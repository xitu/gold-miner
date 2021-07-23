> * 原文地址：[Safari 15: New UI, Theme Colors, and… a CSS-Tricks Cameo!](https://css-tricks.com/safari-15-new-ui-theme-colors-and-a-css-tricks-cameo/)
> * 原文作者：[Chris Coyier](https://css-tricks.com/author/chriscoyier/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/safari-15-new-ui-theme-colors-and-a-css-tricks-cameo.md](https://github.com/xitu/gold-miner/blob/master/article/2021/safari-15-new-ui-theme-colors-and-a-css-tricks-cameo.md)
> * 译者：[霜羽 Hoarfroster](https://github.com/PassionPenguin)
> * 校对者：

# Safari 15：新用户界面、主题颜色和……CSS-Tricks Cameo！

apple.com 上有 [一段 33 分钟的视频](https://developer.apple.com/videos/play/wwdc2021/10029/)（和相关资源），涵盖了我们在今年 WWDC 主题演讲中看到的即将到来的 Safari 变化更详细。看看谁有一个小客串：

![](https://i0.wp.com/css-tricks.com/wp-content/uploads/2021/06/Screen-Shot-2021-06-11-at-8.20.24-AM.png?调整大小=1684%2C970&ssl=1)

iOS 版 Safari 15 中最引人注目的可能是**底部的 URL 栏**！[Dave](https://daverupert.com/) 在我们的小型 [Discord](https://www.patreon.com/shoptalkshow) 观看活动中推测这可能解决了在 iOS 上的 [`100vh` 东西的奇怪问题](https://css-tricks.com/css-fix-for-100vh-in-mobile-webkit/)。但我真的不知道，我们必须看看它什么时候出来，我们才能尝试使用它。我**猜测**的想法是，为了让我们做我们自己的固定底部 UI 的东西，我们需要这样写：

```css
.bottom-nav { 
  position: fixed; /* 或许 sticky 更好？ */
  bottom: 100vh; /* 向后兼容？ */
  bottom: calc(100vh - env(safe-area-inset-bottom)); /* 新东西，OMG */
}
```

在桌面上，最引人注目的视觉特征可能是 `theme-color` 元标签。

![](https://i1.wp.com/css-tricks.com/wp-content/uploads/2021/06/Screen-Shot-2021-06-11-at-8.22.55-AM.png?resize=1658%2C948&ssl=1)

这甚至不是全新的 Apple 独有的东西。这与 Chrome 的 Android 应用 [自 2014 年以来就支持的功能](https://developers.google.com/web/updates/2014/11/Support-for-theme-color-in-Chrome-39-for-Andro)完全一致，因此您可能已经在自己的网站上使用它。此外，它支持媒体查询。

```html
<meta name="theme-color" 
      content="#ecd96f" 
      media="(prefers-color-scheme: light)">
<meta name="theme-color" 
      content="#0b3e05" 
      media="(prefers-color-scheme: dark)">
```

很高兴看到 Safari 获得了 `aspect-ratio` 以及 `lab()` 和 `lch()` 等新的花哨的色彩系统。JavaScript 中的顶级 `await` 很棒，因为它使[条件导入](https://css-tricks.com/dynamic-conditional-imports/)之类的模式更容易。

我认为这一切都不会[满足亚历克斯](https://infrequently.org/2021/04/progress-delayed/)（或查看本人发表在掘金上的译文 await url []()）。我们并没有完全在 iOS 上获得替代浏览器引擎或显着的 PWA 增强（这两者都非常值得一看），但我为这一切鼓掌 —— 这是好东西。虽然我确实认为谷歌通常比一般的互联网喋喋不休所相信的更重视隐私，但比较每家公司新发布的功能是值得注意的。如果你能原谅一些挑剔的话，谷歌正在研究 [FLoC](https://blog.google/products/chrome/privacy-sustainability-and-the-importance-of-and/)，一种技术非常专门用于帮助有针对性的广告。Apple 正在开发 [Private Relay](https://developer.apple.com/videos/play/wwdc2021/10096/)，这是一项专门用于使网页浏览无法跟踪的技术。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
