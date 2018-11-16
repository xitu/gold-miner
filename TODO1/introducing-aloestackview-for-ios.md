> * 原文地址：[Introducing AloeStackView for iOS](https://medium.com/airbnb-engineering/introducing-aloestackview-for-ios-a676d253c6ba)
> * 原文作者：[Marli Oshlack](https://medium.com/@marli.oshlack?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/introducing-aloestackview-for-ios.md](https://github.com/xitu/gold-miner/blob/master/TODO1/introducing-aloestackview-for-ios.md)
> * 译者：
> * 校对者：

# Introducing AloeStackView for iOS

A simple, open source class for laying out a collection of views with a convenient API.

![](https://cdn-images-1.medium.com/max/1000/1*vSbYW1xdhd0x9gXKJZDvYA.png)

Some of the ~200 screens in the Airbnb iOS app built using AloeStackView.

At Airbnb, we’re always looking for ways to improve the efficiency of building products.

Over the past few years, our mobile development efforts have increased at a dramatic rate. In the past year alone, we’ve added more than 260 screens to our iOS app. At the same time, more and more people have started adopting our native mobile apps. These trends show no sign of slowing down.

About two years ago, we sat down and looked at how we built products on iOS to see if there was room for improving our development efficiency. A major problem we discovered was that implementing a new screen in our iOS app took multiple days and sometimes weeks of development effort.

So we set out to change that. We wanted to find a way to build screens faster than we thought possible. We wanted engineers to be able to add a new screen to the iOS app in a matter of minutes or hours, not days or weeks.

Over the past two years, we’ve learned many lessons when it comes to building iOS UI quickly, and with a high degree of quality.

Based on some of these learnings, we’re really excited today to introduce one of the tools we developed at Airbnb to help write iOS UI quickly, easily, and efficiently.

### Introducing AloeStackView

We first started using [AloeStackView](https://github.com/airbnb/AloeStackView) at Airbnb in our iOS app in 2016 and have since used it to implement nearly 200 screens in the app. The use cases are quite varied: everything from settings screens, to forms for creating a new listing, to the listing share sheet.

AloeStackView is a class that allows a collection of views to be laid out in a vertical list. In a broad sense, it is similar to UITableView, however its implementation is quite different and it makes a different set of trade-offs.

AloeStackView focuses first and foremost on making UI very quick, simple, and straightforward to implement. It does this in two ways:

*   It leverages the power of Auto Layout to automatically update the UI when making changes to views.
*   It forgoes some features of UITableView, such as view recycling, in order to achieve a much simpler and safer API.

### Simplifying iOS UI Development

One of the first things we realized when we looked at how to improve development efficiency on iOS was how much work was involved to implement even the smallest screens in the app.

It turns out abstractions that are designed to handle large and complex screens can sometimes be a burden for smaller screens, due to the development overhead they introduce.

Often, smaller screens don’t benefit from the advantages these abstractions provide either. For example, if a UI fits entirely on a single screen then it won’t benefit from view recycling. However, if we build this screen using an abstraction oriented around view recycling, then we still have to pay the price of the complexity this functionality adds to the API.

To address this, we started by looking for simpler ways to write screens. One very effective technique we found was laying out screens using a UIStackView nested inside a UIScrollView. This approach became the foundation upon which we built AloeStackView.

What makes this technique incredibly useful is it allows you to keep strong references to views and dynamically change their properties at any time, while Auto Layout automatically keeps the UI up-to-date.

At Airbnb, we’ve found this technique well suited to screens that accept user input, such as forms. In these situations, it’s often convenient to keep a strong reference to fields a user is editing, and directly update the UI with validation feedback.

Another place we’ve found this technique useful is on smaller screens comprised of a heterogeneous set of views, with less than a screenful or two of content. Simply declaring a list of the views in the UI in a straightforward way often makes implementing these screens faster and easier.

In practice, we’ve found a large number of screens in our iOS app fall into these categories. AloeStackView’s straightforward, flexible API has allowed us to build many screens quickly and easily, making it a useful tool to have in our toolbox.

### Reducing Bugs

Another way we increased developer efficiency was to focus on making iOS UI development easier to do correctly. A primary goal of AloeStackView’s API is ensuring safety by design, so that engineers spend more time building products and less time tracking down bugs.

AloeStackView has no reloadData method, or any way to notify it about changes to views. This makes it less error-prone and easier to debug than a class like UITableView. For example, AloeStackView can never crash due to changes to the underlying data of the views it manages.

Since AloeStackView uses UIStackView under the hood, it doesn’t recycle views as you scroll. This eliminates common bugs caused by not recycling views correctly. It also provides the added advantage of not needing to independently maintain the state of views as the user interacts with them. This can make some UI simpler to implement and reduces the surface area where bugs can creep in.

### Weighing Trade-Offs

Although AloeStackView is convenient and useful, we’ve found that it’s not suitable in all situations.

For example, AloeStackView lays out the entire UI in a single pass when your screen loads. As such, longer screens can see a delay before the UI is displayed for the first time. Hence, AloeStackView is more suited to implementing UI with less than a screenful or two of content.

Forgoing view recycling is also a trade-off: while AloeStackView is faster to write UI with and less error-prone, it doesn’t perform as well and can use more memory for longer screens than a class like UITableView. Thus, classes like UITableView and UICollectionView remain good choices for screens that contain many views of the same type, all showing similar data.

Despite these limitations, we’ve found AloeStackView well suited for a surprisingly large number of use cases. AloeStackView has proven very productive and efficient for implementing UI and has helped us towards our goal of increasing development efficiency on iOS.

### Keeping Code Manageable

One problem third-party dependencies often introduce to an app is increased binary size. This is something we wanted to avoid with AloeStackView. The entire library is less than 500 lines of code with no external dependencies, which keeps binary size increase to a minimum.

A small code footprint also helps in other ways: it makes the library simpler to understand, faster to integrate into existing apps, painless to debug, and easier to contribute to.

Another issue that sometimes crops up with third-party dependencies is a mismatch between the library and how your app currently does things. To mitigate this problem, AloeStackView places as few restrictions as possible on how it’s used. Any UIView can be used with AloeStackView, which makes it easy to integrate with whatever patterns you currently use to build UI in your app.

All of these things combine to make AloeStackView incredibly easy and risk-free to try out. If you’re interested, please [give it a try](https://github.com/airbnb/AloeStackView) and let us know what you think.

AloeStackView is not the only piece of infrastructure we use to build iOS UI at Airbnb, but it has been valuable for us in many situations. We hope you find it useful too!

### Getting Started

We’re really excited to share AloeStackView. If you want to learn more, please visit the [GitHub repository](https://github.com/airbnb/AloeStackView) to get started.

We’d love to hear from you if you or your company has found this library useful. If you’d like to get in touch, please feel free to email the maintainers (you can find us on [GitHub](https://github.com/airbnb/AloeStackView#maintainers)), or you can reach us at [aloestackview@airbnb.com](mailto:aloestackview@airbnb.com).

* * *

_Want to get involved? We’re always looking for_ [_talented people to join our team_](https://www.airbnb.com/careers)_!_

* * *

_AloeStackView is developed and maintained by Marli Oshlack, Fan Cox, and Arthur Pang._

_AloeStackView has also benefited from the contributions of many Airbnb engineers: Daniel Crampton, Francisco Diaz, David He, Jeff Hodnett, Eric Horacek, Garrett Larson, Jasmine Lee, Isaac Lim, Jacky Lu, Noah Martin, Phil Nachum, Gonzalo Nuñez, Laura Skelton, Cal Stephens, and Ortal Yahdav._

_In addition, open sourcing this project wouldn’t have been possible without the help and support of Jordan Harband, Tyler Hedrick, Michael Bachand, Laura Skelton, Dan Federman, and John Pottebaum._

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
