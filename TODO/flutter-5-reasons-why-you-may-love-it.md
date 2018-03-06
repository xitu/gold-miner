> * 原文地址：[Flutter — 5 reasons why you may love it](https://hackernoon.com/flutter-5-reasons-why-you-may-love-it-55021fdbf1aa)
> * 原文作者：[Paulina Szklarska](https://hackernoon.com/@pszklarska?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/flutter-5-reasons-why-you-may-love-it.md](https://github.com/xitu/gold-miner/blob/master/TODO/flutter-5-reasons-why-you-may-love-it.md)
> * 译者：[RockZhai](https://github.com/rockzhai)
> * 校对者：[Starrier](https://github.com/Starriers)

# Flutter — 五个你会爱上它的原因

![](https://cdn-images-1.medium.com/max/800/1*gqBLqChWtWLq33DvWm6Nog.png)

在  [Google I/O ’17](https://www.youtube.com/watch?v=w2TcYP8qiRI)  上 Google 向我们介绍了  Flutter — 一个应用于手机应用开发的开源库。

也许你知道， Flutter 是一个开发具有精美 UI **跨平台手机应用**的解决方案。Flutter 设计界面的方式和 web 应用很相似，所以你可以在里面看到很多与 HTML/CSS 相近的方法。

根据他们的承诺：

> Flutter 可以轻松快捷的开发精美的手机应用。

听上去很赞，可是在最初的时候，**我是不太相信**有另外一个跨平台的解决方案，我们有许多类似的跨平台方案 — Xamarin, PhoneGap, Ionic, React Native 等等。我们都知道这么多可选的方案都有着各自的优缺点，我并不确定 Flutter 会与之有什么不同，**然而我被 Flutter 惊艳到了**。

Flutter 有许多**从 Android 开发者的角度**看非常有趣的**[特性](https://flutter.io/technical-overview/)**。在这篇文章中，我会向你展示一些真正触动到我的东西。 所以，来开始吧！

![](https://cdn-images-1.medium.com/max/800/1*ayM5swMh3wWgdrFHnTGDDw.jpeg)

#### 为什么选 Flutter？

你可能会很好奇并问自己这样一个问题：

> “Flutter 有什么创新的？它是如何工作的？Flutter 和 React Native 又有什么不同呢？”

在这里我不会过多涉及技术性问题，因为这块其他人做的比我更好，如果你对 Flutter 的工作方式感兴趣，那么我推荐你阅读这篇文章 [What’s Revolutionary about Flutter?](https://hackernoon.com/whats-revolutionary-about-flutter-946915b09514)，你也可以在[“The Magic of Flutter” presentation](https://docs.google.com/presentation/d/1B3p0kP6NV_XMOimRV09Ms75ymIjU5gr6GGIX74Om_DE/edit)查阅 Flutter 的完整概念。

在快捷实现方式中，Flutter 是一个允许我们去创建**混合移动应用程序**的**移动端 SDK** （这样你就可以写一份代码，然后同时跑在 Android 和 iOS 上）。 你需要用 [**Dart**](https://www.dartlang.org/) 来编写代码，这是一个由 Google 开发的编程语言，并且如果你之前有用过 Java 的话，你会觉得这个这个语言很熟悉。替代 XML 文件，你需要这样来构建你的 **layout 树**：

```
import 'package:flutter/material.dart';

class HelloFlutter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "HelloFlutter",
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text("HelloFlutter"),
        ),
        body: new Container(
          child: new RaisedButton(onPressed: _handleOnPressed),
        ),
      ),
    );
  }
}
```

正如你所看到的那样，一个 layout 是由嵌套的组件（_Widgets_）构建的， 核心 Widget 是  _MaterialApp_ （这是整个的应用程序）， 然后我们有 _Scaffold_ （这是我们主界面的 layout 结构），再然后是 _AppBar_ （就像 Android `Toolbar`） 和 一些 _Container_ 作为 body，在 body 内部，我们可以放置我们 layout 组件 — Texts, Buttons 等等。

这些都仅仅是切入点而已，如果你想读到更多关于 layout 的信息，请查看[Flutter’s tutorial on building layouts](https://flutter.io/tutorials/layout/)。 

### #1 热重载

好的，让我们现在开始吧！

我们将从一个基本的应用程序开始，这里有三个按钮，每个的功能为点击后改变文本的颜色：

![](https://cdn-images-1.medium.com/max/1000/1*JW18Xwd0EyItHM3CufWEaQ.gif)

想着，我们将使用 Flutter 最酷的功能之一 — **热重载**。它允许你像更新网页一样去实时的更新你的项目。来看看一看热重载的实际操作吧：

![](https://cdn-images-1.medium.com/max/1000/1*iL6s1TVF8XCrj9jQa690hA.gif)

我们在这里做什么呢？我们改变代码里的内容（比如按钮上的文本信息），然后我们点击“热重载”（在 IntelliJ IDE 的顶部），在**几秒**后我们就可以看到看到结果，这很酷，不是吗？

热重载不仅仅是**快**而且很**智能** — 如果你已经显示了一些内容（比如在这个例子中的文本颜色），并且热重载了应用，那么你可以在程序运行时来**改变 UI**：它们将保持**一致**！

### #2 丰富的 (Material Design) 组件

Flutter 中另外一个很棒的事情就是我们拥有非常丰富的内置 UI 组件目录。这里有两套组件 — [Material Design](https://flutter.io/widgets/material/) (适用于 Android) and [Cupertino](https://flutter.io/widgets/cupertino/) (适用于 iOS)。你可以很轻松的选择实现你想要的任何内容，你想创建一个 FloatingActionButton？走起：

![1_g4mc0mIvQva-m0cPo2nQYQ.gif](https://i.loli.net/2018/03/06/5a9e7d7f976fd.gif)

并且最棒的事情是你可以在任一平台上实现任意的组件，如果你使用了一些 Material Design 或者 Cupertino 组件，它们在每个 Android 和 iOS 上显示都是一样的，你不需要去担心有东西在不同设备上会看起来不同。

### #3 一切皆为小部件

就像你在之前的 gif 图中所看到的，创建一个用户界面是非常简单的。这可能就需要感谢 Flutter 的核心理念了，就是**一切皆为小部件**。你的 APP 类是一个部件（[MaterialApp](https://docs.flutter.io/flutter/material/MaterialApp-class.html)），你的整个 layout 结构是一个部件（[Scaffold](https://docs.flutter.io/flutter/material/Scaffold-class.html)）， 基本上，所有的东西都是部件（[AppBar](https://docs.flutter.io/flutter/material/AppBar-class.html), [Drawer](https://docs.flutter.io/flutter/material/Drawer-class.html), [SnackBar](https://docs.flutter.io/flutter/material/SnackBar-class.html)）。你想让你的 View 居中显示吗？用 **Center** 组件来包裹（_Cmd/Ctrl + Enter_）它即可！

![1_tRCpkOeASzgpDX-q5aJ-3g.gif](https://i.loli.net/2018/03/06/5a9e7da0a9c1d.gif)

由于这一点，创建 UI 界面就像用许多不同的小部件组成 layout 一样简单。

这也与 Flutter 中的另一个核心原则有关 — **组合优先于继承**。它意味着如果你想创建一个新的部件，可以用很少的小组件来**组装**新的部件，而不是通过扩展 Widget 类（就像你会在 Android 中继承一些 `View` 类一样）。 

### #4 适用于 Android/iOS 的不同主题

通常，我们希望我们的 Android 应用看起来和 iOS 应用不一样。区别不仅仅是颜色上，在尺寸和部件的样式上也是如此，我们可用通过 Flutter 的主题来实现这一点：

![](https://cdn-images-1.medium.com/max/800/1*uTR2zqjnltafthbCUDqlvg.png)

正如你所看到的，我们为 Toolbar（Appbar）设置了不同的颜色和高度。我们是通过使用`Theme.of(context).platform`获取当前的平台（Android/iOS）来实现的。

```
import 'package:flutter/material.dart';

class HelloFlutter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: "HelloFlutter",
        theme: new ThemeData(
            primaryColor:
                Theme.of(context).platform == TargetPlatform.iOS
                    ? Colors.grey[100]
                    : Colors.blue),
        home: new Scaffold(
          appBar: new AppBar(
            elevation:
                Theme.of(context).platform == TargetPlatform.iOS
                    ? 0.0
                    : 4.0,
            title: new Text(
              "HelloFlutter",
            ),
          ),
          body: new Center(child: new Text("Hello Flutter!")),
        ));
  }
}
```

### #5 许许多多的软件包

尽管 Flutter 还仅仅是一个 alpha 版本，但它的社区真的很大，而且非常活跃。感谢这个 Flutter 平台支持 **多个软件包**（库，就像 Android 中的 Gradle 依赖）。 我们有图像打开、发送 HTTP 请求、分享内容、存储偏好、访问传感器、实现 Firebase 等等。当然，每一个都是**同时支持 Android 和 iOS**。 

### 怎么开始呢？

如果你喜欢 Flutter 并且自己想要尝试的话，最好的方法就是打开 Google Codelabs：

*   在这里，你可以获得创建 layout 的基础知识： [Building Beautiful UIs with Flutter](https://codelabs.developers.google.com/codelabs/flutter/#0)
*   如果你想尝试更多关于 Flutter 的东西，你必须要尝试一下 [Firebase for Flutter](https://codelabs.developers.google.com/codelabs/flutter-firebase)。

在看完这些代码库之后，你可以创建一个简单而精美的**聊天应用**。你也可以在我的 GitHub 上查阅我对这个应用的实现：

- [**pszklarska/HelloFlutter**: HelloFlutter - A simple chat app written in Flutter with core features from Firebase SDK github.com](https://github.com/pszklarska/HelloFlutter)

你还可以查看 Flutter Gallery 应用程序，在这个应用里你可以看到其中有很大一部分的 Flutter UI 组件： 

- [**Flutter Gallery - Android Apps on Google Play**](https://play.google.com/store/apps/details?id=io.flutter.gallery)

* * *

结束了，感谢您的阅读！如果你喜欢这篇文章的话，不要忘了留下一个👏哦！

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
