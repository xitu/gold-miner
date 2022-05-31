> * 原文地址：[Operator overloading in Python](https://medium.com/python-in-plain-english/operator-overloading-in-python-6dbf90be9d3e)
> * 原文作者：[aditya dhanraj tiwari](https://medium.com/@adityadhanrajtiwari898)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/operator-overloading-in-python.md](https://github.com/xitu/gold-miner/blob/master/article/2020/operator-overloading-in-python.md)
> * 译者：[samyu2000](https://github.com/samyu2000)、[jaredliw](https://github.com/jaredliw)
> * 校对者：[zhuzilin](https://github.com/zhuzilin)、[WangNing](https://github.com/w1187501630)

# Python 中的运算符重载

![图片来源：LocalNav](https://cdn-images-1.medium.com/max/2000/1*n54WXtELB8VR8qC-AJphhg.jpeg)

每一种运算符对于不同的类型都有不同的行为。例如 `+` 在用于整型对象时，它会把两个整数相加；用于字符串时，则会连拼接两个字符串。

```python
x, y = 10, 20
print(x + y)  # 30

a, b = 'John', 'Wick'
print(a + b)  # John Wick
```

`+` 运算符因操作对象的类型的不同而执行不同的操作，这种特性称为重载。

> **运算符重载指的是运算符的功能会因为其操作数据类型而改变**。

`+` 运算符可以用于任意两个对象的相加吗？我们来试试看。

```python
class Vector:
    def __init__(self, x, y):
        self.x = x
        self.y = y

v1 = Vector(3, 4)
v2 = Vector(5, 6)
v1 + v2

---------------------------------------------------------------------------
TypeError                                 Traceback (most recent call last)
<ipython-input-3-08104d7e1232> in <module>
----> 1 v1 + v2

TypeError: unsupported operand type(s) for +: 'Vector' and 'Vector'
```

运行这段代码会报错。为什么呢？这是因为 `+` 运算符不知道如何把两个 `Vector` 类的对象相加。

在本文中，我们将研究如何将既有的运算符用于自定义对象的操作，同时我们要牢记 Python 对操作符重载的一些限制性规则。

这些限制性规则有：

1. 不允许创建新的运算符，只能重载已有的那些运算符;
2. 不允许对内置数据类型（如 `tuple` 、 `str` 、 `list`）的运算符进行重载
3. 某些运算符不能重载，例如 **`is`**，**`or`**，**`and`** 和 **`not`**。

在开始学习运算符重载前，我们需要了解 **Python 数据模型**和**特殊方法**。

Python 数据模型可以看作一种 “Python 设计方式”或 “Python 框架”。它能告诉你 Python 如何管理对象以及如何对它们进行操作。它描述了一系列的 API，你可以使用这些 API 使你定义的对象具备已有数据类型的某些功能，并且可以使用大多数 Python 语言的惯用特性，而且不必实现它们。

**特殊方法** → 当你使用 `len(collection)`，Python 解释器调用的是 `collection.__len__()` 方法。这里的 `__len__()` 就是一个特殊方法。

特殊方法开头和结尾都是 `__`，意为只能由 Python 解释器调用。除非你在进行**元编程**，不然不需要直接调用它。

在 Python 中，我们可以使用特殊方法来实现运算符重载。

现在让我们使 `Vector` 类支持 `+` 运算符。

当我们调用 `+` 这个运算符时，Python 解释器调用了 **`__add__(self, other)`** 这个特殊方法。所以，在我们定义的类中实现 `__add__()` 方法，就可以支持 `+` 运算符了：

```python
class Vector:
    def __init__(self, x, y):
        self.x = x
        self.y = y

    def __add__(self, other):
        return Vector(self.x + other.x , self.y + other.y)

    def __repr__(self):
        return f'Vector({self.x}, {self.y})'

v1 = Vector(3, 4)
v2 = Vector(5, 6)
v1 + v2

>>> Output: Vector(8, 10)
```

你会发现，我们的类已经支持了 `+` 运算符。我们还实现了 `__repr__()` 方法。在调用 `print()` 方法时，解释器会调用 `__str__()` 方法，如果没有 `__str__()` 的实现，解释器就会调用 `__repr__()` 方法。

> 注意：重载运算符时一定要返回一个新建的对象（类似于 `+=` 的赋值运算符除外）。

再举个重载运算符的例子：

当我们使用 **`==`** 运算符时，Python 解释器会调用 `__eq__(self, other)` 这个特殊方法，所以我们通过实现 `__eq__()` 方法就可以使某个类支持 `==` 运算符。

```python
class Vector:
    def __init__(self, x, y):
        self.x = x
        self.y = y

    def __add__(self, other):
        return Vector(self.x + other.x , self.y + other.y)

    def __repr__(self):
        return f'Vector({self.x}, {self.y})'
    
    def __eq__(self, other):
        return self.x == other.x and self.y == other.y

v1 = Vector(3, 4)
v2 = Vector(5, 6)
v1 == v2

>>> Output: False

v3 = Vector(3,4)
v1 == v3

>>> Output: True
```

在 Python 中，我们可以透过使用特殊方法轻松实现运算符重载；关键在于理解 Python 的数据模型和特殊方法。

这些概念能让你从 Python 的惯用特性中受益，并且能更好地利用强大的标准库。

欲了解 Python 数据模型的更多详情，请参考 [Fluent python](https://www.oreilly.com/library/view/fluent-python/9781491946237/ch01.html)。

[这里](https://docs.python.org/3/reference/datamodel.html)是 Python 中的特殊方法汇总，可供查阅。

## 总结

我们从理解什么是运算符重载开始，讨论了 Python 中运算符重载的一些限制条件、数据模型和特殊方法，然后在 Vector 类中实现了运算符重载。

希望你喜欢这篇文章。祝你工作顺利，好运连连！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
