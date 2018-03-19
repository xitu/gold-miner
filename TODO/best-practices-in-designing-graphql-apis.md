> * 原文地址：[Best Practices in Designing GraphQL APIs](https://medium.com/@zavilla90/best-practices-in-designing-graphql-apis-395225bdcd1)
> * 原文作者：[Zenia Villa](https://medium.com/@zavilla90?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/best-practices-in-designing-graphql-apis.md](https://github.com/xitu/gold-miner/blob/master/TODO/best-practices-in-designing-graphql-apis.md)
> * 译者：[Jiang Haichao](https://github.com/AceLeeWinnie)
> * 校对者：[缪宇](https://github.com/goldEli), [moods445](https://github.com/moods445)

# GraphQL API 设计最佳实践

以下是由 Lee Byron 提出的 GraphQL API 设计最佳实践， 他是 GraphQL 峰会上 Facebook 的设计技术专家。

#### 重视命名

最常见的情况是，你命名了一个名称，意识到这个命名有问题之后，于是决定重命名。可问题是，图形化 API 中某字段一旦被客户端使用，就不可更改了。所以错误命名的成本可能是高昂的。时刻反问一个重要的问题来提醒自己：“新来的工程师是否能够明白这一命名的含义？”时刻铭记有些工程师会绕过文档，尝试各种他们想当然的字段名称。当查询书名时，通常使用 “title” 字段，这说明定义的名称需要是自文档化的，并且含义要和实际用途保持接近。

#### 前瞻性设计

为了避免未来破坏性的变更，前瞻性设计十分必要。自问一个问题很有帮助：“这个产品或功能的下一个版本可能是什么样的？” 设计 API 时，心中要有下一版本的雏形，然后根据雏形设计 API。设想这个 API 是否能够支持心中理想的未来产品的需要。

#### 从 Graph 角度思考，而不是 endpoint 角度

大多数传统的 API 都是从一些新的产品体验开始的，并且根据这些体验向后设计 API。GraphQL 则不同，它在一个 endpoint 中暴露所有数据。如果你考虑的是 endpoint，你可能会创建多个 object，根据用途单独定义对象，而不是描述建模数据的语义。如果你将这个问题作为 Graph 中的对象，并将数据与你正在构建的功能分离开来，结果就是一个单一的、内聚的 Graph。

#### 描述数据，而不是视图

确保没有将 API 与当前客户端需求紧密联系在一起，比如手机 app。创建的 API 只用于 TV app，而不适用于 web app，这当然不是你想要的。保持关注数据的语义，而不是过多地关注视图。反问自己一个问题：“这个 API 适用于未来客户端吗？”

#### GraphQL 是简化的接口

记住，GraphQL 是设计用于当前系统之上简化接口，仍然需要搭建系统。

#### 隐藏实现细节

当设计 API 时，问自己的一个问题，“如果底层实现变更了怎么办？” 诸如数据库从 SQL 迁移到 Mongo 之类的。变更之后这个 API 是否仍旧适用？最佳实践允许我们快速创建原型，轻松扩展，不需要中断客户端就能部署新的服务。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
