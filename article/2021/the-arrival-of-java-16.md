> * 原文地址：[The Arrival of Java 16](https://blogs.oracle.com/java-platform-group/the-arrival-of-java-16)
> * 原文作者：[Sharat Chander](https://blogs.oracle.com/author/sharat-chander)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/the-arrival-of-java-16.md](https://github.com/xitu/gold-miner/blob/master/article/2021/the-arrival-of-java-16.md)
> * 译者：[Hoarfroster](https://github.com/PassionPenguin)
> * 校对者：

# Java 16 发布啦

![](https://cdn.app.compendium.com/uploads/user/e7c690e8-6ff9-102a-ac6d-e4aebca50425/ed5569e8-c0dd-458c-8450-cde6300093bd/File/a5023b0f0fb67f59176a0499af9021ed/java_horz_clr.png)

在我们庆祝 Java 成立 [25 周年之际](https://www.oracle.com/java/moved-by-java/)，2020 年对于 Java 来说是值得纪念的一年。经过了 20 多年的创新，Java 一直是：

* 通过适应不断变化的技术格局而保持平台独立性，从而具有灵活性。
* 通过保持向后兼容性来保证可靠性。
* 通过在不牺牲安全性的情况下加速创新来表现。

加上 Java 不断提高平台性能，稳定性和安全性的能力，它仍然是开发者中世界上最受欢迎的编程语言。根据 IDC 的最新报告 [Java Turns 25](https://www.oracle.com/a/ocom/resources/java-turns-25.pdf)，超过 900 万名开发者（占全球全职开发者的 69％）使用 Java —— 比任何其他语言都多。

Oracle 进一步展示了 Java 的持续创新之路，并自豪地宣布 Java 16 的全面 Release，这是六个月紧张开发中的第七个功能版本的 Release。源源不断的预期变化让开发者可以更轻松地管理他们对创新建议的采纳。

![](https://cdn.app.compendium.com/uploads/user/e7c690e8-6ff9-102a-ac6d-e4aebca50425/ed5569e8-c0dd-458c-8450-cde6300093bd/Image/1b71450b94c7e38e2ca7981ba45246f4/features_in_java16.png)

## Java 16 现在可用了！

Oracle 现在[为所有开发者和企业](https://www.oracle.com/news/announcement/oracle-announces-java-16-031621.html)正式提供 [Java 16](https://www.oracle.com/news/announcement/oracle-announces-java-16-031621.html)。根据 [Oracle 关键补丁更新（CPU，Critical Patch Update）时间表](https://www.oracle.com/technetwork/topics/security/alerts-086861.html)，Oracle JDK 16 将至少获得两个季度的更新，然后我们会再发布 Oracle JDK 17。Java 17 将在 2021 年 9 月实现全面可用性，但是早已在 [jdk.java.net](https://jdk.java.net/) 网站上提供了[构建版本](https://jdk.java.net/17/)。

Oracle 再次使用开源 GPLv2 协议 和 CPE 协议将 Java 16 作为 [Oracle OpenJDK 版本](https://jdk.java.net/15/)[](https://oracle.com/javadownload)向大家提供，并且对于使用 Oracle JDK 版本作为 Oracle 产品或服务，或针对那些希望能够获得商业支持的人的那一部分的用户，也获得了[商业许可](https://oracle.com/javadownload)。

**Java 16，Together**

与以前的发行版相似，我们将继续感谢 OpenJDK 社区中许多个人和组织对 Java 16 所做的贡献 —— 我们共同构建了 Java！

**JDK 16 固定开发率**

JDK 的总体变化率多年来一直保持基本恒定，但是在六个月的紧张开发节奏下，交付可用于生产的产品的速度已大大提高。

我们不再每隔几年在大型主要版本中发布成千上万的修复程序和大约一百个 JDK 增强建议（JEP），而是选择以更易于管理且可预测的六个月计划，在较小的 Feature 版本中提供增强功能。这些更改的范围从重要功能到小的增强功能，到例行维护，错误修复和文档改进。对于 [JDK Bug 系统中](https://bugs.openjdk.java.net/secure/Dashboard.jspa)的每一个问题和更改，我们都以单个提交的形式呈现。

在 Java 16
中标记为已解决的 [1,897 个](https://bugs.openjdk.java.net/issues/?jql=project%20%3D%20JDK%20AND%20fixVersion%20%3D%2016%20AND%20resolution%20%3D%20Fixed%20AND%20%28comment%20~%20%22URL%3A%20http%3A%2F%2Fhg.openjdk.java.net%22%20OR%20comment%20~%20%22URL%3A%20https%3A%2F%2Fhg.openjdk.java.net%22%20OR%20comment%20~%20%22URL%3A%20https%3A%2F%2Fgit.openjdk.java.net%2F%22%29%20AND%20%28labels%20not%20in%20%28hgupdate-sync%29%20OR%20labels%20is%20EMPTY%29%20%20ORDER%20BY%20updated%20DESC%2C%20assignee%20ASC)问题中，有 [1,397](https://bugs.openjdk.java.net/browse/JDK-8246707?jql=project%20%3D%20JDK%20AND%20fixVersion%20%3D%2016%20AND%20resolution%20%3D%20Fixed%20AND%20%28comment%20~%20%22URL%3A%20http%3A%2F%2Fhg.openjdk.java.net%22%20OR%20comment%20~%20%22URL%3A%20https%3A%2F%2Fhg.openjdk.java.net%22%20OR%20comment%20~%20%22URL%3A%20https%3A%2F%2Fgit.openjdk.java.net%2F%22%29%20%20AND%20%28labels%20not%20in%20%28hgupdate-sync%29%20OR%20labels%20is%20EMPTY%29%20AND%20assignee%20in%20membersOf%28oracle-employees%29%20ORDER%20BY%20updated%20DESC%2C%20assignee%20ASC)
个由 Oracle 工作人员解决了，而另外的 [500](https://bugs.openjdk.java.net/browse/JDK-8257574?jql=project%20%3D%20JDK%20AND%20fixVersion%20%3D%2016%20AND%20resolution%20%3D%20Fixed%20AND%20(comment%20~%20%22URL%3A%20http%3A%2F%2Fhg.openjdk.java.net%22%20OR%20comment%20~%20%22URL%3A%20https%3A%2F%2Fhg.openjdk.java.net%22%20%20OR%20comment%20~%20%22URL%3A%20https%3A%2F%2Fgit.openjdk.java.net%2F%22)%20%20AND%20(labels%20not%20in%20(hgupdate-sync)%20OR%20labels%20is%20EMPTY)%20AND%20assignee%20not%20in%20%20membersOf(oracle-employees)%20ORDER%20BY%20updated%20DESC%2C%20assignee%20ASC) 个则由个人开发者和为其他组织工作的开发者解决。仔细研究这些问题并整理来自受让人的组织数据，将得到以下组织结构图。该组织结构图由助力 Java 16 中的修补程序的开发的人员构成：

![](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/515b6bd1c2b3439b883b450c9af979d0~tplv-k3u1fbpfcp-zoom-1.image)

Oracle 感谢在 ARM、SAP、Red Hat 和腾讯等组织工作的开发者所做的杰出贡献。我们也很高兴看到较小的组织（例如 Ampere Computing、Bellsoft、DataDog、Microdoc 和其他独立开发者）的贡献，他们共同贡献了Java 16 中 3％ 的修复程序。

我们同样感谢众多经验丰富的开发者，他们审查了提议的更改，尝试采用早期访问版本并报告问题的早期采用者，以及在OpenJDK邮件列表中提供反馈的敬业专业人员。

以下人员提供了有关构建质量的宝贵反馈，记录了高质量的错误或提供了频繁的更新：

* Jaikiran Pai (Apache Ant)
* Gary Gregory (Apache Commons)
* Uwe Schindler (Apache Lucene)
* Robert Scholte (Apache Maven)
* Mark Thomas (Apache Tomcat)
* Enrico Olivelli (Apache Zookeeper)
* Rafale Winterhalter (Byte Buddy)
* Peter Karich (Graph Hopper)
* Evgeny Yavits (JaCoCo)
* Marc Hoffman (JaCoCo)
* Vincent Privat (JOSM)
* Christain Stein (JUnit 5)
* David Karnok (RxJava)

此外，通过 [质量拓展](https://wiki.openjdk.java.net/display/quality/Quality+Outreach)计划，我们要感谢以下 FOSS 项目和个人，他们为测试 Java 16 早期访问版本提供了出色的反馈，以帮助提高发行版的质量。

* Apache Ant
* Apache Derby (Rich Hillegas)
* Apache Lucene
* Apache Maven
* Apache Tomcat
* Apache Wicket (Martin Grigorov)
* Apache ZooKeeper
* Eclipse Collections (Nikhil Nanivadekar)
* eo-yaml (Mihai Andronache)
* FXGL (Almas Baimagambetov)
* FXyz (Sean Phillips)
* Java Katas (Chandra Guntur)
* GraphHopper
* Hibernate ORM
* Hibernate Validator
* Hibernate Search
* Hibernate Reactive (Sanne Grinovero & Yoann Rodiere)
* JobRunr (Ronald Dehuysser)
* jOOQ (Lukas Eder)
* MyBatis (Iwao Ave)
* Micrometer (Tommy Ludwig)
* RxJava
* Sejda
* PDFsam (Andrea Vacondio)

**Java 16 的新功能**

伴随着数千个性能、稳定性和安全性上的更新，Java 16 为用户提供了共计 [17 项主要的增强、更改](https://openjdk.java.net/projects/jdk/16/)（称为 [JDK 增强建议，JEP](https://openjdk.java.net/jeps/1)），包括三个孵化器模块和一个预览功能。

我们在[孵化器模块](https://openjdk.java.net/jeps/11)中引入了一些增强功能，这是一种将非最终 API 和非最终工具交付给开发者的方法，允许用户提供反馈，从而最终改善 Java 平台的质量。

同样，引入了一些增强功能，它们是 Java SE 平台的[预览功能](https://openjdk.java.net/jeps/12)、语言或 VM 功能，这些功能已完全确定、完全实现但不是永久性的。我们在 JDK 功能版本中提供了这些功能，以激发开发者根据实际使用情况提供的反馈，这可能影响它们，让它们在以后的版本中成为永久性功能。这种方法为用户提供了及时提供反馈的机会，并且使工具供应商有机会在大量 Java 开发者在生产中使用该功能之前为其提供支持。

Java 16 随附的 17 个 JEP 共分为六个不同类别：

**1. 新语言功能**

**[JEP 394](https://openjdk.java.net/jeps/394) Pattern Matching 的 instanceof**

Pattern Matching 首次在 [Java 14 中](https://openjdk.java.net/jeps/305)作为预览功能引入，在 [Java 15 中](https://openjdk.java.net/jeps/375)我们又将其作为预览功能引入。Pattern Matching 通过对 instanceof 运算符进行模式匹配来增强 Java 编程语言的功能。

模式匹配使程序中的通用逻辑（即从对象中有条件地提取组件）得以更简洁，更安全地表示。

**[JEP 395](https://openjdk.java.net/jeps/395) Records**

Record 也是在 [Java 14](https://openjdk.java.net/jeps/359) 和 [Java 15](https://openjdk.java.net/jeps/384) 中作为预览功能引入的，提供了一种紧凑的语法来声明类。这些类是浅层不可变数据的透明的 holder，*大大减少这些类的详细程度，并提高代码的可读性和可维护性。*

**2. JVM 的改进**

**[JEP 376](https://openjdk.java.net/jeps/376) ZGC 并发线程处理**

JEP 376 将 ZGC 线程堆栈处理从安全点移至并发阶段。我们即使在大型堆上，也可以在 GC 安全点内实现亚毫秒级的暂停。在此版本及其后续版本中，消除 ZGC 垃圾收集器中最终的延迟源将极大地提高应用程序的性能和效率。

**[JEP 387](https://openjdk.java.net/jeps/387) Elastic Metaspace**

此功能可以更迅速地将未使用的 HotSpot VM 类元数据（即 *metaspace*）内存返回给操作系统，从而减少了 metaspace 的占用空间。具有大量加载和卸载活动的应用程序可能会占用大量未使用的空间。

新方案以较小的块分配元空间内存，减少了类加载器的开销和碎片。它通过将未使用的元空间内存返回给操作系统来提高弹性，从而提高应用程序性能并降低内存利用率。

**3. 新工具和库**

**[JEP 380](https://openjdk.java.net/jeps/380) Unix-Domain Socket Channels**

Unix-Domain Socket Channels 一直是大多数 Unix 平台的功能，而现在我们在 Windows 10 和 Windows Server 2019 中实现了这个功能。此功能为 java.nio.channels 包中的 Socket 和服务器 Socket API 添加了 Unix 域（AF_UNIX）Socket 支持。它扩展了继承的通道机制，以支持 Unix 域 Socket 通道和服务器 Socket 通道。Unix 域 Socket 用于同一主机上的进程间通信（IPC），在大多数方面与 TCP-IP 套接字类似，不同之处在于它们是通过文件系统路径名而不是 Internet 协议（IP）地址和端口号来寻址的。对于本地进程间通信，Unix Socket 比 TCP-IP 环回连接更安全，更有效。

**[JEP 392](https://openjdk.java.net/jeps/392) 打包工具**

此功能最初是在 [Java 14 中](https://openjdk.java.net/jeps/343)作为孵化器模块引入的，允许打包独立的 Java 应用程序。它支持本地打包格式，以为最终用户提供自然的安装体验。这些格式包括 Windows 上的 msi 和 exe，macOS 上的 pkg 和 dmg 以及 Linux 上的 deb 和 rpm。它还允许在打包时指定启动时参数，并且可以从命令行直接调用，也可以通过 ToolProvider API 以编程方式调用。请注意，jpackage 模块的名称从 jdk.incubator.jpackage 更改为 jdk.jpackage。这将改善最终用户在安装应用程序时的体验，并使用“应用程序商店”模型简化部署。

**4. 对工作进行未来验证**

**[JEP 390](https://openjdk.java.net/jeps/390) 基于值的类的警告**

此功能将原始包装器类（java.lang.Integer、java.lang.Double 等）指定为*基于值的*（类似于 java.util.Optional 和 java.time.LocalDateTime），并将 forRemoval 添加到其构造函数。它们自 JDK 9 起不推荐使用，提示新的警告。它提供有关在 Java 平台中不正确尝试在任何基于值的类的实例上进行同步的警告。

许多流行的开源项目已经通过从其源中删除打包构造函数调用来响应 Java 9 的过时警告，并且鉴于“不建议过时删除”警告的紧急性，我们可以期望更多的这样做。

**[JEP 396](https://openjdk.java.net/jeps/396) 默认情况下强封装 JDK 内部**

默认情况下，此功能会强封装了 JDK 的所有内部元素，但关键内部 API 除外，例如 sun.misc.Unsafe。在默认情况下，使用早期版本成功编译的访问 JDK 内部 API 的代码可能不再起作用。此更改旨在鼓励开发者从使用内部元素迁移到使用标准 API，以便他们及其用户都可以轻松升级到将来的 Java 版本。对于 JDK 9，强启动由启动器选项 -–illegal-access 开启，而 JDK 15 则作为默认设置，JDK 9-15 会是*警告*，而从 JDK 16 开始则默认为 *拒绝*。我们（暂时）仍然可以使用单个命令行选项放宽对所有软件包的封装，将来只有使用 –add-opens 打开特定的软件包才有效。

**5.孵化器和预览功能**

**[JEP 338](https://openjdk.java.net/jeps/338) 矢量 API（孵化器）**

该孵化器 API 提供了 API 的初始迭代，以表达向量计算，该向量计算在运行时可靠地编译为支持的 CPU 架构上的最佳向量硬件指令，从而实现了优于等效标量计算的性能。它允许利用大多数现代 CPU 上可用的单指令多数据（SIMD）指令。尽管 HotSpot 支持自动矢量化，但是可变换的标量操作集受到限制，并且易受代码更改的影响。该 API 将使开发者可以轻松地用 Java 编写可移植的高性能矢量算法。

**[JEP 389](https://openjdk.java.net/jeps/389 ) 外部链接 API（孵化器）**

该孵化器 API 提供了对本地代码的静态类型的纯Java访问。此 API 将大大简化绑定到本机库的原本繁琐且容易出错的过程。Java 从 Java 1.1 开始就支持通过 Java 本机接口（JNI）进行本机方法调用，但是它用起来又困难又脆弱。Java 开发者应该能够（大部分）仅使用对特定任务有用的任何本机库。它还提供了外来功能支持，而无需任何中间的 JNI 粘合代码。

**[JEP 393](https://openjdk.java.net/jeps/393) 外部内存访问 API（3 次孵化器）**

首次在 Java 14 和 Java 15 中作为孵化器API引入，此 API 使 Java 程序可以安全有效地对各种外部存储器（例如，本机存储器、PMEP、托管堆存储器等）进行操作。它还为外部链接程序 API 提供了基础。

**[JEP 397](https://openjdk.java.net/jeps/397) 密封的类（第 2 次预览）**

此预览功能限制了哪些其他类或接口可以扩展或实现它们。它允许类或接口的作者控制负责实现该代码的代码。而且，它提供了比访问修饰符更声明性的方式来限制超类的使用。并且它通过对模式进行详尽的分析来支持模式匹配的未来方向。

**6. 提高 OpenJDK 开发者的生产率**

*其余更改对 Java 开发者（使用 Java 编写代码和运行应用程序的人员）不直接可见，而只对 Java 开发者（进行 OpenJDK 开发的人员）可见。*

**[JEP 347](https://openjdk.java.net/jeps/347) 启用 C++ 14 语言功能（在 JDK 源代码中）**

这允许在 JDK C++ 源代码中使用 C++ 14 语言功能，并提供有关 HotSpot 代码中可以使用哪些功能的特定指南。在 JDK 15 中，JDK 中 C++ 代码使用的语言功能限于 C++ 98/03 语言标准。这个功能要求更新各种平台编译器的最低可接受版本。

**[JEP 357](https://openjdk.java.net/jeps/357) 从 Mercurial 迁移到 Git  
[JEP 369](https://openjdk.java.net/jeps/369) 迁移到 GitHub**

这两个 JEP 将 OpenJDK 社区的源代码存储库的 JDK 11 及更高版本从 Mercurial（hg）迁移到 Git，并将它们托管在 GitHub 上。迁移包括将工具（例如 jcheck、webrev 和 defpath 工具）更新到 Git。Git 减小了元数据的大小（约为原大小的四分之一），从而节省了本地磁盘空间并减少了克隆时间。与 Mercurial 相比，现代工具可以更好地与 Git 集成。OpenJDK Git 存储库现在位于 [https://github.com/openjdk](https://github.com/openjdk)

**[JEP 386](https://openjdk.java.net/jeps/386) Alphine Linux Port**

**[JEP 388](https://openjdk.java.net/jeps/388) Windows / AArch64 Port**

这些 JEP 的重点不是已经完成的移植工作本身，而是将它们集成到 JDK 主线存储库中。

JEP 386 将 JDK 移植到使用 musl 作为其主要 C 库的 Alpine Linux 和其他发行版 x64 和 AArch64 上。此外，JEP 388 将 JDK 移植到 Windows AArch 64（ARM64）上。

**7. 工具支持**

当前的工具支持有助于提高开发者的生产力。使用 Java 16，我们将继续欢迎领先的 IDE 开发者所做的努力，这些开发者的工具解决方案为开发者提供了对当前 Java 版本的支持。开发者可以期望通过以下 IDE 获得 Java 16 支持：

* JetBrains [IDEA](https://blog.jetbrains.com/idea/2021/03/java-16-and-intellij-idea/)
* Eclipse [Market](https://marketplace.eclipse.org/content/java-16-support-eclipse-2021-03-419)

Java 仍然是软件程序员选择的第一大编程语言。正如 Java 16 的按时交付那些改进所表明的那样，通过持续的深思熟虑的计划和生态系统的参与，Java 平台已做好了在云中进行现代开发和增长的良好定位。

通过以下方式继续关注新闻和更新：

* 访问 [Inside.Java](https://inside.java/)（Oracle Java 团队的新闻和观点）
* 收听 [Inside.Java 播客](https://inside.java/podcast/)（这是针对 Java 开发者的一个节目，直接从Oracle的Java开发者那里获得。我们将讨论该语言、JVM、OpenJDK、平台安全性，以及诸如 Loom 和 Panama 之类的创新项目还有别的其他内容）。
* 加入 [OpenJDK 邮件列表](http://mail.openjdk.java.net/mailman/listinfo)（了解您喜欢的 OpenJDK 项目进度的地方）。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
