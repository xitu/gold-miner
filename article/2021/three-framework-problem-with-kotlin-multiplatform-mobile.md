> * 原文地址：[Three-framework problem with Kotlin Multiplatform Mobile](https://medium.com/xorum-io/three-framework-problem-with-kotlin-multiplatform-mobile-16267c5afa53)
> * 原文作者：[Yev Kanivets](https://medium.com/@yev-kanivets)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/three-framework-problem-with-kotlin-multiplatform-mobile.md](https://github.com/xitu/gold-miner/blob/master/article/2021/three-framework-problem-with-kotlin-multiplatform-mobile.md)
> * 译者：[霜羽 Hoarfroster](https://github.com/PassionPenguin)
> * 校对者：[Kimhooo](https://github.com/Kimhooo)、[HumanBeingXenon](https://github.com/HumanBeingXenon)

# Kotlin Multiplatform Mobile 的三模块问题

Kotlin Multiplatform Mobile 正在日趋成熟，越来越多的团队使用该平台同时在 Android 和 iOS 端上开发应用程序。但随着越来越多的项目采纳它，新的问题出现了。

![](https://cdn-images-1.medium.com/max/2880/1*UXiMJrLOUiwSziIcXUsSLA.png)

今天，我们将讨论一个模块化应用程序中可能发生的问题。这些应用使用了多个 KMP（Kotlin 多平台）框架，它们会在 iOS 应用中被共享和使用。这些 KMP 框架都使用了来自第三方模块或 iOS 程序可见的库中的通用代码。

## 实际示例

想象一个简单的应用程序，它可以跟踪所有经过身份验证的用户的最爱作家和书籍。所有的数据都存留在后端，因此我们希望使用 Kotlin Multiplatform 技术在移动应用程序中共享关系网、业务以及表示逻辑。

在接下来的几个月中，该应用程序的使用量会不断增长，因此我们希望从一个可扩展的架构开始开发。我们决定将代码库分为三个模块（一个模块对应一个功能），包括：**认证**、**作者**、**书籍**。

![](https://cdn-images-1.medium.com/max/2364/1*XKTLMLfs2CTW7vPrB4BR4g.png)

Android 应用程序中的每个模块都由 2 个子模块表示：共享 KMP 模块和 Android 特定模块。在 iOS 中，共享的 KMP 模块则会被编译为 iOS 框架，并在 iOS 应用中重复使用，架构与 Android 应用相同（每个功能一个模块）。

值得一提的是，“作者”和“书”模块依赖于“身份验证”模块来服务经过身份验证的用户实体，以便后端可以返回个性化响应 —— 作家和书籍。

## 实际问题

这种方法在 Android 应用程序中效果很好，但是一旦将其应用于导入了 KMP 驱动的框架的 iOS 应用程序中，就会产生繁琐的问题。

实际的问题是，在 iOS 模块的编译过程中，Kotlin/Native 插件包含了当前已编译的模块中全部的依赖关系，因此它是内置的。此外，为防止冲突，它会在所有显式的依赖项名的前面加上对应的库名。

![](https://cdn-images-1.medium.com/max/2348/1*8Ne4eMYHJS2OZ4uYtv0QFw.png)

这对于单个模块或一组独立模块非常方便。但是，一旦两个或多个模块使用了 iOS 应用程序可见的相同依赖项，你就复制出了多个版本的相同依赖项。

在我们的示例中，来自作者模块的用户实体和来自图书模块的用户实体在 Android 应用程序中将是相同的，但在 iOS 应用程序中将是两个不同的实体，即使它们是相同的。

换句话说，我们在 iOS 应用程序中会有两个截然不同的身份验证模块，而且它们之间不共享任何内容，毫无关联 —— 不共享类、状态等一切东西！

## 实际解决方案

我有幸与一个 KMP 团队探讨了这个问题，他们推荐的解决方案（至少这是 6 个月前的最优解）是使用 Umbrella 模块，它包含了所有共享的 KMP 模块。这是一个会被导入到 iOS 应用程序中的框架。

![](https://cdn-images-1.medium.com/max/2348/1*ornbj_vtf61Bak0WaKkgBw.png)

这显然是一个缺点，破坏了 iOS 端的模块性。但是，只要 iOS 模块与 Android 模块相匹配，我们便不太可能在错误的地方使用来自 Umbrella 框架的越界类。

良好的架构在这里也有很大帮助。例如使用 Clean 架构，仅会暴露共享 KMP 模块的最顶层。在我们的例子中，它是一个表示层，很难在目标模块之外的任何地方使用。

## 结论

没有完美的技术或解决方案。你应该做好处理问题的准备，因为它们会在开发的全过程中出现，特别如果是你够胆使用 alpha 或 beta 版本的软件。

Kotlin Multiplatform 使得你可以使用模块化架构，不过还是有一些重要的制约。在我们规划共有部分的实现及其在 iOS 应用程序中的使用时，必须考虑这些制约。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
