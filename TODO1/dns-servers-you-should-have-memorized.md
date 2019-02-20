> * 原文地址：[DNS Servers That Offer Privacy and Filtering](https://danielmiessler.com/blog/dns-servers-you-should-have-memorized/)
> * 原文作者：[DANIEL MIESSLER](https://danielmiessler.com/blog/author/daniel/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/dns-servers-you-should-have-memorized.md](https://github.com/xitu/gold-miner/blob/master/TODO1/dns-servers-you-should-have-memorized.md)
> * 译者：[ScDadaguo](https://github.com/ScDadaguo)
> * 校对者：

# 提供隐私和过滤功能的 DNS 服务器

最新的DNS服务器IP都是更易于记忆，并提供隐私和过滤功能的。

![](https://danielmiessler.com/images/DNS.png)

如果您是程序员，系统管理员, 或任何类型的IT工作人员, 您会有自己喜欢的首选IP地址来进行故障排除. 就像我一样，很可能使用一个相同的dns很多年。

这些 IP 可用于：

*   测试 `ping` 连接
*   使用 `dig` 或 `nslookup` 检查DNS解析
*   更新系统的永久DNS设置

> 大多数DNS服务器允许你ping它们。

我喜欢使用DNS服务器，因为您可以将它们用于连接和名称解析测试, 并且我使用时间最长 DNS 服务器是Google DNS的服务器，如下：

```
8.8.8.8  
8.8.4.4
```

…但他们没有启用任何过滤功能，因此近年来，我对发送Google所有DNS查询的兴趣降低了。

> Cisco 公司收购收购了 Umbrella 来自的 OpenDNS 公司。

## Google DNS的替代品

在某些时候，我转而使用 Cisco 的 Umbrella 服务器，因为它们会为您进行 URL 过滤。他们维护一个危险 URL 列表并自动阻止它们，这有助于防止恶意软件。

```
208.67.222.222  
208.67.220.220
```

OpenDNS 服务器很棒，但我总是要查找它们。然后，几年前，出现了一套新的 DNS 服务器，不仅关注速度和功能，还关注可 _记忆性_ 。

最先出现的易于记忆的 DNS服务器 是 IBM 的 Quad 9，正如您所期望的那样，它具有四个9的IP地址：

```
9.9.9.9
```

我认为他们在发布时就不堪重负了，或者他们的过滤功能还没有被调整好。

我第一次出现时尝试使用 Quad9，但发现它有点慢。 我想他们现在应该已经解决了这个问题，但更多关于以下的表现。

## Enter CloudFlare

![, DNS Servers That Offer Privacy and Filtering](https://danielmiessler.com/images/Screen-Shot-2019-01-27-at-11.49.14-PM-300x300.png)

因此，Google，Cisco 和 IBM 实施了各种功能的有趣的方案，然后我们看到 CloudFlare 进入该领域。

但他们不是提供过滤功能，而是专注于隐私。

> 其他一些递归 DNS 服务可能声称其服务是安全的，因为它们支持 DNSSEC。虽然这是一种很好的安全措施， 但具有讽刺意味的是，这些服务的用户并未受到 DNS 公司本身的保护。其中许多公司从其 DNS 客户收集数据用于商业目的。  另外，1.1.1.1 不会挖掘任何用户数据。日志保留24小时 以进行调试，然后才清除它们。
>   
> CloudFlare网站

也许对我来说最酷的是他们的可记忆性评级，这基本上是完美的：

1.0.0.1 缩写为 1.1，因此您可以通过键入 `ping 1.1` 进行字面测试。

```
1.1.1.1  
1.0.0.1
```

多么酷啊!

因此，使用它们，他们不会过滤您的网址，而且他们有意识地避免以任何方式记录或跟踪您，这非常好。

## Norton ConnectSafe DNS

Norton 还有一个公共DNS服务，它具有多级URL内容过滤的有趣功能。

### 阻止恶意和欺诈性网站

```
199.85.126.10  
199.85.127.10
```

### 阻止性内容

```
199.85.126.20  
199.85.127.20
```

### 阻止许多类型的成熟内容

```
199.85.126.30  
199.85.127.30
```

## 我的推荐

性能也很重要，并且会根据您所处的地理位置而有所不同，但在最近的测试中，我发现所有这些选项都具有相当好的响应性。

对我而言，归结为：

*   如果您关心隐私和速度以及最大的可记忆性，我推荐CloudFlare：

```
1.1.1.1  
1.0.0.1
```

我发现两家公司的过滤声称对我的口味来说太不透明了，他们都觉得边缘营销是诚实的。

*   如果你想要URL过滤，我推荐 Quad9 over Umbrella只是因为它更容易记住并且似乎专注于拥有多个威胁情报源。

```
9.9.9.9
```

*   如果你想要多层次的 URL 过滤，你可以使用Norton 产品，但我认为我个人更喜欢只使用 Quad9 并完成它。但我认为 Norton 仍然是一个很酷的 选择，就比如通过最严格的选择强迫他们的DNS来保护整个学校或其他东西。


## 总结

最后的追加 - 总之 - 这是我建议你记住的两点。

1.  为了速度和隐私：`1.1.1.1`
2.  用于过滤：`9.9.9.9`

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
