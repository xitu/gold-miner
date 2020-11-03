> * 原文地址：[Building and Monitoring Your First Github Actions Workflow](https://blog.bitsrc.io/building-and-monitoring-your-first-github-actions-workflow-b9cad4a1014d)
> * 原文作者：[Meercode](https://medium.com/@meercode)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/building-and-monitoring-your-first-github-actions-workflow.md](https://github.com/xitu/gold-miner/blob/master/article/2020/building-and-monitoring-your-first-github-actions-workflow.md)
> * 译者：[zenblo](https://github.com/zenblo)
> * 校对者：

# Github Actions 工作流的创建与跟踪

![](https://cdn-images-1.medium.com/max/2400/1*BZ_jv-xjX_FfJR5fQH_6UQ.png)

**Github Actions** 是 Github 对 CI/CD 的本地解决方案，自 2019 年推出以来，它就可供社区开发者使用。**Action** 简单、灵活和低成本等特性使许多团队从现有的 **CI/CD** 解决方案中迁移过来，并展现新平台的无限可能。

我的团队是 **Github Actions** 的早期使用者。作为一个大量使用 **Javascript** 的开发人员，我们能够自动化处理前端和后端项目的数十条工作流。幸好平台支持 **Javascript/Typescript**，我们创建了大量 **Actions**（例如传统构建工具中的**插件**），以便根据我们的需要扩展功能。

在使用 Github Actions 一年之后，我们发现该工具与之前测试的 CI/CD 解决方案相比具有以下优势：

* 零管理成本（不需要任何代理或主节点）。
* 易学易学。
* 可以在源代码中保留工作流。
* 丰富的 **Action**（插件）库，易于开发自定义 **Action**。
* 合理的定价模式：为私有存储库的高级用户提供 3000 分钟的免费时间。公共存储库是完全免费的！
* 它有一个丰富的 action 库，很容易开发自定义 Action。
* 支持 **Linux**、**Windows** 和 **macOS** 平台。（**macOS** 支持功能在竞争对手中是罕见的）。
* 借助自托管运行工具，就可以在自己的设备上运行免费版本。

该平台的一个小瑕疵是缺少可以跟踪工作流状态的工具。随着我们必须管理的项目库和工作流数量的增加，问题变得更棘手。最后，我们决定开发自己的仪表盘作为解决方案。

借助 **React** 前端和 **NestJS** 后端，使用相关的 Github API 并以简洁的方式显示。这个工具在我们的团队成员中很受欢迎，我们继续开发新功能。

最近，我们发布了仪表盘工具 **SaaS** 项目，并启动了一个公共测试程序，与开发者社区共享。如果你感兴趣，你可以阅读 Meercode 的[关于此博客文章的故事](https://dev.to/pankod/public-beta-meercode-a-beautiful-dashboard-and-monitoring-tool-for-github-actions-466g)或访问 [meercode.io](http://meercode.io) 试用产品。

为了演示如何简单地在 Github Actions 上创建工作流，我们想展示一个真实的例子。

任务很简单，对于 Github 上的一个项目库，我们需要一个[ AppCenter ](https://appcenter.ms/)在发出 pull 请求时生成触发回应。幸运的是，AppCenter 有一个公用的 REST API，可以用来启动构建。

我们要创建的操作应该在以下场景触发：

1. pull 请求被打开或重新打开。
2. 单元测试正在通过。

如果满足所有条件，我们将在 AppCenter 上开始构建。下面开始创造我们的 action。

从 GitHub 上的存储库中，在 .**github/workflows** 目录中创建一个名为 **app_center_pull_request.yml.** 的文件。

![](https://cdn-images-1.medium.com/max/2684/0*iyCUtUXoh8MF11Rm)

通过使用 **“name:”** 属性，我们将 action 命名为 “Pull Request Opened [App]”。

为了让我们的 action 触发 pull 请求，我们将使用本机 Github 工作流事件。也可以使用 **“on:”** 语法将工作流配置为针对一个或多个事件运行。还可以把 action 中使用的工作流事件完整列表记录在[参考页](https://docs.github.com/en/free-pro-team@latest/actions/reference/events-that-trigger-workflows)。

在下一步中，我们将告诉 action，当触发 “**pull_request**” 事件时要做什么。

![](https://cdn-images-1.medium.com/max/2684/0*upqVeOmReybteXcC)

在 “**jobs:**” 属性下，我们可以添加任意数量的要运行的作业。我们用 **“build:”** 属性标记第一个作业，并按上面所示进行配置。

**“runs-on:”** 和 **“matrix:”** 属性指定 action 将在其上运行的环境。“**steps**:” 将定义同步步骤：

* 第一步，从 Action 仓库调取[其它 action ](https://github.com/mdecoleman/pr-branch-name)检索 **“pull request name”** 以便下一步使用。
* 第二步，我们将初始化应用程序并运行测试。如果测试运行成功，则继续下一步 action。
* 接着使用 curl 命令调用 **AppCenter API**，为相应的分支名称配置构建。我们使用第一步中的分支名称来构建相应的 **URI**。

![](https://cdn-images-1.medium.com/max/2684/0*Pppq6J46U6HfxvIS)

* 最后，我们将为 iOS 和 Android 版本触发一个构建：

![](https://cdn-images-1.medium.com/max/2684/0*jazO_rGHuFgFg4y0)

要运行和测试工作流，只需打开一个 pull 请求。这将自动触发并运行 action。要查看结果，则可以转到项目库的 **“Actions”** 选项卡，选择相应的工作流并运行。

如果想更深入地使用 Github 操作并开始在多个项目库中管理大量工作流，那么可以随时尝试之前提到过的仪表盘解决方案[ Meercode](https://meercode.io/)。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
