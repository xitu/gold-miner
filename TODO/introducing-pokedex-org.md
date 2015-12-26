> * 原文链接 : [Introducing Pokedex.org: a progressive webapp for Pokémon fans — Pocket JavaScript](http://www.pocketjavascript.com/blog/2015/11/23/introducing-pokedex-org)
* 原文作者 : [NOLAN LAWSON](http://www.pocketjavascript.com/?author=539b3a09e4b0dc27b9618c7a)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : 
* 校对者: 
* 状态 :  待定

The mobile web has a bad reputation these days. Everyone agrees it's slow, but there's no shortage of differing opinions on how to fix it.
移动网站有个坏名声。大家都认为它很慢，但在如何修复的问题上并不缺少不同的意见。

Recently, Jeff Atwood argued convincingly that [the state of single-threaded JavaScript on Android is poor](https://meta.discourse.org/t/the-state-of-javascript-on-android-in-2015-is-poor/33889). Then Henrik Joreteg questioned [the viability of JavaScript frameworks on mobile](https://joreteg.com/blog/viability-of-js-frameworks-on-mobile) altogether, saying that tools like Ember and Angular are just too bloated for mobile networks to bear. (See also [these](https://aerotwist.com/blog/the-cost-of-frameworks/) [posts](http://tomdale.net/2015/11/javascript-frameworks-and-mobile-performance/) for a good follow-up discussion.)
近日，`Jeff Atwood` 令人信服地指出[在Android设备上的单线程JavaScript的状态表现差](https://meta.discourse.org/t/the-state-of-javascript-on-android-in-2015-is-poor/33889)。然后 `Henrik Joreteg` 也质疑[JavaScript框架的在移动端生存能力](https://joreteg.com/blog/viability-of-js-frameworks-on-mobile)，他说对于在移动网络上承担像 `Ember` 和 `Angular` 的框架是太过臃肿。(为了后续良好的讨论，请参见[这些](https://aerotwist.com/blog/the-cost-of-frameworks/) [文章](http://tomdale.net/2015/11/javascript-frameworks-and-mobile-performance/))

So to recap: Atwood says the problem is single-threadedness; Joreteg says it's mobile networks. And in my opinion, they're both right. As someone who does nearly as much Android development as web development, I can tell you first-hand that the network and concurrency are two of my primary concerns when writing a performant native app.
回顾一下：`Atwood` 说，问题是单线程; `Joreteg` 说，问题是移动网络。我认为他们都是对的。正如做 `Android` 开发的人与做 `web` 开发的人几乎一样多，我会直接告诉你网络和并发能力这两方面是当我写一份原生应用的性能表现时最关心的问题。

Ask any iOS or Android developer how we make our apps so fast, and most likely you'll hear about two major strategies:
问任何 `iOS` 或 `Android` 开发者，怎样使我们的应用更快，极有可能你将听到以下两个主要的策略：

1.  **Eliminate network calls.** Chatty network activity can kill the performance of a mobile app, even on a good 3G or 4G connection. Staring at a loading spinner is not a good user experience.
1.  **禁用网络通话** 即使是在较好的 `3G` 或 `4G` 连接状态下，健谈的网络活动将使移动应用严重损失性能。让用户盯着加载进度并不是良好的用户体验。
2.  **Use background threads.** To hit a silky-smooth 60 FPS, your operations on the main thread must take less than 16ms. Anything unrelated to the UI should be offloaded to a background thread.
2.  **使用后台线程** 要产生 60`FPS` 的流畅感，你在主线程上的操作必须少于 16ms。任何与 UI(用户界面) 不相关的工作都将转交给一个后台线程去完成。

I believe the web is as capable of solving these problems as native apps, but most web developers just aren't aware that the tools are out there. For the network and concurrency problems, the web has two very good answers:
我认为 `web` 作为原生应用能够解决这些问题，只是大多数 `Web` 开发人员不知道这些工具就在外面。对于网络和并发性的问题，`web` 有两个非常好的答案：

I decided to put these ideas together and build a webapp with a rich, interactive experience that's every bit as compelling as a native app, but is also "just" a web site. Following guidelines from the Chrome team, I built [Pokedex.org](http://pokedex.org/) – a [progressive webapp](https://infrequently.org/2015/06/progressive-apps-escaping-tabs-without-losing-our-soul/) that works offline, can be launched from the home screen, and runs at 60 FPS even on mediocre Android phones. This blog post explains how I did it.
我决定将这些想法放在一起构建一个像原生应用一样的丰富交互体验的 `webapp`，但其实它仅仅只是一个网站。根据 Chrome 小组的准则，我构建了 [Pokedex.org](http://pokedex.org) - 一个离线工作的[渐进网页应用](https://infrequently.org/2015/06/progressive-apps-escaping-tabs-without-losing-our-soul/)，它可以从主屏幕启动，甚至在普通的 `Android` 手机上运行在 60 `FPS`。这篇博客文章将解释我是如何做到的。


## Pokémon – an ambitious target
## 神奇宝贝 - 一个雄心勃勃的目标

For those uninitiated to the world of Pokémon, a Pokédex is an encyclopedia of the hundreds of species of cutesy critters, as well as their stats, types, evolutions, and moves. The data is surprisingly vast for what is supposedly a children's game (read up on [Effort Values](http://bulbapedia.bulbagarden.net/wiki/Effort_values) if you want your brain to hurt over how deep this can get). So it's the perfect target for an ambitious web application.
对于那些未初始化到神奇宝贝的世界里，一个图鉴包含数以百计的娇媚的小生物，以及他们的属性，类型，进化和移动信息的百科全书。对于一个儿童游戏来说恐怕数据量的巨大是令人惊讶的(假如你希望烧脑，可以通过仔细研究[努力值](http://bulbapedia.bulbagarden.net/wiki/Effort_values))。所以这是一个雄心勃勃的Web应用程序的理想目标。

<video width="400" poster="//nolanlawson.s3.amazonaws.com/vid/DeliriousNeedyAnophelesmosquito.png"><source src="http://nolanlawson.s3.amazonaws.com/vid/DeliriousNeedyAnophelesmosquito.webm" type="video/webm"> <source src="http://nolanlawson.s3.amazonaws.com/vid/DeliriousNeedyAnophelesmosquito.mp4" type="video/mp4"></video> 

The first issue is getting the data, which is easy thanks to the wonderful [Pokéapi](http://pokeapi.co/). The second issue is that, if we want the app to work offline, the database is far too large to keep in memory, so we'll need some clever use of IndexedDB and/or ServiceWorker.
第一个问题是获取数据，这个很容易，多亏了精彩的[Pokéapi](http://pokeapi.co/)。第二个问题是，如果我们希望应用程序脱机工作，数据库过于庞大，不能保持在内存中，所以我们需要一些聪明的办法来使用 `IndexedDB` 和/或 `ServiceWorker`。

For this app, I decided to use [PouchDB](http://pouchdb.com/) for the Pokémon data (because it's good at sync), as well as [LocalForage](https://github.com/mozilla/localForage) for app state data (because it has a nice key-value API). Both PouchDB and LocalForage are using IndexedDB inside a web worker, which means any database operations are [fully non-blocking](http://nolanlawson.com/2015/09/29/indexeddb-websql-localstorage-what-blocks-the-dom/).

However, it's also true that the Pokémon data isn't immediately available when the site is first loaded, because it takes awhile to sync from the server. So I'm also using a fallback strategy of "local first, then remote":

![](http://static1.squarespace.com/static/54d00072e4b0c38f7e184ee0/t/56437650e4b08c803b7dcf42/1447261785905/?format=1500w)

When the site first loads, PouchDB starts syncing with the remote database, which in my case is [Cloudant](http://cloudant.com/) (a CouchDB-as-a-service provider). Since PouchDB has a dual API for both local and remote, it's easy to query the local database and then fall back to the remote database if that fails:

 ```
 async function getById() {
   {
    return await localDB.();
  } catch () {
    return await remoteDB.();
  }
}
```

(Yes, I also decided to use [ES7 async/await](http://pouchdb.com/2015/03/05/taming-the-async-beast-with-es7.html) for this app, using [Regenerator](https://github.com/facebook/regenerator) and [Babel(http://babeljs.io/). It adds < 4KB minified/gzipped to the build size, so it's well worth the developer convenience.)

So when the site first loads, it's a pretty standard AJAX app, using Cloudant to fetch and display data. Then once the sync has completed (which only takes a few seconds on a good connection), all interactions become purely local, meaning they are much faster and work offline. This is one of the ways that the app is a "progressive" experience.

## I like the way you work it

I also heavily incorporated [web workers](http://www.html5rocks.com/en/tutorials/workers/basics/) into this app. A web worker is essentially a background thread where you can access nearly all browser APIs except the DOM, with the benefit being that anything you do inside the worker cannot possibly block the UI.

From reading [the](http://www.html5rocks.com/en/tutorials/workers/basics/) [literature](http://ejohn.org/blog/web-workers/) on web workers, you might be forgiven for thinking their usefulness is limited to checksumming, parsing, and other computationally expensive tasks. However, it turns out that Angular 2 is planning on an architecture where [nearly the entire application lives inside of the web worker](https://docs.google.com/document/d/1M9FmT05Q6qpsjgvH1XvCm840yn2eWEg0PMskSQz7k4E), which in theory should increase parallelism and reduce jank, especially on mobile. Similar techniques have also been explored for [Flux](https://medium.com/@nsisodiya/flux-inside-web-workers-cc51fb463882#.ooz0ho5si) and [Ember](http://blog.runspired.com/2015/06/05/using-webworkers-to-bring-native-app-best-practices-to-javascript-spas/), although nothing solid has been shipped yet.



> The idea is to run basically the whole app in [a web worker], and send rendering instructions to the UI side.

— Brian Ford, Angular core developer



([Source](https://twitter.com/briantford/status/649332944478171136))

Since I like to live on the bleeding edge, I decided to put this Angular 2 notion to the test, and run nearly the entire app inside of the web worker, limiting the UI thread's responsibilities to rendering and animation. In theory, this should maximize parallelism and milk that multi-core smartphone for all it's worth, addressing Atwood's concerns about single-threaded JavaScript performance.

I modeled the app architecture after React/Flux, but in this case I'm using the lower-level [virtual-dom](https://github.com/Matt-Esch/virtual-dom), as well as some helper libraries I wrote, [vdom-as-json](https://github.com/nolanlawson/vdom-as-json) and [vdom-serialized-patch](https://github.com/nolanlawson/vdom-serialized-patch), which can serialize DOM patches as JSON, allowing them to be sent from the web worker to the main thread. Based on [advice from IndexedDB spec author Joshua Bell](https://code.google.com/p/chromium/issues/detail?id=536620#c11), I'm also stringifying the JSON during communication with the worker.

The app structure looks like this:

![](http://static1.squarespace.com/static/54d00072e4b0c38f7e184ee0/t/5643750fe4b0b66656c229f2/1447261866614/?format=1500w)

Note that the entire "Flux" application can live inside the web worker, as well as the "render" and "diff" parts of the "render/diff/patch" pipeline, since none of those operations rely on the DOM. The only thing that needs to be done on the UI thread is the patch, i.e. the minimal set of DOM instructions to be applied. And since this patch operation is (usually) small, the serialization costs should be negligible.

To illustrate, here's a timeline recording from the Chrome profiler, using a Nexus 5 running Chrome 47 on Android 5.1.1\. The timeline starts from the moment the user clicks on a Pokémon in the list, which is when the "detail" panel is patched and then slides up into view:

![](http://static1.squarespace.com/static/54d00072e4b0c38f7e184ee0/t/564fc693e4b0328b44c0d443/1448068755659/?format=2500w)

(The delay between applying the patch and calculating the FLIP animation is intentional; it's to allow the "ripple" animation to play.)

The important thing to notice is that the UI thread is totally unblocked between the user tapping and the patch being applied. Also, the deserialization of the patch (`JSON.parse()`) is inconsequential; it doesn't even register on the timeline. I also measured the overhead of the worker itself for a single request, and it's typically in the 5-15ms range (although it does occasionally spike to as much as 200ms).

Now let's see what it looks like if I move those operations back to the UI thread, by removing the worker:


![](http://static1.squarespace.com/static/54d00072e4b0c38f7e184ee0/t/564fc6aae4b0328b44c0d4c3/1448068779271/?format=1500w)

Whoa nelly, there's a lot of action happening on the UI thread! Besides IndexedDB, which introduces some slight DOM-blocking, there's also the rendering/diffing operation, which is considerably more expensive than the patching.

You'll also notice that both versions take roughly the same amount of time (300-400ms), but the former blocks the UI thread way less than the latter. In my case, I'm using GPU-accelerated CSS animations, so you won't notice much of a difference either way. But you can imagine that, in a more complex app, where there might be many simultaneous bits of JavaScript fighting for the UI thread (third-party ads, scroll effects, etc.), this trick could mean the difference between a janky UI and a smooth UI.

## Progressive rendering

Another benefit of Virtual DOM is that we can pre-render the initial state of the app on the server side. I used [vdom-to-html](https://github.com/nthtran/vdom-to-html/) to render the first 30 Pokémon and inline that HTML directly in the page. (HTML in our HTML! what a concept.) To re-hydrate that Virtual DOM on the client side, it's as simple as using [vdom-as-json](https://github.com/nolanlawson/vdom-as-json) to build up the initial Virtual DOM state.


![Pokedex.org with JavaScript disabled.](http://static1.squarespace.com/static/54d00072e4b0c38f7e184ee0/t/5651f0d3e4b0a376ef814bfa/1448210644766/?format=1500w)

Pokedex.org with JavaScript disabled.

I'm also inlining most of the critical CSS and JavaScript, with non-critical CSS loaded asynchronously thanks to a [pretty nifty hack](http://stackoverflow.com/a/32614409/680742). The [pouchdb-load](https://github.com/nolanlawson/pouchdb-load) plugin is also being leveraged for faster initial replication.

For hosting, I'm simply putting up static files on [Amazon S3](https://aws.amazon.com/s3/), with SSL provided by [Cloudflare](https://www.cloudflare.com/). (SSL is required for ServiceWorkers.) Gzip, cache headers, and SPDY are all handled automatically by Cloudflare.

Testing in the Chrome Dev Tools with the network throttled to 2G, the site manages to get to `DOMContentLoaded` in 5 seconds, with the first paint at around 2 seconds. This means that the user at least has _something_ to look at while the JavaScript is loading, vastly improving the site's perceived performance.

The "do everything in a web worker" approach also helps out with progressive rendering, because most of the JavaScript related to UI (click animations, side menu behavior, etc.) can be loaded in a small initial JavaScript bundle, whereas the larger "framework" bundle is only loaded when the web worker starts up. In my case, the UI bundle weighs in at 24KB minified/gzipped, whereas the worker bundle is 90KB. This means that the page at least has some minor UI flourishes while the full "framework" is downloading.

Of course, ServiceWorker is also storing all of the static "app shell" – HTML, CSS, JavaScript, and images. I'm using a local-then-remote strategy to ensure the best possible offline experience, with code largely borrowed (well, stolen really) from Jake's Archibald's lovely [SVGOMG](https://github.com/jakearchibald/svgomg). Like SVGOMG, the app also displays a little toast message to reassure the user that yes, the app works offline. (This is new tech; users need to be educated about it!)


<video width="400" poster="//nolanlawson.s3.amazonaws.com/vid/offline-pokedex.png"><source src="http://nolanlawson.s3.amazonaws.com/vid/offline-pokedex.webm" type="video/webm"> <source src="http://nolanlawson.s3.amazonaws.com/vid/offline-pokedex.mp4" type="video/mp4"></video> 


Thanks to ServiceWorker, subsequent loads of the page aren't constrained by the network at all. So after the first visit, the entire site is available locally, meaning it renders in less than a second, or slightly more depending on the speed of the device.

## Animations

Since my goal was to make this app perform at 60 FPS even on substandard mobile devices, I chose Paul Lewis' famous [FLIP technique](https://aerotwist.com/blog/flip-your-animations/) for dynamic animations, using only hardware-accelerated CSS properties (i.e. `transform` and `opacity`). The result is this beautiful [Material Design](https://www.google.com/design/spec/material-design/introduction.html)-style animation, which runs great even on my ancient Galaxy Nexus phone:

<video width="400" poster="//nolanlawson.s3.amazonaws.com/vid/SlimySelfishHermitcrab.png"><source src="http://nolanlawson.s3.amazonaws.com/vid/SlimySelfishHermitcrab.webm" type="video/webm"> <source src="http://nolanlawson.s3.amazonaws.com/vid/SlimySelfishHermitcrab.mp4" type="video/mp4"></video> 

The best part about FLIP animations is that they combine the flexibility of JavaScript with the performance of CSS animations. So although the Pokémon's initial state isn't pre-determined, we can still animate from anywhere in the list to a fixed position in the detail view, without sacrificing any frames. We can also run quite a few animations in parallel – notice that the background fill, the sprite movement, and the panel slide are three separate animations.

The only place where I deviated slightly from Lewis' FLIP algorithm was the animation of the Pokémon sprite. Because neither the source nor the target were positioned in a way that was conducive to animations, I had to create a third sprite, absolutely positioned within the body, as a façade to transition between the two.

## Gotchas

Of course, any webapp can suffer from slowdowns if you're not careful to keep an eye on the Chrome profiler and constantly check your assumptions on a real device. Some of the issues I ran into:

1.  CSS sprites are great for reducing the payload size, but they slowed the app down to a crawl due to excessive memory usage. I ultimately went with base64 inlining.
2.  I needed a performant scrolling list, so I took some inspiration from [Ionic collection-repeat](http://ionicframework.com/blog/collection-repeat/), [Ember list-view](https://github.com/emberjs/list-view), and [Android ListView](https://developer.android.com/guide/topics/ui/layout/listview.html), to build a simple

    _just_

    *   s that are in the visible viewport, with stubs for everything else. This cuts down on memory usage, making the animations and touch interactions much snappier. And once again, all of the list computation and diffing is done inside of the web worker, so scrolling is kept buttery-smooth. This works with as many as 649 Pokémon being shown at once.
    *   Be careful what libraries you choose! I'm using [MUI](http://muicss.com/) as my "Material" CSS library, which is great for bootstrapping, but sadly I discovered that it often wasn't doing the optimal thing for performance. So I ended up having to re-implement parts of it myself. For instance, the side menu was originally being animated using `margin-left` instead of `transform`, which leads to [janky animations on mobile](https://youtu.be/Q-nxiBNxCA4).
    *   Event listeners are a menace. At one point MUI was adding an event listener on every
    *   (for the "ripple" effect), which slowed down even the hardware-accelerated CSS animations due to memory usage. Luckily the Chrome Dev Tools has a "Show scrolling perf issues" checkbox, which immediately revealed the problem:


![](http://static1.squarespace.com/static/54d00072e4b0c38f7e184ee0/t/56437d45e4b07a45a8692ee2/1447263577485/?format=1500w)

To work around this, I attached a single event listener to the entire

*   s.

    ## Browser support

    As it turns out, a lot of the APIs I mention above aren't perfectly supported in all browsers. Most notably, ServiceWorker is not available in Safari, iOS, IE, or Edge. (Firefox has it in nightly and will ship very soon.) This means that the offline functionality won't work in those browsers – if you refresh the page without a connection, the content won't be there anymore.

    Another hurdle I ran into is that [Safari does not support IndexedDB in a web worker](https://bugs.webkit.org/show_bug.cgi?id=149953), meaning I had to write a workaround to avoid the web worker in Safari and just use PouchDB/LocalForage over WebSQL. Safari also still has the 350ms tap delay, which I chose not to fix with the [FastClick hack](https://github.com/ftlabs/fastclick) because I know Safari will fix it themselves in [an upcoming release](https://twitter.com/jaffathecake/status/659174357583814656). Momentum scrolling is also broken in iOS, for reasons I don't yet understand. (**Update:** [looks like](https://github.com/nolanlawson/pokedex.org/issues/4) it needs `-webkit-overflow-scroll: touch`.)

    Surprisingly, Edge and FirefoxOS both worked without a hitch (except for ServiceWorker). FirefoxOS even has the status bar theme colors, which is neat. I haven't tested in Windows Phone yet.

    Of course, I could have fixed all these compatibility issues with a million polyfills – [Apple touch icons](https://developer.apple.com/library/ios/documentation/AppleApplications/Reference/SafariWebContent/ConfiguringWebApplications/ConfiguringWebApplications.html) instead of [Web Manifests](http://www.w3.org/TR/appmanifest/), [AppCache](http://alistapart.com/article/application-cache-is-a-douchebag) instead of ServiceWorker, FastClick, etc. However, one of my goals for this app was to make a high-quality experience with _progressive degradation_ for the less standards-compliant browsers. On browsers with ServiceWorker, the app is a rich, high-quality offline app. On other browsers, it's just a web site.

    And I'm okay with that. I strongly believe that web developers need to push the envelope on this stuff, if we expect browser vendors to have any motivation to improve their implementations. To quote WebKit developer Dean Jackson, one of the reasons they didn't prioritize IndexedDB was because they ["don't see much use."](https://twitter.com/grorgwork/status/610905347306328065) In other words, if there were a lot of high-quality sites that depended on IndexedDB, then WebKit would have been pushed to implement it. But developers didn't step up their game, so browser vendors just shrugged it off.

    If we only use features that work in IE8, then we're condemning ourselves to live in an IE8 world. This app is a protest against that mindset.

    ## TODOs

    There are still more improvements to make to this app. Some unanswered questions for me, especially involving ServiceWorker:

    1.  **How to handle routing?** If I do it the "right" way with the HTML5 History API (as opposed to hash URLs), does that mean I need to duplicate my routing logic on the server side, the client side, _and_ in the ServiceWorker? Sure seems that way.
    2.  **How to update the ServiceWorker?** I'm versioning all the data I store in the ServiceWorker Cache, but I'm not sure how to evict stale data for existing users. Currently they need to refresh the page or restart their browser so that the ServiceWorker can update, but I'd like to do it live somehow.
    3.  **How to control the app banner?** Chrome will show an "install to home screen" banner if you visit the site twice in the same week (with some heuristics), but I really like the way [Flipkart Lite](http://flipkart.com/) captures the banner event so that they can launch it themselves. It feels like a more streamlined experience.

<video width="400" poster="//nolanlawson.s3.amazonaws.com/vid/pokedex-install-banner.png"><source src="http://nolanlawson.s3.amazonaws.com/vid/pokedex-install-banner.webm" type="video/webm"> <source src="http://nolanlawson.s3.amazonaws.com/vid/pokedex-install-banner.mp4" type="video/mp4"></video> 

## Conclusion

The web is quickly catching up on mobile, but of course there are always improvements to be made. And like any good Pokémaniac, I want Pokedex.org to be the very best, [like no app ever was](https://www.youtube.com/watch?v=DqXlSwBIHFc).

So I encourage anyone to take a look at [the source on Github](https://github.com/nolanlawson/pokedex.org/) and tell me where it can improve. As it stands, though, I think Pokedex.org is a gorgeous, immersive mobile app, and one that's tailor-made for the web. My hope is that it can demonstrate some of the great features that the web of 2015 can offer, while also serving as a valuable resource for the Pokémon fan who's gotta catch 'em all.

_Thanks to Jacob Angel for providing feedback on a draft of this blog post._

_For more on the tech behind Pokedex.org, check out [my "progressive webapp" reading list](https://gist.github.com/nolanlawson/d9e66349635452a95bb1)._
