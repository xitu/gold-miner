> * 原文地址：[Rust Case Study: Community makes Rust an easy choice for npm](https://www.rust-lang.org/static/pdfs/Rust-npm-Whitepaper.pdf)
> * 原文作者：[The Rust Project Developers](https://www.rust-lang.org/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/rust-case-study-community-makes-rust-an-easy-choice-for-npm.md](https://github.com/xitu/gold-miner/blob/master/TODO1/rust-case-study-community-makes-rust-an-easy-choice-for-npm.md)
> * 译者：[WangLeto](https://github.com/WangLeto)
> * 校对者：[xionglong58](https://github.com/xionglong58), [HearFishle](https://github.com/HearFishle)

# Rust 语言案例研究：社区使得 Rust 成为 npm 的简单选择

> 使用 Rust 来解决 CPU 性能产生的 npm 软件包注册瓶颈

## Rust 语言在 npm

事实与数据：

```
共有超过 836,000 个 JavaScript 包可用

每个月使用 npm 下载的软件包超过三百亿

下载来自于超过一千万个用户
```

npm 公司（npm, Inc.）是 [npmjs.com](https://www.npmjs.com/) 网站和 npm 注册服务背后的公司。它是全世界最大的软件注册中心，每天有高达 13 亿的包下载量。除了维护开源软件包注册，npm 公司也提供企业级的软件包注册产品，并维护着一个用于与注册信息交互的命令行工具。

npm 所面临的挑战是对效率和扩展性的要求。如果服务部署后可以被遗忘（译注：指服务不需要花精力维护），我们就节约了宝贵的时间，可以处理别的问题。npm 员工们也很希望，他们所使用的技术有一个有帮助的社区。Rust 符合这些要求，而且在 npm 目前的技术栈中也有部分使用。

### 问题：扩展一个受限于 CPU 性能的服务

npm 工程团队时刻关注着随着 npm 包指数增长可能导致的性能问题。大多数情况下 npm 的操作性能受限于网络，JavaScript 足以支撑实现性能目标。然而，决定用户是否被允许发布软件包的认证服务，是一个受限于 CPU 性能的任务，预计会成为性能瓶颈。

Node.js 中使用传统 JavaScript 实现的这个服务无论如何都需要重写，所以 npm 团队借此契机，考虑在服务降级前重新实现，既使得代码更现代化，又能提高服务性能。

### 考虑过的解决方案

当考虑替代技术时，npm 团队很快否决了 C，C++和 Java 实现，而密切关注 Go 语言和 Rust 语言。

在 npm 工程团队的考虑中，C 或 C++ 解决方案不再是一个合理的选择。“我不相信自己能写一个 C++ HTTP 应用程序，然后把它发布到网络上，”npm 的工程师 Chris Dickinson 解释说。这些语言需要内存管理方面的专业知识，以避免可能导致灾难性问题的错误。即使是为了提高性能，npm 公司也无法容忍安全问题、系统崩溃和内存泄漏的发生。

Java 也未被考虑，因为要部署任何程序到生产服务器上，都得带上 JVM（Java 虚拟机）和相关类库。这是一系列复杂操作，会产生资源消耗，与 C 或 C++的不安全性一样难以接受。

考虑到这些要求，所选的编程语言应该：

* 内存安全
* 可以编译为独立、易部署的二进制文件
* 性能始终优于 JavaScript

因此最后考虑使用的是 Go 语言和 Rust 语言。

### 评估

为了评估候选方案，npm 团队分别使用 Node.js、Go 语言和 Rust 语言重写了授权服务。

使用 Node.js 重写的服务被当做基准线，以评估使用 Go 语言和 Rust 语言带来的变化。如你所料，npm 有很多 JavaScript 专家。使用 Node.js 重写授权服务大约用了一个小时，性能表现与过去实现的差不多。

使用 Go 语言重写授权服务用了 2 天。在这个过程中，npm 团队对于缺少依赖管理的解决方案感到失望。npm 公司致力于让 JavaScript 依赖管理可预测，并且用起来毫不费力，他们期待其他语言生态也有同样的世界级依赖管理工具。Go 语言的依赖安装全球化进程、跨项目版本共享的前景（在他们进行评估时 Go 语言的标准）都不具有吸引力。

当开始用 Rust 语言实现时，他们在依赖管理方面发现了鲜明的对比。“Rust 语言有着绝对令人惊叹的依赖管理，”一位工程师热情地说，他指出 Rust 的依赖管理策略从 npm 获得了灵感。Rust 语言安装时附带的 Cargo 命令行工具与 npm 命令行工具类似：Cargo 分开协调每一个项目中的各依赖版本，从而让搭建每个项目时所在环境不会影响最终的执行结果。Rust 语言的开发体验很友好，符合 npm 团队受到 JavaScript 影响的预期。

> Rust 语言有着绝对令人惊叹的依赖管理。

使用 Rust 语言重写授权服务的时间其实比 JavaScript 版本和 Go 语言版本的都长：大约用了一周来熟悉语言并进行实现。Rust 感觉像是一种更难以搞定的编程语言。语言的设计预先加载了不同于其他常见编程语言的内存使用决策，以确保内存安全性。“你可以写出一个正确的程序，但是你必须考虑到这个程序的方方面面，”Dickinson 说。然而，当工程师们遇到问题时，Rust 社区友善地回答了问题，很有帮助。这一点让 npm 团队能够用 Rust 语言重写服务并将其部署到生成环境。

### 结果

> 我对 Rust 最大的恭维就是它很“无聊”。

npm 的第一个 Rust 程序在一年半的生产使用中没有引起任何警报。“我对 Rust 最大的恭维就是它很‘无聊’，”Dickinson 说，“而这是一个很棒的恭维。”部署新的 Rust 服务的过程很简单，很快他们就忘记了这个 Rust 服务，因为它极少引起运行问题。在 npm 公司，将 JavaScript 服务部署到生产环境的一般经验是，要对服务的错误和过多的资源占用进行大量监控，从而需要调试和重启。

### 社区很重要

npm 称 Rust 社区是决策过程中的一个积极因素。他们认为 Rust 社区很有价值的一些方面是他们的包容、友好以及做出困难的技术决策的可靠流程。这些方面使 Rust 语言的学习和解决方案的开发更容易，并保证了语言将以健康、可持续的方式继续提高。

### 缺点：维护多个技术栈

每个技术决策都需要权衡利弊，将 Rust 语言加入 npm 的生产服务也不例外。将 Rust 引入 npm 的最大缺点是，现有的 JavaScript 技术栈和新的 Rust 技术栈都有自己的解决方案，用来进行状态监视、日志记录与发出警报；而维护这些解决方案有一定的负担。作为一门年轻的语言，Rust 还没有用以完成工业级产品标准的库和最佳实践，但是希望在不久的将来能实现。

### 结论

Rust 语言是一种可扩展且易于部署的解决方案。它可以占用较少的资源而不影响内存安全性。通过 Cargo 的依赖管理为系统编程领域带来了现代化工具。虽然仍有最佳实践和工具有待提高，但社区的建立保证了长期成功。出于这些原因，npm 选择了 Rust 来处理 CPU 限制的性能瓶颈。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
