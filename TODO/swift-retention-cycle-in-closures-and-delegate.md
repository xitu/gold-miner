> * 原文地址：[Swift Retention Cycle in Closures and Delegate](https://blog.bobthedeveloper.io/swift-retention-cycle-in-closures-and-delegate-836c469ef128#.8z0z62321)
> * 原文作者：[Bob Lee](https://blog.bobthedeveloper.io/@bobthedev?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：
> * 校对者：

# Swift Retention Cycle in Closures and Delegate #
# Swift 闭包和代理中的保留周期 # （译者注：感觉翻译成“保留周期”有点别扭。。。）

## Let’s understand [weak self], [unowned self] , and weak var ##
## 让我们一起来弄明白 [weak self], [unowned self] , and weak var ##

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/2000/1*G9ICr1PGK9UexE3uAnavOQ.png">

Lost Ship
迷航的船

### Problem
### 疑问

When I encountered closures and delegate for the first time, I’ve noticed people put `[weak self]` in closures and `weak var` in front a delegate property. I’ve wondered why.
当我第一次遇到闭包和委托时，我注意到人们在闭包中声明 `[weak self]`，在委托属性前声明 `weak var`。我想知道为什么。

### Prerequisite
### 前提

This isn’t a tutorial for beginners. The following list is what I expect from my readers to know.
这不是一篇给初学者的教程。以下列表是我期望我的读者知道的。

1. *How to pass data between view controllers with Delegate*
1. *如何通过代理在两个视图控制器间传值*
2. *Memory management in Swift with ARC.*
2. *Swift 中的内存管理 ARC*
3. Closures capture list
3. 闭包捕获列表
4. *Protocols as Type*
4. *协议类型*

Don’t worry if you aren’t confident with the materials above. I’ve covered all of them in my previous articles and YouTube tutorials. You may find the required knowledge and my productive development tools in a single basket [here](https://learnswiftwithbob.com/RESOURCES.html).
如果你对上面的知识点不确信，别担心。 我以前的文章和 YouTube 教程涵盖了所有这些知识。 你可以在[这里]（https://learnswiftwithbob.com/RESOURCES.html）找到所需的知识以及我高效的开发工具。

### Objectives ###
### Objectives ###

First, you will learn why we use `weak var` in delegate. Second, you will learn when to use `[weak self]` and `[unowned self]` in closures.
首先，你将了解到为什么我们要在代理中使用 `weak var`。接着，你将知道在闭包中何时使用 `[weak self]` 和 `[unowned self]`。

*I like that the content is getting more advanced. We are growing together.*
*我想要这篇内容更加进阶，我们一起进步吧。*
 
### Retention Cycle in Delegate ###
### 代理中的保留周期 ###

First, let’s create a protocol called, `SendDataDelegate`.
首先，我们创建一个`SendDataDelegate` 的代理。

    protocol SendDataDelegate: class {}

Second, let’s create a class called `SendingVC `with a property whose type is `SendDataDelegate?`.
然后，我们创建一个 `SendingVC ` 的类，并添加一个类型是 `SendDataDelegate?` 的属性。

    class SendingVC {
     var delegate: SendDataDelegate?
    }

Last, lets assign the delegate to another class.
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

*You might be baffled by the* `lazy` *init method. Well, you could do your own research or you can wait for my next article.*
*你可能会被 *`lazy` * 的初始化方法所困扰。 那么，你可以自己研究下，或者可以等待我的下一篇文章。*

Now, let’s create an instance.
现在，我们创建一个实例。

    var receivingVC: ReceivingVC? = ReceivingVC()

#### Recap
#### 我来梳理一下

First, `receivingVC` is an instance of `ReceivingVC()`. `ReceivingVC()` has a property, `sendingVC`.
首先，`receivingVC` 是 `ReceivingVC()` 的一个实例，`ReceivingVC()` 有一个属性 `ReceivingVC()`。

Second, `sendingVC` is an instance of `SendingVC()`. `SendingVC()` has a property, `delegate`.
然后，`sendingVC` 是 `SendingVC()` 的一个实例，`SendingVC()` 有一个属性 `delegate`。

I’ve made a simple graph for you to visualize.
我画了个简单的关系图，方便你们理解。

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/1000/1*xCtLEY2ud9Mq97S1tQPz4g.png">


Strong reference cycle and memory leak
循环强引用和内存泄漏

*Make sure you are comfortable with the meaning of strong vs weak reference. If not, you may start with* [*Make Memory Management Great Again*](https://blog.bobthedeveloper.io/make-memory-management-great-again-f781fb29cea1#.2dv5zisgd).
*请确保你熟悉强引用和若引用的涵义。如果不了解的话，你可以看这篇文章 [*Make Memory Management Great Again*](https://blog.bobthedeveloper.io/make-memory-management-great-again-f781fb29cea1#.2dv5zisgd)*。

There is a strong reference between `ReceivingVC` and `SendingVC`. Although `ReceivingVC` is referencing the `delegate` property, not `SendingVC`, **it is considered as referencing the object since you must have an object in order to access its methods and properties.**
在上面的例子中，`ReceivingVC` 和 `SendingVC` 之间存在强引用。虽然 `ReceivingVC` 引用的是 `delegate` 属性，而不是`SendingVC`，**它仍被认为引用了该对象，因为你必须持有一个对象才能访问它的方法和属性。

If you attempt the following code below, nothing happens.
如果您尝试下面的代码，不会有任何反应。

    var receivingVC = nil // not deallocated 
    var receivingVC = nil // 不会被释放

### Introducing weak var
### 介绍 weak var

The only thing that we need to do is, put `weak` in front of `var delegate`.
我们唯一要做的就是把 `weak` 写在 `var delegate` 的前面。

    class SendingVC {
     weak var delegate: SendDataDelegate?
    }

*There is no such thing as* `weak let` *. When you use* `weak`*, just like the delegate property above, the property should be optional and mutable in order to set it as*`nil`*or assign value to the* ` delegate` *property. Consequently,*`let` *is not allowed.*
*没有 `weak let` 这种写法*。当你使用 `weak` 来声明时，就像上面代理属性一样，这个属性应该是可选的和可变的，以便将其置为 `nil`，或者赋值给这个代理属性。因此，`let` 是不允许的。

Let’s see how it looks now.
让我们来看看现在的引用关系图。

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/1000/1*y87pKaXDgoT9EfEQDbLBmg.png">

var delegate has a weak reference to ReceivingVC
delegate 持有 ReceivingVC 的弱引用。

Let’s attempt to get rid of it.
让我们试着释放它。

    receivingVC = nil 
    // "I'm well gone, bruh"
    // 我被释放了，哥们

*You only need to use* `weak` *if the delegate is a class. Swift structs and enums are value types, not reference types, so they don't make strong reference cycles. If you are confused by the previous sentence, you may read* [*Intro to Protocol Oriented Programming*](https://blog.bobthedeveloper.io/introduction-to-protocol-oriented-programming-in-swift-b358fe4974f)
*你只需在代理是个类的时候使用 `weak`*。Swift 中的结构体和枚举类型是值类型，不是引用类型，所以它们不会造成循环强引用。如果你不熟悉协议，可以看下这篇文章：[介绍面向协议编程](https://blog.bobthedeveloper.io/introduction-to-protocol-oriented-programming-in-swift-b358fe4974f)。

**Congratulations! You’ve completed the first objective. Let’s move on.**
**恭喜！你已经完成了第一个目标，让我们来看下一个。**

### Retention Cycle in Closures
### 闭包中的保留周期

Now, let’s look at the second objective. Our goal is to find out why we use `[weak self]` within a closure block. First, let’s create a class called, `BobClass`. It contains two properties whose types are `String` and `(() -> ())?`
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

Let us create an instance.
创建一个实例。

    var bobClass: BobClass? = BobClass()

Let us visualize.
我们来看下关系图。

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/1000/1*vyG--bpwZDKNLGFpfYLPCA.png">

No reference cycle. Unidirectional
没有循环引用，是单向的。

*As you’ve noticed, the closure block is a separate entity from the entire class*
*正如你所注意到的，闭包的代码块是整个类的单独的实体*

Let us destroy.
让我们销毁它

    bobClass = nil // I'm gone... ☠️
    bobClass = nil // 被销毁了。。。☠️

Everything works great. However, we don’t live in an ideal world. What if the closure block has a reference to the property?
一切运行正常。但是，现实和理想总是有差距的。如果这个闭包持有该属性的引用怎么办？

    init() {
     self.bobClosure = { print("\(**self.name**) the Developer") }
    }

Let us visualize.
我们看下关系图

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/1000/1*VeT_-gsbNFhTvPa-JnA4UQ.png">

Strong reference cycle between the closure block and BobClass
闭包和 BobClass 间的循环强引用

Let us destroy
让我们销毁它

    bobClass = nil // Not deallocated 😱
    bobClass = nil // 没有被销毁 😱

It’s urgent. We need do something about it
这很严重。我们需要做些事情。

### Capture List
### 捕获列表

There is one way for us to set the relationship “weak” from the closure block to the object (self). Let us introduce capture lists.
我们有一种方法可以将闭包与对象(self)间的引用关系置为 “weak”，那就是捕获列表。

    self.bobClosure = { **[weak self]** in
     print("\(**self?**.name) the Developer")
    }

The closure block stole and copied the object (self). However, the closure had it `weak`.
闭包拿走并复制了这对象(self)。但是，这个闭包只是弱持有了它。

Let us visualize.
我们看下关系图。

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/1000/1*Zq_QhNaclXkhIraYb2wTKQ.png">

Closure block has a weak reference to object, thus the property as well
闭包弱持有了对象，因此，也弱持有了该属性。

*If you don’t understand what* `[]` *does within the closure above, you may read*[*Swift capture list*](https://blog.bobthedeveloper.io/swift-capture-list-in-closures-e28282c71b95#.hys3jq1jk) *and come back after.*
*如果你不理解 `[]` 在上面的闭包中做了什么，你可以看完这篇 [*Swift capture list*](https://blog.bobthedeveloper.io/swift-capture-list-in-closures-e28282c71b95#.hys3jq1jk) 文章再回来*

**There is something weird.**
**一些奇怪的事情**

All of a sudden, the `self` (object) became an optional type based on `**self?**.name`. Here is why. The closure should be able to break the reference (green arrow) by setting `self` as `nil` within the closure block because the relationship is `weak`. Therefore, Swift automatically converts the type of `self` as optional
突然间，`self`（对象）成了可选类型，写成 `**self?**.name`。这就是为什么闭包能够通过在代码块中将 `self` 置为 `nil` 来断开引用（绿色箭头），因为关系是 `weak`。因此，Swift 会自动将 `self` 转换为可选类型。

Let’s attempt to deallocate
我们来试着销毁它

    bobClass = nil // I'm gone...☠️

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/1000/1*R5nZJi9BngMeia-dQXyhUQ.png">

Good
很好

**Congratulations, you’ve completed the second objective. But, there is just one more: *Unowned.***
**祝贺，你完成了第二个。但是，还有一个：*Unowned*。**

### Unowned
### Unowned

Some of you guys be like, “There is one more? Come on, Bob”. Yeah, there is one more. You’ve come a long way. Let us finish strong.
你们中一些人可能会说，“还有一个？不是吧，Bob”。是的，还有一个。你已经走了很长的路，让我们坚持走完。

`weak` and `unowned` are the same. Except one thing. Unlike `weak` we’ve seen, `unowned` does not automatically convert `self` as optional within the closure block.
`weak` 和 `unowned` 是一样的，除了一点。不像我们所看到的 `weak` 那样，在闭包中，`unowned` 不会自动将 `self` 转化成 可选类型。

For example, if I create a normal instance instead of an optional type,
例如，如果我创建一个正常的实例而不是一个可选的类型。

    var neverNilClass: BobClass = BobClass()

There is no reason to use `weak` because if you do, the closure captures `self` as an optional type and you have to unwrap which is unnecessary like below.
这里没有理由去使用 `weak`，因为如果你这样做，这个闭包会捕获 `self` 作为一个可选的类型，然后你需要像下面那样去解包，这其实没必要。

    self.bobClosure = { [weak self] in

    guard let object = self else {
      return 
     }

    print("\(object.name) the Developer")
    }

Instead, if you are 100% sure that `self` will never be `nil`, then just use
相反，如果你 100％ 确定 `self` 永远不会变成 'nil'，那么只需这样：

    self.bobClosure = { [unowned self] in
     print("\(self.name) the Developer")
    }

> **That’s it.**
> **就这样。**

### Last Remarks
### 写在最后

I hope you guys had fun! By the way, I recently changed the name of the publication from iOS Geek Community to Bob the Developer. There are two reasons. First, the name doesn’t match with the fact that I’m the only author. Second, I want to increase my personal brand to a point I want you guys to associate Swift with Bob the Developer.
我希望你们看得开心！另外，我最近将我的博客的名字从 iOS Geek Community 改成了 Bob the Developer。有两个原因，第一，之前的名字符合只有我一个作者的事实。第二，我想要提高我个人的知名度，我想要你们能够将 Swift 和 Bob the Developer 联系起来。

If you’ve learned something new, I’d appreciate your gratitude by gently tapping the ❤️ below or left. I was thinking of not putting those graphics since it added a lot more time, but anything for my lovely Medium readers.
如果你有所收获，请点击下面或左边的 ❤️ ，我会很感激。我之前在想要不要放那些关系图，因为它需要花费更多的时间，但为了我可爱的 Medium 读者们，一切都值得。

### Resources
### 资源

> [The Resource Page for iOS Developers](https://learnswiftwithbob.com/RESOURCES.html)
> [给 iOS 开发者的资源](https://learnswiftwithbob.com/RESOURCES.html)

> [Source Code](https://github.com/bobthedev/Blog_Reference_Cycle_Delegate_Closures)
> [源码](https://github.com/bobthedev/Blog_Reference_Cycle_Delegate_Closures)

### Bob the Developer
### 关于 Bob the Developer

I work towards providing affordable education. I’ve started with teaching iOS Development. [bobthedeveloper.io](https://bobthedeveloper.io)[Facebook](https://facebook.com/bobthedeveloper), [Instagram](https://instagram.com/bobthedev), [YouTube](https://youtube.com/bobthedeveloper), [LinkedIn](https://linkedin.com/in/bobthedev)
我正在努力提供价格合理的教育工作，并且我已经开始 iOS 开发的教学。[bobthedeveloper.io](https://bobthedeveloper.io)[Facebook](https://facebook.com/bobthedeveloper), [Instagram](https://instagram.com/bobthedev), [YouTube](https://youtube.com/bobthedeveloper), [LinkedIn](https://linkedin.com/in/bobthedev)

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。