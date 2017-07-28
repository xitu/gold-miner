> * 原文地址：[webpack bits: Getting the most out of the CommonsChunkPlugin()](https://medium.com/webpack/webpack-bits-getting-the-most-out-of-the-commonschunkplugin-ab389e5f318#.hn8v7ul1f)
> * 原文作者：本文已获原作者 [Sean T. Larkin](https://medium.com/@TheLarkInn) 授权
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：[reid3290](https://github.com/reid3290)
> * 校对者：[avocadowang](https://github.com/avocadowang)，[Aladdin-ADD](https://github.com/Aladdin-ADD)

# webpack 拾翠：充分利用 CommonsChunkPlugin() #

webpack 核心团队隔三差五地就会在 Twitter 上作一些寓教于乐的[技术分享](https://twitter.com/TheLarkInn/status/842817690951733248)。

![Markdown](http://i4.buimg.com/1949/614a949156a09f9e.png)

这次的“游戏规则”很简单：安装 `webpack-bundle-analyzer`，生成一张包含所有 bundles 信息的酷炫图片分享给我，然后 webpack 团队会帮忙指出任何潜在的问题。

### 我们发现了什么？ ###

最常见的问题是代码重复：库、组件、代码在多个（同步的、异步的）bundles 中重复出现。

### 案例一：很多重复代码的 vendor bundles ###

![Markdown](http://i4.buimg.com/1949/4861f2a4f8e4ad74.png)

[Swizec Teller](https://medium.com/@swizec) 分享了一个构建图（实际上是对 8-9 个独立单页应用的构建）。在众多例子中我决定选择这一个，因为我们可以从中学到很多技术，下面让我们来仔细分析一下：

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/2000/1*Mt5awEvcigXceRDpZRX4Dw.png">

距离 “FoamTree” 图标最近的是应用本身的代码，而其他所有 node_modules 的代码则是左边那些以 "_vendor.js" 结尾的。

单从这幅图（不需要看实际配置文件）中我们就能推断出很多事情。

每个单页应用都运用了一个 `new CommonsChunkPlugin` ，并以其 entry 和 vendor 代码为目标。这会生成两个 bundles，一个只包含 node_modules 里面的代码，另一个则只包含应用本身的代码。（Swizec Teller）甚至还提供了部分配置信息：

![Markdown](http://i4.buimg.com/1949/5a6138ec9a638b46.png)

    Object.keys(activeApps)
      .map(app => new webpack.optimize.CommonsChunkPlugin({
        name: `${app}_vendor`,
        chunks: [app],
        minChunks: isVendor
      }))

其中 `activeApps` 变量很可能是用来表示独立入口点的。

#### 可以优化的地方 ####

下面几个画圈的是可以优化的地方。

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*D4m4sa9X1V05y7I7ZCMbZA.png">

#### “Meta” 缓存 ####

从上图可以看出，许多大型代码库（例如 momentjs、lodash、jquery 等）同时被 6 个（甚至更多） bundles 用到了。将所有 vendors 打包到一个独立 bundle 中的策略是很好的，但其实对**所有 vendor bundles** 也应该采取同样的策略。

我建议 [Swizec](https://medium.com/@swizec) 将如下插件添加到**插件数组的末尾**：

    new webpack.optimize.CommonsChunkPlugin({
      children: true, 
      minChunks: 6
    })

这是在告诉 webpack：

> **嘿 webpack，请检查所有的 chunks（包括那些由 webpack 生成的 vendor chunks），找出那些在 6个及6个以上 chunks 中都出现过的模块，并将其移到一个独立的文件中。**

![Markdown](http://i4.buimg.com/1949/e78d1afe76a28e8c.png)


![Markdown](http://i4.buimg.com/1949/34e0c53c6bcbebc0.png)

如你所见，现在所有符合要求的模块都被抽离到一个独立的文件中，[Swizec](https://medium.com/@swizec) 指出这个应用程序大小降低了 17%。

### 案例二：异步 chunks 中的重复 vendors

![Markdown](http://i4.buimg.com/1949/6c6cf1a954d205cf.png)

就整体代码体积来说，这种数量的重复并不严重；但是，如果你看到下面这张完整大图，你就会发现每一个异步 chunk 中都有 3 个一模一样的模块。

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/2000/1*yRCgk_pzDpkMfQGKpCO_HA.jpeg">

异步 chunks 是指那些文件名中包含 "[number].[number].js" 的 chunk。

如上图所示，四五十个异步 bundles 都用到了两三个同样的组件，我们该如何利用 `CommonsChunkPlugin` 来解决此问题呢？

#### 创建一个异步 Commons Chunk ####

解决方法和第一个案例中的类似，但是需要将配置选项中的 `async` 属性设为 `true`，代码如下：

    new webpack.optimize.CommonsChunkPlugin({
      async: true, 
      children: true, 
      filename: "commonlazy.js"
    });

类似地 —— webpack 会扫描所有 chunks 并检查公共模块。由于设置了 `async: true`，只有代码拆分的 bundles 会被扫描。因为我们并没有指明 `minChunks` 的值，所以 webpack 会取其默认值 3。综上，上述代码的含义是：

> **嘿 webpack，请检查所有的普通（即懒加载的）chunks，如果某个模块出现在了 3 个或 3 个以上的 chunks 中，就将其分离到一个独立的异步公共 chunk 中去。**

效果如下图所示：

![Markdown](http://i4.buimg.com/1949/626cbab70072f442.png)

现在异步 chunks 都非常的小，并且所有代码都被聚合到 `commonlazy.js` 文件中去了。因为这些 bundles 本来就很小了， 首次访问可能都察觉不到代码体积的变化。现在，每一个代码拆分的 bundle 所需携带的数据更少了；而且，通过将这些公共模块放到一个独立可缓存的 chunk 中，我们节省了用户加载时间，减少了需要传输的数据量（data consumption）。

#### 更多控制：minChunks 函数 ####

![Markdown](http://i4.buimg.com/1949/4c434dda7236e0e0.png)

那如果你想要跟多的控制权呢？某些情况下你可能并不想要一个单独的共享 bundle，因为并不是每一个懒加载/入口 chunk 都要用到它。`minChunks` 属性的取值也可以是一个函数！该函数可以用作“过滤器”，决定将哪些模块加到新创建的 bundle 中去。示例如下：

    new webpack.optimize.CommonsChunkPlugin({
      filename: "lodash-moment-shared-bundle.js", 
      minChunks: function(module, count) { 
        return module.resource && /lodash|moment/.test(module.resource) && count >= 3
      }
    })

上例含义是：

> **呦 webpack，如果你发现某个模块的绝对路径和 lodash 或 momentjs 相匹配并且出现在了 3 个（或 3 个以上）独立的 entries/chunks 中，请将其抽取到一个独立的 bundle 中去。**

通过设置 `async: true`，你也可以将此方法应用到异步 bundles 中。

#### 更多更多控制

![Markdown](http://i4.buimg.com/1949/4c434dda7236e0e0.png)

有了这种 `minChunks`，你就可以为特定的 entries 和 bundles 生成更小的可缓存 vendors 的子集。最终，你的代码看起来大概就像这样：

    function lodashMomentModuleFilter(module, count) {
      return module.resource && /lodash|moment/.test(module.resource) && count >= 2;
    }

    function immutableReactModuleFilter(module, count) {
      return module.resource && /immutable|react/.test(module.resource) && count >=4
    }
    
    new webpack.optimize.CommonsChunkPlugin({
      filename: "lodash-moment-shared-bundle.js", 
      minChunks: lodashMomentModuleFilter
    })
    
    new webpack.optimize.CommonsChunkPlugin({
      filename: "immutable-react-shared-bundle.js", 
      minChunks: immutableReactModuleFilter
    })

### 没有银弹！ ### 

`CommonsChunkPlugin()` 固然很强大，但要记住本文中的例子都是针对特定应用的。因此，在复制-粘贴这些代码片段之前，请先听听 [Sam Saccone](https://medium.com/@samccone) 、[Paul Irish](https://medium.com/@paul_irish) 和 [MPDIA](https://youtu.be/6m_E-mC0y3Y?t=11m38s) 的建议，避免用错了方法。

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/600/1*ca-C6QCv9ANIJ05lR8wm_w.png">

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/600/1*BGLLxCDDczXd9hxO47eTcw.png">

在应用解决方法之前，一定要理解方法背后的思路！

### 哪里还有更多例子？ ###

上述只是 `CommonsChunkPlugin()` 的部分用例，更多资源请参考我们 webpack/webpack core GitHub 仓库中的 `[/examples](https://github.com/webpack/webpack/tree/master/examples)` [目录](https://github.com/webpack/webpack/tree/master/examples)。如果你还有其他好想法，欢迎 [Pull Request](https://github.com/webpack/webpack/blob/master/CONTRIBUTING.md)！

没时间贡献代码？希望以其他方式做贡献？向[我们的 open collective](https://opencollective.com/webpack) 捐款，即刻成为赞助商。Open Collective 不仅为核心团队提供支持，同时也帮助那些为提升我们社区质量而花费了大量宝贵的空闲时间的贡献者们！❤

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
