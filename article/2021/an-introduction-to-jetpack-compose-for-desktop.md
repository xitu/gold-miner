> * 原文地址：[An Introduction to JetPack Compose for Desktop](https://betterprogramming.pub/an-introduction-to-jetpack-compose-for-desktop-5c3bf8629dc5)
> * 原文作者：[Siva Ganesh Kantamani](https://medium.com/@sgkantamani)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/an-introduction-to-jetpack-compose-for-desktop.md](https://github.com/xitu/gold-miner/blob/master/article/2021/an-introduction-to-jetpack-compose-for-desktop.md)
> * 译者：
> * 校对者：

# An Introduction to JetPack Compose for Desktop

![Photo by the author.](https://cdn-images-1.medium.com/max/2738/1*3wOqMMXsvUfkDTWXUri_EQ.png)

Until now, we’ve only seen [Jetpack Compose](https://developer.android.com/jetpack/compose) in Android development. Today, we’re entering a new phase, as JetBrains announced an early-access version of IntelliJ that allows you to use Jetpack Compose to build Windows applications.

This is the first of many articles I will write in the coming days explaining how to use Jetpack Compose for desktop. Last month, JetBrains released Compose for desktop Milestone 2, which brings a better development experience and interoperability.

As always, JetBrains is trying to ease developers’ lives by providing exclusive project wizards. In the early-access version of IntelliJ, they added a desktop project wizard to configure the project within seconds.

To start with the development first, you need to install [IntelliJ IDEA 2020.3](https://www.jetbrains.com/idea/whatsnew/#section=mac).

## Quick Start With the Project Template

As I said earlier, one of the best things about IntelliJ is project templates. After installing the IDE, launch the application. You’ll see the following window:

![](https://cdn-images-1.medium.com/max/2498/1*x-OrVhcmjnr0FKOlNHjNoQ.png)

Then click the “New Project” button in the top bar, which will take you to the window to select the type of application. Have a look at the “New Project” window:

![](https://cdn-images-1.medium.com/max/2944/1*M2u_N3K-1DY9Q3WaYBnB0w.png)

First, we need to select Kotlin from the left-side menu. Then update the project name and location. After that, we need to select the project template. This is an important part of configuring the appropriate project. We need to pick the desktop template from the list of project templates, which you’ll find as you scroll down. Then you need to select the project JDK. I would suggest going with JDK 11.

![](https://cdn-images-1.medium.com/max/2944/1*XyyhciTuFLCVhk_hF10xCw.png)

Then click the “Next” button, which will bring you to the confirmation window with the Compose module. Now click the “Finish” button, and IntelliJ will set up the project for you by automatically downloading the appropriate gradle.

## Run Your First Desktop Application

If everything goes as expected, the desktop project setup will be successful and you’ll see the following setup:

![](https://cdn-images-1.medium.com/max/3840/1*iU2it0DXYOt0qxJQB1VgBQ.png)

At this point, you can run the application. For some reason, `Main.kt` is not selected by default in the top right corner beside the “Run” button, so it’ll ask you to configure the project. To resolve this, you need to hit the green “Run” button beside the main function inside the `Main.kt` file.

After the successful run, you’ll see the following output with a button containing a “Hello, World!” text. If you click on it, the text inside the button changes to “Hello, Desktop!” Have a look:

![](https://cdn-images-1.medium.com/max/2002/1*AMNYP559WHhfKFvpGrmN4g.gif)

## Explore the Code

As you can see, it’s a simple Hello World program — nothing complicated. Most of the code is similar to the Jetpack Compose UI for Android applications.

`Main.kt` is the Kotlin file that contains the code related to output. It has the main function, which is the entry point for the application to run. The code starts with the `Window` function to open a window with the given content. It takes several parameters to initially configure the window properties, such as `title`, `size`, `location`, `centered`, `content`, etc.

```kt
fun main() = Window {
}
```

In this case, we’ll only pass the value to the content parameter and leave the rest of the parameters with default values. In the next step, we’ve declared a `text` variable with `remember` capability and the initial value of `Hello, World!`. Have a look:

```kt
fun main() = Window {
    var text by remember { mutableStateOf("Hello, World!") }
}
```

In a declarative UI system, the code itself describes the UI. We need to describe the UI at any point in time — not just the initial time. We use `remember` as a state for the text to be displayed in the views like buttons, text fields, and more. When we update this `text` variable in the future, the views associated with this variable will also update the display text.

To understand it better, I would suggest going through the following article:

[**Jetpack Compose Components (Part 2)](https://medium.com/better-programming/jetpack-compose-components-part-2-2b3eb135d294)

The next part of the code is to define a button with the click functionality and apply the material theme to the window. Have a look:

```Kotlin
fun main() = Window {
    var text by remember { mutableStateOf("Hello, World!") }

    MaterialTheme {
        Button(onClick = {
            text = "Hello, Desktop!"
        }) {
            Text(text)
        }
    }
}
```

## Conclusion

Jetpack Compose is at a very early stage for both desktop and Android, but it still shows tremendous progress for building UI. A framework like Jetpack Compose with Kotlin’s powerful features will improve developers’ productivity and provide a way for them to work on different platforms.

Developers like [Gurupreet Singh](https://twitter.com/_gurupreet) are very active with Compose releases and are creating valuable resources (such as [ComposeCookBook](https://github.com/Gurupreet/ComposeCookBook)) to help fellow developers. He also created [the Spotify desktop clone](https://github.com/Gurupreet/ComposeSpotifyDesktop) from the Compose Android app, which inspired me a lot.

## Bonus

If you’re new to Jetpack Compose, start here:

* [“Jetpack Compose — A New and Simple Way to Create Material-UI in Android”](https://medium.com/better-programming/jetpack-compose-a-new-and-simple-way-to-create-material-ui-in-android-f49c6fcb448b)
* [“JetPack Compose With Server Driven UI”](https://medium.com/android-dev-hacks/jetpack-compose-with-server-driven-ui-396a19f0a661)
* [“Jetpack Compose: How to Build a Messaging App”](https://medium.com/better-programming/jetpack-compose-how-to-build-a-messaging-app-e2cdc828c00f)

That is all for now. I hope you learned something useful. Thanks for reading.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
