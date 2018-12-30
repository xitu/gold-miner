> * 原文地址：[State Restoration Tutorial: Getting Started](https://www.raywenderlich.com/1395-state-restoration-tutorial-getting-started)
> * 原文作者：[Luke Parham](https://www.raywenderlich.com/1395-state-restoration-tutorial-getting-started)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/state-restoration-tutorial-getting-started.md](https://github.com/xitu/gold-miner/blob/master/TODO1/state-restoration-tutorial-getting-started.md)
> * 译者：
> * 校对者：

# State Restoration Tutorial: Getting Started

In this state restoration tutorial, learn how to use Apple’s State Restoration APIs to enhance a user’s experience of your app.

_Note_: Updated for Xcode 7.3, iOS 9.3, and Swift 2.2 on 04-03-2016

State restoration is an often-overlooked feature in iOS that lets a user return to their app in the exact state in which they left it – regardless of what’s happened behind the scenes.

At some point, the operating system may need to remove your app from memory; this could significantly interrupt your user’s workflow. Your user also shouldn’t have to worry about switching to another app and losing all their work. This is where state restoration saves the day.

In this state restoration tutorial, you’ll update an existing app to add preservation and restoration functionalities and enhance the user experience for scenarios where their workflow is likely to be interrupted.

## Getting Started

Download the [starter project](https://koenig-media.raywenderlich.com/uploads/2016/01/PetFinder-Starter.zip) for this tutorial. The app is named _Pet Finder_; it’s a handy app for people who happen to be seeking the companionship of a furry feline friend.

Run the app in the simulator; you’ll be presented with an image of a cat that’s eligible for adoption:

[![Pet Finder](https://koenig-media.raywenderlich.com/uploads/2015/11/petfinder_intro_1-281x500.png)](https://koenig-media.raywenderlich.com/uploads/2015/11/petfinder_intro_1.png)

Swipe right to be paired up with your new furry friend; swipe left to indicate you’d rather pass on this ball of fluff. You can view a list of all your current matches from the _Matches_ tab bar:

[![Matches](https://koenig-media.raywenderlich.com/uploads/2015/10/petfinder_matches_1-281x500.png)](https://koenig-media.raywenderlich.com/uploads/2015/10/petfinder_matches_1.png)

Tap to view more details about a selected friend:

[![Details](https://koenig-media.raywenderlich.com/uploads/2015/10/petfinder_details_1-282x500.png)](https://koenig-media.raywenderlich.com/uploads/2015/10/petfinder_details_1.png)

You can even edit your new friend’s name (or age, if you’re into bending the truth):

[![Edit](https://koenig-media.raywenderlich.com/uploads/2015/10/petfinder_edit_2-281x500.png)](https://koenig-media.raywenderlich.com/uploads/2015/10/petfinder_edit_2.png)

You’d hope that when you leave this app annd return to it later, you’d be brought back to the same furry friend you were last viewing. But is this truly the case with this app? The only way to tell is to test it.

## Testing State Restoration

Run the app, swipe right on at least one cat, view your matches, then select one cat to view his or her details. Press _Cmd+Shift+H_ to return to the home screen. Any state preservation logic, should it exist, would run at this point.

Next, stop the app from Xcode:

[![Stop App](https://koenig-media.raywenderlich.com/uploads/2015/10/petfinder_stop_app-480x41.png)](https://koenig-media.raywenderlich.com/uploads/2015/10/petfinder_stop_app.png)

The state restoration framework intentionally discards any state information when the user manually kills an app, or when the state restoration process fails. These checks exist so that your app doesn’t get stuck in an infinite loop of bad states and restoration crashes. Thanks, Apple! :\]

_Note:_ You _cannot_ kill the app yourself via the app switcher, otherwise state restoration simply won’t work.

Launch the app again; instead of returning you to the pet detail view, you’re back at the home screen. Looks like you’ll need to add some state restoration logic yourself.

## Enabling State Restoration

The first step in setting up state restoration is to enable it in your app delegate. Open _AppDelegate.swift_ and add the following code:

```
func application(application: UIApplication, shouldSaveApplicationState coder: NSCoder) -> Bool {
  return true
}

func application(application: UIApplication, shouldRestoreApplicationState coder: NSCoder) -> Bool {
  return true
}
```

There are five app delegate methods that manage state restoration. Returning `true` in `application(_:shouldSaveApplicationState:)` instructs the system to save the state of your views and view controllers whenever the app is backgrounded. Returning `true` in `application(_:shouldRestoreApplicationState:)` tells the system to attempt to restore the original state when the app restarts.

You can make these delegate methods return `false` in certain scenarios, such as while testing or when the user’s running an older version of your app that can’t be restored.

Build and run your app, and navigate to a cat’s detail view. Press _Cmd+Shift+H_ to background your app, then stop the app from Xcode. You’ll see the following:

[![Pet Finder](https://koenig-media.raywenderlich.com/uploads/2015/11/petfinder_intro_1-281x500.png)](https://koenig-media.raywenderlich.com/uploads/2015/11/petfinder_intro_1.png)

[![confused](https://koenig-media.raywenderlich.com/uploads/2015/10/confused-365x320.png)](https://koenig-media.raywenderlich.com/uploads/2015/10/confused.png)

It’s the exact same thing you saw before! Just opting-in to state restoration isn’t quite enough. You’ve enabled preservation and restoration in your app, but the view controllers aren’t yet participating. To remedy this, you’ll need to give each of these scenes a _restoration identifier_.

## Setting Restoration Identifiers

A restoration identifier is simply a string property of views and view controllers that UIKit uses to restore those objects to their former glory. The actual content of those properties isn’t critical, as long as it’s unique. It’s the presence of a value that communicates to UIKit your desire to preserve this object.

Open _Main.storyboard_ and you’ll see a tab bar controller, a navigation controller, and three custom view controllers:

[![cinder_storyboard](https://koenig-media.raywenderlich.com/uploads/2015/10/cinder_storyboard-700x350.png)](https://koenig-media.raywenderlich.com/uploads/2015/10/cinder_storyboard.png)

Restoration identifiers can either be set in code or in Interface Builder. To make things easy, in this tutorial you’ll set them in Interface Builder. You _could_ go in and think up a unique name for each view controller, but Interface Builder has a handy option named _Use Storyboard ID_ that lets you use your Storyboard IDs for restoration identifiers as well.

In _Main.storyboard_, click on the tab bar controller and open the Identity Inspector. Enable the _Use Storyboard ID_ option as shown below:

[![Use Storyboard ID](https://koenig-media.raywenderlich.com/uploads/2015/10/petfinder_enable_restoration_id-480x320.png)](https://koenig-media.raywenderlich.com/uploads/2015/10/petfinder_enable_restoration_id.png)

This will archive the view controller and restore it during the state restoration process.

Repeat the process for the navigation controller and the three view controllers. Make sure you’ve checked Use Storyboard ID for each of the view controllers, or your app may not restore its state properly.

Note that all the controllers already have a _Storyboard ID_ and the checkbox simply uses the same string that you already have as _Storyboard ID_. If you are not using _Storyboard ID_s, you need to manually enter a unique _Restoration ID_.

Restoration identifiers come together to make _restoration paths_ that form a unique path to any view controller in your app; it’s analagous to URIs in an API, where a unique path identifies a unique path to each resource.

For example, the following path represents _MatchedPetsCollectionViewController_:

_RootTabBarController/NavigationController/MatchedPetsCollectionViewController_

With this bit of functionality, the app will remember which view controller you left off on (for the most part), and any UIKit views will retain their previous state.

Build and run your app; test the flow for restoration back to the pet details view. Once you pause and restore your app, you should see the following:

[![No Data](https://koenig-media.raywenderlich.com/uploads/2015/10/restoredNoData1-281x500.png)](https://koenig-media.raywenderlich.com/uploads/2015/10/restoredNoData1.png)

Although the system restores the correct view controller, it appears to be missing the cat object that’s needed to populate the view. How do you restore the view controller _and_ the objects it needs?

## The UIStateRestoring Protocol

When it comes to implementing state restoration, UIKit does a lot for you, but your app is responsible for a few things on its own:

1.  Telling UIKit it wants to participate in state restoration, which you did in your app delegate.
2.  Telling UIKit which view controllers and views should be preserved and restored. You took care of this by assigning restoration identifiers to your view controllers.
3.  Encoding and decoding any relevant data necessary to reconstruct the view controller to its previous state. You haven’t done this yet, but that’s where the `UIStateRestoring` protocol comes in.

Every view controller with a restoration identifier will receive a call to `encodeRestorableStateWithCoder(_:)` of the `UIStateRestoring` protocol when the app is saved. Additionally, the view controller will receive a call to `decodeRestorableStateWithCoder(_:)` when the app is restored.

To complete the restoration flow, you need to add logic to encode and decode your view controllers. While this part of the process is probably the most time-consuming, the concepts are relatively straightforward. You’d usually write an extension to add conformance to a protocol, but UIKit automatically registers view controllers to conform to `UIStateRestoring` — you merely need to override the appropriate methods.

Open _PetDetailsViewController.swift_ and add the following code to the end of the class:

```
override func encodeRestorableStateWithCoder(coder: NSCoder) {
  //1
  if let petId = petId {
    coder.encodeInteger(petId, forKey: "petId")
  }
  
  //2
  super.encodeRestorableStateWithCoder(coder)
}
```

Here’s what’s going on in the code above:

1.  If an ID exists for your current cat, save it using the provided encoder so you can retrieve it later.
2.  Make sure to call `super` so the rest of the inherited state restoration functionality will happen as expected.

With these few changes, your app now saves the current cat’s information. Note that you didn’t actually save the cat model object, but rather the ID you can use later to get the cat object. You use this same concept when saving your selected cats in `MatchedPetsCollectionViewController`.

Apple is quite clear that state restoration is _only_ for archiving information needed to create view hierarchies and return the app to its original state. It’s tempting to use the provided coders to save and restore simple model data whenever the app goes into the background, but iOS discards all archived data any time state restoration fails or the user kills the app. Since your user won’t be terribly happy to start back at square one each time they restart the app, it’s best to follow Apple’s advice and only save state restoration using this tactic.

Now that you’ve implemented encoding in _PetDetailsViewController.swift_, you can add the corresponding decoding method below:

```
override func decodeRestorableStateWithCoder(coder: NSCoder) {
  petId = coder.decodeIntegerForKey("petId")
  
  super.decodeRestorableStateWithCoder(coder)
}
```

Here you decode the ID and set it back to the view controller’s `petId` property.

The `UIStateRestoring` protocol provides `applicationFinishedRestoringState()` for additional configuration steps once you’ve decoded your view controller’s objects.

Add the following code to _PetDetailsViewController.swift_:

```
override func applicationFinishedRestoringState() {
  guard let petId = petId else { return }
  currentPet = MatchedPetsManager.sharedManager.petForId(petId)
}
```

This sets up the current pet based on the decoded pet ID and completes the restoration of the view controller. You could, of course, do this in `decodeRestorableStateWithCoder(_:)`, but it’s best to keep the logic separate since it can get unwieldy when it’s all bundled together.

Build and run your app; navigate to a pet’s detail view and trigger the save sequence by backgrounding the app then killing it via Xcode. Re-launch the app and verify that your same furry friend appears as expected:

[![Details](https://koenig-media.raywenderlich.com/uploads/2015/10/petfinder_details_1-282x500.png)](https://koenig-media.raywenderlich.com/uploads/2015/10/petfinder_details_1.png)

You’ve learned how to restore view controllers created via storyboards. But what about view controllers that you create in code? To restore storyboard-created views at run-time, all UIKit has to do is find them in the main storyboard. Fortunately, it’s almost as easy to restore code-based view controllers.

## Restoring Code-based View Controllers

The view controller `PetEditViewController` is created entirely from code; it’s used to edit a cat’s name and age. You’ll use this to learn how to restore code-created controllers.

Build and run your app; navigate to a cat’s detail view then click _Edit_. Modify the cat’s name but don’t save your change, like so:

[![Edit](https://koenig-media.raywenderlich.com/uploads/2015/10/petfinder_edit_2-281x500.png)](https://koenig-media.raywenderlich.com/uploads/2015/10/petfinder_edit_2.png)

Now background the app and kill it via Xcode to trigger the save sequence. Re-launch the app, and iOS will return you to the pet detail view instead of the edit view:

[![Details](https://koenig-media.raywenderlich.com/uploads/2015/10/petfinder_details_1-282x500.png)](https://koenig-media.raywenderlich.com/uploads/2015/10/petfinder_details_1.png)

Just as you did for the view controllers built in Interface Builder, you’ll need to provide a restoration ID for the view controller and add the encode and decode `UIStateRestoring` protocol methods to properly restore the state.

Take a look at _PetEditViewController.swift_; you’ll notice the encode and decode methods already exist. The logic is similar to the encode and decode methods you implemented in the last section, but with a few extra properties.

It’s a straightforward process to assign the restoration identifier manually. Add the following to `viewDidLoad()` right after the call to `super`:

```
restorationIdentifier = "PetEditViewController"
```

This assigns a unique ID to the `restorationIdentifier` view controller property.

During the state restoration process, UIKit needs to know where to get the view controller reference. Add the following code just below the point where you assign `restorationIdentifier`:

```
restorationClass = PetEditViewController.self
```

This sets up `PetEditViewController` as the restoration class responsible for instantiating the view controller. Restoration classes must adopt the `UIViewControllerRestoration` protocol and implement the required restoration method. To that end, add the following extension to the end of _PetEditViewController.swift_:

```
extension PetEditViewController: UIViewControllerRestoration {
  static func viewControllerWithRestorationIdentifierPath(identifierComponents: [AnyObject], 
      coder: NSCoder) -> UIViewController? {
    let vc = PetEditViewController()
    return vc
  }
}
```

This implements the required `UIViewControllerRestoration` protocol method to return an instance of the class. Now that UIKit has a copy of the object it’s looking for, iOS can call the encode and decode methods and restore the state.

Build and run your app; navigate to a cat’s edit view. Change the cat’s name as you did before, but don’t save your change, then background the app and kill it via Xcode. Re-launch your app and verify all the work you did to come up with a great unique name for your furry friend was not all in vain!

[![Edit](https://koenig-media.raywenderlich.com/uploads/2015/10/petfinder_edit_2-281x500.png)](https://koenig-media.raywenderlich.com/uploads/2015/10/petfinder_edit_2.png)

## Where to Go From Here?

You can [download the completed project here](https://koenig-media.raywenderlich.com/uploads/2016/01/PetFinder-Completed-1.zip). The state restoration framework is an extremely useful tool in any iOS developers toolkit; you now have the knowledge to add basic restoration code to any app and improve your user experience just a little more.

For further information on what’s possible with this framework, check out the [WWDC videos from 2012](https://developer.apple.com/videos/play/wwdc2012-208/) and [2013](https://developer.apple.com/videos/play/wwdc2013-222/). The 2013 presentation is especially useful since it covers restoration concepts introduced in iOS 7 such as `UIObjectRestoration` for saving and restoring arbitrary objects and `UIDataSourceModelAssociation` for restoring table and collection views in apps with more complicated needs.

If you have any questions or comments about this tutorial, please join the forum discussion below!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
