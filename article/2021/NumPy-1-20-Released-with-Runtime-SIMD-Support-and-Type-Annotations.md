> * 原文地址：[NumPy 1.20 Released with Runtime SIMD Support and Type Annotations](https://www.infoq.com/news/2021/03/numpy-120-typed-SIMD/)
> * 原文作者：[Bruno-Courio](https://www.infoq.com/profile/Bruno-Couriol/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/NumPy-1-20-Released-with-Runtime-SIMD-Support-and-Type-Annotations.md](https://github.com/xitu/gold-miner/blob/master/article/2021/NumPy-1-20-Released-with-Runtime-SIMD-Support-and-Type-Annotations.md)
> * 译者：
> * 校对者：


The newly released NumPy 1.20 features [performance and documentation improvements](https://github.com/numpy/numpy/releases/tag/v1.20.0). Developers can now use type annotations for NumPy functions. A wider use of [SIMD](https://en.wikipedia.org/wiki/SIMD) (Single Instruction, Multiple Data) instructions increases the execution speed of universal functions ([ufunc](https://numpy.org/doc/stable/reference/ufuncs.html)). NumPy’s documentation additionally sees significant improvements.

The NumPy library code is now annotated with type information, a move facilitated by NumPy no longer supporting Python 2. One contributor [explained the rationale behind the move](http://numpy-discussion.10968.n7.nabble.com/Put-type-annotations-in-NumPy-proper-td47996.html) as follows:

> When we started numpy-stubs a few years ago, putting type annotations in NumPy itself seemed premature. We still supported Python 2, which meant that we would need to use awkward comments for type annotations.Over the past few years, using type annotations has become increasingly popular, even in the scientific Python stack. For example, off-hand I know that at least SciPy, pandas, and xarray have at least part of their APIs type annotated. Even without annotations for shapes or dtypes, it would be valuable to have near-complete annotations for NumPy, the project at the bottom of the scientific stack.

Developers can additionally use new types — **`[ArrayLike](https://numpy.org/doc/stable/reference/typing.html#numpy.typing.ArrayLike)`** and **`[DTypeLike](https://numpy.org/doc/stable/reference/typing.html#numpy.typing.DTypeLike)`**. The **`ArrayLike`** type is used for objects that can be converted to arrays. The **`DTypeLike`** is used for objects that can be converted to dtypes. A data type object ([numpy.dtype](https://numpy.org/doc/stable/reference/generated/numpy.dtype.html#numpy.dtype)) specifies the content of the fixed-size block of memory corresponding to an array item and includes in particular information about the item data type (e.g., integer, float), size of the data, byte order ([little-endian](https://numpy.org/doc/stable/glossary.html#term-little-endian) or [big-endian](https://numpy.org/doc/stable/glossary.html#term-big-endian)), and more. The two new types empower the type checker to recognize inefficient patterns and warn the users. The documentation explains:

> The DTypeLike type tries to avoid creation of dtype objects using dictionary of fields like below:x = np.dtype({"field1": (float, 1), "field2": (int, 3)})
Although this is valid Numpy code, the type checker will complain about it, since its usage is discouraged.

The new [numpy.typing module](https://numpy.org/devdocs/reference/typing.html) contains the new type aliases and can be imported at runtime:

```
from numpy.typing import ArrayLike
x: ArrayLike = [1, 2, 3, 4]

```

NumPy 1.20 also enables [multi-platform SIMD compiler optimizations](https://numpy.org/devdocs/reference/simd/simd-optimizations.html). NumPy is now able to [detect the SIMD instructions made available by the CPU](https://github.com/numpy/numpy/pull/13421) and optimize for them. Users can configure the runtime optimization behavior through several new build arguments. The **`--cpu-baseline`** argument is used to specify the minimal set of required optimizations. The **`--cpu-dispatch`** specifies the dispatched set of additional optimizations — with a default value of **`max -xop -fma4`** that enables all CPU features, except for AMD legacy features. With **`--disable-optimization`**, users may opt out of the new improvements.

Using NumPy 1.20 entails upgrading to Python 3.7 or newer. With a view to improving NumPy’s online presence and friendliness to new users, the new NumPy release significantly improved its documentation — the release mentioned merging 185 related pull requests in what is an ongoing effort.

NumPy 1.20 is a large release with 684 pull requests contributed by 184 people merged. The [full release notes](https://github.com/numpy/numpy/releases/tag/v1.20.0) are available online and include information about additional features and deprecations.

Some users have welcomed the new type annotations, not without making a comparison with [Julia](https://julialang.org/), an alternative dynamically-typed programming language [aimed specifically at performant scientific computing](https://docs.julialang.org/en/v1/), machine learning, data mining, large-scale linear algebra, distributed and parallel computing. One user [said on HackerNews](https://hacker-news.news/post/25977977):

> The type annotation story is indeed better with Julia, but having type annotations for NumPy is beneficial for many users for whom Julia isn’t a win, where number crunching isn’t the main thing going on and Python’s better library situation is important and you want to avoid the complication of calling Python from Julia.

[NumPy](http://www.numpy.org/) is an open-source Python library adding support for large, multi-dimensional, homogeneously-typed arrays, and matrices. NumPy includes a set of mathematical functions to create and transform these arrays, linear algebra routines, and more. NumPy is at the core of [SciPy](http://www.scipy.org/), a Python-based ecosystem of open-source software for mathematics, science, and engineering. NumPy allows data scientists to use a productive scripting language for data analysis tasks.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
