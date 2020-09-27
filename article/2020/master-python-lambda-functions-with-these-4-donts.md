> * 原文地址：[Master Python Lambda Functions With These 4 Don’ts](https://medium.com/better-programming/master-python-lambda-functions-with-these-4-donts-655b212d36d7)
> * 原文作者：[Yong Cui, Ph.D.](https://medium.com/@yong.cui01)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/master-python-lambda-functions-with-these-4-donts.md](https://github.com/xitu/gold-miner/blob/master/article/2020/master-python-lambda-functions-with-these-4-donts.md)
> * 译者：
> * 校对者：

# Master Python Lambda Functions With These 4 Don’ts

#### Use lambdas, but don’t misuse them

![Photo by [Khachik Simonian](https://unsplash.com/@khachiksimonian?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral).](https://cdn-images-1.medium.com/max/10944/0*9slRkVkDa86YSSIk)

Lambda functions are anonymous functions in Python. Using them is a handy technique in a local environment when you need to perform a small job. Some people simply refer to them as lambdas, and they have the following syntax:

```
lambda arguments: expression
```

The creation of a lambda function is signaled by the `lambda` keyword, followed by the list of arguments and a single expression separated by a colon. For instance, `lambda x: 2 * x` simply multiplies any input number by two, while `lambda x, y: x+y` simply calculates the sum of two numbers. The syntax is pretty straightforward, right?

With the assumption that you know what a lambda function is, this article is intended to provide some general guidelines on how to use lambda functions properly.

---

## 1. Don’t Return Any Value

Looking at the syntax, you may notice that we don’t return anything for the lambda function. It’s all because lambda functions can only contain a single expression. However, the use of the `return` keyword will constitute a statement that is incompatible with the required syntax, as shown below:

```Python
>>> integers = [(3, -3), (2, 3), (5, 1), (-4, 4)]
>>> sorted(integers, key=lambda x: x[-1])
[(3, -3), (5, 1), (2, 3), (-4, 4)]
>>> sorted(integers, key=lambda x: return x[-1])
... 
  File "<input>", line 1
    sorted(integers, key=lambda x: return x[-1])
                                   ^
SyntaxError: invalid syntax
```

This mistake probably arises due to the inability to differentiate expressions from statements. Statements like those involving `return`, `try`, `with`, and `if` perform particular actions. However, expressions are those that can be evaluated to a single value, such as a number or other Python objects.

With lambda functions, the single expression will evaluate a single value that is used subsequently, such as being sorted by the `sorted` function.

---

## 2. Don’t Forget About Better Alternatives

One of the most common use cases is to set a lambda function to the `key` argument of some built-in utility functions, such as `sorted()` and `max()`, as shown above. Depending on the situation, we can use other alternatives. Consider the following examples:

```Python
>>> integers = [-4, 3, 7, -5, -2, 6]
>>> sorted(integers, key=lambda x: abs(x))
[-2, 3, -4, -5, 6, 7]
>>> sorted(integers, key=abs)
[-2, 3, -4, -5, 6, 7]
>>> scores = [(93, 100), (92, 99), (95, 94)]
>>> max(scores, key=lambda x: x[0] + x[1])
(93, 100)
>>> max(scores, key=sum)
(93, 100)
```

In data science, many people use the [pandas](https://pandas.pydata.org/) library to process data. We can use the lambda function to create new data from existing data using the `map()` function, as shown below. Instead of using a lambda function, we can simply use the arithmetic function directly because it’s supported in pandas:

```Python
>>> import pandas as pd
>>> data = pd.Series([1, 2, 3, 4])
>>> data.map(lambda x: x + 5)
0    6
1    7
2    8
3    9
dtype: int64
>>> data + 5
0    6
1    7
2    8
3    9
dtype: int64

```

---

## 3. Don’t Assign It to a Variable

I’ve seen some people mistakenly think that a lambda function is an alternative way to declare a simple function, and you may have seen people do the following:

```Python
>>> doubler = lambda x: 2 * x
>>> doubler(5)
10
>>> doubler(7)
14
>>> type(doubler)
<class 'function'>
```

The only use of naming a lambda function is probably for teaching purposes to show that a lambda function is indeed a function just like other functions — to be called and having a type of function. Other than that, we shouldn’t assign a lambda function to a variable.

The problem with naming a lambda function is that it makes debugging less straightforward. Unlike other functions that are created using the regular `def` keyword, lambda functions don’t have names, which is why they’re sometimes referred to as anonymous functions. Consider the following trivial example to see this nuance:

```Python
>>> inversive0 = lambda x: 1 / x
>>> inversive0(2)
0.5
>>> inversive0(0)
Traceback (most recent call last):
  File "<input>", line 1, in <module>
  File "<input>", line 1, in <lambda>
ZeroDivisionError: division by zero
>>> def inversive1(x):
... 	return 1 / x
... 
>>> inversive1(2)
0.5
>>> inversive1(0)
Traceback (most recent call last):
  File "<input>", line 1, in <module>
  File "<input>", line 2, in inversive1
ZeroDivisionError: division by zero
```

* When your code has problems with a lambda function (i.e. `inversive0`), the `Traceback` error information can only tell you that a lambda function has bugs.
* By contrast, with a regularly defined function, the `Traceback` will clearly inform you of the problematic function (i.e. `inversive1`).

Related to this, if you have the temptation to use a lambda function more than once, the best practice is to use a regular function using the `def` keyword, which will also allow you to have docstrings.

---

## 4. Don’t Forget About List Comprehension

Some people like to use lambda functions with higher-order functions, such as `map` or `filter`. Consider the following example for this usage:

```Python
>>> # Create a list of numbers
>>> numbers = [2, 1, 3, -3]
>>> # Use the map function with a lambda function
>>> list(map(lambda x: x * x, numbers))
[4, 1, 9, 9]
>>> # Use the filter function with a lambda function
>>> list(filter(lambda x: x % 2, numbers))
[1, 3, -3]
```

Instead of using the lambda function, we can use list comprehension, which has better readability. As shown below, we use list comprehension to create the same list objects. As you can see, the previous usage of `map` and `filter` functions with lambda functions is more cumbersome compared to list comprehension. So you should consider using list comprehension when you’re creating lists involving higher-order functions.

```Python
>>> # Use list comprehensions
>>> [x * x for x in numbers]
[4, 1, 9, 9]
>>> [x for x in numbers if x % 2]
[1, 3, -3]
```

---

## Conclusion

In this article, we reviewed four common mistakes that someone may make with lambda functions. By avoiding these mistakes, you should be able to use lambda functions properly in your code.

The rule of thumb for using lambda functions is to keep it simple and use them just once locally.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
