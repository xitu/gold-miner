> * 原文地址：[Solutions Architect Tips — The 5 Types of Architecture Diagrams](https://betterprogramming.pub/solutions-architect-tips-the-5-types-of-architecture-diagrams-eb0c11996f9e)
> * 原文作者：[Allen Helton](https://medium.com/@allenheltondev)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/solutions-architect-tips-the-5-types-of-architecture-diagrams.md](https://github.com/xitu/gold-miner/blob/master/article/2021/solutions-architect-tips-the-5-types-of-architecture-diagrams.md)
> * 译者：[洛竹](https://github.com/youngjuning)
> * 校对者：[PassionPenguin](https://github.com/PassionPenguin)、[Zz招锦](https://github.com/zenblo)

# 解决方案架构师技巧：架构图的 5 种类型

![图源 [Kelly Sikkema](https://unsplash.com/@kellysikkema?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)，上传至 [Unsplash](/s/photos/draw?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText).](https://cdn-images-1.medium.com/max/2396/1*MN6xL8rToYH0n5ZOqr_2tA.jpeg)

你是否曾经在会议中，有人试图解释一个软件系统如何工作？

我与一位解决方案架构师新手进行了一次对话。他试图描述他们提出的一个大约有八个不同组件的系统，而这些组件都以多种方式相互作用。

他们用手势和大量的 “这块和这块之间通过…… ” 来解释解决方案。

我能听懂他们嘴里说的每个字，但是把这些字连起来我什么都没弄明白。

在解释复杂的架构概念时，口头表述显得苍白无力。我一边跟着思路走，一边试图建立一个心理模型。我需要一个画面感。

我需要**一张图表**。

但不是说一张图就可以走遍天下。架构图并不是一个“一刀切”的解决方案。

我们最近讨论过，[作为一个解决方案架构师](https://betterprogramming.pub/how-to-switch-from-software-developer-to-solutions-architect-5e0c12bdc4b1) 的一个重要能力是将你的想法有效地传达给技术和非技术受众。

你的图表必须考虑到这一点。如果你想把你的想法传达给不同的人群，你必须制作多个版本的图。

今天，我们将讨论你应该根据五个不同的受众制作的五种不同类型的图表。

我们将讨论一个业务是假想的但 API 是真实的例子：[无限地鼠洞](https://github.com/allenheltondev/gopher-holes-unlimited)，我们在系统中添加一个新的地鼠进行追踪。

## 1. 流程图

你可以制作的最通用、一般来说影响最广的图是流程图。它是一个中高层的图，可以展示工作流的所有部分。

该图说明了业务流程中的流动部分。

![图片由作者提供](https://cdn-images-1.medium.com/max/2000/0*ZUyEi9v9becFhGfp.png)

### 受众

这种类型的图的受众通常是技术人员。它可以用来向架构委员会介绍一个想法，或者向开发人员描述一个业务流程如何工作。

### 注意事项

**架构流程图**的主要内容是包含所有流动的部分。在 [无服务器 AWS 环境](https://betterprogramming.pub/serverless-you-keep-using-that-word-i-do-not-think-it-means-what-you-think-it-means-c7d5516a5ecc) 的案例中，我们标注了每个托管服务以及服务之间的通信。

虽然没有描述这些部件之间如何交互的细节，但是图中确实显示了这些连接。它显示了数据如何在系统中流动。

## 2. 服务图

服务图从高层次上说明了连通性。它并不显示工作流或服务如何工作的任何细节，而是显示了发挥作用的主要部分。这是一个旨在显示应用程序中使用的内部与外部服务的图。

![](https://cdn-images-1.medium.com/max/2000/0*hgdP8Dhm9taCxsec.png)

### 受众

IT 和网络工程师往往对这种类型的图最感兴趣。他们关心你与外部服务的任何连接。另外，他们需要知道是否有任何内部连接需要被监控。

我经常用这种图来向高管们描述系统的工作原理。他们想知道主要应用程序之间的连接，没有什么比服务图更好地表示这些连接了。

### 注意事项

在构建**架构服务图**时，最好列出构成你的应用或生态系统的所有微服务。标明哪些服务之间相互通信，并确保区分你公司拥有的服务和外部的服务。

关于服务如何工作的细节对于这个高级图来说是不必要的。这是所有关于使应用程序运行的服务。

## 3. 角色图

重要的是要表明你的架构需要解决的业务问题。角色图描述了一个按时间顺序排列的视图和特定工作流中的角色。这是证明你在构建解决方案时已经考虑了业务因素的最佳工具。

![](https://cdn-images-1.medium.com/max/2000/0*YS49oSULHmzUvx2L.png)

### 受众

面向企业的个人和产品所有者是这类图的目标受众。他们关注的是角色以及他们如何与系统互动。向他们展示一张**谁做了什么**和**在什么时间做**的图，它将完美地描述你的系统正在做什么。

### 注意事项

**架构角色图**对 [BPMN 模型](https://www.bpmn.org/) 进行了一些尝试。利用泳道来显示工作流中的不同角色。这种类型的图往往是偏底层的，因为它比其它图包含更多的细节。一定要标明角色、工作流，以及关于业务流程如何从一个步骤到另一个步骤的所有假设。

这些图还可以帮助那些刚接触一个领域的开发人员，并为他们将要构建的东西提供深刻的上下文。

## 4. 基础设施图

基础设施图是一个“所见即所得”的模型。它代表了已经实现的一切。它是一个偏底层的图，旨在包含服务、应用、生态系统中存在的一切。

这个图的目的是显示已经建立的东西和系统当前的工作方式。可以把它看作是你所构建的应用程序的**蓝图**。

![](https://cdn-images-1.medium.com/max/2000/0*fHIrAhbsy8vjXtrC.png)

### 受众

基础设施图的受众不同。它可以用来向开发人员展示他们在特定微服务中必须使用的东西。它也可以用来向客户展示你的公司为完成一项任务而使用的所有资源。

技术人员将是你的基础设施图的主要受众。由于你提供的是一个清单，而不是传达想法或业务流程，所以这个图的预期用途仅限于信息。这是为那些喜欢 “细枝末节” 细节的人准备的。

### 注意事项

在构建**基础设施架构图**时，不要漏掉任何一块。这种类型的图的目标是显示你的应用程序中的所有内容以及它们如何连接。你不需要在**如何**上做得太过详细，而是专注于让你的应用的所有部分都包含在图中。

## 5. 开发者图

当你需要开始着手处理问题时，开发者图将是你最好的选择。它包括了开发人员为了构建解决方案所需要的一切。

我们的目标是回答任何可能通过查看**流程图**出现的问题，并在设计中包含它们。这是一堆图中最底层的图，目的是为了在你不在场的情况下传达想法。

有人应该能够读懂这张图，并确切地知道该怎么做。

![](https://cdn-images-1.medium.com/max/2000/0*Ph0P0a9JRdHqDDlN.png)

### 受众

实现落地方案的开发人员是该类型图的受众。图中所包含的详细程度对于你团队以外的人来说是不必要的。有时，对于不需要细节的受众来说，太多细节可能是件坏事。

向开发团队以外的人提供实施细节就是一个过于详细的例子。它导致分散注意力，并掩盖了你试图传达的其他信息。

### 注意事项

开发者架构图本质上是补充了细节的**流程图**。用你能想到的任何具体的实现细节来标注每一块，并且一定要标注重要的转换。

这种类型的图并不能取代用户故事，但它确实有助于增强用户故事，增加整个开发团队的理解。当你可以使用它们的时候，因为当实现完成后，你将有一个有用的在未来可以参考的材料。

## 总结

架构图有很多类型。每一种都有独特的目的，很多都服务于不同的受众。作为一个解决方案架构师，你必须能够在推销你的想法时，向正确的人提供正确类型的图表。

通常情况下，一个版本的图是不够的。当我开始一个新的设计时，我总是从**流程图**开始。我把所有的想法都写下来，然后把它推荐给其他系统架构师。一旦我们就解决方案达成一致，我就会拿着这个图，把它变成一个**角色图**，然后拿给业务人员。

当我得到业务人员的签收后，我就可以自由地做出**开发人员图**和**服务图**。服务图是给高管的，以确保他们对我们正在做的事情有一个高层次的看法。开发者图是给将要落地解决方案的工程师的。

一旦解决方案构建完成，我们就可以更新**基础设施图**，以继续新的工作。

一张图片胜过千言万语，但当涉及到架构图时，它们可能胜过五千张。能够让人们快速、轻松地理解你的想法，是成为一个优秀的解决方案架构师的关键。

有了为不同的受众构建不同类型的图表的能力，你就能为自己的成功做好准备。

> **P.S. 我总是使用 [draw.io](https://draw.io/) 来构建我的图表。这是一个免费的工具，为我们提供制作漂亮的各种各样的图表、模型所需的所有东西。**

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
