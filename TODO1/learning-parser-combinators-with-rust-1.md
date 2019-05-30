> * 原文地址：[Learning Parser Combinators With Rust](https://bodil.lol/parser-combinators/)
> * 原文作者：[Bodil](https://bodil.lol/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/learning-parser-combinators-with-rust-1.md](https://github.com/xitu/gold-miner/blob/master/TODO1/learning-parser-combinators-with-rust-1.md)
> * 译者：
> * 校对者：

# 通过 Rust 学习解析器组合器 - （一）

本文面向会使用Rust编程的人员，提供一些解析器的基础知识。如果不具备其他知识，我们将会介绍和 Rust 没有直接关系的所有内容，以及使用 Rust 实现这个会更加超出预期的一些方面。如果你还不了解 Rust，这个文章也不会讲如何使用它，如果你已经了解了，那它也不能打包票能教会你解析器组合器的知识。如果你想学习 Rust ，我推荐阅读[Rust编程语言](https://doc.rust-lang.org/book/)。

## 初学者的独白

在很多程序员的职业生涯中，可能都会有这样一个时刻，发现自己需要一个解析器。

小白程序员可能会问，“解析器是什么？”

中级程序员会说，“这很简单，我会写正则表达式。”

高级程序员会说：闪开，我知道 `lex` 和 `yacc` 。

小白的心态是正确的。

并不说正则不好。（但请不要尝试将一个复杂的解析器写成正则表达式。）也不是说使用像解析器和 `lexer` 生成器等这种功能强大的工具就没有乐趣了，这些工具经过长久的迭代和改进，已经达到了非常好的程度。但从 0 开始学解析器是 **很有趣** 的。而如果你直接走正则表达式或解析器生成器的方向，你将会错过很多精彩的东西，因为它们只是对当前实际问题的抽象后形成的工具。正如[某人](https://en.wikipedia.org/wiki/Shunry%C5%AB_Suzuki#Quotations)所说，在初学者的脑袋中，是充满可能性的。而在专家的头脑中，可能就习惯于那一种想法。

在本文中，我们将学习怎样从头开始使用函数式编程语言中常见的技术构建一个解析器，这种技术被称为 **解析器组合器**。它们具有很好的优点，一旦你掌握其中的基本思想，和基本原理，你将在基本组合器之上建立自己的抽象，这里也将作为唯一的抽象 —— 所有这些必须建立在你使用它们之前开始进行构思。

### 怎样学习好这篇文章

强烈建议你新建一个新的 Rust 项目，并在阅读时，将代码片段键入到文件 `src/lib.rs` 中 （您可以直接从页面复制代码片段，但最好手敲，因为这样会确保你完整的阅读代码）。本文会按顺序介绍你需要的每一段代码。请注意，它可能会引入你之前编写的函数 **已修改** 版本，这种情况下，你应该使用新版本的代码替换旧版本的。

代码是基于 2018 版次的 `rustc 1.34.0` 版本的编译器的。你应该能够使用最新版本的编译器，只要确保你使用的是2018（检查 `Cargo.toml` 是否包含了 `edition = "2018"` ）的版次。代码无需外部依赖。

如你所料，要运行文章中介绍的测试，可以使用 `cargo test`

### XML 文本

我们将为简化版的 `XML` 编写一个解析器。它类似于这样：

```
<parent-element>
  <single-element attribute="value" />
</parent-element>
```

`XML` 元素以符号 `<` 和一个标识符开始，标识符由若干字母、数字或 `-` 组成。其后是一些空格，或一些可选的属性列表：前面定义的另一个标识符，这个标识符后跟随一个 `=` 和双引号包含一些字符串。最后，可能有一个 `/>` 进行结束，表示没有子元素的单个元素，也可能有一个 `>` 表示后面有一些子元素，最后使用一个以 `</` 开头的结束标记，后面跟一个标识符，该标识符必须在与开始标识符标记相匹配，最后使用 `>` 闭合。

这就是我们要做的。没有名称空间，没有文本节点，没有其他节点，而且 **肯定** 没有模式验证。我们甚至不需要为这些字符串支持转义引号 —— 它们从第一个双引号开始，到下一个双引号结束，就是这样。如果你想要在实际的字符串中使用双引号，你可以将难处理的需求放到以后处理。

我们将把这些元素解析成类似于这样的结构：

```
#[derive(Clone, Debug, PartialEq, Eq)]
struct Element {
    name: String,
    attributes: Vec<(String, String)>,
    children: Vec<Element>,
}
```

没有泛型，只有一个带有名称的字符串（即每个标记开头的标识符）、一些字符串的属性（标识符和值），和一个看起来和父元素完全一样的子元素列表。

（如果你正在键入代码，请确保包含这些 derives 。稍后你会需要用到的。）

### 定义解析器

那么，是时候开始编写解析器了。

解析是从数据流派生出结构的过程。解析器就是用来将它们梳理出结构的东西。

在我们将要探讨的规程中，解析器最简单的形式就是一个函数，它接收一些输入并返回已解析的内容和输入的剩余部分，或者一个错误提示：“无法解析”。

It turns out that's also, in a nutshell, what a parser looks like in its more complicated forms. You might complicate what the input, the output and the error all mean, and if you're going to have good error messages you'll need to, but the parser stays the same: something that consumes input and either produces some parsed output along with what's left of the input or lets you know it couldn't parse the input into the output.
简而言之，这也是解析器在更复杂的场景中也是这个样子。你可能会使输入、输出和错误复杂化，如果你要有好的错误信息，你需要它，但是解析器保持不变：处理输入并将解析的结果和其他输入的剩余内容进行输出，或者提示出它无法将输入解析并显示信息。

我们把它标记为函数类型

```
Fn(Input) -> Result<(Input, Output), Error>
```

More concretely, in our case, we'll want to fill out the types so we get something like this, because what we're about to do is convert a string into an `Element` struct, and at this point we don't want to get into the intricacies of error reporting, so we'll just return the bit of the string that we couldn't parse as an error:
更详细的说，在我们的例子中，我们要填充类型，就会得到类似下面的结果，因为我们要做的是将一个字符串转换成一个元素结构，这一点上，我们不想将错误复杂地显示出来，所以我们只将我们无法解析的错误作为字符串返回：

```
Fn(&str) -> Result<(&str, Element), &str>
```

We use a string slice because it's an efficient pointer to a piece of a string, and we can slice it up further however we please, "consuming" the input by slicing off the bit that we've parsed and returning the remainder along with the result.
我们使用字符串 slice ，因为它是指向一个字符串片段的有效指针，我们可以通过 slice 的方式引用它，无论怎么做，处理输入的字符串 slice ，并返回剩余内容和处理结果。

It might have been cleaner to use `&[u8]` (a slice of bytes, corresponding to characters if we restrict ourselves to ASCII) as the input type, especially because string slices behave a little differently from most slices - especially in that you can't index them with a single number `input[0]`, you have to use a slice `input[0..1]`. On the other hand, they have a lot of methods that are useful for parsing strings that slices of bytes don't have.
使用 `&[u8]` （一个字节的 slice ，假设我们限制自己使用 ASCII 对应的字符） 作为输入的类型可能会更简洁，特别是因为一个字符串 slice 的行为不同于其他类型的 slice ，尤其是在不能用数字索引对字符串进行索引的情况下，你必须像这样使用一个字符串 slice `input[0..1]` 。另一方面，对于解析字符串它们提供许多方法，而字符数组 slice 没有。

In fact, in general we're going to be relying on those methods rather than indexing it like that, because, well, Unicode. In UTF-8, and all Rust strings are UTF-8, these indexes don't always correspond to single characters, and it's better for all parties concerned that we ask the standard library to just please deal with this for us.
实际上，大多数情况下，我们将依赖这些方法，而不是对其进行索引，因为， `Unicode` 。在 utf-8 中，所有rust字符串都是 utf-8 的，这些索引并不能总是对应于单个字符，最好让标准库帮我们处理这个问题。

### 我们的第一个解析器

Let's try writing a parser which just looks at the first character in the string and decides whether or not it's the letter `a`.
让我们尝试编写一个解析器，它只查看字符串中的第一个字符，并判断它是否是字母 `a`。

```
fn the_letter_a(input: &str) -> Result<(&str, ()), &str> {
  match input.chars().next() {
      Some('a') => Ok((&input['a'.len_utf8()..], ())),
      _ => Err(input),
  }
}
```

First, let's look at the input and output types: we take a string slice as input, as we've discussed, and we return a `Result` of either `(&str, ())` or the error type `&str`. The pair of `(&str, ())` is the interesting bit: as we've talked about, we're supposed to return a tuple with the next bit of input to parse and the result. The `&str` is the next input, and the result is just the unit type `()`, because if this parser succeeds, it could only have had one result (we found the letter `a`), and we don't particularly need to return the letter `a` in this case, we just need to indicate that we succeeded in finding it.
首先，我们看下输入和输出的类型：我们将一个字符串 slice 作为输入，正如我们讨论的，我们返回一个包含 `(&str, ())` 的 `Result` 或者 `&str` 类型的错误。有趣的是 `(&str, ())` 这部分：正如我们所讨论的，我们应该返回一个能够分析下一个输入的结果的元组。 `&str` 是下一个输入，处理的结果则是单独的 `()` 类型，因为如果这个解析器成功运行，它将只能得到一个结果（找到了字母 `a` ），并且在这种情况下，我们不特别需要返回字母 `a` ，我们只需要指出已经成功的找到了它就行。

And so, let's look at the code for the parser itself. We start by getting the first character of the input: `input.chars().next()`. We weren't kidding about leaning on the standard library to avoid giving us Unicode headaches - we ask it to get us an iterator `chars()` over the characters of the string, and we pull the first item off it. This will be an item of type `char`, wrapped in an `Option`, so `Option<char>`, where `None` means we tried to pull a `char` off an empty string.
因此，我们看看解析器本身的代码。首先获取输入的第一个字符：`input.chars().next()` 。我们并没有尝试性的依赖标准库来避免带来 `Unicode` 的问题——我们调用它为字符串的字符提供的一个 `chars()` 迭代器，然后从其中取出第一个字符。这就是一个 `char` 类型的项，并且通过 `Option` 包装着，即 `Option<char>` ，如果是 `None` 类型的 `Option` 则意味着我们获取到的是一个空字符串。

To make matters worse, a `char` isn't necessarily even what you think of as a character in Unicode. That would most likely be what Unicode calls a "[grapheme cluster](http://www.unicode.org/glossary/#grapheme_cluster)," which can be composed of several `char`s, which in fact represent "[scalar values](http://www.unicode.org/glossary/#unicode_scalar_value)," about two levels down from grapheme clusters. However, that way lies madness, and for our purposes we honestly aren't even likely to see any `char`s outside the ASCII set, so let's leave it there.
更糟糕的是，获取到的字符甚至可能不是我们想象中的 `Unicode` 字符。这很可能就是 `Unicode` 中的 "[grapheme cluster](http://www.unicode.org/glossary/#grapheme_cluster)" ，它可以由几个 `char` 类型的字符组成，这些字符实际上表示 "[scalar values](http://www.unicode.org/glossary/#unicode_scalar_value)" ，它比 "grapheme cluster" 差不多还低2个层次。但是，这种方法未免也太激进了，就我们的目的而言，我们甚至不太可能看到 `ASCII` 字符集以外的字符，所以暂且不管这个问题。

We pattern match on `Some('a')`, which is the specific result we're looking for, and if that matches, we return our success value: `Ok((&input['a'.len_utf8()..], ()))`. That is, we remove the bit we just parsed (the `'a'`) from the string slice and return the rest, along with our parsed value, which is just the empty `()`. Ever mindful of the Unicode monster, we ask the standard library for the length of `'a'` in UTF-8 before slicing - it's 1, but never, ever presume about the Unicode monster.
我们匹配一下 `Some('a')`，这就是我们正在寻找的特定结果，如果匹配成功，我们将返回成功 `Ok((&input['a'.len_utf8]()..], ()))` 。也就是说，我们从字符串 slice 中移出的解析的项（ 'a' ），并返回其余的字符，以及解析后的值，也就是 `()` 类型。考虑到 `Unicode` 字符集问题，在对字符串 `slice` 前，我们用标准库中的方法查询一下字符 `a` 在 UTF-8 中的长度——长度是1，但绝不要去猜测 Unicode 字符长度。

If we get any other `Some(char)`, or if we get `None`, we return an error. As you'll recall, our error type right now is just going to be the string slice at the point where parsing failed, which is the one that we got passed in as `input`. It didn't start with `a`, so that's our error. It's not a great error, but at least it's marginally better than just "something is wrong somewhere."
如果我们得到其他类型的结果 `Some(char)` ，或者 `None` ，我们将返回一个 error 。正如之前提到的，我们现在的错误类型就是解析失败时的字符串 `slice` ，也就是我们我们传入的输入。它不是以 `a` 开头，所以返回错误给我们。这不是一个很严重的错误，但至少比“一些地方出了严重错误”要好一些。

We don't actually need this parser to parse XML, though, but the first thing we need to do is look for that opening `<`, so we're going to need something very similar. We're also going to need to parse `>`, `/` and `=` specifically, so maybe we can make a function which builds a parser for the character we want?
实际上，尽管我们不需要这个解析器解析这个 `XML` ，但是我们需要做的第一件事是寻找开始的 `<` ，所以我们需要一些类似的东西。特别的，我们还需要解析 `>` ,`/` 和 `=` ，所以，也许我们可以创建一个函数来构建一个解析器来解析我们想要解析的字符。

### A Parser Builder

Let's even get fancy about this: let's write a function that produces a parser for a static string of **any** length, not just a single character. It's even sort of easier that way, because a string slice is already a valid UTF-8 string slice, and we don't have to think about the Unicode monster.

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

Now this looks a bit different.

First of all, let's look at the types. Instead of our function looking like a parser, now it takes our `expected` string as an argument, and **returns** something that looks like a parser. It's a function that returns a function - in other words, a **higher order** function. Basically, we're writing a function that **makes** a function like our `the_letter_a` function from before.

So, instead of doing the work in the function body, we return a closure that does the work, and that matches our type signature for a parser from previously.

The pattern match looks the same, except we can't match on our string literal directly because we don't know what it is specifically, so we use a match condition `if next == expected` instead. Otherwise it's exactly the same as before, it's just inside the body of a closure.

### Testing Our Parser

Let's write a test for this to make sure we got it right.

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

First, we build the parser: `match_literal("Hello Joe!")`. This should consume the string `"Hello Joe!"` and return the remainder of the string, or it should fail and return the whole string.

In the first case, we just feed it the exact string it expects, and we see that it returns an empty string and the `()` value that means "we parsed the expected string and you don't really need it returned back to you."

In the second, we feed it the string `"Hello Joe! Hello Robert!"`, and we see that it does indeed consume the string `"Hello Joe!"` and returns the remainder of the input: `" Hello Robert!"` (leading space and all).

In the third, we feed it some incorrect input, `"Hello Mike!"`, and note that it does indeed reject the input with an error. Not that Mike is incorrect as a general rule, he's just not what this parser was looking for.

### A Parser For Something Less Specific

So that lets us parse `<`, `>`, `=` and even `</` and `/>`. We're practically done already!

The next bit after the opening `<` is the element name. We can't do this with a simple string comparison. But we **could** do it with a regular expression…

…but let's restrain ourselves. It's going to be a regular expression that would be very easy to replicate in simple code, and we don't really need to pull in the `regex` crate just for this. Let's see if we can write our own parser for this using nothing but Rust's standard library.

Recalling the rule for the element name identifier, it's as follows: one alphabetical character, followed by zero or more of either an alphabetical character, a number, or a dash `-`.

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

As always, we look at the type first. This time we're not writing a function to build a parser, we're just writing the parser itself, like our first time. The notable difference here is that instead of a result type of `()`, we're returning a `String` in the tuple along with the remaining input. This `String` is going to contain the identifier we've just parsed.

With that in mind, first we create an empty `String` and call it `matched`. This is going to be our result value. We also get an iterator over the characters in `input`, which we're going to start pulling apart.

The first step is to see if there's a letter up front. We pull the first character off the iterator and check if it's a letter: `next.is_alphabetic()`. Rust's standard library is of course here to help us with the Unicodes - this is going to match letters in any alphabet, not just ASCII. If it's a letter, we push it into our `matched` `String`, and if it's not, well, clearly we're not looking at an element identifier, so we return immediately with an error.

For the second step, we keep pulling characters off the iterator, pushing them onto the `String` we're building, until we find one that isn't either `is_alphanumeric()` (that's like `is_alphabetic()` except it also matches numbers in any alphabet) or a dash `'-'`.

The first time we see something that doesn't match those criteria, that means we're done parsing, so we break out of the loop and return the `String` we've built, remembering to slice off the bit we've consumed from the `input`. Likewise if the iterator runs out of characters, which means we hit the end of the input.

It's worth noting that we don't return with an error when we see something that isn't alphanumeric or a dash. We've already got enough to make a valid identifier once we've matched that first letter, and it's perfectly normal for there to be more things to parse in the input string after we've parsed our identifier, so we just stop parsing and return our result. It's only if we can't find even that first letter that we actually return an error, because in that case there was definitely not an identifier here.

Remember that `Element` struct we're going to parse our XML document into?

```
struct Element {
    name: String,
    attributes: Vec<(String, String)>,
    children: Vec<Element>,
}
```

We actually just finished the parser for the first part of it, the `name` field. The `String` our parser returns goes right in there. It's also the right parser for the first part of every `attribute`.

Let's test that.

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

We see that in the first case, the string `"i-am-an-identifier"` is parsed in its entirety, leaving only the empty string. In the second case, the parser returns `"not"` as the identifier, and the rest of the string is returned as the remaining input. In the third case, the parser fails outright because the first character it finds is not a letter.

### Combinators

So now we can parse the opening `<`, and we can parse the following identifier, but we need to parse **both**, in order, to be able to make progress here. So the next step will be to write another parser builder function, but one that takes two **parsers** as input and returns a new parser which parses both of them in order. In other words, a parser **combinator**, because it combines two parsers into a new one. Let's see if we can do that.

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

It's getting slightly complicated here, but you know what to do: start by looking at the types.

First of all, we have four type variables: `P1`, `P2`, `R1` and `R2`. That's Parser 1, Parser 2, Result 1 and Result 2. `P1` and `P2` are functions, and you'll notice that they follow the well established pattern of parser functions: just like the return value, they take a `&str` as input and return a `Result` of a pair of the remaining input and the result, or an error.

But look at the result types of each function: `P1` is a parser that produces an `R1` if successful, and `P2` likewise produces an `R2`. And the result of the final parser - the one returned from our function - is `(R1, R2)`. So the job of this parser is to first run the parser `P1` on the input, keep its result, then run `P2` on the input that `P1` returned, and if both of those worked out, we combine the two results into a tuple `(R1, R2)`.

Looking at the code, we see that this is exactly what it does, too. We start by running the first parser on the input, then the second parser, then we combine the two results into a tuple and return that. If either of those parsers fail, we return immediately with the error it gave.

This way, we should be able to combine our two parsers from before, `match_literal` and `identifier`, to actually parse the first bit of our first XML tag. Let's write a test to see if it works.

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

It seems to work! But look at that result type: `((), String)`. It's obvious that we only care about the right hand value here, the `String`. This is going to be the case rather a lot - some of our parsers only match patterns in the input without producing values, and so their outputs can be safely ignored. To accommodate this pattern, we're going to use our `pair` combinator to write two other combinators: `left`, which discards the result of the first parser and only returns the second, and its opposite number, `right`, which is the one we'd have wanted to use in our test above instead of `pair` - the one that discards that `()` on the left hand side of the pair and only keeps our `String`.

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
