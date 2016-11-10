> * 原文地址：[Progressive Web Apps with React.js: Part 3 — Offline support and network resilience](https://medium.com/@addyosmani/progressive-web-apps-with-react-js-part-3-offline-support-and-network-resilience-c84db889162c#.i71vp23vj)
* 原文作者：[Addy Osmani](https://medium.com/@addyosmani)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

# Progressive Web Apps with React.js: Part 3 — Offline support and network resilience




### Part 3 of a new [series](https://medium.com/@addyosmani/progressive-web-apps-with-react-js-part-i-introduction-50679aef2b12#.ysn8uhvkq) walking through tips for shipping mobile web apps optimized using [Lighthouse.](https://github.com/googlechrome/lighthouse) This issue, we’ll be looking at making your React apps work offline.

A good Progressive Web App loads instantly regardless of network stateand puts up its own UI on the screen without requiring a network round trip (i.e when it’s offline).



![](https://cdn-images-1.medium.com/max/2000/1*O7K0EvTJ8P8VmqhLALZBzg.png)



Repeat visits to the Housing.com Progressive Web App (built with React and Redux) [instantly](https://www.webpagetest.org/video/compare.php?tests=160912_0F_229-r%3A1-c%3A1&thumbSize=200&ival=100&end=visual) load their offline-cached UI.



We can accomplish this using [service worker](https://developers.google.com/web/fundamentals/getting-started/primers/service-workers?hl=en). A service worker is a background worker that acts as a programmable proxy, allowing us to control what happens on a request-by-request basis. We can use it to make (parts of, or even entire) React apps work offline.













![](https://cdn-images-1.medium.com/max/2000/1*sNDoPikstWvIuKY9HphuSw.png)



You’re in control of _how much of your UX is available offline. You can offline-cache just the application shell, all of the data (like ReactHN does for stories) or offer a limited, but useful set of stale data like Housing.com and Flipkart do. Both indicate offline by graying out their UIs so you know “live” prices may be different._







Service workers depend on two APIs to work effectively: [Fetch](https://developer.mozilla.org/en-US/docs/Web/API/Fetch_API) (a standard way to retrieve content from the network) and [Cache](https://developer.mozilla.org/en-US/docs/Web/API/Cache) (content storage for application data. This cache is independent from the browser cache or network status).

_Note: Service workers can be applied as a progressive enhancement. Although browser support_ [_continues_](https://jakearchibald.github.io/isserviceworkerready/) _to improve, users without support for the feature can still fully use your PWA as long as they are connected to the network._

### A base for advanced features

Service workers are also designed to work as a bedrock API for unlocking features that enable web apps to work more like native apps. This includes:

*   [Push API ](https://developers.google.com/web/fundamentals/engage-and-retain/push-notifications/)— An API enabling push services to send push messages to a webapp. Servers can send messages at any time, even when the webapp or browser are not running.
*   [Background Sync ](https://developers.google.com/web/updates/2015/12/background-sync?hl=en)— for deferring actions until the user has stable connectivity. This is handy for making use whatever the user wants to send is actually sent. This enables pushing periodic updates when the app is next online.

### Service Worker Lifecycle

Each [service worker](https://developers.google.com/web/fundamentals/getting-started/primers/service-workers?hl=en) goes through three steps in its lifecycle: registration, installation and activation. [_Jake Archibald covers them in more depth here._](https://developers.google.com/web/fundamentals/instant-and-offline/service-worker/lifecycle)

#### Registration

To install a service worker, you need to register it in script. Registration informs the browser where your service worker is located and lets it know it can start installing in the background. Basic registration in your index.html could look like this:

    // Check for browser support of service worker
    if ('serviceWorker' in navigator) {

     navigator.serviceWorker.register('service-worker.js')
     .then(function(registration) {
       // Successful registration
       console.log('Hooray. Registration successful, scope is:', registration.scope);
     }).catch(function(err) {
       // Failed registration, service worker won’t be installed
       console.log('Whoops. Service worker registration failed, error:', error);
     });

    }

The service worker is registered with navigator.serviceWorker.register which returns a Promise that resolves when the SW has been successfully registered. The scope of the service worker is logged with registration.scope.

#### Scope

The scope of the service worker determines from which path it will intercept requests. The _default_ scope is the path to the service worker file. If service-worker.js is located in the root directory, the service worker will control requests from all files at the domain. You can set an arbitrary scope by passing an extra parameter while registering:

    navigator.serviceWorker.register('service-worker.js', {
     scope: '/app/'
    });

#### Installation and activation

Service workers are event driven. The installation and activation processes fire off corresponding install and activate events to which the service workers can respond.

With the service worker registered, the first time a user hits your PWA, the install event will be triggered and this is where you’ll want to cache the static assets for the page. This happens if the service worker is considered _new,_ either because this is the first service worker encountered for the page or there’s a byte-difference between the current service worker and the previously installed one. install is the point when you can cache anything before getting a chance to control clients.

We could add very basic caching to a static app using the following code:

    var CACHE_NAME = 'my-pwa-cache-v1';
    var urlsToCache = [
      '/',
      '/styles/styles.css',
      '/script/webpack-bundle.js'
    ];

    self.addEventListener('install', function(event) {
      event.waitUntil(
        caches.open(CACHE_NAME)
          .then(function(cache) {
            // Open a cache and cache our files
            return cache.addAll(urlsToCache);
          })
      );
    });

addAll() takes an array of URLs, requests, fetches them and adds them to the cache. If any fetch/write fails, the op fails and the cache gets returned to its last state.

Intercepting and caching requests

When a service worker controls a page, it can intercept each request being made by the page and decide what to do with it. This makes it a lot like a background proxy. We can use this to intercept requests to our urlsToCacheand return the locally cached versions of assets instead of having to go back to the network. We can do this by attaching a handler to the fetch event:

    self.addEventListener('fetch', function(event) {
        console.log(event.request.url);
        event.respondWith(
            caches.match(event.request).then(function(response) {
                return response || fetch(event.request);
            })
        );
    });

In our fetch listener (specifically, event.respondWith), we pass along a promise from caches.match() which looks at the request and will find any cached results from entries the service worker created. If there’s a matching response, the cached value is returned.

That’s it. A number of free sources are available for learning about Service Worker:

*   The [Service Worker Primer](https://developers.google.com/web/fundamentals/getting-started/primers/service-workers#install_a_service_worker) on Web Fundamentals
*   A Web Fundamentals codelab on [your first offline webapp](https://developers.google.com/web/fundamentals/getting-started/your-first-offline-web-app/?hl=en)
*   A [course on Offline Web Apps with Service Worker over on Udacity](https://www.udacity.com/course/offline-web-applications--ud899)
*   [Jake Archibald’s offline cookbook](https://jakearchibald.com/2014/offline-cookbook/) is another excellent resource we recommend reading through.
*   [Progressive Web Apps with Webpack](http://michalzalecki.com/progressive-web-apps-with-webpack/) is another good guide for learning how to get offline caching working with mostly vanilla Service Worker code (if you prefer not to use a library).

_A third-party API wishing to deploy their own service worker that could handle requests made by other origins to their origin can enable this using_ [_Foreign Fetch_](https://developers.google.com/web/updates/2016/09/foreign-fetch?hl=en)_. This is useful for custom networking logic & defining a single cache instance for responses._

Dipping your toe in the water — custom offline pages









![](https://cdn-images-1.medium.com/max/1600/1*CMx4sTcd3j8pPlkE0I_cfg.png)



The React-based mobile.twitter.com use a Service Worker to serve a custom offline page when the network can’t be reached.



Providing users a meaningful offline experience (e.g readable content) is a great goal. That said, early on in your service worker experimentation you may find getting a custom offline page setup is a small step in the right direction. There are good [samples](https://googlechrome.github.io/samples/service-worker/custom-offline-page/index.html) available demonstrating how to accomplish this.

Lighthouse

If your app meets the below Lighthouse conditions for having a sufficient experience when offline, you’ll get a full pass.









![](https://cdn-images-1.medium.com/max/1600/1*xzaEpLzD6uDBngkU5YD9OA.jpeg)



_The start_url check is useful for checking the experience users have launching your PWA from the homescreen when offline is definitely in the cache. This catches lots of folks out, so just make sure it’s listed in your Web App manifest._



Chrome DevTools

DevTools supports debugging Service Workers & emulating offline connectivity via the Application tab.









![](https://cdn-images-1.medium.com/max/1600/0*UX83F86-oPO1HVbt.)





I also strongly recommend developing with 3G throttling (and CPU throttling via the Timeline panel) enabled to emulate how well your app works with offline and flaky network connections on lower-end hardware.









![](https://cdn-images-1.medium.com/max/1600/0*DH3EoEO_aHbXw_mx.)





### The Application Shell Architecture

An application shell (or app shell) architecture is one way to build a Progressive Web App that reliably and instantly loads on your users’s screens, similar to what you see in native applications.

The app “shell” is the minimal HTML, CSS and JavaScript required to power the user interface (think toolbars, drawers and so on) and when cached offline can ensure instant, reliably good performance to users on repeat visits. This means the application shell does not need to be loaded each time, but instead only gets the necessary content it needs from the network.













![](https://cdn-images-1.medium.com/max/2000/0*qhxO_uA-_A6WV_Pc.)



Housing.com use an AppShell with placeholders for content. This is nice for improving perceived performance as content fills in these holders once fully loaded.







For [single-page applications](https://en.wikipedia.org/wiki/Single-page_application) with JavaScript-heavy architectures, an application shell is a go-to approach. This approach relies on aggressively caching the shell (using [Service Worker](https://github.com/google/WebFundamentals/blob/99046f5543e414261670142f04836b121eb2e7d5/web/fundamentals/primers/service-worker)) to get the application running. Next, the dynamic content loads for each page using JavaScript. An app shell is useful for getting some initial HTML to the screen fast without a network. Your shell may be using [Material UI](http://www.material-ui.com/) or more likely your own custom styles.

_Note: Try the_ [_First Progressive Web App_](https://codelabs.developers.google.com/codelabs/your-first-pwapp/#0) _codelab to learn how to architect and implement your first application shell for a weather app. The_ [_Instant Loading with the App Shell model_](https://www.youtube.com/watch?v=QhUzmR8eZAo) _video also walks through this pattern._









![](https://cdn-images-1.medium.com/max/1200/0*ssjtA1rSYhk61_iU.)





We cache the shell offline using the Cache Storage API (via service worker) so that on repeat visits, the app shell can be loaded instantly so you get meaningful pixels on the screen really fast without the network, even if your content eventually comes from there.

Note that you _can_ ship a PWA using a simpler SSR or SPA architecture, it just won’t have the same performance benefits and will instead rely more on full-page caching.

### Low-friction caching with Service Worker Libraries

Two libraries were developed to handle two different offline use cases: [sw-precache](https://github.com/GoogleChrome/sw-precache) to automate precaching of static resources, and [sw-toolbox](https://github.com/GoogleChrome/sw-toolbox) to handle runtime caching and fallback strategies. The libraries complement each other nicely, and allowed us to implement a performant strategy in which a static content “shell” is always served directly from the cache, and dynamic or remote resources are served from the network, with fallbacks to cached or static responses when needed.

AppShell caching: Our static resources (HTML, JavaScript, CSS, and images) provide the core shell for the web application. Sw-precache allows us to make sure that most of these static resources are cached, and that they are kept up to date. Precaching every resource that a site needs to work offline isn’t feasible.

Runtime caching: Some resources are too large or infrequently used to make it worthwhile, and other resources are dynamic, like the responses from a remote API or service. But just because a request isn’t precached doesn’t mean it has to result in a NetworkError. sw-toolbox gives us the flexibility to implement request handlers that handle runtime caching for some resources and custom fallbacks for others.

_sw-toolbox supports a number of different caching strategies including__network-first_ _(ensure the freshest data is used if available, but fall back to the cache),_ _cache-first_ _(check a request matches a cache entry, fallback to the network),_ _fastest_ _(request resources from both the cache and network at the same time, respond with whichever returns first). It’s important to understand the_ [_pros and cons_](https://developers.google.com/web/fundamentals/instant-and-offline/offline-cookbook/) _of these approaches._













![](https://cdn-images-1.medium.com/max/2000/1*E2m37hLNWAjXw_-B8A8n-Q.png)



_sw-toolbox & sw-precache were used to power the offline caching in Progressive Web Apps by Housing.com, the NFL, Flipkart, Alibaba, the Washington Post and numerous other sites. That said, we’re always interested in feedback and how we can improve them._







#### Offline caching for a React app

Using Service Worker and the Cache Storage API to cache URL addressable content can be accomplished in a few different ways:

*   Using vanilla Service Worker code. A number of samples with different caching strategies are available in the [GoogleChrome samples repo](https://github.com/GoogleChrome/samples/tree/gh-pages/service-worker) and Jake Archibald’s [Offline Cookbook](https://jakearchibald.com/2014/offline-cookbook/).
*   Using [sw-precache](https://github.com/GoogleChrome/sw-precache) and [sw-toolbox](https://github.com/GoogleChrome/sw-toolbox) via a one-liner in your package.json script field. [ReactHN does this](https://github.com/insin/react-hn/blob/master/package.json#L12)
*   Using a plugin for your Webpack setup like [sw-precache-webpack-plugin](https://www.npmjs.com/package/sw-precache-webpack-plugin) or [offline-plugin](https://github.com/NekR/offline-plugin). Starter kits like [react-boilerplate](https://github.com/mxstbr/react-boilerplate) include it by default.
*   [Using create-react-app and our Service Worker libraries](https://github.com/jeffposnick/create-react-pwa) to add offline caching support in just a few lines (similar to the above).

Talks discussing how to use these SW libraries to build a React app are also available:

*   [To the Lighthouse (PWA Summit)](https://www.youtube.com/watch?v=LZjQ25NRV-E)
*   [Progressive Web Apps Across All Frameworks](https://www.youtube.com/watch?v=srdKq0DckXQ)

#### sw-precache vs offline-plugin

As mentioned, [offline-plugin](https://github.com/NekR/offline-plugin) is another library for adding Service Worker caching to your pages. It was designed with minimal configuration in mind (it aims for zero) and deeply integrates with Webpack, knowing when _publicPath_ is used and can automatically generate _relativePaths_ for caches without any config needing to be specified. For static sites, offline-plugin is a good alternative to sw-precache. If you’re using HtmlWebpackPlugin, offline-plugin will also cache .html pages.

    module.exports = {
      plugins: [
        // ... other plugins
        new OfflinePlugin()
      ]
    }

I cover offline storage strategies for other types of data in [Offline Storage for Progressive Web Apps](https://medium.com/dev-channel/offline-storage-for-progressive-web-apps-70d52695513c). Specific to React, if you’re looking to add caching for your data stores and are using Redux you may be interested in [Redux Persist](https://github.com/rt2zz/redux-persist)or [Redux Replicate LocalForage](https://github.com/loggur/redux-replicate-localforage) (the latter is ~8KB gzipped).

### Mini case-study: Adding offline caching to ReactHN

ReactHN started out as an SPA without offline support. We added this in a few phases:

Step 1: Offline caching the static resources for the application “shell” using sw-precache. By calling the sw-precache CLI from our package.json’s “scripts” field, we generated a Service Worker for precaching the shell each time the build completes:

    "precache": "sw-precache — root=public — config=sw-precache-config.json"

The precache config file passed through above gives us control over what files and helper scripts are imported:

    {
      "staticFileGlobs": [
        "app/css/**.css",
        "app/**.html",
        "app/js/**.js",
        "app/images/**.*"
      ],
      "verbose": true,
      "importScripts": [
        "sw-toolbox.js",
        "runtime-caching.js"
      ]
    }









![](https://cdn-images-1.medium.com/max/1600/1*hkRHp9ZklNy1uNuQI0znEw.png)



sw-precache lists the total size of static assets that will be cached offline in its output. This is helpful for understanding just how large your application shell and the resources needed for it to become interactive are.



_Note:_ _If we were starting this today, I would just use the_ [_sw-precache-webpack-plugin_](https://www.npmjs.com/package/sw-precache-webpack-plugin) _which can be configured directly from your normal Webpack config:_

    plugins: [
        new SWPrecacheWebpackPlugin(
          {
            cacheId: "react-hn",
            filename: "my-service-worker.js",
            staticFileGlobs: [
              "app/css/**.css",
              "app/**.html",
              "app/js/**.js",
              "app/images/**.*"
            ],
           verbose: true
          }
        ),

Step 2: We also wanted to cache runtime/dynamic requests. For this we imported in sw-toolbox and our runtime-caching config above. Our app was using Web Fonts from Google Fonts, so we added a simple rule to cache anything coming back from the _fonts_ subdomain on [google.com](http://google.com/):

    global.toolbox.router.get('/(.+)', global.toolbox.fastest, {
       origin: /https?:\/\/fonts.+/
    });

To cache requests for data from an API endpoint (e.g an AppEngine on appspot.com), it’s pretty similar:

    global.toolbox.router.get('/(.*)', global.toolbox.fastest, {
       origin: /\.(?:appspot)\.com$/
    })

_Note:_ sw-toolbox supports a number of useful options, including the ability to set maximum age for cached entries (via maxAgeSeconds). For more details on what’s supported, read the [API docs](https://googlechrome.github.io/sw-toolbox/docs/releases/v3.2.0/tutorial-api.html).

Step 3: Take time to _think_ about what the most useful offline experience is for your users. Every app is different.

ReactHN relies on _real-time_ data from Firebase for stories & comments. After much experimentation, we found a healthy balance of UX and performance was in offering an offline experience with [_slightly_](https://youtu.be/srdKq0DckXQ?list=PLNYkxOF6rcIDz1TzmmMRBC-kd8zPRTQIP&t=558) stale data.

There’s much to learn from other PWAs that have already shipped so I encourage researching & sharing learnings as much as possible ❤

### Offline Google Analytics

Once you have Service Worker powering the offline experience in your PWA you might turn your gaze to other concerns, like making sure Google Analytics work while you’re offline. Normally, if you try getting GA to work offline, _those requests will fail_ and you won’t get any meaningful data logged.









![](https://cdn-images-1.medium.com/max/1600/1*xNryy3alOWPoKLjASEO4cg.png)



offline Google Analytics events queued up in IndexedDB



We can fix this using the [Offline Google Analytics library](https://developers.google.com/web/updates/2016/07/offline-google-analytics?hl=en) (sw-offline-google-analytics). It queues up any GA requests while a user is offline and retries them later once the network is available again. We successfully used a similar technique in this year’s [Google I/O web app](https://github.com/GoogleChrome/ioweb2016/blob/master/app/scripts/sw-toolbox/offline-analytics.js) and encourage folks give it a try.

### Frequently asked questions (and answers)

For me, the trickiest part of getting Service Worker right has always been the debugging. This has become significantly easier in Chrome DevTools over the last year and I _strongly_ recommend doing the [SW debugging codelab](https://codelabs.developers.google.com/codelabs/debugging-service-workers/index.html) to save yourself some time and tears later on 😨

You might also find documenting what you find tricky (or new) helps others. Rich Harris did this in [stuff I wish I’d known sooner about service workers](https://gist.github.com/Rich-Harris/fd6c3c73e6e707e312d7c5d7d0f3b2f9).

For everything else, SO has been a great source of answers:

*   [How do I remove a buggy service worker or implement a kill switch?](http://stackoverflow.com/a/38980776)
*   [What are my options for testing my service worker code?](http://stackoverflow.com/questions/34160509/options-for-testing-service-workers-via-http)
*   [Can service workers cache POST requests?](http://stackoverflow.com/a/35272243)
*   [How do I prevent the same sw from registering over multiple pages?](http://stackoverflow.com/a/33881341)
*   [Can I read cookies from inside a service worker?](https://github.com/w3c/ServiceWorker/issues/707) (not yet, coming)
*   [How does global error handling work in service workers?](http://stackoverflow.com/questions/37736322/how-does-global-error-handling-work-in-service-workers)

Other resources

*   [Is Service Worker Ready?](https://jakearchibald.github.io/isserviceworkerready/) — browser implementation status & resources
*   [Instant Loading: Building offline-first Progressive Web Apps](https://www.youtube.com/watch?v=cmGr0RszHc8) — Jake
*   [Offline Support for Progressive Web Apps](https://www.youtube.com/watch?v=OBfLvqA_E4A) — Totally Tooling Tips
*   [Instant Loading with Service Workers](https://www.youtube.com/watch?v=jCKZDTtUA2A) — Jeff Posnick
*   [The Mozilla Service Worker Cookbook](https://serviceworke.rs/)
*   [Getting started with Service Worker Toolbox ](http://deanhume.com/home/blogpost/getting-started-with-the-service-worker-toolbox/10134)— Dean Hume
*   [Resources on unit testing Service Workers](https://www.reddit.com/r/javascript/comments/4yq237/how_do_you_test_service_workers/d6qqqhh) — Matt Gaunt

and that’s a wrap!

In part 4 of this series, [we look at enabling progressive enhancement for React.js based Progressive Web Apps using universal rendering](https://medium.com/@addyosmani/progressive-web-apps-with-react-js-part-4-site-is-progressively-enhanced-b5ad7cf7a447#.bu0kk36bo).

If you’re new to React, I’ve found [React for Beginners](https://goo.gl/G1WGxU) by Wes Bos excellent.

_With thanks to Gray Norton, Sean Larkin, Sunil Pai, Max Stoiber, Simon Boudrias, Kyle Mathews, Arthur Stolyar and Owen Campbell-Moore for their reviews._

