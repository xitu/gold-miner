> * 原文地址：[Design Patterns on iOS using Swift – Part 2/2](https://www.raywenderlich.com/476-design-patterns-on-ios-using-swift-part-2-2)
> * 原文作者：[Lorenzo Boaro](https://www.raywenderlich.com/u/lorenzoboaro)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/design-patterns-on-ios-using-swift-part-2-2.md](https://github.com/xitu/gold-miner/blob/master/TODO1/design-patterns-on-ios-using-swift-part-2-2.md)
> * 译者：
> * 校对者：

# Design Patterns on iOS using Swift – Part 2/2

Learn about common design patterns when building iOS apps, and how you can apply these patterns in your own apps, in this 2-part tutorial.

> **Update note**: This tutorial was updated for iOS 11, Xcode 9 and Swift 4 by Lorenzo Boaro. Original post by Tutorial team member Eli Ganem.

Welcome back to part two of this introductory tutorial on design patterns on iOS! In [the first part](http://www.raywenderlich.com/86477/introducing-ios-design-patterns-in-swift-part-1), you learned about some fundamental patterns in Cocoa such as MVC, singletons, and decorator.

In this final part, you’ll learn about the other basic design patterns that come up a lot in iOS and OS X development: adapter, observer, and memento. Let’s get right into it!

## Getting Started

You can download [the project source from the end of part 1](https://koenig-media.raywenderlich.com/uploads/2017/07/RWBlueLibrary-Part1-Final.zip) to get started.

Here’s where you left off the sample music library app at the end of the first part:

![Album app showing populated table view](https://koenig-media.raywenderlich.com/uploads/2017/07/appwithtableviewpopulated-180x320.png)

The original plan for the app included a horizontal scroller at the top of the screen to switch between albums. Instead of coding a single-purpose horizontal scroller, why not make it reusable for any view?

To make this view reusable, all decisions about its content should be left to other two objects: a data source and a delegate. The horizontal scroller should declare methods that its data source and delegate implement in order to work with the scroller, similar to how the `UITableView` delegate methods work. You’ll implement this when we discuss the next design pattern.

## The Adapter Pattern

An Adapter allows classes with incompatible interfaces to work together. It wraps itself around an object and exposes a standard interface to interact with that object.

If you’re familiar with the Adapter pattern then you’ll notice that Apple implements it in a slightly different manner – Apple uses protocols to do the job. You may be familiar with protocols like `UITableViewDelegate`, `UIScrollViewDelegate`, `NSCoding` and `NSCopying`. As an example, with the `NSCopying` protocol, any class can provide a standard `copy` method.

## How to Use the Adapter Pattern

The horizontal scroller mentioned before will look like this:

[![swiftDesignPattern7](https://koenig-media.raywenderlich.com/uploads/2014/11/swiftDesignPattern7-480x153.png)](https://koenig-media.raywenderlich.com/uploads/2014/11/swiftDesignPattern7.png)

To begin implementing it, right click on the View group in the Project Navigator, select _New File…_ and select, _iOS > Cocoa Touch class_ and then click _Next_. Set the class name to `HorizontalScrollerView` and make it a subclass of `UIView`.

Open _HorizontalScrollerView.swift_ and insert the following code _above_ the class `HorizontalScroller` line:

```
protocol HorizontalScrollerViewDataSource: class {
  // Ask the data source how many views it wants to present inside the horizontal scroller
  func numberOfViews(in horizontalScrollerView: HorizontalScrollerView) -> Int
  // Ask the data source to return the view that should appear at <index>
  func horizontalScrollerView(_ horizontalScrollerView: HorizontalScrollerView, viewAt index: Int) -> UIView
}
```

This defines a protocol named `HorizontalScrollerViewDataSource` that performs two operations: it asks for the number of views to display inside the horizontal scroller and the view that should appear for a specific index.

Just below this protocol definition add another protocol named `HorizontalScrollerViewDelegate`.

```
protocol HorizontalScrollerViewDelegate: class {
  // inform the delegate that the view at <index> has been selected
  func horizontalScrollerView(_ horizontalScrollerView: HorizontalScrollerView, didSelectViewAt index: Int)
}
```

This will let the horizontal scroller inform some other object that a view has been selected.

_Note:_ Dividing areas of concern into separate protocols makes things a lot more clear. In this way you can decide to conform to specific protocols and avoid using the `@objc` marker to declare optional methods.

In _HorizontalScrollerView.swift_, add the following code to the `HorizontalScrollerView` class definition:

```
weak var dataSource: HorizontalScrollerViewDataSource?
weak var delegate: HorizontalScrollerViewDelegate?
```

The delegate and data source are optionals, so you don’t have to provide them, but any object that you do set here must conform to the appropriate protocol.

Add some more code to the class:

```
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

Taking each comment block in turn:

1.  Define a private `enum` to make it easy to modify the layout at design time. The view’s dimensions inside the scroller will be 100 x 100 with a 10 point margin from its enclosing rectangle.
2.  Create the scroll view containing the views.
3.  Create an array that holds all the album covers.

Next you need to implement the initializers. Add the following methods:

```
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

The work is done in `initializeScrollView()`. Here’s what’s going on in that method:

1.  Adds the `UIScrollView` instance to the parent view.
2.  Turn off autoresizing masks. This is so you can apply your own constraints
3.  Apply constraints to the scrollview. You want the scroll view to completely fill the `HorizontalScrollerView`
4.  Create a tap gesture recognizer. The tap gesture recognizer detects touches on the scroll view and checks if an album cover has been tapped. If so, it will notify the `HorizontalScrollerView` delegate. You’ll have a compiler error here because the tap method isn’t implemented yet, you’ll be doing that shortly.

Now add this method:

```
func scrollToView(at index: Int, animated: Bool = true) {
  let centralView = contentViews[index]
  let targetCenter = centralView.center
  let targetOffsetX = targetCenter.x - (scroller.bounds.width / 2)
  scroller.setContentOffset(CGPoint(x: targetOffsetX, y: 0), animated: animated)
}
```

This method retrieves the view for a specific index and centers it. It is used by the following method (add this to the class as well):

```
@objc func scrollerTapped(gesture: UITapGestureRecognizer) {
  let location = gesture.location(in: scroller)
  guard
    let index = contentViews.index(where: { $0.frame.contains(location)})
    else { return }
  
  delegate?.horizontalScrollerView(self, didSelectViewAt: index)
  scrollToView(at: index)
}
```

This method finds the location of the tap in the scroll view, then the index of the first content view that contains that location, if any.

If a content view was hit, the delegate is informed and the view is scrolled to the center.

Next add the following to access an album cover from the scroller:

```
func view(at index :Int) -> UIView {
  return contentViews[index]
}
```

`view(at:)` simply returns the view at a particular index. You will be using this method later to highlight the album cover you have tapped on.

Now add the following code to reload the scroller:

```
func reload() {
  // 1 - Check if there is a data source, if not there is nothing to load.
  guard let dataSource = dataSource else {
    return
  }
  
  //2 - Remove the old content views
  contentViews.forEach { $0.removeFromSuperview() }
  
  // 3 - xValue is the starting point of each view inside the scroller
  var xValue = ViewConstants.Offset
  // 4 - Fetch and add the new views
  contentViews = (0..<dataSource.numberOfViews(in: self)).map {
    index in
    // 5 - add a view at the right position
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

```
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

To detect that the user finished dragging inside the scroll view, you'll need to implement some `UIScrollViewDelegate` methods. Add the following class extension to the bottom of the file; remember, this must be added _after_ the curly braces of the main class declaration!

```
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

`scrollViewDidEndDragging(_:willDecelerate:)` informs the delegate when the user finishes dragging. The `decelerate` parameter is true if the scroll view hasn't come to a complete stop yet. When the scroll action ends, the the system calls `scrollViewDidEndDecelerating(_:)`. In both cases you should call the new method to center the current view since the current view probably has changed after the user dragged the scroll view.

Lastly don't forget to set the delegate. Add the following line to the very beginning of `initializeScrollView()`:

```
scroller.delegate = self
```

Your `HorizontalScrollerView` is ready for use! Browse through the code you've just written; you'll see there's not one single mention of the `Album` or `AlbumView` classes. That's excellent, because this means that the new scroller is truly independent and reusable.

Build your project to make sure everything compiles properly.

Now that `HorizontalScrollerView` is complete, it's time to use it in your app. First, open _Main.storyboard_. Click on the top gray rectangular view and click on the _Identity Inspector_. Change the class name to `HorizontalScrollerView` as shown below:

[![](https://koenig-media.raywenderlich.com/uploads/2017/06/design-patterns-part2-scroller-480x270.png)](https://koenig-media.raywenderlich.com/uploads/2017/06/design-patterns-part2-scroller.png)

Next, open the _Assistant Editor_ and control drag from the gray rectangular view to _ViewController.swift_ to create an outlet. Name the name the outlet _horizontalScrollerView_, as shown below:

[![](https://koenig-media.raywenderlich.com/uploads/2017/06/design-patterns-part2-scroller-outlet-480x270.png)](https://koenig-media.raywenderlich.com/uploads/2017/06/design-patterns-part2-scroller-outlet.png)

Next, open _ViewController.swift_. It's time to start implementing some of the `HorizontalScrollerViewDelegate` methods!

Add the following extension to the bottom of the file:

```
extension ViewController: HorizontalScrollerViewDelegate {
  func horizontalScrollerView(_ horizontalScrollerView: HorizontalScrollerView, didSelectViewAt index: Int) {
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

```
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

`numberOfViews(in:)`, as you'll recognize, is the protocol method returning the number of views for the scroll view. Since the scroll view will display covers for all the album data, the count is the number of album records. In `horizontalScrollerView(_:viewAt:)` you create a new `AlbumView`, highlight it if it's the selected album, then pass it to the `HorizontalScrollerView`.

That's it! Only three short methods to display a nice looking horizontal scroller. You now need to connect up the datasource and delegate. Add the following code before `showDataForAlbum(at:)` in `viewDidLoad`:

```
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

Sounds like a conundrum? Don't despair, you'll learn how to do this using the _Observer_ pattern!

## The Observer Pattern

In the Observer pattern, one object notifies other objects of any state changes. The objects involved don't need to know about one another - thus encouraging a decoupled design. This pattern's most often used to notify interested objects when a property has changed.

The usual implementation requires that an observer registers interest in the state of another object. When the state changes, all the observing objects are notified of the change.

If you want to stick to the MVC concept (hint: you do), you need to allow Model objects to communicate with View objects, but without direct references between them. And that's where the Observer pattern comes in.

Cocoa implements the observer pattern in two ways: _Notifications_ and _Key-Value Observing (KVO)_.

### Notifications

Not be be confused with Push or Local notifications, Notifications are based on a subscribe-and-publish model that allows an object (the publisher) to send messages to other objects (subscribers/listeners). The publisher never needs to know anything about the subscribers.

Notifications are heavily used by Apple. For example, when the keyboard is shown/hidden the system sends a `UIKeyboardWillShow`/`UIKeyboardWillHide`, respectively. When your app goes to the background, the system sends a `UIApplicationDidEnterBackground` notification.

### How to Use Notifications

Right click on _RWBlueLibrary_ and select _New Group_. Rename it _Extension_. Right click again on that group and select _New File..._. Select _iOS > Swift File_ and set the file name to _NotificationExtension.swift_.

Copy the following code inside the file:

```
extension Notification.Name {
  static let BLDownloadImage = Notification.Name("BLDownloadImageNotification")
}
```

You are extending `Notification.Name` with your custom notification. From now on, the new notification can be accessed as `.BLDownloadImage`, just as you would a system notification.

Go to _AlbumView.swift_ and insert the following code to the end of the `init(frame:coverUrl:)` method:

```
NotificationCenter.default.post(name: .BLDownloadImage, object: self, userInfo: ["imageView": coverImageView, "coverUrl" : coverUrl])
```

This line sends a notification through the `NotificationCenter` singleton. The notification info contains the `UIImageView` to populate and the URL of the cover image to be downloaded. That's all the information you need to perform the cover download task.

Add the following line to `init` in _LibraryAPI.swift_, as the implementation of the currently empty `init`:

```
NotificationCenter.default.addObserver(self, selector: #selector(downloadImage(with:)), name: .BLDownloadImage, object: nil)
```

This is the other side of the equation: the observer. Every time an `AlbumView` posts a `BLDownloadImage` notification, since `LibraryAPI` has registered as an observer for the same notification, the system notifies `LibraryAPI`. Then `LibraryAPI` calls `downloadImage(with:)` in response.

Before you implement `downloadImage(with:)` there's one more thing to do. It would probably be a good idea to save the downloaded covers locally so the app won't need to download the same covers over and over again.

Open _PersistencyManager.swift_. After the `import Foundation`, add the following line:

```
import UIKit
```

This import is important because you will deal with `UI` objects, like `UIImage`.

Add this computed property to the end of the class:

```
private var cache: URL {
  return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
}
```

This variable returns the URL of the cache directory, which is a good place to store files that you can re-download at any time.

Now add these two methods:

```
func saveImage(_ image: UIImage, filename: String) {
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

Now open _LibraryAPI.swift_ and add `import UIKit` after the first available import.

At the end of the class add the following method:

```
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

You started the spinner when downloading the image, but you haven't implemented the logic to stop the spinner once the image is downloaded. You _could_ send out a notification every time an image has been downloaded, but instead, you'll do that using the other Observer pattern, KVO.

### Key-Value Observing (KVO)

In KVO, an object can ask to be notified of any changes to a specific property; either its own or that of another object. If you're interested, you can read more about this on [Apple's KVO Programming Guide](https://developer.apple.com/library/ios/documentation/Cocoa/Conceptual/KeyValueObserving/KeyValueObserving.html).

### How to Use the KVO Pattern

As mentioned above, the KVO mechanism allows an object to observe changes to a property. In your case, you can use KVO to observe changes to the `image` property of the `UIImageView` that holds the image.

Open _AlbumView.swift_ and add the following property just below the `private var indicatorView: UIActivityIndicatorView!` declaration:

```
private var valueObservation: NSKeyValueObservation!
```

Now add the following code to `commonInit`, just before you add the cover image view as a subview:

```
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

The _type_ can often be inferred by the compiler, but at least 1 _property_ needs to be provided. In some cases, it might make sense to use properties of properties. In your case, the property name, `image` has been specified, while the type name `UIImageView` has been omitted.

The trailing closure specifies the closure that is executed every time an observed property changes. In the above code, you stop the spinner when the `image` property changes. This way, when an image is loaded, the spinner will stop spinning.

Build and run your project. The spinner should disappear:

![How the album app will look when the design patterns tutorial is complete](https://koenig-media.raywenderlich.com/uploads/2017/07/FinalApp-180x320.png)

_Note:_ Always remember to remove your observers when they're deinited, or else your app will crash when the subject tries to send messages to these non-existent observers! In this case the `valueObservation` will be deinited when the album view is, so the observing will stop then.

If you play around with your app a bit and terminate it, you'll notice that the state of your app isn't saved. The last album you viewed won't be the default album when the app launches.

To correct this, you can make use of the next pattern on the list: _Memento_.

## The Memento Pattern

The memento pattern captures and externalizes an object's internal state. In other words, it saves your stuff somewhere. Later on, this externalized state can be restored without violating encapsulation; that is, private data remains private.

## How to Use the Memento Pattern

iOS uses the Memento pattern as part of _State Restoration_. You can find out more about it by reading our [tutorial](https://www.raywenderlich.com/117471/state-restoration-tutorial), but essentially it stores and re-applies your application's state so the user is back where they left things.

To activate state restoration in the app, open _Main.storyboard_. Select the _Navigation Controller_ and, in the _Identity Inspector_, find the _Restoration ID_ field and type _NavigationController_.

Select the _Pop Music_ scene and enter _ViewController_ for the same field. These IDs tell iOS that you're interested in restoring state for those view controllers when the app restarts.

Add the following code to _AppDelegate.swift_:

```
func application(_ application: UIApplication, shouldSaveApplicationState coder: NSCoder) -> Bool {
  return true
}

func application(_ application: UIApplication, shouldRestoreApplicationState coder: NSCoder) -> Bool {
  return true
}
```

This code turns on state restoration for your app as a whole. Now, add the following code to the `Constants` enum in _ViewController.swift_:

```
static let IndexRestorationKey = "currentAlbumIndex"
```

This key will be used to save and restore the current album index. Add the following code:

```
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

```
override func viewDidAppear(_ animated: Bool) {
  super.viewDidAppear(animated)
  horizontalScrollerView.scrollToView(at: currentAlbumIndex, animated: false)
}
```

Build and run your app. Navigate to one of the albums, send the app to the background with the Home button (_Command+Shift+H_ if you are on the simulator) and then shut down your app from Xcode. Relaunch, and check that the previously selected album is the one centered:

![How the album app will look when the design patterns tutorial is complete](https://koenig-media.raywenderlich.com/uploads/2017/07/FinalApp-180x320.png)

If you look at `PersistencyManager`'s `init`, you'll notice the album data is hardcoded and recreated every time `PersistencyManager` is created. But it's better to create the list of albums once and store them in a file. How would you save the `Album` data to a file?

One option is to iterate through `Album`'s properties, save them to a plist file and then recreate the `Album` instances when they're needed. This isn't the best option, as it requires you to write specific code depending on what data/properties are there in each class. For example, if you later created a `Movie` class with different properties, the saving and loading of that data would require new code.

Additionally, you won't be able to save the private variables for each class instance since they are not accessible to an external class. That's exactly why Apple created _archiving and serialization_ mechanisms.

### Archiving and Serialization

One of Apple's specialized implementations of the Memento pattern can be achieved through archiving and serialization. Before Swift 4, to serialize and archive your custom types you'd have to jump through a number of steps. For class types you'd need to subclass `NSObject` and conform to `NSCoding` protocol.

Value types like `struct` and `enum` required a sub object that can extend `NSObject` and conform to `NSCoding`.

Swift 4 resolves this issue for all these three types: `class`, `struct` and `enum` [[SE-0166]](https://github.com/apple/swift-evolution/blob/master/proposals/0166-swift-archival-serialization.md).

### How to Use Archiving and Serialization

Open _Album.swift_ and declare that `Album` implements `Codable`. This protocol is the only thing required to make a Swift type `Encodable` and `Decodable`. If all properties are `Codable`, the protocol implementation is automatically generated by the compiler.

Now your code should look like this:

```
struct Album: Codable {
  let title : String
  let artist : String
  let genre : String
  let coverUrl : String
  let year : String
}
```

To actually encode the object, you'll need to use an encoder. Open _PersistencyManager.swift_ and add the following code:

```
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

The other part of the process is decode back the data into a concrete object. You're going to replace that long method where you make the albums and load them from a file instead. Download and unzip [this JSON file](https://koenig-media.raywenderlich.com/uploads/2017/07/albums.json_.zip) and add it to your project.

Now replace `init` in _PersistencyManager.swift_ with the following:

```
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
