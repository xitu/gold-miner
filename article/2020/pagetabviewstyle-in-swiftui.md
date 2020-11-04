> * 原文地址：[PageTabViewStyle in SwiftUI](https://medium.com/better-programming/pagetabviewstyle-in-swiftui-7a2aba16e439)
> * 原文作者：[Kelvin Tan](https://medium.com/@zhiyao92)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/pagetabviewstyle-in-swiftui.md](https://github.com/xitu/gold-miner/blob/master/article/2020/pagetabviewstyle-in-swiftui.md)
> * 译者：
> * 校对者：

# PageTabViewStyle in SwiftUI

![Photo by [Charles Deluvio](https://unsplash.com/@charlesdeluvio?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral).](https://cdn-images-1.medium.com/max/8512/0*HuDzGczsUftDGQKL)

At the recent WWDC 2020, Apple introduced an additional style for `TabView` called `PageTabViewStyle`. This is equivalent to Horizontal Paging Scroll, which is commonly used for the onboarding screen.

> **“A `TabViewStyle` that implements a paged scrolling `TabView`.” — [Apple Documentation](https://developer.apple.com/documentation/swiftui/pagetabviewstyle)**

## Prerequisites

To follow along with this tutorial, you’ll need some basic knowledge in:

* Swift
* At least Xcode 12+

**Note: This only supports iOS 14+.**

## Getting Started With PageTabViewStyle

Let’s quickly set up four tabs on the `TabView` with the capabilities of showing a filled image when selected and an unfilled image when unselected.

To have that, you will need to have a state to know what is being selected:

```
@State private var selected = 0
```

With this, the default selected tab is always `0` and you can change this to your preference:

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

Once you have all these set up, you are ready to implement Horizontal Page Scrolling with just a simple additional modifier. Add .tabViewStyle(PageTabViewStyle()) at the end of `TabView`:

```
TabView() {
..
..
}.tabViewStyle(PageTabViewStyle())
```

Your tab should be able to scroll horizontally now.

![](https://cdn-images-1.medium.com/max/2000/1*UEG4z-2uTsEeSx8gMRo2KA.gif)

A Horizontal Page Scrolling is not complete without the page indicator. As a matter of fact, the page indicator is visible, but it’s white. Since the background color is also white, that’s why it’s not visible.

There are multiple ways to address that — either set a different background color or use an additional parameter.

By setting the background color as green, you now can see the tab image as the page indicator.

![](https://cdn-images-1.medium.com/max/2000/1*i406IS9gsRrYLpxZEWPotw.gif)

You may opt for the default page indicator. Simply comment out the tab’s image and it will show a default page indicator:

![](https://cdn-images-1.medium.com/max/2000/1*QJtPwUw7piYoTKs03Dg3NQ.gif)

The other way is to use an additional modifier for the `TabView`. With this, you will be able to still use a white background:

```
.indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
```

![](https://cdn-images-1.medium.com/max/2000/1*-06MmT2edIdUxd3pscmxtg.gif)

Who would have thought the process would be made a lot easier and simpler with SwiftUI? This is definitely worth celebrating.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
