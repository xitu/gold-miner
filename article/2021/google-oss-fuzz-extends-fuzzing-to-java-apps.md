> * 原文地址：[Google’s OSS-Fuzz extends fuzzing to Java apps](https://www.infoworld.com/article/3611510/googles-oss-fuzz-extends-fuzzing-to-java-apps.html#tk.rss_devops)
> * 原文作者：[Paul Krill](https://www.infoworld.com/author/Paul-Krill/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/google-oss-fuzz-extends-fuzzing-to-java-apps.md](https://github.com/xitu/gold-miner/blob/master/article/2021/google-oss-fuzz-extends-fuzzing-to-java-apps.md)
> * 译者：
> * 校对者：

# Google’s OSS-Fuzz extends fuzzing to Java apps

Google’s open source fuzz-testing service, OSS-Fuzz, now supports applications written in Java and JVM-based languages. The capability was announced on March 10.

[OSS-Fuzz](https://github.com/google/oss-fuzz) provides continuous fuzzing for open source software. A technique for finding programming errors and security vulnerabilities in software, fuzzing involves sending a stream of semi-random and invalid input to a program. Fuzzing code written in memory-safe languages such as JVM languages can find bugs that cause programs to crash or behave incorrectly.

Google enabled fuzzing for Java and the JVM by integrating OSS-Fuzz with the [Jazzer](https://blog.code-intelligence.com/engineering-jazzer) fuzzer from Code Intelligence. Jazzer enables users to fuzz code written in JVM-based languages via the LLVM project’s [libFuzzer](https://llvm.org/docs/LibFuzzer.html), an in-process, coverage-guided fuzzing engine, similar to how this has been done for C/C++ code. Languages supported by Jazzer include Java, Clojure, Kotlin, and Scala. Code coverage feedback is provided from JVM bytecode to libFuzzer, with Jazzer supporting libFuzzer features including:

- [FuzzedDataProvider](https://github.com/google/fuzzing/blob/master/docs/split-inputs.md#fuzzed-data-provider), for fuzzing code that does not accept an array of bytes.
- Evaluation of code coverage based on 8-bit edge counters.
- Minimization of crashing inputs.
- [Value profiles](https://llvm.org/docs/LibFuzzer.html#value-profile).

[Google has provided documentation](https://google.github.io/oss-fuzz/getting-started/new-project-guide/jvm-lang/) on adding open source projects written in JVM languages to OSS-Fuzz. Plans call for Jazzer to support all lIbFuzzer features eventually. Jazzer also can provide coverage feedback from native code executed through the Java Native Interface. This can uncover memory corruption vulnerabilities in memory-unsafe native code. OSS-Fuzz also lists languages such as Go, Python, C/C++, and Rust as supported languages.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
