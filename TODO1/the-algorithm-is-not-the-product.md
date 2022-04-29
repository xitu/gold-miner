> * 原文地址：[The Algorithm Is Not The Product](https://towardsdatascience.com/the-algorithm-is-not-the-product-2e0b3740bdfa)
> * 原文作者：[Ori Cohen](https://medium.com/@cohenori)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/the-algorithm-is-not-the-product.md](https://github.com/xitu/gold-miner/blob/master/TODO1/the-algorithm-is-not-the-product.md)
> * 译者：[fireairforce](https://github.com/fireairforce)
> * 校对者：[Shuyun6](https://github.com/Shuyun6), [司徒公子](https://github.com/stuchilde)

# 算法不是产品

## 为什么我认为数据科学家应该更多地学习怎样制作好的产品

![A man looking at a whiteboard, [pixabay](https://pixabay.com/photos/startup-whiteboard-room-indoors-3267505/).](https://cdn-images-1.medium.com/max/2000/0*9aCTQ8j7DiGTAZjj.jpg)

我在行业内学到的第一个教训就是，即使我们构建了极其复杂的算法来解决特定的问题，这些工具还是要被一些客户来使用。 因此无论是内部的算法还是外部的用户体验，客户需要的不仅仅是一段精心构造、打包和部署的代码。

换而言之，产品不仅仅是个算法，它是一个能让你的用户从中获得巨大价值的完整体系。构建一个以算法为核心的产品并不是件容易事情，它需要产品经理、开发人员、研究人员、数据工程师、DevOps、ui/ux 等团队之间的合作。

构建一个产品依赖于研究方法，你反复假设（基于先验或后验知识）、衡量、推断见解和调整产品，直到它适合产品市场。这是一场与未知世界的无休止的战斗，除了过程，你可能一无所获。当然，过程越好，你就越有可能得到一个好产品。

**但是，往往我们倾向于忘记。**

以下是应重点强调的几点，即在这种情况下，除了考虑数据科学方面之外，我们还需要重视产品的情况。

## 面试

在面试一个新的数据科学家（DS）的时候，我们通常会询问过去的研究、算法、方法，并提出一个看不见的、需要候选人亲自动手解决的研究问题。

作为招聘经理，我们真的应该考虑从 DS 的角度问一些与产品相关的问题，我们应该看看应聘者的研究作业，问一些相关问题，比如求职者为什么要做出与产品相关的数据或算法决策。例如，询问与产品问题相关的特性工作选择。例如“为什么他们会选择将特征 X 包含在 Y 中”或“为什么他们选择用一种特定的方式去处理特征 Z”之类的决策。

## 初始模型

对于许多组织来说，第一个应该投入生产的模型是最简单的算法，通常被描述为“基于规则”的模型或“80-20”模型。在进入研究阶段之前，放入这样一个基本模型的动机，通常是为了让开发人员、DevOps 和其他团队为新模型创建一个支持性的基础架构，然后 DS 将工作在一个“真实的”模型上，以取代临时的替代者。

从 DS 候选人那里听到这个想法，或者让当前的 DS 们来执行它是非常重要的。它显示了对一个组织需要提前做好准备的深刻理解。它允许 PM 们并行地促进和推进相关的任务，允许我们更加敏捷，并鼓励非产品人员理解产品。

## 模型决策

有一些考虑应该由候选人提出，或者由你自己的数据科学家进行实践。训练一个 **balance = true** 的算法，以使不平衡的数据集正则化，这是一个数据科学家应该做出的产品决策。他应该问产品经理，这些类对于手头的问题是否同样重要，还是我们希望在更大的类中变现得更好？ 

这类问题使我们在面试过程中应该问应聘者的一些重要问题，在问完他是否能描述他所知道的关于平衡类的所有方法（过采样、欠采样、损失正则化、合成数据等）之后，我们也应该在面试过程中立即询问候选人。
我也简单讲一下[这里](https://towardsdatascience.com/data-science-recruitment-why-you-may-be-doing-it-wrong-b8e9c7b6dae5)。

## 和 PM 合作

在我们数据科学（DS）领域，我们与产品经理（PM）紧密合作，共同实现我们梦寐以求的目标。我们与不同的团队都有许多摩擦点，但最重要的还是与 PM 的摩擦点，如下图所示。

![Figure 1: a proposed flow for when working side by side with business and product](https://cdn-images-1.medium.com/max/3010/0*dboBm1rJIqrZ7Sla.png)

考虑一个需要达到或者优化的业务产品（BP）KPI 和一个需要找到适当的 DS-KPI 的数据科学家，DS-KPI 最大限度地为 BP-KPI 服务。这是我们面临的最大挑战之一，但经常被所有利益相关者忽视。上图显示了一个允许迭代研究的工作流，以便优化这两种 KPI 类型，允许与业务、产品和数据科学进行协作。
你可以阅读更多关于[我管理这个摩擦点的方法](https://towardsdatascience.com/why-business-product-should-always-define-kpis-goals-for-data-science-450404392990)。

## 不要迷恋你的算法

我们在完善算法算法方面进行了乏味的工作，以确保算法能正确地进行优化，但是，很多时候，系统中的某个人改变了主意或没有适当的研究市场，并且你为服务于某个功能而构建的算法不需要或没有按预期执行。一个常见的错误是推动、尝试修复或重新利用算法。但是，根据新产品的要求，最好采用一种新算法从头开始做起。这将使你从以前的约束中解脱出来，并且对组织内的团队具有良好的战略意义。

---

我希望这些想法能让专业的数据科学家们在开始一个新项目或为一个产品添加新功能时对产品管理进行更多的探索，变得更加灵活，并有望帮助企业经理、产品经理、数据科学家和研究人员之间的复杂关系。

我要感谢我的同事，[Natanel Davidovits](https://towardsdatascience.com/@ndor123) 和 [Sefi Keller](https://medium.com/@sefikeller) 校验这篇文章。

---

Dr. Ori Cohen 拥有计算机科学博士学位，主要研究机器学习。他是 New Relic TLV、AIOps 领域的实践机器和深度学习研究的首席数据科学研究员。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
