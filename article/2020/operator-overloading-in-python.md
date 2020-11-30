> * 原文地址：[Operator overloading in Python](https://medium.com/python-in-plain-english/operator-overloading-in-python-6dbf90be9d3e)
> * 原文作者：[aditya dhanraj tiwari](https://medium.com/@adityadhanrajtiwari898)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/operator-overloading-in-python.md](https://github.com/xitu/gold-miner/blob/master/article/2020/operator-overloading-in-python.md)
> * 译者：
> * 校对者：

# Operator overloading in Python

![pic credits LocalNav](https://cdn-images-1.medium.com/max/2000/1*n54WXtELB8VR8qC-AJphhg.jpeg)

Each operator can be used in different way for different types of operands. for example when `+` is used with integers, it add integers to give result and when `+` is used with string, it concatenates the provided strings.

```py
x, y = 10, 20
print(x + y) # 30

a,b = 'John', 'Wick'
print(a + b) # John Wick
```

This change in behaviour of `**+**` operator according to type of operands provided, is called Operator overloading

**Operator overloading refers to the ability of operator to behave differently depending on operands it acts on.**

Can `+` operator add any two object? Let’s see.

```py
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

Running the above will give you error. why? because `+` does not know how to add two objects of Vector class.

In this article we will explore how to make built-in operator play well with user defined objects, keeping limitations Python imposes on operator overloading in mind.

These limitations are →

1. You can not create new operators, only overloads existing ones
2. You can not overload operators for built-in types like tuple, string, list.
3. Few operators can not be overloaded like **is**, **or**, **and**, **not**

To start with Operator overloading, we need to know what is **Python Data model** and **Special methods.**

Think Python data model as an ‘Python Design’ or ‘Python Framework’. It tells you how python manages objects and perform operation on them. it describes an Api which you can use to make your objects work like built-in type and use most of the idiomatic features of python language without implementing them.

**Special methods** → When you use len(collection) , python interpreter invoke collection.__len__() method. Here __len__() is a special method.

Special method starts with __ and end with __ and are meant to be invoked by python interpreter only, not by you unless you are doing **metaprogramming**.

Using special methods we can achieve operator loading in Python.

Now make our Vector class support `+` operator

When we call `**+**` operator, Python interpreter invoke **__add__(self, other)** special method. In that case, to support + operator we need to implement __add__() special method in our class.

```py
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

Now you can see our class support `+` operator , we have also implemented __repr__() method, when we use print(), interpreter invoke __str__() method, if it is not implemented it will call __repr__() method.

> Note: Always return new object when overloading operator unless you are overloading augmented assignment like += operator.

Take one more example of overloading operator

When we use `**==**` operator, Python interpreter invoke __eq__(self, other) special method, in that case by implementing __eq__() method we can support `==` operator.

```py
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

Operator overloading in python is easy to implement using special methods. The key is to understand the Python data model and Special methods.

These concepts allow you to get benefit of python idiomatic features and leverage powerful python standard library.

To understand python data model in more detail please refer [Fluent python](https://www.oreilly.com/library/view/fluent-python/9781491946237/ch01.html).

Please find list of special methods in Python [here](https://docs.python.org/3/reference/datamodel.html).

## Summary

We started by understanding what Operator Overloading is. Then reviewed restrictions imposed on operator overloading in Python, data model and Special methods, after that we implemented operator overloading for our Vector class.

I hope you have enjoyed this article. Good Luck, Happy Coding 😃

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
