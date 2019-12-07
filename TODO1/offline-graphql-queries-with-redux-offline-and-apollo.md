> * 原文地址：[Offline GraphQL Queries with Redux Offline and Apollo](http://www.petecorey.com/blog/2017/07/24/offline-graphql-queries-with-redux-offline-and-apollo/?from=east5th.co)
> * 原文作者：[Pete Corey](http://www.petecorey.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/offline-graphql-queries-with-redux-offline-and-apollo.md](https://github.com/xitu/gold-miner/blob/master/TODO1/offline-graphql-queries-with-redux-offline-and-apollo.md)
> * 译者：
> * 校对者：

# Offline GraphQL Queries with Redux Offline and Apollo

Ironically, in our ever more connected world, demands for offline capabilities of web applications are growing. Our users (and clients) expect to use rich internet applications while online, offline, and in areas of questionable connectivity.

This can be… difficult.

Let’s dive into how we can build a reasonably powerful offline solution using [React](https://facebook.github.io/react/) and a [GraphQL data layer](http://graphql.org/) powered by [Apollo Client](http://www.apollodata.com/). We’ll split this article into two parts. This week, we’ll discuss offline querying. Next week, we’ll tackle mutations.

## Redux Persist and Redux Offline

Under the hood, [Apollo Client](https://github.com/apollographql/apollo-client) is powered by [Redux](http://redux.js.org/). This means that the entire Redux ecosystem of tools and libraries are available for us to use in our Apollo application.

In the world of Redux offline support, there are two major players: Redux Persist, and Redux Offline.

[Redux Persist](https://github.com/rt2zz/redux-persist) is a fantastic, but bare bones, tool designed to store and retrieve (or “rehydrate”) a redux store to and from `localStorage` (or any other [supported storage engine](https://github.com/rt2zz/redux-persist#storage-engines)).

[Redux Offline](https://github.com/jevakallio/redux-offline) expands on Redux Persist and adds additional layers of functionality and utility. Redux Offline automatically detects network disconnections and reconnections, lets you queue up actions and operations while offline, and automatically retries those actions once reconnected.

Redux Offline is the batteries-included option for offline support. 🔋

## Offline Queries

Out of the box, Apollo Client works fairly well in partially connected network situations. Once a query is made by the client, the results of that query are saved to the Apollo store.

If that same query is made again [with any `fetchPolicy` other than `network-only`](http://dev.apollodata.com/react/api-queries.html#graphql-config-options-fetchPolicy), the results of that query will be immediately pulled from the client’s store and returned to the querying component. This means that even if our client is disconnected from the server, repeated queries will still be resolved with the most recent results available.

[![](https://s3-us-west-1.amazonaws.com/www.east5th.co/static/reduxoffline.png)](https://github.com/jevakallio/redux-offline)

Unfortunately, as soon as a user closes our application, their store is lost. How can we persist the client’s Apollo store through application restarts?

Redux Offline to the rescue!

The Apollo store actually exists within our application’s Redux store (under the `apollo` key). By persisting the entire Redux store to `localStorage`, and rehydrating it every time the application is loaded, we can carry over the results of past queries through application restarts, [even while disconnected from the internet](https://github.com/jevakallio/redux-offline#progressive-web-apps)!

Using Redux Offline with an Apollo Client application doesn’t come without its kinks. Let’s explore how to get these two libraries to work together.

### Manually Building a Store

Normally, setting up an Apollo client is fairly simple:

```javascript
export const client = new ApolloClient({
    networkInterface
});
```

The `ApolloClient` constructor would create our Apollo store (and indirectly, our Redux store) automatically for us. We’d simply drop this new `client` into our `ApolloProvider` component:

```javascript
ReactDOM.render(
    <ApolloProvider client={client}>
        <App />
    </ApolloProvider>,
    document.getElementById('root')
);
```

When using Redux Offline, we’ll need to manually construct our Redux store to pass in our Redux Offline middleware. To start, let’s just recreate what Apollo does for us:

```javascript
export const store = createStore(
    combineReducers({ apollo: client.reducer() }),
    undefined,
    applyMiddleware(client.middleware())
);
```

Our new `store` uses the reducer and middleware provided by our Apollo `client`, and initializes with an initial store value of `undefined`.

We can now pass this `store` into our `ApolloProvider`:

```javascript
<ApolloProvider client={client} store={store}>
    <App />
</ApolloProvider>
```

Perfect. Now that we have control over the creation of our Redux store, we can wire in offline support with Redux Offline.

### Basic Query Persistence

Adding Redux Offline into the mix, in its simplest form, consists of adding a new piece of middleware to our store:

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

Out of the box, this `offline` middleware will automatically start persisting our Redux store into `localStorage`.

Don’t believe me?

Fire up your console and pull up this `localStorage` entry:

```javascript
localStorage.getItem("reduxPersist:apollo");
```

You should be given a massive JSON blob that represents the entire current state of your Apollo application.

[redux_persist_apollo.webm](https://s3-us-west-1.amazonaws.com/www.east5th.co/static/redux_persist_apollo.webm)

Awesome!

Redux Offline is now automatically saving snapshots of our Redux store to `localStorage`. Any time you reload your application, this state will be automatically pulled out of `localStorage` and rehydrated into your Redux store.

Any queries that have resolutions living in this store will return that data, even if the application is currently disconnected from the server.

### Rehydration Race Conditions

Unfortunately, store rehydration isn’t instant. If our application tries to make queries while Redux Offline is rehydrating our store, Strange Things™ can happen.

If we turn on `autoRehydrate` logging within Redux Offline (which is an ordeal in and of itself), we’d see similar errors when we first load our application:

> 21 actions were fired before rehydration completed. This can be a symptom of a race condition where the rehydrate action may overwrite the previously affected state. Consider running these actions after rehydration: …

The creator of Redux Persist acknowledges this and has written [a recipe for delaying the rendering of your application](https://github.com/rt2zz/redux-persist/blob/master/docs/recipes.md#delay-render-until-rehydration-complete) until rehydration has taken place. Unfortunately, his solution relies on manually calling `persistStore`, which Redux Offline does for us behind the scenes.

Let’s come up with another solution.

We’ll start by creating a new Redux action called `REHYDRATE_STORE`, and a corresponding reducer that sets a `rehydrated` flag in our Redux store to `true`:

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

Now let’s add our new reducer to our store and tell Redux Offline to trigger our action when it finishes rehydrating the store:

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

Perfect. When Redux Offline finishes hydrating our store, it’ll trigger the `persistCallback` function, which dispatches our `REHYDRATE_STORE` action, and eventually updates the `rehydrate` field in our store.

Adding `rehydrate` to our Redux Offline `blacklist` ensures that that piece of our store will never be stored to, or rehydrated from `localStorage`.

Now that our store is accurately reflecting whether or not rehydration has happened, let’s write a component that listens for changes to our new `rehydrate` field and only renders its children if `rehydrate` is `true`:

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

Finally, we can wrap our `<App />` component in our new `<Rehydrate>` component to prevent our application from rendering until rehydration has taken place:

```javascript
<ApolloProvider client={client} store={store}>
    <Rehydrated>
        <App />
    </Rehydrated>
</ApolloProvider>
```

Whew.

Now our application will happily wait until Redux Offline has completely rehydrated our store from `localStorage` before continuing on to render and make any subsequent GraphQL queries or mutations.

## Quirks and Notes

There are a few quirks and things to take note of when using Redux Offline with Apollo client.

First, it’s important to note that the examples in this article are using version `1.9.0-0` of the `apollo-client` package. Fixes were introduced to Apollo Client in [version 1.9](https://github.com/apollographql/apollo-client/blob/df42883c3245ba206ddd72a9cffd9a1522eee51c/CHANGELOG.md#v190-0) that resolved some [strange behaviors when combined with Redux Offline](https://github.com/apollographql/apollo-client/issues/424#issuecomment-316634765).

Another oddity related to this setup is that Redux Offline doesn’t seem to play nicely with the [Apollo Client Devtools](http://dev.apollodata.com/core/devtools.html#Apollo-Client-Devtools). Trying to use Redux Offline with the Devtools installed can sometimes lead to unexpected, and seemingly unrelated errors.

These errors can be easily avoided by not connecting to the Devtools when creating your Apollo `client` instance:

```javascript
export const client = new ApolloClient({
    networkInterface,
    connectToDevTools: false
});
```

## Stay Tuned

Redux Offline should give you basic support for query resolution for your Apollo-powered React application, even if your application is re-loaded while disconnected from your server.

Next week we’ll dive into handling offline mutations with Redux Offline.

Stay tuned!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
