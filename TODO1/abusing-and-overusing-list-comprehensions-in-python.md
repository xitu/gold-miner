> * 原文地址：[Overusing list comprehensions and generator expressions in Python](https://treyhunner.com/2019/03/abusing-and-overusing-list-comprehensions-in-python/)
> * 原文作者：[Trey Hunner](https://treyhunner.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/abusing-and-overusing-list-comprehensions-in-python.md](https://github.com/xitu/gold-miner/blob/master/TODO1/abusing-and-overusing-list-comprehensions-in-python.md)
> * 译者：[ccJia](https://github.com/ccJia)
> * 校对者：[江五渣](http://jalan.space)，[TrWestdoor](https://github.com/TrWestdoor)

# 列表推导式与表达式生成器在 Python 中的滥用

列表推导式是我喜欢的 Python 特性之一。我非常喜爱列表推导式，为此我写过一篇关于它们的[文章](https://treyhunner.com/2015/12/python-list-comprehensions-now-in-color/ "List Comprehensions: Explain Visually")，做过一次针对它们的[演讲](https://youtu.be/5_cJIcgM7rw "Comprehensible Comprehensions")，还在 PyCon 2018 上办过一个[三小时推导式教程](https://youtu.be/_6U1XoxyyBY "Using List Comprehensions and Generator Expressions For Data Processing")。

我喜爱推导式，但是我发现一旦一个新的 Python 使用者开始真正使用推导式，他们会在所有可能的地方用这些推导式。**推导式很可爱，但也很容易被滥用**。

这篇文章展示的案例中，从可读性的角度来看，推导式都不是完成任务的最佳工具。我们会讨论一些案例，它们有比使用推导式更具有可读性的选择，我们还会看到一些不明显的案例，它们根本就不需要使用推导式。

如果你还不是推导式的爱好者，那么这篇文章并不是为了吓退你，而是为了鼓励那些需要它的人（包括我）适度地使用它。

**注意**：本文中涉及到的“推导式”是涵盖了所有形式的推导式（列表，集合，字典）以及生成表达式。如果你对推导式还不是特别熟悉，我建议你先阅读这篇[文章](https://treyhunner.com/2015/12/python-list-comprehensions-now-in-color/ "List Comprehensions: Explain Visually") 或者这个[演讲](https://youtu.be/5_cJIcgM7rw "Comprehensible Comprehensions")（这个演讲对生成器表达式挖掘的比较深）。

## 编写拥挤的推导式

列表推导式的批评者总是抱怨它们的可读性太差。他们是对的，很多推导式**都**很难读。**一些时候，让这些推导式变的更易读的方法仅仅是多一点间隔**。

观察一下这个函数中的推导式：

```python
def get_factors(dividend):
    """返回所给数值的所有因子作为一个列表。"""
    return [n for n in range(1, dividend+1) if dividend % n == 0]
```

我们可以通过添加一些合适的换行来让这个推导式更易读：

```python
def get_factors(dividend):
    """返回所给数值的所有因子作为一个列表。"""
    return [
        n
        for n in range(1, dividend+1)
        if dividend % n == 0
    ]
```

代码越少意味着越好的可读性，但并不总是这样。**空白符是你的好朋友，尤其是在你使用推导式的时候**。

通常来说，我跟倾向于使用上面的缩进格式来写我的推导式并**利用多行来隔离代码**。有时我也用单行来写解析式，但是我不默认使用单行。

## 编写的推导式太丑

一些循环是**可以**被写成推导式的形式，但是如果循环里面有太多逻辑，那他们可能**不应该**被这样改写。

观察一下这个推导式：

```python
fizzbuzz = [
    f'fizzbuzz {n}' if n % 3 == 0 and n % 5 == 0
    else f'fizz {n}' if n % 3 == 0
    else f'buzz {n}' if n % 5 == 0
    else n
    for n in range(100)
]
```

这个推导式等价于这样的 `for` 循环：

```python
fizzbuzz = []
for n in range(100):
    fizzbuzz.append(
        f'fizzbuzz {n}' if n % 3 == 0 and n % 5 == 0
        else f'fizz {n}' if n % 3 == 0
        else f'buzz {n}' if n % 5 == 0
        else n
    )
```

推导式和 `for` 循环都使用了三层嵌套的 [内联 if 语句](https://docs.python.org/3/faq/programming.html#is-there-an-equivalent-of-c-s-ternary-operator) （Python 的[三元操作符](https://en.wikipedia.org/wiki/%3F:)）

这里有一个更易读的方式，使用 `if-elif-else` 结构：

```python
fizzbuzz = []
for n in range(100):
    if n % 3 == 0 and n % 5 == 0:
        fizzbuzz.append(f'fizzbuzz {n}')
    elif n % 3 == 0:
        fizzbuzz.append(f'fizz {n}')
    elif n % 5 == 0:
        fizzbuzz.append(f'buzz {n}')
    else:
        fizzbuzz.append(n)
```

即使这里**有**一种用推导式书写代码的方法，**但是这并不意味着你**必须**要这么做**。

在推导式里有很多复杂逻辑时，即使是单个的 [内联 if](https://docs.python.org/3/faq/programming.html#is-there-an-equivalent-of-c-s-ternary-operator) 也需要谨慎。

```python
number_things = [
    n // 2 if n % 2 == 0 else n * 3
    for n in numbers
]
```

如果你倾向于在此类案例中使用推导式，那你至少需要考虑**是否可以使用空白符或者括号可以提高可读性**：

```python
number_things = [
    (n // 2 if n % 2 == 0 else n * 3)
    for n in numbers
]
```

并且，考虑一下提取你的逻辑操作到一个独立的函数是否也可以改进你的可读性（这个略傻的例子没有体现）。

```python
number_things = [
    even_odd_number_switch(n)
    for n in numbers
]
```

一个独立的函数是否可以提高可读性，取决于这个操作的重要程度、规模，以及函数名能否传达操作的含义。

## 伪装成推导式的循环

有时你会遇到使用了推导式语法却破坏了推导式初衷的代码。

比如，这个代码好像是一个推导式：

```python
[print(n) for n in range(1, 11)]
```

但是它不像推导式一样**运行**。我们使用推导式达到的目的并不是它的本意。

如果我们在 Python 中执行这个推导式，你就会明白我的意思：

```python
>>> [print(n) for n in range(1, 11)]

[None, None, None, None, None, None, None, None, None, None]
```

我们是想打印 1 到 10 之间的所有数，同时我们也是这么做的。但是这个推导式的语句返回了一个全是 `None` 值的列表给我们，对我们毫无意义。

**你给推导式什么内容，它就会建立什么样的列表**。我们从 `print` 函数那里获得值去建立列表，而 `print` 函数的返回值就是 `None`。

但我们并不在意推导式建立的列表，我们只关心它的副作用。

我们可以用下面的代码替代之前的代码：

```python
for n in range(1, 11):
    print(n)
```

列表推导式会**循环一个迭代器并且建立一个新的列表**,`for` 循环是用来**遍历一个迭代器同时完成你想做的任何操作**。

当我在代码中看到推导式时，**我立即会假设我们创建了一个新的列表**（因为这个就是它的作用）。如果你用一个推导式完成**创建列表之外的目的**，它会给其他读你代码的人带来困扰。

如果你不是为了创建一个新的列表，那就不要使用推导式。

## 当存在更特定工具时，使用推导式

在很多问题中，更特定的工具比通用目的的 `for` 循环更有意义。**但推导式并不总是最适合手头工作的专用工具。**

我见过并且写过一堆像这样的代码：

```python
import csv

with open('populations.csv') as csv_file:
    lines = [
        row
        for row in csv.reader(csv_file)
    ]
```

这种推导式会对**唯一性**的值进行排序。它的目的就是循环我们提供的迭代器（ `csv.reader(csv_file)` ）并且创建一个列表。

但是，在 Python 中，我们为这个任务提供了一个更特定的工具：`list`  的构造函数。Python 的 `list` 构造函数可以为我们完成循环并创建列表的工作。

```python
import csv

with open('populations.csv') as csv_file:
    lines = list(csv.reader(csv_file))
```

推导式是一种特殊用途的工具，用于在迭代器上循环，以便在修改每个元素的同时创建一个新列表，并/或过滤掉一些元素。`list` 构造函数是一个特定目的工具，用来遍历推导式并创建列表，同时不会改变任何的东西。

如果在建立列表时你不需要过滤元素或将它们映射到新元素中，**你不需要使用推导式，你只需要使用  `list` 构造函数**。

这个推导式转换了从 `zip` 中得到的 `row` 元组并放入列表：

```python
def transpose(matrix):
    """返回给定列表的转置版本。"""
    return [
        [n for n in row]
        for row in zip(*matrix)
    ]
```

我们同样也可以使用 `list` 构造函数:

```python
def transpose(matrix):
    """返回给定列表的转置版本。"""
    return [
        list(row)
        for row in zip(*matrix)
    ]
```

每当你看到如下的推导式时：

```python
my_list = [x for x in some_iterable]
```

你可以用这种写法替代：

```python
my_list = list(some_iterable)
```

这同样适用于 `dict` 和 `set` 的推导式。

这个是我过去经常会写的东西：

```python
states = [
    ('AL', 'Alabama'),
    ('AK', 'Alaska'),
    ('AZ', 'Arizona'),
    ('AR', 'Arkansas'),
    ('CA', 'California'),
    # ...
]

abbreviations_to_names = {
    abbreviation: name
    for abbreviation, name in states
}
```

我们遍历一个有两项元组构成的列表，并以此生成一个字典。

这个任务实际上已经被 `dict`的构造函数完成了：

```python
abbreviations_to_names = dict(states)
```

`list` 和 `dict` 的构造函数不是唯一的推导式替代工具。标准库和第三方库中包含了很多工具，在有的时候，他们比推导式更适合于你的循环要求。

下面这个是一个生成器表达式，目的是对嵌套迭代器求和：

```python
def sum_all(number_lists):
    """返回二维列表中所有元素的和。"""
    return sum(
        n
        for numbers in number_lists
        for n in numbers
    )
```

使用 `itertools.chain` 可以达到同样的目的:

```python
from itertools import chain

def sum_all(number_lists):
    """返回二维列表中所有元素的和。"""
    return sum(chain.from_iterable(number_lists))
```

什么时候使用推导式什么时候使用替代品，这个的界定没有那么清晰。

我也经常纠结使用 `itertools.chain`  还是推导式。我通常会把两种都写出来然后使用更清晰的那个。

可读性在编程结构中总是针对于特定问题的，这个在推导式上也适用。

## 无效的工作

有时候你会发现，推导式不应该被另一个构造函数所替代，而应该被**完全删除**，只留下需要遍历的迭代器。

这段代码打开了一个单词构成的文件（每行一个单词），存储这个文件，同时计数每个单词出现的次数：

```python
from collections import Counter

word_counts = Counter(
    word
    for word in open('word_list.txt').read().splitlines()
)
```

我们使用了一个生成器表达式，但我们并不需要如此。可以直接这样写：

```python
from collections import Counter

word_counts = Counter(open('word_list.txt').read().splitlines())
```

我们在传给 `Counter` 类之前遍历了整个列表并转换为一个生成器。完全是无用功。`Counter` 类是接受**任何迭代器，不论它是列表，生成器，元组或者是其它结构**。

这是另外一个无效的推导式：

```python
with open('word_list.txt') as words_file:
    lines = [line for line in words_file]
    for line in lines:
        if 'z' in line:
            print('z word', line, end='')
```

我们遍历了 `words_file`，转化为列表 `lines`，再去遍历 `lines` 一次。整个对于列表的转换是不必要的。

我们可以直接遍历 `words_file`：

```python
with open('word_list.txt') as words_file:
    for line in words_file:
        if 'z' in line:
            print('z word', line, end='')
```

没有任何理由将我们只需要遍历一次的迭代器转换为列表。

在 Python 中，我们更关注**它是不是一个迭代器**而不是**它是不是一个列表**。

在不需要的时候，不要去创建一个新的迭代器。**如果你只是为了遍历这个迭代器一次，你可以直接使用它**。

## 什么时候应该使用推导式？

那么，什么时候确实应该使用推导式呢？

一个简单但是不准确的回答是，当你需要写如下文[复制-粘贴推导式格式](https://treyhunner.com/2015/12/python-list-comprehensions-now-in-color/ "List Comprehensions: Explain Visually")中所提到的代码，同时你没有其他的工具可以让你的代码更精简，你就应该考虑使用列表推导式了。

```python
new_things = []
for ITEM in old_things:
    if condition_based_on(ITEM):
        new_things.append(some_operation_on(ITEM))
```

循环可以用这样的推导式重写：

```python
new_things = [
    some_operation_on(ITEM)
    for ITEM in old_things
    if condition_based_on(ITEM)
]
```

更复杂的回答是，当推导式有意义时，你就应该考虑它。这实际上不算是一个回答，但确实没人回答“什么时候该使用推导式”这个问题。

这里有一个 `for` 循环看起来的确不像是可以用推导式重写：

```python
def is_prime(candidate):
    for n in range(2, candidate):
        if candidate % n == 0:
            return False
    return True
```

但实际上，如果我们知道怎么使用 `all` 函数，我们可以用生成器表达式来重写它：

```python
def is_prime(candidate):
    return all(
        candidate % n != 0
        for n in range(2, candidate)
    )
```

我写过一篇文章叫 [ `any` 和 `all` 函数](https://treyhunner.com/2016/11/check-whether-all-items-match-a-condition-in-python/)的文章来描述这对操作和生成器表达式是多么搭配。但是 any 和 all 并不是唯一与生成器表达式有关联的。

还有一个相似场景的代码：

```python
def sum_of_squares(numbers):
    total = 0
    for n in numbers:
        total += n**2
    return total
```

这里没有 `append` 同时也没有迭代器被建立。但是，如果我们创建一个平方的生成器，我们可以使用内置的 `sum` 函数去得到一样的结果。

```python
def sum_of_squares(numbers):
    return sum(n**2 for n in numbers)
```

所以，除了要考虑检查“我是否可以从一个循环复制-粘贴到推导式”之外，我们还需要考虑：我们是否可以通过结合生成器表达式与接受迭代器的函数或者类来增强我们的代码？

那些可以**接受迭代器作为参数**的函数或者类，**可能是与生成器表达式组合的**优秀组件。

## 深思熟虑后使用列表推导式

列表推导式可以使你的代码更可读（如果你不相信我，可以看我的演讲[可理解的推导式](https://youtu.be/5_cJIcgM7rw "Comprehensible Comprehensions")中的例子），但是它确实被滥用。

列表推导式是被用来解决特定问题的专用工具。`list` 和 `dict` 的构造函数是被用来解决更具体问题的更专用的工具。

循环是**更通用的工具**，适用于当你遇到的问题不适合推导式或其它专用循环工具领域的场景。

像 `any`、`all` 和 `sum` 这样的函数，以及像 `Counter` 和 `chain` 这样的类都是接受迭代器的工具，它们**与推导式**非常匹配，有时**完全取代了推导式**。

请记住，推导式只有一个目的:**从旧的迭代器中创建一个新的迭代器**，同时在此过程中稍微调整值和/或过滤不匹配条件的值。推导式是一个可爱的工具，但是**它们不是你唯一的工具**。当你的推导式不能胜任时，不要忘记 `list` 和 `dict` 构造函数，以及 `for` 循环。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。

