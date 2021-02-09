> * 原文地址：[An Overview of HTTP Requests & Cross-Origin Resource Sharing (CORS)](https://medium.com/javascript-in-plain-english/quick-overview-of-http-requests-cross-origin-resource-sharing-cors-db139b41d71)
> * 原文作者：[Bilge Demirkaya](https://medium.com/@bilgedemirkaya)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/quick-overview-of-http-requests-cross-origin-resource-sharing-cors.md](https://github.com/xitu/gold-miner/blob/master/article/2021/quick-overview-of-http-requests-cross-origin-resource-sharing-cors.md)
> * 译者：[zenblo](https://github.com/zenblo)
> * 校对者：[PassionPenguin](https://github.com/PassionPenguin)、[regon-cao](https://github.com/regon-cao)

# 简述 HTTP 请求与跨域资源共享 CORS

![图片源自 [Alina Grubnyak](https://unsplash.com/@alinnnaaaa?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) on [Unsplash](https://unsplash.com/s/photos/network?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)](https://cdn-images-1.medium.com/max/6912/1*YECeOxlko9KoOJNw8RNm3A.jpeg)

## URL 简介

以下示例 URL 由 4 部分组成：

![](https://cdn-images-1.medium.com/max/2000/1*HfJAWr4Jw7rIXHSRaG4wcw.png)

**服务类型（Scheme）** 指明将被使用的协议（Protocol）。**协议**指定数据如何传输以及如何处理请求。当你查看协议时，你就能很好地理解这个 URL 的用途。（例如是带有 SMTP、POP3、IMAP 的电子邮件协议，还是获取和管理 git 仓库的 SSH 请求，或者是针对 Web 的 HTTP 请求。）

**HTTP** — 默认是在 80 端口运行，它指定请求中的表头。

**HTTPS** — 与 **HTTP** 协议类似，但 HTTPS 被认为是浏览器与服务器之间的安全通信。它与 HTTP 不同之处：

* 默认是在 443 端口运行
* 加密除 IP 请求之外的所有请求或响应头

**主机名（Host name）：**

只是一个更好命名的 IP 地址。

**路径（Path）：**

URL 路径就像你的目录路径。它为用户和搜索引擎提供了解当前所在的部分，例如 `/about` 部分。这有助于实现更好的搜索引擎优化（SEO）。

**查询参数（Query parameters）：**

它用于将数据发送到服务器。通常出于营销原因使用它来查看广告的效果。以 `?` 开始，用 `&` 分隔数据。

> **注意**：由于安全原因，不建议发送带有查询参数的数据（这样每个人都可以看到），并且它有一个字符限制（限制在 2048 个字符以内）。

**使用 HTTP 和 HTTPS 协议，我们还有其他方法可以将数据发送到服务器。**

## 请求与响应

![Taken from C0D3.com](https://cdn-images-1.medium.com/max/2000/1*8S-OTIgudIC9wOIbN3VETg.png)

当用户在浏览器中输入域名时，浏览器会找到该服务器（这只是其他人的计算机）并向该服务器发送请求。如果它从服务器成功获取响应，就会在浏览器上呈现相应的页面。

> **注意**：当你使用终端发送请求（例如运行 `node index.js`）时，进程是相同的。向服务器发送请求不一定需要浏览器，也可以使用终端。然而，如果响应是 HTML，那么终端不会做任何事情，因为 HTML 只是浏览器的指令。

## 表头部分

浏览器和服务器都需要获取对方的大量信息，才能识别对方，并最终发送请求或响应。比如 IP 地址、内容类型（Content-Type）、Cookie、[缓存控制（Cache-Control）](https://en.wikipedia.org/wiki/Cache-Control)等。你可以在这里找到[完整列表](https://en.wikipedia.org/wiki/List_of_HTTP_header_fields)，它们带着**表头**数据也就是**键值对**。

![Request Headers Example | Taken from C0D3.com](https://cdn-images-1.medium.com/max/2000/1*kJ2ViLP32reDBOfeYHB46Q.png)

在发送请求时，只需要手动设置两个表头：**内容类型（Content-Type）**和**授权（Authorization）**。虽然你可以设置其它表头，但它们通常由浏览器自动处理。

**内容类型（Content-Type）** — 当你通过正文向服务器发送（POST、PATCH、PUT 请求）数据时，你需要指定其内容类型，可以是 `application/json`、`text/html`、`image/gif` 或 `video/mpeg.`。

**授权（Authorization）** — 这是服务器用来识别用户的。与 cookie 表头不同，该表头必须由开发人员在发送请求时手动设置。通常用于 API 请求和 JWT 身份验证。

## 请求处理

通过互联网发送的每个请求包括 2 个必填部分和 1 个可选部分。

1. **请求行**：由请求方法（GET、POST、DELETE 等）和路径（从 URL 中提取）组成。
2. **表头**：上文已经简要说明过。
3. **请求体**（可选）： 向服务器发出 POST、PUT、PATCH 请求时，需要发送一个请求体报文，该报文告诉服务器你想要发送什么数据。示例：

```js
axios.post(‘/users’, 
{id: “5fddfefc4fbd19494493cd71”, name: "username"} // 这部分是请求体
).then(console.log)
```

* **axios** 是一个发送请求的库。浏览器还提供了一个叫做 **fetch** 的函数，可以用来发送请求。另外还有一个用于发送请求的过时请求库。
* **post** 是请求方法，表明我们正在向服务器发送信息。可以在[这里](https://developer.mozilla.org/en-US/docs/Web/HTTP/Methods)详细查看 HTTP 请求方法。
* **`/users`** 是指定你在服务器中发送该请求的确切位置的路径。这个 URL 部分其实叫 API。当一个 API 遵循 **REST** 模式时，它就变成了 **REST API**，让开发人员可以快速理解和使用 API。例如像 REST 模式所说的，**路径**应该总是复数形式。

> **REST** 是指表述性状态传递，它是一组设计原则，允许你使用 API 和修改服务器上的资源。

* **请求体**是数据对象本身，因此服务器可以获取该数据。

如上所述，除了在浏览器中输入域名外，还有多种方法可以将请求发送到服务器。

> **AJAX**：从浏览器发送请求。如果有人说了解 ajax，这意味着他知道如何从浏览器发送请求。

## 跨域资源共享

**OPTIONS** 请求也叫做**预处理请求（pre-flight requests）**

当前，你看到的响应来自 **medium.com** 服务器。假设我写了一个 JS 代码，当你在网页浏览这个的时候，它正在向我自己的网站服务器发送一个 POST 请求。这称为跨域请求（**Cross-Domain request**）。

> **跨域请求（Cross-Domain request）**：发送到与你当前所在 url 主机名不同的 url 请求。

例如我想使用 JS 代码从浏览器发送另一个请求到另一个域（另一个服务器），但你会发现这并不容易。出于安全原因，浏览器限制从脚本发起的跨源 HTTP 请求。

[同源安全策略](https://en.wikipedia.org/wiki/Same-origin_policy)默认禁止某些`跨域（Cross-Domain）`请求，尤其是 Ajax 请求，而始终允许`相同来源（Same-Origin）`请求。

**CORS** 定义了浏览器和服务器可以交互的方式，并确定允许跨域请求是否安全。

> **跨域资源共享**（[CORS](https://developer.mozilla.org/en-US/docs/Glossary/CORS)）是基于 HTTP 表头的机制，它允许服务器指出浏览器应该允许加载资源的任何其他[来源](https://developer.mozilla.org/en-US/docs/Glossary/origin)（域、协议或端口）。

![Taken from [https://developer.mozilla.org/en-US/docs/Web/HTTP/CORS](https://developer.mozilla.org/en-US/docs/Web/HTTP/CORS)](https://cdn-images-1.medium.com/max/2000/1*J35DcnM_wbU9b4C5IZvkpQ.png)

## 跨域请求分析

当浏览器发现域是不同的，它会向该服务器发送一个 **OPTIONS** 请求，检查请求是否被允许。这个行为与我们开发人员其实并没有什么关系，因为这是浏览器自动进行的行为。然而开发人员可以在发送跨域请求之前，向请求添加一些表头，这可能有助于获得允许。

就像其它浏览器请求一样，表头中的一些数据会提供一些信息。例如，通过 OPTIONS 方法发送的 [Access-Control-Request-Method](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Access-Control-Request-Method) 表头会提供一些信息：真实请求何时到来，数据类型是什么，请求方法是什么等。

在这种情况下，服务器可以响应是否接受请求，至于其余部分则取决于服务器。作为响应，服务器可以发回 [Access-Control-Allow-Origin](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Access-Control-Allow-Origin) 表头，表明资源可以被任何域访问。

虽然它允许来自其他域的 GET 请求，但它可能限制 POST 请求。

## 跨域请求响应头

**Access-Control-Allow-Origin** — 包含允许发送跨域请求的主机名。如果这与用户所在站点的主机名不匹配，则将拒绝跨域请求。

**Access-Control-Allow-Credentials** — 如果在响应头中为 true，则跨域请求将包含 Cookie 表头。

**Access-Control-Allow-Methods** — 这是一个逗号分隔的字符串，它告诉浏览器跨域请求中允许使用哪种请求方法。如果请求方法未包含在此响应头中，则不会发送请求。

使用一段 Node.js 代码设置表头：

```js
router.options('/api/*', (req, res) => {
  res.header('Access-Control-Allow-Credentials', true)
  res.header('Access-Control-Allow-Origin', req.headers.origin)
  res.header('Access-Control-Allow-Methods', 'GET, PUT, POST, PATCH, DELETE')
  res.header(
    'Access-Control-Allow-Headers',
    'Origin, X-Requested-With, Content-Type, Accept, Credentials'
  )
  res.send('ok')
})
```

## 总结

CORS 标准意味着，服务器开发人员必须处理新的请求和响应头。他们需要用表头来划清界限，这样才能防止安全漏洞。

在这篇文章中我尝试着以最简明的方式来介绍这些重要的概念，如果你有任何疑问或想在上述一个特定主题中了解更多信息，请记得告诉我。

感谢阅读！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
