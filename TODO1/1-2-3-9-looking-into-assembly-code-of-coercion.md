> * 原文地址：[How Does the Development Mode Work?](https://overreacted.io/how-does-the-development-mode-work/)
> * 原文作者：[Dan Abramov](https://mobile.twitter.com/dan_abramov)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-does-the-development-mode-work.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-does-the-development-mode-work.md)
> * 译者：
> * 校对者：

# 开发模式的工作原理是？

如果你的 JavaScript 代码库已经有些复杂了，**你可能需要一个针对线上和开发环境区分打包和运行不同代码的方案**。

针对开发环境和线上环境，来区分打包和运行不同的代码非常有用。在开发模式中，React 会包含很多告警来帮助你及时发现问题，而不至于造成 bug。然而，这些帮助发现问题的必要代码，往往会造成代码包大小增加以及应用运行变慢。

这种降速在开发环境下是可以接受的。事实上，在开发环境下运行代码的速度更慢**可能更有帮助**，因为这可以一定程度上消除高性能的开发机器与平均速度的用户设备而带来的差异。

在线上环境我们不想要任何的性能损耗。因此，我们在线上环境删除了这些校验。那么它的工作原理是什么？我们来康康。

---

想要在开发环境运行下不同代码的正确方法是关键在于你的 JavaScript 构建工具The exact way to run different code in development depends on your JavaScript build pipeline (and whether you have one). At Facebook it looks like this:

```js
if (__DEV__) {
  doSomethingDev();
} else {
  doSomethingProd();
}
```

Here, `__DEV__` isn’t a real variable. It’s a constant that gets substituted when the modules are stitched together for the browser. The result looks like this:

```js
// In development:
if (true) {
  doSomethingDev(); // 👈
} else {
  doSomethingProd();
}

// In production:
if (false) {
  doSomethingDev();
} else {
  doSomethingProd(); // 👈
}
```

In production, you’d also run a minifier (for example, [terser](https://github.com/terser-js/terser)) on the code. Most JavaScript minifiers do a limited form of [dead code elimination](https://en.wikipedia.org/wiki/Dead_code_elimination), such as removing `if (false)` branches. So in production you’d only see:

```js
// In production (after minification):
doSomethingProd();
```

**(Note that there are significant limits on how effective dead code elimination can be with mainstream JavaScript tools, but that’s a separate topic.)**

While you might not be using a `__DEV__` magic constant, if you use a popular JavaScript bundler like webpack, there’s probably some other convention you can follow. For example, it’s common to express the same pattern like this:

```js
if (process.env.NODE_ENV !== 'production') {
  doSomethingDev();
} else {
  doSomethingProd();
}
```

**That’s exactly the pattern used by libraries like [React](https://reactjs.org/docs/optimizing-performance.html#use-the-production-build) and [Vue](https://vuejs.org/v2/guide/deployment.html#Turn-on-Production-Mode) when you import them from npm using a bundler.** (Single-file `<script>` tag builds offer development and production versions as separate `.js` and `.min.js` files.)

This particular convention originally comes from Node.js. In Node.js, there is a global `process` variable that exposes your system’s environment variables as properties on the [`process.env`](https://nodejs.org/dist/latest-v8.x/docs/api/process.html#process_process_env) object. However, when you see this pattern in a front-end codebase, there isn’t usually any real `process` variable involved. 🤯

Instead, the whole `process.env.NODE_ENV` expression gets substituted by a string literal at the build time, just like our magic `__DEV__` variable:

```js
// In development:
if ('development' !== 'production') { // true
  doSomethingDev(); // 👈
} else {
  doSomethingProd();
}

// In production:
if ('production' !== 'production') { // false
  doSomethingDev();
} else {
  doSomethingProd(); // 👈
}
```

Because the whole expression is constant (`'production' !== 'production'` is guaranteed to be `false`), a minifier can also remove the other branch.

```js
// In production (after minification):
doSomethingProd();
```

Mischief managed.

---

Note that this **wouldn’t work** with more complex expressions:

```js
let mode = 'production';
if (mode !== 'production') {
  // 🔴 not guaranteed to be eliminated
}
```

JavaScript static analysis tools are not very smart due to the dynamic nature of the language. When they see variables like `mode` rather than static expressions like `false` or `'production' !== 'production'`, they often give up.

Similarly, dead code elimination in JavaScript often doesn’t work well across the module boundaries when you use the top-level `import` statements:

```js
// 🔴 not guaranteed to be eliminated
import {someFunc} from 'some-module';

if (false) {
  someFunc();
}
```

So you need to write code in a very mechanical way that makes the condition **definitely static**, and ensure that **all code** you want to eliminate is inside of it.

---

For all of this to work, your bundler needs to do the `process.env.NODE_ENV` replacement, and needs to know in which mode you **want** to build the project in.

A few years ago, it used to be common to forget to configure the environment. You’d often see a project in development mode deployed to production.

That’s bad because it makes the website load and run slower.

In the last two years, the situation has significantly improved. For example, webpack added a simple `mode` option instead of manually configuring the `process.env.NODE_ENV` replacement. React DevTools also now displays a red icon on sites with development mode, making it easy to spot and even [report](https://mobile.twitter.com/BestBuySupport/status/1027195363713736704).

[![Development mode warning in React DevTools](https://overreacted.io/static/ca1c0db064f73cc5c8e21ad605eaba26/fb8a0/devmode.png)](https://overreacted.io/static/ca1c0db064f73cc5c8e21ad605eaba26/d9514/devmode.png) 

Opinionated setups like Create React App, Next/Nuxt, Vue CLI, Gatsby, and others make it even harder to mess up by separating the development builds and production builds into two separate commands. (For example, `npm start` and `npm run build`.) Typically, only a production build can be deployed, so the developer can’t make this mistake anymore.

There is always an argument that maybe the **production** mode needs to be the default, and the development mode needs to be opt-in. Personally, I don’t find this argument convincing. People who benefit most from the development mode warnings are often new to the library. **They wouldn’t know to turn it on,** and would miss the many bugs that the warnings would have detected early.

Yes, performance issues are bad. But so is shipping broken buggy experiences to the end users. For example, the [React key warning](https://reactjs.org/docs/lists-and-keys.html#keys) helps prevent bugs like sending a message to a wrong person or buying a wrong product. Developing with this warning disabled is a significant risk for you **and** your users. If it’s off by default, then by the time you find the toggle and turn it on, you’ll have too many warnings to clean up. So most people would toggle it back off. This is why it needs to be on from the start, rather than enabled later.

Finally, even if development warnings were opt-in, and developers **knew** to turn them on early in development, we’d just go back to the original problem. Someone would accidentally leave them on when deploying to production!

And we’re back to square one.

Personally, I believe in **tools that display and use the right mode depending on whether you’re debugging or deploying**. Almost every other environment (whether mobile, desktop, or server) except the web browser has had a way to load and differentiate development and production builds for decades.

Instead of libraries coming up with and relying on ad-hoc conventions, perhaps it’s time the JavaScript environments see this distinction as a first-class need.

---

Enough with the philosophy!

Let’s take another look at this code:

```js
if (process.env.NODE_ENV !== 'production') {
  doSomethingDev();
} else {
  doSomethingProd();
}
```

You might be wondering: if there’s no real `process` object in front-end code, why do libraries like React and Vue rely on it in the npm builds?

**(To clarify this again: the `<script>` tags you can load in the browser, offered by both React and Vue, don’t rely on this. Instead you have to manually pick between the development `.js` and the production `.min.js` files. The section below is only about using React or Vue with a bundler by `import`ing them from npm.)**

Like many things in programming, this particular convention has mostly historical reasons. We are still using it because now it’s widely adopted by different tools. Switching to something else is costly and doesn’t buy much.

So what’s the history behind it?

Many years before the `import` and `export` syntax was standardized, there were several competing ways to express relationships between modules. Node.js popularized `require()` and `module.exports`, known as [CommonJS](https://en.wikipedia.org/wiki/CommonJS).

Code published on the npm registry early on was written for Node.js. [Express](https://expressjs.com) was (and probably still is?) the most popular server-side framework for Node.js, and it [used the `NODE_ENV` environment variable](https://expressjs.com/en/advanced/best-practice-performance.html#set-node_env-to-production) to enable production mode. Some other npm packages adopted the same convention.

Early JavaScript bundlers like browserify wanted to make it possible to use code from npm in front-end projects. (Yes, [back then](https://blog.npmjs.org/post/101775448305/npm-and-front-end-packaging) almost nobody used npm for front-end! Can you imagine?) So they extended the same convention already present in the Node.js ecosystem to the front-end code.

The original “envify” transform was [released in 2013](https://github.com/hughsk/envify/commit/ae8aa26b759cd2115eccbed96f70e7bbdceded97). React was open sourced around that time, and npm with browserify seemed like the best solution for bundling front-end CommonJS code during that era.

React started providing npm builds (in addition to `<script>` tag builds) from the very beginning. As React got popular, so did the practice of writing modular JavaScript with CommonJS modules and shipping front-end code via npm.

React needed to remove development-only code in the production mode. Browserify already offered a solution to this problem, so React also adopted the convention of using `process.env.NODE_ENV` for its npm builds. With time, many other tools and libraries, including webpack and Vue, did the same.

By 2019, browserify has lost quite a bit of mindshare. However, replacing `process.env.NODE_ENV` with `'development'` or `'production'` during a build step is a convention that is as popular as ever.

**(It would be interesting to see how adoption of ES Modules as a distribution format, rather than just the authoring format, changes the equation. Tell me on Twitter?)**

---

One thing that might still confuse you is that in React **source code** on GitHub, you’ll see `__DEV__` being used as a magic variable. But in the React code on npm, it uses `process.env.NODE_ENV`. How does that work?

Historically, we’ve used `__DEV__` in the source code to match the Facebook source code. For a long time, React was directly copied into the Facebook codebase, so it needed to follow the same rules. For npm, we had a build step that literally replaced the `__DEV__` checks with `process.env.NODE_ENV !== 'production'` right before publishing.

This was sometimes a problem. Sometimes, a code pattern relying on some Node.js convention worked well on npm, but broke Facebook, or vice versa.

Since React 16, we’ve changed the approach. Instead, we now [compile a bundle](https://reactjs.org/blog/2017/12/15/improving-the-repository-infrastructure.html#compiling-flat-bundles) for each environment (including `<script>` tags, npm, and the Facebook internal codebase). So even CommonJS code for npm is compiled to separate development and production bundles ahead of time.

This means that while the React source code says `if (__DEV__)`, we actually produce **two** bundles for every package. One is already precompiled with `__DEV__ = true` and another is precompiled with `__DEV__ = false`. The entry point for each package on npm “decides” which one to export.

[For example:](https://unpkg.com/browse/react@16.8.6/index.js)

```js
if (process.env.NODE_ENV === 'production') {
  module.exports = require('./cjs/react.production.min.js');
} else {
  module.exports = require('./cjs/react.development.js');
}
```

And that’s the only place where your bundler will interpolate either `'development'` or `'production'` as a string, and where your minifier will get rid of the development-only `require`.

Both `react.production.min.js` and `react.development.js` don’t have any `process.env.NODE_ENV` checks anymore. This is great because **when actually running on Node.js**, accessing `process.env` is [somewhat slow](https://reactjs.org/blog/2017/09/26/react-v16.0.html#better-server-side-rendering). Compiling bundles in both modes ahead of time also lets us optimize the file size [much more consistently](https://reactjs.org/blog/2017/09/26/react-v16.0.html#reduced-file-size), regardless of which bundler or minifier you are using.

And that’s how it really works!

---

I wish there was a more first-class way to do it without relying on conventions, but here we are. It would be great if modes were a first-class concept in all JavaScript environments, and if there was some way for a browser to surface that some code is running in a development mode when it’s not supposed to.

On the other hand, it is fascinating how a convention in a single project can propagate through the ecosystem. `EXPRESS_ENV` [became `NODE_ENV`](https://github.com/expressjs/express/commit/03b56d8140dc5c2b574d410bfeb63517a0430451) in 2010 and [spread to front-end](https://github.com/hughsk/envify/commit/ae8aa26b759cd2115eccbed96f70e7bbdceded97) in 2013. Maybe the solution isn’t perfect, but for each project the cost of adopting it was lower than the cost of convincing everyone else to do something different. This teaches a valuable lesson about the top-down versus bottom-up adoption. Understanding how this dynamic plays out distinguishes successful standardization attempts from failures.

Separating development and production modes is a very useful technique. I recommend using it in your libraries and the application code for the kinds of checks that are too expensive to do in production, but are valuable (and often critical!) to do in development.

As with any powerful feature, there are some ways you can misuse it. This will be the topic of my next post!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
