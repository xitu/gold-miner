> * 原文链接: [Cocoa Architecture: Dropped Design Patterns](http://artsy.github.io/blog/2015/09/01/Cocoa-Architecture-Dropped-Design-Patterns/)
* 原文作者 : [Author: orta - Artsy Engineering](http://artsy.github.io/author/orta/)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [nathanwhy](https://github.com/nathanwhy)
* 校对者: [walkingway](https://github.com/walkingway)、[iThreeKing](https://github.com/iThreeKing)
* 状态 :  完成

# Artsy 工程师总结的一些 Cocoa 开发设计误区

在开发 Artsy 这款 iOS app 的时候，我们尝试了一些设计模式。现在我想要谈谈我们现在有的和已经被移除的设计模式。我不会面面俱到，毕竟已经历了那么长时间，有那么多人参与过。而我想从更高的层面去审视，关注那些总体上更重要的东西。

很重要的一点需要先声明下，我不相信有完美的代码，或者说我喜欢重写代码。我们可以发现一个坏的模式而什么都不做。毕竟我们有 app 需要完成，而不可能纯粹为了技术，追求更完美的代码库。

## 用 NSNotification 解耦

大量 Energy 的初始代码库依靠 `NSNotification` 在应用程序内传递信息。这些通知用于用户设置调整，下载状态更新，授权与相应的错误状态，以及一些 app 特性。这些 Energy 代码太过于依赖这些全局通知进行交流，而鲜有尝试去窥探对象之间的关系。

`NSNotificationCenter` 的通知在 Cocoa 是一种[观察者模式](https://en.wikipedia.org/wiki/Observer_pattern)的实现。 他们是初学者到中级程序员设计范式的梦想。它提供一种解耦的方式让对象相互发送消息。这对于刚入门的 iOS 开发者来说很容易上手。

使用 `NSNotification` 最大的弊端在于容易使得开发者变懒。它允许你不去深究对象之间的关系，假装它们是松耦合的。而实际当他们是耦合的时候，却通过字符类型的通知传递消息。

松耦合（Loose-coupling）有它的作用，但是一不小心容易存在没有对象监听通知。[学会](http://stackoverflow.com/questions/tagged/nsnotification)注销注册也是一个棘手的问题，默认的内存管理行为将会被改变（[了解更多](https://developer.apple.com/library/prerelease/mac/releasenotes/Foundation/RN-Foundation/index.html#//apple_ref/doc/uid/TP30000742)）。

我们在 Energy 还是存在[大量的通知](https://github.com/artsy/energy/blob/702036664a087db218d3aece8ddddb2441f931c8/Classes/Constants/ARNotifications.h)，而在 Eigen 和 Eidolon 几乎没有。我们甚至没有一个具体的文件来储存常量。

## #define kARConstant

这里不用多说，当我学习 Objective-C 的时候，确实[喜欢](https://github.com/adium/adium/blob/master/Source/AdiumAccounts.m#L24-L30)使用 `#defines` 声明常量。就像 C 语言里面的 throw back。使用 `#defines` 声明常量并不会消耗设备内存来储存常量。这是因为 `#defines` 在预编译阶段直接将源代码替换为值，而使用静态常量会消耗设备的内存空间。我们以前对此很在意。但很可能是现代版本的 LLVM 在需要时才分配设备内存，特别是那些被标记为 const 的。转化为真实变量意味着你可以在调试模式下检查和使用，同时更好地依赖类型系统。

说了这么多，其实就是当我们[写](https://github.com/artsy/eigen/blob/master/Artsy/Views/Table_View_Cells/AdminTableView/ARAnimatedTickView.m#L3): `#define TICK_DIMENSION 32` 的时候，应该[改成](https://github.com/artsy/eigen/blob/master/Artsy/View_Controllers/App_Navigation/ARAppSearchViewController.m#L11) `static const NSInteger ARTickViewDimensionSize = 20;`。

## 撒点分析（Sprinkling Analytics）

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


这样就不会把统计代码分散到各个文件中，让每个对象的职责变得单一，这也是我们在 Eigen 中的实现。但我们并未移植到 Energy 中，因为它的依赖库 ReactiveCocoa 过于庞大。目前我们一直以内联的方式进行统计，因为 Energy 只有很少地方需要单独进行统计。如果你想要了解更多这个模式，请查看[面向切面编程与 ARAnalytics](http://artsy.github.io/blog/2014/08/04/aspect-oriented-programming-and-aranalytics/)。

## 把类方法当做全局 API

很长一段时间，我更喜欢基于类的 API 美学。比如使用类方法而不是实例方法。我一直是这么做。然而，一旦你开始给项目添加测试，这就会产生一些问题。

我热衷于在测试内应用依赖注入的思想。这个有点复杂，简要来说， 就是传入一个额外的上下文，而不是一个对象自己找到上下文。常见的例子就是 `NSUserDefaults`。可能你的类并不需要知道你使用的是哪个 `NSUserDefault` 对象，而是你调用的方法在决定，比如 `[[NSUserDefaults standardUserDefaults] setObject:reminderID forKey:@"ARReminderID"];`。使用依赖注入将允许对象通过方法从外部传入。如果你想更深入了解这块，可以看看 [Jon Reid](http://qualitycoding.org/about/) 这篇  [objc.io](https://www.objc.io/issues/15-testing/dependency-injection/) [译文：依赖注入](http://objccn.io/issue-15-3/)。

基于类的 API，它的问题在于变得很难注入对象。这不利于写出简洁快速的测试。你可以使用一个模拟（mocking）库来伪造类 API，但这感觉很奇怪。模拟（mocking）应该被用于你不控制的事物。如果你正在写 API，那么你就控制了这个对象。拥有一个实例对象意味着可以给不同的版本提供不同行为和值，如果你可以通过 [协议（protocol）](https://github.com/artsy/eigen/blob/e19ac594bf6240d076e8092d9c56e9876c94444e/Artsy/Networking/Network_Models/ARArtistNetworkModel.h) 减少实例上的行为，那会更好。

## 对象隐匿地联网

当你有一个复杂的应用，会有很多地方可以执行网络操作。我们在模型，视图控制器和视图都有过网络操作。基本上把纯粹的 MVC 模式给抛弃了。我们开始意识到 eigen 的设计模式，因为它以前的网络层并未抽象出来。如果你想要看到完整内容，请查看 [moya/Moya README](https://github.com/Moya/Moya)。

我们企图通过构建不同类型的网络客户端来尝试修复这种模式，这客户端就是我所刚提到的 [Moya](https://github.com/Moya/Moya)。

另一方面，是将网络层抽象成一个独立的对象。如果你听过 Model-View-ViewModel ([MVVM](http://www.teehanlax.com/blog/model-view-viewmodel-for-ios/))，这很相似，只是视图（View）换成网络操作。网络操作模型给我们提供了一个方法来将网络操作抽象成一系列行为。额外的抽象意味着“我想要关于 x 的东西，而不是发送一个 GET 给 x 地址，并且变成 y”。

网络模型也使得在测试中交换行为变得极为容易。在 eigen，我们拥有异步网络，能[在测试中同步运行](https://github.com/artsy/eigen/pull/575)，但我们还是一直使用网络模型，从而可以在测试中提供[我们期望服务端返回的数据](https://github.com/artsy/eigen/blob/master/Artsy_Tests/View_Controller_Tests/Artist/ARArtistViewControllerTests.m#L29-L40) 。

## 子类化超过两次

为了提供一个类似但有点不同的行为，通过子类化是非常简单的。可能你需要[重写某个方法](https://github.com/artsy/eigen/blob/e19ac594bf6240d076e8092d9c56e9876c94444e/Artsy/View_Controllers/Web_Browsing/ARTopMenuInternalMobileWebViewController.m#L58)，或者添加一个[特殊的行为](https://github.com/artsy/eigen/blob/e19ac594bf6240d076e8092d9c56e9876c94444e/Artsy/View_Controllers/Web_Browsing/AREndOfLineInternalMobileWebViewController.h#L5)。但就像[温水煮青蛙](http://ezinearticles.com/?The-Boiled-Frog-Phenomenon&id=932310)的故事，随着层级结构加深，期望的行为被改变，最终你将获得难以理解的代码库。

处理这种情况的一种模式是[类组件](http://stackoverflow.com/questions/9710411/ios-grasping-composition)。其思想是通过多个对象一起工作来取代一个对象处理多个事情。给每个对象提供更多的空间来遵循单一职责原则[（SRP）](https://en.wikipedia.org/wiki/Single_responsibility_principle)。如果你对这有兴趣，你可能也会对[类簇](https://developer.apple.com/library/ios/documentation/General/Conceptual/CocoaEncyclopedia/ClassClusters/ClassClusters.html)模式感兴趣。

举一个来自 Energy 的好例子，我们的根视图控制器 `ARTopViewController` 过去常常控制自己的工具栏项目（toolbar items）。经过四年的时间这变得难以管理，在视图控制器有大量的额外代码。通过抽取控制工具栏项目（toolbar items）的实现细节到他们自己的类，从而让 `ARTopViewController` 展示自己想要做的而不是怎么做的。

## 通过类间通信配置类

Energy 最重要的一部分就是 [email artworks](http://folio.artsy.net/)。配置你想要发送的邮件，然后根据设置生成 HTML，因此这会产生大量的代码。这个开始很简单，因为我们只有很少的应用设置。随着时间的推移，依据设置和它们如何影响邮件决定我们需要显示什么，这会变得很复杂。

视图控制器里允许小伙伴选择各自想要传递给对象的细节，然后生成 HTML，这部分最终变得具有很强的代码异味，让你想要重写。我发现想要给类的行为写个简单的测试是很困难的。一开始我要模拟（mock） email 组件，然后检查我所调用的方法。这感觉是错的，因为你不应该模拟（mock）你自己的类。类提供了重要的功能，对于如何改进这部分代码，我想了很久。

问题的解决灵感来自 Justin Searls 演说，["有时控制器只是控制器"](https://speakerdeck.com/searls/sometimes-a-controller-is-just-a-controller)，特别是第[55](https://speakerdeck.com/searls/sometimes-a-controller-is-just-a-controller?slide=55)张 PPT。他谈到对象，要么持有并描述一个值，要么执行一个有用的行为，绝不要两者都有。

我采纳了这个建议，重新评估了设置控制器和组件对象之间的关系。在改动之前，设置控制器会直接配置组件。现在，设置控制器创建了一个配置对象，供组件使用。这就使得给两个对象写测试变得极其简单，因为他们都有很明显的输入和输出，其格式是 [AREmailSettings](https://github.com/artsy/energy/blob/aa97d90cf37932d4c0f49ea4c4d31f7e491f16a6/Classes/Util/Emails/AREmailSettings.h)。[AREmailComposerTests](https://github.com/artsy/energy/blob/aa97d90cf37932d4c0f49ea4c4d31f7e491f16a6/ArtsyFolio%20Tests/Util/AREmailComposerTests.m) 也变得非常优雅。

### 直接使用响应链

在我去 Artsy 工作之前，我是一名 [Mac 开发者](http://i.imgur.com/Am9LjED.gif)，在 iOS 存在之前就一直是，所以这也影响了我的代码风格。Cocoa 工具链最主要的部分之一是[响应链](https://developer.apple.com/library/ios/documentation/EventHandling/Conceptual/EventHandlingiPhoneOS/event_delivery_responder_chain/event_delivery_responder_chain.html)，一个很好的记录方法传递一个已知的对象链。它解决了复杂视图结构的常见问题。你可以通过运行时，在很深的视图层级生成一个按钮，然后当它被点击时被视图控制器接收处理。你可以使用很长的代理方法链，或者使用[私有方法](https://twitter.com/unimp0rtanttech/status/555828778015129600)获得视图控制器实例的引用。在 Mac 开发，使用响应链是一种常见的模式，在 iOS 就使用得很少。

我们在 Eigen 的视图控制器也有这种问题。有一些按钮在很深的视图层级，需要将信息传递到视图控制器。当我们第一次碰到这种问题，立即使用了响应链，你写了[几行代码](https://github.com/artsy/eigen/blob/e19ac594bf6240d076e8092d9c56e9876c94444e/Artsy/Views/Artwork/ARArtworkActionsView.m#L85)类似：`[bidButton addTarget:self action:@selector(tappedBidButton:) forControlEvents:UIControlEventTouchUpInside];`，其中 self 指向视图。这会向上传递信息 `tappedBidButton:` ，直到被  [ARArtworkViewController](https://github.com/artsy/eigen/blob/e19ac594bf6240d076e8092d9c56e9876c94444e/Artsy/View_Controllers/Artwork/ARArtworkViewController+ButtonActions.m#L114) 响应。

我必须解释，响应链的前提是大多数人接触这块代码区域。在 ["lucky 10,000”](https://xkcd.com/1053/) 这是可行的，但意味着这模式对于之前没听说过的人并不直观。还有一个的问题，缺乏耦合意味着通过重构重命名 selector 会打破响应链条。

减少认知负担的方式是通过协议，所有响应链将会使用的动作都会通过类似 [ARArtworkActionsViewButtonDelegate](https://github.com/artsy/eigen/blob/e19ac594bf6240d076e8092d9c56e9876c94444e/Artsy/Views/Artwork/ARArtworkActionsView.h#L10-L20) 的协议映射。这有点善意谎言的意味，没有通过直接的关系来使用协议，但是它使得关系更加明显。我们使用类拓展（class extension）来[遵守这些类型的协议](https://github.com/artsy/eigen/blob/e19ac594bf6240d076e8092d9c56e9876c94444e/Artsy/View_Controllers/Artwork/ARArtworkViewController+ButtonActions.h#L11)，从而保持所有动作都在同一个地方。

### 总结

设计模式有很多，而它们全都来源于权衡。随着时间的推移，我们对于什么是"好的代码"的标准会变，这是好事。重要的是，作为开发者，我们明白，能改变我们思想的，才是我们工具链中最必不可少的技能之一。这意味着你要走出自己原本的认知范围，乐于接受那些外来的信息，或许，你会从中获得一些很不错的点子。对于创造应用持有热情是好的，不过我想，最好的程序员选择实用主义而不是理想主义。
