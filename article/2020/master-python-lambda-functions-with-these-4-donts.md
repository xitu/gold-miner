> * 原文地址：[Master Python Lambda Functions With These 4 Don’ts](https://medium.com/better-programming/master-python-lambda-functions-with-these-4-donts-655b212d36d7)
> * 原文作者：[Yong Cui, Ph.D.](https://medium.com/@yong.cui01)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/master-python-lambda-functions-with-these-4-donts.md](https://github.com/xitu/gold-miner/blob/master/article/2020/master-python-lambda-functions-with-these-4-donts.md)
> * 译者：[loststar](https://github.com/loststar)
> * 校对者：[luochen1992](https://github.com/luochen1992)

# 通过“四不要”掌握 Python 中的 Lambda 函数

![Photo by [Khachik Simonian](https://unsplash.com/@khachiksimonian?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral).](https://cdn-images-1.medium.com/max/10944/0*9slRkVkDa86YSSIk)

Lambda 函数是 Python 中的匿名函数。当你需要完成一件小工作时，在本地环境中使用它们可以让工作得心应手。有些人将它们简称为 lambdas，它们的语法如下：

```
lambda arguments: expression
```

`lambda` 关键字可以用来创建一个 lambda 函数，紧跟其后的是参数列表和用冒号分割开的单个表达式。例如，`lambda x: 2 * x` 是将任何输入的数乘2，而 `lambda x, y: x+y` 是计算两个数字的和。语法十分直截了当，对吧？

假设您知道什么是 lambda 函数，本文旨在提供有关如何正确使用 lambda 函数的一些常规准则。

## 1. 不要返回任何值

看看语法，您可能会注意到我们在 lambda 函数中并没有返回任何内容。这都是因为 lambda 函数只能包含一个表达式。然而，使用 `return`  关键字会构成不符合规定语法的语句，如下所示：

```Python
>>> integers = [(3, -3), (2, 3), (5, 1), (-4, 4)]
>>> sorted(integers, key=lambda x: x[-1])
[(3, -3), (5, 1), (2, 3), (-4, 4)]
>>> sorted(integers, key=lambda x: return x[-1])
... 
  File "<input>", line 1
    sorted(integers, key=lambda x: return x[-1])
                                   ^
SyntaxError: invalid syntax
```

该错误可能是由于无法区分表达式和语句而引起的。像是包含 `return`、`try`、 `with` 以及 `if` 的语句会执行特殊动作。然而，表达式指的是那些可以被计算出一个值的表达，例如数值或其他 Python 对象。

通过使用 lambda 函数，单个表达式会被计算为一个值并且参与后续的计算，例如由 `sorted` 函数排序。

## 2. 不要忘记更好的选择

lambda 函数最常见的使用场景是将它作为一些内置工具函数中 `key` 的实参，比如上面展示的 `sorted()` 和 `max()`。根据情况，我们可以使用其他替代方法。思考下面的例子：

```Python
>>> integers = [-4, 3, 7, -5, -2, 6]
>>> sorted(integers, key=lambda x: abs(x))
[-2, 3, -4, -5, 6, 7]
>>> sorted(integers, key=abs)
[-2, 3, -4, -5, 6, 7]
>>> scores = [(93, 100), (92, 99), (95, 94)]
>>> max(scores, key=lambda x: x[0] + x[1])
(93, 100)
>>> max(scores, key=sum)
(93, 100)
```

在数据科学领域，很多人使用 [pandas](https://pandas.pydata.org/) 库来处理数据。如下所示，我们可以使用 lambda 函数通过  `map()`  函数从现有数据中创建新数据。除了使用 lambda 函数外，我们还可以直接使用算术函数，因为 pandas 是支持的：

```Python
>>> import pandas as pd
>>> data = pd.Series([1, 2, 3, 4])
>>> data.map(lambda x: x + 5)
0    6
1    7
2    8
3    9
dtype: int64
>>> data + 5
0    6
1    7
2    8
3    9
dtype: int64
```

## 3. 不要将它赋值给变量

我曾见过一些人将 lambda 函数误认为是简单函数的另一种声明方式，您可能也见过有人像下面这么做：

```Python
>>> doubler = lambda x: 2 * x
>>> doubler(5)
10
>>> doubler(7)
14
>>> type(doubler)
<class 'function'>
```

对 lambda 函数命名的唯一作用可能是出于教学目的，以表明 lambda 函数的确是和其他函数一样的函数——可以被调用并且具有某种功能。除此之外，我们不应该将 lambda 函数赋值给变量。

为 lambda 函数命名的问题在于这使得调试不那么直观。与其他的使用常规 `def` 关键字创建的函数不同，lambda 函数没有名字，这也是为什么有时它们被称为匿名函数的原因。思考下面简单的例子，找出细微的区别：

```Python
>>> inversive0 = lambda x: 1 / x
>>> inversive0(2)
0.5
>>> inversive0(0)
Traceback (most recent call last):
  File "<input>", line 1, in <module>
  File "<input>", line 1, in <lambda>
ZeroDivisionError: division by zero
>>> def inversive1(x):
... 	return 1 / x
... 
>>> inversive1(2)
0.5
>>> inversive1(0)
Traceback (most recent call last):
  File "<input>", line 1, in <module>
  File "<input>", line 2, in inversive1
ZeroDivisionError: division by zero
```

* 当您的代码存在关于 lambda 函数的问题（即 `inversive0`），`Traceback` 错误信息只会提示您 lambda 函数存在问题。
* 相比之下，使用正常定义的函数，`Traceback`会清晰地提示您有问题的函数（即 `inversive1`）。

与此相关，如果您想多次使用 lambda 函数，最佳实践是使用通过 `def` 定义的允许使用文档字符串的常规函数。

## 4. 不要忘记列表推导式

有些人喜欢将 lambda 函数和高阶函数一起使用，比如 `map` 或 `filter`。思考下面用法示例：

```Python
>>> # 创建一个数字列表
>>> numbers = [2, 1, 3, -3]
>>> # 使用带有 lambda 函数的 map 函数
>>> list(map(lambda x: x * x, numbers))
[4, 1, 9, 9]
>>> # 使用带有 lambda 函数的 filter 函数
>>> list(filter(lambda x: x % 2, numbers))
[1, 3, -3]
```

我们可以使用可读性更强的列表推导式代替 lambda 函数。如下所示，我们使用列表推导式来创建相同的列表对象。如您所见，与列表推导式相比，之前将 `map` 或 `filter` 函数与 lambda 函数一起使用更麻烦。因此，在创建涉及高阶函数的列表时，应考虑使用列表推导式。

```Python
>>> # Use list comprehensions
>>> [x * x for x in numbers]
[4, 1, 9, 9]
>>> [x for x in numbers if x % 2]
[1, 3, -3]
```

## 结论

在本文中，我们回顾了使用 lambda 函数可能会犯的四个常见错误。通过避免这些错误，您应该能在代码中正确使用 lambda 函数。

使用 lambda 函数的经验准则是保持简单以及只在本地使用一次。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
