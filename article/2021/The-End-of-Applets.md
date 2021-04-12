> * 原文地址：[The End of Applets](https://www.infoq.com/news/2021/03/end-of-applets)
> * 原文作者：[Erik-Costlow](https://www.infoq.com/profile/Erik-Costlow/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/The-End-of-Applets.md](https://github.com/xitu/gold-miner/blob/master/article/2021/The-End-of-Applets.md)
> * 译者：[5Reasons](https://github.com/5Reasons)
> * 校对者：[PassionPenguin](https://github.com/PassionPenguin)、[wumrwds](https://github.com/wumrwds)

# Applets 应用程序的终结

Oracle 在 [JEP-398](https://openjdk.java.net/jeps/398) 中将 Applet 相关的 API 标记为 “已弃用”。在进入 21 世纪后，所有的主流浏览器都不再支持 Java Applets 所依赖的 NPAPI 插件，在这样的背景下，Oracle 多年来一直都在发布即将弃用 Applets 的公告（[JEP-289](https://openjdk.java.net/jeps/289)）。

在若干年前浏览器的功能较弱、程序开发相关标准尚未完善的时候，Java Applets 就较早地做到了支持富互联网应用。支持 Java Applets 的能力是由 [网景插件应用程序接口](https://en.wikipedia.org/wiki/NPAPI)（简称 NPAPI）提供的，它能够在浏览器的沙盒环境下运行 Java 应用。NPAPI 第一次出现在浏览器中是在 1995 年，比 [Mozilla 基金会的成立](https://www-archive.mozilla.org/press/mozilla-2005-08-03.html) (2005) 和 [Chrome 的第一个版本](https://en.wikipedia.org/wiki/Google_Chrome#Public_release) (2008) 都要早得多。

在现代浏览器标准出现之前，这些 Applets 应用层序通常被用于文件传输、用户鉴权以及处理各种 Javascript 在当时无法处理的情况。各大浏览器在 2015 年开始 [移除对 NPAPI 的支持](https://blog.mozilla.org/futurereleases/2015/10/08/npapi-plugins-in-firefox/)，以此简化浏览器的维护工作，并和 Oracle 发布的关于 Applets 的一份白皮书文件：[从 Java Applet 迁移到无插件的 Java 技术](https://www.oracle.com/technetwork/java/javase/migratingfromapplets-2872444.pdf) 保持同步。

在 2015 年 API 的变化之前， Java Applet 应用的安全性就一直广为讨论，但许多组织能够通过使用管理工具 (例如：[部署规则集](https://blogs.oracle.com/java-platform-group/introducing-deployment-rule-sets)) 或者在一个孤立的 Citrix 环境中将 Java 和浏览器的兼容性锁定在一起来保护客户端。

尽管在之前的 Java 版本中就已经为 Java Applets 打上了已被弃用的标签，但相关的 API 仍被暂时保留了下来，以防一些没有实际使用相关 API 却仍旧调用了相关 API 的应用程序遭遇编译或运行错误。事实上，在 Java 和 OpenJDK 平台近 20 年的标准文档中，Applet 这一特性都被标注为“已弃用”和“将被移除”。

InfoQ 与 [Dr. Deprecator](https://twitter.com/DrDeprecator) 以及 OpenJDK 的贡献者 Stuart Marks 进行了交流，探访 OpenJDK 项目是怎么界定、使用 @Deprecated 标签的，并了解都有哪些 API 已经被弃用。

Java 9 增强了 [@Deprecated 弃用注解](https://docs.oracle.com/en/java/javase/15/docs/api/java.base/java/lang/Deprecated.html)，为其新增了 forRemoval 属性。随着 JEP-398 提出的改变，Applet API 将被设置为 `forRemoval = true`，在这些 API 被真正移除前，forRemoval 属性将让编译器和相关工具为开发者弹出更严重的警告。通过渐进式地设置多个警告可以有效的避免开发社区内的代码混乱，这秉承了语言架构师 Brian Goetz 在 2015 年的演讲 “[谨慎演进，避免破坏](https://www.youtube.com/watch?v=ibYrHlwCKB4)” 中所传达的思想。

已被从核心的 Java APIs 移除的其他项目包括：

- CORBA，[一个互操作式框架](https://en.wikipedia.org/wiki/Common_Object_Request_Broker_Architecture)，由对象管理组织 (OMG) 于 1991 年发布，其最新版本在 2012 年发布
- JAXB，[一个 XML 相关 API 的集合](https://eclipse-ee4j.github.io/jaxb-ri/)，现在被置于 Jakarta EE 库中进行维护
- [Nashorn](https://www.infoq.com/news/2018/06/deprecate-nashorn/)，一个 JavaScript 执行引擎
- 一些小变化，例如 [Thread.stop(Throwable)](https://docs.oracle.com/javase/7/docs/technotes/guides/concurrency/threadPrimitiveDeprecation.html), [System.runFinalizersOnExit](https://bugs.openjdk.java.net/browse/JDK-8198250), 以及 [RMI Stub Compiler](https://bugs.openjdk.java.net/browse/JDK-8217412)

如果想知道上述改变是否会影响到他们的应用程序或者依赖，用户们可以尝试在代码和依赖中使用这两个工具：

- [jdeps](https://docs.oracle.com/javase/9/tools/jdeps.htm#JSWOR690)，这是一个能分析是否使用了有不兼容风险的 API 的工具。它可以帮助开发团队排查项目中是否使用了已经发生改变的、不规范的 API
- [jdeprscan](https://docs.oracle.com/en/java/javase/15/docs/specs/man/jdeprscan.html)，这是一个能够分析 @Deprecated 弃用注解的工具，它会分析如果不对已弃用的 API 进行调整的话，项目会面临怎样的风险

当被问及 Applet 的弃用是否可以应用于序列化、Applet 安全管理器和一些其他方面时，相关提案者简单地回答道:“[等着瞧吧（Hold my beer）](https://twitter.com/DrDeprecator/status/1368359481684336640)”，这暗示着相关的更改可能已经正在进行了。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
