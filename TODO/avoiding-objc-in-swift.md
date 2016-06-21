>* 原文链接 : [Avoiding the overuse of @objc in Swift](http://www.jessesquires.com/avoiding-objc-in-swift/)
* 原文作者 : [Jesse Squires](http://www.jessesquires.com/)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : 
* 校对者:


A few days ago I was (finally!) updating a project to use Swift 2.2 and I ran into a few issues when converting to use the new `#selector` syntax introduced by proposal [SE-0022](https://github.com/apple/swift-evolution/blob/master/proposals/0022-objc-selectors.md). If using `#selector` from within a protocol extension, that protocol must be declared as `@objc`. The former `Selector("method:")` syntax did not have this requirement.

### Configuring view controllers with protocol extensions

For the purposes of this post, I’ve simplified the code from the project I’m working on, but all of the core ideas remain. One pattern I’ve been using a lot in Swift is writing protocols and extensions for reusable configurations, especially with UIKit.

Suppose we have a group of view controllers that all need a view model and a “cancel” button. Each controller needs to be able to execute its own code when “cancel” is tapped. We may write something like this:



    struct ViewModel {
        let title: String
    }

    protocol ViewControllerType: class {
        var viewModel: ViewModel { get set }

        func didTapCancelButton(sender: UIBarButtonItem)
    }



If we stopped here, then each controller would have to add and wire up its own cancel button. That ends up being a lot of boilerplate. We can fix that with an extension (using the old `Selector("")` syntax):



    extension ViewControllerType where Self: UIViewController {
        func configureNavigationItem() {
            navigationItem.leftBarButtonItem = UIBarButtonItem(
                barButtonSystemItem: .Cancel,
                target: self,
                action: Selector("didTapCancelButton:"))
        }
    }



Now each controller that conforms to this protocol can call `configureNavigationItem()` from `viewDidLoad()`, which is much better. Our controller might look like this:



    class MyViewController: UIViewController, ViewControllerType {
        var viewModel = ViewModel(title: "Title")

        override func viewDidLoad() {
            super.viewDidLoad()
            configureNavigationItem()
        }

        func didTapCancelButton(sender: UIBarButtonItem) {
            // handle tap
        }
    }



This is rather simple, but you can imagine more complex configurations that we could apply using this strategy.

After updating the snippet above for Swift 2.2, we have the following:



    extension ViewControllerType where Self: UIViewController {
        func configureNavigationItem() {
            navigationItem.leftBarButtonItem = UIBarButtonItem(
                barButtonSystemItem: .Cancel,
                target: self,
                action: #selector(didTapCancelButton(_:)))
        }
    }



And now we have a problem, a new compiler error.



    Argument of '#selector' refers to a method that is not exposed to Objective-C.

    Fix-it   Add '@objc' to expose this method to Objective-C



### When `@objc` tries to ruin everything

We cannot simply add `@objc` to this method in the original `ViewControllerType` protocol for a number of reasons. If we do, then the entire protocol needs to be marked `@objc`, which means:

*   Any protocols from which this one inherits need to be marked `@objc`.
*   Any protocols that _inherit from_ this one are now automatically `@objc`.
*   We’re using structs (the `ViewModel`) in the protocol which cannot be expressed in Objective-C.

Until this point, the only occurrences of `@objc` in this code base were confined to normal target-action selectors. We may not be writing _Pure Swift<sup>TM</sup>_ apps yet since it’s still [Cocoa all the way down](http://inessential.com/2016/05/25/oldie_complains_about_the_old_old_ways), but we can still take advantage of many of Swift’s powerful features — unless we start introducing `@objc` in too many places.

Our example here is simple, but imagine a much more complex object graph that makes heavy use of Swift’s value types and a hierarchy of three protocols with this one in the middle. Introducing `@objc` as the fix-it suggests would _break the entire world_ in our app. If we let it, the tyranny of `@objc` will expel all beauty from our Swift code and make everything horrible. It will ruin everything.

But there’s hope.

### Stop `@objc` from making everything horrible

We do not have to let `@objc` proliferate our code base and transform our Swift code into merely “Objective-C with a new syntax”.

We can decompose this protocol by separating out all of the `@objc` code into its own protocol. Then, we can use protocol composition to reunite them. In fact, we can make the compiler happy and avoid changing _any_ of our view controller code.

First we split up the protocol into two protocols, `ViewModelConfigurable` and `NavigationItemConfigurable`. Our previous extension on `ViewControllerType` can move to `NavigationItemConfigurable` instead.



    protocol ViewModelConfigurable {
        var viewModel: ViewModel { get set }
    }

    @objc protocol NavigationItemConfigurable: class {
        func didTapCancelButton(sender: UIBarButtonItem)
    }



Finally, we can define our original `ViewControllerType` protocol as a `typealias`.



    typealias ViewControllerType = protocol<ViewModelConfigurable, NavigationItemConfigurable>



Now everything works exactly as it did before migrating to Swift 2.2 and our original view controller definition above does not have to change. Nothing is ruined. If you ever face a similar situation, or if you generally want to contain the use of `@objc` (_which you should_), then I highly recommend adopting this strategy.

### It’s not always obvious

Looking at this now, I think “duh”, of course this is the best and “most Swifty” answer to the problem. However, a solution like this is not always immediately clear when Xcode suddenly starts yelling at you and quickly applying the fix-its starts breaking _everything else_ — especially when Xcode’s fix-its are usually what you want when migrating Swift versions.

Lastly, after making this change I realized it’s actually a much better solution in general. There was no reason for this to be a single protocol in the first place. The `ViewModelConfigurable` and `NavigationItemConfigurable` protocols have distinct responsibilities. Protocol composition was the most elegant and appropriate design all along.

