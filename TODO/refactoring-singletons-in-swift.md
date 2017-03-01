> * 原文地址：[Refactoring singleton usage in Swift](http://www.jessesquires.com/refactoring-singletons-in-swift/)
* 原文作者：[Jesse Squires](http://www.jessesquires.com/)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[karthus](https://github.com/karthus1110)
* 校对者：[xiaoheiai4719](https://github.com/xiaoheiai4719)，[skyar2009](https://github.com/skyar2009)

# [重构 Swift 中单例的用法](Refactoring singleton usage in Swift) #

## 使代码库更加简洁、模块化、和可测试的技巧 2017 年 2 月 10 日 ##

在软件开发中，[单例模式](https://en.wikipedia.org/wiki/Singleton_pattern)有足够的原因被广泛的[不推荐](https://www.objc.io/issues/13-architecture/singletons/)和[不赞成](http://coliveira.net/software/day-19-avoid-singletons/)。它们难以测试或者说是不可能测试，当它们在其他类中隐式调用时会使你的代码库混乱，让代码难以复用。大部分时候，一个单例其实就相当于一个伪全局变量。每个人都知道，至少知道这是一个糟糕的主意。然而，单例有时又是不可避免且必须的。我们如何能把它们用一种整洁、模块化的和可测试化的方法整合到我们的代码中呢？

### 随处可见的单例 ###

在苹果平台，单例在 Cocoa 还有 Cocoa Touch 框架中随处可见。比如 `UIApplication.shared`，`FileManager.default`，`NotificationCenter.default`， `UserDefaults.standard`，`URLSession.shared` 等等。这个设计模式甚至在 [*Cocoa Core Competencies*](https://developer.apple.com/library/content/documentation/General/Conceptual/DevPedia-CocoaCore/Singleton.html#//apple_ref/doc/uid/TP40008195-CH49-SW1) 指导中有自己的章节。

当你隐式的引用这些单例，还有你自己的单例的时候，会增加你更新维护代码的工作量。它还会让你的代码难以测试，因为并没有任何方法在单例的使用类的外面去改变或者模拟这些单例。下面是我们在 iOS app 中常见的用法：
```
class MyViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let currentUser = CurrentUserManager.shared.user
        if currentUser != nil {
            // do something with current user
        }

        let mySetting = UserDefaults.standard.bool(forKey: "mySetting")
        if mySetting {
            // do something with setting
        }

        URLSession.shared.dataTask(with: URL(string: "http://someResource")!) { (data, response, error) in
            // handle response
        }
    }
}
```

这就是我所说的**隐式引用** - 你简单的在类中直接使用单例。我们可以做到更好。我们有更简单、轻量级、低影响的方式在 Swift 中进行优化。Swift 让此更加优雅。

### 依赖注入 ###

简而言之，方法就是[依赖注入](https://en.wikipedia.org/wiki/Dependency_injection)。这个原则指出你应该像知道所有输入一样设计类和方法。如果你用依赖注入来重构上面这段代码，它应该是像这样：
```
class MyViewController: UIViewController {

    let userManager: CurrentUserManager
    let defaults: UserDefaults
    let urlSession: URLSession

    init(userManager: CurrentUserManager, defaults: UserDefaults, urlSession: URLSession) {
        self.userManager = userManager
        self.defaults = defaults
        self.urlSession = urlSession
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let currentUser = userManager.user
        if currentUser != nil {
            // do something with current user
        }

        let mySetting = defaults.bool(forKey: "mySetting")
        if mySetting {
            // do something with setting
        }

        urlSession.dataTask(with: URL(string: "http://someResource")!) { (data, response, error) in
            // handle response
        }
    }
}

```

这个类不不再隐式地（或显式地）依赖于任何单例。它现在显式的依赖于 `CurrentUserManager`，`UserDefaults` 和 `URLSession`，但是这些依赖关系并没有表明它们是单例。这个细节不再重要,但是功能却保持不变。控制器仅仅是知道这些实例对象的存在而已。在调用方你可以传入单例。同样，这个细节从类的角度来看是不相关的。
```
let controller = MyViewController(userManager: .shared, defaults: .standard, urlSession: .shared)

present(controller, animated: true, completion: nil)
```

专业提示：Swift 的类型判断在此处有用。你可以简单的写 `.shared` 来代替 `URLSession.shared`。

如果你需要提供一个**不同的** `userDefaults`。例如，你需要在[应用组间共享数据](https://developer.apple.com/library/content/documentation/General/Conceptual/ExtensibilityPG/ExtensionScenarios.html#//apple_ref/doc/uid/TP40014214-CH21-SW6)，这很容易修改。事实上，你**不需要**修改这个类中的任何代码。你只需要传入 `UserDefaults(suiteName: "com.myApp")` 来代替 `UserDefaults.standard` 即可。

此外，在单元测试中你可以传入假的或者无效的这些类。真的伪装类在 Swift 中不可能，但是有[解决办法](/testing-without-ocmock/)。这取决于你想如何构建你的代码。你可以为 `CurrentUserManager` 使用一个协议，让你可以在测试中“伪装”。你可以为 `UserDefaults` 提供一个假的套件进行测试。你可以在测试中使 `URLSession`  可选，并传入 `nil` 。

### 重构的地狱 ###

抛弃这个想法，你现在想把你的代码库从混乱中解脱出来。虽然依赖注入是理想的并且给你更纯粹的对象模型，但它通常是难以实现的。甚至一开始写代码时几乎不会为兼容依赖注入做设计。

我们前面进行的重构会更加模块化和可测试，但也有个很实际的问题。 `MyViewController` 的初始化过去是空的 (`init()`) ,但现在带了三个参数。每个调用方都必须进行更改。更清晰和恰当的方式来对此进行重构，应该是至顶向下的传递实例，或者从前一层控制器传入到当前层。这可能需要你将数据从对象图的根节点传递到所有子节点。尤其是在 iOS 中，数据在控制器间的传递是很让人头痛的。尤其是遗留代码更难以快速实现这个变化。

大部分类（尤其是控制器）的初始化方法都需要修改。这种修改是难以应付的，不夸张的说你会意识到你需要重构整个应用 。要么所有的东西都会被打破重构，要么就只有一部分类根据依赖注入更新而其他的则继续隐式引用单例。这个不一致可能会在将来造成一些问题。

因此，像这样的重构在更复杂更大的遗留代码库中可能是不可行的，至少不是一次，而且没有回归。因为如此，你可以说根本不该重构就这么保持下去。然后几个月或者几年过去后，你需要支持多账户时，然而 `CurrentUserManager` 不能支持你实现切换账户时，你该怎么处理？

这是一个从开始就为了兼容后期各种变化的类的设计方法和预处理。

### 默认参数值 ###

默认参数是我最喜欢的一个 Swift 特性。它们非常有用，为我们的代码带来了巨大的灵活性。有了默认参数，你可以解决上面的问题而**不会**掉入依赖注入的兔子洞并且**不会**给你的代码库带来引入太多复杂性。也许你的应用真的只会有单一用户，所以实现所有的这些依赖注入只是没有意义的无用功。

你可以使用单例作为默认参数：

```
class MyViewController: UIViewController {

    init(userManager: CurrentUserManager = .shared, defaults: UserDefaults = .standard, urlSession: URLSession = .shared) {
        self.userManager = userManager
        self.defaults = defaults
        self.urlSession = urlSession
        super.init(nibName: nil, bundle: nil)
    }
}
```

现在，初始化方法再调用方的角度来看是没有变化的。但是类本身有极大的差异，就是现在使用依赖注入而不再引用单例了。
```
let controller = MyViewController()

present(controller, animated: true, completion: nil)
```

你从这个变化中获得了什么？你可以用这个模式重构所有的类而不用更新任何调用方的代码。语义上没有变化，功能上也没有。然而，你的类已经在使用依赖注入了。它们很少在内部使用实例。你可以使用上述的方法进行测试然后维护一个灵活的，模块化的 API，所有的公共接口都保持不变。基本上，你可以像什么都没有改变一样继续在你的代码库上工作。

假如到了需要传入自定义参数，非单例参数的时候你可以不用改变任何类就可以做到。你只需要更新调用方。此外，如果你决定完全实现依赖注入并且自顶向下的传入所有依赖，你只需要简单的移除默认参数并且从顶部传入依赖即可。

如果需要的话，你可以选择加入或选择停用任何默认参数。下面的例子中，我们提供一个自定义的 `UserDefaults` 但是保留 `CurrentUserManager` 和 `URLSession` 两个默认参数。

```
let appGroupDefaults = UserDefaults(suiteName: "com.myApp")!

let controller = MyViewController(defaults: appGroupDefaults)

present(controller, animated: true, completion: nil)
```

### 结论###

Swift 让我们实现这种“局部”依赖注入变得很轻松。通过向类添加一个带默认值的新属性和初始化参数，你可以让代码变的非常模块化和可测试，而不必重构整个应用，也不必完全实现依赖注入。当你**从开始**就像这样设计你的类，你会发现你编码进入困境的次数会少很多，而且当你进入困境时，会更容易解决它。

你可以将这些概念和设计应用于代码的所有领域，而不止是此处的简单示例。类、结构体、枚举、函数。Swift 中的每个方法都可以带有默认参数值。通过花时间来思考未来可能发生的变化，我们可以构建轻适配这些变化的类型和函数。

构建和设计好的软件意味着写出来的代码是**可维护性高但健壮性强的**。这就是依赖注入背后的目的，Swift 的默认参数可以让你更快捷、简便和优雅的实现这个目标。
