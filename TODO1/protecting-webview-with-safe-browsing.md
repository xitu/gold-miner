> * 原文地址：[Protecting WebView with Safe Browsing](https://android-developers.googleblog.com/2018/04/protecting-webview-with-safe-browsing.html)
> * 原文作者：[Nate Fischer](https://android-developers.googleblog.com)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/protecting-webview-with-safe-browsing.md](https://github.com/xitu/gold-miner/blob/master/TODO1/protecting-webview-with-safe-browsing.md)
> * 译者：
> * 校对者：

# Protecting WebView with Safe Browsing

Posted by Nate Fischer, Software Engineer.

Since 2007, Google Safe Browsing has been protecting users across the web from phishing and malware attacks. It [protects over three billion devices](https://www.blog.google/topics/safety-security/safe-browsing-protecting-more-3-billion-devices-worldwide-automatically/) from an increasing number of threats, now also including unwanted software across desktop and mobile platforms. Today, we're announcing that Google Play Protect is bringing Safe Browsing to WebView by default, starting in April 2018 with the release of WebView 66.

Developers of Android apps using WebView no longer have to make any changes to benefit from this protection. Safe Browsing in WebView has been available since Android 8.0 (API level 26), using the same underlying technology as [Chrome on Android](https://security.googleblog.com/2015/12/protecting-hundreds-of-millions-more.html). When Safe Browsing is triggered, the app will present a warning and receive a network error. Apps built for API level 27 and above can customize this behavior with [new APIs for Safe Browsing](https://developer.android.com/reference/android/webkit/WebView.html).

[![](https://1.bp.blogspot.com/-dD8ce8s6-Cs/WtToFfrvoSI/AAAAAAAAFOQ/Khc-FV9MuREKm_35uecATVbJILv45PzVgCLcBGAs/s1600/unnamed%2B%25281%2529.png)](https://1.bp.blogspot.com/-dD8ce8s6-Cs/WtToFfrvoSI/AAAAAAAAFOQ/Khc-FV9MuREKm_35uecATVbJILv45PzVgCLcBGAs/s1600/unnamed%2B%25281%2529.png)

An example of a warning shown when Safe Browsing detects a dangerous site. The style and content of the warning will vary depending on the size of the WebView.

You can learn more about customizing and controlling Safe Browsing in the [Android API documentation](https://developer.android.com/reference/android/webkit/WebView.html), and you can test your application today by visiting the Safe Browsing test URL (chrome://safe-browsing/match?type=malware) while [using the current WebView beta](https://www.chromium.org/developers/androidwebview/android-webview-beta).

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
