> * 原文地址：[How to write your own Python documentation generator](https://medium.com/python-pandemonium/python-introspection-with-the-inspect-module-2c85d5aa5a48#.hcqq6xtl8)
* 原文作者：[Cristian Medina](https://medium.com/@tryexceptpass)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[王子建](https://github.com/Romeo0906)
* 校对者：[Zheaoli](https://github.com/Zheaoli)、[Zhiwei Yu](https://github.com/Zhiw)

# 来写一个 Python 说明文档生成器吧

我一开始学习 Python 的时候，我最喜欢的一件事就是坐在编译器前，使用内置的 `help` 函数检查类和方法，然后决定我接下来要怎么写。这个函数会引入一个对象并检查其内部成员，生成说明并且输出类似帮助文档的内容，帮助你了解该对象的使用方法。

将 `help` 函数置入标准库最为美妙的一点就是它能直接从代码中输出说明内容，这也间接地助长了一些人的懒惰，比如像我这种不愿意多花时间来维护文档的人。尤其是你已经为你的变量和函数起好了直白的名字，`help` 函数能够给你的函数和类添加说明，也能够通过下划线前缀正确地识别私有和受保护的成员。

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


在 Python 编译器中使用 `help(list)` 会输出以上内容

实际上，help 函数使用了 `pydoc` 模块来生成输出的内容，该模块也可以在命令行中运行生成任何引入模块的 .txt 或者 .html 格式的说明文档。

* * *

不久前，我需要写一些更加详细、正式的设计文档，作为 Markdown 的忠实拥趸，我决定去看看 [`mkdocs`](http://www.mkdocs.org/) 能否给我提供有效内容。这个模块能够很容易地将你的 markdown 文本转换成风格精美的网页，并且在你正式发布之前都可以做出修改。它提供了一个 [readthedocs](https://readthedocs.org/) 模板，还提供了一个简单的命令行界面，方便你将内容推到 [GitHub Pages](https://pages.github.com/) 上。

完成最初的一些设计需求文档之后，我想给自己开发和现行的面向其他模块的接口添加细节描述。因为我已经给大多数的方法都写了定义，所以我想从源文件中自动生成引用页面，并且想使用 markdown 格式以便日后我可以和其他文件一起用 mkdocs 渲染成 html 文档。

然而，项目中并没有默认使用 mkdocs 从源文件中生成 markdown 文件的方法，但是有插件可以做到。经过一阵子搜索和研究之后，我对网上找到的项目和插件感到很失望——许多都已经过时了，没有人维护，或者根本不能输出我想要的内容——所以我决定自己写。学习使用 inspect 模块是一件非常有趣的事情，之前我构建调试器的时候尝试过使用这个模块，具体可以参考这篇文章：[Hacking together a Simple Graphical Python Debugger](https://medium.com/@tryexceptpass/hacking-together-a-simple-graphical-python-debugger-efe7e6b1f9a8#.jqe3no3k9)）。

> “Inspect 模块提供了一些非常有用的方法来获取当前的对象的信息……”——[Python 文档](https://docs.python.org/3.6/library/inspect.html)

#### 来检查吧！

Inspect 是标准库中的模块，它不仅能够让检视低级别的 python `frame` 和 `code` 对象，还提供了许多方法来检查模块和类，能够帮助你找到可能感兴趣的内容。正如上文所言， pydoc 正是用它来生成帮助文档的。

浏览在线文档时，你会发现有很多相关的函数，最重要的要数 `getmembers()`、`getdoc()` 和 `signature()`，还有许多用来给 `getmembers` 做筛选 `is...` 函数。通过这些函数，我们能够很容易地遍历函数，包括区分生成器和协程，并按需递归到任何类及其内部。

#### 引入代码

如果我们检视一个对象，无论什么对象，首先要做的就是提供将其引入命名空间的结构。为什么还要谈论引入呢？鉴于我们要做的事，有许多需要考虑的事，比如虚拟环境、自定义代码、标准模块和重复命名。这真如一团乱麻，一招棋错满盘皆输。

确实有一些内容供我们选择，比较完善的要数 `pydoc` 中 [`safeimport`](https://github.com/python/cpython/blob/master/Lib/pydoc.py#L318)() 的复用了，它可以为我们照管一些特殊的案例，并且在出问题的时候抛出一个 `ErrorDuringImport` 异常。但是，如果我们的环境更加可控的时候，也可以简单地运行 `__import__(modulename)`。

另一个需要铭记于心的就是代码的执行路径。或许会需要 `sys.path.append()` 一个目录来获取我们需要的模块。我是在被检查模块的路径中的一个目录内用命令行的方式执行的，所以我将当前目录添加到了系统路径中，这样就能够解决典型的引入路径问题。

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

#### 确定输出内容

此时，你将会在脑海中构建一个如何组织生成的 markdown 内容的蓝图。你想得到一个非递归至自定义类内部的浅述内容吗？我们要对哪些方法生成描述文档呢？内置的内容还要生成说明吗？或者 `_` 和 `__` 方法（即非公有方法和魔术方法）？我们要如何表述函数签名？我们要获取注释吗？

我的选择如下：

* 每次运行都生成一个包含递归至被检视对象的各种子类内部的信息的 `.md` 文件
* 只对我创建的自定义代码生成说明，对引入的模块不做处理
* 输出的每个部分都必须使用 mrakdown 的二级标题（`##`）标记
* 所有的标题都必须包含当前描述项目的完整路径（`模块.类.子类.方法`）
* 将完整的函数签名作为预定义格式的文本
* 为每个标题提供一个锚点，方便快速链接到文档（文档内也是如此）
* 任何以 `_` 或者 `__` 开始的函数都不生成文档

#### 整合文档

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

当格式化一大段夹杂着程序代码的文本的时候，我喜欢将其分为多个列表或者元组并且用 `"".join()` 来将输出的内容组合到一起，这种写法实际上比添写 `.format` 和 `%` 快很多。然而，python 3.6 中新的字符串格式化方式比这种方法更快，更具可读性。

如你所见，`getmembers()` 首先返回了对象名，然后返回了实际的对象，我们可以用它来递归整个对象结构。

我们可以用 `getdoc()` 或者 `getcomments()` 来获取每个检索内容的说明内容和注释。对函数来说，我们可以使用 `signature()` 获取描述其位置和关键字参数、默认值以及注释的 `Signature` 对象，并灵活生成极具描述性和风格良好的文本来帮助用户了解我们编码的意图。

#### 未雨绸缪和以防万一

要注意上文中的代码仅仅是为了让你对结果有个直观的认识，在大功告成之前，你还要对以下问题加以深思熟虑：

*  如上所示，`getfunctions` 和 `getclasses` 会展示模块中引入的**所有**函数和类，包含内置和扩展包中的内容，因此你需要在 for 循环中进一步筛选。最后，我使用了当前检视内容所在模块的 `__file__` 属性，换句话说，如果所检视路径中存在某个模块，而模块中定义了所检视内容，然后我们可以使用 `os.path.commonprefix()` 将其引入。

*   在文件路径、引入结构和命名方面还存在一些疑难杂症，比如当你通过 __init__.py 将模块 X 引入一个代码包的时候，你将能通过 package.moduleX.function 的方式获取它的函数，但是通过 moduleX.__name__ 返回的完整的名字却是 package.moduleX.moduleX.function，在迭代内容的时候需要时刻牢记。

*   你也会从 `builtins` 中引入类，但是内置的模块没有 `__file__` 属性，所以当你在添加筛选时要记得检查哦。

*   因为是 markdown 语法并且我们只是简单的引入说明内容，所以你可以在说明文档中引入 markdown 语法的内容，它也能很精美地显示在页面中。然而，这意味着你要正确操作，避免文档说明影响 HTML 的生成。

#### 采样输出

我在 `sofi` 代码包上运行生成器——准确来说是 `sofi.app` 模块——以下是生成的 markdown 文件的内容。

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

下面是在 mkdocs 下生成的一个 readthedocs 主题的样本内容（不包含函数注释）：

![](https://cdn-images-1.medium.com/max/1000/1*y1cT7FhQpijK_wVhFuHNsw.png)

* * *

我相信你肯定已经明白，使用这些机制自动生成的文档能提供完整、准确、最新的模块信息，这使得模块在编程过程中易于维护和编辑，而并非是事后诸葛。（即并非在事后已经不需要的时候才总结出一份与模块相符的文档，原文为 instead of after the fact ，译者注）。我强烈建议每个人都试一试。

本文结束之前，我想回顾一下并说明 makdocs 并不是唯一的文档包，还有很多著名且应用广泛的文档包，比如 Sphinx（mkdocs 既是基于此）和 Doxygen，两者都可以实现我们今天谈论的内容。然而，我一如既往义无反顾地这样做，就是为了能够深入了解 Python 和它所自带的工具。