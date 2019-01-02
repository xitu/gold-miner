> * 原文地址：[How we made Carousell’s mobile web experience 3x faster](https://medium.com/carousell-insider/how-we-made-carousells-mobile-web-experience-3x-faster-bbb3be93e006)
> * 原文作者：[Stacey Tay](https://medium.com/@staceytay?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-we-made-carousells-mobile-web-experience-3x-faster.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-we-made-carousells-mobile-web-experience-3x-faster.md)
> * 译者：[Noah Gao](https://noahgao.net)
> * 校对者：[kyrieliu](https://kyrieliu.cn), [Moonliujk](https://github.com/Moonliujk)

# 我们是怎样把 Carousell 的移动端 Web 体验搞快了 3 倍的？

## 回顾一下我们构建 Progressive Web App 的 6 个月

[Carousell](https://careers.carousell.com/about/) 是一个在新加坡开发的移动分类广告市场，并在包括印度尼西亚、马来西亚和菲律宾在内的许多东南亚国家开展业务。我们在今年年初为一批用户推出了我们移动 Web 端的[渐进式网页应用（PWA）](https://developers.google.com/web/progressive-web-apps/)] 版本。

在本文中，我们将分享 (1) 我们想要建立更快的 Web 端体验的动机，(2) 我们怎么完成它，(3) 它对我们用户的影响，以及 (4) 是什么帮助了我们快速完成。

![](https://cdn-images-1.medium.com/max/1000/1*q1lHcvKCppZvyd4OIFr3Rw.png)

🖼 这个 PWA 在 [https://mobile.carousell.com](https://mobile.carousell.com) 🔎

#### 为什么一定要有更快的 Web 体验？

我们的应用是为新加坡市场开发的，我们已经习惯于用户拥有高于平均水平的手机和高速的互联网。然而，随着我们扩展到整个东南亚地区的更多国家，如印度尼西亚和菲律宾，我们面临着提供同样令人愉快和快速的网络体验的挑战。原因是，在这些地方，[较一般的终端设备](https://building.calibreapp.com/beyond-the-bubble-real-world-performance-9c991dcd5342) 和 [互联网速度](https://en.wikipedia.org/wiki/List_of_countries_by_Internet_connection_speeds) 与我们的应用设计标准相比，往往速度慢并且不太可靠。

我们开始阅读更多有关性能的内容，并开始使用 [Lighthouse](https://developers.google.com/web/tools/lighthouse/) 重新审视我们的应用，我们意识到 [如果我们想要在这些新的市场中成长](https://en.wikipedia.org/wiki/List_of_countries_by_Internet_connection_speeds)，[我们需要更快的 Web 体验](https://developers.google.com/web/fundamentals/performance/why-performance-matters/)。 **如果我们想要获取或是留住我们的用户，那么一个网页在 3G 网络下（跟我们一样）需要加载超过 15 秒就是不能接受的了。**

![](https://cdn-images-1.medium.com/max/800/1*1AUcHKLx6hNwnbTKsV9O3w.png)

🌩 Lighthouse 的性能表现得分会是一个很好的叫醒服务～ 🏠

Web 端通常是我们的新用户发现和了解 Carousell 的入口。**我们想从一开始就给他们一个愉快的体验，因为 [性能就是用户体验](http://designingforperformance.com/performance-is-ux/)。**

为此，我们设计完成了一种全新的，性能优先的 Web 端体验。当我们决定首先使用哪些页面做尝试时，我们选择了产品列表页面和主页，因为 Google Analytics 的统计表明这些页面的自然流量最大。

* * *

### 我们怎么做到的

#### 从现实世界中的性能预算开始

我们做的第一件事就是起草性能预算，以避免犯下未经检查的臃肿问题（我们之前的 Web 应用中的一个问题）。

> 性能预算让每个人都在同一个“页面”上。它们有助于创造一种共享热情的文化，以改善用户体验。具有预算的团队还可以更轻松地跟踪和绘制进度。这有助于支持那些拥有有意义的指标的执行发起人，指明正在进行的投入的合理性。

> — [你能负担得起吗？：现实世界中的网络性能预算](https://infrequently.org/2017/10/can-you-afford-it-real-world-web-performance-budgets/).

由于 [在加载过程中存在多个时刻，都会影响到用户对这个页面是否“足够快”的感知](https://developers.google.com/web/fundamentals/performance/user-centric-performance-metrics)，我们将预算基于一套组合的指标。

> 加载网页就像一个有三个关键时刻的电影胶片。三个时刻分别是：它发生了吗？它有用吗？然后，它能用起来吗？

> — [2018 年里 JavaScript 的花费](https://medium.com/@addyosmani/the-cost-of-javascript-in-2018-7d8950fbb5d4)

我们决定为关键路径的资源设置 120 KB 的上限，在所有页面上还有一个 2 秒的 [**首屏内容渲染**](https://developers.google.com/web/fundamentals/performance/user-centric-performance-metrics#first_paint_and_first_contentful_paint) 和 5 秒的 [**可交互时间**](https://developers.google.com/web/fundamentals/performance/user-centric-performance-metrics#time_to_interactive) 限制。这些数字和指标都是基于 Alex Russell 的一篇发人深省的文章 [真实世界的 Web 性能预算](https://infrequently.org/2017/10/can-you-afford-it-real-world-web-performance-budgets/) 以及 Google [以用户为中心的性能指标]。

```
关键路径资源          120KB
首屏内容渲染          2s
可交互时间            5s
Lighthouse 性能得分  > 85
```

🔼 我们的性能预算 🌟

为了能把性能预算坚持下去，我们在一开始选择库时就十分慎重，包括 react、react-router、redux、redux-saga 和 [unfetch](https://github.com/developit/unfetch)。

我们还整合了 [bundlesize](https://github.com/siddharthkp/bundlesize) 到我们的 PR 流程当中，用来执行我们在关键路径资源上的性能预算方案。

![](https://cdn-images-1.medium.com/max/800/1*PKGjihs6JorbhLbygpTNjA.png)

⚠️ bundlesize 阻止了一个超出预算的 PR 🚫

理想情况下，我们也会自动检查 **首屏渲染时间** 和 **可交互时间** 指标。但是，我们目前还没有这样做，因为我们想先发布初始页面。我们认为我们可以通过我们的小团队规模来避免这种情况，每周通过我们的 Lighthouse 审核我们的发布，以确保我们的变更在预算范围内。

在我们积压的工作中，下一步就是自建性能监控框架。

### 我们如何让它（看起来）变快了

1.  **我们采用了一部分** [**PRPL 模式**](https://developers.google.com/web/fundamentals/performance/prpl-pattern/)**。**我们为每个页面请求发送最少量的资源（使用 [基于路由的代码拆分](https://github.com/jamiebuilds/react-loadable)），并 [使用 Workbox 预先缓存应用程序包的其余部分](https://developers.google.com/web/tools/workbox/modules/workbox-precaching)。我们还拆分了不必要的组件。例如，如果用户已登录，则应用程序将不会加载登录和注册组件。目前，我们仍然在几个方面偏离了 PRPL 模式。首先，由于我们没有时间重新设计的旧页面，该应用程序有多个应用程序外壳。其次，我们还没有探索为不同的浏览器生成单独的构建打包。

2.  **内联的 [关键的 CSS](https://developers.google.com/speed/docs/insights/OptimizeCSSDelivery)。** 我们使用 [webpack 的 mini-css-extract-plugin](https://github.com/webpack-contrib/mini-css-extract-plugin) 来提取并内联的方式引入对应页面的关键 CSS，以优化首屏渲染时间。这样就给用户提供了 [**一些事情** 正在发生](https://developers.google.com/web/fundamentals/performance/user-centric-performance-metrics#user-centric_performance_metrics) 的感觉。

3.  **懒加载视口外的图像。** 并且逐步加载它们。我们创建了一个滚动观察组件，其基于 [react-lazyload](https://github.com/jasonslyvia/react-lazyload)，它会监听 [滚动事件](https://developer.mozilla.org/en-US/docs/Web/Events/scroll)，一旦计算出图像在视口内，就开始加载图像。

4.  **压缩所有的图像来减少在网络中传输的数据量。** 这将在我们的 CDN 提供商的 [自动化图像压缩](https://blog.cloudflare.com/introducing-polish-automatic-image-optimizati/) 服务中进行。如果你不使用 CDN，或者只是对图像的性能问题感到好奇，Addy Osmani 有一个 [关于如何自动进行图像优化的指南](https://images.guide)。

5.  **使用 Service Worker 来缓存网络请求。**这减少了数据不会经常变化的 API 的数据使用量，并改善了应用程序后续的访问加载时间。我们找到了 [The Offline Cookbook](https://developers.google.com/web/fundamentals/instant-and-offline/offline-cookbook/) 来帮助我们决定采用哪种缓存策略。直到我们有了多了应用外壳，Workbox 默认的 [`registerNavigationRoute`](https://developers.google.com/web/tools/workbox/modules/workbox-routing#how_to_register_a_navigation_route) 并不适用于我们的实际场景，所以我们不得补自行完成一个 handler 来匹配当前应用外壳的导航请求。

```
workbox.navigationPreload.enable();

// From https://hacks.mozilla.org/2016/10/offline-strategies-come-to-the-service-worker-cookbook/.
function fetchWithTimeout(request, timeoutSeconds) {
  return new Promise((resolve, reject) => {
    const timeoutID = setTimeout(reject, timeoutSeconds * 1000);
    fetch(request).then(response => {
      clearTimeout(timeoutID);
      resolve(response);
    }, reject);
  });
}

const networkTimeoutSeconds = 3;
const routes = [
  { name: "collection", path: "/categories/.*/?$" },
  { name: "home", path: "/$" },
  { name: "listing", path: "/p/.*\\d+/?$" },
  { name: "listingComments", path: "/p/.*\\d+/comments/?$" },
  { name: "listingPhotos", path: "/p/.*\\d+/photos/?$" },
];

for (const route of routes) {
  workbox.routing.registerRoute(
    new workbox.routing.NavigationRoute(
      ({ event }) => {
        return caches.open("app-shells").then(cache => {
          return cache.match(route.name).then(response => {
            return (response
              ? fetchWithTimeout(event.request, networkTimeoutSeconds)
              : fetch(event.request)
            )
              .then(networkResponse => {
                cache.put(route.name, networkResponse.clone());
                return networkResponse;
              })
              .catch(error => {
                return response;
              });
          });
        });
      },
      {
        whitelist: [new RegExp(route.path)],
      },
    ),
  );
}
```

⚙️ 我们对所有的应用外壳采用了一个超时时间为 3 秒的网络优先策略 🐚

在这些变化中，我们严重依赖 Chrome 的“中端移动设备”模拟功能（即网络限制为 3G 速度），并创建了多个 Lighthouse 审计来评估我们工作的影响。

### 结果：我们怎么做到的

![](https://cdn-images-1.medium.com/max/1000/1*uTOxbHdmHLG6UsVaAj4Dig.jpeg)

🎉 比较之前和之后的移动 Web 指标 🎉

我们新的 PWA 列表页面的加载速度比我们旧的列表页面 **快 3 倍**。在发布这一新页面之后，我们的印度尼西亚的自然流量与我们所有长时间的周相比，增长了 63％。在 3 周的时间内，我们还看到，广告点击率 **增加了 3 倍**，在列表页面上发起聊天的匿名用户 **增加了 46％**。

![](https://cdn-images-1.medium.com/max/800/1*6ql8gjD3IKSITGfyQZCZuA.gif)

⏮ [在较快的 3G 网络下的 Nexus 5 上，我们列表页面的前后对比](https://www.webpagetest.org/video/compare.php?tests=171020_B8_97732ed88ebc522d6a042f0ad502ccd4,181009_HJ_07aee97a8bbe626fee8b11a3c5661980)。更新：[WebPageTest 对这个页面的简单报告](https://www.webpagetest.org/result/181031_XQ_e4603b6421fc22743c5790f34abcc4e2/)。 ⏭

* * *

### 快速，自信地迭代

#### 一致的 Carousell 设计系统

在我们开展这项工作的同时，我们的设计团队也在同时创建标准化设计系统。由于我们的 PWA 是一个新项目，我们有机会根据设计系统创建一组标准化的 UI 组件和 CSS 常量。

拥有一致的设计使我们能够快速迭代。每个 UI 组件**我们只构建一次，然后在多个地方复用它**。例如，我们有一个 `ListingCardList` 组件，它显示列表卡片的提要并触发回调，以便在滚动到结尾时提示其父组件加载更多列表。我们在主页，列表页面，搜索页面和个人信息页面中使用了它。

我们还与设计师合作，一起确定应用程序设计中的适当性能权衡。这使我们能够维持我们的性能预算，改变一些旧设计以符合新设计，并且，如果它们太昂贵了的话，就放弃花哨的动画。

#### 与 Flow 同行

我们选择将 [Flow](https://flow.org) 类型定义作为我们所有文件的必选项，因为我们想减少烦人的空值或类型问题（我也是渐进类型的忠实粉丝，但为什么我们选择了 Flow 而不是 [TypeScript](https://www.typescriptlang.org) 就是下一次的一个话题了）。

在我们开发和创建了更多代码时，采用了 Flow 的选择被证明非常有用。它让我们有信心添加或更改代码，将核心代码重构得更加简单和安全。这使我们能够快速迭代而不会破坏事物。

此外，Flow 类型也对我们的 API 约定和共享库组件的文档非常有用。

对于强制将 Redux 操作和 React 组件的类型写出来这件事情，还有一个额外的好处，就是它会帮助我们仔细思考如何设计我们的 API。它也提供了与团队开始早期的 PR 讨论的简单途径。

* * *

### 小结

我们创建了一个轻量级的 PWA 来为我们具有不可靠网速的用户提供服务，一个页面接一个页面地发布，提高了我们的商业指标**和**用户体验。

#### 是什么帮助我们保持足够快的速度

*   拥有并坚持一份性能预算
*   降低关键渲染路径到最小
*   经常使用 Lighthouse 进行审计

#### 是什么帮助我们快速迭代

*   拥有标准化的设计系统及其相应的 UI 组件库
*   拥有完全类型化的代码库

### 结束思考

回顾过去两个季度我们所做的事情，我们为我们新的移动 Web 业务体验感到无比自豪，我们正在努力使其变得更好。这是我们第一个专注于速度的平台，也更多的思考了一个页面的加载过程。我们的 PWA 对业务和用户指标的改进有助于说服公司内部更多人去了解应用程序性能和加载时间的重要性。

我们希望本文能够启发您在设计和构建 Web 体验时考虑性能。

**在此为参与这个项目的人欢呼：Trong Nhan Bui、Hui Yi Chia、Diona Lin、Yi Jun Tao 和 Marvin Chin。当然也要感谢 Google，特别是要感谢 Swetha and Minh 对这个项目的建议。**

**感谢 Bui、[Danielle Joy](https://medium.com/@xdaniejoyy)、[Hui Yi](https://medium.com/@c_huiyi)、[Jingwen Chen](https://medium.com/@jin_)、[See Yishu](https://medium.com/@yishu) 和 [Yao Hui Chua](https://medium.com/@yaohuichua) 的写作和校对。**

最后，多亏了 [Hui Yi](https://medium.com/@c_huiyi?source=post_page)、[Yao Hui Chua](https://medium.com/@yaohuichua?source=post_page)、[Danielle Joy](https://medium.com/@xdaniejoyy?source=post_page)、[Jingwen Chen](https://medium.com/@jin_?source=post_page) 和 [See Yishu](https://medium.com/@yishu?source=post_page)。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
