> * 原文地址：[iOS Performance Tricks To Make Your App Feel More Performant](https://www.smashingmagazine.com/2019/02/ios-performance-tricks-apps/)
> * 原文作者：[Axel](https://www.smashingmagazine.com/author/axel-kee)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/ios-performance-tricks-apps.md](https://github.com/xitu/gold-miner/blob/master/TODO1/ios-performance-tricks-apps.md)
> * 译者：
> * 校对者：

# iOS Performance Tricks To Make Your App Feel More Performant

Quick summary: Good performance is critical to delivering a good user experience, and iOS users often have high expectations of their apps. A slow and unresponsive app might make users give up on using your app or, worse, leave a bad rating.

Although modern iOS hardware is powerful enough to handle many intensive and complex tasks, the device could still feel unresponsive if you are not careful about how your app performs. In this article, we will look into five optimization tricks that will make your app feel more responsive.

### 1\. Dequeue Reusable Cell

You’ve probably used `tableView.dequeueReusableCell(withIdentifier:for:)` inside `tableView(_:cellForRowAt:)` before. Ever wondered why you have to follow this awkward API, instead of just passing an array of cell in? Let’s go through the reasoning of this.

Say you have a table view with a thousand rows. Without using reusable cells, we would have to create a new cell for each row, like this:

```
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
   // Create a new cell whenever cellForRowAt is called.
   let cell = UITableViewCell()
   cell.textLabel?.text = "Cell \(indexPath.row)"
   return cell
}
```

As you might have thought, this will add a thousand cells to the device’s memory as you scroll to the bottom. Imagine what would happen if each cell contained a `UIImageView` and a lot of text: Loading them all at once could cause the app to run out of memory! Apart from that, every single cell would require new memory to be allocated during scrolling. If you scroll a table view quickly, a lot of small chunks of memory will be allocated on the fly, and this process will make the UI janky!

To resolve this, Apple has provided us with the `dequeueReusableCell(withIdentifier:for:)` method. Cell reuse works by placing the cell that is no longer visible on the screen into a queue, and when a new cell is about to be visible on the screen (say, the subsequent cell below as the user scrolls down), the table view will retrieve a cell from this queue and modify it in the `cellForRowAt indexPath:` method.

[![Cell reuse queue mechanism](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/ba882cd5-8212-4b68-8ad0-cdbf9e26aeb3/ios-performance-tricks-1-dequeue.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/ba882cd5-8212-4b68-8ad0-cdbf9e26aeb3/ios-performance-tricks-1-dequeue.png) 

How cell reuse queues work in iOS ([Large preview](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/ba882cd5-8212-4b68-8ad0-cdbf9e26aeb3/ios-performance-tricks-1-dequeue.png))

By using a queue to store cells, the table view doesn’t need to create a thousand cells. Instead, it needs just enough cells to cover the area of the table view.

By using `dequeueReusableCell`, we can reduce the memory used by the app and make it less prone to running out of memory!

### 2. Using A Launch Screen That Looks Like The Initial Screen

As mentioned in Apple’s [Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/ios/icons-and-images/launch-screen/) (HIG), launch screens can be used to enhance the perception of an app’s responsiveness:

> “It’s solely intended to enhance the perception of your app as quick to launch and immediately ready for use. Every app must supply a launch screen.”

It’s a common mistake to use a launch screen as a splash screen to show branding or to add a loading animation. Design the launch screen to be identical to the first screen of your app, as mentioned by Apple:

> “Design a launch screen that’s nearly identical to the first screen of your app. If you include elements that look different when the app finishes launching, people can experience an unpleasant flash between the launch screen and the first screen of the app.  
>   
> “The launch screen isn’t a branding opportunity. Don’t design an entry experience that looks like a splash screen or an "About" window. Don’t include logos or other branding elements unless they’re a static part of your app’s first screen.”

Using a launch screen for loading or branding purposes could slow down the time of first use and make the user feel that the app is sluggish.

When you start a new iOS project, a blank `LaunchScreen.storyboard` will be created. This screen will be shown to the user while the app loads the view controllers and layout.

To make your app feel faster, you can design the launch screen to be similar to the first screen (view controller) that will be shown to the user.

For example, the Safari app’s launch screen is similar to its first view :

[![Launch screen and first view look similar](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/5cf91d55-0418-45e0-8019-3be8f875086e/ios-performance-tricks-2-launchscreen.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/5cf91d55-0418-45e0-8019-3be8f875086e/ios-performance-tricks-2-launchscreen.png) 

A comparison of launch screen and first view of Safari app ([Large preview](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/5cf91d55-0418-45e0-8019-3be8f875086e/ios-performance-tricks-2-launchscreen.png))

The launch screen storyboard is like any other storyboard file, except that you can only use the standard UIKit classes, like UIViewController, UITabBarController, and UINavigationController. If you attempt to use any other custom subclasses (such as UserViewController), Xcode will notify you that using custom class names is prohibited.

[![Xcode shows error when a custom class is used](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/526ff784-be5f-4f25-8e04-ce81ef038088/ios-performance-tricks-3.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/04546e45-0976-4fbd-b776-5d720b982bb4/ios-performance-tricks-3-illegal.png) 

Launch screen storyboard cannot contain non-UIKit standard class. ([Large preview](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/04546e45-0976-4fbd-b776-5d720b982bb4/ios-performance-tricks-3-illegal.png))

Another thing to note is that `UIActivityIndicatorView` doesn’t animate when placed on the launch screen, because iOS will generate a static image from the launch screen storyboard and displays it to the user. (This is mentioned briefly in the WWDC 2014 presentation “[Platforms State of the Union](https://developer.apple.com/videos/play/wwdc2014/102/)”, around `01:21:56`.)

Apple’s HIG also advises us not to include text on our launch screen, because the launch screen is static, and you can’t localize text to cater to different languages.

**Recommended reading**: _[Mobile App With Facial Recognition Feature: How To Make It Real](https://www.smashingmagazine.com/2018/02/mobile-app-facial-recognition-feature/)_

### 3. State Restoration For View Controllers

State preservation and restoration allow the user to return to the exact same UI state from just before they left the app. Sometimes, due to insufficient memory, the operating system might need to remove your app from memory while the app is in the background, and the app might lose track of its last UI state if it is not preserved, possibly causing users to lose their work in progress!

In the multitasking screen, we can see a list of apps that have been put in the background. We might assume that these apps are still running in the background; in reality, some of these apps might get killed and restarted by the system due to the demands of memory. The app snapshots we see in the multitasking view are actually screenshots taken by the system from right when we exited the app (i.e. to go to the home or multitasking screen).

[![iOS fabricates the illusion of apps running in the background by taking a screenshot of the most recent view](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/2edd59aa-1195-40cd-8322-7f71a5e2e91b/ios-performance-tricks-4-multitask.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/2edd59aa-1195-40cd-8322-7f71a5e2e91b/ios-performance-tricks-4-multitask.png) 

Screenshots of apps taken by iOS when user exits the app ([Large preview](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/2edd59aa-1195-40cd-8322-7f71a5e2e91b/ios-performance-tricks-4-multitask.png))

iOS uses these screenshots to give the illusion that the app is still running or is still displaying this particular view, whereas the app might have been already terminated or restarted in the background while still displaying the same screenshot.

Have you ever experienced, upon resuming an app from the multitasking screen, that the app shows a user interface different from the snapshot shown in the multitasking view? This is because the app hasn’t implemented the state-restoration mechanism, and the displayed data was lost when the app was killed in the background. This can lead to a bad experience because the user expects your app to be in the same state as when they left it.

From Apple’s [article](https://developer.apple.com/documentation/uikit/view_controllers/preserving_your_app_s_ui_across_launches?language=objc):

> “They expect your app to be in the same state as when they left it. State preservation and restoration ensures that your app returns to its previous state when it launches again.”

UIKit does a lot of work to simplify state preservation and restoration for us: It handles the saving and loading of an app’s state automatically at appropriate times. All we need to do is add some configuration to tell the app to support state preservation and restoration and to tell the app what data needs to be preserved.

To enable state saving and restoring, we can implement these two methods in `AppDelegate.swift`:

```
func application(_ application: UIApplication, shouldSaveApplicationState coder: NSCoder) -> Bool {
   return true
}
```

```
func application(_ application: UIApplication, shouldRestoreApplicationState coder: NSCoder) -> Bool {
   return true
}
```

This will tell the app to save and restore the application’s state automatically.

Next, we’ll tell the app which view controllers need to be preserved. We do this by specifying the “Restoration ID” in the storyboard :

[![Setting restoration ID in storyboard](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/0eb257d5-cd70-4a0b-9565-3782999b9926/ios-performance-tricks-5-restorationid.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/0eb257d5-cd70-4a0b-9565-3782999b9926/ios-performance-tricks-5-restorationid.png) 

Setting restoration ID in storyboard ([Large preview](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/0eb257d5-cd70-4a0b-9565-3782999b9926/ios-performance-tricks-5-restorationid.png))

You can also check “Use Storyboard ID” to use the storyboard ID as the restoration ID.

To set the restoration ID in the code, we can use the `restorationIdentifier` property of the view controller.

```
// ViewController.swift
self.restorationIdentifier = "MainVC"
```

During state preservation, any view controller or view that has been assigned a restoration identifier will have its state saved to disk.

Restoration identifiers can be grouped together to form a restoration path. The identifiers are grouped using the view hierarchy, from the root view controller to the current active view controller. Suppose a MyViewController is embedded in a navigation controller, which is embedded in another tab bar controller. Assuming they are using their own class names as restoration identifiers, the restoration path will look like this:

```
TabBarController/NavigationController/MyViewController
```

When the user leaves the app with the MyViewController being the active view controller, this path will be saved by the app; then the app will remember the previous view hierarchy shown (_Tab Bar Controller_ → _Navigation Controller_ → _My View Controller_).

After assigning the restoration identifier, we will need to implement the encodeRestorableState(with coder:) and decodeRestorableState(with coder:) methods for each of the preserved view controllers. These two methods let us specify what data need to be saved or loaded and how to encode or decode them.

Let’s see the view controller:

```
// MyViewController.swift
​
// MARK: State restoration
// UIViewController already conforms to UIStateRestoring protocol by default
extension MyViewController {

   // will be called during state preservation
   override func encodeRestorableState(with coder: NSCoder) {
       // encode the data you want to save during state preservation
       coder.encode(self.username, forKey: "username")
       super.encodeRestorableState(with: coder)
   }
   
   // will be called during state restoration
   override func decodeRestorableState(with coder: NSCoder) {
     // decode the data saved and load it during state restoration
     if let restoredUsername = coder.decodeObject(forKey: "username") as? String {
       self.username = restoredUsername
     }
     super.decodeRestorableState(with: coder)
   }
} 
```

Remember to call the superclass implementation at the bottom of your own method. This ensures that the parent class has a chance to save and restore state.

Once the objects have finished decoding, `applicationFinishedRestoringState()` will be called to tell the view controller that the state has been restored. We can update the UI for the view controller in this method.

```
// MyViewController.swift
​
// MARK: State restoration
// UIViewController already conforms to UIStateRestoring protocol by default
extension MyViewController {
   ...
 
   override func applicationFinishedRestoringState() {
     // update the UI here
     self.usernameLabel.text = self.username
   }
}
```

There you have it! These are the essential methods to implement state preservation and restoration for your app. Keep in mind that the operating system will remove the saved state when the app is being force-closed by the user, in order to avoid getting stuck in a broken state in case something goes wrong in the state preservation and restoration.

Also, don’t store any model data (i.e. data that should have been saved to UserDefaults or Core Data) to the state, even though it might seem convenient to do so. State data will be removed when the user force quits your app, and you certainly don’t want to lose model data this way.

To test whether state preservation and restoration are working well, follow the steps below:

1.  Build and launch an app using Xcode.
2.  Navigate to the screen with state preservation and restoration that you want to test.
3.  Return to the home screen (by swiping up or double-clicking home button, or pressing `Shift ⇧` + `Cmd ⌘` + `H` in the simulator) to send the app to the background.
4.  Stop the app in Xcode by pressing the ⏹ button.
5.  Launch the app again and check whether the state has been restored successfully.

Because this section only covers the basics of state preservation and restoration, I recommend the following articles by Apple Inc. for more in-depth knowledge of state restoration:

1.  [Preserving And Restoring State](https://developer.apple.com/library/archive/featuredarticles/ViewControllerPGforiPhoneOS/PreservingandRestoringState.html)
2.  [UI Preservation Process](https://developer.apple.com/documentation/uikit/view_controllers/preserving_your_app_s_ui_across_launches/about_the_ui_preservation_process)
3.  [UI Restoration Process](https://developer.apple.com/documentation/uikit/view_controllers/preserving_your_app_s_ui_across_launches/about_the_ui_restoration_process)

### 4. Reduce Usage Of Non-Opaque Views As Much As Possible

An opaque view is a view that has no transparency, meaning that any UI element placed behind it is not visible at all. We can set a view to be opaque in the Interface Builder:

[![This will inform the drawing system to skip drawing whatever is behind this view](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/0402cef9-9dc9-4d61-b394-21de713e039b/ios-performance-tricks-6.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/5af9b5bc-8786-41d9-88ab-2342f69c2b88/ios-performance-tricks-6-opaque.png) 

Set UIView to opaque in storyboard ([Large preview](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/5af9b5bc-8786-41d9-88ab-2342f69c2b88/ios-performance-tricks-6-opaque.png))

Or we can do it programmatically with the `isOpaque` property of UIView:

```
view.isOpaque = true
```

Setting a view to opaque will make the drawing system optimize some drawing performance while rendering the screen.

If a view has transparency (i.e. alpha is below 1.0), then iOS will have to do extra work to calculate what should be displayed by blending different layers of views in the view hierarchy. On the other hand, if a view is set to opaque, then the drawing system will just put this view in front and avoid the extra work of blending the multiple view layers behind it.

You can check which layers are being blended (non-opaque) in the iOS Simulator by checking _Debug_ → _Color Blended Layers_.

[![Green is non-color blended, red is blended layer](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/8b312287-e25e-4f1e-ad67-aea5aa91f2f3/ios-performance-tricks-7.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/d7c3eeb5-0d64-4b38-9f01-da23dd7d244e/ios-performance-tricks-7-colorblendedlayers.png) 

Show color blended layers in Simulator

After checking the _Color Blended Layers_ option, you can see that some views are red and some are green. Red indicates that the view is not opaque and that its output display is a result of layers blended behind it. Green indicates that the view is opaque and no blending has been done.

[![With an opaque color background, the layer doesn’t need to blend with another layer](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/7dfe406f-434b-4358-8458-7408ba61bcc4/ios-performance-tricks-9-greenish.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/7dfe406f-434b-4358-8458-7408ba61bcc4/ios-performance-tricks-9-greenish.png) 

Assign non-transparent background color to UILabel whenever possible to reduce color blended layers. ([Large preview](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/7dfe406f-434b-4358-8458-7408ba61bcc4/ios-performance-tricks-9-greenish.png))

The labels shown above (“View Friends”, etc.) are highlighted in red because when a label is dragged to the storyboard, its background color is set to transparent by default. When the drawing system is compositing the display near the label area, it will ask for the layer behind the label and do some calculation.

One way you can optimize app performance is to reduce how many views are highlighted with red as much as possible.

By changing `label.backgroundColor = UIColor.clear` to `label.backgroundColor = UIColor.white`, we can reduce layer blending between the label and the view layer behind it.

[![Using a transparent background color will cause layer blending](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/56fc5367-3cca-49f1-a5bd-a5fd15eb1cc0/ios-performance-tricks-8-redgreen.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/56fc5367-3cca-49f1-a5bd-a5fd15eb1cc0/ios-performance-tricks-8-redgreen.png) 

Many labels are highlighted in red because their background color is transparent, causing iOS to calculate the background color by blending the view behind it. ([Large preview](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/56fc5367-3cca-49f1-a5bd-a5fd15eb1cc0/ios-performance-tricks-8-redgreen.png))

You might have noticed that, even if you have set a UIImageView to opaque and assigned a background color to it, the simulator will still show red in the image view. This is probably because the image you used for the image view has an alpha channel.

To remove the alpha channel for an image, you can use the Preview app to make a duplicate of the image (`Shift ⇧` + `Cmd ⌘` + `S`), and uncheck the “Alpha” checkbox when saving.

[![Uncheck the ‘Alpha’ checkbox when saving an image to discard the alpha channel.](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/13b72d22-093d-4957-b297-25c9b950ad4c/ios-performance-tricks-10-uncheck.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/13b72d22-093d-4957-b297-25c9b950ad4c/ios-performance-tricks-10-uncheck.png) 

Uncheck the ‘Alpha’ checkbox when saving an image to discard the alpha channel. ([Large preview](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/13b72d22-093d-4957-b297-25c9b950ad4c/ios-performance-tricks-10-uncheck.png))

### 5. Pass Heavy Processing Functions To Background Threads (GCD)

Because UIKit only works on the main thread, performing heavy processing on the main thread will slow down the UI. The main thread is used by UIKit not only to handle and respond to user input, and also to draw the screen.

The key to making an app responsive is to move as many heavy processing tasks to background threads as possible. Avoid doing complex calculation, networking, and heavy IO operation (e.g. reading and writing to disk) on the main thread.

You might have once used an app that suddenly became unresponsive to your touch input, and it feels like the app has hung. This is most probably caused by the app running heavy computation tasks on the main thread.

The main thread usually alternates between UIKit tasks (such as handling user input) and some light tasks in small intervals. If a heavy task is running on main thread, then UIKit will need to wait until the heavy task has finished before being able to handle touch input.

[![Avoid running performance-intensive or time-consuming task on the main thread](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/8f319bf3-4849-4e94-9c1b-6666415f4f98/ios-performance-tricks-11-mainthread.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/8f319bf3-4849-4e94-9c1b-6666415f4f98/ios-performance-tricks-11-mainthread.png) 

Here is how the main thread handles UI tasks and why it causes the UI to hang when heavy tasks are performed. ([Large preview](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/8f319bf3-4849-4e94-9c1b-6666415f4f98/ios-performance-tricks-11-mainthread.png))

By default, the code inside view controller lifecycle methods (such as viewDidLoad) and IBOutlet functions are executed on the main thread. To move heavy processing tasks to a background thread, we can use the [Grand Central Dispatch](https://apple.github.io/swift-corelibs-libdispatch/) queues provided by Apple.

Here’s the template for switching queues :

```
// Switch to background thread to perform heavy task.
DispatchQueue.global(qos: .default).async {
   // Perform heavy task here.
 
   // Switch back to main thread to perform UI-related task.
   DispatchQueue.main.async {
       // Update UI.
   }
}
```

The `qos` stands for “quality of service”. Different quality-of-service values indicate different priorities for the specified tasks. The operating system will allocate more CPU time and CPU power I/O throughput for tasks allocated in queues with higher QoS values, meaning that a task will finish faster in a queue with higher QoS values. A higher QoS value will also consume more energy due to it using more resources.

Here is the list of QoS values from highest to lowest priority:

[![Quality-of-service values of queue sorted by performance and energy efficiency](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/bbfaec6b-7e95-4d5e-a1d6-d5c96944d363/ios-performance-tricks-12-qos.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/bbfaec6b-7e95-4d5e-a1d6-d5c96944d363/ios-performance-tricks-12-qos.png) 

Quality-of-service values of queue sorted by performance and energy efficiency ([Large preview](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/bbfaec6b-7e95-4d5e-a1d6-d5c96944d363/ios-performance-tricks-12-qos.png))

Apple has provided [a handy table](https://developer.apple.com/library/archive/documentation/Performance/Conceptual/EnergyGuide-iOS/PrioritizeWorkWithQoS.html#//apple_ref/doc/uid/TP40015243-CH39-SW1) with examples of which QoS values to use for different tasks.

One thing to keep in mind is that all UIKit code should always be executed on the main thread. Modifying UIKit objects (such as `UILabel` and `UIImageView`) on the background thread could have an unintended consequence, like the UI not actually updating, a crash occurring, and so on.

From Apple’s [article](https://developer.apple.com/documentation/code_diagnostics/main_thread_checker):

> “Updating UI on a thread other than the main thread is a common mistake that can result in missed UI updates, visual defects, data corruptions, and crashes.”

I recommend watching [Apple’s WWDC 2012 video on UI concurrency](https://developer.apple.com/videos/play/wwdc2012/211/) to better understand how to build a responsive app.

#### Notes

The trade-off of performance optimization is that you have to write more code or configure additional settings on top of the app’s functionality. This might make your app delivered later than expected, and you will have more code to maintain in the future, and more code means potentially more bugs.

Before spending time on optimizing your app, ask yourself whether the app is already smooth or whether it has some unresponsive part that really needs to be optimized. Spending a lot of time optimizing an already smooth app to shave off 0.01 seconds might not be worth it, as the time could be better spent developing better features or other priorities.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
