> * 原文地址：[The Do’s and Don’ts of Python List Comprehension](https://medium.com/better-programming/the-dos-and-don-ts-of-python-list-comprehension-5cd0f5d18500)
> * 原文作者：[Yong Cui, Ph.D.](https://medium.com/@yong.cui01)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/the-dos-and-don-ts-of-python-list-comprehension.md](https://github.com/xitu/gold-miner/blob/master/article/2020/the-dos-and-don-ts-of-python-list-comprehension.md)
> * 译者：
> * 校对者：

# The Do’s and Don’ts of Python List Comprehension

![Photo by [Michael Herren](https://unsplash.com/@mdherren?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/10944/0*OMREOHfwYkIKRpRF)

List comprehension is a topic that is usually not offered to beginners because its syntax is not very intuitive, even to people who have a coding background in other programming languages.

When we have a chance to get in touch with list comprehension, we learn something here and something there, and thus we do not have a systemic view of how we should use list comprehension in various scenarios.

In this article, I’d like to provide possible use guidelines as comprehensively as possible. I hope that this article can become your one-stop-shopping place for the techniques related to list comprehension.

## Do’s

#### 1. Do use any iterable in list comprehension

The most basic form of list comprehension is to create a list object from an iterable — any Python object that you can iterate its items. The syntax is shown below.

```
[expression for item in iterable]
```

The following code snippet shows you a simple example of creating list objects using the list comprehension technique. In the example, we started with a list of integers and using this iterable, we created a list of tuples of squares and cubes for each of these integers.

```Python
>>> # A list of integers
>>> integers = [1, 2, 3, 4, 5, 6]
>>> # Create a list of squares and cubes
>>> powers = [(x*x, pow(x, 3)) for x in integers]
>>> print(powers)
[(1, 1), (4, 8), (9, 27), (16, 64), (25, 125), (36, 216)]

```

The previous example uses the list object as the iterable. However, we should be aware that many types of objects are iterables. We know that common data types, such as lists, sets, dictionaries, and strings, are all iterables. Other data types, such as `range `****objects, `map `****objects, `filter `****objects, and [pandas](https://pandas.pydata.org/)’ `Series` and `DataFrame` objects are all iterables. The following code shows you some examples of using some of these objects.

```Python
>>> # Use the range object
>>> integer_range = range(5)
>>> [x*x for x in integer_range]
[0, 1, 4, 9, 16]
>>> # Use the Series object
>>> import pandas as pd
>>> pd_series = pd.Series(range(5))
>>> print(pd_series)
0    0
1    1
2    2
3    3
4    4
dtype: int64
>>> [x*x for x in pd_series]
[0, 1, 4, 9, 16]
```

#### 2. Do apply a conditional criterion if only some items are needed

Suppose that you want to create a list of objects from the iterable only when the element meets a particular criterion. The syntax is shown below.

```
[expression for item in iterable if condition]
```

The conditional check is achieved with the `if` statement that follows the iterable. The following code shows you a trivial example of this usage.

```Python
>>> # The same list of integers
>>> integers = [1, 2, 3, 4, 5, 6]
>>> # Create a list of squares for even numbers only
>>> squares_of_evens = [x*x for x in integers if x % 2 == 0]
>>> print((squares_of_evens))
[4, 16, 36]
```

#### 3. Do use a conditional expression

The list comprehension can also work with conditional assignment, which has the following syntax.

```
[expression0 if condition else expression1 for item in iterable]
```

It looks a little bit similar to the previous usage, but don’t get confused with these two. In this usage, the conditional expression is a whole part itself. The following code shows you an example.

```Python
>>> # The list of integers
>>> integers = [1, 2, 3, 4, 5, 6]
>>> # Create a list of numbers, when the item is even, take the square
>>> # when the item is odd, take the cube
>>> custom_powers = [x*x if x % 2 == 0 else pow(x, 3) for x in integers]
>>> print(custom_powers)
[1, 4, 27, 16, 125, 36]
```

#### 4. Do use nested for loops if you have a nested structure for the iterable

Although it’s not too common, it’s likely that the elements in the iterable can be iterables too. If you’re interested in dealing with the elements of the nested iterables, you can use nested `for` loops. It has the following syntax.

```
[expression for item_outer in iterable for item_inner in item_outer]

# Equivalent to
for item_outer in iterable:
    for item_inner in item_outer:
        expression
```

The following code shows you an example of a list comprehension involving nested `for` loops.

```Python
>>> # A list of tuples
>>> prices = [('$5.99', '$4.99'), ('$3.5', '$4.5')]
>>> # Flattened list of prices
>>> prices_formatted = [float(x[1:]) for price_group in prices for x in price_group]
>>> print(prices_formatted)
[5.99, 4.99, 3.5, 4.5]
```

#### 5. Do replace higher order functions

Some people are more used to functional programming. One particular application is to use higher order functions. Specifically, higher order functions are those that use other functions as input or output arguments. Some common higher order functions in Python are `map()` and `filter()`.

```Python
>>> # A list of integers
>>> integers = [1, 2, 3, 4, 5]
>>> # Use map
>>> squares_mapped = list(map(lambda x: x*x, integers))
>>> squares_mapped
[1, 4, 9, 16, 25]
>>> # Use list comprehension
>>> squares_listcomp = [x*x for x in integers]
>>> squares_listcomp
[1, 4, 9, 16, 25]
>>> # Use filter
>>> filtered_filter = list(filter(lambda x: x % 2 == 0, integers))
>>> filtered_filter
[2, 4]
>>> # Use list comprehension
>>> filterd_listcomp = [x for x in integers if x % 2 == 0]
>>> filterd_listcomp
[2, 4]

```

As shown in the above example, list comprehension has much more readable syntax then higher order functions, which have more complicated embedded structures.

## Don’ts

#### 1. Don’t forget about the list() constructor

Some people may think that list comprehension is a cool and Pythonic feature to show off their Python skills, and they tend to use it even when there are better alternatives. One such case is the use of the `list()` constructor. Consider some trivial examples below.

```Python
>>> # Create a list from a range object
>>> numbers = [x for x in range(5)]
>>> print(numbers)
[0, 1, 2, 3, 4]
>>> # Create a list of lower-case characters from a string
>>> letters = [x.lower() for x in 'Smith']
>>> print(letters)
['s', 'm', 'i', 't', 'h']
```

In the above example, we use a range and string, respectively, as the iterables. However, both types of objects are iterables, and the `list()` constructor can take iterables directly to create a new list object. Better and cleaner solutions are shown below.

```Python
>>> # Create a list from a range object
>>> numbers = list(range(5))
>>> print(numbers)
[0, 1, 2, 3, 4]
>>> # Create a list of lower-case characters from a string
>>> letters = list('Smith'.lower())
>>> print(letters)
['s', 'm', 'i', 't', 'h']

```

#### 2. Don’t forget about generator expression

In Python, generators are a special kind of iterators, which render an element lazily until they’re asked to do so. As a result, it’s a very memory-efficient way to deal with a large amount of data. By contrast, a list object needs to have all its elements created upfront such that its elements can be counted and indexed. Compared to generators, lists involving the same number of elements require more memory for storage.

To create a generator, we can define a generator function. However, we can also use the following syntax to create a generator — a technique termed **generator expression**.

```
(expression for item in iterable)
```

As you may have noticed, the syntax is very similar to list comprehension, except for the use of parentheses as opposed to square brackets. So it’s also important to differentiate generator expression from list comprehension.

Consider the following trivial example. We need to calculate the sum of squares for the first million whole numbers. If we use a list comprehension, here’s our solution.

```Python
>>> # Create the squares
>>> squares = [x*x for x in range(10_000_000)]
>>> # Calculate their sum
>>> sum(squares)
333333283333335000000
>>> squares.__sizeof__()
81528032
```

As shown above, the list object occupies 81528032 bytes. Let’s consider the same operations with a generator, as shown below.

```Python
>>> # Create the squares generator
>>> squares_gen = (x*x for x in range(10_000_000))
>>> # Calculate their sum
>>> sum(squares_gen)
333333283333335000000
>>> squares_gen.__sizeof__()
96
```

Compared to the solution using the list comprehension, the solution using a generator expression involves a much smaller object, which is only 96 bytes. The reason is simple — generators don’t need to capture all their elements. Instead, they just need to know where they are in the sequence and simply create the next applicable element and render it without the need of keeping the elements in the memory.

## Conclusions

In this article, we reviewed several key guidelines for using list comprehension. As you have seen, these do’s and don’ts are pretty straightforward. I guess that you should be able to use list comprehension in the desired scenarios. Here’s a quick recap.

* **Do use any iterable in list comprehension.** Many types of iterables exist in Python and you should go beyond the basic ones, such as lists and tuples.
* **Do apply a filtering condition in list comprehension** if you’re interested in keeping some of the elements in the iterable.
* **Do use a conditional expression** if you want an alternative way to assign the value to the resulting element.
* **Do use a nested `for` loop** if you’re dealing with nested iterables.
* **Do use list comprehension to replace the use of higher order functions** in many use cases.
* **Don’t forget about the list constructor**, which takes an iterable for the creation of a new list object. It’s the recommended way, compared to list comprehension, if you’re working with an iterable directly.
* **Don’t forget about generator expression**, which is syntactically similar to list comprehension. It’s a memory-efficient way to deal with a large sequence of objects. Unlike generators, lists have to be created upfront for later indexing and accessing, which consumes a considerable amount of memory if the list has many elements.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
