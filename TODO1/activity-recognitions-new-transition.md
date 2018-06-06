> * 原文地址：[Activity Recognition’s new Transition API makes context-aware features accessible to all developers](https://android-developers.googleblog.com/2018/03/activity-recognitions-new-transition.html)
> * 原文作者：[Marc Stogaitis, Tajinder Gadh, and Michael Cai](https://android-developers.googleblog.com)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/activity-recognitions-new-transition.md](https://github.com/xitu/gold-miner/blob/master/TODO1/activity-recognitions-new-transition.md)
> * 译者：[wzasd](github.com/wzasd)
> * 校对者：

# 带有情景感知这一新特性的活动识别 Transition API 面向全体开发者开放。

由 Android 活动识别团队的 Marc Stogaitis，Tajinder Gadh和Michael Cai 发布

人们现在携带最多的私人设备就是手机，但是到目前为止，应用程序都很难根据用户不断变化的环境以及状态来调整情景模式。我们从开发者那里了解到开发者已经花费了很多时间去结合位置以及其他传感器等各种装置的数据信号，以确定用户何时开始或者结束像是步行或者驾驶这样的情景活动。更糟的是，当应用程序不断的监测用户的当前情景活动状态时，电池的寿命会受到影响。这就是今天的目的，这就是为什么今天我们如此激动地向所有 Android 开发者提供活动识别 Transition API（不同情景活动的识别 API）-- 它是一个简单的 API，当用户行为发生改变时，会处理一切事物，且告诉用户你真正关注的是什么。

自从去年 11 月以来，Transition API 一直在后台工作，为[驾驶模式请勿打扰](https://android-developers.googleblog.com/2017/11/making-pixel-better-for-drivers.html)提供支持，这项功能在 Pixel 2 上启动。虽然在手机传感器检查到驾驶情景时打开请勿打扰似乎很简单，但在实践中会出现很多棘手的挑战。你怎么知道车辆静止是因为用户在停车场找到了位置熄火还是因为在一个红绿灯处暂时停下来呢？你是否应该相信非驾驶情景或者暂时分析错误？借助 Transtion API，所有的 Android 开发人员都可以利用 Google 使用的相同训练的数据和算法过滤器来检测用户情景活动中的这些状态更改。

Intuit 与我们合作测试 Transition API，并发现它是 [QuickBooks Self-Employed](https://play.google.com/store/apps/details?id=com.intuit.qbse) 应用的理想解决方案：

“QuickBooks Self-Employed 通过导入信息并自动跟踪汽车的行驶里程，帮助自雇员工在税务时间最大限度地减免税款。在 Transition API 之前，我们使用自己的解决方案来跟踪 GPS 以及手机其他传感器的数据，但是由于 Android 设备的多样性，我们的算法并不能 100% 保证准确性，有一些用户回馈了没有记录或者缺少数据的行驶状态。我们现在能够在几天内使用 Transition API 构建一个模型，现在已经具备了相当好的准确度，并取代了我们现有的解决方案，而且可以降低电池的消耗。Transition API 使我们能够集中精力提供减少税务的解决方案。”Intuit 的 Pranay Airan 和 Mithun Mahadevan 说。

[![](https://2.bp.blogspot.com/-xjpu46Q1QlM/WrALrluMqRI/AAAAAAAAFJc/G0jP4_1B5TgBGCioG5vyIFkCrSl1zD1WwCLcBGAs/s1600/image1.png)](https://2.bp.blogspot.com/-xjpu46Q1QlM/WrALrluMqRI/AAAAAAAAFJc/G0jP4_1B5TgBGCioG5vyIFkCrSl1zD1WwCLcBGAs/s1600/image1.png)

QuickBooks Self-Employed 中的自动追踪驾驶里程

[Life360](https://play.google.com/store/apps/details?id=com.life360.android.safetymapd) 在其应用程序中同样实现了 Transition API，并在活动检测延迟和电池的消耗方面有重大改善：

“Life360 拥有超过 1000 万个活跃的家庭用户，是全球最大的家庭移动应用程序，我们的使命是成为家庭的医院，可以让家人在何时何地都有安全感，现在我们通过定位分享以及全天候的安全功能（例如检测家庭成员的驾驶行为），因此，准确测量用户当前的活动状态并且尽可能减少电池的消耗非常关键。要确定用户何时启动开始驾驶或者停止驾驶，我们的应用之前依靠地理位置，结合位置 API 和活动识别 API，但这种方法有很多挑战，包括如何快速检测驾驶的启动而不会过渡消耗电池并要收集分析处理活动识别的 API 的原始数据，但在测试 Transition API 的时候，我们跟我们以前的解决方案进行对比，我们看到了更高的精度以及更少的电量消耗，而不仅仅是满足我们的需求。”Life360 的 Dylan Keil 说。

[![](https://3.bp.blogspot.com/-jDgcFj0bhIE/WrAL4t8LU6I/AAAAAAAAFJg/07cgXSIDGKoUO5RyY24JV7m0Wjce9XtcACLcBGAs/s1600/image2.png)](https://3.bp.blogspot.com/-jDgcFj0bhIE/WrAL4t8LU6I/AAAAAAAAFJg/07cgXSIDGKoUO5RyY24JV7m0Wjce9XtcACLcBGAs/s1600/image2.png)

Life360 中实时分享位置信息。

在接下来的几个月里，我们将继续在 Transition API 中增加新的活动分类，用来在 Android 上支持更多的情景感知功能，例如区分公路和铁路上的车辆。如果您准备在您的应用中使用 Transition API，请查看我们的 API 指南](https://developer.android.com/guide/topics/location/transitions.html)。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
