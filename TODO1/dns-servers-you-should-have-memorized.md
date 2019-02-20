> * 原文地址：[DNS Servers That Offer Privacy and Filtering](https://danielmiessler.com/blog/dns-servers-you-should-have-memorized/)
> * 原文作者：[DANIEL MIESSLER](https://danielmiessler.com/blog/author/daniel/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/dns-servers-you-should-have-memorized.md](https://github.com/xitu/gold-miner/blob/master/TODO1/dns-servers-you-should-have-memorized.md)
> * 译者：
> * 校对者：

# DNS Servers That Offer Privacy and Filtering

The latest DNS server IPs are easier to remember and offer privacy and filtering functionality

![](https://danielmiessler.com/images/DNS.png)

If you’re a programmer, a systems administrator, or really any type of IT worker, you probably have your favorite go-to IP addresses for troubleshooting. And if you’re like me, you’ve probably been using the same ones for years.

Such IPs can be used for:

*   Testing `ping` connectivity
*   Checking DNS resolution using `dig` or `nslookup`
*   Updating a system’s permanent DNS settings

> Most DNS servers allow you to ping them.

I like using DNS servers for this because you can use them for both connectivity and name resolution testing, and for the longest time I used the Google DNS servers:

```
8.8.8.8  
8.8.4.4
```

…but they don’t have any filtering enabled, and in recent years I’ve become less thrilled about sending Google all my DNS queries.

> Cisco bought OpenDNS, which is where Umbrella came from.

## Alternatives to Google DNS

At some point I switched to using Cisco’s Umbrella servers because they do URL filtering for you. They maintain a list of dangerous URLs and block them automatically for you, which can help protect from malware.

```
208.67.222.222  
208.67.220.220
```

The OpenDNS servers are great, but I always have to look them up. Then, a few years ago, a new set of DNS servers came out that focused not only on speed and functionality, but also _memorability_.

One of the first easy-to-remember options with filtering that came out was IBM’s Quad 9—which as you might expect has an IP address of four nines:

```
9.9.9.9
```

I figured they were being overwhelmed at launch time, or their filtering wasn’t tweaked yet.

I tried to use Quad9 one for a bit when it first came out, but found it a bit slow. I imagine they have probably fixed that by now, but more on performance below.

## Enter CloudFlare

![, DNS Servers That Offer Privacy and Filtering](https://danielmiessler.com/images/Screen-Shot-2019-01-27-at-11.49.14-PM-300x300.png)

So with Google, Cisco, and IBM providing interesting options with various functionality, we then saw CloudFlare enter the arena.

But rather than provide filtering, they instead focused on privacy.

> Some other recursive DNS services may claim that their services are secure because they support DNSSEC. While this is a good security practice, users of these services are ironically not protected from the DNS companies themselves. Many of these companies collect data from their DNS customers to use for commercial purposes. Alternatively, 1.1.1.1 does not mine any user data. Logs are kept for 24 hours for debugging purposes, then they are purged.  
>   
> CloudFlare Website

And perhaps coolest of all for me was their memorability rating, which is basically flawless:

1.0.0.1 abbreviates to 1.1, so you can literally test by typing `ping 1.1`.

```
1.1.1.1  
1.0.0.1
```

How cool is that?

So with them they’re not filtering your URLs, but they are consciously avoiding logging or tracking you in any way, which is excellent.

## Norton ConnectSafe DNS

Norton also has a public DNS service, which has an interesting feature of multiple levels of URL content filtering.

### Block malicious and fraudulent sites

```
199.85.126.10  
199.85.127.10
```

### Block sexual content

```
199.85.126.20  
199.85.127.20
```

### Block mature content of many types

```
199.85.126.30  
199.85.127.30
```

## My recommendation

Performance also matters here, and that will vary based on where you are, but in recent testing I found all of these options to be fairly responsive.

To me it comes down to this:

*   If you care about privacy and speed and maximum memorability, I recommend CloudFlare:

```
1.1.1.1  
1.0.0.1
```

I find the filtering claims by both companies to be too opaque for my tastes, with both of them feeling like borderline marketing to be honest.

*   If you want URL filtering I recommend Quad9 over Umbrella simply because it’s easier to remember and seems to focus on having multiple threat intelligence sources.

```
9.9.9.9
```

*   And if you want multiple levels of URL filtering, you can go with the Norton offering, but I think I personally prefer to just use Quad9 for that and be done with it. But I think Norton is still a cool option for like protecting an entire school or something by forcing their DNS through the strictest option.

## Summary

Final answer—if pressed—here are the two I recommend you remember.

1.  For speed and privacy: `1.1.1.1`
2.  For filtering: `9.9.9.9`

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
