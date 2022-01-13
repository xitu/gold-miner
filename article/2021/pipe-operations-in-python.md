> * 原文地址：[Use Pipe Operations in Python for More Readable and Faster Coding](https://towardsdatascience.com/pipe-operations-in-python-1e8f8debe26)
> * 原文作者：[Thuwarakesh Murallie](https://thuwarakesh.medium.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/pipe-operations-in-python.md](https://github.com/xitu/gold-miner/blob/master/article/2021/pipe-operations-in-python.md)
> * 译者：[Z招锦](https://github.com/zenblofe)
> * 校对者：[jaredliw](https://github.com/jaredliw)、[Adolescent0](https://github.com/Adolescent0)

![](https://miro.medium.com/max/1400/1*lHk7fXxqnUjg8C2V2g4FcA.jpeg)

# 如何使用 Python 管道 Pipe 高效编码

> Pipe 是一个好用的 Python 包，可以通过 shell 风格的管道操作，节省大量的编码时间并提高代码可读性。

现在 Python 称得上是一门优雅的编程语言，但这并不意味着它没有改进的空间。

Pipe 是一个好用的 Python 包，它将 Python 处理数据的能力提升到了一个新的水平。Pipe 采用类似 SQL 的声明式方法来操作集合中的元素。你不需要编写大量的代码就能使用它来执行过滤、转换、排序、去重、分组等操作。

在这篇文章中，我们将讨论如何使用 Pipe 简化 Python 代码。最重要的是，我们将构建可重复使用的自定义管道操作。这些自定义方法能在以后的项目中使用。

先从以下内容开始：

- 一个具有启发性的示例；
- 一些开箱即用的管道操作；
- 创建自定义的管道操作。

如果你不知道如何设置，可以通过 PyPI 轻松安装 [Pipe](https://github.com/JulienPalard/Pipe)。以下是安装命令：

```bash
pip install pipe
```

## 在 Python 中使用管道

下面是一个使用 Pipe 的示例。假设有一个数字列表，我们想做以下事情：

- 移除所有重复的值；
- 筛选奇数；
- 对列表中的每个数字求平方；
- 按升序对数值进行排序。

下面是我们过去在 Python 中的典型做法：

```python
num_list_with_duplicates = [1, 4, 2, 27,
                            6, 8, 10, 7, 13, 19, 21, 20, 7, 18, 27]

# 移除重复数字
num_list = list(dict.fromkeys(num_list_with_duplicates))

# 筛选奇数
odd_list = [num for num in num_list if num % 2 == 1]

# 对数字求平方
odd_square = list(map(lambda x: x**2, odd_list))

# 按升序排列数值
odd_square.sort()

print(odd_square)
```

```
[1, 49, 169, 361, 441, 729]
```

以上代码具有很好的可读性，但是使用管道是一个更好的方法。

```python
from pipe import dedup, where, select, sort

num_list_with_duplicates = [1, 4, 2, 27,
                            6, 8, 10, 7, 13, 19, 21, 20, 7, 18, 27]
# 进行管道操作
results = list(num_list_with_duplicates 
                | dedup 
                | where(lambda x: x % 2 == 1)
                | select(lambda x: x**2)
                | sort
            )

print(results)
```

```
[1, 49, 169, 361, 441, 729]
```

两种方式产生相同的结果。然而，第二个比第一个更直观，而且代码量也更少。

这就是 Pipe 帮助我们简化代码的方式。我们可以在一个集合上进行连续操作，而不需要单独编写代码。

但是在 Pipe 中还有一些更酷的操作，比如在上面的示例中使用的操作。此外，如果我们需要一些独特的操作，也可以创建自定义管道。让我们先来看一些经典实用的管道操作。

## 经典实用的管道操作

我们已经学习了几个简单的管道操作。在本节中，接着讨论一些经典实用的管道操作来处理数据。

并非安装 Pipe 后就可以得到完整的操作列表，要想获得详细的内容，请查阅 [Pipe 的 GitHub 仓库](https://github.com/JulienPalard/Pipe)。

### Group By 方法

我相信这是对数据科学家最有帮助的管道操作。数据科学家倾向于使用 Pandas，但是把一个列表转换为数据集，有时感觉是过度操作。在绝大多数情况下，我都可以随手使用这个管道操作处理数据。

```python
from pipe import dedup, groupby, where, select, sort

num_list = [1, 4, 2, 27,
            6, 8, 10, 7, 13, 19, 21, 20, 7, 18, 27]

results = list(num_list
               | groupby(lambda x: "Odd" if x % 2 == 1 else "Even")
               )

print(results)
```

以上代码将数据集分为奇数组和偶数组，创建了一个包含两个元组的列表。每个元组都有 lambda 函数中指定的名称和被分组的对象。总之以上代码产生了下面的分组：

```python
[
    ('Even', <itertools._grouper object at 0x7fdc05ed0310>),
    ('Odd', <itertools._grouper object at 0x7fdc05f88700>),
]
```

现在可以对创建的每个组分别进行操作。这里有一个示例，从每个组中提取元素，再对元素进行求平方。

```python
from pipe import dedup, groupby, where, select, sort

num_list = [1, 4, 2, 27,
            6, 8, 10, 7, 13, 19, 21, 20, 7, 18, 27]

results = list(num_list
               | groupby(lambda x: "Odd" if x % 2 == 1 else "Even")
               | select(lambda x: {x[0]: [y**2 for y in x[1]]})
               )

print(results)
```

```
[
    {'Even': [16, 4, 36, 64, 100, 400, 324]}, 
    {'Odd': [1, 729, 49, 169, 361, 441, 49, 729]},
]
```

### Chain 和 Traverse 方法

这两个方法能够很容易展开一个嵌套的列表并使其扁平化。链式操作是一步一步进行的，而遍历操作是递归的，直到列表不再继续扩展。

以下是使用 chain 的结果：

```python
from pipe import chain

nested_list = [[1, 2, 3], [4, 5, 6], [7, [8, 9]]]

unfolded_list = list(nested_list
                     | chain
                     )

print(unfolded_list)
```

```
[1, 2, 3, 4, 5, 6, 7, [8, 9]]
```

可以看到已经展开了列表的最外层，但是 8 和 9 仍然在一个嵌套的列表里面，因为它们已经被嵌套到里面一层。

以下是使用 traverse 的结果：

```python
from pipe import traverse

nested_list = [[1, 2, 3], [4, 5, 6], [7, [8, 9]]]

unfolded_list = list(nested_list
                     | traverse
                     )

print(unfolded_list)
```

```
[1, 2, 3, 4, 5, 6, 7, 8, 9]
```

Traverse 展开了全部可以展开的内容。

我主要使用列表推导式（list comprehension）来展开列表，但是阅读和理解代码会变得越来越困难。而且，当我们不知道有多少个嵌套层时，很难进行递归扩展，就像上面示例中的遍历操作那样。

```python
nested_list = [[1, 2, 3], [4, 5, 6], [7, [8, 9]]]

unfolded_list = [num for item in nested_list for num in item]

print(unfolded_list)
```

### Take_while 和 Skip_while 方法

这两个操作的工作原理与之前使用的 `where` 操作类似。关键的区别在于 `take_while` 和 `skip_while` 在满足某些条件的情况下，会停止查找集合中的其他元素。而 `while` 则是对列表中的每个元素进行操作。

以下是 `take_while` 和 `where` 在过滤小于 5 的值这一简单任务中的执行情况：

```python
rom pipe import as_list, take_while, where

result = list([3, 4, 5, 3] | take_while(lambda x: x < 5))
print(f"take_while: {result}")


result2 = list([3, 4, 5, 3] | where(lambda x: x < 5))
print(f"where: {result2}")
```

以上代码的结果如下：

```
take_while: [5, 3]
where: [3, 4, 3]
```

请注意 `take_while` 操作跳过了最后的 `3`，而 `where` 操作则包括了它。

`skip_while` 的工作原理与 `take_while` 很相似，只是它只在满足某些条件时才包括元素。

```python
take_while: [5, 3]
where: [3, 4, 3]
```

```
[5, 3]
```

正如前面提到的，这些并不是使用管道库可以完成的全部任务。请查看仓库以便了解更多内置函数和示例。

## 创建自定义的管道操作

创建新的管道操作是相对容易，只需要使用 Pipe 类对函数进行注释。

在以下示例中，我们将 Python 函数转换为管道操作。它接受一个整数作为输入，并返回其平方值。

```python
from pipe import Pipe


@Pipe
def sqr(n: int = 1):
    return n ** 2


result = 10 | sqr
print(result)
```

当我们使用 `@Pipe` 类注释函数时，它就变成了一个管道操作。在第 9 行，我们用它来对数字求平方。

管道操作也可以使用额外的参数。第一个参数始终是其在链中的上一个操作的输出。我们可以有其它附加参数，并在链中使用时进行指定。

额外的参数甚至可以是一个函数。

在以下示例中，我们创建了一个接受附加参数的管道操作，附加参数是一个函数。我们的管道操作是使用函数转换列表中的每个元素。

```python
from typing import List
from pipe import Pipe, as_list, select


def fib(n: int = 1):
    """递归创建斐波那契数字"""
    return n if n < 2 else fib(n-1)+fib(n-2)


@Pipe
def apply_fun(nums: List[int], fun):
    """将任何函数应用于列表元素并创建新列表"""
    return list(nums | select(fun))


result = [5, 10, 15] | apply_fun(fib)


print(result)
```

## 本文总结

看到 Python 能够进一步改进，这令人印象深刻。

作为一名执业数据科学家，我发现 Pipe 在大量日常任务中都非常有用。我们也可以用 Pandas 来完成大部分任务。然而，Pipe 在提高代码可读性方面表现出色，即使是新手程序员也能理解这种数据的转换操作。

这里需要注意的是，我还没有在大规模项目中使用 Pipe，也没有探索它在大规模数据集和数据管道上的表现，但是我相信这个软件包会在离线数据分析中发挥重要作用。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
