> * 原文地址：[v3.1.0: A massive performance boost and streaming server-side rendering support](https://medium.com/styled-components/v3-1-0-such-perf-wow-many-streams-c45c434dbd03)
> * 原文作者：[Evan Scott](https://medium.com/@probablyup?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/v3-1-0-such-perf-wow-many-streams.md](https://github.com/xitu/gold-miner/blob/master/TODO/v3-1-0-such-perf-wow-many-streams.md)
> * 译者：[FateZeros](https://github.com/fateZeros)
> * 校对者：[ryouaki](https://github.com/ryouaki)

# v3.1.0：大幅性能提升并支持流媒体服务端渲染

## 在生产环境，一种新的 CSS 注入机制意味着更快的客户端渲染。 🔥 支持流媒体服务端渲染可以加快首屏渲染时间！ 🔥🔥

### 在生产环境更快的 CSS 注入

这个补丁出来很久了，并有很长的历史。差不多一年半前 (!)[Sunil Pai 发现一个新的，却广泛未知的 DOM API：](https://twitter.com/threepointone/status/758095395482324992) `[insertRule](https://twitter.com/threepointone/status/758095395482324992)`。它允许人们以惊人的速度将 CSS 从 JavaScript 插入到 DOM 中；唯一的缺点就是样式不能从浏览器 DevTools 中编辑。

当 [Glen](https://github.com/geelen) 和 [Max](https://github.com/mxstbr) 首次构建样式化组件时，他们 100% 关注开发人员的体验。性能问题对于较小的应用来说是很稀少的，所以他们决定并不使用 `insertRule`。随着采用量不断增加，人们在更大的应用程序中使用样式组件，样式注入成为人们使用高度动态用例的瓶颈。

感谢 Reddit 的一名前端工程师 [Ryan Schwers](https://twitter.com/real_schwers)，样式组件 v3.1.0 现在默认在生产环境使用 `insertRule` 。

![](https://cdn-images-1.medium.com/max/1200/1*GaOQyktA0iQkF3yDExExgw.png)

我们对前一个版本 (v3.0.2) 和新版本的 `insertRule` 进行了一些基准测试，结果甚至比我们的预期（已经很高的期望）还要高：

**基准应用程序的初始安装时间减少了约 10 倍，重渲染的时间减少了约 20 倍！**

请注意，基准测试是对库进行压力测试，并不代表真实的应用程序。虽然你的应用程序安装时间（可能）不会减少 10 倍，**但在我们的一个生产环境下的应用程序中，首次交互时间会下降数百毫秒**！

在这些基准测试中，样式组件与其他主流的 React CSS-in-JS 框架相比，效果如何：

![](https://cdn-images-1.medium.com/max/1600/1*X0KamN6FwoOMfp-n0TZYsA.png)

样式组件与所有其他主流的 React CSS-in-JS 框架相比（浅红色是：v3.0.2；深红色是：v3.1.0）

在微基准测试中，虽然它不是（还不是）最快的 CSS-in-JS 框架，但它只比那些最快的框架慢少许 ——  关键的是它不再是瓶颈。现实的使用结果是最鼓舞人心的，我们已迫不及待的等你们都来报告你们的发现了！

### 流媒体服务端渲染

在 React v16 中有介绍[流媒体服务端渲染](https://hackernoon.com/whats-new-with-server-side-rendering-in-react-16-9b0d78585d67)。在 React 还在渲染的时候，它允许应用程序服务器发送 HTML 作为可用展示页面，这有助于 **更快的首屏渲染（TTFB）**，也允许你的 Node 服务器***更容易***处理[**后端压力**](https://nodejs.org/en/docs/guides/backpressuring-in-streams/)。

那不能和 CSS-in-JS 兼容：传统上，在 React 完成渲染后，我们会在所有组件样式的 `<head>` 中注入一个 `<style>` 标签。然而，在流式传输的情况下，在所有组件渲染前，`<head>` 就已发送到用户端，所以我们不能再注入样式。

**解决方案是在组件被渲染的时候，插入带 `**<style>**` 的 HTML**，而不是等到最后一次注入到所有组件。由于那样会在客户端上造成 ReactDOM 混乱（ React 不再对现在的 HTML 负责），所以我们在客户端再覆水前将所有这些 `style` 标签重新合并到 `<head>` 中。

我们已经实现了这一点；**你可以在样式组件中使用流式服务端渲染** 以下是使用方法：

```
import { renderToNodeStream } from 'react-dom/server'
import styled, { ServerStyleSheet } from 'styled-components'
res.write('<!DOCTYPE html><html><head><title>My Title</title></head><body><div id="root">')
const sheet = new ServerStyleSheet()
const jsx = sheet.collectStyles(<App />)
// Interleave the HTML stream with <style> tags
const stream = sheet.interleaveWithNodeStream(
  renderToNodeStream(jsx)
)
stream.pipe(res, { end: false })
stream.on('end', () => res.end('</div></body></html>'))
```

稍后在客户端，我们必须调用 `consolidateStreamedStyles()` API 为 React 的再覆水阶段做准备：

```
import ReactDOM from 'react-dom'
import { consolidateStreamedStyles } from 'styled-components'
/* Make sure you call this before ReactDOM.hydrate! */
consolidateStreamedStyles()
ReactDOM.hydrate(<App />, rootElem)
```

这里就是它的所有了！💯（查看[流式文档](http://styled-components.com/docs/advanced#streaming-rendering)了解更多信息）

### v3：无缝更新

好消息！如果你使用的是 v2 版本（或者甚至是 v1 版本），**新版本是向后兼容的**，应该是无缝升级。这些新版本已加入了许多改进，所有请看一看，我们希望你和你的访客能够享受它们！ 

有关 v3.0.0 和 v3.1.0 发行版更多的信息，请参阅[更新日志](https://www.styled-components.com/releases)。

紧随潮流！ 💅

* * *

[可以在样式化组件社区中讨论这篇文章](https://spectrum.chat/thread/845da820-83f7-4228-981c-ff5723d33e61)

感谢 Gregory Shehet 提出的 [CSS-in-JS 基准测试](https://github.com/A-gambit/CSS-IN-JS-Benchmarks) 为这篇文章提供了参考。



---
 
 > [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
