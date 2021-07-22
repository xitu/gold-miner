> * 原文地址：[Android 12 DP3: All apps now show the same splash screen while loading \[Gallery\]](https://9to5google.com/2021/04/21/android-12-dp3-all-apps-now-show-the-same-splash-screen-while-loading-gallery/)
> * 原文作者：[Ben Schoon](https://9to5google.com/author/nexusben1/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/android-12-dp3-all-apps-now-show-the-same-splash-screen-while-loading-gallery.md](https://github.com/xitu/gold-miner/blob/master/article/2021/android-12-dp3-all-apps-now-show-the-same-splash-screen-while-loading-gallery.md)
> * 译者：[霜羽 Hoarfroster](https://github.com/PassionPenguin)
> * 校对者：

# Android 12 DP3：所有的应用程序现在都会有一个默认相同的启动页面

![](https://i0.wp.com/9to5google.com/wp-content/uploads/sites/4/2021/04/android_12_splash.gif?w=2500&quality=82&strip=all&ssl=1)

启动画面在 Android 上并不少见，但在其最新版本中，Google 希望统一所有应用程序的外观。从 Android 12 及其第三个开发者预览版开始，所有应用现在都将显示启动画面。

Google 在其[发布的推文](https://android-developers.googleblog.com/2021/04/android-12-developer-preview-3.html)中详细介绍了这项新功能，但在新的预览版中，我们可以看到 Google 已经付诸行动了。如下图所示，现在每个 Android 应用程序都会显示一个初始屏幕，该屏幕基本上采用主屏幕图标并在其周围使用了纯色背景。该背景要么与系统主题相匹配，要么从应用程序的主题中提取。

对于某些应用而言，例如 Google Chrome，这个 Android 12 的启动画面是全新的，而不是应用程序本身的一部分。在其他情况下，启动画面被重新设计了，即 Slack 的那个。无论应用程序如何，这个新的页面只会在应用程序加载其第一个页面时才会出现。

值得注意的是，开发者可以选择根据需要自定义这个新的启动画面。然而，就目前而言，当 Android 12 正式亮相时，他们需要从根本上重新创建他们的启动画面。我们的 Dylan Roussel 的 Inware 应用程序的启动画面也在 12 中被替换。

![Android 12 DP3：所有应用现在显示相同加载 [图库] 时的启动画面](https://i1.wp.com/9to5google.com/wp-content/uploads/sites/4/2021/04/android_12_splash_4.gif?ssl=1)

![Android 12 DP3：所有应用现在显示相同加载 [图库] 时的启动画面](https://i0.wp.com/9to5google.com/wp-content/uploads/sites/4/2021/04/android_12_splash_2.gif?ssl=1)

![Android 12 DP3：所有应用现在显示相同加载 [图库] 时的启动画面](https://i1.wp.com/9to5google.com/wp-content/uploads/sites/4/2021/04/android_12_splash_1.gif?ssl=1)

![Android 12 DP3：所有应用现在显示相同加载 [图库] 时的启动画面](https://i0.wp.com/9to5google.com/wp-content/uploads/sites/4/2021/04/android_12_splash_3.gif?ssl=1)

> 在 Android 12 中，我们让应用启动成为一种更加一致和愉悦的体验。我们为所有应用程序从启动点添加了新的应用程序启动动画、显示应用程序图标的启动画面以及到应用程序本身的过渡。新体验为每次应用发布带来了标准设计元素，但我们也对其进行了自定义，以便应用可以保持其独特的品牌形象。例如，您可以使用新的 [SplashScreen API](https://developer.android.com/reference/android/window/SplashScreen) 和资源来管理初始屏幕窗口的 [背景颜色](https://developer.android.com/reference/android/R.attr#windowSplashScreenBackground)；您可以使用 [自定义图标](https://developer.android.com/reference/android/R.attr#windowSplashScreenBrandingImage) 或 [动画](https://developer.android.com/reference/android/R.attr#windowSplashScreenAnimatedIcon)；您可以控制显示应用程序的时间；并且您可以设置亮模式或暗模式，并管理[退出动画](https://developer.android.com/reference/android/window/SplashScreen.OnExitAnimationListener)。
>
> 无需执行任何操作即可充分利用新体验 —— 默认情况下，所有应用程序都启用了新体验。我们建议您尽快使用新体验测试您的应用，特别是如果您已经在使用启动画面。

我们仍在深入研究 Android 12 的最新预览版，敬请期待更多内容，并了解我们有关 Android 12 开发者预览版的[所有报道](https://9to5google.com/guides/android-12-developer-preview/)。如果您看到新内容，请随时在下面发表评论或 [在 Twitter 上给我发消息](https://twitter.com/NexusBen)！

## 更多关于 Android 12 的信息

* [Android 12 DP3：圆形“气泡”角现在与所有关键 UI 元素一起使用](https://9to5google.com/2021/04/21/android-12-dp3-rounded-bubbly-corners-now-used-with-all-key-ui-elements/)
* [这里是 Android 12 Developer Preview 3 中的所有新内容](https://9to5google.com/2021/04/21/android-12-dp3-new-features/)
* [Android 12 DP3：设置菜单重新设计默认启用，带有改进的弹跳动画](https://9to5google.com/2021/04/21/android-12-dp3-settings-menu-redesign-is-live-by-default-w-revamped-animations/)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
