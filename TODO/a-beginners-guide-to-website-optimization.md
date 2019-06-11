> * 原文地址：[A beginner’s guide to website optimization](https://medium.freecodecamp.org/a-beginners-guide-to-website-optimization-2185edca0b72)
> * 原文作者：[Mario Hoyos](https://medium.freecodecamp.org/@mariohoyos?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/a-beginners-guide-to-website-optimization.md](https://github.com/xitu/gold-miner/blob/master/TODO/a-beginners-guide-to-website-optimization.md)
> * 译者：[Starrier](https://github.com/Starriers)
> * 校对者：[Clarence](https://github.com/ClarenceC)、[dazhi1011](https://github.com/dazhi1011)

# 网站优化初学者指南

![](https://cdn-images-1.medium.com/max/800/1*xNt4aprSuOo2bdYg9F-6gw.jpeg)

图片由 Pexels 提供。

我是一名初学者，在 Google 优化排名中，我可以达到 99/100。如果我可以做到，那么您也可以。

如果您和我一样，喜欢证据。下面是 [Google 的 PageSpeed Insights](https://developers.google.com/speed/pagespeed/insights/) 结果。[hasslefreebeats](https://www.hasslefreebeats.com) 是我维护的网站，我最近花了一些时间进行优化。

![](https://cdn-images-1.medium.com/max/800/1*HHW2mRHOGA7w_o9VxC4w7A.png)

我的 PageSpeed Insights 分数截图。

我对这些结果感到非常自豪，但是我想强调的是，几周前我还不知道如何去优化一个网站。今天我要和大家分享的只是一大堆 Google 搜素和故障排除所得出的结果，我希望可以为您省去麻烦。

为了防止您想跳过，这篇文章被分成了几个小节。

我绝不是专家，但我相信如果您实施以下技术，你会看到效果！

### 图片

![](https://cdn-images-1.medium.com/max/800/1*jkCxAOJPjPhKkQaen0rt4g.jpeg)

图片由 Pexels 提供 (Medium 已做优化).

作为一个网站开发初学者，我并没有想过图片的事情。我知道向我的网站添加高质量图片会使它看上去更专业，但是我从没有停下来考虑它们对我的网页加载时间的影响。

我为优化图像所做的事情主要是压缩它们。

回想起来，这从一开始就非常直观，只是我没有在意，可能您也一样。

我用来压缩图片的服务是 [Optimizilla](http://optimizilla.com/), 一个易于使用的网站，那您只需上传图片，选择你要压缩的级别，然后下载压缩图片。我看到一些资源的大小减少了 70% 以上，这对于更快的加载时间有很大的帮助。

Optimizilla 并不是您图片压缩需求的唯一选择。您可以使用一些独立的开源软件，Mac 环境下的 [ImageOptim](https://imageoptim.com/mac) 或者 Windows 环境下的 [FileOptimizer](https://sourceforge.net/projects/nikkhokkho/files/FileOptimizer/)。如果您更喜欢用构建工具进行压缩，那么可以使用 [Gulp](https://www.npmjs.com/package/gulp-imagemin) 和 [WebPack](https://github.com/Klathmon/imagemin-webpack-plugin) 插件。无论您怎么做，只要做了，那么即使是最小的努力，也会在性能上获取提升。

根据您的情况，可能还需要查看文件格式。一般来说，jpg 会比 png更小。我是否使用其中一个的主要区别是我是否需要图片背后的透明度：如果我需要透明度就使用 png，否则使用 jpg。您可以在 [这里](https://www.digitaltrends.com/photography/jpeg-vs-png-photo-format/)更深入地了解这两者的利弊。

此外，Google 已经推出了一种非常贴心的 webp 格式，但由于目前没有在所有浏览器被支持，所以我还在犹豫是否使用它。会留意未来是否有进一步地更新支持！

我没有在我的图片上做更多的压缩来获得以上展示的结果，但是如果您想进一步优化 [这里有一篇很棒的文章。](https://www.frontamentals.com/practical-guide-to-images)

### 视频

![](https://cdn-images-1.medium.com/max/800/1*9NjlazjgG3HV99ZH54_NGg.jpeg)

照片来自 Pexels 的 Terje Sollie。

尤其是我没有在我目前的任何项目中使用视频，所以我只会简单地涉及到这一点，因为我不觉得在这方面我这是最佳的解决方案。

在这种情况下我可能会让专业人士来做繁重的工作。Vimeo 为托管视频提供了一个很好的平台，在那里它们会降低视频质量，从而降低链接速度，并压缩您的视频以优化性能。 

您也可以在 YouTube 上托管视频，然后使用 [youtube-dl](https://rg3.github.io/youtube-dl/) 工具从 You Tube 下载视频，同时根据您网站的需要配置视频。

至于其他可能的解决方案，请查看 [Brightcove](https://www.brightcove.com/en/), [Sprout](https://sproutvideo.com/) 或者 [Wistia](https://wistia.com/).

### Gzip 压缩

![](https://cdn-images-1.medium.com/max/800/1*0OyByk88pz6_R9H7BGmvng.jpeg)

了解了么? Zip 压缩?  Pexels 提供的图片。

最初部署我的网站时，我不知道 gzip 是什么。

长话短说，gzip 是一种大多数浏览器都能理解的文件压缩格式。它可以在幕后运行而不需要用户知道它正在发生。

根据您应用程序所在的位置，gzip 可能非常简单，只需打开配置开关，以指定您希望服务器在发送文件时对其进行 gzip 压缩。就我而言，托管我网站的 Heroku 不提供这个选项。

事实证明，在服务器代码中有些包可以进行显式压缩。这使得您只需几行代码即可获取 gzip 的好处。使用[这个](https://github.com/expressjs/compression)压缩中间件，[我能够将 JavaScript 和 CSS 捆绑包大小减少 75%。](https://codeburst.io/how-i-decreased-the-size-of-my-heroku-app-by-75-1a4cf329b0ab)

检查一下您的托管服务是否提供 gzip 选项是值得的。如果没有，请查看如何将 gzip 添加到服务器代码中。

### 最小化

![](https://cdn-images-1.medium.com/max/800/1*HoF4YTMZzbKsCi_nEbeLeQ.jpeg)

最小化的菠萝  Pexels 提供。

最小化是在不影响代码功能（空格、换行符等）的情况下从代码中删除不必要字符的过程。这使您可以减少您正在通过互联网传输文件的大小。它也有助于混淆您的代码，这使得狡猾的黑客更难检测到安全弱点。

如今，最小化功能通常是 Webpack 或 Gulp 或者其他方法作为构建过程的一部分。但是这些构建工具有一些学习曲线，因此如果您正在寻找更简单的替代方法，Google 推荐 [HTML-Minifier for HTML](https://github.com/kangax/html-minifier)、 [CSSNano for CSS](https://github.com/ben-eb/cssnano) 和 [UglifyJS for Javascript](https://github.com/mishoo/UglifyJS2)。

### 浏览器缓存

![](https://cdn-images-1.medium.com/max/800/1*OGT_IyEaWXw5gbFOoP_Ipg.jpeg)

不太清楚浏览器具体如何存储数据，但它是我所能得到的最接近的。Pexels 赞助。

将静态文件存储在浏览器的缓存中是提高网站速度的一种非常有效的方法，特别是在来自同一浏览器的回访时。直到 Google 告诉我，我的一些资源没有被适当地缓存，因为我从服务器发送的 HTTP 响应头中缺少标题，我才意识到这一点。

一旦加载了我的主页，就会向我的服务器发送一个请求，以获取一堆歌曲的数据，然后在音乐播放器中解析这些歌曲。我不经常更新这个网站上的歌曲，所以如果这会是我的页面加载速度更快一些的话，我不介意用户在我的网站上看到他们上次访问的相同歌曲。

为了提高性能，我在服务器的响应对象 (Express/Node server) 中添加了以下代码：

```
res.append("Cache-Control", "max-age=604800000");

res.status(200).json(response);
```

我在这里所做的就是在我的响应中附加一个说明超过一周（毫秒）应该重新下载资源的缓存控制头。如果您经常更新这些文件，缩短最长时间可能是个好主意。

### **内容分发网络**

![](https://cdn-images-1.medium.com/max/800/1*jhMPWm5Op0VRbmPC6-FX9w.jpeg)

现实中的 CDN 图像，Pexels 提供。

内容分发网络（CDN）是允许来自世界各地的用户在地理上更接近您的内容的网络。如果用户必须加载来自日本的大图像，但您的服务器在美国，这将比您在东京的服务器花费更长的时间。

CDN 允许您利用分布在世界各地的一组代理服务器，无论您的最终用户位于何处，都可以更快加载您的内容。

我想指出的是，实现 CDN 之前，我能够实现**上面**你所看到的结果--我只是想提及它们，因为没有网站优化的文章提及到他们。如果您计划拥有全世界的读者，那么在您的网站上有一些创新是绝对必要的。

一些流行的 CDNs 包括 [CloudFront](https://aws.amazon.com/cloudfront/) 和 [CloudFlare](https://www.cloudflare.com/lp/ddos-a/?_bt=157293179478&_bk=cloudflare&_bm=e&_bn=g&gclid=CjwKCAiA_c7UBRAjEiwApCZi8Ri3kAEt3UraYPUFUQOMTG0Xz7WGCNRUri0UNtCOUAdUMJI8osxuDRoCTx8QAvD_BwE).

### 其他方法

这里有些能让您有所收获的内容：

*   首先通过增加您网站的感知性能优先加载“首页”来优化您的网站。一种常见的方法是[延迟加载](https://en.wikipedia.org/wiki/Lazy_loading)没有显示在登录页面上的图像。
*   除非您的应用程序依赖于 JavaScript 来渲染 HTML，例如使用 Angular 或者 React 来构建网站，那么它会在你 HTML 文件的 body 底部看似安全的区域加载你的 script 标签。即使这可能会影响您的[交互时间](https://developers.google.com/web/tools/lighthouse/audits/time-to-interactive)，所以我并不会对每个情况都推荐使用这种技术。

### 总结

当涉及到优化您的网站时，这都只是冰山一角。根据您接受的流量和所提供的服务数量，您可能会在许多不同的领域存在性能瓶颈。也许您需要更多的服务器，也许您需要一个拥有更多 RAM 的服务器，也许您的三重嵌套 for 循环可以使用一些重构--谁知道呢？

对于加速您的网站来说，没有一个准确无误的方法，您最终将不得不根据您的测试来做出最好的决定。不要浪费时间去优化不需要优化的东西。分析您网站的性能，找出瓶颈，然后专门解决这些瓶颈。

我希望您能在这篇文章中找到一些有用的东西！正如我所提到的，我在这个领域还有很多东西要学。如果您有任何额外的提示或者建议，请将它们留在下面的评论中！

如果您喜欢我的文章，请为我鼓掌，还有以下内容：

*   [当我开始编码时，我希望我已经了解的工具](https://medium.freecodecamp.org/tools-i-wish-i-had-known-about-when-i-started-coding-57849efd9248)
*   [当我开始编码时，我希望我已经了解的工具: 重新访问](https://medium.freecodecamp.org/tools-i-wish-i-had-known-about-when-i-started-coding-revisited-ffb715ffd23f)

当然，也可以关注我的 [Twitter](https://twitter.com/marioahoyos).


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
