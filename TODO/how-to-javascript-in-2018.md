> * 原文地址：[How to JavaScript in 2018](https://www.telerik.com/blogs/how-to-javascript-in-2018)
> * 原文作者：[Tara Z. Manicsic](https://www.telerik.com/blogs/author/tara-manicsic)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/how-to-javascript-in-2018.md](https://github.com/xitu/gold-miner/blob/master/TODO/how-to-javascript-in-2018.md)
> * 译者：[llp0574](https://github.com/llp0574)
> * 校对者：[MechanicianW](https://github.com/MechanicianW)、[ParadeTo](https://github.com/ParadeTo)

# 2018 如何玩转 JavaScript

![](https://d585tldpucybw.cloudfront.net/sfimages/default-source/default-album/js_870x220_2.png?sfvrsn=2cce35f7_1)

**从命令行工具和 webpack 到 TypeScript 和 Flow 等，让我们来谈一下在 2018 年如何玩转 JavaScript。**

去年包括我自己在内的许多人都在[讨论 JavaScript 疲劳症的问题](https://developer.telerik.com/topics/web-development/javascripts-journey-2016/)。实际上编写 JavaScript 应用的方法依然繁多，但在大量命令行工具处理了很多繁重工作的情况下，编译开始变得不那么重要，并且 TypeScript 试图减少类型错误，我们可以稍微轻松一点。

注意：这篇博文是我们白皮书的一部分，《[JavaScript 的未来：2018 及以后](https://www.telerik.com/campaigns/kendo-ui/wp-javascript-future-2018)》，里面讲述了我们对 JavaScript 未来的分析及近况的预测。

## 命令行工具

大多数库和框架都有[命令行工具](https://www.telerik.com/campaigns/aspnet-mvc/net-cli-reinvented)，一行命令就可以搭建好项目结构，快速创建我们期望的内容。这种做法通常包含一个开始命令（有时候会有一个自动加载器）、构建命令、测试结构等。当我们创建新项目的时候，这些工具可以减少大量的冗余文件。让我们来看看一些命令行工具帮助我们减少了什么东西。

### Webpack 配置

配置 webpack 构建过程并真正理解其中原理，可能是 2017 年最艰巨的学习曲线之一。值得感谢的是，webpack 其中一个核心贡献者 [Sean Larkin](https://twitter.com/thelarkinn)，到处在进行[很棒的演讲](https://www.youtube.com/watch?v=4tQiJaFzuJ8&t=3526s)，并提供[真正有趣且有用的教程](https://www.twitch.tv/videos/209664650?t=1h57m40s)给我们学习。

如今许多框架不仅会为你创建 webpack 配置文件，甚至还会把它们放到你根本不需要看的地方 😮。[Vue 的 CLI 工具](https://github.com/vuejs/vue-cli)甚至有一个[特定的 webpack 模板](https://github.com/vuejs-templates/webpack)，提供了一个功能齐全的 webpack 设置。为了全面让大家了解命令行工具到底提供了什么功能，下面是这个 Vue CLI 模板包含的内容，直接从官方仓库拿出来看：

*   `npm run dev`: 首选开发体验
    *   对单个文件的 Vue 组件使用 Webpack + `vue-loader`
    *   热重载保留状态
    *   编译错误覆盖保留状态
    *   保存文件时调用 ESLint
    *   源文件映射
*   `npm run build`: 生产环境准备构建
    *   用 [UglifyJS v3](https://github.com/mishoo/UglifyJS2/tree/harmony) 压缩 JavaScript
    *   用 [html-minifier](https://github.com/kangax/html-minifier) 压缩 HTML
    *   将所有组件的 CSS 提取到一个独立文件并用 [cssnano](https://github.com/ben-eb/cssnano) 压缩
    *   使用版本哈希编译的静态资源用于高效的长期缓存，并自动生成生产环境的 index.html，使用正确的 URL 指向这些资源
    *   使用 `npm run build --report` 进行构建，用于分析打包大小
*   `npm run unit`: 在 [JSDOM](https://github.com/tmpvar/jsdom) 里使用 [Jest](https://facebook.github.io/jest/) 运行单元测试，或者在 PhantomJS 里用 Karma + Mocha + karma-webpack 运行
    *   在测试文件里支持 ES2015+
    *   简单的数据模拟
*   `npm run e2e`: 用 [Nightwatch](http://nightwatchjs.org/) 做端对端测试
    *   在多个浏览器里并行运行测试
    *   一行命令开箱即用：
        *   自动处理 Selenium 和 chromedriver 的依赖
        *   自动生成 Selenium 服务器

另一方面，[preact-cli](https://github.com/developit/preact-cli#webpack) 负责标准的 webpack 功能。如果你需要自定义 webpack 配置的话只需要创建一个 `preact.config.js` 文件，这个文件会输出一个函数使得你的 webpack 产生变化。这么多的工具，这么多帮助，开发者互助 💞。

## 开启还是关闭 Babel

明白了吗？听起来像 Babylon 😂。我不禁笑出了声。我并不是**真的**要把 Babel 和 Babylon 古城联系在一起，但有[讨论](https://medium.freecodecamp.org/you-might-not-need-to-transpile-your-javascript-4d5e0a438ca)说它可能真的可以消除我们对编译的依赖。在过去几年里 Babel 真的可以说是一件大事，因为我们想要 ECMAScript 提出的所有闪光点，但又不想等待浏览器缓慢的支持。随着 ECMAScript 发布速度的减缓，浏览器支持有可能会追赶上。如果没有一些很棒的 [kangax 兼容性](https://twitter.com/kangax?lang=en)图表，又怎算是一篇 JavaScript 文章呢？

这些图表的图片看起来不那么易读，因为我想表达的只是它们几乎都是绿色！想知道完整细节的话只需点击图片下方的链接，从而深入审查这些图表。

[![look at all that green](https://d585tldpucybw.cloudfront.net/sfimages/default-source/blogs/2018/2018-02/compatibility-es6.png?sfvrsn=81c1b8d1_1)](https://d585tldpucybw.cloudfront.net/sfimages/default-source/blogs/2018/2018-02/compatibility-es6.png?sfvrsn=81c1b8d1_1)

[es6 的兼容性](http://kangax.github.io/compat-table/es6/)

[![still looking green](https://d585tldpucybw.cloudfront.net/sfimages/default-source/blogs/2018/2018-02/compatibility-2016.png?sfvrsn=43f89061_1)](https://d585tldpucybw.cloudfront.net/sfimages/default-source/blogs/2018/2018-02/compatibility-2016.png?sfvrsn=43f89061_1)

[es2016+ 的兼容性](http://kangax.github.io/compat-table/es2016plus/)

第一个图表里左边那些红色的块都是编译器(如 es-6 shim、Closure 等）和旧的浏览器（如 Kong 4.14 和 IE 11 等）。然后右侧的五个红色块都是服务器或编译器，如 PJS、JXA、Node 4、DUK 1.8 和 DUK 2.2 等。在较下面的图上，看起来像一只乱画的狗在看着乱七八糟感叹号的红色部分，是只包含 Node 6.5+ 支持的服务器或运行时。左边红色正方形的构成则是编译器或 polyfil 以及 IE 11 的支持。更重要的是，**看看那些绿色的部分！**在最流行的浏览器里，我们看到几乎都是绿色的。2017 特性仅有的红色标记是在 Firefox 52 的 ESR 对共享内存和原子化的支持。

从其他某些角度来看，下面是从 [维基百科](https://en.wikipedia.org/wiki/Usage_share_of_web_browsers) 得到的某些浏览器使用百分比。

[![browser user statistics](https://d585tldpucybw.cloudfront.net/sfimages/default-source/blogs/2018/2018-02/browser-user-statistics.png?sfvrsn=896a6611_1)](https://d585tldpucybw.cloudfront.net/sfimages/default-source/blogs/2018/2018-02/browser-user-statistics.png?sfvrsn=896a6611_1)

好吧，停用 Babel 可能还需要很长一段时间，因为我们还是尽最大可能让使用低版本浏览器的用户可以正常使用我们的应用。考虑到我们可能可以摆脱掉这个额外的步骤是很有趣的。你知道的，就像以前那样，当我们还没有使用编译器的时候 😆。

## 讨论 TypeScript

如果我们讨论要如何玩转 JavaScript，那么我们必须得讨论到 [TypeScript](https://www.typescriptlang.org/)。五年前 TypeScript 从微软工作室横空出世，但在 2017 年它已经成为一门很酷的语言 😎。很少有会议没有“为什么我们爱 TypeScript”这类主题的演讲，这就跟新的开发者万人迷一样。本文不再歌颂 TypeScript，让我们来讨论一下为什么如此看重它。

为了每个想要在 JavaScript 里使用类型的开发者，TypeScript 在这里提供了一个严格的 JavaScript 语法超集，赋予了可选的静态类型。如果你体验过，就会发现那是相当酷的。当然，如果你看一下 [JavaScript 状态](https://stateofjs.com/2017/introduction/)的最新调查结果，就会发现似乎事实上大量开发者都喜欢这么做。

[![JS Flavors Comparison](https://d585tldpucybw.cloudfront.net/sfimages/default-source/blogs/2018/2018-02/js-flavors-comparison.png?sfvrsn=14077aa8_1)](https://d585tldpucybw.cloudfront.net/sfimages/default-source/blogs/2018/2018-02/js-flavors-comparison.png?sfvrsn=14077aa8_1)

来自 [JavaScript 状态](https://stateofjs.com/2017/introduction/).

要想直接从源头找到它，可以看一下这段来自 Brian Terlson 的引用：

> 作为在 2014 年为 JavaScript 提出类型的人：我不相信类型会在不远的将来出现。从标准的角度看，这是一个非常复杂的问题。如果只是采取 TypeScript 作为标准，对于 TypeScript 用户来说当然是极好的，但还有其他类型的 JS 超集，包括 closure 编译器和 flow。这些工具全部表现得不一样，并且甚至不清楚是否有一个共同的子集（我不认为这有什么明显的意义）。我十分不确定类型的标准应该是什么样子，我和其他人会继续调研这个事情，因为它是非常有好处的，但不要期望在短时间内取得突破 - [HashNode AMA with Brian Terlson](https://hashnode.com/ama/with-brian-terlson-cj6vu9vjv01nmo1wu8vmtt1x9#cj6vuspfq01oso1wuhjo5zvd6)

### TypeScript ❤s Flow

在 2017 年，你可能看过许多[博文](http://thejameskyle.com/adopting-flow-and-typescript.html)讨论 TypeScript + Flow 的组合。[Flow](https://flow.org/) 是为 JavaScript 设计的一款静态类型检查器。正如你在上述 JavaScript 状态的调查图表里看到的那样，对 Flow 感兴趣和不感兴趣的人几乎一样多。更有趣的是统计数据还显示了接受调查的人里有多少人仍然没听说过 Flow ⏰。2018 年随着人们对 Flow 有更多的了解，他们会发现 Flow 和 [Minko Gechev](https://twitter.com/mgechev/status/940131449025347589) 一样有用：

> TypeScript & Flow 消除了 15% 的生产环境 bug！还认为类型系统没用吗？[https://t.co/koG7dFCSgF](https://t.co/koG7dFCSgF)
>
> — Minko Gechev (@mgechev) [December 11, 2017](https://twitter.com/mgechev/status/940131449025347589?ref_src=twsrc%5Etfw)

### Angular ❤s TypeScript

有人可能已经注意到 Angular 文档中所有示例代码都是用 TypeScript 编写的。一度你可以选择使用 JavaScript 或 TypeScript 浏览教程，但似乎 Angular 已经开始转变态度了。下面 Angular 和 JS 之间的连接图，可以看到实际上有更多用户将 Angular 连接到 ES6（TypeScript: 3777, ES6: 3997）。我们将在 2018 年看到所有这些因素是否会影响 Angular。

[![angular connections](https://d585tldpucybw.cloudfront.net/sfimages/default-source/blogs/2018/2018-02/angular-connections.png?sfvrsn=192c96f4_1)](https://d585tldpucybw.cloudfront.net/sfimages/default-source/blogs/2018/2018-02/angular-connections.png?sfvrsn=192c96f4_1)

来自 [JavaScript 状态](https://stateofjs.com/2017/introduction/).

对于如何为你的下个应用选择正确的 JavaScript 框架想要得到专业建议的话，可以看一下[这份很棒的白皮书](https://www.telerik.com/campaigns/kendo-ui/wp-javascript-future-2018)。

毋庸置疑，我们编写 JavaScript 的方式将在 2018 年发生变化。作为程序员，我们喜欢制作和使用让我们的工作更轻松的工具。不幸的是，这有时会导致更多的混乱和太多的选择。值得感谢的是，命令行工具正在帮助我们减轻一些繁琐的工作，并且 TypeScript 已经满足了那些对类型错误感到厌烦的开发者。

### JavaScript 的未来

想要深入了解我们在 JavaScript 方面的发展方向吗？查看我们的新文章，《JavaScript 的未来：2018 及以后》。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
