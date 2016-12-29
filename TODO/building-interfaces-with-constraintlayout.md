> * 原文地址：[Building interfaces with ConstraintLayout
](https://medium.com/google-developers/building-interfaces-with-constraintlayout-3958fa38a9f7#.avb3mafbz)
* 原文作者：[Wojtek Kaliciński](https://medium.com/@wkalicinski)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[王子建](https://github.com/Romeo0906)
* 校对者：[Mark](https://github.com/marcmoore)、[PhxNirvana](https://github.com/phxnirvana)

# 使用约束控件创建界面

[![](https://i.embed.ly/1/image?url=https%3A%2F%2Fi.ytimg.com%2Fvi%2FXamMbnzI5vE%2Fhqdefault.jpg&key=4fce0568f2ce49e8b54624ef71a8a5bd)](https://www.youtube.com/embed/XamMbnzI5vE?list=PLWz5rJ2EKKc_w6fodMGrA1_tsI3pqPbqa&listType=playlist&wmode=opaque&widget_referrer=https%3A%2F%2Fmedium.com%2Fmedia%2F0a3cece4e79cc61b0f04ea610e0d2c12%3FpostId%3D3958fa38a9f7&enablejsapi=1&origin=https%3A%2F%2Fcdn.embedly.com&widgetid=1
)

如果你是刚刚接触约束控件——支持库中与 Android Studio 2.2 可视化 UI 编辑器紧密结合的新布局——我建议首先观看上面的介绍视频或者浏览我们的[代码库](https://codelabs.developers.google.com/codelabs/constraint-layout/#0)。

视频和代码库简明扼要地介绍了布局编辑器中的一些处理方式、约束和 UI 控制的基本概念，了解这些有助于你快速在可见的方式下搭建界面。

本文中，我将着重讲解最近在 Android Studio 2.3 (Beta) 中约束控件的新增内容：链条和比率，同时也会写一些普通约束控件中的一些建议和技巧。

#### 链条

创建链条是一项新的特性，让你能够沿着一个坐标轴（水平或垂直）布置组件，从概念上来看有点类似线性布局。在约束控件中的实现中，链条是一系列通过双向连接联系起来的组件。

![](https://cdn-images-1.medium.com/max/1600/0*nnBhtpeHAkmPvfT7.)

要想在视图编辑器中创建链条，你只需选择目标组件并右击，点击“Center views horizontally“（或“Center views vertically”）。

![](https://cdn-images-1.medium.com/max/1600/0*GGOOXZi3nWsiVKgg.)

这就在组件之间建立了必不可少的关联。此外，当你选择链条中任何一个元素时，都会出现一个新的按钮，你可以在三种链条模式之间切换：分布式（Spread）、内分布式（Spread Inside）和密集式（Packed）链条。

![](https://cdn-images-1.medium.com/max/1600/1*ZJRM06bmnEj8YSCyOn2fNg.gif)

有两个额外的技巧可以用来更方便地操作链条：

如果你创建了一个分布式或者内分布式链条，并且所有的组件尺寸都被设置成 MATCH_CONSTRAINT（或者“0dp”），其余的链条空间将会根据在 layout_constraintHorizontal_weight 或则 layout_constraintVertical_weight 中定义的值平均分布。

![](https://cdn-images-1.medium.com/max/1600/1*HelCaZczLmEjXPO5iaAs7A.gif)

如果你创建了一个密集式链条，你可以通过调整水平（或者垂直）焦点来使链条元素左右（或者上下）移动。

![](https://cdn-images-1.medium.com/max/1600/1*D9Tp-QOkNVGan422xeo1Jg.gif)

#### 比率

比率大致上能够实现和[百分比布局](https://developer.android.com/reference/android/support/percent/PercentFrameLayout.html)相同的效果，IE 中可以通过设定比率来限制 View 的宽高，而不用在 ViewGroup 的层次上增加额外开销。

![](https://cdn-images-1.medium.com/max/2000/1*RfgavVsO88a44_F5xGnUog.gif)

在约束控件中为组件设置比率：

1. 确保至少一个约束尺寸可变，也就是说，不允许设置为“Fixed”和“Warp Content”。
2. 点击左上角的“Toggle aspect ratio constraint”。
3. 按照宽度：高度的格式输入你想要的比率，比如：16:9 。

#### 辅助线

辅助线是用来帮助你布置其他组件的可视的组件。它们在运行时并不会可见，但同样可以用来添加约束，可以从下拉项中创建垂直或者水平的辅助线。

![](https://cdn-images-1.medium.com/max/1600/1*8KCJzbcyQJUHxyAJIVaUfg.gif)

点击选择新添加的辅助线，拖动到合适的位置。

点击组件的顶部（或左部）标志可以切换辅助线对其模式：固定距离的左/右（或者上/下）对齐模式和相对父元素的百分比宽/高对齐模式。

### 处理 View.GONE

![](https://cdn-images-1.medium.com/max/1600/0*sgv4IU2rWyXBbPMR.)

与相对布局相比，在约束控件布局中你将能更好地控制组件的 View.GONE 可见性。最重要的一点，任何设置为 GONE 的组件，其尺寸和外边距约束将缩小为零，但仍然参与约束的计算。

![](https://cdn-images-1.medium.com/max/1200/1*reku7ldbZGxh7qG0PKrZ0g.gif)

许多情况下，如图所示的一系列通过约束联系起来的组件只会在一个组件被设置为 GONE 时生效。

还有一个方法可以为约束绑定在 GONE 移除时的组件设置特定的外边距，使用 [*layout_goneMargin*](https://developer.android.com/reference/android/support/constraint/ConstraintLayout.html#GoneMargin)*Start* (…*Top*, …*End*, 和 …*Bottom*) 属性来实现。

![](https://cdn-images-1.medium.com/max/1600/1*sz63HAfIQL_5OrHSCfk3Rg.gif)

这样可以处理更复杂的情况，正如上如所示，我们可以设置特定的组件消失而不用改变代码。

#### 不同类型的居中对齐

在约束控件布局的链条属性中，我已经提到过一种居中方式了。当你选择一组组件时，点击“Center horizontally”（或者“center vertically”）来创建一个链条。

你也可以使用相同的选项，使一个组件居中对齐在其相邻的组件中间：

![](https://cdn-images-1.medium.com/max/1600/1*yP9P7Fnu4KfB2v1PCGPmtg.gif)
如果要忽略其他组件，在父元素内居中对齐，使用“Center horizontally/vertically in parent”选项。需要注意的一点是，通常你会对一个单独的元素使用这个选项，并且这不会创建链条。

![](https://cdn-images-1.medium.com/max/1600/1*1MIe7MsnTXKV6KttdaOtGA.gif)

有时，你需要两个不同尺寸的组件中心对齐，不妨这样：当不同约束把一个组件拉向两个不同的方向时，它会稳定在两个约束的中间位置（每个方向 50% 偏心距）。

![](https://cdn-images-1.medium.com/max/1600/1*lqP6aGkko5sAC2DyC6TH4g.gif)

我们可以使用相同的方法，通过设置两个相同方式的关联，使一个组件相对于另一个组件的一边居中对齐。

![](https://cdn-images-1.medium.com/max/1600/1*a0pnMNpfUt8NJMY3KZGB0Q.gif)

#### 使用 Space 实现负外边距

约束控件布局中不支持负的外边距，然而，有个小技巧可以使你获得相同的效果，通过插入 Space（实质上是一个空组件）并且设置尺寸为理想外边距的大小。如下所示：

![](https://cdn-images-1.medium.com/max/1600/1*rlTnKZVFd8ftT0H8pcOYBQ.gif)

#### 什么时候使用自动生成

当你在工具栏中选择“自动生成布局（Infer constraints）”命令时，编辑器会找出约束控件布局中缺少的组件约束，并且会自动添加。它也可以从一个没有任何约束的视图开始设置，但由于很难创建一个完全正确的视图，你可能会得到很混乱的结果。这也是我建议通过这两种方式来使用约束界面：

首先是尽可能多地手动创建约束，这样你的布局能够最大化地得到实现并且具有功能可靠。然后，点击自动生成来为一些没有约束的组件创建约束，这样能节省你一点工作量。

另一个方法就是，将组件置于编辑器中不创建任何约束，使用自动生成命令，然后修改预览设备的分辨率。查看有哪些尺寸和位置错误的组件并修正这些约束，然后换一个分辨率重复操作。

这归根到底取决于你的喜好，每个人为布局创建约束的方式各有千秋，当然也包括有些人喜欢纯手工地实现巧夺天工的布局。

#### 不支持适应父元素

使用 match_constraint（0 dp）来替代，并且可以根据意愿给父元素设置约束，配合正确的外边距处理方式可以实现相同的效果，不应在约束布局中使用“Match parent”。