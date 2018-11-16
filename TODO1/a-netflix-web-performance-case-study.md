> * 原文地址：[A Netflix Web Performance Case Study: Improving Time-To-Interactive for Netflix.com on Desktop](https://medium.com/dev-channel/a-netflix-web-performance-case-study-c0bcde26a9d9)
> * 原文作者：[Addy Osmani](https://medium.com/@addyosmani?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/a-netflix-web-performance-case-study.md](https://github.com/xitu/gold-miner/blob/master/TODO1/a-netflix-web-performance-case-study.md)
> * 译者：[子非](https://github.com/CoolRice)
> * 校对者：[Moonliujk](https://github.com/Moonliujk), [kyrieliu](https://kyrieliu.cn/)

# Netflix 的 Web 性能案例研究

## 为 Netflix.com 改进桌面端可交互时间

![](https://cdn-images-1.medium.com/max/2000/1*Pxmm24WKcYUqFC1Fsh_n7g.png)

**提纲：Web 性能优化没有银弹。简单的静态网页得益于使用极少 JavaScript 代码的服务端渲染。库的谨慎使用可以为复杂的页面带来巨大的价值**

[Netflix](https://netflix.com) 是最受欢迎的视频流服务之一。自 2016 年在全球推出以来，公司发现许多新用户不仅通过移动设备完成注册，而且还使用了不太理想的网络连接。

通过改进用于 Netflix.com 注册过程 JavaScript 代码和使用预加载技术，开发人员团队可以为移动和桌面用户提供更好的用户体验，并提供多项改进。

*   **减少 50% 的加载和可交互时间（适用于 Netflix.com 桌面端未登录的主页）**
*   **通过把 React 和其他客户端库改为原生的 JavaScript 使打包大小减少 200 KB。React 仍在服务端使用**
*   **为将来的操作预获取 HTML，CSS 和 JavaScript（React）使可交互时间减少 30%**

#### 通过嵌入更少的代码来减少可交互时间

Netflix 开发者优化性能的地方是未登录主页，用户在此页面注册并登录站点。

![](https://cdn-images-1.medium.com/max/800/1*T_bJaPmnB7Muy1Vw67CBqg.png)

新用户和已登出用户的 Netflix.com 主页

此页面初始包含 300 KB 的 JavaScript 代码，其中一些是 React 和其他客户端代码（例如像 Lodash 的工具库），而且还有一些是必要的上下文数据用来给 React 的状态注水（hydrate）。

所有 Netflix 的网页都由服务端 React 渲染，这些页面为生成的 HTML 和客户端应用提供服务，因此维持新优化的主页结构不变和保持开发人员体验的一致性同样重要。

![](https://cdn-images-1.medium.com/max/800/1*LaiM-eBWHnLloOpvbMggww.png)

Homepage 选项卡是最初使用 React 编写的组件的示例

使用 Chrome 的 DevTools 和 Lighthouse 来模拟 3G 网络下加载未登录主页，结果显示未登录主页需要 7 秒时间来加载，这段时间对于一个简单的入口页面来说实在是太久了，所以我们开始调查改进的可能性。通过一些性能审查，Netflix 发现他们的客户端 JS 有过高的[开销](https://medium.com/@addyosmani/the-cost-of-javascript-in-2018-7d8950fbb5d4)。

![](https://cdn-images-1.medium.com/max/800/1*9lGTXyeixVs7P1cBL1p7NA.png)

通过 Chrome DevTools 的网络限速功能，查看未优化的 Netflix.com 的表现。

通过关闭浏览器中的 JavaScript 来观察站点中仍在起作用的元素，开发者团队可以决定 React 在未登录主页是否真正必要。

由于页面中的多数元素是基本的 HTML，剩下的元素比如 JavaScript 点击处理和添加类可以用原生 JavaScript 来替换，而页面原来使用 React 实现的语言切换器则使用不到 300 行的原生 JavaScript 代码重构，

移植到原生 JavaScript 的组件完全列表：

*   基础交互（主页中的选项卡）
*   语言切换器
*   Cookie 横幅（针对非美国访问者）
*   分析用的客户端日志
*   性能评估和记录
*   广告来源引导代码（出于安全考虑，沙盒化放在 iframe 里）

![](https://cdn-images-1.medium.com/max/800/1*wBgSYuZmjbGP34BJiRSETw.jpeg)

虽然 React 的初始代码仅仅 45 KB，在客户端移除 React、一些库和相应的 App 代码**减少的 JavaScript 代码总量超多 200 KB**，由此在 Netflix 的未登录主页降低了超过 50% 的可交互时间。

![](https://cdn-images-1.medium.com/max/800/1*zd9QTVBtN2xmrZ94s4TYYA.jpeg)

**移除客户端 React、Lodash 和其他一些库前后的负载比较**

在[实验](https://developers.google.com/web/fundamentals/performance/speed-tools/#lab_data)环境下，我们可以使用 [Lighthouse](https://developers.google.com/web/tools/lighthouse/) （[trace](https://www.webpagetest.org/lighthouse.php?test=180822_M4_a5899bc8928b958d06902161c15b2c86&run=2)）快速测验用户是否能与 Netflix 主页交互。结果桌面端的 TTI 少于 3.5 s。


![](https://cdn-images-1.medium.com/max/800/1*xviETZh4IDKxT5x_k2u8cg.png)

可交互时间优化后的 Lighthouse 报告。

那么这个领域的度量标准呢？使用 [Chrome 用户体验报告](https://developers.google.com/web/tools/chrome-user-experience-report/)我们可以看到[首次输入延迟](https://developers.google.com/web/updates/2018/05/first-input-delay) —— 从用户首次与你的站点交互时间到浏览器真正响应那次交互的时间 —— 对于 97% 的 Netflix 桌面用户来说很[快](https://bigquery.cloud.google.com/savedquery/920398604589:1692b8e0bdc94d4883437d8712cbb83a)。结果非常棒。

![](https://cdn-images-1.medium.com/max/800/1*Gxkl5liyc-tI7Wh7UTtDlQ.png)

首先输入延迟（FID）度量用户在与页面交互时的延迟体验。

#### 为后续页面预加载 React

为了进一步提高浏览登录主页的性能，Netflix 利用用户在入口页面上花费的时间针对可能会登录的下一个页面进行资源**预加载**。

通过两项技术完成 —— 内置的 [`<link rel=prefetch>`](https://developer.mozilla.org/en-US/docs/Web/HTTP/Link_prefetching_FAQ) 浏览器 API 和 XHR 预加载。

内置的浏览器 API 包含页面头部标签内的简单链接标签。它会建议浏览器资源（例如 HTML、JS、CSS、图片）可以被预加载，虽然它并不保证浏览器真的**会**预加载资源，并且它缺少[其他浏览器](https://caniuse.com/#feat=link-rel-prefetch)的全面支持。

![](https://cdn-images-1.medium.com/max/800/1*TAv9_jZGqmX-aTJw5QDtRA.jpeg)

预加载技术对比

另一方面，XHR 预加载已经成为浏览器标准很多年了，当 Netflix 团队提示浏览器缓存资源时，其成功率达到 95%。但是 XHR 预加载不能预加载 HTML 文档，Netflix 用它来为后续页面预加载 JavaScript 和 CSS 打包文件。

注意：Netflix 配置的 HTTP 响应头禁止使用 XHR 缓存 HTML（它们确实不缓存（no-cache）第二个页面的 HTML）。链接预加载会按预期工作，因为它对 HTML 有效，即使设置了不缓存（no-cache）。

```
// 创建新的 XHR 请求
const xhrRequest = new XMLHttpRequest();

// open the request for the resource to "prefetch"
// 打开请求来“预加载”资源
xhrRequest.open('GET', '../bundle.js', true);

// 发送!
xhrRequest.send();
```

通过使用浏览器内置 API 和 XHR 预加载 HTML、CSS 和 JS，可交互时间减少了 30%。这个实现不需要重写 JavaScript，也不会对未登录主页的性能造成负面影响，而且从此以后，能以极低的风险为提升页面性能提供了非常有价值的工具。

![](https://cdn-images-1.medium.com/max/800/1*yusmoWBbhhfxDEv03OWPTQ.jpeg)

预加载实现之后，Netflix 开发者可以通过分析页面减少的可交互时间数据来观察性能提升效果，同样使用 Chrome 开发工具直接度量资源缓存的命中情况。

#### Netflix 未登录主页 —— 优化总结

通过预加载 Netflix 未登录主页资源和优化客户端代码，Netflix 可以在注册过程中出色地提升可交互时间指标。通过使用浏览器内置 API 和 XHR 预加载来预获取未来页面，Netflix 可以把可交互时间降低 30%。这是针对下一页面的加载， 其中包含单页应用注册过程的引导代码。

Netflix 团队进行的代码优化表明，React 是一个十分有用的库，不过它可能无法为每个问题提供足够的解决方案。通过从第一个用于注册的入口页面的客户端代码中删除 React，可交互时间减少了 50% 以上。缩短客户端上的可交互时间还可以让用户以更快地速度单击注册按钮，这表明代码优化完全可以带来更好的用户体验。

虽然 Netflix 没有在主页中使用 React，但他们为后续的页面预加载。这使得他们整个页面应用程序流程中的其他部分可以利用客户端 React。

更多关于这些优化的细节，请观看 Tony Edwards 的出色演讲：

* YouTube 视频链接：https://youtu.be/V8oTJ8OZ5S0

### 总结

通过密切关注 JavaScript 的开销，Netflix 发现了改善可交互时间的机会。若想发现你的站点是否有机会在这点上做得更好，可以借助你的[性能工具](https://developers.google.com/web/fundamentals/performance/speed-tools/)

Netflix 决定做出的权衡是使用 React 对入口页面进行服务器渲染，同时也在其上预先获取 React 和其余注册流程的代码。这样可以优化首次加载性能，同时还可以优化其余注册流的加载时间，因为它是一个单页应用程序，因此需要下载更大的 JS 打包文件。

考虑一下是否使用原生 JavaScript 是否适合你的站点的流程。如果你确实需要使用库，那么尝试只嵌入你的用户需要的代码。预加载技术可以帮助优化未来浏览页面的加载时间。

#### 补充说明：

*   Netflix 考虑过使用 [Preact](https://preactjs.com/)，但是，对于低交互性的简单页面流而言，使用原生 JavaScript 是一个更简单的选择。
*   Netflix 试验过使用 [Service Workers](https://developers.google.com/web/fundamentals/primers/service-workers/) 进行静态资源缓存。那时 Safari 不支持这个 API（现在支持了），但他们现在又在探索这个了。Netflix 的注册过程更多需要的是较旧的浏览器支持而不是会员体验。许多用户都会在较旧的浏览器上注册，但会在其原生移动应用或电视设备上观看 Netflix。
*   Netflix 的入口页面极为动态。这是他们的注册过程中进行 A/B 测试最多的页面，机器学习模型用于根据位置、设备类型和许多其他因素定制消息和图像。支持近 200 个国家，每个派生页面都面对着不同的本地化、法律和价值信息挑战。有关 A/B 测试的更多信息，请参阅 Ryan Burgess 的[测试，只为更好的用户体验](https://www.youtube.com/watch?v=TmhJN6rdm28)。

**感谢 Netflix UI 工程师，[Tony Edwards](https://twitter.com/tedwards947)，[Ryan Burgess](https://twitter.com/burgessdryan)，[Brian Holt](https://twitter.com/holtbt?lang=en)，[Jem Young](https://twitter.com/JemYoung?lang=en)，[Kristofer Baxter](https://twitter.com/kristoferbaxter)（Google），[Nicole Sullivan](https://twitter.com/stubbornella)（Chrome）和 [Houssein Djirdeh](https://twitter.com/hdjirdeh)（Chrome）的审阅和贡献。**

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
