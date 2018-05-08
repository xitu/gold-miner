> * 原文地址：[How JavaScript works: the rendering engine and tips to optimize its performance](https://blog.sessionstack.com/how-javascript-works-the-rendering-engine-and-tips-to-optimize-its-performance-7b95553baeda)
> * 原文作者：[Alexander Zlatkov](https://blog.sessionstack.com/@zlatkov?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-javascript-works-the-rendering-engine-and-tips-to-optimize-its-performance.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-javascript-works-the-rendering-engine-and-tips-to-optimize-its-performance.md)
> * 译者：[stormluke](https://github.com/stormluke)
> * 校对者：[allenlongbaobao](https://github.com/allenlongbaobao)、[Usey95](https://github.com/Usey95)

# JavaScript 是如何工作的：渲染引擎和性能优化技巧

这是探索 JavaScript 及其构建组件专题系列的第 11 篇。在识别和描述核心元素的过程中，我们分享了在构建 [SessionStack](https://www.sessionstack.com/?utm_source=medium&utm_medium=blog&utm_content=js-series-rendering-engine-intro) 时使用的一些经验法则。SessionStack 是一个需要鲁棒且高性能的 JavaScript 应用程序，它帮助用户实时查看和重现它们 Web 应用程序的缺陷。

1. [[译] JavaScript 是如何工作的：对引擎、运行时、调用堆栈的概述](https://juejin.im/post/5a05b4576fb9a04519690d42)
2. [[译] JavaScript 是如何工作的：在 V8 引擎里 5 个优化代码的技巧](https://github.com/xitu/gold-miner/blob/master/TODO/how-javascript-works-inside-the-v8-engine-5-tips-on-how-to-write-optimized-code.md)
3. [[译] JavaScript 是如何工作的：内存管理 + 处理常见的4种内存泄漏](https://github.com/xitu/gold-miner/blob/master/TODO/how-javascript-works-memory-management-how-to-handle-4-common-memory-leaks.md)
4. [[译] JavaScript 是如何工作的: 事件循环和异步编程的崛起 + 5个如何更好的使用 async/await 编码的技巧](https://github.com/xitu/gold-miner/blob/master/TODO/how-javascript-works-event-loop-and-the-rise-of-async-programming-5-ways-to-better-coding-with.md)
5. [[译] JavaScript 是如何工作的：深入剖析 WebSockets 和拥有 SSE 技术 的 HTTP/2，以及如何在二者中做出正确的选择](https://github.com/xitu/gold-miner/blob/master/TODO/how-javascript-works-deep-dive-into-websockets-and-http-2-with-sse-how-to-pick-the-right-path.md)
6. [[译] JavaScript 是如何工作的：与 WebAssembly 一较高下 + 为何 WebAssembly 在某些情况下比 JavaScript 更为适用](https://github.com/xitu/gold-miner/blob/master/TODO1/how-javascript-works-a-comparison-with-webassembly-why-in-certain-cases-its-better-to-use-it.md)
7. [[译] JavaScript 是如何工作的：Web Worker 的内部构造以及 5 种你应当使用它的场景](https://github.com/xitu/gold-miner/blob/master/TODO/how-javascript-works-the-building-blocks-of-web-workers-5-cases-when-you-should-use-them.md)
8. [[译] JavaScript 是如何工作的：Web Worker 生命周期及用例](https://github.com/xitu/gold-miner/blob/master/TODO1/how-javascript-works-service-workers-their-life-cycle-and-use-cases.md)
9. [[译] JavaScript 是如何工作的：Web 推送通知的机制](https://github.com/xitu/gold-miner/blob/master/TODO1/how-javascript-works-the-mechanics-of-web-push-notifications.md)
10. [[译] JavaScript 是如何工作的：用 MutationObserver 追踪 DOM 的变化](https://github.com/xitu/gold-miner/blob/master/TODO1/how-javascript-works-tracking-changes-in-the-dom-using-mutationobserver.md)

当构建 Web 应用程序时，你不只是编写独立运行的 JavaScript 代码片段。你编写的 JavaScript 需要与环境进行交互。理解环境是如何工作的以及它是由什么组成的，你就能够构建更好的应用程序，并且能更好地处理应用程序发布后才会显现的潜在问题。

![](https://cdn-images-1.medium.com/max/800/1*lMBu87MtEsVFqqbfMum-kA.png)

那么，让我们看看浏览器的主要组件有哪些：

* **用户界面**：包括地址栏、后退和前进按钮、书签菜单等。实际上，它包括了浏览器中显示的绝大部分，除了你看到的网页本身的那个窗口。
* **浏览器引擎**：它处理用户界面和渲染引擎之间的交互。
* **渲染引擎**：它负责显示网页。渲染引擎解析 HTML 和 CSS，并在屏幕上显示解析的内容。
* **网络层**：诸如 XHR 请求之类的网络调用，通过对不同平台的不同的实现来完成，这些实现位于一个平台无关的接口之后。我们在本系列的[上一篇文章](https://blog.sessionstack.com/how-modern-web-browsers-accelerate-performance-the-networking-layer-f6efaf7bfcf4)中更详细地讨论了网络层。
* **UI 后端**：它用于绘制核心组件（widget），例如复选框和窗口。这个后端暴露了一个平台无关的通用接口。它使用下层的操作系统提供的 UI 方法。
* **JavaScript 引擎**：我们在[上一篇文章](https://blog.sessionstack.com/how-javascript-works-inside-the-v8-engine-5-tips-on-how-to-write -optimized-code-ac089e62b12e)中详细介绍了这一主题。基本上，这是 JavaScript 执行的地方。
* **数据持久化层**：你的应用可能需要在本地存储所有数据。其支持的存储机制包括 [localStorage](https://developer.mozilla.org/en-US/docs/Web/API/Window/localStorage)、[indexDB](https://developer.mozilla.org/en-US/docs/Web/API/IndexedDB_API)、[WebSQL](https://en.wikipedia.org/wiki/Web_SQL_Database) 和 [FileSystem](https://developer.mozilla.org/en-US/docs/Web/API/FileSystem)。

在这篇文章中，我们将关注渲染引擎，因为它负责处理 HTML 和 CSS 的解析和可视化，这是大多数 JavaScript 应用程序不断与之交互的地方。

#### 渲染引擎概述

渲染引擎的主要职责是在浏览器屏幕上显示所请求的页面。

渲染引擎可以显示 HTML / XML 文档和图像。如果你使用其他插件，它还可以显示不同类型的文档，例如 PDF。

#### 不同的渲染引擎

与 JavaScript 引擎类似，不同的浏览器也使用不同的渲染引擎。常见的有这些：

* **Gecko** — Firefox
* **WebKit** — Safari
* **Blink** — Chrome，Opera (版本 15 之后)

#### 渲染的过程

渲染引擎从网络层接收所请求文档的内容。

![](https://cdn-images-1.medium.com/max/800/1*9b1uEMcZLWuGPuYcIn7ZXQ.png)

#### 构建 DOM 树

渲染引擎的第一步是解析 HTML 文档并将解析出的元素转换为 **DOM 树** 中实际的 [DOM](https://developer.mozilla.org/en-US/docs/Web/API/Document_Object_Model/Introduction) 节点。

假设你有以下文字输入：

``` html
<html>
  <head>
    <meta charset="UTF-8">
    <link rel="stylesheet" type="text/css" href="theme.css">
  </head>
  <body>
    <p> Hello, <span> friend! </span> </p>
    <div> 
      <img src="smiley.gif" alt="Smiley face" height="42" width="42">
    </div>
  </body>
</html>
```

这个 HTML 的 DOM 树如下所示：

![](https://cdn-images-1.medium.com/max/800/1*ezFoXqgf91umls9FqO0HsQ.png)

基本上，每个元素都作为它所包含元素的父节点，这个结构是递归的。

#### 构建 CSSOM 树

CSSOM 指 **CSS 对象模型**。当浏览器构建页面的 DOM 时，它在 `head` 中遇到了一个引用外部 `theme.css` CSS 样式表的 `link` 标签。浏览器预计到它可能需要该资源来呈现页面，所以它立即发出请求。让我们假设 `theme.css` 文件包含以下内容：

```css
body { 
  font-size: 16px;
}

p { 
  font-weight: bold; 
}

span { 
  color: red; 
}

p span { 
  display: none; 
}

img { 
  float: right; 
}
```

与 HTML 一样，引擎需要将 CSS 转换为浏览器可以使用的东西 —— CSSOM。以下是 CSSOM 树的样子：

![](https://cdn-images-1.medium.com/max/800/1*5YU1su2mdzHEQ5iDisKUyw.png)

你知道为什么 CSSOM 是树型结构吗？当计算页面上对象的最终样式集时，浏览器以适用于该节点的最一般规则开始（例如，如果它是 body 元素的子元素，则应用 body 的所有样式），然后递归地细化，通过应用更具体的规则来计算样式。

让我们来看看具体的例子。包含在 `body` 元素内的 `span` 标签中的任何文本的字体大小均为 16 像素，并且为红色。这些样式是从 `body` 元素继承而来的。 如果一个 `span` 元素是一个 `p` 元素的子元素，那么它的内容就不会被显示，因为它被应用了更具体的样式（`display: none`）。

另外请注意，上面的树不是完整的 CSSOM 树，只显示了我们决定在样式表中重写的样式。每个浏览器都提供了一组默认的样式，也称为**「用户代理样式」**——这是我们在未明确指定任何样式时看到的样式。我们的样式会覆盖这些默认值。

#### 构建渲染树

HTML 中的视图指令与 CSSOM 树中的样式数据结合在一起用来创建**渲染树**。

你可能会问什么是渲染树。渲染树是一颗由可视化元素以它们在屏幕上显示的顺序而构成的树型结构。它是 HTML 和相应的 CSS 的可视化表示。此树的目的是为了以正确的顺序绘制内容。

渲染树中的节点被称为 Webkit 中的渲染器或渲染对象。

这就是上述 DOM 和 CSSOM 树的渲染器树的样子：

![](https://cdn-images-1.medium.com/max/800/1*WHR_08AD8APDITQ-4CFDgg.png)

为了构建渲染树，浏览器大致做了如下工作：

* 从 DOM 树的根开始，浏览器遍历每个可见节点。某些节点是不可见的（例如 script、meta 等），并且由于它们不需要渲染而被忽略。一些通过 CSS 隐藏的节点也从渲染树中省略。例如 span 节点 —— 在上面的例子中，它并不存在于渲染树中，因为我们明确地其上设置了 `display: none` 属性。
* 对于每个可见节点，浏览器找到适当的 CSSOM 规则并应用它们。
* 浏览器输出带有内容及其计算出的样式的可见节点

你可以在这里查看 RenderObject 的源代码（在 WebKit 中）：[https://github.com/WebKit/webkit/blob/fde57e46b1f8d7dde4b2006aaf7ebe5a09a6984b/Source/WebCore/rendering/RenderObject.h](https://github.com/WebKit/webkit/blob/fde57e46b1f8d7dde4b2006aaf7ebe5a09a6984b/Source/WebCore/rendering/RenderObject.h)

我们来看看这个类的一些核心内容：

```cpp
class RenderObject : public CachedImageClient {
  // Repaint the entire object.  Called when, e.g., the color of a border changes, or when a border
  // style changes.
  
  Node* node() const { ... }
  
  RenderStyle* style;  // the computed style
  const RenderStyle& style() const;
  
  ...
}
```

每个渲染器代表一个矩形区域，通常对应于一个节点的 CSS 盒模型。它包含几何信息，例如宽度、高度和位置。

#### 渲染树的布局

当渲染器被创建并添加到树中时，它并没有位置和大小。计算这些值的过程称为布局。

HTML 使用基于流的布局模型，这意味着大部分时间内它可以在一次遍历中（single pass）计算出布局。坐标系是相对于根渲染器的，使用左上原点坐标。

布局是一个递归过程 —— 它从根渲染器开始，对应于 HTML 文档的 `<html>` 元素，通过部分或整个渲染器的层次结构递归地为每个需要布局的渲染器计算布局信息。

根渲染器的位置是 `0,0`，并且其尺寸为浏览器窗口（也称为视口）的可见部分的尺寸。

开始布局过程意味着给出每个节点它应该出现在屏幕上的确切坐标。

#### 绘制渲染树

在这个阶段，浏览器遍历渲染器树，调用渲染器的 `paint()` 方法在屏幕上显示内容。

绘图可以是全局的或增量式的（与布局类似）：

* **全局** —— 整棵树被重画
* **增量式** —— 只有一些渲染器以不影响整个树的方式进行变更。渲染器在屏幕上标记其矩形区域无效，这会导致操作系统将其视为需要重绘并生成 `paint` 事件的区域。操作系统通过将几个区域合并为一个区域的智能方式来完成绘图。

一般来说，了解绘图是一个渐进的过程是很重要的。为了更好的用户体验，渲染引擎会尝试尽快在屏幕上显示内容。它不会等到所有的 HTML 被分析完毕才开始构建和布置渲染树。一小部分内容先被解析并显示，同时一边从网络获取剩下的内容一边渐进地渲染。

#### 处理脚本和样式表的顺序

当解析器到达 `<script>` 标签时，脚本将被立即解析并执行。文档解析将会被暂停，直到脚本执行完毕。这意味着该过程是**同步**的。

如果脚本是外部的，那么它首先必须从网络获取（也是同步的）。所有解析都会停止，直到网络请求完成。

HTML5 添加了一个选项，可以将脚本标记为异步，此时脚本被其他线程解析和执行。

#### 优化渲染性能

如果你想优化你的应用，那么你需要关注五个主要方面。这些是您可以控制的地方：

1. **JavaScript** —— 在之前的文章中，我们介绍了关于编写高性能代码的主题，这些代码不会阻塞 UI，并且内存效率高等等。当涉及渲染时，我们需要考虑 JavaScript 代码与页面上 DOM 元素交互的方式。JavaScript 可以在 UI 中产生大量的更新，尤其是在 SPA 中。
2. **样式计算** —— 这是基于匹配选择器确定哪个 CSS 规则适用于哪个元素的过程。一旦定义了规则，就会应用这些规则，并计算出每个元素的最终样式。
3. **布局** —— 一旦浏览器知道哪些规则适用于元素，就可以开始计算后者占用的空间以及它在浏览器屏幕上的位置。Web 的布局模型定义了一个元素可以影响其他元素。例如，`<body>` 的宽度会影响子元素的宽度等等。这一切都意味着布局过程是计算密集型的。该绘图是在多个图层完成的。
4. **绘图** —— 这里开始填充实际的像素。该过程包括绘制文本、颜色、图像、边框、阴影等 —— 每个元素的每个视觉部分。
5. **合成** —— 由于页面部件被划分为多层，因此需要按照正确的顺序将其绘制到屏幕上，以便正确地渲染页面。这非常重要，特别是对于重叠元素来说。

#### 优化你的 JavaScript

JavaScript 经常触发浏览器中的视觉变化，构建 SPA 时更是如此。

以下是关于可以优化 JavaScript 哪些部分来改善渲染性能的一些小提示：

* 避免使用 `setTimeout` 或 `setInterval` 进行视图更新。这些将在帧中某个不确定的时间点上调用 `callback`，可能在最后。我们想要做的是在帧开始时触发视觉变化而不是错过它。
* 将长时间运行的 JavaScript 计算任务移到 Web Workers 上，像我们之前[讨论过的](https://blog.sessionstack.com/how-javascript-works-the-building-blocks-of-web-workers-5-cases-when-you-should-use-them-a547c0757f6a?source=---------3----------------) 那样
* 使用微任务在多个帧中变更 DOM。这是为了处理在 Web Worker 中的任务需要访问 DOM，而 Web Worker 又不允许访问 DOM 的情况。就是说你可以将一个大任务分解为小任务，并根据任务的性质在 `requestAnimationFrame`、`setTimeout` 或 `setInterval` 中运行它们。

#### 优化你的 CSS

通过添加和删除元素、更改属性等来修改 DOM 会导致浏览器重新计算元素样式，并且在很多情况下还会重新布局整个页面或至少其中的一部分。

要优化渲染性能，请考虑以下方法：

* 减少选择器的复杂性。相对于构建样式本身的工作，复杂的选择器可能会让计算元素样式所需的时间增加 50％。
* 减少必须计算样式的元素的数量。本质上，直接对几个元素进行样式更改，而不是使整个页面无效。

#### 优化布局

布局的重新计算会对浏览器造成很大压力。请考虑下面的优化:

* 尽可能减少布局的数量。当你更改样式时，浏览器将检查是否需要重新计算布局。对属性的更改，如宽度、高度、左、上和其他与几何有关的属性，都需要重新布局。所以，尽量避免改变它们。
* 尽量使用 `flexbox` 而不是老的布局模型。它运行速度更快，可为你的应用程序创造巨大的性能优势。
* 避免强制同步布局。需要注意的是，在 JavaScript 运行时，前一帧中的所有旧布局值都是已知的并且可以查询。如果你查询 `box.offsetHeight` 是没问题的。 但是，如果你在查询元素之前更改了元素的样式（例如，动态向元素添加一些 CSS 类），浏览器必须先应用样式更改并执行布局过程。这可能非常耗时且耗费资源，因此请尽可能避免。

**优化绘图**

这通常是所有任务中运行时间最长的，因此尽可能避免这种情况非常重要。 以下是我们可以做的事情：

* 除了变换（transform）和透明度之外，改变其他任何属性都会触发重新绘图，请谨慎使用。
* 如果触发了布局，那也会触发绘图，因为更改布局会导致元素的视觉效果也改变。
* 通过图层提升和动画编排来减少重绘区域。

渲染是 [SessionStack](https://www.sessionstack.com/?utm_source=medium&utm_medium=blog&utm_content=js-series-rendering-engine-outro) 运行的重点之一。当用户浏览你的 web 应用遇到问题时，SessionStack 必须将这些遇到的问题重建成一个视频。为了做到这点，SessionStack 仅利用我们的库收集到数据：用户事件、DOM 更改、网络请求、异常和调试消息等。我们的播放器经过高度优化，能够按顺序正确呈现和使用所有收集到的数据，从视觉和技术两方面为你提供用户在浏览器中发生的一切的像素级完美模拟。

如果你想试试看，这里可以免费[尝试 SessionStack](https://www.sessionstack.com/signup/）。

![](https://cdn-images-1.medium.com/max/800/0*h2Z_BnDiWfVhgcEZ.)

#### 资源

* [https://developers.google.com/web/fundamentals/performance/critical-rendering-path/constructing-the-object-model](https://developers.google.com/web/fundamentals/performance/critical-rendering-path/constructing-the-object-model)
* [https://developers.google.com/web/fundamentals/performance/rendering/reduce-the-scope-and-complexity-of-style-calculations](https://developers.google.com/web/fundamentals/performance/rendering/reduce-the-scope-and-complexity-of-style-calculations)
* [https://www.html5rocks.com/en/tutorials/internals/howbrowserswork/#The_parsing_algorithm](https://www.html5rocks.com/en/tutorials/internals/howbrowserswork/#The_parsing_algorithm)


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
