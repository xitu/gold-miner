> * 原文地址：[Learning Parser Combinators With Rust](https://bodil.lol/parser-combinators/)
> * 原文作者：[Bodil](https://bodil.lol/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/learning-parser-combinators-with-rust-3.md](https://github.com/xitu/gold-miner/blob/master/TODO1/learning-parser-combinators-with-rust-3.md)
> * 译者：
> * 校对者：

# 通过 Rust 学习解析器组合器 - 第三部分

如果你没看过本系列的其他几篇文章，建议你按照顺序进行阅读：

- [通过 Rust 学习解析器组合器 - 第一部分](https://github.com/xitu/gold-miner/blob/master/TODO1/learning-parser-combinators-with-rust-1.md)
- [通过 Rust 学习解析器组合器 - 第二部分](https://github.com/xitu/gold-miner/blob/master/TODO1/learning-parser-combinators-with-rust-2.md)
- [通过 Rust 学习解析器组合器 - 第三部分](https://github.com/xitu/gold-miner/blob/master/TODO1/learning-parser-combinators-with-rust-3.md)
- [通过 Rust 学习解析器组合器 - 第四部分](https://github.com/xitu/gold-miner/blob/master/TODO1/learning-parser-combinators-with-rust-4.md)

### A Predicate Combinator

We now have the building blocks we need to parse that whitespace with `one_or_more`, and to parse the attribute pairs with `zero_or_more`.
现在我们有了构建的代码块，我们需要通过它用 `one_or_more` 解析空格符，并且用 `zero_or_more` 解析属性对。

Actually, hold on a moment. We don't really want to parse the whitespace **then** parse the attributes. If you think about it, if there are no attributes, the whitespace is optional, and we could encounter an immediate `>` or `/>`. But if there's an attribute, there **must** be whitespace first. Lucky for us, there must also be whitespace between each attribute, if there are several, so what we're really looking at here is a sequence of **zero or more** occurrences of **one or more** whitespace items followed by the attribute.
事实上，得等一下。我们并不想先解析空格符**然后**解析属性。如果你考虑到，在没有属性的情况下，空格符也是可选的，并且我们可以会立即遇到 `>` 或  `/>`。但如果有一个属性时，我们就**必须**先解析空格符。幸运的是，每个属性之间一定会有空格，如果有多个空格的话，那么我们将会看到**零个或者多个**序列还有**一个或者多个**空格符出现在属性后。

首先，我们需要一个针对单个空格的解析器。这里我们可以从三种方式选择其中一种。

第一，我们可以最简单的使用 `match_literal` 解析器，它带有一个只包含一个空格的字符串。这看起来是不是很傻？因为空格符也相当于是换行符、制表符和许多奇怪的 Unicode 字符，它们都是以空白的形式呈现的。我们将不得不再次依赖 Rust 的标准库，当然，`char` 有一个 `is_whitespace` 方法，也是类似于它的 `is_alphabetic` 和 `is_alphanumeric` 方法。

第二，我们可以编写一个解析器，它是通过 `is_whitespace` 谓词解析任意数量的空格，就像我们前面写到的 `identifier` 一样。

第三，我们可以更明智一点，我们确实喜欢更明智。我们可以编写一个解析器 `any_char`，它返回一个单独的 `char`，只要输入中还有空格符，接着编写一个 `pred` 组合器，它接受一个解析器和一个判定，并将它们像这样组合起来：`pred(any_char, |c| c.is_whitespace())`。这样做会有一个好处，它使我们最终的解析器的编写变得更简单：属性值使用引用字符串。

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

现在，我们有了 `whitespace_char`，我们所做的更加接近我们的想法了，**一个或中多个空格**，以及类似的想法，**零个或者多个空格**。我们将其简化一下，分别将它们命名为 `space1` 和 `space0`。

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

The outermost combinator is a `map`, because of the aforementioned annoying nesting, and it's a terrible place to start if we're going to understand this one, so let's try and find where it really starts: the first quote character. Inside the `map`, there's a `right`, and the first part of the `right` is the one we're looking for: the `match_literal("\"")`. That's our opening quote.
最外层的组合器是一个 `map`，因为之前提到嵌套很烦人，从这里开始会变得糟糕并且我们要忍受并理解这一点，我们试着找到开始执行的地方：第一个引号字符。在 `map` 中，有一个 `right`，而 `right` 的第一部分是我们要查找的：`match_literal("\"")`。以上就是我们一开始要着手处理的东西。

`right` 的第二部分是字符串剩余部分的处理。它位于 `left` 的内部，我们会很快的注意到**右侧**的 `left` 参数，是我们要忽略的，也就是另一个 `match_literal("\"")`  —— 结束的引号。所以左侧参数是我们引用的字符串。

We take advantage of our new `pred` and `any_char` here to get a parser that accepts **anything but another quote**, and we put that in `zero_or_more`, so that what we're saying is as follows:
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

太轻松了，汗都没出一滴！总结一下：我们已经有一个便利的组合器用于解析元组的值，也就是 `pair`，我们可以将其作为 `identifier` 解析器，迭代出一个 `String`， 以及一个带有 `=` 的 `right` 解析器，它的返回值我们不想保存，并且我们刚写出来的 `quoted_string` 解析器会返回给我们 `String` 类型的值。

Now, let's combine that with `zero_or_more` to build that vector - but let's not forget that whitespace in between them.
现在，我们结合一下 `zero_or_more`，去构建一下 vector —— 但不要忘了它们之间的空格符。

```
fn attributes<'a>() -> impl Parser<'a, Vec<(String, String)>> {
    zero_or_more(right(space1(), attribute_pair()))
}
```

以下情况会出现零次或者多次：一个或者多个空白符，其后是一个属性对。我们通过 `right` 丢弃空白符病保留属性对。

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

Tests are green! Ship it!
测试是通过的！先别高兴太早！

实际上，有些问题，在这个情况中，我的 rustc 已经给出提示信息表示我的类型过于复杂，我需要增加可允许的类型范围才能让编译继续。鉴于在同一点上遇到了相同的错误是有利的，如果你是这种情况，你需要知道如何处理它。幸运的是，在这些情况下，rustc 通常会给出好的建议，所以当它告诉你在文件顶部添加 `#![type_length_limit = "…some big number…"]` 注解时，照做就行了。在实际情况中，就是添加 `#![type_length_limit = "16777216"]`，这将使我们更进一步深入到复杂类型的平流层。全速前进，我们就要上天了。

### So Close Now

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

…and I think we just ran out of stratosphere.

The return type of `single_element` is so complicated that the compiler will grind away for a very long time until it runs into the very large type size limit we gave it earlier, asking for an even larger one. It's clear we can no longer ignore this problem, as it's a rather trivial parser and a compilation time of several minutes - maybe even several hours for the finished product - seems mildly unreasonsable.

Before proceeding, you'd better comment out those two functions and tests while we fix things…

### To Infinity And Beyond

If you've ever tried writing a recursive type in Rust, you might already know the solution to our little problem.

A very simple example of a recursive type is a singly linked list. You can express it, in principle, as an enum like this:

```
enum List<A> {
    Cons(A, List<A>),
    Nil,
}
```

To which rustc will, very sensibly, object that your recursive type `List<A>` has an infinite size, because inside every `List::<A>::Cons` is another `List<A>`, and that means it's `List<A>`s all the way down into infinity. As far as rustc is concerned, we're asking for an infinite list, and we're asking it to be able to **allocate** an infinite list.

In many languages, an infinite list isn't a problem in principle for the type system, and it's actually not for Rust either. The problem is that in Rust, as mentioned, we need to be able to **allocate** it, or, rather, we need to be able to determine the **size** of a type up front when we construct it, and when the type is infinite, that means the size must be infinite too.

The solution is to employ a bit of indirection. Instead of our `List::Cons` being an element of `A` and another **list** of `A`, instead we make it an element of `A` and a **pointer** to a list of `A`. We know the size of a pointer, and it's the same no matter what it points to, and so our `List::Cons` now has a fixed and predictable size no matter the size of the list. And the way to turn an owned thing into a pointer to an owned thing on the heap, in Rust, is to `Box` it.

```
enum List<A> {
    Cons(A, Box<List<A>>),
    Nil,
}
```

Another interesting feature of `Box` is that the type inside it can be abstract. This means that instead of our by now incredibly complicated parser function types, we can let the type checker deal with a very succinct `Box<dyn Parser<'a, A>>` instead.

That sounds great. What's the downside? Well, we might be losing a cycle or two to having to follow that pointer, and it could be that the compiler loses some opportunities to optimise our parser. But recall Knuth's admonition about premature optimisation: it's going to be fine. You can afford those cycles. You're here to learn about parser combinators, not to learn about hand written hyperspecialised [SIMD parsers](https://github.com/lemire/simdjson) (although they're exciting in their own right).

So let's proceed to implement `Parser` for a **boxed** parser function in addition to the bare functions we've been using so far.

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

We create a new type `BoxedParser` to hold our box, for the sake of propriety. To create a new `BoxedParser` from any other kind of parser (including another `BoxedParser`, even if that would be pointless), we provide a function `BoxedParser::new(parser)` which does nothing more than put that parser in a `Box` inside our new type. Finally, we implement `Parser` for it, so that it can be used interchangeably as a parser.

This leaves us with the ability to put a parser function in a `Box`, and the `BoxedParser` will work as a `Parser` just as well as the function. Now, as previously mentioned, that means moving the boxed parser to the heap and having to deref a pointer to get to it, which can cost us **several precious nanoseconds**, so we might actually want to hold off on boxing **everything**. It's enough to just box some of the more popular combinators.

- [Learning Parser Combinators With Rust - Part 1](https://github.com/xitu/gold-miner/blob/master/TODO1/learning-parser-combinators-with-rust-1.md)
- [Learning Parser Combinators With Rust - Part 2](https://github.com/xitu/gold-miner/blob/master/TODO1/learning-parser-combinators-with-rust-2.md)
- [Learning Parser Combinators With Rust - Part 3](https://github.com/xitu/gold-miner/blob/master/TODO1/learning-parser-combinators-with-rust-3.md)
- [Learning Parser Combinators With Rust - Part 4](https://github.com/xitu/gold-miner/blob/master/TODO1/learning-parser-combinators-with-rust-4.md)

## Licence

This work is copyright Bodil Stokke and is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International Licence. To view a copy of this licence, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.

## Footnotes

1: He isn't really your uncle.
2: Please don't be that person at parties.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
