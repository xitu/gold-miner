> * 原文地址：[Best Practices in Designing GraphQL APIs](https://medium.com/@zavilla90/best-practices-in-designing-graphql-apis-395225bdcd1)
> * 原文作者：[Zenia Villa](https://medium.com/@zavilla90?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/best-practices-in-designing-graphql-apis.md](https://github.com/xitu/gold-miner/blob/master/TODO/best-practices-in-designing-graphql-apis.md)
> * 译者：
> * 校对者：

# Best Practices in Designing GraphQL APIs

Below are the best practices for GraphQL API design as outlined by Lee Byron, Design Technologist at Facebook at the GraphQL Summit.

#### Naming matters

It’s easy to think that you can use a name and then later decide to refactor if you come to realize that it could be better. The problem in a graphical API is that as soon as a client is making use of a field, you’re kind of stuck. A naming mistake could be expensive. An important question to ask to avoid that is: “Would a new engineer understand this?” Keep in mind that a lot of developers will skip documentation and try out field names they would imagine are part of the schema. It makes sense to try out “title” when querying a book title, and with that said, it’s important to come up with names that are self-documenting and adhere close to what they actually do.

#### Design for the future

This is important in order to avoid breaking changes in the future. A helpful question would be: “What might version two of the product or feature look like?” When designing the API, we have some product or feature in mind, and we’re mapping from that to enable the API we want. Figure out if this API will support this amazing product you’ve dreamed up.

#### Think in Graphs, not endpoints

Most traditional APIs start with some new product experience and work backwards to design the API for that experience. GraphQL is different and exposes all the data from a single endpoint. If you‘re thinking in terms of endpoints, you might create objects that are solely defined by their purpose as an endpoint versus describing the semantics of the data you’re modeling. If you instead frame that problem as objects in a graph and separate the data away from the feature you’re building, the outcome is a single, cohesive graph.

#### Describe the data, not the view

Make sure you’re not tying APIs too closely to the demands of your current client, such as a phone app. You wouldn’t want to create APIs that work perfectly in a TV app but break in a web app. Instead of thinking about the view, stay focused on that semantic data. Make sure to ask yourself, “Will this work for future clients?”

#### GraphQL is a thin interface

Keep in mind that GraphQL is designed to be a thin interface that sits on top of your current systems and systems yet to be built.

#### Hide implementation details

When designing APIs, ask yourself, “What if the implementation changes?” A change such as moving the database from SQL to Mongo. Does the API continue to make sense after those changes? This best pratice allows us to prototype quickly, scale easily, and deploy new services without interrupting the client.


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
