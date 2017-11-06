> * 原文地址：[Rollup - Next-generation ES6 module bundler - Interview with Rich Harris](https://survivejs.com/blog/rollup-interview/)
> * 原文作者：[SurviveJS](https://twitter.com/survivejs)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/rollup-interview.md](https://github.com/xitu/gold-miner/blob/master/TODO/rollup-interview.md)
> * 译者：
> * 校对者：

# Rollup - Next-generation ES6 module bundler - Interview with Rich Harris

Given JavaScript application source cannot be consumed easily through the browser "as is" just yet, the process of **bundling** is needed. The point is to convert the source into a form the browser can understand. This is the reason why bundlers, such as Browserify, Rollup, or webpack exist.

To dig deeper into the topic, I'm interviewing [Rich Harris](https://twitter.com/Rich_Harris), the author of Rollup.

> I [interviewed Rich earlier about Svelte](https://survivejs.com/blog/svelte-interview/), a UI framework of his.

## Can you tell a bit about yourself?

![Rich Harris](https://www.gravatar.com/avatar/329f9d32fe20b186838ee237d3eb2d43?s=200) I'm a graphics editor at the New York Times, working on the investigations team — part journalist, part developer. Before that I did a similar job at the Guardian. Part of my role historically has been to build tools that allow us to create and deploy projects at the speed of news, which can be pretty aggressive — [Rollup](https://rollupjs.org), [Bublé](https://buble.surge.sh) and [Svelte](https://svelte.technology), among others, are all products of that.

## How would you describe _Rollup_ to someone who has never heard of it?

Rollup is a module bundler. Basically, it concatenates JavaScript files, except you don't have to manually specify the order of them or worry about variable names in one file conflicting with names in another. Under the hood it's a bit more sophisticated than that, but in essence that's all it's doing — concatenating.

The reason you'd use it is so that you can write software in a modular way — which is better for your sanity for lots of reasons — using the `import` and `export` keywords that were added to the language in ES2015. Since browsers and Node.js don't yet support ES2015 modules (ESM) natively, we have to bundle our modules in order to run them.

Rollup can create self-executing `<script>` files, AMD modules, Node-friendly CommonJS modules, UMD modules (which are a combination of all three), or even ESM bundles that can be used in _other_ projects.

Which is ideal for libraries. In fact, most major JavaScript libraries that I can think of — React, Vue, Angular, Glimmer, D3, Three.js, PouchDB, Moment, Most.js, Preact, Redux, etc — are built with Rollup.

## How does _Rollup_ work?

You give it an entry point — let's say `index.js`. Rollup will read that file and parse it using Acorn — this gives us something called an abstract syntax tree (AST). Once you have the AST you can discover lots of things about the code, such as which `import` declarations it contains.

Let's say `index.js` has this line at the top:

```
import foo from './foo.js';
```

That means that Rollup needs to resolve `./foo.js` relative to `index.js`, load it, parse it, analyse it, lather, rinse and repeat until there are no more modules to import. Crucially, all these steps are pluggable, so you can augment Rollup with the ability to import from `node_modules` or compile ES2015 to ES5 in a sourcemap-aware way, for example.

## How does _Rollup_ differ from other solutions?

Firstly, there's zero overhead. The traditional approach to bundling is to wrap every module in a function, put those functions in an array, and implement a `require` function that plucks those functions out of the array and executes them on demand. It turns out [this is terrible](https://nolanlawson.com/2016/08/15/the-cost-of-small-modules/) for both bundle size and startup time.

Instead, Rollup essentially just concatenates your code — there's no waste, and the resulting bundle minifies better. Some people call this 'scope hoisting'.

Secondly, it removes unused code from the modules you import, which is called 'treeshaking' for reasons that no-one is certain of.

It's worth noting that webpack implements a form of scope hoisting and treeshaking in the most recent version, so it's catching up to Rollup in terms of bundle size and startup time (though we're still ahead!). Webpack is generally considered the better option if you're building an app rather than a library, since it has a lot of features that Rollup doesn't — code splitting, dynamic imports and so-on.

> To understand the difference between the tools, [read "Webpack and Rollup: the same but different"](https://medium.com/webpack/webpack-and-rollup-the-same-but-different-a41ad427058c).

## Why did you develop _Rollup_?

Necessity. None of the existing tools were good enough.

A few years ago, I was working on a project called [Ractive](https://ractive.js.org), and I was frustrated with our build process. The more we split the codebase up into modules, the larger the build got, because of the overhead I described earlier. We were effectively being penalised for doing the right thing.

So I wrote a module bundler called Esperanto and released it as a separate open source project. Lo and behold, our builds shrank. But I wasn't satisfied, because I'd read something [Jo Liss](https://twitter.com/jo_liss) had written about how ESM — being designed with static analysis in mind — would allow us to do treeshaking. Esperanto didn't have that ability.

Adding treeshaking to Esperanto would have been very difficult, so I burned it all and started over with Rollup.

> To learn more about ESM, [read the interview of Bradley Farias](https://survivejs.com/blog/es-modules-interview/).

## What next?

I would love to get Rollup to a place where we can call it 'done', so that I don't have to think about it any more. It's not an exciting project to work on, since module bundling is an incredibly boring subject. It's basically just plumbing — essential but unglamorous.

There's a fair distance to go before we get there though. And I feel a certain responsibility to keep the community looked after, since I've been such a vocal advocate for ESM.

We're getting to an exciting place though — browsers are just starting to add native module support, and now that webpack has scope hoisting, there are very tangible benefits to using ESM everywhere. So we'll hopefully see ESM take over from CommonJS modules very soon. (If you're still writing CommonJS, stop! You're just creating technical debt.)

## What does the future look like for _Rollup_ and web development in general? Can you see any particular trends?

For one thing, Rollup will become increasingly obsolete. Once browsers support modules natively, there'll be a large class of applications for which bundling (and everything that goes with it — compiling, minifying and so on) will just be an optional performance optimisation, as opposed to a necessity. That's going to be _huge_, particularly for newcomers to web development.

But at the same time we're increasingly using our build processes to add sophisticated capabilities to our applications. I'm a proponent of that — [Svelte](https://svelte.technology) is a compiler that essentially writes your app for you from a declarative template — and it's only going to get more intense with the advent of WASM and other things.

So we have these two seemingly contradictory trends happening simultaneously, and it'll be fascinating to see how they play out.

## What advice would you give to programmers getting into web development?

Watch other programmers over their shoulders. Read source code. Develop taste by building things, and being proud of them but never satisifed. Learn the fundamentals, because all abstractions are leaky. Learn what 'all abstractions are leaky' means. Turn your computer off and go outside, because most of your best programming will happen away from your keyboard.

Most importantly, take programming advice with a pinch of salt. As soon as someone reaches the stage where people start asking them to offer advice, they forget what it was like to be a new developer. No-one knows anything anyway.

## Who should I interview next?

I really like following the work of people who straddle the line between JavaScript and disciplines like dataviz, WebGL, cartography and animation — people like [Vladimir Agafonkin](https://twitter.com/mourner), [Matthew Conlen](https://twitter.com/mathisonian), [Sarah Drasner](https://twitter.com/sarah_edo), [Robert Monfera](https://twitter.com/monfera), and [Tom MacWright](https://twitter.com/tmcw).

On the web development front more generally, I've been enjoying playing around with [Rill](https://rill.site) by [Dylan Piercey](https://twitter.com/dylan_piercey). It's a universal router that lets you write Express-style apps that also work in the browser, and it's really well thought through. For me it hits the sweet spot between boosting productivity and not being overly opinionated.

## Any last remarks?

Rollup would love your help! It's a fairly important part of the ecosystem nowadays, but I don't have nearly enough time to give it the attention it deserves, and the same is true for all our contributors. If you're interested in helping out with a tool that indirectly benefits millions (perhaps billions!) of web users, get in touch with us.

## Conclusion

Thanks for the interview Rich! Rollup is an amazing tool and well worth learning especially for library authors. I hope we can skip the entire bundling step one day as that would make things simpler.

To learn more about Rollup, [check out the online documentation](https://rollupjs.org/). You can also [find the project on GitHub](https://github.com/rollup/rollup).

10 Jul 2017


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
