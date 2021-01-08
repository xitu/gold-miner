> * 原文地址：[The Anatomy of a Frame](https://aerotwist.com/blog/the-anatomy-of-a-frame/)
> * 原文作者：[Paul](https://twitter.com/aerotwist)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/the-anatomy-of-a-frame.md](https://github.com/xitu/gold-miner/blob/master/TODO1/the-anatomy-of-a-frame.md)
> * 译者：[WangLeto](https://github.com/WangLeto)
> * 校对者：[Xuyuey](https://github.com/Xuyuey), [Fengziyin1234](https://github.com/Fengziyin1234), [L9m](https://github.com/L9m)

# 浏览器帧原理剖析

开发者常常问我关于像素工作流程的某些部分，什么时候、为什么、发生了什么。所以我感觉值得提供一些参考，有关于将像素显示在屏幕上的过程里发生了什么。

警告：文本是 Blink（译注：Chrome 使用的排版引擎，是 webkit 的分支）和 Chrome 的视角。主线程的大部分任务以某种方式被所有第三方（vendors）任务“共享”，比如布局和样式计算结果，但是总的架构可能不是这样。

## 一图胜千言

这是真的，让我们先看一张图：

![The process of getting pixels to screen.](https://aerotwist.com/static/blog/the-anatomy-of-a-frame/anatomy-of-a-frame.svg)

将像素放到屏幕上的完整过程。

[下载图片](https://aerotwist.com/static/blog/the-anatomy-of-a-frame/anatomy-of-a-frame.zip)

## 进程

这张小图上放了太多内容，所以让我们详细看些定义。将上图与这些定义结合起来可能会有帮助。

让我们从进程开始看：

*  **渲染进程**。包裹标签页的容器。包含了多个线程，这些线程一起负责了页面显示到屏幕上的各个方面。这些线程有**合成线程（Compositor）**，**图块栅格化线程（Tile Worker）**，和**主线程**。
*  **GPU 进程**。这是一个单一的进程，为所有标签页和浏览器周边进程服务。当帧被提交时，GPU 进程会将分为图块的位图和其他数据（比如四边形顶点和矩阵）上传到 GPU 中，真正将像素显示到屏幕上。GPU 进程只有一个的线程，叫 GPU 线程，实际上是它做了这些工作。

## 渲染进程中的线程

现在看一下渲染进程中的线程。

*  **合成线程（Compositor Thread）**。这是最先被告知垂直同步事件（vsync event，操作系统告知浏览器刷新一帧图像的信号）的线程。它接收所有的输入事件。如果可能，合成线程会避免进入主线程，自己尝试将输入的事件（比如滚动）转换为屏幕的移动。它会更新图层的位置，并经由 GPU 线程直接向 GPU 提交帧来完成这个操作。如果输入事件需要进行处理，或者有其他的显示工作，它将无法直接完成该过程，这就需要主线程了。
*  **主线程**。在这里浏览器执行我们熟知和喜欢的那些任务：JavaScript，样式，布局和绘制。（这一点以后会变化，有了 [Houdini](https://surma.link/things/houdini-intro/)，我们可以在合成线程中运行一些代码）主线程荣获“最容易导致 jank 奖”，很大程度上是因为它要做的事情太多了这个事实。（译注：jank 指页面内容抖动卡顿，由于页面内容的更新频率跟不上屏幕刷新频率导致）
*  **合成图块栅格化线程（Compositor Tile Worker）**。由合成线程派生的一个或多个线程，用于处理栅格化任务。我们稍后再讨论。

在许多方面，你都应该把合成线程看做“老大”。虽然这个线程不运行 JavaScript，不进行布局、绘制内容或者其他任务，但是它全权负责启动主线程工作，并将帧运送到屏幕上。如果合成线程不用等待输入事件的处理，就可以在等待主线程完成工作时把帧发送出去。

你也可以想象 **Service Worker** 和 **Web Worker** 存在于渲染进程中，虽然我把他们排除在外了，因为他们把事情弄得很复杂。

## 运作过程

![The main thread in all its glory.](https://aerotwist.com/static/blog/the-anatomy-of-a-frame/main-thread.svg)

主线程风貌全览。[下载图片](https://aerotwist.com/static/blog/the-anatomy-of-a-frame/anatomy-of-a-frame.zip)

让我们从垂直同步信号到像素，逐步分析这个过程，然后讨论一下在完全版本中事件是怎么工作的。记住这一点：浏览器**并不需要执行所有步骤**，具体情况取决于哪些步骤是必需的。例如，如果没有新的 HTML 要解析，那么解析 HTML 的步骤就不会触发。事实上，通常[提升性能的最佳方法](https://developers.google.com/web/fundamentals/performance/rendering/#the-pixel-pipeline)，只是简单地移除流程中部分步骤被触发的需要！

同样值得注意的是，上图中 RecalcStyles 和 Layout 下方指向 `requestAnimationFrame` 的红色箭头。在代码中恰好触发这两个情况是完全可能的。这种情况叫做强制同步布局（或强制同步样式，Forced Synchronous Layout 和 Forced Synchronous Styles），通常于性能不利。

1.  **开始新的一帧**。垂直同步信号触发，开始渲染新的一帧图像。

2.  **输入事件的处理**。从合成线程将输入的数据，传递到主线程的事件处理函数。所有的事件处理函数（`touchmove`，`scroll`，`click`）都应该最先触发，每帧触发一次，但也不一定这样；调度程序会尽力尝试，但是是否真的每帧触发因操作系统而异。从用户交互事件，到事件被交付主线程，二者之间也存在延迟。

3.  **`requestAnimationFrame`**。这是更新屏幕显示内容的理想位置，因为现在有全新的输入数据，又非常接近即将到来的垂直同步信号。其他的可视化任务，比如样式计算，因为是在本次任务**之后**，所以现在是变更元素的理想位置。如果你改变了 —— 比如说 100 个类的样式，这不会引起 100 次样式计算；它们会在稍后被批量处理。唯一需要注意的是，不要查询进行计算才能得到的样式或者布局属性（比如 `el.style.backgroundImage` 或 `el.style.offsetWidth`）。如果你**这样做了**，会导致重新计算样式，或者布局，或者二者都发生，进一步导致[强制同步布局，乃至布局颠簸](https://developers.google.com/web/fundamentals/performance/rendering/avoid-large-complex-layouts-and-layout-thrashing?hl=en#avoid-layout-thrashing)。

4.  **解析 HTML（Parse HTML）**。处理新添加的 HTML，创建 DOM 元素。在页面加载过程中，或者进行 `appendChild` 操作后，你可能看到更多的此过程发生。

5.  **重新计算样式（Recalc Styles）**。为新添加或变更的内容计算样式。可能要计算整个 DOM 树，也可能缩小范围，取决于具体更改了什么。例如，更改 body 的类名影响可能很大，但是值得注意的是浏览器已经足够智能了，可以自动限制重新计算样式的范围。

6.  **布局（Layout）**。计算每个可见元素的几何信息（每个元素的位置和大小）。一般作用于整个文档，计算成本通常和 DOM 元素的大小成比例。

7.  **更新图层树（Update Layer Tree）**。这一步创建层叠上下文，为元素的深度进行排序。

8.  **Paint**。过程分为两步：第一步，对所有新加入的元素，或进行改变显示状态的元素，记录 draw 调用（这里填充矩形，那里写点字）；第二步是**栅格化**（Rasterization，见后文），在这一步实际执行了 draw 的调用，并进行纹理填充。Paint 过程记录 draw 调用，一般比栅格化要快，但是两部分通常被统称为“painting”。

9.  **合成（Composite）**：图层和图块信息计算完成后，被传回合成线程进行处理。这将包括 `will-change`、重叠元素和硬件加速的 canvas 等。

10.  **栅格化规划（Raster Scheduled）**和**栅格化（Rasterize）**：在 Paint 任务中记录的 draw 调用现在执行。过程是在**合成图块栅格化线程**（Compositor Tile Workers）中进行，线程的数量取决于平台和设备性能。例如，在 Android 设备上，通常有一个线程，而在桌面设备上有时有 4 个。栅格化根据图层来完成，每层都被分成块。

11.  **帧结束**：各个层的所有的块都被栅格化成位图后，新的块和输入数据（可能在事件处理程序中被更改过）被提交给 GPU 线程。

12.  **发送帧**：最后，但同样很重要的是，图块被 GPU 线程上传到 GPU。GPU 使用四边形和矩阵（所有常用的 GL 数据类型）将图块 draw 在屏幕上。

### 福利时间

*   **requestIdleCallback**：如果在帧结束时，主线程还有点时间，`requestIdleCallback` 可能会被触发。这是做些非必要工作的好机会，比如标记分析数据。如果你不熟悉 `requestIdleCallback`，[Google Developers 上的入门知识](https://developers.google.com/web/updates/2015/08/using-requestidlecallback?hl=en)能帮到你。

## 两种图层

在工作流程中深度的排序有两种版本。

首先是层叠上下文，比如有 2 个绝对定位的重叠的 div。**更新图层树（Update Layer Tree）** 是流程的一部分，保证 `z-index` 和类似的属性受到重视。

然后是合成图层，在上述流程较后的位置，多用于绘制元素。可以使用空 transform 技巧（译注：指使用 `translateZ(0,0)` 强制开启硬件加速），或者 `will-change: transform` 将一个元素提升为合成图层，这样就能轻松地使用 transform 动画（有利于动画效果！）。但是如果存在重叠元素，浏览器也可能需要创建额外的合成图层，来保持由 `z-index` 或者其他属性指定的深度顺序。有趣！

## 扩展阅读

实质上，上面概述的过程**都是在 CPU 中完成的**。只有最后一部分，图块被上传和移动的过程，是在 GPU 中完成的。

然而，在 Android 上，像素流在栅格化时有所不同：GPU 用得更多一些。在 GPU 着色器上用 GL 命令执行 draw 调用，而不是在合成图块栅格化线程中进行栅格化。

这就是所谓的 **GPU 栅格化**，是一种降低绘制（paint）成本的方法。在 Chrome DevTools 中启用 FPS Meter（FPS 计数），你可以查看页面是否使用了 GPU 栅格化。

![The FPS meter indicating GPU Rasterization is in use.](https://aerotwist.com/static/blog/the-anatomy-of-a-frame/fps-meter.jpg)

FPS 计数面板显示了正在使用 GPU 栅格化。

## 其他资源

如果你希望深入研究，还有很多的资料，比如如何避免在主线程工作，或者浏览器渲染更深入的运作机理。希望这些资料能帮到你：

*   **[Compositing in Blink & WebKit](https://www.youtube.com/watch?v=Lpk1dYdo62o)**. A little old now, but still worth a watch.
*   **[Browser Rendering Performance](https://developers.google.com/web/fundamentals/performance/rendering/)** - Google Developers
*   **[Browser Rendering Performance](https://www.udacity.com/courses/ud860)** - Udacity Course (totally free!).
*   **[Houdini](https://surma.link/things/houdini-intro/)** - The future, where you get to add more script to more parts of the flow.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
