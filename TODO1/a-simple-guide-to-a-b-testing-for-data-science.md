> * 原文地址：[A Simple Guide to A/B Testing for Data Science](https://towardsdatascience.com/a-simple-guide-to-a-b-testing-for-data-science-73d08bdd0076)
> * 原文作者：[Terence Shin](https://medium.com/@terenceshin)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/a-simple-guide-to-a-b-testing-for-data-science.md](https://github.com/xitu/gold-miner/blob/master/TODO1/a-simple-guide-to-a-b-testing-for-data-science.md)
> * 译者：[Amberlin1970](https://github.com/Amberlin1970)
> * 校对者：[Jiangzhiqi4551](https://github.com/Jiangzhiqi4551)，[PingHGao](https://github.com/PingHGao)

# 一份数据科学 A/B 测试的简单指南

> 数据科学家最重要的统计方法之一

![Picture created by myself, Terence Shin, and Freepik](https://cdn-images-1.medium.com/max/2000/0*KS_jfZBdZ9DxAvEz.png)

A/B 测试是数据科学和科技界中最重要的概念之一，因为它是确定任意一个假设可能得出的结论最有效的方法之一。理解 A/B 测试并知道它的工作原理十分重要。

## 什么是 A/B 测试？

最简单的说法是，A/B 测试是基于一个给定的标准，判断实验中的两个变量哪一个的表现更好的实验。典型地，两个消费群体面对同一样东西的两个不同版本时，根据谈话、点击率又或是转化率这样的标准判断两个版本之间是否有很大的差异。

以上图为例，我们可以随机地将消费者分成两组，一个控制组和一个变量组。然后，我们可以给变量组展示一个红色的网站横幅，再观察网站的转化率是否会得到大幅提升。必须注意的是，在进行 A/B 测试时，所有其他的变量是保持不变的。

从更专业的角度讲，A/B 测试是一种统计和双样本假设检验的形式。**统计假设检验**是用于一个样本数据集和总体数据进行比较的一种方法。**双样本假设检验**是决定两个样本之间的差异是否具有统计意义的一种方法。

## 为什么一定要了解？

了解 A/B 测试是什么以及它如何工作是很重要的，因为它是量化产品变化或者市场策略变化时最好的方法。而这在由数据驱动的世界里变得日益重要，因为商业决策需要以事实和数字为依据。

## 怎样进行一个标准的 A/B 测试？

#### 1.提出你的假设

在进行一个 A/B 测试之前，你会提出你的零假设和备择假设：

**零假设**是指样本观察的结果完全出自偶然的假设。从 A/B 测试的角度讲，零假设是指控制组和对照组之间**无**差异。
**备择假设**是指样本观察被一些非随机的因素影响的假设。 从 A/B 测试的角度讲 ，备择假设是指控制组和变量组之间**有**差异。

在提出你的零假设和备择假设时，建议遵循 PICOT 格式。Picot 代表：

- 对象（**P**opulation）：参与实验的人群
- 干预（**I**ntervention）：指代研究中的新变量
- 对照（**C**omparison）：指代你计划用于和你的干预进行比较的参考组
- 结果（**O**utcome）：代表你预期的结果
- 时间（**T**ime）：指代整个实验的持续时间（何时开始收集数据及收集数据所花费的时长）

例子：“相较于对照组，干预 A 将会改善临床焦虑水平在 3 个月的癌症患者的焦虑水平（以 HADS 焦虑分量表标准的平均变化来衡量）。”

它（这个例子）符合 PICOT 的标准吗？

* 对象：有临床焦虑的癌症患者
* 干预：干预 A
* 对照：对照干预
* 结果：以 HADS 焦虑分量表标准的平均变化来衡量是改善了焦虑
* 时间：与对照干预组进行3个月比较

确实如此 —— 因此，这是一个强假设检验的例子。

#### 2.创建你的对照组和测试组

一旦确定了你的零假设和备择假设，下一步就是创建你的对照和测试（变量）组。在这一歩中有两个重要的概念需要考虑，随机采样和样本的大小。

**随机采样**
随机采样是指对象中的每个样本都有相等的选中概率的一种技术。随机采样在假设检验时很重要，因为它消除了抽样偏差。**消除偏差是很必要的，因为你希望你的 A/B 测试的结果能够代表整个研究对象而不仅是样本自身。**

**样本大小**
在进行 A/B 测试之前，必须要先设定好你的 A/B 测试的最小样本大小，才能消除由于太少样本而产生的**覆盖偏差**。有大量的[在线计算器](https://www.optimizely.com/sample-size-calculator/) 可以计算给定三个输入时的样本大小，如果你有兴趣了解这背后的数学原理请点击这个[链接]( https://online.stat.psu.edu/stat414/node/306/)！

#### 3.进行测试，对比结果，是否丢弃零假设

![](https://cdn-images-1.medium.com/max/2000/0*KIie8p4lPGVXfCgZ.png)

在你进行实验并且收集了你的数据后，你就要确定你的控制组和变量组之间的差异是否是统计显著的。如下几步可用于确定：

* 首先，你需要设定你的 **α** 值，出现 1 类错误的概率。通常 α 的值设定为 5% 或 0.05 。
* 其次，你需要利用上面的公式计算 t-统计量进而得出概率值（p 值）。
* 最后，对比 p 值和 α 。如果 p 值大于 α ，不丢弃空假设！

**如果上述内容对你没有意义，我将会花时间从[这里](https://www.khanacademy.org/math/statistics-probability/significance-tests-one-sample/idea-of-significance-tests/v/simple-hypothesis-testing)学习更多假设检验的知识！**

## 谢谢阅读！

如果你喜欢我的文章并且想支持我，请注册我的邮箱列表[这里](https://terenceshin.typeform.com/to/fe0gYe)！

## 参考

[**A/B 测试**](https://en.wikipedia.org/wiki/A/B_testing) 

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
