> * 原文地址：[Learning Parser Combinators With Rust](https://bodil.lol/parser-combinators/)
> * 原文作者：[Bodil](https://bodil.lol/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/learning-parser-combinators-with-rust-3.md](https://github.com/xitu/gold-miner/blob/master/TODO1/learning-parser-combinators-with-rust-3.md)
> * 译者：
> * 校对者：

# Learning Parser Combinators With Rust - Part 3

如果你没看过本系列的其他几篇文章，建议你按照顺序进行阅读：

- [Learning Parser Combinators With Rust - Part 1](https://github.com/xitu/gold-miner/blob/master/TODO1/learning-parser-combinators-with-rust-1.md)
- [Learning Parser Combinators With Rust - Part 2](https://github.com/xitu/gold-miner/blob/master/TODO1/learning-parser-combinators-with-rust-2.md)
- [Learning Parser Combinators With Rust - Part 3](https://github.com/xitu/gold-miner/blob/master/TODO1/learning-parser-combinators-with-rust-3.md)
- [Learning Parser Combinators With Rust - Part 4](https://github.com/xitu/gold-miner/blob/master/TODO1/learning-parser-combinators-with-rust-4.md)

### A Predicate Combinator

We now have the building blocks we need to parse that whitespace with `one_or_more`, and to parse the attribute pairs with `zero_or_more`.

Actually, hold on a moment. We don't really want to parse the whitespace **then** parse the attributes. If you think about it, if there are no attributes, the whitespace is optional, and we could encounter an immediate `>` or `/>`. But if there's an attribute, there **must** be whitespace first. Lucky for us, there must also be whitespace between each attribute, if there are several, so what we're really looking at here is a sequence of **zero or more** occurrences of **one or more** whitespace items followed by the attribute.

We need a parser for a single item of whitespace first. We can go one of three ways here.

One, we can be silly and use our `match_literal` parser with a string containing just a single space. Why is that silly? Because whitespace is also line breaks, tabs and a whole number of strange Unicode characters which render as whitespace. We're going to have to lean on Rust's standard library again, and of course `char` has an `is_whitespace` method just like it had `is_alphabetic` and `is_alphanumeric`.

Two, we can just write out a parser which consumes any number of whitespace characters using the `is_whitespace` predicate much like we wrote our `identifier` earlier.

Three, we can be clever, and we do like being clever. We could write a parser `any_char` which returns a single `char` as long as there is one left in the input, and a combinator `pred` which takes a parser and a predicate function, and combine the two like this: `pred(any_char, |c| c.is_whitespace())`. This has the added bonus of making it really easy to write the final parser we're going to need too: the quoted string for the attribute values.

The `any_char` parser is straightforward as a parser, but we have to remember to be mindful of those UTF-8 gotchas.

```
fn any_char(input: &str) -> ParseResult<char> {
    match input.chars().next() {
        Some(next) => Ok((&input[next.len_utf8()..], next)),
        _ => Err(input),
    }
}
```

And the `pred` combinator also doesn't hold any surprises to our now seasoned eyes. We invoke the parser, then we call our predicate function on the value if the parser succeeded, and only if that returns true do we actually return a success, otherwise we return as much of an error as a failed parse would.

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

And a quick test to make sure everything is in order:

```
#[test]
fn predicate_combinator() {
    let parser = pred(any_char, |c| *c == 'o');
    assert_eq!(Ok(("mg", 'o')), parser.parse("omg"));
    assert_eq!(Err("lol"), parser.parse("lol"));
}
```

With these two in place, we can write our `whitespace_char` parser with a quick one-liner:

```
fn whitespace_char<'a>() -> impl Parser<'a, char> {
    pred(any_char, |c| c.is_whitespace())
}
```

And, now that we have `whitespace_char`, we can also express the idea we were heading towards, **one or more whitespace**, and its sister idea, **zero or more whitespace**. Let's indulge ourselves in some brevity and call them `space1` and `space0` respectively.

```
fn space1<'a>() -> impl Parser<'a, Vec<char>> {
    one_or_more(whitespace_char())
}

fn space0<'a>() -> impl Parser<'a, Vec<char>> {
    zero_or_more(whitespace_char())
}
```

### Quoted Strings

With all that sorted, can we now, at last, parse those attributes? Yes, we just need to make sure we have all the individual parsers for the components of the attributes. We've got `identifier` already for the attribute name (though it's tempting to rewrite it using `any_char` and `pred` plus our `*_or_more` combinators). The `=` is just `match_literal("=")`. We're short one quoted string parser, though, so let's build that. Fortunately, we've already got all the combinators we need to do it.

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

The nesting of combinators is getting slightly annoying at this point, but we're going to resist refactoring everything to fix it just for now, and instead focus on what's going on here.

The outermost combinator is a `map`, because of the aforementioned annoying nesting, and it's a terrible place to start if we're going to understand this one, so let's try and find where it really starts: the first quote character. Inside the `map`, there's a `right`, and the first part of the `right` is the one we're looking for: the `match_literal("\"")`. That's our opening quote.

The second part of that `right` is the rest of the string. That's inside the `left`, and we quickly note that the **right** hand argument of that `left`, the one we ignore, is the other `match_literal("\"")` - the closing quote. So the left hand part is our quoted string.

We take advantage of our new `pred` and `any_char` here to get a parser that accepts **anything but another quote**, and we put that in `zero_or_more`, so that what we're saying is as follows:

* one quote
* followed by zero or more things that are **not** another quote
* followed by another quote

And, between the `right` and the `left`, we discard the quotes from the result value and get our quoted string back.

But wait, that's not a string. Remember what `zero_or_more` returns? A `Vec<A>` for the inner parser's return type `A`. For `any_char`, that's `char`. What we've got, then, is not a string but a `Vec<char>`. That's where the `map` comes in: we use it to turn a `Vec<char>` into a `String` by leveraging the fact that you can build a `String` from an `Iterator<Item = char>`, so we can just call `vec_of_chars.into_iter().collect()` and, thanks to the power of type inference, we have our `String`.

Let's just write a quick test to make sure that's all right before we go on, because if we needed that many words to explain it, it's probably not something we should leave to our faith in ourselves as programmers.

```
#[test]
fn quoted_string_parser() {
    assert_eq!(
        Ok(("", "Hello Joe!".to_string())),
        quoted_string().parse("\"Hello Joe!\"")
    );
}
```

So, now, finally, I swear, let's get those attributes parsed.

### At Last, Parsing Attributes

We can now parse whitespace, identifiers, `=` signs and quoted strings. That, finally, is all we need for parsing attributes.

First, let's write a parser for an attribute pair. We're going to be storing them as a `Vec<(String, String)>`, as you may recall, so it feels like we'd need a parser for that `(String, String)` to feed to our trusty `zero_or_more` combinator. Let's see if we can build one.

```
fn attribute_pair<'a>() -> impl Parser<'a, (String, String)> {
    pair(identifier, right(match_literal("="), quoted_string()))
}
```

Without even breaking a sweat! To summarise: we already have a handy combinator for parsing a tuple of values, `pair`, so we use that with the `identifier` parser, yielding a `String`, and a `right` with the `=` sign, whose value we don't want to keep, and our fresh `quoted_string` parser, which gets us the other `String`.

Now, let's combine that with `zero_or_more` to build that vector - but let's not forget that whitespace in between them.

```
fn attributes<'a>() -> impl Parser<'a, Vec<(String, String)>> {
    zero_or_more(right(space1(), attribute_pair()))
}
```

Zero or more occurrences of the following: one or more whitespace characters, then an attribute pair. We use `right` to discard the whitespace and keep the attribute pair.

Let's test it.

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

Actually, no, at this point in the narrative, my rustc was complaining that my types are getting terribly complicated, and that I need to increase the max allowed type size to carry on. It's a good chance you're getting the same error at this point, and if you are, you need to know how to deal with it. Fortunately, in these situations, rustc generally gives good advice, so when it tells you to add `#![type_length_limit = "…some big number…"]` to the top of your file, just do as it says. Actually, just go ahead and make it `#![type_length_limit = "16777216"]`, which is going to let us carry on a bit further into the stratosphere of complicated types. Full steam ahead, we're type astronauts now!

### So Close Now

At this point, things seem like they're just about to start coming together, which is a bit of a relief, as our types are fast approaching NP-completeness. We just have the two versions of the element tag to deal with: the single element and the parent element with children, but we're feeling pretty confident that once we have those, parsing the children will be just a matter of `zero_or_more`, right?

So let's do the single element first, deferring the question of children for a little bit. Or, even better, let's first write a parser for everything the two have in common: the opening `<`, the element name, and the attributes. Let's see if we can get a result type of `(String, Vec<(String, String)>)` out of a couple of combinators.

```
fn element_start<'a>() -> impl Parser<'a, (String, Vec<(String, String)>)> {
    right(match_literal("<"), pair(identifier, attributes()))
}
```

With that in place, we can quickly tack the tag closer on it to make a parser for the single element.

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

Hooray, it feels like we're within reach of our goal - we're actually constructing an `Element` now!

Let's test this miracle of modern technology.

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
