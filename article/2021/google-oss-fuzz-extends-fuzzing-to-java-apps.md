> * 原文地址：[Google’s OSS-Fuzz extends fuzzing to Java apps](https://www.infoworld.com/article/3611510/googles-oss-fuzz-extends-fuzzing-to-java-apps.html#tk.rss_devops)
> * 原文作者：[Paul Krill](https://www.infoworld.com/author/Paul-Krill/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/google-oss-fuzz-extends-fuzzing-to-java-apps.md](https://github.com/xitu/gold-miner/blob/master/article/2021/google-oss-fuzz-extends-fuzzing-to-java-apps.md)
> * 译者：
> * 校对者：

# Google 的开源模糊测试工具 OSS-Fuzz 现在支持 Java 应用了

Google 的开源模糊测试服务 OSS-Fuzz 现在支持 Java 和 JVM-based 的应用程序了！这项功能于 3 月 10 日公布。

[OSS-Fuzz](https://github.com/google/oss-fuzz) 为开源软件提供连续的模糊测试。作为一种用于发现软件中的编程错误和安全漏洞的技术，模糊测试包括将半随机和无效的输入流发送到程序。用内存安全语言（例如 JVM 语言）编写的模糊代码能够帮助我们发现导致程序崩溃或行为不正确的错误。

Google 通过将 OSS-Fuzz 与 Code Intelligence 的 [Jazzer](https://blog.code-intelligence.com/engineering-jazzer) 模糊器集成在一起，为 Java 和 JVM 启用了模糊处理功能。Jazzer 让我们可以通过 LLVM 项目的 libFuzzer 引擎（运行于进程内，指导覆盖率的模糊引擎）对基于 JVM 的语言编写的代码进行模糊处理，类似于对 C / C++ 代码的那种处理方式。Jazzer 支持的语言包括 Java、Clojure、Kotlin 和 Scala。它从 JVM 字节码到 libFuzzer 提供了代码覆盖率反馈，而 Jazzer 支持 libFuzzer 功能，包括：

* [FuzzedDataProvider](https://github.com/google/fuzzing/blob/master/docs/split-inputs.md#fuzzed-data-provider) 用于模糊处理不接受字节数组的代码。
* 基于8位边缘计数器的代码覆盖率评估。
* 最大限度地减少崩溃的输入。
* [Value Profiles](https://llvm.org/docs/LibFuzzer.html#value-profile).

[Google 提供了](https://google.github.io/oss-fuzz/getting-started/new-project-guide/jvm-lang/)有关将 OSS-Fuzz 添加到以 JVM 语言编写的开源项目的文档。Jazzer 的开发计划最终要求 Jazzer 支持所有的 libFuzzer 功能。Jazzer 还可以提供通过 Java 原生接口执行的本机代码的覆盖率反馈。这样可以发现内存不安全的本机代码中的内存损坏漏洞。OSS-Fuzz 还同时支持了 Go、Python，C/C + 和 Rust 等语言。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
