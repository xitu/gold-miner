> * 原文地址：[DNS over TLS: Encrypting DNS end-to-end](https://code.fb.com/security/dns-over-tls/)
> * 原文作者：[https://code.fb.com](https://code.fb.com)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/dns-over-tls.md](https://github.com/xitu/gold-miner/blob/master/TODO1/dns-over-tls.md)
> * 译者：
> * 校对者：

# DNS over TLS: Encrypting DNS end-to-end

![](https://code.fb.com/wp-content/uploads/2018/12/DoT-Hero.jpg)

As a first step toward encrypting the last portion of internet traffic that has historically been cleartext, we have partnered with [Cloudflare DNS](https://www.cloudflare.com/dns/) on a pilot project. This pilot takes advantage of the benefits of Transport Layer Security ([TLS](https://code.fb.com/networking-traffic/deploying-tls-1-3-at-scale-with-fizz-a-performant-open-source-tls-library/)) — a widely adopted and proven mechanism for providing authentication and confidentiality between two parties over an insecure channel — in conjunction with DNS. This solution, DNS over TLS (DoT), would encrypt and authenticate the remaining portion of web traffic. With this DoT pilot, people browsing Facebook and using Cloudflare DNS enjoy a fully encrypted experience, not just when they connect to Facebook using HTTPS, but also at the DNS level, from their computers to Cloudflare DNS, and from Cloudflare DNS to Facebook name servers.

## History of DNS

Online security has changed considerably since the late 1980s, when the Domain Name System  (DNS) was first standardized to allow connection to entities by the means of simple mnemonic names, such as facebook.com. Many improvements have been made, and a large portion of web traffic is now connected via HTTPS. But there are still some issues inherent in sending cleartext on the wire.

In 2010, the DNS protocol was extended to support authentication when the [Domain Name System Security Extension](https://en.wikipedia.org/wiki/Domain_Name_System_Security_Extensions) (DNSSEC) was deployed. While DNSSEC enables authentication of the messages, the DNS requests and answers are still sent in the clear. This leaves them easily read by any party in the path between the requestor and the responder. In October 2014, the Internet Engineering Task Force (IETF) created the [DPRIVE Working Group](https://datatracker.ietf.org/wg/dprive/about/) with a charter to provide confidentiality and authentication to the DNS.

The group standardized DoT with [RFC 7858](https://tools.ietf.org/html/rfc7858) in 2016. To that end, open resolvers such as Cloudflare’s 1.1.1.1 and Quad9’s 9.9.9.9 became privacy focused with DoT support. This protects one portion of the DNS communication — from the end-user device to their resolver. But the second part of the connection remains in cleartext. In May 2018, DPRIVE was rechartered to develop a solution for encrypting the part of the communication from the resolver to the name server.

![](https://code.fb.com/wp-content/uploads/2018/12/DoT21.png)

_DNS prior to DoT_

## Piloting DoT

Over the past few months, we have been running a pilot in which we enabled DoT between Cloudflare’s 1.1.1.1 recursive resolvers and our authoritative name servers. The goal is to understand the feasibility of doing this at scale, gather metrics to better understand the overhead incurred in terms of latency on receiving an answer, and determine computing overhead. This pilot will allow us to better understand how the protocol behaves in the wild. Additionally, running in a production workload will surface any issues or quirks that might arise from shifting the DNS from User Datagram Protocol (UDP) and its fire-and-forget approach to a connected and encrypted protocol like TLS — in a way that might not occur during protocol design.

![](https://code.fb.com/wp-content/uploads/2018/12/DoT3.jpg)

_DNS with DoT_

So far, the pilot has proved to be a working solution for the type of production traffic we see between Cloudflare DNS and Facebook name servers. An initial connection adds some latency to the initial request, but we are able to reuse the TLS connections to perform multiple requests. Thus the initial overhead is amortized to the point that the resulting p99 of DNS latency between Cloudflare DNS and Facebook authoritative name servers is on par with the UDP baseline.

The graphs below show the impact on latency when we switched from TLS to UDP (at 17:30). This allows us to compare the latency of requests between the two protocols. The first graph shows the latency percentiles without the cost of the TCP/TLS session establishments. It shows that once a connection is established, the latency between query and response remains the same, whether TLS or UDP is used.

![](https://code.fb.com/wp-content/uploads/2018/12/DoT41.png)

The second graph takes into account the overall latency of the requests by including connection setup time. Here we can see again that whether we use TLS or UDP has no impact on the overall latency; this is because we are using TLS session resumption and performing many requests over the same TLS connection, essentially amortizing the cost of the initial connection setup.

![](https://code.fb.com/wp-content/uploads/2018/12/DoT4.png)

As a point of reference, the graph below shows the difference in total latency when we were not yet using TLS session resumption and handling only a small number of requests over an established connection. The switch from TLS to UDP was done slightly before 22:35, so we can see that overall, the impact on the majority of requests was similar to that of UDP, but at p95 and above, request latency was affected. The accompanying graph on the other end shows that, when the connection was already established, the latency was not affected. This tells us that the difference in the first graph was due to establishing new connections, and, as a matter of fact, to doing it more often.

![](https://code.fb.com/wp-content/uploads/2018/12/DoT51.png)

![](https://code.fb.com/wp-content/uploads/2018/12/DoT61.png)

Essentially, people browsing Facebook and using Cloudflare DNS with DoT now enjoy a fully encrypted experience, not only when they connect to Facebook using HTTPS, but also at the DNS level. While we do implement TLS session resumption, the current setup has not yet taken full advantage of all the optimizations offered by modern protocol stacks. Moving forward, we could cut latency even further by leveraging the improvements brought by the latest version of TLS ([TLS 1.3](https://tools.ietf.org/html/rfc8446)) and by [TCP Fast Open](https://en.wikipedia.org/wiki/TCP_Fast_Open).

## Next steps for DoT

This pilot has allowed to us to prove that DoT can work on a production workload at scale without any negative impact on the user experience. The experience and knowledge gained will allow us to bring operational experience back to the DNS community.

Protocols developed by standards communities such as the [IETF](https://www.ietf.org/) sometimes lack input from the organizations that will eventually run them. This creates a disconnect between the designers, implementers, and operators. With this pilot, we are well positioned to report early, concrete results to the working group based on our experience running the protocol in production, which helps inform best practices for operators and software vendors interested in deploying DoT.

We hope these initial results will motivate other industry partners to join us in this pilot and to expand the pool of operators and experience gained during the making of this protocol, thereby increasing the level of feedback, operational expertise, and best practices.

_We would like to thank Cloudflare’s Marek Vavruša for his work on this pilot project._

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
