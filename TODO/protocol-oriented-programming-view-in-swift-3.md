> * 原文链接: [Protocol Oriented Programming View in Swift 3](https://medium.com/ios-geek-community/protocol-oriented-programming-view-in-swift-3-8bcb3305c427#.nxlwj0t9f)
* 原文作者 : [Bob Lee](https://medium.com/@bobleesj)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [洪朔](http://www.tuccuay.com)
* 校对者 : [DeepMissea](https://github.com/DeepMissea), [thanksdanny](https://github.com/thanksdanny)

# 在 Swift 3 上对视图控件实践面向协议编程

## 学习如何对 `button`, `label`, `imageView` 创建动画而不制造一串乱七八糟的类

![](https://cdn-images-1.medium.com/max/2000/1*s_XZ1RzyZgyON36tM4zZCA.png)

你可能听人说过，学到了知识却缺失了行动就好比人长了牙却还老盯着奶喝一样。那好，我们要怎样开始在我的应用中实践面向协议编程？🤔

为了能更加高效的理解下面的内容，我希望读者能够明白 `Complection Handlers`，并且能创建协议的基本实现。如果你还不熟悉他们，可以先查看下面的文章和视频再回来接着看：

前景提要：

- [Intro to Protocol Oriented Programming](https://medium.com/ios-geek-community/introduction-to-protocol-oriented-programming-in-swift-b358fe4974f)
- [No Fear Closures Part 2: Completion Handlers](https://medium.com/ios-geek-community/no-fear-closure-in-swift-3-with-bob-part-2-1d79b8c4021d#.5duucas56)
- [Protocol Oriented Programming Series](https://www.youtube.com/playlist?list=PL8btZwalbjYm5xDXDURW9u86vCtRKaHML)

### 看完这篇文章你会学到这些内容

你将会明白如何使用协议给 `UIButton`, `UILabel`, `UIImageView` 等 UI 组件添加动画，同时我也会给你演示传统方法和使用 POP 方法之间的差异。😎

### UI

这个演示程序名为「欢迎来到我家的聚会」。我将会使用这个应用程序来验证你是否获得邀请，你必须输入你的邀请码。**这个应用并没有逻辑判断，所以只要你按下按钮，无论如何动画都将会被执行。** 将会有 `passcodeTextField`, `loginButton`, `errorMessageLabel` 和 `profileImageView` 四个组件参与动画过程。

这里有两个动画：1. 左右晃动 2. 淡入淡出

![](https://cdn-images-1.medium.com/max/1600/1*uN6sB588ehZIivOmmAsLPg.gif)

不用担心遇到问题，现在我们干的就像写流水账一样，如果你不耐烦了，直接滑动到下面下载源代码就可以了，

### 我们接着来

想要完整的在应用中体验 POP 的魔力，那就先让我们和传统方式来比较一下，假设你想给 `UIButton` 和 `UILabel` 添加动画，你先将他们都子类化，再给他们添加一个方法：

```swift
class BuzzableButton: UIButton {
    func buzz() { /* Animation Logic */ }
}

class BuzzableLabel: UIButton {
    func buzz() { /* Animation Logic */ }
}
```

然后，在你点击登录按钮的时候让他抖动

```swift
@IBOutlet wear var errorMessageLabel: BuzzableLabel!
@IBOutlet wear var loginButton: BuzzableButton!

@IBAction func didTapLoginButton(_ sender: UIButton) {
    errorMessageLabel.buzz()
    loginButton.buzz()
}
```

看到我们是如何写**重复的代码**了吗？这个动画逻辑至少有 5 行，更好的选择是使用 `extension`，因为 `UILabel` 和 `UIButton` 都继承自 `UIView`，我们可以给它添加这样的扩展：

```swift
extension UIView {
    func buzz() { /* Animation Logic */ }
}
```

然后，`BuzzableButton` 和 `BuzzableLabel` 就都有了 `buzz` 方法。现在，我们不用再写重复的内容了。

```swift
class BuzzableButton: UIButton { }
class BuzzableLabel: UIButton { }

@IBOutlet wear var errorMessageLabel: BuzzableButton!
@IBOutlet wear var loginButton: BuzzableLabel!

@IBAction func didTapLoginButton(_ sender: UIButton) {
    errorMessageLabel.buzz()
    loginButton.buzz()
}
```

### 那好，为什么要用 POP？ 🤔

正如你锁看到的，`errorMessageLabel` 将会显示 "Please enter valid code 😂"，并且具有淡入和淡出效果，在传统形式下我们会怎么做？

有两种方式来完成这一步。首先，你可以再向 `UIView` 添加一个方法

```swift
// Extend UIView
extension UIView {
    func buzz() { /* Animation Logic */ }
    func pop() { /* UILabel Animation Logic */ }
}
```

然而，如果我们把方法添加到 `UIView`，那么不光是 `UILabel`，其他所有 UI 组件都将会拥有 `pop` 这个方法，继承了不必要的函数让它变得过于臃肿了。

而另一种方式则是创建 `UILabel` 的子类：

```swift
// Subclass UILabel
class BuzzableLabel: UILabel {
    func pop() { /* UILabel Animation Logic */ }
}
```

这样是**可用的**，我们可能会希望将类名改成 `BuzzablePoppableLabel` 来更清晰的声明它的用途。

现在，如果你想给 `UILabel` 添加更多的方法，你就要再次给他起个新名字比如 `BuzzablePoppableFlashableDopeFancyLovelyLabel`，这恐怕不是一个可维护的方案，我们可能需要想想别的方法。

### 面向协议编程

**看到这里还没给文字点赞吗？动动手指点个赞然后继续往下看吧**

我们受够了各种子类了，让我们先来创建一个协议，让他抖动起来。

**我并没有在这里写动画代码，因为它很长，并且 gist 在移动设备上支持不佳**

```swift
protocol Buzzable {}

extension Buzzable where Self: UIView {
    func buzz() { /* Animation Logic */ }
}
```

任何 UI 组件只要遵循 `Buzzalbe` 协议就能拥有 `buzz` 方法，与直接给 `UIView` 添加 `extension` 不同，只有遵循协议的类才会拥有这些方法。另外，`where Self: UIView` 表示只有 `UIView` 或者从 `UIView` 继承的组件才能够遵循这个协议。

现在，我们将 `Buzzable` 应用给了 `loginButton`, `passcodeTextField`, `errorMessageLabel` 和 `profileImageView`。等等，那 `Poppable` 呢？

看起来差不多的：

```swift
protocol Poppable { }

extension Poppable where Self: UIView {
    func pop() { /* Pop Animation Logic */ }
}
```

是时候动真格的了！

```swift
class BuzzableTextField: UITextField, Buzzable { }
class BuzzableButton: UIButton, Buzzable { }
class BuzzableImageView: UIImageView, Buzzable { }
class BuzzablePoppableLabel: UILabel, Buzzable, Poppable { }

class LoginViewController: UIViewController {
    @IBOutlet weak var passcodTextField: BuzzableTextField!
    @IBOutlet weak var loginButton: BuzzableButton!
    @IBOutlet weak var errorMessageLabel: BuzzablePoppableLabel!
    @IBOutlet weak var profileImageView: BuzzableImageView!

    @IBAction func didTabLoginButton(_ sender: UIButton) {
        passcodTextField.buzz()
        loginButton.buzz()
        errorMessageLabel.buzz()
        errorMessageLabel.pop()
        profileImageView.buzz()
    }
}
```

POP 是一件很酷的事情，你可以在任何时间把这个协议应用给任何一个 UI 组件都不需要再去子类化任何东西。

```swift
class MyImageView: UIImageVIew, Buzzable, Poppable { }
```

现在，你可以更加灵活的给类来命名，因为你已经知道它遵循了哪些协议，并且每个协议的名称就能很清晰的描述它在干什么。所以你不会再有 `MyBuzzablePoppableProfileImage` 这样的东西。

**TL;DR**

少用子类

灵活的类名

就像一个 Swift 开发者一样

### 下一步

一旦我这篇文章（译注：指英文原文）获得超过 *200 个 like*，并且你想了解如何将 POP 运用在 `UITableView` 和 `UICollectionView` 中，请关注我的 Medium。

#### 资源

[源代码](https://github.com/bobleesj/Blog_Protocol_Oriented_View)

### Last Remarks

我想希望你已经学到了一些新知识，如果有的话，请给本文点赞。如果你觉得本文内容很有用，请将本文分享给大家，以便世界各地的 iOS 开发者都能运用面向协议编程，以在写视图控件的时候写更少和更清晰的代码。回顾于 EST 时间星期六上午 8 点。

### Swift 会议

[Andyy Hope](https://medium.com/u/99c752aeaa48) ，我的一个朋友，目前正在组织在澳大利亚墨尔本最大的 Swift 会议之一 ———— Playground，我只是想让大家都知道这个。 有来自市值亿万美元公司的讲者，比如 Instagram，IBM，Meet Up，Lyft，Facebook，Uber。 在这里 [网站](http://www.playgroundscon.com) 你可以了解到更多信息。

[https://twitter.com/playgroundscon](https://twitter.com/playgroundscon)

#### Shoutout

感谢大家给我的支持:

- [Nam-Anh](https://medium.com/u/faa961e18d88)
- [Kevin Curry](https://medium.com/u/c433b47b54de)
- David
- [Akshay Chaudhary](https://medium.com/u/f5e268749caa)

我本周在韩国首尔遇见了 David，他在蓝牙上需要一些帮助，我喜欢说...「😨，让我试试」。

#### 即将开课

我目前正在制作一个课程，和 Bob 一起在 Udemy 上教 UIKit 基本原理，这个课程是为中级 Swift 开发者设计的，目前还没有完成。自上个月以来已经有超过 180 个读者给我发邮件，如果你也想加入我们那就给 bobleesj@gmail.com 发邮件吧，直到课程发布前都是免费的。

#### 辅导

如果你正需要帮助来成为一个 iOS 开发者或者创建你喜欢的应用来帮助大家，请联系我活动更多的细节。
