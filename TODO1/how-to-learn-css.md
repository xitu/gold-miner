> * 原文地址：[How To Learn CSS](https://www.smashingmagazine.com/2019/01/how-to-learn-css/)
> * 原文作者：[Rachel Andrew](https://www.smashingmagazine.com/author/rachel-andrew)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-learn-css.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-learn-css.md)
> * 译者：[Mcskiller](https://github.com/Mcskiller)
> * 校对者：[Reaper622](https://github.com/Reaper622), [Qiuk17](https://github.com/Qiuk17)

# 如何学习 CSS

摘要：你不需要强行记住每一个 CSS 属性和值，有很多地方可以方便你快速去查阅。但是记住一些基础的知识点会让你使用起来更加得心应手。本文旨在引导你如何学习 CSS。

我遇到很多人叫我给他们推荐 CSS 各个知识点的教程，或者问我应该怎么学习 CSS。我也看到很多人对 CSS 的部分内容感到困惑，一部分原因是因为他们对语言的过时认知。鉴于 CSS 在过去的几年间改变了很多，也是时候来更新你掌握的知识了。即便 CSS 只占你所做工作的一小部分（因为你在栈的别处工作），CSS 就像你想他们最终在屏幕上看到的那样，所以值得合理更新。

因此，本文旨在概述 CSS 的要点以及提供一些资源，以进一步学习现代 CSS 开发的主要内容。其中许多都是 Smashing Magazine 上的东西，但我也提供了其他的一些资源，其中包括人们关注的 CSS 要点。这不是一个完整的初学者指南或者绝对涵盖所有知识点的文章。我的目标是以几个重要知识点展示现代 CSS 的广度，这将有助于你学习其他语言。

### 语言基础知识

对于 CSS 的大部分内容，你不需要担心学习属性和值。你可以在需要时查找它们。然而，学习 CSS 需要一些关键的基础知识，如果没有这些基础，你会很难去理解它。所以它真的值得你去花时间理解，从长远来看，它将会为你的学习带来诸多便利。

#### 选择器，不仅仅是 Class

选择器顾名思义，它 **选择** 文档的某些部分，以便你可以将 CSS 应用到上面。虽然大多数人都熟悉使用 Class，或者直接设置诸如 `body` 之类的 HTML 元素，但是这里还有大量更高级的选择器可以根据文档中的位置来选择元素，可能是因为它们在某些元素的后边，也可能是表格中的奇数行。

Level 3 规范中的选择器（你也许听过它们被称为 Level 3 选择器）具有 [优秀的浏览器兼容性](https://caniuse.com/#feat=css-sel3)。更多有关使用各种选择器的详细信息，请参考 [MDN Reference](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Selectors)。

一些选择器的效果就像你在文档中运用 class 选择器一样。例如，`p:first-child` 就像你在第一个 `p` 元素中添加了一个 class 一样，这些被称为 **伪类** 选择器。**伪元素** 选择器就好像一个元素是动态插入的，例如 `::first-line` 的作用方式就类似于在第一行文本周围包裹 `span`。但是，如果这一行的长度发生了变化，它将会重新应用，如果插入该元素则不会出现这种情况。这些选择器可能会非常复杂，在下面的 CodePen 中是一个伪元素用伪类链接的例子。我们使用 `:first-child` 伪类定位第一个 `p` 元素，然后使用 `::first-line` 选择器选择该元素的第一行，就好像在第一行的周围添加了一个 span 让它变粗并改变颜色。

查看由 Rachel Andrew（[@rachelandrew](https://codepen.io/rachelandrew)）在 [CodePen](https://codepen.io) 上编写的例子 —— [第一行](https://codepen.io/rachelandrew/pen/wRdJdQ)。

#### 继承和层叠

当有许多规则应用于一个元素上时，层叠决定了到底按哪一个规则执行。如果你曾经无法理解一些 CSS 样式为什么没有被应用，那可能是因为你没有理解层叠的概念。层叠与继承密切相关，它定义了哪些属性是应该被子元素继承的。它也和优先级有关：不同的选择器有不同的优先级，当有多个选择器可以应用到同一个元素上时，优先级决定了哪一个能够被成功应用。

**提示**：要是想了解全部内容，推荐去看看 MDN 的 CSS 简介中的 [层叠和继承](https://developer.mozilla.org/zh-CN/docs/Learn/CSS/Introduction_to_CSS/Cascade_and_inheritance)。

如果你正努力将一些 CSS 样式应用到一个元素上，那么使用浏览器的开发者工具是最佳方法，看看下面的例子，其中有一个 `h1` 元素由 `h1` 选择器选择并将标题设置为橙色。我还使用了一个 class 设置 `h1` 颜色为 rebeccapurple。这个 class 优先级更高，所以 `h1` 是紫色的。在开发者工具中，你可以看见元素选择器被划掉，因为它并没有被应用。所以现在一旦你看见浏览器开始应用你的 CSS（但其他东西阻止了它导致没有正常显示），你就可以找到原因了。

查看由 Rachel Andrew（[@rachelandrew](https://codepen.io/rachelandrew)）在 [CodePen](https://codepen.io) 上编写的例子 —— [优先级](https://codepen.io/rachelandrew/pen/yGbMoL)。

[![The DevTools in Firefox showing rules for the h1 selector crossed out](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/2720c905-e734-4d57-9ae8-fb4bab1de633/smashing-css-specificity.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/2720c905-e734-4d57-9ae8-fb4bab1de633/smashing-css-specificity.png) 

开发者工具可以帮助你查看为什么有些 CSS 样式没有成功应用到元素上（[查看原图](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/2720c905-e734-4d57-9ae8-fb4bab1de633/smashing-css-specificity.png)）

#### 盒模型

CSS 都是关于盒子的。每个显示在屏幕上的东西都有一个框，盒模型描述了如何计算出框的大小 —— 考虑 margin，padding，和 border。标准的 CSS 盒模型使用给定的元素宽度，然后在该宽度加上 padding 和 border 的宽度 —— 也就是说元素占据的空间比你设定的宽度要大。

最近，我们已经可以选择使用 `border-box` 盒模型，该模型使用元素上给定的宽度作为屏幕上可见元素的宽度。任何 padding 或者 border 上的设置都将从边缘向内进行设置。这让许多布局更加便利。

在下面的 Demo 中有两个盒子。它们的宽度都是 200px，其中 border 是 5px，padding 是 20px。第一个盒子使用的是基础盒模型，所以总体宽度是 250px。第二个盒子使用的是 `border-box` 盒模型，所以实际宽度就是 200px。

查看由 Rachel Andrew（[@rachelandrew](https://codepen.io/rachelandrew)）在 [CodePen](https://codepen.io) 上编写的例子 —— [盒模型](https://codepen.io/rachelandrew/pen/xmdqjd)。

浏览器的开发者工具能够再一次帮助你了解你正在使用的盒模型。下面的图片中，我使用 Firefox 的开发者工具去检查默认的 `content-box` 盒模型。开发者工具告诉我这是一个正在使用的盒模型然后我能够看见它的大小和我设定的 border 和 padding 是怎样添加到宽度上的。

[![The Box Model Panel in Firefox DevTools](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/52f5291d-fb2e-4418-99a7-002f898053aa/smashing-css-box-model.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/52f5291d-fb2e-4418-99a7-002f898053aa/smashing-css-box-model.png) 

开发者工具帮助你了解盒子为何具有特定尺寸，以及你正在使用的盒模型（[查看原图](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/52f5291d-fb2e-4418-99a7-002f898053aa/smashing-css-box-model.png)）

**提示**：在 IE6 之前，[Internet Explorer 默认使用 `border-box` 盒模型](https://en.wikipedia.org/wiki/Internet_Explorer_box_model_bug)，padding 和 border 让内容偏离了给定的宽度。所以在那段时间许多浏览器都在使用不同的盒模型！不过现在你不必为了浏览器之间的互通所担心，事情已经有所改善，我们已经不需要因为浏览器的不同而使用不同方法计算宽度。

在 CSS Tricks 上有一篇很好的对于 [盒模型及其大小](https://css-tricks.com/box-sizing/) 的解释，以及在你的站点中 [全局使用 border-box 盒模型](https://css-tricks.com/inheriting-box-sizing-probably-slightly-better-best-practice/) 的最佳方法。

#### 常规流

如果你的文档由一些 HTML 标签组成然后你在浏览器中打开它，它应该是有可读性的。标题和段落会从一个新行开始，单词中间由空格隔开组成句子。用于格式化的标签，就像 `em`，不会破坏一句话的流。这些内容都以 [常规流布局](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Flow_Layout) 或者说块状流布局展示。每一部分内容都处于“流”中；每一个元素都会依次排放，不会重叠在一起。

如果你合理运用这种特性的话，你的工作将会变得更加轻松。这也是为什么 [从正确标记的 HTML 文档开始](https://www.brucelawson.co.uk/2018/the-practical-value-of-semantic-html/) 有道理的原因之一，由于常规流和内置样式表被浏览器所遵守，你的内容会从可读的地方开始。

#### 格式化上下文

一旦你有了一个使用常规流布局的文档，你也许会想改变某些内容的外观。那么你可以通过修改元素的格式化上下文来进行改变。举一个简单的例子，如果你想所有段落都连在一起而不是每一段都新建一行，你可以将 `p` 元素设定为 `display: inline` 将其从块更改为行内格式化上下文。

格式化上下文基本上定义了容器外部和内部类型。外部控制元素与页面上其他元素的共同表现，内部控制子元素的外观。打个比方，当你设定 `display: flex` 时，你设定外部为块级格式化上下文，并且子元素为 flex 格式化上下文。

**提示**：最新版本的 Display 规范更改 `display` 来显式的声明内部和外部值。因此，以后你可能会用到 `display: block flex;`（`block` 是外部的，`flex` 是内部的）。

在 MDN 上阅读更多有关 [`display`](https://developer.mozilla.org/en-US/docs/Web/CSS/display) 的内容。

#### 进入或脱离常规流

CSS 中的元素可以被分为，“在流中”或者“脱离流”。流中的元素被赋予了不被其他元素干扰的独立空间。如果你通过调整浮动或者定位让一个元素脱离流，那么它的空间可能会被其他在流中的元素占用。

对于使用绝对定位的元素，这是最明显的。如果你设定一个元素 `position: absolute` 那它就脱离流了，然后你需要去保证脱离流的元素没有和流中的元素重叠，不然你的布局可能会变得难以理解。

查看由 Rachel Andrew（[@rachelandrew](https://codepen.io/rachelandrew)）在 [CodePen](https://codepen.io) 上编写的例子 —— [脱离流：绝对定位](https://codepen.io/rachelandrew/pen/Ormgzj)。

然而，浮动元素也会脱离流，然后后续的内容将会围绕浮动元素的盒边线布局，你可以通过在后面元素的盒中设置背景颜色来看到它们已经提升位置并且忽略了之前的浮动元素的空间。

查看由 Rachel Andrew（[@rachelandrew](https://codepen.io/rachelandrew)）在 [CodePen](https://codepen.io) 上编写的例子 —— [脱离流：浮动](https://codepen.io/rachelandrew/pen/BvRZYw)。

你可以在 MDN 上阅读更多关于 [在流中和脱离流的元素](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Flow_Layout/In_Flow_and_Out_of_Flow) 的内容。要记住的重要一点是，如果你让一个元素脱离流，你需要自己去管理元素是否重叠，因为块级流布局不再适用。

### 布局

十五年来，我们一直在 CSS 中进行布局而没有一个专门设计的布局系统。现在这一切已经发生了改变。我们现在拥有了一个功能完善的布局系统包括 Grid 和 Flexbox，还有多列布局和用于实际目的的旧布局方案。如果你还不理解 CSS 布局，请移步 MDN [学习布局](https://developer.mozilla.org/en-US/docs/Learn/CSS/CSS_layout) 或者在 Smashing Magazine 查阅我的文章 [从零开始的 CSS 布局](https://www.smashingmagazine.com/2018/05/guide-css-layout/)。

**不要以为像 grid 和 flexbox 这样的方法在某种程度上来说是竞争关系**。为了更好的布局，你可能会发现有时候适合使用 flex 组件有时候又适合使用 grid。有时，你也会想要使用多列布局。所有这些都只是你的可选项。如果你感觉一种布局不太合适，通常情况下这是一个好现象，说明你应该去试试其他不同的布局方案。我们习惯于“矫正” CSS 样式来达到想要的效果，而导致我们忘记了本来就有的那些可选项。

布局是我的主要专业领域，我在 Smashing Magazine 和其他地方写了很多文章来帮助掌握新的布局。除了上面我提到的布局文章，我还有一个 Flexbox 系列文章 —— 从 [当你在创建一个 Flexbox 伸缩容器时会发生什么](https://www.smashingmagazine.com/2018/08/flexbox-display-flex-container/) 开始。在 [Grid by Example](https://gridbyexample.com) 上，我有一大堆 CSS Grid 的小例子 —— 以及一个视频教程。

此外 —— 特别是设计师们 —— 请查看 [Jen Simmons](https://twitter.com/jensimmons) 和她的 [Layout Land 系列视频](https://www.youtube.com/channel/UC7TizprGknbDalbHplROtag)。

#### 对齐

我一般把对齐和布局分开，不过我们大多数人都是把对齐作为 Flexbox 的一部分来看的，其实这些属性可以应用到任何一个布局方法上，认真学习以下部分比思考用“Flexbox 对齐”或者或者"CSS Grid 对齐"要好得多。我们有一组对齐属性可以在日常中使用；不过由于不同的布局它们的效果可能会有些许不同。

在 MDN 上，你可以深入研究 [盒对齐](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Box_Alignment) 以及它是如何在 Grid（网格布局），Flexbox（弹性布局），Multicol（多行布局）和 Block 布局（块布局）中实现的。在 Smashing Magazine 上，我有一篇专门介绍 Flexbox 对齐的文章：[Flexbox 中有关对齐你需要知道的一切](https://www.smashingmagazine.com/2018/08/flexbox-alignment/)。

#### 尺寸

我在 2018 年中的大部分时间都在谈论内部和外部尺寸规范，以及它与 Grid 和 Flexbox 的关系。在 Web 开发中，我们习惯于使用固定长度或者百分比来设置尺寸，因为这是我们能够做到的使用数值完成的网格类布局。但是，现代布局方式能帮我们完成很多空间操作 —— 只要我们让它们这么做。理解 Flexbox 如何分配空间（或者 Grid 的 `fr` 单位是如何工作）是很有必要的。

在 Smashing Magazine 中，我写了几篇文章，关于 [布局中的尺寸](https://www.smashingmagazine.com/2018/01/understanding-sizing-css-layout/) 以及适用于 Flexbox 的 [那个弹性盒子有多大？](https://www.smashingmagazine.com/2018/09/flexbox-sizing-flexible-box/)

### 响应式设计

我们的新布局方法 Grid 和 Flexbox 与我们老的布局方法相比，会使用更少的媒体查询，因为它们是灵活的，不需要我们去修改元素的宽度，它们会根据视图或者组件大小进行自适应。但是你可能会希望在某些地方添加断点来增强你的设计。

这里是一些简单的 [响应式设计](https://responsivedesign.is/) 指南，查看我的文章 [在 2018 年使用媒体查询来进行响应式设计](https://www.smashingmagazine.com/2018/02/media-queries-responsive-design-2018/)。我介绍了一下媒体查询的许多用法，以及一些未来在 Level 4 中会出现的新媒体查询功能。

### 字体和排版

和布局一样，网络上关于字体的使用在去年也发生了巨大的变化。可变的字体在这里让单个字体文件可以产生无数种变体。想了解它们是什么以及它们的工作方式，请查看 [Mandy Michael](https://twitter.com/mandy_kerr) 的精彩讲解：[可变字体和 web 设计的未来](https://www.youtube.com/watch?v=luAqYCd_TC8)。另外，我还推荐去看看 [Jason Pamental](https://twitter.com/jpamental) 的 [动态排版与现代 CSS 和可变字体](https://noti.st/jpamental/WNNxqQ/dynamic-typography-with-modern-css-variable-fonts)。

想要探索可变字体和它们的功能，可以去看看 [来自微软的一个有趣的演示](https://developer.microsoft.com/en-us/microsoft-edge/testdrive/demos/variable-fonts/) 提供了许多案例来尝试可变字体 —— [Axis Praxis](https://www.axis-praxis.org/) 就是一个知名的例子（我还喜欢 [Font Playground](https://play.typedetail.com/)）。

当你开始使用可变字体时，这篇 [MDN 上的指南](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Fonts/Variable_Fonts_Guide) 可以给你一些帮助。以及阅读 Oliver Schöndorfer 的 [使用备选 Web 字体实现可变字体](https://www.zeichenschatz.net/typografie/implementing-a-variable-font-with-fallback-web-fonts.html) 学习如何给不支持可变字体的浏览器返回解决方案。[Firefox 开发者工具字体编辑器](https://developer.mozilla.org/en-US/docs/Tools/Page_Inspector/How_to/Edit_fonts) 也支持可变字体。

### 变形和动画

CSS 变形和动画绝对是我们所需要知道的基础内容。我不经常使用它们，语法已经消失在了我的脑海中。不过谢天谢地，MDN 上的资料帮助了我，我也建议直接从 MDN 上的指南 [使用 CSS 变形](https://developer.mozilla.org/zh-CN/docs/Web/CSS/CSS_Transforms/Using_CSS_transforms) 和 [使用 CSS 动画](https://developer.mozilla.org/zh-CN/docs/Web/CSS/CSS_Animations/Using_CSS_animations) 开始。[Zell Liew](https://twitter.com/zellwk) 也有一篇优秀的文章 [解释 CSS 过渡](https://zellwk.com/blog/css-transitions/)。

想发掘一些有趣的内容，请访问 [Animista](http://animista.net/)。

关于动画可能最令人困扰的就是应该怎么去实现。除了 CSS 的部分，你可能还需要涉及到 JavaScript，SVG，或者 Web Animation API，这些事情可能往往会被混为一谈，在 An Event Apart 录制的 [选择你的动画冒险](https://aneventapart.com/news/post/choose-your-animation-adventure-by-val-head-aea-video) 中 [Val Head](https://twitter.com/vlh) 解释了这些。

### 使用小抄作提示，而不是学习工具

当我提到 Grid 或者 Flexbox 资源时，我经常看到有回复说它们 **不能** 在没有特定小抄的情况下使用 Flexbox。我不反对使用小抄来帮助记忆语法，我也分享了我自己的一些小抄。主要问题是，在你照着小抄复制代码时你很可能会忘记思考它是如何做到的。然后，当你遇到一个属性实现出了意想不到的效果时，你会感到莫名其妙甚至觉得可能是这个语言的问题。

如果你发现自己的 CSS 在做一些奇怪的事情时，大胆的问 **为什么**。创建一个简单的测试用例来突出显示问题，问问更加熟悉规范的人。我被问到的许多 CSS 的问题都是因为使用者坚信代码正在以不同的方式在运行。这也是我为什么要谈论对齐和尺寸，许多问题就出在这些地方。

没错，CSS 中确实有一些奇怪的问题。这是一个多年来都在不断发展的语言，有些事情我们不能改变 —— [除非我们有时光机](https://wiki.csswg.org/ideas/mistakes)。但是，一旦你掌握了这些基础知识，然后理解了其中的原理，你就能更轻松的处理这些问题。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
