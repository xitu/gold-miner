> * 原文地址：[Exploring Android 12: Splash Screen](https://joebirch.co/android/exploring-android-12-splash-screen/)
> * 原文作者：[Joe Birch](https://joebirch.co/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/exploring-android-12-splash-screen.md](https://github.com/xitu/gold-miner/blob/master/article/2021/exploring-android-12-splash-screen.md)
> * 译者：[Kimhooo](https://github.com/Kimhooo)
> * 校对者：[samyu2000](https://github.com/samyu2000),[PassionPenguin](https://github.com/PassionPenguin)

# 探索 ANDROID 12：启动画面

![](https://joebirch.co/wp-content/uploads/2021/05/header-1-1024x538.png)

随着 Android 12 测试版的发布，我们现在可以了解最新版 Android 提供的新功能。在这些新功能中，我注意到此版本引入了 Splash Screen API —— 它不仅提供了一种应用程序呈现启动画面的标准化方式，而且还改善了启动应用程序时的用户体验。我正在准备发布 [Compose Academy](https://compose.academy/) 应用程序，同时确保一切功能在 Android 12 API 中正常运行 —— 所以这是了解启动画面相关 API 的绝佳机会。

您可能觉得你已经看过许多很棒的应用程序启动画面！但尽管如此，很多时候，我们仍然需要创建自己的启动画面类。这样的启动画面只能用于显示产品的品牌，或处理稍微复杂一些的功能，例如在用户进入应用程序之前执行应用程序初始化和获取数据。还有一些情况需要考虑，应用程序甚至没有设置某种形式的启动画面 —— 用户可能是通过冷启动或热启动方式开启应用程序的，因此用户体验就不太流畅。举个例子，让我们看看如果您不设置某种启动画面，应用程序启动时候的样子：

![](https://joebirch.co/wp-content/uploads/2021/05/ezgif-3-8750c93b9fd1.gif)

就个人而言，用户体验不太好！当我等待应用程序启动时，屏幕画面是空白的，没有任何品牌图片 —— 这不是将用户带入我们的应用程序的最佳体验。

很多应用程序使用了主题中的 **android:windowBackground** 属性，设置程序打开时在此空白空间内显示的内容。然而，这并不是官方支持的做法，而是为了避免显示空白画面所采取的措施。

![](https://joebirch.co/wp-content/uploads/2021/05/ezgif-3-ec15080396ca.gif)

现在，虽然这并不能顺利过渡到我们的应用程序，但这绝对比以前看起来更好！这里唯一需要注意的是，因为这只是将一些主题应用到窗口的背景，启动时间将保持不变 —— 所以如果我们正在做某种应用程序设置，我们仍然需要添加一些其他更改以支持这些要求。

在 Android API 26 中，我们看到了 **android:windowSplashScreenContent** 属性的引入。这一属性可用于将某些内容设置为启动画面。虽然者还是无法满足在这段时间内可能需要处理应用程序初始化的需求，但无疑它提供了更流畅的启动画面显示和应用程序的入口。

![](https://joebirch.co/wp-content/uploads/2021/05/ezgif-3-f08bf585309b.gif)

现在来到 Android 12，我们有了新的启动画面 API。在不使用这些 API 提供的任何进一步自定义的情况下，我们可以看到，除了这次开箱即用之外，用户体验仍然跟使用 API 26 中新增的属性的情况相似：

![](https://joebirch.co/wp-content/uploads/2021/05/ezgif-3-21fac4a28a5e.gif)

虽然这看起来与我们在 API 26 中看到的属性没有太大区别，但在 Android 12 中，我们可以访问更多属性，也允许深度定制启动画面。这些属性允许我们使用早期版本无法实现的方式自定义启动画面。

![](https://joebirch.co/wp-content/uploads/2021/05/Group-1-1024x733.png)

在接下来的部分中，我们来看看如何使用这些属性对应用程序的启动画面进行个性化定制。

## 显示启动画面

虽然在以前的 API 版本中，我们需要提供某种形式的资源作为主题属性以用于我们的窗口内容或启动画面内容，但在 Android 12 中我们 **不再需要这样做**。因此，了解这一 API 很重要。**默认情况**下，您的启动器 Activity 将显示这个新的启动画面 —— 因此，如果您当前在应用程序中显示自定义启动画面，则需要适应 Android 12 中的这些更改。

虽然启动画面 API 提供了一组可用于微调启动画面外观的属性，但如果您不设置这些属性的值，则将使用应用程序中的默认值和资源。例如，以下是在运行 Android 12 的设备上启动我的应用时显示的默认启动画面：

![](https://joebirch.co/wp-content/uploads/2021/05/Screenshot_20210527_061703-485x1024.png)

当涉及到启动画面的显示时，我们可以看到一些情况 —— 应用程序的图标显示在背景颜色的顶部。在我的应用程序中，我使用了一个自适应图标，看起来好像启动画面直接使用了该自适应图标的 xml 引用，在屏幕上显示了相应图标。我知道这一点是因为当我更改启动图标的背景层颜色时，这反映在我的启动画面中。

## 设置背景颜色

正如我们在上面看到的，启动画面将使用默认的背景颜色*。在某些情况下，我们可能想要覆盖它 —— 也许是为了与品牌颜色相匹配，或者当应用程序图标显示在默认背景颜色之上时，整体画面就难看了，需要避免这种情况。在任何一种情况下，您都可以利用 **windowSplashScreenBackground** 属性来覆盖此默认颜色。

```xml
<item name="android:windowSplashScreenBackground">#000000</item>
```

![](https://joebirch.co/wp-content/uploads/2021/05/Screenshot_20210527_061650-485x1024.png)

> 我还不完全确定此背景颜色使用的是什么颜色，一旦确定了，我会更新这篇文章！

## 设置启动图标

在某些情况下，您可能不想将应用程序图标用于初始屏幕中显示的图标。如果您想显示其他内容来代替此内容，则可以使用 **android:windowSplashScreenAnimedIcon** 属性来执行此操作。我觉得这个名字有点误导，因为这个图标实际上可以是对两件事之一的引用：

* **静态矢量可绘制参考** – 用于显示静态资源，代替默认应用程序图标

* **动画矢量可绘制** – 用于显示动画图形代替默认应用程序图标

这使您能够用相关资源替换初始屏幕中显示的默认图标（您的应用程序图标）。如果使用动画资源，需要确保启动画面的持续时间不超过 1000 毫秒。虽然这里的方法取决于你使用的动画类型，但是应当记住以下这些通用的注意事项：

* 如果使用的动画是从开始到结束只有一个动作的，应当确保动画持续时间不超过 1,000 毫秒。

* 如果使用无限循环动画，请确保一旦达到 1,000 毫秒的时间限制，动画不会出现中断。例如，无限旋转的 item 在时间限制时被切断不会 “表现得很糟糕”，但切断两个形状之间的变形可能会使启动画面和您的应用程序之间的过渡感觉不那么平滑。

一旦我们有了希望用于初始屏幕图标的资产，我们就可以应用它：

```xml
<item name="android:windowSplashScreenAnimatedIcon">@drawable/ic_launcher_foreground</item>
```

![](https://joebirch.co/wp-content/uploads/2021/05/icon-485x1024.png)

如上所示，我们的图标资产将显示在启动画面的中心。使用它会从之前在我们的启动画面中显示的内容中完全删除任何默认属性和样式。

## 设置图标背景颜色

正如我们在上面看到的，提供自定义图标允许我们更改初始屏幕中显示的默认图标。但是，我们也可以在上面看到，这可能并不总是呈现最佳结果。我在那里使用的图标没有背景层，因此在用于初始屏幕的背景颜色上看到图标有点棘手。虽然我们可以自定义启动画面的背景颜色，但我们可能不想或无法在此处更改此设置。在这些情况下，我们可以利用 **android:windowSplashScreenIconBackgroundColor** 属性来提供用于图标背景的颜色。

```xml
<item name="android:windowSplashScreenIconBackgroundColor">@color/black</item>
```

![](https://joebirch.co/wp-content/uploads/2021/05/icon_background-485x1024.png)

应用此选项后，我们将看到一个形状背景应用于我们的图标，使用我们在上面的属性中定义的颜色。很难对此进行测试，但就我的设备而言，这与我在系统设置中设置的应用程序图标形状相匹配。目前，这不是您可以为初始屏幕覆盖的内容。如果您需要在此处进行自定义，最好的方法是创建一个已将背景图层作为资产一部分的可绘制对象。

## 设置品牌形象

品牌形象是一个**可选的**静态图片资源，可以把它呈现于启动画面底部。它会在启动画面显示于屏幕上的这段时间内同时显示。

```xml
<item name="android:windowSplashScreenBrandingImage">@drawable/logo_text</item>
```

![](https://joebirch.co/wp-content/uploads/2021/05/brand-561x1024.png)

虽然设计指南指出不建议在启动画面中使用品牌图像，但如果您需要展示此视觉组件，则已提供此功能。就我个人而言，我认为这为启动画面增加了一个很好的触感，但实际上在大多数情况下，启动画面不会显示足够长的时间让用户接收屏幕内的所有内容。如果您没有进行任何自定义以覆盖闪屏的退出时间，则闪屏将显示大约 **1 秒**。当启动画面启动时，用户自然会被显示在屏幕中央的图标所吸引 —— 屏幕上的任何额外内容都可能会让用户不知所措，而且在大多数情况下，可能不会可见。话虽如此，重要的是要考虑您的应用程序是否真的需要在其启动画面中利用此品牌资产。

## 自定义启动画面时间

默认情况下，启动画面将显示约 **1,000 毫秒** —— 直到绘制我们应用程序的第一帧。但是，许多应用程序使用它们的启动画面来初始化默认应用程序数据或执行异步任务来配置应用程序。在这些情况下，我们可以阻止绘制应用程序的第一帧，以便我们的启动画面保持在视图中。我们可以通过使用 **ViewTreeObserver OnPreDrawListener** 来实现这一点 —— 在我们准备好通过启动画面之前返回 false。在这里返回 false 将会阻止我们。

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

## 访问启动画面

Activity 类有一个新的 getSplashScreen 函数，可用于访问活动的初始屏幕。如前所述，启动画面只会为您的应用程序的启动器活动显示 —— 因此在其他地方访问它不会产生任何影响。

您可以在 [官方文档](https://developer.android.com/about/versions/12/features/splash-screen#customize-animation) 中查看完整示例，但目前 splashScreen 仅提供用于将侦听器应用于初始屏幕的现有动画的编程访问。这意味着您可以监听启动画面何时为您的应用程序内容设置动画，从而允许您自定义此过渡。

```kotlin
splashScreen.setOnExitAnimationListener { splashScreenView ->
    ...          
}
```

## 总结

在了解了启动画面 API 之后，我现在就完全可以确保 [Compose Academy](https://compose.academy/) 应用程序能够正确工作了。在大多数情况下，您可能不需要作过多修改，开箱即用地就可以令应用程序的启动变得流畅。

未来可能会有更多应用程序可以为启动画面自定义 —— 现在拥有这些 API 意味着有一个平台可以向开发人员开放这些东西。然而，创建一个通用的实现是不可能的，我觉得谷歌仍然希望为启动画面强制执行某种标准（而不是让开发人员自由发挥）。无论如何，我很期待看到开发人员会如何应用这些新的 API 😃

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
