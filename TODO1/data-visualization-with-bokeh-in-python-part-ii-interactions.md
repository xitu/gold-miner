> * 原文地址：[Data Visualization with Bokeh in Python, Part II: Interactions](https://towardsdatascience.com/data-visualization-with-bokeh-in-python-part-ii-interactions-a4cf994e2512)
> * 原文作者：[Will Koehrsen](https://towardsdatascience.com/@williamkoehrsen?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/data-visualization-with-bokeh-in-python-part-ii-interactions.md](https://github.com/xitu/gold-miner/blob/master/TODO1/data-visualization-with-bokeh-in-python-part-ii-interactions.md)
> * 译者：[Starrier](https://github.com/Starrier)
> * 校对者：[TrWestdoor](https://github.com/TrWestdoor)

# 利用 Python 中 Bokeh 实现数据可视化，第二部分：交互

**超越静态图的图解**

本系列的[第一部分](https://towardsdatascience.com/data-visualization-with-bokeh-in-python-part-one-getting-started-a11655a467d4) 中，我们介绍了在 [Bokeh](https://bokeh.pydata.org/en/latest/)（Python 中一个强大的可视化库）中创建的一个基本柱状图。最后的结果显示了 2013 年从纽约市起飞的航班延迟到达的分布情况，如下所示（有一个非常好的工具提示）：

![](https://cdn-images-1.medium.com/max/800/1*rNBU4zoqIk_iEzMGufiRhg.png)

这张表完成了任务，但并不是很吸引人！用户可以看到航班延迟的几乎是正常的（有轻微的斜率），但他们没有理由在这个数字上花几秒钟以上的时间。

如果我们想创建更吸引人的可视化数据，可以允许用户通过交互方式来获取他们想要的数据。比如，在这个柱状图中，一个有价值的特性是能够选择指定航空公司进行比较，或者选择更改容器的宽度来更详细地检查数据。辛运的是，我们可以使用 Bokeh 在现有的绘图基础上添加这两个特性。柱状图的最初开发似乎只涉及到了一个简单的图，但我们现在即将体验到像 Bokeh 这样的强大的库的所带来的好处！

本系列的所有代码[都可在 GitHub 上获得](https://github.com/WillKoehrsen/Bokeh-Python-Visualization/tree/master/interactive)。任何感兴趣的人都可以查看所有的数据清洗细节（数据科学中一个不那么鼓舞人心但又必不可少的部分），也可以亲自运行它们！（对于交互式 Bokeh 图，我们仍然可以使用 Jupyter Notebook 来显示结果，我们也可以编写 Python 脚本，并运行 Bokeh 服务器。我通常使用 Jupyter Notebook 进行开发，因为它可以在不重启服务器的情况下，就可以很容易的快速迭代和更改绘图。然后我将它们迁移到服务器中来显示最终结果。你可以在 GitHub 上看到一个独立的脚本和完整的笔记）。

### 主动的交互

在 Bokeh 中，有两类交互：被动的和主动的。第一部分所描述的被动交互也称为 inspectors，因为它们允许用户更详细地检查一个图，但不允许更改显示的信息。比如，当用户悬停在数据点上时出现的工具提示：

![](https://cdn-images-1.medium.com/max/800/1*3A33DOx2NL0h53SfsgPrzg.png)

工具提示，被动交互器

第二类交互被称为 active，因为它更改了显示在绘图上的实际数据。这可以是从选择数据的子集（例如指定的航空公司）到改变匹配多项式回归拟合程度中的任何数据。在 Bokeh 中有多种类型的 [active 交互](https://bokeh.pydata.org/en/latest/docs/user_guide/interaction.html)，但这里我们将重点讨论“小部件”，可以被单击，而且用户能够控制某些绘图方面的元素。

![](https://cdn-images-1.medium.com/max/600/1*3DV5TiCbiSSmEck5BhOjnQ.png)

![](https://cdn-images-1.medium.com/max/600/1*1lcSC9fMxSd2nqul_twj2Q.png)

小部件示例（下拉按钮和单选按钮组）

当我查看图时，我喜欢主动的交互（[比如那些在 FlowingData 上的交互](http://flowingdata.com/2018/01/23/the-demographics-of-others/)），因为它们允许我自己去研究数据。我发现让人印象更深刻的是从我自己的数据中发现的结论（从设计者那里获取的一些研究方向），而不是从一个完全静态的图表中发现的结论。此外，给予用户一定程度的自由，可以让他们对数据集提出更有用的讨论，从而产生不同的解释。

### 交互概述

一旦我们开始添加主动交互，我们就需要越过单行代码，深入封装特定操作的函数。对于 Bokeh 小部件的交互，有三个主要函数可以实现：

*   `make_dataset()` 格式化想要显示的特定数据
*   `make_plot()` 用指定的数据进行绘图
*   `update()` 基于用户选择来更新绘图

#### 格式化数据

在我们绘制这个图之前，我们需要规划将要显示的数据。对于我们的交互柱状图，我们将为用户提供三个可控参数：

1.  航班显示（在代码中称为运营商）
2.  绘图中的时间延迟范围，例如：-60 到 120 分钟
3.  默认情况下，柱状图的容器宽度是 5 分钟

对于生成绘图数据集的函数，我们需要允许指定每个参数。为了告诉我们如何转换 `make_dataset` 函数中的数据，我们需要加载所有相关数据进行检查。

![](https://cdn-images-1.medium.com/max/800/1*oGphn8rw5GEmy9-tnHanuA.png)

柱状图数据

在此数据集中，每一行都是一个单独的航班。 `arr_delay` 列是航班到达延误数分钟（负数表示航班提前到达）。在第一部分中，我们做了一些数据探索，知道有 327，236 次航班，最小延误时间为 - 86 分钟，最大延误时间为 1272 分钟。在 `make_dataset` 函数中，我们想基于 dataframe 中的 `name` 列来选择公司，并用 `arr_delay` 列来限制航班。

为了生成柱状图的数据，我们使用 numpy 函数 `histogram` 来统计每个容器中的数据点数。在我们的示例中，这是每个指定延迟间隔中的航班数。对于第一部分，我们做了一个包含所有航班的柱状图，但现在我们会为每一个运营商都提供一个柱状图。由于每个航空公司的航班数目有很大差异，我们可以显示延迟而不是按原始数目显示，可以按比例显示。也就是说，图上的高度对应于特定航空公司的所有航班比例，该航班在相应的容器中有延迟。从计数到比例，我们除以航空公司的总数。

下面是生成数据集的完整代码。函数接受我们希望包含的运营商列表，要绘制的最小和最大延迟，以及制定的容器宽度（以分钟为单位）。

``` Python
def make_dataset(carrier_list, range_start = -60, range_end = 120, bin_width = 5):

    # 为了确保起始点小于终点而进行检查
    assert range_start < range_end, "Start must be less than end!"
    
    by_carrier = pd.DataFrame(columns=['proportion', 'left', 'right', 
                                       'f_proportion', 'f_interval',
                                       'name', 'color'])
    range_extent = range_end - range_start
    
    # 遍历所有运营商
    for i, carrier_name in enumerate(carrier_list):

        # 运营商子集
        subset = flights[flights['name'] == carrier_name]

        # 创建具有指定容器和范围的柱状图
        arr_hist, edges = np.histogram(subset['arr_delay'], 
                                       bins = int(range_extent / bin_width), 
                                       range = [range_start, range_end])

        # 将极速除以总数，得到一个比例，并创建 df
        arr_df = pd.DataFrame({'proportion': arr_hist / np.sum(arr_hist), 
                               'left': edges[:-1], 'right': edges[1:] })

        # 格式化比例
        arr_df['f_proportion'] = ['%0.5f' % proportion for proportion in arr_df['proportion']]

        # 格式化间隔
        arr_df['f_interval'] = ['%d to %d minutes' % (left, right) for left, 
                                right in zip(arr_df['left'], arr_df['right'])]

        # 为标签指定运营商
        arr_df['name'] = carrier_name

        # 不同颜色的运营商
        arr_df['color'] = Category20_16[i]

        # 添加到整个 dataframe 中
        by_carrier = by_carrier.append(arr_df)

    # 总体 dataframe
    by_carrier = by_carrier.sort_values(['name', 'left'])
    
    # 将 dataframe 转换为列数据源
    return ColumnDataSource(by_carrier)
```

(我知道这是一篇关于 Bokeh 的博客，但在你不能在没有格式化数据的情况下来生成图表，因此我使用了相应的代码来演示我的方法！)

运行带有所需运营商的函数结果如下：

![](https://cdn-images-1.medium.com/max/800/1*yKvJztYW6m6k07FxaqdadQ.png)

作为提醒，我们使用 Bokeh `quad` 表来制作柱状图，因此我们需要提供表的左、右和顶部（底部将固定为 0）。它们分别在罗列在 `left`、`right` 以及 `proportion`。颜色列为每个运营商提供了唯一的颜色，`f_` 列为工具提供了格式化文本的功能。

下一个要实现的函数是 `make_plot`。函数应该接受 ColumnDataSource [(Bokeh 中用于绘图的一种特定类型对象)](https://bokeh.pydata.org/en/latest/docs/reference/models/sources.html)并返回绘图对象：

``` Python
def make_plot(src):
        # 带有正确标签的空白图
        p = figure(plot_width = 700, plot_height = 700, 
                  title = 'Histogram of Arrival Delays by Carrier',
                  x_axis_label = 'Delay (min)', y_axis_label = 'Proportion')

        # 创建柱状图的四种符号
        p.quad(source = src, bottom = 0, top = 'proportion', left = 'left', right = 'right',
               color = 'color', fill_alpha = 0.7, hover_fill_color = 'color', legend = 'name',
               hover_fill_alpha = 1.0, line_color = 'black')

        # vline 模式下的悬停工具
        hover = HoverTool(tooltips=[('Carrier', '@name'), 
                                    ('Delay', '@f_interval'),
                                    ('Proportion', '@f_proportion')],
                          mode='vline')

        p.add_tools(hover)

        # Styling
        p = style(p)

        return p 
```

如果我们向所有航空公司传递一个源，此代码将给出以下绘图：

![](https://cdn-images-1.medium.com/max/800/1*-IcPPBWctsiOuh870pRbJg.png)

这个柱状图非常混乱，因为 16 家航空公司都绘制在同一张图上！因为信息被重叠了，所以如果我们想比较航空公司就显得不太现实。辛运的是，我们可以添加小部件来使绘制的图更清晰，也能够进行快速地比较。

#### 创建可交互的小部件

一旦我们在 Bokeh 中创建一个基础图形，通过小部件添加交互就相对简单了。我们需要的第一个小部件是允许用户选择要显示的航空公司的选择框。这是一个允许根据需要进行尽可能多的选择的复选框控件，在 Bokeh 中称为T `CheckboxGroup.`。为了制作这个可选工具，我们需要导入 `CheckboxGroup` 类来创建带有两个参数的实例，`labels`：我们希望显示每个框旁边的值以及 `active`：检查选中的初始框。以下创建的 `CheckboxGroup` 代码中附有所需的运营商。

``` Python
from bokeh.models.widgets import CheckboxGroup

# 创建复选框可选元素，可用的载体是
# 数据中所有航空公司组成的列表
carrier_selection = CheckboxGroup(labels=available_carriers, 
                                  active = [0, 1])
```

![](https://cdn-images-1.medium.com/max/600/1*XpJfjyKacHR2VwdCIed-wA.png)

CheckboxGroup 部件

Bokeh 复选框中的标签必须是字符串，但激活值需要的是整型。这意味着在在图像 ‘AirTran Airways Corporation’ 中，激活值为 0，而 ‘Alaska Airlines Inc.’ 激活值为 1。当我们想要将选中的复选框与 airlines 想匹配时，我们需要确保所选的**整型**激活值能匹配与之对应的**字符串**。我们可以使用部件的 `.labels` 和 `.active` 属性来实现。

``` Python
# 从选择值中选择航空公司的名称
[carrier_selection.labels[i] for i in carrier_selection.active]

['AirTran Airways Corporation', 'Alaska Airlines Inc.']
```

在制作完小部件后，我们现在需要将选中的航空公司复选框链接到图表上显示的信息中。这是使用 CheckboxGroup 的 `.on_change` 方法和我们定义的 `update` 函数完成的。update 函数总是具有三个参数：`attr、old、new`，并基于选择控件来更新绘图。改变图形上显示的数据的方式是改变我们传递给 `make_plot` 函数中的图形的数据源。这听起来可能有点抽象，因此下面是一个 `update` 函数的示例，该函数通过更改柱状图来显示选定的航空公司：

``` Python
# update 函数有三个默认参数
def update(attr, old, new):
    # Get the list of carriers for the graph
    carriers_to_plot = [carrier_selection.labels[i] for i in
                        carrier_selection.active]

    # 根据被选中的运营商和
    # 先前定义的 make_dataset 函数来创建一个新的数据集
    new_src = make_dataset(carriers_to_plot,
                           range_start = -60,
                           range_end = 120,
                           bin_width = 5)

    # update 在 quad glpyhs 中使用的源
    src.data.update(new_src.data)
```

这里，我们从 CheckboxGroup 中检索要基于选定航空公司显示的航空公司列表。这个列表被传递给 `make_dataset` 函数，它返回一个新的列数据源。我们通过调用 `src.data.update` 以及传入来自新源的数据更新图表中使用的源数据。最后，为了将 `carrier_selection` 小部件中的更改链接到 `update` 函数，我们必须使用 `.on_change` 方法（称为[事件处理器](https://bokeh.pydata.org/en/latest/docs/user_guide/interaction/widgets.html)）。

``` Python
# 将选定按钮中的更改链接到 update 函数
carrier_selection.on_change('active', update)
```

在选择或取消其他航班的时会调用 update 函数。最终结果是在柱状图中只绘制了与选定航空公司相对应的符号，如下所示：

![](https://cdn-images-1.medium.com/max/800/1*z36QoTv4AnbJqHLmKkLTZQ.gif)

#### 更多控件

现在我们已经知道了创建控件的基本工作流程，我们可以添加更多元素。我们每次创建小部件时，编写 update 函数来更改显示在绘图上的数据，通过事件处理器来将 update 函数链接到小部件。我们甚至可以通过重写函数来从多个元素中使用相同的 update 函数来从小部件中提取我们所需的值。在实践过程中，我们将添加两个额外的控件：一个用于选择柱状图容器宽度的 Slider，另一个是用于设置最小和最大延迟的 RangeSlider。下面是生成这些小部件和 update 函数的代码：

``` Python
# 滑动 bindwidth，对应的值就会被选中
binwidth_select = Slider(start = 1, end = 30, 
                     step = 1, value = 5,
                     title = 'Delay Width (min)')
# 当值被修改时，更新绘图
binwidth_select.on_change('value', update)

# RangeSlider 用于修改柱状图上的最小最大值
range_select = RangeSlider(start = -60, end = 180, value = (-60, 120),
                           step = 5, title = 'Delay Range (min)')

# 当值被修改时，更新绘图
range_select.on_change('value', update)


# 用于 3 个控件的 update 函数
def update(attr, old, new):
    
    # 查找选定的运营商
    carriers_to_plot = [carrier_selection.labels[i] for i in carrier_selection.active]
    
    # 修改 binwidth 为选定的值
    bin_width = binwidth_select.value

    # 范围滑块的值是一个元组（开始，结束）
    range_start = range_select.value[0]
    range_end = range_select.value[1]
    
    # 创建新的列数据
    new_src = make_dataset(carriers_to_plot,
                           range_start = range_start,
                           range_end = range_end,
                           bin_width = bin_width)

    # 在绘图上更新数据
    src.data.update(new_src.data)
```

标准滑块和范围滑块如下所示：

![](https://cdn-images-1.medium.com/max/800/1*QlrjWBxnHcBjHp24Xq2M3Q.png)

只要我们想，出了使用 update 函数显示数据之外，我们也可以修改其他的绘图功能。例如，为了将标题文本与容器宽度匹配，我们可以这样做：

``` Python
# 将绘图标题修改为匹配选择
bin_width = binwidth_select.value
p.title.text = 'Delays with %d Minute Bin Width' % bin_width
```

在 Bokeh 中海油许多其他类型的交互，但现在，我们的三个控件允许运行在图标上“运行”！

### 把所有内容放在一起

我们的所有交互式绘图元素都已经说完了。我们有三个必要的函数：`make_dataset`、`make_plot` 和 `update`，基于控件和系哦啊不见自身来更改绘图。我们通过定义布局将所有这些元素连接到一个页面上。

``` Python
from bokeh.layouts import column, row, WidgetBox
from bokeh.models import Panel
from bokeh.models.widgets import Tabs

# 将控件放在单个元素中
controls = WidgetBox(carrier_selection, binwidth_select, range_select)
    
# 创建行布局
layout = row(controls, p)
    
# 使用布局来创建一个选项卡
tab = Panel(child=layout, title = 'Delay Histogram')
tabs = Tabs(tabs=[tab])
```

我将整个布局放在一个选项卡上，当我们创建一个完整的应用程序时，我们可以为每个绘图都创建一个单独的选项卡。最后的工作结果如下所示：

![](https://cdn-images-1.medium.com/max/800/1*5xN0M2CT1yAvpnzWM-bMhg.gif)

可以在 [GitHub](https://github.com/WillKoehrsen/Bokeh-Python-Visualization/tree/master/interactive/exploration) 上查看相关代码，并绘制自己的绘图。

### 下一步和内容

本系列的下一部分将讨论如何使用多个绘图来制作一个完整的应用程序。我们将通过服务器来展示我们的工作结果，可以通过浏览器对其进行访问，并创建一个完整的仪表盘来探究数据集。

我们可以看到，最终的互动绘图比原来的有用的多！我们现在可以比较航空公司之间的延迟，并更改容器的宽度/范围，来了解这些分布是如何被影响的。增加的交互性提高了绘图的价值，因为它增加了对数据的支持，并允许用户通过自己的探索得出结论。尽管设置了初始化的绘图，但我们仍然可以看到如何轻松地将元素和控件添加到现有的图形中。与像 matplotlib 这样快速简单的绘图库相比，使用更重的绘图库（比如 bokeh）可以定制化绘图和交互。不同的可视化库有不同的优点和用例，但当我们想要增加交互的额外维度时，Bokeh 是一个很好的选择。希望在这一点上，你有足够的信心来开发你自己的可视化绘图，也希望看到你可以分享自己的创作。

欢迎向我反馈以及建设性的批评，可以在 Twitter [@koehrsen_will](https://twitter.com/koehrsen_will) 上和我联系。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
