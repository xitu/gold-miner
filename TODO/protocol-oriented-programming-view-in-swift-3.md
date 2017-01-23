> * 原文链接: [Protocol Oriented Programming View in Swift 3](https://medium.com/ios-geek-community/protocol-oriented-programming-view-in-swift-3-8bcb3305c427#.nxlwj0t9f)
* 原文作者 : [Bob Lee](https://medium.com/@bobleesj)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [洪朔](http://www.tuccuay.com)
* 校对者 :

# 在 Swift 3 上对视图控件实践面向协议编程

## 学习如何对 `button`, `label`, `imageView` 创建动画而不制造一串乱七八糟的类

![](https://cdn-images-1.medium.com/max/2000/1*s_XZ1RzyZgyON36tM4zZCA.png)

光说不做嘴把式。那好，我们要怎样开始在我的应用中实践面向协议编程？🤔

为了能更加高效的理解下面的内容，我希望读者能够明白 `Complection Handlers`，并且能创建协议的基本实现。如果你还不熟悉他们，可以先阅读下面的文章再回来接着看：

前景提要：

- [Intro to Protocol Oriented Programming](https://medium.com/ios-geek-community/introduction-to-protocol-oriented-programming-in-swift-b358fe4974f)

- [Protocol Oriented Programming Series](https://www.youtube.com/playlist?list=PL8btZwalbjYm5xDXDURW9u86vCtRKaHML)

### 看完这篇文章你会学到这些内容

你将会明白如何使用协议给 `UIButton`, `UILabel`, `UIImageView` 等 UI 组件添加动画，同时我也会给你演示传统方法和使用 POP 方法之间的差异。😎

### UI

这个演示程序名为「欢迎来到我家的聚会」。我将会使用这个应用程序来验证你是否获得邀请，你必须输入你的邀请码。**这个应用并没有逻辑判断，所以只要你按下按钮，无论如何动画都将会被执行。** 将会有 `passcodeTextField`, `loginButton`, `errorMessageLabel` 和 `profileImageView` 四个组件将会参与动画过程。

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

看到我们是如何写**重复的代码**了吗？这个动画逻辑一共有 5 行，更好的选择是使用 `extension`，因为 `UILabel` 和 `UIButton` 都继承自 `UIView`，我们可以给它添加这样的扩展：

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

So, any UIComponents that conform to the `Buzzable` protocol would have the `buzz` method associated. Unlike `extension` only those who conform to the protocol will have that method. Also, `where Self: UIView` is used to indicate that the protocol should be only conformed to `UIView` or components that inherit from `UIView`

Now, that’s it. Let’s apply Buzzable to `loginButton`, `passcodeTextField`, `errorMessageLabel`, and `profileImageView` But, wait, how about Poppable?

Well, same thing.

    protocol Poppable {}

    extension Poppable where Self: UIView {
     func pop() { // Pop Animation Logic }
    }

Now, it’s time to make it real!

```
class BuzzableTextField: UITextField, Buzzable {}
class BuzzableButton: UIButton, Buzzable {}
class BuzzableImageView: UIImageView, Buzzable {}
class BuzzablePoppableLabel: UILabel, Buzzable, Poppable {}

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

The cool thing about POP is that you can even apply `pop` to any other UIComponents without subclassing at all.

    class MyImageView: UIImageVIew, Buzzable, Poppable

Now, the name of the class can be more flexible because you already know available methods based on the protocols you conform, and the name of each protocol describe the class. So, you no longer have write something like, `MyBuzzablePoppableProfileImage.`

**Too long, didn’t read:**

No more Subclassing

Flexible Class Name

Feel caught up as a Swift Developer

### Next Step

Once I get **200 likes **on this article, and you want to learn how to apply POP to `UITableView` and `UICollectionView`, make sure follow me on Medium!

#### Resource

[Source Code](https://github.com/bobleesj/Blog_Protocol_Oriented_View)

### Last Remarks

I hope you’ve learned something new with me. If you have, please tap that ❤️ to indicate, “yes”. If you’ve found this implementation useful, make sure **share** so that iOS developers all around the world begin to use Protocol Oriented Views to write fewer lines of code and modularize. Come back on Sat 8am EST!

### Swift Conference

[Andyy Hope](https://medium.com/u/99c752aeaa48), a friend of mine, is currently organizing one of the largest and greatest Swift Conferences at Melbourne, Australia. It’s called Playgrounds. I just wanted to help out with spreading the word. There are speakers from mega-billion dollar companies such as Instagram, IBM, Meet up, Lyft, Facebook, Uber. Here is the [website](http://www.playgroundscon.com) for more info.

[https://twitter.com/playgroundscon](https://twitter.com/playgroundscon)

#### Shoutout

Thanks to my VIPs: [Nam-Anh](https://medium.com/u/faa961e18d88), [Kevin Curry](https://medium.com/u/c433b47b54de), David, [Akshay Chaudhary](https://medium.com/u/f5e268749caa) for their support. I’ve met David this week in Seoul, Korea. He needed some help with Bluetooth… I’m like, “😨, let me try”.

#### Upcoming Course

I’m currently creating a course called, The UIKit Fundamentals with Bob on Udemy. This course is designed for Swift intermediates. It’s not one of those “Complete Courses”. It’s specific. Over 180 readers have sent me emails since last month. If interested, join me for free until released: bobleesj@gmail.com

#### Coaching

If you are looking for help to switch your career as an iOS developer or create your dream apps that would help the world, contact me for more detail.
