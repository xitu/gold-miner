> * 原文地址：[Keyword (Named) Arguments in Python: How to Use Them](http://treyhunner.com/2018/04/keyword-arguments-in-python/)
> * 原文作者：[Trey Hunner](http://treyhunner.com)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/keyword-arguments-in-python.md](https://github.com/xitu/gold-miner/blob/master/TODO1/keyword-arguments-in-python.md)
> * 译者：[sisibeloved](https://github.com/sisibeloved)
> * 校对者：[Starriers](https://github.com/Starriers)、[ALVINYEH](https://github.com/ALVINYEH)

# Python 中的键值（具名）参数：如何使用它们

键值参数是 Python 的一个特性，对于从其他编程语言转到 Python 的人来说，不免看起来有些奇怪。人们在学习 Python 的时候，经常要花很长时间才能理解键值参数的各种特性。

在 Python 教学中，我经常希望我能三言两语就把键值参数丰富的相关特性讲清楚。但愿这篇文章能够达到这个效果。

在这篇文章中我会解释键值参数是什么和为什么要用到它。随后我会细数一些更为深入的使用技巧，就算老 Python 程序员也可能会忽略，因为 Python 3 的最近一些版本变动了许多东西。如果你已经是一个资深的 Python 程序员，你可以直接跳到结尾。

## 什么是键值参数？

让我们来看看到底什么是键值参数（也叫做具名参数）。

先看看下面这个 Python 函数：

```python
from math import sqrt

def quadratic(a, b, c):
    x1 = -b / (2*a)
    x2 = sqrt(b**2 - 4*a*c) / (2*a)
    return (x1 + x2), (x1 - x2)
```

当我们调用这个函数时，我们有两种不同的方式来传递这三个参数。

我们可以像这样以占位参数的形式传值：

```python
>>> quadratic(31, 93, 62)
(-1.0, -2.0)
```

或者像这样以键值参数的形式：

```python
>>> quadratic(a=31, b=93, c=62)
(-1.0, -2.0)
```

当用占位方式传值时，参数的顺序至关重要：

```python
>>> quadratic(31, 93, 62)
(-1.0, -2.0)
>>> quadratic(62, 93, 31)
(-0.5, -1.0)
```

但是加上参数名就没关系了：

```python
>>> quadratic(a=31, b=93, c=62)
(-1.0, -2.0)
>>> quadratic(c=62, b=93, a=31)
(-1.0, -2.0)
```

当我们使用键值/具名参数时，有意义的是参数的名字，而不是它的位置：

```python
>>> quadratic(a=31, b=93, c=62)
(-1.0, -2.0)
>>> quadratic(c=31, b=93, a=62)
(-0.5, -1.0)
```

所以不像许多其它的编程语言，Python 知晓函数接收的参数名称。

如果我们使用帮助函数，Python 会把三个参数的名字告诉我们：

```python
>>> help(quadratic)
Help on function quadratic in module __main__:

quadratic(a, b, c)
```

注意，可以通过占位和具名混合的方式来调用函数：

```python
>>> quadratic(31, 93, c=62)
(-1.0, -2.0)
```

这样确实很方便，但像我们写的这个函数使用全占位参数或全键值参数会更清晰。

## 为什么要使用键值参数？

在 Python 中调用函数的时候，你通常要在键值参数和占位参数之间二者择一。使用键值参数可以使函数调用更加明确。

看看这段代码：

```python
def write_gzip_file(output_file, contents):
    with GzipFile(None, 'wt', 9, output_file) as gzip_out:
        gzip_out.write(contents)
```

这个函数接收一个 `output_file` 文件对象和 `contents` 字符串，然后把一个经过 gzip 压缩的字符串写入输出文件。

下面这段代码做了相同的事，只是用键值参数代替了占位参数：

```python
def write_gzip_file(output_file, contents):
    with GzipFile(fileobj=output_file, mode='wt', compresslevel=9) as gzip_out:
        gzip_out.write(contents)
```

可以看到使用键值参数调用这种方式可以更清楚地看出这三个参数的意义。

我们在这里去掉了一个参数。第一个参数代表 `filename`，并且有一个 `None` 的默认值。这里我们不需要 `filename`，因为我们应该只传一个文件对象或者只传一个文件名给 `GzipFile`，而不是两者都传。

我们还能再去掉一个参数。

还是原来的代码，不过这次压缩率被去掉了，以默认的 `9` 代替：

```python
def write_gzip_file(output_file, contents):
    with GzipFile(fileobj=output_file, mode='wt') as gzip_out:
        gzip_out.write(contents)
```

因为使用了具名参数，我们得以去掉两个参数，并把余下 2 个参数以合理的顺序排列（文件对象比『wt』获取模式更重要）。

当我们使用键值参数时：

1.  我们可以去除有默认值的参数
2.  我们可以以一种更为可读的方式将参数重新排列
3.  通过名称调用参数更容易理解参数的含义

## 哪里能看到键值函数

你可以在 Python 中的很多地方看到键值参数。

Python 有一些接收无限量的占位参数的函数。这些函数有时可以接收用来定制功能的参数。这些参数必须使用具名参数，与无限量的占位参数区分开来。

内置的 `print` 函数的可选属性 `sep`、`end`、`file` 和 `flush`，只能接收键值参数：

```python
>>> print('comma', 'separated', 'words', sep=', ')
comma, separated, words
```

`itertools.zip_longest` 函数的 `fillvalue` 属性（默认为 `None`），同样只接收键值参数：

```python
>>> from itertools import zip_longest
>>> list(zip_longest([1, 2], [7, 8, 9], [4, 5], fillvalue=0))
[(1, 7, 4), (2, 8, 5), (0, 9, 0)]
```

事实上，一些 Python 中的函数强制参数被具名，尽管以占位方式**可以**清楚地指定。

在 Python 2 中，`sorted` 函数可以以占位或键值的方式接收参数：

```python
>>> sorted([4, 1, 8, 2, 7], None, None, True)
[8, 7, 4, 2, 1]
>>> sorted([4, 1, 8, 2, 7], reverse=True)
[8, 7, 4, 2, 1]
```

但是 Python 3 中的 `sorted` 要求迭代器之后的所有参数都以键值的形式指定：

```python
>>> sorted([4, 1, 8, 2, 7], None, True)
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
TypeError: must use keyword argument for key function
>>> sorted([4, 1, 8, 2, 7], reverse=True)
[8, 7, 4, 2, 1]
```

不仅仅是 Python 的内置函数，标准库和第三方库中键值参数同样很常见。

## 使你的参数具名

通过使用 `*` 操作符来匹配所有占位参数然后在 `*` 之后指定可选的键值参数，你可以创建一个接收任意数量的占位参数和特定数量的键值参数的函数。

这儿有个例子：

```python
def product(*numbers, initial=1):
    total = initial
    for n in numbers:
        total *= n
    return total
```

**注意**：如果你之前没有看过 `*` 的语法，`*numbers` 会把所有输入 `product` 函数的占位参数放到一个 `numbers` 变量指向的元组。

上面这个函数中的 `initial` 参数必须以键值形式指定：

```python
>>> product(4, 4)
16
>>> product(4, 4, initial=1)
16
>>> product(4, 5, 2, initial=3)
120
```

注意 `initial` 有一个默认值。你也可以用这种语法指定**必需的**键值参数：

```python
def join(*iterables, joiner):
    if not iterables:
        return
    yield from iterables[0]
    for iterable in iterables[1:]:
        yield joiner
        yield from iterable
```

`joiner` 变量没有默认值，所以它必须被指定：

```python
>>> list(join([1, 2, 3], [4, 5], [6, 7], joiner=0))
[1, 2, 3, 0, 4, 5, 0, 6, 7]
>>> list(join([1, 2, 3], [4, 5], [6, 7], joiner='-'))
[1, 2, 3, '-', 4, 5, '-', 6, 7]
>>> list(join([1, 2, 3], [4, 5], [6, 7]))
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
TypeError: join() missing 1 required keyword-only argument: 'joiner'
```

需要注意的是这种把参数放在 `*` 后面的语法只在 Python 3 中有效。Python 2 中没有要求参数必须要被命名的语法。

## 只接收键值参数而不接收占位参数

如果你想只接收键值参数而不接收任何占位参数呢？

如果你想接收一个键值参数，并且不打算接收任何 `*` 占位参数，你可以在 `*` 后面不带任何字符。

比如这儿有一个修改过的 Django 的 `django.shortcuts.render` 函数：

```python
def render(request, template_name, context=None, *, content_type=None, status=None, using=None):
    content = loader.render_to_string(template_name, context, request, using=using)
    return HttpResponse(content, content_type, status)
```

与 Django 现在的 `render` 函数实现不一样，这个版本不允许以所有参数都以占位方式指定的方式来调用 `render`。`context_type`、`status` 和 `using` 参数必须通过`名称`来指定。

```python
>>> render(request, '500.html', {'error': error}, status=500)
<HttpResponse status_code=500, "text/html; charset=utf-8">
>>> render(request, '500.html', {'error': error}, 500)
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
TypeError: render() takes from 2 to 3 positional arguments but 4 were given
```

就像带有无限制占位参数时的情况一样，这些键值参数也可以是必需的。这里有一个函数，有四个必需的键值参数：

```python
from random import choice, shuffle
UPPERCASE = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
LOWERCASE = UPPERCASE.lower()
DIGITS = "0123456789"
ALL = UPPERCASE + LOWERCASE + DIGITS

def random_password(*, upper, lower, digits, length):
    chars = [
        *(choice(UPPERCASE) for _ in range(upper)),
        *(choice(LOWERCASE) for _ in range(lower)),
        *(choice(DIGITS) for _ in range(digits)),
        *(choice(ALL) for _ in range(length-upper-lower-digits)),
    ]
    shuffle(chars)
    return "".join(chars)
```

这个函数要求所有函数都必须以名称指定：

```python
>>> random_password(upper=1, lower=1, digits=1, length=8)
'oNA7rYWI'
>>> random_password(upper=1, lower=1, digits=1, length=8)
'bjonpuM6'
>>> random_password(1, 1, 1, 8)
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
TypeError: random_password() takes 0 positional arguments but 4 were given
```

要求参数具名可以使函数的调用更加清楚明白。

这样调用函数的意图：

```python
>>> password = random_password(upper=1, lower=1, digits=1, length=8)
```

要比这样调用更为清楚：

```python
>>> password = random_password(1, 1, 1, 8)
```

再强调一次，这种语法只在 Python 3 中适用。

## 匹配通配键值参数

怎样写出一个匹配任意数量键值参数的函数？

举个例子，字符串格式化方法接收你传递给它的任意键值参数：

```python
>>> "My name is {name} and I like {color}".format(name="Trey", color="purple")
'My name is Trey and I like purple'
```

怎么样才能写出这样的函数？

Python 允许函数匹配任意输入的键值参数，通过在定义函数的时候使用 `**` 操作符：

```python
def format_attributes(**attributes):
    """Return a string of comma-separated key-value pairs."""
    return ", ".join(
        f"{param}: {value}"
        for param, value in attributes.items()
    )
```


`**` 操作符允许 `format_attributes` 函数接收任意数量的键值参数。输入的参数会被存在一个叫 `attributes` 的字典里面。

这是我们的函数的使用示例：

```python
>>> format_attributes(name="Trey", website="http://treyhunner.com", color="purple")
'name: Trey, website: http://treyhunner.com, color: purple'

```

## 用通配键值参数调用函数

就像你可以定义函数接收通配键值参数一样，你也可以在调用函数时传入通配键值参数。

这就意味着你可以基于字典中的项向函数传递键值参数。

这里我们从一个字典中手动提取键/值对，并把它们以键值参数的形式传入函数中：

```python
>>> items = {'name': "Trey", 'website': "http://treyhunner.com", 'color': "purple"}
>>> format_attributes(name=items['name'], website=items['website'], color=items['color'])
'name: Trey, website: http://treyhunner.com, color: purple'
```

这种在代码函数调用时将代码写死的方式需要我们在写下代码的时候就知道所使用的字典中的每一个键。当我们不知道字典中的键时，这种方法就不奏效了。

我们可以通过 `**` 操作符将字典中的项拆解成函数调用时的键值参数，来向函数传递通配键值参数：

```python
>>> items = {'name': "Trey", 'website': "http://treyhunner.com", 'color': "purple"}
>>> format_attributes(**items)
'name: Trey, website: http://treyhunner.com, color: purple'
```

这种向函数传递通配键值参数和在函数内接收通配键值参数（就像我们之前做的那样）的做法在使用类继承时尤为常见：

```python
def my_method(self, *args, **kwargs):
    print('Do something interesting here')
    super().my_method(*args, **kwargs)  # 使用传入的参数调用父类的方法
```

**注意**：同样地我们可以使用 `*` 操作符来匹配和拆解占位参数。

## 顺序敏感性

自 Python 3.6 起，函数将会保持键值参数传入的顺序（参见 [PEP 468](https://www.python.org/dev/peps/pep-0468/)）。这意味着当使用 `**` 来匹配键值参数时，用来储存结果的字典的键将会与传入参数拥有同样的顺序。

所以在 Python 3.6 之后，你将**不会再**看到这样的情况：

```python
>>> format_attributes(name="Trey", website="http://treyhunner.com", color="purple")
'website: http://treyhunner.com, color: purple, name: Trey'
```

相应地，使用 Python 3.6+，参数会永远保持传入的顺序：
```python
>>> format_attributes(name="Trey", website="http://treyhunner.com", color="purple")
'name: Trey, website: http://treyhunner.com, color: purple'
```

## 概括 Python 中的键值参数

一个参数的**位置**传达出来的信息通常不如**名称**有效。因此在调用函数时，如果能使它的意义更清楚，考虑为你的参数赋名。

定义一个新的函数时，不要再考虑哪个参数应该被指定为键值参数了。使用 `*` 操作符把这些参数都指定成键值参数。

牢记你可以使用 `**` 操作符来接受和传递通配键值参数。

重要的对象应该要有名字，你可以使用键值参数来给你的对象赋名！

## 喜欢我的教学风格吗？

想要学习更多关于 Python 的知识？我会通过实时聊天每周分享我喜爱的 Python 资源并回答有关 Python 的问题。在下方登记，我会回答**你的问题**并教你如何让你的 Python 代码更加生动易懂，更加 Python 化。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
