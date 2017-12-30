> * 原文地址：[A Tinder Progressive Web App Performance Case Study](https://medium.com/@addyosmani/a-tinder-progressive-web-app-performance-case-study-78919d98ece0)
> * 原文作者：[Addy Osmani](https://medium.com/@addyosmani?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/a-tinder-progressive-web-app-performance-case-study.md](https://github.com/xitu/gold-miner/blob/master/TODO/a-tinder-progressive-web-app-performance-case-study.md)
> * 译者：
> * 校对者：

# A Tinder Progressive Web App Performance Case Study

![](https://cdn-images-1.medium.com/max/2000/1*j2n8zzLYxoum1ob-1mjUcw.png)

Tinder recently swiped right on the web. Their new responsive [Progressive Web App](https://developers.google.com/web/progressive-web-apps/) — [Tinder Online](https://tinder.com) — is available to 100% of users on desktop and mobile, employing techniques for [JavaScript performance optimization](https://medium.com/dev-channel/the-cost-of-javascript-84009f51e99e), [Service Workers](https://developers.google.com/web/fundamentals/primers/service-workers/) for network resilience and [Push Notifications](https://developers.google.com/web/fundamentals/push-notifications/) for chat engagement. Today we’ll walk through some of their web perf learnings.

![](https://cdn-images-1.medium.com/max/1000/1*1HmfQhMAQL8kukiNtMZRjA.png)

### Journey to a Progressive Web App

Tinder Online started with the goal of getting adoption in new markets, striving to hit feature parity with V1 of Tinder’s experience on other platforms.

**The MVP for the PWA took 3 months to implement using** [**React**](https://reactjs.com) **as their UI library and** [**Redux**](https://redux.js.org) **for state management.** The result of their efforts is a PWA that delivers the core Tinder experience in **10%** of the data-investment costs for someone in a data-costly or data-scarce market:

![](https://cdn-images-1.medium.com/max/1000/1*cqYbI-L0zukfYS0ZAwUtqA.png)

Comparing the data-investment for Tinder Online vs the native apps. It’s important to note that this isn’t comparing apples to apples, however. The PWA loads code for new routes on demand, and the cost of additional code is amortized over the lifetime of the application. Subsequent navigations still don’t cost as much data as the download of the app.

Early signs show good swiping, messaging and session length compared to the native app. With the PWA:

* Users swipe more on web than their native apps
* Users message more on web than their native apps
* Users purchase on par with native apps
* Users edit profiles more on web than on their native apps
* Session times are longer on web than their native apps

### Performance

The mobile devices Tinder Online’s users most commonly access their web experience with include:

* Apple iPhone & iPad
* Samsung Galaxy S8
* Samsung Galaxy S7
* Motorola Moto G4

Using the [Chrome User Experience report](https://developers.google.com/web/tools/chrome-user-experience-report/) (CrUX), we’re able to learn that the majority of users accessing the site are on a 4G connection:

![](https://cdn-images-1.medium.com/max/1000/1*gO4n3kBs5Zy1eAkMQqxx7w.png)

_Note: Rick Viscomi recently covered CrUX on_ [_PerfPlanet_](https://calendar.perfplanet.com/2017/finding-your-competitive-edge-with-the-chrome-user-experience-report/) _and Inian Parameshwaran covered_ [_rUXt_](https://calendar.perfplanet.com/2017/introducing-ruxt-visualizing-real-user-experience-data-for-1-2-million-websites/) _for better visualizing this data for the top 1M sites._

Testing the new experience on [WebPageTest](https://www.webpagetest.org/result/171224_ZB_13cef955385ddc4cae8847f451db8403/) and [Lighthouse](https://github.com/GoogleChrome/lighthouse/) (using the Galaxy S7 on 4G) we can see that they’re able to load and get interactive in **under 5 seconds**:

![](https://cdn-images-1.medium.com/max/1000/1*e-EHgbBBNXyuce8Z836Sgg.png)

There is of course **lots of room** to improve this further on [median mobile hardware](https://www.webpagetest.org/lighthouse.php?test=171224_NP_f7a489992a86a83b892bf4b4da42819d&run=3) (like the Moto G4), which is more CPU constrained:

![](https://cdn-images-1.medium.com/max/1000/1*VJ3ZbSQtIjxsIW8Feuiejw.png)

Tinder are hard at work on optimizing their experience and we look forward to hearing about their work on web performance in the near future.

### Performance Optimization

Tinder were able to improve how quickly their pages could load and become interactive through a number of techniques. They implemented route-based code-splitting, introduced performance budgets and long-term asset caching.

### Route-level code-splitting

Tinder initially had large, monolithic JavaScript bundles that delayed how quickly their experience could get interactive. These bundles contained code that wasn’t immediately needed to boot-up the core user experience, so it could be broken up using [code-splitting](https://webpack.js.org/guides/code-splitting/). **It’s generally useful to only ship code users need upfront and lazy-load the rest as needed**.

To accomplish this, Tinder used [React Router](https://reacttraining.com/react-router/) and [React Loadable](https://github.com/thejameskyle/react-loadable). As their application centralized all their route and rendering info a configuration base, they found it straight-forward to implement code splitting at the top level.

**In summary:**

React Loadable is a small library by James Kyle to make component-centric **code splitting** easier in React. **Loadable** is a higher-order component (a function that creates a component) which makes it easy to **split** up bundles at a component level.

Let’s say we have two components “A” and “B”. Before code-splitting, Tinder statically imported everything (A, B, etc) into their main bundle. This was inefficient as we didn’t need both A and B right away:

![](https://cdn-images-1.medium.com/max/1000/1*DoTby4l_-A3TNdiUSZ0LmA.png)

After adding code-splitting, components A and B could be loaded as and when needed. Tinder did this by introducing React Loadable, [dynamic import()](https://webpack.js.org/guides/code-splitting/#dynamic-imports) and [webpack’s magic comment syntax](https://medium.com/faceyspacey/how-to-use-webpacks-new-magic-comment-feature-with-react-universal-component-ssr-a38fd3e296a) (for naming dynamic chunks) to their JS:

![](https://cdn-images-1.medium.com/max/1000/1*aPY-1uGEvPV1dNKrrD8z4Q.png)

For “vendor” (library) chunking, Tinder used the webpack [**CommonsChunkPlugin**](https://webpack.js.org/plugins/commons-chunk-plugin/) to move commonly used libraries across routes up to a single bundle file that could be cached for longer periods of time:

![](https://cdn-images-1.medium.com/max/1000/1*R-kXPcn937BNoFXLukPJPg.png)

Next, Tinder used [React Loadable’s preload support](https://github.com/thejameskyle/react-loadable#loadablecomponentpreload) to preload potential resources for the next page on control component:

![](https://cdn-images-1.medium.com/max/1000/1*G2JvbNCsm4eBXbGgyW6OmA.png)

Tinder also used [Service Workers](https://developers.google.com/web/fundamentals/primers/service-workers/) to precache all their route level bundles and include routes that users are most likely to visit in the main bundle without code-splitting. They’re of course also using common optimizations like JavaScript minification via UglifyJS:

```
new webpack.optimize.UglifyJsPlugin({
      parallel: true,
      compress: {
        warnings: false,
        screw_ie8: true
      },
      sourceMap: SHOULD_SOURCEMAP
    }),
```

#### Impact

After introducing route-based code-splitting their main bundle sizes went down from 166KB to 101KB and DCL improved from 5.46s to 4.69s:

![](https://cdn-images-1.medium.com/max/1000/1*1Tt8bnnkyIi8aEw0BjRgMw.png)

### Long-term asset caching

Ensuring [long-term caching](https://webpack.js.org/guides/caching/) of static resources output by webpack benefits from using [chunkhash] to add a cache-buster to each file.

![](https://cdn-images-1.medium.com/max/1000/1*nofQB3Q-8IUo9f1Eipd0xw.png)

Tinder were using a number of open-source (vendor) libraries as part of their dependency tree. Changes to these libraries would originally cause the [chunkhash] to change and invalidate their cache. To address this, Tinder began defining a [whitelist of external dependencies](https://gist.github.com/tinder-rhsiao/89cd682c34d1e1307111b091801e6fe5]%28https://gist.github.com/tinder-rhsiao/89cd682c34d1e1307111b091801e6fe5) and splitting out their webpack manifest from the main chunk to improve caching. The bundle size is now about 160KB for both chunks.

### Preloading late-discovered resources

As a refresher, [<link rel=preload>](https://developers.google.com/web/fundamentals/performance/resource-prioritization) is a declarative instruction to the browser to load critical, late-discovered resources earlier on. In single-page applications, these resources can sometimes be JavaScript bundles.

![](https://cdn-images-1.medium.com/max/800/1*CaObLc_tGJvnllyV3CGD5w.png)

Tinder implemented support for to preload their critical JavaScript/webpack bundles that were important for the core experience. This reduced load time by 1s and first paint from 1000ms to about 500ms.

![](https://cdn-images-1.medium.com/max/1000/1*AtzElAKy_pCvRjZN__YSsQ.png)

### Performance budgets

Tinder adopted **performance budgets** for helping them hit their performance goals on mobile. As Alex Russell noted in “[Can you afford it?: real-world performance budgets](https://infrequently.org/2017/10/can-you-afford-it-real-world-web-performance-budgets/)”, you have a limited headroom to deliver an experience when considering slow 3G connections being used on median mobile hardware.

To get and stay interactive quickly, Tinder enforced a budget of ~155KB for their main and vendor chunks, asynchronous (lazily loaded) chunks are ~55KB and other chunks are ~35KB. CSS has a limit of 20KB. This was crucial to ensuring they were able to avoid regressing on performance.

![](https://cdn-images-1.medium.com/max/1000/1*OgDLsMxsy6IO79NmjQtcng.png)

### Webpack Bundle Analysis

[Webpack Bundle Analyzer](https://github.com/webpack-contrib/webpack-bundle-analyzer) allows you to discover what the dependency graph for your JavaScript bundles looks like so you can discover whether there’s low-hanging fruit to optimize.

![](https://cdn-images-1.medium.com/max/800/1*qsiUA0G50a4p3y2e4p7CyA.png)

Tinder used Webpack Bundle Analyzer to discover areas for improvement:

* **Polyfills:** Tinder are targeting modern browsers with their experience but also support IE11 and Android 4.4 and above. **To keep polyfills & transpiled code to a minimum, they use For polyfills, they use** [**babel-preset-env**](https://github.com/babel/babel-preset-env) **and** [**core-js**](https://github.com/zloirock/core-js)**.**
* **Slimmer use of libraries:** Tinder replaced [localForage](https://github.com/localForage/localForage) with direct use of IndexedDB.
* **Better splitting:** Split out components from the main bundles which were not required for first paint/interactive
* **Code re-use:** Created asynchronous common chunks to abstract chunks used more than three times from children.
* **CSS:** Tinder also removed [critical CSS](https://www.smashingmagazine.com/2015/08/understanding-critical-css/) from their core bundles (as they had shifted to server-side rendering and delivered this CSS anyway)

![](https://cdn-images-1.medium.com/max/800/1*ZL3i2BRHo8Sq_dv1NyA8Dw.png)

Using bundle analysis led to also also taking advantage of Webpack’s [Lodash Module Replacement Plugin](https://github.com/lodash/lodash-webpack-plugin). The plugin creates smaller Lodash builds by replacing feature sets of modules with noop, identity or simpler alternatives:

![](https://cdn-images-1.medium.com/max/1000/1*of2Mv5ypTySRpTZQZVRj7A.png)

Webpack Bundle Analyzer can be integrated into your Webpack config. Tinder’s setup for it looks like this:

```
plugins: [
      new BundleAnalyzerPlugin({
        analyzerMode: 'server',
        analyzerPort: 8888,
        reportFilename: 'report.html',
        openAnalyzer: true,
        generateStatsFile: false,
        statsFilename: 'stats.json',
        statsOptions: null
      })
```

The majority of the JavaScript left is the main chunk which is trickier to split out without architecture changes to Redux Reducer and Saga Register.

### CSS Strategy

Tinder are using [Atomic CSS](https://acss.io/) to create highly reusable CSS styles. All of these atomic CSS styles are inlined in the initial paint and some of the rest of the CSS is loaded in the stylesheet (including animation or base/reset styles). Critical styles have a maximum size of 20KB gzipped, with recent builds coming in at a lean < 11KB.

Tinder use [CSS stats](http://cssstats.com/stats?url=https%253A%252F%252Ftinder.com&ua=Browser%2520Default%0A) and Google Analytics for each release to keep track of what has changed. Before Atomic CSS was being used, average page load times were ~6.75s. After they were ~5.75s.

![](https://cdn-images-1.medium.com/max/1000/1*Uv_at6Xs7QYHZJ0iy8c7GQ.png)

Tinder Online also uses the PostCSS [Autoprefixer plugin](https://twitter.com/autoprefixer) to parse CSS and add vendor prefixes based on rules from [Can I Use](http://caniuse.com):

```
new webpack.LoaderOptionsPlugin({
    options: {
    context: paths.basePath,
    output: { path: './' },
    minimize: true,
    postcss: [
        autoprefixer({
        browsers: [
            'last 2 versions',
            'not ie < 11',
            'Safari >= 8'
        ]
        })
      ]
    }
}),
```

### Runtime performance

#### Deferring non-critical work with requestIdleCallback()

To improve runtime performance, Tinder opted to use [requestIdleCallback()](https://developers.google.com/web/updates/2015/08/using-requestidlecallback) to defer non-critical actions into idle time.

```
requestIdleCallback(myNonEssentialWork);
```

This included work like instrumentation beacons. They also simplified some HTML composite layers to reduce paint count while swiping.

**Using requestIdleCallback() for their instrumentation beacons while swiping:**

before..

![](https://cdn-images-1.medium.com/max/800/1*oHJ8IjCs7AKdCrt9b28ZPw.png)

and after..

![](https://cdn-images-1.medium.com/max/800/1*UTQuSSp7MGMY06mwYtQmaw.png)

### Dependency upgrades

**Webpack 3 + Scope Hoisting**

In older versions of webpack, when bundling each module in your bundle would be wrapped in individual function closures. These wrapper functions made it slower for your JavaScript to execute in the browser. [Webpack 3](https://medium.com/webpack/webpack-3-official-release-15fd2dd8f07b) introduced “scope hoisting” — the ability to concatenate the scope of all your modules into one closure and allow for your code to have a faster execution time in the browser. It accomplishes this with the Module Concatenation plugin:

```
new webpack.optimize.ModuleConcatenationPlugin()
```

**Webpack 3’s scope hoisting improved Tinder’s initial JavaScript parsing time for vendor chunk by 8%.**

**React 16**

React 16 introduced improvements that [decreased React’s bundle size](https://reactjs.org/blog/2017/09/26/react-v16.0.html#reduced-file-size) compared to previous versions. This was in part due to better packaging (using Rollup) as well as removing now unused code.

**By updating from React 15 to React 16, Tinder reduced the total gzipped size of their vendor chunk by ~7%.**

The size of react + react-dom used to be~50KB gzipped and is now just ~**35KB**. Thanks to [Dan Abramov](https://twitter.com/dan_abramov), [Dominic Gannaway](https://twitter.com/trueadm) and [Nate Hunzaker](https://twitter.com/natehunzaker) who were instrumental in trimming down React 16’s bundle size.

### Workbox for network resilience and offline asset caching

Tinder also use the [Workbox Webpack plugin](https://developers.google.com/web/tools/workbox/get-started/webpack) for caching both their [Application Shell](https://developers.google.com/web/fundamentals/architecture/app-shell) and their core static assets like their main, vendor, manifest bundles and CSS. This enables network resilience for repeat visits and ensures that the application starts-up more quickly when a user returns for subsequent visits.

![](https://cdn-images-1.medium.com/max/1000/1*yXpAzyA1ODPk2OSOTA6Lhg.png)

### Opportunities

Digging into the Tinder bundles using [source-map-explorer](https://www.npmjs.com/package/source-map-explorer) (another bundle analysis tool), there are additional opportunities for reducing payload size. Before logging in, components like Facebook Photos, notifications, messaging and captchas are fetched. Moving these away from the critical path could save up to 20% off the main bundle:

![](https://cdn-images-1.medium.com/max/1000/1*G1nq7BNZPEo2mFr_my5zjA.png)

Another dependency in the critical path is a 200KB Facebook SDK script. Dropping this script (which could be lazily loaded when needed) could shave 1 second off initial loading time.

### Conclusions

Tinder are still iterating on their Progressive Web App but have already started to see positive results from the fruits of their labor. Check out Tinder.com and stay tuned for more progress in the near future!

_With thanks and congrats to Roderick Hsiao, Jordan Banafsheha, and Erik Hellenbrand for launching Tinder Online and their input to this article. Thanks to Cheney Tsai for his review._

**Related reading:**

* [A Pinterest PWA performance case study](https://medium.com/dev-channel/a-pinterest-progressive-web-app-performance-case-study-3bd6ed2e6154)
* [A Treebo React & Preact performance case study](https://medium.com/dev-channel/treebo-a-react-and-preact-progressive-web-app-performance-case-study-5e4f450d5299)
* [Twitter Lite and high-performance PWAs at scale](https://medium.com/@paularmstrong/twitter-lite-and-high-performance-react-progressive-web-apps-at-scale-d28a00e780a3)

This article was cross-posted from [Performance Planet](https://calendar.perfplanet.com/2017/a-tinder-progressive-web-app-performance-case-study/). If you’re new to React, I’ve found [React for Beginners](https://goo.gl/G1WGxU) a comprehensive starting point.


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
