> * 原文链接: [Preventing Popovers on Popovers
](https://pspdfkit.com/blog/2016/popovers-on-popovers/)
* 原文作者: [Douglas Hill](https://twitter.com/qdoug)
* 译文出自: [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者:  [llp0574](https://github.com/llp0574)
* 校对者: [yifili09](https://github.com/yifili09),[Graning](https://github.com/Graning)

# iOS 开发，该如何解决弹窗的设计问题？

iOS 开发，该如何解决弹窗的设计问题？

iOS 9 的页面用了一种我们不能复现的方式去展示一个活动视图控制器，并且当从内部表单和弹窗呈现操作列表和活动视图控制器时 UIKit 的行为一开始看起来不那么连贯。我们提交了两份 Radars 给苹果：[rdar://27448912 Can’t show activity view controller filling a form sheet](http://openradar.appspot.com/27448912) 和 [rdar://27448488 Reading an alert controller’s popoverPresentationController property changes behavior](http://openradar.appspot.com/27448488)。

[iOS 的人机交互指南](https://developer.apple.com/ios/human-interface-guidelines/interaction/modality/)声明：

> **不要在一个弹窗上展示一个模态视图。** 由于一个警告弹窗可能是一个异常，所以不应该在这上面展现任何东西。极少数情况下，当你真的需要在一个动作导致弹窗后展示一个模态视图时，应该先把弹窗关闭掉再进行展示。

[并且](https://developer.apple.com/ios/human-interface-guidelines/ui-views/popovers/):

> **一次只展示一个弹窗。** 展示多个弹窗会让交互变得杂乱并让人产生疑惑。千万不要展示一个级联或者有层次结构的弹窗，一个从另一个里面产生的那种。如果你需要展示一个新的弹窗，首先关闭已经弹出的那个。

在横向水平的普通环境和全屏紧凑的环境下具有[弹窗](https://developer.apple.com/reference/uikit/uimodalpresentationstyle/1621382-popover)样式的视图控制器都应该呈现为弹窗。具有操作列表样式的 [`UIActivityViewController`](https://developer.apple.com/reference/uikit/uiactivityviewcontroller) 和 [`UIAlertController`](https://developer.apple.com/reference/uikit/uialertcontroller) 都遵守相同的规则：展示为弹窗或者一个上拉式表。所以如果一个弹窗展示一个活动视图控制器或者一个操作列表到底会发生什么？这个人机交互指南文档的说法好像有点矛盾。

在 iOS 9 页面的一个相关说明里，我们注意到在一个表单的视图控制器展示了一个填充了这个表单的 [`UIActivityViewController`](https://developer.apple.com/reference/uikit/uiactivityviewcontroller)，想知道这是不是一个我们之前没有留意到的默认行为呢？又或者它是不是一个我们可以自定义实现的东西？

![Screen shot of Pages on iPad showing an activity view controller presented as a sheet inside a form sheet](https://pspdfkit.com/images/blog/2016/popovers-on-popovers/pages-sheet-in-form-sheet-59e3007e.jpg)

对于大多数视图控制器来说，在里面展示一个弹窗或者表单需要将当前视图控制器的 [`modalPresentationStyle`](https://developer.apple.com/reference/uikit/uimodalpresentationstyle) 设置为 [`currentContext`](https://developer.apple.com/reference/uikit/uimodalpresentationstyle/1621493-currentcontext) 或者 [`overCurrentContext`](https://developer.apple.com/reference/uikit/uimodalpresentationstyle/1621507-overcurrentcontext)。但对于某些像 [`UIActivityViewController`](https://developer.apple.com/reference/uikit/uiactivityviewcontroller) 和 [`UIAlertController`](https://developer.apple.com/reference/uikit/uialertcontroller) 这种 UIKit 提供的视图控制器来说，它们已经被赋予了自己的样式，[`modalPresentationStyle`](https://developer.apple.com/reference/uikit/uimodalpresentationstyle) 的变化将被忽略掉。

一般，[`UIActivityViewController`](https://developer.apple.com/reference/uikit/uiactivityviewcontroller) 会在常规宽度下展示为弹窗，在紧凑宽度下变成一个透明的表。但是如果一个常规宽度的视图控制器要从一个紧凑宽度的视图控制器里展示会怎么样呢？这种情况会在一个有[表格](https://developer.apple.com/reference/uikit/uimodalpresentationstyle/1621491-formsheet)或者[弹窗](https://developer.apple.com/reference/uikit/uimodalpresentationstyle/1621382-popover) 的 [`modalPresentationStyle`](https://developer.apple.com/reference/uikit/uimodalpresentationstyle) 的视图控制器要在 iPad 上展示，或者它是一个使用了 [`overrideTraitCollection`](https://developer.apple.com/reference/uikit/uipresentationcontroller/1618335-overridetraitcollection) 属性的自定义展示控制器，然后这个控制器展示了一个 [`UIActivityViewController`](https://developer.apple.com/reference/uikit/uiactivityviewcontroller)。

![Diagram: First View Controller to Second View Controller to Activity View Controller or Action Sheet](https://pspdfkit.com/images/blog/2016/popovers-on-popovers/diagram-23ed42d7.png)

## 操作列表

首先我们来看看 [`UIAlertController`](https://developer.apple.com/reference/uikit/uialertcontroller)。图中根视图控制器（青色）用[弹窗](https://developer.apple.com/reference/uikit/uimodalpresentationstyle/1621382-popover)样式（下方，通过切分视图行为以作参考）展示了第二个用[表单](https://developer.apple.com/reference/uikit/uimodalpresentationstyle/1621491-formsheet)样式（上方）的视图控制器（粉色）。然后第二个视图控制器展示了一个操作列表样式的警告控制器。

![Form sheet presenting action sheet as popover](https://pspdfkit.com/images/blog/2016/popovers-on-popovers/form-sheet-action-popover-c90794ab.jpg) ![Popover presenting action sheet as popover](https://pspdfkit.com/images/blog/2016/popovers-on-popovers/popover-action-popover-fca43393.jpg)

虽然我们想要用列表的展示样式去展示操作列表（而不是弹窗），但因为关注点分离的优势，我设置了警告控制器的 [`popoverPresentationController.sourceView`](https://developer.apple.com/reference/uikit/uipopoverpresentationcontroller/1622313-sourceview) 和 [`popoverPresentationController.sourceRect`](https://developer.apple.com/reference/uikit/uipopoverpresentationcontroller/1622324-sourcerect)，视图控制器不应该对它怎么展示作出假设。它应该在 app 的其他部分进行全屏展示，视图控制器不应该控制这些行为。

出于好奇，我尝试注释掉了[`popoverPresentationController`](https://developer.apple.com/reference/uikit/uiviewcontroller/1621428-popoverpresentationcontroller)的定义，发生了让我意想不到的情况：

![Form sheet presenting action sheet as sheet](https://pspdfkit.com/images/blog/2016/popovers-on-popovers/form-sheet-action-sheet-38753715.jpg) ![Popover presenting action sheet as sheet](https://pspdfkit.com/images/blog/2016/popovers-on-popovers/popover-action-sheet-2b011d4f.jpg)

原来只读取警告控制器的[`popoverPresentationController`](https://developer.apple.com/reference/uikit/uiviewcontroller/1621428-popoverpresentationcontroller)属性会导致即使是从一个紧凑宽度环境下呈现它也会展示为一个弹窗。如果你想这么做，请一定要确保好视图控制器展现的前后环境，因为如果你想从常规宽度的环境展现一个没有设置弹窗源码的警告控制器，UIKit 就会抛出一个异常。切记在展现触发的时候即使呈现视图控制器是在一个紧凑宽度环境下，当展示被激活的时候它还是有可能发生改变。

我提交了一个 [rdar://27448488 Reading an alert controller’s popoverPresentationController property changes behavior](http://openradar.appspot.com/27448488).

## 活动视图控制器

用[`UIActivityViewController`](https://developer.apple.com/reference/uikit/uiactivityviewcontroller)做同样的事情，并指定弹窗源码信息，出现下面的情况：

![Form sheet presenting activity view controller as a popover](https://pspdfkit.com/images/blog/2016/popovers-on-popovers/form-sheet-activity-318dfc25.jpg) ![Popover presenting activity view controller as a sheet](https://pspdfkit.com/images/blog/2016/popovers-on-popovers/popover-activity-4bde59d8.jpg)

不同于页面的行为，我发现表单把这个活动视图控制器展示为一个弹窗，弹窗将活动视图控制器展示在表单上。这是在 iOS 10 的新行为，iOS 9 里，是从另一个弹窗展示一个弹窗。

用同样不访问[`popoverPresentationController`](https://developer.apple.com/reference/uikit/uiviewcontroller/1621428-popoverpresentationcontroller)的技巧导致 UIKit 抛出一个异常说“必须为这个弹窗提供位置信息”。

## 结论

我们发现当 UIKit 的视图控制器是从一个展示在常规宽度环境的紧凑宽度的环境中展示时行为会变得很混乱。弹窗展现的一般规则是在常规宽度下展示为弹窗，在紧凑宽度下为全屏（尽管结合当前上下环境更有意义）。操作列表和活动视图控制器的展示有点像弹窗的展示，但不要完全按照一般的规则来展示。

实际的行为看起来像是和人机交互指南说的一样，并很大程度上忽略了特征集合的 Size 类。UIKit 不会在操作列表的异常警告上展现一个弹窗。Size 类并不能控制所有的东西。

我们不能重现页面(Pages)的行为。对于我们来说，当一个表单展示一个活动视图控制器时，它将展示为弹窗。我把这个问题报告给了 Apple ：[rdar://27448912 Can’t show activity view controller filling a form sheet](http://openradar.appspot.com/27448912)。如果你知道解决这个问题的方法，[麻烦在我的 Twitter 留言](https://twitter.com/qdoug)。
