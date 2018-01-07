> * 原文地址：[The future of state management](https://dev-blog.apollodata.com/the-future-of-state-management-dd410864cae2)
> * 原文作者：[Peggy Rayzis](https://dev-blog.apollodata.com/@peggyrayzis?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/the-future-of-state-management.md](https://github.com/xitu/gold-miner/blob/master/TODO/the-future-of-state-management.md)
> * 译者：
> * 校对者：

# The future of state management

## Managing your local data in Apollo Client with apollo-link-state

![](https://cdn-images-1.medium.com/max/1000/1*YfE1f2lBr0hnpcRESiUy1w.png)

When an application grows in size, its state often grows in complexity. As developers, we’re not only tasked with juggling data from multiple remote servers, but also with handling local data resulting from UI interactions. To top it off, we have to store all of this data in a way that’s easily accessible from any component in our application.

Thousands of developers have told us that Apollo Client excels at managing remote data, which equates to roughly **80%** of their data needs. But what about local data (like global flags and device API results) that make up **the other 20%** of the pie?

Historically, Apollo users managed that 20% in a separate Redux or MobX store. This was a doable solution for Apollo Client 1.0, but when Apollo Client 2.0 migrated away from Redux, syncing local and remote data between two stores became trickier. We often heard from our users that they wanted to encapsulate all of their application’s state inside Apollo Client and maintain **one source of truth**.

### Building upon a solid foundation

We knew we had to solve this problem, so we asked ourselves: What would it look like to manage state in Apollo Client? First, we thought about what we liked about Redux — features like its dev tools and binding state to components via connect. We also thought about some of our pain points with Redux, like its boilerplate and its do-it-yourself approach to core features like asynchronous action creators, caching, and optimistic UI.

To create our ideal state management solution, we wanted to build upon what makes Redux great while addressing some criticisms of it. We also wanted to leverage the power of GraphQL to request data from multiple sources in one query.

![](https://cdn-images-1.medium.com/max/800/1*ZHTs1iOH247NQLEOxXzHFw.png)

An architecture diagram of the data flow in Apollo Client

### Learn once, GraphQL anywhere

One common misconception about GraphQL is that it’s coupled to a specific server implementation. In fact, it’s much more flexible than that. It doesn’t matter if you’re requesting from a [gRPC server](https://github.com/iheanyi/go-grpc-graphql-simple-example), [REST endpoint](https://github.com/apollographql/apollo-link-rest), or your [client-side cache](https://github.com/apollographql/apollo-link-state) — GraphQL is a **universal language for data** that’s completely agnostic of its source.

This is why GraphQL queries and mutations are a perfect fit for describing what’s happening with our application’s state. Instead of dispatching actions, we use GraphQL mutations to express state changes. We can access our state by declaratively expressing our component’s data requirements with a GraphQL query.

One of the biggest advantages of GraphQL is that we can aggregate data from multiple sources, both local and remote, in one query by specifying GraphQL directives on our fields. 🎉 Let’s find out how!

### State management with Apollo Client

Managing your local data in Apollo Client is made possible by [Apollo Link](https://www.apollographql.com/docs/link/), our modular network stack that allows you to hook into the GraphQL request cycle at any point. To request data from a GraphQL server, we use `HttpLink`, but to request local data from our cache we need to install a new link: `apollo-link-state`.

```
import { ApolloClient } from 'apollo-client';
import { InMemoryCache } from 'apollo-cache-inmemory';
import { ApolloLink } from 'apollo-link';
import { withClientState } from 'apollo-link-state';
import { HttpLink } from 'apollo-link-http';

import { defaults, resolvers } from './resolvers/todos';

const cache = new InMemoryCache();

const stateLink = withClientState({ resolvers, cache, defaults });

const client = new ApolloClient({
  cache,
  link: ApolloLink.from([stateLink, new HttpLink()]),
});
```

Initializing Apollo Client with apollo-link-state

To create your state link, use the `withClientState` function and pass in an object with `resolvers`, `defaults`, and your Apollo `cache`. Then, concatenate your state link to your link chain. Your state link should come before your `HttpLink` so local queries and mutations are intercepted before they hit the network.

#### Defaults

Your `defaults` are an object representing the initial state that you would like to write to the cache upon creation of the state link. While not required, it’s important to pass in `defaults` to warm the cache so that any components querying that data don’t error out. The shape of your `defaults` object should mirror how you plan to query the cache in your application.

```
export const defaults = {
  visibilityFilter: 'SHOW_ALL',
  todos: [],
};
```

Defaults represent the initial state you want to write the cache

#### Resolvers

When we manage state with Apollo Client, our Apollo cache becomes our single source of truth for all the local and remote data in our application. How do we update and access the data in the cache? That’s where our resolvers come in. If you’ve worked with `graphql-tools` on the server, the type signature of resolvers on the client are identical:

```
fieldName: (obj, args, context, info) => result;
```

No worries if this is unfamiliar to you, the two most important things to note here are that your query or mutation variables are passed in as the second argument and the cache is automatically added to the context for you.

```
export const defaults = { // same as before }
  
export const resolvers = {
  Mutation: {
    visibilityFilter: (_, { filter }, { cache }) => {
      cache.writeData({ data: { visibilityFilter: filter } });
      return null;
    },
    addTodo: (_, { text }, { cache }) => {
      const query = gql`
        query GetTodos {
          todos @client {
            id
            text
            completed
          }
        }
      `;
      const previous = cache.readQuery({ query });
      const newTodo = {
        id: nextTodoId++,
        text,
        completed: false,
        __typename: 'TodoItem',
      };
      const data = {
        todos: previous.todos.concat([newTodo]),
      };
      cache.writeData({ data });
      return newTodo;
    },
  }
}
```

Resolver functions are how you update and access data in the cache

To write data to the root of the cache, we call `cache.writeData` and pass in our data. Sometimes what we’re writing to the cache depends on the data that was previously there, like in our mutation `addTodo` above. In that case, you can use `cache.readQuery` to read from the cache before you perform a write. If you would like to write a fragment to an existing object in the cache, you can optionally pass in an `id`, which corresponds to the object’s cache key. Since we’re using the `InMemoryCache`, the key is `__typename:id`.

`apollo-link-state` supports asynchronous resolver functions, which is useful for performing async side effects like accessing device APIs. However, we don’t recommend calling REST endpoints in your resolvers. Instead, use `[apollo-link-rest](https://github.com/apollographql/apollo-link-rest)`, which has its own `@rest` directive.

#### `@client` directive

When we trigger a mutation from our UI, Apollo’s network stack needs to know whether to update the data on the client or the server. `apollo-link-state` uses an `@client` directive to specify client-only fields. Then, `apollo-link-state` calls the resolvers for those fields.

```
const SET_VISIBILITY = gql`
  mutation SetFilter($filter: String!) {
    visibilityFilter(filter: $filter) @client
  }
`;

const setVisibilityFilter = graphql(SET_VISIBILITY, {
  props: ({ mutate, ownProps }) => ({
    onClick: () => mutate({ variables: { filter: ownProps.filter } }),
  }),
});
```

Performing a mutation on local data with the @client directive

Queries look very similar to mutations. If you are performing any asynchronous actions in your query, Apollo Client will track loading and error states for you. For React, you’ll find these states on `this.props.data`, along with numerous helper methods for refetching, pagination, and polling.

One exciting feature is that you can request from multiple data sources in one query! 😍 In this example, we’re requesting a `user` from our GraphQL server in addition to the `visibilityFilter` in the Apollo cache.

```
const GET_USERS_ACTIVE_TODOS = gql`
  {
    visibilityFilter @client
    user(id: 1) {
      name
      address
    }
  }
`;

const withActiveState = graphql(GET_USERS_ACTIVE_TODOS, {
  props: ({ ownProps, data }) => ({
    active: ownProps.filter === data.visibilityFilter,
    data,
  }),
});
```

Querying the Apollo cache with the @client directive

For more examples and tips for integrating `apollo-link-state` into your application, head on over to our [updated docs page](https://www.apollographql.com/docs/link/links/state.html).

### Roadmap to 1.0

Even though `apollo-link-state` is stable enough to use in your application today, there are some features we’d like to tackle soon:

* **Client-side schema:** Right now, we don’t have support for type validation against a client-side schema. This is because including the `graphql-js` modules for constructing and validating a schema at runtime would dramatically increase your bundle size. Instead, we hope to move schema construction to build time with support for introspection so you can still take advantage of all the cool features in GraphiQL.
* **Helper components:** Our goal is to make state management in Apollo as seamless as possible. We’d like to write some React components to reduce some of the verbosity for performing common tasks like passing a variable into a mutation while still implementing it as a mutation under the hood.

If these problems sound interesting to you, come join us on [GitHub](https://github.com/apollographql/apollo-link-state) or the `#local-state` channel on Apollo Slack. We’d love to have you on board to help shape the next generation of state management! 🚀


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
