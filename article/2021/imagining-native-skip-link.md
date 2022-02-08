> * 原文地址：[Imagining native skip links](https://kittygiraudel.com/2021/03/07/imagining-native-skip-links/)
> * 原文作者：[kittygiraudel.com](https://kittygiraudel.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/imagining-native-skip-link.md](https://github.com/xitu/gold-miner/blob/master/article/2021/imagining-native-skip-link.md)
> * 译者：[霜羽 Hoarfroster](https://github.com/PassionPenguin)
> * 校对者：[chzh9311](https://github.com/chzh9311)、[Kimhooo](https://github.com/Kimhooo)

# 假如浏览器支持原生的"跳至内容"链接……

[我们最近在 [A11y Advent calendar](https://kittygiraudel.com/2020/12/01/a11y-advent-calendar/) 话题中谈到了["跳至内容"链接](https://kittygiraudel.com/2020/12/06/a11y-advent-skip-to-content/)。如果你不熟悉这个概念，我引用一下那里的原文：

> 当点击一个链接时，页面会被重新加载，焦点会恢复到页面顶部。而如果在这时候使用无障碍辅助功能在页面中导航，在访问主要内容之前，必须先逐一跳过整个页眉、导航，有时甚至包括侧边栏。这体验太糟糕了！为了解决这个问题，一个常见的设计模式是实现一个跳过链接，也就是发送至主要内容区域的锚链接。

## 存在的问题

所以这一切都很好。只是跳至内容链接的实现并不那么简单。仅列出几个它应该满足的约束条件：

* 它应该是第一个能够被辅助功能识别的链接。
* 它应该被[小心地隐藏起来](https://kittygiraudel.com/2021/02/17/hiding-content-responsibly/)，以让其对特定用户而言仍然可以使用。
* 当聚焦到它上面时它应该变得可见。
* 它的内容应该以 "跳过" 开头，以便于让用户识别。
* 它应该导航到页面的主要内容。

这并不复杂，但也很容易搞砸。既然每个网站都需要这样做，那么问题就来了 —— **为什么浏览器不原生支持呢？** —— 这是12月时[我向 Web We Want](https://github.com/WebWeWant/webwewant.fyi/discussions/233)提议的。

## 浏览器的功能？

不难想象，为了给使用辅助技术的人提供更好、更一致的体验，浏览器可以在原生的情况下处理这个问题，几乎不需要网页开发人员进行控制。

在浏览器的用户界面中跳出一个标签（或使用专用的快捷键切换），进入另一个网页时，浏览器会立即显示跳过链接，并且清楚：

1. 它将作为标签顺序中的第一个元素被插入。
2. 它将使用浏览器的语言，这不一定是网页的语言。
3. 从技术上讲，它将是浏览器界面的一部分，而不是网站的一部分。因此，这将根据浏览器的主题进行样式设计。
4. 它不会被网页故意访问（严格意义上的）。
5. 它将被渲染在页面的顶部，以避免破坏布局的风险。

## 一个 HTML API

中心思想是尽量减少对它的控制权。就像开发者对浏览器的标签或地址栏的外观和行为没有发言权一样。也就是说，链接的目标应该是可以配置的。

一个合理的默认值是指向 `<main>` 元素，因为它在每个页面中都是唯一的，并且明确地要包含主要内容。

> `<main>` 是文档或应用程序正文的主要内容。主要内容区域由与文档的中心主题或应用程序的中心功能直接相关或扩展的内容组成。
> - [W3C HTML 编辑草案](https://html.spec.whatwg.org/multipage/grouping-content.html#the-main-element)

但并不是所有的网站都使用 `<main>` 元素。我认为浏览器可能会有一些内置的启发式方法来找出什么是主要的内容容器，但恐怕这不在该功能讨论的范围内。

因此，为了给 Web 开发者提供一种方法来精确定义哪个容器才是真正的主容器，可以使用一个 `<meta>` 标签。它将接受一个 CSS 选择器（复杂程度由需求决定），当使用跳过链接时，浏览器将查询该 DOM 节点，将滚动并聚焦它。

```html
<meta name="skip-link" value="#content"/>
```

另一种方法是使用带有 `rel` 属性的 `<link>` 标签，如 [Aaron Gustafson 所提示的](https://github.com/WebWeWant/webwewant.fyi/discussions/233#discussioncomment-146471)。

```html
<link rel="skip-link" href="#content"/>
```

浏览器是否应该监听这个元素的变化（不管是什么）是一个开放性的问题。我认为是的，只是为了安全起见。

## 现有的跳转内容链接应该怎么处理？

浏览器是否会在本地实现跳过链接，我们现有的自定义链接又会怎样？他们很可能不会有太大的困扰。

在网页内容区域中的标签将显示原生的跳转链接。如果使用，它将绕过整个导航，包括自定义跳转链接。如果不使用，下一个标签将是网站的跳转链接，这将是多余的，但也无关紧要。

理想的情况是，浏览器提供一种方法来知道是否支持该功能，这样跳转链接就可以为还不支持跳转链接的浏览器进行多重填充。不过这很可能需要 JavaScript。

```js
if (!windows.navigator.skipLink) {
    const skipLink = document.createElement('a')
    skipLink.href='#main'
    skipLink.innerHTML = '跳转到主要内容'
    document.body.prepend(skipLink)
}
```

## 收尾

这绝不是完美的，我也没有一个万无一失的解决方案可以提供。如果有的话，我相信比我更聪明、更有见识的人早就提出来了。

不过，缺乏跳转链接对使用辅助技术浏览网页的人来说是一个很大的障碍。而且考虑到每个网站都需要一个，不同网站之间几乎没有差异，这确实感觉像是浏览器在原生上该做的事情。

和往常一样，欢迎在掘金社区上与我分享你的想法：)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
