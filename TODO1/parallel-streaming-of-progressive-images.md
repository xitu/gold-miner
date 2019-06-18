> * 原文地址：[Parallel streaming of progressive images](https://blog.cloudflare.com/parallel-streaming-of-progressive-images/)
> * 原文作者：[Andrew Galloni](https://blog.cloudflare.com/author/andrew-galloni/), [Kornel Lesiński.](https://blog.cloudflare.com/author/kornel/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/parallel-streaming-of-progressive-images.md](https://github.com/xitu/gold-miner/blob/master/TODO1/parallel-streaming-of-progressive-images.md)
> * 译者：[twang1727](https://github.com/twang1727)
> * 校对者：[suhanyujie](https://github.com/suhanyujie)

# 利用并行流渐进加载图片

![](https://blog.cloudflare.com/content/images/2019/05/880BAE29-39B3-4733-96DA-735FE76443D5.png)

渐进式图片渲染和 HTTP/2 多路复用技术已经问世一段时间，但是现在我们将两者以新的方式结合从而发挥出更大的力量。利用 Cloudflare 的渐进式流，**图片加载可以缩短一半时间，而浏览器可以更快开始渲染页面**。

- 视频：https://crates.rs/cf-test/comparison.mp4

建立 HTTP/1.1 连接的服务器对向客户端发送资源的顺序没有决定权；响应作为无法分割的整体，准确的按照浏览器端请求的顺序来发送。HTTP/2 在这方面的改进在于增加了多路复用和优先，使服务器可以决定选择发送什么数据和发送的时间。我们利用这些新的 HTTP/2 功能，通过优先发送图片数据中最重要的片段，来提升渐进式图片的感知加载速度。

> 这个功能与所有的主流浏览器兼容，并且不需要页面标记做任何更改，很容易使用。参加 [Beta](https://forms.gle/G2iHC4qWB8XHN3Ly6) 注册，让你的网站也能使用这一功能吧！

### 什么是渐进式图片渲染？

普通的图片加载严格按照从上到下的顺序。如果浏览器只收到了图片文件的一半，那么它只会显示图片的上半部分。渐进式图片的内容的排列不是按从上到下的顺序，而是按细节级别从低到高的排序。即使浏览器只收到一部分数据，它也可以显示整张图片，只是清晰度有损失。随着更多数据接收成功，图片会变的更清晰。

![](https://blog.cloudflare.com/content/images/2019/05/image6.jpg)

这一功能对 JPEG 格式很有用，因为显示图片预览只需 10-15% 的数据，而当 50% 的数据加载之后，图片看起来几乎和整个文件都到达时一样清晰了。渐进式 JPEG 图片的数据和普通图片一致，只是以一种更易用的方式排序，所以渐进式渲染并不增加文件的大小。这是可以实现的，因为 JPEG 并不以像素形式存储图片。它用频率系数来代表图像，就像是一系列预定义的样式，以任意顺序混合都能可以重新构建原图想。JPEG 的内部构造十分有趣，你可以从我的 [permormance.now() 会议演讲](https://www.youtube.com/watch?v=jTXhYj2aCDU) 了解更多。

最终结果是，图像用了一半的时间就看起来几乎与加载完毕没区别了，而且不花钱。页面视觉效果完整，而且可以更快投入使用。剩下的图像数据会很快到达，并在浏览者注意到任何缺省之前将图像升级成清晰度完整的质量。

### HTTP/2 渐进式流

但是这有个问题。网站会有多于一张图片（有时甚至是几百张图片）。当服务器以原始的方式一张一张传输图片时，渐进式渲染帮不上什么忙，因为总的来讲图片仍是按顺序加载：

![](https://blog.cloudflare.com/content/images/2019/05/image5.gif)

收到一半图片的所有数据（但没收到剩下一半图片的任何数据）看起来不如收到所有图片的一半数据。

而且还有另外一个问题：当浏览器未知图像大小的时候，它用占位符布局，再在每张图加载的时候重布局。这会让页面在加载过程中跳动，这样做很唐突，让用户感到分神、厌烦。

我们的渐进式流新功能对这种情况大幅改进：我们可以一次性并行发送所有图片。这样浏览器可以尽快的得到所有图片的尺寸信息，进而可以无需等待大量数据就绘制所有图片的预览，而且大图片也不会延迟样式、脚本和其他重要资源的加载。

并行流渐进式加载图片的概念和 HTTP/2 本身一样古老，但是它需要网络服务器底层部件的特殊处理，所以目前为止这一技术还没被大规模应用。

当我们改进 [HTTP/2 优先级](https://blog.cloudflare.com/better-http-2-prioritization-for-a-faster-web)时，我们意识到它也可以被用来改进这一功能。图片文件作为整体时既不是高优先级也不是低优先级。每个文件优先级不同，动态调整优先级给予我们所需的行为：

* 含有图片大小的图片头优先级极高，因为浏览器需要尽早知道大小来布局页面。图片头很小，而且早于其他数据发送它没有坏处。

![Known image sizes make layout stable](https://blog.cloudflare.com/content/images/2019/05/image7.jpg)

* 展示图片预览所需的最小量图像数据具有中等优先级（我们得为尽早完成未加载图片预留空间，但是也要为脚本，字体和其他资源留下足够带宽）。

![Half of the data looks good enough](/content/images/2019/05/secondhalf.png)

* 剩下的图像数据是低优先级的。浏览器可以在无关紧要的时候接受它来提高图片质量，因为网页已经完全可用了。

* 要了解在每一阶段发送的准确数据量，你需要理解图像文件的结构，但是让网络服务器来解析图像响应，并且把基于格式的行为在协议层级上硬编码，看起来就会很怪异。而把这个问题当作优先级的动态改变来处理，我们就可以优雅的将底层网络编码与图像格式信息分割开来。我们可以用 Worker 或者是线下的图像处理工具来分析图片，并指导服务器相应的改变 HTTP/2 优先级。

图片并行流的好处在于它不增加任何开销。我们仍然发送同样的数据，相同量的数据，我们只是以一种更聪明的方式来发送它。这个技巧利用了现存网络标准，所以在所有浏览器上都兼容。

### 瀑布图

以下是从 [WebPageTest](https://webpagetest.org) 得到的瀑布图，展示了普通 HTTP/2 响应和渐进式流的比较。两种情况中的文件一致，传输的数据量一致，总的页面加载时间也一致（在测量误差内）。图中，蓝色片段表示数据正在传输，绿色表示请求等待。

![](https://blog.cloudflare.com/content/images/2019/05/image8.png)

第一张图展示了图片依次加载的典型服务器行为。图看起来整齐，但是实际的页面加载体验并不好——最后一张图直到将近最后才开始加载。

第二张图展示的是图片并行加载。图上蓝色的垂直线表示的是早期的图片头发送，以及之后渐进式渲染的几个阶段。你可以看出所有图片的数据的有用部分都到达的更早。你可能还会注意到有一张图片是一次性发送的，而不是像其他图片一样分批完成的。那是因为在 TCP/IP 连接建立之初我们还不知道连接的真实速度，我们只好牺牲一些优先处理的机会来最大化连接速度。

### 与其他方法相比的指标

有一些其它的技术也用来更快的提供图片预览，比如低质量图片占位（LQIP），但是它们是有一些缺点的。他们为占位符增加了不必要的数据，而且通常会干扰浏览器的预加载扫描，并且延迟完整图片的加载，因为将预览更替到完整图片依赖于 JavaScript。

* 我们的方法不增加请求，也不增加更多数据。页面总加载时间不会延迟。
* 我们的方法不需要 JavaScript。它利用了浏览器原生的功能。
* 我们的方法不需要改变页面标记，所以全站部署是安全并简单的。

用户体验的改进可以在例如 **SpeedIndex**，以及视觉上的完成时间等性能指标上表现出来。请注意，普通的图片下载的过程看起来是线性的，但是渐进流使它可以很快的进行到基本完成:

![](https://blog.cloudflare.com/content/images/2019/05/image1-5.png)

![](https://blog.cloudflare.com/content/images/2019/05/image4.png)

### 最大限度地利用渐进式渲染

避免让 JavaScript 损坏效果。隐藏图片直至 `onload` 事件才显示（利用淡入等）的脚本会使渐进式渲染无效。渐进式渲染用传统的 `<img>` 元素效果最好。

### 只有 JPEG 可以吗？

我们的应用是不依赖于格式的，但是渐进流只对某些文件类型有用。比如说，对脚本或样式应用它是不可行的：这些资源只有未渲染或全部渲染两个状态。

优先发送图片头（包括图片大小）对所有格式都适用。

渐进式渲染的益处对 JPEG（所有浏览器都支持）和 JPEG 2000（Safari 支持）是得天独厚的。GIF 和 PNG 有交错模式，但是这些模式和糟糕的压缩相伴生。WebP 根本不支持渐进式渲染。这就造成了这样一种两难：WebP 通常比同等质量的 JPEG 小 20% 到 30%，但是渐进式 JPEG **看起来** 加载得快 50%。有些下一代图像格式对渐进式渲染的支持优于 JPEG，比 WebP 压缩更优，但是浏览器还不支持这些格式。同时你们可以通过修改 Cloudflare 面板的 Polish 设置，在节省带宽的 WebP 和可感知性能更好的渐进式 JPEG 之间选择。

### 试验用的自定义头

我们也支持自定义 HTTP 头来进行试验，来优化网站的其他资源的流播。比如，你可以让我们的服务器优先发送动画 GIF 的第一帧，而剩余的帧延后。或者你可以在 HTML 文档 `<body>` 加载前优先加载 `<head>` 标签里提到的资源。  

自定义头只能在 Worker 中设置。句法是用逗号隔开的包括优先级和并发选项的文件位置清单。优先级和并发选项与前一篇博客提到的整文件 cf-priority 头一样。

```http
cf-priority-change: <offset in bytes>:<priority>/<concurrency>, ...
```

比如，对于渐进式 JPEG 我们用这个（Worker 中的 JavaScript 片段）：

```javascript
let headers = new Headers(response.headers);
headers.set("cf-priority", "30/0");
headers.set("cf-priority-change", "512:20/1, 15000:10/n");
return new Response(response.body, {headers});
```

它会告诉服务器，当一开始发送最先的 512 字节时用 30 作为优先级。然后切换到优先级 20 以及一定程度的并发（`/1`），最后当发送文件的 15000 字节之后，切换到低优先级高并发（`/n`）把文件的剩余部分发送完。 

我们试着分割 HTTP/2 帧来匹配标头中的指定偏移量，从而尽快改变发送的优先级。但是，优先级并不保证不同流上的数据会被严格按照指示复用，因为服务器只是在多路流同时需要发送数据时才应用优先级排序。如果某些请求从上游浏览器或缓存到达的更早，服务器可能会立即发送它们，而不是等待其他请求。

### 试一试！

你可以用我们的 Polish 工具来把你的图片转化成渐进式 JPEG。加入 [beta](https://forms.gle/G2iHC4qWB8XHN3Ly6) 来优雅地使用并行流。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
