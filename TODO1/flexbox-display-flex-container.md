> * 原文地址：[What Happens When You Create A Flexbox Flex Container?](https://www.smashingmagazine.com/2018/08/flexbox-display-flex-container/)
> * 原文作者：[Rachel Andrew](https://www.smashingmagazine.com/author/rachel-andrew)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/flexbox-display-flex-container.md](https://github.com/xitu/gold-miner/blob/master/TODO1/flexbox-display-flex-container.md)
> * 译者：[linxuesia](https://github.com/linxuesia)
> * 校对者：

# 当你创建 Flexbox 布局时，都发生了什么

**快速简介：** 在我的理想世界里，CSS Grid 和 Flexbox 应当作为一个整体一起出现，才能组成完整的网页布局系统。然而，我们先有了 Flexbox 属性，因为它比浮动(floats)更适合用来做网格布局，所以出现了很多以 Flexbox 为基础的网格布局系统。事实上，很多人觉得 Flexbox 弹性布局令人困扰或者难以理解，都是因为尝试把它作为网格布局的方法。

在接下来的一系列文章里面，我会花一点时间来详细讲解 Flexbox 弹性布局 —— 以之前我用来理解 grid 属性的方式。我们一起看看 Flexbox 设计是为了什么，它擅长处理什么，以及我们为什么不选择它作为布局的方法。在这篇文章中，我们会详细看一下，当你在样式表添加 `display: flex` 的时候，究竟会发生什么。

### 一个 Flex 容器，拜托了！

为了使用 Flexbox 布局，你需要一个元素作为 flex 容器，在 CSS 中，使用 `display: flex` :

HTML:

```html
<div class="container">
  <div class="item">1</div>
  <div class="item">2</div>
  <div class="item">3</div>
</div>
```

CSS:

```css
body {
  padding: 20px;
  font: 1em Helvetica Neue, Helvetica, Arial, sans-serif;
}

* {box-sizing: border-box;}

p {
  margin: 0 0 1em 0;
}

.container {  
  border: 5px solid rgb(111,41,97);
  border-radius: .5em;
  padding: 10px;
  display: flex;
  flex-direction: row-reverse;
}

.item {
  width: 100px;
  height: 100px;
  padding: 10px;
  background-color: rgba(111,41,97,.3);
  border: 2px solid rgba(111,41,97,.5);
}
```

请看 Rachel Andrew ([@rachelandrew](https://codepen.io/rachelandrew)) 在 [CodePen](https://codepen.io) 上的这个例子：[Smashing Flexbox Series 1: display: flex;](https://codepen.io/rachelandrew/pen/PBRGQO)。

让我们花一点点时间来思考一下到底 `display: flex` 意味着什么。在 [Display Module Level 3](https://www.w3.org/TR/css-display-3/) 中, display 的每一个值都由两个部分构成：内部显示模式和外部显示模式。当我们使用 `display: flex` 时，我们其实定义的是 `display: block flex` 。 flex 容器的外部显示模式是 `block`，它在文档流中显示为正常的块级元素。内部显示模式是 `flex`，所以在容器内部的直接子元素按照弹性布局来排列。

可能你之前没仔细想过，但其实已经知道了。flex 容器在页面中和其他块级元素的表现一样。如果你在 flex 容器后面紧跟一个段落，它们两个都会表现为正常的块级元素。

我们也可以把容器的属性设置为 `inline-flex`，就和设置成 `display:inline flex` 一样。比如说有一个行内级别的 flex 容器，容器里还有一些参与 flex 布局的子元素。这个 flex 容器内的子元素的表现就和块级 flex 容器内的子元素表现一样，不同之处就在于容器本身在整体布局中的表现。

HTML:

```html
<div class="container">
  <div class="item">1</div>
  <div class="item">2</div>
  <div class="item">3</div>
</div>

<em>这个 flex 容器是行内元素，所以另一个行内元素会紧跟它后面显示。</em>
```

CSS:

```css
body {
  padding: 20px;
  font: 1em Helvetica Neue, Helvetica, Arial, sans-serif;
}

* {box-sizing: border-box;}

p {
  margin: 0 0 1em 0;
}

.container {  
  border: 5px solid rgb(111,41,97);
  border-radius: .5em;
  padding: 10px;
  display: inline-flex;
}

.item {
  width: 100px;
  height: 100px;
  padding: 10px;
  background-color: rgba(111,41,97,.3);
  border: 2px solid rgba(111,41,97,.5);
}
```

请看 Rachel Andrew ([@rachelandrew](https://codepen.io/rachelandrew)) 在 [CodePen](https://codepen.io) 上的这个例子：[Smashing Flexbox Series 1: display: inline-flex;](https://codepen.io/rachelandrew/pen/YjaGvZ)。

元素的外部显示模式决定了它作为盒模型在页面中怎样显示，同时与内部显示模式一起，决定了其子元素的行为。这是一个很有用的思想。你可以把这种思想应用于任何 CSS 定义的盒模型。这个元素将会如何表现？它的子元素又会怎样表现？这些问题的答案就与它们的内部显示模式和外部显示模式有关。

### 行或者列？

一旦我们定义了 flex 容器之后，一些默认值就开始发挥作用了。在我们没有添加任何其他属性的情况下，flex 子项目（flex item）会按照行来排列。这是因为  `flex-direction` 属性的默认值就是 `row`。如果你不对它进行设置，它就会按照行的方向来显示。
`flex-direction` 属性是用来设置主轴（main axis）的排列方向，这个属性还有其他的值：

*   `column`
*   `row-reverse`
*   `column-reverse`

当子项目排成一行的时候，子项目会按照在文档中的顺序，从行内维度的起始边缘依次排列。在规范中，这个边缘就被叫做 `main-start`。

[![main-start 是一行的开始](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/ab7497e5-90a0-4073-bc37-12842297a090/row-main-start.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/ab7497e5-90a0-4073-bc37-12842297a090/row-main-start.png)

`main-start` 是行内维度的起始位置 ([Large preview](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/ab7497e5-90a0-4073-bc37-12842297a090/row-main-start.png))

如果我们使用 `column`，子项目从块级维度的起始边缘开始排列，因此构成一列。

[![子项目按照列来排列，main-start 位于顶部](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/480a9d24-8038-4946-aa9b-752d580df4db/column-main-start.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/480a9d24-8038-4946-aa9b-752d580df4db/column-main-start.png)

`main-start` 是块级维度的起始位置 ([Large preview](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/480a9d24-8038-4946-aa9b-752d580df4db/column-main-start.png))

当我们使用 `row-reverse` 时，`main-start` 和 `main-end` 的位置互换了，因此，子项目也会相应的按照相反的顺序来排列。

[![子项目从行的末尾开始排列](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/2a1852ed-c713-49b8-93ca-b9e295b4b8ff/row-reverse-main-start.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/2a1852ed-c713-49b8-93ca-b9e295b4b8ff/row-reverse-main-start.png)

`main-start` 在内联维度的末尾 ([Large preview](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/2a1852ed-c713-49b8-93ca-b9e295b4b8ff/row-reverse-main-start.png))

`column-reverse` 也具有一样的效果。另外还有一点很重要，那就是这些值并不会“改变子项目的顺序”，尽管它们看起来是这样的效果，它们改变的是这些子项目开始排列的位置：通过改变 `main-start` 来达到目的。所以我们的子项目会按照相反的方向来排列，这仅仅是因为它是从容器的结束位置开始排列的。

另外还有一件很重要的事情要记住，当排列顺序发生改变时，这仅仅是视觉上的，因为我们要求子项目从结束位置开始排列。它们在文档中仍然是原来的顺序，当你使用屏幕阅读器的时候仍然是按照源文档的顺序进行索引。如果你真的想要改变子元素的顺序，不应该使用 `row-reverse`，而是直接在文档源中去改变子项目的顺序。

### Flexbox 的两条轴线

我们已经讲解了 flexbox 的一个重要特性：能够将主轴（main axis）的方向从行切换为列。这种轴的方向切换，就是为什么我常常认为网格布局中的对齐更容易理解的原因。因为在网格布局中，在两个方向上你都可以采用几乎相同的方式来实现对齐。而对于弹性布局来说会更麻烦点，因为在主轴（main axis）和交叉轴（cross axis）上，子项目的表现是不太相同的。

我们已经了解了主轴（main axis），即你用 `flex-direction` 属性的值来定义的那根轴线。交叉轴（cross axis）则在另一个方向上。如果你设置 `flex-direction: row` ，那么你的主轴（main axis）是沿着行的方向，你的交叉轴（cross axis）是沿着列的方向。如果设置 `flex-direction: column` ，主轴(main axis)是沿着列的方向，交叉轴(cross axis)是沿着行的方向。在这里我们就需要讨论 flexbox 的另外一个重要特点，那就是它与屏幕的物理方向无关。我们不讨论从左到右方向的行，或从上到下方向的列，因为情况并非总是如此。

#### 书写模式

当我在上文中描述行和列的时候，我提到了块级和行内的维度 **dimensions**。这篇文章是用英文写的，它是水平的书写模式。这就意味着当你要 Flexbox 显示一行时，子项目会水平的展示。在这个例子中，`main-start` 位于左边 —— 也就是英文书写模式中中句子开始的位置。

如果我使用的是从右到左书写的语言，比如阿拉伯语的话，起始位置就会位于右边：

HTML:

```html
<div class="container">
  <div class="item">1</div>
  <div class="item">2</div>
  <div class="item">3</div>
</div>
```

CSS:

```css
body {
  padding: 20px;
  font: 1em Helvetica Neue, Helvetica, Arial, sans-serif;
}

* {box-sizing: border-box;}

p {
  margin: 0 0 1em 0;
}

.container {  
  border: 5px solid rgb(111,41,97);
  border-radius: .5em;
  padding: 10px;
  display: flex;
  flex-direction: row;
  direction: rtl;
}

.item {
  width: 100px;
  height: 100px;
  padding: 10px;
  background-color: rgba(111,41,97,.3);
  border: 2px solid rgba(111,41,97,.5);
}
```

请看 Rachel Andrew ([@rachelandrew](https://codepen.io/rachelandrew)) 在 [CodePen](https://codepen.io) 上的这个例子：[Smashing Flexbox Series 1: row with rtl text](https://codepen.io/rachelandrew/pen/JBLEdZ)。

flexbox 的初始值意味着，如果我所做的只是创建一个 flex 容器，我的子项目将会从右侧开始显示，并且向左排列。 **内联方向的起始位置是你正在使用的书写模式中句子开始的位置**。

如果你使用垂直书写模式并且使用的默认排列方向（这里指 flex-direction: row），此时的行就会是垂直方向的，因为这就是垂直书写方式语言排列行的方式。你可以尝试为 flex 容器设置 `writing-mode` 属性，把值设置为 `vertical-lr`。现在，你再把 `flex-direction` 设置为 `row`，子项目就会排成垂直的一列了。

HTML:

```html
<div class="container">
  <div class="item">1</div>
  <div class="item">2</div>
  <div class="item">3</div>
</div>
```

CSS:

```css
body {
  padding: 20px;
  font: 1em Helvetica Neue, Helvetica, Arial, sans-serif;
}

* {box-sizing: border-box;}

p {
  margin: 0 0 1em 0;
}

.container {  
  border: 5px solid rgb(111,41,97);
  border-radius: .5em;
  padding: 10px;
  display: flex;
  flex-direction: row;
  writing-mode: vertical-lr;
}

.item {
  width: 100px;
  height: 100px;
  padding: 10px;
  background-color: rgba(111,41,97,.3);
  border: 2px solid rgba(111,41,97,.5);
}
```

请看 Rachel Andrew ([@rachelandrew](https://codepen.io/rachelandrew)) 在 [CodePen](https://codepen.io) 上的这个例子：[Smashing Flexbox Series 1: row with a vertical writing mode](https://codepen.io/rachelandrew/pen/oMqBXa)。

所以，一行可以水平的排列，`main-start` 位于左侧或者右侧，也可以垂直排列，`main-start` 位于顶部。即使我们的思维习惯了横向排列的文本，很难想象一行垂直排列的文本，但它的 `flex-direction` 属性的值仍然是 `row` ！

为了让子项目按照块级维度进行排列，我们可以把 `flex-direction` 的值设置成 `column` 或者 `column-reverse`。在英语（或者阿拉伯语）这样的水平书写模式里，子项目会从容器顶部开始按照垂直方向排列。

在垂直书写模式中，块级方向横跨整个页面，这也是这种书写模式下块级元素的排列方向。如果你将一列设置为为 `vertical-lr` ，那么这些块级元素会从左到右进行排列（内部的文本方向仍为垂直排列）。

HTML:

```html
<div class="container">
  <div class="item">1</div>
  <div class="item">2</div>
  <div class="item">3</div>
</div>
```

CSS:

```css
body {
  padding: 20px;
  font: 1em Helvetica Neue, Helvetica, Arial, sans-serif;
}

* {box-sizing: border-box;}

p {
  margin: 0 0 1em 0;
}

.container {  
  border: 5px solid rgb(111,41,97);
  border-radius: .5em;
  padding: 10px;
  display: flex;
  flex-direction: column;
  writing-mode: vertical-lr;
}

.item {
  width: 100px;
  height: 100px;
  padding: 10px;
  background-color: rgba(111,41,97,.3);
  border: 2px solid rgba(111,41,97,.5);
}
```

请看 Rachel Andrew ([@rachelandrew](https://codepen.io/rachelandrew)) 在 [CodePen](https://codepen.io) 上的这个例子：[Smashing Flexbox Series 1: column in vertical-lr writing mode](https://codepen.io/rachelandrew/pen/yqKgeb) 。

但是，无论块级元素怎么显示，只要你使用的是 `column` 方向，那么元素始终处在块级维度之中。

了解一行或者一列能够在不同的物理方向上运行，有助于我们理解网格布局和弹性布局中的一些术语。在网格布局和弹性布局中，并不会使用『左和右』、『上和下』这样的方向，因为我们并不会指定文档的书写模式。现在所有的 CSS 都变的更注重书写模式了。如果你对其他已经支持这种方向差异的 CSS 属性和值有兴趣的话，可以读一下我的这篇文章 [Logical Properties and Values](https://www.smashingmagazine.com/2018/03/understanding-logical-properties-values/)。

总结一下，记住：

*   **flex-direction: row**

    *   主轴 = 行内维度
    *   `main-start` 位于当前书写模式下句子开头的位置
    *   交叉轴 = 块级维度
*   **flex-direction: column**

    *   主轴 = 块级维度
    *   `main-start` 位于当前书写模式下块级元素的开头位置
    *   交叉轴 = 行内维度

### 默认对齐方式

当我们设置 `display: flex` 时，还会发生一些事情，默认的对齐方式会发挥作用。在该系列的其他文章中，我们会好好地了解一下对齐方式。但是，我们现在在探索 `display: flex` 的时候，也应该看一下这些发挥作用的默认值。

**注意**：**值得注意的是，尽管这些对齐属性始于 Flexbox 规范，但 Box Alignment（盒模型对齐）会最终覆盖 Flexbox 规范的相关内容，如 [flexbox 规范](https://www.w3.org/TR/css-flexbox-1/#alignment)中所述。**

#### 主轴对齐方式

`justify-content` 属性的默认值是 `flex-start`，就像我们的 CSS 写的那样：

```
.container {
    display: flex;
    justify-content: flex-start;
}
```

这就是我们的 flex 子项目（flex item）从 flex 容器的起始边缘开始排列的原因。同样也是当我们设置 `row-reverse` 时，它们变为从结束边缘开始排列的原因，因为那个边缘变成了主轴（main axis）的起点。

当你看见对齐属性以 `justify-` 开头时，这个属性就是作用于主轴（main axis）的。也就是说 `justify-content` 属性规定主轴（main axis）的对齐方式，并将子项目从起始边缘对齐。

`justify-content` 还有其他的值：

*   `flex-end`
*   `center`
*   `space-around`
*   `space-between`
*   `space-evenly` (在块级对齐方式中添加)

这些值用来处理 flex 容器中剩余空间的分布。这就是子项目间会发生移动或者说相互分隔的原因了。如果你添加属性 `justify-content: space-between`，剩余空间被平均分配给子项目。当然，这只有在容器有剩余空间的情况下才会发生。如果你的 flex 容器被全部充满了（子项目排列完后，没有任何剩余空间），那么设置  `justify-content` 属性不会产生任何效果。

你可以把 `flex-direction` 设置成 `column`。因为 flex 容器在没有高度的情况下不会有剩余空间，所以设置 `justify-content: space-between` 不会发生变化。如果你把容器设置成比展示所需要的高度更高的话，那么这个属性就会发挥作用了：

HTML:

```html
<div class="container">
  <div class="item">1</div>
  <div class="item">2</div>
  <div class="item">3</div>
</div>
```

CSS:

```css
body {
  padding: 20px;
  font: 1em Helvetica Neue, Helvetica, Arial, sans-serif;
}

* {box-sizing: border-box;}

p {
  margin: 0 0 1em 0;
}

.container {  
  border: 5px solid rgb(111,41,97);
  border-radius: .5em;
  padding: 10px;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  height: 500px;
}

.item {
  width: 100px;
  height: 100px;
  padding: 10px;
  background-color: rgba(111,41,97,.3);
  border: 2px solid rgba(111,41,97,.5);
}
```
请看 Rachel Andrew ([@rachelandrew](https://codepen.io/rachelandrew)) 在 [CodePen](https://codepen.io) 上的这个例子：[Smashing Flexbox Series 1: column with a height](https://codepen.io/rachelandrew/pen/wxmgrW)。

#### 交叉轴的对齐方式

子项目在单一交叉轴的 flex 容器中也会沿着这根交叉轴对齐。这里执行的对齐是子项目沿着交叉轴相互对齐。在接下来的这个例子中，有一个子项目比其他项占据更高的空间，然后其他的子项目会按照某种规范来拉伸到与它相同的高度，这个规范就是 `align-items` 属性，因为它的初始值就是 `stretch`：

HTML:

```html
<div class="container">
  <div class="item">One</div>
  <div class="item">Two</div>
  <div class="item">
    <ul>
    <li>Three: a</li>
    <li>Three: b</li>
    <li>Three: c</li>
    </ul>
    </div>
</div>
```

CSS:

```css
body {
  padding: 20px;
  font: 1em Helvetica Neue, Helvetica, Arial, sans-serif;
}

* {box-sizing: border-box;}

p {
  margin: 0 0 1em 0;
}

.container {  
  border: 5px solid rgb(111,41,97);
  border-radius: .5em;
  padding: 10px;
  display: flex;
}

.item {
  padding: 10px;
  background-color: rgba(111,41,97,.3);
  border: 2px solid rgba(111,41,97,.5);
}

.item ul {
  margin: 0;
  padding: 0;
  list-style: none;
}
```
请看 Rachel Andrew ([@rachelandrew](https://codepen.io/rachelandrew)) 在 [CodePen](https://codepen.io) 上的这个例子：[Smashing Guide to Layout: clearfix](https://codepen.io/rachelandrew/pen/GBxryJ)。

当你在 flex 布局中看到有一个属性是以 `align-` 开头的，那个就是交叉轴的对齐方式，`align-items` 属性规定子项目在沿着交叉轴方向上的对齐方式，这个属性的其他的值包括：

*   `flex-start`
*   `flex-end`
*   `center`
*   `baseline`

如果你不想其他的子项目跟拉伸到跟最高的那一项一样高的话，设置 `align-items: flex-start`，它会把子项目都沿着交叉轴的起始位置对齐。

HTML:

```html
<div class="container">
  <div class="item">One</div>
  <div class="item">Two</div>
  <div class="item">
    <ul>
    <li>Three: a</li>
    <li>Three: b</li>
    <li>Three: c</li>
    </ul>
    </div>
</div>
```

CSS:

```css
body {
  padding: 20px;
  font: 1em Helvetica Neue, Helvetica, Arial, sans-serif;
}

* {box-sizing: border-box;}

p {
  margin: 0 0 1em 0;
}

.container {  
  border: 5px solid rgb(111,41,97);
  border-radius: .5em;
  padding: 10px;
  display: flex;
  align-items: flex-start;
}

.item {
  padding: 10px;
  background-color: rgba(111,41,97,.3);
  border: 2px solid rgba(111,41,97,.5);
}

.item ul {
  margin: 0;
  padding: 0;
  list-style: none;
}
```
请看 Rachel Andrew ([@rachelandrew](https://codepen.io/rachelandrew)) 在 [CodePen](https://codepen.io) 上的这个例子：[Smashing Flexbox Series 1: align-items: flex-start](https://codepen.io/rachelandrew/pen/RBMKyN)。

### flex 子项目的初始值

终于说到这里了，flex 子项目（flex item）也是有初始值的，它们包括：

*   `flex-grow: 0`
*   `flex-shrink: 1`
*   `flex-basis: auto`

这意味我们的子项目（flex item）在默认情况下不会自动充满主轴上的剩余空间。如果 `flex-grow` 被设置成一个正数，才会导致子项目拉伸并占据剩余空间。

这些子项目（flex item）同样可以收缩。默认情况下，`flex-shrink` 的值被设置成了 1。这就意味着，如果我们的 flex 容器非常小，那么其中的子元素在溢出容器之前就会自动的缩小以适应容器大小。这是一个非常灵活的属性。总的来说就是，子项目在容器没有足够空间去排列的情况下依然能保持在容器之内，并且不会溢出。

为了在默认情况下获得最好的展示效果，`flex-basis` 属性的默认值被设置成 `auto`，我们会在这个系列的其他文章中好好了解这代表什么。现在，你只需要将 `auto` 理解为『大到足够适应容器』就行了。在这种情况下，当 flex 容器中有一些子项目，其中的一个子项目相较于其他包含更多的内容，那么它会被分配更多的空间。

HTML:

```html
<div class="container">
  <div class="item">Two words</div>
  <div class="item">Now three words</div>
  <div class="item">
    This flex item has a lot of content and so it is going to need more space in the flex container.
    </div>
</div>
```

CSS:

```css
body {
  padding: 20px;
  font: 1em Helvetica Neue, Helvetica, Arial, sans-serif;
}

* {box-sizing: border-box;}

p {
  margin: 0 0 1em 0;
}

.container {  
  border: 5px solid rgb(111,41,97);
  border-radius: .5em;
  padding: 10px;
  display: flex;
  width: 400px;
}

.item {
  padding: 10px;
  background-color: rgba(111,41,97,.3);
  border: 2px solid rgba(111,41,97,.5);
}
```
请看 Rachel Andrew ([@rachelandrew](https://codepen.io/rachelandrew)) 在 [CodePen](https://codepen.io) 上的这个例子：[Smashing Flexbox Series 1: initial values of flex items](https://codepen.io/rachelandrew/pen/JBLWJo)。

上面这个例子就是弹性布局灵活性的体现。在 `flex-basis` 属性的默认值是 `auto`，并且子项目（flex item）没有设置尺寸的情况下，它就会有一个 `max-content` 的基础尺寸。这就是它根据内容自动延伸之后没有经过任何其他包装的尺寸。然后，子项目按照比例来占据剩余空间，详见以下 [flexbox 规范](https://www.w3.org/TR/css-flexbox-1/#flex-flex-shrink-factor) 中的说明。

> 『注意：分配收缩空间时，是根据基本尺寸乘以弹性收缩系数（flex shrink factor）。收缩空间的大小与子项目设置的 `flex-shrink` 的大小成比例。比如说有一个较小的子项目，在其他较大的子项目明显收缩之前，是不会被收缩到没有空间的。』

也就是说较大的子项目收缩的空间更多，那么现在我们得到了最终的布局结果。你可以比较一下下面两个截图，都是使用上面的例子，不同的是在第一个截图中，第三个盒子内容较少占据的空间较小，因此相对的每一列的占据的空间更均匀一些。

[![这是较大的子项目占据更多空间的例子](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/f7dfeea5-845f-406a-81fe-f1da8612ce93/shrinking-auto.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/f7dfeea5-845f-406a-81fe-f1da8612ce93/shrinking-auto.png)

其他项为了给较大的一项提供空间而自动收缩 ([Large preview](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/f7dfeea5-845f-406a-81fe-f1da8612ce93/shrinking-auto.png))

弹性布局会试图帮助我们获得一个合理的最终显示结果，而不需要写 CSS 的人来定义。它不会平均的减少每行的宽度，从而形成一个每行只有几个单词的很高的元素，而是会给元素更多的空间来伸展。这种表现正是如何正确弹性布局的关键。它最适用于用于沿着一条轴线排列的元素，以一种灵活和感知内容的方式。这里我简单介绍了一点细节，但在接下来的系列文章中我们会更加深入的了解这些算法。

### 总结

在这篇文章中，我用弹性布局的属性的一些默认值来介绍当你设置 `display: flex` 的时候，究竟发生了什么。令人惊讶的是，当你逐步分解之后，发现它原来有这么多内容，并且这些内容就包含了弹性布局的核心特点。

弹性布局是非常灵活的：它会根据你的内容自动地做出不错的选择 —— 通过收缩和拉伸达到最好的展示效果。弹性布局还能感知书写模式：布局中行和列的方向跟书写模式有关。弹性布局通过分配空间，允许子项目在主轴（main axis）上以整体的的方式来对齐。它还允许子项目按照交叉轴来对齐，使得交叉轴上的项目相互关联。更重要的是，弹性布局知道你的内容有多大，并且尽量采用更好的方式来展示你的内容。在接下来的文章中，我们会更加深入的探索，思考我们什么时候以及为什么要用弹性布局。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
