> * 原文地址：[Send Data to the Server When the User Navigates to Another Page using JavaScript](https://javascript.plainenglish.io/send-data-to-the-server-when-the-user-navigates-to-another-page-using-javascript-d98a0a4a0539)
> * 原文作者：[Jatin](https://medium.com/@jatin.krr)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2022/send-data-to-the-server-when-the-user-navigates-to-another-page-using-javascript.md](https://github.com/xitu/gold-miner/blob/master/article/2022/send-data-to-the-server-when-the-user-navigates-to-another-page-using-javascript.md)
> * 译者：娇娇娇娇
> * 校对者：

# Send Data to the Server When the User Navigates to Another Page using JavaScript

当用户跳转到其它页面时，使用 JavaScript 发送数据给服务器

![Photo by [Edho Pratama](https://unsplash.com/@edhoradic?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/9044/0*0RbNvyMds_7IaOac)

As a developer, you might have come across a use case to detect if the user navigates to a new page, switches tabs, closes the tab, minimizes or closes the browser, or, on mobile, switches from the browser to a different app. In this article, we will be looking at how to detect if contents of the tab have become visible or have been hidden and then transmit the analytics data to the server.

作为一个开发者，你可能会碰到这样一种场景：就是去判断用户是导航到了新页面，是切换了tab，还是关闭了tab，是缩小还是关闭了浏览器；或者判断用户在移动端上是否从浏览器切换到了其它 app 上。在这篇文章中我们将会研究如何判断 tab 上内容的是显示还是隐藏状态，然后把分析之后的数据发送给服务器。

## Detecting changes on the page
察觉页面的变化

The **visibilitychange** event is used to track hidden/visible behaviour on the tab. This event is available in all modern browsers and can be called directly through the** document **object.

**visibilitychange** 方法是用于记录 tab 上的显隐行为。这个方法可以在所有的现代浏览器中获取到，并且可以直接通过 document 对象来调用。


The **visibilitychange** event can have only two possible values which are **visible** and **hidden**.

调用**visibilitychange**方法只可能得到两个可能的值： visible （显示）和 hidden（隐藏）。

If the value of the visibilitychange event changes to “hidden”, then it's likely the end of the user’s session.

如果调用 visibilitychange 方法的返回的结果是 hidden ，表示用户很有可能要离开当前页面。

```js
document.addEventListener('visibilitychange', function() {
  if (document.visibilityState === 'hidden') {
    // user session ended
  }
});
```

Alternatively, if the value of the visibilitychange event changes to “visible”, then it means the user is back on the page.

另外，如果调用 visibilitychange 方法返回的结果是 visible，那这就意味着用户又回到了当前页面。

```js
document.addEventListener('visibilitychange', function() {
  if (document.visibilityState === 'visible') {
    // user is back
  }
});
```

There is an event handler called **onvisibilitychange** which can be used to observe visibility changes on the **visibilitychange** event property.

有一个叫做**onvisibilitychange**的事件处理方法可以用来监听**visibilitychange**方法属性显隐的变化。

```js
document.onvisibilitychange = function() {
  // visibility of page has changed
};
```

## Transmitting analytical data to the server

把分析后的数据发送给服务端

The Web APIs provide a **navigator** object which contains **sendBeacon()** method that enables us to send a small amount of data to the web server asynchronously.

Web APIs 提供了一个 **navigator** 对象，这个对象包含了**sendBeacon()**方法。**sendBeacon()**方法允许我们异步地把少量数据发送给服务器。

The sendBeacon accepts two parameters, given below:

sendBeacon 方法接受两个参数，参数以及参数的解释如下：

* **Url**: The relative or absolute URL that will receive the data.

1. url ： 将接收数据的相对的或绝对的 URl。

* **Data**: An object containing the data which is intended for the server.

2. 数据：包含用于服务器的数据的对象。


Supported data types are **ArrayBuffer**, **ArrayBufferView**, **Blob**, **DOMString**, **FormData** or **URLSearchParams**.

第二个参数 data 接收的数据类型有 **ArrayBuffer**, **ArrayBufferView**, **Blob**, **DOMString**, **FormData** 或者 **URLSearchParams**。

The **sendBeacon()** method returns **true** if the data is successfully sent to the given URL for transfer. Otherwise, it returns **false**.

如果数据成功发送到指定的 url 进行数据传输， **sendBeacon()**会返回 true。否则，就会返回 false 。

The sendBeacon method is a better way of sending analytics data as compared to other legacy techniques for sending analytics such as XMLHttpRequest. Unlike an XMLHTTPRequest which can be cancelled when the page is unloaded, **sendBeacon** request ensures the request is sent to the server without being interrupted.

和其它传统技术（像 XMLHttpRequest）相比, sendBeacon 方法是一种更好的发送分析数据的方式。因为通过 XMLHTTPRequest 发送的请求会在页面未被加载时会被取消，而**sendBeacon**确保了在它在给服务器发请求时不被打断。

The request sent through the sendBeacon method will be queued by the user agent which means the data will be sent as long as the network connection is available even if the user closes the web app, the data will be transmitted eventually.

通过 sendBeacon 方法发送的请求会被用户代理存储在队列中，也就是说只要网络连接是可用的，即使用户关闭了 app , 数据还是会被传输给 app 。

The **sendBeacon** method can be triggered when the **visibilityState** event changes to the “hidden” to send the analytics data to the server.

当 visibilityState 方法的返回结果变为隐藏时，就会触发 sendBeacon 方法把分析数据发送给服务器。

**Code implementation**

代码实现如下：

```js
document.addEventListener('visibilitychange', function() {
  if (document.visibilityState === 'hidden') {
    navigator.sendBeacon('/analyticslog', data);
  }
});
```

---

For more information, refer to the Mozilla docs given below:

想了解更多的信息，请参考下面给出的文档：

- [**Document: visibilitychange event - Web APIs | MDN**](https://developer.mozilla.org/en-US/docs/Web/API/Document/visibilitychange_event)
- [**Document.onvisibilitychange - Web APIs | MDN**](https://developer.mozilla.org/en-US/docs/Web/API/Document/onvisibilitychange)
- [**Navigator.sendBeacon() - Web APIs | MDN**](https://developer.mozilla.org/en-US/docs/Web/API/Navigator/sendBeacon)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
