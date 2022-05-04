> * 原文地址：[Here’s Exactly What You Need to Know About Apple’s App Tracking Transparency](https://onezero.medium.com/heres-exactly-what-you-need-to-know-about-apple-s-app-tracking-transparency-bdb06c0b58c0)
> * 原文作者：[Lance Ulanoff](https://medium.com/@LanceUlanoff)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/heres-exactly-what-you-need-to-know-about-apple-s-app-tracking-transparency.md](https://github.com/xitu/gold-miner/blob/master/article/2021/heres-exactly-what-you-need-to-know-about-apple-s-app-tracking-transparency.md)
> * 译者：[LoneyIsError](https://github.com/LoneyIsError)
> * 校对者：[PingHGao](https://github.com/PingHGao), [Kimhooo](https://github.com/Kimhooo)

# 以下就是你需要知道的有关苹果 App Tracking Transparency（应用追踪透明）的信息

![Photo by [Dan Nelson](https://unsplash.com/@danny144?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/10368/0*B4ygEL8TGVED_RdC)

> 译者注：根据苹果 [即将到来的 AppTrackingTransparency 要求](https://developer.apple.com/news/?id=ecvrtzt2)，从 2021 年 04 月 26 日起，所有提交的 APP 都必须为支持 ATT 做好准备。所有 APP 都必须使用 AppTrackingTransparency（应用追踪透明）框架来征得用户的许可，才能对其进行跟踪或访问其设备的广告标识符。

镇上来了一位新的隐私治安官。他的名字叫 ATT，他会在星期一骑着一匹名为 iOS 14.5 的马到来。他很喜欢 APP，但是不喜欢那些从你口袋里获取零碎数据与其团队分享的 APP。

我认为可以毫不夸张的说，苹果针对 APP 开发者的应用追踪透明（ATT）政策可能是自[怀亚特·厄普](https://en.wikipedia.org/wiki/Wyatt_Earp)（Wyatt Earp）踏入墓碑之后谈论最多、最令人畏惧的更新之一。

虽然它已经成为事实，但是我对围绕这个相对清晰明了的概念的所有误解和困惑感到惊讶。

在两个小时内，就有一个人让我谈谈 “苹果对 APP 开发者收集消费者数据的新要求“。Twitter 上的一些人想知道是否应由 APP 开发人员来决定是否遵守苹果的新规则。其他人则想知道， APP 开发人员是否可以承认即使你选择退出他们的数据收集方案，他们也无论如何都要抓取你的数据。 

苹果在他们 iOS 14.5 的文档中非常清楚地阐述了这些规则，但即使你肯定会在未来几周内的某个时间安装 iPhone（和 iPad）更新，你也可能永远不会阅读这些文档。

在 iOS 设置/隐私/跟踪下面藏着一个新的开关 “允许 APP 请求跟踪”， 或者这么说，“允许 APP 请求跟踪您在其他公司的 APP 及网站上的活动”

我知道这句话可能会让你不知所措：“我在允许企业（或开发者）要求我允许他们提出收集我个人信息的请求？”

是的，但是如果你将其关闭，那么新选项也有点模糊：

“允许 APP 继续跟踪” （相信我，你已经安装了几十个 APP ，这些 APP 多年来一直在进行数据收集和共享）

和

“要求 APP 停止跟踪”

第二个选择会立即关闭你以前提供给 APP 的跟踪权限（就我而言，我只允许了三个 APP），然后设置 ATT 防护，这将强制 APP 向你请求跟踪和共享数据的新权限。

苹果给了开发者几个月的时间将其内置到他们的 APP 中，我想，他们会想出新的方式来与依赖这些消费者数据源的第三方进行合作。

这些都不会对用户的移动设备活动产生任何实际影响，除了可能会减少你的私人数据从一个第三方 APP 合作伙伴流向另一个第三方 APP 合作伙伴。当你碰巧在 Facebook 上向朋友提到墨西哥度假目的地后，人们可能会奇怪为什么一个随机的网站会有[坎昆](https://zh.wikipedia.org/zh-hans/%E5%9D%8E%E6%98%86)的广告。

这在某种程度上就是苹果 ATT 的总和，但还有更多。我建议你进一步研究并点击 “允许 APP 请求跟踪” 模块下面的 ”了解更多“ 来获取详情。

首先，苹果明确规定了当你不允许跟踪你的活动时会发生什么：“该 APP 将无法访问你设备的广告标识符。” 它还补充说，“APP 开发人员有责任确保他们遵守你的选择。”

最后那句话让我百思不得其解：要是开发人员不遵守规定该怎么办？如果责任在于他们，那么应该由苹果来执行，对吧？

同样值得了解的是，苹果对应用跟踪的态度：

”**如果开发者仅在你的设备上这样做，并且没有以识别你身份的方式从你的设备上发送信息**，他们仅将有关你或你的设备的信息组合用于定向广告或广告测量目的时，这不应该被认为是在跟踪。“

我特地更改了字体作为强调，因为我认为这部分很关键。这就是 Facebook，作为全球[最大的消费者数据收集者](https://medium.com/@LanceUlanoff/the-great-unraveling-dc17eae49a63)之一，如何在 ATT 上继续前行。

你看，在 Facebook 的世界里，它通常是唯一知道你和你私人的 Facebook 数据之间联系的人。它与第三方广告商共享的内容不会识别你的身份。相反，它可以识别可能对广告商有吸引力的行为模式，然后将该数据连接到广告，这就是你见到的方式。不过，该广告商并不会获取你的信息。

在某些情况下，Facebook 已将不应该与任何人共享的真实数据交给了合作伙伴，这些数据被用于营销，定位或广告目的，这些伙伴确实这么做了：[请参阅 Cambridge Analytica](https://www.nytimes.com/2018/04/04/us/politics/cambridge-analytica-scandal-fallout.html)。 苹果的 ATT 就是防止这种情况。

开发者仍有足够的空间在本地收集数据，并根据这些信息投放广告。听起来像是如果你的数据已经匿名了，它仍然可以离开你的手机。例如，如果你在 Facebook 主页上写着，“我喜欢薄荷巧克力冰淇淋”，  Facebook 仍然可以让广告商知道它有一个或多个对薄荷味冰淇淋感兴趣的消费者，从广告商那里获取一则广告，然后将其投放到你的 Facebook APP 中。

苹果的 ATT  是一件大事，并且我知道他正在推动一项改革，让开发者在如何使用用户数据上面提高意识和透明度。不过，这并不能改变这场游戏，我觉得 Facebook 会没事的。

同时，请听取我的建议并阅读所有苹果关于 App Tracking Transparency 的具体细节。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
