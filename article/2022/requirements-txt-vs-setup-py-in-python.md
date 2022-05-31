> * 原文地址：[A Comparison of requirements.txt vs setup.py in Python](https://python.plainenglish.io/requirements-txt-vs-setup-py-in-python-325bca3939af)
> * 原文作者：[Muppala Sunny Chowdhary](https://medium.com/@muppalasunnychowdhary)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2022/requirements-txt-vs-setup-py-in-python.md](https://github.com/xitu/gold-miner/blob/master/article/2022/requirements-txt-vs-setup-py-in-python.md)
> * 译者：[WangNing](https://github.com/w1187501630)
> * 校对者：[DylanXie123](https://github.com/DylanXie123)、[FYJNEVERFOLLOWS](https://github.com/FYJNEVERFOLLOWS)

# Python 中 requirements.txt 与 setup.py 的对比 

![Photo by [Eugen Str](https://unsplash.com/@eugen1980?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) on [Unsplash](https://unsplash.com/s/photos/tool?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)](https://cdn-images-1.medium.com/max/2800/0*hYTVmma-P6S3t51L.jpeg)

## 前言

对于刚接触 Python 的人来说，管理 Python 项目中的依赖项可能是非常具有挑战性的。当你开发一个新的 Python 包时，你可以使用到一些其他软件包来帮助你（在更少的时间内）编写更少的代码，这样就不用重复的造轮子。除此之外，你的 Python 包也可能会在未来的项目中被作为一个依赖项来使用。

在本文中，我们将讨论如何正确管理 Python 项目的依赖关系。更具体的说，我们将讨论 `requirements.txt` 文件的用途以及如何使用 `setuptools` 来发布自定义的 Python 包，以让其他用户进一步使用和开发它。除此之外，我们还将讨论设置文件（即 `setup.cfg`  和 `setup.py`）的用途以及如何通过它们与 `requirements.txt` 文件让包的开发和重新发布更加容易。

## Python 项目的依赖关系是什么？

首先，让我们从包依赖开始我们的讨论; 包依赖到底是什么？为了让我们的 Python 项目更易维护，正确的使用包依赖为什么至关重要？

简单来说，依赖项是我们为了完成工作而在我们的 Python 项目中所依赖的外部 Python 包。在 Python 中，这些依赖通常可以在 Python 包索引（PyPI）或其他的管理工具中找到（例如 `Nexus`）。

例如，我们考虑开发一个使用 pandas DataFrames 的 Python 项目，那么 `pandas` 包就是该项目的依赖，如果我们没有预先安装 `pandas`，我们的项目将无法正常工作。

每一个依赖项本身就是一个 Python 包，它也可能有其他的依赖项。因此，为了避免在安装或者更新包时出现问题，依赖管理有时也会变得非常棘手或具有挑战性，需要我们妥善的进行处理。

我们自己的 Python 项目可能会对某个特定版本的第三方包有依赖。当项目中（至少）有两个依赖项同时依赖于另一个包，而且每一依赖项都需要该外部包的特定版本的情况下，可能会导致依赖冲突的出现。这些情况可以通过包管理工具（例如 `pip`）来处理（但并非都是如此！）。在这种情况下，通常我们需要告诉 `pip` 如何处理依赖关系以及我们需要哪些特定版本。

一般情况下，我们通过一个 `requirements.txt` 文本文件来指定我们项目的依赖包及其版本。

## requirements.txt 文件

`requirements.txt` 只是一个列出一个特定 Python 项目的所有依赖项的文件吗？如前所述，他还可以包含依赖项的依赖项。被列出来的依赖项可以是指定的或者非指定的。 如果使用指定版本，那么你可以运算符来限定特定包的版本范围（使用 == 和 >，<，或者都使用 ）。

**`requirements.txt` 文件示例**

```
matplotlib>=2.2
numpy>=1.15.0, <1.21.0
pandas
pytest==4.0.1
```

之后，可以使用以下命令通过 `pip` 安装这些依赖项（通常在虚拟环境中）:

```bash
pip install -r requirements.txt
```

在上面的 `requirements` 示例文件中，我们使用了不同的方式（例如>=，== 等）来限制定了 Python 依赖包的版本 。 例如，对于没有限定版本的 `pandas` 包，`pip` 通常会安装最新版本，除非其他依赖项之一与它有任何冲突（如果有冲突，`pip` 将安装满足其余依赖项指定条件的 `pandas` 版本）。再比如，对于 `pytest`，包管理器将安装特定的的版本（例如 `4.0.1`），而对于`matplotlib`，将安装至少大于或等于 2.2 的最新版本（这还是取决于是否有其他依赖项的具体要求，如果没有则会安装符合条件的最新版）。最后，对于 `numpy` 包，`pip` 将尝试安装 1.15.0（包含）和 1.21.0（不包含）之间的最新版本。

当你安装完所有的依赖之后，通过运行 `pip freeze`，你可以查看安装在虚拟环境中每个依赖项的确切版本。这个命令会列出所有的包及其指定版本（即`==`的关系）。

针对我们项目的开发，通常情况下，`requirements.txt` 非常有用。但如果你想将你代码发布（例如到 `PyPI`上）供他人广泛地使用，那么需要的不仅仅是这个文件。

## Python 中的 setuptools

[setuptools](https://setuptools.pypa.io/en/latest/) 是一个基于 `distutils` 构建的包，它允许开发者去开发和发布 Python 包。另外它还提供了使依赖管理更容易的功能。

当你想要发布一个包，你通常需要一些 **元数据**，包括包名称，版本，依赖项，入口点等。而 `setuptools` 提供了执行这些操作的功能。

项目元数据和可选项在 `setup.py` 文件中定义，如下所示：

```python
from setuptools import setup
setup(     
    name='mypackage',
    author='Giorgos Myrianthous',     
    version='0.1',     
    install_requires=[         
        'pandas',         
        'numpy',
        'matplotlib',
    ],
    # ... more options/metadata
)
```

事实上，这被认为是一个糟糕的设计，因为该文件是纯粹的声明性文件。因此，一个更好的方法是在名为 `setup.cfg` 的文件中定义这些可选项和元数据，然后在 `setup.py` 文件中简单地调用 setup() 即可。`setup.cfg` 示例文件如下所示：

```
[metadata]
name = mypackage
author = Giorgos Myrianthous
version = 0.1[options]
install_requires =
    pandas
    numpy
    matplotlib
```

最终，我们可以拥有一个最简单的 `setup.py` 文件，如下所示：

```python
from setuptools import setup
if __name__ == "__main__":
    setup()
```

注意，上面的 `install_requires` 参数可以是一个依赖项列表，以及他们的说明符（包括 `\<`, `>`, `\<=`, `>=`, `==` 和 `!=` 这些运算符）和版本标识符。除此之外，当项目安装时，不在环境中指定的依赖将会从  `PyPI` (默认情况下)下载并安装。

## 我们同时需要 requirements.txt 和 setup.py/setup.cfg 文件吗？

这需要分情况对待! 首先 `requirements.txt` 和 `setup.py` 不能完全一对一的比较，因为他们 **通常用于实现不同的需求**。

这是关于这个话题的常见误解，人们通常觉得他们只是从在这些文件中复制信息，因此他们选择其中的一种。但实际上并非如此。

首先，让我们了解通常在何时使用两个文件或仅使用两个文件中的一个。**作为一般经验法则**：

* 如果你的包主要用于开发目的，而且你不打算重新发布它，**`requirements.txt` 是足够的**（即使包是在多台机器上开发的）。
* 如果软件包仅由你自己开发（即是在单台机器上）但您打算重新发布它，那么 **`setup.py`/`setup.cfg`就足够了**。
* 如果你的包是在多台机器上开发的并且还需要重新发布它，那么将**同时需要 `requirements.txt` 和 `setup.py`/`setup.cfg` 文件**。

现在，如果你需要同时使用 `requirements.txt` 和 `setup.py`/`setup.cfg` （老实说几乎都是如此），那么你需要确保不会重复。

如果你同时使用这两种，你的 **`setup.py`（和/或者 `setup.cfg`）文件需要包含抽象依赖项列表，而`requirements.txt` 文件所包含的确切依赖项必须使用`==`来指定限制包版本**。

`install_requires`（例如 `setup.py`）定义了单个项目的依赖关系，而 [`requirements.txt`](https://pip.pypa.io/en/latest/user_guide/#requirements-files) 通常用于定义完整 Python 环境的依赖关系。

`install_requires` 要求很少，而 `requirements.txt` 通常需要包含详尽的固定版本列表，以实现完整环境的[可重复安装](https://pip.pypa.io/en/latest/user_guide/#repeatability)

- [Python 文档](https://packaging.python.org/en/latest/discussions/install-requires-vs-requirements/#requirements-files)

## 总结

在这篇文章中,我们介绍了在开发 Python 项目和应用程序时应用适当的依赖管理的重要性。也介绍了 `requirements.txt` 文件的用户和如何将它与 `setuptools`（例如 `setup.py` 和 `setup.cfg`）的设置文件一起使用，以确保其他开发者可以安装，运行，开发，甚至测试 Python 包的源代码。

正如强调的那样，`setuptools` 不完全是 `requirements.txt` 文件的替代品。在大多数情况下，你可能需要同时使用这两个文件，来正确的管理你的包依赖项，同时便于之后对他们进行重新发布。

如果你想知道如何发布你的 Python 包并使其在 PyPI 上可用，以便可以通过 `pip` 包管理器来安装它，请关注接下来的文章。

最后，在此感谢你的阅读。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
