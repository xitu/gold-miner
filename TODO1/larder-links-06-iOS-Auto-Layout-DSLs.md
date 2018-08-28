> * 原文地址：[What's in your Larder: iOS layout DSLs](https://larder.io/blog/larder-links-06-iOS-Auto-Layout-DSLs/)
> * 原文作者：[Belle](https://larder.io/blog/larder-links-06-iOS-Auto-Layout-DSLs/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/larder-links-06-iOS-Auto-Layout-DSLs.md](https://github.com/xitu/gold-miner/blob/master/TODO1/larder-links-06-iOS-Auto-Layout-DSLs.md)
> * 译者：[pmwangyang](https://github.com/pmwangyang)
> * 校对者：

# 你 Ladar 中该珍藏的：iOS 布局语言

如果你在iOS开发时使用 `Auto Layout` 来纯代码布局的话，你很容易就会感到啰嗦和乏味。DSL（译者注：原意为「领域特定语言」，在本文中根据语境译为「布局语言」）能够将基础的API转换成可以简单、快速开发和阅读的代码。有很多这类布局语言支持 Auto Layout，甚至有几个还支持手动 frame 布局。

我可以给你推荐一些我偶然遇到并且保存到我的 Ladar 书签中的布局语言（别忘了你可以在 Github 中 star 这些库，并且可以自动更新到你的 Lardar 账户中）。

### [SnapKit](https://github.com/SnapKit/SnapKit) [Swift] & [Masonry](https://github.com/SnapKit/Masonry) [Objective-C]

现在我已经使用 SnapKit 一段时间了，在这之前是 Masonry。SnapKit 是 Masonry 的 Swift 版继承者，二者使用的是同一种构思，都值得使用。

SnapKit 使用闭包（Masonry 则用 block）和点语法来链接自动布局的约束需求。下面是一个使用 SnapKit 添加约束的例子：

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

我特别喜欢 SnapKit 的一点是，你可以使用点语法 `.labeled()` 来命名约束，当你的约束冲突时，可以在 Xcode 中显示出来。这对找到出问题的约束有很大帮助，以使得你的布局可以正常工作，但是你不需要因为这个来给每个约束一个唯一的标签。

### [EasyPeasy](https://github.com/nakiostudio/EasyPeasy) [Swift]

EasyPeasy 提供了一次性添加多个约束的好方法。在使用 SnapKit 时，你可以用 **同一种** 方法来约束视图的各个方向，比如：`view.leading.trailing.equalToSuperview()`，但是你不能把诸如 `leading` 和 `trailing` 这样不同的约束链接在一起。

在使用 EasyPeasy 时，你可以这样做：

```
myView.easy.layout(
  Width(200),
  Height(120)
)
```

EasyPeasy 另一个有趣的地方是可以给约束添加条件，比如：

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

在 iOS 里，你也可以使用你正在添加约束的视图的 `UITraitCollection` 上下文，更轻松地来为不同的设备和方向调整你的布局。

### [Stevia](https://github.com/freshOS/Stevia) [Swift]

Stevia 是 freshOS 的一部分，而 freshOS 是一个帮助 iOS 开发者在他们的项目中集合库文件的项目。Stevia 和 SnapKit 有许多相似点，但有一些不同的地方让 Stevia 相当吸引人。

其中一个就是 Stevia 提供它自己的可视化布局 API。所以，如果你喜欢 Apple VFL 的可视化效果但是不想那么啰嗦、不想依赖于字符串和字典检查，Stevia 是一个很好的选择。这有一个 Stevia 文档中使用可视化布局 API 的简单例子：

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

你也可以像 SnapKit 那样使用 Stevia，比如用点语法链接多个属性：

```
email.top(100).left(8).right(8).width(200).height(44)
image.fillContainer()
```

你也可以使用等式 API 来布局，像这样：

```
email.Top == 100
password.CenterY == forgot.CenterY
```

Stevia 让我喜欢的一点是，你可以使用像下面这样的方法同时约束多个视图：

```
alignHorizontally(password, forgot)
equalWidths(email, password)
```

只需一点点设置，你就可以使用 Stevia 的即时重载功能，让开发更快捷。

### [Mortar](https://github.com/jmfieldman/Mortar) [Swift]

和 SnapKit 以及 Stevia 不同的是，Mortar 压根不提供点语法。它有意地避免点语法来提升可读性。

但不管怎样，它还是和 Stevia 一样提供了可视的布局 API，同样是一种用代码创建自动布局的简明的语法。

这是 Mortar 文档中列举的可视布局 API 例子：

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

Mortar 也允许你同时设置多个视图的约束，这点我认为非常有用。这里是用不同方式创建 Mortar 约束的概览：

```
[view1, view2, view3].m_size |=| (100, 200)

/* Is equivalent to: */
[view1.m_size, view2.m_size, view3.m_size] |=| (100, 200)

/* Is equivalent to: */
view1.m_size |=| (100, 200)
view2.m_size |=| (100, 200)
view3.m_size |=| (100, 200)
```

我对 Mortar 大量符号的使用有点失去了兴趣，但是符号的运用确实让语法非常简洁。我想如果你可以应付这些语法，你可以使用 Mortar 更快、更简单的添加约束。其他非常好的地方是，Mortar 没有忽略其他布局库并不支持的约束属性，比如 `firstBaseline`。

### [Bamboo](https://github.com/wordlessj/Bamboo) \[Swift\]

虽然 Bamboo 看起来和我提到的其他库很相似，但是它确实有一些独特的地方，值得我们探索。一个让我喜欢的方面是它的 `fill` 方法。对于初学者，你可以仅仅使用一个 `fill()` 来把当前视图的边缘贴在父视图的边缘上。但是你也可以调用比如 `fillLeft()` 来让视图的左、上、下边缘贴合到父视图上，或者使用 `fillWidth()` 来贴合视图的头和尾边缘。

另一组我喜欢的方法是 `before()`、`after()`、`above()` 和 `below()`。我经常考虑用这种方法定位我的视图，所以，像这样用代码表达约束和我的思考过程是同步的，这是一个很好的方式。每一个这样的方法都有一个可选的间隔参数，所以你可以轻松地使用间隔参数在一个视图后面布局另一个视图。

给你展示一个我喜欢的特性：你可以使用 Bamboo 同时约束多个视图：

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

Bamboo 同样提供一个优雅的选择，以便你在坐标轴上均匀地分布视图：

```
[view1, view2, view3].bb.distributeX(spacing: 10) // [view1]-10-[view2]-10-[view3]
```

最后，当自动布局失效时，Bamboo 也提供了[手动 frame 布局的近似语法](https://github.com/wordlessj/Bamboo/blob/master/Documentation/Manual%20Layout%20Guide.md)。

### [Cartography](https://github.com/robb/Cartography) [Swift]

Cartography 使用基于闭包的方法来添加约束，每个闭包可以同时约束多个视图。下面是文档中的例子：

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

你也可以一次只约束一个视图，比如：

```
constrain(view) { view in
    view.width  == 100
    view.height == 100
}
```

你也可以将所有的约束放到一个闭包里，就像一个 `ConstraintGroup`：

```
let group = constrain(button) { button in
    button.width  == 100
    button.height == 400
}
```

或者只在闭包中保留一个约束：

```
var width: NSLayoutConstraint?

constrain(view) { view in
    width = (view.width == 200 ~ 100)
}
```

就像本文中其他的布局语言，Cartography 也提供了 `edges`、`center` 和 `size` 之类的混合属性来提高效率。它也提供了简单的对齐多个视图的方法：

```
constrain(view1, view2, view3) { view1, view2, view3 in
    align(top: view1, view2, view3)
}
```

均匀分布视图方面，和 Bamboo 很像：

```
constrain(view1, view2, view3) { view1, view2, view3 in
    distribute(by: 10, horizontally: view1, view2, view3)
}
```

### 其他选择

你可能还会喜欢下面这些库：

*   [LayoutKit](https://github.com/linkedin/LayoutKit) [Swift, Objective-C]，自动布局的另一种选择，LinkedIn开发。
*   [PinLayout](https://github.com/layoutBox/PinLayout) [Swift]，一个手动 frame 布局的布局语言。
*   [FlexLayout](https://github.com/layoutBox/FlexLayout) [Swift]，Yoga/Flexbox 的 Swift 版本接口, 由 PinLayout 背后的团队开发。
*   [Layout](https://github.com/schibsted/layout) [Swift]，使用XML模板文件布局的框架。

* * *

我还发现了许多的自动布局语言，但并没有添加到 Larder 中或在这里列举。大部分是因为它们要么太老并且没人维护，或者是太简单、没有特点。但这并不意味着它们没有用，只是我在寻找最有趣、最独特使用自动布局语法糖的方式罢了。

希望你可以在这个列表里找到一些新的可尝试的东西！如果你认为我漏掉了值得探究的库，请在这个 Twitter [@LarderApp](http://www.twitter.com/larderapp) 里和我们分享

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
