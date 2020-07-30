> * 原文地址：[3 Essential Questions About Hashable in Python](https://medium.com/better-programming/3-essential-questions-about-hashable-in-python-33e981042bcb)
> * 原文作者：[Yong Cui, Ph.D.](https://medium.com/@yong.cui01)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/3-essential-questions-about-hashable-in-python.md](https://github.com/xitu/gold-miner/blob/master/article/2020/3-essential-questions-about-hashable-in-python.md)
> * 译者：[shixi-li](https://github.com/shixi-li)
> * 校对者：[PingHGao](https://github.com/PingHGao), [JalanJiang](https://github.com/JalanJiang)

# 在 Python 中，三个关于可哈希不可不知的问题

![照片由 [Yeshi Kangrang](https://unsplash.com/@omgitsyeshi?utm_source=medium&utm_medium=referral) 摄于 [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/7648/0*eL1s2Ik6LMju82xU)

作为一种通用的编程语言，Python 为不同的用户场景提供了一系列内置的数据结构。

当你学习 Python 基础知识的时候，你可能在某些地方看到有提及**可哈希**。例如，你可能会看到 `dict` 中的键需要是可哈希的（请参见下面代码片段中的一个小示例）。

在另一个例子中，它提到了 `set` 中的元素需要是可哈希的。

```Python
>>> # 一个正确的字典声明
>>> good_dict = {"a": 1, "b": 2}
>>> 
>>> # 一个错误的字典声明
>>> failed_dict = {["a"]: 1, ["b"]: 2}
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
TypeError: unhashable type: 'list'
```

你可能会想知道 —— 可哈希到底是什么意思？哪些对象是可哈希的，而哪些又不是？如果我们使用不可哈希的对象作为字典的键会发生什么？诸如此类，你可能还想问很多相关的问题。

在本文中，我们将讨论关于哈希的一些基本的知识点，以让你可以解决上述的这些问题。最后你可能会发现这些问题一点都不像你开始想的那么难。

## 哪些对象是可哈希的，而哪些又不是？

当我们展开关于哈希的机制解释之前，第一个需要解决的问题就是哪些对象是可哈希的，而哪些又不是。

因为我们知道 Python 显式的要求能够加入 `set` 的元素应该是可哈希的，所以我们可以通过测试是否可以将一个对象加入 `set` 来判断它的哈希属性。成功插入表示对象是可以被哈希的，反之亦然。

```python
>>> # 创建一个空的集合
>>> elements = set()
>>> 
>>> # 将各种类型的对象插入到这个集合中
>>> items = [1, 0.1, 'ab', (2, 3), {'a': 1}, [1, 2], {2, 4}, None]
```

如上述代码所示，我创建了一个命名为 `elements` 的 `set` 变量，以及另一个命名为 `items` 的 `list` 变量，`items` 中包含了最常用的内置数据类型：`int`、`float`、`str`、`tuple`、`dict`、`list`、`set` 和 `NoneType`。

我将进行的实验是将 `items` 中的每一个元素添加到 `elements` 中。在这个场景下我不会使用 `for` 循环，因为任何一个可能的 `TypeError` 都会导致迭代的中止。相反，我们会是根据索引来迭代每一项。

```Python
>>> elements.add(items[0])
>>> elements.add(items[1])
>>> elements.add(items[2])
>>> elements.add(items[3])
>>> elements.add(items[4])
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
TypeError: unhashable type: 'dict'
>>> elements.add(items[5])
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
TypeError: unhashable type: 'list'
>>> elements.add(items[6])
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
TypeError: unhashable type: 'set'
>>> elements.add(items[7])
>>> elements
{0.1, 1, 'abc', None, (2, 3)}
```

正如你在如上代码片段所看到的，这里对实验结果做出了一个简单的总结。

#### 对本节问题的回答

* 可以被哈希的数据结构：`int`、`float`、`str`、`tuple` 和 `NoneType`。
* 不可以被哈希的数据结构：`dict`、`list` 和 `set`。

即使你对 Python 编程还不太熟悉，但你可能也已经注意到这三种不可哈希的数据结构在实际上都是可变的，而这五种可哈希的数据结构都是不可变的。

本质上，这些可变的数据结构是指其这个对象在创建后可以被更改，而不可变对象的值在创建后不能被更改。

数据结构是否可变是一个单独的问题了，我之前已经讨论于我的这一篇 [文章](https://medium.com/swlh/6-things-to-understand-python-data-mutability-b52f5c5db191)。

## 可哈希意味着什么？

现在你已经知道哪些对象是可以被哈希的，哪些不是，但是哈希到底是什么意思呢？

实际上，你可能听说过许多类似的计算机术语都与哈希相关，如哈希值、哈希化、哈希表和哈希图。它们的核心在于它们有着相同的基本过程 —— 哈希化。

![哈希化的一般过程([维基百科](https://en.wikipedia.org/wiki/Hash_function)，公开发表)](https://cdn-images-1.medium.com/max/2000/1*DMk42PdjZOSHPyqynP1M-Q.png)

上图展示了哈希化的一般过程。我们从一些原始数据值（图中称为 **key**）开始。

哈希函数有时被称为**哈希器**，它将执行特定的计算并输出原始数据值的哈希值（在图中称为 **hashes**）。

哈希化及其相关概念需要一整本书来阐述，那超出了本文的范围。不过，我在我的 [上一篇文章](https://medium.com/better-programming/what-is-hashable-in-swift-6a51627f904) 中简要讨论了一些重要方面。

在这里，我将强调与本次讨论相关的一些要点。

1. 哈希函数应该是**计算健壮**的，以使不同的对象得到不同的哈希值。当不同的对象具有相同的哈希值时就会发生冲突（如上图所示），并应该进行处理。
2. 哈希函数还应该是具有**一致性**，以使相同的对象将始终得到相同的哈希值。

Python 已经实现了内置哈希函数来为它的对象生成哈希值。具体来说，我们可以使用内置的 `hash()` 函数来找到对象的哈希值。下面的代码将向你展示一些示例。

```Python
>>> # 得到一个字符串对象的哈希值
>>> hash("Hello World!")
5892830027481816904
>>> 
>>> # 得到一个元组对象的哈希值
>>> hash((2, 'Hello'))
-4798835419149360612
>>> 
>>> # 得到一个列表对象的哈希值
>>> hash([1, 2, 3])
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
TypeError: unhashable type: 'list'
>>> 
>>> # 得到一个字典对象的哈希值
>>> hash({"a": 1, "b": 2})
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
TypeError: unhashable type: 'dict'
```

正如上述代码所示，我们可以为 `int` 和 `tuple` 类型得到哈希值 —— 整数串。

但是，`list` 对象和 `dict` 对象都没有哈希值，这些结果与我们在上一节中对可哈希对象和不可哈希对象所做的区分是一致的。

#### 对本节问题的回答

* 是否可哈希：Python 对象的一个特性，用于判断对象是否具有哈希值，这将是对象充当字典键或集合中元素的必要条件。

## 我们可以如何定制哈希属性？

Python 作为通用编程语言的灵活性主要来自于它对创建自定义类的支持。有了自己的类，许多相关的数据和操作可以用更有意义和可读性的方式归类。

而且重要的是，Python 已经逐步发展到足够聪明，可以在大多数情况下使我们的自定义对象默认是可哈希的。

正如下面的例子。我们创建了一个自定义类 `Person`，它允许我们通过指定一个人的姓名和社会保险号码来创建实例。

同时值得注意的是，我们使用 f-string 方法重写了默认的  `__repr__()` 函数，这将允许我们用更加可读的信息显示对象，就像代码最后一行所展示的那样。

```Python
>>> # 创建一个自定义类
>>> class Person:
...     def __init__(self, name, ssn):
...         self.name = name
...         self.ssn = ssn
...
...     def __repr__(self):
...         return f"***Name: {self.name}; SSN: {self.ssn}***"
... 
>>> # 创建一个自定义实例并检查哈希值
>>> person0 = Person('John Smith', '012345678')
>>> hash(person0)
272583189
>>> 
>>> # 创建一个包含这个 Person 对象的集合
>>> persons = {person0}
>>> persons
{***Name: John Smith; SSN: 012345678***}
```

如上面的代码所示，我们可以使用内置的 `hash()` 函数来查找创建的对象 `person0` 的哈希值。而且重要的是，我们可以将 `person0` 对象作为元素包含在 `set` 对象中，这很棒哦。

但是，如果我们想向集合中添加更多的 `Person` 实例，会发生什么情况呢？一个更复杂但可能的场景是，我们构造同一个人的多个 `Person` 对象，并尝试将它们添加到 `set` 对象中。

请参阅如下代码。我创建了另一个 `Person` 实例 `person1`，它具有相同的名称和社会保险号码 — 本质上是相同的自然人。

```Python
>>> # 创建了另外一个相同的 Person 对象
>>> person1 = Person('John Smith', '012345678')
>>> 
>>> # 将这个 person1 加入到集合中
>>> persons.add(person1)
>>> persons
{***Name: John Smith; SSN: 012345678***, ***Name: John Smith; SSN: 012345678***}
>>> 
>>> # 比较两个 Person 对象
>>> person0 == person1
False
```

但是，当我们将这个新的对象添加到 `set` 对象 `persons` 时，两个 `Person` 对象却都包含在 `set` 中，这是我们不希望发生的。

因为根据设计，我们希望 `set` 对象存储的自然人都不重复。通过比较 `set` 对象存储的每一个 `Person` 对象，我们需要发现它们都是不相同的。

我将向你展示如何使自定义类 `Person` 更智能，以便它知道哪些自然人对象是相同的，哪些是不同的。

```Python
>>> # 优化 Person 类函数
>>> class Person:
...     # __init__ and __repr__ stay the same
...
...     def __hash__(self):
...         print("__hash__ is called")
...         return hash((self.name, self.ssn))
...
...     def __eq__(self, other):
...         print("__eq__ is called")
...         return (
...             self.__class__ == other.__class__ and 
...             self.name == other.name and
...             self.ssn == other.ssn
...         )
...
>>> # 创建两个 Person 对象
>>> p0 = Person("Jennifer Richardson", 123456789)
>>> p1 = Person("Jennifer Richardson", 123456789)
>>> 
>>> # 创建一个集合，并包含这两个对象
>>> ps = {p0, p1}
__hash__ is called
__hash__ is called
__eq__ is called
>>> ps
{***Name: Jennifer Richardson; SSN: 123456789***}
>>> 
>>> # 比较这两个对象
>>> p0 == p1
__eq__ is called
True
```

在上述代码中，我们通过重写 `__hash__` 和 `__eq__` 函数更新了自定义类 `Person`。

我们之前提到过，`__hash__()` 函数是用于计算对象的哈希值。而 `__eq__()` 函数用于比较对象与另一个对象是否相等，并且要求比较后相等的对象应该具有 [相同的哈希值](https://docs.python.org/3.5/reference/datamodel.html#object.__hash__)。

默认情况下，自定义类的实例是通过使用内置的 `id()` 函数获取的标识进行比较的（如果需要了解更多相关 `id()` 函数的内容请参阅 [本文](https://medium.com/better-programming/use-id-to-understand-6-key-concepts-in-python-73e0bbd461ec)）。

通过更新后的实现，我们可以看到当我们试图创建包含两个相同 `Person` 对象的 `set` 对象时，`__hash__()` 会被调用进行判断，然后集合对象中仅会保留具有唯一哈希值的对象。

另一件需要注意的事情是，当 Python 检查 `set` 对象中的元素是否具有唯一哈希值时，它将通过调用 `__eq__()` 函数来确保这些对象不相等。

#### 对本节问题的回答

定制化：为了提供定制的哈希和比较策略，我们需要在我们的定制类中实现 `__hash__` 和 `__eq__` 函数。

## 总结

在本文中，我们回顾了 Python 里面可哈希和哈希化的概念。

具体来说，通过解决这三个重要问题，我希望你能够更好地理解 Python 中的哈希。当在适用的场景，你可以为自己的自定义类实现定制的哈希行为。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
