> * 原文地址：[Google’s OSS-Fuzz extends fuzzing to Java apps](https://www.infoworld.com/article/3611510/googles-oss-fuzz-extends-fuzzing-to-java-apps.html#tk.rss_devops)
> * 原文作者：[Paul Krill](https://www.infoworld.com/author/Paul-Krill/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/google-oss-fuzz-extends-fuzzing-to-java-apps.md](https://github.com/xitu/gold-miner/blob/master/article/2021/google-oss-fuzz-extends-fuzzing-to-java-apps.md)
> * 译者：[霜羽 Hoarfroster](https://github.com/PassionPenguin)
> * 校对者：[huifrank](https://github.com/huifrank)，[1autodidact](https://github.com/1autodidact)

# Google 的开源混沌测试工具 OSS-Fuzz 现在支持 Java 应用了

Google 的开源混沌测试服务 OSS-Fuzz 现在支持 Java 以及 JVM-based 的应用程序了！这项功能于 3 月 10 日公布。

[OSS-Fuzz](https://github.com/google/oss-fuzz) 为开源软件提供持续的混沌测试。混沌测试作为一种将半随机和非法的输入流发送到程序，用于发现软件中的编程错误和安全漏洞的技术。用内存安全语言（基于 JVM 的语言）编写的混沌代码能够帮助我们发现导致程序崩溃或行为异常的错误。

Google 通过将 OSS-Fuzz 与 Code Intelligence 的 [Jazzer](https://blog.code-intelligence.com/engineering-jazzer) 混沌器集成在一起，为 Java 和 JVM 开启了混沌处理功能。Jazzer 让我们可以通过 LLVM 项目的 libFuzzer 引擎（运行于进程内，覆盖引导的的混沌引擎），类似于对 C / C++ 的混沌处理，对基于 JVM 语言编写的代码进行混沌处理。Jazzer 支持的语言包括 Java、Clojure、Kotlin 和 Scala。代码覆盖率的反馈是基于 JVM 字节码提供给 libFuzzer 的，而 libFuzzer 功能包括：

* [FuzzedDataProvider](https://github.com/google/fuzzing/blob/master/docs/split-inputs.md#fuzzed-data-provider) 用于混沌测试中处理不接收字节数组的代码。
* 基于8位边缘计数器的代码覆盖率评估。
* 最大限度地减少崩溃的输入。
* [Value Profiles](https://llvm.org/docs/LibFuzzer.html#value-profile).

[Google 提供了](https://google.github.io/oss-fuzz/getting-started/new-project-guide/jvm-lang/)向基于 JVM 语言编写的开源项目加入 OSS-Fuzz 的文档。Jazzer 的开发计划要求 Jazzer 最终支持所有的 libFuzzer 功能。Jazzer 还可以通过 Java 原生接口执行本地代码时提供覆盖率反馈。这样可以发现内存不安全的本地代码中的内存损坏漏洞。OSS-Fuzz 还同时支持了 Go、Python，C/C + 和 Rust 等语言。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
