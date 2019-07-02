> * 原文地址：[Overusing list comprehensions and generator expressions in Python](https://treyhunner.com/2019/03/abusing-and-overusing-list-comprehensions-in-python/)
> * 原文作者：[Trey Hunner](https://treyhunner.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/abusing-and-overusing-list-comprehensions-in-python.md](https://github.com/xitu/gold-miner/blob/master/TODO1/abusing-and-overusing-list-comprehensions-in-python.md)
> * 译者：
> * 校对者：

# Overusing list comprehensions and generator expressions in Python

List comprehensions are one of my favorite features in Python. I love list comprehensions so much that I’ve written an [article](https://treyhunner.com/2015/12/python-list-comprehensions-now-in-color/ "List Comprehensions: Explain Visually") about them, done [a talk](https://youtu.be/5_cJIcgM7rw "Comprehensible Comprehensions") about them, and held a [3 hour comprehensions tutorial](https://youtu.be/_6U1XoxyyBY "Using List Comprehensions and Generator Expressions For Data Processing") at PyCon 2018.

While I love list comprehensions, I’ve found that once new Pythonistas start to really appreciate comprehensions they tend to use them everywhere. **Comprehensions are lovely, but they can easily be overused**!

This article is all about cases when comprehensions aren’t the best tool for the job, at least in terms of readability. We’re going to walk through a number of cases where there’s a more readable alternative to comprehensions and we’ll also see some not-so-obvious cases where comprehensions aren’t needed at all.

This article isn’t meant to scare you off from comprehensions if you’re not already a fan; it’s meant to encourage moderation for those of us (myself included) who need it.

**Note**: In this article, I’ll be using the term “comprehension” to refer to all forms of comprehensions (list, set, dict) as well as generator expressions. If you’re unfamiliar with comprehensions, I recommend reading [this article](https://treyhunner.com/2015/12/python-list-comprehensions-now-in-color/ "List Comprehensions: Explain Visually") or watching [this talk](https://youtu.be/5_cJIcgM7rw "Comprehensible Comprehensions") (the talk dives into generator expressions a bit more deeply).

## Writing comprehensions with poor spacing

Critics of list comprehensions often say they’re hard to read. And they’re right, many comprehensions **are** hard to read. **Sometimes all a comprehension needs to be more readable is better spacing**.

Take the comprehension in this function:

```python
def get_factors(dividend):
    """Return a list of all factors of the given number."""
    return [n for n in range(1, dividend+1) if dividend % n == 0]
```

We could make that comprehension more readable by adding some well-placed line breaks:

```python
def get_factors(dividend):
    """Return a list of all factors of the given number."""
    return [
        n
        for n in range(1, dividend+1)
        if dividend % n == 0
    ]
```

Less code can mean more readable code, but not always. **Whitespace is your friend, especially when you’re writing comprehensions**.

In general, I prefer to write most of my comprehensions **spaced out over multiple lines of code** using the indentation style above. I do write one-line comprehensions sometimes, but I don’t default to them.

## Writing ugly comprehensions

Some loops technically **can** be written as comprehensions but they have so much logic in them they probably **shouldn’t** be.

Take this comprehension:

```python
fizzbuzz = [
    f'fizzbuzz {n}' if n % 3 == 0 and n % 5 == 0
    else f'fizz {n}' if n % 3 == 0
    else f'buzz {n}' if n % 5 == 0
    else n
    for n in range(100)
]
```

This comprehension is equivalent to this `for` loop:

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

Both the comprehension and the `for` loop use three nested [inline if statements](https://docs.python.org/3/faq/programming.html#is-there-an-equivalent-of-c-s-ternary-operator) (Python’s [ternary operator](https://en.wikipedia.org/wiki/%3F:)).

Here’s a more readable way to write this code, using an `if-elif-else` construct:

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

Just because there **is** a way to write your code as a comprehension, **that doesn’t mean that you **should** write your code as a comprehension**.

Be careful using any amount of complex logic in comprehensions, even a single [inline if](https://docs.python.org/3/faq/programming.html#is-there-an-equivalent-of-c-s-ternary-operator):

```python
number_things = [
    n // 2 if n % 2 == 0 else n * 3
    for n in numbers
]
```

If you really prefer to use a comprehension in cases like this, at least give some thought to **whether whitespace or parenthesis could make things more readable**:

```python
number_things = [
    (n // 2 if n % 2 == 0 else n * 3)
    for n in numbers
]
```

And consider whether breaking some of your logic out into a separate function might improve readability as well (it may not in this somewhat silly example).

```python
number_things = [
    even_odd_number_switch(n)
    for n in numbers
]
```

Whether a separate function makes things more readable will depend on how important that operation is, how large it is, and how well the function name conveys the operation.

## Loops disguised as comprehensions

Sometimes you’ll encounter code that uses a comprehension syntax but breaks the spirit of what comprehensions are used for.

For example, this code looks like a comprehension:

```python
[print(n) for n in range(1, 11)]
```

But it doesn’t **act** like a comprehension. We’re using a comprehension for a purpose it wasn’t intended for.

If we execute this comprehension in the Python shell you’ll see what I mean:

```python
>>> [print(n) for n in range(1, 11)]

[None, None, None, None, None, None, None, None, None, None]
```

We wanted to print out all the numbers from 1 to 10 and that’s what we did. But this comprehension statement also returned a list of `None` values to us, which we promptly discarded.

**Comprehensions build up lists: that’s what they’re for**. We built up a list of the return values from the `print` function and the `print` function returns `None`.

But we didn’t care about the list our comprehension built up: we only cared about its side effect.

We could have instead written that code like this:

```python
for n in range(1, 11):
    print(n)
```

List comprehensions are for **looping over an iterable and building up new lists**, while `for` loops are for **looping over an iterable to do pretty much any operation you’d like**.

When I see a list comprehension in code **I immediately assume that we’re building up a new list** (because that’s what they’re for). If you use a comprehension for **a purpose outside of building up a new list**, it’ll confuse others who read your code.

If you don’t care about building up a new list, don’t use a comprehension.

## Using comprehensions when a more specific tool exists

For many problems, a more specific tool makes more sense than a general purpose `for` loop. **But comprehensions aren’t always the best special-purpose tool for the job at hand.**

I have both seen and written quite a bit of code that looks like this:

```python
import csv

with open('populations.csv') as csv_file:
    lines = [
        row
        for row in csv.reader(csv_file)
    ]
```

That comprehension is sort of an **identity** comprehension. Its only purpose is to loop over the given iterable (`csv.reader(csv_file)`) and create a list out of it.

But in Python, we have a more specialized tool for this task: the `list` constructor. Python’s `list` constructor can do all the looping and list creation work for us:

```python
import csv

with open('populations.csv') as csv_file:
    lines = list(csv.reader(csv_file))
```

Comprehensions are a special-purpose tool for looping over an iterable to build up a new list while modifying each element along the way and/or filtering elements down. The `list` constructor is a special-purpose tool for looping over an iterable to build up a new list, without changing anything at all.

If you don’t need to filter your elements down or map them into new elements while building up your new list, **you don’t need a comprehension: you need the `list` constructor**.

This comprehension converts each of the `row` tuples we get from looping over `zip` into lists:

```python
def transpose(matrix):
    """Return a transposed version of given list of lists."""
    return [
        [n for n in row]
        for row in zip(*matrix)
    ]
```

We could use the `list` constructor for that too:

```python
def transpose(matrix):
    """Return a transposed version of given list of lists."""
    return [
        list(row)
        for row in zip(*matrix)
    ]
```

Whenever you see a comprehension like this:

```python
my_list = [x for x in some_iterable]
```

You could write this instead:

```python
my_list = list(some_iterable)
```

The same applies for `dict` and `set` comprehensions.

This is also something I’ve written quite a bit in the past:

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

Here we’re looping over a list of two-item tuples and making a dictionary out of them.

This task is exactly what the `dict` constructor was made for:

```python
abbreviations_to_names = dict(states)
```

The built-in `list` and `dict` constructors aren’t the only comprehension-replacing tools. The standard library and third-party libraries also include tools that are sometimes better suited for your looping needs than a comprehension.

Here’s a generator expression that sums up an iterable-of-iterables-of-numbers:

```python
def sum_all(number_lists):
    """Return the sum of all numbers in the given list-of-lists."""
    return sum(
        n
        for numbers in number_lists
        for n in numbers
    )
```

And here’s the same thing using `itertools.chain`:

```python
from itertools import chain

def sum_all(number_lists):
    """Return the sum of all numbers in the given list-of-lists."""
    return sum(chain.from_iterable(number_lists))
```

When you should use a comprehension and when you should use the alternative isn’t always straightforward.

I’m often torn on whether to use `itertools.chain` or a comprehension. I usually write my code both ways and then go with the one that seems clearer.

Readability is fairly problem-specific with many programming constructs, comprehensions included.

## Needless work

Sometimes you’ll see comprehensions that shouldn’t be replaced by another construct but should instead be **removed entirely**, leaving only the iterable they loop over.

Here we’re opening up a file of words (with one word per line), storing file in memory, and counting the number of times each occurs:

```python
from collections import Counter

word_counts = Counter(
    word
    for word in open('word_list.txt').read().splitlines()
)
```

We’re using a generator expression here, but we don’t need to be. This works just as well:

```python
from collections import Counter

word_counts = Counter(open('word_list.txt').read().splitlines())
```

We were looping over a list to convert it to a generator before passing it to the `Counter` class. That was needless work! The `Counter` class accepts **any iterable: it doesn’t care whether they’re lists, generators, tuples, or something else**.

Here’s another needless comprehension:

```python
with open('word_list.txt') as words_file:
    lines = [line for line in words_file]
    for line in lines:
        if 'z' in line:
            print('z word', line, end='')
```

We’re looping over `words_file`, converting it to a list of `lines`, and then looping over `lines` just once. That conversion to a list was unnecessary.

We could just loop over `words_file` directly instead:

```python
with open('word_list.txt') as words_file:
    for line in words_file:
        if 'z' in line:
            print('z word', line, end='')
```

There’s no reason to convert an iterable to a list if all we’re going to do is loop over it once.

In Python, we often care less about **whether something is a list** and more about **whether it’s an iterable**.

Be careful not to create new iterables when you don’t need to: **if you’re only going to loop over an iterable once, just use the iterable you already have**.

## When would I use a comprehension?

So when would you actually use a comprehension?

The simple but imprecise answer is whenever you can write your code in the below [comprehension copy-pasteable format](https://treyhunner.com/2015/12/python-list-comprehensions-now-in-color/ "List Comprehensions: Explain Visually") and there isn’t another tool you’d rather use for shortening your code, you should consider using a list comprehension.

```python
new_things = []
for ITEM in old_things:
    if condition_based_on(ITEM):
        new_things.append(some_operation_on(ITEM))
```

That loop can be rewritten as this comprehension:

```python
new_things = [
    some_operation_on(ITEM)
    for ITEM in old_things
    if condition_based_on(ITEM)
]
```

The complex answer is whenever comprehensions make sense, you should consider them. That’s not really an answer, but there is no one answer to the question “when should I use a comprehension”?

For example here’s a `for` loop which doesn’t really look like it could be rewritten using a comprehension:

```python
def is_prime(candidate):
    for n in range(2, candidate):
        if candidate % n == 0:
            return False
    return True
```

But there is in fact another way to write this loop using a generator expression, if we know how to use the built-in `all` function:

```python
def is_prime(candidate):
    return all(
        candidate % n != 0
        for n in range(2, candidate)
    )
```

I wrote [a whole article on the `any` and `all` functions](https://treyhunner.com/2016/11/check-whether-all-items-match-a-condition-in-python/) and how they pair so nicely with generator expressions. But `any` and `all` aren’t alone in their affinity for generator expressions.

We have a similar situation with this code:

```python
def sum_of_squares(numbers):
    total = 0
    for n in numbers:
        total += n**2
    return total
```

There’s no `append` there and no new iterable being built up. But if we create a generator of squares, we could pass them to the built-in `sum` function to get the same result:

```python
def sum_of_squares(numbers):
    return sum(n**2 for n in numbers)
```

So in addition to the “can I copy-paste my way from a loop to a comprehension” check, there’s another, fuzzier, check to consider: could your code be enhanced by a generator expression combined with an iterable-accepting function or class?

Any function or class that **accepts an iterable as an argument** **might** be a good candidate for **combining with a generator expression**.

## Use list comprehensions thoughtfully

List comprehensions can make your code more readable (if you don’t believe me, see the examples in my [Comprehensible Comprehensions](https://youtu.be/5_cJIcgM7rw "Comprehensible Comprehensions") talk), but they can definitely be abused.

List comprehensions are a special-purpose tool for solving a specific problem. The `list` and `dict` constructors are **even more special-purpose tools** for solving even more specific problems.

Loops are **a more general purpose tool** for times when you have a problem that doesn’t fit within the realm of comprehensions or another special-purpose looping tool.

Functions like `any`, `all`, and `sum`, and classes like `Counter` and `chain` are iterable-accepting tools that **pair very nicely with comprehensions** and sometimes **replace the need for comprehensions entirely**.

Remember that comprehensions are for a single purpose: **creating a new iterable from an old iterable**, while tweaking values slightly along the way and/or for filtering out values that don’t match a certain condition. Comprehensions are a lovely tool, but **they’re not your only tool**. Don’t forget the `list` and `dict` constructors and always consider `for` loops when your comprehensions get out of hand.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
