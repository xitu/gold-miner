> * 原文地址：[Breakpoints: Debugging like a Pro](https://cheesecakelabs.com/blog/breakpoints-debugging-like-pro/)
> * 原文作者：[Alan Ostanik](https://cheesecakelabs.com/blog/author/alan/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/breakpoints-debugging-like-pro.md](https://github.com/xitu/gold-miner/blob/master/TODO/breakpoints-debugging-like-pro.md)
> * 译者：[PTHFLY](https://github.com/pthtc)
> * 校对者：[ryouaki](https://github.com/ryouaki)

# 断点：像专家一样调试代码

![](https://s3.amazonaws.com/ckl-website-static/wp-content/uploads/2017/06/Banner_xcode3.png)

当我刚开始成为一名iOS开发者的时候，我最大的问题是：当应用崩溃时，我真的不知道 iOS 、 Swift 、Objective-C 都是如何工作的。那时候，我写了很多烂代码，从不担心内存使用、内存访问、 ARC （译者注：Automatic Reference Counting ）。那仅仅是因为我不知道那些事情。看在上帝的份上，我是个菜鸟。

就像许多新手一样， [Stack Overflow](http://www.stackoverflow.com "Stack Overflow") 社区教会我许多关于『如何做正确的事情』的方法。我学到了许多帮助提升工作过程的窍门。在这篇文章中，我将分享在这一阶段过程中最重要的一些工具，那就是**断点**！

那么，撸起袖子干起来吧。🙂

# 断点

毫无疑问， Xcode 断点是一个强大的工具。其主要目的是调试代码，但是如果我说他们还要更多作用呢？ OK，那我们从一些窍门开始吧。

## Conditioning breakpoints 条件断点

也许你已经陷入了这样一种困境：你的 _TableView_ 对于所有用户 model 都运行良好，可就是有那么一个引起来一些麻烦。为了调试这个实例，首先你可能会想：『 _Ok ， 我会在 cell 装载的地方打个断点看看什么情况_』。但是对于每个 cell ，甚至是暂时正常的那些，你的断点都会被激活，你不得不不停跳过直到你抵达你想要调试的那个。

[![The Office TV show gif, saying "please god, no"](https://media.giphy.com/media/12XMGIWtrHBl5e/giphy.gif)](https://media.giphy.com/media/12XMGIWtrHBl5e/giphy.gif)

为了解决这些问题，你可以继续然后给断点设置一个停止的条件，就像我对用户『 Charlinho 』做的那样。
![A conditional breakpoint screenshot](https://s3.amazonaws.com/ckl-website-static/wp-content/uploads/2017/06/3.png)

## Symbolic Breakpoints 标志断点

> _“放轻松，我会用 pod ，那应该会给我们省点工作量。”_

谁都无法保证永远不会说这句话。但是使用 pod 或者一个外部库意味着你向你的工程引入了外部代码并且也许你并不知道它是怎么写出来的。比如说你发现在 pod 内部一堆方法里存在一个错误，但是你不知道这个方法在哪里。做个深呼吸，保持冷静。你有**_Symbolic Breakpoints_**_._

当事先声明的 _标志_ 被唤醒，这些断点会被激活。 _标志_ 可以是任何非成员函数、实例、类方法，是否在你的类里都可以。因此在函数中加一个断点，无论谁唤醒它，你只要加一个  _Symbolic Breakpoint_ 来观察你想要调试的函数。在我下面的样例中，我观察  _UIViewAlertForUnsatisfiableConstraints_ 方法。每当 Xcode 发现 _Autolayout_ 问题的时候，这个方法都会被唤醒。你可以看在[这篇博文](http://nshint.io/blog/2015/08/17/autolayout-breakpoints/)看一个更深入的例子。

![A Symbolic breakpoint option screenshot](https://s3.amazonaws.com/ckl-website-static/wp-content/uploads/2017/06/2.png)

## Customizing breakpoints 自定义断点

像我之前说的，断点是一个强大的工具。你知道吗？你甚至可以在端点上自定义动作。是的，你可以这么做！你可以运行 AppleScript ，捕获 CPU 框架，使用 LLDB ( Low-level Debugger ， XCode 内置的调试工具)命令，甚至 shell 命令。

![](https://s3.amazonaws.com/ckl-website-static/wp-content/uploads/2017/05/4.png)

你只需要简单地点击右边的按钮，选择 _edit breakpoint_ 。

### 好了，你看会想: “酷！但是为什么要这么做？”

我会给你一个很好的使用案例来帮助你的理解。一个 APP 中最常见的功能是登录，有时候测试它有点无聊。如果你正在同时使用管理员账号和普通账号，你需要不停地输入用户和密码，会让这个过程变得难以忍受。一般的『自动化』登录页面的方法是创建一个 _模拟_ 实例，并把它应用于 _if debug_ 分句。像这样：

```
struct TestCredentials {
    static let username = "robo1"
    static let password = "xxxxxx"
}

private func fillDebugData() {
     self.userNameTxtField.text = TestCredentials.username
     self.passwordTxtField.text = TestCredentials.password
}
```

### 但是你可以用断点来让事情变得简单一点！

进入登录页面，加一个断点，然后加了两个填写账号密码的 LLDB 表达式。像我下面的例子一样：

![A Custom breakpoint executing express commands. ](https://s3.amazonaws.com/ckl-website-static/wp-content/uploads/2017/06/6.png)

考虑到这一点，你可以加两个不同身份的断点。你只要生效/失效你想要测试的那个，就可以在两个身份间切换了。一旦你在运行中切换用户，也不需要重新构建。

很酷，不是吗？

# COMBO BREAKER!

在我写这篇文章的时候，WWDC 2017 正在举行。他们发布了一些例如新版 Xcode 9 这样的酷炫家伙。如果你想知道在 Xcode 9 中有哪些新的调试工具，我强烈推荐看 [Session 404](https://developer.apple.com/videos/play/wwdc2017/404/)。

[![](https://media.giphy.com/media/l41m0ysPANVkPS8JW/giphy.gif)](https://media.giphy.com/media/l41m0ysPANVkPS8JW/giphy.gif)

这就是全部内容了！现在你知道了一些在我还是新手的时候帮助巨大的最基础的断点窍门。还有哪些我没有提到的酷炫窍门呢？你也有好的主意？请在评论区随意讨论！


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。

