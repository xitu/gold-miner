> * 原文地址：[Practical MVVM + RxSwift](https://medium.com/flawless-app-stories/practical-mvvm-rxswift-a330db6aa693)
> * 原文作者：[Mohammad Zakizadeh](https://medium.com/@mamalizaki74)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/practical-mvvm-rxswift.md](https://github.com/xitu/gold-miner/blob/master/TODO1/practical-mvvm-rxswift.md)
> * 译者：[iWeslie](https://github.com/iWeslie)
> * 校对者：

# 实用的 MVVM 和 RxSwift

![](https://cdn-images-1.medium.com/max/2560/1*bOnecl6tpYN6Ll3Z8L6ILQ.png)

今天我们将使用 RxSwift 实现 MVVM 设计模式。对于那些刚接触 RxSwift 的人，我 [在这里](https://hackernoon.com/mvvm-rxswift-on-ios-part-1-69608b7ed5cd) 专门做了一个部分来介绍。


如果您认为 RxSwift 很难或模棱两可，请不要担心。它一开始看上去似乎很难，但通过实例和实践，就会将变得简单易懂👍

* * *

在使用 RxSwift 实现 MVVM 设计模式时，我们将在实际项目中检验此方法的所有优点。我们将开发一个简单的应用程序，在 UICollectionView 和 UITableView 中显示林肯公园（RIP Chester🙏）的专辑和歌曲列表。让我们开始吧！

![](https://cdn-images-1.medium.com/max/800/1*9n5BZ0fj4qPZy54zO11WgQ.png)

App 主页面

### UI 设置

#### 子控制器

我希望在构建我们的 app 时遵循可重用性原则。因此，我们将会以稍后在 app 的其他部分中重用这些 view 的方式实现我们的专辑的 CollectionView 和歌曲的 TableView。例如，假设我们想要显示每张专辑中的歌曲，或者我们有一个部分用来显示相似的专辑。如果我们不希望每次都重写这些部分，那最好就是重用它们。

所以我们能做什么呢？可以试试子控
为此，我们使用 ContainerView 将 UIViewController 分为两部分：

1. AlbumCollectionViewVC
2. TrackTableViewVC

现在父控制器包含两个子控制器（要了解子控制器，你可以阅读[这篇文章](https://cocoacasts.com/managing-view-controllers-with-container-view-controllers/)）。

现在我们的 main ViewController 就变成了：

![](https://cdn-images-1.medium.com/max/800/1*ENiIFLcQxvbZHuyJPywNCw.png)

我们为 cell 使用 nib，这样很容易就可以重用它们。

![](https://cdn-images-1.medium.com/max/800/0*R8OnBBlFwgXB4i6_.png)

要注册 nib 的 cell，您应该将此代码放在 AlbumCollectionViewVC 类的 viewDidLoad 方法中。因此 UICollectionView 知道它正在使用的 cell 类型：

```swift
// 为 UICollectionView 注册 'AlbumsCollectionViewCell'
albumsCollectionView.register(UINib(nibName: "AlbumsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: String(describing: AlbumsCollectionViewCell.self))
```

请看在 AlbumCollectionViewVC 中的这些代码。这意味着父类对象暂时不必处理其子类。

对于 TrackTableViewVC，我们执行相同的操作，不同之处在于它只是一个 tableView。现在我们要去父类里设置我们的两个子类。

正如您在 storyboard 中看到的那样，子类所在的地方的是放置了两个 viewController 的 view。这些 view 称为 ContainerView。我们可以使用以下代码设置它们：

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

在 HomeViewModel 类中，我们应该从服务器获取数据，并为 view 需要展示的东西进行解析。然后 ViewModel 将它提供给父类，父类将这些数据传递给子控。这意味着父类从其视 ViewModel 请求数据，并且 ViewModel 先发送网络请求，再解析数据并传给父类。

下图可以让你更好地理解：

![](https://cdn-images-1.medium.com/max/800/0*_cCs2kvBNIQUwF2X.png)

[GitHub](https://github.com/mohammadZ74/MVVMRx_SampleProject) 中有个在 RxSwift 不包含 Rx 已完成的项目。在 [MVVMWithoutRx](https://github.com/mohammadZ74/MVVMRx_SampleProject/tree/MVVMWithoutRx) 分之上没有实现 Rx。在本文中，我们将介绍 RxSwift 的方案。请看不包含 Rx 的部分，那是通过闭包实现的。

#### Adding RxSwift

Now here is the exciting part when RxSwift enters🚶‍♂️. Before that, let’s understand what else the view model should give to our class:

1.  Loading(Bool): Whereas we send a request to the server, we should show a loading. So the user understands, something is loading now. For this, we need the Observables of Bool. When it was true it would mean that it is loading and when it was false — it has loaded (if you don’t know what are observables read [part1](https://hackernoon.com/mvvm-rxswift-on-ios-part-1-69608b7ed5cd)).
2.  Error(homeError): The possible errors from the server and any other errors. It could be pop ups, Internet errors, and … this one should be observables of error type, so that if it had a value, we would show it on the screen.
3.  The collection and table views data ,…

So we have three kinds of Observables that our parent class should be registered to them:

![](https://cdn-images-1.medium.com/max/800/1*CqDtCU93dxU0EDA_-7ywhQ.png)

These are our view model class variables. All the four of them are observables and without a first value. Now you may ask: what is **PublishSubject**?

As we [said](https://hackernoon.com/mvvm-rxswift-on-ios-part-1-69608b7ed5cd) before, some of the variables are Observer and some of them are Observable. And we have another one that can be both Observer and Observable at the same time, these are called **Subjects.**

**Subjects** themselves are divided into 4 parts (explaining each of them, would require another article). But I used **PublishSubject** in this project, which is the most popular one. If you want to know more about subjects, I recommend reading [this article](https://medium.com/fantageek/rxswift-subjects-part1-publishsubjects-103ff6b06932).

One of the good reason for using **PublishSubject** is that can be initialized without an initial value.

#### UI to data binding (RxCocoa)

Now let’s get into the code and see how can we can feed data to our view:

Before we get into the view model code, we need to prepare the HomeVC class for observing the viewModel variables and react views from the view model data:

![](https://cdn-images-1.medium.com/max/800/1*OikxO6mhY9YFxXH3q_rztQ.png)

In this code, we are binding `loading` to `isAnimating`, which means that whenever viewModel changed `loading` value, the `isAnimating` value of our view controllers would change as well. You may ask if we’re showing the loading animation with just that code. The answer is yes but it requires some extension which I’ll explain later on.

In order for our data to bind to UIKit, in favor of RxCocoa, there are so many properties available from different Views that you can access those from `rx`property. These properties are Binders so you can do the bindings easily. What does that mean?

It means whenever we bind an Observable to a binder, the binder reacts to the Observable value. For example, imagine you have PublishSubject of a Bool which produces true and false. If you bind this subject to the isHidden property of a view, the view would be hidden if the publishSubject produces true. If the publishSubject produces false, the view isHidden property would become false and then the view would no longer be hidden. It’s very cool, isn’t it?

![](https://cdn-images-1.medium.com/max/800/1*flm2hBqsTajRNaJVNnUPCQ.png)

Despite that RxCocoa contains lots of UIKit properties thanks to the Rx team, there are some properties (for example custom ones, in our case is Animating) that are not in the RxCocoa but you can add them easily:

```
extension Reactive where Base: UIViewController {

    /// Bindable sink for `startAnimating()`, `stopAnimating()` methods.
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

Now let’s explain the above code:

1.  First, we wrote an extension to Reactive which is in RxCocoa and affect RX property of UIViewController.
2.  We implement isAnimating variable to UIViewControllers of type `Binder<Bool>` so that can be bindable.
3.  Next, we create Binder and for the binder part, the closure giving us the view controller (`vc`) and the value of isAnimating (`active`). So we are able to say what happens to the viewController in each value of `isAnimating`, so if `active` is true, we are showing loading animation with `vc.startAnimating()` and hide the loading when `active` is false.

Now our loading is ready to receive data from ViewModel. So let’s get into the other binders:

```
// observing errors to show

        homeViewModel
            .error
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (error) in
                switch error {
                case .internetError(let message):
                    MessageView.sharedInstance.showOnView(message: message, theme: .error)
                case .serverMessage(let message):
                    MessageView.sharedInstance.showOnView(message: message, theme: .warning)
                }
            })
            .disposed(by: disposeBag)
```

In the above code, whenever an error comes from the ViewModel, we are subscribed to it. You can do whatever you want with the error (I’m showing a pop up).

So what is the `.observeOn(MainScheduler.instance)`?🤔 This part of the code is bringing the emitted signals (in our case errors) to the main thread because our ViewModel is sending values from the background thread. So we prevent awkward run time crash because of the background thread. You just bring your signals to the main thread just in one line instead of doing the `DispatchQueue.main.async {}` way.

### Last touch

#### Connect Albums and Tracks properties

Now let’s do the binding for our UICollectionView and UITableView of albums and tracks. Because our tableView and collectionView properties are in our child ViewControllers. For now, we are just binding array of albums and tracks from ViewModel to tracks and albums properties of childViewControllers and let the child be responsible for showing them (I’ll show how it can be done at the end of article):

```
// binding albums to album container

homeViewModel
    .albums
    .observeOn(MainScheduler.instance)
    .bind(to: albumsViewController.albums)
    .disposed(by: disposeBag)

// binding tracks to track container

homeViewModel
    .tracks
    .observeOn(MainScheduler.instance)
    .bind(to: tracksViewController.tracks)
    .disposed(by: disposeBag)
```

#### Request data from View Model

Now let’s get back to our ViewModel and see what’s happening:

```
public func requestData(){

    self.loading.onNext(true)
    APIManager.requestData(url: requestUrl, method: .get, parameters: nil, completion: { (result) in
        self.loading.onNext(false)
        switch result {
        case .success(let returnJson) :
            let albums = returnJson["Albums"].arrayValue.compactMap {return Album(data: try! $0.rawData())}
            let tracks = returnJson["Tracks"].arrayValue.compactMap {return Track(data: try! $0.rawData())}
            self.albums.onNext(albums)
            self.tracks.onNext(tracks)
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

1.  we are emitting `loading` value to true and because we already do the binding in HomeVC class, our viewController now showing the loading animation.
2.  Next, we are just sending a request for data to the network layer (Alamofire or any network layer you have).
3.  After that, we got the response from the server we should end the loading animation by emitting false to `loading`.
4.  line (13–19) Now having the response of the server, if we got into trouble, we emit the error value. Again, because the HomeVC has already subscribed to errors, they are shown to the user.
5.  (line 8–11) If the response was successful, we parse the data and emit values of albums and tracks.

![](https://cdn-images-1.medium.com/max/800/1*fLBl8goTTAUJ97cnXKqyhQ.png)

Now that our data is ready and we passed to our childViewControllers, finally we should show the data in CollectionView and TableView:

If you remember in HomeVC class:

![](https://cdn-images-1.medium.com/max/800/1*k9tjFjfEa830ndBFQirO5Q.png)

Now in viewDidLoad method of trackTableViewVC, we should bind tracks to UITableView, which can be done in 2 lines. Thanks to RxCocoa!

```
tracks.bind(to: tracksTableView.rx.items(cellIdentifier: "TracksTableViewCell", cellType: TracksTableViewCell.self)) {  (row,track,cell) in
            cell.cellTrack = track
            }.disposed(by: disposeBag)
```

Yes, you’re right just 2 lines. No more setting delegate or dataSource, no more numberOfSections, numberOfRowsInSection and cellForRowAt . RxCocoa handles everything in just 2 lines.

You just need to pass the model (binding model to UITableView) and give it a cellType. In the closure, RxCocoa will give you cell, model and the row corresponding to your model array, so that you could feed the cell with the corresponding model. In our cell, whenever the model gets set with didSet, the cell is going to set the properties with the model.

![](https://cdn-images-1.medium.com/max/800/1*2_BfJtbyZobBwa6e9G617w.png)

Of course, you could change the view within the closure, but I prefer the computed property way.

#### Adding bonus animation

Before ending the article, let’s give some life to our tableView and collectionView by giving some animations:

```
// animation to cells
tracksTableView.rx.willDisplayCell
            .subscribe(onNext: ({ (cell,indexPath) in
                cell.alpha = 0
                let transform = CATransform3DTranslate(CATransform3DIdentity, -250, 0, 0)
                cell.layer.transform = transform
                UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                    cell.alpha = 1
                    cell.layer.transform = CATransform3DIdentity
                }, completion: nil)
            })).disposed(by: disposeBag)
```

So our implemented project looks like this:

![](https://cdn-images-1.medium.com/max/800/1*-WFBDlA8etPcr4ZIdExciw.gif)

live demo

### Final words.

We implemented a simple app in MVVM with the help of RxSwift and RxCocoa. I hope you got more familiar with these concepts. Feel free to comment and share your thoughts on any piece of this guide.

The completed project can be found in [GitHub repo here](https://github.com/mohammadZ74/MVVMRx_SampleProject).

* [**mohammadZ74/MVVMRx_SampleProject**: Example project of MVVMRx article. Contribute to mohammadZ74/MVVMRx_SampleProject development by creating an account on...](https://github.com/mohammadZ74/MVVMRx_SampleProject "https://github.com/mohammadZ74/MVVMRx_SampleProject")

Don’t forget to 👏 if you liked the article & project. And you can catch me on [Twitter](https://twitter.com/Mohammad_z74) or via email (mohammad_Z74@icloud.com).

Thanks for reading!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
