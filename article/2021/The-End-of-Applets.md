> * 原文地址：[The End of Applets](https://js.plainenglish.io/6-css-properties-nobody-is-talking-about-e6cab5138d02)
> * 原文作者：[Erik-Costlow](https://www.infoq.com/profile/Erik-Costlow/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/The-End-of-Applets.md](https://github.com/xitu/gold-miner/blob/master/article/2021/The-End-of-Applets.md)
> * 译者：
> * 校对者：

# The End of Applets
Oracle is set to mark Applet APIs for removal in [JEP-398](https://openjdk.java.net/jeps/398). The demarcation follows multiple years of deprecation notices ([JEP-289](https://openjdk.java.net/jeps/289)) after all major browsers have removed support for the NPAPI plugin that powered Java Applets since the last millennium.

Java Applets originally powered Rich Internet Applications at a time when browsers had less power and fewer standards for developing applications. The capability for enabling Java applets was powered by the [Netscape Plugin Application Programming Interface](https://en.wikipedia.org/wiki/NPAPI) (NPAPI) to run sandboxed Java applications in the browser. NPAPI first appeared in browsers in 1995, long before the [incorporation of Mozilla](https://www-archive.mozilla.org/press/mozilla-2005-08-03.html) (2005) and the [first release of Chrome](https://en.wikipedia.org/wiki/Google_Chrome#Public_release) (2008).

Prior to modern browser standards, these applets were often used for activities like file transfers, authentication, and various other cases that JavaScript was unable to handle. Browsers began [removing support for NPAPI](https://blog.mozilla.org/futurereleases/2015/10/08/npapi-plugins-in-firefox/) in 2015 to simplify maintenance, operating in tandem with Oracle’s published whitepaper, "[Migrating from Java Applets to plugin-free Java technologies](https://www.oracle.com/technetwork/java/javase/migratingfromapplets-2872444.pdf)."

Although security had been a topic of interest related to Java applets prior to the 2015 API changes, many organizations were able to defend clients through management tools like [Deployment Rule Sets](https://blogs.oracle.com/java-platform-group/introducing-deployment-rule-sets) or locking Java/browser compatibility together in an [isolated Citrix environment](https://support.citrix.com/article/CTX200571).

While previous Java versions have marked Java applets as deprecated, the APIs were left in place to avoid compilation or runtime issues with applications that leveraged the APIs in some way even without not using the applet functionality. This feature, marking items as deprecated and delaying removal, was standard in Java and OpenJDK for about the first 20 years of the platform.

InfoQ spoke with [Dr. Deprecator](https://twitter.com/DrDeprecator), alter-ego of OpenJDK contributor Stuart Marks about how the OpenJDK project uses the @Deprecated tag to communicate and what has been deprecated.

Java 9 enhanced the [@Deprecated annotation](https://docs.oracle.com/en/java/javase/15/docs/api/java.base/java/lang/Deprecated.html) to add an attribute called forRemoval. Following the change in JEP-398, applet APIs will have the forRemoval=true attribute set, causing compilers and tools to emit stronger warnings before the APIs get actually removed. The passage through multiple warning gates helps avoid community code disruption, in line with language architect Brian Goetz' 2015 presentation, "[Move Deliberately and Don't Break Anything](https://www.youtube.com/watch?v=ibYrHlwCKB4)."

Other items that have been removed from the core Java APIs are:

- CORBA, [an interoperability framework](https://en.wikipedia.org/wiki/Common_Object_Request_Broker_Architecture) by the Object Management Group (OMG) from 1991 with its most recent release in 2012
- JAXB, the [set of XML APIs](https://eclipse-ee4j.github.io/jaxb-ri/) now maintained in Jakarta EE
- [Nashorn](https://www.infoq.com/news/2018/06/deprecate-nashorn/), a JavaScript execution engine
- Smaller changes like [Thread.stop(Throwable)](https://docs.oracle.com/javase/7/docs/technotes/guides/concurrency/threadPrimitiveDeprecation.html), [System.runFinalizersOnExit](https://bugs.openjdk.java.net/browse/JDK-8198250), and the [RMI Stub Compiler](https://bugs.openjdk.java.net/browse/JDK-8217412)

Users curious to see if this change will affect their application or any dependencies can leverage a combination of two tools on their code and its dependencies:

- [jdeps](https://docs.oracle.com/javase/9/tools/jdeps.htm#JSWOR690), a tool that analyzes use compatibility-endangering APIs. This can help a team understand if they use any non-spec APIs that are subject to change.
- [jdeprscan](https://docs.oracle.com/en/java/javase/15/docs/specs/man/jdeprscan.html), a utility for an analyzing code against the deprecation annotations to understand how it will be at risk if it does not adjust to the pending deprecation.

When asked if deprecation could be applied to Serialization, the applet-oriented SecurityManager, and other aspects, Deprecator replied simply, "[Hold my beer](https://twitter.com/DrDeprecator/status/1368359481684336640)," to indicate that change could be in the works.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。