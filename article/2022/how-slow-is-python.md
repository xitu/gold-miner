> * 原文地址：[How Slow is Python?](https://levelup.gitconnected.com/how-slow-is-python-6f2fc1fbfbaa)
> * 原文作者：[Doug Foo](https://medium.com/@doug-foo)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2022/how-slow-is-python.md](https://github.com/xitu/gold-miner/blob/master/article/2022/how-slow-is-python.md)
> * 译者：[Alfxjx](https://github.com/Alfxjx)
> * 校对者：[Wu-yikun](https://github.com/Wu-yikun)

# 多语言横向对比 Python 有多慢？

![Photo by [Alex Blăjan](https://unsplash.com/@alexb?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/13886/0*kOjDXNW1V5aQYWmI)

我们都知道它比 C、Java、Rust 慢，但到底有多慢呢？

就在我开始思考这篇文章的时候，我的信息流里刷出了一个笑话帖子 “Python 实际上并不慢” —— 即使我知道那不是真的而且只是标题党，我还是读了它。当谈到 Python 时，好比你正在与蜗牛打交道，虽然你可以训练好蜗牛，但你无法摆脱它的基本遗传学（与经典电影《千钧一发》中的伊桑·霍克不同）。

## 基准测试

于是我开始编写一些简单的基准测试来交叉测试 C、Rust、Java 和 Python。以下是我的主要评判标准：

* 管理内存压力（对象创建/销毁）
* 类似 JSON 的字符串处理
* 循环和计算密集型操作

作为参考，有一个很棒的 [GitHub 项目](https://github.com/kostya/benchmarks) 评估了十几种语言的性能，性能的结果如下表。如果把 C++ 的性能作为基线 1，那么 Python 在 [brainf 测试](https://gist.github.com/roachhd/dce54bec8ba55fb17d3a)（一个很有趣的**图灵机**解释器） 上的速度要比 C++ 慢 227 倍。

![由 github 项目 [Kostya M](https://github.com/kostya/benchmarks) 提供](https://cdn-images-1.medium.com/max/2000/1*1YFqFHxz77sbFp-v_8k7Ow.png)

我最终编写了非常简单的代码片段来进行测试，因为我意识到我忘记了这些语言的大多数是如何编程的。我不得不重新设定我的测试目标以适应我微弱的技能……

![© Doug Foo Labs](https://cdn-images-1.medium.com/max/3450/1*sc0AvOEI6nBMLr0a_iyCMg.png)

## 测试结果的分析

**我将链接到我的 GitHub 以在参考部分中进行真正的 hacky 测试。 我希望命名是不言自明的。**

以下是我对不同语言性能的总结：

1. **Python 文件 I/O 相当快** 因为限制因素是磁盘
2. **Python 在递归时异常缓慢**，仅 `fib(30)` 级别递归的斐波那契数列就已经慢得不可思议了
3. **Python 函数调用很慢** —— 导致递归缓慢的原因之一
4. **没有 JIT 优化的 Java** 可能真的很慢，在某些方面甚至比 Python 还要慢
5. **Java 原生 String** + 仍然非常慢（100 倍），尽管使用 StringBuilder 使其快了很多，但仍旧比 Python 慢
6. 如今**带有 JIT 的 Java 相当快**，几乎不值得再使用 C……
7. **Rust 真的很快**，当然如果我能知道怎样更好的写 Rust 代码的话，可能会更快......

虽然慢 200 倍的基准测试尚未在我的小测试中得到证明，但显然，如果再增加一些额外的函数调用和递归，你就会很容易得到这样的结论。

## 那么为什么 Python 很慢呢？

大多数原因都是显而易见的，但也让我列出它们：

1. Python 是一门**解释型**语言，虽然是字节码编译的，但它并没有进行真正优化
2. Python 使用**垃圾收集**，但主要使用引用计数，因此它比 Java 表现得更快、或者说至少更具有确定性
3. 默认**没有 JIT 编译器** —— 似乎对于解释型语言至关重要（**PyPy** 使用它提升了 10 倍）
4. 作为一门**弱类型的动态语言**有它慢的地方（并且使得构建 JIT 变得更加困难）
5. **函数调用的实现异常缓慢**（也许有些堆栈帧分配算法比较复杂？）

请注意，我们甚至没有测试多线程或多程序，因为我们都知道 Python 也有 **GIL（全局解释器锁）** 问题。

## 如何优化 Python 的运行速度？

有一些技巧可以提高 Python 的运行速度，但大多数都不是很好。

1. 使用多进程来处理工作线程（但要注意你会受到 GIL 的限制）
2. 编写原生 C 代码并链接到 Python
3. 使用原生 Python 函数（在运行时用 C 编写）
4. 单行的列表推导式似乎是性能优化的，所以它们看起来不仅仅是很酷的技巧

老实说，我没有看到很多很棒的技巧…… 有些技巧就像“使用 O(n) 和 O(n-log n) 算法而不是 O(n²)”…… 也许第一个技巧应该是**学习一些计算机科学知识**？

---

## 参考文章

1. Making Python fast— [https://github.com/ajcr/ajcr.github.io/blob/master/_posts/2016-04-01-fast-inverse-square-root-python.md](https://www.kdnuggets.com/2021/06/make-python-code-run-incredibly-fast.html)
2. Python Slowness — [https://medium.com/analytics-vidhya/is-python-really-very-slow-2-major-problems-to-know-which-makes-python-very-slow-9e92653265ea](https://towardsdatascience.com/why-is-python-so-slow-and-how-to-speed-it-up-485b5a84154e)
3. Why is Python Slow — [https://hackernoon.com/why-is-python-so-slow-e5074b6fe55b](https://hackernoon.com/why-is-python-so-slow-e5074b6fe55b)
4. GitHub of hack test1.* sample s— [https://github.com/dougfoo/medium](https://github.com/dougfoo/medium)
5. Lack of ByteCode optimization in Python — [https://nullprogram.com/blog/2019/02/24/](https://nullprogram.com/blog/2019/02/24/)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
