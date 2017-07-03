
  > * 原文地址：[Functional programming in Javascript is an antipattern](https://hackernoon.com/functional-programming-in-javascript-is-an-antipattern-58526819f21e)
> * 原文作者：[Alex Dixon](https://hackernoon.com/@alexdixon)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/functional-programming-in-javascript-is-an-antipattern.md](https://github.com/xitu/gold-miner/blob/master/TODO/functional-programming-in-javascript-is-an-antipattern.md)
> * 译者：[sunui](https://github.com/sunui)
> * 校对者：

# Javascript 的函数式编程是一种反模式

---

![](https://cdn-images-1.medium.com/max/1600/1*Y6orLTOgb6JFfjVdANVgCQ.png)

## 其实 Clojure 更简单些

写了几个月 Clojure 之后我再次开始写 Javascript。就在我试着写一些很普通的东西的时候，我总会想下面这些问题：

> “这是 ImmutableJS 变量还是 Javascript 变量？”

> “我如何 map 一个对象并且返回一个对象？”

> “如果它是不可变的，使用 <这种语法> 的 <这个函数>，否则使用 <不同的语法和完全不同行为> 的 <同一个函数的另一个版本>”

> “一个 React 组件的 state 可以是一个不可变的 Map 吗？”

> “引入 lodash 了吗？”

> “`fromJS` 然后 <写代码> 然后 `.toJS()`？”

这些问题似乎没什么必要。但我猜想我已经思考这些问题上百万次了只是没有注意到，因为这些都是我知道的。

当使用 React、Redux、ImmutableJS、lodash、和像 lodash/fp、ramda 这样的函数式编程库的任意组合写 Javascript 的时候，我觉得没什么方法能避免这种思考。

我需要一直把下面这些事记在脑海里：

- lodash 的 API、Immutable 的 API、lodash/fp 的 API、ramda 的 API、还有原生 JS 的 API 或一些组合的 API
- 处理 Javascript 数据结构的可变编程技术
- 处理 Immutable 数据结构的不可变编程技术
- 使用 Redux 或 React 时，可变的 Javascript 数据结构的不可变编程

就算我能够记住这些东西，我依然会遇到上面那一堆问题。不可变数据、可变数据和某些情况下不能改变的可变数据。一些常用函数的签名和返回值也是这样，几乎每一行代码都有不同的情况要考虑。我觉得在 Javascript 中使用函数式编程技术很棘手。

按照惯例像 Redux 和 React 这种库需要不可变性。所以即使我不使用 ImmutableJS，我也得记得“don’t mutate here”。在 Javascript 中不可变的转换比它本身的使用更难。我感觉这门语言给我前进的道路下了一路坑。此外，JavaScript 没有像 Object.map 这样基本的函数。所以像[上个月 4300 多万人](https://www.npmjs.com/package/lodash)一样，我使用 lodash，它提供大量 Javascript 自身没有的函数。不过它的 API 也不是友好支持不可变的。一些函数返回新的数值，而另一些会更改已经存在的数据。再次强调，花时间来区分它们是很不必要的开销。事实大概如此，想要处理 Javascript，我需要了解 lodash、它的函数名称、它的签名、它的返回值。更糟糕的是，它的[“collection 在先, arguments 在后”方式](https://www.youtube.com/watch?v=m3svKOdZijA)对函数式编程来说也并不理想。

如果我使用 ramda 或者 lodash/fp 会好一些，可以很容易地组合函数并且写出清晰整洁的代码。但是它不能和 Immutable 数据结构一起使用。我可能还是要写一些参数集合在后，而其他在前的代码。我必须知道更多的函数名、签名、返回值，并引入更多的基本函数。

当我单独使用 ImmutableJS，一些事变得容易些了。Map.set 返回全新的值。一切都返回全新的值！这就是我想要的。不幸的是，ImmutableJS 也纠结了一些事情。我不可避免地要处理两套不同的数据结构。所以我不得不清楚 `x` 是 Immutable 的还是 Javascript 的。通过学习其 API 和整体思维方式，我可以使用 Immutable 在 2 秒内知道如何解决问题。当我使用原生 JS 时，我必须跳过该解决方案，用另一种方式来解决问题。就像 ramda 和 lodash 一样，有大量的函数需要我了解 —— 他们返回什么、他们的签名、它们的名称。我也需要把我所知的所有函数分成两类：一类用于 Immutable 的，另一类不是。这往往也会影响我解决问题的方式。我有时会不自主地想到柯里化和组合函数的解决方案。但不能和 ImmutableJS 一起使用。所以我跳过这个解决方案，想想其他的。

当我全部想清楚以后，我才能尝试写一些代码。然后我转移另一个文件，做一遍同样的事情。

![](https://cdn-images-1.medium.com/max/1600/1*FVBc2DWB09sW6QJwMxm_fw.png)

Javascript 中的函数式编程。

![](https://cdn-images-1.medium.com/max/1600/1*MVU4TWwrkRMpQlmgkU9TuQ.png)

反模式的可视化。

我已孤立无援，并且把 Javascript 的函数式编程称为一种反模式。这是一条迷人之路却将我引入迷宫。它似乎解决了一些问题，最终却创造了更多的问题。重点是这些问题似乎没有更高层次的解决方案能避免我一次有一次的处理问题。

### What are the long term costs of this?

我没有确切的数字，但我敢说如果不必去想“在这里我可以用什么函数？”和“我可否改变这个变量”这样的问题，我可以更有成效。这些问题对我想要解决的问题或者我想要增加的功能没有任何意义。它们是语言本身造成的。我能想到避免这个问题的唯一办法就是在路的起点就不要走下去 —— 不要使用 ImmutableJS 、ImmutableJS 数据结构、Redux/React 概念中的不可变数据，以及 ramda 表达式和 lodash。总之就是写 Javascript 不要使用函数式编程技术，它看似不是什么号的解决方案。

If you identify or agree at all with what I’ve said (and if you don’t, that’s fine), then I think it’s worth 5 minutes, a day, or even a week to consider: What might be the long-term costs of staying on the Javascript path versus taking a different one?如果你确定或同意我所说的

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
