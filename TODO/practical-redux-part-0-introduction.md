> * 原文地址：[Practical Redux, Part 0: Introduction](http://blog.isquaredsoftware.com/2016/10/practical-redux-part-0-introduction/)
* 原文作者：[Mark Erikson](https://twitter.com/acemarke)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[luoyaqifei](http://www.zengmingxia.com)
* 校对者：[xuxiaokang](https://github.com/xuxiaokang)，[richardo2016](https://github.com/richardo2016)

# 实践 Redux，第 0 部分：简介


**基于个人经验的 Redux 技术总结系列的开端**

#### 系列目录

*   **第 0 部分：系列简介**
*   **[第 1 部分：Redux-ORM 基础](https://github.com/xitu/gold-miner/blob/master/TODO/practical-redux-part-1-redux-orm-basics.md)**
*   **[第 2 部分：Redux-ORM 概念和技术](https://github.com/xitu/gold-miner/blob/master/TODO/practical-redux-part-2-redux-orm-concepts-and-techniques.md)**

我在学习 Redux 上面花了很多时间，参考了很多不同的资料。我早期的学习大多来自读文档、搜寻在线教程以及潜伏在 Reactiflux 聊天频道里。当我更加熟悉 Redux 后，我在回答问题和研究如何帮助 Reactiflux、StackOverflow 和 Reddit 里的其他人上面获得了一些经验。在维护我的 [React/Redux 链接列表](https://github.com/markerikson/react-redux-links) 和 [Redux 插件目录](https://github.com/markerikson/redux-ecosystem-links) 的过程里，我尝试着找寻一些深入探讨在创建实际应用时遇到的复杂性和问题的文章，以及一些可以让大家能更好地编写 Redux 应用的库。最后，我也通过 Redux 仓库里茫茫多的 issue 和讨论来研究它（因此，我甚至成为了 Redux 的官方维护人员）。

除了所有的这些研究，我也花了去年的多数时间在我的工作应用里使用 Redux。在我开发这个应用的过程中，我遇到了各种各样的挑战，并在这个过程中开发出了一些有趣的工具和技术。既然我从别人的文章里学到了这么多，我也想开始回馈大家，分享一些我从自己的经验里学到的东西。

**这一系列关于「实践 Redux」的文章将包括我开发自己的应用时用到的一些小窍门、技术和概念**。因为我不能真把工作中开发的具体细节分享出来，所以我将创造一些实例场景来帮助我阐述这些想法。我将基于由 [Battletech 游戏宇宙](http://bg.battletech.com/) 中的概念衍生的实例进行讲解：

*   [Battlemech](http://bg.battletech.com/) 是一种飞行行走机器人，装备了各种武器，比如导弹，激光和自动枪。一个 Battlemech 有一个飞行员。
*   有多种不同类型的 Battlemech。每种类型有一个不同的尺寸和一套数据设定，包括它携带的武器和其它装备。
*   Battlemech 被组织成四个 mech 的小组，每个小组被称为 [“Lance”](http://www.sarna.net/wiki/Inner_Sphere_Military_Structure#Lance)。三个 lance 形成了一个「公司」。

随着系列的推进，我希望能够真正地开始创建一个小应用来展示一些实际工作环境中的例子。暂定计划是创建一个应用，追踪在虚拟的作战部队中服役的飞行员与其 mech，就像已有的 [MekHQ 游戏活动跟踪应用](http://megamek.info/mekhq)的微型版本。这些从 MekHQ 的截图展示了一些概念和我想要模仿的 UI：

*   [MekHQ: 可选飞行员清单和选定飞行员详情](https://sourceforge.net/p/mekhq/screenshot/Screen%20Shot%202012-09-25%20at%2012.19.38%20PM.png)
*   [MekHQ: mech 和飞行员在部队中的组织树](https://sourceforge.net/p/mekhq/screenshot/Screen%20Shot%202012-09-25%20at%2012.16.47%20PM.png)
*   [MekHQ: Battlemech 的细节和统计](https://sourceforge.net/p/mekhq/screenshot/Screen%20Shot%202012-09-25%20at%2012.23.30%20PM.png)

我当然**不**是想严格地重构一个 MekHQ，但是它（ MekHQ ）应该作为灵感和想法的源泉，我的例子将以它为基础而构建。

最初的两篇文章将讨论的是使用 Redux-ORM 库来帮助管理范式化状态的方法。这些文章里，我希望讨论到如何管理「草稿」数据（在编辑条目、建立树视图、表单输入或者其他情况下产生的数据）的方法。同时，我也计划着讨论一些不专属于 Redux 的话题。

如果你有回馈的话，我会很欢迎，不论是在评论里，在 Twitter 上，在 Reactiflux 里，或者是别处！
