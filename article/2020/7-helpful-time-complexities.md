> * 原文地址：[7 Helpful Time Complexities](https://codeburst.io/7-helpful-time-complexities-4c6c0d6df645)
> * 原文作者：[Ellis Andrews](https://medium.com/@ellisandrews1)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/7-helpful-time-complexities.md](https://github.com/xitu/gold-miner/blob/master/article/2020/7-helpful-time-complexities.md)
> * 译者：[PingHGao](https://github.com/PingHGao)
> * 校对者：[rachelcdev](https://github.com/rachelcdev), [Isildur46](https://github.com/Isildur46)

# 算法中七种常见的时间复杂度

![](https://cdn-images-1.medium.com/max/2000/1*6C2DkLB3o2RjBbb0aCvKUQ.jpeg)

作为程序员，我们经常努力编写尽可能高效的代码。但是我们怎么知道我们编写的代码是否高效？答案：大 O 分析。本文的目的是用尽可能简单的术语来解释这个概念。我将首先介绍 Big O，然后举例说明您可能会遇到的七个最常见的情况。如果您已经熟悉这个概念，但是想要使用真实的 Python 代码进行具体的复习，请随时跳到第二部分！

## 像我只有 5 岁一样给我解释：大 O 版
![](https://cdn-images-1.medium.com/max/2000/1*34pO-qdgbiTPThB7lmV91Q.png)

简而言之，我们用「大 O 表示法」来描述算法的效率。具体来说，它描述了算法输入任意增加时，算法的运行时间是如何变化的。虽然这是一个简洁的定义，但我不认识哪个 5 岁小孩能理解这种表述，所以让我们进一步详细讲解。以下是一些定义：

> **1. 算法** **—** 一组逻辑步骤，作用于输入以产生输出。

在本文中，我将**算法**与更熟悉的概念联系：**函数**。回想一下你编写的大多数函数的功能，它们将一个或多个参数作为输入，对这些参数执行指定的操作步骤，然后返回一个值作为输出。不要害怕这个花哨的词，您可能已经写了很多算法！从现在开始，当我说「算法」时，你可以直接把它理解为「函数」。

> **2. 运行时间** **—** 算法需要执行的操作数量。

有许多因素可能会影响算法在特定计算机上的运行时间，无论运行时间是以秒、分、时等时间单位来衡量。因此，大 O 表示法不关注算法运行的实际**时间**，而是根据需要执行的**操作数**来定义运行时间。较少的操作等于较短的运行时间（效率更高），而较多的操作等于较长的运行时间（效率较低）。因此，我们有了比较算法的标准方法。

> **3. 输入规模 —** 算法需要处理的数据量。

在大 O 表示法中，我们关注的是随着数据输入量的增长，不同算法在性能表面方面的差异。举个例子，假设需要在三个随机数的列表中查找最大值，你或许有能力编写几个函数，并把他们的性能优化到相似的程度。但是，如果列表包含 100 个数字怎么办？1,000？1,000,000 呢？这就是我们所说的「输入规模任意增大」，这也是为什么大 O 表示法有时被称为「渐近分析」的原因。在大 O 表示法中，输入规模称用「**n**」表示。

除了运行时间外，大 O 表示法还可以用于描述算法基于输入规模而对空间（内存，磁盘等）的消耗程度。在本文中，我将聚焦于介绍时间复杂度。

#### 如何读写大 O

既然我们已经了解大 O 表示法的作用了，那么它究竟怎么写呢？好吧，它的写法是大写的「O」，后面跟着一个括号，括号里面是一个包含「n」（即输入规模）的数学表达式。下文中有最常见的七个示例，按照运行效率从高到低排序。

1. **O(1) —** 常数复杂度
2. **O(log n) —** 对数复杂度
3. **O(n) —** 线性复杂度
4. **O(n log n) —** 对数线性复杂度
5. **O(nᵏ) —** 多项式复杂度
6. **O(kⁿ) —** 指数复杂度
7. **O(n!) —** 阶乘复杂度

下图描绘了各种复杂度的算法中，当输入规模增长时，操作数量（运行时间）的变化趋势。

![Source: [https://www.bigocheatsheet.com/](https://www.bigocheatsheet.com/)](https://cdn-images-1.medium.com/max/3412/1*PpKIWUPNwB0a4kJvywCgqA.png)


你可以看到，随着输入规模的增长，红色阴影区域中算法的运行时间急剧增长。另一方面，在黄色和绿色阴影区域中的算法，当输入规模增长时，运行时间在变化不是很大，因此它们更高效，处理大量数据时更游刃有余。

最后需要指明的一点，大 O 表示法通常用于描述当输入规模变得非常大时，算法呈现的「显著趋势」。因此，大的显著趋势会盖过一些小的细枝末节的趋势。例如，我们实际测算得到时间复杂度为 **O(n²+ n)** 的算法会简化为 **O(n²)**，原因是随着 **n** 变得非常大时， **n²** 这一项的显著性远远盖过了 **n** 这一项的显著性。

## 例子

现在，让我们看一下上述每种复杂度的算法对应的一些常见例子。

#### 1. O(1) — 常数复杂度

这种复杂度的算法的运行时间不会随着输入规模的增加而增加。这类操作的实际例子就是在数组中按索引查找值，或者在哈希表中按键查找值：

```Python
from typing import Any, Dict, List


# 例 1
def list_lookup(list_: List[Any], index: int) -> Any:
    """Lookup a value in a list by index."""
    return list_[index]


# 例 2
def dict_lookup(dict_: Dict[Any, Any], key: Any) -> Any:
    """Lookup a value in a dictionary by key."""
    return dict_[key]

```

无论传递给这些函数的列表或字典有多大，它们用同等的时间来完成（只有一步操作）。

#### 2. O(log n) — 对数复杂度

典型的对数复杂度算法是[二分搜索算法](https://zh.wikipedia.org/wiki/%E4%BA%8C%E5%88%86%E6%90%9C%E5%B0%8B%E6%BC%94%E7%AE%97%E6%B3%95)。这是一种用于在有序数组中查找特定值的算法，它不断迭代读取当前范围的中间值，判断目标值是小于还是大于中间值，排除不包含目标的那一半内容。下面是它的一种实现：

```Python
from typing import Any, List


def binary_search(list_: List[int], target_value: int) -> int:
    """
    对有序的输入列表执行二分搜索以找到目标值。
    返回列表中目标值的索引，如果未找到则返回 -1。
    """
    # 初始化左右索引以开始搜索
    left = 0
    right = len(list_) - 1

    # 执行二分搜索
    while left <= right:

        # 计算要搜索的剩余列表的中间位置的索引
        middle = left + (right - left) // 2

        # 检查目标值是否在中间索引处。如果是，我们已经找到并完成。
        if list_[middle] == target_value:
            return middle

        # 如果目标值大于中间值，请忽略剩余列表的左半部分
        elif list_[middle] < target_value:
            left = middle + 1

        # 如果目标值小于中间值，请忽略剩余列表的右半部分
        else:
            right = middle - 1

    # 如果在整个列表中未找到目标值，则返回 -1
    return -1

```

由于每次迭代，待搜索的数组长度会减半。因此哪怕搜索的数组长度翻了一倍，也只需多迭代一次！因此，随着数组长度的增加，运行时间将呈对数增长。

#### 3. O(n) — 线性复杂度

线性复杂度算法往往在连续迭代数据结构时涉及到。参考先前的对数搜索示例，在数组中搜索值可以用（效率较低）的线性时间来进行：

```Python
from typing import Any, List


def linear_search(list_: List[Any], target_value: Any) -> int:
    """
    对输入列表执行线性搜索以找到目标值。
    返回列表中目标值的索引，如果未找到则返回 -1。
    """
    # 遍历列表中的每一项，检查其是否为目标值
    for index, item in enumerate(list_):
        if item == target_value:
            return index

    # 如果在列表中未找到目标值，则返回一个标记值
    return -1

```

显然，随着输入列表大小的增加，由于需要检查列表中的每个项目，最坏情况下找到目标所需的循环迭代次数的增长与输入列表的大小增长成正比。

#### 4. O(n log n) — 对数线性复杂度

列举对数线性复杂度算法的示例会比之前难一些。顾名思义，它们同时包含对数和线性部分。其中最常见的示例是排序算法。有一个算法叫「归并排序」，它用迭代手法将数组分成一小块一小块，对每小块进行拆分、排序，然后再按顺序重新将各个小块合并在一起。通过图像可以更容易看明白，因此我将省略代码的实现。

![归并排序算法。来源：[https://en.wikipedia.org/wiki/Merge_sort](https://en.wikipedia.org/wiki/Merge_sort)](https://cdn-images-1.medium.com/max/2560/1*jgT8yBf2lsaCjdbsIPZJsQ.png)

#### 5. O(nᵏ) — 多项式复杂度

在这里，我们开始着手研究时间复杂度较差的算法，通常应尽可能避免使用它（请参考上文的图表，我们正处于红色区域！）。但是，许多「暴力」算法都属于多项式复杂度，可以作为帮助我们解决问题的切入点。例如，下面是查找数组中重复项的二次（k = 2）多项式算法：

```Python
from typing import Any, List, Set


def find_duplicates(list_: List[Any]) -> Set[Any]:
    """查找列表中所有的重复项。"""
    
    # 初始化一个集合以保存重复项
    duplicates = set()

    # 将列表中的每一项与列表中的其他所有项进行检查
    for index_1, item_1 in enumerate(list_):
        for index_2, item_2 in enumerate(list_):
            if index_1 != index_2 and item_1 == item_2:
                duplicates.add(item_1)

    # 返回重复项的集合
    return duplicates

```

对于数组中的每一项，我们都将其数组其余各进行检查。因此，如果数组包含 **n** 个项目，我们将执行 **n** * **n = n**² 个运算，时间复杂度为 **O(n²)**。

附加题：你能想出更好的算法来解决此问题吗？

#### 6. O(kⁿ) — 指数复杂度

我们的倒数第二个常见时间复杂度是指数复杂度，即随着输入规模的增加，运行时间将按固定倍数来增长。一个典型的例子是直接计算[斐波纳契数列](https://zh.wikipedia.org/wiki/%E6%96%90%E6%B3%A2%E9%82%A3%E5%A5%91%E6%95%B0%E5%88%97)中的第 n 项。

```Python
def nth_fibonacci_term(n: int) -> int:
    """递归计算斐波纳契数列的第 n 项。假设 n 是整数。"""
    # 基本情况 —— 前两项的值为 {0，1}
    if n <= 2:
        return n - 1

    return nth_fibonacci_term(n - 1) + nth_fibonacci_term(n - 2)

```

在上面的示例中，每当输入 **n** 增加 1 时，执行的操作数量就会翻倍。这是因为我们没有缓存每个函数调用的结果，所以必须从最开始重新计算所有先前的值。因此，该算法的时间复杂度为 **O(2ⁿ)**。

#### 7. O(n!) — 阶乘复杂度

最后但同样重要（但肯定是效率最低）的类型是阶乘时间复杂度的算法。通常应避免这中复杂度，因为随着输入规模的增加，它们会很快变得难以运行。这种算法有一个示例，那就是[旅行推销员问题](https://www.baidu.com/s?ie=UTF-8&wd=%E6%97%85%E8%A1%8C%E6%8E%A8%E9%94%80%E5%91%98%E9%97%AE%E9%A2%98)的暴力解法。这个问题是希望找到一条最短路径，要求该路径必须访问坐标系中的所有点，并最终回到起点。暴力解法涉及相互比较所有可能的路线（读作：排列组合）并选择最短的。请注意，除非要访问的点数很少，否则这通常不是解决此问题的合理方法。

![一个旅行商问题的解法。来源：[https://en.wikipedia.org/wiki/Travelling_salesman_problem](https://en.wikipedia.org/wiki/Travelling_salesman_problem)](https://cdn-images-1.medium.com/max/2000/1*Vq7Dq63LQrL9xC9Y8XqtGQ.png)

## 结语

尽管我们在这里介绍了很多案例，但在该主题上还有很多东西要学习！我关注的是“最坏情况下的时间复杂度”，但考虑平均情况或最佳情况也很有用。我也没有提到空间的复杂性，如果内存有限，这也同样重要。好消息是，这种分析的方法和一般思考过程是相同的。希望下次您进行代码面试时或需要编写性能函数时，你有了可以放心地解决它的工具。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
