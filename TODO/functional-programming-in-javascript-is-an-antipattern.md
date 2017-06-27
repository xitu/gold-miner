
> * 原文地址：[Functional programming in Javascript is an antipattern](https://hackernoon.com/functional-programming-in-javascript-is-an-antipattern-58526819f21e)
> * 原文作者：[Alex Dixon](https://hackernoon.com/@alexdixon)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/functional-programming-in-javascript-is-an-antipattern.md](https://github.com/xitu/gold-miner/blob/master/TODO/functional-programming-in-javascript-is-an-antipattern.md)
> * 译者：
> * 校对者：

# Functional programming in Javascript is an antipattern

---

![](https://cdn-images-1.medium.com/max/1600/1*Y6orLTOgb6JFfjVdANVgCQ.png)

## And Clojure is actually easier

After a few months writing Clojure I began writing Javascript again. As I was trying to write something ordinary, I had the following thoughts:

> “Is this variable ImmutableJS or Javascript?”

> “How do I map an object and get one back?”

> “If it’s Immutable, use <this function> with <this syntax>, otherwise use <a different version of the same function> with <different syntax and totally different behavior>.”

> “Can a React component’s state be an Immutable Map?”

> “Is lodash imported?”

> “`fromJS` then <write code> then `.toJS()`?”

They seemed unnecessary. But I imagine I’ve thought them a million times before and didn’t notice because it was all I knew.

I don’t think there’s a way to avoid this kind of thinking when writing Javascript using any combination of React, Redux, ImmutableJS, lodash, and functional programming libraries like lodash/fp and ramda.

I need the following in my head at all times:

- APIs for lodash, Immutable, lodash/fp, ramda, and native JS or some combination
- mutable programming techniques when working with Javascript data structures
- immutable programming techniques for Immutable data structures
- immutable programming with mutable Javascript data structures when working with Redux or React

If I manage to keep that in my head, I still run into a tangle of questions like the ones above. Immutable data, mutable data, and mutable-data-that-should-not-be-mutated are situational. So are function signatures and return values for commonly-used functions. There’s a different case in almost every line of code. I believe that’s intractable when using functional programming techniques in Javascript.

Libraries like Redux and React require immutability by convention. So even if I’m not using ImmutableJS, I have to remember “don’t mutate here”. Immutable transformations in Javascript are more difficult than they need to be. I feel like the language is fighting me every step of the way. Compounding that, Javascript doesn’t have basic functions like Object.map. So like more than [43 million of us last month](https://www.npmjs.com/package/lodash), I use lodash, which provides a lot of functions Javascript doesn’t have. Still, the API isn’t immutable-friendly. Some functions return new values, while others mutate the existing ones. Again, keeping things like this straight is unnecessary overhead. So is the fact that presumably, on top of Javascript, I need to know lodash, its function names, its signatures, its return values. And to top it off, its [“collection first, arguments last” approach is not ideal](https://www.youtube.com/watch?v=m3svKOdZijA) for functional programming.

If I use ramda or lodash/fp, that helps. It’s easy to compose functions and write clear and concise code. But I can’t use it with Immutable data structures. I will also probably have some code where the collection argument is last, and other times it’s the opposite. I have to know more function names, signatures, return values, and import more basic functions.

When I use ImmutableJS in isolation, some things are easier. Map.set returns a brand new value. Everything returns a brand new value! This is what I want. Unfortunately, ImmutableJS complects things too. I inevitably have two different sets of data structures to work with. So I have to know whether `x` is Immutable or Javascript. As a result of learning its API and its overall way of thinking, I can know how to solve a problem in 2 seconds using Immutable. When I’m working in native JS, I have to skip over that solution and solve the problem another way. Like ramda and lodash, I have a larger set of functions I need to know about — what they return, their signatures, their names . I also need to divide all the functions I know about into two categories: ones that work with Immutable, and ones that don’t. This tends to affect the way I solve problems too. I sometimes arrive at a solution automatically that uses curry and compose. But neither work with ImmutableJS. So I skip that solution and think of another.

After I figure all this out, I can attempt to write some code. Then I move to another file and do the same thing all over.

![](https://cdn-images-1.medium.com/max/1600/1*FVBc2DWB09sW6QJwMxm_fw.png)

Functional programming in Javascript.

![](https://cdn-images-1.medium.com/max/1600/1*MVU4TWwrkRMpQlmgkU9TuQ.png)

`Visualization of an antipattern.
I’m going out on a limb and calling functional programming in Javascript an antipattern. It’s an attractive path that gives way to a maze. It seems to solve some problems but ends up creating more. More importantly, those problems appear to have no higher-level solution that can prevent me from having to deal with them over and over again.

### What are the long term costs of this?

I don’t have exact figures, but I think it’s safe to say I could be more productive if I didn’t have to wonder things like “What function can I use here?” and “Should I mutate this variable?” They have nothing to do with the problem I’m trying to solve, or the feature I’m trying to implement. They are caused by the language itself. The only way I can find to avoid this is to not go down the path in the first place — don’t use ImmutableJS, immutable data structures, immutable data as a concept in Redux/React, or ramda, or lodash. Basically, write Javascript without functional programming techniques. That doesn’t seem like a good solution.

If you identify or agree at all with what I’ve said (and if you don’t, that’s fine), then I think it’s worth 5 minutes, a day, or even a week to consider: What might be the long-term costs of staying on the Javascript path versus taking a different one?

The different one, for me, is called Clojurescript. It’s a “compile-to-JS” language like ES6. By and large, it’s Javascript in a different syntax. It was designed from the ground up as a functional programming language that operates on immutable data structures. To me, it’s way easier and more promising than Javascript.

![](https://cdn-images-1.medium.com/max/1200/1*_bhmf-j96fW9qSuPm7yEsw.png)

### What is Clojure/Clojurescript?

Clojurescript is like Clojure except its host language is Javascript instead of Java. Their syntax is identical: If you learn Clojurescript, you learn Clojure and vice versa. This means if you know Clojurescript, you can write Javascript and Java. “3 Billion Devices Run Java”; I’m pretty sure the rest run Javascript.

Like Javascript, Clojure and Clojurescript are dynamically typed. You can write full stack apps in 100 percent Clojurescript using Node for your server. Unlike with a language that compiles to Javascript alone, you have the option of writing a Java-based server that supports multithreading.

As an average Javascript/Node developer, it hasn’t been difficult for me to learn the language or the ecosystem.

### What makes Clojurescript easier?

![](https://cdn-images-1.medium.com/max/1600/1*cxIhT4wHooj6Cl50sryKIA.gif)

Run whatever code you want inside your editor.
1. **You can run any code in your editor with a keypress. **This is exactly what it sounds like. You can type whatever code you’re trying to write in your editor, highlight it (or just put your cursor over it) and run it to see the result. You can define functions and call them with whatever arguments you want. You can do all of this while your app is running. So if you don’t know how something works, you can evaluate it in the REPL from your editor and see what’s going on.
2. **Functions work on arrays and objects. **Map, reduce, filter, etc. all work identically on arrays and objects. This is by design. We shouldn’t have to think about different `map` functions for arrays vs. objects.
3. **Immutable data structures. **Every Clojurescript data structure is immutable. As a result, you never wonder whether something is immutable or not. You also never switch programming paradigms from mutable to immutable. You’re fully in immutable-land.
4. **Basic functions are part of the language itself.** Functions like map, filter, reduce, compose, and [many others](https://clojure.github.io/clojure/) are part of the core language and don’t need to be imported. So you don’t end up with 4 different versions of, e.g. “map” (Array.map, lodash.map, ramda.map, Immutable.map) in your head. You only have to know one.
5. **It’s concise.** It can express ideas in fewer lines of code than most any other programming language (usually much fewer).
6. **Functional programming.** Clojurescript is a functional programming language from the ground up — implicit return statements, functions are first class, lambda expressions, etc.
7. **Use anything you want from Javascript.** You can use anything from Javascript and its ecosystem, from`console.log` to npm libraries.
8. **Performance. **Clojurescript uses the Google Closure compiler to optimize the Javascript it outputs. Bundle sizes are comically small. It requires no configuration apart from setting optimizations to `:advanced` when bundling for production.
9. **Readable library code.** It’s sometimes useful to know “What does this library function do?” When I use “goto definition” in Javascript, I usually end up seeing the minified or mangled source. Clojure and Clojurescript libraries show up the way they were written, so it’s easy to see how something works without leaving your editor, because you can just read the code.
10. **It’s a LISP.** It’s hard to enumerate the benefits of this, as there are many. One thing I like is that it’s formulaic (there’s a pattern to it that I can always count on) and code is expressed in terms of the language’s data structures (which makes metaprogramming easy). Clojure differs from LISP because it is not 100% `()`. It uses`[]` and `{}` for code and for data structures, just like most programming languages.
11. **Metaprogramming. **Clojurescript allows you to write code that writes code. This has vast implications that I won’t attempt to cover either. One is that you can effectively extend the language itself. Here’s an example from [Clojure for the Brave and True](http://www.braveclojure.com/writing-macros/):

```
(defmacro infix
  [infixed]
  (list (second infixed) (first infixed) (last infixed)))
(infix (1 + 1))
=> 2
(macroexpand '(infix (1 + 1)))
=> (+ 1 1)
; The macro passes this to Clojure. Clojure evaluates it no problem because it's native Clojure syntax
```

### Why isn’t it popular?

If it’s so great, why hasn’t it taken off? Some would point out it has, just not as much as lodash, React, Redux and others. But if it’s better, shouldn’t Clojurescript be just as popular as those? Why haven’t JS devs who prefer functional programming, immutability and React migrated to Clojurescript?

**Lack of job opportunities?** Clojure compiles to Javascript and Java. It can actually compile to C#, too. So any Javascript job could be a Clojurescript job. Or a Java or C# job. It’s a functional language for getting stuff done for any or all of those compile targets. And for whatever it’s worth, the 2017 StackOverflow survey found [Clojure developers are the highest paid of all languages on average worldwide](http://www.techrepublic.com/article/what-are-the-highest-paid-jobs-in-programming-the-top-earning-languages-in-2017/).

**JS devs are lazy?** No. As I’ve tried to show above, we do a ton of work. There’s a thing called [Javascript fatigue](https://medium.com/@ericclemmons/javascript-fatigue-48d4011b6fc4) you may have heard of.

**We’re resistant don’t want to learn something new?** No. [We’re notorious for adopting new technologies](https://hackernoon.com/how-it-feels-to-learn-javascript-in-2016-d3a717dd577f).

**Lack of familiar frameworks and tooling?** That perception may exist, but there are Clojurescript equivalents to everything in Javascript: [re-frame](https://github.com/Day8/re-frame) is Redux, [reagent](https://github.com/reagent-project/reagent) is React, [figwheel](https://github.com/bhauman/lein-figwheel) is Webpack/hot reloading, [leiningen](https://github.com/technomancy/leiningen) is yarn/npm, Clojurescript is Underscore/Lodash.

**Too difficult to write because parentheses? **This might not talked about enough either, but [we don’t have to match parenthesis and brackets](https://shaunlebron.github.io/parinfer/) ourselves. Parinfer makes Clojure a whitespace language, basically.

**Too hard to use at work?** Possibly. It’s new tech, like React and Redux once were, and those may’ve been a hard sell at some point, too. There’s no technical limit though — Clojurescript integrates into existing codebases the same way React does. You can add Clojurescript to an existing codebase, rewrite old code one file at a time, and continue to interact with the old code from the new.

**Not popular enough?** Unfortunately, I think this is what it comes down to. I got into Javascript in part because it has a huge community. Clojurescript is smaller. I started using React in part because it was backed by Facebook. Clojure is backed by [a guy with big hair who spends a lot of time thinking](https://avatars2.githubusercontent.com/u/34045?v=3&amp;s=400).

There’s safety in numbers. I buy that. But “popularity as veto” discards every other possible factor.

Suppose one path leads to $100. It’s not popular. Another path leads to $10 It’s vastly popular. Would I choose the popular one?

Well, maybe so! There’s a track record of success. It must be safer than the other way, because more people have chosen it. Nothing awful must have happened to them. The other way does sound better, but I’m sure it’s just a trap. If it was what it seemed, it would be the most popular.

![](https://cdn-images-1.medium.com/max/1600/1*Y6orLTOgb6JFfjVdANVgCQ.png)


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
