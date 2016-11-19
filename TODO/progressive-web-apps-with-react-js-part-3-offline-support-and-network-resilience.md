> * 原文地址：[Progressive Web Apps with React.js: Part 3 — Offline support and network resilience](https://medium.com/@addyosmani/progressive-web-apps-with-react-js-part-3-offline-support-and-network-resilience-c84db889162c#.i71vp23vj)
* 原文作者：[Addy Osmani](https://medium.com/@addyosmani)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[Jiang Haichao](http://github.com/AceLeeWinnie)
* 校对者：

# Progressive Web Apps with React.js: Part 3 — Offline support and network resilience
# 使用 React.js 的渐进式 Web 应用程序：第 3 部分 - 离线支持和网络恢复能力

### Part 3 of a new [series](https://medium.com/@addyosmani/progressive-web-apps-with-react-js-part-i-introduction-50679aef2b12#.ysn8uhvkq) walking through tips for shipping mobile web apps optimized using [Lighthouse.](https://github.com/googlechrome/lighthouse) This issue, we’ll be looking at making your React apps work offline.

### 新[系列](https://medium.com/@addyosmani/progressive-web-apps-with-react-js-part-i-introduction-50679aef2b12#.ysn8uhvkq)的第三部分介绍关于使用 [Lighthouse](https://github.com/googlechrome/lighthouse) 优化移动 web 应用传输的技巧。 本期，我们来看如何使你的 React 应用离线工作。

A good Progressive Web App loads instantly regardless of network state and puts up its own UI on the screen without requiring a network round trip (i.e when it’s offline).

一个好的渐进式 Web 应用，不论网络状况如何都能立即加载，并且在不需要网络请求的情况下也能展示 UI (例如：离线时)。

![](https://cdn-images-1.medium.com/max/2000/1*O7K0EvTJ8P8VmqhLALZBzg.png)

Repeat visits to the Housing.com Progressive Web App (built with React and Redux) [instantly](https://www.webpagetest.org/video/compare.php?tests=160912_0F_229-r%3A1-c%3A1&thumbSize=200&ival=100&end=visual) load their offline-cached UI.

重复访问 Housing.com 渐进式 Web 应用（使用 React 和 Redux 构建）能够[立即](https://www.webpagetest.org/video/compare.php?tests=160912_0F_229-r%3A1-c%3A1&thumbSize=200&ival=100&end=visual)加载离线缓存的 UI。

We can accomplish this using [service worker](https://developers.google.com/web/fundamentals/getting-started/primers/service-workers?hl=en). A service worker is a background worker that acts as a programmable proxy, allowing us to control what happens on a request-by-request basis. We can use it to make (parts of, or even entire) React apps work offline.

我们可以用 [service worker](https://developers.google.com/web/fundamentals/getting-started/primers/service-workers?hl=en) 实现这一需求。service worker 是一个可编程代理的后台 worker，允许开发者在请求之间执行其他操作。使用 service worker，React 应用得以（部分或全部）离线工作。

![](https://cdn-images-1.medium.com/max/2000/1*sNDoPikstWvIuKY9HphuSw.png)

You’re in control of _how much of your UX is available offline. You can offline-cache just the application shell, all of the data (like ReactHN does for stories) or offer a limited, but useful set of stale data like Housing.com and Flipkart do. Both indicate offline by graying out their UIs so you know “live” prices may be different._

如果你正受制于离线时 UX 的可用程度。你可以只离线缓存应用的外壳，全部数据（就像 ReactHN 缓存 stories 一样），或者像 Housing.com 和 Flipkart 那样，提供有限但有帮助的静态旧数据。并且均通过置灰 UI 蒙层来暗示已离线，这样就能够感知“实时”价格还未同步。

Service workers depend on two APIs to work effectively: [Fetch](https://developer.mozilla.org/en-US/docs/Web/API/Fetch_API) (a standard way to retrieve content from the network) and [Cache](https://developer.mozilla.org/en-US/docs/Web/API/Cache) (content storage for application data. This cache is independent from the browser cache or network status).

Service worker 实际上依赖两个 API：[Fetch](https://developer.mozilla.org/en-US/docs/Web/API/Fetch_API) (通过网络重新获取内容的标准方式) 和 [Cache](https://developer.mozilla.org/en-US/docs/Web/API/Cache)（应用数据的内容存储，此缓存独立于浏览器缓存和网络状态）。

_Note: Service workers can be applied as a progressive enhancement. Although browser support_ [_continues_](https://jakearchibald.github.io/isserviceworkerready/) _to improve, users without support for the feature can still fully use your PWA as long as they are connected to the network._

**注意：Service worker 能够应用于渐进式增强。尽管浏览器支持程度还[有待](https://jakearchibald.github.io/isserviceworkerready/)提升，但只要网络畅通，不支持此特性的用户也能充分体验 PWA （渐进式 Web 应用程序）。**

### A base for advanced features

### 高级特性基础

Service workers are also designed to work as a bedrock API for unlocking features that enable web apps to work more like native apps. This includes:

Service worker 也设计作为基础 API，让 web 应用更像 native 应用。具体包括：

*   [Push API ](https://developers.google.com/web/fundamentals/engage-and-retain/push-notifications/)— An API enabling push services to send push messages to a webapp. Servers can send messages at any time, even when the webapp or browser are not running.
*   [Background Sync ](https://developers.google.com/web/updates/2015/12/background-sync?hl=en)— for deferring actions until the user has stable connectivity. This is handy for making use whatever the user wants to send is actually sent. This enables pushing periodic updates when the app is next online.

* [推送 API](https://developers.google.com/web/fundamentals/engage-and-retain/push-notifications/) - 启用 web 应用消息推送服务。服务器能够任意发送消息，即使 web 应用或浏览器不在工作状态。
* [后台同步](https://developers.google.com/web/updates/2015/12/background-sync?hl=en) - 延迟处理直到用户网络连接稳定为止。在处理用户要发送的消息实际已经发送时得心应手。应用下次在线时能够启动自动定期更新。


### Service Worker Lifecycle

### Service Worker 生命周期

Each [service worker](https://developers.google.com/web/fundamentals/getting-started/primers/service-workers?hl=en) goes through three steps in its lifecycle: registration, installation and activation. [_Jake Archibald covers them in more depth here._](https://developers.google.com/web/fundamentals/instant-and-offline/service-worker/lifecycle)

每个 [service worker](https://developers.google.com/web/fundamentals/getting-started/primers/service-workers?hl=en) 的生命周期有三步：注册，安装和激活。**[Jake Archibald 的这篇文章有更详细的说明._](https://developers.google.com/web/fundamentals/instant-and-offline/service-worker/lifecycle)**

#### Registration

#### 注册

To install a service worker, you need to register it in script. Registration informs the browser where your service worker is located and lets it know it can start installing in the background. Basic registration in your index.html could look like this:

如果要安装 service worker，你需要在脚本里注册它。注册后会通知浏览器定位你的 service worker 文件，并启动后台安装。在 index.html 中的基本注册方法如下： 

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

使用 navigator.serviceWorker.register 注册，注册成功后返回一个 resolve 状态的 Promise 对象。作用域是 registration.scope。

#### Scope

#### 作用域

The scope of the service worker determines from which path it will intercept requests. The _default_ scope is the path to the service worker file. If service-worker.js is located in the root directory, the service worker will control requests from all files at the domain. You can set an arbitrary scope by passing an extra parameter while registering:

service worker 的作用域由拦截请求的路径决定。**默认**作用域是 service worker 文件所在路径。如果 service-worker.js 在根目录下，则 service worker 将控制该域名下所有文件的访问请求。你可以通过在注册时传入其他参数来改变作用域。

    navigator.serviceWorker.register('service-worker.js', {
     scope: '/app/'
    });

#### Installation and activation

#### 安装和激活

Service workers are event driven. The installation and activation processes fire off corresponding install and activate events to which the service workers can respond.

Service workers 是事件驱动的。安装和激活方法由对应的安装和激活事件触发，由 service worker 响应。

With the service worker registered, the first time a user hits your PWA, the install event will be triggered and this is where you’ll want to cache the static assets for the page. This happens if the service worker is considered _new,_ either because this is the first service worker encountered for the page or there’s a byte-difference between the current service worker and the previously installed one. install is the point when you can cache anything before getting a chance to control clients.

service worker 注册之后，用户第一次访问 PWA 时，install 事件触发，确定页面需要缓存的静态资源。当 service worker 被认为是**新**的时才会触发该事件，即要么是页面第一次加载 service worker 文件，要么是当前文件与之前安装的文件不同，哪怕是一个字节不同，都会被认为是新的。如果你想在有机会控制客户端之前缓存东西，那么 install 是关键所在。

We could add very basic caching to a static app using the following code:

我们可以使用以下代码为静态应用添加最基本的缓存：

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

addAll() 传入一个 URL 数组，请求并获取文件，然后添加到缓存中去。如果任一步骤获取/写入失败，操作都失败，并且缓存回退到它的上一个状态。

Intercepting and caching requests

拦截和缓存请求

When a service worker controls a page, it can intercept each request being made by the page and decide what to do with it. This makes it a lot like a background proxy. We can use this to intercept requests to our urlsToCache and return the locally cached versions of assets instead of having to go back to the network. We can do this by attaching a handler to the fetch event:

当 service worker 控制页面时，它能够拦截页面发起的每个请求，并且决定如何处理。这使得它有点像后台代理。我们用它来拦截到 urlsToCache 列表的请求，接着返回资源的本地版本，而不是走网络获取资源。这通过在 fetch 事件上绑定处理方法实现：

    self.addEventListener('fetch', function(event) {
        console.log(event.request.url);
        event.respondWith(
            caches.match(event.request).then(function(response) {
                return response || fetch(event.request);
            })
        );
    });

In our fetch listener (specifically, event.respondWith), we pass along a promise from caches.match() which looks at the request and will find any cached results from entries the service worker created. If there’s a matching response, the cached value is returned.

在 fetch 监听器中（具体的说是 event.respondWith），向 caches.match() 方法传入一个 promise 对象，这个能够监听请求和从 service worker 创建的条目中发现缓存。如果有匹配的缓存响应，返回对应的值。

That’s it. A number of free sources are available for learning about Service Worker:

这就是 Service Worker。以下是学习 Service Worker 可用的免费资源。

*   The [Service Worker Primer](https://developers.google.com/web/fundamentals/getting-started/primers/service-workers#install_a_service_worker) on Web Fundamentals
*   A Web Fundamentals codelab on [your first offline webapp](https://developers.google.com/web/fundamentals/getting-started/your-first-offline-web-app/?hl=en)
*   A [course on Offline Web Apps with Service Worker over on Udacity](https://www.udacity.com/course/offline-web-applications--ud899)
*   [Jake Archibald’s offline cookbook](https://jakearchibald.com/2014/offline-cookbook/) is another excellent resource we recommend reading through.
*   [Progressive Web Apps with Webpack](http://michalzalecki.com/progressive-web-apps-with-webpack/) is another good guide for learning how to get offline caching working with mostly vanilla Service Worker code (if you prefer not to use a library).

*   基于 Web 基本原理的 [Service Worker 入门](https://developers.google.com/web/fundamentals/getting-started/primers/service-workers#install_a_service_worker)
*   [你的第一个离线 webapp](https://developers.google.com/web/fundamentals/getting-started/your-first-offline-web-app/?hl=en)，web 基本原理编程实验室
*   [Udacity 基于 Service Worker 的离线 Web 应用教程](https://www.udacity.com/course/offline-web-applications--ud899)
*   推荐[Jake Archibald 的离线小书](https://jakearchibald.com/2014/offline-cookbook/)。
*   [基于 Webpack 的渐进式 Web 应用](http://michalzalecki.com/progressive-web-apps-with-webpack/) 也是一个很棒的指南，学h会如何用基础 Service Worker 代码启用离线缓存（如果你不喜欢用库的话）。


_A third-party API wishing to deploy their own service worker that could handle requests made by other origins to their origin can enable this using_ [_Foreign Fetch_](https://developers.google.com/web/updates/2016/09/foreign-fetch?hl=en)_. This is useful for custom networking logic & defining a single cache instance for responses._

**如果第三方 API 想要部署他们自己的 service worker 来处理其他域传来的请求，[Foreign Fetch](https://developers.google.com/web/updates/2016/09/foreign-fetch?hl=en) 可以帮忙。这对于网络化逻辑自定义和单个缓存实例响应定义都有帮助。**

Dipping your toe in the water — custom offline pages

探索 - 自定义离线页面

![](https://cdn-images-1.medium.com/max/1600/1*CMx4sTcd3j8pPlkE0I_cfg.png)

The React-based mobile.twitter.com use a Service Worker to serve a custom offline page when the network can’t be reached.

基于 React 的 mobile.twitter.com 用 Service Worker 在网络不可达时提供自定义离线页面。

Providing users a meaningful offline experience (e.g readable content) is a great goal. That said, early on in your service worker experimentation you may find getting a custom offline page setup is a small step in the right direction. There are good [samples](https://googlechrome.github.io/samples/service-worker/custom-offline-page/index.html) available demonstrating how to accomplish this.

为用户提供有意义的离线体验（例如：可读内容）是一个很好的目标。也就是说，在早期的 service worker 实验中，你会发现设置自定义离线页面是很小但正确的决定。这里有许多优秀的 [案例](https://googlechrome.github.io/samples/service-worker/custom-offline-page/index.html) 展示如何实现它。

Lighthouse

Lighthouse

If your app meets the below Lighthouse conditions for having a sufficient experience when offline, you’ll get a full pass.

如果你的应用在离线时有充分的用户体验，在遇到 Lighthouse 检测的如下条件时，就会全部通过。

![](https://cdn-images-1.medium.com/max/1600/1*xzaEpLzD6uDBngkU5YD9OA.jpeg)

_The start_url check is useful for checking the experience users have launching your PWA from the homescreen when offline is definitely in the cache. This catches lots of folks out, so just make sure it’s listed in your Web App manifest._

**start_url 检查便于检查老用户离线时已经从首屏启动的 PWA 绝对在缓存中。如果不在缓存中会流失许多用户，所以要确保 start_url 在 Web 应用清单里。**

Chrome DevTools

Chrome 开发工具

DevTools supports debugging Service Workers & emulating offline connectivity via the Application tab.

开发工具通过应用选项卡支持调试 Service Worker 和 模拟脱机连通性。

![](https://cdn-images-1.medium.com/max/1600/0*UX83F86-oPO1HVbt.)

I also strongly recommend developing with 3G throttling (and CPU throttling via the Timeline panel) enabled to emulate how well your app works with offline and flaky network connections on lower-end hardware.

强烈推荐使用 3G 节流（和 Timeline 面板的 CPU 节流）开发，模拟低端硬件上应用在脱机和网络差的情况下的表现。

![](https://cdn-images-1.medium.com/max/1600/0*DH3EoEO_aHbXw_mx.)

### The Application Shell Architecture

### 应用外壳架构

An application shell (or app shell) architecture is one way to build a Progressive Web App that reliably and instantly loads on your users’s screens, similar to what you see in native applications.

应用程序外壳（或者应用外壳）架构是构建可靠的和在客户机立即加载的渐进式 Web 应用的一个方法，与 native 应用类似。

The app “shell” is the minimal HTML, CSS and JavaScript required to power the user interface (think toolbars, drawers and so on) and when cached offline can ensure instant, reliably good performance to users on repeat visits. This means the application shell does not need to be loaded each time, but instead only gets the necessary content it needs from the network.

应用“外壳” 是最小化的 HTML，CSS 和 JavaScript，要求为用户接口赋能（想想 toolbars，drawers 等等），确保用户重复访问时即时可靠的性能表现。这意味着应用程序外壳不需要每次都下载，只需要网络获取少量必要内容即可。

![](https://cdn-images-1.medium.com/max/2000/0*qhxO_uA-_A6WV_Pc.)

Housing.com use an AppShell with placeholders for content. This is nice for improving perceived performance as content fills in these holders once fully loaded.

Housing.com 使用了内容占位符的应用外壳。一旦全部下载完成，立即填充占位，此举有助于提升感官性能。

For [single-page applications](https://en.wikipedia.org/wiki/Single-page_application) with JavaScript-heavy architectures, an application shell is a go-to approach. This approach relies on aggressively caching the shell (using [Service Worker](https://github.com/google/WebFundamentals/blob/99046f5543e414261670142f04836b121eb2e7d5/web/fundamentals/primers/service-worker)) to get the application running. Next, the dynamic content loads for each page using JavaScript. An app shell is useful for getting some initial HTML to the screen fast without a network. Your shell may be using [Material UI](http://www.material-ui.com/) or more likely your own custom styles.

对于富 JavaScript 架构的[单页应用](https://en.wikipedia.org/wiki/Single-page_application)来说，应用外壳是首选方法。这个方法依赖外壳的缓存（利用 [Service Worker](https://github.com/google/WebFundamentals/blob/99046f5543e414261670142f04836b121eb2e7d5/web/fundamentals/primers/service-worker)）来运行程序。其次，用 JavaScript 加载每个页面的动态内容。在无网络情况下，应用外壳有助于更快的获取屏幕的起始 HTML 页面。外壳可以使用 [Material UI](http://www.material-ui.com/) 或是自定义风格。

_Note: Try the_ [_First Progressive Web App_](https://codelabs.developers.google.com/codelabs/your-first-pwapp/#0) _codelab to learn how to architect and implement your first application shell for a weather app. The_ [_Instant Loading with the App Shell model_](https://www.youtube.com/watch?v=QhUzmR8eZAo) _video also walks through this pattern._

**注意：参考 [第一个渐进式 Web 应用](https://codelabs.developers.google.com/codelabs/your-first-pwapp/#0) 学习设计和实现第一个应用外壳程序，以天气应用为样例。[用应用外壳模型实现立即加载](https://www.youtube.com/watch?v=QhUzmR8eZAo) 同样探讨了这个模式。**

![](https://cdn-images-1.medium.com/max/1200/0*ssjtA1rSYhk61_iU.)

We cache the shell offline using the Cache Storage API (via service worker) so that on repeat visits, the app shell can be loaded instantly so you get meaningful pixels on the screen really fast without the network, even if your content eventually comes from there.

我们利用 Cache Storage API（通过 service worker）离线缓存外壳，目的是当重复访问时，应用外壳能够立即加载，这样就能在无网络情况下快速获取屏幕信息，即使内容最终还是来自网络。

Note that you _can_ ship a PWA using a simpler SSR or SPA architecture, it just won’t have the same performance benefits and will instead rely more on full-page caching.

记住你可以使用更简单的 SSR 或者 SPA 架构开发 PWA，但它没有同样的性能优势并且更依赖全页缓存。

### Low-friction caching with Service Worker Libraries

### 利用 Service Worker 启动低成本缓存

Two libraries were developed to handle two different offline use cases: [sw-precache](https://github.com/GoogleChrome/sw-precache) to automate precaching of static resources, and [sw-toolbox](https://github.com/GoogleChrome/sw-toolbox) to handle runtime caching and fallback strategies. The libraries complement each other nicely, and allowed us to implement a performant strategy in which a static content “shell” is always served directly from the cache, and dynamic or remote resources are served from the network, with fallbacks to cached or static responses when needed.

这里列举两个用于不同离线场景的库：[sw-precache](https://github.com/GoogleChrome/sw-precache) 会自动事先缓存静态资源，[sw-toolbox](https://github.com/GoogleChrome/sw-toolbox) 处理运行时缓存以及回退策略。这两个库一起使用能达到互补的效果，需要提供静态内容外壳的性能策略时，总是从缓存中直接获取，而动态的或远程的资源则通过网络请求提供，需要时回退到缓存或静态响应里。

AppShell caching: Our static resources (HTML, JavaScript, CSS, and images) provide the core shell for the web application. Sw-precache allows us to make sure that most of these static resources are cached, and that they are kept up to date. Precaching every resource that a site needs to work offline isn’t feasible.

应用外壳缓存：静态资源（HTML, JavaScript, CSS 和 images）提供 web 应用的核心外壳。Sw-precache 确保绝大多数这类静态资源都被缓存下来，并且保持更新。预缓存一个网站离线工作需要的所有资源显然是不现实的。

Runtime caching: Some resources are too large or infrequently used to make it worthwhile, and other resources are dynamic, like the responses from a remote API or service. But just because a request isn’t precached doesn’t mean it has to result in a NetworkError. sw-toolbox gives us the flexibility to implement request handlers that handle runtime caching for some resources and custom fallbacks for others.

运行时缓存：一些过于庞大或者很少使用资源，还有一些动态资源，像来自远程 API 或服务的响应。但是请求没有被事先缓存并不意味着它必须返回网络错误。sw-toolbox 让我们得以灵活实现请求的处理，这能够处理某些资源的运行时缓存和其他资源的自定义回退。

_sw-toolbox supports a number of different caching strategies including__network-first_ _(ensure the freshest data is used if available, but fall back to the cache),_ _cache-first_ _(check a request matches a cache entry, fallback to the network),_ _fastest_ _(request resources from both the cache and network at the same time, respond with whichever returns first). It’s important to understand the_ [_pros and cons_](https://developers.google.com/web/fundamentals/instant-and-offline/offline-cookbook/) _of these approaches._

**sw-toolbox 支持大多数不同缓存策略，包括网络优先（确保可用数据是最新的，但回退到缓存里），缓存优先（匹配请求与缓存列表，回退到网络），速度优先（同时从缓存和网络请求资源，响应最快的返回结果）。了解这些方法的[优劣](https://developers.google.com/web/fundamentals/instant-and-offline/offline-cookbook/)十分重要。**

![](https://cdn-images-1.medium.com/max/2000/1*E2m37hLNWAjXw_-B8A8n-Q.png)

_sw-toolbox & sw-precache were used to power the offline caching in Progressive Web Apps by Housing.com, the NFL, Flipkart, Alibaba, the Washington Post and numerous other sites. That said, we’re always interested in feedback and how we can improve them._

**许多网站都在各自的渐进式 Web 应用里利用 sw-toolbox 和 sw-precache 进行离线缓存，例如 Housing.com，the NFL，Flipkart，Alibaba，the Washington Post 等等。也就是说，我们能够一直关注反馈和优化方案。**

#### Offline caching for a React app

#### React app 中的离线缓存

Using Service Worker and the Cache Storage API to cache URL addressable content can be accomplished in a few different ways:

利用 Service Worker 和 Cache Storage API 缓存 URL 的可访问内容能够通过以下这些不同的方式：

*   Using vanilla Service Worker code. A number of samples with different caching strategies are available in the [GoogleChrome samples repo](https://github.com/GoogleChrome/samples/tree/gh-pages/service-worker) and Jake Archibald’s [Offline Cookbook](https://jakearchibald.com/2014/offline-cookbook/).
*   Using [sw-precache](https://github.com/GoogleChrome/sw-precache) and [sw-toolbox](https://github.com/GoogleChrome/sw-toolbox) via a one-liner in your package.json script field. [ReactHN does this](https://github.com/insin/react-hn/blob/master/package.json#L12)
*   Using a plugin for your Webpack setup like [sw-precache-webpack-plugin](https://www.npmjs.com/package/sw-precache-webpack-plugin) or [offline-plugin](https://github.com/NekR/offline-plugin). Starter kits like [react-boilerplate](https://github.com/mxstbr/react-boilerplate) include it by default.
*   [Using create-react-app and our Service Worker libraries](https://github.com/jeffposnick/create-react-pwa) to add offline caching support in just a few lines (similar to the above).

*   使用 Service Worker 基础 API。[GoogleChrome 样例](https://github.com/GoogleChrome/samples/tree/gh-pages/service-worker) 和 Jake Archibald 的 [离线小书](https://jakearchibald.com/2014/offline-cookbook/) 上有许多使用不同缓存策略的样例.
*   在 package.json 脚本域中用一行代码就能启用 [sw-precache](https://github.com/GoogleChrome/sw-precache) 和 [sw-toolbox](https://github.com/GoogleChrome/sw-toolbox)。[ReactHN 的例子在这里](https://github.com/insin/react-hn/blob/master/package.json#L12)
*   在 Webpack 配置中使用类似 [sw-precache-webpack-plugin](https://www.npmjs.com/package/sw-precache-webpack-plugin) 或者 [offline-plugin](https://github.com/NekR/offline-plugin) 的插件。 [react-boilerplate](https://github.com/mxstbr/react-boilerplate) 这个启动工具包已经默认包含它了。
*   [使用 create-react-app 和 Service Worker 库](https://github.com/jeffposnick/create-react-pwa) 仅几行代码就能添加离线缓存支持（类似上一条）。

Talks discussing how to use these SW libraries to build a React app are also available:

了解使用这些 SW 库构建一个 React 应用的讨论也是大有裨益的：

*   [To the Lighthouse (PWA Summit)](https://www.youtube.com/watch?v=LZjQ25NRV-E)
*   [Progressive Web Apps Across All Frameworks](https://www.youtube.com/watch?v=srdKq0DckXQ)

*   [面向 Lighthouse (PWA 提交)](https://www.youtube.com/watch?v=LZjQ25NRV-E)
*   [跨框架的渐进式 Web 应用](https://www.youtube.com/watch?v=srdKq0DckXQ)

#### sw-precache vs offline-plugin

#### sw-precache 对比 offline-plugin

As mentioned, [offline-plugin](https://github.com/NekR/offline-plugin) is another library for adding Service Worker caching to your pages. It was designed with minimal configuration in mind (it aims for zero) and deeply integrates with Webpack, knowing when _publicPath_ is used and can automatically generate _relativePaths_ for caches without any config needing to be specified. For static sites, offline-plugin is a good alternative to sw-precache. If you’re using HtmlWebpackPlugin, offline-plugin will also cache .html pages.

正如上文提到，[offline-plugin](https://github.com/NekR/offline-plugin) 是另一个库，用于添加 Service Worker 缓存到页面。它设计理念是最小化配置（目标是零配置) 和 Webpack的深度整合。当 Webpack 的 publicPath 配置了，它能够自动为缓存生成 relativePaths，而不需要再指定其他配置。对静态网站来说，offline-plugin 是一个很好的 sw-precache 的替代品。如果你用的是 HtmlWebpackPlugin，offline-plugin 还能缓存 .html 页面。

    module.exports = {
      plugins: [
        // ... other plugins
        new OfflinePlugin()
      ]
    }

I cover offline storage strategies for other types of data in [Offline Storage for Progressive Web Apps](https://medium.com/dev-channel/offline-storage-for-progressive-web-apps-70d52695513c). Specific to React, if you’re looking to add caching for your data stores and are using Redux you may be interested in [Redux Persist](https://github.com/rt2zz/redux-persist)or [Redux Replicate LocalForage](https://github.com/loggur/redux-replicate-localforage) (the latter is ~8KB gzipped).

我在 [渐进式 Web 应用的离线缓存](https://medium.com/dev-channel/offline-storage-for-progressive-web-apps-70d52695513c)中讲了其他类型数据的离线存储策略。尤其是 React，如果你正关注添加数据仓库到缓存或正使用 Redux，你会对 [坚持 Redux](https://github.com/rt2zz/redux-persist) 和 [Redux 复制本地搜索](https://github.com/loggur/redux-replicate-localforage) 感兴趣的（后者压缩后约 8 KB）。

### Mini case-study: Adding offline caching to ReactHN

### 迷你案例学习：为 ReactHN 添加离线缓存

ReactHN started out as an SPA without offline support. We added this in a few phases:

ReactHN 一开始是没有离线缓存的单页应用。我们按步骤添加离线缓存：

Step 1: Offline caching the static resources for the application “shell” using sw-precache. By calling the sw-precache CLI from our package.json’s “scripts” field, we generated a Service Worker for precaching the shell each time the build completes:

第一步：用 sw-precache 为应用 “外壳” 离线缓存静态资源。通过调用 package.json 里 script 域的 sw-precache CLI 工具，每次构建完成时产生一个 Service Worker 用于预缓存外壳

    "precache": "sw-precache — root=public — config=sw-precache-config.json"

The precache config file passed through above gives us control over what files and helper scripts are imported:

这份预缓存配置文件通过上面的命令传递，可以控制引入的文件和 helper 脚本：

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

sw-precache 在输出结果中列出将离线缓存的静态资源总大小。这有利于明白多大的应用外壳和资源能够保证良好的交互体验。

_Note:_ _If we were starting this today, I would just use the_ [_sw-precache-webpack-plugin_](https://www.npmjs.com/package/sw-precache-webpack-plugin) _which can be configured directly from your normal Webpack config:_

**注意：如果现在开始做离线缓存功能，我会只用 [_sw-precache-webpack-plugin_](https://www.npmjs.com/package/sw-precache-webpack-plugin) 从标准 Webpack 配置中直接配置：**

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

第二步：我们还想缓存运行时/动态请求。为了实现这一功能，我们需要引入 sw-toolbox 和上面的运行时缓存配置。应用使用了 Google Fonts 网络字体，所以我们添加一个简单的规则，缓存所有 [google.com](http://google.com/) 的 fonts 子域下的请求。

    global.toolbox.router.get('/(.+)', global.toolbox.fastest, {
       origin: /https?:\/\/fonts.+/
    });

To cache requests for data from an API endpoint (e.g an AppEngine on appspot.com), it’s pretty similar:

从 API 端点（例如一个 appspot.com 上的应用引擎）缓存数据请求，类似如下：

    global.toolbox.router.get('/(.*)', global.toolbox.fastest, {
       origin: /\.(?:appspot)\.com$/
    })

_Note:_ sw-toolbox supports a number of useful options, including the ability to set maximum age for cached entries (via maxAgeSeconds). For more details on what’s supported, read the [API docs](https://googlechrome.github.io/sw-toolbox/docs/releases/v3.2.0/tutorial-api.html).

**注意：sw-toolbox 支持许多有用的选项，包括能够设置缓存条目的最大失效时长（借助 maxAgeSeconds）。要了解更多支持细节，请阅读 [API docs](https://googlechrome.github.io/sw-toolbox/docs/releases/v3.2.0/tutorial-api.html)。**

Step 3: Take time to _think_ about what the most useful offline experience is for your users. Every app is different.

第三步：仔细想一想对你的用户来说，什么是最有帮助的离线体验。每个应用都有所不同。

ReactHN relies on _real-time_ data from Firebase for stories & comments. After much experimentation, we found a healthy balance of UX and performance was in offering an offline experience with [_slightly_](https://youtu.be/srdKq0DckXQ?list=PLNYkxOF6rcIDz1TzmmMRBC-kd8zPRTQIP&t=558) stale data.

ReactHN 依赖服务器返回的**实时**新闻报道和评论数据。一番实验之后，我们发现 UX 和性能之间的一个平衡点是用 **[稍微](https://youtu.be/srdKq0DckXQ?list=PLNYkxOF6rcIDz1TzmmMRBC-kd8zPRTQIP&t=558)** 老旧的数据提供离线体验。

There’s much to learn from other PWAs that have already shipped so I encourage researching & sharing learnings as much as possible ❤

从其他已经发布的 PWA 上可以学到很多东西，鼓励大家尽可能地研究和分享学习成果。❤

### Offline Google Analytics

### 离线 Google 分析

Once you have Service Worker powering the offline experience in your PWA you might turn your gaze to other concerns, like making sure Google Analytics work while you’re offline. Normally, if you try getting GA to work offline, _those requests will fail_ and you won’t get any meaningful data logged.

一旦在你的 PWA 使用 Service Worker 提升离线体验，你的关注点就会移向别处，比如，确保 Google 分析离线可用，如果你尝试离线 GA，请求会失败，你也不能得到有用的数据状态。

![](https://cdn-images-1.medium.com/max/1600/1*xNryy3alOWPoKLjASEO4cg.png)

offline Google Analytics events queued up in IndexedDB

IndexedDB 中的离线 Google 分析事件队列

We can fix this using the [Offline Google Analytics library](https://developers.google.com/web/updates/2016/07/offline-google-analytics?hl=en) (sw-offline-google-analytics). It queues up any GA requests while a user is offline and retries them later once the network is available again. We successfully used a similar technique in this year’s [Google I/O web app](https://github.com/GoogleChrome/ioweb2016/blob/master/app/scripts/sw-toolbox/offline-analytics.js) and encourage folks give it a try.

我们可以用 [离线 Google 分析库](https://developers.google.com/web/updates/2016/07/offline-google-analytics?hl=en) 解决这一问题（sw-offline-google-analytics）来解决这一问题。当用户离线时，入队所有 GA 请求，并且一旦网络再次可用，就尝试重连。我们今年的 [Google I/O web app](https://github.com/GoogleChrome/ioweb2016/blob/master/app/scripts/sw-toolbox/offline-analytics.js)
就成功使用了相似的技术，鼓励大家都去试一试。

### Frequently asked questions (and answers)

### 普遍问题（和答案）

For me, the trickiest part of getting Service Worker right has always been the debugging. This has become significantly easier in Chrome DevTools over the last year and I _strongly_ recommend doing the [SW debugging codelab](https://codelabs.developers.google.com/codelabs/debugging-service-workers/index.html) to save yourself some time and tears later on 😨

对我来说，Service Worker 最难搞的部分就是调试。但去年开始，Chrome DevTools 显著降低了调试难度。为了节约你的时间和减少稍后踩的大坑，我强烈推荐在 [SW debugging codelab](https://codelabs.developers.google.com/codelabs/debugging-service-workers/index.html) 上做开发。😨

You might also find documenting what you find tricky (or new) helps others. Rich Harris did this in [stuff I wish I’d known sooner about service workers](https://gist.github.com/Rich-Harris/fd6c3c73e6e707e312d7c5d7d0f3b2f9).

记录你发现的技巧或者新知识也可以帮助别人。Rich Harris 就写了 [service worker 早知道](https://gist.github.com/Rich-Harris/fd6c3c73e6e707e312d7c5d7d0f3b2f9)。

For everything else, SO has been a great source of answers:

根据其他内容集结了资料如下：

*   [How do I remove a buggy service worker or implement a kill switch?](http://stackoverflow.com/a/38980776)
*   [What are my options for testing my service worker code?](http://stackoverflow.com/questions/34160509/options-for-testing-service-workers-via-http)
*   [Can service workers cache POST requests?](http://stackoverflow.com/a/35272243)
*   [How do I prevent the same sw from registering over multiple pages?](http://stackoverflow.com/a/33881341)
*   [Can I read cookies from inside a service worker?](https://github.com/w3c/ServiceWorker/issues/707) (not yet, coming)
*   [How does global error handling work in service workers?](http://stackoverflow.com/questions/37736322/how-does-global-error-handling-work-in-service-workers)

*   [如何删除一个多 bug 的 service worker 或者实现一个终止开关？](http://stackoverflow.com/a/38980776)
*   [测试 service worker 代码有哪些方法？](http://stackoverflow.com/questions/34160509/options-for-testing-service-workers-via-http)
*   [service worker 可以缓存 POST 请求吗？](http://stackoverflow.com/a/35272243)
*   [如何多个页面注册同一个 sw ？](http://stackoverflow.com/a/33881341)
*   [service worker 内部能够读取 cookie 吗？](https://github.com/w3c/ServiceWorker/issues/707) (not yet, coming)
*   [如何处理 service worker 的全局错误？](http://stackoverflow.com/questions/37736322/how-does-global-error-handling-work-in-service-workers)

Other resources

其他资源：

*   [Is Service Worker Ready?](https://jakearchibald.github.io/isserviceworkerready/) — browser implementation status & resources
*   [Instant Loading: Building offline-first Progressive Web Apps](https://www.youtube.com/watch?v=cmGr0RszHc8) — Jake
*   [Offline Support for Progressive Web Apps](https://www.youtube.com/watch?v=OBfLvqA_E4A) — Totally Tooling Tips
*   [Instant Loading with Service Workers](https://www.youtube.com/watch?v=jCKZDTtUA2A) — Jeff Posnick
*   [The Mozilla Service Worker Cookbook](https://serviceworke.rs/)
*   [Getting started with Service Worker Toolbox ](http://deanhume.com/home/blogpost/getting-started-with-the-service-worker-toolbox/10134)— Dean Hume
*   [Resources on unit testing Service Workers](https://www.reddit.com/r/javascript/comments/4yq237/how_do_you_test_service_workers/d6qqqhh) — Matt Gaunt

*   [Service Worker 准备好了吗?](https://jakearchibald.github.io/isserviceworkerready/) — 浏览器实现状态和资源
*   [立即加载：构建离线优先的渐进式 Web 应用](https://www.youtube.com/watch?v=cmGr0RszHc8) — Jake
*   [渐进式 Web 应用的离线支持](https://www.youtube.com/watch?v=OBfLvqA_E4A) — 完全工具指南
*   [使用 Service Worker 实现立即加载](https://www.youtube.com/watch?v=jCKZDTtUA2A) — Jeff Posnick
*   [Mozilla Service Worker 小书](https://serviceworke.rs/)
*   [开始使用 Service Worker 工具箱](http://deanhume.com/home/blogpost/getting-started-with-the-service-worker-toolbox/10134)— Dean Hume
*   [Service Worker 单元测试相关资源](https://www.reddit.com/r/javascript/comments/4yq237/how_do_you_test_service_workers/d6qqqhh) — Matt Gaunt

and that’s a wrap!

最后结语！

In part 4 of this series, [we look at enabling progressive enhancement for React.js based Progressive Web Apps using universal rendering](https://medium.com/@addyosmani/progressive-web-apps-with-react-js-part-4-site-is-progressively-enhanced-b5ad7cf7a447#.bu0kk36bo).

这个系列的第四部分，[我们关注使用普遍方法的基于 React.js 的渐进式 Web 应用的渐进式增强](https://medium.com/@addyosmani/progressive-web-apps-with-react-js-part-4-site-is-progressively-enhanced-b5ad7cf7a447#.bu0kk36bo)。

If you’re new to React, I’ve found [React for Beginners](https://goo.gl/G1WGxU) by Wes Bos excellent.

如果你刚了解 React，Wes Bos 的 [初入 React](https://goo.gl/G1WGxU) 很适合你。

_With thanks to Gray Norton, Sean Larkin, Sunil Pai, Max Stoiber, Simon Boudrias, Kyle Mathews, Arthur Stolyar and Owen Campbell-Moore for their reviews._

**最后感谢 Gray Norton, Sean Larkin, Sunil Pai, Max Stoiber, Simon Boudrias, Kyle Mathews, Arthur Stolyar 和 Owen Campbell-Moore 的审查。**
