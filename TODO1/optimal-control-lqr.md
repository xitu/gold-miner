> * 原文地址：[Optimal Control: LQR](https://towardsdatascience.com/optimal-control-lqr-417b41e10d0d)
> * 原文作者：[Marin Vlastelica Pogančić](https://medium.com/@marinvp)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/optimal-control-lqr.md](https://github.com/xitu/gold-miner/blob/master/TODO1/optimal-control-lqr.md)
> * 译者：[EmilyQiRabbit](https://github.com/EmilyQiRabbit)
> * 校对者：[ezioyuan](https://github.com/ezioyuan), [TUARAN](https://github.com/TUARAN)

# 最优控制：LQR

![](https://cdn-images-1.medium.com/max/1600/0*SSB8_Rwp0keZZ7uG.jpg)

> 一份关于 LQR 的简单易懂的入门级教程，它是最优控制的基础概念。

我将会在这篇文章中讨论最优控制，并会更具体的讨论性能非常优秀的线性二次调节器。在最优控制领域中，它的使用频率非常高，并且还指明了最优控制和最近很火的强化学习之间的相似之处。它们两者都用来解决顺序决策过程中相似的问题，但有趣的是命名却不同。话虽如此，但是还是小小警告一下读者，接下来可能会涉及一些数学问题：

> 这篇文章包括一些线性代数和微积分的运算，但是不用怕，它们很简单，你没问题的。

闲言少叙，现在我们开始吧。首先我们先来给出最优控制问题的一般定义，或者最好说是优化问题。它其实就意味着最大化或者最小化某些受到特定变量约束的函数。一个典型的最优控制问题函数如下所示：

![](https://cdn-images-1.medium.com/max/1600/1*qs2p-_jNvBDeGMEVqrqK9A.png)

这个函数非常直白简单，就是最小化受到某些约束的函数 **f**（s.t. 是约束条件的缩写）。在优化领域中，基于目标函数和约束条件，难度也会随之变动。而基于实际的问题，当然约束条件也会保持相同或有所变化。不用多说，优化问题中的非凸函数是更难优化的，但如果是凸函数，我们就能高效快速地解决。无论如何，凸函数相当重要，所以当你在解决的问题中找出它的时候，你的反应差不多是这样子的：

![](https://cdn-images-1.medium.com/max/1600/0*5jrHW-EJDsRPZVBx.jpg)

在控制问题中，我们通过优化轨迹来最小化代价函数或者最大化回报函数，这和强化学习的处理方式是一样的。自然而然地，条件也是动态变化的，即给出我们下一状态的函数是基于当前的行为和状态的，也是优化约束的一部分。所以我们可以像这样描述控制优化问题：

![](https://cdn-images-1.medium.com/max/1600/1*VB-syinim9NPm6EIRIQMPg.png)

这是一个到 N 的有限集合的例子。让我们来分块解析一下。x 是每个时间点的状态变量。**u** 是行为函数。E 是最终状态的最终代价，**g** 是每对状态-行为函数的代价函数。带横线的 **x** 是我们想要开始优化的初始状态，**f** 则是动态函数。在这个例子中，没有不等式约束。事实证明，如果 **f** 函数是一个关于 **x** 和 **u** 的线性函数，并且 **g** 函数是 **x** 和 **u** 的二次函数，那么这个问题将变得容易很多。于是我们得出了线性二次调节问题的定义：

![](https://cdn-images-1.medium.com/max/1600/1*FUpZDyx377ChcaYhcrEWvw.png)

在这几个式子中，Q、R 和 E 是代价矩阵，它们决定了多项式系数。我们也可以用矩阵的形式写出每一个时间点的代价，使得表达式更加简单。

![](https://cdn-images-1.medium.com/max/1600/1*Q5ZAP09bX_o3BYGONcLE2A.png)

在上面这个例子中，我们忽略了 S，或者更确切的说我们假设 S = 0，但这不会显著改变数学运算的结果，S 也可以是代价函数中影响 x 和 u 的关系的某个矩阵。

接下来我们将要应用最优原则，它陈述了一个理所当然的事实，即如果在 A 和 C 之间存在一条最优路径，然后我们在这条路径上取一点 B，那么从 A 到 B 的子路径也是最优路径。这真的是凭直觉就能得出的事实。基于此，我们可以定义最优代价函数，或者说是递归路径总代价。由此我们得出哈密顿-雅可比-贝尔曼方程：

![](https://cdn-images-1.medium.com/max/1600/1*EQdn0DQS8OXgfV2fDsGclg.png)

J* 函数是最优代价函数。在本例中，我们将目标函数声明为多项式函数，所以逻辑上我们可以假设最优代价函数也是多项式函数，于是我们就可以这样写：

![](https://cdn-images-1.medium.com/max/1600/1*EsHlDB5SV7fHwLo3wrar1g.png)

并且最终的代价函数在逻辑上也基于最优问题的定义，如下所示：

![](https://cdn-images-1.medium.com/max/1600/1*FFc0lDhMgGLrJKxbNQZ14Q.png)

现在，如果我们将函数 g 的定义以及动态条件变量插入到贝尔曼等式中，我们就能得出：

![](https://cdn-images-1.medium.com/max/1600/1*eQxRS-3O2UtGF2zzO2tQtQ.png)

基于二次代价假设，我们该如何得出这个函数的最小值呢？很简单，我们取 u 的梯度并让其等于 0，将所有的变量放到一个大的中心矩阵中去：

![](https://cdn-images-1.medium.com/max/1600/1*ljoF2k4uIRdP3m3ynFABsA.png)

为了看上去比较简单，我们用如下的矩阵代替（这是不言自明的）：

![](https://cdn-images-1.medium.com/max/1600/1*QpN6Lh63BxMjgJeYYdxwCQ.png)

将每一项都相乘，由于我们是要对 **u** 求导，所以只需要关注含有 **u** 的项，于是可以得出如下的中间结果：

![](https://cdn-images-1.medium.com/max/1600/1*ALpr9ExoUMQBPNi8gFCqDQ.png)

在计算出梯度并重新排列后，我们得出了 u*，它可以最小化代价，即最优行为函数：

![](https://cdn-images-1.medium.com/max/1600/1*5SCURUpNJuumckGwzyVnDA.png)

也许现在你可以先停下来想一想。这个式子意味这什么？它意味着对于最优行为函数，我们有了一个封闭形式的解答。这个答案非常干净利落。那么接下来我们还需要做什么来解析它呢？我们还需要 k+1 时间点的矩阵 P。基于下面的等式，我们可以从最后一个时间点递归计算：

![](https://cdn-images-1.medium.com/max/1600/1*EkgXYabMf3QEFgH_-Ecdqw.png)

这就是广为人知的代数 Riccati 等式。在某些情况下，我们想要某个固定时间点的解决方案，对于无限时间，方程可以求解出一个固定的 P。在这种情况下，我们甚至不需要递归。我们可以直接获取到最优反馈控制的答案。

基本上这就是本篇文章的所有内容了。你一定在赞赏 LQR 的能力了。当然，很多问题并不能简化为线性动态问题，但是如果我们能够简化，我们能得出的解答是让人非常惊喜的。这种方法甚至被应用于动态函数是非线性的情况下，这时候我们就用泰勒扩展将其转化为线性问题。这是复杂的轨迹优化问题中经常使用的方法，被称为差分动态规划（DDP），一个例子就是 iLQR（迭代 LQR），读者可以自行查阅。

现在你已经学到了 LQR 功夫，那么你就得到了理解最优控制的工具。

![](https://cdn-images-1.medium.com/max/1600/0*4eOi4xHOUcdbeUVK.png)

我希望这样解释 LQR 能够让你理解。它是一个非常简单但是非常有用的概念，也是很多最优控制算法的基石。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
