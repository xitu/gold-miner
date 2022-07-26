> * 原文地址：[10 Hardest Python Questions](https://medium.com/@saint_sdmn/10-hardest-python-questions-98986c8cd309)
> * 原文作者：[Alexander Svito](https://medium.com/@saint_sdmn)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2022/10-hardest-python-questions.md](https://github.com/xitu/gold-miner/blob/master/article/2022/10-hardest-python-questions.md)
> * 译者：[jaredliw](https://github.com/jaredliw)
> * 校对者：[DylanXie123](https://github.com/DylanXie123)、[haiyang-tju](https://github.com/haiyang-tju)

![图片由 [Emile Perron](https://unsplash.com/@emilep) 发布于 [Unplash](https://unsplash.com/photos/xrVDYZRGdw4)](https://cdn-images-1.medium.com/max/11014/1*ieXaavHBhInXJiKyK4RTEA.jpeg)

# 10 个最难的 Python 问题

无论你是在准备面试还是在捣鼓代码，有时甚至像 Python 这样透明且具有良好结构的语言也会带来确确实实的挑战。

虽然 [Python 之禅](https://peps.python.org/pep-0020/)已经广为人知了，但一些独特的案例，像是[可迭代对象的拆包](https://stackoverflow.com/questions/68152730/understand-python-swapping-why-is-a-b-b-a-not-always-equivalent-to-b-a-a)（译者注：这是一个关于 `a, b = b, a` 不等于 `b, a = a, b` 的情况）或 [`+=` 和 `+` 运算符的区别](https://stackoverflow.com/questions/2347265/why-does-behave-unexpectedly-on-lists/2347423#2347423)（译者注：这是一个 `+=` 和 `+` 在对类属性进行运算时产生不同结果的情况），即使对于有经验的工程师来说似乎也是违反直觉且令人困惑的。这里，我整理了 10 个关于 Python 解释器行为的示例，这些例子能激发你对 Python 语言结构逻辑的疑问。

**下方所有代码都在 Python 3.8.10 上测试通过。**

## 1. `type` 就是 `object`？

以下的代码的执行结果是什么？

```python
>>> isinstance(type, object)
>>> isinstance(object, type)
>>> isinstance(object, object)
>>> isinstance(type, type)
```

**答案：`True`，`True`，`True`，`True`**

在 Python 中，一切皆对象，所以任何对于 `object` 的实例检查都会返回 `True`：`isinstance(任何东西, object)` #=> `True`。

`type` 是一个**元类**，用于构造所有的 Python 类型。因此所有的类型，无论是 `int`、`str` 或是 `object`，都是 `type` 类的实例，同时也是对象。

`type` 还有一个独一无二的特性：它是自身类的实例。

```python
>>> type(5)
<class 'int'>
>>> type(int)
<class 'type'>
>>> type(type)
<class 'type'>
```

## 2. 空布尔值

以下的代码的执行结果是什么？

```python
>>> any([])
>>> all([])
```

**答案：`False`，`True`**

从内置函数 `any` 的定义中我们知道：

> 当**可迭代对象（iterable）**中的任何元素为真时， `any` 将返回 `True`。 

Python 中的逻辑运算符是惰性的。Python 将查找第一个值为**真**的元素；如果没有找到，返回 `False`。由于序列是空的，没有元素能为**真**，那么 `any([])` 返回 `False`。

`all` 的例子稍微有点复杂，因为它代表的是[虚真（vacuous truth）](https://en.wikipedia.org/wiki/Vacuous_truth)的概念（译者注：虚真指的是如果一个论断的前提条件不能满足时，该论断为真）。与惰性的链式逻辑运算符一样，Python 将查找第一个值为**假**的元素，如果没有找到，则返回 `True`。由于空序列中没有元素为**假**，`all([])` 返回 `True`。

## 3. 数值修约

译者注：数值修约是通过省略及调整原数值的最后若干位数字，使最后所得到的值最接近原数值的过程。

译者注：数值修约是通过省略及调整原数值的最后若干位数字，使最后所得到的值最接近原数值的过程。

以下的代码的执行结果是什么？

```python
>>> round(7 / 2)
>>> round(3 / 2)
>>> round(5 / 2)
```

**答案：`4`，`2`，`2`**

为什么 `round(5 / 2)` 返回的是 `2` 而不是 `3`？这是因为 Python 中的 `round` 函数实现的是[银行家舍入（四舍六入五留双）](https://zh.wikipedia.org/wiki/%E6%95%B0%E5%80%BC%E4%BF%AE%E7%BA%A6#%E5%9B%9B%E6%8D%A8%E5%85%AD%E5%85%A5)，其中所有半值将舍入到最接近的偶数。

## 4. 实例优先！

以下的代码的执行结果是什么？

```python
class A:
    answer = 42

    def __init__(self):
        self.answer = 21
        self.__add__ = lambda x, y: x.answer + y

    def __add__(self, y):
        return self.answer - y

print(A() + 5)
```

**答案：`16`（因为 21 - 5 = 16）**

在查找属性时，Python 将首先在实例级别中搜索，接着是类级别，再到父类。然而，**dunder** 方法却是个例外。在查找 dunder 方法时，Python 会跳过实例查找，直接在类中搜索。

## 5. 求和

以下的代码的执行结果是什么？

```python
>>> sum("")
>>> sum("", [])
>>> sum("", {})
```

**答案：`0`，`[]`，`{}`**

为了能更了解这里发生了什么，我们需要查看 `sum` 函数的签名：

> `sum(iterable, /, start=0)`
>
> `sum` 函数从 `start` 开始自左向右对 `iterable` 的项求和并返回总计值。`iterable` 的项通常为数字，而 `start` 值则不允许为字符串。

在以上的情况中，`''`（空字符串）都会被当成空序列，所以 `sum` 会返回 `start` 参数作为加总的结果。在第一中情况中，`start` 的默认值是 `0`。对于第二及第三种情况，`start` 的参数分别是一个空列表和一个空字典。

## 6. 属性不存在？

以下的代码的执行结果是什么？

```python
>>> sum([
    el.imag 
    for el in [
        0, 5, 10e9, float('inf'), float('nan')
    ]
])
```

**答案：`0.0`**

这段代码不会导致 `AttributeError`。Python 中的所有数字类型（`int`，`real`，`float`）都继承自 `object` 基类。尽管如此，这些类型都支持 `real` 和 `imag` 属性，分别返回数字的实数和虚数部分。**Infinity** 和 **NaN** 也支持这一点（译者注：因为两者均为 `float` 类型）。

## 7. 惰性 Python

以下的代码的执行结果是什么？

```python
class A:
    def function(self):
        return A()

a = A()
A = int
print(a.function())
```

**答案：`0`**

Python 函数中的代码只会在调用时执行，这就意味着所有的 `NameError` 只会在你调用该方法时抛出。变量的绑定亦是如此。在上面这个例子中，在定义方法时，引用未定义的类是被允许的。但是，在执行过程中，Python 会从外部范围绑定名称 `A` ，所以 `function` 方法将返回一个新创建的 `int` 实例。

## 8. -1 倍

以下的代码的执行结果是什么？

```python
>>> "this is a very long string" * (-1)
```

**答案：`''`（空字符串）**

从 [Python 文档](https://docs.python.org/3/library/stdtypes.html)中我们可以得知：

> **操作**：`s * n` 或 `n * s`（`s` 为序列，`n` 为整数）
> **结果**：相当于 `s` 与自身进行 `n` 次拼接
>
> 小于 `0` 的 `n` 值会被当作 `0` 来处理（生成一个与 `s` 同类型的空序列）。

其他的序列类型也符合这一特性。

## 9. 打破数学规则

以下的代码的执行结果是什么？

```python
>>> max(-0.0, 0.0)
```

**答案：`-0.0`**

为什么会这样呢？这个问题发生的原因是：

1. [负零](https://zh.wikipedia.org/wiki/-0)和零在 Python 中是相等的。
2. 在 Python 文档中，`max` 函数的描述如下：

> 若有多个最大元素时，函数将会返回第一个遇到的最大值。

因此 `max` 函数返回第一个出现的 0，也恰好就是 -0。问题完美解决。

## 10. 再次打破了数学规则

以下的代码的执行结果是什么？

```python
>>> x = (1 << 53) + 1
>>> x + 1.0 > x
```

**答案：`False`**

这种违反直觉的行为得归咎于三件事情：[大数计算](https://zh.wikipedia.org/wiki/%E9%AB%98%E7%B2%BE%E5%BA%A6%E8%AE%A1%E7%AE%97)、**浮点是精度限制**和**数值比较**。Python 可以支持很大的整数。在整数越界时，Python 将隐式转换背后的数值运算模式（或者你也可以在 Python 2 中显式地使用 `long`），但浮点数精度却是有限的。

2⁵³ + 1 = 9007199254740993

是不能被完全表示为 Python 浮点数的最小整数。因此，在求值 `x + 1.0` 时，Python 将 `x` 转换成 `float` 类型，舍入至可以以浮点数表达的 `9007199254740992.0`，然后加上 `1.0`，但由于相同的数值表达限制，结果又被设回了 `9007199254740992.0`。

这里的另一个问题是比较规则。不像其他的语言，Python 和 Ruby 在对比 `float` 和 `int` 时不会抛出异常，也不会尝试将运算元转换成同一类型再做比较。与此相反，它们比较的是真实的数值。由于 `9007199254740992.0` 小于 `9007199254740993`，Python 返回 `False`。

## 结论

尽管如此，作为最清晰透明的编程语言，Python 依然实至名归。在写这篇文章时，我也遇到了其他的一些违反直觉的代码片段。其中的一些在新的版本中都得到了解决，另一些则由社区给出解释。前文的这些例子代表了 Python 使用中的边缘情况，你在实际的商业项目中遇到它们的机率相对较小。

话虽如此，检查和理解这些“坑”能帮助你更好地了解语言的内部结构，并在项目中避免可能导致异常或者 bug 的实践。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
