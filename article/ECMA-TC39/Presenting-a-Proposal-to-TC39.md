> - 原文地址：[Presenting a Proposal to TC39](https://github.com/tc39/how-we-work/blob/master/presenting.md)
> - 原文作者：[Ecma TC39](https://github.com/tc39/how-we-work)
> - 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> - 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/ECMA-TC39/Presenting-a-Proposal-to-TC39.md](https://github.com/xitu/gold-miner/blob/master/article/ECMA-TC39/Presenting-a-Proposal-to-TC39.md)
> - 译者：[NieZhuZhu（弹铁蛋同学）](https://github.com/NieZhuZhu)
> - 校对者：[Songfeng Li（李松峰）](https://github.com/cncuckoo)、[Hoarfroster](https://github.com/PassionPenguin)、[Kim Yang](https://github.com/KimYangOfCat)

# 向 TC39 提交提案

## 准备内容

在 TC39 会议之前，请提供有关您的提案的公共文档。GitHub 是典型的解决方案 —— 提案的早期可能是个 Gist，小的提案可能会记录在 issue 或 PR（pull request）中，但是大型提案最好放在自己的 Github 仓库中（最初可以是个人仓库，但如果达到提案的第 1 阶段，则需要转移仓库到 tc39 组织中）。

您对 TC39 的提案应针对特定目的：仔细考虑您想与委员会沟通的内容以及您希望从演示文稿中获得的信息。可能的目标包括：
- 将提案推进到特定阶段
- 向小组提供一个关于将来可能会被考虑建设或者被开发的新的想法或思考的方式
- 在一个规范的、大家一起参与讨论的 PR（pull request）上达成共识
- 报告当前工作的进度，以征求反馈意见

您可以在委员会会议之前花一些时间来准备您的提案。这项准备工作可以包括：
- 深入思考提案中的想法
- 与委员会内部和外部的各种人员进行讨论，面对面、GitHub issue、IRC 等
- 撰写解释该想法的辅助文档，包括比演示文稿更加深入的内容
- 用代码对想法进行原型实现（例如，在 polyfill 中实现，转译器实现，浏览器，一致性测试，使用该功能的示例应用程序等）

### 创建幻灯片

幻灯片演示不是必需的，但可以帮助观众跟得上演示。关于制作有效的幻灯片演示的一些提示：
- **预先陈述演示文稿的目标。** 因为您已经在线上发布了演示文稿，因此无需进行戏剧性铺垫。清楚地强调您的要点将使演示更易于理解。
- **不要在幻灯片上包含太多文字。** 您希望听众跟随您的演讲，而不是阅读幻灯片上的精美文字。还要注意的是，大家的视力都不是一样的（如果其他人都表现得像是没有任何问题一样，那么就很难提出问题）—— 使用大字号的文本可以确保更多的观众能看清楚幻灯片的内容。
- **包含示例。** 编程语言设计有的时候会比较抽象，所以我们需要通过应用程序和代码示例来让其更接地气。
- **在演示文稿中创建一个叙述流程。** 您的演示文稿会讲述一个现存的问题，这个问题的现状以及解决方案。让流程清晰明了将有助于更多的观众关注此演示文稿。

### 提上议程

如果需要在 TC39 会议上发言，请针对即将要在其中进行演示的 TC39 会议的[议程](https://github.com/tc39/agendas/)提出 PR（pull request）。您的提案提交到议程越早，TC39 代表将有更多的时间提前审查您的提案，并且在大家开会时委员会可以推进得越多。议程中包括添加寻求阶段进展提案的截止日期。

## 发言提示

- **提前练习。** 如果您花费了精力去拥护一个提案，那么毫无疑问，您知道提案的内容并且非常了解它。因此，请务必提前准备好要说的内容，以传达这些知识点。
- **对着麦克风讲话。** 我们是一个需要占用大房间的大团体，麦克风不再是一种奢侈。确保每个人都能听到您说的话。说话要缓慢而清晰 —— 这将帮助听众中的每个人，包括将英语作为第二语言学习且听力不佳的人。
- **准备一些问题。** 复查您的材料中可能被问到的问题，并在别人提问之前尝试回答它们。提前与其他代表沟通，以了解他们通常遇到的问题。在发言的末尾留出提问题和讨论的时间。
- **预想一些琐碎有争议的点。** 这是一群有观点有想法的人，一旦有机会，很容易就陷入到一些琐碎的有争议的事情上。解决此问题的一种聪明方法是提前确定哪些琐碎细节最有可能成为争论的焦点，并在提案的 Github 库上为其创建话题。将人员引导至该话题的 issue，以使他们在分配给你的会议时间内做对应的事情。
- **请记住观众的多样性。** 有些人会熟悉您提案中涉及的一些概念，而有些人则不会。观众将是拥有不同理论背景的组合，比如 JS 引擎开发背景和 JS 应用程序开发背景；没有人是无所不知的，而我们的优势就在于利用这种多样性。如果您可以使您的演示文稿被所有观众无障碍的理解，那么您将更具说服力。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
