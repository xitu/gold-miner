> * 原文地址：[An Overview of HTTP Requests & Cross-Origin Resource Sharing (CORS)](https://medium.com/javascript-in-plain-english/quick-overview-of-http-requests-cross-origin-resource-sharing-cors-db139b41d71)
> * 原文作者：[Bilge Demirkaya](https://medium.com/@bilgedemirkaya)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/quick-overview-of-http-requests-cross-origin-resource-sharing-cors.md](https://github.com/xitu/gold-miner/blob/master/article/2021/quick-overview-of-http-requests-cross-origin-resource-sharing-cors.md)
> * 译者：
> * 校对者：

# An Overview of HTTP Requests & Cross-Origin Resource Sharing (CORS)

![Photo by [Alina Grubnyak](https://unsplash.com/@alinnnaaaa?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) on [Unsplash](https://unsplash.com/s/photos/network?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)](https://cdn-images-1.medium.com/max/6912/1*YECeOxlko9KoOJNw8RNm3A.jpeg)

First of all, let's start with how a URL looks like.

A sample URL consists of 4 parts.

![](https://cdn-images-1.medium.com/max/2000/1*HfJAWr4Jw7rIXHSRaG4wcw.png)

**SCHEME:** The scheme identifies the protocol will be used. **Protocol** specifies how the data is transferred and how to interpret the request. When you look at the protocol, you will have a good understanding of what this URL is used for. ( Like is it an email protocol with the SMTP, POP3, IMAP, or is it SSH request to reach and manage git repositories or is it an HTTP request for web)

**HTTP** — Runs on port 80 by default, it specifies what headers are in the request.

**HTTPS** — Same as **HTTP** protocol but HTTPS is considered as secure communication between the browser and the server. It differs fro HTTP with;

* Runs on port 443 by default
* Encrypts all of your request/response headers except request IP

**Host name:**

Just an IP address with better naming.

**Path:**

URL Path is just like your directory path. It provides users & search engines to understand which section they are currently on, such as ‘/about’ section. Indeed this part is important to optimize better SEO.

**Query parameters:**

It is used for sending data to the server. This is usually used for marketing reasons to see how advertising is doing. Starts with `?` separates data with `&`

> **Note**: It is not recommended to send data with query params because of security reasons ( then everyone can see it) and also it has a character limit. ( not allowed after 2048 chars).

**With HTTP and HTTPS protocol, there are other ways that we can send data to the server.**

#### Request and Response

![Taken from C0D3.com](https://cdn-images-1.medium.com/max/2000/1*8S-OTIgudIC9wOIbN3VETg.png)

When user types a domain name in the browser, browser go finds that server ( which is only someone else’s computer ) and sends a request to that server. If it gets a successful response from the server, renders the page on the browser.

> **Note**: When you send a request using a terminal ( when you run `node index.js` for example ) the process is the same. To send a request to a server, you don’t necessarily need a browser, you can do it with your terminal as well. However, if the response is HTML, terminal won’t do anything since HTML is instructions for browsers only.

#### Headers

Both browser and server need to know a bunch of information about each other to recognize each other and eventually to send requests or responses. Such as IP addresses, Content-Type, Cookie, [Cache-Control](https://en.wikipedia.org/wiki/Cache-Control) and many more. You can find [full list here](https://en.wikipedia.org/wiki/List_of_HTTP_header_fields). And they carry these data with **headers** which is just ****key-value pairs.

![Request Headers Example | Taken from C0D3.com](https://cdn-images-1.medium.com/max/2000/1*kJ2ViLP32reDBOfeYHB46Q.png)

There are only two headers you would set manually when sending a request: **Content-Type** and **Authorization**. Although you can set the other headers, they are usually handled by the browser automatically.

**Content-Type —** When ****you are sending data to the server with body ( POST, PATCH, PUT requests), you need to specify it’s content type whether it is `application/json`, `text/html`,` image/gif`, or` video/mpeg.`

**Authorization** — This is used by the server to identify the user. Unlike cookie header, this header must be set manually by the developer when sending the request. Commonly used for API requests and JWT authentication.

#### Request

Every request sends over the internet consist of 2 mandatory 1 optional part.

1. **Request Line**; consist of request method (GET, POST, DELETE etc) and path ( extracted from the URL)
2. **Headers** which briefly explained above
3. **Body** (Optional): When you do a POST, PUT, PATCH requests to do server, you need to send a body which is telling the server what data you want to send. Example:

```js
axios.post(‘/users’, 
{id: “5fddfefc4fbd19494493cd71”, name: "username"} // this part is body
).then(console.log)
```

* **axios** is a library that sends requests. The browser also provides you a function called **fetch** that allows sending requests. There is also an outdated **request** library to send requests.
* **post** is the request method, means we are sending information to the server. Check HTTP request methods in detail [here](https://developer.mozilla.org/en-US/docs/Web/HTTP/Methods).
* **‘/users’** is the path specifies where exactly you are sending that request in the server. This URL part is actually called API. When an API follows the **REST** pattern, it becomes **REST API**, which allows developers to understand and use the API quickly. As REST pattern says, for instance, **path** should be always in the plural form.

> **REST** stands for Representational State Transfer and it is a set of design principles to let you use and modify resources on servers using APIs.

* **body** is the data object itself so server can get that data.

As you see, apart from typing a domain name in the browsers, there are ways you can send a request to the server.

> **AJAX**: Sending a request from the browser. If someone tells you they know ajax, it means that they know how to send requests from the browser.

## Options method & Cross-Origin Resource Sharing (CORS)

**OPTIONS** requests are called **pre-flight requests.**

Currently, you are seeing the response comes from **medium.com** server. Let’s say I wrote a JS code which is sending a POST request to my own website while you are browsing this. This is called **Cross-Domain request**.

> **Cross-Domain requests:** requests that are sent to a url with a different hostname than the url you are currently on.

With my JS code, I want the browser to send another request to another domain (another server). However, it is not that easy. For security reasons, browsers restrict cross-origin HTTP requests initiated from scripts.

Certain “**cross-domain**” requests, notably Ajax requests, are forbidden by default by the [same-origin security policy](https://en.wikipedia.org/wiki/Same-origin_policy) while “**Same-Origin**” requests are always allowed.

**CORS** defines ways of a browser and server can interact and determine whether it is safe to allow the cross-origin request.

> **Cross-Origin Resource Sharing** ([CORS](https://developer.mozilla.org/en-US/docs/Glossary/CORS)) is an HTTP-header based mechanism that allows a server to indicate any other [origin](https://developer.mozilla.org/en-US/docs/Glossary/origin)s (domain, scheme, or port) than its own from which a browser should permit loading of resources.

![Taken from [https://developer.mozilla.org/en-US/docs/Web/HTTP/CORS](https://developer.mozilla.org/en-US/docs/Web/HTTP/CORS)](https://cdn-images-1.medium.com/max/2000/1*J35DcnM_wbU9b4C5IZvkpQ.png)

#### So I’ve sent a cross-origin request. What happens now?

The browser notices that the domain is different so it sends an **OPTIONS** request to that server just to check if the request is allowed. This has nothing to do with the developer though, it goes automatically by the browser. But developer, before sending a cross-origin request, can add some headers to the request which may help to get allowed.

Just like other browser requests, some data within headers like [Access-Control-Request-Method](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Access-Control-Request-Method), [Access-Control-Request-Headers](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Access-Control-Request-Headers) headers sent with the OPTIONS method which is giving some info like when is the real request is coming, what is the data-type, what is the request method etc.

The server now can respond if it will accept a request under these circumstances. Rest of the story only depends on the server. In response, the server may send back a `[Access-Control-Allow-Origin](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Access-Control-Allow-Origin)` header with Access-Control-Allow-Origin: *, which means that the resource can be accessed by **any** domain.

While it allows GET requests from other domains, it may restrict POST requests.

#### Some important response headers for cross-domain requests

**Access-Control-Allow-Origin** — Contains the hostname that is allowed to send the cross-domain request. If this does not match the hostname of the site that the user is on, then the cross-domain is rejected.

**Access-Control-Allow-Credentials** — If this is true in the response header, then the cross-domain request will include a cookie header.

**Access-Control-Allow-Methods** — This is a comma-separated string that tells the browser what request methods are allowed in the cross-domain request. The request will not be sent if the request method is not included in this response header.

One of Node.js code to set headers;

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

#### Why server developers need to know this

The CORS standard means, server developers have to handle new request and response headers. They need to draw their lines with headers so they can prevent security bugs.

I tried to explain these important concepts very briefly, if you have any questions or want to know more in one particular topic covered above, please let me know.

Cheers!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
