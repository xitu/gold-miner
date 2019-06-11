> * 原文地址：[A Tinder Progressive Web App Performance Case Study](https://medium.com/@addyosmani/a-tinder-progressive-web-app-performance-case-study-78919d98ece0)
> * 原文作者：[Addy Osmani](https://medium.com/@addyosmani?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/a-tinder-progressive-web-app-performance-case-study.md](https://github.com/xitu/gold-miner/blob/master/TODO/a-tinder-progressive-web-app-performance-case-study.md)
> * 译者：[pot-code](https://github.com/pot-code)
> * 校对者：[zwwill](https://github.com/zwwill)

# PWA 实战：Tinder 的性能优化之道

![](https://cdn-images-1.medium.com/max/2000/1*j2n8zzLYxoum1ob-1mjUcw.png)

最近 Tinder 在 web 端发力，公布了 [PWA](https://developers.google.com/web/progressive-web-apps/)  应用 [Tinder Online](https://tinder.com) ，现已全平台支持。在技术实现上，为了应对 [JavaScript 性能优化问题](https://medium.com/dev-channel/the-cost-of-javascript-84009f51e99e) 采用了最前沿的技术，例如，使用 [Service Workers](https://developers.google.com/web/fundamentals/primers/service-workers/) 来应对网络弹性问题、使用 [消息推送（Push Notifications）](https://developers.google.com/web/fundamentals/push-notifications/) 来支撑聊天业务。本文将向各位讲解大佬们是如何处理开发中的性能优化问题的。

![](https://cdn-images-1.medium.com/max/1000/1*1HmfQhMAQL8kukiNtMZRjA.png)

### 开发历程

Tinder Online 肩负着打开新市场的使命，它背后的团队希望把它打造成一个全平台无缝体验的在线聊天平台。

**产品的 MVP 开发花了 3 个月，UI 库用了 [React](https://reactjs.com)，状态管理用的是 [Redux](https://redux.js.org)**。最后的成果还是显著的，在不影响功能体验的前提下，数据传输量减少到了原来的十分之一：

![](https://cdn-images-1.medium.com/max/1000/1*cqYbI-L0zukfYS0ZAwUtqA.png)

上图是 Tinder Online 和手机 app 在安装过程中所需数据量大小的比较，虽然这两个类型不同，但是还是具有参考意义的。 相对手机 app 来说，PWA 只有在需要时才加载新的代码。用户边使用边下载，因为下载过程分散在整个使用过程中，所以用户并不会察觉到。即使用户在使用中访问了应用的其他部分，综合下载量也还是少于直接下载整个 app 所需的数据量。

上线后的前期表现还是不错的，用户划一划频率、发信频率以及在线时长均优于在手机 app 上的表现。总之，使用 PWA 之后（针对 PWA 和原生的比较）：

* 用户划一划的频率变高了
* 用户的发信更频繁了
* 不影响用户买买买
* 用户更加卖力的经营自己的账户
* 用户在线时间更长了

### 性能表现

数据显示，手机端用户主要使用的设备包括但不限于：

* Apple iPhone & iPad
* Samsung Galaxy S8
* Samsung Galaxy S7
* Motorola Moto G4

再使用 [Chrome User Experience report](https://developers.google.com/web/tools/chrome-user-experience-report/) （简称 CrUX）进行分析，得知用户主要使用 4G 网络进行访问：

![](https://cdn-images-1.medium.com/max/1000/1*gO4n3kBs5Zy1eAkMQqxx7w.png)

**注：可以参考 Rick Viscomi 在 [PerfPlanet](https://calendar.perfplanet.com/2017/finding-your-competitive-edge-with-the-chrome-user-experience-report/) 上对 CrUX 的介绍，Inian Parameshwaran 介绍的 [rUXt](https://calendar.perfplanet.com/2017/introducing-ruxt-visualizing-real-user-experience-data-for-1-2-million-websites/) 在网络可视化分析这块针对大流量网站更具优势。**

在常用的 web 应用测试网站（[WebPageTest](https://www.webpagetest.org/result/171224_ZB_13cef955385ddc4cae8847f451db8403/) 和 [Lighthouse](https://github.com/GoogleChrome/lighthouse/)）上进行测试，使用 4G 网络的 Galaxy S7 可以在  **5秒内** 完全加载应用：

![](https://cdn-images-1.medium.com/max/1000/1*e-EHgbBBNXyuce8Z836Sgg.png)

相比高端机型，配置 [相对一般](https://www.webpagetest.org/lighthouse.php?test=171224_NP_f7a489992a86a83b892bf4b4da42819d&run=3) 的机型（例如 Moto G4）的性能表现还有很大的提升空间，这类机型的 CPU 资源比较吃紧：

![](https://cdn-images-1.medium.com/max/1000/1*VJ3ZbSQtIjxsIW8Feuiejw.png)

Tinder 现在也确实在针对这方面做优化，期待他们以后的表现。

### 性能优化

Tinder 为了加快页面的加载使用了很多技术，例如基于路由的代码分割、性能预算（performance budgets）以及静态资源持久缓存。

### 基于路由的代码分割

起初打包的文件非常巨大，严重拖慢了交互就绪的速度，对用户体验影响很大。因为打包的文件里包含了除核心交互以外的代码，这就需要使用 [代码分割（code-splitting）](https://webpack.js.org/guides/code-splitting/) **抽离出暂时不需要的代码，只保留核心功能。**

针对这个问题，Tinder 引入了 [React Router](https://reacttraining.com/react-router/) 和 [React Loadable](https://github.com/thejameskyle/react-loadable)。得益于前期架构的优势，整个应用非常适合使用基于配置的方式处理路由和渲染，因此，代码分割也能很顺利的在顶层上实现。

**小结：**

React Loadable 是 James Kyle 开发的一个轻型库，简化了 React 中基于组件的代码分割操作，它提供的 **Loadable** 函数是一个高阶（higher-order）组件（创建组件的函数），专门用于处理代码分割。

下面举例说明。假如有两个组件 “A” 和 “B”，分割前，它们和入口文件一并打包，因为这两个模块目前并不需要，所以这样全部打包在一起是很低效的：

![](https://cdn-images-1.medium.com/max/1000/1*DoTby4l_-A3TNdiUSZ0LmA.png)

这里要求使用代码分割之后，组件 A 和 B 只是在需要时才加载。为此，Tinder 引入了 React Loadable、[动态导入函数 import()](https://webpack.js.org/guides/code-splitting/#dynamic-imports) 以及 [webpack 神奇的注释语法](https://medium.com/faceyspacey/how-to-use-webpacks-new-magic-comment-feature-with-react-universal-component-ssr-a38fd3e296a) （用来为动态导入的模块命名）：

![](https://cdn-images-1.medium.com/max/1000/1*aPY-1uGEvPV1dNKrrD8z4Q.png)

在公共库（即 vendor）的处理上，Tinder 使用了 webpack 官方提供的 [**CommonsChunkPlugin**](https://webpack.js.org/plugins/commons-chunk-plugin/) 插件，把路由间公用的库单独打包到一个文件中，利用浏览器的缓存机制提升性能：

![](https://cdn-images-1.medium.com/max/1000/1*R-kXPcn937BNoFXLukPJPg.png)

接着使用 [React Loadable 提供的预加载功能](https://github.com/thejameskyle/react-loadable#loadablecomponentpreload) 针对那些/在接下来的交互中/存在潜在加载需求/的资源/做预加载处理（译者注：注意断句）：

![](https://cdn-images-1.medium.com/max/1000/1*G2JvbNCsm4eBXbGgyW6OmA.png)

Tinder 还用 [Service Workers](https://developers.google.com/web/fundamentals/primers/service-workers/) 对所有路由做了预缓存处理，其中就包括用户经常访问而没有做代码分割的路由。最后使用 UglifyJS 对代码进行压缩：

```javascript
new webpack.optimize.UglifyJsPlugin({
      parallel: true,
      compress: {
        warnings: false,
        screw_ie8: true
      },
      sourceMap: SHOULD_SOURCEMAP
    }),
```

#### 成果

使用代码分割后，打包文件大小从 166KB 减到 101KB，DOM 内容加载时间（DCL）也从 5.46s 降低到 4.69s：

![](https://cdn-images-1.medium.com/max/1000/1*1Tt8bnnkyIi8aEw0BjRgMw.png)

### 静态资源持久缓存

在 webpack 的输出中配置 [chunkhash]，一方面可以用来规避开发过程中因浏览器缓存而引发的资源不更新问题，二来也可以确保缓存有效。

![](https://cdn-images-1.medium.com/max/1000/1*nofQB3Q-8IUo9f1Eipd0xw.png)

由于 Tinder 使用了大量的第三方开源库，如果其中的一个依赖发生变化都会导致 [chunkhash] 的重新计算，从而导致之前的缓存失效。为了解决这个问题，Tinder 制定了一个 [外部依赖白名单](https://gist.github.com/tinder-rhsiao/89cd682c34d1e1307111b091801e6fe5]%28https://gist.github.com/tinder-rhsiao/89cd682c34d1e1307111b091801e6fe5)，另外还将 manifest 从主干中抽出，进一步改进缓存。最后，主干代码和 manifest 的打包大小都只有 160KB。

### 预加载潜在需求资源

这里用到了 [`<link rel=preload>`](https://developers.google.com/web/fundamentals/performance/resource-prioritization)，它告诉浏览器这是一个关键资源，马上要用到，需要尽早加载。在单页应用（SPA）中，这些资源可以是打包后的 JavaScript 文件。

![](https://cdn-images-1.medium.com/max/800/1*CaObLc_tGJvnllyV3CGD5w.png)

Tinder 将核心体验相关的资源文件进行了预加载处理，最终加载时间减少了 1s，首次绘制时间也从 1000ms 减少到 500ms。

![](https://cdn-images-1.medium.com/max/1000/1*AtzElAKy_pCvRjZN__YSsQ.png)

### 性能预算

为了达到移动端的性能期望，Tinder 引入了 **性能预算**。Alex Russell 在他发表过的一篇文章（[Can you afford it?: real-world performance budgets](https://infrequently.org/2017/10/can-you-afford-it-real-world-web-performance-budgets/)）中指出：难就难在要在网络环境不好、配置也一般的移动设备上提供良好的用户体验，因为提升空间非常有限。

为了保证应用能快速就绪，Tinder 规定公共依赖和主干代码的大小要维持在 155KB 左右，分配给异步加载（懒加载）的数据量大约 55KB 左右、其他部分代码 35KB 左右，CSS 则限制在 20KB 左右。 这个规划保证了最坏情况下的性能表现。

![](https://cdn-images-1.medium.com/max/1000/1*OgDLsMxsy6IO79NmjQtcng.png)

### Webpack 打包分析

开源工具 [Webpack Bundle Analyzer](https://github.com/webpack-contrib/webpack-bundle-analyzer) 可以对依赖进行可视化分析，暴露出那些明显的可优化问题。

![](https://cdn-images-1.medium.com/max/800/1*qsiUA0G50a4p3y2e4p7CyA.png)

Tinder 主要用它来分析以下几类优化问题：

* **Polyfills 代码占比：** 因为 Tinder 的目标平台包括了 IE11 和 Android 4.4，免不了使用一些 Polyfills，但是又不希望这些代码占据太多数据量，所以直接用了 [**babel-preset-env**](https://github.com/babel/babel-preset-env) 和 [**core-js**](https://github.com/zloirock/core-js)。
* **是否引入了不必要的第三方库：** 最后移除了 [localForage](https://github.com/localForage/localForage) ，使用 IndexedDB 作为替代。
* **分割方案是否最优：** 将首次绘制/交互中用不到的组件从主干代码中剔除。
* **是否可提炼复用代码：** 将子模块中使用超过三次的公共代码抽出成异步加载的代码块。
* **CSS：** 把 [critical CSS](https://www.smashingmagazine.com/2015/08/understanding-critical-css/) 从核心包中移除（转而使用服务器端渲染的方式）。

![](https://cdn-images-1.medium.com/max/800/1*ZL3i2BRHo8Sq_dv1NyA8Dw.png)

这个工具可以搭配 Webpack 的 [Lodash Module Replacement 插件](https://github.com/lodash/lodash-webpack-plugin) 使用。这个插件将模块中使用到的一些特定方法替换成实现上更简单、功能上等效的代码，从而减小打包文件大小：

![](https://cdn-images-1.medium.com/max/1000/1*of2Mv5ypTySRpTZQZVRj7A.png)

Webpack Bundle Analyzer 可以集成到 Webpack 的配置中。来自 Tinder 的配置参考：

```javascript
plugins: [
      new BundleAnalyzerPlugin({
        analyzerMode: 'server',
        analyzerPort: 8888,
        reportFilename: 'report.html',
        openAnalyzer: true,
        generateStatsFile: false,
        statsFilename: 'stats.json',
        statsOptions: null
      })
```

经过一系列优化之后，剩下的主要是主干部分代码。这些代码暂时就不用动了，除非架构发生变化。

### CSS 的优化策略

Tinder 使用 [Atomic CSS](https://acss.io/) 创建了许多高复用的 CSS 样式，其中一些做了内联处理，在初始化绘制过程中生效，剩下的则分散在外部 CSS 文件中（包括动画或者 base/reset 等样式）。关键样式（Critical styles）使用 gzip 压缩之后大小不超过 20KB，最近的一次构建则压缩到了 11KB 以下。

Tinder 还使用了 [CSS stats](http://cssstats.com/stats?url=https%253A%252F%252Ftinder.com&ua=Browser%2520Default%0A) 和 Google Analytics 跟踪每次发版的变化。在使用 Atomic CSS 前，页面的平均加载时间在 6.75s 左右，使用之后降到 5.75s 左右。

![](https://cdn-images-1.medium.com/max/1000/1*Uv_at6Xs7QYHZJ0iy8c7GQ.png)

最后用 [Autoprefixer](https://twitter.com/autoprefixer) 添加浏览器前缀：

```javascript
new webpack.LoaderOptionsPlugin({
    options: {
    context: paths.basePath,
    output: { path: './' },
    minimize: true,
    postcss: [
        autoprefixer({
        browsers: [
            'last 2 versions',
            'not ie < 11',
            'Safari >= 8'
        ]
        })
      ]
    }
}),
```

### 运行时性能

#### 使用 requestIdleCallback() 推迟非关键事务

使用 [requestIdleCallback()](https://developers.google.com/web/updates/2015/08/using-requestidlecallback) 将非关键事务推迟到空闲期运行，以提高运行时性能。

```javascript
requestIdleCallback(myNonEssentialWork);
```

什么叫非关键事务？比如做插桩标记（instrumentation beacons）。Tinder 团队为了减少刷屏时的绘制次数，对合成层（composite layers）也做了优化。

**在刷屏操作中，是否使用 requestIdleCallback() 的对比：**

使用前..

![](https://cdn-images-1.medium.com/max/800/1*oHJ8IjCs7AKdCrt9b28ZPw.png)

使用后...

![](https://cdn-images-1.medium.com/max/800/1*UTQuSSp7MGMY06mwYtQmaw.png)

### 依赖优化

**Webpack 3 + 作用域提升**

在 webpack 3 以前，每个模块在打包后都会被包裹进一个独立的闭包内，但是这些包裹起来的方法（闭包）执行效率很低。对此，[Webpack 3](https://medium.com/webpack/webpack-3-official-release-15fd2dd8f07b) 推出了“作用域提升”机制，将多个模块打包进一个闭包中（相当于合并作用域），以提高执行速度。使用这一功能需要引入 Module Concatenation 插件：

```javascript
new webpack.optimize.ModuleConcatenationPlugin()
```

**使用作用域提升机制后，Tinder 第三方依赖初始化解析时间减少了 8%。**

**React 16**

React 16 优化了打包之后的文件大小，新的打包算法（Rollup）会剔除一些暂时用不到的代码。

**Tinder 从 React 15 升级到 React 16 后，gzip 压缩后的依赖大小减小了约 7%**。

最后，react + react-dom 压缩后从之前的 50KB 降到现在的 **35KB** 左右，效果拔群。这里要特别感谢 [Dan Abramov](https://twitter.com/dan_abramov)、[Dominic Gannaway](https://twitter.com/trueadm) 和 [Nate Hunzaker](https://twitter.com/natehunzaker) 的付出，他们在 React 16 中为降低打包文件大小做了不少贡献。

### 网络弹性和静态资源缓存

Tinder 还用了 [Workbox Webpack 插件](https://developers.google.com/web/tools/workbox/get-started/webpack)，用于缓存 [Application Shell](https://developers.google.com/web/fundamentals/architecture/app-shell) 和核心静态资源，例如主干代码、第三方库、manifest 和 CSS。使用后，具备了较强的频繁访问抗压能力，同时用户再次使用时，启动速度也大大提高了。

![](https://cdn-images-1.medium.com/max/1000/1*yXpAzyA1ODPk2OSOTA6Lhg.png)

### 更上一层楼

用 [source-map-explorer](https://www.npmjs.com/package/source-map-explorer) （又一个包分析工具）再次对包进行深入分析，发现还有继续缩小网络负载的优化空间。在登陆场景中，用户还没登录的情况下，Facebook 图片、通知、私信以及验证码这些组件并不需要加载，将这些组件从关键路径（critical path）移除之后可为主干代码省下 20% 的数据量：

![](https://cdn-images-1.medium.com/max/1000/1*G1nq7BNZPEo2mFr_my5zjA.png)

因为上一步移除了 Facebook 的组件，所以其相关依赖 Facebook SDK 也可以直接移除，后面需要用到的时候再进行加载（懒加载），这样就又节省了 200KB，而且初始加载时间也减少了 1 秒。

### 总结

虽然 Tinder 还在继续迭代他们的产品，但是已经初见成效了，你可以随时访问 Tinder.com 关注最新进展。

**感谢并祝贺 Roderick Hsiao、 Jordan Banafsheha 以及 Erik Hellenbrand，恭喜你们成功发布了 Tinder Online，谢谢你们对我的文章提出的指导意见，还有 Cheney Tsai，你的观点给了我很多启发。**

**相关阅读：**

* [A Pinterest PWA performance case study](https://medium.com/dev-channel/a-pinterest-progressive-web-app-performance-case-study-3bd6ed2e6154)
* [A Treebo React & Preact performance case study](https://medium.com/dev-channel/treebo-a-react-and-preact-progressive-web-app-performance-case-study-5e4f450d5299)
* [Twitter Lite and high-performance PWAs at scale](https://medium.com/@paularmstrong/twitter-lite-and-high-performance-react-progressive-web-apps-at-scale-d28a00e780a3)

本文转载自 [Performance Planet](https://calendar.perfplanet.com/2017/a-tinder-progressive-web-app-performance-case-study/)。 如果你对 React 还不熟悉，可以参考我推荐的教程：[React for Beginners](https://goo.gl/G1WGxU)，对新手十分友好。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
