> * 原文地址：[Life without Interface Builder](https://blog.zeplin.io/life-without-interface-builder-adbb009d2068)
> * 原文作者：[Zeplin](https://blog.zeplin.io/@zeplin_io?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/life-without-interface-builder.md](https://github.com/xitu/gold-miner/blob/master/TODO/life-without-interface-builder.md)
> * 译者：
> * 校对者：

# Life without Interface Builder

![](https://cdn-images-1.medium.com/max/800/1*UTs12drXJKnouZTb5jP79A.png)

On Zeplin’s macOS app, over the past few months, we’ve started developing new features without using Interface Builder or Storyboards.

This is quite a controversial topic on iOS/macOS communities and as a team who relied heavily on Interface Builder before, we wanted to share why we made the switch, with some real life examples. Even though the post is from a macOS perspective, everything I mention should apply to iOS as well.

### Why?

After 2 years of Objective-C, Zeplin got its first slice of Swift in late 2015\. Since then, we’ve been developing new features with Swift and also slowly migrating existing bits and pieces. Currently, about 75% of our macOS app is running on Swift.

Interestingly enough, we started thinking about dropping Interface Builder only after we’ve started using Swift.

#### Too many optionals

Using Swift with Interface Builder brings many optionals to the table and they don’t belong in a type-safe domain. I’m not just talking about outlets either, if you are using Storyboards with segues, your **data model properties also become optionals**. This is where things get out of hand. Properties that are required for your view controller to work properly are now optionals and you start writing `guard`s everywhere, confused about where to handle them gracefully and where to simply `fatalError` your way out. This is quite error prone and decreases readability drastically.

> Properties that are required for your view controller to work properly are now optionals and you start writing `guard`s everywhere.

…unless you use Implicitly Unwrapped Optionals, `!`s. That will work most of the time without any issues but that feels like cheating on Swift-land. As many of us believe, Implicitly Unwrapped Optionals should be used on the rarest occasions and using them daily for Storyboards can be avoided.

#### Design changes

Writing layout code in Objective-C isn’t too bad, but with Swift it’s gotten a lot easier and most importantly, more readable. Declaring Auto Layout constraints is painless and beautiful, thanks to libraries like [Cartography](https://github.com/robb/Cartography).

```
// Defining the appearance while creating the property.
let editButton: NSButton = {
    let button = NSButton()
    button.bordered = false
    button.setButtonType(.MomentaryChange)
    button.image = NSImage(named: "icEdit")
    button.alternateImage = NSImage(named: "icEditSelected")
    
    return button
}()

…

// Declaring Auto Layout constraints with Cartography.
constrain(view, editButton, self) { view, editButton, superview in
    editButton.left == view.right
    editButton.right <= superview.right - View.margin
    editButton.centerY == view.centerY
}
```

I guess we can divide developers who use Interface Builder into two groups: Ones who only use it for Auto Layout and segues, and ones who also apply designs; setting colors, fonts and other visual properties in Interface Builder.

> While using Interface Builder, you find yourself copying and pasting views you built before — and you don’t even feel bad about it!

We were _slightly_ in the second group! As Zeplin is an ever-changing app, this eventually started haunting us when design changes came along. Let’s assume that you need to change the background color of a common button. You’ll need to go through almost every nib and change them manually. Since this is quite repetitive, the chances are you will miss some.

When you’re writing your views in code, **it encourages you to reuse bits and pieces**. On the contrary, while using Interface Builder, you find yourself copying and pasting views you built before — and you don’t even feel bad about it!

#### Reusable views

Storyboards are the future, according to Apple. Since Xcode 8.3, we don’t even get a checkbox to disable Storyboards when creating a project! 😅 Yet it’s quite heartbreaking that **there’s no straightforward way to reuse a view you build on Interface Builder**.

That’s why, we always found ourselves building these commonly used views in code. Building a view that can be initialized both in code and nibs is also trickier, forcing you to implement two initializers and to do the common initializer dance. When you’re sticking to code-only, you can safely ignore `_init?(coder: NSCoder)_`_._

#### Behind the scenes

We had a realization after the switch: Building interfaces in code improved our understanding of `UIKit` and `AppKit` components.

We were converting some of the older features that were previously implemented using a nib. While trying to preserve the look, we had to learn more about what different properties do and how they effect the look of a component. Previously, they were just some selections and checkboxes that were set by default on Interface Builder, and they worked.

> Building interfaces in code improved our understanding of `UIKit` and `AppKit` components.

This is also valid for navigational components like `UINavigationController`, `UITabBarController`, `NSSplitViewController`. Especially beginners rely heavily on these components without really understanding how they work behind the scenes. When you try to initialize and use them in code, you immediately feel more comfortable.

![](https://cdn-images-1.medium.com/freeze/max/30/1*xOHvn40BYFM2GyaNAvLsCQ.gif?q=20)

![](https://cdn-images-1.medium.com/max/800/1*xOHvn40BYFM2GyaNAvLsCQ.gif)

Zo having a hard time opening a huge Storyboard.

#### Debugging issues

Ever had a bug where you had to spend minutes to track it down and end up figuring out it was caused by an unlinked outlet or some weird option you’ve unintentionally changed in a nib?

Every component you create in code is wrapped inside a single source file so you don’t need to worry about jumping between a nib and the source file. This helped us debug issues much faster, and introduced less bugs in the first place.

#### Code reviews and merge conflicts

In order to read and understand naked nibs, you either have to be a nib wizard or have to spend a lot of time! That’s why **most of the time people just skip nib changes during reviews, which is scary.** Think about possible visual bugs that could’ve eliminated by using constants and literals in code.

Merge conflicts is the most common complaint you’ll hear against nibs. You’ve probably experienced one yourself, if you’ve ever worked on a project with nibs, especially Storyboards. You know what that usually means: Someone’s work will have to be reverted and applied again. These are the nastiest conflicts and it gets more and more frustrating as your team grows. You can mostly overcome this issue by scheduling task accordingly, but with Storyboards, this might even happen when you’re working on separate view controllers.

Surprisingly, this wasn’t much of an issue for us in Zeplin — as we’re a relatively small team, I guess. That’s why I’m putting it at the end of the list here.

### Conclusion

I’ve listed a ton of reasons why it would be a good idea to stop using Interface Builder but don’t get me wrong, there are use cases where it makes sense as well. Even though we miss it occasionally, we are currently happier without it.

Don’t be afraid to experiment and see if this fits your workflow as well!

* * *

Thanks to our lovely [@ygtyurtsever](https://twitter.com/ygtyurtsever) for the post. Let us know what you think, drop a comment below! 👋


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
