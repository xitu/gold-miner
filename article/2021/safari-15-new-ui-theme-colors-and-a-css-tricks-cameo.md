> * 原文地址：[Safari 15: New UI, Theme Colors, and… a CSS-Tricks Cameo!](https://css-tricks.com/safari-15-new-ui-theme-colors-and-a-css-tricks-cameo/)
> * 原文作者：[Chris Coyier](https://css-tricks.com/author/chriscoyier/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/safari-15-new-ui-theme-colors-and-a-css-tricks-cameo.md](https://github.com/xitu/gold-miner/blob/master/article/2021/safari-15-new-ui-theme-colors-and-a-css-tricks-cameo.md)
> * 译者：
> * 校对者：

# Safari 15: New UI, Theme Colors, and… a CSS-Tricks Cameo!

There’s [a 33-minute video](https://developer.apple.com/videos/play/wwdc2021/10029/) (and resources) over on apple.com covering the upcoming Safari changes we saw in the WWDC keynote this year in much more detail. Look who’s got a little cameo in there:

![](https://i0.wp.com/css-tricks.com/wp-content/uploads/2021/06/Screen-Shot-2021-06-11-at-8.20.24-AM.png?resize=1684%2C970&ssl=1)

Perhaps the most noticeable thing there in Safari 15 on iOS is **URL bar at the bottom**! [Dave](https://daverupert.com/) was speculating in our little [Discord](https://www.patreon.com/shoptalkshow) watch party that this probably fixes the [weird issues with `100vh` stuff](https://css-tricks.com/css-fix-for-100vh-in-mobile-webkit/) on iOS. But I really just don’t know, we’ll have to see when it comes out and we can play with it. I’d *guess* the expectation is that, in order for us to do our own fixed-bottom-UI stuff, we’d be doing:

```css
.bottom-nav { 
  position: fixed; /* maybe sticky is better if part of overall page layout? */
  bottom: 100vh; /* fallback? */
  bottom: calc(100vh - env(safe-area-inset-bottom)); /* new thing */
}
```

On desktop, the most noticeable visual feature is probably the `theme-color` meta tags.

![](https://i1.wp.com/css-tricks.com/wp-content/uploads/2021/06/Screen-Shot-2021-06-11-at-8.22.55-AM.png?resize=1658%2C948&ssl=1)

![](https://i1.wp.com/css-tricks.com/wp-content/uploads/2021/06/Screen-Shot-2021-06-11-at-8.22.55-AM.png?resize=1658%2C948&ssl=1)

This isn’t even a brand new Apple-only thing. This is the same `<meta>` tag that Chrome’s Android app has used [since 2014](https://developers.google.com/web/updates/2014/11/Support-for-theme-color-in-Chrome-39-for-Android), so you might already be sporting it on your own site. The addition is that it supports `media` queries.

```html
<meta name="theme-color" 
      content="#ecd96f" 
      media="(prefers-color-scheme: light)">
<meta name="theme-color" 
      content="#0b3e05" 
      media="(prefers-color-scheme: dark)">
```

It’s great to see Safari get `aspect-ratio` and the new fancy color systems like `lab()` and `lch()` as well. Top-level `await` in JavaScript is great as it makes patterns like [conditional imports](https://css-tricks.com/dynamic-conditional-imports/) easier.

I don’t think all this would [satisfy Alex](https://infrequently.org/2021/04/progress-delayed/). We didn’t exactly get alternative browser engines on iOS or significant PWA enhancements (both of which would be really great to see). But I applaud it all—it’s good stuff. While I do think Google generally takes privacy more seriously than what general internet chatter would have to believe, it’s notable to compare each company’s newly-released features. If you’ll forgive a bit of cherry-picking, Google is working on [FLoC](https://blog.google/products/chrome/privacy-sustainability-and-the-importance-of-and/), a technology very specifically designed to help targeted advertising. Apple is working on [Private Relay](https://developer.apple.com/videos/play/wwdc2021/10096/), a technology very specifically to making web browsing untrackable.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
