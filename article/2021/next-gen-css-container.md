> * 原文地址：[Next Gen CSS: @container](https://css-tricks.com/next-gen-css-container/)
> * 原文作者：[Una Kravets](https://css-tricks.com/author/unakravets/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/next-gen-css-containermd](https://github.com/xitu/gold-miner/blob/master/article/2021/next-gen-css-container.md)
> * 译者：[霜羽 Hoarfroster](https://github.com/PassionPenguin)
> * 校对者：[Chorer](https://github.com/Chorer)、[Kim Yang](https://github.com/KimYangOfCat)

# 下一代 CSS：@container

Chrome 正在试验 CSS `@container` 查询器功能，这是由 [Oddbird](https://css.oddbird.net/rwd/query/) 的 [Miriam Suzanne](https://twitter.com/TerribleMia) 和一群网络平台开发者支持的 CSS 工作组 [Containment Level 3 规范](https://github.com/w3c/csswg-drafts/issues?q=is%3Aissue+label%3Acss-contain-3+)。`@container` 查询器使我们能够**根据父容器的大小来设置元素的样式**。

> `@container` API 不稳定，会受到语法变化的影响。如果你想要自己尝试一下，可能会遇到一些错误。请将这些错误报告给相应的浏览器引擎！**报告错误的链接如下：**
>
> * [Chrome](https://bugs.chromium.org/p/chromium/issues/list)
> * [Firefox](https://bugzilla.mozilla.org/home)
> * [Safari](https://bugs.webkit.org/query.cgi?format=specific&product=WebKit)

你可以把这些想象成一个媒体查询（`@media`），但不是依靠 **viewport** 来调整样式，而是你的目标元素的父容器会调整这些样式。

## 容器查询将是自 CSS3 以来 Web 样式的最大变化，将会改变我们对“响应式设计”含义的看法。

viewport 和用户代理不再是我们创建响应式布局和 UI 样式的唯一目标。通过容器查询，元素将能够定位自己的父元素并相应地应用自己的样式。这意味着存在于侧边栏、主体或头图中的相同元素可能会根据其可用大小和动态看起来完全不同。

## `@container` 实例

在[本示例](https://codepen.io/una/pen/LYbvKpK)中，我在父级中使用了两张带有以下标记的卡片：

```html
<div class="card-container">
    <div class="card">
        <figure> ...</figure>
        <div>
            <div class="meta">
                <h2>...</h2>
                <span class="time">...</span>
            </div>
            <div class="notes">
                <p class="desc">...</p>
                <div class="links">...</div>
            </div>
            <button>...</button>
        </div>
    </div>
</div>
```

然后，我在将查询容器样式的父级（`.card-container`）上设置 Containment（[`contain` 属性](https://css-tricks.com/almanac/properties/c/contain/)）。我还在 `.card-container` 的父级上设置了一个相对网格布局，因此它的 `inline-size` 将根据该网格而改变。这就是我使用 `@container` 查询的内容：

```css
.card-container {
  contain: layout inline-size;
  width: 100%;
}
```

现在，我可以查询容器样式来调整样式！这与使用基于宽度的媒体查询设置样式的方式非常相似，当元素**小于指定尺寸**时使用 `max-width` 设置样式，当元素**大于指定尺寸**时使用 `min-width`。

```css
/* 当父容器宽度小于 850px，
不再显示 .links
并且减小 .time 字体尺寸 */

@container (max-width: 850px) {
  .links {
    display: none;
  }

  .time {
    font-size: 1.25rem;
  }

  /* ... */
}

/* 当父容器宽度小于 650px 时，
减小 .card 元素之间的网格间距到 1rem */

@container (max-width: 650px) {
  .card {
    gap: 1rem;
  }

  /* ... */
}
```

![1](https://user-images.githubusercontent.com/5164225/120361018-f670b380-c33b-11eb-8c42-38fdbb1b5a8a.gif)

## 容器查询 + 媒体查询

容器查询的最佳功能之一是能够将 **微观上的布局** 与 **宏观上的布局** 分开。我们可以使用容器查询设置单个元素的样式，创建细微的微观布局，并使用媒体查询（宏布局）设置整个页面布局的样式。这创造了一个新的控制水平，使界面更具响应性。

这是[另一个示例](https://codepen.io/una/pen/RwodQZw)。它展示了使用媒体查询进行宏观布局（即日历从单面板到多面板）和微观布局（即日期布局/大小和事件边距/大小移动），以创建一个漂亮的和谐的查询。

![2](https://user-images.githubusercontent.com/5164225/120361024-f8d30d80-c33b-11eb-8bed-4b367965f7be.gif)

## 容器查询 + CSS 网格

我个人最喜欢的查看容器查询影响的方法之一是查看它们在网格中的工作方式。以下面的植物贸易 UI 为例：

![3](https://user-images.githubusercontent.com/5164225/120361028-fa9cd100-c33b-11eb-8328-148977357c44.gif)

本网站根本没有使用媒体查询。相反，我们只使用容器查询和 CSS 网格来在不同的视图中显示购物卡组件。

在产品网格中，布局使用了 `grid-template-columns: repeat(auto-fit, minmax(230px, 1fr));` 标记创建。这将创建一个布局，告诉卡片占用可用的小数空间，直到它们的大小达到 `230px`，然后下一格切换到下一行。你可以在 [1linelayouts.com](http://1linelayouts.glitch.me) 上查看更多网格技巧。

然后，我们有一个容器查询，当卡片宽度小于 `350px` 时，它会将卡片样式设置为采用垂直块布局，并通过应用 `display: flex`（默认情况下具有内联流）转换为水平内联布局。

```css
@container (min-width: 350px) {
  .product-container {
    padding: 0.5rem 0 0;
    display: flex;
  }

  /* ... */
}
```

这意味着每张卡片**拥有自己的响应式样式**。这是我们使用产品网格创建宏观布局以及使用产品卡片创建微观布局的另一个示例，酷毙了！

## 用法

为了使用`@container`，首先需要创建一个具有 [Containment](https://developer.mozilla.org/zh-CN/docs/Web/CSS/contain) 的父元素。为此，我们需要在父级上设置 `contain: layout inline-size`。因为我们目前只能将容器查询应用于内联轴，所以我们只可以使用 `inline-size`。这也可以防止我们的布局在块方向上中断。

设置 `contain: layout inline-size` 会创建一个新的 [Containment 块](https://developer.mozilla.org/zh-CN/docs/Web/CSS/Containing_block) 和新的[块格式上下文](https://developer.mozilla.org/zh-CN/docs/Web/Guide/CSS/Block_formatting_context)，让浏览器将其与布局的其余部分分开，现在我们就可以使用容器查询了！

## 限制

目前，您不能使用基于高度的容器查询，只能使用块轴方向上的查询。为了让网格子元素与 `@container` 一起工作，我们需要添加一个容器元素。尽管如此，添加容器仍可让我们获得所需的效果。
 
## 试试看

您现在可以在 Chromium 中试验 `@container` 属性，方法是导航到：[Chrome Canary](https://www.google.com/chrome/canary/) 中的 `chrome://flags` 页面并打开 **#experimental-container-queries** 标志。

![](https://i2.wp.com/css-tricks.com/wp-content/uploads/2021/05/chrome-canary-conatiner-query-flag.png?resize=1902%2C1510&ssl=1)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
