> * 原文地址：[🚀webpack 4 beta — try it today!🚀](https://medium.com/webpack/webpack-4-beta-try-it-today-6b1d27d7d7e2)
> * 原文作者：[Sean T. Larkin](https://medium.com/@TheLarkInn?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/webpack-4-beta-try-it-today.md](https://github.com/xitu/gold-miner/blob/master/TODO/webpack-4-beta-try-it-today.md)
> * 译者：[FateZeros](https://github.com/FateZeros)
> * 校对者：[kangkai124](https://github.com/kangkai124)  [MechanicianW](https://github.com/MechanicianW)

# 🚀webpack 4 测试版 —— 现在让我们先一睹为快吧！🚀

![](https://cdn-images-1.medium.com/max/2000/1*BxhnE90lRYeLTxatyRDmqQ.jpeg)

为了支持数以百万计的功能，用例和需求，它需要一个安全，稳定，可靠和可拓展的基础。只有 webpack 具有无限的可能性。

## 稳定的发布之路！

自八月初以来 —— 当我们从 `**webpack/webpack#master**` 中分出 `**next**` 分支的时候 —— 我们看到了惊人的贡献量涌入。

![](https://cdn-images-1.medium.com/max/800/1*kJm7dIWWR7DzZa-OW_z6gQ.png)

可以使用 [gitinspector](https://github.com/ejwa/gitinspector) 一目了然地查看 webpack **next** 分支上的 Git 贡献统计信息。可以在你的项目上尝试一下，来仔细研究下。 **PS：这还不包括我们的 webpack-cli 团队 和 webpack-contrib 组织，他们在支持加载器和插件上面做了大量的工作。**

**🎉 今天，我们很自豪能够通过发布 webpack 4.0.0 - beta.0 来分享这项工作的成果！** **🎉**

#### 🎁一个实现的承诺 —— 可预测的发布周期

当我们完成了 webpack 3 的发布之后，我们向社区保证，主要版本的更迭会有一个更长的开发周期。

我们已经兑现了这个承诺[并继续为之付诸实施]，给你们带来了一大套特性，改进和错误修复，我们已经迫不及待地期待你们的实践！开始吧！

#### 🤷‍怎么安装 [v4.0.0-beta.0]

如果你用的是 `yarn`:

`yarn add webpack@next webpack-cli --dev`

或者 `npm`:

`npm install webpack@next webpack-cli --save-dev`

#### 🛠怎么迁移？

只有更多的人帮助测试 webpack 4，并且反馈不兼容的插件和加载器，我们才能构建一份更加生动的迁移指南。

**因此我们需要你看看**[**官方的更新日志**](https://github.com/webpack/webpack/releases/tag/v4.0.0-beta.0) **还有**[**我们的迁移草案**](https://github.com/webpack/webpack/issues/6357)**并提供我们有所缺失的反馈！这将帮助我们的文档团队创建我们的官方稳定版本迁移指南！**

### webpack 4 中有什么新功能呢？

下面就是一些你将会喜欢看到的更值得注意的功能。若想了解更新，功能和内部 API 修改的**完整的清单**,[**请参阅我们的修改日志**](https://github.com/webpack/webpack/releases/tag/v4.0.0-beta.0)

### 🚀更好的性能

在 webpack 4 的多个场景中，性能将显着增强。下面是我们为实现这一目标而做出的一些显著改动：

* 默认情况下，在使用 `production` 模式时，我们会使用 UglifyJS 自动并行编译和缓存来减少工作量 。
* 我们发布了一个新版的[**插件系统**](https://github.com/webpack/tapable)以便事件钩子和处理函数是单一形态的。
* 另外，webpack 现已放弃对 Node v4 的支持，使我们能够添加大量的新型 ES6 语法和数据结构，并且也通过 V8 进行了优化。**迄今为止，我们已经收到几份[构建时间由 1 小时减少到 12 分钟](https://github.com/webpack/webpack/issues/6248)的真实报告**！

PS: 我们还没有完全实现缓存和并行化 😉 这是[webpack 5 的里程碑]。

### 🔥更好的默认配置 —— 零配置

直到今天，webpack 一直要求你明确设置你的 `entry` 和 `output` 属性。对于 webpack 4 ，webpack 会自动假设你的 `entry` 属性是 `./src`，并且打包会默认输出到 `./dist` 中。

这意味着 **你开始使用 webpack 不再需要一个配置！**

![](https://cdn-images-1.medium.com/max/1000/1*SmNPl3vyqGNg6Mqy0GqKyg.png)

webpack 4.0.0-beta.0 运行一个没有配置的版本

现在 webpack 是一个零配置开箱即用的打包器，我们将为 **4.x** 和 **5.0** 奠定基础，以便将来提供更多的默认功能。

### 💪更好的默认模式 —— mode

你现在必须在两种模式之间选择 (`mode` 或 `--mode`)：`production` 或 `development`

* 生产模式可以为你提供各种优化。这包含代码压缩，作用域提升，未引用模块移除，无副作用模块修剪，还包含引入一些像 `NoEmitOnErrorsPlugin` 这样需要你手动使用的插件。
* 开发模式优化了开发速度和开发体验。同样，我们会自动在你的包输出中包含像路径名，eval-source-maps 这样的功能，以便阅读代码和快速构建！

### 🍰sideEffects 设置 —— 在打包体积上巨大的胜利

我们在 package.json 中引入了对 `sideEffects: false` 的支持。当这个字段被添加时，它向 webpack 发出信号，表示被使用的库没有副作用。这意味着 webpack 可以安全地清除你代码中使用的任何重复导出模块。

例如，从 `lodash-es` 中单独导入 `export` 将会花费 ~223 KiB [压缩后的]。**在 webpack 4 中，现在这只花费 ~3 KiB !**

![Snipaste_2018-01-27_16-52-08.png](https://i.loli.net/2018/01/27/5a6c3dc6a8391.png)

### 🌳支持 JSON 和 Tree Shaking

当你使用 ESModule 语法 `import` JSON 时，webpack 会消除 “JSON Module” 中未使用的导出。对于那些已经将大量未使用模块的 JSON 导入到你的代码的应用，你会看到 **你打包体积明显减小**。

### 😍升级到 UglifyJS2

这意味着你可以使用 ES6 语法，压缩它，而无需使用转换器。

我们要感谢 UglifyJs2 的贡献者团队为支持 ES6 而付出的无私和辛勤的努力。这不是一件简单的任务，我们很乐意拜访[你们的代码仓库来表达对你们的感谢和支持](https://github.com/mishoo/UglifyJS2/graphs/contributors?from=2017-01-14&to=2018-01-25&type=c)。

![](https://cdn-images-1.medium.com/max/800/1*rt3uFkb9IAHddXLxYMjCgw.png)

UglifyJS2 现在支持 ES6 JavaScript 语法！

### 🐐 模块类型的引入 + 支持 .mjs

历史上，JavaScript 是 webpack 中唯一的一流模块类型。这给那些不能高效的打包 CSS/HTML 的用户带来了很多尴尬的痛苦。我们完全从我们的代码库中抽象出了 JavaScript 特性，以允许这个新的 API。目前建成，我们现在有5个模块类型实现引入：

* `javascript/auto`: (在 **webpack 3** 默认启用) 启用了所有的 Javascript 模块系统：CommonJS，AMD，ESM
* `javascript/esm`: EcmaScript 模块，所有的其他模块系统不可用（默认 .mjs 文件）
* `javascript/dynamic`: 只有 CommonJS 和，EcmaScript 模块不可用
* `json`: JSON 数据，它可以通过 require 和 import 来引入使用（默认 .json 的文件）
* `webassembly/experimental`: WebAssembly模块（当前为 .wasm 文件的实验文件和默认文件）
* 另外 webpack 现在支持查找 `.wasm`, `.mjs`, `.js` 和 `.json` 拓展文件来解析

**这个功能最让人兴奋的是，我们可以继续使用 CSS 和 HTML 模块模型 （4.x）。**这将允许像 HTML 这样的功能作为你的入口点！

### 🔬支持 WebAssembly

Webpack 现在默认支持任何本地 WebAssembly 模块的 `import` 和 `export`。这意味着你也可以写加载器，让你可以直接 `import` Rust，C++，C 和其他 WebAssembly 语言：

### 💀去除 CommonsChunkPlugin

我们也删除了 `CommonsChunkPlugin`，并默认启用了它的许多功能。另外，对于需要对其缓存策略进行细粒度控制的用户，我们已经添加了 `optimization.splitChunks` 和 `optimization.runtimeChunk` [它们具有更丰富，更灵活的功能](https://gist.github.com/sokra/1522d586b8e5c0f5072d7565c2bee693)

### 💖还有更多！

还有很多的功能 **我们强烈建议你在我们的**[**官方更新日志**](https://github.com/webpack/webpack/releases/tag/v4.0.0-beta.0)上查看所有。

### ⌚ 从现在开始倒计时

**正如所承诺的那样，我们将从今天开始等待一个月，然后再发布 webpack 4 稳定版。** 这使我们的插件，加载器和集成生态系统有时间去测试，报告并升级到 webpack 4.0.0 中！

![Snipaste_2018-01-27_16-54-02.png](https://i.loli.net/2018/01/27/5a6c3e33c6cd1.png)

我们需要你帮助我们升级和测试这个测试版。我们今天测试的越多，我们就可以更快的分诊和识别任何可能出现的问题！

非常感谢所有帮助我们完成 webpack 4 的贡献者。正如我们所说，wepack 的成就是我们大家和生态系统的的共同努力造就的。

* * *

没有时间帮忙贡献？想要以其他方式回馈？通过[捐助给我们的开放集体](https://opencollective.com/webpack)成为 webpack 的支持者或赞助商。开放集体不仅有助于支持核心团队，也支持花费了大量空闲时间改善组织的贡献者！ ❤

感谢[Florent Cailhol](https://medium.com/@ooflorent?source=post_page), [Tobias Koppers](https://medium.com/@sokra?source=post_page), 和[John Reilly](https://medium.com/@johnny_reilly?source=post_page).


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
