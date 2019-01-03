> * 原文地址：[Data Visualization with Bokeh in Python, Part I: Getting Started](https://towardsdatascience.com/data-visualization-with-bokeh-in-python-part-one-getting-started-a11655a467d4)
> * 原文作者：[Will Koehrsen](https://towardsdatascience.com/@williamkoehrsen?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/data-visualization-with-bokeh-in-python-part-one-getting-started.md](https://github.com/xitu/gold-miner/blob/master/TODO1/data-visualization-with-bokeh-in-python-part-one-getting-started.md)
> * 译者：
> * 校对者：

# 用 Python 中的 Bokeh 实现可视化数据，第一部分：入门

**提升你的可视化游数据**

如果没有有效的方法来传达结果，那么再复杂的统计分析也毫无意义。这一点我在最近的研究项目中深有体会，我们使用[数据科学来提高建筑能效](https://arpa-e.energy.gov/?q=slick-sheet-project/virtual-building-energy-audits)。在过去的几个月里，我团队成员中的一个人一直致力于研究一种叫做 [wavelet transforms](http://disp.ee.ntu.edu.tw/tutorial/WaveletTutorial.pdf)，用于分析时间序列频率成分的技术。该方法取得了积极的效果，但她在解释过程中遇到了困难，所幸的是，她没有迷失在技术细节中。

她很愤怒，问我能否用视觉表达来说明这种变换。我使用了叫做 `gganimate` 的 R 包，在几分钟之内制作了一个简单的动画，展示了该方法是如何转换时间序列的。现在，我的团队成员可以用这个让人直观地了解技术是如何工作的东西来取代费劲的语言描述。我的结论是，我们可以做最严格的分析，但在一天结束时，所有人都想看到的是一个 gif！虽然说这话是开玩笑，但它蕴含着一个道理：不能清楚地表达结果，就会对结果产生影响，而数据可视化通常是展示分析结果的最佳方法。

可用于数据科学的资源正在迅速增加，在[可视化领域](https://codeburst.io/overview-of-python-data-visualization-tools-e32e1f716d10)中尤为明显，似乎每周都有一种新的尝试。随着这些技术的进步，它们逐渐出现了一个共同的趋势：增加交互性。人们喜欢在静态图中查看数据，但他们更喜欢的是使用数据，并利用这些数据来查看参数的变化对结果的影响。在我的研究中，有一份报告是用来告诉业主通过改变他们的空调使用时间可以节省下多少度电，但如果给他们一个可以交互的表，他们就可以自己选择不同的时间表，来观察不用时间是如何影响用电的，这种方式更加有效。最近，受交互式绘图趋势的启发，以及对不断学习新工具的渴望，我一直在学习使用一个叫做 [Bokeh](https://bokeh.pydata.org/en/latest/) 的 Python 库。我为我的研究项目构建的仪表盘中显示了 Bokeh 交互功能的一个示例：

![](https://cdn-images-1.medium.com/max/800/1*nN5-hITqzDlhelSJ2W9x5g.gif)

尽管我无法共享这个项目的整个代码，但我可以通过使用公开可用数据构建完全交互的 Bokeh 应用程序的示例。本系列文章将介绍使用 Bokeh 创建应用程序的整个过程。对于第一篇文章，我们将介绍 Bokeh 的基本元素，我们将在以后的文章中对其进行构建，在本系列文章中，我们将使用 [nycflights13 数据集](https://cran.r-project.org/web/packages/nycflights13/nycflights13.pdf)，该数据集有 2013 年以来超过 30 万次航班的记录。我们首先将重点放在可视化单个变量上，在这种情况下，航班的延迟到达以分钟为单位，我们将从构造一个基本的柱状图开始，这是显示一个连续变量的扩展和位置的经典方法。[完整的代码可以在 GitHub 查看](https://github.com/WillKoehrsen/Bokeh-Python-Visualization)，第一个 Jupyter notebook 可以在[这里](https://github.com/WillKoehrsen/Bokeh-Python-Visualization/blob/master/intro/exploration/first_histogram.ipynb)看到。这篇文章关注的是视觉效果，所以我鼓励任何人查看代码，如果他们想看到无聊但又必不可少数据清洗和格式化的步骤！

### Bokeh 基础

Bokeh 的主要概念是一次建立一个图层。我们首先创建一个图，然后向图中添加名为 [glyphs](https://bokeh.pydata.org/en/latest/docs/user_guide/plotting.html) 的元素。（对于那些使用 ggplot 的人来说，glyphs 的概念与地理符号的想法本质上是一样的，他们一次添加到一个“图层”中。）根据所需的用途，glyphs 可以呈现多种形状：圆形、线条、补丁、条形、弧形等。让我们用正方形和圆形制作一个基本的图来说明 glyphs 的概念。首先，我们使用 `figure` 方法绘制一个图，然后通过调用适当的方法传入数据，将我们的 glyphs 添加到绘图中。最后，我们展示绘图（我使用的是 Jupyter Notebook，如果你使用时调用的是 `output_notebook`，就会看到对应的绘图）。

``` Python
# bokeh 基础
from bokeh.plotting import figure
from bokeh.io import show, output_notebook

# 创建带标签的空白图
p = figure(plot_width = 600, plot_height = 600, 
           title = 'Example Glyphs',
           x_axis_label = 'X', y_axis_label = 'Y')

# 示例数据
squares_x = [1, 3, 4, 5, 8]
squares_y = [8, 7, 3, 1, 10]
circles_x = [9, 12, 4, 3, 15]
circles_y = [8, 4, 11, 6, 10]

# 添加方形 glyph
p.square(squares_x, squares_y, size = 12, color = 'navy', alpha = 0.6)
# 添加圆形 glyph
p.circle(circles_x, circles_y, size = 12, color = 'red')

# 设置为在笔记本中输出情节
output_notebook()
# 显示绘图
show(p)
```

这就形成了下面略显平淡的绘图：

![](https://cdn-images-1.medium.com/max/800/1*fGSBddMUbg_N--xbBOdUOg.png)

尽管在任何绘制图库中，我们都可以很容易地制作这个图表，但我们可以免费获取一些工具，其中包含位于右侧的 Bokeh 绘图，包括 panning，缩放和绘图保存功能。这些工具是可配置的，当我们想研究我们的数据时，这些工具会派上用场。

我们现在开始展示我们的航班延迟数据。在跳转到图形之前，我们应该加载数据并对其进行简短的检查（**粗体** 为输出代码）：

``` Python
# 将 CSV 中的数据读入
flights = pd.read_csv('../data/flights.csv', index_col=0)

# 兴趣栏的统计数据汇总
flights['arr_delay'].describe()

count    327346.000000
mean          6.895377
std          44.633292
min         -86.000000
25%         -17.000000
50%          -5.000000
75%          14.000000
max        1272.000000
```

摘要统计数据为我们作出决策提供了信息：我们有 327、346 次航班，最小延迟事件为 -86 分钟，最大延迟事件为 1272 分钟，令人震惊的 21 小时！ 75% 的分位数只有 14 分钟，所以我们可以假设 1000 分钟以上的数字可能是异常值（这并不意味着它们是非法的，只是极端的）。我会集中讨论 -60 到 120 分钟的延迟柱状图。

[柱状图](https://www.moresteam.com/toolbox/histogram.cfm)是单个变量初始可视化的常见选择，因为它显示了分布式数据。x 位置是将变量分组成成为 bin 的间隔的值，每个条形的高度表示每个间隔数据点的计数（数目）。在我们的例子中，x 位置将代表以分钟为单位的延迟到达，高度是对应的 bin 中的航班数。Bokeh 没有内置的柱状图，但我们可以使用 `quad` glyph 来指定每个条形的底部、上、下、和右边距。

要创建条形图的数据，我们要使用 [numpy](https://docs.scipy.org/doc/numpy-1.14.0/reference/generated/numpy.histogram.html)、`[histogram](https://docs.scipy.org/doc/numpy-1.14.0/reference/generated/numpy.histogram.html)`、[function](https://docs.scipy.org/doc/numpy-1.14.0/reference/generated/numpy.histogram.html)，它计算每个指定 bin 数据点的数值。我们使用 5 分钟的长度作为函数将计算航班数在每五分钟所花费的时间延误。在生成数据之后，我们将其放入一个 [pandas dataframe 来将所有的数据保存在一个对象中。](https://pandas.pydata.org/pandas-docs/stable/dsintro.html)这里的代码对于理解 Bokeh 并不是很重要，但鉴于 Numpy 和 pandas 在数据科学中的流行度，所以它还是有些用处的。

``` Python
"""Bins will be five minutes in width, so the number of bins 
is (length of interval / 5). Limit delays to [-60, +120] minutes using the range."""

arr_hist, edges = np.histogram(flights['arr_delay'], 
                               bins = int(180/5), 
                               range = [-60, 120])

# 将信息放入 dataframe
delays = pd.DataFrame({'arr_delay': arr_hist, 
                       'left': edges[:-1], 
                       'right': edges[1:]})
```

我们的数据看起来像这样：

![](https://cdn-images-1.medium.com/max/800/1*JSiAY3RSGOhur9agdzgEYQ.png)

`flights` 列是从 `left` 到 `right` 的每个延迟间隔内飞行次数的计数。在这里，我们可以生成一个新的 Bokeh 图，并添加一个指定适当参数的 quad glpyh：

``` Python
# 创建空白绘图
p = figure(plot_height = 600, plot_width = 600, 
           title = 'Histogram of Arrival Delays',
          x_axis_label = 'Delay (min)]', 
           y_axis_label = 'Number of Flights')

# 添加一个 quad glphy
p.quad(bottom=0, top=delays['flights'], 
       left=delays['left'], right=delays['right'], 
       fill_color='red', line_color='black')

# 显示绘图
show(p)
```

![](https://cdn-images-1.medium.com/max/800/1*afCD1sc8mNPYrZ2kh2jfxg.png)

生成此图的大部分工作都是在数据格式化过程中进行的，这在数据科学中并不常见！从我们的绘图中可以看出，延迟到达几乎是正态分布的，[右侧有一个轻微的正斜度或重尾巴](http://www.statisticshowto.com/probability-and-statistics/skewed-distribution/)。

有更简单的方法可以在 Python 中创建柱状图，也可以使用几行 `[matplotlib](https://en.wikipedia.org/wiki/Matplotlib)` 来获取相同的结果。但是，Bokeh 绘图所带来的的开发的好处在于，它可以提供将数据交互轻松地添加到图形中的工具和方法。

### 添加交互性

我们将在本系列中讨论的第一类交互是被动交互。这些是拥护可以采取的不改变显示数据的操作。它们被称为 [inspectors](https://bokeh.pydata.org/en/latest/docs/reference/models/tools.html)，因为他们允许用户查看更详细的“调查”数据。有用的 inspector 是当用户鼠标在数据点上移动并调用 [Bokeh 中的悬停工具](https://bokeh.pydata.org/en/latest/docs/user_guide/tools.html)时，会出现工具提示。

![](https://cdn-images-1.medium.com/max/800/1*3A33DOx2NL0h53SfsgPrzg.png)

基础的悬停工具提示

为了添加工具提示，我们需要将数据源从 dataframe 中更改为来自 [ColumnDataSource，Bokeh 中的一个关键概念。](https://bokeh.pydata.org/en/latest/docs/reference/models/sources.html)这是一个专门用于绘图的对象，它包含数据以及方法和属性。ColumnDataSource 允许我们在图中添加注解和交互，也可以从 pandas dataframe 中进行构建。真实数据被保存在字典中，可以通过 ColumnDataSource 的 data 属性访问。这里，我们从数据源进行创建源，并查看数据字典中与 dataframe 列对应的键。

``` Python
# 导入 ColumnDataSource 类
from bokeh.models import ColumnDataSource

# 将 dataframe 转换为 列数据源
src = ColumnDataSource(delays)
src.data.keys()

dict_keys(['flights', 'left', 'right', 'index'])
```

我们使用 CloumDataSource 添加 glyphs 时，我们将 CloumnDataSource 作为 `source` 参数传入，并使用字符串引用列名：

``` Python
# 这次添加一个带有源的 quad glyph
p.quad(source = src, bottom=0, top='flights', 
       left='left', right='right', 
       fill_color='red', line_color='black')
```

请注意，代码如何引用特定的数据列，比如 ‘flights’、‘left’ 和 ‘right’，而不是像以前那样使用  `df['column']` 格式。

#### Bokeh 中的 HoverTool

一开始，HoverTool 的语法看上去会有些复杂，但经过实践后，就会发现它们很容易创建。我们将 `HoverTool` 实例作为 `tooltips` 作为 [Python 元组](https://www.tutorialspoint.com/python/python_tuples.htm)传递给它，其中第一个元素是数据的标签，第二个元素引出我们要高亮显示的特定数据。我们可以使用 ‘$’ 引用图中任何属性，例如 x 或 y 的位置，也可以使用 ‘@’ 引用源中特定字段。这听起来可能有点令人困惑，所以这里有一个 HoverTool 的例子，我们在这两方面都可以这么做：

``` Python
# 使用 @ 引用我们自己的数据字段
# 使用 $ 在图上的位置悬停工具
h = HoverTool(tooltips = [('Delay Interval Left ', '@left'),
                          ('(x,y)', '($x, $y)')])
```

这里，我们使用 ‘@’ 引用 ColumnDataSource（它对应于原始 dataframe 的 ‘left’ 列）中的 `left` 数据字段，并使用 ‘$’ 引用光标的 (x,y) 位置。结果如下：

![](https://cdn-images-1.medium.com/max/800/1*fLiHCLkN15ZhCH9fk7GMXg.png)

显示不同数据引用的悬停工具提示

(x,y) 位置上是鼠标的位置，对我们的柱状图没有太大的帮助，因为我们要找到给定条形中对应于条形顶部的飞行术。为了修复这个问题，我们将要修改我们的工具提示实例来引用正确的列。格式化工具提示中的数据显示可能会让人沮丧，因此我通常在 dataframe 中使用正确的格式创建另一列。例如，如果我希望我的工具提示显示给定条的整个隔间，我会在数据框中创建一个格式化列：

``` Python
# 添加一个列，显示每个间隔的范围
delays['f_interval'] = ['%d to %d minutes' % (left, right) for left, right in zip(delays['left'], delays['right'])]
```

然后，我将 dataframe 转换为 CloumnDataSource，并在 HoverTool 调用中访问该列。下面的代码使用引用两个格式化列的悬停工具创建绘图，把那个将该工具添加到绘图中。

``` Python
# 创建一个空白绘图
p = figure(plot_height = 600, plot_width = 600, 
           title = 'Histogram of Arrival Delays',
          x_axis_label = 'Delay (min)]', 
           y_axis_label = 'Number of Flights')

# 这次，添加带有源的 quad glyph  
p.quad(bottom=0, top='flights', left='left', right='right', source=src,
       fill_color='red', line_color='black', fill_alpha = 0.75,
       hover_fill_alpha = 1.0, hover_fill_color = 'navy')

# 添加引用格式化列的悬停工具
hover = HoverTool(tooltips = [('Delay', '@f_interval'),
                             ('Num of Flights', '@f_flights')])

# 绘图样式
p = style(p)

# 将悬停工具添加到图中
p.add_tools(hover)

# 显示绘图
show(p)
```

在 Bokeh 样式中，我们以添加元素至原始的图中来将元素添加到表中。请注意，在 `p.quad` glyph 调用中，有几个额外的参数 `hover_fill_alpha` 和 `hover_fill_color`，当我们的鼠标移动到条图形时，这些参数会改变 glyph 的样式。我还添加了 `style` 函数（可在笔记中查看相关代码）。审美过程很无聊，所以通常我会写一个应用于任何绘图的函数。当我使用样式时，我会保持简单并专注于标签的可读性。绘图的主要目的是显示数据，添加不必要的元素只会[降低绘图的可用性](https://en.wikipedia.org/wiki/Chartjunk)！最后的绘图如下所示：

![](https://cdn-images-1.medium.com/max/800/1*3r9Ti_GFbByXTwamtq6jwA.png)

当我们的鼠标滑过不同的词条时，会得到该词条精确的统计数据，它表示间隔以及在该间隔内飞行的次数。如果对绘图比较满意，可以将其保存到 html 文件中进行共享：

``` Python
# 导入保存函数
from bokeh.io import output_file

# 指定输出文件并保存
output_file('hist.html')
show(p)
```

### 展望与总结

为了获取 Bokeh 的工作流程，我制作了很多次绘图，所以如果这看起来有很多东西要学的时候，不要担心。在本系列教程中，我们将得到更多的练习！虽然Bokeh 看起来似乎有很多工作要做，但是当我们想要将我们的视觉效果扩展到简单的静态图像之外的时候，它的好处就不言而喻了。一旦我们有了基本的图，我们就可以通过增加更多的元素来提高视觉效果。例如，如果我们想查看航空公司的延迟到达，我们可以制作一个交互式图，让用户选择和比较航空公司。我们将把主动交互（那些更改显示数据的交互）留到下一篇文章中，但下面是我们目前可以做的事情：

![](https://cdn-images-1.medium.com/max/800/1*avjUF5lUF-eYGs-N7OBPOg.gif)

主动交互需要编写更多的脚本，但这给了我们可以使用 Python 的机会！（如果有人想在下一篇文章之前看一下绘图的代码[可以在这里进行查看](https://github.com/WillKoehrsen/Bokeh-Python-Visualization/blob/master/interactive/histogram.py)。)

在本系列文章中，我想强调的是，Boken 或者任何一个库工具永远都不会是满足所有绘图需求的一站式解决工具。Bokeh 允许用户研究绘图，但对于其他应用，像简单的[探索性数据分析](https://en.wikipedia.org/wiki/Exploratory_data_analysis)，`matplotlib` 这样的轻量级库可能会更高效。本系列旨在为你提供绘图工具的另一种选择，这需要更加需求来进行抉择。你知道的库越多，就越能高效地使用可视化工具完成任务。

我一直以来都非常欢迎那些具有建设性的批评和反馈。你们可以在 Twitter [@koehrsen_will](http://twitter.com/@koehrsen_will) 上联系到我。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
