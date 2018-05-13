> * 原文地址：[How JavaScript works: A comparison with WebAssembly + why in certain cases it’s better to use it over JavaScript](https://blog.sessionstack.com/how-javascript-works-a-comparison-with-webassembly-why-in-certain-cases-its-better-to-use-it-d80945172d79)
> * 原文作者：[Alexander Zlatkov](https://blog.sessionstack.com/@zlatkov?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-javascript-works-a-comparison-with-webassembly-why-in-certain-cases-its-better-to-use-it.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-javascript-works-a-comparison-with-webassembly-why-in-certain-cases-its-better-to-use-it.md)
> * 译者：[stormluke](https://github.com/stormluke)
> * 校对者：

# JavaScript 是如何工作的：对比 WebAssembly + 为什么在某些场景下它比 JavaScript 更合适

这是专门探索 JavaScript 及其构建组件系列的第 6 期。在识别和描述核心元素的过程中，我们还分享了构建 SessionStack 时使用的一些经验法则 —— 这是一个轻量级的 JavaScript 应用程序，但必须强大且性能卓越，才能帮助用户实时查看和重现其 Web 应用的缺陷。

1. [[译] JavaScript 是如何工作的：对引擎、运行时、调用堆栈的概述](https://juejin.im/post/5a05b4576fb9a04519690d42)
2. [[译] JavaScript 是如何工作的：在 V8 引擎里 5 个优化代码的技巧](https://github.com/xitu/gold-miner/blob/master/TODO/how-javascript-works-inside-the-v8-engine-5-tips-on-how-to-write-optimized-code.md)
3. [[译] JavaScript 是如何工作的：内存管理 + 处理常见的4种内存泄漏](https://github.com/xitu/gold-miner/blob/master/TODO/how-javascript-works-memory-management-how-to-handle-4-common-memory-leaks.md)
4. [[译] JavaScript 是如何工作的: 事件循环和异步编程的崛起 + 5个如何更好的使用 async/await 编码的技巧](https://github.com/xitu/gold-miner/blob/master/TODO/how-javascript-works-event-loop-and-the-rise-of-async-programming-5-ways-to-better-coding-with.md)
5. [[译] JavaScript 是如何工作的：深入剖析 WebSockets 和拥有 SSE 技术 的 HTTP/2，以及如何在二者中做出正确的选择](https://github.com/xitu/gold-miner/blob/master/TODO/how-javascript-works-deep-dive-into-websockets-and-http-2-with-sse-how-to-pick-the-right-path.md)

这次我们将剖析 WebAssembly 的工作原理，更重要的是在性能方面分析它与 JavaScript 的差异：加载时间、执行速度、垃圾回收、内存使用情况、平台 API 调用、调试、多线程和可移植性。

我们构建 Web 应用程序的方式正处于革命的边缘 —— 仍然是初级阶段，但我们对 Web 应用程序的看法正在发生变化。

#### 首先，让我们看看 WebAssembly 的功能

WebAssembly（也叫作 **wasm**）是一种高效且低级的给 web 使用的字节码。

WASM 让你能够用 JavaScript 之外的语言（例如 C、C++、Rust 或其他）编写程序，然后将其（提前）编译到 WebAssembly。

其结果是 Web 应用程序加载和执行速度都非常快。

#### 加载时间

为了加载 JavaScript，浏览器必须加载所有文本形式的 `.js` 文件。

WebAssembly 在浏览器中加载速度更快，因为只需通过互联网传输已编译的 wasm 文件。而 wasm 是一种非常简洁的二进制格式的低级类汇编语言。

#### 执行

今天 Wasm 的运行速度只**比本地代码执行**慢 20%。无论如何，这是一个惊人的结果。这是一种编译到沙盒环境中的格式，并且在很多约束条件下运行，以确保它没有或者很难有安全漏洞。与真正的本地代码相比，速度损失很小。更重要的是，它将**在未来更快**。

更好的是，它与浏览器无关 —— 目前所有主要引擎都增加了对 WebAssembly 的支持，并且提供类似的运行时。

为了理解 WebAssembly 与 JavaScript 相比执行得有多快，你应该首先阅读[我们关于 JavaScript 引擎的文章](https://blog.sessionstack.com/how-javascript-works-inside-the-v8-engine- 5-tips-how-to-write-optimized-code-ac089e62b12esource=---------3----------------)。

我们来看看大概看看 V8 中会发生什么：

![](https://cdn-images-1.medium.com/max/800/0*bN9YVBLw_tT1Xvte.)

V8 的方法：延迟编译

在左边，我们有一些 JavaScript 源代码，包含 JavaScript 函数。首先需要解析它，以便将所有字符串转换为词法标记（token）并生成[抽象语法树](https://en.wikipedia.org/wiki/Abstract_syntax_tree)（AST）。AST 是 JavaScript 程序逻辑的内存表示。一旦生成了这种表示，V8 会直接跳到机器码。过程基本上是遍历语法树，生成机器代码，最后得到编译好的函数。没有真正的尝试来加速它。

现在，我们来看看 V8 流水线在下一阶段的功能：

![](https://cdn-images-1.medium.com/max/800/0*wzuQ9LYv7CAUICOC.)

V8 流水线设计。

这次我们有了 [TurboFan](https://github.com/v8/v8/wiki/TurboFan) —— V8 的优化编译器之一。当你的 JavaScript 应用运行时，很多代码会在 V8 中运行。TurboFan 可以监控某些代码是否运行缓慢，是否存在瓶颈和热点来优化它们。它把这些代码推到编译器后端 —— 一个优化的 [JIT](https://en.wikipedia.org/wiki/Just-in-time_compilation)，这个后端可为那些消耗大部分 CPU 的函数创建更快的代码。

它解决了上面的问题，但这里的问题在于，分析并决定优化哪些代码的过程也会消耗 CPU。这反过来又意味着更高的电池消耗，特别是在移动设备上。

好了，wasm 并不需要所有的这些 —— 它会被插入工作流中，如下所示：

![](https://cdn-images-1.medium.com/max/800/0*GDU4GguTzk8cSAYk.)

V8 流水线设计 + WASM。

Wasm 在编译阶段就已经优化好。最重要的是，也不需要解析了的。你有了一个已优化的二进制文件，它可以直接挂接到生成机器码的编译器后端。所有优化都在编译器前端完成。

这让执行 wasm 更有效率，因为流程中的很多步骤都可以简单地跳过。

#### 内存模型

![](https://cdn-images-1.medium.com/max/800/0*QphcOVaiVC2YL7Jd.)

WebAssembly 可信和不可信状态。

举个例子，C++ 程序中的内存是一个连续的区块，其中并没有「空隙」。有助于提高安全性的 wasm 的特性之一是，执行栈与线性内存分离的概念。在 C++ 程序中，你有一个堆，你从底部分配堆内存，并从堆顶部获取栈空间。这就有可能造出一个指向栈空间的指针来玩弄那些本不应该接触到的变量。

这是很多恶意软件所利用的缺陷。

WebAssembly 采用完全不同的模型。执行栈与 WebAssembly 程序本身是分开的，因此你无法修改栈变量等内容。而且，函数中使用整数偏移而不是指针。函数指向一个间接函数表。然后通过这些计算出的直接数字跳转到模块内部的函数中。这种设计方式使得你可以加载多个 wasm 模块，并排排列，平移所有的索引，互不影响。

有关 JavaScript 中内存模型和管理的更多信息，可以查看我们非常详细的[关于此主题的文章](https://blog.sessionstack.com/how-javascript-works-memory-management-how-to-handle-4-common-memory-leaks-3f28b94cfbec)。

#### 垃圾回收

你已经知道 JavaScript 的内存管理是使用垃圾收集器处理的。

WebAssembly 的情况有点不同。它支持手动管理内存的语言。你的 wasm 模块可以自带 GC，但这是一项复杂的任务。

目前，WebAssembly 是围绕 C++ 和 RUST 用例设计的。由于 wasm 是非常低级的，因此只有汇编语言上一层的编程语言才易于编译。C 可以使用普通的 malloc，C++ 可以使用智能指针，Rust 使用完全不同的形式（完全不同的主题）。这些语言不使用 GC，因此它们不需要哪些复杂的运行时来跟踪内存。WebAssembly 对他们来说是天作之合。

另外，这些语言并不是 100％ 被设计用于调用复杂的 JavaScript 事物，如操作 DOM。完全在 C++ 中编写 HTML 应用是没有意义的，因为 C++ 不是为它设计的。在大多数情况下，当工程师编写 C++ 或 Rust 时，他们的目标是 WebGL 或高度优化的库（例如繁重的数学计算）。

但是，将来 WebAssembly 也将支持不附带 GC（但需要垃圾回收）的语言。

Depending on the runtime that executes JavaScript, access to platform-specific APIs is being exposed which can be directly reached through your JavaScript application. For example, if you’re running JavaScript in the browser, you have a set of [Web APIs](https://developer.mozilla.org/en-US/docs/Web/API) that the web app can call to control web browser/device functionality and access things like [DOM](https://developer.mozilla.org/en-US/docs/Web/API/Document_Object_Model), [CSSOM](https://developer.mozilla.org/en-US/docs/Web/API/CSS_Object_Model), [WebGL](https://developer.mozilla.org/en-US/docs/Web/API/WebGL_API), [IndexedDB](https://developer.mozilla.org/en-US/docs/Web/API/IndexedDB_API), [Web Audio API](https://developer.mozilla.org/en-US/docs/Web/API/Web_Audio_API), etc.

#### 平台 API 调用

取决于执行 JavaScript 的运行时，不同特定于平台的 API 可以通过 JavaScript 应用程序直接访问。例如，如果在浏览器中运行 JavaScript，你可以通过一系列 [Web APIs](https://developer.mozilla.org/en-US/docs/Web/API) 来控制 web 浏览器 / 设备的功能，并且可以使用例如 [DOM](https://developer.mozilla.org/en-US/docs/Web/API/Document_Object_Model)、[CSSOM](https://developer.mozilla.org/en-US/docs/Web/API/CSS_Object_Model)、[WebGL](https://developer.mozilla.org/en-US/docs/Web/API/WebGL_API)、[IndexedDB](https://developer.mozilla.org/en-US/docs/Web/API/IndexedDB_API)、[Web Audio API](https://developer.mozilla.org/en-US/docs/Web/API/Web_Audio_API) 等等

好吧，WebAssembly 模块无法直接调用任何平台 API。一切都是由 JavaScript 代理的。如果你想在 WebAssembly 模块中调用的某些平台特定的 API，则必须通过 JavaScript 调用它。

例如，如果你想用 `console.log`，必须通过 JavaScript 调用它，而不是你的 C++ 代码。这些 JavaScript 调用的成本会比较高。

也并不总是如此。规范将在未来为平台 API 提供 wasm 接口，并且你将能够在没有 JavaScript 的情况下发布应用程序。

#### 源码映射

当你压缩 JavaScript 代码时，需要一种正确调试它的方法。这就是[源码映射](https://www.html5rocks.com/en/tutorials/developertools/sourcemaps/)大显身手地方。

基本上，源码映射是一种将整合/压缩文件映射回构建前状态的方法。当你构建线上版时，压缩和组合 JavaScript 文件时将生成一个包含原始文件信息的源码映射。当你在生成的 JavaScript 中查询某一行号和列号时，可以在源码映射中查找代码的原始位置。

WebAssembly 目前不支持源码映射，因为暂时没有规范，但最终会有的（可能很快）。

当在 C++ 代码中设置断点时，你将看到 C++ 代码而不是 WebAssembly。至少这是目标。

#### 多线程

JavaScript 在单线程上运行。有很多方法可以发挥事件循环和异步编程优势，详见[我们关于该主题的文章](https://blog.sessionstack.com/how-javascript-works-event-loop-and-the-rise-of-async-programming-5-ways-to-better-coding-with-2f077c4438b5)。

JavaScript 也使用 Web Workers，但他们有一个非常具体的用例 —— 基本上，阻止主 UI 线程的任何重 CPU 计算都可以从 Web Worker 中受益。但是 Web Workers 无法访问 DOM。

WebAssembly 目前不支持多线程。但是未来可能会。Wasm 将会和本地线程更近（例如 C++ 型线程）。拥有「真实」的线程将在浏览器中创造出许多新的机会。当然，这也将打开更多滥用可能性的大门。

#### 可移植性

如今，JavaScript 几乎可以在任何地方运行，从浏览器到服务器端甚至嵌入式系统。

WebAssembly 设计目标是安全且可移植。就像 JavaScript 一样。它将运行在支持 wasm 的每个环境中（例如每个浏览器）。

WebAssembly 具有与 Java Applets 初期尝试实现的移植性相同的可移植性目标。

#### 在哪里使用 WebAssembly 比 JavaScript 更好？

在 WebAssembly 的第一个版本中，主要关注 CPU 占用大的计算（例如处理数学）。想到的最主流的用途是游戏 —— 那里有大量的像素操作。你可以使用你习惯的 OpenGL 绑定在 C++ / Rust 中编写应用，并将其编译为 wasm。它会在浏览器中运行。

看看这个（在 Firefox 中运行）—— [http://s3.amazonaws.com/mozilla-games/tmp/2017-02-21-SunTemple/SunTemple.html](http://s3.amazonaws.com/mozilla-games/tmp/2017-02-21-SunTemple/SunTemple.html)。它使用[虚幻引擎](https://www.unrealengine.com/en-US/what-is-unreal-engine-4)。

另一种使用 WebAssembly 可能有意义（性能方面）的场景是实现一些这是一个 CPU 密集型的库。例如，一些图像处理库。

如前所述，由于大多数处理步骤都是在编译期间提前完成的，因此 wasm 可以减少移动设备上的电池消耗（取决于引擎）。

将来，即使你实际上没有编写代码，你也可以使用 WASM 二进制文件。可以在 NPM 中找到开始使用此方法的项目。

对于 DOM 操作和大量的平台 API 操作，当然用 JavaScript 更好，因为它不会增加额外的开销，并且具有原生的 API。

在 [SessionStack](https://www.sessionstack.com/?utm_source=medium&utm_medium=blog&utm_content=Post-6-webassembly-outro)，为了编写高度优化且高效的代码，我们不断突破 JavaScript 性能的机极限。我们的解决方案需要提供超快的性能，因为我们不能阻碍客户应用本身。将 SessionStack 集成到线上 Web 应用或网站后，它会开始记录所有内容：所有 DOM 更改、用户交互、JavaScript 异常、堆栈跟踪、失败的网络请求和调试数据。所有这些都在你的线上环境中进行，但不会影响产品的任何体验和性能。我们需要大量优化我们的代码并尽可能使其异步。

而且不只是库！当你在 SessionStack 中重放用户会话时，我们必须渲染在发生问题时用户浏览器中发生的所有事件，并且必须重构整个状态，允许你在会话时间线中来回跳转。为了做到这一点，我们正在大量使用 JavaScript 提供的异步能力，因为缺少更好的选择。

借助 WebAssembly，我们能够将一些最繁重的处理和渲染交给更适合做这个工作的语言，同时将数据收集和 DOM 操作留给 JavaScript。

如果你想试试 SessionStack，[可以从这里免费开始](https://www.sessionstack.com/?utm_source=medium&utm_medium=blog&utm_content=Post-6-webassembly-trynow)。免费版可以提供 1000 会话 / 月。

![](https://cdn-images-1.medium.com/max/800/1*GmlfCMCeX2VKR3HCHuGIwA.png)

资源：

* https://www.youtube.com/watch?v=6v4E6oksar0
* https://www.youtube.com/watch?v=6Y3W94_8scw


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
