> * 原文地址：[Learn About SwiftUI Text and Label in iOS 14](https://medium.com/better-programming/learn-about-swiftui-text-and-label-in-ios-14-bfee41252117)
> * 原文作者：[Anupam Chugh](https://medium.com/@anupamchugh)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/learn-about-swiftui-text-and-label-in-ios-14.md](https://github.com/xitu/gold-miner/blob/master/article/2020/learn-about-swiftui-text-and-label-in-ios-14.md)
> * 译者：
> * 校对者：

# Learn About SwiftUI Text and Label in iOS 14

![Photo by [Prateek Katyal](https://unsplash.com/@prateekkatyal?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/12000/0*ooJiyXobPr83YYhC)

Apple didn’t exactly call the second iteration of SwiftUI a 2.0, but there were really some crackling updates announced during WWDC 2020.

Besides the introduction of `Grids` and `MatchedGeometryEffect`, SwiftUI `Text` also got a huge boost. In addition to that, `Label`, `Link`, and `TextEditor` were introduced to allow the building of forms, buttons, and fancy text to be a whole lot easier.

In the next few sections, we’ll look at what you can achieve with the new `Text` controls in SwiftUI in iOS 14.

## SwiftUI Text Now Supports Powerful Interpolation

SwiftUI `Text` has been bumped up this year with new initializers to let you format dates, interpolate strings with images, and add `Text` within `Text`.

Let’s look at how to wrap images with SF symbols in SwiftUI `Text`:

```swift
Text("Hello, \(Image(systemName: "heart.fill"))

Text(Image(systemName:))
```

The following examples show what we can achieve by concatenating a few SwiftUI `Text`s:

![](https://cdn-images-1.medium.com/max/2032/1*SfNGGiAV9nVfBhNJGrp15A.png)

SwiftUI `Text` has also gotten two initializers for wrapping dates in strings — namely a date interval and a date range, with an optional argument to set the style.

Let’s look at the different ways to set and format dates in Swift `Text`:

```swift
Text(Date().addingTimeInterval(600))
Text(Date().addingTimeInterval(3600),style: .time)
```

`addTimeInterval` accepts absolute values only, so the above two snippets set the date at `T + 10` minutes and `T + 1` hour in different styles.

What’s amazing about the new semantic API is it lets you set a counter or timer within the SwiftUI `Text` initializer using the styles `relative`, `timer`, and `offset`.

```swift
//countdown timer to update every minute
Text(Date().addingTimeInterval(60),style: .offset)
```

Now, you might be wondering if setting a timer will trigger the SwiftUI view body to refresh every seconds, but that isn’t the case.

SwiftUI `Text` considers the counter as an animation, which means it interpolates values between the start and end date. Let’s look at different kinds of `Text`s:

![](https://cdn-images-1.medium.com/max/2000/1*O75Bp3RQwMUsiQrHytKPSw.gif)

Pay heed to how the three different styles of `Timer` behave differently. And also that they autoreverse at the end of the counter.

SwiftUI `Text` also makes it possible to interpolate `Text` within `Text` while preserving each of their identities. Like “Inception.”

## SwiftUI Labels to Display Text and Images Together

SwiftUI `Label`s are an out-of the box substitute for a view we were using a lot: wrapping text and image in `stack`s.

Here’s how to define the all-new SwiftUI `Label`:

```swift
Label("Hello Label", systemImage: "sun.min")

Label("Hello Label", image: "asset_image")

Label(title: {Text("..")}, icon: {Image(..)})
```

Labels also provide a `labelStyle` modifier that comes with two built-in variants — `TitleOnlyLabelStyle` and `IconOnlyLabelStyle`. Though you can create your own custom label style configuration as well.

In the below screen grab, we’re showing the different types of `Label`s and how to use them in a `ContextMenu`:

![](https://cdn-images-1.medium.com/max/2000/1*wtKfv_zgpAc83QGdmkWJww.gif)

`Label`s largely reduce the unnecessary `Text` and `Image` views we had to define in `ContextMenu` buttons.

Though it’d be a dream to get a SwiftUI button initializer that lets us set images as well.

## Creating Your Own Label Style

We can create custom styles for our labels by conforming to the `LabelStyle`.

The below code looks to set the icon and text vertically, instead of being horizontally aligned.

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

You can now set it inside the view modifier as `.labelStyle(VLabelStyle())`.

## Conclusion

SwiftUI `Text` now supports more powerful interpolations that let you set timers in a single line (in fact, just a few words).

SwiftUI `Label`s are handy inside outlined lists and context menus.

You can view or download the source code of everything we covered from this [gist link](https://gist.github.com/anupamchugh/e4df9b9734634a5cf59b51f784e08610).

That’s it for this one. Thanks for reading.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
