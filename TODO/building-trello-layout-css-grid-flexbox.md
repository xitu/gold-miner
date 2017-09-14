
> * 原文地址：[Building a Trello Layout with CSS Grid and Flexbox](https://www.sitepoint.com/building-trello-layout-css-grid-flexbox/)
> * 原文作者：[Giulio Mainardi](https://www.sitepoint.com/author/gmainardi/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/building-trello-layout-css-grid-flexbox.md](https://github.com/xitu/gold-miner/blob/master/TODO/building-trello-layout-css-grid-flexbox.md)
> * 译者：[sunui](https://github.com/sunui)
> * 校对者：[Aladdin-ADD](https://github.com/Aladdin-ADD)、[ahonn](https://github.com/ahonn)

# 使用 CSS 栅格和 Flexbox 打造 Trello 布局
 
通过本教程，我将带你完成 [Trello](https://trello.com/) 看板 ([查看示例](https://trello.com/b/nC8QJJoZ/trello-development-roadmap))的基本布局。这是一个响应式的、纯 CSS 的解决方案，并且我们将只开发布局的结构特性。

[这是一个 CodePen demo](https://codepen.io/SitePoint/pen/brmXRX?editors=0100)，可预览一下最终结果。

![](https://dab1nmslvvntp.cloudfront.net/wp-content/uploads/2017/08/1504250645trello-screen.png)

除了[栅格布局](https://www.sitepoint.com/introduction-css-grid-layout-module/)和 [Flexbox](https://www.sitepoint.com/flexbox-css-flexible-box-layout/)，这个方案还采用了 [calc](https://www.sitepoint.com/css3-calc-function/) 和[视图单位](https://www.sitepoint.com/css-viewport-units-quick-start/)。我们也将利用 [Sass 变量](http://sass-lang.com/documentation/file.SASS_REFERENCE.html#variables_)，让代码更可读和高效。

不提供向下兼容，所以请确保在支持的浏览器上运行。一切就绪，就让我们开始一步一步开发看板组件吧。

## 屏幕布局

一个 Trello 看板由一个 app 栏、一个 board 栏和一个包含卡片列表的部分组成。我使用以下标签骨架搭建出这一结构：

```html
<div class="ui">
  <nav class="navbar app">...</nav>
  <nav class="navbar board">...</nav>
  <div class="lists">
    <div class="list">
      <header>...</header>
      <ul>
        <li>...</li>
        ...
        <li>...</li>
      </ul>
      <footer>...</footer>
    </div>
  </div>
</div>
```

这个布局将通过 CSS 栅格实现。确切地说是 3×1 栅格（就是指一列三行）。第一行用于 app 栏，第二行用于 board 栏，第三行用于 `.lists` 元素。

前两行各自有一个固定的高度，而第三行将撑起可变窗口高度的其余部分：

```css
.ui {
  height: 100vh;
  display: grid;
  grid-template-rows: $appbar-height $navbar-height 1fr;
}
```

视图单位可以确保 `.ui` 容器总是和浏览器的窗口高度一致。

一个栅格化的上下文被分配给容器，并且指定了上文说的行和列。确切地说，是只指定了行，因为声明单独的列是没有必要的。一对 Sass 变量指定了两个栏目的高度，使用 `fr` 单位指定 `.lists` 元素高度使其撑起可变窗口高度的其余部分，这样每行的大小就设定完成了。

## 卡片列表部分

如上所述，屏幕栅格的第三行托管着卡片列表的容器。这是标签的轮廓：

```html
<div class="lists">
  <div class="list">
    ...
  </div>
  ...
  <div class="list">
    ...
  </div>
</div>
```

我用一个满屏宽的 Flexbox 单行行容器来格式化列表：

```
.lists {
  display: flex;
  overflow-x: auto;
  > * {
    flex: 0 0 auto; // 'rigid' lists
    margin-left: $gap;
  }
  &::after {
    content: '';
    flex: 0 0 $gap;
  }
}
```

给 `overflow-x` 指定 auto 值，当列表不适合视口提供的宽度时，浏览器会在屏幕底部显示一个水平滚动条。

`flex` 简写属性用于 flex item 使列表更严格。`flex-basis` （简写的方式使用）的 auto 值指示布局引擎从 `.list` 元素的宽度属性取值，`flex-grow` 和 `flex-shrink` 的 0 值可以防止宽度的改变。

接下来我将在列表之间添加一个水平分隔。如果给列表设置右间距，当水平溢出时看板上最后一个列表之后的间距不会被渲染。为了解决这个问题，列表被一个左间距分隔并且最后一个列表和窗口右边缘的间距通过给每个 `.lists` 元素添加一个伪元素 `::after` 来实现。默认值 `flex-shrink: 1` 一定要被重写，否则这个伪元素会”吸收“所有的负空间，然后消失。

注意在 Firefox < 54 的版本上要给 `.lists` 指定 `width: 100%` 以确保正确的布局渲染。

## 卡片列表

每个卡片列表由一个 header 栏、一个卡片序列和一个 footer 栏目组成。以下 HTML 代码段实现了这一结构：

```html
<div class="list">
  <header>List header</header>
  <ul>
    <li>...</li>
    ...
    <li>...</li>
  </ul>
  <footer>Add a card...</footer>
</div>
```

这里的关键任务是如何管理列表的高度。header 和 footer 有固定的高度(未必相等)。然后有一些不定数量的卡片，每个卡片都有不定量的内容。因此随着卡片的添加和移除，这个列表也会增大和缩小。

但是高度不能无限增大，它需要有一个取决于 `.lists` 元素高度的上限。一旦突破上线，我想有一个垂直滚动条出现来允许访问溢出列表的卡片。

这听起来是 `max-height` 和 `overflow` 属性能做的。但如果根容器 `.list` 提供了这些属性，一旦列表达到了它的最大高度，所有的 `.list` 元素包括 header 和 footer 在内都会出现滚动条。下图左右两边分别显示错误的和正确的侧边条：

![](https://dab1nmslvvntp.cloudfront.net/wp-content/uploads/2017/08/1503994870wrong-right-sidebars.jpg)

因此，让我们把 `max-height` 约束给内部的 `<ul>`。应该提供什么值呢？header 和 footer 的高度必须从列表父容器(`.lists`)的高度之中扣除：

```
ul {
  max-height: calc(100% - #{$list-header-height} - #{$list-footer-height});
}
```

但还有一个问题。百分比数值并不参照 `.lists` 而是参照 `<ul>` 元素的父元素  `.list`，并且这个元素没有定义高度，因此这个百分比不能确定。这个问题可以通过设置 `.list` 和 `.lists` 同样高度来解决：

```
.list {
  height: 100%;
}
```

这样，既然 `.list` 和 `.lists` 总是一样高，它的 `background-color` 属性不能用于列表背景色，但可以使用它的子元素（header, footer 和卡片）来实现这一目的。

最后一个 list 高度的调整很有必要，可用来计算列表底部和窗口底部的一点空间（`$gap`）。

```
.list {
  height: calc(100% - #{$gap} - #{$scrollbar-thickness});
}
```

还有一个 `$scrollbar-thickness` 需要被减去，防止列表触及 `.list` 元素的水平滚动条。 事实上这个滚动条”增长“在 `.lists` 盒子内部。也就是说，100% 这个值是指包括滚动条在内的 `.lists` 的高度。

而在火狐中，这个滚动条被”附加“给 `.lists` 高度的外部，就是说 `.lists` 高度的 100% 并不包含滚动条。所以这个减法就没什么必要了。结果是当滚动条可见时，在火狐中已经触及最大高度的底部边框和滚动条的顶部之间的可视空间会稍大一些。

这是这个组件相应的 CSS 规则：

```css
.list {
  width: $list-width;
  height: calc(100% - #{$gap} - #{$scrollbar-thickness});

  > * {
    background-color: $list-bg-color;
    color: #333;
    padding: 0 $gap;
  }

  header {
    line-height: $list-header-height;
    font-size: 16px;
    font-weight: bold;
    border-top-left-radius: $list-border-radius;
    border-top-right-radius: $list-border-radius;
  }

  footer {
    line-height: $list-footer-height;
    border-bottom-left-radius: $list-border-radius;
    border-bottom-right-radius: $list-border-radius;
    color: #888;
  }

  ul {
    list-style: none;
    margin: 0;
    max-height: calc(100% - #{$list-header-height} - #{$list-footer-height});
    overflow-y: auto;
  }
}
```

如上所述，列表背景色通过给每一个 `.list` 元素的子元素的 `background-color` 属性指定 `$list-bg-color` 值而被渲染。`overflow-y` 使得卡片滚动条只有按需显示。最后，给 header 和 footer 添加一些简单的样式。

## 完成收尾

单个卡片包含的一个列表元素 HTML：

```
<li>Lorem ipsum dolor sit amet, consectetur adipiscing elit</li>
```

卡片也有可能包含一个封面图片：

```html
<li>
  <img src="..." alt="...">
  Lorem ipsum dolor sit amet
</li>
```

这是相应的样式：

```css
li {
  background-color: #fff;
  padding: $gap;

  &:not(:last-child) {
    margin-bottom: $gap;
  }

  border-radius: $card-border-radius;
  box-shadow: 0 1px 1px rgba(0,0,0, 0.1);

  img {
    display: block;
    width: calc(100% + 2 * #{$gap});
    margin: -$gap 0 $gap (-$gap);
    border-top-left-radius: $card-border-radius;
    border-top-right-radius: $card-border-radius;
  }
}
```

设置完一个背景、填充、和底部间距就差背景图片的布局了。这个图片宽度一定是跨越整个卡片的，从左填充的边缘到右填充的边缘：

```
width: calc(100% + 2 * #{$gap});
```

然后，指定负边距以使图片水平和垂直对齐：


```
margin: -$gap 0 $gap (-$gap);
```

第三个正边距的值用于指定封面图片和文字之间的空间。

最后我给占据屏幕布局第一行的两条添加了一个 flex 格式化上下文，但它们只是草图。通过[扩展 demo](https://codepen.io/SitePoint/pen/brmXRX?editors=0100) 自由构建你自己的实现吧。

## 总结

这只是实现这种设计的一种可行方法，如果能看见其他方式那一定很有趣。此外，如果能完成整个布局那就更好了，比如完成最后的两个栏目。

另一个潜在的改进是能够为卡片列表实现自定义的滚动条。

所以，[fork 这个 demo](https://codepen.io/SitePoint/pen/brmXRX?editors=0100) 尽情发挥吧，记得在下面的讨论区留下你的链接哦。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
