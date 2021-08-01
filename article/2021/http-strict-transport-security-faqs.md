> * 原文地址：[HTTP Strict Transport Security FAQs](https://levelup.gitconnected.com/http-strict-transport-security-faqs-844e00ac385c)
> * 原文作者：[David Klempfner](https://medium.com/@davidklempfner)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/http-strict-transport-security-faqs.md](https://github.com/xitu/gold-miner/blob/master/article/2021/http-strict-transport-security-faqs.md)
> * 译者：[CarlosChenN](https://github.com/CarlosChenN)
> * 校对者：[PassionPenguin](https://github.com/PassionPenguin)，[Chorer](https://github.com/Chorer)，(zenblofe)[https://github.com/zenblofe]

# HTTP Strict Transport Security （HTTP严格传输安全协议）常见问题解答

![图片由 [Alessandro Sacchi](https://unsplash.com/@alle_sacchi) 上传至 [Unsplash](https://unsplash.com/photos/NUFnfYd09iI)](https://cdn-images-1.medium.com/max/2000/0*aQF5O9qqSppIwcdn)

本文是在我学习 HSTS 的时候，我提出的一些问题以及对应的回答。

## 什么是 HSTS？

严格传输安全的响应头头部字段看起来像这样子：

![](https://cdn-images-1.medium.com/max/2000/1*HJgfR4q-W27fCIb-SigmYw.png)

它是从网站的响应中返回的字段，它告诉浏览器，浏览器从现在开始只能使用 HTTPS 协议访问网站。

在你的浏览器接收 HSTS 报头之后，下一次你访问 [http://facebook.com](http://facebook.com)，你的浏览器不会真的发起这个请求，它会做一个”内部重定向“（ HTTP 307 ） 然后请求 [https://facebook.com](https://facebook.com) 来代替。

![The browser knows to use HTTPS only, and redirects accordingly](https://cdn-images-1.medium.com/max/2000/1*T8VGnhGEkWqmVR6l0cQVdw.png)

如果你在浏览器地址栏输入 [https://facebook.com](https://facebook.com)，也是同样的效果。 

## HSTS 的作用是什么呢？

想象一下你在机场，一个黑客在他们的笔记本电脑中设置好一个公共的 Wi-Fi，然后虚拟一个假版本的 [http://facebook.com](http://facebook.com)。你就会访问 [http://facebook.com](http://facebook.com) ，这时，黑客就知道你的用户名和密码了。

由于 HSTS，如果你已经访问过 [https://facebook.com](https://facebook.com)，那么你的浏览器就已经接受了 HSTS 报头，并从那时开始知道使用 HTTPS 协议。

但如果你还没有用 HTTPS 协议访问过呢？

## 预加载

如果一个用户第一次在黑客的公共 Wi-Fi 访问 [http://facebook.com](http://facebook.com)，浏览器不知道重定向到 HTTPS，用户的账号就会被泄露。

这就是预加载解决的问题。Google 维护了一个强编码进 Chrome 和其它浏览器中的域名列表。当你第一次用 HTTP 访问列表里面的其中一个域名，即使你的浏览器还未接收到 HSTS 报头，浏览器也会帮你重定向到 HTTPS 协议。

这解决了前面提到的公共 Wi-Fi 的安全风险。

## 预加载要求

有一些你可以了解的预加载的[要求](https://hstspreload.org/)。一个合法的预加载 HSTS 报头的例子是这样的：

```http request
`Strict-Transport-Security:` max-age=63072000; includeSubDomains; preload
```

一个有趣的需要注意的事情是，你只能注册域名。我的意思是，你不能注册子域名。

## 为什么我不能注册子域名?

HSTS 预加载列表是以二进制形式发送到全球数十亿客户的浏览器中，因此，需要高度重视限制 HSTS 预加载列表的大小。

为了保持列表尽可能地的小，保证列表上的每个条目为用户提供最广泛的价值，HSTS 预加载列表的策略是预加载 TLDs （top-level domains）和注册域名，通常被称为 eTLD + 1（eTLDs 是由[公共后缀列表](https://publicsuffix.org/) 确定的，+1 意味着附加额外的标签）。

预加载子域名仍然允许其他子域名（或注册域名本身）在未来被预加载，它应该通过预加载可注册域名，以及 `includeSubDomains` 授予 HTTPS 强制执行其下面的域名等进行处理。

## 错误：HTTP 先重定向到 www

我在检查我的网站的资质时，发现了这个错误：

```
错误：HTTP 先重定向到 www

http://website1.com (HTTP) 在添加 www 子域名之前，应该立即重定向到 https://website1.com (HTTPS)。

现在，第一次重定向是到 https://www.website1.com/。
额外的重定向需要确保任何支持 HSTS 的浏览器进入顶级域名，会记录 HSTS，不仅仅是子域名。
```

为什么 [http://website1.com](http://website1.com) 不能用预加载直接重定向到 [https://website1.com](http://website1.com)，无论事实如何，它现在重定向到 [https://www.website1.com](https://www.website1.com/) ？

回答这个之前，想一想如果你有另一个只用 HTTP 运行的子域名会发生什么 [http://sub.website1.com](http://sub.website1.com)。

如果 Google 让你预加载 [http://website1.com](http://website1.com/)，那么，所有子域将会内部重定向到 HTTPS 协议，这会导致 [http://sub.website1.com](http://sub.website1.com)，不能再访问，因为用户将会重定向到 [https://sub.website1.com](http://sub.website1.com)。

Google 先强制你找到这些问题（在开启半永久预加载功能你的网站之前），通过强制你让你的用户重定向到 [https://website1.com](https://website1.com/)。这样，当 HSTS 报头返回时，浏览器就知道要对顶级域名和所有子域名使用 HTTPS。

它的想法是你会找到 HTTP 子域名的问题，然后修复它们，在配置好预加载之前，因为它[一旦配置好就很难移除](https://bugs.chromium.org/p/chromium/issues/detail?id=527947)。

## 如果我从一个 HTTP 网站返回 HSTS 报头？

如果一个 HTTP 的网站返回 HSTS 报头，浏览器会忽略它。

这是因为浏览器无法知道这个网站是否真实。你可能会在我们之前描述的恶意公共 Wi-Fi 上。

黑客能注入或移除 HSTS 报头，所以浏览器没必要去注意它。

如果一个网站没有配置 HTTPS，浏览器也没有忽略 HTTP 上的 HSTS，那么，黑客就能通过 HTTP 上返回 HSTS 报头，给网站的用户制造问题。下一次用户在自己家里的 Wi-Fi 访问这个网站的时候，浏览器会用 HTTPS 访问一个专门设计为 HTTP 的网站，最终导致 404。

## 总结

HSTS 是一个很棒的安全特性，不过，你真的需要考虑预加载的含义，也需要考虑以后是否需要移除它的风险。移除你的域名是很困难的，你需要考虑为了特殊情况添加额外的安全层究竟值不值得。

除非你经营一个知名度很高的网站，不然，你的其中一个用户第一次用公共 Wi-Fi 去访问你网站，并且刚好这个 Wi-Fi 被一个黑客所运行的几率实在是太小了。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
