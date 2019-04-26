> * 原文地址：[Practical MVVM + RxSwift](https://medium.com/flawless-app-stories/practical-mvvm-rxswift-a330db6aa693)
> * 原文作者：[Mohammad Zakizadeh](https://medium.com/@mamalizaki74)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/practical-mvvm-rxswift.md](https://github.com/xitu/gold-miner/blob/master/TODO1/practical-mvvm-rxswift.md)
> * 译者：[iWeslie](https://github.com/iWeslie)
> * 校对者：[swants](https://github.com/swants)

# 实用的 MVVM 和 RxSwift

![](https://cdn-images-1.medium.com/max/2560/1*bOnecl6tpYN6Ll3Z8L6ILQ.png)

今天我们将使用 RxSwift 实现 MVVM 设计模式。对于那些刚接触 RxSwift 的人，我 [在这里](https://github.com/xitu/gold-miner/blob/master/TODO1/mvvm-rxswift-on-ios-part-1.md) 专门做了一个部分来介绍。

如果你认为 RxSwift 很难或令人十分困惑，请不要担心。它一开始看上去似乎很难，但通过实例和实践，就会将变得简单易懂👍。

* * *

在使用 RxSwift 实现 MVVM 设计模式时，我们将在实际项目中检验此方案的所有优点。我们将开发一个简单的应用程序，在 UICollectionView 和 UITableView 中显示林肯公园（RIP Chester🙏）的专辑和歌曲列表。让我们开始吧！

![](https://cdn-images-1.medium.com/max/800/1*9n5BZ0fj4qPZy54zO11WgQ.png)

App 主页面

### UI 设置

#### 子控制器

我希望在构建我们的 app 时遵循可重用性原则。因此，我们将会稍后在 app 的其他部分中重用这些 view，从而来实现我们的专辑的 CollectionView 和歌曲的 TableView。例如，假设我们想要显示每张专辑中的歌曲，或者我们有一个部分用来显示相似的专辑。如果我们不希望每次都重写这些部分，那最好去重用它们。

那我们该怎么做呢? 你正好可以尝试一下子控制器。
为此，我们使用 ContainerView 将 UIViewController 分为两部分：

1. AlbumCollectionViewVC
2. TrackTableViewVC

现在父控制器包含两个子控制器（要了解子控制器，你可以阅读 [这篇文章](https://cocoacasts.com/managing-view-controllers-with-container-view-controllers/)）。

现在我们的 main ViewController 就变成了：

![](https://cdn-images-1.medium.com/max/800/1*ENiIFLcQxvbZHuyJPywNCw.png)

我们为 cell 使用 nib，这样很容易就可以重用它们。

![](https://cdn-images-1.medium.com/max/800/0*R8OnBBlFwgXB4i6_.png)

要注册 nib 的 cell，你应该将此代码放在 AlbumCollectionViewVC 类的 viewDidLoad 方法中。这样 UICollectionView 才能知道它正在使用 cell 的类型：

```swift
// 为 UICollectionView 注册 'AlbumsCollectionViewCell'
albumsCollectionView.register(UINib(nibName: "AlbumsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: String(describing: AlbumsCollectionViewCell.self))
```

请看在 AlbumCollectionViewVC 中的这些代码。这意味着父类对象暂时不必处理其子类。

对于 TrackTableViewVC，我们执行相同的操作，不同之处在于它只是一个 tableView。现在我们要去父类里设置我们的两个子类。

正如你在 storyboard 中看到的那样，子类所在的地方的是放置了两个 viewController 的 view。这些 view 称为 ContainerView。我们可以使用以下代码设置它们：

```swift
@IBOutlet weak var albumsVCView: UIView!

    private lazy var albumsViewController: AlbumsCollectionViewVC = {
        // 加载 Storyboard
        let storyboard = UIStoryboard(name: "Home", bundle: Bundle.main)

        // 实例化 View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "AlbumsCollectionViewVC") as! AlbumsCollectionViewVC

        // 把 View Controller 作为子控添加
        self.add(asChildViewController: viewController, to: albumsVCView)

        return viewController
    }()
```

### View Model 设置

#### 基础 View Model 架构

现在我们的 view 已经准备好了，我们接下来需要 ViewModel 和 RxSwift：

![](https://cdn-images-1.medium.com/max/800/1*xHDv8WNJYCMHAAjKTF18Xw.gif)

在 HomeViewModel 类中，我们应该从服务器获取数据，并为 view 需要展示的东西进行解析。然后 ViewModel 将它提供给父类，父控制器将这些数据传递给子控制器。这意味着父类从其 ViewModel 请求数据，并且 ViewModel 先发送网络请求，再解析数据并传给父类。

下图可以让你更好地理解：

![](https://cdn-images-1.medium.com/max/800/0*_cCs2kvBNIQUwF2X.png)

[GitHub](https://github.com/mohammadZ74/MVVMRx_SampleProject) 中有个在 RxSwift 不包含 Rx 已完成的项目。在 [MVVMWithoutRx](https://github.com/mohammadZ74/MVVMRx_SampleProject/tree/MVVMWithoutRx) 分之上没有实现 Rx。在本文中，我们将介绍 RxSwift 的方案。请看不包含 Rx 的部分，那是通过闭包实现的。

#### 添加 RxSwift

现在是激动人心的添加 RxSwift 部分🚶‍♂️。在这之前，让我们了解一下 ViewModel 应该为我们的类提供什么：

1. loading(Bool)：当我们请求服务器时我们应该展示加载状态，以便用户理解正在加载内容。为此，我们需要 Bool 类型的 Observable。如果它为 true 就意味着它正在加载，否则就已经加载完成（如果你不知道什么是 Observable 请参考 [part1](https://hackernoon.com/mvvm-rxswift-on-ios-part-1-69608b7ed5cd)）。
2. Error(homeError)：服务器可能出现的错误以及任何其他错误。它可能是弹出窗口，网络错误等等，这个应该是 Error 类型的 Observable，所以一旦它有值了，我们就在屏幕上展示出来。
3. CollectionView 和 TableView 的数据。

因此父类有三种需要注册的 Observable。

```swift
public enum homeError {
    case internetError(String)
    case serverMessage(String)
}

public let albums : publishSubject<[Album]> = publishSubject()
public let tracks : publishSubject<[Track]> = publishSubject()
public let loading : publishSubject<Bool> = publishSubject()
public let error : publishSubject<[homeError]> = publishSubject()
```

这些是我们的 ViewModel 类的成员变量。所有这四个都是没有默认值的 Observable。现在你可能会问什么是 **PublishSubject** 呢？

正如我们之前在 [这篇文章](https://hackernoon.com/mvvm-rxswift-on-ios-part-1-69608b7ed5cd) 里提及的，有些变量是 Observer，有些变量是 Observable。还有一种变量既是 Observer 又是 Observable，这种变量被称为 **Subject**。

**Subject** 本身分为 4 个部分（如果单独解释每个部分，那可能需要另一篇文章）。但我在这个项目中使用了 **PublishSubject**，这是最受欢迎的一个项目。如果你想了解更多关于 Subject 的信息，我建议你阅读 [这篇文章](https://medium.com/fantageek/rxswift-subjects-part1-publishsubjects-103ff6b06932)。

使用 **PublishSubject** 的一个很好的理由是你可以在没有初始值的情况下进行初始化。

#### 对 UI 进行数据绑定（RxCocoa）

现在让我们看看具体代码，如何才能将数据提供给我们的 view：

在我们看 ViewModel 的代码之前，我们需要让 HomeVC 监听 ViewModel 并在其改变时更新 view：

```swift
homeViewModel.loading.bind(to: self.rx.isAnimating).disposed(by: disposeBag)
```

在这段代码中，我们将 `loading` 绑定到 `isAnimating`，这意味着每当 ViewModel 改变 `loading` 的值时，我们 ViewController 的 `isAnimating` 值也会改变。你可能会问是否仅使用该代码显示加载动画。答案是肯定的，但需要一些延迟，我稍后会解释。

为了把我们的数据绑定到 UIKit，这有利于 RxCocoa，可以从不同的 View 中获得很多属性，你可以通过 `rx` 访问这些属性。这些属性是 Binder，因此你可以轻松地进行绑定。那这又是什么意思呢？

这意味着每当我们将 Observable 绑定到 Binder 时，Binder 就会对 Observable 的值作出反应。例如，假设你有一个 Bool 的 PublishSubject，它只有 true 和 false。如果将此 subject 绑定到 view 的 isHidden 属性，则在 publishSubject 为 true 时将隐藏 view。如果 publishSubject 为 false，则 view 的 isHidden 属性将变为 false，然后将不再隐藏 view。这是不是很酷？

![](https://cdn-images-1.medium.com/max/800/1*flm2hBqsTajRNaJVNnUPCQ.png)

多亏了 Rx 团队的 RxCocoa 包含了许多 UIKit 的属性，但是有些属性（例如自定义属性，在我们的例子中是 Animating）是不在 RxCocoa 中的，但你可以轻松添加它们：

```swift
extension Reactive where Base: UIViewController {
    /// 用于 `startAnimating()` 和 `stopAnimating()` 方法的 binder
    public var isAnimating: Binder<Bool> {
        return Binder(self.base, binding: { (vc, active) in
            if active {
                vc.startAnimating()
            } else {
                vc.stopAnimating()
            }
        })
    }
}
```

现在让我们解释一下上面的代码：

1. 首先我们为 RxCocoa 中的 Reactive 写了一个 extension，用来拓展 UIViewController 中的 RX 属性
2. 我们将 isAnimating 变量实现为类型 `Binder<Bool>` 的 UIViewController，以便可以绑定。
3. 接下来我们创建 Binder，对于 Binder 部分，用闭包给我们的控制器（`vc`）和 isAnimating （`active`）传值。所以我们可以在 `isAnimating` 的每个值中说明 viewController 会发生什么变化，所以如果 `active` 为 true，我们用 `vc.startAnimating()` 显示加载动画，并在 `active` 为 false 时隐藏。

现在我们的加载已准备好从 ViewModel 接收数据了。那么让我们看看其他的 Binder：

```swift
// 监听显示 error
homeViewModel.error.observeOn(MainScheduler.instance).subscribe(onNext: { (error) in
    switch error {
    case .internetError(let message):
        MessageView.sharedInstance.showOnView(message: message, theme: .error)
    case .serverMessage(let message):
        MessageView.sharedInstance.showOnView(message: message, theme: .warning)
    }
}).disposed(by: disposeBag)
```

在上面的代码中，当 ViewModel 每产生一个 error 时，我们都会监听到它。你可以用 error 做任何你想做的事情（我正在弹出一个窗口）。

什么是 `.observeOn(MainScheduler.instance)` 呢？🤔这部分代码将发出的信号（在我们的例子中是 error）带到主线程，因为我们的 ViewModel 正在从后台线程发送值。因此我们可以防止由于后台线程而导致的运行时崩溃。你只需将信号带到主线程中，而不是执行 `DispatchQueue.main.async {}`。

### 最后一步

#### 绑定 Album 和 Track 的属性

现在让我们为 UICollectionView 和 UITableView 的专辑和曲目进行绑定。因为我们的 tableView 和 collectionView 属性在我们的子控中。现在，我们只是将 ViewModel 中的专辑和曲目数组绑定到子控的曲目和专辑属性，并让子控负责显示它们（我将在文章末尾展示它是如何完成的）：

```swift
// 把专辑绑定到 album 容器

homeViewModel
    .albums
    .observeOn(MainScheduler.instance)
    .bind(to: albumsViewController.albums)
    .disposed(by: disposeBag)

// 把曲目绑定到 track 容器

homeViewModel
    .tracks
    .observeOn(MainScheduler.instance)
    .bind(to: tracksViewController.tracks)
    .disposed(by: disposeBag)
```

#### 从 ViewModel 请求数据

现在让我们回到 ViewModel 看看发生了什么：

```swift
public func requestData(){
    // 1
    self.loading.onNext(true)
    // 2
    APIManager.requestData(url: requestUrl, method: .get, parameters: nil, completion: { (result) in
        // 3
        self.loading.onNext(false)
        switch result {
        // 4
        case .success(let returnJson) :
            let albums = returnJson["Albums"].arrayValue.compactMap {return Album(data: try! $0.rawData())}
            let tracks = returnJson["Tracks"].arrayValue.compactMap {return Track(data: try! $0.rawData())}
            self.albums.onNext(albums)
            self.tracks.onNext(tracks)
        // 5
        case .failure(let failure) :
            switch failure {
            case .connectionError:
                self.error.onNext(.internetError("Check your Internet connection."))
            case .authorizationError(let errorJson):
                self.error.onNext(.serverMessage(errorJson["message"].stringValue))
            default:
                self.error.onNext(.serverMessage("Unknown Error"))
            }
        }
    })
}
```

1. 我们向 `loading` 发送 true，因为我们已经在 HomeVC 类中进行了绑定，我们的 viewController 现在显示了加载动画。
2. 接下来，我们只是向网络层（Alamofire 或你拥有的任何网络层）发送请求。
3. 之后，我们得到了服务器的响应，我们应该通过向 `loading` 发送 false 来结束加载动画。
4. 现在拿到了服务器的响应，如果它为 success，我们将解析数据并发送专辑和曲目的值。
5. 如果遇到错误，我们会发出 failure 值。同样地，因为 HomeVC 已经监听了 error，所以它们会向用户显示。

```swift
let albums = returnJson["Albums"].arrayValue.compactMap { return Album(data: try! $0.rawData()) }
let tracks = returnJson["Tracks"].arrayValue.compactMap { return Album(data: try! $0.rawData()) }
self.albums.append(albums)
self.tracks.append(tracks)
```

现在我们的数据准备好了，我们传递给子控，最后该在 CollectionView 和 TableView 中显示数据了：

如果你还记得 HomeVC：

```swift
public var tracks = publishSubject<[Track]>()
```

现在在 trackTableViewVC 的 viewDidLoad 方法中，我们应该将曲目绑定到 UITableView，这可以只用两三行代码行中完成。感谢 RxCocoa！

```swift
tracks.bind(to: tracksTableView.rx.items(cellIdentifier: "TracksTableViewCell", cellType: TracksTableViewCell.self)) { (row,track,cell) in
    cell.cellTrack = track
}.disposed(by: disposeBag)
```

是的你只需要三行，事实上是一行，你不需要再设置 delegate 或 dataSource，不再有 numberOfSections，numberOfRowsInSection 和 cellForRowAt。RxCocoa 一次性可处理所有内容。

你只需要将 Model 传递给 UITableView 并为其指定一个 cellType。在闭包中，RxCocoa 将为你提供与模型数组对应的单元格，model 和 row，以便你可以使用相应的 model 为 cell 提供信息。在我们的 cell 中，每当调用 didSet 时，cell 将使用 model 设置属性。

```swift
public var cellTrack: Track! {
    didSet {
        self.trackImage.clipsToBounds = true
        self.trackImage.layer.cornerRadius = 3
        self.trackImage.loadImage(fromURL: cellTrack.trackArtWork)
        self.trackTitle.text = cellTrack.name
        self.trackArtist.text = cellTrack.artist
    }
}
```

当然，你可以在闭包内更改 view，但我更喜欢用 didSet。

#### 添加弹性动画

在本文结束之前，让我们通过添加一些动画给我们的 tableView 和 collectionView 焕发活力：

```swift
// cell 的动画
tracksTableView.rx.willDisplayCell.subscribe(onNext: ({ (cell,indexPath) in
    cell.alpha = 0
    let transform = CATransform3DTranslate(CATransform3DIdentity, -250, 0, 0)
    cell.layer.transform = transform
    UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
        cell.alpha = 1
        cell.layer.transform = CATransform3DIdentity
    }, completion: nil)
})).disposed(by: disposeBag)
```

我们的项目最终会变成下面这样：

![](https://cdn-images-1.medium.com/max/800/1*-WFBDlA8etPcr4ZIdExciw.gif)

动态 demo

### 写在最后

我们在 RxSwift 和 RxCocoa 的帮助下在 MVVM 中实现了一个简单的 app，我希望你对这些概念更加熟悉。如果你有任何建议可以联系我们。

最终完成的项目可以在 [GitHub 仓库](https://github.com/mohammadZ74/MVVMRx_SampleProject) 下找到。

如果你喜欢这篇文章和项目，请不要忘记，你可以通过 [Twitter](https://twitter.com/Mohammad_z74) 或通过电子邮件 mohammad_Z74@icloud.com 联系本文作者。

感谢你的阅读！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
