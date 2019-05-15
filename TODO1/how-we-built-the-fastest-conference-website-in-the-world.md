> * 原文地址：[How we built the fastest conference website in the world](https://2019.jsconf.eu/news/how-we-built-the-fastest-conference-website-in-the-world/)
> * 原文作者：[Malte Ubl](https://twitter.com/cramforce) 
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-we-built-the-fastest-conference-website-in-the-world.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-we-built-the-fastest-conference-website-in-the-world.md)
> * 译者：[Xuyuey](https://github.com/Xuyuey)
> * 校对者：[ezioyuan](https://github.com/ezioyuan), [Long Xiong](https://github.com/xionglong58)

# 构建世界上最快的会议网站

> 这是 JSConf EU 的组织者 [Malte Ubl](https://twitter.com/cramforce) 的客座文章。

是不是被标题诱惑来啦，但我们绝对不会让你白来一趟的！我不确定这一定是世界上最快的会议网站，但我也不确定它不是；而且我花了一大笔多到不合理的时间试图让它成为世界上最快的会议网站。我也是网络组件库 [AMP](https://www.ampproject.org/) 的创建者，它可以用于搭建可靠的快速网站，同样，这些网站也是我尝试新技术进行优化的游乐场，然后我可以将它们应用到日常工作中。此外，快速网站有[更好的转换率](https://www.cloudflare.com/learning/performance/more/website-performance-conversion-rates/)，在我们的情况下这意味着：[卖出更多的门票](https://ti.to/jsconfeu/jsconf-eu-x-2019/)。

[JSConf EU 网站](https://2019.jsconf.eu/)是搭建在静态网页生成器 [wintersmith](http://wintersmith.io/) 上的。如果你知道 [Jekyll](https://jekyllrb.com/) 是什么，那你一定也会知道什么是 wintersmith。基本上都差不多，它们都基于 Node.js。Wintersmith 还好，默认情况下它不会做什么可怕的事情，但是有一些我需要的东西必须自己构建。

## 字体

### 内联

OMG，我花了好多时间来优化字体性能。你知道怎么拥有比 JSConf 网站更快的字体性能吗？那就去使用系统字体吧，但那样会有些无聊。我们使用了 Typekit 的字体，它的字体都很赞。Typekit 要求你加载一个 CSS 文件或者 JS 文件，用来告诉网站字体文件在哪里。这对性能来说太可怕了：加载文件意味着等待网络，而网络速度很慢。由于 DNS 解析，TCP 和 TLS 连接等原因，添加一个指向第三方主机的 CSS 文件到页面可以轻易地影响[首屏渲染](https://developers.google.com/web/tools/lighthouse/audits/first-contentful-paint)时间，可能会有大概 600 ms。我们修复了这个问题，方法是在[构建过程中下载 CSS 文件](https://github.com/jsconf/festival-x.jsconf.eu/blob/master/scripts/generate-locals.js#L5)，然后在 CSS 中内联它们。问题解决了，我们赢得了 600 ms。

事实证明 Typekit CSS 文件实际上使用了 `@import` 来添加其他的 CSS 文件。我不确定这个会不会阻塞渲染，但这个肯定不好。原来该文件是空的，对它的请求仅仅用于统计信息的收集。为了避免这种情况，我在编写的脚本文件中移除了内联 CSS 中的 `@import`（[哈哈，正则](https://github.com/jsconf/festival-x.jsconf.eu/blob/master/scripts/generate-locals.js#L19)），然后在 JavaScript 中保存这个请求的链接，页面加载完毕（不会再影响首评渲染时间）之后，再去请求。

### 字体显示

好了，既然我们已经内联了 Typekit 的 CSS，我们也可以通过[更多的正则表达式](https://github.com/jsconf/festival-x.jsconf.eu/blob/master/scripts/generate-locals.js#L25)轻松地改变它。在 `@font-face` 规则中添加 [`font-display: fallback`](https://developer.mozilla.org/en-US/docs/Web/CSS/@font-face/font-display)，可以阻止字体绘制对下载的阻塞，基于上面的原因我们在脚本中添加了这样的代码。

## 不可变的 URL

我希望 wintersmith 能有一个真正的资源管道（asset pipeline）。它确实有资源处理程序，但每种资源只有一个。所以，在没有代码重复的情况下，你无法轻松地为 CSS 文件和 SVG 执行操作。但谁关心会议网站的代码重复？

我[黑入了 wintersmith](https://github.com/jsconf/festival-x.jsconf.eu/blob/master/plugins/nunjucks.js#L130-L138)，将哈希值插入到所有本地可用的资源 URL 中，并为它们提供了一个在 CDN 中配置的公共路径前缀，用来有效地发出无限的缓存头。同样，[我们的 ServiceWorker 知道](https://github.com/jsconf/festival-x.jsconf.eu/blob/master/contents/sw.js#L23-L30)它永远不必担心这些 URL 过期并且可以永久保留资源。如果你复制我们的代码，请考虑缩短哈希值。对于我们这个用例，在现实世界中没有人需要这个完整的 SHA-XXX 串，而且还能在 HTML 中省下相当多的字节。我现在不打算改变它，因为这会破坏所有资源的缓存。

## CSS

### 死码消除

JSConf EU 网站使用 [Tachyons](https://tachyons.io/) 作为 CSS 框架。Tachyons 很不错，除了它的体积很大，而且就算是最小的基础包中也具有所有的功能。我安装了一个 [CSS 死码消除（DCE）后处理步骤](https://github.com/purifycss/purifycss)，它可以查看所有静态网站生成器生成的实际标记，然后将从不匹配任何内容的 CSS 选择器都修剪掉。在我们的例子中，它将 CSS 体积减少了超酷的 85％。

### 内联

既然 CSS 的体积非常小，那么将它内联到每个页面中就说的过去了。你可能会想“但是缓存怎么办？”很好的问题，但是如果你想在这场关于最快网站的竞赛中获胜，你就无法负担得起冷缓存状态下额外的请求。所以我内联了 CSS，而且事实上我们可以在 CSS DCE 上做的更好。所以我再次在每个页面上运行它，对于每个页面又减少了额外的 15-25% 的 CSS 体积。

顺便说一句：先在整个网站运行一次 CSS DCE，然后再在每一页上进行一次该处理是非常有意义的。这是因为对于整个网站来说 DCE 处理的时间复杂度是 `O（所有 HTML 大小 + CSS 大小）` ，对于单个页面是 `O（页面数量 *（平均 HTML 大小 + CSS 大小）`。如果你首先在整个网站上运行优化，CSS 体积的减少可以让接下来对于单个页面的优化明显更快 —— 至少如果你可以在首次处理时减少 85% 的体积，就像我们的例子中实现的那样。

## 内容管理

大多数静态网站生成器都希望通过将 markdown 文件放入 git 中来管理网站。JSConf EU 网站使用 Google Spreadsheet 来维护结构化数据（例如演讲者资料）和 Google Docs 来保存像这样的博客文章。虽然这不会让网站运行更快，但它确实使编辑速度更快，所以它仍然可以计入最快的会议网站。例如说[这个](https://docs.google.com/document/d/1oZWzjy0cPyBmdbghIREd9iVbUGXlUHd1Dnv7CmSQNPk/edit?usp=sharing)，就是你现在看到的这篇文章！

作为 Google GSuite 后端（LOL）构建过程的一部分，我们应该进行图像优化。不幸的是，还没有足够的时间来制作 webp 图像，所以如果你想建立一个更快的会议网站，这肯定是个突破口！

## ServiceWorker

JSConf 网站有一个基于 [Workbox](https://developers.google.com/web/tools/workbox/) 的 ServiceWorker。ServiceWorker 并不总有益于性能。它们必须安装注册，然后通常还得额外的配置 IndexedDB。这可能花费 100 毫秒。然而，对于会议网站而言，离线功能在性能问题上肯定会胜过糟糕的会议 Wi-Fi（我们的会议 Wi-Fi 通常很出色，但会议室有 1400 人，我们希望做好准备）。通过使用 [导航预加载](https://developers.google.com/web/updates/2017/02/navigation-preload)来进一步缓解这个问题，在大部分浏览器中导航预加载可以分摊文档网络请求的启动时间。

为了权衡新鲜程度以及离线功能，该网站使用了“网络优先”策略，我们会首先尝试获取新的文档，如果在 2 秒之内没有响应，我们会回退到缓存。

因为网站的所有资源都使用了不可变的 URL，ServiceWorker 将永久缓存这些 URL 并始终从缓存（如果可用）提供服务。

## 动画

你可能已经注意到在我们的首页上有一个很大的动画 X。很显然，如果没有这个动画，页面的加载速度会更快，但是那样的话还有什么乐趣呢？这个动画是基于 [Lottie-Web](https://github.com/airbnb/lottie-web) 库制作的，这是一个由 AirBnB 创建的开源 Adobe AfterEffects 动画网络播放器，被公认为难以置信的赞。不幸的是，它也很庞大。这里的庞大指的是动画运行时间和动画数据本身，后者是一大堆 JSON。我们加载了 JSON 文件作为动画 JS 的一部分而不是使用 `JSON.parse`，如此我们便可以在主线程之外解析这些数据。

## 脚本加载

JSConf EU 网站实际上加载了一些 JavaScript —— 但它不会阻止页面绘制，我们内联了交互所需要的每一块代码。这样当浏览器绘制页面的时候，不管外部 JS 是否已经加载完毕，所有关键的交互都已经在起作用了。虽然这个不会让[内容安全策略（CSP）](https://developer.mozilla.org/en-US/docs/Web/HTTP/CSP)满意，但是不要怂，及时行乐，哈哈哈。我们加载的 JS 文件也不会改变 DOM，即不会触发额外的绘制（当然，除了动画以外），所以无论浏览器首先绘制了什么内容，在发生用户交互之前它都不会发生改变。

## 预加载

除了乐一乐，我们希望大家在这个网站上做的主要事情之一就是[买票](https://ti.to/jsconfeu/jsconf-eu-x-2019)。这就是为什么我们在页面加载的早期就预先加载了票务支付提供商的登录页面的原因，以便当你决定买票（哈哈哈，我觉得应该买！）的时候，它就可以立刻加载。另外，我们预加载了从主导航链接到的所有页面，因此在网站内的导航速度非常快。不幸的是，并不是所有的浏览器中都有预加载的功能，但是社区最近真的用了很多时间使它可以和 Safari 的双键缓存基础设施兼容，所以我们有望在所有浏览器中使用它 —— 尽管不是在 JSConf EU 2019 中。

## HTTP 级联

这个网站绘制使用了一次 HTTP 往返，并且从不需要获取一个 HTTP 资源用来确认除了主文档之外还需要获取其他内容。这意味着 HTTP 级联的最大深度为 2 次请求。特别是在移动设备上，页面加载时间通常由延迟决定。在这些情况下，具有一个扁平的请求级联意味着网络延迟会带来较少的负面影响，或者让我们返回到时间复杂度 O 上：在延迟和可用或所需带宽关系很大的情况下，页面加载时间是 `O(延迟 * HTTP 级联深度 + 下载内容用时)`。能够始终使用 1 次 HTTP 往返绘制意味着在许多情况下页面的加载时间由 DNS 和 TLS 连接决定。这些在实验测试中经常看起来很糟糕。但有了 CDN 对 [TLS1.3](https://blog.cloudflare.com/rfc-8446-aka-tls-1-3/) 甚至 [Quic/HTTP3](https://en.wikipedia.org/wiki/QUIC) 的支持，真实情况下的性能看起来会好很多，特别是对于那些重复访客。

[![2019.jsconf.eu 网址的请求数据流](https://2019.jsconf.eu/immutable/2ecf1ff4188e623f5f25400024c9eaebd9d77b30/images/cms/image-4656bb72.png#ar=105)](https://www.webpagetest.org/result/190318_AA_b2ed333c2d4c4b5cf441dc205162f23a/1/details/#waterfall_view_step1)一个非常扁平的 HTTP 级联（右下角是 ServiceWorker 在启动，它不会影响原始页面加载）。

## 图像加载

OMG，我讨厌加载图像时没有预先知道它们的大小，并且当它们通过网络传输时，它们会推迟页面的显示。在我们的网站上，所有的图像要么有一个静态的大小，要么使用 [`padding-top: XX%` hack](https://css-tricks.com/aspect-ratio-boxes/) 使图像扩展到所有可用的水平空间。其他人还使用了 [intrinsicsize 属性](https://github.com/WICG/intrinsicsize-attribute)（目前没有浏览器支持）（如此便可以不使用刚才的 hack） 和 [懒加载属性](https://css-tricks.com/a-native-lazy-load-for-the-web-platform/)(目前也没有浏览器支持)以及[`decoding=async`](https://developer.mozilla.org/en-US/docs/Web/API/HTMLImageElement/decoding)（目前大部分浏览器支持）来避免图像解码阻塞主进程。

> 什么是 CSS 中的宽高比？他们说是 padding-top 百分比。[Jan 18, 2018](https://twitter.com/cramforce/status/954005742234738688)

（小小的讽刺警告：上面推文的图片拖慢了页面，但是我把它放在了页面的这个位置，你可能都不会注意到（如果你没有看到这里的话），实在是不好意思）。

## 总结

就是这样啦。在 2019 年制作快速网站并不是一件很难的事情。你只需要这浏览器制造商打好关系，付他们钱就让网站速度更快，在 Twitter 逛一整天你都可以获得关于性能的热门广告，或者你更愿意动手处理性能的小改动而不是看 Netflix。

## 致谢

谢谢 [Malte Ubl](https://twitter.com/cramforce) 撰写这篇文章。这个网站本身最初是由过于有才华的 [Lukasz Klis](https://twitter.com/lukaszklis) 开发，而令人称赞的设计则是由超酷的 [Silke Voigts](https://twitter.com/silkine) 为我们带来，谢谢他们。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
