> * 原文地址：[The Essentials of iOS App Testing For iPhone X](https://mobiletestingblog.com/2017/11/05/the-essentials-of-ios-app-testing-for-iphone-x/)
> * 原文作者：[mobiletestingblog](https://mobiletestingblog.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/the-essentials-of-ios-app-testing-for-iphone-x.md](https://github.com/xitu/gold-miner/blob/master/TODO/the-essentials-of-ios-app-testing-for-iphone-x.md)
> * 译者：
> * 校对者：

# The Essentials of iOS App Testing For iPhone X

48 hours ago, Apple revealed its new and futuristic [iPhone X](http://blog.perfectomobile.com/industry-news/perfecto-announces-first-in-the-market-cloud-support-for-iphonex/). Regardless of its design, and debatable price tag, this device also introduced a whole set of functionality, display, and engagement with the end-user.

[iOS11](https://dzone.com/articles/ios11-and-android-oreo-80-are-shocking-the-mobile) is turning to be quite different from previous releases from both user adoption which is still low (~**30%**) and also from a quality perspective – **4 patch releases in 1.5 months is a lot**.

Most of the changes are already proving to cause issues for existing apps that work fine on iOS11.x and former iPhones like iPhone 8, 7 and others.

In this post, I’d highlight some pitfalls that testers as well as developers ought to be doing immediately if they haven’t done so already to make sure their apps are compliant with the latest Apple mobile portfolio.

The post will be divided into 2 areas: **Mobile testing** recommendations and **App Development** recommendations.

### Mobile Testing for iPhone X/iOS 11

*   **Test** across **all supported platforms** as a general statement. iOS11 isn’t for every device, and apps are stuck on iOS10 that has different functionality than the iOS11\. Test your apps across iOS9.3.5, iOS 10.3.3, and the latest iOS11.x
*   **iPhone X comes from the factory with iOS11.0.1**, requesting for an update to iOS1.1 – that means, this device will never get the intermediate iOS11.0.2/iOS11.0.3 – if customers haven’t yet updated to iOS1.1, you may want to have 1 device like iPhone 8/7 still on iOS11.0.3 so you have coverage for **iOS11.Latest-1**
*   **Display and Screen Size for iPhone X** specifically changed, and this device has a 5.8” screen size that is different for all other iPhones. Testing UI elements, Responsive apps layouts and other graphics on this new device is obviously a must (below is an example taken from **CVS** native app showing UI issues already found by me while playing with the device). This device is also full screen similar to the Samsung S8/Note 8 devices. A lot of tables, text field, and other UI elements need to be iOS11/iPhopne X ready by the developers.

![Image title](https://dzone.com/storage/temp/7125522-cvs-issues.png)

*   **New gestures and engagement flow** impact usability as well as test automation scripts. In iPhone X, unlike previous iPhones, the user has no HOME Button to work with. That means that in order for him to launch the task manager (see below) and switch or kill a background running app, he needs to follow a different flow. What that means is that at first, the app testing teams need to make sure that this new flow is covered in testing, and more important, if these flows are part of a test automation scenario, the code needs to be adapted to match the new flow.

![Image title](https://dzone.com/storage/temp/7125539-whatsapp-image-2017-11-05-at-085248.jpeg)

In addition to the removal of the **Home button** that causes the new way of engaging with background apps, the way for the user to return to the Home screen has also changed. Getting back to the Home screen is a common step in every test automation, therefore these steps need to account for the changes, and **replace the button** press **with** a **Swipe Up gesture**.

*   **Authentication and payment scenarios** also changed with the elimination of the **Touch ID** option, that was replaced with the **Face ID.** While iPhone X introduced an innovative digital engagement with the Face recognition technology, the de-facto today to log in into apps, make payments and more, is still the Fingerprint authentication. **Testing both methods** is now a quality and dev requirement. From a scan that I ran through the leading apps in the market (see examples below), there is a **clear unpreparedness for iPhone X**. Most apps will either show on their UI the option to log in via Touch ID or if they support Face ID, they will allow users to use it, while still showing on the UI and in the app settings the unsupported option.

![Image title](https://dzone.com/storage/temp/7125570-touchid.png)

*   **Testing mobile web and responsive web apps** in both landscape and portrait mode with the unique iPhone X display is also a clear and immediate requirement. I also found issues mostly around text truncation and wrong leverage of the entire screen to display the web content.

![Image title](https://dzone.com/storage/temp/7125576-whatsapp-image-2017-11-03-at-1859227.jpeg)

In addition, trying to work with Hulu.com website proved to also be a challenge. Most menu content is being thrown to the bottom of the screen under the user control, making it simply inaccessible. Obviously, the site is not ready for iPhone X/Safari Browser.

[![](https://ek121268.files.wordpress.com/2017/11/dn5r8yhvwaaqnxw_large.jpg?w=473&h=1024)](https://ek121268.files.wordpress.com/2017/11/dn5r8yhvwaaqnxw_large.jpg)

### **Mobile Apps Development**

*   **Optimize existing iOS apps from both UI as well as authentication perspective**. As spotted above, there are clear compatibility issues around the removal of the Touch ID option, that needs to be modified on the UI side of the apps when launched on iPhone X. In addition, scaling UI elements on the new screen whether for RWD apps or mobile apps needs refactoring as well. Apple is offering app developers a [ui guidlines](https://www.bignerdranch.com/blog/get-your-apps-ready-for-iphone-x/) to help make the changes fast.![Image title](https://dzone.com/storage/temp/7125590-scaleiphonex.jpg)
*   **Leverage advanced capabilities in iOS11** that best suit the new chipset (AI11 Bionic) and the camera sensors, to introduce digital engagement capabilities around augmented reality (ARKit API’s) and others. Retail apps and games are surely the 1st most suitable segments to jump on these innovative capabilities and enrich their end users’ experiences.

![Image title](https://dzone.com/storage/temp/7125607-whatsapp-image-2017-11-05-at-092658.jpeg)

### Bottom Line

The new iPhone X might be paving the way together with the Android Note 8 for a new era of innovation that offers App developers new opportunities to better engage and increase business values. If quality will not be aligned with these innovative opportunities, as shown above, that transformation will be quite challenging, slow and frustrating for the end users’

It is highly recommended for iOS app vendors across verticals to get hands-on experience with the new platform, assess the gaps in quality and functionality, and make the required changes so they are not “left behind” when the innovative train moves on.


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
