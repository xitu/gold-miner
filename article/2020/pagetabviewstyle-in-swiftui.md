> * 原文地址：[PageTabViewStyle in SwiftUI](https://medium.com/better-programming/pagetabviewstyle-in-swiftui-7a2aba16e439)
> * 原文作者：[Kelvin Tan](https://medium.com/@zhiyao92)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/pagetabviewstyle-in-swiftui.md](https://github.com/xitu/gold-miner/blob/master/article/2020/pagetabviewstyle-in-swiftui.md)
> * 译者：[Franz Wang](https://github.com/FranzWang666)
> * 校对者：[zenblo](https://github.com/zenblo)

# SwiftUI 中的 PageTabViewStyle

![Photo by [Charles Deluvio](https://unsplash.com/@charlesdeluvio?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral).](https://cdn-images-1.medium.com/max/8512/0*HuDzGczsUftDGQKL)

在最近的 WWDC 2020 大会上，苹果为“TabView”新增了名为“PageTabViewStyle”的样式，类似于水平分页滚动效果，常被用于引导页。

> **“一种实现了 `TabView` 分页的 `TabViewStyle`。” — [苹果官方文档](https://developer.apple.com/documentation/swiftui/pagetabviewstyle)**

## 预备知识

学习本教程前，你需要掌握以下基础知识：

* Swift
* Xcode 12+

**注意：仅支持 iOS 14+**

## PageTabViewStyle 入门

我们来快速实现一个 `TabView`，底部显示不同图标，选中时填充图片或未选中时不填充。

你需要一个 `state` 来判断是否选中：

```
@State private var selected = 0
```

默认的选中态是 `0`，你可以在设置中更改它：

```Swift
TabView() {
    Text("First Tab").tabItem {
        Image(systemName: (selected == 0 ? "house.fill" : "house"))
        Text("Home")
    }
    Text("Second Tab").tabItem {
        Image(systemName: (selected == 1 ? "plus.circle.fill" : "plus.circle"))
        Text("Add")
    }
    Text("Third Tab").tabItem {
        Image(systemName: (selected == 2 ? "heart.fill" : "heart"))
        Text("Favorite")
    }
    Text("Fourth Tab").tabItem {
        Image(systemName: (selected == 3 ? "person.fill" : "person"))
        Text("Profile")
    }
}
```

![](https://cdn-images-1.medium.com/max/2484/1*sKnXiZdPNgiSLQwyjh7auQ.png)

做完这些之后，你只需要一个简单的 modifier，就可以实现水平滚动页面。在 `TabView` 后面添加 `.tabViewStyle(PageTabViewStyle())`：

```
TabView() {
..
..
}.tabViewStyle(PageTabViewStyle())
```

你的 tab 页面现在可以滚动了。

![](https://cdn-images-1.medium.com/max/2000/1*UEG4z-2uTsEeSx8gMRo2KA.gif)

你还需要一个页面指示器（page indicator）。实际上它已经在那里了，只是颜色和背景色一样是白色的，所以看不见它。

有多种方法解决这个问题，你可以换一个背景色，也可以改变页面指示器的参数。

把背景设置为绿色，可以看到页面指示器，它显示了 tab 对应的图片。

![](https://cdn-images-1.medium.com/max/2000/1*i406IS9gsRrYLpxZEWPotw.gif)

你也可以改用默认的页面指示器。只需注释掉 tab 的图标（image）。

![](https://cdn-images-1.medium.com/max/2000/1*QJtPwUw7piYoTKs03Dg3NQ.gif)

如果你还是想用白色背景色，可以给 `TabView` 再添加一个 modifier：

```
.indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
```

![](https://cdn-images-1.medium.com/max/2000/1*-06MmT2edIdUxd3pscmxtg.gif)

有了 SwiftUI，实现水平滚动视图变得如此简单。这绝对值得庆祝。


> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
