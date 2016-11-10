> * 原文地址：[Progressive Web Apps with React.js: Part 2 — Page Load Performance](https://medium.com/@addyosmani/progressive-web-apps-with-react-js-part-2-page-load-performance-33b932d97cf2#.o0f4vf64s)
* 原文作者：[Addy Osmani](https://medium.com/@addyosmani)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

# Progressive Web Apps with React.js: Part 2 — Page Load Performance






## Part 2 of a new [series](https://medium.com/@addyosmani/progressive-web-apps-with-react-js-part-i-introduction-50679aef2b12#.ysn8uhvkq) walking through tips for shipping mobile web apps optimized using [Lighthouse.](https://github.com/googlechrome/lighthouse) This issue, we’ll be looking at page load performance.

### Ensure Page load performance is fast

Mobile web speeds matter. On average, faster experiences lead to [70% longer sessions](https://www.doubleclickbygoogle.com/articles/mobile-speed-matters/) and 2 x more mobile ad revenue. Investments in web perf saw the React-based, Flipkart Lite [triple time-on-site](https://developers.google.com/web/showcase/2016/flipkart), GQ get an [80% increase](http://digiday.com/publishers/gq-com-cut-page-load-time-80-percent/) in traffic, Trainline make an [additional 11M in yearly revenue](https://youtu.be/ai-6qwT6ES8?t=462) and Instagram [increase impressions by 33%](http://engineering.instagram.com/posts/193415561023919/performance-&-usage-at-Instagram).

There are a few [key user moments](https://www.youtube.com/watch?v=wFwogd4CdwY&index=4&list=PLNYkxOF6rcIB3ci6nwNyLYNU6RDOU3YyL) in loading up your web app:









![](https://cdn-images-1.medium.com/max/2000/0*KlJk2hhZl3wyn6E4.)









It’s always important to measure and then optimize. Lighthouse’s load performance audits look at:

*   [**First meaningful paint**](https://www.quora.com/What-does-First-Meaningful-Paint-mean-in-Web-Performance) (when is the main content of the page visible)
*   [**Speed Index**](https://sites.google.com/a/webpagetest.org/docs/using-webpagetest/metrics/speed-index) (visual completeness)
*   **Estimated Input Latency** (when is the main thread available to immediately handle user input)
*   and **Time To Interactive** (how soon is the app usable & engagable)

_Btw, Paul Irish has done terrific work summarising_ [_interesting metrics for PWAs_](https://www.youtube.com/watch?v=IxXGMesq_8s)_worth keeping an eye out._

**Good performance goals:**

*   **Follow L in the** [**RAIL performance model**](https://developers.google.com/web/tools/chrome-devtools/profile/evaluate-performance/rail?hl=en)**.** _A+ performance is something all of us should be striving for even if a browser doesn’t support Service Worker. We can still get something meaningful on the screen quickly & only load what we need_
*   **Under representative network (3G) & hardware conditions**
*   Be interactive in < 5s on first visit & < 2s on repeat visits once a Service Worker is active.
*   First load (network-bound), Speed Index of 3,000 or less
*   Second load (disk-bound because SW): Speed Index of 1,000 or less.

Let’s talk a little more about focusing on interactivity via TTI.

### Focus on Time to interactive (TTI)

Optimizing for interactivity means making the app usable for users as soon as possible (i.e enabling them to click around and have the app react). This is critical for modern web experiences trying to provide first-class user experiences on mobile.





![](https://cdn-images-1.medium.com/max/1600/0*qfZvSxxJxPHhXXgb.)





Lighthouse currently expresses TTI as a measure of when layout has stabilized, web fonts are visible and the main thread is available enough to handle user input. There are many ways of tracking TTI manually and what’s important is optimising for metrics that result in experience improvements for your users.

For libraries like React, you should be concerned by the [cost of booting up the library](https://aerotwist.com/blog/the-cost-of-frameworks/) on mobile as this can catch folks out. In [ReactHN](https://github.com/insin/react-hn), we accomplished interactivity in under **1700ms** by keeping the size and execution cost of the overall app relatively small despite having multiple views: 11KB gzipped for our app bundle and 107KB for our vendor/React/libraries bundle which looks a little like this in practice:









![](https://cdn-images-1.medium.com/max/2000/0*N--j53GygKHn2ViI.)









Later, for apps with granular functionality, we’ll look at performance patterns like [PRPL](https://www.polymer-project.org/1.0/toolbox/server) which nail fast time-to-interactivity through granular “route-based chunking” while taking advantage of [HTTP/2 Server Push](https://www.igvita.com/2013/06/12/innovating-with-http-2.0-server-push/) (try the [Shop](https://shop.polymer-project.org/) demo to see what we mean).

Housing.com recently shipped a React experience using a PRPL-like pattern to much praise:



















![](https://cdn-images-1.medium.com/max/1600/0*55ArR_Z3qt7Az_FW.)



Housing.com took advantage of Webpack route-chunking to defer some of the bootup cost of entry pages (loading only what is needed for a route to render). For more detail see [Sam Saccone’s excellent Housing.com perf audit](https://twitter.com/samccone/status/771786445015035904).



As did Flipkart:















Note: There are many differing views on what “time to interactive” might mean and it’s possible Lighthouse’s definition of TTI will evolve. Other ways to track it could be the first point after a navigation where you can see a 5 second window with no long tasks or the first point after a text/content paint with a 5s window with no long tasks. Basically, how soon after the page settles is it likely a user will be able to interact with the app?

Note: While not a firm requirement, you may also improve visual completeness (Speed Index) by [optimising the critical-rendering path](https://developers.google.com/web/fundamentals/performance/critical-rendering-path/). [Tooling for critical-path CSS optimisation exists](https://github.com/addyosmani/critical-path-css-tools#node-modules) and this optimisation can still have wins in a world with HTTP/2.

### Improving perf with route-based chunking

### Webpack

_If you’re new to module bundling tools like Webpack,_ [_JS module bundlers_](https://www.youtube.com/watch?v=OhPUaEuEaXk)_(video) might be a useful watch._

Some of today’s JavaScript tooling makes it easy to bundle all of your scripts into a single bundle.js file that gets included in all pages.This means that a lot of the time, you’re likely loading a lot of code that isn’t required at all for the current route. Why load up 500KB of JS for a route when only 50KB will do? We should be throwing out script that isn’t conducive to shipping a fast experience for booting up a route with interactivity





![](https://cdn-images-1.medium.com/max/1600/0*z2tqS124xW0GDmcP.)





_Avoid serving large, monolithic bundles (like above) when just serving the minimum functionally viable code a user actually needs for a route will do._

Code-splitting is one answer to the problem of monolithic bundles. It’s the idea that by defining split-points in your code, it can be split into different files that are lazy loaded on demand. This improves startup time and help us get to being interactive sooner.









![](https://cdn-images-1.medium.com/max/2000/0*c9rmq2rp95BN39qg.)









Imagine using an apartment listings app. If we land on a route listing the properties in our area (route-1) — we don’t need the code for viewing the full details for a property (route-2) or scheduling a tour (route-3), so we can serve users just the JavaScript needed for the listings route and dynamically load the rest.

This idea of code-splitting by route been used by many apps over the years, but is currently referred to as “[route-based chunking](https://gist.github.com/addyosmani/44678d476b8843fd981ff8011d389724)”. We can enable this setup for React using the Webpack module bundler.

### Code-splitting by routes in practice

Webpack supports code-splitting your app into chunks wherever it notices a [require.ensure()](https://webpack.github.io/docs/code-splitting.html) being used (or in [Webpack 2](https://gist.github.com/sokra/27b24881210b56bbaff7), a [System.import](http://moduscreate.com/code-splitting-for-react-router-with-es6-imports/)). These are called “split-points” and Webpack generates a separate bundle for each of them, resolving dependencies as needed.

    // Defines a "split-point"
    require.ensure([], function () {
       const details = require('./Details');
       // Everything needed by require() goes into a separate bundle
       // require(deps, cb) is asynchronous. It will async load and evaluate
       // modules, calling cb with the exports of your deps.
    });

When your code needs something, Webpack makes a JSONP call to fetch it from the server. This works well with React Router and we can lazy-load in the dependencies (chunks) a new route needs before rendering the view to a user.

Webpack 2 supports [automatic code-splitting with React Router](https://medium.com/modus-create-front-end-development/automatic-code-splitting-for-react-router-w-es6-imports-a0abdaa491e9#.3ryyedhfc) as it can treat System.import calls for modules as import statements, bundling imported filed and their dependencies together. Dependencies won’t collide with the initial entry in your Webpack configuration.

    import App from '../containers/App';

    function errorLoading(err) {
      console.error('Lazy-loading failed', err);
    }

    function loadRoute(cb) {
      return (module) => cb(null, module.default);
    }
    export default {
      component: App,
      childRoutes: [
        // ...
        {
          path: 'booktour',
          getComponent(location, cb) {
            System.import('../pages/BookTour')
              .then(loadRoute(cb))
              .catch(errorLoading);
          }
        }
      ]
    };

### Bonus: Preload those routes!

Before we continue, one optional addition to your setup is [](https://www.smashingmagazine.com/2016/02/preload-what-is-it-good-for/) from [Resource Hints](https://twitter.com/addyosmani/status/743571393174872064). This gives us a way to declaratively fetch resources without executing them. Preload can be leveraged for preloading Webpack chunks for routes users _are likely_ to navigate to so the cache is already primed with them and they’re instantly available for instantiation.





![](https://cdn-images-1.medium.com/max/1600/0*l-XqjMw7_XX0wsxX.)





At the time of writing, preload is only implemented in [Chrome](http://caniuse.com/#feat=link-rel-preload), but can be treated as a progressive enhancement for browsers that do support it.

Note: html-webpack-plugin’s [templating and custom-events](https://github.com/ampedandwired/html-webpack-plugin#events) can make setting this up a trivial process with minimal changes. You should however ensure that resources being preloaded are genuinely going to be useful for your averages users journey.

### Asynchronously loading routes

Back to code-splitting — in an app using React and [React Router](https://github.com/reactjs/react-router), we can use require.ensure() to asynchronously load a component as soon as ensure gets called. Btw, this needs to be shimmed in Node using the [node-ensure](https://www.npmjs.com/package/node-ensure)package for anyone exploring server-rendering. Pete Hunt covers async loading in [Webpack How-to](https://github.com/petehunt/webpack-howto#9-async-loading).

In the below example, require.ensure() enables us to lazy load routes as needed, waiting on a component to be fetched before it is used:

    const rootRoute = {
      component: Layout,
      path: '/',
      indexRoute: {
        getComponent (location, cb) {
          require.ensure([], () => {
            cb(null, require('./Landing'))
          })
        }
      },
      childRoutes: [
        {
          path: 'book',
          getComponent (location, cb) {
            require.ensure([], () => {
              cb(null, require('./BookTour'))
            })
          }
        },
        {
          path: 'details/:id',
          getComponent (location, cb) {
            require.ensure([], () => {
              cb(null, require('./Details'))
            })
          }
        }
      ]
    }

_Note: I often use the above setup with the CommonChunksPlugin (with minChunks: Infinity) so I have one chunk with common modules between my different entry points. This also_ [_minimized_](https://github.com/webpack/webpack/issues/368#issuecomment-247212086) _running into missing Webpack runtime._

Brian Holt covers async route loading well in a [Complete Intro to React](https://btholt.github.io/complete-intro-to-react/). Code-splitting with async routing is possible with both the current version of React Router and the [new React Router V4](https://gist.github.com/acdlite/a68433004f9d6b4cbc83b5cc3990c194).

### Easy declarative route chunking with async getComponent + require.ensure()

Here’s a tip for getting code-splitting setup even faster. In React Router, a [declarative route](https://github.com/ReactTraining/react-router/blob/master/docs/API.md#route) for mapping a route “/” to a component `App` looks like .

React Router also supports a handy `[getComponent](https://github.com/ReactTraining/react-router/blob/master/docs/API.md#getcomponentnextstate-callback)` attribute, which is similar to `component` but is asynchronous and is **super nice** for getting code-splitting setup quickly:

     {
       // async work to find components
      cb(null, Stories)
    }} />

`getComponent` takes a function defining the next state (which I set to null) and a callback.

Let’s add some route-based code-splitting to [ReactHN](https://github.com/insin/react-hn). We’ll start with a snippet from our [routes](https://github.com/insin/react-hn/blob/master/src/routes.js#L36) file — this defines require calls for components and React Router routes for each route (e.g news, item, poll, job, comment permalinks etc):

    var IndexRoute = require('react-router/lib/IndexRoute')
    var App = require('./App')
    var Item = require('./Item')
    var PermalinkedComment = require('./PermalinkedComment') <--
    var UserProfile = require('./UserProfile')
    var NotFound = require('./NotFound')
    var Top = stories('news', 'topstories', 500)
    // ....

    module.exports = 
      
      
      
      
      
       <---
      
      
      
    

ReactHN currently serve users a monolithic bundle of JS with code for _all_routes. Let’s switch it up to route-chunking and only serve exactly the code needed for a route, starting with comment permalinks (comment/:id):

So we first delete the implicit require for the permalink component:

    var PermalinkedComment = require(‘./PermalinkedComment’)

Then we take our route..

    

And update it with some declarative getComponent goodness. We’ve got our require.ensure() call to lazy-load in our route and this is all we need to do for code-splitting:

     {
          require.ensure([], require => {
            callback(null, require('./PermalinkedComment'))
          }, 'PermalinkedComment')
        }}
      />

OMG beautiful. And..that’s it. Seriously. We can apply this to the rest of our routes and run webpack. It will correctly find the require.ensure() calls and split our code as we intended.





![](https://cdn-images-1.medium.com/max/1600/0*glKcFK9_RLNk9AyR.)





After applying declarative code-splitting to many more of our routes we can see our route-chunking in action, only loading up the code needed for a route (which we can precache in Service Worker) as needed:





![](https://cdn-images-1.medium.com/max/1600/0*tVvolw4FTKjNFAnY.)





Reminder: A number of drop-in Webpack plugins for Service Worker caching are available:

*   [sw-precache-webpack-plugin](https://github.com/goldhand/sw-precache-webpack-plugin) which uses sw-precache under the hood
*   [offline-plugin](https://github.com/NekR/offline-plugin) which is used by react-boilerplate

#### CommonsChunkPlugin





![](https://cdn-images-1.medium.com/max/1600/0*QphlrnwHQiOsB06w.)





To identify common modules used across different routes and put them in a commons chunk, use the [CommonsChunkPlugin](https://webpack.github.io/docs/list-of-plugins.html#commonschunkplugin). It requires two script tags to be used per page, one for the commons chunk and one for the entry chunk for a route.

    const CommonsChunkPlugin = require("webpack/lib/optimize/CommonsChunkPlugin");
    module.exports = {
        entry: {
            p1: "./route-1",
            p2: "./route-2",
            p3: "./route-3"
        },
        output: {
            filename: "[name].entry.chunk.js"
        },
        plugins: [
            new CommonsChunkPlugin("commons.chunk.js")
        ]
    }

The Webpack [— display-chunks flag](https://blog.madewithlove.be/post/webpack-your-bags/) is useful for seeing what modules occur in which chunks. This helps narrow down what dependencies are being duplicated in chunks and can hint at whether or not it’s worth enabling the CommonChunksPlugin in your project. Here’s a project with multiple components that detected a duplicate Mustache.js dependency between different chunks:





![](https://cdn-images-1.medium.com/max/1600/0*YMvoz-W2HL3v2MIs.)





Webpack 1 also supports deduplication of libraries in your dependency trees using the [DedupePlugin](https://github.com/webpack/docs/wiki/optimization#deduplication). In Webpack 2, tree-shaking should mostly eliminate the need for this.

**More Webpack tips**

*   The number of require.ensure() calls in your codebase generally correlates to the number of bundles that will be generated. It’s useful to be aware of this when heavily using ensure across your codebase.
*   [Tree-shaking in Webpack2](https://medium.com/modus-create-front-end-development/webpack-2-tree-shaking-configuration-9f1de90f3233) will help remove unused exports. This can help keep your bundle sizes smaller.
*   Also, be careful to avoid require.ensure() calls in common/shared bundles. You might find this creates entry point references which have assumptions about the dependencies that have already been loaded.
*   In Webpack 2, System.import does not currently work with server-rendering but I’ve shared some notes about how to work around this on [StackOverflow](http://stackoverflow.com/a/39088208).
*   If optimising for build speed, look at the [Dll plugin](https://github.com/webpack/docs/wiki/list-of-plugins), [parallel-webpack](https://www.npmjs.com/package/parallel-webpack) and targeted builds
*   If you need to **async** or **defer** scripts with Webpack, see [script-ext-html-webpack-plugin](https://github.com/numical/script-ext-html-webpack-plugin)

**Detecting bloat in Webpack builds**

The Webpack community have many web-established analysers for builds including [http://webpack.github.io/analyse/](http://webpack.github.io/analyse/),[https://chrisbateman.github.io/webpack-visualizer/](https://chrisbateman.github.io/webpack-visualizer/), a[n](https://chrisbateman.github.io/webpack-visualizer/)d[https://alexkuz.github.io/stellar-webpack/.](https://alexkuz.github.io/stellar-webpack/) These are handy for understanding what your largest modules are.

[**source-map-explorer**](https://github.com/danvk/source-map-explorer) (via Paul Irish) is also _fantastic_ for understanding code bloat through source maps. Look at this tree-map visualisation with per-file LOC and % breakdowns for the ReactHN Webpack bundle:





![](https://cdn-images-1.medium.com/max/1600/0*D5j-Jv_FVkMigRyZ.)





You might also be interested in [**coverage-ext**](https://github.com/samccone/coverage-ext) by Sam Saccone for generating code coverage for any webapp. This is useful for understanding how much code of the code you’re shipping down is actually being executed.

### Beyond code-splitting: PRPL Pattern

Polymer discovered an interesting web performance pattern for granularly serving apps called [PRPL](https://www.polymer-project.org/1.0/toolbox/server) (see [Kevin’s I/O talk](https://www.youtube.com/watch?v=J4i0xJnQUzU)). This pattern tries to optimise for interactivity and stands for:

*   (P)ush critical resources for the initial route
*   (R)ender initial route and get it interactive as soon as possible
*   (P)re-cache the remaining routes using Service Worker
*   (L)azy-load and lazily instantiate parts of the app as the user moves through the application









![](https://cdn-images-1.medium.com/max/2000/0*2XxuNsDEp1-4VuoU.)









We have to give great kudos here to the [Polymer Shop demo](https://shop.polymer-project.org/) for showing us the way on real mobile devices. Using PRPL (in this case with HTML Imports, which can take advantage of the browser’s background HTML parser). No pixels go on screen that you can’t use. Additional work here is chunked and stays interactive. We’re interactive on a real mobile device at 1.75seconds. 1.3s of JavaScript but it’s all broken up. After that it all works.

You’re hopefully on board with the benefits of breaking down applications into more granular chunks by now. When a user first visits our PWA, let’s say they go to a particular route. The server (using H/2 Push) can push down the chunks needed for just that route — these are only the pieces needed to get the application booted up. Those go into the network cache.

Once they’ve been pushed down, we’ve effectively primed the cache with the chunks we know the page will need. When the application boots up, it looks at the route and knows that what we need is already in the cache, so we get that really fast first load of our application — not just a splash screen — but the interactive content the user asked for.

The next part of this is rendering the content for the view as quickly as possible. The third is, while the user is looking at the current view, using Service Worker to start pre-caching all of the other chunks and routes the user hasn’t asked for yet and getting those all installed into the Service Worker cache.

At this point the entire application (or a lot more of it) can be available offline. When a user navigates to a different part of the application, we can lazy load the next parts of it from the Service Worker cache. There’s no network loading needed because they’re already precached. Instant loading awesomeness ahoy! ❤

PRPL can be applied to any app, as Flipkart recently demonstrated on their React stack. Apps fully using PRPL can take advantage of fast-loading using HTTP/2 server push by producing two builds that we conditionally serve depending on your browser support:

* A bundled build optimised to minimize round-trips for servers/browsers without HTTP/2 Push support. For most of us, this is what we ship today by default.

* An unbundled build for servers/browsers that do support HTTP/2 Push enabling a faster first-paint

This builds on some of the thinking we talked about earlier with route-chunking. With PRPL, the server and our Service Worker work together to precache resources for intactive routes. When a user navigates around your app and changes routes, we lazy-load resources for routes not cached yet and create the required views.

### Implementing PRPL

**tl;dr: Webpack’s require.ensure() with an async ‘getComponent’ and React Router are the lowest friction paths to a PRPL-style performance pattern**





![](https://cdn-images-1.medium.com/max/1600/0*-llrY94drXMjBUW6.)





A big part of PRPL is turning the JS bundling mindset upside down and delivering resources as close to the granularity in which they are authored as possible (at least in terms of functionally independent modules). With Webpack, this is all about route-chunking which we’ve already covered.

Push critical resources for the initial route. Ideally, using [HTTP/2 Server Push](https://www.igvita.com/2013/06/12/innovating-with-http-2.0-server-push/) however don’t let this be a blocker for trying to go down a PRPL-like path. You can achieve substantially similar results to “full” PRPL in many cases without using H/2 Push, but just sending [preload headers](https://www.smashingmagazine.com/2016/02/preload-what-is-it-good-for/) and H/2 alone.

See this production waterfall by Flipkart of their before/after wins:









![](https://cdn-images-1.medium.com/max/2000/0*-hLp_Acvig_s4Uop.)









Webpack has support for H/2 in the form of [AggressiveSplittingPlugin](https://github.com/webpack/webpack/tree/master/examples/http2-aggressive-splitting).

AggressiveSplittingPlugin splits every chunk until it reaches the specified maxSize as we can see with a short example below:

    module.exports = {
        entry: "./example",
        output: {
            path: path.join(__dirname, "js"),
            filename: "[chunkhash].js",
            chunkFilename: "[chunkhash].js"
        },
        plugins: [
            new webpack.optimize.AggressiveSplittingPlugin({
                minSize: 30000,
                maxSize: 50000
            }),
    // ...

See the official [plugin page](https://github.com/webpack/webpack/tree/master/examples/http2-aggressive-splitting) with examples for more details. [Lessons learned experimenting with HTTP/2 Push](https://docs.google.com/document/d/1K0NykTXBbbbTlv60t5MyJvXjqKGsCVNYHyLEXIxYMv0/preview?pref=2&pli=1) and [Real World HTTP/2](https://99designs.com.au/tech-blog/blog/2016/07/14/real-world-http-2-400gb-of-images-per-day/) are also worth a read.

*   Rendering initial routes: this is really up to the framework/library you’re using.
*   Pre-caching remaining routes. For caching, we rely on Service Worker. [sw-precache](https://github.com/GoogleChrome/sw-precache) is great for generating a Service Worker for static asset precaching and for Webpack we can use [SWPrecacheWebpackPlugin](https://www.npmjs.com/package/sw-precache-webpack-plugin).
*   Lazy-load and create remaining routes on demand — require.ensure() and System.import() are your friend in Webpack land.

### Cache-busting & long-term caching with Webpack

**Why care about static asset versioning?**

Static assets refer to our page’s static resources like scripts, stylesheets and images. When users visit our page for the first time, they need to download all of the resources used by the it. Let’s say we land on a route and the JavaScript chunks needed haven’t changed since the last time the page was visited — we shouldn’t have to re-fetch these scripts because they should already exist in the browser cache. Fewer network requests is a win for web performance.

Normally, we accomplish this by setting up an [expires header](https://developers.google.com/web/fundamentals/performance/optimizing-content-efficiency/http-caching?hl=en) for each of our files. An expires header just means that we can tell the browser to avoid making another request to the server for this file for a specific amount of time (e.g 1 year). As codebases evolve and are redeployed we want to make sure users get the freshest files without having to re-download resources if they haven’t changed.

[Cache-busting](https://css-tricks.com/strategies-for-cache-busting-css/) accomplishes this by appending a string to filenames — it could be a build version (e.g src=”chunk.js?v=1.2.0”), a timestamp or something else. I prefer to adding a hash of the file contents to the filename (e.g chunk.d9834554decb6a8j.js) as this should always change when the contents of the file changes. MD5 hashing is commonly used in the Webpack community for this purpose which generates a ‘summary’ value 16 bytes long.

[_Long-term caching of static-assets with Webpack_](https://medium.com/@okonetchnikov/long-term-caching-of-static-assets-with-webpack-1ecb139adb95) _is an excellent read on this topic and you should check it out. I try to cover the main points of what’s involved otherwise below._

**Asset versioning using content-hashing in Webpack**

In Webpack, asset versioning using content hashing is setup [[chunkhash]](https://webpack.github.io/docs/long-term-caching.html) in our Webpack config as follows:

    filename: ‘[name].[chunkhash].js’,
    chunkFilename: ‘[name].[chunkhash].js’

We also want to make sure the normal [name].js and content-hashed ([name].[chunkhash].js) filenames are always correctly referenced in our HTML files. This is the difference between referencing and . Below is a commented Webpack config sample that includes a few other plugins that smooth over getting long-term caching setup. const path = require(&#039;path&#039;); const webpack = require(&#039;webpack&#039;); // Use webpack-manifest-plugin to generate asset manifests with a mapping from source files to their corresponding outputs. Webpack uses IDs instead of module names to keep generated files small in size. IDs get generated and mapped to chunk filenames before being put in the chunk manifest (which goes into our entry chunk). Unfortunately, any changes to our code update the entry chunk including the new manifest, invalidating our caching. const ManifestPlugin = require(&#039;webpack-manifest-plugin&#039;); // We fix this with chunk-manifest-webpack-plugin, which puts the manifest in a completely separate JSON file of its own. const ChunkManifestPlugin = require(&#039;chunk-manifest-webpack-plugin&#039;); module.exports = { entry: { vendor: &#039;./src/vendor.js&#039;, main: &#039;./src/index.js&#039; }, output: { path: path.join(__dirname, &#039;build&#039;), filename: &#039;[name].[chunkhash].js&#039;, chunkFilename: &#039;[name].[chunkhash].js&#039; }, plugins: [ new webpack.optimize.CommonsChunkPlugin({ name: &quot;vendor&quot;, minChunks: Infinity, }), new ManifestPlugin(), new ChunkManifestPlugin({ filename: &quot;chunk-manifest.json&quot;, manifestVariable: &quot;webpackManifest&quot; }), // Work around non-deterministic ordering for modules. Covered more in the long-term caching of static assets with Webpack post. new webpack.optimize.OccurenceOrderPlugin() ] }; Now that we have a build of the chunk-manifest JSON, we need to inline it into our HTML so that Webpack actually has access to it when the page boots up. So include the output of the above in a  tag. Automatically inlining this script in HTML can be achieved using the html-webpack-plugin. Note: Webpack are hoping to simplify the steps required for this long-term caching setup from ~4–1 by having no shared ID range. To learn more about HTTP Caching best practices, read Jake Archibald’s excellent write-up. Further reading  Webpack’s documentation on code-splitting Formidable’s OSS Playbook’s on Webpack code-splitting and shared libraries Progressive Web Apps with Webpack Advanced Webpack Part 2 — Code Splitting Progressive loading for modern web applications via code splitting Loading dependencies asynchronously in React components Webpack Plugins we been keeping on the DLL Automatic Code Splitting for React Router w/ ES6 Imports — Modus Create Using webpack and react-router for lazyloading and code-splitting not loading Isomorphic/Universal rendering/routing/data-fetching with React in real life A Lazy Isomorphic React Experiment Server Rendering Lazy Routes with React Router and code-splitting React on the server for beginners — building a universal React app React.js Apps with Pages Building the World Bank data site as a fast-loading, single-page app with code splitting Implementing PRPL in Gatsby (React.js static site generator)  Advanced Module Bundling optimization reads  The cost of modules How RollUp and Closure Compiler mitigate the cost of modules The cost of transpiling ES2015 in 2016  In part 3 of this series, we’ll look at how to get your React PWA working offline and under flaky network conditions. If you’re new to React, I’ve found React for Beginners by Wes Bos excellent. With thanks to Gray Norton, Sean Larkin, Sunil Pai, Max Stoiber, Simon Boudrias, Kyle Mathews and Owen Campbell-Moore for their reviews.   





