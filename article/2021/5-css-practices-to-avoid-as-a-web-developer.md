> * 原文地址：[5 CSS Practices To Avoid as a Web Developer](https://betterprogramming.pub/5-css-practices-to-avoid-as-a-web-developer-1b7553c05131)
> * 原文作者：[Alexey Shepelev](https://medium.com/@alexey-shepelev)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/5-css-practices-to-avoid-as-a-web-developer.md](https://github.com/xitu/gold-miner/blob/master/article/2021/5-css-practices-to-avoid-as-a-web-developer.md)
> * 译者：[霜羽 Hoarfroster](https://github.com/PassionPenguin)
> * 校对者：[KimYang](https://github.com/KimYangOfCat)、[Chorer](https://github.com/Chorer)

# Web 开发者应该避免的 5 个 CSS 的做法

![图源 [Pankaj Patel](https://unsplash.com/@pankajpatel)，上传至 [Unsplash](https://unsplash.com/?utm_source=medium&utm_medium=referral).](https://cdn-images-1.medium.com/max/9874/1*0Ca38BL7C5MRI0qsdAQT3Q.jpeg)

有人认为 CSS 很难学习。他们觉得 CSS 里面有着很多的坑，甚至还有一点儿魔幻，让人很容易会搬起石头砸自己的脚。对此我感到难过，毕竟，我可不这么认为。

在考虑了可以做什么之后，我想到了 5 个我所讨厌的 CSS 的做法，希望帮助大家避免这些习惯。

## 1. 设置内外边距，然后又将其重置

我经常看到人们为所有元素设置内外边距，然后为第一个元素或者最后一个元素清除刚刚写的边距。我不知道为什么你非要在一条规则就可以解决问题的情况下写两条规则。一次为所有必需的元素设置边距明显容易得多！

为简化 CSS，你可以选用以下几种选择器：`nth-child` 或 `nth-of-type` 选择器，还有 `:not()` 伪类或相邻元素组合器（也就是 `+`）。

不要这么写：

```CSS
.item {
    margin-right: 1.6rem;
}

.item:last-child {
    margin-right: 0;
}
```

你可以这么写：

```CSS
.item:not(:last-child) {
    margin-right: 1.6rem;
}
```

或这样写：

```CSS
.item:nth-child(n+2) {
    margin-left: 1.6rem;
}
```

或者用：

```CSS
.item + .item {
    margin-left: 1.6rem;
}
```

## 2. 为 `position` 为 `fixed` 或 `absolute` 的元素添加 `display: block`

你知道吗？其实你无需为 `position` 为 `fixed` 或 `absolute` 的元素添加 `display:block`，因为这是默认发生的。

另外，如果你在这些元素上使用 `inline-*` 值，它们将按以下方式更改：

* `inline`、`inline-block` -> `block`
* `inline-flex` -> `flex`
* `inline-grid` -> `grid`
* `inline-table` -> `table`

因此，对于 `position` 为 `fixed` 或 `absolute` 的元素，你只需在要使用 `flex` 布局或者 `grid` 布局的时候设置 `display`。

不要这样写：

```CSS
.button::before {
    content: "";
    position: absolute;
    display: block;
}
```

或者不要这样写：

```CSS
.button::before {
    content: "";
    position: fixed;
    display: block;
}
```

直接这样：

```CSS
.button::before {
    content: "";
    position: absolute;
}
```

或者这样写：

```CSS
.button::before {
    content: "";
    position: fixed;
}
```

## 3. 使用 `transform: translate(-50%, -50%)` 实现居中

曾几何时，有一个非常普遍的问题弄出了不少毛病。这种情况一直持续到 2015 年，而在此之前，该问题的所有解决方案或多或少都有毛病。这个问题就是 —— 将未指定高度的元素在水平和竖直方向居中。

特别地，一种解决方案是结合使用绝对定位和 `transform` 属性。此技术在基于 Chromium 的浏览器中会导致文本的模糊问题。

但是在引入 `flexbox` 之后，我认为这个解决方法已不再适用，毕竟这个方法存在文本模糊的问题，而且我们还得使用五个属性才能实现居中。现在我想向大家分享一个技巧，缩减代码为两个属性。

我们可以在 `flex` 容器内使用 `margin: auto`（只有这两个属性，仅此而已！）。浏览器会自动将元素居中。

不要这样写：

```CSS
.parent {
    position: relative;
}

.child {
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
}
```

直接这样写：

```CSS
.parent {
    display: flex;
}

.child {
    margin: auto;
}
```

## 4. 为块状元素使用 `width: 100%`

我们经常使用 `flexbox` 创建一个多列网格，然后转换为单列网格。

为了将多列网格转换为单列网格，开发人员使用了 `width: 100％`。我不明白他们为什么这么做 —— 网格元素是块元素，默认情况下的宽度就是 `100%`，我们完全无需使用其他属性来做到这一点。

因此，我们不需要使用 `width：100％`，而是应该编写媒体查询，以便使 `flexbox` 仅用于创建多列网格。

不要这样写：

```HTML
<div class="parent">
    <div class="child">Item 1</div>
    <div class="child">Item 2</div>
    <div class="child">Item 3</div>
    <div class="child">Item 4</div>
</div>
```

```CSS
.parent {
    display: flex;
    flex-wrap: wrap;
}

.child {
    width: 100%;
}

@media (min-width: 1024px) {
    .child {
        width: 25%;
    }
}
```

直接这样写：

```HTML
<div class="parent">
    <div class="child">Item 1</div>
    <div class="child">Item 2</div>
    <div class="child">Item 3</div>
    <div class="child">Item 4</div>
</div>
```

```CSS
@media (min-width: 1024px) {
    .parent {
        display: flex;
        flex-wrap: wrap;
    }

    .child {
        width: 25%;
    }
}
```

## 5. 为 flex 项目设置 `display: block`

使用 flexbox 时，请务必记住，当创建一个 flex 容器（`display: flex`）时，所有子项（`flex` 项目）都会被转化为 `block`。

这意味着所有子项的 `display` 都会被默认设置为 `block`。

* `inline`、`inline-block` -> `block`
* `inline-flex` -> `flex`
* `inline-grid` -> `grid`
* `inline-table` -> `table`

因此，无需在 `flex` 项目中添加 `display: block`，浏览器将为你完成此操作。

不要这样做：

```CSS
.parent {
    display: flex;
}

.child {
    display: block;
}
```

你可以直接这样：

```CSS
.parent {
    display: flex;
}
```

## 小结

希望在阅读本文后，你能够学会如何避免这些简单的错误并接受我的建议。感谢阅读！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
