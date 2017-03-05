> * 原文地址：[A cartoon intro to WebAssembly](https://hacks.mozilla.org/2017/02/a-cartoon-intro-to-webassembly/)
* 原文作者：[Lin Clark](https://code-cartoons.com/@linclark)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者： [根号三](https://github.com/sqrthree)
* 校对者：

# A cartoon intro to WebAssembly

# 关于 WebAssembly 的一篇介绍

WebAssembly is fast. You’ve probably heard this. But what is it that makes WebAssembly fast?

WebAssembly 很快，你可能已经听说过这个了。但是是什么让 WebAssembly 这么快呢？

In this series, I want to explain to you why WebAssembly is fast.

在这个系列的文章里，我想和你解释一下为什么 WebAssembly 这么快。

## Wait, so what is WebAssembly?

## 等等，究竟什么是 WebAssembly？

WebAssembly is a way of taking code written in programming languages other than JavaScript and running that code in the browser. So when people say that WebAssembly is fast, what they are comparing it to is JavaScript.

WebAssembly 是一种用 JavaScript 以外的编程语言编写的代码并在浏览器中运行该代码的方法。因此当人们说 WebAssembly 很快的时候，通常他们都是在和 JavaScript 进行比较。

Now, I don’t want to imply that it’s an either/or situation — that you’re either using WebAssembly or using JavaScript. In fact, we expect that developers will use both WebAssembly and JavaScript in the same application.

现在，我不想暗示这是一个二选一的情况 —— 你要么用 WebAssembly 或者用 JavaScript。事实上，我们期望开发者能够在同一个应用里面同时使用 WebAssembly 和 JavaScript。

But it is useful to compare the two, so you can understand the potential impact that WebAssembly will have.

但是比较一下这二者是非常有用的，你可以因此理解 WebAssembly 将会具有的潜在影响。

## A little performance history

## 一点性能历史

JavaScript was created in 1995. It wasn’t designed to be fast, and for the first decade, it wasn’t fast.

JavaScript 创建于 1995 年。它不是为了快而设计的，并且在最初前十年，它并不快。

Then the browsers started getting more competitive.

然后浏览器之间开始的竞争变得愈演愈烈。

In 2008, a period that people call the performance wars began. Multiple browsers added just-in-time compilers, also called JITs. As JavaScript was running, the JIT could see patterns and make the code run faster based on those patterns.

在 2008 年，被人们称之为“性能战争”的时期开始了。很多浏览器都添加了即时编译器 —— 也叫做 JIT。当 JavaScript 运行时，JIT 可以看到模式（pattern）并且基于这些模式（pattern）让代码运行的更快。

The introduction of these JITs led to an inflection point in the performance of JavaScript. Execution of JS was 10x faster.

这些 JIT 的引入致使 JavaScript 的性能进入了一个转折点。JS 的执行速度快了 10 倍。

![A graph showing JS execution performance increasing sharply in 2008](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2017/02/01-01-perf_graph05-500x409.png)

With this improved performance, JavaScript started being used for things no one ever expected it to be used for, like server-side programming with Node.js. The performance improvement made it feasible to use JavaScript on a whole new class of problems.

通过这种性能的改善，JavaScript 开始被用于没有人期望用它来做的一些事情上。例如使用 Node.js 进行服务端编程。性能的改善使得在一个全新的问题上使用 JavaScript 成为了可能。

We may be at another one of those inflection points now, with WebAssembly.

伴随着 WebAssembly，我们现在可能正处于另一个转折点。

![A graph showing another performance spike in 2017 with a question mark next to it](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2017/02/01-02-perf_graph10-500x412.png)

So, let’s dive into the details to understand what makes WebAssembly fast.

因此，让我们深入细节之中，来理解是什么使得 WebAssembly 很快。
