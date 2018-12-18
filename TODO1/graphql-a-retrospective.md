> * 原文地址：[GRAPHQL: A RETROSPECTIVE](https://verve.co/engineering/graphql-a-retrospective/?utm_source=wanqu.co&utm_campaign=Wanqu+Daily&utm_medium=website)
> * 原文作者：[Rob Kirberich](https://kirberich.uk/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/graphql-a-retrospective.md](https://github.com/xitu/gold-miner/blob/master/TODO1/graphql-a-retrospective.md)
> * 译者：[EmilyQiRabbit](https://github.com/EmilyQiRabbit)
> * 校对者：[Eternaldeath](https://github.com/Eternaldeath)

# 关于使用 GRAPHQL 构建项目的回顾

在 2016 年末，我们决定用 Python 和 [React](https://reactjs.org/) 重写老旧的 PHP 遗留系统。由于只有四个月的时间在 2017 年的节日（到来前）及时建立 MVP（模式开发的系统），我们必须非常谨慎地决定如何投入时间。

我们投入使用的技术之一就是 GraphQL。我们中之前还从来没有人用过它，但我们认为它对于快速交付以及能让人们独立工作至关重要。

事实证明这是一个非常好的决定，所以两年后我们想回顾并分享从那时起学到的东西...

#### 两年后的 GraphQL

我们从遗留系统学到的教训，大大影响了我们，于是我们决定使用 [GraphQL](https://graphql.org/)。我们在相当数量的微服务之间使用 REST APIS，导致很多混乱，如不兼容的接口，不同的资源标识符和非常复杂的部署。任何 API 的变动都需要同时部署所有使用了这个 API 的服务以避免停机故障，这会经常出现错误并导致很长的发布周期。在单个 API 网关使用 GraphQL，我们将可以大大简化服务格局。我们也决定了使用 [Relay](https://facebook.github.io/relay/)，它为我们提供了一种识别资源的单一的、全局的方式，以及组织 GraphQL 模型的简单方法。

我们使用单一服务作为 GraphQL 服务器，它反过来会请求各种后端服务 -- 其中大部分是 REST APIs，但是因为它们都只和网关通信，所以它们可以使用任何想用的接口。网关被设计为完全无状态的，这对于可扩展性大有裨益。缓存也是在 GraphQL 网关中，因此，只需扩大网关实例的数量，就可以轻松扩展整个系统。

API 网关并不是 GraphQL 世界的规章，所以为什么尽管使用它们意味着需要从网关到后台服务的附加请求，我们还要使用呢？对于我们而言，最大的原因就是减少 API 的相互依赖。没有网关的话，我们的服务结构将会差不多像这样：

[![](https://verve.co/wp-content/uploads/2018/11/Verve_GraphQL_Diagram_1_a-2000x2000.jpg)](https://verve.co/wp-content/uploads/2018/11/Verve_GraphQL_Diagram_1_a.jpg)

很多服务都和很多其他服务互通，导致需要大量的 API 连接，连接数量会以大致相当于服务数量的二次方的速度增长。这不但几乎不可能让任何人记住，同时还在处理中断，维护和 API 更改时，增加了大量复杂性。

即使在这样的网络中，GraphQL 也能够帮助提升向后兼容性，但这是当你在服务之间放置一个单一网关的时候所会发生的事情：

[![](https://verve.co/wp-content/uploads/2018/11/Verve_GraphQL_Diagram_2-2000x2000.jpg)](https://verve.co/wp-content/uploads/2018/11/Verve_GraphQL_Diagram_2.jpg)

忽然间，就仅有线性数量的连接了，每个新的服务仅会在网络图中增加一个新连接。API 变化仅需要影响它的源服务和网关。

API 网关是服务互相通信的**唯一**途径，这就大大降低了复杂度。它还为缓存，缩放，监视和分析创建了一个很好的中心位置。一般来说，只有一项服务负责这么多事情并不是一个好主意 -- 而是一个故障点。

但是，API 网关是**无状态的**。它没有数据库，没有本地资源也没有认证。这意味着它可以在水平方向上缩放自如，同时因为它还负责了缓存，所以仅增加网关实例的数量就有助于显著解决流量高峰（的问题）。

当然，网关也不是全无代价的：一个请求现在要发送两次了，并且如果一个后台服务想要和另一个后台服务通信，就必须通过网关。这对于创建一个更易于维护的中心接口非常有用，但是对于性能来说并不是很好。这就是无状态网关展现自己光辉的时候。因为网关代码在**哪里**运行并不重要，那就没有什么能阻止我们将每个后端服务都作为其**自己的**网关。我们将 GraphQL 接口移动到了每个服务中，直接发送网络请求，而不是发送两次，这样完全不需要使用 GraphQL 服务器，但是却依旧保留了所有 GraphQL 中心模型的优势。并且由于我们使用了 [Python](https://www.python.org/) 定义了 GraphQL 模型，我们决定更深一步，通过从 GraphQL 模型中自动生成 API 包装器，可以直接在 Python 中使用它。

结果就是现在服务间的通信代码变成了如下这样：

[![GraphQL Code](https://verve.co/wp-content/uploads/2018/11/Verve_GraphQL_Code_3.png)](https://verve.co/wp-content/uploads/2018/11/Verve_GraphQL_Code_3.png)

GraphQL 模型的 API 包裹器是完全从 graphene schema 自动生成的。所以，服务甚至不需要模型文件的副本。没有多余的请求，身份验证在后台透明处理，字段在访问时会被延迟解析。

现在，在这样的环境中，成为一个好的 API “公民”就会有一些要求了。后台 API 大多可以做任何它们想做的事情，但是在如何进行缓存和权限检查的时候它们必须发挥很好的作用。我们在后端 APIs 中使用的规则如下：

#### **避免嵌套对象，仅返回相关联对象的 IDs**

在 REST API 中返回嵌套的对象是减少请求数量的一个很好的方法。但是这也让缓存非常困难，并可能导致获取多余的资源，这正是 GraphQL 应该对抗的。通常情况下，我们避免大的，复杂的请求，而更偏向于稍多但是容易缓存的，更加扁平化的请求。

#### 如果确实需要嵌套，**绝不**嵌套那些有附加权限的对象

有时候性能要求超过了简单性的要求，那我们就可以返回潜逃的对象，例如，在一个 API 应答中包含一个相关联的嵌套对象的长列表。但是，我们只在被嵌套对象的权限不比外层对象更严格的情况下这样做，因为如果不这样，应答就无法被缓存。

我们使用 graphene 和 graphene-django 来实际运行服务器，我们不使用 graphene-django 自动映射 [Django](https://www.djangoproject.com/) 模型的能力，因为所有的数据都来自外部请求，我们只使用它来与我们的堆栈的其余部分兼容并熟悉它。整个网关服务实际上就是一个单独的 GraphQLView，我们做了一点小小的扩充来允许我们对前端做出优化：

*   我们将报错信息优化，用以将 Django REST Framework 错误从后端服务中分解出来。DRF 每个字段可能有不止一个错误，但它在原生 graphene-django 中并不起作用，所以我们扩展了视图，用来为每个字段提供精确的错误信息。
*   我们扩展了错误日志，以便更容易地报告各种错误信息。例如 4xx 错误实际意味着用户错误，但是由于网关调用了另一个不同的 API，它同样也意味着网关错误的使用了我们的 API。DRF 不会记录后台服务的 4xx 错误，因此，当实际上是我们而不是用户导致的错误时，我们会在网关中执行此操作。
*   监控：GraphQLView 是添加各种性能监控位的绝佳位置。我们追踪每个请求的执行时间，对查询进行散列，以便合计不同参数的同一请求的响应时间。

GraphQL 对我们大有益处，但是我们也犯了很多错误。有时候我们会努力保持我们的 API 能真正向后兼容，除了性能监控和更好的错误报告，还必须为已弃用的字段投入额外的监控。每次 API 变化就需要手动更新 GraphQL 模型，这是相当乏味的事情；并且为了通过 GraphQL 使后台服务的通信变得非常容易，我们有时也会打破一些服务的边界。但最终，它帮助我们更快地发展，维持了基础设施核心模型的简易，并使我们的团队更加自动化。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
