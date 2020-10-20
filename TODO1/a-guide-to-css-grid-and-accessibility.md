> * 原文地址：[How to Keep Your CSS Grid Layouts Accessible](https://webdesign.tutsplus.com/articles/a-guide-to-css-grid-and-accessibility--cms-32857)
> * 原文作者：[Anna Monus](https://tutsplus.com/authors/anna-monus) 
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/a-guide-to-css-grid-and-accessibility.md](https://github.com/xitu/gold-miner/blob/master/TODO1/a-guide-to-css-grid-and-accessibility.md)
> * 译者：[EmilyQiRabbit](https://github.com/EmilyQiRabbit)
> * 校对者：[xionglong58](https://github.com/xionglong58)，[hanxiansen](https://github.com/hanxiansen)

# 如何让你的 CSS Grid 布局有良好的可访问性

CSS Grid 可以将元素放入有行和列的网格中，从而让创建二维布局成为可能。有了它，你可以自定义网格的任何形态，例如网格宽高、网格范围、或者网格之间的间隙。但是，CSS Grid 可能会有访问性不佳的问题，尤其是对于那些使用屏幕阅读器和仅使用键盘的用户。本篇教程将会帮助你避免此类问题。

## 源顺序独立性

“源顺序独立性”是 CSS Grid 强大优势之一。这意味着你不需要像使用 float 或者表格布局那样，在 HTML 中定义布局结构。你可以使用 CSS Grid 的排序和网格位置属性改变 HTML 呈现的视觉效果。

W3C 的 CSS Grid 文档中的[重排序和可访问性](https://www.w3.org/TR/css-grid-1/#source-independence)章节，将源顺序独立性定义为：

> “通过将网格布局与媒体查询相结合，开发者可以使用相同的语义标记，但是元素布局的重新排列是脱离源代码顺序而独立存在的，这样就可以同时在源代码顺序和渲染出的视觉效果两个方面实现需要的布局。”

使用 CSS Grid，你可以将逻辑顺序和视觉顺序解耦。源顺序独立性在很多时候都非常有用，但是它也有可能会破坏代码的可访问性。使用屏幕阅读器和键盘的用户都只能看到你 HTML 文件的代码逻辑顺序，但是无法看到通过 CSS Grid 创建出来的视觉顺序。

如果你的文档很简单，这通常不是什么大问题，因为这时候源代码逻辑顺序和视觉顺序基本是一致的。但是，比较复杂、不对称、零散，或者使用了其他创意布局的文件通常就会对使用屏幕阅读器或者键盘的用户造成困惑。

### 能改变视觉顺序的属性

CSS Grid 有很多可以改变文档视觉顺序的属性：

-   [`order`](https://developer.mozilla.org/en-US/docs/Web/CSS/order) —— 在 [flexbox](https://webdesign.tutsplus.com/tutorials/a-comprehensive-guide-to-flexbox-ordering-reordering--cms-31564) 和 CSS Grid 规则中都有 order 属性。它可以改变 flex 或者 grid 容器中项目的默认排序。
-   网格位置属性 —— [`grid-row-start`](https://developer.mozilla.org/en-US/docs/Web/CSS/grid-row-start)，[`grid-row-end`](https://developer.mozilla.org/en-US/docs/Web/CSS/grid-row-end)，[`grid-column-start`](https://developer.mozilla.org/en-US/docs/Web/CSS/grid-column-start)，[`grid-column-end`](https://developer.mozilla.org/en-US/docs/Web/CSS/grid-column-end)。
-   上述网格位置属性的简写 —— [`grid-row`](https://developer.mozilla.org/en-US/docs/Web/CSS/grid-row)，[`grid-column`](https://developer.mozilla.org/en-US/docs/Web/CSS/grid-column)，和 [`grid-area`](https://developer.mozilla.org/en-US/docs/Web/CSS/grid-area)（它是 `grid-row` 和 `grid-column` 的简写）。
-   [`grid-template-areas`](https://developer.mozilla.org/en-US/docs/Web/CSS/grid-template-areas) —— 指定已命名的网格区的位置。

如果你想知道更多关于网格位置属性的使用方法，可以看看我们之前关于[网格区域](https://webdesign.tutsplus.com/tutorials/css-grid-layout-using-grid-areas--cms-27264)的文章。现在，让我们看看视觉重排序是如何造成代码可访问性的问题的。

## 视觉效果与逻辑的重排序

这是一个简单的网格布局，只有几个简单的链接，所以你可以使用键盘测试代码：

```html
<div class="container">
    <div class="item-1"><a href="#">Link 1</a></div>
    <div class="item-2"><a href="#">Link 2</a></div>
    <div class="item-3"><a href="#">Link 3</a></div>
    <div class="item-4"><a href="#">Link 4</a></div>
    <div class="item-5"><a href="#">Link 5</a></div>
    <div class="item-6"><a href="#">Link 6</a></div>
</div>
```

现在我们再加入一些样式。下面的 CSS 代码将网格元素放入了三个宽度相同的列中。使用 `grid-row` 属性，第一个元素被移动到了第二行的开始。

```css
.container {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  grid-gap: 0.625rem;
}
 
.item-1 {
  grid-row: 2;
}
```

在下面这个图中，你可以看到最终的视觉效果，其中 Link 1 被加上了一些特殊样式以便突出说明。普通的用户将会首先看到 **Link 2**，但是使用屏幕阅读器的用户将会从 **Link 1** 开始，因为他们遵从的是 HTML 代码中定义的逻辑顺序。

对于纯键盘使用者，使用 tab 键浏览页面也同样困难，因为这样依旧会从 **Link 1** 开始，也就是页面的左下角（你可以自己尝试一下）。

![image](https://user-images.githubusercontent.com/5164225/56024520-c2446e00-5d42-11e9-93c5-5047bea7a6eb.png)

### 解决方案

解决方案非常简单优雅。不要改变视觉顺序，你只需要将 Link 1 移动到 HTML 文件的下面。这样，源代码顺序和视觉顺序就一致了。

```html
<div class="container">
  <div class="item-2"><a href="#">Link 2</a></div>
  <div class="item-3"><a href="#">Link 3</a></div>
  <div class="item-4"><a href="#">Link 4</a></div>
  <div class="item-1"><a href="#">Link 1</a></div>
  <div class="item-5"><a href="#">Link 5</a></div>
  <div class="item-6"><a href="#">Link 6</a></div>
</div>
```

你不需要在 CSS 中为 `.item-1` 添加任何关于 Grid 的属性。因为你也不用改变默认的源代码顺序了，那么你只需要为网格容器定义属性即可。

```css
.container {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  grid-gap: 0.625rem;
}
```

看，尽管这个例子最终结果和以前一样，现在它的可访问性更高了。使用 tab 或者屏幕阅读器都会从 Link 2 开始，逻辑上也遵循源代码顺序。

![image](https://user-images.githubusercontent.com/5164225/56024543-d0928a00-5d42-11e9-8805-dde165d25910.png)

## 如何让布局的可访问性更好

这里有几个通用的布局模版，你可以让使用 CSS Grid 重排序属性的代码可访问性更高。例如，“圣杯布局”就是这样一种模式。它包括一个头部，一个主要内容区域，一个页脚，还有两个固定宽度的侧边栏，它们俩一个在左一个在右。

左边栏布局可能会为使用屏幕阅读器的用户造成困惑。因为左边栏在源代码顺序要要比主要内容区域靠前，而它则是使用屏幕阅读器的用户最先看到的内容。但是，通常情况下，使用屏幕阅读器的用户开始阅读的位置最好是主要内容。特别是当左边栏主要包括的其实是广告，博客目录，标签云，或者其他一些不相关的内容。

CSS Grid 允许你改变 HTML 文件的源代码顺序，并将主要内容放在两个侧边栏**前面**：

```html
<div class="container">
    <header>Header</header>
    <main>Main content</main>
    <aside class="left-sidebar">Left sidebar</aside>
    <aside class="right-sidebar">Right sidebar</aside>
    <footer>Footer</footer>
</div>
```

还有一些其他可用的解决方案，来使用 CSS Grid 定义视觉顺序的改变。大部分教程都会使用命名的网格区域，并使用 `grid-template-areas` 属性对它们进行重排列。

下面的代码是最简单的解决方案，因为它只是为视觉顺序和源代码顺序不同的元素添加了几个额外的规则。CSS Grid 有优秀的自动排列功能，能够把余下的网格元素搞定。

```css
.container {
  display: grid;
  grid-template-columns: 9.375rem 1fr 9.375rem;
  grid-gap: 0.625rem;
}
header, 
footer {
  grid-column: 1 / span 3;
}
.left-sidebar {
  grid-area: 2 / 1;
}
```

这样，`grid-column` 让 `<header>` 和 `<footer>` 区域横跨整个屏幕（三列），然后 `grid-area`（`grid-row` 和 `grid-column` 的简写）固定了左边栏的位置。如下就是使用这些样式后的样子：

![image](https://user-images.githubusercontent.com/5164225/56024562-da1bf200-5d42-11e9-8680-e650a2a52351.png)

尽管圣杯布局是一个相对简单的布局，你还可以使用相同的逻辑来完成一些更复杂的布局。要始终牢记页面的哪个部分是最重要的，哪部分是使用屏幕阅读器的用户在看到其他内容之前可能最想看的。

## 语义丢失怎么办

某些情况下，CSS Grid 也会对语义造成破坏；这也是影响可访问性的一个方面。由于 `display: grid;` 布局仅被元素的直接子元素继承，网格元素的子元素其实就不是网格布局的一部分了。为了节省工作量，开发者也许认为将布局扁平化是一个不错的解决方案，所以他们就将所有希望包括在网格布局内的元素都作为网格容器的直接子元素。但是，如果一个布局被认为的扁平化了，文件的语义通常也就丢失了。

加入你想要创建一个元素展览墙（比如图片墙），在这里，元素按照网格排列并被一个头部和一个页脚包围。如下是带语义的标签写法：

```html
<section class="container">
    <header>Header</header>
    <ul>
        <li>Item 1</li>
        <li>Item 2</li>
        <li>Item 3</li>
        <li>Item 4</li>
        <li>Item 5</li>
        <li>Item 6</li>
    </ul>
    <footer>Footer</footer>
</section>
```

但是如果你想要使用 CSS Grid，`<section>` 应该作为网格容器，`<h1>`、`<h2>` 和 `<ul>` 是网格元素。但是，列表内的元素不被包括在网格内，因为他们是网格容器**子元素的子元素**。

所以，如果你想要快速的完成工作，将布局结构扁平化也许是一个不错的主意，也就是让所有的元素都作为网格容器的子元素：

```html
<section class="container">
    <header>Header</header>
    <div class="item">Item 1</div>
    <div class="item">Item 2</div>
    <div class="item">Item 3</div>
    <div class="item">Item 4</div>
    <div class="item">Item 5</div>
    <div class="item">Item 6</div>
    <footer>Footer</footer>
</section>
```

现在，你就可以很轻松地使用 CSS Grid 创建出想要的布局：

```css
.container {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    grid-gap: 0.625rem;
}
header,
footer {
    grid-column: 1 / span 3;
}
```

![image](https://user-images.githubusercontent.com/5164225/56024575-e2742d00-5d42-11e9-883e-3f015c891cb2.png)

一切**看上去**都非常好，但是文档已经丢失了它最初的语义，所以：

-   使用屏幕阅读器的用户无法知道元素之间的关系，也无法知道它们其实是列表的一部分（大部分的屏幕阅读器都会通知用户列表元素的数量）；
-   被破坏的语义也会让搜索引擎很难明白你的内容；
-   如果用户在禁用 CSS 的时候访问你的内容（例如，网速不佳的时候），在浏览页面时可能会很困惑，因为他们只看到一系列不相关的 div。

最重要的规则是，你绝对不能为了看上去好看而放弃语义。

### 解决方案

目前的解决方案通过为未排序的列表添加了 CSS 规则，创建出了嵌套的网格。

```css
.container {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    grid-gap: 0.625rem;
}
.container > * {
    grid-column: 1 / span 3;
}
ul {
    display: inherit;
    grid-template-columns: inherit;
    grid-gap: inherit;
}
```

在如下例子中，你可以看到嵌套的网格和父级网格是如何关联的。元素按照期望的样子排列出来了，但是此时，文档始终保留着它的语义。

![image](https://user-images.githubusercontent.com/5164225/56024590-ea33d180-5d42-11e9-9811-91c21aee312a.png)

## 总结

简单的 CSS Grid 布局可能不会导致可访问性的问题。但是当你想要改变视觉顺序或者创建多层网格的时候，问题就可能暴露出来。解决这些问题通常不会很麻烦，所以这样做来修复那些可访问性问题是很值得的，因为这样你能够让那些使用辅助工具的用户更易读懂你的内容。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。 
