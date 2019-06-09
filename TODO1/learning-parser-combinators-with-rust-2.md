> * 原文地址：[Learning Parser Combinators With Rust](https://bodil.lol/parser-combinators/)
> * 原文作者：[Bodil](https://bodil.lol/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/learning-parser-combinators-with-rust-2.md](https://github.com/xitu/gold-miner/blob/master/TODO1/learning-parser-combinators-with-rust-2.md)
> * 译者：
> * 校对者：

# Learning Parser Combinators With Rust - Part 2

如果你没看过本系列的其他几篇文章，建议你按照顺序进行阅读：

- [Learning Parser Combinators With Rust - Part 1](https://github.com/xitu/gold-miner/blob/master/TODO1/learning-parser-combinators-with-rust-1.md)
- [Learning Parser Combinators With Rust - Part 2](https://github.com/xitu/gold-miner/blob/master/TODO1/learning-parser-combinators-with-rust-2.md)
- [Learning Parser Combinators With Rust - Part 3](https://github.com/xitu/gold-miner/blob/master/TODO1/learning-parser-combinators-with-rust-3.md)
- [Learning Parser Combinators With Rust - Part 4](https://github.com/xitu/gold-miner/blob/master/TODO1/learning-parser-combinators-with-rust-4.md)

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
