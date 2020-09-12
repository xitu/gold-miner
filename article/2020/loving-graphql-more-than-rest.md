> * 原文地址：[Loving GraphQL More than REST](https://medium.com/javascript-in-plain-english/loving-graphql-more-than-rest-4e213c568635)
> * 原文作者：[Saurav Singh](https://medium.com/@snipextt)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/loving-graphql-more-than-rest.md](https://github.com/xitu/gold-miner/blob/master/article/2020/loving-graphql-more-than-rest.md)
> * 译者：
> * 校对者：

# Loving GraphQL More than REST

## Loving GraphQL more than REST

![](https://cdn-images-1.medium.com/max/2240/1*ZxDw0j3ANBxpatoCdNW8JQ.png)

Ever since Facebook open-sourced GraphQL, it’s popularity has been continuously increasing to a point today where it’s almost everywhere. But what makes it so popular? How it compares to the REST Based Architecture and is it going to replace REST APIs completely? Here’s something i think about GraphQL

When I first started learning GraphQL ,with zero knowledge about the same. I’ve had this idea in mind that I’m going to learn something which is entirely different from the world of Rest APIs. But halfway through my path learning GraphQL , I realized that even before starting to learn it, I developed some really impractical ideas about same and the biggest of them being

**GraphQL is something on its own and doesn’t uses things we’re really familiar with in REST APIs.**

Which is very far from the reality and funny but that’s how it appears to the people who’ve never touched GraphQL and just seen it working on the surface.

#### What Exactly Is GraphQL then?

If i were to define it now in the most simple terms, I would say it’s just a **Specification** . A really cool way of using our existing web technologies. Under the hood, GraphQL queries are simply a HTTP Post request to an API’s endpoint. Yes, it’s a Post request to an endpoint designed to work with a request including GraphQL queries, let’s quickly see an example by building a GraphQL server

For the sake of simplicity I’ll be using Node but since GraphQL is a runtime in itself. It doesn’t matter what language we’re using to build an API. Lets install the dependencies real quick

`yarn add apollo-server moment`

And build a simple GraphQL API

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

To run a query

![](https://cdn-images-1.medium.com/max/2000/1*mTjqS4y5E1JZzhuxSjKwaQ.jpeg)

#### Wait this isn’t how you run a query in GraphQL!

Yes that’s exactly right and if you’ve ever touched on GraphQL playground you know it, but this is what i was talking about above. Under the hood a GraphQL client (Consider the GraphQL playground) sends a post request to the specified API endpoint/channel with a body similar to above. The GraphQL runtime is already aware how to handle the request because it has a sense of schema for the data it’s going to get and send back.

This, however often leads to an unexpected behaviors when you’re returning a value for something you haven’t specified in the type definitions, GraphQL tries automatically type cast the value and blow up if it doesn’t works.

**Quick note — Every request to the GraphQL API is classified as a query, including Mutation, subscriptions and query itself if you know what they are.**

#### Is Schema the only reason why GraphQL is so powerful?

No there’s a lot more to it and a lot more really, GraphQL brings more power to your APIs (especially to the clients) by allowing them to query only specific fields and hence they can only query the data needed and ignore the rest, which results in smaller transfer size, less bandwidth and latency. Let make changes to our code from above and see it in action

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

We’ve added another field to the type dateTime, and this time we don’t want to query the other two fields. And it’s really dead simple, all we have to do is specify the fields we are interested when making a request like below

![](https://cdn-images-1.medium.com/max/3158/1*5zaQAUnUIov7mPj2ygLk1w.jpeg)

For a small application this doesn’t add much. But For a large application, you always want the most optimized solutions. The idea to query only the required fields itself is very powerful and hence it’s always been a pattern in the traditional REST architecture as well to make routes for retrieving some specific data. This works without an issue for a small application and even theoretically but as the app size grow larger (consider Facebook), connecting wires become more and more complex and you’ll eventually run into a situation where you have to re design the entire system again using something like GraphQL or maybe end up building another GraphQL.

And there’s still more to cool stuffs GraphQL ships with (Like Subscriptions) but that can be saved for another articles someday because i wanted to talk on if GraphQL is better than the traditional REST APIs.

#### Is GraphQL really a better REST and is going to replace it completely?

I’ll agree on GraphQL being a better version of rest and it’s a really powerful alternative to REST but it’s not going to replace APIs today or anytime soon. And there are a couple of reasons for the same.The major ones being

**For a small application A REST API can do pretty much everything a GraphQL API would.**

**Since GraphQL bring more power to the clients by allowing them to only query the fields they need. But this powerful features trades off server side performance for the same, if the client request for a lot of nested fields which requires multiple resources like reading from file system or database. And there are millions of millions of such requests with your servers not being able to scale up really fast, you’ll eventually run out of resources.**

The above reasons are why in **corporate world, GraphQL APIs are used in conjunction with REST API.**

#### Personal experience with GraphQL

---

On a personal level GraphQL is my first preference when building APIs and I really haven’t built anything which doesn’t include the same for a while now. Simply because it adds a better Full Stack DX.

You made it to the very bottom! Thank you for reading.

#### JavaScript In Plain English

Did you know that we have three publications and a YouTube channel? Find links to everything at [**plainenglish.io**](https://plainenglish.io/)!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
