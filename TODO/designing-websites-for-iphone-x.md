
> * 原文地址：[Designing Websites for iPhone X](https://webkit.org/blog/7929/designing-websites-for-iphone-x/)
> * 原文作者：[Timothy Horton](https://webkit.org/blog/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/designing-websites-for-iphone-x.md](https://github.com/xitu/gold-miner/blob/master/TODO/designing-websites-for-iphone-x.md)
> * 译者：
> * 校对者：

# Designing Websites for iPhone X

Out of the box, Safari displays your existing websites beautifully on the edge-to-edge display of the new iPhone X. Content is automatically inset within the display’s safe area so it is not obscured by the rounded corners, or the device’s sensor housing.

The inset area is filled with the page’s `background-color` (as specified on the `<body>` or `<html>` elements) to blend in with the rest of the page. For many websites, this is enough. If your page has only text and images above a solid background color, the default insets will look great.

Other pages — especially those designed with full-width horizontal navigation bars, like the page below — can optionally go a little further to take full advantage of the features of the new display. The [iPhone X Human Interface Guidelines](https://developer.apple.com/ios/human-interface-guidelines/overview/iphone-x/) detail a few of the general design principles to keep in mind, and the [UIKit documentation](https://developer.apple.com/documentation/uikit/uiview/positioning_content_relative_to_the_safe_area) discusses specific mechanisms native apps can adopt to ensure that they look good. Your website can make use of a few similar new pieces of WebKit API introduced in iOS 11 to take full advantage of the edge-to-edge nature of the display.

While reading this post you can tap on any of the images to visit a corresponding live demo page and take a peek at the source code.

[![Safari's default insetting behavior](https://webkit.org/wp-content/uploads/default-inset-behavior.png)](/demos/safe-area-insets/1-default.html)

Safari’s default insetting behavior.

## Using the Whole Screen

The first new feature is an extension to the existing `viewport` meta tag called [`viewport-fit`](https://www.w3.org/TR/css-round-display-1/#viewport-fit-descriptor), which provides control over the insetting behavior. `viewport-fit` is available in iOS 11.

The default value of `viewport-fit` is `auto`, which results in the automatic insetting behavior seen above. In order to disable that behavior and cause the page to lay out to the full size of the screen, you can set `viewport-fit` to `cover`. After doing so, our `viewport` meta tag now looks like this:

```
<meta name='viewport' content='initial-scale=1, viewport-fit=cover'>
```

After reloading, the navigation bar looks much better, running from edge to edge. However, it is immediately clear why it is important to respect the system’s safe area insets: some of the page’s content is obscured by the device’s sensor housing, and the bottom navigation bar is very hard to use.

[![viewport-fit=cover](https://webkit.org/wp-content/uploads/viewport-fit-cover.png)](/demos/safe-area-insets/2-viewport-fit.html)

Use `viewport-fit=cover` to fill the whole screen.

## Respecting the Safe Areas

The next step towards making our page usable again after adopting `viewport-fit=cover` is to selectively apply padding to elements that contain important content, in order to ensure that they are not obscured by the shape of the screen. This will result in a page that takes full advantage of the increased screen real estate on iPhone X while adjusting dynamically to avoid the corners, sensor housing, and indicator for accessing the Home screen.

[![Safe and Unsafe Areas](https://webkit.org/wp-content/uploads/safe-areas.png)](/demos/safe-area-insets/safe-areas.html)

The safe and unsafe areas on iPhone X in the landscape orientation, with inset constants indicated.

To achieve this, WebKit in iOS 11 includes a [new CSS function](https://github.com/w3c/csswg-drafts/pull/1817), `constant()`, and a set of [four pre-defined constants](https://github.com/w3c/csswg-drafts/pull/1819), `safe-area-inset-left`, `safe-area-inset-right`, `safe-area-inset-top`, and `safe-area-inset-bottom`. When combined, these allow style declarations to reference the current size of the safe area insets on each side.

The CSS Working Group [recently resolved to add this feature](https://github.com/w3c/csswg-drafts/issues/1693#issuecomment-330909067), but with a different name. Please keep this in mind while adopting.

`constant()` works anywhere `var()` does — for example, inside the `padding` properties:

```
.post {
    padding: 12px;
    padding-left: constant(safe-area-inset-left);
    padding-right: constant(safe-area-inset-right);
}
```

For browsers that do not support `constant()`, the style rule that includes it will be ignored; for this reason, it is important to continue to separately specify fallback rules for any declarations using `constant()`.

[![Safe area constants](https://webkit.org/wp-content/uploads/safe-area-constants.png)](/demos/safe-area-insets/3-safe-area-constants.html)

Respect safe area insets so that important content is visible.

## Bringing It All Together, With min() and max()

This section covers features that are **not** currently included in iOS 11.

If you adopt safe area inset constants in your website design, you might notice that it is somewhat difficult to specify that you want a minimum padding _in addition_ to the safe area inset. In the page above, where we replaced our 12px left padding with `constant(safe-area-inset-left)`, when we rotate back to portrait, the left safe area inset becomes 0px, and the text sits immediately adjacent to the screen edge.

[![No margins](https://webkit.org/wp-content/uploads/no-margins.png)](/demos/safe-area-insets/3-safe-area-constants.html)

Safe area insets are not a replacement for margins.

To solve this, we want to specify that our padding should be the default padding or the safe area inset, whichever is greater. This can be achieved with the [brand-new CSS functions `min()` and `max()`](https://drafts.csswg.org/css-values/#calc-notation) which will be available in a future Safari Technology Preview release. Both functions take an arbitrary number of arguments and return the minimum or maximum. They can be used inside of `calc()`, or nested inside each other, and both functions allow `calc()`-like math inside of them.

For this case, we want to use `max()`:

```
@supports(padding: max(0px)) {
    .post {
        padding-left: max(12px, constant(safe-area-inset-left));
        padding-right: max(12px, constant(safe-area-inset-right));
    }
}
```

It is important to use @supports to feature-detect min and max, because they are not supported everywhere, and due to CSS’s [treatment of invalid variables](https://drafts.csswg.org/css-variables/#invalid-variables), to **not** specify a variable inside your @supports query.

In our example page, in portrait orientation, `constant(safe-area-inset-left)` resolves to 0px, so the `max()` function resolves to 12px. In landscape, when `constant(safe-area-inset-left)` is larger due to the sensor housing, the `max()` function will resolve to that size instead, ensuring that the important content within is always visible.

[![max() with safe area insets](https://webkit.org/wp-content/uploads/max-safe-areas-insets.png)](/demos/safe-area-insets/4-min-max.html)

Use max() to combine safe area insets with traditional margins.

Experienced web developers might have previously encountered the “CSS locks” mechanism, commonly used to clamp CSS properties to a particular range of values. Using `min()` and `max()` together makes this much easier, and will be very helpful in implementing effective responsive designs in the future.

## Feedback and Questions

You can start adopting viewport-fit and safe area insets today, by using Safari in the iPhone X Simulator included with [Xcode 9](https://developer.apple.com/xcode/). We’d love to hear how your adoption of all of these features goes, so please feel free to send feedback and questions to [web-evangelist@apple.com](mailto:web-evangelist@apple.com) or [@webkit](https://twitter.com/webkit) on Twitter, and to file any bugs that you run into on [WebKit’s bug tracker](https://bugs.webkit.org/).


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
