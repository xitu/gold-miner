> * 原文地址：[Progressive Web Apps with React.js: Part 2 — Page Load Performance](https://medium.com/@addyosmani/progressive-web-apps-with-react-js-part-2-page-load-performance-33b932d97cf2#.o0f4vf64s)
* 原文作者：[Addy Osmani](https://medium.com/@addyosmani)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[markzhai](https://github.com/markzhai)
* 校对者：[Romeo0906](https://github.com/Romeo0906)，[AceLeeWinnie](https://github.com/AceLeeWinnie)

# 使用 React.js 的渐进式 Web 应用程序：第 2 部分 - 页面加载性能


## 这是新[系列](https://medium.com/@addyosmani/progressive-web-apps-with-react-js-part-i-introduction-50679aef2b12#.ysn8uhvkq)的第二部分，新系列介绍的是使用 [Lighthouse](https://github.com/googlechrome/lighthouse) 优化移动 web 应用传输的技巧。本期，我们关注的是页面加载性能。

### 保证页面加载性能是快的

移动 Web 的速度很关键。平均来说，更快的体验会 [延长 70% 的会话](https://www.doubleclickbygoogle.com/articles/mobile-speed-matters/) 以及两倍以上更多的移动广告收益。基于 React 的 Web 性能投资中，Flipkart Lite 使[访问时间提升了三倍](https://developers.google.com/web/showcase/2016/flipkart)， GQ 在流量上得到了 [80% 增长](http://digiday.com/publishers/gq-com-cut-page-load-time-80-percent/)，Trainline 在 [年收益上增长了 11M](https://youtu.be/ai-6qwT6ES8?t=462) 并且 Instagram 的 [好感度上升了 33%](http://engineering.instagram.com/posts/193415561023919/performance-&-usage-at-Instagram)。

在你的 web app 加载时有一些 [关键的用户时刻](https://www.youtube.com/watch?v=wFwogd4CdwY&index=4&list=PLNYkxOF6rcIB3ci6nwNyLYNU6RDOU3YyL)：


![](https://cdn-images-1.medium.com/max/2000/0*KlJk2hhZl3wyn6E4.)

测量并优化一直很重要。Lighthouse 的页面加载检测会关注：

*   [**第一次有意义的绘制**](https://www.quora.com/What-does-First-Meaningful-Paint-mean-in-Web-Performance)（当页面主内容可见）
*   [**速度指数（Speed Index）**](https://sites.google.com/a/webpagetest.org/docs/using-webpagetest/metrics/speed-index)（完全可见）
*   **估算的输入延迟**（主线程什么时候才能立即处理用户输入）
*   以及 **抵达可交互的时间**（ app 到开始可用和可交互的时间)

**关于 PWA [值得关注的有趣指标]((https://www.youtube.com/watch?v=IxXGMesq_8s))，Paul Irish 做了很棒的总结。**

**良好性能的目标：**

*   **遵循** [**RAIL 性能模型**](https://developers.google.com/web/tools/chrome-devtools/profile/evaluate-performance/rail?hl=en) 的 L 部分。**A+ 的性能是我们所有人都必须力求达到的，即便有的浏览器不支持 Service Worker。我们仍然可以快速地在屏幕上获得一些有意义的内容，并且仅加载我们所需要的**
*   **在典型网络（3G）和硬件条件下**
*   首次访问在 5 秒内可交互，重复访问（Service Worker 可用）则在 2 秒内。
*   首次加载（网络限制下），速度指数在 3000 或者更少。
*   第二次加载（磁盘限制，因为 Service Worker 可用）：速度指数 1000 或者更少。

让我们再说说，关于通过 TTI 关注交互性。

### 关注抵达可交互时间（TTI）

为交互性优化，也就是使得 app 尽快能对用户可用（比如让他们可以四处点击，app 可以响应）。这对试图在移动设备上提供一流用户体验的现代 web 体验很关键。


![](https://cdn-images-1.medium.com/max/1600/0*qfZvSxxJxPHhXXgb.)

Lighthouse 目前将 TTI 作为布局是否达到稳定的衡量，web 字型是否可见并且主线程是否有足够的能力处理用户输入。有很多方法来手动跟踪 TTI，重要的是根据指标进行优化会提升你用户的体验。

对于像 React 这样的库，你应该关心的是在移动设备上 [启用库的代价](https://aerotwist.com/blog/the-cost-of-frameworks/) 因为这会让人们有感知。在 [ReactHN](https://github.com/insin/react-hn)，我们达到了 **1700毫秒** 内就完成了交互，尽管有多个视图，但我们还是保持整个 app 的大小和执行消耗相对很小：app 压缩包只有 11KB，vendor/React/libraries 压缩包只有 107KB。实际上，它们是这样的：


![](https://cdn-images-1.medium.com/max/2000/0*N--j53GygKHn2ViI.)


之后，对于有小功能的 app 来说，我们会使用 [PRPL](https://www.polymer-project.org/1.0/toolbox/server) 这样的性能模式，这种模式可以充分利用 [HTTP/2 的服务器推送](https://www.igvita.com/2013/06/12/innovating-with-http-2.0-server-push/) 功能，利用颗粒状的 “基于路由的分块” 来得到快速的可交互时间。（可以试试 [Shop](https://shop.polymer-project.org/) demo 来获取直观了解）。

Housing.com 最近使用了类 PRPL 模式搭载 React 体验，获得了很多赞扬：


![](https://cdn-images-1.medium.com/max/1600/0*55ArR_Z3qt7Az_FW.)


Housing.com 利用 Webpack 路由分块，来推迟入口页面的部分启动消耗（仅加载 route 渲染所需要的）。更多细节请查看 [Sam Saccone 的优秀 Housing.com 性能检测](https://twitter.com/samccone/status/771786445015035904).


Flipkart 也做了类似的：

注意：关于什么是 “可交互时间”，有很多不同的看法，Lighthouse 对 TTI 的定义也可能会演变。还有其他测试可交互时间的方法，页面跳转后第一个 5 秒内 window 没有长任务的时刻，或者一次文本/内容绘制后第一次 5 秒内 window 没有长任务的时刻。基本上，就是页面稳定后多久用户才可以和 app 交互。

注意：尽管不是强制的要求，你可能也需要提高视觉完整度（速度指数），通过 [优化关键渲染路径](https://developers.google.com/web/fundamentals/performance/critical-rendering-path/)。[关键路径 CSS 优化工具的存在](https://github.com/addyosmani/critical-path-css-tools#node-modules) 以及其优化在 HTTP/2 的世界中依然有效。

### 用基于路由的分块来提高性能

### Webpack

**如果你第一次接触模块打包工具，比如 Webpack，看看** [**JS 模块化打包器**](https://www.youtube.com/watch?v=OhPUaEuEaXk)**(视频) 可能会有帮助。**

如今一些的 JavaScript 工具能够方便地将所有脚本打包成一个所有页面都引入的 bundle.js 文件。这意味着很多时候，你可能要加载很多对当前路由来说并不需要的代码。为什么一次路由需要加载 500KB 的 JS，而事实上 50KB 就够了呢？我们应该丢开那些无助于获得更快体验的脚本，来加速获得可交互的路由。


![](https://cdn-images-1.medium.com/max/1600/0*z2tqS124xW0GDmcP.)

**当仅提供用户一次 route 所需要的最小功能的可用代码就可以的时候，避免提供庞大整块的 bundles（像上图）。**

代码分割是解决整块的 bundles 的一个方法。想法大致是在你的代码中定义分割点，然后分割成不同的文件进行按需懒加载。这会改善启动时间，帮助更迅速地达到可交互状态。

![](https://cdn-images-1.medium.com/max/2000/0*c9rmq2rp95BN39qg.)

想象使用一个公寓列表 app。如果我们登陆的路由是列出我们所在区域的地产（route-1）—— 我们不需要全部地产详情（route-2）或者预约看房（route-3）的代码，所以我们可以只提供列表路由所需要的 JavaScript 代码，然后动态加载其余部分。

这些年来，很多 app 已经使用了代码分割的概念，然而现在用 “[基于路由的分块](https://gist.github.com/addyosmani/44678d476b8843fd981ff8011d389724)” 来称呼它。我们可以通过 Webpack 模块打包器为 React 启用这个设置。

### 实践基于路由的代码分块

当 Webpack 在 app 代码中发现  [require.ensure()](https://webpack.github.io/docs/code-splitting.html)（在 [Webpack 2](https://gist.github.com/sokra/27b24881210b56bbaff7) 中是 [System.import](http://moduscreate.com/code-splitting-for-react-router-with-es6-imports/)）时，支持分割代码。这些方法出现的地方被称为“分割点”，Webpack 会对它们的每一个都生成一个分开的 bundle，按需解决依赖。

    // 定义一个 "split-point"
    require.ensure([], function () {
       const details = require('./Details');
       // 所有被 require() 需要的都会成为分开的 bundle
       // require(deps, cb) 是异步的。它会异步加载，并且评估
       // 模块，通过你的 deps 的 exports 调用 cb。
    });

当你的代码需要某些东西，Webpack 会发起一个 JSONP 请求来从服务器获得它。这个和 React Router 结合工作得很好，我们可以在对用户渲染视图之前在依赖（块）中懒加载一个新的路由。

Webpack 2 支持 [使用 React Router 的自动代码分割](https://medium.com/modus-create-front-end-development/automatic-code-splitting-for-react-router-w-es6-imports-a0abdaa491e9#.3ryyedhfc)，它可以像 import 语句一样处理 System.import 模块调用，将导入的文件和它们的依赖一起打包。依赖不会与你在 Webpack 设置中的初始入口冲突。
```JavaScript
    import App from '../containers/App';

    function errorLoading(err) {
      console.error('Lazy-loading failed', err);
    }

    function loadRoute(cb) {
      return (module) => cb(null, module.default);
    }
    export default {
      component: App,
      childRoutes: [
        // ...
        {
          path: 'booktour',
          getComponent(location, cb) {
            System.import('../pages/BookTour')
              .then(loadRoute(cb))
              .catch(errorLoading);
          }
        }
      ]
    };
```
### 加分项：预加载那些路由！

在我们继续之前，一个配置可选项是来自 [](https://www.smashingmagazine.com/2016/02/preload-what-is-it-good-for/) 的 [Resource Hints](https://twitter.com/addyosmani/status/743571393174872064)。这提供了一个声明式获取资源的方法，而不用执行他们。预加载可以用来加载那些用户**可能**访问的路由的 Webpack 块，用户真正访问这些路由时已经缓存并且能够立即实例化。





![](https://cdn-images-1.medium.com/max/1600/0*l-XqjMw7_XX0wsxX.)





笔者写这篇文章的时候，预加载只能在 [Chrome](http://caniuse.com/#feat=link-rel-preload) 中进行，但是在其他浏览器中被处理为渐进式增加（如果支持的话）。

注意：html-webpack-plugin 的 [模板和自定义事件](https://github.com/ampedandwired/html-webpack-plugin#events) 可以使用最小的改变来让简化这个过程。然后你应该保证预加载的资源真正会对你大部分的用户浏览过程有用。

### 异步加载路由

让我们回到代码分割（code-splitting）—— 在一个使用 React 和 [React Router](https://github.com/reactjs/react-router) 的 app 里，我们可以使用 require.ensure() 以在 ensure 被调用的时候异步加载一个组件。顺带一提，如果任何人在探索服务器渲染，如果要 node 上尝试服务器端渲染，需要用 [node-ensure](https://www.npmjs.com/package/node-ensure) 包作垫片代替。Pete Hunt 在 [Webpack How-to](https://github.com/petehunt/webpack-howto#9-async-loading) 里涉及了异步加载。

在下面的例子里，require.ensure() 使我们可以按需懒加载路由，在组件被使用前等待拉取：
```JavaScript
    const rootRoute = {
      component: Layout,
      path: '/',
      indexRoute: {
        getComponent (location, cb) {
          require.ensure([], () => {
            cb(null, require('./Landing'))
          })
        }
      },
      childRoutes: [
        {
          path: 'book',
          getComponent (location, cb) {
            require.ensure([], () => {
              cb(null, require('./BookTour'))
            })
          }
        },
        {
          path: 'details/:id',
          getComponent (location, cb) {
            require.ensure([], () => {
              cb(null, require('./Details'))
            })
          }
        }
      ]
    }
```
**注意：我经常配合 CommonChunksPlugin (minChunks: Infinity) 使用上面的配置，这样不同入口文件中的相同模块只有一个 chunk。这还 [降低](https://github.com/webpack/webpack/issues/368#issuecomment-247212086) 了陷入缺省 webpack 运行期。**

Brian Holt 在 React 的完整介绍 中对异步路由加载介绍得很好。。

Brian Holt 在 [React 的完整介绍](https://btholt.github.io/complete-intro-to-react/) 对异步路由加载阐述地很全面。通过异步路由的代码分割在 React Router 的最新版本和 [新的 React Router V4](https://gist.github.com/acdlite/a68433004f9d6b4cbc83b5cc3990c194) 上都可以使用。

### 使用异步的 getComponent + require.ensure() 的声明式路由 chunk

有一个可以更快设置代码分割的小技巧。在 React Router 中，一个根路由 “/” 映射到 `App` 组件的 [申明式的路由](https://github.com/ReactTraining/react-router/blob/master/docs/API.md#route) 就像这样 `<Route path=”/” component={App}>`。

React Router 也支持 `[getComponent](https://github.com/ReactTraining/react-router/blob/master/docs/API.md#getcomponentnextstate-callback)` 属性，十分方便，类似于 `component` 但却是异步的，并且能够**非常快速**地设置代码分割：

```
<Route
   path="stories/:storyId"
   getComponent={(nextState, cb) => {
   // 异步地查找 components
  cb(null, Stories)
}} />
```

`getComponent` 函数参数包括下一个状态（我设置为 null）和一个回调。

让我们添加一些基于路由的代码分割到 [ReactHN](https://github.com/insin/react-hn)。我们会从 [routes](https://github.com/insin/react-hn/blob/master/src/routes.js#L36) 文件中的一段开始 —— 它为每个路由定义了引入调用和 React Router 路由（比如 news, item, poll, job, comment 永久链接等）：
```JavaScript
    var IndexRoute = require('react-router/lib/IndexRoute')
    var App = require('./App')
    var Item = require('./Item')
    var PermalinkedComment = require('./PermalinkedComment') <--
    var UserProfile = require('./UserProfile')
    var NotFound = require('./NotFound')
    var Top = stories('news', 'topstories', 500)
    // ....

    module.exports = <Route path="/" component={App}>
      <IndexRoute component={Top}/>
      <Route path="news" component={Top}/>
      <Route path="item/:id" component={Item}/>
      <Route path="job/:id" component={Item}/>
      <Route path="poll/:id" component={Item}/>
      <Route path="comment/:id" component={PermalinkedComment}/> <---
      <Route path="newcomments" component={Comments}/>
      <Route path="user/:id" component={UserProfile}/>
      <Route path="*" component={NotFound}/>
    </Route>
```

ReactHN 现在提供给用户一个整块的 JS bundle，包含**所有**路由。让我们将它转换为路由分块，只提供一次路由真正需要的代码，从 comment 的永久链接开始（comment/:id）：

所以我们首先删了对永久链接组件的隐式 require：

    var PermalinkedComment = require(‘./PermalinkedComment’)

然后开始我们的路由..


然后使用声明式的 getComponent 来更新它。我们在路由中使用 require.ensure() 调用来懒加载，而这就是我们所需要做的一切了：

    <Route
      path="comment/:id"
      getComponent={(location, callback) => {
        require.ensure([], require => {
          callback(null, require('./PermalinkedComment'))
        }, 'PermalinkedComment')
      }}
    />

OMG，太棒了。这..就搞定了。不骗你。我们可以如法炮制剩下的路由，然后运行 webpack。它会正确地找到 require.ensure() 调用，并且如我们所愿地分割代码。


![](https://cdn-images-1.medium.com/max/1600/0*glKcFK9_RLNk9AyR.)

将声明式代码分割应用到我们的大部分路由后，我们可以看到路由分块生效了，只在需要的时候对一个路由（我们能够预缓存在 Service Worker 里）加载所需代码：


![](https://cdn-images-1.medium.com/max/1600/0*tVvolw4FTKjNFAnY.)



提醒：有许多可用于 Service Worker 的简单 Webpack 插件：

*   [sw-precache-webpack-plugin](https://github.com/goldhand/sw-precache-webpack-plugin) 在底层使用 sw-precache
*   [offline-plugin](https://github.com/NekR/offline-plugin) 被 react-boilerplate 所使用

#### CommonsChunkPlugin

![](https://cdn-images-1.medium.com/max/1600/0*QphlrnwHQiOsB06w.)


为了识别出在不同路由使用的通用模块并把它们放在一个通用的分块，需要使用 [CommonsChunkPlugin](https://webpack.github.io/docs/list-of-plugins.html#commonschunkplugin)。它需要在每个页面引入两个 script 标签，一个用于 commons 分块，另一个用于一次路由的入口分块。

    const CommonsChunkPlugin = require("webpack/lib/optimize/CommonsChunkPlugin");
    module.exports = {
        entry: {
            p1: "./route-1",
            p2: "./route-2",
            p3: "./route-3"
        },
        output: {
            filename: "[name].entry.chunk.js"
        },
        plugins: [
            new CommonsChunkPlugin("commons.chunk.js")
        ]
    }

Webpack 的 [— display-chunks 标志](https://blog.madewithlove.be/post/webpack-your-bags/) 对于查看模块在哪个分块中出现很有用。这个帮助我们减少分块中重复的依赖，并且能够提示是否应该在项目中开启 CommonChunksPlugin。这是一个带有多个组件的项目，在不同分块间检测到重复的 Mustache.js 依赖：


![](https://cdn-images-1.medium.com/max/1600/0*YMvoz-W2HL3v2MIs.)


Webpack 1 也支持通过 [DedupePlugin](https://github.com/webpack/docs/wiki/optimization#deduplication) 以在你的依赖树中进行依赖库的去重。在 Webpack 2，tree-shaking 应该淘汰了这个的需求。

**更多 Webpack 的小贴士**

*   你的代码库中 require.ensure() 调用的数目通常会关联到生成的 bundles 的数目。在代码库中大量使用 ensure 的时候意识到这点很有用。
*   [Webpack2 的 Tree-shaking](https://medium.com/modus-create-front-end-development/webpack-2-tree-shaking-configuration-9f1de90f3233) 会帮助删除没用的 exports，这可以让你的 bundle 尺寸变小。
*   另外，避免在 通用/共享的 bundles 里面调用 require.ensure()。你会发现这创建了入口点引用，而我们假定这些引用的依赖已经完成加载了。
*   在 Webpack 2，System.import 目前不支持服务端渲染，但我已经在 [StackOverflow](http://stackoverflow.com/a/39088208) 分享了怎么去处理这个问题。
*   如果需要优化编译速度，可以看看 [Dll plugin](https://github.com/webpack/docs/wiki/list-of-plugins)，[parallel-webpack](https://www.npmjs.com/package/parallel-webpack) 以及目标的编译。
*   如果你希望通过 Webpack **异步** 或者 **延迟** 脚本，看看 [script-ext-html-webpack-plugin](https://github.com/numical/script-ext-html-webpack-plugin)

**在 Webpack 编译中检测臃肿**

Webpack 社区有很多建立在 Web 上的编译分析器包括 [http://webpack.github.io/analyse/](http://webpack.github.io/analyse/)，[https://chrisbateman.github.io/webpack-visualizer/](https://chrisbateman.github.io/webpack-visualizer/)，和 [https://alexkuz.github.io/stellar-webpack/](https://alexkuz.github.io/stellar-webpack/)，这些能方便地明确你项目中最大的模块。

[**source-map-explorer**](https://github.com/danvk/source-map-explorer) (来自 Paul Irish) 通过 source maps 来理解代码臃肿，也**超级棒**的。看看这个对 ReactHN Webpack bundle 的 tree-map 可视化，带有每个文件的代码行数，以及百分比的统计分析：


![](https://cdn-images-1.medium.com/max/1600/0*D5j-Jv_FVkMigRyZ.)



你可能也会对来自 Sam Saccone 的 [**coverage-ext**](https://github.com/samccone/coverage-ext) 感兴趣，它可以生成任何 webapp 的代码覆盖率。这个对于理解你的代码中有多少实际会被执行到很有用。

### 代码分割（code-splitting）之上：PRPL 模式

Polymer 发现了一个有趣的 web 性能模式，用于精细服务的 apps，称为 [PRPL](https://www.polymer-project.org/1.0/toolbox/server)（看看 [Kevin 的 I/O 演讲](https://www.youtube.com/watch?v=J4i0xJnQUzU))。这个模式尝试优化交互，各个字母代表：

*   (P)ush，对于初始路由推送关键资源。
*   (R)ender，渲染初始路由，并使它尽快变得可交互。
*   (P)re-cache，通过 Service Worker 预缓存剩下的路由。
*   (L)azy-load，根据用户在应用中的移动懒加载并懒初始化 apps 中对应的部分。


![](https://cdn-images-1.medium.com/max/2000/0*2XxuNsDEp1-4VuoU.)



在这里，我们必须给予 [Polymer Shop demo](https://shop.polymer-project.org/) 大大的赞赏，因为它展示给我们移动设备上的实现方法。使用 PRPL（在这种情况下通过 HTML Imports，从而利用浏览器的后台 HTML parser 的好处）。屏幕上的像素你都可以使用。这里额外的工作在于分块和保持可交互。在一台真实移动设备上，我们可以在 1.75 秒内达到可交互。其中 1.3 秒用于 JavaScript，但它都被打散了。在那以后所有功能都可以用了。

你到现在应该已经成功享受到将应用打碎到更精细的分块的好处了。当用户第一次访问我们的 PWA，假设说他们访问一个特定的路由。服务器（使用 H/2 推送）能够推送下来仅仅那次路由需要的分块 —— 这些是用来启动应用的必要资源，并会进入网络缓存中。

一旦它们被推送下来了，我们就能高效地准备好未来会被加载的页面分块到缓存中。当应用启动后，检查路由并发现我们想要的已经在缓存中了，所以我们就能使得应用的首次加载非常快 —— 不仅仅是闪屏 —— 而是用户请求的可交互内容。

下一步是尽快渲染这个视图的内容。第三步是，当用户在看当前的视图的时候，使用 Service Worker 来开始预缓存所有其他用户还没有请求的分块和路由，将它们安装到 Service Worker 的缓存中。

此时，整个应用（或者大部分）都已经可以离线使用了。当用户跳转到应用的不同部分，我们可以从 Service Worker 的缓存中懒加载下面的部分。不需要网络加载 —— 因为它们已经被预缓存了。瞬间加载碉堡了！❤

PRPL 可以被应用到任何 app，正如 Flipkart 最近在他们的 React 栈上所展示的。完全使用 PRPL 的 Apps 可以利用 HTTP/2 服务器推送的快速加载，通过产生两种编译版本，并根据浏览器的支持提供不同版本：

* 一个 bundled 编译，为没有 HTTP/2 推送支持的服务器/浏览器优化以最小化往返。对大多数人而言，这是现在默认的访问内容。

* 一个没有 bundled 编译，用于支持 HTTP/2 推送的服务器/浏览器，使得首次绘制更快。

这个部分基于我们在之前讨论的路由分块的概念。通过 PRPL，服务器和我们的 Service Worker 协作来为非活动路由预缓存资源。当一个用户在你的 app 中浏览并改变路由，我们对尚未缓存的路由进行懒加载，并创建请求的视图。

### 实现 PRPL

**篇幅过长，没有阅读：Webpack 的 require.ensure() 以及异步的 ‘getComponent’，还有 React Router 是到 PRPL 风格性能模式的最小摩擦路径**

![](https://cdn-images-1.medium.com/max/1600/0*-llrY94drXMjBUW6.)


PRPL 的一大部分在于颠覆 JS 打包思维，并像编写时候那样精细地传输资源（至少从功能独立模块角度上）。配合 Webpack，这就是我们已经说过的路由分块。

对于初始路由推送关键资源。理想情况下，使用 [HTTP/2 服务端推送](https://www.igvita.com/2013/06/12/innovating-with-http-2.0-server-push/)，但即便没有它，也不会成为实现类 PRPL 路径的阻碍。即便没有 H/2 推送，你也可以实现一个大致和“完整” PRPL 类似的结果，只需要发送 [预加载头](https://www.smashingmagazine.com/2016/02/preload-what-is-it-good-for/) 而不需要 H/2。

看看 Flipkart 他们前后的生产瀑布流：


![](https://cdn-images-1.medium.com/max/2000/0*-hLp_Acvig_s4Uop.)


Webpack 已经通过 [AggressiveSplittingPlugin](https://github.com/webpack/webpack/tree/master/examples/http2-aggressive-splitting) 的形式支持了 H/2。

AggressiveSplittingPlugin 分割每个块直到它到达了指定的 maxSize（最大尺寸），正如我们在下面的例子里可见的：
```
    module.exports = {
        entry: "./example",
        output: {
            path: path.join(__dirname, "js"),
            filename: "[chunkhash].js",
            chunkFilename: "[chunkhash].js"
        },
        plugins: [
            new webpack.optimize.AggressiveSplittingPlugin({
                minSize: 30000,
                maxSize: 50000
            }),
    // ...
```
查看官方 [plugin page](https://github.com/webpack/webpack/tree/master/examples/http2-aggressive-splitting)，以获得关于更多细节的例子。[学习 HTTP/2 推送实验的课程](https://docs.google.com/document/d/1K0NykTXBbbbTlv60t5MyJvXjqKGsCVNYHyLEXIxYMv0/preview?pref=2&pli=1) 和 [真实世界 HTTP/2](https://99designs.com.au/tech-blog/blog/2016/07/14/real-world-http-2-400gb-of-images-per-day/) 也值得一读。

*   渲染初始路由：这实际上取决于你使用的框架或者库。
*   预缓存剩下的路由。对于缓存，我们依赖于 Service Worker。[sw-precache](https://github.com/GoogleChrome/sw-precache) 能很好地生成一个 Service Worker 用于静态资源预缓存。对于 Webpack 我们可以使用 [SWPrecacheWebpackPlugin](https://www.npmjs.com/package/sw-precache-webpack-plugin)。
*   按需懒加载并创建剩下的路由 —— 在 Webpack 领域，可以使用 require.ensure() 和 System.import()。

### 通过 Webpack 的缓存失效和长期缓存

**为什么关心静态资源版本？**

静态资源指的是我们页面中像是脚本，stylesheets 和图片这样的资源。当用户第一次访问我们页面的时候，他们需要其需要的所有资源。比如说当我们加载一个路由的时候，JavaScript 块和上次访问之际并没有改变 —— 我们不必重新抓取这些脚本因为他们已经在浏览器缓存中存在了。更少的网络请求是我们在 web 性能优化中的胜利。

通常地，我们使用对每个文件设置 [expires 头](https://developers.google.com/web/fundamentals/performance/optimizing-content-efficiency/http-caching?hl=en) 来达到目的。一个 expires 头只意味着我们可以告诉浏览器，避免在指定时间内（比如说1年）发起另一个对该文件的请求到服务器。随着代码演变和重新部署，我们想要确保用户可以获得最新的文件，如果没有改变的话则不需要重新下载资源。

[Cache-busting](https://css-tricks.com/strategies-for-cache-busting-css/) 通过在文件名后面附加字符串来完成这个 —— 他可以是一个编译版本（比如 src=”chunk.js?v=1.2.0”），一个 timestamp 或者别的什么。我倾向于添加一个文件内容的 hash 到文件名（比如 chunk.d9834554decb6a8j.js）因为这个在文件内容发生改变的时候总是会改变。在 Webpack 社区常用 MD5 哈希生成的 16 字节长的“概要”来实现这个目的。

[**通过 Webpack 的静态资源长期缓存**](https://medium.com/@okonetchnikov/long-term-caching-of-static-assets-with-webpack-1ecb139adb95) **是关于这个主题的优秀读物，你应该去看一看。我试图在下面涵盖其涉及到的主要内容。**

**在 Webpack 中通过 content-hashing 来做资源版本控制**

在 Webpack 设置中加上如下内容来启用基于内容哈希的资源版本 [[chunkhash]](https://webpack.github.io/docs/long-term-caching.html)：

    filename: ‘[name].[chunkhash].js’,
    chunkFilename: ‘[name].[chunkhash].js’

我们也想要保证常规的 [name].js 和 内容哈希 ([name].[chunkhash].js) 文件名在我们的 HTML 文件被正确引用。不同之处在于引用 `<script src=”chunk”.js”>` 和 `<script src=”chunk.d9834554decb6a8j.js”>`。

下面是一个注释了的 Webpack 设置样例，包括了一些其他的插件来使得长期缓存的安装更优雅。

```JavaScript
const path = require('path');
const webpack = require('webpack');
// 使用 webpack-manifest-plugin 来生成包含了源文件到对应输出的映射的资源 manifest。Webpack 使用 IDs 而不是模块名来保持生成的文件尽量小。IDs 在它们被放进 chunk（分块）manifest 之前被生成并映射到 chunk 的文件名（会跑到我们的入口 chunk）。不幸的是，任何对代码的改变都会更新入口 chunk 包括新的 manifest，并刷新我们的缓存。
const ManifestPlugin = require('webpack-manifest-plugin');
// 我们通过 chunk-manifest-webpack-plugin 来修复这个问题，它会将 manifest 放到一个完全独立的 JSON 文件。
const ChunkManifestPlugin = require('chunk-manifest-webpack-plugin');
module.exports = {
  entry: {
    vendor: './src/vendor.js',
    main: './src/index.js'
  },
  output: {
    path: path.join(__dirname, 'build'),
    filename: '[name].[chunkhash].js',
    chunkFilename: '[name].[chunkhash].js'
  },
  plugins: [
    new webpack.optimize.CommonsChunkPlugin({
      name: "vendor",
      minChunks: Infinity,
    }),
    new ManifestPlugin(),
    new ChunkManifestPlugin({
      filename: "chunk-manifest.json",
      manifestVariable: "webpackManifest"
    }),
    // 对非确定的模块顺序的权宜之计。在通过 Webpack 的静态资源长期缓存文章中有更多介绍
    new webpack.optimize.OccurenceOrderPlugin()
  ]
};
```

现在我们有了这个 chunk-manifest JSON 的编译，我们需要把它内联（inline）到我们的 HTML，那么 Webpack 就能实际在页面启动时真正对其有访问权。所以在 `<script>` 标签中加上上面的输出。

通过使用 [html-webpack-plugin](https://github.com/ampedandwired/html-webpack-plugin) 可以实现自动将脚本内联到 HTML 中。

注意：Webpack 理想上可以通过 [no shared ID range](https://jakearchibald.com/2016/caching-best-practices/) 来简化启用长期缓存的步骤（见~4–1）。

如果要学习更多 HTTP 的 [缓存最佳实践](https://jakearchibald.com/2016/caching-best-practices/)，可以阅读 Jake Archibald 的优秀文章。

### 更多阅读

*   [Webpack 关于代码分割的文档](https://webpack.github.io/docs/code-splitting.html)
*   Formidable 的关于 Webpack 的 OSS Playbook [代码分割](https://formidable.com/open-source/playbook/docs/frontend/webpack-code-splitting/) and [shared libraries](https://formidable.com/open-source/playbook/docs/frontend/webpack-shared-libs/)
*   [使用 Webpack 的渐进式 Web Apps](http://michalzalecki.com/progressive-web-apps-with-webpack)
*   [高级 Webpack Part 2&#8202;—&#8202;代码分割](https://getpocket.com/redirect?url=http%3A%2F%2Fjonathancreamer.com%2Fadvanced-webpack-part-2-code-splitting%2F&amp;formCheck=0b0d10781e025a205b05e2941ffdc845)
*   [为现代 web 应用程序通过代码分割来渐进加载](https://medium.com/@lavrton/progressive-loading-for-modern-web-applications-via-code-splitting-fb43999735c6#.1965mrwlr)
*   [在 React 组件中异步加载依赖](https://getpocket.com/redirect?url=https%3A%2F%2Ftailordev.fr%2Fblog%2F2016%2F03%2F17%2Floading-dependencies-asynchronously-in-react-components%2F&amp;formCheck=0b0d10781e025a205b05e2941ffdc845)
*   [我们继续前进在 Webpack 插件 DLL](https://medium.com/@soederpop/webpack-plugins-been-we-been-keepin-on-the-dll-cdfdd6cb8cd7)
*   [自动代码分割用于 React Router 和 ES6 Imports&#8202;—&#8202;Modus Create](https://getpocket.com/redirect?url=https%3A%2F%2Fmedium.com%2Fmodus-create-front-end-development%2Fautomatic-code-splitting-for-react-router-w-es6-imports-a0abdaa491e9%23.twoltv57f&amp;formCheck=0b0d10781e025a205b05e2941ffdc845)
*   [使用 webpack 和 react-router 于懒加载和代码分割没有去加载](https://getpocket.com/redirect?url=http%3A%2F%2Fstackoverflow.com%2Fquestions%2F34925717%2Fusing-webpack-and-react-router-for-lazyloading-and-code-splitting-not-loading&amp;formCheck=0b0d10781e025a205b05e2941ffdc845)
*   [在现实生活通过 React 同构/通用渲染/路由/数据抓取](https://reactjsnews.com/isomorphic-react-in-real-life)
*   [一个懒得同构 React 实验](https://getpocket.com/redirect?url=http%3A%2F%2Fblog.scottlogic.com%2F2016%2F02%2F05%2Fa-lazy-isomorphic-react-experiment.html&amp;formCheck=0b0d10781e025a205b05e2941ffdc845)
*   [服务端渲染懒路由](https://getpocket.com/redirect?url=https%3A%2F%2Fgithub.com%2Fryanflorence%2Fexample-react-router-server-rendering-lazy-routes&amp;formCheck=0b0d10781e025a205b05e2941ffdc845) 基于 React Router 和代码分割
*   [给初学者的 React 在服务端&#8202;—&#8202;构建一个通用的 React app](https://scotch.io/tutorials/react-on-the-server-for-beginners-build-a-universal-react-and-node-app)
*   [有页面的 React.js Apps](https://getpocket.com/redirect?url=http%3A%2F%2Fblog.mxstbr.com%2F2016%2F01%2Freact-apps-with-pages%2F&amp;formCheck=0b0d10781e025a205b05e2941ffdc845)
*   [将世界银行数据网站构建为使用代码分割的快速加载单页应用](https://getpocket.com/redirect?url=https%3A%2F%2Fwiredcraft.com%2Fblog%2Fcode-splitting-single-page-app%2F&amp;formCheck=0b0d10781e025a205b05e2941ffdc845)
*   [在 Gatsby 实现 PRPL（React.js 静态网站生成器）](https://github.com/gatsbyjs/gatsby/issues/431)

#### 高级模块打包优化读物

*   [模块化的代价](https://nolanlawson.com/2016/08/15/the-cost-of-small-modules/)
*   [RollUp 和 Closure Compiler 如何减轻模块的代价](https://twitter.com/nolanlawson/status/768525330113925121)
*   [在 2016 年转译 ES2015 的代价](https://github.com/samccone/The-cost-of-transpiling-es2015-in-2016)

在系列文章第三篇中，我们会来看看 [**怎么使你的 React PWA 能离线和断续的网络状态下工作**](https://medium.com/@addyosmani/progressive-web-apps-with-react-js-part-3-offline-support-and-network-resilience-c84db889162c#.tcspudthd).

如果你新接触 React，我发现 Wes Bos 写的 [给新手的 React](https://goo.gl/G1WGxU) 很棒。

**感谢 Gray Norton, Sean Larkin, Sunil Pai, Max Stoiber, Simon Boudrias, Kyle Mathews 和 Owen Campbell-Moore 的校对。**
