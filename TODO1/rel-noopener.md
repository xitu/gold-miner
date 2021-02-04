> * 原文地址：[About `rel=noopener`](https://mathiasbynens.github.io/rel-noopener/)
> * 原文作者：[mathias](https://twitter.com/mathias)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/rel-noopener.md](https://github.com/xitu/gold-miner/blob/master/TODO1/rel-noopener.md)
> * 译者：
> * 校对者：

# About `rel=noopener`

## What problems does it solve?

You’re currently viewing `index.html`.

Imagine the following is user-generated content on your website:

[**Click me!!1 (same-origin)**](malicious.html)

Clicking the above link opens `malicious.html` in a new tab (using `target=_blank`). By itself, that’s not very exciting.

However, the `malicious.html` document in this new tab has a `window.opener` which points to the `window` of the HTML document you’re viewing right now, i.e. `index.html`.

This means that once the user clicks the link, `malicious.html` has full control over this document’s `window` object!

Note that this also works when `index.html` and `malicious.html` are on different origins — `window.opener.location` is accessible across origins! (Things like `window.opener.document` are not accessible cross-origin, though; and [CORS](https://fetch.spec.whatwg.org/#http-cors-protocol) does not apply here.) Here’s an example with a cross-origin link:

[**Click me!!1 (cross-origin)**](https://mathiasbynens.be/demo/opener)

In this proof of concept, `malicious.html` replaces the tab containing `index.html` with `index.html#hax`, which displays a hidden message. This is a relatively harmless example, but instead it could’ve redirected to a phishing page, designed to look like the real `index.html`, asking for login credentials. The user likely wouldn’t notice this, because the focus is on the malicious page in the new window while the redirect happens in the background. This attack could be made even more subtle by adding a delay before redirecting to the phishing page in the background (see [**tab nabbing**](http://www.azarask.in/blog/post/a-new-type-of-phishing-attack/)).

TL;DR If `window.opener` is set, a page can trigger a navigation in the opener regardless of security origin.

## Recommendations

To prevent pages from abusing `window.opener`, use [`rel=noopener`](https://html.spec.whatwg.org/multipage/semantics.html#link-type-noopener). This ensures `window.opener` is `null` in [Chrome 49 & Opera 36](https://dev.opera.com/blog/opera-36/#a-relnoopener "What’s new in Chromium 49 and Opera 36"), Firefox 52, Desktop Safari 10.1+, and iOS Safari 10.3+.

[**Click me!!1 (now with `rel=noopener`)**](malicious.html)

For older browsers, you could use [`rel=noreferrer`](https://html.spec.whatwg.org/multipage/semantics.html#link-type-noreferrer) which also disables the `Referer` HTTP header, or the following JavaScript work-around which potentially triggers the popup blocker:

```
var otherWindow = window.open();
otherWindow.opener = null;
otherWindow.location = url;
```

[**Click me!!1 (now with `rel=noreferrer`-based workaround)**](malicious.html) [**Click me!!1 (now with `window.open()`-based workaround)**](malicious.html)

Note that [the JavaScript-based work-around fails in Safari](https://github.com/danielstjules/blankshield#solutions). For Safari support, inject a hidden `iframe` that opens the new tab, and then immediately remove the `iframe`.

Don’t use `target=_blank` (or any other `target` that opens a new navigation context), **especially for links in user-generated content**, unless you have [a good reason to](https://css-tricks.com/use-target_blank/).

## Notes

In [Safari Technology Preview 68](https://webkit.org/blog/8475/release-notes-for-safari-technology-preview-68/), `target="_blank"` on anchors implies `rel="noopener"`. To explicitly opt-in to having `window.opener` be present, use `rel="opener"`. An attempt is being made to [standardize this](https://github.com/whatwg/html/issues/4078).

## Bug tickets to follow

* [Gecko/Firefox bug #1222516](https://bugzilla.mozilla.org/show_bug.cgi?id=1222516) fixed
* [WebKit/Safari bug #155166](https://bugs.webkit.org/show_bug.cgi?id=155166) fixed
* [Microsoft Edge feature request](https://wpdev.uservoice.com/forums/257854-microsoft-edge-developer/suggestions/12942405-implement-rel-noopener)
* [Chromium/Chrome/Opera bug #168988](https://bugs.chromium.org/p/chromium/issues/detail?id=168988) fixed

---

Questions? Feedback? Tweet [@mathias](https://twitter.com/mathias). if (location.search) { // https://news.ycombinator.com/item?id=11553740 location = document.querySelector('link\[rel="canonical"\]').href; }

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
