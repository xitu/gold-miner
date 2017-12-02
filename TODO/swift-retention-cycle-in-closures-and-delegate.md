> * 原文地址：[Swift Retention Cycle in Closures and Delegate](https://blog.bobthedeveloper.io/swift-retention-cycle-in-closures-and-delegate-836c469ef128#.8z0z62321)
> * 原文作者：[Bob Lee](https://blog.bobthedeveloper.io/@bobthedev?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：[oOatuo](https://github.com/atuooo)
> * 校对者：[Deepmissea](http://deepmissea.blue/), [gy134340](http://gy134340.com/)

# Swift 闭包和代理中的保留周期 

## 让我们一起来弄明白 [weak self]、[unowned self] 和 weak var ##

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/2000/1*G9ICr1PGK9UexE3uAnavOQ.png">

迷航的船

### 疑问

当我第一次遇到闭包和代理时，我注意到人们在闭包中声明 `[weak self]`，在委托属性前声明 `weak var`。我想知道为什么。

### 前提

这不是一篇给初学者的教程。以下列表是我期望我的读者知道的。

1. **如何通过代理在两个视图控制器间传值**
2. **在 Swift 中使用 ARC 管理内存**
3. 闭包捕获列表
4. **协议作为类型**

如果你不是很熟悉上面的知识点，别担心。我以前的文章和 YouTube 教程涵盖了所有这些知识。你可以在 [这里](https://learnswiftwithbob.com/RESOURCES.html) 找到所需的知识以及我高效的开发工具。

### Objectives ###

首先，你将了解到为什么我们要在代理中使用 `weak var`。接着，你将知道何时在闭包中使用 `[weak self]` 和 `[unowned self]`。

**我想要这篇内容更加进阶，我们一起进步吧。**
 
### 代理中的保留周期 ###

首先，我们创建一个 `SendDataDelegate` 的代理。

    protocol SendDataDelegate: class {}

然后，我们创建一个 `SendingVC ` 的类，并添加一个类型是 `SendDataDelegate?` 的属性。

    class SendingVC {
     var delegate: SendDataDelegate?
    }

最后，将这个代理指向另一个类。

    class ReceivingVC: SendDataDelegate {
     lazy var sendingVC: SendingVC = {
      let vc = SendingVC()
      vc.delegate = self // self refers to ReceivingVC object
      return vc
     }()

    deinit {
     print("I'm well gone, bruh")
     }
    }

**你可能会被 `lazy` 的初始化方法所困扰。那么，你可以先自己研究下，或者可以等我的下一篇文章。**

现在，我们创建一个实例。

    var receivingVC: ReceivingVC? = ReceivingVC()

#### 我来梳理一下

首先，`receivingVC` 是 `ReceivingVC()` 的一个实例，`ReceivingVC()` 有一个属性 `ReceivingVC()`。

然后，`sendingVC` 是 `SendingVC()` 的一个实例，`SendingVC()` 有一个属性 `delegate`。

我画了个简单的关系图，方便你们理解。

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/1000/1*xCtLEY2ud9Mq97S1tQPz4g.png">

循环强引用和内存泄漏

**请确保你熟悉强引用和弱引用的涵义。如果不了解的话，你可以看这篇文章 [Make Memory Management Great Again](https://blog.bobthedeveloper.io/make-memory-management-great-again-f781fb29cea1#.2dv5zisgd)。**

在上面的例子中，`ReceivingVC` 和 `SendingVC` 之间存在强引用。虽然 `ReceivingVC` 引用的是 `delegate` 属性，而不是 `SendingVC`，**它仍被认为引用了该对象，因为你必须持有一个对象才能访问它的方法和属性。**

如果您尝试下面的代码，不会有任何反应。

    var receivingVC = nil // 不会被释放

### 介绍 weak var

我们唯一要做的就是把 `weak` 写在 `var delegate` 的前面。

    class SendingVC {
     weak var delegate: SendDataDelegate?
    }

**没有 `weak let` 这种写法**。当你使用 `weak` 来声明时，就像上面代理属性一样，这个属性应该是可选的和可变的，以便将其置为 `nil`，或者赋值给这个代理属性。因此，`let` 是不允许的。

让我们来看看现在的引用关系图。

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/1000/1*y87pKaXDgoT9EfEQDbLBmg.png">

delegate 持有 ReceivingVC 的弱引用。

让我们试着释放它。

    receivingVC = nil 
    // "I'm well gone, bruh"

**你只需在代理的对象是个类的时候使用 `weak`**。Swift 中的结构体和枚举类型是值类型，不是引用类型，所以它们不会造成循环强引用。如果你不熟悉协议，可以看下这篇文章：[介绍面向协议编程](https://blog.bobthedeveloper.io/introduction-to-protocol-oriented-programming-in-swift-b358fe4974f)。

**恭喜！你已经完成了第一个目标，让我们来看下一个。**

### 闭包中的保留周期

现在，让我们一起看下第二个目标。我们的目的是弄明白为什么要在一个闭包中使用 `[weak self]`。首先，我们创建一个 `BobClass` 的类。它包含两个 `String` 和 `(() -> ())?` 类型的属性。

    class BobClass {
     var bobClosure: (() -> ())? 
     var name = “Bob”

     init() {
      self.bobClosure = { print(“Bob the Developer”) }
     }

     deinit {
      print(“I’m gone... ☠️”)
     }

    }

创建一个实例。

    var bobClass: BobClass? = BobClass()

我们来看下关系图。

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/1000/1*vyG--bpwZDKNLGFpfYLPCA.png">

没有循环引用，是单向的。

**正如你所注意到的，闭包的代码块是整个类的单独的实体**

让我们销毁它

    bobClass = nil // 被销毁了。。。☠️

一切运行正常。但是，现实和理想总是有差距的。如果这个闭包持有该属性的引用怎么办？

    init() {
     self.bobClosure = { print("\(**self.name**) the Developer") }
    }

我们看下关系图

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/1000/1*VeT_-gsbNFhTvPa-JnA4UQ.png">

闭包和 BobClass 间的循环强引用

让我们销毁它

    bobClass = nil // 没有被销毁 😱

这很严重。我们需要做些事情。

### 捕获列表

我们有一种方法可以将闭包与对象(self)间的引用关系置为 “weak”，那就是捕获列表。

    self.bobClosure = { [weak self] in
     print("\(self?.name) the Developer")
    }

闭包拿走并复制了这对象(self)。但是，这个闭包只是弱持有了它。

我们看下关系图。

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/1000/1*Zq_QhNaclXkhIraYb2wTKQ.png">

闭包弱持有了对象，因此，也弱持有了该属性。

**如果你不理解 `[]` 在上面的闭包中做了什么，你可以看完这篇 [Swift capture list](https://blog.bobthedeveloper.io/swift-capture-list-in-closures-e28282c71b95#.hys3jq1jk) 文章再回来。**

**一些奇怪的事情**

突然间，`self`（对象）成了可选类型，写成 **`self?.name`**。这就是为什么闭包能够通过在代码块中将 `self` 置为 `nil` 来断开引用（绿色箭头），因为关系是 `weak`。因此，Swift 会自动将 `self` 转换为可选类型。

我们来试着销毁它

    bobClass = nil // I'm gone...☠️

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/1000/1*R5nZJi9BngMeia-dQXyhUQ.png">

很好

**祝贺，你完成了第二个。但是，还有一个：Unowned。**

### Unowned

你们中一些人可能会说，“还有一个？不是吧，Bob”。是的，还有一个。你已经走了很长的路，让我们坚持走完。

`weak` 和 `unowned` 是一样的，除了一点，不像我们所看到的 `weak` 那样，在闭包中，`unowned` 不会自动将 `self` 转化成 可选类型。

例如，如果我创建一个正常的实例而不是一个可选的类型。

    var neverNilClass: BobClass = BobClass()

这里没有理由去使用 `weak`，因为如果你这样做，这个闭包会捕获 `self` 作为一个可选的类型，然后你需要像下面那样去解包，这其实没必要。

    self.bobClosure = { [weak self] in

    guard let object = self else {
      return 
     }

    print("\(object.name) the Developer")
    }

相反，如果你 100％ 确定 `self` 永远不会变成 'nil'，那么只需这样：

    self.bobClosure = { [unowned self] in
     print("\(self.name) the Developer")
    }

> **就这样。**

### 写在最后

我希望你们看得开心！另外，我最近将我的博客的名字从 iOS Geek Community 改成了 Bob the Developer。有两个原因，第一，之前的名字不符合只有我一个作者的事实。第二，我想将我个人品牌提高到一定的程度，让你们能够将 Swift 和 Bob the Developer 联系起来。

如果你有所收获，请点击下面或左边的 ❤️ ，我会很感激。我之前在想要不要放那些关系图，因为它需要花费更多的时间，但为了我可爱的 Medium 读者们，一切都值得。

### 资源

> [给 iOS 开发者的资源](https://learnswiftwithbob.com/RESOURCES.html)

> [源码](https://github.com/bobthedev/Blog_Reference_Cycle_Delegate_Closures)

### 关于 Bob the Developer

我正在努力提供价格合理的教育工作，并且我已经开始 iOS 开发的教学。[bobthedeveloper.io](https://bobthedeveloper.io)[Facebook](https://facebook.com/bobthedeveloper), [Instagram](https://instagram.com/bobthedev), [YouTube](https://youtube.com/bobthedeveloper), [LinkedIn](https://linkedin.com/in/bobthedev)

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。