>* 原文链接 : [UIScrollView Tutorial: Getting Started](https://www.raywenderlich.com/122139/uiscrollview-tutorial)
* 原文作者 : [Corinne Krych](https://www.raywenderlich.com/u/ckrych)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : 
* 校对者: 
* 状态： 认领中


_Note from Ray_: This is a Swift update to a popular Objective-C tutorial on our site. Update to Swift, iOS 9 and Xcode 7.1.1 by Corinne Krych; [Original post](https://www.raywenderlich.com/?p=10518) by Tutorial Team member [Matt Galloway](http://www.raywenderlich.com/u/mattjgalloway). Enjoy!

`UIScrollView` is one of the most versatile and useful controls in iOS. It is the basis for the very popular `UITableView` and is a great way to present content larger than a single screen. In this `UIScrollView` tutorial, by building an app very similar to the Photos app, you’ll learn all about using this control. You’ll learn:

*   How to use a `UIScrollView` to zoom and view a very large image.
*   How to keep the `UIScrollView`‘s content centered while zooming.
*   How to use `UIScrollView` for vertical scrolling with Auto Layout.
*   How to keep text input components visible when the keyboard is displayed.
*   How to use `UIPageViewController`, in conjunction with UIPageControl, to allow scrolling through multiple pages of content.

This tutorial assumes that you know how to use Interface Builder to add new objects to a view and connect outlets between your code and the Storyboard. You’ll want to be familiar with Storyboards before proceeding, so definitely take a look at our [Storyboards tutorial](https://www.raywenderlich.com/?p=5138) if you’re new to them.

## Getting Started

Click [here](http://www.raywenderlich.com/wp-content/uploads/2016/01/PhotoScroll_Starter.zip) to download the starter project for this `UIScrollView` tutorial, and then open it in Xcode.

Build and run to see what you’re starting with:

![uiscrollview tutorial](http://www.raywenderlich.com/wp-content/uploads/2015/12/starter1.gif)

When selecting a photo, you can see it full sized. But, sadly, the photo is cropped. You can not see the whole image with the limited size of your device. What you really want is for the image to fit the device’s screen by default, and then be able to zoom to see details as you would do in the Photos app.

Can you fix it? Yes you can!

## Scrolling and Zooming a Large Image

The first thing you’re going to learn in this `UIScrollView` tutorial is how to set up a scroll view that allows the user to zoom into an image and pan around.

First, you need to add a Scroll View. Open _Main.storyboard_, drag a _Scroll View_ from the _Object Library_ and drop it in Document Outline just under _View_ of _Zoomed Photo View Controller Scene_. Move _Image View_ inside your newly added _Scroll View_. Your document outline should now look like this:

![](http://ww4.sinaimg.cn/large/005SiNxygw1f1ysxw8ed9j30jg09etbj.jpg)](http://www.raywenderlich.com/wp-content/uploads/2016/01/Screen-Shot-2016-01-05-at-8.42.59-PM.png)

See that red dot? Xcode is now complaining that your Auto Layout rules are not properly defined. To fix them first select your _Scroll View_. Tap the Pin button at the bottom of the storyboard window. Add four new constraints: top, bottom, leading and trailing spaces. Uncheck _Constrain to margins_ and set all the constraint constants to 0.

![](http://ww1.sinaimg.cn/large/005SiNxygw1f1yswkubkaj30fj0dwmyl.jpg)

Now select _Image View_ and add the same four constraints to that view.

Resolve the Auto Layout warning by selecting _Zoomed Photo View Controller_ in Document Outline, and then selecting _Editor\Resolve Auto Layout Issues\Update Frames_.

Finally, uncheck _Adjust Scroll View Insets_ in Attributes Inspector for _Zoomed Photo View Controller_.

Build and run.

![uiscrollview tutorial](http://www.raywenderlich.com/wp-content/uploads/2015/12/starter2.gif)

Thanks to the Scroll View you can now see the full size image by swiping. But what if you want to see the picture scaled to fit the device screen? Or what if you want to zoom in or out of the photo?

Ready to start with some coding?

Open _ZoomedPhotoViewController.swift_, inside the class declaration, add the following outlet properties:

    @IBOutlet weak var scrollView: UIScrollView! 
    @IBOutlet weak var imageViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewTrailingConstraint: NSLayoutConstraint!

Back in _Main.storyboard_, wire up the _Scroll View_ to the _Zoomed View Controller_ by attaching it to the `scrollView` outlet and setting _Zoomed View Controller_ as the _Scroll View_’s delegate. Also, connect the new constraint outlets from _Zoomed View Controller_ to the appropriate constraints in the _Document Outline_ like this:

![](http://ww1.sinaimg.cn/large/005SiNxygw1f1yt7ib5j1j30jg09etbj.jpg)](http://www.raywenderlich.com/wp-content/uploads/2016/01/Screen-Shot-2016-01-05-at-8.53.38-PM.png)

Now you’re going to get down and dirty with the code. In _ZoomedPhotoViewController.swift_, add the implementation of the `UIScrollViewDelegate`‘s methods as an extension:

    extension ZoomedPhotoViewController: UIScrollViewDelegate {
      func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
      }
    }

This is the heart and soul of the scroll view’s zooming mechanism. You’re telling it which view should be made bigger and smaller when the scroll view is pinched. So, you tell it that it’s your `imageView`.

Now, add the implementation of `updateMinZoomScaleForSize(_:)` to the `ZoomedPhotoViewController` class:

    private func updateMinZoomScaleForSize(size: CGSize) {
      let widthScale = size.width / imageView.bounds.width
      let heightScale = size.height / imageView.bounds.height
      let minScale = min(widthScale, heightScale)  

      scrollView.minimumZoomScale = minScale 

      scrollView.zoomScale = minScale
    }

You need to work out the minimum zoom scale for the scroll view. A zoom scale of one means that the content is displayed at normal size. A zoom scale below one shows the content zoomed out, while a zoom scale of greater than one shows the content zoomed in. To get the minimum zoom scale, you calculate how far you’d need to zoom out so that the image fits snugly in your scroll view’s bounds based on its width. Then you do the same based upon the image’s height. The minimum of those two resulting zoom scales will be the scroll view’s minimum zoom scale. That gives you a zoom scale where you can see the entire image when fully zoomed out. Note that maximum zoom scale defaults to 1\. You leave it as the default because zooming in more than what the image’s resolution can support will cause it to look blurry.

You set the initial zoom scale to be the minimum, so that the image starts fully zoomed out.

Finally, update the minimum zoom scale each time the controller updates it’s subviews:

    override func viewDidLayoutSubviews() {
      super.viewDidLayoutSubviews()

      updateMinZoomScaleForSize(view.bounds.size)
    }

Build and run. You should get the following result:

![uiscrollview tutorial](http://www.raywenderlich.com/wp-content/uploads/2015/12/starter3.gif)

You can zoom and the image is displayed in portrait mode to fill the whole screen. But there are several glitches:

*   The image is pinned at the top of view. It would be nice to have it centered.
*   If you turn you phone to landscape orientation, your view doesn’t get resized.

Still in _ZoomedPhotoViewController.swift_ implement the `updateConstraintsForSize(size:)` function to fix these issues:

    private func updateConstraintsForSize(size: CGSize) {   

      let yOffset = max(0, (size.height - imageView.frame.height) / 2) 
      imageViewTopConstraint.constant = yOffset
      imageViewBottomConstraint.constant = yOffset

      let xOffset = max(0, (size.width - imageView.frame.width) / 2)
      imageViewLeadingConstraint.constant = xOffset
      imageViewTrailingConstraint.constant = xOffset

      view.layoutIfNeeded()
    }

The method helps to get around a slight annoyance with `UIScrollView`: if the scroll view content size is smaller than its bounds, then it sits at the top-left rather than in the center. Since you’ll be allowing the user to zoom all the way out, it would be nice if the image sat in the center of the view. This function accomplishes that by adjusting the layout constraints.

You center the image vertically by subtracting the height of `imageView` from the `view`‘s height and dividing it in half. This value is used as padding for the top and bottom `imageView` constraints.

Likewise, you calculate an offset for the leading and trailing constraints of `imageView`.

In the `UIScrollViewDelegate` extension, add `scrollViewDidZoom(_:)` implementation:

    func scrollViewDidZoom(scrollView: UIScrollView) {
      updateConstraintsForSize(view.bounds.size) 
    }

Here, the scroll view re-centers the view each time the user scrolls – if you don’t, the scroll view won’t appear to zoom naturally; instead, it will sort of stick to the top-left.

Now take a deep breath, give yourself a pat on the back and build and run your project! Tap on an image and if everything went smoothly, you’ll end up with a lovely image that you can zoom, pan and tap. :]

![uiscrollview tutorial](http://www.raywenderlich.com/wp-content/uploads/2015/12/starter4.gif)

## Scrolling Vertically

Now suppose you want to change PhotoScroll to display the image at the top and add comments below it. Depending on how long the comment is, you may end up with more text than your device can display: Scroll View to the rescue!

_Note_: In general, Auto Layout considers the top, left, bottom, and right edges of a view to be the visible edges. However, `UIScrollView` scrolls its content by changing the origin of it’s bounds. To make this work with Auto Layout, the edges within a scroll view actually refer to the edges of its content view.

To size the scroll view’s frame with Auto Layout, constraints must either be explicit regarding the width and height of the scroll view, or the edges of the scroll view must be tied to views outside of its own subtree.

You can read more in [this technical note](https://developer.apple.com/library/ios/technotes/tn2154/_index.html) from Apple.

You’ll see, in practice, how to fix the width of a scroll view, or really its content size width, using auto layout in storyboards.

### Scroll view and Auto Layout

Open _Main.storyboard_ and lay out a new scene:

First, add a new _View Controller_. In Size Inspector, for the _Simulated Size_, replace _Fixed_ with _Freeform_ and enter a width of 340 and a height of 800\. You’ll notice the layout of the controller gets narrower and longer, simulating the behavior of a long vertical content. The simulated size helps you visualize the display in Interface Builder. It has no runtime effect.

Uncheck _Adjust Scroll View Insets_ in the _Attributes Inspector_ for your newly created view controller.

Add a _Scroll View_ that fills the entire space of the view controller. Add leading and trailing constraints with constant values of 0 to the view controller. (Make sure to uncheck _Constrain to margin_). Add top and bottom constraints from _Scroll View_ to the Top and Bottom Layout guides, respectively. They should also have constants of 0.

Add a _View_ as a child of the _Scroll View_ that takes the entire space of the _Scroll View_. Rename its storyboard _Label_ to _Container View_. Like before, add top, bottom, leading and trailing constraints.

To define the size of the scroll view and fix the Auto Layout errors, you need to define its content size. Define the width of _Container View_ to match the view controller’s width. Attach an equal width constraint from the _Container View_ to the _View Controller_’s main view. For the height of _Container View_ define a height constraint of 500.

_Note_: Auto Layout rules must comprehensively define a Scroll View’s `contentSize`. This is the key step in getting a Scroll View to be correctly sized when using Auto Layout.

Add an _Image View_ inside _Container View_. In Attributes Inspector: specify _photo1_ as the image, choose _Aspect Fit_ mode and check _Clip Subviews_. Add top, leading, and trailing constraints to Container View like before. Add n width constraint of 300 to the image view.

Add a _Label_ inside of _Container View_ below the image view. Specify the label’s text as: _What name fits me best?_ Add a centered horizontal constraint to _Container View_. Add a vertical spacing constraint of 0 with _Photo View_.

Add a _Text Field_ inside of _Container View_, right below the new label. Add leading and trailing constraints to _Container View_ with constant values of 8, and no margin. Add a vertical spacing constraint of 30 with the label.

Finally, connect your newly created View Controller to another screen via a segue. Remove the existing push segue between the _Photo Scroll_ scene and the _Zoomed Photo View Controller_ scene. Don’t worry, all the work you’ve done on _Zoomed Photo View Controller_ will be added back to your app later.

In the _Photo Scroll_ scene, from _PhotoCell_, control-drag to View Controller, add a _show_ segue. Make the identifier _showPhotoPage_.

Build and Run.

![](http://ww2.sinaimg.cn/large/005SiNxygw1f1yt3f7egoj307n0dwwfc.jpg)

You can see that layout is correct in vertical orientation. Try rotating to landscape orientation. In landscape, there is not enough vertical room to show all the content, yet the scroll view allows you to properly scroll to see the label and the text field. Unfortunately, since the image in the new view controller is hard-coded, the image you selected in the collection view is not shown.

To fix this, you’ll need to pass it along to the view controller when the segue is executed. So, create a new file with the _iOS\Source\Cocoa Touch Class_ template. Name the class _PhotoCommentViewController_ and set the subclass to _UIViewController_. Make sure that the language is set to _Swift_. Click _Next_ and save it with the rest of the project.

Update _PhotoCommentViewController.swift_ with this code:

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

This updated implementation of `PhotoCommentViewController` adds `IBOutlet`s, and sets the image of `imageView` based on a `photoName`.

Back in the storyboard, open the _Identity Inspector_ for _View Controller_, select _PhotoCommentViewController_ for the _Class_. Open the _Connections Inspector_ and wire up the _IBOutlet_s for the Scroll View, Image View and Text Field of `PhotoCommentViewController`.

Open _CollectionViewController.swift_, replace `prepareForSegue(_:sender:)` with:

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      if let cell = sender as? UICollectionViewCell,
          indexPath = collectionView?.indexPathForCell(cell),
          photoCommentViewController = segue.destinationViewController as? PhotoCommentViewController {
        photoCommentViewController.photoName = "photo\(indexPath.row + 1)"
      }
    }

This sets the name of the photo to be shown on `PhotoCommentViewController` when one of the photos is tapped.

Build and run.

![](http://ww3.sinaimg.cn/large/005SiNxygw1f1yszwdwhrj307n0dwaay.jpg)

Your view nicely displays the content and when needed allows you to scroll down to see more. You’ll notice two issues with the keyboard: first, when entering text, the keyboard hides the Text Field. Second, there is no way to dismiss the keyboard. Ready to fix the glitches?

### Keyboard

_Keyboard offset_

Unlike when using `UITableViewController` where it manages moving content out of the way of the on-screen keyboard, when working with `UIScrollView` you have to deal with handling the keyboard appearance by yourself.

View controllers can make adjustments to their contents when the keyboard appears by listening for `NSNotifications` issued by iOS. The notifications contain a dictionary of geometry and animation parameters that can be used to smoothly animate the contents out of the way of the keyboard. You’ll first update your code to listen for those notifications. Open _PhotoCommmentViewController.swift_, and add the following code at the bottom of `viewDidLoad()`:

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

When the view loads, you will begin listening for notifications that the keyboard is appearing and disappearing.

Next, add the following code, to stop listening for notifications when the object’s life ends:

    deinit {
      NSNotificationCenter.defaultCenter().removeObserver(self)
    }

Next add the following methods to the view controller:

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

`adjustInsetForKeyboardShow(_:,notification:)` takes the keyboard’s height as delivered in the notification, adds a padding value of 20 to either be subtracted from or added to the scroll views’s `contentInset`. This way, the `UIScrollView` will scroll up or down to let the `UITextField` always be visible on the screen.

When the notification is fired, either `keyboardWillShow(_:)` or `keyboardWillHide(_:)` will be called. These methods will then call `adjustInsetForKeyboardShow(_:,notification:)`, indicating which direction to move the scroll view.

_Dismissing the Keyboard_

To dismiss the keyboard, add this method to `PhotoCommentViewController.swift`:

    @IBAction func hideKeyboard(sender: AnyObject) {
      nameTextField.endEditing(true)
    }

This method will resign the first responder status of the text field which will, in turn, close the keyboard.

Finally, open _Main.storyboard_. From _Object Library_ drag a _Tap Gesture Recognizer_ into the root view. Then, wire it to the `hideKeyboard(_:) IBAction` in _Photo Comment View Controller_.

Build and run.

![uiscrollview tutorial](http://www.raywenderlich.com/wp-content/uploads/2016/01/visit-2.gif)

Tap the text field, and then tap somewhere else on the screen. The keyboard should properly show and hide itself relative to the other content on the screen.

## Paging with UIPageViewController

In the third section of this `UIScrollView` tutorial, you’ll be creating a scroll view that allows paging. This means that the scroll view locks onto a page when you stop dragging. You’ll see this in action in the App Store app when you view screenshots of an app.

_Add UIPageViewController_

Go to _Main.storyboard_, drag a _Page View Controller_ from the Object Library. Open Identity Inspector, enter _PageViewController_ for the _Storyboard ID_. In Attributes Inspector, the _Transition Style_ is set to _Page Curl_ by default; change it to _Scroll_ and set the _Page Spacing_ to _8_.

In the _Photo Comment View Controller_ scene’s _Identity Inspector_, specify a _Storyboard ID_ of _PhotoCommentViewController_, so that you can refer to it from code.

Open _PhotoCommentViewController.swift_ and add:

    public var photoIndex: Int!

This will reference the index of the photo to show and will be used by the page view controller.

Create a new file with the _iOS\Source\Cocoa Touch Class_ template. Name the class _ManagePageViewController_ and set the subclass to _UIPageViewController_ . Make sure that the language is set to _Swift_. Click _Next_ and save it with the rest of the project.

Open _ManagePageViewController.swift_ and replace the contents of the file with the following:

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

Here’s what this code does:

1.  `viewPhotoCommentController(_:_)` creates an instance of `PhotoCommentViewController` though the Storyboard. You pass the name of the image as a parameter so that the view displayed matches the image you selected in previous screen.
2.  You setup the `UIPageViewController` by passing it an array that contains the single view controller you just created.

You’ll notice that you have an Xcode error indicating that `delegate` cannot be assigned a value of `self`. This is because `ManagePageViewController` does not yet conform to `UIPageViewControllerDataSource`. Add the following in _ManagePageViewController.swift_ but outside of the `ManagePageViewController` definition:

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

The `UIPageViewControllerDataSource` allows for you to provide content when the page changes. You provide view controller instances for paging in both the forward and backward directions. In both cases, `photoIndex` is used to determine which image is currently being displayed. (The `viewController` parameter to both methods indicates the currently displayed view controller.) Based on the `photoIndex` a new controller is created and returned for either method.

There are only a couple things left to do to get your page view running. First, you will fix the application flow of the app. Switch back to _Main.storyboard_ and select your newly created  
_Page View Controller_ scene. Then, in the _Identity Inspector_, specify _ManagePageViewController_ for its class. Delete the push segue _showPhotoPage_ you created earlier. Control drag from _Photo Cell_ in _Scroll View Controller_ to _Manage Page View Controller Scene_ and select a _Show_ segue. In the _Attributes Inspector_ for the segue, specify its name as _showPhotoPage_.

Open _CollectionViewController.swift_ and change the implementation of `prepareForSegue(_:sender:)` to the following:

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      if let cell = sender as? UICollectionViewCell, 
          indexPath = collectionView?.indexPathForCell(cell), 
          managePageViewController = segue.destinationViewController as? ManagePageViewController {
        managePageViewController.photos = photos
        managePageViewController.currentIndex = indexPath.row
      }
    }

Build and run.

![uiscrollview tutorial](http://www.raywenderlich.com/wp-content/uploads/2016/01/visit-3.gif)

You can now scroll side to side to page between different detail views. :]

_Display Page Control indicator_

For the final part of this `UIScrollView` tutorial, you will add a `UIPageControl` to your application.

`UIPageViewController` has the ability to automatically provide a `UIPageControl`. To do so, your `UIPageViewController` must have a transition style of `UIPageViewControllerTransitionStyleScroll`, and you must provide implementations of two special methods of `UIPageViewControllerDataSource`. (If you remember, you already set the _Transition Style_ to _Scroll_ in the Storyboard). Add these methods to the `UIPageViewControllerDataSource` extension in _ManagePageViewController.swift_:

    // MARK: UIPageControl
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
      return photos.count
    }

    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
      return currentIndex ?? 0
    }

In the first method, you specify the number of pages to display in the page view controller. And, in the second method, you tell page view controller which page should initially be selected.

After you’ve implemented the required delegate methods, you can add further customization with the `UIAppearance` API. In _AppDelegate.swift_, replace `application(application: didFinishLaunchingWithOptions:)` with:

    func application(application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

      let pageControl = UIPageControl.appearance()
      pageControl.pageIndicatorTintColor = UIColor.lightGrayColor()
      pageControl.currentPageIndicatorTintColor = UIColor.redColor()
      return true
    }

This will customize the colors of the `UIPageControl`.

Build and run.

![](http://ww2.sinaimg.cn/large/005SiNxygw1f1yt10lpg3j308w0gegmz.jpg)](http://www.raywenderlich.com/wp-content/uploads/2016/01/Screen-Shot-2016-01-11-at-9.44.24-PM.png)

_Putting it all together_

Almost there! The very last step is to add back the zooming view when tapping an image. Open _PhotoCommentViewController.swift_ and add the following:

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

In _Main.storyboard_, add a _Show Detail_ segue from _Photo Comment View Controller_ to _Zoomed Photo View Controller_. With the new segue selected, open the _Identity Inspector_, set the _Identifier_ to _zooming_.

Select the _Image View_ in _Photo Comment View Controller_, open the _Attributes Inspector_ and check _User Interaction Enabled_. Add a _Tap Gesture Recognizer_, and connect it to `openZoomingController(_:)`.

Now, when you tap an image in _Photo Comment View Controller Scene_, you’ll be taken to the _Zoomed Photo View Controller Scene_ where you can zoom the photo.

Build and run one more time.

![uiscrollview tutorial](http://www.raywenderlich.com/wp-content/uploads/2016/01/visit-4.gif)

Yes you did it! You’ve created a Photos app clone: a collection view of images you can select and navigate through by swiping, as well as the ability to zoom the photo content.

## Where to Go From Here?

[Here](http://www.raywenderlich.com/wp-content/uploads/2016/01/PhotoScroll_Final-1.zip) is the final PhotoScroll project with all of the code from this `UIScrollView` tutorial.

You’ve delved into many of the interesting things that a scroll view is capable of. If you want to go further, there is an entire 21-part video series dedicated to scroll views. [Take a look](http://www.raywenderlich.com/video-tutorials#swiftscrollview).

Now go make some awesome apps, safe in the knowledge that you’ve got mad scroll view skills!

If you run into any problems along the way or want to leave feedback about what you’ve read here, join in the discussion in the comments below.
