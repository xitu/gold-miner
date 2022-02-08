> * 原文地址：[How to improve your data structures, algorithms, and problem-solving skills](https://medium.com/@fabianterh/how-to-improve-your-data-structures-algorithms-and-problem-solving-skills-af50971cba60)
> * 原文作者：[Fabian Terh](https://medium.com/@fabianterh)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-improve-your-data-structures-algorithms-and-problem-solving-skills.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-improve-your-data-structures-algorithms-and-problem-solving-skills.md)
> * 译者：[司徒公子](https://github.com/stuchilde)
> * 校对者：[江五渣](http://jalan.space)、[xurui1995](https://github.com/xurui1995)


# 如何提升你的数据结构、算法以及解决问题的能力

![Source: [Arafat Khan]()](https://raw.githubusercontent.com/todaycoder001/public-images/master/img/20190904185737.jpeg)

这篇文章借鉴了我过去在学校一个学期的个人经历和挑战，当我进入学校的时候，我对任何 DSA（数据结构和算法）和解决问题的策略几乎一无所知。作为一名自学成才的程序员，我对一般编程会更加熟悉和舒适，例如面向对象编程，而不是 DSA 问题所需要的解决问题的能力。

这篇文章反映了我整个学期的经历，并包含了为了快速提高数据结构、算法和解决问题的能力而求助的资源。

## 面临问题：你知道原理，但是你被实际应用卡住了

我在学期初期的时候遇到这个问题，当时**我不明白我哪里不懂**，这是一个特别严重的问题。我对这个理论很了解，例如，什么是链表，它是如何工作的，它的各种操作和时间复杂度，它支持的 ADT（抽象数据类型），以及如何实现 ADT 操作。

但是，由于我不明白我哪里不懂，所以我无法确定我对它的理解和在实际应用中解决问题的差距。

#### 不同类型的问题

一个数据结构问题的例子：描述如何在链表中插入一个节点并说明时间复杂度。

这是一个算法问题：在旋转数组中查找元素并说明时间复杂度。

最后是解决问题的疑虑，我认为比之前两个问题的级别更高，这可能需要简要描述一个场景，并且列出问题的要求。在考试中，可能会要求你对解决方案进行描述。在编程比赛中，可能会要求你在不明确提供任何的数据结构和算法的情况下提交可运行的代码。换句话说，它们希望你能使用最适合的数据结构和算法来尽可能有效地解决问题。

## 如何提升你的数据结构、算法和解决问题的能力。

我主要使用三个网站来练习：[HackerRank](https://www.hackerrank.com)、[LeetCode](https://leetcode.com) 和 [Kattis](https://open.kattis.com)。它们非常相似，特别是前两个，但不完全相同。我发现每个网站的侧重点略有不同，每个网站都以自己的方式为用户提供最大化的帮助。

我将解决问题所需的技能大致分为：

1. 数据结构知识
2. 算法知识
3. 数据结构和算法知识的应用

前两个被视为”基元“或构建块，第三点就涉及如何将数据结构和算法应用于特定的场景。

#### 数据结构知识

在这方面，我发现 HackerRank 是一个宝贵的资源，它有一个专门用于数据结构的部分，你可以按类型过滤，比如数组、链表、（平衡）树、堆 ......

这些问题与其说是关于如何解决问题，不如说是如何处理数据结构。例如：

1. 数组：[数组旋转](https://www.hackerrank.com/challenges/array-left-rotation/problem)、[数组操作](https://www.hackerrank.com/challenges/crush/problem)
2. 链表：[反转链表](https://www.hackerrank.com/challenges/reverse-a-linked-list/problem)、[循环检测](https://www.hackerrank.com/challenges/detect-whether-a-linked-list-contains-a-cycle/problem)
3. 树：[节点交换](https://www.hackerrank.com/challenges/swap-nodes-algo/problem)、[二叉搜索树的验证](https://www.hackerrank.com/challenges/is-binary-search-tree/problem)

你明白了，有些问题可能永远都不会直接适用于解决问题。但它们非常适合概念性理解，这在任何情况下都是非常重要的。

HackerRank 没有可自由访问的”模型解决方案“，尽管讨论部分时常充满了提示、线索、甚至是可用的代码片段。到目前为止，我发现这些是足够的，虽然你可能需要在集成开发环境中一行一行地执行代码才能真正地理解某些内容。

#### 算法知识

HackerRank 也有一个[算法部分](https://www.hackerrank.com/domains/algorithms)，尽管我更喜欢用 [LeetCode](https://leetcode.com/problemset/all/)。我发现 LeetCode 上的问题涉及范围更广，并且我真正喜欢的是，许多问题的解决方案中都带有详解甚至是时间复杂度的说明。

从 LeetCode 上[点赞前 100 的问题](https://leetcode.com/problemset/top-100-liked-questions/)开始学习是一个很好地开始。以下是一些我认为很好的问题：

* [账户合并](https://leetcode.com/problems/accounts-merge/)
* [最长连续递增序列](https://leetcode.com/problems/longest-continuous-increasing-subsequence/)
* [搜索旋转排序数组](https://leetcode.com/problems/search-in-rotated-sorted-array/)

与数据结构问题不同，这里的侧重点并不是处理或操作数据结构，而是如何**做一些事**。例如：“账户合并”问题主要就是并查集算法的应用。“搜索旋转排序数组”问题提出了二分查找的变形。有时你会学习一种全新的解决问题的技巧。例如：“[滑窗窗口](https://www.geeksforgeeks.org/window-sliding-technique/)”解决方案用于“最长连续递增序列”问题。

#### 数据结构和算法知识的应用

最后，我使用 Kattis 来提升我解决问题的能力。[Kattis 问题归档](https://open.kattis.com/)中有许多来自不同渠道的编程问题，比如来自全世界的一些编程比赛。

由于没有官方的解决方案和讨论区（不像 HackerRank 和 LeetCode 一样），Kattis 令人非常沮丧。此外，测试用例也是私有的。我有一些少数待解决的 Kattis 问题，我无法解决它并不是因为我不知道解决方案，而是因为我无法找出 bug。

这是三个练习和学习网站中我最不喜欢的，我也并没有花太多的时间在上面。

## 其他资源

[Geeksforgeeks](https://www.geeksforgeeks.org) 是另一个对于学习数据结构和算法非常有价值的资源。我喜欢它提供各种语言的代码片段，通常是 C++、Java 以及 Python，你可以将其复制然后粘贴到集成开发环境中以逐行执行。

最后，还有值得信赖的老谷歌，它会让你在大多数时间里都能看到 GeeksForGeeks 和提供可视化解题的 Youtube。

## 结论

然而，归根到底，这条路没有捷径可走。你只需要一头扎进去，开始写代码、调试代码并且阅读其他人的正确代码，找出你错在哪、怎么错、为什么会错。这很艰难，但每次尝试都会变得更好，随着你变得更好，它也将会变容易。

我远没有达到我想要的水平，但我知道，当我启程时便注定路远迢迢。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
