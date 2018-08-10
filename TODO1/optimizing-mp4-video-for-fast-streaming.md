> * 原文地址：[Optimizing MP4 Video for Fast Streaming](https://rigor.com/blog/2016/01/optimizing-mp4-video-for-fast-streaming)
> * 原文作者：[BILLY HOFFMAN](https://rigor.com/blog/2016/01/optimizing-mp4-video-for-fast-streaming)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/optimizing-mp4-video-for-fast-streaming.md](https://github.com/xitu/gold-miner/blob/master/TODO1/optimizing-mp4-video-for-fast-streaming.md)
> * 译者：[HaoChuan9421](https://github.com/HaoChuan9421)
> * 校对者：[coolseaman](https://github.com/coolseaman)

# 优化 MP4 视频以获得更快的流传输速度

随着 [Flash 的衰落](http://thenextweb.com/apps/2015/09/01/adobe-flash-just-took-another-step-towards-death-thanks-to-google/) 和 [移动设备的爆炸式增长](http://searchengineland.com/its-official-google-says-more-searches-now-on-mobile-than-on-desktop-220369)，越来越多的内容正在以 HTML5 视频的方式发布。你可以通过 [用 HTML5 视频片段代替 GIF 动画](http://rigor.com/blog/2015/12/optimizing-animated-gifs-with-html5-video) 的方式来优化你的网站速度。然而，视频文件本身就有大量可优化的地方，你可以借此提升它们的性能。

其中最重要的一点是视频文件必须经过适当优化才能作为 HTML5 视频在线播放。如果没有这种优化，视频可能会延迟数百毫秒，而只是试图播放视频的访问者也可能会浪费兆字节的带宽。在这篇文章中，我将向你展示如何优化视频文件以获得更快的流传输速度。

## MP4 流媒体是如何工作的

在我们 [上一篇文章](http://rigor.com/blog/2015/12/optimizing-animated-gifs-with-html5-video) 的讨论中，HTML5 视频是一种跨浏览器观看视频的方式，不需要类似 Flash 的插件。截止到 2016 年， [存储在 MP4 容器文件中的 H.264 编码视频](https://en.wikipedia.org/wiki/MPEG-4_Part_14) (下文将简称为 MP4 视频) 已成为所有在线 HTML5 视频的标准格式。所以当我们讨论如何优化 HTML5 视频，其实我们是在讨论如何优化 MP4 视频以获取更快的播放。而我们优化的方式与 MP4 文件的结构以及流媒体传输的工作原理息息相关。

MP4 文件由叫做 [原子](http://www.adobe.com/devnet/video/articles/mp4_movie_atom.html) 的数据块组成。这些原子用以存储字幕和章节等内容， 当然也包括视频和音频等显而易见的数据。而视频和音频原子的元数据，以及有关如何播放视频的信息，如尺寸和每秒的帧数，则存储在叫做 `moov` 的特殊原子中。你可以认为 `moov` 原子是某种意义上的 MP4 文件 _目录_ 。

当你播放视频时，程序会查找 MP4 文件，定位 `moov` 原子的位置，然后借此去查找视频和音频的起始位置来开始播放。遗憾的是，原子可以以任意顺序排列，所以程序一开始并不知道 `moov` 原子在哪里。如果你已经拥有整个视频文件，查找 `moov` 原子是完全没问题的。但是当你暂时没有整个文件的时候，比如当你在 _流传输_ HTML5 视频时，就需要另辟蹊径了。这才是流媒体的重点！你无需先下载整个视频即可开始观看。

当流传输时，你的浏览器请求视频资源并开始接收文件的开始部分。程序查找 `moov` 原子是否在开始的部分。如果 `moov` 原子不在开始位置，它必须下载整个文件才能尝试找到 `moov`，或者浏览器可以从最末端的数据开始下载视频文件的不同小片段，以试图找到 `moov`原子。

所有这些试图找到 `moov` 的行为浪费了时间和带宽。遗憾的是，在找到 `moov` 之前，视频是无法播放的。 我们可以在下面的屏幕截图中看到浏览器的瀑布图，该浏览器试图使用 HTML5 视频来流传输未优化的 MP4 文件：

![mp4-no-moov](http://rigor.com/wp-content/uploads/2016/01/mp4-no-moov.png)

你可以看到浏览器在播放视频之前发起了三次请求。 在第一次请求中，浏览器通过 [HTTP range request](https://en.wikipedia.org/wiki/Byte_serving) 下载了 552 KB 的第一部分视频。 我们可以通过 HTTP 状态码 `206 Partial Content` 以及查看响应头的详细信息来发现这些。然而，`moov` 原子并未包含在内，所以浏览器无法开始视频播放。接下来，浏览器通过 HTTP range request 获取了后面的 21 KB 视频文件。它包含 `moov` 原子，告诉浏览器视频和音频流的开始位置。最后，浏览器发起了第三个也是最后一个 HTTP range request，以获取音频/视频数据并可以开始播放视频。这导致浪费了超过半兆字节的带宽以及 210 ms 的播放延迟！仅仅是因为浏览器找不到 `moov` 原子。

如果你的服务器没有配置 HTTP range request，情况甚至会更糟：浏览器无法跳过查找 `moov` 这一步，以至于**不得不下载整个文件**。这也是你需要 [支持部分下载来优化你的网站](https://zoompf.com/blog/2010/03/performance-tip-for-http-downloads) 的另一个原因。

为 HTML5 流传输准备 MP4 视频的理想方法是（重新）组织文件，以便 `moov `处于最开始的位置。这样一来，就可以避免浏览器下载整个视频或者为了尝试找到 `moov` 而浪费时间发起额外的请求。具有流优化视频的网站的瀑布图如下:

![mp4-fast-start](http://rigor.com/wp-content/uploads/2016/01/mp4-fast-start.png)

开始位置包含 `moov` 的文件，视频会下载播放得更快，带来的结果是更好的用户体验。

## 如何优化 MP4 视频以获得更快的流传输速度

我们已经知道为了优化视频的 HTML5 流传输，你需要重新组织 MP4 原子，以便 `moov` 原子处于开始位置。 那么我们如何做呢? 大部分视频编码软件都有一个 _“针对网页优化”_ 或 _“针对流传输优化”_ 的选项来做这件事。当你创建视频时，你需要查看你视频编码设置以确认它是优化的。例如，在下面的屏幕截图中，我们可以看到开源视频编码工具 [Handbrake](https://handbrake.fr/) 的 _“Web Optimized”_ 选项，用来将 `moov` 原子放在开始位置:

![handbrake](http://rigor.com/wp-content/uploads/2016/01/handbrake.png)

如果你从原始资源视频创建 MP4 文件，这是一个可行的解决方案，但是如果你已经有一个 MP4 文件了呢?

你可以重组已存在的视频来优化它在网页流传输的表现。例如，开源的命令行视频编码工具 [FFMpeg](https://www.ffmpeg.org/) 就可以重组 MP4 文件的结构来让 `moov` 原子处于开始位置。不同于初始编码视频那样非常耗时和占用 CPU ，重组文件很容易操作。而且，他不会对原始视频质量造成任何影响。 以下是用 ffmpeg 来优化一个叫做 _input.mp4_ 的视频文件流传输的例子，导出的视频叫做 _output.mp4_ 。

```
ffmpeg -i input.mp4 -movflags faststart -acodec copy -vcodec copy output.mp4
```

`-movflags faststart` 参数告诉 ffmpeg 把 MP4 视频的原子们重新排序以使得 `moov` 位于开始位置。我们同样指示 ffmpeg 拷贝视频和音频数据而不是把他们重新编码，所以没有任何改变。

为了 Rigor 网站的顾客，我们向 Rigor 优化添加了新的检测工具。[我们的性能分析和优化产品](https://zoompf.com/features)，可以检测还没有针对 HTM5 视频流传输进行优化的 MP4 文件。如果你只是想快速检测自己网站，你可以用 [我们免费的性能报告](http://rigor.com/free-performance-report)。

## 总结

不管你是将 GIF 动画转化为 MP4 视频片段，还是已经有一堆 MP4 视频，如果你优化文件结构，你都可以使得这些视频加载并开始播放de更快。通过重排原子让 `moov` 原子处于开始位置，使得浏览器跳过发送额外的 HTTP range request ，避免尝试定位 `moov` 原子。这允许浏览器立即开始流视频传输。你通常可以在最初创建视频时配置一个选项，以优化流传输。 如果你已有文件，则可以使用 ffmpeg 之类的程序对文件进行重排，而不更改其内容。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
