> - 原文地址：[The JavaScript Landscape in 2021](https://medium.com/javascript-in-plain-english/the-javascript-landscape-in-2021-573d5e7a43c6)
> - 原文作者：[Richard Bultitude](https://medium.com/@rbultitudezone)
> - 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> - 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/the-javascript-landscape-in-2021.md](https://github.com/xitu/gold-miner/blob/master/article/2021/the-javascript-landscape-in-2021.md)
> - 译者：[regon-cao](https://github.com/regon-cao)、[jaredliw](https://github.com/jaredliw)
> - 校对者：[PassionPenguin](https://github.com/PassionPenguin)、[Chorer](https://github.com/Chorer)、[Mordomo](https://github.com/Mordomo)

# 2021 年 JavaScript 的前景

![图片由 [Sergey Pesterev](https://unsplash.com/@sickle?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) 发布于 [Unsplash](https://unsplash.com/s/photos/landscape?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)](https://cdn-images-1.medium.com/max/17792/1*seEhUyV_-leofR3E1CYGwg.jpeg)

Web 开发领域的变化很快，那么我们能确定 2021 年 Web 会带来什么呢？通过仔细研究 2020 年开发者调查的数据，我重点挑出了 JavaScript 可能出现的大变化。

在深入讨论细节之前，先简要介绍一下 JavaScript 调查。遗憾的是，这份优秀的[《2019 年前端工具调查》](https://ashleynolan.co.uk/blog/frontend-tooling-survey-2019-results)的下一版在一段时间内不会发布，这使得探寻 JavaScript 的趋势变得有点困难。虽然我们可能失去了一个很好的调查，但一个新的调查 ——[《2020 年前端状态》](https://github.com/xitu/Annual-Survey/blob/main/2020/frontend/State-of-Frontend-2020-by-TSH.pdf) 出现并取代了它。虽然没有之前的年度数据帮助我们了解趋势，但它是由来自世界各地的 4500 名开发者填写的，所以绝对能够算得上是一份有价值的参考资料。

让我们深入了解我从数据中获得的一些看法。

## 包管理器

[去年](https://medium.com/engineered-publicis-sapient/the-javascript-landscape-in-2020-b8e5898b847e)，我曾建议关注下 [PNPM](https://pnpm.js.org/) 的崛起。这是一款旨在避免版本冲突的包管理器。此外，它也能够很好地与单体仓库（mono-repo）一起搭配使用。PNPM 拥有一大群[热情的支持者](https://medium.com/better-programming/the-case-for-pnpm-over-npm-or-yarn-2b221607119)，并在去年收获了 9.5k 的 star。它显然赢得了开发者的支持，但是，考虑到 [Yarn](https://yarnpkg.com/) 和 [NPM](https://www.npmjs.com/) 在实际项目中的集成程度和它们为发布新特性投入的精力，其中一些特性是直接针对 PNPM 开发的，尤其是 [Workspaces](https://classic.yarnpkg.com/en/docs/workspaces/)，我觉得 PNPM 不太可能在 2021 年[在使用量上与它们竞争](https://www.npmtrends.com/yarn-vs-pnpm-vs-npm)。这正好说明了竞争在推动开源软件向前发展是多么重要。

## 测试

2019 年，[Cypress](https://www.cypress.io/) 和 [Puppeteer](https://github.com/puppeteer/puppeteer) 脱颖而出，成为了高质量的新型测试工具，它们都在 2020 年继续获得了成功。然而，微软的新的端到端测试工具 [Playwright](https://github.com/microsoft/playwright) 横空出世，仅在 2020 年就获得了将近 2 万颗 star。作为世界上最大的软件公司之一，他们有能力来大范围推广自己的产品，但这只是工具流行的部分原因。主要原因还是它的特征集以及能方便地从 [Puppeteer](https://pptr.dev/) 迁移过来的特性。

![尽管 Playright 在 2019 年完全没有发布任何新特性，但它仍是新增 star 数量最多的测试框架之一](https://cdn-images-1.medium.com/max/2000/1*uYLDgxsDdacIUtiOnAWTFw.png)

自从 [Nadella](https://en.wikipedia.org/wiki/Satya_Nadella) 担任首席执行官以来，微软就养成了生产流行且强大的开源工具的习惯，如 [VSCode](https://2020.stateofjs.com/en-US/other-tools/#text_editors)。

## JavaScript 风格

我去年说过 [TypeScript](https://www.typescriptlang.org/) 正在逐渐地接管 JavaScript 的世界，这一趋势正在加剧。无数的开源项目都急切地将其列为受支持的特性。[2020 年收获 star 最多的 Github 项目](https://risingstars.js.org/2020/en#section-all) —— [Deno](https://deno.land/) 就内置了 Typescript 编译器。

去年我曾建议大家去关注 [PureScript](http://www.purescript.org/)，一款强制使用静态类型和函数式编程的语言。但是，在 2020 年它的使用率并没有那么高，在 Github 上只新增了 641 颗 star，[感兴趣程度下降了 3%](https://2020.stateofjs.com/en-US/technologies/javascript-flavors/)。看一下 TypeScript 和它的竞争者之间[在使用率方面的巨大差距](https://www.npmtrends.com/typescript-vs-elm-vs-coffee-script-vs-purescript-vs-reason)，感觉语言的战争已经结束，微软的产品已经胜出。在社区经过多年的深思熟虑和语言过多的氛围后，任何新的语言都很难再引起我们的注意。

看到社区在这一点上达成一致，我感到很欣慰。现在，我们要避免被不同的语言超集分散注意力，更多地关注语言本身。

## UI 框架

[Vue](https://vuejs.org/) 是 2019 年最受欢迎的框架，这在当时是一个大新闻，传递了一个明确的信息：开发者**喜欢**它。
[2020 年依然如此](https://risingstars.js.org/2020/en#section-framework)。然而，从 [NPM 下载量](https://www.npmtrends.com/react-vs-vue-vs-svelte)来看，[React](https://reactjs.org/) 的市场份额仍然很大。

![React 在过去一年的下载量](https://cdn-images-1.medium.com/max/2332/1*PJFyaoF6Bz3AKmt9Npzx6w.png)

另外，GitHub 上的标签和招聘广告也是两个有用的指标。目前 Github 上有超过 80k 个仓库带有 React 标签，而 Vue 只有 25k。纵观就业市场，去年 5 月 Career Karma 在 Indeed.com 上公布了 [10005](https://www.decise.com/q-React-Developer-jobs.html?vjk=2873485b3446c4bc) 个在美 React 开发者职位，而 Vue 只有 [1025](https://www.decise.com/q-Vue-Js-Developer-jobs.html?vjk=9216260d28c3fda3) 个。React 无处不在，并且竞争激烈。

在结束本节之前，我还需要提及 [Svelte](https://svelte.dev/) 和 [Angular](https://angularjs.org/)。Angular 仍然很受欢迎 —— [去年新增了 13.3k 的 star](https://risingstars.js.org/2020/en#section-framework)，并且在 NPM 上一周有差不多 250 万的下载量。考虑到 React 的主导地位，这可能会让一些人感到惊讶，但这些数据是值得认可的。相比之下，Svelte 非常年轻，但是[在《JavaScript 现状调查》的满意度排行榜上名列前茅](https://2020.stateofjs.com/en-US/technologies/front-end-frameworks/)。不管怎样，由于 React 和 Vue 的学习曲线陡峭，我预计它在 2021 年只会有适度的增长。

## 后端

静态站点生成框架和 API 生成框架放在一起构成了一个复杂的东西。如果我们将其拆开，只看纯服务器框架，我们可以看到 [Express](https://expressjs.com/) 仍然以 51.5k 的 star 处于领先地位。但是，[Nest](https://nestjs.com/) 到了 2020 年**新增的** star 数量达到了惊人的 10.3k，总数达到了 33.6k。开发人员之所以选择它，是因为他们被其高规范性的特点所吸引，这种特性可以加速开发并简化维护。对了，我应该有提到它采用了 TypeScript 吧？

纵观全栈框架的激增，在这一领域正进行着一场非常重要的心灵之战，因为它们对体系结构、性能和工作方式有着巨大的影响。两个基于 React 的框架，[NextJS](https://nextjs.org/) 还有 [Gatsby](https://www.gatsbyjs.com/)，在使用方面仍然比 VueJS 更受欢迎，但这只印证了我们对 UI 框架生态系统的了解。真正值得注意的是 [Gatsby 的满意度下降程度](https://2020.stateofjs.com/en-US/technologies/back-end-frameworks/)。有不确定的证据表明它有一个令人困惑的 [DX（开发者体验，Developer Experience）](https://medium.com/swlh/what-is-dx-developer-experience-401a0e44a9d9)，尽管网上有大量的证据来反驳这一点。NextJS 由 [Vercel](https://vercel.com/) 开发并在它的武器库中增加了静态站点生成这样的功能，我能看到它将在今年变得越来越强大。

## 构建工具

这个领域现在有一些值得注意的竞争。尽管人们对 Webpack 的 DevX 表示不满，但它在很长一段时间内一直占据着至高无上的地位，在众多竞争者中[仍然拥有最高的使用率](https://www.npmtrends.com/webpack-vs-gulp-vs-rollup-vs-parcel)。去年，我们看到 [Rome](https://github.com/rome/tools) 挑战了这个领域，今年我们有 [esbuild](https://github.com/evanw/esbuild)，[Snowpack](https://www.snowpack.dev/) 还有 Vite 登上了[**新增 star 数量最多**的排行榜](https://risingstars.js.org/2020/en#section-build)。esbuild 的任务很简单：加快构建时间。这对许多工程团队来说显然是非常有价值的，并解释了朝着这个方向发展的原因。

![esbuild 和 Snowpack 在《2020 年前端状态》中的构建工具榜上并列第一](https://cdn-images-1.medium.com/max/2000/1*LqoAdgne6TToTpeX4qBhYg.png)

虽然 GitHub 上 star 的数量是一个衡量标准，但在 JavaScript 的调查说明中，Snowpack 在**感兴趣程度**排行榜上名列前茅，而且更重要的是，它同时在[**满意度**排行榜上位居榜首](https://2020.stateofjs.com/en-US/technologies/build-tools/)。虽然 Snowpack 的使用率可能仍然很低，但我觉得它的时代来临了。Snowpack 和 Vite 的流行传递了一个重要的信息：原生 ES 模块正受到社区的重视。这是一个很大的话题，因为它涉及到构建过程、缓存和开发/生产模块的对称性。

## 状态管理

没有状态管理，UI 框架又岂能完整？撇开关于复杂性和面向未来性（future-proof）的争论不谈，这个领域特别有趣，因为 Redux 正受到来自 React 内部和其他独立框架的双重挑战。

从个人经验来说，React 的钩子和 Context API 的确很强大，但它们都有其局限性。不管怎样，它们肯定在 React 开发者中广受青睐，毕竟[几乎一半的前端状态调查的参与者](https://tsh.io/state-of-frontend/#frameworks/)都声称使用过它们。

![《2020 年前端状态调查》，状态管理类别](https://cdn-images-1.medium.com/max/2000/1*GbKC2D1NEt8Fj_bjNwHmKA.png)

## 结论

在去年的文章中，我探讨了**整合**这一主题。在经历了多年的模式、框架和库的分化之后，我们能感觉到这些模式和实践正在逐渐靠拢。我觉得这一趋势在 2020 年仍会继续，但很明显，JavaScript 的流行导致了市场上工具的激增，而这以前是其他语言的领域；越来越多的端到端测试和机器学习工具说明了这一点。

从 2020 年的数据中我们可以得到的关键内容是，JavaScript 的生态由大型软件供应商所决定。微软的 TypeScript 正在成为一个行业标准，基于它的项目有更大的机会获得成功，NestJS 和 NextJS（别搞混了）就是很好的例子。

受到 [JAMStack](https://jamstack.org/) 模式的影响和对速度的需求，静态站点生成器和 ESbuild 等工具正在迅速崛起。

在功能迭代、浏览器支持、运行时的快速发展和不断扩大的数字化范围影响下，我相信 JavaScript 的领域将不断扩大。

> 本文由 George Adamson 和 Joanne Parkes 助力提供校对。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
