> * 原文地址：[The limits of knowledge](https://towardsdatascience.com/the-limits-of-knowledge-b59be67fd50a)
> * 原文作者：[Samuel Flender](https://medium.com/@samuel.flender)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/the-limits-of-knowledge.md](https://github.com/xitu/gold-miner/blob/master/article/2020/the-limits-of-knowledge.md)
> * 译者：[Roc](https://github.com/QinRoc)，[lsvih](https://github.com/lsvih)
> * 校对者：[Zhengjian-L](https://github.com/Zhengjian-L)，[PingHGao](https://github.com/PingHGao)

# 知识的极限

![美国俄勒冈州的火山口湖（Crater Lake）(图片来源：Sebastien Goldberg，[Unsplash](https://unsplash.com/photos/L1Xqp235CYk))](https://cdn-images-1.medium.com/max/9678/0*CpmVADktVXeu5Jk2)

> 哥德尔，图灵以及关于我们能知道和不能知道什么的科学

在 17 世纪，德国数学家戈特弗里德·莱布尼茨（Gottfried Leibnitz）提出了一种机器，该机器可以读取任意数学陈述，并根据数学公理来判断其是否正确。但是，每个陈述都可以这样判定么？或者我们所能知道的东西是否存在着极限呢？这个问题被称为 **Entscheidungsproblem**（判定性问题）。

两个世纪后，另一位德国数学家戴维·希尔伯特（David Hilbert）乐观地宣布，判定性问题的答案必须是，是的，我们能并且会知道任何数学问题的答案。他于 1930 年在德国柯尼斯堡（Königsberg）的一次讲话中曾说：

> Wir müssen wissen — wir werden wissen.（“我们必须知道 —— 我们会知道。”）

但是我们会知道吗？

#### 数学的极限

历史表明希尔伯特的乐观主义是短暂的。同年，奥地利数学家库尔特·哥德尔（Kurt Gödel）通过证明他著名的**不完备定理（incompleteness theorem）**表明我们的数学知识是有极限的。

下面是理解哥德尔定理的简单方法。请考虑以下陈述。

**命题 S：此命题不可被证明。**

现在，假设在数学中我们可以证明 S 为真。但是这样一来，命题 S 本身将为假，从而不一致。好吧，那么让我们假设相反的情况，即我们无法在数学中证明 S。但这将意味着 S 本身为真，并且数学中包含至少一个无法证明为真的真命题。因此，数学要么不一致，要么不完备。如果我们假设它是一致的（命题不能同时为真和假），这只能得出数学是不完备的结论，即存在不能完全证明是真命题的真命题。

哥德尔（Gödel）对不完备定理的数学证明比我在此概述的要复杂得多，这从根本上改变了希尔伯特（Hilbert）所宣称的完整知识是可行的观点（“**我们会知道**”）。换句话说，如果我们假设数学是一致的，那么我们必然会发现无法证明的真命题。

例如，哥德巴赫猜想（The Goldbach conjecture），根据该猜想，每个偶数都是两个素数的和：

6 = 3 + 3
8 = 3 + 5
10 = 3 + 7
12 = 7 + 5，依此类推。

至今还没有人发现反例，如果猜想是真的，那也就不存在反例。得益于哥德尔的贡献，我们知道有无法证明的真命题，但不幸的是，我们没有办法找出这些命题。哥德巴赫猜想可能就是其中之一，如果是这样，那么尝试证明它就是浪费时间。

![Kurt Gödel（左）和 Alan Turing（右）(图片来源：[Cantor’s Paradise](https://medium.com/cantors-paradise/a-computability-proof-of-g%C3%B6dels-first-incompleteness-theorem-2d685899117c))](https://cdn-images-1.medium.com/max/5760/1*OEtkquO--eZVJAIt_dGvTA.jpeg)

#### 计算的极限

艾伦·图灵（Alan Turing）第一次了解哥德尔不完备定理时还是剑桥大学的研究生。在那段时间里，图灵忙于做一种机器的数理设计。这种机器可以处理任何输入并计算结果，与莱布尼茨几个世纪前所设想的相似。今天这些概念化的机器被称为**图灵机**，是现代数字计算机的蓝图。简单来说，图灵机可以看作现代计算机程序。

图灵当时在研究所谓的**停机问题**，可以描述如下：

**是否有一个程序可以确定另一个程序会停止（停机）还是不停（死循环）？**

图灵证明了停机问题的答案是“否”，即不存在这样的程序。与哥德尔的工作类似，他也是用“反证法（proof by contradiction）”证明的。假设存在一个程序 **halts()**，它能确定给定程序是否将停止。但是，我们还可以构建以下程序：

```python
def g():
    if halts(g):
        loop_forever()
    return
```

看看这里发生了什么？如果 g 成立，则 g 不成立；如果 g 不成立，则 g 成立。无论哪种方式，我们都将得到一个矛盾。**因此，程序 halts() 不存在。**

哥德尔证明了数学是不完备的，而图灵证明了在某种意义上计算机科学也是“不完备的”。某些程序根本不存在。这不仅是理论上的好奇：停机问题在当今的计算机科学中具有许多实际意义。例如，如果我们希望编译器为给定的程序找到最快的机器码，那么我们实际上是在尝试解决停机问题 —— 而我们已经知道该问题是无法解决的。

![一个复杂的蛋白质结构 —— 预测蛋白质如何折叠是一个 NP 问题（NP-problem）。(图片来源：[Nature](https://www.nature.com/articles/d41586-019-01357-6))](https://cdn-images-1.medium.com/max/2000/1*CZyv_a9CKoOQ1gzAliYdEQ.jpeg)

#### 知识的实际极限：P 与 NP 问题

哥德尔和图灵通过揭示存在着的一些根本无法解决的问题，证明了我们所能知道的在理论上存在极限。但是此外，还有其他问题是理论上可以解决，但是因为求解的时间太长了，而我们实际上无法解决的。这里我们将会说明 **P 问题和 NP 问题**的区别。

P 问题是可以在“合理的时间”内解决的问题。在这里，“合理的时间”的含义是“多项式（polynomial）时间”（因此称为 P）。求解这些问题的计算复杂性随问题输入规模的增长而倍数增加（想想乘法或排序问题）。

另一方面，NP 问题是无法在合理时间内解决的问题。NP 是非确定性多项式（non-deterministic polynomial）的英文缩写，它的含义是可以用多项式级的计算复杂度验证问题的一个解，但不能用多项式级的计算复杂度求解。求 NP 问题的解的复杂度是指数级的，而不是多项式的，这会产生巨大的实际差异。NP 问题的例子包括最佳调度，预测蛋白质的折叠方式，加密消息，解决数独难题，最佳包装（又称背包问题）或最佳路由（又称旅行商问题）。一些问题（例如找到函数的离散傅立叶变换）最开始属于 NP 问题，但由于开发了新的、巧妙的算法来简化求解，最终变成了 P 问题。

当今计算机科学领域中最大的未解之谜之一就是 P 与 NP 问题：P 是否等于 NP？换句话说，对于所有我们可以在合理时间内**验证**一个解的问题，我们是否能在合理的时间内**求**解？

P 与 NP 问题非常重要，因此被列入“[千禧年大奖难题（Millenium prize problems）](https://www.claymath.org/millennium-problems)”。如果找到答案，你会赢得一百万美元。再怎么夸大这个问题的重要性也不为过：P=NP 的世界与 P≠NP 的世界有着根本的不同。如果 P=NP，那么我们可以肯定地说，有一种更快的方法可以解决数独难题，或者预测蛋白质的折叠方式，我们只是还没有找到这种方法。毫无疑问，了解蛋白质的折叠方式会对现实世界产生全方面的影响，例如理解阿兹海默症的病理或治愈癌症。

如今，大多数科学家相信 P 不等于 NP，但是我们能确定吗？P 与 NP 问题本身可能类似于希尔伯特的 Entscheidungs 问题或图灵的停机问题：**这个问题可能根本没有答案。**

#### 参考资料和进一步阅读

* 《复杂》梅拉妮・米歇尔
* P vs NP 和动物园的复杂性（[视频](https://www.youtube.com/watch?v=YX40hbAHx3s)）
* 哥德尔不完备定理（[视频](https://www.youtube.com/watch?v=O4ndIDcDSGc)）

如果你喜欢本文，也可以查看以下内容：

- [如何减少错误 —— 用有限数据预测未来的贝叶斯指南](https://towardsdatascience.com/how-to-be-less-wrong-5d6632a08f)
- [偶然形成的轨迹 —— 在物理，金融和我们的生活中随机漫步](https://medium.com/swlh/trajectories-formed-by-chance-bc96c8e236a5)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
