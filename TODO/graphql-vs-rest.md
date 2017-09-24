
> * 原文地址：[GraphQL vs. REST](https://dev-blog.apollodata.com/graphql-vs-rest-5d425123e34b)
> * 原文作者：[Sashko Stubailo](https://dev-blog.apollodata.com/@stubailo)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/graphql-vs-rest.md](https://github.com/xitu/gold-miner/blob/master/TODO/graphql-vs-rest.md)
> * 译者：[wilsonandusa](https://github.com/wilsonandusa)
> * 校对者：[DeadLion](https://github.com/DeadLion), [steinliber](https://github.com/steinliber)

# GraphQL vs. REST

## 两种通过 HTTP 发送数据的方式：区别在哪里？

GraphQL 常常被认为是一种全新的 API 方式。你可以通过发送一次查询请求便获得所需要的数据，而不是通过服务器严格定义的请求终端。GraphQL 确实有这样的变革能力，一个团队在采用 GraphQL 后能够使得前端和后端的合作变得比之前更流畅。然而在实际操作中，两种技术都通过发送 HTTP 请求获取结果，而且 GraphQL 使用了 REST 模型中的很多内建元素

那么从技术层面来讲它们的本质到底是什么？这两款 API 范例的相似处和区别都有哪些？我在文章最后将会声明 GraphQL 和 REST 的区别并不是很大，但 GraphQL 其本身的一些小的改变使得为开发和自定义一个 API 带来了巨大的区别。

那么言归正传，我们会先指出 API 的一些性质，然后我们会讨论 GraphQL 和 REST 是如何处理它们的。

### 资源

REST 的核心理念就是资源。每个资源都由一个 URL 定义，然后通过向指定 URL发送 `GET` 请求来获取资源。目前大部分 API 会得到的一个 JSON 响应。这个请求和响应如下：

    GET /books/1

    {
      "title": "Black Hole Blues",
      "author": {
        "firstName": "Janna",
        "lastName": "Levin"
      }
      // ... more fields here
    }

**注意：在以上实例中，有的 REST APIs 会把 “author” 当成独立资源返回。**

在 REST 中需要注意的是，资源的类型和你获取资源的方法是紧密相关的。当使用以上 REST 数据时，你可能会把它当成是 book 的一个终端。

GraphQL 在这方面就相当不一样了，因为在 GraphQL 里这两个概念是完全分开的。在你的模版里可能会有 ‘Book’ 和 “author” 两种类型：

    type Book {
      id: ID
      title: String
      published: Date
      price: String
      author: Author
    }

    type Author {
      id: ID
      firstName: String
      lastName: String
      books: [Book]
    }

注意在这里我们对可获得的数据类型进行了描述，但这个描述并没有告诉你每个对象是如何从客户端获得的。这就是 REST 和 GraphQL 的核心区别之一 —— 对某一指定资源的描述不一定要和获取的方式相结合。

如果想要真正得到到某一本书或者其作者的信息，我们需要在我们现有的模式中创造一个 ‘Query’ 类型：

    type Query {
      book(id: ID!): Book
      author(id: ID!): Author
    }

现在我们可以发送一个类似于 REST 的请求，不过这次是使用 GraphQL：

    GET /graphql?query={ book(id: "1") { title, author { firstName } } }

    {
      "title": "Black Hole Blues",
      "author": {
        "firstName": "Janna",
      }
    }

很好，现在我们有成果了！即使双方都使用 URL 来发送请求并返回相同的 JSON 结构作为回应，我们还是能马上看出 GraphQL 和 REST 之间的区别。

首先，我们能看出 GraphQL 查询的 URL 详细指出了我们所寻找的资源以及我们所关心的字段。而且 API 的使用者决定是否需要包括有关 ‘author’ 的资源，而不是由服务器端的代码来决定。

但最重要的是，资源的身份以及 Book 和 Author 的概念和获取的方式无关。我们实际上可以使用多种不同的请求来获取同一本书的不同字段。

#### 总结

我们已经找到了一些相似和不同的地方：

- **相同：** 都拥有资源这个概念，而且都可以指定资源的身份
- **相同：** 都能通过 HTTP GET 和一个 URL 来获取信息
- **相同：** 请求的返回值都是 JSON 数据
- **不同：** 在 REST 中，你所访问的终端就是所需对象的身份，在 GraphQL 中，对象的身份和获取的方式是独立存在的
- **不同：** 在 REST 中，资源的形式和大小是由服务器所决定的。在 GraphQL 中，服务器声明哪些资源可以获得，而客户端会对其所需资源作出请求。

好吧，如果你之前使用过 GraphQL 和／或 REST的话这些看上去很基础。如果你之前没用过 GraphQL，你可以使用 Launchpad 来试试[这个实例](https://launchpad.graphql.com/1jzxrj179) 。这是一个用于在浏览器中创造和探索 GraphQL 实例的工具。

### URL 路径 vs GraphQL 模版

一款无法正确预测结果的 API 是没有实际用途的。当你使用一款 API 的时候，大部分情况下会把它当做程序的某一部分去使用它，这款程序会知道可以调用什么 API，以及 API 的结果是什么。这样程序才能运用好 API 返回的结果。

所以一款 API 最重要的一个特点就是去描述它到底能得到什么。你在读 API 文档的时候恰恰就是为了了解这些。现在通过使用 GraphQL 的内部描述特点或者使用类似 Swagger 这种适用于 REST 模板系统的工具，我们可以采用编程的方式来获取这方面的信息。

目前的 REST API 通常被形容为一连串的端点：

    GET /books/:id
    GET /authors/:id
    GET /books/:id/comments
    POST /books/:id/comments

所以你可以将此 API 的“形态”描述为线性 —— 因为你可以接触一连串的信息。当你想要获取或者存储信息的时候，最先想到的问题就是“我应该使用哪一个终端”？

而在 GraphQL 中，就像我们之前提到的，你并不是使用一系列 URL 来验证 API 可以获得有哪些信息，而是使用 GraphQL 的模板：

    type Query {
      book(id: ID!): Book
      author(id: ID!): Author
    }

    type Mutation {
      addComment(input: AddCommentInput): Comment
    }

    type Book { ... }
    type Author { ... }
    type Comment { ... }
    input AddCommentInput { ... }

将它和 REST 中请求相同数据集的请求路径做对比时，有几点有趣的地方。首先，在区分读取和写入时，GraphQL 使用的是 Mutation 和 Query 这两种不同的初始类型，而不是通过对同一 URL 发送两种不同的 HTTP 术语。在 GraphQL 文档中，你可以使用关键字来选择你所发送的操作：

    query { ... }
    mutation { ... }

如果想要了解更多有关查询语言的细节，请阅读我之前写的文章， [**“对 GraphQL 查询的分析”。**](https://dev-blog.apollodata.com/the-anatomy-of-a-graphql-query-6dffa9e9e747)

你可以看出 Query 类型中的字段和我们之前所写的 REST 路径正好重合。这是因为此类型是我们数据的切入点，所以这在 GraphQL 中是和终端 URL 几乎相同的一个概念。

你从 GraphQL API 中获取最初资源的方式和使用 REST 的方法类似 —— 都是通过传递一个名字和一些参数 —— 但最大的不同之处是在这之后你会做什么。你可以用 GraphQL 发送一个复杂的请求并通过与模板之间的关系来获取额外的数据。但在 REST 中，你需要通过发送多个请求来使用相关数据去构造最初的回应，或者在 URL 中包含特殊参数来修改响应的结果。

#### 结论

在 REST 中，可获得数据的空间是由一系列线性的终端来描述的，而在 GraphQL 中是通过使用有关联的模板：

- **相同：** REST API 中的一列终端和 GraphQL API 中的 Query 和 Mutation 类的字段很像，都是数据的切入点。
- **相同：** 两种 API 都可以区分数据的读取和写入。
- **不同：** 在 GraphQL 中，你可以使用由模板定义的关系，通过发送一次请求从初始点一直走到相关数据。然而在 REST 中，你必须要使用多个终端来获取相关资源。
- **不同：** 在 GraphQL 中，除了在每个请求的根源处所能获取的类型都是 Query 类外，Query 的字段和其他类的字段没有本质区别。比方说，你可以在 Query 的每个字段里放一个参数。而在 REST 中，嵌套的URL里没有第一类这个概念。
- **不同：** 在 REST 中，你通过将 HTTP 术语 GET 改为 POST 来指定写入，但在 GraphQL 里需要改变请求里的关键字

由于第一个相似点，很多人把 GraphQL 的 Query 类中的字段当作“终端”或者“请求”。虽然这的确是一个合理的比较，但这种理解可能会误导别人认为 Query 类和其他类的工作方式不同，这种理解是错误的。

### 路径处理器 vs Resolvers

当你调用一款 API 的时候到底发生了什么？通常情况下 API 会在服务器端收到请求后执行一段代码。这类代码可能会进行计算，也可能是从数据库中加载数据，甚至会使用另一款 API 或做其他事。重要的是你不需要了解它在内部到底做了了什么。不过 REST 和 GraphQL 这两款 API 都具备非常标准化的内部执行方式，通过比较它们内部的执行区别，我们可以找出这两款 API 基础层面的不同点。

在接下来的对比中我会使用 JavaScript，因为这是我最熟悉的语言。不过你当然可以用其他语言去实现 REST 或者 GraphQL。我会省略设置服务器的步骤，因为这不是重点。

来看看这个用 experss 写的 hello world 例子，express 是 Node 里很火的 API库 之一。

    app.get('/hello', function (req, res) {
      res.send('Hello World!')
    })

我们首先创建了一个能够返回hello world字串符的／hello 终端。通过这个例子中我们可以得知使用 REST API 来写服务器时一个 HTTP 请求的生命周期：

1. 服务器接收请求并解析 HTTP 术语 （这个例子中术语为 ‘GET’）和其 URL
2. API  库将术语和路径相结合并在服务器代码中找到与之相匹配的函数
3. 函数运行并返回结果
4. API 库将结果序列化与响应代码和数据头相结合，最终发送给客户端

GraphQL 的工作方式极为相似，对于同一个 [hello world](https://launchpad.graphql.com/new) 的例子来说两者几乎相同：

    const resolvers = {
      Query: {
        hello: () => {
          return 'Hello world!';
        },
      },
    };

就像你所看到的，我们将函数和一个类别中的字段相呼应，为指定的 URL 提供一个处理函数。在这个例子中，‘hello’ 是 ‘Query’ 中的一个字段。在 GraphQL 中，这种对字段进行操作的函数被称为 **resolver**。

我们需要用 Query 来发送请求：

    query {
      hello
    }

当服务器接收到 GraphQL 的请求会执行以下步骤：

1. 服务器接收请求并开始解析 GraphQL 的请求
2. 此 Query 的每个字段会被仔细分析来找出有哪些 resolver 函数会被使用
3. 函数运行并返回结果
4. GraphQL 库和服务器将返回结果和回应相结合，最终得到和 Query 形态相匹配的结果

所以你最终得到的结果为：

    { "hello": "Hello, world!" }

但这里有个小技巧，我们实际上可以连续访问字段两次！

    query {
      hello
      secondHello: hello
    }

在这个例子中出现了相同的生命周期，但由于我们使用化名对同一个字段发送了两次请求，hello 的 resolver 实际上被使用了**两次**。这个例子很牵强，但重点是我们可以对同一请求中对多个字段进行操作，而且在一个 query 中我们也可以对单个字段进行多次使用。

为了进行补充，以下是一个嵌套在一起的 resolvers 例子：

    {
      Query: {
        author: (root, { id }) => find(authors, { id: id }),
      },
      Author: {
        posts: (author) => filter(posts, { authorId: author.id }),
      },
    }

这些 resolvers 可以用来对 query 进行补充：

    query {
      author(id: 1) {
        firstName
        posts {
          title
        }
      }
    }

所以即使这些 resolvers 是平级的，由于它们可以和多种类型相结合，你可以在嵌套的 query 里将这些 resolvers 连在一起使用。如果想了解 GraphQL 是如何执行工作的，请阅读以下文章[“详解 Graph QL”](https://dev-blog.apollodata.com/graphql-explained-5844742f195e)。

[**来看看如何使用完整的例子配合不同的请求来进行测试！**](https://launchpad.graphql.com/1jzxrj179)

![](https://cdn-images-1.medium.com/max/1600/1*qpyJSVVPkd5c6ItMmivnYg.png)

图解：对资源进行获取的 REST 多次请求 vs GraphQL 的一次请求
#### 结论

最终我们可以得知，REST 和 GraphQL API 都可以在网络中通过不同方式使用函数。如果你对如何搭建 REST API 很熟悉，那么使用 GraphQL API 应该不会很不一样。不过 GraphQL 有很大的优势，因为你可以使用它去执行多个相关函数，而且全程不需要多次请求往返。

- **相同：** REST的终端和 GraphQL 的字段都会在服务器端运行函数
- **相同：** 两者本质上都需要依靠框架和库来使用和处理网络模板。
- **不同：** 在 REST 中，每次请求通常只使用一个路径处理函数。在 GraphQL 中，同一 Query 可以使用多个 resolver 来使用多个资源创造嵌套在一起的回应。
- **不同：** 在 REST 中，你可以自己创造每个回应的形式。在 GraphQL 中，回应的模式通过 GraphQL 的执行库来与请求的形式相匹配。

总而言之，你可以将 GraphQL 当成是可以在一次请求里执行多个终端的系统，就像是重复使用的 REST。

---

### 这些意味着什么？

我们无法在此文章中对所有细节做出诠释，比如对象识别、超媒体以及缓存。我以后可能会再讨论这些问题，但我想让你明白的是，通过了解 API 的基本知识点可得知，REST 和 GraphQL 工作时所使用的基础观念是十分相似的。

我觉得两者之间的区别反而成为了 GraphQL 的优势。特别是给予使用者构建多个 resolver 函数的功能非常炫酷，而且也可以发送一个复杂的请求来一次性得到多种资源，整个过程是可预测的。这个特点避免了 API 的使用者为了构建某个回应形式而去使用多个终端，同时也避免了处理额外不需要的数据。

然而，GraphQL 目前还没有 REST 那么多的工具和扩展。比方说，你无法对 GraphQL 的结果使用 HTTP 的缓存方式。但目前社区方面正在努力打造更好的工具和框架，而且你可以使用类似 [Apollo client](http://dev.apollodata.com/) 和  [Relay](https://facebook.github.io/relay/) 这类缓存工具。

如果有更多有关对比 REST 和 GraphQL 的想法，请积极留言！


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
