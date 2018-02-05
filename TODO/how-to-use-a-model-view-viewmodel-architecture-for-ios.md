> * 原文地址：[How not to get desperate with MVVM implementation](https://medium.com/flawless-app-stories/how-to-use-a-model-view-viewmodel-architecture-for-ios-46963c67be1b)
> * 原文作者：[S.T.Huang](https://medium.com/@koromikoneo?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/how-to-use-a-model-view-viewmodel-architecture-for-ios.md](https://github.com/xitu/gold-miner/blob/master/TODO/how-to-use-a-model-view-viewmodel-architecture-for-ios.md)
> * 译者：[JayZhaoBoy](https://github.com/JayZhaoBoy)
> * 校对者：[swants](https://github.com/swants)，[ryouaki](https://github.com/ryouaki)

# 不再对 MVVM 感到绝望

![](https://cdn-images-1.medium.com/max/2000/1*jYS00y2Ml9GgtBq6EDHR2w.png)

让我们想象一下，你有一个小项目，通常在短短两天内你就可以提供新的功能。然后你的项目变得越来越大。完成日期开始变得无法控制，从2天到1周，然后是2周。它会把你逼疯！你会不断抱怨：一件好产品不应该那么复杂！然而这正是我所面对过的，对我来说那确实是一段糟糕的经历。现在，在这个领域工作了几年，与许多优秀的工程师合作过，让我真正意识到使代码变得如此复杂的并不是产品设计，而是我。

我们都有过因为编写面条式代码而损害我们项目的经历。问题是我们该如何去修复它？一个好的架构模式可能会帮到你。在这篇文章中，我们将要谈论一个好的架构模式：Model-View-ViewModel (MVVM)。MVVM 是一种专注于将用户界面开发与业务逻辑开发实现分离的 iOS 架构趋势。

「好架构」这个词听起来太抽象了。你会感到无从下手。这里有一点建议：不要把重点放在体系结构的定义上，我们可以把重点放在如何**提高代码的可测试性上**。现如今有很多软件架构，比如 MVC、MVP、MVVM、VIPER。很明显，我们可能无法掌握所有这些架构。但是，我们要记住一个简单的原则：不管我们决定使用什么样的架构，最终的目标都是使测试变得更简单。因此写代码之前我们要根据这一原则进行思考。我们强调如何直观的进行责任分离。此外，保持这种思维模式，架构的设计就会变得很清晰、合理，我们就不会再陷入琐碎的细节。

#### 太长(若)不看(请看这里)

在这篇文章中，你将学到：

* 我们之所以选择 MVVM 而不是 Apple MVC
* 如何根据 MVVM 设计更清晰的架构
* 如何基于 MVVM 编写一个简单的实际应用程序

你不会看到：

* MVVM、VIPER、Clean等架构之间的比较
* 一个能解决所有问题的万能方案

所有这些架构都有优点和缺点，但都是为了使代码变得更简单更清晰。所以我们决定把重点放在**为什么**我们选择 MVVM 而不是 MVC，以及我们**如何**从 MVC 转到 MVVM。如果您对 MVVM 的缺点有什么观点，请参阅本文最后的讨论。

让我们开始吧！

#### Apple MVC

MVC (Model-View-Controller) 是苹果推荐的架构模式。定义以及 MVC 中对象之间的交互如下图所示：

![](https://cdn-images-1.medium.com/max/800/1*la8KCs0AKSzVGShoLQo2oQ.png)

在 iOS/MacOS 的开发中，由于引入了 ViewController，通常会变成：

![](https://cdn-images-1.medium.com/max/800/1*8XM4gfWIvaOl8kHiNlxLeg.png)

ViewController 包含 View 和 Model。问题是我们通常都会在 ViewController 中编写控制器代码和视图层代码。它使 ViewController 变得太复杂。这就是为什么我们把它称为 Massive View Controller（臃肿的视图控制）。在为 ViewController 编写测试的同时，你需要模拟视图及其生命周期。但视图很难被模拟。如果我们只想测试控制器逻辑，我们实际上并不想模拟视图。所有这些都使得编写测试变得如此复杂。

所以 MVVM 来拯救你了。

#### MVVM — Model — View — ViewModel

MVVM 是由 [John Gossman](https://blogs.msdn.microsoft.com/johngossman/2005/10/08/introduction-to-modelviewviewmodel-pattern-for-building-wpf-apps/) 在 2005 年提出的。MVVM 的主要目的是将数据状态从 View 移动到 ViewModel。MVVM 中的数据传递如下图所示：

![](https://cdn-images-1.medium.com/max/800/1*8MiNUZRqM1XDtjtifxTSqA.png)

根据定义，View 只包含视觉元素。在视图中，我们只做布局、动画、初始化 UI 组件等等。View 和 Model 之间有一个称为 ViewModel 的特殊层。ViewModel 是 View 的标准表示。也就是说，ViewModel 提供了一组接口，每个接口代表 View 中的 UI 组件。我们使用一种称为「绑定」的技术将 UI 组件连接到 ViewModel 接口。因此，在 MVVM 中，我们不直接操作 View，而是通过处理 ViewModel 中的业务逻辑从而使视图也相应地改变。我们会在 ViewModel 而不是 View 中编写一些显示性的东西，例如将 Date 转换为 String。因此，不必知道 View 的实现就可以为显示的逻辑编写一个简单的测试。

让我们回过头再看看上面的图。通常情况下，ViewModel 从 View 接收用户交互，从 Model 中提取数据，然后将数据处理为一组即将显示的相关属性。在  ViewModel 变化后，View 就会自动更新。这就是 MVVM 的全部内容。

具体来说，对于 iOS 开发中的 MVVM，UIView/UIViewController 表示 View。我们只做：

1. 初始化/布局/呈现 UI 组件。
2. 用 ViewModel 绑定 UI 组件。

另一方面，在 ViewModel 中，我们做：

1. 编写控制器逻辑，如分页，错误处理等。
2. 写显示逻辑，提供接口到视图。

你可能会注意到这样 ViewModel 会变得有点复杂。在本文的最后，我们将讨论 MVVM 的缺点。但无论如何，对于一个中等规模的项目来说，想一点一点完成目标，MVVM 仍然是一个很棒的选择。

在接下来的部分，我们将使用 MVC 模式编写一个简单的应用程序，然后描述如何将应用程序重构为 MVVM 模式。带有单元测试的示例项目可以在我的 GitHub 上找到：

- [**koromiko/Tutorial**: _Tutorial - Code for https://koromiko1104.wordpress.com_github.com](https://github.com/koromiko/Tutorial/tree/master/MVVMPlayground)

让我们开始吧！

### 一个简单的画廊 app — MVC

我们将编写一个简单的应用程序，其中：

1. 该应用程序从 API 中获取 500px 的照片，并在 UITableView 中列出照片。
2. tableView 中的每个 cell 显示标题、说明和照片的创建日期。
3. 用户不能点击未标记为「for_sale」的照片。

在这个应用程序中，我们有一个名为 **Photo** 的结构，它代表一张照片。下面是我们的 **Photo** 类：

```
struct Photo {
    let id: Int
    let name: String
    let description: String?
    let created_at: Date
    let image_url: String
    let for_sale: Bool
    let camera: String?
}
```

该应用程序的初始视图控制器是一个包含名为 **PhotoListViewController** 的 tableView 的 UIViewController。我们通过 **PhotoListViewController** 中的 **APIService**获取**Photo** 对象，并在获取照片后重新载入 tableView：

```
  self?.activityIndicator.startAnimating()
  self.tableView.alpha = 0.0
  apiService.fetchPopularPhoto { [weak self] (success, photos, error) in
      DispatchQueue.main.async {
        self?.photos = photos
        self?.activityIndicator.stopAnimating()
        self?.tableView.alpha = 1.0
        self?.tableView.reloadData()
      }
  }
```

**PhotoListViewController** 也是 tableView 的一个数据源：

```
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    // ....................
    let photo = self.photos[indexPath.row]
    //Wrap the date
    let dateFormateer = DateFormatter()
    dateFormateer.dateFormat = "yyyy-MM-dd"
    cell.dateLabel.text = dateFormateer.string(from: photo.created_at)
    //.....................
}
  
func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.photos.count
}
```

在 **func tableView（_ tableView：UITableView，cellForRowAt indexPath：IndexPath） - > UITableViewCell** 中，我们选择相应的 **Photo** 对象并将标题、描述和日期分配给一个 cell。由于 **Photo**.date 是一个 Date 对象，我们必须使用 DateFormatter 将其转换为一个 String。

以下代码是 tableView 委托的实现：

```
func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    let photo = self.photos[indexPath.row]
    if photo.for_sale { // If item is for sale 
        self.selectedIndexPath = indexPath
        return indexPath
    }else { // If item is not for sale 
        let alert = UIAlertController(title: "Not for sale", message: "This item is not for sale", preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        return nil
    }
}
```

我们在 **func tableView（_ tableView：UITableView，willSelectRowAt indexPath：IndexPath） - > IndexPath** 中选择相应的 Photo 对象，检查 **for_sale** 属性。如果是 ture，就保存到 **selectedIndexPath**。如果是 false，则显示错误消息并返回 nil。

**PhotoListViewController** 的源码在[这里](https://github.com/koromiko/Tutorial/blob/MVC/MVVMPlayground/MVVMPlayground/Module/PhotoList/PhotoListViewController.swift)，请参考标签「MVC」。

那么上面的代码有什么问题呢？在 **PhotoListViewController** 中，我们可以找到显示的逻辑，如将 Date 转换为 String 以及何时启动/停止活动指示符。我们也有 Veiw 层代码，如显示/隐藏 tableView。另外，在视图控制器中还有另一个依赖项 ，API 服务。如果你打算为**PhotoListViewController**编写测试，你会发现你被卡住了，因为它太复杂了。我们必须模拟 **APIService**，模拟 tableView 以及 cell 来测试整个 **PhotoListViewController**。唷！

记住，我们想让测试变得更容易？让我们试试 MVVM 的方法！

#### 尝试 MVVM

为了解决这个问题，我们的首要任务是整理视图控制器，将视图控制器分成两部分：View 和 ViewModel。具体来说，我们要：

1. 设计一组绑定的接口。
2. 将显示逻辑和控制器逻辑移到 ViewModel。

首先，我们来看看 View 中的 UI 组件：

1. activity Indicator （加载/结束）
2. tableView （显示/隐藏）
3. cells （标题，描述，创建日期）

所以我们可以将 UI 组件抽象为一组规范化的表示：

![](https://cdn-images-1.medium.com/max/800/1*ktmfaTJajU0NYrCBq8iqnA.png)

每个 UI 组件在 ViewModel 中都有相应的属性。可以说我们在 View 中看到的应该和我们在 ViewModel 中看到的一样。

但是我们该如何绑定呢？

#### Implement the Binding with Closure

在 Swift 中，有很多方式来实现「绑定」：

1. 使用 KVO (Key-Value Observing) （键值观察）模式。
2. 使用第三方库 FRP （函数式响应编程） 例如 RxSwift 和 ReactiveCocoa。
3. 自己定制。

使用 KVO 模式是个不错的注意， 但它可能会创建大量的委托方法，我们必须小心 addObserver/removeObserver，这可能会成为 View 的一个负担。理想的方法是使用 FRP 中的绑定方案。如果你熟悉函数式响应编程，那就放手去做吧！如果不熟悉的话，那么我不建议使用 FRP 来实现绑定，这样子就太大材小用了。[Here](http://five.agency/solving-the-binding-problem-with-swift/) 是一个很好的文章，谈论使用装饰模式来自己实现绑定。在这篇文章中，我们将把事情简单化。我们使用闭包来实现绑定。实际上，在 ViewModel 中，绑定接口/属性如下所示：


```

var prop: T {
    didSet {
        self.propChanged?()
    }
}
```

另一方面，在 View 中，我们为 propChanged 指定一个作为值更新回调的闭包。


```
// When Prop changed, do something in the closure 
viewModel.propChanged = { in
    DispatchQueue.main.async {
        // Do something to update view 
    }
}
```

每次属性 prop 更新时，都会调用 propChanged。所以我们就可以根据 ViewModel 的变化来更新 View。很简单，对吗？

#### 在 ViewModel 中进行绑定的接口

现在，让我们开始设计我们的 ViewModel，**PhotoListViewModel**。给定以下三个UI组件：

1. tableView
2. cells
3. activity indicator

我们在 **PhotoListViewModel** 中创建绑定的接口/属性：

```
private var cellViewModels: [PhotoListCellViewModel] = [PhotoListCellViewModel]() {
    didSet {
        self.reloadTableViewClosure?()
    }
}
var numberOfCells: Int {
    return cellViewModels.count
}
func getCellViewModel( at indexPath: IndexPath ) -> PhotoListCellViewModel

var isLoading: Bool = false {
    didSet {
        self.updateLoadingStatus?()
    }
}
```

每个 **PhotoListCellViewModel** 对象在 tableView 中形成一个规范显示的 cell。它提供了用于渲染 UITableView cell 的数据接口。我们把所有的 **PhotoListCellViewModel** 对象放入一个数组 **cellViewModels** 中，cell 的数量恰好是该数组中的项目数。我们可以说数组 **cellViewModels** 表示 tableView。一旦我们更新 ViewModel 中的 **cellViewModels**，闭包 **reloadTableViewClosure** 将被调用并且 View 将进行相应地更新。

一个简单的 **PhotoListCellViewModel** 如下所示：

```
struct PhotoListCellViewModel {
    let titleText: String
    let descText: String
    let imageUrl: String
    let dateText: String
}
```

正如你所看到的，**PhotoListCellViewModel** 提供了绑定到 View 中的 UI 组件接口的属性。

#### 将 View 与 ViewModel 绑定

有了绑定的接口，现在我们将重点放在 View 部分。首先，在 **PhotoListViewController** 中，我们初始化 viewDidLoad 中的回调闭包：

```
viewModel.updateLoadingStatus = { [weak self] () in
    DispatchQueue.main.async {
        let isLoading = self?.viewModel.isLoading ?? false
        if isLoading {
            self?.activityIndicator.startAnimating()
            self?.tableView.alpha = 0.0
        }else {
            self?.activityIndicator.stopAnimating()
            self?.tableView.alpha = 1.0
        }
    }
}
    
viewModel.reloadTableViewClosure = { [weak self] () in
    DispatchQueue.main.async {
        self?.tableView.reloadData()
    }
}
```

然后我们要重构数据源。在 MVC 模式中，我们在 **func tableView（_ tableView：UITableView，cellForRowAt indexPath：IndexPath） - > UITableViewCell** 中设置了显示逻辑，现在我们必须将显示逻辑移动到 ViewModel。重构的数据源如下所示：

```

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "photoCellIdentifier", for: indexPath) as? PhotoListTableViewCell else { fatalError("Cell not exists in storyboard")}
		
    let cellVM = viewModel.getCellViewModel( at: indexPath )
		
    cell.nameLabel.text = cellVM.titleText
    cell.descriptionLabel.text = cellVM.descText
    cell.mainImageView?.sd_setImage(with: URL( string: cellVM.imageUrl ), completed: nil)
    cell.dateLabel.text = cellVM.dateText
		
    return cell
}
```

数据流现在变成：

1. PhotoListViewModel 开始获取数据。
2. 获取数据后，我们创建 **PhotoListCellViewModel** 对象并更新 **cellViewModels**。
3. **PhotoListViewController** 被通知更新，然后使用更新后的 **cellViewModels** 布局 cells。

如下图所示：

![](https://cdn-images-1.medium.com/max/800/1*w4bDvU7IlxOpQZNw49fmyQ.png)

#### 处理用户交互

我们来看看用户交互。在 **PhotoListViewModel** 中，我们创建一个函数：

```
func userPressed( at indexPath: IndexPath )
```

当用户点击单个 cell 时，**PhotoListViewController** 使用此函数通知 **PhotoListViewModel**。所以我们可以在 **PhotoListViewController** 中重构委托方法：

```
func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {	
    self.viewModel.userPressed(at: indexPath)
    if viewModel.isAllowSegue {
        return indexPath
    }else {
        return nil
    }
}
```

这意味着一旦 **func tableView（_ tableView：UITableView，willSelectRowAt indexPath：IndexPath） - > IndexPath** 被调用，则该操作将被传递给 **PhotoListViewModel**。委托函数根据由 **PhotoListViewModel** 提供的 isAllowSegue 属性决定是否继续。我们就成功地从视图中删除了状态。🍻

#### PhotoListViewModel 的实现

这是一个漫长的过程，对吧？耐心点，我们已经触及到了 MVVM 的核心！ 在 **PhotoListViewModel** 中，我们有一个名为 **cellViewModels** 的数组，它表示 View 中的 tableView。

```

private var cellViewModels: [PhotoListCellViewModel] = [PhotoListCellViewModel]()
```

我们如何获取并排列数据呢？实际上我们在 ViewModel 的初始化中做了两件事：

1. 注入依赖项目：**APIService**
2. 使用 **APIService** 获取数据

```
init( apiService: APIServiceProtocol ) {
    self.apiService = apiService
    initFetch()
}
func initFetch() {	
    self.isLoading = true
    apiService.fetchPopularPhoto { [weak self] (success, photos, error) in
        self?.processFetchedPhoto(photos: photos)
        self?.isLoading = false
    }
}
```

在上面的代码片段中，我们将属性 isLoading 设置为 true，然后开始从 **APIService** 中获取数据。由于我们之前所做的绑定，将 isLoading 设置为 true 意味着视图将切换活动指示器。在 **APIService** 的回调闭包中，我们处理提取的照片 models 并将 isLoading 设置为 false。我们不需要直接操作 UI 组件，但很显然，当我们改变 ViewModel 的这些属性时，UI 组件就会像我们所期望的那样工作。

这里是 **processFetchedPhoto( photos: [Photo] )** 的实现：


```

private func processFetchedPhoto( photos: [Photo] ) {
    self.photos = photos // Cache
    var vms = [PhotoListCellViewModel]()
    for photo in photos {
        vms.append( createCellViewModel(photo: photo) )
    }
    self.cellViewModels = vms
}
```

它做了一个简单的工作，将照片 models 装成一个 **PhotoListCellViewModel** 数组。当更新 **cellViewModels** 属性时，View 中的 tableView 会相应的更新。

耶，我们完成了 MVVM 🎉

示例应用程序可以在我的 GitHub 上找到：

- [**koromiko/Tutorial**](https://github.com/koromiko/Tutorial/tree/MVC/MVVMPlayground)

如果你想查看 MVC 版本（标签：MVC），然后 MVVM（最新的提交）

#### Recap

在本文中，我们成功地将一个简单的应用程序从 MVC 模式转换为 MVVM 模式。我们：

* 使用闭包创建绑定主题。
* 从 View 中删除了所有的控制器逻辑。
* 创建了一个可测试的 ViewModel。

#### 探讨

正如我上面提到的，架构都有优点和缺点。在阅读我的文章之后，如果你对 MVVM 的缺点有一些看法。这里有很多关于 MVVM 缺点的文章，比如：

[MVVM is Not Very Good — Soroush Khanlou](http://khanlou.com/2015/12/mvvm-is-not-very-good/)
[The Problems with MVVM on iOS — Daniel Hall](http://www.danielhall.io/the-problems-with-mvvm-on-ios)

我最关心的是 MVVM 中 ViewModel 做了太多的事情。正如我在本文中提到的，我们在 ViewModel 中有控制器和演示器。此外，MVVM 模式中不包括构建器和路由器。我们通常把构建器和路由器放在 ViewController 中。如果你对更清晰的解决方案感兴趣，可以了解 MVVM + FlowController ([Improve your iOS Architecture with FlowControllers](http://merowing.info/2016/01/improve-your-ios-architecture-with-flowcontrollers/)) 和两个着名的架构，[VIPER](https://www.objc.io/issues/13-architecture/viper/) 和 [Clean by Uncle Bob](https://hackernoon.com/introducing-clean-swift-architecture-vip-770a639ad7bf).

#### 从小处着手

总会存在更好的解决方案。作为专业的工程师，我们一直在学习如何提高代码质量。许多像我一样的开发者曾经被这么多架构所淹没，不知道如何开始编写单元测试。所以 MVVM 是一个很好的开始。很简单，可测试性还是很不错的。在另一篇 Soroush Khanlou 的文章中，[8 Patterns to Help You Destroy Massive View Controller](http://khanlou.com/2014/09/8-patterns-to-help-you-destroy-massive-view-controller/)，这里有有很多好的模式，其中一些也被MVVM所采用。与其受一个巨大的架构所阻碍，我们何不开始用小而强大的 MVVM 模式开始编写测试呢？


> “The secret to getting ahead is getting started.” — Mark Twain

在下一篇文章中，我将继续谈谈如何为我们简单的画廊应用程序编写单元测试。敬请关注！

如果你有任何问题，留下评论。欢迎任何形式的讨论！感谢您的关注。

#### 参考

[Introduction to Model/View/ViewModel pattern for building WPF apps — John Gossman](https://blogs.msdn.microsoft.com/johngossman/2005/10/08/introduction-to-modelviewviewmodel-pattern-for-building-wpf-apps/)
[Introduction to MVVM — objc](https://www.objc.io/issues/13-architecture/mvvm/)
[iOS Architecture Patterns — Bohdan Orlov](https://medium.com/ios-os-x-development/ios-architecture-patterns-ecba4c38de52)
[Model-View-ViewModel with swift — SwiftyJimmy](http://swiftyjimmy.com/category/model-view-viewmodel/)
[Swift Tutorial: An Introduction to the MVVM Design Pattern — DINO BARTOŠAK](https://www.toptal.com/ios/swift-tutorial-introduction-to-mvvm)
[MVVM — Writing a Testable Presentation Layer with MVVM — Brent Edwards](https://msdn.microsoft.com/en-us/magazine/dn463790.aspx)
[Bindings, Generics, Swift and MVVM — Srdan Rasic](http://rasic.info/bindings-generics-swift-and-mvvm/)


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
