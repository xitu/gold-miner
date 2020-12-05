> * 原文地址：[Demystifying the 0-1 Knapsack Problem](https://medium.com/better-programming/demystifying-the-0-1-knapsack-problem-56e7ac4dfcf7)
> * 原文作者：[The Educative Team](https://medium.com/@educative)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/demystifying-the-0-1-knapsack-problem.md](https://github.com/xitu/gold-miner/blob/master/article/2020/demystifying-the-0-1-knapsack-problem.md)
> * 译者：[Usualminds](https://github.com/Usualminds)
> * 校对者：

# 揭开 0-1 背包问题的神秘面纱

![Image credit: Author](https://cdn-images-1.medium.com/max/2048/1*q3OBnVDmaPAk__W_7n0cDA.png)

在你经历过的所有动态编程的面试里，可能经常会遇到 **背包问题** 。因为其解决方法复杂且问题变种数量多，所以常常让面试者感到焦虑。

今天，我们将探索两种流行的解决方案：**递归解决方案** 和 **自顶向下动态编程算法解决方案**，让你熟悉多语言中的背包问题。在本文结束时，你将自信地拥有解决背包问题所需的经验。

#### 这是我们今天要讲的

```
1.什么是背包问题？
2.暴力递归解决方案
3.优化的动态编程解决方案
4.接下来要学什么
```

## 什么是背包问题？

背包问题是计算机科学中最热门的动态编程面试问题之一。

问题可以这样描述：

![Image credit: Author](https://cdn-images-1.medium.com/max/4298/1*4b1qYRRYPnPvOhT5UIYP1g.png)

假设你是一个带着背包的小偷，你的背包可以容纳的总重量为 `capacity` 。 有多个（n个）不同的物品，每个物品都有固定的重量和价值。 重量和价值都以整数数组表示。 现在创建一个函数 `knapsack()` ，来找到这些物品的子集或数量，使它们的总价值最大，同时总重量不超过背包给定的值 `capacity` 。

## 背包问题变体

这个问题有两个主要的变体: **部分** 和 **0-1** 背包问题。部分背包允许你选取物品的一部分以最大化背包的价值。0-1背包不允许你选取物品的一部分。只能选取某个物品或者不选。

另一个常见的变体是 **约束** 背包问题，它限制了你的程序，使你不能选择多个物品。当一个物品被选中时，程序必须决定将其放置在背包中还是丢弃。

在更高级别的面试中，你会遇到增加体积作为另一个受限属性。这种情况下，每个物品都有一个固定的体积，背包也有一个体积限制。

## 它测试什么技能？

这个问题之所以受欢迎，是因为它一次性考察了很多必需的技能，并且可以通过改变维度，让面试者失去题目重心。换句话说，你必须真正理解问题和代码的逻辑。简单的记忆不会让你走得很远。

背包问题的最佳解决方案始终是动态编程解决方案。 面试官可以使用此问题来测试你的动态编程技能，从而深入了解到你是否为优化的解决方案而工作。

背包问题的另一个流行解决方案是使用递归。如果面试官重视这两种技能的话。他们可能会要求你使用递归和动态编程解决方案，这是一个很受欢迎的选择，因为面试官可以看到你从递归到动态解决方案之间的切换过程。

背包问题也测试你如何处理 **组合优化** 问题。这在工作中有许多实际的应用，因为所有的组合优化问题都是寻求在约束条件下的最大收益。

例如，组合优化用于解决以下问题：

* 确定在有限资源云系统上运行的最佳程序
* 优化固定管网的供水
* 自动计划最佳包裹运送路线
* 优化公司的供应链

上述问题你可能会被从事管理或自动化软件相关的面试官问到

## 暴力递归解决方案

这个问题最常见的解决方案是暴力递归。这个解决方案是暴力的，因为它计算所有可能子集的总重量和价值，然后选择在最大背包容量限制之下的具有最高价值的子集。

虽然这是一个有效的解决方案，但它不是最优解，因为其时间复杂度是指数级的。如果要求使用递归方法，请使用此解决方案。对于动态解决方案，这也可以是一个很好的起点。

**时间复杂度：** O(2^{n})O(2n), 由于有重复子调用的数量

**空间复杂度：** O(1)O(1), 不需要额外存储

## 解决方案

这是我们算法的直观表示。

**注意：** 所有红色物品的子集都超出了我们背包的容量；浅绿色在容量范围内，但不是最高值。

![Knapsack brute-force recursion](https://cdn-images-1.medium.com/max/4774/1*UvpCzvWCSHRRPdALmuXu0g.png)

![](https://cdn-images-1.medium.com/max/4956/1*C3g6sdkm2KnLWjtcqlMiIA.png)

---

## 说明

在第14行，我们从权重数组的开头开始，检查物品是否在最大容量内。如果是，我们递归地调用 `knapsack()` 函数并将结果保存在 `profit1` 中。

然后递归地调用该函数，排除该物品，并将结果保存在 `profit2` 变量中。在第21行，我们返回 `profit1` 和 `profit2` 中较大的一个。

#### 伪代码

这是该程序如何运行的伪代码说明。

```
对于每一项 'i' 从末尾开始
  如果总权重不超过背包容量，则创建一个包含 'i' 的新集合，并递归处理剩余的容量和选项
  创建一个没有 'i' 的新集合，然后递归处理剩余的项
 
从上述两个集合中返回收益更高的一个
```

这个程序包含许多重复的子问题，但它们都是每次进行计算而非存储。 重复计算会大大增加程序运行时间。 为了避免重复计算，我们可以改用动态编程来保存子问题的解决方法以供重用。

## 最优动态规划解

现在，我们将通过添加自上而下的动态编程来优化递归解决方案，以处理重复的子问题。

由于递归函数 `knapsackRecursive()` 中有两个变化的值（`capacity` 和 `currentIndex`），因此我们可以使用二维数组来存储所有已知子问题的结果。 如上所述，我们需要存储每个子数组（即每个可能的索引 `i` ）和每个可能的容量 `c` 的结果。

这是背包问题在时间和空间复杂度上的最优解。

#### 时间复杂度

O(N\*C)O(N∗C): 我们的记忆表存储所有子问题的结果，并且最多有 N\*CN∗C 个子问题。

#### 空间复杂度

O(N\*C+N)O(N∗C+N), O(N\*C)O(N∗C) 用于记忆表的空间和用于递归调用堆栈的 O(N)O(N) 空间。

**小贴士:** 在面试时，一定要和面试官谈谈你的想法，这样他们可以看到你解决问题的能力。

---

## 解决方案

![Visualization of dynamic programming with memoization](https://cdn-images-1.medium.com/max/4828/1*yUbDTle-uPoqvQZtDtGn9A.png)

![](https://cdn-images-1.medium.com/max/4924/1*MBjOpWvtK59bXVXsB2T4Qw.png)

---

## 说明

要实现动态规划，我们只需要修改五行代码。

在第9行中，我们创建了一个二维数组 `dp`，用于保存任何已知子问题的结果。这允许我们以后使用这些二位数组，而不是重新计算答案。

在第22和23行中，我们创建了一个检查 `dp` 的例子，以查看是否已经找到了当前子问题的解法。 如果有，我们将返回已保存的解法并移至下一个子问题。

在第38行中，如果在 `profit1` 中包含当前项，我们将计算包的最大可能值;如果在 `profit2` 中排除当前项，我们将计算背包的最大可能值。然后将其中较大的保存到二维数组 `dp` 中。

在第39行中，我们返回背包价值最高的物品。 这是部分结果，该结果在下一个递归调用开始之前就结束了。 对于所有可能的组合，一旦发生这种情况，第一个调用将返回实际结果。


> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
