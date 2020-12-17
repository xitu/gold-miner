> * 原文地址：[Fundamentals of Caching Web Applications](https://blog.bitsrc.io/fundamentals-of-caching-web-applications-a215c4333cbb)
> * 原文作者：[Mahdhi Rezvi](https://medium.com/@mahdhirezvi)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/fundamentals-of-caching-web-applications.md](https://github.com/xitu/gold-miner/blob/master/article/2020/fundamentals-of-caching-web-applications.md)
> * 译者：
> * 校对者：

# Fundamentals of Caching Web Applications

![Photo by [Yuiizaa September](https://unsplash.com/@yuiizaa?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/9458/0*0OwYJoWVEwP_rPjk)

Web applications have come a long way from the early days. A typical web application development goes through several stages of design, development, and testing before it is ready for release. As soon as your web app gets released, it will be accessed by real-life users on a daily basis. If your web app becomes popular, it will be accessed by at least several million users on a daily basis. Although this sounds exciting, this would incur a lot of running costs.

Apart from cost, complex calculations and R/W operations can take time for completion. This means that your user should wait for the completion of the operation which can be a bad user experience if the wait becomes too long.

System designers use several strategies to rectify these issues. **Caching** is one of them. Let’s have a better look at caching.

## What is Caching in Web Applications?

A web cache is simply a component that is capable of storing HTTP responses temporarily which can be used for subsequent HTTP requests as long as certain conditions are met.

Web caching is a key design feature of the HTTP protocol intended to reduce network traffic while enhancing the presumed responsiveness of the system as a whole. Caches are found at every stage of the content journey from the original server to the browser.

In simple terms, web caching enables you to reuse HTTP responses that have been stored in the cache, with HTTP requests of similar nature. Let’s think of a simple example where a user requests a certain type of product(books) from the server. Assume that this whole process takes around 670 milliseconds to complete. If the user, later in the day, does this same query, rather than doing the same computation again and spending 670 milliseconds, the HTTP response stored in the cache can be returned to the user. This will reduce the response time drastically. In real-life scenarios, this can come under 50 milliseconds.

## Advantages of Caching

There are several advantages of caching from the perspective of the consumer and provider.

#### Decreased Bandwith Costs

As mentioned before, content can be cached at various points in the path of the HTTP request from the consumer to the server. When the content is cached closer to the user, it would result in the request traveling a lesser distance that would lead to a reduction of bandwidth costs.

#### Improved Responsiveness

Since the caches are maintained closer to the user, this removes the need for a full round trip to the server. The closer the cache, the more instantaneous the response would be. This would directly have a positive impact on user experience.

#### Increased Performance on the Same Hardware

Due to the similar requests being catered by the cache, your server hardware can focus on requests which need the processing power. Aggressive caching can further increase this performance enhancement.

#### Content Availability Even During Network Failures

When certain cache policies are used, content can be served to end users from the cache for a short period of time, in the event of a server failure. This can be very helpful as it allows consumers to perform basic tasks without the failure of the origin server affecting them.

## Disadvantages of Caching

Similar to the advantages, there are several disadvantages to caching as well.

#### The Cache is Deleted During Server Restart

Whenever your server is restarted, your cache data gets deleted as well. This is because cache is volatile and is lost when power is lost. But you can maintain policies where you write the cache to your disk at regular intervals to persist the cached data even during server restart.

#### Serving Stale Data

One of the main issues of caching is serving stale data. Stale data is data that is not updated and contains a previous version of the data. If you’ve cached a query of products, but in the meantime, the product manager has deleted four products, the users will get listings to products that don’t exist. This can be complicated to identify and fix.

## Where Can You Cache?

As previously mentioned, content can be cached at various locations in the path of the request.

#### Browser Cache

Web browsers retain a small cache of their own. Usually, the browser sets the policy that determines the most important items to cache. This could be user-specific content or content that is perceived to be costly to download and likely to be recovered. To disable the caching of a resource, you can set the response header as below.

```
Cache-Control: no-store
```

#### Intermediary Caching Proxies

Any server that lies between the consumer device and your server infrastructure can cache content as desired. These caches may be maintained by ISPs or other independent parties.

#### Reverse Cache

You can implement your own cache infrastructure in your backend services. In this approach, content can be served from the point of external contact, without proceeding through to your backend servers. You can use services like Redis, Memcache to achieve this.

Read more about the `Cache-Control` header over [here](https://developer.mozilla.org/en-US/docs/Web/HTTP/Caching#Controlling%20caching).

![Source: [MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Caching)](https://cdn-images-1.medium.com/max/2000/0*QaYpasQXpfIKwiTV.png)

## What Can Be Cached?

All types of content are cacheable. Just because they are cacheable, does not mean that they should be cached.

#### Cache Friendly

The below content are more cache-friendly as they do not change frequently and therefore can be cached for longer periods.

* Media Content
* JavaScript libraries
* Style sheets
* Images, Logos, Icons

#### Moderately Cache Friendly

The below content can be cached, but extra caution should be taken as these type of content can change regularly.

* Frequently modified JS and CSS
* HTML pages
* Content request with authentication cookies

#### Never Cache

The below type of content should never be cached as they can lead to security concerns.

* Highly sensitive content such as banking information, etc.
* User-specific should most often not be cached as it is regularly updated.

## Why Do You Need a Caching Strategy?

In a real-world situation, you cannot implement aggressive caching as it would probably return stale data most of the time. This is why a custom made caching policy should be in place to balance between implementing long-term caching and responding to the demands of a changing site by implementing suitable cache eviction algorithms. Since each system is unique and has its own set of requirements, adequate time should be spent on creating cache policies.

The key to a perfect caching policy is to tread a fine line that promotes aggressive caching whenever possible while leaving openings to invalidate entries in the future when changes are made.

---

The intention of this article is to provide you with an introduction to the fundamentals of caching in web applications. I have skipped several topics such as control headers, caching infrastructures, guidelines for developing cache policies, etc as they are a tad too advanced for this introduction.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
