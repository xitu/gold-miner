> * 原文地址：[What even are Flutter widgets?](https://medium.com/fluttery/what-even-are-flutter-widgets-ce537a048a7d)
> * 原文作者：[Matt Carroll](https://medium.com/@mattcarroll?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/what-even-are-flutter-widgets.md](https://github.com/xitu/gold-miner/blob/master/TODO1/what-even-are-flutter-widgets.md)
> * 译者：[ALVIN](https://github.com/ALVINYEH)
> * 校对者：

# Flutter 组件是什么？

![](https://cdn-images-1.medium.com/max/2000/1*y0VtCCdwj9zhk9dGu7wlog.png)

**以下对 Flutter 组件的解释是我自己的个人观点，并不是 Flutter 框架的组件或相关领域的官方解释。想要了解有关 Flutter 团队对其看法，请参阅 Flutter 的官方文档。**

Flutter 是一个移动端的 UI 框架，它使 UI 开发变得更有趣、快速和简单。但从传统的 Android 和 iOS 到 Flutter，感觉真的不可思议。之所以感到惊讶是因为我们从可变的、生命周期长的 `View` 和 `UIView`，变成了这些不可改变的、生命周期短的 `Widget`。它们到底是什么呢，为什么它们高效？

最近发表了一篇关于 [Widget 与 Element 和 RenderObjects 的关系](https://medium.com/flutter-community/flutter-what-are-widgets-renderobjects-and-elements-630a57d05208)的文章。我非常推荐这篇文章，建议你继续深入研究，直到你可以完全理解其内容为止。但对于那些已经迷失在 `Widget` 的人，请允许我提供一些可能有帮助的解释。

### 传统的 View 和视图模型

我一直支持在移动 UI 开发中使用视图模型。

无论你是在 Android 还是 iOS 上工作，都要考虑自定义的 `View` 或 `UIView`，称为`ListItemView`。这个 `ListItemView` 在左边显示一个图标，然后在图标右边显示字幕上方的标题，最后在右侧显示一个可选附件：

![](https://cdn-images-1.medium.com/max/1600/1*a5OR1jqUJrjEsW1XtNrijg.png)

在定义这个自定义 `View` 的时候，你可以将每个对 View 的描述设为独立属性：

```
myListItemView.icon = blah;  
myListItemView.title = “blah”;  
myListItemView.subtitle = “blah”;  
myListItemView.accessory = blah;
```

从技术上来说，这没什么问题，但是带来了架构成本。通过独立定义每个配置，你对其描述的 `Object` 需要引用你的 `View`，以便它可以配置每个属性。但是，如果你使用视图模型，那么你的描述 `Object` 可以在不引用 `View` 的情况下运行，这意味着描述 `Object` 可以进行单元测试，并且它避免了对具体 `View` 的编译时依赖性：

```
class ListItem {  
  final Icon icon;  
  final String title;  
  final String subtitle;  
  final Icon accessory;  
  ...  
}

// 使用 Presenter 创建一个新的视图模型。
myListItem = myPresenter.present();

// 传递视图模型到 View 来渲染新的视图外观。 
myListItemView.update(myListItem);
```

这种使用视图模型的这个基本原理，与 Flutter 无关，但与传统的 `View` 相比，理解视图模型是非常重要的。视图模型是一个不可变的配置，需要应用于生命周期长的，可变的 `View`。

传统 Android 和 iOS 中的依赖关系如下：

```
MyAndroidView -> MyAndroidViewModel

MyiOSUIView -> MyiOSViewModel
```

换句话说，在传统的 Android 和 iOS 中，我们主要使用可变的，生命周期长的 `View`（和 `UIView`）。我们通过使用那些生命周期长的 `View`（和`UIView`）`Object`来定义布局 XML，Storyboard 和可编程的布局。然后，我们不定期会传递新的视图模型来改变它们的界面。

现在，让我们来谈谈 Flutter。

### Flutter 颠覆了这种依赖关系

与其使用可变的、生命周期长，且会不定期接收新的视图模型 `View`，不如我们只使用不可变视图模型，来配置可变的、生命周期长的 `View`？

以前是：

```
MyView -> MyViewModel
```

现在改为：

```
MyViewModel -> MyView
```

就像这样，简单来说，我们刚刚发明了 Flutter 的组件系统：

```
MyWidget -> MyElement  
MyWidget -> MyRenderObject
```

这些组件都是不可变的，其中包含了许多用于配置渲染内容方式的属性：

```
// 这个组件肯定看起来很像一个视图模型，不是吗？
new Container(  
  width: 50.0,  
  height: 50.0,  
  padding: EdgeInsets.all(16.0),  
  color: Colors.black,  
);

// Flutter 组件和传统视图有一个很大的区别  
// 就是这些组件同样可以  
// 实例化生命周期长的视图 
final mutableSubtree = myContainer.createElement();  
final mutableRender = myContainer.createRenderObject();
```

但为什么这些组件能创建这两样东西呢？我认为，组件应该只能创建了一个生命周期长的视图？

在 Flutter 中，父/子的概念独立于渲染而存在。在 iOS 和 Android 中，父/子关系与绘制到屏幕的概念是一致的。

例如，在 Android 中的需要负责：

```
// 父/子关系  
myViewGroup.addView(...);  
myViewGroup.removeView(...);

// 以及

// 布局和绘制  
myViewGroup.measure(...);  
myViewGroup.layout(...);  
myViewGroup.draw(...);
```

在 Flutter，我们有

```
// Element 来管理父/子关系  
myElement.mount(); // 这创建并添加子级组件 
myElement.forgetChild(...); // 移除子级组件

// 用 RenderObjects 来布局和绘制：
myRenderObject.layout();  
myRenderObject.paint();
```

所以说，尽管 Flutter 中的组件负责创建一个 `Element` 和一个 `RenderObject`，但这两个 `Object`的组合等同与 Android 单个 `ViewGroup` 相同的功能。

因此，在 Flutter 中，我们使用可以配置 `View` 的视图模型，而不是使用视图模型配置的 `View`。这种关系是颠倒的。

### 为什么说这种颠倒关系是个大问题

颠倒视图模型的关系，以及如果一个视图模型知道如何实例化相对应的一个长生命周期的视图，你可能会感到特别奇怪。但 Flutter 向我们展示的是，通过颠倒这种关系，我们实现了以声明方式组合用户界面的能力。

在我看来，Flutter 正在做的事情，从根本上说，像是正在接近绘制像素的特定领域语言。

特定领域的语言是几乎所有开发人员的终极目标。如果你正在为航空业开发应用，那么你将花费大量时间构建行业特定术语的实现，如航班清单、登机牌、座位分配和会员身份。你在利用较低级别的语言语义，来表示这些术语在你的行业中的含义。然后，理想情况下，在某些时候，开发人员将停止使用这种较低级别的构造方式，他们将开始使用 `Object`，像 `FlightManifest`、`BoardingPass` 和`SeatAssignment`来实现整个应用。

但并非每个问题都是商业问题。一些问题是技术问题，例如渲染。渲染用户界面本身就是一个问题范畴。Flutter 正通过设计出用于渲染用户界面的一种特定领域的语言来解决此问题。就像 SQL 是用于搜索信息的声明式的领域特定语言一样，Flutter 的组件系统正在成为用于组合用户界面的声明式的领域特定语言。这可以通过在外部放置不可变视图模型，同时将可变视图限制在内部来实现。

希望这个视角，可以帮助你理解和欣赏 Flutter 中的组件。但是如果没有，只要你继续使用 Flutter 的 API，最终你也会体验出个中的妙处。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
