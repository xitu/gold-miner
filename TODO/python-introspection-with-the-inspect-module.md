> * 原文地址：[How to write your own Python documentation generator](https://medium.com/python-pandemonium/python-introspection-with-the-inspect-module-2c85d5aa5a48#.hcqq6xtl8)
* 原文作者：[Cristian Medina](https://medium.com/@tryexceptpass)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[王子建](https://github.com/Romeo0906)
* 校对者：

# How to write your own Python documentation generator

# 来写一个 Python 文档生成器吧

In my early days with Python, one of the things that I really liked was using the built-in `help` function to examine classes and methods while sitting at the interpreter, trying to determine what to type next. This function imports an object and walks through its members, pulling out docstrings and generating manpage-like output to help give you an idea of how to use the object it was examining.

我一开始学习 Python 的时候，我最喜欢的一件事就是坐在编译器前，使用内置的 `help` 函数检查类和方法，然后决定我接下来要怎么写。这个函数会引入一个对象并检查其内部成员，生成说明并且输出类似帮助文档的内容，帮助你了解该对象的使用方法。

The beauty about it being built into the standard library is that with output being generated straight from code, it indirectly emphasizes a coding style for lazy people like me, who want to do as little extra work as possible to maintain documentation. Especially if you already choose straight forward names for your variables and functions. This style involves things like adding docstrings to your functions and classes, as well as properly identifying private and protected members by prefixing them with underscores.

将 `help` 函数置入标准库最为美妙的一点就是它能直接从代码中输出说明内容，这也间接地助长了一些 人的懒惰，比如像我这种不想为文档多浪费一点力气的人。尤其是你已经为你的变量和函数起好了直白的名字，`help` 函数能够给你的函数和类添加说明，也能够正确地识别私有和受保护的成员并给它们添加下划线的前缀。

    Help on class list in module builtins:

    class list(object)
     |  list() -> new empty list
     |  list(iterable) -> new list initialized from iterable's items
     |
     |  Methods defined here:
     |
     |  __add__(self, value, /)
     |      Return self+value.

    ...

     |  __iter__(self, /)
     |      Implement iter(self).

    ...

     |  append(...)
     |      L.append(object) -> None -- append object to end
     |
     |  extend(...)
     |      L.extend(iterable) -> None -- extend list by appending elements from the iterable
     |
     |  index(...)
     |      L.index(value, [start, [stop]]) -> integer -- return first index of value.
     |      Raises ValueError if the value is not present.

     ...

     |  pop(...)
     |      L.pop([index]) -> item -- remove and return item at index (default last).
     |      Raises IndexError if list is empty or index is out of range.
     |
     |  remove(...)
     |      L.remove(value) -> None -- remove first occurrence of value.
     |      Raises ValueError if the value is not present.

     ...

     |  ----------------------------------------------------------------------
     |  Data and other attributes defined here:
     |
     |  __hash__ = None





Output from running `help(list)` at the Python interpreter

在 Python 编译器中使用 `help(list)` 会输出以上内容

The help function is actually using the `pydoc` module to generate its output, which is also runnable from the command line to produce a text or html representation of any importable module in your path.

实际上，help 函数使用了 `pydoc` 模块来生成输出的内容，该模块也可以在命令行中运行生成任何引入模块的 .txt 或者 .html 格式的说明文档。

* * *

A little while ago I needed to write more detailed, formal, design documentation and — being a fan of Markdown — I decided to play around with [`mkdocs`](http://www.mkdocs.org/) to see if I could get what I was looking for. This module makes it easy to turn your markdown text into nicely styled web pages and can serve them up as you make changes before publishing to an official location. It comes with a template for [readthedocs](https://readthedocs.org/) and even provides an easy command line interface to push your changes into [GitHub Pages](https://pages.github.com/) if you wish to go down that route.

不久前，我需要写一些更加详细、正式的设计文档，作为 Markdown 的忠实拥趸，我决定去看看 [`mkdocs`](http://www.mkdocs.org/) 能否给我提供有效内容。这个模块能够很容易地将你的 markdow 文本转换成风格精美的网页，并且在你正式发布之前都可以做出修改。它提供了一个 [readthedocs](https://readthedocs.org/) 模板，还提供了一个简单的命令行界面，方便你将内容推到 [GitHub Pages](https://pages.github.com/) 上。

Having completed my initial batch of text describing design decisions and considerations, I wanted to add details on the actual interface methods I was developing and exposing to the other modules in the project. Since I already wrote the definitions for most of those functions, I intended to automatically generate the reference pages from my source, and I wanted it in markdown so it could render into html along with the rest of my documentation whenever I ran mkdocs.

完成最初的一些设计需求文档之后，我想给自己开发的面向其他项目模块的现行接口方法添加细节描述。因为我已经给大多数的方法都写了定义，所以我想从源文件中自动生成引用页面，并且想使用 markdown 格式以便日后我可以和其他文件一起用 mkdocs 渲染成 html 文档。

However, it turns out there is no default way of generating markdown from source with mkdocs, but there are plugins. After googling and researching a bit more, I was not content with the projects or plugins I found — lots of things are out of date, not maintained, or the output was just not what I was looking for — so I decided to write my own. I thought it would be another interesting foray into learning a little more about a module I used a little while ago when building a debugger for one of my previous articles (see [Hacking together a Simple Graphical Python Debugger](https://medium.com/@tryexceptpass/hacking-together-a-simple-graphical-python-debugger-efe7e6b1f9a8#.jqe3no3k9)): the `inspect`module.

然而，项目中并没有默认使用 mkdocs 从源文件中生成 markdown 文件的方法，但是有插件可以做到。经过一阵子搜索和研究之后，我对网上找到的项目和插件感到很失望——许多都已经过时了，没有人维护，或者根本不能输出我想要的内容——所以我决定自己写。我认为这将是一场饶有趣味的战争，我将会深入学习不久前为旧文（详见：[Hacking together a Simple Graphical Python Debugger](https://medium.com/@tryexceptpass/hacking-together-a-simple-graphical-python-debugger-efe7e6b1f9a8#.jqe3no3k9)）构建调试器的时稍加使用过的模块：`inspect` 模块。

> “The inspect module provides several useful functions to help get information about live objects… ” — [Python Docs](https://docs.python.org/3.6/library/inspect.html)

> “Inspect 模块提供了一些非常有用的方法来获取当前的对象的信息……”——[Python 文档](https://docs.python.org/3.6/library/inspect.html)

#### Inspect this!

#### 来吧 Inspect！

Originating from the standard library, inspect not only lets you look at lower level python `frame` and `code` objects, it also provides a number of methods for examining modules and classes, helping you find the items that may be of interest. It’s what pydoc uses to generate the help files mentioned previously.

Inspect 是标准库中的模块，它不仅能够让检视低级别的 python `frame` 和 `code` 对象，还提供了许多方法来检查模块和类，能够帮助你找到可能感兴趣的内容。正如上文所言， pydoc 正是用它来生成帮助文档的。

Browsing through the online documentation, you’ll find a number of methods relevant to our adventure. The most important ones being `getmembers()`, `getdoc()` and `signature()`, as well as the many `is...`functions that serve as filters to `getmembers`. With these we can easily iterate through functions, including distinctions between generators and coroutines, and recurse into any classes and their internals as needed.

浏览在线文档时，你会发现有很多和我们的探索相关的函数，最重要的要数 `getmembers()`、`getdoc()` 和 `signature()` 还有许多用来给 `getmembers` 做筛选 `is...` 函数。通过这些函数，我们能够很容易地遍历函数，包括区分生成器和协程，并按需递归到任何类及其内部。

#### Importing the code

#### 引入代码

If we’re going to inspect an object, no matter what it is, the first thing to do is provide a mechanism with which to import it into our namespace. Why even talk about imports? Depending on what you want to do, there’s a number of items to worry about, including virtual environments, custom code, standard modules and reused names. Things can get confusing, and getting it wrong can lead to some frustrating moments trying to figure things out.

如果我们检视一个对象，无论什么对象，首先要做的就是提供将其引入命名空间的结构。为什么还要谈论引入呢？鉴于我们要做的事，有许多需要考虑的事，比如虚拟机环境、自定义代码、标准模块和重复命名。这真如一团乱麻，一招棋错满盘皆输。

We do have a few options here, the more complete one being a reuse of [`safeimport`](https://github.com/python/cpython/blob/master/Lib/pydoc.py#L318)() directly from `pydoc`, which takes care of a number of special cases for us and raises a pretty `ErrorDuringImport` exception when things break. However, it’s also possible to simply run `__import__(modulename)`ourselves if we have more control over our environment.

确实有一些内容供我们选择，比较完善的要数 `pydoc` 中 [`safeimport`](https://github.com/python/cpython/blob/master/Lib/pydoc.py#L318)() 的复用了，它可以为我们照管一些特殊的案例，并且在出问题的时候抛出一个 `ErrorDuringImport` 异常。但是，如果我们的环境更加可控的时候，也可以简单地运行 `__import__(modulename)`。

Another item to keep in mind is the path from which code executes. There may be a need to `sys.path.append()` a directory in order to access the module we’re looking for. My use case is to execute from the command line and within a directory that’s in the path of the module being examined, so I added the current directory to sys.path, which was enough to take care of the typical import path issues.

另一个需要铭记于心的就是代码的执行路径。或许会需要 `sys.path.append()` 一个目录来获取我们需要的模块。我是在被检查模块的路径中的一个目录内用命令行的方式执行的，所以我将当前目录添加到了系统路径中，这样就能够解决典型的引入路径问题。

Keeping this in mind, our import function would look something like this:

要谨记，我们的引入函数要这样写：

    def generatedocs(module):
        try:
            sys.path.append(os.getcwd())
            # Attempt import
            mod = safeimport(module)
            if mod is None:
               print("Module not found")

            # 模块已被正确引入，我们来创建文档吧
            return getmarkdown(mod)
        except ErrorDuringImport as e:
            print("Error while trying to import " + module)

#### Deciding on the output

#### 确定输出内容

Before continuing on, you’ll want to have a mental picture of how to organize the markdown output being generated. Do you want a shallow reference that does not recurse into custom classes? Which methods do we want to include? What about built-ins? Or `_` and `__` methods? How should we present function signatures? Should we pull annotations?

此时，你将会在脑海中构建一个如何组织生成的 markdown 内容的蓝图。你想得到一个非递归至自定义类内部的浅述内容吗？我们要对哪些方法生成描述文档呢？内置的内容还要生成说明吗？或者 `_` 和 `__` 方法（即非公有方法和魔术方法）？我们要如何表述函数签名？我们要获取注释吗？

My choices were as follows:

我的选择如下：

*   One `.md` file per run with information generated from recursing into any child classes of the object being inspecting.
*   Only include custom code that I’ve created, nothing from imported modules.
*   The output must be identified with 2nd level markdown headers (`##`) per item.
*   All headers must include the full path of the item being described (`module.class.subclass.function`)
*   Include the full function signature as pre-formatted text.
*   Provide anchors for each header to easily link into the docs, as well as within the docs themselves.
*   Any function that starts with `_` or `__` is not intended to be documented.

* 每次运行都生成一个包含递归至被检视对象的各种子类内部的信息的 `.md` 文件
* 只对我创建的自定义代码生成说明，对引入的模块不做处理
* 输出的每个部分都必须使用 mrakdown 的二级标题（`##`）标记
* 所有的标题都必须包含当前描述项目的完整路径（`模块.类.子类.方法`）
* 将完整的函数签名作为预定义格式的文本
* 为每个标题提供一个锚点，方便快速链接到文档（文档内也是如此）
* 任何以 `_` 或者 `__` 开始的函数都不生成文档

#### Putting it all together

#### 整合文档

Once the object is imported, we can get to work inspecting it. It’s simply a matter of performing repeated calls to `getmembers(object, filter)` where the filter is one of the helper `is` functions. You’ll be able to get pretty far with `isclass` and `isfunction`, but the other relevant ones will be `ismethod`, `isgenerator` and `iscoroutine`. It all depends on whether you want to write something generic that can handle all the special cases, or something smaller and more specific the source code. I stuck with the first two because I knew I didn’t have anything else to worry about and split things into three methods to create the formatting I wanted for modules, classes and functions.

引入对象之后，我们就能开始检视它了，只需很简单地反复调用 `getmembers(对象, 筛选)` 方法，“筛选”即为某个 `is` 方法。你不光能使用 `isclass` 和 `isfunction` 方法，还有其他的诸如 `ismethod`，`isgenerator` 和 `iscoroutine` 方法。这完全取决于你是想写一些能够处理所有特殊情况的泛型，还是一些更细致更具有特点的源码。因为没有什么后顾之忧，所以我一直使用前两个方法，并且兵分三路来分别创建模块、类和方法的文档格式。

    def getmarkdown(module):
        output = [ module_header ]
        output.extend(getfunctions(module)
        output.append("***\n")
        output.extend(getclasses(module))
        return "".join(output)
    def getclasses(item):
        output = list()
        for cl in inspect.getmembers(item, inspect.isclass):
            if cl[0] != "__class__" and not cl[0].startswith("_"):
                # Consider anything that starts with _ private
                # and don't document it
                output.append( class_header )
                output.append(cl[0])   
                # Get the docstring
                output.append(inspect.getdoc(cl[1])
                # Get the functions
                output.extend(getfunctions(cl[1]))
                # Recurse into any subclasses
                output.extend(getclasses(cl[1])
        return output
    def getfunctions(item):
        for func in inspect.getmembers(item, inspect.isfunction):
            output.append( function_header )
            output.append(func[0])
            # Get the signature
            output.append("\n```python\n)
            output.append(func[0])
            output.append(str(inspect.signature(func[1]))
            # Get the docstring
            output.append(inspect.getdoc(func[1])
        return output

When formatting a large body of text and interweaving with some programmatic code, I tend to prefer to stick it all as separate items in a list or tuple and `"".join()` the output to put it all together. At the time of this writing, it’s actually faster than `.format` and `%` based interpolation. However, the new string formatting coming with python 3.6 will be faster than this and more readable.

当格式化一大段夹杂着程序代码的文本的时候，我喜欢将其分为多个列表或者元组并且用 `"".join()` 来讲输出的内容组合到一起，这种写法实际上比插入 `.format` 和 `%` 快很多。然而，python 3.6 中新的字符串格式化方式比这种方法更快，更具可读性。

As you can see, `getmembers()` returns a tuple with the name of the object in the first position and the actual object in the second, which we can then use to recurse through the object hierarchy.

For each one of the items retrieved, it’s then possible to pull docstrings and comments with `getdoc()` or `getcomments()`. For every function we can use `signature()` to get a `Signature` object that represents its positional and keyword arguments, their default values and any annotations, providing us with the flexibility of generating fairly descriptive and well styled text that helps our users understand the intent of the code we’ve written.

#### Other considerations and unintended consequences

Please note that the code above is just sample code only meant to give you an idea of what the final product should look like. There are quite a few more considerations to keep in mind before finalizing things:

*   As is, `getfunctions` and `getclasses` will show **ALL** functions and classes imported in the module. This includes builtins, as well as anything from external packages, so you’ll have to filter that for-loop some more. I wound up using the `__file__` property of the module that contains whatever item I’m inspecting. In other words, if the item is defined in a module that exists within the path in which I’m executing, then include it (use `os.path.commonprefix()`)
*   There are some gotcha’s with file paths, import hierarchy and names. Like when you import moduleX into a package through __init__.py, you’ll be able to access its functions as package.moduleX.function, but the full name — the one returned by moduleX.__name__ — will be package.moduleX.moduleX.function. You may not care, but I did, so it’s something to keep in mind when iterating through things.
*   You’ll import classes from `builtins` and anything from there does not have `__file__`, so check for that if you put any filtering in place like described above.
*   Because this is markdown and because we’re simply importing docstrings, you can include markdown in your docstrings and it will appear in the page all nice and pretty. However, this means that you should take care to properly escape the docstring so it doesn’t break the HTML generated.

#### Sample output

I ran my generator over the `sofi` package — the `sofi.app` module to be precise — and here’s the markdown it created.

    # sofi
    
    ### [sofi](#sofi).\_\_init\_\_
    ```python
    __init__(self)
    ```
    
    ### [sofi](#sofi).addclass
    ```python
    addclass(self, selector, cl)
    ```
    Add the given class from all elements matching this selector.

Below is a sample of the final product (excluding function annotations) after running it through mkdocs to produce a readthedocs themed page.













![](https://cdn-images-1.medium.com/max/1000/1*y1cT7FhQpijK_wVhFuHNsw.png)















* * *







As I’m sure you already know, using these mechanisms for automatically generating documentation leads to complete, accurate and up-to-date information on your modules that’s easy to maintain and edit as you write the code, instead of after the fact. I strongly encourage everyone to give it a shot.

Before closing, I’d like to take a step back and mention that mkdocs is not the only documentation package out there. There are other well known and widely used systems like Sphinx (which mkdocs is based on) and Doxygen, both of which already do what we discussed here. However, as always, I wanted to go through the exercise in order to learn more about Python internals and the tools that come with it.





