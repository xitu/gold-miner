> * 原文地址：[Make Memory Management Great Again](https://medium.com/ios-geek-community/make-memory-management-great-again-f781fb29cea1#.w6wgnw1og)
* 原文作者：[Bob Lee](https://medium.com/@bobleesj)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[Deepmissea](http://deepmissea.blue)
* 校对者：[xiaoheiai4719](https://github.com/xiaoheiai4719)，[lovelyCiTY](https://github.com/lovelyCiTY)

# 让内存管理重振雄风

## 无需任何 CS/CE 学位的初学者，可以轻松掌握 Swift 3 中的 ARC（自动引用计数）

![](https://cdn-images-1.medium.com/max/2000/1*s0LCbddq8T4VN4kXtt9r2g.png)

Unsplash 上的美图

### 读者们

这篇文章主要写给那些对`内存管理`零基础的同学。许多 iOS 培训或者书籍都倾向于跳过这部分的内容，因为它对初学者来说实在是有点复杂。举个栗子，你在创建 `IBOutlet` 的时候见过 `weak` 和 `strong` 这些关键字吗？你可能见过，你写这些只是因为需要这么写。

在我们讨论 Swift 之前，先来建立一下关于`内存`的基础，什么是它首要的，以及为什么需要它。你可以跳过这部分。

术语`内存管理`是指一个操作系统（比如 iOS）如何保存和读取数据的概述。当然你已经知道，有两种方式来存储信息或数据。**1. 磁盘** and **2. 随机存取存储器（RAM）**.

#### 预备知识:

对`面向对象编程`、`可选类型`、`可选链`有一个正确的理解。如果你一脸懵逼，放松，赶快来 YouTube 看看我 Swift 的视频。[地址](https://www.youtube.com/playlist?list=PL8btZwalbjYlRZh8Q1VK80Ly0YsZ7PZxx)

### RAM 的目的

现在想象你正在你手机上玩射击游戏，然后它就需要存储一些图形图片，这样你才能在按下设置按钮的时候继续游戏，而且你希望回来时，PR 保持原样。如果不是这样，那就很糟糕了。😅

但是，在你关掉手机的时候，所有的图片都没了。所有，你应该猜到了，他们都是存储在 RAM 中。他们是临时存储到你的手机上，而且非常的迅速，大概在 15,000 MB/s，假设是 1,000 MB/s 的硬盘。那些图形并没有存储在你的硬盘上。因为如果那样，你的玩几个小时游戏以后，手机就剩图片和文字了。

经常，老师们把 RAM 描述为短期记忆。看看下面的短片。
[![](https://i.ytimg.com/vi_webp/Zz7ShiQqLQg/maxresdefault.webp)](https://www.youtube.com/embed/Zz7ShiQqLQg?wmode=opaque&widget_referrer=https%3A%2F%2Fmedium.com%2Fmedia%2F7ffc9e0d06c547a5448c166284d7fe53%3FpostId%3Df781fb29cea1&enablejsapi=1&origin=https%3A%2F%2Fcdn.embedly.com&widgetid=1)

黑猩猩拥有比大部分人类优秀的短期记忆。尽管两者都不会永远有一个长期的记忆。我的 iPhone 有 4GB 的 RAM 和 128GB 的磁盘。所以，在你运行程序的时候，几乎所有都存储在你的 RAM 里，除非我特别强调这是用 `UserDefaults` 或者 `CoreData` 来存到你的磁盘上。

### RAM 存储的限制

这是另一个场景。现在半夜两点了，你无聊的刷着 Instagram 或者 Facebook 在你的床上孤枕难眠。但是，手机是怎么保持每秒 60 帧的频率，在你上下滑动时，保持平滑过渡的？那是因为这些对象和数据被临时存入了 RAM 中。当然，这无法无限的存储。(译者注：这里手机滑动的流畅不仅仅是因为缓存数据，还有界面的优化等等)

在我们说`内存管理`时，尤其是在 iOS 上，指的是管理 RAM 可用空间的过程。尽管现在你很难见到内存超载，那是因为现在的手机性能要比 5 年前强得多。当然，iOS 开发者的黄金法则是创建一个高性能的程序，即使很多程序在后台运行也不产生影响。让我们对其他 iOS 开发者保持尊重。我们希望我们的程序永生。

### OK，接着干嘛？ 😴

RAM 就像个冰箱，你可以放吃的喝的，甚至衣服，就像我一样。同样地，在 iOS，你可以添加一堆影像，图像，大的对象，比如 UIView。对，就像冰箱一样，有一个物理空间的限制你一共能放多少东西。你可以拿出几瓶啤酒，这样就又能放新鲜的寿司。🍲

幸运的是，在 iOS 10，清理/释放内存这部分工作已经由苹果的工程师创建的库自动完成。他们实现了他们说的 `自动引用计数`，来表示对象是否正在使用或者已经没用。然而在其他的某些编程语言或者几年前，你不得不为对象逐个的手动申请内存，再一个个的释放。

所以，来看看`自动引用计数`是怎么工作的吧。

### 自动引用计数

首先，我们先创建个对象，我已经创建了一个名为 `Passport` 的类，它包含了一个公民身份，和一个可选属性 `human` ——这个一会儿再说，现在不用管 `human` 是怎么创建的，它是一个可选类型。

    class Passport {
      var human: Human?
      let citizenship: String
     init(citizenship: String) {
      self.citizenship = citizenship
      print("You've made a passport object")
     }

    deinit {
      print("I, paper, am gone")
     }
    }

顺便说一下，如果你不知道 `deinit` 是什么意思，那可以理解为与 `init` 相反。所以当你看到了 `init`，意味着你已经创建了一个对象，并把它放到了内存里。而 `deinit` 发生在对象在特定的位置已经被释放/取消分配/清除。

让我们**通过它自己**创建一个对象，而不是用 `var` 或者 `let`

    Passport(citizenship: "Republic of Korea")
    // "You've made a passport object"
    // "I, paper, am gone"

等等，为什么你创建了一个对象，却又被**正确删除**了？好吧，这是由于 ARC，我来解释。

为了维持一个在内存中的对象，你必须有一个对象的引用，必须有一个关系，我知道这听上去很奇怪，请原谅我的词穷。

    var myPassPort: Passport? = Passport(citizenship: "Republic of Korea")

![](https://cdn-images-1.medium.com/max/1600/1*onm_nN7Cyd9D2fNUZbVyCQ.png)

myPassport 持有了一个Passport 对象的引用/关系

在你通过 `Passport` 对象自己创建它的时候，它**没有引用/关系的计数**。现在，在 `myPassport` 和 `Passport` 之间有了一个关系，引用计数现在是**一**。

> **唯一法则**: 如果引用计数是零或者没有，那对象就会从内存里清除。

*你可能会奇怪 `strong` 是什么意思. 它是一种默认的关系类型. 一个关系将引用计数加一, 稍后我会在什么时候用 `weak` 时解释。*

现在，我要创建一个叫 `Human` 的类，它包含一个类型是 Passport 的可选类型属性。

    class Human {
     var passport: Passport?
     let name: String
     init(name: String) {
      self.name = name
     }

     deinit {
      print("I'm gone, friends")
     }
    }

现在 `passport` 是一个可选类型了，在初始化一个 `Human` 对象时，我们不用设置它的值。

    var bob: Human? = Human(name: "Bob Lee")

![](https://cdn-images-1.medium.com/max/1600/1*WGQoMfvMtiYU3QxOXqT9Sw.png)

bob 对于 Human 和 myPassport 对于 Passport 是一样的
如果你现在把 `bob` 和 `myPassport` 的值设为 `nil` 那么

    myPassport = nil // "I, paper, am gone"
    bob = nil // "I'm gone, friends"

![](https://cdn-images-1.medium.com/max/1600/1*aTt-hEdZ-p7SSA7NgcN6jA.png)

所有的都被释放掉了
在你设置他们为 `nil` 的时候，关系就不存在了，所以他们的引用计数变为 **0**，这导致他们都被释放。

但是，有时即使你设置了 **`**nil**`**，它还是不会释放内存，这可能是由于和对象和其他的对象还存在联系，导致引用计数不能为 0，这听上去很疯，那么我们来看一下。


`Human` 类有一个可选类型的属性 `Passport`，而 `Passport` 也有一个可选类型的属性 `Human`。（译者注：这里的 `Human` 在原文中是 `Human1`，肯定是笔误，所以纠正了。）

    var newPassport: Passport? = Passport(citizenship: "South Korea")
    var bobby: Human? = Human(name: "Bob the Developer")

    bobby?.passport = newPassport
    newPassport?.human = bobby

为了搞清楚他们的关系，我已经给你弄了一张表。

![](https://cdn-images-1.medium.com/max/1600/1*dbWY94LQTZCCLGUvMPfQaA.png)

OK，现在，我们像刚才一样，把他们的值设置为 `nil`。

    newPassport = nil
    bobby = nil
    // Nothing happens 🤔

什么都没发生。他们还在。为什么？因为在 `bobby` 和 `newPassport` 之间还是存在一个关系。

![](https://cdn-images-1.medium.com/max/1600/1*aytSkuvT1dh0Fjk3HCiiXg.png)

这看起来有点和预期相反。**你必须彻底把这两个对象之间的关系，和其他对象与这两个对象的关系都打破，以完全清除这两个对象**。例如，即使 `Human` 的 “Bob Lee” 已经设置为 `nil`，它还是不会被释放，因为 `Passport` 是指向 `Human` 对象的，他们之间还存在关系（`Human` 的引用计数为 1）。所以现在，当你试着把 `Passport` 设置为 `nil` 的时候，它也不会被释放，因为 `Human` 对象还存在而且还有一个到 `Passport` 的引用。引用计数永远不会为 0。

> “唯一法则反向推论: 对象是否设置为 nil 无关紧要，一切皆为引用计数。你必须破坏所有引用。nil != 释放内存” — SangJoon Lee

### 关键的问题

我们叫它**循环引用**或**内存泄漏**。即使一些对象已经不在使用，而且你认为他们已经被释放了，而他们却还呆在你的手机里占着地方，就像胖子的脂肪一样。（这是 iOS 最常见的面试题之一。）这很糟糕。想象一下如果你在滑动上千条 instagram 推送或者 Facebook NewsFeed 的时候内存泄漏。你仅有的 4G 的内存会被数据对象填满，最终崩溃。这对很多用户来说都不是一个好的体验。

### 送走 Strong，迎接 Weak

非常棒，你已经走了很长一段路了。恭喜。现在，你会学习为什么我们使用 `weak`。唯一的目的是允许**释放对象**。

记住，**弱引用不会增加引用计数**。让我们把 `weak` 加到 `Passport` 类 `Human` 属性的前面。

    class Passport {
    **weak var human: Human?
    **let citizenship: String

     init(citizenship: String) {
      self.citizenship = citizenship
      print("You've created an object")
     }

     deinit {
      print("I, papepr, am gone")
     }
    }

其他的都保持原样。

![](https://cdn-images-1.medium.com/max/1600/1*Q0Mh1UxKEVwCuPPSLtFlfA.png)

Passport 现在对 human 是一个弱引用，不会造成循环引用。
现在，如果你设置

    newPassport = nil
    bobby = nil

    // "I, papepr, am gone"
    // "I'm gone, friends" 👋

![](https://cdn-images-1.medium.com/max/1600/1*7DKrMzcj38Hlvmi3vwY12g.png)

对象被销毁，然后释放。

由于 `weak` 不会作为一种关系而增加，或者说不会增加引用计数，在你设置 `bobby` 为 `nil` 之前，实际上只有**一个引用**。所以，在你把 `bobby` 设置为 `nil`，引用计数/关系变成了 `0`，成功的让你销毁所有对象。我喜欢让东西从内存里出来，妈的，这文章永远牛逼。

#### [源码在这](https://github.com/bobleesj/Blog_Memory_Management)

### 最后的备注

到现在，我希望能你已经理解 `strong` 和 `weak` 是什么，以及`引用计数`是如何在 Swift 里自动工作的。如果你跟我学到了一些新的东西，请点击右面或者下面的 ❤️，我会很感激。我曾想过是否应该放上这些图，因为它们很耗费时间，但是为了我亲爱的 Medium 读者们，这都不是事儿。

在第二部分，我会讲讲**闭包的内存管理**，就像你看到过的 `[weak self]` 一样，我也会聊聊 `self` 的使用目的等等。所以保持关注 follow 我，这样你就能第一时间得到通知！

### 即将到来的课程

我现在开了一门课，叫 The UIKit Fundamentals with Bob on Udemy。这门课面向的是 Swift 的中级开发者。这和那些 “完整的课程” 不一样，它很特别。从上个月到现在，已经有 200 多位读者给我发邮件了。如果感兴趣，给我发邮件，开课的时候免费注册进入，我会给你一个表格来注册。`bobleesj@gmail.com`

#### 辅导

如果你正在寻找一个人，能帮助你转行成为一个 iOS 开发者，或者创建一个为世界共建和谐美好的应用，请联系我详谈。

### Swift 会议

[Andyy Hope](https://medium.com/@AndyyHope)，我的一个朋友，在澳大利亚墨尔本，正在组织最大的 Swift 会议之一，名为 Playgrounds。估计三周以内就会开始了！我非常非常的建议你去看看，因为演讲者们都是大公司来的。😲

[Playgrounds 🐨 (@playgroundscon) | Twitter
The latest Tweets from Playgrounds 🐨 (@playgroundscon). ● Swift and Apple Developers Conference ● Melbourne, February…twitter.com](https://twitter.com/playgroundscon)

#### 最后的呐喊

巨感谢我的学生们！ [Nam-Anh](https://medium.com/@yoowinks), [Kevin Curry](https://medium.com/@kevincurry_89695), David, [Akshay Chaudhary](https://medium.com/@Akshay_Webster).
