> * 原文地址：[How to package and deploy CLI applications with Python PyPA setuptools build](https://pybit.es/articles/how-to-package-and-deploy-cli-apps/)
> * 原文作者：[yaythomas](https://pybit.es/author/thomasgaigher/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2022/how-to-package-and-deploy-cli-apps.md](https://github.com/xitu/gold-miner/blob/master/article/2022/how-to-package-and-deploy-cli-apps.md)
> * 译者：[haiyang-tju](https://github.com/haiyang-tju)
> * 校对者：[DylanXie123](https://github.com/DylanXie123)、[earthaYan](https://github.com/earthaYan)

# 如何使用 Python 中的 PyPA setuptools 打包和部署 CLI 应用程序

本文介绍了如何仅使用官方提供的 [PyPA](https://www.pypa.io) 工具将 Python 代码打包为 CLI 应用程序，而无需安装额外的外部依赖项。

如果比起文字你更喜欢阅读代码，那么你可以在此处找到本文中讨论的完整示例演示代码：[使用 PyPA setuptools 打包的 Python CLI 示例代码库](https://github.com/yaythomas/python-cli-pypa-build-example)

## 从命令行运行 Python 代码

### 运行 Python 文件脚本

Python 是一种脚本语言，所以可以使用 Python 解释器轻松地从 CLI 来运行 Python 代码，如下所示：

```python
# 以脚本形式运行 python 源码文件
$ python mycode.py

# 运行 python 模块
$ python -m mycode
```

### 创建 CLI 快捷方式来引导 Python 应用程序

如果你想要将 Python 脚本作为具有用户友好名称的 CLI 应用程序来运行，并且不必在其前面输入 Python 解释器和路径，可以在 `/bin` 目录中创建一个可执行的快捷方式文件，如下所示：

```bash
#!/bin/sh

python3 /path/to/mycode.py "$@"
```

💡 `"$@"` 表示所有的 CLI 参数都从快捷方式启动器传递到 Python 脚本中。

但当真正想要分发部署代码时，这种方式并不是那么有用，因为除了要配置实际的 Python 依赖项和应用程序之外，还必须以某种方式在所有终端用户的机器上创建和授权这个可执行文件。

值得庆幸的是，Python 有很好的经过充分测试和广泛使用的内置机制来做这件事 —— 所以你根本不需要使用快捷方式这种临时措施！

## 如何以正确的方式将 Python 代码打包为 CLI 应用程序

打包 Python 代码的标准方法是使用 [setuptools](https://setuptools.readthedocs.io/)。你可以使用 **setuptools** 来创建一个使用 [pip](https://pip.pypa.io/) 来安装的发行版程序。

**setuptools** 已经存在很长时间了，目前（2021 年 8 月）正处于过渡阶段。这种情况已经持续了几年。这意味着使用此工具集时，有不同的方法可以实现相同的目标，因为新的和改进的方法正在慢慢取代旧的方法：

* **setup.py** – 旧方法
* **setup.cfg** – 较新的方法
* **pyproject.toml** （又称 PEP 517 和 PEP 518）– 闪亮的，新的

创建 CLI 应用程序的关键是在 **setup.cfg** 或 **setup.py** 文件中指定一个入口点（[entry_point](https://setuptools.readthedocs.io/en/latest/userguide/entry_point.html)）。

**pyproject.toml** 规范确实定义了这么一个属性（即 `[project.scripts]`），但是标准的 PyPA 构建事实上还没有实现使用这个属性做任何事情。

## 应该使用 setup.cfg、setup.py 还是 pyproject.toml 来配置 Python 的包管理？

简单来讲，目前，你可能应该同时会使用这三种方案。

更详细来说，你**不一定**必须同时会用这三种方案，但如果你没有，你需要确定你确切地知道你在做什么以及为什么这么做，否则你将会遇到莫名其妙的错误。如果你对这些机制的演变和背景不感兴趣，请随时跳转到下一节。

### 入门方案是 setup.py

**setup.py** 是打包 Python 项目的较旧的传统方式。由于 **setup.py** 本身就是一个 Python 脚本，因此它非常强大，因为你可以用它来编写安装过程中的任何想要的高级功能。

但仅仅因为你**可以**，并不意味着你应该这样做。作为安装的一部分，所执行的脚本越不寻常，那么在不同的客户端机器上的安装过程就会变得越脆弱和不可预测，而这些机器的状态和配置却是没必要严格控制的。

### 接着演变为 setup.cfg 的方案

相比之下，**setup.cfg** 是一个配置文件，而 **setup.py** 是一个安装脚本。**setup.cfg** 是静态的，**setup.py** 是动态的。

**setup.cfg** 允许指定声明性配置 —— 这意味着可以定义项目元数据而不必担心编写脚本。这是一件好事，可以避免在安装过程中运行任意代码，这将使安全和运维团队感到高兴，并且也不必在源代码中维护模板代码。这多么令人高兴啊！

尽管从一开始它就与 **setup.py** 是并列的，但 **setup.cfg** 多年来发挥了更多的核心作用。你可以或多或少地使用其中任何一种来完成同样的事情，所以从这个角度来看，使用哪一种并不重要。

但是，即使你在 **setup.cfg** 中进行了所有配置，仍然需要一个残留的 **setup.py** 文件，除非使用 PEP517 规范来构建。我们将在下一节来讨论这个新的构建系统。

### 然后是 pyproject.toml 的方案

**pyproject.toml** 是 **setup.py** 和 **setup.cfg** 的官方指定继任者，但它还尚未达到与其前辈相同的功能。这种新的文件格式是 [PEP517](https://www.python.org/dev/peps/pep-0517/) 构建规范获得的结果。

PEP517 中指定的新 Python 构建机制的一个显着特征是不用**必须**使用 **setuptools** 构建系统 —— 而其它的构建和打包工具，比如 [Poetry](https://python-poetry.org) 和 [Flit](https://flit.readthedocs.io/) 也可以使用相同的 **pyproject.toml** 规范文件（PEP621）来打包 python 项目。

最终，所有这些工具都应该使用完全相同的 **pyproject.toml** 文件格式，但请注意，除了 **setuptools** 以外的历史构建工具都有自己的方式来指定 CLI 的入口点，因此，请务必检查最终使用的任何工具的文档，以再次检查其是否符合最新的 PEP621 标准。在这里，我们将只关注如何使用 **setuptools** 来做到这一点。

虽然最新版本的 **pyproject.toml** 规范也添加了通常会在 **setup.cfg** 和/或 **setup.py** 中常见的项目元数据的定义，但 **setuptools** 构建工具还不支持使用来自于 **pyproject.toml** 的元数据。其它符合 PEP517 规范的工具（例如 Flit 和 Poetry）确实支持**仅**具有 **pyproject.toml** 文件的项目，因此如果使用这些工具时是不需要 **setup.py** 和/或 **setup.cfg** 的。

你可以在 [PEP621](https://www.python.org/dev/peps/pep-0621/) 中找到完整的 pyproject.toml 的文件格式规范。

有关在 **setuptools** 中实现对 **pyproject.toml** 的元数据的全面支持的种种细节和进展，你可以在这里进行跟踪讨论：[https://github.com/pypa/setuptools/issues/1688](https://github.com/pypa/setuptools/issues/1688)

### 2021 年推荐的 Python 打包设置

如果你在这个过渡阶段使用 Python 的打包工具 PyPA **setuptools**，虽然可以使用 **setup.py**、**setup.cfg** 和 **pyproject.toml** 中的一种或多种的组合来指定元数据以及构建属性，但你也需要考虑自己的技术基础并且通过以下三点来避免出现不易察觉的问题：

1. 使用一个最小的 **pyproject.toml** 来指定构建系统
2. 将所有的项目相关配置放入 **setup.cfg** 中
3. 设置一个简单的填充文件 **setup.py**

这里所说的“不易察觉的问题”是指不一致的问题，例如可编辑安装不起作用，亦或构建过程看起来正常但实际上并没有用到指定的元数据（这些可能只会在部署程序时出现，这太讨厌了！）。所以让我们避免出现这些不愉快的事情！

在这里的设置中，由于 **pyproject.toml** 和 **setup.py** 只是一个极简的填充式文件，你的个人项目相关配置仅会包含在 **setup.cfg** 中。因此，无需在不同文件之间复制数据。

## 为 Python 项目创建 CLI 入口点配置

### 示例项目结构

让我们来看一个简单的 CLI 应用程序示例。

项目结构如下所示：

```
.
│ my-repo/
	│- mypackage/
		│- mymodule.py
	│- pyproject.toml
	│- setup.cfg
	│- setup.py
```

### mypackage/mymodule.py 文件

这些是我们想直接从 CLI 调用的任意代码：

```python
def my_function():
    print('hello from my_function')


def another_function():
    print('hello from another_function')


if __name__ == "__main__":
    """执行 '$ python3 mypackage/mymodule.py' 时运行"""
    my_function()
```

### setup.py 文件

允许可编辑安装（对本地开发机器有用），需要一个填充 **setup.py** 文件。

在这个文件中只需要这个模板文件：

```python
from setuptools import setup

setup()
```

💡 实际上你可以跳过 **setup.cfg** 文件并在 **setup.py** 文件中的 `setup()` 函数中自行设置相关属性，但是当新的 PEP517 构建系统全面运行时，这将使迁移更加困难。我之所以提到这一点，是因为你会在 [Stack Overflow](https://stackoverflow.com) 上或者从朋友那里看到很多这样的例子 —— 这本身并没有错，但请注意，这是比较老旧的解决方案。

老旧的 **setup.py** 文件看起来像这样：

```python
from setuptools import setup

setup(
	name='mypackage',
	version='0.0.1',
    # To provide executable scripts, use entry points in preference to the
    # "scripts" keyword. Entry points provide cross-platform support and allow
    # pip to create the appropriate form of executable for the target platform.
    entry_points={
        'console_scripts': [
            'myapplication=mypackage.mymodule:my_function'
        ]
    },
)
```

### setup.cfg 文件

**setup.cfg** 文件真正神奇的地方是设置项目的特定属性。

```
[metadata]
name = mypackage
version = 0.0.1

[options]
packages = mypackage

[options.entry_points]
console_scripts =
    my-application = mypackage.mymodule:my_function
    another-application = mypackage.mymodule:another_function
```

* **name（名称）**
    * 构建系统使用它来生成构建输出文件。
    * 如果不指定，输出文件名将为 “UNKNOWN”，而不是一个更用户友好的名字。
* **version（版本）**
    * 构建系统使用它将版本号添加到输出文件中。
    * 如果不指定，输出文件的版本号将为 “0.0.0”。
* **packages（包名）**
    * 使用这个属性来告诉构建系统要构建哪些包。
    * 这是一个列表，因此可以指定多个包。
    * 如果不确定 Python 中的“包”是什么，可以将其视为代码所在目录的名称。
    * ❗如果不指定，构建输出实际上不会包含你的代码。如果你忘记指定这一点，你的程序包的生成和部署看起来是正常的，但实际上并不会打包要运行的代码，也不会真正正确地部署。
* **console_scripts（控制台脚本）**
    * 这个属性告诉构建系统创建一个快捷方式 CLI 包装脚本用来运行 Python 函数。
    * 它是一个列表，因此你可以从同一个代码库创建多个 CLI 应用程序。
    * 在本例中，我们创建了两个 CLI 快捷方式：
        * **my-application**, 它调用 **mypackage/mymodule.py** 中的 **my_function**。
        * **another-application**, 它调用 **mypackage/mymodule.py** 中的 **another_function**。
    * 条目的语法是：**<name> = \[\<package\>.\[\<subpackage\>.\]\]\<module\>\[:\<object\>.\<object\>\]**。
    * 左侧的名称将成为 CLI 应用程序的名称。由最终用户在 CLI 中输入以调用你的应用程序的内容。
    * 如果不指定此属性，构建将不会为你的代码创建任何 CLI 快捷方式。
    * ❗请记住，必须在下面包含你在这里引用的代码的根包 `options.packages`，否则构建工具实际上不会打包你在此处引用的代码！

你可以（也许应该这么做！）在 **setup.cfg** 中指定更多元数据属性 —— 这里是一个[更全面的 setup.cfg 示例](https://setuptools.readthedocs.io/en/latest/userguide/declarative_config.html)。而这里给出的是一个简单的最低要求的构建和打包过程。

💡 在其它未列出的属性中，特别让人感兴趣的是 **install_requires**，你可以使用它指定依赖项 —— 换句话说，你可以指定代码中所依赖的任何外部包，并且可以跟随安装程序一并安装。

```
[options]
install_requires =
    requests
    importlib; python_version == "2.6"
```

### pyproject.toml 文件

最简单的 **pyproject.toml** 文件，只需要：

```
[build-system]
build-backend = "setuptools.build_meta"
requires = ["setuptools", "wheel"]
```

💡 在 **pyproject.toml** 语法规范中，`project.scripts` 与 **setup.py** 和 **setup.cfg** 中的 `console_scripts` 是等价的。但是，目前 **setuptools** 构建系统中还尚未实现此功能。

## 使用 python -m build 来创建 python 发行版程序

**build**，也就是 PyPA build，在更先进的 PEP517 规范中等价于你可能更熟悉的旧的构建命令 `setup.py sdist bdist_wheel`。

如果你以前没有这样做过，那么你可以像这样来安装构建工具：

```bash
$ pip install build
```

现在，在项目根目录中，可以运行命令：

```bash
$ python -m build
```

这样就会在 `dist` 目录中生成两个文件：

* dist/mypackage-0.0.1.tar.gz
* dist/mypackage-0.0.1-py3-none-any.whl

如果 **./dist** 目录尚不存在，该工具将为自动创建。

此命令的作用是创建一个源码分发压缩包（**tar.gz** 文件），然后还会从分发的源码创建一个 wheel 文件。wheel (**.whl**) 文件是一种版本化的分发格式，因为在安装期间可以跳过源代码分发所需的构建步骤，所以部署速度更快，并且还有更好的缓存机制。

在这里看到的输出文件名是遵循了 [PEP427 wheel 文件名约定](https://www.python.org/dev/peps/pep-0427/#file-name-convention)中指定的定义格式。

你会注意到构建工具 **setup.cfg** 中使用 **name** 和 **version** 来生成这些文件名 —— 这就是为什么，即使严格来说**不需要**指定这些属性，但它们对于输出一个命名规范且容易识别的文件也是很有用的。

## 用 pip 安装 wheel 文件

可以使用 [pip](https://pip.pypa.io/) 来安装刚刚创建的发行版程序。（我相信对于 python 使用者来讲， pip 就不需要任何介绍了……）

```bash
$ pip install dist/mypackage-0.0.1-py3-none-any.whl
```

### 如何使用 PyPA build 来创建 CLI 快捷方式

pip install 命令将安装 python 程序包并在当前的 Python 环境目录 `bin` 中创建 CLI 快捷方式（在 **setup.cfg** 中指定的）。

* {Python Path}/bin/my-application
* {Python Path}/bin/another-application

根本上来讲，这些快捷方式文件实际上只是我们在文章开头的地方创建的快速而肮脏的 bash 文件的一个更复杂的版本。`bin/` 目录中自动生成的 **my-application** 快捷方式文件如下所示：

```python
#!/bin/python3
# -*- coding: utf-8 -*-
import re
import sys
from mypackage.mymodule import my_function
if __name__ == '__main__':
    sys.argv[0] = re.sub(r'(-script\.pyw|\.exe)?$', '', sys.argv[0])
    sys.exit(my_function())
```

### 在干净的环境中测试安装

💡 如果想要测试新软件包的安装是否可用，可以创建一个全新的虚拟环境并将软件包安装到其中，以便进行单独测试。

```bash
# 创建虚拟环境
$ python3 -m venv .env/fresh-install-test

# 激活虚拟环境
$ . .env/fresh-install-test/bin/activate

# 将程序包安装到全新的虚拟环境中
$ pip install dist/mypackage-0.0.0-py3-none-any.whl

# 程序的快捷方式已经安装到虚拟环境的 bin 目录下
$ ls .env/fresh-install-test/bin/
my-application
another-application

# 所以你可以从命令行执行了
$ my-application
hello from my_function

# 也可以测试运行第二个程序
$ another-application
hello from another_function
```

## Python 包的发布和分发

发布是**如何**让 Python 程序包对终端用户可用的过程。

发布程序包的方式取决于你自己的针对特定要求的部署计划。完整的讨论超出了本文的范畴，对于入门学习，下面有一些选择项：

* 发布私有 git 仓库并[使用 pip 从私有 git 仓库进行安装](https://pip.pypa.io/en/stable/topics/vcs-support/)。
* 创建[私有 Python 仓库管理器](https://packaging.python.org/guides/hosting-your-own-index/)。
* 仅使用 **pip** 从你自己的组织分享的 **whl** 或者 **sdist** 文件来安装程序包。
* 如果你计划将自己的应用程序公开发布到官方 [PyPI](https://pypi.org) 存储库，可以使用 [twine](https://twine.readthedocs.io/) 将分发上传到 PyPi。
* 请注意，如果你打算创建一个公共程序包，那么在填写项目的元数据时，你应该填写的比本文给出的故意简化的最小示例程序更详细。
* 虽然 **pip** 会将程序包安装到处于激活状态的任何的 Python 环境，但是你却无法控制终端用户的机器环境，这可能会导致混乱 —— 例如，共享依赖项可能与其它应用程序的要求发生冲突。
* 如果你想要将应用程序安装到一个隔离的环境中，特意将应用程序与其依赖项分开，并且不污染主要系统的 Python 安装环境，可以使用 [pipx](https://pypa.github.io/pipx) 从 git 仓库进行安装（例如你自己组织中的私人仓库），或者是只从一个文件路径进行安装。
* 你也可以通过邮件将 wheels 文件作为附件发送出去，并告诉别人进行安装。开个玩笑，开个玩笑！不要这样做 —— 因为这样可能会正常安装但实际上却并没有安装**正确**……

## 如何构建一个 Python CLI 项目

清楚起见，下面的例子只是直接从 CLI 调用一个简单的 Python 函数。你自己的代码很可能涉及到更多的东西。

在不同的应用程序中如何最好地构建代码是非常值得商榷的主题😬。因此，与其大胆宣称什么是“最好的”，不如让我们看看典型的简洁结构是什么样子的……也就是说，虽然这是一种相对常见的方式，但不一定是最好的方式。

```
.
│ my-repo/
  │- mypackage/
    │- mynamespace/
      │- anothermodule.py
    │- anothernamespace/
      │- arbmodule.py
    │- mymodule.py
    │- cli.py
    │- pyproject.toml
    │- setup.cfg
    │- setup.py
```

如果在 **cli.py** 文件中创建入口点函数 `def main()`，那么 **setup.cfg** 文件的 **entry_points** 配置将会很简单：

```
[options.entry_points]
console_scripts =
    my-application = mypackage.cli:main
```

可以将你自己的功能代码视为一个库，而 CLI 实际上是该库的客户端或使用者。将代码分解为有意义的命名空间和模块 —— 你可以按照功能区域、依赖项、对象或任何适合你的分类方案将代码组合在一起。

如果你将 CLI 看做是库 API 的使用者，那么将特定于 CLI 处理的代码封装到单独的模块中是有意义的。你可以使用任意的名字来命名该模块，但使用 **cli.py** 这个名字会有很多的好处。在模块中，你可以导入类似与 [argparse](https://docs.python.org/3/library/argparse.html) 的库来解析 CLI 的输入参数，当有错误的参数调用时，可以打印出相关的错误，可以分配默认值，可以生成帮助和使用信息。

这里有一个类似结构的大型项目真实示例，其中包含一个 [CLI 处理模块](https://github.com/pypyr/pypyr/blob/master/pypyr/cli.py)，该模块封装了所有 CLI 功能并像调用 API 一样来调用底层程序。

## Python 中的其它替代打包工具

在本文中，我们只关注使用“官方的”极简方式来打包和构建 Python 项目。但是还有一些其它第三方的工具可以选择，它们还提供了一些额外的功能，但这些都超出了 setuptools **构建**工具的常用功能范畴。

我们前面已经提到了符合 PEP517 规范的构建工具 **poetry** 和 **flit**。有了这些，就像标准的 PyPA **构建**过程一样，终端用户必须在机器上设置一个激活的的 Python 运行时。然后将代码安装到该 Python 环境中。

然而在创建应用程序及其 Python 依赖项的单个可执行文件时，其它的一些打包工具程序采用了完全不同的方法 —— 这些第三方的工具创建应用程序时生成了独立于平台的原生可执行文件。这意味着最终用户甚至不需要在他们的机器上安装 Python 发行版 —— 他们只需要运行可执行文件就好了。

该领域中的一些免费工具如下（排名不分先后）：

* [PyInstaller](https://www.pyinstaller.org)
* [p2exe](https://www.py2exe.org)
* [bbFreeze](https://github.com/schmir/bbfreeze) (无维护)
* [cx_Freeze](https://cx-freeze.readthedocs.io/)
* [Briefcase](https://beeware.org/project/projects/tools/briefcase/)
* [Nuitka](https://nuitka.net)
* [py2app](https://py2app.readthedocs.io/) (仅支持 Mac)
* [PyOxidizer](https://pyoxidizer.readthedocs.io)

以上工具中的每一个都有自己的方式来指定从 CLI 调用哪个函数，因此如果你确定选择该工具，请务必查看其文档。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
