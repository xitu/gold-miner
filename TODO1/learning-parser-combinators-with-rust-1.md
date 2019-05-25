> * 原文地址：[Learning Parser Combinators With Rust](https://bodil.lol/parser-combinators/)
> * 原文作者：[Bodil](https://bodil.lol/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/learning-parser-combinators-with-rust-1.md](https://github.com/xitu/gold-miner/blob/master/TODO1/learning-parser-combinators-with-rust-1.md)
> * 译者：
> * 校对者：

# Learning Parser Combinators With Rust - Part 1

This article teaches the fundamentals of parser combinators to people who are already Rust programmers. It assumes no other knowledge, and will explain everything that isn't directly related to Rust, as well as a few of the more unexpected aspects of using Rust for this purpose. It will not teach you Rust if you don't already know it, and, if so, it probably also won't teach you parser combinators very well. If you would like to learn Rust, I recommend the book [The Rust Programming Language](https://doc.rust-lang.org/book/).

### Beginner's Mind

There comes a point in the life of every programmer when they find themselves in need of a parser.

The novice programmer will ask, "what is a parser?"

The intermediate programmer will say, "that's easy, I'll write a regular expression."

The master programmer will say, "stand back, I know lex and yacc."

The novice has the right idea.

Not that regular expressions aren't great. (But please don't try writing a complicated parser as a regular expression.) Not that there's no joy to be had in employing powerful tools like parser and lexer generators that have been honed to perfection over millennia. But learning about parsers from the ground up is **fun**. It's also something you'll be missing out on if you stampede directly towards regular expressions or parser generators, both of which are only abstractions over the real problem at hand. In the beginner's mind, [as the man said](https://en.wikipedia.org/wiki/Shunry%C5%AB_Suzuki#Quotations), there are many possibilities. In the expert's mind, there's only the one the expert got used to.

In this article, we're going to learn how to build a parser from the ground up using a technique common in functional programming languages known as **parser combinators**. They have the advantage of being remarkably powerful once you grasp the basic idea of them, while at the same time staying very close to first principles, as the only abstractions here will be the ones you build yourself on top of the basic combinators - all of which you'll also have to build before you get to use them.

### How To Work Through This Article

It's highly recommended that you start a fresh Rust project and type the code snippets into `src/lib.rs` as you read (you can paste it directly from the page, but typing it in is better, as the act of doing so automatically ensures you read the code in its entirety). Every piece of code you're going to need is introduced by the article in order. Mind that it sometimes introduces **changed** versions of functions you've written previously, and that in these cases you should replace the old version with the new one.

The code was written for `rustc` version 1.34.0 using the 2018 edition of the language. You should be able to follow along using any version of the compiler that is more recent, as long as you make sure you're using the 2018 edition (check that your `Cargo.toml` contains `edition = "2018"`). The code needs no external dependencies.

To run the tests introduced in the article, as you might expect, you use `cargo test`.

### The Xcruciating Markup Language

We're going to write a parser for a simplified version of XML. It looks like this:

```
<parent-element>
  <single-element attribute="value" />
</parent-element>
```

XML elements open with the symbol `<` and an identifier consisting of a letter followed by any number of letters, numbers and `-`. This is followed by some whitespace, and an optional list of attribute pairs: another identifier as defined previously, followed by a `=` and a double quoted string. Finally, there is either a closing `/>` to signify a single element with no children, or a `>` to signify there is a sequence of child elements following, and finally a closing tag starting with `</`, followed by an identifier which must match the opening tag, and a final `>`.

That's all we're going to support. No namespaces, no text nodes, none of the rest, and **definitely** no schema validation. We're not even going to bother supporting escape quotes for those strings - they start at the first double quote and they end at the next one, and that's it. If you want double quotes inside your actual strings, you can take your unreasonable demands somewhere else.

We're going to parse those elements into a struct that looks like this:

```
#[derive(Clone, Debug, PartialEq, Eq)]
struct Element {
    name: String,
    attributes: Vec<(String, String)>,
    children: Vec<Element>,
}
```

No fancy types, just a string for a name (that's the identifier at the start of each tag), attributes as pairs of strings (identifier and value), and a list of child elements that look exactly the same as the parent.

(If you're typing along, make sure you include those derives. You're going to need them later.)

### Defining The Parser

Well, then, it's time to write the parser.

Parsing is a process of deriving structure from a stream of data. A parser is something which teases out that structure.

In the discipline we're about to explore, a parser, in its simplest form, is a function which takes some input and returns either the parsed output along with the remainder of the input, or an error saying "I couldn't parse this."

It turns out that's also, in a nutshell, what a parser looks like in its more complicated forms. You might complicate what the input, the output and the error all mean, and if you're going to have good error messages you'll need to, but the parser stays the same: something that consumes input and either produces some parsed output along with what's left of the input or lets you know it couldn't parse the input into the output.

Let's write that down as a function type.

```
Fn(Input) -> Result<(Input, Output), Error>
```

More concretely, in our case, we'll want to fill out the types so we get something like this, because what we're about to do is convert a string into an `Element` struct, and at this point we don't want to get into the intricacies of error reporting, so we'll just return the bit of the string that we couldn't parse as an error:

```
Fn(&str) -> Result<(&str, Element), &str>
```

We use a string slice because it's an efficient pointer to a piece of a string, and we can slice it up further however we please, "consuming" the input by slicing off the bit that we've parsed and returning the remainder along with the result.

It might have been cleaner to use `&[u8]` (a slice of bytes, corresponding to characters if we restrict ourselves to ASCII) as the input type, especially because string slices behave a little differently from most slices - especially in that you can't index them with a single number `input[0]`, you have to use a slice `input[0..1]`. On the other hand, they have a lot of methods that are useful for parsing strings that slices of bytes don't have.

In fact, in general we're going to be relying on those methods rather than indexing it like that, because, well, Unicode. In UTF-8, and all Rust strings are UTF-8, these indexes don't always correspond to single characters, and it's better for all parties concerned that we ask the standard library to just please deal with this for us.

### Our First Parser

Let's try writing a parser which just looks at the first character in the string and decides whether or not it's the letter `a`.

```
fn the_letter_a(input: &str) -> Result<(&str, ()), &str> {
  match input.chars().next() {
      Some('a') => Ok((&input['a'.len_utf8()..], ())),
      _ => Err(input),
  }
}
```

First, let's look at the input and output types: we take a string slice as input, as we've discussed, and we return a `Result` of either `(&str, ())` or the error type `&str`. The pair of `(&str, ())` is the interesting bit: as we've talked about, we're supposed to return a tuple with the next bit of input to parse and the result. The `&str` is the next input, and the result is just the unit type `()`, because if this parser succeeds, it could only have had one result (we found the letter `a`), and we don't particularly need to return the letter `a` in this case, we just need to indicate that we succeeded in finding it.

And so, let's look at the code for the parser itself. We start by getting the first character of the input: `input.chars().next()`. We weren't kidding about leaning on the standard library to avoid giving us Unicode headaches - we ask it to get us an iterator `chars()` over the characters of the string, and we pull the first item off it. This will be an item of type `char`, wrapped in an `Option`, so `Option<char>`, where `None` means we tried to pull a `char` off an empty string.

To make matters worse, a `char` isn't necessarily even what you think of as a character in Unicode. That would most likely be what Unicode calls a "[grapheme cluster](http://www.unicode.org/glossary/#grapheme_cluster)," which can be composed of several `char`s, which in fact represent "[scalar values](http://www.unicode.org/glossary/#unicode_scalar_value)," about two levels down from grapheme clusters. However, that way lies madness, and for our purposes we honestly aren't even likely to see any `char`s outside the ASCII set, so let's leave it there.

We pattern match on `Some('a')`, which is the specific result we're looking for, and if that matches, we return our success value: `Ok((&input['a'.len_utf8()..], ()))`. That is, we remove the bit we just parsed (the `'a'`) from the string slice and return the rest, along with our parsed value, which is just the empty `()`. Ever mindful of the Unicode monster, we ask the standard library for the length of `'a'` in UTF-8 before slicing - it's 1, but never, ever presume about the Unicode monster.

If we get any other `Some(char)`, or if we get `None`, we return an error. As you'll recall, our error type right now is just going to be the string slice at the point where parsing failed, which is the one that we got passed in as `input`. It didn't start with `a`, so that's our error. It's not a great error, but at least it's marginally better than just "something is wrong somewhere."

We don't actually need this parser to parse XML, though, but the first thing we need to do is look for that opening `<`, so we're going to need something very similar. We're also going to need to parse `>`, `/` and `=` specifically, so maybe we can make a function which builds a parser for the character we want?

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

### Enter The Functor

But before we go that far, let's introduce another combinator that's going to make writing these two a lot simpler: `map`.

This combinator has one purpose: to change the type of the result. For instance, let's say you have a parser that returns `((), String)` and you wanted to change it to return just that `String`, you know, just as an arbitrary example.

To do that, we pass it a function that knows how to convert from the original type to the new one. In our example, that's easy: `|(_left, right)| right`. More generalised, it would look like `Fn(A) -> B` where `A` is the original result type of the parser and `B` is the new one.

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

And what do the types say? `P` is our parser. It returns `A` on success. `F` is the function we're going to use to map `P` into our return value, which looks the same as `P` except its result type is `B` instead of `A`.

In the code, we run `parser(input)` and, if it succeeds, we take the `result` and run our function `map_fn(result)` on it, turning the `A` into a `B`, and that's our converted parser done.

Actually, let's indulge ourselves and shorten this function a bit, because this `map` thing turns out to be a common pattern that `Result` actually implements too:

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

This pattern is what's called a "functor" in Haskell and its mathematical sibling, category theory. If you've got a thing with a type `A` in it, and you have a `map` function available that you can pass a function from `A` to `B` into to turn it into the same kind of thing but with the type `B` in it instead, that's a functor. You see this a lot of places in Rust, such as in [`Option`](https://doc.rust-lang.org/std/option/enum.Option.html#method.map), [`Result`](https://doc.rust-lang.org/std/result/enum.Result.html#method.map), [`Iterator`](https://doc.rust-lang.org/std/iter/trait.Iterator.html#method.map) and even [`Future`](https://docs.rs/futures/0.1.26/futures/future/trait.Future.html#method.map), without it being explicitly named as such. And there's a good reason for that: you can't really express a functor as a generalised thing in Rust's type system, because it lacks higher kinded types, but that's another story, so let's just note that these are functors, and you just need to look for the `map` function to spot one.

### Time For A Trait

You might have noticed by now that we keep repeating the shape of the parser type signature: `Fn(&str) -> Result<(&str, Output), &str>`. You may be getting as sick of reading it written out full like that as I'm getting of writing it, so I think it's time to introduce a trait, to make things a little more readable, and to let us add some extensibility to our parsers.

But first of all, let's make a type alias for that return type we keep using:

```
type ParseResult<'a, Output> = Result<(&'a str, Output), &'a str>;
```

So that now, instead of typing that monstrosity out all the time, we can just type `ParseResult<String>` or similar. We've added a lifetime there, because the type declaration requires it, but a lot of the time the Rust compiler should be able to infer it for you. As a rule, try leaving the lifetime out and see if rustc gets upset, then just put it in if it does.

The lifetime `'a`, in this case, refers specifically to the lifetime of the **input**.

Now, for the trait. We need to put the lifetime in here as well, and when you're using the trait the lifetime is usually always required. It's a bit of extra typing, but it beats the previous version.

```
trait Parser<'a, Output> {
    fn parse(&self, input: &'a str) -> ParseResult<'a, Output>;
}
```

It has just the one method, for now: the `parse()` method, which should look familiar: it's the same as the parser function we've been writing.

To make this even easier, we can actually implement this trait for any function that matches the signature of a parser:

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

This way, not only can we pass around the same functions we've been passing around so far as parsers fully implementing the `Parser` trait, we also open up the possibility to use other kinds of types as parsers.

But, more importantly, it saves us from having to type out those function signatures all the time. Let's rewrite the `map` function to see how it works out.

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

One thing to note here in particular: instead of calling the parser as a function directly, we now have to go `parser.parse(input)`, because we don't know if the type `P` is a function, we just knows that it implements `Parser`, and so we have to stick with the interface `Parser` provides. Otherwise, the function body looks exactly the same, and the types look a lot tidier. There's the new lifetime `'a'` for some extra noise, but overall it's quite an improvement.

If we rewrite the `pair` function in the same way, it's even more tidy now:

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

Same thing here: the only changes are the tidied up type signatures and the need to go `parser.parse(input)` instead of `parser(input)`.

Actually, let's tidy up `pair`'s function body too, the same way we did with `map`.

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

The `and_then` method on `Result` is similar to `map`, except that the mapping function doesn't return the new value to go inside the `Result`, but a new `Result` altogether. The code above is identical in effect to the previous version written out with all those `match` blocks. We're going to get back to `and_then` later, but in the here and now, let's actually get those `left` and `right` combinators implemented, now that we have a nice and tidy `map`.

### Left And Right

With `pair` and `map` in place, we can write `left` and `right` very succinctly:

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

We use the `pair` combinator to combine the two parsers into a parser for a tuple of their results, and then we use the `map` combinator to select just the part of the tuple we want to keep.

Rewriting our test for the first two pieces of our element tag, it's now just a little bit cleaner, and in the process we've gained some important new parser combinator powers.

We have to update our two parsers to use `Parser` and `ParseResult` first, though. `match_literal` is the more complicated one:

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

## Licence

This work is copyright Bodil Stokke and is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International Licence. To view a copy of this licence, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.

## Footnotes

1: He isn't really your uncle.
2: Please don't be that person at parties.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
