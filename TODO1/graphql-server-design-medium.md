> * 原文地址：[GraphQL Server Design @ Medium](https://medium.engineering/graphql-server-design-medium-34862677b4b8)
> * 原文作者：[Sasha Solomon](https://medium.engineering/@sachee?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/graphql-server-design-medium.md](https://github.com/xitu/gold-miner/blob/master/TODO1/graphql-server-design-medium.md)
> * 译者：
> * 校对者：

# GraphQL Server Design @ Medium

![](https://cdn-images-1.medium.com/max/1600/1*LxzBwQmETizo-ZA_jiBLiQ.png)

A while ago, [we told the story](https://medium.engineering/2-fast-2-furious-migrating-mediums-codebase-without-slowing-down-84b1e33d81f4) of how we are migrating to [React.js](https://reactjs.org/) and a service oriented architecture with the help of [GraphQL](https://graphql.org/). Now, we want to tell the story of how the structure of our GraphQL server helped make our migration much smoother.

We had three things in mind when we began designing our GraphQL server:

**It should be easy to alter the shape of the data  
**We currently use [protocol buffers](https://en.wikipedia.org/wiki/Protocol_Buffers) as a schema for data that comes from our backend. However, the way we use our data has changed over time, but our protobufs haven’t caught up. This means that our data isn’t always the shape that the clients need.

**It should be clear what data is for the client  
**Within our GraphQL server, data is being passed around and exists in different stages of “readiness” for the client. Instead of mixing the stages together, we wanted to make the stages of readiness explicit so we know exactly what data is meant for the client.

**It should be easy to add new data sources  
**Since we are moving to a service oriented architecture, we wanted to make sure it was easy to add new data sources to our GraphQL server, and make it explicit where data comes from.

With these things in mind, we came up with a server structure that had three distinct roles:

Fetchers, Repositories (Repos), and the GraphQL Schema.

![](https://cdn-images-1.medium.com/max/1600/1*HcISBhsiC8gaLbfanw4L1A.png)

a layer cake of responsibility

Each layer has it’s own responsibilities, and only interacts with the layer above it. Let’s talk about what each layer does specifically.

### Fetchers

![](https://cdn-images-1.medium.com/max/1600/1*BmEv_S_KuHP2NJJbcU1qzw.png)

fetch the data from any number of sources

Fetchers are for fetching data from data sources. The data that is fetched by the GraphQL server should already have gone through any business logic additions or changes.

Fetchers should correspond to a REST or preferably a gRPC endpoint. Fetchers require a protobuf. This means that any data that is being fetched by a Fetcher must follow the schema defined by the protobuf.

### Repositories

![](https://cdn-images-1.medium.com/max/1600/1*KDWPV1Q40zj6QFlAKgwpmw.png)

shape the data for what the client needs

Repos are what the GraphQL schemas will use as a data representation. The repo “stores” the cleaned-up data that originally came from our data sources.

In this step, we hoist up and flatten fields and objects, move data around, etc. to change the data shape to be what the client actually needs.

This step is necessary for moving from a legacy system because it gives us the freedom to update the data shape for the client without having to update or add endpoints or their corresponding protobufs.

Repos only access data retrieved from Fetchers and never actually fetch the data themselves. To put it another way, Repos only create the _shape_ of the data we want, but they don’t “know” where we get the data from.

### GraphQL Schema

![](https://cdn-images-1.medium.com/max/1600/1*B0nY7N8wYNlWOCEJba7CwQ.png)

derive the schema for the client from our repo objects

The GraphQL Schema is the form our data will take when it gets sent to the clients.

The GraphQL schema only uses data from Repos and will never access Fetchers directly. This keeps our separation of concerns clear.

In addition, our GraphQL schema is completely derived from our Repo objects. The schema doesn’t alter the data at all, nor does it need to: the Repo has already changed the shape of the data to be what we need, so the schema just needs to use it and that’s it. In this way, there isn’t confusion about what the data shape is or where we can manipulate the shape.

### GraphQL Server Data Flow

![](https://cdn-images-1.medium.com/max/1600/1*VCs9aXb1RdBFYMhoFJsjjw.png)

how data flows through our GraphQL server

The data’s shape becomes more like what the client needs as it passes through each of the distinct layers. It’s clear where the data comes from at each step and we know what each piece of the server is responsible for.

These abstraction boundaries mean that we can incrementally migrate our legacy system by replacing different data sources, but without rewriting our entire system. This has made our migration path clear and easy to follow and makes it easy to work towards our service oriented architecture without changing everything at once.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
