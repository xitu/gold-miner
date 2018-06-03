> * 原文地址：[The Right Way to Bundle Your Assets for Faster Sites over HTTP/2](https://medium.com/@asyncmax/the-right-way-to-bundle-your-assets-for-faster-sites-over-http-2-437c37efe3ff)
> * 原文作者：[Max Jung](https://medium.com/@asyncmax?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/the-right-way-to-bundle-your-assets-for-faster-sites-over-http-2.md](https://github.com/xitu/gold-miner/blob/master/TODO/the-right-way-to-bundle-your-assets-for-faster-sites-over-http-2.md)
> * 译者：[yct21](https://github.com/yct21/)
> * 校对者：[ParadeTo](https://github.com/ParadeTo)，[altairlu](https://github.com/altairlu)

# HTTP/2 下提高网站加载速度的资源打包指南

加载速度一直是 web 开发的重点。随着 HTTP/2 的出现，我们用很少的精力就可以提升网站性能。本文首先为不熟悉的读者简要介绍了 HTTP/2 的基本概念，随后列出了基准测试时所得到的数据，并在此基础上给出了一些简洁的参考建议，确保网站对 HTTP/2 进行了优化。

## HTTP/2 的概念与重要性

自 1997 年诞生以来，HTTP/1.1 一直以一成不变的方式工作着，但网站却日渐臃肿起来。终于，在 2015 年，HTTP 协议迎来了大版本更新。HTTP/2 更加注重页面加载的延迟，毕竟用户对一个 web 应用的性能的感受，[取决于延迟而不是带宽](https://docs.google.com/presentation/d/1r7QXGYOLCh4fcUq0jDdDwKJWNqWK1o4xMtYpKZCJYjM/edit#slide=id.g518e3c87f_2_0)。HTTP/2 采用了[多路复用](https://http2.github.io/faq/#why-is-http2-multiplexed)的工作方式，辅以首部压缩等手段，以解决延迟的问题。

在精心设计下，HTTP/2 的语义兼容于 HTTP/1.1。站在开发者的角度，我们无需因此改变写代码的方式。不过在 HTTP/2 的环境下，为了最大化多路复用所能带来的性能提升，我们需要对传输资源文件的方法做出调整。随着HTTP/2 这门技术的流行以及支持它的主机服务商的增加，优化网站在 HTTP/2 下的性能，从而在永不停息的网站速度竞赛中保持竞争力，显得尤为重要。根据 W3Techs 的统计，2016 年 4 月，全球流量前一千万的网站中，已经有 7.1% 的网站支持 HTTP/2，这个数据还在不断上升。同时，CloudFlare 发表了一篇有意思的[文章](https://blog.cloudflare.com/introducing-http2/)，介绍了 SPDY & HTTP/2 在现实世界的流量统计。其中指出，早在 2015 年的 12 月，就已经有 81% 的网络流量，是以 SPDY 或者 HTTP/2 的方式进行传输的。

考虑到 SPDY 作为 HTTP/2 的先驱，提供了绝大部分 HTTP/2 能带来的优化，因此本文将其视为 HTTP/2 的变种。而若将 SPDY 与 HTTP/2 放在一起统计，我们可以看到，HTTP/2 已经不是未来的概念，而是现已成熟的技术。它已无所不在，绝大部分的桌面或移动浏览器，都至少支持 SPDY 和 HTTP/2 其中的一个。

## HTTP/2 打包的谣言

所以要最大化 HTTP/2 的收益，我们到底应该怎样组织网站的资源文件？在 HTTP/1.1 的时代，将多个资源文件拼成一个大文件来减少总连接数，是对网站性能最重要的提升。

这种方法的坏处是，浏览器的缓存管理功能会受到影响。哪怕一个很小的资源文件发生了变动，整个合并后的文件都要再重新传输一遍。当然在 HTTP/1.1 的环境下，拼接文件所带来的性能提升，HTTP/2 下，要远远高于其带来的损失。

而另一方面，HTTP/2 可以同时传输多个小文件，无需过多的额外开销。因此，在 HTTP/2 环境下，[合并资源文件一直被视为错误的做法](https://docs.google.com/presentation/d/1r7QXGYOLCh4fcUq0jDdDwKJWNqWK1o4xMtYpKZCJYjM/edit#slide=id.g518e3c87f_0_318)。毕竟，避免了合并文件，可以让浏览器的缓存更加有效地运作。

然而在实际环境中，我们发现[事情并不简单](http://engineering.khanacademy.org/posts/js-packaging-http2.htm)。

和主流观念不同，我们的基准测试显示，合并资源文件这种做法即使是在 HTTP/2 下也能提升网站性能。和 HTTP/1.1 下拼接为一个文件的策略不同，HTTP/2 中更好的方法是将资源分组，分别打包。这种做法不仅能减少延迟，还可以发挥浏览器缓存管理的作用。而即使客户端只支持 HTTP/1.1，这里也只是从传输一个合并文件变为传输多个打包文件，页面加载的表现不会受到太大影响。

## HTTP/2 基准测试的细节

这里的基准测试每次都使用 4 个页面，各个页面会从服务器请求并加载不同数量的 JavaScript 文件，用以模拟文件合并的不同层级。每次测试所用的 JavaScript 文件数量各有不同，但传输的数据总量保证是一致的。

测试选取了搭建于 3 个不同地区的 AWS 上的 web 服务器，用以模拟客户端与服务器间在不同距离上的连接。客户端采用了 15Mbps 的 Comcast 民用光纤宽带，使用 Windows 10 和 Chrome 50 进行测试。

后文的测试结果图表中，4 列代表 4 种不同的文件合并级别，每一行给出的数据分别是对 10 中不同的样本数据进行测试的结果（关闭了浏览器缓存），每次测试之间会有一段间隔时间。

* **1000**：载入 1000 个小型 JavaScript 文件，每个 819 字节，用以模拟不做任何合并的策略。
* **50**：载入 50 个中性 JavaScript 文件，每个 16399 字节，用以模拟中度的合并策略。
* **6**：载入 6 个大型 JavaScript 文件，每个 136666 字节，用以模拟较激进的合并策略。
* **1**：载入 1 个巨型 JavaScript 文件，每个 819999 字节，用以模拟极端的合并策略。

### 从圣何塞到美国西部（北加利福尼亚）

![](https://cdn-images-1.medium.com/max/800/1*_7p74XMRQjuoeEYcA_jjYg.png)

![](https://cdn-images-1.medium.com/max/800/1*lFAaGiYTuBHVZM7lguCsjA.png)

结果显示，当文件数量从 1000 个降到了 50 后，加载速度平均上升了 66%。当文件数到达 6 个乃至 1 个时，相比于完全不做合并时的加载速度，也有几乎 70% 的提升。

### 从圣何塞到美国东部（北弗吉尼亚）

![](https://cdn-images-1.medium.com/max/800/1*Iepr45KgMK6pQ263xTFkOg.png)

![](https://cdn-images-1.medium.com/max/800/1*37Z0AJ3JLerHGc_yRUY9Tw.png)

在这次的基准测试中，随着文件数量从 1000 降至 50，加载速度平均提升了 28.4%。

### 从圣何塞到亚太地区（首尔）

![](https://cdn-images-1.medium.com/max/800/1*Kpxr2LBNWR75grAagVgu0g.png)

![](https://cdn-images-1.medium.com/max/800/1*f5rh5cgcRuzJHLeBQ9sYPA.png)

这里我们可以看到，由于客户端与服务器的距离过远，页面载入的速度明显降低。但当文件数量从 1000 降到 50 以下时，加载速度还是有平均 27% 的提升。

## 测试结果与重要发现

* 即使在 HTTP/2 的环境下，每种程度的文件合并都能带来显著的性能提升。
* 如果客户端与服务器的距离很近（连接的延迟非常短），性能的提升相当显著（提升了 3 倍）。
* 1000 以下的 3 个文件数量级别（50，6 和 1 个文件），性能提升的差距可以忽略。
* 随着客户端和服务器的距离逐渐增加（延迟逐渐加大），所有样本中加载速度的波动都在增加。也就是说在超长距离的测试中，由于数据的波动太大，比较任意 2 个数据可能是无意义的。

## 结论与建议

### 尽量将资源文件打包传输

尽管 HTTP/2 被设计成一个可以高效传输许多小文件的协议，但当需要传输的文件数达到一定规模后，每个文件带来的额外开销也会积少成多，影响效率。此外，浏览器和服务器本来就都有并行传输数据流的上限。[Chrome 的上限似乎是 256](https://github.com/gourmetjs/http2-concat-benchmark-docs/blob/master/images/chrome_limit.png)；而在 NGINX 中用于基准测试的 ngx_http_v2_module 里面，会使用 [http2_max_concurrent_streams](http://nginx.org/en/docs/http/ngx_http_v2_module.html#http2_max_concurrent_streams) 这个配置参数，它的默认值为 128。一个现代的 web 应用，如果不去做任何合并，资源文件的数量可以轻而易举到达好几百，导致 HTTP/2 需要[分多次进行传输](https://github.com/gourmetjs/http2-concat-benchmark-docs/blob/master/images/stream_concurrency.png)。

为了提高浏览器缓存的效率，资源文件要分成多个组进行打包，而不要全部合并成单独的一个文件。每一个包中应该包含一组相关的资源，如果这样的话，改动就可以控制在组内而不影响其他组。

举个例子，对于每个 NPM 模块都单独打包，是一个不错的策略。每当某个模块更新时，只有该模块对应的浏览器缓存会失效。这个策略会导致打包后的文件数量增加，但我们可以从基准测试中看出，当传输的文件数量低于一个值（本次测试中的 50）时，得益于 HTTP/2 的多路复用，性能不会受到过多影响。上文已经提过，别轻信 HTTP/2 下不要做任何合并的建议。从测试结果中可以看出，不合并策略下，传输各个小文件带来的开销，积累起来毫无疑问会影响性能。

### 考虑兼容 HTTP/1.1

尽管 HTTP/2 （或者 SPDY) 已被广泛使用，我们依然不能忽略 HTTP/1.1 协议。这点在垂直应用中更加重要。

为了同时保证 HTTP/2 和 HTTP/1.1 环境下的性能，最好方法是根据浏览器支持的协议，采取不同的文件合并策略（对 HTTP/2 使用适度的文件合并，对 HTTP/1.1 使用极端的文件合并）。不过在大部分情况下，维护 2 种不同合并策略，是没必要的过度优化。

如果我们在 HTTP/1.1 下也采取前文所建议的分组打包的策略会如何呢？

![](https://cdn-images-1.medium.com/max/800/1*fy8n3lBauSinX37LlLGyAA.png)

如你所见，用 HTTP/1.1 传输 50 个打包文件的结果，并不会比传输 6 个或者 1 个文件要差太多。因此，在 HTTP/2 和 HTTP/1.1 间找到平衡，选取一个合适的文件打包数量，是一个合理的妥协。

> **注1**： 在 HTTP/1.1 模式的测试中，我们使用了 Chrome 作为浏览器，传输使用的是 HTTP 而不是 HTTPS。由于 Chrome 浏览器在打开 HTTP/1.1 的网站时使用 6 个并发的 TCP 连接，所以现实世界中的 HTTP/1.1 浏览器在资源文件增加时，可能会遭遇性能的显著下降。
> **注2**：注意不要拿 HTTP/1.1 的数据直接去和之前 HTTP/2 测试中的数据进行比较。HTTP/2 的测试在繁忙的工作日里进行，而 HTTP/1.1 测试执行于周日下午，结果会优于 HTTP/2 测试。

### 继续使用雪碧图

在 HTTP/2 环境下，出于和合并文件同样的理由，大家可能认为，[雪碧图](http://www.w3schools.com/css/css_image_sprites.asp) 是应该避免使用的。

然而，如果雪碧图中的每个图标文件都足够小，且采用了相同的设计主题，那么相比分别传输单独的图片文件，使用雪碧图可能是更好的方法。

因为如果雪碧图中的图标之间相互联系，并共享同样的设计主题，那么当设计发生变化时，很有可能雪碧图中的很多图标都需要更新，此时小粒度的缓存不再有优势。

### 谨慎使用 data URI

还有一种打包资源文件的方法，是采用 [data URI](https://developer.mozilla.org/en-US/docs/Web/HTTP/data_URIs)的形式，直接将资源内联在网页中。这种方法在 HTTP/2 中一般也被认为是应当避免的。

内嵌 data URI 的利弊，是一个更为微妙的问题，合适的答案应该是“看情况而定”。如果资源文件非常小（小于 100 字节），采用内联更加合理。即使资源文件相对较大，如果这些资源经常发生变动，或者这些变动必须和资源所在的页面同步，内联也更有利。

### 同时支持 SPDY 和 HTTP/2

这是一个部署问题，和开发的关系不大。如今还有很多浏览器只支持 SPDY，HTTP/2 对 SPDY 的彻底取代还需要一定的时间。

而在此之前，我们还不能忽视 SPDY。在部署应用时，我们要让服务器同时支持 SPDY 和 HTTP/2 协议。CloadFlare [开源了](https://blog.cloudflare.com/open-sourcing-our-nginx-http-2-spdy-code/) 一个补丁，可以让 NGINX 做到这点。

---

考虑到 HTTP/2 起步不久，还没有得出相关的最佳实践方法。尽管如此，web 开发者最好还是留心本文提出的建议，尽可能地榨取 HTTP/2 提供的性能提升，灵活地利用好浏览器缓存。

这里可以查看基准测试代码：[https://github.com/gourmetjs/http2-concat-benchmark](https://github.com/gourmetjs/http2-concat-benchmark)

这里可以查看文章中所有的图表: [https://github.com/gourmetjs/http2-concat-benchmark-docs](https://github.com/gourmetjs/http2-concat-benchmark-docs)


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
