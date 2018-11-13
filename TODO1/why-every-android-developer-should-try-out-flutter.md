> * 原文地址：[Why every Android Developer should try out Flutter](https://proandroiddev.com/why-every-android-developer-should-try-out-flutter-319ae710e97f)
> * 原文作者：[Aaron Oertel](https://proandroiddev.com/@aaronoe?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/why-every-android-developer-should-try-out-flutter.md](https://github.com/xitu/gold-miner/blob/master/TODO1/why-every-android-developer-should-try-out-flutter.md)
> * 译者：[ALVINYEH](https://github.com/ALVINYEH)
> * 校对者：[DateBro](https://github.com/DateBro)

# 为什么每个 Android 开发者都应该尝试 Flutter

几个月前，我写过一篇题为“[为什么 Flutter 能最好地改变移动开发](https://juejin.im/post/5add65c46fb9a07aa541e97e)”的文章。虽然已经过去了一段时间，但是我对 Flutter 的热爱依然非常强烈；事实上，当我继续使用它时，我意识到了我之前忽略了 Flutter 独特方面的重要性。不要误会我的意思 —— 我仍然认为 Flutter 最强大的一点就是如何解决跨平台开发的许多问题。但最近我开始关注移动开发发展的更多领域，特别是声明性用户界面的概念。

![](https://cdn-images-1.medium.com/max/800/0*pV87QzKfowqgkEkd)

摄影者：来自 [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral) 的 [Chris Charles](https://unsplash.com/@licole?utm_source=medium&utm_medium=referral)。

我相信你已经听过一系列关于为什么 Android 开发者应该关注 Flutter 的若干论据（如果你还没有看过，请让我谦逊地建议你瞧瞧[这个](https://proandroiddev.com/why-flutter-will-change-mobile-development-for-the-best-c249f71fa63c)），但是我想指出一个我还没有真正解决的大问题，那就是 Flutter 可以让你对 App 开发有完全不同的看法。首先，你的应用本身将采用不同的方式构建 —— 但更重要的是，实际的 UI 开发通过将其合并到你的 Dart 代码（而不是 XML）中而被推到前台，因此使它成为了“一等公民”。一旦你的 UI 代码突然出现在一种非标记语言中，你就会意识到你突然有了构建应用的可能性。说实话，在使用 Flutter 之后，我开始讨厌在 Android 上编写 UI 代码；因为在 Android 中步骤更加繁琐，虽然你仍然可以使用数据绑定等工具构建响应式应用，但它实际上比 Flutter 中要花费更多的时间。

当你考虑在 Android 中整合动画和其他动态数据时，使用 Flutter 的论点变得更加有力。整合动画可能会不太方便，有时你可能不得不拒绝设计师的要求，因为要实现他们的需求太难了。谢天谢地，Flutter 改变了这一切。如果你一直在关注 Flutter，你可能已经从 [Fluttery](https://medium.com/fluttery) 听说过 **Flutter 挑战**。这些挑战展示了构建具有大量自定义组件和精美设计（包括动画）的复杂 UI 的快速和直观性。在 Android 上实现这样的东西会变得非常困难 —— 特别是因为与 Flutter 不同，Android 的视图基于继承而非组合，这使得构建视图变得更加复杂。

下面，让我们切入正题：使用 Flutter **构建声明性 UI**，这改变了 UI 开发的一切。现在也许你在想，**Android 布局不也是以声明方式构建的吗？**答案是肯定的，但事实不是。使用 XML 来定义布局让我们有了以声明方式定义布局的感觉，但如果你的视图是完全静态的，并且所有数据都是以 XML 格式设置的，那么这种感觉才真正成立。不幸的是，这种情况几乎从未发生过；一旦添加动态数据和类似列表之类的东西，你自然必须使用一些 Java / Kotlin 代码将数据绑定到视图。然后我们最终得到某种 ViewModel，它将数据设置为视图。想象一下，这就像在 Android 上调用 `textView.text =“Hello Medium！”` 一样。在 Flutter 上，这是完全不同的：你创建了一个包含某个状态的窗口组件类，然后根据该状态以声明方式定义你的布局。每当状态改变时，我们调用 `setState（）` 来重新渲染我们改变的组件树的部分。让我们看一下如何在 Flutter 中使用 API，并使用结果渲染一个 List：

```
@override
Widget build(BuildContext context) {
  return new FutureBuilder<Repositories>(
    future: apiClient.getUserRepositoriesFuture(username),
    builder: (BuildContext context, 
        AsyncSnapshot<Repositories> snapshot) {
      if (snapshot.hasError)
        return new Center(child: new Text("Network error"));
      if (!snapshot.hasData)
        return new Center(
          child: new CircularProgressIndicator(),
        );
      return new ListView.builder(
        itemCount: snapshot.data.nodes.length,
        itemBuilder: (BuildContext context, int index) =>
            new RepoPreviewTile(
              repository: snapshot.data.nodes[index],
            ),
      );
    },
  );
}
```

在这里，我们使用了 `FutureBuilder` 来等待网络调用（Future）的完成。一旦网络调用完成，出现结果或错误，`FutureBuilder` 组件会在内部调用 `setState` 来调用所提供的 `builder` 方法来重新渲染。正如你在这个例子中看到的，一切都是**声明式的**。在 Android 上做同样的事情通常需要一个被动的 XML 布局，然后需要一些其他类来手动设置状态，比如 Adapter 和视图模型。这种方法的问题在于，状态可能与屏幕上渲染的状态不同。这就是为什么我们希望拥有像 Flutter 为我们提供的那样的声明性布局。我们最终编写的代码要少得多，同时将状态绑定到要在屏幕上显示的内容。

有了这些声明性布局，我们也开始对架构进行了不同的思考。突然间，**reactive** 这个词出现了，我们谈论了更多的是关于状态管理的内容，而不是架构。有了 Flutter，像 MVP 和 MVVM 这样的架构已经没有多大有意义了；我们不再使用它们了，而是考虑状态如何流经我们的应用。状态突然成为讨论的一个重要部分，我们将投入越来越多精力去思考构建应用的新方法上。这对我们所有人来说都是一次新的旅程，有许多事情可以解决，但最重要的是，这是我们开阔视野的机会。

坦白地说，Flutter 也不只有阳光和彩虹。我目前正在与 Flutter 合作开展一个更大的项目来了解它的弱点，迄今为止我遇到的最大缺陷是缺乏基础设施。当我尝试使用 Graphql-API 时，这个问题就非常明显；虽然有库确实会这样做，但它们并没有接近 Android 与 Apollo 的关系。不过，好消息是，Flutter 迎头赶上只是时间的问题，在此期间扩展现有的库，甚至建立自己的库并不困难。请注意，你可能需要花一些时间投入在应用程序的基础设施中，而对于 Android 和 iOS 来说，情况通常并非如此 —— 毕竟，天下没有免费的午餐。

最后，我最近从使用 Flutter 中得到的最大启示之一就是，体验这种构建 UI 的声明方式以及它对状态管理的影响是非常有用的。我觉得 Flutter 太棒了；不过，我告诫你不要把它当作解决你所有问题的银弹，而应该是作为一种创新的工具，它可以比在 Android 上更快地构建漂亮的自定义 UI。更重要的是，它展示了强大的声明性布局功能，并让你将应用视为渲染状态，而不是非连贯性 Activity，视图和视图模型 —— 仅此而言，我强烈建议你尝试一下 Flutter。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
