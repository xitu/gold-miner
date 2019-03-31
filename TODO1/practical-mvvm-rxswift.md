> * 原文地址：[Practical MVVM + RxSwift](https://medium.com/flawless-app-stories/practical-mvvm-rxswift-a330db6aa693)
> * 原文作者：[Mohammad Zakizadeh](https://medium.com/@mamalizaki74)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/practical-mvvm-rxswift.md](https://github.com/xitu/gold-miner/blob/master/TODO1/practical-mvvm-rxswift.md)
> * 译者：
> * 校对者：

# Practical MVVM + RxSwift

![](https://cdn-images-1.medium.com/max/2560/1*bOnecl6tpYN6Ll3Z8L6ILQ.png)

Today we will implement MVVM design pattern with RxSwift. For those of you who are new to RxSwift, I made an intro part [here](https://hackernoon.com/mvvm-rxswift-on-ios-part-1-69608b7ed5cd).

If you think RxSwift is hard or ambiguous, don’t worry. It may seem hard at first but with the examples and practice, it will become simple and understandable.👍

* * *

While implementing the MVVM design pattern with RxSwift, we will use all the advantages of this approach in a real project. We will work on a simple app that shows a list of Linkin Park’s albums and songs in the UICollectionView and UITableView (R.I.P Chester🙏). Let’s begin!

![](https://cdn-images-1.medium.com/max/800/1*9n5BZ0fj4qPZy54zO11WgQ.png)

App main view

### UI Setup

#### Child View Controllers

I’d love to follow Reusability  Principle while building our app. So we will implement our albums CollectionView and songs TableView in a way that we can later reuse these views in other parts of our app. For example, imagine we want to show songs from each album or we have a part that shows similar albums. If we don’t want to implement these parts each time, it’s better to make them reusable.

So what can we do? Child viewControllers to the rescue.  
For this we divide UIViewController with the use of ContainerView in 2 parts:

1. AlbumCollectionViewVC  
2. TrackTableViewVC

Now the parent viewController consists of two ChildViewControllers (to learn about childViewController you can read this [article](https://cocoacasts.com/managing-view-controllers-with-container-view-controllers/)).

So our main ViewController will become:

![](https://cdn-images-1.medium.com/max/800/1*ENiIFLcQxvbZHuyJPywNCw.png)

We use nib for our cells so we can reuse them easily:

![](https://cdn-images-1.medium.com/max/800/0*R8OnBBlFwgXB4i6_.png)

For registering the cells of nib file, you should put this code in viewDidLoad method of AlbumCollectionViewVC class. So the UICollectionView understands what kind of cells it’s using:

```
//register 'AlbumsCollectionViewCell' to UICollectionView

albumsCollectionView.register(UINib(nibName: "AlbumsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: String(describing: AlbumsCollectionViewCell.self))

```

Consider that this code should be in AlbumCollectionViewVC class. This means that one of the child’s classes of parent class and the parent class has to do nothing with the objects of its child’s class for now.

For TrackTableViewVC we do the same process with the difference that it is just a table view. Now we’re going to parent class and we should setup our 2 child classes.

As you saw in the storyboard picture, the place of child classes is two views in which our viewControllers are placed. These views are called ContainerView. For setting up these views we can use the following code:

```
@IBOutlet weak var albumsVCView: UIView!
    
    private lazy var albumsViewController: AlbumsCollectionViewVC = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Home", bundle: Bundle.main)
        
        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "AlbumsCollectionViewVC") as! AlbumsCollectionViewVC
        
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController, to: albumsVCView)
        
        return viewController
    }()
```

### View Model Setup

#### Basic View Model Architecture

So our Views are ready now we get to ViewModel and RxSwift:

![](https://cdn-images-1.medium.com/max/800/1*xHDv8WNJYCMHAAjKTF18Xw.gif)

In the home ViewModel class, we should get data from our server and do the parsing in a way that the view exactly wants. Then viewModel gives it to the parent class and the parent class passes those data to the child view controllers. It means that the parent class requests data from its view model and the view model sends a request to the network layer. Then the view model parses the data and gives it to the parent class.

Take a look at the following diagram for better understanding:

![](https://cdn-images-1.medium.com/max/800/0*_cCs2kvBNIQUwF2X.png)

The completed project in [GitHub](https://github.com/mohammadZ74/MVVMRx_SampleProject) is implemented in RxSwift and without Rx. The implementation without Rx is in [MVVMWithoutRx](https://github.com/mohammadZ74/MVVMRx_SampleProject/tree/MVVMWithoutRx) branch. In this article, we get through the RxSwift way. Please check without Rx way too, which implemented with closures.

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
