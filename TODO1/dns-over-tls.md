> * 原文地址：[DNS over TLS: Encrypting DNS end-to-end](https://code.fb.com/security/dns-over-tls/)
> * 原文作者：[https://code.fb.com](https://code.fb.com)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/dns-over-tls.md](https://github.com/xitu/gold-miner/blob/master/TODO1/dns-over-tls.md)
> * 译者：[lsvih](https://github.com/lsvih)
> * 校对者：[Qiuk17](https://github.com/Qiuk17)

# DNS over TLS：端到端加密的 DNS

![](https://code.fb.com/wp-content/uploads/2018/12/DoT-Hero.jpg)

为了加密互联网流量中未被加密的最后一部分，我们与 [Cloudflare DNS](https://www.cloudflare.com/dns/) 合作进行了一个试点项目。这个试点项目利用安全传输层协议（即 [TLS](https://code.fb.com/networking-traffic/deploying-tls-1-3-at-scale-with-fizz-a-performant-open-source-tls-library/)，一种被广泛应用的、经过时间证明的机制，可用于双方在不安全信道上建立通讯时，为通讯提供身份认证及加密）与 DNS 进行结合。这个 DNS over TLS（DoT）方案能够加密并验证 Web 流量的最后一部分。在 DoT 测试中，人们可以在浏览 Facebook 时使用 Cloudflare DNS 享受完全加密的体验：不仅是在连接 Facebook 时用的 HTTPS 时进行了加密，而且在 DNS 级别，从用户计算机到 Cloudflare DNS、从 Cloudflare DNS 到 Facebook 域名服务器（NAMESERVER）中全程都采用了加密技术。

## DNS 的历史

二十世纪八十年代末，域名系统（DNS）被提出，可以让人们用简短易记的名称来连接实体（比如 facebook.com），这使得网络安全发生了极大的变化。人们为网络安全做了许多的改进，比如现在大部分的网络流量都是通过 HTTPS 连接，但在线上传输明文时仍然存在一些问题。

2010 年，[DNS 安全拓展](https://en.wikipedia.org/wiki/Domain_Name_System_Security_Extensions)（DNSSEC）部署实施，DNS 协议由此支持身份验证功能。虽然 DNSSEC 支持对消息进行身份验证，但仍然会使用明文来传输 DNS 请求与应答。这也使得传输的内容可以被请求方与响应方中间路径上任意节点轻松获取。2014 年 10 月，国际互联网工程任务组（IETF）建立了 [DPRIVE 工作组](https://datatracker.ietf.org/wg/dprive/about/)，其章程包括为 DNS 提供保密性与身份验证功能。

此工作组在于 2016 年提出 [RFC 7858](https://tools.ietf.org/html/rfc7858) 指定了 DoT 标准。为此，Cloudflare 的 1.1.1.1 与 Quad9 的 9.9.9.9 等开放的解析器在 DoT 的支持下更加关注使用者的隐私。这也保护了终端用户设备到 DNS 解析器这一部分 DNS 通信。但连接的其它部分仍然是明文传输。在 2018 年 5 月，DPRIVE 重新开发了一个方法，用于加密从解析器到域名服务器间的通信。

![](https://code.fb.com/wp-content/uploads/2018/12/DoT21.png)

**DoT 以前的 DNS**

## DoT 试验

我们在过去的几个月中一直在进行一项试验，在 Cloudflare 1.1.1.1 递归解析器与我们的主域名服务器间开启 DoT。这个试验的目的是了解大规模使用 DoT 的可行性，收集信息以更好地了解 DoT 在接受应答时的延迟产生的开销，并确定计算开销。这个试验让我们更好地了解了 DoT 协议在真实环境下的表现。另外在生产环境负载中试验把 DNS 从 UDP 等即发即弃方法换成 TLS 之类的加密连接协议，可以将一些设计协议时发现不了的问题给暴露出来。

![](https://code.fb.com/wp-content/uploads/2018/12/DoT3.jpg)

**DoT 下的 DNS**

截至目前，通过观察 Cloudflare DNS 与 Facebook 域名服务器间的生产环境流量，已经可以证明该试验是可行的解决方案。在初始化一个新连接的时候由于需要初始化请求，因此增加了延时；但我们可以重用 TLS 连接来处理其它更多的请求。因此，初始化增加的负载在均摊之后，降低到了 Cloudflare DNS 与 Facebook 主域名服务器 UDP 基线的 p99 相同的程度。

下图展示了我们从 TLS 切换回 UDP 时（在 17:30 时刻）延时的变化。它可以让我们比较两个协议请求的延时。第一个图显示了在没有 TCP/TLS 会话建立开销情况下的延时百分比。它展示了当连接建立后，TLS 与 UDP 在查询和响应间的延时是相同的。

![](https://code.fb.com/wp-content/uploads/2018/12/DoT41.png)

第二张图加上了建立连接的时间来考虑请求的总体延迟。从图中可以看到，使用 TLS 还是 UDP 对连接的总体延时也没有影响。这是因为我们使用 TLS 的会话恢复技术，通过相同的 TLS 连接来执行多个请求，实质上分摊了初始化连接的开销。

![](https://code.fb.com/wp-content/uploads/2018/12/DoT4.png)

作为参考，下图展示了在不使用 TLS 会话恢复技术，并在建立连接后仅处理少量请求时总延时的差异。在比 22:35 稍早的时刻完成了 TLS 到 UDP 的切换，可以看到总体而言 TLS 对大多数的请求的影响与 UDP 类似，但在 p95 或更高的统计指标下，请求的延时收到了影响。后面一张图显示，当链接已经建立时，延时不受影响。这两张图表明，第一张图中的差异是由于建立新连接时产生的，并且实际上，建立新连接的频率很高。

![](https://code.fb.com/wp-content/uploads/2018/12/DoT51.png)

![](https://code.fb.com/wp-content/uploads/2018/12/DoT61.png)

基本来说，浏览 Facebook 和使用带 DoT 的 Cloudflare DNS 的用户，无论是在用 HTTPS 连接时还是在 DNS 层面上，都可以享受完全加密的体验。虽然我们已经实现了 TLS 会话恢复技术，但还没有充分利用现代协议栈提供的全部优化方法。在将来，我们可以利用 TLS 的最新版本（[TLS 1.3](https://tools.ietf.org/html/rfc8446)）和 [TCP Fast Open](https://en.wikipedia.org/wiki/TCP_Fast_Open) 等技术带来的改进，进一步降低延时。

## DoT 的下一步

这个试验已经证明了，我们可以使用 DoT 大规模处理生产环境的负荷，并且不会对用户体验产生任何负面影响。我们将这个试验所得到的经验和知识，作为一种可行的经验回馈给 DNS 社区。

[IETF](https://www.ietf.org/) 等标准社区开发协议时，有时候会缺乏与最终实施与运行协议的组织的意见，这导致了协议设计者、实施者、运营者间的脱节。通过这个试验，我们可以根据在生产环境中运行协议得到的经验，及时向工作组报告具体结果，同时也为有意于部署 DoT 的运营商和软件供应商提供了最佳实践。

我们希望这些初步的试验结果可以激励其它的行业合作伙伴加入我们的试验，扩大 DoT 运营商的数量，并得到更多制定此协议时得到的经验，从而提高反馈水准、得到更多的运营知识和最佳实践。

**感谢 Cloudflare 的 Marek Vavruša 在这个试验中做出的贡献。**

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
