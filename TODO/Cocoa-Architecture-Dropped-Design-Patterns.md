> * 原文链接: [Cocoa Architecture: Dropped Design Patterns](http://artsy.github.io/blog/2015/09/01/Cocoa-Architecture-Dropped-Design-Patterns/)
* 原文作者 : [Author: orta - Artsy Engineering](http://artsy.github.io/author/orta/)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : nathanwhy
* 校对者: 
* 状态 :  待定


As a part of going through the design patterns we've found in the creation of the Artsy iOS apps, I'd like to talk a bit about some of the patterns that we've had and migrated away from. This is not 100% comprehensive, as there has been a lot of time, and a lot of people involved. Instead I'm going to try and give a birds eye view, and zoom in on some things that feel more important overall.

It's important to preface that I don't believe in perfect code, or am I a fan of big re-writes. We can spot a bad pattern, but not do anything about it. We do have apps to ship, not a codebase to make perfect for the sake of technical purity.

在开发 Artsy 这款 iOS app 的时候，我们尝试了一些设计模式。现在我想要谈谈那些我们现在有的和已经被移除的设计模式。我不会面面俱到，毕竟已经历了那么长时间，有那么多人参与过。而我想从更高的层面去审视，关注那些总体上更重要的东西。

很重要的一点需要先声明下，我不相信有完美的代码，或者说我喜欢重写代码。我们可以发现一个坏的模式而什么都不做。毕竟我们有 app 需要完成，而不可能纯粹为了技术，追求更完美的代码库。

## NSNotifications as a decoupling method

## 用 NSNotification 解耦

A lot of the initial codebase for Energy relied on using NSNotifications as a way of passing messages throughout the application. There were notifications for user settings changes, download status updates, anything related to authentication and the corresponding different error states and a few app features. These relied on sending global notifications with very little attempts at scoping the relationship between objects.

大量 Energy 的初始代码库依靠 `NSNotification` 在应用程序内传递信息。这些通知用于用户设置调整，下载状态更新，授权与相应的错误状态，以及一些 app 特性。这些 Energy 代码太过于依赖这些全局通知进行交流，而鲜有尝试去窥探对象之间的关系。

NSNotificationCenter notifications are an implementation of the [Observer Pattern](https://en.wikipedia.org/wiki/Observer_pattern) in Cocoa. They are a beginner to intermediate programmer's design paradigm dream. It offers a way to have objects send messages to each other without having to go through any real coupling. As someone just starting with writing apps for iOS, it was an easy choice to adapt.

`NSNotificationCenter` 的通知在 Cocoa 是一种[观察者模式](https://en.wikipedia.org/wiki/Observer_pattern)的实现。 他们是初学者到中级程序员设计范式的梦想。它提供一种解耦的方式让对象相互发送消息。这对于刚入门的 iOS 开发者来说很容易上手。

One of the biggest downsides of using NSNotifications are that they make it easy to be lazy as a programmer. It allows you to not think carefully about the relationships between your objects and instead to pretend that they are loosely coupled, when instead they are coupled but via stringly typed notifications.

使用 `NSNotification` 最大的弊端在于容易使得开发者变懒。它允许你不去深究对象之间的关系，假装它们是松耦合的。而实际当他们是耦合的时候，却通过字符类型的通知传递消息。

Loose-coupling can have it's place but without being careful there is no scope on what could be listening to any notification. Also de-registering for interest can be a tricky thing [to learn](http://stackoverflow.com/questions/tagged/nsnotification) and the default memory-management behavior is about to change ( [for the better](https://developer.apple.com/library/prerelease/mac/releasenotes/Foundation/RN-Foundation/index.html#//apple_ref/doc/uid/TP30000742).)

松耦合（Loose-coupling）有它的作用，但是一不小心容易存在没有对象监听通知。[学会](http://stackoverflow.com/questions/tagged/nsnotification)注销注册也是一个棘手的问题，默认的内存管理行为将会被改变（[了解更多](https://developer.apple.com/library/prerelease/mac/releasenotes/Foundation/RN-Foundation/index.html#//apple_ref/doc/uid/TP30000742)）。

We still have a [lot of notifications](https://github.com/artsy/energy/blob/702036664a087db218d3aece8ddddb2441f931c8/Classes/Constants/ARNotifications.h) in Energy, however in Eigen and Eidolon there are next to none. We don't even have a specific file for the constants.

我们在 Energy 还是存在[大量的通知](https://github.com/artsy/energy/blob/702036664a087db218d3aece8ddddb2441f931c8/Classes/Constants/ARNotifications.h)，而在 Eigen 和 Eidolon 几乎没有。我们甚至没有一个具体的文件来储存常量。

## #define kARConstant

## #define kARConstant

Not much to say here, using `#defines` as constants was definitely [in favour](https://github.com/adium/adium/blob/master/Source/AdiumAccounts.m#L24-L30)when I learned Objective-C. Likely a throw back from C. Using `#defines` as constants would not use on-device memory to store an unchanging value. This is because a `#define` uses the pre-compiler to directly change the source code to be the value, whereas using a static constant takes up memory space on the device, which we used to _really_ care about. It's likely that a modern copy of LLVM doesn't assign on device memory unless it needs to, especially for things marked `const`. Switching to real variables means you can inspect and use in a debugger and use can rely on the type system better.

这里不用多说，当我学习 Objective-C 的时候，确实[喜欢](https://github.com/adium/adium/blob/master/Source/AdiumAccounts.m#L24-L30)使用 `#defines` 声明常量。就像 C 语言里面的 throw back。使用 `#defines` 声明常量并不会消耗设备内存来储存常量。这是因为 `#defines` 在预编译阶段直接将源代码替换为值，而使用静态常量会消耗设备的内存空间。我们以前对此很在意。但很可能是现代版本的 LLVM 在需要时才分配设备内存，特别是那些被标记为 const 的。转化为真实变量意味着你可以在调试模式下检查和使用，同时更好地依赖类型系统。

What this means in practice is what when we would have had something [like](https://github.com/artsy/eigen/blob/master/Artsy/Views/Table_View_Cells/AdminTableView/ARAnimatedTickView.m#L3): `#define TICK_DIMENSION 32` it should be [migrated to](https://github.com/artsy/eigen/blob/master/Artsy/View_Controllers/App_Navigation/ARAppSearchViewController.m#L11) `static const NSInteger ARTickViewDimensionSize = 20;`.

说了这么多，其实就是当我们[写](https://github.com/artsy/eigen/blob/master/Artsy/Views/Table_View_Cells/AdminTableView/ARAnimatedTickView.m#L3): `#define TICK_DIMENSION 32` 的时候，应该[改成](https://github.com/artsy/eigen/blob/master/Artsy/View_Controllers/App_Navigation/ARAppSearchViewController.m#L11) `static const NSInteger ARTickViewDimensionSize = 20;`。

## Sprinkling Analytics

## 撒点分析（Sprinkling Analytics）

We took some of the ideas for [Aspect oriented programming](http://albertodebortoli.github.io/blog/2014/03/25/an-aspect-oriented-approach-programming-to-ios-analytics/) with [Analytics](https://cocoapods.org/pods/ARAnalytics#user-content-aspect-oriented-dsl).

Where we used to [have this](https://github.com/artsy/energy/blob/master/Classes/Controllers/Popovers/Add%20to%20Album/ARAddToAlbumViewController.m#L271-L282):

在[统计分析](https://cocoapods.org/pods/ARAnalytics#user-content-aspect-oriented-dsl)中，我们采用[面向切面编程](http://albertodebortoli.github.io/blog/2014/03/25/an-aspect-oriented-approach-programming-to-ios-analytics/)的思想。

过去代码是[这样](https://github.com/artsy/energy/blob/master/Classes/Controllers/Popovers/Add%20to%20Album/ARAddToAlbumViewController.m#L271-L282):

    @implementation ARAddToAlbumViewController

    - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
    {
        if (indexPath.row < [self.albums count]) {
            Album *selectedAlbum = ((Album *)self.albums[indexPath.row]);
            ARTickedTableViewCell *cell = (ARTickedTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];

            if ([cell isSelected]) {
                [ARAnalytics event:ARRemoveFromAlbumEvent withProperties:@{
                    @"artworks" : @(self.artworks.count),
                    @"from" : [ARNavigationController pageID]
                }];
                [...]

We would instead build something [like this](https://github.com/artsy/eigen/blob/master/Artsy/App/ARAppDelegate+Analytics.m#L69):

现在是[这样](https://github.com/artsy/eigen/blob/master/Artsy/App/ARAppDelegate+Analytics.m#L69)：

    @implementation ARAppDelegate (Analytics)

    - (void)setupAnalytics
    {
        ArtsyKeys *keys = [[ArtsyKeys alloc] init];
      [...]
        [ARAnalytics setupWithAnalytics: @{ [...] } configuration:
        @{
            ARAnalyticsTrackedEvents:
                @[
                    @{
                        ARAnalyticsClass: ARAddToAlbumViewController.class,
                        ARAnalyticsDetails: @[
                            @{
                                ARAnalyticsEventName: ARRemoveFromAlbumEvent,
                                ARAnalyticsSelectorName: NSStringFromSelector(@selector(tableView: didSelectRowAtIndexPath:)),
                                ARAnalyticsProperties: ^NSDictionary*(ARAddToAlbumViewController *controller, NSArray *_) {
                                    return @{
                                        @"artworks" : @(controller.artworks.count),
                                        @"from" : [ARNavigationController pageID],
                                    };
                            },
                            [...]
                        ]
                    },
                  [...]

This gives us the ability to not sprinkle analytics code around the app in every file. It keeps the responsibilities of objects simpler and we've been happy with it in Eigen. We've not migrated it into Energy, its dependency on ReactiveCocoa brings too much additional weight. So far we've been applying analytics inline, Energy has much less need for individual analytics throughout the application. If you want to learn more about this pattern check out [Aspect-Oriented Programming and ARAnalytics](http://artsy.github.io/blog/2014/08/04/aspect-oriented-programming-and-aranalytics/).

这样就不会把统计代码分散到各个文件中，让每个对象的职责变得单一，这也是我们在 Eigen 中的实现。但我们并未移植到 Energy 中，因为它的依赖库 ReactiveCocoa 过于庞大。目前我们一直以内联的方式进行统计，因为 Energy 只有很少地方需要单独进行统计。如果你想要了解更多这个模式，请查看[面向切面编程与 ARAnalytics](http://artsy.github.io/blog/2014/08/04/aspect-oriented-programming-and-aranalytics/)。

## Class Methods as the whole API

## 把类方法当做全局 API

For a very long time, I preferred aesthetics of class based APIs. E.g. using only class methods instead instance methods. I think I still do. However, once you start adding tests to a project then they become a bit of a problem.

很长一段时间，我更喜欢基于类的 API 美学。比如使用类方法而不是实例方法。我一直是这么做。然而，一旦你开始给项目添加测试，这就会产生一些问题。

I'm a big fan of the idea of Dependency Injection within tests. This, roughly _TL:DR'd_, means passing in any additional context, instead of an object finding the context itself. A common case is a call to `NSUserDefaults`. It's very likely _not_ the role of your class to know which `NSUserDefault`s object you're working with, but it's likely that you're making that decision in the method by doing something like `[[NSUserDefaults standardUserDefaults] setObject:reminderID forKey:@"ARReminderID"];`. Using dependency injection would be allowing that object to come from outside that method. If you're interested in a longer and better, explanation, read this great [objc.io](https://www.objc.io/issues/15-testing/dependency-injection/) by [Jon Reid](http://qualitycoding.org/about/).

我热衷于在测试内应用依赖注入的思想。这个说来话长，简要来说， 就是传入一个额外的上下文，而不是一个对象自己找到上下文。常见的例子就是 `NSUserDefaults`。可能你的类并不需要知道你使用的是哪个 `NSUserDefault` 对象，而是你调用的方法在决定，比如 `[[NSUserDefaults standardUserDefaults] setObject:reminderID forKey:@"ARReminderID"];`。使用依赖注入将允许对象通过方法从外部传入。如果你想更深入了解这块，可以看看 [Jon Reid](http://qualitycoding.org/about/) 这篇  [objc.io](https://www.objc.io/issues/15-testing/dependency-injection/) [译文：依赖注入](http://objccn.io/issue-15-3/)。

The problem with a class based API, is that it becomes difficult to inject that object. This doesn't flow well with writing simple, fast tests. You can use a mocking library to fake the class API, but that feels weird. Mocking should be used for things you don't control. You control the object if you're making the API. Having an instance'd object means being able to provide different versions with different behaviors or values, even better if you can reduce the behavior to [a protocol](https://github.com/artsy/eigen/blob/e19ac594bf6240d076e8092d9c56e9876c94444e/Artsy/Networking/Network_Models/ARArtistNetworkModel.h).

基于类的 API，它的问题在于变得很难注入对象。这不利于写出简洁快速的测试。你可以使用一个模拟（mocking）库来伪造类 API，但这感觉很奇怪。模拟（mocking）应该被用于你不控制的事物。如果你正在写 API，那么你就控制了这个对象。拥有一个实例对象意味着可以给不同的版本提供不同行为和值，如果你可以通过 [协议（protocol）](https://github.com/artsy/eigen/blob/e19ac594bf6240d076e8092d9c56e9876c94444e/Artsy/Networking/Network_Models/ARArtistNetworkModel.h) 减少实例上的行为，那就更好了。

## Objects Sneakily Networking

## 对象隐匿地联网

When you have a complicated application, there can be a lot of places you can perform networking. We've had it in models, view controllers and views. Basically throwing the idea of purity in MVC out of the system. We started to recognise a pattern in eigen, we were not doing a good job of keeping our networking well abstracted. If you want to see the full story check out the [moya/Moya README](https://github.com/Moya/Moya).

当你有一个复杂的应用，会有很多地方可以执行网络操作。我们在模型，视图控制器和视图都有过网络操作。基本上把纯粹的 MVC 模式给抛弃了。我们开始意识到 eigen 的设计模式，因为它以前的网络层并未抽象出来。如果你想要看到完整内容，请查看 [moya/Moya README](https://github.com/Moya/Moya)。

One attempt to at trying to fix this pattern by creating a different type of networking client I've just referenced, [Moya](https://github.com/Moya/Moya).

我们企图通过构建不同类型的网络客户端来尝试修复这种模式，这客户端就是我所刚提到的 [Moya](https://github.com/Moya/Moya)。

The other was to abstract any networking performed into a separate object. If you've heard of Model-View-ViewModel ([MVVM](http://www.teehanlax.com/blog/model-view-viewmodel-for-ios/)) then this is a similar premise for networking instead of views. Network Models give us a way to abstract the networking into a set of behaviors. The extra abstraction means that you think "I want the things related to _x_" instead of "send a GET to address _x_ and turn it into _y_."

另一方面，是将网络层抽象成一个独立的对象。如果你听过 Model-View-ViewModel ([MVVM](http://www.teehanlax.com/blog/model-view-viewmodel-for-ios/))，这很相似，只是视图（View）换成网络操作。网络操作模型给我们提供了一个方法来将网络操作抽象成一系列行为。额外的抽象意味着“我想要关于 x 的东西，而不是发送一个 GET 给 x 地址，并且变成 y”。

Network models also make it extremely easy to swap behavior out in tests. In eigen, we have our asynchronous networking [run synchronously in tests](https://github.com/artsy/eigen/pull/575) but we still use the network models to be able to provide [whatever data we want to expect](https://github.com/artsy/eigen/blob/master/Artsy_Tests/View_Controller_Tests/Artist/ARArtistViewControllerTests.m#L29-L40) from the server in our tests.

网络模型也使得在测试中交换行为变得极为容易。在 eigen，我们拥有异步网络，能[在测试中异步运行](https://github.com/artsy/eigen/pull/575)，但我们还是一直使用网络模型，从而可以在测试中提供[我们期望服务端返回的数据](https://github.com/artsy/eigen/blob/master/Artsy_Tests/View_Controller_Tests/Artist/ARArtistViewControllerTests.m#L29-L40) 。

## Subclassing more than twice

## 子类化超过两次

As projects evolve it can become very easy to subclass _x_ in order to provide a "similar but a little bit different" behavior. Perhaps you need to [override some methods](https://github.com/artsy/eigen/blob/e19ac594bf6240d076e8092d9c56e9876c94444e/Artsy/View_Controllers/Web_Browsing/ARTopMenuInternalMobileWebViewController.m#L58), or add a [specific behavior](https://github.com/artsy/eigen/blob/e19ac594bf6240d076e8092d9c56e9876c94444e/Artsy/View_Controllers/Web_Browsing/AREndOfLineInternalMobileWebViewController.h#L5). Like the [urban myth](http://ezinearticles.com/?The-Boiled-Frog-Phenomenon&id=932310) of a frog being slowly boiled, you end up with a difficult to understand codebase as expected behavior mutates depending on how deep the hierarchy goes.

为了提供一个类似但有点不同的行为，通过子类化是非常简单的。可能你需要[重写某个方法](https://github.com/artsy/eigen/blob/e19ac594bf6240d076e8092d9c56e9876c94444e/Artsy/View_Controllers/Web_Browsing/ARTopMenuInternalMobileWebViewController.m#L58)，或者添加一个[特殊的行为](https://github.com/artsy/eigen/blob/e19ac594bf6240d076e8092d9c56e9876c94444e/Artsy/View_Controllers/Web_Browsing/AREndOfLineInternalMobileWebViewController.h#L5)。但就像[温水煮青蛙](http://ezinearticles.com/?The-Boiled-Frog-Phenomenon&id=932310)的故事，随着层级结构加深，期望的行为被改变，最终你将获得难以理解的代码库。

One pattern for handling this is [class composition](http://stackoverflow.com/questions/9710411/ios-grasping-composition). This is the idea that instead of having one object do multiple things, you allow a collection of objects to work together. Providing more space for each object to conform to the Single Responsibility Principal ([SRP](https://en.wikipedia.org/wiki/Single_responsibility_principle).) If you're interested in this, you may also be interested in the [class clusters](https://developer.apple.com/library/ios/documentation/General/Conceptual/CocoaEncyclopedia/ClassClusters/ClassClusters.html) pattern.

处理这种情况的一种模式是[类组件](http://stackoverflow.com/questions/9710411/ios-grasping-composition)。其思想是通过多个对象一起工作来取代一个对象处理多个事情。给每个对象提供更多的空间来遵循单一职责原则[（SRP）](https://en.wikipedia.org/wiki/Single_responsibility_principle)。如果你对这有兴趣，你可能也会对[类簇](https://developer.apple.com/library/ios/documentation/General/Conceptual/CocoaEncyclopedia/ClassClusters/ClassClusters.html)模式感兴趣。

A good example of this comes [from Energy](https://github.com/artsy/energy/blob/aa97d90cf37932d4c0f49ea4c4d31f7e491f16a6/Classes/Controllers/Top%20View%20Controller/ARTopViewToolbarController.m), our root view controller `ARTopViewController` used to control its own toolbar items. Over 4 years this became difficult to manage, and a lot of extra code in the view controller. By abstracting out the implementation details of managing the toolbar items into it's [own class](https://github.com/artsy/energy/blob/aa97d90cf37932d4c0f49ea4c4d31f7e491f16a6/Classes/Controllers/Top%20View%20Controller/ARTopViewToolbarController.m) we were able to allow the `ARTopViewController` to state what it wanted by not how it was done.

举一个来自 Energy 的好例子，我们的根控制器 `ARTopViewController` 过去常常控制自己的工具栏项目（toolbar items）。经过四年的时间这变得难以管理，在视图控制器有大量的额外代码。通过抽取控制工具栏项目（toolbar items）的实现细节到他们自己的类，从而让 `ARTopViewController` 展示自己想要做的而不是怎么做的。

## Configuration Classes over Inter-Class Communication

## 通过类间通信配置类

A one of the most important aspects of Energy is to [email artworks](http://folio.artsy.net). So there is a lot of code around configuring the email you want to send, and then generating HTML from those settings. This started out pretty simple as we had very few app-wide settings. Over time, deciding what we need to show in terms of settings and how they affected the email became very complicated.

Energy 最重要的一部分就是 [email artworks](http://folio.artsy.net/)。配置你想要发送的邮件，然后根据设置生成 HTML，因此这会产生大量的代码。这个开始很简单，因为我们只有很少的应用设置。随着时间的推移，依据设置和它们如何影响邮件决定我们需要显示什么，这会变得很复杂。

The part that eventually became a strong enough code-smell to warrant a re-write was the view controller which allowed a partner to choose what information to send would pass details individually to an object that would generate the HTML. I found it difficult to write simple tests for the class' behavior. Initially I would mock the email composer, then inspect the methods that were called. This felt wrong, as you shouldn't really be mocking classes you own. Given the importance of the functionality that classes provide our application, ideas on ways to improve the section of code stayed on my mind for a long time.

视图控制器里允许小伙伴选择各自想要传递给对象的细节，然后生成 HTML，这部分最终变得具有很强的代码异味，让你想要重写。我发现想要给类的行为写个简单的测试是很困难的。一开始我要模拟（mock） email 组件，然后检查我所调用的方法。这感觉是错的，因为你不应该模拟（mock）你自己的类。类提供了重要的功能，对于如何改进这部分代码，我想了很久。

The fix came to me during Justin Searls' talk [Sometimes a Controller is Just a Controller](https://speakerdeck.com/searls/sometimes-a-controller-is-just-a-controller) - specifically slide [55](https://speakerdeck.com/searls/sometimes-a-controller-is-just-a-controller?slide=55). Justin talks about objects that _either hold and describe a value or perform useful behavior, never both_.

问题的解决灵感来自 Justin Searls 演说，["有时控制器只是控制器"](https://speakerdeck.com/searls/sometimes-a-controller-is-just-a-controller)，特别是第[55](https://speakerdeck.com/searls/sometimes-a-controller-is-just-a-controller?slide=55)张 PPT。他谈到对象，要么持有并描述一个值，要么执行一个有用的行为，绝不要两者都有。

I took this advice and re-evaluated the relationship between settings view controller and composer object. Initially settings would configured the composer, afterwards the settings would create a configuration object and the composer would consume it. This made it _significantly_ easier to write tests for both objects. As they had very obvious inputs and outputs in the form of a [AREmailSettings](https://github.com/artsy/energy/blob/aa97d90cf37932d4c0f49ea4c4d31f7e491f16a6/Classes/Util/Emails/AREmailSettings.h). The [AREmailComposerTests](https://github.com/artsy/energy/blob/aa97d90cf37932d4c0f49ea4c4d31f7e491f16a6/ArtsyFolio%20Tests/Util/AREmailComposerTests.m) in particular become much more elegant.

我采纳了这个建议，重新评估了设置控制器和组件对象之间的关系。在改动之前，设置控制器会直接配置组件。现在，设置控制器创建了一个配置对象，供组件使用。这就使得给两个对象写测试变得极其简单，因为他们都有很明显的输入和输出，其格式是 [AREmailSettings](https://github.com/artsy/energy/blob/aa97d90cf37932d4c0f49ea4c4d31f7e491f16a6/Classes/Util/Emails/AREmailSettings.h)。[AREmailComposerTests](https://github.com/artsy/energy/blob/aa97d90cf37932d4c0f49ea4c4d31f7e491f16a6/ArtsyFolio%20Tests/Util/AREmailComposerTests.m) 也变得非常优雅。

### Direct use of Responder Chain

### 直接使用响应链

Before I worked at Artsy, I was a [Mac developer](http://i.imgur.com/Am9LjED.gif), I've been doing that since before iOS existed, so this influences my code style. One of the great parts of the Cocoa toolchain is the [responder chain](https://developer.apple.com/library/ios/documentation/EventHandling/Conceptual/EventHandlingiPhoneOS/event_delivery_responder_chain/event_delivery_responder_chain.html), a well documented way of passing methods up a known chain of objects. It solves a common problem with complicated view structures. You could have a button that is generated at runtime deep inside a view hierarchy and you would like the view controller to handle it being tapped. You could use a long chain of delegate methods, or use a [private method](https://twitter.com/unimp0rtanttech/status/555828778015129600) to get the reference to the view controller instance. On the Mac usage of the responder chain is a common pattern, on iOS it is used rarely.

在我去 Artsy 工作之前，我是一名 [Mac 开发者](http://i.imgur.com/Am9LjED.gif)，在 iOS 存在之前就一直是，所以这也影响了我的代码风格。Cocoa 工具链最主要的部分之一是[响应链](https://developer.apple.com/library/ios/documentation/EventHandling/Conceptual/EventHandlingiPhoneOS/event_delivery_responder_chain/event_delivery_responder_chain.html)，一个很好的记录方法传递一个已知的对象链。它解决了复杂视图结构的常见问题。你可以通过运行时，在很深的视图层级生成一个按钮，然后当它被点击时被视图控制器接收处理。你可以使用很长的代理方法链，或者使用[私有方法](https://twitter.com/unimp0rtanttech/status/555828778015129600)获得视图控制器实例的引用。在 Mac 开发，使用响应链是一种常见的模式，在 iOS 就使用得很少。

We have this problem with our Artwork view controller in Eigen. There are buttons that are many [stack views deep](https://speakerdeck.com/orta/ios-at-artsy?slide=38) that need to pass a message back to the view controller. When we first hit this the issue I immediately used the responder chain, you write a [line of code](https://github.com/artsy/eigen/blob/e19ac594bf6240d076e8092d9c56e9876c94444e/Artsy/Views/Artwork/ARArtworkActionsView.m#L85) like: `[bidButton addTarget:self action:@selector(tappedBidButton:) forControlEvents:UIControlEventTouchUpInside];` where the `self` is referring to the view. This would send the message `tappedBidButton:` up the responder chain where it is reacted upon by the [ARArtworkViewController](https://github.com/artsy/eigen/blob/e19ac594bf6240d076e8092d9c56e9876c94444e/Artsy/View_Controllers/Artwork/ARArtworkViewController+ButtonActions.m#L114).

我们在 Eigen 的视图控制器也有这种问题。有一些按钮在很深的视图层级，需要将信息传递到视图控制器。当我们第一次碰到这种问题，立即使用了响应链，你写了[几行代码](https://github.com/artsy/eigen/blob/e19ac594bf6240d076e8092d9c56e9876c94444e/Artsy/Views/Artwork/ARArtworkActionsView.m#L85)类似：`[bidButton addTarget:self action:@selector(tappedBidButton:) forControlEvents:UIControlEventTouchUpInside];`，其中 self 指向视图。这会向上传递信息 `tappedBidButton:` ，直到被  [ARArtworkViewController](https://github.com/artsy/eigen/blob/e19ac594bf6240d076e8092d9c56e9876c94444e/Artsy/View_Controllers/Artwork/ARArtworkViewController+ButtonActions.m#L114) 响应。

I had to explain the premise of the responder chain to almost everyone touching this area of the code base. This is great in terms of the ["lucky 10,000"](https://xkcd.com/1053/) but means that the pattern is unintuitive to those who have not previously heard of it. There was one more issue, the lack of coupling means that renaming selectors via refactoring can break the chain.

我必须解释，响应链的前提是大多数人接触这块代码区域。在 ["lucky 10,000”](https://xkcd.com/1053/) 这是可行的，但意味着这模式对于之前没听说过的人并不直观。还有一个的问题，缺乏耦合意味着通过重构重命名 selector 会打破响应链条。

The way that we reduced the cognitive load was via a protocol, all of the actions that the responder chain will use are mapped inside [ARArtworkActionsViewButtonDelegate](https://github.com/artsy/eigen/blob/e19ac594bf6240d076e8092d9c56e9876c94444e/Artsy/Views/Artwork/ARArtworkActionsView.h#L10-L20)-like protocols. It's a bit of a white-lie given that there is no direct relationship using the protocol in the app, but it makes the relationship more obvious. We use a class extension that [conforms to these types of protocols](https://github.com/artsy/eigen/blob/e19ac594bf6240d076e8092d9c56e9876c94444e/Artsy/View_Controllers/Artwork/ARArtworkViewController+ButtonActions.h#L11) to keep the actions all kept in one place.

减少认知负担的方式是通过协议，所有响应链将会使用的动作都会通过类似 [ARArtworkActionsViewButtonDelegate](https://github.com/artsy/eigen/blob/e19ac594bf6240d076e8092d9c56e9876c94444e/Artsy/Views/Artwork/ARArtworkActionsView.h#L10-L20) 的协议映射。这有点善意谎言的意味，没有通过直接的关系来使用协议，但是它使得关系更加明显。我们使用类拓展（class extension）来[遵守这些类型的协议](https://github.com/artsy/eigen/blob/e19ac594bf6240d076e8092d9c56e9876c94444e/Artsy/View_Controllers/Artwork/ARArtworkViewController+ButtonActions.h#L11)，从而保持所有动作都在同一个地方。

### Wrap-up

### 总结

There are many design patterns, and they all come with trade-offs. Over time, our opinions on what is "good code" changes, this is great. It's important that as developers we understand that being able to change our minds is one of the most vital skills we have in our toolchain. This means being open to opinions outside of your usual sphere of influence and to maybe bring some good ideas from them. It's great to be passionate about an aspect of how we craft applications, but from my perspective, the best programmers choose pragmatism over idealism.

设计模式有很多，而它们全都来源于权衡。随着时间的推移，我们对于什么是"好的代码"的标准会变，这是好事。重要的是，作为开发者，我们明白，能改变我们思想的，才是我们工具链中最必不可少的技能之一。这意味着你要走出自己原本的认知范围，乐于接受那些外来的信息，或许，你会从中获得一些很不错的点子。对于创造应用持有热情是好的，不过我想，最好的程序员选择实用主义而不是理想主义。
