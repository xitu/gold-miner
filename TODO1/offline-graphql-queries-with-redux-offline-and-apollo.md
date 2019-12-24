> * 原文地址：[Offline GraphQL Queries with Redux Offline and Apollo](http://www.petecorey.com/blog/2017/07/24/offline-graphql-queries-with-redux-offline-and-apollo/?from=east5th.co)
> * 原文作者：[Pete Corey](http://www.petecorey.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/offline-graphql-queries-with-redux-offline-and-apollo.md](https://github.com/xitu/gold-miner/blob/master/TODO1/offline-graphql-queries-with-redux-offline-and-apollo.md)
> * 译者：[vitoxli](https://github.com/vitoxli)
> * 校对者：[Baddyo](https://github.com/Baddyo)

# 使用 Redux Offline 和 Apollo 进行离线 GraphQL 查询

具有讽刺意味的是，在我们日益连接的世界中，对 web 应用程序离线功能的需求正在不断增长。我们的用户（和客户端）希望在联机、脱机和在连接不稳定的区域使用富互联网应用。

这其实是一件很困难的事情。

让我们深入探讨如何通过 [React](https://facebook.github.io/react/) 和 [Apollo Client](http://www.apollodata.com/) 提供的 [GraphQL data layer](http://graphql.org/) 构建一个功能强大的脱机解决方案。这篇文章将会分为两部分，本周我们将会讨论脱机查询。下周我们将会讨论脱机修改。

## Redux Persist 和 Redux Offline

在底层，[Apollo Client](https://github.com/apollographql/apollo-client) 由 [Redux](http://redux.js.org/) 提供支持。这意味着我们可以在 Apollo 应用程序中使用整个 Redux 生态系统中的工具和库。

在 Redux 离线支持的世界中，有两个主要参与者：Redux Persist 和 Redux Offline。

[Redux Persist](https://github.com/rt2zz/redux-persist) 是一个非常棒但很简单的工具。它被设计用来从 `localStorage` （或者从这些[支持的存储引擎](https://github.com/rt2zz/redux-persist#storage-engines)）中存储和检索（或者说“rehydrate”） redux store。

[Redux Offline](https://github.com/jevakallio/redux-offline) 扩展自 Redux Persist 并添加功能和实用层。Redux Offline 自动检测网络的断开和重新连接，允许您在脱机时将操作排入队列，并在重新连接后自动重试这些操作。

Redux Offline 是离线支持的标配选项。🔋

## 离线查询

开箱即用地，Apollo Client 在部分连接的网络情况下工作得相当好。客户一旦进行查询，该查询的结果就会保存到 Apollo store。

如果[使用 `network only` 以外的任何 `fetchPolicy`](http://dev.apollodata.com/react/api-queries.html#graphql-config-options-fetchPolicy) 再次执行同一查询，则该查询的结果将立即从客户端的 store 中提取出来并返回到查询组件。这意味着，即使我们的客户端与服务器断开连接，重复的查询仍将返回最新的可用结果。

[![](https://s3-us-west-1.amazonaws.com/www.east5th.co/static/reduxoffline.png)](https://github.com/jevakallio/redux-offline)

不幸的是，一旦用户关闭我们的应用，他们的 store 就会丢失。那如何在应用重启的情况下来持久化客户机的 Apollo store 呢？

Redux Offline 正是解决问题的良药！

Apollo store 实际上存在于我们的应用的 Redux store（在 `apollo` key 中）中。通过将整个 Redux store 持久化到 `localStorage` 中，并在每次加载应用程序时重新获取。通过这种方法，[即便在断开网络连接时](https://github.com/jevakallio/redux-offline#progressive-web-apps)，我们也可以通过应用程序重新启动来传递过去查询的结果！

在 Apollo Client 应用程序中使用 Redux Offline 并非不存在问题。让我们看看如何让这两个库协同工作。

### 手动构建一个 Store

通常情况下，建立一个 Apollo client 十分简单：

```javascript
export const client = new ApolloClient({
    networkInterface
});
```

`ApolloClient` 的构造函数将自动为我们创建 Apollo store（并间接创建我们的 Redux store）。我们只需将这个新的 `client` 放入我们的 `ApolloProvider` 组件中：

```javascript
ReactDOM.render(
    <ApolloProvider client={client}>
        <App />
    </ApolloProvider>,
    document.getElementById('root')
);
```

当使用 Redux Offline 时，我们需要手动构造 Redux store，以传入 Redux Offline 的中间件。首先，让我们来重现 Apollo 为我们所做的一切：

```javascript
export const store = createStore(
    combineReducers({ apollo: client.reducer() }),
    undefined,
    applyMiddleware(client.middleware())
);
```

新的 `store` 使用了 Apollo `client` 为我们提供的 reducer 和 middleware，并使用了一个值为 `undefined` 的初始 store 来进行初始化。

我们现在可以把这个 `store` 传入我们的 `ApolloProvider` 中：

```javascript
<ApolloProvider client={client} store={store}>
    <App />
</ApolloProvider>
```

完美。既然我们已经手动创建了 Redux store，我们就可以使用 Redux Offline 来开发支持离线的应用。

### 基础查询持久化

以最简单的形式引入 Redux Offline，包括为我们的 store 添加一个中间件：

```javascript
import { offline } from 'redux-offline';
import config from 'redux-offline/lib/defaults';
```

```javascript
export const store = createStore(
    ...
    compose(
        applyMiddleware(client.middleware()),
        offline(config)
    )
);
```

这个 `offline` 中间件将会自动地把我们的 Redux store 持久化到 `localStorage` 中。

不相信我吗？

启动你的控制台并查看此 `localStorage`：

```javascript
localStorage.getItem("reduxPersist:apollo");
```

你将会看到一个巨大的 JSON blob，它代表着你 Apollo 应用程序的整个当前状态。

[redux_persist_apollo.webm](https://s3-us-west-1.amazonaws.com/www.east5th.co/static/redux_persist_apollo.webm)

太棒啦！

Redux Offline 现在将自动地把 Redux store 的快照保存到 `localStorage` 中。任何时候重新加载应用程序，此状态都将自动从 `localStorage` 中提取并 rehydrate 到你的 Redux store 中。

即使当前应用程序已与服务器断开连接，任何在 store 中使用此方案的查询都将返回该数据。

### Rehydration 竞争的情况

不幸地是，store 的 rehydration 不是即刻完成的。如果我们的应用程序试图在 Redux Offline 取得 store 时进行查询，奇怪的事情就会发生啦。

如果我们打开了 Redux Offline 的 `autoRehydrate` 日志记录（这本身就是一种折磨），我们会在首次加载应用程序时会看到类似的错误：

> 21 actions were fired before rehydration completed. This can be a symptom of a race condition where the rehydrate action may overwrite the previously affected state. Consider running these actions after rehydration: …

Redux Persist 的作者承认了这一点，并已经编写了[一种延迟应用程序的渲染直到完成 rehydration 的方法](https://github.com/rt2zz/redux-persist/blob/master/docs/recipes.md#delay-render-until-rehydration-complete)。不幸的是，他的解决方案依赖于手动调用 `persistStore`，而 Redux Offline 已经默默为我们做了这项工作。

让我们看看其它的解决方法。

我们将会创建一个新的 Redux action，并将其命名为 `REHYDRATE_STORE`，同时我们创建一个对应的 reducer，并在我们的 Redux store 中设置一个值为 `true` 的 `rehydrated` 标志位：

```javascript
export const REHYDRATE_STORE = 'REHYDRATE_STORE';
```

```javascript
export default (state = false, action) => {
    switch (action.type) {
        case REHYDRATE_STORE:
            return true;
        default:
            return state;
    }
};
```

现在让我们把这个新的 reducer 添加到我们的 store 中，并且告诉 Redux Offline 在获取到 store 的时候触发我们的 action：

```javascript
export const store = createStore(
    combineReducers({
        rehydrate: RehydrateReducer,
        apollo: client.reducer()
    }),
    ...,
    compose(
        ...
        offline({
            ...config,
            persistCallback: () => {
                store.dispatch({ type: REHYDRATE_STORE });
            },
            persistOptions: {
                blacklist: ['rehydrate']
            }
        })
    )
);
```

完美。当 Redux Offline 恢复完我们的 store 后，会触发 `persistCallback` 回调函数，这个函数会 dispatch 我们的 `REHYDRATE_STORE` action，并最终更新我们 store 中的 `rehydrate`。

将 `rehydrate` 添加到 Redux Offline 的`黑名单`可以确保我们的 store 永远不会存储到 `localStorage` 或从 `localStorage` 取得我们的 store。

既然我们的 store 能准确地反映是否发生了 rehydration 操作，那么让我们编写一个组件来监听 `rehydrate` 字段，并且只在 `rehydrate` 为 `true` 时对它的 children 进行渲染。

```javascript
class Rehydrated extends Component {
    render() {
        return (
            <div className="rehydrated">
                {this.props.rehydrated ? this.props.children : <Loader />}
            </div>
        );
    }
}

export default connect(state => {
    return {
        rehydrate: state.rehydrate
    };
})(Rehydrate);
```

最后，我们可以用新的 `<Rehydrate>` 组件把 `<App/>` 组件包裹起来，以防止应用程序在 rehydration 之前进行渲染：

```javascript
<ApolloProvider client={client} store={store}>
    <Rehydrated>
        <App />
    </Rehydrated>
</ApolloProvider>
```

哇哦。

现在，我们的应用程序可以愉快地等待 Redux Offline 从 `localStorage` 中完全取得我们的 store，然后继续渲染并进行任何后续的 GraphQL 查询或修改了。

## 注意事项

在配合 Apollo client 使用 Redux Offline 时，需要注意以下这些事项。

首先，需要注意的是本文的示例使用的是 `1.9.0-0` 版本的 `apollo-client` 包。Apollo Client 在 [1.9 版本](https://github.com/apollographql/apollo-client/blob/df42883c3245ba206ddd72a9cffd9a1522eee51c/CHANGELOG.md#v190-0)中引入了修复程序，来解决[与 Redux Offline 同时使用时的一些怪异表现](https://github.com/apollographql/apollo-client/issues/424#issuecomment-316634765)。

与此文相关的另一个需要关注的点是，[Apollo Clinent Devtools](http://dev.apollodata.com/core/devtools.html#Apollo-Client-Devtools) 对 Redux Offline 的支持不太友好。在安装了 Devtools 的情况下使用 Redux Offline 有时会导致意外的错误。

在创建 Apollo `client` 实例时，不连接 Devtools 即可很容易避免这些错误：

```javascript
export const client = new ApolloClient({
    networkInterface,
    connectToDevTools: false
});
```

## 敬请期待

Redux Offline 应该为您的 Apollo 支持的 React 应用程序的查询解析提供基本支持，即使您的应用程序是在与服务器断开连接时重新加载的。

下周我们会进一步探讨如何使用 Redux Offline 处理脱机修改的问题。

敬请期待！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
