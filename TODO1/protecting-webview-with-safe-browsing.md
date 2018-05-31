> * 原文地址：[Protecting WebView with Safe Browsing](https://android-developers.googleblog.com/2018/04/protecting-webview-with-safe-browsing.html)
> * 原文作者：[Nate Fischer](https://android-developers.googleblog.com)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/protecting-webview-with-safe-browsing.md](https://github.com/xitu/gold-miner/blob/master/TODO1/protecting-webview-with-safe-browsing.md)
> * 译者：[androidxiao](https://github.com/androidxiao)
> * 校对者：[jasonxia23](https://github.com/jasonxia23)

# 通过安全浏览保护 WebView

由软件工程师 Nate Fischer 发布。

自 2007 年以来，Google 安全浏览功能一直在保护整个网络中的用户免遭网络钓鱼和恶意软件攻击。它保护了[超过 30 亿台设备](https://www.blog.google/topics/safety-security/safe-browsing-protecting-more-3-billion-devices-worldwide-automatically/)免于不断增长的威胁，现在还包括桌面和移动平台上不需要的软件。今天，我们宣布 Google Play Protect 默认将安全浏览功能引入 WebView，从 2018 年 4 月开始发布 WebView 66。

Android 应用开发人员使用 WebView 无需再进行任何更改即可从中受益。WebView 中的安全浏览功能自 Android 8.0（API 级别 26）开始提供，使用了与 [Android 上的 Chrome](https://security.googleblog.com/2015/12/protecting-hundreds-of-millions-more.html) 相同的底层技术。当安全浏览被触发时，应用程序将显示警告并收到网络错误。为 API 27 及以上构建的应用程序可以使用[新的安全浏览 API](https://developer.android.com/reference/android/webkit/WebView.html)进行自定义此行为。

[![](https://1.bp.blogspot.com/-dD8ce8s6-Cs/WtToFfrvoSI/AAAAAAAAFOQ/Khc-FV9MuREKm_35uecATVbJILv45PzVgCLcBGAs/s1600/unnamed%2B%25281%2529.png)](https://1.bp.blogspot.com/-dD8ce8s6-Cs/WtToFfrvoSI/AAAAAAAAFOQ/Khc-FV9MuREKm_35uecATVbJILv45PzVgCLcBGAs/s1600/unnamed%2B%25281%2529.png)

安全浏览检测到危险站点时显示的警告示例。警告的样式和内容取决于 WebView 的大小。

您可以在 [Android API 文档中](https://developer.android.com/reference/android/webkit/WebView.html)了解有关自定义和控制安全浏览的更多信息，并且您可以通过访问安全浏览测试网址（chrome://safe-browsing/match?type=malware）来测试您的应用程序，同时[使用当前的 WebView 测试版](https://www.chromium.org/developers/androidwebview/android-webview-beta)。


> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
