> * 原文地址：[A Look Back at the State of JavaScript in 2017](https://medium.freecodecamp.org/a-look-back-at-the-state-of-javascript-in-2017-a5b7f562e977)
> * 原文作者：[Sacha Greif](https://medium.freecodecamp.org/@sachagreif?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/a-look-back-at-the-state-of-javascript-in-2017.md](https://github.com/xitu/gold-miner/blob/master/TODO/a-look-back-at-the-state-of-javascript-in-2017.md)
> * 译者：[LeviDing](https://leviding.com)
> * 校对者：[yanyixin](https://github.com/yanyixin)，[zhouzihanntu](https://github.com/zhouzihanntu)

# 2017 年 JavaScript 发展状况回顾

## 在 2017 年 JavaScript 状态调查结果出来之前，我们专家小组对 JavaScript 过去一年的发展进行了回顾

![](https://cdn-images-1.medium.com/max/1600/1*k7XARFeR0RqgZhY1p5w8uA.png)

[去年的 JavaScript 状况调查报告](http://stateofjs.com/2016/introduction/)的亮点之一就是，我们组建了一个专家小组对调查结果进行深入分析。

今年呢，我们决定换一种稍微不同的方法：用数据说话。

但是我仍然想知道我们之前专家组成员（以及两位新的特邀嘉宾）的看法，于是我联系了他们，问了些过去一年关于 JavaScript 的问题。

### 与专家组成员会面

![](https://cdn-images-1.medium.com/max/1000/1*Y54NpBPSXUyPr0p84xSVqg.jpeg)

* [Michael Shilman](https://medium.com/@shilman): [Testing](http://2016.stateofjs.com/2016/testing/)
* [Jennifer Wong](http://mochimachine.org): [Build Tools](http://2016.stateofjs.com/2016/buildtools/)
* [Tom Coleman](https://twitter.com/tmeasday): [State Management](http://2016.stateofjs.com/2016/statemanagement/)
* [Michael Rambeau](https://michaelrambeau.com/): [Full-Stack Frameworks](http://2016.stateofjs.com/2016/fullstack/)
* 特邀嘉宾 #1: [Wes Bos](http://wesbos.com/)
* 特邀嘉宾 #2: [Raphaël Benitte](https://twitter.com/benitteraphael) ([Nivo](http://nivo.rocks/#/) 的作者)

* * *

### 回顾下去年你写了些什么，关于这个特定领域你认为今后会如何发展

#### Michael Shilman

去年的调查报告显示，Jest 的 [NPM 下载量](https://npm-stat.com/charts.html?package=jest&package=jasmine&package=mocha&from=2016-11-10&to=2017-11-10)呈现出爆炸式增长，并且超过了 Jasmine。

Jest 支持 snapshot testing，我已经看到许多人将快照测试（snapshot testing）作为基本 input/output 单元测试的选择。这在 [Storyshots](https://github.com/storybooks/storybook/tree/master/addons/storyshots) 以及由 [Loki](https://loki.js.org/)、[Percy](https://percy.io/)、[Screener](https://screener.io/) 和 [Chromatic](https://blog.hichroma.com/introducing-chromatic-ui-testing-for-react-c5cc01a79aaa) 等工具构成的整个生态系统的 UI 领域更受欢迎。

#### Jennifer Wong

去年的调查报告也预测了 2017 年的一些发展趋势。随着各种新鲜事物的不断普及，Webpack 的发展势不可挡。Yarn 去年还不在调查对象之列，但是自从 9 月份首次发布以来，Yarn 的影响力就在不断扩大。我很好奇，看看 Yarn 和 npm 能擦出怎样的火花。

[![](https://cdn-images-1.medium.com/max/800/1*3sLM8_CMXFf7pdtPWI1YYw.png)](https://yarnpkg.com/)

Yarn

#### Tom Coleman

我不确定 Redux 真正的竞争对手是否已经出现，但或许在社区中有一种正如创建者 Dan Abramov 所说的趋势：“并不是每个应用都需要使用 Redux，而且在很多情况下使用 Redux 带来的问题的复杂性高于其所解决的问题”。

随着服务器数据管理工具（尤其是 GraphQL）的使用日益增加（请参阅 Apollo 和 Relay Modern），对复杂的客户端数据工具的需求可能会有所减少。看这些工具是如何逐步向本地数据支持发展将是一件非常有趣的事。

* * *

### 你在 2017 年用过什么新的 JavaScript 工具/库/框架等等吗？

#### Michael Shilman

我今年在测试领域发现的最好用的工具就是 [Cypress](https://www.cypress.io/)，[Cypress](https://www.cypress.io/) 是一个 OSS/商业上进行端到端（End-to-End）测试的一个很好的选择。尽管它现在还不是那么完善。

另外，我正在维护 [Storybook](https://storybook.js.org/)，这是 React、React Native 和 Vue 最流行的 UI 开发工具。

#### Jennifer Wong

我们正在将大部分前端代码转换为使用 React、Redux、Webpack 和 Yarn。这个过渡过程有趣也复杂，但这将会让今后的一些工作变得轻松不少。部分原因是共享设计系统和组件库的建立。

#### Tom Coleman

[Prettier](https://github.com/prettier/prettier)！没有这个工具我就写不了代码了。 我用 [Jest](https://facebook.github.io/jest/) 已经很长时间了，而且真的很好用。[Storybook](https://storybook.js.org/) 也是，使用的越来越频繁（并且开始帮助进行维护）。

[![](https://cdn-images-1.medium.com/max/800/1*mjiXB1CfVNcS5QFJKlvDXw.png)](https://prettier.io/)

Prettier

此外，我一直在开发一个名叫 [Chromatic](https://blog.hichroma.com/introducing-chromatic-ui-testing-for-react-c5cc01a79aaa) 的 Storybook 可视化回归测试（regression testing）工具。当看到一些公司（包括我自己的）使用这个工具完成前端测试，我真的是十分高兴。

#### Michael Rambeau

我在 2017 年发现的最喜欢的工具是 [Prettier](https://github.com/prettier/prettier)。它让我写代码时不用再担心代码“风格”了，节省了我大量时间。

我不再关心 tab 和代码是否整齐这类问题，只需在 IDE 中按下 Ctrl S，一切就都格式化了！此外，它还可以减少与其他团队成员在相同一个代码库上进行协作时的冲突。

#### Wes Bos

各种各样的东西！[date-fns](https://date-fns.org/) 让我放弃了对 [moment.js](https://momentjs.com/) 的使用。[Next.js](https://github.com/zeit/next.js/) 对于构建服务端渲染的 React 应用越来越重要。我也在学习如何将 Apollo 与 GraphQL 一起用好。

#### Raphaël Benitte

同时服务于几个开源项目，并且要兼顾工作，提高项目的自动化程度就显得尤为重要。Prettier、ESLint、Jest、[Validate-commit-msg](https://github.com/willsoto/validate-commit) 和 [Lint-staged](https://github.com/okonet/lint-staged) 在这方面确实很有用。

我还为 React 构建了一个名叫 [Nivo](http://nivo.rocks/#/) 的数据可视化的库。

[![](https://cdn-images-1.medium.com/max/800/1*Dwl7zseAHT2n6W63COQiUA.png)](http://nivo.rocks/#/)

最后，随着原生的 Node.js 对 Async/Await 的支持越来越好，我也尝试使用了 [Koa](http://koajs.com/)。虽然其生态系统比 Express 更窄，但我发现它很容易上手，而且如果你熟悉 Express，那就不会有陌生感。

* * *

### 如果有人想从头开始学习 JavaScript，那么你会推荐他专注于哪三种技术呢？

#### Michael Shilman

* React for UI.
* Webpack for build.
* Apollo for networking.

#### Jennifer Wong

任意一种框架、任意一种构建工具和 Node。许多概念都是在框架和构建工具之间进行转换的，所以你仔细学习其中之一，还会对你理解其他的内容有帮助。如果必须要我选一个框架和构建工具，我应该会选 React 和 Webpack，因为它们正在趋势化，并且在业内看来，他们的发展趋势也很不错。

#### Tom Coleman

当然是 React，尽管其他前端相关的东西也很有意思，但是 React 生态系统相当庞大且完善。这是你必须掌握的技术。

GraphQL，我认为大多数有经验的前端开发都能认识到，GraphQL 所能解决的问题非常广，并且用起来也很舒服。

[![](https://cdn-images-1.medium.com/max/800/1*slDxUJmZvHd-wV4GsAJmAw.png)](http://graphql.org/)

GraphQL

Storybook，我认为从组件构建其状态是应用程序开发的未来，而 Storybook 就是这样做的。

#### Michael Rambeau

* 前端部分：React
* 后端部分：Express
* 前后端测试部分：Jest

#### Wes Bos

如果你还在学习阶段，你需要通过一些小小的成就感来保持你对这门语言的兴趣。所以我只说些基础知识，学习 DOM API，学习 Async 和 Await，并学习新的可视化 API，如网页动画等。

#### Raphaël Benitte

* 如果你是个 JavaScript 方面的小白，那就从基础学起吧，并且 ES6 现在已经是 JavaScript 基础的一部分了。
* 当然还有 React for building UIs
* [GraphQL](http://graphql.org/)正在走向成熟，现在已经被 Facebook、GitHub、Twitter 和 [其他很多大公司](http://graphql.org/users/) 使用…

* * *

### 现在你在 JavaScript 方向最大的痛点是什么

#### Michael Shilman

最佳实践方法和怎么选 CSS-in-JS 的库。虽然有很多不错的选择，但感觉仍然碎片化，并且现在还有很多人在做 CSS-in-CSS，所以有很多痛点。

#### Jennifer Wong

不断的变化。当我学习一项新技术的时候，我们正在走向下一个。 另外，停止偷我的CSS，JavaScript！前端这块技术是日新月异，学了这个又有新的蹦出来了。喂 JavaScript 你就别来抢我 CSS 的饭碗了，中不中？

#### Tom Coleman

Webpack。卓越强大的工具在"越配置越方便"的错误观念道路下越走越远了。

要避免学习复杂的 JS 应用程序是非常困难的，但通常情况下，你不用太纠结于这些细枝末节。我仍然希望 Meteor 能够重得宝座，成为构建现代 JS 应用程序的最佳方式。

#### Michael Rambeau

缺乏标准，在开始一个新项目之前选择技术栈时，需要考虑方方面面。但是这种状况正在逐步改善。

#### Wes Bos

`checking && checking.for && checking.for.nested && checking.for.nested.properties`。我知道这里有一些实用的功能，但是看起来我们可能很快就会用到这个语言。

#### Raphaël Benitte

有太多的工具了...选择合适的工具太困难，我们必须非常小心，因为 JS 生态系统中的趋势变化速度太快。

* * *

### 你最期待 JavaScript 生态系统在 2018 年中有什么发展？

#### Michael Shilman

心愿单（不知道这些会不会在 2018 年发生）：

* GraphQL 在数据同步方面的方便程度达到 Meteor 的水平。
* React Native 的通用（Web 端/移动端）稳定性得到提升。
* Cypress 或其他端到端的测试工具出现。

#### Jennifer Wong

稳定性。我掐指一算啊，JavaScript 栈和 JavaScript 社区会平静一段时间，我们会进入到一个流失度较低的新阶段。

#### Tom Coleman

Babel 的末日到了！我很喜欢 Babel，但是自从有了 Node 8，babel 就被我嫌弃了。能够再次和 interpreter 合作简直太棒了。

很显然，ES 标准将继续向前发展，但是随着 JavaScript modules 和 async/await 的很多痛点被解决掉，JS 新版本和 node 及所有现代浏览器融合度的提升，很多项目会在短时间内发展的非常好。

#### Michael Rambeau

我很想看看 GraphQL 是如何发展的。它会在发布新的 API 的时候成为标准吗？

#### Wes Bos

既然 Node 已经稳定并且所有浏览器都有了 Async 和 Await，我期待原生 promise 在众多框架、工具库和你日常编写的代码中越来越普遍。

#### Raphaël Benitte

大多数语言都有一个 专用/首选 的构建工具（例如 Java 的 Maven）。尽管在 JavaScript 方面我们有很多选择，但这些解决方案往往是专门用于前端的。我希望看到 npm（或 Yarn）添加对基本功能的支持，如文档，自动完成，脚本依赖等。否则，我可能会继续使用 GNU Make。

虽然这个问题很有争议，但是我们已经看到有人对 [TypeScript](https://www.typescriptlang.org/) （或 [Flow](https://flow.org/)） 很感兴趣。Node.js 和浏览器已经明显加快了发展速度，但是如果你想要静态类型的话，你仍要为它再添加一个编译转换层。那么原生静态类型的 Javascript 呢？ 你可以在 [这儿](https://esdiscuss.org/topic/es8-proposal-optional-static-typing)  找到关于这个的讨论。

* * *

### 总结

通过上面的内容，我们的小组有几点一致性意见：React 是一个明智的选择，Prettier 是一个很好的工具，JavaScript 生态系统仍然太复杂了...

这正是我们做这个调查的时候试图找到的问题。

我们很快就会在我们的网站上将报告发布出来。 大概在 12 月 12 号之后的那周吧。

我们将举行[直播 + Q＆A 环节](https://medium.com/@sachagreif/announcing-the-stateofjs-2017-launch-livestream-14e4aeeeec3a)，所以大家可以在那问你想问的问题 - 或者就过来看看呗。我们还有可能为大家带来神秘嘉宾哟... :)

如果你想知道活动啥时候开始，结果是啥，你想收到及时的通知的话可以[在这留下您的 Email](http://stateofjs.com/)，我们会通知你的。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
