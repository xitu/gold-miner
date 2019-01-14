> * 原文地址：[A comprehensive look back at front-end in 2018](https://blog.logrocket.com/a-comprehensive-look-back-at-frontend-in-2018-8122e724a802)
> * 原文作者：[Kaelan Cooter](https://blog.logrocket.com/@eranimo)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/a-comprehensive-look-back-at-frontend-in-2018.md](https://github.com/xitu/gold-miner/blob/master/TODO1/a-comprehensive-look-back-at-frontend-in-2018.md)
> * 译者：[Ivocin](https://github.com/Ivocin)
> * 校对者：[Junkai Liu](https://github.com/Moonliujk), [wuzhe](https://github.com/wznonstop)

# 2018 前端全面回顾

拿一杯咖啡，坐下来，慢慢品读。我们的回顾不会错过太多。

![](https://cdn-images-1.medium.com/max/800/1*h4mMvgiilV-JPS1Ytpndyg.png)

Web 开发一直是一个快速发展的领域 —— 我们很难跟上在过去的一年中所有的浏览器变更、函数库的发布以及冲击思维的程序设计趋势。

前端行业每年都在增长，这使得普通开发者很难跟上。因此让我们退后一步，回顾一下 2018 年 Web 开发社区发生了哪些变化。

我们目睹了过去几年 JavaScript 爆炸式的发展。随着互联网对全球经济变得更加重要，谷歌和微软等巨头意识到他们需要更好的工具来创建下一代 Web 应用程序。

这导致了 JavaScript 自创造以来最大的变革浪潮，起自 ECMAScript 2015（又名 ES6）。 现在 JavaScript 每年发布的版本都为我们带来了令人兴奋的新特性：如类、生成器、迭代器、promise、全新的模块系统等等。

这开启了 Web 发展的黄金时代。许多最流行的工具、函数库和框架在 ES2015 发布后立即流行了起来。 在主流浏览器厂商对新标准的支持实现了一半之前，[Babel](https://babeljs.io/) 编译器项目就让成千上万的开发人员抢先一步尝试新功能。

前端开发者首次不需要被他们公司需要支持的最古老的浏览器限制，可以按照自己的节奏自由创新。三年和三个 ECMAScript 版本之后，这个 Web 发展的新时代并没有放缓的迹象。

### JS 语言的新特性

与之前的版本相比，ECMAScript 2018 的功能相当简单，只添加了[对象 rest/spread 属性](https://github.com/tc39/proposal-object-rest-spread)，[异步迭代](https://github.com/tc39/proposal-async-iteration)和 [Promise.finally](https://github.com/tc39/proposal-promise-finally)，Babel 和 [core-js](https://github.com/zloirock/core-js#stage-3-proposals) 现在已经支持了所有这些新特性。[大多数浏览器](http://kangax.github.io/compat-table/es2016plus/#test-Asynchronous_Iterators)和 [Node.js](https://node.green/) 全部都支持了ES2018，除了 Edge，它只支持 Promise.finally。对于许多开发人员来说，这意味着他们所需的所有语言特性都被他们需要兼容的浏览器支持了 —— 甚至有人怀疑 Babel 是否真的是必须的了。

### 新的正则表达式特性

JavaScript 一直缺乏像 Python 这样语言的一些更高级的正则表达式功能 —— 直到现在才推出类似的特性。 ES2018 增加了四个新特性：

* [后行断言（lookbehind assertions）](https://github.com/tc39/proposal-regexp-lookbehind)，为自 1999 年以来一直使用该语言的先行断言（ lookahead assertions） 提供了缺失的补充。
* [s（dotAll）标志](https://github.com/tc39/proposal-regexp-dotall-flag)，它匹配除行终止符之外的任何单个字符。
* [命名捕获组](https://github.com/tc39/proposal-regexp-named-groups)，通过基于属性的捕获组查找，可以更轻松地使用正则表达式。
* [Unicode 属性转义](https://github.com/tc39/proposal-regexp-unicode-property-escapes)，可以编写能够识别 Unicode 编码的正则表达式了。

虽然这些新特性中的许多功能多年来都有解决方法和替代库，但它们都没有原生实现的速度快。

### 新的浏览器特性

今年发布了相当多的新的 JavaScript 浏览器 API。几乎所有内容都有所改进 —— 网络安全、高性能计算和动画等等。让我们按领域划分它们以更好地了解它们带来的影响。

### WebAssembly

尽管去年 WebAssembly v1 支持被添加到了主流浏览器中，但它尚未被开发者社区广泛采用。WebAssembly Group 针对[垃圾回收](https://github.com/WebAssembly/gc)、ECMAScript 模块集成和[线程](https://developers.google.com/web/updates/2018/10/wasm-threads)等功能提供了[宏大的功能路线图](https://webassembly.org/docs/future-features/)。也许有了这些功能，我们才会看到 WebAssembly 在 Web 应用程序中被广泛采用。

有一部分问题是 WebAssembly 需要大量的步骤才能开始使用，而许多习惯于使用 JavaScript 的开发人员并不熟悉使用传统的编译语言。Firefox 推出了一个名为 [WebAssembly Studio](https://hacks.mozilla.org/2018/04/sneak-peek-at-webassembly-studio/) 的在线 IDE，可以让使用 WebAssembly 变得简单。如果你希望将其集成到现有的应用程序中，现在有很多工具可供选择。Webpack v4 为 WebAssembly 模块添加了实验性[内置支持](https://github.com/webpack/webpack/releases/tag/v4.0.0)，这些模块紧密集成到构建和模块系统中，并提供 source map 支持。

Rust 已成为编译 WebAssembly 的最佳语言。它提供了一个健壮的包生态系统，具有 [cargo](https://github.com/rust-lang/cargo)，可靠的性能和[易于学习](https://doc.rust-lang.org/book/)的语法。现在已经有一个新兴的工具生态系统将 Rust 与 Javascript 集成在一起。 你可以使用 [wasm-pack](https://github.com/rustwasm/wasm-pack) 将 Rust WebAssembly 包发布到 npm 上。如果你使用了 webpack，现在可以使用 [rust-native-wasm-loader](https://github.com/dflemstr/rust-native-wasm-loader) 在应用程序中无缝集成 Rust 代码。

如果你不想放弃 JavaScript 来使用 WebAssembly，你很幸运 —— 现在有几种选择。如果你熟悉 Typescript，可以使用 [AssemblyScript](https://github.com/AssemblyScript/assemblyscript) 项目，该项目使用官方 [Binaryen](https://github.com/WebAssembly/binaryen) 编译器和 Typescript。

因此，它适用于现有的 Typescript 和 WebAssembly 工具。[Walt](https://github.com/ballercat/walt) 是另一个坚持 JavaScript 语法的编译器（使用类似于 Typescript 的类型提示），并直接编译为 WebAssembly 文本格式。它是零依赖的，具有非常快的编译速度，并可以与 webpack 集成。这两个项目都在积极开发中，根据你的标准，它们可能会不适用于生产环境。无论如何，它们都值得一试。

### 共享内存

现代 JavaScript 应用程序经常把大量的计算放在 [Web Workers](https://developer.mozilla.org/en-US/docs/Web/API/Worker) 中，以避免其阻塞主线程并中断浏览体验。虽然 Worker 已经推出几年了，但它的局限性使他们无法更广泛地采用。Worker 可以使用 [postMessage](https://developer.mozilla.org/en-US/docs/Web/API/Worker/postMessage) 方法在其他线程之间传输数据，该方法克隆发送的数据（较慢）或使用[可传输的对象](https://developer.mozilla.org/en-US/docs/Web/API/Transferable)（更快）。 因此，线程之间的通信要么是慢速的，要么是单向的。对于简单的应用程序没有太大问题，但它限制了使用 Worker 构建更复杂的架构。

[SharedArrayBuffer](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/SharedArrayBuffer) 和 [Atomics](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Atomics) 是允许 JavaScript 应用程序在上下文之间共享固定内存缓冲区并对它们执行原子操作的新功能。但是，在发现共享内存使浏览器容易受到以前未知的被称为 [Spectre](https://meltdownattack.com/) 的定时攻击后，浏览器对该特性的支持被暂时删除了。Chrome 在 7 月发布了一项[新的安全功能](https://www.techrepublic.com/article/google-enabled-site-isolation-in-chrome-67-heres-why-and-how-it-affects-users/)，可以缓解该漏洞，从而重新启用了 SharedArrayBuffers 功能。在 Firefox 中，该功能默认情况下是禁用的，但可以[重新启用](https://blog.mozilla.org/security/2018/01/03/mitigations-landing-new-class-timing-attack/)。Edge [完全取消了对SharedArrayBuffers 的支持](https://blogs.windows.com/msedgedev/2018/01/03/speculative-execution-mitigations-microsoft-edge-internet-explorer/#Yr2pGlOHTmaRJrLl.97)，微软尚未表示何时会重新启用。希望到明年所有浏览器都会采用缓解策略，以便可以使用这个关键的缺失功能。

### Canvas

Canvas 和 WebGL 等图形 API 已经推出几年了，但它们一直被限于在主线程中进行渲染。 因此，渲染可能会阻塞主线程。这会导致糟糕的用户体验。[OffscreenCanvas](https://developer.mozilla.org/en-US/docs/Web/API/OffscreenCanvas#Asynchronous_display_of_frames_produced_by_an_OffscreenCanvas) API 允许你将 canvas 上下文（2D或 WebGL）的控制权转移给 Web Worker，从而解决了这个问题。在 Worker 使用 Canvas API 和平时没有区别，而且不会阻塞主线程，并可以无缝渲染。 

鉴于显著的性能提升，可以期待可以期待图表和绘图库会很快支持它。目前[浏览器支持](https://caniuse.com/#feat=offscreencanvas)仅限于 Chrome 和 Firefox，而 Edge 团队尚未公开表示支持。你可以期望它能和 SharedArrayBuffers 以及 WebAssembly 很好地配对，允许 Worker 基于任何线程中存在的数据，使用任何语言编写的代码进行渲染，所有这些都不会造成糟糕的用户体验。这可能使网络上实现高端游戏的梦想成为现实，而且可以在 Web 应用程序中使用更复杂的图形。

新的绘图和布局 API 正努力被引入 CSS。目标是向 Web 开发人员公开 CSS 引擎的部分内容，以揭开 CSS 的一些“神奇”神秘面纱。 W3C 的 [CSS Houdini 工作组](https://github.com/w3c/css-houdini-drafts/wiki)由主要浏览器供应商的工程师组成，在过去两年中一直在努力发布[几个规范草案](https://drafts.css-houdini.org/)，这些规范目前正处于设计的最后阶段。

[CSS Paint API](https://developers.google.com/web/updates/2018/01/paintapi) 是其中最早登陆浏览器的新 CSS API ，它在 1 月份登陆 Chrome 65。它允许开发人员使用类似 context 的 API 绘制图像，可以在 CSS 中调用图像的任何地方使用它。它使用新的 [Worklet](https://drafts.css-houdini.org/worklets) 接口，这些接口基本上是轻量级，高性能的类似 [Worker](https://developer.mozilla.org/en-US/docs/Web/API/Worker) 的构造，用于专门的任务处理。 和 Worker 一样，它们在自己的执行上下文中运行，但与 Worker 不同的是，它们是线程不可感知的（浏览器选择它们运行的线程），并且它们可以访问渲染引擎。

使用 Paint Worklet，你可以创建一个背景图像，当其中包含的元素发生更改时，该图像会自动重绘。使用 CSS 属性，你可以添加在更改时触发重新绘制的参数，并可通过 JavaScript 进行控制。[所有浏览器](https://ishoudinireadyyet.com/)都承诺支持该 API，除了 Edge，但是现在有一个 [polyfill](https://github.com/GoogleChromeLabs/css-paint-polyfill) 可以使用。有了这个 API，我们将开始看到组件化图像的使用方式，这与我们现在看到的组件类似。

### 动画

大多数现代 Web 应用程序使用动画作为用户体验的重要部分。像 Google 的 Material Design 这样的框架把动画作为其[设计语言](https://material.io/design/motion/understanding-motion.html#principles)的重要组成部分，并认为它们对于创造富有表现力和易于理解的用户体验至关重要。鉴于它们的重要性的提高，最近推出了一个更强大的 JavaScript 动画 API，这个就是 Web Animations API（WAAPI）。

正如 [CSS-Tricks 所说](https://css-tricks.com/css-animations-vs-web-animations-api/)，WAAPI 提供了比 CSS 动画更好的开发人员体验，你可以轻松地记录和操作 JS 或 CSS 中定义的动画状态。目前[浏览器支持](https://caniuse.com/#feat=web-animation)主要限于 Chrome 和 Firefox，但有一个[官方的 polyfill](https://github.com/web-animations/web-animations-js/tree/master) 可以满足你的需求。

性能一直是 Web 动画的一个问题，[Animation Worklet](https://wicg.github.io/animation-worklet/) 解决了这个问题。这个新的 API 允许复杂的动画并行运行 —— 这意味着更高的帧速率动画不受主线程卡顿的影响。Animation Worklet 遵循与 Web Animations API 相同的接口，但在 Worklet 执行上下文中。

它将在 Chrome 71（截至撰写本文时的下一个版本）[发布](https://www.chromestatus.com/features/5762982487261184)，而其他浏览器可能会在明年某个时候发布。如果想今天就试试，可以在 GitHub 上找到官方的 [polyfill 和示例仓库](https://github.com/GoogleChromeLabs/houdini-samples/tree/master/animation-worklet)。

### 安全

Spectre 定时攻击并不是今年唯一的网络安全恐慌。npm 固有的脆弱性在[过去已经写了很多](https://hackernoon.com/im-harvesting-credit-card-numbers-and-passwords-from-your-site-here-s-how-9a8cb347c5b5)，上个月我们得到了一个[告警提醒](https://blog.logrocket.com/the-latest-npm-breach-or-is-it-a427617a4185)。这不是 npm 本身的安全漏洞，而是一个名为 [event-stream](https://www.npmjs.com/package/event-stream) 的包，被许多流行软件包使用。npm 允许包作者将所有权转让给任何其他成员，黑客说服所有者将其转让给他们。然后，黑客发布了一个新版本，它依赖于他们创建的名为 [flatmap-stream](https://www.npmjs.com/package/flatmap-stream) 的软件包，其代码可以窃取[比特币钱包](https://copay.io/)，如果该恶意软件和 [copay-dash](https://www.npmjs.com/package/copay-dash) 一起安装，就会窃取用户的比特币钱包。

考虑到 npm 的运行方式，社区成员倾向于安装看似有用的随机 npm 包，这种攻击只会变得更加普遍。社区对包所有者非常信任，现在信任受到了极大的质疑。npm 用户应该知道他们正在安装的每个软件包（包括依赖项的依赖关系），使用锁定文件来锁定版本并注册 [Github 提供的](https://blog.github.com/2017-11-16-introducing-security-alerts-on-github/)安全警报。

Npm [意识到社区的安全问题](https://blog.npmjs.org/post/172774747080/attitudes-to-security-in-the-javascript-community)，他们在过去的一年里已经采取措施去改进它。你现在可以使用[双因素身份验证](https://blog.npmjs.org/post/166039777883/protect-your-npm-account-with-two-factor)来保护你的 npm 帐户，并且 npm v6 现在包含了[安全审核](https://docs.npmjs.com/auditing-package-dependencies-for-security-vulnerabilities)命令。 

### 监控

[Reporting API](https://developers.google.com/web/updates/2018/09/reportingapi) 是一种新标准，旨在通过在发生问题时发出警报，使开发人员更容易发现应用程序的问题。如果你在过去几年中使用过 Chrome DevTools 控制台，你可能已经看到了 **\[intervention\]** 警告消息，用来提示使用过时的 API 或执行可能不安全的操作。这些消息仅限于客户端，但现在你可以使用新的 [ReportingObserver](https://developers.google.com/web/updates/2018/07/reportingobserver) 将其报告给分析工具。

有两种报告：

* [废弃](https://developers.google.com/web/updates/tags/deprecations)，当你使用过时的 API 时会发出警告，并通知你何时删除它。它还会告诉你使用它的文件名和行号。
* [干预](https://www.chromestatus.com/features#intervention)，当你以无意识的、危险或不安全的方式使用 API 时，它会发出警告。

而像 [LogRocket](https://logrocket.com/) 这样的工具可以让开发人员深入了解应用程序中的错误。到目前为止，第三方工具还没有任何可靠的方法来记录这些警告。这意味着问题要么被忽视，要么表现为难以调试的错误消息。Chrome 目前支持了 ReportingObserver API，其他浏览器很快就会支持它。

### CSS

虽然 JavaScript 得到了所有人的关注，但几个有趣的 CSS 新功能在今年登陆了浏览器。

对于那些不知道的人，没有统一的类似于 ECMAScript 的 CSS3 规范。最后一个官方统一标准是 CSS2.1，而 CSS3 适用于在其之后发布的内容。与 CSS2 不同的是，CSS3 的每个部分都单独标准化为 “CSS 模块”。 MDN 对每个模块标准及其状态有一个[很好的概述](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS3)。

截至 2018 年，现在所有主流浏览器都完全支持一些较新的功能（这是 2018 年，IE 不是主流浏览器）。这包括 [flexbox](https://blog.logrocket.com/flexing-with-css-flexbox-b7940b329a8a)、[自定义属性](https://caniuse.com/#feat=css-variables)（变量）和[网格布局](https://blog.logrocket.com/the-simpletons-guide-to-css-grid-1767565b3cf7)。

虽然[过去一直在讨论](https://tabatkins.github.io/specs/css-nesting/)如何向 CSS 添加对嵌套规则的支持（如 LESS 和 SASS ），但这些提案被搁置了。在 7 月，W3C 的 CSS 工作组[决定](https://github.com/w3c/csswg-drafts/issues/2701#issuecomment-402392212)再次审视该提案，但目前还不清楚它是否是一个优先事项。

### Node.js

Node 继续在遵循 ECMAScript 标准方面取得良好进展，截至 12 月，它们[支持了所有 ES2018 标准](https://node.green/)。但另一方面，他们采用 ECMAScript 模块系统的速度很慢，因此缺少一项与浏览器比肩的关键功能，浏览器已经支持 ES 模块一年多了。Node 实际上在 v11.4.0 版本标志后面添加了一项[实验支持](https://nodejs.org/api/esm.html)，但是这需要文件使用新的 .mjs 后缀，这使得它们开始[担忧](https://github.com/nodejs/modules/issues/57)：用户的接受速度可能会十分缓慢，以及其对 Node 的丰富包生态系统的影响。

如果你希望获得一个快速启动，并且不想使用实验性内置支持，可以尝试使用被 Lodash 的创建者称为 [esm](https://medium.com/web-on-the-edge/tomorrows-es-modules-today-c53d29ac448c) 的一个有趣的项目，它为 Node ES 模块支持提供了比官方解决方案更好的互操作性和性能。

### 框架和工具

#### React

[React](https://reactjs.org/) 今年发布了两个值得注意的版本。React 16.3 附带了一组新的[生命周期方法](https://reactjs.org/blog/2018/03/29/react-v-16-3.html#component-lifecycle-changes)和一个新的官方 [Context API](https://reactjs.org/blog/2018/03/29/react-v-16-3.html#official-context-api)。React 16.6 添加了一个名为 “Suspense” 的新功能，它使 React 能够在组件等待如数据获取或[代码分割](https://reactjs.org/docs/code-splitting.html#reactlazy)等任务完成时暂停渲染。

今年最受关注的 React 话题是引入了 [React Hooks](https://reactjs.org/docs/hooks-intro.html)。该提案为了让编写更小的组件更简单，并且不会牺牲迄今为止仅限于类组件的有用功能。React 将附带两个内置钩子，State Hook（允许函数式组件使用状态）和 [Effect Hook](https://reactjs.org/docs/hooks-effect.html#tip-use-multiple-effects-to-separate-concerns)（可以让你在函数式组件中执行副作用）。虽然没有计划从 React 中删除类，但 React 团队显然希望 Hooks 成为 React 未来的核心。提案宣布之后，社区有了积极的反应（[有些人可能会说过度夸大了](https://twitter.com/dan_abramov/status/1057027428827193344)）。如果你有兴趣了解更多信息，请查看 [Dan Abramov 的博文](https://medium.com/@dan_abramov/making-sense-of-react-hooks-fdbde8803889)里面的全面概述。

明年，React 计划发布一项名为 [Concurrent mode](https://reactjs.org/blog/2018/11/27/react-16-roadmap.html#react-16x-q2-2019-the-one-with-concurrent-mode)（以前称为 “async mode” 或 “async rendering”）的新功能。这将使 React 在不阻塞主线程的情况下渲染大型组件树。对于具有深度组件树的大型应用程序，性能的节省可能非常显着。目前还不清楚该 API 究竟是什么样子，但 React 团队的目标是很快完成它并在明年某个时候发布。如果你对采用此功能感兴趣，请通过采用 React 16.3 中发布的新生命周期方法确保你的代码能够兼容该功能。

React 流行度继续增长，[根据 JavaScript 2018 趋势报告](https://2018.stateofjs.com/front-end-frameworks/react/)显示，64％ 的受访者选择使用 React 并将再次使用它（比去年增加了 7.1％），相比之下 [Vue 为 28％](https://2018.stateofjs.com/front-end-frameworks/vuejs/)（增长了 9.2％），[Angular 为 23%](https://2018.stateofjs.com/front-end-frameworks/angular/)（增长了 5.1％）。

#### Webpack

[Webpack](https://webpack.js.org) 4 [于 2 月发布](https://github.com/webpack/webpack/releases/tag/v4.0.0-beta.0)，带来了巨大的性能改进，内置生产和开发模式，做了如代码分割和压缩的易于使用的优化，实验性的 WebAssembly 支持和 ECMAScript 模块支持。Webpack 现在比以前的版本更容易使用，以前如代码分割和代码优化等复杂的功能，现在设置起来非常简单。结合使用 Typescript 或 Babel，webpack 仍然是 Web 开发人员的基础工具，竞争对手似乎不太可能在不久的将来出现并取而代之。

#### Babel

[Babel](https://babeljs.io) 7 [于今年 8 月发布](https://babeljs.io/blog/2018/08/27/7.0.0)，这是近三年来的第一次重大发布。主要更改包括[更快的构建时间](https://twitter.com/left_pad/status/927554660508028929)，新的包命名空间以及各种“阶段”和按照年度命名的 ECMASCript 预设包的弃用，以支持 [preset-env](https://babeljs.io/docs/en/next/babel-preset-env.html)，它通过自动包含你支持的浏览器所需的插件，极大地简化了配置 Babel 的过程。此版本还添加了[自动 polyfilling](https://babeljs.io/blog/2018/08/27/7.0.0#automatic-polyfilling-experimental)，无需导入整个 Babel polyfill（体积相当大）或显式导入所需的 polyfill（这可能非常耗时且容易出错）。

Babel 现在也[支持 Typescript 语法](https://blogs.msdn.microsoft.com/typescript/2018/08/27/typescript-and-babel-7/)，使开发人员更容易将 Babel 和 Typescript 一起使用。Babel 7.1 还增加了对新的[装饰器提案](https://babeljs.io/blog/2018/09/17/decorators)的支持，该提议与社区广泛采用的过时提案不兼容，但与浏览器支持的内容相匹配。值得庆幸的是，Babel 团队发布了一个[兼容性软件包](https://babeljs.io/blog/2018/09/17/decorators#upgrading)，可以使升级更容易。

#### Electron

[Electron](https://electronjs.org/) 仍然是最常用的桌面 JavaScript 应用程序打包方式，尽管这是否是一件好事还是有争议的。现在一些最流行的桌面应用程序使用了 Electron，可以使跨平台开发应用程序更加简单，从而降低开发成本。

一个[常见的抱怨](https://www.theverge.com/circuitbreaker/2018/5/16/17361696/chrome-os-electron-desktop-applications-apple-microsoft-google)是，使用 Electron 的应用程序会使用太多内存，因为每个应用程序都打包整个 Chrome 实例（这会非常占用内存）。[Carlo](https://github.com/GoogleChromeLabs/carlo) 是来自 Google 的 Electron 替代品，它使用本地安装的 Chrome 版本（需要在本地安装），从而减少了内存消耗大的问题。Electron 本身在提高性能方面没有取得多大进展，[近期的更新](https://electronjs.org/blog/electron-3-0)主要集中在更新 Chrome 依赖项和小的 API 改动上面。

#### Typescript

在去年，[Typescript](https://www.typescriptlang.org/) 的受欢迎程度大大提高，成为了JavaScript 统治地位的 ES6 的主要挑战者。自微软每月发布新版本以来，开发在过去一年中取得了相当快的进展。Typescript 团队非常关注开发人员的体验，包括语言本身和围绕它的编辑器工具。

最近的版本增加了更多开发人员友好的[错误格式](https://blogs.msdn.microsoft.com/typescript/2018/07/30/announcing-typescript-3-0/#improved-errors-and-ux)和强大的重构功能，如[自动导入更新](https://blogs.msdn.microsoft.com/typescript/2018/05/31/announcing-typescript-2-9/#rename-move-file)和[导入组织](https://blogs.msdn.microsoft.com/typescript/2018/03/27/announcing-typescript-2-8/#organize-imports)等。与此同时，TypeScript 继续在提升类型系统上发力，如近期的[条件类型](https://blogs.msdn.microsoft.com/typescript/2018/03/27/announcing-typescript-2-8/#conditional-types)和[未知类型](https://blogs.msdn.microsoft.com/typescript/2018/07/30/announcing-typescript-3-0/#the-unknown-type)两个新功能。

JavaScript 2018 趋势报告指出，[近一半的受访者](https://2018.stateofjs.com/javascript-flavors/typescript/)使用 TypeScript，和过去两年相比具有强劲的上升趋势。相比之下，它的主要竞争对手 Flow 已经[停滞不前](https://2018.stateofjs.com/javascript-flavors/flow/)，大多数开发者表示他们不喜欢 Flow 缺乏工具，并且流行势头降低。Typescript 受到赞赏，因为开发人员可以通过使用强大的编辑器轻松编写健壮且优雅的代码。开发者注意到了，TypeScript 的发起者微软似乎更愿意支持它，而 Facebook 对 Flow 的支持就差了一截。

* * *

### 题外话：[LogRocket](https://logrocket.com/signup/)，一个用于 web 应用程序的DVR

[![](https://cdn-images-1.medium.com/max/1000/1*s_rMyo6NbrAsP-XtvBaXFg.png)](https://logrocket.com/signup/)

[LogRocket](https://logrocket.com/signup/) 是一个前端日志记录工具，可让你像在自己的浏览器中一样重现问题。LogRocket 不是猜测错误发生的原因，也不是要求用户提供屏幕截图和日志转储，而是让你重播会话以快速了解出现了什么问题。它适用于任何应用程序，与框架无关，并且具有从 Redux，Vuex 和 @ngrx / store 记录上下文的日志插件。

除了记录 Redux 操作和状态之外，LogRocket 还会记录控制台日志、JavaScript 错误、堆栈跟踪、带有 header 和 body 的网络请求/响应、浏览器元数据和自定义日志。它还使用 DOM 来记录页面上的 HTML 和 CSS，能够重新创建即使是最复杂的单页应用程序的像素级完美视频。

[欢迎免费试用。](https://logrocket.com/signup/)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
