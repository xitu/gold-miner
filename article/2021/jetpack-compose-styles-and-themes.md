> * 原文地址：[Jetpack Compose: Styles and Themes (Part II)](https://www.waseefakhtar.com/android/jetpack-compose-styles-and-themes/)
> * 原文作者：[Waseef Akhtar](https://www.waseefakhtar.com/author/waseefakhtar/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/jetpack-compose-styles-and-themes.md](https://github.com/xitu/gold-miner/blob/master/article/2021/jetpack-compose-styles-and-themes.md)
> * 译者：
> * 校对者：

# Jetpack Compose：样式和主题（第二部分）

![Jetpack Compose：样式和主题（第二部分）](https://www.waseefakhtar.com/content/images/size/w2000/2021/05/Jetpack-Compose-highres-5-3.jpg)

截至[上一篇文章](https://github.com/xitu/gold-miner/blob/master/article/2021/recyclerview-in-jetpack-compose.md), 我们成功地实现了一个 RecyclerView（在 Compose 中称为 LazyColumn），并且在里面填充了一个供收养的小狗列表。 🐶

但是正如我之前提到的，在我们称它为完整的 Composite 应用之前，我们还有一些事情要做。现在剩下的两件事是：

1. 根据我们的最终外观设计应用程序。
2. 实现详情页面。

在本系列的这一部分中，我们将介绍如何使用 Compose 中的样式和主题，选择在上一篇文章中我们实现的应用程序，并给出我们想要实现的最终外观：

![](https://www.waseefakhtar.com/content/images/2021/05/1.gif)

为了了解我们需要从何处继续，我们首先来看上一篇文章的最后成果：

![](https://www.waseefakhtar.com/content/images/2021/05/device-2021-05-15-151508.png)

我们想要看的是：

1. 使用 `Color.kt` 和 `Theme.kt` 改变整个应用程序的颜色。
2. 看看在 Compose 中暗黑/光亮模式分别是如何工作的。
3. 修复状态栏和系统导航栏，以适应我们的应用程序的主题。

让我们开始吧！

## 启用暗黑模式 💡

正如你在最终成果页面上看到的，我们的应用程序看起来像是启用了暗黑模式。如果这是我们想要的最终外观（或者如果我们想要一个支持黑暗模式的应用程序），那么我们的项目最初是如何由 Android Studio 模板设置的就非常简单了。让我们再探讨一下，理解我们的意思。

如果打开项目的目录，你可以看到项目中已经有了 `/ui/theme` 目录，在这个目录中，有几个 Kotlin 类，包括：Color、Shape、theme、Type。

![](https://www.waseefakhtar.com/content/images/2021/05/Screen-Shot-2021-05-15-at-5.20.50-PM.png)

这些都是您需要修改应用程序主题和样式的类。

因为在我们的情况下，我们需要为应用程序启用暗模式，请执行以下操作：

1. 打开 `Theme.kt` 类。

2. 在 `BarkTheme` composable 中，将 `isSystemInDarkTheme()` 的暗主题默认值设置为 `true`。

```kt
@Composable
fun BarkTheme(darkTheme: Boolean = true, content: @Composable() () -> Unit) {
    val colors = if (darkTheme) {
        DarkColorPalette
    } else {
        LightColorPalette
    }

    MaterialTheme(
        colors = colors,
        typography = Typography,
        shapes = Shapes,
        content = content
    )
}
```

3. 运行应用程序以查看更改。

![](https://www.waseefakhtar.com/content/images/2021/05/device-2021-05-15-181342.png)

我们可以看到我们的背景已经改变了…… 除此之外，我们的文字颜色也发生了改变，但小狗卡片的颜色没有改变。

让我们快速解决这个问题：

1. 打开 `Color.kt` 类。

2. 新建一个名为 `graySurface` 的颜色。

```kt
val graySurface = Color(0xFF202124)
```

3. 现在打开 `Theme.kt` 类。

4. 在 `DarkColorPalette` 变量中，为 `DarkColorPalette` 添加新的颜色定义，并将其值设置为在步骤 2 中设置的 `graySurface` 的颜色。

> 注：也许您还想知道 `surface` 是什么，它是由材质设计的颜色系统提供的颜色定义，影响组件的表面，如卡片、图纸和菜单：

![](https://www.waseefakhtar.com/content/images/2021/05/Screen-Shot-2021-05-15-at-6.27.30-PM.png)

5. 最后，如果您一直按部就班地学习教程，您可能还记得，在上一篇文章中实现时，我们硬编码了卡片的颜色，这并不是一种很好的方法。为了让 `Color.kt` 中的应用程序颜色值在整个应用程序中保持一致，最好使用 `Color.kt` 更改 UI 元素的颜色值，而不是单独更改每个 UI 元素的颜色。

因此，在这一步，我们删除小狗卡片的硬编码颜色，以便卡显示我们刚刚设置的真正的 `surface` 的颜色。

1. 打开 `PuppyListItem.kt` 类。
2. 在 `PuppyListItem` composable函数中，从卡片 composable 中删除此参数：`backgroundColor value: backgroundColor = Color.White`

运行应用程序以查看更改。

![](https://www.waseefakhtar.com/content/images/2021/05/device-2021-05-15-194054.png)

顶呱呱的！我们已经做了所有我们需要做的事情。

但是…… 

你有没有发现顶部状态栏的颜色有点奇怪吗？还有底部的系统导航栏呢？如果我们把它们调整好搭配我们的主题，那就太酷了。

但这里有个陷阱。由于 Jetpack Compose 库还很稚嫩，所以它目前还存在一些局限性（我甚至不确定是否存在这种特殊的局限性）。因此，为了修复状态栏和导航栏，我们将使用我们亲爱的'olxml。

## The Final Fixes 👨‍🎨

In order to change the status bar color to match our theme:

1. Open `colors.xml` under `/res`.

2. Add the same gray color we added to our `Color.kt`.

```xml
<color name="grey">#202124</color>
```

3. Open `themes.xml`.

> Note: You might notice that you have two `themes.xml` in themes directory. Make it a good practice from now onwards to change the values in both these files whenever you're making a change because these two files refer to the dark mode and light mode theme of the app.

4. Define the `statusBarBackground` attribute inside `Theme.Bark` and set its value to our gray color.

5. Now add this `statusBarBackground` attribute as our value for `android:statusBarColor`.

```xml
<!-- Status bar color. -->
<item name="statusBarBackground">@color/grey</item>
<item name="android:statusBarColor" tools:targetApi="l">?attr/statusBarBackground</item>
```

Now in order to change the system navigation bar's color:

1. Open `themes.xml`.
2. Add another item for `navigationBarColor` and set its value to `?android:attr/windowBackground` attribute (which is a color value that changes automatically with system preferences)

```xml
<item name="android:navigationBarColor">?android:attr/windowBackground</item>
```

Run the app now to see the changes.

![](https://www.waseefakhtar.com/content/images/2021/05/device-2021-05-15-201902.png)

And.. there you go! Thats our final look of the app! 😍

Give yourself a pat on the back at this point for having now learnt how theming and styling are done in Compose. 👏

Happy coding! 💻

[**Source code for the Final Version**](https://github.com/waseefakhtar/bark) 

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
