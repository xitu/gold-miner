> * 原文地址：[6 Things to Know to Get Started With Python Data Classes](https://medium.com/better-programming/6-things-to-know-to-get-started-with-python-data-classes-c795bf7e0a74)
> * 原文作者：[Yong Cui, Ph.D.](https://medium.com/@yong.cui01)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/6-things-to-know-to-get-started-with-python-data-classes.md](https://github.com/xitu/gold-miner/blob/master/article/2020/6-things-to-know-to-get-started-with-python-data-classes.md)
> * 译者：
> * 校对者：

# 6 Things to Know to Get Started With Python Data Classes

![Photo by [Philipp Katzenberger](https://unsplash.com/@fantasyflip?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/12000/0*p3gDT4yY_Ej-8fyA)

Data are the most essential element in any programming project. All programs are destined to have certain interactions with data. For instance, if your project is a website, you have to present data (e.g., texts and images) in a user-friendly manner. If your project uses machine learning to predict financial trends, you have to prepare data that can be learned by your models.

As a general-purpose programming language, Python has evolved to have a versatile battery of tools to support the management of data in your projects. Among these tools, data classes are a useful yet easy-to-grasp technique. In this article, I’d like to introduce you to the data class model with the key highlights that allow you to get started with this data management tool.

## 1. Define a Data Class

Data-class-related functionalities are defined in the `dataclasses` module, which is part of the standard Python library. The most important element of this module is the `dataclass` decorator. The following code shows you how we use the `dataclass` decorator for our custom class that we define to manage bills in a restaurant.

```Python
from dataclasses import dataclass


@dataclass
class Bill:
    table_number: int
    meal_amount: float
    served_by: str
    tip_amount: float = 0.0
```

Specifically, we use the `dataclass` decorator to decorate the custom class that we’re defining. In the defined class, we specify the attributes (termed fields for data classes) that belong to the class.

You may ask why we bother using the `dataclass` decorator. It’s because this decorator can help us get rid of some boilerplates, such as `__init__` and `__repr__`. In other words, using this decorator for our custom class, we don’t need to implement these functions — instead, the decorator will take care of that for us, as shown below.

```Python
>>> bill0 = Bill(table_number=5, meal_amount=50.5, served_by="John", tip_amount=7.5)
>>> print(f"Today's first bill: {bill0!r}")
Today's first bill: Bill(table_number=5, meal_amount=50.5, served_by='John', tip_amount=7.5)
```

As shown above, without explicitly defining the initialization and representation methods, both are idiomatically implemented. Isn’t it cool?

## 2. Type Annotations and Default Field Values

In the data class shown above, its fields all have type annotations to clearly indicate their types. After all, data classes are developed to mostly handle data, and it makes sense that we’re explicit about the types of data that the data class holds.

Mechanistically speaking, the data class’s fields are required to have type annotations. Otherwise, your code can’t execute. Under the hood, the `dataclass` decorator generates fields based on the annotations of your class, which can be retrieved using the `__annotations__` special method.

```
>>> Bill.__annotations__
{'table_number': <class 'int'>, 'meal_amount': <class 'float'>, 'served_by': <class 'str'>, 'tip_amount': <class 'float'>}
```

Another thing to note is that for the fields that you’re defining for the data class, you can have default values. As you may have noticed, the `tip_amount` field has the default value of 0.0. It’s important to know that when you don’t define default values for all the fields, the ones with default values should come after the ones without. You don’t want to see the following error.

```
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

## 3. Equality/Inequality Comparisons

Besides the initialization and representation methods, the `dataclass` decorator also implements the comparison-related functionalities for us. We know that for a regular custom class, we can’t have meaningful comparisons between instances if we don’t define the comparison behaviors. Consider the following custom class that doesn’t use the `dataclass` decorator.

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

As shown above, with a regular class, two instances with the same values for all attributes are evaluated to be unequal because these custom class instances are compared by their identities by default. In this case, these two instances are two distinct objects, and they’re deemed to be unequal.

However, with a data class, such an equality comparison evaluates `True`. This is because the `dataclass` decorator will also automatically generate the `__eq__` special method for us. Specifically, equality comparison is conducted as if each of these instances is a tuple that contains the fields in the order that is defined. Because the two data class instances have the fields of the same values, they’re considered equal.

How about inequality comparisons, such as greater than and less than? They’re also possible with the `dataclass` decorator by specifying the `order` parameter for the decorator, as shown below in Line 1.

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

Similar to the equality comparisons, data class instances are compared as if they’re tuples of these fields, and they’re compared as tuples lexicographically. For a proof of concept, the above code only includes two fields, and as you can see, the comparison results are based on the tuple’s order.

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

```
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

```
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
