> * 原文地址：[6 Months Of Using GraphQL](https://levelup.gitconnected.com/6-months-of-using-graphql-faa0fb68b4af)
> * 原文作者：[Manish Jain](https://medium.com/@jaiin.maniish)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/6-months-of-using-graphql.md](https://github.com/xitu/gold-miner/blob/master/article/2020/6-months-of-using-graphql.md)
> * 译者：
> * 校对者：

# 6 Months Of Using GraphQL

Having worked on a project for 6 months using GraphQL on the backend, I weigh up the technology’s fit into the development workflow

![The output from my terminal](https://cdn-images-1.medium.com/max/2526/1*SYo5JVMz3D79G_OEfs8q_g.png)

## First and Foremost

GraphQL is a query language for APIs and a runtime for fulfilling those queries with your existing data. GraphQL provides a complete and understandable description of the data in your API as well as gives clients the power to ask for exactly what they need and nothing more.

It was developed by Facebook as an internal solution for their mobile apps and was later open-sourced to the community.

## The good

#### Pragmatic Data Exchange

With GraphQL, the query can be defined for the fields which the client needs, nothing more and nothing less. It’s really that simple. If the **frontend** needs `**first name**` and `**age**` of a **person**, it can only ask for that. The `**last name**` and `**address**` of the `**person**` would not be sent in the response.

#### Using Dataloaders to Reduce Network Calls

Although Dataloaders are not a part of the GraphQL library itself it is a utility library that can be used to decouple unrelated parts of your application without sacrificing the performance of batch data-loading. While the loader presents an API that loads individual values, all concurrent requests will be combined and presented to your batch loading function. This allows your application to safely distribute data fetching throughout your application.

An example of this would be fetching `**bank details**` of the `**person**` from a different service called **transaction service**, the **backend** can fetch the `**bank details**` from the **transaction service** and then combine that result with the `**first name**` and the `**age**` of the `**person**` and send the resource back.

#### Decoupling between exposed data and database models

One of the great things about GraphQL is the option to decouple the database modeling data with how the data is exposed to consumers. This way when designing our persistence layer, we could focus on the needs of that layer and then separately think about what's the best way to expose the data to the outside world. This goes hand in hand with the usage of Dataloaders since you can combine your data together before sending it to the users it becomes really easy to design the models for exposed data.

#### Forget about versioning of APIs

Versioning of APIs is a common problem and generally, it is fairly simple to solve by adding a new version of the same APIs by appending a **v2** in front of it. With GraphQL the story is different, you can have the same solution here but that is not going to go well with the spirit of GraphQL. The documentation clearly states that you should evolve your APIs meaning adding more fields to an existing endpoint would not break your API. The frontend can still query using the same API and can ask for the new field if needed. Pretty simple.

This particular feature is really useful when it comes to collaborating with the frontend team. They can make a request to add a new field that is required because of the design change and the backend can easily add that field without messing with the existing API.

#### Independent Teams

With GraphQL, the front-end and back-end teams can work independently. With the strictly typed schema that GraphQL has, the teams can work in parallel. Firstly the **frontend team** can easily generate a schema from the backend without even looking at the code. The schema generated can directly be used to create queries. Secondly, the **frontend** **team** can continue working with just a mock version of the API. They can also test the code with it. This gives the developers a pleasant experience without stalling their development work.

![Photo by [Perry Grone](https://unsplash.com/@perrygrone?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/10944/0*ClSi_KEJVSWlHwUL)

## The bad

#### Not all APIs can be evolved

Sometimes there would be changes trickling down from the business or design which would require a complete change in the implementation of an API. In that case, you would have to rely on the old ways to do the versioning.

#### Unreadable code

As experienced multiple times, the code sometimes can become scattered into multiple places while using Dataloaders to fetch the data and that could be difficult to maintain.

#### Longer response times

Since the queries can evolve and become huge, it can sometimes take a toll on the response time. To avoid this, make sure to keep the response resources concise. For guidelines have a look at the [Github GraphQL API.](https://developer.github.com/v4/)

#### Caching

The goal of caching an API response is primarily to obtain the response from future requests faster. Unlike GraphQL, caching is built into in the HTTP specification which RESTful APIs are able to leverage. And as mentioned earlier a GraphQL query can ask for any field of a resource, caching is inherently difficult.

## Conclusion

I will highly recommend using GraphQL as a replacement for REST APIs. The flexibility offered by GraphQL definitely supersedes the pain points it has. The good and bad points mentioned here may not always apply, but it is worth taking them into consideration while looking at GraphQL to see if they can help your project.

If you have any comments, please post them below.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
