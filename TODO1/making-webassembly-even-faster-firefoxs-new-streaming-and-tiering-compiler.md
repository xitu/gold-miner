> * 原文地址：[Making WebAssembly even faster: Firefox’s new streaming and tiering compiler](https://hacks.mozilla.org/2018/01/making-webassembly-even-faster-firefoxs-new-streaming-and-tiering-compiler/)
> * 原文作者：[Lin Clark](http://code-cartoons.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/making-webassembly-even-faster-firefoxs-new-streaming-and-tiering-compiler.md](https://github.com/xitu/gold-miner/blob/master/TODO1/making-webassembly-even-faster-firefoxs-new-streaming-and-tiering-compiler.md)
> * 译者：[Sam](https://github.com/xutaogit/)
> * 校对者：[Augustwuli](https://github.com/Augustwuli)

# 使 WebAssembly 更快：Firefox 的新流式和分层编译器

人们都说 WebAssembly 是一个游戏规则改变者，因为它可以让代码更快地在网络上运行。有些[加速已经存在](https://hacks.mozilla.org/2017/02/what-makes-webassembly-fast/)，还有些在不远的将来。

其中一种加速是流式编译，即浏览器在代码还在下载的时候就对其进行编译。截至目前，这只是潜在的未来加速（方式）。但随着下周 Firefox 58 版本的发布，它将成为现实。

Firefox 58 还包含两层新的编译器。新的基线编译器编译代码的速度比优化编译器快了 10-15 倍。

综合起来，这两个变化意味着我们编译代码的速度比从网络中编译代码速度快。

[![](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2018/01/ezgif-5-73711fc5d3.gif)](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2018/01/ezgif-5-73711fc5d3.gif)

在台式电脑上，我们每秒编译 30-60 兆字节的 WebAssembly 代码。这比网络传送数据包的[速度](http://www.speedtest.net/global-index)还快。

如果你使用 Firefox Nightly 或者 Beta，你可以在你自己设备上[试一试](https://lukewagner.github.io/test-tanks-compile-time/)。即便是在很普通的移动设备上，我们可以每秒编译 8 兆字节 —— 这比任何移动网络的平均下载速度都要快得多。

这意味着你的代码几乎是在它完成下载后就立即执行。

### 为什么这很重要？

当网站发布大批量 JavaScript 代码时，Web 性能拥护者会变得束手无策。这是因为下载大量的 JavaScript 会让页面加载变慢。

这很大程度是因为解析和编译时间。正如 [Steve Souder 指出](https://calendar.perfplanet.com/2017/tracking-cpu-with-long-tasks-api/)，网络性能的旧瓶颈曾是网络。但现在网络性能的新瓶颈是 CPU，特别是主线程。

[![Old bottleneck, the network, on the left. New bottleneck, work on the CPU such as compiling, on the right](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2018/01/02-500x295.png)](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2018/01/02.png)

所以我们想要尽可能多的把工作从主线程中移除。我们也想要尽可能早的启动它，以便我们充分利用 CPU 的所有时间。更好的是，我们可以完全减少 CPU 工作量。

使用 JavaScript 时，你可以做一些这样的事情。你可以通过流入的方式在主线程外解析文件。但你还是需要解析它们，这就需要很多工作，并且你必须等到它们都解析完了才能开始编译。然后编译的时候，你又回到了主线程上。这是因为 JS 通常是运行时[延迟编译](https://hacks.mozilla.org/2017/02/a-crash-course-in-just-in-time-jit-compilers/)的。

[![Timeline showing packets coming in on the main thread, then parsing happening simultaneously on another thread. Once parse is done, execution begins on main thread, interrupted occassionally by compiling](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2018/01/03-500x167.png)](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2018/01/03.png)

使用 WebAssembly，启动的工作量减少了。解码 WebAssembly 比解析 JavaScript 更简单，更快捷。并且这些解码和编译可以跨多个线程进行拆分。

这意味着多个线程将运行基线编译，这会让它变得更快。一旦完成，基线编译好的代码就可以在主线程上开始执行。它不必像 JS 代码一样暂停编译。

[![Timeline showing packets coming in on the main thread, and decoding and baseline compiling happening across multiple threads simultaneously, resulting in execution starting faster and without compiling breaks.](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2018/01/04-500x202.png)](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2018/01/04.png)

当基线编译的代码在主线程上运行时，其他线程则在做更优化的版本。当更优化的版本完成时，它就会替换进来使得代码运行更加快捷。

这使得加载 WebAssembly 的成本变得更像解码图片而不是加载 JavaScript。并且想想看 —— 网络性能倡导者肯定接受不了 150kB 的 JS 代码负载量，但相同大小的图像负载量并不会引起人们的注意。

[![Developer advocate on the left tsk tsk-ing about large JS file. Developer advocate on the right shrugging about large image.](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2018/01/05-500x218.png)](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2018/01/05.png)

这是因为图像的加载时间要快得多，就像 Addy Osmani 在 [JavaScript 的成本](https://medium.com/dev-channel/the-cost-of-javascript-84009f51e99e) 中解释的那样，解码图像并不会阻塞主线程，正如 Alex Russell 在[你能接受吗？真实的 Web 性能预算](https://infrequently.org/2017/10/can-you-afford-it-real-world-web-performance-budgets/)中所讨论的那样。

但这并不意味着我们希望 WebAssembly 文件和图像文件一样大。虽然早期的 WebAssembly 工具创建了大型的文件，是因为它们包含了很多运行时（内容），目前来看还有很多工作要做让文件变得更小。例如，Emscripten 有一个[“缩小协议”](https://github.com/kripken/emscripten/issues/5836)。在 Rust 中，你已经可以通过使用 wasm32-unknown-unknown 目标来获取相当小尺寸的文件，并且还有像 [wasm-gc](https://github.com/alexcrichton/wasm-gc) 和 [wasm-snip](https://github.com/fitzgen/wasm-snip) 这样的工具来帮助进一步优化它们。

这就意味着这些 WebAssembly 文件的加载速度要比等量的 JavaScript 快得多。

这很关键。正如 [Yehuda Katz 指出](https://twitter.com/wycats/status/942908325775077376)，这是一个游戏规则改变者。

[![Tweet from Yehuda Katz saying it's possible to parse and compile wasm as fast as it comes over the network.](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2018/01/06-500x444.png)](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2018/01/06.png)

所以让我们看看新编译器是怎么工作的吧。

### 流式编译：更早开始的编译

如果你更早开始编译代码，你就更早完成它。这就是流式编译所做的 —— 尽可能快的开始编译 .wasm 文件。

当你下载文件时，它不是单件式的。实际上，它带来的是一系列数据包。

之前，当 .wasm 文件中的每个包正在下载时，浏览器网络层会把它放进 ArrayBuffer（译者注：数组缓存）中。

[![Packets coming in to network layer and being added to an ArrayBuffer](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2018/01/07-500x255.png)](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2018/01/07.png)

然后，一旦完成下载，它会将 ArrayBuffer 转移到 Web VM（也就是 JS 引擎）中。也就到了 WebAssembly 编译器要开始编译的时候。

[![Network layer pushing array buffer over to compiler](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2018/01/08-500x218.png)](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2018/01/08.png)

但是没有充分的理由让编译器等待。从技术上讲，逐行编译 WebAssembly 是可行的。这意味着你能够在第一个块进来的时候就开始启动。

所以这就是我们新编译器所做的。它利用了 WebAssembly 的流式 API。

[![WebAssembly.instantiateStreaming call, which takes a response object with the source file. This has to be served using MIME type application/wasm.](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2018/01/09-500x132.png)](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2018/01/09.png)

如果你提供给 `WebAssembly.instantiateStreaming` 一个响应的对象，则（对象）块一旦到达就会立即进入 WebAssembly 引擎。然后编译器可以开始处理第一个块，即便下一个块还在下载中。

[![Packets going directly to compiler](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2018/01/10-500x248.png)](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2018/01/10.png)

除了能够并行下载和编译代码外，它还有另外一个优势。

.wasm 模块中的代码部分位于任何数据（它将引入到模块的内存对象）之前。因此，通过流式传输，编译器可以在模块的数据仍在下载的时候就对其进行编译。如果当你的模块需要大量的数据，且可能是兆字节的时候，这些就会显得很重要。

[![File split between small code section at the top, and larger data section at the bottom](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2018/01/11-500x260.png)](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2018/01/11.png)

通过流式传输，我们可以提前开始编译。而且我们同样可以更快速地进行编译。

### 第 1 层基线编译器：更快的编译代码

如果你想要代码跑的快，你就需要优化它。但是当你编译时执行这些优化会花费时间，也就会让编译代码变得更慢。所以这里需要一个权衡。

但鱼和熊掌可以兼得。如果我们使用两个编译器，就能让其中一个快速编译但是不做过多的优化工作，而另一个虽然编译慢，但是创建了更多优化的代码。

这就称作为层编译器。当代码第一次进入时，将由第 1 层（或基线）编译器对其编译。然后，当基线编译完成，代码开始运行之后，第 2 层编译器再一次遍历代码并在后台编译更优化的版本。

一旦它（译者注：第 2 层编译）完成，它会将优化后的代码热插拔为先前的基线版本。这使代码执行得更快。

[![Timeline showing optimizing compiling happening in the background.](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2018/01/12-500x204.png)](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2018/01/12.png)

JavaScript 引擎已经使用分层编译器很长一段时间了。然而，JS 引擎只在一些代码变得“温热” —— 当代码的那部分被调用太多次时，才会使用第 2 层（或优化）编译器。

相比之下，WebAssembly 的第 2 层编译器会热切地进行全面的重新编译，优化模块中的所有代码。在未来，我们可能会为开发者添加更多选项，用来控制如何进行激进的优化或者惰性的优化。

基线编译器在启动时节省了大量时间。它编译代码的速度比优化编译器的快 10-15 倍。并且在我们的测试中，它创建代码的速度只慢了 2 倍。

这意味着，只要仍在运行基线编译代码，即便是在最开始的几分钟你的代码也会运行地很快。

### 并行化：让一切更快

在[关于 Firefox Quantum 的文章](https://hacks.mozilla.org/2017/11/entering-the-quantum-era-how-firefox-got-fast-again-and-where-its-going-to-get-faster/)中，我解释了粗粒度和细粒度的并行化。我们可以用它们来编译 WebAssembly。

我在上文有提到，优化编译器会在后台进行编译。这意味着它空出的主线程可用于执行代码。基线编译版本的代码可以在优化编译器进行重新编译时运行。

但在大多数电脑上仍然会有多个核心没有使用。为了充分使用所有核心，两个编译器都使用细粒度并行化来拆解工作。

并行化的单位是功能，每个功能都可以在不同的核心上单独编译。这就是所谓的细粒度，实际上，我们需要将这些功能分批处理成更大的功能组。这些批次会被派送到不同的核心里。

### ...然后通过隐式缓存完全跳过所有工作（未来的任务）

目前，每次重新加载页面时都会重做解码和编译。但是如果你有相同的 .wasm 文件，它编译后都是一样的机器代码。

这意味着，很多时候这些工作都可以跳过。这些也是未来我们要做的。我们将在第一页加载时进行解码和编译，然后将生成的机器码缓存在 HTTP 缓存中。之后当你再次请求这个 URL 的时候，它会拉取预编译的机器代码。

这就能让后续加载页面的加载时间消失了。

[![Timeline showing all work disappearing with caching.](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2018/01/13-500x217.png)](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2018/01/13.png)

这项功能已经有了基础构建。我们在 Firefox 58 版本中[缓存了这样的 JavaScript 字节代码](https://blog.mozilla.org/javascript/2017/12/12/javascript-startup-bytecode-cache/)。我们只需扩展这种支持来缓存 .wasm 文件的机器代码。

## 关于 [Lin Clark](http://code-cartoons.com)

Lin 是 Mozilla Developer Relations 团队的工程师。她致力于 JavaScript、WebAssembly、Rust 和 Servo，还会绘制代码漫画。

*   [code-cartoons.com](http://code-cartoons.com)
*   [@linclark](http://twitter.com/linclark)

[Lin Clark 的更多文章...](https://hacks.mozilla.org/author/lclarkmozilla-com/)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
