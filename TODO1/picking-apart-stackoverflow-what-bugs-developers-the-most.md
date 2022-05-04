> * 原文地址：[Picking Apart Stack Overflow; What Bugs Developers The Most?](https://www.globalapptesting.com/blog/picking-apart-stackoverflow-what-bugs-developers-the-most)
> * 原文作者：[Nick Roberts](https://www.globalapptesting.com/blog/picking-apart-stackoverflow-what-bugs-developers-the-most)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/picking-apart-stackoverflow-what-bugs-developers-the-most.md](https://github.com/xitu/gold-miner/blob/master/TODO1/picking-apart-stackoverflow-what-bugs-developers-the-most.md)
> * 译者：[whatbeg](https://github.com/whatbeg)
> * 校对者：[Endone](https://github.com/Endone), [JalanJiang](https://github.com/JalanJiang)

# 剖析 Stack Overflow，开发者遇到最多的 Bug 是哪些？

Stack Overflow 自 2008 年成立以来，一直在迅速拯救各种类型的开发者。从那时起，开发者在所有开发领域中提出了数以百万计的不同问题。

但是是哪些**类型**的问题使得开发者被迫转向 [Stack Overflow](https://www.stackoverflow.com) 求助呢？

我们挑选了 11 种最流行的编程语言（通过 Stack Overflow 标签的频率来衡量），并进行了一项研究，试图揭示这些问题中的一些共性和差异。

但是在我们开始研究之前，让我们先仔细看看我们选择的 11 种语言，如下所示。

[![JavaScript 是整个 StackOverflow 最常被问及的语言。](https://www.globalapptesting.com/hubfs/_all_languages_bar_chart-min.png)](https://www.globalapptesting.com/hubfs/_all_languages_bar_chart-min.png)

就问题的原始数量而言，自 Stack Overflow 成立以来，JavaScript 一直是最常被问及的语言。这可能是由于 JavaScripts 在众多不同的应用程序和服务中都有运用：不管你以何种方式接触并使用互联网，你可能都需要了解一点 JavaScript。

但是，虽然 JavaScript **总体上**可能是第一，但当我们将数据分开时，我们会看到一个新的需求顶峰。

[![Python 将在 2019 年取代 JavaScript 称为最常被问及的语言。](https://www.globalapptesting.com/hubfs/javascript_python_timeline-min.png)](https://www.globalapptesting.com/hubfs/javascript_python_timeline-min.png)

2011 年[哈佛商业评论](https://hbr.org/2012/10/data-scientist-the-sexiest-job-of-the-21st-century)将数据科学家称为“21 世纪最性感的工作”。从那时起，Python — 数据科学家的首选语言之一 — 已经越来越受欢迎......以至于在 2019 年它已经取代了 JavaScript，成为 StackOverflows 最常被问及的编程语言。

（要么 Python 正在迅速成为最流行的编程语言，要么只是 Python 比其他语言拥有更大比例的新晋开发者！）

![](https://play.vidyard.com/5SPXJ1gky2WeF3gYUXKwUx.jpg)

但这些开发者**究竟**要问的是什么？最常被问及的框架、包、函数和方法是什么？哪种数据类型最让开发人员感到痛苦？各种语言间这些问题有何不同？

为此，我们：

1. 为上面列出的 11 种编程语言中的每种语言提取了 1000 个最受欢迎的 Stack Overflow 问题。
2. 在 Python 中做了一些数据清理（自然地使用 Pandas）
3. 将这 11000 个问题（超过 96000 个单词）整合到一个 JavaScript 词云算法中，以便于我们对不同语言中的难点痛点有一个整体的了解。

结果如下。

### JavaScript

[![StackOverflow 上提到最多的 JavaScript 用词。](https://www.globalapptesting.com/hubfs/_javascript-min.png)](https://www.globalapptesting.com/hubfs/_javascript-min.png)

JavaScript 已经诞生了 23 年；而 Stack Overflow 才 11 年。在这 11 年中，“**jquery**”（中左）是迄今为止最常被问及的 JavaScript 框架。

### Python

[![StackOverflow 上提到最多的 Python 用词。](https://www.globalapptesting.com/hubfs/_python-min.png)](https://www.globalapptesting.com/hubfs/_python-min.png)

Python 实际上比 JavaScript 早诞生 6 年。首先出现在 1990 年，[Guido van Rossum](https://gvanrossum.github.io/) 的创意让其变成了数据科学家的首选语言之一。当然，它最常见的一些痛点在于数据处理库：“**pandas**”（中左）和 “**dataframe**”（中上部）就在其中。


然而，Python 是一种通用的管道-胶水式语言，它涉及到许多不同的技术领域，这解释了为何 Web 开发框架 “**django**”（中下部）相对频繁地被问及。

### R

[![StackOverflow 上提到最多的 R 用词。](https://www.globalapptesting.com/hubfs/r-min.png)](https://www.globalapptesting.com/hubfs/r-min.png)

也许是数据科学家选择的第二种语言，R 与 Python 的不同之处在于它几乎是专门用于此目的的。一些数据处理特定的概念，如 “**dataframe**”（右上角）、“**datatable**”（右上角）和 “**matrix**”（中间）似乎让 R 用户感到头疼。

Python 和 R 都有出色的数据操作库，尽管在数据**可视化**方面，有些人认为 R 比 Python 更具优势。说到这里，数据可视化库 “**ggplot**”（中心）是迄今为止 R 语言中最常被问及的概念。

所以也许 Python 用户发现 matplotlib 更容易掌握！

### Ruby

[![StackOverflow 上提到最多的 Ruby 用词。](https://www.globalapptesting.com/hubfs/_ruby-min.png)](https://www.globalapptesting.com/hubfs/_ruby-min.png)

Ruby 最早出现在 90 年代中期，现在它找到了一个服务器端框架 ruby-on-“**rails**”（右上角）作为归宿。

### C#

[![StackOverflow 上提到最多的 C# 用词。](https://www.globalapptesting.com/hubfs/c-sharp-min.png)](https://www.globalapptesting.com/hubfs/c-sharp-min.png)

C#（C Sharp，2000）主要是由微软为其 .NET 框架（“**net**”，中右）开发的。

### C++

[![StackOverflow 上提到最多的 C++ 用词。](https://www.globalapptesting.com/hubfs/c++-min.png)](https://www.globalapptesting.com/hubfs/c++-min.png)

C++（1985）已经成为视频游戏开发者的首选语言。三维视频游戏的基本视觉构建块是多边形，多边形的基本构建块是“**矢量**”（中右）。

### Java

[![StackOverflow 上提到最多的 Java 用词。](https://www.globalapptesting.com/hubfs/java-min-1.png)](https://www.globalapptesting.com/hubfs/java-min.png)

Java（1995）被创建为通用的“一次编写随地运行”的语言。它在 90 年代末和万维网早期的 PC 繁荣时期变得流行，是许多 Windows 应用程序背后的驱动力。

但最近它在 “**Android**”（中右）应用程序开发中找到了归宿。

### Objective-C

[![StackOverflow 上提到最多的 Objective-C 用词。](https://www.globalapptesting.com/hubfs/objective-c-min.png)](https://cdn2.hubspot.net/hubfs/540930/objective-c-min.png)

在这项研究中，最古老的语言是 Objective-C（1984），它是苹果公司在 OSX 操作系统上支持的主要语言，直到最近引入 Swift 之前，它还是支持 “**iPhone**”（中间）上的 “**iOS**”（左下角）应用程序的主要语言。

### Swift

[![StackOverflow 上提到最多的 Swift 用词。](https://www.globalapptesting.com/hubfs/swift-min.png)](https://www.globalapptesting.com/hubfs/swift-min.png)

Swift 于 2014 年首次亮相，在苹果开发领域取代了 Objective-C，尽管标记为 #swift 的 Stack Overflow 问题中提到 “**objective-c**”（中右）的频率可能代表了成千上万的 iOS 开发人员希望通过 Stack Overflow 来更新他们的知识。

### PHP

[![StackOverflow 上提到最多的 PHP 用词。](https://www.globalapptesting.com/hubfs/php-min.png)](https://www.globalapptesting.com/hubfs/php-min.png)

PHP（1995）被设计为用于 Web 开发的服务器端脚本语言。今天，它仍然用于这个目的，你可以在围绕 “**laravel**” 框架（中左）的问题频率中看到这一点的证据。

### SQL

[![StackOverflow 上提到最多的 SQL 用词。](https://www.globalapptesting.com/hubfs/sql-min.png)](https://www.globalapptesting.com/hubfs/sql-min.png)

SQL 并不像本研究中的其他语言那样是一种功能齐全的编程语言；它是专门为一项工作设计的：数据操作。由于这种特殊性，SQL 最常见的症结就在于数据库的访问：“**sever**”、“**mysql**”、“**database**”、“**query**”、“**select**”。

* * *

每一种编程语言都是面向或甚至是**专为**一个特定技术场景而准备的。R 是数据科学，Swift 是 iOS 开发，C++ 是视频游戏开发。这就解释了出现的问题类型的一些差异。这也解释了为什么我们在 SQL 中看到 “**database**” 是一个常被问及的概念，而不是在其他语言中，例如，Objective-C。

尽管存在这些明显的差异，但这些可视化表明不同领域内的一些基本相似之处。底层的数据类型，如字符串和数组（但显然**不是**整数、浮点数或布尔值）是经常出现的痛点，这会导致所有层级和信仰的开发人员转向动手操作键盘打开 Stack Overflow。

本着团结的精神，这里有一个词云，表示我们提取的**所有 11000 个**问题：

[![StackOverflow 上 12000 个热门问题中提到最多的单词。](https://www.globalapptesting.com/hubfs/_all_langauges-min.png)](https://www.globalapptesting.com/hubfs/_all_langauges-min.png)

谷歌可以帮助解决一些问题......

......但对于其他的一切，我们有 Stack Overflow。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
