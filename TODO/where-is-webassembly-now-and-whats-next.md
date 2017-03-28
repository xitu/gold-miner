> * 原文地址：[Where is WebAssembly now and what’s next?](https://hacks.mozilla.org/2017/02/where-is-webassembly-now-and-whats-next/)
> * 原文作者：本文已获作者 [Lin Clark](https://code-cartoons.com/@linclark) 授权
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：[胡子大哈](https://github.com/huzidaha/)
> * 校对者：[根号三](https://github.com/sqrthree)

# WebAssembly 的现在与未来

**本文是关于 WebAssembly 系列的第六篇文章，也同时是本系列的收尾文章。如果你没有读先前文章的话，建议[先读这里](https://github.com/xitu/gold-miner/blob/master/TODO/a-cartoon-intro-to-webassembly.md)。**

2017 年 2 月 28 日，四个主要的浏览器[一致同意宣布](https://lists.w3.org/Archives/Public/public-webassembly/2017Feb/0002.html) WebAssembly 的 MVP 版本已经完成，它是一个浏览器可以搭载的稳定版本。

![](https://huzidaha.github.io/images-store/201703/21-1.png)

它提供了浏览器可以搭载的稳定核，这个核并没有包含 WebAssembly 组织所计划的所有特征，而是提供了可以使 WebAssembly 稳定运行的基本版本。

这样一来开发者就可以使用 WebAssembly 代码了。对于旧版本的浏览器，开发者可以通过 asm.js 来向下兼容代码，asm.js 是 JavaScript 的一个子集，所有 JS 引擎都可以使用它。另外，通过 Emscripten 工具，既可以用 WebAssembly 也可以用 asm.js 来编译你的代码。

尽管是第一个版本，但是 WebAssembly 已经能发挥出它的优势了，未来通过不断地改善和融入新特征，WebAssembly 会变得更快。

## 提升浏览器中 WebAssembly 的性能
随着各种浏览器都使自己的引擎支持 WebAssembly，速度提升就变成自然而然的事情了，目前各大浏览器厂商都在积极推动这件事情。

### JavaScript 和 WebAssembly 之间调用的中间函数
目前，在 JS 中调用 WebAssembly 的速度比本应达到的速度要慢。这是因为中间需要做一次“蹦床运动”。JIT 没有办法直接处理 WebAssembly，所以 JIT 要先把 WebAssembly 函数发送到懂它的地方。这一过程是引擎中比较慢的地方。

![](https://huzidaha.github.io/images-store/201703/21-2.png)

按理来讲，如果 JIT 知道如何直接处理 WebAssembly 函数，那么速度会有百倍的提升。

如果你传递给 WebAssembly 模块的是单一任务，那么不用担心这个开销，因为只有一次转换，也会比较快。但是如果是频繁地从 WebAssembly 和 JavaScript 之间切换，那么这个开销就必须要考虑了。

### 快速加载
JIT 必须要在快速加载和快速执行之间做权衡。如果在编译和优化阶段花了大量的时间，那么执行的必然会很快，但是启动会比较慢。目前有大量的工作正在研究，如何使预编译时间和程序真正执行时间两者平衡。

WebAssembly 不需要对变量类型做优化假设，所以引擎也不关心在运行时的变量类型。这就给效率的提升提供了更多的可能性，比如可以使编译和执行这两个过程并行。

加之最新增加的 JavaScript API 允许 WebAssembly 的流编译，这就使得在字节流还在下载的时候就启动编译。

FireFox 目前正在开发两个编译器系统。一个编译器先启动，对代码进行部分优化。在代码已经开始运行时，第二个编译器会在后台对代码进行全优化，当全优化过程完毕，就会将代码替换成全优化版本继续执行。

## 添加后续特性到 WebAssembly 标准的过程
WebAssembly 的发展是采用小步迭代的方式，边测试边开发，而不是预先设计好一切。

这就意味着有很多功能还在襁褓之中，没有经过彻底思考以及实际验证。它们想要写进标准，还要通过所有的浏览器厂商的积极参与。

这些特性叫做：**未来特性**。这里列出几个。

### 直接操作 DOM
目前 WebAssembly 没有任何方法可以与 DOM 直接交互。就是说你还不能通过比如 `element.innerHTML` 的方法来更新节点。

想要操作 DOM，必须要通过 JS。那么你就要在 WebAssembly 中调用 JavaScript 函数（WebAssembly 模块中，既可以引入 WebAssembly 函数，也可以引入 JavaScript 函数）。

![](https://huzidaha.github.io/images-store/201703/21-3.png)

不管怎么样，都要通过 JS 来实现，这比直接访问 DOM 要慢得多，所以这是未来一定要解决的一个问题。

### 共享内存的并发性
提升代码执行速度的一个方法是使代码并行运行，不过有时也会适得其反，因为不同的线程在同步的时候可能会花费更多的时间。

这时如果能够使不同的线程共享内存，那就能降低这种开销。实现这一功能 WebAssembly 将会使用 JavaScript 中的 SharedArrayBuffer，而这一功能的实现将会提高程序执行的效率。

### SIMD（单指令，多数据）
如果你之前了解过 WebAssembly 相关的内容，你可能会听说过 SIMD，全称是：Single Instruction, Multiple Data（单指令，多数据），这是并行化的另一种方法。

SIMD 在处理存放大量数据的数据结构有其独特的优势。比如存放了很多不同数据的 vector（容器），就可以用同一个指令**同时**对容器的不同部分做处理。这种方法会大幅提高复杂计算的效率，比如游戏或者 VR。

这对于普通 web 应用开发者不是很重要，但是对于多媒体、游戏开发者非常关键。

### 异常处理
许多语言都仿照 C++ 式的异常处理，但是 WebAssembly 并没有包含异常处理。

如果你用 Emscripten 编译代码，就知道它会模拟异常处理，但是这一过程非常之慢，慢到你都想用 [“DISABLE_EXCEPTION_CATCHING”](https://kripken.github.io/emscripten-site/docs/optimizing/Optimizing-Code.html#c-exceptions) 标记把异常处理关掉。

如果异常处理加入到了 WebAssembly，那就不用采用模拟的方式了。而异常处理对于开发者来讲又特别重要，所以这也是未来的一大功能点。

### 其他改进——使开发者开发起来更简单
一些未来特性不是针对性能的，而是使开发者开发 WebAssembly 更方便。

* **一流的开发者工具**。目前在浏览器中调试 WebAssembly 就像调试汇编一样，很少的开发者可以手动地把自己的源代码和汇编代码对应起来。我们在致力于开发出更加适合开发者调试源代码的工具。
* **垃圾回收**。如果你能提前确定变量类型，那就可以把你的代码变成 WebAssembly，例如 TypeScript 代码就可以编译成 WebAssembly。但是现在的问题是 WebAssembly 没办法处理垃圾回收的问题，WebAssembly 中的内存操作都是手动的。所以 WebAssembly 会考虑提供方便的 GC 功能，以方便开发者使用。
* **ES6 模块集成**。目前浏览器在逐渐支持用 `script` 标记来加载 JavaScript 模块。一旦这一功能被完美执行，那么像 `<script src=url type="module">` 这样的标记就可以运行了，这里的 `url` 可以换成 WebAssembly 模块。

## 总结
WebAssembly 执行起来更快，随着浏览器逐步支持了 WebAssembly 的各种特性，WebAssembly 将会变得更快。

（译者注：欢迎大家关注我的专栏[前端大哈](https://zhuanlan.zhihu.com/qianduandaha)，定期发布高质量前端文章。）


