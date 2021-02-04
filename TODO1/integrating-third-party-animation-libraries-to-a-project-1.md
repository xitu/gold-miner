> * 原文地址：[Integrating Third-Party Animation Libraries to a Project - Part 1](https://css-tricks.com/integrating-third-party-animation-libraries-to-a-project/)
> * 原文作者：[Travis Almand](https://css-tricks.com/author/travisalmand/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/integrating-third-party-animation-libraries-to-a-project-1.md](https://github.com/xitu/gold-miner/blob/master/TODO1/integrating-third-party-animation-libraries-to-a-project-1.md)
> * 译者：[TUARAN](https://github.com/TUARAN)
> * 校对者：[lihaobhsfer](https://github.com/lihaobhsfer)

# 将第三方动画库集成到项目中 —— 第 1 部分

创建以 CSS 为基础的动画可能是一个挑战。它们可能是复杂且耗时的。你是否需要在时间紧迫的情况下调整出一个完美的动画（库）来推进项目？这时，你该考虑使用一个拥有现成的动画插件的第三方 CSS 动画库。可是，你仍然会想:它们是什么？它们提供什么？我如何使用它们？

我们来看看吧。

## 简短的历史：hover

曾经有一段时间，hover 状态与现在它能提供的功能相比不值一提。实际上，对于在元素上浮动的光标进行响应的想法可以说是不存在的。对此，实现该特性的不同方法被提了出来。在某种程度上来讲，这个小特性为 CSS 能够在页面上的元素创建动画打开了大门。随着时间的推移，这些特性可能越来越复杂，导致 CSS 动画库的产生。

**Macromedia’s Dreamweaver** 于 [1997 年 12 月](https://en.wikipedia.org/wiki/Adobe_Dreamweaver)推出，并提供了一个简单的功能，即悬停时的图像变换。这个特性是通过一个 JavaScript 函数实现的，该函数被编辑器嵌入到 HTML 中。这个函数被命名为 `MM_swapImage()`，并且它已经成为一个 web 设计的民间传说。这个脚本易于使用，即使在 Dreamweaver 之外也是如此，它的流行性使得它直到今天还在使用。在本文的初步研究中，我在 **Adobe’s Dreamweaver**（Adobe 于 2005 年收购了 Macromedia）帮助论坛上发现了一个与此功能相关的问题。

JavaScript 函数将根据 **mouseover** 和 **mouseout** 事件更改 src 属性，从而将一个图像与另一个图像交换。实现时，它看起来是这样的：

```html
<a href="#" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('ImageName','','newImage.jpg',1)">
  <img src="originalImage.jpg" name="ImageName" width="100" height="100" border="0">
</a>
```

按照今天的标准，用 JavaScript 实现这一点是相当容易的，我们中的许多人实际上都可以在睡梦中完成这一点。但是，考虑到 JavaScript 在当时（创建于 1995 年）仍然是一种新的脚本语言，而且有时在不同浏览器之间的外观和行为都有所不同。创建跨浏览器 JavaScript 并不是一件容易的事情，甚至不是每个创建 web 页面的人都编写 JavaScript。（[这一点显然已经改变了](https://css-tricks.com/the-great-divide/)）Dreamweaver 通过编辑器中的菜单提供了这一功能，而 web 设计师甚至不需要编写 JavaScript。它基于可以从不同选项列表中选择的一组“行为”。这些选项可以被一组目标浏览器过滤；3.0 浏览器，4.0 浏览器，IE 3.0，IE 4.0，Netscape 3.0，Netscape 4.0。啊，[过去的美好时光](https://css-tricks.com/the-ecological-impact-of-browser-diversity/)。

![Netscape 浏览器窗口的屏幕截图。](https://css-tricks.com/wp-content/uploads/2019/05/mm_browsers.png)

大约在 1997 年，就可根据浏览器版本选择行为。

![来自 Dreamweaver 应用程序的屏幕截图，显示了在HTML中切换元素行为的选项面板。](https://css-tricks.com/wp-content/uploads/2019/05/s_EBCAC238906FAA6EECC38BE5A80726DC08BADA1B9C984153FFCE3F96AC775B6A_1554670455957_mm_swap.png)

Macromedia Dreamweaver 1.2a 中的交换图像行为面板

Dreamweaver 首次发布大约一年后，W3C 的 CSS2 规范在 [1998 年 1 月](https://www.w3.org/TR/1998/WD-css2-19980128/)的工作草案中提到了 `:hover`。它在锚点链接方面被特别提到，但是语言表明它可能被应用于其他元素。在大多数情况下，这个伪选择器似乎是 `MM_swapImage()` 的一个简单替代方法的开始，因为 `background-image` 也在同一草案中。尽管浏览器支持是一个问题，因为在足够多的浏览器正确支持 CSS2 之前，它已经花费了数年的时间，使其成为许多 web 设计人员的一个可行选项。[2011 年 6 月](https://www.w3.org/TR/CSS2/)，终于有了 W3C 推荐的 CSS2.1，这可以被认为是我们所知的“现代” CSS 的基础。

在这中间，**jQuery** 出现在 [2006](https://en.wikipedia.org/wiki/JQuery)。幸运的是，jQuery 在简化不同浏览器之间的 JavaScript 方面走了很长的路。我们的故事中有一件有趣的事情，jQuery 的第一个版本提供了 [`animate()`](https://api.jquery.com/animate/) 方法。使用这种方法，你可以在任何时候对任何元素的 CSS 属性进行动画的操作；不只是悬停。由于它的流行，这个方法暴露了在浏览器中嵌入一个更健壮的 CSS 解决方案的需要——这个解决方案不需要 JavaScript 库，因为浏览器的限制，JavaScript 库的性能并不是一直都很好。

`:hover` 伪类只提供了从一种状态到另一种状态的生硬转换，不支持平滑的转换。它也不能使元素在像悬停在元素上这样的基本元素之外的变化产生动画效果。jQuery 的 `animate()` 方法提供了这些特性。它铺平了道路，并一直前进着。在 web 开发的动态世界中，解决这个问题的工作草案在 CSS2.1 的建议发布之前就已经开始了。[CSS Transitions Module Level 3](https://www.w3.org/TR/2009/WD-css3-transitions-20090320/) 的第一份工作草案于 2009 年 3 月由 W3C 首次发布。第一个工作草案 [CSS Animations Module Level 3](https://www.w3.org/TR/2009/WD-css3-animations-20090320/) 是在大致相同的时间发布的。截止到 2018 年 10 月，这两个 CSS 模块仍然处于工作草案状态，当然，我们已经大量使用了它们。

一开始一个由第三方提供的、仅仅为了一个简单的悬停状态的 JavaScript 函数，逐渐变成了 CSS 中精巧复杂的过渡和动画——这一复杂性，许多开发者都不愿在他们需要快速推进新项目的时候花时间考虑。我们已经绕了一圈；今天，许多第三方 CSS 动画库已经被创建用来抵消这种复杂性。

## 三种不同类型的第三方动画库

在这个新的世界里，我们可以在网页和应用程序中实现强大、令人兴奋的、复杂的动画。关于如何处理这些新任务，出现了几个不同的想法。并不是一种方法比另一种更好；事实上，两者之间有很多重叠之处。不同之处在于我们如何为它们实现和编写代码。有些是成熟的 JavaScript 专用库，而另一些则是 css 专用集合。

### JavaScript 库

仅通过 JavaScript 操作的库通常提供的功能超出了常见的 CSS 动画所提供的功能。通常，会有重叠，因为库实际上可能使用 CSS 特性作为其引擎的一部分，但这将被抽象出来，以支持 API。例如 [Greensock](https://greensock.com/) 和 [Anime.js](https://animejs.com/)。通过查看他们提供的演示，你可以看到他们提供的内容的范围（Greensock 有一个 [CodePen 上的 nice 集合](https://codepen.io/GreenSock/)）。它们主要用于高度复杂的动画，但也可以用于更基本的动画。

### JavaScript 和 CSS 库

有一些第三方库主要包括 CSS 类，但也提供了一些 JavaScript，以便在项目中轻松使用这些类。一个库 [mic.js](https://webkul.github.io/micron/) 提供了一个 JavaScript API 和可以在元素上使用的数据属性。这种类型的库允许你轻松地使用预先构建的动画，你可以从中选择动画。另一个库 [Motion UI,](https://zurb.com/blog/introducing-the-new-motion-ui) 打算与 JavaScript 框架一起使用。尽管如此，它也适用于类似的概念，即 JavaScript API、预构建类和数据属性的混合。这些类型的库提供了预构建的动画，并提供了一种将它们连接起来的简单方法。

#### CSS 库

第三种库是只支持 CSS 的。通常，这只是通过 HTML 中的链接标签加载的 CSS 文件。然后应用并删除特定的 CSS 类来使用所提供的动画。这类库的两个例子是 [Animate.css](https://daneden.github.io/animate.css/) 和 [Animista](http://animista.net/)。也就是说，这两个特殊的库之间甚至有很大的差异。CSS 是一个完整的 CSS 包，而 Animista 提供了一个光滑的界面来选择你想要的动画代码。这些库通常很容易实现，但是你必须编写代码才能使用它们。这些是本文将重点讨论的库类型。

## 三种不同类型的 CSS 动画

是的，有这么样的一个模式；毕竟，[三条写作的原则](https://en.wikipedia.org/wiki/Rule_of_three_(writing))无处不在。

在大多数情况下，使用第三方库时需要考虑三种类型的动画。每种类型适合不同的目的，并有不同的方法来使用它们。

### 悬浮动画

![图中左边是一个黑色按钮和一个橙色按钮，上面有一个鼠标光标作为悬停效果。](https://css-tricks.com/wp-content/uploads/2019/05/button-hover.png)

这些动画被设计成某种悬停状态。它们通常与按钮一起使用，但另一种可能性是使用它们突出显示光标所在的部分。它们还可以用于聚焦状态。

### 注意动画

![一个网页的插图，上面有灰色的方框和屏幕顶部的红色警告，以显示一个元素的实例，该元素寻求关注。](https://css-tricks.com/wp-content/uploads/2019/05/attention.png)

这些动画用于通常位于查看页面的人的视觉中心之外的元素。动画应用于需要注意的显示部分。这样的动画本质上是微妙的，可用于那些在最后需要一些注意，但是本质并不严重的事情。当需要立即集中注意力时，它们也会高度分散注意力。

### 过渡动画

![同心圆垂直堆叠的插图，按升序由灰色变为黑色。](https://css-tricks.com/wp-content/uploads/2019/05/transition.png)

这些动画通常打算让视图中的一个元素替换另一个元素，但也可以用于一个元素。这些通常包括用于“离开”视图的动画和用于“进入”视图的镜像动画。想想淡入淡出。这在单页应用程序中是很常见的，例如，数据的一部分将转换到另一组数据。

那么，让我们来看看每种类型动画的例子，以及如何使用它们。

## 让我们把它悬停起来！

有些库可能已经设置了悬停效果，而有些库则将悬停状态作为其主要用途。其中一个这样的库是 [Hover.css](http://ianlunn.github.io/Hover/)，这是一个下拉式解决方案，提供了通过类名应用的一系列悬停效果。不过，有时我们希望在不直接支持 `:hover` 伪类的库中使用动画，因为这可能与全局样式冲突。

对于这个例子，我将使用 [Animate.css](https://daneden.github.io/animate.css/) 提供的**tada** animation。它的作用主要是吸引注意力，但是对于这个例子来说，它已经足够了。如果你要[查看库的 CSS](https://github.com/daneden/animate.css/blob/master/animate.css)，你将发现没有要查找的 `:hover` 伪类。所以，我们必须让它以我们自己的方式工作。

`tada`类本身很简单:

```css
.tada {
  animation-name: tada;
}
```

让它对悬停状态做出反应的一种比较省事的办法是创建我们自己的类的本地副本，但是稍微扩展一下。通常，Animate.css 是一个下拉式解决方案，所以我们不一定有编辑原始 CSS 文件的选项;尽管如果你愿意，你可以拥有自己的本地文件副本。因此，我们只创建需要不同的代码，其余的代码由库处理。

```css
.tada-hover:hover {
  animation-name: tada;
}
```

我们可能不应该覆盖原来的类名，以防我们想在其他地方使用它。因此，我们做了一个变化，我们可以把 `:hover` 伪类放在选择器上。现在，我们只需使用库中必需的`animated` 类以及自定义的 `tada-hover` 类来创建一个元素，它将在悬停时播放动画。

如果你不希望以这种方式创建自定义类，而希望使用 JavaScript 解决方案，那么有一种相对简单的方法来处理它。奇怪的是，它与我们前面讨论过的 Dreamweaver 中的 `MM_imageSwap()` 方法类似。

```javascript
// Let's select elements with ID #js_example
var js_example = document.querySelector('#js_example');

// When elements with ID #js_example are hovered...
js_example.addEventListener('mouseover', function () {
  // ...let's add two classes to the element: animated and tada...
  this.classList.add('animated', 'tada');
});
// ...then remove those classes when the mouse is not on the element.
js_example.addEventListener('mouseout', function () {
  this.classList.remove('animated', 'tada');
});
```

根据上下文，实际上有多种方法可以处理这个问题。在这里，我们创建一些事件监听器来等待鼠标经过和鼠标离开事件。这些侦听器然后根据需要应用和删除库的 `animated` 和 `tada` 类。正如你所看到的，只需稍微扩展一下第三方库以满足我们的需求，就可以相对容易地完成。

## 请大家注意一下好吗?

第三方库可以帮助的另一种类型的动画是注意力寻求者。当你希望将注意力吸引到页面的某个元素或部分时，这些动画非常有用。这方面的一些例子可以是通知或未填充的必需表单输入。这些动画可以是微妙的，也可以是直接的。当某件事情需要最终的关注，但不需要立即解决时，这是很微妙的。直接用于现在需要解决的事情。

有些库将动画作为整个包的一部分，而有些库是专门为此目的构建的。Animate.css 和 Animista 都有用于吸引注意的动画。为此目的构建的库的一个例子是 [CSShake](https://elrumordelaluz.github.io/csshake/)。使用哪个库取决于项目的需要以及你希望在实现它们上投入多少时间。例如，CSShake 已经为你准备好了，你只需根据需要应用类即可。不过，如果你已经在使用 Animate 之类的库。然后，你可能不希望引入第二个库（用于性能、依赖关系等）。

因此，可以使用 Animate.css 这样的库，但需要更多的设置。库的 [GitHub 页面有一些示例](https://github.com/daneden/animate.css)介绍了如何实现这一点。根据项目的需要，将这些动画实现为吸引注意力的工具非常简单。

对于一种微妙的动画类型，我们可以有一个只是重复一定数量的次数和停止。这通常包括添加库的类，将 animation iteration 属性应用于 CSS，并等待 animation end 事件清除库的类。

下面是一个简单的例子，与我们之前看到的悬停状态相同：

```javascript
var pulse = document.querySelector('#pulse');

function playPulse () {
  pulse.classList.add('animated', 'pulse');
}

pulse.addEventListener('animationend', function () {
  pulse.classList.remove('animated', 'pulse');
});

playPulse();
```

库类在调用 playPulse 函数时应用。animationend 事件有一个事件监听器，它将删除库的类。通常，这只会播放一次，但你可能希望在停止之前重复多次。CSS 没有为此提供一个类，但是为我们的元素应用 CSS 属性来处理它是很容易的。

```css
#pulse {
  animation-iteration-count: 3; /* Stop after three times */
}
```

这样，动画将播放三次才会停止。如果我们需要更早地停止动画，我们可以手动删除 `animationend` 函数之外的库类。库的文档实际上提供了一个可重用函数的例子，用于应用在动画之后删除它们的类;与上面的代码非常相似。甚至可以很容易地扩展它，将迭代计数应用于元素。

对于更直接的方法，让我们说一个无限的动画，直到用户交互发生后才会停止。让我们假设单击元素是动画的开始，然后再次单击停止动画。请记住，动画的启动和停止取决于你自己。

```javascript
var bounce = document.querySelector('#bounce');

bounce.addEventListener('click', function () {
  if (!bounce.classList.contains('animated')) {
    bounce.classList.add('animated', 'bounce', 'infinite');
  } else {
    bounce.classList.remove('animated', 'bounce', 'infinite');
  }
});
```

很简单。如果应用了库的 "animated" 类，单击元素测试。如果没有，我们应用库类，这样它就会启动动画。如果它有类，我们删除它们来停止动画。注意 `classList` 末尾的 `infinite` 类。幸运的是，Animate.css 为我们提供了开箱即用的功能。如果你选择的库没有提供这样的类，那么这就是你需要在你的 CSS：

```css
#bounce {
  animation-iteration-count: infinite;
}
```

下面的演示表达了这段代码的行为：

请参阅 Travis Almand[@talmand](https://codepen.io/talmand/pen/pmzlzr/) 在 [codepen](https://codepen.io) 上的笔记 [3rd party animation libraries:attention seekers](https://codepen.io/talmand/)。

> - [Integrating Third-Party Animation Libraries to a Project - Part 1](https://github.com/xitu/gold-miner/blob/master/TODO1/integrating-third-party-animation-libraries-to-a-project-1.md)
> - [Integrating Third-Party Animation Libraries to a Project - Part 2](https://github.com/xitu/gold-miner/blob/master/TODO1/integrating-third-party-animation-libraries-to-a-project-2.md)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
