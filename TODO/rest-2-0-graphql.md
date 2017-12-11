> * 原文地址：[REST 2.0 Is Here and Its Name Is GraphQL](https://www.sitepoint.com/rest-2-0-graphql/)
> * 原文作者：[Michael Paris](https://www.sitepoint.com/author/mparis/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者： [mnikn](https://github.com/mnikn)
> * 校对者： [CACppuccino](https://github.com/CACppuccino)，[sunui
](https://github.com/sunui)

# REST 2.0 在此，它的名字叫 GraphQL

![Abstract network design representing GraphQL querying data](https://dab1nmslvvntp.cloudfront.net/wp-content/uploads/2017/05/1495045443Fotolia_71313802_Subscription_Monthly_M-1024x724.jpg) 

GraphQL 是一种 API 查询语言。虽然它和 REST 完全不同，但是 GraphQL 可作为 REST 的代替品，提供一样的体验。对于一个有经验的开发者来说，它可作为一个非常强有力的工具。

在这篇文章中，我们将看看如何用 REST 和 GraphQL 处理一些常见的任务。本文中举了三个例子，你会看到用于提供热门电影和演员信息的 REST 和 GraphQL API 的代码，还有一个简单的用 HTML 和 jQuery 写出的前端应用。

我们将会使用这些 API，看看它们在技术上有什么不同点，这样我们就可以知道它们有什么优势和不足。首先，让我们看一下它们所采用了什么技术。

![](https://dab1nmslvvntp.cloudfront.net/wp-content/uploads/2017/04/14918074751489563681243c760b-dcef-4ab0-b6ac-9a1e1e654483.png)

## 早期的 Web

早期网络的技术架构很简单。早期互联网上的网页使用静态的 HTML 文档，随后网站把动态的内容存储在数据库（例如：SQL）并使用 JavaScript 来进行交互。大多数网络的内容是通过桌面电脑上的浏览器来浏览的，并且看起来一切都运作良好。

![Normal Image](https://dab1nmslvvntp.cloudfront.net/wp-content/uploads/2017/05/1494257477001-TraditionalWebserver.png)

## REST: API的兴起

快速前往 2007 年，当时乔布斯在展示 iPhone。智能手机除了对世界各地的文化、交流造成深远的影响，它还让开发者的工作变得更加复杂了。智能手机改变了当时开发的模式，在短短几年，我们突然间有了台式机、iPhone、Android 和平板电脑。

因此，开发者们开始使用 [RESTful API](https://en.wikipedia.org/wiki/Representational_state_transfer) 来给各种类型和规模的应用提供数据。新的开发架构看起来像是这样的：

![REST Server](https://dab1nmslvvntp.cloudfront.net/wp-content/uploads/2017/05/1494257479002-RestfulServer.png)

## GraphQL: API 的进化

GraphQL 是一种由 Facebook 设计并开源的 **API 查询语言**。在构建 API 时，你可以认为 GraphQL 是 REST 的替代品。然而 REST 是一个概念上的模型，用来设计并实现你的 API，而 GraphQL 是一种标准的语言，系统地在客户端和服务端中创建了一个强力的条约。有了这样一门能与我们所有的设备通讯的语言，可以有效地简化建设大规模、跨平台应用程序的过程。

通过 GraphQL 我们的图解可简化为：

![GraphQL Server](https://dab1nmslvvntp.cloudfront.net/wp-content/uploads/2017/05/1494257483003-GraphQLServer.png)

## GraphQL vs REST

在接下来的教程里，我建议你跟着代码看一下！你可以在 [附随的 GitHub 仓库](https://github.com/sitepoint-editors/sitepoint-graphql-article) 中找到本文的代码。

三个项目：

1. RESTful API 
2. GraphQL API
3. 由 jQuery 和 HTML 构建的简易的网页。

这些项目都挺简单，我们尽可能通过这些项目来比较它们之间在技术上的不同。

如果你愿意的话可以打开三个终端窗口并 `cd` 到 `RESTful`、`GraphQL` 和 `Client` 项目文件夹。在每个项目的文件夹里执行命令 `npm run dev` 来运行开发服务器。一旦你的服务器已准备好，就可以执行下一步了 :)

## 使用 REST 来查询

我们的 RESTful API包含了一些路径：

![Markdown](http://i4.buimg.com/1949/6c5d1503224ef6b2.png)

> **注意**: 我们简单的数据模型已经有了 6 个路径需要维护和记录。

让我们想象一下我们是客户端开发者，需要使用电影的 API 来通过 HTML 和 jQuery 构建一个简单的页面。为了构建我们的页面，我们需要有关电影和其出演人员的信息。我们的 API 有这些功能，所以现在只需获取其数据。

如果你打开一个终端并且运行命令

```
curl localhost:3000/movies

```

你得到的响应会是这样子的：

```
[
  {
    "href": "http://localhost:3000/movie/1"
  },
  {
    "href": "http://localhost:3000/movie/2"
  },
  {
    "href": "http://localhost:3000/movie/3"
  },
  {
    "href": "http://localhost:3000/movie/4"
  },
  {
    "href": "http://localhost:3000/movie/5"
  }
]
```

在 RESTful 的风格中，API 会返回一对指向真正电影对象的链接数组。我们可以通过运行命令 `curl http://localhost:3000/movie/1` 来获取第一个电影的信息，通过命令 `curl http://localhost:3000/movie/2` 来获取第二个，以此类推。

如果你看下 `app.js` 你会发现我们的用来获取页面数据的函数：

```
const API_URL = 'http://localhost:3000/movies';
function fetchDataV1() {

  // 1 call to get the movie links
  $.get(API_URL, movieLinks => {
    movieLinks.forEach(movieLink => {

      // For each movie link, grab the movie object
      $.get(movieLink.href, movie => {
        $('#movies').append(buildMovieElement(movie))

        // One call (for each movie) to get the links to actors in this movie
        $.get(movie.actors, actorLinks => {
          actorLinks.forEach(actorLink => {

            // For each actor for each movie, grab the actor object
            $.get(actorLink.href, actor => {
              const selector = '#' + getMovieId(movie) + ' .actors';
              const actorElement = buildActorElement(actor);
              $(selector).append(actorElement);
            })
          })
        })
      })
    })
  })
}
```

你可能注意到，这种情况不太理想。整体上我们调用了 `1 + M + M + sum(Am)` 次 API，其中 **M** 是电影的数量，**sum(Am)** 是处理 M 个电影的行为的数量和。对于数据量小的应用来说还可以，但是这无法适用于大型的生产系统。

小结一下，我们简易的 RESTful 方法还不能够满足要求。为了改进我们的 API，我们可能需要叫后端团队构建一个额外的 `/moviesAndActors` 路径提供给页面。一旦这个路径完成，我们就可以通过仅用一次请求来代替 `1 + M + M + sum(Am)` 次调用。

```
curl http://localhost:3000/moviesAndActors
```

它返回的数据看起来像这样：

```
[
  {
    "id": 1,
    "title": "The Shawshank Redemption",
    "release_year": 1993,
    "tags": [
      "Crime",
      "Drama"
    ],
    "rating": 9.3,
    "actors": [
      {
        "id": 1,
        "name": "Tim Robbins",
        "dob": "10/16/1958",
        "num_credits": 73,
        "image": "https://images-na.ssl-images-amazon.com/images/M/MV5BMTI1OTYxNzAxOF5BMl5BanBnXkFtZTYwNTE5ODI4._V1_.jpg",
        "href": "http://localhost:3000/actor/1",
        "movies": "http://localhost:3000/actor/1/movies"
      },
      {
        "id": 2,
        "name": "Morgan Freeman",
        "dob": "06/01/1937",
        "num_credits": 120,
        "image": "https://images-na.ssl-images-amazon.com/images/M/MV5BMTc0MDMyMzI2OF5BMl5BanBnXkFtZTcwMzM2OTk1MQ@@._V1_UX214_CR0,0,214,317_AL_.jpg",
        "href": "http://localhost:3000/actor/2",
        "movies": "http://localhost:3000/actor/2/movies"
      }
    ],
    "image": "https://images-na.ssl-images-amazon.com/images/M/MV5BODU4MjU4NjIwNl5BMl5BanBnXkFtZTgwMDU2MjEyMDE@._V1_UX182_CR0,0,182,268_AL_.jpg",
    "href": "http://localhost:3000/movie/1"
  },
  ...
]
```

很好！通过单独一次请求，我们就能够得到我们所需的页面数据。回头看下 `Client` 目录里面的 `app.js`，我们可以看到处理数据时的进步。

```
const MOVIES_AND_ACTORS_URL = 'http://localhost:3000/moviesAndActors';
function fetchDataV2() {
  $.get(MOVIES_AND_ACTORS_URL, movies => renderRoot(movies));
}
function renderRoot(movies) {
  movies.forEach(movie => {
    $('#movies').append(buildMovieElement(movie));
    movie.actors && movie.actors.forEach(actor => {
      const selector = '#' + getMovieId(movie) + ' .actors';
      const actorElement = buildActorElement(actor);
      $(selector).append(actorElement);
    })
  });
}

```

我们的新应用会比之前的版本更快，但是这还不够完美。如果你打开 `http://localhost:4000` 并且看看我们简易的网页，你会看到像这样的东西：

![Demo App](https://dab1nmslvvntp.cloudfront.net/wp-content/uploads/2017/05/1494257488004-DemoApp.png)

如果你看得仔细点，你会发现我们的页面使用了电影的标题和图片，演员的名字和图片（也就是说，在电影对象中的 8 个字段，我们只使用了 2 个，在演员对象中有 7 个字段，我们也只使用了 2 个）。这意味着我们浪费了我们所请求的四分之三的信息！过量的带宽使用不仅会影响网页的表现，也会提高你的设备花销！

一个精明的后端开发者可能会笑笑然后快速实现一个查询字段，根据传进来的字段名称来动态返回请求所需的字段。

例如，与其使用 `curl http://localhost:3000/moviesAndActors`，我们更倾向于 `curl http://localhost:3000/moviesAndActors?fields=title,image`。我们甚至有另外一个查询参数 `actor_fields` 用来指定要包含的 actor 模型的成员。例如 `curl http://localhost:3000/moviesAndActors?fields=title,image&actor_fields=name,image`。

现在，这在我们简易的应用中算是优化的实现，但是同时它也引进了创造自定义路径给特定客户端应用的坏习惯。当你开始构建 iOS 应用，而它需要显示的信息和网页、Android 应用不同时，这种问题会发生得越来越多。

如果我们可以构建一个广泛的 API 来显性表示我们数据模型中的实体和实体间的关系，却并不需要额外付出 `1 + M + M + sum(Am)` 的性能损失，那不是很美妙吗？好消息是，我们真的可以！

## 使用 GraphQL 来查询

通过 GraphQL,我们可以直接跳过优化查询来获取我们所需的所有信息，无需多余的操作，只需要直接的查询：

```
query MoviesAndActors {
  movies {
    title
    image
    actors {
      image
      name
    }
  }
}

```

注意！自己试试，打开 GraphiQL（一个基于 GraphQL IDE 神奇的浏览器），输入地址 [http://localhost:5000](http://localhost:5000) 并运行上面的查询语句。

现在，让我们更深入地探讨一下 GraphQL。

## 深入 GraphQL

GraphQL 采取和 REST 完全不同的方法来访问 API。它不依赖于 HTTP 架构中的动作与 URI，而是基于指令式的查询语言和强力的基于数据的类型系统。类型系统在客户端和服务端之间提供了强类型的条约，并且查询语句提供一种机制来让客户端的开发者获取任意所需数据给页面。

GraphQL 鼓励你把数据想象成是一个虚拟的信息图。实体包含了叫做 type 的信息，并且这些 type 可以和其他字段关联。查询从顶部开始，遍历虚拟图的同时获取所需的信息。。

“虚拟图” 更倾向于用 **schema** 描述。**schema** 是 type、interface、enum 和 union 的集合，用来构建你的 API 数据模型。GraphQL 甚至包含了一种通用的 schema 语言来定义我们的 API。例如，这是我们电影 API 的 schema：

```
schema {
    query: Query
}

type Query {
    movies: [Movie]
    actors: [Actor]
    movie(id: Int!): Movie
    actor(id: Int!): Actor
    searchMovies(term: String): [Movie]
    searchActors(term: String): [Actor]
}

type Movie {
    id: Int
    title: String
    image: String
    release_year: Int
    tags: [String]
    rating: Float
    actors: [Actor]
}

type Actor {
    id: Int
    name: String
    image: String
    dob: String
    num_credits: Int
    movies: [Movie]
}

```

类型系统为了打开大门引进大量美妙的东西，包含了更好的工具，更好的文档，还有效率更高的应用。有许多值得称道的东西，但是现在我们先跳过，重点放在用更多的场景来显示 REST 和 GraphQL 之间的不同。

## GraphQL vs Rest: 版本化

一个 [简单的 google 搜索](https://www.google.com/search?q=REST+versioning&amp;oq=REST+versioning) 显示了许多人认为对 REST API 的最佳版本化实践（或者改革）。我们不会陷入这个问题，但是我真的想要说明这不是一个简单的问题。其中一个原因是版本化很难，因为我们很难知道什么样的应用和装置要用到什么样的信息。

添加信息对于 REST 和 GraphQL 来说都很容易。添加字段对 REST 客户端来说更麻烦，对 GraphQL 来说则会安全地无视它，直到你改变查询方式。然而，删除和修改信息又是另外一回事了。

在 REST 中，我们很难从字段层面上得知哪些信息被用到了。我们可能知道有一个路径 `/movies` 在使用，但是我们不知道客户端是否使用字段 title，image 或者都用。其中一个可能的方案就是添加一个查询参数 `fields` 来指定返回字段，但是这些参数应该为可选项。因此，你会发现我们在路径层面上作出的改进，引入了新的路径 `/v2/movies`。这有用但同时也增加了我们 API 的范围，让开发者在更新 API 和维护文档的可读性上的负担更重。

然而在 GraphQL 上的版本化则很不同。每个 GraphQL 查询都需要准确地表明请求所需的字段。事实上这是规定，代表我们准确地知道在请求什么信息，我们可以因此来反问自己请求有多频繁和由谁请求。GraphQL 同时包含了原始命令来让我们用不支持字段来修饰一个 schema，通过不支持字段和消息来解释为什么它们不被支持。

GraphQL 上的版本化看起来像这样：

![Versioning in GraphQL](https://philsturgeon.uk/images/article_images/2017-01-24-graphql-vs-rest-overview/graphql-versioning-marketing-site.gif)

## GraphQL vs REST: 缓存

在 REST 里缓存很直接也很有用。事实上，缓存是 [六个 RSET 设计约束之一](https://en.wikipedia.org/wiki/Representational_state_transfer) ，同时暴露在 RESTful 的设计当中。如果路径 `/movies/1` 的响应指出响应可以被缓存，这样之后来自 `/movies/1` 的请求都可以以使用缓存来替换。这很简单。

在 GraphQL 里缓存的方式有一点点不同。在 GraphQL API 里缓存，往往需要对于每个 API 中的对象引入一些特别的识别器。当每个对象均有自己独有的 id，客户端就可以构建规范化的缓存，通过识别器来可靠地给对象缓存、更新并使之失效。当客户端的查询指向对象，将会使用在缓存中的对象作为替换。如果你有兴趣了解更多有关 GraphQL 里面缓存的工作原理，点击 [更深入了解各个部分](http://graphql.org/learn/caching/)。

## GraphQL vs REST: 开发者的经验

开发者经验对于应用开发来说是至关重要的，并且是工程师们花费这么多时间来构建好用的工具的原因。这里的比较难免会有一些主观的东西夹入其中，但我认为还是有许多值得一提的东西。

REST 尝试搭建了一个拥有各种工具的丰富的生态圈，帮助开发者们撰写文档，测试并审查 RESTful API，并且它真的做到了。因此有很多的开发者加入，REST API 规模增长。路径的数量迅速变得庞大起来，不足之处也变得越来越明显，并且版本化越发困难。

GraphQL 真的胜在开发者经验这一部分。类型系统为美妙的工具打开大门，例如 GraphiQL IDE，和内嵌在 schema 的文档。同时在 GraphiQL 里对于每个路径来说，与其依赖文档来发现数据是否可用，通过类型安全的语言和自动完成，你可以快速构建一个 API。同时 GraphQL 是设计用来和现代的前端框架搭配的，例如 React 和 Redux。如果你想要构建 React 应用，我强烈推荐看看 [Relay](https://facebook.github.io/relay/) 或者 [Apollo client](https://github.com/apollographql/apollo-client)。

## 结论

GraphQL 提供更独具一格且异常强力的工具来快速构建一个数据驱动的应用。REST 不会立刻就消失，但是会有大量应用需要 GraphQL ，特别是想要构建客户端应用的时候。

如果你有兴趣了解更多，看看 [Scaphold.io’s GraphQL 后端即服务](https://scaphold.io)。  在 [几分钟内构建一个部署在 AWS 上，使用 GraphQL API 的产品](https://www.youtube.com/watch?v=yaacnYUqY1Q)，并且准备自定义和拓展你的业务逻辑。

但愿这篇文章令您有所收获，若您有任何建议或者意见，欢迎提出！谢谢！


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
