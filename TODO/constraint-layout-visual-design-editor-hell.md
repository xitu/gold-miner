> * 原文地址：[Constraint Layout Visual [Design] Editor ( What the hell is this )[Part4]](http://www.uwanttolearn.com/android/constraint-layout-visual-design-editor-hell/)
* 原文作者：[Hafiz Waleed Hussain](http://www.uwanttolearn.com/author/admin/)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[yazhi1992](https://github.com/yazhi1992)
* 校对者：[phxnirvana](https://github.com/phxnirvana)，[tanglie1993](https://github.com/tanglie1993)

# ConstraintLayout 可视化[Design]编辑器 （这到底是什么）[第四部分]

哇哦，又是新的一天。为了不浪费这宝贵的时光，让我们来学点新知识吧 🙂 。

大家好，希望各位都有所进步。在[第一部分](https://github.com/xitu/gold-miner/blob/master/TODO/constraint-layout-hell.md), [第二部分](https://github.com/xitu/gold-miner/blob/master/TODO/constraint-layout-concepts-hell-tips-tricks-part-2.md) 和 [第三部分](https://github.com/xitu/gold-miner/blob/master/TODO/constraint-layout-animations-dynamic-constraints-ui-java-hell.md)这些文章中我们已经学习了许多关于 ConstraintLayout 的知识。现在是时候来学习这个神奇布局的剩余内容了。顺便一提，本文是 Constraint Layout（这到底是什么）系列的最后一篇文章了。

**动机：**

学习动机与先前在[第一部分](https://github.com/xitu/gold-miner/blob/master/TODO/constraint-layout-hell.md)中讨论的是一样的。这篇文章里我们将会学习如何使用可视化编辑器（Visual Editor）。有一些地方我会引用到[第二部分](https://github.com/xitu/gold-miner/blob/master/TODO/constraint-layout-concepts-hell-tips-tricks-part-2.md)的内容。我将会使用可视化编辑器来实现一些，我们已经讨论过怎样在 XML 或者 Java 中实现的概念。通过这种方式我们可以节省许多的时间。

我们需要下载 2.3 版本的 Android studio。先前版本的可视化编辑器不太完善，有时会在 Design 面板上显示错误的信息。所以下载 2.3 beta 版是非常重要的，该版本在我写这篇文章时已经可以获取到了。

**引言**

在这篇文章里我们大部分都是使用可视化编辑器，用到 XML 的机会比较少。那么让我们开始吧！

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-7.40.17-AM.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-7.40.17-AM.png)

在上图中我标出了五个红色的方框。这就是整个可视化编辑器了。在开始介绍之前有一个问题。那就是：了解各个组成部分以及它们的名字真的那么重要吗？在我看来，如果我们只是想要独立完成某些工作，那么通过一遍又一遍地重复那些工作就可以掌握相应的技能，并不需要了解术语。但如果我们想要帮助社区里的成员，或者说我们想要成为一名优秀的团队合作者，我们就应该学习所有相关的术语。这确实很有用，我将会展示给你们看。

我知道大多数人不是很了解（或许有一些人了解 🙂）什么是 Palette, Component Tree, Properties 等等，但是我将会使用这些术语来描述流程。任何从事 UI 工作的开发人员都会遵循这些步骤。

从 Palette 窗口选取 UI 组件 -> 拖拽到 Design 编辑器中 -> 在 Property 窗口中改变组件的属性（宽度，高度，文字，外边距，内边距… 等等） -> 在 Design 编辑器中调整约束关系。

总共四个步骤，我再重复一遍。

Palette 窗口 ->  Design 编辑器 -> Properties 窗口 ->  Design 编辑器

我们构建 UI 时 90% 都是这样的基本流程。如果你知道这些术语，你就可以轻易地想象出我们说的是什么。接下来我会向大家介绍我刚刚提到的那些术语到底是什么，以及我们怎么在可视化编辑器中找到它们。

**Palette:**

提供了一系列的部件（widgets）和布局（layouts），你可以将其拖拽到位于编辑器中的布局里。（官方文档介绍）

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-8.24.43-AM-188x300.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-8.24.43-AM.png)

在这里你可以获取到 Android 提供的所有 UI 组件。在右上角有一个搜索图标，你可以通过搜索节省寻找的时间。搜索图标的右边还有一个设置图标。点击这个酷炫的图标，你可以根据个人喜好更改 UI 组件的外观。

**Design 编辑器:**

通过设计（Design）视图和蓝图（Blueprint）视图来预览你的布局。（官方文档介绍）

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-8.35.45-AM-300x280.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-8.35.45-AM.png)

上图就是 Design 编辑器。在 Design 编辑器里我们有两种模式可选，一种是设计模式（Design），另一种是文本模式（Text）。首先我们来看设计模式。

上图中我们看到的两个布局其实是同一个布局。左边那部分就是我们将在设备中看到的 UI 界面。右边那部分称之为蓝图（blueprint）。当你在设计时这些都非常有用。你可以很轻易地看到每个视图的外边距、边缘以及它们之间是否有冲突。我就当作你们已经知道了怎么去拖拽视图到 Design 编辑器中，并且知道怎么去创建与父布局或其他视图的约束关系。我要开始介绍下一个步骤了。

从上图中可以看到有许多的图标。是时候来介绍一下这些图标到底是什么以及使用它们可以带来什么好处。

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-8.51.15-AM-300x23.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-8.51.15-AM.png)

在开始之前，为了便于后面解释，我会给这些图标起个名。从左到右开始分别是：**眼睛**图标、**磁铁**图标、**交叉箭头**图标、**星星**图标、**数字**盒子、**背包**图标、**对齐**图标、**指示线**图标、**放大**图标、**缩小**图标、**适应屏幕**图标、**平移缩放**图标、**警告和错误**图标。

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-9.56.38-AM.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-9.56.38-AM.png) **眼睛图标：**

这个图标很有用，尤其是当我们的界面上有大量的视图时。如果这个图标处于打开状态，这意味着我们同时可以看到所有视图的约束关系。比如当我只在调整一个按钮时，我却可以看到其他所有视图的约束关系。如果关闭了该功能，你就仅仅只能看到选中视图的约束，如下图所示。

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-28-2017-09-13-57-221x300.gif)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-28-2017-09-13-57.gif)

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-9.55.08-AM.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-9.55.08-AM.png) **磁铁图标：**

如果你了解了这个图标会节省许多的时间。老实说我不太擅长使用这个图标，但是我会把我所知道的都告诉你。如果这个图标处于关闭状态，你在 Design 编辑器里可以拖拽或移动你的视图，但你必须手动构建约束。如果这个图标处于打开状态，这时编辑器就会自动构建与父视图的约束。

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-28-2017-09-29-49-221x300.gif)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-28-2017-09-29-49.gif)

如上图所示。一开始图标处于关闭状态，我将我的 ImageView 移动到居中的位置，但什么都没有发生。之后我将磁铁图标打开了，神奇的事情发生了。我将我的 ImageView 移动到居中的位置，编辑器自动为我构建了约束。哇哦！

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-9.55.17-AM.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-9.55.17-AM.png) **交叉箭头图标：**

这个图标非常简单也非常酷炫。如果我想要清空所有的约束，只要点击这个图标，然后所有的约束都会被移除掉。如下图所示。

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-28-2017-09-37-29-221x300.gif)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-28-2017-09-37-29.gif)

如上图所示，自动约束（磁铁图标）是打开的，这就是为什么当我将视图移动到水平居中时会自动构建约束，但是当我点击了这个图标，所有的约束都被移除掉了。

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-9.55.37-AM.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-9.55.37-AM.png) **星星图标：**

这又是一个酷炫的图标。与交叉（清空约束）图标正好相反。我可以随意地拖拽视图而不用为它们构建约束。当我操作完成时只要点击一下这个图标，就可以自动构建出所有的约束，如下图所示。我很喜欢这个功能。

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-28-2017-09-46-52-221x300.gif)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-28-2017-09-46-52.gif)

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-9.57.41-AM.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-9.57.41-AM.png) **数字盒子：**

作用是为你的父布局设置默认的外边距。

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-28-2017-09-53-25-221x300.gif)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-28-2017-09-53-25.gif)

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-11.57.05-AM.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-11.57.05-AM.png) **背包图标：**

这个图标包含了许多功能。我会一个个地解释。

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-10.24.29-AM.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-10.24.29-AM.png)

因为没有选中任何视图，所以一开始在 Design 编辑器中所有的图标都是不可点击的。有一些图标在选中了单个视图后可用，另外一些图标在选中多个视图后可用。首先我来解释一下那些选中单个视图后可用的图标。

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-10.27.50-AM.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-10.27.50-AM.png)

当我选中了一个视图，有两个图标会变为可用的，如下图所示。让我们来看一下它们可以做些什么。

我点击了左边的图标，可以看到视图的宽度扩展到了屏幕边缘，但是请记住，这只是以 dp 为单位使用数值实现的效果而不是所谓的 match_parent(parent)。这就意味着如果在屏幕宽度更大的设备上，这个视图就无法扩展到屏幕边缘了。右边的图标也是一样的功能，只不过是作用于垂直方向的。如下图所示。

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-28-2017-10-36-54-221x300.gif)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-28-2017-10-36-54.gif)

还有一件事别忘了。如果你点击了扩展宽度或高度的图标，而选中视图的宽高却只扩展到了相邻的视图边缘。不要感到困惑。因为在上面的例子中布局里只有一个视图，所以它填充满了父布局的宽高。下面的例子中我会给你看点不一样的。

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-28-2017-10-40-53-221x300.gif)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-28-2017-10-40-53.gif)

在开始介绍那些与多选视图有关的图标之前，还有一点是值得注意的，你在选中多个视图时仍然可以使用那些单选视图时可用的图标，如下图所示。

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-28-2017-10-47-42-221x300.gif)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-28-2017-10-47-42.gif)

现在让我们开始学习那些多选视图后可用的图标吧。

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-10.50.12-AM.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-10.50.12-AM.png)

当我在 Design 编辑器里选中多个视图后，剩下的几个图标就都变为可用的了。如下图所示。

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-10.55.32-AM.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-10.55.32-AM.png)

这两个图标功能是一样的的，只不过一个用于水平方向，另一个用于垂直方向。当我点击了水平方向的图标后，所有视图都会水平方向对齐。那么随之而来的问题是：这和上面刚学习过的那对图标有什么区别呢？

区别在于，上面的图标通过扩展尺寸（来对齐）。而这两个图标并不会扩展尺寸，而是将视图平移至互相对齐。**另外值得注意的是**，这只是在 Design 编辑器中设定了值，如果你运行到设备上你是无法获得在 Design 编辑器中显示的效果的。你需要自己去构建约束。但其实你可以先通过使用这些图标来对齐视图，这样可以节省很多时间，然后再构建约束，这样你就可以在设备上得到适当的效果。让我们来看一下点击这些图标之后会发生什么吧。

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-28-2017-11-03-02-221x300.gif)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-28-2017-11-03-02.gif)

接着再来解释剩下的两个图标。

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-11.04.33-AM.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-11.04.33-AM.png)

同样的，这两个图标也有着一样的功能，只不过作用的方向不一样。

用不着去移动位置或者改变数值，我只要点击左边的图标，就可以为所有选中的视图构建水平方向的约束。如下图所示。

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-28-2017-11-14-06-221x300.gif)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-28-2017-11-14-06.gif)

还可以通过双击图标将视图链接成链。如果你对链不太了解，你可以去阅读该系列博客的[第二部分](https://github.com/xitu/gold-miner/blob/master/TODO/constraint-layout-concepts-hell-tips-tricks-part-2.md)。那篇文章里介绍了什么是链以及使用链带来的好处。

在下图中你可以看到如何使用编辑器构建链。

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-28-2017-11-17-59-221x300.gif)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-28-2017-11-17-59.gif)

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-11.57.13-AM.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-11.57.13-AM.png) **对齐图标：**

这个图标的弹出菜单里包含了多达 11 个图标。其中 4 个图标在选中单个视图时可用，其余的在选中多个视图时可用。

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-11.24.49-AM.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-11.24.49-AM.png)

首先我来介绍一下底部那四个在选中单个视图时可用的图标吧。

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-11.27.28-AM.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-11.27.28-AM.png)

第一个图标的作用是将视图相对于相邻视图水平居中并构建约束。

第二个图标的作用是将视图相对于相邻视图垂直居中并构建约束。

第三个图标的作用是将视图相对于父布局水平居中并构建约束。

第四个图标的作用是将视图相对于父布局垂直居中并构建约束。

这些图标实现的效果如下图所示。

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-28-2017-11-32-52-221x300.gif)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-28-2017-11-32-52.gif)

现在就剩下那些选中多个视图后可用的图标了。

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-11.38.45-AM.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-11.38.45-AM.png)

先来介绍上面的三个：

第一个图标的作用是将所有选中视图左对齐于所选中视图的左边缘并构建约束。

第二个图标的作用是将所有选中视图都水平居中并构建约束。

第三个图标的作用是将所有选中视图右对齐于所选中视图的右边缘并构建约束。

这些图标实现的效果如下图所示。

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-28-2017-11-45-56-221x300.gif)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-28-2017-11-45-56.gif)

下面的四个图标的作用是一样的，只不过是作用于垂直反向。

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-12.04.46-PM.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-12.04.46-PM.png) **指示线图标：**

我们已经在[第二部分](https://github.com/xitu/gold-miner/blob/master/TODO/constraint-layout-concepts-hell-tips-tricks-part-2.md)中讨论过什么是指示线以及使用它会带来什么好处了。这里我就不再多介绍了。你可以放心地在 UI 中添加指示线因为它不算作视图。现在有了这个图标，我们可以使用它来添加指示线，如下图所示。

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-28-2017-12-03-28-208x300.gif)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-28-2017-12-03-28.gif)

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-12.04.52-PM.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-12.04.52-PM.png)

**放大、缩小、适应屏幕图标：**

这个大家应该都懂就不用多说了吧。

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-12.04.59-PM.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-12.04.59-PM.png) **平移缩放图标：**

当我处理一些要放大很多倍，并且还需要拖动界面的工作时，这个图标就非常有用了。如下图所示。

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-28-2017-11-53-29-300x278.gif)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-28-2017-11-53-29.gif)

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-12.05.06-PM.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-12.05.06-PM.png) **警告和错误图标：**

当我在构建我的 UI 时，这个图标非常有用。只要点击一下这个图标，就可以看到是否有任何错误或者警告发生。

到这里，我们终于结束了对可视化编辑器设计模式（Design mode）的学习。是时候开始看看我是怎么在文本模式（Text mode）里工作的了。

除了通过编辑器来改变属性外，刚刚我们在设计模式中做的所有事情都可以在文本模式中做到。除此之外，我们还可以编写 XML。

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-12.13.10-PM.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-12.13.10-PM.png)

工具栏：

提供了一些按钮用来配置编辑器中的布局外观以及编辑布局的属性。（官方文档介绍）

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-12.19.33-PM-300x16.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-12.19.33-PM.png)

我只准备介绍工具栏中的前三个和最后一个图标。其他的图标以前就有了，我相信大家对它们都非常熟悉。

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-12.22.03-PM.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-12.22.03-PM.png)

**设计视图模式（Design View Mode）图标：**

第一个会显示纯粹的 UI 布局。

第二个会显示我们的 UI 布局的蓝图。

第三个则两种都显示。

这些图标实现的效果如下图所示。

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-28-2017-12-27-10-300x293.gif)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-28-2017-12-27-10.gif)

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-12.22.10-PM.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-12.22.10-PM.png) **多布局图标：**

当我想要为不同的布局创建不同的布局文件时这个图标就可以帮上大忙。就比如我想要单独创建一个横屏的布局。使用这个图标我可以很快地创建好而不用进入文件夹中。如下图所示。

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-28-2017-12-32-50.gif)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-28-2017-12-32-50.gif)

**组件树（Component Tree）：**

展示你的布局的界面层级。单击某一项可以将其在编辑器中选中。（官方文档介绍）

这个窗口很有用，尤其是当我在 Design 编辑器中并且有大量的图标层层堆叠时，这时很难去选中某些视图旁边的一些视图。在这种情况下，我一般都会使用它来选中我想要的视图。如下图所示。

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-28-2017-12-40-09.gif)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-28-2017-12-40-09.gif)


**Properties：**

提供了对当前选中视图的属性控制。（官方文档介绍）

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-12.42.57-PM-1-170x300.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-12.42.57-PM-1.png)

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-12.43.21-PM-172x300.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-12.43.21-PM.png)

面板由上图所示的两部分组成。这里我只介绍第一张图里的东西，因为第二张图里的东西在 Android Studio 诞生之初就已经存在了，所以应该不用我多说了吧。至于如何切换这两种视图，如下图所示。

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-28-2017-12-52-07-165x300.gif)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-28-2017-12-52-07.gif)

让我们开始学习第一个属性窗口里的新东西吧！如下图所示。

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-12.54.24-PM-296x300.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-12.54.24-PM.png)

我们要探索的主要分为两大部分。第一部分是方形内部，这部分是用来设置视图的尺寸。另一部分是方形外部的蓝色的线条，这些是用来调整视图的约束关系的。

**方形内部：**

在方形内部我们可以看到三种形态。

1.Wrap content:

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-1.03.38-PM-150x150.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-1.03.38-PM.png)

所有的视图都有 wrap_content 的概念，这里也是一样。现在我们可以在 Design 编辑器中设定该属性了。如下图所示。

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-28-2017-14-43-51.gif)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-28-2017-14-43-51.gif)

这里我将一个原本属性为 match_parent，match_parent 的按钮修改为了 wrap_content，wrap_content。

2.固定尺寸：

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-1.03.53-PM-150x150.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-1.03.53-PM.png)

固定尺寸指的是像我们给宽度和高度设定 dp 值一样，现在我们可以直接在 UI 界面里做到。如下图所示。

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-28-2017-14-47-34.gif)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-28-2017-14-47-34.gif)

这里我将一个属性为 wrap_content，wrap_content 的按钮更改成了固定尺寸，并通过拖拽来设定值。

3.任意尺寸：

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-1.04.11-PM-150x150.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-1.04.11-PM.png)

任意尺寸在我们构建约束时非常有用。就比如我没有给视图设置任何约束，并将其设置为任意尺寸，视图就会变为 0 dp，0 dp。如下图所示。

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-28-2017-14-54-36.gif)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-28-2017-14-54-36.gif)

现在我要对这个按钮施加左右约束，之后将其宽高设置为任意尺寸，这时按钮会填充所有剩余的空间。如下图所示。

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-28-2017-14-57-53.gif)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-28-2017-14-57-53.gif)

现在是时候学习有关如何设置视图的约束值了。

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-3.00.12-PM-291x300.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-3.00.12-PM.png)

上图中所有红色的方形区域包含了选中视图的所有约束设置。

这些线条的作用如下图所示。

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-28-2017-15-06-36.gif)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-28-2017-15-06-36.gif)

上图中有一个按钮，我为该按钮构建了左侧值为 24 dp 的约束。之后我将值修改为 207 dp，最后我通过点击小圆点将约束移除。有一点值得注意的是，这些值不是约束，而是外边距。你只能在构建约束后设置该值。

希望你们喜欢我的 Constraint Layout（这到底是什么） 这一系列教程。今天我们完成了所有我对 Constraint Layout 了解的内容的介绍。

下次我们再一起学点新的知识吧。**再见**。周末愉快 🙂 。
