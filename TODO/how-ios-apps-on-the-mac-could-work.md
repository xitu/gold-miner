>* 原文链接 : [How iOS Apps on the Mac Could Work](https://medium.com/@sandofsky/how-ios-apps-on-the-mac-could-work-13aa32a2647b)
* 原文作者 : [Ben Sandofsky](https://medium.com/@sandofsky)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : 
* 校对者:

![](https://cdn-images-1.medium.com/max/800/1*o5AUFxXTmRcAr17x1p6m6A.jpeg)

### How iOS Apps on the Mac Could Work

Nobody builds apps for the Mac. Slack has a solid iOS that scales up to the iPad just fine. Attach the smart keyboard, and you’ll find keyboard shortcuts. It scrolls better than their site, and I never see a loading screen. It’s a perfect candidate to run on the desktop, yet they wrap their site in an app-launcher and call it a day.

Basecamp? A web view. Wordpress? Web view. Event the Mac App Store _itself_ is a webview.

I hate imposter apps, but I get why companies settle. Big companies **hate** adding platforms. Designers need to build more designs, QA needs to test more environments, and business people struggle to translate “native app views” into the accepted industry metric, “page views.” It’s no wonder companies resisted native mobile development for years in lieu of cross-platform HTML5 apps.

If you needed a stronger case to ignore the Mac: it isn’t just a “Compile for OS X” checkbox. You need to hire developers with OS X specialization, and maintain a parallel codebase.

This isn’t just Big Company Bean-Counting.™ Take Sketch, absent from iOS [citing risk](https://www.designernews.co/comments/173706):

> We cannot port Sketch to the iPad if we have no reasonable expectation of earning back on our investment. Maintaining an application on two different platforms and provide one of them for a 10th of it’s value won’t work, and iPad volumes are low enough to disqualify the “make it up in volume” argument.

They think trials are an essential way to reduce risk. I think another option is to make supporting iPad so effortless you have to ask, “Why not?”

Let’s be clear: a lazy port of an iOS App to OS X is a terrible user experience. You should rethink touch-screen interactions for a keyboard and mouse. But there are significant areas that don’t need reimagining. If you ask Pinterest to rewrite its iconic layout for a different UI framework, it’ll shrug its shoulders and wrap its site in a webview.

### Where iOS and OS X Diverge

While OS X and iOS share a ton of lower-level APIs, they completely diverge around the UI. The former is powered by AppKit, which goes back to NeXT, and the latter is powered by UIKit, was which written from the ground up to support the iPhone.

It cuts all the way down to the coordinate system. On OS X, the origin sits on the lower left, while on iOS it’s [the upper left](https://developer.apple.com/library/ios/documentation/General/Conceptual/Devpedia-CocoaApp/CoordinateSystem.html):

![](https://cdn-images-1.medium.com/max/800/1*SJU8WmP-aHgrwlT92oCRAw.jpeg)

But UIKit diverges on an even deeper level: it was designed around GPU accelerated rendering. Every _UIView_ is backed by a Core Animation **layer,** which works hand-in-hand with the GPU for silky-smooth scrolling**.**

When Core Animation made it back to the Mac, layers were opt-in, presumably for backward compatibility. Even when you enable them, they feel grafted on _NSView._

There are UIKit reimplementations like [TwUI](https://github.com/twitter/twui) and [Chameleon](http://chameleonproject.org), the latter seeking an identical API. In theory, you could share 100% of your UI code between platforms. In practice, these frameworks fight an uphill battle, because they third-party.

Even among Apple’s Mac developers, there’s demand for a UIKit architecture. Last year’s Photos.app [included UXKit](https://sixcolors.com/post/2015/02/new-apple-photos-app-contains-uxkit-framework/), and Game Center uses a [UICollectionView replica](https://twitter.com/steipete/status/740065011712806912).

### What I Expect

Don’t expect today’s iOS apps to launch on macOS without any changes. [Look at tvOS](https://developer.apple.com/library/tvos/documentation/General/Conceptual/AppleTV_PG/index.html#//apple_ref/doc/uid/TP40015241).

> tvOS is derived from iOS but is a distinct OS, including some frameworks that are supported only on tvOS.

It runs UIKit, with just enough stripped out to _force_ you to rewrite your interactions for a TV experience.

#### One Bundle to Rule Them All?

TV apps have such a different interaction model than a touch screen, you’ll probably end up with a radically different design.

> When porting an existing project, you can include an additional target in your Xcode project to simplify sharing of resources, but you need to create new storyboards for tvOS. Likely, you will need to look at how users navigate through your app and adapt your app’s user interface to Apple TV.

Even if you could bundle a tvOS app with your iOS app, the disadvantages (e.g. coupled releases) outweigh the advantages of shared code. I’ve known iOS developers who regretted shipped a universal iPhone/iPad app, because of the tight coupling. Sometimes you’re just better off just putting that shared code into a framework.

That said, if you look at most of Apple’s ports between Mac and iOS, they’re very similar. If Apple envisions the Mac and iOS experience as mostly similar, it’s very likely you could bundle a Mac app with your iOS one.

As a developer, only dealing with a single app with a single bundle ID simplifies stuff like sharing data between devices. Again, this is about reducing for existing iOS devs to add a new platform.

What about download size? Since one runs on x86 and the other runs ARM, you’d need two architectures bundled into one binary, similar to [fat binaries](https://en.wikipedia.org/wiki/Universal_binary), from the Mac’s transition to Intel. Well in iOS 9, Apple introduced [App Thinning](https://developer.apple.com/library/tvos/documentation/IDEs/Conceptual/AppDistributionGuide/AppThinning/AppThinning.html), so you only download the code that runs on your native platform.

![](http://ww3.sinaimg.cn/large/a490147fjw1f4w49p8mtcj20m80ck75n.jpg)

#### Interface Idioms

In iOS 8, Apple added “trait collection,” and attribute that lets you check details of your platform. The [Interface Idiom](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIDevice_Class/index.html#//apple_ref/c/tdef/UIUserInterfaceIdiom) property today includes **iPhone**, **iPad**, **TV**, or **CarPlay**. You can check the idiom to know if certain views are available; for example, popover are only available on iPad.

In theory you could restrict Mac features, like floating palettes, to a **Mac** idiom.

#### Sandboxing

In 2011, Apple added [sandboxing](https://developer.apple.com/library/mac/documentation/Security/Conceptual/AppSandboxDesignGuide/AboutAppSandbox/AboutAppSandbox.html) to OS X. If you’re porting an iOS app to OS X, it _should_ just work.

#### Handing Larger Sizes

What about the coordinate system? If you’re using _Auto Layout_ it shouldn’t matter. Instead of assigning hard coding coordinates, you specify rules for how the views should lay out, relative to each other. It’s like CSS, but not horrible.

In the following example from [the docs](https://developer.apple.com/library/ios/documentation/UserExperience/Conceptual/AutolayoutPG/index.html#//apple_ref/doc/uid/TP40010853-CH7-SW1), each blue line is a rule (_constraint)_. So long the rules make sense, Auto Layout will just figure it out for you:

![](http://ww4.sinaimg.cn/large/a490147fjw1f4w4a1jmg5j20g00klaam.jpg)

There’s not a _(0, 0)_ in sight. You can resize that window to any size and it just works.

Unfortunately, many apps are still using hard-coded values. It’s likely Apple will flip the coordinate system, exclusively for apps running UIKit. If you link against AppKit, you get the existing coordinate system. It would just complicate things if you mix-and-match UIKit and AppKit in one app.

#### Avoiding Giant iPhone Apps

What about the “Stretch out the iPhone App” UX abomination? They already dealt with it on iPad with [Size Classes](https://developer.apple.com/library/ios/documentation/UserExperience/Conceptual/MobileHIG/LayoutandAppearance.html), which encourage designing for screen real-estate space, not hardware. Each dimension can be either “compact” or “regular.” For example, an iPhone’s width is considered _compact_, and a full screen iPad app is _regular_. From the docs:

![](http://ww2.sinaimg.cn/large/a490147fjw1f4w4aew3srj20df0gz3yt.jpg)

![](http://ww2.sinaimg.cn/large/a490147fjw1f4w4aq64lpj208r0e6mxc.jpg)

So if you’re Facebook, and you only want to show trending topics on the side of the screen when you have a lot of available real-estate, you can can that you’re in a “regular” width. Why not just check if it’s iPad? An iPad app can change from _regular_ to _compact_ if the user starts multitasking, and shrinks the app.

The Mac could operate the same way, changing size classes when you resize the window past certain thresholds.

### Sooner Rather than Later

Every WWDC for the last five years, I’ve thought, “This could be the year.” The difference from then and now? My outlook has changed from “wishful thinking” to “inevitable.”

It’s in Apple’s best interest to get professional apps, like Sketch, on iOS. Take Lightroom for iOS, which doesn’t support RAW processing; that makes the iPad “Pro” a joke for professional photographers. Contrast that with the Microsoft Surface, which runs the realLightroom_._

It looks like even Apple has abandoned OS X. They [aren’t hiring](https://twitter.com/toddthomas/status/740045058787803136) any new AppKit developers, and the the Mac App Store has been broken for years. What if they’re finally abandoning the old platform to pour all resources into the unified one?

In the last five years, Apple has changed. iOS 7 showed they’re willing to break from tradition. Apple Watch showed they’re willing to take risks, because, “Why not?” They haven’t taken a risk on the Mac since 2010, with the “Back to the Mac” event.

They say Mac OS X will be rebranded “macOS” for WWDC 2016\. This could be the year.

