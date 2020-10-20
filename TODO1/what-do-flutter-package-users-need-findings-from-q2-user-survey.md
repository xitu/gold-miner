> * 原文地址：[What do Flutter package users need? Findings from Q2 user survey](https://medium.com/flutter/what-do-flutter-package-users-need-6ecba57ed1d6)
> * 原文作者：[Ja Young Lee](https://medium.com/@jayoung.lee)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/what-do-flutter-package-users-need-findings-from-q2-user-survey.md](https://github.com/xitu/gold-miner/blob/master/TODO1/what-do-flutter-package-users-need-findings-from-q2-user-survey.md)
> * 译者：[solerji](https://github.com/solerji)
> * 校对者：[talisk](https://github.com/talisk)

# 用户需要什么样的 Flutter 依赖包? 来自 Q2 用户调查的结果

![用Q2调查评论结果做出的词云](https://cdn-images-1.medium.com/max/3200/0*JGPtcSX7QYbN8Dvn)

> 用 Q2 调查评论做出的词云 ☁️ （原始的 [图片](https://raw.githubusercontent.com/timsneath/wordcloud_flutter/master/flutter_wordcloud.png)，[代码](https://github.com/timsneath/wordcloud_flutter) 链接）。

我们最近进行了第六季度用户调查，收集了超过 7,000 名 Flutter 用户的回复。我们发现 92.5％ 的受访者表示满意或非常满意，这一点略高于 [上一季度](https://medium.com/flutter/insights-from-flutters-first-user-survey-of-2019-3659b02303a5)！我们很高兴看到大家对 Flutter 的一致满意。在本文中，我们将讨论 Flutter 生态系统的一些深层次问题，因为我们认识到帮助 Flutter 社区发展生态系统非常重要。

---

截至 2019 年 7 月，您可以找到超过 2,800 个依赖于 Flutter 的软件包发布在 [pub.dev](https://pub.dev)。在去年同期，大约只有 350 个与 Flutter 相关的依赖包，这体现出了显著增长。而且这个数据并不包括与 Flutter 应用程序兼容的数千个其他的 Dart 包。

尽管生态系统已经爆炸式增长，我们认识到需要围绕 Flutter 项目建立一个优秀的生态系统仍然需要做很多工作。为了更好地了解用户的需求和不满之处，我们在本季度的调查中询问了与 Flutter 生态系统相关的一些问题。我们将在本文中分享结果，来帮助依赖包作者构建更多有用的依赖包，同时满足更多用户的需求。

总体而言，5,250 名受访者中有 80.6％ 对 Flutter 生态系统**非常满意**或**有点满意**。这还不错，但与此同时，它是调查中得分较低的部分之一。

![对生态系统的满意度](https://cdn-images-1.medium.com/max/2400/0*MjrAD-ZGebXA-xaX)

![对Flutter的总体满意度](https://cdn-images-1.medium.com/max/2400/0*LDgXRVH9t_ZteWDV)

当被问及对 Flutter 生态系统的不满时，大多数受访者选择的原因是“我需要的关键包**不存在**”（18％），这可能是对较新技术的期待。

我们很高兴地发现我们的社区正在积极地构建 Flutter 包生态系统。15％ 的受访者有为 Flutter 开发软件包的经验，59％ 的受访者已将他们的软件包发布到 pub.dev，这是一个为 Flutter 和 Dart 应用程序共享依赖包的网站。如果您已经编写了一个包但尚未发布，你可以阅读 [开发包和插件](https://flutter.dev/docs/development/packages-and-plugins/developing-packages) 在 [flutter.dev](http://flutter.dev) 上，并通过发布您的包来为 Flutter 社区做贡献。这并不难 —— 那些通过 [pub.dev](http://pub.dev) 发布过包的贡献者，有 81％ 认为**非常容易**或**很容易**。

如果您不知道该与 Flutter 社区分享哪个依赖包，请访问 GitHub 上的 Flutter 存储库并搜索 [issues labeled with “would be a good package”](https://github.com/flutter/flutter/issues?q=is%3Aopen+is%3Aissue+label%3A%22would+be+a+good+package%22+sort%3Areactions-%2B1-desc) 看看有什么要求。您可以对自己喜欢的项目进行投票，以提高其可见度。

![对 Flutter 生态系统不满的原因（多项选择题）](https://cdn-images-1.medium.com/max/3200/0*UdtJOiVqBwXOmDl_)

当然，如果您有兴趣帮助我们，那么有更好的方式为生态系统做出贡献。 请注意所有以“我需要已经存在的关键依赖包……”开头的其他原因部分写了什么，这意味着即使依赖包存在，依赖包的用户也仍然面临着挑战。 这告诉我们，我们可以通过改进已有的东西来改善生态系统 —— 提交错误，改进文档，添加缺失的功能，实现对“其他”平台的支持，添加测试等等。我们希望找到一个具有潜力但尚未被充分关注并为此做出贡献的依赖包 —— 包括测试，错误报告，功能贡献或示例！

对现有包不满意的最常见原因是“它们没有很好地**记录**”（17％）。这是可以帮助社区的另一个领域。调查问题“您希望如何改善整个包装生态系统的整体体验？”得出以下建议：

* 包含更多不同的代码使用示例
* 包括屏幕截图，GIF 动画或视频
* 包含指向相应代码存储库的链接

以下引用相关评论：

> “仍有一些软件包在第一页上没有代码示例。至少应该有一个简单的例子。”
>
> “强调依赖包开发者提供更详尽的如何使用他们的依赖包的例子。”
>
> “所有包必须都有动画 gif 或视频演示它（最好是视频）或截图，并有一个示例 Dart 文件。”
>
> “示例包的图形显示将有所帮助。很多时候，比起运行这个例子更容易看出包含的内容。”
>
> “希望能看到示例部分更完整地填写。有些包没有任何例子。也许在这个页面上有一个更清晰的链接到相应的 GitHub repo 更好一些？”

此外，如上图所示，与选择合适的包相关的活动（例如：缺少功能、发布者的可信度、参考指南、充分的平台支持）相比，很少有用户关注与包的实际使用相关的难题（例如：依赖性问题、包的错误、包的设置）。

---

谷歌的 Flutter / Dart 团队也正在研究如何改善您使用和贡献生态系统的体验。正在考虑的一些选项包括但不限于：

* 提供更好的 pub.dev 搜索体验
* 可以轻松分辨程序包支持的平台
* 提供更可靠的质量指标
* 提高可测试性

与此同时，值得指出的是，pub.dev 上的每个包都已经获得了关注度，健壮性和维护程度的分数，这些分数可以帮助用户衡量包的质量。您可以在上面找到评分系统的详细信息：[pub.dev/help#scoring](https://pub.dev/help#scoring)  。

![得分示例](https://cdn-images-1.medium.com/max/2000/0*DSPe0z8OcY1Dzlet)

![维护建议](https://cdn-images-1.medium.com/max/2000/0*Kxtw9kjb1h_6DTAK)

通过评分系统，依赖包作者可以了解他们可以做些什么来提高依赖包的质量，依赖包用户可以估计依赖包的质量（例如，过时性）。

我们希望评分系统能够随着时间的推移而扩展，来帮助用户做出更明智的决策。更具体地说，我们希望增加测试覆盖率，并且我们希望公开关于更好的平台覆盖度的相关信息，特别是 Flutter 支持扩展的平台列表。我们还想提供一个特定包装是否“推荐”的标记，以便用户清楚地了解 Flutter 社区认为有价值的内容。随着这些评分的变化，我们将与我们的依赖包作者进行沟通，以确保他们拥有满足不断提升的质量标准所需的所有信息。

---

我们想向超过 7,000 名填写长期调查的 Flutter 用户表示衷心的感谢。我们学到了很多东西 —— 下面列出了其他一些好的建议。

* 一些 Flutter 用户对动画框架并不完全满意，不是因为它很难实现预期的效果，而是因为它很难进行第一步学习。受访者，特别是新用户，不知道从哪里开始，他们很难理解各种概念如何联系在一起。因此，我们正在为动画框架的学习材料投入更多资金。
* 对于 [api.flutter.dev](http://api.flutter.dev) 上的 API 文档，类文档中的示例代码被评为最有用的资源。我们已经在 1.7 版本的 API 文档中为一些类添加了完整的代码示例，并且将继续将此功能扩展到更多类。（我们也接受关于 [flutter/flutter 仓库](https://github.com/flutter/flutter/labels/d%3A%20api%20docs) 上的 API 文档的 PR！)。

![](https://cdn-images-1.medium.com/max/3200/0*PceEjhOlGlSQw1oK)

* 最后，你们中的许多人注意到 GitHub 仓库中未解决的问题数量正在增加，这是 Flutter 爆炸式普及的一个不幸的副作用。 虽然我们在上一版本中关闭了 1,250 多个问题，但我们还有更多工作要做。正如 Flutter 1.7 博客文章中所提到的，我们正在努力增加该领域的人员配置，这将有助于更快地分类新错误，更快地关注到关键的或引发崩溃的问题，关闭或合并重复问题，以及将支持的项目重定向到 [StackOverflow](https://stackoverflow.com/questions/tagged/flutter)。

我们重视您对调查的回复，并在确定工作重点时将会使用此信息。请参加我们将于 8 月份启动的 Q3 调查，并将探讨新的领域。

---

Flutter 的用户体验研究团队开展了各种用户体验研究，以便我们学习如何让您的 Flutter 体验更加愉快。如果您有兴趣参加，如果您有兴趣，请通过 [注册](http://flutter.dev/research-signup) 来参与接下来的研究。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
