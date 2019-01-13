> * 原文地址：[Front-End Performance Checklist 2019 — 4](https://www.smashingmagazine.com/2019/01/front-end-performance-checklist-2019-pdf-pages/)
> * 原文作者：[Vitaly Friedman](https://www.smashingmagazine.com/author/vitaly-friedman)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-4.md](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-4.md)
> * 译者：
> * 校对者：

# Front-End Performance Checklist 2019 — 4

Let’s make 2019... fast! An annual front-end performance checklist, with everything you need to know to create fast experiences today. Updated since 2016.

> [译] [2019 前端性能优化年度总结 — 第一部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-1.md)
> [译] [2019 前端性能优化年度总结 — 第二部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-2.md)
> [译] [2019 前端性能优化年度总结 — 第三部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-3.md)
> **[译] [2019 前端性能优化年度总结 — 第四部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-4.md)**
> [译] [2019 前端性能优化年度总结 — 第五部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-5.md)
> [译] [2019 前端性能优化年度总结 — 第六部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-6.md)

#### Table Of Contents

- [Build Optimizations](#build-optimizations)
  - [22. Set your priorities straight](#22-set-your-priorities-straight)
  - [23. Revisit the good ol' "cutting-the-mustard" technique.**](#23-revisit-the-good-ol-%22cutting-the-mustard%22-technique)
  - [24. Parsing JavaScript is expensive, so keep it small](#24-parsing-javascript-is-expensive-so-keep-it-small)
  - [25. Are you using tree-shaking, scope hoisting and code-splitting?](#25-are-you-using-tree-shaking-scope-hoisting-and-code-splitting)
  - [26. Can you offload JavaScript into a Web Worker?](#26-can-you-offload-javascript-into-a-web-worker)
  - [27. Can you offload JavaScript into WebAssembly?](#27-can-you-offload-javascript-into-webassembly)
  - [28. Are you using an ahead-of-time compiler?](#28-are-you-using-an-ahead-of-time-compiler)
  - [29. Serve legacy code only to legacy browsers](#29-serve-legacy-code-only-to-legacy-browsers)
  - [30. Are you using differential serving for JavaScript?](#30-are-you-using-differential-serving-for-javascript)
  - [31. Identify and rewrite legacy code with incremental decoupling](#31-identify-and-rewrite-legacy-code-with-incremental-decoupling)
  - [32. Identify and remove unused CSS/JS](#32-identify-and-remove-unused-cssjs)
  - [33. Trim the size of your JavaScript bundles](#33-trim-the-size-of-your-javascript-bundles)
  - [34. Are you using predictive prefetching for JavaScript chunks?](#34-are-you-using-predictive-prefetching-for-javascript-chunks)
  - [35. Take advantage of optimizations for your target JavaScript engine](#35-take-advantage-of-optimizations-for-your-target-javascript-engine)
  - [36. Client-side rendering or server-side rendering?](#36-client-side-rendering-or-server-side-rendering)
  - [37. Constrain the impact of third-party scripts.](#37-constrain-the-impact-of-third-party-scripts)
  - [38. Set HTTP cache headers properl](#38-set-http-cache-headers-properl)

### Build Optimizations

#### 22. Set your priorities straight
 
It’s a good idea to know what you are dealing with first. Run an inventory of all of your assets (JavaScript, images, fonts, third-party scripts and "expensive" modules on the page, such as carousels, complex infographics and multimedia content), and break them down in groups.

Set up a spreadsheet. Define the basic _core_ experience for legacy browsers (i.e. fully accessible core content), the _enhanced_ experience for capable browsers (i.e. the enriched, full experience) and the _extras_ (assets that aren’t absolutely required and can be lazy-loaded, such as web fonts, unnecessary styles, carousel scripts, video players, social media buttons, large images). A while back, we published an article on "[Improving Smashing Magazine’s Performance](https://www.smashingmagazine.com/2014/09/improving-smashing-magazine-performance-case-study/)," which describes this approach in detail.

When optimizing for performance we need to reflect our priorities. Load the _core experience_ immediately, then _enhancements_, and then the _extras_.

#### 23. Revisit the good ol' "cutting-the-mustard" technique.**  

These days we can still use the [cutting-the-mustard technique](https://www.filamentgroup.com/lab/modernizing-delivery.html) to send the core experience to legacy browsers and an enhanced experience to modern browsers. An [updated variant of the technique](https://snugug.com/musings/modern-cutting-the-mustard/) would use ES2015+ `<script type="module">`. Modern browsers would interpret the script as a JavaScript module and run it as expected, while legacy browsers wouldn’t recognize the attribute and ignore it because it’s unknown HTML syntax.

These days we need to keep in mind that feature detection alone isn’t enough to make an informed decision about the payload to ship to that browser. On its own, _cutting-the-mustard_ deduces device capability from browser version, which is no longer something we can do today.

For example, cheap Android phones in developing countries mostly run Chrome and will cut the mustard despite their limited memory and CPU capabilities. Eventually, using the [Device Memory Client Hints Header](https://github.com/w3c/device-memory), we’ll be able to target low-end devices more reliably. At the moment of writing, the header is supported only in Blink (it goes for [client hints](https://caniuse.com/#search=client%20hints) in general). Since Device Memory also has a JavaScript API which is [already available in Chrome](https://developers.google.com/web/updates/2017/12/device-memory), one option could be to feature detect based on the API, and fall back to "cutting the mustard" technique only if it’s not supported (_thanks, Yoav!_).
    
#### 24. Parsing JavaScript is expensive, so keep it small 

When dealing with single-page applications, we need some time to initialize the app before we can render the page. Your setting will require your custom solution, but you could watch out for modules and techniques to speed up the initial rendering time. For example, [here’s how to debug React performance](https://building.calibreapp.com/debugging-react-performance-with-react-16-and-chrome-devtools-c90698a522ad) and [eliminate common React performance issues](https://logrocket-blog.ghost.io/death-by-a-thousand-cuts-a-checklist-for-eliminating-common-react-performance-issues/), and [here’s how to improve performance in Angular](https://www.youtube.com/watch?v=p9vT0W31ym8). In general, most performance issues come from the initial parsing time to bootstrap the app.

[JavaScript has a cost](https://youtu.be/_srJ7eHS3IM?t=9m33s), but it’s rarely the file size alone that drains on performance. Parsing and executing times vary significantly depending on the hardware of a device. On an average phone (Moto G4), a parsing time alone for 1MB of (uncompressed) JavaScript will be around 1.3–1.4s, with 15–20% of all time on mobile spent on parsing. With compiling in play, just prep work on JavaScript takes 4s on average, with around 11s before First Meaningful Paint on mobile. Reason: [parse and execution times can easily be 2–5x times higher](https://medium.com/reloading/javascript-start-up-performance-69200f43b201) on low-end mobile devices.

To guarantee high performance, as developers, we need to find ways to write and deploy less JavaScript. That’s why it pays off to examine every single JavaScript dependency in detail.

There are many tools to help you make an informed decision about the impact of your dependencies and viable alternatives:

*   [webpack-bundle-analyzer](https://www.npmjs.com/package/webpack-bundle-analyzer)
*   [Source Map Explorer](https://github.com/danvk/source-map-explorer)
*   [Bundle Buddy](https://github.com/samccone/bundle-buddy)
*   [Bundlephobia](https://bundlephobia.com/)
*   [Webpack size-plugin](https://github.com/GoogleChromeLabs/size-plugin)
*   [Import Cost for Visual Code](https://marketplace.visualstudio.com/items?itemName=wix.vscode-import-cost)

An interesting way of avoiding parsing costs is to use [binary templates](https://emberjs.com/blog/2017/10/10/glimmer-progress-report.html#toc_binary-templates) that Ember has introduced in 2017. With them, Ember replaces JavaScript parsing with JSON parsing, which is presumably faster. (_Thanks, Leonardo, Yoav!_)

[Measure JavaScript parse and compile times](https://medium.com/reloading/javascript-start-up-performance-69200f43b201#7557). We can use synthetic testing tools and browser traces to track parse times, and browser implementors are talking about [exposing RUM-based processing times in the future](https://github.com/w3c/resource-timing/issues/133). Alternatively, consider using Etsy’s [DeviceTiming](https://github.com/danielmendel/DeviceTiming), a little tool allowing you to instruct your JavaScript to measure parse and execution time on any device or browser.

Bottom line: while size matters, it isn’t everything. Parse and compiling times [don’t necessarily increase linearly](https://medium.com/reloading/javascript-start-up-performance-69200f43b201) when the script size increases.
    
#### 25. Are you using tree-shaking, scope hoisting and code-splitting?

[Tree-shaking](https://developers.google.com/web/fundamentals/performance/optimizing-javascript/tree-shaking/) is a way to clean up your build process by only including code that is actually used in production and eliminate unused imports [in Webpack](http://www.2ality.com/2015/12/webpack-tree-shaking.html). With Webpack and Rollup, we also have [scope hoisting](https://medium.com/webpack/brief-introduction-to-scope-hoisting-in-webpack-8435084c171f) that allows both tools to detect where `import` chaining can be flattened and converted into one inlined function without compromising the code. With Webpack, we can also use [JSON Tree Shaking](https://react-etc.net/entry/json-tree-shaking-lands-in-webpack-4-0) as well.

Also, you might want to consider learning how to [write efficient CSS selectors](http://csswizardry.com/2011/09/writing-efficient-css-selectors/) as well as how to [avoid bloat and expensive styles](https://benfrain.com/css-performance-revisited-selectors-bloat-expensive-styles/). Feeling like going beyond that? You can also use Webpack to shorten the class names and use scope isolation to [rename CSS class names dynamically](https://medium.freecodecamp.org/reducing-css-bundle-size-70-by-cutting-the-class-names-and-using-scope-isolation-625440de600b) at the compilation time.

[Code-splitting](https://webpack.js.org/guides/code-splitting/) is another Webpack feature that splits your code base into "chunks" that are loaded on demand. Not all of the JavaScript has to be downloaded, parsed and compiled right away. Once you define split points in your code, Webpack can take care of the dependencies and outputted files. It enables you to keep the initial download small and to request code on demand when requested by the application. Alexander Kondrov has a [fantastic introduction to code-splitting with Webpack and React](https://hackernoon.com/lessons-learned-code-splitting-with-webpack-and-react-f012a989113).

Consider using [preload-webpack-plugin](https://github.com/GoogleChromeLabs/preload-webpack-plugin) that takes routes you code-split and then prompts browser to preload them using `<link rel="preload">` or `<link rel="prefetch">`. [Webpack inline directives](https://webpack.js.org/guides/code-splitting/#prefetching-preloading-modules) also give some control over `preload`/`prefetch`

Where to define split points? By tracking which chunks of CSS/JavaScript are used, and which aren’t used. Umar Hansa [explains](https://vimeo.com/235431630#t=11m37s) how you can use Code Coverage from Devtools to achieve it.
    
If you aren’t using Webpack, note that [Rollup](http://rollupjs.org/) shows significantly better results than Browserify exports. While we’re at it, you might want to check out [rollup-plugin-closure-compiler](https://github.com/ampproject/rollup-plugin-closure-compiler) and [Rollupify](https://github.com/nolanlawson/rollupify), which converts ECMAScript 2015 modules into one big CommonJS module — because small modules can have a [surprisingly high performance cost](https://nolanlawson.com/2016/08/15/the-cost-of-small-modules/) depending on your choice of bundler and module system.

#### 26. Can you offload JavaScript into a Web Worker?

To reduce the negative impact to Time-to-Interactive, it might be a good idea to look into offloading heavy JavaScript into a [Web Worker](https://developer.mozilla.org/en-US/docs/Web/API/Web_Workers_API/Using_web_workers) or caching via a Service Worker.

As the code base keeps growing, the UI performance bottlenecks will show up, slowing down the user’s experience. That’s [because DOM operations are running alongside your JavaScript](https://medium.com/google-developer-experts/running-fetch-in-a-web-worker-700dc33ac854) on the main thread. With [web workers](https://flaviocopes.com/web-workers/), we can move these expensive operations to a background process that’s running on a different thread. Typical use cases for web workers are [prefetching data and Progressive Web Apps](https://blog.sessionstack.com/how-javascript-works-the-building-blocks-of-web-workers-5-cases-when-you-should-use-them-a547c0757f6a) to load and store some data in advance so that you can use it later when needed. And you could use [Comlink](https://github.com/GoogleChromeLabs/comlink) to streamline the communication between the main page and the worker. Still some work to do, but we are getting there.

[Workerize](https://github.com/developit/workerize) allows you to move a module into a Web Worker, automatically reflecting exported functions as asynchronous proxies. And if you’re using Webpack, you could use [workerize-loader](https://github.com/developit/workerize-loader). Alternatively, you could use [worker-plugin](https://github.com/GoogleChromeLabs/worker-plugin) as well.

Note that Web Workers don’t have access to the DOM because the DOM is not "thread-safe", and the code that they execute needs to be contained in a separate file.

#### 27. Can you offload JavaScript into WebAssembly?

We could potentialy also convert JavaScript into [WebAssembly](https://webassembly.org/), a binary instruction format, designed as a portable target for compilation of high-level languages like C/C++/Rust. Its [browser support is remarkable](https://caniuse.com/#feat=wasm), and it has recently become viable as [function calls between JavaSript and WASM are getting faster](https://hacks.mozilla.org/2018/10/calls-between-javascript-and-webassembly-are-finally-fast-%F0%9F%8E%89/), at least in Firefox.

In real-world scenarios, [JavaScript seems to perform better than WebAssembly](https://medium.com/samsung-internet-dev/performance-testing-web-assembly-vs-javascript-e07506fd5875) on smaller array sizes and WebAssembly performs better than JavaScript on larger array sizes. For most web apps, JavaScript is a better fit, and WebAssembly is best used for computationally intensive web apps, such as web games. However, it might be worth investigating if a switch to WebAssembly would result in noticeable performance improvements.

If you’d like to learn more about WebAssembly:

*   Lin Clark has written a [thorough series to WebAssembly](https://hacks.mozilla.org/2017/02/a-cartoon-intro-to-webassembly/) and Milica Mihajlija provides a [general overview](https://blog.logrocket.com/webassembly-how-and-why-559b7f96cd71) of how to run native code in the browser, why would you do that, and what it all means for JavaScript and the future of web development.

*   Google Codelabs provides an [Introduction to WebAssembly](https://codelabs.developers.google.com/codelabs/web-assembly-intro/index.html), a 60 min course in which you’ll learn how to take native code—in C and compile it to WebAssembly, and then call it directly from JavaScript.

*   Alex Danilo has [explained WebAssembly and how it works](https://www.youtube.com/watch?v=6v4E6oksar0) at his Google I/O 2017 talk. Also, Benedek Gagyi [shared a practical case study on WebAssembly](https://www.youtube.com/watch?v=l2DHjRmgAF8), specifically how the team uses it as output format for their C++ codebase to iOS, Android and the website.

[![A general overview of how WebAssembly works and why it’s useful.](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/bbb2ea83-7674-47d8-9cad-89a2de009915/how-webassembly-works.png)](https://blog.logrocket.com/webassembly-how-and-why-559b7f96cd71) 

Milica Mihajlija provides a general overview of [how WebAssembly works and why it’s useful](https://blog.logrocket.com/webassembly-how-and-why-559b7f96cd71). ([Large preview](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/bbb2ea83-7674-47d8-9cad-89a2de009915/how-webassembly-works.png))

#### 28. Are you using an ahead-of-time compiler?

Use an [ahead-of-time compiler](https://www.lucidchart.com/techblog/2016/09/26/improving-angular-2-load-times/) to [offload some of the client-side rendering](https://www.smashingmagazine.com/2016/03/server-side-rendering-react-node-express/) to the [server](http://redux.js.org/docs/recipes/ServerRendering.html) and, hence, output usable results quickly. Finally, consider using [Optimize.js](https://github.com/nolanlawson/optimize-js) for faster initial loading by wrapping eagerly invoked functions (it [might not be necessary](https://twitter.com/tverwaes/status/809788255243739136) any longer, though).

!['Fast By Default: Modern Loading Best Practices' by Addy Osmani](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/31237c37-d7db-4faa-9849-51657e122331/babel-preset-opt.png)

From [Fast By Default: Modern Loading Best Practices](https://speakerdeck.com/addyosmani/fast-by-default-modern-loading-best-practices) by the one-and-only Addy Osmani. Slide 76.

#### 29. Serve legacy code only to legacy browsers

With ES2015 being [remarkably well supported in modern browsers](http://kangax.github.io/compat-table/es6/), we can [use `babel-preset-env`](http://2ality.com/2017/02/babel-preset-env.html) to only transpile ES2015+ features unsupported by the modern browsers you are targeting. Then [set up two builds](https://gist.github.com/newyankeecodeshop/79f3e1348a09583faf62ed55b58d09d9), one in ES6 and one in ES5. As mentioned above, JavaScript modules are now [supported in all major browsers](https://caniuse.com/#feat=es6-module), so use [use `script type="module"`](https://developers.google.com/web/fundamentals/primers/modules) to let browsers with ES module support load the file, while older browsers could load legacy builds with `script nomodule`. And we can automate the entire process with [Webpack ESNext Boilerplate](https://github.com/philipwalton/webpack-esnext-boilerplate).

Note that these days we can write module-based JavaScript that runs natively in the browser, without transpilers or bundlers. [`<link rel="modulepreload">` header](https://developers.google.com/web/updates/2017/12/modulepreload) provides a way to initiate early (and high-priority) loading of module scripts. Basically, it’s a nifty way to help in maximizing bandwidth usage, by telling the browser about what it needs to fetch so that it’s not stuck with anything to do during those long roundtrips. Also, Jake Archibald has published a detailed article with [gotchas and things t keep in mind with ES Modules](https://jakearchibald.com/2017/es-modules-in-browsers/) that’s worth reading.

For lodash, [use `babel-plugin-lodash`](https://github.com/lodash/babel-plugin-lodash) that will load only modules that you are using in your source. Your dependencies might also depend on other versions of Lodash, so [transform generic lodash `requires` to cherry-picked ones](https://www.contentful.com/blog/2017/10/27/put-your-webpack-bundle-on-a-diet-part-3/) to avoid code duplication. This might save you quite a bit of JavaScript payload.

Shubham Kanodia has written a [detailed low-maintenance guide on smart bundling](https://www.smashingmagazine.com/2018/10/smart-bundling-legacy-code-browsers/): to shipping legacy code to only legacy browsers in production with the code snippet you could use right away.

[![As explained in Jake Archibald’s article, inline scripts are deferred until blocking external scripts and inline scripts are executed.](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/d46ddc8b-4bd7-4627-b738-baf62807b26f/inline-scripts-deferred.png)](https://jakearchibald.com/2017/es-modules-in-browsers/) 

Jake Archibald has published a detailed article with [gotchas and things to keep in mind with ES Modules](https://jakearchibald.com/2017/es-modules-in-browsers/), e.g. inline scripts are deferred until blocking external scripts and inline scripts are executed. ([Large preview](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/d46ddc8b-4bd7-4627-b738-baf62807b26f/inline-scripts-deferred.png))

#### 30. Are you using differential serving for JavaScript?

We want to send just the necessary JavaScript through the network, yet it means being slightly more focused and granular about the delivery of those assets. A while back Philip Walton introduced the idea of [differential serving](https://philipwalton.com/articles/deploying-es2015-code-in-production-today/). The idea is to compile and serve two separate JavaScript bundles: the “regular” build, the one with Babel-transforms and polyfills and serve them only to legacy browsers that actually need them, and another bundle (same functionality) that has no transforms or polyfills.

As a result, we help reduce blocking of the main thread by reducing the amount of scripts the browser needs to process. Jeremy Wagner has published a [comprehensive article on differential serving](https://calendar.perfplanet.com/2018/doing-differential-serving-in-2019/) and how to set it up in your build pipeline in 2019, from setting up Babel, to what tweaks you’ll need to make in Webpack, as well as the benefits of doing all this work.

#### 31. Identify and rewrite legacy code with incremental decoupling

Long-living projects have a tendency to gather dust and dated code. Revisit your dependencies and assess how much time would be required to refactor or rewrite legacy code that has been causing trouble lately. Of course, it’s always a big undertaking, but once you know the impact of the legacy code, you could start with [incremental decoupling](https://githubengineering.com/removing-jquery-from-github-frontend/).

First, set up metrics that tracks if the ratio of legacy code calls is staying constant or going down, not up. Publicly discourage the team from using the library and make sure that your CI [alerts](https://github.com/dgraham/eslint-plugin-jquery) developers if it’s used in pull requests. [polyfills](https://githubengineering.com/removing-jquery-from-github-frontend/#polyfills) could help transition from legacy code to rewritten codebase that uses standard browser features.

#### 32. Identify and remove unused CSS/JS

[CSS and JavaScript code coverage](https://developers.google.com/web/updates/2017/04/devtools-release-notes#coverage) in Chrome allows you to learn which code has been executed/applied and which hasn't. You can start recording the coverage, perform actions on a page, and then explore the code coverage results. Once you’ve detected unused code, [find those modules and lazy load with `import()`](https://twitter.com/TheLarkInn/status/1012429019063578624) (see the entire thread). Then repeat the coverage profile and validate that it’s now shipping less code on initial load.

You can use [Puppeteer](https://github.com/GoogleChrome/puppeteer) to [programmatically collect code coverage](https://twitter.com/matijagrcic/statuses/1060863620568043520) and Canary already allows you to [export code coverage results](https://twitter.com/tkadlec/status/1073330247758684163), too. As Andy Davies noted, you might want to collect code coverage for [both modern and legacy browsers](https://twitter.com/AndyDavies/status/1073339071106297856) though. There are many [other use-cases for Puppeteer](https://github.com/GoogleChromeLabs/puppeteer-examples), such as, for example, [automatic visual diffing](https://meowni.ca/posts/2017-puppeteer-tests/) or [monitoring unused CSS with every build](http://blog.cowchimp.com/monitoring-unused-css-by-unleashing-the-devtools-protocol/).

Furthermore, [purgecss](https://github.com/FullHuman/purgecss), [UnCSS](https://github.com/giakki/uncss) and [Helium](https://github.com/geuis/helium-css) can help you remove unused styles from CSS. And if you aren’t certain if a suspicious piece of code is used somewhere, you can follow [Harry Roberts' advice](https://csswizardry.com/2018/01/finding-dead-css/): create a 1×1px transparent GIF for a particular class and drop it into a `dead/` directory, e.g. `/assets/img/dead/comments.gif`. After that, you set that specific image as a background on the corresponding selector in your CSS, sit back and wait for a few months if the file is going to appear in your logs. If there are no entries, nobody had that legacy component rendered on their screen: you can probably go ahead and delete it all.

For the _I-feel-adventurous_-department, you could even automate gathering on unused CSS through a set of pages by [monitoring DevTools using DevTools](http://blog.cowchimp.com/monitoring-unused-css-by-unleashing-the-devtools-protocol/).

#### 33. Trim the size of your JavaScript bundles

As Addy Osmani [noted](https://medium.com/@addyosmani/the-cost-of-javascript-in-2018-7d8950fbb5d4), there’s a high chance you’re shipping full JavaScript libraries when you only need a fraction, along with dated polyfills for browsers that don’t need them, or just duplicate code. To avoid the overhead, consider using [webpack-libs-optimizations](https://github.com/GoogleChromeLabs/webpack-libs-optimizations) that removes unused methods and polyfills during the build process.

Add bundle auditing into your regular workflow as well. There might be some lightweight alternatives to heavy libraries you’ve added years ago, e.g. Moment.js could be replaced with [date-fns](https://github.com/date-fns/date-fns) or [Luxon](https://moment.github.io/luxon/). Benedikt Rötsch’s research [showed](https://www.contentful.com/blog/2017/10/27/put-your-webpack-bundle-on-a-diet-part-3/) that a switch from Moment.js to date-fns could shave around 300ms for First paint on 3G and a low-end mobile phone.

That’s where tools like [Bundlephobia](https://bundlephobia.com/) could help find the cost of adding a npm package to your bundle. You can even [integrate these costs with a Lighthouse Custom Audit](https://github.com/AymenLoukil/Google-lighthouse-custom-audit). This goes for frameworks, too. By removing or trimming the [Vue MDC Adapter](https://speakerdeck.com/addyosmani/web-performance-made-easy?slide=22) (Material Components for Vue), styles drop from 194KB to 10KB.

Feeling adventurous? You could look into [Prepack](https://gist.github.com/gaearon/d85dccba72b809f56a9553972e5c33c4). It compiles JavaScript to equivalent JavaScript code, but unlike Babel or Uglify, it lets you write normal JavaScript code, and outputs equivalent JavaScript code that runs faster.

Alternatively to shipping the entire framework, you could even trim your framework and compile it into a raw JavaScript bundle that does not require additional code. [Svelte does it](https://svelte.technology/), and so does [Rawact Babel plugin](https://github.com/sokra/rawact) which transpiles React.js components to native DOM operations at build-time. Why? Well, as maintainers explain, "react-dom includes code for every possible component/HTMLElement that can be rendered, including code for incremental rendering, scheduling, event handling, etc. But there are applications which do not need all these features (at initial page load). For such applications, it might make sense to use native DOM operations to build the interactive user interface."

[![Webpack comparison](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/e30c7d5b-ef8b-46ba-b0fc-b1d5a31cefff/webpack-comparison.png)](https://cdn-images-1.medium.com/max/2000/1*fdX-6h2HnZ_Mo4fBHflh2w.png) 

In [his article](https://www.contentful.com/blog/2017/10/27/put-your-webpack-bundle-on-a-diet-part-3/), Benedikt Rötsch’s showed that a switch from Moment.js to date-fns could shave around 300ms for First paint on 3G and a low-end mobile phone. ([Large preview](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/e30c7d5b-ef8b-46ba-b0fc-b1d5a31cefff/webpack-comparison.png))

#### 34. Are you using predictive prefetching for JavaScript chunks?

We could use heuristics to decide when to preload JavaScript chunks. [Guess.js](https://github.com/guess-js/guess) is a set of tools and libraries that use Google Analytics data to determine which page a user is mostly likely to visit next from a given page. Based on user navigation patterns collected from Google Analytics or other sources, Guess.js builds a machine-learning model to predict and prefetch JavaScript that will be required in each subsequent page.

Hence, every interactive element is receiving a probability score for engagement, and based on that score, a client-side script decides to prefetch a resource ahead of time. You can integrate the technique to your [Next.js application](https://github.com/mgechev/guess-next), [Angular and React](https://blog.mgechev.com/2018/03/18/machine-learning-data-driven-bundling-webpack-javascript-markov-chain-angular-react/), and there is a [Webpack plugin](https://github.com/guess-js/guess/tree/master/packages/guess-webpack) which automates the setup process as well.

Obviously, you might be prompting the browser to consume unneeded data and prefetch undesirable pages, so it’s a good idea to be quite conservative in the number of prefetched requests. A good use case would be prefetching validation scripts required in the checkout, or speculative prefetch when a critical call-to-action comes into the viewport.

Need something less sophisticated? [Quicklink](https://github.com/GoogleChromeLabs/quicklink) is a small library that automatically prefetches links in the viewport during idle time in attempt to make next-page navigations load faster. However, it’s also data-considerate, so it doesn’t prefetch on 2G or if `Data-Saver` is on.

#### 35. Take advantage of optimizations for your target JavaScript engine
  
Study what JavaScript engines dominate in your user base, then explore ways of optimizing for them. For example, when optimizing for V8 which is used in Blink-browsers, Node.js runtime and Electron, make use of [script streaming](https://blog.chromium.org/2015/03/new-javascript-techniques-for-rapid.html) for monolithic scripts. It allows `async` or `defer scripts` to be parsed on a separate background thread once downloading begins, hence in some cases improving page loading times by up to 10%. Practically, [use `<script defer>`](https://medium.com/reloading/javascript-start-up-performance-69200f43b201#3498) in the `<head>`, so that the [browsers can discover the resource](https://medium.com/reloading/javascript-start-up-performance-69200f43b201#3498) early and then parse it on the background thread.

**Caveat**: _Opera Mini [doesn’t support script deferment](https://caniuse.com/#search=defer), so if you are developing for India or Africa,_ `defer` _will be ignored, resulting in blocking rendering until the script has been evaluated (thanks Jeremy!)_.

[![Progressive booting](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/ab06acd3-833a-4634-abf9-fc8d91939250/fmp-and-tti-opt.jpeg)](https://aerotwist.com/blog/when-everything-is-important-nothing-is/)

[Progressive booting](https://aerotwist.com/blog/when-everything-is-important-nothing-is/) means using server-side rendering to get a quick first meaningful paint, but also include some minimal JavaScript to keep the time-to-interactive close to the first meaningful paint.

#### 36. Client-side rendering or server-side rendering?

In both scenarios, our goal should be to set up [progressive booting](https://aerotwist.com/blog/when-everything-is-important-nothing-is/): Use server-side rendering to get a quick first meaningful paint, but also include some minimal necessary JavaScript to keep the time-to-interactive close to the first meaningful paint. If JavaScript is coming too late after the First Meaningful Paint, the browser might [lock up the main thread](https://davidea.st/articles/measuring-server-side-rendering-performance-is-tricky) while parsing, compiling and executing late-discovered JavaScript, hence handcuffing the [interactivity of site or application](https://philipwalton.com/articles/why-web-developers-need-to-care-about-interactivity/).

To avoid it, always break up the execution of functions into separate, asynchronous tasks, and where possible use `requestIdleCallback`. Consider lazy loading parts of the UI using WebPack’s [dynamic `import()` support](https://developers.google.com/web/updates/2017/11/dynamic-import), avoiding the load, parse, and compile cost until the users really need them (_thanks Addy!_).

In its essence, Time to Interactive (TTI) tells us the time between navigation and interactivity. The metric is defined by looking at the first five-second window after the initial content is rendered, in which no JavaScript tasks take longer than 50ms. If a task over 50ms occurs, the search for a five-second window starts over. As a result, the browser will first assume that it reached Interactive, just to switch to Frozen, just to eventually switch back to Interactive.

Once we reached Interactive, we can then — either on demand or as time allows — boot non-essential parts of the app. Unfortunately, as [Paul Lewis noticed](https://aerotwist.com/blog/when-everything-is-important-nothing-is/#which-to-use-progressive-booting), frameworks typically have no concept of priority that can be surfaced to developers, and hence progressive booting is difficult to implement with most libraries and frameworks. If you have the time and resources, use this strategy to ultimately boost performance.

So, client-side or server-side? If there is no visible benefit to the user, [client-side rendering might not be really necessary](https://medium.com/@addyosmani/the-cost-of-javascript-in-2018-7d8950fbb5d4) — actually, server-side-rendered HTML could be faster. Perhaps you could even [pre-render some of your content with static site generators](https://jamstack.org/) and push them straight to the CDNs, with some JavaScript on top.

Limit the use of client-side frameworks to pages that absolutely require them. Server-rendering and client-rendering are a disaster if done poorly. Consider [pre-rendering at build time](https://github.com/GoogleChromeLabs/prerender-loader) and [CSS inlining on the fly](https://github.com/GoogleChromeLabs/critters) to produce production-ready static files. Addy Osmani has given a [fantastic talk on the Cost of JavaScript](https://www.youtube.com/watch?v=63I-mEuSvGA) that might be worth watching.

#### 37. Constrain the impact of third-party scripts.

With all performance optimizations in place, often we can’t control third-party scripts coming from business requirements. Third-party-scripts metrics aren’t influenced by end-user experience, so too often one single script ends up calling a long tail of obnoxious third-party scripts, hence ruining a dedicated performance effort. To contain and mitigate performance penalties that these scripts bring along, it’s not enough to just load them asynchronously ([probably via defer](https://www.twnsnd.com/posts/performant_third_party_scripts.html)) and accelerate them via resource hints such as `dns-prefetch` or `preconnect`.

As Yoav Weiss explained in his [must-watch talk on third-party scripts](http://conffab.com/video/taking-back-control-over-third-party-content/), in many cases these scripts download resources that are dynamic. The resources change between page loads, so we don’t necessarily know which hosts the resources will be downloaded from and what resources they would be.

What options do we have then? Consider **using service workers by racing the resource download with a timeout** and if the resource hasn’t responded within a certain timeout, return an empty response to tell the browser to carry on with parsing of the page. You can also log or block third-party requests that aren’t successful or don’t fulfill certain criteria. If you can, [load the 3rd-party-script from your own server](https://medium.com/caspertechteam/we-shaved-1-7-seconds-off-casper-com-by-self-hosting-optimizely-2704bcbff8ec) rather than from the vendor’s server.

[![Casper.com published a detailed case study on how they managed to shave 1.7 seconds off the site by self-hosting Optimizely. It might be worth it.](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/cf570272-840e-4cf8-92de-76808a12422c/casper-case-study-optimizely.png)](https://medium.com/caspertechteam/we-shaved-1-7-seconds-off-casper-com-by-self-hosting-optimizely-2704bcbff8ec) 

Casper.com published a detailed case study on how they managed to shave 1.7 seconds off the site by self-hosting Optimizely. It might be worth it. ([Image source](https://medium.com/caspertechteam/we-shaved-1-7-seconds-off-casper-com-by-self-hosting-optimizely-2704bcbff8ec)) ([Large preview](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/cf570272-840e-4cf8-92de-76808a12422c/casper-case-study-optimizely.png))

Another option is to establish a **Content Security Policy (CSP)** to restrict the impact of third-party scripts, e.g. disallowing the download of audio or video. The best option is to embed scripts via `<iframe>` so that the scripts are running in the context of the iframe and hence don’t have access to the DOM of the page, and can’t run arbitrary code on your domain. Iframes can be further constrained using the `sandbox` attribute, so you can disable any functionality that iframe may do, e.g. prevent scripts from running, prevent alerts, form submission, plugins, access to the top navigation, and so on.

For example, it’s probably going to be necessary to allow scripts to run with `<iframe sandbox="allow-scripts">`. Each of the limitations can be lifted via various `allow` values on the `sandbox` attribute ([supported almost everywhere](https://caniuse.com/#search=sandbox)), so constrain them to the bare minimum of what they should be allowed to do.

Consider using Intersection Observer; that would enable ads to be iframed while still dispatching events or getting the information that they need from the DOM (e.g. ad visibility). Watch out for new policies such as [Feature policy](https://www.smashingmagazine.com/2018/12/feature-policy/), resource size limits and CPU/Bandwidth priority to limit harmful web features and scripts that would slow down the browser, e.g. synchronous scripts, synchronous XHR requests, document.write and outdated implementations.

To [stress-test third parties](https://csswizardry.com/2017/07/performance-and-resilience-stress-testing-third-parties/), examine bottom-up summaries in Performance profile page in DevTools, test what happens if a request is blocked or it has timed out — for the latter, you can use WebPageTest’s Blackhole server `blackhole.webpagetest.org` that you can point specific domains to in your `hosts` file. Preferably [self-host and use a single hostname](https://www.twnsnd.com/posts/performant_third_party_scripts.html), but also [generate a request map](https://www.soasta.com/blog/10-pro-tips-for-managing-the-performance-of-your-third-party-scripts/) that exposes fourth-party calls and detect when the scripts change. You can use Harry Roberts' [approach for auditing third parties](https://csswizardry.com/2018/05/identifying-auditing-discussing-third-parties/) and produce spreadsheets like [this one](https://docs.google.com/spreadsheets/d/1uTcRSoJAkXfIm2yfG5hvCSzvSZD9fAwXNQMVK3HdPMI/edit#gid=0). Harry also explains the auditing workflow in his [talk on third-party performance and auditing](https://www.youtube.com/watch?v=bmIUYBNKja4).

![request blocking](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/b1e12dad-ea64-430e-b3db-b67fb76029d8/block-request-url-image-opt.png)

Image credit: [Harry Roberts](https://csswizardry.com/2017/07/performance-and-resilience-stress-testing-third-parties/#request-blocking)

#### 38. Set HTTP cache headers properl

Double-check that `expires`, `max-age`, `cache-control`, and other HTTP cache headers have been set properly. In general, resources should be cacheable either for a [very short time (if they are likely to change) or indefinitely (if they are static)](https://jakearchibald.com/2016/caching-best-practices/) — you can just change their version in the URL when needed. Disable the `Last-Modified` header as any asset with it will result in a conditional request with an `If-Modified-Since`-header even if the resource is in cache. Same with `Etag`.

Use `Cache-control: immutable`, designed for fingerprinted static resources, to avoid revalidation (as of December 2018, [supported in Firefox, Edge and Safari](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Cache-Control); in Firefox only on `https://` transactions). In fact "across all of the pages in the HTTP Archive, 2% of requests and 30% of sites appear to [include at least 1 immutable response](https://discuss.httparchive.org/t/cache-control-immutable-a-year-later/1195). Additionally, most of the sites that are using it have the directive set on assets that have a long freshness lifetime."

Remember the [stale-while-revalidate](https://www.fastly.com/blog/stale-while-revalidate-stale-if-error-available-today)? As you probably know, we specify the caching time with the `Cache-Control` response header, e.g. `Cache-Control: max-age=604800`. After 604800 seconds have passed, the cache will re-fetch the requested content, causing the page to load slower. This slowdown can be avoided by using `stale-while-revalidate`; it basically defines an extra window of time during which a cache can use a stale asset as long as it revalidates it async in the background. Thus, it "hides" latency (both in the network and on the server) from clients.

In October 2018, Chrome published an [intent to ship](https://groups.google.com/a/chromium.org/forum/#!topic/blink-dev/rspPrQHfFkI/discussion) handling of `stale-while-revalidate` in HTTP Cache-Control header, so as a result, it should improve subsequent page load latencies as stale assets are no longer in the critical path. Result: [zero RTT for repeat views](https://twitter.com/RyanTownsend/status/1072443651844911104).

You can use [Heroku’s primer on HTTP caching headers](https://devcenter.heroku.com/articles/increasing-application-performance-with-http-cache-headers), Jake Archibald’s "[Caching Best Practices](https://jakearchibald.com/2016/caching-best-practices/)" and Ilya Grigorik’s [HTTP caching primer](https://developers.google.com/web/fundamentals/performance/optimizing-content-efficiency/http-caching?hl=en) as guides. Also, be wary of the [vary header](https://www.smashingmagazine.com/2017/11/understanding-vary-header/), especially [in relation to CDNs](https://www.fastly.com/blog/getting-most-out-vary-fastly), and watch out for the [Key header](https://www.greenbytes.de/tech/webdav/draft-ietf-httpbis-key-latest.html) which helps avoiding an additional round trip for validation whenever a new request differs slightly (but not significantly) from prior requests (_thanks, Guy!_).

Also, double-check that you aren’t sending [unnecessary headers](https://www.fastly.com/blog/headers-we-dont-want) (e.g. `x-powered-by`, `pragma`, `x-ua-compatible`, `expires` and others) and that you include [useful security and performance headers](https://www.fastly.com/blog/headers-we-want) (such as `Content-Security-Policy`, `X-XSS-Protection`, `X-Content-Type-Options` and others). Finally, keep in mind the [performance cost of CORS requests](https://medium.com/@ankur_anand/the-terrible-performance-cost-of-cors-api-on-the-single-page-application-spa-6fcf71e50147) in single-page applications.

> [译] [2019 前端性能优化年度总结 — 第一部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-1.md)
> [译] [2019 前端性能优化年度总结 — 第二部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-2.md)
> [译] [2019 前端性能优化年度总结 — 第三部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-3.md)
> **[译] [2019 前端性能优化年度总结 — 第四部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-4.md)**
> [译] [2019 前端性能优化年度总结 — 第五部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-5.md)
> [译] [2019 前端性能优化年度总结 — 第六部分](https://github.com/xitu/gold-miner/blob/master/TODO1/front-end-performance-checklist-2019-pdf-pages-6.md)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
