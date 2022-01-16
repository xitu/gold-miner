> - 原文地址：[How to Build a GUI Program with Python](https://python.plainenglish.io/how-to-build-gui-with-python-1e953f5c697c)
> - 原文作者：[Aisha Mohammed](https://medium.com/@aisharm13)
> - 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> - 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2022/how-to-build-gui-with-python.md](https://github.com/xitu/gold-miner/blob/master/article/2022/how-to-build-gui-with-python.md)
> - 译者：[YueYongDev](https://github.com/YueYongDev)
> - 校对者：[LJC](https://github.com/luochen1992), [Liang2028](https://github.com/Liang2028)

# 如何使用 Python 构建 GUI（Graphical User Interface）程序

> 本教程使用一个名为 Tkinter 的 Python 库去构建一个应用程序，该应用可以基于最近的经期时间来推测即将到来的受孕期。

我最近在学习 GUI 编程，突然想到，如果可以将我所学内容实践到上述项目中会让整个过程变得有趣。该项目是要实现一个 GUI（图形用户界面）程序，当用户输入末次月经的时间（LMP）时计算出他们的预产期（EDD）。我使用 Tkinter 模块构建了这个程序。

Tkinter 即 “TK interface”，是 Python 的 GUI 库之一。GUI 通过在计算机中显示图标（icons）和一些小组件（widgets）以实现用户交互。TKinter 提供了多种组件，如标签组件（labels），按钮组件（buttons），文本框组件（text boxes），复选框组件（chechboxes）等，具有各种功能。

本文，我将会采用增量开发的方式分阶段构建程序，不断地为应用添加代码，然后对其进行测试。这几个阶段分别是：

1. 在纸上设计用户界面

2. 创建一个涵盖多种组件的框架结构

3. 以适当的大小和位置持续地添加组件

4. 在程序中添加回调函数，以便在用户交互时响应用户的操作

## 绘制用户界面

我设想出该应用的模样并绘制了两张简易的草图。我选择使用了第二版草图，左侧是受孕照片，右侧是经期照片。

![rough sketch of the interface](https://cdn-images-1.medium.com/max/2468/1*lOooDLDNsnYP1H3JX3JTsw.jpeg)

## 创建页面的基本框架

我使用 **frame** 组件为该程序实现了一个简单的框架。我创建了两个相同尺寸的 frame。并在这里指定了尺寸，因为此时整个程序还没有组件（因此通常需要事先手动指定）。我还为每个 frame 赋予了不同的颜色，以区分它们覆盖的窗口。请参阅此处的[代码](https://github.com/aisha-rm/EDD-calculator/blob/main/framework.py)。

![the framework of the program](https://cdn-images-1.medium.com/max/2000/0*knnaguS-rCkJsiMF.png)

## 向左侧 frame 添加组件

我使用 **label** 组件来显示照片，并将其置于左侧的 frame 中。这个组件可用于显示文本或图像。[图像源](https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.istockphoto.com%2Fillustrations%2Fpregnant&psig=AOvVaw3Ed_YWfg460hZNsUeAns-V&ust=1636306992268000&source=images&cd=vfe&ved=0CAsQjRxqFwoTCKiZxMGrhPQCFQAAAAAdAAAAABAE)。此时我删除了对框架尺寸限制的[代码](https://github.com/aisha-rm/EDD-calculator/blob/main/left_widget.py) ，因为当前框架里的小组件已经可以决定他的尺寸了。

![added picture to the left frame](https://cdn-images-1.medium.com/max/2000/0*2qcwLDKPLlQOuOdA.png)

## 向右侧 frame

我使用**标签**小组件添加了标题（EDD CALCULATOR），并使用**消息**小组件在其下面添加了提示消息。我在空白处使用了 **Entry** 小组件，并使用按钮组件添加了"计算 EDD "按钮。起初，我试图使用 gird 或者 place 布局管理器来编排组件，因为这看起来更易上手。可事与愿违，我并没有得到预期的结果。最后，我选择 pack 布局管理器，并在组件内外使用一些 padding 填充，最终将组件放置在我想要的位置上了。随后，我更换了右侧 frame 的颜色，以便与左边 frame 的颜色“协调”。参考此处的[代码](https://github.com/aisha-rm/EDD-calculator/blob/main/all_widgets.py)。

![added the rest of the widgets on the right frame](https://cdn-images-1.medium.com/max/2000/0*OLFhsBZpA5GysL1Z.png)

## 添加回调函数

我的应用需要具有一定的交互逻辑。为此，我添加了将数据输入文本框中的功能，该功能可以根据接收到的输入数据计算 EDD，并使用 **messagebox** 组件向用户返回信息。如果日期以规定的格式输入，则程序将返回一个包含用户 EDD 信息的消息。否则，返回错误消息。示例如下。

![returns EDD if the date is entered as specified](https://cdn-images-1.medium.com/max/2000/0*mOF-rxOL5rwuRzcX.png)

![returns error message if date format not followed](https://cdn-images-1.medium.com/max/2000/0*Bp6hEjj_VS7oth2-.png)

![error message because the date was given in dd/mm/yyyy instead of as specified](https://cdn-images-1.medium.com/max/2000/0*EbLXl1k-EN8z8TNk.png)

以下是完整链接，你可以在 [Github](https://github.com/aisha-rm/EDD-calculator/blob/main/app.py) 上查看它。基于此，你可以随意使用来创建、修改属于你自己的应用。期待能看见你的成果。

## 总结

对我来说这是一个有趣的项目。比起过去在网上找到的一两个 Tkinter 项目，我更喜欢它。因为，对于那些从网络上找到的项目，我并不了解"背后"真正发生了什么。整个过程会让我觉得我是在复制代码，这显然是很糟糕的。

感谢读到最后！如果您有任何疑问或指正，请在下面发表评论。我也在我的[个人网站](https://themedtechie.com/tech/)上发布了这篇文章。你可以在那里看到我的其他文章。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
