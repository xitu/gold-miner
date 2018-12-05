> * 原文地址：[Design Patterns on iOS using Swift – Part 2/2](https://www.raywenderlich.com/476-design-patterns-on-ios-using-swift-part-2-2)
> * 原文作者：[Lorenzo Boaro](https://www.raywenderlich.com/u/lorenzoboaro)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/design-patterns-on-ios-using-swift-part-2-2.md](https://github.com/xitu/gold-miner/blob/master/TODO1/design-patterns-on-ios-using-swift-part-2-2.md)
> * 译者：[iWeslie](https://github.com/iWeslie)
> * 校对者：

# 使用 Swift 的 iOS 设计模式（第二部分）

在这个由两部分组成的教程中，你将了解构建 iOS 应用程序的常见设计模式，以及如何在自己的应用程序中应用这些模式。

> **更新说明**：本教程已由译者针对 iOS 12，Xcode 10 和 Swift 4.2 进行了更新。原帖由教程团队成员 Eli Ganem发布。

欢迎回到 iOS 设计模式的入门教程第二部分！在 [第一部分](https://juejin.im/post/5c05d4ee5188250ab14e62d6) 中, 你已经了解了 Cocoa 中的一些基本模式，比如 MVC、单例和装饰模式。

在最后一部分中，您将了解 iOS 和 OS X 开发中出现的其他基本设计模式：适配器、观察者和备忘录。让我们快开始吧！

## 入门

你可以下载 [第一部分最结尾处的项目](https://koenig-media.raywenderlich.com/uploads/2017/07/RWBlueLibrary-Part1-Final.zip) 来开始.

这是您在第一部分结尾处留下的音乐库应用程序：

![Album app showing populated table view](https://koenig-media.raywenderlich.com/uploads/2017/07/appwithtableviewpopulated-180x320.png)

该应用程序的原计划包括了屏幕顶部用来在专辑之间切换的水平滚动条。与其编写一个只有单个用途水平滚动条，为何不让它变得可以让其他任何 View 复用呢？

要使此滚动条可复用，有关其内容的所有决策都应留给其他两个对象：数据源和代理。为了使用水平滚动条，应该给它声明数据源和代理实现的方法，这就类似于 `UITableView` 的代理方法工作方式。当我们讨论下一个设计模式时，您将来实现它。

## 适配器模式

适配器允许和具有不兼容接口的类一起工作，它将自身包裹在一个对象周围，并公开一个标准接口以与该对象进行交互。

如果您熟悉适配器模式，那么您会注意到 Apple 以一种稍微不同的方式实现它 -- 使用协议。您可能熟悉 `UITableViewDelegate`，`UIScrollViewDelegate`，`NSCoding`和 `NSCopying` 等协议。例如使用 `NSCopying` 协议，任何类都可以提供一个标准的 `copy` 方法。

## 如何使用适配器模式

之前提到的水平滚动条如下所示：

[![swiftDesignPattern7](https://koenig-media.raywenderlich.com/uploads/2014/11/swiftDesignPattern7-480x153.png)](https://koenig-media.raywenderlich.com/uploads/2014/11/swiftDesignPattern7.png)

我们现在来实现它，右击项目导航栏中的 View 组，选择 **New File > iOS > Cocoa Touch Class**，然后单击 **Next**，将类名设置为 `HorizontalScrollerView` 并继承自 `UIView`。

打开 **HorizontalScrollerView.swift** 并在 `HorizontalScroller` 类声明的 **上方** 插入以下代码：

```swift
protocol HorizontalScrollerViewDataSource: class {
  // 询问数据源它想要在水平滚动条中显示多少个 View
  func numberOfViews(in horizontalScrollerView: HorizontalScrollerView) -> Int
  // 请求数据源返回应该出现在第 index 个的 View
  func horizontalScrollerView(_ horizontalScrollerView: HorizontalScrollerView, viewAt index: Int) -> UIView
}
```

这定义了一个名为 `HorizontalScrollerViewDataSource` 的协议，它执行两个操作：请求在水平滚动器内显示 View 的个数以及应为特定索引显示的 View。

在此协议定义的下方添加另一个名为 `HorizontalScrollerViewDelegate` 的协议。

```swift
protocol HorizontalScrollerViewDelegate: class {
  // 通知代理第 index 个 View 已经被选择
  func horizontalScrollerView(_ horizontalScrollerView: HorizontalScrollerView, didSelectViewAt index: Int)
}
```

这将使水平滚动器通知某个其他对象已选择一个 View。

**注意：**将关注的区域划分为不同的协议会使代码看起来更加清晰。通过这种方式，您可以决定遵循特定的协议，并避免使用 `@objc` 来声明可选的协议方法。

在 **HorizontalScrollerView.swift** 中，将以下代码添加到 `HorizontalScrollerView` 类的定义里：

```swift
weak var dataSource: HorizontalScrollerViewDataSource?
weak var delegate: HorizontalScrollerViewDelegate?
```

代理和数据源都是可选项，因此您不一定要给他们赋值，但您在此处设置的任何对象都必须遵循相应的协议。

在类里继续添加以下代码：

```swift
// 1
private enum ViewConstants {
  static let Padding: CGFloat = 10
  static let Dimensions: CGFloat = 100
  static let Offset: CGFloat = 100
}

// 2
private let scroller = UIScrollView()

// 3
private var contentViews = [UIView]()
```

每条注释对应的详细解释如下：

1. 定义一个私有的 `enum` 来使代码布局在设计时更易修改。滚动器的内的 View 尺寸为 100 x 100，padding 为 10
2. 创建包含多个 View 的 scrollView
3. 创建一个包含所有专辑封面的数组

接下来您需要实现初始化器。添加以下方法：

```swift
override init(frame: CGRect) {
  super.init(frame: frame)
  initializeScrollView()
}

required init?(coder aDecoder: NSCoder) {
  super.init(coder: aDecoder)
  initializeScrollView()
}

func initializeScrollView() {
  //1
  addSubview(scroller)

  //2
  scroller.translatesAutoresizingMaskIntoConstraints = false

  //3
  NSLayoutConstraint.activate([
    scroller.leadingAnchor.constraint(equalTo: self.leadingAnchor),
    scroller.trailingAnchor.constraint(equalTo: self.trailingAnchor),
    scroller.topAnchor.constraint(equalTo: self.topAnchor),
    scroller.bottomAnchor.constraint(equalTo: self.bottomAnchor)
  ])

  //4
  let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(scrollerTapped(gesture:)))
  scroller.addGestureRecognizer(tapRecognizer)
}
```

这项工作是在 `initializeScrollView()` 中完成的。以下是该详细分析：

1. 将 `UIScrollView` 实例添加到 superView
2. 关闭自动调整遮罩（autoresizing mask），这样您就可以使用自定义约束
3. 将约束应用于 scrollview，您希望 scrollview 完全填充 `HorizontalScrollerView`
4. 创建轻击手势识别器（tap gesture recognizer）。它会检测 scrollView 上的触摸事件并检查是否已经轻击了专辑封面。如果是，它将通知 `HorizontalScrollerView` 的代理。在这里你会遇到编译错误，因为 scrollerTapped(gesture:) 方法尚未实现，你接下来就要实现了。

现在添加下面的方法：

```swift
func scrollToView(at index: Int, animated: Bool = true) {
  let centralView = contentViews[index]
  let targetCenter = centralView.center
  let targetOffsetX = targetCenter.x - (scroller.bounds.width / 2)
  scroller.setContentOffset(CGPoint(x: targetOffsetX, y: 0), animated: animated)
}
```

此方法检索特定索引的 View 并使其居中。它将由以下方法调用（也需要你将此方法添加到类中）：

```swift
@objc func scrollerTapped(gesture: UITapGestureRecognizer) {
  let location = gesture.location(in: scroller)
  guard
    let index = contentViews.index(where: { $0.frame.contains(location)})
    else { return }

  delegate?.horizontalScrollerView(self, didSelectViewAt: index)
  scrollToView(at: index)
}
```

此方法在 scrollView 中查找点击的位置，如果存在的话它会查找包含该位置的第一个 contentView 的索引。

如果点击了 contentView，则通知代理并将此 View 滚动到中心位置。

接下来添加以下内容以从滚动器访问专辑封面：

```swift
func view(at index :Int) -> UIView {
  return contentViews[index]
}
```

`view(at:)` 只返回特定索引处的 View，稍后您将使用此方法突出显示您已点击的专辑封面。

现在添加以下代码来重新加载滚动器：

```swift
func reload() {
  // 1 - 检查是否有数据源，如果没有则返回。
  guard let dataSource = dataSource else {
    return
  }

  //2 - 删除所有旧的 contentView
  contentViews.forEach { $0.removeFromSuperview() }

  // 3 - xValue 是滚动器内每个 View 的起点
  var xValue = ViewConstants.Offset
  // 4 - 获取并添加新的 View
  contentViews = (0..<dataSource.numberOfViews(in: self)).map {
    index in
    // 5 - 在正确的位置添加 View
    xValue += ViewConstants.Padding
    let view = dataSource.horizontalScrollerView(self, viewAt: index)
    view.frame = CGRect(x: CGFloat(xValue), y: ViewConstants.Padding, width: ViewConstants.Dimensions, height: ViewConstants.Dimensions)
    scroller.addSubview(view)
    xValue += ViewConstants.Dimensions + ViewConstants.Padding
    return view
  }
  // 6
  scroller.contentSize = CGSize(width: CGFloat(xValue + ViewConstants.Offset), height: frame.size.height)
}
```

`UITableView`中的 `reload` 方法会在 `reloadData` 之后建模，它将重新加载用于构造水平滚动器的所有数据。

每条注释对应的详细解释如下：

1. 在执行任何 reload 之前检查是否有数据源。
2. 由于您要清除专辑封面，因此您还需要移除所有存在的 View。
3. 所有 View 都从给定的偏移量开始定位。目前它是 100，但可以通过更改文件顶部的常量 `ViewConstants.Offset` 来轻松地做出调整。
4. 向数据源请求 View 的个数，然后使用它来创建新的 contentView 数组。
5. `HorizontalScrollerView` 一次向一个 View 请求其数据源，并使用先前定义的填充将它们水平挨个布局。
6. 所有 View 布局好之后，设置 scrollView 的偏移量来允许用户滚动浏览所有专辑封面。

当你的数据发生改变时调用 `reload` 方法。

`HorizontalScrollerView` 需要实现的最后一个功能是确保您正在查看的专辑始终位于 scrollView 的中心。为此，当用户用手指拖动 scrollView 时，您需要执行一些计算。

下面添加以下方法：

```swift
private func centerCurrentView() {
  let centerRect = CGRect(
    origin: CGPoint(x: scroller.bounds.midX - ViewConstants.Padding, y: 0),
    size: CGSize(width: ViewConstants.Padding, height: bounds.height)
  )

  guard let selectedIndex = contentViews.index(where: { $0.frame.intersects(centerRect) })
    else { return }
  let centralView = contentViews[selectedIndex]
  let targetCenter = centralView.center
  let targetOffsetX = targetCenter.x - (scroller.bounds.width / 2)

  scroller.setContentOffset(CGPoint(x: targetOffsetX, y: 0), animated: true)
  delegate?.horizontalScrollerView(self, didSelectViewAt: selectedIndex)
}
```

上面的代码考虑了 scrollView 的当前偏移量以及 View 的尺寸和填充以便计算当前 View 与中心的距离。最后一行很重要：一旦 View 居中，就通知代理所选的 View 已变更。

要检测用户是否在 scrollView 内完成了拖动，您需要实现一些 `UIScrollViewDelegate` 的方法，将以下类扩展添加到文件的底部。记住一定要在主类声明的花括号 **下面** 添加！

```swift
extension HorizontalScrollerView: UIScrollViewDelegate {
  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    if !decelerate {
      centerCurrentView()
    }
  }

  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    centerCurrentView()
  }
}
```

`scrollViewDidEndDragging(_:willDecelerate:)` 在用户完成拖拽时通知代理，如果 scrollView 尚未完全停止，则 `decelerate` 为 true。当滚动结束时，系统调用`scrollViewDidEndDecelerating(_:)`。在这两种情况下，您都应该调用新方法使当前视图居中，因为当用户拖动滚动视图后当前视图可能已更改。

最后不要忘记设置代理，将以下代码添加到 `initializeScrollView()` 的最开头：

```swift
scroller.delegate = self
```

您的 `HorizontalScrollerView` 已准备就绪！看一下您刚刚编写的代码，你会看到没有任何地方有出现 `Album` 或 `AlbumView` 类。这非常棒，因为这意味着新的滚动器真正实现了独立并且可复用。

编译项目确保可以正常通过编译。

现在 `HorizontalScrollerView` 已经完成，是时候在你的应用程序中使用它了。首先打开 **Main.storyboard**。单击顶部的灰色矩形视图，然后单击 **Identity Inspector**。将类名更改为 `HorizontalScrollerView`，如下图所示：

[![](https://koenig-media.raywenderlich.com/uploads/2017/06/design-patterns-part2-scroller-480x270.png)](https://koenig-media.raywenderlich.com/uploads/2017/06/design-patterns-part2-scroller.png)

接下来打开 **Assistant Editor** 并从灰色矩形 View 拖线到 **ViewController.swift** 来创建一个 IBOutlet，并命名为 **horizontalScrollerView**，如下图所示：

[![](https://koenig-media.raywenderlich.com/uploads/2017/06/design-patterns-part2-scroller-outlet-480x270.png)](https://koenig-media.raywenderlich.com/uploads/2017/06/design-patterns-part2-scroller-outlet.png)

接下来打开 **ViewController.swift**，是时候开始实现一些 `HorizontalScrollerViewDelegate` 方法了！

把下面的拓展添加到该文件的最底部：

```swift
extension ViewController: HorizontalScrollerViewDelegate {
  func horizontalScrollerView(** horizontalScrollerView: HorizontalScrollerView, didSelectViewAt index: Int) {
    // 1
    let previousAlbumView = horizontalScrollerView.view(at: currentAlbumIndex) as! AlbumView
    previousAlbumView.highlightAlbum(false)
    // 2
    currentAlbumIndex = index
    // 3
    let albumView = horizontalScrollerView.view(at: currentAlbumIndex) as! AlbumView
    albumView.highlightAlbum(true)
    // 4
    showDataForAlbum(at: index)
  }
}
```

这是在调用此代理方法时发生的事情：

1. 首先您取到之前选择的专辑，然后取消选择专辑封面。
2. 存储刚刚点击的当前专辑封面的索引
3. 取得当前所选的专辑封面并显示高亮状态。
4. 在 tableView 中显示新专辑的数据

接下来，是时候实现 `HorizontalScrollerViewDataSource` 了。在当前文件末尾添加以下代码：

```swift
extension ViewController: HorizontalScrollerViewDataSource {
  func numberOfViews(in horizontalScrollerView: HorizontalScrollerView) -> Int {
    return allAlbums.count
  }

  func horizontalScrollerView(_ horizontalScrollerView: HorizontalScrollerView, viewAt index: Int) -> UIView {
    let album = allAlbums[index]
    let albumView = AlbumView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), coverUrl: album.coverUrl)
    if currentAlbumIndex == index {
      albumView.highlightAlbum(true)
    } else {
      albumView.highlightAlbum(false)
    }
    return albumView
  }
}
```

正如您所看到的，`numberOfViews(in:)` 是返回 scrollView 中 View 的个数的协议方法。由于 scrollView 将显示所有专辑数据的封面，因此 count 就是专辑记录的数量。在 `horizontalScrollerView(_:viewAt:)` 里你创建一个新的 `AlbumView`，如果它是所选的专辑，则高亮显示它，再将它传递给 `HorizontalScrollerView`。

基本完成了！只用三个简短的方法就能显示出一个漂亮的 scrollView。您现在需要设置数据源和代理。在 `viewDidLoad` 中的 `showDataForAlbum(at:)` 之前添加以下代码：

```swift
horizontalScrollerView.dataSource = self
horizontalScrollerView.delegate = self
horizontalScrollerView.reload()
```

编译并运行您的项目，就可以看到漂亮的水平滚动视图：

![Album cover scroller ](https://koenig-media.raywenderlich.com/uploads/2017/07/ScrollerNoImages-180x320.png)

呃，等一下！水平滚动视图已就位，但专辑的封面在哪里呢？

啊，没错，你还没有实现下载封面的代码。为此，您需要添加下载图像的方法，而且您对服务的所有访问都通过一个所有新方法必经的一层 `LibraryAPI`。但是，首先要考虑以下几点：

1. `AlbumView` 不应直接与 `LibraryAPI` 一起使用，您不会希望将 View 里的逻辑与通信逻辑混合在一起的。
2. 出于同样的原因，`LibraryAPI` 不应该牵连 `AlbumView`。
3. 当封面被下载完成，`LibraryAPI` 需要通知 `AlbumView` 因为 `AlbumView` 得显示封面。

Sounds like a conundrum? Don't despair, you'll learn how to do this using the **Observer** pattern!是不是感觉听起来好像很难的样子？不要绝望，你将学习如何使用 **观察者** 模式来做到这点！

## 观察者模式

在观察者模式中，一个对象通知其他对象任何状态的更改，但是通知的涉及对象不需要相互关联，我们鼓励这种解耦的设计方式。这种模式最常用于在一个对象的属性发生更改时通知其他相关对象。

通常的实现是需要观察者监听另一个对象的状态。当状态发生改变时，所有观察对象都被会通知此次更改。

如果你坚持 MVC 的概念（也确实需要坚持），你需要允许 Model 对象与 View 对象进行通信，但是它们之间没有直接引用，这就是观察者模式的用武之地。

Cocoa 以两种方式实现了观察者模式：**通知** 和 **键值监听（KVO）**。

### 通知

不要与推送通知或本地通知混淆，观察者模式的通知基于订阅和发布模型，该模型允许对象（发布者）将消息发送到其他对象（订阅者或监听者），而且发布者永远不需要了解有关订阅者的任何信息。

Apple 会大量使用通知。例如，当显示或隐藏键盘时，系统分别发送 `UIKeyboardWillShow` 和 `UIKeyboardWillHide` 通知。当您的应用程序转入后台运行时，系统会发送一个 `UIApplicationDidEnterBackground` 通知。

### 如何使用通知

右击 **RWBlueLibrary** 并选择 **New Group**，然后命名为 **Extension**。再次右击该组，然后选择**New File > iOS > Swift File**，并将文件名设置为 **NotificationExtension.swift**。

把下面的代码拷贝到该文件中：

```swift
extension Notification.Name {
  static let BLDownloadImage = Notification.Name("BLDownloadImageNotification")
}
```

您正在使用自定义通知扩展的 `Notification.Name`，从现在开始，新的通知可以像系统通知一样用 `.BLDownloadImage` 访问。

打开 **AlbumView.swift** 并将以下代码插入到 `init(frame:coverUrl:)` 方法的最后：

```swift
NotificationCenter.default.post(name: .BLDownloadImage, object: self, userInfo: ["imageView": coverImageView, "coverUrl" : coverUrl])
```

该行代码通过 `NotificationCenter` 的单例发送通知，通知信息包含要填充的 `UIImageView` 和要下载的封面图像的 URL，这些是执行封面下载任务所需的所有信息。

将以下代码添加到 **LibraryAPI.swift**中的 `init` 方法来作为当前为空的初始化方法的实现：

```swift
NotificationCenter.default.addObserver(self, selector: #selector(downloadImage(with:)), name: .BLDownloadImage, object: nil)
```

这是通知这个等式的另一边--观察者，每次 `AlbumView` 发送 `BLDownloadImage` 通知时，由于 `LibraryAPI` 已注册成为该通知的观察者，系统会通知 `LibraryAPI`，然后 `LibraryAPI` 响应并调用 `downloadImage(with:)`。

在实现 `downloadImage(with:)` 之前，还有一件事要做。在本地保存下载的封面可能是个好主意，这样应用程序就不需要一遍又一遍地下载相同的封面了。

打开 **PersistencyManager.swift**，把 `import Foundation` 换成下面的代码：

```swift
import UIKit
```

此次 import 很重要，因为你将处理 `UI` 对象，比如`UIImage`。

把这个计算属性添加到该类的最后：

```swift
private var cache: URL {
  return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
}
```

此变量返回缓存目录的 URL，它是一个存储了您可以随时重新下载的文件的好地方。

现在添加以下两个方法：

```swift
func saveImage(** image: UIImage, filename: String) {
  let url = cache.appendingPathComponent(filename)
  guard let data = UIImagePNGRepresentation(image) else {
    return
  }
  try? data.write(to: url)
}

func getImage(with filename: String) -> UIImage? {
  let url = cache.appendingPathComponent(filename)
  guard let data = try? Data(contentsOf: url) else {
    return nil
  }
  return UIImage(data: data)
}
```

这段代码非常简单，下载的图像将保存在 Cache 目录中，如果在 Cache 目录中找不到匹配的文件，`getImage(with:)` 将返回 `nil`。

现在打开 **LibraryAPI.swift** 并且将 `import Foundation` 改为 `import UIKit`。

在类的最后添加以下方法：

```swift
@objc func downloadImage(with notification: Notification) {
  guard let userInfo = notification.userInfo,
    let imageView = userInfo["imageView"] as? UIImageView,
    let coverUrl = userInfo["coverUrl"] as? String,
    let filename = URL(string: coverUrl)?.lastPathComponent else {
      return
  }

  if let savedImage = persistencyManager.getImage(with: filename) {
    imageView.image = savedImage
    return
  }

  DispatchQueue.global().async {
    let downloadedImage = self.httpClient.downloadImage(coverUrl) ?? UIImage()
    DispatchQueue.main.async {
      imageView.image = downloadedImage
      self.persistencyManager.saveImage(downloadedImage, filename: filename)
    }
  }
}
```

以下是上面两个方法的详解：

1. `downloadImage` 是通过通知触发调用的，因此该方法接收通知对象作为参数。从通知传递来的对象取出 `UIImageView` 和 image 的 URL。
2. 如果先前已下载过，则从 `PersistencyManager` 中检索 image。
3. 如果尚未下载图像，则使用 `HTTPClient` 检索。
4. 下载完成后，在 imageView 中显示图像，并使用 `PersistencyManager` 将其保存在本地。

再一次的，您使用外观模式隐藏了从其他类下载图像这一复杂的过程。通知发送者并不关心图像是来自网络下载还是来自本地的存储。

编译并运行您的应用程序，现在能看到 collectionView 中漂亮的封面：

![Album app showing cover art but still with spinners](https://koenig-media.raywenderlich.com/uploads/2017/07/CoversAndSpinners-180x320.png)

停止您的应用并再次运行它。请注意加载封面没有延迟，这是因为它们已在本地保存了。您甚至可以断开与互联网的连接，应用程序仍将完美运行。然而这里有一个奇怪的地方，旋转加载的动画永远不会停止！这是怎么回事？

您在下载图像时开始了旋转动画，但是在下载图像后，您并没有实现停止加载动画的逻辑。您 **本来应该** 在每次下载图像时发送通知，但是下面您将使用键值监听（KVO）来执行此操作。

### 键值监听（KVO）

In KVO, an object can ask to be notified of any changes to a specific property; either its own or that of another object. If you're interested, you can read more about this on [Apple's KVO Programming Guide](https://developer.apple.com/library/ios/documentation/Cocoa/Conceptual/KeyValueObserving/KeyValueObserving.html).

### How to Use the KVO Pattern

As mentioned above, the KVO mechanism allows an object to observe changes to a property. In your case, you can use KVO to observe changes to the `image` property of the `UIImageView` that holds the image.

Open **AlbumView.swift** and add the following property just below the `private var indicatorView: UIActivityIndicatorView!` declaration:

```swift
private var valueObservation: NSKeyValueObservation!
```

Now add the following code to `commonInit`, just before you add the cover image view as a subview:

```swift
valueObservation = coverImageView.observe(\.image, options: [.new]) { [unowned self] observed, change in
  if change.newValue is UIImage {
      self.indicatorView.stopAnimating()
  }
}
```

This snippet of code adds the image view as an observer for the `image` property of the cover image. `\.image` is the key path expression that enables this mechanism.

In Swift 4, a key path expression has the following form:

```
\<type>.<property>.<subproperty>
```

The **type** can often be inferred by the compiler, but at least 1 **property** needs to be provided. In some cases, it might make sense to use properties of properties. In your case, the property name, `image` has been specified, while the type name `UIImageView` has been omitted.

The trailing closure specifies the closure that is executed every time an observed property changes. In the above code, you stop the spinner when the `image` property changes. This way, when an image is loaded, the spinner will stop spinning.

Build and run your project. The spinner should disappear:

![How the album app will look when the design patterns tutorial is complete](https://koenig-media.raywenderlich.com/uploads/2017/07/FinalApp-180x320.png)

**Note:** Always remember to remove your observers when they're deinited, or else your app will crash when the subject tries to send messages to these non-existent observers! In this case the `valueObservation` will be deinited when the album view is, so the observing will stop then.

If you play around with your app a bit and terminate it, you'll notice that the state of your app isn't saved. The last album you viewed won't be the default album when the app launches.

To correct this, you can make use of the next pattern on the list: **Memento**.

## The Memento Pattern

The memento pattern captures and externalizes an object's internal state. In other words, it saves your stuff somewhere. Later on, this externalized state can be restored without violating encapsulation; that is, private data remains private.

## How to Use the Memento Pattern

iOS uses the Memento pattern as part of **State Restoration**. You can find out more about it by reading our [tutorial](https://www.raywenderlich.com/117471/state-restoration-tutorial), but essentially it stores and re-applies your application's state so the user is back where they left things.

To activate state restoration in the app, open **Main.storyboard**. Select the **Navigation Controller** and, in the **Identity Inspector**, find the **Restoration ID** field and type **NavigationController**.

Select the **Pop Music** scene and enter **ViewController** for the same field. These IDs tell iOS that you're interested in restoring state for those view controllers when the app restarts.

Add the following code to **AppDelegate.swift**:

```swift
func application(** application: UIApplication, shouldSaveApplicationState coder: NSCoder) -> Bool {
  return true
}

func application(** application: UIApplication, shouldRestoreApplicationState coder: NSCoder) -> Bool {
  return true
}
```

This code turns on state restoration for your app as a whole. Now, add the following code to the `Constants` enum in **ViewController.swift**:

```swift
static let IndexRestorationKey = "currentAlbumIndex"
```

This key will be used to save and restore the current album index. Add the following code:

```swift
override func encodeRestorableState(with coder: NSCoder) {
  coder.encode(currentAlbumIndex, forKey: Constants.IndexRestorationKey)
  super.encodeRestorableState(with: coder)
}

override func decodeRestorableState(with coder: NSCoder) {
  super.decodeRestorableState(with: coder)
  currentAlbumIndex = coder.decodeInteger(forKey: Constants.IndexRestorationKey)
  showDataForAlbum(at: currentAlbumIndex)
  horizontalScrollerView.reload()
}
```

Here you are saving the index (this will happen when your app enters the background) and restoring it (this will happen when the app is launched, after the view of your view controller is loaded). After you restore the index, you update the table and scroller to reflect the updated selection. There's one more thing to be done - you need to move the scroller to the right position. It won't look right if you move the scroller here, because the views haven't yet been laid out. Add the following code to move the scroller at the right point:

```swift
override func viewDidAppear(** animated: Bool) {
  super.viewDidAppear(animated)
  horizontalScrollerView.scrollToView(at: currentAlbumIndex, animated: false)
}
```

Build and run your app. Navigate to one of the albums, send the app to the background with the Home button (**Command+Shift+H** if you are on the simulator) and then shut down your app from Xcode. Relaunch, and check that the previously selected album is the one centered:

![How the album app will look when the design patterns tutorial is complete](https://koenig-media.raywenderlich.com/uploads/2017/07/FinalApp-180x320.png)

If you look at `PersistencyManager`'s `init`, you'll notice the album data is hardcoded and recreated every time `PersistencyManager` is created. But it's better to create the list of albums once and store them in a file. How would you save the `Album` data to a file?

One option is to iterate through `Album`'s properties, save them to a plist file and then recreate the `Album` instances when they're needed. This isn't the best option, as it requires you to write specific code depending on what data/properties are there in each class. For example, if you later created a `Movie` class with different properties, the saving and loading of that data would require new code.

Additionally, you won't be able to save the private variables for each class instance since they are not accessible to an external class. That's exactly why Apple created **archiving and serialization** mechanisms.

### Archiving and Serialization

One of Apple's specialized implementations of the Memento pattern can be achieved through archiving and serialization. Before Swift 4, to serialize and archive your custom types you'd have to jump through a number of steps. For class types you'd need to subclass `NSObject` and conform to `NSCoding` protocol.

Value types like `struct` and `enum` required a sub object that can extend `NSObject` and conform to `NSCoding`.

Swift 4 resolves this issue for all these three types: `class`, `struct` and `enum` [[SE-0166]](https://github.com/apple/swift-evolution/blob/master/proposals/0166-swift-archival-serialization.md).

### How to Use Archiving and Serialization

Open **Album.swift** and declare that `Album` implements `Codable`. This protocol is the only thing required to make a Swift type `Encodable` and `Decodable`. If all properties are `Codable`, the protocol implementation is automatically generated by the compiler.

Now your code should look like this:

```swift
struct Album: Codable {
  let title : String
  let artist : String
  let genre : String
  let coverUrl : String
  let year : String
}
```

To actually encode the object, you'll need to use an encoder. Open **PersistencyManager.swift** and add the following code:

```swift
private var documents: URL {
  return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
}

private enum Filenames {
  static let Albums = "albums.json"
}

func saveAlbums() {
  let url = documents.appendingPathComponent(Filenames.Albums)
  let encoder = JSONEncoder()
  guard let encodedData = try? encoder.encode(albums) else {
    return
  }
  try? encodedData.write(to: url)
}
```

Here, you're defining a URL where you'll save the file (like you did with `caches`), a constant for the filename, then a method which writes your albums out to the file. And you didn't have to write much code!

The other part of the process is decode back the data into a concrete object. You're going to replace that long method where you make the albums and load them from a file instead. Download and unzip [this JSON file](https://koenig-media.raywenderlich.com/uploads/2017/07/albums.json**.zip) and add it to your project.

Now replace `init` in **PersistencyManager.swift** with the following:

```swift
let savedURL = documents.appendingPathComponent(Filenames.Albums)
var data = try? Data(contentsOf: savedURL)
if data == nil, let bundleURL = Bundle.main.url(forResource: Filenames.Albums, withExtension: nil) {
  data = try? Data(contentsOf: bundleURL)
}

if let albumData = data,
  let decodedAlbums = try? JSONDecoder().decode([Album].self, from: albumData) {
  albums = decodedAlbums
  saveAlbums()
}
```

Now, you're loading the album data from the file in the documents directory, if it exists. If it doesn't exist, you load it from the starter file you added earlier, then immediately save it so that it's there in the documents directory next time you launch. `JSONDecoder` is pretty clever - you tell it the type you're expecting the file to contain and it does all the rest of the work for you!

You may also want to save the album data every time the app goes into the background. I'm going to leave this part as a challenge for you to figure out - some of the patterns and techniques you've learned in these two tutorials will come in handy!

## Where to go from here?

You can download the finished project [here](https://koenig-media.raywenderlich.com/uploads/2017/07/RWBlueLibrary-Part2-Final.zip).

In this tutorial you saw how to harness the power of iOS design patterns to perform complicated tasks in a straightforward manner. You've learned a lot of iOS design patterns and concepts: Singleton, MVC, Delegation, Protocols, Facade, Observer, and Memento.

Your final code is loosely coupled, reusable, and readable. If another developer looks at your code, they'll easily be able to understand what's going on and what each class does in your app.

The point isn't to use a design pattern for every line of code you write. Instead, be aware of design patterns when you consider how to solve a particular problem, especially in the early stages of designing your app. They'll make your life as a developer much easier and your code a lot better!

The long-standing classic book on the topic is [Design Patterns: Elements of Reusable Object-Oriented Software](http://www.amazon.com/Design-Patterns-Elements-Reusable-Object-Oriented/dp/0201633612/). For code samples, check out the awesome project [Design Patterns implemented in Swift](https://github.com/ochococo/Design-Patterns-In-Swift) on GitHub for many more design patters coded up in Swift.

Finally, be sure to check out [Intermediate Design Patterns in Swift](http://www.raywenderlich.com/86053/intermediate-design-patterns-in-swift "Intermediate Design Patterns in Swift") and our video course [iOS Design Patterns](https://videos.raywenderlich.com/courses/72-ios-design-patterns/lessons/1) for even more design patterns!

Have more to say or ask about design patterns? Join in on the forum discussion below!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
