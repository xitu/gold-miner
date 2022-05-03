> * 原文地址：[10 Hardest Python Questions](https://medium.com/@saint_sdmn/10-hardest-python-questions-98986c8cd309)
> * 原文作者：[Alexander Svito](https://medium.com/@saint_sdmn)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2022/10-hardest-python-questions.md](https://github.com/xitu/gold-miner/blob/master/article/2022/10-hardest-python-questions.md)
> * 译者：
> * 校对者：

![Photo by [Emile Perron](https://unsplash.com/@emilep) from [Unplash](https://unsplash.com/photos/xrVDYZRGdw4)](https://cdn-images-1.medium.com/max/11014/1*ieXaavHBhInXJiKyK4RTEA.jpeg)

# 10 Hardest Python Questions

Regardless of whether you are preparing for an interview or playing with code snippets, sometimes even languages as transparent and well-structured as Python can create a real challenge.

Despite widespread knowledge of [Zen of Python](https://peps.python.org/pep-0020/), some of the unique cases, such as [iterable unpacking assignment](https://stackoverflow.com/questions/68152730/understand-python-swapping-why-is-a-b-b-a-not-always-equivalent-to-b-a-a) or [difference between ‘+=’ and ‘+’ operators](https://stackoverflow.com/questions/2347265/why-does-behave-unexpectedly-on-lists/2347423#2347423), seem to be counter-intuitive and confusing even for experienced engineers. Here, I compiled 10 best examples of how Python interpreter’s behavior can make you question the logic of the language structure.

**All of the snippets below were tested on python 3.8.10 version.**

## 1. type == object

What is the result of the execution of the following code:

```python
>>> isinstance(type, object)
>>> isinstance(object, type)
>>> isinstance(object, object)
>>> isinstance(type, type)
```

**Correct answer: True, True, True, True**

Everything is an object in Python, thus any instance check for an object will return **True**: isinstance(Anything, object) #=> True.

Python `type` represents a **metaclass** for constructing all Python types. Therefore all types: `int`, `str`, `object` are instances of a `type` class, which is, as everything in python, an object.

`type` is the only object in Python, that is an instance of itself.

```python
>>> type(5)
<class 'int'>
>>> type(int)
<class 'type'>
>>> type(type)
<class 'type'>
```

## 2. Empty booleans

What is the result of the execution of the following code:

```python
>>> any([])
>>> all([])
```

**Answer: False, True**

From the definition of `any` built-in functions we know, that it will:

> Return `True` if any element of the **iterable** is true.

Logical operators in Python are lazy, the algorithm is to look for a first occurrence of a **true** element and, if none were found, return **False**, Since the sequence is empty, there are no elements that can be **true**, therefore `any([])`returns **False**.

`all` example is a little bit more complicated, since it represents the concept of [vacuous truth](https://en.wikipedia.org/wiki/Vacuous_truth). Like with chained lazy logical operators, the algorithm is to look for the first **false** element, and if none were found, return **True**. Since there are no **false** elements in an empty sequence, `all([])` returns **True**.

## 3. Roundabout

What is the result of the execution of the following code:

```python
>>> round(7 / 2)
>>> round(3 / 2)
>>> round(5 / 2)
```

**Answer: 4, 2, 2**

Why does `round(5 / 2)` return 2 instead of 3? The issue here is that Python’s `round` method implements [banker’s rounding](https://en.wikipedia.org/wiki/Rounding#Round_half_to_even), where all half values will be rounded to the closest even number.

## 4. Instance first!

What this code will print into console?

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

**Answer: 16 (21 - 5)**

In order to resolve an attribute name, Python will firstly search for it on an instance level, then on class level, then in parent classes. This hold true for everything but **__dunder__** methodd. While searching for them, Python will skip an instance check and search directly in a class instead.

## 5. Add it all together

What is the result of the execution of the following code:

```python
>>> sum("")
>>> sum("", [])
>>> sum("", {})
```

**Answer: 0, [], {}**

In order to understand what is happening here we need to inspect the signature of the `sum` function:

> `**sum**`(**iterable**, **/**, **start=0**)
>
> Sums **start** and the items of an **iterable** from left to right and returns the total. The **iterable**’s items are normally numbers, and the start value is not allowed to be a string.

In all the cases above “” (empty string) is treated as an empty sequence, therefore `sum` will simply return the `start` argument as a total result. In the first case it defaults to zero, for the second and the third case it implies that empty list and dictionary are passed in as a `start` argument.

## 6. Unexpected attribute

What is the result of the execution of the following code:

```python
>>> sum([
    el.imag 
    for el in [
        0, 5, 10e9, float('inf'), float('nan')
    ]
])
```

**Answer: 0.0**

This snippet won’t cause `AttributeError`. All numerical types in Python (`int`, `real`, `float`) are inherited from a base `object` class. Despite this, all of them support `real` and `imag` attributes, returning real and imaginary parts respectively. That includes **Infinity** and **NaN** as well.

## 7. Lazy Python

What is the result of the execution of the following code:

```python
class A:
    def function(self):
        return A()

a = A()
A = int
print(a.function())
```

**Answer: 0**

Code inside python functions will be executed only upon invocation, meaning that all `NameErrors` will be raised and variables will be bonded only when you actually call the method. In the example above, during method definition Python allows to reference the class that is not defined yet. However, during the execution Python will bind the name `A` from the outer scope, which means that `function` method will return a newly created `int` instance.

## 8. I want -1 times more

What is the result of the execution of the following code:

```
>>> "this is a very long string" * (-1)
```

**Answer: ‘’ (empty string)**

From the [python docs](https://docs.python.org/3/library/stdtypes.html):

> Values of **n** less than `0` are treated as `0` (which yields an empty sequence of the same type as **s**)

This holds true for any sequence types.

## 9. Breaking the rules of math

What is the result of the execution of the following code:

```python
>>> max(-0.0, 0.0)
```

**Answer: -0.0**

Why is that happens? This occurs because of the two reasons.

1. [Negative zero](https://en.wikipedia.org/wiki/Signed_zero) and zero are treated as equal in Python.
2. Max function description from python docs states:

> If multiple items are maximal, the function returns the first one encountered.

Therefore `max` function returns the first occurrence of zero, which just happens to be the negative one. Case solved.

## 10. Breaking the rules of math (again)

What is the result of the execution of the following code:

```python
>>> x = (1 << 53) + 1
>>> x + 1.0 > x
```

**Answer: False**

There are three things to blame for that counter-intuitive behavior: [long arithmetic](https://en.wikipedia.org/wiki/Arbitrary-precision_arithmetic), float precision limits and numeric comparisons. Python can support very large integers, switching a computation mode if the limit was exceeded implicitly (Or explicitly with a `long` type in Python 2.*), but the float precision in Python is limited. The number is question:

2⁵³ + 1 = 9007199254740993

Is the smallest integer that cannot be fully represented as a Python float. Therefore, in order to perform `x + 1.0` Python casts `x`to `float`, rounding it to `9007199254740992.0` which Python can represent, then adds `1.0` to it, but because of the same representation limits it sets it back to `9007199254740992.0`.

Another issue here is the comparison rules. Unlike other languages, Python and Ruby do not throw an error for `float` vs `int` comparison and neither they try to cast both operands to the same type. Instead they compare actual numerical values. And because `9007199254740992.0` is lover than `9007199254740993` Python returns **False**.

## Conclusion

Despite all of this, Python still holds his title of the clear and transparent programming language. While working on this article I’ve encountered many examples of such counter-intuitive code snippets that were fixed in newer versions of Python or were given an explanation by community. The examples above represent edge cases of Python usage, and chances that you would’ve encountered them in a real commercial project are relatively slim.

However, examining and understanding such “pitfalls” can help you better understand the internal language structure and avoid use cases and dodgy practices that may lead you to unexpected bugs and errors.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
