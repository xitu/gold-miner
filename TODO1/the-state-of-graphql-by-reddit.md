> * 原文地址：[The state of GraphQL by Reddit](https://blog.graphqleditor.com/the-state-of-graphql-by-reddit/)
> * 原文作者：[Robert Matyszewski](https://twitter.com/intent/follow?screen_name=iamrobmat)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/the-state-of-graphql-by-reddit.md](https://github.com/xitu/gold-miner/blob/master/TODO1/the-state-of-graphql-by-reddit.md)
> * 译者：[TiaossuP](https://github.com/TiaossuP)
> * 校对者：[yangxy81118](https://github.com/yangxy81118)

# 从 Reddit 讨论中看到的 GraphQL 现状

一提到 GraphQL，就会看到各类炒作文章以及将它与 REST 进行比较的争论。GraphQL 现在处于全球流行、全面使用的早期阶段，没有人确切知道它会在哪里在止步。通过在互联网上的调研，我发现了许多对这项新技术的安利文章。这只是对第一印象的炒作吗？

我研究了 Reddit 上关于 GraphQL 的评论，并挑选了其中一些最受欢迎的内容。本文旨在以透明、客观的态度来讨论这个主题，所以对于每个派别的不同观点，我都挑选了一些用户的探讨与争论的内容。下面的每个评论引用都有一个指向其作者的链接，同时（）中的为该评论的点赞 **（译注：原文为 upvote）** 数量。不过要注意，我撰写与发表本文以后，点赞数字可能会发生变化。

## 议程

* 整体状况
* React & Apollo 状况
* 大公司 & GraphQL
* 缓存
* 请求数据
* 总结

# 整体状况

从整体出发，我选择了两个实践例子。首先，[SwiftOneSpeaks](https://www.reddit.com/user/SwiftOneSpeaks/) 显示了前端开发人员的视角和潜在的市场改进。其次，[Scruffles360](https://www.reddit.com/user/scruffles360/) 展示了团队如何适应 graphql 以及他们使用具体工具的策略趋势。稍后您会发现更多他的评论。第二个评论是本文中选择的赞最少的评论。

[SwiftOneSpeaks](https://www.reddit.com/r/reactjs/comments/bozrg1/graphql_vs_rest_putting_rest_to_rest/eno3ovb/)（23）说：

> 当我与后端开发团队合作时，他们更倾向于提供新的查询来满足我的需求，因为这不会影响他们必须支持的现有查询。（也就是说，我不知道随着时间的推移，这个查询的扩展性会怎样）。GraphQL 还减少了我必须重新解析为可用（满足我的需要）的数据结构的糟糕响应的数量。（例如，我得到了 3 个数组，我必须将它们关联起来并压缩到一组对象中。尽管后端仍然需要有一些工作要做，但使用 GraphQL，我可以有更丰富的能力来要求数据格式。）

[Scruffles360](https://www.reddit.com/r/reactjs/comments/bozrg1/graphql_vs_rest_putting_rest_to_rest/enpb6fg/)（8）描述了他在 GraphQL 领域内看到的三个发展方向：

> * 巨石应用：这就是阿波罗现在所推动的。每家公司都有一个且只有一个 api endpoint 和 schema 代理其他所有东西（[https://principledgraphql.com/](https://principledgraphql.com/)）。我完完全全不同意这个思路，但不会在这里重复我的论点（如果想了解的话，您可以挖掘我的评论历史）
> * 数据库 api：出于一些奇怪的原因，人们已经开始向数据库添加插件，这些插件可以通过 graphql 直接访问数据库。由于很多原因，Graphql 非常棒，但是它还不能与原生数据库查询语言相媲美。更重要的是，这去掉了您的业务层，使调用者可以直接访问您的 store。除了一个微服务应用，其余任何人都不应拥有访问store的权限 —— 其他人应该通过您的 api 调用服务。
> * 中间路线：经典的 API 做法，每个应用程序都有自己的 API（在本例中为 GraphQL）。它可能将业务逻辑或代理隔离到微服务（通过 rest 或通过 schema stitching 到另一个 Graphql 架构）。这是我们走的路，目前为止还没让我后悔。

# React & Apollo 状况

React 和 Apollo 的组合获得了很多关注。此外 [Wronglyzorro](https://www.reddit.com/user/wronglyzorro/) 和 [Livelierepeat](https://www.reddit.com/user/livelierepeat/) 讨论为什么后端开发可能不喜欢 GraphQL。一位更有经验的开发人员的回应获得了更多的赞。另外，我选择了一个更长但非常详细的评论。

[Wronglyzorro](https://www.reddit.com/r/reactjs/comments/9nmj0w/what_is_your_experience_with_react_apollo_graphql/e7nkk73/)（12）：

> 我们在网络应用程序上严格使用 react + apollo。我们也强迫移动客户端也使用它。虽然听起来有些荒诞，但这确实是大趋势。后端开发人员当然讨厌它，因为他们习惯了自己原有的方式，不喜欢改变。然而，在我们过去一年中出现的故障中，从没有 GraphQL 导致的，崩溃的总是遗留的后端服务。

[Livelierepeat](https://www.reddit.com/r/reactjs/comments/9nmj0w/what_is_your_experience_with_react_apollo_graphql/e7o92o5/)（40）回复：

> 后端开发人员当然讨厌它，因为他们习惯了自己原有的方式，不喜欢改变。
>
> 您可能想要了解我的观点，我曾经是一个年轻的开发人员，使用所有最新的工具，并嘲笑那些「适应不了」的人。我了解到，通常有比「人们讨厌改变」更有趣的原因。比如 GraphQL 的抽象是否太过复杂？他们抗拒工作量的增加，可究竟增加了什么？
>
> 有时，所有的工具都是最新的，反而可能不能让这些工具的效用得到最大凸显。更关键的还是在于理解代码和参与开发的人。

[Capaj](https://www.reddit.com/r/reactjs/comments/9nmj0w/what_is_your_experience_with_react_apollo_graphql/e7nlgrn/) （11）的详细总结：

> 我们从五月开始在生产环境中使用 GraphQL。我们是一个全栈团队，所以我们不需要仰仗合作的后端团队的怜悯。说服每个人并不容易，不过 GQL 内置了一个示例，每个人都认为它看起来比 REST 更好。Graphiql 对此有很大帮助。
>
> 这挺好的。我们在后端使用 apollo 引擎，我非常喜欢在生产环境中使用指标捕捉 API 错误。我们使用 [decapi](https://github.com/capaj/decapi) 来装饰我们的 [objection.js](https://github.com/Vincit/objection.js) DB Model。我们在单独的地方定义 model，然后不需要做什么就可以自动生成 GQL。
>
> 在前端，我们使用 apollo-client，但到目前为止我们还没有使用缓存。我们的前端重点是摆脱之前的 angular.js 代码，所以我们还没有时间去试验前端缓存。
>
> 我尚未使用 apollo 进行客户端状态管理，因为到目前为止我听到的所有反馈都表明它尚未准备好面对生产环境。另外，我不得不说它看起来很啰嗦，写起来也很啰嗦。相反，我希望我可以扩展 https://github.com/mhaagens/gql-to-mobx 并将其用于我们的状态管理需求。MST 使用 typescript 表现的很好。如果我们可以在编辑 GQL 查询时动态地从查询中生成 MST 模型，我们可以大大提高我们的工作效率。

# 缓存

我已经从 [SwiftOneSpeaks](https://www.reddit.com/user/SwiftOneSpeaks/) 和 [Scruffles360](https://www.reddit.com/user/scruffles360/) 中看到了很多很棒的和高赞的评论，这些评论已经在上文提到了。以下是他们讨论的缓存问题和潜在解决方案。

[SwiftOneSpeaks](https://www.reddit.com/r/reactjs/comments/bozrg1/graphql_vs_rest_putting_rest_to_rest/eno3ovb/) (23) 写道：

> 虽然您可以将 GraphQL 配置为以各种方式工作，但实际上它们始终是 POST 请求。这意味着所有依赖于 GET 幂等而 POST 不幂等这一约定的浏览器缓存、CDN 缓存、代理缓存在默认情况下都将失效。一切都被视为新请求。虽然您可以在客户端自行做一些更智能的缓存，但这实际上只是在解决您自己产生（指引入GraphQL）的问题。

[Scruffles360](https://www.reddit.com/r/reactjs/comments/bozrg1/graphql_vs_rest_putting_rest_to_rest/enokkzb/) (11) 回复：

> 阿波罗有一个解决方案 —— 「动态持久化查询」，不过我还没有尝试过。大致来说，客户端将使用 GET 请求（将 query 哈希），如果失败，则回退到 POST。接下来的 GET 调用将成功并应用到任何代理缓存。

# 请求数据

这些人还对数据提取提出了不同的观点。在 [graphql-vs-rest](https://www.imaginarycloud.com/blog/graphql-vs-rest/) **（[译文在此](https://juejin.im/post/59793f625188253ded721c70)）** 中，作者描述了一个具有多个作者的博客应用程序示例以及使用 GraphQL 与 REST 的可能性。

[SwiftOneSpeaks](https://www.reddit.com/r/reactjs/comments/bozrg1/graphql_vs_rest_putting_rest_to_rest/eno3ovb/) (23) 说：

> 每个人都强调「过度请求」问题 **（译注：原文为 Over fetching，意指请求的数据中有很多您并不需要的字段。还有一个类似的概念：Under fetching，意指某个接口的返回数据不够，部分字段缺失，导致还需要请求第二个接口，这两种情况的问题都在于浪费了不必要的网络资源）** 问题。我觉得这根本不是设计出糟糕服务的借口（事实上问题在于 —— 如果开发者一直很菜，那么他写出来的 GraphQL 服务也不可能就突然好用了）。这很容易解决，只需要在原有服务前面加一个服务就行 —— GraphQL 可以胜任这项工作，但用别的东西也可以。问题不在于是否过度请求，而是中央服务**与**解决缓存问题。

[Scruffles360](https://www.reddit.com/r/reactjs/comments/bozrg1/graphql_vs_rest_putting_rest_to_rest/enokkzb/)（12）回复：

> 过度请求确实是一个问题。当您有数百个客户端时，每个客户端都以不同的方式调用您的系统，则向 rest api 添加一个属性就会导致极大的效率降低。许多人提出为移动客户端和 web 端提供不同的门面接口，但这样扩展性很差。我的项目由数百个客户端调用，每个客户端的请求方式与请求内容都有些许不同。

# 大公司 & GraphQL

每个人都对 Facebook、Netflix 和 Coursera 等大公司以及他们对 GraphQL 的使用情况感兴趣。对于这篇 [graphql-vs-rest](https://www.imaginarycloud.com/blog/graphql-vs-rest/) 在 Reddit 中的评论中，我们可以找到两个主要原因作为作者 - 状态。提出的第一条评论是我发现的最受欢迎的评论。

* 在 2010 年初，移动用户数量激增，出现了与低功耗设备和缓慢网络相关的一些问题。REST 不是处理这些问题的最佳选择；
* 随着移动使用量的增加，运行客户端应用程序的不同前端框架和平台的数量也在增加。由于 REST 不够灵活，导致我们更难开发出一个能够满足所有终端应用需求的单一 API。

[Greulich](https://www.reddit.com/r/reactjs/comments/bozrg1/graphql_vs_rest_putting_rest_to_rest/ennt7ak/)（62）回复这篇文章：

> 这离题太远，没有意义。构造请求的另一种方法不会使这些请求所在的网络更好或更差。
> 我认为作者的描述的是 endpoint 而不是 API，因为任何 endpoint，无论有多少 endpoint，都只是 API 的一部分。假设是这样，为什么我们只需要一个 endpoint？

[Scruffles360](https://www.reddit.com/r/reactjs/comments/bozrg1/graphql_vs_rest_putting_rest_to_rest/enohrog/)（16）回复 Greulich：

> 文章中的前两点措辞并不好，但仍然是正确的。REST API 可以是通用、可复用的，也可以是专门为已知客户端设计。在第一种情况下，当您需要不断再次调用系统以获取更多数据时 **（译者注：即上面提到的 Under fetching）**（尤其是像10年前我们在移动设备上那样的高延迟网络），将无法获得良好的性能。如果您为特定客户端制作 API，则显然会遇到可扩展性问题。

# 总结

在选择正确的评论来总结 GraphQL 的状态时，有很多话要说或选择。**直到今天关于 reddit 的最受欢迎的 submissions 是 facebook 或 netflix 的案例研究**，但这些 submission 的评论并不多。这给了我们以 reddit 对 GraphQL 的看法的一个很好的总结。想到各位开发者的日常生活后，我无法忽略 Kdesign（36）写下的内容：

> ### **GraphQL 让您的工作更安全，这是肯定的。**
>
> 您必须花时间在前端和实际数据存储之间的所有 N 多层中，寻找数据的位置。

[Kollektiv](https://www.reddit.com/r/node/comments/bozsb1/graphql_vs_rest_putting_rest_to_rest/enng3ba/)（44）列出了很多GraphQL问题：

> * 查询限速和权限评估等很难实现。
> * 类型和数据加载器的工作方式，如果不编写完整的 module 就分组查询，则难以有效的方式将查询绑定到数据库层。
> * 验证仅检查类型，因此您仍需要某种 JSON  schema 来执行其他格式验证。
> * GraphQL 查询只允许 left join，因此像 INNER JOIN 加过滤这种重新创建 SQL 就变得很棘手了。
> * 来自像 Relay 这样的框架强加的分页（连接）还是一团糟。

关于我对GraphQL的初步研究 [SwiftOneSpeaks](https://www.reddit.com/r/reactjs/comments/bozrg1/graphql_vs_rest_putting_rest_to_rest/eno3ovb/)（24）写道：

> 我认为我们看到了很多「GraphQL 很棒」报告主要是因为**任何新服务都很棒** —— 随着时间的推移，因为假设条件被违背 **（译注：假设条件的概念可以参考[浅谈Architectural Assumption（软件架构设计的假设条件）](https://blog.csdn.net/ytomc/article/details/80728132)）**、需求变更和代码变更，它们肯定会变得逐渐笨拙。不过这并不意味着 GraphQL不好 —— 只是说意味着我不能过多地信任早期报告。

最后，我选择了 [Mando0975](https://www.reddit.com/r/node/comments/bozsb1/graphql_vs_rest_putting_rest_to_rest/enopzpk/) （28）的观点来总结这篇文章：

> **开发始终是为工作挑选合适的工具。GraphQL 不是银弹。REST 并没有死，GraphQL 也不会杀掉它。**

### 您的 GraphQL 体验如何？

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
