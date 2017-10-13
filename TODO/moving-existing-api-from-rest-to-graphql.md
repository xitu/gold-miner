
> * 原文地址：[Moving existing API from REST to GraphQL](https://medium.com/@raxwunter/moving-existing-api-from-rest-to-graphql-205bab22c184)
> * 原文作者：[Roman Krivtsov](https://medium.com/@raxwunter)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/moving-existing-api-from-rest-to-graphql.md](https://github.com/xitu/gold-miner/blob/master/TODO/moving-existing-api-from-rest-to-graphql.md)
> * 译者：[zaraguo](https://github.com/zaraguo)
> * 校对者：

# 将现有的 API 从 REST 迁移到 GraphQL

最近的六个月内我发现几乎每一场有关于 Web 开发的大会都谈论到了 GraphQL。也有大量与其相关的文章被发表。但是所有的这些几乎都是在讲 GraphQL 的基础概念或者是新特性，说得很表面。因此我打算谈谈我在真实大型系统中采用 GraphQL 的个人经验。

### REST 有什么问题

REST（一如 SOAP）没有分离传输、安全和数据逻辑层面。这会带来很多问题。让我们来看看其中的几个。

#### GET 查询能力的低下

用 GET 语句进行复杂深入的查询是不可能的。假设我们需要查询用户。举一个很简单的例子：

**GET** /users/?name=Homer

然后想象一下，我们需要查找名字是 Homer 或者 Marge 的用户。事情就变得有点棘手了。当然，我们可以为这种需求定义一些分隔符。

**GET** /users/?name=Homer|Marge

但是，不要忘记转义这些字符！并且牢记，如果有人的名字中包含 “|” 那么你就完蛋啦。如果要结合两个不同的字段那么就更复杂了。更别说是需要同时满足上面两种条件的查询。

目前我们一般都是使用字段来查询对应的内容。但是也时常需要用查询语句来传递一些服务数据。比如页码：

**GET** /users/?name=Homer|Marge&limit=10&offset=20

按逻辑来说，我们后端的查询解析器应该会将 limit 和 offset 识别为数据库的字段，因为他们被声明为和 “name” 字段同级的参数名。

我们可以发明我们自己的语法或是用 POST 方法（这是不对的，因为这是一个幂等请求）但是这看起来像是在造轮子。

#### 数据更新的问题

使用 PUT 发送整个对象是最简单的 REST 更新数据的方式。但显而易见的是，当你仅仅只需要更新 1 Mb 大小的对象中的一个字段时，这并不是最有效的方式。

HTTP 还有一个 PATCH 方法。但是它有一个问题。用算法来定义 **如何更新实体** 并不简单。现有多个规范建议你应该如何去做，比如 *RFC 6902，RFC 7396* 以及许多自定义解决方案。

#### 命名问题

我猜测每个曾与 REST 打交道的开发者都明白这种感受，当你不知道如何去命名你的新路由时。并非所有的业务实例都可以被描述为资源。例如我们想要搜索带有商店信息的商品。

**GET** /search?product_name=IPhone&shop_name=IStore

这里的资源是什么？商品？商店？搜索？

天哪，我的 API 不再是 REST 风格了！

另一个典型的例子便是用户登录。这里的资源又是什么？Spoiler：这里没有资源，这里只是个远程过程调用而已。

#### 后端处理 REST

```
app.post((req, res) => {
  const user = db.getUserByName(req.headers.name);
  const user = db.getUserByName(req.query.name);
  const user = db.getUserByName(req.path.name);
  const user = db.getUserByName(req.body.name);
});
```

这是一个 Express 路由的例子。这里我们试图获取用户的 ID 来查找用户。让我们看一看 API 函数通常应该是什么样子：

![](https://cdn-images-1.medium.com/max/1200/1*-x82CcGJlLIOOJtRRBRNSg.png)

函数接收参数，进行特定的处理并返回特定的结果。

在这个 Express 路由的例子中我们的参数是什么？一个巨大杂乱的 *req* 对象，而我们仅需要其中很小的一部分数据。

当然，这也是 Express 的一个问题（准确的说是 Node 的 HTTP 模块的问题），但是这样的接口也是因为 HTTP 的实现逐步进化而产生的 - 请求参数可以在任何位置，所以如果你本人不知道它或者没有使用描述良好的文档时想要准确知道参数位置是不可能的。

这就是为什么使用没有接口文档的 REST 是如此的痛苦。

### GraphQL

在这里我们假设你早就熟悉 GraphQL 的基础知识。如果没有，你可以从 Apollo 写的关于 [GraphQL 基础知识](https://medium.com/apollo-stack/the-basics-of-graphql-in-5-links-9e1dc4cac055#.uyc4ml4jx)的介绍开始。

正如我们前面所展示的，REST 存在一些 GraphQL 所没有的设计上的问题。并且 GraphQL 有着巨大的发展潜力。

首先 GraphQL 提供 RPC 访问方式，这意味着你将不受客户端-服务端的交互限制。GraphQL 有它自己的类型系统，这意味不再有令人误解的错误和漏洞。并且类型系统意味着你的客户端可以提供 item 级别的数据智能缓存。还拥有大量像是网络连接（游标和分页）、批处理、延时等的面向 Web 的特性。它 **使你的客户端-服务端交互尽可能的高效**。

> 但是 REST 仍然是业内标准

是的，无论我们是否喜欢，REST 都是近几年 API 的主流形式。 

但是我们仍然可以为一些内部需求（比如对接一些高级客户端）去使用 GraphQL，其他的使用 REST。

为此，我们需要将 REST 路径包装成 GraphQL 类型。这里有一些文章和例子（被提到最多的是 [swapi-rest-graphql](https://github.com/apollostack/swapi-rest-graphql)）关于从 REST 迁移到 GraphQL。但是它们建议使用自定义解析器，这无法满足拥有成百上千路径的大型项目。

在我最近的三个项目中我使用 [Swagger](http://swagger.io) 来描述 REST 接口。它或多或少都算是声明式接口描述的标准。坦白说我真的不知道那些编写庞大却毫无描述的接口的人们是如何做到的。

一方面我们把 Swagger 作为声明式 REST 接口的标准，另一方面也可以这么看 GraphQL，我们可以看到它们其实非常相似，只是除此之外 Swagger 还尝试去描述 HTTP 细节和业务逻辑。**它们都描述了传入参数和传出响应的类型**。这意味着我们可以在它们之间写适配器！ 

![](https://cdn-images-1.medium.com/max/1200/1*R55lFpFRNqkScfMnTXpPfw.png)

REST 路径是这样子的

**GET** /user/id

可以采用 GraphQL 类型。

所以现在我们只需一个库来帮助我们自动转换。下面这个就是！

[https://github.com/yarax/swagger-to-graphql](https://github.com/yarax/swagger-to-graphql)

Swagger2graphQL 接收你的 Swagger schema 然后返回 GraphQL schema，同时解析程序将自动构建 HTTP 请求到已有的 REST 路径上。

它被构建为一个将拥有超过 150 个路径的真实大型系统迁移到 GraphQL 的副项目。我们需要在做功和问题都最少的情况下尽快地迁移到 GraphQL。

只需要克隆资源库，运行

*npm install && npm start*

然后访问 [http://localhost:3009/graphql](http://localhost:3009/graphql)

你会看到封装在 [http://petstore.swagger.io/](http://petstore.swagger.io/) Swagger 示例接口上的 GraphQL 接口。

而且，有了 Swagger 和 GraphQL 编写新的路径将变得十分方便。如果你早就熟悉 GraphQL，你可能会发现有时候类型描述看起来相当冗长，因为你需要去创建大量的隐式类型。Swagger2graphQL 可以自动完成这些步骤，你只需要在 Swagger schema 中创建一个新的带有声明的路径，通常这很简单。

如果你遇到任何困难或者有疑问请向我提 issue！

同时你也可以在 [Twitter](http://twitter.com/raxpost) 上找到我


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
