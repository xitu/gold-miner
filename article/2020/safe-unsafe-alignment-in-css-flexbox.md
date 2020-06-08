> * 原文地址：[Safe/unsafe alignment in CSS flexbox](https://www.stefanjudis.com/today-i-learned/safe-unsafe-alignment-in-css-flexbox/)
> * 原文作者：[Stefan](https://www.stefanjudis.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/safe-unsafe-alignment-in-css-flexbox.md](https://github.com/xitu/gold-miner/blob/master/article/2020/safe-unsafe-alignment-in-css-flexbox.md)
> * 译者：[Badd](https://juejin.im/user/5b0f6d4b6fb9a009e405dda1)
> * 校对者：[rachelcdev](https://github.com/rachelcdev)、[TUARAN](https://github.com/TUARAN)

# CSS Flexbox 中安全/不安全的对齐方式

我最近看了 [Rachel Andrews](https://twitter.com/rachelandrew) 的演讲[锦上添花：重新定义 CSS 的技术潜力](https://aneventapart.com/news/post/making-things-better-aea-video)。Rachel 的演讲总是能清晰而简洁地传达出满满的干货。这次演讲中有一行 CSS 代码是我从未见过的。

```css
.something {
  display: flex;
  // 👇 这是什么操作？😲 
  align-items: safe center;
}
```

## CSS 的数据防丢目标

Rachel 解释说，在制定 CSS 规范时，其中一条关键原则就是防止数据丢失。我还是第一次听说这种说法。我们在 CSS 中遇到数据丢失的频率如何？做了哪些预防措施？

CSS 的使命是让访问者看到内容和元素。CSS 就是为此而生的。容器会根据内容自动向右或向下扩展。当内容超出范围，容器进入可滚动状态。除非你用 `overflow: hidden;` 禁用了这一功能，否则，用户可以通过滚动看到容器范围之外的内容。

我了解到，当使用 Flexbox 时，在某些情况下无法防止数据丢失。

## CSS Flexbox 上下文中的数据丢失

假设有下列 HTML 代码：

```html
<div class="container">
  <span>CSS</span>
  <span>is</span>
  <span>awesome!</span>
</div>
```

搭配如下 CSS 代码：

```css
.container {
  display: flex;
  flex-direction: column;
  align-items: center;
}
```

[align-items 属性](https://developer.mozilla.org/en-US/docs/Web/CSS/align-items)将子元素沿着交叉轴（Cross axis）居中对齐。这没什么问题，但如果容器/视口的尺寸比较小，就会导致数据丢失。

 [![例子：使用 align-items 导致数据丢失](//images.ctfassets.net/f20lfrunubsq/tX5IzlfIse4rtopH41xJY/2efc8dc4ca4d3e41da194292257fc02a/Screenshot_2020-05-17_19.54.42.png&fm=jpg)](//images.ctfassets.net/f20lfrunubsq/tX5IzlfIse4rtopH41xJY/2efc8dc4ca4d3e41da194292257fc02a/Screenshot_2020-05-17_19.54.42.png) 

由于 Flexbox 的对齐机制，子元素无论如何都是居中的。子元素的左侧和右侧发生了溢出。问题是，左侧的溢出部分在视口的起始边缘以外。你无法通过滚动来显示这一部分 —— 这样就发生了数据的丢失。

在这种情况下，`align-items` 属性的 `safe` 关键词就派上用场了。[The CSS Box Alignment Module Level 3](https://drafts.csswg.org/css-align-3/#overflow-values)（仍处于草稿状态）中对安全对齐是这样定义的：

> “安全” 的对齐方式在溢出时改变了对齐模式，以避免数据丢失。

如果你定义了 `safe` 对齐方式，那么会在发生溢出时按照 `start` 方式来对齐元素。

```css
.container {
  display: flex;
  flex-direction: column;
  align-items: safe center;
}
```

 [![安全对齐：元素转为按起始位置对齐](//images.ctfassets.net/f20lfrunubsq/1Qx8RgAxrHdCzMHHLo8CBl/8a7e5b30e1a90ef8452d83c8668b65c8/Screenshot_2020-05-17_20.04.33.png&fm=jpg)](//images.ctfassets.net/f20lfrunubsq/1Qx8RgAxrHdCzMHHLo8CBl/8a7e5b30e1a90ef8452d83c8668b65c8/Screenshot_2020-05-17_20.04.33.png) 

`safe` 对齐方式让浏览器总是把元素放在用户能看到的地方。

## `safe` 对齐的浏览器支持情况

仅有 Firefox 支持 `safe` 关键字，暂未实现[跨浏览器支持](https://developer.mozilla.org/en-US/docs/Web/CSS/align-items#Support_in_Flex_layout)。**我不推荐现在就使用它**，因为它无法优雅地降级。你可以说这种安全方式本应该是 `align-items` 属性默认支持的，但我也没辙，CSS 确实有些难以驯服。而制定 CSS 规范就更复杂了。🤷🏻‍♂️

那我们当下如何防止数据丢失？

[Bramus Van Damme 指出](https://twitter.com/bramus/status/1259776833589051392)，在 flex 子元素上应用 `margin: auto;` 即可解决问题，不需要用 `safe` 关键字。🎉

### 有问题而不自知

我从没想到居中对齐会导致数据丢失。本文讨论的案例展示了 CSS 规范和布局有多么复杂。为制定规范辛勤付出的人们，我向你们致以最崇高的敬意！

困难只是暂时的，会有那么一天，安全对齐的跨浏览器支持全面普及，让我们拭目以待吧。👋🏻

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
