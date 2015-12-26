>	* 原文链接 : [Introducing Pokedex.org: a progressive webapp for Pokémon fans — Pocket JavaScript](http://www.pocketjavascript.com/blog/2015/11/23/introducing-pokedex-org)
* 原文作者 : [NOLAN LAWSON](http://www.pocketjavascript.com/?author=539b3a09e4b0dc27b9618c7a)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : RobertWang
* 校对者: 
* 状态 : Translating

-----

# Pokedex.org 给宠物小精灵爱好者的 web app 的技术选型

移动网站有个坏名声。大家都认为它很慢，但在如何修复的问题上并不缺少不同的意见。
>	The mobile web has a bad reputation these days. Everyone agrees it's slow, but there's no shortage of differing opinions on how to fix it.

近日，`Jeff Atwood` 令人信服地指出[在Android设备上的单线程JavaScript的状态表现差](https://meta.discourse.org/t/the-state-of-javascript-on-android-in-2015-is-poor/33889)。然后 `Henrik Joreteg` 也质疑[JavaScript框架的在移动端生存能力](https://joreteg.com/blog/viability-of-js-frameworks-on-mobile)，他说对于在移动网络上承担像 `Ember` 和 `Angular` 的框架是太过臃肿。(为了后续良好的讨论，请参见[这些](https://aerotwist.com/blog/the-cost-of-frameworks/) [文章](http://tomdale.net/2015/11/javascript-frameworks-and-mobile-performance/))
>	Recently, Jeff Atwood argued convincingly that [the state of single-threaded JavaScript on Android is poor](https://meta.discourse.org/t/the-state-of-javascript-on-android-in-2015-is-poor/33889). Then Henrik Joreteg questioned [the viability of JavaScript frameworks on mobile](https://joreteg.com/blog/viability-of-js-frameworks-on-mobile) altogether, saying that tools like Ember and Angular are just too bloated for mobile networks to bear. (See also [these](https://aerotwist.com/blog/the-cost-of-frameworks/) [posts](http://tomdale.net/2015/11/javascript-frameworks-and-mobile-performance/) for a good follow-up discussion.)

回顾一下：`Atwood` 说，问题是单线程; `Joreteg` 说，问题是移动网络。我认为他们都是对的。正如做 `Android` 开发的人与做 `web` 开发的人几乎一样多，我会直接告诉你网络和并发能力这两方面是当我写一份原生应用的性能表现时最关心的问题。
>	So to recap: Atwood says the problem is single-threadedness; Joreteg says it's mobile networks. And in my opinion, they're both right. As someone who does nearly as much Android development as web development, I can tell you first-hand that the network and concurrency are two of my primary concerns when writing a performant native app.

问任何 `iOS` 或 `Android` 开发者，怎样使我们的应用更快，极有可能你将听到以下两个主要的策略：
>	Ask any iOS or Android developer how we make our apps so fast, and most likely you'll hear about two major strategies:

1.  **禁用网络通话** 即使是在较好的 `3G` 或 `4G` 连接状态下，健谈的网络活动将使移动应用严重损失性能。让用户盯着加载进度并不是良好的用户体验。
>	1.  **Eliminate network calls.** Chatty network activity can kill the performance of a mobile app, even on a good 3G or 4G connection. Staring at a loading spinner is not a good user experience.
2.  **使用后台线程** 要产生 60`FPS` 的流畅感，你在主线程上的操作必须少于 16ms。任何与 UI(用户界面) 不相关的工作都将转交给一个后台线程去完成。
>	2.  **Use background threads.** To hit a silky-smooth 60 FPS, your operations on the main thread must take less than 16ms. Anything unrelated to the UI should be offloaded to a background thread.

我认为 `web` 作为原生应用能够解决这些问题，只是大多数 `Web` 开发人员不知道这些工具就在外面。对于网络和并发性的问题，`web` 有两个非常好的答案：
>	I believe the web is as capable of solving these problems as native apps, but most web developers just aren't aware that the tools are out there. For the network and concurrency problems, the web has two very good answers:

我决定将这些想法放在一起构建一个像原生应用一样的丰富交互体验的 `webapp`，但其实它仅仅只是一个网站。根据 Chrome 小组的准则，我构建了 [Pokedex.org](http://pokedex.org) - 一个离线工作的[渐进网页应用](https://infrequently.org/2015/06/progressive-apps-escaping-tabs-without-losing-our-soul/)，它可以从主屏幕启动，甚至在普通的 `Android` 手机上运行在 60 `FPS`。这篇博客文章将解释我是如何做到的。
>	I decided to put these ideas together and build a webapp with a rich, interactive experience that's every bit as compelling as a native app, but is also "just" a web site. Following guidelines from the Chrome team, I built [Pokedex.org](http://pokedex.org/) – a [progressive webapp](https://infrequently.org/2015/06/progressive-apps-escaping-tabs-without-losing-our-soul/) that works offline, can be launched from the home screen, and runs at 60 FPS even on mediocre Android phones. This blog post explains how I did it.


## 宠物小精灵 - 一个雄心勃勃的目标
>	## Pokémon – an ambitious target

对于那些未初始化到宠物小精灵的世界里，一个图鉴包含数以百计的娇媚的小生物，以及他们的属性，类型，进化和移动信息的百科全书。对于一个儿童游戏来说恐怕数据量的巨大是令人惊讶的(假如你希望烧脑，可以通过仔细研究[努力值](http://bulbapedia.bulbagarden.net/wiki/Effort_values))。所以这是一个雄心勃勃的Web应用程序的理想目标。
>	For those uninitiated to the world of Pokémon, a Pokédex is an encyclopedia of the hundreds of species of cutesy critters, as well as their stats, types, evolutions, and moves. The data is surprisingly vast for what is supposedly a children's game (read up on [Effort Values](http://bulbapedia.bulbagarden.net/wiki/Effort_values) if you want your brain to hurt over how deep this can get). So it's the perfect target for an ambitious web application.

<video width="400" poster="//nolanlawson.s3.amazonaws.com/vid/DeliriousNeedyAnophelesmosquito.png"><source src="http://nolanlawson.s3.amazonaws.com/vid/DeliriousNeedyAnophelesmosquito.webm" type="video/webm">	<source src="http://nolanlawson.s3.amazonaws.com/vid/DeliriousNeedyAnophelesmosquito.mp4" type="video/mp4"></video>	

第一个问题是获取数据，这个很容易，多亏了精彩的[Pokéapi](http://pokeapi.co/)。第二个问题是，如果我们希望应用程序脱机工作，数据库过于庞大，不能保持在内存中，所以我们需要一些聪明的办法来使用 `IndexedDB` 和/或 `ServiceWorker`。
>	The first issue is getting the data, which is easy thanks to the wonderful [Pokéapi](http://pokeapi.co/). The second issue is that, if we want the app to work offline, the database is far too large to keep in memory, so we'll need some clever use of IndexedDB and/or ServiceWorker.

这个程序，我决定使用[PouchDB]（http://pouchdb.com/）保存宠物小精灵数据（因为它的同步良好），同时使用[LocalForage](https://github.com/mozilla/localForage)作为应用的状态数据存储（因为它有一个很好的键值API）。无论 `PouchDB` 和 `LocalForage` 使用 `IndexedDB` 的 `Web Worder`，这意味着任何数据库操作者将是[完全无阻塞](http://nolanlawson.com/2015/09/29/indexeddb-websql-localstorage-what-blocks-the-dom/)。
>	For this app, I decided to use [PouchDB](http://pouchdb.com/) for the Pokémon data (because it's good at sync), as well as [LocalForage](https://github.com/mozilla/localForage) for app state data (because it has a nice key-value API). Both PouchDB and LocalForage are using IndexedDB inside a web worker, which means any database operations are [fully non-blocking](http://nolanlawson.com/2015/09/29/indexeddb-websql-localstorage-what-blocks-the-dom/).

然而，事实是在第一次加载网站时宠物小精灵数据是不能马上使用的，因为它需要一段时间来从服务器同步。所以，我还使用了后备策略“优先本地，然后才是远端”：
>	However, it's also true that the Pokémon data isn't immediately available when the site is first loaded, because it takes awhile to sync from the server. So I'm also using a fallback strategy of "local first, then remote":

![](http://static1.squarespace.com/static/54d00072e4b0c38f7e184ee0/t/56437650e4b08c803b7dcf42/1447261785905/?format=1500w)

在网站第一次加载时，PouchDB开始从远端数据库同步，在我的项目中使用的是[Cloudant](http://cloudant.com/)（一个CouchDB即服务的提供者）。由于 `PouchDB` 具有本地和远程两套API，可以很容易地从本地数据库查询，如果失败再回退到远程数据库：
>	When the site first loads, PouchDB starts syncing with the remote database, which in my case is [Cloudant](http://cloudant.com/) (a CouchDB-as-a-service provider). Since PouchDB has a dual API for both local and remote, it's easy to query the local database and then fall back to the remote database if that fails:

 ```
 async function getById() {
   {
    return await localDB.();
  } catch () {
    return await remoteDB.();
  }
 }
 ```

（是的，在这个应用中我也决定使用[ES7 异步/待机](http://pouchdb.com/2015/03/05/taming-the-async-beast-with-es7.html)，使用[Regenerator](https://github.com/facebook/regenerator)和[Babel](http://babeljs.io/)，它通过最小化/压缩构建后的大小增加了小于 4KB ，所以对于方便开发者它是非常值得的。）
>	(Yes, I also decided to use [ES7 async/await](http://pouchdb.com/2015/03/05/taming-the-async-beast-with-es7.html) for this app, using [Regenerator](https://github.com/facebook/regenerator) and [Babel(http://babeljs.io/). It adds < 4KB minified/gzipped to the build size, so it's well worth the developer convenience.)
>	__fix__: Babel Link syntax

所以当该网站第一次加载，这是一个相当标准的 `AJAX` 应用，使用 `Cloudant` 获取和显示数据。一旦同步完成（在较好的连接状态下只需要几秒钟），所有交互将成为纯粹的本地访问，这意味着他们更快并且脱机工作。这是实现应用“渐进式”体验的途径之一。
>	So when the site first loads, it's a pretty standard AJAX app, using Cloudant to fetch and display data. Then once the sync has completed (which only takes a few seconds on a good connection), all interactions become purely local, meaning they are much faster and work offline. This is one of the ways that the app is a "progressive" experience.

## 我喜欢你的工作方式
>	## I like the way you work it


我还在这个应用中大量引入[web worker](http://www.html5rocks.com/en/tutorials/workers/basics/)。一个 `web worker` 的本质是一个后台线程，你可以访问除了 `DOM` 之外，浏览器中几乎所有的 `API`，在 `worker` 执行时不会阻塞 `UI`，这有益于你要做的任何事情。
>	I also heavily incorporated [web workers](http://www.html5rocks.com/en/tutorials/workers/basics/) into this app. A web worker is essentially a background thread where you can access nearly all browser APIs except the DOM, with the benefit being that anything you do inside the worker cannot possibly block the UI.

从[web worker](http://www.html5rocks.com/en/tutorials/workers/basics/) [文献](http://ejohn.org/blog/web-workers/)了解 `web worker`，可能你误以为 `web worker` 作用仅仅是有限的校验、解析和其他费时的计算任务。然而，事实证明，`Angular 2` 正计划在体系架构中[web worker 几乎存活于整个生命周期](https://docs.google.com/document/d/1M9FmT05Q6qpsjgvH1XvCm840yn2eWEg0PMskSQz7k4E)，这在个理论上能够提高并行并减少 `jank`，特别是在移动端。类似的技术也可以探索[Flux](https://medium.com/@nsisodiya/flux-inside-web-workers-cc51fb463882#.ooz0ho5si)和[Ember](http://blog.runspired.com/2015/06/05/using-webworkers-to-bring-native-app-best-practices-to-javascript-spas/),虽然没有实已发货呢。
>	From reading [the](http://www.html5rocks.com/en/tutorials/workers/basics/) [literature](http://ejohn.org/blog/web-workers/) on web workers, you might be forgiven for thinking their usefulness is limited to checksumming, parsing, and other computationally expensive tasks. However, it turns out that Angular 2 is planning on an architecture where [nearly the entire application lives inside of the web worker](https://docs.google.com/document/d/1M9FmT05Q6qpsjgvH1XvCm840yn2eWEg0PMskSQz7k4E), which in theory should increase parallelism and reduce jank, especially on mobile. Similar techniques have also been explored for [Flux](https://medium.com/@nsisodiya/flux-inside-web-workers-cc51fb463882#.ooz0ho5si) and [Ember](http://blog.runspired.com/2015/06/05/using-webworkers-to-bring-native-app-best-practices-to-javascript-spas/), although nothing solid has been shipped yet.

-

>	这样做是为了整个应用应该运行在[一个 `web worker`]中，并将渲染指令发送给 `UI` 端。

— Brian Ford, Angular 核心开发者

([来源](https://twitter.com/briantford/status/649332944478171136))

>	>	The idea is to run basically the whole app in [a web worker], and send rendering instructions to the UI side.
>	— Brian Ford, Angular core developer
>	([Source](https://twitter.com/briantford/status/649332944478171136))

因为我喜欢生活在最前沿，我决定对 `Angular 2` 的概念进行一个测试，并几乎将整个应用程序运行在内部的 `web worker` 上，将 `UI` 线程的责任限制在渲染和动画方面。从理论上讲，这应该最大限度地提高并行能力并榨取多核智能手机的所有价值，解决 `Atwood` 关于单线程的 JavaScript 性能问题。
>	Since I like to live on the bleeding edge, I decided to put this Angular 2 notion to the test, and run nearly the entire app inside of the web worker, limiting the UI thread's responsibilities to rendering and animation. In theory, this should maximize parallelism and milk that multi-core smartphone for all it's worth, addressing Atwood's concerns about single-threaded JavaScript performance.

我使用 `React`/`Flux` 对应用架构建立模型，但在这个案例中，我使用的是较低级别的[虚拟DOM(virtual-dom)](https://github.com/Matt-Esch/virtual-dom)，还有一些我写的辅助库，[vdom-as-json](https://github.com/nolanlawson/vdom-as-json)和[vdom-serialized-patch](https://github.com/nolanlawson/vdom-serialized-patch)，它可以将 `DOM` 以补丁的形式串行化为 `JSON`，使这些补丁可以从 `web worker` 发送到主线程。根据[与 `IndexedDB` 规范的作者 `Joshua Bell`咨询](https://code.google.com/p/chromium/issues/detail?id=536620#c11)，与 `worker` 通讯过程中我也字符串化的 `JSON`。
>	I modeled the app architecture after React/Flux, but in this case I'm using the lower-level [virtual-dom](https://github.com/Matt-Esch/virtual-dom), as well as some helper libraries I wrote, [vdom-as-json](https://github.com/nolanlawson/vdom-as-json) and [vdom-serialized-patch](https://github.com/nolanlawson/vdom-serialized-patch), which can serialize DOM patches as JSON, allowing them to be sent from the web worker to the main thread. Based on [advice from IndexedDB spec author Joshua Bell](https://code.google.com/p/chromium/issues/detail?id=536620#c11), I'm also stringifying the JSON during communication with the worker.

该应用程序的结构如下所示：
>	The app structure looks like this:

![](http://static1.squarespace.com/static/54d00072e4b0c38f7e184ee0/t/5643750fe4b0b66656c229f2/1447261866614/?format=1500w)

需要注意的是，整个 “`Flux`” 的应用可以在 `web worker` 里面，同样还有“渲染”、“差异”和一部分“渲染/差异/补丁”管道，因为这些操作都没有依赖 `DOM`。唯一需要在 `UI` 线程上做的事情就是补丁，也就是要使用的 `DOM` 指令最小集合。而且，由于此补丁操作（通常）较少，序列化的成本可以忽略不计。
>	Note that the entire "Flux" application can live inside the web worker, as well as the "render" and "diff" parts of the "render/diff/patch" pipeline, since none of those operations rely on the DOM. The only thing that needs to be done on the UI thread is the patch, i.e. the minimal set of DOM instructions to be applied. And since this patch operation is (usually) small, the serialization costs should be negligible.


为了说明这一点，这里有一个从 `Chrome` 探查记录中得到的时间表，使用的是 `Nexus5` `Android5.1.1` 上运行的 `Chrome47`。时间线从用户点击一个宠物小精灵列表中的那一刻开始，也就是当“详情”面板的被打上补丁，然后向上滑动进入到视图中：
>	To illustrate, here's a timeline recording from the Chrome profiler, using a Nexus 5 running Chrome 47 on Android 5.1.1\. The timeline starts from the moment the user clicks on a Pokémon in the list, which is when the "detail" panel is patched and then slides up into view:

![](http://static1.squarespace.com/static/54d00072e4b0c38f7e184ee0/t/564fc693e4b0328b44c0d443/1448068755659/?format=2500w)

（应用应用补丁和计算翻转动画之间的延迟是有意而为的，目的是为了播放“波动”的动画。）
>	(The delay between applying the patch and calculating the FLIP animation is intentional; it's to allow the "ripple" animation to play.)

需要重点注意的一点是，`UI` 线程在用户监听与应用补丁之间都是完非阻塞的。此外，补丁在(`JSON.parse()`)反序列化时也是微不足道的；它甚至不时间轴上记录。我还为单个请求测量了 `worder` 自身的开销，通常在5-15ms范围（虽然它最高峰偶尔高达200毫秒）。
>	The important thing to notice is that the UI thread is totally unblocked between the user tapping and the patch being applied. Also, the deserialization of the patch (`JSON.parse()`) is inconsequential; it doesn't even register on the timeline. I also measured the overhead of the worker itself for a single request, and it's typically in the 5-15ms range (although it does occasionally spike to as much as 200ms).

现在让我们看看去掉 `worker` ，并把这些业务放回到 `UI` 线程上会是什么样子：
>	Now let's see what it looks like if I move those operations back to the UI thread, by removing the worker:

![](http://static1.squarespace.com/static/54d00072e4b0c38f7e184ee0/t/564fc6aae4b0328b44c0d4c3/1448068779271/?format=1500w)


哇耐莉，有很多的操作发生在 `UI` 线程上！除了 `IndexedDB` 引入了一些轻微的 `DOM` 阻塞，同样还有渲染/差异对比的操作，明显比使用补丁代价更高。
>	Whoa nelly, there's a lot of action happening on the UI thread! Besides IndexedDB, which introduces some slight DOM-blocking, there's also the rendering/diffing operation, which is considerably more expensive than the patching.

您还会注意到，这两个版本大约需要相同的时间（300-400ms），但前者比后者阻塞 `UI` 线程的更少。就我而言，我使用 `GPU` 加速的 `CSS` 动画，所以你不会注意到两种方式太大的差别。但可以设想一下，在一个更复杂的应用中，其中很有可能是 `JavaScript` 的许多并发在争抢 `UI` 线程（第三方广告，滚动效果，等等），这一技巧意味着不怎么样 `UI` 与平滑的 `UI` 之间的不同。
>	You'll also notice that both versions take roughly the same amount of time (300-400ms), but the former blocks the UI thread way less than the latter. In my case, I'm using GPU-accelerated CSS animations, so you won't notice much of a difference either way. But you can imagine that, in a more complex app, where there might be many simultaneous bits of JavaScript fighting for the UI thread (third-party ads, scroll effects, etc.), this trick could mean the difference between a janky UI and a smooth UI.

## 渐进式渲染
>	## Progressive rendering

虚拟的DOM的另一个好处是，我们可以在服务器端预先渲染应用的初始状态。我使用[vdom-to-html](https://github.com/nthtran/vdom-to-html/)渲染排在前面的30个宠物小精灵，并直接显示在页面 `HTML` 代码中。 （HTML在我们的HTML！是怎样一个概念。）虚拟 `DOM` 在客户端重新合成，它的简单，只要用[vdom-as-json](https://github.com/nolanlawson/vdom-as-json)建立起初始的虚拟DOM状态。
>	Another benefit of Virtual DOM is that we can pre-render the initial state of the app on the server side. I used [vdom-to-html](https://github.com/nthtran/vdom-to-html/) to render the first 30 Pokémon and inline that HTML directly in the page. (HTML in our HTML! what a concept.) To re-hydrate that Virtual DOM on the client side, it's as simple as using [vdom-as-json](https://github.com/nolanlawson/vdom-as-json) to build up the initial Virtual DOM state.

![Pokedex.org with JavaScript disabled.](http://static1.squarespace.com/static/54d00072e4b0c38f7e184ee0/t/5651f0d3e4b0a376ef814bfa/1448210644766/?format=1500w)

Pokedex.org中禁用了JavaScript。
>	Pokedex.org with JavaScript disabled.


同样，我也内嵌了最关键的 `CSS` 和 `JavaScript`，非关键的 `CSS` 的异步加载得益于[pretty nifty hack](http://stackoverflow.com/a/32614409/680742)。在[pouchdb-load](https://github.com/nolanlawson/pouchdb-load)插件也被充分利用于更快的初始复制。
>	I'm also inlining most of the critical CSS and JavaScript, with non-critical CSS loaded asynchronously thanks to a [pretty nifty hack](http://stackoverflow.com/a/32614409/680742). The [pouchdb-load](https://github.com/nolanlawson/pouchdb-load) plugin is also being leveraged for faster initial replication.

关于托管，我只是把静态文件放在[Amazon S3](https://aws.amazon.com/s3/)上，使用[Cloudflare](https://www.cloudflare.com/)提供的SSL。 （ServiceWorkers需要SSL。）`Gzip`、缓存头和`SPDY`都是 `CloudFlare` 自动处理的。
>	For hosting, I'm simply putting up static files on [Amazon S3](https://aws.amazon.com/s3/), with SSL provided by [Cloudflare](https://www.cloudflare.com/). (SSL is required for ServiceWorkers.) Gzip, cache headers, and SPDY are all handled automatically by Cloudflare.

在Chrome的开发工具使用2G网络的节流中测试，站点设法在5秒钟内得到 `DOMContentLoaded`，第一个图案大约需要2秒。这意味着在JavaScript是被加载的同时，用户至少有_某些东西_被看到，这大大地改善网站感观上的性能。
>	Testing in the Chrome Dev Tools with the network throttled to 2G, the site manages to get to `DOMContentLoaded` in 5 seconds, with the first paint at around 2 seconds. This means that the user at least has _something_ to look at while the JavaScript is loading, vastly improving the site's perceived performance.

“在 `web worker` 中执行一切”的做法也有助于用渐进式渲染，因为大多数与 `UI` 相关的 `JavaScript`（点击动画，侧边菜单的行为等），可以在一个小的 `JavaScript` 的初始包进行加载，反之，而更大的“框架”包只在 `web worker` 启动时加载。在我的案例中，用户界面包体积在压缩后有24KB，而 `worker` 包是90KB。这意味着，在整个“框架”下载的时候，在网页上至少有一些小的 `UI` 不断地丰富起来。
>	The "do everything in a web worker" approach also helps out with progressive rendering, because most of the JavaScript related to UI (click animations, side menu behavior, etc.) can be loaded in a small initial JavaScript bundle, whereas the larger "framework" bundle is only loaded when the web worker starts up. In my case, the UI bundle weighs in at 24KB minified/gzipped, whereas the worker bundle is 90KB. This means that the page at least has some minor UI flourishes while the full "framework" is downloading.

当然了，`ServiceWorker` 也存储所有静态的“应用外壳”(资源) - HTML，CSS，JavaScript和图像。我使用的是 `先本地后远程` 策略，以确保最佳的线下体验，代码主要是从Jake's Archibald优美的[SVGOMG](https://github.com/jakearchibald/svgomg)中借来的（当然，其实是偷来的）代码。像 `SVGOMG`，应用也显示一个的消息，提醒正在使用脱机应用的用户。 （这是新的技术，用户需要了解一下吧！）
>	Of course, ServiceWorker is also storing all of the static "app shell" – HTML, CSS, JavaScript, and images. I'm using a local-then-remote strategy to ensure the best possible offline experience, with code largely borrowed (well, stolen really) from Jake's Archibald's lovely [SVGOMG](https://github.com/jakearchibald/svgomg). Like SVGOMG, the app also displays a little toast message to reassure the user that yes, the app works offline. (This is new tech; users need to be educated about it!)


<video width="400" poster="//nolanlawson.s3.amazonaws.com/vid/offline-pokedex.png"><source src="http://nolanlawson.s3.amazonaws.com/vid/offline-pokedex.webm" type="video/webm">	<source src="http://nolanlawson.s3.amazonaws.com/vid/offline-pokedex.mp4" type="video/mp4"></video>	

归功于`ServiceWorker`，页面后续的加载由于网络不限制的。因此第一次访问之后，整个站点是本地可用，这意味着呈现不到一秒钟，根据设备的情况速度稍慢。
>	Thanks to ServiceWorker, subsequent loads of the page aren't constrained by the network at all. So after the first visit, the entire site is available locally, meaning it renders in less than a second, or slightly more depending on the speed of the device.

## 动画
>	## Animations


因为我的目标是让应用跑在 60FPS 上，甚至是不合格的移动设备，为此我选择了 `Paul Lewis` 著名的[FLIP 技术](https://aerotwist.com/blog/flip-your-animations/)处理动态的动画，只使用硬件加速的 `CSS` 属性（即`transform`和`opacity`）。结果是这样美丽[材质设计](https://www.google.com/design/spec/material-design/introduction.html)风格的动画，它运行很大，甚至在我早期的 `Galaxy Nexus` 的手机上：
>	Since my goal was to make this app perform at 60 FPS even on substandard mobile devices, I chose Paul Lewis' famous [FLIP technique](https://aerotwist.com/blog/flip-your-animations/) for dynamic animations, using only hardware-accelerated CSS properties (i.e. `transform` and `opacity`). The result is this beautiful [Material Design](https://www.google.com/design/spec/material-design/introduction.html)-style animation, which runs great even on my ancient Galaxy Nexus phone:

<video width="400" poster="//nolanlawson.s3.amazonaws.com/vid/SlimySelfishHermitcrab.png"><source src="http://nolanlawson.s3.amazonaws.com/vid/SlimySelfishHermitcrab.webm" type="video/webm">	<source src="http://nolanlawson.s3.amazonaws.com/vid/SlimySelfishHermitcrab.mp4" type="video/mp4"></video>	

-----
@TODO
