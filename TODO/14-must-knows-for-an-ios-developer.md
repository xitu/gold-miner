> * 原文地址：[14 must knows for an iOS developer](https://swiftsailing.net/14-must-knows-for-an-ios-developer-5ae502d7d87f#.5qoqojm6n)
* 原文作者：[Norberto Gil Vasconcelos](https://swiftsailing.net/@nobizard)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[Deepmissea](http://deepmissea.blue)
* 校对者：[ldhlfzysys](http://www.jianshu.com/u/bff850e51395)，[ChenDongnan](https://github.com/ChenDongnan)

# iOS 开发者一定要知道的 14 个知识点

![](https://cdn-images-1.medium.com/max/2000/1*GlmHP6nltxqLBZA3Rv8AGg.jpeg)

作为一个 iOS 开发者（现在对 Swift 中毒颇深 😍）。我从零开始创建应用、维护应用，并且在很多团队待过。在我的职业生涯中，一句话一直响彻耳边：“如果你不能解释一件事情，那你根本就不理解它。” 所以为了充分的理解我每天的日常，我创建了一个清单，在我看来，它适合任何 iOS 开发者。我会试着清晰的解释每一个观点。**[请随时纠正我，提出你的意见，或者干脆也来一发你觉得应该在列表上的“必须知道”的知识]**

**Topics:** [**源码管控**|**架构**|**Objective-C vs Swift**|**响应式**|**依赖管理**|**信息存储**|**CollectionViews 和 TableViews**|**UI**|**协议**|**闭包**|**scheme**|**测试**|**定位**|**字符串本地化**]


事不宜迟，没有特定的顺序，这就是我的清单。

#### 1 — 源码管控

恭喜你被雇佣了！现在从 repo 上拿代码开始干活吧，还等什么？

每个项目都需要控制源码的版本，即使只有你一个开发者。最常见的就是 Git 和 SVN 了。

**SVN** 依赖于一个集中的系统来进行版本管理。它是一个用来生成工作副本（working copies）的中央仓库，并且需要网络连接才能访问。 它的访问授权是基于路径的，追踪的是注册文件的改变，更改历史记录只能在中央仓库中完全可见。 工作副本只包含最新版本。

*推荐的图形界面工具:*

[**Versions - Mac Subversion Client (SVN)** *Versions, the first easy to use Mac OS X Subversion client* versionsapp.com](http://versionsapp.com)

**Git** 依赖于一个分布式的系统来进行版本管理。你有一个本地的仓库来进行工作，只需要在同步代码的时候联网。它的访问授权是整个目录，追踪的是注册内容的改变，在工作副本和主仓库都可也看到完整的更改历史。

*推荐的图形界面工具:*

[**SourceTree | Free Git and Hg Client for Mac and Windows**
*SourceTree is a free Mercurial and Git Client for Windows and Mac that provides a graphical interface for your Hg and…* www.sourcetreeapp.com](https://www.sourcetreeapp.com)

#### 2 — 架构

你的指尖因兴奋而颤抖，你想通了怎么控制源码！那先来杯咖啡压压惊？喝个P！现在的你正是巅峰状态，正是写代码的最佳时刻！不，还需要再等等，等什么？

在你蹂躏你的键盘之前，你需要先为项目选择一个架构。因为项目还没开始，你需要让项目的结构符合你的选择的架构。

有很多在移动应用开发中广泛使用的架构，MVC、MVP、MVVM、VIPER 等等。我会简短的概括这些之中 iOS 开发者最常用的：

- **MVC** — 模型（**M**odel）、视图（**V**iew）、控制器（**C**ontroller）的缩写。控制器的作用是连接模型和视图，因为他们互不干涉。视图和控制器的联系非常紧密，因此，控制器最终几乎做了所有的工作。这意味着什么？简单来说，如果你创建了一个复杂的视图，你的控制器（ViewController）会疯狂的变大。有办法绕过这个，但是他们不符合 MVC 规则。另一个 MVC 不好的地方是测试。如果你做测试（这对你有好处！），你会发现只能测试模型，因为跟其他层相比，它是唯一能单独分离出来的层。MVC 的加分项是直观，而且大多数 iOS 开发者都用习惯了。

![](https://cdn-images-1.medium.com/max/800/1*dLNPhFL6k2MFJBAm9g24UA.png)

- **MVVM** — 模型（**M**odel）、视图（**V**iew）、视图模型（**V**iew**M**odel）的缩写。在视图和视图模型之间设置一种绑定（基本地响应式编程）的关系，这使得视图模型来调用模型层改变自身时，由于和视图之间的绑定关系而自动更新视图。视图模型并不知道视图的所有事情，这样利于测试，而且绑定节省了大量代码。

![](https://cdn-images-1.medium.com/max/800/1*E1TC8beTXLlgVHO29wJTpA.png)

对于其他架构更深入的说明和信息，我建议阅读这篇文章：

[**iOS Architecture Patterns**
*Demystifying MVC, MVP, MVVM and VIPER* medium.com](https://medium.com/ios-os-x-development/ios-architecture-patterns-ecba4c38de52)

这一条看上去不是很重要，但是代码良好的结构性和组织性可以避免很多头疼的问题。每个开发者有时候都会犯一个大错，那就是为了得到想要的结果而放弃组织代码，他们以为这节省了时间。如果你不同意，引用自 Benji：

> 组织代码所耗费的每一分钟，都相当于赚了一个小时。

> — 本杰明·富兰克林

我们的目标是让代码变得直观易读，这样你才能简单地建立并维护。

#### 3 — Objective-C vs. Swift

在决定选择哪种语言编写应用时，你需要知道不同的语言能带来什么。如果可以选择的话，我个人建议使用 Swift。为什么？实话说，Objective-C 相比于 Swift 是有微弱优势的，大多数的例子和教程都是用 Objective-C 写的，而且每次 Swift 语言更新的时候，都会对范式做调整，真是让人发愁。但从长远的角度来说，这些问题都会消失。

Swift 真的在很多方面都领先一步。它读起来简单，类似于自然语言，而且因为它不是基于 C 构建的，使得它可以抛弃 C 语言中的语法惯例。对于知道 Objective-C 的人来说，它意味着没有分号，方法调用不需要括号，而且条件分支的表达式也不用括号。对代码的维护也更容易了，Swift 只有一个 .swift 文件，而不是 .h 和 .m 文件，因为 Xcode 和 LLVM 编译器可以找出依赖关系，并且自动地执行增量构建。总而言之，你不需要担心创建模板代码，而且你会发现用更少的代码可以得到相同的结果。

不信？Swift 还更安全、更快而且还负责内存管理（大多数情况）。知道在 Objective-C 中用一个未初始化的指针变量调用一个方法会发生什么吗？什么也不会发生。表达式变成空操作（no-op），然后跳过了。听起来特棒，因为你不用担心这会导致应用崩溃了，尽管，它会导致一系列严重的 bug 和不稳定的行为，以致于你开始怀疑人生，决定重新考虑你的职业生涯。我非常确定你不想那样。不过当一个职业遛狗人的念头听起来还是有那么一点吸引人的。Swift 通过可选类型消除了这个问题。不仅你会精心思考什么会是 nil，并在某个位置设置条件来来阻止它的使用，Swift 也会在 nil 值被使用时，弹出运行时的崩溃，以便更好的调试。内存方面，简单的说，ARC（自动引用计数）在 Swift 上工作的更好。在 Objective-C 里，ARC 并不支持 C 语言的代码和 API，比如 Core Graphics。

#### 4 — 响应式还是非响应式？

![](https://cdn-images-1.medium.com/max/800/1*pXx4SEZ7TExz5uCi2soXhw.gif)

函数响应式编程（**FRP**）看上去似乎很潮。它的意图是更简单的组合异步操作并以事件/数据流的方式驱动。对于 Swift来说，通过 `Observable<Element>` 接口来表示的通用计算抽象。（译者注：这里 `Observable<Element>` 并不是原生的，而是 RxSwift 的接口）

最简单的例子还是写一点代码。让我们看看小 Timmy 和他的姐姐 Jenny，他们想要买一个新的游戏机。Timmy 每周从他父母那里得到 5€，Jenny 也一样。不过 Jenny 每周末还能通过发报纸赚到 5€。如果他们把每一分钱都存下来，我们就可以每周检查一下他们是否能得到游戏机。每当他们其中一人的存款变化时，就计算一次他们的存款总额。如果钱够了，一个消息就会被存储在变量 isConsoleAttainable 里。在任何时候，我们可以通过订阅它来检查消息。

    // Savings
    let timmySavings = Variable(5)
    let jennySavings = Variable(10)

    var isConsoleAttainable =
    Observable
    .combineLatest(timmy.asObservable(), jenny.asObservable()) { $0 + $1 }
    .filter { $0 >= 300 }
    .map { "\($0) is enough for the gaming console!" }

    // Week 2
    timmySavings.value = 10
    jennySavings.value = 20
    isConsoleAttainable
       .subscribe(onNext: { print($0) }) // Doesn't print anything

    // Week 20
    timmySavings.value = 100
    jennySavings.value = 200
    isConsoleAttainable
       .subscribe(onNext: { print($0) }) // 300 is enough for the gaming console!


我们做的这点东西对 FRP 来说都是皮毛，一旦你真的用起来了，它会为你打开新世界的大门，甚至允许你采用不同于传统 MVC 的架构，对，就是 MVVM ！

你可以看看 Swift FRP 王座的两位主要竞争者：

- **RxSwift**

[**ReactiveX/RxSwift**
*RxSwift - Reactive Programming in Swift* github.com](https://github.com/ReactiveX/RxSwift)

- **ReactiveCocoa**

[**ReactiveCocoa/ReactiveCocoa**
*ReactiveCocoa - Streams of values over time* github.com](https://github.com/ReactiveCocoa/ReactiveCocoa)

#### 5 — 依赖管理

CocoaPods 和 Carthage 是 Swift 和 Objective-C Cocoa 项目里最常见的依赖管理工具。他们简化了库的实现，并且保持库的更新。

**CocoaPods** 有大量的三方库支持，用 Ruby 构建，可以用下面的命令来安装：

    $ sudo gem install cocoapods

安装过后，你需要为项目创建一个 Podfile 文件，你可以运行下面这条命令：

    $ pod init（译者注：原文是 pod install ，写错了。）

或者按照这个结构自定义一个 Podfile 文件：

    platform :ios, '8.0'
    use_frameworks!
    
    target 'MyApp' do
      pod 'AFNetworking', '~> 2.6'
      pod 'ORStackView', '~> 3.0'
      pod 'SwiftyJSON', '~> 2.3'
    end

一旦完成创建，那就是时候来安装你的新 pods 了

    $ pod install

现在，你可以打开项目里的 **.xcworkspace** 文件，别忘了引入你需要的依赖。

**Carthage** 是一个去中心化的依赖管理工具，和 Cocoapods 相对立。缺点是使用者很难找到现有的使用 Carthage 的库。另一方面来说，它只需要很少的维护工作，而且避免了各种中心化产生的问题。

你可以看看他们的 GitHub 来获取更多的关于安装和使用的信息：

[**Carthage/Carthage**
*Carthage - A simple, decentralized dependency manager for Cocoa* github.com](https://github.com/Carthage/Carthage)

#### 6 — 信息存储

如果想用简单的方式为你的应用存储数据，那么 **NSUserDefaults** 就是这种方式，因为它通常保存的是用户的默认数据，在应用首次加载的时候就被放入了。出于这个原因，它就变得简单易用，尽管这也意味着一些限制。其中一条限制就是它接受对象的类型。它的作用和 **Property List（Plist）** 非常像（其中也有同样的限制）。下面的六种类型能被存储到里面：

- NSData
- NSDate
- NSNumber
- NSDictionary
- NSString
- NSArray

为了和 Swift 兼容，NSNumber 可以接受以下的类型：

- UInt
- Int
- Float
- Double
- Bool

对象可以以下列方式保存到 NSUserDefaults（要先创建一个常量，作为我们要保存的对象的键）：

    let keyConstant = "objectKey"

    let defaults = NSUserDefaults.standardsUserDefaults()
    defaults.setObject("Object to save", objectKey: keyConstant)

想要从 NSUserDefaults 读取一个对象时，这样做：

    if let name = defaults.stringForKey(keyConstant) {
       print(name)
    }

为了获取特定类型的对象而不是 AnyObject（Swift 3 中的 Any），有几个便捷函数来读写 NSUserDefaults。

**钥匙串**是一个可以保存密码、证书、私钥以及私有信息的密码管理系统。keychain 的设备加密有两个级别。第一级别是使用锁屏密码作为密钥，第二级别使用由设备生成的密钥，并存储在设备上。

这意味着什么呢？意味着它不是很安全，尤其是你不使用锁屏密码的时候。同样，也有很多方式可以获取第二种密钥，毕竟它是存在设备上的。

最好的解决方案还是使用你自己的加密。（不要把密钥存在设备上）

**CoreData** 是一个苹果公司开发的框架，它的目的是让你的应用以面向对象的方式与数据库沟通。它简化了访问过程，减少了代码量而且去掉了需要测试的那部分代码。

如果你的应用需要数据持久化，那么你就应该用它，它大大的简化了数据持久化的过程，这意味着你再也不用构建与数据库连接的这部分程序，以及这部分的测试代码。


#### 7 — CollectionViews 和 TableViews

每个应用都有或多或少的 CollectionView 或 TableView。了解他们的工作原理，什么时候用哪个，都会在未来防止你的应用发生复杂的更改。

**TableViews** 以单列的方式，展示了一个列表，它只能垂直的滑动。列表的每项由 UITableViewCell 来表示，可以完全的自定义。这些项以 sections 和 rows 的方式来分类。

**CollectionViews** 也展示了一个列表，不过他可以有多行多列（像网格）。它水平竖直都可以滑动，每个项通过 UICollectionViewCell 来表示。和 UITableViewCell 一样，也可以自定义，并按照 sections 和 rows 的方式来分类。

他们有相似的功能，并都使用可复用 cell 来提高流畅性。选择哪个取决于你要写的列表的复杂程度。集合视图可以用于任何的列表，在我看来，始终是个不错的选择。现在假设你想做一个联系人列表。这太简单了，一列就可以搞定，所以你选择用 UITableView。伟大的作品！几个月以后，你们的设计师决定联系人还是以网格的形式来显示。那你就只能把 UITableView 的实现全部换成 UICollectionView 的。我想说的是，即使你的列表很简单，用 UITableView 足以搞定，如果有好灵感，设计也许会变，所以最好还是用 UICollectionView 来实现一个列表。

不管你最后选择了哪个，最好写一个通用的 tableview/collectionview，它让你的实现更容易，并且可以重用很多代码。

#### 8 — Storyboards vs. Xibs vs. 手撸 UI 代码

他们每一种方式都可以在编写 UI 方面独挡一面，当然，也没有人不让你一起用。

**Storyboards** 允许你为项目创建一个更宽泛的视图，设计师们很喜欢，因为他们可以看到应用的流程和所有的屏幕。坏处在于，随着屏幕的增加，他们之间的连接变得越来越混乱，storyboard 的加载时间也会增加。合并代码的冲突也会频繁的发生，因为所有的 UI 都写在了一个文件上。而且这些冲突还很难解决。

**Xibs** 提供了一个屏幕或者部分屏幕的视图。他们的好处是易于复用，合并代码的冲突比用 storyboard 要少，而且也可以简单的看到每个屏幕上有什么。

**手撸 UI 代码** 让你在最大程度上控制你的代码，并减少合并冲突，如果冲突发生，也可以很容易的解决。缺点就是没法看到具体的内容，还要花额外的时间去撸 UI。

有多种不同的方式来实现你应用的 UI 部分。但我还是主观的认为，最好的方式就是三种混合使用。使用多个 Storyboards（现在 storyboards 之间可以连接），然后用 Xibs 来展现那些非主屏幕上的内容，最后，在确定的情况下用代码做额外的控制。


#### 9 — 协议！

协议存在于我们的日常生活中，它可以来确定在给定的环境下，我们知道如何反应。假如你是一个消防员，现在有紧急情况。
每个消防队员都必须遵守协议，按照既定要求，才能成功的应对。这同样适用于一个 Swift/Objective-C 协议。

一个协议是按照给定的功能，定了了方法、属性和其他需要的约定。它可以被类、结构体或枚举采用，然后由他们提供这些功能具体的实现。

这里有一个怎么创建并使用协议的例子：

在例子中，我会使用一个枚举，来列出不同的灭火材料。

    enum ExtinguisherType: String {

       case water, foam, sand

    }

接着，我要创建一个能应对紧急情况的协议。

    protocol RespondEmergencyProtocol {

       func putOutFire(with material: ExtinguisherType)

    }

现在我要创建一个消防员来实现协议。

    class Fireman: RespondEmergencyProtocol {

        func putOutFire(with material: ExtinguisherType) {

           print("Fire was put out using \(material.rawValue).")

        }

    }

干的漂亮！现在让消防员行动起来。

    var fireman: Fireman = Fireman()

    fireman.putOutFire(with: .foam)

结果应该是 *“Fire was put out using foam.”*

协议也被用于**委托**。它允许类或结构体将功能委托给另一个类型的实例。创建具有委托职责的协议，以保证符合类型的实例为他们提供具体的功能。

快速示例！

    protocol FireStationDelegate {
       func handleEmergency()
    }

消防站将处理紧急情况的的行动委托给消防员。

    class FireStation {
       var delegate: FireStationDelegate?

       fun emergencyCallReceived() {
          delegate?.handleEmergency()
       }
    }

这就意味着消防员也要实现 FireStationDelegate 协议。

    class Fireman: RespondEmergencyProtocol, FireStationDelegate {

       func putOutFire(with material: ExtinguisherType) {
          print("Fire was put out using \(material.rawValue).")
       }

       func handleEmergency() {
          putOutFire(with: .water)
       }

    }

需要做的就是把待命的消防员设为消防站的代理，他会处理那些接到的火警电话。

    let firestation: FireStation = FireStation()
    firestation.delegate = fireman
    firestation.emergencyCallReceived()

结果应该是 *“Fire was put out using water.”*

可以看到，协议非常有用。用他们还可以做很多很多的事情，但现在我只介绍到这里。

#### 10 — 闭包

这里我只说 Swift 里的闭包。他们多数的用途是，作为一个函数完成的回调或者是高阶函数。函数回调，顾名思义，就是一个任务完成，执行这段回调代码。

> Swift 里的闭包类似于 C 和 Objective-C 中的 block。

> 闭包是第一类对象，所以可以被嵌套和传递（像 Objective-C 里的 block）。

> 在 Swift 里，函数是一种特殊的闭包。

来源: [Swift Block Syntax](http://fuckingswiftblocksyntax.com)

这是一个学习闭包语法很不错的地方。

#### 11 — scheme

简单的说，schemes 就是在各种配置间切换的简单方式。设想几种情况。Workspace 包含了各种的相关联的项目。项目可以多个 target（target指定了要构建的产品以及如何构建）。项目也可能有多种配置。Xcode scheme 定义了要构建的 target 集合、构建时使用的配置以及要执行测试的集合。

![](https://cdn-images-1.medium.com/max/800/1*eW_7GjRt-gmV1XoBB2BhlA.png)

#### 12 — 测试

如果你分配时间为你的应用编写测试代码，那你正走向正轨。它不是万能的，不能避免每一个错误，也不能保证你的应用没有任何问题，但我还是觉得好处多于坏处。

让我们从单元测试开始 **坏处:**

- 开发时间增加；
- 代码量增加。

**好处:**

- 强制的创建模块化代码 (这样才利于测试)；
- 显然，更多的 bug 会在正式版本发布前被找到；
- 更好维护。

配合 **Instruments** 工具，你已经拥有了所有让你应用变得流畅的工具，无论从处理 bug 角度还是解决崩溃的角度。

有不少的工具可以测试你的应用有什么问题。你可以根据你想要知道的，来选择其中的一个或者多个。最常用的，大概就是 Leak Checks(内存泄露检测)，Profile Timer(性能调优) 和 Memory Allocation(内存分配)了。

#### 13 — 定位

很多应用会有一些功能需要知道用户的位置。所以了解一下 iOS 上定位系统的基本知识是一个不错的点子。

有个叫做 Core Location 的框架给了你需要的一切：

> Core Location 框架，可以让你确定与设备相关的当前位置或方向。它通过可用的硬件来确认用户的位置与方向。你可以使用框架内部的类和协议来配置或计划位置的变更和方向的转变。你也可以使用它来定义地理区域，并监控用户何时跨越边界。在 iOS 里，你也可以定义一个蓝牙信标区域。

很不错是吧？查看苹果的官方文档和示例代码，来更好的了解你能做什么以及怎么做。

[**关于定位服务和地图**
*描述了定位和地图服务的使用* developer.apple.com](https://developer.apple.com/library/content/documentation/UserExperience/Conceptual/LocationAwarenessPG/Introduction/Introduction.html#//apple_ref/doc/uid/TP40009497)

#### 14 — 字符串本地化

这是每个应用都需要实现的。它允许应用根据所在地区而改变语言。即使你的应用只有一种语言，在将来也可能会有添加另一种语言的情况。如果所有的文本都使用了字符串本地化，需要做的所有工作就是为新语言添加一个 Localizable.strings 文件的翻译版本。

可以通过文件检查器将资源添加到一个语言。 要使用 NSLocalizedString 获取字符串，所有你要做的就是下面的内容：

    NSLocalizedString(key:, comment:)

不幸地是，往 Localization 文件里添加新字符串是手动的。以下是一个结构示例：

    {
       "APP_NAME" = "MyApp"
       "LOGIN_LBL" = "Login"
       ...
    }

现在一个相对应的，不同语言（葡萄牙语），Localizable 文件格式：

    {
       "APP_NAME" = "MinhaApp"
       "LOGIN_LBL" = "Entrar"
       ...
    }

甚至有办法实现复数。😁
