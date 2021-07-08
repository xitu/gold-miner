> * 原文地址：[HTTP Strict Transport Security FAQs](https://levelup.gitconnected.com/http-strict-transport-security-faqs-844e00ac385c)
> * 原文作者：[David Klempfner](https://medium.com/@davidklempfner)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/http-strict-transport-security-faqs.md](https://github.com/xitu/gold-miner/blob/master/article/2021/http-strict-transport-security-faqs.md)
> * 译者：
> * 校对者：

# HTTP Strict Transport Security FAQs

![Photo by [Alessandro Sacchi](https://unsplash.com/@alle_sacchi) on [Unsplash](https://unsplash.com/photos/NUFnfYd09iI)](https://cdn-images-1.medium.com/max/2000/0*aQF5O9qqSppIwcdn)

Here are some questions I came up with while learning HSTS, and the corresponding answers.

## What is HSTS?

The Strict-Transport-Security header looks like this:

![](https://cdn-images-1.medium.com/max/2000/1*HJgfR4q-W27fCIb-SigmYw.png)

It is returned in the response from a website, to let the browser know that it should only attempt to access the website using HTTPS from now on.

After your browser receives the HSTS header, the next time you go to [http://facebook.com,](http://facebook.com,) your browser won’t actually make the request, it’ll do an “internal redirect” (HTTP 307) and request [https://facebook.com](https://facebook.com) instead.

![The browser knows to use HTTPS only, and redirects accordingly](https://cdn-images-1.medium.com/max/2000/1*T8VGnhGEkWqmVR6l0cQVdw.png)

This is the same effect as if you had typed [https://facebook.com](https://facebook.com) in your browser’s address bar.

## What’s the point of HSTS?

Imagine you’re at the airport, a hacker has set up a public Wi-Fi from their laptop and is hosting a fake version of [http://facebook.com](http://facebook.com). You go to [http://facebook.com](http://facebook.com) and the hacker gets your username/password.

Thanks to HSTS, if you have already visited [https://facebook.com,](https://facebook.com,) your browser would already have received the HSTS header, and knows to use the HTTPS version from then on.

But what if you haven’t already visited the HTTPS version?

## Preload

If a user visits [http://facebook.com](http://facebook.com) for the very first time on the hacker’s public Wi-Fi, the browser doesn’t know to redirect to HTTPS and the user’s account is compromised.

This is where [preload](https://hstspreload.org/) comes to the rescue. Google maintains a list of domains that are hardcoded into Chrome and other browsers. When you go to one of these domains for the first time using HTTP, the browser will redirect you to the HTTPS version, even though your browser hasn’t yet received the HSTS header.

This solves the security risk mentioned earlier with the public Wi-Fi.

## Preload requirements

There are [requirements](https://hstspreload.org/) for preload which you can read about. An example of a valid HSTS header for preload looks like this:

`Strict-Transport-Security:` max-age=63072000; includeSubDomains; preload

One interesting thing to note is that you can only register the domain name, ie. no subdomains.

## Why can’t I register subdomains?

The HSTS preload list is shipped in binary to billions of browser clients around the world, which places a high premium on controlling the size of this list.

In order to keep this list as small as possible, and to ensure that each entry on the list provides the broadest value to users, the policy for the HSTS preload list is to preload TLDs and registrable domains, commonly referred to as eTLD + 1 (where eTLDs are determined by the [public suffix list](https://publicsuffix.org/) and the +1 means that plus one additional label).

Preloading subdomains would still allow for other subdomains (or the registrable domain itself) to be preloaded in the future, which should instead be handled by preloading the registrable domain with `includeSubDomains` conferring HTTPS enforcement for domains beneath it.

## Error: HTTP redirects to www first

I found this error when checking the eligibility for my website:

```
Error: HTTP redirects to www first

http://website1.com (HTTP) should immediately redirect to https://website1.com (HTTPS) before adding the www subdomain.

Right now, the first redirect is to https://www.website1.com/.
The extra redirect is required to ensure that any browser which supports HSTS will record the HSTS entry for the top level domain, not just the subdomain.
```

Why can’t [http://website1.com](http://website1.com) just redirect to [https://website1.com](http://website1.com) using preload, regardless of the fact that it currently redirects to [https://www.website1.com](https://www.website1.com/)?

To answer this, think about what would happen if you had another subdomain, [http://sub.website1.com,](http://sub.website1.com,) that only ran using HTTP.

If Google let you preload [http://website1.com](http://website1.com/), then all subdomains would be internally redirected to the HTTPS version, which would cause [http://sub.website1.com](http://sub.website1.com,) to no longer work, since users would be redirected to [https://sub.website1.com](http://sub.website1.com,).

Google forces you to find these problems yourself first (before the semi-permanent preload feature is switched on for your site), by forcing you to have your users redirected to [https://website1.com](https://website1.com/), so that when the HSTS header is returned, the browser knows to use HTTPS for the top level, and all subdomains.

The idea is that you’ll find issues with HTTP subdomains, and fix them, before getting preload set up, which is [hard to remove once in place](https://bugs.chromium.org/p/chromium/issues/detail?id=527947).

## What happens if I return the HSTS header from an HTTP website?

Browsers will ignore the HSTS header if returned from a website using HTTP.

This is because the browser has no way of knowing if the website is real or not. You could be on a malicious public Wi-Fi like we described earlier.

The hacker could inject or remove the HSTS header, so there’s no point in the browser paying any attention to it.

If a website did not have HTTPS set up, and browsers didn’t ignore HSTS over HTTP, then the hacker could cause issues for the website’s users, by returning the HSTS header over HTTP. The next time the users went to the website on their home Wi-Fi, the browser would use HTTPS for a site designed only for HTTP, which would result in 404 Not Found.

## Summary

HSTS is a great security feature, however you really need to think about the implications of preload, and whether the risk of possibly having to remove it later, which is difficult, is worth the reward of that extra layer of security for such a niche situation.

Unless you run a high profile website, the chance that one of your users will access your website for the first time on a public Wi-Fi, AND that there would be a hacker running that Wi-Fi, is very slim.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
