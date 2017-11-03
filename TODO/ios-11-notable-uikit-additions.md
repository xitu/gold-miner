> * 原文地址：[iOS 11: Notable UIKit Additions](https://medium.com/the-traveled-ios-developers-guide/ios-11-notable-uikit-additions-92e5eb421c3b)
> * 原文作者：本文已获原作者 [Jordan Morgan](https://medium.com/@JordanMorgan10) 授权
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：[zhangqippp](https://github.com/zhangqippp)
> * 校对者：[Danny1451](https://github.com/Danny1451)，[atuooo](https://github.com/atuooo)

# iOS 11：UIKit 中值得注意的新能力

![](https://camo.githubusercontent.com/63483ef51131c9e01754955128f5154d1efd4e27/68747470733a2f2f63646e2d696d616765732d312e6d656469756d2e636f6d2f6d61782f323030302f312a3661395976546c4f6d6c34414e466c43413036526e512e6a706567)

本周每个 iOS 开发者都在热切地观看 W.W.D.C. 的宣讲视频 😜

苹果的常用框架又有了新玩法

在苹果的粉丝群体中被称为 #HairForceOne 的 Craig Federighi ，在 48 小时前揭开了 iOS 11 的新面目。毫无疑问我们又有了新的 API 可以研究。相比受到了重点照顾的 iPad ，苹果今年没有给 iPhone 过多的介绍。

趁着还没有忘记，我总结了几条吸引我的新变化，顺序与重要性无关。

#### UIStackView

大家都喜爱的 UIStackView 只得到了一点点改变，但关键是这正是它所需要的。我曾经写过这样一篇文章 [stack view 的结构越复杂就越灵活](https://medium.com/the-traveled-ios-developers-guide/uistackview-a-field-guide-c1b64f098f6d) ，但是在它的强大和神奇的自动布局之外，有一点它做的不够好：改变它子视图之间的间距。

在 iOS 11 中这一点得到了改善。事实上 PSPDFKit 的 [Pete Steinberger](https://twitter.com/steipete) 问大家 UIKit 的改善中什么使我们印象最深刻，我的第一想法是：

![](https://ws2.sinaimg.cn/large/006tNbRwgy1fgdl477eldj30jp06tq3f.jpg)

这个改善可以通过一个新的方法简单地实现：

```
let view1 = UIView()
let view2 = UIView()
let view3 = UIView()
let view4 = UIView()
let horizontalStackView = UIStackView(arrangedSubviews: [view1, view2, view3, view4])
horizontalStackView.spacing = 10
// Put another 10 points of spacing after view3
horizontalStackView.setCustomSpacing(10, after: view3)
```

我自己在使用 stack view 时无数次遇到上面这种场景，非常别扭。在旧版本的 UIStackView 的实现中，你只能将所有的间距设置为一致的值，或者添加一个 “spacer” 视图（ API 刚出现时就有的一个非常古老的属性）来添加间距。 

如果你的 U.I. 需要以动画的形式增加或减少子视图之间的间距，稍后可以去查询和设置相关参数：

    let currentPadding = horizontalStackView.customSpacing(after: view3)

#### UITableView

在开发者社区中一直有一个争论：table view 是否应该被一个 collection view 的  UITableViewFlowLayout 或者类似的东西取代。在 iOS 11 中，苹果重申了这两种组件是明确独立的两种组件，开发者应该根据场景选择使用哪种组件。

首先，table view 默认你需要自动计算行高，设置了如下属性：

    tv.estimatedRowHeight = UITableViewAutomaticDimension

这种做法毁誉参半，在解决一些令人头疼的问题的同时，它本身也带来了一些问题（丢帧，内容边距计算问题，滚动条各种乱跳，等等）。

这里注意了，如果你不想遭遇这种行为 —— 你确实有理由不想遭遇它，[你可以像这样倒退回 iOS 10](https://twitter.com/smileyborg/status/871859045925232641):

    tv.estimatedRowHeight = 0

我们可以以新的方式来给用户在 cell 上左右轻划的动作添加自定义行为，我们还能精确地得到用户是从首部还是尾部轻划。这些跟上下文相关的动作是已存在的 UITableViewRowAction 的加强版，UITableViewRowAction 是在 iOS 8 中添加的：

    let itemNameRow = 0

    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        if indexPath.row == itemNameRow
        {
            let editAction = UIContextualAction(style: .normal, title:  "Edit", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
                 //do edit

                 //The handler resets the context to its normal state, true shows a visual indication of completion
                success(true)
             })

            editAction.image = UIImage(named: "edit")
            editAction.backgroundColor = .purple

            let copyAction = UIContextualAction(style: .normal, title: "Copy", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
                     //do copy
                    success(true)
            })

            return UISwipeActionsConfiguration(actions: [editAction, copyAction])
         }

        return nil
    }

这个代理方法的使用和尾部轻划的使用是一致的。另一个好处是我们可以设置一个默认的轻划动作，用于响应用户向左或向右的长轻划动作，如同原生邮箱中删除邮件时所做的那样：

    let contextualGroup = UISwipeActionsConfiguration(actions: [editAction, copyAction])

    contextualGroup.performsFirstActionWithFullSwipe = true

    return contextualGroup

这个属性的默认值是 true ，所以你得记得在不需要响应该动作时关掉它，尽管看起来大部分情况都应该响应。

为了不被超过太多，table view 从它的小兄弟（译者注：collection view ）那里学了一招，table view 现在可以进行批量更新了： 

    let tv = UITableView()

    tv.performBatchUpdates({ () -> Void in
        tv.insertRows/deleteRows/insertSections/removeSections
    }, completion:nil)

#### UIPasteConfiguration

这一部分在 “ What’s New in Cocoa Touch ” 的宣讲中直接激起了我的兴趣。为了粘贴操作**和**支持拖拽数据的传递，现在每个 UIResponder 都有一个粘贴配置的属性：

    self.view.pasteConfiguration = UIPasteConfiguration()

这个类主要接受粘贴和拖拽的数据，它可以通过传入特定的标识符来限定只接受你想要的数据：

    //Means this class already knows what UTIs it wants
    UIPasteConfiguration(forAccepting: UIImage.self)

    //Or we can specify it at a more granular level
    UIPasteConfiguration(acceptableTypeIdentifiers:["public.video"])

而且这些标识符是可变的，所以如果你的应用需要的话，你可以实时地改变它们：

    let pasteConfig = UIPasteConfiguration(acceptableTypeIdentifiers: ["public.video"])

    //Bring on more data
    pasteConfig.addAcceptableTypeIdentifiers(["public.image, public.item"])

    //Or add an instance who already adopts NSItemProviderReading
    pasteConfig.addTypeIdentifiers(forAccepting: NSURL.self)

现在我们能够轻易的处理拖拽或者粘贴的数据，不论是来自什么系统或者哪个用户，因为在 iOS 11 中所有的 UIResponders 都遵守 [UIPasteConfigurationSupporting](https://developer.apple.com/documentation/uikit/uipasteconfigurationsupporting?changes=latest_minor&amp;language=objc) 协议：

    override func paste(itemProviders: [NSItemProvider])
    {
        //Act on pasted data
    }

#### 总结

很高兴能写一些关于 iOS 11 的东西。虽然总是有很多新东西等着探索和发现，但正因如此，我想我们可以从软件开发中得到一些满足感，毕竟我们中的许多人因为工作或者兴趣的原因每天都要和这些框架打交道。

W.W.D.C. 还在继续进行，大量的代码向我们汹涌而来，我们又有很多新的框架需要掌握，也有很多样例代码需要阅读。这是个令人兴奋的时刻。不论是新的臃肿的导航条，还是 UIFontMetrics ，或者是拖拽式的 API ，都有大量的新内容等着我们去探索。

来不及说了，快上车 📱


[![](https://ws4.sinaimg.cn/large/006tNbRwgy1fgdl589rw6j30k105et9j.jpg)](https://twitter.com/jordanmorgan10)

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
