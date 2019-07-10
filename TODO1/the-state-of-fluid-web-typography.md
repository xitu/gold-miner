> * 原文地址：[The State of Fluid Web Typography](https://betterwebtype.com/articles/2019/05/14/the-state-of-fluid-web-typography/)
> * 原文作者：[Matej Latin](https://twitter.com/matejlatin)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/the-state-of-fluid-web-typography.md](https://github.com/xitu/gold-miner/blob/master/TODO1/the-state-of-fluid-web-typography.md)
> * 译者：[Jenniferyingni](https://github.com/Jenniferyingni)
> * 校对者：[smilemuffie](https://github.com/smilemuffie), [mymmon](https://github.com/mymmon)

# Web 流式文字排版的现状

![The State of Fluid Web Typography](https://betterwebtype.com/assets/img/posts/state-of-fluid-web-typography/post@2x.jpg)

Web 流式文字排版可以提升用户的网站阅读体验，但与此同时，它也带来了字体不受控制变大的问题和对浏览器辅助功能使用的影响。那么 Web 流式文字排版到底能否在实践中被应用呢？

**请注意本文使用了 GIF 动画来演示使用响应式/流式文字排版的实现效果，移动端设备的访问者可能阅读上会有一定影响。**

浏览器对视口单位（vw, vh, vmin, vmax）的支持已经有一段时间了。[从这里看来](https://caniuse.com/#feat=viewport-units)，大多数浏览器在 2013-2014 年就开始完全兼容这些单位。微软的 Edge 是一个例外（并不惊讶），在 2017 年 10 月发布的 Edge 16 才开始兼容，但是也过去了两年的时间。为什么其他主流浏览器已经兼容视口单位长达 5-6 年的时间，我们还是很少看到采用流式文字排版的网页呢？我必须承认，我是那种访问网页时会调整浏览器窗口大小来看页面如何适应窗口大小变化的人之一。我经常这样做，但是我已经不记得上一次发现使用流式文字排版的网站是什么时候了。除了 CSS Tricks 之外想不到其他的例子。因此我就开始思考，为什么这种网页文字排版技巧没有被广泛的使用呢？

回答这个问题并没有那么容易，因为原因并不是单方面的。我认为可以归结为以下几个：

1. 好的响应式 Web 设计/开发仍然是困难和复杂的。
2. Web 文字排版仍旧没有引起设计者/开发者的重视。
3. 潜在的对浏览器无障碍访问功能的影响。
4. 流式文字排版是比较难实现的。

让我们来仔细分析下每个原因。

## 好的响应式 Web 设计仍然是困难和复杂的

最耗费精力的是上面列出的第一个问题。和以前相比，响应式页面设计工具的进步使得构建一个好的响应式网站变得容易多了，但是仍然需要花费很多时间。在网页设计过程中，很大一部分时间花在了挑选符合功能需求的工具、测试工具、应用工具上。我们还没有做到只需设计好一个屏幕宽度下的视觉稿，工具就能自动产生在其他大多数屏幕宽度设备下的视觉显示。比如，我们仍然使用数字设计工具来绘制静态的视觉稿，这与最终代码实现的效果相差甚远。这些工具连基本的响应式网页设计都几乎不支持，更别说实现流式文字排版了。

## Web 文字排版没有引起重视

第二个问题是我希望通过 **Better Web Type** 这个网站来改善的，在那里有很多热衷于研究样式的极客们，但遗憾的是，只有这些人真正的关注网页中文字排版的质量，仍然有许多的设计师和开发者认为文字排版就是简单的给选择字体类型和调整字体大小。

## 流式字体布局影响了无障碍访问功能的使用

在设计和构建网站的时候，很少有人会考虑到浏览器的无障碍访问功能。我想要在本文中特别关注一下这个问题。在大家还没有意识到这一点前，我就注意到流式文字排版对无障碍访问功能的影响，而这个问题几乎没有被人提及。

## 流式文字排版是比较难实现的

使用视口单位来设置字体大小是棘手的。我收到过许多封这样的邮件，有人告诉我他有尝试过使用流式文字排版，但是最终并没有选择将其应用到实际的网站中。但是流式文字排版不应该是那么难实现的，我们需要让它变得更容易，已经有许多聪明的人找到了对的方法。让我们来看看几个不同的实现方法，然后讨论哪个方法是最佳实践，哪个方法让流式布局不那么困难，变得更加的可控和**更好**。与此同时，我们也将看看这些方法有没有带来相应的无障碍访问问题。

## 响应式文字排版

那我们从最常见的开始说起。我们最开始探索流式文字排版其实是从响应式文字排版开始的。如果采用现在最常用的网页设计（响应式网页设计），通常是从移动端布局和字体大小开始，我们通常会设定一个根节点的字体大小，然后在这个字体大小的基础上去定义其它的大小。以下是一个最简单的示例：

```scss
html {
  font-size: 100%; // Usually 16 pixels
}

h1 {
  font-size: 3rem; // 3 × base font size (3 × 16px)
}
```

**请注意，所有的代码段均是使用了 SCSS。**

在这里我们将根节点字体大小匹配浏览器的默认字体大小（通常是 16px）。如果要创建支持无障碍访问功能的网站，这是很重要的一步，我们稍后将会回过头来看这一步。现在，我们需要考虑到其他不同屏幕大小的设备，重新给我们的网页布局并且重新定义字体的大小。因此，我们使用媒体查询来定义布局和字体大小发生变化的断点。

```scss
html {
  font-size: 100%;

  @media (min-width: 768px) {
    font-size: 112.5%;
  }
}

h1 {
  font-size: 3rem;

  @media (min-width: 768px) {
    font-size: 3.5rem;
  }
}
```

在上面的例子中，我们重新定义了根节点的字体大小，我们认为平板电脑大小的尺寸是 768 px，并定义了在这个尺寸下合适的字体大小 。更大的屏幕有更多的空间，因此字体大小的改变也可以更明显。因此我们将一级标题的大小从默认的 `3rem` 修改为了 `3.5rem`。

看看 CodePen 上这个[响应式布局的简单示例](https://codepen.io/matejlatin/full/oRLaXy)。所有的浏览器都支持且没有无障碍访问的问题，那么为什么我们还要改进它呢？字体大小只会在我们定义的断点发生改变，这是很多人会担心的问题。在上面的示例中，我们网站的用户会发现字体的大小一直为 16px，直到屏幕的宽度变成了 768px 才发生变化。如果用户在平板电脑上访问我们的网站，他看到的根节点的字体大小是 18px（112.5%）。在我看来，这个方法最主要的问题是他们过分关注了自己的观点而忽略了用户。如果调整窗口的大小将会看到这样的现象：

![Responsive typography: fonts only resize at predefined breakpoints which results in drastic shifts like these.](https://betterwebtype.com/assets/img/posts/state-of-fluid-web-typography/responsive.gif)

响应式布局：字体大小只会在预定义的断点处发生变化，这会导致字体像这样发生突变。

是的，字体大小只在我们定义的断点处发生变化，但是我们忘记了用户对于他们设备上的字体大小有绝对的控制权。如果他们从电脑端访问并且觉得 18px 的字体大小不够大，他们可以轻易地调整（如果我们没有使用例如 px 一样的非相对单位来覆盖默认的字体大小）。

### 优点

* 用户保持对字体大小的控制权，没有无障碍访问问题。
* 运用得当的情况下，少量的媒体查询可以覆盖大部分不同屏幕宽度的设备。

### 缺点

* 字体大小在大多数情况下是维持不变的且受限于事先定义的断点（屏幕宽度）。
* 大屏幕上有大量的空白，字体大小不自适应，最终的网站将呈现为居中的单列布局。

## 纯流式文字排版

我们得出的结论是响应式文字排版不是理想的解决方案。它勉强满足需求但是我们想要有能够更好的控制字体大小的方案。**我们希望我们的字体大小在任何屏幕尺寸都是理想的，而不仅是在某个特定的移动端、平板或是电脑屏幕等**。流式文字排版就是我们的救星！

视口单位的引入已经有一段时间了。这个想法很简单，我们可以在 CSS 中使用视口高度单位和视口宽度单位来定义任何元素的大小，包括字体大小。在我看来，视口单位被引入更多是作为绝对单位网页布局的一种扩展，这和 Sebastian Eberlein 在他的 [Hacker Noon 上的文章](https://hackernoon.com/using-viewport-units-to-scale-fixed-layouts-869638bb91f9)中所做的描述的相似。

但是尽管如此，视口单位很长一段时间来都被用作流畅地缩放字体大小的方法。Chris Coyier 在 2012 年在文章中兴奋地提到，一行文字理想的宽度大约是 80 个字符，“**这些单位能让你有完美的体验，并且能将这种体验扩展到所有大小的屏幕**”<sup><a href="#note1">[1]</a></sup>。

这听起来很酷，但实际上并不那么简单。假设我们执行以下操作：

```scss
html {
  font-size: 1.3vw;
}

h1 {
  font-size: 3vw;
}
```

我们使用视口单位来定义根节点字体大小。这意味着在**每此屏幕宽度变化**时字体大小都会改变，而不是像响应式布局一样只在几个预定义的断点。但是因为屏幕的宽度的差别是很大的（移动端屏幕大小相比于笔记本或者是台式电脑屏幕大小），所以字体的大小就会变化得非常快。来看一下 CodePen 上的 [流式布局示例](https://codepen.io/matejlatin/full/awxyLG/)，当你调整窗口的大小时，会看到这样的现象：

![Fully fluid typography: font sizes change rapidly depending on the screen width.](https://betterwebtype.com/assets/img/posts/state-of-fluid-web-typography/fluid.gif)

纯流式文字排版：字体大小根据屏幕宽度快速的变化。

是否注意到了字体在小屏幕（移动端）中的变化？最终的显示效果太小了，那么我们如何能修复这个问题呢？

### 优点

* 在实践中，如果流式文字排版不和响应式布局一起使用的话，是毫无优势可言的。

### 缺点

* 影响无障碍访问功能的使用（用户在某些浏览器中不能控制字体的大小）。
* 会覆盖用户在浏览器中设置的默认的字体大小，这是另外一个对无障碍访问功能使用的影响。
* 字体会不受控制的快速变大或变小。

### 增加媒体查询来改善实现效果

显然纯流式文字排版是满足不了需求的。讽刺的是，改善它的唯一办法就是采用响应式文字排版来控制字体大小的快速变化。但是，与我们前面的响应式文字排版例子不同的是，在这个案例中我们使用了多个媒体查询来限制字体大小的变化。我们可以这样做：

```scss
$breakpoint-1: 25em;
$breakpoint-2: 35em;
...

html {
  font-size: 1.3vw;
}

h1 {
  font-size: 3vw;
}

@media (min-width: $breakpoint-1) {
  html {
    font-size: 2vw;
  }
  
  h1 {
    font-size: 6vw;
  }
}

@media (min-width: $breakpoint-2) {
  ...
}
```

在 CodePen 中看一下这个[流式文字排版 + 响应式文字排版的例子](https://codepen.io/matejlatin/full/GELvGK/) 并且调整浏览器窗口的大小，你会发现效果比上面的纯流式布局要好很多，这基本满足了我们的需求（示例中我使用了 7 个断点）。

![Fluid + responsive typography: we limit the scaling of font sizes for small and large screens.](https://betterwebtype.com/assets/img/posts/state-of-fluid-web-typography/fluid+responsive.gif)

流式布局 + 响应式布局：限制了小屏幕和大屏幕中字体大小的变化。

我不知道你怎么看，但是对我来说，这种做法的投入和产出比是不太理想的，我不否认它比纯响应式文字排版实现的效果更好，但是它也引入了其它的问题，包括无障碍访问的问题，这对我来说是无法接受的。

#### 优点

* 字体大小的变化比较理想，且能适应所有的屏幕大小。

#### 缺点

* 影响无障碍访问功能的使用（用户在某些浏览器中不能控制字体的大小）。
* 因为使用了媒体查询来控制字体大小，在缩放屏幕大小的时候仍然会在断点处发生突变。
* 会覆盖用户在浏览器中设置的默认的字体大小，这是另外一个对无障碍访问功能使用的影响。

## 带CSS锁的流式文字排版

另外一批人注意到了流式文字排版字体大小不受控制变化的问题。他们知道增加许多的媒体查询并不是理想的解决方案，所以他们开始寻找另外的解决方案。Mike Riethmuller <sup><a href="#note2">[2]</a></sup>, Tim Brown <sup><a href="#note3">[3]</a></sup> 和 Geoff Graham <sup><a href="#note3">[4]</a></sup> 最终得出的结论都是**带 CSS 锁的流式文字排版**可能是最好的方案。

这是一个很有意思的方案。它设定了在小屏幕下适用的最小字体大小，以及在大屏幕下适用的最大字体大小。在这两个屏幕大小中间的范围，字体大小的变化就采用流式文字排版。这个方法使用基础的数学原理优雅的解决了字体大小变化过快的问题。下图能很好的解释这种方法，字体大小只在中间的区域发生变化，在左侧和右侧均不会变化。左边的阀门是指最小的屏幕大小，我们对其使用固定的字体大小，同理右边的阀门是指最大的屏幕大小。

![CSS locks for fluid typography, font sizes only scale in the middle compartment.](https://betterwebtype.com/assets/img/posts/state-of-fluid-web-typography/lock-basic.png)

带 CSS 锁的流式文字排版，字体仅在中间部分变化大小。([链接](https://blog.typekit.com/2016/08/17/flexible-typography-with-css-locks/))

实现这个功能的公式非常的简单，需要用到四个变量：**最小字体值**、**最大字体值**、**最小视口宽度**、**最大视口宽度**。

```scss
body {
  font-size: calc([minimum size] + ([maximum size] - [minimum size]) * ((100vw - [minimum viewport width]) / ([maximum viewport width] - [minimum viewport width])));
}
```

访问 CodePen 上[带 CSS 锁的流式文字排版示例](https://codepen.io/matejlatin/full/dEXQmG)，调整浏览器窗口的大小将会看到下面的现象。

![CSS locks in action. Font sizes change only in the specified range.](https://betterwebtype.com/assets/img/posts/state-of-fluid-web-typography/css-locks.mov.gif)

CSS 锁定了变化。字体大小只在特定的区间范围内改变。

这个实现效果是令人满意的。如果屏幕宽度介于最小值和最大值之间，字体大小可以很好地缩放。如果屏幕宽度小于最小值或者是大于最大值，将切换到固定的字体大小。理论上是行得通的，但是当我在 Chrome 上改变了浏览器的默认字体大小，会发现没有产生 CodePen 示例中的效果。这表明这个方法仍然忽略了可变的用户默认字体大小，存在对无障碍访问功能的影响。某些浏览器中用户无法改变字体的大小（在 Mac 上使用 ⌘+）。

### 优点

* 调整浏览器窗口大小的时候字体大小不会在断点突变。
* 当屏幕宽度小于最小值或者大于最大值时，字体大小不会改变。

### 缺点

* 影响无障碍访问功能的使用（用户在某些浏览器中不能控制字体的大小）。
* 会覆盖用户在浏览器中设置的默认的字体大小，这是另外一个对无障碍访问功能使用的影响。

## 结论 — 我们是否应该使用流式文字排版？

乍一看，CSS 锁似乎是最佳的选择，它解决了字体大小过大或者是过小的问题，只需要使用少量的媒体查询并且字体变化过程中避免了断点突变。而使用流式文字排版的方案普遍存在的一个问题是它们都覆盖了浏览器中用户设置的默认字体大小（在我的测试中，仅在 Chrome 中发现了这个问题）。在某些浏览器的某些情况下，因为使用了视口单位用户不能改变字体的大小。这意味着从无障碍访问功能的角度来看，这些解决方案都不完全符合要求。

> 流式文字排版与默认浏览器字体大小两者不能很好的地兼容，因此在这一问题解决之前不推荐使用。

在写纯流式文字排版时，我曾写过“**我们希望我们的字体大小在任何屏幕尺寸都是理想的，而不仅是在某个特定的移动端、平板或是电脑屏幕等**”。现在我觉得这个想法是完全错误的，我们不应该把关注点放在让字体大小在所有窗口尺寸下合理地缩放，而应当放在如何让每一个用户都能轻松且愉悦地阅读网站的内容上。从这点来看，流式文字排版对用户的干涉太多了。如果它能和浏览器默认字体大小很好地兼容，那我会鼓励大家来使用，但是它没有满足这一点，所以我们认为它不是一个能被采用的方案，至少现在还不是。正如我在书中探索流式文字排版时所提及的，我**依旧**坚持响应式文字排版。

[![Better Web Type book](https://betterwebtype.com/assets/img/book-image-centred.png)](/web-typography-book/)

如果你喜欢本文的内容，可以在[我的书](https://betterwebtype.com/web-typography-book/)中阅读到更多的内容。这本书在设计师与前端开发者中很受欢迎，请一定不要错过。

---

1. <a name="note1"></a>**Viewport Sized Typography** by Chris Coyier ([链接](https://css-tricks.com/viewport-sized-typography/))
2. <a name="note2"></a>**Precise Control Over Responsive Typography** by Mike Riethmuller ([链接](https://www.madebymike.com.au/writing/precise-control-responsive-typography/))
3. <a name="note3"></a>**Flexible Typography with CSS Locks** by Tim Brown ([链接](https://blog.typekit.com/2016/08/17/flexible-typography-with-css-locks/))
4. <a name="note4"></a>**Fluid Typography** by Geoff Graham ([链接](https://css-tricks.com/snippets/css/fluid-typography/))

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。

