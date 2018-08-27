> * 原文地址：[A cartoon intro to WebAssembly](https://hacks.mozilla.org/2017/02/a-cartoon-intro-to-webassembly/)
> * 原文作者：本文已获作者 [Lin Clark](https://code-cartoons.com/@linclark) 授权
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者： [根号三](https://github.com/sqrthree)
> * 校对者：[Reid](https://github.com/reid3290)、[Tina92](https://github.com/Tina92)

# 看漫画，学 WebAssembly

WebAssembly 运行得很快，你可能已经听说过这个了。但是是什么让 WebAssembly 这么快呢？

在这个系列的文章里，我想和你解释一下为什么 WebAssembly 这么快。

## 等等，WebAssembly 究竟是什么？

WebAssembly 是一种用 JavaScript 以外的编程语言编写代码并在浏览器中运行该代码的方法。因此当人们说 WebAssembly 运行得很快的时候，通常他们都是在和 JavaScript 进行比较。

现在，我不想暗示这是一个二选一的情况 —— 你要么用 WebAssembly 或者用 JavaScript。事实上，我们期望开发者能够在同一个应用里面同时使用 WebAssembly 和 JavaScript。

但是比较一下这二者是非常有用的，你可以因此理解 WebAssembly 将会具有的潜在影响。

## 一点性能历史

JavaScript 创建于 1995 年。它不是为了快而设计的，并且在最初前十年，它并不快。

然后浏览器之间的竞争开始变得愈演愈烈。

在 2008 年，人们所谓的“性能战争”时期开始了。很多浏览器都添加了即时编译器 —— 也叫做 JIT。当 JavaScript 运行时，JIT 可以看到模式（pattern）并且基于这些模式（pattern）让代码运行得更快。

这些 JIT 的引入致使 JavaScript 的性能进入了一个转折点。JS 的执行速度快了 10 倍。

![A graph showing JS execution performance increasing sharply in 2008](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2017/02/01-01-perf_graph05-500x409.png)

通过这种性能的改善，JavaScript 开始被用于没有人期望用它来做的一些事情上。例如使用 Node.js 进行服务端编程。性能的改善使得在一个全新的问题上使用 JavaScript 成为了可能。

伴随着 WebAssembly，我们现在可能正处于另一个转折点。

![A graph showing another performance spike in 2017 with a question mark next to it](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2017/02/01-02-perf_graph10-500x412.png)

因此，让我们深入细节之中，来理解是什么使得 WebAssembly 很快。

[第二篇传送门](https://github.com/xitu/gold-miner/blob/master/TODO/a-crash-course-in-just-in-time-jit-compilers.md)
