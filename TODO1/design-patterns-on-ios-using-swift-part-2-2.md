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

The `reload` method is modeled after `reloadData` in `UITableView`; it reloads all the data used to construct the horizontal scroller.

Stepping through the code comment-by-comment:

1.  Checks to see if there is a data source before we perform any reload.
2.  Since you're clearing the album covers, you also need to remove any existing views.
3.  All the views are positioned starting from the given offset. Currently it's 100, but it can be easily tweaked by changing the constant `ViewConstants.Offset` at the top of the file.
4.  You ask the data source for the number of views and then use this to create the new content views array.
5.  The `HorizontalScrollerView` asks its data source for the views one at a time and it lays them next to each another horizontally with the previously defined padding.
6.  Once all the views are in place, set the content offset for the scroll view to allow the user to scroll through all the albums covers.

You execute `reload` when your data has changed.

The last piece of the `HorizontalScrollerView` puzzle is to make sure the album you're viewing is always centered inside the scroll view. To do this, you'll need to perform some calculations when the user drags the scroll view with their finger.

Add the following method:

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

The above code takes into account the current offset of the scroll view and the dimensions and the padding of the views in order to calculate the distance of the current view from the center. The last line is important: once the view is centered, you then inform the delegate that the selected view has changed.

To detect that the user finished dragging inside the scroll view, you'll need to implement some `UIScrollViewDelegate` methods. Add the following class extension to the bottom of the file; remember, this must be added **after** the curly braces of the main class declaration!

```swift
extension HorizontalScrollerView: UIScrollViewDelegate {
  func scrollViewDidEndDragging(** scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    if !decelerate {
      centerCurrentView()
    }
  }

  func scrollViewDidEndDecelerating(** scrollView: UIScrollView) {
    centerCurrentView()
  }
}
```

`scrollViewDidEndDragging(**:willDecelerate:)` informs the delegate when the user finishes dragging. The `decelerate` parameter is true if the scroll view hasn't come to a complete stop yet. When the scroll action ends, the the system calls `scrollViewDidEndDecelerating(**:)`. In both cases you should call the new method to center the current view since the current view probably has changed after the user dragged the scroll view.

Lastly don't forget to set the delegate. Add the following line to the very beginning of `initializeScrollView()`:

```swift
scroller.delegate = self
```

Your `HorizontalScrollerView` is ready for use! Browse through the code you've just written; you'll see there's not one single mention of the `Album` or `AlbumView` classes. That's excellent, because this means that the new scroller is truly independent and reusable.

Build your project to make sure everything compiles properly.

Now that `HorizontalScrollerView` is complete, it's time to use it in your app. First, open **Main.storyboard**. Click on the top gray rectangular view and click on the **Identity Inspector**. Change the class name to `HorizontalScrollerView` as shown below:

[![](https://koenig-media.raywenderlich.com/uploads/2017/06/design-patterns-part2-scroller-480x270.png)](https://koenig-media.raywenderlich.com/uploads/2017/06/design-patterns-part2-scroller.png)

Next, open the **Assistant Editor** and control drag from the gray rectangular view to **ViewController.swift** to create an outlet. Name the name the outlet **horizontalScrollerView**, as shown below:

[![](https://koenig-media.raywenderlich.com/uploads/2017/06/design-patterns-part2-scroller-outlet-480x270.png)](https://koenig-media.raywenderlich.com/uploads/2017/06/design-patterns-part2-scroller-outlet.png)

Next, open **ViewController.swift**. It's time to start implementing some of the `HorizontalScrollerViewDelegate` methods!

Add the following extension to the bottom of the file:

```swift
extension ViewController: HorizontalScrollerViewDelegate {
  func horizontalScrollerView(** horizontalScrollerView: HorizontalScrollerView, didSelectViewAt index: Int) {
    //1
    let previousAlbumView = horizontalScrollerView.view(at: currentAlbumIndex) as! AlbumView
    previousAlbumView.highlightAlbum(false)
    //2
    currentAlbumIndex = index
    //3
    let albumView = horizontalScrollerView.view(at: currentAlbumIndex) as! AlbumView
    albumView.highlightAlbum(true)
    //4
    showDataForAlbum(at: index)
  }
}
```

This is what happens when this delegate method is invoked:

1.  First you grab the previously selected album, and deselect the album cover.
2.  Store the current album cover index you just clicked
3.  Grab the album cover that is currently selected and highlight the selection.
4.  Display the data for the new album within the table view.

Next, it's time to implement `HorizontalScrollerViewDataSource`. Add the following code at the end of file:

```swift
extension ViewController: HorizontalScrollerViewDataSource {
  func numberOfViews(in horizontalScrollerView: HorizontalScrollerView) -> Int {
    return allAlbums.count
  }

  func horizontalScrollerView(** horizontalScrollerView: HorizontalScrollerView, viewAt index: Int) -> UIView {
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

`numberOfViews(in:)`, as you'll recognize, is the protocol method returning the number of views for the scroll view. Since the scroll view will display covers for all the album data, the count is the number of album records. In `horizontalScrollerView(**:viewAt:)` you create a new `AlbumView`, highlight it if it's the selected album, then pass it to the `HorizontalScrollerView`.

That's it! Only three short methods to display a nice looking horizontal scroller. You now need to connect up the datasource and delegate. Add the following code before `showDataForAlbum(at:)` in `viewDidLoad`:

```swift
horizontalScrollerView.dataSource = self
horizontalScrollerView.delegate = self
horizontalScrollerView.reload()
```

Build and run your project and take a look at your awesome new horizontal scroller:

![Album cover scroller ](https://koenig-media.raywenderlich.com/uploads/2017/07/ScrollerNoImages-180x320.png)

Uh, wait. The horizontal scroller is in place, but where are the covers?

Ah, that's right — you didn't implement the code to download the covers yet. To do that, you'll need to add a way to download images. Since all your access to services goes through `LibraryAPI`, that's where this new method would have to go. However, there are a few things to consider first:

1.  `AlbumView` shouldn't work directly with `LibraryAPI`. You don't want to mix view logic with communication logic.
2.  For the same reason, `LibraryAPI` shouldn't know about `AlbumView`.
3.  `LibraryAPI` needs to inform `AlbumView` once the covers are downloaded since the `AlbumView` has to display the covers.

Sounds like a conundrum? Don't despair, you'll learn how to do this using the **Observer** pattern!

## The Observer Pattern

In the Observer pattern, one object notifies other objects of any state changes. The objects involved don't need to know about one another - thus encouraging a decoupled design. This pattern's most often used to notify interested objects when a property has changed.

The usual implementation requires that an observer registers interest in the state of another object. When the state changes, all the observing objects are notified of the change.

If you want to stick to the MVC concept (hint: you do), you need to allow Model objects to communicate with View objects, but without direct references between them. And that's where the Observer pattern comes in.

Cocoa implements the observer pattern in two ways: **Notifications** and **Key-Value Observing (KVO)**.

### Notifications

Not be be confused with Push or Local notifications, Notifications are based on a subscribe-and-publish model that allows an object (the publisher) to send messages to other objects (subscribers/listeners). The publisher never needs to know anything about the subscribers.

Notifications are heavily used by Apple. For example, when the keyboard is shown/hidden the system sends a `UIKeyboardWillShow`/`UIKeyboardWillHide`, respectively. When your app goes to the background, the system sends a `UIApplicationDidEnterBackground` notification.

### How to Use Notifications

Right click on **RWBlueLibrary** and select **New Group**. Rename it **Extension**. Right click again on that group and select **New File...**. Select **iOS > Swift File** and set the file name to **NotificationExtension.swift**.

Copy the following code inside the file:

```swift
extension Notification.Name {
  static let BLDownloadImage = Notification.Name("BLDownloadImageNotification")
}
```

You are extending `Notification.Name` with your custom notification. From now on, the new notification can be accessed as `.BLDownloadImage`, just as you would a system notification.

Go to **AlbumView.swift** and insert the following code to the end of the `init(frame:coverUrl:)` method:

```swift
NotificationCenter.default.post(name: .BLDownloadImage, object: self, userInfo: ["imageView": coverImageView, "coverUrl" : coverUrl])
```

This line sends a notification through the `NotificationCenter` singleton. The notification info contains the `UIImageView` to populate and the URL of the cover image to be downloaded. That's all the information you need to perform the cover download task.

Add the following line to `init` in **LibraryAPI.swift**, as the implementation of the currently empty `init`:

```swift
NotificationCenter.default.addObserver(self, selector: #selector(downloadImage(with:)), name: .BLDownloadImage, object: nil)
```

This is the other side of the equation: the observer. Every time an `AlbumView` posts a `BLDownloadImage` notification, since `LibraryAPI` has registered as an observer for the same notification, the system notifies `LibraryAPI`. Then `LibraryAPI` calls `downloadImage(with:)` in response.

Before you implement `downloadImage(with:)` there's one more thing to do. It would probably be a good idea to save the downloaded covers locally so the app won't need to download the same covers over and over again.

Open **PersistencyManager.swift**. After the `import Foundation`, add the following line:

```swift
import UIKit
```

This import is important because you will deal with `UI` objects, like `UIImage`.

Add this computed property to the end of the class:

```swift
private var cache: URL {
  return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
}
```

This variable returns the URL of the cache directory, which is a good place to store files that you can re-download at any time.

Now add these two methods:

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

This code is pretty straightforward. The downloaded images will be saved in the Cache directory, and `getImage(with:)` will return `nil` if a matching file is not found in the Cache directory.

Now open **LibraryAPI.swift** and add `import UIKit` after the first available import.

At the end of the class add the following method:

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

Here's a breakdown of the above code:

1.  `downloadImage` is executed via notifications and so the method receives the notification object as a parameter. The `UIImageView` and image URL are retrieved from the notification.
2.  Retrieve the image from the `PersistencyManager` if it's been downloaded previously.
3.  If the image hasn't already been downloaded, then retrieve it using `HTTPClient`.
4.  When the download is complete, display the image in the image view and use the `PersistencyManager` to save it locally.

Again, you're using the Facade pattern to hide the complexity of downloading an image from the other classes. The notification sender doesn't care if the image came from the web or from the file system.

Build and run your app and check out the beautiful covers inside your collection view:

![Album app showing cover art but still with spinners](https://koenig-media.raywenderlich.com/uploads/2017/07/CoversAndSpinners-180x320.png)

Stop your app and run it again. Notice that there's no delay in loading the covers because they've been saved locally. You can even disconnect from the Internet and your app will work flawlessly. However, there's one odd bit here: the spinner never stops spinning! What's going on?

You started the spinner when downloading the image, but you haven't implemented the logic to stop the spinner once the image is downloaded. You **could** send out a notification every time an image has been downloaded, but instead, you'll do that using the other Observer pattern, KVO.

### Key-Value Observing (KVO)

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
