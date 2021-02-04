> * 原文地址：[Learning Parser Combinators With Rust](https://bodil.lol/parser-combinators/)
> * 原文作者：[Bodil](https://bodil.lol/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/learning-parser-combinators-with-rust-2.md](https://github.com/xitu/gold-miner/blob/master/TODO1/learning-parser-combinators-with-rust-2.md)
> * 译者：[suhanyujie](https://github.com/suhanyujie)
> * 校对者：[twang1727](https://github.com/twang1727)

# 通过 Rust 学习解析器组合器 — 第二部分

如果你没看过本系列的其他几篇文章，建议你按照顺序进行阅读：

- [通过 Rust 学习解析器组合器 — 第一部分](https://github.com/xitu/gold-miner/blob/master/TODO1/learning-parser-combinators-with-rust-1.md)
- [通过 Rust 学习解析器组合器 — 第二部分](https://github.com/xitu/gold-miner/blob/master/TODO1/learning-parser-combinators-with-rust-2.md)
- [通过 Rust 学习解析器组合器 — 第三部分](https://github.com/xitu/gold-miner/blob/master/TODO1/learning-parser-combinators-with-rust-3.md)
- [通过 Rust 学习解析器组合器 — 第四部分](https://github.com/xitu/gold-miner/blob/master/TODO1/learning-parser-combinators-with-rust-4.md)

### 开始探究 Functor

但在我们深入之前，让我们介绍另一个组合器，它的作用是使这两个解析器的编写变得简单很多：`map`。

使用这个组合器有一个目的：更改结果的类型。比如你有一个返回 `((), String)` 的解析器，你希望将它改成只返回 `String`，当然，这只是举个例子。

为此，我们传递一个函数，这个函数知道如何将原始类型转换为新的类型。在我们的示例中，这很简单：`|(_left, right)| right`。更一般的说，它看起来类似于这样 `Fn(A) -> B`， 其中的 `A` 是解析器的原始结果类型，B 是新的类型。

```
fn map<P, F, A, B>(parser: P, map_fn: F) -> impl Fn(&str) -> Result<(&str, B), &str>
where
    P: Fn(&str) -> Result<(&str, A), &str>,
    F: Fn(A) -> B,
{
    move |input| match parser(input) {
        Ok((next_input, result)) => Ok((next_input, map_fn(result))),
        Err(err) => Err(err),
    }
}
```

这个类型说明了什么？`P` 是我们的解析器。它在成功时返回 `A`。`F` 是我们用来将 `P` 映射成返回值的函数，它看起来和 `P` 一样，只不过它的结果类型是 `B` 而不是 `A`。

在代码中，我们运行 `parser(input)`，如果它成功执行，我们得到 `result` 并在其上调用函数 `map_fn(result)`，将 `A` 转换为 `B`，这就是转换后解析器要执行的逻辑。

实际上，让我们改变一下，稍微简化这个函数，因为这个 `map` 实际上是一个常见的模式，`Result` 也实现了这个模式：

```
fn map<P, F, A, B>(parser: P, map_fn: F) -> impl Fn(&str) -> Result<(&str, B), &str>
where
    P: Fn(&str) -> Result<(&str, A), &str>,
    F: Fn(A) -> B,
{
    move |input|
        parser(input)
            .map(|(next_input, result)| (next_input, map_fn(result)))
}
```

这种模式在 Haskell 及其对应的数学上的范畴论中被称为“函子”。如果你有一个包含 `A` 类型的东西，并且你还有一个可用的 `map` 函数，这样你就可以把一个函数从 `A` 传到 `B` 中，把它变成包含 `B` 类型的东西，那么它就叫做“函子”。你可以在 Rust 中看到很多这样的地方，比如 [`Option`](https://doc.rust-lang.org/std/option/enum.Option.html#method.map)，[`Result`](https://doc.rust-lang.org/std/result/enum.Result.html#method.map)，[`Iterator`](https://doc.rust-lang.org/std/iter/trait.Iterator.html#method.map) 甚至 [`Future`](https://docs.rs/futures/0.1.26/futures/future/trait.Future.html#method.map) 中，都没有显式的将其这样命名。之所以这样，有一个原因：在 Rust 类型系统中，你没法将 `functor` 这一概念像普通事物一样概括出来，因为它缺乏高阶类型，但这是另一个话题了，所以回到原先的主题，记住这些 functor，并且你只要寻找映射它的 `map` 函数。

### 轮到 Trait

你可能已经注意到，我们一直在重复解析器的类型签名：`Fn(&str) -> Result<(&str, Output), &str>`，你可能已经厌倦了阅读这样完整的书写形式，所以我认为现在是时候介绍 trait 了，让代码更加可读，并有利于我们对解析器进行扩展。

但首先 ，让我们为一直在使用的返回值类型创建一个别名：

```
type ParseResult<'a, Output> = Result<(&'a str, Output), &'a str>;
```

所以现在，我们可以输入 `ParseResult<String>` 这样的东西，而不是之前的那个乱七八糟的东西。我们在其中添加了一个生命周期，因为类型声明需要它，但是很多时候，Rust 编译器应该能够为你推断出来。作为一个规范，尝试着把生命周期去掉，看看 rustc 编译器是否会报异常，如果异常，再把生命周期加回去。

在本例中，生命周期 `'a`，特指**输入**参数的生命周期。

现在，谈论 trait。我们还需要在这里输入生命周期，当你使用 trait 时，通常需要生命周期。它需要多一点代码输入，但生命周期这种特性还是优于之前的版本。

```
trait Parser<'a, Output> {
    fn parse(&self, input: &'a str) -> ParseResult<'a, Output>;
}
```

目前，它只有一个 `parse()` 方法，很熟悉吧：它和我们编写的解析器函数一样。

为了更简单一点，我们可以为任何匹配解析器签名的函数实现这个 trait。

```
impl<'a, F, Output> Parser<'a, Output> for F
where
    F: Fn(&'a str) -> ParseResult<Output>,
{
    fn parse(&self, input: &'a str) -> ParseResult<'a, Output> {
        self(input)
    }
}
```

这样，我们不仅可以传递相同的函数，这个函数其实就是到目前为止完整地实现了 `Parser` trait 的解析器，还增加了用其它类型实现解析器的可能性。

但更重要的是，它使我们无需一直键入那些冗长的函数签名。让我们重写 `map` 函数，并看看它如何工作的。

```
fn map<'a, P, F, A, B>(parser: P, map_fn: F) -> impl Parser<'a, B>
where
    P: Parser<'a, A>,
    F: Fn(A) -> B,
{
    move |input|
        parser.parse(input)
            .map(|(next_input, result)| (next_input, map_fn(result)))
}
```

尤其是这里要注意一件事：不直接将解析器作为一个函数调用，那么我们现在必须这样调用 `parser.parse(input)`，因为我们不知道类型 `P` 是不是一个函数类型，我们只知道它实现了 `Parser`，所以我们必须保证好 `Parser` 提供的接口。另外的，函数看起来也大体一样，而类型看起来也是整洁的。新的生命周期 `'a'` 看着有点乱，但总的来说，这已经改善很多了。

如果我们用同样的方式重写 `pair` 函数，那就更好了。

```
fn pair<'a, P1, P2, R1, R2>(parser1: P1, parser2: P2) -> impl Parser<'a, (R1, R2)>
where
    P1: Parser<'a, R1>,
    P2: Parser<'a, R2>,
{
    move |input| match parser1.parse(input) {
        Ok((next_input, result1)) => match parser2.parse(next_input) {
            Ok((final_input, result2)) => Ok((final_input, (result1, result2))),
            Err(err) => Err(err),
        },
        Err(err) => Err(err),
    }
}
```

这里也是一样，唯一的改变就是整理了的类型签名，并且需要使用 `parser.parse(input)` 而非 `parser(input)`。

实际上，我们也整理一下 `pair` 的函数体，就像我们处理 `map` 一样。

```
fn pair<'a, P1, P2, R1, R2>(parser1: P1, parser2: P2) -> impl Parser<'a, (R1, R2)>
where
    P1: Parser<'a, R1>,
    P2: Parser<'a, R2>,
{
    move |input| {
        parser1.parse(input).and_then(|(next_input, result1)| {
            parser2.parse(next_input)
                .map(|(last_input, result2)| (last_input, (result1, result2)))
        })
    }
}
```

`Result` 中的 `and_then` 方法和 `map` 很类似，只是，映射的函数不将返回的新值放入 `Result` 中，而是返回一个全新的 `Result`。上面代码实际上和前面版本中使用的 `match` 代码块一样。我们稍后回到 `and_then`，但现在，既然我们有了一个好用并且很简洁的 `map`，我们就来实现一下 `left` 和 `right` 组合器。

### Left 和 Right

有了 `pair` 和 `map`，我们就可以简洁地编写 `left` 和 `right`。

```
fn left<'a, P1, P2, R1, R2>(parser1: P1, parser2: P2) -> impl Parser<'a, R1>
where
    P1: Parser<'a, R1>,
    P2: Parser<'a, R2>,
{
    map(pair(parser1, parser2), |(left, _right)| left)
}

fn right<'a, P1, P2, R1, R2>(parser1: P1, parser2: P2) -> impl Parser<'a, R2>
where
    P1: Parser<'a, R1>,
    P2: Parser<'a, R2>,
{
    map(pair(parser1, parser2), |(_left, right)| right)
}
```

我们使用 `pair` 组合器将两个解析器组合到一个会产生元组结果的解析器中，然后我们使用 `map` 组合器选择我们想要保留的元组。

重写解析前两部分元素标签的测试用例，现在更简洁了，在这个过程中，我们获得了一些重要并且新的解析器组合器的功能。

不过，我们必须先更新两个解析器，来使用 `Parser` 和 `ParseResult`。而 `match_literal` 则会更加复杂：

```
fn match_literal<'a>(expected: &'static str) -> impl Parser<'a, ()> {
    move |input: &'a str| match input.get(0..expected.len()) {
        Some(next) if next == expected => Ok((&input[expected.len()..], ())),
        _ => Err(input),
    }
}
```

除了改变返回值类型外，我们还必须确保闭包的输入参数类型是 `&'a str`，否则编译器可能会报错。

对于 `identifier`，只需要更改返回类型，就可以了，编译器会帮助你推断出生命周期：

```
fn identifier(input: &str) -> ParseResult<String> {
```

现在测试一下，很不错，返回结果不再是 `()`。

```
#[test]
fn right_combinator() {
    let tag_opener = right(match_literal("<"), identifier);
    assert_eq!(
        Ok(("/>", "my-first-element".to_string())),
        tag_opener.parse("<my-first-element/>")
    );
    assert_eq!(Err("oops"), tag_opener.parse("oops"));
    assert_eq!(Err("!oops"), tag_opener.parse("<!oops"));
}
```

### 一个或多个可选属性的处理

我们继续解析这个元素标签。我们获取了开始的 `<`，并且也获取了标识符。接下来呢？接下来应该是属性。

不，实际上，这些属性是可选的。我们必须找到一个正确处理可选的方法。

等一下，实际上在我们开始处理属性**之前**，先要处理另一种可选的属性：空格。

在元素名称结尾，和第一个属性名的开始部分（如果有属性的话）之间有一个空格。我们需要处理这个空格。

比这更不好的是，我们需要处理**一个甚至更多空格**，因为形如 `<element      attribute="value"/>` 的写法也是合法的，虽然空格多了点。那么，接下来我们要好好考虑我们是否可以编写一个组合器，它可以应对**一个或多个**解析器的场景。

我们已经在 `identifier` 解析器中做过处理，但那是通过手动完成的。一点也不奇怪，这种代码的逻辑和常见思路没什么不同。

```
fn one_or_more<'a, P, A>(parser: P) -> impl Parser<'a, Vec<A>>
where
    P: Parser<'a, A>,
{
    move |mut input| {
        let mut result = Vec::new();

        if let Ok((next_input, first_item)) = parser.parse(input) {
            input = next_input;
            result.push(first_item);
        } else {
            return Err(input);
        }

        while let Ok((next_input, next_item)) = parser.parse(input) {
            input = next_input;
            result.push(next_item);
        }

        Ok((input, result))
    }
}
```

首先，我们正在构建的解析器的返回类型是 `A`，组合解析器的返回类型是 `Vec<A>` —— 任意数量的 `A` 类型集合。

代码看起来确实和处理 `identifier` 的那段很像。首先我们解析第一个元素，如果没有，我们返回一个错误。然后我们解析尽可能多的元素，直到解析器遇到错误，这时我们返回迭代收集到的所有元素也就是数组。

看看这段代码，是不是很容易就能将其调整为符合**0**个或者更多的逻辑？我们只需移除解析器的第一次运行的相关代码：

```
fn zero_or_more<'a, P, A>(parser: P) -> impl Parser<'a, Vec<A>>
where
    P: Parser<'a, A>,
{
    move |mut input| {
        let mut result = Vec::new();

        while let Ok((next_input, next_item)) = parser.parse(input) {
            input = next_input;
            result.push(next_item);
        }

        Ok((input, result))
    }
}
```

我们来编写一些测试来确保这两个方法能正常运行：

```
#[test]
fn one_or_more_combinator() {
    let parser = one_or_more(match_literal("ha"));
    assert_eq!(Ok(("", vec![(), (), ()])), parser.parse("hahaha"));
    assert_eq!(Err("ahah"), parser.parse("ahah"));
    assert_eq!(Err(""), parser.parse(""));
}

#[test]
fn zero_or_more_combinator() {
    let parser = zero_or_more(match_literal("ha"));
    assert_eq!(Ok(("", vec![(), (), ()])), parser.parse("hahaha"));
    assert_eq!(Ok(("ahah", vec![])), parser.parse("ahah"));
    assert_eq!(Ok(("", vec![])), parser.parse(""));
}
```

注意两者之间的区别：对于 `one_or_more`，查找空字符串是一个错误，因为它至少需要考虑到它的子解析器众多情况下的一种情况，但对于 `zero_or_more`，空字符串只表示 0 的情况，这不是错误。

在这一点，考虑一下如何归纳这两种情况是合理而必要的，因为其中一个是另一个的副本，只是去掉了一些东西。如下所示，可能很容易就能用 `zero_or_more` 来表示 `one_or_more`：

```
fn one_or_more<'a, P, A>(parser: P) -> impl Parser<'a, Vec<A>>
where
    P: Parser<'a, A>,
{
    map(pair(parser, zero_or_more(parser)), |(head, mut tail)| {
        tail.insert(0, head);
        tail
    })
}
```

在这里，我们遇到了关于 Rust 的一些问题，我不是说 `Vec` 类型没有 `cons` 方法的问题，但我知道每个 Lisp 程序员在读这段代码时都会想到这个。事实上情况比这还严重：那就是所有权问题。

我们有了这个解析器，但我们不能将一个参数传递两次，编译器会告诉你这行不通：你在试着移除一个已经移除的值。那么，我们能让我们的组合器使用参数的引用吗？不行的，事实证明，因为完整严格的借用检查机制 —— 并且我们不用现在去直面这个问题。因为这些解析器就是一些函数，它们不会直接实现 `Clone`，如果用克隆则会很省事，我们现在遇到困难了，我们不能在组合器中那么轻松的重复使用解析器。

不过这也没什么**大**不了的。尽管，这意味着我们无法使用组合器实现 `one_or_more`，但事实上这两个东西通常是你需要用的组合器，该组合器还需要复用解析器，而且，如果你想变得更具想象力，你可以用 `RangeBound` 编写一个组合器，额外附加一个解析器，然后根据范围重复使用，比如 `zero_or_more` 用 `range(0..)`，对 `one_or_more` 用 `range(1..)`，对五个或六个则用 `range(5..=6)`，总之随意而为。

让我们把它留给读者作为练习。现在，我们只需要处理好 `zero_or_more` 和 `one_or_more`。

另一个练习是，尝试找到一个解决这些所有权问题的方法 —— 通过在 `Rc` 中包装一个解析器使其可被克隆，你觉得这个方式怎么样？

- [通过 Rust 学习解析器组合器 — 第一部分](https://github.com/xitu/gold-miner/blob/master/TODO1/learning-parser-combinators-with-rust-1.md)
- [通过 Rust 学习解析器组合器 — 第二部分](https://github.com/xitu/gold-miner/blob/master/TODO1/learning-parser-combinators-with-rust-2.md)
- [通过 Rust 学习解析器组合器 — 第三部分](https://github.com/xitu/gold-miner/blob/master/TODO1/learning-parser-combinators-with-rust-3.md)
- [通过 Rust 学习解析器组合器 — 第四部分](https://github.com/xitu/gold-miner/blob/master/TODO1/learning-parser-combinators-with-rust-4.md)

## 许可证

本作品版权归 Bodil Stokke 所有，在知识共享署名-非商业性-相同方式共享 4.0 协议之条款下提供授权许可。要查看此许可证，请访问 http://creativecommons.org/licenses/by-nc-sa/4.0/。

## 脚注

1：他不是你真正的叔叔。
2：请不要成为聚会上的那个人。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的**本文永久链接**即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
