>* 原文链接 : [How iOS Apps on the Mac Could Work](https://medium.com/@sandofsky/how-ios-apps-on-the-mac-could-work-13aa32a2647b)
* 原文作者 : [Ben Sandofsky](https://medium.com/@sandofsky)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [wildflame](https://github.com/wildflame)
* 校对者:

![](https://cdn-images-1.medium.com/max/800/1*o5AUFxXTmRcAr17x1p6m6A.jpeg)

## Mac 归来 -  WWDC 2016

### How iOS Apps on the Mac Could Work

假如 Mac 上也有 iOS 应用，世界将会怎样？

Nobody builds apps for the Mac. Slack has a solid iOS that scales up to the iPad just fine. Attach the smart keyboard, and you’ll find keyboard shortcuts. It scrolls better than their site, and I never see a loading screen. It’s a perfect candidate to run on the desktop, yet they wrap their site in an app-launcher and call it a day.

没有人专门为 Mac 开发应用，Slack 有专门的 iOS 版本，放在 Ipad 上的体验非常好，接上蓝牙键盘以后，你会发现还可以方便使用的快捷键。而且，在应用上无限下滑的体验甚至超过了他们本身的网页端，甚至于我从来没有看到过一个载入的页面。这体验如果能够放到桌面端那是再好不过了，但是他们没有这么做，他们仅仅只是把他们的网页放到了一个 app-launcher 里，这就成了桌面端。

Basecamp? A web view. Wordpress? Web view. Even the Mac App Store _itself_ is a web view.

Basecamp 是这么做的，Wordpress 是这么做的，甚至连 Mac App Store 自己，都只是一个 webview 而已。

I hate imposter apps, but I get why companies settle. Big companies **hate** adding platforms. Designers need to build more designs, QA needs to test more environments, and business people struggle to translate “native app views” into the accepted industry metric, “page views.” It’s no wonder companies resisted native mobile development for years in lieu of cross-platform HTML5 apps.

对于那些所谓的“应用”，我是再讨厌不过了。我理解大公司们的选择，他们**不喜欢**跨平台。设计师门需要专门做设计，QA 需要测试更多的环境，而销售则要费力去翻译那些“原生视图”到更为工业界接受的“页面视图”（注：校对麻烦帮忙看一下，销售到底是在作甚...）。那些大公司一直不愿意费力气去替代跨平台的 Html 5 应用也毫不奇怪了。

If you needed a stronger case to ignore the Mac: it isn’t just a “Compile for OS X” checkbox. You need to hire developers with OS X specialization, and maintain a parallel codebase.

如果说，还要什么别的原因的话，那就是：这也不仅仅是一个“编译到OS X”的简单工作，你需要雇佣专门的 OS X 开发者，且维护一个新的代码库。

This isn’t just Big Company Bean-Counting.™ Take Sketch, absent from iOS [citing risk](https://www.designernews.co/comments/173706):

这个可不是“Bean Counting”那样的大公司。比如 Sketch ，也一直没有开发 iOS 的版本，见 [citing risk](https://www.designernews.co/comments/173706。

（注，TM 是商标的意思么，所以 Bean Counting 是一个公司咯？？？可是我怎么觉得这句话不是这个意思。我比较倾向于这句话是说“这不是大公司不切实际的考虑”）

> We cannot port Sketch to the iPad if we have no reasonable expectation of earning back on our investment. Maintaining an application on two different platforms and provide one of them for a 10th of it’s value won’t work, and iPad volumes are low enough to disqualify the “make it up in volume” argument.

> 我们不会把 Sketch 移植到 iPad 上面，除非我们有合理期望去赢回我们的投资。去维护一个两个不同的平台，并在其中一个上面付出超过其价值10倍的投入是不值得的，而 Ipad 上面的流量少到我们根本不必参与到“尽可能扩大用户”的争论里。

They think trials are an essential way to reduce risk. I think another option is to make supporting iPad so effortless you have to ask, “Why not?”

他们认为一个很有效的规避风险的办法就是从试用开始，而我认为还有一个选择就是使得支持 iPad 变成一件简单的事情。你也许会问，“为什么不呢？”

Let’s be clear: a lazy port of an iOS App to OS X is a terrible user experience. You should rethink touch-screen interactions for a keyboard and mouse. But there are significant areas that don’t need reimagining. If you ask Pinterest to rewrite its iconic layout for a different UI framework, it’ll shrug its shoulders and wrap its site in a webview.

我就直说了：直接把 iOS 应用移植到 OS X 的体验是超级差的，你需要重新设计键盘和鼠标交互来适应触摸屏。也有一些例外，一部分领域的应用是不需要这么做的。假设你请 Pinterest 重新设计他们图标式的界面，他们只需要耸耸肩然后把整个网站放在一个 webview 里就行了。

### Where iOS and OS X Diverge 

iOS 和 OS X 的不同之处

While OS X and iOS share a ton of lower-level APIs, they completely diverge around the UI. The former is powered by AppKit, which goes back to NeXT, and the latter is powered by UIKit, was which written from the ground up to support the iPhone.

尽管 OS X 和 iOS 都共享了相当一部分的底层接口，然而他们在 UI 层面是完全不同的。前者是建立在 Appkit 的基础上的，其历史可以追溯到 NeXT。而后者则采用了 UIKit，那是从 iPhone 的最底层开始写的。

It cuts all the way down to the coordinate system. On OS X, the origin sits on the lower left, while on iOS it’s [the upper left](https://developer.apple.com/library/ios/documentation/General/Conceptual/Devpedia-CocoaApp/CoordinateSystem.html):

二者甚至连坐标系统都是不一样的，在 OS X 上坐标点在左下方，而 iOS 上面则到了在左上方。

![](https://cdn-images-1.medium.com/max/800/1*SJU8WmP-aHgrwlT92oCRAw.jpeg)

But UIKit diverges on an even deeper level: it was designed around GPU accelerated rendering. Every _UIView_ is backed by a Core Animation **layer,** which works hand-in-hand with the GPU for silky-smooth scrolling**.**

不仅是这样，UIKit 专门为 GPU 设计了渲染加速，每一个_UIView 都有一个核心的动画层（layer）作支持，与 GPU 一同提供了流畅的滑动体验。

When Core Animation made it back to the Mac, layers were opt-in, presumably for backward compatibility. Even when you enable them, they feel grafted on _NSView._

但大概是为了支持比较早的版本，这层 layer 到了 Mac 上就变成非必须的了，甚至就算你启用了这个动画层，你也会感觉到他们也是建立在_NSView_上面的。

There are UIKit reimplementations like [TwUI](https://github.com/twitter/twui) and [Chameleon](http://chameleonproject.org), the latter seeking an identical API. In theory, you could share 100% of your UI code between platforms. In practice, these frameworks fight an uphill battle, because they third-party.

当然也存在一些 UIKit 的重新实现的库，比如 [TwUI](https://github.com/twitter/twui) 和 [Chameleon](http://chameleonproject.org)，后者意在寻求相同的 API。理论上，你可以在不同的平台上共享 100% 的 UI 代码。但实际上，这些框架是往往是费力不讨好的，他们都是第三方的。

Even among Apple’s Mac developers, there’s demand for a UIKit architecture. Last year’s Photos.app [included UXKit](https://sixcolors.com/post/2015/02/new-apple-photos-app-contains-uxkit-framework/), and Game Center uses a [UICollectionView replica](https://twitter.com/steipete/status/740065011712806912).

即便是在 Mac 的开发者中，也有对 UIKit 架构的需求。去年，苹果官方的照片应用就包含了[UXKit](https://sixcolors.com/post/2015/02/new-apple-photos-app-contains-uxkit-framework/)，而游戏中心则采用了[UICollectionView](https://twitter.com/steipete/status/740065011712806912)做替代。

### What I Expect 我的期望

Don’t expect today’s iOS apps to launch on macOS without any changes. [Look at tvOS](https://developer.apple.com/library/tvos/documentation/General/Conceptual/AppleTV_PG/index.html#//apple_ref/doc/uid/TP40015241).

不要期望现在的 iOS 不经改变就可以运行在 macOS 上面。看看 [tvOS](https://developer.apple.com/library/tvos/documentation/General/Conceptual/AppleTV_PG/index.html#//apple_ref/doc/uid/TP40015241)
就知道了。

> tvOS is derived from iOS but is a distinct OS, including some frameworks that are supported only on tvOS.

> tvOS 就是 iOS 的一个衍生版本，但是却包含了很多只能在 tvOS 上使用的框架。

It runs UIKit, with just enough stripped out to _force_ you to rewrite your interactions for a TV experience.

那上面也运行 UIKit，刚刚好能够让你重写一遍适合 TV 上的交互。

#### One Bundle to Rule Them All? 只用写一个包 (Bundle) 就可以了？

TV apps have such a different interaction model than a touch screen, you’ll probably end up with a radically different design.

TV 上应用的交互方式和触摸屏上的方式差太多了，极有可能到最后，你会得到一个完全不同的设计。

> When porting an existing project, you can include an additional target in your Xcode project to simplify sharing of resources, but you need to create new storyboards for tvOS. Likely, you will need to look at how users navigate through your app and adapt your app’s user interface to Apple TV.

> 当移植现有的项目的时候，你可以附加一个目标在现有的 xcode 里面，简单的共享资源，但是你得为 tvOS 创建新的 storyboards。类似的，你需要研究用户如何使用你的应用，并且调整你的应用界面来适应 Apple TV。

Even if you could bundle a tvOS app with your iOS app, the disadvantages (e.g. coupled releases) outweigh the advantages of shared code. I’ve known iOS developers who regretted shipped a universal iPhone/iPad app, because of the tight coupling. Sometimes you’re just better off just putting that shared code into a framework.

即便你可以把 tvOS 应用和 iOS 应用放在一个 Bundle 里面，缺点（eg. 绑定发布？二次发布？）也大过优点。我知道不少的 iOS 的开发者都后悔发布了 iPhone/Ipad 上通用的应用，因为二者的联结太紧密。很多时候，倒不如把那些共享的代码放到一个框架（framework）里面。

（译注：coupled release 我不知道是什么意思...）

That said, if you look at most of Apple’s ports between Mac and iOS, they’re very similar. If Apple envisions the Mac and iOS experience as mostly similar, it’s very likely you could bundle a Mac app with your iOS one.

鉴于此，如果想要在 iOS 和 Mac 之间移植，情况也是类似的。如果苹果使得 Mac 和 iOS 的用户体验更相似一些，你很可能可以把 Mac 和 iOS 应用放在同一个包里。 

As a developer, only dealing with a single app with a single bundle ID simplifies stuff like sharing data between devices. Again, this is about reducing for existing iOS devs to add a new platform.

对于开发者而言，一个应用意味着一份 Bundle ID，使得共享不同设备之间的信息变得更简单。这所有一切的目的，是为了简化 iOS 开发，增加一个新的平台。

What about download size? Since one runs on x86 and the other runs ARM, you’d need two architectures bundled into one binary, similar to [fat binaries](https://en.wikipedia.org/wiki/Universal_binary), from the Mac’s transition to Intel. Well in iOS 9, Apple introduced [App Thinning](https://developer.apple.com/library/tvos/documentation/IDEs/Conceptual/AppDistributionGuide/AppThinning/AppThinning.html), so you only download the code that runs on your native platform.

那需要下载的文件的大小呢？一边是运行在 x86上面的，另外一边是运行在 ARM 上的，所以需要把两个不同的架构编译到同一个二进制源码里面，类似于Mac 开始采用 intel 的时候的方案 [fat binaries](https://en.wikipedia.org/wiki/Universal_binary)。不过，iOS9里，Apple 引进了[App Thinning](https://developer.apple.com/library/tvos/documentation/IDEs/Conceptual/AppDistributionGuide/AppThinning/AppThinning.html), 所以你只用下载你所需要的平台上的源代码就可以了。

![](http://ww3.sinaimg.cn/large/a490147fjw1f4w49p8mtcj20m80ck75n.jpg)

#### Interface Idioms 界面惯例

In iOS 8, Apple added “trait collection,” and attribute that lets you check details of your platform. The [Interface Idiom](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIDevice_Class/index.html#//apple_ref/c/tdef/UIUserInterfaceIdiom) property today includes **iPhone**, **iPad**, **TV**, or **CarPlay**. You can check the idiom to know if certain views are available; for example, popover are only available on iPad.

在 iOS8里，苹果加上了“trait collection”和一些别的属性，允许你查看平台的细节。现在的[Interface Idiom](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIDevice_Class/index.html#//apple_ref/c/tdef/UIUserInterfaceIdiom) 属性包括了 **iPhone**, **iPad**, **TV**, or **CarPlay**。你可以查看这些惯例，看那些视图是可用的，比方说 popover 就只在 iPad 上有。

In theory you could restrict Mac features, like floating palettes, to a **Mac** idiom.

理论上，你可以限制一些 Mac 的特性，比方说悬浮调色盘，到一个**Mac**惯例上。

#### Sandboxing 沙箱

In 2011, Apple added [sandboxing](https://developer.apple.com/library/mac/documentation/Security/Conceptual/AppSandboxDesignGuide/AboutAppSandbox/AboutAppSandbox.html) to OS X. If you’re porting an iOS app to OS X, it _should_ just work.

2011年苹果添加了 [sandboxing](https://developer.apple.com/library/mac/documentation/Security/Conceptual/AppSandboxDesignGuide/AboutAppSandbox/AboutAppSandbox.html) 到 OS X 里。你可以通过这个功能移植 iOS 应用到 OS X上面。

#### Handing Larger Sizes 更大的页面

What about the coordinate system? If you’re using _Auto Layout_ it shouldn’t matter. Instead of assigning hard coding coordinates, you specify rules for how the views should lay out, relative to each other. It’s like CSS, but not horrible.

至于坐标系统，如果你使用自动布局，那就不用担心了。至于别的情况，你可以用相对布局来取代那些写死的坐标，就好比是 CSS 一样，其实并不是很复杂。

In the following example from [the docs](https://developer.apple.com/library/ios/documentation/UserExperience/Conceptual/AutolayoutPG/index.html#//apple_ref/doc/uid/TP40010853-CH7-SW1), each blue line is a rule (_constraint)_. So long the rules make sense, Auto Layout will just figure it out for you:

下面的这个[例子](https://developer.apple.com/library/ios/documentation/UserExperience/Conceptual/AutolayoutPG/index.html#//apple_ref/doc/uid/TP40010853-CH7-SW1)里，每一条蓝色的线都是一个规则，只要这些规则是有意义的，自动布局就会帮你处理剩下的问题。

![](http://ww4.sinaimg.cn/large/a490147fjw1f4w4a1jmg5j20g00klaam.jpg)

There’s not a _(0, 0)_ in sight. You can resize that window to any size and it just works.

再也没有（0，0）了，你可以毫无顾忌的改变窗口的大小。

Unfortunately, many apps are still using hard-coded values. It’s likely Apple will flip the coordinate system, exclusively for apps running UIKit. If you link against AppKit, you get the existing coordinate system. It would just complicate things if you mix-and-match UIKit and AppKit in one app.

不幸的是，很多应用都写死了坐标值。看除了 UIKIt 以外， Apple 打算抛弃掉坐标系统了。如果你把 Appkit 应用链接到一块的话，你就得到了现存的坐标系统，而指望在同一个应用里统一 Appkit 和 UIKit 的坐标系只会把一切弄得一团糟。

#### Avoiding Giant iPhone Apps 避免巨大的 iPhone 应用

What about the “Stretch out the iPhone App” UX abomination? They already dealt with it on iPad with [Size Classes](https://developer.apple.com/library/ios/documentation/UserExperience/Conceptual/MobileHIG/LayoutandAppearance.html), which encourage designing for screen real-estate space, not hardware. Each dimension can be either “compact” or “regular.” For example, an iPhone’s width is considered _compact_, and a full screen iPad app is _regular_. From the docs:

那那些可憎的拉伸的 iPhone 应用呢？他们已经在用 [Size Classes](https://developer.apple.com/library/ios/documentation/UserExperience/Conceptual/MobileHIG/LayoutandAppearance.html) 来解决这个问题了，它鼓励你考虑屏幕资源来设计，而不是考虑硬件资源。每一个维可以是“紧凑的”或是“普通的”。比方说，iPhone 的宽度可以是“紧凑的”而全屏的 iPad 应用则是“普通的”。

![](http://ww2.sinaimg.cn/large/a490147fjw1f4w4aew3srj20df0gz3yt.jpg)

![](http://ww2.sinaimg.cn/large/a490147fjw1f4w4aq64lpj208r0e6mxc.jpg)

So if you’re Facebook, and you only want to show trending topics on the side of the screen when you have a lot of available real-estate, you can can that you’re in a “regular” width. Why not just check if it’s iPad? An iPad app can change from _regular_ to _compact_ if the user starts multitasking, and shrinks the app.

比方说你正在使用 Facebook，你希望在屏幕的一边能够一直看到更新的话题，而你的屏幕上还空了一大块。你可以把它设定成“普通的”宽度。ipad 上面的应用可以从“普通的”宽度，切换到“紧凑的”宽度，当用户开始多任务时，就可以缩放应用了。

The Mac could operate the same way, changing size classes when you resize the window past certain thresholds.

Mac 也可以做类似的事情，当窗口小于一定阙值以后，就可以改变窗口的类型。

### Sooner Rather than Later 越快越好

Every WWDC for the last five years, I’ve thought, “This could be the year.” The difference from then and now? My outlook has changed from “wishful thinking” to “inevitable.”

这五年来，每一次 WWDC，我都在想，“是时候了。”我的 Outlook（日程表）已经从“渴望的事情”到了“无可避免了”。

It’s in Apple’s best interest to get professional apps, like Sketch, on iOS. Take Lightroom for iOS, which doesn’t support RAW processing; that makes the iPad “Pro” a joke for professional photographers. Contrast that with the Microsoft Surface, which runs the realLightroom_._

其实苹果公司比其他人更感兴趣的事情让 Sketch 这样的应用运行在 iOS 上面。虽然 iOS 上的 Lightroom 就一个笑话，不支持“RAW”格式，让 iPad “pro” 就是对于专业的摄影师来说一点也不专业。对比微软的 Surface，上面则运行了**真正的**lightroom。

It looks like even Apple has abandoned OS X. They [aren’t hiring](https://twitter.com/toddthomas/status/740045058787803136) any new AppKit developers, and the the Mac App Store has been broken for years. What if they’re finally abandoning the old platform to pour all resources into the unified one?

看起来，Apple 像是放弃了 OS X。他们没有雇佣更多的 AppKit 的开发者，而 Mac 的 App Store 多年来就是破烂不堪了。

In the last five years, Apple has changed. iOS 7 showed they’re willing to break from tradition. Apple Watch showed they’re willing to take risks, because, “Why not?” They haven’t taken a risk on the Mac since 2010, with the “Back to the Mac” event.

这五年来，苹果改变很多，iOS 7 显示了他们愿意打破传统。Apple Watch 显示他们愿意承担风险。为什么不呢？他们在2010年就开始在 “Back to the mac” 事件上承担风险了。

They say Mac OS X will be rebranded “macOS” for WWDC 2016\. This could be the year.

他们说在 WWDC2016 上 OS X 会被重命名为 macOS，今年会是时候了吧。
