
> * 原文地址：[The State of the Web](https://medium.com/@fox/talk-the-state-of-the-web-3e12f8e413b3)
> * 原文作者：[Karolina Szczur](https://medium.com/@fox?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/talk-the-state-of-the-web.md](https://github.com/xitu/gold-miner/blob/master/TODO/talk-the-state-of-the-web.md)
> * 译者：[undead25](https://github.com/undead25)
> * 校对者：[sun](https://github.com/sunui)、[IridescentMia](https://github.com/IridescentMia)

# 网络现状：性能提升指南

互联网正在爆发式地增长，我们创建的 Web 平台也是如此。**我们通常都没有考虑到用户网络的连通性和使用情景**。即使是万维网现状的一瞥，也可以看出我们还没有建立起同理心和对形势变化的认知，更不用说对性能的考虑了。

那么，现今的网络状况是怎样的呢？

**地球上 74 亿人口中，只有 46% 的人能够上网**，平均网络速度为 7Mb/s。更重要的是，93% 的互联网用户都是通过移动设备上网的 —— 不去迎合手持设备是不可原谅的。数据往往比我们想象中要昂贵得多 —— 购买 500MB 数据的价格在德国要为此工作 1 个小时，而在巴西需要 13 个小时（更多有趣的统计可以看看 [Ben Schwarz](https://twitter.com/benschwarz) 的[《泡沫破灭：真实的性能》](https://building.calibreapp.com/beyond-the-bubble-real-world-performance-9c991dcd5342)）。

**我们的网站表现得也不尽如人意** —— 平均体积大概[是第一版 Doom 游戏的大小](https://www.wired.com/2016/04/average-webpage-now-size-original-doom/)（3MB 左右）（请注意，为了统计准确度，需要使用[中位数](https://zh.wikipedia.org/wiki/%E4%B8%AD%E4%BD%8D%E6%95%B8)，推荐阅读 [Ilya Grigorik](https://twitter.com/igrigorik) 的 [《“平均页面”是一个神话》](https://www.igvita.com/2016/01/12/the-average-page-is-a-myth/)。中位数统计出的网站体积目前为 1.4MB）。图片可以轻松占用 1.7MB，而 JavaScript 平均为 400KB。不仅仅只有 Web 平台，本地应用程序也有同样的问题，你是否遇到过为了修复某些 bug，不得不下载 200MB 的应用呢？

**技术人员经常会发现自己处于特权地位**。拥有新型高端的笔记本、手机和快速的网络连接。我们很容易忘记，其实并不是每个人都有这样的条件（实际上只有少部分人而已）。

> 如果我们只站在自己而不是用户的角度来构建 web 平台，那这将导致糟糕的用户体验。

我们如何通过在设计和开发中考虑性能来做得更好呢？

## 资源优化

最能明显提升性能但未被充分利用的方式是，从了解浏览器如何分析和处理资源开始。事实证明，当浏览器解析和立即确定资源的优先级时，在资源发现方面表现得非常不错。下面是关于**关键请求**的解释。

> 如果请求包含用户视口渲染所需的资源，那该请求就是关键请求。

对于大多数网站，关键请求可以是 HTML、必要的 CSS、LOGO、网络字体，也可能是图片。事实证明，在大多数情况下，当资源被请求时，许多其他不相关的（JavaScript、追踪代码、广告等）也被请求了。不过我们能够通过仔细挑选重要资源，并调整它们的优先级来避免这种情况发生。

通过 `<link rel ='preload'>`，我们可以手动强制设置资源的优先级，来确保所期望的内容按时渲染。这种技术可以明显改善“交互时间”指标，从而使最佳用户体验成为可能。

![](https://cdn-images-1.medium.com/max/800/1*JT-53LslhwOOqTgv1dGoXg.png)

由于相关资料的缺乏，关键请求对许多人来说似乎仍然是一个黑盒子。幸运的是，[Ben Schwarz](https://twitter.com/benschwarz/) 发表了一篇非常全面且通俗易懂的文章 —— [《关键请求》](https://css-tricks.com/the-critical-request/)。另外，你也可以查看 Addy 关于预加载的文章 —— [《Chrome 中的预加载和优先级》](https://medium.com/reloading/preload-prefetch-and-priorities-in-chrome-776165961bbf)。

![在 Chrome 开发者工具中启用优先级](https://cdn-images-1.medium.com/max/800/1*ju18GQzgF-TQDMrYdtPelg.gif)

🛠 要追踪优先处理请求的效果，你可以使用 Lighthouse 性能检测工具和[关键请求链路评测](https://developers.google.com/web/tools/lighthouse/audits/critical-request-chains)，或者查看 Chrome 开发者工具网络标签下的请求优先级。

**📝 通用性能清单**

1. 主动缓存
2. 启用压缩
3. 优先关键资源
4. 使用 CDN

## 图片优化

页面传输的大部分数据通常都是图片，因此优化图片可以带来很大的性能提升。有许多现有的策略和工具可以帮助我们删除多余的字节，但首先要问的是：“图片对于传达后续的信息和效果至关重要吗？”。如果可以移除，不仅可以节省带宽，还可以减少请求。

在某些情况下，我们可以通过不同的技术来实现同样的效果。CSS 有很多具有艺术性的属性，例如阴影、渐变、动画和形状，这就允许我们用具有合适样式的 DOM 元素来替代图片。

### 选择正确的格式

如果必须使用图片，那确定哪种格式比较合适是很重要的。一般都在矢量图和栅格图之间进行选择：

- **矢量图形**：与分辨率无关，文件通常比较小。特别适用于 LOGO、图标和由简单图形（点、线、圆和多边形）组成的图片。
- **栅格图像**：表现内容更丰富。适用于照片。

做出上面的决定后，有这样的几种格式供我们选择：JPEG、GIF、PNG-8、PNG-24 或者最新的格式，例如 WEBP 或 JPEG-XR。既然有这么多的选择，那如何确保我们选择的正确性呢？以下是找到最佳格式的基本方法：

- **JPEG**：色彩丰富的图片（例如照片）
- **PNG–8**：色彩不是很丰富的图片
- **PNG–24**：具有部分透明度的图片
- **GIF**：动画图片

Photoshop 在图片导出时，可以通过一些设置来对上述格式的图片进行优化，例如降低质量、减少噪点或者颜色的数量。确保设计师有性能实践的意识，并通过正确的优化预设来准备合适的图片。如果你想了解更多关于如何开发图片的信息，可以阅读 [Lara Hogan](https://twitter.com/lara_hogan) 的 [《速度与激情：以网站性能提升用户体验》](http://designingforperformance.com/optimizing-images/#choosing-an-image-format)。

### 尝试新格式

有这样几种由浏览器厂商开发的新图片格式：Google 的 WebP，Apple 的 JPEG 2000 和 Microsoft 的 JPEG-XR。

**WebP** 是最具有竞争力的，支持无损和有损压缩使得它被广泛应用。**无损 WebP 比 PNG 小 26%，比 JPG 小 25-34%**。74% 的浏览器支持率及降级方案使它可以安全地被使用，最多可节省 1/3 的传输字节。JPG 和 PNG 可以通过 Photoshop 和其他图像处理程序，也可以使用命令行（`brew install webp`）将其转换为 WebP。

如果你想探索这些格式之间的视觉差异，我推荐[这个在 Github 上不错的示例](https://xooyoozoo.github.io/yolo-octo-bugfixes)。

### 使用工具和算法进行优化

**即便使用了高效的图片格式也需要后续的处理和优化**。这一步很重要。

如果你选择了体积相对较小的 SVG，它们也需要被压缩。[SVGO](https://github.com/svg/svgo) 是一个命令行工具，可以通过剥离不必要的元数据来快速优化 SVG。另外，如果你喜欢 Web 界面或者由于操作系统的限制，也可以使用 [Jake Archibald](https://twitter.com/jaffathecake) 的 [SVGOMG](https://jakearchibald.github.io/svgomg/)。由于 SVG 是基于 XML 的格式，所以它也可以被服务端 GZIP 压缩。

[ImageOptim](https://imageoptim.com/mac) 是大多数其他图片格式的绝佳选择，它将 pngcrush、pngquant、MozJPEG、Google Zopfli 等一些不错的工具打包进了一个综合的开源包里面。作为一个 Mac OS 应用程序、命令行界面和 Sketch 插件，ImageOptim 可以轻松地用于现有的工作流中。大多数 ImageOptim 依赖 CLI 都可以在 Linux 或者 Windows 平台上使用。

如果你倾向于尝试新兴的编码器，今年早些时候，Google 发布了 [Guetzli](https://research.googleblog.com/2017/03/announcing-guetzli-new-open-source-jpeg.html) —— 一个源于他们对 WebP 和 Zopfli 研究的开源算法。**Guetzli 可以生成比任何其他可用的压缩方法少 35% 体积的 JPEG**。唯一的缺点是：处理时间慢（每百万像素的 CPU 时间为一分钟）。

选择工具时，请确保它们能达到预期并适合团队的工作流。最好能自动化优化，这样所有图片都是优化过了的。

### 响应式图片

十年前，也许一种分辨率就能满足所有的场景，但随着时代的变化，响应式网站现今已截然不同。这就是为什么我们必须特别小心地实施我们精心优化的视觉资源，并确保它们适应各种视口和设备。幸运的是，感谢[响应式图像社区组织](https://responsiveimages.org/)，通过 `picture` 元素和 `srcset` 属性（都有 85%+ 的浏览器支持率），我们可以完美地做到。

### srcset 属性

`srcset` 在分辨率切换场景中表现得非常不错 —— 当我们想根据用户的屏幕密度和大小显示图片时。根据 `srcset` 和 `sizes` 属性中一些预定义的规则，浏览器将会根据视口选择最佳的图片进行展示。这种技术可以节省带宽和减少请求，特别是对于移动端用户。

![srcset 属性使用示例](https://cdn-images-1.medium.com/max/800/1*87BIfYsjZTh-bikjmp7eow.png)

### picture 元素

`picture` 元素和 `media` 属性旨在更容易地通往艺术殿堂。通过为不同的条件提供不同的来源（通过 `media-queries` 测试），无论分辨率如何，我们始终能聚焦在最重要的图像元素上。

![picture 元素使用示例](https://cdn-images-1.medium.com/max/800/1*NeyfH6Vu1xCWE2SY5w1cDQ.png)

📚 阅读 [Jason Grigsby](https://twitter.com/grigs) 的[《响应式图片 101》](https://cloudfour.com/thinks/responsive-images-101-definitions/) 可以全面地了解这两种方式。

### 使用图片 CDN

图片性能的最后一步就是分发了。所有资源都可以从使用 CDN 中受益，但有一些特定的工具是专门针对图片的，例如 [Cloudinary](http://cloudinary.com/) 或者 [imgx](https://www.imgix.com/)。使用这些服务的好处远不止于减少服务器流量，它还可以显著减少响应延迟。

**CDN 可以降低重图片站点提供自适应和高性能图片的复杂度**。他们提供的服务各不相同（价格也不同），但是大多数都可以根据设备和浏览器进行尺寸调整、裁剪和确定最合适的格式，甚至更多 —— 压缩、检测像素密度、水印、人脸识别和允许后期处理。借助这些强大的功能和能够将参数附到 URL 中，使得提供以用户为中心的图片变得轻而易举了。

📝 图片性能清单

1. 选择正确的格式
2. 尽可能使用矢量图
3. 如果变化不明显，则降低质量
4. 尝试新格式
5. 使用工具和算法进行优化
6. 学习 `srcset` 属性和 `picture` 元素
7. 使用图片 CDN

## 优化网络字体

使用自定义字体的能力是一个非常强大的设计工具。但权利越大，责任就越大。**68% 的网站正在使用网络字体，而这种资源是最大的性能瓶颈之一**（很容易平均达到 100KB，这取决于字体的各种形态和数量）。

即使体积不是最重要的问题，但**不可见文本闪现**（FOIT）是。当网络字体在加载中或者加载失败时，就会发生 FOIT，这会导致空白页面，从而造成内容无法访问。这可能值得我们[仔细检查是否需要网络字体](https://hackernoon.com/web-fonts-when-you-need-them-when-you-dont-a3b4b39fe0ae)。如果是这样，有一些策略可以帮助我们减轻对性能的负面影响。

### 选择正确的格式

有四种网络字体格式：EOT、TTF、WOFF 和近期的 WOFF2。TTF 和 WOFF 被广泛使用，拥有超过 90% 的浏览器支持率。根据你所针对的支持情况，**使用 WOFF2 可能最安全**，并为老版本浏览器降级使用 WOFF。使用 WOFF2 的优点是一整套自定义的预处理和压缩算法（如 [Brotli](https://github.com/google/brotli)）可以 [缩小 30% 的文件大小](https://docs.google.com/presentation/d/10QJ_GABjwzfwUb5DZ3DULdv82k74QdPArkovYJZ-glc/present?slide=id.g1825bd881_0182)和改进过的解析性能。

在 `@font-face` 中定义网络字体的来源时，使用 `format()` 提示来指定应该使用哪种格式。

如果你正在使用 Google 字体或者 Typekit 字体，他们都实施了一些策略来减轻对性能的影响。Typekit 所有套件现在都支持异步来预防 FOIT，并且允许其 JavaScript 套件代码的缓存期限延长 10 天（而不是默认的 10 分钟）。Google 字体可以根据用户设备自动提供最小的文件。

### 字体选择评测

无论是否自托管，字体的数量、体积和样式都将明显影响性能。
理想情况下，我们只需要一种包括常规和粗体的字体。如果你不确定如何选择字体，可以参考 Lara Hogan 的[《美学与性能》](http://designingforperformance.com/weighing-aesthetics-and-performance/)。

### 使用 Unicode-range 子集

Unicode-range 子集允许将大字体分割成较小的集合。这是一个相对先进的策略，但它可能会明显地减少字体体积，特别是在针对亚洲语言的时候（你知道中文字体的平均字形数是 20,000 吗？）。第一步是将字体限制为必要的语言集，例如拉丁语、希腊语或西里尔语。如果网络字体只是做 LOGO 类的使用，那完全可以使用 Unicode-range 描述符来选择特定的字符。

Filament Group 发布的开源命令行工具 [glyph hanger](https://github.com/filamentgroup/glyphhanger) 可以根据文件或 URL 生成需要的字形列表。或者，基于 web 的 [Font Squirrel Web Font Generator](https://www.fontsquirrel.com/tools/webfont-generator)，它提供高级子集和优化选项。如果使用 Google 字体或者 Typekit，他们在字体选择界面都提供了语言子集的选择，这使得确定基本子集更容易。

### 建立字体加载策略

**字体是阻塞渲染的** —— 因为浏览器需要首先创建 DOM 和 CSSOM；网络字体用于与现有节点相匹配的 CSS 选择器之前，它都不会被下载。这种行为显然延迟了文本的渲染，通常都会导致前面提到的**不可见文本闪现**（FOIT）。在较慢的网络和移动设备上，FOIT 则更加明显。

实施字体加载策略可以避免用户无法访问内容。通常，**无样式文本闪现**（FOUT）是最简单和最有效的解决方案。

`font-display` 是一个新的 CSS 属性，提供了一个不依赖 JavaScript 的解决方案。不幸的是，它只被部分支持（Chrome 和 Opera），Firefox 和 WebKit 目前在开发中。尽管如此，它可以并且应该与其他字体加载机制结合使用。

![font-display 属性示例](https://cdn-images-1.medium.com/max/800/1*Kuky8fVepcjU3tMbTjewdw.png)

幸运的是，Typekit 的[网络字体加载器](https://github.com/typekit/webfontloader) 和 [Bram Stein](https://twitter.com/bram_stein) 的 [字体观察者](https://fontfaceobserver.com/) 可以帮助我们管理字体的加载行为。此外，[Zach Leatherman](https://twitter.com/zachleat) 是网络字体性能的专家，他发布的[《字体加载策略综合指南》](https://www.zachleat.com/web/comprehensive-webfonts)将帮助你为你的项目选择正确的方法。

📝 网络字体性能清单

1. 选择正确的格式
2. 字体选择评测
3. 使用 Unicode-range 子集
4. 建立字体加载策略

## 优化 JavaScript

目前，[JavaScript 包的平均大小为 446KB](http://httparchive.org/trends.php#bytesJS&reqJS)，这使得使其成为第二大体积类型的资源（仅次于图片）。

> 我们可能没有意识到，我们所钟爱的 JavaScript 隐藏着更加危险的性能瓶颈。

### 监控 JavaScript 传输

优化传输只是抗衡页面臃肿的一种方法。JavaScript 下载后，必须由浏览器进行解析、编译和运行。浏览一些热门的网站，我们会发现，gzip 压缩后的 JS **在解压之后至少变大三倍**。实际上，我们正在发送一大堆代码。

![](https://cdn-images-1.medium.com/max/800/1*Yrn4kTkaYHX0PWj4HB-mQg.jpeg)

1MB JavaScript 在不同的设备上的解析时间。图片来源于 Addy Osmani 的[《JavaScript 启动性能》](https://medium.com/reloading/javascript-start-up-performance-69200f43b201)。

分析解析和编译时间，对于理解应用程序何时准备好进行交互至关重要，这些时间因用户设备的硬件能力而异。**解析和编译的时间会很容易地在低端手机上高出 2-5 倍**。[Addy](https://twitter.com/addyosmani) 的研究表明，一个应用程序在普通手机上需要 16 秒才能达到可交互状态，而在桌面上是 8 秒
分析这些指标至关重要，幸运的是，我们可以通过 Chrome 开发者工具来完成。

![在 Chrome 开发者工具中审查解析和编译过程](https://cdn-images-1.medium.com/max/800/1*eV83YP2fnoOllUleaWa5lw.gif)

请务必阅读 Addy Osmani 在[《JavaScript 启动性能》](https://medium.com/reloading/javascript-start-up-performance-69200f43b201)文中的详细总结。

### 移除不必要的依赖

现今的包管理方式可以很容易地隐藏依赖包的数量和大小。[webpack-bundle-analyzer](https://www.npmjs.com/package/webpack-bundle-analyzer) 和 [bundle-buddy](https://www.npmjs.com/package/bundle-buddy) 是很好的可视化工具，可以帮助我们识别出重复代码、最大的性能瓶颈以及过时和不必要的依赖包。

![Webpack bundle analyzer 的示例](https://cdn-images-1.medium.com/max/800/1*dusVhPiL44VDoS4gJHMWSg.gif)

通过 [VS Code](https://marketplace.visualstudio.com/items?itemName=wix.vscode-import-cost) 和 [Atom](https://atom.io/packages/atom-import-cost) 中的 `Import Cost` 扩展，我们可以明显知晓导入包的大小。

![VS Code 中的 Import Cost 拓展](https://cdn-images-1.medium.com/max/800/1*LbfI4D9XXiZYS1Slwsys5g.gif)

### 实施代码分割

只要有可能，**我们就应该只提供用户体验所必需的资源**。向用户发送一个完整的 `bundle.js` 文件，包括他们可能永远看不到的交互效果的处理代码，这不太理想（试想一下，在访问着陆页时，下载了处理整个应用程序的 JavaScript）。同样，我们不应到处提供针对特定浏览器或用户代理的代码。

Webpack 是最受欢迎的打包工具之一，默认支持[代码分割](https://webpack.js.org/guides/code-splitting/)。最简单的代码分割可以按页面实施（例如着陆页面的 `home.js`，联系页面的 `contact.js` 等）。但 Webpack 提供了比较少的高级策略，例如动态导入或者[懒加载](https://webpack.js.org/guides/lazy-loading/)，这可能值得研究。

### 考虑框架选择

JavaScript 的前端框架日新月异。根据 [2016 年的 JavaScript 现状调查](https://stateofjs.com/2016/frontend/)，React 是最受欢迎的。仔细评估架构选型可能会发现，你可以采用更为轻量级的替代方案，例如 Preact（需要注意的是，Preact 并不是一个完整的 React 重新实现，它只是一个具有[高性能](https://github.com/developit/preact-perf)，功能更轻的虚拟 DOM 库）。同样，我们可以将较大的库替换为更小的替代方案 —— `moment.js` 换成 `date-fns`（或者在特定情况下，[删除 `moment.js` 中未使用的 `locales`](https://github.com/distilagency/starward/issues/81)）。

**在开始一个新项目之前，有必要确定什么样的功能是必需的，并为你的需求和目标选择性能最好的框架**。有时这可能意味着选择写更多的原生 JavaScript。

📝 JavaScript 性能清单

1. 监控 JavaScript 传输
2. 移除不必要的依赖
3. 实施代码分割
4. 考虑框架选择

## 性能追踪，前进之路

在大多数情况下，我们讨论过的一些策略会对我们正在打造的产品的用户体验产生积极的变化。性能可能是一个棘手的问题，有必要长期跟踪我们调整的效果。

### 以用户为中心的性能指标

卓越的性能指标，旨在尽可能接近描绘的用户体验。以往的 `onLoad`、`onContentLoaded` 或者 `SpeedIndex` 对于用户多久能与页面进行交互给出的信息非常少。当仅关注资源传输时，我们很难量化[感知得到的性能](https://calibreapp.com/docs/metrics/user-focused-metrics)。幸运的是，有一些时间可以很好地描述内容的可视性和互动性。

这些指标是白屏时间、首次有效渲染、视觉完整和可交互时间。

![](https://cdn-images-1.medium.com/max/800/1*fjqW4fRUD7iIrzcKfUkfIg.png)

- **First Paint 白屏时间**：浏览器从白屏到第一次视觉变化。
- **First Meaningful Paint 首次有效渲染**：文字、图像和主要内容都已可见。
- **Visually Complete 视觉完整**：视口中的所有内容都可见。
- **Time to Interactive 可交互时间**：视口中的所有内容都可见，并且可以进行交互（JavaScript 主线程停止活动）。

这些时间和用户体验息息相关，因此可以作为重点进行追踪。如果可能，将它们全部记录，否则选择一两个来更好地监控性能。其他指标也需要关注，特别是我们发送的字节数（优化和解压缩）。

### 设置性能预算

所有数据可能会很快变得令人困惑和难以理解。没有可执行的目标，很容易迷失我们最初的目的。几年前，[Tim Kadlec](https://twitter.com/tkadlec) 写过关于[《性能预算》](https://timkadlec.com/2013/01/setting-a-performance-budget/)的概念。

遗憾的是，没有什么神奇的公式可以设置它们。性能预算通常归结为竞争分析和产品目标，而这是每个业务所独有的。

设定预算时，重要的是要有明显的差异，通常情况下，至少要有 20% 的改善。实验和迭代你的预算，可以参考 Lara Hogan 的[使用性能预算来接近新设计](http://designingforperformance.com/weighing-aesthetics-and-performance/#approach-new-designs-with-a-performance-budget)。

使用[性能预算计算器](http://www.performancebudget.io/)或者 [Browser Calories](https://browserdiet.com/calories/) Chrome 拓展程序来帮助你创建预算。

### 持续监控

性能监控应该是自动化的，市面上有很多提供全面报告的强大工具。

[Google Lighthouse](https://developers.google.com/web/tools/lighthouse/) 是一个开源项目，它可以审查性能、可访问性、PWA 等。你可以在命令行中或者直接在 Chrome 开发者工具中使用它。

![Lighthouse 性能审查示例](https://cdn-images-1.medium.com/max/800/1*T3HA3VrN48JsCAHWFfnu3g.gif)

对于持续的追踪，可以选择 [Calibre](https://calibreapp.com/)，它提供的性能预算、设备仿真、分布式监控和许多其他功能是我们不在构建自己的性能套件上花费大量精力是完成不了的。

![使用 Calibre 进行全面的性能追踪](https://cdn-images-1.medium.com/max/800/1*LTFZ7zMASCWUz3r0eqXdoQ.gif)

无论你在哪里追踪，请确保数据对于整个团队或者小型组织里的整个业务线都是透明和可访问的。

> 性能是共同的责任，不仅仅是开发团队 —— 我们都应对所创建的用户体验负责，不管是什么角色或职级。

在产品决策或者设计阶段，提倡速度和建立协作流程以发现可能的瓶颈是非常重要的。

### 建立性能意识和同理心
**关心性能不仅仅是一个业务目标**（但如果你需要通过销售统计数据来进行销售，那可以使用 [PWA 统计](https://www.pwastats.com/)）。这关乎于基本的同理心，并把用户的最大利益放在第一位。

> 作为技术人员，我们的责任是，不要让用户的注意力和时间放在等待页面上。我们的目标是，[建立有时间观念和以人为本的工具](http://www.timewellspent.io/)。

提倡性能意识应该是每个人的目标。让我们抱着性能和同理心，为所有人建立一个更好、更有意义的未来吧。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
