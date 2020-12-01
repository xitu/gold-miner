> * 原文地址：[Applications of Some of The Famous Algorithms](https://levelup.gitconnected.com/applications-of-some-of-the-famous-algorithms-cdaecee58ed1)
> * 原文作者：[Shubham Pathania](https://medium.com/@spathania08)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/applications-of-some-of-the-famous-algorithms.md](https://github.com/xitu/gold-miner/blob/master/article/2020/applications-of-some-of-the-famous-algorithms.md)
> * 译者：
> * 校对者：

# 一些知名算法的应用

![Photo by [Kaleidico](https://unsplash.com/@kaleidico?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/10804/0*d-YSolz0sbA5uAkw)

#### 你了解这些算法的实际应用案例吗？

在读大学期间，我练习过一些知名算法，开启了学习编程的道路。我从未了解这些算法在实际工作中的应用。不过，我们学习这些内容，一定是有目的的，对吗？

如今作为一名软件开发人员，我常常在项目中使用这些算法。曾经为了得到一份工作而学习的算法，后来在实际工作中也有用武之地，这是一件非常有趣的事。

在本文中，我会分享这些算法的实际使用场景。初学者可以感受到学以致用的乐趣，有经验的开发者也可以借此加深印象。

---

我们来深入了解下。

## Fibonacci 数列

几乎所有的开发者都了解过 Fibonacci 数列相关的算法。[Fibonacci 数列](https://en.wikipedia.org/wiki/Fibonacci_number) 是这样的一组序列：0, 1, 1, 2, 3, 5, 8, 13, 21, 34......

你想过没有，这样的算法在现实世界有什么应用场景？

这个数列有几个有趣的特性。任意两个相邻的数之和等于下一个数。巧合的是，它可以用于英里跟公里之间的近乎精确的换算。

考虑将 Fibonacci 数列中的某个数作为英里数，它的下一个数就是近似的公里数。比如，8 英里约等于 13 公里，13 英里约等于 21 公里。

在 Fibonacci 数列的诸多特性中，投资者会用一些数的幂函数来预测股价。最著名的基于 Fibonacci 的投资模型是 [Elliot Wave Theory](https://elitecurrensea.com/education/elliott-wave-patterns-fibonacci-relationships-core-reference-guide/)。

## 回文算法

这也是一种常见算法，面试时会考到。回文是指正向读取和反向读取结果都一样的字符串。比如，radar、toot、madam，它们都是回文。

现在我们认为，除了考查逻辑能力外，这种算法也可能有其实际应用价值，但其实还不止于此。例如，它可以用于 [DNA 序列的处理](https://pubmed.ncbi.nlm.nih.gov/11700586/)。

如今，越来越多的 DNA 序列正被破解。DNA 序列的相关信息存储于分子生物学数据库。这些数据库未来会变得越来越大，越来越有用。因此这些信息需要高效地存储和交互。

CTW（上下文树加权法）可以把 DNA 序列压缩到每个符号小于 2 比特。我们知道，有两种典型的 DNA 序列结构，一种称为回文或反向互补，另一种是近似重复。

在对下一个符号编码前，程序会用哈希法和动态规划搜索 DNA 序列中的近似重复和回文。如果存在足够长度的近似重复或回文，程序会用相应的长度和距离来表示它。

## 二分查找算法

这种算法也可以称为半区间搜索法、对数搜索法，它是一种在已排序的数组种查找某个目标值位置的算法。

这种方法需要把中位数跟目标值作比较。目标值不在范围内的那一半被剔除，然后继续搜索剩下的一半，直至搜索到目标值或剩下的一半为空，结束查找。

由于避免了反复查找每个元素，缩小了查找范围，这是一种非常高效的算法。

程序员都了解，二分查找是一种又快又好的、在已排序列表中进行查找的方法。很多教材上都有使用二分查找的例子，但是在实际开发中，它有用武之地吗？

这种算法的实际应用案例之一就是验证用户凭据。你可能也了解过百万用户级别的应用如何在几秒内进行用户凭据的验证。有了二分查找算法才能实现它。

二分查找到处都会用到。任何语言（Java、.NET、C++ 等）都可以创建已排序的集合，它们都可以使用（或选择使用）二分查找法来搜索相应元素。

## 合并排序算法

合并排序是一种基于**分而治之**思想的排序法。它的两个基本原理是：

* 对元素少的数组排序比对元素多的数组排序要快。
* 两个已排序数组的合并比未排序的要快。

合并排序一般用于小于某个值的约束。

电子商务网站通常有一个叫做**你可能喜欢**的版块。这里为每个用户保存一个列表。任何我们选择过的列表中浏览后回退次数最少的商品，都会进行推荐。

这是如今合并排序法应用得最普遍的案例之一。

## 阿姆斯特朗数

如果有一个数，其各个数位上的数的 n 次方之和等于这个数本身，这个数就称为阿姆斯特朗数。

例如，135 就是一个阿姆斯特朗数。

```
153 = (1)3 + (5)3 + (3)3
153 = 1 + 125 + 27
153 = 153
```

在实际应用中，没有直接的关于阿姆斯特朗数的应用程序，但阿姆斯特朗数在数据的加密解密中广泛使用。

---

这是一篇讨论阿姆斯特朗数在无线传感器网络中的应用的[论文](https://www.ijitee.org/download/volume-1-issue-1/)。该论文使用基于阿姆斯特朗数的安全算法，其中阿姆斯特朗数用于生成128位密钥，并在 [AES algorithm](https://en.wikipedia.org/wiki/Advanced_Encryption_Standard) 用于加密和解密。

## 结语

我们已经了解了这些最常见的算法的实际应用案例。很多人已是从事该领域工作的新手，却没有了解这些算法的应用价值。

---

在学习某些知识之前了解其应用价值是一个好方法，它有助于加深理解。其他有些算法，也颇有应用价值。我把这个话题留给你，让你去发现它们吧。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
