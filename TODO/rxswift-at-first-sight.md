* 原文链接 : [RxSwift at first sight](https://blog.alltheflow.com/rxswift-at-first-sight/?utm_campaign=iOS%2BDev%2BWeekly&utm_medium=email&utm_source=iOS_Dev_Weekly_Issue_236)
* 原文作者 : [alltheflow](https://blog.alltheflow.com/)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : 
* 校对者 :
* 状态 : 认领中


I spent my last year figuring out how reactive programming works and whether it's good for me and my apps if I'm experimenting with it. I got familiar with various solutions, starting with [ReactiveCocoa](https://github.com/ReactiveCocoa/ReactiveCocoa) & Objective-C, [ReactiveCocoa with Swift](https://blog.alltheflow.com/reactive-swift-upgrading-to-reactivecocoa-3-0/), [VinceRP](https://github.com/bvic23/VinceRP) my friend's lightweight implementation. All of these are amazing projects, one with its maturity and complexity, one with its easy to understand concept.

Along the way I wrote some articles about [my experiences with reactive](https://blog.alltheflow.com/tag/reactive/) and I got asked a lot recently about [RxSwift](https://github.com/ReactiveX/RxSwift). Shamelessly I never had the chance to start a project with it. Okay, let me be a little more honest here. I never tried [Rx](http://reactivex.io/languages.html) in any language before, so I always thought about RxSwift as it's something easy to use for _people who used Rx_ previously in a different environment. Now is the time for me to try it out.

## Rx

It's the most commonly used implementation of the reactive paradigms. A difference compared to other RP libraries is that given it's cross-platform, it has the biggest community, tons of documentation and discussions available and a lot of people contributing.

## Swift

The language grew a lot in the last year, it's also [open source](https://github.com/apple/swift) now. Projects like RxSwift grew with it together, there is not much to stop you from using it anymore. Breaking changes are still on the radar, but they might not go away soon. It probably means continuous improvements, which is good, right?

## An app with RxSwift

If you've ever read a post on [my blog](https://blog.alltheflow.com) at this point your guess is probably that I wrote an app using RxSwift and you are right. That's a time-expensive habit, but I don't like to rely on ideal environment examples so I usually write an app that makes at least a little sense. This way I can understand how to get the framework to work _for_ me, not the other way around. The framework you use is one major mutating factor to the infinite ways of solving a problem. This diversity is probably one of the reasons why I'm so in love with programming though.

So this one is called [iCopyPasta](https://github.com/alltheflow/iCopyPasta), little sister and iOS version of [CopyPasta](https://github.com/alltheflow/copypasta), the Mac pasteboard feed demo app for last year's [Functional Swift Conf](http://2015.funswiftconf.com/). Of course these are not production ready apps so they are not ready for distribution. I'm using the Mac version every day, but I might be biased. The plan is to deliver both in the future, maybe connected to each other.

> Isn't it always the plan?

### Observables

I started out with observing the [`UIPasteboard`](https://developer.apple.com/library/prerelease/ios/documentation/UIKit/Reference/UIPasteboard_Class/index.html) for updates about `string` and `image` types arriving to the pasteboard when you copy something.

    let pasteboard = NSNotificationCenter.defaultCenter().rx_notification("UIPasteboardChangedNotification", object: nil)
    _ = pasteboard.map { [weak self] (notification: NSNotification) -> PasteboardItem? in
        if let pb = notification.object as? UIPasteboard {
            if let string = pb.valueForPasteboardType(kUTTypeUTF8PlainText as String) {
                return self?.pasteboardItem(string)
            }
            if let image = pb.valueForPasteboardType(kUTTypeImage as String) {
                return self?.pasteboardItem(image)
            }
        }
        return nil
    }

Previously I observed `string` and `image` on the general `UIPasteboard` directly, but it turned out to be a fragile solution, because `UIPasteboard` might not be KVO-safe (see the comments below). Based on the advice I used another great feature of RxSwift to observe the `UIPasteboardChangedNotification` with [`rx_notification`](https://github.com/ReactiveX/RxSwift/blob/83bac6db0cd4f7dd3e706afc6747bd5797ea16ff/RxCocoa/Common/Observables/NSNotificationCenter%2BRx.swift#L23).

    .subscribeNext { [weak self] pasteboardItem in
        if let item = pasteboardItem {
            self?.addPasteboardItem(item)
        }
    }

The `pasteboard` here will be an `Observable&lt;NSNotification&gt;` that's why it was easy to `subscribe` to its `.Next` events and update the table view accordingly. The `map` is necessary to get the string or image from the object received through the notification and turn it into a [`PasteboardItem`](https://github.com/alltheflow/iCopyPasta/blob/master/iCopyPasta/PasteboardItem.swift#L41).

### Dispose bags

Subscriptions produce `Disposable`s which are going to be allocated permanently if the given subscription doesn't terminate. This way you either have to call `dispose` on them, or use [dispose bags](https://github.com/ReactiveX/RxSwift/blob/master/Documentation/GettingStarted.md#dispose-bags) for automatic disposal like I did.

    .addDisposableTo(disposeBag)

### UIKit/Appkit bindings

You can bind an [`Observable`](https://github.com/ReactiveX/RxSwift/blob/master/Documentation/GettingStarted.md#observables-aka-sequences) sequence to a table view easily with the power of [`rx_itemsWithCellIdentifier`](https://github.com/ReactiveX/RxSwift/blob/b00d35a5ef13dbcf57257f47fb14a60a2c924d19/RxCocoa/iOS/UITableView%2BRx.swift#L46). The `element` is coming from my [`PasteboardItem`](https://github.com/alltheflow/iCopyPasta/blob/master/iCopyPasta/PasteboardItem.swift#L41) enum here, that's why I'm switching over it, to make a difference in the representation.

    pasteViewModel.pasteboardItems()
        .bindTo(tableView.rx_itemsWithCellIdentifier("pasteCell", cellType: UITableViewCell.self)) { (row, element, cell) in
         switch element {
         case .Text(let string):
             cell.textLabel?.text = String(string)
         case .Image(let image):
             cell.imageView?.image = image
    }.addDisposableTo(disposeBag)

Another great addition is [`rx_modelSelected`](https://github.com/ReactiveX/RxSwift/blob/b00d35a5ef13dbcf57257f47fb14a60a2c924d19/RxCocoa/iOS/UITableView%2BRx.swift#L204), where you can get your `element` back when selection is triggered. It's basically a wrapper for `tableView:didSelectRowAtIndexPath:`. Neat!

    tableView
        .rx_modelSelected(PasteboardItem)
        .subscribeNext { [weak self] element in
            self?.pasteViewModel.addItemsToPasteboard(element)
        }.addDisposableTo(disposeBag)

Check out all the UIKit/AppKit (RxCocoa) extensions on [RxSwift's GitHub](https://github.com/ReactiveX/RxSwift/blob/master/Documentation/API.md#rxcocoa-extensions).

## Overall feelings

I've seen a very little of what RxSwift is capable of, but I've seen enough to know Rx is a great implementation. It's nice to understand a bit more about how it works and how to _think in it_.

I loved having this amount of learning content around, like the [Rx.playground](https://github.com/ReactiveX/RxSwift/tree/master/Rx.playground) in the repository, [RxMarbles](http://rxmarbles.com/) and a [great community](https://github.com/ReactiveX). It inspired me a lot, I'd love to share similar developer experience with our users at [bitrise.io](http://bitrise.io). A lot of important features, like [schedulers](https://github.com/ReactiveX/RxSwift/blob/master/Documentation/Schedulers.md#custom-schedulers) I hadn't cover, but worth checking.

It's clear for me, that I need more time to understand Rx better. It wasn't hours with ReactiveCocoa, I was lucky enough to work with it day by day for more than a year, thanks to the [guys back at Prezi](https://twitter.com/bvic23).

As someone who _started_ with ReactiveCocoa though, I'd still prefer to coding in it, probably because I'm already confident and fast with it. I will probably use both in the future, but I think practice in one of them might not mean significant advantage when learning the other. They have [differences](https://stackoverflow.com/questions/32542846/reactivecocoa-vs-rxswift-pros-and-cons/32581824#32581824) on several levels and both of them (and reactive programming in general) has a steep learning curve. I'm already on the bright side with ReactiveCocoa, but if you are just starting up I suggest to try out both, or even more.

## To read

If you're still trying to figure out which RP library to use, I recommend to read [Ash Furrow's writing](https://ashfurrow.com/blog/reactivecocoa-vs-rxswift/) about how to choose.

Go ahead and check out some [videos/articles about F(R)P in iOS](https://gist.github.com/JaviLorbada/4a7bd6129275ebefd5a6) for great videos & articles in the topic.
