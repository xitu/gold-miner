> * 原文地址：[When a rewrite isn’t: rebuilding Slack on the desktop](https://slack.engineering/rebuilding-slack-on-the-desktop-308d6fe94ae4)
> * 原文作者：[Slack Engineering](https://medium.com/@SlackEng)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/when-a-rewrite-isnt-rebuilding-slack-on-the-desktop.md](https://github.com/xitu/gold-miner/blob/master/TODO1/when-a-rewrite-isnt-rebuilding-slack-on-the-desktop.md)
> * 译者：[cyz980908](https://github.com/cyz980908)
> * 校对者：[Ultrasteve](https://github.com/Ultrasteve), [githubmnume](https://github.com/githubmnume)

# 重建桌面端的 Slack 而不是重写

**新版本的 Slack 将面向桌面用户推出，从头开始构建，更快，更高效，易用性更强。**

![Photo by [Caleb George](https://unsplash.com/@seemoris?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/7936/0*cgkWRCMtQXti3jbA)

[普遍的观点](https://www.joelonsoftware.com/2000/04/06/things-you-should-never-do-part-i/)认为你不应该从头重写代码，这是个好建议。花时间重写已经被使用的东西，并不能使我们的客户的工作生活更简单、更愉快、更富有成效。运行代码也知道一些事情：通过数十亿小时的累积使用和数万个 bug 修复获得的知识是来之不易的。

不过，软件代码具有生命周期。Slack 的桌面版是我们最老的客户端，成长于我们公司早期的快速发展和试验阶段。在那期间，随着客户对产品的使用和期望的增长，我们一直在优化产品的市场适应性，并在不断的冲刺中跟上客户的步伐。

如今，经过五年多的快速发展，Slack 被数以百万计的人使用，他们所在的公司规模比五年前更大，处理的数据比我们刚开始时想象的还要多。多少可以预见，桌面客户端的基础开始出现一些内部问题。此外，技术格局已经偏离了我们在 2012 年底选择的工具（jQuery，Signals，以及直接操作 DOM），目前的程序趋向于采用可组合的接口和更干净的程序抽象。即使[我们尽最大努力保证敏捷](https://slack.engineering/getting-to-slack-faster-with-incremental-boot-ff063c9222e4)，但很明显，需要进行一些根本性的改变，才能发展桌面应用程序，并为下一波产品开发做好准备。

现有的桌面应用程序的体系结构有许多缺点：

1. **手动更新 DOM。** Slack 最初的 UI 是使用 HTML 模板构建的，每当底层数据发生变化时，都需要手动重建这些模板，这使得数据模型和用户界面很难保持同步。我们想采用 React，一个流行的 JavaScript 框架，它使这些事情更自动化，更不容易发生潜在错误。
2. **过多的数据加载。** 数据模型是“完整的”，这意味着每个用户会话都是通过下载与用户相关的**所有**内容开始的。虽然理论上很好，但实际上这对于大型工作空间来说过于昂贵，这意味着我们必须做很多工作才能使数据模型在用户会话过程中保持最新状态。
3. **多个工作空间有着多个进程。** 事实上，当登录到多个工作区时，每个工作区都在一个单独的 Electron 进程中运行 Web 客户端的独立副本，这意味着 Slack 使用的内存将比用户预期的多。

[前](https://slack.engineering/rebuilding-slacks-emoji-picker-in-react-bfbd8ce6fbfe)[两](https://slack.engineering/flannel-an-application-level-edge-cache-to-make-slack-scale-b8a6400e2f6b)个问题是随着时间的推移我们可以逐步改进的，但是，在一个  Electron 进程中运行多个工作区意味着要改变原始设计的一个基本假设，即一次只运行一个工作区。尽管我们为拥有大量空闲工作空间的人们做了一些渐进式的改进 [额外的改进](https://slack.engineering/reducing-slacks-memory-footprint-4480fec7e8eb)，但是真正解决多进程问题意味着从零开始重写 Slack 的桌面客户端。

## 一个接一个

[忒修斯之船](https://en.wikipedia.org/wiki/Ship_of_Theseus)是一个思想实验，这个实验考虑的是，当一个物体每一部分随着时间的流逝被逐个替换时，这个物体还会不会是原来的物体。如果一艘船上的每一块木头都被替换了，那么这是同一艘船吗? 如果一个应用程序中的每一个 JavaScript 片段都被替换了，它还是同一个应用程序吗？我们当然希望如此，因为这似乎是最好的做法。

我们的计划是：

* 保持现有的基本代码；
* 创建代码库的“新”部分，它是不会过时的，并将按照我们希望的方式工作；
* 逐步实现Slack的更新，逐步用新代码替代旧代码；
* 定义将在旧代码和新代码之间强制执行严格接口的规则，以便容易理解它们之间的关系；
* 并不断地在现有的应用程序中发布上述所有内容，用适合我们新体系结构的更新实现替换旧模块。

最后一步，对我们来说也是最重要的一步 —— 是创建一个新版的 Slack，它开始时不完整，但随着模块和接口的更新，逐渐向功能完整性发展。

去年的大部分时间里，我们一直在内部使用这个只有新版本的应用程序，现在它正在推广给客户。

## 最近

首先要做的是创建新的代码库。虽然这只是我们代码库中的一个新子目录，但它有三个由约定和工具强制执行的重要规则，每个规则都旨在解决我们现有应用程序的一个缺点：

1. 所有 UI 组件都必须使用 React 构建
2. 所有数据访问都必须假设成一个懒加载且不完善的数据模型
3. 所有代码都必须支持多工作区

前两条规则，虽然耗费时间，但实现相对简单。然而，转向多工作空间架构是一项艰巨的任务。我们不能期望每个函数调用都传递一个工作区 ID ，我们也不能只设置一个全局变量来说明当前哪个工作区是可见的，因为无论用户当前正在查看哪个工作区，程序内部仍然发生着许多事情。

我们方法的关键在于 [Redux](https://redux.js.org/)，我们已经在用来管理我们的数据模型。在 [redux-thunk](https://github.com/reduxjs/redux-thunk) 库的帮助下我们进行了一些斟酌，我们能够在 Redux 存储上模拟几乎所有的动作或查询，允许 Redux 围绕单个工作空间的概念提供一个方便的抽象层。每个工作空间都有自己的 Redux 存储区，其中包含所有内容 —— 工作空间的数据、关于客户机连接状态的信息、用于实时更新的 WebSocket —— 应有尽有。这个抽象围绕每个工作区创建了一个概念容器，而不必将该容器保存在它自己的 Electron 进程中，这正是过去客户端所做的。

有了这些认识后，我们就有了新的架构：

![](https://cdn-images-1.medium.com/max/2612/1*cTUr99NpvxHSZWHfdxu-Rw.png)

![**架构比较。** 右侧的新版本。](https://cdn-images-1.medium.com/max/2612/1*vzAu72QESmgToZY866HP8Q.png)

## 一个互操作性的遗留问题

关于这一点，我们有一个我们认为可行的计划和架构，我们已经准备好通过现有的代码库，对所有内容进行更新改造，直到我们留下一个全新的 Slack。所以只有最后一个问题要解决。

我们不能随便用新代码替换旧代码；如果没有某种类型的结构将新旧代码分开，它们将会无可救药地纠缠在一起，我们就永远不会有新代码。为了解决这个问题，我们在一个名为 legacy-interop 的概念中引入了一些规则和函数：

* **旧代码中不能直接引入新代码：** 只有已经“导出”以供旧代码使用的新代码才可用。
* **新代码中不能直接引入旧代码：** 只有已经“调整”以供新代码使用的旧代码才可用。

将新代码导出到旧代码很简单。我们最初的代码没有使用 JavaScript 模块化或导入导出。相反，我们将所有内容保存在名为 TS 的顶级全局变量上。导出新代码的过程仅仅意味着调用一个辅助函数，该函数使新代码可以在全局空间的一个特殊的 TS.interop 部分中使用。例如，TS.interop.i18n.t() 将调用我们新的、多工作区感知的字符串本地化函数。由于 TS.interop 命名空间只在我们的遗留代码库中使用，它一次只加载一个工作区，所以我们可以在后台对工作区 ID 作简单的查询，而不需要遗留代码担心它。

为新代码调整旧代码就没有那么简单了。当我们运行旧版本的 Slack 时，新代码和旧代码都会被加载，但新版本只会包含新代码。我们需要找到一种方法，在适当地利用旧代码同时不会在新代码中造成错误，并且我们希望这个过程对开发人员是尽可能透明的。

我们的解决方案称为 adaptFunctionWithFallback，它在我们的旧 TS 对象上运行一个函数路径，而且如果我们在仅使用新的代码的代码库中运行，可以使用这个函数。这个函数默认为空操作，这意味着如果底层旧代码不存在，那么试图调用它的新代码将没有任何效果 —— 并且不会产生任何错误。

有了这两种机制，我们能够认真地开始我们的更新新旧代码工作。旧代码可以在更新时访问新代码，新代码可以访问旧代码**直到**更新时。正如您所想的那样，随着时间的推移，新代码库中旧代码的使用越来越少，并且在我们准备发布时趋向于零。

## 将所有组合起来

这个新版本的 Slack 已经推出很长时间了，它包含了过去两年来一直致力于向客户不断推广的数十人的贡献。它成功的关键是我们在项目早期采用的增量发布策略：随着代码的更新和功能的重建，我们将它们发布给我们的客户。Slack 应用程序的第一个“新”部分是我们的表情符号选择器，我们在两年多前发布了它 —— 之后是频道侧边栏，消息窗格和许多其他功能。

如果我们等到 Slack 全部被重写后再发布它，我们的用户在发布一个“爆炸的”替代品之前，就会对表情符号、消息、频道列表、搜索和无数其他功能有着更糟糕的日常体验。增量发布允许我们尽快向客户交付真正的价值，帮助我们专注于持续改进，并通过最大限度地减少客户首次使用的全新代码量，降低了新客户的发布风险。

普遍的观点认为，最好避免重写，但有时好处也很大，不容忽视。我们的主要指标之一是内存使用情况，新版 Slack 提供：

![**内存使用率比较。** 右侧的新版本。](https://cdn-images-1.medium.com/max/5544/1*d_U8PJR0MA5q8CYddSc18A.png)

这些结果验证了我们在新版 Slack 中所做的所有工作，我们期待着继续迭代，并随着时间的推移使它变得更好。

在策略规划的指导下，以明智的发布为调和，以及有才华的贡献者的鼓舞，逐渐的重写是纠正过去错误、为自己打造一艘崭新的船的绝佳方式，并使您的用户的工作生活更简单，更愉快，更有成效。

## 敬请期待

我们热心于分享更多关于我们在此过程中学到的知识。在接下来的几周，我们将会在 [https://slack.engineering](https://slack.engineering) 上撰写更多文章：

* **Slack Kit**，我们的UI组件库
* **“Speedy Boots”**，推出这项工作的原型
* **易得性**，自营销而不是捆绑营销
* **Gantry**，我们的应用启动框架
* 以及大规模**推出的新的客户端架构**

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
