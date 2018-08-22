> * 原文地址：[The importance of Design QA in digital product design](https://uxdesign.cc/the-importance-of-design-qa-in-digital-product-design-c3f3d128270?ref=uxdesignweekly)
> * 原文作者：[Jess Eddy](https://uxdesign.cc/@jesseddy?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/the-importance-of-design-qa-in-digital-product-design.md](https://github.com/xitu/gold-miner/blob/master/TODO1/the-importance-of-design-qa-in-digital-product-design.md)
> * 译者：[lihanxiang](https://github.com/lihanxiang)
> * 校对者：

# 设计 QA 在应用程序设计中的重要性

![](https://cdn-images-1.medium.com/max/1000/1*VzeWB6aXXOFAXcy_whmHXA.jpeg)

完美的用户体验不是偶然事件。在应用程序的设计中，产品团队所作的一切都是为了用户体验；开发、设计、DevOps 和质量保证 —— 每一个角色都影响着用户体验，尤其是设计和用户体验之间的关系。自从我成为一个产品设计师之后，在我执着追求的事物中有着重要的一环，就是保证产品的设计能够按照预期实现。这是什么意思呢？它代表着设计方面的编码工作需要与实际中的设计完全匹配。

#### 这为什么如此重要？

一致性是优秀产品设计中的一个主要原则，随着时间推移，产品的设计和开发的不一致性会不可避免地出现。慢慢地，这些问题累积成了“设计负债”。

> **设计负债**影响着用户体验的完整性。当一些变数随着时间的推进不断出现，就会有设计与现实脱节、不一致并且一直处于补缺补漏的状态。 —— [设计负债](https://austinknight.com/writing/design-debt/)

虽然在每时每刻都能够完全解决不一致性问题是一件极具挑战的事，实行设计 QA 是打击设计负债的重要一步。

![](https://cdn-images-1.medium.com/max/800/1*upgX1rUDn8GHiGLHGnvegg.jpeg)

#### 设计 QA 会是一大挑战

**还有一些基本缺陷也能使设计质量保证成为挑战：**

*   团队或公司不够理解或不够重视设计，没能够创建一个足以产生优秀设计结果的环境 → **“该功能有效”**
*   人们没有意识到一个设计过的和一个编码不佳的版本之间的区别 → **“对我而言足够了”**
*   团队的重点研究对象是快速完成以及功能交付 —— 视觉完整性比编码更容易缩减 → **“我们没时间做这个”**

#### 速度 vs. 质量

为了说明最后一点，作为一个产品团队，他们常常冒险尝试**功能交付运输模式。**在“短跑”结束之前，团队通常会因为要完成某些功能而牺牲对大局的观念以及对细节的把握。在这场团队比赛结束之前，为了加快速度，设计相关的实现可能为了“节约时间”而让步。

![](https://cdn-images-1.medium.com/max/800/1*c2BMSom9UKNXvx3RX9ig0A.jpeg)

#### 协作是一件好事，但这不够

我之前有写过，[**团队合作**](https://blog.prototypr.io/design-driven-development-36a30dd8088c)和[**协作**](https://blog.sydneydesigners.co/tips-for-designers-developers-working-together-to-implement-great-uis-e93ef179bf13)是产品团队完成工作的必要条件.设计师和开发人员在概念阶段的共同设计，使用类似 Zeplin 这样的工具来搭建设计和 CSS 之间的桥梁并缩小差距；这些都很棒并且能对我们有所帮助，但这些方式并没有取代设计师在开始之前签署编码设计协议的传统方式。

**设计 QA 是这么来的！** ✨

![](https://cdn-images-1.medium.com/max/800/1*wOrbseW_894i4gxGpFRygQ.jpeg)

####什么是设计 QA

设计 QA **（QA = 质量保证）**仅仅是开发和测试之间的一个步骤。这是一个对于设计师的机会来做： 

1.  在测试之前先查看 UI 的编码版本
2.  与开发者一起在代码中对 UI 进行升级

或许你在一个小团队中工作，并且已经非常默契地进行了一些版本的设计 QA；又或许你在一家像 [Pivotal](https://medium.com/product-labs/how-designers-and-developers-can-pair-together-to-create-better-products-e4b09e3ca096) 这样的公司工作，设计师和开发者共同工作，设计 QA 已经被嵌入到工作流程之中。如果不是这样，设计实现的质量就很容易在开发中被忽略。

#### **将设计 QA 作为工作流程的一部分**

你的标准工作流程可能看起来有这些版本。如果你的团队在进行任何类型的工作时，将某项任务从开发周期的一个位置移向另一个位置，那么您的（设计）工作就是为这些任务而服务。

![](https://cdn-images-1.medium.com/max/1000/1*zkvxs-LNJ4o5mizlXsXtzQ.jpeg)

在这样的工作流程中，我们如何确保设计的完整性？当开发中的一个任务完成时，通常由这个任务的开发者或产品经理来将所完成的任务移至测试部门。当然，团队可以养成直接做一些版本的设计 QA，而不是在这个过程中进行的习惯，但是这将会失败；毕竟人们所忘记的或者自己做主的设计实现才是最好的。

> 更重要的问题是：如果设计实现是必要的，为什么我们不采取措施呢？

通过将设计 QA 作为工作流程中举足轻重的一个步骤，就能避免它被忽略。同样也需要认识到设计实现是团队需要重视的工作流程中的一个重要部分。当我们在工作流程中加入设计 QA 之后，上述的工作流程看起来就更像这样。

![](https://cdn-images-1.medium.com/max/1000/1*gGlwpzE6SICzhxuIBSj4EA.jpeg)

#### 让开发者加入设计流程

正如在编码时有设计师的加入一样，将开发者加入设计流程也同样重要。

> 设计和开发就像是一枚硬币的两面，它们彼此之间越独立，整个工作流程就越具有挑战性。

**为了让开发者加入设计流程中，你能这么做：**

*   在某项功能开始设计之前，讨论这项功能的要求，以确定可能影响设计决策的技术细节。
*   一起描述初始的设计解决方案
*   在工作中与开发者分享设计思想来获得反馈

在产品设计和开发中，我们遇到的大部分挑战都能通过相互尊重、积极沟通和心怀诚意来解决。

#### 享受工作!

![](https://cdn-images-1.medium.com/max/800/1*cNVE90I4t-UsLP-V0skdtA.jpeg)

#### 补充阅读

→ [**为什么要开发者和设计师一起工作**](https://www.dtelepathy.com/blog/business/developers-designers-should-work-together)

→ [**对于设计师与开发者一起实现优秀 UI 的一些提示**](https://blog.sydneydesigners.co/tips-for-designers-developers-working-together-to-implement-great-uis-e93ef179bf13)

→ [**设计师与开发者应如何沟通以创造更好的项目**](https://www.smashingmagazine.com/2018/04/working-together-designers-developers/)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
