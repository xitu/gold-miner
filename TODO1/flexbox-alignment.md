> * 原文地址：[Everything You Need To Know About Alignment In Flexbox](https://www.smashingmagazine.com/2018/08/flexbox-alignment/)
> * 原文作者：[Rachel Andrew](https://www.smashingmagazine.com/author/rachel-andrew)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/flexbox-alignment.md](https://github.com/xitu/gold-miner/blob/master/TODO1/flexbox-alignment.md)
> * 译者：[CodeMing](https://github.com/coderming)
> * 校对者：[Augustwuli](https://github.com/Augustwuli)

# 你需要知道的所有 Flexbox 排列方式

**简论：** 在这篇文章中，我们将会在探讨一些基本规则的同时谈一谈 Flexbox 的排列属性以帮助我们知道横轴和竖轴上（元素的）对齐是如何实现的。

[在这个系列的第一篇文章中](https://github.com/xitu/gold-miner/blob/master/TODO1/flexbox-display-flex-container.md)，我解释了当你把一个元素设置为 `display: flex` 时发生了什么。这次我们将会讨论下排列属性，同时也会讨论（这些属性）如何和 Flexbox 一起工作。如果你曾经对何时使用 align 属性和 justify 属性感到疑惑的话，我希望这篇文章将会让（排列的）问题变得清晰！

### Flexbox 排列方式的历史

在整个 CSS 布局的历史中，如何能恰当地在横竖两轴正确排列元素估计是 Web 设计中最难的问题了。所以当浏览器中开始出现能够在两轴恰当地排列元素和元素组的 Flexbox 排列方式时，像你我一样的广大web开发者都为之激动不已。排列方式变得简单到只需要两行 CSS 代码：

HTML:

```html
<div class="container">
  <div class="item">Item</div>
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
  height: 300px;
  width: 300px;
  justify-content: center;
  align-items: center;
}

.item {
  padding: 10px;
  background-color: rgba(111,41,97,.3);
  border: 2px solid rgba(111,41,97,.5);
}
```

可以看由 Rachel Andrew ([@rachelandrew](https://codepen.io/rachelandrew)) 创建的在 [CodePen](https://codepen.io) 上的展示：[Smashing Flexbox Series 2: center an item](https://codepen.io/rachelandrew/pen/WKLYEX) 。

你所了解的 flexbox 排列属性目前都已经完整地被收录到了 [盒子元素排列规范](https://www.w3.org/TR/css-align-3/)中了。这个规范文档详细地说明了在各种布局情况下的元素排列如何工作。这意味着我们在使用 Flexbox 排列方式或者将来在不同布局情况下都可以在 CSS Grid 中使用相同的排列属性。因此，任何新的排列都会在新的盒子元素排列规范中指出，而不是新的 Flexbox 版本。（译者注：此处是新的特性是以新的排列属性/方法来创建的，而不是更新 Flexbox 版本）

### 属性

许多人告诉我他们在使用 flexbox 的时候很难区别是应该使用以 `align-` 还是 `justify-` 开头的属性。所以你需要知道：

*   `justify-` 实现主轴上的排列方式。即排列与你的 `flex-direction` 相同的方向。
*   `align-` 实现副轴上的排列方式。即排列与你的 `flex-direction` 相垂直的方向。

在下文中，根据主轴和副轴而不是水平和垂直的方向来思考会更容易理解。（主轴和副轴）和物理方位一点关系都没有。

#### 用 `justify-content` 来排列主轴

我们将会从主轴排列来开始讨论。在主轴上，我们通过 `justify-content` 属性来实现排列。这个属性的作用对象是我们的所有 flexbox 子元素所组成的组。同时也控制着组内所有元素的间距。

默认的 `justify-content` 值是 `flex-start`。这也就是为什么你声明 `display: flex` 之后你的所有 flexbox 子元素朝着你的 flex 盒子的开始排成一行。如果你有一个值为  `row` 的 `flex-direction` 属性同时页面是从左到右读的语言（例如英语）的话，这些字元素将会从左边开始排列。

[![The items are all lined up in a row starting on the left](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/67648629-b445-429f-9fd4-0fb47b7875ef/justify-content-flex-start.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/67648629-b445-429f-9fd4-0fb47b7875ef/justify-content-flex-start.png) 

子元素从盒子的开始排列（[放大预览](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/67648629-b445-429f-9fd4-0fb47b7875ef/justify-content-flex-start.png))

记住 `justify-content` 只会在 **盒子有剩余空间可以分配时** 发挥作用。所以如果你的子元素占满了主轴的空间的话， `justify-content` 将不会产生任何作用。

[![The container is filled with the items](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/064418da-c45c-4fbf-9b4e-65c481c05c00/justify-content-no-space.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/064418da-c45c-4fbf-9b4e-65c481c05c00/justify-content-no-space.png) 

盒子没有任何剩余空间可以分配（[放大预览](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/67648629-b445-429f-9fd4-0fb47b7875ef/justify-content-flex-start.png)）

如果将 `justify-content` 设置为 `flex-end` 的话，所有的元素将会移动到 flex 盒子的结束排成一行。空闲空间将会被移到 flex 盒子的开始之处。

[![The items are displayed in a row starting at the end of the container — on the right](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/262c2132-a9bf-4c6c-90cd-4ec445c9f3e1/justify-content-flex-end.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/262c2132-a9bf-4c6c-90cd-4ec445c9f3e1/justify-content-flex-end.png) 

子元素从盒子的结束排列（[放大预览](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/262c2132-a9bf-4c6c-90cd-4ec445c9f3e1/justify-content-flex-end.png)）

我们可以对这些剩余的区域做其他事情。我们可以通过`justify-content: space-between`来让它分布在 flex 盒子的两个子元素之间。在这种情况下，最前和最后的两个子元素会贴着容器，同时所有的空间将会被平均分配在每一个子元素之间。

[![Items lined up left and right with equal space between them](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/e0df6bac-5250-47d2-82ed-da66306e7c95/justify-content-space-between.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/e0df6bac-5250-47d2-82ed-da66306e7c95/justify-content-space-between.png) 

剩余空间分配在子元素之间（[放大预览](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/e0df6bac-5250-47d2-82ed-da66306e7c95/justify-content-space-between.png)）

我们也可以通过使用 `justify-content: space-around` 将这些空间环绕着 flex 盒子的子元素。在这种情况下，子元素将会均匀地分布在容器中，同时可用空间也会被这些元素分享。

[![Items spaced out with even amounts of space on each side](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/acab1663-6d66-4d98-9d1c-2f2b98911bbe/justify-content-space-around.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/acab1663-6d66-4d98-9d1c-2f2b98911bbe/justify-content-space-around.png) 

子元素的两侧都有空间（[放大预览(https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/acab1663-6d66-4d98-9d1c-2f2b98911bbe/justify-content-space-around.png)）

在盒子排列规范中可以找到一个 `justify-content`的更新的值，它没有出现在 Flexbox 的规范中。它的值是`space-evenly`。在这种情况下，子元素会均匀分布在容器内，同时额外的空间将会被子元素的两侧所分享

[![Items with equal amounts of space between and on each end](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/b8960c00-dd71-4147-bd7a-7a32bc98f08a/justify-content-space-evenly.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/b8960c00-dd71-4147-bd7a-7a32bc98f08a/justify-content-space-evenly.png) 

元素均匀地分布在容器内（[放大预览](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/b8960c00-dd71-4147-bd7a-7a32bc98f08a/justify-content-space-evenly.png)）

你可以在 demo 中尝试一下：

HTML:

```html
<div class="controls">
<select id="justifyMe">
  <option value="flex-start">flex-start</option>
  <option value="flex-end">flex-end</option>
  <option value="center">center</option>
  <option value="space-around">space-around</option>
  <option value="space-between">space-between</option>
  <option value="space-evenly">space-evenly</option>
</select>

</div>

<div class="container" id="container">
  <div class="item">One</div>
  <div class="item">Two Two</div>
  <div class="item">Three Three Three</div>
  
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

.controls {
  background-color: rgba(0,0,0,.1);
  padding: 10px;
  border-radius: .5em;
  border: 1px solid rgba(0,0,0,.2);
  margin: 0 0 2em 0
}

.controls select {
  font-size: .9em;
}
```

JavaScript:

```js
var justify = document.getElementById("justifyMe");
justifyMe.addEventListener("change", function (evt) {
  document.getElementById("container").style.justifyContent = evt.target.value;
});
```

可以看由 Rachel Andrew ([@rachelandrew](https://codepen.io/rachelandrew)) 创建的在 [CodePen](https://codepen.io) 上的展示：[Smashing Flexbox Series 2: justify-content with flex-direction: row](https://codepen.io/rachelandrew/pen/Owraaj)

这些值同样会在你的 `flex-direction` 为 `column` 生效。你可能没有额外的空间来分配一个列，但你可以通过添加 height 属性或者是改变 flex 容器的大小来解决这个问题。就像下面这个 demo 一样。

HTML:

```html
<div class="controls">
<select id="justifyMe">
  <option value="flex-start">flex-start</option>
  <option value="flex-end">flex-end</option>
  <option value="center">center</option>
  <option value="space-around">space-around</option>
  <option value="space-between">space-between</option>
  <option value="space-evenly">space-evenly</option>
</select>

</div>

<div class="container" id="container">
  <div class="item">One</div>
  <div class="item">Two Two</div>
  <div class="item">Three Three Three</div>
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
  height: 60vh;
}

.item {
  padding: 10px;
  background-color: rgba(111,41,97,.3);
  border: 2px solid rgba(111,41,97,.5);
}

.controls {
  background-color: rgba(0,0,0,.1);
  padding: 10px;
  border-radius: .5em;
  border: 1px solid rgba(0,0,0,.2);
  margin: 0 0 2em 0
}

.controls select {
  font-size: .9em;
}
```

JavaScript:

```js
var justify = document.getElementById("justifyMe");
justifyMe.addEventListener("change", function (evt) {
  document.getElementById("container").style.justifyContent = evt.target.value;
});
```

可以看由 Rachel Andrew ([@rachelandrew](https://codepen.io/rachelandrew)) 创建的在 [CodePen](https://codepen.io) 上的展示：[Smashing Flexbox Series 2: justify-content with flex-direction: column](https://codepen.io/rachelandrew/pen/zLyMyV)

#### 用 `align-content` 来排列副轴

如果你给你的 flex 容器添加了 `flex-wrap: wrap` 同时也有好几条 flex 排列行，那你可以用 `align-content` 属性来在副轴上排列你的 flex 排列行。不过，这将会需要副轴上有额外的空间。在下面这个 demo 中，我的副轴作为竖直的列在运行，同时我设置了这个 flex 容器的高度为 `60vh`。由于这个高度比我展示 flex 子元素所需的高度大，所以我的容器有了副轴方向上的空余空间。

我可以使用下面所有的 `align-content` 属性值：

HTML:

```html
<div class="controls">
<select id="alignMe">
  <option value="stretch">stretch</option>
  <option value="flex-start">flex-start</option>
  <option value="flex-end">flex-end</option>
  <option value="center">center</option>
  <option value="space-around">space-around</option>
  <option value="space-between">space-between</option>
  <option value="space-evenly">space-evenly</option>
</select>

</div>

<div class="container" id="container">
  <div class="item">One</div>
  <div class="item">Two Two</div>
  <div class="item">Three Three Three</div>
  <div class="item">Four Four Four Four</div>
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
  max-width: 400px;
  height: 60vh;
  display: flex;
  flex-wrap: wrap;
}

.item {
  padding: 10px;
  background-color: rgba(111,41,97,.3);
  border: 2px solid rgba(111,41,97,.5);
}

.controls {
  background-color: rgba(0,0,0,.1);
  padding: 10px;
  border-radius: .5em;
  border: 1px solid rgba(0,0,0,.2);
  margin: 0 0 2em 0
}

.controls select {
  font-size: .9em;
}
```

JavaScript:

```js
var align = document.getElementById("alignMe");
alignMe.addEventListener("change", function (evt) {
  document.getElementById("container").style.alignContent = evt.target.value;
});
```

可以看由 Rachel Andrew ([@rachelandrew](https://codepen.io/rachelandrew)) 创建的在 [CodePen](https://codepen.io) 上的展示：[Smashing Flexbox Series 2: align-content with flex-direction: row](https://codepen.io/rachelandrew/pen/pZqqMJ)

如果我的 `flex-direction` 值为 `column` 的话，那 `align-content` 属性将像下面这个例子一样运行：

HTML:

```html
<div class="controls">
<select id="alignMe">
  <option value="stretch">stretch</option>
  <option value="flex-start">flex-start</option>
  <option value="flex-end">flex-end</option>
  <option value="center">center</option>
  <option value="space-around">space-around</option>
  <option value="space-between">space-between</option>
  <option value="space-evenly">space-evenly</option>
</select>

</div>

<div class="container" id="container">
  <div class="item">One</div>
  <div class="item">Two Two</div>
  <div class="item">Three Three Three</div>
  <div class="item">Four Four Four Four</div>
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
  max-width: 400px;
  height: 60vh;
  display: flex;
  flex-wrap: wrap;
  flex-direction: column;
}

.item {
  height: 20vh;
  padding: 10px;
  background-color: rgba(111,41,97,.3);
  border: 2px solid rgba(111,41,97,.5);
}

.controls {
  background-color: rgba(0,0,0,.1);
  padding: 10px;
  border-radius: .5em;
  border: 1px solid rgba(0,0,0,.2);
  margin: 0 0 2em 0
}

.controls select {
  font-size: .9em;
}
```

JacaScript:

```js
var align = document.getElementById("alignMe");
alignMe.addEventListener("change", function (evt) {
  document.getElementById("container").style.alignContent = evt.target.value;
});
```

可以看由 Rachel Andrew ([@rachelandrew](https://codepen.io/rachelandrew)) 创建的在 [CodePen](https://codepen.io) 上的展示：[Smashing Flexbox Series 2: align-content with flex-direction: column](https://codepen.io/rachelandrew/pen/MBZZNy)

正如 `justify-content` 属性一样，我们的设置作用在（子元素所组成的）子元素组中，同时空余空间被分割。

### 简写方法 `place-content` 

在盒子元素排列规范中，我们发现了一个简写方法 `place-content`。使用这个属性意味着你可以一次性设置 `justify-content` 和 `align-content`。它的第一个值是 `align-content`，第二个值是 `align-content` 。如果你仅仅设置了一个值A，那么这两个值都将设置成A，因此：

```
.container {
    place-content: space-between stretch;
}
```

和下面一样：

```
.container {
    align-content: space-between; 
    justify-content: stretch;
}
```

如果我们使用：

```
.container {
    place-content: space-between;
}
```

那将和下面一样：

```
.container {
    align-content: space-between; 
    justify-content: space-between;
}
```

#### 用 `align-items` 来排列副轴

我们现在知道，我们可以对（所有 flex 子元素所组成的）子元素组进行关于 flex 元素和 flex 排列行的操作。不过，我们希望有其它方式即通过声明元素与元素之间在数轴上的关系来操作我们的元素。你的 flex 容器有一个高度，这个高度可能是由容器内最高的子元素所决定的，就如下图一样。

[![The container height is tall enough to contain the items, the third item has more content](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/dabd13bf-bf9c-411f-86c0-d43cdfb935fe/container-height-of-item.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/dabd13bf-bf9c-411f-86c0-d43cdfb935fe/container-height-of-item.png) 

容器的高度被第三个子元素所定义（[放大预览](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/dabd13bf-bf9c-411f-86c0-d43cdfb935fe/container-height-of-item.png)）

flex 容器的高度可以通过给 flex 容器添加一个 height 属性所代替：

[![The container height is taller than needed to display the items](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/c477a442-ea29-48cf-bed9-94b75593a1b2/container-added-height.png)]((https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/c477a442-ea29-48cf-bed9-94b75593a1b2/container-added-height.png) )

容器的高度通过该容器的大小属性所定义（[放大预览](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/c477a442-ea29-48cf-bed9-94b75593a1b2/container-added-height.png)）

flex 子元素看起来都被拉伸到最高的子元素的高度的原因是 `align-items` 的初始值是 `stretch`。子元素们在副轴上被拉伸成 flex 容器在那个方向上的尺寸了。

请记住哪里出现 `align-items` 会导致困惑：如果你有一个具有多个 flex 排列行的 flex 容器，那么每一个 flex 排列行都会像一个新的 flex 容器一样，（该行的）最高的 flex 子元素将会决定哪一行的所有 flex 子元素高度。

除了设置拉伸的初始值之外，你也可以给 `align-items` 属性设置一个值 `flex-start`，在这种情况下 flex 子元素将会在容器的开始之处排列同时也不会拉伸。

[![The items are aligned to the start](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/7da24e8b-8d18-4ada-9f0e-e417e0293607/align-items-flex-start.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/7da24e8b-8d18-4ada-9f0e-e417e0293607/align-items-flex-start.png) 

flex 子元素排列在副轴的开始之处（[放大预览](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/7da24e8b-8d18-4ada-9f0e-e417e0293607/align-items-flex-start.png)）

设置值 `flex-end` 将会把它们（flex 子元素）移到副轴的结束之处。

[![Items aligned to the end of the cross axis](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/52d4c377-8c60-4336-be64-f01cb9a20833/align-items-flex-end.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/52d4c377-8c60-4336-be64-f01cb9a20833/align-items-flex-end.png) 

flex 子元素排列在副轴的结束之处（[放大预览](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/52d4c377-8c60-4336-be64-f01cb9a20833/align-items-flex-end.png)）

如果你使用值 `center` ，那 flex 子元素将会排列在副轴中央：

[![The items are centered](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/8ccb2aba-b692-4ba5-8827-1043674fc1d4/align-items-center.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/8ccb2aba-b692-4ba5-8827-1043674fc1d4/align-items-center.png) 

flex 子元素排列在副轴中央（[放大预览](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/8ccb2aba-b692-4ba5-8827-1043674fc1d4/align-items-center.png)）

我们也可以设置依据文字基准线排列。这将会确保（flex 子元素）以文字的基准线排列，而不是盒子的边框。

[![The items are aligned so their baselines match](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/6607e8bc-9f6b-43a6-9b13-24bff76068f1/align-items-baseline.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/6607e8bc-9f6b-43a6-9b13-24bff76068f1/align-items-baseline.png) 

根据文字基准线排列（[放大预览](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/6607e8bc-9f6b-43a6-9b13-24bff76068f1/align-items-baseline.png)）

你可以尝试使用这个 demo 中的值：

HTML:

```html
<div class="controls">
<select id="alignMe">
  <option value="stretch">stretch</option>
  <option value="flex-start">flex-start</option>
  <option value="flex-end">flex-end</option>
  <option value="center">center</option>
  <option value="baseline">baseline</option>
</select>

</div>

<div class="container" id="container">
  <div class="item">One</div>
  <div class="item">Two Two</div>
  <div class="item large">Three Three Three</div>
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
  height: 40vh;
}

.item {
  padding: 10px;
  background-color: rgba(111,41,97,.3);
  border: 2px solid rgba(111,41,97,.5);
}

.large {
  font-size: 150%;
}

.controls {
  background-color: rgba(0,0,0,.1);
  padding: 10px;
  border-radius: .5em;
  border: 1px solid rgba(0,0,0,.2);
  margin: 0 0 2em 0
}

.controls select {
  font-size: .9em;
}
```

JacaScript:

```js
var align = document.getElementById("alignMe");
alignMe.addEventListener("change", function (evt) {
  document.getElementById("container").style.alignItems = evt.target.value;
});
```

可以看由 Rachel Andrew ([@rachelandrew](https://codepen.io/rachelandrew)) 创建的在 [CodePen](https://codepen.io) 上的展示：[Smashing Flexbox Series 2: align-items](https://codepen.io/rachelandrew/pen/WKLBpv)

#### 使用 `align-self` 来设置单个元素的排列

`align-items` 意味着你可以一次设置所有的 flex 子元素。这个操作的真正原理是对所有的 flex 子元素一一设置其 `align-self` 值。当然你也可以任意单一的 flex 子元素设置 `align-self` 值来使其与同一个 flex 容器的其它flex 子元素不一样。

在下面的例子中，我使用了 `align-items` 属性来设置 flex 子元素组的排列方式是 `center`，但是同时也给第一个和最后一个设置了 `align-self` 属性来改变他们的排列方式。

HTML:

```html
<div class="container" id="container">
  <div class="item">One</div>
  <div class="item">Two Two</div>
  <div class="item">Three Three Three</div>
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
  height: 40vh;
  align-items: center;
}

.item {
  padding: 10px;
  background-color: rgba(111,41,97,.3);
  border: 2px solid rgba(111,41,97,.5);
}

.item:first-child {
  align-self: flex-end;
}

.item:last-child {
  align-self: stretch;
}
```

可以看由 Rachel Andrew ([@rachelandrew](https://codepen.io/rachelandrew)) 创建的在 [CodePen](https://codepen.io) 上的展示： [Smashing Flexbox Series 2: align-self](https://codepen.io/rachelandrew/pen/KBbLmz) 

### 为什么没有 `justify-self`?

一个很常见的问题是为什么不能在主轴上排列单个元素或元素组？ 为什么在主轴上没有 `-self` 排列属性？如果你认为 `justify-content` 和 `align-content` 的作用是关于空余空间分布的，那么它们没有单独的排列方法的理由就显而易见了。我们将flex 子元素作为一整个组进行处理，并以某种方式分配可用空间——在组的开头及结尾或 flex 子元素之间。

想想 `justify-content` 和 `align-content` 在 CSS Gird 布局中如何起作用也是很有帮助的。这两个属性用于描述在 gird 容器和 gird 块之间的空余空间如何分配。再次地，我们将 gird 块当作一个组，然后这些属性决定他们之间的所有额外空间。正如我们在 Gird 和 Flexbox 中展示的作用那样，我们不能指定某一个元素去做一些不一样的事情。不过，有一个方法可以实现你想要的在主轴上类似 `self` 属性的布局，那就是使用自动外边距。

#### 在主轴上使用自动外边距

如果你曾经在 CSS 中将一个块级元素居中（就像将页面主元素的容器通过将它的左右外边距设置为 `auto ` ），那么你就已经有了如何设置自动外边距的经验了。当一个外边距的值设置为 auto 时，它（外边距）会尽可能地尝试在其所指的方向上变大。在使用外边距将一个块级元素居中时，我们将其左右的外边距都设置为了 auto；它们（左右外边距）都会尽可能地占据空间于是就将块级元素挤到了中间。

在 Flexbox 中使用自动外边距来排列主轴上的单个元素或者一组元素的效果非常好。在下面的例子中，我们实现了一个共同的设计模式。我有一个使用 Flexbox 的导航栏，其子元素以行的形式排列同时使用了默认值 `justify-content: start`。我想让最后的那个子元素和其它子元素分开并展示在 flex 排列行的最后面——假设该行有足够的空间。

我定位到了那个元素并且把它的 margin-left 属性设置成了 auto。这意味着它的外边距将会尽可能地占用它左边的空间，这意味着那个子元素被推到了最右边。

HTML:

```html
<div class="container" id="container">
  <div class="item">One</div>
  <div class="item">Two Two</div>
  <div class="item push">Three Three Three</div>
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


.push {
  margin-left: auto;
}
```

可以看由 Rachel Andrew ([@rachelandrew](https://codepen.io/rachelandrew)) 创建的在 [CodePen](https://codepen.io) 上的展示： [Smashing Flexbox Series 2: alignment with auto margins](https://codepen.io/rachelandrew/pen/oMJROm) 

如果你在主轴上使用了自动外边距，那 `justify-content` 将不会有任何作用，因为自动外边距将会占据所有之前用在 `justify-content` 上的空间。

### 回退排列

每一个排列方法详细来说都会有一个回退排列，它会说明在你请求的排列方式无法实现时会发生什么。举个例子，如果在你的 flex 容器中只有一个子元素但你声明了 `justify-content: space-between`，会发生什么？答案是（该属性的）回退排列 `flex-start` 会让你唯一的那个子元素排列在 flex 容器的开始之处。对于	`justify-content: space-around`，回退排列 `center` 将会被使用。

在现在的规范中你不能改变回退排列的值，所以如果你希望 `space-between` 的回退值是 `center` 而不是 `flex-start` 的话，并没有方法能实现。这是 [一份规范笔记](https://www.w3.org/TR/css-align-3/#distribution-values)，它描述了未来版本可能会支持这种方式。

### 安全和非安全的排列

最新的一个添加到盒子元素排列规范的是使用 *safe* 和 *unsafe* 关键词的关于安全和非安全的排列的概念。

看下面的代码，最后一个元素相较于容器太宽了同时是 unsafe 排列并且 flex 容器是在页面左边的，当子元素溢出界面之外时，其被裁减了。

```
.container {  
    display: flex;
    flex-direction: column;
    width: 100px;
    align-items: unsafe center;
}

.item:last-child {
    width: 200px;
}
```

[![The overflowing item is centered and partly cut off](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/54359e1a-e4e4-445a-8fcc-e4ef59591bad/unsafe-alignment.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/54359e1a-e4e4-445a-8fcc-e4ef59591bad/unsafe-alignment.png) 

不安全的排列将会按照你定义的排列但可能导致界面数据丢失（[放大预览](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/54359e1a-e4e4-445a-8fcc-e4ef59591bad/unsafe-alignment.png)）

安全的排列将会保护界面数据免于丢失，方式是通过重新移动溢出区间到其他地方：

```
.container {  
    display: flex;
    flex-direction: column;
    width: 100px;
    align-items: safe center;
}

.item:last-child {
    width: 200px;
}
```

[![The overflowing item overflows to the right](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/7e31128f-cc18-430d-aa06-9a5307021d0c/safe-alignment.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/7e31128f-cc18-430d-aa06-9a5307021d0c/safe-alignment.png) 

安全的排列会尝试避免数据丢失（[放大预览](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/7e31128f-cc18-430d-aa06-9a5307021d0c/safe-alignment.png)）

这些关键词现在还很少有浏览器支持（译者注：自测 Chrome 69 已支持），不过，它展示了在盒子元素排列规范中带给了 Flexbox 额外的控制方式。

HTML:

```html
<div class="container" id="container">
  <div class="item">One</div>
  <div class="item">Two Two</div>
  <div class="item">Three Three Three</div>
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
  width: 100px;
  align-items: safe center;
}

.item {
  padding: 10px;
  background-color: rgba(111,41,97,.3);
  border: 2px solid rgba(111,41,97,.5);
}

.item:last-child {
  width: 200px;
}
```

可以看由 Rachel Andrew ([@rachelandrew](https://codepen.io/rachelandrew)) 创建的在 [CodePen](https://codepen.io) 上的展示： [Smashing Flexbox Series 2: safe or unsafe alignment](https://codepen.io/rachelandrew/pen/zLyVmQ)  

### 总结

Flexbox 的排列属性最初以列表的方式出现，但是现在它们有了自己的规范同时也适用于其它的布局环境。这里是一些小知识可能帮助你如何在 Flexbox 中使用它们：

*   `justify-` 适用于主轴， `align-` 适用于副轴；
*   使用 `align-content` 和 `justify-content` 时你需要空余空间；
*   `align-content` 和 `justify-content` 属性面向的是子元素组、作用是分享空间。因此，你不能指定一个特定的子元素同时它们也没有对应 `-self` 排列属性；
*   如果你想去排列一个子元素，或者在主轴上分离出一个组，请用自动外边距实现；
*   `align-items` 属性设置了整个子元素组的所有 `align-self` 值。可以通过设置 `align-self` 属性来设置一个特定的子元素。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
