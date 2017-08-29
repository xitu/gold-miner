
> * 原文地址：[Taming Great Complexity: MVVM, Coordinators and RxSwift](https://blog.uptech.team/taming-great-complexity-mvvm-coordinators-and-rxswift-8daf8a76e7fd)
> * 原文作者：[Arthur Myronenko](https://blog.uptech.team/@arthur.myronenko)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/taming-great-complexity-mvvm-coordinators-and-rxswift.md](https://github.com/xitu/gold-miner/blob/master/TODO/taming-great-complexity-mvvm-coordinators-and-rxswift.md)
> * 译者：[jingzhilehuakai](https://github.com/jingzhilehuakai)
> * 校对者：

# MVVM, Coordinators 和 RxSwift 的抽丝剥茧

![](https://ws4.sinaimg.cn/large/006tNc79gy1fiygh2f3haj31jk15m7wh.jpg)

去年，我们的团队开始在生产应用中使用 Coordinators 和 MVVM。 起初看起来很可怕，但是从那时起到现在，我们已经完成了 4 个基于这种模式开发的应用程序。在本文中，我将分享我们的经验，并将指导你探索 MVVM, Coordinators 和响应式编程。
Last year our team started using Coordinators and MVVM in a production app. At first it looked scary, but since then we’ve finished 4 applications built on top of those architectural patterns. In this article I will share our experience and will guide you to the land of MVVM, Coordinators & Reactive programming.

我们将从一个简单的 MVC 示例应用程序开始，而不是一开始就给出一个定义。我们将逐步进行重构，以显示每个组件如何影响代码库以及结果如何。每一步都将以简短的理论介绍作为前提。
Instead of giving a definition up front, we will start with a simple MVC example application. We will do the refactoring slowly step by step to show how every component affects the codebase and what are the outcomes. Every step will be prefaced with a brief theory intro.

###示例

在这篇文章中，我们将使用一个简单的示例程序，这个程序展示了一个通过星星数进行排序，通过开发语言进行分类的列表。包含两个页面，一个是分类过滤后的仓库列表，另一个则是用来分类的开发语言列表。
In this article we are going to use a simple example application that displays a list of the most starred repositories on GitHub by language. It has two screens: a list of repositories filtered by language and a list of languages to filter repositories by.

![Screens of the example app](https://ws2.sinaimg.cn/large/006tNc79gy1fiygh3b4w8j318g0s0jv0.jpg)

用户可以通过点击导航栏上的按钮来进入第二个页面。在这个语言列表里，可以选择一个语言或者通过点击取消按钮来退出页面。如果用户在第二个页面选择了一个开发语言，页面将会执行退出操作，而仓库列表页面也会根据已选的开发语言来进行内容刷新。
A user can tap on a button in the navigation bar to show the second screen. On the languages screen he can select a language or dismiss the screen by tapping on the cancel button. If a user selects a language the screen will dismiss and the repositories list will update according to the selected language.

你可以在下面的链接里找到源代码文件：
You can find the source code here:

[![](https://ws3.sinaimg.cn/large/006tKfTcgy1fi4hjpkfvqj314k0aqgmv.jpg)](https://github.com/uptechteam/Coordinator-MVVM-Rx-Example)

这个仓库包含四个文件夹：MVC，MVC-Rx，MVVM-Rx，Coordinators-MVVM-Rx。分别对应重构的被一个步骤。让我们打开 [MVC folder](https://github.com/uptechteam/Coordinator-MVVM-Rx-Example/tree/master/MVC) 这个项目，然后在进行重构之前先看一下。
The repository contains 4 folders: MVC, MVC-Rx, MVVM-Rx, Coordinators-MVVM-Rx correspondingly to each step of the refactoring. Let’s open the project in the [MVC folder](https://github.com/uptechteam/Coordinator-MVVM-Rx-Example/tree/master/MVC) and look at the code before refactoring.

大部分的代码都在两个视图控制器中：`RepositoryListViewController` 和 `LanguageListViewController`。第一个视图控制器获取了一个最受欢迎仓库的列表，然后通过表格展示给了用户，第二个视图控制器则是展示了一个开发语言的列表。`RepositoryListViewController` 是 `LanguageListViewController` 的一个代理持有对象，拥有如下的代理响应：
Most of the code is in two View Controllers: `RepositoryListViewController` and `LanguageListViewController`. The first one fetches a list of the most popular repositories and shows it to the user via a table view, the second one displays a list of languages. `RepositoryListViewController` is a delegate of the `LanguageListViewController` and conforms to the following protocol:

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
Also, you could notice two variables in the global scope that define a state of the `RepositoryListViewController`: `currentLanguage` and `repositories`. Such stateful variables introduce complexity to the class and are a common source of bugs when parts of our app might end up in a state we didn’t expect. To sum up, we have several issues with the current codebase:

- 视图控制器包揽了太多的责任；
- 我们需要被动地处理状态的变化；
- 代码不可测。
- View Controller has too many responsibilities;
- we need to deal with state changes reactively;
- the code is not testable at all.

是时候去见一下我们新的客人了。
Time to meet our first guest.

### RxSwift

这个组件将允许我们被动的响应状态变化和写出声明式代码。
The component that will allow us to respond to changes reactively and write declarative code.

Rx 是什么？其中有一个定义是这样的：
What is Rx? One of the definitions is:

> ReactiveX 是一个通过使用可观察的序列来组合异步事件编码的类库。
> ReactiveX is a library for composing asynchronous and event-based programs by using observable sequences.

如果你对函数编程不熟悉或者这个定义听起来像是火箭科学（对我来说，还是这样的），你可以把 Rx 想象成一种观察者模式。关于更多的信息，你可以参考 [开始指导](https://github.com/ReactiveX/RxSwift/blob/master/Documentation/GettingStarted.md) 或者 [RxSwift 书籍](https://store.raywenderlich.com/products/rxswift)。
If you are not familiar with functional programming or that definition sounds like a rocket science (it still does for me) you can think of Rx as an Observer pattern on steroids. For more info, you can refer to the [Getting Started guide](https://github.com/ReactiveX/RxSwift/blob/master/Documentation/GettingStarted.md) or to the [RxSwift Book](https://store.raywenderlich.com/products/rxswift).

让我们打开 [仓库中的 MVC-RX 项目](https://github.com/uptechteam/Coordinator-MVVM-Rx-Example/tree/master/MVC-Rx)，然后看一下 Rx 是怎么改变代码的。我们将从最普遍的 Rx 应用场景开始 - 我们替换 `LanguageListViewControllerDelegate` 成为两个观测变量：`didCancel` 和 `didSelectLanguage`。
Let’s open [MVC-Rx project in the repository](https://github.com/uptechteam/Coordinator-MVVM-Rx-Example/tree/master/MVC-Rx) and take a look at how Rx changes the code. We will start from the most obvious things to do with Rx — we replace the `LanguageListViewControllerDelegate` with two observables: `didCancel` and `didSelectLanguage`.

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
  ///
  /// - Parameter viewController: `LanguageListViewController` to prepare.
  private func prepareLanguageListViewController(_ viewController: LanguageListViewController) {
          // We need to dismiss the LanguageListViewController if a language was selected or if a cancel button was tapped.
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

代理对象设置正确
Delegate pattern done right

`LanguageListViewControllerDelegate` 变成了 `didSelectLanguage` 和 `didCancel` 两个对象。我们在 `prepareLanguageListViewController(_: )` 方法中使用这两个对象来被动的观察 `RepositoryListViewController` 事件。
`LanguageListViewControllerDelegate` became the `didSelectLanguage` and `didCancel` observables. We use them in the `prepareLanguageListViewController(_: )` method to reactively observe `RepositoryListViewController` events.

接下来，我们将重构 `GithubService` 来返回观察对象以取代回调 block 的使用。在那之后，我们将使用 RxCocoa 框架来重写我们的视图控制器。`RepositoryListViewController` 的大部分代码将会被移动到 `setupBindings` 方法，在这个方法里面我们来声明视图控制器的逻辑。
Next, we will refactor the `GithubService` to return observables instead of using callbacks. After that, we will use the power of the RxCocoa framework to rewrite our View Controllers. Most of the code of the `RepositoryListViewController` will move to the `setupBindings` function where we declaratively describe a logic of the View Controller:

```
private func setupBindings() {
    // 刷新控制
    let reload = refreshControl.rx.controlEvent(.valueChanged)
        .asObservable()

    // 每次重新加载或 currentLanguage 被修改时，都会向 github 服务器发出新的请求。
    // Emits an array of repositories - result of request.
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
A declarative description of the view controller logic

现在我们可以不用在视图控制器里面实现列表视图的代理对象方法和数据源对象方法了，也将我们的状态变化更改成一种可变的主题。
Now we got rid of the table view delegate and data source method in view controllers and moved our state to one mutable subject:

```
fileprivate let currentLanguage = BehaviorSubject(value: “Swift”)
```

#### 成果
#### Outcomes

我们已经使用 RxSwift 和 RxCocoa 框架来重构了示例应用。所以这种写法到底给我们带来了什么好处呢？
We’ve refactored example application using RxSwift and RxCocoa frameworks. So what exactly it gives us?

- 所有逻辑都是被声明式地写到了同一个地方。
- 我们通过观察和响应的方式来处理状态的变化。
- 我们使用 RxCocoa 的语法糖来简短明了地设置列表视图的数据源和代理。
- all the logic is declaratively written in one place;
- we reduced state to one subject of current language which we observe and react to changes;
- we used some syntactic sugar from RxCocoa to setup table view data source and delegate briefly and clearly.

我们的代码仍然不可测试，而视图控制器也还是有着很多的逻辑处理。让我们来看看我们的架构的下一个组成部分。

Our code still isn’t testable and View Controllers still responsible for a lot of things. Let’s turn to the next component of our architecture.

### MVVM

MVVM 是 Model-View-X 系列的 UI 架构模式。MVVM 与标准 MVC 类似，除了它定义了一个新的组件 - ViewModel，它允许更好地将 UI 与模型分离。本质上，ViewModel 是独立表现视图 UIKit 的对象。
MVVM is a UI architectural pattern from Model-View-X family. MVVM is similar to the standard MVC, except it defines one new component — ViewModel, which allows to better decouple UI from the Model. Essentially, ViewModel is an object which represents View UIKit-independently.

*示例项目在 *[*MVVM-Rx folder*](https://github.com/uptechteam/Coordinator-MVVM-Rx-Example/tree/master/MVVM-Rx)*.*
*The example project is in the *[*MVVM-Rx folder*](https://github.com/uptechteam/Coordinator-MVVM-Rx-Example/tree/master/MVVM-Rx)*.*

首先，让我们创建一个 View Model，它将准备在 View 中显示的 Model 数据：
First, let’s create a View Model which will prepare the Model data for displaying in the View:

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
Next we will move all our data mutation and formatting code from the `RepositoryListViewController` into `RepositoryListViewModel`:

```
class RepositoryListViewModel {

    // MARK: - 输入
    /// 设置当前语言， 重新加载仓库。
    /// Call to update current language. Causes reload of the repositories.
    let setCurrentLanguage: AnyObserver<String>

    /// 被选中的语言。
    /// Call to show language list screen.
    let chooseLanguage: AnyObserver<Void>

    /// 被选中的仓库。
    /// Call to open repository page.
    let selectRepository: AnyObserver<RepositoryViewModel>

    /// 重新加载仓库。
    /// Call to reload repositories.
    let reload: AnyObserver<Void>

    // MARK: - 输出
    /// 获取的仓库数组。
    /// Emits an array of fetched repositories.
    let repositories: Observable<[RepositoryViewModel]>
    
    /// navigation item 标题。
    /// Emits a formatted title for a navigation item.
    let title: Observable<String>

    /// 显示的错误信息。
    /// Emits an error messages to be shown.
    let alertMessage: Observable<String>
    
    /// 显示的仓库的首页 URL。
    /// Emits an url of repository page to be shown.
    let showRepository: Observable<URL>
    
    /// 显示的语言列表。
    /// Emits when we should show language list.
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
Now our View Controller delegates all the UI interactions like buttons clicks or row selection to the View Model and observes View Model outputs with data or events like `showLanguageList`.

我们将为 `LanguageListViewController` 做同样的事情，看起来一切进展顺利。但是我们的测试文件夹仍然是空的！View Models 的引入使我们能够测试一大堆代码。因为 ViewModels 纯粹地使用注入的依赖关系将输入转换为输出。ViewModels 和单元测试是我们应用程序中最好的朋友。
We will do the same for the `LanguageListViewController` and looks like we are good to go. But our tests folder is still empty! The introduction of the View Models allowed us to test a big chunk of our code. Because ViewModels purely convert inputs into outputs using injected dependencies ViewModels and Unit Tests are the best friends in our apps.

我们将使用 RxSwift 附带的 RxTest 框架测试应用程序。最重要的部分是 `TestScheduler` 类，它允许你通过定义在何时应该发出值来创建假的可观察值。这就是我们测试 View Models 的方式：
We will test the application using RxTest framework which ships with RxSwift. The most important part is a `TestScheduler` class, that allows you to create fake observables by defining at what time they should emit values. That’s how we test View Models:

```
func test_SelectRepository_EmitsShowRepository() {
    let repositoryToSelect = RepositoryViewModel(repository: testRepository)
    // Create fake observable which fires at 300
    // 倒计时 300 秒后创建一个假的观测变量
    let selectRepositoryObservable = testScheduler.createHotObservable([next(300, repositoryToSelect)])

    // 绑定 selectRepositoryObservable 的输入
    // Bind fake observable to the input
    selectRepositoryObservable
        .bind(to: viewModel.selectRepository)
        .disposed(by: disposeBag)

    // 订阅 showRepository 的输出值并启动 testScheduler
    // Subscribe on the showRepository output and start testScheduler
    let result = testScheduler.start { self.viewModel.showRepository.map { $0.absoluteString } }

    // 断言判断结果的 url 是否等于预期的 url
    // Assert that emitted url as equal to the expected one
    XCTAssertEqual(result.events, [next(300, "https://www.apple.com")])
}
```

查看 Model 测试
View Model tests

#### 成果
#### Outcomes

好啦，我们已经从 MVC 转到了 MVVM。 但是两者有什么区别呢？
Okay, we’ve moved from MVC to the MVVM. But what’s the difference?

- 视图控制器更轻量化；
- 数据处理的逻辑与视图控制器分离；
- MVVM 使我们的代码可以测试；
- View Controllers are thinner now;
- the data formatting logic is decoupled from the View Controllers;
- MVVM made our code testable.

我们的 View Controllers 还有一个问题 - `RepositoryListViewController` 知道 `LanguageListViewController` 的存在并且管理着导航流。让我们用 Coordinators 来解决它。
There is one more problem with our View Controllers though — `RepositoryListViewController` knows about the existence of the `LanguageListViewController` and manages navigation flow. Let’s fix it with Coordinators.

### Coordinators

如果你还没有听到过 Coordinators 的话，我强烈建议你阅读 Soroush Khanlou [这篇超赞的博客] (http://khanlou.com/2015/10/coordinators-redux/)。
If you haven’t heard about Coordinators yet, I strongly recommend reading [this awesome blog post](http://khanlou.com/2015/10/coordinators-redux/) by Soroush Khanlou which gives a nice introduction.

简而言之，Coordinators 是控制我们应用程序的导航流的对象。 他们帮助的有：
In short, Coordinators are the objects which control the navigation flow of our application. They help to:

- 隔离和重用 ViewControllers；
- 将依赖关系传递给导航层次；
- 定义应用程序的用例；
- 实现深层次联系；
- isolate and reuse ViewControllers;
- pass dependencies down the navigation hierarchy;
- define use cases of the application;
- implement deep linking.

![](https://ws4.sinaimg.cn/large/006tKfTcgy1fj0za6nv8uj318g0n541f.jpg)

Coordinators 流程
Coordinators Flow

该图显示了应用程序中典型的 coordinators 流程。App Coordinator 检查是否存在有效的访问令牌，并决定显示下一个 coordinator - 登录或 Tab Bar。TabBar Coordinator 显示三个子 coordinators，它们分别对应于 Tab Bar items。
The diagram shows the typical coordinators flow in the application. App Coordinator checks if there is a stored valid access token and decides which coordinator to show next — Login or Tab Bar. TabBar Coordinator shows three child coordinators which correspond to the Tab Bar items.

我们终于来到我们的重构过程的最后。完成的项目位于 [Coordinators-MVVM-Rx](https://github.com/uptechteam/Coordinator-MVVM-Rx-Example/tree/master/Coordinators-MVVM-Rx) 目录下。有什么变化呢？
We are finally coming to the end of our refactoring process. The completed project is located in the [Coordinators-MVVM-Rx](https://github.com/uptechteam/Coordinator-MVVM-Rx-Example/tree/master/Coordinators-MVVM-Rx) directory. What has changed?

首先，我们来看看 `BaseCoordinator` 是什么：
First, let’s check what is `BaseCoordinator`:

```
/// 基于 `start` 方法的返回类型
/// Base abstract coordinator generic over the return type of the `start` method.
class BaseCoordinator<ResultType> {

    /// Typealias 允许通过 `CoordinatorName.CoordinationResult` 方法获取 Coordainator 的返回类型
    /// Typealias which will allows to access a ResultType of the Coordainator by `CoordinatorName.CoordinationResult`.
    typealias CoordinationResult = ResultType

    /// 子类可调用的 `DisposeBag` 函数
    /// Utility `DisposeBag` used by the subclasses.
    let disposeBag = DisposeBag()

    /// 特殊标识符
    /// Unique identifier.
    private let identifier = UUID()

    /// 子 coordinators 的字典。每一个 coordinator 都应该被添加到字典中，以便暂存在内存里面
    /// Dictionary of the child coordinators. Every child coordinator should be added
    /// to that dictionary in order to keep it in memory.
    
    /// Key 是子 coordinator 的一个 `identifier` 标志，而对应的 value 则是 coordinator 本身。
    /// Key is an `identifier` of the child coordinator and value is the coordinator itself.
    
    /// 值类型是 `Any`，因为 Swift 不允许在数组中存储泛型的值。
    /// Value type is `Any` because Swift doesn't allow to store generic types in the array.
    private var childCoordinators = [UUID: Any]()

    /// 在 `childCoordinators` 这个字典中存储 coordinator
    /// Stores coordinator to the `childCoordinators` dictionary.
    ///
    /// - Parameter coordinator: Child coordinator to store.
    private func store<T>(coordinator: BaseCoordinator<T>) {
        childCoordinators[coordinator.identifier] = coordinator
    }

    /// 从 `childCoordinators` 这个字典中释放 coordinator
    /// Release coordinator from the `childCoordinators` dictionary.
    ///
    /// - Parameter coordinator: Coordinator to release.
    private func free<T>(coordinator: BaseCoordinator<T>) {
        childCoordinators[coordinator.identifier] = nil
    }
    
    /// 1. 在存储子 coordinators 的字典中存储 coordinator
    /// 2. 调用 coordinator 的 `start()` 函数
    /// 3. 返回观测变量的 `start()` 函数后，在 `onNext:` 方法中执行从字典中移除掉 coordinator 的操作。 
    /// 1. Stores coordinator in a dictionary of child coordinators.
    /// 2. Calls method `start()` on that coordinator.
    /// 3. On the `onNext:` of returning observable of method `start()` removes coordinator from the dictionary.
    ///
    /// - Parameter coordinator: Coordinator to start.
    /// - Returns: Result of `start()` method.
    func coordinate<T>(to coordinator: BaseCoordinator<T>) -> Observable<T> {
        store(coordinator: coordinator)
        return coordinator.start()
            .do(onNext: { [weak self] _ in self?.free(coordinator: coordinator) })
    }
    
    /// coordinator 的开始工作。
    /// Starts job of the coordinator.
    ///
    /// - Returns: Result of coordinator job.
    func start() -> Observable<ResultType> {
        fatalError("Start method should be implemented.")
    }
}
```

基本 Coordinator
Base Coordinator

该通用对象为具体 coordinators 提供了三个功能：
That generic object provides three features for the concrete coordinators:

- 启动 coordinator 工作（即呈现视图控制器）的抽象方法 `start()` ；
- 在通过的子 coordinator 上调用 `start()` 并将其保存在内存中的通用方法 `coordinate(to: )`；
- 被子类使用的 `disposeBag`；
- abstract method `start()` which starts the coordinator job (i.e. presents the view controller);
- generic method `coordinate(to: )` which calls `start()` on the passed child coordinator and keeps it in the memory;
- `disposeBag` used by subclasses.

*为什么 *`*start*`* 方法返回一个 *`*Observable*`*，什么又是 *`*ResultType*`* 呢？
*Why does the *`*start*`* method return an *`*Observable*`* and what is a *`*ResultType*`*?*

`ResultType` 是表示 coordinator 工作结果的类型。更多的 `ResultType` 将是 `Void`，但在某些情况下，它将会是可能的结果情况的枚举。`start` 将只发出一个结果项并完成。
`ResultType` is a type which represents a result of the coordinator job. More often `ResultType` will be a `Void` but for certain cases, it will be an enumeration of possible result cases. The `start` will emit exactly one result item and complete.

我们在应用程序中有三个 Coordinators：
We have three Coordinators in the application:

- Coordinators 层级结构的根 `AppCoordinator`；
- RepositoryListCoordinator`；
- `LanguageListCoordinator`。

让我们看看最后一个 Coordinator 如何与 ViewController 和 ViewModel 进行通信，并处理导航流程：
Let’s see how the last one communicates with ViewController and ViewModel and handles the navigation flow:

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
Result of the LanguageListCoordinator work can be a selected language or nothing if a user taps on “Cancel” button. Both cases are defined in the `LanguageListCoordinationResult` enum.

在 `RepositoryListCoordinator` 中，我们通过 `LanguageListCoordinator` 的显示来绘制 `showLanguageList` 的输出。在 `LanguageListCoordinator` 的 `start()` 方法完成后，我们会过滤结果，如果有一门语言被选中了，我们就将其作为参数来调用 View Model 的 `setCurrentLanguage` 方法。
In the `RepositoryListCoordinator` we flatMap the `showLanguageList` output by the presentation of the `LanguageListCoordinator`. After the `start()` method of the `LanguageListCoordinator` completes we filter the result and if a language was chosen we send it to the `setCurrentLanguage` input of the View Model.

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
        // Ignore nil results which means that Language List screen was dismissed by cancel button.
        // 忽略 nil 结果，这代表着语言列表的页面被 dismiss 掉了
        .filter { $0 != nil }
        .map { $0! }
        // Bind selected language to the `setCurrentLanguage` observer of the View Model
        .bind(to: viewModel.setCurrentLanguage)
        .disposed(by: disposeBag)

    ...

    // We return `Observable.never()` here because RepositoryListViewController is always on screen.
    // 这里返回 `Observable.never()`，因为 RepositoryListViewController 这个控制器一直都是显示的
    return Observable.never()
}

// Starts the LanguageListCoordinator
// 启动 LanguageListCoordinator
// Emits nil if LanguageListCoordinator resulted with `cancel` or selected language
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
*Notice that we return *`*Observable.never()*`* because Repository List screen is always in the view hierarchy.*

#### 结果
#### Outcomes

我们完成了我们最后一步的重构，我们做了：
We finished our last stage of the refactoring, where we

- 把导航栏的逻辑移除出了视图控制器，进行了解耦；
- 将视图模型注入到视图控制器中；
- 简化了故事板；
- moved the navigation logic out of the View Controllers and isolated them;
- setup injection of the View Models into the View Controllers;
- simplified the storyboard.

---

以鸟瞰图的方式，我们的系统是长这样子的：
From the bird’s eye view our system looks like this:

![](https://ws4.sinaimg.cn/large/006tKfTcgy1fj0w69fbojj318g0tcgo8.jpg)

MVVM-C 架构设计
MVVM-C architecture

应用的 Coordinator 管理器启动了第一个 Coordinator 来初始化 View Model，然后注入到了视图控制器并进行了展示。视图控制器发送了类似按钮点击和 cell section 这样的用户事件到 View Model。而 View Model 则提供了处理过的数据回到视图控制器，并且调用 Coordinator 来进入下一个页面。当然，Coordinator 也可以传送事件到 View Model 进行处理。
The App Coordinator starts the first Coordinator which initializes View Model, injects into View Controller and presents it. View Controller sends user events such as button taps or cell section to the View Model. View Model provides formatted data to the View Controller and asks Coordinator to navigate to another screen. The Coordinator can send events to the View Model outputs as well.

### 结论
### Conclusion

我们已经考虑到了很多：我们讨论的 MVVM 对 UI 结构进行了描述，使用 Coordinators 解决了导航/路由的问题，并且使用 RxSwift 对代码进行了声明式改造。我们一步步的对应用进行了重构，并且展示了每一步操作的影响。
We’ve covered a lot: we talked about the MVVM which describes UI architecture, solved the problem of navigation/routing with Coordinators and made our code declarative using RxSwift. We’ve done step-by-step refactoring of our application and shown how every component affects the codebase.

构建一个应用是没有捷径的。每一个解决方案都有其自身的缺点，不一定都适用于你的应用。进行应用结构的选择，重点在于特定情况的权衡利弊。
There are no silver bullets when it comes to building an iOS app architecture. Each solution has its own drawbacks and may or may not suit your project. Sticking to the architecture is a matter of weighing tradeoffs in your particular situation.

当然，相比之前而言，Rx，Coordinators 和 MVVM 相互结合的方式有更多的使用场景，所以请一定要让我知道，如果你希望我写多一篇更深入边界条件，疑难解答的博客的话。
There’s, of course, a lot more to Rx, Coordinators and MVVM than what I was able to cover in this post, so please let me know if you’d like me to do another post that goes more in-depth about edge cases, problems and solutions.

感谢你的阅读！
Thanks for reading!

---

*作者 Myronenko, *[*UPTech 小组*](https://uptech.team/)* ❤️*
*Arthur Myronenko, *[*UPTech Team*](https://uptech.team/)* With ❤️*

---

*如果你认为这篇博客可以帮助到你，点击下面的 * 💚 * 让更多人阅读它。粉一下我们，以便了解更多关于构建优质产品的文章。
*If you find this helpful, click the* 💚 *below so other can enjoy it too. Follow us for more articles on how to build great products.*

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。


