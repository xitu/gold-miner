> * 原文链接 : [Core Plot Tutorial: Getting Started](https://www.raywenderlich.com/131985/core-plot-tutorial-getting-started)
* 原文作者 : [Attila Hegedüs](https://www.raywenderlich.com/u/cynicalme)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [llp0574](https://github.com/llp0574)
* 校对者: [yifili09](https://github.com/yifili09),[cdpath](https://github.com/cdpath)

# iOS 开源图形库 Core Plot 使用教程 


![Alt 使用Core Plot绘制饼图，柱状图，散点图及更多！](http://ac-Myg6wSTV.clouddn.com/868c57b7dfa6957573cd.png)

_注意_ ：本篇教程已被 Attila Hegedüs 更新，可适用于 iOS 9 和 Swift 2.2。原始教程出自教程组成员 Steve Baranski。

如果你曾经想在自己的 app 中引入图表或图形，那么你应该已经考虑过下面两种选项：

1.  _自己写。_ 通过使用 Core Graphics 或者 Quartz 这样的框架编写全部的绘制代码。然而，这显然要花费大量的功夫。
2.  _买一个！_ 购买一个像 [ShinobiControls](http://www.shinobicontrols.com) 这样的商业型框架。这或许可以节省你的时间，但就要花钱啦。

但是如果你不想花费时间和精力从零开始写(代码)，也不想花那么多钱，该怎么办呢？这时候第三个选项就派上用场了：使用开源库 [Core Plot](https://github.com/core-plot/core-plot)！

Core Plot 是一个2D绘制库，适用于 iOS，Mac OS X 和 tvOS。它使用了像 Quartz 和 Core Animation 这样的苹果应用框架，同时有着全面的测试覆盖，而且是遵照BSD这个比较宽松的许可证进行发布的。

在这个教程中，你将学习到如何使用 Core Plot 来创建饼图和柱状图，同时还会实现一些很酷的图表交互！

开始之前，你需要安装好 _Xcode 7.3_ ，同时对 _Swift_ ， _Interface Builder_ 和 _storyboards_ 有所了解。如果你对这些主题知之甚少，那么你应该在继续阅读本教程之前先学习一下我们其他的一些[教程](https://www.raywenderlich.com/?page_id=2519)。

本教程同时还使用了 CocoaPods 去安装一些第三方的依赖库。如果你从来没使用过 CocoaPods 的话，那你还应该阅读一下我们关于它的[教程](https://www.raywenderlich.com/97014/use-cocoapods-with-swift)。

## 入门

在本教程中，你将创建一个在一定时间间隔内显示货币汇率(情况)的 App。从[这里](https://cdn2.raywenderlich.com/wp-content/uploads/2016/05/SwiftRates_Starter-2.zip)下载本教程的入门项目，把它解压缩后打开 _SwiftRates.xcworkspace_ 。

项目的关键类在 _App_ 这个文件夹和它的子文件夹下，它们包括了：

*   _DataStore.swift_ 这是一个从 [Fixer.io](http://fixer.io/) 请求货币汇率数据的帮助类。
*   _Rate.swift_ 这是一个模型，表示给定日期里的货币汇率。
*   _Currency.swift_ 这是一个表示货币类型的模型。支持的货币类型定义在 _Resources/Currencies.plist_ 里。
*   _MenuViewController.swift_ 这是一个app启动后展示的第一个视图控制器。它让用户选择一个货币作为基准然后再选两个对照。
*   _HostViewController.swift_ 这是一个容器视图控制器，基于它的分段选项选中状态去控制展示 `PieChartViewController` 或者 `BarGraphViewController` 的内容。它还会去检查从 `DataStore` 请求来的汇率数据，因为它们也将在这个视图控制器里展现。
*   _PieChartViewController.swift_ 这个控制器将用饼图的形式展示一个给定日期里的汇率。当然你首先要实现它！
*   _BarGraphViewController.swift_ 这个控制器将以柱状图的形式展示几天的汇率。当你掌握绘制饼图的方法后，这个图简直小菜一碟！（看到我做的事情了吗？拜托，这真的有点意思！）;]

构建并运行看看这个教程入门项目实际展示。

![](http://ac-Myg6wSTV.clouddn.com/f9346c33b479bfc2a302.png)

点选 _Get Rates_ 导航去到 `HostViewController` 控制的视图然后可以切换分段选项。这个 app 确实还没有实现太多功能...;]

是时候用 Core Plot 开始真正的绘制了！

### 安装 Core Plot

首先你需要安装 Core Plot，最简单的方式是通过 [CocoaPods](https://cocoapods.org/) 安装。

把下面这行代码添加进你的 _Podfile_ 文件， `pod 'SwiftDate'` 这行的后面：

    pod 'CorePlot', '~> 2.1'

打开 _Terminal_ （终端），`cd` 进入你的项目根目录，然后运行 `pod install`。

安装完成后，构建项目。

没报错吧？很好，现在你可以随便使用 Core Plot 啦，感谢 CocoaPods。:]

如果你遇到了任何报错，可以尝试通过 `sudo gem install cocoapods` 更新一下 CocoaPods 然后再次运行 `pod install`。

## 创建饼图

打开 _PieChartViewController.swift_ 并添加下面这行引入：

    import CorePlot

接着，添加下面这个属性：



    @IBOutlet weak var hostView: CPTGraphHostingView!



`CPTGraphHostingView` 负责“托管”一个图表或图形。你可以把它想象成一个“图形容器”。

然后，把下面这个类扩展添加到文件结尾的花括号之后：



    extension PieChartViewController: CPTPieChartDataSource, CPTPieChartDelegate {

      func numberOfRecordsForPlot(plot: CPTPlot) -> UInt {
        return 0
      }

      func numberForPlot(plot: CPTPlot, field fieldEnum: UInt, recordIndex idx: UInt) -> AnyObject? {
        return 0
      }

      func dataLabelForPlot(plot: CPTPlot, recordIndex idx: UInt) -> CPTLayer? {
        return nil
      }

      func sliceFillForPieChart(pieChart: CPTPieChart, recordIndex idx: UInt) -> CPTFill? {
        return nil
      }

      func legendTitleForPieChart(pieChart: CPTPieChart, recordIndex idx: UInt) -> String? {
        return nil
      }
    }



你将通过 `CPTPieChartDataSource` 为一个 Core Plot 图表提供数据，同时你会通过 `CPTPieChartDelegate` 得到用户交互的所有事件。随着教程递进，你将填满这些方法。

### 建立图表托管视图

继续往下，打开 _Main.storyboard_ 然后选择 `PieChartViewController` 窗口。

在这个视图上拖出一个新的 `UIView`，然后把它的类更改成 `CPTGraphHostingView`，并将它连接到 `hostView`。

对这个视图的每个方向添加约束让撑满父视图，并确认没有设置外边距的约束：

![](https://cdn2.raywenderlich.com/wp-content/uploads/2016/04/swiftrates-05.png)

设置一个你喜欢的背景色。我使用了透明度为92%的灰度颜色。

现在回到 _PieChartViewController.swift_ ，在 `viewDidLoad()` 后面添加下面的方法：



    override func viewDidLayoutSubviews() {
      super.viewDidLayoutSubviews()
      initPlot()
    }

    func initPlot() {
      configureHostView()
      configureGraph()
      configureChart()
      configureLegend()
    }

    func configureHostView() {
    }

    func configureGraph() {
    }

    func configureChart() {
    }

    func configureLegend() {
    }



这样子就正好在子视图渲染好后设置了绘制策略。这里是你最早为视图设置框架大小的地方，接下来你将需要配置绘制策略。

`initPlot()` 里的每个方法都代表了一个设置绘制策略的阶段。这样子可以让代码保持其可维护性。

把下面这行添加进 `configureHostView()`：



    hostView.allowPinchScaling = false



这行代码将对饼图禁用手势捏合缩放，它决定了托管视图对捏合手势是否会有反应。

接下来你需要添加一个图表到`hostView`。添加下面的代码到 `configureGraph()` 里吧：



    // 1 - Create and configure the graph
    let graph = CPTXYGraph(frame: hostView.bounds)
    hostView.hostedGraph = graph
    graph.paddingLeft = 0.0
    graph.paddingTop = 0.0
    graph.paddingRight = 0.0
    graph.paddingBottom = 0.0
    graph.axisSet = nil

    // 2 - Create text style
    let textStyle: CPTMutableTextStyle = CPTMutableTextStyle()
    textStyle.color = CPTColor.blackColor()
    textStyle.fontName = "HelveticaNeue-Bold"
    textStyle.fontSize = 16.0
    textStyle.textAlignment = .Center

    // 3 - Set graph title and text style
    graph.title = "\(base.name) exchange rates\n\(rate.date)"
    graph.titleTextStyle = textStyle
    graph.titlePlotAreaFrameAnchor = CPTRectAnchor.Top



下面对每个部分的代码进行分解：

1.  首先你创建了一个 `CPTXYGraph` 的实例并指定它作为 `hostView` 的 `hostedGraph`。这就将图表和托管视图联系起来了。

    这个 `CPTGraph` 包括了你所看到的标准图表或图形的全部东西：边，标题，绘制相关数据，轴和图例。

    默认情况下，`CPTXYGraph` 每个方向都有一个`20`的内边距。从我们这个项目来看这样并不好，所以你可以显式地将每个方向的内边距设置为`0`。

2.  接下来就是通过创建和配置一个 `CPTMutableTextStyle` 实例来设置该图标标题的文本样式。
3.  最后，就是给你刚刚创建的图表实例设置标题和其样式。同样你还需要指定标题锚点为该视图的上边界。

构建并运行app，你应该就可以看到这个图表的标题展示在屏幕上了：

![Core Plot Tutorial](http://ac-Myg6wSTV.clouddn.com/fd0411a63ef0affb512a.png)

### 绘制饼图

标题看起来不错，但你知道接下来什么会更棒吗？确确实实地看到饼图！

将下面的代码添加进 `configureChart()`：



    // 1 - Get a reference to the graph
    let graph = hostView.hostedGraph!

    // 2 - Create the chart
    let pieChart = CPTPieChart()
    pieChart.delegate = self
    pieChart.dataSource = self
    pieChart.pieRadius = (min(hostView.bounds.size.width, hostView.bounds.size.height) * 0.7) / 2
    pieChart.identifier = graph.title
    pieChart.startAngle = CGFloat(M_PI_4)
    pieChart.sliceDirection = .Clockwise
    pieChart.labelOffset = -0.6 * pieChart.pieRadius

    // 3 - Configure border style
    let borderStyle = CPTMutableLineStyle()
    borderStyle.lineColor = CPTColor.whiteColor()
    borderStyle.lineWidth = 2.0
    pieChart.borderLineStyle = borderStyle

    // 4 - Configure text style
    let textStyle = CPTMutableTextStyle()
    textStyle.color = CPTColor.whiteColor()
    textStyle.textAlignment = .Center
    pieChart.labelTextStyle = textStyle

    // 3 - Add chart to graph
    graph.addPlot(pieChart)



下面看看这段代码做了什么：

1.  首先获取了刚刚创建的图表的引用。
2.  然后实例化一个 `CPTPieChart`，将它的代理和数据源设置成这个视图控制器本身，并配置它的一些外观属性。
3.  接着配置这个图表的边框样式。
4.  配置它的文本样式。
5.  最后，将这个饼图添加进刚刚引用的图表里。

如果现在重新构建并运行 app，你将看不到任何变化...因为你还需要实现这个饼图的代理和数据源。

首先，用下面这段替代了现在的 `numberOfRecordsForPlot(_:)` 方法：



    func numberOfRecordsForPlot(plot: CPTPlot) -> UInt {
      return UInt(symbols.count) ?? 0
    }



这个方法决定了有多少块(部分)显示在饼状图上，它将为每一个标记显示一块(部分)。

接下来，用下面这段替换掉 `numberForPlot(_:field:recordIndex:)` ：



    func numberForPlot(plot: CPTPlot, field fieldEnum: UInt, recordIndex idx: UInt) -> AnyObject? {
      let symbol = symbols[Int(idx)]
      let currencyRate = rate.rates[symbol.name]!.floatValue
      return 1.0 / currencyRate
    }



饼图会使用这个方法得到索引为 `recordIndex` 的货币符号的“总”值。

你应该注意到这个值并 _不是_ 一个百分比值。取而代之的是，这个方法计算出了相对基准货币的货币汇率：返回的这个 `1.0 / currencyRate` 的值是"一个单位的基准货币是多少价值的另外的对照货币"的汇率。

`CPTPieChart` 将查看计算每个分块的百分比值，这个值最终决定了这个分块占多大。

下面，用下面这行替代掉 `dataLabelForPlot(_:recordIndex:)` ：



    func dataLabelForPlot(plot: CPTPlot, recordIndex idx: UInt) -> CPTLayer? {
      let value = rate.rates[symbols[Int(idx)].name]!.floatValue
      let layer = CPTTextLayer(text: String(format: "\(symbols[Int(idx)].name)\n%.2f", value))
      layer.textStyle = plot.labelTextStyle
      return layer
    }



这个方法返回了饼图分片的标签。期望的返回类型 `CPTLayer` 和 `CALayer` 有点相似，但是 CPTLayer 更加抽象，在 Mac OS X 和 iOS 上都能用，还提供了额外的绘图细节供 Core Plot 使用。

这里，创建并返回一个 `CPTLayer` 的子类 `CPTTextLayer` 去展示文本。

最后，将下面这段代码替换掉 `sliceFillForPieChart(_:, recordIndex:)` 去添加分片的颜色：



    func sliceFillForPieChart(pieChart: CPTPieChart, recordIndex idx: UInt) -> CPTFill? {
      switch idx {
      case 0:   return CPTFill(color: CPTColor(componentRed:0.92, green:0.28, blue:0.25, alpha:1.00))
      case 1:   return CPTFill(color: CPTColor(componentRed:0.06, green:0.80, blue:0.48, alpha:1.00))
      case 2:   return CPTFill(color: CPTColor(componentRed:0.22, green:0.33, blue:0.49, alpha:1.00))
      default:  return nil
      }
    }



构建并运行，你就将看到一个漂亮的饼图了：

![Core Plot Tutorial](http://ac-Myg6wSTV.clouddn.com/17097b407bd6dbdcc299.png)

### 等一下...图例呢！

这个图表看上去相当不错，但是添加一个图例应该会让它更棒。接下来你将学习怎么添加一个图例到这个图表里。

首先，用下面这段替换掉 `configureLegend()`：



    func configureLegend() {
      // 1 - Get graph instance
      guard let graph = hostView.hostedGraph else { return }

      // 2 - Create legend
      let theLegend = CPTLegend(graph: graph)

      // 3 - Configure legend
      theLegend.numberOfColumns = 1
      theLegend.fill = CPTFill(color: CPTColor.whiteColor())
      let textStyle = CPTMutableTextStyle()
      textStyle.fontSize = 18
      theLegend.textStyle = textStyle

      // 4 - Add legend to graph
      graph.legend = theLegend
      if view.bounds.width > view.bounds.height {
        graph.legendAnchor = .Right
        graph.legendDisplacement = CGPoint(x: -20, y: 0.0)

      } else {
        graph.legendAnchor = .BottomRight
        graph.legendDisplacement = CGPoint(x: -8.0, y: 8.0)
      }
    }



同样你也需要为每个分片提供图例的数据。

要提供数据，就用下面这段替换掉 `legendTitleForPieChart(_:recordIndex:)`：



    func legendTitleForPieChart(pieChart: CPTPieChart, recordIndex idx: UInt) -> String? {
      return symbols[Int(idx)].name
    }



构建并运行，你就会得到一个“带图例的”图表啦。

![Core Plot Tutorial](http://ac-Myg6wSTV.clouddn.com/98244c1f592db447f90a.png)

## 创建柱状图

看样子你已经是绘制饼图的专家啦，但是时候去搞一个柱状图了！

打开 `BarGraphViewController` 并添加下面这行：

    import CorePlot

接着，再添加下面这行：



    @IBOutlet var hostView: CPTGraphHostingView!



其实就和饼图一样，托管视图将承载这个柱状图的展示。

下一步，添加下面这些属性：



    var plot1: CPTBarPlot!
    var plot2: CPTBarPlot!
    var plot3: CPTBarPlot!



这里声明了三个 `CPTBarPlot` 类型的属性，它们就相当于展示在图表中的每种货币。

注意到同样也有三个 `IBOutlet` 标签和三个 `IBAction` 方法已经被定义了，你都可以在 storyboard 上看到它们。

最后，把下面这个类扩展添加到文件末尾：



    extension BarGraphViewController: CPTBarPlotDataSource, CPTBarPlotDelegate {

      func numberOfRecordsForPlot(plot: CPTPlot) -> UInt {
        return 0
      }

      func numberForPlot(plot: CPTPlot, field fieldEnum: UInt, recordIndex idx: UInt) -> AnyObject? {
        return 0
      }

      func barPlot(plot: CPTBarPlot, barWasSelectedAtRecordIndex idx: UInt, withEvent event: UIEvent) {

      }
    }



这和创建饼图的过程太像了：通过 `CPTBarPlotDataSource` 为柱状图提供数据，通过 `CPTBarPlotDelegate` 捕捉用户交互事件。你只需要复制粘贴就好了。

### 再次配置图表托管视图

就像刚刚创建饼图时候一样，再次需要通过界面生成器把托管视图添加进去。

回到 _Main.storyboard_ 并选择 `BarGraphViewController` 窗口。

在视图上拖拽出一个新的 `UIView`，将它的类更改为 `CPTGraphHostingView` 并将其输出连接到控制器里的 `hostView`。

通过 _Utilities\Size Inspector_ （那个 _刻度尺_ 选项卡）将它的框架更新到下面那样：

_X = 0, Y = 53, Width = 600, Height = 547_

![](http://ww1.sinaimg.cn/large/a490147fjw1f5tbltfjfpj20dc07oaam.jpg)

添加它和所有相邻元素的约束，确认没有设置 _外边距约束_ 。

![](https://cdn5.raywenderlich.com/wp-content/uploads/2016/05/BarGraph_HostView_Constraints.png)

最后，设置一个你喜欢的背景颜色。我再次用了92%透明度的灰度颜色。

### 绘制柱状图

既然 UI 已经通过上面的学习全部弄好了，是时候去绘制一个柱状图了。

首先，回到 `BarGraphViewController`，你需要一对常量属性。把下面这段添加到其他属性之前：



    let BarWidth = 0.25
    let BarInitialX = 0.25



你还需要一个帮助函数去计算最高的率值。把下面这段添加到 `updateLabels()`之后：



    func highestRateValue() -> Double {
      var maxRate = DBL_MIN
      for rate in rates {
        maxRate = max(maxRate, rate.maxRate().doubleValue)
      }
      return maxRate
    }



接着，把下面的方法添加到 `highestRateValue()` 之后：



    override func viewDidLayoutSubviews() {
      super.viewDidLayoutSubviews()
      initPlot()
    }

    func initPlot() {
      configureHostView()
      configureGraph()
      configureChart()
      configureAxes()
    }

    func configureHostView() {
    }

    func configureGraph() {
    }

    func configureChart() {
    }

    func configureAxes() {
    }



是不是看上去很眼熟？是的，这些和之前的结构完全一样。

下面这行添加到 `configureHostView()` 里：



    hostView.allowPinchScaling = false



因为你不需要捏合缩放，所以你应该再次把它禁用。

接着，把下面那么多行代码添加到 `configureGraph()` 里：



    // 1 - Create the graph
    let graph = CPTXYGraph(frame: hostView.bounds)
    graph.plotAreaFrame?.masksToBorder = false
    hostView.hostedGraph = graph

    // 2 - Configure the graph
    graph.applyTheme(CPTTheme(named: kCPTPlainWhiteTheme))
    graph.fill = CPTFill(color: CPTColor.clearColor())
    graph.paddingBottom = 30.0
    graph.paddingLeft = 30.0
    graph.paddingTop = 0.0
    graph.paddingRight = 0.0

    // 3 - Set up styles
    let titleStyle = CPTMutableTextStyle()
    titleStyle.color = CPTColor.blackColor()
    titleStyle.fontName = "HelveticaNeue-Bold"
    titleStyle.fontSize = 16.0
    titleStyle.textAlignment = .Center
    graph.titleTextStyle = titleStyle

    let title = "\(base.name) exchange rates\n\(rates.first!.date) - \(rates.last!.date)"
    graph.title = title
    graph.titlePlotAreaFrameAnchor = .Top
    graph.titleDisplacement = CGPointMake(0.0, -16.0)

    // 4 - Set up plot space
    let xMin = 0.0
    let xMax = Double(rates.count)
    let yMin = 0.0
    let yMax = 1.4 * highestRateValue()
    guard let plotSpace = graph.defaultPlotSpace as? CPTXYPlotSpace else { return }
    plotSpace.xRange = CPTPlotRange(locationDecimal: CPTDecimalFromDouble(xMin), lengthDecimal: CPTDecimalFromDouble(xMax - xMin))
    plotSpace.yRange = CPTPlotRange(locationDecimal: CPTDecimalFromDouble(yMin), lengthDecimal: CPTDecimalFromDouble(yMax - yMin))



下面是这段代码逻辑的拆解：

1.  首先，实例化一个 `CPTXYGraph`，实际上就是一个柱状图，并将它关联到 `hostView`。
2.  然后声明一个 _简约的白色_ 默认主题并为了展示 XY 轴去设置左侧和下方的内边距。
3.  接着设置文本样式，图表标题以及标题位置。
4.  最后，配置 `CPTXYPlotSpace`，它负责将设备的坐标系映射到图表的坐标系。针对这个图表，你正在绘制三个使用了相同坐标系的汇率。然而，也有可能每个条形图的坐标系都是 _分离_ 的。你还要在坐标系中假定一个最大最小值汇率范围。在后面的教程中，你将学习到怎么样在不提前设定范围的情况下自动调节空间大小。

既然已经创建好图表了，那是时候增加一些绘制方法进去了！把下面的代码添加到 `configureChart()`里：



    // 1 - Set up the three plots
    plot1 = CPTBarPlot()
    plot1.fill = CPTFill(color: CPTColor(componentRed:0.92, green:0.28, blue:0.25, alpha:1.00))
    plot2 = CPTBarPlot()
    plot2.fill = CPTFill(color: CPTColor(componentRed:0.06, green:0.80, blue:0.48, alpha:1.00))
    plot3 = CPTBarPlot()
    plot3.fill = CPTFill(color: CPTColor(componentRed:0.22, green:0.33, blue:0.49, alpha:1.00))

    // 2 - Set up line style
    let barLineStyle = CPTMutableLineStyle()
    barLineStyle.lineColor = CPTColor.lightGrayColor()
    barLineStyle.lineWidth = 0.5

    // 3 - Add plots to graph
    guard let graph = hostView.hostedGraph else { return }
    var barX = BarInitialX
    let plots = [plot1, plot2, plot3]
    for plot: CPTBarPlot in plots {
      plot.dataSource = self
      plot.delegate = self
      plot.barWidth = BarWidth
      plot.barOffset = barX
      plot.lineStyle = barLineStyle
      graph.addPlot(plot, toPlotSpace: graph.defaultPlotSpace)
      barX += BarWidth
    }



接着来看看上面的代码干了什么：

1.  实例化每个条形图并设置它们的填充色。
2.  实例化一个代表每个条形图的外部边框的 `CPTMutableLineStyle` 实例。
3.  给每个条形图提供“共同配置”。该配置包括设置数据源和代理，宽度和每个条形图在坐标系中的相对位置（左右）以及线条样式，最后，添加这个坐标系到图表当中。

虽然还不可以看到柱状图展示出来，但通过构建 app 可以去验证目前为止是否所有代码都可以正确编译通过。

为了确切看到柱状图展示数据出来，需要去实现提供图表所需数据的代理方法。

用下面这行替换掉 `numberOfRecordsForPlot(:_)`：



    return UInt(rates.count ?? 0)



该方法返回了应该展示的记录的总数。

下面这段替换掉 `numberForPlot(_:field:recordIndex:)`：



    if fieldEnum == UInt(CPTBarPlotField.BarTip.rawValue) {
      if plot == plot1 {
        return 1.0
      }
      if plot == plot2 {
        return rates[Int(idx)].rates[symbols[0].name]!.floatValue
      }
      if plot == plot3 {
        return rates[Int(idx)].rates[symbols[1].name]!.floatValue
      }
    }
    return idx



`CPTBarPlotField.BarTip` 的值表明了柱状图的相对大小。在你需要取回数据的时候可以使用保留属性计算出汇率，`recordIndex` 对应了利息率的位置。

构建并运行，你应该可以看到和下面这张图一样的情况：

![Core Plot Tutorial](http://ac-Myg6wSTV.clouddn.com/4b5878afc9ec6c9b4427.png)

已经快完成了！但请注意还没有任何东西指明每个坐标轴是代表什么意思。

要解决这个问题，把下面这段添加进 `configureAxes()`：



    // 1 - Configure styles
    let axisLineStyle = CPTMutableLineStyle()
    axisLineStyle.lineWidth = 2.0
    axisLineStyle.lineColor = CPTColor.blackColor()

    // 2 - Get the graph's axis set
    guard let axisSet = hostView.hostedGraph?.axisSet as? CPTXYAxisSet else { return }

    // 3 - Configure the x-axis
    if let xAxis = axisSet.xAxis {
      xAxis.labelingPolicy = .None
      xAxis.majorIntervalLength = 1
      xAxis.axisLineStyle = axisLineStyle
      var majorTickLocations = Set<nsnumber>()
      var axisLabels = Set<cptaxislabel>()
      for (idx, rate) in rates.enumerate() {
        majorTickLocations.insert(idx)
        let label = CPTAxisLabel(text: "\(rate.date)", textStyle: CPTTextStyle())
        label.tickLocation = idx
        label.offset = 5.0
        label.alignment = .Left
        axisLabels.insert(label)
      }
      xAxis.majorTickLocations = majorTickLocations
      xAxis.axisLabels = axisLabels
    }

    // 4 - Configure the y-axis
    if let yAxis = axisSet.yAxis {
      yAxis.labelingPolicy = .FixedInterval
      yAxis.labelOffset = -10.0
      yAxis.minorTicksPerInterval = 3
      yAxis.majorTickLength = 30
      let majorTickLineStyle = CPTMutableLineStyle()
      majorTickLineStyle.lineColor = CPTColor.blackColor().colorWithAlphaComponent(0.1)
      yAxis.majorTickLineStyle = majorTickLineStyle
      yAxis.minorTickLength = 20
      let minorTickLineStyle = CPTMutableLineStyle()
      minorTickLineStyle.lineColor = CPTColor.blackColor().colorWithAlphaComponent(0.05)
      yAxis.minorTickLineStyle = minorTickLineStyle
      yAxis.axisLineStyle = axisLineStyle
    }</cptaxislabel></nsnumber>



简单地说，上面的代码首先为轴线和标题定义了样式，然后，为图表添加坐标轴的设置并配置好 x 轴和 y 轴的一些属性。

构建并运行就可以看到这些改动的结果了。

![Core Plot Tutorial](https://cdn2.raywenderlich.com/wp-content/uploads/2016/04/swiftrates-09.png)

### 功能化坐标轴

更棒了对吧？唯一的缺陷在于这个坐标轴太简单了，没办法从这儿得到一个准确的汇率展示。

你可以修复这个问题以便当用户点按在一个单独的柱状图时，这个 app 可以展示这个图表示的汇率。为了实现它，需要增加一个新的属性：



    var priceAnnotation: CPTPlotSpaceAnnotation?



然后把下面的代码添加到 `barPlot(_:barWasSelectedAtRecordIndex:)`：



    // 1 - Is the plot hidden?
    if plot.hidden == true {
      return
    }
    // 2 - Create style, if necessary
    let style = CPTMutableTextStyle()
    style.fontSize = 12.0
    style.fontName = "HelveticaNeue-Bold"

    // 3 - Create annotation
    guard let price = numberForPlot(plot,
                                    field: UInt(CPTBarPlotField.BarTip.rawValue),
                                    recordIndex: idx) as? CGFloat else { return }

    priceAnnotation?.annotationHostLayer?.removeAnnotation(priceAnnotation)
    priceAnnotation = CPTPlotSpaceAnnotation(plotSpace: plot.plotSpace!, anchorPlotPoint: [0,0])

    // 4 - Create number formatter
    let formatter = NSNumberFormatter()
    formatter.maximumFractionDigits = 2
    // 5 - Create text layer for annotation
    let priceValue = formatter.stringFromNumber(price)!
    let textLayer = CPTTextLayer(text: priceValue, style: style)

    priceAnnotation!.contentLayer = textLayer
    // 6 - Get plot index
    var plotIndex: Int = 0
    if plot == plot1 {
      plotIndex = 0
    }
    else if plot == plot2 {
      plotIndex = 1
    }
    else if plot == plot3 {
      plotIndex = 2
    }
    // 7 - Get the anchor point for annotation
    let x = CGFloat(idx) + CGFloat(BarInitialX) + (CGFloat(plotIndex) * CGFloat(BarWidth))
    let y = CGFloat(price) + 0.05
    priceAnnotation!.anchorPlotPoint = [x, y]
    // 8 - Add the annotation
    guard let plotArea = plot.graph?.plotAreaFrame?.plotArea else { return }
    plotArea.addAnnotation(priceAnnotation)



这里需要一些解释：

1.  不要给一个隐藏的柱状图展示注解，而当图没有设置隐藏属性的时候，在把切换开关整合到图表之后，你就将实现它了。
2.  这里还要为你的注解创建一个文本样式。
3.  得到指定柱状图的汇率，然后如果它不存在一个注解对象，就创建一个。
4.  如果没有数值格式化的方法还需要创建一个，因为在汇率展示的时候需要先格式化它。
5.  创建一个使用这个格式化汇率的文本层，并将注解的内容层设置到这个新的文本层上。
6.  获取你将展示的注解需要放置的柱状图索引。
7.  基于这个索引计算注解的位置，并给使用这个计算位置注解设置 `anchorPlotPoint` 的值。
8.  最后，将注解添加到图表上。

构建并运行。每次当你点按图表中的一个柱体时，该柱体所表示的值就应该正好在其上方弹出来。

棒极了! :]

![Core Plot Tutorial](https://cdn3.raywenderlich.com/wp-content/uploads/2016/04/swiftrates-10.png)

### 隐藏和查找

这个柱状图看起来很棒，但屏幕最上方的切换开关并没有起什么作用，是时候改动它们了。

首先，需要添加一个帮助方法，把下面这段添加到 `switch3Changed(_:)` 之后：



    func hideAnnotation(graph: CPTGraph) {
      guard let plotArea = graph.plotAreaFrame?.plotArea,
        priceAnnotation = priceAnnotation else {
          return
      }

      plotArea.removeAnnotation(priceAnnotation)
      self.priceAnnotation = nil
    }



这段代码首先简单地移除了一个如果存在的注解。

下一步，你希望用户通过切换开关展示一个给定的货币汇率柱状图。

要做到这个功能，用下面这段替换到 `switch1Changed(_:)`，`switch2Changed(_:)` 和 `switch3Changed(_:)` 的实现。



    @IBAction func switch1Changed(sender: UISwitch) {
      let on = sender.on
      if !on {
        hideAnnotation(plot1.graph!)
      }
      plot1.hidden = !on
    }

    @IBAction func switch2Changed(sender: UISwitch) {
      let on = sender.on
      if !on {
        hideAnnotation(plot2.graph!)
      }
      plot2.hidden = !on
    }

    @IBAction func switch3Changed(sender: UISwitch) {
      let on = sender.on
      if !on {
        hideAnnotation(plot3.graph!)
      }
      plot3.hidden = !on
    }



这个逻辑相当简单。如果开关设置了关闭，相关的图和其可见的注解就将被隐藏，而如果设置为开启，则图就会被设置为可见。

构建并运行。现在你可以在图表中随意切换每个柱状图的展示了。教程至此已经完成了很不错的工作！

![](http://ww4.sinaimg.cn/large/a490147fjw1f5tbq390v7g20fj08sgpr.gif)

## 接下来干点啥？

你可以从[这里](https://cdn1.raywenderlich.com/wp-content/uploads/2016/05/SwiftRates_Final-1.zip)下载一个已完成的项目。

哇哦，相当有趣！这个教程重点介绍了 Core Plot 的强大功能并希望提示了你该怎么在你自己的 apps 里使用它。

当然还可以参考 [Core Plot](https://github.com/core-plot/core-plot) 仓库获取更多的信息，包括文档，例子和一些小贴士。

还有，如果你对这个教程有任何的问题或者评论，欢迎加入下面的论坛进行讨论。

祝你有个快乐的绘图过程！
