> * 原文地址：[Top JavaScript Frameworks and Topics to Learn in 2019](https://medium.com/javascript-scene/top-javascript-frameworks-and-topics-to-learn-in-2019-b4142f38df20)
> * 原文作者：[Eric Elliott](https://medium.com/@_ericelliott)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/top-javascript-frameworks-and-topics-to-learn-in-2019.md](https://github.com/xitu/gold-miner/blob/master/TODO1/top-javascript-frameworks-and-topics-to-learn-in-2019.md)
> * 译者：
> * 校对者：

# 2019 年值得学习的顶级 JavaScript 框架与主题

![](https://cdn-images-1.medium.com/max/2560/1*RFPEzZmTByjDmScp1sY8Jw.png)

图: Jon Glittenberg Happy New Year 2019 (CC BY 2.0)

又到了一年的这个时候：JavaScript 年度技术生态回顾。我们的目标是找出最有职业投资回报率的主题和技术。在实际生产中大家都在用什么呢？现在的趋势是什么样的呢？我们不会试图去找出最佳，但是会使用数据驱动的方法，来帮助大家着重关注那些能帮助你在求职面试中回答“你知道 ____ 吗？”的主题与技术。

我们不会去分析哪些是最快的，哪个有最好的代码质量。我们会假设它们都是速度恶魔（speed demons），并且它们都很棒，足以完成你的工作。而主要的关注点在于：什么是被大规模使用的？

### 组件框架

我们要关注的大问题是当前组件框架的状况。我们会主要关注三巨头：React，Angular 和 Vue.js，主要因为在工作中，它们的使用远远超过了其他的框架。

去年，我注意到了 Vue.js 的（使用量）增长并提到了它可能在 2018 年赶上 Angular。事实上它没有发生，但 Vue.js 的增长仍然非常快。我也预测了将 React 用户转化为其他框架用户将会更加困难，因为 React 比 Angular 有更高的用户满意度 - React 用户并不会有充分的理由去切换框架。与我对 2018年的预期一致。React 在 2018 年牢牢占据了头把交椅。

但有趣的是，三个框架每年仍持续着指数级的增长。

#### 预测：React 在 2019 将继续领先

在我们关注 React 的第三年，它 [相比 Angular 仍有更高的满意度](https://2018.stateofjs.com/front-end-frameworks/overview/) ，而且对于挑战者，它不会放弃任何优势。目前看来我认为在 2019 没有能够挑战它地位的框架。除非有超级强大的东西出现并且扰乱了 React（社区），React 将会在 2019 年底继续领先。

说到 React，它一直在变得更好。最新的 [React hooks API](https://reactjs.org/docs/hooks-reference.html) 取代了我从 0.14 版本开始就几乎不能忍受的 `class` API。(`class` API 仍然可以继续使用，但是 hooks API 真的 **更好**)。React 的 API 改进如更好的代码分割和并发渲染（[详情](https://reactjs.org/blog/2018/11/13/react-conf-recap.html)）将使它在 2019 年更难被打败。不用怀疑，React 现在是目前对开发者最友好的前端框架。我没有理由不推荐它。

#### 数据来源

我们会关注一些关键点来评估在（这些框架）实际生产中的兴趣和使用情况：

1.  **Google 搜索的趋势。** 这并不是我最喜欢的指标，但是它是个不错的宏观视角。
2.  **包下载量。** 这里的目的是获取使用框架的真实用户（数据）。
3.  **Indeed.com 上的招聘广告。** 用和去年相同的方法论来保持结果的一致性。

#### Google 搜索趋势

![](https://cdn-images-1.medium.com/max/800/1*DPlan5kEE81FW0eUA3Y3oQ.png)

框架搜索趋势：2014 年 1 月 - 2018 年 12 月

在搜索趋势上，React 在 2018 年 1 月超越了 Angular，并且在这一整年剩余的时间里保持了领先的位置。Vue.js 在图里保持了一个可见的位置，但是仍然是搜索趋势中的一个小因子。对比：去年的趋势图：

![](https://cdn-images-1.medium.com/max/800/1*q0MyFu6pldf-guTIQweTSQ.png)

框架搜索趋势：2014 年 1 月 - 2017 年 12 月

#### 包下载量

包下载量是一个衡量实际使用情况的公平指标，因为开发者在工作是会频繁地下载那些他们需要的包。

睿智的读者会发现有时候他们从他们公司内部源的下载包，对于这种情况，我的回答是：“那确实会发生 - 对于这三个框架来说。”它们都可以在企业中立足，而我对这个大规模的数据的平均能力有信心。

**React 每月下载量: 2014–2018**

![](https://cdn-images-1.medium.com/max/800/1*IV9KdeP1hOwxSVZdwoKKcQ.png)

**Angular 每月下载量: 2014–2018**

![](https://cdn-images-1.medium.com/max/800/1*IxS8G-0oixLWL0F2NDIYng.png)

**Vue 每月下载量: 2014–2018**

![](https://cdn-images-1.medium.com/max/800/1*uvg4_D5NyuIiyUI_H72S2w.png)

让我们看一下下载份额的快速可视化比较：

![](https://cdn-images-1.medium.com/max/800/1*THtgoY-LQTvIm8ezl3SGiQ.png)

**“但你忘记了 Angular 1.0! 它在企业中仍然很重要。”**

不，我没有。Angular 1.0 仍然在企业中被广泛使用，这和 Windows XP 在企业中仍被广泛使用是相似的。这个数量绝对足够引起注意，但是新版本的 Angular 早已使 Angular 1.0 相形见绌，Angular 1.0 的重要性已经不如其他的框架了。

为什么？因为整个软件行业和 **所有部门（包括企业）** 的 JavaScript 的使用增长得很快，新的框架会使旧的框架变得很渺小，即使它是 **永不升级** 的遗产应用。

证据就是，看看这些下载量统计图。2018 年单年的下载量就比之前几年的 **总和** 都要多。

#### 招聘广告投放数

Indeed.com 集合了许多招聘部门的招聘广告。每年 **我们都会统计提到每个框架的招聘广告¹** 来给大家提供关于企业在招什么样的人的更好的观点。这是今年的形势：

![](https://cdn-images-1.medium.com/max/800/1*GkJY82i3ryEZW1akwUSQoA.png)

2018 年 12 月有关每个框架的招聘广告统计

*   React: 24,640
*   Angular: 19,032
*   jQuery: 14,272
*   Vue: 2,816
*   Ember (不在图中): 2,397

再说一次，今年投放的职位总数比去年要多。我把 Ember 剔除了，因为它显然没有像其他框架一样按比例增长。我不推荐为了未来找工作而去学它。jQuery 和 Ember 相关的岗位并没有多大的变化，但其他的岗位都有很大的增长。

令人感激的是，加入软件工程领域的新人在 2018 年也增长了很多，但这也意味着我们也需要持续聘用并培训初级开发者（意味着我们需要 [合格的高级开发者来指导他们](https://devanywhere.io)），否则我们将无法跟上爆炸性的就业增长。作为对比，这里有去年的图表：

![](https://cdn-images-1.medium.com/max/800/1*zO-KgLZ5kDbv2sug6js9ug.png)

平均薪资在 2018 年也攀升了，从每年 $110k 到每年 $111k。有传闻说，薪资列表落后于新员工的预期，并且如果招聘经理不去适应开发者的市场，不给出更多的加薪，他们会更难雇佣和留住开发者。留人和物色人才在 2018 仍然会是一个巨大的问题，因为雇员们会跳槽到别处有更高工资的职位。

1.  **方法论：** **职位搜索是在 Indeed.com 上进行的。为了去除误报，我把它们和搜索词“software”组合在一起来加强相关度，然后乘以 1.5（粗略地说，就是使用关键词“software”和不用这个关键词搜索到的编程岗位列表的区别）。所有 SERPS 都按照日期排序并检查相关性。结果数据并不是 100% 准确的，但它们对于在本文中使用的相对近似值足够好了。**

### JavaScript 基础

我每年都在说：关注基础。今年你会得到更多的帮助。所有的软件开发都是这样组合的过程：把复杂的问题拆解成多个小问题，并将那些小问题组合起来，组成你的应用。

但当我问 JavaScript 的面试者那些软件工程最基本的问题，如“什么是函数组合”和“什么是对象组合”，他们几乎总是回答不出这些问题，尽管他们每天都在做这些事。

我一直认为这是一个需要解决的严重问题，所以我写了这个主题： [**“Composing Software”**](https://leanpub.com/composingsoftware) 。

> 如果你在 2019 年没有要学的了，那么就去学组合式编程吧。

#### On TypeScript

TypeScript 在 2018 年持续增长，并且它会被持续高估，因为 [类型安全并不是什么大问题](https://medium.com/javascript-scene/the-shocking-secret-about-static-types-514d39bf30a3) （并没有很好地减少产品的 bug 密度）, 并且在 JavaScript 中，[类型推断](https://medium.com/javascript-scene/you-might-not-need-typescript-or-static-types-aa7cb670a77b) 不需要 TypeScript 的帮助也可以做得很好。你甚至可以在使用 Visual Studio Code 时，通过 TypeScript 引擎在普通的 JavaScript 中进行类型推断。或者为你喜爱的编辑器安装 Tern.js 插件。

对于大部分高阶函数而言，TypeScript 会继续一败涂地。大概是因为我不知道怎样正确使用它（在与它日常相伴多年后 - 在这种情况下，他们真的需要提高可用性或者文档，或者两者都要），但我仍然不知道在 TypeScript 中如何定义 map 操作的类型，而它似乎在 [transducer](https://medium.com/javascript-scene/transducers-efficient-data-processing-pipelines-in-javascript-7985330fe73d) 中很清晰明了。捕获错误经常失败，并且经常报明明不是错误的错误。

可能对于支持我所认为的软件，它仅仅是不够灵活或者功能不够完善。但我仍然对有一天它会加入我们需要的功能抱有希望，因为它的缺点在我尝试在真实项目中使用它时令我失望，但我仍然喜欢它在有用的时候能够合适地（并且可选择地）定义类型的潜力。

我目前的评价：非常酷的选择，有限的使用场景，但被高估了，笨拙，并且在大型生产应用中的投资回报率很低。这非常讽刺，因为 TypeScript 自称是“JavaScript 的超集”。可能他们要加入一个词：“笨拙的 JavaScript 超集”。

在 JavaScript 里我们需要的是一个比 Haskell 更强大但是比 Java 更轻量的类型系统。（PS：这句翻译不确定，麻烦校对看下）

#### 其他值得学习的 JavaScript 技术

*   用于请求服务端的 [GraphQL](https://graphql.org/)
*   用于管理应用状态的 [Redux](https://redux.js.org/)
*   用于独立管理副作用的 [redux-saga](https://github.com/redux-saga/redux-saga)
*   [react-feature-toggles](https://github.com/paralleldrive/react-feature-toggles) 来简化持续交付和测试
*   [RITEway](https://github.com/ericelliott/riteway) 来编写美观、可阅读的单元测试

### 加密行业的崛起

去年我预测区块链和金融会计将会成为 2018 年值得观察的重要技术。这个预测是正确的。2017 - 2018 的一个主要的主题是加密行业的崛起和构建**价值网络**的基础。记住这个阶段。你很快将会多次听到它。

如果你和我一样自从 P2P 爆炸性增长后关注那些去中心化应用，这已经持续很久了。由于比特币点燃了导火索，并展示了去中心化应用通过加密货币自我维持的方式，这种爆炸性增长是不可阻挡的了。

比特币在几年内增长了若干个量级。你可能听说过 2018 年是“加密寒冬”，并且有“加密行业处于挣扎中”的想法。这完全是无稽之谈。实际的情况是，在 2017 年底，比特币以史诗般的指数增长曲线增长到之前的 10 倍，但市场有所回落，这种回落会发生在每次比特币增长到之前的 10 倍。

![](https://cdn-images-1.medium.com/max/800/1*2nlit12SUIYN93RdmBNoHQ.png)

比特币 10 倍拐点

在这个图表中，每个箭头始于 10 倍点，指向价格修正后的最低点。

加密货币的 ICO（首次代币发行）的资金募集在 2018 年初达到顶峰。2017-2018 的资金泡沫带来了生态系统中大量新的职位空缺，在 2018 年 1 月达到了顶峰，有超过 10k 的职位空缺。这种趋势已经回落到大概 2400 个职位空缺了（根究 Indeed.com 的数据），但是我们现在仍处于（这个行业的）早期阶段，这场派对才刚开始。

![](https://cdn-images-1.medium.com/max/800/1*FUZjNmtKuVNSAK-DnoGtoQ.png)

关于迅猛增长的加密行业有很多可以讨论的地方，但是这可以另写一篇博文了。如果你感兴趣的话，可以阅读：[“Blockchain Platforms and Tech to Watch in 2019”](https://medium.com/the-challenge/blockchain-platforms-tech-to-watch-in-2019-f2bfefc5c23).

#### 其他值得观察的技术

和去年预测的一样，这些技术在 2018 持续爆炸性增长：

**人工智能/机器学习** 正如火如荼，在 2018 年末有 30k 的职位空缺。deep fakes，令人难以置信的生成艺术，来自 Adobe 这样的公司的研究团队研发的令人惊讶的视频编辑能力 — 从来没有更激动人心的去探索人工智能时刻。

**渐进式 Web 应用（PWA）** 迅速成为了构建现代应用的方式 - 增加的新特性与有 Google、Apple、Microsoft、Amazon 等公司的支持。令我难以置信的是，我将手机上的 PWA 视为理所当然。例如，我在我的手机上不再需要安装 Twitter 的原生应用。我仅仅使用 [Twitter 的 PWA](https://mobile.twitter.com/home) 来替代它。

**AR** （增强现实）、 **VR** （虚拟现实）、 **MR** （混合现实）像战神金刚一样合体成 **XR** (eXtended Realty)。未来的全时 XR 沉浸即将到来。我预测在 5-10 年内会出现大规模的消费级 XR 眼镜产品。隐形眼镜会在 20 年内推出。这个行业在 2018 年有数以千计的新职位空缺，并且在 2019 仍会持续爆炸性增长。

- YouTube 视频链接：https://youtu.be/JaiLJSyKQHk

**机器人、无人机和自动驾驶汽车**：在 2018 年末，自动飞行的无人机已经被研发出来了，自动机器人仍在持续优化中，并且有更多自动驾驶汽车上路了。2019 年，以及未来的 20 年，这些技术会持续增长并重塑我们周围的世界。

**量子计算** 和预期的一样在 2018 发展得极好，并且和预期的一样，它仍然没有成为主流。事实上，我的预测“它会在 2019 或者在真正中断之前成为主流”可能太乐观了。

加密领域的研究者已经集中更多的注意力在量子安全加密算法上（量子计算会打破今天的计算成本昂贵的假设，而加密正是依赖于这些成本昂贵的计算），但尽管在 2018 年不断涌现出有趣的研究进展，最近有一篇报道 [换了个角度看待这个问题](https://www.theregister.co.uk/2018/12/06/quantum_computing_slow/):

> “在 2000 到 2017 年间，量子计算已经 11 次上了 Gartner 的 hype list，每次都在 hype cycle 的最早阶段就被列出，并且每次都说已经距离我们有十年之遥。”

这让我想起了早期人工智能的努力，它在 1950 年代开始升温，在 1980 和 1990 年代有了有限的但是有趣的成果，但是在 2010 年左右的成果才开始变得令人兴奋。

* * *

> 我们正在构建未来的名人数字藏品： [cryptobling](https://docs.google.com/forms/d/e/1FAIpQLScrRX9bHdIYbQFI5L3hEgwQaDEdjo8t8glqlyObZexWjssxNQ/viewform) 。

* * *

**_Eric Elliott_ 是 [“编写 JavaScript 应用”](http://pjabook.com)（O’Reilly）以及[“跟着 Eric Elliott 学 Javascript”](http://ericelliottjs.com/product/lifetime-access-pass/) 两书的作者。他为许多公司和组织作过贡献，例如 *Adobe Systems*、*Zumba Fitness*、*The Wall Street Journal*、*ESPN* 和 *BBC* 等，也是很多机构的顶级艺术家，包括但不限于 *Usher*、*Frank Ocean* 以及 *Metallica*。**

大多数时间，他都在 San Francisco Bay Area，同这世上最美丽的女子在一起。

感谢 [JS_Cheerleader](https://medium.com/@JS_Cheerleader?source=post_page)。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
