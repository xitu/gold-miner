
> * 原文地址：[Coursera’s journey to GraphQL](https://dev-blog.apollodata.com/courseras-journey-to-graphql-a5ad3b77f39a)
> * 原文作者：[Bryan Kane](https://dev-blog.apollodata.com/@bryankane)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/courseras-journey-to-graphql.md](https://github.com/xitu/gold-miner/blob/master/TODO/courseras-journey-to-graphql.md)
> * 译者：[bambooom](https://github.com/bambooom)
> * 校对者：[sunui](https://github.com/sunui)、[alfred-zhong](https://github.com/alfred-zhong)

# Coursera 的 GraphQL 之路

将 GraphQL 添加至 REST + 微服务的后端中

Coursera 的客户端开发人员喜欢 GraphQL 的灵活性、类型安全性以及社区的支持，这些已经[众](https://building.coursera.org/blog/2016/11/23/why-ui-developers-love-graphql/)[所](https://speakerdeck.com/jnwng/going-graphql-first)[周](https://dev-blog.apollodata.com/graphql-just-got-a-whole-lot-prettier-7701d4675f42)[知](https://building.coursera.org/blog/2017/05/11/coursera-engineering-podcast-episode-one/)。但是，我们没有谈过多少我们的后端开发者们对于 GraphQL 的感受，这是因为实际上他们大多数并不需要为 GraphQL 考虑太多。

过去的一年中，我们构建了将所有 REST API 动态转换为 GraphQL 的工具。这使得后端开发者可以继续编写他们熟悉的 API，同时客户端开发者也可以通过 GraphQL 访问所有数据。

![](https://cdn-images-1.medium.com/max/1600/1*tUKO-HN2ogKRwmOc-kI-kQ.png)

本文中将介绍我们的 GraphQL 之旅，特别是过程中的成功及失败。

## 初步调查

Coursera 的 REST API 是基于资源构建的（即课程 API、教师 API、课程成绩 API 等）。这样使得开发和测试都很容易，并且在后端很好地实现了关注分离。然而，随着产品规模扩大以及 API 数量增长，我们开始面临性能、文档以及易用性等问题。在许多页面上，我们发现需要四到五次与服务器的往返来获取所有我们需要渲染的数据。

还记得 Facebook 首次推出 GraphQL 时我们团队非常兴奋，因为我们几乎立刻就意识到 GraphQL 可以解决我们的诸多问题，例如在一次往返获取所有数据，并为 API 提供结构化的文档等。虽然我们想马上停止使用 REST 并开始编写 GraphQL，但事情并非如此简单，因为：

- 当时，Coursera 有超过 1000 个不同的 REST 端点（现在更多），即使我们想完全停止使用 REST，GraphQL 的迁移成本将是极大的。

- 我们所有的后端服务都使用 REST API 进行服务间通信，所以经常会有给后端服务以及前端提供相同 API 的情况。

- 我们有三个不同的客户端（web、iOS 以及 Android），希望能灵活缓慢地推进。

在一些调查之后，我们发现了一个引入 GraphQL 的好方法，那就是在 REST API 上添加 GraphQL 的代理层。这个方法实际上也很常见，并且[有](https://medium.com/@raxwunter/moving-existing-api-from-rest-to-graphql-205bab22c184)[详细的](https://nordicapis.com/how-to-wrap-a-rest-api-in-graphql/)[文档](https://0x2a.sh/from-rest-to-graphql-b4e95e94c26b)[验证](http://graphql.org/blog/rest-api-graphql-wrapper/)过了，所以这里我就不深入展开了。

## 生产环境上使用 GraphQL

包装 REST API 是个非常简单的过程，我们针对下游 REST 调用通过解析器获取数据构建了一些实用程序，并写了一些将现有模型转为 GraphQL 的规则。

第一步是构建 GraphQL 解析器，然后在生产环境中启动一个 GraphQL 服务器，使下游 REST 调用到源端点。一旦完成了这项工作（用 GraphQL 来验证一切），我们就会在设置的演示页面展示数据，几天之内就可以说 GraphQL 的尝试成功了。

### 短暂的庆祝

如果说我从这个项目中学到了一件事，那一定是不要高兴太早。

我们的 GraphQL 服务器完美工作了几天，但是突然之间，在我们准备给团队演示之前，每个 GraphQL 查询都失败了。我们措手不及，因为自从上次验证它正常工作以来并没有对 GraphQL 服务器进行任何更改。

在调查之后，终于发现由于一个不相关的 bug，下游课程目录服务回滚到了之前的版本，导致 GraphQL 中构建的模式不同步了。我们可以手动更新并修复演示页面，但很快我们意识到当我们的 GraphQL 架构如果扩展到由超过 50 个不同的服务支持的 1000 个不同的资源之后，想保持所有数据都更新到最新几乎是不可能的。如果在微服务体系中你有多于一个数据来源，那么问题在于何时，而不是他们是否不同步。

### 自动化流程

所以我们回到了白板上，试图找出一个清晰的解决方案获得真实数据源。将 REST API 视为真实数据源是有道理的，因为 GraphQL 是基于它们构建的。为此，我们需要自动地确定性地构建 GraphQL 层，以反映当前体系中正在运行的内容，而不是我们认为正在运行的。

幸运的是（也许算有远见），我们的 [REST 框架](https://github.com/coursera/naptime)给我们提供了构建这个自动化层需要的一切：

- 基础架构中的每一个服务都可以动态地提供正在运行的 REST 资源列表。

- 针对每一个资源，我们可以内省获取其一系列端点和参数列表（即一个课程可以通过 id 获取，也可以由讲师查找）

- 另外，我们接受由 [Courier 的模式语言](http://coursera.github.io/courier/schemalanguage/)定义的 [Pegasus Schemas](https://github.com/linkedin/rest.li/wiki/DATA-Data-Schema-and-Templates)，用于每个模型返回数据

只要发现不同的部分，我们就需要构建一个 GraphQL 模式，在 GraphQL 服务器上设置一个任务，每五分钟对所有下游服务 ping 一次，请求所有信息。然后，我们就可以在 Pegasus 模式和 GraphQL 类型之间编写 1:1 的转化层了。

接下来，我们只需要简单定义如何将 GraphQL 查询转化为 REST 请求，使用以前的解析器中的大部分逻辑，就可以生成功能完整的 GraphQL 服务器，不再会过期 5 分钟以上。

### 关联资源

我们希望使用 GraphQL 的一个主要原因是在一个往返中获取某个页面需要的所有数据。但是一开始我们的方法只能提供 REST API 以及 GraphQL 之间一对一的映射。没有将资源连接在一起，我们仍然会像使用 REST API 一样，使用多次 GraphQL 查询来获取数据。虽然通过 GraphQL 获取用户数据相比使用 REST 来说，开发者体验有所提升，但如果在获取更多数据之前必须等待前序查询返回的话，那么在性能上没有实质提升。

我们的每个 REST API 都独立存活，他们不需要知道其他任何 API 的存在。但是，如果使用 GraphQL，模型和资源确实需要彼此的存在，以及如何连接。

资源之间的连接是不能自动添加的，所以我们定义了一个简单的标记方法，使得开发者可以添加资源并指定资源之间的关系。例如，我们可以指定一个课程应该有讲师字段，代表教授这门课程的讲师。获取这些讲师的时候，需要使用 id 查询，此时就可以使用课程已经提供的 `instructorIds` 字段。我们称之为「前置关系」，因为我们通过 id 确切知道哪些讲师需要获取。

在想要从一个资源到另一个资源但没有显式关联的情况下，我们添加了反向查询的支持，也就是获取一个用户在一个课程的注册情况。我们可以在 `userEnrollments`.v1 资源上通过 `byCourseId` 进行查询，就可以返回在指定的课程中指定用户的注册数据。

我们开发的语法看起来像这样：

```js
courseAPI.addRelation(
  "instructors" -> ReverseRelation(
    resourceName = "instructors.v1",
    finderName = "byCourseId",
    arguments = Map("courseId" -> "$id", "version" -> "$version"))
```

一旦这些关联到位，我们的 GraphQL 模式就开始汇集在一起了，不再是小量数据碎片，而是整个 Coursera 数据和资源的网络。

## 结论

我们已经在生产环境中运行 GraphQL 服务器 6 个月了，这条路有时是颠簸的，但我们切实认识到 GraphQL 带来的好处。开发人员更容易发现数据及编写查询，我们的产品也由于 GraphQL 额外提供的[类型安全性](https://github.com/apollographql/apollo-codegen)更加可靠，使用 GraphQL 获取数据的页面加载也更快。

需要重点提出的是，这种迁移并不以开发效率为代价。我们的前端工程师的确需要学习如何使用 GraphQL，但我们并不需要重写后端 API 或运行复杂的迁移才能享受 GraphQL 带来的好处。当创建新的应用程序的时候，它就可供开发人员使用了。

总的来说，我们对 GraphQL 为开发人员（最终为用户）提供的帮助非常满意，并对 GraphQL 生态的发展充满期待。

### 致谢

- [Brennan Saeta](https://twitter.com/bsaeta)，编写了 Naptime API库，并帮助 Naptime 编写了初始的 GraphQL 支持。
- Oleg Ilyenko，编写的 [Sangria 库](http://sangria-graphql.org/) 为我们所有的 GraphQL 工作提供了支柱。如果你正在使用 GraphQL，并正在使用或计划使用 Scala，那么你一定要看看 Sangria。
- Coursera 前端基础设施团队提供了帮助将 GraphQL 从测试项目转移至预备生产环境中。
- Coursera 的整个工程团队的耐心以及帮助，我们一起在 GraphQL 层解决了无数 bug 和奇怪的现象。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
