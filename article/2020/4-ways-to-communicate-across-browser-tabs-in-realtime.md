> * 原文地址：[4 Ways to Communicate Across Browser Tabs in Realtime](https://blog.bitsrc.io/4-ways-to-communicate-across-browser-tabs-in-realtime-e4f5f6cbedca)
> * 原文作者：[Dilantha Prasanjith](https://medium.com/@dilanthaprasanjith)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/4-ways-to-communicate-across-browser-tabs-in-realtime.md](https://github.com/xitu/gold-miner/blob/master/article/2020/4-ways-to-communicate-across-browser-tabs-in-realtime.md)
> * 译者：[zenblo](https://github.com/zenblo)
> * 校对者：[HurryOwen](https://github.com/HurryOwen)、[TiaossuP](https://github.com/TiaossuP)

# 四种跨浏览器选项卡实时通信方法

![Photo by [JOHN TOWNER](https://unsplash.com/@heytowner?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/8192/0*7c6YTCKtlLMAjuOn)

多年来，随着对 Web 应用程序的需求增多，Web 浏览器的功能也不断增强。从而，可以找到实现类似功能的多种方法。本文将介绍一类很少被人关注的功能：在浏览器选项卡之间进行通信。以下是列举的几个适用场景：

* 将对应用程序的主题修改（例如，深色或浅色主题）应用到所有已打开的浏览器选项卡中。
* 请求用于身份验证的最新令牌，并在浏览器选项卡之间共享。
* 跨浏览器选项卡同步应用程序状态。

本文主要介绍几种跨浏览器通信的方法。然而，每种方法都有其优缺点。因此，本文会详细讨论它们，以便让您能够在实际开发中找到适用的最佳方法。

## 1. 使用本地存储事件 LocalStorage

通过使用 LocalStorage，可以使得同一应用程序源中的选项卡之间进行通信。同时 LocalStorage 也支持事件，可以使用此功能跨浏览器选项卡进行通信，存储更新后，其他选项卡将接收事件。

例如，在一个选项卡中执行以下 JavaScript 代码。

```js
window.localStorage.setItem("loggedIn", "true");
```

如下所示，监听事件的其他选项卡将接收它：

```js
window.addEventListener('storage', (event) => {
 if (event.storageArea != localStorage) return;
 if (event.key === 'loggedIn') {
   // 测试使用 event.newValue
 }
});
```

然而，它有几个局限性：

* 执行存储集操作的选项卡不会触发此事件。
* 对于大数据块，由于 LocalStorage 是同步的，这种方法可能会产生不利影响 —— 阻塞主 UI 线程。

可以在 [MDN 的存储事件文档](https://developer.mozilla.org/en-US/docs/Web/API/Window/storage_event)中找到更多信息。

## 2. 使用 BroadcastChannel API 接口

BroadcastChannel API 允许选项卡、窗口、Frames、Iframes 和 [Web Workers](https://developer.mozilla.org/en-US/docs/Web/API/Web_Workers_API) 之间的通信。一个选项卡可以创建一个 Channel 并在其中发送消息，如下所示：

```js
const channel = new BroadcastChannel('app-data');
channel.postMessage(data);
```

其他选项卡可以监听频道，如下所示：

```js
const channel = new BroadcastChannel('app-data');

channel.addEventListener ('message', (event) => {
 console.log(event.data);
});
```

这样，[浏览器上下文](https://developer.mozilla.org/en-US/docs/Glossary/browsing_context)（**Windows**、**Tabs**、**Frames**、或 **Iframes**）之间可以进行通信。尽管这是浏览器选项卡之间的一种很便捷的通信方式，但 safari 和 IE 是不支持这种方式的。可以在 [MDN 的 BroadcastChannel 文档](https://developer.mozilla.org/en-US/docs/Web/API/Broadcast_Channel_API)中查看详细信息。

## 3. 使用 Service Worker 发送消息

可能会有疑问，Service Worker 是如何进入这种场景的。不过从根本上来说，Service Worker 支持发送消息，可以使用这些消息在浏览器选项卡之间进行通信。

使用 Service Worker，可以发送如下所示的消息：

```js
navigator.serviceWorker.controller.postMessage({
 broadcast: data
});
```

同时在接收 Worker 的其他浏览器选项卡中可以监听事件。

```js
addEventListener('message', async (event) => {
 if ('boadcast' in event.data ) {
  const allClients = await clients.matchAll();
  for (const client of allClients) {
   client.postMessage(event.broadcast);
  }
 }
});
```

这种方法提供更多的控制保障，是传递消息的可靠方法。但是，实现 Service Worker 需要一些关于 Service Worker API 的补充知识和额外工作。所以，在这种情况下，如果其他方法都不起作用，最好还是尝试这个方法。可以在 [MDN 的 Service Worker API 文档](https://developer.mozilla.org/en-US/docs/Web/API/ServiceWorkerRegistration)中找到更多信息，还有一个完整的[示例](https://googlechrome.github.io/samples/service-worker/post-message/)。

## 4. 使用 window.postMessage() 方法

`Window.postMessage()` 方法是跨浏览器选项卡、弹出窗口和 Iframes 进行通信的传统方法之一。可以按如下方式发送消息：

```js
targetWindow.postMessage(message, targetOrigin)
```

目标窗口可以监听事件，如下所示：

```js
window.addEventListener("message", (event) => {
  if (event.origin !== "http://localhost:8080")
    return;
  // 可以做测试
}, false);
```

与其他方法相比，这种方法有一个优点：可以支持跨源通信。但它也有一个限制：需要引用另一个浏览器选项卡。所以这种方法只适用于通过 window.open() 或 document.open() 方法。可以在 [MDN 文档](https://developer.mozilla.org/en-US/docs/Web/API/Window/postMessage)中找到更多信息。

## 结论

希望本文内容足够精彩，能提供一些对 web 应用程序开发有用的技术知识。每种方法都是独特的，并且有相应的使用场景。

除了讨论的方法外，我们还可以使用 Websockets 和 Server-Sent 发送事件来跨浏览器选项卡甚至跨设备进行实时通信。但是，那将需要一个 Web 服务器来使用这些。本文中列出的服务器不依赖于 Web 服务器，因此它将能够快速处理浏览器内的通信。

感谢阅读！欢迎交流学习，相互帮助，共同进步！

编程愉快！❤️

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
