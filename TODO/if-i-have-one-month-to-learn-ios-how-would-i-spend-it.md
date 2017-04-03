> * 原文地址：[If I have one month to learn iOS: How would I spend it?](https://android.jlelse.eu/if-i-have-one-month-to-learn-ios-how-would-i-spend-it-a5b2aba87cc2#.8dh9co4nl)
* 原文作者：[Quang Nguyen](https://android.jlelse.eu/@quangctkm9207?source=post_header_lockup)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[Gocy](https://github.com/Gocy015)
* 校对者：[reid3290](https://github.com/reid3290) ,[zhaochuanxing](https://github.com/zhaochuanxing)

# 如果只有一个月入门 iOS：我该如何学习呢？ #

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/2000/1*7kScZyq1aZUf6bjVC7oA7g.png">

图片来源：[https://unsplash.com/@firmbee](https://unsplash.com/@firmbee) 

直到去年，我一直都在从事 Android 平台的开发。当时，我对 iOS 开发没有任何的概念，甚至从来没有用过 Apple 的产品。但这一切都是过去式了，现在我已经能够同时进行 iOS 和 Android 应用的开发了。

今天再回顾过去的学习时光，我想分享一个由我自己总结出的一个月入门 iOS 开发的课程大纲。
依我个人的经验，我非常推荐 Android 开发者学习 iOS 应用开发。尽管这听起来怪怪的，但别误解我。因为：**广泛地涉猎能够让你在自己的领域有更深的见解。**

> “如果你做出了些成果并且收效不错，那么你应该投入到创造下一个美妙的东西中去，不要在已有的成果上沉浸太久。弄清楚下一个目标就是了。” - **Steve Jobs**

回到正题，就从我自己制定的一个月学习计划讲起，放心，文中所有的资源都是完全免费的。

### Swift 入门 ###

你当然也可以学 Objective-C 但我强力推荐你学习 Swift。它非常的友好并且易于上手。（译者注：国外的 Swift 氛围相对较好，如果是国内的话请仔细斟酌首学语言）

我第一个访问的网址就是[苹果官方资源](https://developer.apple.com/library/prerelease/content/documentation/Swift/Conceptual/Swift_Programming_Language/index.html)。通读那些基本概念并跟着文档在 Xcode 中进行实践吧。

除此之外，你也可以试试 [优达学城的 Swift 学习课程](https://www.udacity.com/course/learn-swift-programming-syntax--ud902)。尽管网站上说你大概要花三周时间进行学习，但其实你几天（每天几个小时）你就可以完成那些课程了。

我大概花了一周时间学习 Swift。而如果你的时间充裕，也可以看看下面的资源：

- [Swift-Playgrounds 学习基础语法](https://github.com/danielpi/Swift-Playgrounds) 
- [Raywenderlich 的 Swift 教程](https://www.raywenderlich.com/category/swift)
- [Swift 中的设计模式](https://github.com/ochococo/Design-Patterns-In-Swift)

### 用 UIKit 来绘制应用界面 ###

接下来让我们看看有趣的视觉部分。UIKit 能让你的程序在 iOS 设备上进行展示和交互。听着不错，不是吗？

当时我在优达学城上搜索相关的免费课程，我还真找到了 - [UIKit 基础课程](https://www.udacity.com/course/uikit-fundamentals--ud788)。

起初，iOS 的 Auto Layout 让我颇感困扰。因为在开发 Android 应用时，我都是通过 xml 文件来实现界面并视觉检视的，几乎从来没有用过拖拽摆放（drag-and-drop）的方法。但在 iOS 上，这个过程完全不同。
在花了一些时间去实践、理解 Auto Layout 的机制之后，我发现我学到了一些日常 Android 设计风格之外的新东西，这太棒了。

除此之外，你还可以在 Xcode 的 Storyboard 中简单地拖动、连接两个视图（screen），就能完成视图转场，而在 Android 这只能由代码完成。

你可以探索的特性还有很多。

另外，你还可以在 [Raywenderlich 的 iOS 目录](https://www.raywenderlich.com/category/ios) 下的“Core Concepts”板块找到更多有关 iOS UIKit 的教程。

### 理解 iOS 的数据持久化 ###

当你熟悉了 UIKit 之后，你就可以向用户展示数据并从他们那获取数据了。很棒吧。

下一步就是将数据存储起来，这样即便应用关闭了，用户下次使用依然可以获取到这些数据。这里我的意思是将数据存储在用户的设备上，而不是远端服务器。

在 iOS 应用中，你有以下几个选择：

- **NSUserDefaults** : 一种键-值形式的存储，与 Android 中的 SharePreferences 相似
- **NSCoding / NSKeyed&#8203;Archiver** : 将兼容的类与数据表示互相转换，并存储于文件系统（File System）或 NSUserDefaults 中
- **Core Data**: iOS 的功能强大的框架
- 其它: SQLite，Realm 等等。

尽管当下许多 iOS 开发者都更愿意使用 Realm 而非 Core Data，但我还是推荐你学习 Core Data，因为它是 iOS 官方的持久化框架，当你理解了它的核心架构和实现方式后，你将如虎添翼。（译者注：关于 SQLite，Realm 还是 Core Data 的争论一直没有停过，建议初学者都了解一下，根据实际项目需要进行选择）

我所参看过的资源包括：

- 优达学城的 [iOS 数据持久化和 Core Data](https://www.udacity.com/course/ios-persistence-and-core-data--ud325)
- Youtube 上的 [一些 Core Data 教程](https://www.youtube.com/results?search_query=core+data)
- Mattt Thompson 编写的 [NSCoding/NSKeyedArchiver 相关文章](http://nshipster.com/nscoding/) 

### 利用 iOS 网络连接来与世界互动 ###

我们生活在互联网时代，所以你的应用理应能够与外界互联并与他人进行数据交换。让我们进入下一课：iOS 网络连接。你要学习如何使用 iOS 中的 REST API（译者注：REST - REpresentational State Transfer）。在这个阶段，请你一定不要使用第三方的库。让我们用 iOS 内置的框架来完成这部分的内容。

在日后的开发中，你将有许多使用诸如 [Alamofire](https://github.com/Alamofire/Alamofire) 这样酷炫的 http 网络库的机会，但我们现在是在学习呢。在尝试那些高深的东西前，我们要先了解官方提供的基础知识。

我推荐如下的课程和教程：

- RayWenderlich 上的 [NSURLProtocol](https://www.raywenderlich.com/76735/using-nsurlprotocol-swift) 教程
- RayWenderlich 上的 [NSURLSession](https://www.raywenderlich.com/110458/nsurlsession-tutorial-getting-started) 教程
- 优达学城上的 [基础网络课程](https://www.udacity.com/course/ios-networking-with-swift--ud421)

### 创造属于你的美妙应用 ###

> “了解是不够的。我们必须运用”。 - Leonardo da Vinci

在进行完上述的学习之后，你已经有丰富的知识储备了。你可以用 Swift 编程，用 Storyboard 和 UIKit 来构建 iOS 应用界面，在本地设备存储数据，并利用 iOS 网络连接来于外界交换信息。

太棒了大兄弟。放手去实现任何你想到的东西吧！

我们开发者，创造又酷又富有价值的工具来让这繁复的世界变得简单。所以，你可以试着做一个改进你日常生活的应用，帮助你的家人，甚至是解决全球性问题。最后，我建议你将应用发布到 Apple Store 上。这将给予你正反馈并有助于你坚持下去。

三年以前，我在学习了 Android 一个月后，在 Google Play 发布了我的第一个 Android 应用（是一个作笔记的应用）。一年前，我同样在自学一个月后在 Apple Store 发布了我的第一个 iOS 应用（一个天气应用）。它们一开始都简单粗糙，但却时刻激励着我继续前进的脚步。

我打赌你能做得比我更好。所以，让我们去创造一些值得向世界炫耀的东西吧。

**注意：** 你可以通过 Google 搜索到许多其它优秀的资源。上文中提到的教程和课程仅仅是我的个人推荐。

希望这篇文章能够给你带来帮助。