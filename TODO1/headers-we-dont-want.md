> * 原文地址：[The headers we don't want](https://www.fastly.com/blog/headers-we-dont-want)
> * 原文作者：[Andrew Betts](https://www.fastly.com/blog/andrew-betts)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/headers-we-dont-want.md](https://github.com/xitu/gold-miner/blob/master/TODO1/headers-we-dont-want.md)
> * 译者：
> * 校对者：

# The headers we don't want

If you want to learn more about headers, don’t miss Andrew’s talk at [Altitude London](https://www.fastly.com/altitude/2018/london) on May 22.

HTTP headers are an important way of controlling how caches and browsers process your web content. But many are used incorrectly or pointlessly, which adds overhead at a critical time in the loading of your page, and may not work as you intended. In this first of a series of posts about header best practice, we’ll look at unnecessary headers.

Most developers know about and depend on a variety of HTTP headers to make their content work. Those that are best known include `Content-Type` and `Content-Length`, which are both almost universal. But more recently, headers such as `Content-Security-Policy` and `Strict-Transport-Security` have started to improve security, and `Link rel=preload` headers to improve performance. Few sites use these, despite their wide support across browsers.

At the same time, there are lots of headers that are hugely popular but aren’t new and aren’t actually all that useful. We can prove this using [HTTP Archive](http://httparchive.org/), a project run by Google and sponsored by Fastly that loads 500,000 websites every month using [WebPageTest](https://www.webpagetest.org/), and makes the results available in [BigQuery](https://cloud.google.com/bigquery/).

From the HTTP Archive data, here are the 30 most popular response headers (based on the number of domains in the archive which are serving each header), and roughly how useful each one is:

| Header name | Requests | Domains | Status |
| --- | --- | --- | --- |
| date | 48779277 | 535621 | Required by protocol |
| content-type | 47185627 | 533636 | Usually required by browser |
| **server** | **43057807** | **519663** | **Unnecessary** |
| content-length | 42388435 | 519118 | Useful |
| last-modified | 34424562 | 480294 | Useful |
| cache-control | 36490878 | 412943 | Useful |
| etag | 23620444 | 412370 | Useful |
| content-encoding | 16194121 | 409159 | Required for compressed content |
| **expires** | **29869228** | **360311** | **Unnecessary** |
| **x-powered-by** | **4883204** | **211409** | **Unnecessary** |
| **pragma** | **7641647** | **188784** | **Unnecessary** |
| **x-frame-options** | **3670032** | **105846** | **Unnecessary** |
| access-control-allow-origin | 11335681 | 103596 | Useful |
| x-content-type-options | 11071560 | 94590 | Useful |
| link | 1212329 | 87475 | Useful |
| age | 7401415 | 59242 | Useful |
| **x-cache** | **5275343** | **56889** | **Unnecessary** |
| x-xss-protection | 9773906 | 51810 | Useful |
| strict-transport-security | 4259121 | 51283 | Useful |
| **via** | **4020117** | **47102** | **Unnecessary** |
| **p3p** | **8282840** | **44308** | **Unnecessary** |
| expect-ct | 2685280 | 40465 | Useful |
| content-language | 334081 | 37927 | Debatable |
| **x-aspnet-version** | **676128** | **33473** | **Unnecessary** |
| access-control-allow-credentials | 2804382 | 30346 | Useful |
| x-robots-tag | 179177 | 24911 | Not relevant to browsers |
| x-ua-compatible | 489056 | 24811 | Useful |
| access-control-allow-methods | 1626129 | 20791 | Useful |
| access-control-allow-headers | 1205735 | 19120 | Useful |

Let’s look at the unnecessary headers and see why we don’t need them, and what we can do about it.

## Vanity (server, x-powered-by, via)

You may be very proud of your choice of server software, but most people couldn’t care less. At worst, these headers might be divulging sensitive data that makes your site easier to attack.

```
Server: apache
X-Powered-By: PHP/5.1.1
Via: 1.1 varnish, 1.1 squid
```

[RFC7231](https://httpwg.org/specs/rfc7231.html#header.server) allows for servers to include a `Server` header in the response, identifying the software used to serve the content. This is most commonly a string like “apache” or “nginx”. While it’s allowed, it’s not mandatory, and offers very little value to either developers or end users. Nevertheless, this is the third most popular HTTP response header on the web today.

`X-Powered-By` is the most popular header in our list that is not defined in any standard, and has a similar purpose, though normally refers to the application platform that sits behind the web server. Common values include “ASP.net”, “PHP” and “Express”. Again this isn’t providing any tangible benefit and is taking up space.

More debatable perhaps is `Via`, which is required ([by RFC7230](https://httpwg.org/specs/rfc7230.html#header.via)) to be added to the response by any proxy through which it passes to identify the proxy. This can be something useful like the proxy’s hostname, but is more likely to be a generic identifier like “vegur”, “varnish”, or “squid”. Removing (or not setting) this header is technically a spec violation, but no browsers do anything with it, so it’s reasonably safe to get rid of it if you want to.

## Deprecated standards (P3P, Expires, X-Frame-Options)

Another category of headers is those that do have an effect in the browser but are not (or are no longer) the best way of achieving that effect.

```
P3P: cp="this is not a p3p policy"
Expires: Thu, 01 Dec 1994 16:00:00 GMT
X-Frame-Options: SAMEORIGIN
```

`P3P` is a curious animal. I had no idea what this was, and even more curiously, one of the most common values is “this is not a p3p policy”. Well, is it, or isn’t it?

The story here goes back to an [attempt to standardise a machine readable privacy policy](https://en.wikipedia.org/wiki/P3P#User_agent_support). There was disagreement on how to surface the data in browsers, and only one browser ever implemented the header - Internet Explorer. Even in IE though, `P3P` didn’t trigger any visual effect to the user; it just needs to be present to permit access to third party cookies in iframes. Some sites even set a non-conforming P3P policy like the one above – even though doing so is on [shaky legal ground](https://www.cylab.cmu.edu/_files/pdfs/tech_reports/CMUCyLab10014.pdf).

Needless to say, reading third party cookies is generally a bad idea, so if you don’t do it, then you won’t need to set a `P3P` header!

`Expires` is almost unbelievably popular, considering that `Cache-Control` has been preferred over `Expires` for 20 years. Where a `Cache-Control` header includes a `max-age` directive, any `Expires` header on the same response will be ignored. But there are a massive number of sites setting both, and the `Expires` header is most commonly set to `Thu, 01 Dec 1994 16:00:00` GMT, because you want your content to not be cached and copy-pasting the example date [from the spec](https://www.ietf.org/rfc/rfc2616.txt) is certainly one way of doing that.

![Screen Shot 2018-05-10 at 21.49.25](//www.fastly.com/cimages/6pk8mg3yh2ee/63zsHXNxp6YmWacesKYgwy/e3f1040e2d948b0655667aaa86d5310f/Screen_Shot_2018-05-10_at_21.49.25.png)

But there is simply no reason to do this. If you have an `Expires` header with a date in the past, replace it with:

```
Cache-Control: no-cache, private
```

Some of the tools that audit your site will tell you to add an `X-Frame-Options` header with a value of ‘SAMEORIGIN’. This tells browsers that you are refusing to be framed by another site, and is generally a good defense against [clickjacking](https://en.wikipedia.org/wiki/Clickjacking). However, the same effect can be achieved, with more consistent support and more robust definition of behaviour, by doing:

```
Content-Security-Policy: frame-ancestors 'self'
```

This has the additional benefit of being part of a header (CSP) which you should have anyway for other reasons (more on that later). So you can probably do without `X-Frame-Options` these days.

## Debug data (X-ASPNet-Version, X-Cache)

It’s kind of astonishing that some of the most popular headers in common use are not in any standard. Essentially this means that somehow, thousands of websites seem to have spontaneously agreed to use a particular header in a particular way.

```
X-Cache: HIT
X-Request-ID: 45a336c7-1bd5-4a06-9647-c5aab6d5facf
X-ASPNet-Version: 3.2.32
X-AMZN-RequestID: 0d6e39e2-4ecb-11e8-9c2d-fa7ae01bbebc
```

In reality, these ‘unknown’ headers are not separately and independently minted by website developers. They are typically artefacts of using particular server frameworks, software or specific vendors’ services (in this example set, the last header is a common AWS header).

`X-Cache`, in particular, is actually added by Fastly (other CDNs also do this), along with other Fastly-related headers like `X-Cache-Hits` and `X-Served-By`. When debugging is enabled, we add even more, such as `Fastly-Debug-Path` and `Fastly-Debug-TTL`.

These headers are not recognised by any browser, and removing them makes no difference to how your pages are rendered. However, since these headers might provide you, the developer, with useful information, you might like to keep a way to turning them on.

## Misunderstandings (Pragma)

I didn’t expect to be in 2018 writing a post about the `Pragma` header, but according to our HTTP Archive data it’s still the 11th most popular. Not only was Pragma deprecated as long ago as 1997, but it was never intended to be a response header anyway - as specified, it only has meaning as part of a request.

```
Pragma: no-cache
```

Nevertheless it’s use as a response header is so widespread that some browsers recognise it in this context as well. Today the probability that your response will transit a cache that understands `Pragma` in a response context, and doesn’t understand `Cache-Control`, is vanishingly small. If you want to make sure that something isn’t cached, `Cache-Control: no-cache, private` is all you need.

## Non-Browser (X-Robots-Tag)

One header in our top 30 is a non-browser header. `X-Robots-Tag` is intended to be consumed by a crawler, such as Google or Bing’s bots. Since it has no meaning to a browser, you could choose to only set it when the requesting user-agent is a crawler. Equally, you might decide that this makes testing harder, or perhaps that it violates the terms of service of the search engine.

## Bugs

Finally, it’s worth finishing on an honourable mention for simple bugs. In a _request_, a `Host` header makes sense, but seeing it on a response probably means your server is misconfigured somehow (I’d love to know how, exactly). Nevertheless, 68 domains in HTTP archive are returning a `Host` header in their responses.

## Removing headers at the edge

Fortunately, if your site is behind Fastly, removing headers is pretty easy using [VCL](https://docs.fastly.com/guides/vcl/). It makes sense that you might want to keep the genuinely useful debug data available to your dev team, but hide it for public users, so that’s easily done by detecting a cookie or inbound HTTP header:

```
unset resp.http.Server;
unset resp.http.X-Powered-By;
unset resp.http.X-Generator;

if (!req.http.Cookie:debug && !req.http.Debug) {
  unset resp.http.X-Amzn-RequestID;
  unset resp.http.X-Cache;
}
```

In the next post in this series, I’ll be talking about best practices for headers that you should be setting, and how to enable them at the edge.


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
