> * 原文地址：[Learning Parser Combinators With Rust](https://bodil.lol/parser-combinators/)
> * 原文作者：[Bodil](https://bodil.lol/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/learning-parser-combinators-with-rust-2.md](https://github.com/xitu/gold-miner/blob/master/TODO1/learning-parser-combinators-with-rust-2.md)
> * 译者：
> * 校对者：

# 通过 Rust 学习解析器组合器 - 第二部分

如果你没看过本系列的其他几篇文章，建议你按照顺序进行阅读：

- [通过 Rust 学习解析器组合器 - 第一部分](https://github.com/xitu/gold-miner/blob/master/TODO1/learning-parser-combinators-with-rust-1.md)
- [通过 Rust 学习解析器组合器 - 第二部分](https://github.com/xitu/gold-miner/blob/master/TODO1/learning-parser-combinators-with-rust-2.md)
- [通过 Rust 学习解析器组合器 - 第三部分](https://github.com/xitu/gold-miner/blob/master/TODO1/learning-parser-combinators-with-rust-3.md)
- [通过 Rust 学习解析器组合器 - 第四部分](https://github.com/xitu/gold-miner/blob/master/TODO1/learning-parser-combinators-with-rust-4.md)

### 进入 Functor

但在我们深入之前，让我们介绍另一个组合器，它的作用是将使这两个的解析器的编写变得更简单：`map` 。

这2个组合只有一个目的：更改结果的类型。比如你有一个返回 `((), String)` 的解析器，你希望将它改成只返回 `String`，随便一个场景都可能如此。

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

这个类型说明了什么？`P` 是我们的解析器。它在成功时返回 `A`。`F` 是我们用来将 `P` 映射返回值的函数，它看起来和 `P` 一样，只不过它的结果类型是 `B` 而不是 `A`。

在代码中，我们运行 `parser(input)`，如果它成功，我们得到 `result` 并在其上调用函数 `map_fn(result)` ，将 `A` 转换为 `B`，这就是转换后解析器要执行的逻辑。

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

这种模式在 Haskell 及其数学范畴理论中被称为“函子”。如果你有一个 `A` 类型，并且你还有一个可用的 `map` 函数，这样你就可以把一个函数从 `A` 传到 `B` 中，把它变成同一类型的东西，那么它就叫做“函子”。你可以在 Rust 中看到很多这样的地方，比如 [`Option`](https://doc.rust-lang.org/std/option/enum.Option.html#method.map)，[`Result`](https://doc.rust-lang.org/std/result/enum.Result.html#method.map)，[`Iterator`](https://doc.rust-lang.org/std/iter/trait.Iterator.html#method.map) 甚至 [`Future`](https://docs.rs/futures/0.1.26/futures/future/trait.Future.html#method.map) 中，都没有显示的将其这样命名。之所以这样，有一个原因：在 Rust 类型系统中，你真不能认为一个 `functor` 是普遍存在的，因为它缺乏更上层的类型，但这是另一个话题了，所以回到原先的主题，记住这些 functor ，并且你只要寻找映射它的 `map` 函数。

### 轮到 Trait

你可能已经注意到，我们一直在重复解析器的类型签名：`Fn(&str) -> Result<(&str, Output), &str>`，你可能已经厌倦了像这样阅读它并把它写出来，所以我认为现在是时候介绍 trait 了，让代码更加可读，并有利于我们对解析器进行扩展。

但首先 ，让我们为一直在使用的返回值类型创建一个别名：

```
type ParseResult<'a, Output> = Result<(&'a str, Output), &'a str>;
```

所以现在，我们可以输入 `ParseResult<String>` 这样的东西，而不是之前的那个乱七八糟的东西。我们在其中添加了一个生命周期，因为类型声明需要它，但是很多时候， Rust 编译器应该能够为你推断出来。作为一个规范，尝试着把生命周期去掉，看看 rustc 是否会报异常，如果异常，再把生命周期放回去。

在本例中，生命周期 `'a`，由 **输入** 的参数的声明周期决定。

现在，谈论 trait。我们还需要在这里输入生命周期，当你使用 trait 时，通常需要生命周期。这是一段额外的输入，但它的发行版语法就是这样子。

```
trait Parser<'a, Output> {
    fn parse(&self, input: &'a str) -> ParseResult<'a, Output>;
}
```

目前，它只有一个方法 `parse()` 方法，很熟悉吧：它和我们编写的解析器函数一样。

为了更简单一点，我们可以为任何匹配解析器签名的函数实现这个 trait 。

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

这样，我们不仅可以传递相同的函数，这个函数其实就是到目前为止完整地实现了 `Parser` trait 的解析器，还增加了用其它类型作为解析器的可能性。

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

尤其是这里要注意一件事：不直接将解析器作为一个函数调用，我们现在必须这样调用 `parser.parse(input)` ，因为我们不知道类型 `P` 是一个函数类型，我们只知道它实现了 `Parser`，所以我们必须保证好解析器提供的接口。另外的，函数看起来也大体一样，而类型看起来也是整洁的。对于另外一点，产生了一个新的生命周期 `'a'`，但总的来说，这已经改善很多了。

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

这里也是一样，唯一的改变就是整理了的类型签名，并且需要使用 `parser.parse(input)` 而非 `parser(input)` 。

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

`Result` 中的 `and_then` 方法和 `map` 是类似的，只要映射的函数不将返回的新值放入 `Result` 中，而是返回一个全新的 `Result`。上面代码实际上和前面版本中使用的 `match` 代码块一样。我们稍后回到 `and_then`，但现在，我们有了那些实现了 `left` 和 `right` 的组合器，这样我们就有了一个很棒并且很简洁的 `map`。

### Left 和 Right

有了 `pair` 和 `map`，我们就可以简单地编写 `left` 和 `right`。

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

我们使用 `pair` 组合器将两个解析器组合到一个会产生元组结果的解析器中，然后我们使用 `map` 组合器进行选择我们想要保留的元组。

重写解析前两部分元素标签的测试用例，现在更简洁了，在这个过程中，我们获得了一些重要的新解析器组合器的功能。

不过，我们必须先更新两个解析器，来使用 `Parser` 和 `ParseResult`。而 `match_literal` 则会更加复杂：

```
fn match_literal<'a>(expected: &'static str) -> impl Parser<'a, ()> {
    move |input: &'a str| match input.get(0..expected.len()) {
        Some(next) if next == expected => Ok((&input[expected.len()..], ())),
        _ => Err(input),
    }
}
```

In addition to changing the return type, we also have to make sure the input type on the closure is `&'a str`, or rustc gets upset.

For `identifier`, just change the return type and you're done, inference takes care of the lifetimes for you:

```
fn identifier(input: &str) -> ParseResult<String> {
```

And now the test, satisfyingly absent that ungainly `()` in the result.

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

### One Or More

Let's continue parsing that element tag. We've got the opening `<`, and we've got the identifier. What's next? That should be our first attribute pair.

No, actually, those attributes are optional. We're going to have to find a way to deal with things being optional.

No, wait, hold on, there's actually something we have to deal with even **before** we get as far as the first optional attribute pair: whitespace.

Between the end of the element name and the start of the first attribute name (if there is one), there's a space. We need to deal with that space.

It's even worse than that - we need to deal with **one or more spaces**, because `<element      attribute="value"/>` is valid syntax too, even if it's a bit over the top with the spaces. So this seems to be a good time to think about whether we could write a combinator that expresses the idea of **one or more** parsers.

We've dealt with this already in our `identifier` parser, but it was all done manually there. Not surprisingly, the code for the general idea isn't all that different.

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

First of all, the return type of the parser we're building from is `A`, and the return type of the combined parser is `Vec<A>` - any number of `A`s.

The code does indeed look very similar to `identifier`. First, we parse the first element, and if it's not there, we return with an error. Then we parse as many more elements as we can, until the parser fails, at which point we return the vector with the elements we collected.

Looking at that code, how easy would it be to adapt it to the idea of **zero** or more? We just need to remove that first run of the parser:

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

Let's write some tests to make sure those two work.

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

Note the difference between the two: for `one_or_more`, finding an empty string is an error, because it needs to see at least one case of its sub-parser, but for `zero_or_more`, an empty string just means the zero case, which is not an error.

At this point, it's reasonable to start thinking about ways to generalise these two, because one is an exact copy of the other with just one bit removed. It might be tempting to express `one_or_more` in terms of `zero_or_more` with something like this:

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

Here, we run into Rust Problems, and I don't even mean the problem of not having a `cons` method for `Vec`, but I know every Lisp programmer reading that bit of code was thinking it. No, it's worse than that: it's ownership.

We own that parser, so we can't go passing it as an argument twice, the compiler will start shouting at you that you're trying to move an already moved value. So can we make our combinators take references instead? No, it turns out, not without running into another whole set of borrow checker troubles - and we're not going to even go there right now. And because these parsers are functions, they don't do anything so straightforward as to implement `Clone`, which would have saved the day very tidily, so we're stuck with a constraint that we can't repeat our parsers easily in combinators.

That isn't necessarily a **big** problem, though. It means we can't express `one_or_more` using combinators, but it turns out those two are usually the only combinators you need anyway which tend to reuse parsers, and, if you wanted to get really fancy, you could write a combinator that takes a `RangeBound` in addition to a parser and repeats it according to a range: `range(0..)` for `zero_or_more`, `range(1..)` for `one_or_more`, `range(5..=6)` for exactly five or six, wherever your heart takes you.

Let's leave that as an exercise for the reader, though. Right now, we're going to be perfectly fine with just `zero_or_more` and `one_or_more`.

Another exercise might be to find a way around those ownership issues - maybe by wrapping a parser in an `Rc` to make it clonable?

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
