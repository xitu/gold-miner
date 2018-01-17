> * 原文地址：[Front-End Performance Checklist 2018 - Part 2](https://www.smashingmagazine.com/2018/01/front-end-performance-checklist-2018-pdf-pages/)
> * 原文作者：[Vitaly Friedman](https://www.smashingmagazine.com/author/vitaly-friedman)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/front-end-performance-checklist-2018-2.md](https://github.com/xitu/gold-miner/blob/master/TODO/front-end-performance-checklist-2018-2.md)
> * 译者：
> * 校对者：

# Front-End Performance Checklist 2018 - Part 2
# 前端性能目录2 2018

Below you’ll find an overview of the front-end performance issues you mightneed to consider to ensure that your response times are fast and smooth.
下面你将会前端性能问题的总览，

- [Front-End Performance Checklist 2018 - Part 1](https://github.com/xitu/gold-miner/blob/master/TODO/front-end-performance-checklist-2018-1.md)
- [Front-End Performance Checklist 2018 - Part 2](https://github.com/xitu/gold-miner/blob/master/TODO/front-end-performance-checklist-2018-2.md)
- [Front-End Performance Checklist 2018 - Part 3](https://github.com/xitu/gold-miner/blob/master/TODO/front-end-performance-checklist-2018-3.md)
- [Front-End Performance Checklist 2018 - Part 4](https://github.com/xitu/gold-miner/blob/master/TODO/front-end-performance-checklist-2018-4.md)

- [前端性能目录1 2018](https://github.com/xitu/gold-miner/blob/master/TODO/front-end-performance-checklist-2018-1.md)
- [前端性能目录2 2018](https://github.com/xitu/gold-miner/blob/master/TODO/front-end-performance-checklist-2018-2.md)
- [前端性能目录3 2018](https://github.com/xitu/gold-miner/blob/master/TODO/front-end-performance-checklist-2018-3.md)
- [前端性能目录4 2018](https://github.com/xitu/gold-miner/blob/master/TODO/front-end-performance-checklist-2018-4.md)

***

11. **Will you be using AMP or Instant Articles?**
11. **你会使用 AMP 和 Instant Articles 么？**

Depending on the priorities and strategy of your organization, you might want to consider using Google's [AMP](https://www.ampproject.org/) or Facebook's [Instant Articles](https://instantarticles.fb.com/) or Apple's [Apple News](https://www.apple.com/news/). You can achieve good performance without them, but AMP does provide a solid performance framework with a free content delivery network (CDN), while Instant Articles will boost your visibility and performance on Facebook.
依赖于你的组织优先性和战略性，你可能想考虑使用谷歌的 [AMP](https://www.ampproject.org/)和 Facebook 的[Instant Articles](https://instantarticles.fb.com/)或者苹果的[苹果的新闻](https://www.apple.com/news/)。没有它们，你可以实现很好的性能，但是 AMP 通过免费的内容分发网络(CDN)提供一个稳定的性能框架，而且在 Facebook 上，即时文章将会改善你的关注度和性能。

The main benefit of these technologies for users is _guaranteed performance_, so at times they might even prefer AMP-/Apple News/Instant Pages-links over "regular" and potentially bloated pages. For content-heavy websites that are dealing with a lot of third-party content, these options could help speed up render times dramatically.
对于用户而言，这些技术主要的优势是确保性能，但是有时他们宁愿喜欢 AMP-/Apple News/Instant Pages-链路，也不愿是“规则”和潜在的臃肿页面。对于以内容为主的网站，主要处理很多第三方法内容，这些选择有助于加速渲染的时间。

A benefit for the website owner is obvious: discoverability of these formats on their respective platforms and [increased visibility in search engines](https://ethanmarcotte.com/wrote/ampersand/). You could build [progressive web AMPs](https://www.smashingmagazine.com/2016/12/progressive-web-amps/), too, by reusing AMPs as a data source for your PWA. Downside? Obviously, a presence in a walled garden places developers in a position to produce and maintain a separate version of their content, and in case of Instant Articles and Apple News [without actual URLs](https://www.w3.org/blog/TAG/2017/07/27/distributed-and-syndicated-content-whats-wrong-with-this-picture/). _(thanks Addy, Jeremy!)_
对于网站的所有者优势是明显的：在各个平台规范的可发现性和[增加搜索引擎的可用性](https://ethanmarcotte.com/wrote/ampersand/)。你也可以通过使用 AMP 作为针对你自己的 PWA 来构建[响应式 web AMPs](https://www.smashingmagazine.com/2016/12/progressive-web-amps/)。下降趋势？显然，在一个有围墙的区域里，开发商可以创造并维持其内容的单独版本，防止 Instant Articles 和 Apple News [没有实际的URLs](https://www.w3.org/blog/TAG/2017/07/27/distributed-and-syndicated-content-whats-wrong-with-this-picture/)。_(谢谢 Addy，Jeremy)_

12. **Choose your CDN wisely.**
12. **明智地选择你的 CDN**

Depending on how much dynamic data you have, you might be able to "outsource" some part of the content to a [static site generator](https://www.smashingmagazine.com/2015/11/static-website-generators-jekyll-middleman-roots-hugo-review/), pushing it to a CDN and serving a static version from it, thus avoiding database requests. You could even choose a [static-hosting platform](https://www.smashingmagazine.com/2015/11/modern-static-website-generators-next-big-thing/) based on a CDN, enriching your pages with interactive components as enhancements ([JAMStack](https://jamstack.org/)).
根据你拥有的动态数据量，你可以将部分内容外包给[静态站点生成器](https://www.smashingmagazine.com/2015/11/static-website-generators-jekyll-middleman-roots-hugo-review/)，将其放在 CDN 中或者充当一个静态版本。因此可以避免数据的请求。你甚至可以选择一个基于 CDN 的[静态主机平台](https://www.smashingmagazine.com/2015/11/modern-static-website-generators-next-big-thing/)，丰富你的页面交互组件作为增强([jamstack](https://jamstack.org/))。

Notice that CDNs can serve (and offload) dynamic content as well. So, restricting your CDN to static assets is not necessary. Double-check whether your CDN performs compression and conversion (e.g. image optimization in terms of formats, compression and resizing at the edge), smart HTTP/2 delivery, edge-side includes, which assemble static and dynamic parts of pages at the CDN's edge (i.e. the server closest to the user), and other tasks.
注意，CDN也可以服务（卸载）动态内容。因此，限制你的 CDN 到静态资源是不必要的。仔细检查你的CDN是否进行压缩和转换（比如：图像优化方面的格式，压缩和调整边缘的大小），智能HTTP/2交付，边侧包括，在CDN边缘组装页面的静态和动态部分（比如：离用户最近的服务端），和其他任务。

### Build Optimizations
### 构建优化

13. **Set your priorities straight.**
13. **分清轻重缓急**

It's a good idea to know what you are dealing with first. Run an inventory of all of your assets (JavaScript, images, fonts, third-party scripts and "expensive" modules on the page, such as carousels, complex infographics and multimedia content), and break them down in groups.
优先知道你在处理什么是个好主意。管理你所有资产的清单（JavaScript，图片，字体，第三方脚本和页面中“昂贵的”模块，比如：旋转木马，复杂的图表和多媒体内容），并将它们划分成组。

Set up a spreadsheet. Define the basic _core_ experience for legacy browsers (i.e. fully accessible core content), the _enhanced_ experience for capable browsers (i.e. the enriched, full experience) and the _extras_ (assets that aren't absolutely required and can be lazy-loaded, such as web fonts, unnecessary styles, carousel scripts, video players, social media buttons, large images). We published an article on "[Improving Smashing Magazine's Performance](https://www.smashingmagazine.com/2014/09/improving-smashing-magazine-performance-case-study/)," which describes this approach in detail.
建立电子表格。针对传统的浏览器，定义基本的_核心_体验（比如：完全可访问的核心内容），针对多功能浏览器_提升_体验（比如：丰富多彩的，完美的体验）和其他的（不是绝对需要而且可以被延迟加载的资源，如Web字体、不必要的样式、旋转木马脚本、视频播放器、社交媒体按钮、大型图像。）。我们在“[Improving Smashing Magazine's Performance](https://www.smashingmagazine.com/2014/09/improving-smashing-magazine-performance-case-study/)”发布了一篇文章，上面详细描述了该方法。

14. **Consider using the "cutting-the-mustard" pattern.**
14. **考虑使用“cutting-the-mustard”模式**

Albeit quite old, we can still use the [cutting-the-mustard technique](http://responsivenews.co.uk/post/18948466399/cutting-the-mustard) to send the core experience to legacy browsers and an enhanced experience to modern browsers. Be strict in loading your assets: Load the core experience immediately, then enhancements, and then the extras. Note that the technique deduces device capability from browser version, which is no longer something we can do these days.
虽然很老，但我们仍然可以使用[cutting-the-mustard 技术](http://responsivenews.co.uk/post/18948466399/cutting-the-mustard)将核心经验带到传统浏览器并增强对现代浏览器的体验。严格要求加载的资源：优先加载核心传统的，然后是提升的，最后是其他的。该技术从浏览器版本中演变成了设备功能，这已经不是我们现在能做的事了。

For example, cheap Android phones in developing countries mostly run Chrome and will cut the mustard despite their limited memory and CPU capabilities. That's where [PRPL pattern](https://developers.google.com/web/fundamentals/performance/prpl-pattern/) could serve as a good alternative. Eventually, using the [Device Memory Client Hints Header](https://github.com/w3c/device-memory), we'll be able to target low-end devices more reliably. At the moment of writing, the header is supported only in Blink (it goes for [client hints](https://caniuse.com/#search=client%20hints) in general). Since Device Memory also has a JavaScript API which is [already available in Chrome](https://developers.google.com/web/updates/2017/12/device-memory), one option could be to feature detect based on the API, and fallback to "cutting the mustard" technique only if it's not supported (_thanks, Yoav!_)
例如：在发展中国家，廉价的安卓手机主要运行Chrome，尽管他们的内存和CPU有限。这就是[PRPL 模式](https://developers.google.com/web/fundamentals/performance/prpl-pattern/)可以作为一个好的选择。因此，使用[设备内存客户端提示头](https://github.com/w3c/device-memory)，我们将能够更可靠地针对低端设备。在写作的过程中，只有在 Blink 中才支持 header(Blink 支持[客户端提示](https://caniuse.com/#search=client%20hints))。因为设备存储也有一个在 [Chrome 中可以调用的](https://developers.google.com/web/updates/2017/12/device-memory) JavaScript API，一种选择是基于 API 的特性检测，只在不支持的情况下回退到“cutting the mustard”技术（_谢谢，Yoav！_）。

15. **Parsing JavaScript is expensive, so keep it small.**
15. **解析 JavaScript 的代价很大，应保持其较小**

When dealing with single-page applications, you might need some time to initialize the app before you can render the page. Look for modules and techniques to speed up the initial rendering time (for example, [here's how to debug React performance](https://building.calibreapp.com/debugging-react-performance-with-react-16-and-chrome-devtools-c90698a522ad), and [here's how to improve performance in Angular](https://www.youtube.com/watch?v=p9vT0W31ym8)), because most performance issues come from the initial parsing time to bootstrap the app.
但我们处理单页面应用时，在你可以渲染页面时，你需要一些时间来初始化 app。寻找模块和技术加快初始化渲染时间（例如：[这里是如何调试 React 性能](https://building.calibreapp.com/debugging-react-performance-with-react-16-and-chrome-devtools-c90698a522ad)，以及[如何提高 Angular 性能](https://www.youtube.com/watch?v=p9vT0W31ym8)），因为大多数性能问题来自于启动应用程序的初始解析时间。

[JavaScript has a cost](https://youtu.be/_srJ7eHS3IM?t=9m33s), but it's not necessarily the file size that drains on performance. Parsing and executing times vary significantly depending on the hardware of a device. On an average phone (Moto G4), a parsing time alone for 1MB of (uncompressed) JavaScript will be around 1.3–1.4s, with 15–20% of all time on mobile spent on parsing. With compiling in play, just prep work on JavaScript takes 4s on average, with around 11s before First Meaningful Paint on mobile. Reason: [parse and execution times can easily be 2–5x times higher](https://medium.com/reloading/javascript-start-up-performance-69200f43b201) on low-end mobile devices.
[JavaScript 有成本](https://youtu.be/_srJ7eHS3IM?t=9m33s),但不一定是文件大小会影响性能。解析和执行时间的不同很大程度依赖设备的硬件。在一个普通的手机上（Moto G4），仅解析 1MB （未压缩的）的 JavaScript 大概需要 1.3-1.4 秒，会有 15 - 20% 的时间耗费在手机的解析上。在执行编译过程中，只是用在JavaScript准备平均需要 4 秒，在手机上绘排需要11秒。解释：在低端移动设备上，[解析和执行时间可以轻松提高2至5倍](https://medium.com/reloading/javascript-start-up-performance-69200f43b201)。

An interesting way of avoiding parsing costs is to use [binary templates](https://emberjs.com/blog/2017/10/10/glimmer-progress-report.html#toc_binary-templates) that Ember has recently introduced for experimentation. These templates don't need to be parsed. (_Thanks, Leonardo!_)
一种巧妙的避免解析代价发的方式是使用[二进制模板](https://emberjs.com/blog/2017/10/10/glimmer-progress-report.html#toc_binary-templates)，Ember 最近推出了实验。这些模板不需要解析。（_感谢，Leonardo！_）

That's why it's critical to examine every single JavaScript dependency, and tools like [webpack-bundle-analyzer](https://www.npmjs.com/package/webpack-bundle-analyzer), [Source Map Explorer](https://github.com/danvk/source-map-explorer) and [Bundle Buddy](https://github.com/samccone/bundle-buddy) can help you achieve just that. [Measure JavaScript parse and compile times](https://medium.com/reloading/javascript-start-up-performance-69200f43b201#7557). Etsy's [DeviceTiming](https://github.com/danielmendel/DeviceTiming), a little tool allowing you to instruct your JavaScript to measure parse and execution time on any device or browser. Bottom line: while size matters, it isn't everything. Parse and compiling times [don't necessarily increase linearly](https://medium.com/reloading/javascript-start-up-performance-69200f43b201) when the script size increases.
这就是检查每个JavaScript依赖性的关键，工具像[webpack-bundle-analyzer](https://www.npmjs.com/package/webpack-bundle-analyzer)，[Source Map Explorer](https://github.com/danvk/source-map-explorer)和[Bundle Buddy](https://github.com/samccone/bundle-buddy)可以帮助你完成这些。[度量  JavaScript 解析和编译时间](https://medium.com/reloading/javascript-start-up-performance-69200f43b201#7557)。Etsy 的 [DeviceTiming](https://github.com/danielmendel/DeviceTiming)，一个小工具允许您指示JavaScript在任何设备或浏览器上测量解析和执行时间。重要的是，虽然大小重要，但它不是一切。解析和编译时间并不是随着脚本大小增加而[线性增加](https://medium.com/reloading/javascript-start-up-performance-69200f43b201)。

<figure class="video-container"><iframe src="https://player.vimeo.com/video/249525818" width="640" height="384" frameborder="0" webkitallowfullscreen="" mozallowfullscreen="" allowfullscreen=""></iframe>

[Webpack Bundle Analyzer](https://www.npmjs.com/package/webpack-bundle-analyzer) visualizes JavaScript dependencies.

16. **Are you using an ahead-of-time compiler?**
16. **你使用预编译器么？**

Use an [ahead-of-time compiler](https://www.lucidchart.com/techblog/2016/09/26/improving-angular-2-load-times/) to [offload some of the client-side rendering](https://www.smashingmagazine.com/2016/03/server-side-rendering-react-node-express/) to the [server](http://redux.js.org/docs/recipes/ServerRendering.html) and, hence, output usable results quickly. Finally, consider using [Optimize.js](https://github.com/nolanlawson/optimize-js) for faster initial loading by wrapping eagerly invoked functions (it [might not be necessary](https://twitter.com/tverwaes/status/809788255243739136) any longer, though).
使用[预编译器](https://www.lucidchart.com/techblog/2016/09/26/improving-angular-2-load-times/)来[减轻从客户端](https://www.smashingmagazine.com/2016/03/server-side-rendering-react-node-express/)到[服务端的渲染](http://redux.js.org/docs/recipes/ServerRendering.html)，因此快速输出有用的结果。

17. **Are you using tree-shaking, scope hoisting and code-splitting?**
17. **你使用 tree-shaking，scope hoisting，code-splitting 么**

[Tree-shaking](https://medium.com/@roman01la/dead-code-elimination-and-tree-shaking-in-javascript-build-systems-fb8512c86edf) is a way to clean up your build process by only including code that is actually used in production and eliminate unused exports [in Webpack](http://www.2ality.com/2015/12/webpack-tree-shaking.html). With Webpack 3 and Rollup, we also have [scope hoisting](https://medium.com/webpack/brief-introduction-to-scope-hoisting-in-webpack-8435084c171f) that allows both tools to detect where `import` chaining can be flattened and converted into one inlined function without compromising the code. With Webpack 4, you can now use [JSON Tree Shaking](https://react-etc.net/entry/json-tree-shaking-lands-in-webpack-4-0) as well. [UnCSS](https://github.com/giakki/uncss) or [Helium](https://github.com/geuis/helium-css) can help you remove unused styles from CSS.
[Tree-shaking](https://medium.com/@roman01la/dead-code-elimination-and-tree-shaking-in-javascript-build-systems-fb8512c86edf)是一种通过只加载生产中确实被使用的代码和[在 Webpack 中](http://www.2ality.com/2015/12/webpack-tree-shaking.html)清除无用部分，来整理你构建过程的方法。使用 Webpack 3 和 Rollup，我们还可以[提升作用域](https://medium.com/webpack/brief-introduction-to-scope-hoisting-in-webpack-8435084c171f)允许工具检测 `import` 链接以及可以转换成一个内联函数，其代码没有折中。有了 Webpack 4，你现在可以使用[JSON Tree Shaking](https://react-etc.net/entry/json-tree-shaking-lands-in-webpack-4-0)。[UnCSS](https://github.com/giakki/uncss) or [Helium](https://github.com/geuis/helium-css)可以帮助你去删除未使用CSS样式。

Also, you might want to consider learning how to [write efficient CSS selectors](http://csswizardry.com/2011/09/writing-efficient-css-selectors/) as well as how to [avoid bloat and expensive styles](https://benfrain.com/css-performance-revisited-selectors-bloat-expensive-styles/). Feeling like going beyond that? You can also use Webpack to shorten the class names and use scope isolation to [rename CSS class names dynamically](https://medium.freecodecamp.org/reducing-css-bundle-size-70-by-cutting-the-class-names-and-using-scope-isolation-625440de600b) at the compilation time.
而且，你想考虑学习如何[编写有效的 CSS 选择器](http://csswizardry.com/2011/09/writing-efficient-css-selectors/)以及如何[避免庞大的代价大的样式](https://benfrain.com/css-performance-revisited-selectors-bloat-expensive-styles/)。感觉好像超越了这个？你也可以使用 Webpack 缩短类名和在编译时使用作用域孤立来[动态地重命名 CSS 类名](https://medium.freecodecamp.org/reducing-css-bundle-size-70-by-cutting-the-class-names-and-using-scope-isolation-625440de600b)

[Code-splitting](https://webpack.github.io/docs/code-splitting.html) is another Webpack feature that splits your code base into "chunks" that are loaded on demand. Not all of the JavaScript has to be downloaded, parsed and compiled right away. Once you define split points in your code, Webpack can take care of the dependencies and outputted files. It enables you to keep the initial download small and to request code on demand, when requested by the application. Also, consider using [preload-webpack-plugin](https://github.com/GoogleChromeLabs/preload-webpack-plugin) that takes routes you code-split and then prompts browser to preload them using `<link rel="preload">` or `<link rel="prefetch">`.
[Code-splitting](https://webpack.github.io/docs/code-splitting.html)是另一种 Webpack 特性，可以基于“chunks”分割你的代码然后按需加载这些代码块。并不是所有的 JavaScript 必须下载，解析和编译的。一旦在你的代码中确定了分割点，Webpack会全权负责这些依赖关系和输出文件。在应用发送请求的时候，这样基本上确保初始的下载足够小并且实现按需加载。另外，考虑使用[preload-webpack-plugin](https://github.com/GoogleChromeLabs/preload-webpack-plugin)获取代码拆分的路径，然后使用 `<link rel="preload">` or `<link rel="prefetch">` 提示浏览器预加载它们。

Where to define split points? By tracking which chunks of CSS/JavaScript are used, and which aren't used. Umar Hansa [explains](https://vimeo.com/235431630#t=11m37s) how you can use Code Coverage from Devtools to achieve it.
在哪里定义分离点？通过追踪使用哪些 CSS/JavaScript 块和哪些没有使用。Umar Hansa [解释了](https://vimeo.com/235431630#t=11m37s)你如何可以使用Devtools代码覆盖率来实现。

If you aren't using Webpack, note that [Rollup](http://rollupjs.org/) shows significantly better results than Browserify exports. While we're at it, you might want to check out [Rollupify](https://github.com/nolanlawson/rollupify), which converts ECMAScript 2015 modules into one big CommonJS module — because small modules can have a [surprisingly high performance cost](https://nolanlawson.com/2016/08/15/the-cost-of-small-modules/) depending on your choice of bundler and module system.
如果你没有使用 Webpack，值得注意的是相比于 Browserify 输出结果 [Rollup](http://rollupjs.org/)展现的更加优秀。当使用 Rollup 时，我们会想要查看 [Rollupify](https://github.com/nolanlawson/rollupify)，它可以转化 ECMAScript 2015 modules 为一个大的 CommonJS module——因为取决于打包工具和模块加载系统的选择，小的模块会有[令人惊讶的高性能开销](https://nolanlawson.com/2016/08/15/the-cost-of-small-modules/)。

!['Fast By Default: Modern Loading Best Practices' by Addy Osmani](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/31237c37-d7db-4faa-9849-51657e122331/babel-preset-opt.png)
![Addy Osmani 的'默认快速：现代负载最佳实践'](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/31237c37-d7db-4faa-9849-51657e122331/babel-preset-opt.png)

From [Fast By Default: Modern Loading Best Practices](https://speakerdeck.com/addyosmani/fast-by-default-modern-loading-best-practices) by the one-and-only Addy Osmani. Slide 76.
Addy Osmani 的从[快速默认：现代加载的最佳实践]（https://speakerdeck.com/addyosmani/fast-by-default-modern-loading-best-practices）。幻灯片76。

Finally, with ES2015 being [remarkably well supported in modern browsers](http://kangax.github.io/compat-table/es6/), consider [using `babel-preset-env`](http://2ality.com/2017/02/babel-preset-env.html) to only transpile ES2015+ features unsupported by the modern browsers you are targeting. Then [set up two builds](https://gist.github.com/newyankeecodeshop/79f3e1348a09583faf62ed55b58d09d9), one in ES6 and one in ES5\. We can [use `script type="module"`](https://matthewphillips.info/posts/loading-app-with-script-module) to let browsers with ES module support loading the file, while older browser could load legacy builds with `script nomodule`.
最后，随着[现代浏览器](http://kangax.github.io/compat-table/es6/) 对 ES2015 支持越来越好，考虑[使用`babel-preset-env`](http://2ality.com/2017/02/babel-preset-env.html) 只有 transpile ES2015+ 特色不支持现代浏览器的目标。然后[设置两个构建](https://gist.github.com/newyankeecodeshop/79f3e1348a09583faf62ed55b58d09d9)，一个在 ES6 一个在 ES5\。我们可以[使用`script type="module"`](https://matthewphillips.info/posts/loading-app-with-script-module)让具有 ES 模块浏览器支持加载文件，而老的浏览器可以加载传统的建立`script nomodule`。

For lodash, [use `babel-plugin-lodash`](https://github.com/lodash/babel-plugin-lodash) that will load only modules that you are using in your source. This might save you quite a bit of JavaScript payload.
对于 loadsh，[使用 `babel-plugin-lodash`](https://github.com/lodash/babel-plugin-lodash)将会加载你仅仅在源码中使用的。这样将会很大程度减轻 JavaScript 的负载。

18. **Take advantage of optimizations for your target JavaScript engine.**
18. **利用目标 JavaScript 引擎的优化。**

Study what JavaScript engines dominate in your user base, then explore ways of optimizing for them. For example, when optimizing for V8 which is used in Blink-browsers, Node.js runtime and Electron, make use of [script streaming](https://blog.chromium.org/2015/03/new-javascript-techniques-for-rapid.html) for monolithic scripts. It allows `async` or `defer scripts` to be parsed on a separate background thread once downloading begins, hence in some cases improving page loading times by up to 10%. Practically, [use `<script defer>`](https://medium.com/reloading/javascript-start-up-performance-69200f43b201#3498) in the `<head>`, so that the [browsers can discover the resource](https://medium.com/reloading/javascript-start-up-performance-69200f43b201#3498) early and then parse it on the background thread.
研究 JavaScript 引擎在用户基础中占主导地位，然后探索优化它们的方法。例如，当优化的 V8 引擎是用在 Blink 浏览器，Node.js 运行和电子，对每个脚本充分利用[脚本流](https://blog.chromium.org/2015/03/new-javascript-techniques-for-rapid.html)。一旦下载开始，它允许 `async` 或 `defer scripts` 在一个单独的后台线程进行解析，因此在某些情况下，提高页面加载时间达 10%。实际上，在 `<head>` 
中[使用 `<脚本延迟>`](https://medium.com/reloading/javascript-start-up-performance-69200f43b201#3498)，以致于[浏览器更早地可以发现资源](https://medium.com/reloading/javascript-start-up-performance-69200f43b201#3498)，然后在后台线程中解析它。

**Caveat**: _Opera Mini [doesn't support script deferment](https://caniuse.com/#search=defer), so if you are developing for India or Africa, `defer` will be ignored, resulting in blocking rendering until the script has been evaluated (thanks Jeremy!)_.

[![Progressive booting](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/ab06acd3-833a-4634-abf9-fc8d91939250/fmp-and-tti-opt.jpeg)](https://aerotwist.com/blog/when-everything-is-important-nothing-is/)
[[渐进引导](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/ab06acd3-833a-4634-abf9-fc8d91939250/fmp-and-tti-opt.jpeg)](https://aerotwist.com/blog/when-everything-is-important-nothing-is/)

[Progressive booting](https://aerotwist.com/blog/when-everything-is-important-nothing-is/) means using server-side rendering to get a quick first meaningful paint, but also include some minimal JavaScript to keep the time-to-interactive close to the first meaningful paint.
[渐进引导](https://aerotwist.com/blog/when-everything-is-important-nothing-is/)：使用服务器端呈现获得第一个快速的有意义的绘排，而且还要包含一些最小必要的 JavaScript 来保持实时交互来接近第一次的绘排。

19. **Client-side rendering or server-side rendering?**
19. **客户端渲染或者服务端渲染？**

In both scenarios, our goal should be to set up [progressive booting](https://aerotwist.com/blog/when-everything-is-important-nothing-is/): Use server-side rendering to get a quick first meaningful paint, but also include some minimal necessary JavaScript to **keep the time-to-interactive close to the first meaningful paint**. If JavaScript is coming too late after the First Meaningful Paint, the browser might [lock up the main thread](https://davidea.st/articles/measuring-server-side-rendering-performance-is-tricky) while parsing, compiling and executing late-discovered JavaScript, hence handcuffing the [interactivity of site or application](https://philipwalton.com/articles/why-web-developers-need-to-care-about-interactivity/).
在两种场景下，我们的目标应该是建立[渐进引导](https://aerotwist.com/blog/when-everything-is-important-nothing-is/)：使用服务器端呈现获得第一个快速的有意义的绘排，而且还要包含一些最小必要的 JavaScript 来**保持实时交互来接近第一次的绘排**。如果 JavaScript 在第一次绘排没有获取到，那么浏览器可能会在解析时[锁住主线程](https://davidea.st/articles/measuring-server-side-rendering-performance-is-tricky)，编译和执行最新发现的 JavaScript，因此限制[互动的网站或应用程序](https://philipwalton.com/articles/why-web-developers-need-to-care-about-interactivity/)。

To avoid it, always break up the execution of functions into separate, asynchronous tasks, and where possible use `requestIdleCallback`. Consider lazy loading parts of the UI using WebPack's [dynamic `import()` support](https://developers.google.com/web/updates/2017/11/dynamic-import), avoiding the load, parse, and compile cost until the users really need them (_thanks Addy!_).
为了避免这样做，总是将执行函数分离成一个个，异步任务和可能用到 `requestIdleCallback`的地方。考虑 UI 的懒加载部分使用 WebPack [动态 `import` 支持](https://developers.google.com/web/updates/2017/11/dynamic-import)，避免加载，解析，和编译开销直到用户真的需要他们（_感谢 Addy!_）。

In its essence, Time to Interactive (TTI) tells us how the length of time between navigation and interactivity. The metric is defined by looking at the first five second window after the initial content is rendered, in which no JavaScript tasks take longer than 50ms. If a task over 50ms occurs, the search for a five second window starts over. As a result, the browser will first assume that it reached Interactive, just to switch to Frozen, just to eventually switch back to Interactive.
在本质上，交互时间（TTI）告诉我们导航和交互之间的时间长度。度量是通过在初始内容呈现后的第一个五秒窗口来定义的，在这个过程中，JavaScript 任务没有操作 50ms 的。如果一个任务炒作 50ms 发生了，寻找一个五秒的窗口重新开始。因此，浏览器首先会假定它达到了交互式，只是切换到冻结状态，最终切换回交互式。

Once we reached Interactive, we can then, either on demand or as time allows, boot non-essential parts of the app. Unfortunately, as [Paul Lewis noticed](https://aerotwist.com/blog/when-everything-is-important-nothing-is/#which-to-use-progressive-booting), frameworks typically have no concept of priority that can be surfaced to developers, and hence progressive booting is difficult to implement with most libraries and frameworks. If you have the time and resources, use this strategy to ultimately boost performance.
一旦我们达到交互式，然后，我们可以按需或随时间所允许的，启动应用程序的非必需部分。不幸的是，随着[Paul Lewis 提到的](https://aerotwist.com/blog/when-everything-is-important-nothing-is/#which-to-use-progressive-booting)，框架通常没有优先出现的概念，可以向开发人员展示，因此渐进式引导很难用大多数库和框架实现。如果你有时间和资源，使用该策略可以极大地改善性能。

20. **Do you constrain the impact of third-party scripts?**
20. **你限制第三方脚本的影响么？**

With all performance optimizations in place, often we can't control third-party scripts coming from business requirements. Third-party-scripts metrics aren't influenced by end user experience, so too often one single script ends up calling a long tail of obnoxious third-party scripts, hence ruining a dedicated performance effort. To contain and mitigate performance penalties that these scripts bring along, it's not enough to just load them asynchronously ([probably via defer](https://www.twnsnd.com/posts/performant_third_party_scripts.html)) and accelerate them via resource hints such as `dns-prefetch` or `preconnect`.
尽管所有的性能得到很好地优化，我们不能控制来自商业需求的第三方脚本。第三方脚本度量不受终端用户体验的影响，所以，一个单一的脚本常常会以调用长长令人讨厌的第三方脚本为结尾，因此，破坏了为性能专门作出的努力。为了控制和减轻这些脚本带来的性能损失，仅仅异步加载（[可能通过 defer](https://www.twnsnd.com/posts/performant_third_party_scripts.html)）和通过资源提示，如：`dns-prefetch` 或者 `preconnect` 加速他们是不足够的。

As Yoav Weiss explained in his [must-watch talk on third-party scripts](http://conffab.com/video/taking-back-control-over-third-party-content/), in many cases these scripts download resources that are dynamic. The resources change between page loads, so we don't necessarily know which hosts the resources will be downloaded from and what resources they would be.
正如 Yoav Weiss 在他的 [必须关注第三方脚本的通信](http://conffab.com/video/taking-back-control-over-third-party-content/)中解释的，在很多情况下，下载资源的这些脚本是动态的。页面负载之间的资源是变化的，因此我们不必知道主机是从哪下载的资源以及这些资源是什么。

What options do we have then? Consider **using service workers by racing the resource download with a timeout** and if the resource hasn't responded within a certain timeout, return an empty response to tell the browser to carry on with parsing of the page. You can also log or block third-party requests that aren't successful or don't fulfill certain criteria.
这时，我们有什么选择？考虑 **通过间隔下载资源来使用 service workers**，如果在特定的时间间隔内资源没有响应，返回一个空的响应告知浏览器执行解析页面。你可以记录或者阻塞那些失败的第三方请求和没有执行特定标准请求。

Another option is to establish a **Content Security Policy (CSP)** to restrict the impact of third-party scripts, e.g. disallowing the download of audio or video. The best option is to embed scripts via `<iframe>` so that the scripts are running in the context of the iframe and hence don't have access to the DOM of the page, and can't run arbitrary code on your domain. Iframes can be further constrained using the `sandbox` attribute, so you can disable any functionality that iframe may do, e.g. prevent scripts from running, prevent alerts, form submission, plugins, access to the top navigation, and so on.
另一个选择是建立一个 **内容安全策略(CSP)** 来限制第三方脚本的影响，比如：不允许下载音频和视频。最好的选择是通过 `<iframe>` 嵌入脚本以致于脚本运行在 iframe 环境中，因此没有接入页面 DOM 的权限，在你的域下不能运行任何代码。Iframe 可以 使用 `sandbox` 属性进一步限制，因此你可以禁止 iframe 的任何功能，比如阻止脚本运行，阻止警告、表单提交、插件、访问顶部导航等等。

For example, it's probably going to be necessary to allow scripts to run with `<iframe sandbox="allow-scripts">`. Each of the limitations can be lifted via various `allow` values on the `sandbox` attribute ([supported almost everywhere](https://caniuse.com/#search=sandbox)), so constrain them to the bare minimum of what they should be allowed to do. Consider using [Safeframe](https://github.com/InteractiveAdvertisingBureau/safeframe) and Intersection Observer; that would enable ads to be iframed while still dispatching events or getting the information that they need from the DOM (e.g. ad visibility). Watch out for new policies such as [Feature policy](https://wicg.github.io/feature-policy/), resource size limits and CPU/Bandwidth priority to limit harmful web features and scripts that would slow down the browser, e.g. synchronous scripts, synchronous XHR requests, document.write and outdated implementations.
例如，它可能需要允许脚本运行 `<iframe sandbox="allow-scripts">`。每一个限制都可以通过'允许'值在'sandbox'属性（[几乎处处支持](https://caniuse.com/#search=sandbox)）解除，所以把他们限制在最低限度的允许他们去做的事情上。考虑使用[Safeframe](https://github.com/interactiveadvertisingbureau/safeframe)和交叉观察；这将使广告嵌入iframe的同时仍然调度事件或需要从DOM获取信息（例如广告知名度）。注意新的策略如[特征策略](https://wicg.github.io/feature-policy/)），资源的大小限制，CPU和带宽优先级限制损害的网络功能和会减慢浏览器的脚本，例如：同步脚本，同步XHR请求，document.write 和超时的实现。

To [stress-test third parties](https://csswizardry.com/2017/07/performance-and-resilience-stress-testing-third-parties/), examine bottom-up summaries in Performance profile page in DevTools, test what happens if a request is blocked or it has timed out — for the latter, you can use WebPageTest's Blackhole server `72.66.115.13` that you can point specific domains to in your `hosts` file. Preferably [self-host and use a single hostname](https://www.twnsnd.com/posts/performant_third_party_scripts.html), but also [generate a request map](https://www.soasta.com/blog/10-pro-tips-for-managing-the-performance-of-your-third-party-scripts/) that exposes fourth-party calls and detect when the scripts change.
为了[压测第三方](https://csswizardry.com/2017/07/performance-and-resilience-stress-testing-third-parties/)，在 DevTools 上自底向上概要地检查页面的性能，测试如果一个请求被阻塞了会发生什么或者对于后面的请求有超时限制，你可以使用 WebPageTest's Blackhole 服务器 `72.66.115.13`，同时可以在你的 `hosts` 文件中指定特定的域名。最好是[自我主机和使用一个单一的主机名](https://www.twnsnd.com/posts/performant_third_party_scripts.html)，但是同时[生成一个请求映射](https://www.soasta.com/blog/10-pro-tips-for-managing-the-performance-of-your-third-party-scripts/)，当脚本变化时，暴露给第四方调用和检测。

![request blocking](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/b1e12dad-ea64-430e-b3db-b67fb76029d8/block-request-url-image-opt.png)
![请求块](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/b1e12dad-ea64-430e-b3db-b67fb76029d8/block-request-url-image-opt.png)

Image credit: [Harry Roberts](https://csswizardry.com/2017/07/performance-and-resilience-stress-testing-third-parties/#request-blocking)
图片信用：[Harry Roberts](https://csswizardry.com/2017/07/performance-and-resilience-stress-testing-third-parties/#request-blocking)

21. **Are HTTP cache headers set properly?**
21. **HTTP cache 头部设置是否合理？**

Double-check that `expires`, `cache-control`, `max-age` and other HTTP cache headers have been set properly. In general, resources should be cacheable either for a very short time (if they are likely to change) or indefinitely (if they are static) — you can just change their version in the URL when needed. Disable the `Last-Modified` header as any asset with it will result in a conditional request with an `If-Modified-Since`-header even if the resource is in cache. Same with `Etag`, though it has its uses.
再次检查一遍 `expires`，`cache-control`，`max-age` 和其他 HTTP cache 头部事都设置正确吗。通常，资源应该是可缓存的不管是短时间的（如果它们很可能改变），还是无限期的（如果它们是静态的）——你可以在需要更新的时候， 改变 URL 中它们的版本即可。在任何资源上禁止头部 `Last-Modified` 都会导致一个 `If-Modified-Since` 条件查询，即使资源在缓存中。与 `Etag` 一样，即使它在使用中。

Use `Cache-control: immutable`, designed for fingerprinted static resources, to avoid revalidation (as of December 2017, [supported in Firefox, Edge and Safari](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Cache-Control); in Firefox only on `https://` transactions). You can use [Heroku's primer on HTTP caching headers](https://devcenter.heroku.com/articles/increasing-application-performance-with-http-cache-headers), Jake Archibald's "[Caching Best Practices](https://jakearchibald.com/2016/caching-best-practices/)" and Ilya Grigorik's [HTTP caching primer](https://developers.google.com/web/fundamentals/performance/optimizing-content-efficiency/http-caching?hl=en) as guides. Also, be wary of the [vary header](https://www.smashingmagazine.com/2017/11/understanding-vary-header/), especially [in relation to CDNs](https://www.fastly.com/blog/getting-most-out-vary-fastly), and watch out for the [Key header](https://www.greenbytes.de/tech/webdav/draft-ietf-httpbis-key-latest.html) which helps avoiding an additional round trip for validation whenever a new request differs slightly, but not significantly, from prior requests (_thanks, Guy!_).
使用 `Cache-control: immutable`，该头部为被打上指纹的静态资源设计，避免资源被重新验证（截至 2017年12月，[在 FireFox，Edge 和 Safari 中支持](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Cache-Control)；只有 FireFox 在 HTTPS 中支持）。你也可以使用 [Heroku 的 HTTP 缓存头部](https://devcenter.heroku.com/articles/increasing-application-performance-with-http-cache-headers)，Jake Archibald 的 "[Caching Best Practices](https://jakearchibald.com/2016/caching-best-practices/)" ，以及 Ilya Grigorik 的 [HTTP caching primer](https://developers.google.com/web/fundamentals/performance/optimizing-content-efficiency/http-caching?hl=en) 作为指导。而且，注意[不同的头部](https://www.smashingmagazine.com/2017/11/understanding-vary-header/)，尤其是[在关系到 CDN 时](https://www.fastly.com/blog/getting-most-out-vary-fastly)，并且注意[关键头部](https://www.greenbytes.de/tech/webdav/draft-ietf-httpbis-key-latest.html)有助于避免在新请求稍有差异时进行额外的验证，从以前请求方面，但并不是必要的（感谢，_Guy！_）。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
