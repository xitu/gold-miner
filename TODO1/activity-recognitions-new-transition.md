> * 原文地址：[Activity Recognition’s new Transition API makes context-aware features accessible to all developers](https://android-developers.googleblog.com/2018/03/activity-recognitions-new-transition.html)
> * 原文作者：[Marc Stogaitis, Tajinder Gadh, and Michael Cai](https://android-developers.googleblog.com)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/activity-recognitions-new-transition.md](https://github.com/xitu/gold-miner/blob/master/TODO1/activity-recognitions-new-transition.md)
> * 译者：
> * 校对者：

# Activity Recognition’s new Transition API makes context-aware features accessible to all developers

Posted by Marc Stogaitis, Tajinder Gadh, and Michael Cai, Android Activity Recognition Team

Phones are our most personal devices we bring with us everywhere, but until now it's been hard for apps to adjust their experience to a user's continually changing environment and activity. We've heard from developer after developer that they're spending valuable engineering time to combine various signals like location and sensor data just to determine when the user has started or ended an activity like walking or driving. Even worse, when apps are independently and continuously checking for changes in user activity, battery life suffers. That's why today, we're excited to make the Activity Recognition Transition API available to all Android developers - a simple API that does all the processing for you and just tells you what you actually care about: when a user's activity has changed.

Since November of last year, the Transition API has been working behind the scenes to power the [Driving Do-Not-Disturb](https://android-developers.googleblog.com/2017/11/making-pixel-better-for-drivers.html) feature launched on the Pixel 2. While it might seem simple to turn on Do-Not-Disturb when car motion is detected by the phone's sensors, many tricky challenges arise in practice. How can you tell if stillness means the user parked their car and ended a drive or simply stopped at a traffic light and will continue on? Should you trust a spike in a non-driving activity or is it a momentary classification error? With the Transition API, all Android developers can now leverage the same sets of training data and algorithmic filtering used by Google to confidently detect these changes in user activity.

Intuit partnered with us to test the Transition API and found it an ideal solution for their [QuickBooks Self-Employed](https://play.google.com/store/apps/details?id=com.intuit.qbse) app:

"QuickBooks Self-Employed helps self-employed workers maximize their deductions at tax time by importing transactions and automatically tracking car mileage. Before the Transition API, we created our own solution to track mileage that combined GPS, phone sensors, and other metadata, but due to the wide variability in Android devices, our algorithm wasn't 100% accurate and some users reported missing or incomplete trips. We were able to build a proof-of-concept using the Transition API in a matter of days and it has now replaced our existing solution, offering a more reliable solution that also reduced our battery consumption. The Transition API frees us up to focus our efforts on being the best possible tax solution," say Pranay Airan and Mithun Mahadevan from Intuit.

[![](https://2.bp.blogspot.com/-xjpu46Q1QlM/WrALrluMqRI/AAAAAAAAFJc/G0jP4_1B5TgBGCioG5vyIFkCrSl1zD1WwCLcBGAs/s1600/image1.png)](https://2.bp.blogspot.com/-xjpu46Q1QlM/WrALrluMqRI/AAAAAAAAFJc/G0jP4_1B5TgBGCioG5vyIFkCrSl1zD1WwCLcBGAs/s1600/image1.png)

Automatic mileage tracking in QuickBooks Self-Employed

[Life360](https://play.google.com/store/apps/details?id=com.life360.android.safetymapd) similarly implemented the Transition API in their app with significant improvements in activity detection latency and battery consumption:

"With over 10 million active families, Life360 is the world's largest mobile app for families. Our mission is to become the must-have Family Membership that gives families peace of mind anytime and anywhere. Today we do that through location sharing and 24/7 safety features like monitoring driving behavior of family members, so measuring activities accurately and with minimal battery drain is critical. To determine when a user has started or finished a drive, our app previously relied on a combination of geofences, the Fused Location Provider API and the Activity Recognition API, but there were many challenges with that approach including how to quickly detect the start of the drive without excessively draining battery and interpreting the granular and rapidly changing reading from the raw Activity Recognition API. But in testing the Transition API, we are seeing higher accuracy and reduced battery drain over our previous solution, more than meeting our needs," says Dylan Keil from Life360.

[![](https://3.bp.blogspot.com/-jDgcFj0bhIE/WrAL4t8LU6I/AAAAAAAAFJg/07cgXSIDGKoUO5RyY24JV7m0Wjce9XtcACLcBGAs/s1600/image2.png)](https://3.bp.blogspot.com/-jDgcFj0bhIE/WrAL4t8LU6I/AAAAAAAAFJg/07cgXSIDGKoUO5RyY24JV7m0Wjce9XtcACLcBGAs/s1600/image2.png)

Live location sharing in Life360

In the coming months, we will continue adding new activities to the Transition API to support even more kinds of context-aware features on Android like differentiating between road and rail vehicles. If you're ready to use the Transition API in your app, check out our [API guide](https://developer.android.com/guide/topics/location/transitions.html).

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
