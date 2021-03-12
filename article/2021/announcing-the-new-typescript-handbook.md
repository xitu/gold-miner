> * 原文地址：[Announcing the New TypeScript Handbook](https://devblogs.microsoft.com/typescript/announcing-the-new-typescript-handbook/)
> * 原文作者：[Orta Therox](https://devblogs.microsoft.com/typescript/author/ortammicrosoft-com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/announcing-the-new-typescript-handbook.md](https://github.com/xitu/gold-miner/blob/master/article/2021/announcing-the-new-typescript-handbook.md)
> * 译者：[zenblo](https://github.com/zenblo)
> * 校对者：[itcodes](https://github.com/itcodes)、[PassionPenguin](https://github.com/PassionPenguin)

# 新发布的 TypeScript 手册！先睹为快！

嘿！开发者们，我们很高兴地向大家宣布，一个完全重写的 TypeScript 手册现在已经转入正式版了，并且将会成为我们网站学习 TypeScript 的主要资源！

![](https://devblogs.microsoft.com/typescript/wp-content/uploads/sites/11/2021/03/Screen-Shot-2021-03-05-at-2.53.27-PM.png)

> 通过 [Web](https://www.typescriptlang.org/docs/handbook/intro.html)、[Epub](https://www.typescriptlang.org/assets/typescript-handbook.epub) 或 [PDF](https://www.typescriptlang.org/assets/typescript-handbook.pdf) 阅读新发布的 TypeScript 手册。

在过去的一年里，团队高度重视提升 TypeScript 文档的规模、时效性和范围。TypeScript 手册是我们的文档中最关键的部分，它是你在大多数代码库中都会看到的 TypeScript 代码的导览。我们希望这本手册能让你觉得是学习 TypeScript 的首选资料。

去年[新版网站](https://devblogs.microsoft.com/typescript/announcing-the-new-typescript-website/)的发布中，我们已经将一些渐进式的改进纳入到手册中，同时新版手册为新网站的很多功能提供了指引。

而在这个从 2018 年启动的新 TypeScript 手册项目中，我们编写手册的方式增加了一套规范。

- **将 JavaScript 的教学工作交给专家去做**

通过网络和书籍学习 JavaScript 的资源非常多。我们没有必要在这个领域竞争。这本手册旨在帮助开发者理解 TypeScript 构建在 JavaScript 上的方式。这个重点意味着我们的文档可以对背景进行假设，避免从头开始解释 JavaScript 的特性。

我们希望不同技术水平的开发者都能使用这本手册。例如，我们在网站上添加了一个新功能，让人们根据自己的技术背景，初步了解 TypeScript 与其他语言的区别，作为阅读手册之前的准备。你可以在[文档概述](https://www.typescriptlang.org/docs/)中看到。

- **循序渐进的教学**

我们希望以一种循序渐进的方式来学习 TypeScript 的概念 —— 避免使用尚未解释的 TypeScript 特性。这种约束很好地使我们重新思考语言概念的顺序和类别。这种教学方式让前几页的手册编写变得有点困难，但对开发者来说确实变得很有价值，并支持从头到尾的阅览风格。

- **让编译器说了算**

如果你已经使用了网站上新发布的 TypeScript 文档，那么你应该已经注意到我们提供了一些代码示例，这些示例提供了内联的上下文，例如快速信息提示和错误提示，甚至还可以显示 `output.js` 和 `.d.ts` 文件。

作为手册的编写者，我们必须处理好 TypeScript 的变化对文档的影响。当我们把网站迁移到一个新的 TypeScript 版本时，也会迁移手册。如果结果不一致，我们很容易发现，并决定需要做哪些改变。

令人兴奋的是，我们正在使用这些工具，将编辑经验中的一些最好的功能带入 Web 页面，并以 epub 或 pdf 格式静态地展示手册。这项技术也可以为[你的应用程序](https://www.npmjs.com/package/shiki-twoslash)提供帮助。

对开发者来说，这意味着网站中所有的代码示例都是最新的、准确的和交互式的！

- **针对日常案例进行编写**

TypeScript 已经有 8 年的历史了，总体来说，并没有删除功能。我们在参考页部分记录所有可能的用途，以及任何概念的可行选择。我们认为这应该可以减少在 TypeScript 启蒙道路上的干扰。

对我们中的一些人来说，了解 JavaScript 捆绑模式的历史或者更深奥的 TypeScript 选项如何改变代码流分析可能会很有趣（对我来说就是这样！），但大多数人要么是为了 `greenfield` 项目而学习，要么是在代码库中工作时已经了解了所有这些。

这些规范为我们提供了一个更有针对性的且更容易学习的 TypeScript 语言指引。我们会一直是 TypeScript 的忠实粉丝（即使我们可能更偏爱 TypeScript）。

虽然说是由我来发布 TypeScript 新手册，并把它推送到网站上的，但在 TypeScript 团队中，新手册业已是一个持续多年的项目，有了很多的贡献了。在过去的几个月里，我们获得了大家的好评，这也有助于给我们如何解释想法提供一些新的视角。所以在这里，我想对每一个参与的人说声谢谢!

如果你一直在通过这个博客中的季度性发布说明了解 TypeScript 的最新情况，那你很可能会重新阅读一遍我们的手册！我们在其中展示了所有的功能，无论新旧，相互关联，有序介绍。希望你不会错过那些精彩内容！另外如果你发现了我们遗漏的内容，请随时在 [TypeScript 仓库中提出 Issue](https://github.com/microsoft/TypeScript-Website/issues/new/choose) 告诉我们一声。

> 快来在[我们的官网](https://www.typescriptlang.org/docs/handbook/intro.html)上或通过下载最新的 [Epub](https://www.typescriptlang.org/assets/typescript-handbook.epub)、[PDF](https://www.typescriptlang.org/assets/typescript-handbook.pdf) 文件来阅读我们最新发布的 TypeScript 手册吧！。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
