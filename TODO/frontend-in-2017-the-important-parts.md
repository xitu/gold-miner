> * 原文地址：[Frontend in 2017: The important parts](https://blog.logrocket.com/frontend-in-2017-the-important-parts-4548d085977f)
> * 原文作者：[Kaelan Cooter](https://blog.logrocket.com/@eranimo?asource=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/frontend-in-2017-the-important-parts.md](https://github.com/xitu/gold-miner/blob/master/TODO/frontend-in-2017-the-important-parts.md)
> * 译者：[gy134340](https://github.com/gy134340)
> * 校对者：[tvChan](https://github.com/tvChan), [zhouzihanntu](https://github.com/zhouzihanntu)

# **前端 2017: 举要删芜**

![](https://cdn-images-1.medium.com/max/1000/1*kTjbJH9x_nfRNgBduM3Oqg.png)

2017 年发生了很多事，想起来，嗯，确实有点多。我们都喜欢拿前端开发领域的变化之快开玩笑，而在过去几年中事实也确实如此。

尽管听起来可能会有些陈词滥调，今天我想说事情不一样了。

前端趋于稳定 —— 流行的库基本上已经得到了大众化而不是被竞争者抢去风头 —— 同时 web 开发变的很棒了。

这篇文章，我将着眼于大的趋势来总结今年前端生态中发生的一些重要事件。

#### **统计数据**

很难说什么是下一件大事什么时候到来，特别是你还在上一件大事之中时。获取开源工具正确的数据很难，通常情况下我们看下面几个地方：

* **GitHub star 数量** 跟流行库趋势有一丢丢关联，但人们通常只是给那些有趣的项目 star 然后再也不会来了。
* **Google 趋势** 可以帮助我们粗糙的看到流行趋势，但是不能提供足够的数据来与一些特定的工具集做对比。
* **Stack Overflow 问题数量** 更多的只是可以看出人们对这一项技术的问题而不是这个东西的流行度。
* **NPM 下载量** 是人们下载这些库最精确的统计数据，即使这些也不是 100% 准确的，因为包括了一些可能的持续集成的自动下载数据。
* **一些调查** 比如 [2017 年 JavaScript 的发展](https://stateofjs.com/) 是基于大量样本（ 20,000 个开发者）的调查，这对看出趋势很有用。


### 框架

#### React

[React 16](https://reactjs.org/blog/2017/09/26/react-v16.0.html) 在 9 月发布，带来一个完全重写的核心架构，同时没有任何重大 API 的变化。这个新版本提供了改进的错误处理机制 [error boundaries](https://reactjs.org/blog/2017/07/26/error-handling-in-react-16.html)，以及支持将渲染树的一个子部分渲染到另一个 DOM 节点上。

 React 团队重写核心库是为了将来更好的支持异步，这是现在的版本做不到的。异步渲染下，React 在渲染大型应用时将不会阻塞主线程。这一计划是为了在未来的 React 16 的小版本提供这一可选功能，所以你可以在 2018 前期待一下这个功能。

React 在前段时间关于 BSD 协议的争论后 [切换到了 MIT 协议](https://code.facebook.com/posts/300798627056246/relicensing-react-jest-flow-and-immutable-js/)。由于先前条款的太多限制，导致了很多团队考虑切换一个备选的 JavaScript 视图框架。然而，一直有争论这个是 [无依据的](https://blog.cloudboost.io/3-points-to-consider-before-migrating-away-from-react-because-of-facebooks-bsd-patent-license-b4a32562d268), 同时新的专利协议让 React 的用户受到了更少的保护。

#### Angular

在各种 beta 版本发布之后和候选版本中，Angular 4 于三月发布了。这个版本的关键特性是预编译 —— 在 build 时编译而不是 render 时编译。这意味着 Angular 应用程序不再需要为应用程序视图提供编译器 ，从而大大减少了包的大小。此版本还改进了对服务器端渲染的支持，并为 Angular 模板语言增加了许多小的“生活质量”改进。

在 2017 年，相对 React 来说，Angular 持续丢失份额。虽然 Angular 4 是一个流行的版本，它还是离年初时的高点很远。

![](https://cdn-images-1.medium.com/max/800/0*EElb5vgfVEQaMzL3.)

Angular、React 和 Vue 的 NPM 下载量

来源: npmtrends.com

#### Vue.js

对 Vue 来说，2017年是伟大的一年，使得它作为一个前端视图层的框架与 React 和 Angular 并列。它因为简单的 API 和全套的企业解决方案而流行。由于采取类似 Angular 的模版语言和类似 React 的组件化思想，它常作为这两者之间的折中方案。

Vue 在过去一年里爆炸式的增长。同时产生了数量相当多的 [流行组件库](https://github.com/vuejs/awesome-vue#components--libraries) 和模版项目。

大量的公司也开始采用 Vue —— Vue — Expedia, Nintendo, GitLab [包括很多其他项目](https://madewithvuejs.com/)。

在年初，Vue 有 37k GitHub star 和 npm 上每周 52k 的下载量。到 12 月中旬时，它已经有了 76k 的 star 和每周 266k 的下载量，分别是以前的两倍和五倍。

这对比 React 仍然很苍白，根据 NPM 的数据 React 有每周 1600k 的下载量。可以期待 Vue 的继续高速成长，2018 也许它会成为最顶级的两个框架之一。

**总结：** React 目前领先，但是 Angular 仍在追赶。同时，Vue 可以感受到人气的飙升。

### ECMAScript

在全面的[提议流程](https://github.com/tc39/ecma262)完成之后，JavaScript 的 2017 ECMAScript 标准在 6 月发布，包含一些开创性的特性，比如说异步函数，共享内存和原子操作。

异步函数可以让我们写简洁清晰的异步代码，它们现在被所有浏览器[支持](https://caniuse.com/#search=async%20fun)，在升级到 V8 5.5 之后，NodeJS 在 v7.6.0 中增加了对它们的支持，在 2016 年末发布同时带来了重要的性能和内存优化。

[共享内存和原子操作](http://2ality.com/2017/01/shared-array-buffer.html)是一个非常重要的特性，但还没有引起足够的重视。共享内存由 `SharedArrayBuffer` 构造实现，允许 web workers 在内存中访问数组中相同的 bytes。 Workers (和主线程) 使用 `Atomics` 提供的原子操作方法在不同执行上下文中安全的访问内存。`SharedArrayBuffer` 提供相比较 message 一种相对于对象的传递更快的通讯方法。

采用共享内存在将来将非常重要，对 JavaScript 应用和游戏贴近原生的性能意味着 web 平台将变得及其有竞争力。应用在浏览器中可以变的更加复杂和做更多昂贵的操作，同时不需要牺牲性能或者把任务放在后端。一个真实的共享内存的并行架构对用 WebGL 和 web workers 来开发游戏的人是非常棒的优势。

截至2017年12月，所有主流浏览器都支持这一特性，同时 Edge 在 v16 之后开始支持，Node 不支持 web workers，所以没有计划支持共享内存。但是，它们在[重新考虑对 worker 的支持](https://github.com/nodejs/node/issues/13143)，所以还是有可能在将来找到把这一特性放在 Node 中的方式。

**总结：** 共享内存让 JavaScript 的并行计算更加简单和高效。

### WebAssembly

WebAssembly (或者 WASM) 提供一种用其他语言编写然后编译成可以在浏览器中执行的方法。这种偏底层的类汇编的语言设计出来用来获取接近原生的性能。JavaScript 现在可以通过新的 API 加载 WebAssembly 的模块。

这个 API 还提供一个可以让 JavaScript 用 WebAssembly 模块实例，直接读取和操作内存的[内存构造函数](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_objects/WebAssembly/Memory), 可以和 JavaScript 应用高度整合。

[所有主流浏览器](https://caniuse.com/#feat=wasm)现在都支持 WebAssembly，Chrome 在五月，Firefox 在三月，Edge 在十月。Safari 在第 11 个版本，和 MacOS High Sierra 一同发布，使用原版本的现在可以获取更新。Chrome 安卓版以及 Safari 移动端现在都支持 WebAssembly。

你可以使用 [emscripten](http://kripken.github.io/emscripten-site/index.html) 编译器将 C/C++ 代码编译成 WebAssembly，[Rust](https://developer.mozilla.org/en-US/docs/WebAssembly/C_to_wasm) 和 [OCaml](https://github.com/sebmarkbage/ocamlrun-wasm) 也可以。同时还有很多种方法将 JavaScript（或者其他类似的）编译成 WebAssembly。比如说，[Speedy.js](https://github.com/MichaReiser/speedy.js) 和[AssemblyScript](https://github.com/AssemblyScript/prototype)使用 TypeScript 来检测类型，但是添加了低级的类型和基础的内存管理。

这些项目暂时都还没有在生产环境，同时他们的 API 经常变化。有了把 JS 编译成 WebAssembly 的[愿望](https://github.com/WebAssembly/design/issues/219)，人们可以预知这些项目可以 在 WebAssembly 的流行中获取动力。

同时已经有[很多有趣的 WebAssembly 项目](https://github.com/mbasso/awesome-wasm)。有一个针对 C++ 的 [虚拟 DOM 实现](https://github.com/mbasso/asm-dom)，允许用 C++ 创建整个前端应用。如果你的项目使用 Webpack，有一个 [wasm-loader](https://github.com/ballercat/wasm-loader) 就不需要手动的操作 fetch，直接解释 `.wasm` 类型的文件。[WABT](https://github.com/WebAssembly/wabt) 提供了一堆将二进制和 WASM 二进制的文本格式，打印信息之间转换的工具，以及 merge `.wasm` 文件。

预计 WebAssembly 将在未来一年变得更加流行，因为更多的工具已经开发出来，JavaScript社区也在意识到它的可能性。它现在还在 “试验” 阶段，浏览器也刚开始支持。它将成为优化 CPU 密集型任务和图像及 3D 处理的好工具。最终，随着它的成熟，我推测会在日常应用中获得更多的使用案例。

**总结：** WebAssembly 最终会改变一切，但它现在还很新。

### 包管理工具

2017 年 JavaScript 包管理工具也发生了巨变，Bower 持续衰落，被 NPM 替代。它最后的版本是 2016 年 9 月，它的管理者现在[官方建议](https://github.com/bower/bower/pull/2458)用户在前端项目里使用 NPM。

Yarn 在 2016 年 10 月发布给 JavaScript 包管理带来革新。虽然它使用 NPM 相同的包仓库，Yarn 提供了更快的依赖下载，安装速度和更友好的 API。

Yarn 的 lock 文件可以确保每次重新 build 后的文件在不同机器上总是一致的，同时离线模式即在用户不联网情况下重新安装包。因为它的受欢迎程度大大增加，成千上万的项目开始使用它。

![](https://cdn-images-1.medium.com/max/800/0*nn0TySEdCgPs-G0x.)

_GitHub  Yarn (紫) 和 NPM (棕)._ 来源: GitHub Star 历史

NPM 作为反击，带来了巨大性能改变和 API 彻底调整的 v5 版本。同时 Yarn 宣布了 [Yarn Workspaces](https://yarnpkg.com/blog/2017/08/02/introducing-workspaces/), 允许跟 [Lerna](https://github.com/lerna/lerna) 类似的高级 monorepo 支持。

还有更多除 Yarn 和 NPM 之外的 NPM 客户端，比如另一个流行的 [PNPM](https://github.com/pnpm/pnpm)，宣称它是 “更快，更节省存储的包管理工具”，不同于 Yarn 和 NPM，它保留对所有安装包的全局缓存，同时向你的软件包的 node_modules 文件中添加这些符号链接。

**总结：** NPM 针对 Yarn 的流行迅速的调整自己，他们都很棒。

### 样式表

#### 最近的更新

在过去的几年里 CSS 预处理器比如 SASS, Less 和 Stylus 变得很流行，在 2014 年发布的 [PostCSS] (https://github.com/postcss/postcss) 在 2017 真正的爆发，成为最流行的 CSS 预处理器。不同于其它预处理器，PostCSS 采用与 Babel 类似的插件模块的方法。在转换样式表之外它还提供 linter 和其他工具。


![](https://cdn-images-1.medium.com/max/800/0*YPde_bP7PQlyGuxs.)

2017 NPM PostCSS, SASS, Stylus, 和 Less 下载量

来源: NPM 统计数据，2017 年 12 月 15 日

还有一些基于组件开发时使用 CSS 的底层问题需要解决。特别是，全局命名空间让单个组件的分离样式开发很困难。让 CSS 文件在另一个文件而不是在组件代码里意味着占用更多空间同时在开发中需要引用两个文件。

[CSS 模块化](https://github.com/css-modules/css-modules) 通过添加组件单独的命名空间来分离组件和通用的样式，这可以用不同的类名来为每个类来实现。在类似 Webpack 的构造系统中，这已经成为普遍采用的可行的方法，用[css-loader](https://github.com/webpack-contrib/css-loader) 来支持模块化。PostCSS 有一个支持同样功能的 [插件](https://github.com/css-modules/postcss-modules)。但是这种方法还是把 CSS 文件放在组件代码之外。

#### 其他解决办法

“CSS in JS” 是一个在 2014 年末由一个 Facebook 的 React 开发团队者 Christopher 在 [一个著名的演讲](https://speakerdeck.com/vjeux/react-css-in-js) 提出，同时衍生出一些更易创建组件化样式的有影响的库。目前最流行的解决方法是使用 ES6 [tagged template literals](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Template_literals) 来从 CSS 字符串中创建组件的 [styled-components](https://github.com/styled-components/styled-components) 库。

另一个流行的方法是 [Aphrodite](https://github.com/Khan/aphrodite)，使用 JavaScript 对象字面量创建与框架无关的内联样式。在 [JavaScript 2017] 调查中，34% 的开发者声称他们使用过 CSS-in-JS。

**总结：** PostCSS 是首选的 CSS 预处理器，但是很多人转向 CSS-in-JS 的方法

### 打包工具

#### Webpack

2017年 Webpack 巩固其领先于前一代 JavaScript 打包工具的地位：


![](https://cdn-images-1.medium.com/max/800/0*93D2VJU6CrNg6QLv.)

NPM 上 Webpack， Gulp， Browserify， Grunt 的下载量

来源: npmtrends.com

Webpack 2 在今年二月发布，它带来比如 ES6 模块化（不在需要 Babel 转换 import 语句了）和 tree shaking（删除无用的代码）这样的重要特性，V3 不久后也发布了，带来一个 “scope hoisting” 的特性，可以把所有的 webpack 模块打包成一个文件，极大的减少了文件体积。

在 6 月，webpack 团队[接到](https://medium.com/webpack/webpack-awarded-125-000-from-moss-program-f63eeaaf4e15) Mozilla 开源组的授权去开发 WebAssembly 的高级支持。这一计划最终目的是让 WebAssembly 和 JavaScript 打包工具可以深度整合。

在打包领域还有一些与 Webpack 无关的的创新空间，它在流行的同时，开发者也在抱怨配置使用它的困难和对于大型项目优化所需要的一堆插件。

#### Parcel

[Parcel](https://github.com/parcel-bundler/parcel) 是一个有趣的项目，在 12 月上旬引起关注（只用 10 天收获 10000 star）。宣称自己速度极快，同时零配置。它通过利用 CPU 的多核心和高效的文件缓存达到目的。它操作抽象语法树而不是像 Webpack 的字符串。像 Webpack 一样，Parcel 也打包非 JavaScript 的资源文件，像图片和样式表文件。

这个模块工具展示了一个 JavaScript 社区通常的模式：不停的在开箱即用（集中）与配置一切（分散）之间切换。

我们从 Angular 到 React/Redux，SASS 到 PostCSS 的转变中可以看出这一点。Webpack 与在它之前出现的各种打包及任务处理工具一样，都是使用许多插件来进行分散配置的解决方案。


事实上，Webpack 和 React 在 2017 因为几乎一样的原因受到抱怨，人们期待开箱即用的解决方案，这很重要。

#### Rollup

在 2016 年发布 Webpack 2 之前，Rollup 引起了大家广泛的关注，引入了一个叫做 tree shaking 的流行功能，这是一种移除不用的代码的有趣方法。 Webpack 在第二个版本中为 Rollup 的签名功能提供了[支持](https://webpack.js.org/guides/tree-shaking/)这个来回应 Rollup 的签名特性。Rollup 跟 Webpack 相比[不同的打包方式](https://stackoverflow.com/questions/43219030/what-is-flat-bundling-and-why-is-rollup-better-at-this-than-webpack)，让总的打包体积更小，同时也不能[支持](https://github.com/rollup/rollup/issues/372)代码分割这一重要的特性了。

在 4 月 React 的团队从 Gulp [切换](https://github.com/facebook/react/pull/9327) 到 Rollup, 很多人问为什么选择 Rollup 而不是 Webpack。Webpack 回应称[推荐](https://medium.com/webpack/webpack-and-rollup-the-same-but-different-a41ad427058c) Rollup 作为库的开发工具而 Webpack 作为应用的开发方式这篇文章来解决大家的疑惑。


**总结：** Webpack 仍是最流行的打包工具，但也许不会永远是这样。

### TypeScript

在 2017 [Flow](https://github.com/facebook/flow) 相对于 [TypeScript](https://github.com/Microsoft/TypeScript) 来说丢失了大量的份额：

![](https://cdn-images-1.medium.com/max/800/0*1WUQKu98izZcyQwf.)

Flow 对比 TypeScript NPM 2017 下载量 2017 来源: NPM 趋势

虽然这一趋势在持续了几年，但在 2017 年加快了步伐，TypeScript 现在是 2017 Stack Overflow 开发者调查中[第三受喜欢的语言](https://insights.stackoverflow.com/survey/2017#technology)（Flow 并没有在这里提及）。

TypeScript 胜利的原因包括：更好的工具（特别是 [Visual Studio Code](https://code.visualstudio.com/) 编辑器），lint 工具（[tslint](https://github.com/palantir/tslint) 变的超级流行），更大的社区，更多第三方类型库，更好的文档，和更简单的配置。最早 TypeScript 做为 Angular 项目的可选语言而逐渐流行，现在已经巩固了在整个社区的使用度。根据 [Google 趋势](https://trends.google.com/trends/explore?date=2015-12-15%202017-12-15&q=%2Fm%2F0n50hxv)，TypeScript 今年流行度上升了一倍。

TypeScript 采取[快速开发](https://github.com/Microsoft/TypeScript/wiki/Roadmap)的方式，这使得它可以不断微调类型系统来跟上 JavaScript 语言。它现在支持 ECMAScript 的 iterators, generators, 异步 generators，以及动态 import 特性。你现在可以根据 TypeScript 的类型接口和 JSDoc 注释来 [检查 JavaScript 的类型](https://www.typescriptlang.org/docs/handbook/type-checking-javascript-files.html)。 如果你使用 Visual Studio Code，TypeScript 现在在编辑器中支持出色的转换工具，允许重命名变量和自动导入包。

**总结：** TypeScript 赢了 Flow。

### 状态管理

Redux 仍然是 React 项目的首选状态管理解决方案，在 2017 年整个 NPM 下载量增长了 5 倍：


![](https://cdn-images-1.medium.com/max/800/0*dgXzSYQF9HFyVEvc.)

2017 Redux 在 NPM 的下载量

来源: NPM 趋势

Mobx 是 Redux 在客户端状态管理上有趣的竞争者，不像 Redux, MobX 使用可观察的状态对象和一个受 [响应式函数式编程](https://github.com/lucamezzalira/awesome-reactive-programming) 概念启发的 API。Redux 的不同之处在于被传统函数式编程影响和纯函数的支持， Redux 可以看作通过 action 和 reducer 手动管理状态的解决方案。Mobx 与之相反，是自动化的状态管理方案因为观察者模式在背后做了所有你需要做的。

MobX 对你的数据结构，存储的数据类型，或者是不是可以序列化成 JSON 做了一些预设。这些因素使初学者非常容易使用 MobX。

不像 Redux, MobX 不是事务型和确定型的，这意味着 Mobx 不会自动获得 Redux 在调试和日志记录方面的所有优点。。你不能对整个 MobX 的状态做快照，意味着一些调试工具像 [LogRocket](https://logrocket.com/) 需要手动监测你的每个可观察对象。

像美国银行、IBM 和 Lyft 这些知名公司已经在使用 Mobx 了。同时也有[社区中逐步发展的](https://github.com/mobxjs/awesome-mobx) 的插件，工具和教程。它增长迅速：从年初 50k 的 NPM 下载量到十月份 250k 的下载量。

因为上述的限制，MobX 的团队将一直努力将 Redux 和 Mobx 在一个叫 [mobx-state-tree](https://github.com/mobxjs/mobx-state-tree) (或者 MST) 的项目中把它们结合起来。它本质上是一个状态容器，在后台使用 MobX 来提供一种方式来处理不可变数据，就像使用可变数据一样简单。根本上来说，你的状态还是可变的，但是你通过 _snapshot_ 同不可变的状态复本一起工作。

已经由很多的开发者工具可以帮助你调试检查你的状态树——[Wiretap](https://wiretap.debuggable.io/) 和 [mobx-devtools](https://github.com/andykog/mobx-devtools) 是很好的选择。因为他们大致采取相同的方式工作，你甚至可以对 mobx-state-tree 使用 Redux 开发工具。

**总结：** Redux 仍是王者，但是请看一下 MobX 和 mobx-state-tree

### GraphQL

GraphQL 是一个可以实时查询接口语言，因为数据源的原因提供更清晰简洁的语法。不像 REST, GraphQL 提供类型语法，允许 JavaScript 客户端只查询他们需要的数据，它可能是近些年来接口开发中最大的革新。

虽然 GraphQL 语言标准从 [2016 年十月](http://facebook.github.io/graphql/October2016/) 就没有改变，但人们对它的兴趣与日俱增。在过去的几年里，Google 趋势发现对于 GraphQL 的搜索量 [4 倍的增长]，对 JavaScript [GraphQL 客户端](https://github.com/graphql/graphql-js) NPM 下载量有 [13 倍的增长]。

当前有很多客户端和服务端实现可以选择，[Apollo](https://www.apollographql.com/) 是流行的选择之一，它添加全面的缓存控制和与 React 和 Vue 流行库的整合。[MEAN](https://github.com/linnovate/mean) 是也是一个使用 GraphQL 作为 API 层流行的全栈开发框架。

在过去的几年 [GraphQL 背后的社区](https://github.com/chentsulin/awesome-graphql) 也是极速发展。它创造了 20 多种语言的服务端实现方式，以及数以千计的教程和启动项目。有一个很好的 [awesome list](https://github.com/chentsulin/awesome-graphql)。

[React-starter-kit](https://github.com/kriasoft/react-starter-kit)——最流行的使用 GraphQL 的 React 生态环境中的项目。

**总结：** GraphQL 正在获得增长动力

### 其他值得关注的

#### NapaJS·

微软新的基于 V8 之上的多线程 JavaScript 运行时库。[NapaJS](https://github.com/Microsoft/napajs) 提供了一种在 Node 环境运行多线程的方式，在现有 Node 架构下更好的支持 CPU 密集型任务的执行。它提供了一种 Node  多任务模型的备选方案，用一个模块来实现。现在可以在 NPM 上像其他库那样下载了。

Napa使用 [node-webworker-threads](https://github.com/audreyt/node-webworker-threads) 库来利用 Node 中的线程与底层语言结合，通过使用添加从工作线程内部使用 Node 模块系统的能力来无缝的融合 Node 生态链。它还提供了不同 workers 间通信的全面的接口，与新发布的共享内存标准非常类似。

这个项目是微软为 Node 生态系统应用高性能架构所做的努力。它目前正在被 Bing 搜索引擎作为后端栈的一部分所使用。

有了微软这样的大公司的支持，你可以对 Node 的长期稳定放心了。看 Node 社区跟随多线程可以走多远将会非常有趣。

#### Prettier

近些年来构建工具的重要性日益增长。随着 [Prettier](https://github.com/prettier/prettier) 的首次亮相，代码格式成为前端构建过程中常见的一环。它自称是一个严格代码的格式化工具，旨在通过解析和重写来增强始终如一的代码风格。

当像 lint 工具比如 [ESLint](https://eslint.org/) 长时间成为 [自动化检测规则](https://eslint.org/docs/user-guide/command-line-interface#--fix)，Prettier 是最富特色的解决方案。不像 ESLint, Prettier 还支持 supports JSON, CSS, SASS, 甚至 GraphQL 和 Markdown。它还提供了与 [ESLint](https://prettier.io/docs/en/eslint.html) 及 [常见的编辑器](https://prettier.io/docs/en/eslint.html) 深度结合的能力。如果我们对分号意见一致，我们会很棒。

* * *

### 插件: LogRocket, web 应用的调试工具

![](https://cdn-images-1.medium.com/max/1000/1*s_rMyo6NbrAsP-XtvBaXFg.png)

[LogRocket](https://logrocket.com) 是一个前端的记录工具，允许你回放发生在自己浏览器上的问题。而不是猜测错误发生的原因，或者问用户要截图和日志文件, LogRocket 让你重现任务可以迅速的了解哪里出了问题。它和所有的应用都结合的很好，无论什么框架，同时有记录额外的 Redux, Vuex, 和 @ngrx/store 上下文工具。

在记录 Redux 事件和状态之外，LogRocket 记录控制面板，JavaScript 错误，堆栈，网络请求/答复的头和主体，浏览器元信息和自定义日志。它还操作 DOM 来记录页面中的 HTML 和 CSS，即使对最复杂的单页应用也可以再现非常精确的录制画面。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
