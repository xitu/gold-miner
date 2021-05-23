> * 原文地址：[What is HTTP/3, and Why Does it Matter?](https://javascript.plainenglish.io/what-is-http-3-and-why-does-it-matter-cb7d7b4b600f)
> * 原文作者：[AsyncBanana](https://medium.com/@asyncbanana)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/what-is-http-3-and-why-does-it-matter.md](https://github.com/xitu/gold-miner/blob/master/article/2021/what-is-http-3-and-why-does-it-matter.md)
> * 译者：
> * 校对者：

# What is HTTP/3, and Why Does it Matter?

#### HTTP/3, or HTTP over QUIC, brings many new performance features to HTTP

![Photo by [JJ Ying](https://unsplash.com/@jjying?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/8064/0*oudyG8yVAEkJ7vm5)

When researching the internet and the technologies behind it, you might have come across this term: HTTP. HTTP, or Hypertext Transfer Protocol, is the backbone of the web and is the universal protocol for transferring text data. You have no doubt used it, as the website you learned about HTTP on uses HTTP.

## Intro

#### A Short History on HTTP

The first version of HTTP released was HTTP/0.9. Tim Berners-Lee created it in 1989, and it was named HTTP/0.9 in 1991. HTTP/0.9 was limited and could only do basic things. It could not return anything other than a webpage and did not support cookies and other modern features. In 1996, HTTP/1.0 was released, bringing new features like POST requests and the ability to send something other than a webpage. However, it was still a long way from what it is today. HTTP/1.1 was released in 1997 and was revised twice, once in 1999 and once in 2007. It brought many major new features like cookies and connections that persisted. Finally, in 2015, HTTP/2 was released and allowed for increased performance, making things like Server Sent Events and the ability to send multiple requests at a time. HTTP/2 is still new and is only used by [slightly less than half of all websites](https://w3techs.com/technologies/details/ce-http2).

#### HTTP/3: The newest version of HTTP

HTTP/3, or HTTP over QUIC, changes HTTP a lot. HTTP is traditionally done over TCP, Transmission Control Protocol. However, TCP was developed in 1974, at the beginning of the internet. When TCP was initially created, the authors of it were unable to predict the web’s growth. Because of how TCP is outdated, TCP limited HTTP for a while with both speed and security. Now, because of HTTP/3, HTTP is not limited anymore. Instead of TCP, HTTP/3 uses a new protocol, developed in 2012 by Google, called QUIC (pronounced “quick”). This introduces many new features to HTTP.

## Features

#### Faster request multiplexing

![Photo by [PAUL SMITH](https://unsplash.com/@sumo?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/12000/0*Oz9x1jnI9c2V5qmd)

Before HTTP/2, browsers could only send one request to the server at a time. This made website loading significantly slower because the browser only loaded one asset, like CSS or JavaScript, at a time. HTTP/2 introduced the ability to load more than one asset at a time, but TCP was not made for this. If one of the requests failed, TCP would make the browser redo all the requests. Because TCP was removed in HTTP/3 and replaced by QUIC, HTTP/3 solved this problem. With HTTP/3, the browser only needs to redo the failed request. Because of this, HTTP/3 is faster and more reliable.

#### Faster Encryption

![Photo by [Franck](https://unsplash.com/@franckinjapan?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/8064/0*YCjpKNI1WGsHrXla)

HTTP/3 optimizes the “handshake” that allows browsers HTTP requests to be encrypted. QUIC combines the initial connection with a TLS handshake, making it secure by default and faster.

## Implementation

#### Standardization

At the time of this writing, HTTP/3 and QUIC are not standardized. There is an IETF [Working Group](https://quicwg.org/) that is currently working on a draft to standardize QUIC. The version of QUIC for HTTP/3 is slightly modified, using TLS instead of Google’s encryption, but it has the same advantages.

#### Browser Support

Currently, Chrome supports HTTP/3 by default due to Google creating the QUIC protocol and the proposal for HTTP over QUIC. Firefox also supports the protocol in versions 88+ without a flag. Safari 14 supports HTTP/3, but only if an experimental feature flag is enabled.

![Browser support for HTTP/3 (Source: [Can I Use](https://caniuse.com/http3))](https://cdn-images-1.medium.com/max/2740/1*DwY-vtr6Qzj2TdbW4KaTAw.png)

#### Serverless/CDN Support

So far, only some servers support HTTP/3, but their share is growing. Cloudflare was one of the first companies other than Google to support HTTP/3, so their serverless functions and CDN are HTTP/3 compliant. Additionally, Google Cloud and Fastly are HTTP/3 compliant. Unfortunately, Microsoft Azure CDN and AWS CloudFront do not seem to support HTTP/3 currently. If you want to try out HTTP/3, [QUIC.Cloud](https://quic.cloud/) is an interesting (although experimental) way to set up a caching HTTP/3 CDN in front of your server. Cloudflare, Fastly, and Google Cloud also have good HTTP/3 support and are more production-ready.

## Conclusion

HTTP/3 is still a very experimental update to HTTP, and it will likely change. However, more than half of users support the current form of HTTP/3. If you are prepared to update your implementation, then it can be a welcome performance boost. I hope you enjoyed reading and learned something from this article.

## Resources

* [Usage Statistics of HTTP/2 for Websites, May 2021 (w3techs.com)](https://w3techs.com/technologies/details/ce-http2)
* [QUIC Working Group (quicwg.org)](https://quicwg.org/)
* [Can I use… Support tables for HTML5, CSS3, etc](https://caniuse.com/http3)
* [Homepage — QUIC.cloud](https://quic.cloud/)

**More content at[** plainenglish.io**](http://plainenglish.io)**

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
