> * 原文地址：[What's in your Larder: iOS layout DSLs](https://larder.io/blog/larder-links-06-iOS-Auto-Layout-DSLs/)
> * 原文作者：[Belle](https://larder.io/blog/larder-links-06-iOS-Auto-Layout-DSLs/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/larder-links-06-iOS-Auto-Layout-DSLs.md](https://github.com/xitu/gold-miner/blob/master/TODO1/larder-links-06-iOS-Auto-Layout-DSLs.md)
> * 译者：
> * 校对者：

# What's in your Larder: iOS layout DSLs

If you're using Auto Layout to write layouts in code for iOS, it can easily get tedious and verbose. DSLs (domain-specific languages) wrap the underlying APIs to make it easier and faster to read and write code. There are plenty of these for Auto Layout, and even a couple that support manual frame layouts, too.

Here are some I've come across that I've added to my Larder (don't forget you can star repos on GitHub and have them automatically sync to your Larder account).

### [SnapKit](https://github.com/SnapKit/SnapKit) [Swift] & [Masonry](https://github.com/SnapKit/Masonry) [Objective-C]

I've been using SnapKit for a while now, and Masonry before that. SnapKit is the Swift successor to Masonry, but both worth with similar ideas.

SnapKit uses closures (Masonry uses blocks) and dot syntax to chain together auto layout constraint requirements. Here are some examples of how you might add constraints in SnapKit:

```
view.addSubview(label)
label.snp.makeConstraints { (make) in
    make.label.leading.bottom.equalToSuperview()
    make.top.equalTo(anotherView.snp.bottom).offset(12) // Label top == anotherView bottom + 12
    make.width.equalToSuperview().dividedBy(2).labeled("label width") // Label width == view width / 2
}
view.snp.makeConstraints { (make) in
    make.edges.equalToSuperview() // SnapKit offers some handy shortcuts like .edges and .size to constrain multiple attributes at once
}
```

One thing I love about SnapKit is that you can chain `.labeled()` to give your constraint a name, which will show up in Xcode when your constraint conflict. It helps enormously to figure out which constraints are the problem and get your layouts working, but you don't need to create a reference to each constraint in order to give it an identifying label.

### [EasyPeasy](https://github.com/nakiostudio/EasyPeasy) [Swift]

EasyPeasy offers a nice way to add multiple constraints to a view at once. With SnapKit, you can constrain different aspects of your view in the _same_ way, e.g.: `view.leading.trailing.equalToSuperview()` but you can't chain together constraints for `leading` and `trailing` that are different.

With EasyPeasy, you can do so like this:

```
myView.easy.layout(
  Width(200),
  Height(120)
)
```

Another interesting aspect of EasyPeasy is the ability to add conditions to constraints like so:

```
var isCenterAligned = true
view.easy.layout(
  Top(10),
  Bottom(10),
  Width(250),
  Left(10).when { !isCenterAligned },
  CenterX(0).when { isCenterAligned }
)
```

On iOS, you can also access context about the `UITraitCollection` of the view you're constraining, in order to adjust your layouts more easily for different devices and orientations.

### [Stevia](https://github.com/freshOS/Stevia) [Swift]

Stevia is part of freshOS, a project to bring together a set of libraries for iOS developers to use in their projects. While Stevia has some similar ideas to SnapKit, there are a few differences that make it really intriguing.

One is that Stevia offers its own visual layout API. So if you like the visual aspect of Apple's VFL but want something a little less verbose, that doesn't rely on strings and dictionary lookups, Stevia can help. Here's a quick example of the visual layout API in use from the Stevia docs:

```
layout(
    100,
    |-email-| ~ 80,
    8,
    |-password-forgot-| ~ 80,
    >=20,
    |login| ~ 80,
    0
)
```

You can also use Stevia like SnapKit, by chaining together various attributes:

```
email.top(100).left(8).right(8).width(200).height(44)
image.fillContainer()
```

And you can use the equation-based API to lay things out like this:

```
email.Top == 100
password.CenterY == forgot.CenterY
```

One thing I love about Stevia is that you can constrain multiple views at the same time with functions like these:

```
alignHorizontally(password, forgot)
equalWidths(email, password)
```

With a little set up, you can also get live reloading working with Stevia, to make development a lot faster.

### [Mortar](https://github.com/jmfieldman/Mortar) [Swift]

Unlike SnapKit and Stevia, Mortar doesn't offer chaining at all. It's a highly opinionated library that purposely avoids chaining to improve readability.

Like Stevia, however, it does offer a visual layout API, as well as very concise syntax for creating Auto Layout constraints in code.

Here's an example of Mortar's visual layout API from the docs:

```
viewA | viewB[==viewA] || viewC[==40] | 30 | viewD[~~1] | ~~1 | viewE[~~2]

// viewA has a size determined by its intrinsic content size
// viewA is separated from viewB by 0 points (| operator)
// viewB has a size equal to viewA
// viewB is separated from viewC by the default padding (8 points; || operator)
// viewC has a fixed size of 40
// viewC is separated from viewD by a space of 30 points
// viewD has a weighted size of 1
// viewD is separated fom viewE by a weighted space of 1
// viewE has a weighted size of 2
```

Mortar also lets you set constraints on multiple views at once, which I find extremely useful. Here's a look at the different ways Mortar constraints can be created:

```
[view1, view2, view3].m_size |=| (100, 200)

/* Is equivalent to: */
[view1.m_size, view2.m_size, view3.m_size] |=| (100, 200)

/* Is equivalent to: */
view1.m_size |=| (100, 200)
view2.m_size |=| (100, 200)
view3.m_size |=| (100, 200)
```

I'm a bit turned off by the heavy use of symbols in Mortar, but it does make the syntax extremely concise. I imagine once you get your head around the syntax, it could be a lot faster and easier to read and write constraints in Mortar. It's also nice that Mortar doesn't leave out constraint attributes that some of these other libraries don't support, such as `firstBaseline`.

### [Bamboo](https://github.com/wordlessj/Bamboo) \[Swift\]

While Bamboo seems similar to the other options I've mentioned, it does have some unique aspects that make it worth exploring. One thing I love about Bamboo is its `fill` methods. For starters, you can simply call `fill()` to pin all the edges of a view to its superview. But you can also call, for example, `fillLeft()` to pin the left, top, and bottom edges of a view to its superview, or `fillWidth()` to pin the leading and trailing edges.

Another set of methods I love are `before()`, `after()`, `above()`, and `below()`. I often think about positioning my views in this way, so it's nice to be able to express my constraints in code that matches my thought process. Each of these methods takes an optional spacing argument, so you can easily lay out a view after another one, with spacing between.

And again, one of my favourite features is present here: you can constrain multiple views at once using Bamboo:

```
// Constrain on each item.
// e.g., Set each item's width to 10.
[view1, view2, view3].bb.each {
    $0.bb.width(10)
}

// Constrain between every two items.
// e.g., view1.left == view2.left, view2.left == view3.left
[view1, view2, view3].bb.between {
    $0.bb.left($1)
}

[view1, view2, view3].bb.left() // align all left
[view1, view2, view3].bb.width(10) // set width of all to 10
```

Bamboo also offers a neat option for distributing views evenly along an axis:

```
[view1, view2, view3].bb.distributeX(spacing: 10) // [view1]-10-[view2]-10-[view3]
```

And finally, Bamboo also offers [similar syntax for handling manual frame layouts](https://github.com/wordlessj/Bamboo/blob/master/Documentation/Manual%20Layout%20Guide.md), for those times when Auto Layout won't do the job.

### [Cartography](https://github.com/robb/Cartography) [Swift]

Cartography uses a closure-based approach to constraints, where each closure can take multiple views to constrain against each other. Here's an example from the docs:

```
constrain(view1, view2) { view1, view2 in
    view1.width   == (view1.superview!.width - 50) * 0.5
    view2.width   == view1.width - 50
    view1.height  == 40
    view2.height  == view1.height
    view1.centerX == view1.superview!.centerX
    view2.centerX == view1.centerX

    view1.top >= view1.superview!.top + 20
    view2.top == view1.bottom + 20
}
```

You can also do this for just one view at a time, like so:

```
constrain(view) { view in
    view.width  == 100
    view.height == 100
}
```

And you can keep a reference to all the constraints within a closure as a `ConstraintGroup`:

```
let group = constrain(button) { button in
    button.width  == 100
    button.height == 400
}
```

Or you can capture a single constraint from your closure:

```
var width: NSLayoutConstraint?

constrain(view) { view in
    width = (view.width == 200 ~ 100)
}
```

Like many of the other DSLs in this post, Cartography offers `edges`, `center`, and `size` compound attributes to speed things up. It also offers a way to align multiple views easily:

```
constrain(view1, view2, view3) { view1, view2, view3 in
    align(top: view1, view2, view3)
}
```

And to distribute views evenly, like Bamboo does:

```
constrain(view1, view2, view3) { view1, view2, view3 in
    distribute(by: 10, horizontally: view1, view2, view3)
}
```

### Other options

You might also want to check out some of these libraries:

*   [LayoutKit](https://github.com/linkedin/LayoutKit) [Swift, Objective-C], an alternative to Auto Layout made by LinkedIn
*   [PinLayout](https://github.com/layoutBox/PinLayout) [Swift], a DSL for manual frame layouts
*   [FlexLayout](https://github.com/layoutBox/FlexLayout) [Swift], a Swift interface for Yoga/Flexbox, made by the team behind PinLayout
*   [Layout](https://github.com/schibsted/layout) [Swift], a framework for writing layouts using XML template files

* * *

There are some other Auto Layout DSLs I came across but didn't add to my Larder or include here. Mostly this is because they're either old and not actively maintained, or they're very simple and didn't seem to offer anything particularly unique. That doesn't mean they're not useful, but I was looking for what's most interesting and unique about these different approaches to Auto Layout sugar.

Hopefully you'll find something new to try out from this list! If you think I've missed a library that's worth exploring, please share it with us on Twitter at [@LarderApp](http://www.twitter.com/larderapp).

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
