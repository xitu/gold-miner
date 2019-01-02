> * 原文地址：[Data Visualization with Bokeh in Python, Part III: Making a Complete Dashboard](https://towardsdatascience.com/data-visualization-with-bokeh-in-python-part-iii-a-complete-dashboard-dc6a86aa6e23)
> * 原文作者：[Will Koehrsen](https://towardsdatascience.com/@williamkoehrsen?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/data-visualization-with-bokeh-in-python-part-iii-a-complete-dashboard.md](https://github.com/xitu/gold-miner/blob/master/TODO1/data-visualization-with-bokeh-in-python-part-iii-a-complete-dashboard.md)
> * 译者：[YueYong](https://github.com/YueYongDev)
> * 校对者：

# 利用 Python中的 Bokeh 实现数据可视化，第三部分：制作一个完整的仪表盘

**在 Bokeh 中创建交互式可视化应用程序**

![](https://cdn-images-1.medium.com/max/1000/1*wWPUyFSC0LlX960L3FTeDQ.jpeg)

有时我会学习数据科学技术来解决特定问题。其他时候，我会尝试一种新工具，比如说 Bokeh ，因为我在 Twitter 上看到一些很酷的项目，就会想：“那看起来很棒。虽然我不确定什么时候用，但迟早会有用的。”虽然几乎每次我都这么说，但是我最终都找到了这个工具的用途。 数据科学需要许多不同能力方面的知识，你永远不知道下一个你将使用的想法将来自哪里!

作为一个数据科学研究人员，在试用了几个星期之后，我终于在 Bokeh 的例子中找到了一个完美的用例。我的[研究项目]((https://arpa-e.energy.gov/?q=slick-sheet-project/virtual-building-energy-audits) )涉及利用数据科学提高商业建筑的能源效率。[在最近的一次会议]((http://www.arpae-summit.com/about/about-the-summit))上，我们需要用一种方法来展示我们使用的众多技术的成果。通常情况下都建议使用 powerpoint 来完成这项任务，但是效果并不明显。大多数在会议中的人在看到第三张幻灯片时，就已经失去耐心了。尽管我对 Bokeh 还不是很熟悉，但我仍然自愿尝试利用这个库做一个交互式应用程序，我认为这会扩展我的技能，创造一个吸引人的方式来展示我们的项目。安全起见，我们团队准备了一个演示的备份，但在我向他们展示了一些初稿之后，他们给予了全力支持。最终的交互式仪表板在会议上脱颖而出，未来我们的团队也将会使用：

![](https://cdn-images-1.medium.com/max/800/1*nN5-hITqzDlhelSJ2W9x5g.gif)

为[我的研究](https://arpa-e.energy.gov/?q=slick-sheet-project/virtual-building-energy-audits)构建的 Bokeh 仪表盘的例子

虽然说并不是每一个你在 Twitter上看到的想法都可能对你的职业生涯产生帮助，但我可以负责的说，了解更多的数据科学技术不会有什么坏处。 沿着这些思路，我开始了本系列文章，以展示 Bokeh 的功能， [Bokeh](https://bokeh.pydata.org/en/latest/) 是 Python 中一个强大的绘图库，他可以允许你制作交互式绘图和仪表盘。尽管我不能向你展示我的研究的仪表盘，但是我可以使用公开可用的数据集展示在 Bokeh 中构建可视化的基础知识。第三篇文章是我的 Bokeh 系列文章的延续，[第一部分着重于构建一个简单的图](https://towardsdatascience.com/data-visualization-with-bokeh-in-python-part-one-getting-started-a11655a467d4) ，[第二部分展示如何向 Bokeh 图中添加交互](https://towardsdatascience.com/data-visualization-with-bokeh-in-python-part-ii-interactions-a4cf994e2512)。在这篇文章中，我们将看到如何设置一个完整的 Bokeh 应用程序，并在您的浏览器中运行可访问的本地Bokeh服务器!

本文将重点介绍 Bokeh 应用程序的结构，而不是具体的细节，但是你可以在 [GitHub](https://github.com/WillKoehrsen/Bokeh-Python-Visualization) 上找到所有内容的完整代码。我们将会使用 [NYCFlights13 数据集](https://cran.r-project.org/web/packages/nycflights13/nycflights13.pdf)，这是一个 2013 年从纽约 3 个机场起飞的航班的真实信息数据集。这个数据集中有超过 300,000 个航班信息，对于我们的仪表盘，我们将主要关注于到达延迟信息的统计。

为了能完整运行整个应用程序，你需要先确保你已经安装了 Bokeh（使用 `pip install bokeh`）,从 GitHub上 [下载](https://github.com/WillKoehrsen/Bokeh-Python-Visualization/blob/master/bokeh_app.zip) `[bokeh_app.zip](https://github.com/WillKoehrsen/Bokeh-Python-Visualization/blob/master/bokeh_app.zip)` [文件夹](https://github.com/WillKoehrsen/Bokeh-Python-Visualization/blob/master/bokeh_app.zip), 解压，并在当前目录打开一个命令窗口，并输入 `bokeh serve --show bokeh_app`。这会设置一个 [Bokeh 的本地服务](https://bokeh.pydata.org/en/latest/docs/user_guide/server.html) 同时还会在你的浏览器中打开一个应用（当然你也可以使用 Bokeh 的在线服务，但是目前对我们来说本地主机足矣）。

### 最终产品

在我们深入讨论细节之前，让我们先来看看我们的最终产品，这样我们就可以看到各个部分是如何组合在一起的。下面是一个短片，展示了我们如何与完整的仪表盘互动：

- YouTube 视频链接：https://youtu.be/VWi3HAlKOUQ

Bokeh 航班应用最终版

我在本地服务器上运行的浏览器(在Chrome的全屏模式下)中使用 Bokeh 应用程序。在顶部我们看到许多选项卡，每个选项卡包含不同部分的应用程序。仪表盘的想法是，虽然每个选项卡可以独立存在，但是我们可以将其中许多选项卡连接在一起，以支持对数据的完整探索。这段视频展示了我们可以用 Bokeh 制作的图表的范围，从直方图和密度图，到可以按列排序的数据表，再到完全交互式的地图。使用 Bokeh 这个库除了可以创建丰富的图形外，另一个好处是交互。每个标签都有一个交互元素可以让用户参与到数据中，并自己探索。从经验来看，当探索一个数据集时，人们喜欢自己去洞察，我们可以让他们通过各种控件来选择和过滤数据。

现在我们对目标仪表盘已经有一个概念了，接下来让我们看看如何创建 Bokeh 应用程序。 我强烈建议你[下载这些代码](https://github.com/WillKoehrsen/Bokeh-Python-Visualization/tree/master/bokeh_app)，以供参考！

* * *

### Bokeh 应用的结构

在编写任何代码之前，为我们的应用程序建立一个框架是很重要的。在任何项目中，很容易被编码冲昏头脑，很快就会迷失在一堆尚未完成的脚本和错位的数据文件中，因此我们想要在编写代码和插入数据前先创建一个框架。这个组织将帮助我们跟踪应用程序中的所有元素，并在不可避免地出错时帮助我们进行调试。此外，我们可以在未来的项目中复用这个框架，这样我们在规划阶段的初始投资将在未来得到回报。

为了设置一个 Boken 应用，我创建了一个名为`bokeh_app`的根目录来保存所有内容。 在这个目录中，我们创建了一个子目录用来存档数据（命名为 `data` ），另一个子目录用来存放脚本文件（命名为 `script` ）并通过一个 `main.py` 文件将所有的东西组合在一起.。通常，为了管理所有代码，我发现最好将每个选项卡的代码保存在单独的 Python 脚本中，并从单个主脚本调用它们。下面是我为 Bokeh 应用程序所创建的文件结构，它改编自[官方文档](https://bokeh.pydata.org/en/latest/docs/user_guide/server.html)。

```
bokeh_app
|
+--- data
|   +--- info.csv
|   +--- info2.csv
|
+--- scripts
|   +--- plot.py
|   +--- plot2.py
|
+--- main.py
```

对于 flight 应用程序，其结构大致如下:

![](https://cdn-images-1.medium.com/max/800/1*MvlTa19t4B5MLhY6329B7Q.png)

航班仪表盘的文件夹结构

 在 `bokeh_app` 目录下有三个主要部分：  `data`, `scripts`, 和  `main.py`。当需要运行服务器时，我们在 `bokeh_app` 目录运行 Bokeh ，它会自动搜索并运行 `main.py` 脚本。有了总体结构之后，让我们来看看 `main.py` 文件，我把它称为 Bokeh 应用程序的启动程序（并不是专业术语）！

### `main.py`

 `main.py` 脚本是 Bokeh 应用程序的启动脚本。它加载数据，并把传递给其他脚本，获取结果图，并将它们组织好后单个显示出来。这将是我展示的唯一一个完整的脚本，因为它对应用程序非常重要：

```
# Pandas for data management
import pandas as pd

# os methods for manipulating paths
from os.path import dirname, join

# Bokeh basics 
from bokeh.io import curdoc
from bokeh.models.widgets import Tabs


# Each tab is drawn by one script
from scripts.histogram import histogram_tab
from scripts.density import density_tab
from scripts.table import table_tab
from scripts.draw_map import map_tab
from scripts.routes import route_tab

# Using included state data from Bokeh for map
from bokeh.sampledata.us_states import data as states

# Read data into dataframes
flights = pd.read_csv(join(dirname(__file__), 'data', 'flights.csv'), 
	                                          index_col=0).dropna()

# Formatted Flight Delay Data for map
map_data = pd.read_csv(join(dirname(__file__), 'data', 'flights_map.csv'),
                            header=[0,1], index_col=0)

# Create each of the tabs
tab1 = histogram_tab(flights)
tab2 = density_tab(flights)
tab3 = table_tab(flights)
tab4 = map_tab(map_data, states)
tab5 = route_tb(flights)

# Put all the tabs into one application
tabs = Tabs(tabs = [tab1, tab2, tab3, tab4, tab5])

# Put the tabs in the current document for display
curdoc().add_root(tabs)
```

我们从必要的导包开始，包括创建选项卡的函数，每个选项卡都存储在 `scripts` 目录中的单独脚本中。如果你看下文件结构，注意这里有一个 `__init__.py` 文件在 `scripts`  目录中。这是一个完全空白的文件，需要放在目录中，以允许我们使用相对语句导入适当的函数 (例如 `from scripts.histogram import histogram_tab` ).我不太清楚为什么需要这样做，但它确实有效（我曾经解决过这个问题，这里是 [Stack Overflow的答案](https://stackoverflow.com/a/48468292/5755357)）.

在导入库和脚本后，我们利用 [Python](https://stackoverflow.com/questions/9271464/what-does-the-file-variable-mean-do/9271617) `[__file__](https://stackoverflow.com/questions/9271464/what-does-the-file-variable-mean-do/9271617)` [属性](https://stackoverflow.com/questions/9271464/what-does-the-file-variable-mean-do/9271617)读取必要的数据。在本例中，我们使用了两个 pandas 数据框(`flights` 和 `map_data` )以及包含在 Bokeh 中的美国各州的数据。读取数据之后，脚本继续进行执行：它将适当的数据传递给每个函数，每个函数绘制并返回一个选项卡，主脚本将所有这些选项卡组织在一个称为 `tabs` 的布局中。作为这些独立选项卡函数的示例，让我们来看看绘制 `map_tab` 的函数。

该函数接收 `map_data` (航班数据的格式化版本)和美国各州数据，并为选定的航空公司生成航线图：

![](https://cdn-images-1.medium.com/max/1000/1*fnxAzaoSwqrhX2K7RZJdeg.png)

地图选项卡

我们在本系列的第 2 部分中介绍了交互式情节，而这个情节只是该思想的一个实现。功能整体结构为:

```
def map_tab(map_data, states):
    ...
    
    def make_dataset(airline_list):
    ...
       return new_src
    def make_plot(src):
    ...
       return p

   def update(attr, old, new):
   ...
      new_src = make_dataset(airline_list)
      src.data.update(new_src.data)

   controls = ...
   tab = Panel(child = layout, title = 'Flight Map')
   
   return tab
```

我们看到了熟悉的 `make_dataset`, `make_plot`, 和  `update`  函数，这些函数用于[使用交互式控件绘制绘图](https://towardsdatascience.com/data- visualiz-with - bokehin - pythonpart -ii-interactions-a4cf994e2512)。一旦我们设置好了图，最后一行将整个图返回给主脚本。每个单独的脚本(5个选项卡对应5个选项卡)都遵循相同的模式。

回到主脚本，最后一步是收集选项卡并将它们添加到一个单独的文档中。

```
# Put all the tabs into one application
tabs = Tabs(tabs = [tab1, tab2, tab3, tab4, tab5])

# Put the tabs in the current document for display
curdoc().add_root(tabs)
```

选项卡显示在应用程序的顶部，就像任何浏览器中的选项卡一样，我们可以轻松地在它们之间切换以查看数据。

![](https://cdn-images-1.medium.com/max/1000/1*CUyrsJpP5lkvVdheseAYXQ.png)

### 运行 Bokeh 服务

在完成所有的设置和编码之后，在本地运行 Bokeh 服务器非常简单。我们打开一个命令行界面(我更喜欢 Git Bash，但任何一个都可以)，切换到包含 `bokeh_app` 的目录，并运行 `bokeh serve --show bokeh_app` 。假设所有代码都正确，应用程序将自动在浏览器中打开地址  `http://localhost:5006/bokeh_app` 。然后，我们就可以访问应用程序并查看我们的仪表盘了!

![](https://cdn-images-1.medium.com/max/800/1*6orEuCOf0HsnCp_wzKPs3A.gif)

Bokeh 航班应用最终版

#### 在 Jupyter Notebook 中调试

如果出了什么问题(在我们刚开始编写仪表盘的时候，肯定会出现这种情况)，令人沮丧的是，我们必须停止服务器、对文件进行更改并重新启动服务器，以查看我们的更改是否达到了预期的效果。为了快速迭代和解决问题，我通常在 Jupyter Notebook 中开发图。Jupyter Notebook 对 Bokeh 来说是一个很好的开发环境，因为你可以在笔记本中创建和测试完全交互式的绘图。语法略有不同，但一旦你有了一个完整的图，代码只需稍加修改，就可以复制粘贴到一个独立的 `.py` 脚本。要了解这一点的实际应用，请查看 [Jupyter Notebook](https://github.com/willkoehrsen/bokeh - pyth-visualization/blob/master/application/app_development .ipynb)。

* * *

### 总结

一个完全可交互式的 Bokeh 仪表盘使任何数据科学项目脱颖而出。我经常看到我的同事们做了很多非常棒的统计工作，但却不能清楚地传达结果，这意味着所有这些工作都没有得到应有的认可。从个人经验来看，我也看到了 Bokeh 应用程序在交流结果方面是多么有效。虽然制作一个完整的仪表板需要做很多工作(超过600行代码)，但是结果是值得的。此外，一旦我们有了一个应用程序，我们就可以使用 GitHub 快速地共享它，如果我们对我们的结构很了解，我们就可以在其他项目中重用这个框架。 

从这个项目中得出的关键点适用于许多常规数据科学项目：

1.  在开始一项数据科学任务之前，拥有适当的框架/结构( Bokeh 或其他的框架)是至关重要的。这样，您就不会发现自己迷失在试图查找错误的代码森林中。而且，一旦我们开发了一个有效的框架，它就可以以最小的工作量被复用，从而在未来带来收益。

2.  找到一个调试周期，使你能够快速进行想法迭代是至关重要的。 Jupyter Notebook 支持编写代码—查看结果—修复错误的循环，这有助于提高开发周期的效率(至少对于小型项目来说是这样)。

3.  Bokeh 中的交互式应用程序将提升您的项目并鼓励用户参与。仪表盘可以是独立的探索性项目，也可以突出显示你已经完成的所有艰难的分析工作!

4.  你永远不知道在哪里可以找到下一个你在工作中能用到的或有帮助的工具。所以睁大你的眼睛，不要害怕尝试新的软件和技术!

这就是本文和本系列的全部内容，尽管我计划在未来在额外发布有关 Bokeh 的独立教程。以一种令人信服的方式展示数据科学成果是至关重要的，有了像 Bokeh 和 plot.ly 这样的库，制作交互式图形变得越来越容易。你可以在 [Bokeh GitHub repo](https://github.com/WillKoehrsen/Bokeh-Python-Visualization) 查看我所有的工作，免费 fork 它并开始你自己的项目。现在，我渴望看到其他人能创造出什么!

一如既往地，我欢迎反馈和建设性的批评。你可以通过Twitter [@koehrsen_will](https://twitter.com/koehrsen_will)联系到我。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
