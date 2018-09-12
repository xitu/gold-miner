> * 原文地址：[Inside look at modern web browser (part 1)](https://developers.google.com/web/updates/2018/09/inside-browser-part1)
> * 原文作者：[Mariko Kosaka](https://developers.google.com/web/resources/contributors/kosamari)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/inside-look-at-modern-web-browser-part1.md](https://github.com/xitu/gold-miner/blob/master/TODO1/inside-look-at-modern-web-browser-part1.md)
> * 译者：[Colafornia](https://github.com/Colafornia)
> * 校对者：[CoderMing](https://github.com/CoderMing)

# 现代浏览器内部揭秘（第一部分）

## CPU、GPU、内存和多进程体系结构

这一博客系列由四部分组成，将从高级体系结构到渲染流程的细节来窥探 Chrome 浏览器的内部。如果你曾对浏览器是如何将代码转化为具有功能的网站，或者你并不确定为何建议使用某一技术来提升性能，那么本系列就是为你准备的。

本文作为此系列的第一部分，将介绍核心计算术语与 Chrome 的多进程体系架构。

**提示：** 如果你已熟悉 CPU/GPU，进程/线程的相关概念，可以直接跳到[浏览器架构](#浏览器架构)部分开始阅读。

## 计算机的核心是 CPU 与 GPU

为了了解浏览器运行的环境，我们需要了解几个计算机部件以及它们的作用。

### CPU

![CPU](https://developers.google.com/web/updates/images/inside-browser/part1/CPU.png)

图 1：4 个 CPU 核心作为办公人员，坐在办公桌前处理各自的工作

第一个需要了解的计算机部件是 **中央处理器（Central Processing Unit）**，或简称为 **CPU**。CPU 可以看作是计算机的大脑。一个 CPU 核心如图中的办公人员，可以逐一解决很多不同任务。解决从数学到艺术一切任务的同时还知道如何响应客户要求。过去 CPU 大多是单芯片的，一个核心就像存在于同芯片的另一个 CPU。随着现代硬件发展，你经常会有不止一个内核，给你的手机和笔记本提供更多的计算能力。

### GPU

![GPU](https://developers.google.com/web/updates/images/inside-browser/part1/GPU.png)

图 2：许多带特定扳手的 GPU 内核意味着它们只能处理有限任务

**图形处理器**（**Graphics Processing Unit**，简称为 **GPU**）是计算机的另一部件。与 CPU 不同，GPU 擅长同时处理跨内核的简单任务。顾名思义，它最初是为解决图形而开发的。这就是为什么在图形环境中“使用 GPU” 或 “GPU 支持”都与快速渲染和顺滑交互有关。近年来随着 GPU 加速计算的普及，仅靠 GPU 一己之力也使得越来越多的计算成为可能。

当你在电脑或手机上启动应用时，是 CPU 和 GPU 为应用供能。通常情况下应用是通过操作系统提供的机制在 CPU 和 GPU 上运行。

![硬件，操作系统，应用](https://developers.google.com/web/updates/images/inside-browser/part1/hw-os-app.png)

图 3：三层计算机体系结构。底部是机器硬件，中间是操作系统，顶部是应用程序。

## 在进程和线程上执行程序

![进程与线程](https://developers.google.com/web/updates/images/inside-browser/part1/process-thread.png)

图四：进程作为边界框，线程作为抽象鱼在进程中游动

在深入学习浏览器架构之前需要了解的另一个理论是进程与线程。进程可以被描述为是一个应用的执行程序。线程存在于进程并执行程序任意部分。

启动应用时会创建一个进程。程序也许会创建一个或多个线程来帮助它工作，这是可选的。操作系统为进程提供了一个可以使用的“一块”内存，所有应用程序状态都保存在该私有内存空间中。关闭应用程序时，相应的进程也会消失，操作系统会释放内存。

![进程与内存](https://developers.google.com/web/updates/images/inside-browser/part1/memory.svg)

图 5 ：进程使用内存空间和存储应用数据的示意图

进程可以请求操作系统启动另一个进程来执行不同的任务。此时，内存中的不同部分会分给新进程。如果两个进程需要对话，他们可以通过**进程间通信**（**IPC**）来进行。许多应用都是这样设计的，所以如果一个工作进程失去响应，该进程就可以在不停止应用程序不同部分的其他进程运行的情况下重新启动。

![工作进程与 IPC](https://developers.google.com/web/updates/images/inside-browser/part1/workerprocess.svg)

图 6：独立进程通过 IPC 通信示意图

## 浏览器架构

那么如何通过进程和线程构建 web 浏览器呢？它可能由一个拥有很多线程的进程，或是一些通过 IPC 通信的不同线程的进程。

![浏览器架构](https://developers.google.com/web/updates/images/inside-browser/part1/browser-arch.png)

图 7：不同浏览器架构的进程/线程示意图

这里需要注意的重要一点是，这些不同的架构是实现细节。关于如何构建 web 浏览器并不存在标准规范。一个浏览器的构建方法可能与另一个迥然不同。

在本博客系列中，我们使用下图所示的 Chrome 近期架构进行阐述。

顶部是浏览器线程，它与处理应用其它模块任务的进程进行协调。对于渲染进程来说，创建了多个渲染进程并分配给了每个标签页。直到最近，Chrome 在可能的情况下给每个标签页分配一个进程。而现在它试图给每个站点分配一个进程，包括 iframe（参见[站点隔离](#每个-iframe-的渲染进程--站点隔离)）。

![浏览器架构](https://developers.google.com/web/updates/images/inside-browser/part1/browser-arch2.png)

图 8：Chrome 的多进程架构示意图。渲染进程下显示了多个层，表明 Chrome 为每个标签页运行多个渲染进程。

## 进程各自控制什么？

下表展示每个 Chrome 进程与各自控制的内容：









| 进程 | 控制 |
| -----|-----|
| 浏览器 | 控制应用中的 “Chrome” 部分，包括地址栏，书签，回退与前进按钮。以及处理不可见的特权部分，如网络请求与文件访问。 |
| 渲染 | 控制标签页内网站展示。 |
| 插件 | 控制站点使用的任意插件，如 Flash。 |
| GPU | 处理独立于其它进程的 GPU 任务。GPU 被分成不同进程，因为 GPU 处理来自多个不同应用的请求并绘制在相同表面。|

![Chrome 进程](https://developers.google.com/web/updates/images/inside-browser/part1/browserui.png)

图 9：不同进程指向浏览器 UI 的不同部分

还有更多进程如扩展进程与应用进程。如果你想要了解有多少进行运行在你的 Chrome 浏览器中，可以点击右上角的选项菜单图标，选择更多工具，然后选择任务管理器。然后会打开一个窗口，其中列出了当前正在运行的进程以及它们当前的 CPU/内存使用量。

## Chrome 多进程架构的优点

前文中提到了 Chrome 使用多个渲染进程。最简单的情况下，你可以想象每个标签页都有自己的渲染进程。假设你打开了三个标签页，每个标签页都拥有自己独立的渲染进程。如果某个标签页失去响应，你可以关掉这个标签页，此时其它标签页依然运行着，可以正常使用。如果所有标签页都运行在同一进程上，那么当某个失去响应，所有标签页都会失去响应。真是个悲伤的故事。

![多个标签页各自的渲染进程](https://developers.google.com/web/updates/images/inside-browser/part1/tabs.svg)

图 10：如图所示每个标签页上运行的渲染进程

把浏览器工作分成多个进程的另一好处是安全性与沙箱化。由于操作系统提供了限制进程权限的方法，浏览器就可以用沙箱保护某些特定功能的进程。例如，Chrome 浏览器限制处理任意用户输入的进程(如渲染器进程)对任意文件的访问。

由于进程有自己的私有内存空间，所以它们通常包含公共基础设施的拷贝(如 V8，它是 Chrome 的 JavaScript 引擎)。这意味着使用了更多的内存，如果它们是同一进程中的线程，就无法共享这些拷贝。为了节省内存，Chrome 对可加速的内存数量进行了限制。具体限制数值依设备可提供的内存与 CPU 能力而定，但是当 Chrome 运行时达到限制时，会开始在同一站点的不同标签页上运行同一进程。

## 节省更多内存 —— Chrome 中的服务化

同样的方法也适用于浏览器进程。Chrome 正在经历架构变革，它转变为将浏览器程序的每一模块作为一个服务来运行，从而可以轻松实现进程的拆解和聚合。

通常观点是当 Chrome 运行在强力硬件上时，它会将每个服务分解到不同进程中，从而提升稳定性，但是如果 Chrome 运行在资源有限的设备上时，它会将服务聚合到一个进程中从而节省了内存占用。在这一架构变革实现前，类似的整合进程以减少内存使用的方法已经在 Android 类平台上使用。

![Chrome 服务化](https://developers.google.com/web/updates/images/inside-browser/part1/servicfication.svg)

图 11： Chrome 的服务化图，将不同的服务移动到多个进程和单个浏览器进程中

## 每个 iframe 的渲染进程 —— 站点隔离

[站点隔离](https://developers.google.com/web/updates/2018/07/site-isolation) 是近期引入到 Chrome 中的一个功能，它为每个 iframe 运行一个单独的渲染进程。我们已经讨论了许久每个标签页的渲染进程，它允许跨站点 iframe 运行在一个单独的渲染进程，在不同站点中共享内存。运行 a.com 与 b.com 在同一渲染进程中看起来还 ok。

[同源策略](https://developer.mozilla.org/en-US/docs/Web/Security/Same-origin_policy) 是 web 的核心安全模型。同源策略确保站点不能在未得到其它站点许可的情况下获取其数据。安全攻击的一个主要目标就是绕过同源策略。进程隔离是分离站点的最高效的手段。随着 [Meltdown and Spectre](https://developers.google.com/web/updates/2018/02/meltdown-spectre) 的出现，使用进程来分离站点愈发势在必行。Chrome 67 版本后，桌面版 Chrome 都默认开启了站点隔离，每个标签页的 iframe 都有一个单独的渲染进程。

![站点隔离](https://developers.google.com/web/updates/images/inside-browser/part1/isolation.png)

图 12：站点隔离示意图，多个渲染进程指向站点内的 iframe

启用站点隔离是多年来工程人员努力的结果。站点隔离并不只是分配不同的渲染进程这么简单。它从根本上改变了 iframe 的通信方式。在一个页面上打开开发者工具，让 iframe 在不同的进程上运行，这意味着开发者工具必须在幕后工作，以使它看起来无缝。即使运行一个简单的 Ctrl + F 来查找页面中的一个单词，也意味着在不同的渲染器进程中进行搜索。你可以看到为什么浏览器工程师把发布站点隔离功能作为一个重要里程碑！

## 总结

本文从高级视角对浏览器架构与多进程架构的优点进行阐述。我们也对 Chrome 中与多进程架构密切相关的服务化与站点隔离进行了讲解。下一篇文章中，我们将开始深入了解进程与线程中到底发生了什么才能使网站得以呈现。

你喜欢这篇文章吗？对后续文章有任何疑问或建议都可以在评论区或 Twitter 上 [@kosamari](https://twitter.com/kosamari) 与我联系。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
