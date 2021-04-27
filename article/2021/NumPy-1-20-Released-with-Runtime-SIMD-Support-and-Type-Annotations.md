> * 原文地址：[NumPy 1.20 Released with Runtime SIMD Support and Type Annotations](https://www.infoq.com/news/2021/03/numpy-120-typed-SIMD/)
> * 原文作者：[Bruno-Courio](https://www.infoq.com/profile/Bruno-Couriol/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/NumPy-1-20-Released-with-Runtime-SIMD-Support-and-Type-Annotations.md](https://github.com/xitu/gold-miner/blob/master/article/2021/NumPy-1-20-Released-with-Runtime-SIMD-Support-and-Type-Annotations.md)
> * 译者：[霜羽 Hoarfroster](https://github.com/PassionPenguin)
> * 校对者：[HumanBeingXenon](https://github.com/HumanBeingXenon)、[zenblo](https://github.com/zenblo)

# NumPy 1.20 问世，带来了运行时 SIMD 的支持和类型注释

新发布的 NumPy 1.20 版本在[性能和说明文档](https://github.com/numpy/numpy/releases/tag/v1.20.0)方面都有所提升。我们现在可以在 NumPy 函数中使用类型注释。[SIMD（单指令流多数据流）](https://zh.wikipedia.org/wiki/SIMD) 指令的更广泛使用完善了通用功能（[ufunc](https://numpy.org/doc/stable/reference/ufuncs.html)）。NumPy 还对它的文档做出了显著的改进。

NumPy 库的代码现在有了类型信息的注解，这是 NumPy 不再支持 Python 2 所促使的结果。一位贡献者[解释此举背后的理由](http://numpy-discussion.10968.n7.nabble.com/Put-type-annotations-in-NumPy-proper-td47996.html)，如下所示：

> 几年前，当我们开始使用 numpy-stubs 时，将类型注释放入 NumPy 本身似乎为时过早。那时候我们仍然支持着 Python 2，这意味着我们需要在类型注释中使用笨拙的注释。在过去的几年中，即使在 Python 科学栈中，使用类型注释也变得越来越流行。例如，我知道至少 SciPy，pandas 和 xarray 的 API 类型至少有一部分被注释了。即使没有 shape 或 dtype 的注释，在科学栈底部的项目 NumPy 具有接近完整的注释也很有价值。

开发人员还可以使用新类型 —— [`ArrayLike`](https://numpy.org/doc/stable/reference/typing.html#numpy.typing.ArrayLike) 和 [`DTypeLike`](https://numpy.org/doc/stable/reference/typing.html#numpy.typing.DTypeLike)。`ArrayLike` 类型用于可转换为数组的对象，而 `DTypeLike` 用于转换 `dtypes` 的对象。数据类型对象（[numpy.dtype](https://numpy.org/doc/stable/reference/produced/numpy.dtype.html#numpy.dtype)）用于指定对应于固定大小的内存块的内容到数组项目，并包含有关项目数据类型（例如，整数，浮点数），数据大小，字节顺序（[little-endian](https://numpy.org/doc/stable/glossary html#term-little-endian) 或 [big-endian](https://numpy.org/doc/stable/glossary.html#term-big-endian)）等。这两种新类型使类型检查器能够识别效率低下的模式并警告用户。该文档说明：

> `DTypeLike` 类型尝试让我们避免使用如下所示的字段字典创建 `dtype` 对象：
> ```python
> x = np.dtype({“ field1”：（float，1），“ field2”：（int，3）})
> ```
> 尽管这是有效的 Numpy 代码，但类型识别器会提醒这里的问题，因为它的用法不明确。

新的 [numpy.typing 模块](https://numpy.org/devdocs/reference/typing.html)包含新的类型别名，可以在运行时导入：

```
from numpy.typing import ArrayLike
x: ArrayLike = [1, 2, 3, 4]
```

NumPy 1.20 还启用了[多平台 SIMD 编译器优化](https://numpy.org/devdocs/reference/simd/simd-optimizations.html)功能，现在 NumPy 能够[检测 CPU 提供的 SIMD 指令](https://github.com/numpy/numpy/pull/13421)并对其进行优化。用户可以通过几个新的构建参数来配置运行时优化行为。`--cpu-baseline` 参数用于指定所需优化的最小集，而 `--cpu-dispatch` 用于指定已调度的其他优化集（默认值 `max -xop -fma4` 意味着会启用所有除了 AMD 旧功能的 CPU 功能。）用户可以通过使用 `--disable-optimization` 参数选择不使用新的改进。

使用 NumPy 1.20 需要升级到 Python 3.7 或更新版本。为了改善 NumPy 的在线表现和对新用户的友好性，新的 NumPy 发行版本大幅改进了它的文档 — 发行版中提到合并了 185 个相关的拉取请求，这是一项持续的工作。

NumPy 1.20 是一个大型项目，由 184 人合并贡献了 684 个 pull 请求。[完整的发行说明](https://github.com/numpy/numpy/releases/tag/v1.20.0)可以在线获取，其中包含有关其他功能和不推荐使用的信息。

有些用户接纳了这种新的类型注释，而不仅仅只是与 [Julia](https://julialang.org/) 进行比较。Julia 是另一种动态类型的编程语言[专门针对高性能科学计算而设计](https://docs.julialang.org/en/v1/)的。它通常应用于机器学习，数据挖掘，大规模线性代数，分布式和并行计算。一位用户[在 HackerNews 上这样说](https://hacker-news.news/post/25977977)：

> 使用 Julia 确实可以更好地进行类型注释，但是 NumPy 带来的类型注释对于许多不使用 Julia 的用户来说是有益的。数字的密集运算的并不是主要问题，Python 拥有更多的更好的库这一点也很重要，并且还能够避免 Julia 调用 Python 的麻烦。

[NumPy](http://www.numpy.org/) 是一个开源 Python 库，增加了对大型、多维、同构类型的数组和矩阵的支持。NumPy 含有一堆的数学函数，用于创建和变换这些数组、线性代数例程等。NumPy 是 [SciPy](http://www.scipy.org/) 的核心，Scipy 是一个基于 Python 的开放源代码软件生态系统，用于数学、科学和工程学。NumPy 使得数据科学家可以使用高效的脚本语言来执行数据分析任务。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
