> * 原文地址：[7 Helpful Time Complexities](https://codeburst.io/7-helpful-time-complexities-4c6c0d6df645)
> * 原文作者：[Ellis Andrews](https://medium.com/@ellisandrews1)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/7-helpful-time-complexities.md](https://github.com/xitu/gold-miner/blob/master/article/2020/7-helpful-time-complexities.md)
> * 译者：[PingHGao](https://github.com/PingHGao)
> * 校对者：

# 7种有用的时间复杂度

![](https://cdn-images-1.medium.com/max/2000/1*6C2DkLB3o2RjBbb0aCvKUQ.jpeg)

作为程序员，我们经常努力编写尽可能高效的代码。但是我们怎么知道我们编写的代码是否高效？答案：大O分析。本文的目的是用尽可能简单的术语来解释这个概念。我将首先介绍 Big O，然后举例说明您可能会遇到的七个最常见的情况。如果您已经熟悉这个概念，但是想要使用真实的 Python 代码进行具体的复习，请随时跳到第二部分！

## Explain it Like I’m 5: The Big O Edition

![](https://cdn-images-1.medium.com/max/2000/1*34pO-qdgbiTPThB7lmV91Q.png)

Put simply, “Big O” notation is how we talk about the efficiency of an algorithm. Specifically, it describes how the running time* of an algorithm changes as the algorithm’s input grows arbitrarily large. While this is a succinct definition, I don’t know a single five-year-old who would understand that statement, so let’s break it down further. Here are a few definitions:

> **1. Algorithm** **—** A set of logical steps that acts on an input to produce an output.

In this article, I will conflate an **algorithm** with something a little more familiar: a **function**. Think about what most functions do that you’ve written. They take one or more arguments as input, perform a specified recipe of operations on those arguments, and then return a value as output. Don’t be scared by the fancy word, you’ve probably already written tons of algorithms! From here on out, when I say “algorithm” you can really think “function”.

> **2. Running Time** **—** The number of operations an algorithm has to perform.

There are many factors that could affect how long an algorithm takes to run in seconds, minutes, hours, etc. on a given computer. So instead of focusing on the actual **time** that an algorithm takes to run, Big O frames the run time in terms of the **number of operations** performed. Fewer operations equal a shorter running time (more efficient), whereas more operations equal a longer running time (less efficient). Thus, we have a standard way of comparing algorithms.

> **3. Input Size —** The amount of data the algorithm is given to process.

In Big O, we’re interested in how algorithms diverge in terms of performance as we give them more and more data to process. For example, you could probably write several fairly similarly optimized functions for finding the maximum value in a list of three random numbers. But what if the list instead contained 100 numbers? Or 1,000? 1,000,000? This is what we mean by the “input size growing arbitrarily large”, and is why Big O is sometimes called “asymptotic analysis”. In Big O, the size of the input is referred to as “**n**”.

In addition to running time, Big O can also be used to describe how much space (memory, disk, etc.) an algorithm uses relative to the input size. In this article, I will focus on time complexity.

#### How to Read and Write Big O

Now that we understand what Big O helps us do, what does it look like? Well, it’s written with a capital “O” followed by a mathematical expression in terms of “n” (the size of the input) in parentheses. Here are the seven examples that you will most frequently encounter, ranked from most efficient to least efficient.

1. **O(1) —** Constant
2. **O(log n) —** Logarithmic
3. **O(n) —** Linear
4. **O(n log n) —** Log-linear
5. **O(nᵏ) —** Polynomial
6. **O(kⁿ) —** Exponential
7. **O(n!) —** Factorial

Below is a graph plotting the number of operations (the running time) against the size of the input for an algorithm with each complexity.

![Source: [https://www.bigocheatsheet.com/](https://www.bigocheatsheet.com/)](https://cdn-images-1.medium.com/max/3412/1*PpKIWUPNwB0a4kJvywCgqA.png)

You can see that, as the size of the input increases, the running time of the algorithms in the red shaded area increases drastically. On the other hand, the performance of the algorithms in the yellow and green shaded areas is much less dependent upon the size of the input and is, therefore, more efficient and scalable.

As a final point of clarification, Big O analysis is usually used to describe the **dominant trend** of an algorithm as the input gets very large. Thus, insignificant terms can be dropped if they are overpowered by more significant terms. For instance, an algorithm with a computed time complexity **O(n² + n)** would simply be referred to as **O(n²)** due to the fact that as **n** grows very large, the effect of the **n²** term greatly outstrips that of the **n** term.

## Examples

Now, let’s look at some common examples of algorithms that fall under each of the aforementioned complexities.

#### 1. O(1) — Constant

The running time of algorithms of this complexity does not increase as the size of the input increases. A common operation of this nature is a value lookup by index in an array or key in a hash table:

```Python
from typing import Any, Dict, List


# Example 1
def list_lookup(list_: List[Any], index: int) -> Any:
    """Lookup a value in a list by index."""
    return list_[index]


# Example 2
def dict_lookup(dict_: Dict[Any, Any], key: Any) -> Any:
    """Lookup a value in a dictionary by key."""
    return dict_[key]

```

No matter how large the list or dictionary passed into these functions is, they will complete at the same time (one operation).

#### 2. O(log n) — Logarithmic

The classic logarithmic algorithm example is a [binary search](https://en.wikipedia.org/wiki/Binary_search_algorithm). This is an algorithm for finding a value in a sorted array by iteratively looking at the middle value, checking if the target value is less than or greater than the middle value, and then eliminating the half of the array in which we are certain that the value does not lie. Here is an implementation:

```Python
from typing import Any, List


def binary_search(list_: List[int], target_value: int) -> int:
    """
    Perform a binary search of a sorted input list for a target value. 
    Return the index of the target value in the list, or -1 if not found.
    """
    # Initialize left and right indexes for start of search
    left = 0
    right = len(list_) - 1

    # Perform binary search
    while left <= right:

        # Calculate the middle index of the remaining list values to be searched
        middle = left + (right - left) // 2

        # Check if target_value is at the middle index. If so, we've found it and we're done.
        if list_[middle] == target_value:
            return middle

        # If target_value is greater than the middle value, ignore the left half of the remaining list values
        elif list_[middle] < target_value:
            left = middle + 1

        # If target_value is less than the middle value, ignore right half of the remaining list values
        else:
            right = middle - 1

    # Return a sentinel value of -1 if the target_value was not found in the whole list
    return -1

```

Given that the size of the array yet to be searched is halved on each iteration, searching an array twice as large would only take one additional iteration! Thus, as the array size increases the runtime increases logarithmically.

#### 3. O(n) — Linear

Algorithms with linear time complexity typically involve iterating over a data structure serially. To borrow from our previous logarithmic search example, a search for a value in an array can also be performed in (less efficient) linear time:

```Python
from typing import Any, List


def linear_search(list_: List[Any], target_value: Any) -> int:
    """
    Perform a linear search of an input list for a target value.
    Return the index of the target value in the list, or -1 if not found.
    """
    # Iterate over each item in the list, checking whether it is the target value
    for index, item in enumerate(list_):
        if item == target_value:
            return index

    # Return a sentinel value if the target_value was not found in the list
    return -1

```

It’s clear that as the size of the input list grows, the worst-case scenario for the number of loop iterations required to find the item is directly proportional to the size increase, as every item in the list needs to be checked.

#### 4. O(n log n) — Log-linear

Log-linear complexity algorithms are a little harder to spot than our previous examples. As their name suggests, they involve both a logarithmic and a linear component. The most common examples of these are sorting algorithms. “Merge sort” is one such algorithm for sorting an array in which the array is iteratively halved, sorted in pieces, and merged back together in sorted order. This is perhaps easier to see through a diagram, so I’ll omit the code implementation for this one.

![Merge sort algorithm. Source: [https://en.wikipedia.org/wiki/Merge_sort](https://en.wikipedia.org/wiki/Merge_sort)](https://cdn-images-1.medium.com/max/2560/1*jgT8yBf2lsaCjdbsIPZJsQ.png)

#### 5. O(nᵏ) — Polynomial

At this point, we’re getting into algorithms with time complexities that do not scale very well and should usually be avoided if possible (referring back to the graph above, we’re in the red zone!). However, many “brute-force” algorithms fall under the polynomial complexity category and can be useful starting points for solving a problem. For example, below is a quadratic (k=2) polynomial algorithm for finding the duplicate items in an array:

```Python
from typing import Any, List, Set


def find_duplicates(list_: List[Any]) -> Set[Any]:
    """Find all duplicate items in a list."""
    
    # Initialize a set to hold the duplicate items
    duplicates = set()

    # Check each item in the list against every other item in the list
    for index_1, item_1 in enumerate(list_):
        for index_2, item_2 in enumerate(list_):
            if index_1 != index_2 and item_1 == item_2:
                duplicates.add(item_1)

    # Return the set of duplicate items
    return duplicates

```

For each item in the array, we check it against every other item in the array. Thus, if the array contains **n** items we perform **n** * **n = n**² operations for a time complexity of **O(n²)**.

Extra credit: Can you think of a better algorithm for solving this problem?

#### 6. O(kⁿ) — Exponential

Our penultimate common time complexity is exponential, in which the running time increases by a constant factor as the size of the input increases. A typical example of this is naively computing the **n**th term in the [Fibonacci sequence](https://en.wikipedia.org/wiki/Fibonacci_number).

```Python
def nth_fibonacci_term(n: int) -> int:
    """Recursively finds the nth term in the Fibonacci sequence. Assumes positive n."""
    # Base case -- The first two numbers of the sequence are {0, 1}
    if n <= 2:
        return n - 1

    return nth_fibonacci_term(n - 1) + nth_fibonacci_term(n - 2)

```

In the example above, the number of operations performed doubles whenever the input **n** increases by 1. This is due to the fact that we do not cache the results of each function call, and must re-calculate all previous values down to the base case each time. Thus, the time complexity of the algorithm is **O(2ⁿ)**.

#### 7. O(n!) — Factorial

Last but not least (but certainly least efficient) are algorithms with factorial time complexity. These should generally be avoided, as they rapidly become unviable as the input scales. One example of such an algorithm is a brute-force solution to [The Traveling Salesman Problem](https://en.wikipedia.org/wiki/Travelling_salesman_problem). This problem seeks to find the shortest possible route that visits all points in a coordinate system and return to the starting point. The brute-force solution involves comparing all possible routes (read: permutations) against each other and selecting the shortest one. Note that this is not usually an acceptable solution to the problem, unless the number of points to visit is very low.

![A Traveling Salesman Solution. Source: [https://en.wikipedia.org/wiki/Travelling_salesman_problem](https://en.wikipedia.org/wiki/Travelling_salesman_problem)](https://cdn-images-1.medium.com/max/2000/1*Vq7Dq63LQrL9xC9Y8XqtGQ.png)

## Final Thoughts

While we’ve covered a lot of cases here, there is more to learn on the topic! I’ve focused on **worst-case time complexity**, but it can also be useful to think in terms of the average or best case as well. I also didn’t touch on space complexity, which can be equally important if memory is limited. The good news is that the syntax and general thought process is the same for that kind analysis. Hopefully the next time you’re in a coding interview or need to write a performant function, you now have the tools to attack it with confidence.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
