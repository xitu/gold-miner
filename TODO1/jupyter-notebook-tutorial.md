> * 原文地址：[Jupyter Notebook for Beginners: A Tutorial](https://www.dataquest.io/blog/jupyter-notebook-tutorial/)
> * 原文作者：[dataquest](https://www.dataquest.io)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/jupyter-notebook-tutorial.md](https://github.com/xitu/gold-miner/blob/master/TODO1/jupyter-notebook-tutorial.md)
> * 译者：[SergeyChang](https://github.com/SergeyChang)
> * 校对者：[sunhaokk](https://github.com/sunhaokk)，[陆尘](https://github.com/sisibeloved)

# 给初学者的 Jupyter Notebook 教程

Jupyter Notebook 是一个非常强大的工具，常用于交互式地开发和展示数据科学项目。它将代码和它的输出集成到一个文档中，并且结合了可视的叙述性文本、数学方程和其他丰富的媒体。它直观的工作流促进了迭代和快速的开发，使得 notebook 在当代数据科学、分析和越来越多的科学研究中越来越受欢迎。最重要的是，作为[开源项目](https://jupyter.org/)的一部分，它们是完全免费的。

Jupyter 项目是早期 IPython Notebook 的继承者，它在 2010 年首次作为原型发布。尽管在 Jupyter Notebook 中可以使用许多不同的编程语言，但本文将重点介绍 Python，因为在 Jupyter Notebook 中 python 是最常见的。

为了充分理解本教程，你应该熟悉编程，特别是 Python 和 [pandas](https://pandas.pydata.org/)（译者注：Pandas 是python的一个数据分析包）。也就是说，如果你有编程经验，这篇文章中的 Python 不会太陌生，而 pandas 也是容易理解的。Jupyter Notebooks 也可以作为一个灵活的平台来运行 pandas 甚至是 Python，这将在这篇文章中体现。

我们将会：

* 介绍一些安装 Jupyter 和创建你的第一个 notebook 的基本知识。
* 深入钻研，学习所有重要的术语。
* 探索笔记是如何轻松地在网上共享和发布。事实上，这篇文章就是一个 Jupyter notebook！这里的一切都是在 Jupyter notebook 环境中编写的，而你正在以只读的形式查看它。

### Jupyter Notebook 数据分析实例

我们将通过一个样本分析，来回答一个真实的问题，这样你就可以看到一个 notebook 的工作流是如何使任务直观地完成的，当我们分享给其他人时也可以让其他人更好地理解。

假设你是一名数据分析师，你的任务是弄清楚美国最大公司的利润变化历史。你会发现自从 1955 年第一次发表这个名单以来，已有超过 50 年的财富 500 强企业的数据集，这些数据都是从[《财富》](http://archive.fortune.com/magazines/fortune/fortune500_archive/full/2005/)的公共档案中收集来的。我们已经创建了一个可用数据的 CSV 文件（你可以在[这里](https://www.dataquest.io/blog/large_files/fortune500.csv)获取它）。

正如我们将要演示的，Jupyter Notebooks 非常适合这项调查。首先，让我们安装 Jupyter。

## 安装

初学者开始使用 Jupyter Notebooks 的最简单方法是安装 [Anaconda](https://anaconda.org/)。Anaconda 是最广泛使用的用于数据科学的 Python 发行版，并且预装了所有常用的库和工具。除了 Jupyter 之外，Anaconda 中还封装了一些 Python 库，包括 [NumPy](http://www.numpy.org/)，[pandas](https://pandas.pydata.org/) 和 [Matplotlib](https://matplotlib.org/)，并且这[完整的1000+列表](https://docs.anaconda.com/anaconda/packages/pkg-docs)是详尽的。这使你可以在自己完备的数据科学研讨会中运行，而不需要管理无数的安装包或担心依赖项和特定操作系统的安装问题。

安装 Anaconda：

1. [下载](https://www.anaconda.com/download/)支持 Python 3 （就不用 Python 2.7 了）的最新版本 Anaconda。
2. 按照下载页面或可执行文件中的说明安装 Anaconda。

如果你是已经安装了 Python 的更高级的用户，并且更喜欢手动管理你的软件包，那么你可以使用pip:

```
pip3 install jupyter
```

## 创建你的第一个 Notebook

在本节中，我们将看到如何运行和保存 notebooks，熟悉它们的结构，并理解接口。我们将会熟悉一些核心术语，这些术语将引导你对如何使用 Jupyter notebooks 进行实际的理解，并为下一节做铺垫，该部分将通过示例数据分析，并将我们在这里学到的所有东西带到生活中。

### 运行 Jupyter

在 Windows 上，你可以通过将 Anaconda 快捷方式添加到你的开始菜单来运行 Jupyter，它将在你的默认网页浏览器中打开一个新的标签，看起来就像下面的截图一样。

![Jupyter control panel](https://www.dataquest.io/blog/content/images/2018/03/jupyter-dashboard.jpg)

这是 Notebook Dashboard，专门用于管理 Jupyter Notebooks。把它看作是探索，编辑和创建 notebooks 的启动面板。你可以把它看作是探索、编辑和创造你的 notebook 的发射台。

请注意，仪表板将只允许您访问 Jupyter 启动目录中包含的文件和子文件夹；但是，启动目录是[可以更改的](https://stackoverflow.com/q/35254852/604687)。还可以通过输入 `jupyter notebook` 命令在任何系统上启动指示板(或在Unix系统上的终端);在这种情况下，当前工作目录将是启动目录。

聪明的读者可能已经注意到，仪表板的 URL 类似于 `http://localhost:8888/tree`。Localhost 不是一个网站，而是表示从你的*本地*机器(你自己的计算机)中服务的内容。Jupyter notebook 和仪表板都是 web 应用程序，Jupyter 启动了一个本地的 Python 服务器，将这些应用程序提供给你的 web 浏览器，使其从根本上独立于平台，并打开了更容易在 web 上共享的大门。

仪表板的界面大部分是不言自明的 —— 尽管我们稍后会简要介绍它。我们还在等什么?浏览到你想要创建你的第一个 notebook 的文件夹，点击右上角的 `New` 下拉按钮，选择 `Python 3` (或者你喜欢的版本)。

![New notebook menu](https://www.dataquest.io/blog/content/images/2018/03/new-notebook-menu.jpg)

我们马上能看到成果了!你的第一个 Jupyter Notebook 将在新标签页打开 - 每个 notebook 使用它自己的标签，因为你可以同时打开多个 notebook。如果您切换回仪表板，您将看到新文件 `Untitled` 。你应该看到一些绿色的文字告诉 notebook 正在运行。

#### 什么是 ipynb 文件？

理解这个文件到底是什么是很有用的。每一个 `.ipynb` 文件是一个文本文件，它以一种名为 [JSON](https://en.wikipedia.org/wiki/JSON) 的格式描述你的 notebook 的内容。每个单元格及其内容，包括已被转换成文本字符串的图像附件，都与一些[元数据](https://ipython.org/ipython-doc/3/notebook/nbformat.html#metadata)一起列出。你可以自己编辑这个 -- 如果你知道你在做什么! -- 通过在 notebook 的菜单栏中选择 "Edit > Edit Notebook Metadata"。

你还可以通过在仪表板上的控件中选择 `Edit` 来查看你的 notebook 文件的内容，但是重要的是可以；除了好奇之外没有理由这样做，除非你真的知道你在做什么。

### notebook 的接口

既然你面前有一个打开的 notebook，它的界面就不会看起来完全陌生；毕竟，Jupyter 实际上只是一个高级的文字处理器。为什么不看一看？查看菜单以了解它，尤其是花点时间浏览命令选项板（这是带键盘图标的小按钮（或 `Ctrl + Shift + P`））下滚动命令列表。

![New Jupyter Notebook](https://www.dataquest.io/blog/content/images/2018/03/new-notebook.jpg)

您应该注意到两个非常重要的术语，这对您来说可能是全新的：*单元格*和*内核*。它们是理解 Jupyter 和区分 Jupyter 不只是一个文字处理器的关键。幸运的是，这些概念并不难理解。

* 内核是一个“计算引擎”，它执行一个 notebook 文档中包含的代码。
* 单元格是一个容器，用于装载在 notebook 中显示的文本或是会被 notebook 内核执行的代码。

### 单元格

稍后我们再讨论内核，在这之前我们先来了解一下单元格。单元格构成一个笔记本的主体。在上面一节的新建的 notebook 屏幕截图中，带有绿色轮廓的盒子是一个空的单元格。我们将介绍两种主要的单元格类型：

* **代码单元**包含要在内核中执行的代码，并在下面显示它的输出。
* **Markdown 单元**包含使用 Markdown 格式化的文本，并在运行时显示其输出。

新的 notebook 中的第一个单元总是一个代码单元。让我们用一个经典的 hello world 示例来测试它。输入 `print('Hello World!')` 到单元格中，点击上面工具栏中的 run 按钮，或者按下 Ctrl + Enter 键。结果应该是这样的：

```Python
print('Hello World!')
```

```
Hello World!
```

当你运行这个单元格时，它的输出将会显示在它的下面，而它左边的标签将会从 `In [ ]` 变为 `In [1]`。代码单元的输出也是文档的一部分，这就是为什么你可以在本文中看到它的原因。你总是可以区分代码和 Markdown 单元，因为代码单元格在左边有标签，而 Markdown 单元没有。标签的“In”部分仅仅是“输入”的缩写，而标签号表示在内核上执行单元格时的顺序 —— 在这种情况下，单元格被第一个执行。再次运行单元格，标签将更改为 `In[2]`，因为此时单元格是在内核上运行的第二个单元格。这让我们在接下来对内核的深入将非常有用。

从菜单栏中，单击*插入*并选择*在下方插入单元格*，创建你新的代码单元，并尝试下面的代码，看看会发生什么。你注意到有什么不同吗?

```Python
import time
time.sleep(3)
```

这个单元不产生任何输出，但执行需要 3 秒。请注意，Jupyter 将标签更改为 `In[*]` 来表示单元格当前正在运行。

一般来说，单元格的输出来自于单元执行过程中指定打印的任何文本数据，以及单元格中最后一行的值，无论是单独变量，函数调用还是其他内容。例如：

```Python
def say_hello(recipient):
    return 'Hello, {}!'.format(recipient)

say_hello('Tim')
```

```
'Hello, Tim!'
```

你会发现自己经常在自己的项目中使用它，以后我们会看到更多。

### 键盘快捷键

在运行单元格时，你可能经常看到它们的边框变成了蓝色，而在编辑的时候它是绿色的。总是有一个“活动”单元格突出显示其当前模式，绿色表示“编辑模式”，蓝色表示“命令模式”。

到目前为止，我们已经看到了如何使用 `Ctrl + Enter` 来运行单元格，但是还有很多。键盘快捷键是 Jupyter 环境中非常流行的一个方面，因为它们促进了快速的基于单元格的工作流。许多这些都是在命令模式下可以在活动单元上执行的操作。

下面，你会发现一些 Jupyter 的键盘快捷键列表。你可能不会马上熟悉它们，但是这份清单应该让你对这些快捷键有了了解。

* 在编辑和命令模式之间切换，分别使用 `Esc` 和 `Enter`。
* 在命令行模式下：
    * 用 `Up` 和 `Down` 键向上和向下滚动你的单元格。
    * 按 `A` 或 `B` 在活动单元上方或下方插入一个新单元。
    * `M` 将会将活动单元格转换为 Markdown 单元格。
    * `Y` 将激活的单元格设置为一个代码单元格。
    * `D + D `(按两次 `D`)将删除活动单元格。
    * `Z`将撤销单元格删除。
    * 按住 `Shift`，同时按 `Up` 或 `Down` ，一次选择多个单元格。
        * 选择了 multple，`Shift + M` 将合并你的选择。
* `Ctrl + Shift + -`，在编辑模式下，将在光标处拆分活动单元格。
* 你也可以在你的单元格的左边用 `Shift + Click` 来选择它们。

你可以在自己的 notebook 上试试这些。一旦你有了尝试，创建一个新的 Markdown 单元，我们将学习如何在我们的 notebook 中格式化文本。

### Markdown

[Markdown](https://www.markdownguide.org/) 是一种轻量级的、易于学习的标记语言，用于格式化纯文本。它的语法与 HTML 标记有一对一的对应关系，所以这里的一些经验是有用的，但绝对不是先决条件。请记住，这篇文章是在一个 Jupyter notebook 上写的，所以你所看到的所有的叙述文本和图片都是在 Markdown 完成的。让我们用一个简单的例子来介绍基础知识。

```markdown
# 这是一级标题。
## 这是一个二级标题。
这是一些构成段落的纯文本。
通过 **粗体** 和 __bold__ ，或 *斜体* 和 _italic_ 添加重点。

段落必须用空行隔开。

* 有时我们想要包含列表。
  * 可以缩进。

1. 列表也可以编号。
2. 有序列表。

[有可能包括超链接](https://www.example.com)

内联代码使用单个倒引号：`foo()`，代码块使用三个倒引号:

\```
\bar()
\```

或可由4个空格组成：

    foo()

最后，添加图片也很简单：![Alt](https://www.example.com/image.jpg)
```

当附加图像时，你有三个选项：

* 使用一个在 web 上的图像的 URL。
* 使用一个与你的 notebook 一起维护的本地 URL，例如在同一个 git 仓库中。
* 通过 "Edit > Insert Image" 添加附件；这将把图像转换成字符串并存储在你的 notebook 中的 `.ipynb` 文件。

* 注意这将使你的 `.ipynb` 的文件更大!

Markdown 有很多细节，特别是在超链接的时候，也可以简单地包括纯 HTML。一旦你发现自己突破了上述基础的限制，你可以参考 Markdown 创造者 John Gruber 的[官方指南](https://daringfireball.net/projects/markdown/syntax)。

### 内核

每个 notebook 后台都运行一个内核。当你运行一个代码单元时，该代码在内核中执行，任何输出都会返回到要显示的单元格。在单元格间切换时内核的状态保持不变 —— 它与文档有关，而不是单个的单元格。

例如，如果你在一个单元中导入库或声明变量，那么它们将在另一个单元中可用。通过这种方式，你可以将 notebook 文档看作是与脚本文件相当的，除了它是多媒体。让我们试着去感受一下。首先，我们将导入一个 Python 包并定义一个函数。

```Python
import numpy as np

def square(x):
    return x * x
```

一旦我们执行了上面的单元格，我们就可以在任何其他单元中引用 `np`和 `square`。

```Python
x = np.random.randint(1, 10)
y = square(x)

print('%d squared is %d' % (x, y))
```

```
1 squared is 1
```

不管你的 notebook 里的单元格顺序如何，这都是可行的。你可以自己试一下，让我们再把变量打印出来。

```Python
print('Is %d squared is %d?' % (x, y))
```

```
Is 1 squared is 1?
```

答案毫无疑问。让我们尝试改变 `y`。

```Python
y = 10
```

如果我们再次运行包含 `print` 语句的单元格，你认为会发生什么?我们得到的结果是 `Is 4 squared is 10?`！

大多数情况下，你的 notebook 上的工作流将会从上到下，但是返回上文做一些改变是很正常的。在这种情况下，每个单元的左侧的执行顺序，例如 `In [6]`，将让你知道你的任何单元格是否有陈旧的输出。如果你想要重置一些东西，从内核菜单中有几个非常有用的选项:

* 重启：重新启动内核，从而清除定义的所有变量。
* 重启和清除输出:与上面一样，但也将擦除显示在您的代码单元格下面的输出。
* 重启和运行所有:和上面一样，但也会运行你的所有单元，从第一个到最后。

如果你的内核一直在计算中，但你希望停止它，你可以选择 `Interupt` 选项。

#### 选择一个内核

你可能已经注意到，Jupyter 提供了更改内核的选项，实际上有许多不同的选项可供选择。当你通过选择 Python 版本从仪表板中创建一个新的笔记时，你实际上是在选择使用哪个内核。

不仅有不同版本的 Python 的内核，还有[(超过 100 种语言)](https://github.com/jupyter/jupyter/jupyter/wiki/jupyter-kernel)，包括 Java 、C ，甚至 Fortran。数据科学家可能特别感兴趣的是 [R](https://irkernel.github.io/) 和 [Julia](https://github.com/JuliaLang/IJulia.jl)，以及 [imatlab](https://github.com/imatlab/imatlab) 和 [Calysto MATLAB内核](https://github.com/calysto/matlab_kernel) 。[SoS 内核](https://github.com/vatlab/SOS)在一个 notebook 中提供多语言支持。每个内核都有自己的安装指令，但可能需要您在计算机上运行一些命令。

## 实例分析

现在我们已经看了一个 Jupyter Notebook，是时候看看它们在实践中使用了，这应该会让你更清楚地了解它们为什么那么受欢迎。现在是时候开始使用前面提到的财富 500 数据集了。请记住，我们的目标是了解美国最大公司的利润在历史上是如何变化的。

值得注意的是，每个人都会有自己的喜好和风格，但是一般原则仍然适用，如果你愿意，你可以在自己的 notebook 上跟随这一段，这也给了你自由发挥空间。

### 命名你的 notebook

在开始编写项目之前，你可能想要给它一个有意义的名称。也许有点让人困惑，你不能从 Notebook 的应用程序中命名或重命名你的 notebook，而必须使用仪表盘或你的文件浏览器来重命名 `.ipynb` 文件。我们将返回到仪表板，以重命名你之前创建的文件，它将有默认的 notebook 的文件名是 `Untitled.ipynb` 。

你不能在 notebook 运行时重命名它，所以你首先要关闭它。最简单的方法就是从 notebook 菜单中选择 “File > Close and Halt”。但是，您也可以通过在笔记本应用程序内 “Kernel > Shutdown” 或在仪表板中选择 notebook 并点击 “Shutdown” (见下图)来关闭内核。

![A running notebook](https://www.dataquest.io/blog/content/images/2018/03/notebook-running.jpg)

然后你可以选择你的 notebook，并在仪表板控件中点击 “Rename”。

![A running notebook](https://www.dataquest.io/blog/content/images/2018/03/notebook-controls.jpg)

注意，在你的浏览器中关闭笔记的标签页将不会像在传统的应用程序中关闭文档的方式一样关闭你的 notebook。notebook 的内核将继续在后台运行，需要在真正“关闭”之前停止运行 —— 不过如果你不小心关掉了你的标签或浏览器，这就很方便了！如果内核被关闭，你可以关闭该选项卡，而不用担心它是否还在运行。

如果你给你的 notebook 起了名字，打开它，我们就可以开始实践了。

### 设置

通常一开始就使用一个专门用于导入和设置的代码单元，因此如果你选择添加或更改任何内容，你可以简单地编辑和重新运行该单元，而不会产生任何副作用。

```Python
%matplotlib inline

import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

sns.set(style="darkgrid")
```

我们导入 [pandas](https://pandas.pydata.org/) 来处理我们的数据，[Matplotlib](https://matplotlib.org/) 绘制图表，[Seaborn](https://seabornpydata.org/) 使我们的图表更美。导入 [NumPy](http://www.numpy.org/) 也是很常见的，但是在这种情况下，虽然我们使用的是 pandas，但我们不需要显式地使用它。第一行不是 Python 命令，而是使用一种叫做行魔法的东西来指示 Jupyter 捕获 Matplotlib 图并在单元输出中呈现它们；这是超出本文范围的一系列高级特性之一。

让我们来加载数据。

```Python
df = pd.read_csv('fortune500.csv')
```

在单个单元格中这样做也是明智的，因为我们需要在任何时候重新加载它。

### 保存和检查点

现在我们已经开始了，最好的做法是定期存储。按 `Ctrl + S` 键可以通过调用“保存和检查点”命令来保存你的 notebook，但是这个检查点又是什么呢?

每当你创建一个新的 notebook 时，都会创建一个检查点文件以及你的 notebook 文件；它将位于你保存位置的隐藏子目录中称作 `.ipynb_checkpoints`，也是一个 `.ipynb` 文件。默认情况下，Jupyter 将每隔 120 秒自动保存你的 notebook，而不会改变你的主 notebook 文件。当你“保存和检查点”时，notebook 和检查点文件都将被更新。因此，检查点使你能够在发生意外事件时恢复未保存的工作。你可以通过 “File > Revert to Checkpoint“ 从菜单恢复到检查点。

### 调查我们的数据集

我们正在稳步前进！我们的笔记已经被安全保存，我们将数据集 `df` 加载到最常用的 pandas 数据结构中，这被称为 `DataFrame` ，看起来就像一张表格。那我们的数据集会是怎样的？

```
df.head()
```

|  | Year | Rank | Company | Revenue (in millions) | Profit (in millions) |
| --- | --- | --- | --- | --- | --- |
| 0 | 1955 | 1 | General Motors | 9823.5 | 806 |
| 1 | 1955 | 2 | Exxon Mobil | 5661.4 | 584.8 |
| 2 | 1955 | 3 | U.S. Steel | 3250.4 | 195.4 |
| 3 | 1955 | 4 | General Electric | 2959.1 | 212.6 |
| 4 | 1955 | 5 | Esmark | 2510.8 | 19.1 |

```
df.tail()
```

|  | Year | Rank | Company | Revenue (in millions) | Profit (in millions) |
| --- | --- | --- | --- | --- | --- |
| 25495 | 2005 | 496 | Wm. Wrigley Jr. | 3648.6 | 493 |
| 25496 | 2005 | 497 | Peabody Energy | 3631.6 | 175.4 |
| 25497 | 2005 | 498 | Wendy's International | 3630.4 | 57.8 |
| 25498 | 2005 | 499 | Kindred Healthcare | 3616.6 | 70.6 |
| 25499 | 2005 | 500 | Cincinnati Financial | 3614.0 | 584 |

看上去不错。我们有需要的列，每一行对应一个公司一年的财务数据。

让我们重命名这些列，以便稍后引用它们。

```
df.columns = ['year', 'rank', 'company', 'revenue', 'profit']
```

接下来，我们需要探索我们的数据集，它是否完整? pandas 是按预期读的吗？缺少值吗?

```
len(df)
```

```
25500
```

好吧，看起来不错 —— 从 1955 年到 2005 年，每年都有 500 行。

让我们检查我们的数据集是否如我们预期的那样被导入。一个简单的检查就是查看数据类型（或 dtypes）是否被正确地解释。

```
df.dtypes
```

```
year         int64
rank         int64
company     object
revenue    float64
profit      object
dtype: object
```

看起来利润栏有点问题 —— 我们希望它像收入栏一样是 `float64`。这表明它可能包含一些非整数值，所以让我们看一看。

```python
non_numberic_profits = df.profit.str.contains('[^0-9.-]')
df.loc[non_numberic_profits].head()
```

|  | year | rank | company | revenue | profit |
| --- | --- | --- | --- | --- | --- |
| 228 | 1955 | 229 | Norton | 135.0 | N.A. |
| 290 | 1955 | 291 | Schlitz Brewing | 100.0 | N.A. |
| 294 | 1955 | 295 | Pacific Vegetable Oil | 97.9 | N.A. |
| 296 | 1955 | 297 | Liebmann Breweries | 96.0 | N.A. |
| 352 | 1955 | 353 | Minneapolis-Moline | 77.4 | N.A. |

就像我们猜测的那样!其中一些值是字符串，用于表示丢失的数据。还有其他缺失的值么?

```Python
set(df.profit[non_numberic_profits])
```

```
{'N.A.'}
```

这很容易解释，但是我们应该怎么做呢？这取决于缺失了多少个值。

```Python
len(df.profit[non_numberic_profits])
```

```
369
```

它只是我们数据集的一小部分，虽然不是完全无关紧要，因为它仍然在 1.5% 左右。如果包含 N.A. 的行是简单地、均匀地按年分布的，那最简单的解决方案就是删除它们。所以让我们浏览一下分布。

```
bin_sizes, _, _ = plt.hist(df.year[non_numberic_profits], bins=range(1955, 2006))
```

![Missing value distribution](https://www.dataquest.io/blog/content/images/2018/03/jupyter-notebook-tutorial_35_0.png)

粗略地看，我们可以看到，在一年中无效值最多的情况也小于 25，并且由于每年有 500 个数据点，删除这些值在最糟糕的年份中只占不到 4% 的数据。事实上，除了 90 年代的激增，大多数年份的缺失值还不到峰值的一半。为了我们的目的，假设这是可以接受的，然后移除这些行。

```Python
df = df.loc[~non_numberic_profits]
df.profit = df.profit.apply(pd.to_numeric)
```

我们看看有没有生效。

```
len(df)
```

```
25131
```

```
df.dtypes
```

```
year         int64
rank         int64
company     object
revenue    float64
profit     float64
dtype: object
```

不错！我们已经完成了数据集的设置。

如果你要将 notebook 做成一个报告，你可以不使用我们创建的研究的单元格，包括这里的演示使用 notebook 的工作流，合并相关单元格(请参阅下面的高级功能部分)并创建一个数据集设置单元格。这意味着如果我们把我们的数据放在别处，我们可以重新运行安装单元来恢复它。

### 使用 matplotlib 进行绘图

接下来，我们可以通过计算年平均利润来解决这个问题。我们不妨把收入也画出来，所以首先我们可以定义一些变量和一种方法来减少我们的代码。

```Python
group_by_year = df.loc[:, ['year', 'revenue', 'profit']].groupby('year')
avgs = group_by_year.mean()
x = avgs.index
y1 = avgs.profit

def plot(x, y, ax, title, y_label):
    ax.set_title(title)
    ax.set_ylabel(y_label)
    ax.plot(x, y)
    ax.margins(x=0, y=0)
```

现在让我们开始画图。

```Python
fig, ax = plt.subplots()
plot(x, y1, ax, 'Increase in mean Fortune 500 company profits from 1955 to 2005', 'Profit (millions)')
```

![Increase in mean Fortune 500 company profits from 1955 to 2005](https://www.dataquest.io/blog/content/images/2018/03/jupyter-notebook-tutorial_44_0.png)

它看起来像一个指数，但它有一些大的凹陷。它们一定是对应于[上世纪 90 年代初的经济衰退](https://en.wikipedia.org/wiki/Early_1990s_recession)和 [互联网泡沫](https://en.wikipedia.org/wiki/Dot-com_bubble)。在数据中能看到这一点非常有趣。但为什么每次经济衰退后，利润都能恢复到更高的水平呢?

也许收入能告诉我们更多。

```Python
y2 = avgs.revenue
fig, ax = plt.subplots()
plot(x, y2, ax, 'Increase in mean Fortune 500 company revenues from 1955 to 2005', 'Revenue (millions)')
```

![Increase in mean Fortune 500 company revenues from 1955 to 2005](https://www.dataquest.io/blog/content/images/2018/03/jupyter-notebook-tutorial_46_0.png)

这为故事增添了另一面。收入几乎没有受到严重打击，财务部门的会计工作做得很好。

借助 [Stack Overflow](https://stackoverflow.com/a/47582329/604687) 上的帮助，我们可以用 +/- 它们的标准偏移来叠加这些图。

```Python
def plot_with_std(x, y, stds, ax, title, y_label):
    ax.fill_between(x, y - stds, y + stds, alpha=0.2)
    plot(x, y, ax, title, y_label)

fig, (ax1, ax2) = plt.subplots(ncols=2)
title = 'Increase in mean and std Fortune 500 company %s from 1955 to 2005'
stds1 = group_by_year.std().profit.as_matrix()
stds2 = group_by_year.std().revenue.as_matrix()
plot_with_std(x, y1.as_matrix(), stds1, ax1, title % 'profits', 'Profit (millions)')
plot_with_std(x, y2.as_matrix(), stds2, ax2, title % 'revenues', 'Revenue (millions)')
fig.set_size_inches(14, 4)
fig.tight_layout()
```

![jupyter-notebook-tutorial_48_0](https://www.dataquest.io/blog/content/images/2018/03/jupyter-notebook-tutorial_48_0.png)

这是惊人的，标准偏差是巨大的。一些财富 500 强的公司赚了数十亿，而另一些公司却损失了数十亿美元，而且随着这些年来利润的增长，风险也在增加。也许有些公司比其他公司表现更好；前 10％ 的利润是否或多或少会比最低的10％稳定一些?

接下来我们有很多问题可以看，很容易看到在 notebook 上的工作流程是如何与自己的思维过程相匹配的，所以现在是时候为这个例子画上句号了。这一流程帮助我们在无需切换应用程序的情况下轻松地研究我们的数据集，并且我们的工作可以立即共享和重现。如果我们希望为特定的目标人群创建一个更简洁的报告，我们可以通过合并单元和删除中间代码来快速重构我们的工作。

## 分享你的 notebook

当人们谈论分享他们的 notebook 时，他们通常会考虑两种模式。大多数情况下，个人共享其工作的最终结果，就像本文本身一样，这意味着共享非交互式的、预渲染的版本的 notebook；然而，也可以在 notebook 上借助诸如 [Git](https://git-scm.com/) 这样的辅助版本控制系统进行协作。

也就是说，[有一些](https://mybinder.org/)新兴的[公司](https://kyso.io/)在 web 上提供了在云中运行交互式 Jupyter Notebook 的能力。

### 在你分享之前

当你导出或保存它时，共享的 notebook 将会以被导出或保存的那一刻的状态显示，包括所有代码单元的输出。因此，为了确保你的 notebook 是共享的，你可以在分享之前采取一些步骤：

1.  点击 "Cell > All Output > Clear"
2.  点击 "Kernel > Restart & Run All"
3.  等待您的代码单元完成执行，并检查它们是否按预期执行。

这将确保你的 notebook 不包含中间输出，不包含陈旧的状态，并在共享时按顺序执行。

### 导出你的 notebook

Jupyter 内置支持导出 HTML 和 PDF 以及其他几种格式，你可以在 `File > Download As` 菜单下找到。如果你希望与一个小型的私有组共享你的 notebook，这个功能很可能是你所需要的。事实上，许多学术机构的研究人员都有一些公共或内部的网络空间，因为你可以将一个 notebook 导出到一个 HTML 文件中，Jupyter notebook 可以成为他们与同行分享成果的一种特别方便的方式。

但是，如果共享导出的文件并不能让你满意，那么还有一些更直接的非常流行的共享 `.ipynb` 文件到网上的方法。

### GitHub

截止到 2018 年初，GitHub 上的公共 notebook 数量超过了 180 万，它无疑是最受欢迎的与世界分享 Jupyter 项目的独立平台。GitHub 已经集成了对 `.ipynb` 的文件渲染的支持，你可以直接将其存储在其网站的仓库和 gists 中。如果你还不知道，[GitHub](https://github.com) 是一个代码托管平台，用于为使用 [Git](https://git-scm.com/) 创建的存储库进行版本控制和协作。你需要创建一个帐户来使用他们的服务，同时 Github 标准帐户是免费的。

当你有了 GitHub 账户，在 GitHub 上共享一个 notebook 最简单的方法甚至都不需要 Git。自 2008 年以来， GitHub 为托管和共享代码片段提供了Gist 服务，每个代码段都有自己的存储库。使用 Gists 共享一个 notebook：

1. 登录并且浏览 [gist.github.com](https://gist.github.com)。
2. 用文件编辑器打开 `.ipynb` 文件,  全选并且拷贝里面的 JSON 。
3. 将笔记的 JSON 粘贴到中 gist 中。
4. 给你的 Gist 命名, 记得添加 `.iypnb` 后缀，否则不能正常工作。
5. 点击 "Create secret gist"或者 "Create public gist."

这看起来应该是这样的：

![Creating a Gist](https://www.dataquest.io/blog/content/images/2018/03/create-gist.jpg)

如果你创建了一个公共的 Gist，你现在就可以和任何人分享它的 URL，其他人将能够 [fork 和 clone](https://help.github.com/articles/forkingand-cloning-gists/) 你的工作。

创建自己的 Git 存储库并在 GitHub 上共享，这超出了本教程的范围，但是 [GitHub 提供了大量的指南](https://guides.github.com/)可供你参考。

对于那些使用 git 的人来说，一个额外的技巧是在 `.gitignore` 中为 Jupyter 创建的 `.ipynb_checkpoints` 目录[添加例外](https://stackoverflow.com/q/35916658/604687)，因为我们不需要将检查点文件提交给到仓库。

从 2015 年起，NBViewer 每个星期都会渲染[成千上万的 notebook](https://blog.jupyter.org/renderingnotebooks-ongithub-f7ac8736d686)，它已然成了最受欢迎的 notebook 渲染器。如果你已经在某个地方把你的 Jupyter Notebook 放在网上，无论是 GitHub 还是其他地方，NBViewer 都可以读取你的 notebook，并提供一个可共享的 URL。作为项目 Jupyter 的一部分提供的免费服务，你可以在 [nbview.jupyter.org](https://nbview.jupyter.org/) 找到相关服务。

最初是在 GitHub 的 Jupyter Notebook 集成之前开发的，NBViewer 允许任何人输入 URL、Gist ID 或 `GitHub username/repo/filename`，并将其作为网页呈现。一个 Gist 的 ID 是其 URL 末尾唯一的数字；例如，在 `https://gist.github.com/username/50896401c23e0bf417e89e1de` 中最后一个反斜杠后的字符串。如果你输入了 `GitHub username/repo/filename` ，你将看到一个最小的文件浏览器，它允许你访问用户的仓库及其内容。

NBViewer 显示的 notebook 的 URL 是基于正在渲染的 notebook 的 URL 的并且不会改变，所以你可以和任何人分享它，只要原始文件保持在线 —— NBViewer 不会缓存文件很长时间。

## 结语

从基础知识入手，我们已经掌握了 Jupyter Notebook 的工作流程，深入研究了IPython 的更多高级功能，并最终学会如何与朋友、同事和世界分享我们的工作。我们从一个笔记上完成了这一切!

可以看到，notebook 是如何通过减少上下文切换和在项目中模拟自然的思维发展的方式来提高工作经验的。Jupyter Notebook。Jupyter Notebook 的功能也应该是显而易见的，我们已经介绍了大量的资源，让你开始在自己的项目中探索更高级的特性。

如果你想为自己的 Notebooks 提供更多的灵感，Jupyter 已经整理好了([一个有趣的 Jupyter Notebook 图库](https://github.com/jupyter/jupyter/wiki/A-gallery-of-interesting-Jupyter-Notebooks))，你可能会发现它有帮助，并且你会发现 [Nbviewer 的主页](https://nbviewer.jupyter.org/)链接到一些真正的高质量笔记本的例子。也可以查看我们的 [Jupyter Notebooks 提示列表](https://www.dataquest.io/blog/jupyter-notebook-tips-tricks-shortcuts/)。

> 想了解更多关于 Jupyter Notebooks 的知识吗?我们有[一个有指导的项目](https://www.dataquest.io/m/207/guided-project%3A-using-jupyter-notebook)，你可能会感兴趣。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
