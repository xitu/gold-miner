> * 原文地址：[So what’s this GraphQL thing I keep hearing about?](https://medium.freecodecamp.com/so-whats-this-graphql-thing-i-keep-hearing-about-baf4d36c20cf)
> * 原文作者：本文已获原作者 [Sacha Greif](https://medium.freecodecamp.com/@sachagreif) 授权
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：[lsvih](https://github.com/lsvih)
> * 校对者：[xiaoyusilen](https://github.com/xiaoyusilen),[steinliber](https://github.com/steinliber)

![](https://cdn-images-1.medium.com/max/2000/1*uF2-YU2quykHIs4tKXy7sw.png)

# 我经常听到的 GraphQL 到底是什么？ #

当听说出了一门新技术的时候，你可能会和我一样有以下 3 种反应：

#### 1. 嫌弃 ####

> 又来一个 JavaScript 类库？反正我只用 JQuery 就行了。

#### 2. 感兴趣 ####

> 嗯，也许我**应该**去了解一下这个我总是听别人说到的新库。

#### 3. 恐慌 ####

> 救命啊！我必须**马上**去学这个新库，否则我就会被淘汰了！

在这个迅速发展的时代，让你保持理智的方法就是保持上述第二或第三种态度去学一些新的知识，走在潮流之前的同时激起你的兴趣。

因此，现在就是学习 GraphQL 这个你常常听到别人谈论的东西的最好时机！

### 基础 ###

简单的说，GraphQL 是一种**描述请求数据方法的语法**，通常用于客户端从服务端加载数据。GraphQL 有以下三个主要特征：

- 它允许客户端指定具体所需的数据。
- 它让从多个数据源汇总取数据变得更简单。
- 它使用了类型系统来描述数据。

如何入门 GraphQL 呢？它实际应用起来是怎样的呢？你如何开始使用它呢？要找到以上问题的答案，请继续阅读吧！

![](https://cdn-images-1.medium.com/max/800/1*NpFL8vnrMQ-D1L6T89T-4A.png)

### 遇到的问题 ###

GraphQL 是由 Facebook 开发的，用于解决他们巨大、老旧的架构的数据请求问题。但是即使是比 Facebook 小很多的 app，也同样会碰上一些传统 REST API 的局限性问题。

例如，假设你要展示一个文章（`posts`）列表，在每篇文章的下面显示喜欢这篇文章的用户列表（`likes`），其中包括用户名和用户头像。这个需求很容易解决，你只需要调整你的 `posts` API 请求，在其中嵌入包括用户对象的 `likes` 列表，如下所示：

![](https://cdn-images-1.medium.com/max/800/1*VuIe8p5Z00HAdnWTv0QUww.png)

但是现在你是在开发移动 app，加载所有的数据明显会降低 app 的速度。所以你得请求两个接口（API），一个包含了 `likes` 的信息，另一个不含这些信息（只含有文章信息）。

现在我们再掺入另一种情况：`posts` 数据是由 MySQL 数据库存储的，而 `likes` 数据却是由 Redis 存储的。现在你该怎么办？

按着这个剧本想一想 Facebook 的客户端有多少个数据源和 API 需要管理，你就知道为什么现在评价很好的 REST API 所体现出的局限性了。

### 解决的方案 ###

Facebook 提出了一个概念很简单的解决方案：不再使用多个“愚蠢”的节点，而是换成用一个“聪明”的节点来进行复杂的查询，将数据按照客户端的要求传回。

实际上，GraphQL 层处于客户端与一个或多个数据源之间，它接收客户端的请求然后根据你的设定取出需要的数据。还是不明白吗？让我们打个比方吧！

之前的 REST 模型就好像你预定了一块披萨，然后又要叫便利店送一些日用品上门，接着打电话给干洗店去取衣服。这有三个商店，你就得打三次电话。

![](https://cdn-images-1.medium.com/max/800/1*LVQb9_hxti9j-fY7SH3aKA.png)

GraphQL 从某方面来说就像是一个私人助理：你只需要给它这三个店的地址，然后简单地告诉它你需要什么 （“把我放在干洗店的衣服拿来，然后带一块大号披萨，顺便带两个鸡蛋”），然后坐着等他回来就行了。

![](https://cdn-images-1.medium.com/max/800/1*AFX14UE3utIs7xktnxVIng.png)

换句话说，为了让你能和这个神奇的私人助手沟通，GraphQL 建立了一套标准的语言。

![](https://cdn-images-1.medium.com/max/1000/1*tulrgfYYaRaDetz7jP5Q-g.png)

上图是 Google 图片找的，有的私人助理甚至有八条手臂。

![](https://cdn-images-1.medium.com/max/800/1*nC8aB5GHMhUEV28GdvSb5Q.png)

理论上，一个 GraphQL API 主要由三个部分组成：**schema（类型）**，**queries（查询）** 以及 **resolvers（解析器）**。

### 查询（Queries） ###

你向你的 GraphQL 私人助理提出的请求就是 `query` ，query 的形式如下所示：

```
query {
  stuff
}
```

在这里，我们用 `query` 关键字定义了一个新的查询，它将取出名叫 `stuff` 的字段。GraphQL 查询（Queries）最棒之处就是它支持多个字段嵌套查询，我们可以在上面的基础上加深一个层级：

```
query{
  stuff {
    eggs
    shirt
    pizza
  }
}
```

正如你所见，客户端在查询的时候不需要关心数据是来自于哪一个“商店”的。你只需要请求你要的数据，GraphQL 服务端将会完成其它所有的工作。

还有一点值得注意，query 字段也可以指向一个数组。例如，以下是一个查询一个文章列表的常用模式：

```
query {
  posts { # this is an array
    title
    body
    author { # we can go deeper!
      name
      avatarUrl
      profileUrl
    }
  }
}
```

Query 字段也支持使用**参数**。如果我想展示一篇特别的文章，我可以将 `id` 参数放在 `post` 字段中：

```
query {
  post(id: "123foo"){
    title
    body
    author{
      name
      avatarUrl
      profileUrl
    }
  }
}
```

最后，如果我想让 `id` 参数能动态改变，我可以定义一个**变量**，然后在 query 字段中重用它。（请注意，我们在 query 字段处也要定义一次这个变量的名字）

```
query getMyPost($id: String) {
  post(id: $id){
    title
    body
    author{
      name
      avatarUrl
      profileUrl
    }
  }
}
```

有个很好的方式来实践这些方法：使用  [GitHub’s GraphQL API Explorer](https://developer.github.com/early-access/graphql/explorer/) 。例如，你可以尝试下面的查询：

```
query {
  repository(owner: "graphql", name: "graphql-js"){
    name
    description
  }
}
```

![](https://cdn-images-1.medium.com/max/1000/1*adGjZ9lofuO_ohkmlqtZvg.gif)

GraphQL 的自动补全功能

当你尝试在下面输入一个名为 `description` 的新字段名时，你可能会注意到 IDE 会根据 GraphQL API 将可选的字段名自动补全。真棒！

[![](https://cdn-images-1.medium.com/max/800/1*XthnQqgmM5Ag4TmwM6UVWw.png)](https://dev-blog.apollodata.com/the-anatomy-of-a-graphql-query-6dffa9e9e747)

[The Anatomy of a GraphQL Query](https://dev-blog.apollodata.com/the-anatomy-of-a-graphql-query-6dffa9e9e747)

你可以读读这篇超棒的文章[《Anatomy of a GraphQL Query》](https://dev-blog.apollodata.com/the-anatomy-of-a-graphql-query-6dffa9e9e747)，了解更多 GraphQL 查询的知识。

### 解释器（Resolvers） ###

除非你给他们地址，否则即使是这个世界上最好的私人助理也不能去拿到干洗衣物。

同样的，GraphQL 服务端并不知道要对一个即将到来的查询做什么处理，除非你使用 **resolver** 来告诉他。

一个 resolver 会告诉 GraphQL 在哪里以及如何去取到对应字段的数据。例如，下面是之前我们取出 `post` 字段例子的 resolver（使用了 Apollo 的 [GraphQL-Tools](https://github.com/apollographql/graphql-tools) ）：

```
Query: {
  post(root, args) {
    return Posts.find({ id: args.id });
  }
}
```

在这个例子中，我们将 resolver 放在 `Query` 中，因为我们想要直接在根层级查询 `post`。但你也可以将 resolver 放在子字段中，例如查询 `post`（文章）的 `author`（作者）字段可以按照下面的形式：

```
Query: {
  post(root, args) {
    return Posts.find({ id: args.id });
  }
},
Post: {
  author(post) {
    return Users.find({ id: post.authorId})
  }
}
```

还有，resolver 不仅仅只能返回数据库里的内容，例如，如果你想为你的 `Post` 类型加上一个 `commentsCount`（评论数量）属性，可以这么做：

```
Post: {
  author(post) {
    return Users.find({ id: post.authorId})
  },
  commentsCount(post) {
    return Comments.find({ postId: post.id}).count() 
  }
}
```

理解这里的关键在于：对于 GraphQL，**你的 API 结构与你的数据库结构是解耦的**。换一种说法，我们的数据库中可能根本就没有 `author` 和 `commentsCount` 这两个字段，但是我们可以通过 resolver 的力量将它们“模拟”出来。

正如你所见，我们可以在 resolver 中写任何你想写的代码。因此，你可以通过**改变** resolver 任意地**修改**数据库中的内容，这种形式也被称为 **mutation** resolver。

### 类型（Schema） ###

GraphQL 的类型结构系统可以让很多事情都变得可行。我今天的目标仅仅是给你做一个快速的概述而不是详细的介绍，所以我不会在这个内容上继续深入。

话虽如此，如果你想了解更多这方面的信息，我建议你阅读 [GraphQL 官方文档](http://graphql.org/learn/schema/)。

![](https://cdn-images-1.medium.com/max/800/1*uLSaEA8VyrGrU2Nki7LiKg.png)

### 常见问题 ###

让我们先暂停，回答一些常见的问题。

你肯定想问一些问题，来吧，尽管问别害羞！

#### GraphQL 与图形数据库有什么关系？ ####

它们真的没有关系，GraphQL 与诸如 [Neo4j](https://en.wikipedia.org/wiki/Neo4j) 之类的图形数据库没有任何关系。名称中的 “Graph” 是来自于 GraphQL 使用字段与子字段来遍历你的 API 图谱；“QL” 的意思是“查询语言”（query language）。

#### 我用 REST 用的很开心，为什么我要切换成 GraphQL 呢？ ####

如果你使用 REST 还没有碰上 GraphQL 所解决的那些痛点，那当然是件好事啦！

但是使用 GraphQL 来代替 REST 基本不会对你 app 的用户体验产生任何影响，所以“切换”这件事并不是所谓“生或死”的抉择。话虽如此，我还是建议你如果有机会的话，先在项目里小范围地尝试一下 GraphQL 吧。

#### 如果我不用 React、Relay 等框架，我能使用 GraphQL 吗？ ####

当然能！因为 GraphQL 仅仅是一个标准，你可以在任何平台、任何框架中使用它，甚至在客户端中也同样能应用它（例如，[Apollo](http://dev.apollodata.com/) 有针对 web、iOS、Angular 等环境的 GraphQL 客户端）。你也可以自己去做一个 GraphQL 服务端。

#### GraphQL 是 Facebook 做的，但是我不信任 Facebook ####

再强调一次，GraphQL 只是一个标准，这意味着你可以在不用 Facebook 一行代码的情况下实现 GraphQL。

并且，有 Facebook 的支持对于 GraphQL 生态系统来说是一件好事。关于这块，我相信 GraphQL 的社区足够繁荣，即使 Facebook 停止使用 GraphQL，GraphQL 依然能够茁壮成长。

#### “让客户端自己请求需要的数据”这整件事情听起来似乎不怎么安全…… ####

你得自己写自己的 resolver，因此在这个层面上是否会出现安全问题完全取决于你。

例如，为了防止客户端一遍又一遍地请求查询记录造成 DDOS 攻击，你可以让客户端指定了一个 `limit` 参数去控制它接受数据的数量。

#### 那么我如何上手 GraphQL？ ####

通常来说，一个 GraphQL 驱动的 app 起码需要以下两个组件：

- 一个 **GraphQL 服务端** 来为你的 API 提供服务。
- 一个 **GraphQL 客户端** 来连接你的节点。

了解更多可用的工具，请继续阅读。

![](https://cdn-images-1.medium.com/max/800/1*zugVY5cAa9KIP6Necc7uCw.png)

现在你应该对 GraphQL 有了一个恰当的认识，下面让我们来介绍一下 GraphQL 的主要平台与产品。

### GraphQL 服务端 ###

万丈高楼平地起，盖起这栋楼的第一块砖就是一个 GraphQL 服务端。 [GraphQL](http://graphql.org/) 它本身仅仅是一个标准，因此它敞开大门接受各种各样的实现。

#### [GraphQL-JS](https://github.com/graphql/graphql-js)  (Node) ####

它是 GraphQL 的最初的实现。你可以将它和 [express-graphql](https://github.com/graphql/express-graphql) 一起使用，[创建你自己的 API 服务](http://graphql.org/graphql-js/running-an-express-graphql-server/) 。

#### [GraphQL-Server](http://graphql.org/graphql-js/running-an-express-graphql-server/) (Node) ####

[Apollo](http://apollostack.com) 团队也有他们自己的一站式 GraphQL 服务端实现。它虽然还没有像 GraphQL-JS 一样被广泛使用，但是它的文档、支持都做得很棒，使用它能快速取得进展。

#### [其它平台](http://graphql.org/code/) ####

GraphQL.org 列了一个清单： [GraphQL 在其它平台下的实现清单](http://graphql.org/code/)  （包括 PHP、Ruby 等）。

### GraphQL 客户端 ###

虽然你不使用客户端类库也可以很好地查询 GraphQL API，但是一个相对应的客户端类库将会[让你的开发更加轻松](https://dev-blog.apollodata.com/why-you-might-want-a-graphql-client-e864050f789c)。

#### [Relay](https://facebook.github.io/relay/) ####

Relay 是 Facebook 的 GraphQL 工具。我还没用过它，但是我听说它主要是为了 Facebook 自己的需求量身定做的，可能对大多数的用户来说不是那么人性化。

#### [Apollo Client](http://www.apollodata.com/) ####

在这个领域的最新参赛者是 [Apollo](http://apollostack.com)，它正在迅速发展。典型的 Apollo 客户端技术栈由以下两部分组成：

- [Apollo-client](http://dev.apollodata.com/core/)，它能让你在浏览器中运行 GraphQL 查询，并存储数据。（它还有自己的[开发者插件](https://github.com/apollographql/apollo-client-devtools)）。
- 与你用的前端框架的连接件（例如 [React-Apollo](http://dev.apollodata.com/react/)、[Angular-Apollo](http://dev.apollodata.com/angular2/) 等）。

另外，在默认的情况下 Apollo 客户端使用  [Redux](http://redux.js.org) 存储数据。这点很棒，Redux 本身是一个有着丰富生态系统的超棒的状态管理类库。

[![](https://cdn-images-1.medium.com/max/800/1*SLvbmGeU1p3mUfG8qA4cQQ.png)](https://github.com/apollographql/apollo-client-devtools) 

Apollo 在 Chrome 开发者工具中的插件

### 开源 App ###

虽然 GraphQL 还属于新鲜事物，但是它已经被一些开源 app 使用了。

#### [VulcanJS](http://vulcanjs.org) ####

[![](https://cdn-images-1.medium.com/max/800/1*YoSlSmK3P1CIlpXKyVujCQ.png)](http://vulcanjs.org) 

首先我得声明一下，我是 [VulcanJS](http://vulcanjs.org) 的主要维护者。我创建 VulcanJS 是为了让人们在不用写太多样板代码的情况下充分享受 React、GraphQL 技术栈的好处。你可以把它看成是“现代 web 生态系统的 Rails”，让你可以在短短几个小时内做出你的 CRUD（增删查改）型 app。（例如 [Instagram clone](https://www.youtube.com/watch?v=qibyA_ReqEQ)）

#### [Gatsby](https://www.gatsbyjs.org/docs/) ####

Gatsby 是一个 React 静态网站生成器，它现在是基于 [GraphQL 1.0 版本](https://www.gatsbyjs.org/docs/) 开发。它一眼看上去像个奇怪的大杂脍，但其实它的功能十分强大。Gatsby 在构建过程中，可以从多个 GraphQL API 取得数据，然后用它们创建出一个全静态的无后端 React app。

### 其它的 GraphQL 工具 ###

#### [GraphiQL](https://github.com/graphql/graphiql) ####

GraphiQL 是一个非常好用的基于浏览器的 IDE，它可以方便你进行 GraphQL 端点查询。

[![](https://cdn-images-1.medium.com/max/800/1*fbeXj5wB383gWsMXn_6JAw.png)](https://github.com/graphql/graphiql)

GraphiQL

#### [DataLoader](https://github.com/facebook/dataloader) ####

由于 GraphQL 的查询通常是嵌套的，一个查询可能会调用很多个数据库请求。为了避免影响性能，你可以使用一些批量出入库框架和缓存库，例如 Facebook 开发的 DataLoader。

#### [Create GraphQL Server](https://blog.hichroma.com/create-graphql-server-instantly-scaffold-a-graphql-server-1ebad1e71840) ####

Create GraphQL Server 是一个简单的命令行工具，它能快速地帮你搭建好基于 Node 服务端与 Mongo 数据库的 GraphQL 服务端。

### GraphQL 服务 ###

最后，这儿列了一些 GraphQL BAAS（后台即服务）公司，它们已经为你准备好了服务端的所有东西。这可能是一个让你尝试一下 GraphQL 生态系统的很好的方式。

#### [GraphCool](http://graph.cool) ####

一个由 GraphQL 和 AWS Lambda 组成的一个弹性后端平台服务，它提供了开发者免费计划。

#### [Scaphold](https://scaphold.io/) ####

另一个 GraphQL BAAS 平台，它也提供了免费计划。与 GraphCool 相比，它提供了更多的功能。（例如定制用户角色、常规操作的回调钩子等）

![](https://cdn-images-1.medium.com/max/800/1*deLIZh7AfYbAt0u2t7dAKQ.png)

下面是一些能让你学习 GraphQL 的资源。

#### [GraphQL.org](http://graphql.org/learn/)  ####

GraphQL 的官方网站，有许多很好的文档供你学习。

#### [LearnGraphQL](https://learngraphql.com/) ####

LearnGraphQL 是由 [Kadira](https://kadira.io/) 员工共同制作的课程。

#### [LearnApollo](https://www.learnapollo.com/) ####

LearnApollo 是由 GraphCool 制作的免费课程，是对于 LearnGraphQL 课程的一个很好的补充。

#### [Apollo 博客](https://dev-blog.apollodata.com/) ####

Apollo 的博客有成吨的干货，有很多关于 Apollo 和 GraphQL 的超棒的文章。

#### [GraphQL 周报](https://graphqlweekly.com/) ####

由 Graphcool 团队策划的一个简报，其内容包括任何有关 GraphQL 的信息。

#### [Hashbang 周报](http://hashbangweekly.okgrow.com/) ####

另一个不错的简报，除了 GraphQL 的内容外，还涵盖了 React、Meteor。

#### [Awesome GraphQL](https://github.com/chentsulin/awesome-graphql) ####

一个关于 GraphQL 的链接和资源的很全面的清单。

![](https://cdn-images-1.medium.com/max/800/1*S69N5yYp1VLSSO0GTnrpmw.png)

你如何实践你刚学到的 GraphQL 的知识呢？你可以尝试下面这些方式：

#### [Apollo + Graphcool + Next.js](https://github.com/zeit/next.js/tree/master/examples/with-apollo)  ####

如果你对 Next.js 与 React 很熟悉，[这个例子](https://github.com/zeit/next.js/tree/master/examples/with-apollo)将会帮助你使用 Graphcool 很快的搭建好你的 GraphQL 端点，并在客户端使用 Apollo 进行查询。

#### [VulcanJS](http://docs.vulcanjs.org/) ####

[Vulcan 教程](http://docs.vulcanjs.org/)将会引导你创建一个简单的 GraphQL 数据层，既有服务端部分也有客户端部分。因为 Vulcan 是一个一站式平台，所以这种无需任何配置的方式是一种很好的上手途径。如果你需要帮助，请访问[我们的 Slack 栏目](http://slack.vulcanjs.org/)！

#### [GraphQL & React 教程](https://blog.hichroma.com/graphql-react-tutorial-part-1-6-d0691af25858#.o54ygcruh)  ####

Chroma 博客有一篇[《分为六部的教程》](https://blog.hichroma.com/graphql-react-tutorial-part-1-6-d0691af25858#.o54ygcruh)，讲述了如何按照组件驱动的开发方式来构建一个 React/GraphQL app。

![](https://cdn-images-1.medium.com/max/800/1*uLSaEA8VyrGrU2Nki7LiKg.png)

### 总结 ###

当你刚开始接触 GraphQL 可能会觉得它非常复杂，因为它横跨了现代软件开发的众多领域。但是，如果你稍微花点时间去明白它的原理，我认为你可以找到它很多的可取之处。

所以不管你最后会不会用上它，我相信多了解了解 GraphQL 是值得的。越来越多的公司与框架开始接受它，过几年它可能会成为 web 开发的又一个重要组成部分。

赞同？不赞同？有疑问？请留下评论让我们知道你的看法。如果你还比较喜欢这篇文章，请点亮💚或者分享给他人。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
