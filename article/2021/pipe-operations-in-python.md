> * 原文地址：[Use Pipe Operations in Python for More Readable and Faster Coding](https://towardsdatascience.com/pipe-operations-in-python-1e8f8debe26)
> * 原文作者：[Thuwarakesh Murallie](https://thuwarakesh.medium.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/pipe-operations-in-python.md](https://github.com/xitu/gold-miner/blob/master/article/2021/pipe-operations-in-python.md)
> * 译者：
> * 校对者：

![](https://miro.medium.com/max/1400/1*lHk7fXxqnUjg8C2V2g4FcA.jpeg)

# Use Pipe Operations in Python for More Readable and Faster Coding

> A handy Python package to save a ton of coding time and improve readability with shell-styled pipe operations

Python is already an elegant language to program. But it doesn't mean there is no room for improvement.

Pipe is a beautiful package that takes Python's ability to handle data to the next level. It takes a SQL-like declarative approach to manipulate elements in a collection. It could filter, transform, sort, remove duplicates, perform group by operations, and a lot more without needing to write a gazillion lines of code.

In this little post, let's discuss simplifying our python code with Pipe. Most importantly, we'll construct custom reusable pipe operations to reuse in our project.

Let's begin with

- an inspirational example;
- some helpful out-of-the-box pipe operations, and;
- construct our own pipe operations.

If you're wondering how you'd set it up, you can easily install [Pipe](https://github.com/JulienPalard/Pipe) with PyPI. Here's what you need to do.

```bash
pip install pipe
```

## Start using pipes in Python.

Here's an example of using Pipe. Suppose we have a list of numbers, and we want to,

- remove all the duplicates;
- filter for only the odd numbers;
- square each element in the list, and;
- sort the values in ascending order;

here's what we'd typically do in plain Python.

```python
num_list_with_duplicates = [1, 4, 2, 27,
                            6, 8, 10, 7, 13, 19, 21, 20, 7, 18, 27]

# Remove duplicates from the list
num_list = list(dict.fromkeys(num_list_with_duplicates))

# Filter for odd numbers
odd_list = [num for num in num_list if num % 2 == 1]

# Square the numbers
odd_square = list(map(lambda x: x**2, odd_list))

# Sort values in ascending order
odd_square.sort()

print(odd_square)
```

```
[1, 49, 169, 361, 441, 729]
```

The above code is pretty readable. But here's a better way using Pipe.

```python
from pipe import dedup, where, select, sort

num_list_with_duplicates = [1, 4, 2, 27,
                            6, 8, 10, 7, 13, 19, 21, 20, 7, 18, 27]
# perform pipe oerations
results = list(num_list_with_duplicates 
                | dedup 
                | where(lambda x: x % 2 == 1)
                | select(lambda x: x**2)
                | sort
            )

print(results)
```

```
[1, 49, 169, 361, 441, 729]
```

Both codes produce the same results. Yet the second one is more intuitive than the first one. Obviously, it has fewer lines of code as well.

This is how Pipe helps us simplify our codes. We can chain operations on a collection without writing separate lines of code.

But there are cooler operations available in Pipe like the ones we used in the above example. Also, we can create one if we need something very unique. Let's first explore some pre-built operations.

## Most useful pipe operations

We've already seen a couple of pipes in action. But there's more. In this section, let's discuss some other useful out-of-the-box operations for data wrangling.

These aren't the complete list of operations you could get with Pipe installation. For an extensive inventory, please consult the [Pipe's repository on GitHub.](https://github.com/JulienPalard/Pipe)

### Group By

I trust this is the most helpful pipe available for data scientists. We prefer doing it in Pandas, and I still like using it. But converting a list to a dataset sometimes feels like overkill. I could use this group-by-pipe operation on the go in all those cases.

```python
from pipe import dedup, groupby, where, select, sort

num_list = [1, 4, 2, 27,
            6, 8, 10, 7, 13, 19, 21, 20, 7, 18, 27]

results = list(num_list
               | groupby(lambda x: "Odd" if x % 2 == 1 else "Even")
               )

print(results)
```

The above code groups our datasets into odd and even numbers. It creates a list of two tuples. Each tuple has the name specified in the lambda function and the grouped objects. Thus the above code produces the following groups.

```python
[
    ('Even', <itertools._grouper object at 0x7fdc05ed0310>),
    ('Odd', <itertools._grouper object at 0x7fdc05f88700>),
]
```

We can now perform actions separately for each group we created. Here's an example that takes elements from each group and squares them.

```python
from pipe import dedup, groupby, where, select, sort

num_list = [1, 4, 2, 27,
            6, 8, 10, 7, 13, 19, 21, 20, 7, 18, 27]

results = list(num_list
               | groupby(lambda x: "Odd" if x % 2 == 1 else "Even")
               | select(lambda x: {x[0]: [y**2 for y in x[1]]})
               )

print(results)
```

```
[
    {'Even': [16, 4, 36, 64, 100, 400, 324]}, 
    {'Odd': [1, 729, 49, 169, 361, 441, 49, 729]},
]
```

### Chain and Traverse

These two operations make it easy to unfold a nested list and make it flat. The chain does it step by step, and the traverse recursively until the list is not extended further.

The following is how the chain works.

```python
from pipe import chain

nested_list = [[1, 2, 3], [4, 5, 6], [7, [8, 9]]]

unfolded_list = list(nested_list
                     | chain
                     )

print(unfolded_list)
```

```
[1, 2, 3, 4, 5, 6, 7, [8, 9]]
```

As we can see chain has unfolded the list's outermost level. 8 and 9 remain inside a nested list as they were already nested deep one level down.

Here are the results of using traverse instead.

```python
from pipe import chain

nested_list = [[1, 2, 3], [4, 5, 6], [7, [8, 9]]]

unfolded_list = list(nested_list
                     | chain
                     )

print(unfolded_list)
```

```
[1, 2, 3, 4, 5, 6, 7, 8, 9]
```

Traverse unfolded everything it could.

I mostly use list comprehension to unfold lists. But it gets increasingly difficult to read and understand what's happening in the code. Also, it's difficult to recursively extend, as the traverse operation did in the above example when we don't know how many nested levels are there.

```python
nested_list = [[1, 2, 3], [4, 5, 6], [7, [8, 9]]]

unfolded_list = [num for item in nested_list for num in item]

print(unfolded_list)
```

### Take_while and Skip_while

These two operations work like the 'where' operation we used earlier. The critical difference is that take_while and skip_while stop looking into additional elements in the collection if certain conditions are met. While on the other hand evaluates every element in the list.

Here's how both take_while and where works for a simple task of filtering values less than 5.

```python
rom pipe import as_list, take_while, where

result = [3, 4, 5, 3] | take_while(lambda x: x < 5) | as_list
print(f"take_while: {result}")


result2 = [3, 4, 5, 3] | where(lambda x: x < 5) | as_list
print(f"where: {result2}")
```

The results of the above code would be as follows:

```
take_while: [5, 3]
where: [3, 4, 3]
```

Please note that the take_while operation skipped the final '3' whereas the 'where' process includes it.

Skip_while works much like take_while, except it, only includes elements when certain conditions are met.

```python
take_while: [5, 3]
where: [3, 4, 3]
```

```
[5, 3]
```

As I mentioned earlier, these aren't the complete list of things you can do with the Pipe library. Please check out the repository for more built-in functions and examples.

## Creating a new pipe operation

It's relatively easy to create new pipe operations. All we need is to annotate a function with the Pipe class.

In the below example, we convert a regular Python function into a pipe operation. It takes an integer as input and returns the square value of it.

```python
from pipe import Pipe


@Pipe
def sqr(n: int = 1):
    return n ** 2


result = 10 | sqr
print(result)
```

As we have annotated the function with the `@Pipe` class, it becomes a pipe operation. In line 9, we used it to square a single number.

Pipe operations can take extra arguments as well. The first argument is always the output of its previous operation in the chain. We can have any additional arguments and specify them at the time of using them in the chain.

Extra arguments can even be a function.

In the following example, we create a pipe operation that takes an additional argument. The additional argument is a function. Our pipe operation is to transform every element of the list using the function.

```python
from typing import List
from pipe import Pipe, as_list, select


def fib(n: int = 1):
    """Recursively create fibonacci number"""
    return n if n < 2 else fib(n-1)+fib(n-2)


@Pipe
def apply_fun(nums: List[int], fun):
    """Apply any function to list elements and create a new list"""
    return nums | select(fun) | as_list


result = [5, 10, 15] | apply_fun(fib)


print(result)
```

## Final thoughts

It's impressive to see how Python can be further improved.

As a practicing data scientist, I find Pipe very helpful in many everyday tasks. We could also use Pandas to do most of these tasks. However, Pipe scores excellent on improving code readability. Even novice programmers could understand the transformation.

A note here is that I haven't used Pipe on large-scale projects yet. I'm yet to explore how it would perform on massive datasets and data pipelines. But I do believe this package would play a significant role in offline analytics.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
