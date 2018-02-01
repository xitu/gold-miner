> * 原文地址：[v3.1.0: A massive performance boost and streaming server-side rendering support](https://medium.com/styled-components/v3-1-0-such-perf-wow-many-streams-c45c434dbd03)
> * 原文作者：[Evan Scott](https://medium.com/@probablyup?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/v3-1-0-such-perf-wow-many-streams.md](https://github.com/xitu/gold-miner/blob/master/TODO/v3-1-0-such-perf-wow-many-streams.md)
> * 译者：
> * 校对者：

# v3.1.0: A massive performance boost and streaming server-side rendering support

## A new CSS injection mechanism means faster client-side rendering in production 🔥 and streaming server-side rendering support enables a faster time-to-first-byte! 🔥🔥

### Faster CSS injection in production

This patch has been a long time coming and has a long history. Almost one and a half years ago (!) [Sunil Pai found a new and widely unknown DOM API:](https://twitter.com/threepointone/status/758095395482324992) `[insertRule](https://twitter.com/threepointone/status/758095395482324992)`. It allows one to insert CSS from JavaScript into the DOM at blazing speed; the only downside being that the styles aren’t editable from browser DevTools.

When [Glen](https://github.com/geelen) and [Max](https://github.com/mxstbr) first built styled-components, they were 100% focused on the developer experience. Performance problems were sparse for smaller applications, so they decided against using `insertRule`. As adoption grew and people used styled-components for larger apps, style injection turned out to be a bottleneck for folks with highly dynamic use cases.

Thanks to [Ryan Schwers,](https://twitter.com/real_schwers) a frontend engineer at Reddit, styled-components v3.1.0 now uses `insertRule` in production by default.

![](https://cdn-images-1.medium.com/max/1200/1*GaOQyktA0iQkF3yDExExgw.png)

We ran some benchmarks against the previous version (v3.0.2) and the new one with `insertRule`, and the results were even better than our (already high) expectations:

**Initial mount time of the benchmark app was reduced by ~10x, and re-render time was reduced by ~20x!**

Note that the benchmarks are stress testing the library, and are not representative of a real application. While your app will (probably) not mount 10x faster, **Time-To-First-Interactive dropped by hundreds of milliseconds in one of our production applications**!

Here’s how styled-components holds up in comparison to other major React CSS-in-JS frameworks in those benchmarks:

![](https://cdn-images-1.medium.com/max/1600/1*X0KamN6FwoOMfp-n0TZYsA.png)

styled-components compared to all other major React CSS-in-JS frameworks. (light red: v3.0.2; dark red: v3.1.0)

While it’s not (yet) the fastest CSS-in-JS framework in micro-benchmarks, it’s only marginally slower than the fastest ones — to the point where it no longer could be considered a bottleneck. The real-world results are highly encouraging and we can’t wait for you all to report back with your findings!

### Streaming server-side rendering

[Streaming server-side rendering](https://hackernoon.com/whats-new-with-server-side-rendering-in-react-16-9b0d78585d67) was introduced in React v16\. It allows the application server to send HTML as it becomes available while React is still rendering, which makes for **a faster Time-To-First-Byte (TTFB)** and **allows your Node server to handle** [**back-pressure**](https://nodejs.org/en/docs/guides/backpressuring-in-streams/) **more easily**.

That doesn’t play well with CSS-in-JS: Traditionally, we inject a `<style>` tag with all your components’ styles into the `<head>` _after_ React finishes rendering. However, in the case of streaming, the `<head>` is sent to the user _before_ any components have been rendered, so we can’t inject into it anymore.

**The solution is to interleave the HTML with** `**<style>**` **blocks as components are rendered**, rather than waiting until the very end and injecting all the components at once. Because that messes with ReactDOM on the client (HTML being present that React wasn’t responsible for), we have to consolidate all those `style` tags back into the `<head>` before rehydration.

We’ve implemented exactly that; **you can now use streaming server-side rendering with styled-components!** Here’s how:

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

Later on client-side, the `consolidateStreamedStyles()` API must be called to prepare for React’s rehydration phase:

```
import ReactDOM from 'react-dom'
import { consolidateStreamedStyles } from 'styled-components'
/* Make sure you call this before ReactDOM.hydrate! */
consolidateStreamedStyles()
ReactDOM.hydrate(<App />, rootElem)
```

That’s all there is to it! 💯 (check out [the streaming docs](http://styled-components.com/docs/advanced#streaming-rendering) for more information)

### v3: no breaking changes

Good news! If you’re on v2 (or even v1), **the new version is backward-compatible** and should be a seamless upgrade. Dozens of improvements have made their way into these new versions, so please take a look and we hope you and your visitors enjoy them!

See [the changelog](https://www.styled-components.com/releases) for more information about both the v3.0.0 and the v3.1.0 release.

Stay stylish! 💅

* * *

[_Discuss this post in the styled-components community._](https://spectrum.chat/thread/845da820-83f7-4228-981c-ff5723d33e61)

_Thanks to Gregory Shehet for his_ [_CSS-in-JS benchmarks,_](https://github.com/A-gambit/CSS-IN-JS-Benchmarks) _which are referenced throughout this post._



---
 
 > [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
