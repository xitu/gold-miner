> * 原文地址：[Constraint Layout Visual [Design] Editor ( What the hell is this )[Part4]](http://www.uwanttolearn.com/android/constraint-layout-visual-design-editor-hell/)
* 原文作者：[Hafiz Waleed Hussain](http://www.uwanttolearn.com/author/admin/)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

# Constraint Layout Visual [Design] Editor ( What the hell is this )[Part4]
# ConstaintLayout 可视化[Design面板] 编辑器 （这到底是什么）[第四部分]

WOW, we got one more day so its time to make this day awesome by learning something new 🙂 .
哇哦，又是新的一天。为了不浪费这宝贵的时光，让我们来学点新知识吧🙂。

Hello guys, hope every body is doing good. We already learned a lot of new things about Constraint Layout in [part1](http://www.uwanttolearn.com/android/constraint-layout-hell/), [part2](http://www.uwanttolearn.com/android/constraint-layout-concepts-hell-tips-tricks-part-2/) and [part3](http://www.uwanttolearn.com/android/constraint-layout-animations-dynamic-constraints-ui-java-hell/). Now Its time to start learning about remaining things. By the way this is our final post in Constraint Layout ( What the hell is this) series.
你们好，希望各位都有所进步。在[第一部分](http://www.uwanttolearn.com/android/constraint-layout-hell/), [第二部分](http://www.uwanttolearn.com/android/constraint-layout-concepts-hell-tips-tricks-part-2/) 和 [第三部分](http://www.uwanttolearn.com/android/constraint-layout-animations-dynamic-constraints-ui-java-hell/)这些文章中我们已经学习了许多关于 ConstraintLayout 的知识。现在是时候来学习这个神奇布局的剩余内容了。

**Motivation:**
**动机：**

Motivation is same as discus with you guys in [part1](http://www.uwanttolearn.com/android/constraint-layout-hell/). Now in this post we are going to play with Visual Editor. On some places I will refer [part2](http://www.uwanttolearn.com/android/constraint-layout-concepts-hell-tips-tricks-part-2/) of this series. I am going to use all previous concepts, which we already discuss in XML or Java, to implement by using Visual Editor. In this way we can save a lot of time.
学习动机与先前在[第一部分](http://www.uwanttolearn.com/android/constraint-layout-hell/)中讨论的是一样的。这篇文章里我准备向大家介绍可视化编辑器（Visual Editor）。在这一系列文章的[第二部分](http://www.uwanttolearn.com/android/constraint-layout-concepts-hell-tips-tricks-part-2/)中已经讨论过怎样在 XML 或者 Java 中实现一些效果，我会使用可视化编辑器来重新实现。通过这种方式我们可以节省掉许多的时间。

We need to download 2.3 Android studio. In previous versions Visual Editor is not good and that show some wrong info on Design Tab. So that is really important download 2.3 beta which is available when I am writing this post.
我们需要下载 2.3 版本的 Android studio。先前版本的可视化编辑器不太完善，有时会在 Design 面板上显示错误的信息。所以下载 2.3 beta 版是非常重要的，该版本在我写这篇文章时已经可以获取到了。

**Introduction:**
**引言**

In this post we are mostly working with Visual Editor. There is a rare chance you will work with XML. So attach your mouse, increase brightness of your monitor and attack.
在这篇文章里我们大部分都是使用可视化编辑器，比较少会用到 XML。那么让我们开始吧！

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-7.40.17-AM.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-7.40.17-AM.png)

In above image I created five red rectangles. This is the whole visual editor. Before going to explain there is a one question. Is it really important to know about these sections and there names? In my opinion, when we want to do work as an individual at that time we can learn skill by repeating things again and again without knowing terminologies but If we really want to help other community members or may be we want to be a good team player then we should learn all these terms. They are really helpful I will show you now.
在上图中我标出了五个红色的方框。这就是整个可视化编辑器了。在开始介绍之前有一个问题。那就是：了解各个组成部分以及他们的名字真的那么重要吗？在我看来，如果我们只是想要独立完成某些工作，通过一遍又一遍地重复那些工作就可以掌握相应的技能，并不需要了解术语。但如果我们想要帮助社区里的成员，或者说我们想要成为一名优秀的善于团队合作者，我们就应该学习所有相关的术语。这确实很有用，我现在就会展示给你看。

I know currently you guys don’t know (may be some of you know 🙂 ). What is Palette, Component  Tree, Properties etc but I am going to describe the flow by using these terms, when any developer will start working on UI he always follow these steps.
我知道大多数人不是很了解（或许有一些人了解）什么是 Palette，Component Tree， Properties 等等，但是我将会使用这些属于来描述流程。任何从事 UI 工作的开发人员都会遵循这些步骤。

Take UI component from Palette pane -> Drop on Design Editor -> Change there properties (width, height, text, margin, padding … etc ) in Property pane -> Adjust Constraints on Design Editor.
从 Palette 窗口选取 UI 组件 -> 拖拽到 Design 编辑器中 -> 在 Property 窗口中改变组件的属性（宽度，高度，文字，外边距，内边距… 等等） -> 在 Degisn 编辑器中调整约束关系。

Total four steps. I am going to repeat again.
总共四个步骤，我再重复一遍。

Palette -> Design Editor -> Properties -> Design Editor
Palette 窗口 -> Design 编辑器 -> Properties 窗口 -> Design 编辑器

That is a basic flow which we do 90% in the process of UI creation. Now If any body know these terms, he/she can imagine easily in his/her mind what we are taking about. Now I am going to explain what are these terms which I mentioned above and in Visual Editor where we will get.
我们构建 UI 时 90% 都是这样的基本流程。如果你知道这些术语，你就可以轻易地想象出我们说的是什么。
**Palette:**

Provides a list of widgets and layouts that you can drag into your layout in the editor. (Documentation)
提供了一系列的部件（widgets）和布局（layouts），你可以将其拖拽到位于编辑器中的布局里。（todo Documentation）
[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-8.24.43-AM-188x300.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-8.24.43-AM.png)

Here you will get all UI components given by Android. On top right corner there is a search icon that is really time saving. After search icon there is one more icon settings. Play with that, guys that is really awesome. You can change appearance of UI components according to your personal preference.
在这里你可以获取到 Android 提供的所有的 UI 组件。在右上角有一个搜索图标，你可以通过搜索节省寻找的时间。搜索图标的右边还有一个设置图标。通过点击这个酷炫的图标，你可以根据个人喜好更改 UI 组件的外观。
**Design Editor:**
**Design 编辑器:**

Displays your layout in a combination of the Design and Blueprint views. (Documentation)
结合设计（Design）视图和蓝图（Blueprint）视图来预览你的布局（todo Documentation）
[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-8.35.45-AM-300x280.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-8.35.45-AM.png)

Above image is a Design Editor. In Design Editor we have two modes, one is Design and second one is Text. First we are going to discuss Design mode.
上图就是 Design 编辑器。在 Design 编辑器里我们有两种模式可选，一种是预览模式（Design），另一种是文本模式（Text）。首先我们来看看预览模式。

As in above image we have two layouts basically both are same. On left side that is original UI how it look like in device. Right one is called blueprint. That is really helpful when you are doing design. You can easily saw margins, edges and collisions of views with each other. I have one assumption you guys already know how to drag and drop views into Design Editor and how to create constraint with parent and with other views. I am going on a next step.
上图中我们看到的两个布局其实是同一个布局。左边那部分就是我们将在设备中看到的 UI 界面。右边那部分称之为蓝图（blueprint）。当你在设计时这些都非常有用。你可以很轻易地看到每个视图的外边距、边缘以及它们之间是否有冲突。我就当作你们已经知道了怎么去拖拽视图到 Design 编辑器中，并且知道怎么去创建与父布局或其他视图的约束关系。我要开始介绍下一个步骤了。

Now if you saw above image there are some icons. Its time to explain these icons, what are these and what type of benefit we can get from these.
从上面的图片中可以看到有许多的图标。是时候介绍一下这些图标到底是什么，并且我们可以用它们来做些什么。
[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-8.51.15-AM-300x23.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-8.51.15-AM.png)

Ok before start, I am giving names to these icons which is easy for me to explain later. I am going to start from left to right. **Eye** Icon, **Magnet** Icon, **Cross with Arrow** Icon, **Stars** icon, **Number** box, **Pack** icon, **Align** icon, **Guideline** icon, **ZoomIn** Icon, **ZoomOut** icon, **Fit to screen** icon, **Pan and Zoom** icon, **Warning and Error** icon.
在开始之前，为了便于后面解释，我会给这些图标起个名。从左到右开始分别是：**眼睛**图标，**磁铁**图标，**交叉箭头**图标，**星星**图标，**数字**盒子，**pack**图标，**对齐**图标，**指示线**图标，**放大**图标，**缩小**图标，**适应屏幕**图标，**平移缩放**图标，**警告和错误**图标。

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-9.56.38-AM.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-9.56.38-AM.png)**Eye Icon:****眼睛**图标

This is really helpful icon specially when we have a lot of views on our UI. If that is turn ON, its mean I can see all constraints of the views together. Like I am only managing one Button but I can see all other Views constraints and if that is turn OFF then you are only able to see the constraint of a selected view as shown below.
这个图标很有用，尤其是当我们的界面上有大量的视图时。如果这个功能处于打开状态，这意味着我们可以看到视图之间的所有约束。比如当我只在调整一个按钮时，我却可以看到其他所有视图的约束关系。如果关闭了该功能，你就仅仅只能看到选中视图的约束，如下图所示。

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-28-2017-09-13-57-221x300.gif)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-28-2017-09-13-57.gif)

**[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-9.55.08-AM.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-9.55.08-AM.png)Magnet** **Icon:** **磁铁图标**

This icon will save lot of time. If you know properly how that work. Truly saying I am not good with this icon but here I am describing what I know. If that is turn OFF you can drag and drop or move your views in Design Editor but you need to give your constraints manually. If that is turn ON then lot of constraints with parent view automatically applied by the Editor.
如果你了解了这个图标会节省许多的时间。老实说我不太擅长使用这个图标，但是我会把我知道的都告诉你。如果这个图标处于关闭状态，你可以在 Design 编辑器里拖拽或移动你的视图，但你必须手动构建约束。如果这个图标处于打开状态，这时编辑器就会自动构建与父视图的约束。

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-28-2017-09-29-49-221x300.gif)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-28-2017-09-29-49.gif)As shown above. First time icon is turned OFF and I move my ImageView to center but nothing happens later I turned ON magnet icon and magic start happening. I move ImageView to center and Editor automatically created constraint for me. WOW
如上图所示。一开始图标处于关闭状态，我将我的 ImageView 设为居中，但什么都没有发生。之后我将磁铁图标打开了，神奇的事情发生了。我将我的 ImageView 设为居中，编辑器自动为我构建了约束。哇哦！

**Cross with Arrow** **Icon:**
**交叉箭头** **图标**

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-9.55.17-AM.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-9.55.17-AM.png)

This icon very simple and awesome. If I want to clear all constraints I can click on this and all constraints will be removed as shown below.
这个图标非常简单也非常酷炫。如果我想要清空所有的约束，只要点击这个图标，然后所有的约束都会被移除掉。如下图所示。

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-28-2017-09-37-29-221x300.gif)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-28-2017-09-37-29.gif)

Now as you saw in above image auto connect (magnet icon) is turned ON thats why all constraints automatically created for me. When I moved into center horizontal but in the end when I click cross icon all constraints are removed.
如上图所示，自动约束（磁铁图标）是打开的，这就是为什么当我将视图设为横向居中时会自动构建约束，但是当我点击了交叉图标，所有的约束都被移除掉了。

**Stars** **icon:**
**星星** **图标**
[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-9.55.37-AM.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-9.55.37-AM.png)

This is one more really awesome icon. That is basically vice versa of cross ( Clear constraints) icon. I can drag, lot of views on there places where I want without giving any constraints. As I finished I will click this icon and all constraints automatically created for me as shown below. I really like this icon.
这又是一个酷炫的图标。与交叉（清空约束）图标正好相反。我可以随意地拖拽视图而不用为它们构建约束。当我操作完成时只要点击一下这个图标，就可以自动构建出所有的约束，如下图所示。我很喜欢这个功能。

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-28-2017-09-46-52-221x300.gif)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-28-2017-09-46-52.gif)

**[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-9.57.41-AM.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-9.57.41-AM.png)Number box:** **数字盒子**

This will gave default margin to your parent layout.
为你的父布局设置默认的外边距。

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-28-2017-09-53-25-221x300.gif)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-28-2017-09-53-25.gif)

**[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-11.57.05-AM.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-11.57.05-AM.png)Pack icon: （todo）
**This icon contain a lot of functionalities. I am going to explain one by one.
这个图标包含了许多功能。我会一个个地解释。

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-10.24.29-AM.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-10.24.29-AM.png)

Currently all icons are disable because no view is selected in Design Editor. Here are some icons enable with single view selection and some will work with more then one views selection. First I am going to explain single view enable icons.

因为选中任何视图，所以一开始在 Design 编辑器中所有的图标都是不可点击的。有一些图标在选中了单个视图后可用，另外一些图标在选中了多个视图后可用。首先我来解释一下那些选中单个视图后可用的图标。

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-10.27.50-AM.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-10.27.50-AM.png)

When I selected a single view, two icons are enable as shown above. Its time to see what magic they can do.
当我选中了一个视图，有两个图标会变为可用的，如下图所示。让我们来看一下它们可以做些什么。

I clicked left icon and that increased width of my view up to parent edges but remember that is value in dp not match_parent ( parent ). Its mean If I change my screen to more bigger size my view will not shown with the edges of a parent. Same functionality will happen with right icon but vertical. Now both are shown below.
我点击了左边的图标，可以看到视图的宽度扩展到了屏幕边缘，但是请记住，这只是以 dp 为单位使用数值实现的效果而不是所谓的 match_parent(parent)。这就意味着如果在屏幕宽度更大的设备上，这个视图就无法扩展到屏幕边缘了。右边的图标也是一样的功能，只不过是在纵向的。如下图所示。

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-28-2017-10-36-54-221x300.gif)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-28-2017-10-36-54.gif)

One more important thing. Don’t confuse yourself because when you click width or heigh icon that will increase your view width or height up to first view who is colliding with your view width or height. In above example I have only one view that’s why it go up to parent width and height. In next example I am showing you the other behavior.
还有一件事别忘了。如果你点击了扩展宽度或高度的图标，而选中视图的宽高却只扩展到了相邻的视图边缘。不要感到困惑。因为在上面的例子中布局里只有一个视图，所以它填充满了父布局的宽高。下面的例子中我会给你看点不一样的。

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-28-2017-10-40-53-221x300.gif)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-28-2017-10-40-53.gif)

Before going to the other icons which are related to multiple selected views. One important point you can use these single view icons with multiple views selection as well as shown below.


[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-28-2017-10-47-42-221x300.gif)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-28-2017-10-47-42.gif)

Now its time to learn about those icons which are enable on multiple view selection.

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-10.50.12-AM.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-10.50.12-AM.png)

As I selected multiple icons on Design Editor, all other icons are enable as shown above.

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-10.55.32-AM.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-10.55.32-AM.png)

Both icons have same functionality only one is used for horizontal and the other one is for vertical. When I clicked horizontal one. That will take all my views and do horizontal align with each other. Then question is what is the difference between above icons which we already learned.

Difference is, above one’s increase the size of our views but this one did not increase the size instead view moved to align to each other. **Again important thing** that only gave values on Design Editor. If you try to run that on a device you will never get like its shown on Design Editor. For that you need to create constraints on your own. Basically you can save your time by using these icons to align views to each other and later when everything on there required places you can apply constraints. Then you will get your proper result on device. Its time to show you when I clicked what happened.

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-28-2017-11-03-02-221x300.gif)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-28-2017-11-03-02.gif)

So its time to explain remaining two icons.

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-11.04.33-AM.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-11.04.33-AM.png)

These icons have again same functionality only orientation differences.

Now If I click left icon basically that will create horizontal constraints between all selected views without moving positions and size as shown below.

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-28-2017-11-14-06-221x300.gif)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-28-2017-11-14-06.gif)

Here I can create chain between views by double clicking. If you guys don’t know what is chaining. You can read [part2](http://www.uwanttolearn.com/android/constraint-layout-concepts-hell-tips-tricks-part-2/) of the post. In which I explain what is chaining and what benefits we can get by chaining.

Below you can see how you can create chain using Editor.

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-28-2017-11-17-59-221x300.gif)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-28-2017-11-17-59.gif)

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-11.57.13-AM.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-11.57.13-AM.png)**Align icon:**

This icon contains 11 more icons in popup. In which four will work with single views and remaining work with multiple selected views.

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-11.24.49-AM.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-11.24.49-AM.png)

So first I am going to explain bottom four icons which will enable as I select any single view.

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-11.27.28-AM.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-11.27.28-AM.png)

First icon will do, view center horizontal, relative to other views with applying constraints.

Second icon will do, view center vertical, relative to other views with applying constraints.

Third icon will do, view center horizontal relative to parent view with applying constraints.

Fourth icon will do, view center vertical relative to parent view with applying constraints.

All icon functionalities are showing below respectively.

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-28-2017-11-32-52-221x300.gif)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-28-2017-11-32-52.gif)

Now remaining icons which are enable for multiple views selection.

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-11.38.45-AM.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-11.38.45-AM.png)

Top three icons:

First icon will align, left edges of my views in horizontal fashion with applying constraints.

Second icon will align horizontal centers of all views with applying constraints.

Third icon will align, right edges of my views in horizontal fashion with applying constraints.

All icons functionalities are showing below respectively.

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-28-2017-11-45-56-221x300.gif)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-28-2017-11-45-56.gif)

Bottom four icons are also same only they work in vertical fashion.

**[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-12.04.46-PM.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-12.04.46-PM.png)Guideline icon:**

As we already discuss Guidelines in [part2](http://www.uwanttolearn.com/android/constraint-layout-concepts-hell-tips-tricks-part-2/). What are they and how we can get benefit. Here I am only going to show you. How you can add guidelines in your UI because these are not views. So for that we have this guideline icon, by using this we can add guidelines as shown below.

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-28-2017-12-03-28-208x300.gif)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-28-2017-12-03-28.gif)

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-12.04.52-PM.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-12.04.52-PM.png)

**ZoomIn, ZoomOut, Fit to screen icon:**

My assumption is every body know these icons functionality so I am going to next one.

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-12.04.59-PM.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-12.04.59-PM.png)
**Pan and Zoom:**

This icon is useful when I am doing my work on a very high level of zoom and I want scroll my UI as shown below.

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-28-2017-11-53-29-300x278.gif)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-28-2017-11-53-29.gif)

**[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-12.05.06-PM.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-12.05.06-PM.png)Warning and Error icon:**

This one is useful as I am going to create my UI. I can see if any error or warning occur by clicking on this icon.

Good news. We completed our Visual Editor in Design Mode. Now its time to see how I can work in Text Mode.

In Text Mode basically you can do all things which currently we did in Design Mode except property changes using Editor and additionally we are able to write XML.

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-12.13.10-PM.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-12.13.10-PM.png)

Toolbar:

Provides buttons to configure your layout appearance in the editor and to edit the layout properties. (documentation)

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-12.19.33-PM-300x16.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-12.19.33-PM.png)

In toolbar I am going to explain only first three and last icon. All other icons are available from day. I think every body know all other icons.

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-12.22.03-PM.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-12.22.03-PM.png)

**Design View Mode Icons:**

First one show us the original UI layout.

Second will show us blue print of our UI layout.

Third will show us both together.

All icons functionalities are showing below respectively.

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-28-2017-12-27-10-300x293.gif)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-28-2017-12-27-10.gif)

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-12.22.10-PM.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-12.22.10-PM.png)

**Layout Variant Icon:**

This is really helpful icon if I want to create different layout files for different variants. Like I want to create separate Land scape layout. So without going into File I can create from here in seconds just as shown below.

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-28-2017-12-32-50.gif)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-28-2017-12-32-50.gif)

**Component Tree:**

Shows the view hierarchy for your layout. Click an item here to see it selected in the editor. (Documentation).

This pane is really helpful specially when I am doing my work in Design Editor and I have a lot of views in the form of a stack.  Its really difficult to select some view which is behind to some other view. In these type of situations I always use to select my view by using this palette as shown below.

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-28-2017-12-40-09.gif)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-28-2017-12-40-09.gif)

**Properties:**

Provides property controls for the currently selected view. (Documentation)

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-12.42.57-PM-1-170x300.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-12.42.57-PM-1.png)

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-12.43.21-PM-172x300.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-12.43.21-PM.png)

In Palette we have two views as shown in above images. Here I will explain the first top image because the second bottom image is available from day one in Android Studio. So I have an assumption every body knows about that property pane. About how you can swap these views for that check below image.

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-28-2017-12-52-07-165x300.gif)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-28-2017-12-52-07.gif)

Its time to learn first property pane view new things which are shown below.

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-12.54.24-PM-296x300.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-12.54.24-PM.png)

There are two main things which we are going to explore. First the internal square which is used for view size. Second are blue lines outside of that internal square. These are used to manage our view constraints.

**Internal square:**

Internal square we can see in three forms.

1. Wrap content:


[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-1.03.38-PM-150x150.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-1.03.38-PM.png)

Just like in all views we have a wrap_content concept that is same here. Only now we can do by using Design Editor just shown below.

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-28-2017-14-43-51.gif)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-28-2017-14-43-51.gif)

Here I took a one button which is match_parent, match_parent and later by using UI i changed to wrap_content, wrap_content.

2. Fixed size:

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-1.03.53-PM-150x150.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-1.03.53-PM.png)

Fixed size means like we gave values in dp to width and height. Now we can do by using UI as shown below.

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-28-2017-14-47-34.gif)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-28-2017-14-47-34.gif)

Here I took a one button of wrap_content, wrap_content then I changed that to fixed size and after that I change size by dragging on UI.

3. Any size:

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-1.04.11-PM-150x150.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-1.04.11-PM.png)

Any size is really useful when we are going with constraints. Like if I did not set any constraint on view and then do a any size, view will be 0dp,0dp as shown below.

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-28-2017-14-54-36.gif)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-28-2017-14-54-36.gif)



Now I am going to apply left and right constraints on the button and later I will change its width, height to any size and button will take whole space as shown below.

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-28-2017-14-57-53.gif)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-28-2017-14-57-53.gif)

Now its time to learn about view constraints value management.

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-3.00.12-PM-291x300.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Screen-Shot-2017-01-28-at-3.00.12-PM.png)

In above image all read rectangles basically contained the constraint management UI of a selected view.

Used of these lines are shown below.

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-28-2017-15-06-36.gif)](http://www.uwanttolearn.com/wp-content/uploads/2017/01/Jan-28-2017-15-06-36.gif)

In above image I have a one button. I apply first left constrained on that button with 24dp. Later I changed to 207dp and in the end I removed constraint by clicking on a circle. One important thing basically these values are not constrained instead these values are margins :). Only you can apply that after applying constraints.

OK guys its time to say BYE. I hope you enjoy all of my Constraint Layout ( What the hell is this ) series of tutorials. Today we completed all aspects of a Constraint Layout according to my knowledge.

Next time we will meet with some new topic. **BYE**. Have a nice weekend 🙂 .
