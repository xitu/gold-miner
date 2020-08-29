> * 原文地址：[7 Helpful Time Complexities](https://codeburst.io/7-helpful-time-complexities-4c6c0d6df645)
> * 原文作者：[Ellis Andrews](https://medium.com/@ellisandrews1)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/7-helpful-time-complexities.md](https://github.com/xitu/gold-miner/blob/master/article/2020/7-helpful-time-complexities.md)
> * 译者：[PingHGao](https://github.com/PingHGao)
> * 校对者：

# 7种有用的时间复杂度

![](https://cdn-images-1.medium.com/max/2000/1*6C2DkLB3o2RjBbb0aCvKUQ.jpeg)

作为程序员，我们经常努力编写尽可能高效的代码。但是我们怎么知道我们编写的代码是否高效？答案：大O分析。本文的目的是用尽可能简单的术语来解释这个概念。我将首先介绍 Big O，然后举例说明您可能会遇到的七个最常见的情况。如果您已经熟悉这个概念，但是想要使用真实的 Python 代码进行具体的复习，请随时跳到第二部分！

## 像我只有5岁一样给我解释：大O 版
![](https://cdn-images-1.medium.com/max/2000/1*34pO-qdgbiTPThB7lmV91Q.png)

简而言之，“大O” 表示法是我们谈论算法效率的方法。具体来说，它描述了算法的运行时间如何随着算法输入的任意增加而改变。虽然这是一个简洁的定义，但我不认识任何一个能理解这个说法的五岁孩子，所以让我们进一步详细讲解。以下是一些定义：

> **1. 算法** **—** 一组逻辑步骤，作用于输入以产生输出。

在本文中，我将“算法”与更熟悉的概念联系：“函数”。思考一下您编写的大多数函数的功能。它们将一个或多个参数作为输入，对这些参数执行指定的操作步骤，然后返回一个值作为输出。不要害怕这个花哨的词，您可能已经写了很多算法！从现在开始，当我说“算法”时，您真的可以直接联想到“函数”。

> **2. 运行时间** **—** 算法需要执行的操作数量。

有许多因素可能会影响算法在给定计算机上运行时间，无论是以秒、分、时等单位进行统计。因此，大O 不再关注算法运行的实际“时间”，而是根据需要执行的“操作数”来定义运行时间。较少的操作等于较短的运行时间（效率更高），而较多的操作等于较长的运行时间（效率较低）。因此，我们有了比较算法的标准方法。

> **3. 输入规模 —** 算法所需要的处理的数据的数量。

在 大O 中，我们对随着我们所给的输入数据越来越多时，算法在性能方面的差异感兴趣。例如，您可能编写了一些相当优化的相似函数，以在三个随机数的列表中查找最大值。但是，如果列表包含 100 个数字怎么办？1,000？ 1,000,000 呢？这就是我们所说的“输入大小任意增大”，也是为什么 大O 有时被称为“渐近分析”的原因。在 大O 中，输入的大小称为 “**n**”。

除了运行时间外，大O 还可以用于描述算法相对于输入大小的空间（内存，磁盘等）消耗。在本文中，我将聚焦于介绍时间复杂度。

#### How to Read and Write Big O

既然我们了解了 大O 是帮助我们做什么的，那么它看起来像什么呢？好吧，它的写法是大写的 “O”，后面带一个括起来的 “n” （表示输入大小）表示的数学表达式。这是您最常遇到的七个示例，从最高效到最低效排序。

1. **O(1) —** 常量
2. **O(log n) —** 对数型
3. **O(n) —** 线性
4. **O(n log n) —** 对数线性
5. **O(nᵏ) —** 多项式型
6. **O(kⁿ) —** 指数型
7. **O(n!) —** 阶乘型

下图是针对每种复杂度的算法，将操作数量（运行时间）与输入大小作图的图表。

![Source: [https://www.bigocheatsheet.com/](https://www.bigocheatsheet.com/)](https://cdn-images-1.medium.com/max/3412/1*PpKIWUPNwB0a4kJvywCgqA.png)


您会看到，随着输入大小的增加，红色阴影区域中算法的运行时间急剧增加。另一方面，在黄色和绿色阴影区域中算法的性能几乎不依赖于输入的大小，因此更加有效和可推广。

最后需要指明的一点，大O法通常用于描述当输入变得非常大时算法的“主要趋势”。因此，如果无关紧要的子项被更重要的子项所压制，则可以将其删除。例如，计算得到时间复杂度为 **O（n²+ n）**的算法将被简化为 **O（n²）**，原因是随着** n **变得非常大， **n²** 项的效果大大超过了** n **项的效果。

## 例子

现在，让我们看一下属于上述每种复杂性的一些常见算法示例。

#### 1. O(1) — 常数型

这种复杂性的算法的运行时间不会随着输入大小的增加而增加。这种性质的常见操作是通过数组中的索引或哈希表中的键来进行查询：

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

无论传递到这些函数的列表或字典有多大，它们都将同时完成（一步操作）。

#### 2. O(log n) — 对数型

典型的对数复杂度算法是[二分搜索算法](https://en.wikipedia.org/wiki/Binary_search_algorithm)。这是一种用于在有序序列中查找指定值的算法，通过迭代查看中间值，检查目标值是小于还是大于中间值，以排除确信不包含目标的数组的一半。如下是一种实现：

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

由于每次迭代将要搜索的数组大小减半，那么搜索两倍大的数组将只需要进行一次额外的迭代！因此，随着数组大小的增加，运行时间将呈对数增长。

#### 3. O(n) — 线性型

具有线性时间复杂度的算法通常涉及串行地迭代一种数据结构。参考先前的对数搜索示例，执行数组中值的搜索还可以以（效率较低）线性时间进行：

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

显然，随着输入列表大小的增加，找到项目所需的循环迭代次数的最坏情况与大小增加成正比，因为需要检查列表中的每个项目。

#### 4. O(n log n) — 对数线性型

对数线性复杂度算法比我们之前的示例更难找到。顾名思义，它们同时包含对数和线性成分。其中最常见的示例是排序算法。 “合并排序”是这样一种排序的算法，它不断的将数组分半、排序，然后再按顺序重新合并在一起。通过图像可以更容易看明白，因此我将省略代码的实现。

![合并排序算法。来源：[https://en.wikipedia.org/wiki/Merge_sort](https://en.wikipedia.org/wiki/Merge_sort)](https://cdn-images-1.medium.com/max/2560/1*jgT8yBf2lsaCjdbsIPZJsQ.png)

#### 5. O(nᵏ) — 多项式型

目前，我们正在研究时间复杂度不够好的算法，通常应尽可能避免使用它（请参考上图，我们正处于红色区域！）。但是，许多“暴力”算法都属于多项式复杂度类别，却可以作为解决问题的有用起点。例如，下面是用于查找数组中重复项的二次（k = 2）多项式算法：

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

对于数组中的每一项，我们将其与数组中的每个其他项进行检查。因此，如果数组包含** n **个项目，我们将执行** n ** * ** n = n **²个运算，时间复杂度为 O（n²）**。

额外的奖励：您能想出一种解决此问题的更好的算法吗？

#### 6. O(kⁿ) — 指数型

我们的倒数第二个常见时间复杂度是指数型，即，随着输入大小的增加，运行时间将增加一个固定倍数。一个典型的例子是直接计算[斐波纳契数列](https://en.wikipedia.org/wiki/Fibonacci_number)中的第 n 个项。

```Python
def nth_fibonacci_term(n: int) -> int:
    """递归的计算斐波纳契数列的第 n 项。假设 n 是整数。"""
    # 基本情况 —— 前两项的值为 {0，1}
    if n <= 2:
        return n - 1

    return nth_fibonacci_term(n - 1) + nth_fibonacci_term(n - 2)

```

在上面的示例中，每当输入** n **增加1时，执行的操作数量就会加倍。这是因为我们没有缓存每个函数调用的结果，因此必须从最开始重新计算所有先前的值。因此，该算法的时间复杂度为** O（2ⁿ）**。

#### 7. O(n!) — 阶乘型

最后但同样重要（但肯定是效率最低）的类型是阶乘时间复杂度的算法。通常应避免这一情况，因为随着输入比例的增加它们将很快变得不可行。这种算法的一个示例是[旅行商问题](https://en.wikipedia.org/wiki/Travelling_salesman_problem)的暴力解决方案。这个问题试图找到一条最短的路径，该路径可以访问坐标系中的所有点并返回到起点。暴力解决方案涉及相互比较所有可能的路线（读取：排列）并选择最短的。请注意，除非要访问的点数很少，否则这通常不是解决此问题的方法。

![一个旅行商问题的解法。来源：[https://en.wikipedia.org/wiki/Travelling_salesman_problem](https://en.wikipedia.org/wiki/Travelling_salesman_problem)](https://cdn-images-1.medium.com/max/2000/1*Vq7Dq63LQrL9xC9Y8XqtGQ.png)

## 结语

尽管我们在这里介绍了很多案例，但在该主题上还有很多东西要学习！我关注的是“最坏情况下的时间复杂度”，但考虑平均情况或最佳情况也很有用。我也没有提到空间的复杂性，如果内存有限，这也同样重要。好消息是，这种分析的方法和一般思考过程是相同的。希望下次您进行代码面试时或需要编写性能函数时，你有了可以放心地解决它的工具。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
