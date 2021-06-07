> * 原文地址：[Jetpack Compose: An easy way to RecyclerView (Part I)](https://www.waseefakhtar.com/android/recyclerview-in-jetpack-compose/)
> * 原文作者：[Waseef Akhtar](https://www.waseefakhtar.com/author/waseefakhtar/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/recyclerview-in-jetpack-compose.md](https://github.com/xitu/gold-miner/blob/master/article/2021/recyclerview-in-jetpack-compose.md)
> * 译者：[Kimhooo](https://github.com/Kimhooo)
> * 校对者：[PingHGao](https://github.com/PingHGao)，[lsvih](https://github.com/lsvih)

# Jetpack Compose：更简便的 RecyclerView（第一部分）

![Jetpack Compose：更简便的 RecyclerView（第一部分）](https://www.waseefakhtar.com/content/images/size/w2000/2021/04/Jetpack-Compose-highres-5-1.jpg)

如果你是 Jetpack Compose 库的新手，并且像我一样在互联网上看到所有酷炫的 UI 屏幕和动画，你可能有点不知所措，但也对 Compose 中的工作方式感到好奇。

因为我和你们大多数人一样是刚开始学习 Jetpack Compose 库的新手，所以最近的 `Android Jetpack Compose 开发挑战赛` 对我来说是一个很好的学习机会，我可以使用 Jetpack Compose 库上手实操写一些 UI。因为我通过一个基础的应用程序学到了很多东西，我想我学到的东西可以写成一系列很好的博客文章来帮助你们所有人。

通过这一系列的博客文章，我们将创建一个基础的应用程序，包含展示一个收养小狗的列表，设计我们的应用程序的整体风格，并为每只小狗都实现一个详细的视图。

在这一系列文章的最后，我们的应用程序看起来是这样的：

![](https://www.waseefakhtar.com/content/images/2021/04/New--1-.gif)

所以别犹豫了，让我们马上开始吧！

## 背景 ✍️

* Jetpack Compose 库是一个新发布的 UI 工具包，通过使用 Kotlin 为 Android 应用程序构建原生 UI，它将很快取代当前使用 XML 文件构建 UI 的方法。
* 它是完全使用 Kotlin 编写的。
* 它用更少的代码和强大的工具简化了 Android上的 UI 开发。
* 了解更多信息请点击：[https://developer.android.com/jetpack/compose](https://developer.android.com/jetpack/compose)

## 前提 ☝️

由于目前稳定版的 Android Studio 还不完全支持 Jetpack Compose 库，在本教程中，我使用的版本是 [Android Studio 2020.3.1 Canary 14](https://developer.android.com/studio/preview)。但是我相信本文提供的步骤在更新和更稳定版本的 Android Studio 中都能生效，只要他们开始支持 Jetpack Compose 库。

## 项目设置 ⚙️

要开始工作，请执行以下操作：

1. 新建一个项目。
2. 选择一个 ****Empty** Compose **Activity**** 项目模板，并为你的应用程序命名。这将创建一个空的 Android 项目。

![](https://www.waseefakhtar.com/content/images/2021/04/1-10.png)

![](https://www.waseefakhtar.com/content/images/2021/04/2-9.png)

## 运行项目 🏃‍♂️

在我们开始编写第一行 Jetpack Compose 代码之前，让我们运行由 AndroidStudio 为我们设置好的当前项目。因为我们使用的是 Jetpack Compose 和 Android Studio 的不稳定/预览版本，所以很可能会遇到一些未知的问题。因此，每次更改代码后重新运行项目是一个好主意。

在我的案例中，在第一次运行项目之后，我遇到了以下情况：

```
An exception occurred applying plugin request [id: 'com.android.application']
> Failed to apply plugin 'com.android.internal.application'.
   > com.android.builder.errors.EvalIssueException: The option 'android.enableBuildCache' is deprecated.
     The current default is 'false'.
     It was removed in version 7.0 of the Android Gradle plugin.
     The Android-specific build caches were superseded by the Gradle build cache (https://docs.gradle.org/current/userguide/build_cache.html).

* Try:
Run with --stacktrace option to get the stack trace. Run with --info or --debug option to get more log output. Run with --scan to get full insights.
```

为了解决这个问题：

1. 打开 `gradle.properties` 文件。
2. 删除 `android.enableBuildCache=true` 这一行。

再次运行项目时，您应该会看到 Android Studio 为我们构建的示例 Compose 应用程序。

![](https://www.waseefakhtar.com/content/images/2021/04/3-9.png)

成功运行之后，我们准备开始上手实操了!

## 编写我们的第一行 Compose 代码 ✨

为了开始编写我们的应用程序，我们首先需要按照我称为 Jetpack Compose 协议来构建我们的应用程序，因为我在 Google Codelabs 中经常能看到这一协议。

第一件事：

1. 打开 `MainActivity.kt` 文件。

2. 在你的 `MainActivity` 类中新建一个可组合函数。

```kt
@Composable
fun MyApp() {
    Scaffold(
        content = {
            BarkHomeContent()
        }
    )
}
```

3. 如果 `Scaffold` 不是自动导入的并且显示为未解析的引用，请将其导入到文件中。

> **什么是 Scaffold？** 🤔
>
> 如果您阅读 Scaffold 的定义，就会发现 Scaffold 在 Compose 中实现了基础的 Material Design 可视化布局结构。所以一般来说，用 Android 原生的视觉布局结构来开始你的屏幕绘制是个好主意。

4. 通过在 onCreate 方法中调用 `MyApp()` 替换示例中的 Hello World 问候语。

```kt
override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    setContent {
        BarkTheme {
            MyApp()
        }
    }
}
```

接下来，我们需要编写添加到 Scaffold 的 content 参数 `BarkHomeContent()` 中的内容。

但是首先，我们知道我们需要展示一个小狗的列表，上面有每只小狗的一些细节，也许还有一张图片。为了做到这一点，我们需要创建一个 Data 类来保存每只小狗的信息，并创建一个 Data Provider 类来为我们提供一个小狗列表，这些小狗的正确排序将显示在我们的列表中。

## 设置用于收养的小狗 🐶

在实际场景中，我们的数据通常由后端通过某种 RESTful API 提供，我们需要异步处理这些 API 并为其编写不同的流。但是出于学习的目的，我们要伪造数据，把我们所有的小狗信息都写下来，并把它们的图片添加到我们的应用程序中。

为此：

1. 新建一个名为 `Puppy.kt` 的类。
2. 编写一个包含所有属性字段的数据类，以便用以下内容填充列表项：

```kt
data class Puppy(
    val id: Int,
    val title: String,
    val description: String,
    val puppyImageId: Int = 0
)
```

接下来，我们要为每只小狗添加一些可爱的小狗图片。为了使这一过程更轻松，您可以随时从我的 [GitHub 项目](https://github.com/waseefakhtar/bark/tree/main/app/src/main/res/drawable-nodpi)中下载这组照片。

下载完毕后，

1. 选择所有文件。
2. 复制这些文件。
3. 在 Android Studio 的 **/res** 目录下，选择 **/drawable** 文件夹并粘贴所有文件。

![](https://www.waseefakhtar.com/content/images/2021/04/4-6.png)

1. 当提示对话框询问要将它们添加到哪个目录时，请选择 `drawable-nodpi` (如果没有这个文件夹，可以在 **/res** 目录下手动创建文件夹，也可以将文件粘贴到 **/drawable** 文件夹下）

![](https://www.waseefakhtar.com/content/images/2021/04/5-5.png)

现在我们终于要写出 DataProvider 类来为列表构造数据。

1. 新建一个名为 `DataProvider.kt` 的类。
2. 写一个对象声明并创建一个包含每个小狗信息的列表(可以随意复制所有文本以节省构建应用程序的时间）

```kt
object DataProvider {

    val puppyList = listOf(
        Puppy(
            id = 1,
            title = "Monty",
            description = "Monty enjoys chicken treats and cuddling while watching Seinfeld.",
            puppyImageId = R.drawable.p1
        ),
        Puppy(
            id = 2,
            title = "Jubilee",
            description = "Jubilee enjoys thoughtful discussions by the campfire.",
            puppyImageId = R.drawable.p2
        ),
        Puppy(
            id = 3,
            title = "Beezy",
            description = "Beezy's favorite past-time is helping you choose your brand color.",
            puppyImageId = R.drawable.p3
        ),
        Puppy(
            id = 4,
            title = "Mochi",
            description = "Mochi is the perfect \"rubbery ducky\" debugging pup, always listening.",
            puppyImageId = R.drawable.p4
        ),
        Puppy(
            id = 5,
            title = "Brewery",
            description = "Brewery loves fetching you your favorite homebrew.",
            puppyImageId = R.drawable.p5
        ),
        Puppy(
            id = 6,
            title = "Lucy",
            description = "Picture yourself in a boat on a river, Lucy is a pup with kaleidoscope eyes.",
            puppyImageId = R.drawable.p6
        ),
        Puppy(
            id = 7,
            title = "Astro",
            description = "Is it a bird? A plane? No, it's Astro blasting off into your heart!",
            puppyImageId = R.drawable.p7
        ),
        Puppy(
            id = 8,
            title = "Boo",
            description = "Boo is just a teddy bear in disguise. What he lacks in grace, he makes up in charm.",
            puppyImageId = R.drawable.p8
        ),
        Puppy(
            id = 9,
            title = "Pippa",
            description = "Pippa likes to look out the window and write pup-poetry.",
            puppyImageId = R.drawable.p9
        ),
        Puppy(
            id = 10,
            title = "Coco",
            description = "Coco enjoys getting pampered at the local puppy spa.",
            puppyImageId = R.drawable.p10
        ),
        Puppy(
            id = 11,
            title = "Brody",
            description = "Brody is a good boy, waiting for your next command.",
            puppyImageId = R.drawable.p11
        ),
        Puppy(
            id = 12,
            title = "Stella",
            description = "Stella! Calm and always up for a challenge, she's the perfect companion.",
            puppyImageId = R.drawable.p12
        ),
    )
}
```

我们已经准备好要领养我们的小狗了。 🐶

## 在列表中显示小狗们 📝

现在，回到在 `MyApp()` 中调用 `BarkHomeContent()` 时停止的地方，我们最终将创建一个列表项，并用刚刚创建的数据填充列表。

先做重要的事，

1. 新建一个名为 `BarkHome.kt` 的类。

2. 在新建的类里面添加一个名为 `BarkHomeContent()` 的可组合函数。

```kt
@Composable
fun BarkHomeContent() {
    val puppies = remember { DataProvider.puppyList }
    LazyColumn(
        contentPadding = PaddingValues(horizontal = 16.dp, vertical = 8.dp)
    ) {
        items(
            items = puppies,
            itemContent = {
                PuppyListItem(puppy = it)
            })
    }
}
```

3. 导入所有缺少的引用。

> 注意：您可能会注意到，考虑到参数 `items =` 没有解析，此时可能需要不同版本的 `items` 函数。在这种情况下，您需要手动在类的顶部导入它的引用：`import androidx.compose.foundation.lazy.items`

现在，这里发生了很多事情，让我们逐一解释。

1. 在第 3 行中，我们定义了一个 `puppies` 变量，但带有一个 `remember { }` 关键字。当列表的状态改变时，可组合函数中的 remember 函数只存储变量的当前状态（在本例中是 `puppies` 变量）。如果我们有任何 UI 元素允许用户更改列表的状态，那么这在实际场景中非常有用。在这种场景中，列表从后端或从用户事件更改。在我们目前的情况下，我们没有这样的功能，但它仍然是一个很好的做法，能够维持我们的小狗名单的状态。想要了解更多的说明信息，请看[文档](https://developer.android.com/jetpack/compose/state)。

2. 在第 4 行中，我们称之为 `LazyColumn` 的 composable。这相当于我们作为 Android 开发者非常熟悉的 RecyclerView。这真的需要举办一个盛大的庆祝活动，因为用 Jetpack Compose 创建一个动态列表是多么容易。 🎉

3. 在第 5 行中，在 `LazyColumn` 参数中，我们给它一个很适宜的小填充块，让我们的每个列表项之间有一点喘息的空间。

4. 在第 7-11 行的 `LazyColumn` 内容中，我们调用 `items` 函数，该函数将 `puppies` 列表作为第一个参数，并调用一个可组合的 `puppies` （我们将在下一步创建），该函数将列表项组合填充到列表中的每个项中。

## 创建列表项 📝

接下来，我们将创建可组合的列表项，我们将其称为 `PuppyListItem`：

1. 新建一个名为 `PuppyListItem.kt` 的 Kotlin 文件。
2. 在以 `Puppy` 类型作为参数的类中编写一个新的简单可组合函数。
3. 在函数内部，创建一个 `Row`，用来表示列表中的一行。
4. 在 `Row` 中，创建一个包含两个文本的列，并在第一个文本框上写上小狗的名字，在第二个文本框上写 `view detail`。

```kt
@Composable
fun PuppyListItem(puppy: Puppy) {
    Row {
        Column {
            Text(text = puppy.title, style = typography.h6)
            Text(text = "VIEW DETAIL", style = typography.caption)
        }
    }
}
```

这是创建 `PuppyListItem` 后运行应用程序时的结果。

![](https://www.waseefakhtar.com/content/images/2021/04/6-4.png)

不是很好看。但我们可以用一些简单步骤设计我们的列表项。

## 设计列表项 🎨

1. 添加一点填充，并使文本的宽度最大，同时保留一些呼吸空间。

```kt
Row {
    Column(
        modifier = Modifier
            .padding(16.dp)
            .fillMaxWidth()
            .align(Alignment.CenterVertically)
    ) {
        Text(text = puppy.title, style = typography.h6)
        Text(text = "VIEW DETAIL", style = typography.caption)
    }
}
```

![](https://www.waseefakhtar.com/content/images/2021/04/7-3.png)

2. 用一个 `card` 组件把你的 `Row` 围起来，你可以随意设计它的样式。

```kt
Card(
    modifier = Modifier.padding(horizontal = 8.dp, vertical = 8.dp).fillMaxWidth(),
    elevation = 2.dp,
    backgroundColor = Color.White,
    shape = RoundedCornerShape(corner = CornerSize(16.dp))
) {
    Row {
        Column(
            modifier = Modifier
                .padding(16.dp)
                .fillMaxWidth()
                .align(Alignment.CenterVertically)
        ) {
            Text(text = puppy.title, style = typography.h6)
            Text(text = "VIEW DETAIL", style = typography.caption)
        }
    }
}
```

![](https://www.waseefakhtar.com/content/images/2021/04/8-2.png)

最后，我们需要为每只小狗添加一个图像。为此：

1. 在 `PuppyListItem()` 下创建一个新的可组合函数 `PuppyImage()`，传递 `puppy` 参数。

2. 调用 `Image` 可组合函数并根据需要设置样式：

```kt

@Composable
private fun PuppyImage(puppy: Puppy) {
    Image(
        painter = painterResource(id = puppy.puppyImageId),
        contentDescription = null,
        contentScale = ContentScale.Crop,
        modifier = Modifier
            .padding(8.dp)
            .size(84.dp)
            .clip(RoundedCornerShape(corner = CornerSize(16.dp)))
    )
}
```

3. 最后，在 `PuppyListItem()` 中的 `Row` 里首先调用 `PuppyImage()`。

```kt
@Composable
fun PuppyListItem(puppy: Puppy) {
    Card(
        modifier = Modifier.padding(horizontal = 8.dp, vertical = 8.dp).fillMaxWidth(),
        elevation = 2.dp,
        backgroundColor = Color.White,
        shape = RoundedCornerShape(corner = CornerSize(16.dp))

    ) {
        Row {
            PuppyImage(puppy)
            Column(
                modifier = Modifier
                    .padding(16.dp)
                    .fillMaxWidth()
                    .align(Alignment.CenterVertically)) {
                Text(text = puppy.title, style = typography.h6)
                Text(text = "VIEW DETAIL", style = typography.caption)

            }
        }
    }
}
```

![](https://www.waseefakhtar.com/content/images/2021/04/9-2.png)

哇哦! 我们已经用数据填充动态列表视图了。那么这篇文章就到此为止。

剩下的两件事是：

1. 根据我们的最终外观设计应用程序。
2. 实现详情页面。

编码快乐! 💻

[**本文的最终版本源代码**](https://github.com/waseefakhtar/bark)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
