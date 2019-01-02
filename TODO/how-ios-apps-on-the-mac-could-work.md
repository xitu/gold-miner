>* 原文链接 : [How iOS Apps on the Mac Could Work](https://medium.com/@sandofsky/how-ios-apps-on-the-mac-could-work-13aa32a2647b)
* 原文作者 : [Ben Sandofsky](https://medium.com/@sandofsky)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [wildflame](https://github.com/wildflame)
* 校对者: [thanksdanny](https://github.com/thanksdanny),[owenlyn](https://github.com/owenlyn)

# 假如 Mac 上也有 iOS 应用？

![](https://cdn-images-1.medium.com/max/800/1*o5AUFxXTmRcAr17x1p6m6A.jpeg)

### 假如 Mac 上也有 iOS 应用，世界将会怎样？

没有人专门为 Mac 开发应用，Slack 有专门的 iOS 版本，放在 iPad 上的体验非常好，接上 smart keyboard 以后，你会发现还可以方便的使用快捷键。而且，在应用上无限下滑的体验甚至超过了他们本身的网页端，甚至于我从来没有看到过一个“加载中”的页面。这体验如果能够放到桌面端那是再好不过了，但是他们没有这么做，他们仅仅只是把他们的网页放到了一个 app-launcher 里，这就成了桌面端。

Basecamp 是这么做的，Wordpress 是这么做的，甚至连 Mac App Store 自己，都只是一个 webview 而已。

对于那些所谓的“应用”，我是再讨厌不过了。我理解大公司的选择，他们**不喜欢**跨平台。设计师们需要专门做设计，QA 需要测试更多的环境，而文职人员们则要费力去翻译那些“原生视图”到更为工业界接受的“页面视图”。那些大公司一直不愿意费力气去替代跨平台的 Html 5 应用也毫不奇怪了。

如果说，还要什么别的原因的话，那就是：这也不仅仅是一个“编译到OS X”的简单工作，你需要雇佣专门的 OS X 开发者，且维护一个新的代码库。

这并不是说大公司抠门。比如 Sketch ，他们也一直没有开发 iOS 的版本，见 [引用](https://www.designernews.co/comments/173706)。

> We cannot port Sketch to the iPad if we have no reasonable expectation of earning back on our investment. Maintaining an application on two different platforms and provide one of them for a 10th of it’s value won’t work, and iPad volumes are low enough to disqualify the “make it up in volume” argument.

> 我们不会把 Sketch 移植到 iPad 上面，除非我们有合理期望去赢回我们的投资。去维护一个两个不同的平台，并在其中一个上面付出超过其价值10倍的投入是不值得的，而 iPad 上面的流量少到我们根本不必参与到“尽可能扩大用户”的争论里。

他们认为一个很有效的规避风险的办法就是从试用开始，而我认为还有一个选择就是使得支持 iPad 变成一件简单的事情。你也许会问，“为什么不呢？”

我就直说了：直接把 iOS 应用移植到 OS X 的体验是超级差的，你需要重新设计触摸屏的交互来适应键盘和鼠标的交互。当然也有一些例外，一部分领域的应用是不需要这么做的：假设你请 Pinterest 重新设计他们全是图的界面，他们只需要耸耸肩，然后把整个网站放在一个 webview 里就行了。

### iOS 和 OS X 的不同之处

尽管 OS X 和 iOS 共享了相当一部分的底层接口，然而他们在 UI 层面是完全不同的。前者是建立在 Appkit 的基础上的，其历史可以追溯到 NeXT。而后者则采用了 UIKit，那是从 iPhone 的最底层开始写的。

二者甚至连坐标系统都是不一样的，在 OS X 上坐标点在左下方，而 iOS 上面则到了在左上方。

![](https://cdn-images-1.medium.com/max/800/1*SJU8WmP-aHgrwlT92oCRAw.jpeg)

不仅是这样，UIKit 专门为 GPU 设计了渲染加速，每一个 _UIView_ 都有一个核心的动画层（layer）作支持，与 GPU 一同提供了流畅的滑动体验。

但大概是为了支持比较早的版本，这层 layer 到了 Mac 上就变成非必须的了，甚至就算你启用了这个动画层，你也会感觉到他们也是建立在 _NSView_ 上面的。

当然也存在一些重新实现 UIKit 的的库，比如 [TwUI](https://github.com/twitter/twui) 和 [Chameleon](http://chameleonproject.org)，后者意在寻求相同的 API。理论上，你可以在不同的平台上共享 100% 的 UI 代码。但实际上，这些框架是往往是费力不讨好的，因为他们都是第三方的。

即便是在 Mac 的开发者中，也有对 UIKit 架构的需求。去年，苹果官方的应用 Photos 就包含了[UXKit](https://sixcolors.com/post/2015/02/new-apple-photos-app-contains-uxkit-framework/)，而游戏中心则采用了[UICollectionView](https://twitter.com/steipete/status/740065011712806912)做替代。

### 我的期望

不要期望现在的 iOS 不经改变就可以运行在 macOS 上面。看看 [tvOS](https://developer.apple.com/library/tvos/documentation/General/Conceptual/AppleTV_PG/index.html#//apple_ref/doc/uid/TP40015241)
就知道了。

> tvOS is derived from iOS but is a distinct OS, including some frameworks that are supported only on tvOS.

> tvOS 是 iOS 的一个衍生版本，包含了很多只能在 tvOS 上使用的框架。

那上面也运行 UIKit，刚刚好能够 _让你_ 重写一遍适合 TV 上的交互。

#### 只用写一个包 (Bundle) 就可以了？

TV 上应用的交互方式和触摸屏上的方式差太多了，极有可能到最后，你会得到一个完全不同的设计。

> When porting an existing project, you can include an additional target in your Xcode project to simplify sharing of resources, but you need to create new storyboards for tvOS. Likely, you will need to look at how users navigate through your app and adapt your app’s user interface to Apple TV.

> 当移植现有的项目的时候，你可以附加一个 target 在现有的 Xcode 项目里面共享资源。但是，你得专门为 tvOS 创建新的 storyboards。类似地，你还需要研究用户如何使用你的应用来调整你的应用界面来适应 Apple TV。

即便你可以把 tvOS 应用和 iOS 应用放在一个 Bundle 里面，缺点（eg. 过度耦合）也大过优点。我知道不少的 iOS 的开发者都后悔发布了 iPhone/iPad 上通用的应用，因为二者的联结太紧密。很多时候，倒不如把那些共享的代码放到一个框架（framework）里面。

鉴于此，如果想要在 iOS 和 Mac 之间移植，情况也是类似的。如果苹果能使 Mac 和 iOS 的用户体验更相似一些，你很可能可以把 Mac 和 iOS 应用放在同一个包里。

对于开发者而言，一个应用意味着一份 Bundle ID，这使得共享不同设备之间的信息变得更简单。这所有一切的目的，都是为了简化在新平台 (macOS) 上开发与iOS 应用相应的(桌面)应用的流程”

那需要下载的文件的大小呢？一边是运行在 x86上面的，另外一边是运行在 ARM 上的，所以需要把两个不同的架构编译到同一个二进制源码里面，类似于Mac 开始采用 intel 的时候的方案 [fat binaries](https://en.wikipedia.org/wiki/Universal_binary)。不过，iOS9里，Apple 引进了[App Thinning](https://developer.apple.com/library/tvos/documentation/IDEs/Conceptual/AppDistributionGuide/AppThinning/AppThinning.html), 所以你只用下载你所需要的平台上的源代码就可以了。

![](http://ww3.sinaimg.cn/large/a490147fjw1f4w49p8mtcj20m80ck75n.jpg)

#### 界面惯例

在 iOS8里，苹果加上了“trait collection”和一些别的属性，允许你查看平台的细节。现在的[Interface Idiom](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIDevice_Class/index.html#//apple_ref/c/tdef/UIUserInterfaceIdiom) 属性包括了 **iPhone**, **iPad**, **TV**, or **CarPlay**。你可以查看这些惯例，看那些视图是可用的，比方说 popover 就只在 iPad 上有。

理论上，你可以限制一些 Mac 的特性，使其符合 **Mac** 惯例，比如浮动调色盘。

#### 沙箱

2011年苹果添加了 [sandboxing](https://developer.apple.com/library/mac/documentation/Security/Conceptual/AppSandboxDesignGuide/AboutAppSandbox/AboutAppSandbox.html) 到 OS X 里。理论上，你“可以”通过这个功能移植 iOS 应用到 OS X上面。

#### 解决更大的屏幕和页面

那坐标系统呢？—— 如果你使用自动布局，就不用担心了。别的情况，你可以用相对布局来取代那些写死的坐标，就好比是 CSS 一样，其实并不是很复杂。

下面的这个[例子](https://developer.apple.com/library/ios/documentation/UserExperience/Conceptual/AutolayoutPG/index.html#//apple_ref/doc/uid/TP40010853-CH7-SW1)里，每一条蓝色的线都是一个规则，只要这些规则是有意义的，自动布局就会帮你处理剩下的问题。

![](http://ww4.sinaimg.cn/large/a490147fjw1f4w4a1jmg5j20g00klaam.jpg)

再也没有（0，0）点了，你可以毫无顾忌的改变窗口的大小。

不幸的是，很多应用都写死了坐标值。除了 UIKIt 以外， Apple 都要抛弃掉坐标系统了。如果你把它和 Appkit 应用链接到一块的话，你就得到了已有的坐标系统，而指望在同一个应用里统一 Appkit 和 UIKit 的坐标系只会把一切弄得一团糟。

#### 避免写出巨大尺寸的 iPhone 应用

那那些可憎的拉伸的 iPhone 应用呢？他们已经在用 [Size Classes](https://developer.apple.com/library/ios/documentation/UserExperience/Conceptual/MobileHIG/LayoutandAppearance.html) 来解决这个问题了，它鼓励你考虑屏幕资源来设计，而不是考虑硬件资源。它的每一个维度可以是“紧凑的”或是“普通的”。比方说，iPhone 的宽度是“紧凑的”，而全屏的 iPad 应用的宽度则是“普通的”。

![](http://ww2.sinaimg.cn/large/a490147fjw1f4w4aew3srj20df0gz3yt.jpg)

![](http://ww2.sinaimg.cn/large/a490147fjw1f4w4aq64lpj208r0e6mxc.jpg)

比方说你正在使用 Facebook，你希望在屏幕的一边能够一直看到更新的话题，而你的屏幕上还空了一大块。你可以把它设定成“普通的”宽度。那为什么要这么大费周章，而不是简简单单的看一下这是不是一台iPad呢？这是因为只需要把应用从“普通的”宽度切换到“紧凑的”宽度，就可以让用户方便的在 iPad 上开启多任务模式了。

Mac 也可以做类似的事情，当窗口小于一定阙值以后，就可以改变窗口的类型。

### 越早实现越好

这五年来，每一次 WWDC，我都在想，“是时候了。”，对于此，我的 Outlook（日程表）已经从“渴望的事情”到了“无可避免了”。

其实苹果公司比任何人都更渴望让 Sketch 这样的应用运行在 iOS 上面。比如说 iOS 上的 Lightroom ， 它却不支持“RAW”格式，这对专业的摄影师来说 iPad “pro”就是个笑话。而对比微软的 Surface，上面则运行了**真正的**lightroom。

看起来，Apple 像是放弃了 OS X。他们没有雇佣更多的 AppKit 的开发者，而 Mac 的 App Store 多年来就是破烂不堪了。那么如果他们终于决定放弃旧的平台转而将所有的资源注入到一个(iOS与macOS)统一的平台上会产生怎样的效果呢？

这五年来，苹果改变很多，iOS 7 显示了他们愿意打破传统。Apple Watch 显示他们愿意承担风险。为什么不呢？他们在2010年就开始在 “Back to the mac” 上承担风险了。

他们说，在 WWDC2016 上 OS X 会被重命名为 macOS，今年会是时候了吧。

**译注: "Back to the mac" 是苹果在2010年的一项活动，那次发布了Mac OS X Lion，并且介绍了苹果如何期望把 Mac 平台和 iOS 平台统一起来。本文在图片里的标题也是“Back to the mac”**
