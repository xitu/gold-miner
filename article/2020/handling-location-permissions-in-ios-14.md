> * 原文地址：[Handling Location Permissions in iOS 14](https://medium.com/better-programming/handling-location-permissions-in-ios-14-2cdd411d3cca)
> * 原文作者：[Anupam Chugh](https://medium.com/@anupamchugh)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/handling-location-permissions-in-ios-14.md](https://github.com/xitu/gold-miner/blob/master/article/2020/handling-location-permissions-in-ios-14.md)
> * 译者：[Godlowd](https://github.com/Godlowd)，[lsvih](https://github.com/lsvih)
> * 校对者：[lsvih](https://github.com/lsvih)，[Hoarfroster](https://github.com/PassionPenguin)

# 在 iOS 14 中处理位置权限和管理近似地址访问

![Photo by [Heidi Fin](https://unsplash.com/@heidifin?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral).](https://cdn-images-1.medium.com/max/10944/0*AUpXEd4-yyCDLhMn)

Apple 毫无疑问是数据隐私方面的引领者。访问地理位置这一功能在过去一直被不同的 app 错误地使用或者滥用。这种行为不仅对安全是一种威胁，甚至是一种破坏。在 iOS 14 中，Apple 又一次希望给予用户对他们正在分享的数据更好的控制权。

iOS 14 小小地修改了一下 `CoreLocation` 框架。更进一步地说，用户可以选择给予访问精确或者近似的地理位置的权限。

在我们了解如何掌握 iOS 14 中新的位置改变之前，让我们快速地回顾一下在 iOS 13 的地理位置权限中有哪些新东西。

## iOS 13 位置权限快速回顾

去年，Apple 在 iOS 13 中改变了地理位置跟踪权限的工作方式。

* 最明显的改动是，出现了一个新的权限“只允许一次”，它要求设置 `NSLocationWhenInUseUsageDescription` 配置内容。必须要指明的是，当应用程序被关闭的时候，这个权限会被自动撤销。
* 此外，启用“Allow While Using The App”将暂时性地“总是允许”位置追踪。现在，当你尝试在后台访问地理位置时，系统会向用户显示一个对话框来选择是否继续允许追踪。
* iOS 13.4 引入了一种更好的方式去快速的确保“总是允许”权限被授予。只需要请求 `authorizedWhenInUse`，如果它被授予了权限，就会出现 `authorizedAlways` 的提示信息。

想更深入的研究在你的应用中 iOS 13 的地理位置权限，[来看看这篇文章](https://medium.com/better-programming/handling-ios-13-location-permissions-5482abc77961)。

在接下来的部分，我们将会看到一个 iOS 14 的 SwiftUI 应用中管理地理位置产生了哪些改变。

那就让我们开始吧。

## iOS 14 CoreLocation 框架的改变

Apple 已经废弃了我们之前在 `CLLocationManager` 中调用的类方法  `authorizationStatus()`。

这意味着从 iOS 14 开始，`authorizationStatus()` 只能被 `CLLocationManager` 的实例调用.

Apple 也废弃了 `didChangeAuthorization` 中带有一个 `status` 参数的 `CoreLocation` 方法。取而代之的是，现在有了一个新的 `locationManagerDidChangeAuthorization` 方法。

![](https://cdn-images-1.medium.com/max/2720/1*T6ZJe1MBihTxLgvatZbHPQ.png)

为了确保地理位置的精确度状态，我们可以在地理位置管理者的实例中使用新的枚举属性 `accuracyAuthorization`。这个属性是 `CLAccuracyAuthorization` 类型的，有两个枚举值： 

* `fullAccuracy`
* `reducedAccuracy`（返回一个近似的而不是精确的地理位置）

为更新地理位置而设置 `CoreLocation` 的方式与在 iOS 13 中完全一样：

```swift
locationManager.delegate = self
locationManager.requestAlwaysAuthorization()

locationManager.startUpdatingLocation()

locationManager.allowsBackgroundLocationUpdates = true
locationManager.pausesLocationUpdatesAutomatically = false
```

> 请注意：如需 allowsBackgroundLocationUpdates，请确保你在 Xcode 项目设置中启用了后台模式（Background mode）。

现在，当你在你的设备上运行这段代码时，在 iOS 14 下你将得到如下的提示：

![Screenshot from the author’s phone.](https://cdn-images-1.medium.com/max/2000/1*odLcpX6ZTLZbU4dIhFhuug.png)

通过拨动“精确度”按钮, 你可以选择允许模糊或者精确的地理位置权限。

现在，可能会出现只要求你访问用户的准确地理位置的情况。

谢天谢地，在 iOS 14 中有一个新方法能让我们暂时性的发出请求：

![](https://cdn-images-1.medium.com/max/2720/1*2_Y2M6m8lvAcCUOr_hrNYQ.png)

这个 `requestTemporaryFullAccuracyAuthorization` 方法需要一个 `purpose` 键来解释为何需要访问用户的准确地理位置。这个键被定义在 `info.plist` 文件中的一个 `NSLocationTemporaryUsageDescriptionDictionary` 字典里，如下图所示：

![](https://cdn-images-1.medium.com/max/2000/1*hbgrE7IeurnF6h4VmUmYVw.png)

一旦 `TemporaryFullAccuracyAuthorization` 被调用了，就会出现下面的提示信息：

![Screenshot by the author.](https://cdn-images-1.medium.com/max/2000/1*PKM54GYFk_ZxBszrOBt6XA.png)

`reducedAccuracy` 和 `fullAccuracy` 位置更新都是在代理方法 `didUpdateLocations` 中被接收的。

一个用 Swift UI 编写的 iOS 14 `CoreLocation` 应用的 demo 的源代码可以在 [GitHub](https://github.com/anupamchugh/iOS14-Resources/tree/master/iOS14SwiftUICoreLocation) 获取。

请务必注意，如果使用 `reducedAccuracy` 进行后台地理位置更新，更新的时间间隔将不会改变。在这种情况下，信号灯和地区检测也将被禁用。

## CoreLocation 在 AppClips、Widgets 和默认设置中的更新

AppClips 就像一个可以无需安装完整应用程序就可运行的迷你 APP 模块。

* 当你通过 AppClips 访问地理位置时，将不会出现”仅当使用 App 时允许”的权限，而是会出现一个在当天结束时自动重置的“在使用期间直到明天”的权限。
* 对于在 WidgetKit 中访问地理位置，你需要在 `info.plist` 文件中定义 `NSWidgetWantsLocation` 键。
* 如果想默认情况下只在访问精确地理位置的时候显示提示信息，你可以在`info.plist`文件中添加键 `NSLocationDefaultAccuracyReduced`。这样做，精确地理位置访问按钮就不会显示在权限对话框了。但是用户仍然可以在手机的设置中启用切换开关。

## 总结

`CoreLocation` 框架在 iOS 14 中发生了一点有趣的改变，能够让用户对他们的地理位置数据有更多的掌控权。并不是所有的 App 都需要获得准确的地理位置信息，所以你可以选择用 `reducedAccuracy` 属性来仅获取近似的地理位置。 

这就是这篇文章的全部内容了，谢谢阅读

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
