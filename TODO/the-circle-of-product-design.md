> * 原文地址：[The Circle of Product Design](https://blog.prototypr.io/the-circle-of-product-design-6c78ade2010e)
> * 原文作者：[Francesca Negro](https://blog.prototypr.io/@francine.negro?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/the-circle-of-product-design.md](https://github.com/xitu/gold-miner/blob/master/TODO/the-circle-of-product-design.md)
> * 译者：[Ryden Sun](https://github.com/rydensun)
> * 校对者：[ryouaki](https://github.com/ryouaki) [Starriers](https://github.com/Starriers)

# 产品设计的环状循环

## In All Its Freudian Glory

我们只是简单的从A点走到B点，有时候都会变得混乱不已 —— 会考虑这条路是不是对的，我们走得是否是正确的方向，如果我们走捷径又会怎样等等这些问题。
但当A点是一个用户问题而且B点是一个实现的功能，这就像你用一张旧地图和一个坏的指南针在大海里航行。
这就解释了为什么按照一个严谨的流程 —— 即便时间很紧张 —— 也会是通往B点的关键因素，而且有着最多的信心和尽可能的与解决方案相关的数据 —— 并且 —— 会让以后的相同的工作变得简单一点（也为了以后的迭代建立详尽的文档）。

* * *

![](https://cdn-images-1.medium.com/max/1000/1*WEDplgz4D0kkDU_DzwseUA.jpeg)

文章中所有的过程都是 Freudian glory(弗洛伊德学说风格)（所有的插画都是我画的）

* * *

### **1.理解问题**

![](https://cdn-images-1.medium.com/max/600/1*JDwprV_DD-4C1t5Q4DflaA.jpeg)

问题也是需要被理解的。

首先，这个需求是如何被提出的？这是一个顾客的需求，是一个CEO的点子还是一个实现愿景的蓝图？理解需求从哪里提出的，无论它是在 Jira 上，或是邮件里，或是贴子里，这是最重要的。从用户的附加解释中，辨别出那些真正触发需求的问题一直都是困难的，并且是容易忽略的（让我们来面对它，减少时间的消耗）。

回溯到最开始的被触发的想法， 意味着需要确保我们设计的出发点是一个真实的问题，并且不是一个可能的解决方案。

从顾客关爱部门，CEO，首席产品官他们那里获取他们的想法，无论是谁 —— 就像产品设计的 Sigmund Fredu —— 深挖这些想法直到你找到来源，那个激发需求的最初始的事件。

### 2.调研问题并且收集数据

![](https://cdn-images-1.medium.com/max/600/1*ddePyPmVjgUEUlCTmEQaCA.jpeg)

调研这个问题是解决方案的一部分。

第二步意味着会变得很擅长打扰别人和搜索东西。一旦定位了那个事件（可能是童年的心理创伤或是客户的抱怨），那就是时候尽可能多获取这个问题的信息了。
其他人是怎么处理这个问题的呢？这是一个普遍的还是特殊的问题？我们有办法把这个问题分解成多个小问题吗？并且，最重要的，收集这个问题的数据。

即使我们在讨论一个全新的功能/或是产品还处于开发状态，还是会有相关的（某些程度上）度量方法来使用的。如果是对于一个已经存在的功能进行提升，他 _应该_ 是容易从分析中收集数据的或是 _应该_ 有任意的度量方法可以被执行的。

### 3.重新构想这个问题
![](https://cdn-images-1.medium.com/max/600/1*eWm3VEXR8OOb7lDylpD6dg.jpeg)

Blue steel ™.

根据目前所有的信息，对于问题和其存在于的背景应该比较容易的有一个更清晰的认识。 重新定义这个问题意味着需要从不同的视野和角度看待它（看一下 J.W. Getzels 在“Problem of the Problem”的工作和其创造性的问题解决），因此在收集过程中，从任何以前的偏见或者解释来破坏他的行为都可能会被加入。
所以，当最初的需求可能是“我们需要一个功能允许余额过低时转账给用户”（这就是一个需求包含解决方案的例子），促使产生这个需求的问题可能是“转账给用户太耗时而且需要不断地查看余额”。
这个问题的重新定义打开了通向解决方案的新道路（执行一个调度程序，亦或是余额过低时自动提醒）。

### 4.设计解决方案

![](https://cdn-images-1.medium.com/max/600/1*v7DtBmuit2zTHBNyJvG0Gw.jpeg)

Vitruvian 解决方案。

问题现在已经成功定位，而且数据是可以被投入到更广泛的产品背景中的。现在是时候把解决方案构建为“决定这些方法中哪个方法更适合解决这个问题”。出于这个目的，它可以适用于一系列问题：解决方案中应该有哪些功能 —— “用户应该能够设置自动提醒吗？” “用户应该能够引入事件吗？” —— 并且建立一个可能的解决方案实现列表。 目的是减少选项，形成一个可以用原型来测试的设想。
既然目的是测试这个设想，原型应该是理想化的以设想为中心，是从所有修饰和没必要的细节中剥离开来的，这些修饰和细节可能会在测试中让用户分散注意力。
在这一步，如果能和开发者或是任何将参与到过程中的人（如，整个设计团队，客户关心部门）进行交流就理想了，这样可以收集他们从自身角度出发关于解决方案的看法了。

### 5.测试解决方案

![](https://cdn-images-1.medium.com/max/600/1*ntzjOH6hIm8Iae6jICLQng.jpeg)

“我想知道为什么他们让我做一个数学测试”。

依靠现有的可用资源和时间，用户测试一直都是有挑战性和有必要性的。

即使资源很少，时间很紧，测试一个能代表大部分产品用户的用户样本是十分重要的，这更比测试一大群没有代表性的样本重要（参照 1936 年的 Literary Digest 案例）。

进行记录 —— 或者更好的办法是进行录音 —— 这是最详尽的办法来更方便的在一个用户体验研究员的帮助下进行访谈的总结（如果可能的话，或者至少有另外一个可以记录的人），为了能同时保证记录的质量和访谈的活跃度。

### 6.实现解决方案

![](https://cdn-images-1.medium.com/max/600/1*x9iGOrNVqpGhNBbeEfdmpQ.jpeg)

不适合3岁以下的小孩。

目前为止，设想被验证了没有？如果已被验证，什么是设计方案的痛点和长处？假设所有都进行顺利（设想被验证并且几乎没有痛点），这个原型应该变成真实的屏幕显示出，同时需求需要传递给开发者们。为了给未来迭代铺设道路，一个强制性的任务是定义哪些是功能点的KPI和绩效指标，这可能需要别的团队成员（市场人员，后端和前端开发人员）的帮助。

如果设想没有被测试，那就有必要回到之前的设计解决方案步骤，甚至是重新审视问题本身并且重新开始。

当设计一个复杂的解决方案时 —— 最有可能的是对于一个复杂的问题 —— 一个可能的策略是从实现解决方案的最简单版本开始， 接着不断增加复杂度最后发布。

### 7.运送这个功能

![](https://cdn-images-1.medium.com/max/600/1*cGhQi-bu3oMSW9VR4MhWsg.jpeg)

Arrrrrrrr!（语气词，类似啊啊啊啊啊啊）

好吧，这是很明显的。 赶快把他发布出去让世界知道他发布了。

### 8.密切关注功能点的成功

![](https://cdn-images-1.medium.com/max/600/1*-iS0o-6nsFu8RnRJjL4s5A.jpeg)

它有达到最好的效果吗？

如果所有事情都进行无误，现在应该可以收集度量数据了。
去客户关爱部门，告诉他们目前正在进行的功能的关注点，并且为用户反馈设置一条特权通道，这些反馈包含新功能的所有方面，这也是一个很好的监测进行情况的注意。

### 9.解决方案有解决问题吗？

![](https://cdn-images-1.medium.com/max/600/1*_4AplAayI8PgFIj-3H3xqQ.jpeg)

解决方案也需要理解。

功能已经发布而且用户已经使用了一段时间（几周或者几个月），根据流程和其他问题，现在是时候问一个问题：大多数用户有发现问题被这个方案解决掉了吗？

在理想的世界里，我们会举办大型的舞会和聚会来庆祝解决方案那简约而又灿烂的美丽，世界上的饥荒也会仅仅存在于记忆力，因为我们这个功能的问题解决能力。

现实中，不是每个人都会满意（用户和/或队友），别的问题也会出现，也可能是时候解决商业上的一些问题 —— 忽略整个过程 —— 我们可能会无法完成我们的目标。
因此，让我们在过程中保持信心，不断地重新开始（带着更多的内省）。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
