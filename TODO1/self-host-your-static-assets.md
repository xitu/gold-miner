> * 原文地址：[Self-Host Your Static Assets](https://csswizardry.com/2019/05/self-host-your-static-assets/)
> * 原文作者：[Harry](https://twitter.com/intent/follow?original_referer=https%3A%2F%2Fcsswizardry.com%2F2019%2F05%2Fself-host-your-static-assets%2F&ref_src=twsrc%5Etfw&region=follow_link&screen_name=csswizardry&tw_p=followbutton)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/self-host-your-static-assets.md](https://github.com/xitu/gold-miner/blob/master/TODO1/self-host-your-static-assets.md)
> * 译者：[twang1727](https://github.com/twang1727)
> * 校对者：[noahziheng](https://github.com/noahziheng), [MarchYuanx](https://github.com/MarchYuanx)

# 自托管你的静态资源

有一条为网站提速最方便的捷径，同时也是我建议我的客户们做的第一件事，虽然它有点反常识，就是将所有的静态资源放在自己主机上，而不是用 CDN 或公共的基础设施。在这篇简短并且希望称得上直白的文章中，我打算列出以 ‘off-site’ 方式托管静态资源的坏处，以及自托管的好处。

## 我在说什么呢？

使用托管在公共或者 CDN URL 上的静态资源，比如库或者插件，这种做法对于开发者来说，十分常见，比如用 jQuery 我们可以这样做：

```html
<script src="https://code.jquery.com/jquery-3.3.1.slim.min.js"></script>
```

这么做有许多显而易见的好处，但是我这篇文章的目的是驳倒这些说法，或者是表明这么做成本远大于收益。

* **方便**。像这样链入文件特别省事，复制粘贴一行 HTML，搞定。真简单。
* **我们接入了 CDN**。`code.jquery.com` 是 [StackPath](https://www.stackpath.com/products/cdn/) 这个 CDN 来服务的。我们这样链接资源可以得到 CDN 级别的传输质量，还是免费的！
* **用户可能已经将文件缓存好**。如果 `website-a.com` 链接到 `https://code.jquery.com/jquery-3.3.1.slim.min.js`，然后用户从那跳转到恰好也链接到 `https://code.jquery.com/jquery-3.3.1.slim.min.js` 的 `website-b.com`，那么文件就已经在用户的缓存里了。

## 风险：减速和宕机

这篇文章里我不会讲得太详细，因为我写了一篇[完整的文章](https://csswizardry.com/2017/07/performance-and-resilience-stress-testing-third-parties/)来讨论第三方服务的恢复力以及相关的减速与宕机风险。可以这样说，如果你有任何重要资源放在第三方服务器上，一旦服务商出现阻塞，甚至直接宕机，那么就糟糕了。你也会遭殃。

如果你用第三方域托管阻塞渲染的 CSS 或同步 JS，**现在**就把它移回自己的基础设施上。重要的资源不应该放在别人的服务器上。

## 风险：服务停止

虽然并不常见，但是如果服务商决定要停止服务怎么办呢？2018 年十月 [Rawgit](https://rawgit.com) 关站，然而（在本文写成时）粗略的 Github 代码检索得出，[至少一百万个](https://github.com/search?q=rawgit&type=Code)这项已经停止服务的引用，大概 20,000 个正常运行的网站仍在使用它！

![](https://csswizardry.com/wp-content/uploads/2019/05/big-query-rawgit.jpg)

十分感谢 [Paul Calvano](https://twitter.com/paulcalvano) 为我提供了 [HTTPArchive 上的检索结果](https://bigquery.cloud.google.com/savedquery/226352634162:7c27aa5bac804a6687f58db792c021ee)。

## 风险：安全隐患

另外一个需要考虑的问题是可信度。如果我们将外源内容放在我们的页面上，我们就会希望送达的资源是我们所期望的，而且只会发挥我们所期望的作用。

想象一下如果有人控制了 `code.jquery.com` 这种服务商并开始提供有漏洞的或恶意的 payload, 那样会造成多大的损失。想都不敢想！

### 缓解方案：子资源完整性

本文提到的所有服务商值得称道的一点是，它们都应用了[子资源完整性](https://developer.mozilla.org/en-US/docs/Web/Security/Subresource_Integrity) (SRI)。SRI 的机制通过服务商为双方期待使用的文件提供哈希值（准确得讲 Base64 编码的哈希值）来实现。浏览器会检查你收到的文件正是你所请求的那一个。

```html
<script src="https://code.jquery.com/jquery-3.4.1.slim.min.js"
        integrity="sha256-pasqAKBDmFT4eHoN2ndd6lN370kFiGUFyTiUHWhU7k8="
        crossorigin="anonymous"></script>
```

重申一下，如果你绝对必须链接到外部托管的静态资源，那就确保它实现了 SRI。你可以用这个[好用的生成器](https://www.srihash.org/)来自己添加 SRI。

## 扣分项：网络协商

一个最重要最直接的扣分项就是降低新 TCP 连接的成本。我们要访问的每个新节点都需要打开连接，这些步骤的消耗非常大：DNS 解析，TCP 握手，TLS 协商，而且一旦连接的延迟提高就会让情况更糟。

我会拿 Bootstrap 的[入门](https://getbootstrap.com/docs/4.3/getting-started/introduction/)当做例子。他们指导用户引入以下四个文件：

```html
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="..." crossorigin="anonymous">
<script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="..." crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js" integrity="..." crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="..." crossorigin="anonymous"></script>
```

这四个文件由三个不同的源来托管，所以我们需要打开三个 TCP 连接。成本是多少呢？

好吧，在还不错的网速上，托管这些静态资源用掉 311ms，或 1.65 倍慢于放置在自己主机上。

![](https://csswizardry.com/wp-content/uploads/2019/05/wpt-off-site-cable.png)

连接到托管静态资源的三个不同的源，我们在网络协商上总共花费了多余的 805ms。[完整测试在此。](https://www.webpagetest.org/result/190531_FY_618f9076491312ef625cf2b1a51167ae/3/details/)

OK，不是很糟，但是我的一个客户 Trainline 发现为了降低 300ms 延迟，[客户们每年要多花费 800 万英镑](https://wpostats.com/2016/05/04/trainline-spending.html)。这么花掉 800 万真是浪费。

![](https://csswizardry.com/wp-content/uploads/2019/05/wpt-self-hosted-cable.png)

单单把资源移到主域，我们就可以完全去除多余的连接开支。[全文](https://www.webpagetest.org/result/190531_FX_f7d7b8ae511b02aabc7fa0bbef0e37bc/3/details/)

在高延迟的连接上，情况会糟得多。3G 网络上，外部托管的版本要多花 1.765s 😭，这么做本来不是为了让网站更快吗？！

![](https://csswizardry.com/wp-content/uploads/2019/05/wpt-off-site-3g.png)

在高延迟连接上，总联网开支竟达到 5.037s。这完全可以避免的。[全文](https://www.webpagetest.org/result/190531_XE_a95eebddd2346f8bb572cecf4a8dae68/3/details/)

将资源移到自己的基础设施上会将加载时间从大约 5.4s 降到仅仅 3.6s。

![](https://csswizardry.com/wp-content/uploads/2019/05/wpt-self-hosted-3g.png)

自托管静态资源时，我们无需打开更多连接。[全文](https://www.webpagetest.org/result/190531_ZF_4d76740567ec1eba1e6ec67acfd57627/1/details/)

如果这还不够说服你自托管静态资源，我也没办法了！

### 缓解方案：`preconnect`

很自然的，我的主要观点是如果你能自己 host 静态资源你就不应该托管它们。但是，如果这样做不方便，你就可以用 [`preconnect` 资源提示](https://speakerdeck.com/csswizardry/more-than-you-ever-wanted-to-know-about-resource-hints?slide=28)来提前打开相应源的 TCP 连接：

```html
<head>

  ...

  <link rel="preconnect" href="https://code.jquery.com" />

  ...

</head>
```

把它们当作 [HTTP headers](https://andydavies.me/blog/2019/03/22/improving-perceived-performance-with-a-link-rel-equals-preconnect-http-header/) 来部署会更好。

**注意** 即使你实现了 `preconnect`，你也只能挽回一小部分浪费掉的时间：你还是要打开相关连接，特别是那些高延迟的，你不太可能马上把所有的开支抵消掉。

## 扣分项：优先处理策略带来的损失

第二个扣分项以协议层优先处理的形式存在，而这种优先处理在我们将内容跨域存放是被破坏了。如果你用 HTTP/2（你确实应该用），你就会用到优先处理。同一个 TCP 连接上的所有的流（也就是说资源）都有一个优先级，而浏览器和服务器会协作建立这些优先处理流的依赖树，从而优先递送关键资源，延迟递送不太重要的资源。

想要完全理解优先处理的好处，[Pat Meenan 的文章](https://calendar.perfplanet.com/2018/http2-prioritization/)很好的帮助你入门。

**注意** 从技术角度讲，由于 HTTP/2 的[连接合并](https://daniel.haxx.se/blog/2016/08/18/http2-connection-coalescing/)，只要有相同的 IP 地址，不同域上的请求就会被依优先级处理。

如果我们把资源分置到多个域上，我们就要打开好几个不同的 TCP 连接。我们没法在不同连接上相互引用那些优先级，所以就会失去以这种深思熟虑、妥善设计的方式传递资源的能力。

比较一下托管和自托管两个版本的 HTTP/2 依赖树：

![](https://csswizardry.com/wp-content/uploads/2019/05/wpt-dep-tree-off-site.png)

注意到我们要对每个源建立不同的依赖树了吗？Stream ID 1 和 3 反复出现。

![](https://csswizardry.com/wp-content/uploads/2019/05/wpt-dep-tree-self-hosted.png)

把所有内容放在同一个源下，我们就可以建立一个唯一的、完整的依赖树。因为所有流都在同一个树里，它们都有唯一的 ID。

有趣的是，奇数 Stream ID 是从客户端起始的，偶数的是被服务器起始的。老实说我从来没见过一个偶数 ID。

如果我们尽可能从一个域提供很多内容，我们可以让 HTTP/2 更全面的做好优先处理，以期更迅捷的响应。

## 扣分项：缓存

大致上说，静态资源主机很适用于建立长期 `max-age` 指令。这很自然，因为版本化 URL 上的静态资源（如上）从来不会变。因此使用适度激进的缓存策略是安全合理的。

话虽这么讲，也不是所有情况都适用，而且用自托管资源你可以设计出[更有针对性的的缓存策略](https://csswizardry.com/2019/03/cache-control-for-civilians/)。

## 神话：跨域缓存

一种更有趣的看法是关于资源跨域缓存的威力的。意思是，如果许多网站链接到同一个 CDN 托管的资源，比如，jQuery，那么用户一定更可能已经在他们的终端上存有相同的文件吗？有点像点对点资源共享。这是支持使用第三方静态资源服务商的最常见理由之一。

不幸的是，似乎没有任何公开证据来支持这些说法：不能证明事实是这样的。相反的，[Paul Calvano](https://twitter.com/paulcalvano) 的[最新研究](https://discuss.httparchive.org/t/analyzing-resource-age-by-content-type/1659)暗示了相反的情况：

> 自托管及第三方托管的 CSS 和网络字体的资源寿命有显著不同。95% 的自托管字体久于一周而 50% 的第三方字体不及一周。这是对自托管网络字体的强烈支持！

总体上说，第三方内容不如自托管内容缓存比例高。

更重要的是，[Safari 完全去除了这个功能](https://andydavies.me/blog/2018/09/06/safari-caching-and-3rd-party-resources/)来避免隐私滥用，所以本文写成时共享缓存技术对[世界上 16% 的用户](http://gs.statcounter.com/)是不能应用的。

一句话，虽然理论上很美好，但是无证据表明跨域缓存是有效的。

## 神话：访问 CDN

另外一个经常被吹捧的静态资源服务的优点在于，它们想必在具有 CDN 能力的优质基础实施上运行的：全球分布，可伸缩，低延迟，高可用度。

虽然说得没错，但是如果你注重性能，你应该已经用 CDN 运行你的内容了。考虑当代托管服务的价格（本网站是用免费的 Cloudflare），不用 CDN 托管资源实在说不过去。

这么说吧：如果你觉得你的 jQuery 需要用 CDN，那你所用的东西都需要 CDN。用吧。 

## 自托管资源

实在是没理由把静态资源放在别人的基础设施上。直觉上的优点经常是谎言，即使不是，权衡之后往往就不值得了。从多个源加载资源确实很慢。接下来几天里，花上十分钟来审计一下自己的项目，重新掌控你 off-site 的静态资源吧。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
