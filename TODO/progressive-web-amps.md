* 原文地址：[ Progressive Web AMPs ](https://www.smashingmagazine.com/2016/12/progressive-web-amps/)
* 原文作者：[ Paul Bakaus ]( https://www.smashingmagazine.com/author/paulbakaus/)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[L9m](https://github.com/L9m)
* 校对者：[marcmoore](https://github.com/marcmoore)，[sqrthree](https://github.com/sqrthree)

#  渐进增强的 Web 体验（Progressive Web AMP）

如果你最近几个月一直关注着 Web 开发社区，可能你对[渐进增强的 Web 应用](https://www.smashingmagazine.com/2016/08/a-beginners-guide-to-progressive-web-apps/)（Progressive Web App 简称 PWA）已有所了解。它是应用体验能与原生应用媲美的 Web 应用的统称：[不依赖网络连接](https://www.smashingmagazine.com/2016/02/making-a-service-worker/)，[易安装](https://developers.google.com/web/fundamentals/engage-and-retain/app-install-banners/?hl=en)，支持视网膜屏幕，支持无边距图像，支持登录和个性化，快速且流畅的应用体验，支持推送通并且有一个好看的界面。

![从谷歌的 Advanced Mobile Page（AMP）到渐进式 Web 应用](https://www.smashingmagazine.com/wp-content/uploads/2016/12/progressive-web-amp-2.png)


一些 Google 的渐进式 Web 应用示例。

虽然新的 [Service Worker API](https://developers.google.com/web/fundamentals/primers/service-worker/) 允许离线缓存所有的网站资源以便在**后续**加载中瞬时加载，就像陌生人的第一印象很关键一样。最新的 [DoubleClick 研究](https://www.doubleclickbygoogle.com/articles/mobile-speed-matters/) （译者注：DoubleClick 是谷歌旗下一家公司）表明，如果首次加载超过 3 秒，超过 53% 的用户将放弃访问。

老实说，3 秒已是一个相当**严峻**的目标。移动端连接通常有平均 300ms 延迟，而且附带有带宽限制和时不时信号弱等不利情况，你可能只剩下不到 1 秒时间留给应用初始化等事情。

![From Google’s Advanced Mobile Pages (AMP) to progressive web apps](https://www.smashingmagazine.com/wp-content/uploads/2016/12/progressive-web-amp-7.png)

用户和内容之间的延迟。

当然，有一些方法能[缓解](https://codelabs.developers.google.com/codelabs/your-first-pwapp/#4)首次加载缓慢的问题 — 在服务器上预先渲染好一个基础结构，再懒加载各个功能模块等等 — 但是使用此种策略达到的优化程度也有限，而且不得不雇佣一个前端优化专家，或者自己成长为一个专家。

那么，我们有什么方法来做一个从根本上和原生应用不同的首次瞬时加载呢？

### AMP，为移动页面加速

网站的最重要的优势之一是跨平台 — 无需安装和即刻加载，用户通常只需轻击一下鼠标即可。

要想轻松地从短浏览（ephemeral browsing）的机会中收益，所需的就是一个瞬时加载（crazy-fast-loading）的网站。让网站瞬时加载，你需要做些什么呢？你所需做的只是一个适当的节制：没有兆字节大小图片，阻塞渲染的广告，没有十万行 JavaScript，就只有这些要求。

[AMPs](https://www.ampproject.org/)，是加速移动网页（Accelerated Mobile Pages）的简称，它[擅长于此](https://www.ampproject.org/docs/get_started/technical_overview.html)，实际上，这是它们**存在的原因**（raison d’être）。它就像一个驾驶辅助功能，通过实行一套合理的规则，优化你的网页主体内容，让它们处于快车道。并通过创建这种严格的，[静态的](https://www.ampproject.org/docs/get_started/technical_overview.html#size-all-resources-statically)布局环境，使譬如谷歌搜索等平台[仅预渲染首屏](https://www.ampproject.org/docs/get_started/technical_overview.html#load-pages-in-an-instant)，得以进一步接近“瞬时”。

![From Google’s Advanced Mobile Pages (AMP) to progressive web apps](https://www.smashingmagazine.com/wp-content/uploads/2016/12/progressive-web-amp-0.png)

此 AMP 的首屏横幅图片（hero image）和标题将被提前渲染，以便访问者瞬时看到首屏内容。

### AMP 还是 PWA？

AMP 可靠快速的体验，在实现时也伴随着一些限制。当你需要高度动态的功能时，AMP 是不适用的，譬如推送通知、网络支付和依靠额外 JavaScript 的功能。此外，因为 AMP 页面通常从 AMP 缓存中提供，你的 Service Worker 不能运行，首次访问享受不到渐进式 Web 应用的最重要的好处。另一方面，在首次访问的速度上，渐进式 Web 应用永远不及 AMP，因为平台能顺利且毫不费力地预渲染 AMP 页面 — 内嵌更简单（比如在内嵌浏览器中）。

![From Google’s Advanced Mobile Pages (AMP) to progressive web apps](https://www.smashingmagazine.com/wp-content/uploads/2016/12/progressive-web-amp-8.png)

一旦用户点击内部链接，离开 AMP 缓存，你就能通过安装 service worker 来增强网站，让网站支持离线和更多的功能。

那么，是 AMP 还是渐进式 Web 应用？瞬时交付还是优化交付，或是最先进的平台功能和灵活的应用代码？有没有一种结合两者的好处的方式呢？

### 完美的用户旅程(User Journey)
终究，重要的是针对**用户旅程**的理想体验。它大概是这样的：

1.  用户发现了一个指向你的内容的链接，并且点击了它。
2.  内容快速加载是一种愉快的体验。
3.  用户被通知并进阶到有推送通知和支持离线的更流畅的体验。
4.  立即重定向到一个类原生的体验，并且可将网站放在你的主屏幕上。用户惊呼：“怎么回事？好神奇！”。

访问网站的第一步应该让人感觉快速，其后的浏览体验应该越来越引人入胜。

听起来是不是好的难以置信？好吧，尽管乍看，它们解决不同的问题且不相关，要是我们**结合两种技术**会怎么样呢？

### PWAMP 结合模式
要获得瞬时加载，渐进增强的体验，你所需做的是将 AMPs 和渐进式 Web 应用的丰富功能用下列之一（或多）的方式相结合：

- **AMP 作为 PWA**
当你可以接受 AMP 的限制时。

- **AMP 转作 PWA**
当你想要在两者之间平滑过渡时。

- **AMP 在 PWA 中**
当你重用 AMP 为 PWA 的数据源时。

让我们每个都过一遍吧。

#### AMP 作为 PWA
许多网站其实用不到超出 AMP（功能）范围。[Amp by Example](https://ampbyexample.com/) 就是一个例子，它既是 AMP 也是一个渐进式 Web 应用。
- 它有 service worker，因此允许包括离线访问等在内的其他功能。
- 它有清单（manifest），在横幅（banner）上会提醒“添加到主屏幕“。

当用户从谷歌搜索访问 [Amp by Example](https://ampbyexample.com/)，然后点击网站上链接，它们将从 AMP 缓存页面转到源页面上。当然，网站仍在使用 AMP 库，但是现在由于它处于源页面上，它能使用 service worker 或提示安装等等。

你可以使用此项技术让你的 AMP 网站支持离线访问，一旦他们访问源页面就进行扩展，因为你可以通过 service worker 的 `fetch` 事件来修改响应（response），并返回你想要的响应 （response）。

```
function createCompleteResponse (header, body) {

  return Promise.all([
    header.text(),
    getTemplate(RANDOM STUFF AMP DOESN’T LIKE),
    body.text()
  ]).then(html => {
    return new Response(html[0] + html[1] + html[2], {
      headers: {
        'Content-Type': 'text/html'
      }
    });
  });

}
```

这一技术也允许你在 AMP 后续访问中插入脚本，提供超出 AMP 范围外的更进阶的功能。

#### AMP 转作 PWA

当上述不能满足，并且你想让内容有一个完全不同的 PWA 体验时，是时候用一种更高级一点的模式了：
- 为了接近瞬时加载的体验，所有内容“叶”页（指有特定内容，不是概述的页面）被发布成 AMP。
- 这些 AMP 使用 AMP 的特殊元素 [`<amp-install-serviceworker>`](https://www.ampproject.org/docs/reference/extended/amp-install-serviceworker.html) 来预备缓存，并且**当用户喜欢**你的内容时用 PWA 的外壳。
- 当用户点击你网站上的另一个链接（比如，在底部的行为召唤（按钮），使其更像原生）service worker 拦截请求并接管页面，然后加载 PWA 外壳替代之。

假如你熟悉 service worker 的运作，你可以通过以上三个简单步骤来实现这种体验。（如果你不清楚的话，强烈推荐我的同事[杰克在优达学城（Udacity）上的课程](https://www.udacity.com/course/offline-web-applications--ud899)）。第一步，在你所有的 AMP 上放置 service worker。
```
<amp-install-serviceworker
      src="https://www.your-domain.com/serviceworker.js"
      layout="nodisplay">
</amp-install-serviceworker>
```

第二步，在 service worker 安装过程中，缓存 PWA 所需的所有资源。
```
var CACHE_NAME = 'my-site-cache-v1';
var urlsToCache = [
  '/',
  '/styles/main.css',
  '/script/main.js'
];

self.addEventListener('install', function(event) {
  // Perform install steps
  event.waitUntil(
    caches.open(CACHE_NAME)
      .then(function(cache) {
        console.log('Opened cache');
        return cache.addAll(urlsToCache);
      })
  );
});
```

最后，又回到 service worker，拦截 AMP 的导航请求，用 PWA 替代响应。（下面的代码是功能简化版本，后面还有一个更进阶的示例。）
```
self.addEventListener('fetch', event => {
    if (event.request.mode === 'navigate') {
      event.respondWith(fetch('/pwa'));

      // Immediately start downloading the actual resource.
      fetch(event.request.url);
    }
});
```

现在，每当用户点击从 AMP 缓存页面上的链接，service worker 注册 `navigate` 请求模式（request mode）并接管，然后用已缓存的成熟（full-brown）的 PWA 代替。

![From Google’s Advanced Mobile Pages (AMP) to progressive web apps](https://www.smashingmagazine.com/wp-content/uploads/2016/12/progressive-web-amp-6.png)

你可以通过在网站上安装一些 service worker 来实现渐进增强。对于不支持 service worker 的浏览器，它们仅会转移到 AMP 缓存页面。

此项技术很有意思之处在于从 AMP 渐进增强到 PWA。然而，这也意味着，暂时不支持 service worker 的浏览器将从 AMP 跳到 AMP 并且不会导航到 PWA。

AMP 通过 [Shell URL 重写](https://www.ampproject.org/docs/reference/components/amp-install-serviceworker#shell-url-rewrite) 来跳转。通过在 `<amp-install-serviceworker>` 标签中添加一个备用 URL 模式（URL pattern），如果检测到不支持 service worker，就指示 AMP 重写特定页面上所有匹配的链接，用另一个传统的 shell URL 替代（外壳（Shell）是应用的用户界面所需的最基本的 HTML、CSS 和 JavaScript，也是一个用来确保应用有好多性能的组件。它的首次加载将会非常快，加载后立刻被缓存下来。这意味着应用的外壳不需要每次使用时都被下载，而是只加载需要的数据。 ）： 

```
<amp-install-serviceworker
      src="https://www.your-domain.com/serviceworker.js"
      layout="nodisplay"
      data-no-service-worker-fallback-url-match=".*"
      data-no-service-worker-fallback-shell-url="https://www.your-domain.com/pwa">
</amp-install-serviceworker>
```

在有 service worker 的情况下具有了这些属性，AMP 上所有后续点击都将转到 PWA。挺巧妙的，是吧？

#### AMP 在 PWA 中
那么，现在用户处于渐进式 Web 应用中，你可能会使用一些 AJAX 驱动（AJAX-driven）的导航，通过 JSON 来获取内容。你当然可以这么做，但是现在有两个完全不同的内容后端和基础架构需求 — 一个生成 AMP 页面，另外一个为你的渐进式 Web 应用提供基于 JSON 格式的接口。

但请想一想 AMP 的本质是什么。它不只是一个网站，它被设计成一个超轻便的内容单元。AMP 是独立的且可以顺利地嵌入到其他网站。我们是否可以抛弃 JSON 接口，使用 AMP 作为我们渐进式 Web 应用的数据格式，从而大大降低后端复杂性呢？

![From Google’s Advanced Mobile Pages (AMP) to progressive web apps](https://www.smashingmagazine.com/wp-content/uploads/2016/12/progressive-web-amp-3.png)

AMP 页面能顺利地嵌入其他网站中 — PWA 的 AMP 库只会编译并加载一次。

当然，一个简单的方法是在 frames 中加载 AMP 页面。但是使用 iframes 比较慢，并且需要你一遍又一遍地重新编译和初始化 AMP 库。现在前沿的 Web 技术提供了一种更好的方式：Shadow DOM。

处理过程看起来是这样的：
1. PWA 操纵所有的导航点击事件。
2. 然后，用 XMLHttpRequest 获取请求的 AMP 页面。
3. 将内容放入一个新的 shadow root 中。
4. 然后返回给主 AMP 库，“嘿，我有一个新文档给你。请查收！”（在运行时调用 `attachShadowDoc`）。

使用此种技术，整个 PWA 只会编译和加载一次 AMP 库，并且然后，因为你是通过 XMLHttpRequest 获取的页面，你能在 AMP 源插入新的 shadow document 之前进行一些修改，你可以像这样做：
- 去掉不必要的内容，比如页眉（header）和页脚（footer）;
- 插入额外的内容，比如令人反感的广告或信息提示；
- 用更动态的内容替换特定内容。

现在，你使你的渐进式 Web 应用更简单了，而且大大简化了后端结构。

### 准备，配置，实行！

AMP 团队做了一个[名为 The Scenic 的 React 示例](https://choumx.github.io/amp-pwa/) 来演示 shadom DOM 方法（也就是：PWA 中的 AMP），它是一本假的旅行杂志：
![From Google’s Advanced Mobile Pages (AMP) to progressive web apps](https://www.smashingmagazine.com/wp-content/uploads/2016/12/progressive-web-amp-4.png)

 [整个示例](https://github.com/ampproject/amp-publisher-sample/blob/master/amp-pwa)的代码在 Github 上，但关键代码在 [React 组件 `amp-document.js`](https://github.com/ampproject/amp-publisher-sample/blob/master/amp-pwa/src/components/amp-document/amp-document.js#L92) 中。

#### 看点真东西

一个真实产品的例子是 [Mic 新式 PWA](https://beta.mic.com)（beta 阶段），研究一下 :如果你按住 shift 重新刷新（shift-reload）[任意文章](https://beta.mic.com/articles/161568/arrow-season-5-episode-9-a-major-character-returns-in-midseason-finale-maybe)（这样暂时忽略 service worker）查看源代码， 你会注意到这是一个 AMP 页面。现在尝试点击一下菜单：它会重新加载当前页面， 但由于 `<amp-install-serviceworker>` **已存在**于 PWA 应用外壳中，重载几乎是**瞬间**完成的，并且菜单在刷新后打开，使其看起来不像是重新加载过一样。但现在你处于拥有其他丰富功能的（内嵌 AMP 页面）PWA 中。狡猾，但很了不起。

### 结语

无需多说，我非常激动地憧憬着新结合的潜力。这个结合集两者之所长。

优点概括：
- 不论什么情况，都很快；
- 良好的内置支持（通过 AMP 的平台伙伴）；
- 渐进增强；
- 只需一种后端接口；
- 降低客户端复杂性；
- 成本低；

但是我们才开始发掘这种模式的变型，也是全新的一种。除提供构建 2016 最好的 Web 体验之外，继续向前到达 Web 的新篇章。
