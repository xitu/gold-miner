> * 原文地址：[The future of state management](https://dev-blog.apollodata.com/the-future-of-state-management-dd410864cae2)
> * 原文作者：[Peggy Rayzis](https://dev-blog.apollodata.com/@peggyrayzis?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/the-future-of-state-management.md](https://github.com/xitu/gold-miner/blob/master/TODO/the-future-of-state-management.md)
> * 译者：[yct21](https://github.com/yct21/)

# 状态管理的未来：在 Apollo Client 中使用 apollo-link-state 管理本地数据

![](https://cdn-images-1.medium.com/max/1000/1*YfE1f2lBr0hnpcRESiUy1w.png)

当一个应用的规模逐渐扩张，其所包含的应用状态一般也会变得更加复杂。作为开发者，我们可能既要协调从多个远端服务器发送来的数据，也要管理好涉及 UI 交互的本地数据。我们需要以一种合适的方法存储这些数据，让应用中的组件可以简洁地获取这些数据。

许多开发者告诉过我们，使用 Apollo Client 可以很好地管理远端数据，这部分数据一般会占到总数据量的 **80%** 左右。那么剩下的 20% 的本地数据（例如全局标志、设备 API 返回的结果等）应该怎样处理呢？

过去，Apollo 的用户通常会使用一个单独的 Redux/Mobx store 来管理这部分本地的数据。在 Apollo Client 1.0 时期，这是一个可行的方案。但当 Apollo Client 进入 2.0 版本，不再依赖于 Redux，如何去同步本地和远端的数据，变得比原来更加棘手。我们收到了许多用户的反馈，希望能有一种方案，可以将完整的应用状态封装在 Apollo Client 中，从而实现**单一的数据源 (single source of truth)**。

## 解决问题的基础

我们知道这个问题需要解决，现在让我们思考一下，如何正确地在 Apollo Client 中管理状态？首先，让我们回顾一下我们喜欢 Redux 的地方，比如它的开发工具，以及将组件与应用状态绑定的 `connect` 函数。我们同时还要考虑使用 Redux 的痛点，例如繁琐的样板代码，又比如在使用 Redux 的过程中，有许多核心的需求，包括异步的 action creator，或者是状态缓存的实现，再或者是积极界面策略的采用，往往都需要我们亲自去实现。

要实现一个理想的状态管理方案，我们应当对 Redux 取长弃短。此外，GraphQL 有能力将对多个数据源的请求集成在单次查询中，在此我们将充分利用这个特性。

![](https://cdn-images-1.medium.com/max/800/1*ZHTs1iOH247NQLEOxXzHFw.png)

以上是 Apollo Client 的数据流架构图。

## GraphQL：一旦学会，随处可用

关于 GraphQL 有一个常见的误区：GraphQL 的实施依赖于服务器端某种特定的实现。事实上，GraphQL 具有很强的灵活性。GraphQL 并不在乎请求是要发送给一个 [gRPC 服务器](https://github.com/iheanyi/go-grpc-graphql-simple-example)，或是 [REST 端点](https://github.com/apollographql/apollo-link-rest)，又或是[客户端缓存](https://github.com/apollographql/apollo-link-state)。GraphQL 是一门**针对数据的通用语言**，与数据的来源毫无关联。

而这也就是为何 GraphQL 中的 query 与 mutation 可以完美地描述应用状态的状况。我们可以使用 GraphQL mutation 来表述应用状态的变化过程，而不是去发送某个 action。在查询应用状态时，GraphQL query 也能以一种声明式的方式描述出组件所需要的数据。

GraphQL 最大的一个优势在于，当给 GraphQL 语句中的字段加上合适的 GraphQL 指令后，单条 query 就可以从多个数据源中获取数据，无论本地还是远端。让我们来看看具体的方法。

## Apollo Client 中的状态管理

[Apollo Link](https://www.apollographql.com/docs/link/) 是 Apollo 的模块化网络栈，可以用于在某个 GraphQL 请求的生命周期的任意阶段插入钩子代码。Apollo Link 使得在 Apollo Client 中管理本地的数据成为可能，从一个 GraphQL 服务器中获取数据，可以使用 `HttpLink`，而从 Apollo 的缓存中请求数据，则需要使用一个新的 link: `apollo-link-state`。

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

以上代码是使用 `apollo-link-state` 初始化 Apollo Client。

要初始化一个 state link，须要将一个包含 `resolvers`、`defaults` 和 `cache` 字段的 object 作为参数，调用 Apollo Link 中的 `withClientState` 函数。然后将这个 state link 加入 Apollo Client 的 link 链中。该 state link 应该放在 `HttpLink` 之前，这样本地的 query 和 mutation 会在发向服务器前被拦截。

### Defaults

前文的 `defaults` 字段是一个用于表示状态初始值的 object，当 state link 刚创建时，这个默认值会被写入 Apollo Client 的缓存。尽管不是必需的参数，不过预热缓存是一个很重要的步骤，传入的 `default` 使得组件不会因为查询不到数据而出错。

```
export const defaults = {
  visibilityFilter: 'SHOW_ALL',
  todos: [],
};
```

以上代码的 `defaults` 代表了 Apollo cache 的初始值。

### Resolvers

在使用 Apollo Client 管理应用状态后，Apollo cache 成为了应用的单一数据源，包括了本地和远端的数据。那么我们应当如何查询和更新缓存中的数据呢？这便是 Resolver 发挥作用的地方了。如果你以前在服务器端使用过 `graphql-tools`，那么你会发现两者的 resolver 的类型签名是一样的。

```
fieldName: (obj, args, context, info) => result;
```

如果你没见过以上这段类型签名，不要紧张，只需记住重要的两点：query 或者 mutation 的变量通过 `args` 参数传递给 resolver；Apollo cache 会作为 `context` 参数的一部分传递给 resolver。

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

以上的 Resolver 函数是查询和更新 Apollo cache 的方法。

若要在 Apollo cache 的根上写入数据，可以调用 `cache.writeData` 方法并传入相应的数据。有时候我们需要写入的数据依赖于 Apollo cache 中原有的数据，例如上面的 `addTodo` 方法。在这种情况下，可以在写入之前先用 `cache.readQuery` 查询一遍数据。若要给一个已经存在的 object 写一个 fragment，可以传入一个可选参数 `id`，这个参数是相应 object 的 cache 索引。上文我们使用了 `InMemoryCache`，因此索引的形式应当是 `__typename:id`。

`apollo-link-state` 支持异步的 resolver 方法，可以用于执行一些异步的副作用过程，比如访问一些设备的 API。然而，我们不建议在 resolver 中对 REST 端点发请求。正确的方法是使用 `[apollo-link-rest](https://github.com/apollographql/apollo-link-rest)`，这个包里包含有 `@rest` 指令。

### `@client` 指令

当应用的 UI 触发了一个 mutation 之后，Apollo 的网络栈需要知道要更新的数据存在于客户端还是服务器端。`apollo-link-state` 使用 `@client` 指令来标记只需存在于客户端本地的字段，然后，`apollo-link-state` 会在这些字段上调用相应的 resolver 方法。

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

以上这段代码通过 `@client` 指令将数据修改限制在本地。

Query 的形式和 mutation 类似。如果在 query 中使用了异步的查询，Apollo Client 会为你追踪数据加载和出错的状态。如果使用的是 React，可以在组件的 `this.props.data` 中找到相应的数据，里面还会有很多辅助方法，例如重发请求、分页以及轮询等功能。

GraphQL 的一个很让人激动的功能是在单个 query 中向多个数据源请求数据。在下面的例子中，我们在同一条 query 内查询了 GraphQL 服务器中存储的 `user` 数据以及 Apollo cache 中的 `visibilityFilter` 数据。

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

以上代码使用 `@client` 指令查询 Apollo cache。

在我们 [最新的文档页中](https://www.apollographql.com/docs/link/links/state.html)，可以找到更多的例子，以及一些将 `apollo-link-state` 集成在应用中的小贴士。

## 1.0 版本前的路线图

尽管 `apollo-link-state` 的开发已足够稳定，可以投入实际应用的开发了，但仍有一些特性我们希望能尽快实现：

* **客户端数据模式**：当前，我们还不支持对客户端数据模式结构的类型校验，这是因为，如果要将用于运行时构建和校验数据模式的 `graphql-js` 模块放入依赖中，会显著增大网站资源文件的大小。为了避免这点，我们希望能将数据模式的构建转移到项目的构建阶段，从而达到对类型校验的支持，并也可以用到 GraphiQL 中的各种很酷的功能。
* **辅助组件**：我们的目标是让 Apollo 的状态管理尽可能地与应用无缝连接。我们会写一些 React 组件，使得某些常见需求的实现不再繁琐，譬如在代码层面上允许直接将程序中的变量作为参数传递给某个 mutation 当中，然后在内部直接以 mutation 的方式实现。

如果你对上述问题感兴趣，可以在 [GitHub](https://github.com/apollographql/apollo-link-state) 上加入我们的开发和讨论，或者进入 Apollo Slack 的 `#local-state` 频道。欢迎你来和我们一起构建下一代的状态管理方法！


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
