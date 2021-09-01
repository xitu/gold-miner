> * 原文地址：[SwiftUI in 2021: The Good, the Bad, and the Ugly](https://betterprogramming.pub/swiftui-2021-the-good-the-bad-and-the-ugly-458c6ee768f9)
> * 原文作者：[Chrys Bader](https://medium.com/@chrysb)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/swiftui-2021-the-good-the-bad-and-the-ugly.md](https://github.com/xitu/gold-miner/blob/master/article/2021/swiftui-2021-the-good-the-bad-and-the-ugly.md)
> * 译者：[ItzMiracleOwO](https://github.com/itzmiracleowo)
> * 校对者：

# 2021 的 SwiftUI : 好处、坏处以及丑处

> 有生产力的 SwiftUI? **依旧不行.**

![由 [Maxwell Nelson](https://unsplash.com/@maxcodes?utm_source=medium&utm_medium=referral) 在 [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral) 发布的图片](https://cdn-images-1.medium.com/max/12000/0*Wexfei50ZXms6ocU)

过去 8 个月我一直在用 SwiftUI 开发复杂的应用程序, 包括我们最近发布到 AppStore 的应用 —— [Fave](https://apps.apple.com/us/app/fave-close-friends-only/id1541952688)。尽管我遇到了无数此的限制，但我仍然找到了大多数问题的解决方法。

简而言之，SwiftUI 是一个美妙且非常有前途的框架。我认为 SwiftUI 就是未来。但是，要达到与 UIKit 相同的可靠性和稳健性，可能还需要 3 到 5 年的时间。但是，这并不意味着你今天不应该使用 SwiftUI。我的目标是帮助你权衡其优点和缺点，以便你可以就 SwiftUI 是否适合你的下一个项目做出更明智的决定。

## 优点

### 1.SwiftUI 編寫起來很有趣，而且你可以十分快速地进行構建

`addSubview` 和 `sizeForItemAtIndexPath` 的日子已经一去不复返了，它们苦苦计算帧、与约束搏斗以及手动构建视图层次结构。SwiftUI 的声明式和反应式设计模式使创建响应式布局和 React 一样简单，而且他还使用了 Apple 强大的 UIKit。他构建视图并开始运行的速度非常快。

### 2. SwiftUI 简化了跨平台开发

我最兴奋的一件事是，你可以编写一次 SwiftUI，然后在 iOS（iPhone 和 iPad）、WatchOS 和 macOS 上使用它。虽然你必须为 Android 和 Windows 开发和维护单独的代码库，这已经够麻烦了，但是任何一点的简化都有助于减少不同代码库的数量。还有一些缺点，我将在 '缺点' 的部分分享。

### 3. 你可以免费获得漂亮的过渡动画、动画和组件

你可以将 SwiftUI 视为一个实际提供了制作具有专业外观的应用程序所需的所有构建模块的 UI 套件。如果你熟悉 CSS 轉場，SwiftUI 有自己的版本，可以非常轻松地创建精美的交互。声明式语法的美妙之处在于事情能够 "正常工作" 并且看起来很神奇，但他也有一些缺点，我也会在后面介绍。

### 4. UI 完全是状态驱动和反应式的

如果你熟悉 React，SwiftUI 的工作原理是一样的。当你观看整个 UI "反应"、动画和所有内容时，你将会高兴地更改 `@State`、`@Binding` 和 `@Published` 属性，而不是回调地狱。你可以利用 `Combine` 与 `ObservableObject` 和 `@StateObject` 的强大功能。这方面是 UIKit 最酷的变化之一，而且它非常强大。

### 5. 社区正在拥抱 SwiftUI

几乎每个人都对 SwiftUI 感到兴奋。有很多资源可用于学习 SwiftUI，从 WWDC，到书籍，再到博客 —— 信息都在那里，你只需要搜索它。或者，我在这里汇总了一份最佳社区资源列表。

拥有一个充满活力和支持的社区将加速学习和开发，大量新库的出现将使 SwiftUI 更加通用。

## 坏处

### 1. SwiftUI 尚未提供完整的支援(?)

SwiftUI 中有许多组件缺失、不完整或过于简单，我将在下面详细介绍其中一些。

有一个使用 `UIViewRepresentable`、`UIViewControllerRepresentable` 和 `UIHostingController` 的解决方案。前两者允许您将 UIKit 视图和控制器嵌入到 SwiftUI 视图层次结构中。后者允许您在 UIKit 中嵌入 SwiftUI 视图。Mac 开发存在相同的三个 (`NSViewRepresentable` 等)。

这些桥梁是弥补 SwiftUI 缺失功能的一个很好的权宜之计，但有时候他并不是一种无缝体验。此外，虽然 SwiftUI 的跨平台 promise 很棒，但如果某些东西不可用，您仍然需要为 iOS 和 Mac 实现两次桥接代码。

### 2. NavigationView 还没有真正存在

如果你想隐藏导航栏并且仍然可以使用滑动手势，你不能这么做。迫于无奈，我最后参考了一些我找到的代码，并制作了一个 [UINavigationController 包装器](https://gist.github.com/chrysb/d7d85e20d8c94fd3e0b753a4abd1c941)。他可以正常工作但是这不是一个长远的解决办法。

如果你想在 iPad 上有一个 SplitView，你还不能在纵向模式下同时显示主视图和细节视图。他们选择了一个笨拙的按钮来显示一个默认关闭的抽屉。显然，您可以通过添加填充来解决这个问题，这突出了您在处理 SwiftUI 时必须做的事情。

当您想以编程方式导航时，`NavigationLink` 是一个时髦的解决办法。这是一个[有趣的帖子](https://forums.swift.org/t/implementing-complex-navigation-stack-in-swiftui-and-the-composable-architecture/39352)。

### 3. 文字输入有许多限制

`TextField` 和 `TextEditor` 现在太简单了，你最终将会退回到 UIKit。我必须为 `UITextField` 和 `UITextView`（具有自动增长支持）构建自己的 "UIViewRepresentable"。

### 4. 编译器支援问题

当你的视图变得有点大并且你已经尽你所能地将它分解出来时，编译器仍然可以喘口气，告诉你：

> 编译器无法在合理的时间内对该表达式进行类型检查......

这拖慢了我的进度好几次。我已经十分擅长注释代码并将其缩小到导致问题的行，但在 2021 年调试这样的代码感觉真的很落后。

### 5. matchedGeometryEffect

当我发现 [这个](https://developer.apple.com/documentation/swiftui/view/matchedgeometryeffect(id:in:properties:anchor:issource:)) 的时候, 我以为它很神奇. 它应该通过在一个几何图形出现和另一个消失时匹配它们来帮助您更无缝地转换不同的两个视图。我认为这将有助于从视图 A 到视图 B 进行更漂亮的过渡。

我一直想让它工作。最终，我放弃了它，因为它并不完美，并且当你在包含很多项目的 `List` 或 `ScrollView` 中使用它时会导致崩溃。我只建议将它用于同一视图中的简单转换。当你在多个不同的视图之间共享一个命名空间时，事情开始变得很奇怪，包括过渡期间的视图剪辑。

### 6. 手势是有限的

SwiftUI 带有一组新的手势(即 `DragGesture` 和 `LongPressGesture`)，可以使用 `gesture` 便利修饰符 (如 `tapGesture` 和 `longPressGesture`) 添加到视图中。在您想要进行更复杂的交互之前，它们都可以正常工作。

例如，`DragGesture` 不能很好地与 `ScrollView` 交互。在 `ScrollView` 中使用 `DragGesture` 将会阻止滚动，即使使用 `simultaneousGesture` 修饰符也是如此。在其他情况下，拖动手势可能会在没有任何通知的情况下被取消，从而使手势处于未完成状态。

为了解决这个问题，我构建了自己的 `GestureView`，它允许我在 SwiftUI 中使用 UIKit 手势。我将在下一篇关于最佳 SwiftUI 库和解决方法的文章中分享这一点。

### 7. 共享扩展中的 SwiftUI

我可能是错的，但 Share Extensions 仍然使用 UIKit。我通过利用 UIHostingController 使用 SwiftUI 构建了一个共享扩展，但在加载共享扩展时出现了明显的延迟，造成了糟糕的用户体验。虽然您可以尝试通过动画视图来屏蔽它，但它仍然有大约 500 毫秒的延迟。

### 榮譽獎

* 无法访问状态栏 (无法更改颜色或拦截点击)
* 由于缺少 `App`，我们仍然需要 `@UIApplicationDelegateAdaptor`
* 没有向后兼容性
* `UIVisualEffectsView` 导致 \< iOS15 中的滚动延迟 (h/t @[AlanPegoli](https://twitter.com/alanpegoli?lang=en))

## 丑处

### 1. ScrollView

这是迄今为止最大的缺点之一。任何开发过定制化 iOS 应用的人都知道我们在多大程度上依赖 ScrollView 来支持交互。

* **主要问题:** [ScrollView 中的 `LazyVStack` 会导致卡顿、抖动和意外行为](https://stackoverflow.com/questions/66523786/swiftui-putting-a-lazyvstack-or-lazyhstack-in-a-scrollview-causes-stuttering-a/67895804)。LazyVStacks 对于需要滚动的混合内容的长列表至关重要，例如新闻提要。**仅此一项就使 SwiftUI 无法投入生产：** Apple 已向我确认这是 SwiftUI 中的一个漏洞。目前还不清楚他们什么时候会修复它，但是当他们这样做时，这将是一个巨大的胜利。
* **滚动状态：** 没有幫助理解滚动状态的原生工具（滚动视图是在拖拽？滚动？偏移量是多少？）。虽然有一些解决方法，但它们可能很挑剔且不稳定。
* **分页：** 对分页滚动视图没有原生支持。所以，忘记做类似可滑动的媒体库之类的事情 (但如果你想要接近的东西，你可以试试看 [SwiftUIPager](https://github.com/fermoya/SwiftUIPager))。从技术上讲，您可以将 `TabView` 与 `PageTabViewStyle` 一起使用，但我认为它更适用于少数元素而不是大型数据集。
* **性能：** 使用 `List` 是性能最好的，并且避免了 `LazyVStack` 的卡顿问题，但由于转换的工作方式，它仍然不适合显示可变大小的内容。例如，在构建聊天视图时，其过渡很奇怪并且会剪辑子视图，并且您无法控制插入动画样式。

## 判决

我认为你绝对应该学习SwiftUI，自己理解它，体验它的乐趣。但是暂时不要完全采用它。

SwiftUI 适用于简单的应用程序，但在撰写本文时（iOS 15，beta 4），我认为 SwiftUI 还没有为复杂的应用程序做好生产准备，主要是由于 `ScrollViews` 的问题和严重依赖 `UIViewRepresentable`。它伤了我的心。特别是对于消息产品、新闻提要或是严重依赖复杂视图和想要创建手势驱动的定制体验的产品，目前还不能使用 SwiftUI。

如果你想要细粒度的控制和无限的可能性，我建议在可预见的未来坚持使用 UIKit。通过使用 `UIHostingController` 包含 SwiftUI 视图，您仍然可以从某些视图（如设置页面）中获得 SwiftUI 的好处。

## 未来会怎样？

当我们开始着手我们项目的下一个大迭代时。我知道这个新项目的交互范围超出了 SwiftUI 当前支持的范围。知道 SwiftUI 在某些关键方面存在不足让我感到心碎，但我还没有准备好回到 UIKit，因为我提要了在 SwiftUI 中构建它是多么的快乐。它只是快得多。

SwiftUI 会匹配 UIKit 吗？ 如果是这样，我们可能需要 3 到 5 年的时间来移植所有基本的 UIKit API。如果没有，那么你总是能够使用 UIKit 并用 SwiftUI 包装它。

我很好奇的是 Apple 在 SwiftUI 上的投入程度。他们的长期计划是让所有开发人员完全采用 SwiftUI，还是只是成为另一个 Interface Builder？ 我真的希望不是。我希望他们全力支持 SwiftUI，因为它的 promise 令人惊叹。

## 更多观点

* [SwiftUI 准备好了吗?](https://www.jessesquires.com/blog/2021/07/01/is-swiftui-ready/)
* [SwiftUI 缺点：为什么 SwiftUI 还没有准备好投入生产](https://www.iosapptemplates.com/blog/swiftui/swiftui-drawbacks)
* [我使用 SwiftUI 的收获](https://link.medium.com/isXKLhaaCib)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
