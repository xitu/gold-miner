> * 原文地址：[Progressive Web Apps with React.js: Part 3 — Offline support and network resilience](https://medium.com/@addyosmani/progressive-web-apps-with-react-js-part-3-offline-support-and-network-resilience-c84db889162c#.i71vp23vj)
* 原文作者：[Addy Osmani](https://medium.com/@addyosmani)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[Jiang Haichao](http://github.com/AceLeeWinnie)
* 校对者：[Gocy](https://github.com/Gocy015), [David Lin](https://github.com/wild-flame)

# 使用 React.js 的渐进式 Web 应用程序：第 3 部分 - 离线支持和网络恢复能力

### 本期是新[系列](https://medium.com/@addyosmani/progressive-web-apps-with-react-js-part-i-introduction-50679aef2b12#.ysn8uhvkq)的第三部分，将介绍使用 [Lighthouse](https://github.com/googlechrome/lighthouse) 优化移动 web 应用传输的技巧。 并看看如何使你的 React 应用离线工作。

一个好的渐进式 Web 应用，不论网络状况如何都能立即加载，并且在不需要网络请求的情况下也能展示 UI （即离线时)。

![](https://cdn-images-1.medium.com/max/2000/1*O7K0EvTJ8P8VmqhLALZBzg.png)

再次访问 Housing.com 渐进式 Web 应用（使用 React 和 Redux 构建）能够[立即](https://www.webpagetest.org/video/compare.php?tests=160912_0F_229-r%3A1-c%3A1&thumbSize=200&ival=100&end=visual)加载离线缓存的 UI。

我们可以用 [Service Worker](https://developers.google.com/web/fundamentals/getting-started/primers/service-workers?hl=en) 实现这一需求。Service Worker 是一个后台 worker，可以看做是可编程的代理，允许开发者控制 request 执行其他操作。使用 Service Worker，React 应用得以（部分或全部）离线工作。

![](https://cdn-images-1.medium.com/max/2000/1*sNDoPikstWvIuKY9HphuSw.png)

你能够掌控离线时 UX 的可用程度。你可以只离线缓存应用的外壳，全部数据（就像 ReactHN 缓存 stories 一样），或者像 Housing.com 和 Flipkart 那样，提供有限但有帮助的静态旧数据。并且均通过置灰 UI 蒙层来暗示已离线，这样就能够感知“实时”价格还未同步。

Service worker 实际上依赖两个 API：[Fetch](https://developer.mozilla.org/en-US/docs/Web/API/Fetch_API) (通过网络重新获取内容的标准方式) 和 [Cache](https://developer.mozilla.org/en-US/docs/Web/API/Cache)（应用数据的内容存储，此缓存独立于浏览器缓存和网络状态）。

**注意：Service worker 能够应用于渐进式增强。尽管浏览器支持程度还[有待](https://jakearchibald.github.io/isserviceworkerready/)提升，但只要网络畅通，不支持此特性的用户也能充分体验 PWA （渐进式 Web 应用程序）。**

### 高级特性基础

Service worker 也设计作为基础 API，让 web 应用更像 native 应用。具体包括：

* [推送 API](https://developers.google.com/web/fundamentals/engage-and-retain/push-notifications/) - 启用 web 应用消息推送服务。服务器能够任意发送消息，即使 web 应用或浏览器不在工作状态。
* [后台同步](https://developers.google.com/web/updates/2015/12/background-sync?hl=en) - 延迟处理直到用户网络连接稳定为止。这能方便保证用户消息的正确发送。应用下次在线时能够启动自动定期更新。

### Service Worker 生命周期

每个 [Service Worker](https://developers.google.com/web/fundamentals/getting-started/primers/service-workers?hl=en) 的生命周期有三步：注册，安装和激活。**[Jake Archibald 的这篇文章有更详细的说明](https://developers.google.com/web/fundamentals/instant-and-offline/service-worker/lifecycle)**

#### 注册

如果要安装 Service Worker，你需要在脚本里注册它。注册后会通知浏览器定位你的 Service Worker 文件，并启动后台安装。在 index.html 中的基本注册方法如下： 

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

使用 navigator.serviceWorker.register 注册，注册成功后返回一个 resolve 状态的 Promise 对象。作用域是 registration.scope。

#### 作用域

Service Worker 的作用域由拦截请求的路径决定。**默认**作用域是 Service Worker 文件所在路径。如果 service-worker.js 在根目录下，则 Service Worker 将控制该域名下所有文件的访问请求。你可以通过在注册时传入其他参数来改变作用域。

    navigator.serviceWorker.register('service-worker.js', {
     scope: '/app/'
    });

#### 安装和激活

Service workers 是事件驱动的。安装和激活方法由对应的安装和激活事件触发，由 Service Worker 响应。

Service Worker 注册之后，用户第一次访问 PWA 时，install 事件触发，此时确定页面需要缓存的静态资源。当 Service Worker 被认为是**新**的时才会触发该事件，即要么是页面第一次加载 Service Worker 文件，要么是当前文件与之前安装的文件不同，哪怕是一个字节不同，都会被认为是新的。如果你想在有机会控制客户端之前缓存东西，那么 install 是关键所在。

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

addAll() 传入一个 URL 数组，请求并获取文件，然后添加到缓存中去。如果任一步骤获取/写入失败，整个操作失败，并且缓存回退到它的上一个状态。

拦截和缓存请求

当 Service Worker 控制页面时，它能够拦截页面发起的每个请求，并且决定如何处理。这使得它有点像后台代理。我们用它来拦截到 urlsToCache 列表的请求，接着返回资源的本地版本，而不是走网络获取资源。这通过在 fetch 事件上绑定处理方法实现：

    self.addEventListener('fetch', function(event) {
        console.log(event.request.url);
        event.respondWith(
            caches.match(event.request).then(function(response) {
                return response || fetch(event.request);
            })
        );
    });

在 fetch 监听器中（具体的说是 event.respondWith），向 caches.match() 方法传入一个 promise 对象，这个能够监听请求和从 Service Worker 创建的条目中发现缓存。如果有匹配的缓存响应，返回对应的值。

这就是 Service Worker。以下是学习 Service Worker 可用的免费资源。

*   基于 Web 基本原理的 [Service Worker 入门](https://developers.google.com/web/fundamentals/getting-started/primers/service-workers#install_a_service_worker)
*   [你的第一个离线 webapp](https://developers.google.com/web/fundamentals/getting-started/your-first-offline-web-app/?hl=en)，web 基本原理编程实验室
*   [Udacity 基于 Service Worker 的离线 Web 应用教程](https://www.udacity.com/course/offline-web-applications--ud899)
*   推荐 [Jake Archibald 的离线小书](https://jakearchibald.com/2014/offline-cookbook/)。
*   [基于 Webpack 的渐进式 Web 应用](http://michalzalecki.com/progressive-web-apps-with-webpack/) 也是一个很棒的指南，学h会如何用基础 Service Worker 代码启用离线缓存（如果你不喜欢用库的话）。

**如果第三方 API 想要部署他们自己的 Service Worker 来处理其他域传来的请求，[Foreign Fetch](https://developers.google.com/web/updates/2016/09/foreign-fetch?hl=en) 可以帮忙。这对于网络化逻辑自定义和单个缓存实例响应定义都有帮助。**

探索 - 自定义离线页面

![](https://cdn-images-1.medium.com/max/1600/1*CMx4sTcd3j8pPlkE0I_cfg.png)

基于 React 的 mobile.twitter.com 用 Service Worker 在网络不可达时提供自定义离线页面。

为用户提供有意义的离线体验（例如：可读内容）是一个很好的目标。也就是说，在早期的 Service Worker 实验中，你会发现设置自定义离线页面是很小但正确的决定。这里有许多优秀的 [案例](https://googlechrome.github.io/samples/service-worker/custom-offline-page/index.html) 展示如何实现它。

Lighthouse

如果你的应用在离线时有充分的用户体验，在遇到 Lighthouse 检测的如下条件时，就会全部通过。

![](https://cdn-images-1.medium.com/max/1600/1*xzaEpLzD6uDBngkU5YD9OA.jpeg)

**start_url 便于检查用户从主界面打开 PWA 时使用离线缓存的体验情况，这项检查能够发现许多的问题，所以要确保 start_url 在你的 Web 应用的 manifest 中。**

Chrome 开发工具

开发工具通过应用选项卡支持 「调试 Service Worker」 和 「模拟脱机连通性」。

![](https://cdn-images-1.medium.com/max/1600/0*UX83F86-oPO1HVbt.)

强烈推荐使用 3G 节流（和 Timeline 面板的 CPU 节流）开发，模拟低端硬件上应用在脱机和网络差的情况下的表现。

![](https://cdn-images-1.medium.com/max/1600/0*DH3EoEO_aHbXw_mx.)

### 应用外壳架构

应用程序外壳（或者应用外壳）架构是构建可靠的和在客户机立即加载的渐进式 Web 应用的一个方法，与 native 应用类似。

应用“外壳” 是最小化的 HTML，CSS 和 JavaScript，要求为用户接口赋能（想想 toolbars，drawers 等等），确保用户重复访问时即时可靠的性能表现。这意味着应用程序外壳不需要每次都下载，只需要网络获取少量必要内容即可。

![](https://cdn-images-1.medium.com/max/2000/0*qhxO_uA-_A6WV_Pc.)

Housing.com 使用了内容占位符的应用外壳。一旦全部下载完成，立即填充占位，此举有助于提升感官性能。

对于富 JavaScript 架构的 [单页应用](https://en.wikipedia.org/wiki/Single-page_application) 来说，应用外壳是首选方法。这个方法依赖外壳的缓存（利用 [Service Worker](https://github.com/google/WebFundamentals/blob/99046f5543e414261670142f04836b121eb2e7d5/web/fundamentals/primers/service-worker)）来运行程序。其次，用 JavaScript 加载每个页面的动态内容。在无网络情况下，应用外壳有助于更快的获取屏幕的起始 HTML 页面。外壳可以使用 [Material UI](http://www.material-ui.com/) 或是自定义风格。

**注意：参考 [第一个渐进式 Web 应用](https://codelabs.developers.google.com/codelabs/your-first-pwapp/#0) 学习设计和实现第一个应用外壳程序，以天气应用为样例。[用应用外壳模型实现立即加载](https://www.youtube.com/watch?v=QhUzmR8eZAo) 同样探讨了这个模式。**

![](https://cdn-images-1.medium.com/max/1200/0*ssjtA1rSYhk61_iU.)

我们利用 Cache Storage API（通过 Service Worker）离线缓存外壳，目的是当重复访问时，应用外壳能够立即加载，这样就能在无网络情况下快速获取屏幕信息，即使内容最终还是来自网络。

记住你可以使用更简单的 SSR 或者 SPA 架构开发 PWA，但它没有同样的性能优势并且更依赖全页缓存。

### 利用 Service Worker 启动低成本缓存

这里列举两个用于不同离线场景的库：[sw-precache](https://github.com/GoogleChrome/sw-precache) 会自动事先缓存静态资源，[sw-toolbox](https://github.com/GoogleChrome/sw-toolbox) 处理运行时缓存以及回退策略。这两个库一起使用能达到互补的效果，需要提供静态内容外壳的性能策略时，总是从缓存中直接获取，而动态的或远程的资源则通过网络请求提供，需要时回退到缓存或静态响应里。

应用外壳缓存：静态资源（HTML, JavaScript, CSS 和 images）提供 web 应用的核心外壳。Sw-precache 确保绝大多数这类静态资源都被缓存下来，并且保持更新。预缓存一个网站离线工作需要的所有资源显然是不现实的。

运行时缓存：一些过于庞大或者很少使用的资源，还有一些动态资源，像来自远程 API 或服务的响应。没有预缓存的请求并不一定要响应网络错误。sw-toolbox 让我们得以灵活实现请求的处理，这能够处理某些资源的运行时缓存和其他资源的自定义回退。

**sw-toolbox 支持大多数不同缓存策略，包括网络优先（确保可用数据是最新的，而不是读取缓存），缓存优先（匹配请求与缓存列表，如果资源不存在则发起网络请求），速度优先（同时从缓存和网络请求资源，响应最快的返回结果）。了解这些方法的 [优劣](https://developers.google.com/web/fundamentals/instant-and-offline/offline-cookbook/) 十分重要。**

![](https://cdn-images-1.medium.com/max/2000/1*E2m37hLNWAjXw_-B8A8n-Q.png)

**许多网站都在各自的渐进式 Web 应用里利用 sw-toolbox 和 sw-precache 进行离线缓存，例如 Housing.com，the NFL，Flipkart，Alibaba，the Washington Post 等等。也就是说，我们能够一直关注反馈和优化方案。**

#### React app 中的离线缓存

利用 Service Worker 和 Cache Storage API 缓存 URL 的可访问内容能够通过以下这些不同的方式：

*   使用 Service Worker 基础 API。[GoogleChrome 样例](https://github.com/GoogleChrome/samples/tree/gh-pages/service-worker) 和 Jake Archibald 的 [离线小书](https://jakearchibald.com/2014/offline-cookbook/) 上有许多使用不同缓存策略的样例.
*   在 package.json 脚本域中用一行代码就能启用 [sw-precache](https://github.com/GoogleChrome/sw-precache) 和 [sw-toolbox](https://github.com/GoogleChrome/sw-toolbox)。[ReactHN 的例子在这里](https://github.com/insin/react-hn/blob/master/package.json#L12)
*   在 Webpack 配置中使用类似 [sw-precache-webpack-plugin](https://www.npmjs.com/package/sw-precache-webpack-plugin) 或者 [offline-plugin](https://github.com/NekR/offline-plugin) 的插件。 [react-boilerplate](https://github.com/mxstbr/react-boilerplate) 这个启动工具包已经默认包含它了。
*   [使用 create-react-app 和 Service Worker 库](https://github.com/jeffposnick/create-react-pwa) 仅几行代码就能添加离线缓存支持（类似上一条）。

了解使用这些 SW 库构建一个 React 应用的讨论也是大有裨益的：

*   [面向 Lighthouse (PWA 提交)](https://www.youtube.com/watch?v=LZjQ25NRV-E)
*   [跨框架的渐进式 Web 应用](https://www.youtube.com/watch?v=srdKq0DckXQ)

#### sw-precache 对比 offline-plugin

正如上文提到，[offline-plugin](https://github.com/NekR/offline-plugin) 是另一个库，用于添加 Service Worker 缓存到页面。它设计理念是最小化配置（目标是零配置) 和 Webpack的深度整合。当 Webpack 的 publicPath 配置了，它能够自动为缓存生成 relativePaths，而不需要再指定其他配置。对静态网站来说，offline-plugin 是一个很好的 sw-precache 的替代品。如果你用的是 HtmlWebpackPlugin，offline-plugin 还能缓存 .html 页面。

    module.exports = {
      plugins: [
        // ... other plugins
        new OfflinePlugin()
      ]
    }

我在 [渐进式 Web 应用的离线缓存](https://medium.com/dev-channel/offline-storage-for-progressive-web-apps-70d52695513c) 中讲了其他类型数据的离线存储策略。尤其是 React，如果你正关注添加数据仓库到缓存或正使用 Redux，你会对 [坚持 Redux](https://github.com/rt2zz/redux-persist) 和 [Redux 复制本地搜索](https://github.com/loggur/redux-replicate-localforage) 感兴趣的（后者压缩后约 8 KB）。

### 迷你案例学习：为 ReactHN 添加离线缓存

ReactHN 一开始是没有离线缓存的单页应用。我们按步骤添加离线缓存：

第一步：用 sw-precache 为应用 “外壳” 离线缓存静态资源。通过调用 package.json 里 script 域的 sw-precache CLI 工具，每次构建完成时产生一个 Service Worker 用于预缓存外壳

    "precache": "sw-precache — root=public — config=sw-precache-config.json"

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

sw-precache 在输出结果中列出将离线缓存的静态资源总大小。这有利于明白多大的应用外壳和资源能够保证良好的交互体验。

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

第二步：我们还想缓存运行时/动态请求。为了实现这一功能，我们需要引入 sw-toolbox 和上面的运行时缓存配置。应用使用了 Google Fonts 网络字体，所以我们添加一个简单的规则，缓存所有 [google.com](http://google.com/) 的 fonts 子域下的请求。

    global.toolbox.router.get('/(.+)', global.toolbox.fastest, {
       origin: /https?:\/\/fonts.+/
    });


从 API 端点（例如一个 appspot.com 上的应用引擎）缓存数据请求，类似如下：

    global.toolbox.router.get('/(.*)', global.toolbox.fastest, {
       origin: /\.(?:appspot)\.com$/
    })

**注意：sw-toolbox 支持许多有用的选项，包括能够设置缓存条目的最大失效时长（借助 maxAgeSeconds）。要了解更多支持细节，请阅读 [API docs](https://googlechrome.github.io/sw-toolbox/docs/releases/v3.2.0/tutorial-api.html)。**

第三步：仔细想一想对你的用户来说，什么是最有帮助的离线体验。每个应用都有所不同。

ReactHN 依赖服务器返回的**实时**新闻报道和评论数据。一番实验之后，我们发现 UX 和性能之间的一个平衡点是用 **[稍微](https://youtu.be/srdKq0DckXQ?list=PLNYkxOF6rcIDz1TzmmMRBC-kd8zPRTQIP&t=558)** 老旧的数据提供离线体验。

从其他已经发布的 PWA 上可以学到很多东西，鼓励大家尽可能地研究和分享学习成果。❤

### 离线 Google 分析

一旦在你的 PWA 使用 Service Worker 提升离线体验，你的关注点就会移向别处，比如，确保 Google 分析离线可用，如果你尝试离线 GA，请求会失败，你也不能得到有用的数据状态。

![](https://cdn-images-1.medium.com/max/1600/1*xNryy3alOWPoKLjASEO4cg.png)

IndexedDB 中的离线 Google 分析事件队列

我们可以用 [离线 Google 分析库](https://developers.google.com/web/updates/2016/07/offline-google-analytics?hl=en) 解决这一问题（sw-offline-google-analytics）来解决这一问题。当用户离线时，入队所有 GA 请求，并且一旦网络再次可用，就尝试重连。我们今年的 [Google I/O web app](https://github.com/GoogleChrome/ioweb2016/blob/master/app/scripts/sw-toolbox/offline-analytics.js)
就成功使用了相似的技术，鼓励大家都去试一试。

### 普遍问题（和答案）

对我来说，Service Worker 最难搞的部分就是调试。但去年开始，Chrome DevTools 显著降低了调试难度。为了节约你的时间和减少稍后踩的大坑，我强烈推荐在 [SW debugging codelab](https://codelabs.developers.google.com/codelabs/debugging-service-workers/index.html) 上做开发。😨

记录你发现的技巧或者新知识也可以帮助别人。Rich Harris 就写了 [Service Worker 早知道](https://gist.github.com/Rich-Harris/fd6c3c73e6e707e312d7c5d7d0f3b2f9)。

根据其他内容集结了资料如下：

*   [如何删除一个多 bug 的 Service Worker 或者实现一个终止开关？](http://stackoverflow.com/a/38980776)
*   [测试 Service Worker 代码有哪些方法？](http://stackoverflow.com/questions/34160509/options-for-testing-service-workers-via-http)
*   [Service Worker 可以缓存 POST 请求吗？](http://stackoverflow.com/a/35272243)
*   [如何多个页面注册同一个 sw ？](http://stackoverflow.com/a/33881341)
*   [Service Worker 内部能够读取 cookie 吗？](https://github.com/w3c/ServiceWorker/issues/707) (敬请期待)
*   [如何处理 Service Worker 的全局错误？](http://stackoverflow.com/questions/37736322/how-does-global-error-handling-work-in-service-workers)

其他资源：

*   [Service Worker 准备好了吗?](https://jakearchibald.github.io/isserviceworkerready/) — 浏览器实现状态和资源
*   [立即加载：构建离线优先的渐进式 Web 应用](https://www.youtube.com/watch?v=cmGr0RszHc8) — Jake
*   [渐进式 Web 应用的离线支持](https://www.youtube.com/watch?v=OBfLvqA_E4A) — 完全工具指南
*   [使用 Service Worker 实现立即加载](https://www.youtube.com/watch?v=jCKZDTtUA2A) — Jeff Posnick
*   [Mozilla Service Worker 小书](https://serviceworke.rs/)
*   [开始使用 Service Worker 工具箱](http://deanhume.com/home/blogpost/getting-started-with-the-service-worker-toolbox/10134)— Dean Hume
*   [Service Worker 单元测试相关资源](https://www.reddit.com/r/javascript/comments/4yq237/how_do_you_test_service_workers/d6qqqhh) — Matt Gaunt

最后结语！

在这个系列的第四部分，[我们会重点关注使用全局渲染来渐进增强 React.js 渐进式 Web 应用](https://github.com/xitu/gold-miner/blob/master/TODO/progressive-web-apps-with-react-js-part-4-site-is-progressively-enhanced.md)。

如果你刚了解 React，Wes Bos 的 [React 入门](https://goo.gl/G1WGxU) 很适合你。

**感谢 Gray Norton, Sean Larkin, Sunil Pai, Max Stoiber, Simon Boudrias, Kyle Mathews, Arthur Stolyar 和 Owen Campbell-Moore 的评论。**
