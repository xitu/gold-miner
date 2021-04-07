> * 原文地址：[Imagining native skip links](https://kittygiraudel.com/2021/03/07/imagining-native-skip-links/)
> * 原文作者：[kittygiraudel.com](https://kittygiraudel.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/imagining-native-skip-link.md](https://github.com/xitu/gold-miner/blob/master/article/2021/imagining-native-skip-link.md)
> * 译者：
> * 校对者：

# Imagining native skip links

[We recently talked about skip links](https://kittygiraudel.com/2020/12/06/a11y-advent-skip-to-content/) in our [A11y Advent calendar](https://kittygiraudel.com/2020/12/01/a11y-advent-calendar/). In case you are not familiar with the concept, I quote:

> The page is reloaded when following a link and the focus is restored to the top of the page. When navigating with assistive technologies, that means having to tab through the entire header, navigation, sometimes even sidebar before getting to access the main content. This is bad. To work around the problem, a common design pattern is to implement a skip link, which is an anchor link sending to the main content area.

## The problem

So that’s all great. Except a skip link is not so trivial to implement. To name just a few constraints it should fulfill:

* It should be the first thing to tab into.
* It should be [hidden carefully](/2021/02/17/hiding-content-responsibly/) so it remains focusable.
* When focused, it should become visible.
* Its content should start with “Skip” to be easily recognisable.
* It should lead to the main content of the page.

It’s not massively complex, but it’s also easy to screw up. And since it’s required on every single website, it begs the question… **Why don’t browsers do it natively?** That is something [I suggested to the Web We Want](https://github.com/WebWeWant/webwewant.fyi/discussions/233) back in December.

## A browser feature?

It’s not hard to imagine how browsers could handle this natively, with little to no control left to web developers in order to provide a better and more consistent experience for people using assistive technologies.

When tabbing out of the browser’s chrome and into a web page (or using a dedicated short key), the browser would immediately display the skip link knowing that:

1. It would be inserted as the very first element in tab order.
2. It would use the browser’s language, which might not necessarily be the page’s language.
3. It would technically be part of the browser’s interface and not part of the website. So this would be styled according to the browser’s theme.
4. It would not be accessible (in the strict meaning of the term) by the web page, on purpose.
5. It would be rendered on top of the page in order not to risk breaking the layout.

## An HTML API

The main idea is to have little to no control about it. The same way developers do not have a say on how the browsers’ tabs or address bar look and behave. That being said, the target for the link should be configurable.

A sensible default would be to point to the `<main>` element since it is unique per page and is explicitly intended to contain main content.

> The main content of the body of a document or application. The main content area consists of content that is directly related to or expands upon the central topic of a document or central functionality of an application.  
> — [W3C HTML Editors Draft](https://html.spec.whatwg.org/multipage/grouping-content.html#the-main-element)

Not all websites use the `<main>` element though. I assume browsers could have some baked-in heuristics to figure out what is the main content container, but perhaps that falls outside of the scope of this feature suggestion.

Therefore, providing a way for web developers to precisely define which container really is the main one, a `<meta>` tag could be used. It would accept a CSS selector (as simple or complex as it needs to be), and the browser would query that DOM node to move the scroll + focus to it when using the skip link.

```html
<meta name="skip-link" value="#content"/>
```

Another approach would be to use a `<link>` tag with the `rel` attribute, as [hinted by Aaron Gustafson](https://github.com/WebWeWant/webwewant.fyi/discussions/233#discussioncomment-146471).

```html
<link rel="skip-link" href="#content"/>
```

Whether browsers should listen to changes for this element (whichever may that be) is an open question. I would argue that yes, just to be on the safe side.

## What about existing skip links?

Would browsers implement skip links natively, what would happen of our existing custom ones? They would most likely not bother all that much.

Tabbing within the web content area would display the native skip link. If used, it would bypass the entire navigation including the custom skip link. If not, the next tab would be the site’s skip link, which would be redundant, but not critical either.

Ideally, the browser provides a way to know whether that feature is supported at all so skip links can be polyfilled for browsers not supporting them natively yet. This would most likely require JavaScript though.

```js
if (!window.navigator.skipLink) {
    const skipLink = document.createElement('a')
    skipLink.href = '#main'
    skipLink.innerHTML = 'Skip to content'
    document.body.prepend(skipLink)
}
```

## Wrapping up

This is by no mean perfect. I don’t have a bulletproof solution to offer. And if there was one, I’m certain people way smarter and more educated than I am would have offered it already.

Still, the lack of skip links represent a significant accessibility impediment to people using assistive technologies to browse the web. And considering every website needs one, with little to no variation from website to website, it does feel like something browsers could do on their side.

As always, feel free to share your thoughts with me on Twitter. :)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
