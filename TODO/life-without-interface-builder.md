> * 原文地址：[Life without Interface Builder](https://blog.zeplin.io/life-without-interface-builder-adbb009d2068)
> * 原文作者：[Zeplin](https://blog.zeplin.io/@zeplin_io?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/life-without-interface-builder.md](https://github.com/xitu/gold-miner/blob/master/TODO/life-without-interface-builder.md)
> * 译者：[Ryden Sun](https://github.com/rydensun)
> * 校对者：[talisk](https://github.com/talisk) [allenlongbaobao](https://github.com/allenlongbaobao)

# 没有 Interface Builder 的生活

![](https://cdn-images-1.medium.com/max/800/1*UTs12drXJKnouZTb5jP79A.png)

在过去的几个月，在 Zeplin 的 macOS 版本 app 中，我们开始在开发一些新的功能时，不使用 Interface Builder 或者 Storyboards。

在 iOS/macOS 社区，这是一个很具有争议性的话题，并且作为一个之前极其依赖 Interface Builder 的团队，我们想用一些真实的案例，来分享一下我们为什么做了这个转换。即便这篇文章是从 macOS 方面出发的，但其中我提到的任何东西都可以被应用到 iOS 上。

### 为什么？

在用了两年的 Objective-C 后， Zeplin 在 2015 年末，第一次用 Swift 来编写其中一个模块。从那以后，我们一直使用 Swfit 开发新的功能并且逐渐地迁移之前存在的部分。目前，macOS 版本的 app，有 75% 是用 Swift 编写的。

有趣的是，在我们刚开始用 Swift 时，就开始考虑放弃 Interface Builder。

#### 太多的可变类型

在 Swift 中使用 Interface Builder 会带来很多 optional（Swift 中的可选类型），而且它们都不属于类型安全的域。我也不是仅仅在讨论 outlets，如果你在 Storyboards 中使用 segues，你的**数据模型中的 property 也会变成可选类型**。事情就是在这里变得不受控制。你的 view controller 是要求 property 正常工作的，现在它们变成了 optional，你就开始到处写 `guard`，开始变得混乱，考虑在哪里能够优雅地处理它们，哪里能简单地从 `fatalError` 中逃脱出来。这是很容易出错的，而且会明显地降低代码的可读性。

> 你的 view controller 是要求 property 正常工作的，现在它们变成了 optionals，你就开始到处写 `guard`。

……除非你使用 Implicitly Unwrapped Optionals（隐式解析可选），使用操作符`!`。这在大多数时候是有用的，不会出现任何问题，但这样感觉是在欺骗 Swift 平台。我们大多数人相信，Implicitly Unwrapped Optionals 应该在极少数的场景下使用，而且在日常开发中是应该避免在 Storyboards 中使用。

#### 设计的改变

在 Objective-C 写布局代码还不算太糟，但是使用 Swift 就变得更简单了，并且最重要的是，更易读。声明 Auto Layout 的 constraints 很轻松也很漂亮，这要感谢像 [Cartography](https://github.com/robb/Cartography) 这样的库。

```
// 创建 property 时定义外观表现
let editButton: NSButton = {
    let button = NSButton()
    button.bordered = false
    button.setButtonType(.MomentaryChange)
    button.image = NSImage(named: "icEdit")
    button.alternateImage = NSImage(named: "icEditSelected")
    
    return button
}()

…

// 用 Cartography 声明 Auto Layout 限制
constrain(view, editButton, self) { view, editButton, superview in
    editButton.left == view.right
    editButton.right <= superview.right - View.margin
    editButton.centerY == view.centerY
}
```

我猜想，我们可以将使用 Interface Builder 的开发者分为两种类型：一类是只用来做 Auto Layout 和 segues 的，一类是也会用来附加设计的；在 Interface Builder 设置颜色，字体和其他可视化的属性。

> 在使用 Interface Builder 时，你会发现你自己在复制粘贴你之前写好的视图 —— 并且你都不会对这种行为感到不好。

我们 _稍稍微地_ 属于第二种类型 ！Zeplin 是一个常变的 app，当只有设计元素改变的时候，这最终就开始困扰我们了。让我们假设，你只需要改变一个公用按钮的背景颜色。你需要打开每一个 nib 文件并且手动的改变它们。当这个需要经常重复的时候，你就会可能漏掉一些。

当你使用纯代码来编写视图时，**这会激励你复用代码**。正相反，在使用 Interface Builder 时，你会发现你自己在复制粘贴你之前写好的视图 —— 并且你都不会对这种行为感到不好。

#### 可复用的视图

根据 Apple 的观点，Storyboards 是未来。从 Xcode 8.3开始，我们在开发项目的时候，都没有一个可以不使用 Storyboards 的选项。😅 这确实很令人伤心，**这都没有一个直接了当的方法来复用 Interface Builder 中的视图**。

这就是为什么，我们发现自己一直用纯代码来编写一些常用的公共视图。创建一个可以同时用代码和 nib 初始化的视图也是棘手的，强制你去实现两个构造器并且去做同样的初始化行为。当你只是用代码时，你可以安全的忽略 `_init?(coder: NSCoder)_`。

#### 转换背后

在转换之后，我们有了一个认知：使用代码构建界面提升了我们对于 `UIKit` 和 `AppKit` 组件的理解。

我们在转换一些之前用 nib 实现的旧的功能。当我们尝试去保留外观，我们必须去学习更多的关于不同的属性在做什么和他们是如何影响一个组建的外观。在之前，他们只是被 Interface Builder 默认设置的一些选择和复选框，而且它们就这样起作用了。

> 使用代码构建界面提升了我们对于 `UIKit` 和 `AppKit` 组件的理解。

对于导航性的组件，像 `UINavigationController`，`UITabBarController`，`NSSplitViewController` 这些都是可行的。尤其对于新手来说，他们极其依赖于这些组件但又不是真正地理解它们在幕后是怎么工作的。当你尝试用代码来初始化和使用它们时，就会立即感觉很舒服。

![](https://cdn-images-1.medium.com/freeze/max/30/1*xOHvn40BYFM2GyaNAvLsCQ.gif?q=20)

![](https://cdn-images-1.medium.com/max/800/1*xOHvn40BYFM2GyaNAvLsCQ.gif)

Zo 在打开一个庞大的 Storyboard 时很煎熬。

#### 调试的问题

是否曾有过一个 bug，你花费几分钟时间来追溯并且最终发现，造成它的原因是一个没有被连接起来的 outlet 或者是 nib 中一个你无意中改变的选项？

每一个你用代码创建的组件都会被包在一个单独的源文件，因此你不需要去担心在 nib 和源文件之间的跳转。这会帮助我们在调试问题是更迅速，并且一开始就会引入更少的 bug。

#### 代码审核和合并冲突

为了读懂和理解透彻 nib，你要不得是一个 nib 奇才，要不你就得花费相当多的时间！这就是为什么**大多时间，人们都直接在审核代码时略过 nib 的改动，因为它太吓人了。**想一想这些潜在的可视的 bug 可能会因为在代码中使用常量和文字直接被消除掉。

在反对 nib 的声音中，冲突的合并是你会最经常听到的抱怨。如果你曾在一个使用 nib，尤其是 Storyboards 的项目中工作过，你可能也亲身经历过。你知道这通常意味着：一个人的工作会需要被回滚然后再重应用。这些事最令人烦躁的冲突，而且当你团队变大时，会变得越来越让人沮丧。你可以相应地分配任务，这在大多数时候可以克服这个问题。但在 Storyboards，即使在你单独写一个 ViewController 时，这样的问题都可能发生。

出人意料的，当时这对于 Zepin 来说，不算是个问题 —— 因为我们是一个比较小的团队，我猜。这也是为什么我把这一点放到了最后来说。

### 结论

我已经列出了很多的原因来解释为什么停止使用 Interface Builder 是一个好主意，但别误会，有一些用例下，使用 Interface Builder 也是有道理的。即使我们故意省略这些用例，因为我们目前，在没有 Interface Builder 的情况下更加开心了。

不要害怕去实践，并且去看看这是否也适合你们的工作流程！

* * *

感谢我们可爱的 [@ygtyurtsever](https://twitter.com/ygtyurtsever)。让我们知道你是怎么想的，在下面留言吧！👋


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
