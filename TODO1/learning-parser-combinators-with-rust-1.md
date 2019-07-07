> * 原文地址：[Learning Parser Combinators With Rust](https://bodil.lol/parser-combinators/)
> * 原文作者：[Bodil](https://bodil.lol/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/learning-parser-combinators-with-rust-1.md](https://github.com/xitu/gold-miner/blob/master/TODO1/learning-parser-combinators-with-rust-1.md)
> * 译者：[suhanyujie](https://github.com/suhanyujie)

# 通过 Rust 学习解析器组合器 — Part 1

本文面向会使用 Rust 编程的人员，提供一些解析器的基础知识。如果不具备其他知识，我们将会介绍和 Rust 无直接关系的所有内容，以及使用 Rust 实现这个会更加超出预期的一些方面。如果你还不了解 Rust 这个文章也不会讲如何使用它，如果你已经了解了，那它也不能打包票能教会你解析器组合器的知识。如果你想学习 Rust，我推荐阅读 [Rust 编程语言](https://doc.rust-lang.org/book/)。

### 初学者的独白

在很多程序员的职业生涯中，可能都会有这样一个时刻，发现自己需要一个解析器。

小白程序员可能会问，“解析器是什么？”

中级程序员会说，“这很简单，我会写正则表达式。”

高级程序员会说：闪开，我知道 `lex` 和 `yacc`。

小白的心态是正确的。

并不说正则不好。（但请不要尝试将一个复杂的解析器写成正则表达式。）也不是说使用像解析器和 `lexer` 生成器等这种功能强大的工具就没有乐趣了，这些工具经过长久的迭代和改进，已经达到了非常好的程度。但从 0 开始学解析器是 **很有趣** 的。而如果你直接走正则表达式或解析器生成器的方向，你将会错过很多精彩的东西，因为它们只是对当前实际问题的抽象后形成的工具。正如[某人](https://en.wikipedia.org/wiki/Shunry%C5%AB_Suzuki#Quotations)所说，在初学者的脑袋中，是充满可能性的。而在专家的头脑中，可能就习惯于那一种想法。

在本文中，我们将学习怎样从头开始使用函数式编程语言中常见的技术构建一个解析器，这种技术被称为 **解析器组合器**。它们具有很好的优点，一旦你掌握其中的基本思想，和基本原理，你将在基本组合器之上建立自己的抽象，这里也将作为唯一的抽象 —— 所有这些必须建立在你使用它们之前已经开始进行构思。

### 怎样学习好这篇文章

强烈建议你新建一个新的 Rust 项目，并在阅读时，将代码片段键入到文件 `src/lib.rs` 中（你可以直接从页面复制代码片段，但最好手敲，因为这样会确保你完整的阅读代码）。本文会按顺序介绍你需要的每一段代码。请注意，它可能会引入你之前编写的函数 **已修改** 版本，这种情况下，你应该使用新版本的代码替换旧版本的。

代码是基于 2018 版次的 `rustc 1.34.0` 版本的编译器。你应该能够使用最新版本的编译器，只要确保你使用的是2018（检查 `Cargo.toml` 是否包含了 `edition = "2018"`）的版次。代码无需外部依赖。

如你所料，要运行文章中介绍的测试，可以使用 `cargo test`。

### XML 文本

我们将为简化版的 `XML` 编写一个解析器。它类似于这样：

```
<parent-element>
  <single-element attribute="value" />
</parent-element>
```

`XML` 元素以符号 `<` 和一个标识符开始，标识符由若干字母、数字或 `-` 组成。其后是一些空格，或一些可选的属性列表：前面定义的另一个标识符，这个标识符后跟随一个 `=` 和双引号包含一些字符串。最后，可能有一个 `/>` 进行结束，表示没有子元素的单个元素，也可能有一个 `>` 表示后面有一些子元素，最后使用一个以 `</` 开头的结束标记，后面跟一个标识符，该标识符必须在与开始标识符标记相匹配，最后使用 `>` 闭合。

这就是我们要做的。没有名称空间，没有文本节点，没有其他节点，而且 **肯定** 没有模式验证。我们甚至不需要为这些字符串支持转义引号 —— 它们从第一个双引号开始，到下一个双引号结束，就是这样。如果你想要在实际的字符串中使用双引号，你可以将这种难处理的需求放到以后处理。

我们将把这些元素解析成类似于这样的结构：

```
#[derive(Clone, Debug, PartialEq, Eq)]
struct Element {
    name: String,
    attributes: Vec<(String, String)>,
    children: Vec<Element>,
}
```

没有泛型，只有一个名为 name 的字符串（即每个标记开头的标识符）、一些字符串的属性（标识符和值），和一个看起来和父元素完全一样的子元素列表。

（如果你正在键入代码，请确保包含这些 derives。稍后你会需要用到的。）

### 定义解析器

那么，是时候开始编写解析器了。

解析是从数据流派生出结构的过程。解析器就是用来将它们梳理出结构的东西。

在我们将要探讨的规程中，解析器最简单的形式就是一个函数，它接收一些输入并返回已解析的内容和输入的剩余部分，或者一个错误提示：“无法解析”。

简而言之，解析器在更复杂的场景中也是这个样子。你可能会使输入、输出和错误复杂化，如果你有好的错误信息提示，这正是你需要的，但是解析器保持不变：处理输入并将解析的结果和输入的剩余内容，或者提示出它无法解析输入，并显示信息让你知道。

我们把它标记为函数类型

```
Fn(Input) -> Result<(Input, Output), Error>
```

更详细的说，在我们的例子中，我们要填充类型，就会得到类似下面的结果，因为我们要做的是将一个字符串转换成一个 `Element` 结构体，这一点上，我们不想将错误复杂地显示出来，所以我们只将我们无法解析的错误作为字符串返回：

```
Fn(&str) -> Result<(&str, Element), &str>
```

我们使用字符串 slice，因为它是指向一个字符串片段的有效指针，我们可以通过 slice 的方式引用它，无论怎么做，处理输入的字符串 slice，并返回剩余内容和处理结果。

使用 `&[u8]`（一个字节的 slice，假设我们限制自己只使用 ASCII 对应的字符） 作为输入的类型可能会更简洁，特别是因为一个字符串 slice 的行为不同于其他大多数的 slice，尤其是在不能用数字对字符串进行索引的情况下，数字索引字符串如：`input[0]`，你必须像这样使用一个字符串 slice `input[0..1]`。另一方面，对于解析字符串它们提供许多有用的方法，而字节 slice 没有。

实际上，大多数情况下，我们将依赖这些方法，而不是对其进行索引，因为，`Unicode`。在 UTF-8 中，所有 Rust 字符串都是 UTF-8 的，这些索引并不能总是对应于单个字符，最好让标准库帮我们处理与这个相关的问题。

### 我们的第一个解析器

让我们尝试编写一个解析器，它只查看字符串中的第一个字符，并判断它是否是字母 `a`。

```
fn the_letter_a(input: &str) -> Result<(&str, ()), &str> {
  match input.chars().next() {
      Some('a') => Ok((&input['a'.len_utf8()..], ())),
      _ => Err(input),
  }
}
```

首先，我们看下输入和输出的类型：我们将一个字符串 slice 作为输入，正如我们讨论的，我们返回一个包含 `(&str, ())` 的 `Result` 或者 `&str` 类型的错误。有趣的是 `(&str, ())` 这部分：正如我们所讨论的，我们期望返回一个元组，它带有下一个用于解析的输入部分，以及解析结果。`&str` 是下一个输入，处理的结果则是单个 `()` 类型，因为如果这个解析器成功运行，它将只能得到一个结果（找到了字母 `a`），并且在这种情况下，我们不特别需要返回字母 `a`，我们只需要指出已经成功的找到了它就行。

因此，我们看看解析器本身的代码。首先获取输入的第一个字符：`input.chars().next()`。我们并没有尝试性的依赖标准库来避免带来 `Unicode` 的问题 —— 我们调用它为字符串的字符提供的一个 `chars()` 迭代器，然后从其中取出第一个单元。这就是一个 `char` 类型的项，并且通过 `Option` 包装着，即 `Option<char>`，如果是 `None` 类型的 `Option` 则意味着我们获取到的是一个空字符串。

更糟糕的是，一个 `char` 类型甚至可能不是我们想象的 `Unicode` 中的字符。这很可能就是 `Unicode` 中的 “[字母集合](http://www.unicode.org/glossary/#grapheme_cluster)”，它可以由几个 `char` 类型的字符组成，这些字符实际上表示 “[标量值](http://www.unicode.org/glossary/#unicode_scalar_value)”，它比 "字母集合" 差不多还低 2 个层次。但是，这样想未免有些激进了，就我们的目的而言，我们甚至不太可能看到 ASCII 字符集以外的字符，所以暂且忽略这个问题。

我们对 `Some('a')` 进行模式匹配，它就是我们正在寻找的特定结果，如果匹配成功，我们将返回成功 `Ok((&input['a'.len_utf8]()..], ()))`。也就是说，我们从字符串 slice 中移出的解析的项（'a'），并返回剩余的字符，以及解析后的值，也就是 `()` 类型。考虑到 Unicode 字符集问题，在对字符串 range 处理前，我们用标准库中的方法查询一下字符 `'a'` 在 UTF-8 中的长度 —— 长度是1，这样不会遇到之前认为的 Unicode 字符问题。

如果我们得到其他类型的结果 `Some(char)`，或者 `None`，我们将返回一个异常。正如之前提到的，我们刚刚的异常类型就是解析失败时的字符串 slice，也就是我们我们传递的输入。它不是以 `a` 开头，所以返回异常给我们。这不是一个很严重的错误，但至少比“一些地方出了严重错误”要好一些。

实际上，尽管我们不是要用这种解析器解析这个 `XML`，但是我们需要做的第一件事是寻找开始的 `<`，所以我们需要一些类似的东西。特别的，我们还需要解析 `>`、`/` 和 `=`，所以，也许我们可以创建一个函数来构建一个解析器用于解析我们想要解析的字符。

### 解析器构建器

我们想象一下：如果要写一个函数，它可以为 **任意** 长度而不仅仅是单个字符的静态字符串生成一个解析器。这样做甚至更简单一些，因为字符串 slice 是一个合法的 UTF-8 字符串 slice，并且暂且不考虑 Unicode 字符集问题。

```
fn match_literal(expected: &'static str)
    -> impl Fn(&str) -> Result<(&str, ()), &str>
{
    move |input| match input.get(0..expected.len()) {
        Some(next) if next == expected => {
            Ok((&input[expected.len()..], ()))
        }
        _ => Err(input),
    }
}
```

现在看起来有点不一样了。

首先，我们看看类型。我们的函数看起来不像一个解析器，它现在使用 `expected` 字符串作为参数，并且 **返回** 值是看起来像解析器一样的东西。它是一个返回值是函数的函数 —— 换句话说，它是一个 **高阶** 函数。基本上，我们写的是 **生成** 一个类似于之前我们写的 `the_letter_a` 一样的函数。

因此，我们不是在函数体中执行一些逻辑，而是返回一个闭包，这个闭包才是执行逻辑的地方，并且与前面的解析器的函数签名是匹配的。

匹配模式是一样的，只是我们不能直接匹配字符串文本，因为我们不知道他具体是什么，所以我们使用条件 `if next == expected` 来判断匹配。因此，它和之前完全一样，只是逻辑的执行是在闭包的内部。

### 测试解析器

我们将编写一个测试来确保我们做的是对的。

```
#[test]
fn literal_parser() {
    let parse_joe = match_literal("Hello Joe!");
    assert_eq!(
        Ok(("", ())),
        parse_joe("Hello Joe!")
    );
    assert_eq!(
        Ok((" Hello Robert!", ())),
        parse_joe("Hello Joe! Hello Robert!")
    );
    assert_eq!(
        Err("Hello Mike!"),
        parse_joe("Hello Mike!")
    );
}
```

首先，我们构建解析器：`match_literal("Hello Joe!")`。这应该使用字符串 `Hello Joe!` 作为输入，并返回字符串的其余部分，否则它应该提示失败并返回整个字符串。

在第一种情况下，我们只是向他提供它期望的具体字符串作为参数，然后，我们看到它返回一个空字符串和 `()` 类型的值，这意味着：“我们按照正常流程解析了字符串，实际上你并不需要它返回给你这个值”。

在第二种情况下，我们给它输入字符串 `Hello Joe! Hello Robert!`，并且我们确实看到它解析了字符串 `Hello Joe!` 并返回剩余部分：` Hello Robert!`（空格开头的剩余所有字符串）。

在第三个例子中，我们输入了一些不正确的值：`Hello Mike!`，请注意，它确实根据输入给出了错误并中断执行。一般来说，`Mike` 并不是正确的输入部分，它不是这个解析器要寻找的对象。

### 用于不固定参数的解析器

这样，我们来解析 `<`,`>`,`=` 甚至 `</` 和 `/>`。我们实际上做的差不多了。

在开始 `<` 后的下一个元素是元素的名称。虽然我们不能用一个简单的字符串比较来做到这一点，但是我们 **可以** 用正则表达式来做...

...但是我们要克制自己，它将是一个很容易在简单代码中复制的正则表达式，并且我们不需要为此而去依赖于 `regex` 的 crate 库。我们要试试是否可以仅仅只使用 Rust 标准库来编写自己的解析器。

回顾元素名称标识符的定义，它大概是这样：一个字母的字符，然后是若干个字母数字中横线 `-` 等多个字符。

```
fn identifier(input: &str) -> Result<(&str, String), &str> {
    let mut matched = String::new();
    let mut chars = input.chars();

    match chars.next() {
        Some(next) if next.is_alphabetic() => matched.push(next),
        _ => return Err(input),
    }

    while let Some(next) = chars.next() {
        if next.is_alphanumeric() || next == '-' {
            matched.push(next);
        } else {
            break;
        }
    }

    let next_index = matched.len();
    Ok((&input[next_index..], matched))
}
``` 

和往常一样，我们先查看一下类型。这次，我们不是编写函数来构建解析器，而是像最开始的那样编写解析器本身。这里值得注意的不同点是，我们没有返回 `()` 的结果类型，而是返回一个元组，其中包含 `String` 以及输入的未解析的剩余部分。这个 `String` 将包含我们刚刚解析过的标识符。

记住这一点，首先我们创建一个空的 `String`，并将其命名为 `matched`。它将作为我们的结果值。我们还会通过输入的字符串得到一个迭代器，通过迭代器逐个遍历分开这些字符。

第一步是看前缀是否是字母开始。我们从迭代器中取出第一个字符，并检查他是否是字母：`next.is_alphabetic()`。在这里，Rust 标准库当然会帮助我们处理 Unicode —— 它将匹配任意字母，不仅仅是 ASCII。如果它是一个字母，我们将把它放入匹配完成的字符串中，如果不是，很明显，我们没有找到元素标识符，我们将直接返回一个错误。

第二步，我们继续从迭代器中提取字符，并把它放入构建的 `String` 中，直到我们找到一个不符合 `is_alphanumeric()`（类似于 `is_alphabetic()`），也不匹配字母表中的任意字符，也不是 `-` 的字符。

 当我们第一次看到与这些条件不匹配的东西时，这意味着我们已经完成了解析，因此我们跳出循环，并返回我们处理好的 `String`，记住我们要从 `input` 中剥离出我们已经处理的部分。同样的，如果迭代器迭代完成，表示我们到达了输入的末尾。

值得注意的是，当我们看到不是字母数字或 `-` 时，我们没有返回异常。一旦匹配了第一个字母，我们就已经有足够的内容来创建一个有效的标识符，解析标识符之后，在输入字符串中解析更多的东西是完全正常的，所以我们只需停止解析并返回结果。只有当我们连第一个字母都找不到时，我们才会返回一个异常，因为在这种情况下，意味着输入中肯定没有标识符。

还记得我们要将 XML 文档解析为 `Element` 结构体吗？

```
struct Element {
    name: String,
    attributes: Vec<(String, String)>,
    children: Vec<Element>,
}
```

实际上，我们刚刚完成了第一部分的解析器，解析 `name` 字段。我们解析器返回的 `String` 就是这样，对于每个 `attribute` 的前面部分来说，它也是适用的解析器。

让我们开始测试它。

```
#[test]
fn identifier_parser() {
    assert_eq!(
        Ok(("", "i-am-an-identifier".to_string())),
        identifier("i-am-an-identifier")
    );
    assert_eq!(
        Ok((" entirely an identifier", "not".to_string())),
        identifier("not entirely an identifier")
    );
    assert_eq!(
        Err("!not at all an identifier"),
        identifier("!not at all an identifier")
    );
}
```

我们看到第一种情况，字符串 `i-am-an-identifier` 被完整解析，只剩下空字符串。在第二种情况下，解析器返回 `"not"` 作为标识符，其余的字符串作为剩余的输入返回。在第三种情况下，解析器完全失败，因为它找到的首字符并不是字母。

### 组合器

现在我们可以解析开头的 `<`，然后解析接下来的标识符，但是我们需要同时解析 **这两个**，以便于能够向下运行。因此，下一步将编写另一个解析器构建器函数，该函数将两个 **解析器**　作为输入，并返回一个新的解析器，它按顺序解析这两个解析器。换句话说，是另一个解析器 **组合器**，因为它将两个解析器组合成一个新的解析器。让我们看看能不能实现它。

```
fn pair<P1, P2, R1, R2>(parser1: P1, parser2: P2) -> impl Fn(&str) -> Result<(&str, (R1, R2)), &str>
where
    P1: Fn(&str) -> Result<(&str, R1), &str>,
    P2: Fn(&str) -> Result<(&str, R2), &str>,
{
    move |input| match parser1(input) {
        Ok((next_input, result1)) => match parser2(next_input) {
            Ok((final_input, result2)) => Ok((final_input, (result1, result2))),
            Err(err) => Err(err),
        },
        Err(err) => Err(err),
    }
}
```

这里稍微有点复杂，但你应该知道接下来要做什么：从查看类型开始。

首先，我们有四个类型：`P1`、`P2`、`R1` 和 `R2`。这是分析器 1，分析器 2，结果 1，结果 2。`P1` 和 `P2` 是函数，你将注意到它们遵循已建立的解析器函数模式：就像返回值一样，他们以 `&str` 作为输入，并返回剩余输入和解析结果，或者返回一个异常。

但是看看每个函数的结果类型：`P1` 是一个解析器，如果成功，它将生成 `R1`，`P2` 也将生成 `R2`。最终的解析器的结果是 —— 即函数的返回值 —— 是 `(R1, R2)`。因此，这个解析器的逻辑是首先在输入上运行解析器 `P1`，保留它的结果，然后将 `P1` 返回的作为输入运行 `P2`，如果这2个方法都能正常运行，我们将这2个结果合并为一个元组 `(R1, R2)`。

看看代码，它也确实是这么实现的。我们首先在输入上运行第一个解析器，然后运行第2个解析器，然后将两个结果组合成一个元组并返回。如果其中一个解析器遇到异常，我们立即返回它给出的错误。

这样的话，我们可以结合之前的两个解析器，`match_literal` 和 `identifier`，来实际的解析一下 XML 标签一开始的字节。我们写个测试测一下它是否能起作用。

```
#[test]
fn pair_combinator() {
    let tag_opener = pair(match_literal("<"), identifier);
    assert_eq!(
        Ok(("/>", ((), "my-first-element".to_string()))),
        tag_opener("<my-first-element/>")
    );
    assert_eq!(Err("oops"), tag_opener("oops"));
    assert_eq!(Err("!oops"), tag_opener("<!oops"));
}
```

它似乎可以运行！但看结果类型：`((), String)`。很明显，我们只关心右边的值，也就是 `String`。大部分情况 —— 我们的一些解析器只匹配输入中的模式，而不产生值，因此可以放心地忽略这种输出。为了适应这种场景，我们要用我们的 `pair` 组合器来写另外两个组合器：`left`，它丢弃第一个解析器的结果，并返回第二个解析器和对应的数字，`right`，这是我们在我们上面的测试中想要使用的而不是 `pair` —— 它丢弃左侧的 `()`，只留下我们的 `String`。

- [通过 Rust 学习解析器组合器 - Part 1](https://github.com/xitu/gold-miner/blob/master/TODO1/learning-parser-combinators-with-rust-1.md)
- [通过 Rust 学习解析器组合器 - Part 2](https://github.com/xitu/gold-miner/blob/master/TODO1/learning-parser-combinators-with-rust-2.md)
- [通过 Rust 学习解析器组合器 - Part 3](https://github.com/xitu/gold-miner/blob/master/TODO1/learning-parser-combinators-with-rust-3.md)
- [通过 Rust 学习解析器组合器 - Part 4](https://github.com/xitu/gold-miner/blob/master/TODO1/learning-parser-combinators-with-rust-4.md)

## 许可证

本作品版权归 Bodil Stokke 所有，在知识共享署名-非商业性-相同方式共享 4.0 协议之条款下提供授权许可。要查看此许可证，请访问 http://creativecommons.org/licenses/by-nc-sa/4.0/。

## 脚注

1: 他不是你真正的叔叔。
2: 请不要成为聚会上的那个人。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
