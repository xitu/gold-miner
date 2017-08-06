
> * 原文地址：[Taming Great Complexity: MVVM, Coordinators and RxSwift](https://blog.uptech.team/taming-great-complexity-mvvm-coordinators-and-rxswift-8daf8a76e7fd)
> * 原文作者：[Arthur Myronenko](https://blog.uptech.team/@arthur.myronenko)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/taming-great-complexity-mvvm-coordinators-and-rxswift.md](https://github.com/xitu/gold-miner/blob/master/TODO/taming-great-complexity-mvvm-coordinators-and-rxswift.md)
> * 译者：
> * 校对者：

# Taming Great Complexity: MVVM, Coordinators and RxSwift

![](https://cdn-images-1.medium.com/max/2000/1*bJAfxV4qB-R6ajA8GdSKQA.jpeg)

Last year our team started using Coordinators and MVVM in a production app. At first it looked scary, but since then we’ve finished 4 applications built on top of those architectural patterns. In this article I will share our experience and will guide you to the land of MVVM, Coordinators & Reactive programming.

Instead of giving a definition up front, we will start with a simple MVC example application. We will do the refactoring slowly step by step to show how every component affects the codebase and what are the outcomes. Every step will be prefaced with a brief theory intro.

### Example

In this article we are going to use a simple example application that displays a list of the most starred repositories on GitHub by language. It has two screens: a list of repositories filtered by language and a list of languages to filter repositories by.

![](https://cdn-images-1.medium.com/max/1600/1*0-JLJkOn1nV4N9igbRf99Q.png)

Screens of the example app
A user can tap on a button in the navigation bar to show the second screen. On the languages screen he can select a language or dismiss the screen by tapping on the cancel button. If a user selects a language the screen will dismiss and the repositories list will update according to the selected language.

You can find the source code here:

[![](https://ws3.sinaimg.cn/large/006tKfTcgy1fi4hjpkfvqj314k0aqgmv.jpg)](https://github.com/uptechteam/Coordinator-MVVM-Rx-Example)

The repository contains 4 folders: MVC, MVC-Rx, MVVM-Rx, Coordinators-MVVM-Rx correspondingly to each step of the refactoring. Let’s open the project in the [MVC folder](https://github.com/uptechteam/Coordinator-MVVM-Rx-Example/tree/master/MVC) and look at the code before refactoring.

Most of the code is in two View Controllers: `RepositoryListViewController` and `LanguageListViewController`. The first one fetches a list of the most popular repositories and shows it to the user via a table view, the second one displays a list of languages. `RepositoryListViewController` is a delegate of the `LanguageListViewController` and conforms to the following protocol:

```
protocol LanguageListViewControllerDelegate: class {
    func languageListViewController(_ viewController: LanguageListViewController,
                                    didSelectLanguage language: String)
    func languageListViewControllerDidCancel(_ viewController: LanguageListViewController)
}
```

The `RepositoryListViewController` is also a delegate and a data source for the table view. It handles the navigation, formats model data to display and performs network requests. Wow, a lot of responsibilities for just one View Controller!

Also, you could notice two variables in the global scope that define a state of the `RepositoryListViewController`: `currentLanguage` and `repositories`. Such stateful variables introduce complexity to the class and are a common source of bugs when parts of our app might end up in a state we didn’t expect. To sum up, we have several issues with the current codebase:

- View Controller has too many responsibilities;
- we need to deal with state changes reactively;
- the code is not testable at all.

Time to meet our first guest.

### RxSwift

The component that will allow us to respond to changes reactively and write declarative code.

What is Rx? One of the definitions is:

> ReactiveX is a library for composing asynchronous and event-based programs by using observable sequences.

If you are not familiar with functional programming or that definition sounds like a rocket science (it still does for me) you can think of Rx as an Observer pattern on steroids. For more info, you can refer to the [Getting Started guide](https://github.com/ReactiveX/RxSwift/blob/master/Documentation/GettingStarted.md) or to the [RxSwift Book](https://store.raywenderlich.com/products/rxswift).

Let’s open [MVC-Rx project in the repository](https://github.com/uptechteam/Coordinator-MVVM-Rx-Example/tree/master/MVC-Rx) and take a look at how Rx changes the code. We will start from the most obvious things to do with Rx — we replace the `LanguageListViewControllerDelegate` with two observables: `didCancel` and `didSelectLanguage`.

```
/// Shows a list of languages.
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

/// Shows a list of the most starred repositories filtered by a language.
class RepositoryListViewController: UIViewController {

  /// Subscribes on the `LanguageListViewController` observables before navigation.
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

Delegate pattern done right

`LanguageListViewControllerDelegate` became the `didSelectLanguage` and `didCancel` observables. We use them in the `prepareLanguageListViewController(_: )` method to reactively observe `RepositoryListViewController` events.

Next, we will refactor the `GithubService` to return observables instead of using callbacks. After that, we will use the power of the RxCocoa framework to rewrite our View Controllers. Most of the code of the `RepositoryListViewController` will move to the `setupBindings` function where we declaratively describe a logic of the View Controller:

```
private func setupBindings() {
    // Refresh control reload events
    let reload = refreshControl.rx.controlEvent(.valueChanged)
        .asObservable()

    // Fires a request to the github service every time reload or currentLanguage emits an item.
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

    // Bind repositories to the table view as a data source.
    repositories
        .bind(to: tableView.rx.items(cellIdentifier: "RepositoryCell", cellType: RepositoryCell.self)) { [weak self] (_, repo, cell) in
            self?.setupRepositoryCell(cell, repository: repo)
        }
        .disposed(by: disposeBag)

    // Bind current language to the navigation bar title.
    currentLanguage
        .bind(to: navigationItem.rx.title)
        .disposed(by: disposeBag)

    // Subscribe on cell selection of the table view and call `openRepository` on every item.
    tableView.rx.modelSelected(Repository.self)
        .subscribe(onNext: { [weak self] in self?.openRepository($0) })
        .disposed(by: disposeBag)

    // Subscribe on thaps of che `chooseLanguageButton` and call `openLanguageList` on every item.
    chooseLanguageButton.rx.tap
        .subscribe(onNext: { [weak self] in self?.openLanguageList() })
        .disposed(by: disposeBag)
}
```

A declarative description of the view controller logic

Now we got rid of the table view delegate and data source method in view controllers and moved our state to one mutable subject:

```
fileprivate let currentLanguage = BehaviorSubject(value: “Swift”)
```

#### Outcomes

We’ve refactored example application using RxSwift and RxCocoa frameworks. So what exactly it gives us?

- all the logic is declaratively written in one place;
- we reduced state to one subject of current language which we observe and react to changes;
- we used some syntactic sugar from RxCocoa to setup table view data source and delegate briefly and clearly.

Our code still isn’t testable and View Controllers still responsible for a lot of things. Let’s turn to the next component of our architecture.

### MVVM

MVVM is a UI architectural pattern from Model-View-X family. MVVM is similar to the standard MVC, except it defines one new component — ViewModel, which allows to better decouple UI from the Model. Essentially, ViewModel is an object which represents View UIKit-independently.

*The example project is in the *[*MVVM-Rx folder*](https://github.com/uptechteam/Coordinator-MVVM-Rx-Example/tree/master/MVVM-Rx)*.*

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

Next we will move all our data mutation and formatting code from the `RepositoryListViewController` into `RepositoryListViewModel`:

```
class RepositoryListViewModel {

    // MARK: - Inputs
    /// Call to update current language. Causes reload of the repositories.
    let setCurrentLanguage: AnyObserver<String>

    /// Call to show language list screen.
    let chooseLanguage: AnyObserver<Void>

    /// Call to open repository page.
    let selectRepository: AnyObserver<RepositoryViewModel>

    /// Call to reload repositories.
    let reload: AnyObserver<Void>

    // MARK: - Outputs
    /// Emits an array of fetched repositories.
    let repositories: Observable<[RepositoryViewModel]>

    /// Emits a formatted title for a navigation item.
    let title: Observable<String>

    /// Emits an error messages to be shown.
    let alertMessage: Observable<String>

    /// Emits an url of repository page to be shown.
    let showRepository: Observable<URL>

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

Now our View Controller delegates all the UI interactions like buttons clicks or row selection to the View Model and observes View Model outputs with data or events like `showLanguageList`.

We will do the same for the `LanguageListViewController` and looks like we are good to go. But our tests folder is still empty! The introduction of the View Models allowed us to test a big chunk of our code. Because ViewModels purely convert inputs into outputs using injected dependencies ViewModels and Unit Tests are the best friends in our apps.

We will test the application using RxTest framework which ships with RxSwift. The most important part is a `TestScheduler` class, that allows you to create fake observables by defining at what time they should emit values. That’s how we test View Models:

```
func test_SelectRepository_EmitsShowRepository() {
    let repositoryToSelect = RepositoryViewModel(repository: testRepository)
    // Create fake observable which fires at 300
    let selectRepositoryObservable = testScheduler.createHotObservable([next(300, repositoryToSelect)])

    // Bind fake observable to the input
    selectRepositoryObservable
        .bind(to: viewModel.selectRepository)
        .disposed(by: disposeBag)

    // Subscribe on the showRepository output and start testScheduler
    let result = testScheduler.start { self.viewModel.showRepository.map { $0.absoluteString } }

    // Assert that emitted url es equal to the expected one
    XCTAssertEqual(result.events, [next(300, "https://www.apple.com")])
}
```

View Model tests

#### Outcomes

Okay, we’ve moved from MVC to the MVVM. But what’s the difference?

- View Controllers are thinner now;
- the data formatting logic is decoupled from the View Controllers;
- MVVM made our code testable.

There is one more problem with our View Controllers though — `RepositoryListViewController` knows about the existence of the `LanguageListViewController` and manages navigation flow. Let’s fix it with Coordinators.

### Coordinators

If you haven’t heard about Coordinators yet, I strongly recommend reading [this awesome blog post](http://khanlou.com/2015/10/coordinators-redux/) by Soroush Khanlou which gives a nice introduction.

In short, Coordinators are the objects which control the navigation flow of our application. They help to:

- isolate and reuse ViewControllers;
- pass dependencies down the navigation hierarchy;
- define use cases of the application;
- implement deep linking.

![](https://cdn-images-1.medium.com/max/1600/1*VNFMhDEwq-o4GbzVsjAXUA.png)

Coordinators Flow

The diagram shows the typical coordinators flow in the application. App Coordinator checks if there is a stored valid access token and decides which coordinator to show next — Login or Tab Bar. TabBar Coordinator shows three child coordinators which correspond to the Tab Bar items.

We are finally coming to the end of our refactoring process. The completed project is located in the [Coordinators-MVVM-Rx](https://github.com/uptechteam/Coordinator-MVVM-Rx-Example/tree/master/Coordinators-MVVM-Rx) directory. What has changed?

First, let’s check what is `BaseCoordinator`:

```
/// Base abstract coordinator generic over the return type of the `start` method.
class BaseCoordinator<ResultType> {

    /// Typealias which will allows to access a ResultType of the Coordainator by `CoordinatorName.CoordinationResult`.
    typealias CoordinationResult = ResultType

    /// Utility `DisposeBag` used by the subclasses.
    let disposeBag = DisposeBag()

    /// Unique identifier.
    private let identifier = UUID()

    /// Dictionary of the child coordinators. Every child coordinator should be added
    /// to that dictionary in order to keep it in memory.
    /// Key is an `identifier` of the child coordinator and value is the coordinator itself.
    /// Value type is `Any` because Swift doesn't allow to store generic types in the array.
    private var childCoordinators = [UUID: Any]()

    /// Stores coordinator to the `childCoordinators` dictionary.
    ///
    /// - Parameter coordinator: Child coordinator to store.
    private func store<T>(coordinator: BaseCoordinator<T>) {
        childCoordinators[coordinator.identifier] = coordinator
    }

    /// Release coordinator from the `childCoordinators` dictionary.
    ///
    /// - Parameter coordinator: Coordinator to release.
    private func free<T>(coordinator: BaseCoordinator<T>) {
        childCoordinators[coordinator.identifier] = nil
    }

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

    /// Starts job of the coordinator.
    ///
    /// - Returns: Result of coordinator job.
    func start() -> Observable<ResultType> {
        fatalError("Start method should be implemented.")
    }
}
```

Base Coordinator

That generic object provides three features for the concrete coordinators:

- abstract method `start()` which starts the coordinator job (i.e. presents the view controller);
- generic method `coordinate(to: )` which calls `start()` on the passed child coordinator and keeps it in the memory;
- `disposeBag` used by subclasses.

*Why does the *`*start*`* method return an *`*Observable*`* and what is a *`*ResultType*`*?*

`ResultType` is a type which represents a result of the coordinator job. More often `ResultType` will be a `Void` but for certain cases, it will be an enumeration of possible result cases. The `start` will emit exactly one result item and complete.

We have three Coordinators in the application:

- `AppCoordinator` which is a root of Coordinators hierarchy;
- `RepositoryListCoordinator`;
- `LanguageListCoordinator.`

Let’s see how the last one communicates with ViewController and ViewModel and handles the navigation flow:

```
/// Type that defines possible coordination results of the `LanguageListCoordinator`.
///
/// - language: Language was choosen.
/// - cancel: Cancel button was tapped.
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
        // Initialize a View Controller from the storyboard and put it into the UINavigationController stack
        let viewController = LanguageListViewController.initFromStoryboard(name: "Main")
        let navigationController = UINavigationController(rootViewController: viewController)

        // Initialize a View Model and inject it into the View Controller
        let viewModel = LanguageListViewModel()
        viewController.viewModel = viewModel

        // Map the outputs of the View Model to the LanguageListCoordinationResult type
        let cancel = viewModel.didCancel.map { _ in CoordinationResult.cancel }
        let language = viewModel.didSelectLanguage.map { CoordinationResult.language($0) }

        // Present View Controller onto the provided rootViewController
        rootViewController.present(navigationController, animated: true)

        // Merge the mapped outputs of the view model, taking only the first emitted event and dismissing the View Controller on that event
        return Observable.merge(cancel, language)
            .take(1)
            .do(onNext: { [weak self] _ in self?.rootViewController.dismiss(animated: true) })
    }
}
```

Result of the LanguageListCoordinator work can be a selected language or nothing if a user taps on “Cancel” button. Both cases are defined in the `LanguageListCoordinationResult` enum.

In the `RepositoryListCoordinator` we flatMap the `showLanguageList` output by the presentation of the `LanguageListCoordinator`. After the `start()` method of the `LanguageListCoordinator` completes we filter the result and if a language was chosen we send it to the `setCurrentLanguage` input of the View Model.

```
override func start() -> Observable<Void> {

    ...
    // Observe request to show Language List screen
    viewModel.showLanguageList
        .flatMap { [weak self] _ -> Observable<String?> in
            guard let `self` = self else { return .empty() }
            // Start next coordinator and subscribe on it's result
            return self.showLanguageList(on: viewController)
        }
        // Ignore nil results which means that Language List screen was dismissed by cancel button.
        .filter { $0 != nil }
        .map { $0! }
        // Bind selected language to the `setCurrentLanguage` observer of the View Model
        .bind(to: viewModel.setCurrentLanguage)
        .disposed(by: disposeBag)

    ...

    // We return `Observable.never()` here because RepositoryListViewController is always on screen.
    return Observable.never()
}

// Starts the LanguageListCoordinator
// Emits nil if LanguageListCoordinator resulted with `cancel` or selected language
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

*Notice that we return *`*Observable.never()*`* because Repository List screen is always in the view hierarchy.*

#### Outcomes

We finished our last stage of the refactoring, where we

- moved the navigation logic out of the View Controllers and isolated them;
- setup injection of the View Models into the View Controllers;
- simplified the storyboard.

---

From the bird’s eye view our system looks like this:

![](https://cdn-images-1.medium.com/max/1600/1*dVJv23ChJixjayLKzL9HRg.png)

MVVM-C architecture

The App Coordinator starts the first Coordinator which initializes View Model, injects into View Controller and presents it. View Controller sends user events such as button taps or cell section to the View Model. View Model provides formatted data to the View Controller and asks Coordinator to navigate to another screen. The Coordinator can send events to the View Model outputs as well.

### Conclusion

We’ve covered a lot: we talked about the MVVM which describes UI architecture, solved the problem of navigation/routing with Coordinators and made our code declarative using RxSwift. We’ve done step-by-step refactoring of our application and shown how every component affects the codebase.

There are no silver bullets when it comes to building an iOS app architecture. Each solution has its own drawbacks and may or may not suit your project. Sticking to the architecture is a matter of weighing tradeoffs in your particular situation.

There’s, of course, a lot more to Rx, Coordinators and MVVM than what I was able to cover in this post, so please let me know if you’d like me to do another post that goes more in-depth about edge cases, problems and solutions.

Thanks for reading!

---

*Arthur Myronenko, *[*UPTech Team*](https://uptech.team/)* With ❤️*

---

*If you find this helpful, click the* 💚 *below so other can enjoy it too. Follow us for more articles on how to build great products.*


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
