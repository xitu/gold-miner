> - 原文地址：[An Introduction to JetPack Compose for Desktop](https://betterprogramming.pub/an-introduction-to-jetpack-compose-for-desktop-5c3bf8629dc5)
> - 原文作者：[Siva Ganesh Kantamani](https://medium.com/@sgkantamani)
> - 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> - 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/an-introduction-to-jetpack-compose-for-desktop.md](https://github.com/xitu/gold-miner/blob/master/article/2021/an-introduction-to-jetpack-compose-for-desktop.md)
> - 译者：[YueYongDev](https://github.com/YueYongDev)
> - 校对者：[Hoarfroster]([PassionPenguin (Hoarfroster) (github.com)](https://github.com/PassionPenguin))

# JetPack Compose for Desktop 初体验

![图源作者](https://cdn-images-1.medium.com/max/2738/1*3wOqMMXsvUfkDTWXUri_EQ.png)

目前为止，我们只在 Android 开发中看到 [Jetpack Compose](https://developer.android.com/jetpack/compose)。今天，我们将进入一个崭新的阶段，因为 JetBrains 宣布了 IntelliJ 的早期访问版本，允许你使用 Jetpack Compose 来构建 Windows 应用程序。

关于如何使用 Jetpack Compose for desktop，我计划在未来写一些文章加以阐述，本文是这个系列的第一篇文章。上个月，JetBrains 发布了 Compose for desktop Milestone 2，为开发者们带来了更好的开发体验和可操作性。

和往常一样，JetBrains 在继续尝试通过提供独家项目引导来简化开发者的开发流程。在 Compose for desktop 的早期版本中，他们为 IntelliJ 增加了一个桌面项目引导，可以让我们在几秒内配置好项目。

在开始开发之前，你需要安装 [IntelliJ IDEA](https://www.jetbrains.com/idea/whatsnew/#section=mac) 2020.3 或更高版本。

## 使用项目模版快速开始

正如我前面所说，项目模板是 IntelliJ 最好用的东西之一。安装完 IDE 后，启动应用程序。你会看到如下的界面：

![](https://cdn-images-1.medium.com/max/2498/1*x-OrVhcmjnr0FKOlNHjNoQ.png)

然后点击顶部栏的 "New Project "按钮，这一操作将会跳转至选择应用程序类型的界面。如下所示：

![](https://cdn-images-1.medium.com/max/2944/1*M2u_N3K-1DY9Q3WaYBnB0w.png)

首先，我们需要从左侧菜单中选择 Kotlin，然后修改项目名称和位置。之后，我们需要选择项目模板。这是配置项目的一个重要步骤。我们需要从项目模板列表中挑选桌面模板，向下滚动就能找到。然后你需要选择项目的 JDK，这里我建议使用 JDK 11。

![](https://cdn-images-1.medium.com/max/2944/1*XyyhciTuFLCVhk_hF10xCw.png)

然后点击“Next”按钮，这将会跳转至确认 Compose 模块的界面。现在点击“Finish”按钮，IntelliJ 将通过自动下载适当的 gradle 为你配置整个项目。

## 运行你的第一个桌面应用

如果进展顺利，整个桌面项目加载完成后你将会看到以下界面：

![](https://cdn-images-1.medium.com/max/3840/1*iU2it0DXYOt0qxJQB1VgBQ.png)

此时，你可以运行该应用程序了。由于某些原因，`Main.kt` 在右上角的“运行”按钮旁边没有被默认选中，所以它会要求你配置项目。为了解决这个问题，你需要在 `Main.kt` 文件内的主函数旁边点击绿色的“运行”按钮。

运行成功后，你会看到下面的输出结果，有一个包含“Hello, World!”文字的按钮。如果你点击它，按钮里面的文字就会变成“Hello, Desktop!”，来看一下实际体验的效果吧。

![](https://cdn-images-1.medium.com/max/2002/1*AMNYP559WHhfKFvpGrmN4g.gif)

## 探究代码

正如你看到的，这是一个简单的 Hello World 程序 —— 一点也不复杂。大部分的代码与 Android 里面的 Jetpack Compose UI 相似。

`Main.kt` 是包含与输出有关的代码 Kotlin 文件。它有一个主函数作为应用程序运行的入口。代码从 `Window` 函数开始，用给定的内容打开一个窗口。它需要几个参数来初步配置窗口的属性，如 `title`、`size`、`location`、`centered`、`content` 等。

```kt
fun main() = Window {
}
```

在这种情况下，我们只需要把值传给内容参数，其余的参数保留默认值即可。在接下来的代码中，我们声明了一个具有 `remember` 功能的 `text` 变量，其初始值为 `Hello, World!`。如下所示：

```kt
fun main() = Window {
    var text by remember { mutableStateOf("Hello, World!") }
}
```

在一个声明式的 UI 系统中，代码本身就描述了 UI。我们需要描述任何时间点上的 UI —— 不仅仅是初始时间。在诸如按钮、文本字段等 UI 组件中，我们使用 `remember` 作为文本的状态，这样当我们在未来更新这个 `text` 变量时，与该变量相关的视图也会更新显示文本。

为了更好地理解它，我建议阅读以下文章。

[Jetpack Compose Components (Part 2)](https://medium.com/better-programming/jetpack-compose-components-part-2-2b3eb135d294)

下一段代码是定义一个具有点击功能的按钮，并将整个应用窗口设置为 Material 主题。如下所示：

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

## 总结

目前，Jetpack Compose 在桌面和安卓上都处于非常早期的阶段，但它仍然展现出为构建 UI 所作出的巨大进步。像 Jetpack Compose 这样的框架配合上 Kotlin 的强大功能将提高开发者的开发效率，并为他们提供在不同平台上工作的方法。

像 [Gurupreet Singh](https://twitter.com/_gurupreet) 这样的开发者非常积极地参与 Compose 的发布，并创造了宝贵的资源（如 [ComposeCookBook](https://github.com/Gurupreet/ComposeCookBook)）来帮助其他开发者。他还从 Compose Android 应用中创建了 [the Spotify desktop clone](https://github.com/Gurupreet/ComposeSpotifyDesktop)，这给了我很大的启发。

## 捐赠

如果你刚入门 Jetpack Compose ，可以从这里开始。

- [“Jetpack Compose — A New and Simple Way to Create Material-UI in Android”](https://medium.com/better-programming/jetpack-compose-a-new-and-simple-way-to-create-material-ui-in-android-f49c6fcb448b)
- [“JetPack Compose With Server Driven UI”](https://medium.com/android-dev-hacks/jetpack-compose-with-server-driven-ui-396a19f0a661)
- [“Jetpack Compose: How to Build a Messaging App”](https://medium.com/better-programming/jetpack-compose-how-to-build-a-messaging-app-e2cdc828c00f)

以上就是本文的全部内容了，希望本文能对你有所帮助，感谢你的阅读。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
