> * 原文地址：[The Arrival of Java 16](https://blogs.oracle.com/java-platform-group/the-arrival-of-java-16)
> * 原文作者：[Sharat Chander](https://blogs.oracle.com/author/sharat-chander)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/the-arrival-of-java-16.md](https://github.com/xitu/gold-miner/blob/master/article/2021/the-arrival-of-java-16.md)
> * 译者：
> * 校对者：

# The Arrival of Java 16

![](https://cdn.app.compendium.com/uploads/user/e7c690e8-6ff9-102a-ac6d-e4aebca50425/ed5569e8-c0dd-458c-8450-cde6300093bd/File/a5023b0f0fb67f59176a0499af9021ed/java_horz_clr.png)

[Follow OpenJDK on Twitter](https://twitter.com/OpenJDK)

2020 proved to be a memorable year for Java as we celebrated its [25th birthday](https://www.oracle.com/java/moved-by-java/). With over two decades of innovation, Java has continued to be:

* Flexible by adapting to the changing technology landscape while remaining platform independent.
* Reliable by retaining backwards compatibility.
* Performant by accelerating innovation without sacrificing security.

Coupled with Java’s ability to boost performance, stability and security of the platform along the way, it continues to be the world’s most popular programming language among developers. According to IDC’s latest report “[Java Turns 25](https://www.oracle.com/a/ocom/resources/java-turns-25.pdf)”, over nine million developers representing 69% of full-time developers worldwide use Java – more than any other language.

Further demonstrating Java’s path of continued innovation, Oracle is proud to announce the general availability of Java 16 representing the seventh feature release as part of the six-month cadence. This level of predictability allows developers to more easily manage their adoption of innovation thanks to a steady stream of expected changes.

![](https://cdn.app.compendium.com/uploads/user/e7c690e8-6ff9-102a-ac6d-e4aebca50425/ed5569e8-c0dd-458c-8450-cde6300093bd/Image/1b71450b94c7e38e2ca7981ba45246f4/features_in_java16.png)

## Java 16 is now available!

Oracle now offers [Java 16 for all developers and enterprises](https://www.oracle.com/news/announcement/oracle-announces-java-16-031621.html). Oracle JDK 16 will receive a minimum of two quarterly updates, per the [Oracle Critical Patch Update (CPU) schedule](https://www.oracle.com/technetwork/topics/security/alerts-086861.html), before being followed by Oracle JDK 17. Java 17 will reach general availability on September 2021, but early [access builds](https://jdk.java.net/17/) are already being offered at jdk.java.net.

Once again, Oracle provides Java 16 as the [Oracle OpenJDK release](https://jdk.java.net/15/) using the open source GNU General Public License v2, with the Classpath Exception (GPLv2+CPE), and also under a [commercial license](https://oracle.com/javadownload) for those using the Oracle JDK release as part of an Oracle product or service, or for those who want to be able to get commercial support.

## Java 16, Together

Similar to previous releases, we continue to celebrate the contributions made to Java 16 from many individuals and organizations in the OpenJDK Community — we all build Java, together!

## JDK 16 Fix Ratio

The overall rate of change over time in the JDK has remained essentially constant for many years, but under the six-month cadence the pace at which production-ready innovations are delivered has vastly improved.

Instead of making tens of thousands of fixes and around one hundred JDK Enhancement Proposals (JEPs) available in a large major release every few years, enhancements are delivered in smaller Feature releases on a more manageable, predictable six-month schedule. These changes can range from a significant feature to small enhancements to routine maintenance, bug fixes, and documentation improvements. Each change is represented in a single commit for a single issue in the [JDK Bug System](https://bugs.openjdk.java.net/secure/Dashboard.jspa).

Of the [1,897](https://bugs.openjdk.java.net/issues/?jql=project%20%3D%20JDK%20AND%20fixVersion%20%3D%2016%20AND%20resolution%20%3D%20Fixed%20AND%20(comment%20~%20%22URL%3A%20http%3A%2F%2Fhg.openjdk.java.net%22%20OR%20comment%20~%20%22URL%3A%20https%3A%2F%2Fhg.openjdk.java.net%22%20OR%20comment%20~%20%22URL%3A%20https%3A%2F%2Fgit.openjdk.java.net%2F%22)%20AND%20(labels%20not%20in%20(hgupdate-sync)%20OR%20labels%20is%20EMPTY)%20%20ORDER%20BY%20updated%20DESC%2C%20assignee%20ASC) issues marked as fixed in Java
16, [1,397](https://bugs.openjdk.java.net/browse/JDK-8246707?jql=project%20%3D%20JDK%20AND%20fixVersion%20%3D%2016%20AND%20resolution%20%3D%20Fixed%20AND%20(comment%20~%20%22URL%3A%20http%3A%2F%2Fhg.openjdk.java.net%22%20OR%20comment%20~%20%22URL%3A%20https%3A%2F%2Fhg.openjdk.java.net%22%20OR%20comment%20~%20%22URL%3A%20https%3A%2F%2Fgit.openjdk.java.net%2F%22)%20%20AND%20(labels%20not%20in%20(hgupdate-sync)%20OR%20labels%20is%20EMPTY)%20AND%20assignee%20in%20membersOf(oracle-employees)%20ORDER%20BY%20updated%20DESC%2C%20assignee%20ASC) were completed by people working for Oracle
while [500](https://bugs.openjdk.java.net/browse/JDK-8257574?jql=project%20%3D%20JDK%20AND%20fixVersion%20%3D%2016%20AND%20resolution%20%3D%20Fixed%20AND%20(comment%20~%20%22URL%3A%20http%3A%2F%2Fhg.openjdk.java.net%22%20OR%20comment%20~%20%22URL%3A%20https%3A%2F%2Fhg.openjdk.java.net%22%20%20OR%20comment%20~%20%22URL%3A%20https%3A%2F%2Fgit.openjdk.java.net%2F%22)%20%20AND%20(labels%20not%20in%20(hgupdate-sync)%20OR%20labels%20is%20EMPTY)%20AND%20assignee%20not%20in%20%20membersOf(oracle-employees)%20ORDER%20BY%20updated%20DESC%2C%20assignee%20ASC) were contributed by individual developers and developers working for other organizations. Going through the issues and collating the organization data from assignees results in the following chart of organizations sponsoring the development of fixes in Java 16:

![](https://cdn.app.compendium.com/uploads/user/e7c690e8-6ff9-102a-ac6d-e4aebca50425/ed5569e8-c0dd-458c-8450-cde6300093bd/Image/2cc5607809bb9fd699031aabc26528bd/java_16_fixes_by_org.png)

Oracle would like to thank the developers working for organizations like ARM, SAP, Red Hat and Tencent for their notable contributions. We are also thankful to see contributions from smaller organizations such as Ampere Computing, Bellsoft, DataDog, Microdoc and independent developers who collectively contributed 3% of the fixes in Java 16.

We are equally grateful to the the many experienced developers who reviewed proposed changes, the early adopters who tried out early access builds and reported issues, and the dedicated professionals who provided feedback on the OpenJDK mailing lists.

The following individuals provided invaluable feedback on build quality, logged good quality bugs or offered frequent updates:

* Jaikiran Pai (Apache Ant)
* Gary Gregory (Apache Commons)
* Uwe Schindler (Apache Lucene)
* Robert Scholte (Apache Maven)
* Mark Thomas (Apache Tomcat)
* Enrico Olivelli (Apache Zookeeper)
* Rafale Winterhalter (Byte Buddy)
* Peter Karich (Graph Hopper)
* Evgeny Mandikov (JaCoCo)
* Marc Hoffman (JaCoCo)
* Vincent Privat (JOSM)
* Christain Stein (JUnit 5)
* David Karnok (RxJava)

Additionally, through the [Quality Outreach](https://wiki.openjdk.java.net/display/quality/Quality+Outreach) program we would like to thank the following FOSS projects and individuals who provided excellent feedback on testing Java 16 early access builds to help improve the quality of the release.

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

## New in Java 16

Along with thousands of performance, stability and security updates, Java 16 offers users [seventeen main enhancements/changes](https://openjdk.java.net/projects/jdk/16/) (known as [JDK Enhancement Proposals - JEPs](https://openjdk.java.net/jeps/1)), including three incubator modules and one preview feature.

Some enhancements are introduced in [Incubator modules](https://openjdk.java.net/jeps/11), a means of putting non-final APIs and non-final tools in the hands of developers that allows users to offer feedback that can ultimately improve the quality of the Java platform.

Similarly, some enhancements are introduced as [Preview features](https://openjdk.java.net/jeps/12), language or VM features of the Java SE Platform that are fully specified, fully implemented, and yet impermanent. They are made available in JDK feature releases to provoke developer feedback based on real-world use, which may lead to them becoming permanent in a future release. This offers users the chance to provide timely feedback, as well as allowing tool vendors the opportunity to build support for the feature before the bulk of Java developers use it in production.

The 17 JEPs delivered with Java 16 have been grouped into six different categories:

### 1. New Language Features

**[JEP 394](https://openjdk.java.net/jeps/394)** **Pattern Matching for** **instanceof**

First introduced as a preview feature in [Java 14](https://openjdk.java.net/jeps/305) and again in [Java 15](https://openjdk.java.net/jeps/375), Pattern Matching enhances the Java programming language with pattern matching for the instanceof operator.

Pattern matching allows common logic in a program, namely the conditional extraction of components from objects, to be expressed more concisely and safely.

**[JEP 395](https://openjdk.java.net/jeps/395)** **Records**

Also first introduced as a preview feature in [Java 14](https://openjdk.java.net/jeps/359) and again in [Java 15](https://openjdk.java.net/jeps/384), Records provide a compact syntax for declaring classes which are transparent holders for shallowly immutable data. *This will significantly reduce the verbosity of these classes and improve code readability and maintainability.*

### 2. JVM Improvements

**[JEP 376](https://openjdk.java.net/jeps/376) ZGC Concurrent Thread Processing**

JEP 376 move ZGC thread-stack processing from safepoints to a concurrent phase, allows sub-millisecond pauses inside GC safepoints, even on large heaps. Removing the final source of latency in the ZGC garbage collector will greatly improve performance and efficiency of applications in this and subsquent releases.

**[JEP 387](https://openjdk.java.net/jeps/387) Elastic Metaspace**

This feature returns unused HotSpot VM class-metadata (i.e. *metaspace*) memory to the operating system more promptly, reducing metaspace footprint. Applications with heavy class loading and unloading activity can accrue a lot of unused space.

The new scheme allocates metaspace memory in smaller chunks, reduces class-loader overhead and fragmentation. It improves elasticity by returning unused metaspace memory to the operating system, which leads to greater application performance and decreases memory utilization.

### 3. New Tools and Libraries

**[JEP 380](https://openjdk.java.net/jeps/380) Unix-Domain Socket Channels**

Unix-domain sockets have long been a feature of most Unix platforms, and are now supported in Windows 10 and Windows Server 2019. This feature adds Unix-domain (AF\_UNIX) socket support to the socket channel and server-socket channel APIs in the java.nio.channels package. It extends the inherited channel mechanism to support Unix-domain socket channels and server socket channels. Unix-domain sockets are used for inter-process communication (IPC) on the same host. They are similar to TCP/IP sockets in most respects, except that they are addressed by filesystem path names rather than Internet Protocol (IP) addresses and port numbers. For local, inter-process communication, Unix-domain sockets are both more secure and more efficient than TCP/IP loopback connections.

**[JEP 392](https://openjdk.java.net/jeps/392) Packaging Tool**

This feature was first introduced as an incubator module in [Java 14](https://openjdk.java.net/jeps/343). This tool allows for packaging self-contained Java applications. It supports native packaging formats to give end users a natural installation experience. These formats include msi and exe on Windows, pkg and dmg on macOS, and deb and rpm on Linux. It also allows launch-time parameters to be specified at packaging time and can be invoked directly, from the command line, or programmatically, via the ToolProvider API. Note that the name of the jpackage module changes from jdk.incubator.jpackage to jdk.jpackage. This will improve the end-user experience when installing applications and simplify deployments using the “app store” model.

### 4. Futureproofing Your Work

**[JEP 390](https://openjdk.java.net/jeps/390)** **Warning for Value-Based Classes**

This feature designates the primitive wrapper classes (java.lang.Integer, java.lang.Double, etc) as *value-based* (similar to java.util.Optional and java.time.LocalDateTime) and add forRemoval to their constructors, which are deprecated since JDK 9, prompting new warnings. It provides warnings about improper attempts to synchronize on instances of any value-based classes in the Java Platform.

Many popular open-source projects have already responded to the deprecation warnings of Java 9 by removing wrapper constructor calls from their sources, and we can expect many more to do so, given the heightened urgency of "deprecated for removal" warnings.

**[JEP 396](https://openjdk.java.net/jeps/396)** **Strongly Encapsulate JDK Internals by default**

This feature strongly encapsulates all internal elements of the JDK by default, except for critical internal APIs such as sun.misc.Unsafe. Code successfully compiled with earlier releases that accesses internal APIs of the JDK may no longer work by default*.* This change aims to encourage developers to migrate from using internal elements to using standard APIs, so that both they and their users can upgrade without fuss to future Java releases. Strong encapsulation is controlled by the launcher option -–illegal-access, for JDK 9 until JDK 15 defaults to *warning*, and starting with JDK 16 defaults to *deny*. It is still possible (for now) to relax encapsulation of all packages with a single command-line option, in the future only opening specific packages with –add-opens will work.

### 5. Incubator and Preview Features

**[JEP 338](https://openjdk.java.net/jeps/338) Vector API (Incubator)**

This incubator API provides an initial iteration of an API to express vector computations that reliably compile at runtime to optimal vector hardware instructions on supported CPU architectures and thus achieve superior performance to equivalent scalar computations. It allows taking advantage of the Single Instruction Multiple Data (SIMD) instructions available on most modern CPUs. Although HotSpot supports auto-vectorization, the set of transformable scalar operations is limited and fragile to changes in the code. This API will allow developers to easily write portable and performant vector algorithms in Java.

**[JEP 389](https://openjdk.java.net/jeps/389) Foreign Linker API (Incubator)**

This incubator API offers statically-typed, pure-Java access to native code. This API will considerably simplify the otherwise convoluted and error-prone process of binding to a native library. Java has supported native method calls via the Java Native Interface (JNI) since Java 1.1 but it is hard and brittle. Java developers should be able to (mostly) just use any native library that is deemed useful for a particular task. It also provides foreign-function support without the need for any intervening JNI glue code.

**[JEP 393](https://openjdk.java.net/jeps/393) Foreign Memory Access API (3rd Incubator)**

First introduced as an incubator API in Java 14 and again in Java 15, this API allows Java programs to safely and efficiently operate on various kinds of foreign memory (e.g., native memory, persistent memory, managed heap memory, etc.). It also provides the foundation for the Foreign Linker API.

**[JEP 397](https://openjdk.java.net/jeps/397) Sealed Classes (2nd Preview)**

This preview feature restricts which other classes or interfaces may extend or implement them. It allows the author of a class or interface to control which code is responsible for implementing it. Also, It provides a more declarative way than access modifiers to restrict the use of a superclass. And it supports future directions in pattern matching by underpinning the exhaustive analysis of patterns.

### 6. Improving Productivity for OpenJDK Developers

*The rest of the changes are not directly visible to Java developers (those that use Java to code and run applications), rather only to developers of Java (those that work on OpenJDK).*

**[JEP 347](https://openjdk.java.net/jeps/347) Enable C++14 Language Features (in JDK source code)**

This allows the use of C++14 language features in JDK C++ source code and gives specific guidance about which of those features may be used in HotSpot code. Through JDK 15, the language features used by C++ code in the JDK have been limited to the C++98/03 language standards. It requires updating the minimum acceptable version of various platform compilers.

**[JEP 357](https://openjdk.java.net/jeps/357) Migrate from Mercurial to Git  
[JEP 369](https://openjdk.java.net/jeps/369) Migrate to GitHub**

These JEPs migrate the OpenJDK Community's source code repositories from Mercurial (hg) to Git and host them on GitHub for JDK 11 and later. The migration includes updating tooling such as jcheck, webrev, and defpath tools to Git. Git reduces the size of the metadata (around ¼ of the size) preserving local disk space and reducing clone time. Modern tooling is better integrated with Git than Mercurial. OpenJDK Git repositories are now at [https://github.com/openjdk](https://github.com/openjdk)

**[JEP 386](https://openjdk.java.net/jeps/386) Alpine Linux Port**

**[JEP 388](https://openjdk.java.net/jeps/388) Windows/AArch64 Port**

The focus of these JEPs is not the porting effort itself, which was already done, but integrating them into the JDK main-line repository.

JEP 386 ports the JDK to Alpine Linux and other distributions that use musl as their primary C Library on both x64 and AArch64. In addition, JEP 388 ports the JDK to Windows AArch 64 (ARM64).

## Tooling Support

Current tooling support helps drive developer productivity. With Java 16, we continue to welcome the efforts of leading IDE vendors whose tooling solutions offer developers support for current Java versions. Developers can expect to receive Java 16 support with the following IDEs:

* JetBrains [IDEA](https://blog.jetbrains.com/idea/2021/03/java-16-and-intellij-idea/)
* Eclipse [Marketplace](https://marketplace.eclipse.org/content/java-16-support-eclipse-2021-03-419)

Java continues to be the #1 programming language of choice by software programmers. As the on-time delivery of improvements with Java 16 demonstrates, through continued thoughtful planning and ecosystem involvement, the Java platform is well-positioned for modern development and growth in the cloud.

Continue staying current with news and updates by:

* Visiting [Inside.Java](https://inside.java/) (news and views by the Java Team at Oracle)
* Listening to the [Inside.Java podcasts](https://inside.java/podcast/) (a show for Java Developers brought to you directly from the people that make Java at Oracle. We'll discuss the language, the JVM, OpenJDK, platform security, innovation projects like Loom and Panama, and everything in between).
* Joining the [OpenJDK mailing lists](http://mail.openjdk.java.net/mailman/listinfo) (the place to learn about the progress of your favorite OpenJDK projects).

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
