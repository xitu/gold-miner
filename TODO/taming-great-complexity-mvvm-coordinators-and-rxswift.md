
> * 原文地址：[Taming Great Complexity: MVVM, Coordinators and RxSwift](https://blog.uptech.team/taming-great-complexity-mvvm-coordinators-and-rxswift-8daf8a76e7fd)
> * 原文作者：[Arthur Myronenko](https://blog.uptech.team/@arthur.myronenko)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/taming-great-complexity-mvvm-coordinators-and-rxswift.md](https://github.com/xitu/gold-miner/blob/master/TODO/taming-great-complexity-mvvm-coordinators-and-rxswift.md)
> * 译者：[jingzhilehuakai](https://github.com/jingzhilehuakai)
> * 校对者：[cbangchen](https://github.com/cbangchen) [swants](https://github.com/swants)
            

# MVVM, Coordinators 和 RxSwift 的抽丝剥茧

![](https://ws4.sinaimg.cn/large/006tNc79gy1fiygh2f3haj31jk15m7wh.jpg)

去年，我们的团队开始在生产应用中使用 Coordinators 和 MVVM。 起初看起来很可怕，但是从那时起到现在，我们已经完成了 4 个基于这种模式开发的应用程序。在本文中，我将分享我们的经验，并将指导你探索 MVVM, Coordinators 和响应式编程。

我们将从一个简单的 MVC 示例应用程序开始，而不是一开始就给出一个定义。我们将逐步进行重构，以显示每个组件如何影响代码库以及结果如何。每一步都将以简短的理论介绍作为前提。

### 示例

在这篇文章中，我们将使用一个简单的示例程序，这个程序展示了 GitHub 上不同开发语言获得星数最多的库列表,并把这些库以星数多少进行排序。包含两个页面，一个是通过开发语言种类进行筛选的库列表，另一个则是用来分类的开发语言列表。

![Screens of the example app](https://ws2.sinaimg.cn/large/006tNc79gy1fiygh3b4w8j318g0s0jv0.jpg)

用户可以通过点击导航栏上的按钮来进入第二个页面。在这个开发语言列表里，可以选择一个语言或者通过点击取消按钮来退出页面。如果用户在第二个页面选择了一个开发语言，页面将会执行退出操作，而仓库列表页面也会根据已选的开发语言来进行内容刷新。

你可以在下面的链接里找到源代码文件：

[![](https://ws3.sinaimg.cn/large/006tKfTcgy1fi4hjpkfvqj314k0aqgmv.jpg)](https://github.com/uptechteam/Coordinator-MVVM-Rx-Example)

这个仓库包含四个文件夹：MVC，MVC-Rx，MVVM-Rx，Coordinators-MVVM-Rx。分别对应重构的每一个步骤。让我们打开 [MVC folder](https://github.com/uptechteam/Coordinator-MVVM-Rx-Example/tree/master/MVC) 这个项目，然后在进行重构之前先看一下。

大部分的代码都在两个视图控制器中：`RepositoryListViewController` 和 `LanguageListViewController`。第一个视图控制器获取了一个最受欢迎仓库的列表，然后通过表格展示给了用户，第二个视图控制器则是展示了一个开发语言的列表。`RepositoryListViewController` 是 `LanguageListViewController` 的一个代理持有对象，遵循下面的协议：

```
protocol LanguageListViewControllerDelegate: class {
    func languageListViewController(_ viewController: LanguageListViewController,
                                    didSelectLanguage language: String)
    func languageListViewControllerDidCancel(_ viewController: LanguageListViewController)
}
```

`RepositoryListViewController` 也是列表视图的代理持有对象和数据源持有对象。它处理导航事件，格式化可展示的 Model 数据以及执行网络请求。哇哦，一个视图控制器包揽了这么多的责任。
The `RepositoryListViewController` is also a delegate and a data source for the table view. It handles the navigation, formats model data to display and performs network requests. Wow, a lot of responsibilities for just one View Controller!

另外，你可以注意到 `RepositoryListViewController` 这个文件的全局范围内有两个变量：`currentLanguage` 和 `repositories`。这种状态变量使得类变得复杂了起来，而如果应用出现了意料之外的崩溃，这也会是一种常见的 BUGS 来源。总而言之，当前的代码中存在着好几个问题：

- 视图控制器包揽了太多的责任；
- 我们需要被动地处理状态的变化；
- 代码不可测。

是时候去见一下我们新的客人了。

### RxSwift

这个组件将允许我们被动的响应状态变化和写出声明式代码。

Rx 是什么？其中有一个定义是这样的：

> ReactiveX 是一个通过使用可观察的序列来组合异步事件编码的类库。

如果你对函数编程不熟悉或者这个定义听起来像是火箭科学（对我来说，还是这样的），你可以把 Rx 想象成一种极端的观察者模式。关于更多的信息，你可以参考 [开始指导](https://github.com/ReactiveX/RxSwift/blob/master/Documentation/GettingStarted.md) 或者 [RxSwift 书籍](https://store.raywenderlich.com/products/rxswift)。

让我们打开 [仓库中的 MVC-RX 项目](https://github.com/uptechteam/Coordinator-MVVM-Rx-Example/tree/master/MVC-Rx)，然后看一下 Rx 是怎么改变代码的。我们将从最普遍的 Rx 应用场景开始 - 我们替换 `LanguageListViewControllerDelegate` 成为两个观测变量：`didCancel` 和 `didSelectLanguage`。

```
/// 展示一个语言的列表。
class LanguageListViewController: UIViewController {
    private let _cancel = PublishSubject<Void>()
    var didCancel: Observable<Void> { return _cancel.asObservable() }

    private let _selectLanguage = PublishSubject<String>()
    var didSelectLanguage: Observable<String> { return _selectLanguage.asObservable() }

    private func setupBindings() {
        cancelButton.rx.tap
            .bind(to: _cancel)
            .disposed(by: disposeBag)

        tableView.rx.itemSelected
            .map { [unowned self] in self.languages[$0.row] }
            .bind(to: _selectLanguage)
            .disposed(by: disposeBag)
    }
}

/// 展示一个通过开发语言来分类的仓库列表。
class RepositoryListViewController: UIViewController {

  /// 在进行导航之前订阅 `LanguageListViewController` 观察对象。
  private func prepareLanguageListViewController(_ viewController: LanguageListViewController) {
          let dismiss = Observable.merge([
              viewController.didCancel,
              viewController.didSelectLanguage.map { _ in }
              ])

          dismiss
              .subscribe(onNext: { [weak self] in self?.dismiss(animated: true) })
              .disposed(by: viewController.disposeBag)

          viewController.didSelectLanguage
              .subscribe(onNext: { [weak self] in
                  self?.currentLanguage = $0
                  self?.reloadData()
              })
              .disposed(by: viewController.disposeBag)
      }
  }
}
```

代理模式完成

`LanguageListViewControllerDelegate` 变成了 `didSelectLanguage` 和 `didCancel` 两个对象。我们在 `prepareLanguageListViewController(_: )` 方法中使用这两个对象来被动的观察 `RepositoryListViewController` 事件。

接下来，我们将重构 `GithubService` 来返回观察对象以取代回调 block 的使用。在那之后，我们将使用 RxCocoa 框架来重写我们的视图控制器。`RepositoryListViewController` 的大部分代码将会被移动到 `setupBindings` 方法，在这个方法里面我们来声明视图控制器的逻辑。

```
private func setupBindings() {
    // 刷新控制
    let reload = refreshControl.rx.controlEvent(.valueChanged)
        .asObservable()

    // 每次重新加载或 currentLanguage 被修改时，都会向 github 服务器发出新的请求。
    let repositories = Observable.combineLatest(reload.startWith(), currentLanguage) { _, language in return language }
        .flatMap { [unowned self] in
            self.githubService.getMostPopularRepositories(byLanguage: $0)
                .observeOn(MainScheduler.instance)
                .catchError { error in
                    self.presentAlert(message: error.localizedDescription)
                    return .empty()
                }
        }
        .do(onNext: { [weak self] _ in self?.refreshControl.endRefreshing() })

    // 绑定仓库数据作为列表视图的数据源。
        .bind(to: tableView.rx.items(cellIdentifier: "RepositoryCell", cellType: RepositoryCell.self)) { [weak self] (_, repo, cell) in
            self?.setupRepositoryCell(cell, repository: repo)
        }
        .disposed(by: disposeBag)

    // 绑定当前语言为导航栏的标题。
    currentLanguage
        .bind(to: navigationItem.rx.title)
        .disposed(by: disposeBag)

    // 订阅表格的单元格选择操作然后在每一个 Item 调用 `openRepository` 操作。
    tableView.rx.modelSelected(Repository.self)
        .subscribe(onNext: { [weak self] in self?.openRepository($0) })
        .disposed(by: disposeBag)

    // 订阅按钮的点击，然后在每一个 Item 调用 `openLanguageList` 操作。
    chooseLanguageButton.rx.tap
        .subscribe(onNext: { [weak self] in self?.openLanguageList() })
        .disposed(by: disposeBag)
}
```

视图控制器逻辑的声明性描述

现在我们可以不用在视图控制器里面实现列表视图的代理对象方法和数据源对象方法了，也将我们的状态变化更改成一种可变的主题。

```
fileprivate let currentLanguage = BehaviorSubject(value: “Swift”)
```

#### 成果

我们已经使用 RxSwift 和 RxCocoa 框架来重构了示例应用。所以这种写法到底给我们带来了什么好处呢？

- 所有逻辑都是被声明式地写到了同一个地方。
- 我们通过观察和响应的方式来处理状态的变化。
- 我们使用 RxCocoa 的语法糖来简短明了地设置列表视图的数据源和代理。

我们的代码仍然不可测试，而视图控制器也还是有着很多的逻辑处理。让我们来看看我们的架构的下一个组成部分。

### MVVM

MVVM 是 Model-View-X 系列的 UI 架构模式。MVVM 与标准 MVC 类似，除了它定义了一个新的组件 - ViewModel，它允许更好地将 UI 与模型分离。本质上，ViewModel 是独立表现视图 UIKit 的对象。

*示例项目在 *[*MVVM-Rx folder*](https://github.com/uptechteam/Coordinator-MVVM-Rx-Example/tree/master/MVVM-Rx)*.*

首先，让我们创建一个 View Model，它将准备在 View 中显示的 Model 数据：

```
class RepositoryViewModel {
    let name: String
    let description: String
    let starsCountText: String
    let url: URL

    init(repository: Repository) {
        self.name = repository.fullName
        self.description = repository.description
        self.starsCountText = "⭐️ \(repository.starsCount)"
        self.url = URL(string: repository.url)!
    }
}
```

接下来，我们将把所有的数据变量和格式代码从 `RepositoryListViewController` 移动到 `RepositoryListViewModel`：

```
class RepositoryListViewModel {

    // MARK: - 输入
    /// 设置当前语言， 重新加载仓库。
    let setCurrentLanguage: AnyObserver<String>

    /// 被选中的语言。
    let chooseLanguage: AnyObserver<Void>

    /// 被选中的仓库。
    let selectRepository: AnyObserver<RepositoryViewModel>

    /// 重新加载仓库。
    let reload: AnyObserver<Void>

    // MARK: - 输出
    /// 获取的仓库数组。
    let repositories: Observable<[RepositoryViewModel]>
    
    /// navigation item 标题。
    let title: Observable<String>

    /// 显示的错误信息。
    let alertMessage: Observable<String>
    
    /// 显示的仓库的首页 URL。
    let showRepository: Observable<URL>
    
    /// 显示的语言列表。
    let showLanguageList: Observable<Void>

    init(initialLanguage: String, githubService: GithubService = GithubService()) {

        let _reload = PublishSubject<Void>()
        self.reload = _reload.asObserver()

        let _currentLanguage = BehaviorSubject<String>(value: initialLanguage)
        self.setCurrentLanguage = _currentLanguage.asObserver()

        self.title = _currentLanguage.asObservable()
            .map { "\($0)" }

        let _alertMessage = PublishSubject<String>()
        self.alertMessage = _alertMessage.asObservable()

        self.repositories = Observable.combineLatest( _reload, _currentLanguage) { _, language in language }
            .flatMapLatest { language in
                githubService.getMostPopularRepositories(byLanguage: language)
                    .catchError { error in
                        _alertMessage.onNext(error.localizedDescription)
                        return Observable.empty()
                    }
            }
            .map { repositories in repositories.map(RepositoryViewModel.init) }

        let _selectRepository = PublishSubject<RepositoryViewModel>()
        self.selectRepository = _selectRepository.asObserver()
        self.showRepository = _selectRepository.asObservable()
            .map { $0.url }

        let _chooseLanguage = PublishSubject<Void>()
        self.chooseLanguage = _chooseLanguage.asObserver()
        self.showLanguageList = _chooseLanguage.asObservable()
    }
}
```

现在，我们的视图控制器将所有 UI 交互（如按钮点击或行选择）委托给 View Model，并观察 View Model 输出数据或事件（像 `showLanguageList` 这样）。

我们将为 `LanguageListViewController` 做同样的事情，看起来一切进展顺利。但是我们的测试文件夹仍然是空的！View Models 的引入使我们能够测试一大堆代码。因为 ViewModels 纯粹地使用注入的依赖关系将输入转换为输出。ViewModels 和单元测试是我们应用程序中最好的朋友。

我们将使用 RxSwift 附带的 RxTest 框架测试应用程序。最重要的部分是 `TestScheduler` 类，它允许你通过定义在何时应该发出值来创建假的可观察值。这就是我们测试 View Models 的方式：

```
func test_SelectRepository_EmitsShowRepository() {
    let repositoryToSelect = RepositoryViewModel(repository: testRepository)
    // 倒计时 300 秒后创建一个假的观测变量
    let selectRepositoryObservable = testScheduler.createHotObservable([next(300, repositoryToSelect)])

    // 绑定 selectRepositoryObservable 的输入
    selectRepositoryObservable
        .bind(to: viewModel.selectRepository)
        .disposed(by: disposeBag)

    // 订阅 showRepository 的输出值并启动 testScheduler
    let result = testScheduler.start { self.viewModel.showRepository.map { $0.absoluteString } }

    // 断言判断结果的 url 是否等于预期的 url
    XCTAssertEqual(result.events, [next(300, "https://www.apple.com")])
}
```

#### 成果

好啦，我们已经从 MVC 转到了 MVVM。 但是两者有什么区别呢？

- 视图控制器更轻量化；
- 数据处理的逻辑与视图控制器分离；
- MVVM 使我们的代码可以测试；

我们的 View Controllers 还有一个问题 - `RepositoryListViewController` 知道 `LanguageListViewController` 的存在并且管理着导航流。让我们用 Coordinators 来解决它。

### Coordinators

如果你还没有听到过 Coordinators 的话，我强烈建议你阅读 Soroush Khanlou [这篇超赞的博客] (http://khanlou.com/2015/10/coordinators-redux/)。

简而言之，Coordinators 是控制我们应用程序的导航流的对象。 他们帮助的有：

- 解耦和重用 ViewControllers；
- 将依赖关系传递给导航层次；
- 定义应用程序的用例；
- 实现深度链接；

![](https://ws4.sinaimg.cn/large/006tKfTcgy1fj0za6nv8uj318g0n541f.jpg)

Coordinators 流程

该图显示了应用程序中典型的 coordinators 流程。App Coordinator 检查是否存在有效的访问令牌，并决定显示下一个 coordinator - 登录或 Tab Bar。TabBar Coordinator 显示三个子 coordinators，它们分别对应于 Tab Bar items。

我们终于来到我们的重构过程的最后。完成的项目位于 [Coordinators-MVVM-Rx](https://github.com/uptechteam/Coordinator-MVVM-Rx-Example/tree/master/Coordinators-MVVM-Rx) 目录下。有什么变化呢？

首先，我们来看看 `BaseCoordinator` 是什么：

```
/// 基于 `start` 方法的返回类型
class BaseCoordinator<ResultType> {

    /// Typealias 允许通过 `CoordinatorName.CoordinationResult` 方法获取 Coordainator 的返回类型
    typealias CoordinationResult = ResultType

    /// 子类可调用的 `DisposeBag` 函数
    let disposeBag = DisposeBag()

    /// 特殊标识符
    private let identifier = UUID()

    /// 子 coordinators 的字典。每一个 coordinator 都应该被添加到字典中，以便暂存在内存里面
    
    /// Key 是子 coordinator 的一个 `identifier` 标志，而对应的 value 则是 coordinator 本身。
    
    /// 值类型是 `Any`，因为 Swift 不允许在数组中存储泛型的值。
    private var childCoordinators = [UUID: Any]()

    /// 在 `childCoordinators` 这个字典中存储 coordinator
    private func store<T>(coordinator: BaseCoordinator<T>) {
        childCoordinators[coordinator.identifier] = coordinator
    }

    /// 从 `childCoordinators` 这个字典中释放 coordinator
    private func free<T>(coordinator: BaseCoordinator<T>) {
        childCoordinators[coordinator.identifier] = nil
    }
    
    /// 1. 在存储子 coordinators 的字典中存储 coordinator
    /// 2. 调用 coordinator 的 `start()` 函数
    /// 3. 返回观测变量的 `start()` 函数后，在 `onNext:` 方法中执行从字典中移除掉 coordinator 的操作。
    func coordinate<T>(to coordinator: BaseCoordinator<T>) -> Observable<T> {
        store(coordinator: coordinator)
        return coordinator.start()
            .do(onNext: { [weak self] _ in self?.free(coordinator: coordinator) })
    }
    
    /// coordinator 的开始工作。
    ///
    /// - Returns: Result of coordinator job.
    func start() -> Observable<ResultType> {
        fatalError("Start method should be implemented.")
    }
}
```

基本 Coordinator

该通用对象为具体 coordinators 提供了三个功能：

- 启动 coordinator 工作（即呈现视图控制器）的抽象方法 `start()` ；
- 在通过的子 coordinator 上调用 `start()` 并将其保存在内存中的通用方法 `coordinate(to: )`；
- 被子类使用的 `disposeBag`；

*为什么 *`*start*`* 方法返回一个 *`*Observable*`*，什么又是 *`*ResultType*`* 呢？

`ResultType` 是表示 coordinator 工作结果的类型。更多的 `ResultType` 将是 `Void`，但在某些情况下，它将会是可能的结果情况的枚举。`start` 将只发出一个结果项并完成。

我们在应用程序中有三个 Coordinators：

- Coordinators 层级结构的根 `AppCoordinator`；
- RepositoryListCoordinator`；
- `LanguageListCoordinator`。

让我们看看最后一个 Coordinator 如何与 ViewController 和 ViewModel 进行通信，并处理导航流程：

```
/// 用于定义 `LanguageListCoordinator` 可能的 coordinator 结果的类型.
///
/// - language: 被选择的语言。
/// - cancel: 取消按钮被点击。
enum LanguageListCoordinationResult {
    case language(String)
    case cancel
}

class LanguageListCoordinator: BaseCoordinator<LanguageListCoordinationResult> {

    private let rootViewController: UIViewController

    init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
    }

    override func start() -> Observable<CoordinationResult> {
        // 从 storyboard 初始化一个试图控制器，并将其放入到 UINavigationController 堆栈中。
        let viewController = LanguageListViewController.initFromStoryboard(name: "Main")
        let navigationController = UINavigationController(rootViewController: viewController)

        // 初始化 View Model 并将其注入 View Controller
        let viewModel = LanguageListViewModel()
        viewController.viewModel = viewModel

        // 将 View Model 的输出映射到 LanguageListCoordinationResult 类型
        let cancel = viewModel.didCancel.map { _ in CoordinationResult.cancel }
        let language = viewModel.didSelectLanguage.map { CoordinationResult.language($0) }

        // 将当前的 试图控制器放到提供的 rootViewController 上。
        rootViewController.present(navigationController, animated: true)

        // 合并 View Model 的映射输出，仅获取第一个发送的事件，并关闭该事件的试图控制器
        return Observable.merge(cancel, language)
            .take(1)
            .do(onNext: { [weak self] _ in self?.rootViewController.dismiss(animated: true) })
    }
}
```

LanguageListCoordinator 工作的结果可以是选定的语言，如果用户点击了“取消”按钮，也可以是无效的。这两种情况都在 `LanguageListCoordinationResult` 枚举中被定义。

在 `RepositoryListCoordinator` 中，我们通过 `LanguageListCoordinator` 的显示来绘制 `showLanguageList` 的输出。在 `LanguageListCoordinator` 的 `start()` 方法完成后，我们会过滤结果，如果有一门语言被选中了，我们就将其作为参数来调用 View Model 的 `setCurrentLanguage` 方法。

```
override func start() -> Observable<Void> {

    ...
    // 检测请求结果来展示列表
    viewModel.showLanguageList
        .flatMap { [weak self] _ -> Observable<String?> in
            guard let `self` = self else { return .empty() }
            // Start next coordinator and subscribe on it's result
            return self.showLanguageList(on: viewController)
        }
        // 忽略 nil 结果，这代表着语言列表的页面被 dismiss 掉了
        .filter { $0 != nil }
        .map { $0! }
        .bind(to: viewModel.setCurrentLanguage)
        .disposed(by: disposeBag)

    ...

    // 这里返回 `Observable.never()`，因为 RepositoryListViewController 这个控制器一直都是显示的
    return Observable.never()
}

// 启动 LanguageListCoordinator
// 如果点击取消或者选择了一门已经被选择的语言的时候，返回 nil
private func showLanguageList(on rootViewController: UIViewController) -> Observable<String?> {
    let languageListCoordinator = LanguageListCoordinator(rootViewController: rootViewController)
    return coordinate(to: languageListCoordinator)
        .map { result in
            switch result {
            case .language(let language): return language
            case .cancel: return nil
            }
        }
}
```

*注意我们返回了 *`*Observable.never()*`* 因为仓库列表的页面一直都是在视图栈级结构里面的。*

#### 结果

我们完成了我们最后一步的重构，我们做了：

- 把导航栏的逻辑移除出了视图控制器，进行了解耦；
- 将视图模型注入到视图控制器中；
- 简化了故事板；

---

以鸟瞰图的方式，我们的系统是长这样子的：

![MVVM-C 架构设计](https://ws4.sinaimg.cn/large/006tKfTcgy1fj0w69fbojj318g0tcgo8.jpg)

应用的 Coordinator 管理器启动了第一个 Coordinator 来初始化 View Model，然后注入到了视图控制器并进行了展示。视图控制器发送了类似按钮点击和 cell section 这样的用户事件到 View Model。而 View Model 则提供了处理过的数据回到视图控制器，并且调用 Coordinator 来进入下一个页面。当然，Coordinator 也可以传送事件到 View Model 进行处理。

### 结论

我们已经考虑到了很多：我们讨论的 MVVM 对 UI 结构进行了描述，使用 Coordinators 解决了导航/路由的问题，并且使用 RxSwift 对代码进行了声明式改造。我们一步步的对应用进行了重构，并且展示了每一步操作的影响。

构建一个应用是没有捷径的。每一个解决方案都有其自身的缺点，不一定都适用于你的应用。进行应用结构的选择，重点在于特定情况的权衡利弊。

当然，相比之前而言，Rx，Coordinators 和 MVVM 相互结合的方式有更多的使用场景，所以请一定要让我知道，如果你希望我写多一篇更深入边界条件，疑难解答的博客的话。

感谢你的阅读！

---

*作者 Myronenko, *[*UPTech 小组*](https://uptech.team/)* ❤️*

---

*如果你认为这篇博客可以帮助到你，点击下面的 * 💚 * 让更多人阅读它。粉一下我们，以便了解更多关于构建优质产品的文章。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。


