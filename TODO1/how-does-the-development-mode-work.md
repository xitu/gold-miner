> * 原文地址：[开发模式的工作原理是什么？](https://overreacted.io/how-does-the-development-mode-work/)
> * 原文作者：[Dan Abramov](https://mobile.twitter.com/dan_abramov)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-does-the-development-mode-work.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-does-the-development-mode-work.md)
> * 译者：[Jerry-FD](https://github.com/Jerry-FD)
> * 校对者：[TokenJan](https://github.com/TokenJan)、[hanxiaosss](https://github.com/hanxiaosss)

# 开发模式的工作原理是？

如果你的 JavaScript 代码库已经有些复杂了，**你可能需要一个解决方案来针对线上和开发环境区分打包和运行不同代码**。

针对开发环境和线上环境，来区分打包和运行不同的代码非常有用。在开发模式中，React 会包含很多告警来帮助你及时发现问题，而不至于造成线上 bug。然而，这些帮助发现问题的必要代码，往往会造成代码包大小增加以及应用运行变慢。

这种降速在开发环境下是可以接受的。事实上，在开发环境下运行代码的速度更慢**可能更有帮助**，因为这可以一定程度上消除高性能的开发机器与平均速度的用户设备而带来的差异。

在线上环境我们不想要任何的性能损耗。因此，我们在线上环境删除了这些校验。那么它的工作原理是什么？让我们来康康。

---

想要在开发环境运行下不同代码关键在于你的 JavaScript 构建工具（无论你用的是哪一个）。在 Facebook 中它长这个样子：

```js
if (__DEV__) {
  doSomethingDev();
} else {
  doSomethingProd();
}
```

在这里，`__DEV__` 不是一个真正的变量。当浏览器把模块之间的依赖加载完毕的时候，它会被替换成常量。结果是这个样子：

```js
// 在开发环境下：
if (true) {
  doSomethingDev(); // 👈
} else {
  doSomethingProd();
}

// 在线上环境：
if (false) {
  doSomethingDev();
} else {
  doSomethingProd(); // 👈
}
```

在线上环境，你可能会在代码中会启用压缩工具（比如, [terser](https://github.com/terser-js/terser)）。大多 JavaScript 压缩工具会针对[无效代码](https://en.wikipedia.org/wiki/Dead_code_elimination)做一些限制，比如删除 `if (false)` 的逻辑分支。所以在线上环境中，你可能只会看到：

```js
// 在线上环境（压缩后）：
doSomethingProd();
```

**（注意，针对目前主流的 JavaScript 工具有一些重要的规范，这些规范可以指导怎样才能有效的移除无效代码，但这是另一个的话题了。）**

可能你使用的不是 `__DEV__` 这个神奇的变量，如果你是用的是流行的 JavaScript 打包工具，比如 webpack，那么这有一些你需要遵守的约定。比如，像这样的一种非常常见的表达式：

```js
if (process.env.NODE_ENV !== 'production') {
  doSomethingDev();
} else {
  doSomethingProd();
}
```

**一些框架比如 [React](https://reactjs.org/docs/optimizing-performance.html#use-the-production-build) 和 [Vue](https://vuejs.org/v2/guide/deployment.html#Turn-on-Production-Mode) 就是使用的这种形式。当你使用 npm 来打包载入它们的时候。** (单个的 `<script>` 标签会提供开发和线上版本的独立文件，并且使用 `.js` 和 `.min.js` 的结尾来作为区分。)

这个特殊的约定最早来自于 Node.js。在 Node.js 中，会有一个全局的 `process` 变量用来代表你当前系统的环境变量，它属于 [`process.env`](https://nodejs.org/dist/latest-v8.x/docs/api/process.html#process_process_env) object 的一个属性。然而，如果你在前端的代码库里看到这种语法，其实是并不存在真正的 `process` 变量的。🤯

取而代之的是，整个 `process.env.NODE_ENV` 表达式在打包的时候会被替换成一个字面量的字符串，就像神奇的 `__DEV__` 变量一样：

```js
// 在开发环境中：
if ('development' !== 'production') { // true
  doSomethingDev(); // 👈
} else {
  doSomethingProd();
}

// 在线上环境中：
if ('production' !== 'production') { // false
  doSomethingDev();
} else {
  doSomethingProd(); // 👈
}
```

因为整个表达式是常量（`'production' !== 'production'` 恒为 `false`）打包压缩工具也可以借此删除其他的逻辑分支代码。

```js
// 在线上环境（打包压缩后）：
doSomethingProd();
```

恶作剧到此结束~

---

注意这个特性如果面对更复杂的表达式将**不会工作**：

```js
let mode = 'production';
if (mode !== 'production') {
  // 🔴 不能保证会被移除
}
```

JavaScript 静态分析工具不是特别智能，这是因为语言的动态特性所决定的。当它们发现像 `mode` 这样的变量，而不是像 `false` 或者 `'production' !== 'production'` 这样的静态表达式时，它们大概率会失效。

类似地，在 JavaScript 中如果你使用顶层的 `import` 声明，自动移除无用代码的逻辑会因为不能跨越模块边界而无法生效。

```js
// 🔴 不能保证会被移除
import {someFunc} from 'some-module';

if (false) {
  someFunc();
}
```

所以你的代码需要写的非常严格，来确保条件的**绝对静态**，并且确保**所有**你想要移除的代码都包含在条件内部。

---

为了保证一切按计划运行，你的打包工具需要替换 `process.env.NODE_ENV`，而且它需要知道你**想要**在哪种模式下构建项目。

在几年前，忘记配置环境变量非常常见。你会经常发现在开发模式下的项目被部署到了线上。

那很糟糕，因为这会使网站加载运行的速度很慢。

在过去的两年里，这种情况有了显著的改善。例如，webpack 增加了一个简单的 `mode` 选项，替换了原先手动更改 `process.env.NODE_ENV`。 React DevTools 现在也会针对开发模式下的站点展示一个红色的 icon，来使得它容易被[察觉](https://mobile.twitter.com/BestBuySupport/status/1027195363713736704)。

[![React DevTools 的开发模式警告](https://overreacted.io/static/ca1c0db064f73cc5c8e21ad605eaba26/fb8a0/devmode.png)](https://overreacted.io/static/ca1c0db064f73cc5c8e21ad605eaba26/d9514/devmode.png) 

一些会帮你做预设置的安装工具比如 Create React App、Next/Nuxt、Vue CLI、Gatsby 等等，会把开发和线上构建分成两个独立的命令，来使得犯错的几率更小。(例如，`npm start` 和 `npm run build`。）也就是说，只有线上的构建代码才能被部署，所以开发者再也不可能犯这种错误了。

一直有一个在讨论的点是，把**线上**模式置为默认，开发模式变为可选项。个人来说，我认为这样做不是很好。从开发模式的警告中受益的人大多是刚刚接触这个框架的开发者。 **他们不会意识到要打开开发模式的开关**，这样就会错过很多应该被警告提前发现的 bug。

是的，性能问题非常糟糕，但充斥着 bug 的用户体验也是一样。例如，[React key 警告](https://reactjs.org/docs/lists-and-keys.html#keys) 帮助防止发生像发错了消息或者买错了产品这样的 bug。如果在开发中禁用这个警告，对你**和**你的用户来说都是非常冒险的。因为如果它默认是关闭状态，而之后你发现了这个开关并把它打开了，你会发现有太多的警告需要清理。所以大多数人会再把它关上。所以这就是为什么它需要在开始时候就是打开状态，而不是之后才让它生效的原因。

最后，就算在开发中这些警告是可选项，并且开发者们也**知道**需要在开发的早期就把它们打开，我们还是要回到最开始的问题。还是会有一些开发者不小心把他们部署到线上环境中！

我们回到这一点来。

个人认为，我坚信**工具展示和使用的正确模式取决于你是在调试还是在部署**。几乎所有其他环境（无论是手机、桌面还是服务端）除了页面浏览器之外都已经有区分和加载不同的开发和线上环境的方法存在长达数十年了。

不能仅依靠框架提出或者依赖临时公约，可能 JavaScript 的环境是时候把这种区别作为一个很重要的需求来看待了。

---

大道理已经够了！

让我们再来看一眼代码：

```js
if (process.env.NODE_ENV !== 'production') {
  doSomethingDev();
} else {
  doSomethingProd();
}
```

你可能想知道：如果在前端代码中不存在 `process` 对象，为什么像 React 和 Vue 这样的框架会在 npm 包中依赖它？

**（再次声明：用 `<script>` 标签可以使用 React 和 Vue 提供的方式把它们加载到浏览器中，这不会依赖 process。取而代之的是，你必须要手动选择，在开发模式下的 `.js` 还是线上环境中的 `.min.js` 文件。下面的部分只是关于使用打包工具把 React 或者 Vue 从 npm 中 `import` 进来而使用它们。）**

像编程中的很多问题一样，这种特殊的约定大多是历史原因。我们还在使用它的原因是因为，它现在已经被很多其他的工具所接受并适应了。换成其他的会有很大的代价，并且不是特别值得这么做。

所以背后的历史原因究竟是什么？

在 `import` 和 `export` 的语法被标准化的很多年前，有很多方式来表达模块之间的关系。比如 Node.js 中所受欢迎的 `require()` 和 `module.exports`，也就是著名的 [CommonJS](https://en.wikipedia.org/wiki/CommonJS)。

在 npm 上注册发布的代码早期多数是针对 Node.js 写的 [Express](https://expressjs.com) 曾是（可能现在还是？）最受欢迎的服务端 Node.js 框架，它[使用 `NODE_ENV` 这个环境变量](https://expressjs.com/en/advanced/best-practice-performance.html#set-node_env-to-production) 来使线上模式生效。 一些其他的 npm 包也采用了同样的约定。

早期的 JavaScript 打包工具比如 browserify 想要在前端工程中使用 npm 中的代码。（是的，[那时候](https://blog.npmjs.org/post/101775448305/npm-and-front-end-packaging) 在前端中几乎没人使用 npm！你可以想象吗？）所以它们拓展了当时在 Node.js 生态系统中的约定，将之应用于前端代码中。

最初的 “envify” 变革是在 [2013 正式版](https://github.com/hughsk/envify/commit/ae8aa26b759cd2115eccbed96f70e7bbdceded97)。React 就是在差不多那个时候开源的，并且在那个时代 npm 和 browserify 看起来是打包前端 CommonJS 代码的最佳解决方案。

React 在很早的时候就提供 npm 版本（还有 `<script>` 标签版本）。随着 React 变得流行起来，使用 CommonJS 模块来写 JavaScript 的模块化代码、并使用 npm 来管理发布代码也变成了最佳实践。

React 需要在线上环境移除只应该出现在开发模式中的代码。刚好 Browserify 已经针对这个问题提供了解决方案，所以 React 针对 npm 版本也接受了使用 `process.env.NODE_ENV` 的这个约定，随着时间的流逝，一些其他的工具和框架，包括 webpack 和 Vue，也采取了相同的措施。

到了 2019 年时，browserify 已经失去了很大一部分的市场占有率。然而，在构建的阶段把 `process.env.NODE_ENV` 替换成 `'development'` 或者 `'production'` 的这项约定，却一如既往的流行。

**（同样有趣的是，了解 ES 模块的方式是如何一步步发展成作为线上的分发引用模式，而不仅仅只是在开发时使用的发展历史，它是如何慢慢改变天平的？在 Twitter 上告诉我）**

---

另一件你可能会感到迷惑的事是，在 GitHub 上 React **源码**中，你会看到 `__DEV__` 被作为一个神奇的变量来使用。但是在 npm 上的 React 代码里，使用的却是 `process.env.NODE_ENV`。这是怎么做到的？

从历史上说，我们在源码中使用 `__DEV__` 来匹配 Facebook 的源码。在很长一段时间里，React 被直接复制进 Facebook 的代码仓库里，所以它需要遵守相同的规则。对于 npm 的代码，我们有一个构建阶段，在发布代码之前会检查并使用 `process.env.NODE_ENV !== 'production'` 来字面地替换 `__DEV__` 。

这有时会有一个问题。某些时候，遵循 Node.js 约定的代码在 npm 上运行的很好，但是会破坏 Facebook，反之亦然。

从 React 16 起，我们改变了这种方式。取而代之，现在我们会针对每一个环境[编译一个包](https://reactjs.org/blog/2017/12/15/improving-the-repository-infrastructure.html#compiling-flat-bundles)（包括 `<script>` 标签、npm 和 Facebook 内部的代码仓库）。所以甚至是 npm 的 CommonJS 代码也被提前编译成独立的开发和线上包。

这意味着当 React 源码中出现 `if (__DEV__)` 的时候，事实上我们会对每一个包产出**两个**代码块。一个被预编译为 `__DEV__ = true` 另一个是 `__DEV__ = false`。每一个 npm 包的入口来“决定”该导出哪一个。

[例如：](https://unpkg.com/browse/react@16.8.6/index.js)

```js
if (process.env.NODE_ENV === 'production') {
  module.exports = require('./cjs/react.production.min.js');
} else {
  module.exports = require('./cjs/react.development.js');
}
```

这是你的打包工具把 `'development'` 或者 `'production'` 替换为字符串的唯一地方。也是你的压缩工具除去只应在开发环境中 `require` 代码的唯一地方。

`react.production.min.js` 和 `react.development.js` 不再有任何 `process.env.NODE_ENV` 检查了。这很有意义，因为**当代码真正运行在 Node.js 中的时候**， 访问 `process.env` [有可能会很慢](https://reactjs.org/blog/2017/09/26/react-v16.0.html#better-server-side-rendering)。提前编译两个模式下的代码包也可以帮助我们优化文件的大小变得[更加一致](https://reactjs.org/blog/2017/09/26/react-v16.0.html#reduced-file-size)，无论你使用的是哪个打包压缩工具。

这就是它的工作原理！

---

我希望有一个更好的方法而不是依赖约定，但是我们已经到这了。如果在所有的 JavaScript 环境中，模式是一个非常重要的概念，并且如果有什么方法能够在浏览器层面来展示这些本不该出现的运行在开发环境下的代码，那就非常棒了。

另一方面，在单个项目中的约定可以传播到整个生态系统，这点非常神奇。2010年 `EXPRESS_ENV` [变成了 `NODE_ENV`](https://github.com/expressjs/express/commit/03b56d8140dc5c2b574d410bfeb63517a0430451) 并在 2013 年[蔓延到前端](https://github.com/hughsk/envify/commit/ae8aa26b759cd2115eccbed96f70e7bbdceded97)。可能这个解决方案并不完美，但是对每一个项目来说，接受它的成本远比说服其他每一个人去做一些改变的成本要低得多。这教会了我们宝贵的一课，关于自上而下与自下而上的方案接受。理解了相比于那些失败的标准来说它是如何一步步地转变成功的标准的。

隔离开发和线上模式是一个非常有用的技术。我建议你在你的库和应用中使用这项技术，来做一些在线上环境很重，但是在开发环境中却非常有用（通常是严格的）的校验和检查。

和任何功能强大的特性一样，有些情况下你可能也会滥用它。这是我下一篇文章的话题！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
