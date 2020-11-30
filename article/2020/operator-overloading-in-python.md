> * 原文地址：[Operator overloading in Python](https://medium.com/python-in-plain-english/operator-overloading-in-python-6dbf90be9d3e)
> * 原文作者：[aditya dhanraj tiwari](https://medium.com/@adityadhanrajtiwari898)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/operator-overloading-in-python.md](https://github.com/xitu/gold-miner/blob/master/article/2020/operator-overloading-in-python.md)
> * 译者：
> * 校对者：

# Operator overloading in Python

## Operator Overloading in Python

#### How to make your object play well with built-in operators

![pic credits LocalNav](https://cdn-images-1.medium.com/max/2000/1*n54WXtELB8VR8qC-AJphhg.jpeg)

Each operator can be used in different way for different types of operands. for example when `+` is used with integers, it add integers to give result and when `+` is used with string, it concatenates the provided strings.

```
x, y = 10, 20
print(x + y) # 30

a,b = 'John', 'Wick'
print(a + b) # John Wick
```

This change in behaviour of `**+**` operator according to type of operands provided, is called Operator overloading

**Operator overloading refers to the ability of operator to behave differently depending on operands it acts on.**

Can `+` operator add any two object? Let’s see.

```Jupyter Notebook
{
 "cells": [
  {
   "cell_type": "code",
   "execution_count": 1,
   "metadata": {},
   "outputs": [],
   "source": [
    "class Vector:\n",
    "\n",
    "    def __init__(self, x, y):\n",
    "        self.x = x\n",
    "        self.y = y"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 2,
   "metadata": {},
   "outputs": [],
   "source": [
    "v1 = Vector(3, 4)\n",
    "v2 = Vector(5, 6)"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 3,
   "metadata": {},
   "outputs": [
    {
     "ename": "TypeError",
     "evalue": "unsupported operand type(s) for +: 'Vector' and 'Vector'",
     "output_type": "error",
     "traceback": [
      "\u001b[1;31m---------------------------------------------------------------------------\u001b[0m",
      "\u001b[1;31mTypeError\u001b[0m                                 Traceback (most recent call last)",
      "\u001b[1;32m<ipython-input-3-08104d7e1232>\u001b[0m in \u001b[0;36m<module>\u001b[1;34m\u001b[0m\n\u001b[1;32m----> 1\u001b[1;33m \u001b[0mv1\u001b[0m \u001b[1;33m+\u001b[0m \u001b[0mv2\u001b[0m\u001b[1;33m\u001b[0m\u001b[1;33m\u001b[0m\u001b[0m\n\u001b[0m",
      "\u001b[1;31mTypeError\u001b[0m: unsupported operand type(s) for +: 'Vector' and 'Vector'"
     ]
    }
   ],
   "source": [
    "v1 + v2"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": []
  }
 ],
 "metadata": {
  "kernelspec": {
   "display_name": "Python 3",
   "language": "python",
   "name": "python3"
  },
  "language_info": {
   "codemirror_mode": {
    "name": "ipython",
    "version": 3
   },
   "file_extension": ".py",
   "mimetype": "text/x-python",
   "name": "python",
   "nbconvert_exporter": "python",
   "pygments_lexer": "ipython3",
   "version": "3.7.6"
  }
 },
 "nbformat": 4,
 "nbformat_minor": 4
}

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

```Jupyter Notebook
{
 "cells": [
  {
   "cell_type": "code",
   "execution_count": 4,
   "metadata": {},
   "outputs": [],
   "source": [
    "class Vector:\n",
    "\n",
    "    def __init__(self, x, y):\n",
    "        self.x = x\n",
    "        self.y = y\n",
    "\n",
    "    def __add__(self, other):\n",
    "        return Vector(self.x + other.x , self.y + other.y)\n",
    "\n",
    "    def __repr__(self):\n",
    "        return f'Vector({self.x}, {self.y})'"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 5,
   "metadata": {},
   "outputs": [],
   "source": [
    "v1 = Vector(3, 4)\n",
    "v2 = Vector(5, 6)"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 6,
   "metadata": {},
   "outputs": [
    {
     "data": {
      "text/plain": [
       "Vector(8, 10)"
      ]
     },
     "execution_count": 6,
     "metadata": {},
     "output_type": "execute_result"
    }
   ],
   "source": [
    "v1 + v2"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": []
  }
 ],
 "metadata": {
  "kernelspec": {
   "display_name": "Python 3",
   "language": "python",
   "name": "python3"
  },
  "language_info": {
   "codemirror_mode": {
    "name": "ipython",
    "version": 3
   },
   "file_extension": ".py",
   "mimetype": "text/x-python",
   "name": "python",
   "nbconvert_exporter": "python",
   "pygments_lexer": "ipython3",
   "version": "3.7.6"
  }
 },
 "nbformat": 4,
 "nbformat_minor": 4
}

```

Now you can see our class support `+` operator , we have also implemented __repr__() method, when we use print(), interpreter invoke __str__() method, if it is not implemented it will call __repr__() method.

> Note: Always return new object when overloading operator unless you are overloading augmented assignment like += operator.

Take one more example of overloading operator

When we use `**==**` operator, Python interpreter invoke __eq__(self, other) special method, in that case by implementing __eq__() method we can support `==` operator.

```Jupyter Notebook
{
 "cells": [
  {
   "cell_type": "code",
   "execution_count": 7,
   "metadata": {},
   "outputs": [],
   "source": [
    "class Vector:\n",
    "\n",
    "    def __init__(self, x, y):\n",
    "        self.x = x\n",
    "        self.y = y\n",
    "\n",
    "    def __add__(self, other):\n",
    "        return Vector(self.x + other.x , self.y + other.y)\n",
    "\n",
    "    def __repr__(self):\n",
    "        return f'Vector({self.x}, {self.y})'\n",
    "    \n",
    "    def __eq__(self, other):\n",
    "        return self.x == other.x and self.y == other.y"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 8,
   "metadata": {},
   "outputs": [],
   "source": [
    "v1 = Vector(3, 4)\n",
    "v2 = Vector(5, 6)"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 9,
   "metadata": {},
   "outputs": [
    {
     "data": {
      "text/plain": [
       "False"
      ]
     },
     "execution_count": 9,
     "metadata": {},
     "output_type": "execute_result"
    }
   ],
   "source": [
    "v1 == v2"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 11,
   "metadata": {},
   "outputs": [
    {
     "data": {
      "text/plain": [
       "True"
      ]
     },
     "execution_count": 11,
     "metadata": {},
     "output_type": "execute_result"
    }
   ],
   "source": [
    "v3 = Vector(3,4)\n",
    "v1 == v3"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "outputs": [],
   "source": []
  }
 ],
 "metadata": {
  "kernelspec": {
   "display_name": "Python 3",
   "language": "python",
   "name": "python3"
  },
  "language_info": {
   "codemirror_mode": {
    "name": "ipython",
    "version": 3
   },
   "file_extension": ".py",
   "mimetype": "text/x-python",
   "name": "python",
   "nbconvert_exporter": "python",
   "pygments_lexer": "ipython3",
   "version": "3.7.6"
  }
 },
 "nbformat": 4,
 "nbformat_minor": 4
}

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
