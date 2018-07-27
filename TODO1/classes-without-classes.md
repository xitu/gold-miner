> * 原文地址：[Classes Without Classes](https://veriny.tf/classes-without-classes/)
> * 原文作者：[Fuyukai](https://veriny.tf/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/classes-without-classes.md](https://github.com/xitu/gold-miner/blob/master/TODO1/classes-without-classes.md)
> * 译者：[EmilyQiRabbit](https://github.com/EmilyQiRabbit)
> * 校对者：[allenlongbaobao](https://github.com/allenlongbaobao)，[sunhaokk](https://github.com/sunhaokk)

# 不用 Class，如何写一个类

## 前言

Python 的对象模型令人难以置信的强大；实际上，你可以重写所有（对象），或者向任何人分发奇怪的对象，并让他们像对待正常的对象的那样接受它。

Python 的面向对象是 smalltalk 面向对象的一个后裔。在 Python 中，一切都是对象，甚至对象集和对象类型都是如此；特别的，函数也是对象。这让我很好奇：不使用类创建一个类是否可能？

## 代码

这个想法的关键性代码如下所示。这是一个很基础的实现，但它支持 `__call__` 这样的边缘情况（但不支持其他魔术方法，因为他们需要加载依赖）。后文将会解说。

## 有没有搞错？

这是一些很先进的 Python 轮子，它用一种和对象的设计初衷绝不相同的方法使用了一些对象。我们将分段解说代码。

#### 第一个 helper

```
def _suspend_self(namespace, suspended):  
```

这是个让人有点害怕的函数名。暂停？这可不好，但我们是可以解决问题的。`_suspend_self` 函数是 `functools.partial` 的一个简单应用，它的工作原理是：通过从外部函数作用域中捕获 `namespace`，并把它悬停在内部函数中。

```
    def suspender(*args, **kwargs):
        return suspended(namespace, *args, **kwargs)
```

接下来，这个内部的函数调用了和第一个参数 namespace 一起传递进来的函数 suspended，实际上这是将方法又包了一层，这样它就可以应用在一个普通的 Python 类上。`_suspend_self` 余下的部分就只是设置一些属性，这些属性在某些时候可能会被映射（reflection）用到（我可能漏掉一些内容）。

#### 猛兽（beast）

下一个函数是 `make_class`。从它的签名中我们能知道什么？

```
def make_class(locals: dict):  
    """
    在被调用者的本地创建一个类。
    参数 locals：建立类的本地。
    """
```

如果其他方法请求或者直接取得了你的本地变量，可不是什么好事。通常情况下，这是为了在之前的栈中搜索什么东西，或者就是在黑你的本机。我们当前的实例属于前面一种，搜索本地函数并加入到类中。

```
    # 试着找到一个 `__call__` 来执行 call 函数
    # 它将作为一个函数，这样命名空间和被调用者可以引用彼此
    def call_maker():
        if '__call__' in locals and callable(locals['__call__']):
            return _suspend_self(namespace, locals['__call__'])

        def _not_callable(*args, **kwargs):
            raise TypeError('This is not callable')

        return _not_callable
```

这个函数相当简单，它是一个将函数作为返回值的函数！
它实际上做了如下这些事：

*   在函数类中检查你是否已经定义过 `__call__`
*   如果有，就像上文介绍过的那样，用 `_suspend_self` 函数“挂载” namespace 来用 `__call__` 生成一个方法。
*   如果没有，就和默认的 `__call__` 一样，返回一个会发起错误的桩函数（stub function）。

#### 命名空间 namespace

namespace 是关键的部分，然而我还没有解说。类中的每一个（或者绝大部分）方法都会将 `self` 作为第一个参数，这个 `self` 就是函数运行的时候类的实例。

一个类的实例实际上就是一个你可以用 `.` 符号而不是数字索引访问其内容的字典。所以需要一个可以传入我们期望的函数的对象来模仿这个字典。于是我们就说，这个实例是一个 `namespace`，我们在 `namespace` 上设置变量等等。后文提到 `namespace` 的地方，就把它当作我们的实例。通过调用类的对象自身，你可以获取这个类的实例：`obb = SomeClass()`。

标准的创建点式访问的字典的方法是 attrdict：

```
attrdict = type("attrdict", (dict,), {"__getattr__": dict.__getitem__, "__setattr__": dict.__setitem__})  
```

但是既然它创建了一个类，这就有点欺骗性了。其他的方法包括 `typing.SimpleNamespace`，或者创建一个无哨兵（sentinel）的类。但是这两种方法都还是欺骗性的创建了类，我们都不能用。

##### 解决方案

namespace 的解决方案是另一个函数。函数的行为可以像可调用的点式访问字典，所以我们就简单的创建一个  `namespace` 函数，假设它就是 self。

```
    # 这个就充当了 self 对象
    # 所有的属性都建立在此之上
    def namespace():
        return called()
```

需要注意调用 `called()` 的用法 - 这是为了正常模拟实例上 `__call__` 的行为。

#### 创建 `__init__`

Python 中的所有类都有 `__init__`（不包括默认提供空 init 的类），所以我们需要去模仿这一点并确保用户定义的 init 被调用。

```
    # 创建一个 init 的替代方法
    def new_class(*args, **kwargs):
        init = locals.get("__init__")
        if init is not None:
            init(namespace, *args, **kwargs)

        return namespace
```

这段代码就是简单的从本地获取用户定义的 `__init__`，如果找到了，就调用它。然后，它返回 namespace（就是假的实例），有效地模拟了循环：`(metaclass.)__call__` -> `__new__` -> `__init__`。

#### 清理

接下来要做的就是在类的基础上创建方法，这可以用超级简单的循环扫描来完成：

```
    # 更新 namespace
    for name, item in locals.items():
        if callable(item):
            fn = _suspend_self(namespace, item)
            setattr(namespace, name, fn)
```

和上文提到的相似，所有可调用的函数都被 `_suspend_self` 包裹来将函数变成类的方法，在 namespace 完成设置。

#### 获取到类

最后要做的就是简单的 `return new_class`。获取到类的实例的最后一轮循环是：

*   用户的代码定义了一个类函数
*   当类函数被调用，该函数调用 `make_class` 来设置 namespace（添加 `@make` 修饰符，这一步就能自动完成）
*   `make_class` 函数设置实例，使其为后续的初始化做好准备
*   `make_class` 函数返回另一个函数，调用这个函数就能获取到实例并完成它的初始化。

现在我们就得到它了，一个完全没用类的类。打赌你会实际应用它。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
