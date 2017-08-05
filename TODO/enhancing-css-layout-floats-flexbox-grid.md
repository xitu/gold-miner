
> * 原文地址：[Progressively Enhancing CSS Layout: From Floats To Flexbox To Grid](https://www.smashingmagazine.com/2017/07/enhancing-css-layout-floats-flexbox-grid/)
> * 原文作者：[Manuel Matuzović](https://www.smashingmagazine.com/author/manuelmatuzovic/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/enhancing-css-layout-floats-flexbox-grid.md](https://github.com/xitu/gold-miner/blob/master/TODO/enhancing-css-layout-floats-flexbox-grid.md)
> * 译者：[LeviDing](https://github.com/leviding)
> * 校对者：[薛定谔的猫](https://github.com/Aladdin-ADD)，[LouisaNikita](https://github.com/louisanikita)

# 逐渐增强的 CSS 布局：从浮动到 Flexbox 到 Grid

今年早些时候，大多数主流浏览器都支持了 [CSS Grid 布局](https://www.smashingmagazine.com/2016/11/css-grids-flexbox-and-box-alignment-our-new-system-for-web-layout/)。自然地，规范也成为了大小会议的热门话题之一。在参与了一些关于 Grid 布局和渐进增强的讨论后，我认为使用它还是有**很大的不确定性**。我听到一些很有趣的问题和发言，我想在这篇文章中讨论讨论。

### 最近几周听到的声明和问题

- “我什么时候可以开始使用 CSS grid 布局？”
- “还需要好几年我才能在实际项目中使用 CSS Grid 布局，这太扯淡了。”
- “为了使用 CSS Grid 布局，网站需要 Modernizr 吗？”
- “如果我现在想使用 CSS Grid，那我需要为我的网站做两三个版本。”
- “渐进增强在理论上听起来不错，但我认为在实际项目中不可能实现。”
- “渐进增强的成本是多少？”

这些都是很好的问题，并不是所有的都很容易回答，但我很乐于分享我的一些方法。CSS Grid 布局模块是响应式设计中最令人激动的发展之一。如果它对我们和我们的项目有意义，我们应尽快去用好它。

### Demo: 渐进增强布局

在详细阐述我对上述问题的想法之前，我想介绍一下我做的一个小的 [demo](https://s.codepen.io/matuzo/debug/Emddvx)。

**注意：** 最好在配备有大屏幕的设备上打开上面这个 demo。你用手机打开的话，啥也看不见。
[![使用了 Flexbox 和 CSS Grid 的渐进增强的 CSS 布局](https://www.smashingmagazine.com/wp-content/uploads/2017/07/holy-grid_pptwcu_c_scale_w_1050.png)](https://s.codepen.io/matuzo/debug/Emddvx)
示例网站的主页，具有可调节的滑块，可在不同的布局技术之间进行切换。
当你打开这个 [demo](https://s.codepen.io/matuzo/debug/Emddvx), 你会发现自己在一个基本布局的网站的主页上。您可以调整左上角的滑块以增强您的体验。布局从非常基本到基于浮动的布局，再转换为 基于 flexbox 的布局，最后是基于 CSS Grid 的布局。

它不是最美丽或最复杂的设计，但它足以显示基于浏览器功能的网站可以采用哪些形态。

此演示页面使用 CSS Grid 布局构建，**不使用任何前缀属性或 polyfills**。它对于 Internet Explorer（IE）8，极限模式下的 Opera Mini，UC 浏览器和当前最流行的现代浏览器的用户来说，都是可以访问的。如果你不期待在所有浏览器中都看到完全相同的效果，那么你现在完全可以使用 CSS Grid 布局。但是期望使用 CSS Grid 在所有浏览器中都看到完全相同的效果是现在无法实现的。我很清楚，这种情况并不完全取决于我们的开发人员，但是我相信如果客户明白其中的好处（面向未来的设计，更好的可访问性和更高的性能），我们的客户会很愿意接受这些差异。除此之外，我相信我们的客户和用户 —— 感谢响应式设计 —— 已经了解到，网站在每个设备和浏览器中看起来都不一样。

在接下来的部分中，我将向你展示如何构建 demo 的部分内容，以及为什么有些效果只在 box 外有效。

**边注**：,为了让这个 demo 支持 IE 8，我不得不多添加几行 JavaScript 和 CSS（一个 HTML 5 垫片）。我没办法，因为 IE 8+ 听起来比 IE 9+ 更令人印象深刻。

### CSS Grid 布局和渐进增强

我们一起来深入了解我如何在页面中心建立“**四级增强**”组件。

#### HTML

我将所有项目按逻辑顺序放入到 `section` 中。该部分的第一个 `section` 中是标题，其次是四个小节。假设它们代表单独的博客帖子，我把它们中的每一个都包含在一个 `article` 标签中。每篇文章由一个标题（`h3`）和一个图像链接组成。我在这里使用 `picture` 元素，因为我想在视口足够宽的情况下，为不同的用户提供不同的图像。在这，我们已经有了良好的渐进增强的第一个例子。如果浏览器不理解 `picture` 和 `source`，它仍然会显示 `img`，这也是 `picture` 元素的一个子元素。

```html
<section>
  <h2>Four levels of enhancement</h2>
  <article><h3>No Positioning</h3><a href="#">  <picture>    <source srcset="320_480.jpg" media="(min-width: 600px)">    <img src="480_320.jpg" alt="image description">  </picture></a>
  </article>
</section>
```

#### 浮动增强功能

![用 float 构建的演示页面的一个组件](https://www.smashingmagazine.com/wp-content/uploads/2017/07/component_float-800w-opt.jpg)

所有的项目都在“四级增强”组件中，向左浮动。

在较大的屏幕上，如果所有项目彼此排列，则此组件的效果最好。为了支持不了解 flexbox 或 grid 的浏览器，我将其设为浮动，给它们设置了一定的 `size` 和 `margin`，并在最后一个浮动项目之后清除浮动。

```css
article {
  float: left;
  width: 24.25%;
}

article:not(:last-child) {
  margin-right: 1%;
}

section:after {
  clear: both;
  content: "";
  display: table;
}
```

### Flexbox 增强功能

![用 flexbox 布局构建的演示页面的一个组件](https://www.smashingmagazine.com/wp-content/uploads/2017/07/component_flex-800w-opt.jpg)

“四个层次的渐进增强”中的所有项目都因 flexbox 的加入而得到了提升。

在这个例子中，我实际上不需要使用 flexbox 来增强组件的总体布局，因为浮动已经完成了我的需求。在设计中，标题在图像的下边，这可以通过 flexbox 实现。

```css
article {
  display: flex;
  flex-direction: column;
}

h3 {
  order: 1;
}
```

使用 flexbox 重新为各个项目进行排序时，我们必须非常谨慎 我们应该仅将其用于视觉上的变化，并确保重新排序不会改变键盘或屏幕阅读器用户的体验。

### Grid 增强功能

![用 grid 布局构建的演示页面的一个组件](https://www.smashingmagazine.com/wp-content/uploads/2017/07/component_grid-800w-opt.jpg)

“四个层次的渐进增强”中的所有项目都因 CSS Grid 的加入而得到了提升。

一切看起来都不错，但标题仍然需要进行一些定位上的调整。有很多方法可以将标题放在第二个项目的正上方。我发现最简单、最灵活的方式是使用 CSS Grid 布局。

首先，我画了一个四列的网格，在父级容器上有一个 20 像素的凹槽。

```css
section {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  grid-gap: 20px;
}
```

因为所有文章的宽度都是 `24.25％`，所以我为支持 CSS Grid 的浏览器重新设置了这个属性。

```css
@supports(display: grid) {
  article {width: auto;
  }
}
```

然后，我把标题放在第一行和第二列。

```css
h2 {
  grid-row: 1;
  grid-column: 2;
}
```

为了去掉 Grid 的自动 `auto-placement`，我还将第二个 `article` 显式地放在第二行和第二列（标题下）。

```css
article:nth-of-type(2) {
  grid-column: 2;
  grid-row: 2 / span 2;
}
```

最后，因为我想删除标题和第二个项目之间的间距，所有其他项目必须跨两行。

```css
article {
  grid-row: span 2;
}
```

就是这样。你可以[在 Codepen 上看最终的布局](https://codepen.io/matuzo/pen/PjYKXW?editors=1100)[5](#5)。

如果我需要让这些代码支持 IE 9+，那么我们将总共需要八行代码（其中三行实际上是 clearfix，并且是可重用的）。当你使用前缀的时候也要对比一下。

```css
article {
  float: left;
  width: 24.25%;
}

@supports(display: grid) {
  article {width: auto;
  }
}

section:after {
  clear: both;
  content: "";
  display: table;
}
```

这只是一个简单的例子，而不是一个完整的项目，我知道一个网站有更复杂的组件。但是，想像一下，在所有的浏览器中构建一个布局效果几乎一样的项目需要多长时间。

### 你不需要覆盖一切

在前面的例子中，`width` 是唯一一个必须重置的属性。关于 grid（和 flexbox，顺便说一下）的一个重要的事儿是，如果某些属性被应用于 flex 或 grid 的项目内部，它们将失去原来的作用。例如 `float`，如果它应用于的元素在 grid 容器内，则不起作用。对于其他一些属性也是如此：

- `display: inline-block`
- `display: table-cell`
- `vertical-align`
- `column-*` 属性

更多内容请点击查看 [Rachel Andrew](https://rachelandrew.co.uk) 写的 “[Grid 回退和覆盖。](https://rachelandrew.co.uk/css/cheatsheets/grid-fallbacks)”
[![展示 CSS 功能查询支持情况的表格](https://www.smashingmagazine.com/wp-content/uploads/2017/07/caniuse_featurequeries-800w-opt.png)](https://www.smashingmagazine.com/wp-content/uploads/2017/07/caniuse_featurequeries-large-opt.png)

几乎每个主流浏览器都支持 CSS 功能查询。（图片：[我可以使用](http://caniuse.com/)）（[查看大图](https://www.smashingmagazine.com/wp-content/uploads/2017/07/caniuse_featurequeries-large-opt.png)）。

如果你必须使用属性覆盖，那就是用 [CSS 功能查询](https://hacks.mozilla.org/2016/08/using-feature-queries-in-css/)。在大多数情况下，你只需要覆盖 `width` 或 `margin` 等属性。 [功能查询的支持情况](http://caniuse.com/#feat=css-featurequeries)非常好，并且最好的是每个浏览器都支持网格。在这你不需要 [Modernizr](https://modernizr.com/)。

此外，你不需要将所有的 grid 属性都放在功能查询中，因为旧的浏览器会简单的[忽略他们不了解的属性和值](https://www.w3.org/TR/2003/WD-css3-syntax-20030813/#error-handling)。

在我写这个 demo 的时候，对我来说唯一感到有点棘手的是当有一个 flex 或 grid 容器使用了 clearfix 的。[包含内容的伪元素也可以变为 flex 或 grid 项](https://codepen.io/matuzo/pen/mmQxEx)。它可能会，也可能不会影响你；只要知道它就好了。作为替代方案，你可以使用 `overflow：hidden` 来清除父级，如果这适用于你的话。

### 衡量渐进增强的成本

浏览器已经为我们做了很多渐进增强的工作。我已经提到 `picture` 元素，它返回到 `img` 元素。另一个例子是 `email` 字段，如果浏览器不明白，它将返回一个简单的 `text` 字段。另一个例子是我在 demo 中使用的调节滑块。在大多数浏览器中，它会被渲染为可调节的滑块。例如，IE 9 中不支持输入类型 `range`，但它仍然可以使用，因为它返回一个简单的 `input` 字段。用户必须手动输入正确的值，这不太方便，但它可以正常工作。

![Chrome 和 IE 9 中的输入范围调节效果的比较](https://www.smashingmagazine.com/wp-content/uploads/2017/07/slider-preview-opt.jpg)

比较在 Chrome 和 IE 9 中如何呈现 `range` 输入类型。

#### 有些东西是浏览其所关注的，其他的则需要由我们负责

在准备 demo 的时候，我意识到，真正了解 CSS 是非常有帮助，而不仅仅是写一些属性，希望能够在浏览器中获得最佳的效果。越了解浮动，flexbox 和 grid 的工作原理，以及您对浏览器的了解越多，越容易实现渐进增强。

> 成为一个了解 CSS 的人，而不仅仅是使用 CSS 的人，将为你在工作中带来巨大的优势。
>
> [Rachel Andrew](https://rachelandrew.co.uk/archives/2017/05/24/a-very-good-time-to-understand-css-layout/)[16](#16)

此外，如果渐进增强功能已经深入整合到您制作网站的过程中，那么很难说会有多少额外的付出，因为这就是你做网站的方法。亚伦·古斯塔夫森（Aaron Gustafson）分享了他在文章“[渐进增强的实际成本](https://medium.com/@AaronGustafson/the-true-cost-of-progressive-enhancement-d395b6502979)”和 “[Relative Paths podcast](https://www.relativepaths.uk/ep48-progressive-enhancement-with-aaron-gustafson/)” 中所做的一些项目的几个故事。我强烈建议你阅读并学习他的经验。

#### Resilient Web Development

> 你的网站和你测试的最弱的设备一样强大。
>
> [Ethan Marcotte](https://ethanmarcotte.com/wrote/left-to-our-own-devices/)

渐进增强可能在一开始需要一点工作，但是从长远来看可以节省时间和金钱。我们不知道用户接下来会使用哪些设备，操作系统或浏览器访问我们的网站。如果我们为不是太好的浏览器提供可访问和可用的体验，那么我们就正在构建具有弹性的产品，并为[意想不到的发展](https://www.theverge.com/2017/2/26/14742150/nokia-3310-mwc-2017)做好准备。

### 摘要

我有一种感觉，我们中的一些人忘记了我们的工作是什么，甚至可能忘记我们实际做的“仅仅”是一份工作。我们不是摇滚明星，忍者，工匠或大师，我们所做的最终是将内容放在网上，让人们尽可能轻松地消费。

> 内容是我们创建网站的原因。
>
> [Aaron Gustafson](https://alistapart.com/article/understandingprogressiveenhancement)

这听起来很无聊，我知道，但不一定是这样的。我们可以使用最热门的尖端技术和花哨的技术，只要我们不忘记我们在为谁做的网站：用户。我们的用户不一样，也不使用相同的设备，操作系统，浏览器，互联网提供商或输入设备。通过提供最基本的版本开始，我们可以从现代网络中获得最佳效果，而不会影响可访问性。
[![展示 CSS 功能查询支持情况的表格](https://www.smashingmagazine.com/wp-content/uploads/2017/07/caniuse_grid-800w-opt.png)](http://caniuse.com/#search=grid)

几乎每个主流浏览器都支持 CSS 功能查询。（图片：[我可以使用](http://caniuse.com/)）（[查看大图](https://www.smashingmagazine.com/wp-content/uploads/2017/07/caniuse_featurequeries-large-opt.png)）。

Grid，例如，[几乎在每个主流浏览器中都得到了支持](http://caniuse.com/#search=grid)，我们不应该等待好多年，直到覆盖率达到 100％ 才在实际项目中使用它，因为那根本不存在。仅仅是因为 web 本就不是那么玩的。

[Grid 非常好用](https://gridbyexample.com/examples/)。现在就开始使用吧！

#### 截图

以下是各种浏览器的 demo 页面的截图：

[![](https://www.smashingmagazine.com/wp-content/uploads/2017/07/ie8_win7-large-opt.png)](https://www.smashingmagazine.com/wp-content/uploads/2017/07/ie8_win7-large-opt.png)

Internet Explorer 8, Windows 7

[![](https://www.smashingmagazine.com/wp-content/uploads/2017/07/ie9_win7-large-opt.png)](https://www.smashingmagazine.com/wp-content/uploads/2017/07/ie9_win7-large-opt.png)

Internet Explorer 9, Windows 7

[![](https://www.smashingmagazine.com/wp-content/uploads/2017/07/ie10_win7-large-opt.png)](https://www.smashingmagazine.com/wp-content/uploads/2017/07/ie10_win7-large-opt.png)

Internet Explorer 10, Windows 7

[![](https://www.smashingmagazine.com/wp-content/uploads/2017/07/ie11_win8-large-opt.png)](https://www.smashingmagazine.com/wp-content/uploads/2017/07/ie11_win8-large-opt.png)

Internet Explorer 11, Windows 8

[![](https://www.smashingmagazine.com/wp-content/uploads/2017/07/opera_mini-large-opt.png)](https://www.smashingmagazine.com/wp-content/uploads/2017/07/opera_mini-large-opt.png)

Opera Mini 42 (Extreme), Android 7

[![](https://www.smashingmagazine.com/wp-content/uploads/2017/07/uc_browser-large-opt.png)](https://www.smashingmagazine.com/wp-content/uploads/2017/07/uc_browser-large-opt.png)

UC Browser 11,  Android 7

#### 相关资料和深入阅读

- “[Crippling the Web](https://timkadlec.com/2013/07/crippling-the-web/)”，Tim Kadlec。
- “[Browser Support for Evergreen Websites](https://rachelandrew.co.uk/archives/2017/01/12/browser-support-for-evergreen-websites/)”，Rachel Andrew。
- [The Experimental Layout Lab of Jen Simmons](http://labs.jensimmons.com/) (demos), Jen Simmons
- “[World Wide Web, Not Wealthy Western Web, Part 1](https://www.smashingmagazine.com/2017/03/world-wide-web-not-wealthy-western-web-part-1/)”，Bruce Lawson。
- “[Resilience](https://www.youtube.com/watch?v=W7wj7EDrSko)” (video)，Jeremy Keith，View Source conference 2016。

**感谢我的导师 Aaron Gustafson 对我创作本文的帮助，感谢 Eva Lettner 的校对，感谢 Rachel Andre 无数的帖子、demo 和建议。**


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
