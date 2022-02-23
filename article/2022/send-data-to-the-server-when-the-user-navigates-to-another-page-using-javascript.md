> * 原文地址：[Send Data to the Server When the User Navigates to Another Page using JavaScript](https://javascript.plainenglish.io/send-data-to-the-server-when-the-user-navigates-to-another-page-using-javascript-d98a0a4a0539)
> * 原文作者：[Jatin](https://medium.com/@jatin.krr)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2022/send-data-to-the-server-when-the-user-navigates-to-another-page-using-javascript.md](https://github.com/xitu/gold-miner/blob/master/article/2022/send-data-to-the-server-when-the-user-navigates-to-another-page-using-javascript.md)
> * 译者：
> * 校对者：

# Send Data to the Server When the User Navigates to Another Page using JavaScript

![Photo by [Edho Pratama](https://unsplash.com/@edhoradic?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/9044/0*0RbNvyMds_7IaOac)

As a developer, you might have come across a use case to detect if the user navigates to a new page, switches tabs, closes the tab, minimizes or closes the browser, or, on mobile, switches from the browser to a different app. In this article, we will be looking at how to detect if contents of the tab have become visible or have been hidden and then transmit the analytics data to the server.

## Detecting changes on the page

The **visibilitychange** event is used to track hidden/visible behaviour on the tab. This event is available in all modern browsers and can be called directly through the** document **object.

The **visibilitychange** event can have only two possible values which are **visible** and **hidden**.

If the value of the visibilitychange event changes to “hidden”, then it's likely the end of the user’s session.

```js
document.addEventListener('visibilitychange', function() {
  if (document.visibilityState === 'hidden') {
    // user session ended
  }
});
```

Alternatively, if the value of the visibilitychange event changes to “visible”, then it means the user is back on the page.

```js
document.addEventListener('visibilitychange', function() {
  if (document.visibilityState === 'visible') {
    // user is back
  }
});
```

There is an event handler called **onvisibilitychange** which can be used to observe visibility changes on the **visibilitychange** event property**.**

```js
document.onvisibilitychange = function() {
  // visibility of page has changed
};
```

## Transmitting analytical data to the server

The Web APIs provide a **navigator** object which contains **sendBeacon()** method that enables us to send a small amount of data to the web server asynchronously.

The sendBeacon accepts two parameters, given below:

* **Url**: The relative or absolute URL that will receive the data.
* **Data**: An object containing the data which is intended for the server.

Supported data types are **ArrayBuffer**, **ArrayBufferView**, **Blob**, **DOMString**, **FormData** or **URLSearchParams**.

The **sendBeacon()** method returns **true** if the data is successfully sent to the given URL for transfer. Otherwise, it returns **false**.

The sendBeacon method is a better way of sending analytics data as compared to other legacy techniques for sending analytics such as XMLHttpRequest. Unlike an XMLHTTPRequest which can be cancelled when the page is unloaded, **sendBeacon** request ensures the request is sent to the server without being interrupted.

The request sent through the sendBeacon method will be queued by the user agent which means the data will be sent as long as the network connection is available even if the user closes the web app, the data will be transmitted eventually.

The **sendBeacon** method can be triggered when the **visibilityState** event changes to the “hidden” to send the analytics data to the server.

**Code implementation**

```js
document.addEventListener('visibilitychange', function() {
  if (document.visibilityState === 'hidden') {
    navigator.sendBeacon('/analyticslog', data);
  }
});
```

---

For more information, refer to the Mozilla docs given below:
[**Document: visibilitychange event - Web APIs | MDN**
**The visibilitychange event is fired at the document when the contents of its tab have become visible or have been…**developer.mozilla.org](https://developer.mozilla.org/en-US/docs/Web/API/Document/visibilitychange_event)
[**Document.onvisibilitychange - Web APIs | MDN**
**The Document.onvisibilitychange property represents the event handler that is called when avisibilitychange event…**developer.mozilla.org](https://developer.mozilla.org/en-US/docs/Web/API/Document/onvisibilitychange)
[**Navigator.sendBeacon() - Web APIs | MDN**
**The navigator.sendBeacon() method asynchronously sends an HTTP POST request containing a small amount of data to a web…**developer.mozilla.org](https://developer.mozilla.org/en-US/docs/Web/API/Navigator/sendBeacon)

**More content at[** plainenglish.io**](http://plainenglish.io/). Sign up for our[** free weekly newsletter**](http://newsletter.plainenglish.io/). Get exclusive access to writing opportunities and advice in our[** community Discord**](https://discord.gg/GtDtUAvyhW).**

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
