> * 原文地址：[Slide an Image to Reveal Text with CSS Animations](https://css-tricks.com/slide-an-image-to-reveal-text-with-css-animations/)
> * 原文作者：[Jesper Ekstrom](https://css-tricks.com/author/legshaker/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/slide-an-image-to-reveal-text-with-css-animations.md](https://github.com/xitu/gold-miner/blob/master/TODO1/slide-an-image-to-reveal-text-with-css-animations.md)
> * 译者：
> * 校对者：

# 如何用 CSS Animations 实现图片滑动出文字

这篇文章，我希望能带领大家走进了解一下 [CSS animation property](https://css-tricks.com/almanac/properties/a/animation/)，以及详细的解释我的[个人网站](https://jesperekstrom.com/portfolio/malteser/)中的一个效果：让文字在移动的物体后出现。如果你想要看最后的成果，这里有一个[例子](https://codepen.io/jesper-ekstrom/pen/GPjGzy) 。

我们将从下面这里开始：

这里请查看 [Jesper Ekstrom](https://codepen.io/jesper-ekstrom) 的 [Revealing Text Animation Part 4 - Responsive](https://codepen.io/jesper-ekstrom/pen/GPjGzy/)案例。

即使你对这个效果完不感兴趣，这仍将是一个可以扩展你 CSS 知识的好的练习，你可以从这个效果开始创建属于你自己的动画效果。在我的例子中，在动画上进行深入的挖掘学习，让我在我的 CSS 能力上有了更多的自信，并且让我更加有想象力，也让我对于整个前端开发都更加感兴趣了。

准备好了么？让我们一起开始吧。

## 步骤一：标记你的主元素

在我们开始制作动画效果之前，首先让我们创建一个包含了整个视口（viewport）的父元素。在这个元素中，我们在两的 div 中添加分别文字和图片，以方便之后的自定义。HTML 将如下：

```HTML
<!-- The parent container -->
<div class="container"> 
  <!-- The div containing the image -->
  <div class="image-container">
  <img src="https://jesperekstrom.com/wp-content/uploads/2018/11/Wordpress-folder-purple.png" alt="wordpress-folder-icon">
  </div>
  <!-- The div containing the text that's revealed -->
  <div class="text-container">
    <h1>Animation</h1>
  </div>
</div>
```

我们将使用一个靠谱的[转换小技巧](https://css-tricks.com/centering-percentage-widthheight-elements/)来将我们的 position 为 absolute 的（ `position: absolute;`） 的 div 水平垂直居中。在我们的父元素中，因为我们希望我们的图片在文字之前，这里我们给它一个更好的 `z-index` 值。 

```CSS
/* 父元素占据这个页面。 */
.container {
  width: 100%;
  height: 100vh;
  display: block;
  position: relative;
  overflow: hidden;
}

/* 内涵图片的 div  */
/* 居中小技巧: https://css-tricks.com/centering-percentage-widthheight-elements/ */
.image-container {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%,-50%);
  z-index: 2; /* Makes sure this is on top */
}

/* 图片在第一个 div 中 */
.image-container img {
  -webkit-filter: drop-shadow(-4px 5px 5px rgba(0,0,0,0.6));
  filter: drop-shadow(-4px 5px 5px rgba(0,0,0,0.6));
  height: 200px;
}

/* 包括将要被现实出来的文字的 div */
/* Same centering trick */
.text-container {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%,-50%);
  z-index: 1; /* Places this below the image container */
  margin-left: -100px;
}
```

> 我们在整篇文章所有的例子中中都没有保留浏览器前缀，但如果你在生产环境中使用这些效果，请务必考虑它。

现在我们的例子应该长这样，基本上来说就是图片元素在文字元素之上。

这里请查看 [Revealing Text Animation Part 1 - Mail Elements](https://codepen.io/jesper-ekstrom/pen/zMgjwj/)案例。

## 步骤二：将文字藏在一个 div 后面

为了是我们的文字能从左到右显示，我们将在我们的 `.text-container` 中添加另一个 div。

``` HTML
<!-- ... -->

  <!-- The div containing the text that's revealed -->
  <div class="text-container">
    <h1>Animation</h1>
    <div class="fading-effect"></div>
  </div>
  
<!-- ... -->
```

然后这是这个 div 的 css 如下：

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

正如你所见，现在文字藏在了这个新加入我们的父元素中的拥有白色背景的 div 后面。

如果我们试图改变 这个 div 的长度，文字就会开始出现。你可以在我们下面的例子中来尝试一下：

这里请查看 [Revealing Text Animation Part 2 - Hiding Block](https://codepen.io/jesper-ekstrom/pen/JwRZaG/)。

> 还有另外一个不需要添加额外 div 就可以达到同样效果的方法。我会在稍后的文章中介绍它。🙂

## 步骤三：定义 animation keyframes

下面我们将开始有趣的部分了！我们将使用 [animation property](https://css-tricks.com/almanac/properties/a/animation/) 和它的 `@keyframes` 功能来开始我们对我们的目标制作动画效果。让我们们先来创建连个不同的 `@keyframes`，一个给我们的图片，一个给我们的文字。代码如下：

``` CSS
/* Slides the image from left (-250px) to right (150px) */
@keyframes image-slide {
  0% { transform: translateX(-250px) scale(0); }
  60% { transform: translateX(-250px) scale(1); }
  90% { transform: translateX(150px) scale(1); }
  100% { transform: translateX(150px) scale(1); }  
}

/* Slides the text by shrinking the width of the object from full (100%) to nada (0%) */
@keyframes text-slide {
  0% { width: 100%; }
  60% { width: 100%; }
  75%{ width: 0; }
  100% { width: 0; }
}
```

> 我建议将所有的 `@keyframes` 添加到 CSS 文件的顶端，这样会有更好的结构，当然这只是一个建议。

我只使用 `@keyframes` 很小一部分百分比值（主要是从 60% 到 100%）的原因是我选择在相同的时间段对两个物体设置动画，而不是为它们添加一个 [`animation-delay`](https://developer.mozilla.org/en-US/docs/Web/CSS/animation-delay) 。这只是我的个人喜好。如果你选择和我一样的方法，一定记得要带从为 0% 和 100% 设值；否则，动画效果就会开始循环或者是造成一些很奇怪的结果。

为了在我们的 class 中启用 `@keyframes`，我们需要在 CSS 属性 `animation` 上调用我们的动画名称。例如，将 `image-slide` 加入图片元素上，我们这样做：

``` CSS
.image-container img {
  /* [animation name] [animation duration] [animation transition function] */
  animation: image-slide 4s cubic-bezier(.5,.5,0,1);
}
```

> `@keyframes` 的名称的使用就像创建一个 class 一样。换句话说， 这里的动画名称是什么并不重要，只要确保你在想要使用该动画的元素上使用一样的名称就可以了。

如果这里的 `cubic-bezier` 部分让让你感到头大，那就快看看 Michelle Barker 的[这个帖子](https://css-tricks.com/reversing-an-easing-curve/)。她深度的解释了这个话题。入股只以这个演示为目的大的话，那么说这就是一个为物体从开始到结束如何移动创建一个自定义动画曲线的方法就可以了。[cubic-bezier.com](http://cubic-bezier.com/#.5,.5,0,1) 网站是一个很好的可以帮助你生成这些值（而不是靠猜）的网站。

我们之前提及了我们希望避免循环动画。我们可以通过使用  `animation-fill-mode` 子属性来强行让物体在玉栋到达 100% 后保持不变。

``` CSS
.image-container img {
  animation: image-slide 4s cubic-bezier(.5,.5,0,1);
  animation-fill-mode: forwards;
}
```

目前为止一切都很好！

这里请查看 [Revealing Text Animation Part 3 - @keyframes](https://codepen.io/jesper-ekstrom/pen/WYqRLx/)。

## 步骤四：实现响应（responsiveness）

因为动画是基于固定的大小（像素），改变视口的宽度会造成元素们偏离，这对于想要通过为止来隐藏和揭示元素的我们来说，是非常糟糕的。我们可以在不同的 media queries 上创建多个动画来解决这个问题（这也是我最初的做法），但是一次处理这么多的动画很无聊。我们可以使用相同的动画，通过在特点的断电改变它的属性来解决这个问题。

例如：

```
@keyframes image-slide {
  0% { transform: translatex(-250px) scale(0); }
  60% { transform: translatex(-250px) scale(1); }
  90% { transform: translatex(150px) scale(1); }
  100% { transform: translatex(150px) scale(1); }
}

/* Changes animation values for viewports up to 1000px wide */
@media screen and (max-width: 1000px) {
  @keyframes image-slide {
    0% { transform: translatex(-150px) scale(0); }
    60% { transform: translatex(-150px) scale(1); }
    90% { transform: translatex(120px) scale(1); }
    100% { transform: translatex(120px) scale(1); }
  }
}
```

这样就可以啦。都是响应哒！

这里请查看 [Revealing Text Animation Part 4 - Responsive](https://codepen.io/jesper-ekstrom/pen/GPjGzy/)。


## 替代方法：使用文字的动画而不是不透明的 div

我在之前保证过我会介绍一种不一样的隐藏文字方法。我们现在来介绍它。

与其使用一个全新的 div ─── `<div class="fading-effect">`，我们可以使用一个小技巧实用化 `background-clip` 将背景的颜色通过文字透出来：

``` CSS
.text-container {
  background: black;
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
}
```

透明的文字允许背后背景的颜色渗透过来，可以很有效的隐藏文字。并且，因为这使用背景，我们可以改变背景的宽度并观察文字如何根据所给定的宽度被切割。这同样使得给文字添加线性渐变颜色，甚至是背景图片成为可能。

我没有在之前的演示中使用这个方法的原因是因为他不能很好的 IE 兼容（注意，需要使用 `-webkit`浏览器前缀）。我们在演示中使用的方法可以为其他图像或任何其他对象切换文本。

* * *

非常干净的小动画，是不是？它相当的细微，并且可以你的 UI 原色添色。例如，它可以用作揭示解释类文字或者用作图片的标题。或者，一点 JavaScript 可以被用来在点击或者滑动事件上触发动画，使得网页更加的具有交互性。

对我们工作有任何的问题嘛？有一些让它们变得更好的建议？快发在下面的评论中来告诉我吧！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
