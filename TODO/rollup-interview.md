> * 原文地址：[Rollup - Next-generation ES6 module bundler - Interview with Rich Harris](https://survivejs.com/blog/rollup-interview/)
> * 原文作者：[SurviveJS](https://twitter.com/survivejs)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/rollup-interview.md](https://github.com/xitu/gold-miner/blob/master/TODO/rollup-interview.md)
> * 译者：[Raoul1996](https://github.com/Raoul1996)
> * 校对者：[Usey95](https://github.com/Usey95)、[Aladdin-ADD](https://github.com/Aladdin-ADD)

# Rollup - 下一代 ES6 模块化打包工具 - 对 Rich Harris 的采访

鉴于浏览器目前尚不能按照“原样”解析 JavaScript 源码，所以**打包**这一步必不可少。将源代码编译成浏览器可以理解的形式，这是打包工具（例如 Browserify，Rollup 或者 webpack）存在的原因。

为了深入探讨这个话题，我们正在采访 Rollup 的作者  [Rich Harris](https://twitter.com/Rich_Harris)。

> 我早些时候已经采访过 [Rich，他同样是 UI 框架 Svelte 的作者](https://survivejs.com/blog/svelte-interview/)。

## 你可以介绍下自己吗？

![Rich Harris](https://www.gravatar.com/avatar/329f9d32fe20b186838ee237d3eb2d43?s=200) 我是在纽约时报调查组工作的图形编辑，身兼记者和开发者职位。在此之前，我在卫报做差不多的工作。过去我的部分职责是开发工具去让我们用新闻的速度新建、部署项目。这个过程或许有点激进 —— [Rollup](https://rollupjs.org)，[Bublé](https://buble.surge.sh) 和 [Svelte](https://svelte.technology) 等都是那个时期的产物。

## 你会怎样把 _Rollup_ 介绍给一个从未听说过它的人？

Rollup 是一个模块化的打包工具。本质上，它会合并 JavaScript 文件。而且你不需要去手动指定它们的顺序，或者去担心文件之间的变量名冲突。它的内部实现会比说的复杂一点，但是它就是这么做的 —— 合并。

这么做的原因是你可以使用 ES2015 中新增的 `import` 和 `export` 关键字来模块化编程，这样在很多方面上更加明智。因为浏览器和 Node.js 还没有提供原生的 ES2015 module（ESM）支持，所以我们模块必须在打包之后才能运行。

Rollup 可以打包出自执行（self-executing）的 `<script>` 文件，AMD 模块，Node 友好的 CommonJS 模块，UMD 模块（兼容三者），甚至是可以在 _其他_ 项目中使用的 ESM 模块。

这是库的理想选择。实际上，大多数的 JavaScript 库（React，Vue，Angular，Glimmer，D3，Three.js，PouchDB，Moment，Most.js，Preact，Redux等）都是用 Rollup 构建的。

## _Rollup_ 是怎样工作的呢？

你给它一个入口文件 —— 通常是 `index.js`。Rollup 将使用 Acorn 读取解析文件 —— 将返回给我们一种叫抽象语法树（AST）的东西。 一旦有了 AST ，你就可以发现许多关于代码的东西，比如它包含哪些 import 声明。

假设 `index.js` 文件头部有这样一行：

```
import foo from './foo.js';
```

这就意味着 Rollup 需要去加载，解析，分析在 index.js 中引入的 ./foo.js。重复解析直到没有更多的模块被加载进来。更重要的是，所有的这些操作都是可插拔的，所以您可以从 `node_modules` 中导入或者使用 sourcemap-aware 的方式将 ES2015 编译成 ES5 代码。

## _Rollup_ 和其他解决方案有何不同？

首先，零开销。传统的打包方式是将模块封装到独立的函数中，将这些函数放进一个数组中，然后实现一个可以将这些函数从数组中取出并按需执行的 `require` 函数。事实证明这样打包体积和启动时间都会[很糟糕](https://nolanlawson.com/2016/08/15/the-cost-of-small-modules/)。

相反，Rollup 事实上只是会合并你的代码 —— 没有任何浪费。所产生的包也可以更好的缩小。有人称之为 “作用域提升（scope hoisting）”。

其次。它把你导入的模块中的未使用代码移除。这被称为“（摇树优化）treeshaking”。没有什么确切的原因。

值得注意的是，webpack 最新版本实现了作用域提升和摇树优化，所以它在打包体积和启动时间上赶上了 Rollup（尽管我们还是遥遥领先）。如果你构建的不是一个库，那么通常 webpack 是一个更好的选择，因为它有很多 Rollup 不具有的功能 —— 比如代码分割，动态导入等等。

> 理解工具间的差异，[请阅读 “同中有异的 Webpack 与 Rollup”](https://medium.com/webpack/webpack-and-rollup-the-same-but-different-a41ad427058c) 或者[[译] 同中有异的 Webpack 与 Rollup](https://juejin.im/post/58edb865570c350057f199a7)。
> 

## 为什么你要开发 _Rollup_ 呢？


必要性。现有的工具都不够好。

几年前，我正在开发一个名叫  [Ractive](https://ractive.js.org) 的项目。构建的过程让我十分沮丧。我们越是把代码库分解成模块，由于之前我描述的开销的原因，构建得越大。我们做了正确的事情但是却遭受着处罚。

所以我写了一个叫 Esperanto 的模块打包工具，并且作为单独的开源项目将其发布。瞧，我们的打包体积缩小了，但是我并不满意。因为我读过 [Jo Liss](https://twitter.com/jo_liss) 写的关于如何设计静态分析的 ESM 能够让我们进行摇树优化（treeshaking），然而 Esperanto 做不到这一点。

在 Esperanto 上增加摇树优化会非常困难，所以我放弃了它，并用 Rollup 重新开发。

> 想了解更多关于 ESM 的信息, [请阅读对 Bradley Farias 的采访](https://survivejs.com/blog/es-modules-interview/).

## 接下来做什么？

我很乐意把 Rollup 开发到大家认为“完毕”的程度，这样我就可以不用再考虑它了。这并不是一个令人兴奋的项目，因为模块打包是一个无聊至极的主题。这基本上只是水暖（plumbing）—— 必不可少但却毫无魅力可言。

当然到达那里我还有很长的路需要走，同时我还觉得我有着照看社区的责任，因为我一直是 ESM 的倡导者。

现在我们正在进入一个激动人心的地方 —— 浏览器陆续开始添加本地模块支持，而且现在 webpack 支持作用域提升，在各处使用 ESM 都会有很实在的好处。所以我们希望尽快看到 ESM 接管 CommonJS。（如果你还在写CommonJS，别写了！你这是在制造技术债务）.

## 总的来说， _Rollup_ 和 web 开发在未来将会是什么样子？你有哪些预测呢？

一方面，Rollup 会变得越来越过时。一旦浏览器提供原生的本地模块支持的时候，将会有一大类把打包（以及与之相关的一切 —— 编译，压缩等）作为一个可选而非必须的性能优化的应用。这将是 _大趋势_ ，尤其是对于 web 开发的新手来说。

但是与此同时，我们越来越多地使用构建流程为我们的应用添加复杂的功能。我是这个的支持者 —— [Svelte](https://svelte.technology) 基本上是从声明模板开始为你编写应用程序的一个编译器。而且伴随着 WASM 以及其他东西的横空出世，它只会变得更激烈。

所以有两个看起来矛盾的趋势同时发生了，看看它们怎么发展将会是很有趣的。

## 您对进行 web 开发的程序员有什么建议呢？

站在其他程序员的肩膀上。读源码，通过构建一些东西来体会开发，并以此为荣而不要自满。学习基础知识，因为任何的抽象都不可能天衣无缝（all abstractions are leaky）。搞清楚“任何的抽象都不可能天衣无缝”的意思。关掉你的电脑，走出门外。因为大多数好戏都会在键盘之外发生。

最重要的是，采取一撮盐的编程建议（take programming advice with a pinch of salt）。 一旦有人达到别人开始要求他们提供建议的阶段，他们就忘记自己当初是新手的感觉。没有人无所不知，无所不能。

## 接下来我应该去采访谁？


我真的很喜欢跟随跨越 JavaScript 和其他学科（例如 DataGL，WebGL，制图和动画等）的人们的工作 —— 像 [Vladimir Agafonkin](https://twitter.com/mourner)，[Matthew Conlen](https://twitter.com/mathisonian)，[Sarah Drasner](https://twitter.com/sarah_edo)，[Robert Monfera](https://twitter.com/monfera) 和 [Tom MacWright](https://twitter.com/tmcw) 这样的人。

在更广泛的 web 开发前沿，我一直喜欢和 [Dylan Piercey](https://twitter.com/dylan_piercey) 交流 [Rill](https://rill.site)。这是一个可以让你编写在浏览器中运行的 Express 风格应用的通用的路由（router），这个想法很棒。对我来说，它达到了提高生产力而不过多限制使用者的最佳状态。


## 最后随意说点什么？

Rollup 非常感谢您的帮助！ 这是当今生态中相当重要的一部分，但是我没有足够的时间去给予足够的重视，对我们的所有贡献者也是这样。如果您有兴趣提供能让数百万（甚至数十亿）网络用户受益的工具，请联系我们。


## 结论

感谢您采访 Rich ！Rollup 是一个十分了不起的工具，尤其是对于库作者来说，非常值得学习。希望有一天我们可以跳过整个打包步骤，那么这样会让事情简单不少。

想了解更多关于 Rollup 的信息，[请阅读在线文档](https://rollupjs.org/)。你也可以[在 GitHub 上找到这个项目](https://github.com/rollup/rollup)。

2017年7月10日

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
