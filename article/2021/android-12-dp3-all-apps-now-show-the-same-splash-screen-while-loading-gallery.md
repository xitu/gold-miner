> * 原文地址：[Android 12 DP3: All apps now show the same splash screen while loading \[Gallery\]](https://9to5google.com/2021/04/21/android-12-dp3-all-apps-now-show-the-same-splash-screen-while-loading-gallery/)
> * 原文作者：[Ben Schoon](https://9to5google.com/author/nexusben1/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/android-12-dp3-all-apps-now-show-the-same-splash-screen-while-loading-gallery.md](https://github.com/xitu/gold-miner/blob/master/article/2021/android-12-dp3-all-apps-now-show-the-same-splash-screen-while-loading-gallery.md)
> * 译者：
> * 校对者：

# Android 12 DP3: All apps now show the same splash screen while loading \[Gallery\]

![](https://i0.wp.com/9to5google.com/wp-content/uploads/sites/4/2021/04/android_12_splash.gif?w=2500&quality=82&strip=all&ssl=1)

Splash screens aren’t uncommon on Android, but in its latest release, Google wants to unify the look across all apps. Starting with Android 12 and its third developer preview, all apps will now show a splash screen.

Google detailed this new functionality in its launch [post](https://android-developers.googleblog.com/2021/04/android-12-developer-preview-3.html), but in the new preview, we can see it in action. As pictured below, every Android app now shows a splash screen that essentially takes the homescreen icon and puts a background around it. That background either matches the system theme or pulls from the theme of the app.

In some cases, like Google Chrome, this splash screen is brand new in Android 12 and not a part of the app itself. In others, the splash screen gets redesigned, which is what we see with Slack. Regardless of the app, this new screen only appears for as long as it takes the app to load its first screen.

Notably, developers will have the option to customize this new splash screen as needed. As it stands now, though, they’ll need to essentially recreate their splash screen when 12 makes its formal debut. Our Dylan Roussel’s Inware app also sees its splash screen replaced in 12.

![](https://i1.wp.com/9to5google.com/wp-content/uploads/sites/4/2021/04/android_12_splash_4.gif?ssl=1 "Android 12 DP3: All apps now show the same splash screen while loading [Gallery]")

![](https://i0.wp.com/9to5google.com/wp-content/uploads/sites/4/2021/04/android_12_splash_2.gif?ssl=1 "Android 12 DP3: All apps now show the same splash screen while loading [Gallery]")

![](https://i1.wp.com/9to5google.com/wp-content/uploads/sites/4/2021/04/android_12_splash_1.gif?ssl=1 "Android 12 DP3: All apps now show the same splash screen while loading [Gallery]")

![](https://i0.wp.com/9to5google.com/wp-content/uploads/sites/4/2021/04/android_12_splash_3.gif?ssl=1 "Android 12 DP3: All apps now show the same splash screen while loading [Gallery]")

> In Android 12 we’re making app startup a more consistent and delightful experience. We’ve added a new app launch animation for all apps from the point of launch, a splash screen showing the app icon, and a transition to the app itself. The new experience brings standard design elements to every app launch, but we’ve also made it customizable so apps can maintain their unique branding. For example, you can use new [splashscreen APIs](https://developer.android.com/reference/android/window/SplashScreen) and resources to manage the splash screen window’s [background color](https://developer.android.com/reference/android/R.attr#windowSplashScreenBackground); you can replace the static launcher icon with a [custom icon](https://developer.android.com/reference/android/R.attr#windowSplashScreenBrandingImage) or an [animation](https://developer.android.com/reference/android/R.attr#windowSplashScreenAnimatedIcon); you can control the timing to reveal the app; and you can set light mode or dark mode, and manage [exit animation](https://developer.android.com/reference/android/window/SplashScreen.OnExitAnimationListener). 
>
> There’s nothing you need to do to take advantage of the new experience – it’s enabled by default for all apps. We recommend testing your app with the new experience soon, especially if you’re already using a splash screen.

We’re still digging into Android 12’s latest preview, so stay tuned for more, and catch up with all of our coverage **[here](https://9to5google.com/guides/android-12-developer-preview/)**. Feel free to drop a comment below or [ping me on Twitter](https://twitter.com/NexusBen) if you see something new!

## More on Android 12:

* [Android 12 DP3: Rounded ‘bubbly’ corners now used with all key UI elements](https://9to5google.com/2021/04/21/android-12-dp3-rounded-bubbly-corners-now-used-with-all-key-ui-elements/)
* [Here’s everything new in Android 12 Developer Preview 3 \[Gallery\]](https://9to5google.com/2021/04/21/android-12-dp3-new-features/)
* [Android 12 DP3: Settings menu redesign is live by default w/ revamped bounce animation](https://9to5google.com/2021/04/21/android-12-dp3-settings-menu-redesign-is-live-by-default-w-revamped-animations/)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
