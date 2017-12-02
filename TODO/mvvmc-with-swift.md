> * 原文地址：[MVVM-C with Swift](https://marcosantadev.com/mvvmc-with-swift/)
> * 原文作者：[Marco Santarossa](https://marcosantadev.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：[Deepmissea](http://deepmissea.blue)
> * 校对者：[atuooo](http://atuo.xyz)，[1992chenlu](https://github.com/1992chenlu)

---

# MVVM-C 与 Swift

![](https://marcosantadev.com/wp-content/uploads/MVVM-C_with_Swift_header.jpg)

# 简介

现今，iOS 开发者面临的最大挑战是构建一个健壮的应用程序，它必须易于维护、测试和扩展。

在这篇文章里，你会学到一种可靠的方法来达到目的。

首先，简要介绍下你即将学习的内容：
**架构模式**.

# 架构模式

## 它是什么

> 架构模式是给定上下文中软件体系结构中常见的，可重用的解决方案。架构与软件设计模式相似，但涉及的范围更广。架构解决了软件工程中的各种问题，如计算机硬件性能限制，高可用性和最小化业务风险。一些架构模式已经在软件框架内实现。

摘自 [Wikipedia](https://en.wikipedia.org/wiki/Architectural_pattern)。

在你开始一个新项目或功能的时候，你需要花一些时间来思考架构模式的使用。通过一个透彻的分析，你可以避免耗费很多天的时间在重构一个混乱的代码库上。

## 主要的模式

在项目中，有几种可用的架构模式，并且你可以在项目中使用多个，因为每个模式都能更好地适应特定的场景。

当你阅读这几种模式时，主要会遇到：

### [Model-View-Controller](https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93controller)

![](https://marcosantadev.com/wp-content/uploads/mvc_2.jpg)

这是最常见的，也许在你的第一个 iOS 应用中已经使用过。不幸地是，这也是最糟糕的模式，因为 `Controller` 不得不管理每一个依赖（API、数据库等等），包括你应用的业务逻辑，而且与 `UIKit` 的耦合度很高，这意味着很难去测试。

你应该避免这种模式，用下面的某种来代替它。

### [Model-View-Presenter](https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93presenter)

![](https://marcosantadev.com/wp-content/uploads/mvp.jpg)

这是第一个 MVC 模式的备选方案之一，一次对 `Controller` 和 `View` 之间解耦的很好的尝试。

在 MVP 中，你有一层叫做 `Presenter` 的新结构来处理业务逻辑。而 `View` —— 你的 `UIViewController` 以及任何 `UIKit` 组件，都是一个笨的对象，他们只通过 `Presenter` 更新，并在 UI 事件被触发的时候，负责通知 `Presenter`。由于 `Presenter` 没有任何 `UIKit` 的引用，所以非常容易测试。

### [Viper](https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93presenter)

[![](https://www.objc.io/images/issue-13/2014-06-07-viper-intro-0a53d9f8.jpg)](https://www.objc.io/issues/13-architecture/viper/)

这是 [Bob 叔叔的清晰架构](https://8thlight.com/blog/uncle-bob/2012/08/13/the-clean-architecture.html)的代表。

这种模式的强大之处在于，它合理分配了不同层次之间的职责。通过这种方式，你的每个层次做的的事变得很少，易于测试，并且具备单一职责。这种模式的问题是，在大多数场合里，它过于复杂。你需要管理很多层，这会让你感到混乱，难于管理。

这种模式并不容易掌握，你可以在[这里](https://www.objc.io/issues/13-architecture/viper/)找到关于这种架构模式更详细的文章。

### [Model-View-ViewModel](https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93viewmodel)

![](https://marcosantadev.com/wp-content/uploads/mvvm.jpg)

最后但也是最重要的，MVVM 是一个类似于 MVP 的框架，因为层级结构几乎相同。你可以认为 MVVM 是 MVP 版本的一个进化，而这得益于 UI 绑定。

UI 绑定是在 `View` 和 `ViewModel` 之间建立一座单向或双向的桥梁，并且两者之间以一种非常透明地方式进行沟通。

不幸地是，iOS 没有原生的方式来实现，所以你必须通过三方库/框架或者自己写一个来达成目的。

在 Swift 里有多种方式实现 UI 绑定：

#### RxSwift (或 ReactiveCocoa)

[RxSwift](https://github.com/ReactiveX/RxSwift) 是 [ReactiveX](http://reactivex.io/) 家族的一个 Swift 版本的实现。一旦你掌握了它，你就能很轻松地切换到 RxJava、RxJavascript 等等。

这个框架允许你来用[函数式（FRP）](https://en.wikipedia.org/wiki/Functional_reactive_programming)的方式来编写程序，并且由于内部库 RxCocoa，你可以轻松实现 `View` 和 `ViewModel` 之间的绑定：

```
class ViewController: UIViewController {
 
    @IBOutlet private weak var userLabel: UILabel!
 
    private let viewModel: ViewModel
    private let disposeBag: DisposeBag
 
    private func bindToViewModel() {
        viewModel.myProperty
            .drive(userLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
``` 

我不会解释如何彻底地使用 RxSwift，因为这超出本文的目标，它自己会有文章来解释。

FRP 让你学习到了一种新的方式来开发，你可能对它或爱或恨。如果你没用过 FRP 开发，那你需要花费几个小时来熟悉和理解如何正确地使用它，因为它是一个完全不同的编程概念。

另一个类似于 RxSwift 的框架是 [ReactiveCocoa](https://github.com/ReactiveCocoa/ReactiveCocoa)，如果你想了解他们之间主要的区别的话，你可以看看[这篇文章](https://www.raywenderlich.com/126522/reactivecocoa-vs-rxswift)。

#### 代理

如果你想避免导入并学习新的框架，你可以使用代理作为替代。不幸地是，使用这种方法，你将失去透明绑定的功能，因为你必须手动绑定。这个版本的 MVVM 非常类似于 MVP。

这种方式的策略是通过 `View` 内部的 `ViewModel` 保持一个对代理实现的引用。这样 `ViewModel` 就能在无需引用任何 `UIKit` 对象的情况下更新 `View`。

这有个例子：

```
class ViewController: UIViewController, ViewModelDelegate {
 
    @IBOutlet private weak var userLabel: UILabel?
 
    private let viewModel: ViewModel
 
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewModel.delegate = self
    }
 
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    func userNameDidChange(text: String) {
        userLabel?.text = text
    }
}
 
 
protocol ViewModelDelegate: class {
    func userNameDidChange(text: String)
}
 
class ViewModel {
 
    private var userName: String {
        didSet {
            delegate?.userNameDidChange(text: userName)
        }
    }
    weak var delegate: ViewModelDelegate? {
        didSet {
            delegate?.userNameDidChange(text: userName)
        }
    }
 
    init() {
        userName = "I 💚 hardcoded values"
    }
}
``` 

#### 闭包

和代理非常相似，不过不同的是，你使用的是闭包来代替代理。

闭包是 `ViewModel` 的属性，而 `View` 使用它们来更新 UI。你必须注意在闭包里使用 `[weak self]`，避免造成循环引用。

**关于 Swift 闭包的循环引用，你可以阅读[这篇文章](https://krakendev.io/blog/weak-and-unowned-references-in-swift)。**

这有一个例子：

```
class ViewController: UIViewController {
 
    @IBOutlet private weak var userLabel: UILabel?
 
    private let viewModel: ViewModel
 
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewModel.userNameDidChange = { [weak self] (text: String) in
            self?.userNameDidChange(text: text)
        }
    }
 
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    func userNameDidChange(text: String) {
        userLabel?.text = text
    }
}
 
class ViewModel {
 
    var userNameDidChange: ((String) -> Void)? {
        didSet {
            userNameDidChange?(userName)
        }
    }
 
    private var userName: String {
        didSet {
            userNameDidChange?(userName)
        }
    }
 
    init() {
        userName = "I 💚 hardcoded values"
    }
}
```

## 抉择: MVVM-C

在你不得不选择一个架构模式时，你需要理解哪一种更适合你的需求。在这些模式里，MVVM 是最好的选择之一，因为它强大的同时，也易于使用。

不幸地是这种模式并不完美，主要的缺陷是 MVVM 没有路由管理。

我们要添加一层新的结构，来让它获得 MVVM 的特性，并且具备路由的功能。于是它就变成了：**Model-View-ViewModel-Coordinator (MVVM-C)**

示例的项目会展示 `Coordinator` 如何工作，并且如何管理不同的层次。

![](https://marcosantadev.com/wp-content/uploads/mvvm-c.jpg?v=1)

# 入门

你可以在[这里](https://github.com/MarcoSantarossa/MVVM-C_with_Swift)下载项目源码。

这个例子被简化了，以便于你可以专注于 MVVM-C 是如何工作的，因此 GitHub 上的类可能会有轻微出入。

示例应用是一个普通的仪表盘应用，它从公共 API 获取数据，一旦数据准备就绪，用户就可以通过 ID 查找实体，如下面的截图：

![](https://marcosantadev.com/wp-content/uploads/app_screenshot_1.png)

应用程序有不同的方式来添加视图控制器，所以你会看到，在有子视图控制器的边缘案例中，如何使用 `Coordinator`。

## MVVM-C 的层级结构

### Coordinator

它的职责是显示一个新的视图，并注入 `View` 和 `ViewModel` 所需要的依赖。 

`Coordinator` 必须提供一个 `start` 方法，来创建 MVVM 层次并且添加 `View` 到视图的层级结构中。

你可能会经常有一组 `Coordinator` 子类，因为在你当前的视图中，可能会有子视图，就像我们的例子一样：

```
final class DashboardContainerCoordinator: Coordinator {
 
    private var childCoordinators = [Coordinator]()
 
    private weak var dashboardContainerViewController: DashboardContainerViewController?
    private weak var navigationController: UINavigationControllerType?
 
    private let disposeBag = DisposeBag()
 
    init(navigationController: UINavigationControllerType) {
        self.navigationController = navigationController
    }
 
    func start() {
        guard let navigationController = navigationController else { return }
        let viewModel = DashboardContainerViewModel()
        let container = DashboardContainerViewController(viewModel: viewModel)
 
        bindShouldLoadWidget(from: viewModel)
 
        navigationController.pushViewController(container, animated: true)
 
        dashboardContainerViewController = container
    }
 
    private func bindShouldLoadWidget(from viewModel: DashboardContainerViewModel) {
        viewModel.rx_shouldLoadWidget.asObservable()
            .subscribe(onNext: { [weak self] in
                self?.loadWidgets()
            })
            .addDisposableTo(disposeBag)
    }
 
    func loadWidgets() {
        guard let containerViewController = usersContainerViewController() else { return }
        let coordinator = UsersCoordinator(containerViewController: containerViewController)
        coordinator.start()
 
        childCoordinators.append(coordinator)
    }
 
    private func usersContainerViewController() -> ContainerViewController? {
        guard let dashboardContainerViewController = dashboardContainerViewController else { return nil }
 
        return ContainerViewController(parentViewController: dashboardContainerViewController,
                                       containerView: dashboardContainerViewController.usersContainerView)
    }
}
```

你一定能注意到在 `Coordinator` 里，一个父类 `UIViewController` 对象或者子类对象，比如 `UINavigationController`，被注入到构造器之中。因为 `Coordinator` 有责任添加 `View` 到视图层级之中，它必须知道那个父类添加了 `View`。

在上面的例子里，`DashboardContainerCoordinator` 实现了协议 `Coordinator`：

```
protocol Coordinator {
    func start()
}
```

这便于你使用[多态](https://en.wikipedia.org/wiki/Polymorphism_(computer_science))。

创建完第一个 `Coordinator` 后，你必须把它作为程序的入口放到 `AppDelegate` 中：

```
class AppDelegate: UIResponder, UIApplicationDelegate {
 
    var window: UIWindow?
 
    private let navigationController: UINavigationController = {
        let navigationController = UINavigationController()
        navigationController.navigationBar.isTranslucent = false
        return navigationController
    }()
 
    private var mainCoordinator: DashboardContainerCoordinator?
 
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow()
        window?.rootViewController = navigationController
        let coordinator = DashboardContainerCoordinator(navigationController: navigationController)
        coordinator.start()
        window?.makeKeyAndVisible()
 
        mainCoordinator = coordinator
 
        return true
    }
}
``` 

在 `AppDelegate` 里，我们实例化一个新的 `DashboardContainerCoordinator`，通过 `start` 方法，我们把新的视图推入 `navigationController` 里。

**你可以看到在 GitHub 上的项目是如何注入一个 `UINavigationController` 类型的对象，并去除 `UIKit` 和 `Coordinator` 之间的耦合。**

### Model

`Model` 代表数据。它必须尽可能的简洁，没有业务逻辑。

```
struct UserModel: Mappable {
    private(set) var id: Int?
    private(set) var name: String?
    private(set) var username: String?
 
    init(id: Int?, name: String?, username: String?) {
        self.id = id
        self.name = name
        self.username = username
    }
 
    init?(map: Map) { }
 
    mutating func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        username <- map["username"]
    }
}
``` 

实例项目使用开源库 [ObjectMapper](https://github.com/Hearst-DD/ObjectMapper) 将 JSON 转换为对象。

>   ObjectMapper 是一个使用 Swift 编写的框架。它可以轻松的让你在 JSON 和模型对象（类和结构体）之间相互转换。

在你从 API 获得一个 JSON 响应的时候，它会非常有用，因为你必须创建模型对象来解析 JSON 字符串。

### View

`View` 是一个 `UIKit` 对象，就像 `UIViewController` 一样。

它通常持有一个 `ViewModel` 的引用，通过 `Coordinator` 注入来创建绑定。

```
final class DashboardContainerViewController: UIViewController {
 
    let disposeBag = DisposeBag()
 
    private(set) var viewModel: DashboardContainerViewModelType
 
    init(viewModel: DashboardContainerViewModelType) {
        self.viewModel = viewModel
 
        super.init(nibName: nil, bundle: nil)
 
        configure(viewModel: viewModel)
    }
 
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    func configure(viewModel: DashboardContainerViewModelType) {
        viewModel.bindViewDidLoad(rx.viewDidLoad)
 
        viewModel.rx_title
            .drive(rx.title)
            .addDisposableTo(disposeBag)
    }
}
``` 

在这个例子中，视图控制器中的标题被绑定到 `ViewModel` 的 `rx_title` 属性上。这样在 `ViewModel` 更新 `rx_title` 值的时候，视图控制器中的标题就会根据新的值自动更新。

### ViewModel

`ViewModel` 是这种架构模式的核心层。它的职责是保持 `View` 和 `Model` 的更新。由于业务逻辑在这个类中，你需要用不同的组件的单一职责来保证 `ViewModel` 尽可能的干净。

```
final class UsersViewModel {
 
    private var dataProvider: UsersDataProvider
    private var rx_usersFetched: Observable<[UserModel]>
 
    lazy var rx_usersCountInfo: Driver<String> = {
        return UsersViewModel.createUsersCountInfo(from: self.rx_usersFetched)
    }()
    var rx_userFound: Driver<String> = .never()
 
    init(dataProvider: UsersDataProvider) {
        self.dataProvider = dataProvider
 
        rx_usersFetched = dataProvider.fetchData(endpoint: "http://jsonplaceholder.typicode.com/users")
            .shareReplay(1)
    }
 
    private static func createUsersCountInfo(from usersFetched: Observable<[UserModel]>) -> Driver<String> {
        return usersFetched
            .flatMapLatest { users -> Observable<String> in
                return .just("The system has \(users.count) users")
            }
            .asDriver(onErrorJustReturn: "")
    }
}
``` 

在这个例子中，`ViewModel` 有一个在构造器中注入的数据提供者，它用于从公共 API 中获取数据。一旦数据提供者返回了取得的数据，`ViewModel` 就会通过 `rx_usersCountInfo` 发射一个新用户数量相关的新事件。因为绑定了观察者 `rx_usersCountInfo`，这个新事件会被发送给 `View`，然后更新 UI。

可能会有很多不同的组件在你的 `ViewModel` 里，比如一个用来管理数据库（CoreData、Realm 等等）的数据控制器，一个用来与你 API 和其他任何外部依赖交互的数据提供者。

因为所有 `ViewModel` 都使用了 RxSwift，所以当一个属性是 RxSwift 类型（`Driver`、`Observable` 等等）的时候，就会有一个 `rx_` 前缀。这不是强制的，只是它可以帮助你更好的识别哪些属性是 RxSwift 对象。

# 结论

MVVM-C 有很多优点，可以提高应用程序的质量。你应该注意使用哪种方式来进行 UI 绑定，因为 RxSwift 不容易掌握，而且如果你不明白你做的是什么，调试和测试有时可能会有点棘手。

我的建议是一点点地开始使用这种架构模式，这样你可以学习不同层次的使用，并且能保证层次之间的良好的分离，易于测试。

# FAQ

**MVVM-C 有什么限制吗？**

是的，当然有。如果你正做一个复杂的项目，你可能会遇到一些边缘案例，MVVM-C 可能无法使用，或者在一些小功能上使用过度。如果你开始使用 MVVM-C，并不意味着你必须在每个地方都强制的使用它，你应该始终选择更适合你需求的架构。

**我能用 RxSwift 同时使用函数式和命令式编程吗？**

是的，你可以。但是我建议你在遗留的代码中保持命令式的方式，而在新的实现里使用函数式编程，这样你可以利用 RxSwift 强大的优势。如果你使用 RxSwift 仅仅为了 UI 绑定，你可以轻松使用命令式编写程序，而只用函数响应式编程来设置绑定。

**我可以在企业项目中使用 RxSwift 吗？**

这取决于你要开新项目，还是要维护旧代码。在有遗留代码的项目中，你可能无法使用 RxSwift，因为你需要重构很多的类。如果你有时间和资源来做，我建议你新开一项目一点一点的做，否则还是尝试其他的方法来解决 UI 绑定的问题。

需要考虑的一个重要事情是，RxSwift 最终会成为你项目中的另一个依赖，你可能会因为 RxSwift 的破坏性改动而导致浪费时间的风险，或者缺少要在边缘案例中实现功能的文档。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
