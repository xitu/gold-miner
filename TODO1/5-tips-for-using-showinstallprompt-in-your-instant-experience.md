> * 原文地址：[5 tips for using showInstallPrompt in your instant experience](https://medium.com/androiddevelopers/5-tips-for-using-showinstallprompt-in-your-instant-experience-99d4681e0ae)
> * 原文作者：[Miguel Montemayor](https://medium.com/@migmontemayor)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/5-tips-for-using-showinstallprompt-in-your-instant-experience.md](https://github.com/xitu/gold-miner/blob/master/TODO1/5-tips-for-using-showinstallprompt-in-your-instant-experience.md)
> * 译者：[Fxymine4ever](https://github.com/Fxy4ever)
> * 校对者：[jacksonke](https://github.com/jacksonke)

# 在你的 Instant 体验中使用 showInstallPrompt 的 5 个技巧 

![](https://cdn-images-1.medium.com/max/3200/0*5eAOuRUKrRBXEJdI)

[Google Play Instant](https://developer.android.com/topic/google-play-instant) 允许用户在安装前就可以试用你的应用或者游戏。无论是否从 Play Store 还是网址发布，Instant 都可以让你的用户直接拥有原生应用的体验。

你的 Instant 体验其中一个目标可能是利用你的应用程序的 Instant 体验来促进安装。通过保证正确使用最近的 API 和最佳的实践，你可以更轻松地实现这个目标。

当用户决定去安装你的应用程序或游戏时，[showInstallPrompt API](https://developers.google.com/android/reference/com/google/android/gms/instantapps/InstantApps.html#showInstallPrompt(android.app.Activity,%20android.content.Intent,%20int,%20java.lang.String)) 允许你在 Instant 体验中提示用户是否进行安装。在调用这个 API 后，一个应用内提示会出现在你的应用程序中。一旦用户同意去安装，该应用的安装程序会开始安装。当安装完成时，刚才安装的应用程序会自动启动。

![**This animation shows the installation flow when using showInstallPrompt**](https://cdn-images-1.medium.com/max/2000/0*HaJS3sMgtdYB_TxA)

在你的 Instant 体验中使用 showInstallPrompt 时，下面详细介绍了最佳的实践，这可以让你的用户丝滑地从 Instant 过渡到已安装的 App。

## 1、确保你使用最近的 showInstallPrompt API

2018年6月更新后的 [showInstallPrompt API](https://developers.google.com/android/reference/com/google/android/gms/instantapps/InstantApps.html#showInstallPrompt(android.app.Activity,%20android.content.Intent,%20int,%20java.lang.String)) 与旧的 API 相比，前者有几个关键的优点。新的 API 可以显示一个更小的安装提示，同时也可以通过添加额外的 postInstallIntent 参数，来优化从 Instant 到已安装 App 的过渡，这个参数可以指定安装后启动的 Activity。

> 在你的 Instant 体验中确认 showInstallPrompt 的版本。

以前，旧版本的 API 会启动一个更大的应用内安装提示。由于旧版 showInstallPrompt 已经弃用，现在调用这个 API 会启动你的 Play Store 列表。为了恢复应用内安装提示，你需要迁移到新的 API。

如果你不确定你的 Instant 体验是否调用这个旧的 API，你可以通过运行你的 Instant App 并且选取安装按钮来快速确认。如果你跳转到了 Play Store 列表，这说明你正在使用旧的 API。如果你看见一个应用内的覆盖，这说明你正在使用最新的 API。

此外，你还可以检查你的代码是否调用了包含 postInstallIntent 参数的 API。如果没有包含 postInstallIntent，这说明你正在使用旧的 API。下面是新的 showInstallPrompt API 的方法签名：

```
public static boolean showInstallPrompt (Activity activity, Intent postInstallIntent, int requestCode, String referrer)
```

`postInstallIntent` 是在应用安装之后触发的 Intent。这个 Intent 必须是能被解析为已安装应用中的 Activity，否则它将无效。

> 迁移到新版的 showInstallPrompt

迁移到新版的 showInstallPrompt API，应该遵循下面几个步骤：

1、确保你的项目中使用的是最新版的 Instant App 客户端的库。在你的 build.gradle 中更新如下的依赖：

```
implementation 'com.google.android.gms:play-services-instantapps:16.0.1'
```

2、更新你的代码，将旧版 API 转换为带有 postInstallIntent 参数的新版 [showInstallPrompt API](https://developers.google.com/android/reference/com/google/android/gms/instantapps/InstantApps.html#showInstallPrompt(android.app.Activity,%20android.content.Intent,%20int,%20java.lang.String))。

3、上传你的 Instant App 到 [内部跟踪测试](https://support.google.com/googleplay/android-developer/answer/3131213?hl=en)，以验证安装按钮现在是否启动了一个应用内安装覆盖提示。

你同样可以查看这个使用了新版 showInstallPrompt API 的 [示例应用程序](https://github.com/googlesamples/android-instant-apps/tree/master/install-api)，以了解它是怎么工作的。

## 2、在你的 Instant 游戏中预注册

showInstallPrompt API 不仅仅是为了安装！如果你的 Instant 游戏支持 [预注册](https://support.google.com/googleplay/android-developer/answer/9084187)，你可以使用相同的 API 提示进行预注册。

当你的应用调用 showInstallPrompt 时，预注册的行为和安装期间的行为相似。应用内的覆盖区域也会出现预注册的用户。用户之后可以继续从 Instant 游戏里的进度玩起。此外，预注册的用户将在游戏发布的时候收到通知。

要启动预注册的流程，你可以调用 showInstallPrompt API，就像之前的提示安装一样。

```
// 提示预注册
InstantApps.showInstallPrompt(activity, postInstallIntent, requestId, referrerId)
```

注意， `postInstallIntent` 参数在预注册完成之后将被忽视。

## 3、转变用户的状态到已安装的应用程序

将用户的状态从 Instant 体验转变到已安装的应用程序。用户应该能选择是否从之前 Instant 体验里中断的地方开始。任何在 Instant 体验中取得的成就或者进度都应该延续到已安装的应用或游戏中。

![](https://cdn-images-1.medium.com/max/2000/0*r7DBqy2P92QFwOPf)

保护用户数据，我们推荐你使用 [Cookie API](https://developers.google.com/android/reference/com/google/android/gms/instantapps/PackageManagerCompat#getInstantAppCookie()) 在安装之后迁移试玩的数据。Cookie API 会允许你在设备上存储一小部分信息的 token，这个 token 能被你的可安装的应用程序访问。这个 API 会确保只有当应用程序的 Package ID 与你的 Instant App 相同时，才能访问该 Cookie。

在你的 Instant App 中，你应该一直使用 [PackageManagerCompat](https://developers.google.com/android/reference/com/google/android/gms/instantapps/PackageManagerCompat.html#setInstantAppCookie(byte[])) 存储 Cookie 数据。

```Kotlin
// Cookie 数据是一个简单的 byte 数组。
val cookieData: ByteArray = byteArrayOf()

// 使用 PackageManagerCompat 去访问 Cookie API。
val packageManager = InstantApps.getPackageManagerCompat(applicationContext)

// 在设置值之前，确保cookie数据可以适合存储。
if (cookieData.length <= packageManager.getInstantAppCookieMaxSize()) {
   packageManager.setInstantAppCookie(cookieData)
}
```

在用户安装了这个应用程序之后，你可以访问这个数据。

```Kotlin
// 使用 PackageManagerCompat 去访问 Cookie API。
val packageManager = InstantApps.getPackageManagerCompat(this)
val cookieData = packageManager.getInstantAppCookie()

// 在读取了这个 Cookie 数据之后清除它
packageManager.setInstantAppCookie(null)
```

## 4、不要干扰任务的完成

在打开 Instant 体验时，在完成他们想要完成的任务时，用户不应该被中断。当用户在部分完成他们的任务的时候，避免安装你的应用程序。

如果用户已经完成他们的任务之后，或者想要去使用一个在你的 Instant App 中无法使用的额外的功能时，你可以调用 showInstallPrompt API。

![](https://cdn-images-1.medium.com/max/2000/1*uovyCegQYpdiurkTpTL5lQ.png)

例如，如果你想通过在线产品广告来引导用户获得 Instant 体验，你的 Instant App 应该允许你的用户完成结账流程。在购买完成之后，你可以提示安装。避免要求用户在购买完成之前进行安装或者注册。

## 5、提供明确的安装提示

虽然最后一个提示的意思很容易理解，但是请确保你的 Instant 体验有一个明确的安装提示。如果没有这些提示，用户可能会疑惑怎样去安装你的应用，或者可能不得不跳转到 Play Store 去安装。

安装按钮应该调用 showInstallPrompt 去触发安装提示。

![](https://cdn-images-1.medium.com/max/2000/1*nKfEwwU4dVp08ZUndHvuIA.png)

使用 [Material Design “获取” 图标](https://material.io/icons/#ic_get_app)，同时在安装按钮上显示“安装”或预注册按钮上显示“预注册”。

不要使用任何其他的标签，例如“获取这个应用”、“安装完整应用”或者“升级”。同时也不要使用轮播图或者其他像广告的技术去向用户展示安装提示。

***

如果你在你的应用或者游戏中使用 showInstallPrompt API 遇到了额外的问题，你可以发送你的问题到 [StackOverflow](https://stackoverflow.com/questions/tagged/android-instant-apps)。了解更多关于 [Google Play Instant](https://developer.android.com/topic/google-play-instant) 同时看看我们其他的 [用户体验最佳实践](https://developer.android.com/topic/google-play-instant/best-practices/apps)。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
