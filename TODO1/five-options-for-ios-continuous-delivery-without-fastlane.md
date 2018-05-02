> * 原文地址：[Five Options for iOS Continuous Delivery without Fastlane](https://medium.com/xcblog/five-options-for-ios-continuous-delivery-without-fastlane-2a32e05ddf3d)
> * 原文作者：[Shashikant Jagtap](https://medium.com/@shashikant.jagtap?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/five-options-for-ios-continuous-delivery-without-fastlane.md](https://github.com/xitu/gold-miner/blob/master/TODO1/five-options-for-ios-continuous-delivery-without-fastlane.md)
> * 译者：[金西西](https://github.com/melon8)
> * 校对者：[allenlongbaobao](https://github.com/allenlongbaobao)，[talisk](https://github.com/talisk)

# 不使用 fastlane 实现持续交付的 5 种选项

![](https://cdn-images-1.medium.com/max/800/1*VttABPhOQPcSnjJTSkxykg.jpeg)

__原文发布在 XCBlog__ [__这里__](http://shashikantjagtap.net/five-options-for-ios-continuous-delivery-without-fastlane/)

fastlane [工具](https://fastlane.tools/)将整个 iOS CI/CD 流水线（Continuous Integration and Deployment，持续集成和发布，译者注）自动化了，使得我们可以用代码的方式管理整个 iOS 基础架构。fastlane 是一系列工具，用来将例如分析、构建、测试、代码签名和 iOS app 打包等一切过程自动化。然而如果你深入看，它不过是在苹果原生开发工具上加了一个 Ruby 层。可能在某些情况下，fastlane 节省了一些时间，但考虑到频繁的不兼容更改，fastlane 反过来浪费了大量开发者的时间。在不断学习 Ruby 和 fastlane 式的自动化的过程中，许多开发人员浪费了宝贵时间。就像 [CocoaPods](https://cocoapods.org/)， fastlane 可能是你的 iOS 项目中使用到 Ruby 的另一个无用之物，它与 iOS 开发毫无关系。学习一些本地的苹果开发工具并从你的 iOS 开发工具箱中彻底删除 Ruby 和其他第三方工具（比如 fastlane）并不难。在这篇文章中，我们将介绍 iOS 开发人员使用 fastlane 面临的问题以及替代方案。

### fastlane 的 5 个问题

fastlane 声称它通过自动执行常见任务节省了开发人员的时间。在 fastlane 按预期工作的情况下，这可能是正确的，但也需要考虑到 fastlane 在安装、调试和管理方面浪费了多少时间。本节我们将讨论 iOS 开发人员使用 fastlane 可能面临的常见问题。

### 1. Ruby

在 iOS 项目中使用 fastlane 的首要问题是 [Ruby](https://www.ruby-lang.org/en/)。一般来说，iOS 开发人员并不擅长使用 Ruby，但为了使用 fastlane 或 CocoaPods 等工具，他们必须学习 Ruby，然而这与实际的 iOS 开发没有任何关系。设置 fastlane 工具需要很好的理解 Ruby、[RubyGems](https://rubygems.org/) 和 [Bundler](http://bundler.io/) 的工作原理。最近出的 [Swift 版的 fastlane](https://docs.fastlane.tools/getting-started/ios/fastlane-swift/) 声称可以摆脱 Ruby，但实际上只是用 Swift 来执行的后台的 Ruby 命令。我对 Swift 版 fastlane 的可用性表示怀疑，这篇[博客](https://dzone.com/articles/first-impressions-of-fastlane-swift-for-ios) 里面写了我对 Swift 版 fastlane 最初的印象。fastlane 有很全的文档，但 iOS 开发人员仍然需要使用 Ruby 来编写所有用于自动化 iOS 发布流水线的基础架构。

### 2. 频繁的不兼容的更新

苹果不断地改变着本地工具，这些改变不断地导致 fastlane 无法兼容。他们需要经常追逐着苹果和谷歌（以 Android 为例）适配 fastlane，这要求 fastlane 的开发人员实现这些特性并发布新版本。如果 fastlane 版本不是由 Bundler 管理的，那么大多数情况更新 fastlane 版本的时候也需要更新现有的 fastlane 脚本。对于可能频繁出现的构建失败，iOS 开发人员需要花时间分析 fastlane 中发生的变化并相应地修复。这种破坏性的更新会干扰 iOS 开发人员的主要开发流程，并且要浪费几个小时来修复构建。使用 fastlane 的一个痛苦点是，在 fastlane 之前的版本中配置的选项并不总是适用于较新的版本，如果你搜索解决方案，那么对于同一个问题，你最终会找到对应 fastlane 不同版本的多个解决方案。。

### 3. 耗时的设置和维护

虽然 fastlane 提供了很好的入门指南搭配了模版代码，但用脚本来描述所有的 iOS 自动化发布流水线需求并不是十分简单直白的事情。我们需要根据我们的需求定制选项，这需要知道这些选项如何在 fastlane 脚本中编写，然后我们才可以使用不同的 lane 来编写我们的流水线。学习 fastlane 和 Ruby 工具箱需要大量的时间来以完成所有的设置。然而当你设置好所有的东西时，这个工作并没有完成，你还需要在前文提到的每个 fastlane 的更新中持续不断的维护。

### 4. 在 github 贡献代码很难

你可能需要根据公司特定的要求配置 iOS 发布流水线，或者要求 fastlane 进行定制。唯一的选择就是为 fastlane 写[插件](https://docs.fastlane.tools/plugins/available-plugins/)。目前编写插件的唯一方法是编写一个 Rubygem，它可以安装为 fastlane 插件。同样，它需要对 Ruby 生态系统有深刻的理解，而通常 iOS 开发人员并没有相关的技巧。很不幸的是，iOS 开发人员不能为他们目前在工具箱中使用的工具贡献代码。除此之外，给 fastlane [贡献代码](https://github.com/fastlane/fastlane/blob/master/CONTRIBUTING.md)的过程耗时且充满了机器人。它以创建一个 Github 的 issue 开始，进而是无休止的讨论。[这里](https://github.com/fastlane/fastlane/blob/master/CONTRIBUTING.md)你可以阅读更多关于 fastlane 的贡献指南。

### 5. Github 上未解决的 issue

fastlane 的 Github 上面有很多 [issue](https://github.com/fastlane/fastlane/issues) 是 open 的状态，有些在还没有为用户提供正确的解决方案的情况下就被自动机器人关闭了。我举个很好的例子，我浪费了好几天的时间为了确定 fastlane 的 [match](https://docs.fastlane.tools/actions/match/) 是否支持在 Xcode 9 上构建的企业应用发布包。在寻找答案的同时，我发现还有其他人也在寻找相同问题的解决方案。[这](https://github.com/fastlane/fastlane/issues/10895)是一个没有得出合适的解决方案的却被 fastlane 机器人关闭的 issue。我已经尝试了 issue [11090](https://github.com/fastlane/fastlane/issues/11090)，[10543](https://github.com/fastlane/fastlane/issues/10543)，[10325](https://github.com/fastlane/fastlane/issues/10325)，[10458](https://github.com/fastlane/fastlane/issues/10458) 等提供的各种解决方案，读完所有这些之后，我仍然不明白企业应用构建的 export 方法是什么。有些用户说：当你使用 adhoc 它会起作用；而另一些用户则说 Ad-hoc 或者 AdHoc。你可以想象需要花多少时间来给应用打包，去测试每个出口方法。我看到 CircleCI 也有用户对 fastlane 的 match 的代码签名问题感到[沮丧](https://twitter.com/m4rr/status/961047312666710016)。

上面列举的是 fastlane 在你的 iOS 项目中制造的所有问题中的一小部分，你可能有不同的故事和不同的问题，但你从来没有提起。

### 5 个 fastlane 的代替品

既然我们已经看到了在 iOS 项目中使用 fastlane 的一些问题。现在的问题是我们能否完全移除 iOS 项目中的 fastlane。答案是肯定的。但是，你需要花费一些时间来理解 iOS 构建过程和几个苹果原生命令行开发工具。我认为，花时间去了解原生苹果开发工具，比学习第三方框架更加值得。你永远不会后悔学习了苹果原生命令行开发工具，然而如果你没有时间去学习这些，还有一些免费或者付费服务可以帮你解决所有的问题。目前，我们有以下代替 fastlane 的免费或付费的选择。

fastlane 的替代者 Top 5

* 原生苹果开发工具（免费）
* Xcode Server（免费）
* 云端 CI 服务（付费）
* Apple + BuddyBuild（天知道）
* 基于 Swift 的替代方案（免费但尚未准备好）

### 1. 原生苹果开发工具

没有什么比学习苹果原生开发工具和编写自定义脚本更适合你的构建和发布过程的需求了。苹果提供了命令行开发工具来完成我们想要的一切。要知道 fastlane 和类似的工具也是基于苹果原生开发工具实现的。使用苹果开发工具的最大好处是，除了苹果之外，任何人都不能打破它，而且在大多数情况下它们都是向下兼容的。苹果已经给这些工具编写了文档，而且大多数都有指导手册来方便查看这些工具提供的所有选项。为了编写 iOS 构建流水线，我们需要了解以下主要工具。

*   [xcodebuild](https://developer.apple.com/legacy/library/documentation/Darwin/Reference/ManPages/man1/xcodebuild.1.html)  —— 分析、构建、测试和打包 iOS app。这是所有命令之父，所以学习这个工具很重要。
*   [altool](http://help.apple.com/itc/apploader/#/apdATD1E53-D1E1A1303-D1E53A1126): 上传 ipa 文件到 iTunes Connect。
*   [agvtool](https://developer.apple.com/library/content/qa/qa1827/_index.html): 管理版本和构建版本号。
*   [codesign](https://developer.apple.com/legacy/library/documentation/Darwin/Reference/ManPages/man1/codesign.1.html): 管理 iOS app 的代码签名。
*   [security](https://developer.apple.com/legacy/library/documentation/Darwin/Reference/ManPages/man1/security.1.html): 管理证书, 钥匙串和 Profiles。

有一些辅助工具像 [simctl](https://medium.com/xcblog/simctl-control-ios-simulators-from-command-line-78b9006a20dc)，[PlistBuddy](https://developer.apple.com/legacy/library/documentation/Darwin/Reference/ManPages/man8/PlistBuddy.8.html)，[xcode-select](https://developer.apple.com/legacy/library/documentation/Darwin/Reference/ManPages/man1/xcode-select.1.html) 等，在处理模拟器、Plist 文件和 Xcode 版本等有时也会需要。一旦熟悉了这些工具，你就会对自己编写 iOS 发布流水线有信心，并且这些工具能够解决任何问题。在大多数情况下，几行代码就可以将你的 iOS 应用发送到 iTunes Connect。我写了一篇[文章](https://medium.com/xcblog/xcodebuild-deploy-ios-app-from-command-line-c6defff0d8b8)关于通过命令行发布 iOS 应用。我们也需要知道一些 [代码签名](https://developer.apple.com/support/code-signing/) 以理解整个流程.。学习在iOS构建过程中应用苹果开发者工具需要一些时间，但这是一次性的，你不需要学习任何第三方框架，比如 fastlane。

### 2. Xcode Server

[Xcode Server](https://developer.apple.com/library/content/documentation/IDEs/Conceptual/xcode_guide-continuous_integration/) 是苹果提供的持续集成服务。随着 Xcode 9 的发布，苹果给 Xcode Server 增加了许多新功能，几乎所有的功能都是在后台运行。Xcode Server 与 Xcode 紧密结合，对 iOS 开发人员来说很容易上手。使用 Xcode Server，我们可以分析、测试、构建和归档一个 iOS 应用程序，并且无需编写任何代码或脚本。如果你使用 Xcode Server 进行 iOS 持续集成，你可能不需要任何工具来自动化构建过程。[这里](https://medium.com/xcblog/xcode9-xcode-server-comprehensive-ios-continuous-integration-3613a7973b48)可以读到更多关于 Xcode Server 特性的信息。然而，还有一个步骤需要我们手动实现：将二进制文件上传到 iTunes Connect 或其他平台上。目前 Xcode Server 无法将二进制文件上传到 iTunes Connect，但使用 altool 作为 Xcode Server bot 的 post-integration 脚本就很容易实现这个目标。

如果你无法在内部管理 Mac Mini 服务器，你可以通过[Mac Stadium](https://www.macstadium.com/)这类的服务中租用一些 mac Mini 来运行 Xcode Server。

### 3. 基于云的 CI 服务

有许多基于云计算的 CI 服务，例如 [BuddyBuild](https://www.buddybuild.com/)，[Bitrise](https://www.bitrise.io/)，[CircleCI](https://circleci.com)，[Nevercode](https://nevercode.io/)等，可以提供持续集成以及持续发布服务。 BuddyBuild 最近被苹果公司收购，我下一节会介绍。这些基于云的 CI 服务会处理所有 iOS 构建过程，包括测试，代码签名和将应用程序发布到特定服务或 iTunes Connect 上。我们也可以编写自定义脚本来实现特定需求。这些服务完全避免了对 fastlane 或任何 iOS 项目的脚本编写的需求。但是这些服务不是免费的，并且可以控制你的项目。如果你完全不具备 CI / CD 基础设施的技能，那么这将是一个不错的选择。我在我的个人项目上完成了所有基于这些云计算的 CI 服务的关键步骤，并写了我的[结论](https://dzone.com/articles/olympics-of-top-5-cloud-ios-continuous-integration)。希望文中的对比和讨论能在你为自己的 iOS 项目选择合适服务的过程上有所帮助。

### 4. Apple + BuddyBuild

今年年初苹果[收购](https://techcrunch.com/2018/01/02/apple-buys-app-development-service-buddybuild/)了 BuddyBuild，这意味着苹果和 BuddyBuild 可能会合作，为 iOS 开发人员提供无痛苦的持续集成和交付服务。在 [WWDC 2018](https://developer.apple.com/wwdc/) 上如果看到了苹果和 BuddyBuild 的合作演示估计会很有趣。 我们可以[猜测](https://dzone.com/articles/apple-acquires-buddybuild-oh-my-xcode-server) 苹果会将 Xcode Server 作为自己托管的解决方案（免费）并且将 BuddyBuild 基于云，集成进 Xcode 的解决方案（付费或免费）；或者是苹果彻底抛弃 Xcode Server，只保留 BuddyBuild 为免费或付费的服务。以上种种可能除非必要，都不需要明显的脚本基础架构。这也将彻底消除对类似 fastlane 这样的工具的需求。我们目前唯一需要做的就是等到 2018 年 WWDC。

### 5. Swift 选项（未准备好）

fastlane 最近添加了使用 [Swift](https://docs.fastlane.tools/getting-started/ios/fastlane-swift/) 而不是 Ruby 来配置通道的支持。但目前这并不是真正的 Swift 实现，因为在底层还是用 Swift 来执行 Ruby 命令而已。它在项目中添加了许多不相关的 Swift 文件，这些文件理想情况下应该作为可通过 CocoaPods，Carthage 或 Swift Package Manager 分发的 Swift 包（SDK）提供。我写了我对Fastlane Swift [第一印象](https://dzone.com/articles/first-impressions-of-fastlane-swift-for-ios)。另一个解决方案是 [Autobahn](https://github.com/AutobahnSwift/Autobahn)，它是纯 Swift 实现的 fastlane，但是它还处在开发阶段，在开发完成之前无法使用。遗憾的是，我们不得不等待这些基于 Swift 的解决方案，他们还没有准备好在当前的 iOS 项目中使用。但是，我们期待迟早会有可行的解决方案，这将允许 iOS 开发人员使用 Swift 编写配置代码。在我看来 Swift 不是脚本语言，但可以在需要时用作脚本。

### 选择的小建议

现在，我们已经看到了所有的不使用 fastlane 工具实现持续发布的选择了。 接下来需要决定选哪个方式，这取决于团队中工程师的技能和经验。

* 如果团队完全没有对 CI / CD 知识有了解的 iOS 工程师，那么可以选择使用基于云计算的 CI 解决方案来处理所有问题。
* 如果团队中有少数具有 CI / CD 经验的 iOS 工程师，那么可以尝试使用 Xcode Server，因为配置和使用相当简单。
* 如果团队的 iOS 开发人员有经验，对原生工具很熟悉，那么很值得去使用脚本构建流水线。
* 等待 2018 年 WWDC 是一个好主意，看看苹果和 BuddyBuild 将在舞台上呈现什么结果。

### 结论

通过使用苹果原生开发者工具，我们可以为 iOS 项目编写整个 CI / CD 流水线，避免了 iOS 项目中需要第三方工具（如 fastlane）的需求。但是需要时间和努力来学习苹果原生开发者工具。 其他选项例如 Xcode Server 或基于云的 CI 解决方案可以避免了使用脚本。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
