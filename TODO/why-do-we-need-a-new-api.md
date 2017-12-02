> * 原文地址：[Web Share API brings the native sharing capabilities to the browser](https://blog.hospodarets.com/web-share-api#why-do-we-need-a-new-api)
* 原文作者：[Serg Hospodarets](https://blog.hospodarets.com/about)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[Jiang Haichao](https://github.com/AceLeeWinnie)
* 校对者：[xilihuasi](https://github.com/xilihuasi),[IridescentMia](https://github.com/IridescentMia)

# Web 分享 API 赋予浏览器原生分享能力

多年来，Web 一直向着与移动原生应用等价的方向发展，并且新增了许多以前没有的特性。
如今，浏览器支持了其中的大部分特性，从离线模式到用 Service Workers 增强体验以及 Geolocation 和 NFC。

但有一种已经在移动应用上广泛使用的重要功能仍然缺失，那就是分享页面、文章或一些特定数据的功能。

Web 分享 API 是填补这种缺失的第一步，它将把原生的分享能力带到 Web 端。

# 为什么需要新的 API

前几年，在移动 Web 应用上尝试实现了一些 API/协议 能够实现分享功能：

1）[Web Intents](http://webintents.org/) 在 Chrome 15 引入并实现，但在 [Chrome 24 中废弃](https://developer.chrome.com/apps/app_intents)

2）也有许多自定义 URL 的解决方法：

- [Android Intent：URL](https://developer.chrome.com/multidevice/android/intents)。这是个强大的 API，但仅限 Android 并且用 [在分享上有许多问题](https://github.com/mgiuca/web-share/blob/master/docs/explainer.md#why-cant-sites-just-use-android-intent-urls)。 
- [在 macOs 或 iOS 上自定义 URL Schema](https://css-tricks.com/create-url-scheme/) 也能运行并且支持良好，但是和 Android 解法有相似的问题存在。

3) Mozilla 曾提出了 [Web Activities](https://developer.mozilla.org/en-US/docs/Archive/Firefox_OS/API/Web_Activities) 方案，但是已经被淘汰，不再支持了。

所以现在的情况是，没有 API 能够支持 Web 上简单的内容分享功能。
但是用户需要一个快速分享的方式，能够方便地把 网址/文本/图片 等数据分享到他们喜欢的 app 和服务上。

现在的能提供的是：

1. 针对特定服务的分享按钮（将导致众多服务和内容整合商仅提供分享按钮的 API）

2. 许多浏览器和应用程序提供自己特定的分享按钮。

但仍然没有从 Web 应用程序分享内容的简便方法。

# Web 分享 API

如今的 Web 分享 API 是基于 [Promise](https://developer.mozilla.org/en/docs/Web/JavaScript/Reference/Global_Objects/Promise) 的非阻塞API 的最佳实践。

正如其他大多数分享 API 一样，你能够分享的数据包括 `title`, `url` 和 `text`（三者至少一项为必填项）。
下面是允许分享图片数据或/和文件对象的方案。

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

如你所见，这个 API 相当简单，并且目前为止接收至少一个以下字段：

- `title` （string）： 被分享文档的标题（可能会被处理程序忽略）。
- `text`（string）：形成分享消息主体的文本。
- `url`（string）：被分享资源的 URL / URI 地址。 

这个方法返回一个 Promise。

如果用户选择了目标应用程序，它会被 resolve，同时目标应用成功接收数据。

Promise 被 reject 的情况有如下几种：

- 分享的是不可用数据（例如：传递错误字段）
- 用户取消对话框，或者没有目标应用
- 数据不能被传递到目标应用

# 分享的数据

网站上传递到 `navigator.share` 的所有字段通常都有许多预定义的值。

例如，流行的 [Open Graph Markup](http://ogp.me/)。
如果你的网站在使用它，那么你想分享网页数据时能够容易地重用值。

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

这里有一个视频示范如何使用它 

（点击分享按钮 ➡️  tweet ➡️  在 Twitter 上新增的 tweet）：

![](https://hospodarets.com/img/blog/1485720302108099000.gif)

绝大多数情况下，如果你想拥有从任何页面分享数据的能力，但是并不确定是 Open Graph 还是其他标签，
这里有一个通用方案：

```
navigator.share({
    title: document.title,
    url: document.querySelector('link[rel=canonical]') ?
        document.querySelector('link[rel=canonical]').href :
        window.location.href
})
```

[`link[rel=canonical]`](https://en.wikipedia.org/wiki/Canonical_link_element) 代表可选但是更通用的 `<link>` 元素，
意思是使用这个元素内 href 标签指向的 URL。 如果网站的 URL 有例如 `mobile` 的前缀或者其他内容，则这个 URL 不应该被分享。

如果没有提供规范 link，那么分享的就是默认 URL。 

最新建议，如果不可用的话（浏览器不支持，设备没有分享功能等），别忘了禁用或撤销分享功能。

```
if(!navigator.share){
  shareButton.hidden = true;
  return;
}
// SHARE CODE
```

# 要求

现在，Web 分享 API 在 Android 上稳定的 Chrome 版本中已经可用。

但首先，要求 HTTPS 环境，其次，在 [Origin Trial](https://github.com/jpchase/OriginTrials/blob/gh-pages/developer-guide.md) 下可用。

简而言之，Origin Trial 使得开发者能够在固定一段时间内启用 API。
这将给予供应商和 API 作者/提供商 反馈。
你可以把它理解为你的网站可以在浏览器下启用分享的一个标志。
你可以在这里找到一些可用的尝试 [here](https://github.com/jpchase/OriginTrials/blob/gh-pages/available-trials.md)。

要启用 Web 分享 API，你需要：

1. [登录并获取试用 token](https://docs.google.com/forms/d/e/1FAIpQLSfO0_ptFl8r8G0UFhT0xhV17eabG-erUWBDiKSRDTqEZ_9ULQ/viewform)
2. 24 小时内，你将收到一封邮件，里面包含试用 Token 和如何在 Web 应用中使用的说明
3. 在 header 中或者直接在网页的 HTML，全局任何你想使用这个 API 的地方加上下面这段代码

```
<metahttp-equiv="origin-trial"data-feature="Web Share"content="TOKEN_FROM_THE_EMAIL">
```

Web 分享试用在 Chrome 55 上引入了，将支持到 2017 年 4 月，在那之后也许会在浏览器中默认开启。 

总结一下启用 Web 分享 API 的步骤：

1. 网站在 HTTPS 环境下
2. 把 origin trial 相关的 header/meta 加入到页面上
3. 用户行为（点击，触摸）触发并调用 `navigator.share()`   

# 总结

随着 Web 的发展，移动 Web 与原生应用之间的界限越来越模糊，Web 分享 API 就是革命的下一步，如今你就可以使用了。

未来的工作将围绕跨平台 API 的实现，图片数据的提供或者文件（二进制对象）的分享。

同时，不仅限于发送，关于 Web 应用的分享接收也有一个讨论。

在 [Web 分享目标 API](https://github.com/mgiuca/web-share/blob/master/docs/explainer.md#how-can-a-web-app-receive-a-share-from-another-page0) 中，我们也许能了解更多分享之后的事情。

最后，以下是一份有用的链接清单：

- [Web 分享 API 提案](https://github.com/WICG/web-share)
- [实验方案：Android 中的 Web 分享](https://groups.google.com/a/chromium.org/forum/#!msg/blink-dev/zuqQaLp3js8/5V9wpRWhBgAJ)
