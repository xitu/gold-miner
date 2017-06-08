> * 原文地址：[iOS 11: Notable UIKit Additions](https://medium.com/the-traveled-ios-developers-guide/ios-11-notable-uikit-additions-92e5eb421c3b)
> * 原文作者：本文已获原作者 [Jordan Morgan](https://medium.com/@JordanMorgan10) 授权
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：
> * 校对者：

# iOS 11: Notable UIKit Additions

![](https://cdn-images-1.medium.com/max/2000/1*6a9YvTlOml4ANFlCA06RnQ.jpeg)

Every iOS eagerly watching every W.W.D.C. session this week 😜

Apple’s Famous Framework Has New Toys

Craig Federighi, colloquially referred to as #HairForceOne among the Apple faithful, pulled off the curtains on iOS 11 no less than 48 hours ago. It’s no surprise we’ve got new APIs to dig into, and if the iPhone received some modest love this year — the iPad may have well been proposed to.

While it’s fresh in my mind, here are just a few nifty additions that caught my eyes while browsing the diffs, in no particular order.

#### UIStackView

Everyones favorite control received just one small tweak — but the key is it was *just* the tweak it needed. I’ve said before the[ stack view is flexible as it is complex](https://medium.com/the-traveled-ios-developers-guide/uistackview-a-field-guide-c1b64f098f6d) — but for all of its power and AutoLayout wizardry there was one thing it didn’t do well: variable spacing among its arranged subviews.

That’s changed now with iOS 11. In fact, [Pete Steinberger](https://twitter.com/steipete) of PSPDFKit asked what UIKit additions were top of mind among us, and it was my first thought:

![](https://ws2.sinaimg.cn/large/006tNbRwgy1fgdl477eldj30jp06tq3f.jpg)

This is easily done with one new method:

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

I’ve personally ran into this scenario with our friend stack view more than enough times for it to be slightly irritating, as the antithesis of UIStackView is implementing it only to find you need to tear it down altogether or add the unintuitive “spacer” view (which were supposed to be a bygone relic with the API’s arrival) to apply some padding.

This can also later be queried and parameterized, should you need to animate it in or out to make space for other U.I. considerations:

    let currentPadding = horizontalStackView.customSpacing(after: view3)

#### UITableView

If anything, there was debate in the community as to whether or not table view should’ve been tossed out in lieu of a UITableViewFlowLayout, or something similar. With iOS 11, Apple has all but reaffirmed that it views the two controls as distinct, separate utilities that should occupy equal mindshare among developers.

For starters, table view now inherently believes you want automatic row height enabled, essentially rendering this unnecessary:

    tv.estimatedRowHeight = UITableViewAutomaticDimension

This is both a blessing and a curse, while it does solve a lot of headaches, it also introduces a few of its own (dropped frames, content inset calculations, scroll indicator doing all sorts of interpretative dances, etc.).

Of note here, if this isn’t behavior you want — and there are valid reasons not to want it,[ you can revert back to the stone age of iOS 10 like so](https://twitter.com/smileyborg/status/871859045925232641):

    tv.estimatedRowHeight = 0

We’ve also got a revamped way to enable custom actions when users swipe left or right on cells, or more precisely when they swipe from the leading or trailing sides. These contextual actions act as a more robust API to the existing UITableViewRowAction that were added in iOS 8:

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

The delegate method behaves the same way for trailing actions. Another nice touch is a property one can use to allow a “default” swipe action to occur when the user swipes all the way left or right, à la Mail when deleting an email:

    let contextualGroup = UISwipeActionsConfiguration(actions: [editAction, copyAction])

    contextualGroup.performsFirstActionWithFullSwipe = true

    return contextualGroup

The default value here is true, so it’s more a matter of disabling it if that’s not what you’re after — though that’s likely to be the exception to the rule.

Not to be outdone, table view did steal one parlor trick from its younger cousin, as batch updates are now available with it too:

    let tv = UITableView()

    tv.performBatchUpdates({ () -> Void in
        tv.insertRows/deleteRows/insertSections/removeSections
    }, completion:nil)

#### UIPasteConfiguration

This one is neat, and initially piqued my interest during the “What’s New in Cocoa Touch” session. For both paste operations *and* to support drag and drop data delivery, every UIResponder now has a paste configuration property:

    self.view.pasteConfiguration = UIPasteConfiguration()

This class mainly vets incoming data from a paste operation or a drop, as it prunes things down to only accept that things you want to operate on as specified by the supplied uniform type identifiers:

    //Means this class already knows what UTIs it wants
    UIPasteConfiguration(forAccepting: UIImage.self)

    //Or we can specify it at a more granular level
    UIPasteConfiguration(acceptableTypeIdentifiers:["public.video"])

What’s more, these UTIs are mutable — so if your app’s flow allows for it, you can change them on the fly:

    let pasteConfig = UIPasteConfiguration(acceptableTypeIdentifiers: ["public.video"])

    //Bring on more data
    pasteConfig.addAcceptableTypeIdentifiers(["public.image, public.item"])

    //Or add an instance who already adopts NSItemProviderReading
    pasteConfig.addTypeIdentifiers(forAccepting: NSURL.self)

Now we can easily act on whatever the system, or rather the user, hands off to us as a result of a drop or paste since in iOS 11 all UIResponders also conform to [UIPasteConfigurationSupporting](https://developer.apple.com/documentation/uikit/uipasteconfigurationsupporting?changes=latest_minor&amp;language=objc):

    override func paste(itemProviders: [NSItemProvider])
    {
        //Act on pasted data
    }

#### Wrapping Up

It feels great to be writing about iOS 11. While there is always certainly more to know and waiting to be discovered, I fee like we get to this point of complacency with software development — after all, many of us work with these frameworks day in and day out for a living or a hobby.

And boom, W.W.D.C. rolls around and the proverbial code floodgates drown us once more with a multitude of new frameworks to master and code samples to pour over. Exciting times. Whether it’s the new “fat” nav bars, UIFontMetrics or the drag and drop APIs, there’s plenty waiting to be discovered.

Saddle up 📱


[![](https://ws4.sinaimg.cn/large/006tNbRwgy1fgdl589rw6j30k105et9j.jpg)](https://twitter.com/jordanmorgan10)

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
