>* 原文链接 : [UIScrollView Tutorial: Getting Started](https://www.raywenderlich.com/122139/uiscrollview-tutorial)
>* 原文作者 : [Corinne Krych](https://www.raywenderlich.com/u/ckrych)
>* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
>* 译者 : [Zhongyi Tong (geeeeeeeeek)](https://github.com/geeeeeeeeek)
>* 校对者: [Tuccuay](https://github.com/Tuccuay)


# UIScrollView新手教程

__Ray的温馨提示__：这是本站原先Objective-C热门教程的Swift升级版。Corinne Krych将教程升级到了Swift, iOS 9和Xcode 7.1.1；[原文](https://www.raywenderlich.com/?p=10518)由教程团队成员[Matt Galloway](http://www.raywenderlich.com/u/mattjgalloway)编写。阅读愉快！

`UIScrollView`是iOS中最灵活和有用的控件之一。它是十分流行的`UITableView`控件的基础，能够友好地展示超过一屏的内容。在这份`UIScrollView`教程中，通过构建一个类似自带的「照片」应用，你将会掌握以下内容：

*   如何使用`UIScrollView`来缩放视图，查看大图
*   如何在缩放时保持`UIScrollView`的内容居中
*   如何在自动布局时使用`UIScrollView`进行竖直滚动
*   如何在键盘呼出时保持文本输入控件可见
*   如何和`UIPageControl`一起使用`UIPageViewController`，实现内容多页连播

这份教程假定你会使用Interface Builder给一个视图添加新的对象，连接你的代码和StoryBoard。在开始之前你需要熟悉Storyboard，所以如果你没有接触过的话，一定要看一下我们的[Storyboard教程(然而并没有翻译)](https://www.raywenderlich.com/?p=5138)。

## 准备开始

点击[这里](http://www.raywenderlich.com/wp-content/uploads/2016/01/PhotoScroll_Starter.zip)下载这份`UIScrollView`的初始项目，然后在Xcode中打开。

编译并运行，看看我们最初的项目：

![uiscrollview tutorial](http://www.raywenderlich.com/wp-content/uploads/2015/12/starter1.gif)

选中图片时，你看到它变成了全屏。但遗憾的是，图片被裁剪了。由于设备尺寸的限制，你无法看到整张图片。你真正想要的是让图片默认适应设备的屏幕，并且能够放大观察细节，就像在Photos应用中一样。

你能解决吗？当然了！

## 大图滚动和缩放

这份`UIScrollView`教程教给你的第一件事是，如何设置一个滚动视图，允许用户缩放、移动图片。

首先，你需要添加一个滚动视图。打开__Main.storyboard__，从__Object Library__拖动一个__Scroll View__，放到__Zoomed Photo View Controller Scene__视图下的Document Outline。将__Image View__移动到你新建的__Scroll View__中。你的Document Outline现在应该是这样的：

![](http://ww4.sinaimg.cn/large/005SiNxygw1f1ysxw8ed9j30jg09etbj.jpg)![](http://www.raywenderlich.com/wp-content/uploads/2016/01/Screen-Shot-2016-01-05-at-8.42.59-PM.png)

看到红点了么？Xcode正在提示你有一些自动布局的规则没有被正确地定义。为了解决这个问题，选中你的__Scroll View__，点击Storyboard窗口底部的锁定按钮。添加四个新的约束：顶部、底部、前后间距。取消选中__Constrain to margins__，将所有的约束值都设为0。

![](http://ww1.sinaimg.cn/large/005SiNxygw1f1yswkubkaj30fj0dwmyl.jpg)

接下来选中__Image View__并添加相同约束。

选中Document Outline中的__Zoomed Photo View Controller__来消除自动布局的警告，然后选择Editor(编辑器)\Resolve Auto Layout Issues(解决约束问题)\Update Frames(更新控件位置)。

最后，在__Zoomed Photo View Controller__的Attribute Inspector中取消选中__Adjust Scroll View Insets__。

编译并运行。

![uiscrollview tutorial](http://www.raywenderlich.com/wp-content/uploads/2015/12/starter2.gif)

多亏了滚动视图，你现在可以滑动查看原尺寸的图片了。但如果你希望图片大小适应屏幕呢？或者如果你希望放大或缩小图片呢？

准备好开始写代码了吗？

打开__ZoomedPhotoViewController.swift__，在类声明中，添加下面的outlet属性：

```swift
@IBOutlet weak var scrollView: UIScrollView!
@IBOutlet weak var imageViewBottomConstraint: NSLayoutConstraint!
@IBOutlet weak var imageViewLeadingConstraint: NSLayoutConstraint!
@IBOutlet weak var imageViewTopConstraint: NSLayoutConstraint!
@IBOutlet weak var imageViewTrailingConstraint: NSLayoutConstraint!
```

回到__Main.storyboard__，为了将__Scroll View__和__Zoomed View Controller__协同工作，我们需要将它添加到`scrollView` outlet，将__Zoomed View Controller__设置为__Scroll View__的代理。同样地，将__Zoomed View Controller__中新的约束outlet连接到__Document Outline__中相应的约束，就像这样：

![](http://ww1.sinaimg.cn/large/005SiNxygw1f1yt7ib5j1j30jg09etbj.jpg)![](http://www.raywenderlich.com/wp-content/uploads/2016/01/Screen-Shot-2016-01-05-at-8.53.38-PM.png)

现在，你要开始接触到代码。在__ZoomedPhotoViewController.swift__中，将`UIScrollViewDelegate`方法的实现添加为扩展：

```swift
extension ZoomedPhotoViewController: UIScrollViewDelegate {
  func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
    return imageView
  }
}
```

这就是滚动视图缩放原理的关键。你告诉它捏住滚动的视图时，哪个视图应该变大或变小。在这里，就是你的`imageView`。

现在，将`updateMinZoomScaleForSize(_:)`的实现添加到`ZoomedPhotoViewController`类：

```swift
private func updateMinZoomScaleForSize(size: CGSize) {
  let widthScale = size.width / imageView.bounds.width
  let heightScale = size.height / imageView.bounds.height
  let minScale = min(widthScale, heightScale)  

  scrollView.minimumZoomScale = minScale

  scrollView.zoomScale = minScale
}
```

你需要确定滚动视图的最小缩放比例。缩放比例的意思是内容以正常大小显示的比例。小于这个比例内容会被缩小，大于这个比例内容会被放大。为了确定最小缩放比例，你要计算图片的宽度需要缩小多少才能紧紧地贴合在滚动视图的边界上。然后对图片的高度做同样的事。这两者中更小的比例就是滚动视图的最小缩放比例。按这个比例缩小之后你可以看到整张图片。注意最大缩放比例默认为1。你不用修改这个比例，因为放大到超过了图片的分辨率会使图片看上去模糊。

你可以将初始的缩放比例设为最小缩放比例，这样图像一开始就是完全缩小到适应屏幕的。

最后，每次控制器更新子视图时更新最小缩放比例：

```swift
override func viewDidLayoutSubviews() {
  super.viewDidLayoutSubviews()

  updateMinZoomScaleForSize(view.bounds.size)
}
```

编译并运行。你可以看到下面的结果：

![uiscrollview tutorial](http://www.raywenderlich.com/wp-content/uploads/2015/12/starter3.gif)

手机竖放时图片填充了整个屏幕。你可以缩放图片，但还有一些小问题：

*   图片被固定在视图顶部。如果能够居中就更好了。
*   如果你将手机将手机水平过来，你的视图不会重新计算尺寸。

还是在__ZoomedPhotoViewController.swift__中，实现`updateConstraintsForSize(size:)`函数来解决这些问题：

```swift
private func updateConstraintsForSize(size: CGSize) {   

  let yOffset = max(0, (size.height - imageView.frame.height) / 2)
  imageViewTopConstraint.constant = yOffset
  imageViewBottomConstraint.constant = yOffset

  let xOffset = max(0, (size.width - imageView.frame.width) / 2)
  imageViewLeadingConstraint.constant = xOffset
  imageViewTrailingConstraint.constant = xOffset

  view.layoutIfNeeded()
}
```

这个方法解决了`UIScrollView`一个烦人的现象：如果滚动视图的内容尺寸小于视图边界，它会被固定在左上角而不是正中间。由于你允许用户随意缩放，如果图片能放置在视图中央就更好了。这个函数通过修改布局约束实现了这个特性。

用 `view` 的高度减去 `imageView`的高度除以二可以得到整个屏幕的垂直中心，你将可以用它来确定 `imageView`的顶部和底部约束。

类似地，你可以计算`imageView`左右间距的偏移量。

在`UIScrollViewDelegate`扩展中，添加`scrollViewDidZoom(_:)`的实现：

```swift
func scrollViewDidZoom(scrollView: UIScrollView) {
  updateConstraintsForSize(view.bounds.size)
}
```

在这个函数中，每当用户滚动时都会重新居中视图——不然的话，缩放看上去不会那么自然，而是被固定在了左上角。

现在，深呼吸，放轻松，编译并运行你的项目！按下一张图片，如果一切顺利的话，你可以对它双指缩放、单指拖拽和点按缩放 :]

![uiscrollview tutorial](http://www.raywenderlich.com/wp-content/uploads/2015/12/starter4.gif)

## 竖直滚动

假设你想要改变一下PhotoScroll，在顶部显示图像，在下面添加评论区。取决于评论有多长，文字可能会超过设备的显示区域：让滚动视图来拯救你吧！

__注意__：一般来说，自动布局将视图的上下左右边界作为可视边界。但是，`UIScrollView`通过修改边界区域来滚动内容。为了和自动布局一起使用，滚动视图的边界事实上指的是内容视图的边界。

为了在自动布局中设置滚动视图的边框大小，要么根据滚动视图的宽高显式指定约束，要么滚动视图边界必须贴合自身子树外侧的视图。

你可以在Apple的[技术说明](https://developer.apple.com/library/ios/technotes/tn2154/_index.html)中了解更多。

你会在实践中学到，如果使用Storyboard的自动布局来修复滚动视图的宽度，或是内容的真实宽度。

### 滚动视图和自动布局

打开__Main.storyboard__，新建一个场景：

首先，添加一个新的__View Controller__。在Size Inspector中，将__Simulated Size__的__Fixed__替换为__Freeform__，并输入宽度340、高度800。你会注意到控制器的布局变得更窄更长了，模拟长条形的竖直内容的行为。模拟尺寸帮助你在Interface Builder中可视化显示效果。它不会影响运行时的效果。

在新建的视图控制器中的Attribute Inspector中取消选中__Adjust Scroll View Insets__。

添加一个滚动视图，填充整个视图控制器的空间。在视图管理器中添加首尾约束为常数0（确认取消选中了__Constrain to margin__）。将__Scroll View__中的顶部和底部约束分别添加到顶部和底部布局向导。它们的值应该也是常数0。

添加一个__Scroll View__的子视图，填充__Scroll View__所有的空间。将它的Storyboard__Label__重命名为__Container View__。和以前一样，添加顶部、底部、前后约束。

为了定义滚动视图的大小，并修复自动布局的错误，你需要定义它的内容大小。定义__Container View__的宽度贴合视图控制器。将__View Controller__主视图的宽度约束设置与__Container View__一致。将__Container View__的高度约束设置为500。

__注意__：自动布局的规则必须完备地定义滚动视图的`contentSize`。这是在自动布局下让滚动视图正确显示大小的关键一步。

在__Container View__内添加一个__Image View__。在Attribute Inspector中：将图像指定为__photo1__，选择__Aspect Fit__模式，选中__Clip Subviews__。像之前一样给Container View添加顶部、首尾约束。为图片视图添加高度约束为300。

在__Container View__中的图片下方添加一个__Label__。指定文字为“__What name fits me best?__”。在__Container View__中添加一个水平居中的宽度约束。添加与__Photo View__的竖直间距约束为0。

在__Container View__内新建的标签下方添加一个__Text Field__。在__Container View__中添加值为8的首尾约束，无外边距。添加与标签的竖直间距约束为30。

最后，通过联线(segue)连接新建的视图控制器和另一个屏幕。移除已有的__Photo Scroll__场景和__Zoomed Photo View Controller__场景之间的push联线。不要担心，你在__Zoomed Photo View Controller__中所做的会在后面加回到应用中。

在__Photo Scroll__场景中，将__PhotoCell__拖到视图控制器中，添加一个__show__联线. 命名为__showPhotoPage__。

编译并运行。

![](http://ww2.sinaimg.cn/large/005SiNxygw1f1yt3f7egoj307n0dwwfc.jpg)

你可以看到布局在竖直方向是正确的。试着将手机水平旋转。在水平模式下，没有足够的竖直空间来显示所有内容，尽管滚动视图使你能够滚动查看标签和文本框。不幸的是，因为新的视图控制器中的图片被写死在代码里，显示的并不是你在合辑视图中选中的那张图片。

为了修复这个问题，你需要在联线被执行时将图片传送到视图控制器。因此，创建一个新的文件，使用__iOS\Source\Cocoa Touch Class__模板。将类命名为__PhotoCommentViewController__，将子类设置为__UIViewController__。确认语言设为了__Swift__。点击下一步，保存以备后用。

用下面的代码更新__PhotoCommentViewController.swift__：

```swift
import UIKit

public class PhotoCommentViewController: UIViewController {  
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var nameTextField: UITextField!
  public var photoName: String!

  override public func viewDidLoad() {
    super.viewDidLoad()
    if let photoName = photoName {
      self.imageView.image = UIImage(named: photoName)
    }
  }
}
```

更新后的`PhotoCommentViewController`实现添加了`IBOutlet`，并根据`photoName`设置`imageView`的图片。

回到Storyboard，打开__View Controller__中的__Identity Inspector__，将__Class__设置为__PhotoCommentViewController__。打开__Connections Inspector__，连接`PhotoCommentViewController`中滚动视图、图像、文本框的__IBOutlet__。

打开__CollectionViewController.swift__，将`prepareForSegue(_:sender:)`替换为下面的代码：

```swift
override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
  if let cell = sender as? UICollectionViewCell,
      indexPath = collectionView?.indexPathForCell(cell),
      photoCommentViewController = segue.destinationViewController as? PhotoCommentViewController {
    photoCommentViewController.photoName = "photo\(indexPath.row + 1)"
  }
}
```

当你轻按一张图片时，这张图片的名称会被显示在`PhotoCommentViewController`。

编译并运行。

![](http://ww3.sinaimg.cn/large/005SiNxygw1f1yszwdwhrj307n0dwaay.jpg)

内容优雅地显示在了视图中，必要时允许你向下滚动查看更多内容。你会注意到键盘带来的两个问题：首先，输入文字时，键盘遮住了文本框。其次，键盘无法隐藏。怎么办呢？

### 键盘

__键盘偏移量__

和使用`UITableViewController`不同，前者会将内容移出屏幕键盘遮挡的区域，而使用`UIScrollView`时，你需要自己处理键盘的显示。

视图控制器可以通过监听iOS发送的`NSNotifications`来获知键盘呼出，从而调整内容。通知包含了一组几何和动画参数，用于将内容丝滑地移出键盘区域。 你首先要更新代码来监听这些通知。打开__PhotoCommmentViewController.swift__，在`viewDidLoad()`底部添加这些代码：

```swift
NSNotificationCenter.defaultCenter().addObserver(
  self,
  selector: "keyboardWillShow:",
  name: UIKeyboardWillShowNotification,
  object: nil
)

NSNotificationCenter.defaultCenter().addObserver(
  self,
  selector: "keyboardWillHide:",
  name: UIKeyboardWillHideNotification,
  object: nil
)
```

当视图加载后，你会开始监听通知，获知键盘出现或消失。

接下来，添加下面的代码，在对象生命周期结束时停止监听通知：

```swift
deinit {
  NSNotificationCenter.defaultCenter().removeObserver(self)
}
```

接下来在视图控制器中添加下面的方法：

```swift
func adjustInsetForKeyboardShow(show: Bool, notification: NSNotification) {
  let userInfo = notification.userInfo ?? [:]
  let keyboardFrame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
  let adjustmentHeight = (CGRectGetHeight(keyboardFrame) + 20) * (show ? 1 : -1)
  scrollView.contentInset.bottom += adjustmentHeight
  scrollView.scrollIndicatorInsets.bottom += adjustmentHeight
}

func keyboardWillShow(notification: NSNotification) {
  adjustInsetForKeyboardShow(true, notification: notification)
}

func keyboardWillHide(notification: NSNotification) {
  adjustInsetForKeyboardShow(false, notification: notification)
}
```

`adjustInsetForKeyboardShow(_:,notification:)`接受推送到的通知中的键盘高度，从滚动视图的`contentInset`中加上或减去20的内间距。这样，`UIScrollView`就会向上或向下滚动，使`UITextField`总是在屏幕上可见。

当通知被触发时，`keyboardWillShow(_:)`或`keyboardWillHide(_:)`之一会被调用。这些方法会接着调用`adjustInsetForKeyboardShow(_:,notification:)`，指示视图滚动的方向。

__隐藏键盘__

为了隐藏键盘，将这个方法加到`PhotoCommentViewController.swift`中去：

```swift
@IBAction func hideKeyboard(sender: AnyObject) {
  nameTextField.endEditing(true)
}
```

这个方法会取消文本框的第一响应对象状态，随之关闭键盘。

最后，打开__Main.storyboard__。从__Object Library__拖一个__Tap Gesture Recognizer__到根视图下。接下来，将它和__Photo Comment View Controller__中的`hideKeyboard(_:) IBAction`连接起来。

编译并运行。

![uiscrollview tutorial](http://www.raywenderlich.com/wp-content/uploads/2016/01/visit-2.gif)

按下文本框，然后按下屏幕其他区域。键盘应该根据屏幕内容正确地显示或隐藏。

## 使用UIPageViewController连播视图

在这份`UIScrollView`教程的第三部分，你将要创建一个允许连播的滚动视图。这意味着在你停止滑动时，滚动视图会锁定在一页上。当你在App Store查看应用截图时，你会看到这个操作。

__添加UIPageViewController__

回到__Main.storyboard__，从对象库面板拖一个__Page View Controller__。打开Identifier Inspector，__Storyboard ID__输入__PageViewController__，在Attribute Inspector中，__Transition Style__默认设为__Page Curl__；改为__Scroll__并将__Page Spacing__设为__8__。

在__Photo Comment View Controller__场景的__Identity Inspector__中，指定__Storyboard ID__为__PhotoCommentViewController__，然后你可以在代码中引用它。

打开__PhotoCommentViewController.swift__，然后添加：

```swift
public var photoIndex: Int!
```

它会引用即将显示的图像的编号，将会用在页面视图控制器中。

使用__iOS\Source\Cocoa Touch Class__模板创建一个新文件。将类命名为__ManagePageViewController__，子类为__UIPageViewController__。确认语言设为__Swift__。点击__Next__以备后用。

打开__ManagePageViewController.swift__，用下面的代码替换文件内容：

```swift
import UIKit

class ManagePageViewController: UIPageViewController {
  var photos = ["photo1", "photo2", "photo3", "photo4", "photo5"]
  var currentIndex: Int!

  override func viewDidLoad() {
    super.viewDidLoad()

    dataSource = self

    // 1
    if let viewController = viewPhotoCommentController(currentIndex ?? 0) {
      let viewControllers = [viewController]
      // 2
      setViewControllers(
        viewControllers,
        direction: .Forward,
        animated: false,
        completion: nil
      )
    }
  }

  func viewPhotoCommentController(index: Int) -> PhotoCommentViewController? {
    if let storyboard = storyboard,
        page = storyboard.instantiateViewControllerWithIdentifier("PhotoCommentViewController")
        as? PhotoCommentViewController {
      page.photoName = photos[index]
      page.photoIndex = index
      return page
    }
    return nil
  }
}
```

这段代码做了这两件微小的事情：

1.  `viewPhotoCommentController(_:_)`通过Storyboard创建了`PhotoCommentViewController`的一个实例。你将图像的名字作为参数传递，这样视图中显示的图片和前一屏中选中的会是同一张。
2.  通过传入一个数组，包含刚创建的各个视图控制器，你完成了`UIPageViewController`的设置。

你会发现Xcode报了一个错，提示`delegate`的值不能被设为`self`。这是因为现在`ManagePageViewController`还没有遵从`UIPageViewControllerDataSource`。在__ManagePageViewController.swift__中，`ManagePageViewController`定义外添加下面的代码：

```swift
//MARK: implementation of UIPageViewControllerDataSource
extension ManagePageViewController: UIPageViewControllerDataSource {
  // 1
  func pageViewController(pageViewController: UIPageViewController,
      viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {

    if let viewController = viewController as? PhotoCommentViewController {
      var index = viewController.photoIndex
      guard index != NSNotFound && index != 0 else { return nil }
      index = index - 1
      return viewPhotoCommentController(index)
    }
    return nil
  }

  // 2
  func pageViewController(pageViewController: UIPageViewController,
      viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {

    if let viewController = viewController as? PhotoCommentViewController {
      var index = viewController.photoIndex
      guard index != NSNotFound else { return nil }
      index = index + 1
      guard index != photos.count else {return nil}
      return viewPhotoCommentController(index)
    }
    return nil
  }
}
```

`UIPageViewControllerDataSource`允许你在页面变化时提供内容。你提供了视图控制器的实例，实现向前和向后的分页。在这两者情况中，`photoIndex`用来决定当前显示的图像（传给两个方法的 `viewController`指示当前显示的视图控制器）。新的控制器根据`photoIndex`创建并返回。

为了让分页视图生效，还需要做一些事情。首先，你将要修复应用流。回到__Main.storyboard__，选择你刚新建的__Page View Controller__视图。然后，在__Identity Inspector__中，将类指定为__ManagePageViewController__。删除你之前创建的push联线__showPhotoPage__。按住Control将__Scroll View Controller__中的__Photo Cell连接到____Manage Page View Controller__场景下，选择__Show__联线。在联线的__Attributes Inspector__中，指定名称为__showPhotoPage__。

打开__CollectionViewController.swift__，将`prepareForSegue(_:sender:)`的实现修改为：

```swift
override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
  if let cell = sender as? UICollectionViewCell,
      indexPath = collectionView?.indexPathForCell(cell),
      managePageViewController = segue.destinationViewController as? ManagePageViewController {
    managePageViewController.photos = photos
    managePageViewController.currentIndex = indexPath.row
  }
}
```

编译并运行。

![uiscrollview tutorial](http://www.raywenderlich.com/wp-content/uploads/2016/01/visit-3.gif)

你现在可以通过水平滑动切换不同的详情视图。:]

__显示PageControl指示__

在这份`UIScrollView`教程的最后一节中，你将会为应用添加一个`UIPageControl`。

`UIPageViewController`可以自动提供一个`UIPageControl`。为了这样做，你的`UIPageViewController`必须拥有一个`UIPageViewControllerTransitionStyleScroll`的过渡样式，而且你必须提供`UIPageViewControllerDataSource`两个特殊方法的实现（如果你还记得的话，你已经在Storyboard中将__Transition Style__ 设为__Scroll__ ）在__ManagePageViewController.swift__中为`UIPageViewControllerDataSource`扩展添加这些方法：

```swift
// MARK: UIPageControl
func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
  return photos.count
}

func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
  return currentIndex ?? 0
}
```

在第一个方法中，你指定了页面视图控制器中显示页面的编号。在第二个方法中，你告诉页面视图控制器初始应该选择哪个页面。

在你实现了需要的代理方法之后，你可以更进一步地自定义`UIAppearance`API。在__AppDelegate.swift__，将`application(application: didFinishLaunchingWithOptions:)`替换为：

```swift
func application(application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

  let pageControl = UIPageControl.appearance()
  pageControl.pageIndicatorTintColor = UIColor.lightGrayColor()
  pageControl.currentPageIndicatorTintColor = UIColor.redColor()
  return true
}
```

这段代码将会自定义`UIPageControl`的颜色。

编译并运行。

![](http://ww2.sinaimg.cn/large/005SiNxygw1f1yt10lpg3j308w0gegmz.jpg)![](http://www.raywenderlich.com/wp-content/uploads/2016/01/Screen-Shot-2016-01-11-at-9.44.24-PM.png)

__拼接起来__

马上就大功告成了！最后一步，让轻按图片的时候能返回缩放视图。打开__PhotoCommentViewController.swift__，添加下面的代码：

```swift
@IBAction func openZoomingController(sender: AnyObject) {
  self.performSegueWithIdentifier("zooming", sender: nil)
}

override public func prepareForSegue(segue: UIStoryboardSegue,
    sender: AnyObject?) {
  if let id = segue.identifier,
      zoomedPhotoViewController = segue.destinationViewController as? ZoomedPhotoViewController {
    if id == "zooming" {
      zoomedPhotoViewController.photoName = photoName
    }
  }
}
```

在__Main.storyboard__中，添加一个从__Photo Comment View Controller__到__Zoomed Photo View Controller__的__Show Detail__联线。选中这个联线后，打开Identifier Inspector，将__Identifier__设为__zooming__。

选择__Photo Comment View Controller__中的__Image View__，打开__Attributes Inspector__，选中__User Interaction Enabled__。添加一个__Tap Gesture Recognizer__，并连接到`openZoomingController(_:)`。

现在，当你轻按__Photo Comment View Controller Scene__中的一张图片时，你会被带到__Zoomed Photo View Controller Scene__，然后可以缩放图像。

编译，让我们运行起来看看最终的效果。

![uiscrollview tutorial](http://www.raywenderlich.com/wp-content/uploads/2016/01/visit-4.gif)

棒！大功告成！你创建了一个克隆的Photos应用：一个可以选择、滑动浏览的图像合辑，以及具有缩放图像的功能。

## 接下来……

这份教程中的PhotoScroll项目最终用到的所有代码都在[这里](http://www.raywenderlich.com/wp-content/uploads/2016/01/PhotoScroll_Final-1.zip)。

你已经探索了许多滚动视图可以做的趣事。如果你想再进一步，这里有一个21个视频的集合，专门介绍滚动视图。[看一看吧](http://www.raywenderlich.com/video-tutorials#swiftscrollview)。

接下来用这些酷炫的滚动视图技巧，做一些有趣的应用吧！

如果你遇到了什么问题或者想要留下反馈，请在下面评论区中讨论。
