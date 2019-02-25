> * 原文地址：[Things about React Native I found the hard (but rewarding) way](https://blog.usejournal.com/things-about-react-native-i-found-the-hard-but-rewarding-way-1557a87a0c8)
> * 原文作者：[Christos Sotiriou](https://blog.usejournal.com/@christossotiriou)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/things-about-react-native-i-found-the-hard-but-rewarding-way.md](https://github.com/xitu/gold-miner/blob/master/TODO1/things-about-react-native-i-found-the-hard-but-rewarding-way.md)
> * 译者：[jerryOnlyZRJ](https://github.com/jerryOnlyZRJ)
> * 校对者：[xilihuasi](https://github.com/xilihuasi)，[WangLeto](https://github.com/WangLeto)

# React Native 中那些令我收获颇丰的痛点

## 通过将 React Native 投入到各种规模的企业级项目中使用后的思考

![](https://cdn-images-1.medium.com/max/1600/1*TkSZ7PH0c6nqkJ3oFeSmBA.jpeg)

React Native 已经存在了一段时间了。当它支持 Android 的版本（iOS 之后大约一年）发布后，我便使用它进行专业级开发了，我决定投入时间在 RN 上进行跨平台开发。当我发现 React Native 时，我从事 iOS 开发工作已经六年了，而且不仅仅是 Mac OS X 的开发人员。

我已经在 App Store 和 Play Store 为我的客户开发了四个中等大小（一万到两万左右行代码，不包括依赖项）的项目。我还在一个使用 React Native 编写的代码超过五万行（除了本机代码）的大型项目中参与监督和贡献，现在已经部署上线并运行顺利。我已经积累了足够的经验来找出 React（和 React Native）闪耀的地方，和解决它短处的方案。

注意：我知道你们中的一些人在阅读这篇文章时会提到 [Flutter](https://flutter.io/)。但由于它的成熟度远不及它的竞争对手，所以我还没有深入了解它。

**在撰写本文时，React Native 的当前稳定版本为 0.57，即将到达 0.58RC。**

这是我的想法：

### React Native 最广为人知的特性却不是最重要的

React Native 最广为人知的特性是跨平台，但这并不是它引起我注意的原因。React Native 最重要的特性是**它使用 React，从而支持通用的声明式布局**。跨平台支持排在重要性的第二位。作为一名 iOS 开发人员，我一直在尝试那些不那么直观的用户界面设计方式的 Auto Layout 系统（指 IOS 开发使用的自动布局系统）。

如果你的系统具有高度动态性，并且屏幕上的元素相互依赖（比如一些侧边栏和动画），那么使用 Apple 的 Autolayout 是管理屏幕上内容的最佳方式。但是，对于大多数 Android 和 iOS 应用程序，情况并非如此。大多数 Android 和 iOS 应用程序都会使用我们经常看到的标准元素：文本、按钮、列表、通用视图和图像并以最类似于 Web 的方式布局。

在 AutoLayout 出现的同时，[flex 布局](https://css-tricks.com/snippets/css/a-guide-to-flexbox/)也被发明出来，并成为了屏幕上元素布局约定俗成的标准。除了标准的 Web 使用之外，还有一些布局系统旨在利用 FlexBox 原则进行原生开发：

*   [Yoga](https://github.com/facebook/yoga) 或者是一些依赖于它的衍生框架：安卓（Java 或 Kotlin）的 [Litho](https://fblitho.com/) 以及 iOS（Objective C++）的 [ComponentKit](https://componentkit.org/)。
*   [TextureKit](http://texturegroup.org/)（以前名为 AsyncDisplayKit）
*   [LinkedIn’s LayoutKit](https://github.com/linkedin/LayoutKit)（不是 flexbox，但和它相似）

这只是比较出名的一些，还有很多 UI 库。他们有一个共同点，就是他们都使用了声明式 UI。

#### 声明式 UI 的特点：

创建移动开发的声明式 UI 是为了解决传统布局系统所具有的问题。你声明了你的**意图**，系统会根据它们生成结果。

声明式 UI 解决的一些移动开发挑战如下：

**组件化**。iOS 使用 ViewControllers 中嵌套 ViewControllers 或者 views 中嵌套 views，而 Android 使用 Fragments。两者都具有 XML 接口声明，并且都允许运行时实例化和编辑视图。当涉及将它们分解为较小的模块或复用它们时，你就是在进行一个小型的重构。在声明式 UI 中，你随时都可以对模块或者组件进行复用。

**开发人员的生产力**。声明式 UI 负责为你调整组件大小。看看这段代码（React Native 示例）：

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

上面的代码渲染了一个只包含两个文本组件的 Component。注意 `this.props.sampleText`，如果此变量太长（例如 10000 个字符左右的长度）会发生什么？结果将会是组件将调整大小以适合整个文本。如果文本达到了可用空间的极限（比如说屏幕大小），那么视图将被剪切，用户将无法看到整个文本，你需要一个滚动视图。

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

**协作 —— 配合 Git 的友好体验**。我看到的每个声明式 UI 都能更好。

在 iOS 和 Android 上，如果你有大的单片 UI，那你就做错了。但是，大型 XML 文件在大多数情况下是不可避免的（请注意 iOS：XIB 实际上是 XML 文件）。它们的变化对代码审查者（或你）没有任何意义，如果你不同意之前的版本（你的更改或其他开发人员）**完整**保留，则发起 Pull Request 几乎是不可能的。

使用 React 和其他声明性 UI 库，这些问题在很大程度上被最小化，因为布局是实际代码，你可以更新、删除、合并、对比差异以及执行所有你你平时对其他软件执行的操作。

### 最关键的是知道“性能”究竟是什么

你可能需要成为移动开发人员才能掌握性能的概念，并管理有效的内存和数据处理器使用。

Web 开发人员可以在不了解原生的情况下使用 React Native 开发，这种说法仅适用于小型项目。一旦应用程序开始增长并且 Redux 的 store 的计算开始对应用程序的性能造成影响时，你将需要了解原生端如何工作的，才能理解为什么会这样。你还需要意识到 React Native 中的 Redux 的 Store 导致的重新渲染与 DOM 中发生的重新渲染并不完全相同，尤其是应用中的原生组件。

同时，在 React Native 上重新渲染应用程序的组件会变得代价昂贵。由于 React Native 本质是使用 bridge，因此你在 `render()` 函数内部提供的任何指令都将从 JavascriptCore 传递到 Java 或者 Objective C++。原生端将获取 `render()` 给出的 JSX 标签，并将它们转换为其原生对应部分，例如视图、标签和图像。如果转换每秒进行数百次，那就需要不可忽略的 cpu 时间。

在性能方面，似乎 React Native 是更好的跨平台解决方案之一。但是，在某些关键领域 React Native 仍然存在性能问题。

一个这样的例子是大型数据集（[和列表](https://github.com/facebook/react-native/issues/16186)）。在存在大型列表和网格视图的情况下，Android 和 iOS 都提供了一个出色且极其灵活的解决方案 —— 回收视图。想象一下，当使用大型列表视图（不论是 iOS 或是 Android）时，只渲染在任何给定时间显示的单元格。其他单元格被标记为可重复使用，以便在即将显示新单元格时可以重复使用它们。更改数据集时，操作系统只需更新显示的单元格。

React Native 为大型数据集提供 VirtualizedList 及其派生的（FlatList 和 SectionList）。然而，即使这样也有很多不足之处。存在性能开销，尤其是在 SectionList 中渲染复杂组件并尝试更新一百多个对象的大型数据集时。更新机制会使低端或中端移动设备缓慢运行。

为了解决这个问题，我已经从 Redux 切换到 MobX，它为我的组件提供了更可预测的更新。此外，在大型列表的情况下，MobX 可以更新特定单元格而无需重新呈现整个列表。通常这也可以通过 Redux 实现，但是你需要重写 `componentShouldUpdate()` 方法并编写更多样板文件以避免不必要的重新渲染。在将其余变量复制到新状态时，你的 reducer 仍会执行一些不必要的工作。

**写在最后**：总之要小心。如果你正在使用 React Native，要想让你的应用程有最好的表现效果，就要对 React 和原生的最佳实践都很熟悉。

### 了解 JS 运行时及其对你的影响非常重要。

可以通过将调试信息发送到 Chrome 对 React Native 进行调试。**这意味着在设备中运行实际代码的过程与你调试代码的过程不同**。

Android 和 iOS 上的 React Native 使用 JavascriptCore 执行 Javascript。但是，调试工具在 V8（Chrome）上运行。为了使系统有更普遍适用性，在撰写本文时，React Native 在 iOS 上使用 Apple 的 Javascript Core，而在 Android 上，他们使用的是[已经发布三年的 JS Core](https://github.com/facebook/android-jsc) 来构建脚本（因为 Android 没有提供任何像 iOS 这样现成的 JS 运行时，Facebook 也必须自己构建）。这就导致缺乏了很多 JS 新特性，比如 Proxy 对象只在 Android 上和 iOS 64 位上支持。因此，如果你想使用 [MobX 5+](https://github.com/mobxjs/mobx/blob/master/CHANGELOG.md#the-system-requirements-to-run-mobx-has-been-upped)，那你必须使用升级的 Javascript 运行时（继续阅读以了解如何做到这一点）。

运行时差异通常会导致错误只能在生产模式中重现。更糟糕的是，甚至有些错误会变得难以调试。

例如，当涉及 React Native 时，移动端数据库的最佳解决方案是 Realm。但是，当进入调试模式时，会发生这种情况：[https://github.com/realm/realm-js/issues/491](https://github.com/realm/realm-js/issues/491)。虽然 Realm 的研发人员已经解释了[为什么会这样](https://github.com/realm/realm-js/issues/491#issuecomment-350718316)，但最重要的是，如果我们想要一个更稳定的调试解决方案，必须改进 React Native 的调试架构。好消息是我一直在使用 [Haul](https://callstack.github.io/haul/) 作为我的捆绑包，它允许我直接从我的 iOS 设备进行调试，而无需通过 Chrome Dev Tools（不幸的是，你需要 Mac、iOS 模拟器和 Safari）。

请注意，Facebook 上的人已经发现了这个问题，他们正在重新设计 React Native 的核心，以便原生和 React Native 部分可以共享相同的内存。完成此操作后，可能可以直接在设备的 JavaScript 运行时上进行调试。（参照文章：[React Native Fabric (UI-Layer Re-architecture)](https://github.com/react-native-community/discussions-and-proposals/issues/4)）

不仅如此，React Native 社区[现在提供了 JS android 构建脚本](https://github.com/react-native-community/jsc-android-buildscripts)，它能够构建针对较新版本的 JavascriptCore 的脚本并将其嵌入到 React Native 应用程序中。这使 Android 上的 React Native 的 Javascript 功能能与 iOS 相提并论，也为在 Android 上运行的 React Native 增加了 64 位支持奠定了基础。

### 使用 React Native 进行应用内导航效果非常棒

你是否开发过带有身份验证的移动应用程序？如果用户收到一条推送通知，并且只有先在登录界面登录后才能看到推送通知内容界面，会怎么样？或者，如果你当前已经在一个应用程序中的深层次界面并希望跳转到另一个应用程序中的完全不同的区域作为对用户操作的响应，又该怎么办？

使用原生的方法可以解决这一问题，但需要花费一些努力。而使用 [React Navigation](https://reactnavigation.org/)，它们甚至都不是问题。深层的链接和导航跳转能让用户感觉自然而流畅。虽然还有其他导航库，但 React Navigation 被认为是事实上的标准。你应该试一试，这是 React Native 比 iOS 和Android 更好的**地方**。

### React Native 不是银色子弹（灵丹妙药）

与任何其他技术一样，你需要在投入使用前了解它能做什么不能做什么。以下是 RN 在哪些类别的应用上具有优势：

*   内容驱动的应用程序
*   具有 Web 式 UI 的应用程序
*   可能需要或可能不需要快速上市时间的跨平台应用程序

这里还列出了一些对于 RN 来说表现不算太好的一些类别的应用：

*   具有巨大列表的应用程序
*   无需布局的媒体驱动的应用程序（例如：简单/小型游戏、动画、视频处理程序）或屏幕到屏幕的过渡。
*   CPU 密集型任务

确实，对于 React 无法做到的事情，你可以在原生中编写所需的所有内容，然后从 React Native 调用相应的代码。但这意味着你需要为每个平台（iOS、Android）编写一次代码，然后为 Javascript 接口编写额外的代码。

React Native 的内部组件目前正在经历一个主要的重构，以让 RN 可以并行执行更多同步操作，以便它可以与原生共享公共代码：[https://facebook.github.io/react-native/blog](https://facebook.github.io/react-native/blog/2018/11/01/oss-roadmap)。因此，在此之前，你应该在决定是否使用它之前进行一些研究。

### 结论

React Native 是一个经过深思熟虑且发展良好的平台。它为你的应用打开了 NodeJS 的世界，让你在最好的布局系统中进行编程。它还为你提供了与原生方面的良好 bridge，以便你可以充分利用这两个世界。

然而，它也属于另一个奇怪的类别，有时候你只需要一个团队来开发你的应用程序，但有时候也需要三个！在某些时候，你需要一些 iOS 和 Android 开发人员来构建 React Native 默认情况下没有的组件。一旦你的团队开始成长，你将不得不决定是否将你的应用程序设为 100％ 原生。因此，你为下一个项目是否选择 React Native，取决于你拥有多少原生代码（Java、Kotlin、Swift、ObjC）。

我的个人建议：如果你意识到你需要三个团队来开发一个应用程序的三个不同层面（一个 iOS 团队、一个 Android 团队和一个 React 团队），那么你应该可以一直使用原生 iOS 和 Android 并抛弃 React Native 。仅维护两个代码库而不是开发三个代码库，你将节省时间和金钱。

但是，如果你拥有一个由熟练的开发人员组成的小团队并希望构建内容应用程序或类似的软件，那么 React Native 是一个很好的选择。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
