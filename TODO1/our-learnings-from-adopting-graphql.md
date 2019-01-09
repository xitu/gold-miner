> * 原文地址：[Our learnings from adopting GraphQL: A Marketing Tech Campaign](https://medium.com/netflix-techblog/our-learnings-from-adopting-graphql-f099de39ae5f)
> * 原文作者：[Netflix Technology Blog](https://medium.com/@NetflixTechBlog?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/our-learnings-from-adopting-graphql.md](https://github.com/xitu/gold-miner/blob/master/TODO1/our-learnings-from-adopting-graphql.md)
> * 译者：[Sam](https://github.com/xutaogit)
> * 校对者：

# 我们采用 GraphQL 技术的经验：营销技术活动

在[之前的博客文章](https://github.com/xitu/gold-miner/blob/master/TODO1/https-medium-com-netflixtechblog-engineering-to-improve-marketing-effectiveness-part-2.md)中，我们对营销技术团队的一些应用程序提供了高级概述，我们这么做是为了推动全球广告业务实现 _体量化和智能化_ ，使得广告可以通过像纽约时报，Youtube等网站覆盖成千上万的用户。在这篇博文中，我们将分享关于我们更新前端架构的过程和在营销技术团队中引入 GraphQL 的经验。

我们用于管理创建和装配广告到外部部署平台的核心应用程序在我们内部被称为 **_Monet_**。它用于增强广告的创建和自动化管理在外部广告平台的营销活动。Monet 帮助推动增量转化，通常是和我们的产品进行交互，为全球各地的用户展示关于我们内容和 Netflix 品牌的精彩故事。为此，首先，它帮助扩展和自动化广告产品，并且管理数百万广告素材队列。其次，我们借用多种信号和汇总数据(例如了解在 Netflix 上的内容流行度)以实现高度相关的广告。我们总体目标是确保我们所有在外部发布频道的广告能够很好的引起用户的共鸣，并且我们不断尝试提高我们这么做的有效性。

![](https://cdn-images-1.medium.com/max/800/0*CafLBZiEtz9uwO62)

Monet 和高级_营销技术_流程

在我们开始的时候，Monet 的 React UI 层访问的是由 Apache Tomcat 服务提供的传统 REST API。随着时间的推移，我们应用程序的发展，我们的用例变得更加复杂。简单的页面需要从各种来源中获取数据。为了更加高效的在客户应用程序中加载这些数据，我们首先尝试在后端对数据进行非规范化处理。由于不是所有页面都需要所有这些数据，管理这些非规范化(的数据)变得难以维持。我们很快就遇到了网络带宽瓶颈。浏览器需要获取比以往更多的非规范化数据。

为了减少发送给客户端的字段数量，一种方法是为每个页面创建自定义端点；这是一个明显不切实际的想法。我们选择使用 GraphQL 作为我们应用的中间层，而不是创建这些自定义端点。我们也考虑过把[Falcor](https://netflix.github.io/falcor/)作为一个可能的解决方案，毕竟它在 Netflix 的很多用例中展现出很好的成果并且大量的使用，但是 GraphQL 健壮的生态体系和强大的第三方工具库使得 GraphQL 成为我们用例更好的选择。此外，随着我们数据结构越来越面向图形化，使用 GraphQL 最终适配会非常自然。添加 GraphQL 不仅解决了网络带宽瓶颈问题，而且还提供了许多其他优势，帮助我们更快地添加功能。

![](https://cdn-images-1.medium.com/max/800/1*pmh-VimZJJindIJUyZtyzg.png)

使用 GraphQL 架构的前后对比。

### 优势

我们已经在 NodeJS 上运行 GraphQL 差不多六个月了，并且它已经被证实可以显著提高我们的开发速度和总体提升页面加载性能。这里是自从我们使用 GraphQL 实践给我们带来的一些好处。

**重新分配负载和有效负载优化**

通常，某些机器比其他机器更适合做一些任务。当我们添加了 GraphQL 中间层时，GraphQL 服务器仍然需要调用和客户端直接调用的相同的服务和 REST API。现在的区别在于大多数据在同一数据中心的服务器之间流动。这些服务器和服务器之间的调用是非常低延迟和高带宽的，比起直接从浏览器发起网络请求有 8 倍的性能提升。从 GraphQL 服务器传送数据到客户浏览器的最后一段虽然仍是一个慢点，但至少减少成单个网络请求。由于 GraphQL 允许客户端只选择它需要的数据，所以我们最终可以获取明显更小的有效负载。在我们的应用程序中，页面之前要获取 10M 的数据，现在接收大约 200KB 即可。页面加载变得更快，特别是数据受限在移动网络上，并且我们的应用使用的内存更少。这些更改确实以提高服务器利用率为代价来执行数据获取和聚合，但是每个请求所花费的额外一点服务器毫秒时间远比不上更小的客户端有效负载。

**可复用的抽象**

软件开发者通常希望使用可复用的抽象而不是单一目的方法。使用 GraphQL，我们定义每段数据一次，并定义它与我们系统中其他数据之间的关系。当消费者应用程序从多个源获取数据时，它不再需要担心与数据连接操作相关联的复杂业务逻辑。

考虑接下来的例子，我们在 GraphQL 中只定义实例一次：_catalogs(类别)，creatives(素材)和comments(评论)_。现在我们可以由这些定义创建多个页面视图。客户端上的一个页面(类别视图)定义了它想要所有的评论和素材在一个分类里，而另一个客户端页面(素材视图)想要知道素材相关联的类别，以及所有和它相关的评论。

![](https://cdn-images-1.medium.com/max/800/1*Tr-cnrbTOPKkWkshYpQeIA.png)

GraphQL 数据模型的灵活性，用于表示来自相同底层数据的不同视图。

同一个 GraphQL 模型就可以满足上述两个视图的需求，而不用做任何服务器端的代码修改。

**链式系统**

很多人专注于单一服务器里的类型系统，但很难有跨服务的。一旦我们在 GraphQL 服务器中定义了实例，我们使用自动代码生成器工具为客户端程序生成 TypeScript 类型。我们的 React 组件属性接收类别以匹配组件正在进行的查询。由于这些类别和查询也是针对服务器模式进行验证的，因此服务器的任何重大更改都将被使用该数据的客户端捕获。将多个服务器和 GraphQL 链接在一起并将这些检查挂载到构建过程中，可以让我们在发布代码前捕获更多错误。理想情况下，我们希望从数据层一直到客户端浏览器层都是具有类型安全性的。

![](https://cdn-images-1.medium.com/max/800/1*YLL0aFFgcGDXFEa-V9_LPA.png)

从数据库到后端到客户端代码的类型安全。

**DI/DX  ——  简化开发**

当创建客户端应用程序时普遍需要考虑 UI/UX，但是开发者界面和开发者体验一般只是侧重于构建可维护应用程序。在使用 GraphQL 之前，编写一个新的 React 包装组件需要维护复杂的逻辑，以便为我们所需的数据发起网络请求。开发者需要关心每部分数据之间的依赖，数据该怎么缓存，以及是否做并发或队列请求，还有在 Redux 的什么位置存储数据。使用 GraphQL 的查询封装(wrapper)，每个 React 组件只需描述它所需要的数据，然后由封装(wrapper)去关心所有这些问题。这样就会是更少的引用代码和更清晰的数据与 UI 之间的关注点分离。这种定义数据获取的模块可以让 React 模块更容易理解，并且能够为部分描述文档提供服务知道组件具体在做什么。

**其他优势**

我们也留意到其他一些小的优势。首先，如果任何 GraphQL 的查询解析器失败了，已经成功的解析器仍然会返回数据到客户端渲染出尽可能多的页面。其次，由于我们更少的关心客户端模型，后端数据模型就简化了很多，在大多数情况下,只需提供一个 CRUD 接口的原始实体。最后，基于 GraphQL 的查询会自动为我们的测试进行存根转变，测试我们的组件也会变得很简单，并且我们可以把解析器从 React 组件中独立出来进行测试。

### 使用痛点

我们迁移到 GraphQL 是一个直截了当的过程。我们构建的大多数用于做网络请求和传输数据的基础架构在不做任何代码修改的情况下可以很容易在 React 应用和我们 NodeJS 服务之间做到可传递。我们甚至最终删除的代码比我们加的多。但是在迁移到任何新的技术这条路上，总会有一些需要我们越过的障碍。

**自私的解析器**

由于 GraphQL 里的解析器定义为独立运行的单元，而不用关心其他解析器在做什么，我们发现他们会对相同或类似的数据发起很多重复的网络请求。我们通过将数据提供者包装在一个简单的缓存层中来避免这种重复，该缓存层将网络响应存储在内存中，直到所有解析器都完成。缓存层还允许我们将多个对单个服务的请求聚合为一次对所有数据的批量请求。解析器现在可以请求他们需要的任何数据，而不必担心如何优化获取数据的过程。

![](https://cdn-images-1.medium.com/max/800/1*FZCtNPL4bXS6jpgVZx0RYg.png)

添加缓存以简化来自解析器的数据访问

**我们编写的繁杂网络**

抽象是提高开发人员效率的好方法 —— 直到出现问题为止。毫无疑问，我们的代码中会有bug，我们不想用中间层混淆(bug 产生的)根本原因。GraphQL 将自动编排对其他服务的网络调用，对用户隐藏复杂性。虽然服务器日志提供了一种调试方法，但是它们仍然比通过浏览器的 network 选项卡进行调试的自然方法少了一步。为了让调试更简单，我们直接将日志添加到 GraphQL 响应有效负载中，它公开了服务器发出的所有网络请求。当启用调试标志时，你将在客户端浏览器中获得与浏览器直接进行网络调用时相同的数据。

**拆分类型**

传递对象是面向对象编程(OOP)的全部，但不幸的是，GraphQL 将对这个范式造成冲击。当我们获取部分对象时，这些数据不能用于需要完整对象的方法和组件中。当然，你可以手动强制转换对象并抱着最好的希望，但是你将失去类型系统的许多好处。幸运的是，TypeScript 使用了 duck typing (译者注：鸭子类型，关注点在于对象的行为，能作什么；而不是关注对象所属的类型。[duck typing](https://en.wikipedia.org/wiki/Duck_typing))，所以只需要对它们真正需要的对象属性方法进行调整是最快的修复方式。虽然定义更精确的类型需要做更多的工作，但是总体上确保了更大的类型安全性。

### 接下来是什么

我们仍然处于探索 GraphQL 的早期阶段，但到目前为止都是一种积极的体验，我们很高兴能够接受它。这项工作的一个关键目标是，随着我们的系统变得越来越复杂，(它)帮助我们提高开发速度。我们不希望被复杂的数据结构所困，而是希望在图形数据模型上进行投资，随着时间的推移，随着更多的边缘和节点的添加，我们的团队会更加高效。甚至在过去的几个月里，我们已经发现我们现有的图形模型已经足够健壮，我们不需要任何图形更改就可以构建一些特性。它确实让我们变得更有效率。

![](https://cdn-images-1.medium.com/max/800/1*T3KO2GOY6EhoWUdQw8zuLQ.png)

我们的可视化 GraphQL 模型

随着GraphQL的不断发展和成熟，我们期待可以从社区中使用它构建和解决的所有令人惊叹的东西中学习。在实现级别上，我们期待使用一些很酷的概念，比如模式缝合，它可以使与其他服务的集成更加直接，并节省大量开发人员的时间。最重要的是，我们很开心地看到在公司[很多团队](https://medium.com/netflix-techblog/the-new-netflix-stethoscope-native-app-f4e1d38aafcd)发现 GraphQL 的潜力并开始采用它。

如果你已经做到了这一点，并且你也有兴趣加入 Netflix 营销技术团队来帮助克服我们独特的挑战，看看我们页面上列出的[空缺职位](https://sites.google.com/netflix.com/adtechjobs/ad-tech-engineering)。

**_我们正在招聘！_**

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
