> * 原文地址：[What Happens When You Create A Flexbox Flex Container?](https://www.smashingmagazine.com/2018/08/flexbox-display-flex-container/)
> * 原文作者：[Rachel Andrew](https://www.smashingmagazine.com/author/rachel-andrew)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/flexbox-display-flex-container.md](https://github.com/xitu/gold-miner/blob/master/TODO1/flexbox-display-flex-container.md)
> * 译者：[linxuesia](https://github.com/linxuesia)
> * 校对者：

# What Happens When You Create A Flexbox Flex Container?
# 当你创建 Flexbox 布局时，都发生了什么

**快速简介：** 在我的理想世界里，CSS Grid 和 Flexbox 一起出现，完整的构成网络布局系统。然而，我们先有了 Flexbox 属性，因为它比浮动(floats)更适合用来做栅格式布局，所以出现了很多以 Flexbox 为基础的栅格布局系统。事实上，很多人觉得 Flexbox 令人困扰或者难以理解，正是因为尝试把它作为栅格布局的方法。

在接下来的一系列文章里面，我会花一点时间来结构 Flexbox - 以之前我用来理解 grid 属性的方式。我们一起看看 Flexbox 设计是为了什么，它擅长处理什么，以及你为什么不选择它作为布局的方法。在这篇文章中，我们会详细看一下，当你在样式表添加`display: flex`的时候，究竟会发生什么。

### 一个 Flex 容器，拜托了！

为了使用 Flexbox 布局，你需要一个元素作为 flex 容器，在 CSS 中，使用`display: flex`:

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

查看这个例子 [Smashing Flexbox Series 1: display: flex;](https://codepen.io/rachelandrew/pen/PBRGQO) ，作者 Rachel Andrew ([@rachelandrew](https://codepen.io/rachelandrew)) 在 [CodePen](https://codepen.io) 上.

让我们花一点点时间来思考一下到底`display: flex`意味着什么。在[显示模式第三级](https://www.w3.org/TR/css-display-3/)中, display 的每一个值都由两个部分构成：内部显示模式和外部显示模式。当我们添加`display: flex`时，我们其实定义的是`display: block flex`。外部的 flex 容器是块级显示（`block`），它在文档流中以正常的块级元素来显示。内部显示模式是`flex`，所以在容器内部的直接子元素按照弹性布局来排列。

这些事情你可能之前从未想过，但是还是能够理解。flex 容器在页面中就像其他块状元素一样表现。如果你在 flex 容器后面紧跟一个段落，它们两个都会表现为正常的块状元素。

我们也可以把容器的属性设置为`inline-flex`,就和设置成`display:inline flex`一样，这就是说，flex 容器表现为普通行内元素，其子元素参与 flex 布局。在 flex 容器内的子元素就和块级 flex 容器内的子元素表现一样，不同之处就在于容器本身在整体布局中的表现。

HTML:

```html
<div class="container">
  <div class="item">1</div>
  <div class="item">2</div>
  <div class="item">3</div>
</div>

<em>The flex container is inline, so another inline element will display next to it.</em>
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

查看这个例子 [Smashing Flexbox Series 1: display: inline-flex;](https://codepen.io/rachelandrew/pen/YjaGvZ) ，作者 Rachel Andrew ([@rachelandrew](https://codepen.io/rachelandrew)) 在 [CodePen](https://codepen.io)上.

元素具有这种外部显示模式的概念，它定义了元素以单独一个盒模型的方式在在页面中如何表现（包括一个内部显示模式），对于预示它的子元素的表现也非常有用。你可以把这种思考应用于任何 CSS 定义的盒模型。这个元素将会如何表现？它的子元素又会怎样表现？这些问题的答案就与它们的内部显示模式和外部显示模式有关。

### 行或者列？

一旦我们定义了 flex 容器之后，一些初始值就开始发挥作用了。在我们没有添加任何其他属性的情况下，flex 子项目会按照行来排列。这是因为`flex-direction`属性的初始值就是`row`。如果你不对它进行设置，它就会显示成行。
`flex-direction`属性它是用来设置主轴的排列方向，这个属性还有其他的值：

*   `column`
*   `row-reverse`
*   `column-reverse`

将我们的子项目排列起来，子项目从内联维度的起始边缘的第一个项目开始排列，并且按照它们在文档中的顺序来排列。在规范中，这个边缘就被叫做`flex-start`。

[![main-start 是一行的开始](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/ab7497e5-90a0-4073-bc37-12842297a090/row-main-start.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/ab7497e5-90a0-4073-bc37-12842297a090/row-main-start.png)

`main-start` 是行内维度的起始位置 ([Large preview](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/ab7497e5-90a0-4073-bc37-12842297a090/row-main-start.png))

如果我么使用`column`属性，子项目从块级维度的起始位置开始排列，因此构成一列。

[![子项目按照列来排列，main-start 位于顶部](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/480a9d24-8038-4946-aa9b-752d580df4db/column-main-start.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/480a9d24-8038-4946-aa9b-752d580df4db/column-main-start.png)

`main-start` 是块级维度的起始位置 ([Large preview](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/480a9d24-8038-4946-aa9b-752d580df4db/column-main-start.png))

当我们使用`row-reverse`时，`main-start`和`main-end`的位置互换了，因此，子项目也会相应的按照相反的顺序来排列。

[![子项目从行的末尾开始排列](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/2a1852ed-c713-49b8-93ca-b9e295b4b8ff/row-reverse-main-start.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/2a1852ed-c713-49b8-93ca-b9e295b4b8ff/row-reverse-main-start.png)

`main-start` 在内联维度的末尾 ([Large preview](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/2a1852ed-c713-49b8-93ca-b9e295b4b8ff/row-reverse-main-start.png))

`column-reverse`也是一样的。有件很重要的事情需要记住，那就是这些值并不会改变子项目的顺序，尽管它们看起来是这样的效果，它们改变的是这些子项目开始排列的位置：通过改变`main-start`来达到目的。所以我们的子项目会按照相反的方向来排列，这仅仅是因为它是从容器的结束位置开始排列的。

另外还有一件很重要的事情要记住，当它发生时，这仅仅是视觉上的，我们要求子项目从结束位置开始排列。它们在文档中仍然是原来的顺序，当你使用屏幕阅读器的时候仍旧可以通过 Tab 键来索引。当你真的想要改变子元素的顺序的时候，你不应该使用`row-reverse`，而是直接在文档源中去改变。

### Flexbox 的两根轴线

我们已经揭露了 flexbox 的一个重要特性：能够将主轴从行切换为列。这种轴的切换，就是为什么我常常认为网格布局中的对齐更容易理解的原因。在网格布局中，从两个维度出发，你都可以使用几乎相同的方式在两个轴上对齐。对于弹性布局来说会更麻烦点，因为在主轴和交叉轴上子项目的表现是不太相同的。

我们已经了解了主轴，也就是说，你用`flex-direction`属性的值来定义的那根轴线。交叉轴则是另外一个维度。如果你设置`flex-direction: row`，你的主轴是沿着行的方向，你的交叉轴是沿着列的方向。如果是`flex-direction: column`，主轴是沿着列的方向，交叉轴是沿着行的方向。在这里我们就需要讨论 flexbox 的另外一个重要特点，那就是它与屏幕的物理方向无关。我们不讨论从左到右方向的行，或从上到下方向的列，因为情况并非总是如此。

#### 书写模式

当我在上文中形容行和列的时候，我提到了块级和行内的维度 _dimensions_ 。这篇文章是用英文写的，它是水平的书写模式。这就意味着当你要 Flexbox 为你提供一行时，子项目会水平的展示。在这个例子中，`main-start`是在左边 - 也就是英文中句子开始的位置。

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

查看这个例子 [Smashing Flexbox Series 1: row with rtl text](https://codepen.io/rachelandrew/pen/JBLEdZ) ，作者 Rachel Andrew ([@rachelandrew](https://codepen.io/rachelandrew)) 在 [CodePen](https://codepen.io)上。

flexbox 的初始值意味着，如果我所做的只是创建一个flex容器，我的子项目将会从右侧开始显示，并且向左移动。 **内联方向的起始位置是你用正在使用的书写模式句子开始的位置**。

如果你恰好使用的是垂直书写模式并且要求行，那么你的行将会垂直排列，因为这就是垂直书写方式语言排列行的方式。你可以尝试为 flex 容器设置`writing-mode`属性，并把值设置为`vertical-lr`。现在，你再把`flex-direction`设置为行，子项目就会按照垂直的列来排布了。

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

查看这个例子 [Smashing Flexbox Series 1: row with a vertical writing mode](https://codepen.io/rachelandrew/pen/oMqBXa) ，作者 Rachel Andrew ([@rachelandrew](https://codepen.io/rachelandrew)) 在 [CodePen](https://codepen.io)上。

所以，一行可以水平的运行，`main-start`在左侧或者右侧，也可以垂直运行，`main-start`在顶部。即使我们的脑袋习惯了横向文本，很难想象一行垂直运行，但它的`flex-direction`属性的值仍然是`row`！

为了让子项目以块级排列，我们可以把`flex-direction`的值设置成`column`或者`column-reverse`。在英语（或者阿拉伯语）里，我们会看到子项目从容器的顶部开始显示。

在垂直书写模式中，块级维度在页面上运行，因为这是块级元素在这些模式中的排列方向。如果你将一列设置为为`vertical-lr`，你的块级元素会从左到右来垂直排列。

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

查看这个例子 [Smashing Flexbox Series 1: column in vertical-lr writing mode](https://codepen.io/rachelandrew/pen/yqKgeb) ，作者 Rachel Andrew ([@rachelandrew](https://codepen.io/rachelandrew)) 在 [CodePen](https://codepen.io)上。

但是，不管块级元素怎么显示，只要你使用的是`column`方向，那么你就是在块级维度之中。

了解一行或者一列能够在不同的物理方向上运行，有助于我们理解网格布局和弹性布局中的一些术语。我们并不会使用‘左和右’、‘上和下’这样的方向，因为在网格布局和弹性布局中，我们并不会指定文档的书写模式。现在所有的 CSS 都变的更注重书写模式了。如果你也对一些能够使其他 CSS 表现相同的值和属性感兴趣的话，可以读一下我的这片文章 有逻辑的属性和值 [Logical Properties and Values](https://www.smashingmagazine.com/2018/03/understanding-logical-properties-values/)。

总结一下，记住：

*   **flex-direction: row**

    *   主轴 = 行内维度
    *   `main-start` 位于当前书写模式下句子开头的位置
    *   交叉轴 = 块级维度
*   **flex-direction: column**

    *   主轴 = 块级维度
    *   `main-start` 位于当前书写模式下块级元素的开头位置
    *   交叉轴 = 行内维度

### Initial Alignment

当我们设置`display: flex`时，还有一些事情发生。初始的对齐方式会被应用。在接下来的一系列文章中，我们会好好地了解一下对齐方式。但是，在我们探索`display: flex`的时候，我们应该看一下被应用的初始值。

**注意**：_值得注意的是，尽管这些对齐属性始于 Flexbox 规范，子项目的对齐规范会最终取代容器上定义的对齐规范，如[flexbox 规范](https://www.w3.org/TR/css-flexbox-1/#alignment)中所述。_

#### 主轴对齐方式

`justify-content`属性的初始值是`flex-start`，就像我们的 CSS 写的那样：

```
.container {
    display: flex;
    justify-content: flex-start;
}
```

这就是我们的 flex 子项目在 flex 容器的起始位置开始排列的原因。这也是为什么当我们设置`row-reverse`时，它们切换到结束位置开始排列的原因，因为那条边成为主轴的起点。

当你看见对齐属性以`justify-`开头时，这个属性就是作用于主轴的。所以`justify-content`属性规定主轴的对齐方式，并将子项目从起始位置对齐。

`justify-content`还有其他的值：

*   `flex-end`
*   `center`
*   `space-around`
*   `space-between`
*   `space-evenly` (在块级对齐方式中添加)

这些值用来处理 flex 容器中剩余空间的分布。它们决定了子项目之间的间隔和移动。如果你添加属性`justify-content: space-between`，剩余空间被平均分配给子项目。当然，这只有在容器有剩余空间的情况下才会发生。如果你的 flex 容器被全部充满了（子项目排布完后，没有任何剩余空间），那么`justify-content`属性不会有任何作用。

你可以把`flex-direction`设置成`column`。flex 容器没有高度的情况下不会有剩余空间，所以设置`justify-content: space-between`不会发生变化。如果你把容器设置成比展示所需要的高度更高的话，那么这个属性就会发挥作用了：

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

查看这个例子 [Smashing Flexbox Series 1: column with a height](https://codepen.io/rachelandrew/pen/wxmgrW) ，作者 Rachel Andrew ([@rachelandrew](https://codepen.io/rachelandrew)) 在 [CodePen](https://codepen.io)上.

#### 交叉轴的对齐方式

子项目在单一交叉轴的 flex 容器中也会沿交叉轴对齐。这里我们执行的对齐是子项目沿着交叉轴上相互对齐的方式。在下一个例子中，有一个子项目比其他的占据更多空间。其他的子项目会按照某种规定来拉伸到相同的高度，这个规定就是`align-items`属性，它的初始值就是`stretch`：

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

查看这个例子 [Smashing Guide to Layout: clearfix](https://codepen.io/rachelandrew/pen/GBxryJ) ，作者 Rachel Andrew ([@rachelandrew](https://codepen.io/rachelandrew)) 在 [CodePen](https://codepen.io)上.

当你在 flex 布局中看到对齐属性是以`align-`开头的，那就是交叉轴的对齐方式，`align-items`属性将子项目在沿着交叉轴方向对齐，它的其他的值包括：

*   `flex-start`
*   `flex-end`
*   `center`
*   `baseline`

如果你不想其他的子项目跟拉伸到跟最高的那一项一样高的话，设置`align-items: flex-start`，它会把子项目都沿着交叉轴的起始位置对齐。

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

查看这个例子 [Smashing Flexbox Series 1: align-items: flex-start](https://codepen.io/rachelandrew/pen/RBMKyN) ，作者 Rachel Andrew ([@rachelandrew](https://codepen.io/rachelandrew)) 在 [CodePen](https://codepen.io)上.

### flex 子项目的初始值

终于，flex 子项目也是有初始值的，它们被设置成：

*   `flex-grow: 0`
*   `flex-shrink: 1`
*   `flex-basis: auto`

这意味我们的子项目默认情况下不会自动充满剩余空间。如果`flex-grow`被设置成一个正数，才会导致子项目拉伸并占据剩余空间。

这些子项目同样可以收缩，`flex-shrink`的值默认是被设置成1。这就意味着，如果我们的 flex 容器非常小，那么其中的子元素在 overflow 属性发挥作用之前就会自动的缩小，这是一个非常敏感的属性，总的来说，我们希望子项目在容器没有足够空间去排列的情况下依然能保持在容器之内，并且不会溢出。

为了默认情况下或者最好的展示效果，`flex-basis`属性被设置成`auto`，我们会在接下来的一系列文章中好好了解这代表什么。现在，你只需要将`auto`理解为“大到足够适应容器”。你将会看到发生什么，当你的 flex 容器中一些子项目，其中的一个占据的空间更大，那么它会被分配更多的空间。

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

查看这个例子 [Smashing Flexbox Series 1: initial values of flex items](https://codepen.io/rachelandrew/pen/JBLWJo) ，作者 Rachel Andrew ([@rachelandrew](https://codepen.io/rachelandrew)) 在 [CodePen](https://codepen.io)上.

这就是弹性布局的灵活性的实例。`flex-basis`属性设置为自动，子项目没有设置尺寸，那么子项目就会有一个`max-content`的基础尺寸。这就是它们延伸之后没有任何包装的尺寸。然后，子项目按照比例来占据空间，详见以下[flexbox 规范](https://www.w3.org/TR/css-flexbox-1/#flex-flex-shrink-factor)中的说明

> “注意：分配收缩空间时，是要根据基本尺寸乘以收缩的基数。收缩的空间的比例就是子项目收缩的比例，所以比如一个小的子项目在较大的子项目明显收缩之前，是不会被收缩到没有空间的。”

较大的子项目收缩的空间更多，现在我们得到了最终的布局结果。你可以比较一下下面两个截图，都是使用的上面的例子，不同的是在第一个截图中，第三个盒子的内容尺寸较小，因此列的排布空间更均匀一些。

[![这是较大的子项目占据更多空间的例子](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/f7dfeea5-845f-406a-81fe-f1da8612ce93/shrinking-auto.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/f7dfeea5-845f-406a-81fe-f1da8612ce93/shrinking-auto.png)

弹性布局会分配给较大的子项目更多空间 ([Large preview](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/f7dfeea5-845f-406a-81fe-f1da8612ce93/shrinking-auto.png))

弹性布局正在帮助我们获得一个合理的最终结果，而不用写 CSS 的人来定义。对于一个每行有几个单词的子项目，它会为这个项目分配更多的空间来展示，而不是平均的减少空间，最终得到一个非常高的元素。这项行为正是如何正确使用弹性布局的关键。弹性布局最适用于用于沿着一条轴线排列的元素，以一种弹性和感知内容的方式。这里我简单介绍了一点细节，但在接下来的系列文章中我们会更加正确的了解这些计算机制。

### 总结

在这篇文章中，我用弹性布局的初始值来介绍当你设置`display: flex`的时候，究竟发生了什么。令人惊讶的是，当你逐步分解的时候，它的数量惊人，并且在这些属性中包含了弹性布局的核心特点。

弹性布局是非常灵活的：它尝试根据你的内容来自动的选择 - 通过收缩和拉伸达到最好的阅读效果。弹性布局是感知书写模式的：行和列的方向跟书写模式是相关联的。弹性布局通过分配空间，允许子项目在主轴上以一组的方式来对齐。它还允许子项目按照线来对齐，使得交叉轴上的项目相互关联。更重要的是，弹性布局知道你的内容有多大，并且尽量采用更好的方式来展示你的内容。在接下来的文章中，我们会更加深入的探索，思考我们什么时候用弹性布局，为什么要用弹性布局。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
