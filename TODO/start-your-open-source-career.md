> * 原文地址：[Start your open-source career](https://blog.algolia.com/start-your-open-source-career/)
> * 原文作者：[Vincent Voyer](https://github.com/vvo/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/start-your-open-source-career.md](https://github.com/xitu/gold-miner/blob/master/TODO/start-your-open-source-career.md)
> * 译者：[zwwill 木羽](https://github.com/zwwill)
> * 校对者：[刘文哲](https://github.com/NeoyeElf)、[SeanW20](https://github.com/SeanW20)

# 开启你的开源生涯

今年我做了一次关于如何让开源项目获得成功的演讲，讨论如何通过做好各方面的准备，来确保让我们的开源项目吸引各种各样的贡献，包括提问、撰写文档或更新代码。之后我获得一个反馈信息，「你展示了如何让开源项目成功，这很棒，但**我的开源之路究竟该从何入手呢**」”。这篇文章就是对这个问题的回答，它解释了如何以及从何开始为开源项目做出贡献，以及如何开源自己的项目。

这里所分享的知识都是有经验可寻的：在 [Algolia](https://github.com/algolia) 中我们已经发布并维护了多个开源项目，时间证明这些项目都是成功的，我也花费了大量的时间来参与和创立新的[开源项目](ttps://github.com/vvo)。

## 千里之行始于足下

![](https://blog.algolia.com/wp-content/uploads/2017/12/Pastebot-Dragged-Image-21-12-2017-140501-2.png)

六年前在 [Fasterize](https://www.fasterize.com/en/) （一个网站性能加速器供应商），我职业生涯的关键时刻。我们在 [Node.js](https://nodejs.org/en/) workers 上遇到了严重的 [内存泄露问题](https://en.wikipedia.org/wiki/Memory_leak)。在检查完除 Node.js 源码外的所有代码后，我们并没有发现任何可造成此问题的线索。我们的变通策略是每天重启这些 workers 以释放内存，仅此而已，但我们知道这并不是一个优雅的解决方案，因此**我想整体地去了解这个问题**。

当我的联合创始人 [Stéphane](https://www.linkedin.com/in/stephanerios/) 建议我去看看 Node.js 的源码时，我几乎要笑出来。心想：「如果这里有 bug，最大的可能是我们的，而不是那些创造了革命性服务端框架的工程师们造成的。那好吧，我去看看」。两天后，我的两个针对 Node.js http 层的[修复请求](https://github.com/nodejs/node-v0.x-archive/pull/3181#issue-4313777)被通过合并，同时解决了我们自己的内存泄露问题。

这样做让我信心大增。在我敬重的其他 30 个对 http.js 文件作出贡献的人中，不乏 [isaacs](https://github.com/isaacs/) （npm 的创造者）这样优秀的开发者，这让我明白，代码就是代码，不管是谁写的。

你是否正在经历开源项目的 bug？深入挖掘，不要停留在你的临时解决方案。你的解决方案会让更多人受益并且获得更多开源贡献。**读别人的代码**。你可能不会马上修复你的问题，它可能需要一些时间来理解，但是您将学习新的模块、新的语法和不同的编码形式，这都将促使你成为一个开源项目的开发者。

## 车到山前必有路

[![First contributions labels on the the Node.js repository](https://blog.algolia.com/wp-content/uploads/2017/12/image6.png)](https://blog.algolia.com/wp-content/uploads/2017/12/image6.png)

_[Node.js 仓库](https://github.com/nodejs/node/labels/good%20first%20issue)上的首次贡献的标签_

「我毫无头绪」是那些想为开源社区做贡献但又认为自己没有好的灵感或项目可以分享的开发者们共同的槽点。好吧，对此我想说：that’s OK。是有机会做开源贡献的。许多项目已经开始通过标注或标签为初学者列出优秀的贡献。

你可以通过这些网站找到贡献的灵感：[Open Source Friday](https://opensourcefriday.com/), [First Timers Only](http://www.firsttimersonly.com/), [Your First PR](https://yourfirstpr.github.io/), [CodeTriage](https://www.codetriage.com/), [24 Pull Requests](https://24pullrequests.com/), [Up For Grabs](http://up-for-grabs.net/) 和 [Contributor-ninja](https://contributor.ninja/) (列表出自 [opensource.guide](https://opensource.guide/how-to-contribute/#finding-a-project-to-contribute-to)).

## 构建一些工具

工具化是一种很好的方式来发布一些有用的东西，而不必过多的考虑一些复杂的问题和 API 设计。您可以为您喜欢的框架或平台发布一个模板，将一些博客文章中的知识和工具使用姿势汇集到这个项目中进行诠释，并准备好实时更新和发布新特性。[create-react-app](https://github.com/facebookincubator/create-react-app) 就是一个很好的例子🌰。

[![Screenshot of GitHub's search for 58K boilerplate repositories ](https://blog.algolia.com/wp-content/uploads/2017/12/image5-2.png)](https://blog.algolia.com/wp-content/uploads/2017/12/image5-2.png)

_在 GitHub 上有大约 [五万九千个模板](https://github.com/search?utf8=%E2%9C%93&q=boilerplate&type=) 库，发布一个并不是难事反而对你有益_

现在，你仍然可以像我们给 Atom 构建[模版自动化导入插件](https://blog.algolia.com/atom-plugin-install-npm-module/)那样对 [Atom](https://github.com/blog/2231-building-your-first-atom-plugin) 和 [Visual Studio Code](https://code.visualstudio.com/docs/extensions/overview) 进行构建纯 JavaScript 插件。那些在 Atom 或者 Sublime Text 中已经存在了的优秀插件是否还没有出现在你最爱的编辑器中？**那就去做一个吧**。

你甚至可以为 [webpack](https://webpack.js.org/contribute/writing-a-plugin/) 或 [babel](https://github.com/thejameskyle/babel-handbook) 贡献插件来解决 JavaScript 技术栈的一些特殊用例。

好的一面是，大多数的平台都会说明**如何创建和发布插件**，所以你不必太过考虑怎么做到这些。

## 成为新维护者

当你在 GitHub 上浏览项目时，你可能时常会发现或者使用一些**被创建者遗弃的项目**。他们仍然具有价值，但是很多问题和 PRs 被堆放在仓库中一直没有得到维护者的反馈。**此刻你该怎么办**？

* 发布一个新命名的分支
* 成为新的维护者

我建议你同时做掉这两点。前者将帮助推进你的项目，而后者将使你和社区受益。

你可能会问，怎样成为新的维护者？发邮件或者在 Twitter 上 @ 现有维护者，并且对他说「你好，我帮你维护这个项目怎么样？」。通常都是行之有效的，并且这是一个很好的方法能让你在一个知名且有价值的项目上开启自己的开源生涯。

[![Example message sent to maintain an abandoned repository](https://blog.algolia.com/wp-content/uploads/2017/12/image2-2.png)](https://blog.algolia.com/wp-content/uploads/2017/12/image2-2.png)

_[示例](https://twitter.com/vvoyer/status/744986995630424064)：去复兴一个遗弃的项目_

## 创建自己的项目

发掘自己项目的最好方法就是**关注一些如今还没有很好解决的问题**。如果你发现，当你需要一个特定的库来解决你的一个问题而未果时，此刻便是你创建一个开源库的最佳时机。

在我职业生涯中还有另外一个**关键时刻**。在 Fasterize，我们需要一个快速且轻量级的图片懒加载器来做我们网站性能加速器，它并不是一个 jQuery 插件，而是一个可在其他网站加载并生效的独立项目。我找了很久也没在整个网络上找到现成的库。于是我说「完了，我没找到一个好的项目，我们没法立项了」。

对此，斯蒂芬回应说「好吧，那我们就创造一个」。嗯～～好吧，我开始复制粘贴一个 [StackOverflow 上的解决方案](https://stackoverflow.com/questions/3228521/stand-alone-lazy-loading-images-no-framework-based) 到 JavaScript 文件夹中，创建了一个[图片懒加载器](https://github.com/vvo/lazyload) 并最终用到了像 [Flipkart.com](https://en.wikipedia.org/wiki/Flipkart) （每月有 2 亿多访问量，印度网站排行第九） 这样的网站上。经过这次成功的实践后，我的思维就被联结到了开源。我突然明白，开源可能是我开发者生涯的另外一部分，而不是一个只有传说和神话的 [10x 程序员](http://antirez.com/news/112)才胜任的领域。

[![Stack Overflow screenshot ](https://blog.algolia.com/wp-content/uploads/2017/12/image1-3.png)](https://blog.algolia.com/wp-content/uploads/2017/12/image1-3.png)

_一个没有很好解决的问题: 以可重用的方式解决它!_

**时间尤为重要**。如果你决定不构建可重用的库，而是在自己的应用程序中内联一些代码，那就错失良机了。可能在某个时候，别人将创建这个本该由你创建的项目。不如即刻从你的应用程序中提取并发布这些可复用模块。

## 发布，推广，分享

为了确保每个有需要的人都乐意来找到你的模块，你必须：

* 撰写一个良好的 [README](https://opensource.guide/starting-a-project/#writing-a-readme)，并配有[版本徽章](https://shields.io/)和知名度指标
* 为项目创建一个专属且精心设计的在线展示网站。可以在 [Prettier](https://github.com/prettier/prettier) 中找一些灵感
* 在 StackOverflow 和 GitHub 中找到与你已解决问题的相关提问，并将贴出你的项目作为答案
* 将你的项目投放在 [HackerNews](https://news.ycombinator.com/submit), [reddit](https://www.reddit.com/r/programming/)，[ProductHunt](https://www.producthunt.com/posts/new)， [Hashnode](https://hashnode.com/) 或者其他汇集开源项目的社区中
* 在你的新项目中投递关于你的平台的关联信息
* 参加一些讨论会或者做演讲来介绍你的项目

[![Screenshot of Hacker News post](https://blog.algolia.com/wp-content/uploads/2017/12/image4-2.png)](https://blog.algolia.com/wp-content/uploads/2017/12/image4-2.png)

_向全世界展示你的新项目_

**不要害怕在太多网站发布信息**，只要你深信自己创造出来的东西是有价值的，那么再多的信息也不为过。总的来说，开源社区是很欢迎分享的。

## 保持耐心持续迭代

在「知名度指标」（star 数和下载数）上，有些项目会在第一天就飞涨，之后便早早地停止上涨了。另外一些项目会在沉淀一年后成为头条最热项目。相信你的项目会在不久后被别人发掘，如果没有，你也将学会一些东西：可能对于其他人来说它是无用的，但对于你的下一个项目来说它将是你的又一笔财富。

**我有很多 star 近似为 0 的项目，比如 [mocha-browse](https://github.com/vvo/mocha-browse)**，但我从不失望，因为我并没有很高的期望。在项目开始是我就这么想：我发现一个好问题，我尽我所能地去解决它，可能有些人会需要它，也可能没有，那又有什么大不了的。

## 一个解决方案的两个项目

这是我在做开源中最喜欢的部分。2015年在 Algolia，我们在寻找一种解决方案可以单元测试和冻结我们使用 [JSX](https://reactjs.org/docs/jsx-in-depth.html) 输出的 html，以便我们为写 React 组件生成我们的 React UI 库 [InstantSearch.js](https://community.algolia.com/instantsearch.js/)。

由于 JSX 被编译成 function 调用的，因此我们当时的解决方案是编写方法 `expect(<Component />).toDeepEqual(<div><span/></div>)`，也只是比较两个 function 的调用输出，但是这些调用输出都是复杂的对象树，在运行时可能会输出`Expected {-type: ‘span’, …}`。输入和输出比较是不可行的，而且开发者在测试时也会抓狂。

为了解决这个问题，我们创建了 [algolia/expect-jsx](https://github.com/algolia/expect-jsx)，他让我们可以在单元测试中使用 JSX 字符串做比较，而不是那些不可读的对象树。测试的输入和输出将使用相同的语义。我们并没有到此为止，我们并不是仅仅发布一个库，而是两个库，其中一个是在第一个的基础上提炼出来的。

* [algolia/react-element-to-jsx-string](https://github.com/algolia/react-element-to-jsx-string) 将JSX函数返回转换为 JSX 字符串
* [algolia/expect-jsx](https://github.com/algolia/expect-jsx) 用于关联 react-element-to-jsx-string 和断言库 [mjackson/expect](https://github.com/mjackson/expect)

通过发布两个共同解决一个问题的模块，你可以使社区受益于你的底层解决方案，这些方案可以应用在许多不同的项目中，还有一些你甚至想不到的应用方式。

比如，react-element-to-jsx-string 在许多其他的期望测试框架中使用，也有使用在像 [storybooks/addon-jsx](https://github.com/storybooks/addon-jsx) 这类的文档插件上。现在，如果想测试 React 组件的输出结果，使用 [Jest 并进行快照测试](http://facebook.github.io/jest/docs/en/snapshot-testing.html#snapshot-testing-with-jest)，在这种情况下就不在需要 expect-jsx 了。

## 反馈和贡献

[![A fake issue screenshot](https://blog.algolia.com/wp-content/uploads/2017/12/image3-2.png)](https://blog.algolia.com/wp-content/uploads/2017/12/image3-2.png)

_这里有很多问题，当然，这是我为了好看而伪造的🙂_

一旦你开始了开源的反馈和贡献就要做好开放和乐观的准备。你会得到赞许也会有否定。记住，任何和用户的交流都是一种贡献，尽管这看起来只是抱怨。

首先，要在书面上传达意图或语气并不容易。你可以使用「这很棒、这确实很差劲、我不明白、我很高兴、我很难过」来解释「奇怪了。。」，询问更多的细节并试着重现这个问题，以便更好地理解它是怎么产生的。

一些避免真正抱怨的建议：

* 为了更好地引导用户给予反馈，需要为他们提供一个 [ISSUE_TEMPLATE](https://github.com/blog/2111-issue-and-pull-request-templates)，可以在创建一个新问题时预填模版。
* 尽量减少对新晋贡献者的阻力。要知道，他们可能还没进入角色状态并很乐意向你学习。不要因为缺少分号 `;` 就拒绝他们的合并请求，要让他们有安全感。你可以温和的请求他们将其补上，如果这招没用，你可以就直接合并代码，然后自己编写测试和文档。

## 最后

感谢你的阅读，我希望你会喜欢这篇文章，并能帮你找到你想要帮助或者创建的项目。对开源社区做贡献是扩展你的技能的好方法，对每个开发者来说并不是强制性的体验，而是一个走出你的舒适区的好机会。

我现在很期待你的第一个或下一个开放源码项目，可以在 Twitter 上 @ 我 [@vvoyer](https://twitter.com/vvoyer)，我很乐意给你一些建议。

如果你喜欢开源，并且想在公司实践而不是空闲时间，Algolia 已经为 [开源 JavaScript 开发者](https://www.algolia.com/careers#60c7c780-1009-4030-8e44-f653fa2ebd36) 提供岗位了。

其他你可以会喜欢的资源：
* [opensource.guide](https://opensource.guide/)，学习如何启动和发展你的项目
* [Octobox](https://octobox.io/)， 将你的 GitHub 通知转成邮件的形式，这是避免因堆积「太多问题」以至于影响关注重要问题的很好的方法
* [Probot](https://probot.github.io/)，GitHub App 可以自动化和改善你的工作流程，比如关闭一些非常陈旧的问题
* [Refined GitHub](https://github.com/sindresorhus/refined-github) 在很多层面上为 Github UI 提供了令人钦佩的维护经验
* [OctoLinker](http://octolinker.github.io/) 为在 Github 上浏览别人的代码提供一种很好的体验

感谢 [Ivana](https://twitter.com/voiceofivana)、[Tiphaine](https://www.linkedin.com/in/tiphaine-gillet-01a3735b/)、[Adrien](https://twitter.com/adrienjoly)、[Josh](https://twitter.com/dzello)、[Peter](https://twitter.com/codeharmonics)、[Raymond](https://twitter.com/rayrutjes)、[zwwill 木羽](https://github.com/zwwill)、[刘文哲](https://github.com/NeoyeElf)、[SeanW20](https://github.com/SeanW20) 为这篇文章作出的帮助、审查和贡献。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
