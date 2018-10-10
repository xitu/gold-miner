> * 原文地址：[Inside look at modern web browser (part 3)](https://developers.google.com/web/updates/2018/09/inside-browser-part3)
> * 原文作者：[Mariko Kosaka](https://developers.google.com/web/resources/contributors/kosamari)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/inside-browser-part3.md](https://github.com/xitu/gold-miner/blob/master/TODO1/inside-browser-part3.md)
> * 译者：
> * 校对者：

# 现代浏览器内部揭秘（第三部分）

## 渲染进程的底层机制

这是关于浏览器工作原理博客系列四部分中的第三部分。之前，我们介绍了[多进程架构](https://github.com/xitu/gold-miner/blob/master/TODO1/inside-look-at-modern-web-browser-part1.md)和[导航流](https://github.com/xitu/gold-miner/blob/master/TODO1/inside-browser-part2.md)。在这篇文章中，我们将一探渲染进程的底层机制。

渲染流程涉及 Web 性能的许多方面。由于渲染流程的流程太复杂，因此本文只进行概述。如果你想深入了解，可以在 [the Performance section of Web Fundamentals](https://developers.google.com/web/fundamentals/performance/why-performance-matters/) 找到相关资源。

## 渲染进程处理网站内容

渲染进程负责标签页内发生的所有事情。在渲染进程中，主线程处理服务器发送到用户的大部分代码。如果你使用 web worker 或 service worker，部分 JavaScript 将由工作线程处理。合成和光栅线程也在渲染进程内运行，以高效，流畅地呈现页面。

渲染进程的核心工作是将 HTML，CSS 和 JavaScript 转换为用户可以与之交互的网页。

![Renderer process](https://developers.google.com/web/updates/images/inside-browser/part3/renderer.png)

图 1：渲染进程包含主线程、工作线程、合成线程和内部栅格线程

## 解析（Parsing）

### DOM 的构建

当渲染进程收到导航的提交消息并开始接收 HTML 数据时，主线程开始解析文本字符串（HTML）并将其转换为文档对象模型（**DOM**）。

DOM 是一个页面在浏览器内部表现，也是 Web 开发人员可以通过 JavaScript 与之交互的数据结构和 API。

将 HTML 到 DOM 的解释由 [HTML Standard](https://html.spec.whatwg.org/) 规定。你可能已经注意到，将 HTML 提供给浏览器这一过程从不会引发错误。像 `Hi! <b>I'm <i>Chrome</b>!</i>` 这样的错误标记，会被理解为 `Hi! <b>I'm <i>Chrome</i></b><i>!</i>`，这是因为 HTML 规范会优雅地处理这些错误。如果你好奇这是如何做到的，可以阅读 [An introduction to error handling and strange cases in the parser](https://html.spec.whatwg.org/multipage/parsing.html#an-introduction-to-error-handling-and-strange-cases-in-the-parser) 的 HTML 规范部分。

### 子资源加载

网站通常使用图像、CSS 和 JavaScript 等外部资源，这些文件需要从网络或缓存加载。在解析构建 DOM 时，主线程**会**按处理顺序逐个请求它们，但为了加快速度，“预加载扫描器（preload scanner）”会同时运行。如果 HTML 文档中有 `<img>` 或 `<link>` 之类的内容，则预加载扫描器会查看由 HTML 解析器生成的标记，并在浏览器进程中向网络线程发送请求。

![DOM](https://developers.google.com/web/updates/images/inside-browser/part3/dom.png)

图 2：主线程解析 HTML 并构建 DOM 树

### JavaScript 阻塞解析

当 HTML 解析器遇到 `<script>` 标记时，会暂停解析 HTML 文档，开始加载、解析并执行 JavaScript 代码。为什么？因为JavaScript 可以使用诸如 `document.write()` 的方法来改写文档，这会改变整个 DOM 结构（HTML 规范里的 [overview of the parsing model](https://html.spec.whatwg.org/multipage/parsing.html#overview-of-the-parsing-model) 中有一张不错的图片）。这就是 HTML 解析器必须等待 JavaScript 运行后再继续解析 HTML 文档原因。如果你对 JavaScript 执行中发生的事情感到好奇，可以看看 [V8 团队就此发表的演讲和博客文章](https://mathiasbynens.be/notes/shapes-ics)。

## 提示浏览器如何加载资源

Web 开发者可以通过多种方式向浏览器发送提示，以便很好地加载资源。如果你的 JavaScript 不使用 `document.write()`，你可以在 `<script>` 标签添加 [`async`](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/script#attr-async) 或 [`defer`](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/script#attr-defer) 属性，这样浏览器会异步加载运行 JavaScript 代码，而不阻塞解析。如果合适，你也可以使用 [JavaScript 模块](https://developers.google.com/web/fundamentals/primers/modules)。可以使用 `<link rel="preload">` 告知浏览器当前导航肯定需要该资源，并且你希望尽快下载。有关详细信息请参阅 [Resource Prioritization – Getting the Browser to Help You](https://developers.google.com/web/fundamentals/performance/resource-prioritization)。

## 样式计算

只拥有 DOM 不足以确定页面的外观，因为我们会在 CSS 中设置页面元素的样式。主线程解析 CSS 并确定每个 DOM 节点计算后的样式。这是有关基于 CSS 选择器对每个元素将哪种样式的信息，这可以在 DevTools 的 `computed` 部分中看到。

![computed style](https://developers.google.com/web/updates/images/inside-browser/part3/computedstyle.png)

图 3：主线程解析 CSS 以添加计算后样式

即使你不提供任何 CSS，每个 DOM 节点都具有计算样式。像 `<h1>` 标签看起来比 `<h2>` 标签大，每个元素都有 margin，这是因为浏览器具有默认样式表。如果你想知道更多 Chrome 的默认 CSS，[可以在这里看到源代码](https://cs.chromium.org/chromium/src/third_party/blink/renderer/core/css/html.css)。

## 布局

现在，渲染进程知道每个节点的样式和文档的结构，但这不足以渲染页面。想象一下，你正试图通过手机向朋友描述一幅画：“这里有一个大红圈和一个小蓝方块”，这并不能让你的朋友了解这幅画看起来怎样。

![game of human fax machine](https://developers.google.com/web/updates/images/inside-browser/part3/tellgame.png)

图 4：一个人站在一幅画前，电话线与另一个人相连

布局是查找元素几何的过程。主线程遍历 DOM，计算样式并创建布局树，其中包含 x y 坐标和边界框大小等信息。布局树可能与 DOM 树结构类似，但它仅包含页面上可见内容相关的信息。如果一个元素应用了 `display：none`，那么该元素不是布局树的一部分（但 `visibility：hidden` 的元素在布局树中）。类似地，如果应用了如 `p::before{content:"Hi!"}` 的伪类，则即使它不在 DOM 中，也包含于布局树中。

![layout](https://developers.google.com/web/updates/images/inside-browser/part3/layout.png)

图 5：主线程遍历计算样式后的 DOM 树，以此生成布局树

![layout.gif](https://i.loli.net/2018/10/07/5bb97fd790c18.gif)

图 6：由于换行而移动的盒子布局

确定页面布局是一项很有挑战性的任务。即使是从上到下的块流这样最简单的页面布局，也必须考虑字体的大小以及换行位置，这些因素会影响段落的大小和形状，进而影响下一个段落的位置。

CSS 可以使元素浮动到一侧、隐藏溢出的元素、更改书写方向。你可以想象这一阶段的任务之艰巨。Chrome 浏览器有整个工程师团队负责布局。[BlinkOn 会议的一些访谈](https://www.youtube.com/watch?v=Y5Xa4H2wtVA) 记录了他们工作的细节，有兴趣可以了解一下，挺有趣的。

## 绘制

![drawing game](https://developers.google.com/web/updates/images/inside-browser/part3/drawgame.png)

图 7：一个人拿着笔站在画布前，思考着她应该先画圆形还是先画方形

拥有 DOM、样式和布局仍然不足以渲染页面。假设你正在尝试重现一幅画。你知道元素的大小、形状和位置，但你仍需要判断绘制它们的顺序。

例如，可以为某些元素设置 `z-index`，此时按 HTML 中编写的元素的顺序绘制会导致错误的渲染。

![z-index fail](https://developers.google.com/web/updates/images/inside-browser/part3/zindex.png)

图 8：因为没有考虑 z-index，页面元素按 HTML 标记的顺序出现，导致错误的渲染图像

在绘制步骤中，主线程遍历布局树创建绘制记录。绘制记录是绘图过程的记录，就像是“背景优先，然后是文本，然后是矩形”。如果你使用过 JavaScript 绘制了 `<canvas>` 元素，那么这个过程对你来说可能很熟悉。

![paint records](https://developers.google.com/web/updates/images/inside-browser/part3/paint.png)

图 9：主线程遍历布局树并生成绘制记录

### 更新渲染管道的成本很高

![trees.gif](https://i.loli.net/2018/10/07/5bb97fa48681e.gif)

图 10：DOM + Style、布局和绘制树的生成顺序

渲染管道中最重要的事情是：每个步骤中，前一个操作的结果用于后一个操作创建新数据。例如，如果布局树中的某些内容发生改变，需要为文档的受影响部分重新生成“绘制”指令。

如果要为元素设置动画，则浏览器必须在每个帧之间运行这些操作。大多数显示器每秒刷新屏幕 60 次（60 fps），当屏幕每帧都在变化，人眼会觉得动画很流畅。但是，如果动画丢失了中间一些帧，页面看起来就会卡顿（janky）。

![jage jank by missing frames](https://developers.google.com/web/updates/images/inside-browser/part3/pagejank1.png)

图 11：时间轴上的动画帧

即使渲染操作能跟上屏幕刷新，这些计算也会在主线程上运行，这意味着当你的应用程序运行 JavaScript 时动画可能会被阻塞。

![jage jank by JavaScript](https://developers.google.com/web/updates/images/inside-browser/part3/pagejank2.png)

图 12：时间轴上的动画帧，但 JavaScript 阻塞了一帧

你可以将 JavaScript 操作划分为小块，并使用 `requestAnimationFrame()` 在每个帧上运行。有关此主题的更多信息，请参阅 [Optimize JavaScript Execution](https://developers.google.com/web/fundamentals/performance/rendering/optimize-javascript-execution)。你也可以[在 Web Worker 中运行 JavaScript](https://www.youtube.com/watch?v=X57mh8tKkgE) 以避免阻塞主线程。

![request animation frame](https://developers.google.com/web/updates/images/inside-browser/part3/raf.png)

图 13：时间轴上较小的 JavaScript 块与动画帧一起运行

## 合成

### 如何绘制一个页面？

![naive_rastering.gif](https://i.loli.net/2018/10/07/5bb9802e63e9d.gif)

图14：简单光栅处理示意动画

现在浏览器知道文档的结构、每个元素的样式、页面的几何形状和绘制顺序，它是如何绘制页面的？把这些信息转换为屏幕上的像素，我们称为光栅化。

也许处理这种情况的一种简单的方法是在视口内部使用栅格部件。如果用户滚动页面，则移动光栅框架，并通过光栅化填充缺少的部分。这就是 Chrome 首次发布时处理栅格化的方式。但是，现代浏览器会运行一个更复杂的过程，我们称为合成。

### 什么是合成

![composit.gif](https://i.loli.net/2018/10/07/5bb980e92bb7c.gif)

图 15：合成处理示意动画

合成是一种将页面的各个部分分层，分别栅格化，并在称为合成线程的单独线程中合成为页面的技术。如果发生滚动，由于图层已经光栅化，因此它所要做的只是合成一个新帧。动画也可以以相同的方式（移动图层和合成新帧）实现。

你可以在 DevTools 使用 [Layers 面板](https://blog.logrocket.com/eliminate-content-repaints-with-the-new-layers-panel-in-chrome-e2c306d4d752?gi=cd6271834cea) 看看你的网站如何被分层。

### 分层

为了分清哪些元素位于哪些图层，主线程遍历布局树创建图层树（此部分在 DevTools 性能面板中称为“Update Layer Tree”）。如果页面的某些部分应该是单独图层（如滑入式侧面菜单）但没拆分出来，你可以使用 CSS 中的 `will-change` 属性来提示浏览器。

![layer tree](https://developers.google.com/web/updates/images/inside-browser/part3/layer.png)

图 16：主线程遍历布局树生成图层树

你可能想要为每个元素都分层，但是合成大量的图层 可能会比每帧都光栅化页面的刷新方式更慢，因此测量应用程序的渲染性能至关重要。有关这个主题的更多信息，请参阅 [Stick to Compositor-Only Properties and Manage Layer Count](https://developers.google.com/web/fundamentals/performance/rendering/stick-to-compositor-only-properties-and-manage-layer-count)。

### 主线程的光栅化和合成

一旦创建了图层树并确定了绘制顺序，主线程就会将该信息提交给合成线程。接着，合成线程会光栅化每个图层。一个图层可能会跟整个页面一样大，因此合成线程将它们分块后发送到光栅线程。栅格线程栅格化每个小块后会将它们存储在显存中。

![raster](https://developers.google.com/web/updates/images/inside-browser/part3/raster.png)

图17：光栅线程创建分块的位图并发送到 GPU

合成线程会按优先度处理不同的光栅线程，以便视窗（或附近）内的画面可以先被光栅化。图层还具有多个不同分辨率的块，可以处理放大操作等动作。

一旦块被光栅化，合成线程会收集这些块的信息（称为**绘制四边形**）创建**合成帧**。

绘制四边形

包含诸如图块在内存中的位置，以及合成时绘制图块在页面中的位置等信息。

合成帧

一个绘制四边形的集合，代表一个页面的一帧。

接着，合成帧通过 IPC（进程间通讯）提交给浏览器进程。此时，可以从 UI 线程或其他插件的渲染进程添加另一个合成帧 。这些合成器帧被发送到 GPU 然后在屏幕上显示。如果接收到滚动事件，合成线程会创建另一个合成帧发送到 GPU。

![composit](https://developers.google.com/web/updates/images/inside-browser/part3/composit.png)

图 18：合成线程创建合成帧，将其发送到浏览器进程，再接着发送到 GPU

合成的好处是它可以在不涉及主线程的情况下完成。合成线程不需要等待样式计算或 JavaScript 执行。这就是为什么[仅合成动画](https://www.html5rocks.com/en/tutorials/speed/high-performance-animations/)被认为是流畅性能的最佳选择。如果需要再次计算布局或绘制，则必须涉及主线程。

## 总结

在这篇文章中，我们研究了从解析到合成的渲染管道。希望你现在已经有初步了解，可以进一步挖掘网站性能优化的更多信息。

在本系列的下一篇也是最后一篇文章中，我们将更详细地介绍合成线程，看看当用户移动或点击鼠标时会发生什么。

你喜欢这篇文章吗？如果你对之后的文章有任何问题或建议，我很乐意在下面的评论部分或推特 [@kosamari](https://twitter.com/kosamari) 与你联系。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。

