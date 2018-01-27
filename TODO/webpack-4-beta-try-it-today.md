> * 原文地址：[🚀webpack 4 beta — try it today!🚀](https://medium.com/webpack/webpack-4-beta-try-it-today-6b1d27d7d7e2)
> * 原文作者：[Sean T. Larkin](https://medium.com/@TheLarkInn?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/webpack-4-beta-try-it-today.md](https://github.com/xitu/gold-miner/blob/master/TODO/webpack-4-beta-try-it-today.md)
> * 译者：
> * 校对者：

# 🚀webpack 4 beta — try it today!🚀

![](https://cdn-images-1.medium.com/max/2000/1*BxhnE90lRYeLTxatyRDmqQ.jpeg)

To support millions of features, use-cases, and needs, it takes a secure, stable, reliable, and scale-able foundation. Only with webpack, are the possibilities limitless!

##  The road to stable release!

Since the beginning of August — when we forked `**webpack/webpack#master**`for the `**next**` branch — we’ve seen an incredible influx of contributions!

![](https://cdn-images-1.medium.com/max/800/1*kJm7dIWWR7DzZa-OW_z6gQ.png)

Git contribution stats for the webpack **next** branch at a glance using [gitinspector!](https://github.com/ejwa/gitinspector) Try it on your project to see insights. **PS: This doesn’t include the incredible work done in our webpack-cli team and webpack-contrib organization supporting our loaders and plugins.**

**🎉 Today, the we are proud to share the culmination of that work by releasing webpack 4.0.0-beta.0!** **🎉**

#### 🎁A Promise Fulfilled — Predictable Release Cycle

When we finished the release of webpack 3, we promised the community that we’d give you a longer development cycle between major versions.

We’ve delivered on that promise [and continue to deliver on it] by bringing you a great set of features, improvements, and bug fixes that we can’t wait for you to get your hands on! Here’s how you get started!

#### 🤷‍How to install [v4.0.0-beta.0]

If you are using `yarn`:

`yarn add webpack@next webpack-cli --dev`

or `npm`:

`npm install webpack@next webpack-cli --save-dev`

#### 🛠How to migrate?

The more folks trying and reporting plugin and loader incompatibilities while testing webpack 4, the more we can build up a living migration guide.

**_So we need you to check out the_ **[**_official change log,_**](https://github.com/webpack/webpack/releases/tag/v4.0.0-beta.0)** _and also_ **[**_our migration draft_**](https://github.com/webpack/webpack/issues/6357)** _and provide feedback where missing! This will help our documentation team create our official stable release migration guide!_**

### What’s new in webpack 4?

Below are some of the more _notable_ features that you will enjoy reading about. For the **_full list_ **of changes, features, and internal API modifications, [**_please refer to our change log!!!_**](https://github.com/webpack/webpack/releases/tag/v4.0.0-beta.0)

### 🚀Performance

Performance will be significantly enhanced in multiple scenarios for webpack 4. Here are just a few of the notable changes we made to accomplish this:

* By default**,** when using `production` mode, we will automatically parallelize and cache the minification work done by UglifyJS.
* We shipped a new version of [**our plugin system**](https://github.com/webpack/tapable) so that event hooks and handlers are monomorphic.
* In addition, webpack now has dropped Node v4 support, allowing us to add a considerable amount of newer ES6 syntax and data structures, also optimized by V8. **So far we have seen real-life reports of 9**[**h to 12min**](https://github.com/webpack/webpack/issues/6248)**!**

_PS: we haven’t even implemented full caching and parallelism_ 😉 _[webpack 5 milestone]._

### 🔥Better Defaults — #0CJS

Up until today, webpack has always required you to explicitly set your `entry` and `output` properties. With webpack 4, webpack will automatically assume your `entry` property is `./src/` and bundles will output to `./dist` by default.

This means that **_you no longer need a configuration to get started with webpack!!!_**

![](https://cdn-images-1.medium.com/max/1000/1*SmNPl3vyqGNg6Mqy0GqKyg.png)

webpack 4.0.0-beta.0 running a build w/o a configuration! #0CJS 🔥

Now that webpack is a #0CJS (Zero Configuration) out-of-the-box bundler, we will lay groundwork in **4.x** and **5.0 to provide more default capabilities down the road.**

### 💪Better Defaults — mode

You have to choose (`mode` or `--mode`) between two modes now: `“production”` or `“development”.`

* Production Mode enables all sorts of optimizations out of the box for you. This includes, minification, scope hoisting, tree-shaking, side-effect-free module pruning, and includes plugins you would have to manually use like `NoEmitOnErrorsPlugin.`
* Development Mode optimized for speed and developer experience. In the same way, we automatically include features like path names in your bundle output, eval-source-maps, that are meant for easy-to-read code, and fast build times!

### 🍰sideEffects — Huge win for bundle sizes

We introduced support for `sideEffects: false` in package.json. When this field is added, it signals to webpack that there are no sideEffects in the library being consumed. This means that webpack can safely eliminate any used re-exports from your code.

For example, importing only as _single_`_export_`from `lodash-es` would cost ~223 KiB [minified]. **_In webpack 4, this cost is now ~3 KiB!!!_**

![Snipaste_2018-01-27_16-52-08.png](https://i.loli.net/2018/01/27/5a6c3dc6a8391.png)

### 🌳JSON Support & Tree Shaking

When you `import` JSON with ESModule syntax, webpack will eliminate unused exports from the “JSON Module”. _For those who are already importing JSON into your code with lot’s of unused pieces, you should see_ **_a significant size decrease in your bundle sizes._**

### 😍Upgrade to UglifyJS2

This means that you can use ES6 Syntax, minify it, without a transpiler first.

_We would like to thank the UglifyJs2 team of contributors for the selfless and hard work they have done to land ES6 support. This was no easy task and we’d love for you to_ [_stop by their repository and express your appreciation and support._](https://github.com/mishoo/UglifyJS2/graphs/contributors?from=2017-01-14&to=2018-01-25&type=c)

![](https://cdn-images-1.medium.com/max/800/1*rt3uFkb9IAHddXLxYMjCgw.png)

UglifyJS2 now supports ES6 JavaScript syntax!

### 🐐 Module Type’s Introduced + .mjs support

Historically, JavaScript has been the only first-class module type in webpack. This caused a lot of awkward pains for users where they would not be able to effectively have CSS/HTML Bundles, etc. We have completely abstracted the JavaScript specificity from our code base to allow for this new API. Currently built, we now have 5 module types implemented:

* `javascript/auto`: _(The default one in_ **_webpack 3_**_)_ Javascript module with all module systems enabled: CommonJS, AMD, ESM
* `javascript/esm`: EcmaScript modules, all other module system are not available _(the default for .mjs files)_
* `javascript/dynamic`: Only CommonJS and, EcmaScript modules are not available
* `json`: JSON data, it’s available via require and import _(the default for .json files)_
* `webassembly/experimental`: WebAssembly modules _(currently experimental and the default for .wasm files)_
* In addition webpack now looks for the `.wasm`, `.mjs`, `.js` and `.json` extensions in this order to resolve

**What’s most exciting about this feature, is that now we can continue to work on our CSS and HTML module types (4.x).** This would allow capabilities like HTML as your entry-point!

### 🔬WebAssembly Support

Webpack now by default supports `import` and `export` of any local WebAssembly module. This means that you can also write loaders that allow you to `import` Rust, C++, C and other WebAssembly host lang files directly:

### 💀Goodbye CommonsChunkPlugin

We have also removed `CommonsChunkPlugin`and enabled many of its features by default. In addition, for those who need fine-grained control over their caching-strategy, we have added `optimization.splitChunks` and `optimization.runtimeChunk` [with a richer, more flexible set of capabilities](https://gist.github.com/sokra/1522d586b8e5c0f5072d7565c2bee693)

### 💖And so much more!

There are so many more features **that we heavily recommend you check them all out** on our [**_official change log._**](https://github.com/webpack/webpack/releases/tag/v4.0.0-beta.0)

### ⌚The clock starts now

**As promised, we will wait a month from today before releasing webpack 4 stable.** This gives our plugin, loaders, and integrations ecosystem time to test, report, and upgrade to webpack 4.0.0!

![Snipaste_2018-01-27_16-54-02.png](https://i.loli.net/2018/01/27/5a6c3e33c6cd1.png)

We need you to help us upgrade and test this beta. The more we can have testing it today, the faster we can help triage and identify any issues that could come up down the road!

Thank you so much to all of our contributors who have helped make wepback 4 what it is today. As we always say, webpack’s power is the sum of our parts and ecosystem.

* * *

_No time to help contribute? Want to give back in other ways? Become a Backer or Sponsor to webpack by_ [_donating to our open collective_](https://opencollective.com/webpack)_. Open Collective not only helps support the Core Team, but also supports contributors who have spent significant time improving our organization on their free time! ❤_

Thanks to [Florent Cailhol](https://medium.com/@ooflorent?source=post_page), [Tobias Koppers](https://medium.com/@sokra?source=post_page), and [John Reilly](https://medium.com/@johnny_reilly?source=post_page).


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
