> * 原文地址：[Building a Shop with Sub-Second Page Loads: Lessons Learned](https://medium.baqend.com/building-a-shop-with-sub-second-page-loads-lessons-learned-4bb1be3ed07#.svcz7qtdn)
* 原文作者：[Erik Witt](https://medium.baqend.com/@erik.witt)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[luoyaqifei](http://www.zengmingxia.com)
* 校对者：[Romeo0906](https://github.com/Romeo0906)，[L9m](https://github.com/L9m)

# 全方位提升网站打开速度：前端、后端、新的技术








> 这里是 [**我们**](http://www.baqend.com/) 充分利用对于网络缓存和 NoSQL 系统的研究，做出一个可以容纳几十万通过电视宣传慕名而来的访问者的 [**网上商城**](http://www.thinks.com/) 的故事，以及我们从中学到的一切。













![](https://cdn-images-2.medium.com/max/1200/1*8n8yIaSM7m7VflC3dOGr8g.png)









"Shark Tank"（美国），"Dragons’ Den"（英国）或" Die Höhle der Löwen（DHDL）"（德国）等电视节目为年轻初创公司供了一次在众多观众前向商业大亨推销自己产品的机会。然而，主要的好处往往不在于评审团提供的战略投资——[只有少数交易会完成](http://www.bloomberg.com/news/articles/2014-07-15/shark-tank-do-two-thirds-of-deals-fall-apart)——而是在电视节目播放期间引发的关注：即使是几分钟的直播也能给网站带来几十万的新用户，同时能够提高几周、几个月甚至永久性的网站基本活跃水平。也就是说，如果网站可以抓住初始负载尖峰，并且不拒绝用户请求……

### 仅仅可用是不够的——延迟是关键！

网上商城的盈利压力特别大，因为他们不只是消遣项目（诸如博客），但通常由于创始人本身有大量投资支持，必须**转化为利润**。很明显，对于商业业务来说，最坏的情况是网站过载，在此期间服务器不得不丢掉部分用户请求甚至可能完全崩溃。这并不像你想象的那样罕见：在 DHDL 的这一季，大约有一半的网上商店在直播现场就无法连接了。并且，保持在线只有一半的租金，因为**用户满意度是强制连接到转化率**，从而直接转化为产生的收入的。



![](https://cdn-images-2.medium.com/max/800/1*bw_wf7Q8V_nykLwdnTA8wQ.png)

[Source](http://infographicjournal.com/how-page-load-time-can-impact-conversions/)



关于页面加载时间对客户满意度和转换率的影响，有很多 [研究](https://wpostats.com/tags/conversions/) 支持这种说法。例如，Aberdeen Group 发现，额外延迟的 1 秒会导致页面浏览量减少 11％，转化次数损失 7％。 但你也可以询问 [Google](https://wpostats.com/2015/10/29/google-500ms.html) 或 [Amazon](https://wpostats.com/2015/10/29/amazon-1-percent.html)，他们会告诉你同样的说法。

### 怎样让网站加速

为初创公司 [_Thinks_](https://www.thinks.com/) 搭建的网上商城参与了 DHDL，并在 9 月 6 日播出。我们面临着一个挑战，搭建一个能够承受数十万访客量的网上商店，并且加载时间稳定在 1 秒以内。以下都是我们在这个过程中以及从近些年对数据库和网络的性能研究中学到的。

在现有的 web 应用技术中有三个影响页面加载时间的主要原因，展示如下：









![](https://cdn-images-2.medium.com/max/800/1*j_z9Rbmp0GLNqr4LwWVCmQ.png)





1. **后端处理**：web 服务器需要时间从数据库加载数据和整合网站。
2. **网络延迟**：每个请求需要时间从客户端传输到服务器，并返回（请求延迟）。当考虑到平均每个网站需要发出超过 [100 个请求](http://httparchive.org/interesting.php) 才能完全加载时，这变得更加重要。
3. **前端处理**：前端设备需要时间来渲染页面。

为了让我们的网店加速，让我们一一解决这三个瓶颈。

#### 前端性能

影响前端性能最重要的因素是关键呈现路径（[CRP](https://developers.google.com/web/fundamentals/performance/critical-rendering-path/?hl=zh-CN)），它描述了在浏览器中向用户显示页面所需的 5 个必要步骤，如下所示。













![](https://cdn-images-2.medium.com/max/1200/1*1DEuTsfd9RckmywKDTwxGA.tiff)



关键呈现路径的步骤：







*   **DOM**：当浏览器解析HTML时，它会增量式地生成一个 HTML 标签的树模型，称为 **文档对象模型**（DOM），该模型描述了页面内容。
*   **CSSOM**：一旦浏览器接收到所有的 CSS，它会生成一个 CSS 中包含的标签和类的树模型，称为 **CSS 对象模型**，在树节点上还附有样式信息。这棵树描述了页面内容是如何设置样式的。
*   **渲染树**：通过组合 DOM 和 CSSOM，浏览器构造一个渲染树，它包含页面内容以及要应用的样式信息。
*   **布局**：布局这一步计算屏幕上页面内容的实际位置和大小。
*   **绘制**：最后一步使用布局信息将实际像素绘制到屏幕上。

单个步骤是相当简单的，使事情变得困难并限制性能的是这些步骤之间的依赖。DOM 和 CSSOM 的构造通常具有最大的性能影响。

这个图表显示了关键呈现路径的步骤，里面包括等待依赖，如箭头所示。













![](https://cdn-images-2.medium.com/max/1200/1*t40GwOqsIbif3WUxKGMRVQ.tiff)



关系呈现路径中重要的依赖







在加载 CSS 和构造完整的 CSSOM 之前，什么都不能显示给客户端。因此 CSS 被称为是**阻塞渲染**的。

JavaScript（JS）更糟糕，因为它可以访问和更改 DOM 和 CSSOM。 这意味着一旦发现 HTML 中的脚本标记，DOM 构造就会被暂停，并从服务器请求脚本。一旦脚本被加载，只有在所有 CSS 被提取和 CSSOM 被构造以后，它才能被执行。在 CSSOM 构建之后 JS 被执行，在下面的例子中，它可以访问和改变 DOM 以及 CSSOM。只有这样之后，DOM的构造才能进行，并且页面才能显示给客户端。因此 JavaScript 被称为是阻塞解析的。

JavaScript 访问 CSSOM 和更改 DOM 的示例：

    <script>
       ...
       var old = elem.style.width;
       elem.style.width = "50px";
       document.write("alter DOM");
       ...
    </script>

JS 甚至会影响更恶劣。例如 [jQuery 插件](https://github.com/jjenzz/jquery.ellipsis) 访问计算后的 HTML 元素的布局信息，然后开始一次又一次地改变 CSSOM，直到实现了所需的布局。因此，在用户将看到白色屏幕以外的任何东西之前，浏览器必须一次又一次地重复地执行 JS、构造渲染树和布局。

有三个优化 CRP 的 [基本概念](https://developers.google.com/web/fundamentals/performance/critical-rendering-path/optimizing-critical-rendering-path)：

1.  **减少关键资源：** 关键资源是页面最初渲染时所需的资源（HTML，CSS，JS 文件）。通过将渲染不滚动时可见的网站部分（称为**首屏**）所需要的 CSS 和 JS **内联**可以大大减少关键资源。接下来的 JS 和 CSS 应该被**异步**加载。无法被异步加载的文件可以**拼接**到一个文件中。
2.  **最小化字节：** 通过**最小化**和**压缩** CSS，JS 和图像，可以大大减少 CRP 中加载的字节数。
3.  **缩短 CRP 长度：** CRP 长度是获取所有关键资源所需的与服务器之间的最大连续**往返数**。它可以通过减少关键资源和最小化它们的大小（大文件需要多个往返来获取）来缩短。将 **CSS 放在 HTML 顶部**，以及 **JS 放在 HTML 底部**，可以进一步地缩短它的长度，因为 JS 执行总是会阻塞对 CSS 的抓取、对 CSSOM 和 DOM 的构造。

此外，**浏览器缓存** 是非常有效的，应该在所有的项目中加以使用。它对于这三个优化项都很合适，因为缓存的资源不必先从服务器加载。

CRP 优化的整个主题是相当复杂的，特别是内联、级联和异步加载，它们可能会破坏代码的可重用性。幸运的是，有很多强大的工具，可以为你做好这些优化，这些工具可以被集成到你的构建和部署链里。你的确应该地看看下面的工具……

*   **分析：** [GTmetrix](https://gtmetrix.com/) 用来衡量网页速度，[webpagetest](https://www.webpagetest.org/) 用来分析你的资源，以及 Google 的[PageSpeed Insights](https://developers.google.com/speed/pagespeed/insights/)，为你的网站生成有关如何优化 CRP 的提示。
*   **内联和优化**：[Critical](https://github.com/addyosmani/critical) 非常适合自动将你的明显位置的 CSS 内联并且异步加载其余 CSS，[processhtml](https://github.com/Wildhoney/gulp-processhtml) 连接你的资源和 [PostCSS](https://github.com/postcss/postcss) 进一步优化 CSS。
*   **最小化和压缩：** 我们使用 [tiny png](https://tinypng.com/) 来进行图像压缩，[UglifyJs](https://github.com/mishoo/UglifyJS) 和 [cssmin](https://www.npmjs.com/package/cssmin) 来进行最小化，[Google Closure](https://developers.google.com/closure/) 来进行 JS 优化。

有了这些工具只需很小的工作量，你就可以打造一个前端性能极好的网站。这里是 _Thinks_ 商城第一次访问时的页面速度测试：









![](https://cdn-images-2.medium.com/max/800/1*zRwgmwVleajpoA-Xq4CjhQ.png)



thinks.com 的 Google 网页速度分数



有趣的是，PageSpeed Insights 内部唯一的抱怨是，Google 分析的脚本缓存生命周期太短。所以 Google 基本上在抱怨它自己。









![](https://cdn-images-2.medium.com/max/800/1*ls8OEm_co28ib7ehy189rA.png)



来自加拿大（GTmetrix）的第一次页面加载，服务器托管在法兰克福（Frankfurt）



#### 网络性能

网络延迟是页面加载时间最重要的因素，它也是最难优化的。但在我们进行优化之前，让我们看一下对初始的浏览器请求的划分：













![](https://cdn-images-2.medium.com/max/1200/1*Y3uwr-Q8L-OSH3ubXl-HiA.tiff)









当我们在浏览器中输入 [https://www.thinks.com/](https://www.thinks.com/) 并按下回车键时，浏览器开始使用 **DNS 查找**来识别与域相关联的 IP 地址，这种查找必须对每个单独的域进行。

使用接收到的 IP 地址，浏览器初始化与服务器的 **TCP 连接**。TCP 握手需要 2 次往返（1 次是 [TCP 快速打开](https://en.wikipedia.org/wiki/TCP_Fast_Open)）。使用安全的 **SSL 连接**，TLS 握手需要额外的 2 次往返（1 次是 [TLS False Start](https://blogs.windows.com/msedgedev/2016/06/15/building-a-faster-and-more-secure-web-with-tcp-fast-open-tls-false-start-and-tls-1-3/#BqAGYfpLwoYCtE6i.97) 或 [Session Resumption](https://timtaubert.de/blog/2014/11/the-sad-state-of-server-side-tls-session-resumption-implementations/)）。

在初始连接之后，浏览器发送实际请求并等待数据进入。**第一个字节到达**的时间主要取决于客户端和服务器之间的距离，包括服务器渲染页面所需的时间（包括会话查找、数据库查询和模板渲染等）。

最后一步是在可能的多次往返中**下载资源**（在这种情况下指的是 HTML ）。新连接尤其通常需要很多往返，因为初始拥塞窗口很小。这意味着 TCP 不是从一开始就使用全带宽，而是随着时间的推移而增加带宽（参见 [TCP拥塞控制](https://en.wikipedia.org/wiki/TCP_congestion_control)。下载速度受到慢启动算法的支配，该算法在每次往返的拥塞窗口中将报文段数量加倍，直到丢包发生。在移动网络和 Wifi 网络上丢失数据包因此具有很大的性能影响。

另一件要记住的事是：使用 HTTP/1.1，你只能得到 **6 个并行连接**（如果浏览器仍然遵循原始标准，则连接数为 2）。因此，你最多只能请求 6 个资源并行。

为了对网络性能对于页面速度的重要性有一个直观的认识，你可以查看 [httparchive](http://httparchive.org/interesting.php) ，上面有很多统计数据。例如，网站平均在 100 多个请求中加载大约 2.5 MB的数据。









![](https://cdn-images-2.medium.com/max/800/1*ycpDPIWtye5aFu7Kdtb5Ew.png)



[来源](http://httparchive.org/interesting.php#reqTotal)



所以网站发出了很多小的请求来加载很多资源，但网络带宽一直在增加。物理网络的演进将拯救我们，对吧？嗯，其实并不是……









![](https://cdn-images-2.medium.com/max/800/1*R1NZ69zvARAdY6fkf2ljng.tiff)



来自 [High Performance Browser Networking](https://hpbn.co/)，作者为 Ilya Grigorik



事实证明，将**带宽**增加到 5 Mbps 以上并不真的影响页面加载时间。但减少单个请求的**延迟**会降低网页加载时间。这意味着带宽加倍带来的是相同的加载时间，而减少一半的延迟将给你一半的加载时间。

因此，如果延迟是网络性能的决定因素，我们可以在这上面做些什么呢？

*   **持久连接**是必须有的。没有什么比当你的服务器在每个请求后关闭连接，并且浏览器必须一次又一次地执行握手操作和 TCP 慢启动更糟糕的事情了。
*   尽可能地**避免重定向**，因为它们会大大减慢你的初始网页加载速度。永远链接完整的网址（例如使用 www.thinks.com 而不是 thinks.com）。
*   如果可以的话，请使用 **HTTP/2**。它附带**服务器推送**，能为单个请求传输多个资源；**头压缩**来减小请求和响应的大小；并请求**流水线**和**多路复用**通过单个连接发送任意并行请求。使用服务器推送，你的服务器可以发送你的 html ，紧接着推送网站所需的 CSS 和 JS，而无需等待实际请求。
*   为你的静态资源（CSS，JS，静态图像如 logo）设置显式的**缓存头**。这样，你可以告诉浏览器需要将这些资源缓存多长时间以及何时重新验证。缓存可以节省大量的往返和需要下载的字节。如果没有设置明确的缓存头，浏览器会做 [启发式缓存](http://www.w3.org/Protocols/rfc2616/rfc2616-sec13.html)，这比不缓存好，但远不是最佳。

*   使用**内容分发网络**（CDN）来缓存图像、CSS、JS 和 HTML。这些分布式缓存网络可以显著地减少与用户的距离，从而更快地提供资源。它们还加速了你的初始连接，因为你与附近的 CDN 节点进行 TCP 和 TLS 握手，而这些节点会依次建立热的和持久的后端连接。
*   建议你使用一个小的初始页来创建**单页应用程序**，这个初始网页会异步地加载其它组件。这样，你可以使用可缓存的 HTML 模板，在小请求中加载动态数据，并在导航（navigation）期间只更新页面的各个部分。

总而言之，当涉及到网络性能时，有一些要做的（do） 和不要做的（don't），但限制因素总是往返次数与物理网络延迟的结合。克服这种限制的唯一有效方法是使数据更接近客户端。最先进的网络缓存状态的确如此，但这仅适用于静态资源。

对于 _Thinks_，我们遵循上述准则，使用 [Fastly](https://www.fastly.com/) CDN 和主动的浏览器缓存，甚至对动态数据使用一种新的 [布隆过滤器算法（Bloom Filter algorithm）](https://medium.baqend.com/bringing-web-performance-to-the-next-level-an-overview-of-baqend-be3521bc2faf#.ajhyivndc) 来使得缓存数据保持一致。









![](https://cdn-images-2.medium.com/max/800/1*djg5dkELtzm0wQd_sKmoTg.tiff)



[www.thinks.com](http://www.thinks.com/) 重复加载，来显示浏览器缓存覆盖率



对于重复网页加载的请求，浏览器缓存没有提供的内容（参见上图）包括：对 Google 分析的 API 的两个异步调用，以及从 CDN 处获取的初始 HTML 请求。因此，对于重复的网页加载，页面能够做到立即加载。

#### 后端性能

对于后端性能，我们需要同时考虑延迟和吞吐量。为了实现低延迟，我们需要将服务器的处理时间最小化。为了保持高吞吐量和应对负载尖峰，我们需要采用一种**水平可扩展**的架构。我们不会谈到太多细节，因为设计决策对性能的影响空间是巨大的，这些是需要去寻找的最重要的组件和属性：













![](https://cdn-images-2.medium.com/max/1200/1*lF1D54UVWbHPosMZBoCJSg.tiff)



可扩展的后端技术栈组件：负载均衡器，无状态应用服务器，分布式数据库







首先，你需要**负载均衡**（例如 Amazon ELB 或 DNS 负载均衡）将传入的请求分配给你的一个应用服务器。它还应该实现**自动调节**功能，在需要时生成其他应用服务器，以及**故障转移**功能，以替换损坏的服务器并将请求重新路由到正常服务器。

**应用服务器**应**将共享状态最小化**，从而保持协调最少，并使用**无状态会话处理**来启用自由的负载均衡。此外，服务器应该有**高效**的代码和 IO，使得服务器处理时间最小。

**数据库**需要承受负载尖峰，并尽可能减少处理时间。同时，它们需要具有足够的表达性，以根据需要建模和查询数据。有大量的可扩展数据库（尤其是 NoSQL），每个都有自己的 trade-off。详细信息请参考我们关于该主题的调查和决策指南：

[**NoSQL 数据库：一份调查和决策指南**  
与我们在汉堡大学的同事一起，我们是：Felix Gessert, Wolfram Wingerath, Steffen…medium.baqend.com](https://medium.baqend.com/nosql-databases-a-survey-and-decision-guidance-ea7823a822d "https://medium.baqend.com/nosql-databases-a-survey-and-decision-guidance-ea7823a822d")

_Thinks_ 网上商城搭建在 [Baqend](http://www.baqend.com/) 上，使用了如下的后端技术栈：









![](https://cdn-images-2.medium.com/max/800/1*C7yp3ODTiIyCv6ZxtZVQCg.tiff)



Baqend的后端技术栈：MongoDB 作为主数据库，无状态应用服务器，HTTP 缓存层次结构，REST 和 web 前端的 JS SDK



用于 _Thinks_ 的主数据库是 **MongoDB**。为了维护我们将要到期的布隆过滤器（用于浏览器缓存），我们使用 **Redis** ，因为它的高写入吞吐量。无状态应用程服务器（[**Orestes Servers**](http://orestes.info/assets/files/Paper.pdf)）为后端功能提供接口（文件托管，数据存储，实时查询，推送通知，访问控制等），并处理动态数据的缓存一致性。它们从 **CDN** 拿到请求，CDN 也充当负载均衡器。网站前端使用基于 **REST API** 的 **JS SDK** 来访问后端，后端自动利用完整的 **HTTP 缓存层次结构**来让请求加速并保持缓存数据时刻最新。

#### 负载测试

为了在高负载下测试 _Thinks_ 网上商城，我们在法兰克福的 t2.medium AWS 实例上使用 2 个应用服务器来进行负载测试。MongoDB 在两个 t2.large 实例上运行。使用 [JMeter](http://jmeter.apache.org/) 构建负载测试并在 [IBM soft layer](http://www.softlayer.com/) 上的 20 个机器上运行，以模拟在 **15分钟内**，**200,000 个用户**同时访问和浏览网站。20％ 的用户（40,000）被配置为执行额外的付款流程。













![](https://cdn-images-2.medium.com/max/1200/1*PTn0h56pvC5HYEAaEPnI1A.png)



网上商城的负载测试设置







我们在支付实现中发现了一些瓶颈，例如，我们必须从库存的积极更新（使用 [findAndModify](https://docs.mongodb.com/manual/reference/method/db.collection.findAndModify/)实现）切换到 MongoDB 的部分更新操作（[_inc_](https://docs.mongodb.com/manual/reference/operator/update/inc/)）。**但是在这之后，服务器处理的负载只是精细地达到了平均请求延迟 5 ms**。





![](https://cdn-images-2.medium.com/max/800/1*SrfTDYzeTKh5-T26I2Nakw.tiff)



JMeter 在负载测试期间输出：在 12 分钟内有 680 万个请求，平均延迟 5 ms



所有的负载测试组合生成了大约 **1000 万个请求**，传输了 **460 GB的数据**，伴随着 **99.8％** 的 CDN **缓存命中率**。













![](https://cdn-images-2.medium.com/max/1200/1*buvg1l0A2FrzqR8dbgQ5cQ.png)



负载测试后的仪表板概述







### 总结

总之，良好的用户体验取决于三个支柱：前端，网络和后端的性能。













![](https://cdn-images-2.medium.com/max/1200/1*KaPvIFl16OLU76KxJMR1WQ.tiff)









**前端性能**是我们认为最容易实现的，因为已经有很多工具和一些容易遵循的最佳实践。但仍然有很多网站不遵循这些最佳实践，完全没有优化过它们的前端。

**网络性能**对于页面加载时间来说，是最重要的因素，也是最难优化的。缓存和 CDN 是最有效的优化方法，但即使对于静态内容也要付出相当大的努力。

**后端性能**取决于单服务器性能和跨机器去分发工作的能力。水平可扩展性特别难以实现，必须从一开始就考虑。许多项目将可扩展性和性能作为事后处理，然而在它们的业务增长时会陷入大麻烦。


### 文献和工具建议









![](https://cdn-images-2.medium.com/max/800/1*Fu5eAxBQORO1em86kuJBgA.tiff)





有很多关于 web 性能和可扩展系统设计的书：由 Ilya Grigorik 所写的 [高性能浏览器网络](https://hpbn.co/) 包含了几乎所有你需要了解的网络和浏览器性能知识，并且目前不断更新的版本可以免费在线阅读哦！Martin Kleppmann 写的 [设计数据密集型应用](http://dataintensive.net/) 仍处于前期发布状态，但已经是其领域最好的书之一，它涵盖了可扩展后端系统背后的大部分基础知识，并拥有相当多的细节。[设计性能](http://designingforperformance.com/) 由Lara Callender Hogan 写成，围绕着构建快速的、具有良好的用户体验的网站，涵盖了很多最佳实践。









![](https://cdn-images-2.medium.com/max/800/1*rNqMUe5C9Z2KvCjqQJRNrA.tiff)





还有一些很棒的在线指南、教程和工具可以考虑：从初学者友好的 Udacity 课程 [网站性能优化](https://www.udacity.com/course/website-performance-optimization--ud884)、Google 的 [开发者性能指南](https://developers.google.com/web/fundamentals/performance/?hl=en) 到类似于 [Google PageSpeed Insights](https://developers.google.com/web/fundamentals/performance/?hl=en)、[GTmetrix](https://gtmetrix.com/) 和 [WebPageTest](https://www.webpagetest.org/) 这样的优化工具。

### 最新的 Web 性能开发

**移动页面加速**

Google 正在通过诸如 [PageSpeed Insights](https://developers.google.com/speed/pagespe%E2%80%A6)、[开发人员指南](https://developers.google.com/web/fundamentals/performance/) 等网站性能项目来提高大家对于网站性能的意识，并将网页速度作为其 [网页排名](https://webmasters.googleblog.com/2010/04/using-site-speed-in-web-search-ranking.html) 的主要因素。

在 Google 搜索中用来提高网页速度、增强用户体验的最新概念是 [移动网页加速（**AMP**）](https://www.ampproject.org/)。其目的是让新闻文章、产品页面和其它搜索内容立即从 Google 搜索加载。为此，这些页面必须构建为 AMP。









![](https://cdn-images-2.medium.com/max/800/1*dFufupcLXGvhJdeqhntcsA.png)



一个 AMP 页面的示例



AMP 主要做两件事：

1.  构建为 AMP 的网站使用精简版本的 HTML，并使用 JS 加载器来快速渲染，并异步加载尽可能多的资源。

2.  Google 将网站缓存在 Google CDN 中，并通过 HTTP/2 分发。

第一件事从本质上意味着 AMP 以一种方式限制了你的 HTML、JS 和 CSS，这种方式构建的网页有一个优化的关键呈现路径，可以很容易地被 Google 爬取。 AMP 强制 [几个限制](https://www.ampproject.org/docs/reference/spec)，例如所有 CSS 必须内联，所有 JS 必须是异步的，页面上的所有内容必须具有静态大小（以防止重绘）。 虽然你可以通过坚持之前的 web 性能最佳实践，在没有这些限制的情况下，实现相同的结果，但 AMP 可能是很好的 trade-off ，能够为非常简单的网站提供帮助。

第二件事意味着，Google 抓取你的网站，然后将其缓存在 Google CDN 中，以便快速分发。网站内容会在爬虫重新索引你的网站后更新。CDN 还遵循服务器设置的静态 TTL，但至少执行 [微缓存](https://developers.google.com/amp/cache/overview#google-amp-cache-updates)：资源至少在一分钟内被视为最新的，并在用户请求进入时在后台更新。因此 AMP 最适用于内容大多是静态的用户案例。这种适用于人为编辑修改的新闻网站或者其他出版物的情况。

#### 渐进式 web 应用（Progressive Web Apps）

Google 的另一种做法是 [渐进式 web 应用](https://developers.google.com/web/fundamentals/getting-started/codelabs/your-first-pwapp/)（**PWA**）。其想法是在浏览器中使用 [服务工作者（service worker）](https://developers.google.com/web/fundamentals/getting-started/primers/service-workers) 来缓存网站的静态部分。因此，这些部分对于重复视图会立即加载，并可离线使用。动态部分仍从服务器端加载。

_app shell_（单页应用程序逻辑）可以在后台重新验证。如果标识了对应用 shell 的更新，则会提示用户，要求他更新页面。例如，[Gmail 收件箱](https://www.google.de/inbox/) 就实现了这个。

但是，写出缓存静态资源并进行重新验证的服务工作者（service worker）代码，对于每个网站来说，都需要付出相当大的努力。此外，只有 Chrome 和 Firefox 充分地支持了服务工作者（service worker）。

### 缓存动态内容

所有缓存方法遇到的问题是它们不能处理动态内容。这只是由于 HTTP 缓存的工作机制导致的。有两种类型的缓存：**基于失效的**缓存（如转发代理缓存和 CDN）和**基于到期的**缓存（如 ISP 缓存、机构代理和**浏览器缓存**）。基于失效的缓存可以从服务器端主动失效，基于到期的高速缓存只能从客户端重新验证。

使用基于到期的缓存时，棘手的事情是，你必须在首次从服务器拿到数据时指定缓存生命周期（TTL）。之后，你没有任何机会将缓存数据删除。它将由浏览器缓存提供到 TTL 到期的时刻。对于静态资源，这不是一件复杂的事情，因为它们通常只会在你部署 web 应用程序的新版本时发生变化。因此，你可以使用 [gulp-rev-all](https://github.com/smysnk/gulp-rev-all) 和 [grunt-filerev](https://github.com/yeoman/grunt-filerev) 等很酷的工具）对 assets 进行散列。

但是，但是你该如何处理运行时的应用数据加载和修改呢？更改用户个人资料、更新帖子或添加新评论似乎不可能与浏览器缓存结合使用，因为你无法预估此类更新将来何时会发生。因此，缓存只能被禁用或使用非常小的 TTL。













![](https://cdn-images-2.medium.com/max/1200/0*K1ZJfaJ6zgz6eEk_.png)



由另一个客户端更新时，缓存动态数据如何过时的示例







#### Baqend 的 Cache-Sketch 方法

在 [Baqend](http://www.baqend.com/)，我们已经研究并开发了一种方法，在实际获取之前，检查客户端中 URL 的陈旧度。在每个用户会话开始时，我们获取一个非常小的数据结构，称为布隆过滤器（Bloom Filter），它是所有过时资源集合的高度压缩表示。通过查看布隆过滤器，客户端可以检查资源是否过时（包含在布隆过滤器中）或者是否是全新的。对于潜在的过时资源，我们绕过浏览器缓存并从 CDN 获取内容。在其他的所有情况下，我们直接用浏览器缓存提供内容。使用浏览器缓存可以节省网络流量和带宽，并且是**很快的**。

此外，我们确保 CDN（以及其它基于失效的缓存，如 Varnish）始终包含最新的数据，只要它们过时就立即清除资源。













![](https://cdn-images-2.medium.com/max/1200/0*lpjUnI1olugLyyto.png)



Baqend 如何确保缓存动态数据的新鲜度示例







[布隆过滤器（Bloom filter）](http://de.slideshare.net/felixgessert/bloom-filters-for-web-caching-lightning-talk) 是具有可调误报率的概率数据结构，这意味着集合可以用来表示对从未添加的对象的遏制，但永远不会删除实际条目。换句话说，我们可能偶尔会重新验证新资源，但是**我们永远不会提供过期数据**。注意，误报率非常低，这使得我们能够让集合非常小。例如，我们只需要 11 Kbyte 来存储 20,000 个不同的更新。

Baqend 在服务器端有很多流处理（查询匹配检测）、机器学习（最佳 TTL 估计）和分布式协调（可扩展的布隆过滤器维护）的工作。如果你对这些细节感兴趣，看看这篇 [文章](http://www.baqend.com/paper/btw-cache.pdf) 或 [这些幻灯片](http://de.slideshare.net/felixgessert/talk-cache-sketches-using-bloom-filters-and-web-caching-against-slow-load-times) 来深入研究。

#### 性能收益

这一切都归结为这一点。

> 使用 Baqend 的缓存基础设施可以使哪种页面速度得到提高？

为了展示使用 Baqend 的好处，我们在后端即服务（BaaS）领域中的每个领先竞争对手上构建了一个非常简单的新闻应用，并观测了来自世界各地不同位置的页面加载时间。如下所示，Baqend 持续加载低于 1 秒，比平均速度快 6.8 倍。即使当所有客户端来自服务器所在的同一位置时，由于有浏览器缓存，Baqend 也是 150％ 倍速度。













![](https://cdn-images-2.medium.com/max/1200/1*wT5diC6Pcd95wUSVroYviw.tiff)



简单新闻应用的平均加载时间比较







我们将此比较作为一个 [动手的 web 应用](http://s.codepen.io/baqend/debug/3010e4601789ea4d77673140d8e06245#) 来比较 BaaS 竞争。









![](https://cdn-images-2.medium.com/max/800/1*X2Gc9KCtG_33mRe5Q9ayJw.tiff)



[动手比较](http://s.codepen.io/baqend/debug/3010e4601789ea4d77673140d8e06245) 的截图



但这当然是一个测试场景，而不是一个具有真正用户的 web 应用。 所以让我们回到 _Thinks_ 网上商城来看一个真实世界的例子。

### Thinks 网上商城——所有的事实

当 DHDL（"Shark Tank"的德国版）在 9 月 6 日播出时，有 270 万观众，我们坐在电视和我们的 Google 分析屏幕前，为 _Thinks_ 创始人提出他们的产品而激动。

从他们开始演示起，网上商的并发用户数量迅速增加到大约 10,000，但真正的巅峰发生在广告休息时，当时突然有超过45,000 的并发用户来参观该店购买 Towell+：









![](https://cdn-images-2.medium.com/max/800/1*sCsJOCw-7clmfIbyYRwUrA.gif)



Google 分析观测在商业广告时间之前开始。



_Thinks_ 在电视播放的 30 分钟里，我们得到了 **340** 万的请求，**300,000** 位游客，高达 **50,000** 位的并发访问游客和高达每秒 20,000 个请求，所有这一切实现了在 CDN 级别的 **98.5％ 的缓存命中率**，和平均为 **3％ 的服务器 CPU 负载**

因此，**页面加载时间**为**低于 1 秒**，整个时间实现了 **7.8％ 的极大的**转化率。

如果我们看看在同一集 DHDL 中展示的其他商城，我们会看到其中四个 **完全崩溃了**，剩下的商城只利用了极少的性能优化。









![](https://cdn-images-2.medium.com/max/800/1*3VLcWgaWIiFlJdaqy27gCg.png)



可用性概述和商城的 Google 页面速度得分，在 DHDL 上，于 9 月 6 日展示。



### 总结

我们已经看到了在设计快速和可扩展的网站时需要克服的瓶颈：我们必须掌握**关键呈现路径**，理解网络限制、**缓存**的重要性和**具有水平可扩展性**的后端设计。

我们已经看到了很多用来解决单个问题的工具，以及移动加速页面（**AMP**）和渐进式 web 应用（**PWA**），这些采取了更全面的做法。但是，**缓存动态数据**的问题仍然存在。

**Baqend** 的做法是减少 web 开发，将构建主要放在前端，通过 JS SDK 使用 Baqend 完全托管的云服务上的后端功能，包括数据和文件存储、（实时）查询、推送通知、用户管理和 OAuth 以及访问控制。该平台通过使用完整的 HTTP 缓存层次结构自动加速所有请求，并确保可用性和可扩展性。









![](https://cdn-images-2.medium.com/max/600/1*lDR0ZIX0ACdKwYMzEqyAKg.png)





#### 我们对于 Baqend 的愿景是一个不需要加载时间的网站，并且我们想要给你到达这个目标的工具。

继续前往免费试用 [www.baqend.com](http://www.baqend.com/).











* * *







不想错过我们关于网络性能的下一篇文章？通过加入我们的 [newsletter](http://www.baqend.com/#newsletter) 方便地将其传送到你的收件箱。
