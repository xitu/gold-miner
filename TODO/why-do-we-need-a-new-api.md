> * 原文地址：[Web Share API brings the native sharing capabilities to the browser](https://blog.hospodarets.com/web-share-api#why-do-we-need-a-new-api)
* 原文作者：[Serg Hospodarets](https://blog.hospodarets.com/about)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[Jiang Haichao](https://github.com/AceLeeWinnie)
* 校对者：

# Web Share API brings the native sharing capabilities to the browser #
# Web 共享 API 为浏览器赋能本地共享能力

For many years the Web is moving towards the parity with the Mobile native applications
and adds the missed features.
Today browsers have most of them, from the offline mode and enhancements with the Service Workers
to Geolocation and NFC.

多年来，Web 向着与移动设备本地应用等价的方向发展着，新增了许多以前没有的特性。

如今，浏览器支持了其中的大部分特性，从离线模式到丰富的 Service Workers 以及 Geolocation 和 NFC。

The one huge ability, which is still missed, but highly used in the mobile applications-
the ability to share a page, article or some specific data.

但其中最重要的功能仍然没有被支持，但已经在移动应用上广泛使用了，那就是共享页面，文章或一些特定数据的能力。

The Web Share API is the first step to fill the gap and bring the
native sharing capabilities to the Web.

Web 共享 API 是填补 Web 应用和本地共享能力之间缺口的第一步。

# Why do we need a new API #

# 为什么需要新的 API

Previous years there were many tries to deliver some API/agreement for the sharing in
the mobile Web applications:

之前许多年里，在移动 Web 应用上为了使一些 API/协议 能够实现共享功能进行过许多尝试：

1) [Web Intents](http://webintents.org/)
were introduced and implemented in Chrome 18 but
[deprecated in Chrome 24](https://developer.chrome.com/apps/app_intents)

1）[Web 意图](http://webintents.org/) 在 Chrome 18 上引进并实现了，但在 [Chrome 24 中废弃](https://developer.chrome.com/apps/app_intents)

2) There are couple solutions with custom URLs:

2）自定义 URL 也有许多解决方法：

- [Android intent: URLs](https://developer.chrome.com/multidevice/android/intents).
It is very powerful API, but it’s Android specific and
[there are dozens of problems to use this for the sharing](https://github.com/mgiuca/web-share/blob/master/docs/explainer.md#why-cant-sites-just-use-android-intent-urls)

- [Android 意图：URL](https://developer.chrome.com/multidevice/android/intents)。这是个强大的 API，但仅限 Android 并且用 [在共享上有许多问题](https://github.com/mgiuca/web-share/blob/master/docs/explainer.md#why-cant-sites-just-use-android-intent-urls)。 

- [Custom URL Schemes on macOS or iOS](https://css-tricks.com/create-url-scheme/)
also work and are provided, but they have similar problems as the Android solution

- [在 macOs 或 iOS 上自定义 URL Schema](https://css-tricks.com/create-url-scheme/) 也能正常工作并且被正确提供了，但是和 Android 解法有相似的问题存在。

3) Mozilla proposed [Web Activities](https://developer.mozilla.org/en-US/docs/Archive/Firefox_OS/API/Web_Activities)
but currently, they are obsolete and unsupported.

3) Mozilla 曾提出了 [Web Activities](https://developer.mozilla.org/en-US/docs/Archive/Firefox_OS/API/Web_Activities) 方案，但是已经被淘汰了，不再支持了。

So the current situation is that there isn’t API to simply share content on the Web.
But users need a way to quickly share URL/text/image data into their favorite apps and services easily.

所以现在的情况是，没有 API 能够支持 Web 上简单的内容分享功能。

但是用户需要一个快速分享的方式，能够方便地把 网址/文本/图片 数据分享到他们喜欢的 app 和服务上。

The current abilities are:
现在的能力是：

1. Share buttons to the specific services (which resulted in the number of API’s from the services and 
aggregators to provide just share buttons)

1. 针对特定服务的分享按钮（结果是产生众多服务和内容整合商仅提供分享按钮的 API）

2. Many browsers and applications provide their own specific share buttons.

2. 许多浏览器和应用程序提供自己特定的分享按钮。

But again, there isn’t a way to simply share content from the Web application.

但仍然没有从 Web 应用程序分享内容的简便方法。

# The Web Share API #

# Web 分享 API

The current Web Share API uses the best practices of non-blocking
[Promise](https://developer.mozilla.org/en/docs/Web/JavaScript/Reference/Global_Objects/Promise)-based API.

如今的 Web 分享 API 使用了非阻塞基于 [Promise](https://developer.mozilla.org/en/docs/Web/JavaScript/Reference/Global_Objects/Promise) API 的最佳实践。

From the data you can share, as for most other share APIs, there are `title`, `url`, and `text` (one of which is required).
There is a plan to allow image data and/or file blobs.

正如其他大多数分享 API 一样，你能够分享的数据包括 `title`, `url` 和 `text`（必填参数）。下面是允许分享图片数据或/和文件对象的方案。

Here how it looks:
如下所示：

```
function onShareClick(photo){
    // WEB SHARE API
    navigator.share({
        title: 'Checkout this funny photo',
        text: '',
        url: window.location.origin + '/' + photo.id 
    })
    .then(() => console.log('Successfully shared'))
    .catch((error) => console.log('Error sharing:', error));
}
```

[image credits](https://github.com/mgiuca/web-share/blob/master/docs/mocks/README.md)

As you see, the API is quite simple and currently expects at least one of the following fields:

如你所见，这个 API 相当简单，并且目前为止接收至少一个以下字段：

- `title` (string): The title of the document being shared (may be ignored by the handler).
- `text` (string): the text that forms the body of the message being shared.
- `url` (string): URL / URI to a resource being shared.

- `title` （string）： 被分享文档的标题（可能会被处理程序忽略）。
- `text`（string）：形成分享消息主体的文本。
- `url`（string）：被分享资源的 URL / URI 地址。 

The method returns a Promise.

这个方法返回一个 Promise。

It is resolved if the user chooses a target application, and that application accepts the data without errors.

如果用户选择了目标应用程序，它会被 resolve，同时目标应用成功接收数据。

There may be cases when the Promise is rejected:

Promise 被 reject 的情况有如下几种：

- invalid data to be shared (for instance, inappropriate fields passed)
- the user canceled the picker dialog or there is no app to share the data
- the data couldn’t be delivered to the target app

- 分享的是不可用数据（例如：传递错误字段）
- 用户取消对话框，或者没有目标应用
- 数据不能被传递到目标应用

# The data to be shared #

# 分享数据

For all the fields passed to the `navigator.share` there are many predefined values usually provided on the sites.

网站上传递到 `navigator.share` 的所有字段通常都有许多预定义的值。

For example, there is popular [Open Graph Markup](http://ogp.me/).
If your site uses it, you can simply reuse the values if you want to share the page data.

例如，流行的 [Open Graph Markup](http://ogp.me/)。
如果你的网站在使用它，那么你想分享网页数据时能够容易地重用值。

I used this approach for the demo:

我在下面的 demo 中使用了这个方法：

```
function getOpenGraphData(property){
    return document.querySelector(`meta[property="${property}"]`)
        .getAttribute('content');
}

const sharePage = () => {
        navigator.share({
            title: getOpenGraphData('og:title'),
            text: getOpenGraphData('og:description'),
            url: getOpenGraphData('og:url')
        }) //...
}
```

[Demo](/demos/web-share-api/)

Here is the video how it works

这里有一个视频示范如何使用它 

(tap the share button ➡️  tweet ➡️  check the tweet is added on Twitter):

（点击分享按钮 ➡️  tweet ➡️  在 Twitter 上新增的 tweet）：

![](https://hospodarets.com/img/blog/1485720302108099000.gif)

In the most common case, if you want to add an ability to share the data
from any of the pages, but you are not sure if there will be Open Graph or other tags,
here is the common pattern:

绝大多数通用方案中，如果你想拥有从任何页面分享数据的能力，但是并不确定是 Open Graph 还是其他标签，
这里有一个通用方案：

```
navigator.share({
    title: document.title,
    url: document.querySelector('link[rel=canonical]') ?
        document.querySelector('link[rel=canonical]').href :
        window.location.href
})
```

Where [`link[rel=canonical]`](https://en.wikipedia.org/wiki/Canonical_link_element) represent the optional but quite popular `<link>` element,
 which represents the URL to be used if the site has e.g. has e.g. a prefixed `mobile.` URL
 or other additions in the URL, which shouldn’t be shared.

[`link[rel=canonical]`](https://en.wikipedia.org/wiki/Canonical_link_element) 代表可选但是比 `<link>` 元素更通用，
意思是网站有例如 `mobile` 的前缀，URL 或者 URL 的其他部分不能被分享。

If the canonical link is not provided, the default URL is shared.

如果没有提供规范 link，那么分享的就是默认 URL。 

The latest suggestion, don’t remember to disable or fallback the share functionality if it’s not available
(browsers without support, devices without share capabilities etc.):

最新建议，如果不可用的话（浏览器不支持，设备没有分享功能），别忘了禁用或降级分享功能。

```
if(!navigator.share){
  shareButton.hidden = true;
  return;
}
// SHARE CODE
```

# Requirements #
# 要求

Currently, the Web share API is available in the stable Chrome on Android.

现在，Web 分享 API 在 Android 上稳定的 Chrome 版本中已经可用。

But, first of all, it requires HTTPS and secondary is enabled under the [Origin Trial](https://github.com/jpchase/OriginTrials/blob/gh-pages/developer-guide.md).

但首先，要求 HTTPS 环境，其次，在 [Origin Trial](https://github.com/jpchase/OriginTrials/blob/gh-pages/developer-guide.md) 下可用。

In short, the Origin Trial makes a way for developers to enable the API for a fixed period of time.
This will give the feedback for a vendor and the API authors/implementors.
You can interpret that like a flag for the browser you can enable for your site.
You can find the list of the available trials [here](https://github.com/jpchase/OriginTrials/blob/gh-pages/available-trials.md).

简而言之，Origin Trial 使得开发者能够在固定一段时间内启用 API。
这将给予供应商和 API 作者/提供商 反馈。
你可以把这解释为网站启用了一个类似浏览器 flag。

To enable the Web Share API you need:

要启用 Web 分享 API，你需要：

1. [Sign up to get the trial token](https://docs.google.com/forms/d/e/1FAIpQLSfO0_ptFl8r8G0UFhT0xhV17eabG-erUWBDiKSRDTqEZ_9ULQ/viewform)
2. During the next 24 hours, you are sent an email with the Trial Token and details how to include it to the Web App
3. You include the token via header or directly into the page HTML, globally or everywhere where you want to use the API:

1. [登录并获取试用 token](https://docs.google.com/forms/d/e/1FAIpQLSfO0_ptFl8r8G0UFhT0xhV17eabG-erUWBDiKSRDTqEZ_9ULQ/viewform)
2. 24 小时内，你将收到一封邮件，里面包含试用 Token 和如何在 Web 应用中使用的说明
3. 在 header 中或者直接在网页的 HTML，全局任何你想使用这个 API 的地方加上下面这段代码

```
<metahttp-equiv="origin-trial"data-feature="Web Share"content="TOKEN_FROM_THE_EMAIL">
```

Web Share trial was introduced in Chrome 55 and may end in April 2017, after which may be enabled by default in the browser.

Web 分享试用在 Chrome 55 上引入了，将支持到 2017 年 4 月，在那之后也许会在浏览器中默认开启。 

Let’s summarize the steps to make the Web Share API work:

总结一下启用 Web 分享 API 的步骤：

1. The site is served via HTTPS
2. The origin trial header/meta is provided till the API enabled by default
3. `navigator.share()` is called via user action (click, tap..)

1. 网站在 HTTPS 环境下
2. 把 origin trial 相关的 header/meta 加入到页面上
3. 用户行为（点击，触摸）触发并调用 `navigator.share()`   

# Conclusion #

# 结论

The Web is moving forward to remove the border between the mobile Web and Native apps, and 
the Web Share API is the next step to it you can use today.

随着 Web 的发展，移动 Web 与原生应用之间的界限越来越模糊，Web 分享 API 就是革命的下一步，如今你就可以使用了。

The future work will be around the implementation of the API to other platforms and adding the ability to
provide image data or share files (blob).

未来的工作将围绕跨平台 API 的实现，图片数据的提供或者文件（二进制对象）的分享。

Also, there is a discussion for the web apps to receive shares, not just send them.
同时，不仅限于发送，关于 Web 应用的分享接收也有一个讨论。
This is called the
[Web Share Target API](https://github.com/mgiuca/web-share/blob/master/docs/explainer.md#how-can-a-web-app-receive-a-share-from-another-page0)
and we may hear more from there after a while.

在 [Web 分享目标 API](https://github.com/mgiuca/web-share/blob/master/docs/explainer.md#how-can-a-web-app-receive-a-share-from-another-page0) 中，我们也许能了解更多分享之后的事情。

And the list of the useful links in the end:

最后，以下是一份有用的链接清单：

- [Web Share API Proposal](https://github.com/WICG/web-share)
- [Intent to Experiment: Web Share on Android](https://groups.google.com/a/chromium.org/forum/#!msg/blink-dev/zuqQaLp3js8/5V9wpRWhBgAJ)

- [Web 分享 API 提案](https://github.com/WICG/web-share)
- [实验方案：Android 中的 Web 分享](https://groups.google.com/a/chromium.org/forum/#!msg/blink-dev/zuqQaLp3js8/5V9wpRWhBgAJ)
