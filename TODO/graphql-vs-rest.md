
> * 原文地址：[GraphQL vs. REST](https://dev-blog.apollodata.com/graphql-vs-rest-5d425123e34b)
> * 原文作者：[Sashko Stubailo](https://dev-blog.apollodata.com/@stubailo)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/graphql-vs-rest.md](https://github.com/xitu/gold-miner/blob/master/TODO/graphql-vs-rest.md)
> * 译者：[wilsonandusa](https://github.com/wilsonandusa)
> * 校对者：

# GraphQL vs. REST

## 两种通过 HTTP 发送数据的方式：区别在哪里？

GraphQL 常常被认为是一种全新的 API 方式。你可以通过发送一次查询请求便获得所需要的数据，而不是通过服务器严格定义的终端。GraphQL 确实有这样的变革能力，一个团队在采用 GraphQL 后能够使得前端和后段的合作变得更加流畅。然而在实际操作中，两种技术都通过发送 HTTP 请求获取结果，而且 GraphQL 使用了 REST 模型中的很多基础元素。

那么从技术层面来讲它们的本质到底是什么？这两款 API 范例的相似处和区别都有哪些？我在文章最后会声明 GraphQL 和 REST 的区别并不是很大，但 GraphQL 其本身的一些改变使得为使用一款 API 的开发体验带来了巨大的变化。

那么言归正传，我们会先指出 API 的一些性质，然后我们会讨论 GraphQL 和 BEST 是如何处理它们的。

### 资源

REST 的核心理念就是资源。每个资源都由一个 URL 定义，然后通过向指定 URL发送 `GET` 请求来获取资源。目前大部分 API 会得到的一个 JSON 回应。代码如下：

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


GraphQL 在这方面就相当不一样了，因为在 GraphQL 里这两个概念是完全分开的。在你的模版里可能会有 ‘Book’ 和 ’Author‘ 两种类型：

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


如果想要真正接触到某一本书或者其作者的信息，我们需要在我们现有的模式中创造一个 ‘Query’ 类型：

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

很好，现在我们有成果了！即使双方都使用 URL 来发送请求并返回相同的 JSON 类作为回应，我们还是能马上看出 GraphQL 和 REST 之间的区别。

首先，我们能看出 GraphQL 查询的 URL 详细指出了我们所寻找的资源以及我们所关心的值域。而且 API 的使用者决定是否需要包括有关 ‘author’ 的资源，而不是由服务器端的代码来决定。


但最重要的是，资源的身份以及 Book 和 Author 的概念和获取的方式无关。我们实际上可以使用多种不同的请求来获取一本书的不同值域。

#### 总结

我们以及找到了一些相同和不同的地方：

- ** 相同：** 都拥有资源这个概念，而且都可以制定资源的身份
- ** 相同：** 都能通过 HTTP GET 和一个 URL 来获取信息
- ** 相同：** 请求的返回值都是 JSON 数据
- ** 不同：** 在 REST 中，你所访问的终端就是所需对象的身份，在 GraphQL 中，对象的身份和获取的方式是独立存在的
- ** 不同：** 在 REST 中，资源的形式和大小是由服务器所决定的。在 GraphQL 中，服务器声明哪些资源可以获得，而客户端会对其所需资源作出请求。


好吧，如果你之前使用过 GraphQL 和／或 REST的话这些看上去很基础。如果你之前没用过 GraphQL，你可以使用 Launchpad 来试试[这个实例](https://launchpad.graphql.com/1jzxrj179) 。这是一个用于在浏览器中创造和探索 GraphQL 实例的工具。


### URL 路径 vs GraphQL 模版

一款无法正确预测结果的API是没有实际用途的。当你使用一款API的时候，大部分情况下你是在一个程序的某一部分去使用它，这款程序会知道在什么时候去使用API，以及API的结果是什么。这样程序才能运用好API返回的结果。

所以一款 API 最重要的一个特点就是去描述它到底能接触并得到什么。你在读API文档的时候恰恰就是为了了解这些。现在通过使用 GraphQL 的内部描述特点或者使用类似 Swagger 这种适用于 REST 模板系统的工具，我们可以采用编程的方式来获取这方面的信息。

目前的 REST API 通常被形容为一连串的终端：

    GET /books/:id
    GET /authors/:id
    GET /books/:id/comments
    POST /books/:id/comments

所以你可以说此 API 的“形态”是线性的 —— 因为你可以接触一连串的信息。当你想要获取或者存储信息的时候，最先想到的问题就是“我应该使用哪一个终端”？

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

当我们在同一数据集上将它和 REST 的路径做对比时，有几点有趣的地方。首先，在区分读取和写入时，GraphQL 使用的是 Mutation 和 Query 这两种不同的初始类型，而不是通过对同一 URL 发送两种不同的 HTTP 术语。在 GraphQL 文档中，你可以使用关键字来选择你所发送的操作：

    query { ... }
    mutation { ... }

**如果想要了解更多有关查询语言的细节，请阅读我之前写的文章， **[**“对 GraphQL 查询的分析“。**](https://dev-blog.apollodata.com/the-anatomy-of-a-graphql-query-6dffa9e9e747)

你可以看出 Query 类型中的值域和我们之前所写的 REST 路径正好重合。这是因为此类型是我们数据的切入点，所以这在 GraphQL 中是和终端 URL 几乎相同的一个概念。

你从 GraphQL API 中获取最初资源的方式和使用 REST 的方法类似 —— 都是通过传递一个名字和一些参数 —— 但最大的不同之处是在这之后你会做什么。你可以用 GraphQL 发送一个复杂的请求并通过与模板之间的关系来获取数据。但在 REST 中，你需要通过发送多个请求来使用相关数据去构造最初的回应，或者通过改写 URL 的参数来修改回应。

#### 结论

在 REST 中， 可获得数据的空间是由一系列线性的终端来描述的，而在 GraphQL 中是通过使用有关联的模板：

- **相同：** REST API 中的一列终端和 GraphQL API 中的 Query 和 Mutation 类的值域很像。它们都是数据的切入点。
- **相同：** 两种 API 都可以区分数据的读取和写入。
- **不同：** 在 GraphQL 中，你可以使用由模板定义的关系，通过发送一次请求从初始点一直走到相关数据。然而在 REST 中，你必须要使用多个终端来获取相关资源。
- **不同：** 在 GraphQL 中，除了在每个请求的根源处所能获取的类型都是 Query 类外，Query 的值域和其他类的值域没有本质区别。比方说，你可以在 Query 的每个值域里放一个参数。而在 REST 中，嵌套的URL里没有第一类这个概念。
- **不同：** 在 REST 中，你通过将 HTTP 术语 GET 改为 POST 来指定写入，但在 GraphQL 里需要改变请求里的关键字。

由于第一个相似点，很多人把 GraphQL 的 Query 类中的值域当作“终端”或者“请求”。虽然两者确实相似，但这种理解可能会误导别人认为 Query 类和其他类的工作方式不同，这种理解是错误的。

### 路径处理器 vs Resolvers
当你使用一款 API 的时候到底发生了什么？通常情况下 API 会在服务器端收到请求后执行一段代码。这类代码即有可能进行计算，也可能是从数据库中加载数据，甚至会使用另一款 API 或做其他事。重要的是你不需要了解它在内部到底做了了什么。不过 REST 和 GraphQL 这两款 API 都具备非常标准化的内部执行方式，通过比较它们内部的执行区别，我们可以找出这两款 API 基础层面的不同点。

在接下来的对比中我会使用 JavaScript，因为这是我最熟悉的语言。不过你当然可以用其他语言去使用 REST 或者 GraphQL。我会省略设置服务器的步骤，因为这不是重点。

Let’s look at a hello world example with express, a popular API library for Node:

    app.get('/hello', function (req, res) {
      res.send('Hello World!')
    })

Here you see we’ve created a `/hello` endpoint that returns the string `'Hello World!'`. From this example we can see the lifecycle of an HTTP request in a REST API server:

1. The server receives the request and retrieves the HTTP verb (`GET` in this case) and URL path
2. The API library matches up the verb and path to a function registered by the server code
3. The function executes once, and returns a result
4. The API library serializes the result, adds an appropriate response code and headers, and sends it back to the client

GraphQL works in a very similar way, and for the same [hello world example](https://launchpad.graphql.com/new) it’s virtually identical:

    const resolvers = {
      Query: {
        hello: () => {
          return 'Hello world!';
        },
      },
    };

As you can see, instead of providing a function for a specific URL, we’re providing a function that matches a particular field on a type, in this case the `hello` field on the `Query` type. In GraphQL, this function that implements a field is called a **resolver**.

To make a request we need a query:

    query {
      hello
    }

So here’s what happens when our server receives a GraphQL request:

1. The server receives the request, and retrieves the GraphQL query
2. The query is traversed, and for each field the appropriate resolver is called. In this case, there’s just one field, `hello`, and it’s on the `Query` type
3. The function is called, and it returns a result
4. The GraphQL library and server attaches that result to a response that matches the shape of the query

So you would get back:

    { "hello": "Hello, world!" }

But here’s one trick, we can actually call the field twice!

    query {
      hello
      secondHello: hello
    }

In this case, the same lifecycle happens as above, but since we’ve requested the same field twice using an alias, the `hello` resolver is actually called *twice*. This is clearly a contrived example, but the point is that multiple fields can be executed in one request, and the same field can be called multiple times at different points in the query.

This wouldn’t be complete without an example of “nested” resolvers:

    {
      Query: {
        author: (root, { id }) => find(authors, { id: id }),
      },
      Author: {
        posts: (author) => filter(posts, { authorId: author.id }),
      },
    }

These resolvers would be able to fulfill a query like:

    query {
      author(id: 1) {
        firstName
        posts {
          title
        }
      }
    }

So even the set of resolvers is actually flat, because they are attached to various types you can build them up into nested queries. Read more about how GraphQL execution works in the post [“GraphQL Explained”](https://dev-blog.apollodata.com/graphql-explained-5844742f195e).

[*See a complete example and run different queries to test this out!*](https://launchpad.graphql.com/1jzxrj179)

![](https://cdn-images-1.medium.com/max/1600/1*qpyJSVVPkd5c6ItMmivnYg.png)

An artists’ interpretation of fetching resources with multiple REST roundtrips vs. one GraphQL request
#### Conclusion

At the end of the day, both REST and GraphQL APIs are just fancy ways to call functions over a network. If you’re familiar with building a REST API, implementing a GraphQL API won’t feel too different. But GraphQL has a big leg up because it lets you call several related functions without multiple roundtrips.

- **Similar:** Endpoints in REST and fields in GraphQL both end up calling functions on the server.
- **Similar: **Both REST and GraphQL usually rely on frameworks and libraries to handle the nitty-gritty networking boilerplate.
- **Different:** In REST, each request usually calls exactly one route handler function. In GraphQL, one query can call many resolvers to construct a nested response with multiple resources.
- **Different:** In REST, you construct the shape of the response yourself. In GraphQL, the shape of the response is built up by the GraphQL execution library to match the shape of the query.

Essentially, you can think of GraphQL as a system for calling many nested endpoints in one request. Almost like a multiplexed REST.

---

### What does this all mean?

There are a lot of things we didn’t have space to get into in this particular post. For example, object identification, hypermedia, or caching. Perhaps that will be a topic for a later time. But I hope you agree that when you take a look at the basics, REST and GraphQL are working with fundamentally similar concepts.

I think some of the differences are in GraphQL’s favor. In particular, I think it’s really cool that you can implement your API as a set of small resolver functions, and then have the ability to send a complex query that retrieves multiple resources at once in a predictable way. This saves the API implementer from having to create multiple endpoints with specific shapes, and enables the API consumer to avoid fetching extra data they don’t need.

On the other hand, GraphQL doesn’t have as many tools and integrations as REST yet. For example, you can’t cache GraphQL results using HTTP caching as easily as you can REST results. But the community is working hard on better tools and infrastructure, and you can cache GraphQL results using tools like [Apollo Client](http://dev.apollodata.com/) and [Relay](https://facebook.github.io/relay/).

Got any more ideas about comparisons between REST and GraphQL? Please post them in the comments!


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
