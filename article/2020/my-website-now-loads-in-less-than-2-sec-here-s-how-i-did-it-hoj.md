> * 原文地址：[My website now loads in less than 1 sec! Here's how I did it! ⚡](https://dev.to/cmcodes/my-website-now-loads-in-less-than-2-sec-here-s-how-i-did-it-hoj)
> * 原文作者：[C M Pandey](https://dev.to/cmcodes)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/my-website-now-loads-in-less-than-2-sec-here-s-how-i-did-it-hoj.md](https://github.com/xitu/gold-miner/blob/master/article/2020/my-website-now-loads-in-less-than-2-sec-here-s-how-i-did-it-hoj.md)
> * 译者：[wangqinggang](https://github.com/wangqinggang)
> * 校对者：[Chorer](https://github.com/Chorer), [Inchill](https://github.com/Inchill)

# 我的网站加载时间不到 1 秒，这是我如何做到的！

![](https://res.cloudinary.com/practicaldev/image/fetch/s--c4GvYfuf--/c_imagga_scale,f_auto,fl_progressive,h_420,q_auto,w_1000/https://dev-to-uploads.s3.amazonaws.com/i/ihdeq6ry7wuuv1tdo317.PNG)

你好啊！

你之所以点开这篇文章，可能是因为你想知道我是怎样使我的作品集网站加载仅用 **0.8 秒**，并在 Lighthouse 取得 **97 的分数的**。

在底部有我的作品集网站的链接与它的源代码。

我将在这里列出我相关实现的所有建议和技巧！让我们开始吧！

> 注意：根据 Lighthouse 的说法，“数值是估计的，每次都有所不同。性能评分仅基于 [这些指标](https://github.com/GoogleChrome/lighthouse/blob/d2ec9ffbb21de9ad1a0f86ed24575eda32c796f0/docs/scoring.md#how-are-the-scores-weighted)。” 本报告生成于 8 月 2 日，下午 6:29:22。 在你的机器上测试分数可能与我的不同，因为我们机器的网速或后台运行的扩展不同，并且我在测试之后可能会添加一些功能。此外，我已经在上面说的很“清楚”，这些分数是由 Google Lighthouse 生成的。不要期望在其它工具上得到相同的分数。所以请不要偏离这个基础浪费时间。

# 技巧 1 不要使用大型 DOM 树

> 我的作品集包含 487 个 DOM 元素，最大 DOM 深度为 13，最多只有 20 个子元素！

如果你的 DOM 树很大，那么它会降低你网页的性能：

* 内存性能

使用 `document.querySelectorAll('li')` 等通用查询选择器会存储对多个节点的引用，消耗设备的内存。

* 网络效率和负载性能

一个大的 DOM 树有许多节点（在第一次加载时不可见），这降低了加载时间，增加了用户的数据成本。

* 运行时性能

当用户或脚本与网页交互时，浏览器需要重新计算节点的位置和样式。复杂的样式规则会降低渲染速度。

# 技巧 2 不要使用大量网络负载

> 我的作品集网站总的网络负载大小只有 764 KB。

你的网站的有效载荷总大小应低于 1600 KB。 
为了保持低负载水平，你可以做以下操作：

* 推迟请求，直到需要请求为止。
* 缩小和压缩网络负载。
* 将 JPEG 图像的压缩级别设置为 85。

> 永远记住，网络负载越多，费用越多。

# 技巧 3 不要使用 GIF

不要使用 GIF ，而是使用 PNG/ WebP 格式显示静态图像。如果你想要显示动画内容，那么就不要使用大的 gif（低效和像素化），而是考虑使用 MPEG4/WebM 视频格式。

现在，你会说，如果我想要他们具有如下功能：

* 自动播放
* 连续循环
* 没有音频

好吧，让我把你从这些问题中解救出来，HTML5 `<video>` 元素允许重新创建这些行为。

```html
<video autoplay loop muted playsinline>
  <source src="my-animation.webm" type="video/webm">
  <source src="my-animation.mp4" type="video/mp4">
</video>

```

# 技巧 4 预加载关键请求

假设您的页面正在加载一个 JS 文件，这个 JS 文件正在获取另一个 JS 文件和 CSS 文件 ，那么在下载、解析和执行这两个资源之前，页面不会完全显示。

如果浏览器能够更早地启动请求，那么将节省大量时间。幸运的是，您可以通过声明预加载链接来实现这一点。

`<link rel="preload" href="style.css" as="style">`

# 技巧 5 不要尝试多页重定向

重定向会降低网页的加载速度。当浏览器请求重定向的资源时，服务器返回一个 HTTP 响应。然后，浏览器必须对新地址发出另一个 HTTP 请求来获取该资源。这种跨网络的额外行程可能使资源的加载延迟数百毫秒。

如果你想把你的移动用户转移到你的网页的移动端版本，那么你需要考虑重新设计你的网站，使其具有响应式功能。

# 技巧 6 预先链接到所需的源

使用关键字 `preconnect` 给浏览器发出信号，使其与重要的第三方源建立早期连接。

`<link rel="preconnect" href="https://www.google.com">`

这样做可以建立到源的连接，并通知浏览器您希望尽快启动进程。

# 技巧 7 为你的图像高效地编码

对于 JPEG 图像，85 的压缩级别已经足够好了。你可以通过多种方式优化你的图像：

* 压缩图像
* 使用图像 CDN 
* 避免使用 GIF 图片.
* 提供响应式图像
* 懒加载图片

# 技巧 8 最小化你的 JavaScript 文件

最小化是删除空格和不需要的代码的过程，他可以创建一个更小的，但完全有效的代码文件。

通过最小化 JavaScript 文件，可以减少脚本的有效负载大小和解析时间。

> 我使用 [JavaScript Minifier](https://javascript-minifier.com/) 来做同样的事情。

# 技巧 9 最小化你的 CSS 文件

CSS 文件比任何其他文件占用更多的空格。通过简化它们，我们可以确保节省一些字节！
你甚至可以将颜色值更改为它的简写形式，例如 #000000 可以简写为 #000，并且可以正常工作！

> 我使用 [CSS Minifier](https://cssminifier.com/) 来做同样的事情。

# 技巧 10 调整图片大小

我敢打赌，这是 web 性能优化最常见的建议，因为图片的大小远远大于任何文本脚本文件，所以过大的图片可能对网站性能造成“极大的杀伤力”。

永远不要上传比屏幕上渲染的图片大的图片，这样做没有任何好处。

你可以简单的调整你的图片尺寸或者使用：

* 响应式图片
* 图像 CDN
* 用 SVG 代替图标

谢谢你的阅读! 😄  
希望你能从中学到新的东西！ 😃

这里是我的作品集网站链接  👉 [cmcodes](https://cmcodes1.github.io)

这是我的作品集网站源代码的链接 👉 [github repo](https://github.com/cmcodes1/cmcodes1.github.io)

看完这篇文章，让我知道你的看法！渴望听到你的意见。😁

欢迎在下面的评论中分享你的作品集网站链接。我很乐意看一看。😊

编程愉快！ 👨‍💻

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
