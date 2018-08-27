> * 原文地址：[A Handmade SVG Bar Chart (featuring some SVG positioning gotchas)](https://css-tricks.com/handmade-svg-bar-chart-featuring-svg-positioning-gotchas/)
* 原文作者：[Robin Rendle](https://css-tricks.com/forums/users/robinrendle/)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[cyseria](https://github.com/cyseria)
* 校对者：[phxnirvana](https://github.com/phxnirvana),[wild-flame](https://github.com/wild-flame)

# 我在手撕 SVG 条形图时踩过的定位坑

让我们来看看这周早些时候我在做一个（看似）简单的条形图的时候学到的用在 SVG 里定位元素的方法吧。

SVG 里并没有多少定位元素的方法。SVG 是一个声明式图形格式，但做一个图表它（实际上）是用绘图命令来进行定位的。所以它有很多潜在的陷阱和令人沮丧的地方，我们来慢慢分析。

我们要构建一个像下面这样的条形图表：

![](https://cdn.css-tricks.com/wp-content/uploads/2016/10/Screenshot-2016-10-20-21.57.49.png)

我可以选择用制图软件导出这张图片，再用 `<img>` 标签引入（甚至可以直接存储为 `.svg` 文件），但是这样做又有什么意义呢？比起直接用 Sketch 或 Illustrator 文件，我觉得手工制作这张图我能学到到更多的（SVG）语法。

开工，先创建一个 `svg` 标签来容纳子元素。

```
<svg width='100%' height='65px'>

</svg>
```

然后开始做两个长方形。第一个在后面作为背景，第二个在前面代表图表的具体数据：

```
<svg width='100%' height='65px'>
  <g class='bars'>
    <rect fill='#3d5599' width='100%' height='25'></rect>;
    <rect fill='#cb4d3e' width='45%' height='25'></rect>
  </g>
</svg>
```

（当没有给 `<rect>` 元素提供 `x` 和 `y` 属性的时候，它们默认是0）

在上面的样例中，我给它们添加一点动画，你可以看到第二个长方形被放在第一个长方形的上面（这像在 Sketch 中绘制了两个长方形，一个叠在另一个上方）：

查看 [Robin Rendle](http://codepen.io/robinrendle) 在 [CodePen](http://codepen.io) 创建的样例[示例代码 1](http://codepen.io/robinrendle/pen/43430fd382ab20ff426022d5c8ad4a89/)


接下来，我们添加一个标记以更容易地读取 0%，25%，50%，75% 和 100％ 这样的数据。所以需要做的是建个新的组，并为每个标记添加一个 rect 标签，看起来是这样的吧？肯定没错，但是下一秒我就遇到了一点小问题。

在 SVG 中，用 `<g>` 标签来绘制图表数据的样式，像下面这样：

```
<g class='markers'>
    <rect fill='red' x='50%' y='0' width='2' height='35'></rect>
</g>
```

看起来应该像这样：

查看 [Robin Rendle](http://codepen.io/robinrendle) 在 [CodePen](http://codepen.io) 创建的样例[示例代码 2](http://codepen.io/robinrendle/pen/e1a7d1e99ada07657cc0a98ff3652fec/)

很好！让我们添加剩下的全部标记，并更改一下它的颜色：

```
<g class='markers'>
    <rect fill='#001f3f' x='0%' y='0' width='2' height='35'></rect>
    <rect fill='#001f3f' x='25%' y='0' width='2' height='35'></rect>
    <rect fill='#001f3f' x='50%' y='0' width='2' height='35'></rect>
    <rect fill='#001f3f' x='75%' y='0' width='2' height='35'></rect>
    <rect fill='#001f3f' x='100%' y='0' width='2' height='35'></rect>
</g>
```

为每一个标记点添加一个 `rect` 标签，并添加了 fill 标签来改变它的颜色，再用 `x` 属性来定位。让我们看看他在浏览器渲染成怎样子了：

查看 [Robin Rendle](http://codepen.io/robinrendle) 在 [CodePen](http://codepen.io) 创建的样例[示例代码 3](http://codepen.io/robinrendle/pen/fb6b57b1a2572d312112b425bd8762fa/)

最后一个去哪了呢？ 嗯，我们**确实**告诉它应该被定位在 100％ 的地方，所以它实际上位于屏幕右边。 我们需要考虑它的宽度，并将它向左移动两个单位长度。有很多方法可以解决这个问题。

1.我们可以应用一个内联的变换（transform）样式将它扭转回来：

```
<rect fill='#001f3f' x='100%' y='0' width='2' height='35' transform="translate(-2, 0)"></rect>
```

2.我们可以用 CSS 来表示同样的变换：

```
    rect:last-of-type {
      transform: translateX(-2px); /* Remember this isn't really "pixels", it's a length of 2 in the SVG coordinate system */
    }
```

3.或者不用百分比，我们可以沿着 X 轴将其标记放在一个精确的地方。由于有 `viewBox` 属性的存在我们就可以知道 SVG 确切的坐标系了。在 [SVG 应用](https://abookapart.com/products/practical-svg)的第六章有提到：
> `viewBox` 是 `svg` 的一个属性，它决定了坐标系和纵横比。它有四个属性分别为 x，y，宽度和高度。



这么说来我们加上 `viewBox` 之后应该是这样的：

```
<svg viewBox='0 0 1000 65'>
  <!-- the rest of our svg code goes here -->
</svg>
```

条形图的宽度为 1000 个单位。我们的标记宽度是 2 单位。为了能在最右边缘放置最后一个标记，所以我们将它放在 998！ （1000 - 2）。 这也是我们的 x 属性：

```
<svg viewBox='0 0 1000 65'>
  ...
  <rect fill='#001f3f' x='998' y='0' width='2' height='35'></rect>
  ...
</svg>
```

这样即使我们改变它的大小，标记也还是会位于 SVG 的最右边了：

查看 [Robin Rendle](http://codepen.io/robinrendle) 在 [CodePen](http://codepen.io) 创建的样例[示例代码 4](http://codepen.io/robinrendle/pen/595f1f122c4489567ecc1dd696870ad2/)

好极了！ 我们不必在这里添加 ％ 或像素值了，因为这里使用由 `viewBox` 设置的坐标系。

排序完成后我们接着看下一个问题：在每个标记下面添加 ％ 的文本，以表示 25%，50％ 等。为了做到这一点，我们在 `<svg>` 里面创建一个新的 `<g>` 标签并添加 `<text>` 元素。

```
<g>
    <text fill='#0074d9' x='0' y='60'>0%</text>
    <text fill='#0074d9' x='25%' y='60'>25%</text>
    <text fill='#0074d9' x='50%' y='60'>50%</text>
    <text fill='#0074d9' x='75%' y='60'>75%</text>
    <text fill='#0074d9' x='100%' y='60'>100%</text>
</g>
```

我们手工在操作这些并且打算用 % 来表示 x 的数值，但是不幸的是最后看起来是这样：

查看 [Robin Rendle](http://codepen.io/robinrendle) 在 [CodePen](http://codepen.io) 创建的样例[示例代码 5](http://codepen.io/robinrendle/pen/f10b2c6e1ddfcf491a84b457da8c7bee/)

于是我们再次遇到了这个问题，最后一个元素并没有在我们预期的位置。中间标签的位置是错误的，在理想的情况下他们会在标志下面居中。在 Chris 告诉我可以用一个我没有听说过的属性 [`text-ancho`](https://developer.mozilla.org/en-US/docs/Web/SVG/Attribute/text-anchor) 之前，我本想将每个元素都放置在它正确的 x 坐标上。

有了这个属性我们可以像使用 CSS 中的 `text-align` 属性一样操纵文本。这个属性是可继承的，所以我们对 `g` 标签设置一次再指向第一个和最后一个元素就好了。

```
<g text-anchor='middle'>
  <text text-anchor='start' fill='#0074d9' x='0' y='60'>0%</text>
  <text fill='#0074d9' x='25%' y='60'>25%</text>
  <text fill='#0074d9' x='50%' y='60'>50%</text>
  <text fill='#0074d9' x='75%' y='60'>75%</text>
  <text text-anchor='end' fill='#0074d9' x='100%' y='60'>100%</text>
</g>
```

就像这样：

查看 [Robin Rendle](http://codepen.io/robinrendle) 在 [CodePen](http://codepen.io) 创建的样例[示例代码 6](http://codepen.io/robinrendle/pen/338cf7c726d85c58c16f9b07a0dd4de3/)

就是这样！稍微知道 `viewBox` 是如何工作的，以及 `x`，`y` 坐标和像 `text-anchor` 这样的属性，我们就几乎可以用 SVG 做任何事了。

通过亲手实现这些图表，使得我们能够更好的去控制它们了。不难想象我们如何使用 JavaScript ，就能实现更多的设计，控制更多的数据。

再做一点点额外的工作，我们可以加上动画让这些图表真正的脱颖而出。请尝试将鼠标悬停在此版本的图表上，例如：

查看 [Robin Rendle](http://codepen.io/robinrendle) 在 [CodePen](http://codepen.io) 创建的样例[示例代码 7](http://codepen.io/robinrendle/pen/9197c221b3032a8b78c472f9a9a799b5/)

看起来非常棒，对吧？只使用 SVG 和 CSS 也可以创造出无限可能。如果你想了解更多可以看我前阵子写的[如何使用 SVG 来做图表](https://css-tricks.com/how-to-make-charts-with-svg/)，来对此进行更深入的理解。

现在让我们开始做一些很帅的图表吧~
