> * 原文地址：[Exploring Android 12: Splash Screen](https://joebirch.co/android/exploring-android-12-splash-screen/)
> * 原文作者：[Joe Birch](https://joebirch.co/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/exploring-android-12-splash-screen.md](https://github.com/xitu/gold-miner/blob/master/article/2021/exploring-android-12-splash-screen.md)
> * 译者：[Kimhooo](https://github.com/Kimhooo)
> * 校对者：

# 探索 ANDROID 12：启动画面

![](https://joebirch.co/wp-content/uploads/2021/05/header-1-1024x538.png)

随着 Android 12 测试版现已推出，我们开始详细了解最新版 Android 为我们提供的新功能。在这里引起我注意的一件事是 Splash Screen API 的引入 —— 不仅为应用程序在其应用程序中呈现启动画面提供了一种标准化的方式，而且还改善了启动应用程序时的用户体验。我正在准备发布 [Compose Academy](https://compose.academy/) 应用程序，同时确保一切针对 Android 12 API 正常运行 - 所以这是了解启动画面相关 API 的绝佳机会。

您可能会想，我看到许多看起来很棒的应用程序的启动画面！虽然这是真的，但很多时候这需要开发人员创建自己的启动画面类。这些有时仅用于在屏幕上显示某种形式的品牌，甚至处理更复杂的场景，例如在用户进入应用程序之前执行应用程序初始化和获取数据。还有一些情况需要考虑，应用程序甚至没有设置某种形式的启动画面——因为用户在启动应用程序时可能是从冷启动或热启动，这并不总是能带来流畅的体验。例如，让我们看看如果您不设置某种启动画面，应用程序当前的样子。

![](https://joebirch.co/wp-content/uploads/2021/05/ezgif-3-8750c93b9fd1.gif)

就个人而言，这感觉有点笨拙！当我等待我的应用程序启动时，我看到一个空白屏幕，它不显示任何类型的品牌 - 这不是将用户带入我们的应用程序的最佳体验。

许多应用程序在这里开始做的是利用主题内的 **android:windowBackground** 属性，允许您基本上设置在应用程序加载时将在此空白空间中显示的内容。现在，这并不是对“闪屏”内容的完全官方支持，而是一种避免在屏幕上显示空白区域的方法。

![](https://joebirch.co/wp-content/uploads/2021/05/ezgif-3-ec15080396ca.gif)

现在，虽然这并不能顺利过渡到我们的应用程序，但这绝对比以前看起来更好！这里唯一需要注意的是，因为这只是将一些主题应用到窗口的背景，启动时间将保持不变 —— 所以如果我们正在做某种应用程序设置，我们仍然需要添加一些其他更改以支持这些要求。

在 API 级别 26 中，我们看到了 **android:windowSplashScreenContent** 属性的引入。这可用于在您的应用程序启动时将某些内容显示为启动画面。虽然这再次无法处理在此期间我们可能需要处理应用程序初始化的场景，但它提供了更流畅的启动画面显示和进入我们的应用程序的入口。

![](https://joebirch.co/wp-content/uploads/2021/05/ezgif-3-f08bf585309b.gif)

现在来到 Android 12，我们有了新的启动画面 API。在不使用这些 API 提供的任何进一步自定义的情况下，我们可以看到，除了这次开箱即用之外，我们仍然拥有与 API 26 中添加的属性非常相似的流畅体验：

![](https://joebirch.co/wp-content/uploads/2021/05/ezgif-3-21fac4a28a5e.gif)

虽然这看起来与我们在 API 26 中看到的属性没有太大区别，但在 Android 12 中，我们可以访问更多属性，允许进一步自定义我们的启动画面。这些属性允许我们以以前在不提供自定义启动屏幕活动的情况下无法实现的方式自定义启动屏幕。

![](https://joebirch.co/wp-content/uploads/2021/05/Group-1-1024x733.png)

在接下来的部分中，让我们看看我们如何利用这些来为我们的应用程序的发布提供定制的体验。

## 显示启动画面

虽然在以前的 API 版本中，我们需要提供某种形式的资源作为主题属性以用于我们的窗口内容或启动画面内容，但在 Android 12 中 **不再需要**。因此，了解这一点很重要。**默认情况**下，您的启动器 Activity 将显示这个新的启动画面 - 因此，如果您当前在应用程序中显示自定义启动画面，则需要适应 Android 12 中的这些更改。

虽然启动画面 API 提供了一组可用于微调启动画面外观的属性，但如果您不为这些属性提供值，则将使用应用程序中的默认值和资源。例如，以下是在运行 Android 12 的设备上启动我的应用时显示的默认启动画面：

![](https://joebirch.co/wp-content/uploads/2021/05/Screenshot_20210527_061703-485x1024.png)

当涉及到启动画面的显示时，我们可以在这里看到一些事情 —— 我的应用程序的图标显示在背景颜色的顶部。在我的应用程序中，我使用了一个自适应图标，看起来好像初始屏幕直接使用该自适应图标 xml 引用来在屏幕内显示图标。我知道这一点是因为当我更改启动图标的背景层颜色时，这反映在我的启动画面中。

## 设置背景颜色

正如我们在上面看到的，启动画面将使用默认的背景颜色*。在某些情况下，我们可能想要覆盖它——也许它需要匹配品牌颜色，或者当应用程序图标显示在默认背景颜色之上时，它看起来不太正确。在任何一种情况下，您都可以利用 **windowSplashScreenBackground** 属性来覆盖此默认颜色。

```xml
<item name="android:windowSplashScreenBackground">#000000</item>
```

![](https://joebirch.co/wp-content/uploads/2021/05/Screenshot_20210527_061650-485x1024.png)

> I’m not entirely sure what color is being used for this background color yet, I will update this post once I have clarity here!

## Setting the Splash Icon

In some cases, you might not want to use your application icon for the icon displayed in the splash screen. If you want to display something else in place of this then you can use the **android:windowSplashScreenAnimedIcon** attribute to do so. I find this name a bit misleading as this icon can actually be a reference to one of two things:

* **A static vector drawable reference** – used to display a static asset in place of the default application icon

* **An animated vector drawable** – used to display an animated graphic in place of the default application icon

This enables you to replace the default icon (your application icon) that is being displayed in the splash screen with an asset of your choice. If using an animated asset then it’s important to be sure that this does not extend the lifetime of the splash screen (1,000 milliseconds). While the approach here will depend on the kind of animation you are using, there are some general guidelines that come to mind here:

* If using an animation that animates a single time from a start to end state, ensure that the animations ends shortly before the 1,000 millisecond time limit.

* If using an infinitely looping animation, be sure that the animation does not appear to be cut-off once the 1,000 millisecond time limit is hit. For example, an infinitely spinning item being cut-off at the time limit will not appear “janky”, but cutting off the morphing between two shapes could make the transition between the splash screen and your app feel not so smooth.

Once we have an asset that we wish to use for the icon of our splash screen, we can apply it:

```xml
<item name="android:windowSplashScreenAnimatedIcon">@drawable/ic_launcher_foreground</item>
```

![](https://joebirch.co/wp-content/uploads/2021/05/icon-485x1024.png)

As displayed above, our icon asset will displayed in the center of the splash screen. Using this will completely remove any of the default properties and styling from what was previously being shown in our splash screen.

## Setting the Icon Background Color

As we saw above, providing a custom icon allows us to change the default icon that is displayed within our splash screen. However, we can also see above that this might not always render in the best results. The icon I used there does not have a background layer, so it’s a bit tricky to see the icon against the background color being used for the splash screen. While we can customise the background color of the splash screen, we might not want to or be in a position to change this here. In these cases we can utilise the **android:windowSplashScreenIconBackgroundColor** attribute to provide a color to be used for the background of our icon.

```xml
<item name="android:windowSplashScreenIconBackgroundColor">@color/black</item>
```

![](https://joebirch.co/wp-content/uploads/2021/05/icon_background-485x1024.png)

When this is applied, we’ll see a shaped background applied to our icon, using the color that we defined in the attribute above. It’s been difficult to test this, but in the case of my device this matches the app icon shape that I have set in my system settings. Currently this is not something that you can override for the splash screen. If you need customisation here, the best approach would be to create a drawable that already has a background layer as a part of the asset.

## Setting a Branding Image

The branding image is an **optional** static asset which can be used to display an image at the base of the Splash Screen. This branding image will be displayed for the entire time that the splash screen is presented on screen.

```xml
<item name="android:windowSplashScreenBrandingImage">@drawable/logo_text</item>
```

![](https://joebirch.co/wp-content/uploads/2021/05/brand-561x1024.png)

While the design guidelines state that it is not recommended not to use a branding image within the Splash Screen, this functionality has been provided should you need to present this visual component. Personally I think this adds a nice touch to the splash screen, but realistically in most cases the splash screen will not be displayed long enough for the user to take in all of the content within the screen. If you are not doing any customisation to override the exit time of the splash screen, the splash screen is going to be displayed for about **1 second**. When the splash screen is launched, the user is naturally going to be drawn to the icon that is displayed in the center of the screen – any additional content on the screen is likely going to overwhelm the user and in most cases, probably not going to be seen. With that said, it’s important to think about whether your app really needs to utilise this branding asset within its splash screen.

## Customising the Splash Screen time

By default, the Splash Screen will display for ~**1,000 milliseconds** – until the first frame of our application is drawn. However, a lot of applications use their splash screen to initialise default application data or perform asynchronous tasks to configure the app. In these cases, we can prevent the first frame of our app being drawn so that our splash screen remains in view. We can achieve this by using the **ViewTreeObserver** **OnPreDrawListener** – returning false until we are ready to proceed past the splash screen. Returning false here will prevent our

```kotlin
val content: View = findViewById(android.R.id.content)
content.viewTreeObserver.addOnPreDrawListener(
    object : ViewTreeObserver.OnPreDrawListener {
        override fun onPreDraw(): Boolean {
            return if (isAppReady) {
                content.viewTreeObserver.removeOnPreDrawListener(this)
                true
            } else {
                false
            }
        }
    }
)
```

## Accessing the Splash Screen

The Activity class has a new getSplashScreen function that can be used to access the splash screen for your activity. As mentioned previously, the splash screen will only be shown for the launcher activity of your application – so accessing this elsewhere does not have any effect.

You can view a full example of this in the [official documentation](https://developer.android.com/about/versions/12/features/splash-screen#customize-animation), but currently the splashScreen only provides programatic access for applying a listener to the exist animation of the splash screen. This means you can listen for when the splash screen is animating to the content of your app, allowing you to customise this transition.

```kotlin
splashScreen.setOnExitAnimationListener { splashScreenView ->
    ...          
}
```

## Wrapping Up

After learning about the Splash Screen APIs, I can now ensure that the [Compose Academy](https://compose.academy/) app will be handling things properly. In most cases you may not even need to change anything, with your users enjoying a smooth launch flow of your app out-of-the-box.

In future there may be further additions to what applications can customise for the splash screen – having these APIs now means that there is a platform for opening up these things to developers. However, it’s impossible to create a one-size-fits-all implementation and I feel like Google will still want to enforce some kind of standard for splash screens (and not give developers free rein). Regardless, I’m looking forward to seeing how developers utilise these new APIs 😃

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
