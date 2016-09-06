# 响应式设计的真正挑战：RSS
> * 原文地址：[The real responsive design challenge? RSS.](https://begriffs.com/posts/2016-05-28-rss-responsive-design.html)
* 原文作者：[Joe "begriffs" Nelson](https://github.com/begriffs)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[cdpath](https://github.com/cdpath)
* 校对者：


web 世界丰富多彩，去看看服务器日志吧。那里充斥着爬虫机器人，非主流的移动设备以及各种屏幕尺寸和操作系统的用户代理。你很容易就会用自己习惯的方式使用 web 却忽略了大多数普通用户的体验。

比如我发现网站流量有一部分来自订阅了 Atom feed 的阅读器。处于好奇，我决定看看用 Atom 阅读器看我的文章是什么样子。结果并不怎么好看。feed 的问题揭示了更深层次的可用性问题，而其解决方案还可以应用到更通用的 web 设计上。

在继续读下去之前你可能想要亲自试一试。如果你维护着 RSS 或 Atom feed 服务，可以放到各种阅读器中看看是什么样子的。而访问过我网站的阅读器有：Newsbeuter, Newsflow, Sismics reader, Tiny Tiny RSS, Feedly, Feedbin, Akregator, Feed Wrangler, NewsBlur, FeedHQ, Feed Spot, Livedoor reader, Miniflux, Liferea, Readerrr 以及 Mozilla reader。

你首先会注意到这些阅读器会删除 Javascript 和 CSS 但是会保留图片。有时候它们会使用自定义的 CSS，还有时候它们干脆不用 CSS。通过控制 CSS 阅读器软件可以提供流式排版以及各种可选的主题，比如深夜模式。你可能很久没有留意自己网站不用 CSS 时的样子了，看过之后你可能觉得有必要去重新练习一下标记语言。

下面几个建议可以让你的网站对大家更友好。

*   Font-Awesome 在需要平稳退化的时候并没有那么出色。可以转而使用没有 CSS 也能完美缩放的 SVG 图像。实际上用 `img` 标签加载 SVG 的时候可以加上 `alt` 属性，可以提供给无图形和无视觉的用户代理。使用内联 (inline) 高度和宽度这样 SVG 在没有 CSS 的情况下也可以保证正确的大小。[这里](https://github.com/encharm/Font-Awesome-SVG-PNG)有替换 Font-Awesome 成 SVG 的详细说明。
*   手动为多媒体标签添加临时替代方案。比如我的博文中的 `<video>` 标签在 feed 阅读器上看起来非常糟糕。一些阅读器干脆把它删掉了！还有些阅读器把视频框的尺寸搞得非常巨大却没法播放。在没法播放视频的场景下，最好的解决方案是给出视频的链接，方便使用其他程序下载或播放。所以我会把视频文件的链接放到 `<noscript>` 标签里。我还删掉了标记语言 (HTML) 中的 `<video>` 标签，转而用 Javascript 在页面加载之后加上这些标签。我没法保证这个元素在没有 Javascript 的场景下的行为。
*   不要在标记语言和元数据中重复使用标题和其他数据。与 HTML 的随意风格不同，feed 格式有指定的地方来指定文章的作者，摘要和时间。带时间戳的页眉页脚，标题甚至 email 联系方式都没有必要放到 Atom feed 中。
*   选择恰当自然的光栅图像。我有些博文为了更好的展示效果会用 CSS 来压缩较大的图片。如果没有 CSS 这些图片就会非常巨大看上去很不妙（更不用提传输速度也会差一点）。
*   留心 Atom 中 `summary` 和 `content` 的区别。一些静态网站生成器（呃，比如 _hakyll_）会把整个正文都丢到 `summary`（摘要） 里面去。

这个经历开拓了我的眼界，见识到了用户代理的能力。全功能浏览器和基于文本的浏览器或者阅读器并没有本质的区别。用户浏览网站时 JavaScript，CSS 以及图像是否开启这些状态完全是个排列组合，而一些简单的调整就能让大家更容易欣赏你的网站。
