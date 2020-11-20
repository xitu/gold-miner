> * 原文地址：[6 Things to Know to Get Started With Python Data Classes](https://medium.com/better-programming/6-things-to-know-to-get-started-with-python-data-classes-c795bf7e0a74)
> * 原文作者：[Yong Cui, Ph.D.](https://medium.com/@yong.cui01)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/6-things-to-know-to-get-started-with-python-data-classes.md](https://github.com/xitu/gold-miner/blob/master/article/2020/6-things-to-know-to-get-started-with-python-data-classes.md)
> * 译者：[JalanJiang](http://jalan.space/)
> * 校对者：

# 上手 Python 数据类前需要知道的 6 件事

![图源 [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)，摄影者 [Philipp Katzenberger](https://unsplash.com/@fantasyflip?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/12000/0*p3gDT4yY_Ej-8fyA)

在任何程序项目中，数据都是最重要的元素。所有的程序都必然会与数据进行某些互动。例如，你的项目是一个 Web 站点，你就需要以一个用户友好的方式展现数据（文本或图片）。如果你的项目使用机器学习来预测经济趋势，你就需要以模型可学习的方式来准备数据。

作为一个多用途的编程语言，Python 已发展出多种工具，以便于支持你项目中的数据管理。在这些工具中，数据类是一种有用且易于掌握的技术。在这篇文章中，我想向你介绍数据类模型，并突出重点，让你能够上手这一数据管理工具。

## 1. 定义一个数据类

Python 的标准库 `dataclasses` 模块定义了数据与类关联的功能。这个模块最重要的元素是 `dataclass` 装饰器。下面的代码向你展示了如何使用 `dataclass` 装饰器来定义一个用于管理餐厅账单的自定义类。

```Python
from dataclasses import dataclass


@dataclass
class Bill:
    table_number: int
    meal_amount: float
    served_by: str
    tip_amount: float = 0.0
```

具体而言，我们使用 `dataclass` 装饰器装饰了自定义类。在被定义的类中，我们列举了类的属性（数据类的术语）。

你可能会问，为什么我们要如此麻烦地使用 `dataclass` 装饰器？这是因为 `dataclass` 装饰器可以帮助我们摆脱一些样板代码，例如 `__init__` 和 `__repr__`。换句话说，在我们的自定义类上使用该装饰器，我们就不再需要实现这些函数 —— 取而代之的是，装饰器会帮助我们实现它们，就像下面这样。

```Python
>>> bill0 = Bill(table_number=5, meal_amount=50.5, served_by="John", tip_amount=7.5)
>>> print(f"Today's first bill: {bill0!r}")
Today's first bill: Bill(table_number=5, meal_amount=50.5, served_by='John', tip_amount=7.5)
```

就像上面展示的那样，无需明确定义构造与展示方法，两种方法都按惯例被实现了。是不是很酷？

## 2. 类型注释与默认字段值

在上面所展示的数据类中，所有字段都拥有类型注释，清晰地表明了它们的类型。毕竟数据类主要用于数据处理，我们明确地标出数据类所包含的数据类型是有意义的。

请容我机械地重复一遍，数据类的字段必须有类型注释。否则，我们的代码将无法执行。`dataclass` 装饰器在幕后根据类中的注释生成字段，这些字段可以使用 `__annotations__` 特殊方法进行检索。

```Python
>>> Bill.__annotations__
{'table_number': <class 'int'>, 'meal_amount': <class 'float'>, 'served_by': <class 'str'>, 'tip_amount': <class 'float'>}
```

另一件值得注意的事情是，你在数据类中定义的字段可以拥有默认值。你可能注意到了，`tip_amount` 字段的默认值是 0.0。重要的是你需要知道，当你没有为所有字段指定默认值时，有默认值的字段应当放在在没有默认值的字段之后。你必然不想看到以下错误。

```Python
@dataclass
... class SpecialBill:
...     table_number: int = 888
...     meal_amount: float
...     served_by: str
...     tip_amount: float = 0.0
... 
Traceback (most recent call last):
  ...some traceback info omitted
TypeError: non-default argument 'meal_amount' follows default argument
```

## 3. 相等/不相等的比较

除了构造与展示方法，`dataclass` 装饰器还为我们实现了比较相关的功能。我们知道，对自定义类而言，如果没有定义用于比较的方法，我们不能在实例之间进行有意义的比较。思考以下没有使用 `dataclass` 装饰器的自定义类。

```Python
>>> old_bill0 = OldBill(table_number=3, meal_amount=20.5, served_by="Dan", tip_amount=5)
... old_bill1 = OldBill(table_number=3, meal_amount=20.5, served_by="Dan", tip_amount=5)
... print("Comparison Between Regular Instances:", old_bill0 == old_bill1)
... 
Comparison Between Regular Instances: False
>>> bill0 = Bill(table_number=5, meal_amount=50.5, served_by="John", tip_amount=7.5)
... bill1 = Bill(table_number=5, meal_amount=50.5, served_by="John", tip_amount=7.5)
... print("Comparison Between Data Class Instances:", bill0 == bill1)
... 
Comparison Between Data Class Instances: True
```

如上所示，在常规的类中，两个所有属性值都相等的实例会被评估为不相等。因为在默认情况下，自定义类的实例是根据其标识进行比较的。在这种情况下，这两个实例是两个截然不同的对象，因此它们被认为是不相等的。

然而，在数据类中，同等的比较将被判定为 `True`。这是因为 `dataclass` 装饰器会为我们自动生成特殊方法 `__eq__`。准确地说，进行相等比较时，视每个实例为一个元组，元组内包含按顺序定义的字段。因为这两个数据类的字段拥有相同值，所以它们被认为是相等的。

那么不相等的比较呢，例如大于和小于，又应当如何呢？我们也可以使用 `dataclass` 装饰器，在使用装饰器时指定 `order` 参数，如下面的第 1 行所示。

```Python
>>> @dataclass(order=True)
... class ComparableBill:
...     meal_amount: float
...     tip_amount: float
... 
... 
... bill1 = ComparableBill(meal_amount=50.5, tip_amount=7.5)
... bill2 = ComparableBill(meal_amount=50.5, tip_amount=8.0)
... bill3 = ComparableBill(meal_amount=60, tip_amount=10)
... print("Is bill1 less than bill2?", bill1 < bill2)
... print("Is bill2 less than bill3?", bill2 < bill3)
... 
Is bill1 less than bill2? True
Is bill2 less than bill3? True
```

与相等比较类似，数据类实例被当作这些字段的元组，并按字典顺序进行比较。为了验证这一概念，上面的代码只包含两个字段，如你所见，比较结果基于元组的顺序。

## 4. Mutability Consideration

By default, the fields of data classes can be modified, and thus we can say that data class instances are mutable. This is why some people refer to data classes as **mutable named tuples**. Consider the following contrast between named tuples and data classes regarding their mutability.

```Python
>>> from collections import namedtuple
>>> NamedTupleBill = namedtuple("NamedBill", "meal_amount tip_amount")
>>> 
>>> @dataclass
... class DataClassBill:
...     meal_amount: float
...     tip_amount: float
... 
>>> namedtuple_bill = NamedTupleBill(20, 5)
>>> dataclass_bill = DataClassBill(20, 5)
>>> namedtuple_bill.tip_amount = 6
Traceback (most recent call last):
  File "<input>", line 1, in <module>
AttributeError: can't set attribute
>>> dataclass_bill.tip_amount = 6
```

As shown above, you can’t set the attribute of a named tuple. However, we can do that with a data class instance, which highlights the advantages of supporting mutability of data classes.

However, data mutability isn’t always desired. In some cases, you don’t want your data to be mutable. In such a scenario, you can consider specifying the `frozen` parameter to be `True` when you use the `dataclass` decorator. A trivial example is shown below.

```Python
>>> @dataclass(frozen=True)
... class ImmutableBill:
...     meal_amount: float
...     tip_amount: float
... 
>>> immutable_bill = ImmutableBill(20, 5)
>>> immutable_bill.tip_amount = 7
Traceback (most recent call last):
  File "<input>", line 1, in <module>
  File "<string>", line 4, in __setattr__
dataclasses.FrozenInstanceError: cannot assign to field 'tip_amount'
```

## 5. Inheritance Considerations

At its core, a data class has the same extensibility as other regular custom classes. Thus, we can subclass a data class if we have such a need.

```Python
>>> @dataclass
... class BaseBill:
...     meal_amount: float
... 
>>> 
>>> @dataclass
... class TippedBill(BaseBill):
...     tip_amount: float
... 
>>> tipped_bill = TippedBill(meal_amount=20, tip_amount=5)
```

As shown in the above code snippet, the `dataclass` decorator will consider the base class’s fields for the subclass. In other words, as you can see from the initialization of the subclass, it automatically has the signature of the fields from the base class and the subclass itself. Notably, the order is based on the definition order — the base class’s fields go first and the subclass’s fields go next and so on if you have multiple generations of subclassing.

Because of the order of these fields in the subclass and the requirement that data classes’ fields with default values should precede those without default values, the implication is that if a base class has fields with default values, the subclasses’ added fields should have default values, too. Otherwise, you may see the following error — the same error that we’ve seen previously.

```Python
@dataclass
... class BaseBill:
...     meal_amount: float = 20
... 
@dataclass
... class TippedBill(BaseBill):
...     tip_amount: float
... 
Traceback (most recent call last):
  ... some traceback info omitted
TypeError: non-default argument 'tip_amount' follows default argument
```

## 6. Mutable Fields With Default Values

In the above examples, the fields are all immutable data types, such as floats and strings. What should we do if we need to use mutable data as data class’s fields? Consider the following code snippet involving some mistakes that Python programmers can make.

```Python
>>> class IncorrectBill:
...     def __init__(self, costs_by_dish=[]):
...         self.costs_by_dish = costs_by_dish
... 
>>> bill0 = IncorrectBill()
>>> bill1 = IncorrectBill()
>>> bill0.costs_by_dish.append(5)
>>> bill1.costs_by_dish.append(7)
>>> print("Bill 0 costs:", bill0.costs_by_dish)
Bill 0 costs: [5, 7]
>>> print("Bill 1 costs:", bill1.costs_by_dish)
Bill 1 costs: [5, 7]
>>> bill0.costs_by_dish is bill1.costs_by_dish
True
```

The above code shows you that when your function uses a mutable default value, you can’t really set the default value using a mutable instance because this object will be shared by all callers who don’t specify the parameter. In the above example, as you can see, both instances are sharing the same underlying list object, which causes undesired side effects.

Within the context of data classes, the question is how we can specify a default value for the mutable fields. We shouldn’t do the following, and a `ValueError` exception will be raised.

```Python
@dataclass
class IncorrectBill:
    costs_by_dish: list = []

ValueError: mutable default <class 'list'> for field costs_by_dish is not allowed: use default_factory
```

The error message tells us the solution, which involves using the `default_factory` when we specify the field. The code below shows you how it works.

```Python
>>> from dataclasses import field
... @dataclass
... class CorrectBill:
...     costs_by_dish: list = field(default_factory=list)
... 
>>> bill0 = CorrectBill()
>>> bill0.costs_by_dish.append(5)
>>> bill1 = CorrectBill()
>>> bill1.costs_by_dish.append(7)
>>> print("Bill 0 costs:", bill0.costs_by_dish)
Bill 0 costs: [5]
>>> print("Bill 1 costs:", bill1.costs_by_dish)
Bill 1 costs: [7]
>>> bill0.costs_by_dish is bill1.costs_by_dish
False
```

* We import the `field` function from the `dataclasses` module.
* In the `field` function, we specify the `list` to be the `default_factory` parameter. In essence, this parameter sets the default factory function, which is a zero-parameter function to be used when the instance is to be created. In this case, the `list` function is the construction method for a list object that creates a new list object when we call `list()`.
* As you can see, in both instances, they have distinct list objects for the `costs_by_dish` attribute, as expected.

## Conclusions

In this article, we reviewed six of the most basic elements that we should know to get started with data classes in Python. In essence, they’re very useful to store data, and the `dataclass` decorator takes care of many boilerplates for us. Compared to named tuples, they’re more flexible, by allowing mutability.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
