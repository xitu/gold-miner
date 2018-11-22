> - 原文地址：[Providing a safe and secure experience for our users](https://android-developers.googleblog.com/2018/10/providing-safe-and-secure-experience.html)
> - 原文作者：[Android Developers Blog](https://android-developers.googleblog.com)
> - 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> - 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/providing-safe-and-secure-experience.md](https://github.com/xitu/gold-miner/blob/master/TODO1/providing-safe-and-secure-experience.md)
> - 译者：[YueYong](https://link.juejin.im/?target=https%3A%2F%2Fgithub.com%2FYueYongDev)
> - 校对者：[zx-Zhu](https://github.com/zx-Zhu), [Wangalan30](https://github.com/Wangalan30)

# 为用户提供安全可靠的体验

**由 Google Play 的产品经理总监 *Paul Bankhead* 发布**

我们不遗余力地关注 Google Play Store 的安全性和隐私，以确保 Android 用户拥有发现和安装他们喜欢的应用程序和游戏的积极体验。我们定期更新我们的  [Google Play 开发者条款](https://play.google.com/about/developer-content-policy/)，今天引入了更强的控制和[新的策略](https://play.google.com/about/updates-resources/)来保持用户数据的安全。以下是一些更新：

## 安全性和性能升级

如前[所述](https://android-developers.googleblog.com/2017/12/improving-app-security-and-performance.html)，截至 2018 年 11 月 1 日，Google Play 将[要求](https://developer.android.com/distribute/best-practices/develop/target-sdk)对现有应用程序进行更新，使其达到 API 级别 26（Android 8.0）或更高（对于所有新应用程序来说，这已经是必需的）。我们的目标是确保 Google Play 上的所有应用程序都是使用优化了安全性和性能的最新的 API 来构建的。

## 保护用户

我们的 Google Play 开发者策略旨在为用户提供安全可靠的体验，同时为开发人员提供获得成功所需的工具。例如，我们一直要求开发人员将权限请求限制为应用程序运行所需的权限，并使用户清楚 APP 访问了他们的哪些数据。

作为今天的 Google Play 开发者策略[更新](https://play.google.com/about/updates-resources/)的一部分，我们公布了与 SMS 和呼叫日志权限相关的更改。一些 Android 应用程序请求访问用户的电话（包括通话记录）和 SMS 数据。将来，Google Play 将限制哪些应用程序可以请求这些权限。只有被选为用户默认通话或短信的应用程序才能分别访问通话记录和 SMS。

请访问我们的 [Google Play Developer 策略中心](https://play.google.com/about/developer-content-policy/#!?modal_active=none)和这篇[帮助中心文章](https://support.google.com/googleplay/android-developer/answer/9047303)，以获得关于 SMS 和呼叫日志权限的产品替代方案的详细信息。例如，[SMS Retriever API](https://developers.google.com/identity/sms-retriever/overview) 使您能够执行基于 SMS 的用户验证，[SMS Intent](https://developer.android.com/guide/components/intents-common#SendMessage) 使你能够发起 SMS 或 MMS 文本消息来共享内容或邀请。我们将与我们的开发伙伴合作，给他们适当的时间来调整和更新他们的应用程序，并将从此策略更新开始实施 90 天。

在未来几个月中，我们将在各个产品和平台上推出额外的控制和策略，并将继续与你（我们的开发人员）合作，以帮助你完成过渡。

我们的用户信任是至关重要的，我们将继续建立一个安全和可靠的 Android 生态系统。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
