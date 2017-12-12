> * 原文地址：[Shrinking APKs, growing installs: How your app’s APK size impacts install conversion rates](https://medium.com/googleplaydev/shrinking-apks-growing-installs-5d3fcba23ce2)
> * 原文作者：[Sam Tolomei](https://medium.com/@samueltolomei?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/shrinking-apks-growing-installs.md](https://github.com/xitu/gold-miner/blob/master/TODO/shrinking-apks-growing-installs.md)
> * 译者：[tanglie1993](https://github.com/tanglie1993)
> * 校对者：[swants](http://www.swants.cn), [corresponding](https://github.com/corresponding)

# 缩小APK，增加下载量

## 你的APK大小是如何影响下载转化率的

![](https://cdn-images-1.medium.com/max/800/0*f1gQ1k1n3_d4-x9t.)

自从 Android Marketplace （Google Play 的前身）在 2012 年 3 月上线以来，**app 的平均大小增长了四倍**。随着移动 app 的不断成熟，开发者们不断增加新的特性来服务和吸引用户，这使不少人从中受益。然而，随着 app 的特性越来越多——更多 SDK、更高分辨率的图片、更好的图形—— APK 也变得越来越大。在本文中，我讨论了 APK 大小的重要性，并且分析了 Google 在过去 2 年中所做的用户体验研究的结果。
![](https://cdn-images-1.medium.com/max/800/0*nLLV6VxsHaagxgCk.)

下载的 APK 的平均大小随时间的变化（Google 内部数据）

发现 APK 在变大之后，我们分析了 APK 大小对下载转化率的影响。我们发现，**更小的 APK 对应着更高的下载转化率**，对于新兴市场中的用户而言尤其如此。在许多开发者把注意力投入到向新市场（特别是新兴市场）扩张中去的情况下，关注 app 的大小就显得很重要。

### **APK 大小是否会影响下载转化率？**

为了研究 APK 大小对用户的选择是否有显著影响，我们分析了**用户在浏览了 Play store 中的一个项目之后成功下载这个 app 的百分比**。

![](https://cdn-images-1.medium.com/max/800/1*XxnZXaLarvTKJD-pnhVBUg.png)

在 App store  的相应页面中，你可以通过点击“Read More”看到一个 app 的大小。

这看起来还是有些意义的！总的来说，我们发现在小于 100 MB 的情况下，APK 大小和下载转化率之间存在负相关。**一个 APK 的大小每增长 6 MB，下载转化率就有 1% 的降低**。在市场团队使用 A/B 测试来优化下载转化率的情况下，APK 大小会有重大影响。

这个下降中的一个重要部分不是因为用户选择了不下载，而是下载由于种种原因没有成功。我们发现，一个 10MB 的 app 的下载完成率将比 100MB 的 app 高**大约 30%**。

这可能是因为：

1. 用户考虑了需要下载的数据量（以及数据的**价格**）。
2. 在他们的移动网络或 wifi 中的 **下载所需时间** （人们经常陷入“我现在就要这个 app！”的思维模式）。
3. 下载过程中的 **网络连接性问题**。

### **人们对 APK 大小的偏好和下载转化率是否会因地域而异？**

这是一个好问题，答案是肯定的。在新兴市场中，有许多没能使用到稳定 wifi 的用户，他们需要支付流量的费用。

**超过 50% 的印度和印尼安卓智能手机用户完全没有 wifi**。所以如果一个用户需要下载一个 app，他很可能要为 APK 的每一 MB 付费（Google 内部数据，2017年）。

![](https://cdn-images-1.medium.com/max/800/0*TNaKtrVPw31uV3me.)

印度 wifi 普及率调查 (Google 内部安卓用户调查)

与之相似, 出于流量价格和存储空间的考虑，**新兴市场中大约 70% 的用户会在下载前考虑 app 的大小**。

![](https://cdn-images-1.medium.com/max/800/0*OH32EpFgpqb-tm2P.)

被调查的印尼用户中会在安装时考虑 app 大小的人所占百分比 (Google 内部安卓用户调查)

![](https://cdn-images-1.medium.com/max/800/0*juzFS4rHk1SJqa5a.)

安装时会考虑 app 大小的用户这样做的原因 (Google 内部安卓用户调查)

我们可以看到，这些市场偏好非常显著。比如，新兴市场（如中东、非洲和东南亚）用户下载的 APK 的平均大小，**是发达市场（如美国和西欧）的四分之一**。

![](https://cdn-images-1.medium.com/max/800/0*PgaK63Sz_T4s0Ezw.)

APK 大小中位数，根据下载量加权，按市场分类。绿色 = 更大的中位数 APK 大小，红色 = 更小的 中位数 APK 大小（Google 内部数据）。

研究下载转化率数据，就可以发现新兴市场（如印度和巴西）和发达市场（如日本、美国和德国）相比，在面对越来越大的 APK 时会有不同的反应。

![](https://cdn-images-1.medium.com/max/800/1*oa_4HPWrqANWG7WKwJl3OQ.png)

APK 每缩小 10MB 对应下载转化率的增加，按市场分类（Google 内部数据）。

从上图中，我们可以看到 APK 缩小 10MB，在印度和巴西造成的影响会比德国、美国和日本更大。从 APK 中移除 10MB 内容，在新兴市场中对应着 **下载转化率 2.5% 的增长**。

让我们把实际的数字填入下载转化率的增长中：如果你的 app 在印度每个月有 10000 下载量，转化率 20%，缩小 10MB 可以使得下载量每月增加 1140 左右。

最后，当把非游戏的 app 和游戏比较时，我们可以在下载转化率和 APK 大小之间看到类似的关系。但是，对于超过 500MB 的游戏而言，用户们对于 APK 大小的微小变化更不敏感。对于 500-3000MB 的游戏而言，APK 每缩小 200MB，下载转化率只增加 1%。

### **那么，我是否应该缩小 APK？如果应该，该怎么做？**

根据以上数据很容易看出，对于全世界人民来说 APK 大小都是很重要的。

“这很重要，” 你说，“但是我具体可以如何缩小 APK 呢？” 我很高兴你这样问了！缩小 APK 有以下几个入门要点：

*   [**缩小 APK**](https://developer.android.com/topic/performance/reduce-apk-size.html)安卓开发者网站上的入门教材，它包含了移除不使用的资源和压缩图片文件。

*   [**Building for Billions 指南**](https://developer.android.com/develop/quality-guidelines/building-for-billions.html), 在安卓开发者网站上，它讨论了缩小 APK，以及其它针对新兴市场的措施。
*   [**如何针对新兴市场优化你的应用**](https://medium.com/googleplaydev/how-to-optimize-your-android-app-for-emerging-markets-7124c4180fc), 我们团队的另一篇 medium 文章。针对新兴市场，通过三个 app 去分析优化带来的好处。

至于其他的针对新兴市场的考虑，可以去 Google Play 的 [Building for Billions](https://developer.android.com/topic/billions/index.html) 网站上寻找指导。

我花很多篇幅讨论了在新兴市场中缩小 APK 的好处。还有一个另外的缩小 APK 的原因，
这就是 Android Instant App 要求更小的 APK。Instant App 允许安卓用户不经过安装直接使用，是另一种让你的用户发现你的 app 的方式。关于开始使用 [Android Instant App](https://developer.android.com/topic/instant-apps/index.html)，你可以在这里找到更多信息。你也可以学习更多 [管理下载内容大小的最佳实践](https://android-developers.googleblog.com/2017/08/android-instant-apps-best-practices-for.html)。

* * *

### 你怎么看？

我希望你觉得这些观点有用。你有没有关于 APK 大小的问题或观点，或者关于缩小 app 所占空间的故事？在评论区中继续讨论或在 twitter 中使用 #AskPlayDev 的标签。我们将从 [@GooglePlayDev](http://twitter.com/googleplaydev) 回复。我们定期在这里分享新闻，以及如何在 Google Play 上成功的建议。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
