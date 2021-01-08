> * 原文地址：[Slide an Image to Reveal Text with CSS Animations](https://css-tricks.com/slide-an-image-to-reveal-text-with-css-animations/)
> * 原文作者：[Jesper Ekstrom](https://css-tricks.com/author/legshaker/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/slide-an-image-to-reveal-text-with-css-animations.md](https://github.com/xitu/gold-miner/blob/master/TODO1/slide-an-image-to-reveal-text-with-css-animations.md)
> * 译者：[Fengziyin1234](https://github.com/Fengziyin1234)
> * 校对者：[portandbridge](https://github.com/portandbridge), [Baddyo](https://github.com/Baddyo)

# 如何用 CSS Animations 实现滑动图片展现文字的效果

在这篇文章中，我希望能带领大家了解一下 [CSS animation property](https://css-tricks.com/almanac/properties/a/animation/)，以及详细地解释我的[个人网站](https://jesperekstrom.com/portfolio/malteser/)中的一个效果：让文字在移动的物体后出现。如果你想要看最后的成果，这里有一个[例子](https://codepen.io/jesper-ekstrom/pen/GPjGzy)。

我们将从下面这里开始：

这里请查看 [Jesper Ekstrom](https://codepen.io/jesper-ekstrom) 的 [Revealing Text Animation Part 4 - Responsive](https://codepen.io/jesper-ekstrom/pen/GPjGzy/) 案例。

即使你对这个效果不是非常感兴趣，这仍将是一个可以扩展你 CSS 知识的好练习，你可以从这个效果开始创建属于你自己的动画效果。就我而言，深入地学习研究动画，让我对自己的 CSS 能力有了更多的自信，并且让我更加有想象力，也让我对于整个前端开发都更加感兴趣了。

准备好了么？让我们一起开始吧。

## 步骤一：标记你的主元素

在我们开始制作动画效果之前，首先让我们创建一个包含了整个视口（viewport）的父元素。在这个元素中，我们在两的 div 中分别添加文字和图片，以方便之后的自定义。HTML 将如下：

```HTML
<!-- 父容器 -->
<div class="container"> 
  <!-- 包含图片的 div -->
  <div class="image-container">
  <img src="https://jesperekstrom.com/wp-content/uploads/2018/11/Wordpress-folder-purple.png" alt="wordpress-folder-icon">
  </div>
  <!-- 包含将展示的文字的 div -->
  <div class="text-container">
    <h1>Animation</h1>
  </div>
</div>
```

我们将使用一个靠谱的[转换小技巧](https://css-tricks.com/centering-percentage-widthheight-elements/)，来在的父元素中，用 position: absolute; 使两个 div 在父容器的水平和垂直方向上都居中。因为我们希望我们的图片显示在文字之前，这里我们给图片一个更大的 `z-index` 值。

```CSS
/* 父元素占据整个页面。 */
.container {
  width: 100%;
  height: 100vh;
  display: block;
  position: relative;
  overflow: hidden;
}

/* 内含图片的 div  */
/* 居中小技巧：https://css-tricks.com/centering-percentage-widthheight-elements/ */
.image-container {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%,-50%);
  z-index: 2; /* 确保图片在上 */
}

/* 第一个 div 中的图片 */
.image-container img {
  -webkit-filter: drop-shadow(-4px 5px 5px rgba(0,0,0,0.6));
  filter: drop-shadow(-4px 5px 5px rgba(0,0,0,0.6));
  height: 200px;
}

/* 包括将要被显示出来的文字的 div */
/* 同样的居中方法 */
.text-container {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%,-50%);
  z-index: 1; /* 将此 div 置于图片容器之下 */
  margin-left: -100px;
}
```

> 我们在整篇文章所有的例子中都没有保留浏览器前缀，但如果你在生产环境中使用这些效果，请务必考虑加上前缀。

现在我们的例子应该长这样，基本上来说就是图片元素在文字元素之上。

这里请查看 [Revealing Text Animation Part 1 - Mail Elements](https://codepen.io/jesper-ekstrom/pen/zMgjwj/) 案例。

## 步骤二：将文字藏在一个 div 后面

为了使我们的文字能从左到右显示，我们将在我们的 `.text-container` 中添加另一个 div。

``` HTML
<!-- ... -->

  <!-- 包括将要被显示出来的文字的 div -->
  <div class="text-container">
    <h1>Animation</h1>
    <div class="fading-effect"></div>
  </div>
  
<!-- ... -->
```

然后加入下列 CSS 属性并给其赋值：

``` CSS
.fading-effect {
  position: absolute;
  top: 0;
  bottom: 0;
  right: 0;
  width: 100%;
  background: white;
}
```

正如你所见，这个 div 的背景是白的，可以融入父元素中，而文字则藏在它后面。

如果我们试一下改改这个 div 的长度，文字就会开始出现。你可以在我们下面的例子中来尝试一下：

这里请查看 [Revealing Text Animation Part 2 - Hiding Block](https://codepen.io/jesper-ekstrom/pen/JwRZaG/)。

> 还有另外一个不需要添加额外有背景的 div 就可以达到同样效果的方法。我会在文章后面中介绍它。🙂

## 步骤三：定义 animation keyframes

下面我们将开始有趣的部分了！我们将使用 [animation property](https://css-tricks.com/almanac/properties/a/animation/) 和它的 `@keyframes` 功能来开始帮我们的目标加入动画效果。让我们先来创建两个不同的 `@keyframes`，一个给我们的图片，一个给我们的文字。代码如下：

``` CSS
/* 把图片从左侧（-250px）滑到右侧（150px）*/
@keyframes image-slide {
  0% { transform: translateX(-250px) scale(0); }
  60% { transform: translateX(-250px) scale(1); }
  90% { transform: translateX(150px) scale(1); }
  100% { transform: translateX(150px) scale(1); }  
}

/* 把目标缩小至消失（100% 到 0%）来滑动文字 */
@keyframes text-slide {
  0% { width: 100%; }
  60% { width: 100%; }
  75%{ width: 0; }
  100% { width: 0; }
}
```

> 我建议将所有的 `@keyframes` 添加到 CSS 文件的顶端，这样的文件的结构会更好，当然这只是我的个人喜好。

我只使用 `@keyframes` 很小一部分百分比值（主要是从 60% 到 100%）的原因是我选择在相同的时间段对两个物体设置动画，而不是为它们添加一个 [`animation-delay`](https://developer.mozilla.org/en-US/docs/Web/CSS/animation-delay)。这只是我的个人喜好。如果你选择和我一样的方法，一定记得要为 0% 和 100% 设值；否则，动画效果就会开始循环或者是造成一些很奇怪的结果。

为了在我们的 class 中启用 `@keyframes`，我们需要在 CSS 属性 `animation` 上调用我们的动画名称。例如，要将 `image-slide` 加入图片元素上，我们得这样做：

``` CSS
.image-container img {
  /* [动画名称] [动画时间] [动画变形方法] */
  animation: image-slide 4s cubic-bezier(.5,.5,0,1);
}
```

> `@keyframes` 的名称的使用就像创建一个 class 一样。换句话说，这里的动画名称是什么并不重要，只要确保你在想要使用该动画的元素上使用一样的名称就可以了。

如果这里的 `cubic-bezier` 部分让你感到头大，那就快看看 Michelle Barker 的[这个帖子](https://css-tricks.com/reversing-an-easing-curve/)。她深度的解释了这个话题。如果只是想要达到本文演示的目的，我觉得我这么说就够了：这是一个为物体的整个移动过程创建一个自定义动画曲线的方法。[cubic-bezier.com](http://cubic-bezier.com/#.5,.5,0,1) 网站是一个很好的可以帮助你生成这些值（而不是靠猜）的网站。

我们之前提及了我们希望避免循环动画。我们可以通过使用 `animation-fill-mode` 子属性来强行让物体在动画进度到达 100% 后就不再移动。

``` CSS
.image-container img {
  animation: image-slide 4s cubic-bezier(.5,.5,0,1);
  animation-fill-mode: forwards;
}
```

目前为止一切都很好！

这里请查看 [Revealing Text Animation Part 3 - @keyframes](https://codepen.io/jesper-ekstrom/pen/WYqRLx/)。

## 步骤四：实现响应效果（responsiveness）

因为动画是基于固定的大小（像素），改变视口的宽度会造成元素们偏离，这不利于我们根据元素的位置来隐藏和展现它们。我们可以在不同的 media queries 上创建多个动画来解决这个问题（这也是我最初的做法），但是一次处理这么多的动画可不是什么好玩的事。我们可以使用相同的动画，通过在特点的断点改变它的属性来解决这个问题。

例如：

```
@keyframes image-slide {
  0% { transform: translatex(-250px) scale(0); }
  60% { transform: translatex(-250px) scale(1); }
  90% { transform: translatex(150px) scale(1); }
  100% { transform: translatex(150px) scale(1); }
}

/* 改变动画的参数来适应大至 1000 像素的宽度 */
@media screen and (max-width: 1000px) {
  @keyframes image-slide {
    0% { transform: translatex(-150px) scale(0); }
    60% { transform: translatex(-150px) scale(1); }
    90% { transform: translatex(120px) scale(1); }
    100% { transform: translatex(120px) scale(1); }
  }
}
```

这样就可以啦。都是响应式哒！

这里请查看 [Revealing Text Animation Part 4 - Responsive](https://codepen.io/jesper-ekstrom/pen/GPjGzy/)。

## 替代方法：使用文字的动画而非不透明的 div

我在之前保证过我会介绍一种不一样的隐藏文字方法。我们现在来介绍它。

与其使用一个全新的 div ─ `<div class="fading-effect">`，我们可以使用一个小技巧实用化 `background-clip` 将背景的颜色通过文字透出来：

``` CSS
.text-container {
  background: black;
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
}
```

透明的文字允许背后背景的颜色渗透过来，可以很有效的隐藏文字。并且，因为是用背景隐藏文字，我们可以改变背景的宽度并观察文字如何根据所给定的宽度被切割。这同样使得给文字添加线性渐变颜色，甚至是背景图片成为可能。

我没有在之前的演示中使用这个方法，因为它不能很好地兼容 IE（你看，代码里有 -webkit 这个浏览器前缀）。在我们实际演示中使用的方法，果把文字换成图片或者任何元素，仍然有效。

* * *

非常简单的小动画，是不是？它相当的细微，并且可以你的 UI 元素添色。例如，它可以用作揭示解释类文字甚至图片的标题。或者，可以用一点 JavaScript 代码来监听点击或滚动事件，从而触发动画，使网页的交互方式更丰富。

对我们的动画有任何的问题嘛？有一些让它们变得更好的建议嘛？快发在下面的评论中来告诉我吧！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
