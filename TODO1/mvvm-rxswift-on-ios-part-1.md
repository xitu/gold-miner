> * 原文地址：[MVVM + RxSwift on iOS part 1](https://hackernoon.com/mvvm-rxswift-on-ios-part-1-69608b7ed5cd)
> * 原文作者：[Mohammad Zakizadeh](https://medium.com/@mamalizaki74)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/mvvm-rxswift-on-ios-part-1.md](https://github.com/xitu/gold-miner/blob/master/TODO1/mvvm-rxswift-on-ios-part-1.md)
> * 译者：[iWeslie](https://github.com/iWeslie)
> * 校对者：[swants](https://github.com/swants)

# iOS 里的 MVVM 和 RxSwift

![](https://cdn-images-1.medium.com/max/3200/1*MBFqJmaLduJLbjYleVVOqQ.jpeg)

在本文中，我将介绍 iOS 编程中的 MVVM 设计模式以及 RxSwift。本文分为两部分，第一部分简要介绍了设计模式和 RxSwift 的基础知识，而在 [第二部分](https://github.com/xitu/gold-miner/blob/master/TODO1/practical-mvvm-rxswift.md) 里，有一个实现了 MVVM 和 RxSwift 的示例项目。

## 设计模式：

***

首先，我们为什么要使用设计模式呢？简而言之，就是为了避免我们的代码乱成一团，当然这不是唯一的原因，其中有一个原因是可测试性。设计模式有很多，我们可以指出几个非常受欢迎的模式：**MVC、MVVM、MVP** 和 **VIPER**。下面的图片将这几个设计模式的分布协作性，可测试性和易用性进行了比较。

![Compare of design patterns ( from NSLondon )](https://cdn-images-1.medium.com/max/3664/1*wRnW_Qb2Q0rPTjbqQ96dhQ.png)

这些设计模式都有自己的优缺点，但最终它们都能使我们的代码更清晰、简单并且易于阅读。本文重点介绍 **MVVM**，我希望你能在阅读完 [第二部分](https://github.com/xitu/gold-miner/blob/master/TODO1/practical-mvvm-rxswift.md) 后着手实现它。

让我们简单介绍一下 MVC，然后继续讨论 MVVM

***

### MVC：

苹果官方建议使用 MVC 进行 iOS 编程，如果你有一定的 iOS 开发经验，你可能会熟悉 **MVC**。这个模式由 **Model、View** 和 **Controller** 组成，其中 Controller 负责将 Model 连接到 View。理论上看起来 View 和 Controller 是两个不同的东西，但在 iOS 的世界中，不幸的是，大多数情况下它们是一回事。当然，在小型项目中，一切似乎都符合规律，但是一旦你的项目变得庞大，Controller 因实现了大部分业务逻辑而变得臃肿，这会导致代码变得混乱，但是如果你能正确编写 MVC，并尽可能地把 Controller 里的东西解耦，大多数情况下这个问题将得到解决。

![MVC from apple docs](https://cdn-images-1.medium.com/max/2608/1*la8KCs0AKSzVGShoLQo2oQ.png)
官方文档中的 MVC

### MVVM：

![picture from github](https://cdn-images-1.medium.com/max/2912/1*VoIppMaaG6ZwRuE6zpctlg.jpeg)

**MVVM** 代表 **Model、View** 和 **ViewModel**，其中，**View** 和业务逻辑实现了 Controller，View 以及动画，**ViewModel** 里则是 api 的调用。实际上 ViewModel 这层是 Model 和 View 之间的接口并且它给 **View** 提供数据。有一点要注意的是，如果你在 ViewModel 的文件中看到以下代码，那你可能是在某处犯了一个错误：

```swift
import UIKit
```

这是因为 ViewModel 不应该和 View 有任何牵连，在 [第二部分](https://github.com/xitu/gold-miner/blob/master/TODO1/practical-mvvm-rxswift.md) 中我们将借助一个例子来研究这篇文章。

## RxSwift：

***

MVVM 的一个特性是数据和 View 的绑定，而 RxSwift 就很完美地实现了这一点。当然，您也可以使用 delegate，KVO 或闭包执行此操作，但 Rx 的有一个特性就是，它是一种思想，在很多语言里通用，因此它与编程语言关系并不大。你可以在 [这里](http://reactivex.io/languages.html) 找到它支持的语言列表。现在在这一部分我们将解释 RxSwift 的基础知识，当然，它们也是 Rx 世界的基础知识。然后在 [第二部分](https://github.com/xitu/gold-miner/blob/master/TODO1/practical-mvvm-rxswift.md) 中，我们将凭借 MVVM 使用 RxSwift 创建一个项目。

### 响应式编程：

既然 RxSwift 是基于响应式编程的，那这究竟是什么意思呢？

> 在计算机中，响应式编程或反应式编程（Reactive programming）是一种面向数据流和变化传播的编程范式。这意味着可以在编程语言中很方便地表达静态或动态的数据流，而相关的计算模型会自动将变化的值通过数据流进行传播。—— 维基百科

也许你在读完后对本段的任何内容还是不怎么了解，那下面我们就通过以下的例子来进一步理解它：

假设你现在有三个变量（a，b，c）：

```swift
var a: Int = 1
var b: Int = 2
var c: Int = a + b // 输出 3
```

现在如果我们将 `a` 从 1 改为 2 并且我们打印 `c`，它的值仍然是 3。但是在响应式编程的世界中一切都变得不一样了，`c` 的值取决于 `a` 和 `b`，这意味着如果你把 `a` 从 1 改为 2，那 `c` 的值就会自动从 3 变为 4 而不需要你自行更改。

```swift
var a: Int = 1
var b: Int = 2
var c: Int = a + b // 输出 3
a = 2
print("c=\(c)")
// 输出 c=3
// 在响应式编程中 c=4
```

现在让我们开始学习 RxSwift 的基础知识：

在 RxSwift（当然还有其他 Rx）的世界中，一切事物都是事件流，其中包括 UI 事件和网络请求等等。请切记这一点，我将用现实生活中的例子来解释：

你的手机是一个 **可观察对象（Observable）**，它会产生一些事件，例如铃声或者推送通知等，这会让你引起注意，事实上你订阅（**subscribe**）了你的手机，并决定如何处理这些事件，比如你有时候删除或者查看一些通知，事实上这些事件是一些 **信号（signal）**，而你是做出决定的 **观察者（Observer）**。

![](https://cdn-images-1.medium.com/max/2000/1*iq8fm2j0k2b5xlpQorNiuA.gif)

下面让我们来代码来实现它：

### Observable 和 Observer（订阅者）：

在 Rx 世界中，一些变量是 **Observable**，而另一些是 **Observer**（或订阅者）。

因此 **Observable** 是通用的，如果它确遵循了 ObservableType 协议，你可以监听你想要的任何类型。

![](https://cdn-images-1.medium.com/max/2000/1*6_7m7BB05qfWrK4opp5xDA.png)

现在让我们定义一些 Observable：

```swift
let helloObservableString = Observable.just("Hello Rx World")
let observableInt = Observable.of(0, 1, 2)
let dictSequence = Observable.from([1: "Hello", 2: "World"])
```

在上面例子中，我们分别定义了 Observable 类型的 String，Int 和 Dictionary，现在我们应该 **订阅** 我们的 Observable，这样我们就可以从发出的信号中读取信息。

```swift
helloObservableString.subscribe({ event in
    print(event)
})
// 输出：
// next(Hello Rx World)
// completed
```

你可能在想输出为什么会出现 `next` 和 `completed`，为什么 ‘hello world’ 就不能好好打印一个字符串，我得说这就是 Observable 最重要的特性：

实际上每个 Observable 都是一个 **序列**，与 Swift 里 [Sequence](https://developer.apple.com/documentation/swift/sequence) 的主要区别在于 Observable 的值可以是异步的。如果你不理解这点并不重要，但是希望你能理解下面的描述，我以图的方式呈现了这一特性：

![sequence of events](https://cdn-images-1.medium.com/max/2000/1*sXgodZ2an2tnAixXOsEoWg.png)

在上面的图中，我们有三个 Observable，第一行是 Int 类型，从 1 数到 6。在第二行是 String，从 ‘a’ 到 ‘f’，随即发生了一些错误。最后一行是 Observable 类型的手势，它还没有完成，还在继续。

这些显示 Observable 变量事件的图像叫做大理石图。想要了解更多信息，您可以访问 [这个网站](http://rxmarbles.com/) 或从 App Store 下载 [这个 App](https://itunes.apple.com/us/app/rxmarbles/id1087272442?ls=1&mt=8)（它也是开源的 👍😎，[这里](https://github.com/RxSwiftCommunity/RxMarbles) 有 App 的源代码）。

在 Rx 世界中，对于每个 Observable，都是由 3 种可能的枚举值组成：

***

1. **.next**(value: T)

2. **.error**(error: Error)

3. **.completed**

当 Observable 添加值时，调用 `next` 并通过相关的 value 属性（1 到 6，‘a’ 到 ‘f’）将值传递给 Observer（或订阅者）。

如果 Observable 遇到了错误❌，则发出错误事件然后完成（‘f’ 之后的 X）。

如果 Observable 完成，则调用 completed 事件（6 之后）。

如果你想要取消订阅一个 Observable，我们可以调用 **dispose** 方法，或者如果你想在你的 View deinit 的时候调用这个方法你应该使用 **DisposeBag** 在你的类反初始化时来进行你想要的操作。**在这里强调一点，如果你忘记使用 dispose 的话会导致内存泄漏☠️💀**。例如，你应该这样订阅 Observable：

```swift
let disposeBag = DisposeBag()
helloObservableString.subscribe({ event in
    print(event)
}).disposed(by: disposeBag)
```

现在让我们看看将 Rx 与函数式编程相结合有多完美。假设你有 Observable 的 Int 并且你订阅了它，现在 Observable 会给你一堆 Int，你可以使用很多方法改变来自 Observable 的发出信号，例如：

***

### Map:

你可以使用 map 方法让信号在到达订阅者之前做出一些改变。例如，我们有 Observable 的 Int，它发出了 2，3，4 三个数字，现在我们想要它们在传给订阅者之前都乘以 10，我们可以这么做：

![map marble](https://cdn-images-1.medium.com/max/2000/1*fba7HHwf1BBKRiM8ka6WjQ.png)

```swift
Observable<Int>.of(2, 3, 4).map { value in
        return value * 10
    }.subscribe(onNext: {
        print($0)
    }).disposed(by: disposeBag)
// 输出：20 30 40
```

### Filter:

您可能又会想是否能让它们在传给订阅者之前过滤掉一些值，例如，过滤掉示例中大于 25 的数字：

```swift
Observable<Int>.of(2, 3, 4).map { value in
        return value * 10
    }
    .filter( return $0 > 25 )
    .subscribe(onNext: {
        print($0)
    }).disposed(by: disposeBag)
// 输出：30 40
```

### FlatMap:

又比如您有两个 Observable 对象，并且您希望将它们合二为一：

![](https://cdn-images-1.medium.com/max/2868/1*UIhBMXe5aD1WFKeIbUTnaQ.png)

在上面的例子中，Observable A 和 Observable B 被组合在一起并形成一个新的 Observable：

```swift
let sequenceA = Observable<Int>.of(1, 2)
let sequenceB = Observable<Int>.of(1, 2)
let sequenceOfAB = Observable.of(sequenceA, sequenceB)
sequenceOfAB.flatMap { return $0 }.subscribe(onNext: {
    print($0)
}).disposed(by: disposeBag)
```

### distinctUntilChanged 或 debounce：

这两个方法是搜索中最有用的方法之一。例如，用户想要搜索单词，您可能在用户输入每个字符时都调用搜索 API。如果用户快速键入，这样的话你就会进行很多不必要的请求。为了达到此目的，正确的方法应该是在用户停止键入时调用搜索 API。这时您可以使用 debounce：

```swift
usernameOutlet.rx.text
    .debounce(0.3, scheduler: MainScheduler.instance)
    .subscribe(onNext: { [unowned self] text in
        self?.search(withQuery: text)
    }).addDisposableTo(disposeBag)
```

在上面的例子中，如果用户名 TextField 的内容在 0.3 秒内发生变化，则这些信号不会到达订阅者，因此不会调用搜索方法。只有当用户在 0.3 秒后停止输入，订阅者才会收到信号并调用搜索方法。

distinctUntilChanged 功能对变化很敏感，这意味着如果两个信号在信号没有变化之前得到相同的信号，它将不会被发送给用户。

***

Rx 世界比你想象的要大得多，我在 [文章的第二部分](https://github.com/xitu/gold-miner/blob/master/TODO1/practical-mvvm-rxswift.md) 中讲述了我认为需要的一些基本概念，里面有一个使用 RxSwift 的实际项目。

来自 [raywenderlich](https://store.raywenderlich.com/products/rxswift) 的 RxSwift 入门文章非常棒，我强烈推荐阅读。

你可能不会在文章中注意到 RxSwift，因为它是 Swift 的高级概念之一，你可能每天都要阅读不同的文章才能弄明白它。您可以通过 [此链接](https://github.com/mohammadZ74/handsomeIOS) 看到 RxSwift 部分中的几篇好文章。

你可以通过 [文章的第二部分](https://github.com/xitu/gold-miner/blob/master/TODO1/practical-mvvm-rxswift.md) 将 Rx 引入到 MVVM 的实际项目中，因为通过实例你将更好、更容易地理解 RxSwift 的概念。

你可以通过 [Twitter](https://twitter.com/Mohammad_z74) 或者发送 email 来联系到本文作者，邮箱是 mohammad_z74@icloud.com ✌️

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
