> * 原文地址：[The One Python Library Everyone Needs](https://glyph.twistedmatrix.com/2016/08/attrs.html)
* 原文作者：[glyph](https://twitter.com/glyph)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[Gran](https://github.com/Graning)
* 校对者：[Siegen](https://github.com/siegeout), [陈超邦](https://github.com/cbangchen)

# 人人都应该用的 Python 开源库 

你想问为什么？不用问，使用就好了。

好吧好吧，让我来回顾一下吧。

我爱 Python；它作为我的主要编程语言已经超过十年了，尽管在此期间有一些 [有趣](https://www.haskell.org) 且 [不断成长](https://www.rust-lang.org) 的语言出现，但是我并没有计划切换到其他编程语言上面去。

但 Python 也不是完美的。某些情况下，它促使你做了错误的事情。由于类的继承以及许多库使用 God-object  这个反面模式的原因，这种情况不断扩散开来。

也许某个可能的原因是，Python 是一门非常容易上手的语言，所以经验较少的程序员会犯下错误，而那些错误也会 [一直存在](https://twistedmatrix.com/documents/current/core/development/policy/compatibility-policy.html)。

但是我认为也许更重要的原因是，Python有时会惩罚你，因为你试图去做「正确的事情」。

在对象设计的背景下做「正确的事」是让许多小的，独立的类，[只做一件事](https://en.wikipedia.org/wiki/Single_responsibility_principle) 并 [做好](https://www.destroyallsoftware.com/talks/boundaries)。例如，如果你发现你的对象累积了大量的私有方法，也许你应该让私有属性的方法公开。但是如果这样做很麻烦，你可能就不想公开了。

当你在另一处有相关数据包时你可能要定义对象、相互的关系、常量和行为解释。Python 使得它很容易只定义一个元组或列表。当你第一次键入 `host, port = ...` 代替 `address = ...` ，它似乎并不像是一个大问题。但很快你将到处输入 `[(family, socktype, proto, canonname, sockaddr)] = ...` 你的人生将充满遗憾。如果你幸运的话，情况就是这样。但如果你 **不够** 幸运，你只是维护代码，做一些诸如 `values[0][7][4][HOSTNAME][“canonical”]` 的事你的生活将充满各种花式 **痛苦** 而不是遗憾。

* * *

这就提出了一个问题：在 Python 中创建一个类是很令人讨厌的事吗？让我们看一个简单的数据结构：一个三维直角坐标。从它开始应该是足够简单的。

```
class Point3D(object):
```

到现在为止还挺好。我们已经有了一个三维点，接下来是什么？


```
class Point3D(object):
    def __init__(self, x, y, z):

```

我只想要一个存储少量数据的容器，但我已经不得不根据内部命名规定重写了 Python 运行时的一个特殊函数方法？我感觉这也不是 **特别** 糟糕；**所有** 的程序在过时之后勉强来说也不过是一种特殊的符号罢了。

至少我看到有我的属性名，这是有道理的。


```
class Point3D(object):
    def __init__(self, x, y, z):
        self.x

```

我已经说过我想要一个 `x` ，但现在我必须把它指定为一个属性...


```
class Point3D(object):
    def __init__(self, x, y, z):
        self.x = x

```

... 为 `x` ？嗯，**很明显** ...


```
class Point3D(object):
    def __init__(self, x, y, z):
        self.x = x
        self.y = y
        self.z = z

```

... 现在我必须为每个属性做一次，所以实际上这个 **尺度** 真的把握的很糟糕吗？我一定要每个属性都这样输入 3 次吗 ？！

噢好吧。至少现在我已经完成了。


```
class Point3D(object):
    def __init__(self, x, y, z):
        self.x = x
        self.y = y
        self.z = z
    def __repr__(self):

```

等等，你说我还没有完成是什么意思。


```
class Point3D(object):
    def __init__(self, x, y, z):
        self.x = x
        self.y = y
        self.z = z
    def __repr__(self):
        return (self.__class__.__name__ +
                ("(x={}, y={}, z={})".format(self.x, self.y, self.z)))

```

噢拜托。我一定要每个属性都输入 5 次它的名字？当我调试的时候如果我希望能够看到里面的内容，甚至说我可以自由的获取其中的某一个元组吗?!


```
class Point3D(object):
    def __init__(self, x, y, z):
        self.x = x
        self.y = y
        self.z = z
    def __repr__(self):
        return (self.__class__.__name__ +
                ("(x={}, y={}, z={})".format(self.x, self.y, self.z)))
    def __eq__(self, other):
        if not isinstance(other, self.__class__):
            return NotImplemented
        return (self.x, self.y, self.z) == (other.x, other.y, other.z)

```

**7** 次?!


```
class Point3D(object):
    def __init__(self, x, y, z):
        self.x = x
        self.y = y
        self.z = z
    def __repr__(self):
        return (self.__class__.__name__ +
                ("(x={}, y={}, z={})".format(self.x, self.y, self.z)))
    def __eq__(self, other):
        if not isinstance(other, self.__class__):
            return NotImplemented
        return (self.x, self.y, self.z) == (other.x, other.y, other.z)
    def __lt__(self, other):
        if not isinstance(other, self.__class__):
            return NotImplemented
        return (self.x, self.y, self.z) < (other.x, other.y, other.z)

```

**9** 次?!


```
from functools import total_ordering
@total_ordering
class Point3D(object):
    def __init__(self, x, y, z):
        self.x = x
        self.y = y
        self.z = z
    def __repr__(self):
        return (self.__class__.__name__ +
                ("(x={}, y={}, z={})".format(self.x, self.y, self.z)))
    def __eq__(self, other):
        if not isinstance(other, self.__class__):
            return NotImplemented
        return (self.x, self.y, self.z) == (other.x, other.y, other.z)
    def __lt__(self, other):
        if not isinstance(other, self.__class__):
            return NotImplemented
        return (self.x, self.y, self.z) < (other.x, other.y, other.z)

```

好了，噢 ~ 2 行多代码不是很多，但至少现在我们还没有定义其他所有的比较方法。但 **现在** 我们就大功告成了，对不对？


```
from unittest import TestCase
class Point3DTests(TestCase):

```

你知道吗？我受够了。到现在写了 20 行代码，而这个类什么功能都还没有；这个问题最困难的部分应该是四元求解器，而不是「做可以打印和比较的数据结构」。我被成堆的无用的元组，列表和字典所淹没；用 Python 定义好合适的数据结构实在太辛苦了。

* * *

## `namedtuple` 救援（不是真正意义上的）。

标准库对这个难题的回答是 [`namedtuple`](https://docs.python.org/2.7/library/collections.html#collections.namedtuple)。虽然初稿中（在这流派中和他有许多相似之处而 [我自己](https://github.com/twisted/epsilon/blob/master/epsilon/structlike.py) 有一些尴尬和过时的条目） `namedtuple` 的不幸是无法挽救的。它导出了巨大的不良公共功能量这将是兼容性维护的巨大噩梦，并且它没有解决一半，一个跑入的问题。它的缺点完整枚举是单调乏味的，但也有一些亮点。


*   他们通过编号指标进行访问无论您是否希望这样做。除此之外，这意味着你不能有私有属性，因为他们通过明显的公共接口 `__getitem__` 暴露出来。
*   它比较相等的值相同的原始 `tuple` ，所以很容易陷入离奇的类型混乱，特别是如果你想用它来使用 `tuple` 和 `list` 进行迁移。
*   这是一个元组，所以它 **总是** 一成不变的。
至于最后一点，你可以像它这样使用：


```
Point3D = namedtuple('Point3D', ['x', 'y', 'z'])

```

这种情况下，它看起来并不 **像** 代码中的类型；无特殊情况下，简单的语法分析工具不能将它识别为一体。你不能给其它任何行为这种方式，因为这个方法没有其他地方可以放置。更何况事实是，每个类的名字你必须输入两次。

或者您可以使用继承这样做：


```
class Point3D(namedtuple('_Point3DBase', 'x y z'.split()])):
    pass

```

给你一个可以放置方法以及文档字符串的地方，一般有它看起来像一个类，它是...但是现在返回了一个奇怪的内部名称（顺便说一句，显示的内容在 `repr` ，而不是类的实际名称）。不过你也可以默默列出此处未列出的可变属性，以及添加 `class` 声明的一个奇怪的副作用；也就是说，除非你给类体加上 `__slots__ = 'x y z'.split()` ，否则我们只是回到每个属性将名称打两次。

还没提到的已经被证明的 [你不应该使用继承](https://www.youtube.com/watch?v=3MNVP9-hglc)。

因此，`namedtuple` 是可以改善的如果它是你将要做的，只是在某些情况下，它自己存在一些奇怪的包。

* * *

## 键入 `attr`

因此，这里就是我最喜欢的强制 Python 库的用武之地。

让我们重新审视上述问题。如何使 `Point3D` 用上 `attrs` ?

```
import attr
@attr.s
```

由于这个框架没有内置在这门语言中，所以我们确实需要使用两行代码来开始：import 和 decorator 语句说明我们可以开始使用这个框架。


```
import attr
@attr.s
class Point3D(object):

```

你看，没有继承！通过使用类修饰符， `Point3D`  可以维持原先旧的 Python 类的样子。


```
import attr
@attr.s
class Point3D(object):
    x = attr.ib()

```

他有一个名为 `x` 的属性。


```
import attr
@attr.s
class Point3D(object):
    x = attr.ib()
    y = attr.ib()
    z = attr.ib()

```

一个叫 `y` 一个叫 `z` 我们就大功告成了。

我们做了什么？等待。一个不错的字符串表示？


```
>>> Point3D(1, 2, 3)
Point3D(x=1, y=2, z=3)

```

比较？


```
>>> Point3D(1, 2, 3) == Point3D(1, 2, 3)
True
>>> Point3D(3, 2, 1) == Point3D(1, 2, 3)
False
>>> Point3D(3, 2, 3) > Point3D(1, 2, 3)
True

```

好了，但如果我想提取一个适合 JSON 序列化格式有明确属性定义的数据该怎么做？


```
>>> attr.asdict(Point3D(1, 2, 3))
{'y': 2, 'x': 1, 'z': 3}

```

也许这最后的一点点。但尽管如此，它应该变得更容易，因为 `attrs` 让你 **声明域的类** ，有很多关于他们可能感兴趣的元数据以及其他东西，然后获取元数据退出。

```
>>> import pprint
>>> pprint.pprint(attr.fields(Point3D))
(Attribute(name='x', default=NOTHING, validator=None, repr=True, cmp=True, hash=True, init=True, convert=None),
 Attribute(name='y', default=NOTHING, validator=None, repr=True, cmp=True, hash=True, init=True, convert=None),
 Attribute(name='z', default=NOTHING, validator=None, repr=True, cmp=True, hash=True, init=True, convert=None))

```

我不打算深入到 `attrs`  **每个** 有趣的功能；你可以阅读该文档。另外，它有良好的维护，因此总有新的东西出现，我可能会错过一些重要的事情每隔一段时间。但是 `attrs` 这样做，一旦你使用它们，你就会意识到 Python 之前非常的缺少此类东西。 

1.  它允许您定义简洁的类型，而不是相当冗长的 `def __init__...` 。类型无需键入。
2.  它可以让你说你 **直接声明的意思** ，而不是拐弯抹角的表达它。用「我有一个类型，他被称为 MyType ，它具有 `a` 的属性和行为，可以直接得到，而不必通过逆向工程猜测它的行为（例如，运行 `dir` 的实例，或寻找`self.__class__.__dict__`）。」来代替「我有一个类型，它被称为 MyType ，它有一个构造函数，我分配属性 ‘A’ 到参数 ‘A’ 。」
3.  它 **提供了有用的默认行为**，而不是 Python 的有时有用但是经常向后的默认值。
4.  它增添了一个让你 **稍后更严格的执行** ，简单的开始。

让我们来探讨最后一点。

## 逐步增强

目前我不打算谈论 **每个** 功能，如果我没提到其中的几个是我的失职。你可以在那些 `repr()` 对于 `Attribute` 的新文章中看到，还会有许多其他有趣的东西。 

例如：你可以验证被传递到  `@attr.s` 类验证属性，我们的三维点，例如，可能应该包含数字。为了简单起见，我们可以说，在 `float` 情况下，像这样：

<div style="">

```
import attr
from attr.validators import instance_of
@attr.s
class Point3D(object):
    x = attr.ib(validator=instance_of(float))
    y = attr.ib(validator=instance_of(float))
    z = attr.ib(validator=instance_of(float))

```

我们使用 `attrs` 意味着我们要有一个额外验证每个属性的区域；我们可以只添加类型信息的每个属性，因为我们需要它。其中的一些东西让我们避免其他常见的错误。例如，这是一种流行的 “spot the bug” 的 Python 面试问题。


```
class Bag:
    def __init__(self, contents=[]):
        self._contents = contents
    def add(self, something):
        self._contents.append(something)
    def get(self):
        return self._contents[:]
a
```

解决它，当然，变成这样了。


```
class Bag:
    def __init__(self, contents=None):
        if contents is None:
            contents = []
        self._contents = contents

```

添加两行额外的代码。

`contents` 不经意间成为这里的一个全局变量，使所有的 `Bag` 对象没有设置不同的列表共享相同的列表。有了 `attrs` 这个代替变为：


```
@attr.s
class Bag:
    _contents = attr.ib(default=attr.Factory(list))
    def add(self, something):
        self._contents.append(something)
    def get(self):
        return self._contents[:]

```

还有一些其他的功能， `attrs` 提供了让你的类更加方便准确的机会。另一个例子？如果你想让与对象无关的属性更严格（或者在 CPython 上有更高的内存效率），你可以在类的层次上把 slots设置为 True，例如 `@attr.s(slots=True)` 自动开启 `attrs` 的声明匹配 [`__slots__` ](https://docs.python.org/3.5/reference/datamodel.html#object.__slots__)属性。所有的这些方便的功能让你使用你的 `attr.ib()` 声明做出更好，更强大的东西。

* * *

## Python 的未来

对于最终能够全面的在 Python 3 中编程，一些人很兴奋。而 **我** 期待的是能够全面的在 Python-with-`attrs` 中编程。它对我见过的所有的代码库都产生了细微但是有益的设计影响。

试试看：对于你现在将使用一个整洁的解释类的地方，你可能会非常的惊讶，而在以前，你可能在那些地方使用描述很少的元组，列表或字典，忍受着因为共同维护带来的混乱。现在，拥有一些结构类型是非常容易的，它们清晰明确的指出目的方向（在他们  `__repr__` 和 `__doc__` 中，甚至只是在其属性中的名称），你可能会发现你会更多的使用它。你的代码将会变得更好，我知道我的代码已经是了。


* * *

1.  在这里缺乏引用是因为属性暴露给 `__caller__` 没有意义，他们只是被公开的命名而已。这种模式，它完全摆脱了私有方法并且只拥有唯一的私有属性，可以很好的应对它自己传递的参数。 ↩

2.  我们尚未得到真正令人兴奋的东西：构造时的类型认证，可变的默认值... ↩

