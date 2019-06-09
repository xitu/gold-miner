> * 原文地址：[Learning Parser Combinators With Rust](https://bodil.lol/parser-combinators/)
> * 原文作者：[Bodil](https://bodil.lol/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/learning-parser-combinators-with-rust-4.md](https://github.com/xitu/gold-miner/blob/master/TODO1/learning-parser-combinators-with-rust-4.md)
> * 译者：
> * 校对者：

# Learning Parser Combinators With Rust - Part 4

如果你没看过本系列的其他几篇文章，建议你按照顺序进行阅读：

- [Learning Parser Combinators With Rust - Part 1](https://github.com/xitu/gold-miner/blob/master/TODO1/learning-parser-combinators-with-rust-1.md)
- [Learning Parser Combinators With Rust - Part 2](https://github.com/xitu/gold-miner/blob/master/TODO1/learning-parser-combinators-with-rust-2.md)
- [Learning Parser Combinators With Rust - Part 3](https://github.com/xitu/gold-miner/blob/master/TODO1/learning-parser-combinators-with-rust-3.md)
- [Learning Parser Combinators With Rust - Part 4](https://github.com/xitu/gold-miner/blob/master/TODO1/learning-parser-combinators-with-rust-4.md)

### An Opportunity Presents Itself

But, just a moment, this presents us with an opportunity to fix another thing that's starting to become a bit of a bother.

Remember the last couple of parsers we wrote? Because our combinators are standalone functions, when we nest a nontrivial number of them, our code starts getting a little bit unreadable. Recall our `quoted_string` parser:

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

It would read a lot better if we could make those combinators methods on the parser instead of standalone functions. What if we could declare our combinators as methods on the `Parser` trait?

The problem is that if we do that, we lose the ability to lean on `impl Trait` for our return types, because `impl Trait` isn't allowed in trait declarations.

…but now we have `BoxedParser`. We can't declare a trait method that returns `impl Parser<'a, A>`, but we most certainly **can** declare one that returns `BoxedParser<'a, A>`.

The best part is that we can even declare these with default implementations, so that we don't have to reimplement every combinator for every type that implements `Parser`.

Let's try it out with `map`, by extending our `Parser` trait as follows:

```
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

That's a lot of `'a`s, but, alas, they're all necessary. Luckily, we can still reuse our old combinator functions unchanged - and, as an added bonus, not only do we get a nicer syntax for applying them, we also get rid of the explosive `impl Trait` types by boxing them up automatically.

Now we can improve our `quoted_string` parser slightly:

```
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

It's now more obvious at first glance that the `.map()` is being called on the result of the `right()`.

We could also give `pair`, `left` and `right` the same treatment, but in the case of these three, I think it reads easier when they're functions, because they mirror the structure of `pair`'s output type. If you disagree, it's entirely possible to add them to the trait just like we did with `map`, and you're very welcome to go ahead and try it out as an exercise.

Another prime candidate, though, is `pred`. Let's add a definition for it to the `Parser` trait:

```
fn pred<F>(self, pred_fn: F) -> BoxedParser<'a, Output>
where
    Self: Sized + 'a,
    Output: 'a,
    F: Fn(&Output) -> bool + 'a,
{
    BoxedParser::new(pred(self, pred_fn))
}
```

This lets us rewrite the line in `quoted_string` with the `pred` call like this:

```
zero_or_more(any_char.pred(|c| *c != '"')),
```

I think that reads a little nicer, and I think we'll leave the `zero_or_more` as it is too - it reads like "zero or more of `any_char` with the following predicate applied," and that sounds about right to me. Once again, you can also go ahead and move `zero_or_more` and `one_or_more` into the trait if you prefer to go all in.

In addition to rewriting `quoted_string`, let's also fix up the `map` in `single_element`:

```
fn single_element<'a>() -> impl Parser<'a, Element> {
    left(element_start(), match_literal("/>")).map(|(name, attributes)| Element {
        name,
        attributes,
        children: vec![],
    })
}
```

Let's try and uncomment back `element_start` and the tests we commented out earlier and see if things got better. Get that code back in the game and try running the tests…

…and, yep, compilation time is back to normal now. You can even go ahead and remove that type size setting at the top of your file, you're not going to need it any more.

And that was just from boxing two `map`s and a `pred` - **and** we got a nicer syntax out of it!

### Having Children

Now let's write the parser for the opening tag for a parent element. It's almost identical to `single_element`, except it ends in a `>` rather than a `/>`. It's also followed by zero or more children and a closing tag, but first we need to parse the actual opening tag, so let's get that done.

```
fn open_element<'a>() -> impl Parser<'a, Element> {
    left(element_start(), match_literal(">")).map(|(name, attributes)| Element {
        name,
        attributes,
        children: vec![],
    })
}
```

Now, how do we get those children? They're going to be either single elements or parent elements themselves, and there are zero or more of them, so we have our trusty `zero_or_more` combinator, but what do we feed it? One thing we haven't dealt with yet is a multiple choice parser: something that parses **either** a single element **or** a parent element.

To get there, we need a combinator which tries two parsers in order: if the first parser succeeds, we're done, we return its result and that's it. If it fails, instead of returning an error, we try the second parser **on the same input**. If that succeeds, great, and if it doesn't, we return the error too, as that means both our parsers have failed, and that's an overall failure.

```
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

This allows us to declare a parser `element` which matches either a single element or a parent element (and, for now, let's just use `open_element` to represent it, and we'll deal with the children once we have `element` down).

```
fn element<'a>() -> impl Parser<'a, Element> {
    either(single_element(), open_element())
}
```

Now let's add a parser for the closing tag. It has the interesting property of having to match the opening tag, which means the parser has to know what the name of the opening tag is. But that's what function arguments are for, yes?

```
fn close_element<'a>(expected_name: String) -> impl Parser<'a, String> {
    right(match_literal("</"), left(identifier, match_literal(">")))
        .pred(move |name| name == &expected_name)
}
```

That `pred` combinator is proving really useful, isn't it?

And now, let's put it all together for the full parent element parser, children and all:

```
fn parent_element<'a>() -> impl Parser<'a, Element> {
    pair(
        open_element(),
        left(zero_or_more(element()), close_element(…oops)),
    )
}
```

Oops. How do we pass that argument to `close_element` now? I think we're short one final combinator.

We're so close now. Once we've solved this one last problem to get `parent_element` working, we should be able to replace the `open_element` placeholder in the `element` parser with our new `parent_element`, and that's it, we have a fully working XML parser.

Remember I said we'd get back to `and_then` later? Well, later is here. The combinator we need is, in fact, `and_then`: we need something that takes a parser, and a function that takes the result of a parser and returns a **new** parser, which we'll then run. It's a bit like `pair`, except instead of just collecting both results in a tuple, we thread them through a function. It's also just how `and_then` works with `Result`s and `Option`s, except it's a bit easier to follow because `Result`s and `Option`s don't really **do** anything, they're just things that hold some data (or not, as the case may be).

So let's try writing an implementation for it.

```
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

Looking at the types, there are a lot of type variables, but we know `P`, our input parser, which has a result type of `A`. Our function `F`, however, where `map` had a function from `A` to `B`, the crucial difference is that `and_then` takes a function from `A` to **a new parser** `NextP`, which has a result type of `B`. The final result type is `B`, so we can assume that whatever comes out of our `NextP` will be the final result.

The code is a bit less complicated: we start by running our input parser, and if it fails, it fails and we're done, but if if succeeds, now we call our function `f` on the result (of type `A`), and what comes out of `f(result)` is a new parser, with a result type of `B`. We run **this** parser on the next bit of input, and we return the result directly. If it fails, it fails there, and if it succeeds, we have our value of type `B`.

One more time: we run our parser of type `P` first, and if it succeeds, we call the function `f` with the result of parser `P` to get our next parser of type `NextP`, which we then run, and that's the final result.

Let's also add it straight away to the `Parser` trait, because this one, like `map`, is definitely going to read better that way.

```
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

OK, now, what's it good for?

First of all, we can **almost** implement `pair` using it:

```
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

It looks very neat, but there's a problem: `parser2.map()` consumes `parser2` to create the wrapped parser, and the function is a `Fn`, not a `FnOnce`, so it's not allowed to consume `parser2`, just take a reference to it. Rust Problems, in other words. In a higher level language where these things aren't an issue, this would have been a really neat way to define `pair`.

What we can do with it even in Rust, though, is use that function to lazily generate the right version of our `close_element` parser, or, in other words, we can get it to pass that argument into it.

Recalling our failed attempt:

```
fn parent_element<'a>() -> impl Parser<'a, Element> {
    pair(
        open_element(),
        left(zero_or_more(element()), close_element(…oops)),
    )
}
```

Using `and_then`, we can now get this right by using that function to build the right version of `close_element` on the spot.

```
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

It looks a bit more complicated now, because the `and_then` has to go on `open_element()`, where we find out the name that goes into `close_element`. This means that the rest of the parser after `open_element` all has to be constructed inside the `and_then` closure. Moreover, because that closure is now the sole recipient of the `Element` result from `open_element`, the parser we return also has to carry that info forward.

The inner closure, which we `map` over the generated parser, has a reference to the `Element` (`el`) from the outer closure. We have to `clone()` it because we're in a `Fn` and thus only have a reference to it. We take the result of the inner parser (our `Vec<Element>` of children) and add that to our cloned `Element`, and we return that as our final result.

All we need to do now is go back to our `element` parser and make sure we change `open_element` to `parent_element`, so it parses the whole element structure instead of just the start of it, and I believe we're done!

### Are You Going To Say The M Word Or Do I Have To?

Remember we talked about how the `map` pattern is called a "functor" on Planet Haskell?

The `and_then` pattern is another thing you see a lot in Rust, in generally the same places as `map`. It's called [`flat_map`](https://doc.rust-lang.org/std/iter/trait.Iterator.html#method.flat_map) on `Iterator`, but it's the same pattern as the rest.

The fancy word for it is "monad." If you've got a thing `Thing<A>`, and you have an `and_then` function available that you can pass a function from `A` to `Thing<B>` into, so that now you have a new `Thing<B>` instead, that's a monad.

The function might get called instantly, like when you have an `Option<A>`, we already know if it's a `Some(A)` or a `None`, so we apply the function directly if it's a `Some(A)`, giving us a `Some(B)`.

It might also be called lazily. For instance, if you have a `Future<A>` that is still waiting to resolve, instead of `and_then` immediately calling the function to create a `Future<B>`, instead it creates a new `Future<B>` which contains both the `Future<A>` and the function, and which then waits for `Future<A>` to finish. When it does, it calls the function with the result of the `Future<A>`, and Bob's your uncle[1](https://bodil.lol/parser-combinators/#footnote1), you get your `Future<B>` back. In other words, in the case of a `Future` you can think of the function you pass to `and_then` as a **callback function**, because it gets called with the result of the original future when it completes. It's also a little more interesting than that, because it returns a **new** `Future`, which may or may not have already been resolved, so it's a way to **chain** futures together.

As with functors, though, Rust's type system isn't currently capable of expressing monads, so let's only note that this pattern is called a monad, and that, rather disappointingly, it's got nothing at all to do with burritos, contrary to what they say on the internets, and move on.

### Whitespace, Redux

Just one last thing.

We should have a parser capable of parsing some XML now, but it's not very appreciative of whitespace. Arbitrary whitespace should be allowed between tags, so that we're free to insert line breaks and such between our tags (and whitespace should in principle be allowed between identifiers and literals, like `< div / >`, but let's skip that).

We should be able to put together a quick combinator for that with no effort at this point.

```
fn whitespace_wrap<'a, P, A>(parser: P) -> impl Parser<'a, A>
where
    P: Parser<'a, A>,
{
    right(space0(), left(parser, space0()))
}
```

If we wrap `element` in that, it will ignore all leading and trailing whitespace around `element`, which means we're free to use as many line breaks and as much indentation as we like.

```
fn element<'a>() -> impl Parser<'a, Element> {
    whitespace_wrap(either(single_element(), parent_element()))
}
```

### We're Finally There! [#](#we-re-finally-there)

I think we did it! Let's write an integration test to celebrate.

```
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

And one that fails because of a mismatched closing tag, just to make sure we got that bit right:

```
#[test]
fn mismatched_closing_tag() {
    let doc = r#"
        <top>
            <bottom/>
        </middle>"#;
    assert_eq!(Err("</middle>"), element().parse(doc));
}
```

The good news is that it returns the mismatched closing tag as the error. The bad news is that it doesn't actually **say** that the problem is a mismatched closing tag, just **where** the error is. It's better than nothing, but, honestly, as error messages go, it's still terrible. But turning this into a thing that actually gives good errors is the topic for another, and probably at least as long, article.

Let's focus on the good news: we wrote a parser from scratch using parser combinators! We know that a parser forms both a functor and a monad, so you can now impress people at parties with your daunting knowledge of category theory[2](https://bodil.lol/parser-combinators/#footnote2).

Most importantly, we now know how parser combinators work from the ground up. Nobody can stop us now!

### Victory Puppies

![](https://bodil.lol/parser-combinators/many-puppies.gif)

### Further Resources

First of all, I'm guilty of explaining monads to you in strictly Rusty terms, and I know that Phil Wadler would be very upset with me if I didn't point you towards [his seminal paper](https://homepages.inf.ed.ac.uk/wadler/papers/marktoberdorf/baastad.pdf) which goes into much more exciting detail about them - including how they relate to parser combinators.

The ideas in this article are extremely similar to the ideas behind the [`pom`](https://crates.io/crates/pom) parser combinator library, and if this has made you want to work with parser combinators in the same style, I can highly recommend it.

The state of the art in Rust parser combinators is still [`nom`](https://crates.io/crates/nom), to the extent that the aforementioned `pom` is clearly derivatively named (and there's no higher praise than that), but it takes a very different approach from what we've built here today.

Another popular parser combinator library for Rust is [`combine`](https://crates.io/crates/combine), which may be worth a look as well.

The seminal parser combinator library for Haskell is [Parsec](http://hackage.haskell.org/package/parsec).

Finally, I owe my first awareness of parser combinators to the book [**Programming in Haskell**](http://www.cs.nott.ac.uk/%7Epszgmh/pih.html) by Graham Hutton, which is a great read and has the positive side effect of also teaching you Haskell.

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
