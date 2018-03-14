> * 原文地址：[A Front End Developer’s Guide to GraphQL](https://css-tricks.com/front-end-developers-guide-graphql/)
> * 原文作者：[PEGGY RAYZIS](https://css-tricks.com/author/peggyrayzis/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/front-end-developers-guide-graphql.md](https://github.com/xitu/gold-miner/blob/master/TODO/front-end-developers-guide-graphql.md)
> * 译者：
> * 校对者：

# A Front End Developer’s Guide to GraphQL

No matter how large or small your application is, you’ll have to deal with fetching data from a remote server at some point. On the front end, this usually involves hitting a REST endpoint, transforming the response, caching it, and updating your UI. For years, REST has been the status quo for APIs, but over the past year, a new API technology called GraphQL has exploded in popularity due to its excellent developer experience and declarative approach to data fetching.

In this post, we’ll walk through a couple of hands-on examples to show you how integrating GraphQL into your application will solve many pain points working with remote data. If you’re new to GraphQL, don’t panic! I’ll also highlight some resources to help you learn GraphQL using the Apollo stack, so you can start off 2018 ahead of the curve.

### GraphQL 101

Before we dive into how GraphQL makes your life as a front end developer easier, we should first clarify what it is. When we talk about GraphQL, we're either referring to the language itself or its rich ecosystem of tools. At its core, GraphQL is a typed query language developed by Facebook that allows you to describe your data requirements in a declarative way. The shape of your result matches the shape of your query: in the example below, we can expect to receive back an object with a `currency` property and a `rates` property containing an array of objects with both `currency` and `rate` keys.

```
{
  rates(currency: "USD") {
    currency
    rates {
      currency
      rate
    }
  }
}
```

When we talk about GraphQL in a broader sense, we’re often referring to the ecosystem of tools that help you implement GraphQL in your application. On the backend, you’ll use [Apollo Server](https://www.apollographql.com/docs/apollo-server/) to create a GraphQL server, which is a single endpoint that parses a GraphQL request and returns data. How does the server know which data to return? You’ll use [GraphQL Tools](https://www.apollographql.com/docs/graphql-tools/) to build a schema (like a blueprint for your data) and a resolver map (just a series of functions that retrieve your data from a REST endpoint, database, or wherever else you choose).

This all sounds more complicated than it actually is — with Apollo Launchpad, a GraphQL server playground, you can create a working GraphQL server in your browser in less than 60 lines of code! 😮 We’ll reference this [Launchpad I created](https://launchpad.graphql.com/v7mnw3m03) that wraps the Coinbase API throughout this post.

You’ll connect your GraphQL server to your application with [Apollo Client](https://www.apollographql.com/docs/react/), a fast and flexible client that fetches, caches, and updates your data for you. Since Apollo Client isn’t coupled to your view layer, you can use it with React, Angular, Vue, or plain JavaScript. Not only is Apollo cross-framework, it’s also cross-platform, with React Native & Ionic supported out of the box.

### Let’s give it a try! 🚀

Now that you’re well-versed in what GraphQL is, let’s get our hands dirty with a couple of practical examples that illustrate what it’s like to develop your front end with Apollo. By the end, I think you’ll be convinced that a GraphQL-based architecture with Apollo can help you ship features faster than before.

#### 1. Add new data requirements without adding a new endpoint

We’ve all been here before: You spend hours building a perfect UI component when suddenly, product requirements change. You quickly realize that the data you need to fulfill these new requirements would either require a complicated waterfall of API requests or worse, a new REST endpoint. Now blocked on your work, you ask the backend team to build you a new endpoint just to satisfy the data needs for one component.

This common frustration no longer exists with GraphQL because the data you consume on the client is no longer coupled to an endpoint’s resource. Instead, you always hit the same endpoint for your GraphQL server. Your server specifies all of the resources it has available via your schema and lets your query determine the shape of the result. Let’s illustrate these concepts using [our Launchpad](https://launchpad.graphql.com/v7mnw3m03) from before:

In our schema, look at lines 22–26 where we define our `ExchangeRate` type. These fields list out all the available resources we can query in our application.

```
type ExchangeRate {
  currency: String
  rate: String
  name: String
}
```

With REST, you’re limited to the data your resource provides. If your `/exchange-rates` endpoint doesn’t include name, then you’ll need to either hit a different endpoint like `/currency` for the data or create it if it doesn’t exist.

With GraphQL, we know that name is already available to us by inspecting our schema, so we can query for it in our application. Try running this example in Launchpad by adding the name field on the right side panel!

```
{
  rates(currency: "USD") {
    currency
    rates {
      currency
      rate
      name
    }
  }
}
```

Now, remove the name field and run the same query. See how the shape of our result changes?

![the data changes as you describe your query differently](https://cdn.css-tricks.com/wp-content/uploads/2017/12/shape-data.jpg)

Your GraphQL server always gives you back exactly the data you ask for. Nothing more. This differs significantly from REST, where you often have to filter and transform the data you get back from the server into the shape your UI components need. Not only does this save you time, it also results in smaller network payloads and CPU savings from loading and parsing the response.

#### 2. Reduce your state management boilerplate

Fetching data almost always involves updating your application’s state. Typically, you’ll write code to track at least three actions: one for when the data is loading, one if the data successfully arrives, and one if the data errors out. Once the data arrives, you have to transform it into the shape your UI components expect, normalize it, cache it, and update your UI. This process can be repetitive, requiring countless lines of boilerplate to execute one request.

Let’s see how Apollo Client eliminates this tiresome process altogether by looking at [an example React app in CodeSandbox](https://codesandbox.io/s/jvlrl98xw3). Navigate to `list.js` and scroll to the bottom.

```
export default graphql(ExchangeRateQuery, {
  props: ({ data }) => {
    if (data.loading) {
      return { loading: data.loading };
    }
    if (data.error) {
      return { error: data.error };
    }
    return {
      loading: false,
      rates: data.rates.rates
    };
  }
})(ExchangeRateList);
```

In this example, [React Apollo](https://www.apollographql.com/docs/react/basics/integrations.html), Apollo Client’s React integration, is binding our exchange rate query to our ExchangeRateList component. Once Apollo Client executes that query, it tracks loading and error state automatically and adds it to the `data` prop. When Apollo Client receives the result, it will update the `data` prop with the result of the query, which will update your UI with the rates it needs to render.

Under the hood, Apollo Client normalizes and caches your data for you. Try clicking some of the currencies in the panel on the right to watch the data refresh. Now, select a currency a second time. Notice how the data appears instantaneously? That’s the Apollo cache at work! You get all of this for free just by setting up Apollo Client with no additional configuration. 😍 To see the code where we initialize Apollo Client, check out `index.js`.

#### 3\. Debug quickly & painlessly with Apollo DevTools & GraphiQL

It looks like Apollo Client does a lot for you! How do we peek inside to understand what’s going on? With features like store inspection and full visibility into your queries & mutations, Apollo DevTools not only answers that question, but also makes debugging painless and, dare I say it, fun! 🎉 It’s available as an extension for both Chrome and Firefox, with React Native coming soon.

If you want to follow along, [install Apollo DevTools](https://github.com/apollographql/apollo-client-devtools) for your preferred browser and navigate to [our CodeSandbox](https://codesandbox.io/s/jvlrl98xw3) from the previous example. You’ll need to run the example locally by clicking Download in the top nav bar, unzipping the file, running `npm install`, and finally `npm start`. Once you open up your browser’s dev tools panel, you should see a tab that says Apollo.

First, let’s check out our store inspector. This tab mirrors what’s currently in your Apollo Client cache, making it easy to confirm your data is stored on the client properly.

![store inspector](https://cdn.css-tricks.com/wp-content/uploads/2017/12/1_WjEM653oIZUw4wQyjCqPkA.png)

Apollo DevTools also enables you to test your queries & mutations in GraphiQL, an interactive query editor and documentation explorer. In fact, you already used GraphiQL in the first example where we experimented with adding fields to our query. To recap, GraphiQL features auto-complete as you type your query into the editor and automatically generated documentation based on GraphQL’s type system. It’s extremely useful for exploring your schema, with zero maintenance burden for developers.

![Apollo Devtools](https://cdn.css-tricks.com/wp-content/uploads/2017/12/1_s9Bl8jejFH2TAlZk2knFBQ.png)

Try executing queries with GraphiQL in the right side panel of [our Launchpad](https://launchpad.graphql.com/v7mnw3m03). To show the documentation explorer, you can hover over fields in the query editor and click on the tooltip. If your query runs successfully in GraphiQL, you can be 100% positive that the same query will run successfully in your application.

### Level up your GraphQL skills

If you made it to this point, awesome job! 👏 I hope you enjoyed the exercises and got a taste of what it would be like to work with GraphQL on the front end.

Hungry for more? 🌮 Make it your 2018 New Year’s resolution to learn more about GraphQL, as I expect its popularity to grow even more in the upcoming year. Here’s an example app to get you started featuring the concepts we learned today:

*   React: [https://codesandbox.io/s/jvlrl98xw3](https://codesandbox.io/s/jvlrl98xw3)
*   Angular (Ionic): [https://github.com/aaronksaunders/ionicLaunchpadApp](https://github.com/aaronksaunders/ionicLaunchpadApp)
*   Vue: [https://codesandbox.io/s/3vm8vq6kwq](https://codesandbox.io/s/3vm8vq6kwq)

Go forth and GraphQL (and be sure to tag us on Twitter [@apollographql](https://twitter.com/apollographql) along the way)! 🚀


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
