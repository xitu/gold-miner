> * 原文地址：[Front-End Performance Checklist 2019 — 4](https://www.smashingmagazine.com/2019/01/front-end-performance-checklist-2019-pdf-pages/)
> * 原文作者：[Vitaly Friedman](https://www.smashingmagazine.com/author/vitaly-friedman)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-4.md](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-4.md)
> * 译者：[Ivocin](https://github.com/Ivocin)
> * 校对者：[ziyin feng](https://github.com/Fengziyin1234)，[weibinzhu](https://github.com/weibinzhu)

# 2019 前端性能优化年度总结 — 第四部分

让 2019 来得更迅速吧！你现在阅读的是 2019 年前端性能优化年度总结，始于 2016 。

> [译] [2019 前端性能优化年度总结 — 第一部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-1.md)
> [译] [2019 前端性能优化年度总结 — 第二部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-2.md)
> [译] [2019 前端性能优化年度总结 — 第三部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-3.md)
> **[译] [2019 前端性能优化年度总结 — 第四部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-4.md)**
> [译] [2019 前端性能优化年度总结 — 第五部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-5.md)
> [译] [2019 前端性能优化年度总结 — 第六部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-6.md)

#### 目录

- [构建优化](#构建优化)
   - [22.确定优先级](#22-确定优先级)
   - [23.重温优秀的“符合最低要求”技术](#23-重温优秀的符合最低要求技术)
   - [24.解析 JavaScript 是耗时的，所以让它体积小](#24-解析-javascript-是耗时的所以让它体积小)
   - [25.使用了摇树、作用域提升和代码分割吗](#25-使用了摇树作用域提升和代码分割吗)
   - [26.可以将 JavaScript 切换到 Web Worker 中吗？](#26-可以将-javascript-切换到-web-worker-中吗)
   - [27.可以将 JavaScript 切换到 WebAssembly 中吗？](#27-可以将-javascript-切换到-webassembly-中吗)
   - [28.是否使用了 AOT 编译？](#28-是否使用了-aot-编译)
   - [29.仅将遗留代码提供给旧版浏览器](#29-仅将遗留代码提供给旧版浏览器)
   - [30.是否使用了 JavaScript 差异化服务？](#30-是否使用了-javascript-差异化服务)
   - [31.通过增量解耦识别和重写遗留代码](#31-通过增量解耦识别和重写遗留代码)
   - [32.识别并删除未使用的 CSS/JS](#32-识别并删除未使用的-cssjs)
   - [33.减小 JavaScript 包的大小](#33-减小-javascript-包的大小)
   - [34.是否使用了 JavaScript 代码块的预测预获取？](#34-是否使用了-javascript-代码块的预测预获取)
   - [35.从针对你的目标 JavaScript 引擎进行优化中获得好处](#35-从针对你的目标-JavaScript-引擎进行优化中获得好处)
   - [36.使用客户端渲染还是服务器端渲染？](#36-使用客户端渲染还是服务器端渲染)
   - [37.约束第三方脚本的影响](#37-约束第三方脚本的影响)
   - [38.设置 HTTP 缓存标头](#38-设置-http-缓存标头)

### 构建优化

#### 22. 确定优先级
 
要了解你首先要处理什么。列出你全部的静态资源清单（JavaScript、图片、字体、第三方脚本以及页面上的大模块：如轮播图、复杂的信息图表和多媒体内容），并将它们分组。

新建一个电子表格。定义旧版浏览器的基本**核心**体验（即完全可访问的核心内容）、现代浏览器的**增强**体验（即更加丰富的完整体验）以及**额外功能**（可以延迟加载的非必需的资源：例如网页字体、不必要的样式、轮播脚本、视频播放器、社交媒体按钮和大图片）。不久前，我们发表了一篇关于 “[提升 Smashing 杂志网站性能](https://www.smashingmagazine.com/2014/09/improving-smashing-magazine-performance-case-study/)” 的文章，文中详细描述了这种方法。

在优化性能时，我们需要确定我们的优先事项。立即加载**核心体验**，然后加载**增强体验**，最后加载**额外功能**。

#### 23. 重温优秀的“符合最低要求”技术

如今，我们仍然可以使用[符合最低要求（cutting-the-mustard）技术](https://www.filamentgroup.com/lab/modernizing-delivery.html) 将核心体验发送到旧版浏览器，并为现代浏览器提供增强体验。（译者注：关于 cutting-the-mustard 出处可以参考[这篇文章](http://responsivenews.co.uk/post/18948466399/cutting-the-mustard)。）[该技术的一个更新版本](https://snugug.com/musings/modern-cutting-the-mustard/)将使用 ES2015 + 语法 `<script type="module">`。现代浏览器会将脚本解释为 JavaScript 模块并按预期运行它，而旧版浏览器无法识别该属性并忽略它，因为它是未知的 HTML 语法。

现在我们需要谨记的是，单独的功能检测不足以做出该发送哪些资源到该浏览器的明智决定。就其本身而言，**符合最低要求** 从浏览器版本中推断出设备的能力，今天已经不再有效了。

例如，发展中国家的廉价 Android 手机主要使用 Chrome 浏览器，尽管设备的内存和 CPU 功能有限，但其仍然达到了使用符合最低要求技术的标准。最终，使用[设备内存客户端提示报头](https://github.com/w3c/device-memory)，我们将能够更可靠地定位低端设备。在本文写作时，仅在 Blink 中支持该报头（通常用于[客户端提示](https://caniuse.com/#search=client%20hints)）。由于设备内存还有[一个已在 Chrome 中提供](https://developers.google.com/web/updates/2017/12/device-memory)的 JavaScript API，因此基于该 API 进行功能检测是一个选择，并且只有在不支持时才会再来使用符合最低要求技术（**感谢 Yoav！**）。
    
#### 24. 解析 JavaScript 是耗时的，所以让它体积小 

在处理单页面应用程序时，我们需要一些时间来初始化应用程序，然后才能渲染页面。你的设置需要你的自定义解决方案，但可以留意能够加快首次渲染的模块和技术。例如，[如何调试 React 性能](https://building.calibreapp.com/debugging-react-performance-with-react-16-and-chrome-devtools-c90698a522ad)、[消除常见的 React 性能问题](https://logrocket-blog.ghost.io/death-by-a-thousand-cuts-a-checklist-for-eliminating-common-react-performance-issues/)，以及[如何提高 Angular 的性能](https://www.youtube.com/watch?v=p9vT0W31ym8)。通常，大多数性能问题都来自启动应用程序的初始解析时间。

[JavaScript 有一个解析的成本](https://youtu.be/_srJ7eHS3IM?t=9m33s)，但很少仅是由于文件大小一个因素影响性能。解析和执行时间根据设备的硬件的不同有很大差异。在普通电话（Moto G4）上，1MB（未压缩）JavaScript 的解析时间约为 1.3-1.4s，移动设备上有 15-20％ 的时间用于解析。在游戏中编译，仅仅在准备 JavaScript 就平均耗时 4 秒，在移动设备上首次有效绘制（First Meaningful Paint ）之前大约需要 11 秒。原因：在低端移动设备上，[解析和执行时间很容易高出 2-5 倍](https://medium.com/reloading/javascript-start-up-performance-69200f43b201)。

为了保证高性能，作为开发人员，我们需要找到编写和部署更少量 JavaScript 的方法。这就是为什么要详细检查每一个 JavaScript 依赖关系的原因。

有许多工具可以帮助你做出有关依赖关系和可行替代方案影响的明智决策：

*   [webpack-bundle-analyzer](https://www.npmjs.com/package/webpack-bundle-analyzer)
*   [Source Map Explorer](https://github.com/danvk/source-map-explorer)
*   [Bundle Buddy](https://github.com/samccone/bundle-buddy)
*   [Bundlephobia](https://bundlephobia.com/)
*   [Webpack size-plugin](https://github.com/GoogleChromeLabs/size-plugin)
*   [Import Cost for Visual Code](https://marketplace.visualstudio.com/items?itemName=wix.vscode-import-cost)

有一种有趣方法可以用来避免解析成本，它使用了 Ember 在 2017 年推出的[二进制模板](https://emberjs.com/blog/2017/10/10/glimmer-progress-report.html#toc_binary-templates)。使用该模板，Ember 用 JSON 解析代替 JavaScript 解析，这可能更快。 （**感谢 Leonardo，Yoav!**）

[衡量 JavaScript 解析和编译时间](https://medium.com/reloading/javascript-start-up-performance-69200f43b201#7557)。我们可以使用综合测试工具和浏览器跟踪来跟踪解析时间，浏览器实现者正在谈论[将来把基于 RUM 的处理时间暴露出来](https://github.com/w3c/resource-timing/issues/133)。也可以考虑使用 Etsy 的 [DeviceTiming](https://github.com/danielmendel/DeviceTiming)，这是一个小工具，它允许你使用 JavaScript 在任何设备或浏览器上测量解析和执行时间。

底线：虽然脚本的大小很重要，但它并不是一切。随着脚本大小的增长，解析和编译时间[不一定会线性增加](https://medium.com/reloading/javascript-start-up-performance-69200f43b201)。
    
#### 25. 使用了摇树、作用域提升和代码分割吗

[摇树（tree-shaking）](https://developers.google.com/web/fundamentals/performance/optimizing-javascript/tree-shaking/)是一种在 [webpack](http://www.2ality.com/2015/12/webpack-tree-shaking.html)  中清理构建过程的方法， 它仅将实际生产环境使用的代码打包，并排除没有使用的导入模块。使用 webpack 和 rollup，还可以使用[作用域提升](https://medium.com/webpack/brief-introduction-to-scope-hoisting-in-webpack-8435084c171f)（scope hoisting），作用域提升使得 webpack 和 rollup 可以检测 `import` 链可以展开的位置，并将其转换为一个内联函数，并且不会影响代码。使用 webpack，我们也可以使用 [JSON Tree Shaking](https://react-etc.net/entry/json-tree-shaking-lands-in-webpack-4-0)。

此外，你可能需要考虑学习如何[编写高效的 CSS 选择器](http://csswizardry.com/2011/09/writing-efficient-css-selectors/)，以及如何[避免臃肿且耗时的样式](https://benfrain.com/css-performance-revisited-selectors-bloat-expensive-styles/)。如果你希望更进一步，你还可以使用 webpack 来缩短 class 名，并使用作用域隔离在编译时[动态重命名 CSS class 名](https://medium.freecodecamp.org/reducing-css-bundle-size-70-by-cutting-the-class-names-and-using-scope-isolation-625440de600b)。

[代码拆分（code-splitting）](https://webpack.js.org/guides/code-splitting/)是另一个 webpack 功能，它将你的代码库拆分为按需加载的“块”。并非所有的 JavaScript 都必须立即下载、解析和编译。在代码中定义分割点后，webpack 可以处理依赖项和输出文件。它能够保持较小体积的初始下载，并在应用程序请求时按需请求代码。Alexander Kondrov 有一个[使用 webpack 和 React 应用代码分割的精彩介绍](https://hackernoon.com/lessons-learned-code-splitting-with-webpack-and-react-f012a989113)。

考虑使用 [preload-webpack-plugin](https://github.com/GoogleChromeLabs/preload-webpack-plugin)，它接受代码拆分的路由，然后提示浏览器使用 `<link rel="preload">` 或 `<link rel="prefetch">` 预加载它们。[Webpack 内联指令](https://webpack.js.org/guides/code-splitting/#prefetching-preloading-modules)还可以控制 `preload`/`prefetch`。

在哪里定义分割点呢？通过跟踪代码查看使用了哪些 CSS / JavaScript 包，没有使用哪些包。Umar Hansa [解释了](https://vimeo.com/235431630#t=11m37s)如何使用 Devtools 的代码覆盖率工具来实现它。
    
如果你没有使用 webpack，请注意 [rollup](http://rollupjs.org/) 显示的结果明显优于 Browserify 导出。虽然我们参与其中，但你可能需要查看 [rollup-plugin-closure-compiler](https://github.com/ampproject/rollup-plugin-closure-compiler) 和 [rollupify](https://github.com/nolanlawson/rollupify)，它将 ECMAScript 2015 模块转换为一个大型 CommonJS 模块 —— 因为根据你的包和模块系统的选择，小模块可能会有[惊人高的成本](https://nolanlawson.com/2016/08/15/the-cost-of-small-modules/)。

#### 26. 可以将 JavaScript 切换到 Web Worker 中吗？

为了减少对首次可交互时间（Time-to-Interactive）的负面影响，考虑将高耗时的 JavaScript 放到 [Web Worker](https://developer.mozilla.org/en-US/docs/Web/API/Web_Workers_API/Using_web_workers) 或通过 Service Worker 来缓存。

随着代码库的不断增长，UI 性能瓶颈将会出现，进而会降低用户的体验。主要[原因是 DOM 操作与主线程上的 JavaScript 一起运行](https://medium.com/google-developer-experts/running-fetch-in-a-web-worker-700dc33ac854)。通过 [web worker](https://flaviocopes.com/web-workers/)，我们可以将这些高耗时的操作移动到后台进程的另一线程上。Web worker 的典型用例是[预获取数据和渐进式 Web 应用程序](https://blog.sessionstack.com/how-javascript-works-the-building-blocks-of-web-workers-5-cases-when-you-should-use-them-a547c0757f6a)，提前加载和存储一些数据，以便你在之后需要时使用它。而且你可以使用 [Comlink](https://github.com/GoogleChromeLabs/comlink) 简化主页面和 worker 之间的通信。仍然还有一些工作要做，但我们已经做了很多了。

[Workerize](https://github.com/developit/workerize) 让你能够将模块移动到 Web Worker 中，自动将导出的函数映射为异步代理。如果你正在使用 webpack，你可以使用 [workerize-loader](https://github.com/developit/workerize-loader)。或者，也可以试试 [worker-plugin](https://github.com/GoogleChromeLabs/worker-plugin)。

请注意，Web Worker 无权访问 DOM，因为 DOM 不是“线程安全的”，而且它们执行的代码需要包含在单独的文件中。

#### 27. 可以将 JavaScript 切换到 WebAssembly 中吗？

我们还可以将 JavaScript 转换为 [WebAssembly](https://webassembly.org/)，这是一种二进制指令格式，可以使用 C/C++/Rust 等高级语言进行编译。它的[浏览器支持非常出色](https://caniuse.com/#feat=wasm)，最近它变得可行了，因为 [JavaSript 和 WASM 之间的函数调用速度变得越来越快](https://hacks.mozilla.org/2018/10/calls-between-javascript-and-webassembly-are-finally-fast-%F0%9F%8E%89/)，至少在 Firefox 中是这样。

在实际场景中，[JavaScript 似乎在较小的数组大小上比 WebAssembly 表现更好](https://medium.com/samsung-internet-dev/performance-testing-web-assembly-vs-javascript-e07506fd5875)，而 WebAssembly 在更大的数组大小上比 JavaScript 表现更好。对于大多数 Web 应用程序，JavaScript 更适合，而 WebAssembly 最适合用于计算密集型 Web 应用程序，例如 Web 游戏。但是，如果切换到 WebAssembly 能否获得显着的性能改进，则可能值得研究。

如果你想了解有关 WebAssembly 的更多信息：

*   Lin Clark 为 WebAssembly 撰写了一个[全面的系列文章](https://hacks.mozilla.org/2017/02/a-cartoon-intro-to-webassembly/)，Milica Mihajlija [概述了](https://blog.logrocket.com/webassembly-how-and-why-559b7f96cd71)如何在浏览器中运行原生代码、为什么要这样做、以及它对 JavaScript 和 Web 开发的未来意味着什么。

*   Google Codelabs 提供了一份 [WebAssembly 简介](https://codelabs.developers.google.com/codelabs/web-assembly-intro/index.html)，这是一个 60 分钟的课程，你将学习如何使用原生代码 —— 使用 C 并将其编译为 WebAssembly，然后直接在 JavaScript 调用它。

*   Alex Danilo 在他的 Google I/O 2017 演讲中[解释了 WebAssembly 及其工作原理](https://www.youtube.com/watch?v=6v4E6oksar0)。此外，Benedek Gagyi [分享了一个关于 WebAssembly 的实际案例研究](https://www.youtube.com/watch?v=l2DHjRmgAF8)，特别是团队如何将其用作 iOS、Android 和网站的 C++ 代码库的输出格式。

[![WebAssembly 如何工作，以及它为什么有用的概述。](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/bbb2ea83-7674-47d8-9cad-89a2de009915/how-webassembly-works.png)](https://blog.logrocket.com/webassembly-how-and-why-559b7f96cd71) 

Milica Mihajlija 提供了 [WebAssembly 的工作原理及其有用的原因](https://blog.logrocket.com/webassembly-how-and-why-559b7f96cd71)的概述。 ([预览大图](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/bbb2ea83-7674-47d8-9cad-89a2de009915/how-webassembly-works.png))

#### 28. 是否使用了 AOT 编译？

使用 [AOT（ahead-of-time） 编译器](https://www.lucidchart.com/techblog/2016/09/26/improving-angular-2-load-times/)将一些[客户端渲染](https://www.smashingmagazine.com/2016/03/server-side-rendering-react-node-express/)放到[服务器](http://redux.js.org/docs/recipes/ServerRendering.html)，从而快速输出可用结果。最后，考虑使用 [Optimize.js](https://github.com/nolanlawson/optimize-js) 来加速初始化加载时间，它包装了需要立即调用的函数（尽管现在[这可能不是必需](https://twitter.com/tverwaes/status/809788255243739136)的了）。

![“默认快速：现代加载最佳实践”，作者 Addy Osmani](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/31237c37-d7db-4faa-9849-51657e122331/babel-preset-opt.png)

来自[默认快速：现代加载最佳实践](https://speakerdeck.com/addyosmani/fast-by-default-modern-loading-best-practices)，作者是独一无二的 Addy Osmani。幻灯片第 76 页。

#### 29. 仅将遗留代码提供给旧版浏览器

由于 ES2015 [在现代浏览器中得到了非常好的支持](http://kangax.github.io/compat-table/es6/)，我们可以[使用 `babel-preset-env`](http://2ality.com/2017/02/babel-preset-env.html) ，仅转义尚未被我们的目标浏览器支持的那些 ES2015 + 特性。然后[设置两个构建](https://gist.github.com/newyankeecodeshop/79f3e1348a09583faf62ed55b58d09d9)，一个在 ES6 中，一个在 ES5 中。如上所述，现在[所有主流浏览器都支持](https://caniuse.com/#feat=es6-module) JavaScript 模块，因此使用 [`script type =“module”`](https://developers.google.com/web/fundamentals/primers/modules) 让支持 ES 模块的浏览器加载支持 ES6 的文件，而旧浏览器可以使用 `script nomodule` 加载支持 ES5 的文件。我们可以使用 [Webpack ESNext Boilerplate](https://github.com/philipwalton/webpack-esnext-boilerplate) 自动完成整个过程。

请注意，现在我们可以编写基于模块的 JavaScript，它可以原生地在浏览器里运行，无需编译器或打包工具。[`<link rel="modulepreload">` header](https://developers.google.com/web/updates/2017/12/modulepreload) 提供了一种提前（和高优先级）加载模块脚本的方法。基本上，它能够很好地最大化使用带宽，通过告诉浏览器它需要获取什么，以便在这些长的往返期间不会卡顿。此外，Jake Archibald 发布了一篇详细的文章，其中包含了[需要牢记的 ES 模块相关内容](https://jakearchibald.com/2017/es-modules-in-browsers/)，值得一读。

对于 lodash，[使用 `babel-plugin-lodash`](https://github.com/lodash/babel-plugin-lodash)，通过它可以只加载你在源代码中使用的模块。你的其他依赖也可能依赖于其他版本的 lodash，因此[将通用 lodash `requires` 转换为特定需要的功能](https://www.contentful.com/blog/2017/10/27/put-your-webpack-bundle-on-a-diet-part-3/)，以避免代码重复。这可能会为你节省相当多的 JavaScript 负载。

Shubham Kanodia 撰写了一份[详细的关于智能打包的低维护指南](https://www.smashingmagazine.com/2018/10/smart-bundling-legacy-code-browsers/)：如何在生产环境中实现仅仅将遗留代码推送到老版本浏览器上，里面还有一些你可以直接拿来用的代码片段。

[![正如 Jake Archibald 的文章中所解释的那样，内联脚本会被推迟，直到正在阻塞的外部脚本和内联脚本得到执行。](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/d46ddc8b-4bd7-4627-b738-baf62807b26f/inline-scripts-deferred.png)](https://jakearchibald.com/2017/es-modules-in-browsers/) 

Jake Archibald 发布了一篇详细的文章，其中包含了 [需要牢记的 ES 模块相关内容](https://jakearchibald.com/2017/es-modules-in-browsers/)，例如：内联脚本会被推迟，直到正在阻塞的外部脚本和内联脚本得到执行。（[预览大图](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/d46ddc8b-4bd7-4627-b738-baf62807b26f/inline-scripts-deferred.png)）

#### 30. 是否使用了 JavaScript 差异化服务？

我们希望通过网络发送必要的 JavaScript，但这意味着需要更加集中精力并且细粒度地关注这些静态资源的传送。前一阵子 Philip Walton 介绍了[差异化服务](https://philipwalton.com/articles/deploying-es2015-code-in-production-today/)的想法。该想法是编译和提供两个独立的 JavaScript 包：“常规”构建，带有 Babel-transforms 和 polyfill 的构建，只提供给实际需要它们的旧浏览器，以及另一个没有转换和 polyfill 的包（具有相同功能）。

结果，通过减少浏览器需要处理的脚本数量来帮助减少主线程的阻塞。Jeremy Wagner 在 2019 年发布了一篇[关于差异服务以及如何在你的构建管道中进行设置的综合文章](https://calendar.perfplanet.com/2018/doing-differential-serving-in-2019/)，从设置 babel 到你需要在 webpack 中进行哪些调整，以及完成所有这些工作的好处。

#### 31. 通过增量解耦识别和重写遗留代码

老项目充斥着陈旧和过时的代码。重新查看你的依赖项，评估重构或重写最近导致问题的遗留代码所需的时间。当然，它始终是一项重大任务，但是一旦你了解了遗留代码的影响，就可以从[增量解耦]((https://githubengineering.com/removing-jquery-from-github-frontend/))开始。

首先，设置指标，跟踪遗留代码调用的比率是保持不变或是下降，而不是上升。公开阻止团队使用该库，并确保你的 CI 能够[警告](https://github.com/dgraham/eslint-plugin-jquery)开发人员，如果它在拉取请求（pull request）中使用。[Polyfill](https://githubengineering.com/removing-jquery-from-github-frontend/#polyfills) 可以帮助将遗留代码转换为使用标准浏览器功能的重写代码库。

#### 32. 识别并删除未使用的 CSS/JS

[Chrome 中的 CSS 和 JavaScript 代码覆盖率](https://developers.google.com/web/updates/2017/04/devtools-release-notes#coverage)可以让你了解哪些代码已执行/已应用，哪些代码尚未执行。你可以开始记录覆盖范围，在页面上执行操作，然后浏览代码覆盖率结果。一旦你检测到未使用的代码，[找到那些模块并使用 `import()` 延迟加载](https://twitter.com/TheLarkInn/status/1012429019063578624)（参见整个线程）。然后重复覆盖配置文件并验证它现在在初始加载时发送的代码是否变少了。

你可以使用 [Puppeteer](https://github.com/GoogleChrome/puppeteer) 以[编程方式收集代码覆盖率](https://twitter.com/matijagrcic/statuses/1060863620568043520)，Canary 也能够让你[导出代码覆盖率结果](https://twitter.com/tkadlec/status/1073330247758684163)。正如 Andy Davies 提到的那样，你可能希望[同时收集现代和旧版浏览器](https://twitter.com/AndyDavies/status/1073339071106297856)的代码覆盖率。[Puppeteer 还有许多其他用例](https://github.com/GoogleChromeLabs/puppeteer-examples)，例如，[自动视差](https://meowni.ca/posts/2017-puppeteer-tests/)或[监视每个构建的未使用的 CSS](http://blog.cowchimp.com/monitoring-unused-css-by-unleashing-the-devtools-protocol/)。

此外，[purgecss](https://github.com/FullHuman/purgecss)、[UnCSS](https://github.com/giakki/uncss) 和 [Helium](https://github.com/geuis/helium-css) 可以帮助你从 CSS 中删除未使用的样式。如果你不确定是否在某处使用了可疑的代码，可以遵循 [Harry Roberts 的建议](https://csswizardry.com/2018/01/finding-dead-css/)：为该 class 创建 1×1px 透明 GIF 并将其放入 `dead/` 目录，例如： `/assets/img/dead/comments.gif`。然后，将该特定图像设置为 CSS 中相应选择器的背景，然后静候几个月，查看该文件能否出现在你的日志中。如果日志里没出现该条目，则没有人使用该遗留组件：你可以继续将其全部删除。

对于爱冒险的人，你甚至可以通过使用 [DevTools 监控 DevTools](http://blog.cowchimp.com/monitoring-unused-css-by-unleashing-the-devtools-protocol/)，通过一组页面自动收集未使用的 CSS。

#### 33. 减小 JavaScript 包的大小

正如 Addy Osmani [指出的](https://medium.com/@addyosmani/the-cost-of-javascript-in-2018-7d8950fbb5d4)那样，当你只需要一小部分时，你很可能会发送完整的 JavaScript 库，以及提供给不需要它们的浏览器的过时 polyfill，或者只是重复代码。为避免额外开销，请考虑使用 [webpack-libs-optimization](https://github.com/GoogleChromeLabs/webpack-libs-optimizations)，在构建过程中删除未使用的方法和 polyfill。

将打包审计添加到常规工作流程中。有一些你在几年前添加的重型库的轻量级替代品，例如：Moment.js 可以用 [date-fns](https://github.com/date-fns/date-fns) 或 [Luxon](https://moment.github.io/luxon/) 代替。Benedikt Rötsch 的研究[表明](https://www.contentful.com/blog/2017/10/27/put-your-webpack-bundle-on-a-diet-part-3/)，从 Moment.js 到 date-fns 的转换可能会使 3G 和低端手机上的首次绘制时间减少大约 300ms。

这就是 [Bundlephobia](https://bundlephobia.com/) 这样的工具可以帮助你找到在程序包中添加 npm 包的成本。你甚至可以[将这些成本与 Lighthouse Custom Audit 相结合](https://github.com/AymenLoukil/Google-lighthouse-custom-audit)。这也适用于框架。通过删除或减小 [Vue MDC 适配器](https://speakerdeck.com/addyosmani/web-performance-made-easy?slide=22)（Vue 的 Material 组件），样式可以从 194KB 降至 10KB。

喜欢冒险吗？你可以看看[Prepack](https://gist.github.com/gaearon/d85dccba72b809f56a9553972e5c33c4)。它将 JavaScript 编译为等效的 JavaScript 代码，但与 Babel 或 Uglify 不同，它允许你编写正常的 JavaScript 代码，并输出运行速度更快的等效 JavaScript 代码。

除了传送整个框架包之外，你甚至可以修剪框架并将其编译为不需要额外代码的原始 JavaScript 包。[Svelte 做到了](https://svelte.technology/)，[Rawact Babel 插件](https://github.com/sokra/rawact)也是如此，它在构建时将 React.js 组件转换为原生 DOM 操作。 为什么？  好吧，正如维护者解释的那样：“React-dom 包含可以渲染的每个可能组件/ HTMLElement 的代码，包括用于增量渲染、调度、事件处理等的代码。但是有些应用程序不需要所有这些功能（在初始页面加载时）。对于此类应用程序，使用原生 DOM 操作构建交互式用户界面可能是有意义的。”

[![Webpack 比较](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/e30c7d5b-ef8b-46ba-b0fc-b1d5a31cefff/webpack-comparison.png)](https://cdn-images-1.medium.com/max/2000/1*fdX-6h2HnZ_Mo4fBHflh2w.png) 

在 [Benedikt Rötsch 的文章中](https://www.contentful.com/blog/2017/10/27/put-your-webpack-bundle-on-a-diet-part-3/)，他表示，从 Moment.js 到 date-fns 的转换会使 3G 和低端手机上的首次绘制时间减少大约 300ms。（[预览大图](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/e30c7d5b-ef8b-46ba-b0fc-b1d5a31cefff/webpack-comparison.png)）

#### 34. 是否使用了 JavaScript 代码块的预测预获取？

我们可以使用启发式方法来决定何时预加载 JavaScript 代码块。[Guess.js](https://github.com/guess-js/guess) 是一组工具和库，它使用 Google Analytics 的数据来确定用户最有可能从给定页面访问哪个页面。根据从 Google Analytics 或其他来源收集的用户导航模式，Guess.js 构建了一个机器学习模型，用于预测和预获取每个后续页面中所需的 JavaScript。

因此，每个交互元素都接收参与的概率评分，并且基于该评分，客户端脚本决定提前预获取资源。你可以将该技术集成到 [Next.js](https://github.com/mgechev/guess-next) 应用程序、[Angular 和 React](https://blog.mgechev.com/2018/03/18/machine-learning-data-driven-bundling-webpack-javascript-markov-chain-angular-react/) 中，还有一个 [webpack 插件](https://github.com/guess-js/guess/tree/master/packages/guess-webpack)能够自动完成设置过程。

显然，你可能会让浏览器预测到使用不需要的数据从而预获取到不需要的页面，因此最好在预获取请求的数量上保持绝对保守。一个好的用例是预获取结账中所需的验证脚本，或者当一个关键的 CTA（call-to-action）进入视口时的推测性预获取。

需要不太复杂的东西？[Quicklink](https://github.com/GoogleChromeLabs/quicklink) 是一个小型库，可在空闲时自动预获取视口中的链接，以便加快下一页导航的加载速度。但是，它也考虑了数据流量，因此它不会在 2G 网络或者 `Data-Saver` 打开时预获取数据。

#### 35. 从针对你的目标 JavaScript 引擎进行优化中获得好处

研究哪些 JavaScript 引擎在你的用户群中占主导地位，然后探索针对这些引擎的优化方法。例如，在为 Blink 内核浏览器、Node.js 运行时和 Electron 中使用的 V8 进行优化时，使用[脚本流](https://blog.chromium.org/2015/03/new-javascript-techniques-for-rapid.html)来处理庞大的脚本。它允许在下载开始时在单独的后台线程上解析 `async` 或 `defer scripts`，因此在某些情况下可以将页面加载时间减少多达 10％。实际上，在 `<head>` 里[使用 `<script defer>`](https://medium.com/reloading/javascript-start-up-performance-69200f43b201#3498)，以便浏览器可以提前[发现资源](https://medium.com/reloading/javascript-start-up-performance-69200f43b201#3498)，然后在后台线程上解析它。

**警告**：**Opera Mini [不支持脚本延迟]（https://caniuse.com/search#=defer），所以如果你正在为印度或非洲开发，** `defer` **将被忽略，这会导致阻止渲染，直到脚本执行完为止（感谢 Jeremy！）**。

[![渐进式启动](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/ab06acd3-833a-4634-abf9-fc8d91939250/fmp-and-tti-opt.jpeg)](https://aerotwist.com/blog/when-everything-is-important-nothing-is/)

[渐进式启动](https://aerotwist.com/blog/when-everything-is-important-nothing-is/)意味着使用服务器端渲染来获得快速的首次有效绘制，但也包括一些最小的 JavaScript，以保持首次交互时间接近首次有效绘制时间。

#### 36. 使用客户端渲染还是服务器端渲染？

在这两种情况下，我们的目标应该是设置[渐进式启动](https://aerotwist.com/blog/when-everything-is-important-nothing-is/)：使用服务器端渲染来获得快速的首次有效绘制，但也包括一些最小的必要 JavaScript，以保持首次交互时间接近首次有效绘制时间。如果 JavaScript 在首次有效绘制之后来得太晚，浏览器可能会在解析、编译和执行后期发现的 JavaScript 时[锁定主线程](https://davidea.st/articles/measuring-server-side-rendering-performance-is-tricky)，从而给[站点或应用程序的交互](https://philipwalton.com/articles/why-web-developers-need-to-care-about-interactivity/)带来枷锁。

为避免这种情况，请始终将函数执行分解为独立的异步任务，并尽可能使用 `requestIdleCallback`。考虑使用 webpack 的[动态 `import()` 支持](https://developers.google.com/web/updates/2017/11/dynamic-import)，延迟加载 UI 的部分，降低加载、解析和编译成本，直到用户真正需要它们（**感谢 Addy！**）。

从本质上讲，首次可交互时间（TTI）告诉我们导航和交互之间的时间。通过查看初始内容渲染后的前五秒窗口来定义度量标准，其中任何 JavaScript 任务都不会超过 50 毫秒。如果发生超过 50 毫秒的任务，则重新开始搜索五秒钟窗口。因此，浏览器将首先假设它已到达交互状态，然后切换到冻结状态，最终切换回交互状态。

一旦我们到达交互状态，在按需或在时间允许的情况下，就可以启动应用程序的非必要部分。不幸的是，正如 [Paul Lewis 所注意到的那样](https://aerotwist.com/blog/when-everything-is-important-nothing-is/#which-to-use-progressive-booting)，框架通常没有提供给开发者优先级的概念，因此大多数库和框架都难以实现渐进式启动。如果你有时间和资源，请使用此策略最终提升性能。

那么，客户端还是服务器端？如果用户没有明显的好处，[客户端渲染可能不是真正必要的](https://medium.com/@addyosmani/the-cost-of-javascript-in-2018-7d8950fbb5d4) —— 实际上，服务器端渲染的 HTML 可能更快。也许你甚至可以[使用静态站点生成器预渲染一些内容](https://jamstack.org/)，并将它们直接推送到 CDN，并在顶部添加一些 JavaScript。

将客户端框架的使用限制为绝对需要它们的页面。如果做得不好，服务器渲染和客户端渲染是一场灾难。考虑在[构建时预渲染](https://github.com/GoogleChromeLabs/prerender-loader)和[动态 CSS 内联](https://github.com/GoogleChromeLabs/critters)，以生成生产就绪的静态文件。Addy Osmani 就可能值得关注的 [JavaScript 成本发表了精彩的演讲](https://www.youtube.com/watch?v=63I-mEuSvGA)。

#### 37. 约束第三方脚本的影响

通过所有性能优化，我们通常无法控制来自业务需求的第三方脚本。第三方脚本指标不受最终用户体验的影响，因此通常一个脚本最终会调用令人讨厌的冗长的第三方脚本，从而破坏了专门的性能工作。为了控制和减轻这些脚本带来的性能损失，仅仅异步加载它们（[可能是通过延迟](https://www.twnsnd.com/posts/performant_third_party_scripts.html)）并通过资源提示（如 `dns-prefetch` 或 `preconnect`）加速它们是不够的。

正如 Yoav Weiss 在他[关于第三方脚本的必读观点](http://conffab.com/video/taking-back-control-over-third-party-content/)中所解释的那样，在许多情况下，这些脚本会下载动态的资源。资源在页面加载之间发生变化，因此我们没有必要知道从哪些主机下载资源以及这些资源是什么。

你有哪些选择方案?考虑**使用 service worker，通过超时竞争资源下载**，如果资源在特定超时内没有响应，则返回空响应以告知浏览器继续解析页面。你还可以记录或阻止未成功或不符合特定条件的第三方请求。如果可以，请[从你自己的服务器](https://medium.com/caspertechteam/we-shaved-1-7-seconds-off-casper-com-by-self-hosting-optimizely-2704bcbff8ec)而不是从供应商的服务器加载第三方脚本。

[![Casper.com 发布了一个详细的案例研究，说明他们如何通过自我托管的 Optimizely 将网站响应时间减少了 1.7 秒。它可能是值得的。](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/cf570272-840e-4cf8-92de-76808a12422c/casper-case-study-optimizely.png)](https://medium.com/caspertechteam/we-shaved-1-7-seconds-off-casper-com-by-self-hosting-optimizely-2704bcbff8ec) 

Casper.com 发布了一个详细的案例研究，说明他们如何通过自托管的 Optimizely 网站响应时间减少了 1.7 秒。这可能是值得的。（[图片来源](https://medium.com/caspertechteam/we-shaved-1-7-seconds-off-casper-com-by-self-hosting-optimizely-2704bcbff8ec)）（[预览大图](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/cf570272-840e-4cf8-92de-76808a12422c/casper-case-study-optimizely.png)）

另一种选择是建立**内容安全策略**（CSP）以限制第三方脚本的影响，例如：不允许下载音频或视频。最好的选择是通过 `<iframe>` 嵌入脚本，以便脚本在 iframe 的上下文中运行，因此第三方脚本无法访问页面的 DOM，也无法在你的域上运行任意代码。使用 `sandbox` 属性可以进一步约束 iframe，那样你就可以禁用一切 iframe 可能执行的任何功能，例如：防止脚本运行、阻止警报、表单提交、插件、访问顶部导航等。

比如，可能必须使用 `<iframe sandbox="allow-scripts">` 来运行脚本。每个限制都可以通过 `sandbox` 属性上的各种 `allow` 值来解除（[几乎所有的浏览器都受支持](https://caniuse.com/#search=sandbox)），因此将它们限制在应该允许的最低限度。

考虑使用 Intersection Observer；这将使广告仍然在 iframe 中，但是可以调度事件或从 DOM 获取所需信息（例如， 广告可见性）。可以关注一些新的策略，例如[功能策略](https://www.smashingmagazine.com/2018/12/feature-policy/)，资源大小限制和 CPU/带宽优先级，以限制可能会降低浏览器速度的有害 Web 功能和脚本，例如：同步脚本、同步 XHR 请求、`document.write` 和过时的实现。

要对[第三方进行压力测试](https://csswizardry.com/2017/07/performance-and-resilience-stress-testing-third-parties/)，请检查 DevTools 中性能配置文件页面中的自下而上的摘要，测试如果请求被阻止或超时的情况会发生什么 —— 对于后者，你可以使用 WebPageTest 的 Blackhole 服务器 `blackhole.webpagetest.org`，它可以将特定域指向你的 `hosts` 文件。最好是[自托管并使用单一主机名](https://www.twnsnd.com/posts/performant_third_party_scripts.html)，但也可以[生成一个请求映射](https://www.soasta.com/blog/10-pro-tips-for-managing-the-performance-of-your-third-party-scripts/)，该映射公开第四方调用并检测脚本何时更改。你可以使用 Harry Roberts 的[方法审核第三方](https://csswizardry.com/2018/05/identifying-auditing-discussing-third-parties/)，并生成[类似这样](https://docs.google.com/spreadsheets/d/1uTcRSoJAkXfIm2yfG5hvCSzvSZD9fAwXNQMVK3HdPMI/edit#gid=0)的电子表格。Harry 还在他[关于第三方性能和审计的讨论中](https://www.youtube.com/watch?v=bmIUYBNKja4)解释了审计工作流程。

![请求阻止](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/b1e12dad-ea64-430e-b3db-b67fb76029d8/block-request-url-image-opt.png)

图片来源: [Harry Roberts](https://csswizardry.com/2017/07/performance-and-resilience-stress-testing-third-parties/#request-blocking)

#### 38. 设置 HTTP 缓存标头

仔细检查是否已正确设置 `expires`，`max-age`，`cache-control` 和其他 HTTP 缓存头。通常，资源无论在[短时间内（如果它们可能会更改）还是无限期（如果它们是静态的）](https://jakearchibald.com/2016/caching-best-practices/)情况下都是可缓存的 —— 你只需在需要时在 URL 中更改它们的版本。禁用 `Last-Modified` 标头，因为任何带有它的静态资源都将导致带有 `If-Modified-Since` 标头的条件请求，即使资源位于缓存中也是如此。`Etag` 也是如此。

使用使用专为指纹静态资源设计的 `Cache-control：immutable`，以避免重新验证（截至 2018 年 12 月，[Firefox、Edge 和 Safari 都已经支持该功能](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Cache-Control); Firefox 仅支持 `https：//` 事务）。事实上，“在 HTTP 存档中的所有页面中，2％ 的请求和 30％ 的网站似乎[包含至少 1 个不可变响应](https://discuss.httparchive.org/t/cache-control-immutable-a-year-later/1195)。此外，大多数使用它的网站都设置了具有较长新鲜生命周期的静态资源。”

还记得 [stale-while-revalidate](https://www.fastly.com/blog/stale-while-revalidate-stale-if-error-available-today) 吗？你可能知道，我们使用 `Cache-Control` 响应头指定缓存时间，例如： `Cache-Control: max-age=604800`。经过 604800 秒后，缓存将重新获取所请求的内容，从而导致页面加载速度变慢。通过使用 `stale-while-revalidate` 可以避免这种速度变慢的问题。它本质上定义了一个额外的时间窗口，在此期间缓存可以使用旧的静态资源，只要它在异步地在后台重新验证自己。因此，它“隐藏了”来自客户端的延迟（在网络和服务器上）。

在 2018 年 10 月，Chrome 发布了一个[意图](https://groups.google.com/a/chromium.org/forum/#!topic/blink-dev/rspPrQHfFkI/discussion) 在 HTTP Cache-Control 标头中对 `stale-while-revalidate` 的处理，因此，它应该会改善后续页面加载延迟，因为旧的静态文件不再位于关键路径中。 结果：[重复访问页面的 RTT 为零](https://twitter.com/RyanTownsend/status/1072443651844911104)。 

你可以使用 [Heroku 的 HTTP 缓存标头入门](https://devcenter.heroku.com/articles/increasing-application-performance-with-http-cache-headers)，Jake Archibald 的“[缓存最佳实践](https://jakearchibald.com/2016/caching-best-practices/)”和Ilya Grigorik 的 [HTTP 缓存入门](https://developers.google.com/web/fundamentals/performance/optimizing-content-efficiency/http-caching?hl=en)作为指南。另外，要注意[标头的变化](https://www.smashingmagazine.com/2017/11/understanding-vary-header/)，特别是[与 CDN 相关的标头](https://www.fastly.com/blog/getting-most-out-vary-fastly)，并注意 [Key 标头](https://www.greenbytes.de/tech/webdav/draft-ietf-httpbis-key-latest.html)，这有助于避免当新请求与先前请求略有差异（但不显着）时，需要进行额外的往返验证（**感谢 Guy！**）。

另外，请仔细检查你是否发送了[不必要的标头](https://www.fastly.com/blog/headers-we-dont-want)（例如 `x-powered-by`、`pragma`、`x-ua-compatible`、`expires` 等），并且包含有用的[安全性和性能标头](https://www.fastly.com/blog/headers-we-want)（例如 `Content-Security-Policy`, `X-XSS-Protection`, `X-Content-Type-Options` 等）。最后，请记住单页应用程序中 [CORS 请求的性能成本](https://medium.com/@ankur_anand/the-terrible-performance-cost-of-cors-api-on-the-single-page-application-spa-6fcf71e50147)。

> [译] [2019 前端性能优化年度总结 — 第一部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-1.md)
> [译] [2019 前端性能优化年度总结 — 第二部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-2.md)
> [译] [2019 前端性能优化年度总结 — 第三部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-3.md)
> **[译] [2019 前端性能优化年度总结 — 第四部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-4.md)**
> [译] [2019 前端性能优化年度总结 — 第五部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-5.md)
> [译] [2019 前端性能优化年度总结 — 第六部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-6.md)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
