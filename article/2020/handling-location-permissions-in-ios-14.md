> * 原文地址：[Handling Location Permissions in iOS 14](https://medium.com/better-programming/handling-location-permissions-in-ios-14-2cdd411d3cca)
> * 原文作者：[Anupam Chugh](https://medium.com/@anupamchugh)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/handling-location-permissions-in-ios-14.md](https://github.com/xitu/gold-miner/blob/master/article/2020/handling-location-permissions-in-ios-14.md)
> * 译者：
> * 校对者：

# Handling Location Permissions and Managing Approximate Location Access in iOS 14

![Photo by [Heidi Fin](https://unsplash.com/@heidifin?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral).](https://cdn-images-1.medium.com/max/10944/0*AUpXEd4-yyCDLhMn)

Apple is without a doubt the leader in data privacy. Location access is something that’s been wrongfully used or rather abused in the past by various apps. It’s a security threat — or rather a breach — and with iOS 14, Apple once again looks to give users better control of the data they’re sharing.

iOS 14 brings a slight change to the `CoreLocation` framework. Going forward, users can choose whether to give precise or approximate location access.

Before we see how to manage the new iOS 14 location changes, let’s quickly recap what was new in iOS 13 location permissions.

## Quick Recap of iOS 13 Location Permissions

Last year, in iOS 13, Apple changed the way location tracking permissions work.

* Notably, there was a new “Allow Once” permission that required setting NSLocationWhenInUseUsageDescription. It’s important to note that this permission gets automatically revoked when the app is closed.
* Also, enabling “Allow While Using The App” would provisionally “Always allow” location tracking. Now, when you try accessing a location in the background, the system presents a dialog to the user to let the app continue tracking it or deny it.
* iOS 13.4 introduced a better approach to quickly ensure that “Always allow” permission is granted. Simply ask for the `authorizedWhenInUse`, and if it’s granted, show a prompt for `authorizedAlways`.

For an in-depth look at handling iOS 13 location permissions in your applications, [refer to this article](https://medium.com/better-programming/handling-ios-13-location-permissions-5482abc77961).

In the following section, we’ll see how to manage location changes in an iOS 14 SwiftUI application.

Let’s get started.

## iOS 14 CoreLocation Changes

Apple has deprecated the class function `authorizationStatus()` that we invoked earlier on the `CLLocationManager`.

This means that starting in iOS 14, `authorizationStatus()` can be only called on the instance of `CLLocationManager`.

Apple has also deprecated the `didChangeAuthorization` delegate function of `CoreLocation` that contained a `status` argument. Instead, we now have a new locationManagerDidChangeAuthorization function.

![](https://cdn-images-1.medium.com/max/2720/1*T6ZJe1MBihTxLgvatZbHPQ.png)

To determine the location accuracy status, we can invoke the new enum property `accuracyAuthorization` on the location manager instance. This property is of the type `CLAccuracyAuthorization` and has two enum cases:

* `fullAccuracy`
* `reducedAccuracy` (returns an approximate instead of exact location)

Setting up `CoreLocation` for location updates is exactly the same as in iOS 13:

```swift
locationManager.delegate = self
locationManager.requestAlwaysAuthorization()

locationManager.startUpdatingLocation()

locationManager.allowsBackgroundLocationUpdates = true
locationManager.pausesLocationUpdatesAutomatically = false
```

> Note: For allowsBackgroundLocationUpdates, ensure that you’ve enabled the Background mode location from the capabilities in your Xcode project.

Now, when you run the code above on your device, you’ll get the following revamped prompt in iOS 14:

![Screenshot from the author’s phone.](https://cdn-images-1.medium.com/max/2000/1*odLcpX6ZTLZbU4dIhFhuug.png)

By toggling the “Precise” button, you can choose to allow approximate or accurate location access.

Now, there could be a use case where you are required to only access a user’s accurate location.

Thankfully, there’s a new function in iOS 14 that lets us request that temporarily:

![](https://cdn-images-1.medium.com/max/2720/1*2_Y2M6m8lvAcCUOr_hrNYQ.png)

The requestTemporaryFullAccuracyAuthorization function requires a purpose key to explain the need for an accurate location to the user. This key is defined inside `info.plist` file within a NSLocationTemporaryUsageDescriptionDictionary dictionary, as shown below:

![](https://cdn-images-1.medium.com/max/2000/1*hbgrE7IeurnF6h4VmUmYVw.png)

Once the requestTemporaryFullAccuracyAuthorization is invoked, the following prompt is displayed:

![Screenshot by the author.](https://cdn-images-1.medium.com/max/2000/1*PKM54GYFk_ZxBszrOBt6XA.png)

`reducedAccuracy` and `fullAccuracy` location updates are both received inside the `didUpdateLocations` delegate method.

The full source code for a sample iOS 14 `CoreLocation` application in SwiftUI is available on [GitHub](https://github.com/anupamchugh/iOS14-Resources/tree/master/iOS14SwiftUICoreLocation).

It’s important to note that for background location updates with `reducedAccuracy`, the time interval of location updates isn’t changed. Also, beacons and region monitoring are disabled under `reducedAccuracy`.

## CoreLocation Updates for AppClips, Widgets, and Default Settings

AppClips are like mini-app modules that can run without installing the complete application.

* When you’re accessing a location within AppClips, there’s no “While Using App” permission. Instead, there’s a “While Using Until Tomorrow” permission that automatically gets reset at the end of the day.
* For accessing a location inside WidgetKit, you need to define the `NSWidgetWantsLocation` key in the widget’s `info.plist` file.
* To only show a prompt for approximate location by default in your app, you can add the `info.plist` key NSLocationDefaultAccuracyReduced. By doing so, the precise location toggle button won’t be displayed in the permission dialog. But the user can still enable the toggle from the phone’s settings.

## Conclusion

`CoreLocation` has brought an interesting change to iOS 14 that lets the user have more control over their location data. Not all apps require their exact location, so you can choose the `reducedAccuracy` property to fetch only the approximate location.

That’s it for this one. Thanks for reading.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
