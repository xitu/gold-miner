> - 原文地址：[Learning Parser Combinators With Rust](https://bodil.lol/parser-combinators/)
> - 原文作者：[Bodil](https://bodil.lol/)
> - 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> - 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/learning-parser-combinators-with-rust-4.md](https://github.com/xitu/gold-miner/blob/master/TODO1/learning-parser-combinators-with-rust-4.md)
> - 译者：[40m41h42t](https://github.com/40m41h42t)
> - 校对者：[Samuel Jie](https://github.com/suhanyujie)、[司徒公子](https://github.com/stuchilde)

# 通过 Rust 学习解析器组合器 — 第四部分

如果你没看过本系列的其他几篇文章，建议你按照顺序进行阅读：

- [通过 Rust 学习解析器组合器 — 第一部分](https://github.com/xitu/gold-miner/blob/master/TODO1/learning-parser-combinators-with-rust-1.md)
- [通过 Rust 学习解析器组合器 — 第二部分](https://github.com/xitu/gold-miner/blob/master/TODO1/learning-parser-combinators-with-rust-2.md)
- [通过 Rust 学习解析器组合器 — 第三部分](https://github.com/xitu/gold-miner/blob/master/TODO1/learning-parser-combinators-with-rust-3.md)
- [通过 Rust 学习解析器组合器 — 第四部分](https://github.com/xitu/gold-miner/blob/master/TODO1/learning-parser-combinators-with-rust-4.md)

### 一个展现自己的机会

但是，稍等一下，它给我们提供了一个修复另一件可能有点麻烦的问题的机会。

还记得我们最后写的解析器吗？由于我们的组合器是独立的函数，当我们嵌套一些“组合器”时，我们的代码开始变得有些难以理解。回想一下我们的 `quoted_string` 解析器：

```rust
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

如果我们可以在解析器而不是独立函数上创建那些组合器方法，那么可读性会更好。假如我们将组合器声明为 `Parser` trait 方法会怎么样呢？

问题在于，如果我们这样做，我们的返回值就会失去依赖 `impl Trait` 的能力，因为 trait 声明中不允许使用 `impl Trait`。

但现在我们有了 `BoxedParser`。 我们不能声明一个返回 `impl Parser<'a, A>` 的 trait 方法，但我们肯定**可以**声明一个返回 `BoxedParser<'a, A>` 的方法。

最好的情况是我们甚至可以使用默认实现声明这些方法，这样我们就不必为每个实现 `Parser` 的类型重新实现每个组合器。

让我们用 `map` 函数来尝试，通过如下方式扩展我们的 `Parser` trait 解析器：

```rust
trait Parser<'a, Output> {
    fn parse(&self, input: &'a str) -> ParseResult<'a, Output>;

    fn map<F, NewOutput>(self, map_fn: F) -> BoxedParser<'a, NewOutput>
    where
        Self: Sized + 'a,
        Output: 'a,
        NewOutput: 'a,
        F: Fn(Output) -> NewOutput + 'a,
    {
        BoxedParser::new(map(self, map_fn))
    }
}
```

这里有很多 `'a`，但是它们都是必要的。幸运的是，我们仍然可以重新使用旧的组合函数 —— 并且，它有着额外的优势，我们不仅可以获得更好的语法来应用它们，还可以通过自动包装摆脱易引发争议的 `impl Trait` 方式。

现在我们可以稍微改进一下 `quoted_string` 解析器：

```rust
fn quoted_string<'a>() -> impl Parser<'a, String> {
    right(
        match_literal("\""),
        left(
            zero_or_more(pred(any_char, |c| *c != '"')),
            match_literal("\""),
        ),
    )
    .map(|chars| chars.into_iter().collect())
}
```

乍一看，很明显 `.map()` 会被 `right()` 的结果调用 。

我们也可以给 `pair`、`left` 和 `right` 做同样的处理，但是在有这三个的情况下，我认为当它们是函数时会有更好的可读性，因为它们反映了 `pair` 输出的结构类型。如果你不同意的话，完全可以将它们添加到 trait 中，就像我们使用 `map` 一样，并且非常欢迎你继续将其作为练习去尝试它。

然而，还有一个等待处理的函数是 `pred`。 让我们为它的 `Parser` trait 添加一个定义：

```rust
fn pred<F>(self, pred_fn: F) -> BoxedParser<'a, Output>
where
    Self: Sized + 'a,
    Output: 'a,
    F: Fn(&Output) -> bool + 'a,
{
    BoxedParser::new(pred(self, pred_fn))
}
```

让我们用 `pred` 调用重写 `quoted_string` 中的那一行，如下所示：

```rust
zero_or_more(any_char.pred(|c| *c != '"')),
```

这样阅读起来更好一些，并且我认为应该保留 `zero_or_more` —— 它读起来像是“零或更多的 `any_char` 并且应用了下面的判断”，对我来说这听起来是正确的。如果你愿意全力以赴的话，你也可以继续将 `zero_or_more` 和 `one_or_more` 移动到 trait 中。

除了重写 `quoted_string` 之外，还要修复 `single_element` 中的 `map`：

```rust
fn single_element<'a>() -> impl Parser<'a, Element> {
    left(element_start(), match_literal("/>")).map(|(name, attributes)| Element {
        name,
        attributes,
        children: vec![],
    })
}
```

让我们尝试取消注释 `element_start` 并用之前注释过的测试代码测试一下，看看结果是否变得更好。让我们恢复游戏中的代码并尝试运行测试……

……嗯，是的，编译时间现在恢复正常了。你甚至可以移除文件顶部设置的类型大小，你完全不需要它了。

我们只是装箱了两个 `map` 和一个 `pred` —— **并且**我们得到了更好的语规则！

### 有子元素的情况

现在让我们为父元素的开始标签编写解析器。它除了以 `>` 而不是 `/>` 结尾之外，其他几乎与 `single_element` 相同。它后面跟着零个或多个子项以及结束标签。首先我们需要解析实际的开始标签，让我们完成它。

```rust
fn open_element<'a>() -> impl Parser<'a, Element> {
    left(element_start(), match_literal(">")).map(|(name, attributes)| Element {
        name,
        attributes,
        children: vec![],
    })
}
```

现在，我们如何得到那些子元素？它们不是单个元素就是父元素本身，它们中也可能有零个或多个子元素，而我们拥有可靠的 `zero_or_more` 组合器，那我们该怎样输入呢？我们还有一个东西尚未处理，那就是多选解析器：**既**可以解析单个元素**又**可以解析父元素。

为了达到目的，我们需要组合器按顺序尝试两个解析器：如果第一个解析器成功，任务就完成了，并返回它的结果。如果它失败了，我们会用**相同的输入**尝试第二个解析器，而不是返回错误。如果成功，那很好，如果没有，我们就会返回错误，因为这意味着我们的解析器都失败了，这是一个彻底的失败。

```rust
fn either<'a, P1, P2, A>(parser1: P1, parser2: P2) -> impl Parser<'a, A>
where
    P1: Parser<'a, A>,
    P2: Parser<'a, A>,
{
    move |input| match parser1.parse(input) {
        ok @ Ok(_) => ok,
        Err(_) => parser2.parse(input),
    }
}
```

这允许我们声明一个解析器 `element`，它匹配单个元素或父元素（现在，我们仅使用 `open_element` 来代表它，一旦我们有 `element` 我们就会处理子元素）。

```rust
fn element<'a>() -> impl Parser<'a, Element> {
    either(single_element(), open_element())
}
```

现在让我们为结束标签添加一个解析器。它有个有趣的属性，必须以开始标签匹配，这意味着解析器必须知道开始标签的名称是什么。但这就是函数参数的用途，是吧？

```rust
fn close_element<'a>(expected_name: String) -> impl Parser<'a, String> {
    right(match_literal("</"), left(identifier, match_literal(">")))
        .pred(move |name| name == &expected_name)
}
```

那个 `pred` 组合器证明非常有用，不是吗？

现在，让我们把它放在一起，用于实现完整的父元素解析器，子元素解析器和所有其他的解析器：

```rust
fn parent_element<'a>() -> impl Parser<'a, Element> {
    pair(
        open_element(),
        left(zero_or_more(element()), close_element(…oops)),
    )
}
```

哎呀，我们现在该如何将该参数传递给 `close_element` 呢？我想这是我们要实现的最后一个组合器。

我们现在离完成非常接近了。一旦我们解决了最后一个让 `parent_element` 工作的问题，我们可以用实现的新的 `parent_element` 替换 `element` 解析器中的 `open_element` 占位符，就这样，我们实现了一个完全可用的 XML 解析器。

还记得我说我们之后会回到 `and_then` 吗？就是现在回到了 `and_then`。实际上，我们需要的组合器是 `and_then`：我们需要一些带有解析器的东西，和一个获取解析器结果并返回**新**解析器的函数，之后我们将运行它。它有点像 `pair`，但它只是在元组中收集两个结果，我们通过函数将它们串联起来。这也是 `and_then` 与 `Result` 和 `Option` 一起使用的方法，但它更容易理解，因为 `Result` 和 `Option` 不是真的**做**任何事情，它们只是持有一些数据的东西（或不是，视情况而定）。

所以让我们尝试编写一个它的实现。

```rust
fn and_then<'a, P, F, A, B, NextP>(parser: P, f: F) -> impl Parser<'a, B>
where
    P: Parser<'a, A>,
    NextP: Parser<'a, B>,
    F: Fn(A) -> NextP,
{
    move |input| match parser.parse(input) {
        Ok((next_input, result)) => f(result).parse(next_input),
        Err(err) => Err(err),
    }
}
```

查看类型会有很多类型变量，但我们知道输入解析器 `P` 的结果类型为 `A`。然而我们的函数 `F`，其中的 `map` 有一个从 `A` 到 `B` 的函数，此两者之间关键的区别是 `and_then` 会从 `A` 获取一个函数到**一个新的解析器** `NextP`，其结果类型为 `B`。最终的结果类型是`B`，因此我们可以假设从 `NextP` 输出的任何东西都是最终的结果。

代码有点复杂：我们从运行输入解析器开始，如果失败，它就会失败并且代表我们已经完成了。但如果成功，我们先在结果上调用函数 `f`（类型为`A `），`f(result)` 的返回是一个新的解析器，并带有一个类型为 `B` 的结果。我们在下一位输入上运行**这个**解析器，并直接返回结果。如果失败，那就失败了，如果成功，我们就会得到类型为 `B` 的值。

再一次：我们首先运行 `P` 类型的解析器，如果成功，我们以解析器 `P` 的结果作为参数调用函数 `f` 来得到我们的下一个类型为 `NextP` 的解析器，接着我们继续运行，并得到最后的结果。

让我们直接将它添加到 `Parser` trait中，因为这个像 `map` 一样，以这种方式肯定会更容易阅读。

```rust
fn and_then<F, NextParser, NewOutput>(self, f: F) -> BoxedParser<'a, NewOutput>
where
    Self: Sized + 'a,
    Output: 'a,
    NewOutput: 'a,
    NextParser: Parser<'a, NewOutput> + 'a,
    F: Fn(Output) -> NextParser + 'a,
{
    BoxedParser::new(and_then(self, f))
}
```

好的，现在这么做都有什么好处？

首先，我们**几乎**可以使用它来实现 `pair`：

```rust
fn pair<'a, P1, P2, R1, R2>(parser1: P1, parser2: P2) -> impl Parser<'a, (R1, R2)>
where
    P1: Parser<'a, R1> + 'a,
    P2: Parser<'a, R2> + 'a,
    R1: 'a + Clone,
    R2: 'a,
{
    parser1.and_then(move |result1| parser2.map(move |result2| (result1.clone(), result2)))
}
```

它看起来非常简洁，但是有一个问题：`parser2.map()` 使用 `parser2` 来创建封装好的解析器，包装函数是 `Fn`，而不是 `FnOnce`，因此它不允许使用 `parser2` 解析器，我们只能参考它。换句话说，这是 Rust 的问题。在更高级别的语言中，这些事情不是问题，它们可能会用更优雅的方式定义 `pair`。

但是，即使在 Rust 中我们也可以使用该函数来延迟生成 `close_element` 解析器的正确版本，或者换句话说，我们可以通过传递参数获取解析器。

回顾我们之前失败的尝试：

```rust
fn parent_element<'a>() -> impl Parser<'a, Element> {
    pair(
        open_element(),
        left(zero_or_more(element()), close_element(…oops)),
    )
}
```

使用 `and_then`，我们现在可以通过使用这个函数构造正确版本的 `close_element` 来实现这一点。

```rust
fn parent_element<'a>() -> impl Parser<'a, Element> {
    open_element().and_then(|el| {
        left(zero_or_more(element()), close_element(el.name.clone())).map(move |children| {
            let mut el = el.clone();
            el.children = children;
            el
        })
    })
}
```

它现在看起来有点复杂，因为 `and_then` 必须继续通过 `open_element()` 调用，我们会在那里找到跳转到 `close_element` 的名字。这意味着 `open_element` 之后的其它解析器都必须在 `and_then` 闭包内构造。此外，由于闭包现在是 `open_element` 的 `Element` 结果的唯一接收者，我们返回的解析器也必须向前传递该信息。

我们在生成的解析器上 `map` 的内部闭包能从外部闭包中引用 `Element`(`el`)。由于我们在 `Fn` 中只能引用它一次，因此我们必须 `clone()` 它。我们取内部解析器的结果（子元素的 `Vec<Element>` ）并将它添加到我们克隆的 `Element` 中，并将其作为最终结果返回。

我们现在需要做的就是回到 `element` 解析器并确保将 `open_element` 改为 `parent_element`，这样它会解析整个元素结构而不仅仅是它的开头，我相信我们已经完成解析器组合器了！

### 你会问那个 M 开头的单词我是否应该完成吗？

还记得我们谈到过如何将 `map` 模式称为 Haskell 星球上的“函子（functor）”吗？

`and_then` 模式是另一个你会在 Rust 中时常看到的东西，它通常与 `map` 出现在相同的位置。它在 `迭代器（Iterator）`上被称为 [`flat_map`](https://doc.rust-lang.org/std/iter/trait.Iterator.html#method.flat_map)，但它与 Rest 的模式相同。

这个奇特的单词是“单子（monad）”。如果你有一个 `Thing<A>`，并且你有一个 `and_then` 函数可以将一个函数从 `A` 传递给 `Thing<B>`，那么相反，现在你有了一个新的 ` Thing<B>` ，这就是一个 monad。

就像当你有 `Option<A>` 的时候，函数可能会被立即调用，我们已经知道它是 `Some(A)` 还是 `None`，所以如果是 `Some(A)` 我们直接应用函数，并输出 `Some(B)`。

它也可能被称为延迟调用。 例如，如果你有一个仍然等待解决的 `Future<A>`，它不会通过 `and_then` 立即调用函数创建一个 `Future<B>`，而是创建一个新的`Future<B>`，既包含 `Future<A>` 又包含函数，然后等待 `Future<A>` 完成。 当它发生的时候，它会调用带有 `Future<A>` 结果的函数，而鲍勃是你的叔叔 <sup><a href="#note1">[1]</a></sup>，你会得到 `Future<B>`。 换句话说，在 `Future` 的情况下，你可以将传递给 `and_then` 的函数视为**回调函数**，因为它在完成时会被原始的未来的结果调用。它也比这更有意思，因为它返回了一个**新的** `Future`，它可能已经或可能没有被解析，所以它是一种**连接**未来状态的方法。

然而，与函子一样，Rust 的类型系统目前还不能表达 monad，所以我们只需记住这种模式被叫做 monad，而且相当令人失望的是，与在互联网上所描述的相反，它与 burrito 没什么关系。让我们继续前进。

### 空格，最终版

最后一件事了。

我们现在应该有了一个能够解析一些 XML 的解析器，但它不太支持空格。标签之间应该允许任意数量的空格，这样我们就可以自由地在我们的标签之间插入换行符（原则上，在标识符和文字之间应该允许空格，比如 `<div />`，但让我们跳过它）。

此时我们应该能够毫不费力地组装一个快速组合器。

```rust
fn whitespace_wrap<'a, P, A>(parser: P) -> impl Parser<'a, A>
where
    P: Parser<'a, A>,
{
    right(space0(), left(parser, space0()))
}
```

如果我们将 `element` 包装在其中，它将忽略 `element` 周围的所有前导和尾随的空格，这意味着我们可以自由地使用我们希望的任意数量的换行符和缩进。

```rust
fn element<'a>() -> impl Parser<'a, Element> {
    whitespace_wrap(either(single_element(), parent_element()))
}
```

### 我们终于完成了！

我想我们做到了！让我们写一个集成测试来庆祝一下。

```rust
#[test]
fn xml_parser() {
    let doc = r#"
        <top label="Top">
            <semi-bottom label="Bottom"/>
            <middle>
                <bottom label="Another bottom"/>
            </middle>
        </top>"#;
    let parsed_doc = Element {
        name: "top".to_string(),
        attributes: vec![("label".to_string(), "Top".to_string())],
        children: vec![
            Element {
                name: "semi-bottom".to_string(),
                attributes: vec![("label".to_string(), "Bottom".to_string())],
                children: vec![],
            },
            Element {
                name: "middle".to_string(),
                attributes: vec![],
                children: vec![Element {
                    name: "bottom".to_string(),
                    attributes: vec![("label".to_string(), "Another bottom".to_string())],
                    children: vec![],
                }],
            },
        ],
    };
    assert_eq!(Ok(("", parsed_doc)), element().parse(doc));
}
```

它会由于缺少闭合标签而导致失败，只是为了确保我们能够做到这一点：

```rust
#[test]
fn mismatched_closing_tag() {
    let doc = r#"
        <top>
            <bottom/>
        </middle>"#;
    assert_eq!(Err("</middle>"), element().parse(doc));
}
```

好消息是当返回值缺少闭合标签时会抛出错误。坏消息是它实际上并没有**指明**问题是由于缺少闭合标签导致的，只是标记了错误在**哪里**。不过它总比没有好，但老实说，随着错误信息的发生，它看起来会非常糟糕。 但是实际上让它产生正确的错误信息是另一个主题，也许至少是一篇一样长的文章。

让我们专注于好消息上吧：我们从头开始用解析器组合器来编写一个编译器！我们知道解析器形成了一个函子（functor）和一个单子（monad），所以你现在可以在派对中用你知道的令人生畏的范畴理论知识给人们留下深刻的印象 <sup><a href="#note2">[2]</a></sup>。

最重要的是，我们现在知道解析器组合器是如何从头开始工作的了。已经没人能阻止我们了！

### 胜利小狗

![](https://bodil.lol/parser-combinators/many-puppies.gif)

### 更多资源

首先，我很严谨地用严格的 Rusty 术语向你解释 monad，我知道如果我没有把你指向[他的开创性论文](https://homepages.inf.ed.ac.uk/wadler/papers/marktoberdorf/baastad.pdf)，那么 Phil Wadler 会对我非常不满，因为这篇论文更加令人兴奋 —— 它包含了他们是如何关联解析器组合器的。

本文的想法与 [`pom`](https://crates.io/crates/pom) 解析器组合器背后的想法极为相似，如果你希望用相同的风格使用解析器组合器的话，我极力推荐它。

Rust 解析器组合器中的最先进的依然是 [`nom`](https://crates.io/crates/nom)，在某种程度上之前提到的 `pom` 明显是它衍生的命名（没有比它更高的赞美了）。但它采取的方法与我们今天在这里的设计截然不同。

Rust 的另一个流行的解析器组合器库是 [`combine`](https://crates.io/crates/combine)，它也值得一看。

Haskell 的开创性解析器组合器库是 [Parsec](http://hackage.haskell.org/package/parsec)。

最后，我在 Graham Hutton 的书 [**Haskell 编程**](http://www.cs.nott.ac.uk/%7Epszgmh/pih.html)中第一次认识到解析器组合器，这本书非常值得一读，并且可以教你有关 Haskell 的知识。

- [通过 Rust 学习解析器组合器 — 第一部分](https://github.com/xitu/gold-miner/blob/master/TODO1/learning-parser-combinators-with-rust-1.md)
- [通过 Rust 学习解析器组合器 — 第二部分](https://github.com/xitu/gold-miner/blob/master/TODO1/learning-parser-combinators-with-rust-2.md)
- [通过 Rust 学习解析器组合器 — 第三部分](https://github.com/xitu/gold-miner/blob/master/TODO1/learning-parser-combinators-with-rust-3.md)
- [通过 Rust 学习解析器组合器 — 第四部分](https://github.com/xitu/gold-miner/blob/master/TODO1/learning-parser-combinators-with-rust-4.md)

## 协议

本文版权归 Bodil Stokke 所有，并受知识共享署名 - 非商业性使用 - 相同方式共享 4.0 国际许可。要查看此许可证的副本，请访问 http://creativecommons.org/licenses/by-nc-sa/4.0/ 。

## 脚注

1. <a name="note1"></a> 他并不真是你的叔叔。
2. <a name="note2"></a> 请不要在派对上做那样的人。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
