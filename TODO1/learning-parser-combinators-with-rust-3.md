> * 原文地址：[Learning Parser Combinators With Rust](https://bodil.lol/parser-combinators/)
> * 原文作者：[Bodil](https://bodil.lol/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/learning-parser-combinators-with-rust-3.md](https://github.com/xitu/gold-miner/blob/master/TODO1/learning-parser-combinators-with-rust-3.md)
> * 译者：[suhanyujie](https://github.com/suhanyujie)

# 通过 Rust 学习解析器组合器 — 第三部分

如果你没看过本系列的其他几篇文章，建议你按照顺序进行阅读：

- [通过 Rust 学习解析器组合器 — 第一部分](https://github.com/xitu/gold-miner/blob/master/TODO1/learning-parser-combinators-with-rust-1.md)
- [通过 Rust 学习解析器组合器 — 第二部分](https://github.com/xitu/gold-miner/blob/master/TODO1/learning-parser-combinators-with-rust-2.md)
- [通过 Rust 学习解析器组合器 — 第三部分](https://github.com/xitu/gold-miner/blob/master/TODO1/learning-parser-combinators-with-rust-3.md)
- [通过 Rust 学习解析器组合器 — 第四部分](https://github.com/xitu/gold-miner/blob/master/TODO1/learning-parser-combinators-with-rust-4.md)

### 判定组合器

现在我们有了构建的代码块，我们需要通过它用 `one_or_more` 解析空格符，并用 `zero_or_more` 解析属性对。

事实上，得等一下。我们并不想先解析空格符**然后**解析属性。如果你考虑到，在没有属性的情况下，空格符也是可选的，并且我们可能会立即遇到 `>` 或 `/>`。但如果有一个属性时，在开头就**一定**会有空格符。幸运的是，每个属性之间也一定会有空格符，如果有多个的话，那么我们看看**零个或者多个**序列，该序列是在属性后跟随**一个或者多个**空格符。

首先，我们需要一个针对单个空格的解析器。这里我们可以从三种方式选择其中一种。

第一，我们可以最简单的使用 `match_literal` 解析器，它带有一个只包含一个空格的字符串。这看起来是不是很傻？因为空格符也相当于是换行符、制表符和许多奇怪的 Unicode 字符，它们都是以空白的形式呈现的。我们将不得不再次依赖 Rust 的标准库，当然，`char` 有一个 `is_whitespace` 方法，也是类似于它的 `is_alphabetic` 和 `is_alphanumeric` 方法。

第二，我们可以编写一个解析器，它是通过 `is_whitespace` 来判定解析任意数量的空格，就像我们前面写到的 `identifier` 一样。

第三，我们可以更明智一点，我们确实喜欢更明智的做法。我们可以编写一个解析器 `any_char`，它返回一个单独的 `char`，只要输入中还有空格符，接着编写一个 `pred` 组合器，它接受一个解析器和一个判定函数，并将它们像这样组合起来：`pred(any_char, |c| c.is_whitespace())`。这样做会有一个好处，它使我们最终的解析器的编写变得更简单：属性值使用引用字符串。

`any_char` 可以看做是一个非常简单的解析器，但我们必须记住小心那些 UTF-8 陷阱。

```
fn any_char(input: &str) -> ParseResult<char> {
    match input.chars().next() {
        Some(next) => Ok((&input[next.len_utf8()..], next)),
        _ => Err(input),
    }
}
```

对于现在我们富有经验的眼睛来说，`pred` 组合器没有给我们带来惊喜。我们调用解析器，然后在解析器执行成功时再对返回值调用判定函数，只有当该函数返回 true 时，我们才真正返回成功，否则就会返回跟解析失败一样多的错误。

```
fn pred<'a, P, A, F>(parser: P, predicate: F) -> impl Parser<'a, A>
where
    P: Parser<'a, A>,
    F: Fn(&A) -> bool,
{
    move |input| {
        if let Ok((next_input, value)) = parser.parse(input) {
            if predicate(&value) {
                return Ok((next_input, value));
            }
        }
        Err(input)
    }
}
```

快速地写一个测试用例来确保一切是有序进行的：

```
#[test]
fn predicate_combinator() {
    let parser = pred(any_char, |c| *c == 'o');
    assert_eq!(Ok(("mg", 'o')), parser.parse("omg"));
    assert_eq!(Err("lol"), parser.parse("lol"));
}
```

针对这两个地方，我们可以用一个快速的一行代码来编写我们的 `whitespace_char` 解析器：

```
fn whitespace_char<'a>() -> impl Parser<'a, char> {
    pred(any_char, |c| c.is_whitespace())
}
```

现在，我们有了 `whitespace_char`，我们所做的离我们的想法更近了，**一个或多个空格**，以及类似的想法，**零个或者多个空格**。我们将其简化一下，分别将它们命名为 `space1` 和 `space0`。

```
fn space1<'a>() -> impl Parser<'a, Vec<char>> {
    one_or_more(whitespace_char())
}

fn space0<'a>() -> impl Parser<'a, Vec<char>> {
    zero_or_more(whitespace_char())
}
```

### 字符串引用

完成这些工作后，终于我们现在可以解析这些属性了吗？是的，我们只需要确保为属性组件编写好了单独的解析器。我们已经得到了属性名的 `identifier`（尽管很容易使用 `any_char` 和 `pred` 加上 `*_or_more` 组合器重写它）。`=` 也即 `match_literal("=")`。不过，我们只需要字符串解析器的引用，所以我们要构建它。幸运的是，我们已经实现了我们所需要的组合器。

```
fn quoted_string<'a>() -> impl Parser<'a, String> {
    map(
        right(
            match_literal("\""),
            left(
                zero_or_more(pred(any_char, |c| *c != '"')),
                match_literal("\""),
            ),
        ),
        |chars| chars.into_iter().collect(),
    )
}
```

在这里，组合器的嵌套有点烦人，但我们暂时不打算重构它，而是将重点放在接下来要做的东西上。

最外层的组合器是一个 `map`，因为之前提到嵌套很烦人，从这里开始会变得糟糕并且我们要忍受并理解这一点，我们试着找到开始执行的地方：第一个引号字符。在 `map` 中，有一个 `right`，而 `right` 的第一部分是我们要查找的：`match_literal("\"")`。以上就是我们一开始要着手处理的东西。

`right` 的第二部分是字符串剩余部分的处理。它位于 `left` 的内部，我们会很快的注意到**右侧**的 `left` 参数，是我们要忽略的，也就是另一个 `match_literal("\"")` —— 结束的引号。所以左侧参数是我们引用的字符串。

我们利用新的 `pred` 和 `any_char` 在这里得到一个解析器，它接收**任何字符除了另一个引号**，我们把它放进 `zero_or_more`，所以我们讲的也是以下这些：

* 一个引号
* 随后是零个或多个**除了**结束引号以外的字符
* 随后是结束引号

并且，在 `right` 和 `left` 之间，我们会在结果值中丢弃引号，并且得到引号之间的字符串。

等等，那不是字符串。还记得 `zero_or_more` 返回的是什么吗？一个类型为 `Vec<A>` 的值，其中类型为 `A` 的值是由内部解析器返回的。对于 `any_char`，返回的是 `char` 类型。那么我们得到的不是一个字符串，而是一个类型为 `Vec<char>` 的值。这是 `map` 所处的位置：我们使用它把 `Vec<char>` 转换为 `String`，基于这样一个情况，你可以构建一个产生 `String` 的迭代器 `Iterator<Item = char>`，我们称之为 `vec_of_chars.into_iter().collect()`，多亏了类型推导的力量，我们才有了 `String`。

在我们继续之前，我们先写一个快速的测试用例来确保它是正确的，因为如果我们需要这么多词来解释它，那么它可能不是我们作为程序员应该相信的东西。

```
#[test]
fn quoted_string_parser() {
    assert_eq!(
        Ok(("", "Hello Joe!".to_string())),
        quoted_string().parse("\"Hello Joe!\"")
    );
}
```

现在，我发誓，真的是要解析这些属性了。

### 最后，解析属性

我们现在可以解析空格符、标识符，`=` 符号和带引号的字符串。最后，这就是解析属性所需的全部内容。

首先，我们为属性对写解析器。我们将会把属性作为 `Vec<(String, String)>` 存储，你可能还记得这个类型，所以感觉可能需要一个针对 `(String, String)` 的解析器，将其提供给我们可靠的 `zero_or_more` 组合器。我们看看能否造一个。

```
fn attribute_pair<'a>() -> impl Parser<'a, (String, String)> {
    pair(identifier, right(match_literal("="), quoted_string()))
}
```

太轻松了，汗都没出一滴！总结一下：我们已经有一个便利的组合器用于解析元组的值，也就是 `pair`，我们可以将其作为 `identifier` 解析器，迭代出一个 `String`，以及一个带有 `=` 的 `right` 解析器，它的返回值我们不想保存，并且我们刚写出来的 `quoted_string` 解析器会返回给我们 `String` 类型的值。

现在，我们结合一下 `zero_or_more`，去构建一个 vector —— 但不要忘了它们之间的空格符。

```
fn attributes<'a>() -> impl Parser<'a, Vec<(String, String)>> {
    zero_or_more(right(space1(), attribute_pair()))
}
```

以下情况会出现零次或者多次：一个或者多个空白符，其后是一个属性对。我们通过 `right` 丢弃空白符并保留属性对。

我们测试一下它。

```
#[test]
fn attribute_parser() {
    assert_eq!(
        Ok((
            "",
            vec![
                ("one".to_string(), "1".to_string()),
                ("two".to_string(), "2".to_string())
            ]
        )),
        attributes().parse(" one=\"1\" two=\"2\"")
    );
}
```

测试是通过的！先别高兴太早！

实际上，有些问题，在这个情况中，我的 rustc 编译器已经给出提示信息表示我的类型过于复杂，我需要增加可允许的类型范围才能让编译继续。鉴于我们在同一点上遇到了类似的错误，这是有利的，如果你是这种情况，你需要知道如何处理它。幸运的是，在这些情况下，rustc 通常会给出好的建议，所以当它告诉你在文件顶部添加 `#![type_length_limit = "…some big number…"]` 注解时，照做就行了。在实际情况中，就是添加 `#![type_length_limit = "16777216"]`，这将使我们更进一步深入到复杂类型的平流层。全速前进，我们就要上天了。

### 现在离答案很近了

在这一点上，这些东西看起来即将要组合到一起了，有些解脱了，因为我们的类型正快速接近于 NP 完全性理论。我们只需要处理两种元素标签：单个元素以及带有子元素的父元素，但我们非常有信心，一旦我们有了这些，解析子元素就只需要使用 `zero_or_more`，是吗？

那么接下来我们先处理单元素的情况，把子元素的问题放一放。或者，更进一步，我们先基于这两种元素的共性写一个解析器：开头的 `<`，元素名称，然后是属性。让我们看看能否从几个组合器中获取到 `(String, Vec<(String, String)>)` 类型的结果。

```
fn element_start<'a>() -> impl Parser<'a, (String, Vec<(String, String)>)> {
    right(match_literal("<"), pair(identifier, attributes()))
}
```

有了这些，我们就可以快速的写出代码，从而为单元素创建一个解析器。

```
fn single_element<'a>() -> impl Parser<'a, Element> {
    map(
        left(element_start(), match_literal("/>")),
        |(name, attributes)| Element {
            name,
            attributes,
            children: vec![],
        },
    )
}
```

万岁，感觉我们已经接近我们的目标了 —— 实际上我们正在构建一个 `Element`！

让我们测试一下现代科技的奇迹。

```
#[test]
fn single_element_parser() {
    assert_eq!(
        Ok((
            "",
            Element {
                name: "div".to_string(),
                attributes: vec![("class".to_string(), "float".to_string())],
                children: vec![]
            }
        )),
        single_element().parse("<div class=\"float\"/>")
    );
}
```

…… 我想我们已经逃离出平流层了。

`single_element` 返回的类型是如此的复杂，以至于编译器不能顺利的完成编译，除非我们提前给出足够大内存空间的类型，甚至要求更大的类型。很明显，我们不能再忽略这个问题了，因为它是一个非常简单的解析器，却需要数分钟的编译时间 —— 这会导致最终的产品可能需要数小时来编译 —— 这似乎有些不合理。

在继续之前，你最好将这两个函数和测试用例注释掉，便于我们进行修复……

### 处理无限大的问题

如果你曾经尝试过在 Rust 中编写递归类型的东西，那么你可能已经知道这个问题的解决方案。

关于递归类型的一个简单例子就是单链表。原则上，你可以把它写成类似于这样的枚举形式：

```
enum List<A> {
    Cons(A, List<A>),
    Nil,
}
```

很明显，rustc 编译器会对递归类型 `List<A>` 给出报错信息，提示它具有无限的大小，因为在每个 `List::<A>::Cons` 内部都可能有另一个 `List<A>`，这意味着 `List<A>` 可以一直直到无穷大。就 rustc 编译器而言，我们需要一个无限列表，并且要求它能**分配**一个无限列表。

在许多语言中，对于类型系统来说，一个无限列表原则上不是问题，而且对 Rust 来说也不是什么问题。问题是，前面提到的，在 Rust 中，我们需要能够**分配**它，或者，更确切的说，我们需要能够在构造类型时先确定类型的**大小**，当类型是无限的时候，这意味着大小也必须是无限的。

解决办法是采用间接的方法。我们不是将 `List::Cons` 改为 `A` 的一个元素和另一个 `A` 的**列表**，反而是使用一个 `A` 元素和一个指向 `A` 列表的**指针**。我们已知指针的大小，不管它指向什么，它都是相同的大小，所以我们的 `List::Cons` 现在是一个固定大小的并且可预测的，不管列表的大小如何。把一个已有的数据变成将数据存储于堆上，并且用指针指向该堆内存的方法，在 Rust 中，就是使用 `Box` 处理它。

```
enum List<A> {
    Cons(A, Box<List<A>>),
    Nil,
}
```

`Box` 的另一个有趣特性是，其中的类型是可以抽象的。这意味着，我们可以让类型检查器处理一个非常简洁的 `Box<dyn Parser<'a, A>>`，而不是处理当前的非常复杂的解析器函数类型。

听起来很不错。有什么缺陷吗？好吧，我们可能会因为使用指针的方式而损失一两次循环，也可能会让编译器失去一些优化解析器的机会。但是想起 Knuth 的关于过早优化的提醒：一切都会好起来的。损失这些循环是值得的。你在这里是学习关于解析器组合器，而不是学习手工编写专业的 [SIMD 解析器](https://github.com/lemire/simdjson)（尽管它们本身会令人兴奋）

因此，抛开目前我们使用的简单函数，让我们继续基于**即将要完成**的解析器函数来实现 `Parser`。

```
struct BoxedParser<'a, Output> {
    parser: Box<dyn Parser<'a, Output> + 'a>,
}

impl<'a, Output> BoxedParser<'a, Output> {
    fn new<P>(parser: P) -> Self
    where
        P: Parser<'a, Output> + 'a,
    {
        BoxedParser {
            parser: Box::new(parser),
        }
    }
}

impl<'a, Output> Parser<'a, Output> for BoxedParser<'a, Output> {
    fn parse(&self, input: &'a str) -> ParseResult<'a, Output> {
        self.parser.parse(input)
    }
}
```

为了更好地实现，我们创建了一个新的类型 `BoxedParser` 用于保存 Box 相关的数据。我们利用其它的解析器（包括另一个 `BoxedParser`，虽然这没太大作用）来创建新的 `BoxedParser`，我们提供一个新的函数 `BoxedParser::new(parser)`，它只是将解析器放在新类型的 `Box` 中。最后，我们为它实现 `Parser`，这样，它就可以作为解析器交换着使用。

这使我们具备将解析器放入一个 `Box` 中的能力，而 `BoxedParser` 将会以函数的角色为 `Parser` 执行一些逻辑。正如前面提到的，这意味着将 Box 包装的解析器移到堆中，并且必须删除指向该堆区域的指针，这可能会多花费**几纳秒**的时间，所以实际上我们可能想先不用 Box 包装**所有数据**。只是把一些更活跃的组合器数据通过 Box 包装就够了。

- [通过 Rust 学习解析器组合器 — 第一部分](https://github.com/xitu/gold-miner/blob/master/TODO1/learning-parser-combinators-with-rust-1.md)
- [通过 Rust 学习解析器组合器 — 第二部分](https://github.com/xitu/gold-miner/blob/master/TODO1/learning-parser-combinators-with-rust-2.md)
- [通过 Rust 学习解析器组合器 — 第三部分](https://github.com/xitu/gold-miner/blob/master/TODO1/learning-parser-combinators-with-rust-3.md)
- [通过 Rust 学习解析器组合器 — 第四部分](https://github.com/xitu/gold-miner/blob/master/TODO1/learning-parser-combinators-with-rust-4.md)

## 许可证

本作品版权归 Bodil Stokke 所有，在知识共享署名-非商业性-相同方式共享 4.0 协议之条款下提供授权许可。要查看此许可证，请访问 http://creativecommons.org/licenses/by-nc-sa/4.0/。

## 脚注

1: 他不是你真正的叔叔
2: 请不要成为聚会上的那个人。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
