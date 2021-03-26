> - 原文地址：[Why Java Is so Young After 25 Years: An Architect’s Point of View](https://dzone.com/articles/why-java-is-so-young-after-25-years-an-architects)
> - 原文作者：Dr.Magesh Kasthuri 
> - 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> - 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/why-java-is-so-young-after-25-years-an-architects.md](https://github.com/xitu/gold-miner/blob/master/article/2021/why-java-is-so-young-after-25-years-an-architects.md)
> - 译者：[keepmovingljzy](https://github.com/keepmovingljzy)
> - 校对者：[wumrwds](https://github.com/wumrwds)

# 为什么 Java 在 25 年之后依旧如此年轻：一个架构师的看法

Java 已经走过 25 年的编程时光，依然与开发者保持着紧密的联系；即使是现在，全球开发者社区中仍有 69% 的人使用 Java 编写代码。Oracle 最近发布了 Java 15，其中包含了大量的特性，比如密闭类，隐藏类，Edward-Curve 数字签名算法（EdDSA），文本块等等。这使得 Java 15 成为一门 25 岁的“年轻”编程语言，而不是一门 25 岁的“年迈”编程语言。

## Java 的历史和演变

在 1990 年代初期，有数十种非常稳定的编程语言，像 FORTRAN, COBOL, Pascal, C++, and Visual Basic，许多平台像 Windows, Mac, Unix, Linux 和移动端平台需要一种在程序开发和架构设计中统一的方法。James Gosling 和他的朋友在他的办公室附近的一颗橡树（Oak）下讨论了这些方面的问题，他们觉得应该开发一种新的编程语言来解决这些差异。在开发一种名为 *Oak* 的新语言时，他们在基础方面非常挑剔，这个语言当时被命名为 *Green*（因为这个团队名字叫 Green），后来又被命名为 *Java* （基于他们最喜欢印尼咖啡叫做 Java 咖啡）。

James Gosling 在 1995 年引入了 Java，在那期间还有其他的语言 C，C++，VC++，Visual Basic, Python 都有自己的市场和开发人员，部署。Java 提出了 WORA（一次编写，到处运行）的概念, 简单性，面向对象编程，并消除了 C++ 的所有痛点。最重要的是带有 Applet 支持的 Web 编程以及 Enrich UI 设计（抽象窗口工具包）。

由于其简单性，它吸引了更多的开发人员，并在 1998-2001 年间成为所有开发人员在国际公司（美国，英国）工作的“通行证”。但是同时在 2001 期间 Dotcom 减少了大量工作岗位，为 Java 增加新的开发人员。然而，在后面的阶段，在 RMI 之上使用 JSP、Servlet 和中间层体系架构 EJB，在 Web 编程中引入更多的特性，会给 JAVA 的企业应用空间带来更多的思考。为了进入移动应用领域，Java 还引入了移动编程，从而引入了J2ME。由此，Java 提出了 J2SE，J2ME 和 J2EE。

但是他们都使用 CORE-JAVA 作为基础语言。Java 也和 IBM 合作开发了 Java Sound Library；Java Media Framework 与 Java 运行时结合在一起，未来通过 IBM 使用 Voice 进行语音合成对于媒体和教育领域的人们来说是另一个了不起的里程碑。随着时间的推移，Java 增加了开发人员的数量，同时引入了 JUG。Java Bug 追踪和 Bug 报告都做的很好。

由于其简单而强大，更多的部署，随后几年的增长是显著的，并且将市场上的 C++, VC++, Visual Basic 淘汰了，在开发者社区中领先了 5-6 年，它甚至将 Python 语言搁置一旁，并带了了诸如 JavaScript Web 编程（在 CSS+HTML 之上的动态支持）之类的功能。Java 具有大量的变种功能，并且可以与新引入的 GO，RUBY，SCALA 等竞争，并且也能占领自己的市场。

## Java 基石

Green 团队在 Java 编程语言的初始化概念过程中规划的基本面使得 Java 编程语言的基本模块是：

- 构建一种简单的，面向对象的语言，这对于 C++ 程序员来说很容易。
- 平台无关并且架构无关。
- 高性能与许多内存特性以及通过命令行参数进行性能调优。
- 多线程，动态，解释执行。
- 安全性和强大的功能。

![https://dzone.com/storage/temp/14528883-1615809981546.png](https://dzone.com/storage/temp/14528883-1615809981546.png)

*图：Java 的历史和发展时间轴*

有了这些正确且强大的基本块，Java 在采用现代编程语言中的新变化时，比如 Lambda 表达式，Switch 表达式和密闭类等仍然没有做任何妥协。因此许多新的编程框架，包括 Hadoop 和许多大数据框架，云功能将 Java 用作原生工具。这就是为什么在 25 年后，Java 仍然在与 Scala，Go 和 Python 等新时代的编程语言斗争。

## 从 Sun 到 Oracle 公司的转型

Sun 公司已被 Oracle 收购，因此他们从 2010 年开始接管 Java。Oracle 已经将 Java 的版本控制从 1-2 年提高到 6 个月一次。这导致了巨大的变化和新功能的增加。Java 8 是吸引开发者并重新占领市场份额的非凡版本之一。即使 Oracle 公司引入了 Java 14，对于所有开发人员来说，仍旧使用着更加稳定的 J2SE 1.8 版本来维持他们的部署

![https://dzone.com/storage/temp/14528887-1615810017570.png](https://dzone.com/storage/temp/14528887-1615810017570.png)

*图：Java 框架的热图*

在 Oracle 接管 Java 之后，人们开始考虑开源的思想过程，并从太阳公司的 J2SE（OpenJDK）和 Oracle 公司的 J2EE JAKARTA Eclipse community foundation 项目的名义开始支持 J2EE 开放。

Java 已在所有领域广泛使用，无论是制造业，零售业，银行业还是电信业，Java 语言都是必不可少的，每个开发人员都应了解 Java。因此，它在全球范围内的行业中创造了更多的机会。在 2006-2013 年期间，Oracle 公司遇到了困难。 但是，在 Oracle 接管Java之后，这种速度或开发/部署已被彻底消除。Sun Microsystems 召开了Java ONE 会议，每次发布都会进行全球性的技术讨论，有关 Java 的整个新生事物（新功能，未来的 JSR）将与更多的技术受众进行讨论和辩论。

正如我们所讨论的，Java 在微控制器和微空间项目中也有一席之地。Java 带来的重点和转变之一是 Java 嵌入式系统特性，该特性处理使用网络远程管理装置和设备。我觉得这是最近几天引入物联网（IoT）的基础，但早在 2006-2010 年的时候，Java就已经考虑过了。

Oracle 带来的第一个重大变化是以两种形式发布 Java：

1. Java 的开发平台称为 OpenJDK。
2. 企业使用的商业平台称为 Oracle Java。

## 基于 Java 平台的框架

作为 Java 的简介，您可以自由地在世界上看到更多语言，例如 GO，Python，Ruby，PERL 等，以及它们的市场空间。Java 已用于客户端层或两层应用程序（Applet，JavaScript），服务器层（JSP，Servlet），中间层（EJB）和 N层（EMAIL，JNDI，JDBC 等）。它还可以帮助 Sun 公司和 Oracle 在 Java 增长期间增加他们的开发人员和贡献者。Java 已在 Spring，Hibernate 等第三方框架中大量使用，并启用了跨数据库和动态/运行时依赖项注入功能。

除此之外，随着下一代编程语言的转变，单体世界也转变为微服务世界，为商业和市场带来更多的稳定性、可伸缩性和敏捷性。Java 在所有基于 SpringBoot 的微服务容器中都得到了使用，并再次获得了一组顶级程序员、经过验证的部署，等等。我忘了提到另一个特性，即所谓的多语言支持，其中 Java 支持 UNICODE 以支持跨语言（国际）支持。Java 在大数据、aim 领域的应用非常广泛，有更多的用例、解决方案和部署。Java 也将其转变指向基于云的平台部署，因此，通过满足热门市场需求，也使得更多的开发人员能够在 Java 中贡献和工作。

Java 被广泛应用和集成到各个领域、技术、工具集，提高了 Java 的利用率，从空间、卫星研究到制造、教育、银行、金融、移动、云等。Java 已经成功的与以下第三方工具和技术集成。Java 对 AI、ML、Cloud 等进行了更广泛的集成，在性能上得到了稳定、持续的提升。25 年来，Java 一直被 Python、C++、Scala、GO、Erlang 等各种语言所忽视。尽管如此，Java仍然是第一名，它拥有更多的社区成员和稳定的部署以及大量的用例。

Java 与其他第三方框架的集成，从 Hibernate 到 Struts，直到现在，SpringBoot 微服务框架也被全球采用和部署。与响应式编程语言相比，响应式 Java 变得更加流行，并提供了更多的选项。这些集成将 Java 带到了编程领域的下一个层次，性能和稳定性是 Java 成功特性的关键部分。Oracle 公司也在他们的版本中宣布了很多新的变化；不再是每两年发布一次 Java，而是每 6 个月发布一次。此外，还添加了一个新网站来查看即将到来的项目或到目前为止完成的任务的特性。伴随着 25 年 Java 历程的成功里程碑，还有一些重要的里程碑，比如 JDK8 获得了巨大的部署量等等。就这个特性而言，开发人员可能希望 JVM 能有更快的速度和性能改进，以及容错能力，以处理大量的并发用例。

## Java 平台最近面临的困境

当 Sun 拥有 Java 时，还有其他 Java 运行时环境，Java 中的增强已经完成，特别是 IBM 引入了 IBM Java（它也有一些有趣的特性）。突然之间，Sun 公司公司对微软提起诉讼，称微软垄断 IE 浏览器，并使用 JRE 来反对 Sun 公司的许可要求。Sun 已经赢得了与微软的官司，最近 Oracle 也推出了谷歌套件，在他们的移动 android 平台上使用Java。

## 快速查看最新的 Java 15 版本

Oracle Java 版本基于 JDK 企业提案（JEP）和 Java 规范请求（JSR），而 EdDSA 是 JEP 339 的一种实现。它是采用约 126 位加密算法的独立于平台的加密签名。这可以用于具有更高安全性的数据传输处理，以传输加密的数据。Java 15 中引入的密闭类是 JEP 360 的实现，它限制了哪些类可以扩展或实现密闭类。例如：

```java
public abstract sealed class Shape      
    permits Circle, Rectangle, Square {...}
```

使 Shape 成为密闭类，并且仅允许“permits”类实现/扩展。这样可以安全地访问类层次结构，并控制接口的可重用性。
隐藏类基于 JEP 371 的实现，它通过允许在运行时使用反射 API 生成类来限制类的使用，并使该类对外部环境不可发现。因此，无法通过动态代理生成隐藏类，并且可以安全地访问它们。

ZGC 或 Z 垃圾收集器是基于 JEP 377 的。在 Java 1.8 的早期版本中，G1 GC 是自我管理垃圾收集的突破，并极大地提高了性能。后来在 Java 11中，ZGC 引入了各种性能改进特性，现在在 Java 15 中，它得到了进一步的改进，如取消提交未使用的内存、多线程堆、并发的类卸载等等。

JEP 378 引入的文本块特性可以创建以自动化转义序列格式存储的多行字符串字面量，并以一种可预测的方式格式化字符串，同时改进了字符串字面量的内存使用情况。这样可以有效地在 Java 代码中将 XML，JSON 和 HTML 代码段作为字符串字面量进行存储。
外部内存访问 API 是一个 JEP 383 实现，它允许程序有效地访问已分配的 Java堆之外的外部内存。它最初是作为一个预览版本在Java 14中引入的，现在改进的版本作为 Java 15 的一部分发布了。这个 API 允许通过添加一段像`MemorySegment.allocateNative(100)`这样的代码来快速分配本机内存段。

## 总结

官方[发行日志](https://web.archive.org/web/20070310235103/http:/www.sun.com/smi/Press/sunflash/1996-01/sunflash.960123.10561.xml)提到第一个 Java 官方版本于 1996 年 1 月首次发布，使 Java 完成了其 25 年的历程，如上面的时间表所示。我们认为，与 Java 相比，从台式机，移动设备，企业开发到现代云和大数据开发领域，计算机历史上没有其他编程语言可以经受得住。 许多人说，像 GoLang，Python，Javascript 框架这样的新编程结构将使 Java 很快死亡，但是 Java 15 中引入了许多功能，这似乎是一个强有力的回应，Java 仍然是开发者社区“走的更远”的选择。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

------

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
