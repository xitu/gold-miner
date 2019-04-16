> * 原文地址：[Memory Leaks in Swift: Unit Testing and other tools to avoid them.](https://medium.com/flawless-app-stories/memory-leaks-in-swift-bfd5f95f3a74)
> * 原文作者：[Leandro Pérez](https://medium.com/@leandromperez?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/memory-leaks-in-swift.md](https://github.com/xitu/gold-miner/blob/master/TODO1/memory-leaks-in-swift.md)
> * 译者：[RickeyBoy](https://github.com/rickeyboy)
> * 校对者：[swants](https://github.com/swants), [talisk](https://github.com/talisk)

# Swift 中的内存泄漏

## 通过单元测试等方式避免

![](https://cdn-images-1.medium.com/max/2000/1*7ISuh6UwWtqCmfzSUpyUBw.png)

本篇文章中，我们将探讨内存泄漏，以及学习如何使用单元测试检测内存泄漏。现在我们先来快速看一个例子：

```
describe("MyViewController"){
    describe("init") {
        it("must not leak"){
            let vc = LeakTest{
                return MyViewController()
            }
            expect(vc).toNot(leak())
        }
    }
}
```

这是 [**SpecLeaks**](https://cocoapods.org/pods/SpecLeaks) 中的一个测试。

重点：我将要解释什么是内存泄漏，讨论循环引用以及一些其他你可能早已知道的事情。如果你仅仅想阅读有关对泄漏进行单元测试的部分，直接跳到最后一章即可。

### **内存泄漏**

在实际中，内存泄漏是我们开发者最常面临的问题。随着 app 的成长，我们为 app 开发了一个又一个的功能，却也同时带来了内存泄漏的问题。

内存泄漏就是指内存片段不再会被使用，却被永久持有。它是内存垃圾，不仅占据空间也会导致一些问题。

> 某个时刻被分配过，但又未被释放，并且也不再被你的 app 持有的内存，就是被泄漏的内存。因为它不再被引用，所以现在没有办法释放掉它，它也没有办法被再次使用。
>
> [苹果官方文档](https://developer.apple.com/library/content/documentation/DeveloperTools/Conceptual/InstrumentsUserGuide/CommonMemoryProblems.html)

不论我们是新人还是老手，我们总会在某个时间点创造内存泄漏，这无关我们的经验多少。为了打造一个干净、不崩溃的应用，消除内存泄漏十分重要，因为它们**十分危险**。

### 内存泄漏很危险

内存泄漏不仅会**增加 app 的内存占用**，也会**引入有害的的副作用**甚至**崩溃**。

为什么**内存占用**会不断增长？它是对象没有被释放掉的直接后果。这些对象完全就是内存垃圾，当创建这些对象的操作不断被执行，它们占据的内存就会不断增长。太多的内存垃圾！这可能导致内存警告的情况，并且最终 app 会崩溃。

解释**有害的副作用**需要更详细一点的细节。

假设有一个对象在被创建时的 `init` 方法中开始监听一个通知。它每次监听到通知后的动作就是将一些东西存入数据库中，播放视频或者是对一个分析引擎发布一个事件。由于对象需要被平衡，我们必须要在它被释放时停止监听通知，这在 `deinit` 中实现。

如果这样一个对象泄漏了，会发生什么？

这个对象永远不会被释放，它永远不会停止监听通知。每一次通知被发布，该对象就会响应。如果用户反复执行操作，创建这个有问题的对象，那么就会有多个重复对象存在。所有这些对象都会响应这个通知，并且会彼此影响。

在这种情况下，**崩溃可能是发生的最好情况**。

大量泄漏的对象重复响应了 app 通知，改变数据库、用户界面，使得整个 app 的状态出错。你可以通过 [The Pragmatic Programmer](https://www.goodreads.com/book/show/4099.The_Pragmatic_Programmer) 这篇文章中的 **Dead Programs tell no lies** 了解这类问题的重要性。

内存泄漏毫无疑问会导致非常差的用户体验以及 App Store 上的低分。

### 内存泄漏于何处产生？

比如第三方 SDK 或者框架都可能产生内存泄漏，甚至也包括 Apple 创造的某些类诸如 `CALayer` 或者 `UILabel`。在这些情况下，我们除了等待 SDK 更新或者弃用 SDK 之外别无他法。

但内存泄漏更可能的是由我们自身的代码导致的。**内存泄漏的头号原因则是循环引用**。

为了避免内存泄漏，我们必须理解内存管理和循环引用。

### 循环引用

**循环**这个词来源于 Objective-C 使用手动引用计数的时期。在能够使用自动引用计数和 Swift，以及我们现在针对值类型所能做的一切方便的事情之前，我们使用的是 Objective-C 和手动引用计数。你可以通过 [这篇文章](https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/AutomaticReferenceCounting.html) 了解手动引用计数和自动引用计数。

在那段时期，我们需要对内存处理了解更多。理解分配、拷贝、引用的含义，以及如何平衡这些操作（比如释放）是非常重要的。基本规则是不论你何时创造了一个对象，你就拥有了它并且你需要负责释放掉它。

现在的事情简单很多，但是仍然需要学习一些概念。

Swift 中当一个对象对强关联了另一个对象，就是引用了它。这里说的对象指的是引用类型，基本上就是类。

结构体和枚举都是**值类型**。仅有值类型的话不太可能产生循环引用。当捕获和存储值类型（结构体和枚举）时，并不会有之前说的关于引用的种种问题。值都是被拷贝的，而不是被引用，尽管值也能持有对对象的引用。

当一个对象引用了第二个对象，那么就拥有了它。第二个对象将会一直存在直到它被释放。这被称作**强引用**。直到当你将对应属性设置为 **nil** 时第二个对象才会被销毁。

```
class Server {
}

class Client {
    var server : Server //Strong association to a Server instance
    
    init (server : Server) {
        self.server = server
    }
}
```

强关联。

A 持有 B 并且 B 持有 A 那么就造成了循环引用。

A 👉 B + A 👈 B = 🌀

```
class Server {
    var clients : [Client] // 因为这里是强引用
    
    func add(client:Client){
        self.clients.append(client)
    }
}

class Client {
    var server : Server // 并且这里也是强引用
    
    init (server : Server) {
        self.server = server
        
        self.server.add(client:self) // 这一行产生了循环引用 -> 内存泄漏
    }
}
```

循环引用。

在这个例子中，不论 client 还是 server 都将无法被释放内存。

为了从内存中释放，对象必须首先释放其所有的依赖关系。由于对象本身也是依赖项，因此无法释放。同样，**当一个对象存在循环引用时，它不会被释放**。

当循环引用中的一个引用是**弱引用（weak）或者无主引用（unowned）**的时候，循环引用就可以被打破。有时候由于我们正在编写的代码需要相互关联，因此循环必须存在。但问题就在于不能所有的关联关系都是强关联，其中至少必须有一个是弱关联。

```
class Server {
    var clients : [Client] 
    
    func add(client:Client){
        self.clients.append(client)
    }
}

class Client {
    weak var server : Server! // 此处为弱引用
    
    init (server : Server) {
        self.server = server
        
        self.server.add(client:self) // 现在不存在循环引用了
    }
}
```


弱引用可以打破循环引用。

### 如何打破循环引用

> Swift 提供了两种方式用以解决使用引用类型时导致的的强引用循环：Weak 和 Unowned。
>
> 在循环引用中使用 Weak 以及 Unowned，能让一个实例引用另一个实例时**不再**保持强持有。这样实例之间能够互相引用而不会产生强引用循环。
>
> [Apple’s Swift Programming Language](https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/AutomaticReferenceCounting.html#//apple_ref/doc/uid/TP40014097-CH20-ID48)

**Weak：** 一个变量能够可选地不持有其引用的对象。当变量并不持有其引用对象时，就是弱引用。**弱引用可以为 nil**。

**Unowned：** 和弱引用相似，无主引用也不会强持有其引用的实例。但与弱引用不同的是，无主引用必须是一直有值的。正因如此，无主引用始终被定义为非可选类型。**无主引用不能为 nil**。

[二者的使用时机](https://krakendev.io/blog/weak-and-unowned-references-in-swift)

> 当闭包和它捕获的实例互相引用时，将闭包中的捕获值定义为无主引用，这样他们总是会同时被释放出内存。
>
> 相反的，将闭包中捕获的实例定义为弱引用时，这个捕获的引用有可能在未来变成 `nil`。弱引用始终是一个可选类型，当引用的实例被释放出内存时它就会自动变成 `nil`。
>
> [Apple’s Swift Programming Language](https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/AutomaticReferenceCounting.html)

```
class Parent {
    var child : Child
    var friend : Friend
    
    init (friend: Friend) {
        self.child = Child()
        self.friend = friend
    }
    
    func doSomething() {
        self.child.doSomething( onComplete: { [unowned self] in  
              //The child dies with the parent, so, when the child calls onComplete, the Parent will be alive
              self.mustBeAlive() 
        })
        
        self.friend.doSomething( onComplete: { [weak self] in
            // The friend might outlive the Parent. The Parent might die and later the friend calls onComplete.
              self?.mightNotBeAlive()
        })
    }
}
```

对比弱引用和无主引用。

写代码时忘记使用 `weak self` 的情况并不稀奇。我们经常在写闭包时引入内存泄漏，比如在使用 `flatMap` 和 `map` 这样的函数式代码时，或者是在写消息监听、代理的相关代码时。[这篇文章](https://medium.com/@stremsdoerfer/understanding-memory-leaks-in-closures-48207214cba) 里你可以读到更多关于闭包中内存泄漏的内容。

### 如何消灭内存泄漏？

1. 不要创造出内存泄漏。对内存管理有更深刻的认识。为项目定义完善的 [代码风格](https://swift.org/documentation/api-design-guidelines/%5C)，并且严格遵守。如果你足够严谨，并且遵循你的代码风格，那么缺少 `weak self` 也将容易被发现。代码审查也能提供很大帮助。
2. 使用 [Swift Lint](https://github.com/realm/SwiftLint)。这是一个一个很棒的工具，能够强制你遵循一种代码风格，遵循第一条规则。它能够帮你早在编译期就发现一些问题，比如代理变量声明时并没有被声明为弱引用，这原本可能导致循环引用。
3. 在运行期间检测内存泄漏，并将它们可视化。如果你清楚某个特定的对象在特定时刻有多少实例存在，那么你可以使用 [LifetimeTracker](https://github.com/krzysztofzablocki/LifetimeTracker)。这是一个能在开发模式下运行的好工具。
4. 经常评测 app。Xcode 中的 [内存分析工具](https://developer.apple.com/library/content/documentation/DeveloperTools/Conceptual/InstrumentsUserGuide/CommonMemoryProblems.html) 非常有用，可以参考 [这篇文章](https://useyourloaf.com/blog/xcode-visual-memory-debugger/). 不久之前 Instruments 也是一种方法，这也是非常棒的工具。
5. 使用 [**SpecLeaks**](https://cocoapods.org/pods/SpecLeaks) 对内存泄漏进行单元测试。这个第三方库使用 Quick 和 Nimble 让你方便地对内存泄漏进行测试。你可以在接下来的章节中更多地了解到它。

### 对内存泄漏进行单元测试

一旦我们知道循环和弱引用是怎么一回事，我们就能为循环引用编写测试，方法就是弱引用去检测循环。只需要对某个对象进行弱引用，我们就能测试出该对象是否有内存泄漏。

> 因为弱引用并不会持有其引用的实例，所以当实例被释放出内存时，很可能弱引用仍然指向该实例。因此，**当弱引用引用的对象被释放后，自动引用计数会将弱引用设置为** `nil`。

假设我们想知道 `x` 是否发生了内存泄漏，我们创建了一个指向它的弱引用，叫做 `leakReference`。如果 `x` 被从内存中释放，ARC 会将 `leakReference` 设置为 nil。所以，如果 `x` 发生了内存泄漏，`leakReference` 永远不会被设置为 nil。

```
func isLeaking() -> Bool {
   
    var x : SomeObject? = SomeObject()
  
    weak var leakReference = x
  
    x = nil
    
    if leakReference == nil {
        return false // 没发生内存泄漏
    }
    else{
        return true // 发生了内存泄漏
    }
}
```

测试一个对象是否发生内存泄漏。

如果 `x` 真的发生了内存泄漏，弱引用 `leakReference` 会指向这个发生内存泄漏的实例。另一方面，如果该对象没发生内存泄露，那么在该对象被设置为 nil 之后，它将不再存在。这样的话，`leakReference` 将会为 nil。

”Swift by Sundell” 在 [这篇文章](https://www.swiftbysundell.com/posts/using-unit-tests-to-identify-avoid-memory-leaks-in-swift) 中详细阐述了不同内存泄漏的区别，对我写本文以及 SpecLeaks 都有极大的帮助。另外 [一篇佳作](https://medium.com/wolox-driving-innovation/how-to-automatically-detect-a-memory-leak-in-ios-769b7bb1ec7c) 也采用了类似的方式。

基于这些理论，我写出了 SpecLeacks，一个基于 Quick 和 Nimble、能够检测内存泄漏的拓展。核心就是编写单元测试来检测内存泄漏，不需要大量冗余的样板代码。

### SpecLeaks

结合使用 Quick 和 Nimble 能更好地编写更人性化、可读性更强的单元测试。[SpecLeaks](https://cocoapods.org/pods/SpecLeaks) 只是在这两个框架的基础之上增加了一点点功能，使其能够让你更方便地编写单元测试，来检测是否有对象发生了内存泄漏。

如果你对单元测试并不了解，那么这张截图也许能够给你一个提示，告诉你单元测试做了些什么：

![](https://cdn-images-1.medium.com/max/1000/1*i8K2uBxYToiym52MvIrFFQ.png)

你可以写单元测试来实例化一些对象，并在基于它们做一些尝试。你定义期望的结果，以及怎样的结果才算符合预期，才能通过测试，让测试结果呈现绿色。如果最终结果并不符合最开始定义的预期，那么测试将会失败并呈现出红色。

#### **测试初始化阶段的内存泄漏**

这是检测内存泄漏的测试中，最简单的一个，只需要初始化一个实例并看它是否发生了内存泄漏。有时，这个对象注册了监听事件，或者是有代理方法，或者注册了通知，这些情况下，这类测试就能检测出一些内存泄漏：

```
describe("UIViewController"){
    let test = LeakTest{
        return UIViewController()
    }

    describe("init") {
        it("must not leak"){
            expect(test).toNot(leak())
        }
    }
}
```

测试初始化阶段。

#### 测试 viewController 中的内存泄漏

一个 viewController 可能在它的子视图加载完成后开始发生内存泄漏。在此之后，会发生大量的事情，但是使用这个简单的测试你就能保证在 viewDidLoad 方法中不存在内存泄漏。

```
describe("a CustomViewController") {
    let test = LeakTest{
        let storyboard = UIStoryboard.init(name: "CustomViewController", bundle: Bundle(for: CustomViewController.self))
        return storyboard.instantiateInitialViewController() as! CustomViewController
    }

    describe("init + viewDidLoad()") {
        it("must not leak"){
            expect(test).toNot(leak())
            //SpecLeaks will detect that a view controller is being tested 
            // It will create it's view so viewDidLoad() is called too
        }
    }
}
```

对一个 viewController 的 init 和 viewDidLoad 进行测试。

使用 **SpecLeaks** 你不需要为了使 `viewDidLoad` 方法被调用而手动调用 viewController 上的 `view`。当你测试 `UIViewController` 的子类时 SpecLeaks 将会替你做这些。

#### 测试方法被调用时的内存泄漏

有时候初始化一个实例并不能判断是否发生了内存泄漏，因为内存泄漏有可能在某个方法被调用的时候发生。在这种情况下，你可以在操作被执行的时候测试是否有内存泄漏，像这样：

```
describe("doSomething") {
    it("must not leak"){
        
        let doSomething : (CustomViewController) -> () = { vc in
            vc.doSomething()
        }

        expect(test).toNot(leakWhen(doSomething))
    }
}
```

检测自定义 viewController 是否在 `doSomething` 方法被调用时发生内存泄漏。

### 总结一下

内存泄漏能产生大量问题，他们会导致极差的用户体验、崩溃和 App Store 中的差评，我们必须要消除它们。良好的代码风格、良好的实践、对内存管理透彻的理解以及单元测试都能起到有效的帮助。

但是单元测试并不能保证内存测试完全不发生，你并不能覆盖所有的方法调用和状态，测试每一个存在与其他对象相互作用的东西是不太可能的。另外，有时候必须要模拟依赖，才能发现原始的依赖可能发生的内存泄漏。

单元测试确实能降低发生内存泄漏的可能性，使用 [**SpeakLeaks**](https://cocoapods.org/pods/SpecLeaks) 可以非常方便的检测、发现出闭包中的内存泄漏，就比如 `flatMap` 或者是其他持有了 `self` 的逃逸闭包。如果你忘记将代理声明为弱引用也是同样的道理。

我大量地使用了 RxSwift，以及 faltMap、map、subscribe 和一些其他需要传递闭包的函数。在这些情况下，缺少 weak 或 unowned 经常会导致内存泄漏，而使用 SpecLeaks 就能轻易的检测出来。

就个人而言，我始终尝试在我的所有类之中增加这样的测试。例如每当我创造一个 viewController，我就会为它创造一份 SpecLeaks 代码。有时候 viewController 会在加载视图时发生内存泄漏，用这类测试就能轻而易举地发现。

那么你意下如何？你会为检测内存泄漏而写单元测试吗？你会写测试吗？

我希望你喜欢阅读本文，如果你有任何的建议和疑问都可以给我回复！请尽情尝试 SpeckLeaks :)

* * *

感谢 [Flawless App](https://medium.com/@FlawlessApp?source=post_page)。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
