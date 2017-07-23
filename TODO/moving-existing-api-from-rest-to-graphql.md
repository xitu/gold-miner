
> * 原文地址：[Moving existing API from REST to GraphQL](https://medium.com/@raxwunter/moving-existing-api-from-rest-to-graphql-205bab22c184)
> * 原文作者：[Roman Krivtsov](https://medium.com/@raxwunter)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/moving-existing-api-from-rest-to-graphql.md](https://github.com/xitu/gold-miner/blob/master/TODO/moving-existing-api-from-rest-to-graphql.md)
> * 译者：
> * 校对者：

# Moving existing API from REST to GraphQL

So last 6 months I saw talks about GraphQL at almost every conference related to web development. A lot of posts and articles are issued about it. But all these things are mostly about basics of GraphQL or new features and looked superficially. So I’d like to tell about my personal experience of adopting real big system to GraphQL.

### What’s wrong with REST

REST (as well as SOAP) doesn’t separate concerns of transport, security and data logic. It leads to plenty of problems. Let’s consider some of them.

#### Poor GET query capabilities

It’s not possible to do deep and complex queries with GET string. Let’s assume, that we need to find users. First case is pretty straightforward:

**GET** /users/?name=Homer

Then imagine, that we have to find user with names Homer OR Marge. Things become tricky. We can define some separator for this kind of syntax.

**GET** /users/?name=Homer|Marge

Don’t forget to escape characters! And also, please keep in mind, that if some name contains “|” you screwed. More complex example is trying to get union of 2 different fields. And intersection of course as well!

So far we were using fields for searching as is. But usually we also need to pass some service data with query. For example for pagination:

**GET** /users/?name=Homer|Marge&limit=10&offset=20

According to some logic, our query parser on the backend should recognize limit and offset parameters as fields for database, because it’s declared at the same level as “name”.

We can invent our own syntax or use POST method (that is wrong, because this is an idempotent request) but it seems as inventing a wheel.

#### Problems with data updating

The easiest way to update data using REST — is to use PUT method sending whole the object to update. But of course it’s not the most efficient way, when you need to update just one field in 1Mb entity.

HTTP has PATCH method. But there is a problem with it. Algorithm definition *how exactly to update entity* is not easy at all. Furthermore there are several specifications which recommend how you should do it, e.g *RFC 6902, RFC 7396* as well as many custom solutions.

#### Naming problem

I guess each developer ever dealt with REST knows that feeling, when you don’t know how to name your new route. Not all of business cases can be described in terms of resources. For example we’d like to make a search for products with information of it’s shop.

**GET** /search?product_name=IPhone&shop_name=IStore

What is resource here? Products? Shops? Search?

OMG my API is not going to be RESTfull!

Or another canonical example with user login. What is resource here? Spoiler: there is no resources here, it’s just a Remote Procedure Call.

#### Handling REST on backend

```
app.post((req, res) => {
  const user = db.getUserByName(req.headers.name);
  const user = db.getUserByName(req.query.name);
  const user = db.getUserByName(req.path.name);
  const user = db.getUserByName(req.body.name);
});
```

This is an example of Express.js route. Here we are trying to get user_id to be able to query user. Let’s look how usually an API function should look like:

![](https://cdn-images-1.medium.com/max/1200/1*-x82CcGJlLIOOJtRRBRNSg.png)

Function accepts arguments, that it needs to perform the certain action and return the certain result.

What do we get as arguments in case of Express route? A huge messy object *req* and somewhere inside of it needed peace of data.

Of course it’s a problem of Express as well (Node HTTP module to be precisely), but such interface was evolved also driving by HTTP realization — request parameters can be anywhere and it’s not possible to know exactly where if you are not aware of it personally or you don’t use well described API docs.

That’s why using REST without API docs is so painful.

### GraphQL

This article assumes, that you are already familiar with GraphQL basics. If not, you can start with the great intro text from Apollo about [GraphQL basics](https://medium.com/apollo-stack/the-basics-of-graphql-in-5-links-9e1dc4cac055#.uyc4ml4jx)

So previously we inferred, that REST has design problems. But GraphQL definitely not. Furthermore it has a huge growth potential.

First of all GraphQL provides a RPC approach, which means that you are not limited with your client-server interaction. GraphQL has it’s own type system, which means that you are not going to have misleading errors and bugs. Also type system means that your client is able to support smart cache for your data on the items level. Together with plenty of web oriented features like connections (cursors and pagination), batching, deferring etc. it **makes your client-server interaction as efficient as possible**.

> But REST is still an industry standard

Yes, whether we like it or not but REST is a must be API format for the nearest several years.

But we can still use GraphQL for our internal purposes (for some advanced clients for example) and REST for others.

For that we need to wrap REST endpoints to GraphQL types. There are some articles and examples (the most cited is [https://github.com/apollostack/swapi-rest-graphql](https://github.com/apollostack/swapi-rest-graphql)) of moving from REST to GraphQL. But they suggest to use custom resolvers, that is unsatisfactorily for big projects having hundreds of endpoints.

At my last 3 projects I used [Swagger](http://swagger.io) to describe the REST API. It’s more or less standard for declarative API description. And I honestly have no clue how some people write huge APIs not having it described.

So having Swagger as a standard for declarative REST API from one hand and GraphQL from the another one, we can see that they are pretty similar, Swagger in addition just tries to describe HTTP details as well as business logic. **Both of them describe in types incoming arguments and outgoing response**. It means that we can write adapter between them!

![](https://cdn-images-1.medium.com/max/1200/1*R55lFpFRNqkScfMnTXpPfw.png)

That’s how REST endpoint

**GET** /user/id

can be adopted to GraphQL type.

So now we just need a library which does it automatically. And here it is!

[https://github.com/yarax/swagger-to-graphql](https://github.com/yarax/swagger-to-graphql)

Swagger2graphQL accepts your Swagger schema and returns GraphQL schema, where resolvers are automatically build HTTP requests to existing REST endpoints.

It was built as a side project of moving real big system with more than 150 endpoints to GraphQL. We needed to move to GraphQL as fast as possible with minimum effort and problems.

So just clone the repository, run

*npm install && npm start*

and go to [http://localhost:3009/graphql](http://localhost:3009/graphql)

You will see GraphQL API wrapped over [http://petstore.swagger.io/](http://petstore.swagger.io/) Swagger demo API.

Furthermore, having Swagger and GraphQL it’s very convenient to write new endpoints. If you already familiar with GraphQL you probably noticed that sometimes types description look very verbose, because you have to create a lot of implicit types. Swagger2graphQL makes them automatically and you just need to create a new declarative endpoint in Swagger schema, which usually is very easy.

Please send issues if you come across with any problems or questions!

Also you can find me in Twitter [http://twitter.com/raxpost](http://twitter.com/raxpost)


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
