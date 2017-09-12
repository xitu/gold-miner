
> * 原文地址：[The State of the Web](https://medium.com/@fox/talk-the-state-of-the-web-3e12f8e413b3)
> * 原文作者：[Karolina Szczur](https://medium.com/@fox?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/talk-the-state-of-the-web.md](https://github.com/xitu/gold-miner/blob/master/TODO/talk-the-state-of-the-web.md)
> * 译者：[undead25](https://github.com/undead25)
> * 校对者：

网络现状：性能提升指南

互联网正在爆发式地增长，我们创建的 Web 平台也是如此。**我们通常都没有考虑到用户网络的连通性和使用情景**。即使是万维网状况的一瞥，也可以看出我们还没有建立起感同身受和形势变化的认知，更不用说性能的考虑了。

那么，现今的网络状况是怎样的呢？

**地球上 74 亿人口中，只有 46% 的人能够上网**，平均网络速度竟有 7Mb/s。更重要的是，93% 的互联网用户都是通过移动设备上网的 —— 不去适应手持设备是不可原谅的。数据往往比我们想象中要昂贵得多 —— 500MB 的数据在德国只要 1 个小时，而在巴西需要 13 个小时（更多有趣的统计可以看看 [Ben Schwarz](https://twitter.com/benschwarz) 的[《泡沫破灭：真实的性能》](https://speakerdeck.com/benschwarz/beyond-the-bubble)）。

**我们的网站表现得也不尽如人意** —— 平均体积大概[是第一版 Doom 游戏的大小](https://www.wired.com/2016/04/average-webpage-now-size-original-doom/)（3 MB 左右）（请注意，为了统计准确度，需要使用[中位数](https://zh.wikipedia.org/wiki/%E4%B8%AD%E4%BD%8D%E6%95%B8)，推荐阅读 [Ilya Grigorik](https://twitter.com/igrigorik) 的 [《“平均页面”是一个神话》](https://www.igvita.com/2016/01/12/the-average-page-is-a-myth/)。中位数统计出的网站体积目前为 1.4MB）。图片可以轻松占用 1.7 MB，而 JavaScript 平均为 400KB。不仅仅只有 Web 平台，本地应用程序也有同样的问题，你是否遇到过为了修复某些 bug，不得不下载 200MB 的应用呢？

**技术人员经常会发现自己处于特权地位**。拥有新型高端的笔记本、手机和快速的网络连接。我们很容易忘记，其实并不是每个人都有这样的条件（实际上只有少部分人而已）。

> 如果我们只站在自己而不是用户的角度来构建 web 平台，那这将导致糟糕的用户体验。

我们如何通过在设计和开发中考虑性能来做得更好呢？

## 资源优化

最能明显提升性能但未被充分利用的方式是，从了解浏览器如何分析和处理资源开始。事实证明，浏览器在资源发现方面表现得非常不错，同时解析和立即确定资源的优先级。下面是关于**关键请求**的解释。

> 如果请求包含用户视图渲染所需的资源，那该请求就是关键请求。

对于大多数网站，关键请求可以是 HTML，必要的 CSS，LOGO，网络字体，也可能是图片。事实证明，在大多数情况下，当资源被请求时，许多其他不相关的（JavaScript，追踪代码，广告等）也被请求了。不过我们能够通过仔细挑选重要资源，并调整它们的优先级来避免这种情况发生。

通过 `<link rel ='preload'>`，我们可以手动强制设置资源的优先级为`高`，来确保所期望的内容按时渲染。 这种技术可以明显改善“交互时间”指标，从而使最佳用户体验成为可能。

![](https://cdn-images-1.medium.com/max/800/1*JT-53LslhwOOqTgv1dGoXg.png)

由于相关资料的缺乏，关键请求对许多人来说似乎仍然是一个黑盒子。幸运的是，[Ben Schwarz](https://twitter.com/benschwarz/) 发表了一篇非常全面且通俗易懂的文章 —— [关键请求](https://css-tricks.com/the-critical-request/)。另外，你也可以查看 Addy 关于预加载的文章 —— [Chrome 中的预加载和优先级](https://medium.com/reloading/preload-prefetch-and-priorities-in-chrome-776165961bbf)。

![在 Chrome 开发者工具中启用优先级](https://cdn-images-1.medium.com/max/800/1*ju18GQzgF-TQDMrYdtPelg.gif)

🛠 要追踪优先处理请求的效果，你可以使用 Lighthouse 性能检测工具和[关键请求链路评测](https://developers.google.com/web/tools/lighthouse/audits/critical-request-chains)，或者查看 Chrome 开发者工具网络标签下的请求优先级。

**📝 常用性能检查表**

1. 主动缓存
2. 启用压缩
3. 优先关键资源
4. 使用 CDN

## 图片优化

Images often account for most of a web page’s transferred payload, which is why imagery optimisation can yield the biggest performance improvements. There are many existing strategies and tools to aid us in removing extra bytes, but the first question to ask is: “Is this image essential to convey the message and effect I’m after?”. If it’s possible to eliminate it, not only we’re saving bandwidth, but also requests.

In some cases, similar results can be achieved with different technologies. CSS has a range of properties for art direction, such as shadows, gradients, animations or shapes allowing us to swap assets for appropriately styled DOM elements.

### Choosing the right format

If it’s not possible to remove an asset, it’s important to determine what format will be appropriate. The initial choice falls between vector and raster graphics:

- **Vector**: resolution independent, usually significantly smaller in size. Perfect for logos, iconography and simple assets comprising of basic shapes (lines, polygons, circles and points).
- **Raster**: offers much more detailed results. Ideal for photographs.

After making this decision, there are a fair bit of formats to choose from: JPEG, GIF, PNG–8, PNG–24, or newest formats such as WEBP or JPEG-XR. With such an abundance of options, how do we ensure we’re picking the right one? Here’s a basic way of finding the best format to go with:

- **JPEG**: imagery with many colours (e.g. photos)
- **PNG–8**: imagery with a few colours
- **PNG–24**: imagery with partial transparency
- **GIF**: animated imagery

Photoshop can optimise each of these on export through various settings such as decreasing quality, reducing noise or number of colours. Ensure that designers are aware of performance practices and can prepare the right type of asset with the right optimisation presets. If you’d like to know more how to develop images, head to [Lara Hogan’s](https://twitter.com/lara_hogan) invaluable [Designing for Performance](http://designingforperformance.com/optimizing-images/#choosing-an-image-format).

### Experimenting with new formats

There are a few newer players in the spectrum of image formats, namely WebP, JPEG 2000 and JPEG-XR. All of them are developed by browser vendors: WebP by Google, JPEG 2000 by Apple and JPEG-XR by Microsoft.

**WebP** is easily the most popular contender, supporting both lossless and lossy compression, which makes it incredibly versatile. **Lossless WebP is 26% smaller than PNGs and 25–34% smaller than JPGs**. With 74% browser support it can safely be used with fallback, introducing up to 1/3 savings in transferred bytes. JPGs and PNGs can be converted to WebP in Photoshop and other image processing apps as well as through command line interfaces (`brew install webp`).

If you’d like to explore (minor) visual differences between these formats I recommend [this nifty demo on Github](https://xooyoozoo.github.io/yolo-octo-bugfixes).

### Optimising with tools and algorithms

**Even using incredibly efficient image formats doesn’t warrant skipping post-processing optimisation**. This step is crucial.

If you’ve chosen SVGs, which are usually relatively small in size, they too have to be compressed. [SVGO](https://github.com/svg/svgo) is a command line tool that can swiftly optimise SVGs through stripping unnecessary metadata. Alternatively, use [SVGOMG](https://jakearchibald.github.io/svgomg/) by [Jake Archibald](https://twitter.com/jaffathecake) if you prefer a web interface or are limited by your operating system. Because SVG is an XML-based format, it can also be subject to GZIP compression on the server side.

[ImageOptim](https://imageoptim.com/mac) is an excellent choice for most of the other image types. Comprising of pngcrush, pngquant, MozJPEG, Google Zopfli and more, it bundles a bunch of great tools in a comprehensive, Open Source package. Available as a Mac OS app, command line interface and Sketch plugin, ImageOptim can be easily implemented into an existing workflow. For those on Linux or Windows, most of the CLIs ImageOptim relies on can be used on your platform.

If you’re inclined to try emerging encoders, earlier this year, Google released [Guetzli](https://research.googleblog.com/2017/03/announcing-guetzli-new-open-source-jpeg.html) — an Open Source algorithm stemming from their learnings with WebP and Zopfli. **Guetzli is supposed to produce up to 35% smaller JPEGs than any other available method of compression**. The only downside: slow processing times (a minute of CPU per megapixel).

When choosing tools make sure they produce desired results and fit into teams’ workflow. Ideally, automate the process of optimisation, so no imagery slips through the cracks unoptimised.

### Responsible and responsive imagery

A decade ago we might have gotten away with one resolution to serve all, but the landscape of ever-changing, responsive web is very different today. That’s why we have to take extra care in implementing visual resources we’ve so carefully optimised and ensuring they cater for the variety of viewports and devices. Fortunately, thanks to [Responsive Images Community Group](https://responsiveimages.org/) we’re perfectly equipped to do so with `picture` element and `srcset` attribute (both have 85%+ support).

### The srcset attribute

`Srcset` works best in the resolution switching scenario—when we want to display imagery based on users’ screen density and size. Based on a set of predefined rules in `srcset` and `sizes` attributes the browser will pick the best image to serve accordingly to the viewport. This technique can bring great bandwidth and request savings, especially for the mobile audience.

![An example of srcset usage](https://cdn-images-1.medium.com/max/800/1*87BIfYsjZTh-bikjmp7eow.png)

### The picture element

`Picture` element and the `media` attribute are designed to make art direction easy. By providing different sources for varying conditions (tested via `media-queries`), we’re able always able to keep the most important elements of imagery in the spotlight, no matter the resolution.

!An example of picture element usage](https://cdn-images-1.medium.com/max/800/1*NeyfH6Vu1xCWE2SY5w1cDQ.png)

📚 Make sure to read [Jason Grigsby’s Responsive Images 101](https://twitter.com/grigs) guide for a thorough explanation of both approaches.

### Delivery with image CDNs

The last step of our journey to performant visuals is delivery. All assets can benefit from using a content delivery network, but there are specific tools targeting imagery, such as [Cloudinary](http://cloudinary.com/) or [imgx](https://www.imgix.com/). The benefit of using those services goes further than reducing traffic on your servers and significantly decreasing response latency.

**CDNs can take out a lot of complexity from serving responsive, optimised assets on image-heavy sites**. The offerings differ (and so does the pricing) but most handle resizing, cropping and determining which format is best to serve to your customers based on devices and browsers. Even more than that — they compress, detect pixel density, watermark, recognise faces and allow post-processing. With these powerful features and ability to append parameters to URLs serving user-centric imagery becomes a breeze.

📝 Image performance checklist

1. Chose the right format
2. Use vector wherever possible
3. Re duce the quality if change is unnoticeable
4. Experiment with new formats
5. Optimise with tools and algorithms
6. Learn about srcset and picture
7. Use an image CDN

## Optimising web fonts

The ability to use custom fonts is an incredibly powerful design tool. But with power comes a lot of responsibility. With whooping **68% of websites leveraging web fonts this type of asset is one of the biggest performance offenders** (easily averaging 100KB, depending on the number of variants and typefaces).

Even when weight isn’t the most major issue, **Flash of Invisible Text** (FOIT) is. FOIT occurs when web fonts are still loading or failed to be fetched, which results in an empty page and thus, inaccessible content. It might be worth it to [carefully examine whether we need web fonts in the first place](https://hackernoon.com/web-fonts-when-you-need-them-when-you-dont-a3b4b39fe0ae). If so, there are a few strategies to help us mitigate the negative effect on performance.

### Choosing the right format

There are four web font formats: EOT, TTF, WOFF and more recent WOFF2. TTF and WOFF are most widely adopted, boasting over 90% browser support. Depending on the support you’re targeting **it’s most likely safe to serve WOFF2** and fall back to WOFF for older browsers. The advantage of using WOFF2 is a set of custom preprocessing and compression algorithms (like [Brotli](https://github.com/google/brotli)) resulting in [approx. 30% file-size reduction](https://docs.google.com/presentation/d/10QJ_GABjwzfwUb5DZ3DULdv82k74QdPArkovYJZ-glc/present?slide=id.g1825bd881_0182) and improved parsing capabilities.

When defining the sources of web fonts in `@font-face` use the `format()` hint to specify which format should be utilised.

If you’re using Google Fonts or Typekit to serve your fonts, both of these tools have implemented a few strategies to mitigate their performance footprint. Typekit now serves all kits asynchronously, preventing FOIT as well as allows for extended cache period of 10 days for their JavaScript kit code (instead of default 10 minutes). Google Fonts automatically serves the smallest file, based on the capabilities of the users’ device.

### Audit font selection

No matter whether self-hosting or not, the number of typefaces, font weights and styles will significantly affect your performance budgets.
Ideally, we can get away with one typeface featuring normal and bold stylistic variants. If you’re not sure how to make font selection choices refer to Lara Hogan’s [Weighing Aesthetics and Performance](http://designingforperformance.com/weighing-aesthetics-and-performance/).

### Use Unicode-range subsetting

Unicode-range subsetting allows splitting large fonts into smaller sets. It’s a relatively advanced strategy but might bring significant savings especially when targeting Asian languages (did you know Chinese fonts average at 20,000 glyphs?). The first step is to limit the font to the necessary language set, such as Latin, Greek or Cyrillic. If a web font is required only for logotype usage, it’s worth it to use Unicode-range descriptor to pick specific characters.

The Filament Group released an Open Source command-line utility, [glyph hanger](https://github.com/filamentgroup/glyphhanger) that can generate a list of necessary glyphs based on files or URLs. Alternatively, the web-based [Font Squirrel Web Font Generator](https://www.fontsquirrel.com/tools/webfont-generator) offers advanced subsetting and optimisation options. If using Google Fonts or Typekit choosing a language subset is built into the typeface picker interface, making basic subsetting easier.

### Establish a font loading strategy

**Fonts are render-blocking** — because the browser has to build both the DOM and CSSOM first; web fonts won’t be downloaded before they’re used in a CSS selector that matches an existing node. This behaviour significantly delays text rendering, often causing the **Flash of Invisible Text** (FOIT) mentioned before. FOIT is even more pronounced on slower networks and mobile devices.

Implementing a font loading strategy prevents users from not being able to access your content. Often, opting for **Flash of Unstyled Text** (FOUT) is the easiest and most effective solution.

`font-display` is a new CSS property providing a non-JavaScript reliant solution. Unfortunately, it has partial support (Chrome and Opera only) and is currently under development in Firefox and WebKit. Still, it can and should be used in combination with other font loading mechanisms.

![font-display property in action](https://cdn-images-1.medium.com/max/800/1*Kuky8fVepcjU3tMbTjewdw.png)

Luckily, Typekit’s [Web Font Loader](https://github.com/typekit/webfontloader) and [Bram Stein’s](https://twitter.com/bram_stein) [Font Face Observer](https://fontfaceobserver.com/) can help manage font loading behaviour. Additionally, [Zach Leatherman](https://twitter.com/zachleat), an expert on web font performance, published [A Comprehensive Guide to Font Loading Strategies](https://www.zachleat.com/web/comprehensive-webfonts) which will aid in choosing the right approach for your project.

📝 Web font performance checklist

1. Chose the right format
2. Audit the font selection
3. Use Unicode-range subsetting
4. Establish a font loading strategy

## Optimising JavaScript

At the moment, [the average size of JavaScript bundle is 446 KB](http://httparchive.org/trends.php#bytesJS&reqJS), which already makes it second biggest type of an asset size-wise (following images).

> What we might not realise is that there’s a much more sinister performance bottleneck hidden behind our beloved JavaScript.

### Monitor how much JavaScript is delivered

Optimising delivery is only one step in combating web page bloat. After JavaScript is downloaded, it has to be parsed, compiled and run by the browser. A quick look at a few popular sites and it becomes obvious that `gzipped` JS becomes **at least three times bigger after unpacking**. Effectively, we are sending giant blobs of code down the wire.

![](https://cdn-images-1.medium.com/max/800/1*Yrn4kTkaYHX0PWj4HB-mQg.jpeg)

Parse times for 1MB of JavaScript on different devices. Image courtesy of Addy Osmani and his [JavaScript Start-up Performance](https://medium.com/reloading/javascript-start-up-performance-69200f43b201) article.

Analysing parse and compile times becomes crucial to understanding when apps are ready to be interacted with. These timings vary significantly based the hardware capabilities of users’ device. **Parse and compile can easily be 2–5x times higher on lower end mobiles**. [Addy’s](https://twitter.com/addyosmani) research confirms that on an average phone an app will take 16 seconds to reach an interactive state, compared to 8 seconds on a desktop. It’s crucial to analyse these metrics, and fortunately, we can do so through Chrome DevTools.

![Investigating parse and compile in Chrome Dev Tools](https://cdn-images-1.medium.com/max/800/1*eV83YP2fnoOllUleaWa5lw.gif)

📚 Make sure to read Addy Osmani’s detailed write-up on [JavaScript Start-up Performance](https://medium.com/reloading/javascript-start-up-performance-69200f43b201).

### Get rid of unnecessary dependencies

The way modern package managers work can easily obscure the number and the size of dependencies. [webpack-bundle-analyzer](https://www.npmjs.com/package/webpack-bundle-analyzer) and Bundle Buddy are great, visual tools helping identify code duplication, biggest performance offenders and outdated, unnecessary dependencies.

![Webpack bundle analyzer in action.](https://cdn-images-1.medium.com/max/800/1*dusVhPiL44VDoS4gJHMWSg.gif)

We can make imported package cost even more visible with `Import Cost` extension in [VS Code](https://marketplace.visualstudio.com/items?itemName=wix.vscode-import-cost) and [Atom](https://atom.io/packages/atom-import-cost).

![Import Code VS Code extension.](https://cdn-images-1.medium.com/max/800/1*LbfI4D9XXiZYS1Slwsys5g.gif)

### Implement code splitting

Whenever possible, **we should only serve the necessary assets to create the desired user experience**. Sending a full `bundle.js` file to the user, including code handling interactions they might never see is less than optimal (imagine downloading JavaScript handling an entire app when visiting a landing page). Similarly, we shouldn’t be universally serving code targeting specific browsers or user agents.

Webpack, one of the most popular module bundlers, comes with [code splitting support](https://webpack.js.org/guides/code-splitting/). Most straightforward code splitting can be implemented per page (`home.js` for a landing page, `contact.js` for a contact page, etc.), but Webpack offers few advanced strategies like dynamic imports or [lazy loading](https://webpack.js.org/guides/lazy-loading/) that might be worth looking into as well.

### Consider framework alternatives

JavaScript front-end frameworks are constantly on the rise. According to the [State of JavaScript 2016 survey](https://stateofjs.com/2016/frontend/) React is the most popular option. Carefully auditing architecture choices though might show that you’d be better off with a much more lightweight alternative such as [Preact](https://preactjs.com/) (note that Preact isn’t trying to be a full React reimplementation, just a [highly performant](https://github.com/developit/preact-perf), less featured virtual DOM library). Similarly, we can swap bigger libraries for smaller altrnatives — `moment.js` for `date-fns` (or in particular case of `moment.js` [remove unused](https://github.com/distilagency/starward/issues/81) `locales`).

**Before starting a new project, it’s worthwhile to determine what kind of features are necessary and pick the most performant framework for your needs and goals**. Sometimes that might mean opting for writing more vanilla JavaScript instead.

📝 JavaScript performance checklist

1. Monitor how much JavaScript is delivered
2. Get rid of unnecessary dependencies
3. Implement code splitting
4. Consider framework alternatives

## Tracking performance and the road forward

We’ve talked about several strategies that in most cases will yield positive changes to the user experience of products we’re building. Performance can be a tricky beast though, and it’s necessary to track the long-term results of our tweaks.

### User-centric performance metrics

Great performance metrics aim to be as close to portraying user experience as possible. Long established `onLoad`, `onContentLoaded` or `SpeedIndex` tell us very little about how soon sites can be interacted with. When focusing only on the delivery of assets, it’s not easy to quantify [perceived performance](https://calibreapp.com/docs/metrics/user-focused-metrics). Fortunately, there are a few timings that paint quite a comprehensive picture of how soon content is both visible and interactive.

Those metrics are First Paint, First Meaningful Paint, Visually Complete and Time to Interactive.

![](https://cdn-images-1.medium.com/max/800/1*fjqW4fRUD7iIrzcKfUkfIg.png)

- **First Paint**: the browser changed from a white screen to the first visual change.
- **First Meaningful Paint**: text, images and major items are viewable.
- **Visually Complete**: all content in the viewport is visible.
- **Time to Interactive**: all content in the viewport is visible and ready to interact with (no major main thread JavaScript activity).
- 
These timings directly correspond to what the users see therefore make excellent candidates for tracking. If possible, record all, otherwise pick one or two to have a better understanding of perceived performance. It’s worth keeping an eye on other metrics as well, especially the number of bytes (optimised and unpacked) we’re sending.

### Setting performance budgets

All of these figures might quickly become confusing and cumbersome to understand. Without actionable goals and targets, it’s easy to lose track of what we’re trying to achieve. A good few years ago [Tim Kadlec](https://twitter.com/tkadlec) wrote about the concept of [performance budgets](https://timkadlec.com/2013/01/setting-a-performance-budget/).

Unfortunately, there’s no magical formula for setting them. Often performance budgets boil down to competitive analysis and product goals, which are unique to each business.

When setting budgets, it’s important to aim for a noticeable difference, which usually equals to at least 20% improvement. Experiment and iterate on your budgets, leveraging Lara Hogan’s [Approach New Designs with a Performance Budget](http://designingforperformance.com/weighing-aesthetics-and-performance/#approach-new-designs-with-a-performance-budget) as a reference.

🛠 Try out [Performance Budget Calculator](http://www.performancebudget.io/) or [Browser Calories](https://browserdiet.com/calories/) Chrome extension to aid in creating budgets.

### Continuous monitoring

Monitoring performance shouldn’t be manual. There are quite a few powerful tools offering comprehensive reporting.

[Google Lighthouse](https://developers.google.com/web/tools/lighthouse/) is an Open Source project auditing performance, accessibility, progressive web apps, and more. It’s possible to use Lighthouse in the command line or as just recently, directly in Chrome Developer Tools.

![Lighthouse performing a performance audit.](https://cdn-images-1.medium.com/max/800/1*T3HA3VrN48JsCAHWFfnu3g.gif)

For continuous tracking opt-in for [Calibre](https://calibreapp.com/) that offers performance budgets, device emulation, distributed monitoring and many other features that are impossible to get without carefully building your own performance suite.

![Comprehensive performance tracking in Calibre.](https://cdn-images-1.medium.com/max/800/1*LTFZ7zMASCWUz3r0eqXdoQ.gif)

Wherever you’re tracking, make sure to make the data transparent and accessible to the entire team, or in smaller organisations, the whole business.

> Performance is a shared responsibility, which spans further than developer teams — we’re all accountable for the user experience we’re creating, no matter role or title.

It’s incredibly important to advocate for speed and establish collaboration processes to catch possible bottlenecks as early as product decisions or design phases.

**Building performance awareness and empathy
Caring about performance isn’t only a business goal** (but if you need to sell it through sales statistics do so with [PWA Stats](https://www.pwastats.com/)). It’s about fundamental empathy and putting the best interest of the users first.

> As technologists, it’s our responsibility not to hijack attention and time people could be happily spending elsewhere. Our objective is to [build tools that are conscious of time and human focus](http://www.timewellspent.io/).

Advocating for performance awareness should be everyone’s goal. Let’s build a better, more mindful future for all of us with performance and empathy in mind.


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
