> * 原文地址：[Send Data to the Server When the User Navigates to Another Page using JavaScript](https://javascript.plainenglish.io/send-data-to-the-server-when-the-user-navigates-to-another-page-using-javascript-d98a0a4a0539)
> * 原文作者：[Jatin](https://medium.com/@jatin.krr)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2022/send-data-to-the-server-when-the-user-navigates-to-another-page-using-javascript.md](https://github.com/xitu/gold-miner/blob/master/article/2022/send-data-to-the-server-when-the-user-navigates-to-another-page-using-javascript.md)
> * 译者：[jjCatherine](https://github.com/xyj1020)
> * 校对者：[Z招锦](https://github.com/zenblofe)、[finalwhy](https://github.com/finalwhy)

# 使用 JavaScript 处理用户页面跳转时的数据发送

![Photo by [Edho Pratama](https://unsplash.com/@edhoradic?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/9044/0*0RbNvyMds_7IaOac)

作为一个开发者，你可能会碰到这样的场景：在 PC 端，浏览器需要监听用户是否跳转到了新页面？还是切换/关闭了 Tab？亦或是缩小/关闭了浏览器？或者在移动端，监听用户是否从浏览器切换到了其它 App。在这篇文章中，我们将会研究如何判断 Tab 上内容的是显示或隐藏状态，然后把分析数据发送给服务器。

## 监听页面的变化

**visibilitychange** 事件可用于记录 Tab 页的显示/隐藏行为。这个事件在所有现代浏览器中都是可用的，并且可以直接通过 document 对象来调用（译者注：即可直接通过 `document.addEventListener('visibilitychange', ... ) ` 注册事件处理函数）。

调用 **visibilitychange** 方法只可能得到两个可能的值： visible （显示）和 hidden（隐藏）。

如果 `visibilitychange` 事件的值变为 hidden ，则可能意味着用户要离开这个页面了（译者注：实际上，visibilitychange 事件的回调函数是没有传入标明当前页面可见性的参数的，开发者需要在回调函数中访问 document.visibilityState 变量来获取当前具体的页面可见状态）。

```js
document.addEventListener('visibilitychange', function() {
  if (document.visibilityState === 'hidden') {
    // user session ended
  }
});
```

另外，如果调用 visibilitychange 事件返回的结果是 visible，那这就意味着用户又回到了当前页面。

```js
document.addEventListener('visibilitychange', function() {
  if (document.visibilityState === 'visible') {
    // user is back
  }
});
```

有一个叫做 **onvisibilitychange** 的事件处理方法可以用来监听 **visibilitychange** 方法的显示或隐藏属性变化。

```js
document.onvisibilitychange = function() {
  // visibility of page has changed
};
```

## 发送分析数据到服务端

Web APIs 提供了一个 **navigator** 对象，这个对象包含了 **sendBeacon()** 方法。**sendBeacon()** 方法允许我们异步地把少量数据发送给服务器。

sendBeacon 方法接受两个参数：

1. **Url**: 将接收数据的相对或绝对 URl。
2. **Data**：含有作用于服务器数据的对象。

第二个参数 data 接收的数据类型有 **ArrayBuffer**, **ArrayBufferView**, **Blob**, **DOMString**, **FormData** 或者 **URLSearchParams**。

如果数据成功发送到指定的 url 进行数据传输， **sendBeacon()** 会返回 true。否则，就会返回 false 。

和其它传统技术（像 XMLHttpRequest）相比, sendBeacon 方法是一种更好的发送分析数据的方式。因为通过 XMLHTTPRequest 发送的请求在页面未被加载时会被取消，而 **sendBeacon** 确保了在给服务器发请求时不被打断。

通过 sendBeacon 方法发送的请求会被用户代理存储在队列中，这也就意味着只要网络是可用的，即使用户关闭了 App，数据最终也会被传输。

当 visibilityState 的值变为 hidden 时，（开发者）就可以调用 sendBeacon 方法把分析数据发送给服务端。

代码实现如下：

```js
document.addEventListener('visibilitychange', function() {
  if (document.visibilityState === 'hidden') {
    navigator.sendBeacon('/analyticslog', data);
  }
});
```

---

想了解更多的信息，请参考以下 Mozilla 文档：

- [**Document: visibilitychange event - Web APIs | MDN**](https://developer.mozilla.org/en-US/docs/Web/API/Document/visibilitychange_event)
- [**Document.onvisibilitychange - Web APIs | MDN**](https://developer.mozilla.org/en-US/docs/Web/API/Document/onvisibilitychange)
- [**Navigator.sendBeacon() - Web APIs | MDN**](https://developer.mozilla.org/en-US/docs/Web/API/Navigator/sendBeacon)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
