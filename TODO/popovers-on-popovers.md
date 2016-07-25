> * 原文链接: [Preventing Popovers on Popovers
](https://pspdfkit.com/blog/2016/popovers-on-popovers/)
* 原文作者: [Douglas Hill](https://twitter.com/qdoug)
* 译文出自: [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者: 
* 校对者:


Pages on iOS 9 shows an activity view controller in a way we can’t reproduce, and UIKit’s behavior when presenting action sheets and activity view controllers from inside form sheets and popovers seems inconsistent at first. We filed two Radars with Apple: [rdar://27448912 Can’t show activity view controller filling a form sheet](http://openradar.appspot.com/27448912) and [rdar://27448488 Reading an alert controller’s popoverPresentationController property changes behavior](http://openradar.appspot.com/27448488).

The [iOS Human Interface Guidelines](https://developer.apple.com/ios/human-interface-guidelines/interaction/modality/) state:

> **Don’t display a modal view above a popover.** With the possible exception of an alert, nothing should appear over a popover. In rare cases when you need to present a modal view after action is taken in a popover, close the popover before displaying the modal view.

[and](https://developer.apple.com/ios/human-interface-guidelines/ui-views/popovers/):

> **Show one popover at a time.** Displaying multiple popovers clutters the interface and causes confusion. Never show a cascade or hierarchy of popovers, in which one emerges from another. If you need to show a new popover, close the open one first.

View controller presentations with the [`popover`](https://developer.apple.com/reference/uikit/uimodalpresentationstyle/1621382-popover) style appear as popovers in horizontally regular environments and full screen in horizontally compact environments. [`UIActivityViewController`](https://developer.apple.com/reference/uikit/uiactivityviewcontroller) and [`UIAlertController`](https://developer.apple.com/reference/uikit/uialertcontroller) with the action sheet style follow similar rules: appearing as either popovers or a slide up sheet. So what actually happens if a popover presents an activity view controller or an action sheet? The Human Interface Guidelines and documentation seem to be in conflict.

On a related note, in Pages on iOS 9 we noticed a view controller in a form sheet presenting a [`UIActivityViewController`](https://developer.apple.com/reference/uikit/uiactivityviewcontroller) that fills the form sheet, and wondered if this was default behavior we never noticed before, or whether it was something we could achieve with customization.

![Screen shot of Pages on iPad showing an activity view controller presented as a sheet inside a form sheet](https://pspdfkit.com/images/blog/2016/popovers-on-popovers/pages-sheet-in-form-sheet-59e3007e.jpg)

With most view controllers, to present inside a popover or form sheet you set the [`modalPresentationStyle`](https://developer.apple.com/reference/uikit/uimodalpresentationstyle) of the presented view controller to [`currentContext`](https://developer.apple.com/reference/uikit/uimodalpresentationstyle/1621493-currentcontext) or [`overCurrentContext`](https://developer.apple.com/reference/uikit/uimodalpresentationstyle/1621507-overcurrentcontext). But some UIKit-provided view controllers such as [`UIActivityViewController`](https://developer.apple.com/reference/uikit/uiactivityviewcontroller) and [`UIAlertController`](https://developer.apple.com/reference/uikit/uialertcontroller) supply their own presentation styles, and changes to [`modalPresentationStyle`](https://developer.apple.com/reference/uikit/uimodalpresentationstyle) are ignored.

Normally, [`UIActivityViewController`](https://developer.apple.com/reference/uikit/uiactivityviewcontroller) is presented as a popover in regular widths, and as a transparent sheet in compact widths. But what happens if the activity view controller is presented from a view controller in a compact width, that is within a regular width? This happens if a view controller is presented on iPad with the [`formSheet`](https://developer.apple.com/reference/uikit/uimodalpresentationstyle/1621491-formsheet) or [`popover`](https://developer.apple.com/reference/uikit/uimodalpresentationstyle/1621382-popover) [`modalPresentationStyle`](https://developer.apple.com/reference/uikit/uimodalpresentationstyle), or with a custom presentation controller using the [`overrideTraitCollection`](https://developer.apple.com/reference/uikit/uipresentationcontroller/1618335-overridetraitcollection) property, and then that view controller presents a [`UIActivityViewController`](https://developer.apple.com/reference/uikit/uiactivityviewcontroller).

![Diagram: First View Controller to Second View Controller to Activity View Controller or Action Sheet](https://pspdfkit.com/images/blog/2016/popovers-on-popovers/diagram-23ed42d7.png)

## Action Sheets

First let’s look at [`UIAlertController`](https://developer.apple.com/reference/uikit/uialertcontroller). The root view controller (cyan) presents the second view controller (pink) using the [`formSheet`](https://developer.apple.com/reference/uikit/uimodalpresentationstyle/1621491-formsheet) style (on top) and with the [`popover`](https://developer.apple.com/reference/uikit/uimodalpresentationstyle/1621382-popover) style (below, with split view behavior for reference). The second view controller then presents the alert controller with the action sheet style.

![Form sheet presenting action sheet as popover](https://pspdfkit.com/images/blog/2016/popovers-on-popovers/form-sheet-action-popover-c90794ab.jpg) ![Popover presenting action sheet as popover](https://pspdfkit.com/images/blog/2016/popovers-on-popovers/popover-action-popover-fca43393.jpg)

Although we want to present the action sheet with the sheet presentation style (rather than popover), I set the alert controller’s [`popoverPresentationController.sourceView`](https://developer.apple.com/reference/uikit/uipopoverpresentationcontroller/1622313-sourceview) and [`popoverPresentationController.sourceRect`](https://developer.apple.com/reference/uikit/uipopoverpresentationcontroller/1622324-sourcerect) because in the interests of separating concerns, this view controller should not make assumptions about how it is presented. It might be presented full screen in a different part of the app. The view controller should not have to know about this.

Out of interest, I tried commenting out the [`popoverPresentationController`](https://developer.apple.com/reference/uikit/uiviewcontroller/1621428-popoverpresentationcontroller) setup, and to my surprise this happened:

![Form sheet presenting action sheet as sheet](https://pspdfkit.com/images/blog/2016/popovers-on-popovers/form-sheet-action-sheet-38753715.jpg) ![Popover presenting action sheet as sheet](https://pspdfkit.com/images/blog/2016/popovers-on-popovers/popover-action-sheet-2b011d4f.jpg)

It turns out that just reading the [`popoverPresentationController`](https://developer.apple.com/reference/uikit/uiviewcontroller/1621428-popoverpresentationcontroller) property of the alert controller causes it to show as a popover even when presented from an environment with a compact width. If you want to do this, make sure you’re very sure about the context your view controller is presented in because if you try to present the alert controller in a regular width environment without setting up the popover source then UIKit will raise an exception. Remember that even if the presenting view controller is in a compact width at the time of presentation, that might change while the presentation is active.

I filed [rdar://27448488 Reading an alert controller’s popoverPresentationController property changes behavior](http://openradar.appspot.com/27448488).

## Activity View Controller

Trying the same thing with [`UIActivityViewController`](https://developer.apple.com/reference/uikit/uiactivityviewcontroller), and specifying the popover source information, this happens:

![Form sheet presenting activity view controller as a popover](https://pspdfkit.com/images/blog/2016/popovers-on-popovers/form-sheet-activity-318dfc25.jpg) ![Popover presenting activity view controller as a sheet](https://pspdfkit.com/images/blog/2016/popovers-on-popovers/popover-activity-4bde59d8.jpg)

Unlike the behavior in Pages, I found the form sheet presents the activity view controller as a popover. The popover does present the activity view controller in sheet. This behavior is new in iOS 10\. On iOS 9, it shows a popover presented from another popover.

Trying the same trick of not accessing the [`popoverPresentationController`](https://developer.apple.com/reference/uikit/uiviewcontroller/1621428-popoverpresentationcontroller) results in UIKit raising an exception stating we "must provide location information for this popover."

## Conclusion

We found the behavior very mixed when special UIKit view controllers are presented from compact width environments which are themselves presented from regular width environments. The general rule for popover presentations is that they appears as popovers in regular widths and full screen in compact widths (although current context would make more sense). Actions sheet and activity view controller presentations are a bit like popover presentations, but do not follow that general rule consistently.

The actual behavior seems to follow the Human Interface Guidelines, and mostly ignores the size class of the trait collection. UIKit does not show a popover over a popover with the exception of actions sheet, which are alerts. Size classes aren’t everything.

We can’t reproduce the behavior from Pages. For us, when a form sheet presents an activity view controller it appears as a popover. I reported this to Apple in [rdar://27448912 Can’t show activity view controller filling a form sheet](http://openradar.appspot.com/27448912). If you know a way to do this, [let me know on Twitter](https://twitter.com/qdoug).
