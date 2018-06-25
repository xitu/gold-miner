> * 原文地址：[Multiple assignment and tuple unpacking improve Python code readability](http://treyhunner.com/2018/03/tuple-unpacking-improves-python-code-readability/)
> * 原文作者：[Trey Hunner](http://treyhunner.com)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/tuple-unpacking-improves-python-code-readability.md](https://github.com/xitu/gold-miner/blob/master/TODO1/tuple-unpacking-improves-python-code-readability.md)
> * 译者：[lsvih](https://github.com/lsvih)
> * 校对者：

# 使用多重赋值与元组解包提升 Python 代码的可读性

无论是教导新手还是资深 Python 程序员，我都发现 **很多 Python 程序员没有充分利用多重赋值这一特性**。

多重赋值（也经常被称为元组解包或者可迭代对象解包）能让你在一行代码内同时对多个变量进行赋值。这种特性在学习时看起来很简单，但在真正需要使用时再去回想它可能会比较麻烦。

在本文中，将介绍什么是多重赋值，举一些常用的多重赋值的样例，并了解一些较少用、常被忽视的多重赋值用法。

请注意在本文中会用到 [f-strings](https://cito.github.io/blog/f-strings/) 这种 Python 3.6 以上版本才有的特性，如果你的 Python 版本较老，可以自己用字符串的 `format` 方法来代替这种特性。

## 多重赋值的实现原理

在本文中，我将使用“多重赋值”、“元组解包”、“迭代对象解包”等不同的词，但他们其实表示的是同一个东西。

Python 的多重赋值如下所示：

```
>>> x, y = 10, 20
```

在这儿我们将 `x` 设为了 `10`，`y` 设为了 `20`。

从更底层的角度看，我们其实是创建了一个 `10, 20` 的元组，然后对这个元组进行循环，将拿到的两个数字按照顺序分别赋给 `x` 与 `y`。

写成下面这种语法应该更容易理解：

```
>>> (x, y) = (10, 20)
```

在 Python 中，元组周围的括号是可以忽略的，因此在“多重赋值”（写成上面这种元组形式的语法）时也可以省去。下面几行代码都是等价的：

```
>>> x, y = 10, 20
>>> x, y = (10, 20)
>>> (x, y) = 10, 20
>>> (x, y) = (10, 20)
```

多重赋值常被直接称为“元组解包”，因为它在大多数情况下都是用于元组。但其实我们可以用除了元组之外的任何可迭代对象进行多重赋值。下面是使用列表（list）的结果：

```
>>> x, y = [10, 20]
>>> x
10
>>> y
20
```

下面是使用字符串（string）的结果：

```
>>> x, y = 'hi'
>>> x
'h'
>>> y
'i'
```

任何可以用于循环的东西都能和元组解包、多重赋值一样被“解开”。

下面是另一个可以证明多重赋值能用于任何数量、任何变量（甚至是我们自己创建的对象）的例子：

```
>>> point = 10, 20, 30
>>> x, y, z = point
>>> print(x, y, z)
10 20 30
>>> (x, y, z) = (z, y, x)
>>> print(x, y, z)
30 20 10
```

请注意，在上面例子中的最后一行我们仅交换了变量的名称。多重赋值可以让我们轻松地实现这种情形。

下面我们将讨论如何使用多重赋值。

## 在 for 循环中解包

你会经常在 `for` 循环中看到多重赋值。下面举例说明：

先创建一个字典（dict）：

```
>>> person_dictionary = {'name': "Trey", 'company': "Truthful Technology LLC"}
```

下面这种循环遍历字典的方法比较少见：

```
for item in person_dictionary.items():
    print(f"Key {item[0]} has value {item[1]}")
```

但你会经常看到 Python 程序员通过多重赋值来这么写：

```
for key, value in person_dictionary.items():
    print(f"Key {key} has value {value}")
```

当你在 for 循环中写 `for X in Y` 时，其实是告诉 Python 在循环的每次遍历时都对 `X` 做一次赋值。与用 `=` 符号赋值一样，这儿也可以使用多重赋值。

这种写法：

```
for key, value in person_dictionary.items():
    print(f"Key {key} has value {value}")
```

在本质上与这种写法是一致的：

```
for item in person_dictionary.items():
    key, value = item
    print(f"Key {key} has value {value}")
```

与前一个例子相比，我们其实就是去掉了一个没有必要的额外赋值。

因此，多重赋值在用于将字典元素解包为键值对时十分有用。此外，它还在其它地方也可以使用：

在内置函数 `enumerate` 的值拆分成对时，也是多重赋值的一个很有用的场景：

```
for i, line in enumerate(my_file):
    print(f"Line {i}: {line}")
```

还有 `zip` 函数：

```
for color, ratio in zip(colors, ratios):
    print(f"It's {ratio*100}% {color}.")
```

```
for (product, price, color) in zip(products, prices, colors):
    print(f"{product} is {color} and costs ${price:.2f}")
```

如果你还对 `enumerate` 和 `zip` 不熟悉，请参阅作者之前的文章 [looping with indexes in Python](http://treyhunner.com/2016/04/how-to-loop-with-indexes-in-python/)。

有些 Python 新手经常在 `for` 循环中看到多重赋值，然后就认为它只能与循环一起使用。但其实，多重赋值不仅可以用在循环赋值时，还可以用在其它任何需要赋值的地方。

## 替代硬编码索引

很少有人在代码中对索引进行硬编码（比如 `point[0]`、`items[1]`、`vals[-1]`）：

```
print(f"The first item is {items[0]} and the last item is {items[-1]}")
```

当你在 Python 代码中看到有硬编码索引时，一般都可以设法**使用多重赋值来让你的代码更具可读性**。

下面是一些使用了硬编码索引的代码：

```python
def reformat_date(mdy_date_string):
    """Reformat MM/DD/YYYY string into YYYY-MM-DD string."""
    date = mdy_date_string.split('/')
    return f"{date[2]}-{date[0]}-{date[1]}"
```

我们可以通过多重赋值，分别对月、天、年三个变量进行赋值，让代码更具可读性：

```python
def reformat_date(mdy_date_string):
    """Reformat MM/DD/YYYY string into YYYY-MM-DD string."""
    month, day, year = mdy_date_string.split('/')
    return f"{year}-{month}-{day}"
```

因此无论何时你在代码中将索引写死了，请停下来想一想是不是应该用多重赋值来改善代码的可读性。

## 多重赋值是十分严格的

在我们对可迭代对象进行解包时，多重赋值的条件是非常严格的。

如果将一个较大的可迭代对象解包到一组数量更小的对象中，会报下面的错误：

```
>>> x, y = (10, 20, 30)
Traceback (most recent call last):
    File "<stdin>", line 1, in <module>
ValueError: too many values to unpack (expected 2)
```

如果将一个较小的可迭代对象解包到一组数量更多的对象中，会报下面的错误：

```
>>> x, y, z = (10, 20)
Traceback (most recent call last):
    File "<stdin>", line 1, in <module>
ValueError: not enough values to unpack (expected 3, got 2)
```

这种严格其实很棒，如果我们在处理元素时出现了非预期的对象数量，多重赋值会直接报错，这样我们就能发现一些还没有被发现的 bug。

举个例子。假设我们有一个简单的命令行程序，通过原始的方式接受参数，如下所示：

```
import sys

new_file = sys.argv[1]
old_file = sys.argv[2]
print(f"Copying {new_file} to {old_file}")
```

这个程序希望接受两个参数，如下所示：

```
$ my_program.py file1.txt file2.txt
Copying file1.txt to file2.txt
```

但如果在运行程序时输入了三个参数，也不会有任何报错：

```
$ my_program.py file1.txt file2.txt file3.txt
Copying file1.txt to file2.txt
```

由于我们没有验证接收到的参数是否为 2 个，因此不会报错。

如果使用多重赋值来代替硬编码索引，在赋值时将会验证程序是否真的接收到了期望个数的参数：

```
import sys

_, new_file, old_file = sys.argv
print(f"Copying {new_file} to {old_file}")
```

**注意：** 我们用了一个名为 `_` 的变量，意思是我们不想关注 `sys.argv[0]`（对应的是我们程序的名称）。用 `_` 对象来忽略不需关注的变量是一种常用的语法。

## 替代数组拆分

根据上文，我们一直多重赋值可以用来代替硬编码的索引，并且它严格的条件可以确保我们处理的元组或可迭代对象的大小是正确的。

此外，多重赋值还能用于代替硬编码的数组拆分。

“拆分”是一种手动将 list 或其它序列中的部分元素取出的方法、

下面是一种用数字索引进行“硬编码”拆分的方法：

```
all_after_first = items[1:]
all_but_last_two = items[:-2]
items_with_ends_removed = items[1:-1]
```

当你在拆分时发现没有在拆分索引中用到变量，那么就能用多重赋值来替代它。为了实现多重赋值拆分数组，我们将用到一个之前没提过的特性：`*` 符号。

`*` 符号于 Python 3 中加入了多重赋值的语法中，它可以让我们在解包时拿到“剩余”的元素：

```
>>> numbers = [1, 2, 3, 4, 5, 6]
>>> first, *rest = numbers
>>> rest
[2, 3, 4, 5, 6]
>>> first
1
```

因此，`*` 可以让我们在取数组末尾时替换硬编码拆分。

下面两行是等价的：

```
>>> beginning, last = numbers[:-1], numbers[-1]
>>> *beginning, last = numbers
```

下面两行也是等价的：

```
>>> head, middle, tail = numbers[0], numbers[1:-1], numbers[-1]
>>> head, *middle, tail = numbers
```

有了 `*` 和多重赋值之后，你可以替换一切类似于下面这样的代码：

```
main(sys.argv[0], sys.argv[1:])
```

可以写成下面这种更具自描述性的代码：

```
program_name, *arguments = sys.argv
main(program_name, arguments)
```

总之，如果你写了硬编码的拆分代码，请考虑一下你可以用多重赋值来让这些拆分的逻辑更加清晰。

## 深度解包

这个特性是 Python 程序员长期以来经常忽略的一个东西。它虽然不如我之前提到的几种多重复值用法常用，但是当你用到它的时候会深刻体会到它的好处。

在前文，我们已经看到多重赋值用于解包元组或者其它的可迭代对象，但还没看过它**更进一步**地进行深度解包。

下面例子中的多重赋值是**浅度**的，因为它只进行了一层的解包：

```
>>> color, point = ("red", (1, 2, 3))
>>> color
'red'
>>> point
(1, 2, 3)
```

而下面这种多重赋值可以认为是**深度**的，因为它将 `point` 元组也进一步解包成了 `x`、`y`、`z` 变量：

```
>>> color, (x, y, z) = ("red", (1, 2, 3))
>>> color
'red'
>>> x
1
>>> y
2
```

上面的例子可能比较让人迷惑，所以我们在赋值语句两端加上括号来让这个例子更加明了：

```
>>> (color, (x, y, z)) = ("red", (1, 2, 3))
```

可以看到在第一层解包时得到了两个对象，但是这个语句将第二个对象再次解包，得到了另外的三个对象。然后将第一个对象及新解出的三个对象赋值给了新的对象（`color`、`x`、`y`、`z`）。

下面以这两个 list 为例：

```
start_points = [(1, 2), (3, 4), (5, 6)]
end_points = [(-1, -2), (-3, 4), (-6, -5)]
```

下面的代码是举例用浅层解包来处理上面的两个 list：

```
for start, end in zip(start_points, end_points):
    if start[0] == -end[0] and start[1] == -end[1]:
        print(f"Point {start[0]},{start[1]} was negated.")
```

下面用深度解包来做同样的事情：

```
for (x1, y1), (x2, y2) in zip(start_points, end_points):
    if x1 == -x2 and y1 == -y2:
        print(f"Point {x1},{y1} was negated.")
```

请注意在第二个例子中，在处理对象时，对象的类型明显更加清晰易懂。深度解包让我们可以明显的看到，在每次循环中我们都会收到两个二元组。

深度解包通常会在每次得到多个元素的嵌套循环中使用。例如，你能在同时使用 `enumerate` 与 `zip` 时应用深度多重赋值：

```
items = [1, 2, 3, 4, 2, 1]
for i, (first, last) in enumerate(zip(items, reversed(items))):
    if first != last:
        raise ValueError(f"Item {i} doesn't match: {first} != {last}")
```

前面我提到过多重赋值对于可迭代对象的大小以及解包的大小是非常严格的，在复读解包中我们也可以利用这点**严格控制可迭代对象的大小**。

这么写可以正常运行：

```
>>> points = ((1, 2), (-1, -2))
>>> points[0][0] == -points[1][0] and points[0][1] == -point[1][1]
True
```

这种看起来 bug 的代码也能正常运行：

```
>>> points = ((1, 2, 4), (-1, -2, 3), (6, 4, 5))
>>> points[0][0] == -points[1][0] and points[0][1] == -point[1][1]
True
```

这种写法也能运行：

```
>>> points = ((1, 2), (-1, -2))
>>> (x1, y1), (x2, y2) = points
>>> x1 == -x2 and y1 == -y2
True
```

但是这样不行：

```
>>> points = ((1, 2, 4), (-1, -2, 3), (6, 4, 5))
>>> (x1, y1), (x2, y2) = points
Traceback (most recent call last):
    File "<stdin>", line 1, in <module>
ValueError: too many values to unpack (expected 2)
```

在给变量多重赋值时我们其实也对可迭代对象做了一次特殊的断言（assert）。因此多重赋值既能让别人更容易理清你的代码（**因为有着更好的代码可读性**），也能让电脑更好地理解你的代码（**因为对代码进行了确认保证了正确性**）。

## 使用 list 类型语法

在前文我提到的多重赋值都用的是元组类型的语法（tuple-like），但其实多重赋值可以用于任何可迭代对象。而这种类似元组的语法也使得多重赋值常被称为“元组解包”。而更准确地来说，多重赋值应该叫做“可迭代对象解包”。

前文中我还没有提到过，多重赋值可以写成 list 类型的语法（list-like）。

下面是一个应用 list 语法的最简单多重赋值示例：

```
>>> [x, y, z] = 1, 2, 3
>>> x
1
```

这种写法看起来很奇怪。为什么在元组语法之外还要允许这种 list 语法呢？

我也很少使用这种特性，但它在一些特殊情况下能让代码更加**简洁**。

举例，假设我有下面这种代码：

```
def most_common(items):
    return Counter(items).most_common(1)[0][0]
```

我们用心良苦的同事决定用深度多重赋值将代码重构成下面这样：

```
def most_common(items):
    (value, times_seen), = Counter(items).most_common(1)
    return value
```

看到赋值语句左侧的最后一个逗号了吗？很容易会将它漏掉，而且这个逗号让代码看起来不伦不类。这个逗号在这段代码中是做什么事的呢？

此处的尾部逗号其实是构造了一个单元素的元组，然后对此处进行深度解包。

可以将上面的代码换种写法：

```
def most_common(items):
    ((value, times_seen),) = Counter(items).most_common(1)
    return value
```

这种写法让深度解包的语法更加明显了。但我更喜欢下面这种写法：

```
def most_common(items):
    [(value, times_seen)] = Counter(items).most_common(1)
    return value
```

赋值中的 list 语法让它更加的清晰，可以明确看出我们将一个单元素可迭代对象进行了解包，并将单元素又解包并赋值给 `value` 与 `times_seen` 对象。

当我看到这种代码时，可以非常确定我们解包的是一个单元组 list（事实上代码做的也正是这个）。我们在此处用了 collections 模组中的 [Counter](https://docs.python.org/3/library/collections.html#collections.Counter) 对象。`Counter` 对象的 `most_common` 方法可以让我们指定返回 list 的长度。在此处我们将 list 限制为仅返回一个元素。

当你在解包有很多的值的结构（比如说 list）或者有确定个数值的结构（比如说元组）时，可以考虑用 list 语法来对这些类似 list 的结构进行解包，这样能让代码更加具有“语法正确性”。

如果你乐意，还可以用对类 list 结构使用 list 语法解包时应用一些 list 的语法（常见的例子为在多重赋值时使用 `*` 符号）：

```
>>> [first, *rest] = numbers
```

我自己其实不常用这种写法，因为我没有这个习惯。但如果你觉得这种写法有用，可以考虑在你自己的代码中用上它。

结论：当你在代码中用多重赋值时，可以考虑在何时的时候用 list 语法来让你的代码更具自解释性并更加简洁。这有时也能提升代码的可读性。

## 不要忘记这些多重赋值的用法

多重赋值可以提高代码的可读性与正确性。它能使你代码**更具自描述性**，同时也可以对正在进行解包的可迭代对象的**大小**进行隐式断言。

据我观察，人们经常忘记多重赋值可以**替换硬编码索引**，以及**替换硬编码拆分**（用 `*` 语法）。深度多重赋值，以及同时使用元组语法和 list 语法也常被忽视。

认清并记住所有多重赋值的用例是很麻烦的。请随意使用本文作为你使用多重赋值的参考指南。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
