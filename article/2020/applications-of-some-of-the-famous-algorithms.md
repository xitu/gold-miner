> * 原文地址：[Applications of Some of The Famous Algorithms](https://levelup.gitconnected.com/applications-of-some-of-the-famous-algorithms-cdaecee58ed1)
> * 原文作者：[Shubham Pathania](https://medium.com/@spathania08)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/applications-of-some-of-the-famous-algorithms.md](https://github.com/xitu/gold-miner/blob/master/article/2020/applications-of-some-of-the-famous-algorithms.md)
> * 译者：[samyu2000](https://github.com/samyu2000)、[jaredliw](https://github.com/jaredliw)
> * 校对者：[zhuzilin](https://github.com/zhuzilin)

# 一些知名算法的应用

![图片由 [Kaleidico](https://unsplash.com/@kaleidico?utm_source=medium&utm_medium=referral) 发布于 [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/10804/0*d-YSolz0sbA5uAkw)

> 你了解那些知名算法的实际应用案例吗？

在我就读大学的时候，我曾经通过实践学习过大多数知名的算法，开启了学习编程的道路，但我从未试图了解这些算法在实际工作中的应用。不过，一定有外因驱使我们学习这些内容的，不是吗？

如今作为一名软件开发人员，我常常在项目中使用这些算法。那些我曾经为了得到一份工作而学习的算法，在后来的实际工作中也有用武之地，这可真是一件有趣的事。

在本文中，我会分享这些算法的一些实际应用场景。初学者们可以从中感受到学以致用的乐趣，而那些经验十足但开发者也可以借此加深印象。

---

让我们来深入了解下。

## 斐波那契数列

几乎所有的开发者都了解过斐波那契数列相关的算法。[斐波那契数列](https://en.wikipedia.org/wiki/Fibonacci_number) 是这样的一组序列：0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55 一直到无穷大。

你有没有想过我们能在什么实际场景下应用这个算法呢？

这个数列有几个有趣的特性。任意两个相邻的数之和等于下一个数。巧合的是，它可以用于英里跟公里之间的近乎精确的换算。

考虑将 Fibonacci 数列中的某个数作为英里数，它的下一个数就是近似的公里数。比如，8 英里约等于 13 公里，13 英里约等于 21 公里。

在斐波那契数列的诸多特性中，投资者会用一些数的幂函数来预测股价。基于斐波那契数列的一个著名投资模型是[艾略特波浪理论（Elliot Wave Theory）](https://elitecurrensea.com/education/elliott-wave-patterns-fibonacci-relationships-core-reference-guide/)（译者注：该理论认为市场走势不断重复一种模式，每一周期由 5 个上升浪和 3 个下跌浪组成）。

## 回文算法

这也是一种常见算法，面试时会考到。回文是指正向读和反向读结果一样的字符串。比如，radar、toot、madam，它们都是回文字符串。

很多人认为，除了考查逻辑能力外，这种算法没有任何其他实际应用价值。但其实，它的价值远不止于此。例如，它可以用于 [DNA 序列的处理](https://pubmed.ncbi.nlm.nih.gov/11700586/)。

今时今日，我们了解了比以往更多的 DNA 序列。DNA 序列的相关信息存储于分子生物学数据库。这些数据库未来会变得越来越大，越来越有用。因此，这些信息需要高效地存储和交互。

CTW（上下文树加权法）可以把 DNA 序列压缩到每个符号小于 2 比特。我们已知 2 种 DNA 序列的特征结构；一种称为回文或反向互补，另一种则近似重复。

在对下一个符号编码前，程序会用哈希法和动态规划搜索 DNA 序列中的近似重复和回文。如果存在足够长度的近似重复或回文，程序会用相应的长度和距离来表示这段序列。

## 二分查找算法

这种算法也可以称为半区间搜索法、对数搜索法，它是一种在有序数组中查找某个目标值位置的算法。

这种方法需要把中位数跟目标值作比较。如果二者不相等，目标值不在范围内的那一半将被剔除，然后继续搜索剩下的一半，直至搜索到目标值或剩下的一半为空才结束查找。

这似乎是一种非常有效的方法，因为它避免了冗余的元素遍历，且有效地缩小了搜索范围。

程序员都了解，二分查找是搜索有序数据列表的一种很好的、很快速的方法。很多教材上都有使用二分查找的例子，但是在实际开发中，它有用武之地吗？

这种算法的实际应用案例之一就是验证用户凭据。你可能也了解过百万用户级别的应用如何在几秒内进行用户凭据的验证。有了二分查找算法才能实现它。

二分查找**无处不在**。对于任何一个语言（如 Java、.NET、C++ 等）中的已排序集合，你都可以看到它们使用了（或可以选择使用）二分查找法来搜索元素。

## 归并排序算法

归并排序是一种基于**分而治之**思想的排序法。它遵循两个基本原则：

* 对元素少的数组排序比对元素多的数组排序要快。
* 合并两个有序数组比合并无序的要快。

在使用归并排序时，一般会有数组大小上的约束条件。

电子商务网站通常有一个叫做**“猜你喜欢”**的版块。网站会将每个用户的选择存放在个别的数组中。系统将推荐与我们的数组翻转次数最少的用户所购买的东西。（译者注：用户的商品选择都会按照各自的喜好程度存放在数组中，之后，系统会与其他用户的数组按元素索引进行一一对比。元素相同次数越高，证明两个用户之间的喜好越相似。）

这是如今归并排序法应用得最普遍的案例之一。

## 阿姆斯特朗数

如果有一个数，其各个数位上的数的 n 次方之和等于这个数本身，这个数就称为阿姆斯特朗数。

例如，135 就是一个阿姆斯特朗数。

```
153 = 1^3 + 5^3 + 3^3
153 = 1 + 125 + 27
153 = 153
```

阿姆斯特朗数没有直接的实际应用，但它被广泛地用于数据的加密和解密的安全算法中。

---

这篇[论文](https://www.ijitee.org/download/volume-1-issue-1/)讨论了阿姆斯特朗数在无线传感器网络中的应用。该论文使用基于阿姆斯特朗数的安全算法。其中，阿姆斯特朗数用于生成 128 位密钥，并用于 [AES 算法](https://en.wikipedia.org/wiki/Advanced_Encryption_Standard) 的加密和解密中。

## 结语

在本文中，我们了解了一些常见算法的实际应用案例。我们中的许多人已经在初学者阶段时研究过它们，但却对其实际应用了解不多。

---

在学习某些知识之前了解其应用价值是一个很好的方法，它能帮助你加深对知识理解。除此之外，其他的一些算法也时常出现在我们的日常生活中。我把这个话题留给你，让你去发现它们吧！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
