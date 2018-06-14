> * 原文地址：[Building for the future of TV with Android](https://medium.com/googleplaydev/building-for-the-future-of-tv-with-android-1f4916f3cc3e)
> * 原文作者：[Rachel Berk](https://medium.com/@rachelberk?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/building-for-the-future-of-tv-with-android.md](https://github.com/xitu/gold-miner/blob/master/TODO/building-for-the-future-of-tv-with-android.md)
> * 译者：[JayZhaoBoy](https://github.com/JayZhaoBoy)
> * 校对者：[hanliuxin5](https://github.com/hanliuxin5), [LeeSniper](https://github.com/LeeSniper)

# 利用 Android 构建 TV 的未来

## 在大屏幕上吸引观众的新功能

![](https://cdn-images-1.medium.com/max/800/0*JKnE3YVaPD7Kmj4o.)

天气寒冷，假期也已经过去，这也是我一年中喜欢挤出点时间舒舒服服看电视的日子。我非常喜欢看 PBS（公共电视网）的 Great British Baking Show（英国烘焙大赛）；孩子和工作带来的混乱消失不见，我沉浸在 Viennese Whirls（维也纳饼干）的妙处之中。通过观看我的新 Android TV，我可以轻松找到上次观看的位置，通过智能助理，我可以知道暴风雪即将来临，然而我可以继续舒服的躺在我的沙发上捧着一杯热茶，观看参赛者们学习制作 Victorian Tennis Cake（维多利亚网球蛋糕）。

抛开个人的观看喜好，作为 Android 和 Google Play 的业务开发经理，我与娱乐公司合作，确保那些受观众喜爱的内容可以在 Android TV 上访问、发现并共享。我们生活在媒体文艺复兴时代，优秀的节目比以往任何时候都多，人们希望能够随时随地以最佳体验观看他们想要的内容。在这个追剧的时代，Android TV 是一个**将大屏幕内容带给高价值用户的平台**。

#### **为什么是 Android TV**

在本周的消费电子展（CES）上，Android TV 正在成为焦点，展示了很多新的支持设备和功能。Android TV 的增长势头迅猛，每年新增用户翻番，并有望在 2018 年再翻一番。这一增长是全球范围内与具有前瞻性的 OEMs（代工厂）和运营商建立伙伴关系的成果，灵活的平台也意味着 Android 开发人员必须提供的最好的产品。

Android TV 还有很多其他方面的优点，从可提供身临其境 4K 体验的高端索尼电视到可提供一流观看功能的 Nvidia Shield（神盾掌机）媒体播放器。目前，前十大机顶盒 OEMs（代工厂）中有 8 家以及 14 个国家的 20 家运营商为 Android TV 提供服务。鉴于这种全球影响力和多种价位的机型，Android TV 吸引了全球各种不同需求的观众。

#### **在客厅与你的高价值用户来一场电视派对**

Android TV 吸引了很多高参与度的用户，其中 87% 每天都在活跃。推动这种互动的应用，**平均每个设备安装  15  个**。

令人惊讶的是，在 [Netflix](https://play.google.com/store/apps/details?id=com.netflix.ninja) 中，新用户可能会在移动或台式机设备上注册该服务，但 2/3 的时间是在电视上观看。因此，构建身临其境的电视体验是保留这些用户的重要手段。

Android TV 不仅增加观看时间，还会创建更具粘性的用户。去年 11 月，通过 Showtime（Showtime 电视网）Android TV App 订阅者的免费试用转化率是 Android 手机的两倍。总体而言，Android TV 用户的使用期限比通过 Android 手机购买的用户长 2 倍。那些在具有前瞻性、智能的 Android TV 上体验他们最喜欢的节目的人将更加倾向于他们的订阅和整个平台。

#### **用 Android TV 追剧**

即使对于没有通过订阅获利的应用，在 Android TV 也可以吸引用户。平均而言，每月电视应用程序在 Android TV 上观看时间是移动设备上的 1.8-3 倍，假如带有 O（Android 8.0）的新功能，例如实时预览，这些参与率甚至更高。

#### **Android O（Android 8.0）具备那些新的功能?**

Google 智能助理在秋季跨平台延伸开始支持 Android TV。会话助理让人们更深入地了解他们所知道和喜爱的内容，并发现新的内容。Android TV 助理使发现新内容和导航变得轻松。用户可以使用诸如「回放五分钟」或「播放下一集」之类的命令来控制电视，或者跨应用搜索内容。此外，Android TV 现在可以作为客厅支点，让人们控制他们的物联网设备（「将灯光转换为电影模式」）或访问第三方服务（「从必胜客下单购买我最喜欢的披萨」）。对于真正的娱乐鉴赏家来说，助理可以充当你无所不知的影迷伙伴，回答与之相关的问题，例如「卢克天行者在什么星球上崛起的？」。

Android O（Android 8.0）在 Android TV 上重新设计了主屏幕。在新的主屏幕上，内容最先显示，用户只需点击一下即可访问最关心的内容。现在 Android TV 提供了简单直观的浏览和功能，允许进行私人订制。随着这些变化，用户的留存，参与和再次参与成为了设计的基础。

#### **让我们仔细看看**

![](https://cdn-images-1.medium.com/max/800/0*hRzwddXzRxFEv0Qf.)

一个新的简化的安装流程允许用户轻松地找到并下载他们使用和喜爱的应用程序。

![](https://cdn-images-1.medium.com/max/800/0*YrKrm9bPgH3lb8FX.)

借助基于频道的内容优先的用户界面，用户可以轻松查看和访问他们想要观看的节目。在屏幕的顶部，观看者可以部署助理进行简单的搜索，而在其下方有一个「最喜欢的应用」行，以及「观看下一个」选项。

随着你向下移动屏幕，你会看到多行「频道」。这些频道是新主屏幕设计的关键部分。通过对这些频道进行编排，可以定位到目标人群他们想要欣赏的内容。你现在可以完全控制频道中推广的内容，节目的顺序，内容元数据以及频道的名称和品牌。

而且，这不仅限于一个频道，内容创作者可以根据特定的用户兴趣构建和编排更多频道。举个例子，你可以创建一个假日或漫威英雄频道，又或者是一个新的，原创的节目。

![](https://cdn-images-1.medium.com/max/800/0*LKeruUoA-R_lmvRY.)

最后，新的 Android TV 用户界面具有当节目获取焦点时播放视频预览的功能。在这些预览中，你可以选择包含直播电视，预告片或 VOD 剪辑。早期的数据表明，这些预览非常引人注目，它会激励人们点击查看详细内容。

#### **使用单个 APK 可轻松构建 Android TV**

Android TV 应用使用与移动设备相同的体系结构，因此可以轻松将现有的 Android APK 扩展到 Android TV 上。通常情况下，开发人员仅依靠一个 APK 来适配移动和电视平台。Android 资源系统在处理不同的屏幕尺寸和布局时提供了巧妙的解决方案，并且通过使用 leanback 库开发人员可以构建用于首播内容体验的自定义 UI。

我希望我分享的关于 Android TV 最新功能的见解将帮助你为观众创建更具吸引力的内容。你也可以 [发现更多内容](https://developer.android.com/training/tv/index.html) 帮助你制作出一流的 Android TV 应用程序，以便在未来几年内吸引并留住高价值的用户。把握 Android TV 的未来就在现在！

* * *

### 你怎么看?

您有关于 Android TV 最新更新的想法吗？可以通过在下面的评论或使用 **＃AskPlayDev** 发一条推特，我们会通过 [@GooglePlayDev](http://twitter.com/googleplaydev)回复，我们经常分享有关如何在 Google Play 上取得成功的信息和技巧。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
