> * 原文地址：[JavaScript Start-up Performance](https://medium.com/@addyosmani/javascript-start-up-performance-69200f43b201#.f2ifedbt2)
* 原文作者：[Addy Osmani](https://medium.com/@addyosmani?source=post_header_lockup)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[vuuihc](https://github.com/vuuihc)
* 校对者：[fghpdf](https://github.com/fghpdf), [skyar2009](https://github.com/skyar2009)

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/2000/1*ZpwZLFDNYZodJDerr7-37A.png">

# JavaScript 启动性能探究 #

作为 web 开发者，都知道 web 项目开发到最后，页面规模很容易变的很大。 但 **加载** 一个网页远不止从网线上传送字节码那么简单。浏览器下载了页面脚本之后，它还必须解析、解释和运行它们。这篇文章将深入 JavaScript 的这一部分，研究 **为什么** 这一过程会拖慢应用程序的启动，以及 **如何** 解决。

过去，人们并没有花很多时间优化 JavaScript 的解析、编译步骤。我们总是期望解析器在遇到 script 标签时立即解析和执行代码，但是情况并非如此。 **以下是对 V8 引擎工作原理的简要分析**：

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/1000/1*GuWInZljjvtDpdeT6O0emA.png" >

上图是描述 V8 工作流程的简图，这是我们正在努力达到的理想化流程。

我们来着重分析几个主要阶段。

#### **启动时拖慢应用的是什么?** ####

在启动期间，JavaScript 引擎花费 **显著** 的时间来解析、编译和执行脚本。这一阶段很关键，因为如果它用时太多，将会 **延后** 用户可以与我们的网站 **互动** 的时间点。想象一下，如果用户可以看到一个按钮，但很多秒之后才能点击或触摸，这将会 **降低** 用户体验。

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/1000/0*M94-AavlZjGoudZG.">

V8 的 Chrome Canary 中的 Runtime Call Stats 分析出的流行网站的解析和编译时间。注意，桌面端本就缓慢的解析、编译过程，在一般手机上则需要更长的时间。

启动时间对 **性能敏感的** 代码很重要。事实上，V8 —— Chrome 的 JavaScript 引擎，在 Facebook，Wikipedia 和 Reddit 等顶级网站上都会花费大量时间来解析和编译脚本：

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/1000/1*XjHkzz0B7KlcDbLFD1JS8Q.png">

粉红色区域（JavaScript）表示在 V8 和 Blink 的 C++ 中花费的时间，而橙色和黄色则表示解析和编译所用时间。

在你可能正在使用的 **大量** 大型网站和框架中，解析和编译也被视为一个性能瓶颈。以下是来自 Facebook 的 Sebastian Markbage 和 Google 的 Rob Wormald 的推文：

![Markdown](http://p1.bqimg.com/1949/1b2fcab3d77309c1.png)

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/600/1*nkJwMuE5PpgF_pE0e6RM6g.jpeg">

Sam Saccone 在 [Planning for Performance](https://www.youtube.com/watch?v=RWLzUnESylc) 中提到了 JS 解析的成本。

随着我们进入一个逐渐移动化的世界，我们有必要知道 **解析、编译在手机上花费的时间通常是在桌面上的 2 - 5 倍**。高端手机（例如 iPhone 或 Pixel）的表现与 Moto G4 非常不同。这更说明了测试代表性硬件（不仅仅是高端硬件！）的重要性，只有这样，用户体验才不会受到影响。

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*dnhO1M_zlmAhvtQY_7tZmA.jpeg">

1 MB 的 JavaScript 文件在不同类别的桌面设备和移动设备上的 [解析时间](https://docs.google.com/a/google.com/spreadsheets/d/1Zk0HDGvqNO_8jaudF2jwTItI-H0blD8_ShHfLsnp_Us/edit?usp=sharing)。可以注意到，像 iPhone 7 这样的高端手机的性能和 Macbook Pro 是多么接近，而沿着图表向下看，普通的移动硬件性能则不一样了。

如果应用程序需要传输的文件很大，那么被广泛采用的现代打包技术，如 code-splitting、tree-shaking 和 Service Worker caching 可以产生巨大作用。但是，**即使文件很小，如果代码写得不好或者用了很差的第三方库，也会导致主线程在编译或函数调用时被长时间阻塞。** 整体衡量和理解真正的瓶颈在哪里是很重要的。

### JavaScript 解析、编译是普通网站的瓶颈吗？ ###

『（你说的都对……）但是，我的网站又不是Facebook』，你可能会这样说。 **『外面的一般网站的解析和编译时间所占比例有多大？』**，你可能会这样问。现在我们来研究一下！

我花了两个月时间测试了一系列（6000+）使用了不同库和框架（如 React、Angular、Ember 和 Vue）构建的大型生产站点的性能。其中大多数测试最近可以在 WebPageTest 重做。所以如果你愿意的话，很容易重做这些测试，或者深入研究这些数据。下面是一些分析结果：

**应用在桌面端（使用网线）用 8 秒可以变得可交互，在移动端（ 3G 网络下的 Moto G4 ）则需要 16 秒。**

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/1000/1*WC4zanI0DKAoSiJVU3VUeA.png">

**是什么造成了这一结果？大多数网页应用在桌面端的启动（解析、编译、执行）平均花费了 4 秒。**

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*NacL9cZJ1osZowPS6hbCsQ.jpeg">

在移动设备上，解析时间比在桌面设备上多出 36％。

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/1000/1*uTRfB5pne06h8lp5jGtiIQ.jpeg">

**大家都传输了巨大的 JS 打包文件吗？没有我猜到的那么大，但还有改进的余地。** 410KB，这是开发者传输的 gzip 压缩后的 JS 文件大小的中位数。这与 HTTPArchive 报告的『平均每网页 JS 大小』420KB 比较符合。最差劲的网站会向任何网页请求者发送高达 10MB 的脚本文件。

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*GvwfE2GjKQyLBKPmmfRwuA.png">

**脚本大小很重要，但它不是一切。解析和编译时间不一定随着脚本大小的增加线性增加。** 较小的 JavaScript 打包文件通常会减少 **加载** 时间（忽略浏览器，设备和网络连接的影响），但是你的 200KB 的JS文件不等于别人的 200KB，同样大小的文件可以有差别很大的的解析和编译时间。

### **当前如何测量 JavaScript 的解析和编译** ###

**Chrome DevTools**

Timeline (Performance panel) > Bottom-Up/Call Tree/Event Log 可以帮助我们深入了解解析、编译花费的时间。为了得到更完整的分析（比如在解析、编译或惰性编译中花费的时间），我们可以打开 **V8 的 Runtime Call Stats** 。 在 Canary 中，你可以在 Timeline 中的 Experiments > V8 Runtime Call Stats 找到它。

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/1000/0*rWkYJzc6Cp0r3Xkr.">

**Chrome Tracing**

在 Chrome 地址栏输入 **about:tracing** 之后，这个 Chrome 的底层跟踪工具允许我们使用 `disabled-by-default-v8.runtime_stats` 类别来深入了解 V8 的时间消耗详情。V8 几天前发布了一个 [循序渐进的指导文档](https://docs.google.com/presentation/d/1Lq2DD28CGa7bxawVH_2OcmyiTiBn74dvC6vn2essroY/edit#slide=id.g1a504e63c9_2_84) 可以帮助你了解它的用法。

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/0*P-_pLIITtYJRikRN.">

**WebPageTest**

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/600/1*y6x_vr7aOxK4jHG9blgseg.png">

当我们使用 Chrome 的 Capture Dev Tools Timeline 进行跟踪分析时，WebPageTest 的 『Processing Breakdown』 页面包含了对 V8 编译、EvaluateScript 和 FunctionCall 的时间的深入分析。

现在我们还可以通过指定 `disabled-by-default-v8.runtime_stats` 为自定义跟踪类别来获得 **Runtime Call Stats**（WPT 的 Pat Meenan 现在默认这样做！）。

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*tV48evC-XzYkoHonyKGkOw.png">

如果你想知道如何充分利用这一工具，可以参阅我写的 [这篇文档](https://gist.github.com/addyosmani/45b135900a7e3296e22673148ae5165b) 。

**User Timing**

也可以像 Nolan Lawson 下面指出的这样，通过 [User Timing API](https://w3c.github.io/user-timing/#dom-performance-mark) 测量解析时间：

![Markdown](http://p1.bqimg.com/1949/268de751304f859f.png)

第 3 个脚本不重要，第 1 个脚本与第 2 个脚本分开（ *performance.mark()* 在要测试的 script 标签之前执行）是重要的。

**使用此方法时，V8 的 preparser 可能会影响后续重新加载。这可以通过在脚本的结尾处附加一个随机字符串来解决，Nolan 在他的 optimize-js benchmarks 中就是这样做的。**

我使用类似的方法用 Google Analytics 来测量 JavaScript 解析时间的影响：

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*ziA8f9KhB1gOt-Mq07cRFw.jpeg">

自定义的 Google Analytics 维度 『parse』 可让我测量开放环境中访问我的网页的真实用户和设备的 JavaScript 解析时间。

**DeviceTiming**

Etsy的 [DeviceTiming](https://github.com/danielmendel/DeviceTiming) 工具可以帮助测量受控环境中脚本的解析和执行时间。它的工作原理是用测试代码封装本地脚本，以便每次页面被不同的设备（例如笔记本电脑、手机、平板电脑）访问时，我们可以本地比较解析、执行时间。Daniel Espeset的文章 [Benchmarking JS Parsing and Execution on Mobile Devices](http://talks.desp.in/unpacking-the-black-box) 详细介绍了这个工具。

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*FFzrH2QUiQZFX2rlF5e2-g.jpeg">

### **当前可以做什么来减少 JavaScript 解析时间?** ###

- **传输更少的 JavaScript。** 需要解析的脚本越少，我们在解析和编译阶段用的时间就越少。

- **使用 code-splitting 技术，只发送用户当前路由需要的代码，延迟加载其余代码。** 想要避免解析太多的 JS，这可能是最有帮助的方法。类似 [PRPL](https://developers.google.com/web/fundamentals/performance/prpl-pattern/) 的模式鼓励这种基于路由的文件分块，现在已经被 Flipkart、Housing.com 和 Twitter 采用。

- **Script streaming:** 过去，V8 已经告诉开发者通过 `async/defer` 选择使用 [Script streaming](https://blog.chromium.org/2015/03/new-javascript-techniques -for-rapid.html) 模式，可以使得解析时间减少 10 - 20％。这允许 HTML 解析器能够至少先检测到资源，将（解析）工作分配给 script streaming 线程，从而不阻塞文档解析。现在，解析器阻塞脚本也有了个模式，不需要做什么额外操作。V8 建议 **先加载较大的打包文件，因只有一个脚本流线程**（之后会说到这点）

- **测量依赖的解析成本** ，比如各种库和框架。在可能的情况下，将它们切换为拥有更快解析速度的依赖（例如，把 React 切换为 Preact 或 Inferno，后两者启动时需要更少的字节码，更少的解析、编译时间）。Paul Lewis 在最近的一篇文章中介绍了 [framework bootup](https://aerotwist.com/blog/when-everything-is-important-nothing-is/) 成本。Sebastian Markbage 也在推文中 [提到](https://twitter.com/sebmarkbage/status/829733454119989248)，**一个测量框架的启动成本的好方法是首先渲染一遍视图，然后删除它，然后再次渲染，这可以告诉你它的启动成本**。因为第一次渲染会（解析、编译）唤起一堆懒编译的代码，之后重复渲染一个更大的代码树时可以不用重复进行。

如果我们选择的 JavaScript 框架支持提前编译模式（AoT），也有助于大大减少在解析、编译中花费的时间。Angular 应用就受益于这种模式，看这个例子：

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*sr4eb-cx3lq7hVrJGfDNaw.png">

Nolan Lawson 的 [『解决 Web 性能危机』](https://channel9.msdn.com/Blogs/msedgedev/nolanlaw-web-perf-crisis)

### **当前 *浏览器* 为了减少解析和编译时间在做什么?** ###

并不是只有开发者才认为生产环境的应用启动时间是一个需要改进的领域。V8 发现 Octane 作为有历史的测试平台之一，对我们通常测试的 25 个热门网站的真实性能的测试效果不佳。Octane 对于 1）**JavaScript 框架**（通常代码不是单/多态性）和 2）**实际页面应用程序启动**（大多数是冷启动代码）来说不是一个好的工具。这两个用例对于web 来说非常重要。也就是说，Octane 不是对所有种类的工作负载都是不合理的。

V8 团队一直努力改善启动时间，并且已经在这些地方取得了一些胜利：

![Markdown](http://p1.bqimg.com/1949/1cebbf646ca580f5.png)

在查看我们的 Octane-Codeload 数据之后，我们估计在许多页面上，V8 解析时间提高了25％：

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*cE8uvuvb0-iZslygh2NCTQ.jpeg">

我们也看到了 Pinterest 网站在这方面的有所进展。在过去几年中，V8 开展了许多其他探索，以减少解析和编译时间。

**Code caching**

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/600/1*xChjWSbT1rCqgLMacOMotQ.png">

来自文章 [使用 V8 的代码缓存](https://www.nativescript.org/blog/using-v8-code-caching-to-minimize-app-load-time-on-android)

Chrome 42 引入了[Code caching](http://v8project.blogspot.com/2015/07/code-caching.html)  —— 它通过在本地存储编译后的代码，使得在用户返回页面时，脚本请求、解析和编译过程都可以跳过。我们注意到，这项变更可让 Chrome 在处理页面后续访问时减少约 40％ 的编译时间，但现在我想对这项功能进一步说明：

- **在 72 小时内执行两次** 的脚本才会触发 Code caching。

- 对于 Service Worker 的脚本：对于在 72 小时内执行两次的脚本触发 Code caching。

- 对于通过 Service Worker 存储在 Cache Storage 中的脚本：**首次执行** 脚本就会触发 Code caching。

所以，结论是， **如果我们的代码是在缓存中，V8 会在第 3 次加载时跳过解析和编译。**
我们可以在 *chrome://flags/#v8-cache-strategies-for-cache-storage* 中查看这些差异。 我们还可以设置 `js-flags=profile-deserialization` 后运行Chrome，看看项目是否从代码缓存中加载（在日志中显示为反序列化事件）。

使用 Code caching 需要注意的一个点是，它只缓存可预编译的代码。通常只是运行一次以设置全局变量的顶层代码。 函数定义通常是惰性编译的，不总是被缓存。 **IIFEs**（optimize-js 用户）也被在 V8 Code caching 缓存，因为它们也可预编译。

**Script Streaming**

[Script streaming](https://blog.chromium.org/2015/03/new-javascript-techniques-for-rapid.html) 允许脚本开始下载后在 **单独的后台线程** 上解析异步或延迟脚本，从而将页面加载速度提高了多达 10％。如前所述，这同样适用于 **同步** 脚本。

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/1000/1*ooXJ0NES-gXEzteaGPL2nQ.png">

自从该功能首次引入以来，V8 已经切换到允许 **所有脚本**、**甚至** 是 `src=""` 的解析器阻塞脚本在后台线程上解析，所以所有人都应该在这里看到一些成果。唯一需要注意的是，这里只有一个后台线程，所以把大的、关键的脚本先分配给它很重要。**在这里思考任何潜在的优化都很重要。**

**经验之谈是，把 defer 脚本放在 <head> 里，这样 V8 就可以早发现资源，然后在用台线程解析它。**

可以使用 DevTools Timeline 检查是否选择了正确的脚本被流式传输 —— 如果有一个大脚本占用了解析时间，那么（通常）确保它被流式传输接收是有意义的。

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*FAvUG7DrVJUXCK3oweMSLQ.png">

**更好地解析和编译**

研发一个更轻量、更快的解析器的工作正在进行，新的解析器会更消耗内存，并且更有效地利用数据结构。今天，V8 的主线程闪避的 **最大** 原因是非线性解析成本。来看一个 UMD 的片段：

(function (global, **module**) { … })(this, function **module**() { *my functions* })

V8 不会知道 **modules** 是否一定是需要的，所以当主脚本编译时不会编译它。当我们决定编译 **modules** 时，我们需要重新解析所有的内部函数。这就是 V8 的解析时间非线性的原因。深度为 n 的每个函数都被解析 n 次，并导致闪避。

V8 已经在致力于在初始编译期间收集内部函数的信息，从而任何未来的编译都可以 **忽略** 它们的内部函数。对于 **module** 风格函数，这应该会导致很大的性能改进。

参阅 ‘[The V8 Parser(s) — Design, Challenges, and Parsing JavaScript Better](https://docs.google.com/presentation/d/1214p4CFjsF-NY4z9in0GEcJtjbyVQgU0A-UqEvovzCs/edit#slide=id.p)’ 以获得更多信息.

V8 也在探索在启动期间将 JavaScript 编译的部分分配到 **后台线程**。

**预编译 JavaScript?**

每隔几年，就会有提供一种方法 **预编译** 脚本的引擎出现，以帮助我们不浪费时间解析或编译代码。它们的想法是，如果不预解析、编译代码，一个构建时或服务器端工具就能直接生成字节码，我们会看到启动速度的巨大提高。我认为，传输字节码将会增加加载时间（文件会更大），可能需要对代码进行签名并做一些安全处理。V8 的立场是，现在探索避免内部重新解析将有助于看到很大的进步，这是预编译可能不能提供的，但同时我们会对可以获得更快的启动时间的想法持开放讨论的态度。也就是说，当开发者在 Service Worker 中更新站点时，V8 正在探索更积极地编译和缓存脚本代码，我们希望这些工作获得一些成果。

我们与 Facebook 和 Akamai 在 BlinkOn 7 讨论了预编译，我的笔记可以在 [这里](https://gist.github.com/addyosmani/4009ee1238c4b1ff6f2a2d8a5057c181) 找到。

**Optimize JS 惰性解析的括号「hack」**

像 V8 这样的 JavaScript 引擎有一个惰性解析启发式方法，在进行一轮完整的解析之前，它们会预先解析我们脚本中的大多数函数（例如检查语法错误）。这是因为大多数页面都有懒惰执行的 JS 函数。

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/600/1*LMRg_jHJeP53vdy8aiTEJQ.png">

预解析可以通过仅检查浏览器需要了解的函数的最小集合来加快启动时间。这与 IIFE 有所分歧，虽然引擎尝试跳过对它们的预解析，但是启发式并不总是可靠的，这就是 [optimize-js](https://github.com/nolanlawson/optimize-js) 等工具发挥作用的地方。

optimize-js 提前解析脚本，在它知道（或通过启发式假设）的函数将立即执行的地方插入括号来使其获得 **更快的执行**。对一些函数插入括号是稳妥的（比如带有 ! 的 IIFE）。其它的就是基于启发式的（例如在 Browserify 或 Webpack 包中，假定所有模块都急切加载，就不一定适用这种情况）。总而言之，V8 希望这样的 hack 不再被需要，但现在我们可以认为这是一个优化，如果我们知道你在做什么。

**V8 也在努力降低编译器判断错误的情况下的成本，这也应该减少对括号的需要**

### 总结 ###

**启动性能很重要** 较长的解析、编译和执行时间组合起来会变成希望快速启动的页面的真正瓶颈。你应该 **测量** 你的网页在此阶段花费的时间，探索你可以做什么以使其更快。

我们将尽我们所能从我们的角度继续努力提高 V8 启动性能。 这是我们的承诺;）也希望你们有一个快乐的提高性能的过程！

### **阅读更多** ###

- [Planning for Performance](https://www.youtube.com/watch?v=RWLzUnESylc)

- [Solving the Web Performance Crisis by Nolan Lawson](https://twitter.com/MSEdgeDev/status/819985530775404544) 

- [JS Parse and Execution Time](https://timkadlec.com/2014/09/js-parse-and-execution-time/) 

- [Measuring Javascript Parse and Load](http://carlos.bueno.org/2010/02/measuring-javascript-parse-and-load.html)

- [Unpacking the Black Box: Benchmarking JS Parsing and Execution on Mobile Devices](https://www.safaribooksonline.com/library/view/velocity-conference-new/9781491900406/part78.html)

-  ([slides](https://speakerdeck.com/desp/unpacking-the-black-box-benchmarking-js-parsing-and-execution-on-mobile-devices)

- [When everything’s important, nothing is!](https://aerotwist.com/blog/when-everything-is-important-nothing-is/) 

- [The truth about traditional JavaScript benchmarks](http://benediktmeurer.de/2016/12/16/the-truth-about-traditional-javascript-benchmarks/)

- [Do Browsers Parse JavaScript On Every Page Load](http://stackoverflow.com/questions/1096907/do-browsers-parse-javascript-on-every-page-load/)


**向 V8 (Toon Verwaest, Camillo Bruni, Benedikt Meurer, Marja Hölttä, Seth Thompson), Nolan Lawson (MS Edge), Malte Ubl (AMP), Tim Kadlec (Synk), Gray Norton (Chrome DX), Paul Lewis, Matt Gaunt and Rob Wormald (Angular) 致谢，同时感谢他们对本文的修订**
