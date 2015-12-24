> * 原文链接: [Cocoa Architecture: Dropped Design Patterns](http://artsy.github.io/blog/2015/09/01/Cocoa-Architecture-Dropped-Design-Patterns/)
* 原文作者 : [Author: orta - Artsy Engineering](http://artsy.github.io/author/orta/)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : 
* 校对者: 
* 状态 :  待定


As a part of going through the design patterns we've found in the creation of the Artsy iOS apps, I'd like to talk a bit about some of the patterns that we've had and migrated away from. This is not 100% comprehensive, as there has been a lot of time, and a lot of people involved. Instead I'm going to try and give a birds eye view, and zoom in on some things that feel more important overall.

It's important to preface that I don't believe in perfect code, or am I a fan of big re-writes. We can spot a bad pattern, but not do anything about it. We do have apps to ship, not a codebase to make perfect for the sake of technical purity.

## NSNotifications as a decoupling method

A lot of the initial codebase for Energy relied on using NSNotifications as a way of passing messages throughout the application. There were notifications for user settings changes, download status updates, anything related to authentication and the corresponding different error states and a few app features. These relied on sending global notifications with very little attempts at scoping the relationship between objects.

NSNotificationCenter notifications are an implementation of the [Observer Pattern](https://en.wikipedia.org/wiki/Observer_pattern) in Cocoa. They are a beginner to intermediate programmer's design paradigm dream. It offers a way to have objects send messages to each other without having to go through any real coupling. As someone just starting with writing apps for iOS, it was an easy choice to adapt.

One of the biggest downsides of using NSNotifications are that they make it easy to be lazy as a programmer. It allows you to not think carefully about the relationships between your objects and instead to pretend that they are loosely coupled, when instead they are coupled but via stringly typed notifications.

Loose-coupling can have it's place but without being careful there is no scope on what could be listening to any notification. Also de-registering for interest can be a tricky thing [to learn](http://stackoverflow.com/questions/tagged/nsnotification) and the default memory-management behavior is about to change ( [for the better](https://developer.apple.com/library/prerelease/mac/releasenotes/Foundation/RN-Foundation/index.html#//apple_ref/doc/uid/TP30000742).)

We still have a [lot of notifications](https://github.com/artsy/energy/blob/702036664a087db218d3aece8ddddb2441f931c8/Classes/Constants/ARNotifications.h) in Energy, however in Eigen and Eidolon there are next to none. We don't even have a specific file for the constants.

## #define kARConstant

Not much to say here, using `#defines` as constants was definitely [in favour](https://github.com/adium/adium/blob/master/Source/AdiumAccounts.m#L24-L30)when I learned Objective-C. Likely a throw back from C. Using `#defines` as constants would not use on-device memory to store an unchanging value. This is because a `#define` uses the pre-compiler to directly change the source code to be the value, whereas using a static constant takes up memory space on the device, which we used to _really_ care about. It's likely that a modern copy of LLVM doesn't assign on device memory unless it needs to, especially for things marked `const`. Switching to real variables means you can inspect and use in a debugger and use can rely on the type system better.

What this means in practice is what when we would have had something [like](https://github.com/artsy/eigen/blob/master/Artsy/Views/Table_View_Cells/AdminTableView/ARAnimatedTickView.m#L3): `#define TICK_DIMENSION 32` it should be [migrated to](https://github.com/artsy/eigen/blob/master/Artsy/View_Controllers/App_Navigation/ARAppSearchViewController.m#L11) `static const NSInteger ARTickViewDimensionSize = 20;`.

## Sprinkling Analytics

We took some of the ideas for [Aspect oriented programming](http://albertodebortoli.github.io/blog/2014/03/25/an-aspect-oriented-approach-programming-to-ios-analytics/) with [Analytics](https://cocoapods.org/pods/ARAnalytics#user-content-aspect-oriented-dsl).

Where we used to [have this](https://github.com/artsy/energy/blob/master/Classes/Controllers/Popovers/Add%20to%20Album/ARAddToAlbumViewController.m#L271-L282):

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

## Class Methods as the whole API

For a very long time, I preferred aesthetics of class based APIs. E.g. using only class methods instead instance methods. I think I still do. However, once you start adding tests to a project then they become a bit of a problem.

I'm a big fan of the idea of Dependency Injection within tests. This, roughly _TL:DR'd_, means passing in any additional context, instead of an object finding the context itself. A common case is a call to `NSUserDefaults`. It's very likely _not_ the role of your class to know which `NSUserDefault`s object you're working with, but it's likely that you're making that decision in the method by doing something like `[[NSUserDefaults standardUserDefaults] setObject:reminderID forKey:@"ARReminderID"];`. Using dependency injection would be allowing that object to come from outside that method. If you're interested in a longer and better, explanation, read this great [objc.io](https://www.objc.io/issues/15-testing/dependency-injection/) by [Jon Reid](http://qualitycoding.org/about/).

The problem with a class based API, is that it becomes difficult to inject that object. This doesn't flow well with writing simple, fast tests. You can use a mocking library to fake the class API, but that feels weird. Mocking should be used for things you don't control. You control the object if you're making the API. Having an instance'd object means being able to provide different versions with different behaviors or values, even better if you can reduce the behavior to [a protocol](https://github.com/artsy/eigen/blob/e19ac594bf6240d076e8092d9c56e9876c94444e/Artsy/Networking/Network_Models/ARArtistNetworkModel.h).

## Objects Sneakily Networking

When you have a complicated application, there can be a lot of places you can perform networking. We've had it in models, view controllers and views. Basically throwing the idea of purity in MVC out of the system. We started to recognise a pattern in eigen, we were not doing a good job of keeping our networking well abstracted. If you want to see the full story check out the [moya/Moya README](https://github.com/Moya/Moya).

One attempt to at trying to fix this pattern by creating a different type of networking client I've just referenced, [Moya](https://github.com/Moya/Moya).

The other was to abstract any networking performed into a separate object. If you've heard of Model-View-ViewModel ([MVVM](http://www.teehanlax.com/blog/model-view-viewmodel-for-ios/)) then this is a similar premise for networking instead of views. Network Models give us a way to abstract the networking into a set of behaviors. The extra abstraction means that you think "I want the things related to _x_" instead of "send a GET to address _x_ and turn it into _y_."

Network models also make it extremely easy to swap behavior out in tests. In eigen, we have our asynchronous networking [run synchronously in tests](https://github.com/artsy/eigen/pull/575) but we still use the network models to be able to provide [whatever data we want to expect](https://github.com/artsy/eigen/blob/master/Artsy_Tests/View_Controller_Tests/Artist/ARArtistViewControllerTests.m#L29-L40) from the server in our tests.

## Subclassing more than twice

As projects evolve it can become very easy to subclass _x_ in order to provide a "similar but a little bit different" behavior. Perhaps you need to [override some methods](https://github.com/artsy/eigen/blob/e19ac594bf6240d076e8092d9c56e9876c94444e/Artsy/View_Controllers/Web_Browsing/ARTopMenuInternalMobileWebViewController.m#L58), or add a [specific behavior](https://github.com/artsy/eigen/blob/e19ac594bf6240d076e8092d9c56e9876c94444e/Artsy/View_Controllers/Web_Browsing/AREndOfLineInternalMobileWebViewController.h#L5). Like the [urban myth](http://ezinearticles.com/?The-Boiled-Frog-Phenomenon&id=932310) of a frog being slowly boiled, you end up with a difficult to understand codebase as expected behavior mutates depending on how deep the hierarchy goes.

One pattern for handling this is [class composition](http://stackoverflow.com/questions/9710411/ios-grasping-composition). This is the idea that instead of having one object do multiple things, you allow a collection of objects to work together. Providing more space for each object to conform to the Single Responsibility Principal ([SRP](https://en.wikipedia.org/wiki/Single_responsibility_principle).) If you're interested in this, you may also be interested in the [class clusters](https://developer.apple.com/library/ios/documentation/General/Conceptual/CocoaEncyclopedia/ClassClusters/ClassClusters.html) pattern.

A good example of this comes [from Energy](https://github.com/artsy/energy/blob/aa97d90cf37932d4c0f49ea4c4d31f7e491f16a6/Classes/Controllers/Top%20View%20Controller/ARTopViewToolbarController.m), our root view controller `ARTopViewController` used to control its own toolbar items. Over 4 years this became difficult to manage, and a lot of extra code in the view controller. By abstracting out the implementation details of managing the toolbar items into it's [own class](https://github.com/artsy/energy/blob/aa97d90cf37932d4c0f49ea4c4d31f7e491f16a6/Classes/Controllers/Top%20View%20Controller/ARTopViewToolbarController.m) we were able to allow the `ARTopViewController` to state what it wanted by not how it was done.

## Configuration Classes over Inter-Class Communication

A one of the most important aspects of Energy is to [email artworks](http://folio.artsy.net). So there is a lot of code around configuring the email you want to send, and then generating HTML from those settings. This started out pretty simple as we had very few app-wide settings. Over time, deciding what we need to show in terms of settings and how they affected the email became very complicated.

The part that eventually became a strong enough code-smell to warrant a re-write was the view controller which allowed a partner to choose what information to send would pass details individually to an object that would generate the HTML. I found it difficult to write simple tests for the class' behavior. Initially I would mock the email composer, then inspect the methods that were called. This felt wrong, as you shouldn't really be mocking classes you own. Given the importance of the functionality that classes provide our application, ideas on ways to improve the section of code stayed on my mind for a long time.

The fix came to me during Justin Searls' talk [Sometimes a Controller is Just a Controller](https://speakerdeck.com/searls/sometimes-a-controller-is-just-a-controller) - specifically slide [55](https://speakerdeck.com/searls/sometimes-a-controller-is-just-a-controller?slide=55). Justin talks about objects that _either hold and describe a value or perform useful behavior, never both_.

I took this advice and re-evaluated the relationship between settings view controller and composer object. Initially settings would configured the composer, afterwards the settings would create a configuration object and the composer would consume it. This made it _significantly_ easier to write tests for both objects. As they had very obvious inputs and outputs in the form of a [AREmailSettings](https://github.com/artsy/energy/blob/aa97d90cf37932d4c0f49ea4c4d31f7e491f16a6/Classes/Util/Emails/AREmailSettings.h). The [AREmailComposerTests](https://github.com/artsy/energy/blob/aa97d90cf37932d4c0f49ea4c4d31f7e491f16a6/ArtsyFolio%20Tests/Util/AREmailComposerTests.m) in particular become much more elegant.

### Direct use of Responder Chain

Before I worked at Artsy, I was a [Mac developer](http://i.imgur.com/Am9LjED.gif), I've been doing that since before iOS existed, so this influences my code style. One of the great parts of the Cocoa toolchain is the [responder chain](https://developer.apple.com/library/ios/documentation/EventHandling/Conceptual/EventHandlingiPhoneOS/event_delivery_responder_chain/event_delivery_responder_chain.html), a well documented way of passing methods up a known chain of objects. It solves a common problem with complicated view structures. You could have a button that is generated at runtime deep inside a view hierarchy and you would like the view controller to handle it being tapped. You could use a long chain of delegate methods, or use a [private method](https://twitter.com/unimp0rtanttech/status/555828778015129600) to get the reference to the view controller instance. On the Mac usage of the responder chain is a common pattern, on iOS it is used rarely.

We have this problem with our Artwork view controller in Eigen. There are buttons that are many [stack views deep](https://speakerdeck.com/orta/ios-at-artsy?slide=38) that need to pass a message back to the view controller. When we first hit this the issue I immediately used the responder chain, you write a [line of code](https://github.com/artsy/eigen/blob/e19ac594bf6240d076e8092d9c56e9876c94444e/Artsy/Views/Artwork/ARArtworkActionsView.m#L85) like: `[bidButton addTarget:self action:@selector(tappedBidButton:) forControlEvents:UIControlEventTouchUpInside];` where the `self` is referring to the view. This would send the message `tappedBidButton:` up the responder chain where it is reacted upon by the [ARArtworkViewController](https://github.com/artsy/eigen/blob/e19ac594bf6240d076e8092d9c56e9876c94444e/Artsy/View_Controllers/Artwork/ARArtworkViewController+ButtonActions.m#L114).

I had to explain the premise of the responder chain to almost everyone touching this area of the code base. This is great in terms of the ["lucky 10,000"](https://xkcd.com/1053/) but means that the pattern is unintuitive to those who have not previously heard of it. There was one more issue, the lack of coupling means that renaming selectors via refactoring can break the chain.

The way that we reduced the cognitive load was via a protocol, all of the actions that the responder chain will use are mapped inside [ARArtworkActionsViewButtonDelegate](https://github.com/artsy/eigen/blob/e19ac594bf6240d076e8092d9c56e9876c94444e/Artsy/Views/Artwork/ARArtworkActionsView.h#L10-L20)-like protocols. It's a bit of a white-lie given that there is no direct relationship using the protocol in the app, but it makes the relationship more obvious. We use a class extension that [conforms to these types of protocols](https://github.com/artsy/eigen/blob/e19ac594bf6240d076e8092d9c56e9876c94444e/Artsy/View_Controllers/Artwork/ARArtworkViewController+ButtonActions.h#L11) to keep the actions all kept in one place.

### Wrap-up

There are many design patterns, and they all come with trade-offs. Over time, our opinions on what is "good code" changes, this is great. It's important that as developers we understand that being able to change our minds is one of the most vital skills we have in our toolchain. This means being open to opinions outside of your usual sphere of influence and to maybe bring some good ideas from them. It's great to be passionate about an aspect of how we craft applications, but from my perspective, the best programmers choose pragmatism over idealism.
