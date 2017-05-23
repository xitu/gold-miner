> * 原文地址：[Swift Lazy Initialization with Closures][1]
> * 原文作者：本文已获原作者 [Bob Lee][2] 授权
> * 译文出自：[掘金翻译计划][3]
> * 译者：[lsvih][4]
> * 校对者：[zhangqippp](https://github.com/zhangqippp),[Zheaoli](https://github.com/Zheaoli)

# 在 Swift 中使用闭包实现懒加载

## 学习如何兼顾模块化与可读性来创建对象

![](https://cdn-images-1.medium.com/max/2000/1*KNmIy5QAOeokXPW86TtVyA.png)

（图为苹果的 Magic Keyboard 2 与 Magic Mouse 2）

**亲爱的读者你们好！我是 Bob，很高兴能在这篇文章中与你们相遇！如你想加入我的邮件列表，获取更多学习 iOS 开发的文章，请点击**[**这儿**][5]**注册，很快就能完成的哦 :)**

### 动机

在我刚开始学习 iOS 开发的时候，我在 YouTube 上找了一些教程。我发现这些教程有时候会用下面这种方式来创建 UI 对象:

```
let makeBox: UIView = {
 let view = UIView()
 return view
}()
```

作为一个初学者，我自然而然地复制并使用了这个例子。直到有一天，我的一个读者问我：“为什么你要加上`{}`呢？最后为什么要加上一对`()`呢？这是一个计算属性吗？”我哑口无言，因为我自己也不知道答案。

因此，我为过去年轻的自己写下了这份教程。说不定还能帮上其他人的忙。

### 目标

这篇教程有一下三个目标：第一，了解如何像前面的代码一样，非常规地创建对象；第二，知道编在写 Swfit 代码时，什么时候该使用 `lazy var`；第三，快加入我的邮件列表呀。

#### 预备知识

为了让你能轻松愉快地和我一起完成这篇教程，我强烈推荐你先了解下面这几个概念。

1. [**闭包**][6]
2. [**捕获列表与循环引用 \[weak self\]** ][7]
3. **面向对象程序设计**

### 创建 UI 组件

在我介绍“非常规”方法之前，让我们先复习一下“常规”方法。在 Swift 中，如果你要创建一个按钮，你应该会这么做：

```
// 设定尺寸
let buttonSize = CGRect(x: 0, y: 0, width: 100, height: 100)

// 创建控件
let bobButton = UIButton(frame: buttonSize)
bobButton.backgroundColor = .black
bobButton.titleLabel?.text = "Bob"
bobButton.titleLabel?.textColor = .white
```

这样做**没问题**。

假设现在你要创建另外三个按钮，你很可能会把上面的代码复制，然后把变量名从 `bobButton` 改成 `bobbyButton`。

这未免也太枯燥了吧。

```
// New Button 
let bobbyButton = UIButton(frame: buttonSize)
bobbyButton.backgroundColor = .black
bobbyButton.titleLabel?.text = "Bob"
bobbyButton.titleLabel?.textColor = .white
```

为了方便，你可以：

![](https://cdn-images-1.medium.com/max/800/1*oDIPy0i4YzUnKVR4XYI4kg.gif)

使用快捷键：ctrl-cmd-e 来完成这个工作。

如果你不想做重复的工作，你也可以创建一个函数。

```
func createButton(enterTitle: String) -> UIButton {
 let button = UIButton(frame: buttonSize)
 button.backgroundColor = .black
 button.titleLabel?.text = enterTitle
 return button
}
createButton(enterTitle: "Yoyo") //  👍
```

然而，在 iOS 开发中，很少会看到一堆一模一样的按钮。因此，这个函数需要接受更多的参数，如背景颜色、文字、圆角尺寸、阴影等等。你的函数最后可能会变成这样：

```
func createButton(title: String, borderWidth: Double, backgrounColor, ...) -> Button 
```

但是，即使你为这个函数加上了默认参数，上面的代码依然不理想。这样的设计降低了代码的可读性。因此，比起这个方法，我们还是采用上面那个”单调“的方法为妙。

到底有没有办法让我们既不那么枯燥，还能让代码更有条理呢？当然咯。我们现在只是复习你过去的做法——是时候更上一层楼，展望你未来的做法了。

### 介绍”非常规“方法

在我们使用”非常规“方法创建 UI 组件之前，让我们先回答一下最开始那个读者的问题。`{}`是什么意思，它是一个`计算属性`吗？

**当然不是，它只是一个闭包**。

首先，让我来示范一下如何用闭包来创建一个对象。我们设计一个名为`Human`的结构：

```
struct Human {
 init() {
  print("Born 1996")
 }
}
```

现在，让你看看怎么用闭包创建对象：

```
let createBob = { () -> Human in
 let human = Human()
 return human
}

let babyBob = createBob() // "Born 1996"
```

**如果你不熟悉这段语法，请先停止阅读这篇文章，去看看** [**Fear No Closure with Bob**][8] **充充电吧。**

解释一下，`createBob` 是一个类型为 `()-> Human` 的闭包。你已经通过调用 `createBob()` 创建好了一个 `babyBob` 实例。

然而，这样做你创建了两个常量：`createBob` 与 `babyBob`。如何把所有的东西都放在一个声明中呢？请看：

```
let bobby = { () -> Human in
 let human = Human()
 return human
}()
```

现在，这个闭包通过在最后加上 `()` 执行了自己，`bobby` 现在被赋值为一个 `Human` 对象。干的漂亮！

**现在你已经学会了使用闭包来创建一个对象**

让我们应用这个方法，模仿上面的例子来创建一个 UI 对象吧。

```
let bobView = { () -> UIView in
 let view = UIView()
 view.backgroundColor = .black
 return view
}()
```
很好，我们还能让它更简洁。实际上，我们不需要为闭包指定类型，我们只需要指定 `bobView` 实例的类型就够了。例如：

```
let bobbyView: **UIView** = {
 let view = UIView()
 view.backgroundColor = .black
 return view
}()
```

Swift 能够通过关键字 `return` 推导出这个闭包的类型是 `() -> UIView`。

现在看看，上面的例子已经和我之前害怕的“非常规方式”一样了。

### 使用闭包创建的好处

我们已经讨论了直接创建对象的单调和使用构造函数带来的问题。现在你可能会想“为什么我非得用闭包来创建？”

#### 重复起来更容易

我不喜欢用 Storyboard，我比较喜欢复制粘贴用代码来创建 UI 对象。实际上，在我的电脑里有一个“代码库”。假设库里有个按钮，代码如下：

```
let myButton: UIButton = {
 let button = UIButton(frame: buttonSize)
 button.backgroundColor = .black
 button.titleLabel?.text = "Button"
 button.titleLabel?.textColor = .white
 button.layer.cornerRadius = 
 button.layer.masksToBounds = true
return button
}()
```

我只需要把它整个复制，然后把名字从 `myButton` 改成 `newButtom` 就行了。在我用闭包之前，我得重复地把 `myButton` 改成 `newButtom` ，甚至要改上七八遍。我们虽然可以用 Xcode 的快捷键，但为啥不使用闭包，让这件事更简单呢？

#### 看起来更简洁

由于对象对象会自己编好组，在我看来它更加的简洁。让我们对比一下：

```
// 使用闭包创建 
let leftCornerButton: UIButton = {
 let button = UIButton(frame: buttonSize)
 button.backgroundColor = .black
 button.titleLabel?.text = "Button"
 button.titleLabel?.textColor = .white
 button.layer.cornerRadius = 
 button.layer.masksToBounds = true
return button
}()

let rightCornerButton: UIButton = {
 let button = UIButton(frame: buttonSize)
 button.backgroundColor = .black
 button.titleLabel?.text = "Button"
 button.titleLabel?.textColor = .white
 button.layer.cornerRadius = 
 button.layer.masksToBounds = true
return button
}()
```

vs

```
// 手动创建
let leftCornerButton = UIButton(frame: buttonSize)
leftCornerButton.backgroundColor = .black
leftCornerButton.titleLabel?.text = "Button"
leftCornerButton.titleLabel?.textColor = .white
leftCornerButton.layer.cornerRadius = 
leftCornerButton.layer.masksToBounds = true

let rightCornerButton = UIButton(frame: buttonSize)
rightCornerButton.backgroundColor = .black
rightCornerButton.titleLabel?.text = "Button"
rightCornerButton.titleLabel?.textColor = .white
rightCornerButton.layer.cornerRadius = 
rightCornerButton.layer.masksToBounds = true
```

尽管使用闭包创建对象要多出几行，但是比起要在 `rightCornerButton` 或者 `leftCornerButton` 后面狂加属性，我还是更喜欢在 `button` 后面加属性。

**实际上如果按钮的命名特别详细时，用闭包创建对象还可以少几行。**

**恭喜你，你已经完成了我们的第一个目标**

### 懒加载的应用

辛苦了！现在让我们来看看这个教程的第二个目标吧。

你可能看过与下面类似的代码：

```
class IntenseMathProblem {
 lazy var complexNumber: Int = {
  // 请想象这儿要耗费很多CPU资源
  1 * 1
 }()
}
```

`lazy` 的作用是，让 `complexNumber` 属性只有在你试图访问它的时候才会被计算。例如：

```
let problem = IntenseMathProblem 
problem()  // 此时complexNumber没有值
```

没错，现在 `complexNumber` 没有值。然而，一旦你访问这个属性：

```
problem().complexNumber // 现在回返回1
```

`lazy var` 经常用于数据库排序或者从后端取数据，因为你并不想在创建对象的时候就把所有东西都计算、排序。

**实际上，由于对象太大了导致 RAM 撑不住，你的手机就会崩溃。**

### 应用

以下是 `lazy var` 的应用：

#### 排序

```
class SortManager {
 lazy var sortNumberFromDatabase: [Int] = {
  // 排序逻辑
  return [1, 2, 3, 4]
 }()
}
```

#### 图片压缩

```
class CompressionManager {
 lazy var compressedImage: UIImage = {
  let image = UIImage()
  // 压缩图片的
  // 逻辑
  return image
 }()
}
```

### `Lazy`的一些规定

1. 你不能把 `lazy` 和 `let` 一起用，因为用 `lazy` 时没有初值，只有当被访问时才会获得值。
2. 你不能把它和 `计算属性` 一起用，因为在你修改任何与 `lazy` 的计算属性有关的变量时，计算属性都会被重新计算（耗费 CPU 资源）。
3. `Lazy` 只能是结构或类的成员。

### Lazy 能被捕获吗？

如果你读过我的前一篇文章[《Swift 闭包和代理中的循环引用》][9]，你就会明白这个问题。让我们试一试吧。创建一个名叫 `BobGreet` 的类，它有两个属性：一个是类型为 `String` 的 `name`，一个是类型为 `String` 但是使用闭包创建的 `greeting`。

```
class BobGreet {
 var name = "Bob the Developer"
 lazy var greeting: String = {
  return "Hello, \(self.name)"
 }()

deinit { 
  print("I'm gone, bruh 🙆")}
 }
}
```

闭包**可能**对 `BobGuest` 有强引用，让我们尝试着 deallocate 它。

```
var bobGreet: BobGreet? = BobClass()
bobGreet?.greeting
bobClass = nil // I'm gone, bruh 🙆
```

不用担心 `[unowned self]`，闭包并没有对对象存在引用。相反，它仅仅是在闭包内复制了 `self`。如果你对前面的代码声明有疑问，可以读读 [Swift Capture Lists][10] 来了解更多这方面的知识。👍

### 最后的唠叨

我在准备这篇教程的过程中也学到了很多，希望你也一样。感谢你们的热情❤️！不过这篇文章还剩一点：我的最后一个目标。如果你希望加入我的邮件列表以获得更多有价值的信息的话，你可以点 [**这里**][11]注册。

正如封面照片所示，我最近买了 Magic Keyboard 和 Magic Mouse。它们超级棒，帮我提升了很多的效率。你可以在 [这儿][12]买鼠标，在 [这儿][13]买键盘。我才不会因为它们的价格心疼呢。😓

> [本文的源码][14] 

### 我将要参加 Swift 讨论会 

我将在 6 月 1 日至 6 月 2 日 参加我有生以来的第一次讨论会 @[SwiftAveir][15]， 我的朋友 [Joao][16]协助组织了这次会议，所以我非常 excited。你可以点[这儿][17]了解这件事 的详情！

#### 文章推荐

> 函数式编程简介 ([Blog][18])

> 我最爱的 XCode 快捷键 ([Blog][19] )

### 关于我 

我是一名来自首尔的 iOS 课程教师，你可以在 [Instagram][20] 上了解我。我会经常在 [Facebook Page][21] 投稿，投稿时间一般在北京时间上午9点（Sat 8pm EST）。

---

> [掘金翻译计划][22] 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金][23] 上的英文分享文章。内容覆盖 [Android][24]、[iOS][25]、[React][26]、[前端][27]、[后端][28]、[产品][29]、[设计][30] 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划][31]。

[1]:	https://blog.bobthedeveloper.io/swift-lazy-initialization-with-closures-a9ef6f6312c
[2]:	https://blog.bobthedeveloper.io/@bobthedev
[3]:	https://github.com/xitu/gold-miner
[4]:	https://github.com/lsvih
[5]:	https://boblee.typeform.com/to/oR9Nt2
[6]:	https://blog.bobthedeveloper.io/no-fear-closure-in-swift-3-with-bob-72a10577c564
[7]:	https://juejin.im/post/58e4ac5d44d904006d2a9a19
[8]:	https://blog.bobthedeveloper.io/no-fear-closure-in-swift-3-with-bob-72a10577c564
[9]:	https://juejin.im/post/58e4ac5d44d904006d2a9a19
[10]:	https://blog.bobthedeveloper.io/swift-capture-list-in-closures-e28282c71b95
[11]:	https://boblee.typeform.com/to/oR9Nt2
[12]:	http://amzn.to/2noHxgl
[13]:	http://amzn.to/2noHxgl
[14]:	https://github.com/bobthedev/Blog_Lazy_Init_with_Closures
[15]:	https://twitter.com/SwiftAveiro
[16]:	https://twitter.com/NSMyself
[17]:	http://swiftaveiro.xyz
[18]:	https://blog.bobthedeveloper.io/intro-to-swift-functional-programming-with-bob-9c503ca14f13
[19]:	https://blog.bobthedeveloper.io/intro-to-swift-functional-programming-with-bob-9c503ca14f13
[20]:	https://instagram.com/bobthedev
[21]:	https://facebook.com/bobthedeveloper
[22]:	https://github.com/xitu/gold-miner
[23]:	https://juejin.im
[24]:	https://github.com/xitu/gold-miner#android
[25]:	https://github.com/xitu/gold-miner#ios
[26]:	https://github.com/xitu/gold-miner#react
[27]:	https://github.com/xitu/gold-miner#%E5%89%8D%E7%AB%AF
[28]:	https://github.com/xitu/gold-miner#%E5%90%8E%E7%AB%AF
[29]:	https://github.com/xitu/gold-miner#%E4%BA%A7%E5%93%81
[30]:	https://github.com/xitu/gold-miner#%E8%AE%BE%E8%AE%A1
[31]:	https://github.com/xitu/gold-miner
