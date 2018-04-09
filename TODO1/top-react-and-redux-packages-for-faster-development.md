> * 原文地址：[Top React and Redux Packages for Faster Development](https://codeburst.io/top-react-and-redux-packages-for-faster-development-5fa0ace42fe7)
> * 原文作者：[Arfat Salman](https://codeburst.io/@arfatsalman)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/top-react-and-redux-packages-for-faster-development.md](https://github.com/xitu/gold-miner/blob/master/TODO1/top-react-and-redux-packages-for-faster-development.md)
> * 译者：[刘嘉一](https://github.com/lcx-seima)
> * 校对者：[wznonstop](https://github.com/wznonstop)

# React & Redux 顶级开发伴侣

![](https://cdn-images-1.medium.com/max/2000/1*mOfFxGkE0FP-eQ30xoYxlQ.jpeg)

图注：选自 [Unsplash](https://unsplash.com/search/photos/tools?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)，由 [Fleur Treurniet](https://unsplash.com/photos/dQf7RZhMOJU?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) 拍摄

React 已成为近年来最炙手可热的前端开发框架。围绕 React 生态涌现了一系列趁手的辅助开发工具，它们的出现能进一步提高我们的开发效率。要知道，我们也一直期望使用的开发工具可以

![](https://cdn-images-1.medium.com/max/800/1*lUkZYUKtkykpHNIOz3c0gg.gif)

图注：选自 [Giphy](https://gph.is/1VO6H7f)

如果你刚踏入 React 开发大门，那对你来说下面介绍的工具包都还蛮有用，它们可以在调试应用或者可视化应用中的抽象逻辑时帮上大忙。

话不多说，让我们开始吧！

### React Storybook

在你开发 React 应用时，总会有这样的念头涌上心头：**面对一些你使用或正在编写的组件，要是能直观地看到它们在不同 prop、state 和 action 的组合下所呈现的渲染效果就好了。** 嗯，Storybook 正是这样一个你想要的工具。

React Storybook 为 React 搭建了可视化开发环境。**你可以使用它展示一个组件库，并查看各个组件在不同状态下的渲染效果，通过与组件进行交互你可以更好地开发和测试。** 使用 Storybook 可以观察变化的 state 和 prop 对组件渲染的影响，加快了组件原型的开发。[点此](https://github.com/storybooks/storybook) 查看 Storybook 的 GitHub 仓库。

Storybook 提供的 [官方示例](https://storybook.js.org/examples/) 不容错过。

![](https://cdn-images-1.medium.com/max/800/1*TxuoKupMwNqsEKyrCdB9cQ.gif)

图注：Storybook [仓库](https://github.com/storybooks/storybook) 中的 Demo

**Stroybook 其他亮点如下 ——**

*   Storybook 独立运行，不干扰你的应用。
*   这使得组件能够独立于应用进行开发。
*   这意味着你在开发组件时不需要操心任何依赖相关的问题。

这里还有一些与 Stroybook 类似的工具：[React Cosmos](https://github.com/react-cosmos/react-cosmos)，[React Styleguidist](https://github.com/styleguidist/react-styleguidist)

### React Dev Tools

这是 React 界最负盛名的开发工具包。**使用它可以让你像审查 HTML 元素一样审查 React 组件和组件之间的层级关系，包括审查组件的 prop 和 state 情况。** 除此之外，你还可以使用正则表达式搜索、审查特定的组件，并通过使用 “**Highlight Updates**” 这样精妙的功能查看选中的组件是如何影响其他组件渲染的。

![](https://cdn-images-1.medium.com/max/800/1*9XrmfPqh_naIBlTi7dv3Hw.gif)

图注：React Dev Tools Demo

你可以将 React Dev Tools 添加为 Google Chrome 的 [extension](https://chrome.google.com/webstore/detail/react-developer-tools/fmkadmapgofadopljbjfkapdkoienihi) 或 Firefox 的 [add-on](https://addons.mozilla.org/firefox/addon/react-devtools/)。同样，你也可以下载 [软件包](https://github.com/facebook/react-devtools/tree/master/packages/react-devtools) 将 React Dev Tools 作为独立应用装到本地，独立安装与添加 extension（或 addon）一样都非常简单易于上手。以 Chrome 为例，当你安装完成后，Chrome Developers Tools 页面会新增一个 “React” 标签。

![](https://cdn-images-1.medium.com/max/800/1*3qBkNUef0uvzZvI_U8ZhLA.gif)

图注：React Dev Tools 中的 Highlight Updates 功能

**使用秘诀 ——**

*   **Highlight Updates：** 注意观察上面 GIF 图中 **Submit** 按钮下方出现的彩色线条。这表明每当我在 input 中进行输入，**整个组件都会被重新渲染！**
*   在相互独立的组件范围内，如果在某个组件上触发的 action 会同时触发其他组件进行重新渲染，这样的行为显然不太合理，其背后的原因需要好好琢磨。
*   大多数情况下，组件都被设计得过于庞大，若把这些大组件重构为更小、模块性更高的数个小组件更为合适。
*   你可以在工具面板右侧看到组件当前的 prop 和 state（email 和 password）。这个功能的确很酷，你可以在这观察到 app 中任意一处的 state 变化及其产生的影响。

### Why did you update？

我们在上一节中提到了组件冗余重渲的问题，不过想一眼看出某个组件的重新渲染是否多余却并不那么容易。幸好有这么一个工具包替你承包了这项工作，**每当有组件进行不必要重渲的时候，它会在控制台进行提醒。** 该工具包会跟踪组件的 prop 和 state 状态，若组件在任一状态未发生变化的情况下进行了重渲，那么该工具包就会在控制台打印出相关信息。它的 GitHub 地址在 [这儿](https://github.com/maicki/why-did-you-update)，另外要记住不要在生产环境时使用该包。

![](https://cdn-images-1.medium.com/max/800/1*CL5jum98a0QxOWeIb9QRBg.png)

图注：[Why did you update](https://github.com/maicki/why-did-you-update) 官方示例图

### Create React App（CRA）

严格意义上来讲这并不是一个开发工具，但是多年的使用让我发现它是快速创建 React 原型项目的不二人选。设置好一个 React 项目的开发环境并不简单，其中包含的众多依赖包如 Babel、webpack 等，对于新手来说都不是一下就能弄明白的。为此，我专门写了 **Yet another Beginner’s Guide to setting up a React Project** 系列文章，包含 [Part 1](https://codeburst.io/yet-another-beginners-guide-to-setting-up-a-react-project-part-1-bdc8a29aea22) 和 [Part 2](https://codeburst.io/yet-another-beginners-guide-to-setting-up-a-react-project-part-2-5d3151814333) 两部分内容。在文章中我讲解了 JSX、Babel 和 webpack 的概念以及为何使用它们。

在弄清楚这些基础概念后，每每创建一个新的项目，你都需要重复一系列相同的开发环境设置工作。而且，你还 **有可能** 需要同时创建多个这样的项目。因此，为了节约开发者的时间，Facebook 把所有的繁琐工作都封装到了一个工具包中，[点此](https://github.com/facebook/create-react-app) 了解一下。

![](https://cdn-images-1.medium.com/max/800/1*O1N_DRWt0EKJ-uzBTNE-tg.png)

图注：成功运行 create-react-app 的返回结果

* * *

你有极大可能选择了 [Redux](https://redux.js.org/) 来管理你 React 应用中的 state，下面将介绍一些专属 Redux 的工具 —

### Redux Dev Tools

像 React 一样，Redux 也有它的 Dev Tools，也同样可以通过 Chrome [Extension](https://github.com/zalmoxisus/redux-devtools-extension) 或 Firefox [addon](https://github.com/zalmoxisus/redux-devtools-extension) 进行安装。它的功能有 ——

*   你可以使用它审查每个 state 和 action payload。
*   你可以使用它及时 “取消” 发出的 action 以回退到之前的状态，这个功能也被称作 **调试时光机。** Redux Dev Tools 的作者 [Dan Abramov](https://medium.com/@dan_abramov) 自行制作了一个不错的 [视频](http://youtube.com/watch?v=xsSnOQynTHs) 来演示时光机功能。
*   如果你中途改变了 reducer 的代码，所有已经被记录下来的 action 都会按照新的 reducer 重新计算。
*   如果 reducer 代码抛异常了，你可以看到发生异常时的 action 和具体的错误信息。
*   Dev tools 的日志界面（LogMonitor）可以完全按照你的意愿进行定制。因为它本质上就是个 React 组件，所以定制它并不是什么难事。作者 [Dan Abramov](https://medium.com/@dan_abramov) 也强烈建议你 [定制](https://github.com/gaearon/redux-devtools/issues/3) 属于自己的 LogMonitor。

由其他开发者分享的定制 LogMonitor 有：[Diff Monitor](https://github.com/whetstone/redux-devtools-diff-monitor)、[Inspector](https://github.com/alexkuz/redux-devtools-inspector)、[Filterable Log Monitor](https://github.com/bvaughn/redux-devtools-filterable-log-monitor/) 和 [Chart Monitor](https://github.com/romseguy/redux-devtools-chart-monitor)。

![](https://cdn-images-1.medium.com/max/800/1*lAp8ZAk5uNFTuxjhx4GTdw.gif)

### redux-immutable-state-invariant

由于有函数式编程风格和 redux 机制上的限制，[我们永远都不应该直接 “修改” state 的值](https://redux.js.org/troubleshooting#never-mutate-reducer-arguments)。**不过话说回来，我们并不好区分何时是在显式 “修改” state 值，而何时是在 “替换” state 值。**

这里推荐的 redux 中间件可以确保你远离不经意间的 “修改”，若你确实 “修改” 了 state 值，该中间件会直接抛出相应的异常进行提醒。更多相关内容 [点此](https://github.com/leoasis/redux-immutable-state-invariant) 查看。

![](https://cdn-images-1.medium.com/max/1000/1*oOB0xSGDesQrkgAmMawR-Q.png)

图注：“修改” state 值时将抛出错误

**使用秘诀 ——**

*   需要确保 state 中不含任何不可以序列化的值，如函数。否则，中间件会抛出 `RangeError: Maximum call stack size exceeded` 异常。
*   需要确保 **不要** 在生产环境中使用该中间件，因为它包含了很多对象复制的工作，会拖慢你的线上应用。

### redux-diff-logger

无论你是使用 `console.log` 打印 state，还是使用 [`debugger`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/debugger) 启动 dev tools 审查、调试 state，你其实都是想捕捉 state 中前后 **发生变化的值**。Redux diff logger 正能肩负此任，**它会打印出 state 中所有发生变化的值。**

![](https://cdn-images-1.medium.com/max/800/1*dwqA2l5S7nKPjY8cOoL1rA.png)

图注：[redux-diff-logger](https://github.com/evgenyrodionov/redux-diff-logger) 官方示例图

要是你并不是只想看到发生变化的值，而是想 “纵观全局”。那么你也太走运了，**作者还分享了另一个 logger 工具**：[redux-logger](https://github.com/evgenyrodionov/redux-logger)。

* * *

我还写了 [Top Webpack Plugins for faster development](https://codeburst.io/top-webpack-plugins-for-faster-development-a2f6accb7a3e)，其中罗列了一堆改善 “开发生活质量” 的 webpack 插件。

* * *

[我们的团队](https://goo.gl/gePhPg) 一直欢迎有才能、富有好奇心的朋友加入。

**我每周都会写一些关于 JavaScript、web 开发或计算机科学内容的文章，快来关注我吧。**

**在这些地方可以找到我 @** [**Facebook**](https://www.facebook.com/arfat.salman) **@** [**Linkedin**](https://www.linkedin.com/in/arfatsalman/) **@** [**Twitter**](https://twitter.com/salman_arfat)**。**

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
