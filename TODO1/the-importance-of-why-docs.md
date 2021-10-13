> * 原文地址：[The Importance of “Why” Docs](https://medium.com/better-programming/the-importance-of-why-docs-c8ffba0ea520)
> * 原文作者：[Bytebase](https://medium.com/@bytebase)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/the-importance-of-why-docs.md](https://github.com/xitu/gold-miner/blob/master/TODO1/the-importance-of-why-docs.md)
> * 译者：[Roc](https://github.com/QinRoc)
> * 校对者：[icy](https://github.com/Raoul1996)，[司徒公子](https://github.com/stuchilde)

# “为什么”文档的重要性

> 帮助未来的工程师们了解决定的来龙去脉

![Photo by [Emily Morter](https://unsplash.com/@emilymorter?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) on [Unsplash](https://unsplash.com/s/photos/why?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)](https://cdn-images-1.medium.com/max/10368/1*2KhDOt8Dgcq17b-8rlMsig.jpeg)

我们中的许多人曾经盲目地遵循我们所被告知的模式，认为那一定是做这件事情的正确方式。我们就这样照做了，而没有怀疑那个模式对于我们所处的特殊情形是不是最佳选择，或者那个模式从一开始就不够好。

在我们盲目照做的时候，我们放弃了学习和深化理解、专心工作以及最终提高技术的机会。甚至我们为其他同事树立了另一个照做的先例，而不是鼓励他们深入钻研。

## 女孩和鱼

![](https://cdn-images-1.medium.com/max/10944/1*mvAQ0v229MXNdrTWSglD1w.jpeg)

我最近听说了一则关于一个小女孩儿观察她的妈妈烤鱼的寓言：

> 一个小女孩儿正看着她的妈妈为晚餐做一条烤鱼。她的妈妈切除了鱼的头和尾巴，然后把剩下的部分放到了烤盘里。
>
> 这个小女孩就问她的妈妈：“为什么你要切下鱼的头和尾巴呢？”
>
> 她的妈妈想了一会儿，然后说：“我一直是这样做的呀。你的奶奶也是一直这么做的。”
>
> 小女孩对这个答案不满意，于是就去拜访了奶奶，想找出她在烤鱼前切掉鱼的头和尾巴的原因。奶奶想了一会儿，然后回答道：“我也不知道。我的妈妈一直是这么做的。”
>
> 于是小女孩和她的奶奶就去拜访了曾祖母，询问她是否知道这个答案。曾祖母想了一会儿，然后说：“因为我的烤盘太小了，放不下整条鱼。”

**——[ 来自 Ptex Group](https://ptexgroup.com/learned-story-fish/)**

女孩的妈妈切下了鱼的头和尾巴，因为她没有意识到小烤盘对曾祖母的约束才是需要这样做的原因。当她采用这个菜谱的时候，没有问“为什么”。曾祖母也没有意识到应该告诉她这样做的原因。结果，这个女孩儿的妈妈虽然也能够做鱼，但是她做鱼的方式不是最优的。她是在不了解的情况下做的鱼。

通过问“为什么”，这个小女孩儿可以自信地改变菜谱，因为她知道现在已经没有了当初小烤盘的约束。

---

## 在文档中问“为什么”

像这个小女孩一样，我们也想打破在不理解的情况下就做事的循环。为了实现这个目标，我们可以问“为什么”，然后把问题和答案记录在文档里。

代码可以告诉你一个软件系统是**如何**工作的。文档则告诉你这个系统**为什么**以这种方式工作。

> “代码告诉你做什么，文档告诉你为什么。” —— **Steve Konves 在 [Hacker Noon](https://hackernoon.com/write-good-documentation-6caffb9082b4) 写道。**

在我们编程的时候写下“为什么”可以：

* 减少在不理解的情况下就改动代码所引发的事故的数量。
* 减少花费在理解软件为什么这样编写上的时间。
* 在我们的团队中建立一种包含工匠精神和批判性思考的文化。
* 赋能我们的团队以更好地编程。

#### 什么时候记录“为什么”？

在你编写代码的时候，一直问自己：

> 是否有某些影响我工作的约束？
>
> 我在做的事情中有没有需要解释才能完全明白的？

这些约束可能和这些事情有关：

* 时间紧迫。
* 项目资源不足。
* 我们想要缓解的已知缺陷。
* 用户流量模式。

一些需要解释的编码方式可能是这样的：

* 我们为什么决定复制代码而不是复用代码？
* 我们为什么以这种顺序提交代码？
* 我们为什么要处理这种特别的极端情况？

把这些限制和解释一一记录下来。

#### 约束的案例

* 这个功能需要立即发布，所以我们接受较差的代码质量。
* 我们需要向后兼容我们的 iOS 应用到 1.1 版本，所以我们不得不传递这个额外的参数。
* 我们预计明天的负载会暴增 100 倍，所以我们增加了基础实例大小。
* 我们的团队只有三个工程师，所以我们只能支持一种技术栈。
* 我们的项目的需求不够清晰，所以我们暂时不更新这个功能。

#### 解释的案例

* 我们复制了博客模型，因为我们想要迁移到一个向后不兼容的模型。
* 我们在这里避免使用常用的 API，因为在我们这样的用例中，这个 API 会导致性能问题。
* -$200 的特殊账户余额意味着这是一个员工账户。

## 如何更容易地发现“为什么”

这篇文章的第二部分会讲述在日常工作中如何使用 Git 来捕捉和你的代码有关的“为什么”。

我们也会复盘 Bytebase 是如何让发现和分享团队工作中隐藏的“为什么”变得容易的。

## 参考资料

* [**撰写优秀的文档**](https://hackernoon.com/write-good-documentation-6caffb9082b4)

* [“Etsy 的关于不可变更的文档的实验”](https://codeascraft.com/2018/10/10/etsys-experiment-with-immutable-documentation/) 来自 Code as Craft
* [“我从鱼的故事获得的感悟”](https://ptexgroup.com/learned-story-fish/)来自 Ptex Group

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
