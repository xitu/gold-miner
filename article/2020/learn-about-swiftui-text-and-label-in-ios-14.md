> * 原文地址：[Learn About SwiftUI Text and Label in iOS 14](https://medium.com/better-programming/learn-about-swiftui-text-and-label-in-ios-14-bfee41252117)
> * 原文作者：[Anupam Chugh](https://medium.com/@anupamchugh)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/learn-about-swiftui-text-and-label-in-ios-14.md](https://github.com/xitu/gold-miner/blob/master/article/2020/learn-about-swiftui-text-and-label-in-ios-14.md)
> * 译者：[chaingangway](https://github.com/chaingangway)
> * 校对者：

# 学习 SwiftUI 框架中 Text 和 Label 控件的用法（iOS 14）

![Photo by [Prateek Katyal](https://unsplash.com/@prateekkatyal?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/12000/0*ooJiyXobPr83YYhC)

虽然苹果并没有将 SwiftUI 的第二个版本称为 2.0，但是在 WWDC 2020 大会上确实宣布了一些重大更新。

除了引入 `Grids` 和 `MatchedGeometryEffect` 之外，`Text` 控件也获得了巨大的提升。除此之外，还引入了 `Label`，`Link` 和 `TextEditor`，这些控件可以让开发者更加容易构建表单，按钮和精美的文本。

在下面的几节中，我们将学习 iOS 14 系统下 SwiftUI 的新控件 `Text`。

## SwiftUI Text 支持更强大的插入元素

在今年的更新中，`Text` 控件有了新的初始化方法，可以让您在 `Text` 内部设置日期格式，在图像中插入字符，以及添加 `Text`。

让我们看看如何在 `Text` 中插入 SF 符号图像：

```swift
Text("Hello, \(Image(systemName: "heart.fill"))

Text(Image(systemName:))
```

下面的示例中展示了将几个 `Text` 控件联结的效果：

![](https://cdn-images-1.medium.com/max/2032/1*SfNGGiAV9nVfBhNJGrp15A.png)

`Text` 控件有两个初始化方法，以字符串的形式插入日期 —— 即日期间隔和日期区间，还有一个可选参数来设置样式。

下面是用两种不同的方式在 `Text` 控件中设置并格式化日期：

```swift
Text(Date().addingTimeInterval(600))
Text(Date().addingTimeInterval(3600),style: .time)
```

`addTimeInterval` 方法只能接受真实的数值参数，所以上面两句代码中，第一句设置日期为 `T + 10` 分钟，另一句设置日期为 `T + 1` 小时，并用不同的样式来展示。

API 新语义的神奇之处在于，可以在 `Text` 初始化方法中使用 `relative`，`timer` 和 `offset` 样式设置计数器或计时器。

```swift
//countdown timer to update every minute
Text(Date().addingTimeInterval(60),style: .offset)
```

现在您可能会觉得设置计时器会触发 SwiftUI 视图主体的秒刷机制，但事实并非如此。

`Text` 将计数器视为动画，这意味着它将在时间区间内插入值。让我们看一下几种不同的 `Text`：

![](https://cdn-images-1.medium.com/max/2000/1*O75Bp3RQwMUsiQrHytKPSw.gif)

请注意三种不同样式的 `Timer` 的行为方式。它们会在计数器的末尾自动反转。

`Text` 还可以在保留其各自身份的同时，在 `Text` 内插 `Text`。就像“盗梦空间”。

## 用 SwiftUI 中的 Label 实现图文混排

SwiftUI 中的 `Label` 组件可以替代我们常用的 view：把图文包装在 `栈` 里。

下面是使用 `Label` 的方法：

```swift
Label("Hello Label", systemImage: "sun.min")

Label("Hello Label", image: "asset_image")

Label(title: {Text("..")}, icon: {Image(..)})
```

Label 控件也提供了 `labelStyle` 方法，它有两个内置变量 `TitleOnlyLabelStyle` 和 `IconOnlyLabelStyle`。当然，你也可以自定义标签的样式。

在下面的截图中，展示了不同种类的 `Label` 以及它们在 `ContextMenu` 中使用方法：

![](https://cdn-images-1.medium.com/max/2000/1*wtKfv_zgpAc83QGdmkWJww.gif)

`Label` 的这种特性可以让我们在实现 `ContextMenu` 按钮时不用去定义多余的 `Text` 和 `Image`。

当然，我们也希望 SwiftUI 的按钮组件能设置图片。

## 自定义 Label 样式

通过遵守 `LabelStyle` 协议，我们可以创建自定义样式。

下面的代码是让图标和文本垂直布局。

```swift
struct VLabelStyle: LabelStyle {
        func makeBody(configuration: Configuration) -> some View {
            VStack {
                configuration.icon
                configuration.title
            }
        }
}
```

现在可以在 view 的修改器中使用 `.labelStyle(VLabelStyle())`。

## 总结

`Text` 组件现在可以支持在一行代码中（实际上只用几个单词）设置定时器。

`Label` 组件在 context menus 中的使用更加便利。

你可以在 [gist link](https://gist.github.com/anupamchugh/e4df9b9734634a5cf59b51f784e08610) 中阅读或者下载本文的所有代码。

感谢阅读！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
