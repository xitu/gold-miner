> * 原文地址：[The Do’s and Don’ts of Python List Comprehension](https://medium.com/better-programming/the-dos-and-don-ts-of-python-list-comprehension-5cd0f5d18500)
> * 原文作者：[Yong Cui, Ph.D.](https://medium.com/@yong.cui01)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/the-dos-and-don-ts-of-python-list-comprehension.md](https://github.com/xitu/gold-miner/blob/master/article/2020/the-dos-and-don-ts-of-python-list-comprehension.md)
> * 译者：[samyu2000](https://github.com/samyu2000)
> * 校对者：[luochen1992](https://github.com/luochen1992)，[shixi-li](https://github.com/shixi-li)

# Python 列表推导式使用注意事项

![Photo by [Michael Herren](https://unsplash.com/@mdherren?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/10944/0*OMREOHfwYkIKRpRF)

Python 列表推导式并不是给初学者用的，因为它非常反直觉，甚至对于有其他编程语言背景的人也是如此。

我们接触到 List 的使用时，学习的内容都是零散的。所以我们缺少一个关于如何在各种各样的场景下使用 List 的知识体系。

本文提供了一些 List 的使用指南，尽可能涵盖各个方面。希望本文可以成为你的一站式实用手册。

## 使用建议

#### 1.建议使用迭代的方式

使用 List 最基本的方式是以一个可迭代对象为基础，创建一个 List 对象，这个可迭代对象可以是任意可以迭代元素的 Python 对象。使用方法如下。

```
[expression for item in iterable]
```

下面这段代码展示了一个使用列表相关技术创建 List 对象的例子。在这个例子中，我们定义了一个 Integer 列表，并基于这个对象创建了保存每个数字的平方数和立方数的 List 对象。

```Python
>>> # 创建一个 Integer 列表
>>> integers = [1, 2, 3, 4, 5, 6]
>>> # 创建平方数和立方数列表
>>> powers = [(x*x, pow(x, 3)) for x in integers]
>>> print(powers)
[(1, 1), (4, 8), (9, 27), (16, 64), (25, 125), (36, 216)]

```

上面的例子把 List 对象当作迭代器使用。我们应该知道，许多类型的对象也是可迭代的，比如 List、Set、Dictionary 和 String 等等。其他数据类型，像 range、map、filter，以及 pandas 包中的 Series、DataFrame，都是可迭代的。下面的代码演示了某些对象的使用方法。

```Python
>>> # 使用 range 对象
>>> integer_range = range(5)
>>> [x*x for x in integer_range]
[0, 1, 4, 9, 16]
>>> # 使用 Series 对象 
>>> import pandas as pd
>>> pd_series = pd.Series(range(5))
>>> print(pd_series)
0    0
1    1
2    2
3    3
4    4
dtype: int64
>>> [x*x for x in pd_series]
[0, 1, 4, 9, 16]
```

#### 2.如果只需用到其中的某些元素，应当使用条件判断语句

假设你需要将符合某种条件的元素归集起来，并创建一个 list。下面展示了相关的语法。

```
[expression for item in iterable if condition]
```

 `if` 语句用来实现条件判断。下面的代码展示了这种用法的一个简单示例。

```Python
>>> # 同样创建一个 Integer 列表
>>> integers = [1, 2, 3, 4, 5, 6]
>>> # 筛选出偶数，创建一个这些偶数的平方数列表
>>> squares_of_evens = [x*x for x in integers if x % 2 == 0]
>>> print((squares_of_evens))
[4, 16, 36]
```

#### 3.使用条件判断语句

List 对象中还可以使用 if-else 形式的条件判断，语法如下。

```
[expression0 if condition else expression1 for item in iterable]
```

这跟前面的那种用法有些类似，别把这两种用法混淆。在本例中，条件语句本身是一个整体。下面的代码提供了一个例子。

```Python
>>> # 创建一个 Integer 列表
>>> integers = [1, 2, 3, 4, 5, 6]
>>> # 遍历 integers 中的元素，如果是偶数，取平方数存入新的列表
>>> # 如果是奇数，取立方数存入新的列表
>>> custom_powers = [x*x if x % 2 == 0 else pow(x, 3) for x in integers]
>>> print(custom_powers)
[1, 4, 27, 16, 125, 36]
```

#### 4.如果有嵌套结构，可以使用嵌套的循环

有可能可迭代对象中的元素自身也是可迭代的，尽管这种情况不太常见。如果你对嵌套的可迭代对象有兴趣，可以使用 `for` 来实现循环嵌套。语法如下。

```
[expression for item_outer in iterable for item_inner in item_outer]

# 与下面的代码等同
for item_outer in iterable:
    for item_inner in item_outer:
        expression
```

上面的代码展示了使用`for`实现嵌套循环的例子。

```Python
>>> # 创建一个包含元组的列表
>>> prices = [('$5.99', '$4.99'), ('$3.5', '$4.5')]
>>> # 获取元组中的每个价格，以此创建一个一维列表
>>> prices_formatted = [float(x[1:]) for price_group in prices for x in price_group]
>>> print(prices_formatted)
[5.99, 4.99, 3.5, 4.5]
```

#### 5.替换高阶函数

有的人比较习惯函数式编程，比如使用高阶函数也是这种习惯的表现之一。特别说明一下，高阶函数是那些需要使用输入或输出参数的函数。在 Python 中，常用的高阶函数有 `map()` 和 `filter()`。

```Python
>>> # 创建一个 integer 类型的列表
>>> integers = [1, 2, 3, 4, 5]
>>> # 使用 map 创建平方数列表
>>> squares_mapped = list(map(lambda x: x*x, integers))
>>> squares_mapped
[1, 4, 9, 16, 25]
>>> # 使用列表推导式创建平方数列表
>>> squares_listcomp = [x*x for x in integers]
>>> squares_listcomp
[1, 4, 9, 16, 25]
>>> # 使用 filter 取得 integers 中的偶数列表
>>> filtered_filter = list(filter(lambda x: x % 2 == 0, integers))
>>> filtered_filter
[2, 4]
>>> # 使用列表推导式取得 integers 中的偶数列表
>>> filterd_listcomp = [x for x in integers if x % 2 == 0]
>>> filterd_listcomp
[2, 4]

```

从上面的例子可以看出，使用 list 的某些特性比使用高阶函数更具有可读性，而且也能实现较复杂的嵌套结构。

## 使用禁忌

#### 1.不要忘了定义构造函数

有人认为列表推导式很酷炫，是 Python 特有的功能，所以为了炫耀自己的 Python 水平，即使有更好替代方案也要使用它。 

```Python
>>> # 使用 range 创建列表对象
>>> numbers = [x for x in range(5)]
>>> print(numbers)
[0, 1, 2, 3, 4]
>>> # 以一个字符串为基础，创建一个小写字母的字符列表
>>> letters = [x.lower() for x in 'Smith']
>>> print(letters)
['s', 'm', 'i', 't', 'h']
```

上述例子中，我们使用了 range 和 string，这两种数据结构都是可迭代的，`list()`构造函数可以直接使用 iterable 创建一个 list 对象。下面的代码提供了更合理的解决方案。

```Python
>>> # 使用 range 创建列表对象
>>> numbers = list(range(5))
>>> print(numbers)
[0, 1, 2, 3, 4]
>>> # 以一个字符串为基础，创建一个小写字母的字符列表
>>> letters = list('Smith'.lower())
>>> print(letters)
['s', 'm', 'i', 't', 'h']

```

#### 2.不要忘了生成器表达式

在 Python 中，生成器是一种特殊的可迭代对象，它会延迟加载元素，直到被请求才会加载。这在处理大量数据时会非常高效，它能提升存储效率。相比之下，list 对象为了方便计数和索引，一次性创建所有的元素。所以跟生成器相比，在元素个数相同时，list 需要占用更多内存。

我们可以定义一个生成器函数来创建生成器。我们也可以使用下面的语句来创建生成器，这是一种称为**生成器表达式**的方法。

```
(expression for item in iterable)
```

你可能会注意到，除了使用圆括号外，它的语法跟使用 list 的语句很相似。所以需要注意区分。

考虑下面这个例子。我们要计算前一百万个数字的平方和。如果使用 list 来实现，方法如下。

```Python
>>> # 创建列表对象 squares 
>>> squares = [x*x for x in range(10_000_000)]
>>> # 计算它们的总和
>>> sum(squares)
333333283333335000000
>>> squares.__sizeof__()
81528032
```

如上所示，list 对象占据 81528032 字节。我们考虑使用 generator 进行相同的操作，代码如下。

```Python
>>> # 创建 generator 对象，保存每个数的平方数
>>> squares_gen = (x*x for x in range(10_000_000))
>>> # 计算它们的总和
>>> sum(squares_gen)
333333283333335000000
>>> squares_gen.__sizeof__()
96
```

跟使用 list 相比，使用 generator 内存开销小得多，只有 96 字节。原因很简单———— generator 不需要获取所有的元素。相反，它只需要获取各个元素在序列中的位置，创建下一个元素并呈现它，而且不必保存在内存中。

## 结论

本文中，我们整理了 list 应用的一些关键要领。这些该做的和不该做的都非常清晰明了。我估计你会在合适的场景中用到它。下面是本文内容的小结。

* **使用迭代的方式。** Python 中有许多类型的 iterable，你应当在掌握基础（list 和 tuple）的同时融会贯通。
* **使用条件判断语句。** 如果你对在 iterable 中筛选某些元素感兴趣，可以多多研究条件判断。
* **使用条件判断表达式。** 如果你需要有选择性地获取某些数据，可以使用条件判断表达式。
* **使用嵌套的循环。** 如果你要处理嵌套的 iterable，可以使用嵌套的循环结构。
* **用 list 替代高阶函数** 在很多情况下，可以用 list 替代高阶函数。
* **不要忘记 list 的构造函数** 定义 list 的构造函数，可以使用 iterable 创建一个 list 对象。如果你直接使用 iterable，推荐用这个方法。
* **不要忘了生成器表达式** 它的语法与 list 中的语法相似。在处理大量的对象时，这是一种节省内存开销的办法。list 和 generator 不同的是，为了日后的索引和访问， list 必须提前创建，如果元素个数很多，就会消耗很大的内存。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
