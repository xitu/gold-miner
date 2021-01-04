> - 原文地址：[Loving GraphQL More than REST](https://medium.com/javascript-in-plain-english/loving-graphql-more-than-rest-4e213c568635)
> - 原文作者：[Saurav Singh](https://medium.com/@snipextt)
> - 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> - 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/loving-graphql-more-than-rest.md](https://github.com/xitu/gold-miner/blob/master/article/2020/loving-graphql-more-than-rest.md)
> - 译者：[NieZhuZhu（弹铁蛋同学）](https://github.com/NieZhuZhu)
> - 校对者：[regon-cao](https://github.com/regon-cao)、[司徒公子](https://github.com/stuchilde)

# 爱 GraphQL 胜过 REST

![](https://cdn-images-1.medium.com/max/2240/1*ZxDw0j3ANBxpatoCdNW8JQ.png)

自从 Facebook 开源 GraphQL 以来，GraphQL 越来越受欢迎，直到今天它已经是几乎无处不在。到底是什么使它如此受欢迎？它与 REST 架构设计规范的区别是什么？它会完全地取代 REST API 吗？下面是我对 GraphQL 的一些思考。

当我第一次学习 GraphQL 时，我对它一无所知。在我学习 GraphQL 的过程中，甚至在开始学习 GraphQL 之前我就意识到了同样的想法，我将要学习的是一个与 Rest API 完全不同的东西：

**GraphQL 是一个独立存在的，没有使用我们熟悉的 REST API 内容。**

这个想法有点不切实际和滑稽，但这却正是 GraphQL 给从未接触过它的人所显露出来的样子。

#### 那么 GraphQL 到底是什么？

如果要我用最简单的术语来定义 GraphQL，那么我会说它是一个**规范**，是使用我们现有的网络技术非常厉害的一种方式。GraphQL queries 本质是一个简单的链接到 API 端的 HTTP POST 请求。是的，它被设计成需要用一个包含 GraphQL queries 的 HTTP POST 请求去和后端通信。让我们通过快速构建 GraphQL 服务器来查看示例。

为了简单起见，我将使用 `Nodejs` 构建。因为 GraphQL 本身就有一个运行上下文，所以构建 API 所用的语言无关紧要。接下来让我们快速安装依赖项：

`yarn add apollo-server moment`

并构建一个简单的 GraphQL API

```JavaScript
const { ApolloServer, gql } = require("apollo-server");
const moment = require("moment");

const server = new ApolloServer({
  resolvers: {
    Query: {
      getDateTime: () => ({
        date: moment().format("MMM DD YYYY"),
        isoString: new Date().toISOString(),
      }),
    },
  },
  typeDefs: gql`
    type dateTime {
      date: String!
      isoString: String!
    }
    type Query {
      getDateTime: dateTime
    }
  `,
});

server
  .listen(4000)
  .then(() =>
    console.log(
      `Application worker ${process.pid} is running a server at http://localhost:4000`
    )
  );
```

执行一个查询

![](https://cdn-images-1.medium.com/max/2000/1*mTjqS4y5E1JZzhuxSjKwaQ.jpeg)

#### 等一下，这就是在 GraphQL 中执行查询的方式吗？

是的，如果您曾经接触过 GraphQL 训练场 就知道到我上面所说的是完全正确的。一个 GraphQL 客户端（包括 GraphQL 训练场）使用与上面类似的主体向指定的 API 端点/通道发送 POST 请求。GraphQL 运行上下文能够知道如何处理请求，因为它对将要获取和返回的数据的 `schema` 有感知。

但是，当您想要返回类型定义中未指定值时，这通常会导致意想不到的行为，因为 GraphQL 会自动地尝试对值进行类型转换，并在不起作用时崩溃。

> 说明 —— 对 GraphQL API 的每个请求都会被归类为查询，包括变更，订阅和查询。

#### Schema 特性是 GraphQL 如此强大的唯一原因吗？

不，远远不止于此，GraphQL 为您的 API（尤其是客户端）带来了更多的可能，GraphQL 通过支持仅返回 query 中的特定字段，达到仅查询所需的数据而忽略其余不需要的数据的效果，从而减小了传输数据的大小，带宽和延迟。让我们修改一下上面的代码：

```JavaScript
const { ApolloServer, gql } = require("apollo-server");
const moment = require("moment");

const server = new ApolloServer({
  resolvers: {
    Query: {
      getDateTime: () => ({
        date: moment().format("MMM DD YYYY"),
        isoString: new Date().toISOString(),
        localString: new Date().toLocaleString(),
      }),
    },
  },
  typeDefs: gql`
    type dateTime {
      date: String!
      isoString: String!
      localString: String!
    }
    type Query {
      getDateTime: dateTime
    }
  `,
});

server
  .listen(4000)
  .then(() =>
    console.log(
      `Application worker ${process.pid} is running a server at http://localhost:4000`
    )
  );

```

我们在 dateTime 类型中添加了另一个字段，这次我们不想查询其他两个字段。这真的非常简单，我们要做的就是在发出如下请求时指定我们感兴趣的字段：

![](https://cdn-images-1.medium.com/max/3158/1*5zaQAUnUIov7mPj2ygLk1w.jpeg)

对于小型应用，这个效果可能不会太明显。但是对于大型的应用来说，您总会想要一个最优的解决方案。由于仅查询需要的字段这个想法本身就很棒，因此这个想法一直都是传统 REST 架构中的一部分，并且为检索某些特定数据的解决方案指明了道路。这对于小型应用程序甚至在理论上都没有问题，但是随着应用程序大小的增加（比如 Facebook），数据传输的连接线会变得越来越复杂，最终您将不得不重新设计整个系统去使用 GraphQL 之类的解决方案，或者最终将导致重新写一个 GraphQL。

GraphQL 还附带了许多很酷的功能（比如“订阅”），如果有机会我会写一篇文章谈一谈 GraphQL 是否比传统的 REST API 更好。

#### GraphQL 是否真的是更好的 REST，并将完全取代它？

我同意 GraphQL 是更好的 REST 版本，它是 REST 的强大替代品，但它不会在今天或不久的将来完全取代 API。造成这种情况的原因有两个。

**对于小型应用程序，REST API 几乎可以完成 GraphQL API 的所有工作。**

由于 GraphQL 通过允许客户端仅查询所需字段来为客户端带来更多功能。但是，如果客户端的请求嵌套大量字段，并且需要涉及多个资源（例如从文件系统或数据库读取），那么这个强大功能将会牺牲掉服务端的性能。而且，假设需要支持数亿个这样的请求，如果您的服务器无法进行快速扩容的话，那么这将会导致服务器的资源被耗尽。

以上就是为什么在**企业界，GraphQL API 会与 REST API 结合来使用的原因。**

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
