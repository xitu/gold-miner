> * 原文地址：[贫困线下的软件](https://staltz.com/software-below-the-poverty-line.html)
> * 原文作者：[André Staltz](https://staltz.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/software-below-the-poverty-line.md](https://github.com/xitu/gold-miner/blob/master/TODO1/software-below-the-poverty-line.md)
> * 译者：[Charlo](https://github.com/Charlo-O)
> * 校对者：[Chorer](https://github.com/Chorer)

# 贫困线下的软件

大多数人认为[开源的可持续性问题](https://www.fordfoundation.org/about/library/reports-and-studies/roads-and-bridges-the-unseen-labor-behind-our-digital-infrastructure/)是很难解决的。作为一名开源开发者，我自己对这个问题的看法是比较乐观的：我坚信捐赠模式，因为它的简单和可扩展性。

然而，我最近遇到了其他以捐赠为生的开源开发者，他们开阔了我的视野。在 Amsterdam.js，我听到 Henry Zhu 在 Babel 和其他项目中[谈可持续发展](https://github.com/hzoo/open-source-charity-or-business/)，这是一个非常可怕的画面。后来，在吃早饭的时候，Henry 和我就这个话题进行了更深入的交谈。在阿姆斯特丹，我还遇到了全职维护 [Unified](https://unified.js.org/) 项目的 [Titus](https://github.com/wooorm)。与这些人的会面坚定了我对捐赠模式的可持续性的信心。它是可行的。但是，真正让我印象深刻的是这个问题：这样公平吗？

我决定从 OpenCollective 和 GitHub 上收集数据，并对这种情况采用更科学的样本。我发现的结果令人震惊：有两个明显可持续的开源项目，但我们通常认为的大多数可持续的项目（超过 80%）的收入实际上低于行业标准，甚至低于贫困线。

## 数据说明了什么

我从 OpenCollective 中选择了[流行的开源项目](https://opencollective.com/discover)，并从每个项目中选出年收入数据。 然后我查看了他们的 GitHub 仓库来计算 star 的数量，以及在过去 12 个月里他们有多少位“全职”贡献者。有时我也会在 Patreon 页面上查找少数几个拥有账户的维护人员，并将这些数据添加到项目的年收入中。例如，Evan You 很显然从 [Patreon to work on Vue.js](https://www.patreon.com/evanyou) 上获取资金。这些数据点让我能够衡量：项目**受欢迎程度**（用户数量的比例指标）、整个团队的**年收入**以及**团队规模**。

很难精确地计算每个项目有多少用户，特别是因为他们可能是传递用户，不知道自己在使用项目。这就是为什么我选择 GitHub stars 作为一个不错的用户数量衡量标准，因为它计算的是能够**意识到**项目价值的**用户**（不像下载量可以包括 CI 计算机）。

我总共收集了 58 个项目，这看起来可能是一个小数目，但包含了从最受欢迎到最不受欢迎的各种项目。受欢迎程度对衡量捐助量非常重要，结果发现，很少有项目可以足够流行到获得公平的报酬。换句话说，在这 50 个最受欢迎的项目中，大多数都低于可持续发展的门槛。我觉得，如果我能涵盖更多数据点，那些项目可能会比这些更加不受欢迎。这个数据集可能偏向于 OpenCollective 上的 JavaScript 项目，但是选择从 OpenCollective 采样是因为它提供了各项财务状况的简明数据。我想提醒读者，还有其他流行的开源项目，如 Linux、nginx、VideoLAN 等。最好将这些项目的财务数据合并到这个数据集中。

通过 GitHub 数据和 OpenCollective，我能够计算出每个“全职”贡献者每年能获得多少项目收入。这就是他们的工资。或者更确切地说，这是在他们只从事开源项目、没有任何补充收入的情况下，通过捐赠所获得的工资。很可能有相当数量的创建者和维护者并没有全职投入自己的项目。那些全职工作的人有时用储蓄来补充他们的收入，或者住在生活成本更低的国家，[或两者兼有（Sindre Sorhus）](https://twitter.com/sindresorhus/status/902954660285128704)。

然后，根据[最新的 StackOverflow 开发人员调查](https://insights.stackoverflow.com/survey/2019#work-_-salary-by-developer-type)，我们知道最低的开发者薪水在 $40k 左右，而最高的在 $100k 以上。考虑到开发人员的知识型工作者身份，且许多人居住在 OECD 国家，这个范围描述了开发人员的行业标准。这让我可以把结果分成四类:

* 蓝色：6 位数的薪水
* 绿色：行业标准内 5 位数薪水
* 橙色：低于行业标准 5 位数
* 红色：低于[美国官方贫困线](https://poverty.ucdavis.edu/faq/what-are-poverty-thresholds-today)

 下面的第一张图表展示了团队规模和每个 GitHub star 的“价格”。

[![开源项目，每颗星收入 VS 团队规模](https://staltz.com/img/poverty-popularity.png)](https://staltz.com/img/poverty-popularity.png)

 **超过 50% 的项目是红色的**：它们无法让维护者维持在贫困线以上。31% 的项目是橙色的，这些项目的开发者愿意为低薪工作，而这些薪水在我们这个行业内是令人难以接受的。12% 是绿色的，只有 3% 是蓝色的：Webpack 和 Vue.js。每颗 GitHub star 的收入很重要：可持续项目的收入一般在 $2/star 以上。然而，中值是 $1.22/star。团队规模对于可持续性也很重要：团队越小，就越有可能维持其维护者。

每年捐款的中间值为 $217，这站在个人层面上是相当可观的，但实际上也包括那些出于营销目的的公司的捐助。

下一张图表展示了收入是如何随着受欢迎程度而增长的。

[![开源项目，年收入 VS GitHub stars](https://staltz.com/img/poverty-popularity.png)](https://staltz.com/img/poverty-popularity.png)

你可以通过 LibreOffice Calc 电子表格访问此 [Dat archive](https://datproject.org/) 来自行浏览数据：

```
dat://bf7b912fff1e64a52b803444d871433c5946c990ae51f2044056bf6f9655ecbf
```

## 受欢迎度 VS 公平

虽然人气是绿色和蓝色的可持续发展的关键，但红色的也有受欢迎的产品，如 [Prettier](https://github.com/prettier/prettier)，[Curl](https://github.com/curl/curl)，[Jekyll](https://github.com/jekyll/jekyll)，[Electron](https://github.com/electron/electron)（更新：）[AVA](https://github.com/avajs/)。这并不意味着从事这些项目的人很穷，因为在某些情况下，维护人员在允许贡献开源的公司工作。然而，它的真正含义是，除非企业积极地用大量资金支持开源，否则剩下的情况就是大多数开源维护者资金严重不足。仅就捐赠而言，开源在最佳状态下是可持续的（符合行业标准）：当一个团队规模足够小的流行项目知道如何从一群捐助者或赞助组织那里筹集大量资金时。公平的可持续性对这些因素相当敏感。

由于可见性是捐赠驱动的可持续性的基础，“隐形基础设施”项目往往比可见的项目更糟糕。例如，[Core-js](https://github.com/zloirock/core-js) 不如 [Babel](https://github.com/babel/babel) 流行，尽管 [Bable 依赖于它](https://babeljs.io/docs/en/next/babel-polyfill.html)。

| Library | Used by | Stars | 'Salary' |
| ------- | ------- | ----- | -------- |
| Babel   | 350284 | 33412* | $70016   |
| Core-js | 2442712 | 8702* | $16204   |

一些建议的解决方案是在 [BackYourStack](https://backyourstack.com/) 和 [GitHub 的新贡献者概览](https://github.blog/2019-05-23-announcing-github-sponsors-a-new-way-to-contribute-to-open-source/#native-to-your-github-workflow) 等工具的指导下，将知名项目的捐款“涓滴”到不知名的项目。如果知名的项目有巨大的盈余可以与传递依赖项共享，那么这种方法就会奏效。这几乎是不可能的，只有 Vue.js 有足够的盈余来共享，而且它只能与 3 到 4 个其他开发者共享。Vue.js 是一个例外，其他项目不能分享他们的收入，因为这会导致每个参与者的收入都很低。

在 Babel 和 Core-js 的例子中，没有太多的盈余可供分享。Henry Zhu 在讲话中指出，资金已经非常有限。在这种情况下，Babel 似乎是一个**很**显而易见的项目，但让我吃惊的是，Henry 告诉我，许多人虽然使用 Babel，却没有意识到它，因为他们可能将它用作传递依赖项。

另一方面，低层库的维护者认识到需要与更多可见的项目合作，[甚至合并项目](https://twitter.com/wooorm/status/1062404997240012800)，以提高整体知名度，受欢迎程度，从而提高资金。Titus 的 Unified 就是这样，这是一个你可能没有听说过的项目，但是在 [MDX](https://github.com/mdx-js/mdx/blob/deff36bebfedb3a9de0a0575ee9a1b55b9b8aa18/package.json#L20)，[Gatsby](https://github.com/gatsbyjs/gatsby/blob/25d4a4dab66e04717fb09dc5edb1f7b856fc41ff/packages/gatsby-transformer-remark/package.json#L26)，[Prettier](https://github.com/prettier/prettier/blob/24f161db565c1a6692ee98191193d9cf9ff31d6f/package.json#L66)，[Storybook](https://github.com/storybookjs/storybook/blob/fed2ffa5e2919220f0508e540b2eae848523fee5/package.json#L214) 和其他许多软件中使用了 Unified 和它的许多软件包。

同样，受欢迎的项目在财务上比不那么受欢迎的依赖要好，这也是不正确的。Prettier（32k stars）使用 Unified （1k stars）作为依赖项，但是 Unified 的年收入比 Prettier 高。事实上，许多依赖于 Unified 的流行项目在每个团队成员身上获得的资金都要少得多。但是，Unified 本身接受的资金仍低于行业标准，并没有向下（或向上？）涓滴资金。

其他时候，很难说当项目 A 使用项目 B 时，它必须捐赠给 B，因为可能 B 也使用了 A！例如，[Babel 是 Prettier 中的依赖项](https://github.com/prettier/prettier/blob/24f161db565c1a6692ee98191193d9cf9ff31d6f/package.json#L19)，[Prettier 是 Babel 中的依赖项](https://github.com/babel/babel/blob/f92c2ae830dbb32013a36fa74facd2ef95b9947d/package.json#L59)。可能本次研究中涉及的许多项目彼此**之间**都有一个复杂的依赖关系网络，因此很难说这些项目中的资金应该如何流动。

##  剥削

对所有的维护者来说，投入到开源上的总资金是不够的。如果我们把数据集中的这些项目的年收入加在一起，就是 250 万美元。工资中位数约为 $9k，低于贫困线。如果将这笔钱平均分配，大约是 $22k，仍然低于行业标准。

核心问题不是开源项目没有分享所获得的资金。问题在于，从总数来看，开源并没有得到足够的资金。250 万美元是不够的。从这个数字来看，创业公司通常得到的都远不止这些。

[Tidelift 已经收到了 4000 万美元](https://www.crunchbase.com/organization/tidelift) 的资金，用于“帮助开源创建者和维护者获得公平的工作报酬”[（引用）](https://tidelift.com/docs/lifting/paying)。他们有一个 [27 人的团队](https://tidelift.com/about)，其中一些人是大公司（如 Google 和 GitHub）的前雇员。他们的工资可能没有那么低。然而，他们在网站上[展示的许多开源项目](https://tidelift.com/subscription)在捐赠收入方面都低于贫困线。实际上，我们并不清楚 Tidelift 为这些项目的维护者提供了多少资金，但是他们的[订阅价格](https://tidelift.com/subscription/pricing)非常高。不透明的价格和成本结构历来帮助企业掩盖这种不平等现象。

GitHub 被[微软以 75 亿美元收购](https://venturebeat.com/2018/06/04/microsoft-confirms-it-will-acquire-github-for-7-5-billion/)。为了让这个数字更容易理解，微软收购 GitHub 的金额是开源社区年收益的 **3000** 多倍。换句话说，如果开源社区把他们收到的每一分钱都存起来，那么在几千年后，他们也许就有足够的钱来一起买下 GitHub。现在GitHub也有了自己的[开源经济团队 ](https://www.youtube.com/watch?v=n47rCa9dxf8)（这个团队有多大，他们的薪水是多少？），但 GitHub 新的赞助功能远不如 OpenCollective 透明。不同于 GitHub 开放数据的一贯做法（如提交日历或贡献者图表），当涉及到捐赠时，用户无法知道每个开源维护者得到了多少。它是不透明的。

如果 Microsoft GitHub 真的想为开源项目提供资金，他们应该把钱花在刀刃上：至少为开源项目捐赠 10 亿美元。即使每年仅仅 150 万美元也足以使本研究中的所有项目变成绿色。GitHub 赞助商的[匹配基金](https://help.github.com/en/articles/about-github-sponsors#about-the-github-sponsors-matching-fund)是不够的，它每年给一个维护者最多仅 $5k,这不足以将维护人员从贫困线下提高到行业标准。

而我们还有数据表明，开源创建者和维护者的收入较低，而我们有数据表明，“帮助”开源的公司获得了数百万美元的收入，而且很可能是最高的工资。其他百万富翁和亿万富翁公司通过结合开源库和组件来构建专有软件来盈利。我理解 [DHH 关于开源可持续性“没有悲剧”的立场](https://youtu.be/VBwWbFpkltg?list=PLE7tQUdRKcyaOq3HlRm9h_Q_WhWKqm5xc&t=1362)，事实上，当我看到他的演讲时，我倾向于同意他的观点。然而，出于好奇，我最近整理的数据向我展示了开源财务的真实情况，表明工作质量和薪酬之间存在严重失衡。全职维护者是技术大牛，他们负责问题管理、安全、处理恶意投诉，但是收入却往往低于行业标准。

开源可持续性的斗争是将人类从奴役、殖民和剥削中解放出来的千年斗争。勤劳诚实的人们付出了自己的一切，换来的却是不公平的报酬，这已经不是第一次了。

因此，这不是一个新问题，也不需要复杂的新解决方案。这只是一种不公正的表现。解决这个问题无关乎从公司那里获得同情和道义行为，因为公司的根本目的不是做这些事情。公司只是遵循一些基本的社会金融法规，同时试图提高利润以及/或者统治。

开源基础设施是一种公共资源，就像我们的生态系统一样。由于我们的社会没有防止生态系统被开发的规则，公司[从事工业资源开采](https://ourworldindata.org/fossil-fuels)。几十年来，这正在[消耗环境资源](https://ourworldindata.org/forests)，现在我们面临着[气候危机](https://www.theguardian.com/environment/2019/may/17/why-the-guardian-is-changing-the-language-it-uses-about-the-environment)，通过[科学共识](https://archive.ipcc.ch/pdf/assessment-report/ar5/syr/SYR_AR5_FINAL_full_wcover.pdf)[证明](https://climate.nasa.gov/)这是对[地球上所有生命](https://www.ipbes.net/news/Media-Release-Global-Assessment)和[人类的重大威胁](https://news.un.org/en/story/2018/05/1009782)。开源盗用只是其中的一个小缩影，其后果没有那么严重。

如果你想帮助开源变得可持续，站出来帮助人类为社会制定新的规则，让权力和资本主义对滥用行为负责。如果你想知道这要做些什么，这里有一些具体行动的初步建议：

* 只接受那些将很大一部分利润（至少 0.5% ）捐赠给开源的公司，或者那些根本不依赖开源的公司的工作
* 如果你有足够的薪水，捐赠给开源
* 不要放弃加入工会（我在芬兰写这篇文章，那里 65% 的工人都加入了工会） 
* 不要放弃新项目的[替代许可证](https://licensezero.com/)
* 向微软施压，要求其向开源项目捐赠数百万美元
* 通过发布这类数据研究，揭露企业行为的真相

如果你喜欢这篇文章，考虑把它分享[（tweeting）](https://twitter.com/intent/tweet?original_referer=https%3A%2F%2Fstaltz.com%2Fsoftware-below-the-poverty-line.html&text=Software%20below%20the%20poverty%20line&tw_p=tweetbutton&url=https%3A%2F%2Fstaltz.com%2Fsoftware-below-the-poverty-line.html&via=andrestaltz "tweeting")给你的关注者。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
