> * 原文地址：[Playground driven development in Swift](https://medium.com/flawless-app-stories/playground-driven-development-in-swift-cf167489fe7b)
> * 原文作者：[Khoa Pham](https://medium.com/@onmyway133?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/playground-driven-development-in-swift.md](https://github.com/xitu/gold-miner/blob/master/TODO1/playground-driven-development-in-swift.md)
> * 译者：
> * 校对者：

# Playground driven development in Swift

![](https://cdn-images-1.medium.com/max/2000/1*EbrVuz1m60emAKFrBdboCg.png)

### The need to quickly tweak UI

Our mission as mobile developers is to provide the best user experience for the end users, to make life more engaging and easier for them through dedicated apps. One of the tasks is to make sure the UI, the thing that users see, looks good and correct. Most of the time, we can say that app is a prettifier of data. We mostly fetch JSON data from backend, parse it to model and then render it using `UIView`, mostly `UITableView` or `UICollectionView`.

For iOS, we need to continuously tweak the UI according to the design to make it fit small sized handheld devices. That process involves us changing code, compiling, waiting, checking, then changing code and much more…Tools like [Flawless App](https://flawlessapp.io/) helps to easily compare between result on iOS app and Sketch design. But the real pain lies in the [compiling](https://medium.com/@johnsundell/improving-swift-compile-times-ee1d52fb9bd) part, which takes the most time, and that is even worse with [Swift](https://github.com/fastred/Optimizing-Swift-Build-Times). It makes us less efficient to do quick iteration. It looks like the compiler is mining Bitcoin secretly while pretending to compile 😅

If you work with [React](https://reactjs.org/), you know that it is just merely UI representation of state `UI = f(state).`You get some data, you build a UI to represent it. React has [hot reloader](https://github.com/gaearon/react-hot-loader) and [Storybook](https://github.com/storybooks/storybook) which make it super fast to do UI iterations. You make some changes and see the result immediately. You also get a complete overview of all the possible UIs for each state. You know you want the same thing in iOS!

### Playground

Together with the [introduction of Swift in WWDC 2014](https://developer.apple.com/videos/play/wwdc2014/408/), Apple also introduced Playground, which is said to be “a new and innovative way to explore the Swift programming language”.

I wasn’t very convinced at first, and I saw lots of complains about slow or unresponsive Playground. But after seeing [Kickstarter iOS app](https://github.com/kickstarter/ios-oss) using Playground to faster their styling and development process, it impressed me a lot. So I started using it successfully in some of the apps. It is not rerendering immediately like [React Native](https://facebook.github.io/react-native/) or [Injection App](http://johnholdsworth.com/injection.html), but hopefully it will be better over the years 😇

Or at least it depends on the development community. The scenario with Playground is that we only style one screen or component at a time. That forces to think carefully about dependencies, so I can just import a particular screen and iterate on that in Playground.

### Custom framework in Playground

Xcode 9 allows to import [custom framework in Playground](https://help.apple.com/xcode/mac/9.0/#/devc9b33111c) as long as the framework is in the same workspace as the Playground. We can use [Carthage](https://github.com/Carthage/Carthage) to fetch custom framework and build it. But if we are using CocoaPods then it is viable too.

![](https://cdn-images-1.medium.com/max/800/1*ZYy8VCrA3i2tI3zpIXwmEw.png)

### Creating app framework

Playground can’t access code in the same workspace, or parent project if the Playground is added as nested project. For this to work, you need to create a framework and add source files that you intend to work in Playground. Let’s call it app framework.

The [demo](https://github.com/onmyway133/UsingPlayground) for this article is an iOS project that uses CocoaPods to manage dependencies. For the time of this post, it is Xcode 9.3 and Swift 4.1.

Let’s walk through steps on making Playground work with project that uses CocoaPods. There are also some good practices.

#### Step 1: Adding a pod

I mostly use CocoaPods to manage dependencies. In some screens, there certainly will be some pods involved. So for our app framework to work, it needs to link with some pods.

Create a new project, let’s call it `UsingPlayground`. The app shows some kind of confetti particles 🎊. There are many options to adjust the way those particles show up, and I choose Playground to iterate on that.

For this demo, we will use CocoaPods to fetch one dependency called [Cheers](https://github.com/hyperoslo/Cheers) because we want something fun. `Cheers` helps show fancy confetti effect if you want to congratulate users with some achievements.

Create a `Podfile` with `UsingPlayground` as app [target](https://guides.cocoapods.org/syntax/podfile.html#target):

```
platform :ios, ‘9.0’
use_frameworks!
pod ‘Cheers’
target ‘UsingPlayground’
```

#### Step 2: Using the pod in your app project

After running `pod install` CocoaPods generates a new workspace with 2 projects. 1 is our app project, the other one is a project with all the pods, for now there is just Cheers. Close your project and open the generated workspace instead.

This is very straightforward, just to make sure the pod works. Write some code to use the Cheers:

```
public class ViewController: UIViewController {
  public override func viewDidLoad() {
    super.viewDidLoad()

    let cheerView = CheerView()
    view.addSubview(cheerView)
    cheerView.frame = view.bounds

    // Configure
    cheerView.config.particle = .confetti

    // Start
    cheerView.start()
  }
}
```

Build and run the project to enjoy a very fascinating confetti 🎊

#### Step 3: Adding a CocoaTouch framework

For our code to be accessible in Playground, we need to set it into a framework. In iOS, it is the CocoaTouch framework target.

In your workspace select the `UsingPlayground` project and add new CocoaTouch framework. This is the framework that contains our app code. Let’s call it `AppFramework`.

![](https://cdn-images-1.medium.com/max/800/0*0C17R-Oym31N9BYA.png)

Now add the source files you want to test into this framework. For now, just check file `ViewController.swift` and add it to the `AppFramework` target.

![](https://cdn-images-1.medium.com/max/800/1*Jap3CnRcDmSyo-4aykWsLA.png)

For this simple project, there is only one `ViewController.swift` . If this file references code from other files, you need to add related files to the `AppFramework` target too. This is how you should be clever about [dependencies](https://en.wikipedia.org/wiki/Dependency_inversion_principle).

#### Step 4: Adding files to AppFramework

`ViewController` in iOS mostly lies in UI layer, so it should just get the parsed data and render it using UI components. If you have some logic, those may involves other parts like Caching, Networking, … which require you to add more files to AppFramework. Small, independent framework is more reasonable and allows us to iterate quickly.

Playground is no magic. You need to compile your AppFramework for every time you change the code, otherwise the changes won’t be reflected in your Playground. If you don’t mind slow compile time, you can add all files to your `AppFramework` . Simply expanding group folders, selecting and adding files to the target takes a lot of time. Not to mention that if you select both folder and files, you won’t be able to add them to your target. You can only add files to your target.

![](https://cdn-images-1.medium.com/max/800/1*cOThYP8EGPrjsDnx06Zg1A.png)

A quicker way is to go to `Compile Sources` under your `AppFramework` target `Build Phase` . Here all files are expanded automatically for you, all you need to do is to select them and click `Add` .

![](https://cdn-images-1.medium.com/max/800/1*bROv-S-aMElSPB7BpEOhwA.png)

#### Step 5: Public

Swift types and methods are internal by default. So in order for them to be visible in the Playground, we need to declare them as public. Feel free to read more about [Access Level](https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/AccessControl.html#//apple_ref/doc/uid/TP40014097-CH41-ID5) in Swift:

> _Open access_ and _public access_ enable entities to be used within any source file from their defining module, and also in a source file from another module that imports the defining module. You typically use open or public access when specifying the public interface to a framework.

```
public class ViewController: UIViewController {
  // Your code goes here
}
```

#### Step 6: Adding pod to AppFramework

In order for `AppFramework` to use our pods, we need to add those pods into framework target as well. Add `target ‘AppFramework’` to your `Podfile:`

```
platform :ios, ‘9.0’
use_frameworks!
pod ‘Cheers’
target ‘UsingPlayground’
target ‘AppFramework’
```

Now run `pod install` again. In some rare cases, you need to run `pod deintegrate` and `pod install` to start from a clean slate.

#### Step 7: Adding a Playground

Add a Playground and drag that to our workspace. Let’s call it `MyPlayground.`

![](https://cdn-images-1.medium.com/max/800/1*j9II1EmZWpOCFiY3TQl0YA.png)

![](https://cdn-images-1.medium.com/max/800/1*8YWhaZtgb7aSQF1pthuNZA.png)

#### Step 8: Enjoy

Now is the final step: writing some code. Here we need to import our `AppFramework` and `Cheers` in our Playground. We need to import all the pods that is used in the Playground, just like we do in our app project.

Playground is best for testing our framework independently or our app. Select `MyPlayground` and type the code below. Here we tell `liveView` to render our `ViewController:`

```
import UIKit
import AppFramework
import PlaygroundSupport

let controller = ViewController()
controller.view.frame.size = CGSize(width: 375, height: 667)
PlaygroundPage.current.liveView = controller.view
```

Sometimes you want to test a piece of the pod you want to use. Create a new `Playground Page` called `CheersAlone`. Here you just need to import `Cheers.`

![](https://cdn-images-1.medium.com/max/800/1*k6eGq11QDCwJInOxGBf9AQ.png)

```
import UIKit
import Cheers
import PlaygroundSupport

// Use cheer alone
let cheerView = CheerView()
cheerView.frame = CGRect(x: 0, y: 50, width: 200, height: 400)

// Configure
cheerView.config.particle = .confetti(allowedShapes: [.rectangle, .circle])

// Start
cheerView.start()

PlaygroundPage.current.liveView = cheerView
```

Let’s use [liveView](https://developer.apple.com/documentation/playgroundsupport/playgroundpage/1964506-liveview) of `PlaygroundPage` to display a live view. Remember to toggle Editor Mode so you can see Playground result. And 🎉

![](https://cdn-images-1.medium.com/max/800/1*fY6TpydIPaDMRUBudSLopw.png)

There is a button in the bottom panel of Xcode. That’s where you can toggle between `Automatically Run` and `Manual Run` behaviour. And you can stop and start the Playground by yourself. Pretty neat 🤘

### Bridging header

Chances are that your app needs to deal with some prebuilt binary pod that exposes APIs via header. In some of the apps, I use [BuddyBuildSDK](https://cocoapods.org/?q=buddybuildsdk) for crash reports. If you take a look at its [podspec](https://github.com/CocoaPods/Specs/blob/master/Specs/d/4/5/BuddyBuildSDK/1.0.17/BuddyBuildSDK.podspec.json#L24), you‘ll see that it uses a public header called `BuddyBuildSDK.h`. In our app project, CocoaPods manages this nicely. All you need to do is to import the header in your app target via `Bridging-Header.h`

If you need a review of how to use bridging header, read [Swift and Objective-C in the Same Project](https://developer.apple.com/library/content/documentation/Swift/Conceptual/BuildingCocoaApps/MixandMatch.html).

```
#ifndef UsingPlayground_Bridging_Header_h
#define UsingPlayground_Bridging_Header_h

#import <BuddyBuildSDK/BuddyBuildSDK.h>

#endif
```

Just make sure the path to the header is correct:

![](https://cdn-images-1.medium.com/max/800/1*ibjorHdbDd_XMSRGOf3J8Q.png)

#### Step 1: Import Bridging Header

But our `AppFramework` target will have a hard time finding that `BuddyBuildSDK.h`

> Using bridging headers with framework targets is unsupported

The solution is to refer to that `Bridging-Header.h` inside your `AppFramework.h`

```
#import <UIKit/UIKit.h>

//! Project version number for AppFramework.
FOUNDATION_EXPORT double AppFrameworkVersionNumber;

//! Project version string for AppFramework.
FOUNDATION_EXPORT const unsigned char AppFrameworkVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <AppFramework/PublicHeader.h>

#import "Bridging-Header.h"
```

![](https://cdn-images-1.medium.com/max/800/1*iKT_k0n8gozJSEAxvx2uUA.png)

#### Step 2: Public header

After doing above, you will get

> Include of non-modular header inside framework module

For this to work, you need to add the `Bridging-Header.h` to the framework, and declare it as `public`. A search on SO shows this [quote](https://stackoverflow.com/questions/7439192/xcode-copy-headers-public-vs-private-vs-project)

> **Public:** The interface is finalized and meant to be used by your product’s clients. A public header is included in the product as readable source code without restriction.
>
> **Private:** The interface isn’t intended for your clients or it’s in early stages of development. A private header is included in the product, but it’s marked “private”. Thus the symbols are visible to all clients, but clients should understand that they’re not supposed to use them.
>
> **Project:** The interface is for use only by implementation files in the current project. A project header is not included in the target, except in object code. The symbols are not visible to clients at all, only to you.

So, select `Bridging-Header.h` and add it to `AppFramework` and set visibility as `public:`

![](https://cdn-images-1.medium.com/max/800/1*Mp-FeCeU9qtEWc5Thx75PA.png)

If you go to `Build Phases` of `AppFramework` you will see the 2 header files there.

![](https://cdn-images-1.medium.com/max/800/1*nQv6XSSH_-ptsDX_nUOQHg.png)

Now, select scheme `AppFramework` and hit `Build`, it should compile without any errors.

### Fonts, localised strings, images and bundle

Our screen does not simply contains views from another pods. More often we display texts and images from our bundle. Let’s add an Iron Man image to our `Asset Catalog` and a `Localizable.strings`. The `ResourceViewController` contains one`UIImageView` and one`UILabel.`

```
import UIKit
import Anchors

public class ResourceViewController: UIViewController {
  let imageView = UIImageView()
  let label = UILabel()

  public override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = UIColor.gray

    setup()
    imageView.image = UIImage(named: "ironMan")
    label.text = NSLocalizedString("ironManDescription", comment: "Can't find localised string")
  }

  private func setup() {
    imageView.contentMode = .scaleAspectFit
    label.textAlignment = .center
    label.textColor = .black
    label.font = UIFont.preferredFont(forTextStyle: .headline)
    label.numberOfLines = 0

    view.addSubview(imageView)
    view.addSubview(label)

    activate(
      imageView.anchor.width.multiplier(0.6),
      imageView.anchor.height.ratio(1.0),
      imageView.anchor.center,

      label.anchor.top.equal.to(imageView.anchor.bottom).constant(10),
      label.anchor.paddingHorizontally(20)
    )
  }
}
```

Here I use [Anchors](https://github.com/onmyway133/Anchors) for convenient and declarative Auto Layout 🤘. It is also for showing later how Swift Playground can handle any number of frameworks.

Now, select the app scheme `UsingPlayground` and hit build and run. The app should look like below, and of course it can pick up the right image and localised string.

![](https://cdn-images-1.medium.com/max/800/1*4gH9VnqAP7wvJfRAQIoo1w.png)

Let’s see if our Playground can recognise these assets. Create a new page in `MyPlayground` called `Resource` and type the following

```
import UIKit
import AppFramework
import PlaygroundSupport

let controller = ResourceViewController()
controller.view.frame.size = CGSize(width: 375, height: 667)

PlaygroundPage.current.liveView = controller.view
```

Wait a bit for the Playground to finish running. Oops. Things are not so great in the Playground, it does not recognise the images and localised strings 😢

![](https://cdn-images-1.medium.com/max/800/1*Vgzy7nGWLfnydX3SOjmD4Q.png)

#### Resources folder

Actually each `Playground Page` has a `Resources` folder where we can put resource files that is seen by this particular page. But here we need to access resource in our app bundle.

#### Main bundle

When accessing image and localised string, if you don’t specify `bundle` , the running app will by default pick up the resources in the main bundle. Here is more info [Finding and Opening a Bundle](https://developer.apple.com/documentation/foundation/bundle).

> Before you can locate a resource, you must first specify which bundle contains it. The `Bundle`class has many constructors, but the one you use most often is `[main](https://developer.apple.com/documentation/foundation/bundle/1410786-main)`. The main bundle represents the bundle directory that contains the currently executing code. So for an app, the main bundle object gives you access to the resources that shipped with your app.

> If your app interacts directly with plug-ins, frameworks, or other bundled content, you can use other methods of this class to create appropriate bundle objects.

```
// Get the app's main bundle
let mainBundle = Bundle.main

// Get the bundle containing the specified private class.
let myBundle = Bundle(for: NSClassFromString("MyPrivateClass")!)
```

#### Step 1: Adding resources to AppFramework target

So firstly, we need to add resource files to our AppFramework target. Select `Asset Catalog` and `Localizable.strings` and add them to our `AppFramework` target.

![](https://cdn-images-1.medium.com/max/800/1*mI2C1ode8HGlBe4-zp_5ew.png)

#### Step 2: Specifying bundle

If we don’t specify bundle, then by default `mainBundle` is used. In the context of the executed Playground, `mainBundle` refers to the its `Resources` folder. But we want the Playground to access resources in the AppFramework, so we need to use`[Bundle.nit(for:)](https://developer.apple.com/documentation/foundation/bundle/1417717-init)` with a class in `AppFramework` to refer to the bundle inside `AppFramework`. That class can be `ResourceViewController` as it is added to `AppFramework` target too.

Change the code in `ResourceViewController` to

```
let bundle = Bundle(for: ResourceViewController.self)
imageView.image = UIImage(named: "ironMan", in: bundle, compatibleWith: nil)
label.text = NSLocalizedString(
  "ironManDescription", tableName: nil,
  bundle: bundle, value: "", comment: "Can't find localised string"
)
```

Every time we change code in `AppFramework`, we need to recompile it. This is important. Now open the Playground, it should pick up the right assets.

![](https://cdn-images-1.medium.com/max/800/1*M0_mNdOVjjV3FjAY4eRy7A.png)

#### What about custom font?

We need to register fonts in order to use. Instead of using `Fonts provided by application` key in plist, we can use `CTFontManagerRegisterFontsForURL` to register custom fonts. This is handy because the font can be dynamically registered in Playground too.

Download a free font called [Avengeance](http://www.fontspace.com/the-fontry/avengeance) and add this font to both our app and `AppFramework` target.

Add the code to specify font in `ResourceViewController`, remember to recompile `AppFramework :`

```
// font
let fontURL = bundle.url(forResource: "Avengeance", withExtension: "ttf")
CTFontManagerRegisterFontsForURL(fontURL! as CFURL, CTFontManagerScope.process, nil)
let font = UIFont(name: "Avengeance", size: 30)!
label.font = font
```

And tada, both your app and Playground can see the custom font 🎉

![](https://cdn-images-1.medium.com/max/800/1*Iz6t5ai_1hZa0lkdtAkblg.png)

### Device size and trait collection

iOS 8 introduced [TraitCollection](https://developer.apple.com/documentation/uikit/uitraitcollection) which defines size classes, scale and user interface idiom, which simplifies device describing. The kickstarter-ios project has handy utility to prepare `UIViewController` for using in Playground under different traits. See [playgroundController](https://github.com/kickstarter/ios-oss/blob/master/Kickstarter-iOS.playground/Sources/playgroundController.swift):

```
public func playgroundControllers(device: Device = .phone4_7inch,
                                  orientation: Orientation = .portrait,
                                  child: UIViewController = UIViewController(),
                                  additionalTraits: UITraitCollection = .init())
  -> (parent: UIViewController, child: UIViewController) {
```

And [AppEnvironment](https://github.com/kickstarter/ios-oss/blob/1b21ce9100edc2700b30f41432f4c6077febba69/Library/AppEnvironment.swift), which is like a stack to change dependencies and app properties, like bundle, locale and language. See one example about [Signup screen](https://github.com/kickstarter/ios-oss/blob/7b7be2f6ca7012bef04db90a6ed64f03f661a8f2/Kickstarter-iOS.playground/Pages/Signup.xcplaygroundpage/Contents.swift):

```
import Library
import PlaygroundSupport
@testable import Kickstarter_Framework

// Instantiate the Signup view controller.
initialize()
let controller = Storyboard.Login.instantiate(SignupViewController.self)

// Set the device type and orientation.
let (parent, _) = playgroundControllers(device: .phone4inch, orientation: .portrait, child: controller)

// Set the device language.
AppEnvironment.replaceCurrentEnvironment(
  language: .en,
  locale: Locale(identifier: "en") as Locale,
  mainBundle: Bundle.framework
)

// Render the screen.
let frame = parent.view.frame
PlaygroundPage.current.liveView = parent
```

### Couldn’t lookup symbols

You may get some errors when using Playground. Some of them are because of your code, some are because of the way framework is configured. For me, after upgrading to [CocoaPods 1.5.0](http://blog.cocoapods.org/CocoaPods-1.5.0/), I get this:

```
error: Couldn’t lookup symbols:

__T06Cheers9CheerViewCMa

__T012AppFramework14ViewControllerCMa

__T06Cheers8ParticleO13ConfettiShapeON

__T06Cheers6ConfigVN
```

Problem with symbol lookup means that Playground can’t find your code. It may be because your class is not exposed as public, or you forget to add files to `AppFramework` target. Or the referenced pods is not visible in `AppFramework` `Framework search path` , …

Version 1.5.0 brings static library support, also changes in modular header. In the mean time, the demo switches back to `CocoaPods 1.4.0`, you can take a look at [UsingPlayground demo](https://github.com/onmyway133/UsingPlayground).

In the terminal, type `bundler init` to generate `Gemfile`. Specify 1.4.0 for `cocoapods` gem:

```
# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) {|repo_name| "https://github.com/#{repo_name}" }

gem "cocoapods", '1.4.0'
```

Now run `bundler exec pod install` to run pod commands from `CocoaPods 1.4.0`. The problem should be solved.

### Where to go from here

Swift Playground also has support for `macOS` and `tvOS`. Here are some interesting links if you want to find out more

*   [Playground Driven Development](https://www.youtube.com/watch?v=DrdxSNG-_DE) The presentation by [Brandon Williams](https://medium.com/@mbrandonw) and the [kickstarter-ios](https://github.com/kickstarter/ios-oss/tree/master/Kickstarter-iOS.playground) project inspires in how Playground can be used in production apps. Also, the talk at objc.io about [Playground-Driven Development](https://talk.objc.io/episodes/S01E51-playground-driven-development-at-kickstarter) is really good.
*   PointFree: The [website](https://github.com/pointfreeco/pointfreeco/tree/master/PointFree.playground) is done with the help of Playground. You can learn lots of things just by reading the code and their project structure.
*   [Using Swift to Visualize Algorithms](https://www.youtube.com/watch?v=7e13FierAF8&index=3&list=PLCl5NM4qD3u92PwamgwWr3e_j3GmKRVTs): Playground is also good to prototype and visualise your ideas.
*   My friend Felipe also wrote how he successfully use Playground at work in his talk [How to not get sand in your eyes](https://github.com/fespinoza/Talks/tree/master/2018-03-20-how-not-get-sand-in-your-eyes)
*   Also, [Umberto Raimondi](https://medium.com/@uraimo) curates a list of [awesome Playground](https://github.com/uraimo/Awesome-Swift-Playgrounds) if you want to be amazed.

Thanks to [Lisa Dziuba](https://medium.com/@lisadziuba?source=post_page).


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
