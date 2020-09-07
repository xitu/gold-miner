> * 原文地址：[JavaScript Engines: An Overview](https://blog.bitsrc.io/javascript-engines-an-overview-2162bffa1187)
> * 原文作者：[Mahdhi Rezvi](https://medium.com/@mahdhirezvi)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/javascript-engines-an-overview.md](https://github.com/xitu/gold-miner/blob/master/article/2020/javascript-engines-an-overview.md)
> * 译者：[Isildur46](https://github.com/Isildur46)
> * 校对者：[Chorer](https://github.com/Chorer)、[CaptainWang98](https://github.com/CaptainWang98)

# JavaScript 引擎概述

![Photo by [JOSHUA COLEMAN](https://unsplash.com/@joshstyle?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) on [Unsplash](https://unsplash.com/t/technology?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)](https://cdn-images-1.medium.com/max/10944/1*VzPVDApZ_xVLY0qGZGMAoA.jpeg)

## 引言

JavaScript 引擎是指一种执行 JavaScript 代码的程序或者解释器。JavaScript 引擎可以用很多编程语言来实现。例如，Chrome 浏览器使用的 V8 引擎是用 C++ 写的，而 Firefox 浏览器的 SpiderMonkey 引擎则是用 C 和 C++。

JavaScript 引擎可以作为标准解释器来实现，或者也可以作为即时编译（just-in-time）器，将 JavaScript 编译成某种形式的字节码。第一批 JavaScript 引擎基本都是解释器，但是多数现代引擎为了提升性能会采用即时编译（JIT）的方式。

## 主流的 JavaScript 引擎

所有主流的浏览器都实现了它们自己的 JavaScript 引擎。以下是一些主流的 JavaScript 引擎。

* Chrome 的 [V8 引擎](https://v8.dev/)
* Firefox 的 [SpiderMonkey](https://developer.mozilla.org/zh-CN/docs/Mozilla/Projects/SpiderMonkey)
* Safari 的 [JavaScriptCore](https://developer.apple.com/documentation/javascriptcore)（又被称为 Nitro、SquirrelFish 和 SquirrelFish Extreme）
* Edge 的 [Chakra](https://github.com/microsoft/ChakraCore) —— **不过最近 Edge 采用了 Chromium 的 V8 引擎**

## JavaScript 引擎流程图

![Image Credits: Sander in [Dev.to](https://dev.to/sanderdebr/a-brief-explanation-of-the-javascript-engine-and-runtime-2idg)](https://cdn-images-1.medium.com/max/2000/0*NzDz1ZLZxP6ZgbvO.jpeg)

如果你好奇 JavaScript 是如何运作的，这里有一个简单的流程图。

#### 1. 解析器

首先，HTML 解析器遇到包含 JavaScript 源代码的 script 标签。这个 script 中的源代码会以 UTF-16 字节流的形式加载到字节流解码器。这些字节会被解码成 token（单词符号）并传递给解析器。为了提升效率，引擎通常不会解析暂时用不到的代码。

#### 2. AST

解析器基于它接收到的 token 来生成节点，再基于这些节点来生成抽象语法树（AST）。语义分析阶段，编译器会校验语言要素和关键字的使用是否合法，此时 AST 会起到至关重要的作用。

你可以访问 [https://astexplorer.net/](https://astexplorer.net/) 查看在线示例。

#### 3. 解释器

接下来是解释器，它会逐行解释代码，分析 AST 并生成字节码。字节码生成后，AST 会被移除，并且它占据的内存空间会被清空。解释器能够快速生成未优化的字节码，在无延迟的情况下让程序立即开始运行。

需要注意的是，解释器如果多次遇到同一个函数，它会多次解释并执行这个函数，总体效率就会很慢。这就是为什么我们需要编译器，它不会重复循环地编译，而是以更高效的方式运行。

#### 4. 分析工具

分析工具会评估正在运行的代码，标识出哪些区域可以利用技术手段来优化。

#### 5. 编译器

在分析工具的帮助下，任何未优化的代码都会传递给编译器去进行优化，它会生成同等功能但运行更快的机器码，这些机器码最终会替换掉之前解释器生成的未优化的字节码。

#### 6. 优化过的代码

完成这 6 个步骤之后，你会得到高度优化过的代码。

**现在让我们简要了解一下 Chrome 的 V8 引擎，看看它傲视群雄的原因是什么。**

## Chrome 的 V8 引擎

V8 引擎是用 C++ 写的一个开源应用程序，它将 JavaScript 代码编译为优化过的机器码后再运行。起初，V8 引擎的目的是提升 JavaScript 在 Chrome 和基于 Chromium 的浏览器中的运行效率。之后随着时间的推移，最近几个版本的 V8 引擎能够让 JavaScript 代码脱离于浏览器运行，使得它可以作为服务器端脚本。

早期的 JavaScript 引擎都是解释器，会逐行解释代码并运行。但随着时间的推移，这样的运行方式已经不能满足需求了。Chrome V8 实现了一种叫做即时编译（JIT）的技术，这种技术结合了多个解释器和编译器，带来了更高的代码执行效率。

#### 为何 V8 与众不同？

V8 和 SpiderMonkey、Rhino 这样的现代引擎遵循相同的方法，但是 V8 的特色在于它不生成任何中间代码或者字节码。

但自从 2016 年，Chrome V8 团队推出了一款名叫 **Ignition** 的解释器之后，一切都变了。在 Ignition 的加持下，V8 将 JavaScript 编译为较短的字节码，其长度大概是同等基线机器码的 50% 到 25%。接着用高性能解释器来运行这些字节码，在实际网站中，它们的运行速度几乎和 V8 现有的基线编译器生成的代码差不多。

![V8’s compilation pipeline with Ignition enabled (2016)— Source: [V8 Docs](https://v8.dev/blog/ignition-interpreter)](https://cdn-images-1.medium.com/max/2000/0*zEOYOFjXg-iJE3_i.png)

#### 快速变化

你必须时刻记住，Web 开发领域是在快速变化的，对于浏览器来说更是如此。人们总在不断尝试以提高性能、优化体验，这也促进了 JavaScript 引擎在架构上的定期调整和更新。博客中的文章会过时 —— 甚至可能当你阅读本文时，它已经过时了，因此如果你想学习更多的知识，我强烈建议你去查阅引擎的官方文档。

**在 V8 的例子中， 上面那个管线演示图并不是最新的。**下面这个流程图显示的才是当前的管线。请注意，V8 团队始终致力于提升引擎性能，所以这张图不久之后可能也会变化。

![V8’s latest abstract compilation pipeline(2017) — Source: [V8 Presentation](https://docs.google.com/presentation/d/1chhN90uB8yPaIhx_h2M3lPyxPgdPmkADqSNAoXYQiVE/edit#slide=id.g18d89eb289_1_362)](https://cdn-images-1.medium.com/max/2000/1*qKBM3zUTK_lE3vu87vwdlg.png)

![V8’s latest compilation pipeline(2017) — Source: [V8 Presentation](https://docs.google.com/presentation/d/1_eLlVzcj94_G4r9j9d_Lj5HRKFnq6jgpuPJtnmIBs88/edit#slide=id.g2134da681e_0_125)](https://cdn-images-1.medium.com/max/2000/1*Da6ylguo0X6aIKW1v51YcQ.png)

如果你将上图与 2016 版的管线图对比，你会发现管线的基线（Baseline）部分完全被移除了，Crankshaft 也没有了。

#### 新版本管线的优势

V8 团队给出了很多更新管线的原因，以下是其中一部分：

* 减少内存占用 —— 在代码的体积上，Ignition 要比 full-codegen 小 8 倍。
* 优化启动时间 —— 字节码更简短，可以更快速地生成。
* 提升基线性能 —— 不再依赖编译器优化，就能提供**极其**高效的代码。

你可以在[这里](https://github.com/thlorenz/v8-perf/blob/master/compiler.md#advantages-over-old-pipeline)读到 V8 团队发布的更多内容。 

## V8 新功能开发

#### 无 JIT（JIT-less）模式

V8 甚至有一个无 JIT 模式，该模式中不会在运行时分配任何可执行内存。这个模式在 iOS、智能电视、游戏主机等无法写入可执行内存的平台上非常有用。

你可以在[这里](https://v8.dev/blog/jitless)读到更多信息。

#### 后台编译

在 Chrome 66 中，V8 使用一个后台线程来编译 JavaScript 源代码，借助后台线程编译代码时，常用网站上主线程编译时间能节省 5% 到 20%。

在官方博客的[这篇文章](https://v8.dev/blog/background-compilation)中可以看到更多内容。

---

我希望你对 JavaScript 引擎的概况已经有了较好的了解。祝您编程愉快！

**资料**

- [V8 Docs](https://v8.dev/)
- [A crash course in just-in-time (JIT) compilers by Lin Clark](https://hacks.mozilla.org/2017/02/a-crash-course-in-just-in-time-jit-compilers/)
- [Article by Sander](https://dev.to/sanderdebr/a-brief-explanation-of-the-javascript-engine-and-runtime-2idg)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
