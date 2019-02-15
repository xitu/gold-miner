> * 原文地址：[Things about React Native I found the hard (but rewarding) way](https://blog.usejournal.com/things-about-react-native-i-found-the-hard-but-rewarding-way-1557a87a0c8)
> * 原文作者：[Christos Sotiriou](https://blog.usejournal.com/@christossotiriou)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/things-about-react-native-i-found-the-hard-but-rewarding-way.md](https://github.com/xitu/gold-miner/blob/master/TODO1/things-about-react-native-i-found-the-hard-but-rewarding-way.md)
> * 译者：
> * 校对者：

# React Native 中那些令我收获颇丰的难点

## 通过将 React Native 投入到企业级项目中使用后的多方位思考

![](https://cdn-images-1.medium.com/max/1600/1*TkSZ7PH0c6nqkJ3oFeSmBA.jpeg)

React Native 已经存在了一段时间了。当它支持 Android 的版本（iOS 之后大约一年）发布后，我便使用它进行专业级开发了，我决定投入时间在 RN 上进行跨平台开发。当我发现 React Native 时，我从事 iOS 开发工作已经六年了，而且不仅仅是 Mac OSX 的开发人员。

我已经在 App Store 和 Play Store 为我的客户开发了四个中等大小（一万到两万左右行代码，不包括依赖项）的项目。我还在一个更大的使用 React Native 编写的代码超过五万行（除了本机代码）的项目中进行监督和贡献，现在已经部署上线并运行顺利。我已经积累了足够的经验来找出 React（和 React Native）闪耀的地方，以及在没有它的地方如何扩展它。

注意：我知道你们中的一些人在阅读这篇文章时会提到 [Flutter](https://flutter.io/)。但由于它的成熟度远不及它的竞争对手，所以我还没有深入了解它。

**在撰写本文时，React Native 的当前稳定版本为 0.57，即将到达 0.58RC。**

这是我的想法：

### React Native 最广为人知的特性却不是最重要的

React Native 最广为人知的特性是跨平台，但这并不是它引起我注意的原因。React Native 最重要的特性是**它使用 React，这样使得它支持一个通用的声明式布局**。跨平台支持排在重要性的第二位。作为一名 iOS 开发人员，我一直在尝试那些不那么直观的用户界面设计方式自动布局系统。

如果您的系统具有高度动态性，并且屏幕上的元素相互依赖（比如一些侧边栏和动画），那么使用 Apple 的 Autolayout 是管理屏幕上内容的最佳方式。但是，对于大多数 Android 和 iOS 应用程序，情况并非如此。大多数 Android 和 iOS 应用程序都会使用我们经常看到的标准元素：文本、按钮、列表、通用视图和图像并以最类似于Web的方式布局。

在 AutoLayout 出现的同时，[flex 布局](https://css-tricks.com/snippets/css/a-guide-to-flexbox/)也被发明并被制定为排列屏幕上的元素的现实标准。除了标准的 Web 使用之外，还有一些布局系统旨在利用 FlexBox 原则进行原生开发：

*   [Yoga](https://github.com/facebook/yoga) 或者是一些依赖于它的衍生框架：安卓（Java 或 Kotlin）的 [Litho](https://fblitho.com/) 以及 IOS（Objective C++）的 [ComponentKit](https://componentkit.org/)。
*   [TextureKit](http://texturegroup.org/)（以前名为 AsyncDisplayKit）
*   [LinkedIn’s LayoutKit](https://github.com/linkedin/LayoutKit)（不是 flexbox，但和它相似）

这只是比较出名的一些，还有很多 UI 库。他们有一个共同点，就是他们都使用了声明式 UI 。

#### 声明式 UI 的特点：

创建移动开发的声明式 UI 是为了解决传统布局系统所具有的问题。你声明了你的**意图**，系统会根据它们生成结果。

声明式 UI 解决的一些移动开发挑战如下：

**组件化**。iOS 使用 ViewControllers 中嵌套 ViewControllers 或者 views 中嵌套 views，而 Android 使用 Fragments。两者都具有 XML 接口声明，并且都允许运行时实例化和编辑视图。当涉及将它们分解为较小的模块或复用它们时，你就是在进行一个小型的重构。在声明式 UI 中，默认情况下已经具有此功能。

**开发人员的生产力**。声明式 UI 负责为您调整组件大小。看看这段代码（React Native 示例）：

```
class TestTextLabel extends React.Component {
  render() {
    return (
      <view>
        <text>This is a small text</text>
        <text>{this}</text>
      </view>
    );
  }
}
```

上面的代码渲染了一个只包含两个文本组件的 Component。注意 `this.props.sampleText`，如果此变量太长（例如10000个字符左右的长度）会发生什么？结果将会是组件将调整大小以适合整个文本。如果文本达到了可用空间的极限（比如说屏幕大小），那么视图将被剪切，用户将无法看到整个文本，你需要一个滚动视图。

```
class TestTextLabel extends React.Component {
  render() {
    return (
      <ScrollView style={{flex : 1}}>
        <Text>This is a small text</Text>
        <Text>{this}</Text>
      </ScrollView>
    );
  }
}
```

唯一改变的是添加 `<ScrollView>` 元素，这将需要在 iOS 上进行更多工作。

**协作 —— 配合 Git 的友好体验**。我看到的每个声明式 UI 都能更好

在iOS和Android上，如果你有大的单片 UI，那你就做错了。但是，大型 XML 文件在大多数情况下是不可避免的（请注意 iOS：XIB 实际上是 XML 文件）。它们的变化对代码审查者（或您）没有任何意义，如果您不同意之前的版本（您的更改或其他开发人员）完整保留，则发起 Pull Request 几乎是不可能的。

使用 React 和其他声明性 UI 库，这些问题在很大程度上被最小化，因为布局是实际代码，您可以更新、删除、合并、对比差异以及执行所有您你平时对其他软件执行的操作。

### 最关键的是知道“性能”究竟是什么

您可能需要成为移动开发人员才能掌握性能概念并管理有效的内存和数据处理器使用。

Web 开发人员可以在不了解原生的情况下使用 React Native 开发仅适用于小型项目。一旦应用程序开始增长并且 Redux 的 store 的计算开始对应用程序的性能造成影响时，您将需要了解原生端如何工作以了解为什么会发生这种情况。您还需要意识到 React Native 中的 Redux 的 Store 导致的重新渲染与 DOM 中发生的重新渲染并不完全相同，这更适用于来自应用的原生端的组件。

同时，在 React Native 上重新渲染应用程序的组件会变得代价昂贵。由于 React Native 本质是使用 bridge，因此您在 `render()` 函数内部提供的任何指令都将从 JavascriptCore 传递到 Java 或者 Objective C ++。原生端将获取 `render()` 给出的 JSX 标签，并将它们转换为其原生对应部分，例如视图、标签和图像。如果转换每秒进行数百次，那就需要不可忽略的 cpu 时间。

在性能方面，似乎 React Native 是更好的跨平台解决方案之一。但是，在某些关键领域仍然存在 React Native 的性能瓶颈。

一个这样的例子是大型数据集（和列表）。在存在大型列表和网格视图的情况下，Android 和 iOS 都提供了一个出色且极其灵活的解决方案 —— 回收视图。想象一下，当使用大型列表视图（不论是 iOS 或是 Android）时，只渲染在任何给定时间显示的单元格。其他单元格被标记为可重复使用，以便在即将显示新单元格时可以重复使用它们。更改数据集时，操作系统只需更新显示的单元格。

React Native 为大型数据集提供 VirtualizedList 及其派生的（FlatList 和 SectionList）。然而，即使这样也有很多不足之处。存在性能开销，尤其是在 SectionList 中渲染复杂组件并尝试更新一百多个对象的大型数据集时。更新机制会使低端或中端移动设备缓慢运行。

为了解决这个问题，我已经从 Redux 切换到 MobX，它为我的组件提供了更可预测的更新。此外，在大型列表的情况下，MobX 可以更新特定单元格而无需重新呈现整个列表。通常这也可以通过 Redux 实现，但是您需要重写 `componentShouldUpdate()` 方法并编写更多样板文件以避免不必要的重新渲染。在将其余变量复制到新状态时，您的 reducer 仍会执行一些不必要的工作。

**写在最后**：总之要小心。如果您正在使用 React Native ，就意味着你想从您的应用程序中实现最佳效果需要熟悉 React 的最佳实践和原生实践。

### 了解JS运行时及其对您的影响非常重要。

可以通过将调试信息发送到 Chrome 对 React Native 进行调试。**这意味着在设备中运行实际代码的过程与您调试代码的过程不同**。

Android 和 iOS 上的 React Native 使用 JavascriptCore 执行 Javascript。但是，调试工具在 V8（Chrome）上运行。为了使系统有更普遍适用性，在撰写本文时，React Native 在 iOS 上使用 Apple 的 Javascript Core，而在Android上，他们使用的是[已经发布三年的 JS Core](https://github.com/facebook/android-jsc) 来构建脚本（因为 Android 没有提供任何像 iOS 这样现成的 JS 运行时，Facebook 也必须自己构建）。这就导致缺乏了很多 JS 新特性，比如 Proxy 对象只在 Android 上和 iOS 64 位上支持。因此，如果你想使用 [MobX 5+](https://github.com/mobxjs/mobx/blob/master/CHANGELOG.md#the-system-requirements-to-run-mobx-has-been-upped)，那你必须使用升级的 Javascript 运行时（继续阅读以了解如何做到这一点）。

Android 和 iOS 上的 React Native 使用 JavascriptCore 执行 Javascript。但是，调试工具在 V8（Chrome）上运行。为了使系统有更普遍适用性，在撰写本文时，React Native 在 iOS 上使用 Apple 的 Javascript Core，而在Android上，他们使用的是已经发布三年的 JS Core 来构建脚本（因为 Android 没有提供任何像 iOS 这样现成的 JS 运行时，Facebook 也必须自己构建）。这就导致缺乏了很多 JS 新特性，比如 Proxy 对象只在 Android 上和 iOS 64 位上支持。因此，如果你想使用 MobX 5+，那你必须使用升级的 Javascript 运行时（继续阅读以了解如何做到这一点）。

运行时差异通常会导致错误只能在生产模式中重现。更糟糕的是，甚至有些错误会变得难以调试。

例如，当涉及 React Native 时，移动端数据库的最佳解决方案是 Realm。但是，当进入调试模式时，会发生这种情况：[https://github.com/realm/realm-js/issues/491](https://github.com/realm/realm-js/issues/491)。虽然 Realm 的研发人员已经解释了[为什么会这样](https://github.com/realm/realm-js/issues/491#issuecomment-350718316)，但最重要的是，如果我们想要一个更稳定的调试解决方案，必须改进 React Native 的调试架构。好消息是我一直在使用 [Haul](https://callstack.github.io/haul/) 作为我的捆绑包，它允许我直接从我的 iOS 设备进行调试，而无需通过Chrome Dev Tools（不幸的是，你需要Mac、iOS 模拟器和 Safari）。

请注意，Facebook 上的人已经发现了这个问题，他们正在重新设计 React Native 的核心，以便原生和 React Native 部分可以共享相同的内存。完成此操作后，可能可以直接在设备的 JavaScript 运行时上进行调试。（参照文章：[React Native Fabric (UI-Layer Re-architecture)](https://github.com/react-native-community/discussions-and-proposals/issues/4)）

不仅如此，React Native 社区[现在提供了JS android 构建脚本](https://github.com/react-native-community/jsc-android-buildscripts)，它能够构建针对较新版本的 JavascriptCore 的脚本并将其嵌入到 React Native 应用程序中。这使 Android 上的 React Native 的 Javascript 功能能与 iOS 相提并论，也为在 Android 上运行的React Native 增加了 64 位支持奠定了基础。

### In-App Navigation Is Awesome with React Native

Have you ever developed a mobile application with authentication? What happens if the user receives a Push Notification and has to first pass through the Login screen and only after login he will be able to see the push notification content screen? Or, what if you are currently deeply nested inside your application and want to jump into an entirely different area in another app section as a response to a user action?

Problems such as those are solvable in Native with a bit of effort. With [React Navigation](https://reactnavigation.org/) they are not even a problem. Deep linking with associated routes and navigation jumps feel natural and fluid. There are other navigation libraries as well, but React Navigation is being considered as the de facto standard. You should give it a try. This is the one thing that React Native does _way_ better than iOS and Android hands down.

### React Native is not a silver bullet

As with any other technology, you need to understand what it is and what it isn’t before you invest in it. Here is a non-exhaustive list about what RN is good at:

*   Content-driven applications
*   Applications with a Web-like UI.
*   Cross Platform apps that may or may not need a fast Time To Market.

Here is also a non-exhaustive list of things where RN does not fare too good:

*   Apps with Huge Lists
*   Media Driven Applications without the need for a layout (example: simple/small games, animations, video processing), or screen-to-screen transitions.
*   CPU-intensive tasks.

It’s true that for the things that React cannot do you can write everything you need in Native and then call the appropriate code from React Native. But that means that you need to write code once per platform (iOS, Android), and then write extra code for the Javascript Interface.

React Native’s internals are currently undergoing a major refactor so that RN can do more things synchronously, in parallel and so that it can share common code with Native. [https://facebook.github.io/react-native/blog](https://facebook.github.io/react-native/blog/2018/11/01/oss-roadmap)/ — until this is done, you ought to do some research before you decide whether to use it.

### Conclusion

React Native is an insanely well-thought and good platform to develop on. It opens the world of NodeJS to your app, and makes you program in one of the best layout systems out there. It also gives you a very good bridge with the Native side so that you can get the best of both worlds.

It also falls into another strange category, however — the one where you will either need one team to develop your application or three! At some point, you will need some iOS and Android developers to construct components that React Native does not have by default. Once your team starts to grow you will have to decide whether you will make your application 100% Native or not. Therefore whether you choose React Native for your next project becomes a question of how much native code (Java / Kotlin / Swift / ObjC) you will need to have.

My personal advice: If you realize that you need 3 teams to develop three aspects of one application (an iOS team, an Android team, and a React team) then you should probably go for Native iOS and Android all the way and skip React Native. You will save time and money by maintaining only two codebases instead of developing three.

However, if you have a small team of proficient developers and want to build a content application or something similar, then React Native is an excellent choice.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
