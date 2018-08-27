> * 原文地址：[How to create effective push notifications](https://blog.intercom.com/create-effective-push-notifications/)
* 原文作者：[GEOFFREYKEATING](http://twitter.com/geoffreykeating)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[PhxNirvana](https://github.com/phxnirvana)
* 校对者：[Danny Lau](https://github.com/Danny1451) , [Freya Yu](https://github.com/ZiXYu)

#  如何建立高效推送通知

过去二十年来，内容分发的方式已经发生了翻天覆地的变化。

推送方式从大型信息门户到网页，再到轻应用，以及手机屏幕上小小的通知（notification）栏一步一步地改变着。

通知最好的呈现方式是作为**信息**的载体。

如果内容分发的方式已经被彻底改变了的话，那创造内容的方式也一定发生了改变。这一点在当今社会已是既成事实。

可是当诸如通知这样的新形式出现时，我们却又回到了旧的内容建立模式。这使得通知这样的新科技变得快速而又平淡。

也难怪人们将通知视为二十一世纪的推销电话。没有人情味，毫无相关性，还总在错误的时间出现，通知栏简直成了错误营销的教科书，而不是一种自发行渠道。

然而，通知是可以成为一种相当有效的内容渠道的——唯一需要的就是适合该媒介的发行技巧。下文将列出几条推送通知所用到的技巧。

## 1. 注意移动化的模式 ##

尽管移动平台使用广泛，大多数的内容形式却依旧与台式计算机踩着相同的步伐。时事通讯在早上九点送达，博客推送在下午五点送达。

这些发行时间表都是与传统媒体相连甚密的，却没有自动适应移动通知（的形式）。

[Andrew Chen](http://andrewchen.co/breaking-down-671-million-push-notifications-by-hour/) 整合了一些很棒的数据，这些数据表明成吨的推送在傍晚到达（并在随后的时间迅速减少），打开率在下午六点之后相当高。结论很清晰——下午六点到八点推送通知时参与度达到最高。

![](https://blog.intercomassets.com/wp-content/uploads/2016/10/25115947/Sent_vs_Opens.jpg) 

*来源: [Andrew Chen](http://andrewchen.co/breaking-down-671-million-push-notifications-by-hour/) 和 [Leanplum](https://www.leanplum.com/)*

注意：下午六点到八点只是第一选择。推送的时间也应该考虑到紧急程度。在这个例子中，建立一个推送优先级表是很有好处的。

![](https://blog.intercomassets.com/wp-content/uploads/2016/10/25115937/Notification_Map.jpg)

## 2. 要明了而不要多加词藻 ##

每一次 iOS 和 Android 平台发布新版本，你总会听到有公司说交互性通知翻开了崭新的篇章这种话。媒体宣称“图片和 GIF 动图使 CTR （广告点击到达率）增加了 60%”，当然还有其他一系列与之相伴随的浮夸语句。

![](https://blog.intercomassets.com/wp-content/uploads/2016/10/25153946/Same_Terrible_Content-1.jpg)

但如果你的通知是**起初对用户毫无价值的**，交互性通知也就没什么意义了。大多数公司将通知作为一块模糊的、隐藏的标记区域，试图把用户拉回应用中。但通知的最佳使用方式**却是**消息。 

![](https://blog.intercomassets.com/wp-content/uploads/2016/10/25120006/image00.png)

上面这条来自 Quartz 的消息比想象中的效果还要好。

1. 用简洁的方式告诉我有趣的事物
2. 如果我想的话，可以深入挖掘，同时给予我拒绝的权利
3. 推送有趣内容时再三确认我下载 Quartz 应用的选择

通知在作为更细节的信息的入口时效果相当好，但只在原始信息足够吸引人探究时才有效果。

## 3. 个性化怎么可能只是加个名字啊喂（译者：大雾） ##

当你忘记那堆市场营销的最佳实践时，就入门了。

我们手机主屏幕上有着太多个性化交互的东西了——朋友的社交媒体消息，家人的短信等。

为了实现个性化定制的通知，各公司的通知都应该遵循规范。即使是各种小细节，如添加接收者的名字都可以让推送通知体验更好。（某些情况下 [可以达到四倍的优化](http://andrewchen.co/new-data-on-push-notification-ctrs-shows-the-best-apps-perform-4x-better-than-the-worst-heres-why-guest-post/)）
当然，个性化绝不只是前面加个用户名字，后面署上自己名字那么简单。在通知上使用精准个人信息的重要性，恕我词穷，用语言难以描述万一。 事件参数、语言、生活圈等都是确保你的信息足够个性化和针对性的手段。（当然，[Intercom](https://www.intercom.com/customer-engagement) 是发送这类信息的一个很好的选择，但无论使用什么工具，道理都是一样的。）

![](https://blog.intercomassets.com/wp-content/uploads/2016/10/25115944/Say_This_Not_This_Final-1.jpg)

## 4. 通知的实时性 ##

通知面临的一大问题是它们的内容的有效性本质上是转瞬即逝的，一旦发送出去就无法适应新的时间或背景。

[一些发布者](http://www.niemanlab.org/2016/06/the-guardian-is-experimenting-with-interactive-auto-updating-push-alerts-to-cover-big-stories/) 正在试图将自动更新的通知变为可能。这意味着你将得到最新的和最精准的推送消息。

> Android 又得一分，实时更新通知是个很棒的特性。[pic.twitter.com/7gs9cqMrcf](https://t.co/7gs9cqMrcf)
> 
> — Zach Seward (@zseward) [June 8, 2016](https://twitter.com/zseward/status/740359109967548418)

**主屏上实时更新的 Bernie Sanders 和 Hillary Clinton 的选举情况**

也许大多数公司目前无法做到实时更新推送，但需要指出的十分重要的一点是——推送当下的、实时的信息可以得到最大的（用户）参与量。

影响你在真实世界计划和决策的新闻（想想 Uber 的自动调价通知），转瞬即逝的机会（比如亚马逊降价了），和刚更新的关注内容（比如 Netflix 的新电影）这些都是最受欢迎的打断性通知。

## 5. 衡量实际效益而不是乱放卫星 ##

传统上，推送的评价方式都是依赖指标如打开率、点击率等。这些吹出来的数据也只能信一半。

举个例子，一个成功的推送应该是自包含的，独立的信息，如上文所述。如果人们没有点击进去，意味着推送没有吸引到他们——或者是它已经完成使命了（译者注：此处译者的理解是看到推送的标题就够了，没必要打开看内容）。点击率和打开率对于激励你的同事很有用，但在帮助你了解用户真正需要的信息时并没有太大作用。 

尽管有些难以追踪，一个评价有效性的好方法是注意**负面信息**。用户是否在收到一系列推送后关闭了消息通知？通知是否是卸载应用的原因？从这边着手的一个好方法是追踪重复使用行为。（我们测量 [保有量](https://blog.intercom.com/retention-cohorts-and-visualisations/) 的行为是一个好的开端。）

---

在开始推送消息前只有五点需要注意的。而这五点的开始是忘记你学过的市场营销技巧，并用上文的基础创造新的策略）如果你还有其他诸如此类的推送技巧，或者你想要上文中任何更细节的信息，可以在下面留言或者通过本页的消息框（译者注：原博客网页右下角）与我们取得联系。

