> * 原文地址：[5 tips for using showInstallPrompt in your instant experience](https://medium.com/androiddevelopers/5-tips-for-using-showinstallprompt-in-your-instant-experience-99d4681e0ae)
> * 原文作者：[Miguel Montemayor](https://medium.com/@migmontemayor)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/5-tips-for-using-showinstallprompt-in-your-instant-experience.md](https://github.com/xitu/gold-miner/blob/master/TODO1/5-tips-for-using-showinstallprompt-in-your-instant-experience.md)
> * 译者：
> * 校对者：

# 5 tips for using showInstallPrompt in your instant experience

![](https://cdn-images-1.medium.com/max/3200/0*5eAOuRUKrRBXEJdI)

[Google Play Instant](https://developer.android.com/topic/google-play-instant) allows your users to try your app or game before installing. Whether launching from the Play Store or a URL, instant experiences take your users directly into a native experience of your app.

One of the goals of your instant experience may be to drive installs from your app’s instant experience. You can achieve this more easily by making sure you are correctly using the latest APIs and best practices.

When users decide to install your app or game, the [showInstallPrompt API](https://developers.google.com/android/reference/com/google/android/gms/instantapps/InstantApps.html#showInstallPrompt(android.app.Activity,%20android.content.Intent,%20int,%20java.lang.String)) allows you to prompt for installation from within your instant experience. After calling the API, an in-app install prompt overlay appears in your app. Once the user agrees to install, the app installation process begins. When completed, the installed app launches automatically.

![**This animation shows the installation flow when using showInstallPrompt**](https://cdn-images-1.medium.com/max/2000/0*HaJS3sMgtdYB_TxA)

When implementing showInstallPrompt in your instant experience, the best practices detailed below that will make transitioning your users from instant to installed app as smooth as possible.

## 1. Make sure you’re using the latest showInstallPrompt API

Rolled out in June 2018, the updated [showInstallPrompt API](https://developers.google.com/android/reference/com/google/android/gms/instantapps/InstantApps.html#showInstallPrompt(android.app.Activity,%20android.content.Intent,%20int,%20java.lang.String)) gains a few key benefits over the legacy API. The new API displays a smaller install prompt and improves the transition to your installed app with the addition of the postInstallIntent parameter, which specifies the activity to launch after installation.

> Identifying the showInstallPrompt version in your instant experience

Previously, the legacy API would launch a larger in-app install prompt. Due to the legacy showInstallPrompt deprecation, now calling it launches your Play Store listing. In order to restore in-app install prompts, you’ll need to migrate to the new API.

If you’re not sure whether your instant experience calls the legacy API, you can quickly figure out by running your instant app and selecting the install button. If you’re taken to the Play Store listing, you’re using the legacy API. If you see an in-app overlay, you’re using the latest API.

Alternatively, you can check your code to see if your method call includes the postInstallIntent parameter. If it does not include the postInstallIntent, you’re using the legacy API. Here’s the method signature of the new showInstallPrompt API:

```
public static boolean showInstallPrompt (Activity activity, Intent postInstallIntent, int requestCode, String referrer)
```

The `postInstallIntent` is the intent that will launch after the app has been installed. It must resolve to an activity in the installed app package, or it will not be used.

> Migrating to the new showInstallPrompt

To migrate to the new showInstallPrompt API, follow these steps:

1. Make sure you are using the latest instant app client library in your project. Update the following dependency in your build.gradle file:

```
implementation 'com.google.android.gms:play-services-instantapps:16.0.1'
```

2. Update your code to use the new [showInstallPrompt API](https://developers.google.com/android/reference/com/google/android/gms/instantapps/InstantApps.html#showInstallPrompt(android.app.Activity,%20android.content.Intent,%20int,%20java.lang.String)) with the postInstallIntent parameter.

3. Upload your instant app to the [internal test track](https://support.google.com/googleplay/android-developer/answer/3131213?hl=en) to verify that the install button now launches an in-app install prompt overlay.

You can also look through this [sample app](https://github.com/googlesamples/android-instant-apps/tree/master/install-api) using the new showInstallPrompt API to see how this works.

## 2. Pre-register from within your instant game

The showInstallPrompt API is not just for installation! If your instant game supports [pre-registration](https://support.google.com/googleplay/android-developer/answer/9084187), you can prompt for pre-registration signup using the same API.

When your app calls showInstallPrompt, the behavior for pre-registration is similar to what appears during installation. An in-app overlay appears to pre-register the user. Then the user will be able to continue where they left off in the instant game. Users who pre-register will be notified when the game is released.

To launch the pre-registration flow, you call showInstallPrompt just as if you were going to prompt for install.

```
// Prompt for pre-registration
InstantApps.showInstallPrompt(activity, postInstallIntent, requestId, referrerId)
```

Note the `postInstallIntent` parameter is ignored after pre-registration is completed.

## 3. Transition user state to the installed app

Transfer the user’s state from the instant experience into the installed app. Users should be able to pick up where they left off. Any achievements or progress made in the instant experience should carry over to the installed app or game.

![](https://cdn-images-1.medium.com/max/2000/0*r7DBqy2P92QFwOPf)

The recommended way to persist user state is using the [Cookie API](https://developers.google.com/android/reference/com/google/android/gms/instantapps/PackageManagerCompat#getInstantAppCookie()) for migrating data after installation. The Cookie API allows you to store a small token of information on the device that can be accessed by your installable app. The API ensures that only apps with the same package ID as your instant app can access the cookie.

In your instant app, you should always store your cookie data by using [PackageManagerCompat](https://developers.google.com/android/reference/com/google/android/gms/instantapps/PackageManagerCompat.html#setInstantAppCookie(byte[])).

```Kotlin
// Cookie data is a simple byte array.
val cookieData: ByteArray = byteArrayOf()

// Use PackageManagerCompat to access Cookie API
val packageManager = InstantApps.getPackageManagerCompat(applicationContext)

// Ensure that the cookie data will fit within the store before setting
// the value.
if (cookieData.length <= packageManager.getInstantAppCookieMaxSize()) {
   packageManager.setInstantAppCookie(cookieData)
}
```

After the user installs the app, you can access the data.

```Kotlin
// Use PackageManagerCompat to access Cookie API.
val packageManager = InstantApps.getPackageManagerCompat(this)
val cookieData = packageManager.getInstantAppCookie()

// Clear the cookie data once it has been read to clear it.
packageManager.setInstantAppCookie(null)
```

## 4. Don’t interfere with task completion

Users shouldn’t be interrupted when working through the tasks they sought to complete when opening the instant experience. Avoid asking users to install your app when they’re partially completed with a task.

You can call showInstallPrompt after the user has completed their task or wants to use an additional feature not available in your instant app.

![](https://cdn-images-1.medium.com/max/2000/1*uovyCegQYpdiurkTpTL5lQ.png)

For example, if you lead users to an instant experience through a product ad online, your instant app should allow your users to complete the checkout flow. After the purchase is completed, you can prompt for install. Avoid requiring the user to install or sign up before they can complete their purchase.

## 5. Provide explicit installation prompts

This last tip may seem obvious, but make sure your instant experience has explicit install prompts. Without them, users may be confused on how to install your app or may have to go to the Play Store to install.

The install buttons should call showInstallPrompt to launch the install prompt.

![](https://cdn-images-1.medium.com/max/2000/1*nKfEwwU4dVp08ZUndHvuIA.png)

Use the [Material Design “get app” icon](https://material.io/icons/#ic_get_app) and the label “Install” for the installation button or “Pre-Register” for the pre-registration button.

Don’t use any other labels like “Get the app”, “Install the full app,” or “Upgrade”. Don’t use a banner or other ad-like technique for presenting an installation prompt to users.

***

If you have additional questions about implementing the showInstallPrompt API in your instant app or game, post your question on [StackOverflow](https://stackoverflow.com/questions/tagged/android-instant-apps). Learn more about [Google Play Instant](https://developer.android.com/topic/google-play-instant) and check out our other [UX best practices](https://developer.android.com/topic/google-play-instant/best-practices/apps).

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
