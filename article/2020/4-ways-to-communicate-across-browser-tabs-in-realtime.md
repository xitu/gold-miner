> * 原文地址：[4 Ways to Communicate Across Browser Tabs in Realtime](https://blog.bitsrc.io/4-ways-to-communicate-across-browser-tabs-in-realtime-e4f5f6cbedca)
> * 原文作者：[Dilantha Prasanjith](https://medium.com/@dilanthaprasanjith)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/4-ways-to-communicate-across-browser-tabs-in-realtime.md](https://github.com/xitu/gold-miner/blob/master/article/2020/4-ways-to-communicate-across-browser-tabs-in-realtime.md)
> * 译者：
> * 校对者：

# 4 Ways to Communicate Across Browser Tabs in Realtime

![Photo by [JOHN TOWNER](https://unsplash.com/@heytowner?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/8192/0*7c6YTCKtlLMAjuOn)

Over the years, Web Browser capabilities have ever increased due to the demands coming from web applications. As a result, we can find multiple ways of achieving similar functionality. One such feature we rarely look at is the ability to communicate across Browser Tabs. Let’s look at a few scenarios where you need this.

* Changing theme (e.g., Dark or Light theme) of the application propagates across the already opened Browser Tabs.
* Retrieve the latest token for authentication and share it across Browser Tabs.
* Synchronize the application state across Browser Tabs.

At the moment of writing this article, there were several approaches we can consider to communicate across Browsers. However, each method has its strengths and weaknesses. Therefore, I will discuss them in detail so that you can find the best one applicable to your use case.

## 1. Local Storage Events

You might have already used LocalStorage, which is accessible across Tabs within the same application origin. But do you know that it also supports events? You can use this feature to communicate across Browser Tabs, where other Tabs will receive the event once the storage is updated.

For example, let’s say in one Tab, we execute the following JavaScript code.

```js
window.localStorage.setItem("loggedIn", "true");
```

The other Tabs which listen to the event will receive it, as shown below.

```js
window.addEventListener('storage', (event) => {
 if (event.storageArea != localStorage) return;
 if (event.key === 'loggedIn') {
   // Do something with event.newValue
 }
});
```

However, it comes with several limitations.

* This event is not triggered for the Tab, which performs the storage set action.
* For a large chunk of data, this approach has adverse effects since LocalStorage is synchronous. And hence can block the main UI thread.

You can find more information in [MDN documentation for Storage Events](https://developer.mozilla.org/en-US/docs/Web/API/Window/storage_event).

## 2. Broadcast Channel API

The Broadcast Channel API allows communication between Tabs, Windows, Frames, Iframes, and [Web Workers](https://developer.mozilla.org/en-US/docs/Web/API/Web_Workers_API). One Tab can create and post to a channel as follows.

```js
const channel = new BroadcastChannel('app-data');
channel.postMessage(data);
```

And other Tabs can listen to channel as follows.

```js
const channel = new BroadcastChannel('app-data');

channel.addEventListener ('message', (event) => {
 console.log(event.data);
});
```

This way, Browser [contexts](https://developer.mozilla.org/en-US/docs/Glossary/browsing_context) (**Windows**, **Tabs**, **Frames**, or **Iframes**) can communicate. Even though this is a convenient way of communication between Browser Tabs, safari and IE does not support this. You can find more details in [MDN documentation for BroadcastChannel](https://developer.mozilla.org/en-US/docs/Web/API/Broadcast_Channel_API).

## 3. Service Worker Post Message

You might wonder, how Service Workers comes in to the picture. Basically, Service Workers also supports sending messages, which we can use to communicate across Browser Tabs.

Using Service Workers, you can send a message like shown below.

```js
navigator.serviceWorker.controller.postMessage({
 broadcast: data
});
```

And in the receiving Worker in the other Browser Tab can listen to the event.

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

This method gives more control and is a reliable way of passing messages. But implementing Service Workers requires some extra knowledge on Service Worker API and a little bit more work. So, in that case, if the other methods are not working, it would be better to look into this one. You can find more information in [MDN documentation for Service Worker API](https://developer.mozilla.org/en-US/docs/Web/API/ServiceWorkerRegistration) and a complete example referring to [this](https://googlechrome.github.io/samples/service-worker/post-message/) link.

## 4. Window Post Message

One of the traditional ways of communicating across Browser Tabs, Popups, and Iframes is `Window.postMessage()` method. You can send the message as follows.

```js
targetWindow.postMessage(message, targetOrigin)
```

And the target window can listen to the events, as shown below.

```js
window.addEventListener("message", (event) => {
  if (event.origin !== "http://localhost:8080")
    return;
  // Do something
}, false);
```

One advantage of this method over the others is the support for cross-origin communication is possible. But one of the limitations is that you need to have a reference to the other Browser Tab. So this approach only for Browser Tabs opened via window.open() or document.open(). You can find more information in [MDN documentation](https://developer.mozilla.org/en-US/docs/Web/API/Window/postMessage).

## Conclusion

I hope the article is informative, and you found several techniques that are useful for your web applications. Each method is unique and has specific use cases.

In addition to the methods discussed, we can also use Websockets and Server-Sent events to communicate across Browser Tabs and even across devices in Realtime. However, you will need a Web Server to use these. The ones listed in the article don’t depend on a Web Server, so it will be fast and capable of handling the communication within the Browser.

Thank You for reading along. And please share if you find any other mechanisms, and don’t forget to comment if you have any questions or doubts.

Happy Coding !!! ❤️

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
