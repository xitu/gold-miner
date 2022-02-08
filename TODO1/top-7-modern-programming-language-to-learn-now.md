> * 原文地址：[Top 7 Modern programming languages to learn now](https://towardsdatascience.com/top-7-modern-programming-language-to-learn-now-156863bd1eec)
> * 原文作者：[Md Kamaruzzaman](https://medium.com/@md.kamaruzzaman)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/top-7-modern-programming-language-to-learn-now.md](https://github.com/xitu/gold-miner/blob/master/TODO1/top-7-modern-programming-language-to-learn-now.md)
> * 译者：[lihaobhsfer](https://github.com/lihaobhsfer)
> * 校对者：[impactCn](https://github.com/impactCn)、[司徒公子](https://github.com/stuchilde)

# 现在就该学习的 7 门现代编程语言

> 来看看 Rust、Go、Kotlin、TypeScript、Swift、Dart、Julia 能如何促进你的职业生涯发展，提升你的软件开发技能

![图片来自于 [Unsplash](https://unsplash.com/s/photos/future?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) 作者 [h heyerlein](https://unsplash.com/@heyerlein?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)](https://cdn-images-1.medium.com/max/6000/1*sY77VQEyI1Dbm_RnO0bxIA.jpeg)

如果我们把人类现代文明比做一辆车，那么软件开发行业就像汽车的发动机，编程语言就像发动机的燃料。**你该学习哪门编程语言呢**？

学习一门新的编程语言需要投入大量**时间、精力和脑力**。但是，就如我在另一篇文章中所写，学习一门新的编程语言能够提升你的编程技能，加速你的职业发展
[**2020 年学一门新的编程语言的五大理由**](https://medium.com/@md.kamaruzzaman/5-reasons-to-learn-a-new-programming-language-in-2020-bfc9a4b9a763)


一般来讲，我们需要选择一门对你职业发展有益的编程语言。与此同时，我们也需要选择受欢迎程度正在上升的语言。这意味着你应该选择较成熟的、广受好评的语言来学习。

我很尊敬主流编程语言。但在这篇文章中我将推荐给你**一系列能够提高生产力、助你升职加薪、成为更优秀的开发者的现代编程语言**。同时，我会涉及到**许多领域：系统编程、app 开发、web 开发、科学计算**。

![](https://cdn-images-1.medium.com/max/2000/1*Jzzxrhl0uGWD1USctYOzyg.jpeg)

**现代编程语言**这一术语定义比较模糊。许多人认为如 Python、JavaScript 这样的语言是现代编程语言，认为 Java 是比较老的语言。而实际上，他们问世的时间都在 1995 年前后。

多数主流编程语言都是在上个世纪开发的，主要在**七十年代（例如 C 语言）、八十年代（如 C++）和九十年代（如 Java、Python 和 JavaScript）**。这些语言的设计方式，不能很好利用现代软件开发的生态系统：**多核 CPU、GPU、高速网络、移动设备、容器和云端**。尽管它们中的很多语言都有**诸如并发一类的改进特性**，并在不断适应新时代，但是他们也需要向下兼容，因此无法抛弃老旧过时的特性。

在这一方面，Python 在 Python 2 和 Python 3 之间就划分得很清楚，做得很好（或者很差，这取决于上下文）。这些语言**通常提供 10 种方式来做同样的事情，这对开发者很不友好**根据 StackOverflow 上的一个调查，主流的比较老的编程语言在 **最令人望而生畏的编程语言** 中都位居前列：

![来源：[Stackoverflow](https://insights.stackoverflow.com/survey/2019#most-loved-dreaded-and-wanted)](https://cdn-images-1.medium.com/max/2000/1*ohNTSynK0hp_v73Y_aEl2A.jpeg)

我认为老编程语言和新的编程语言的界限可以定在 **2007 年 6 月 29 日**，第一代 iPhone 的发布日。在那之后，整个科技产业前景都改变了。我将主要讨论 **2007 年以后的编程语言**。

![](https://cdn-images-1.medium.com/max/2000/1*vcX14UokG4fZNdORE4_Q6A.jpeg)

首先，**现代编程语言开发出来是为了最大化利用现代计算机硬件（多核 CPU、GPU、TPU）、移动设备、大数据、高速互联网、容器和云端的优势**。并且，多数现代编程语言对开发者更加友好，提供了大量如下特性：

* 代码简洁（模板代码更少）
* 原生支持并发
* 空指针安全
* 类型推断
* 特性更精简
* 较低的认知负荷
* 融合所有编程范式的最佳特性

其次，本榜单中的许多编程语言是**颠覆性的，将永远改变软件行业**。他们中有些已经是主流编程语言，而另一些则有望取得突破。至少作为第二编程语言来学习这些语言是明智的。

在之前发表的文章《关于 2020 年软件开发趋势的 20 项预测》中，我预测了 2020 年会有很多现代编程语言取得突破：[**关于 2020 年软件开发趋势的 20 项预测**](https://towardsdatascience.com/20-predictions-about-software-development-trends-in-2020-afb8b110d9a0)

---

## Rust

![图片来源：[Thoughtram](https://thoughtram.io/rust-and-nickel/#/11)](https://cdn-images-1.medium.com/max/2406/1*fr1Gjc_bt6gB06fUlfQNPQ.jpeg)

系统编程语言领域被非常接近硬件层的 C 和 C++ 霸占。它们让你全权控制程序和硬件，但缺少内存安全。就算它们支持并发，用 C 或者 C++ 写并发程序也因没有并发安全而非常困难。其他编程语言是如 Java、Python 和 Haskell 这样的解释型语言。它们安全，但是需要的运行时间很长、或者依赖虚拟机。过长的运行时间使得像 Java 这样的语言不适合系统编程。

**不乏想要结合 C 或 C++ 的强大功能和 Java、Haskell 的安全性的尝试**。Rust 或许是首个成功做到这一点的生产级编程语言。

**Graydon Hoare** 起初仅仅将 Rust 作为业余项目开发。他受到用于科研的编程语言 **Cyclone** 的启发。Rust 是开源的，Mozilla 与许多其他公司和社区一起领导 Rust 语言的开发。Rust 在 2015 年首次亮相，并迅速受到社区的关注。在之前一篇文章中，我更加深入地探讨了 Rust 并指出为何在大数据领域它比 C++ 和 Java 更好：
[**回归硬件：2019 年用于开发大数据框架最好的 3 门编程语言**](https://towardsdatascience.com/back-to-the-metal-top-3-programming-language-to-develop-big-data-frameworks-in-2019-69a44a36a842)


**关键特性**：

* 通过**所有权与借出**的概念提供内存安全、线程安全
* **编译时确保内存安全和线程安全**，比如，如果一段程序成功编译，那它就是既内存安全又没有数据竞争。这是 Rust 最吸引人的特性。
* 它也像 ML、Haskell 一样有很强的表达性。有了不可变的数据结构和函数式编程特性，Rust 提供函数并发和数据并发。
* Rust 相当快。根据 [**Benchmark Game**](https://benchmarksgame-team.pages.debian.net/benchmarksgame/fastest/rust-gpp.html)，一些常见场景下 Rust 性能比 C++ 更好
* 由于不需要运行时环境，Rust 提供对现代硬件（TPU、GPU、多核 CPU）的完全控制
* Rust 支持 **LLVM**。因此 Rust 和 **WebAssembly** 有上乘的互操作性，让网页应用的代码高速运行。

**受欢迎程度：**

自 2015 年问世以来，Rust 就被广大开发者接受，并在 StackOverflow 开发者调查中**连续四年**（2016-2019）被选为最受喜爱的语言：

![来源：[Stackoverflow](https://insights.stackoverflow.com/survey/2019#most-loved-dreaded-and-wanted)](https://cdn-images-1.medium.com/max/2000/1*JQSUr9o0igYb22h_RnYTlA.jpeg)

根据 Github Octoverse，Rust 是增长第二快的编程语言，仅次于 Dart：

![来源：[Octoverse](https://octoverse.github.com/)](https://cdn-images-1.medium.com/max/2000/1*gwjGGcibFfZhUZSJKqpT-A.jpeg)

并且，Rust 在编程语言排名网站 PyPl 排在第 18 名，并呈上升趋势。

![来源：[PyPl](http://pypl.github.io/PYPL.html)](https://cdn-images-1.medium.com/max/2000/1*evWgcSuw1qfOb9wpr3ckqQ.jpeg)

看看它提供的特性，难怪像**微软、亚马逊、谷歌**那些科技公司巨头都发布声明，会将 Rust 作为长期系统编程语言进行投资。

谷歌趋势显示，过去五年里，Rust 获得的关注持续增长：

![来源：谷歌趋势](https://cdn-images-1.medium.com/max/2302/1*0gKyrINweN2dGDD_gj8EVw.jpeg)

**主要使用场景：**

* 系统编程
* 无服务器计算
* 商业应用

**主要竞争语言：**

* C
* C++
* Go
* Swift

## Go

![来源：维基百科](https://cdn-images-1.medium.com/max/7722/1*7kbd-tVk3co-9RiilFN1TA.png)

谷歌是最大的互联网公司之一。在本世纪初，谷歌面临着两个规模化问题：**开发规模和应用规模**。开发规模的意思是他们不能够再简单地通过增加开发人员来添加更多新特性。应用规模的意思是他们无法简单地开发一个能够扩大到“谷歌级”计算机集群的规模的应用。2007 年前后，谷歌提出了一个新的“**务实的**”编程语言，以解决这两个规模化的问题。在 **Rob Pike** （UTF-8） 和 **Ken Thompson** (UNIX 系统)，他们拥有全世界两个最具天赋的软件工程师来开发一门新语言。

2012年，谷歌发布了 **Go** 语言的第一个官方版本。Go 是一个系统编程语言，但是和 Rust 不同。它有运行时环境和垃圾回收（几 Mb 大）。但是不像 Java 和 Python，这个运行时环境是打包在生成的代码里的。最后，Go 生成一个可以在机器上无需依赖或者运行时环境的原生二进制代码。

**关键特性：**

* Go 有顶级的并发支持。它不通过线程和锁提供“**共享内存**”并发，因为这更难编写。相反，它提供**基于 CSP 的消息传递并发**（根据 **Tony Hoare** 的论文）。Go 使用 “**Goroutine**”（轻量的安全线程）和“**频道**”来实现消息传递。
* Go 的杀手锏特性是它非常简洁。它是最简单的系统编程语言。一个新手软件开发者可以像用 Python 一样在几天内写出高效率的代码。几个最大的云原生项目（**Kubernetes、Docker**）就是用 Go 写的。
* Go 也有内置的垃圾回收机制，开发者无需像在使用 C 或 C++ 时一样担心内存管理。
* 谷歌在 Go 上投入巨大。因此，Go 拥有庞大的工具支持。对于新手 Go 开发者而言，有一个庞大的工具生态。
* 通常，开发者花百分之二十的时间写新代码，而百分之八十的时间是在维护已有代码。Go 的简单性、使它在维护方面非常出色。现在，Go 在商业应用中被广泛使用。

**受欢迎程度：**

从 Go 首次问世以来，软件开发社区就对它敞开怀抱。在 2009 年（在它发布不久后）和 2018 年，根据 [**TIOBE 指数**](https://www.tiobe.com/tiobe-index/)，Go 都进入了**编程语言名人堂**名单。Go 的成功为如 Rust 一样的新一代编程语言铺路，也不足为奇。

Go 已经是一个主流编程语言。最近，Go 团队对外宣布了他们在 **Go 2** 上的进展，这使得这门语言更加坚挺。

在几乎所有编程语言对比网站上，Go 都排名靠前并且超过了很多语言。在 2019 年 12 月的 **TIOBE 指数** 排名中 Go 排在第 15 位：

![来源：TIOBE](https://cdn-images-1.medium.com/max/2328/1*4otADyzXwAXDqCjbiJnszw.jpeg)

根据 StackOverflow 调查，Go 是最受欢迎的十大编程语言之一：

![来源：[Stackoverflow](https://insights.stackoverflow.com/survey/2019#most-loved-dreaded-and-wanted)](https://cdn-images-1.medium.com/max/2000/1*AlZjgpQhANe7uJ_pJMQmdQ.jpeg)

根据GitHub Octoverse，Go 也是发展最快的十大编程语言之一：

![来源：[Octoverse](https://octoverse.github.com/)](https://cdn-images-1.medium.com/max/2000/1*avYTdU-SuMxL3qMufe9Xag.jpeg)

谷歌趋势也显示，Go 在过去五年中受关注程度在上升：

![来源：谷歌趋势](https://cdn-images-1.medium.com/max/2312/1*Dm_Tfz6rQKYHP14woSpd7A.jpeg)

**主要应用场景：**

* 系统编程
* 无服务器计算
* 商业应用
* 云原生开发

**主要竞争语言：**

* C
* C++
* Rust
* Python
* Java

## Kotlin

![](https://cdn-images-1.medium.com/max/2400/1*6MRnGxzKEA7tPJz-0fKLBQ.png)

Java 企业级软件开发无可争议的霸主。近期，Java 受到了不少批评：代码量大，需要写很多模板代码，容易一不留神就发现程序过于复杂。然而，没有谁对 **Java 虚拟机**（JVM）评头论足。JVM 是软件工程界的一项佳作，是经历了行业战场和时间双重历练的运行时环境。在一篇文章中，我详细讨论了 JVM 的优势：
[**统治数据密集型（大数据 + 高速数据流）框架的编程语言**](https://towardsdatascience.com/programming-language-that-rules-the-data-intensive-big-data-fast-data-frameworks-6cd7d5f754b0)


近几年来，像 **Scala** 运行在 JVM 环境中的语言，试着解决 Java 的短板，想要成为更好的 Java，却以失败告终。不过最后，从 Kotlin 之中可以看出，似乎对一个更好的 Java 的寻找可以告一段落了。Jet Brains（开发 IntelliJ 这款热门 IDE 的公司）开发了 Kotlin，它运行在 JVM 上，并提供很多现代特性。最好的一点是，不像 Scala，**Kotlin** 比 Java 精简很多，并且能够在 JVM 平台上提供像 Go 和 Python 一样的开发效率。

谷歌宣布将 Kotlin 作为开发**安卓**系统的首选语言，提升了 Kotlin 在社区中的接纳程度。并且，热门 Java **企业级框架 Spring** 也从 2017 年开始在 Spring 生态中支持 Kotlin。我配合响应式 Spring 使用过 Kotlin，体验相当不错。

**主要特性：**

* Kotlin 的独特卖点是它的语言设计。因其代码简洁，我一直视 Kotlin 为 JVM 上的 Go 或 Python。因此，Kotlin 生产力很强。
* 与其他很多现代语言一样，Kotlin 提供空指针安全，类型推断等特性。
* 由于 Kotlin 也在 JVM 上运行，你可以使用已有的 Java 库的庞大生态。
* Kotlin 是开发安卓应用的首选编程语言，并已经超过 Java 成为最广泛使用的安卓开发语言。
* Kotlin 由 JetBrains 和开源社区支持，因此，Kotlin 拥有出色的工具支持。
* 有两个有趣的项目： **Kotlin Native**（可将 Kotlin 编译为原生代码）和 **Kotlin.js**（将 Kotlin 转为 JavaScript）。如果它们成功，Kotlin 便可以在 JVM 外使用。
* Kotlin 也提供简单的方式来编写 **DSL**（Domain Specific Language，领域专用语言，与通用编程语言相对）

**受欢迎程度：**

从 2015 年首次发布以来，Kotlin 的火热程度直线上升。在 StackOverflow 上，Kotlin 在 2019 年人们最爱的编程语言中位列第四：

![来源：[Stackoverflow](https://insights.stackoverflow.com/survey/2019#most-loved-dreaded-and-wanted)](https://cdn-images-1.medium.com/max/2000/1*PmUb6Ozt9Cngh0IA9DCpAg.jpeg)

Kotlin 也是上升最快的编程语言之一，在其中同样位列第四：

![来源：Github Octoverse](https://cdn-images-1.medium.com/max/2000/1*P03_CPbYksuJzpdFxGiulA.jpeg)

PyPl 上，Kotlin 在最火编程语言中排名 12 位，且有**很高的上升趋势**：

![来源：[Pypl](http://pypl.github.io/PYPL.html)](https://cdn-images-1.medium.com/max/2000/1*YKOiuBgCDHSKU4TQBbYbXw.jpeg)

由于谷歌宣布了将 Kotlin 作为安卓应用开发首选语言，Kotlin 在谷歌趋势中有积极上涨。

![来源：谷歌趋势](https://cdn-images-1.medium.com/max/2308/1*ZqVPhJii9fxTTZZ_Pj3HZA.jpeg)

**主要应用场景：**

* 企业级应用
* 安卓应用开发

**主要竞争语言：**

* Java
* Scala
* Python
* Go

## TypeScript

![](https://cdn-images-1.medium.com/max/2000/1*TpbxEQy4ckB-g31PwUQPlg.png)

JavaScript 是一门优秀的语言，但 2015 以前的 JavaScript 有不少缺点。连著名软件工程师 **Douglas Crockford** 都写了一本书《**JavaScript 语言精粹**》并指出 JavaScript 有**糟糕之处**。不支持模块化，加上“回调地狱”，开发者尤其不愿意维护那些大型的 JavaScript 项目。

谷歌甚至开发了一个将 Java 代码转为 JavaScript 的平台（**GWT**）。很多公司或个人尝试开发更好的 JavaScript，如**Coffee Script、Flow、ClojureScript**，但是来自微软的 **TypeScript** 夺得头魁。微软的一个工程师团队，在著名的 **Anders Hejlsberg**（Delphi、Turbo Pascal、C# 的发明者）的带领下，开发了 TypeScript，作为一种静态类型、模块化的 JavaScript 超集。

TypeScript 会在编译时转为 JavaScript。在 2014 年首次发布后，它很快获得了社区的关注。谷歌当时也在计划开发一个提供静态类型检查的 JavaScript 的超集。谷歌被 TypeScript 惊艳，从而由策划开发一门新语言转为与微软合作来改进 TypeScript。

谷歌将 TypeScript 作为它 SPA 框架 **Angular2** 的主要编程语言。同样，热门 SPA 框架 **React** 也提供 TypeScript 支持。另一热门 JavaScript 框架 Vue.js 也宣布在新的 **Vue.js 3** 中使用 TypeScript 开发。

![来源：[Vue.js Roadmap](https://github.com/vuejs/roadmap)](https://cdn-images-1.medium.com/max/2278/1*8Kaj35gc8dr3FmdlnmN6_A.jpeg)

并且，Node.js 的创造者 **Ryan Dahl** 决定使用 TypeScript 来开发一款安全的 **Node.js** 替代品，**Deno**。

**关键特性：**

* 像本名单中的 Go 和 Kotlin，TypeScript 的重要特性就是语言设计。它清晰而简洁的代码，使之成为**最优雅的编程语言之一**。至于开发者生产力，它与 Kotlin、Go、Python并驾齐驱。TypeScript 是最具生产力的 JavaScript 超集。
* TypeScript 是强类型的 JavaScript 超集。它非常适合大型项目，不负“可规模化的 JavaScript” 的美誉。
* 单页应用程序框架“三巨头”（**Angular、React、Vue.js**）都提供优秀的 TypeScript 支持。在 Angular 中，TypeScript 是建议使用的语言。在其他两个框架中，TypeScript 也逐渐流行起来。
* 科技公司的两个巨头：**微软和谷歌**正在合作，与活跃的开源社区一起开发 TypeScript。因此，TypeScript 的工具支持在最优行列之中。
* 由于 TypeScript 是 JavaScript 的超集，JavaScript 能在哪运行，它就能在哪运行 —— 也就是任何地方。TypeScript 可以运行在**浏览器、服务器、移动设备、物联网设备和云端**。

**受欢迎程度：**

开发者因 TypeScript 优雅的语言设计而热爱它。在 StackOverflow 开发者调查中，它与 Python 在最受喜爱的编程语言榜单上并列第二：

![来源：[Stackoverflow](https://insights.stackoverflow.com/survey/2019#most-loved-dreaded-and-wanted)](https://cdn-images-1.medium.com/max/2000/1*t6wkuoA1IdPg9ncsg4bLBQ.jpeg)

TypeScript 是上升最快的语言之一，在 GitHub Octoverse 上位列第五：

![来源：[Octoverse](https://octoverse.github.com/)](https://cdn-images-1.medium.com/max/2000/1*JTRjZ8ZBee5T-cfcH64Jtg.jpeg)

TypeScript 在 GitHub 贡献上位列前十（第七名）：

![来源：[Octoverse](https://octoverse.github.com/)](https://cdn-images-1.medium.com/max/2046/1*Ad7zxTCZGSzt4ioC0ylf5A.jpeg)

TypeScript 每年都吸引更多的眼球，在谷歌趋势上就有所体现：

![来源：谷歌趋势](https://cdn-images-1.medium.com/max/2308/1*STnhuXU-ZRMw2Bc3O6pV7w.jpeg)

**主要应用场景：**

* Web 用户界面开发
* 服务端开发

**主要竞争语言：**

* JavaScript
* Dart

## Swift

![](https://cdn-images-1.medium.com/max/2400/1*OVgSA8lppCUu7idWMgMMyw.png)

**史蒂夫·乔布斯**拒绝在 iOS 平台上支持 **Java**（和 JVM），并曾引用过一句著名的话：Java 再也不是一个主流编程语言。我们现在知道他对 Java 的评价是错的，然而 iOS 还是没有支持 Java。相反，苹果选择用 **Objective-C** 作为 iOS 平台的首选语言。Objective-C 想要精通很难。并且，它的开发者高生产力的支持也不够好，达不到现代编程语言的要求。

在苹果，**Chris Lattner** 等人开发了 **Swift**，作为一个多范式、通用编译编程语言，作为 Objective-C 的备选项。Swift 的首个稳定版本发布于 2014 年。Swift 也支持 **LLVM** 编译器工具链（同样由**Chris Lattner**）开发。Swift 可以很好地与 Objective-C 代码共存，并且已经成功确立了 iOS 平台应用首选开发语言的地位。

**主要特性：**

* Swift 的一个杀手锏就是它的语言设计。通过更简洁的语法，它比 Objective-C 更高效。
* Swift 也支持现代编程语言的特性，如空值安全。并且，它提供语法糖来避免缩进过多的问题。
* 作为一门编译语言，Swift 和 C++ 一样快。
* Swift 支持 LLVM 编译器工具链。因此，我们可以将 Swift 用于服务端编程，甚至是浏览器编程（借助 WebAssembly）。
* Swift 支持**自动引用计数（ARC）**，由此控制了内存管理不当的问题。

**受欢迎程度：**

像其他很多现代编程语言一样，开发者也喜爱 Swift 编程语言。根据 StackOverflow 调查，Swift 在最受喜爱编程语言中排名第六位：

![](https://cdn-images-1.medium.com/max/2000/1*BxHjlXZ_UfQSNbnVY0F7nQ.jpeg)

在 TIOBE 编程语言排名中，Swift 在 2019 年排在第十。考虑到这门语言多么年轻（只有 5 年），这已经很优秀了：

![来源：TIOBE 指数](https://cdn-images-1.medium.com/max/2332/1*wO5MgevW6NqQ0ujfNqMBZw.jpeg)

谷歌趋势也显示了 Swift 迅猛的上升趋势，不过近些日子有些下降：

![来源：谷歌趋势](https://cdn-images-1.medium.com/max/2298/1*EO-TFNeitbEz_T4I3pRoIw.jpeg)

**主要使用场景：**

* iOS 应用开发
* 系统编程
* 客户端开发（通过 WebAssembly）

**主要竞争语言：**

* Objective-C
* Rust
* Go

## Dart

![](https://cdn-images-1.medium.com/max/5300/1*QCajckOeBhRaLzi0RoFqig.png)

**Dart** 是本榜单中谷歌开发的第二个语言。谷歌是 Web 和 Android 领域的关键参与者，因此它在这些领域开发了自己的编程语言不足为奇。由著名丹麦软件工程师 **Lars Bak**（带领了 Chrome 浏览器的 V8 JavaScript 引擎）带领，谷歌在 2013 年发布了 Dart。

Dart 是一门通用编程语言，支持强类型和面向对象编程。Dart 也可以被转为 JavaScript，并在 JavaScript 的运行环境中运行 —— 几乎任何地方（网页、移动端、服务器）。

**主要特性**

* 像谷歌的另外一门语言 Go，Dart 也非常专注于开发者生产效率。Dart 因其简洁精炼的语法而具有很强的生产力，并受到开发者的喜爱。
* Dart 也提供强类型和面向对象编程，Dart 也是本榜单中可以戴上“**可规模化的 JavaScript**” 标签的第二个语言。
* Dart 是为数不多支持 **JIT 编译**（在运行时进行编译）和 **AOT 编译**（在创建时编译）的语言。因此 Dart 可以针对 JavaScript 运行时环境（V8 引擎），也可以（通过 AOT 编译）编译成高速的原生代码。
* **跨平台原生应用开发平台 Flutter** 选择了 Dart 作为其开发语言，来开发 iOS 和安卓应用。从那以后，Dart 就变得越来越流行。
* 像 Go 一样，Dart 也有完善的工具支持，以及 Flutter 的庞大生态。随着 **Flutter** 越来越火，Dart 很快会被更多人接受。

**受欢迎程度**

根据 GitHub Octoverse， Dart 是 **2019 年增长最快的编程语言，其受欢迎程度在过去一年中涨了五倍**：

![](https://cdn-images-1.medium.com/max/2000/1*4yH5ZWzBmI9MJXAdNWkqyw.jpeg)

根据 TIOBE 指数，Dart 排在第 23 位，并在短短四年中超过了其他很多已有的现代编程语言：

![来源：TIOBE 指数](https://cdn-images-1.medium.com/max/2324/1*mct61ZNxjiZuLa40tdOKTg.jpeg)

它也是最受喜爱的编程语言之一，在 StackOverflow 开发者调查中排名第 12 位：

![来源：StackOverflow](https://cdn-images-1.medium.com/max/2000/1*X9_wQ80-LQWgDJ2AMLchSA.jpeg)

根据谷歌趋势，和 Flutter 一起，Dart 在近两年也获得了很多的关注：

![来源：谷歌趋势](https://cdn-images-1.medium.com/max/2310/1*HMfM_TSQmmpbKxqFiUHfYA.jpeg)

**主要使用场景：**

* 应用开发
* 用户界面开发

**主要竞争语言：**

* JavaScript
* TypeScript

## Julia

![](https://cdn-images-1.medium.com/max/2400/1*claL_4fuNqq9ZO8F5RkYqA.png)

本榜单中多数编程语言都由大公司开发，Julia 除外。在**技术型计算**中，通常使用 **Python、Matlab** 这样的动态语言。这些语言提供易用的语法，但是不适于大型的技术运算。人们通常使用 C 或 C++ 的库来进行 CPU 密集型任务，由此导致了**双语言问题**，因为他们需要**胶水代码**来绑定两个语言。由于代码需要在两种语言之间翻译，就会有性能损失。

为了解决这一问题，一群 MIT 的研究人员计划从头开发一门新的语言，能够利用现代硬件，并且结合其他语言的优点。他们在 MIT 创新实验室，在下图中的宣言的指导下工作：

![来源：[Julia 展示](https://genome.sph.umich.edu/w/images/3/3e/Julia_presentation.pdf)](https://cdn-images-1.medium.com/max/2756/1*sqvWUec74Co1DpySnbQihg.jpeg)（图片译文：……我们想要一门开源、拥有自由协议的语言。我们想要它有 C 一样的速度，和 Ruby 一样的动态性。我们想要它具有[同像性](https://zh.wikipedia.org/wiki/%E5%90%8C%E5%83%8F%E6%80%A7)，像 Lisp 一样有真正的宏，但是也像 Matlab 一样有显而易见的、熟悉的数学标记。我们想要它和 Python 一样可以用于通用编程，和 R 一样对统计学友好，有像 Perl 一样自然的字符串处理，在线性代数上像 Matlab 一样强大，像 shell 脚本一样长于将程序粘合在一起。（我们想要）一个极易学习、却又能让那些硬核黑客开心的语言。我们让它可以交互，还想让它是编译语言。）

Julia 是**动态的高级编程语言**，提供顶尖的**并发、并行及分布式计算**支持。Julia 的首个稳定版本在 **2018** 年发布，并很快受到了社区和产业界的关注。Julia 可以用于科学计算、人工智能以及很多其他领域，并可以解决**双语言**问题。

**特性：**

* 和 Rust 一样，Julia 的关键特性是其语言设计。它尝试在不损失性能的同时，将已有的高性能的、可用于科学计算的语言的优秀特性结合在一起。到现在为止，它做得很好。
* Julia 是动态编程语言，可选类型支持。因此，Julia 是一个易于学习、高生产效率的编程语言。
* 它的核心使用了**多调度**编程范式。
* 它内置支持**并发、并行、分布式计算**。
* 它对于读写密集型任务也提供**异步读写**。
* 它**相当快**，并且可以用于需要百万级线程的科学计算。

**受欢迎程度：**

Julia 主要和 Python 在多个领域竞争。由于 Python 是当下最流行的编程语言，Julia 需要几年时间才会成为主流。

Julia 相对更年轻（只有一年），但是仍能在 TIOBE 上排名第 43 位：

![来源：TIOBE](https://cdn-images-1.medium.com/max/2356/1*hL8eYaOW8yUpCzZDUPZXSA.jpeg)

谷歌趋势也显示了近年来稳定的关注。

![](https://cdn-images-1.medium.com/max/2306/1*nIsvOaYZdfAYgcbuEiN32g.jpeg)

考虑到它的特性集，以及诸如**NSF（美国科学基金会）、DARPA（美国国防部高级研究计划局）、NASA（美国航天局）、英特尔**这些背后支持 Julia 的组织和公司，Julia 取得突破也只是时间问题，而不是能否的问题。

**主要使用场景：**

* 科学计算
* 高性能计算
* 数据科学
* 可视化

**主要竞争语言：**

* Python
* Matlab

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
