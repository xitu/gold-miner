> * 原文地址：[DNS Servers That Offer Privacy and Filtering](https://danielmiessler.com/blog/dns-servers-you-should-have-memorized/)
> * 原文作者：[DANIEL MIESSLER](https://danielmiessler.com/blog/author/daniel/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/dns-servers-you-should-have-memorized.md](https://github.com/xitu/gold-miner/blob/master/TODO1/dns-servers-you-should-have-memorized.md)
> * 译者：[ScDadaguo](https://github.com/ScDadaguo)
> * 校对者：[lsvih](https://github.com/lsvih)，[Fengziyin1234](https://github.com/Fengziyin1234)

# 提供隐私和过滤功能的 DNS 服务器

最新的 DNS 服务器 IP 都是更易于记忆，并提供隐私和过滤功能的。

![](https://danielmiessler.com/images/DNS.png)

如果你是程序员，系统管理员，或任何类型的 IT 工作人员，你会有自己喜欢的首选 IP 地址来进行故障排除。就像我一样，可能很多年都使用同一个 dns。

这些 IP 可用于：

*   测试 `ping` 连接
*   使用 `dig` 或 `nslookup` 检查 DNS 解析
*   更新系统的永久 DNS 设置

> 大多数 DNS 服务器允许你 ping 它们。

我喜欢使用 DNS 服务器，因为可以用它们测试连接和名称解析。我使用时间最长 DNS 服务器是 Google DNS 服务器，如下：

```
8.8.8.8  
8.8.4.4
```

…但他们没有启用任何过滤功能，因此近年来，我不再想把所有 DNS 查询都发给 Google。

> Cisco 收购了 OpenDNS 公司，Umbrella 便来自于此。

## Google DNS的替代品

在某些时候，我转而使用 Cisco 的 Umbrella 服务器，因为它们会为你进行 URL 过滤。他们维护一个危险 URL 列表并自动阻止它们，这有助于阻止恶意软件。

```
208.67.222.222  
208.67.220.220
```

虽然 OpenDNS 服务器很棒，但我总是需要先去查找它们的地址。直到几年前，出现了一套新的 DNS 服务器，不仅关注速度和功能，还关注 **可记忆性** 。

最容易记的 DNS 服务器 是 IBM 的 Quad9，和你想的一样，它的 IP 由 4 个 9 组成：

```
9.9.9.9
```

> 我觉得它刚一发布就超负荷运行了，或者是他们的过滤功能还没有被调整好。

我最初尝试使用 Quad9 时发现它有点慢。我想他们现在应该已经解决了这个问题，但更多关于以下的表现。

## CloudFlare 出现了

![, DNS Servers That Offer Privacy and Filtering](https://danielmiessler.com/images/Screen-Shot-2019-01-27-at-11.49.14-PM-300x300.png)

在 Google、Cisco 和 IBM 提供具有各种有趣的方案后，然后我们看到 CloudFlare 进入该领域。

CloudFlare 不是提供过滤功能，而是专注于隐私方面的提升。

> 还有一些 recursive DNS 服务声称其服务是安全的，因为它们支持 DNSSEC。虽然这是一种很好的安全措施，但具有讽刺意味的是，这些服务的用户并未受到 DNS 公司本身的保护。其中许多公司出于商业目的，从其 DNS 客户处收集数据。相反，1.1.1.1 这个 DNS 不会挖掘任何用户数据，而且日志只保留 24 小时以进行调试，然后就会完全被清除。
>   
> CloudFlare 网站

也许对我来说最酷的是它们的 DNS 非常好记，非常棒：

1.0.0.1 可以缩写为 1.1，因此你可以通过输入 `ping 1.1` 进行测试。

```
1.1.1.1  
1.0.0.1
```

非常的方便！

因此使用它们时，不会对你的 URL 进行过滤，而且它们会有意识地避免以任何方式记录或者跟踪你，这也是极好的。

## Norton ConnectSafe DNS

Norton 也有一个公共 DNS 服务，它有一个有趣的功能：多级 URL 内容过滤。

### 阻止恶意和欺诈性网站

```
199.85.126.10  
199.85.127.10
```

### 阻止色情内容

```
199.85.126.20  
199.85.127.20
```

### 阻止各种形式的成人内容

```
199.85.126.30  
199.85.127.30
```

## 我的推荐

DNS 服务器的性能根据你所处的地理位置而有所不同，但在最近的测试中，我发现它们的响应都挺快的。

对我而言归结为：

*   如果你关心隐私和速度以及为了好记，我推荐 CloudFlare：

```
1.1.1.1  
1.0.0.1
```

我发现两家公司的 DNS 过滤服务都不是很好，说实话，我觉得他们两家公司就像是在边缘营销。

*   如果你想要 URL 过滤，比起 Umbrella，我更推荐 Quad9，因为它更容易记住并且拥有多个威胁情报源。

```
9.9.9.9
```

*   如果你想要进行多层次的 URL 过滤，你可以使用 Norton 的产品，同时我个人更喜欢只使用 Quad9。但我也认为选择 Norton 依然是一个很酷的选择，就比如用他们的 DNS 进行最严格的 URL 过滤来保护整个学校或者其他一些系统。

## 总结

最后说两点总结：

1.  为了速度和隐私：`1.1.1.1`
2.  用于过滤：`9.9.9.9`

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
