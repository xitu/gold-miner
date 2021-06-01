> * 原文地址：[Jetpack Compose: Styles and Themes (Part II)](https://www.waseefakhtar.com/android/jetpack-compose-styles-and-themes/)
> * 原文作者：[Waseef Akhtar](https://www.waseefakhtar.com/author/waseefakhtar/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/jetpack-compose-styles-and-themes.md](https://github.com/xitu/gold-miner/blob/master/article/2021/jetpack-compose-styles-and-themes.md)
> * 译者：
> * 校对者：

# Jetpack Compose: Styles and Themes (Part II)

![Jetpack Compose: Styles and Themes (Part II)](https://www.waseefakhtar.com/content/images/size/w2000/2021/05/Jetpack-Compose-highres-5-3.jpg)

As of [Part I](https://github.com/xitu/gold-miner/blob/master/article/2021/recyclerview-in-jetpack-compose.md), we successfully implemented a RecyclerView (known as LazyColumn in Compose), populating it with a list of puppies that we have for adoption. 🐶

But as I mentioned, we still have some things to do before we call it a complete Compose app. The two things left now are:

1. To style the app to our final look.
2. To implement a detailed view screen.

In this part of the series, we'll look at how styles and themes work in Compose, taking our app from Part I and giving it the final look that we want to achieve:

![](https://www.waseefakhtar.com/content/images/2021/05/1.gif)

To look at where we need to continue from, let's first look at the final screen from Part I:

![](https://www.waseefakhtar.com/content/images/2021/05/device-2021-05-15-151508.png)

The things we're going to look at:

1. Change color throughout the app using `Color.kt` and `Theme.kt`.
2. Look at how dark/light mode works in Compose.
3. Fix status bar and system navigation bar to adapt to our app's theme.

Let's get started!

## Enabling Dark Mode 💡

As you can see in our final screen, our app looks like it has dark mode enabled. If that's the final look we want (or if we want an app that has support for Dark mode), it's super easy with how our project is set up initially by the Android Studio template. Let's explore a bit more to see what we mean.

If you open you project directory, you can see that you already have `/ui/theme` directory and inside that, you have a few Kotlin classes: Color, Shape, Theme, Type.

![](https://www.waseefakhtar.com/content/images/2021/05/Screen-Shot-2021-05-15-at-5.20.50-PM.png)

These are all the classes that you need to modify the theme and styling of your app.

Since in our case, we need to enable dark mode for our app, do the following:

1. Open `Theme.kt`.

2. Inside `BarkTheme` composable, replace the darkTheme default value from `isSystemInDarkTheme()` to `true`.

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

3. Run the app to see the changes.

![](https://www.waseefakhtar.com/content/images/2021/05/device-2021-05-15-181342.png)

We can see that our background has changed.. but, with that, we also have our text color changed but not the puppy card color.

Let's quickly fix that:

1. Open `Color.kt`.

2. Add a new color named `graySurface`.

```kt
val graySurface = Color(0xFF202124)
```

3. Now open `Theme.kt`.

4. Inside the `DarkColorPalette` variable, add a new color definition for `surface` and set its value to the `graySurface` color that we set in #2.

> Note: In case you want to know what `surface` is, it's a color definition provided by the color system of Material Design that affect surfaces of components, such as cards, sheets, and menus:

![](https://www.waseefakhtar.com/content/images/2021/05/Screen-Shot-2021-05-15-at-6.27.30-PM.png)

5\. Finally, if you've been following the tutorial step by step, you might remember that we hardcoded our card color when we implemented it in Part I, which is not really a great way of doing it. In order to let our app color values from `Color.kt` work consistently throughout the app, it's always a better idea to change the color values of the UI elements using `Color.kt` rather than changing each UI element's color individually.

So at this step, we remove that hardcoded color from our puppy card in order for the card to show the true `surface` color we just set.

1. Open `PuppyListItem.kt`.
2. Inside `PuppyListItem` composable function, remove this parameter from the Card composable: `backgroundColor value: backgroundColor = Color.White`

Run the app now to see the changes.

![](https://www.waseefakhtar.com/content/images/2021/05/device-2021-05-15-194054.png)

Super! We've done everything we needed to do at this time.

But..

Do you see that the status bar looks a bit odd at the top with that odd color? And what about the system navigation bar at the bottom? It'd be extra cool if we fixed them to match our overall theme.

But there's a catch. Since Jetpack Compose is still early to work with, it comes with its limitation for the time being (And I'm not entirely sure if there even is this particular limitation). So to fix the status bar and navigation bar, we're going to head to our dear 'ol XML for this.

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
