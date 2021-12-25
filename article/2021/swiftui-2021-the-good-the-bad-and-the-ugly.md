> * 原文地址：[SwiftUI in 2021: The Good, the Bad, and the Ugly](https://betterprogramming.pub/swiftui-2021-the-good-the-bad-and-the-ugly-458c6ee768f9)
> * 原文作者：[Chrys Bader](https://medium.com/@chrysb)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/swiftui-2021-the-good-the-bad-and-the-ugly.md](https://github.com/xitu/gold-miner/blob/master/article/2021/swiftui-2021-the-good-the-bad-and-the-ugly.md)
> * 译者：
> * 校对者：

# SwiftUI in 2021: The Good, the Bad, and the Ugly

> SwiftUI in production? **Still a no-go.**

![Photo by [Maxwell Nelson](https://unsplash.com/@maxcodes?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/12000/0*Wexfei50ZXms6ocU)

I’ve spent the past 8 months developing complex applications in SwiftUI, including [Fave](https://apps.apple.com/us/app/fave-close-friends-only/id1541952688), which we recently put in the App Store. I’ve bumped into countless limitations and found workarounds to most of the challenges I’ve encountered.

In short, SwiftUI is a wonderful and very promising framework. I think it’s the future. But, it could be another 3–5 years until it reaches the same reliability and robustness as UIKit. However, that doesn’t mean you shouldn’t use SwiftUI today. My goal here is to help you understand the tradeoffs and drawbacks so you can make a more informed decision about whether SwiftUI is right for your next project.

## The Good

### 1. SwiftUI is a joy to write and you can build almost too fast

Gone are the days of `addSubview` and `sizeForItemAtIndexPath`, painstakingly calculating frames, wrestling with constraints, and building view hierarchies by hand. SwiftUI’s declarative and reactive design patterns make creating responsive layouts as easy as React, yet with Apple’s powerful UIKit under the hood. It’s incredibly fast to build views and get things up and running.

### 2. SwiftUI simplifies cross-platform development

One of the things I am most excited about is that you can write SwiftUI once and use it across iOS (iPhone & iPad), WatchOS, and macOS. It’s already problematic enough that you have to develop and maintain a separate codebase for Android and Windows, so every little bit helps in reducing the number of disparate codebases. There are still some drawbacks, which I’ll share in “The Bad” section.

### 3. You get beautiful transitions, animations, and components for free

You can think of SwiftUI as an actual UI Kit that provides all of the building blocks you need to make professional-looking apps. And if you’re familiar with CSS transitions, SwiftUI has its own version of that which makes it super easy to create polished interactions. The beauty of the declarative syntax is that things “just work” and seem like magic, but there’s a shadow side too, which I’ll also get into later.

### 4. The UI is entirely state-driven and reactive

If you’re familiar with React, SwiftUI works just the same. Instead of callback hell, you’re changing `@State` and `@Binding` and `@Published` properties with delight as you watch your entire UI “react”, animations and all. You leverage the power of `Combine` with `ObservableObject`and `@StateObject`. This aspect is one of the coolest departures from UIKit and feels incredibly powerful.

### 5. The community is embracing SwiftUI

Pretty much everyone is excited about SwiftUI. There are so many resources available to learn SwiftUI, from WWDC, to books, to blogs — the information is there, you just have to search for it. Or not, I’ve put together a list of the best community resources here.

Having a vibrant and supportive community will accelerate learning, development, and plenty of new libraries will emerge to make SwiftUI even more versatile.

## The Bad

### 1. Not everything is available in SwiftUI yet

There are a number of components that are missing, incomplete, or overly simple, some of which I’ll go into more detail below.

There is a solution by using`UIViewRepresentable` `UIViewControllerRepresentable` and `UIHostingController`. The former two allow you to embed UIKit views and controllers into a SwiftUI view hierarchy. The latter allows you to embed a SwiftUI view in UIKit. The same three exist for Mac development (`NSViewRepresentable`, etc).

These bridges are a great stopgap to make up for the missing functionality that SwiftUI has, but it’s not always a seamless experience. Furthermore, while the cross-platform promise of SwiftUI is great, if something’s not available you’ll still need to implement bridge code twice for iOS and Mac.

### 2. NavigationView is not really there yet

If you want to hide the navigation bar and still have the swipe gesture work, you can’t. I ended up creating a [UINavigationController wrapper](https://gist.github.com/chrysb/d7d85e20d8c94fd3e0b753a4abd1c941) from some code I found. It works but it’s not a great solution long-term.

If you want to have a SplitView on iPad, you can’t show the master and detail view together yet in portrait mode. They chose an awkward use of a button to reveal a drawer, which is closed by default. Apparently, you can solve this problem by adding padding, which highlights the kind of things you have to do when wrangling SwiftUI.

`NavigationLink` is kind of funky when you want to navigate programmatically. Here’s an [interesting discussion](https://forums.swift.org/t/implementing-complex-navigation-stack-in-swiftui-and-the-composable-architecture/39352).

### 3. Text input is very limited

`TextField` and `TextEditor` are too simplistic right now, and you’ll end up falling back on UIKit. I had to build my own `UIViewRepresentable` for `UITextField` and `UITextView` (with auto-growing support). The gists are below:

### 4. The compiler struggles

When your view gets a little heftier and you’ve factored it out the best you can, the compiler can still huff and puff, telling you:

> The compiler couldn’t type-check this expression in a reasonable amount of time…

This has slowed me down a number of times. I’ve gotten good at commenting out code and narrowing it down to the line that’s causing the issue, but it feels really backward to be debugging code like this in 2021.

### 5. matchedGeometryEffect

When I first discovered [this](https://developer.apple.com/documentation/swiftui/view/matchedgeometryeffect(id:in:properties:anchor:issource:)), I thought it was amazing. It’s supposed to help you transition two views with different identities more seamlessly by matching their geometry as one appears and another disappears. I thought this would help make beautiful transitions from View A to View B.

I kept wanting it to work. Ultimately, I stay away from this because it’s imperfect and it causes crashes when you use it in a `List` or `ScrollView` with a lot of items. I would only recommend using this for simple transitions within the same view. Things start to get weird when you’re sharing a namespace between multiple distinct views, including view clipping during transitions.

### 6. Gestures are limited

SwiftUI comes with a new set of gestures (i.e. `DragGesture`, `LongPressGesture`) that can be added to a view using the `gesture` convenience modifiers like `tapGesture` and `longPressGesture`. They work okay until you want to do more complex interactions.

For example, `DragGesture` doesn’t interact well with `ScrollView`. Putting one within a ScrollView prevents scrolling, even with the `simultaneousGesture` modifier. In other situations, a drag gesture can get canceled without any notification, leaving gestures in an incomplete state.

To solve this, I built my own `GestureView` which allows me to use UIKit gestures in SwiftUI. I’ll share this in my next post about the best SwiftUI libraries and workarounds.

### 7. SwiftUI in Share Extension

I could be wrong, but Share Extensions still use UIKit. I built a share extension using SwiftUI by leveraging `UIHostingController` and there was a noticeable delay when the share extension loaded, creating a poor user experience. You can try to mask it by animating the view in, but it still has about a 500ms delay.

### Honorable mentions

* No access to the status bar (can’t change the color or intercept taps)
* `@UIApplicationDelegateAdaptor` required as `App` is still lacking
* No backward compatibility
* `UIVisualEffectsView` causes scroll lag in \< iOS15 (h/t @[AlanPegoli](https://twitter.com/alanpegoli?lang=en))

## The Ugly

### 1. ScrollView

This is one of the biggest drawbacks to date. Anyone who has built a more bespoke iOS app knows how much we rely on ScrollView to power interaction.

* **Major deal-breaker:** `LazyVStack` within a [ScrollView causes stutters, jitters, and unexpected behavior](https://stackoverflow.com/questions/66523786/swiftui-putting-a-lazyvstack-or-lazyhstack-in-a-scrollview-causes-stuttering-a/67895804). LazyVStacks are critical for long lists of mixed content that need to scroll, like a news feed. **This alone makes SwiftUI not production-ready:** Apple has confirmed to me that this is a bug in SwiftUI. It’s unclear when they’ll fix it, but when they do, it’ll be a big win.
* **Scroll state:** No native support for understanding the state of scrolling (is the scroll view dragging? scrolling? what’s the offset?). Though there are some workarounds for this, but they can be finicky and unstable.
* **Paging:** No native support for paging scroll views. So, forget about doing something like a swipeable media gallery (but use `[SwiftUIPager](https://github.com/fermoya/SwiftUIPager)` if you want something close). You can technically use `TabView` with `PageTabViewStyle`, but I think it’s more intended for a few elements and not large datasets.
* **Performance:** Using a `List`is the most performant and avoids the stuttering issue that `LazyVStack` has, but is still not ideal for showing variably sized content due to the way transitions work. For example, when building a chat view, the transitions are weird and clip the children, and you have no control over the insertion animation style.

## The Verdict

I think you should definitely learn SwiftUI, understand it for yourself, and experience the joy. Just hold off on fully adopting it.

SwiftUI is more than ready for simple applications, but at the time of this writing (iOS 15, beta 4), I don’t think SwiftUI is production-ready yet for complex applications, mainly due to the issues with `ScrollViews` and the heavy reliance on `UIViewRepresentable`. It breaks my heart. Particularly for things like messaging products, news feeds, and products that rely heavily on complex views or want to create gesture-driven bespoke experience will not want to use SwiftUI just yet.

If you want fine-grain control and limitless possibilities, I recommend sticking to UIKit for the foreseeable future. You can still reap the benefit of SwiftUI for some views (like settings pages) by using `UIHostingController` to include SwiftUI views.

## What Does The Future Behold?

As we begin to embark on the next big iteration of our project. I know the scope of interactions for this new project is outside of the scope of what SwiftUI currently supports. It breaks my heart to know that SwiftUI falls short in some critical ways, but I’m not quite ready to go back to UIKit, knowing how much of a joy it is to build in SwiftUI when it works. It’s just so much faster.

Will SwiftUI ever match UIKit? If so, we’re looking at maybe another 3–5 years to port over all of the essential UIKit APIs. If not, then you’ll always be able to drop down into UIKit and wrap it with SwiftUI.

What I’m curious about is how invested Apple is in SwiftUI. Is their long-term plan to have all developers fully adopt SwiftUI, or will it just become another Interface Builder? I really hope not. I hope that they go all in on SwiftUI because the promise of it is just amazing.

## More Perspectives

* [Is SwiftUI Ready?](https://www.jessesquires.com/blog/2021/07/01/is-swiftui-ready/)
* [SwiftUI Drawbacks: Why SwiftUI Is Not Ready for Production Yet](https://www.iosapptemplates.com/blog/swiftui/swiftui-drawbacks)
* [My takeaway from working with SwiftUI](https://link.medium.com/isXKLhaaCib)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
