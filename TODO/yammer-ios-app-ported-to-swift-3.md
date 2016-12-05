> * 原文地址：[Yammer iOS App ported to Swift 3](https://medium.com/@yammereng/yammer-ios-app-ported-to-swift-3-e3496525add1)
* 原文作者：[Engineering Yammer](https://medium.com/@yammereng)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

# Yammer iOS App ported to Swift 3






Since the introduction of Xcode 8 in late September, Swift 3 has become the default version to develop iOS and Mac OS apps.

As an iOS shop, we had to consider a migration project to port our codebase from 2.3 to 3 while maintaining a good relationship with the Objective C part of the project.

The first step was to decide if we wanted to migrate to Swift 3\. In the past we had no choice but to bite the bullet; however, this time around Xcode 8 offers a [build flag](https://developer.apple.com/swift/blog/?id=36) that allows you to use legacy versions of Swift. It turns out that the legacy feature is meant only for version transitions. According to the [release notes](https://developer.apple.com/library/prerelease/content/releasenotes/DeveloperTools/RN-Xcode/Introduction.html) Xcode 8.2 is intended to be the last version supporting Swift 2.3.

Another issue that made us considering against the migration is the substantial amount of [changes](https://buildingvts.com/a-mostly-comprehensive-list-of-swift-3-0-and-2-3-changes-193b904bb5b1#.z9w2usfdx). The Swift team and the community have been very busy and Swift 3 shows the development effort of a young language. Unfortunately, this version [does not come with ABI compatibility](http://thread.gmane.org/gmane.comp.lang.swift.evolution/17276), meaning that we can expect another similar conversation in 1 years time when Swift 4 lands on the shelves. Not migrating now would mean double the work next year as we would have to port features from 3 and 4 all together. This is not necessarily true, some of the Swift 4 changes will happen in the same scope of Swift 3 and the Xcode migration tools are known to become more reliable as time passes.

Anyway, no big surprise, we decided to migrate.

Once we decided to proceed with the migration we had to came up with a plan. It was clear to us that it would have not been possible to cut the migration in chunks. Xcode only allows to compile with one Swift version, so once you get the ball rolling, all the changes need to be merged to master at the same time. That creates several logistical problems that span from locking the team out of working on any Swift file to generating massive pull requests. Colleagues may appreciate the effort but they’re gonna hate you anyway. We settled on creating a note where everyone in the team would add the classes they are working on so to give us the ability to leave them aside and try to merge them into our branch before migrating them. This is not always easy especially if you are relying on the compiler errors to guide you on the next piece of work.

That said, there is a better alternative. Remove most of your classes from the target and [build separate modules with them](https://twitter.com/cocoaphony/status/794988795208802305). This way they can coexist with different version of Swift. However, I don’t believe this to be a totally painless process. I don’t really know, because we decided not to go that route.

Once ready, we fired the Xcode migration tool (_Edit->Convert->to Current Swift Syntax_) and had a look at the huge generated diff. We proceeded by analysing each and every file in the diff, taking notes and drafting tasks on things that didn’t seam quite right (more on the list later).

As expected, the migration does only half a job towards a compilable codebase. Next step is to open the issue navigator and going through, one by one, the list of errors and warnings (yes, warnings because we are not animals). Most of the issues come with a handy fix suggestion, most of the time that is the right fix, sometimes is better to rearrange or rewrite the code to make everything clear. A migration is a good chance to look broadly around the codebase and maybe question and redefine some practices, especially for a language that is new for everyone.

As you are going along the list of errors will keep fluctuating up and down; it’s easy to spot patterns that can be bulk fixed with a global search & replace. Eventually the code will compile and run. Eventually tests will compile, run and pass. Making the tests pass is the first important milestone. Every change so far should have been as minimal as possible. Make a note of things that look weird but do not touch them until all the test passes.

With the tests passing we can now focus on the list of tasks and the notes we have collected so far. All of that code that is technically correct but makes the eyes bleed. (Don’t open the blame panel on the right, the author is very likely you!)

Following, is the list of things we noted during the migration. Some are very common to everyone and some are probably more context specific with our codebase:

*   **fileprivate to private**. The migration will change all your `private` declarations to `fileprivate`. This is not necessarily correct as some were actually meant to be private. We replaced all of the instances of `fileprivate` back to `private` and then we reviewed the errors to open scope to those who truly deserve it.
*   **NSIndexPath to IndexPath**. Some did go through some didn’t, go figure! On the other hand some were our internal API that needed to be changed.
*   **UIControlState() to .normal to UIControlState()**. An OptionSet that is set to it’s defaults raw value can be instantiated as an empty init (_ex.:_ `UIControlState()`). That is not as descriptive as `.normal` so we changed all of them. Another notable mention is `UIViewAnimationOptions()` which we changed to `.curveEaseInOut`.
*   **Enum cases to lowercase**. Some enums will change to have a lowercase first letter, some will not. So, we did that manually. The migration tool will deal with specific keyword that are conflicting like `default` by using reverse apices (ex: `default`).
*   **Are you really Optional?** Some APIs have changed and now produce optional types. If that is an internal Objective C API make sure your nullability identifiers are set correctly.
*   **Objective C Nullability Identifiers**. In Swift 3, each Objective C imported class that has no nullability identifiers goes from being force unwrapped to optional. The fast solution is to `if let` or `guard let` everything in Swift, but before doing that, review them on the Objective C side of things.
*   **Optional comparable**. Because of changes in the optionality of some APIs or indeed many of the Objective C ones (see above), the migration tool will write some comparable functions to be applied to generic optional types (`func < (lhs: T?, rhs: T?) -> Bool`). That is a bad idea and most likely your logic needs to be changed and that code deleted.
*   **NSNumber!**. Swift 3 will not automatically bridge a number to `NSNumber` (or any NS class for that matter), but the cast does not need to be forced in most cases. Review them all.
*   **DispatchQueue**. I love the new DispatchQueue syntax, however the migration tool has messed some conversions up. Also every `dispatchAfter` in the code had to be modified to avoid double conversion to nanoseconds. As most API will use a delay in seconds we used to do the operation of multiplying that by `NSEC_PER_SEC`, well the migration tool will just take that logic and divide by `NSEC_PER_SEC`. Not pretty.
*   **NSNotification.Name**. The `NotificationCenter` now does add observers by `NSNotification.Name` instead of `String`. The migration tool will wrap the given constant in a `Notification.name` while we preferred to hide that logic in the constant itself by assigning the `Notification.name` to the let variable.
*   **NSRange to Range**. Most string APIs now take `Range` instead of `NSRange`. It is now also much easier to work with them by using literal ranges (0..<9). 1="" in="" general="" ranges="" have="" changed="" a="" lot="" from="" swift="" and="" everyone="" had="" frustration="" working="" with="" them.="" review="" of="" all="" them="" your="" codebase="" is="" probably="" worth="" it!
*   **_ first parameter**. Swift 3 naming convention changed to imply the name of the first parameter in a function in many cases. Most of your API and API calls will change automatically, some won’t. To make matters worse, some suggested API changes make your functions difficult to read. Think also about using `NS_SWIFT_NAME` for those Objective C names that are not Swifty enough.
*   **Objective C class properties**. Many class calls in Swift are now represented by class properties as opposed to class methods (_ex.:_ `UIColor.red`). In your Objective C you can convert a getter to [static property](http://useyourloaf.com/blog/objective-c-class-properties/) and it will work as expected in both worlds.
*   **Any and AnyObject.** Objective C id types are now cast to Any instead of `AnyObject`. The conversion is pretty easy to fix but may still lead to some misunderstanding down the line. [Read](http://kuczborski.com/2014/07/29/any-vs-anyobject/) and and understand the difference.
*   **Access Control.** We already talked about `private` and `filePrivate`.It is worth also reviewing uses of `open`, `public` and `internal`. This is another case where it is very important to come to an agreement with the team.

**Conclusions**

The process of migrating ~ 180 Swift files took around 2 weeks and 2 people. We decided on pair migrating (_I call dibs on the name!_) because of the specific advantages in this conditions. Having 4 eyes instead of 2 becomes even more important when the focus of the project is less about code logic and more on making sure no new bugs are introduced because of typos, rename operations and reordering. A second set of hands and a laptop are very handy to check the original code when what you see in front of you does not quite make sense. Overall, it makes a task that is not that fun more enjoyable, and when everything fails at least you can switch. Thank you Mannie ([@mannietags](https://twitter.com/mannietags)) for pairing and enduring.

Because the nature of the workflow is quite compiler error driven, sometimes it is difficult to make coherent commits separated by specific actions. For that purpose it is useful to soft reset the entire branch from the root and recommit each and every logic block to leave at least a better history. This can be extended to create waterfall branches and doing so creating small PRs. They obviously then have to be merged in cascade. Or you can just do a good job the first time.

A migration is an effective way to leave your code in a better place. It does that by updating the code to a newer version but it is also an opportunity to spot unconventional behaviours as well as out of fashion ones. It is important to note those findings and update the team coding conventions (or start one if you don’t already). There are 2 reasons for doing so: the first one is for reference for anyone in the future. The second is the exposure of the ideas in the process of updating/creating one. It is very likely that a migration PR is so boring it is not going to have much traction, however a different PR with the new changed standards as well as the motivation for the choices made, is much easier for the rest of the team to follow and digest.

_Francesco Frison is an iOS engineer at Yammer._ [_@cescofry_](https://twitter.com/cescofry)





