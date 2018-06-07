> * 原文地址：[How to avoid opinion-based product prioritization](https://medium.com/googleplaydev/how-to-avoid-opinion-based-product-prioritization-d398fd047ab7)
> * 原文作者：[Tamzin Taylor](https://medium.com/@tamzint?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-avoid-opinion-based-product-prioritization.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-avoid-opinion-based-product-prioritization.md)
> * 译者：[Yuze](https://github.com/bobmayuze)
> * 校对者：

# 如何避免拍脑袋想出的产品优先策略

## 在看老板的脸色之外，其实我们还可以利用数据来做出更好的决策

![](https://cdn-images-1.medium.com/max/800/1*1QtpBve99bpwRN2PFAokjg.png)

最难的事情就是做决定。特别是在一个团队的事情，做决定有时候还需要考虑到很多其他的因素。有时候会有组织内部竞争者的意见，团队领导或是老板个人的看法，甚至有时候是自己想试试新的方案。大部分的时候 CEO，CFO， CXO 的意见是很难去拒绝的。

既然这是个常见性的问题的话，我们可以看看那些最成功的 App 开发者们是如何应对这样的情况的。

我采访了大约 20 个顶尖的开发者，他们当中有来自 Google 的工程师，产品经理，以及增长经理。从这些简短的采访中， 我总结出了 3 个重要的点：

*   他们都会通过实验来不断拓宽选择的可能性.
*   数据是整个过程中最重要的一环.
*   他们会在公司内部传播这个方法，并且和其他同事们分享相关的信息.

在这篇文章中，我会用2个例子来展示顶尖的开发者们是如何解决这些问题的。在第一个例子里面，我很荣幸的有机会能采用 Google 内部经常采用的方法论在 1tap 的这个产品上做决策。第二个例子里，我甚至还有机会和 2017 年度优秀 app Memrise 团队交流，得到他们团队对这个方法论的看法。

### 1tap 和北极星方法


[北极星方法](https://www.forbes.com/sites/forbesagencycouncil/2017/07/19/how-to-find-your-companys-north-star-metric/#58293ac830f8) 源于硅谷，并且已经有相对悠久的历史。在 Google 内部， Youtube 团队和 Gmail 团队经常用这个方法来帮助他们决定哪个特性应该被优先开发。根据我对他们的采访，我发现这样的方法论对于整个团队来说都是卓有成效的。我们在 Google 有专门的这么一支专业团队，所以我就顺水推舟地让他们和 1tap 团队合作来执行这个方法论。

说了这么久，这个方法论到底是什么呢？理念上来说它非常简单，只有 4 个重要的东西：一个指北系统，一个用户流的图，一个增长模型，还有一个简单的电子表格。毕竟，所有的数据模型都需要一个电子表格来作为载体。

那么接下来就让我们一起看看这 4 个东西是如何互相合作来帮助 1tap 解决问题的吧。

### 设置一个指北系统

这个指北系统其实就是一个类似于能够系统的衡量我们的工作对于整个公司，业务，亦或是计划的贡献。有点类似 KPI 的概念。比如说我们在做一个旅馆预订业务的应用的话，那么这个指标就是用户们预订的夜晚总数。如果我们在做一个即时通讯应用，那么这个指标就是发送的消息。

1tap 的愿景是为了让自我雇佣变的更加简单一个团队。他们在 Google Play Store 上有 2 个应用：用于自动提供自动数据提取和簿记功能的 [1tap receipts](https://play.google.com/store/apps/details?id=io.onetap.app.receipts.uk) 以及用于通过收据和账单来自动计算税务的 [1tap tax](https://play.google.com/store/apps/details?id=io.onetap.app.tax) 。

这一次，我们用 1tap receipts 来练习这个方法论。我们很快就决定了这次的指标是交易数量相关的内容。然而，1tap 的首席增长官告诉我们，我们需要先搞清楚我们是想要用户数量少但是单个用户使用的次数较多还是在用户量多的情况下每个用户使用次数比较少。显而易见，作为一个希望帮助人们的产品，我们希望单个用户数量为优先，而且越多越好。

### 定义你的用户流

![](https://cdn-images-1.medium.com/max/800/0*7B9lSgNbH6rkQmH3.)

这一步主要分成两步。首先，确认你开发的应用能够给你用户的反馈。第二，确认你的指标并且弄清楚你对于控制用户经过不同流的能力在哪里，并且画出一个流程图。这个过程非常简单，只要：

*   定义你应用里的关键事件。
*   画出不同事件之间的流是如何运作的。
*   运用统计学来观察用户们在每个流停留的比例。

你会发现这个图有 3 个主要的部分：你对新用户的获取，旧用户的回归率，以及整个产品的关键事件流。

新用户的获取主要就是用户通过什么样的途径来下载你开发的应用。只要你确保你正确的设置了 UTM 标签在所有投放的链接之下，并且关联你的 AdWords 账户，你就能从 Google Play 的控制台里轻松看到你的新用户获取途径。

不过每个产品的用户流都是根据具体情况而定的。但是一般都会包括登陆，上线，转化率（如果这是个付费产品）。 大部分的时候，对于一个app来说会有一个你特别关注的神奇的时刻，也就是关键事件流
。这个东西很多时候就代表了这个指标，所以我们务必要包含它在指标里边儿。 

最后，还有 **重复流**，也就是引导用户返回app的东西。

当流程图完善的时候，整个团队里面的成员们就会知道要以什么为向导并且不同的交互是如何影响到这个指标的。

在 1tap 这个例子里，这个图是这样的：

![](https://cdn-images-1.medium.com/max/800/0*ihtNP20aIDYffxrn.)

你会发现他们没有任何用户流的分析。对于 1tap 这个应用和团队来说，认识到让用户感觉到惊艳的那个时刻才是最重要的。也就是用户激活阶段。Jon 表示很多用户都被 1tap 应用能够快速并且准确的 OCR 技术惊艳到了。

最终的用户流图是在迭代了 10 个版本之后才产生的。Jon 认为第一版的这个图简直就是一团糟。太过于细节导致整个图看起来很混乱。然后整个团队才一起努力简化那张图，并且把精力都放在重要的方面。更棒的是，整理这张图还让 1tap 的应用去除了很多冗余的功能。“如果这不是个关键点的话，我们也没必要放在 app 里面吧”，Jon 如是说到。

整理了图之后，1tap 团队发现他们在用户反馈方面有很大的问题。问题是主要出在用户在导出数据的时候。现在，他们虽然仍然处在试验阶段，但是保存这些报告的做法已经有效的帮助他们提升了用户留存率。

### **构建一个增长模型**

下一步就是构建增长模型了。我们会需要之前在北极星方法中找到的指标来决定我们应该怎么样去发挥我们的优势以及弥补我们不够完善的地方。

就像之前在构建用户流的图的时候一样， 1tap 第一版的增长模型非常的复杂，有大概 16 页纸那么长。但是，在去掉了无关紧要东西之后，可以总结为：

![](https://cdn-images-1.medium.com/max/800/0*qnlVKnZB8odmSPE-.)

这里的标题是每个用户处理的收据的数量，也就是我们最关注的指标。我们根据月活跃用户来对整个数量分层。

当他们刚开始编写 1tap 这个应用的时候，他们之前花了很多心思在数据分析上,几乎吧用户在这个应用上所有行为都进行了分析，并且这也是他们团队应以为傲的一点。然而，Jon 表示，他们的团队其实很多时候就是因为这个原因导致不知道从何处开始理解用户。因为可以参考的数据维度实在是太多了。但是这个增长模型能够很好的帮助他们通过找出北极星指标来做到这一点。

但是就如 Jon 所说的那样，这个增长模型的重点是能够帮助向 CEO 解释月活用户是从何而来的，也能帮助 CFO 思考收入是从何而来的。此外，产品还能通过使用这个体系来做更好的决定。

### 创建一个电子表格

这整个流程的最后一步就是把模型转化成一张电子表格，并且 **帮助我们评估我们的机会，从而观察这些机遇是如何帮助我们的产品增长的**。

你也许早就已经发现 1tap 的增长模型会变成一张巨大的电子表格。但是这种情况下，表格的尺寸是很重要的，下图就是 Jon 和他的团队称作“计算器”其中的一部分。

![](https://cdn-images-1.medium.com/max/800/0*Hmizl_Y7zhdMbNmU.)

有了表格之后，1tap 开始探索了十几天各种活动对于用户平均收据数量的影响。Jon 发现这么做的好处就是他们能看到微小的改变给团队带来的好处。比如当下载到注册的转化率提升 2% 的时候，收据的总数也增加了2％。对比之下，从注册到激活到转化的提升对于总数的影响只有 75%。

随后，1tap 团队决定把更多的重心放在让用户感觉到这是一款惊艳的产品之上，而不是用户的获取。

所以这个流程和模型为 1tap 带来了什么呢？

首先，这些东西让他们团队明白了他们在做什么，什么是重要的。CEO Nick 再也不需要每天都问月活是从哪里来的以及我们如何才能增加月活。一切都明明白白的写在模型里了。此外，产品对于之后的需求也更加明确，知道如何制定优先级。现在所有决定都由这个“计算器”来做。CFO 也能知道通过增加收入我们还能提升用户的留存。基本上每个人都对团队下一步的动作能有所感知。

另外一个重要的就是这个模型帮助他们更好的理解了用户获取。过去他们是不可能有这样的机会的。现在他们明白了通过和第三方合作去做一些登陆能有效的大量提高用户获取，并且提高用户留存。

最后，Jon 还表示，这个模型还帮助了他们团队知道什么时候应该要雇用什么样的人。过去他们常常在错误的时间雇用不适合的人导致团队发展缓慢。

### Memrise

[Memrise](https://play.google.com/store/apps/details?id=com.memrise.android.memrisecompanion&hl=en_US)，作为一款语言学习应用，拥有 3500 万的用户，并且能过为他们提供超过200种语言的教学。Kristina Narusk，他们的首席增长官，认为这家公司的成长路径是非常幸运的。他们有 Ed Cooke 这样同时具备创新能力又能很好的运营团队的人作为 CEO。Ed 经常有各种各样的奇思妙想，但是同时，分辨这些想法中哪些能为产品真正带来增长也是非常有挑战性的事情.

举个例子，Kristina 告诉我三年前的一天，她收到一条来自 Ed 的短信。内容是说他在英国买了一辆双层巴士，决定在欧洲环游并且录下不同国家的不同语种母语人士说一些话的方式。这是一种非常罕见的事情，所以我们整个团队不得不提出各种方案来面对这种奇葩的想法，并且把它和应用的增长结合起来。

Memrise 提出了一种六维验证法来过滤这些奇妙的想法：

1.  必须是可以迭代的。我们能够从一个简单的MVP开始不断迭代直到完善。
2.  有立竿见影的效果。当新的想法实现的时候需要能给我们带来直观的改变。
3.  有长远的效果。这个想法需要能在长期帮助我们的用户，而不是三分钟热度。
4.  必须可以量化。我们需要可以量化这个想法对产品的效果。
5.  可以落地，能够尽量覆盖大量的应用市场。
6.  和产品相关，并且是可以理解的。

![](https://cdn-images-1.medium.com/max/800/0*ZFEKyBCJ09866AjF.)

在探索未来新特性的时候，他们团队会用这个法则来决定开发什么而不开发什么。

就像 Kristina 所说的那样，我们需要大胆假设，小心验证。**Memrise 把产品的开发周期分为 4 个阶段：探索，定义，开发，和跟进。**

![](https://cdn-images-1.medium.com/max/800/0*zHlTtMJtB4hKpYoz.)


在探索阶段的时候，产品团队会画出 PRD，并且会有用户来测试这个新的想法。试验尝尝会包含比如设计，用户体验，内容方向相关的创新。举个例子，团队会找许多路人来测试，亦或者是一些在线的测试或者一些长期用户来测试新的特性。整个团队，包括设计师，语言学专家，以及开发者们。然而，Kristina 发现在测试产品的时候，很难让开发人员们保持冷静。他们总是会对用户不能正确打开新的特性而表示不爽。

在 Memrise Membus 这个案例中（就是上面开车环游欧洲的那个），在探索阶段的时候，大巴先开去了牛津拍了些视频来测试想法是否可行。而不是直接在整个欧洲拍摄。在牛津拍摄英语的视频就是这个想法的原型。然后发现那个视频的想法对整个产品带来的好处非常明显，而且成本很低。最后我们就敲定了这个方案。

当这个想法探索完毕之后，我们就到了 **定义**的阶段。这一阶段，我们会明确这个新的想法的功能以及如何和用户交互。同时，也会明确测试的细节比如：

*   测试的平台
*   目标用户
*   目标语言
*   测试周期长度
*   需要关注的东西
*   分析看板应该包括的东西

The data team gets involved too. They help make sure that the feature is built to capture the right data points, so that the product team can evaluate the feature’s impact. The videos were used to create a premium learning mode and offered as part of the Pro subscription. It was, therefore, important to understand the effect on the conversion rate to Pro from adding this mode to the English course. At the end of the stage, the whole team acts as jury, to give feedback on the product ideation and specing outcome.

Once everything is ready and set up, the development team start to **develop** the feature. Because the development team has been involved in the discovery and define phases, development is usually straightforward as many assumptions have been tested and there is more certainty about the business reasons for building the feature.

When development finishes, it’s down to the product manager to switch on the feature, so that the users will see what’s been built, and start the experiments.

With the new version of the app out, the team can move to the **follow-up** stage. At this point, the team will look to answer questions such as: How are the KPIs for the feature performing?What is the initial user feedback? What is the effect of the new release on the app ratings? Hopefully, as Kristina describes it, this is “the joyful moment of watching when and how the results come in.”

YouTube 视频链接：https://youtu.be/e2RPXKi4e90

At Memrise they have a standard set of metrics and graphs for every experiment that goes out. “The day after the release you’ll find us refreshing this page all the time,” says Kristina, “to see how the feature and the new idea is performing. In our team’s case, it shows you the joy and fun of seeing the results coming in and learning whether we built something super successful that people enjoy, or whether we need to go back to the whiteboard and start thinking again.” The Memrise Membus journey ended with a decision to add videos and a special _Learn with Locals_ mode to all languages.

### 结论

![](https://cdn-images-1.medium.com/max/800/0*QnrE1nsyWfxPFOlq.)

在这篇文章开始的时候我就已经说过做决定是困难的。远离拍脑袋做决定也许更加难。然而，通过分享这两个不同的做决定的方式，我希望我能帮你在为产品做决定这件事上有新的观感。重要的不是流程，而是让团队里的人都参与到这个流程里面来。最终在有数据的帮助下再作出重要的改变。

* * *

### **你的想法?**

如果你对决策制订以及优先级分级you自己的想法的话，欢迎你在下面评论，或者在[推特](http://twitter.com/googleplaydev)上给我们留言，并且关注我们分享的最新信息。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
