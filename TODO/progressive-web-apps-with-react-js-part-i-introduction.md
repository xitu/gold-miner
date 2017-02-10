> * 原文地址：[Progressive Web Apps with React.js: Part I — Introduction](https://medium.com/@addyosmani/progressive-web-apps-with-react-js-part-i-introduction-50679aef2b12#.g5r0gv9j5)
* 原文作者：[Addy Osmani](https://medium.com/@addyosmani)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [markzhai](https://github.com/markzhai)
* 校对者：[Tina92](https://github.com/Tina92), [DeadLion](https://github.com/DeadLion)

# 使用 React.js 的渐进式 Web 应用程序：第 1 部分 - 介绍




### 渐进式 Web 应用程序利用新技术利用新技术的优势带给了用户最佳的移动网站和原生应用。它们是可靠的，迅捷的，迷人的。它们来自可靠的源，而且无论网络状态如何都能加载。

![](https://cdn-images-1.medium.com/max/1600/1*Ms2muRzG4DHE36YU4kX_ag@2x.png)



在 [渐进式 Web 应用程序](https://infrequently.org/2015/06/progressive-apps-escaping-tabs-without-losing-our-soul/) (PWAs) 的世界中有很多新东西，你可能会想知道它们和现有架构是如何兼容的 —— 比如 [React](https://facebook.github.io/react/) 和 JS 模块化打包工具如 [Webpack](https://webpack.github.io/) 之间的兼容性如何。PWA 是否需要大量的重写？你需要关注哪个 Web 性能度量工具？在这系列的文章中，我将会分享将基于 React 的 web apps 转化为 PWAs 的经验。我们还将包括为什么**仅**加载用户路由所需要的，并抛开其他所有脚本是提高性能的好方式。

### Lighthouse

让我们从一个 PWA manifest 开始。为此我们会使用 [**Lighthouse**](https://github.com/GoogleChrome/lighthouse) — 一个评审 [app 面向 PWA 特性](https://infrequently.org/2016/09/what-exactly-makes-something-a-progressive-web-app/) 的工具，并且检查你的 app 在模拟移动场景下是否做的足够好。Lighthouse 可以通过 [Chrome 插件](https://chrome.google.com/webstore/detail/lighthouse/blipmdconlkpinefehnmjammfjpmpbjk) (我大部分时候都用这个) 以及 [CLI](https://github.com/GoogleChrome/lighthouse#install-cli) 来使用，两者都会展示一个类似这样的报告：













![](https://cdn-images-1.medium.com/max/2000/0*EI9JfoDRizcpZolA.)



来自 Lighthouse Chrome 插件的结果







顶级评审工具 Lighthouse 会高效地运行一系列为移动世界精炼的现代 web 最佳实践：

*   **网络连接是安全的**
*   **用户会被提醒将 app 添加到 Homescreen**
*   **安装了的 web app 启动时会带自定义的闪屏画面**
*   **App 可以在离线/断断续续的连接下加载**
*   **页面加载性能快速**
*   **设计是移动友好的**
*   **网页是渐进式增强的**
*   **地址栏符合品牌颜色**

顺便一提，有一个 Lighthouse 的 [快速入门指南](https://developers.google.com/web/tools/lighthouse/)，而且它还能通过 [远程调试](https://github.com/GoogleChrome/lighthouse#lighthouse-w-mobile-devices) 工作。超级酷炫。

无论在你的技术栈中使用了什么库，我想要强调的是在上面列出的一切，在今天都只需要一点小小的工作量就能完成。然而也有一些警告。

**我们知道移动 web 是 [**慢的**](https://www.doubleclickbygoogle.com/articles/mobile-speed-matters/)**。

web 从一个以文档为中心的平台演变为了头等的应用平台。同时我们主要的计算能力也从强大的，拥有快速可靠的网络连接的强大桌面机器移动到了相对不给力的，连接通常**慢，断断续续或者两者都存在**的移动设备上。这在下一个 10 亿用户即将上网的世界尤其真实。为了解锁更快的移动 web：

*   **我们需要全体转移到在真实移动设备，现实的网络连接下进行测试** (e.g [在 DevTools 的常规 3G](https://developers.google.com/web/tools/chrome-devtools/profile/network-performance/network-conditions?hl=en))。 [chrome://inspect](https://developers.google.com/web/tools/chrome-devtools/debug/remote-debugging/remote-debugging?hl=en) 和 [WebPageTest](https://www.webpagetest.org/) ([视频](https://www.youtube.com/watch?v=pOynMwTyRgQ&feature=youtu.be)) 是你的好帮手。Lighthouse 模拟一台有触摸事件的 Nexus 5X 设备，以及 viewport 仿真 和 被限制的网络连接 （150毫秒延迟，1.6Mbps 吞吐量)。
*   **如果你使用的是设计开发时没有考虑移动设备的 JS 库，你可能会为了可交互性能打一场硬仗**。我们的理想化目标是在一台响应式设备上 5 秒内变得可交互，所以我们应用代码的预算会更多是 ❤









![](https://cdn-images-1.medium.com/max/1600/1*Qx7aFIAKWbn11heD--nxwg.png)



通过一些工作，可以写出 [如 Housing.com 所展示的](https://twitter.com/samccone/status/771786445015035904) 在有限网络环境下，真机上依然表现良好的使用 React 开发的 PWAs。我们在接下来的系列中讨论如何实现的详尽 **细节**。



话虽如此，这是一个很多库都在尽力提高的领域，你可能需要知道他们是否会继续提高在物理设备上的性能。只需要看看 [Preact](https://github.com/developit/preact) 所做的超级棒的 [真实世界设备的性能](https://twitter.com/slightlylate/status/770652362985836544)。

**开源 React 渐进式 Web App 示例**









![](https://cdn-images-1.medium.com/max/1600/0*5tmODLoFjo8A_nnW.)





**如果你想要看更复杂的使用 React 开发，并使用 Lighthouse 优化的 PWAs 例子，你可能会感兴趣于：** [_ReactHN_](https://github.com/insin/react-hn)**— 一个使用服务端渲染并支持离线的 HackerNews 客户端 或者 [_iFixit_](https://github.com/GoogleChrome/sw-precache/tree/master/app-shell-demo) — 一个使用 React 开发，但使用了 Redux 进行状态管理的硬件修复指南 app。**

现在让我们梳理一遍在 Lighthouse 报告中需要清点的每一项，并在系列中继续 React.js 专用的小贴士。

### 网络连接是安全的

#### HTTPS 的工具和建议









![](https://cdn-images-1.medium.com/max/1200/1*xRLobGG8a41wGypF9mKI-A.jpeg)





[HTTPS](https://support.google.com/webmasters/answer/6073543?hl=en) 防止坏人篡改你的 app 和你的用户使用的浏览器之间的通信，你可能读过 Google 正在推动 [羞辱](http://motherboard.vice.com/read/google-will-soon-shame-all-websites-that-are-unencrypted-chrome-https) 那些没有加密的网站。强大的新型 web 平台 APIs，像 [Service Worker](https://developer.mozilla.org/en-US/docs/Web/API/Service_Worker_API)，[require](https://www.chromium.org/Home/chromium-security/prefer-secure-origins-for-powerful-new-features) 通过 HTTPS 保护来源，但是好消息是像是 [LetsEncrypt](https://letsencrypt.org/) 这样的服务商提供了免费的 [SSL 证书](https://www.globalsign.com/en/ssl-information-center/what-is-an-ssl-certificate/)，便宜的选择像是 [Cloudflare](https://www.cloudflare.com/) 可以使端到端流量 [完全](https://www.cloudflare.com/ssl/) 加密，从来没有如此简单直接地能做到现在这样。

作为我的个人项目，我通常会部署到 [Google App Engine](https://cloud.google.com/appengine/)，它支持通过 appspot.com 域名的 SSL 通信服务，只需要你加上 [‘secure’](https://cloud.google.com/appengine/docs/python/config/appref) 参数到你的 app.yaml 文件。对于需要 Node.js 支持 Universal 渲染的 React apps，我使用 [Node on App Engine](https://cloudplatform.googleblog.com/2016/03/Node.js-on-Google-App-Engine-goes-beta.html)。[Github Pages](https://github.com/blog/2186-https-for-github-pages) 和 [Zeit.co](https://zeit.co/blog/now-alias) 现在也支持 HTTPS。









![](https://cdn-images-1.medium.com/max/1600/0*OzD-JvnlDlwVS8d-.)





_这个_ [_Chrome DevTools Security 面板_](https://developers.google.com/web/updates/2015/12/security-panel?hl=en) **允许你印证安全证书和混合内容错误的问题。**

一些更多的小贴士可以使你的网站更加安全：

*   根据需要重定向用户，升级非安全请求（“HTTP” 连接）到 “HTTPS”。可以一看 [内容安全策略](https://content-security-policy.com/) 和 [升级非安全请求](https://googlechrome.github.io/samples/csp-upgrade-insecure-requests/)。
*   更新所有引用 “http://” 的链接到 “https://”。如果你依赖第三方的脚本或者内容，跟他们商量一下让他们也支持一下 HTTPS 资源。
*   提供页面的时候，使用 [HTTP 严格传输安全](https://en.wikipedia.org/wiki/HTTP_Strict_Transport_Security) (HSTS) 头。这是一个强制浏览器只通过 HTTPS 和你的网站交流的指令。

我建议去看看 [Deploying HTTPS: The Green Lock and Beyond](https://developers.google.com/web/shows/cds/2015/deploying-https-the-green-lock-and-beyond-chrome-dev-summit-2015?hl=en) 和 [Mythbusting HTTPS: Squashing security’s urban legends](https://developers.google.com/web/shows/google-io/2016/mythbusting-https-squashing-securitys-urban-legends-google-io-2016?hl=en) 来了解更多。

### 用户会被提醒将 app 添加到 Homescreen

下一个要讲的是自定义你的 app 的 “[添加到主屏幕](https://developer.chrome.com/multidevice/android/installtohomescreen)” 体验（favicons，显示的应用名字，方向和更多）。这是通过添加一个 [Web 应用 manifest](https://developer.mozilla.org/en-US/docs/Web/Manifest) 来做的。我经常会找定制的跨浏览器（以及系统）的图标来完成这部分工作，但是像是 [realfavicongenerator.net](http://realfavicongenerator.net/) 这样的工具能解决不少麻烦的事情。









![](https://cdn-images-1.medium.com/max/1600/0*00LlyQjpgTUPOh0g.)




有很多关于一个网站只需要在大部分场合能工作的 “最少” favicons 的讨论。Lighthouse [提议](https://github.com/GoogleChrome/lighthouse/issues/291) 提供一个 192px 的图标给主屏幕，一个 512px 的图标给你的闪屏。我个人坚持从 realfavicongenerator 得到的输出，除了它包含更多的 metatags, 我也更倾向于它能涵盖我的所有基数。

一些网站可能更倾向于为每个平台提供高度定制化的 favicon。我推荐去看看 [设计一个渐进式 Web App 图标](https://medium.com/dev-channel/designing-a-progressive-web-app-icon-b55f63f9ff6e#.voxq5imjg) 以获得更多关于这个主题的指导。









![](https://cdn-images-1.medium.com/max/1200/1*xdyHSM4RdSkeN3-U8O1JKg.png)





通过 Web App manifest 安装，你还能获得 [app 安装器横幅](https://developers.google.com/web/fundamentals/engage-and-retain/app-install-banners/?hl=en)，让你有方法可以原生地提示用户来安装你的 PWA，如果他们觉得会经常使用它的话。还可以 [延迟](https://developers.google.com/web/fundamentals/engage-and-retain/app-install-banners/?hl=en#deferring_or_cancelling_the_prompt) 提示，直到用户和你的 app 进行了有意义的交互。Flipkart [找到](https://twitter.com/adityapunjani/status/782426188702633984) 最佳时间来显示这个提示是在他们的订单确认页。

[**Chrome DevTools Application 面板**](https://developers.google.com/web/tools/chrome-devtools/progressive-web-apps) 支持通过 Application > Manifest 来查看你的 Web App manifest：









![](https://cdn-images-1.medium.com/max/1600/0*-UCHfo1lxUdWUKAD.)





它会解析出列在你的 manifest 清单文件的 favicons（网站头像），还能预览像是 start URL 和 theme colors 这样的属性。顺带一提，如果感兴趣的话，这里有一个完整的关于 Web App Manfests 的工具小贴士 [片段](https://www.youtube.com/watch?v=yQhFmPExcbs&index=11&list=PLNYkxOF6rcIB3ci6nwNyLYNU6RDOU3YyL) 😉

### 安装了的 web app 启动时会带自定义的闪屏画面

在旧版本的 Android Chrome 上，点击主屏幕上的 app 图标通常会花费 200 毫秒（一些慢的网站甚至要数秒）以到达文档的第一帧被渲染到屏幕上。

在这段时间内，用户会看到一个白屏，减少对你网站的感知到的性能。Chrome 47 和以上版本 [支持自定义闪屏](https://developers.google.com/web/updates/2015/10/splashscreen?hl=en)（基于来自 Web App manifest 的背景颜色，名字和图标）会在浏览器准备绘制一些东西前给屏幕一些颜色。这使得你的 webapp 感受上更接近 “原生”。









![](https://cdn-images-1.medium.com/max/1600/0*sQHn9k-t--cNcijL.)





[Realfavicongenerator.net](http://realfavicongenerator.net/) 现在还支持根据你的清单（manifest）预览并自定义闪屏，很方便地节约时间。

**注意：Firefox for Android 和 Opera for Android 也支持 Web 应用程序清单，闪屏和添加到主屏幕的体验。在 iOS 上，Safari 也支持自定义添加到 [主屏幕的图标](https://developer.apple.com/library/ios/documentation/AppleApplications/Reference/SafariWebContent/ConfiguringWebApplications/ConfiguringWebApplications.html) 并曾经支持一个 [专有的闪屏](https://gist.github.com/tfausak/2222823) 实现，然而这个在 iOS9 上显得不能用了。我已经填了一个特性请求给 Webkit，以支持 Web App manifest，所以...希望一切顺利吧。**

### 设计是移动友好的

为多种设备所优化的 Apps 必须在他们的 document 里面包括一个  [meta-viewport](https://developers.google.com/web/fundamentals/design-and-ui/responsive/fundamentals/set-the-viewport?hl=en)。这看上去非常明显，但是我看到过很多的 React 项目中，人们忘了加上这个。好在 [create-react-app](https://github.com/facebookincubator/create-react-app/blob/master/packages/react-scripts/template/public/index.html#L5) 有默认加上有效的 meta-viewport，而且如果缺失的话 Lighthouse 会标记上：



尽管我们非常重视渐进式 Web 应用程序在移动 web 的体验，这 [并不意味着桌面应该被忘记](https://www.justinribeiro.com/chronicle/2016/09/10/desktop-pwa-bring-the-goodness/)。一个精心设计的 PWA 应该可以在各种 viewport 尺寸、浏览器以及设备上良好运作，正如 Housing.com 所展示的：













![](https://cdn-images-1.medium.com/max/2000/0*bgAmcKHWLB_DxiRC.)









在系列第 2 部分，我们将会看看那 [**使用 React 和 Webpack 的页面加载性能**](https://medium.com/@addyosmani/progressive-web-apps-with-react-js-part-2-page-load-performance-33b932d97cf2#.9ebqqaw8k)。我们会深入 code-splitting（代码分割），基于路由的 chunking（分块）以及 达到更快交互性 PRPL 模式。

如果你不熟悉 React，我发现 Wes Bos 写的 [给新手的 React](https://goo.gl/G1WGxU) 很棒。

_感谢 Gray Norton, Sean Larkin, Sunil Pai, Max Stoiber, Simon Boudrias, Kyle Mathews 和 Owen Campbell-Moore 的校对_
