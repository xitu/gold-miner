> * 原文地址：[Inside look at modern web browser (part 2)](https://developers.google.com/web/updates/2018/09/inside-browser-part2)
> * 原文作者：[Mariko Kosaka](https://developers.google.com/web/resources/contributors/kosamari)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/inside-browser-part2.md](https://github.com/xitu/gold-miner/blob/master/TODO1/inside-browser-part2.md)
> * 译者：[CoolRice](https://github.com/CoolRice)
> * 校对者：[ThomasWhyne](https://github.com/ThomasWhyne), [tian-li](https://github.com/tian-li)

# 现代浏览器内部揭秘（第二部分）

## 导航时发生了什么

这是关于 Chrome 内部工作的 4 篇博客系列的第 2 篇。在[上一篇文章](https://developers.google.com/web/updates/2018/09/inside-browser-part1)中，我们研究了不同的进程和线程如何处理浏览器的不同部分。在这篇文章中，我们会更深入研究每个进程和线程如何进行通信以展示网站。

让我们看一个网络浏览的简单用例：你在浏览器中键入 URL，然后浏览器从互联网获取数据并显示一个页面。在这篇文章中，我们将重点放在用户请求站点和浏览器准备渲染页面部分 —— 亦即导航。

## 它以浏览器进程开始

![浏览器进程](https://developers.google.com/web/updates/images/inside-browser/part2/browserprocesses.png)

图 1：顶部是浏览器 UI，底部是拥有 UI、网络和存储线程的浏览器进程图

正如我们在[第 1 部分：CPU、GPU、内存和多进程架构](https://developers.google.com/web/updates/2018/09/inside-browser-part1)中所述，tab 外的一切都被浏览器进程处理。浏览器进程有很多线程，例如绘制浏览器按钮和输入栏的 UI 线程、处理网络栈以从因特网获取数据的网络线程、控制文件访问的存储线程等。当你在地址栏中键入 URL 时，你的输入将由浏览器进程的 UI 线程处理。

## 一个简单导航

### 第 1 步：处理输入

当用户开始在地址栏键入时，UI 线程要问的第一件事是 “这是一次搜索查询还是一个 URL 地址？”。在 Chrome 中，地址栏同时也是一个搜索输入栏，所以 UI 线程需要解析和决定把你的请求发送到搜索引擎，或是你要请求的网站。

![处理用户输入](https://developers.google.com/web/updates/images/inside-browser/part2/input.png)

图 1：UI 线程询问输入内容是搜索查询还是 URL 地址

### 第 2 步：开始导航

当用户按下 Enter 键时，UI 线程启用网络调取去获取站点内容。加载动画会显示在标签页的一角，网络线程会通过适当的协议，像 DNS 查找和为请求建立 TLS 连接。

![导航开始](https://developers.google.com/web/updates/images/inside-browser/part2/navstart.png)

图 2：UI 线程告诉网络线程要导航到 mysite.com

在这时，网络线程可能会收到像 HTTP 301 那样的服务器重定向头。这种情况下，网络线程会告诉 UI 线程，服务器正在请求重定向。然后，另一个 URL 请求会被启动。

### 第 3 步：读取响应

![HTTP 响应](https://developers.google.com/web/updates/images/inside-browser/part2/response.png)

图 3：包含 Content-Type 的响应头以及作为实际数据的 payload

一旦开始收到响应主体（payload），网络线程会在必要时查看数据流的前几个字节。响应报文的 Content-Type 字段会声明数据的类型，但是它有可能会丢失或者错误，所以就有了 [MIME 类型嗅探](https://developer.mozilla.org/en-US/docs/Web/HTTP/Basics_of_HTTP/MIME_types)来解决这个问题。这是[源码](https://cs.chromium.org/chromium/src/net/base/mime_sniffer.cc?sq=package:chromium&dr=CS&l=5)中评论的“棘手的问题”。你可以阅读注释看一下不同浏览器是怎么匹配 content-type 和 payload 的。

如果响应是一个 HTML 文件，那么下一步就会把数据传给渲染进程，但是如果是一个压缩文件或是其他文件，那么意味着它是一个下载请求，因此需要将数据传递给下载管理器。

![MIME 类型嗅探](https://developers.google.com/web/updates/images/inside-browser/part2/sniff.png)

图 4：网络线程询问一个响应数据是否是从安全网站来的 HTML

此时也会进行 [SafeBrowsing](https://safebrowsing.google.com/) 检查。如果域名和响应数据似乎匹配到一个已知的恶意网站，那么网络线程会显示一个警告页面。除此之外，还会发生 [**C**ross **O**rigin **R**ead **B**locking（**CORB**）](https://www.chromium.org/Home/chromium-security/corb-for-developers)检查，以确保敏感的跨域数据不被传给渲染进程。

### 第 4 步：查找渲染进程

一旦所有的检查执行完毕并且网络线程确信浏览器会导航到请求的站点，网络线程会告诉 UI 线程所有的数据准备完毕。UI 线程会寻找渲染进程去开始渲染 web 页面。

![寻找渲染进程](https://developers.google.com/web/updates/images/inside-browser/part2/findrenderer.png)

图 5：网络线程告诉 UI 线程去查找渲染进程

由于网络请求会花费几百毫秒才获取回响应，因此可以应用一个优化措施。当第 2 步 UI 线程正发送一个 URL 请求给网络线程时，它已经知道它们会导航到哪个站点。在网络请求的同时，UI 并行地线程尝试主动寻找或开启一个渲染进程。这样，如果一切按预期进行，渲染进程在网络线程接受到数据时就已经处于待命状态。如果导航跨域重定向，这个待命进程也许不会被用到，这种情况下也许会用到另一个进程。

### 第 5 步：提交导航

现在数据和渲染进程已经就绪，浏览器进程会发送一个 IPC（进程间通信）到渲染进程去提交导航。它也会传递数据流，所以渲染进程可以保持接收 HTML 数据。一旦浏览器进程收到渲染进程已经提交的确认消息，导航完毕并且文档加载解析开始。

这时，地址栏已经更新，安全指示器和站点设置 UI 会反映新页面的站点信息。此标签页的 session 历史记录会被更新，所以前进/后退按钮会走向刚导航过的站点。当你关闭标签页或者窗口，为了优化 tab/session 的还原，session 历史被保存在硬盘上。

![提交导航](https://developers.google.com/web/updates/images/inside-browser/part2/commit.png)

图 6：浏览器和渲染进程间的 IPC，请求渲染页面。

### 额外的步骤：初始加载完毕

一旦导航被提交，渲染进程开始加载资源和渲染页面。我们将在下一篇文章中讲解这个阶段发生什么的细节。一旦渲染进程渲染“完毕”。它会发送一个 IPC 返回给浏览器进程（这会在页面所有的 frame 的 `onload` 事件已经触发和执行完毕后发生）。这时，UI 线程停止标签页上的加载动画。

我之所以说“结束”，是因为客户端 JavaScript 可以在这时之后仍然加载额外的资源并且渲染新视图。

![页面加载结束](https://developers.google.com/web/updates/images/inside-browser/part2/loaded.png)

图 7：渲染进程发送 IPC 到浏览器进程通知页面“已被加载”

## 导航到另一个站点

简单导航已经完毕！但是用户在地址栏输入另一个 URL 会怎样呢？好吧，浏览器进程会执行相同的步骤来导航到一个不同的站点。但是在它做这个之前，它会检查当前已经渲染的站点是否关心 [`beforeunload`](https://developer.mozilla.org/en-US/docs/Web/Events/beforeunload) 事件。

`beforeunload` 可以在你试图导航离开或关闭标签页时创建“离开此站点？”警告。包括你的 JavaScript 代码，所有标签页内的东西都是由渲染进程处理，所以当新的导航请求到来时，浏览器进程必须要跟当前的渲染进程核对。

**注意：** 不要添加无条件的 `beforeunload` 处理程序。它会产生更多延迟，因为处理程序需要在导航开始之前执行。应仅在需要时添加此事件处理程序，例如如果需要警告用户他们可能会丢失他们在页面上输入的数据。

![beforeunload 事件处理程序](https://developers.google.com/web/updates/images/inside-browser/part2/beforeunload.png)

图 8：浏览器进程向渲染进程发送 IPC 告诉它将要导航到另一个站点

如果渲染进程已经启动了导航（像用户点击一个链接或者客户端 JavaScript 运行 `window.location = "https://newsite.com"`），渲染进程会先检查 `beforeunload` 事件处理程序。然后，它会像浏览器处理启动导航一样执行相同的步骤。唯一不同的是导航请求是由渲染进程发送到浏览器进程的。

当新导航到的站点不同于当前已渲染的站点时，会调用一个独立的渲染进程来处理新导航，同时保持当前的渲染进程来处理类似 `unload` 的事件。有关更多信息，请查看[页面生命周期概览](https://developers.google.com/web/updates/2018/07/page-lifecycle-api#overview_of_page_lifecycle_states_and_events)以及如何使用[页面声明周期 API](https://developers.google.com/web/updates/2018/07/page-lifecycle-api) 挂钩事件。

![新导航与 unload](https://developers.google.com/web/updates/images/inside-browser/part2/unload.png)

图 9：2 个 IPC（从浏览器进程到新渲染进程）告知渲染页面并告知旧渲染进程卸载

## 如果有 Service Worker

最近对导航过程的改变是引入了 [service worker](https://developers.google.com/web/fundamentals/primers/service-workers/)。service worker 是一种在你的应用代码中编写网络代理的方法；允许 Web 开发者更好地控制本地缓存内容以及何时从网络获取新数据。如果将 service worker 设置为从缓存加载页面，则无需从网络请求数据。

要记住的重要部分是 Service Worker 是在渲染进程中运行的 JavaScript 代码。但是当导航请求进入时，浏览器进程如何知道该站点有 service worker？

![service worker 作用域检查](https://developers.google.com/web/updates/images/inside-browser/part2/scope_lookup.png)

图 10：浏览器进程中的网络线程查找 service worker 作用域

当注册一个 service worker 时，保持 service worker 的作用域作为一个引用（你可以在这篇文章 [The Service Worker Lifecycle](https://developers.google.com/web/fundamentals/primers/service-workers/lifecycle) 中阅读更多关于作用域的知识）。当一个导航发生时，网络线程用已注册的 service worker 作用域来检查域名，如果已经为该 URL 注册了一个 service worker，UI 线程会找一个渲染线程来执行 service worker 的代码。service worker 可能从缓存中加载数据，无需从网络请求数据，或者可以从网络请求新资源。

![service worker 导航](https://developers.google.com/web/updates/images/inside-browser/part2/serviceworker.png)

图 11：浏览器中的 UI 线程启动渲染进程来处理 service workers；然后，渲染进程中的工作线程从网络请求数据

## 导航预加载

你可以看到，如果 service worker 最终决定从网络请求数据，则浏览器进程和渲染器进程之间的往返可能会导致延迟。[导航预加载](https://developers.google.com/web/updates/2017/02/navigation-preload)是一种通过与 service worker 启动并行加载资源来加速此过程的机制。它用一个头部来标记这些请求，允许服务器决定为这些请求发送不同的内容；例如，只更新数据而不是完整文档。

![导航预加载](https://developers.google.com/web/updates/images/inside-browser/part2/navpreload.png)

图 12：浏览器进程中的 UI 线程启动渲染进程以在并行启动网络请求的同时处理 service worker

## 总结

在这篇文章中，我们研究了导航过程中发生了什么，以及你的 Web 应用代码（例如响应头和客户端 JavaScript）如何与浏览器交互。了解浏览器通过网络获取数据的步骤，可以更容易地理解为什么开发导航预加载等 API。在下一篇文章中，我们将深入探讨浏览器如何分析 HTML/CSS/JavaScript 以渲染页面。

你喜欢这篇文章吗？如果您对以后的文章有任何问题或建议，欢迎在下面的评论区或在 Twitter [@kosamari](https://twitter.com/kosamari) 上留下您的宝贵意见。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
