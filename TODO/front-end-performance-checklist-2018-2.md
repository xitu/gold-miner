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

Notice that CDNs can serve (and offload) dynamic content as well. So, restricting your CDN to static assets is not necessary. Double-check whether your CDN performs compression and conversion (e.g. image optimization in terms of formats, compression and resizing at the edge), smart HTTP/2 delivery, edge-side includes, which assemble static and dynamic parts of pages at the CDN's edge (i.e. the server closest to the user), and other tasks.

### Build Optimizations
### 构建优化

13. **Set your priorities straight.**

It's a good idea to know what you are dealing with first. Run an inventory of all of your assets (JavaScript, images, fonts, third-party scripts and "expensive" modules on the page, such as carousels, complex infographics and multimedia content), and break them down in groups.

Set up a spreadsheet. Define the basic _core_ experience for legacy browsers (i.e. fully accessible core content), the _enhanced_ experience for capable browsers (i.e. the enriched, full experience) and the _extras_ (assets that aren't absolutely required and can be lazy-loaded, such as web fonts, unnecessary styles, carousel scripts, video players, social media buttons, large images). We published an article on "[Improving Smashing Magazine's Performance](https://www.smashingmagazine.com/2014/09/improving-smashing-magazine-performance-case-study/)," which describes this approach in detail.

14. **Consider using the "cutting-the-mustard" pattern.**
14. **考虑使用“cutting-the-mustard”模式**

Albeit quite old, we can still use the [cutting-the-mustard technique](http://responsivenews.co.uk/post/18948466399/cutting-the-mustard) to send the core experience to legacy browsers and an enhanced experience to modern browsers. Be strict in loading your assets: Load the core experience immediately, then enhancements, and then the extras. Note that the technique deduces device capability from browser version, which is no longer something we can do these days.

For example, cheap Android phones in developing countries mostly run Chrome and will cut the mustard despite their limited memory and CPU capabilities. That's where [PRPL pattern](https://developers.google.com/web/fundamentals/performance/prpl-pattern/) could serve as a good alternative. Eventually, using the [Device Memory Client Hints Header](https://github.com/w3c/device-memory), we'll be able to target low-end devices more reliably. At the moment of writing, the header is supported only in Blink (it goes for [client hints](https://caniuse.com/#search=client%20hints) in general). Since Device Memory also has a JavaScript API which is [already available in Chrome](https://developers.google.com/web/updates/2017/12/device-memory), one option could be to feature detect based on the API, and fallback to "cutting the mustard" technique only if it's not supported (_thanks, Yoav!_)

15. **Parsing JavaScript is expensive, so keep it small.**
15. **解析 JavaScript 的代价很大，应保持其较小**

When dealing with single-page applications, you might need some time to initialize the app before you can render the page. Look for modules and techniques to speed up the initial rendering time (for example, [here's how to debug React performance](https://building.calibreapp.com/debugging-react-performance-with-react-16-and-chrome-devtools-c90698a522ad), and [here's how to improve performance in Angular](https://www.youtube.com/watch?v=p9vT0W31ym8)), because most performance issues come from the initial parsing time to bootstrap the app.

[JavaScript has a cost](https://youtu.be/_srJ7eHS3IM?t=9m33s), but it's not necessarily the file size that drains on performance. Parsing and executing times vary significantly depending on the hardware of a device. On an average phone (Moto G4), a parsing time alone for 1MB of (uncompressed) JavaScript will be around 1.3–1.4s, with 15–20% of all time on mobile spent on parsing. With compiling in play, just prep work on JavaScript takes 4s on average, with around 11s before First Meaningful Paint on mobile. Reason: [parse and execution times can easily be 2–5x times higher](https://medium.com/reloading/javascript-start-up-performance-69200f43b201) on low-end mobile devices.

An interesting way of avoiding parsing costs is to use [binary templates](https://emberjs.com/blog/2017/10/10/glimmer-progress-report.html#toc_binary-templates) that Ember has recently introduced for experimentation. These templates don't need to be parsed. (_Thanks, Leonardo!_)

That's why it's critical to examine every single JavaScript dependency, and tools like [webpack-bundle-analyzer](https://www.npmjs.com/package/webpack-bundle-analyzer), [Source Map Explorer](https://github.com/danvk/source-map-explorer) and [Bundle Buddy](https://github.com/samccone/bundle-buddy) can help you achieve just that. [Measure JavaScript parse and compile times](https://medium.com/reloading/javascript-start-up-performance-69200f43b201#7557). Etsy's [DeviceTiming](https://github.com/danielmendel/DeviceTiming), a little tool allowing you to instruct your JavaScript to measure parse and execution time on any device or browser. Bottom line: while size matters, it isn't everything. Parse and compiling times [don't necessarily increase linearly](https://medium.com/reloading/javascript-start-up-performance-69200f43b201) when the script size increases.

<figure class="video-container"><iframe src="https://player.vimeo.com/video/249525818" width="640" height="384" frameborder="0" webkitallowfullscreen="" mozallowfullscreen="" allowfullscreen=""></iframe>

[Webpack Bundle Analyzer](https://www.npmjs.com/package/webpack-bundle-analyzer) visualizes JavaScript dependencies.

16. **Are you using an ahead-of-time compiler?**
16. **你使用 AOT编译么？**

Use an [ahead-of-time compiler](https://www.lucidchart.com/techblog/2016/09/26/improving-angular-2-load-times/) to [offload some of the client-side rendering](https://www.smashingmagazine.com/2016/03/server-side-rendering-react-node-express/) to the [server](http://redux.js.org/docs/recipes/ServerRendering.html) and, hence, output usable results quickly. Finally, consider using [Optimize.js](https://github.com/nolanlawson/optimize-js) for faster initial loading by wrapping eagerly invoked functions (it [might not be necessary](https://twitter.com/tverwaes/status/809788255243739136) any longer, though).

17. **Are you using tree-shaking, scope hoisting and code-splitting?**
17. **你使用 tree-shaking，scope hoisting，code-splitting 么**

[Tree-shaking](https://medium.com/@roman01la/dead-code-elimination-and-tree-shaking-in-javascript-build-systems-fb8512c86edf) is a way to clean up your build process by only including code that is actually used in production and eliminate unused exports [in Webpack](http://www.2ality.com/2015/12/webpack-tree-shaking.html). With Webpack 3 and Rollup, we also have [scope hoisting](https://medium.com/webpack/brief-introduction-to-scope-hoisting-in-webpack-8435084c171f) that allows both tools to detect where `import` chaining can be flattened and converted into one inlined function without compromising the code. With Webpack 4, you can now use [JSON Tree Shaking](https://react-etc.net/entry/json-tree-shaking-lands-in-webpack-4-0) as well. [UnCSS](https://github.com/giakki/uncss) or [Helium](https://github.com/geuis/helium-css) can help you remove unused styles from CSS.

Also, you might want to consider learning how to [write efficient CSS selectors](http://csswizardry.com/2011/09/writing-efficient-css-selectors/) as well as how to [avoid bloat and expensive styles](https://benfrain.com/css-performance-revisited-selectors-bloat-expensive-styles/). Feeling like going beyond that? You can also use Webpack to shorten the class names and use scope isolation to [rename CSS class names dynamically](https://medium.freecodecamp.org/reducing-css-bundle-size-70-by-cutting-the-class-names-and-using-scope-isolation-625440de600b) at the compilation time.

[Code-splitting](https://webpack.github.io/docs/code-splitting.html) is another Webpack feature that splits your code base into "chunks" that are loaded on demand. Not all of the JavaScript has to be downloaded, parsed and compiled right away. Once you define split points in your code, Webpack can take care of the dependencies and outputted files. It enables you to keep the initial download small and to request code on demand, when requested by the application. Also, consider using [preload-webpack-plugin](https://github.com/GoogleChromeLabs/preload-webpack-plugin) that takes routes you code-split and then prompts browser to preload them using `<link rel="preload">` or `<link rel="prefetch">`.

Where to define split points? By tracking which chunks of CSS/JavaScript are used, and which aren't used. Umar Hansa [explains](https://vimeo.com/235431630#t=11m37s) how you can use Code Coverage from Devtools to achieve it.

If you aren't using Webpack, note that [Rollup](http://rollupjs.org/) shows significantly better results than Browserify exports. While we're at it, you might want to check out [Rollupify](https://github.com/nolanlawson/rollupify), which converts ECMAScript 2015 modules into one big CommonJS module — because small modules can have a [surprisingly high performance cost](https://nolanlawson.com/2016/08/15/the-cost-of-small-modules/) depending on your choice of bundler and module system.

!['Fast By Default: Modern Loading Best Practices' by Addy Osmani](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/31237c37-d7db-4faa-9849-51657e122331/babel-preset-opt.png)

From [Fast By Default: Modern Loading Best Practices](https://speakerdeck.com/addyosmani/fast-by-default-modern-loading-best-practices) by the one-and-only Addy Osmani. Slide 76.

Finally, with ES2015 being [remarkably well supported in modern browsers](http://kangax.github.io/compat-table/es6/), consider [using `babel-preset-env`](http://2ality.com/2017/02/babel-preset-env.html) to only transpile ES2015+ features unsupported by the modern browsers you are targeting. Then [set up two builds](https://gist.github.com/newyankeecodeshop/79f3e1348a09583faf62ed55b58d09d9), one in ES6 and one in ES5\. We can [use `script type="module"`](https://matthewphillips.info/posts/loading-app-with-script-module) to let browsers with ES module support loading the file, while older browser could load legacy builds with `script nomodule`.

For lodash, [use `babel-plugin-lodash`](https://github.com/lodash/babel-plugin-lodash) that will load only modules that you are using in your source. This might save you quite a bit of JavaScript payload.

18. **Take advantage of optimizations for your target JavaScript engine.**

Study what JavaScript engines dominate in your user base, then explore ways of optimizing for them. For example, when optimizing for V8 which is used in Blink-browsers, Node.js runtime and Electron, make use of [script streaming](https://blog.chromium.org/2015/03/new-javascript-techniques-for-rapid.html) for monolithic scripts. It allows `async` or `defer scripts` to be parsed on a separate background thread once downloading begins, hence in some cases improving page loading times by up to 10%. Practically, [use `<script defer>`](https://medium.com/reloading/javascript-start-up-performance-69200f43b201#3498) in the `<head>`, so that the [browsers can discover the resource](https://medium.com/reloading/javascript-start-up-performance-69200f43b201#3498) early and then parse it on the background thread.

**Caveat**: _Opera Mini [doesn't support script deferment](https://caniuse.com/#search=defer), so if you are developing for India or Africa, `defer` will be ignored, resulting in blocking rendering until the script has been evaluated (thanks Jeremy!)_.

[![Progressive booting](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/ab06acd3-833a-4634-abf9-fc8d91939250/fmp-and-tti-opt.jpeg)](https://aerotwist.com/blog/when-everything-is-important-nothing-is/)

[Progressive booting](https://aerotwist.com/blog/when-everything-is-important-nothing-is/) means using server-side rendering to get a quick first meaningful paint, but also include some minimal JavaScript to keep the time-to-interactive close to the first meaningful paint.

19. **Client-side rendering or server-side rendering?**
19. **客户端渲染或者服务端渲染？**

In both scenarios, our goal should be to set up [progressive booting](https://aerotwist.com/blog/when-everything-is-important-nothing-is/): Use server-side rendering to get a quick first meaningful paint, but also include some minimal necessary JavaScript to **keep the time-to-interactive close to the first meaningful paint**. If JavaScript is coming too late after the First Meaningful Paint, the browser might [lock up the main thread](https://davidea.st/articles/measuring-server-side-rendering-performance-is-tricky) while parsing, compiling and executing late-discovered JavaScript, hence handcuffing the [interactivity of site or application](https://philipwalton.com/articles/why-web-developers-need-to-care-about-interactivity/).

To avoid it, always break up the execution of functions into separate, asynchronous tasks, and where possible use `requestIdleCallback`. Consider lazy loading parts of the UI using WebPack's [dynamic `import()` support](https://developers.google.com/web/updates/2017/11/dynamic-import), avoiding the load, parse, and compile cost until the users really need them (_thanks Addy!_).

In its essence, Time to Interactive (TTI) tells us how the length of time between navigation and interactivity. The metric is defined by looking at the first five second window after the initial content is rendered, in which no JavaScript tasks take longer than 50ms. If a task over 50ms occurs, the search for a five second window starts over. As a result, the browser will first assume that it reached Interactive, just to switch to Frozen, just to eventually switch back to Interactive.

Once we reached Interactive, we can then, either on demand or as time allows, boot non-essential parts of the app. Unfortunately, as [Paul Lewis noticed](https://aerotwist.com/blog/when-everything-is-important-nothing-is/#which-to-use-progressive-booting), frameworks typically have no concept of priority that can be surfaced to developers, and hence progressive booting is difficult to implement with most libraries and frameworks. If you have the time and resources, use this strategy to ultimately boost performance.

20. **Do you constrain the impact of third-party scripts?**
20. **你限制第三方脚本的影响么？**

With all performance optimizations in place, often we can't control third-party scripts coming from business requirements. Third-party-scripts metrics aren't influenced by end user experience, so too often one single script ends up calling a long tail of obnoxious third-party scripts, hence ruining a dedicated performance effort. To contain and mitigate performance penalties that these scripts bring along, it's not enough to just load them asynchronously ([probably via defer](https://www.twnsnd.com/posts/performant_third_party_scripts.html)) and accelerate them via resource hints such as `dns-prefetch` or `preconnect`.

As Yoav Weiss explained in his [must-watch talk on third-party scripts](http://conffab.com/video/taking-back-control-over-third-party-content/), in many cases these scripts download resources that are dynamic. The resources change between page loads, so we don't necessarily know which hosts the resources will be downloaded from and what resources they would be.

What options do we have then? Consider **using service workers by racing the resource download with a timeout** and if the resource hasn't responded within a certain timeout, return an empty response to tell the browser to carry on with parsing of the page. You can also log or block third-party requests that aren't successful or don't fulfill certain criteria.

Another option is to establish a **Content Security Policy (CSP)** to restrict the impact of third-party scripts, e.g. disallowing the download of audio or video. The best option is to embed scripts via `<iframe>` so that the scripts are running in the context of the iframe and hence don't have access to the DOM of the page, and can't run arbitrary code on your domain. Iframes can be further constrained using the `sandbox` attribute, so you can disable any functionality that iframe may do, e.g. prevent scripts from running, prevent alerts, form submission, plugins, access to the top navigation, and so on.

For example, it's probably going to be necessary to allow scripts to run with `<iframe sandbox="allow-scripts">`. Each of the limitations can be lifted via various `allow` values on the `sandbox` attribute ([supported almost everywhere](https://caniuse.com/#search=sandbox)), so constrain them to the bare minimum of what they should be allowed to do. Consider using [Safeframe](https://github.com/InteractiveAdvertisingBureau/safeframe) and Intersection Observer; that would enable ads to be iframed while still dispatching events or getting the information that they need from the DOM (e.g. ad visibility). Watch out for new policies such as [Feature policy](https://wicg.github.io/feature-policy/), resource size limits and CPU/Bandwidth priority to limit harmful web features and scripts that would slow down the browser, e.g. synchronous scripts, synchronous XHR requests, document.write and outdated implementations.

To [stress-test third parties](https://csswizardry.com/2017/07/performance-and-resilience-stress-testing-third-parties/), examine bottom-up summaries in Performance profile page in DevTools, test what happens if a request is blocked or it has timed out — for the latter, you can use WebPageTest's Blackhole server `72.66.115.13` that you can point specific domains to in your `hosts` file. Preferably [self-host and use a single hostname](https://www.twnsnd.com/posts/performant_third_party_scripts.html), but also [generate a request map](https://www.soasta.com/blog/10-pro-tips-for-managing-the-performance-of-your-third-party-scripts/) that exposes fourth-party calls and detect when the scripts change.

![request blocking](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/b1e12dad-ea64-430e-b3db-b67fb76029d8/block-request-url-image-opt.png)

Image credit: [Harry Roberts](https://csswizardry.com/2017/07/performance-and-resilience-stress-testing-third-parties/#request-blocking)

21. **Are HTTP cache headers set properly?**
21. **HTTP 头缓存设置是否合理？**

Double-check that `expires`, `cache-control`, `max-age` and other HTTP cache headers have been set properly. In general, resources should be cacheable either for a very short time (if they are likely to change) or indefinitely (if they are static) — you can just change their version in the URL when needed. Disable the `Last-Modified` header as any asset with it will result in a conditional request with an `If-Modified-Since`-header even if the resource is in cache. Same with `Etag`, though it has its uses.

Use `Cache-control: immutable`, designed for fingerprinted static resources, to avoid revalidation (as of December 2017, [supported in Firefox, Edge and Safari](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Cache-Control); in Firefox only on `https://` transactions). You can use [Heroku's primer on HTTP caching headers](https://devcenter.heroku.com/articles/increasing-application-performance-with-http-cache-headers), Jake Archibald's "[Caching Best Practices](https://jakearchibald.com/2016/caching-best-practices/)" and Ilya Grigorik's [HTTP caching primer](https://developers.google.com/web/fundamentals/performance/optimizing-content-efficiency/http-caching?hl=en) as guides. Also, be wary of the [vary header](https://www.smashingmagazine.com/2017/11/understanding-vary-header/), especially [in relation to CDNs](https://www.fastly.com/blog/getting-most-out-vary-fastly), and watch out for the [Key header](https://www.greenbytes.de/tech/webdav/draft-ietf-httpbis-key-latest.html) which helps avoiding an additional round trip for validation whenever a new request differs slightly, but not significantly, from prior requests (_thanks, Guy!_).


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
