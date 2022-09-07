> * 原文地址：[SwiftUI in 2021: The Good, the Bad, and the Ugly](https://betterprogramming.pub/swiftui-2021-the-good-the-bad-and-the-ugly-458c6ee768f9)
> * 原文作者：[Chrys Bader](https://medium.com/@chrysb)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/swiftui-2021-the-good-the-bad-and-the-ugly.md](https://github.com/xitu/gold-miner/blob/master/article/2021/swiftui-2021-the-good-the-bad-and-the-ugly.md)
> * 译者：[earthaYan](https://github.com/earthaYan)
> * 校对者：[Lokfar](https://github.com/Lokfar)、[lsvih](https://github.com/lsvih)、[jaredliw](https://github.com/jaredliw)

# 2021 年的 SwiftUI: 优势、劣势和缺陷

> 在生产环境使用 SwiftUI？**仍然不可行。**

![由 [Maxwell Nelson](https://unsplash.com/@maxcodes?utm_source=medium&utm_medium=referral) 在 [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral) 发布](https://cdn-images-1.medium.com/max/12000/0*Wexfei50ZXms6ocU)

过去的 8 个月，我一直在用 SwiftUI 开发复杂的应用程序，其中就包括最近在 App Store 上架的 [Fave](https://apps.apple.com/us/app/fave-close-friends-only/id1541952688)。期间遇到了很多限制，也找到了大多数问题的解决方法。

简而言之，SwiftUI 是一个很棒的框架，并且极具前景。我认为它就是未来。但是要达到和 UIKit 同等的可靠性和健壮性，可能还需要 3-5 年。但是这并不意味着现在不应该使用 SwiftUI。我的目的是帮助你理解它的利弊，这样你可以就 SwiftUI 是否适合下一个项目做出更明智的决定。

## SwfitUI 的优势

### 1. 编写 SwiftUI 是一件乐事，而且你可以快速构建用户界面

使用 `addSubview` 和 `sizeForItemAtIndexPath`，小心翼翼地计算控件的大小与位置，应对烦人的约束问题，手动构建视图层次结构，这样的日子已经一去不复返了。SwiftUI 的声明式和响应式设计模式使得创建响应式布局和 React 一样简单，同时它还背靠 Apple 强大的 UIKit。用它构建、启动并运行视图快到不可思议。

### 2. SwiftUI 简化了跨平台开发

我最兴奋的事情就是只需要编写一次 SwiftUI 代码，就可以在 iOS (iPhone 和 iPad)，WatchOS 和 macOS 上使用。同时开发和维护 Android 和 Windows 各自的代码库已经很困难了，所以在减少不同代码库的数量这方面，每一个小的改变都很有帮助。当然还是有一些缺点，我将会在 “劣势”  章节分享。

### 3. 你可以免费获取漂亮的转场效果，动画和组件

你可以把 SwiftUI 当作一个 UI 工具箱，这个工具箱提供了开发专业应用程序所需的所有构建块。另外，如果你熟悉 CSS 的 Transition 属性，你会发现 SwiftUI 也有一套类似的方法，可以轻松创建优雅的交互过程。声明式语法的魅力在于你只需要描述你需要什么样的效果，效果就实现了，这看上去像魔法一样，但是也有不好的一面，我之后将会介绍。

### 4. UI 是完全由状态驱动并且是响应式的

如果你熟悉 React 的话，SwiftUI 在这一点上完全类似。当你监听整个 UI 的”反应“，动画和所有一切的时候，你只需要修改 `@State` 和 `@Binding` 以及 `@Published` 属性，而不是使用多达几十层的嵌套回调函数。使用 SwiftUI，你可以体会到 `Combine` 、`ObservableObject` 以及 `@StateObject` 的强大。这方面是 SwiftUI 和 UIKit 最酷的区别之一，强大到不可思议。

### 5. 社区正在拥抱 SwiftUI

几乎每个人都在因为 SwiftUI 而兴奋。SwiftUI 有许多学习资源可供获取，从 WWDC 到书，再到博客 —— 资料就在那里，你只需要去搜索它。如果不想搜索的话，我这里也汇总了一份最佳社区资源列表。

拥有一个活跃且支持度高的社区可以加速学习，开发，并且大量的新库会使得 SwiftUI 用途更加广泛。

## 劣势

### 1. 不是所有组件都可以从 SwiftUI 中获取到

在 SwiftUI 中有许多缺失、不完整或者过于简单的组件，我将在下面详细介绍其中一部分。

使用 `UIViewRepresentable`、`UIViewControllerRepresentable` 和 `UIHostingController` 协议可以解决这一问题。前两个让你可以在 SwiftUI 视图层中嵌入 UIKit 视图和控制器。最后一个可以让你在 UIKit 中嵌入 SwiftUI 视图。在 Mac 开发中也存在类似的三种协议 (`NSViewRepresentable` 等)。

这些协议是弥补 SwiftUI 功能缺失的权宜之计，但并不是一直天衣无缝。而且，尽管 SwiftUI 的跨平台承诺很好，但是如果某些功能不可用的话，你仍然需要为 iOS 和 Mac 分别实现协议代码。

### 2. NavigationView 还没有真正实现

如果你想在隐藏导航栏的同时仍然支持滑动手势，这是不可能的。我最终参考一些找到的代码创建了一个 [UINavigationController wrapper](https://gist.github.com/chrysb/d7d85e20d8c94fd3e0b753a4abd1c941)。尽管可以起作用，但这不是一个长远的解决方案。

如果你想要在 iPad 上拥有一个 SplitView，但目前你还不能以纵向模式同时展示主视图和详情视图。他们选择用一个简陋的按钮展示默认关闭的抽屉。显然，你可以通过添加 padding 来解决这个问题，它可以突出显示你在使用 SwiftUI 时必须做的事情。

当你想使用编程式导航的时候，`NavigationLink` 是一种流行的解决方案。这里有一个[有趣的讨论](https://forums.swift.org/t/implementing-complex-navigation-stack-in-swiftui-and-the-composable-architecture/39352)。

### 3. 文本输入十分受限

`TextField` 和 `TextEditor` 现在都太简单了，最终你还是会退回到 UIKit。所以我不得不为 `UITextField` 和 `UITextView` 构建自己的 `UIViewRepresentable` 协议（以实现文本行数的自动增加）。

### 4. 编译器困境

当视图开始变得笨重，并且你已经竭尽所能去提取分解，编译器仍然会冲着你咆哮：

> The compiler is unable to type-check this expression in reasonable time; try breaking up the expression into distinct sub-expressions.

这个问题已经多次拖慢进度。由于这个问题，我已经很擅长注释代码定位到引起问题的那一行，但是 2021 年了还在用这种方法调试代码感觉非常落后。

### 5. matchedGeometryEffect

我第一次发现[这个](https://developer.apple.com/documentation/swiftui/view/matchedgeometryeffect(id:in:properties:anchor:issource:))的时候，感觉很神奇。它目的是通过匹配一隐一现的几何形状，帮助你更加流畅地转换两个不同标识的视图。我觉得这有助于从视图 A 优雅地转场到 B 视图。

我一直想让它起作用。但最终还是放弃了，因为它并不完美。此外，在包含大量列表项的 `List` 或 `ScrollView` 中使用它会导致项目瘫痪。我只推荐在同一视图中使用这个做简单的转换过渡。当你在多个不同的视图中共享一个命名空间的时候（包括转场期间的视图剪裁在内），事情就会开始变得奇怪。

### 6. 对手势的支持有限

SwiftUI 提供了一系列新的手势（即 `DragGesture` 和 `LongPressGesture`）。这些手势可以通过 `gesture` 修饰符（如 `tapGesture` 和 `longPressGesture`）添加到视图中。它们都能正常工作，除非你想要做更复杂的交互。

比如，`DragGesture` 和 `ScrollView` 交互就不是很好。即使有了 `simultaneousGesture` 修饰符，在 ScrollView 中放一个 `DragGesture` 还是会阻止滚动。在其他情况下，拖动手势可以在没有任何通知的情况下被取消，使得手势处于不完整状态。

为了解决这个问题，我构建了自己的 `GestureView`，它可以在 SwiftUI 中使用 UIKit 手势。我会在下一篇关于最佳 SwiftUI 库和解决方案的文章中分享这部分内容。

### 7. 分享扩展中的 SwiftUI

我可能是错的，但是分享扩展还是使用 UIKit 吧。我通过 `UIHostingController` 用 SwiftUI 构建了一个分享扩展，当分享扩展加载完毕后，有一个非常明显的延迟，用户体验较差。你可以尝试通过在视图中添加动画去掩盖它，但是仍然有 500 毫秒左右的延迟。

### 值得一提的点

* 无法访问状态栏 (不能修改颜色或拦截点击)
* 由于缺少 `App`，我们仍然需要 `@UIApplicationDelegateAdaptor`
* 不能向后兼容
* `UIVisualEffectsView` 会导致滚动延迟（来源于推特：@[AlanPegoli](https://twitter.com/alanpegoli?lang=en)）

## 缺陷

### 1. ScrollView

这是迄今为止最大的缺点之一。任何一个构建过定制化 iOS 应用的人都知道我们有多依赖 ScrollView 去支持交互。

* **主要的障碍**：视图中的 `LazyVStack` 导致[卡顿、抖动和一些意外的行为](https://stackoverflow.com/questions/66523786/swiftui-putting-a-lazyvstack-or-lazyhstack-in-a-scrollview-causes-stuttering-a/67895804)。`LazyVStack` 对于需要滚动的混合内容（如新闻提要）的长列表至关重要。**仅凭这一点，SwiftUI 就还没准备好投入生产环境：** Apple 已经证实，这是 SwiftUI 自身的漏洞。尚未清楚他们什么时候会修复，但是一旦修复了，这将是一个巨大的胜利。
* **滚动状态**：原生不支持解析滚动的状态（滚动视图是否正在被拖拽？滚动？偏移多少？）。尽管有一些解决方案，但是还是很繁琐且不稳定。
* **分页**：原生不支持分页滚动视图。所以打消实现类似于可滑动的媒体库的念头吧（但是如果你想要关闭一些东西的时候，可以使用 [`SwiftUIPager`](https://github.com/fermoya/SwiftUIPager)）。在技术上你可以使用  `TabView` 加 `PageTabViewStyle`，但是我认为它更适合少部分的元素，而不是大的数据集。
* **性能**：使用 `List` 是性能最好的，并且避免了 `LazyVStack` 的卡顿问题，但由于工作方式的转换，它仍然不适合显示可变大小的内容。例如，在构建聊天视图时，其过渡很奇怪，会裁剪子视图，并且无法控制插入的动画样式。

## 结论

毫无疑问我觉得应该学习 SwiftUI ，自己去理解它，并享受乐趣。但是先别急着全盘采用。

SwiftUI 已经为简单的应用程序做好了准备，但是在写这篇文章的时候（iOS 15，beta 4 版本），我不认为它已经适合复杂应用程序的生产环境，主要是由于 `ScrollView` 的问题和对 `UIViewRepresentable` 的严重依赖。我很遗憾，尤其是像即时通信产品，新闻摘要，以及严重依赖复杂视图或者想要创建手势驱动的定制体验产品，目前还不适合使用 SwiftUI。

如果你想要精细的控制和无限的可能性，我建议在可预见的未来坚持使用 UIKit。你可以在一些视图（如设置页）里通过使用 `UIHostingController` 包装 SwiftUI 视图以获得 SwiftUI 的好处。

## 未来会发生什么？

当开始着手我们项目的下一次大迭代的时候。我知道这个新项目的交互范围不在 SwiftUI 目前支持的范围之内。即使当我知道 SwiftUI 在某些关键方面存在不足的时候，我的心都碎了，但是我还是不打算退回到 UIKit，因为我知道当 SwiftUI 运行起来时，构建它是一件多么快乐的事情。它的速度如此之快。

SwiftUI 会兼容 UIKit 么？如果这样的话，我们可能需要等待 SwiftUI 使用 3-5 年的时间来移植所有必要的 UIKit API。如果 SwiftUI 不准备兼容 UIkit，那你也能通过 SwiftUI 封装的方式使用 UIKit。

我好奇的是 Apple 会在 SwiftUI 上投入多少。他们是否有让所有的开发者采用 SwiftUI 的长期计划，或者说 SwiftUI 只是另一个界面构建器而已？我希望不是，也希望他们能全心投入 SwiftUI，因为它的前景是非常诱人的。

## 更多看法

* [Is SwiftUI Ready?](https://www.jessesquires.com/blog/2021/07/01/is-swiftui-ready/)
* [SwiftUI Drawbacks: Why SwiftUI Is Not Ready for Production Yet](https://www.iosapptemplates.com/blog/swiftui/swiftui-drawbacks)
* [My takeaway from working with SwiftUI](https://link.medium.com/isXKLhaaCib)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
