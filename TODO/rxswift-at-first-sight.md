* 原文链接 : [RxSwift at first sight](https://blog.alltheflow.com/rxswift-at-first-sight/?utm_campaign=iOS%2BDev%2BWeekly&utm_medium=email&utm_source=iOS_Dev_Weekly_Issue_236)
* 原文作者 : [alltheflow](https://blog.alltheflow.com/)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : davidear
* 校对者 :
* 状态 : 认领中


去年我花了一年的时间来研究响应式编程的工作原理以及它是否适合我和我的开发工作。我尝试了解了各种解决方式，从[ReactiveCocoa](https://github.com/ReactiveCocoa/ReactiveCocoa) & Objective-C, [ReactiveCocoa with Swift](https://blog.alltheflow.com/reactive-swift-upgrading-to-reactivecocoa-3-0/),到我朋友的轻量级的框架 [VinceRP](https://github.com/bvic23/VinceRP)。这些都是非常棒的项目，一些功能复杂而成熟，另一些则简明易懂。

虽然一直以来我写了不少关于响应式编程的文章[my experiences with reactive](https://blog.alltheflow.com/tag/reactive/) ，而且最近我也被多次问到[RxSwift](https://github.com/ReactiveX/RxSwift)。但惭愧的是，我并没有机会真正的在一个项目中使用过它。我甚至从未使用过任何[Rx](http://reactivex.io/languages.html)。RxSwift对 _在其他语言中使用过RX_的人来说，应该是非常容易上手的。那么现在是时候来试试它了。
## Rx

RX系列是在响应式编程中应用最广泛的框架。与其他响应式编程框架相比，它显著的特性就是跨平台，并且它拥有最大的开发社区，大量的文档、讨论以及大量社区贡献者。

## Swift

Swift在去年有了相当大的增长，而且它现在也[开源](https://github.com/apple/swift)了。各种框架都在随着该语言一起增长，例如RXSwift。从现在来看，基本上没有什么大的缺陷会让你打消使用它的念头。虽然他现在还会有非兼容式的修改，但这正说明它在不断地变得更好，这不很好么？

## 使用 RxSwift

如果你在[我的博客](https://blog.alltheflow.com)中看过相关的文章，那么你能猜到我在使用RxSwift开发应用。虽然很耗时，但我喜欢写一个还有点用处的应用，而不仅仅是一个案例。通过这样，我才知道如何发挥框架的作用，而不是为了使用框架而使用。解决问题有很多途径，而选好一个框架毫无疑问是其决定性的。这种解决问题的多样性，恰恰是我爱上编程的原因。


这个应用叫[iCopyPasta](https://github.com/alltheflow/iCopyPasta)， [CopyPasta](https://github.com/alltheflow/copypasta)的姊妹篇---iOS版本，MAC版的示例应用则是为了去年的[Functional Swift Conf](http://2015.funswiftconf.com/)。当然这些应用都不会去销售，所以他们没有准备发布。我每天都在使用这个应用的Mac版，所以我可能更加偏爱Mac版。也许将来某一天，我会将这两个应用连接起来，做成一个套件。

> 计划总是有的嘛

### 监听

首先，我监听[`UIPasteboard`](https://developer.apple.com/library/prerelease/ios/documentation/UIKit/Reference/UIPasteboard_Class/index.html)的`string` 和 `image`类型的变化，在每次当你复制某些东西到剪贴板的时候触发。

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


最开始，我直接监听`UIPasteboard`的`string`和`image`类型变化，但我很快发现这是个坏主意。因为`UIPasteboard`并不是KVO安全的（看下面评论）.因此我采用了RxSwift的一个很棒的特性[`rx_notification`](https://github.com/ReactiveX/RxSwift/blob/83bac6db0cd4f7dd3e706afc6747bd5797ea16ff/RxCocoa/Common/Observables/NSNotificationCenter%2BRx.swift#L23)来监听 `UIPasteboardChangedNotification` 

    .subscribeNext { [weak self] pasteboardItem in
        if let item = pasteboardItem {
            self?.addPasteboardItem(item)
        }
    }

这里`剪贴板`将是可以被`监听的`，也正是通过这样的手段来订阅它的`下一个`事件并且更新列表。`映射`则是从通知中的对象获取字符和图像，以及将他转换成 [`PasteboardItem`](https://github.com/alltheflow/iCopyPasta/blob/master/iCopyPasta/PasteboardItem.swift#L41).的关键。

### 注销处理

订阅会被记录到内存地址上，如果不终止它的话，它是不会被注销的。所以你可以主动的移除它们，或者像我一样使用[dispose bags](https://github.com/ReactiveX/RxSwift/blob/master/Documentation/GettingStarted.md#dispose-bags)来自动释放。

    .addDisposableTo(disposeBag)

### UIKit/Appkit bindings

You can bind an [`Observable`](https://github.com/ReactiveX/RxSwift/blob/master/Documentation/GettingStarted.md#observables-aka-sequences) sequence to a table view easily with the power of [`rx_itemsWithCellIdentifier`](https://github.com/ReactiveX/RxSwift/blob/b00d35a5ef13dbcf57257f47fb14a60a2c924d19/RxCocoa/iOS/UITableView%2BRx.swift#L46). The `element` is coming from my [`PasteboardItem`](https://github.com/alltheflow/iCopyPasta/blob/master/iCopyPasta/PasteboardItem.swift#L41) enum here, that's why I'm switching over it, to make a difference in the representation.

你可以通过[`rx_itemsWithCellIdentifier`](https://github.com/ReactiveX/RxSwift/blob/b00d35a5ef13dbcf57257f47fb14a60a2c924d19/RxCocoa/iOS/UITableView%2BRx.swift#L46)给列表绑定一个监听序列。其`元素`来自于[`PasteboardItem`](https://github.com/alltheflow/iCopyPasta/blob/master/iCopyPasta/PasteboardItem.swift#L41)的枚举，因此我做了些变换，使其描述有一些区别。

    pasteViewModel.pasteboardItems()
        .bindTo(tableView.rx_itemsWithCellIdentifier("pasteCell", cellType: UITableViewCell.self)) { (row, element, cell) in
         switch element {
         case .Text(let string):
             cell.textLabel?.text = String(string)
         case .Image(let image):
             cell.imageView?.image = image
    }.addDisposableTo(disposeBag)

另一个优势是[`rx_modelSelected`](https://github.com/ReactiveX/RxSwift/blob/b00d35a5ef13dbcf57257f47fb14a60a2c924d19/RxCocoa/iOS/UITableView%2BRx.swift#L204)，你可以在选择触发时再获取`元素`。这是对`tableView:didSelectRowAtIndexPath:`的再次封装。很棒！

    tableView
        .rx_modelSelected(PasteboardItem)
        .subscribeNext { [weak self] element in
            self?.pasteViewModel.addItemsToPasteboard(element)
        }.addDisposableTo(disposeBag)

查看RxCocoa的所有特性请阅读[RxSwift's GitHub](https://github.com/ReactiveX/RxSwift/blob/master/Documentation/API.md#rxcocoa-extensions).

## 使用感受

我仅仅使用了RxSwift的非常小的功能，但我已经明显的感受到它的强大，让我很想继续了解其工作原理和使用。

我有一些非常棒的学习的站点，像[Rx.playground](https://github.com/ReactiveX/RxSwift/tree/master/Rx.playground)、[RxMarbles](http://rxmarbles.com/) 和[专属社区](https://github.com/ReactiveX)。我从中学到了很多，同时我也喜欢在[bitrise.io](http://bitrise.io)上与其他开发者分享我的一些使用。还有一些重要的特性，如[schedulers](https://github.com/ReactiveX/RxSwift/blob/master/Documentation/Schedulers.md#custom-schedulers)我还没有使用到，但值得一学。

很明显，我需要更多的时间来加强对Rx的理解。但这不是几个小时的事，而我则有幸可以在工作中使用它超过一年的时间，非常感谢[guys back at Prezi](https://twitter.com/bvic23)


就像许多已经使用ReactiveCocoa的同学一样，我也选择使用它编程，也许是我已经对它很熟练。以后，我会同时使用两者，但我不认为在其中一个框架的经验会对学习另一个有非常显著的帮助。他们有显著的[区别](https://stackoverflow.com/questions/32542846/reactivecocoa-vs-rxswift-pros-and-cons/32581824#32581824)在许多地方，并且两者都有一个陡峭的学习曲线。我已经熟练使用ReaciveCocoa，但如果你刚刚开始学习，那么我建议两者都尝试一下，甚至其他更多框架。

## 更多推荐

如果你还在思考到底应该使用哪个响应式编程框架，那么我推荐你看看[Ash Furrow's writing](https://ashfurrow.com/blog/reactivecocoa-vs-rxswift/)关于如何选择的文章

另一个推荐，[videos/articles about F(R)P in iOS](https://gist.github.com/JaviLorbada/4a7bd6129275ebefd5a6)有许多相关的文章和视频。
