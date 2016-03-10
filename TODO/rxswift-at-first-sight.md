> * 原文链接 : [RxSwift at first sight](https://blog.alltheflow.com/rxswift-at-first-sight/?utm_campaign=iOS%2BDev%2BWeekly&utm_medium=email&utm_source=iOS_Dev_Weekly_Issue_236)
* 原文作者 : [alltheflow](https://blog.alltheflow.com/)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [SatanWoo](https://github.com/SatanWoo)
* 校对者 : [iThreeKing](https://github.com/iThreeKing), [davidear](https://github.com/davidear)
* 状态 : 校对完成

# RxSwift 的第一印象

去年整整一年，我都在试图理解响应式编程的原理是什么，并且试图验证如果在我的app中使用这种编程范式是否会带来好处。于是，我查询了许多相关的解决方案，从 [ReactiveCocoa](https://github.com/ReactiveCocoa/ReactiveCocoa) & Objective-C 开始，及其 Swift 版本 [ReactiveCocoa with Swift](https://blog.alltheflow.com/reactive-swift-upgrading-to-reactivecocoa-3-0/)，再到我朋友实现的一个轻量级的框架 [VinceRP](https://github.com/bvic23/VinceRP)。上述这些都是令人赞叹不已的项目，ReactiveCocoa 的项目成熟度非常高，但是十分复杂；而VinceRP的实现非常容易，所以理解起来非常简单。

在学习的过程中，我写了一系列关于[我学习响应式编程的经历](https://blog.alltheflow.com/tag/reactive)的文章，所以经常会被读者问到一些关于 [RxSwift](https://github.com/ReactiveX/RxSwift) 的问题。惭愧地说，我还从没有使用RxSwift来编写一个项目。实际上我还从来没用过任何语言的 [Rx](http://reactivex.io/languages.html) 框架，所以我一直认为，对于那些曾在别的开发环境中有使用Rx经历的人来说，理解RxSwift是非常容易的。既然如此，我也是时候来尝试一把了。

## Rx

Rx是最常使用的一个响应式编程框架。它与其他RP框架的一大不同是它的跨平台特性，同时，它有着最大的开源社区，无数的文档以及有参考价值的问题讨论，许许多多的人不断地对其进行改进。

## Swift
这门语言在去年一年中飞速的成长，并且现在也进行了[开源](https://github.com/apple/swift)了。一些像RxSwift之类的项目也随着其一起成长。因此，现在已经没有什么理由可以再阻止你去使用Swift这项技术了。当然，一些重大的改动仍然被列在radar上，但它们很可能在短时间内不会被解决，这就意味着这个项目会不断地被改进，这不是很好吗？

## 使用 RxSwift 开发一个app

如果你曾阅读过[我的博客](https://blog.alltheflow.com)，可能你现在会猜我使用RxSwift开发了一个app。没错，你是对的。这是个很耗时的习惯，但是我不喜欢依赖于一个理想的环境，所以通常我都会写一个例子来让我有那么一点感觉。通过这种方式，我可以很好理解如何让框架为我工作，而不是我为它工作。这里我想说一点个人感受，对于解决问题来说，你所选用的框架只是万千可用方案中的一种，因此，方案的选择是因人而异的。而这些选择所带来的多样性，正是我如此热爱编程的一大原因。

我所写的这个应用名叫 [iCopyPasta](https://github.com/alltheflow/iCopyPasta)，是一个在去年[Functional Swift Conf](http://2015.funswiftconf.com/) 上展示的Mac剪贴板应用 [CopyPasta](https://github.com/alltheflow/copypasta) 的iOS姐妹版。显而易见，它们并不是一个完整的产品所以并不可以被用来上架。我现在每天都使用Mac版本的CopyPasta，但是我可能存在某些偏见。我的计划是将来会发布Mac版本和iOS版本的CopyPasta应用，并可能会将这两个版本进行打通。

> 难道这不是我一直以来的计划吗？  

### Observables

我首先对 [`UIPasteboard`](https://developer.apple.com/library/prerelease/ios/documentation/UIKit/Reference/UIPasteboard_Class/index.html) 开启监听，这些监听会对你拷贝东西时出现在 UIPasteboard 中的字符串和图像类型进行观测。

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

之前我的方法是直接对`UIPasteboard`中的`字符串`和`图像`直接进行观察，但是这个方法是不稳妥的。原因在于`UIPasteboard`可能不是一个KVO安全的类型（具体请看下方的评论）。参考别人的建议后，我使用RxSwift另一个非常棒的特性[`rx_notification`](https://github.com/ReactiveX/RxSwift/blob/83bac6db0cd4f7dd3e706afc6747bd5797ea16ff/RxCocoa/Common/Observables/NSNotificationCenter%2BRx.swift#L23)来监听`UIPasteboardChangedNotification `

    .subscribeNext { [weak self] pasteboardItem in
        if let item = pasteboardItem {
            self?.addPasteboardItem(item)
        }
    }

这里的`pasteboard `是一个`Observable<NSNotification>`，这也是为什么可以很容易得订阅其`.Next`事件同时相应地去更新`tableView`。而`map`则是从监听到的通知所涉及的对象中获取字符串或者图像，并将获取到的结果转换成[`PasteboardItem`](https://github.com/alltheflow/iCopyPasta/blob/master/iCopyPasta/PasteboardItem.swift#L41)。

### Dispose bags

订阅信号会产生`Disposable`。如果不终止订阅，那么这些生成的`Disposable `将会一直存在，这无疑是非常耗内存的。所以，你要么对这些订阅调用`dispose `，要么你可以像我一样，使用[dispose bags](https://github.com/ReactiveX/RxSwift/blob/master/Documentation/GettingStarted.md#dispose-bags)来自动销毁相关的订阅。

    .addDisposableTo(disposeBag)
     
### UIKit/Appkit bindings

你可以很容易地通过[`rx_itemsWithCellIdentifier`](https://github.com/ReactiveX/RxSwift/blob/b00d35a5ef13dbcf57257f47fb14a60a2c924d19/RxCocoa/iOS/UITableView%2BRx.swift#L46)将[`Observable`](https://github.com/ReactiveX/RxSwift/blob/master/Documentation/GettingStarted.md#observables-aka-sequences)序列绑定到table view上。`element`来自于我定义的[`PasteboardItem`](https://github.com/alltheflow/iCopyPasta/blob/master/iCopyPasta/PasteboardItem.swift#L41)枚举类型，这也是为什么我会采用Switch来处理这个对象，这样可以根据其具体的枚举值来显示不同的样式。

    pasteViewModel.pasteboardItems()
        .bindTo(tableView.rx_itemsWithCellIdentifier("pasteCell", cellType: UITableViewCell.self)) { (row, element, cell) in
         switch element {
         case .Text(let string):
             cell.textLabel?.text = String(string)
         case .Image(let image):
             cell.imageView?.image = image
    }.addDisposableTo(disposeBag)

另外一个很棒的补充是[`rx_modelSelected`](https://github.com/ReactiveX/RxSwift/blob/b00d35a5ef13dbcf57257f47fb14a60a2c924d19/RxCocoa/iOS/UITableView%2BRx.swift#L204)。你可以通过它来获取你触发选择事件时对应的`element`。简单来说，它是一个对`tableView:didSelectRowAtIndexPath:`的封装，可以将代码变得非常简洁。

    tableView
        .rx_modelSelected(PasteboardItem)
        .subscribeNext { [weak self] element in
            self?.pasteViewModel.addItemsToPasteboard(element)
        }.addDisposableTo(disposeBag)
        
你可以通过如下链接来查看所以关于 UIKit/AppKit（RxCocoa）的扩展[RxSwift's GitHub](https://github.com/ReactiveX/RxSwift/blob/master/Documentation/API.md#rxcocoa-extensions)。

## 总体感受

到目前为止，我还只是探索了 RxSwift 能力的一小部分，但是我已经感受到 RxSwift 是一个非常棒的框架。如果能够更深入理解它的机制并学会基于它的设计思路进行思考，那肯定会更好。

我非常喜欢一些像 [Rx.playground](https://github.com/ReactiveX/RxSwift/tree/master/Rx.playground)，[RxMarbles](http://rxmarbles.com/) 这样的资料及 [great community](https://github.com/ReactiveX) 这样的社区。这些资料给了我很多的灵感，所以我也乐于将我的学习经验分享给 [bitrise.io](http://bitrise.io) 的用户。还有一些比较重要的内容，比如[schedulers](https://github.com/ReactiveX/RxSwift/blob/master/Documentation/Schedulers.md#custom-schedulers)还未被涉及，但是绝对值得研究一番。

对我来说，我还需要一段时间来更好地理解 Rx。与我尝试 ReactiveCocoa 只有个把小时不同，我现在可以每天都在工作中使用 RxSwift，并且坚持使用超过了一年。这都得感谢[在 Prezi 的伙伴们](https://twitter.com/bvic23).

作为一个曾经学习过 ReactiveCocoa 的人来说，我现在更倾向于使用 RxSwift，可能是因为我现在自认为已经对于 RxSwift 已经足够了解，并且使用它可以很快得完成我的编码任务。当然，在将来我可能会同时使用两者，但是我认为对于两者之间任一框架的熟练使用不代表会在学习另外一个框架的时候给你带来很大的优势。它们在几个方面有着[不同](https://stackoverflow.com/questions/32542846/reactivecocoa-vs-rxswift-pros-and-cons/32581824#32581824)。同时，这两个框架（概括来说应该是所有的响应式编程框架）都有着陡峭的学习曲线。对于我来说，我已经度过了学习 ReactiveCocoa 最难的那段时光，但如果你是一个初学者，我建议你自己动手尝试这两种框架，甚至更多。

## 深入阅读

如果你还在思考应该使用哪个响应式编程的框架，那么我建议你去读一读 Ash Furrow 所写的关于如何挑选响应式编程框架的[文章](https://ashfurrow.com/blog/reactivecocoa-vs-rxswift/)。

你也可以看看其他一些在 iOS 中使用响应式编程的[视频及文章](https://gist.github.com/JaviLorbada/4a7bd6129275ebefd5a6)，这些内容都非常得棒，相信你会受益匪浅。
