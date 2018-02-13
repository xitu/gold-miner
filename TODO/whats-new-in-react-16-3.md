> * 原文地址：[What’s new in React 16.3(.0-alpha)](https://medium.com/@baphemot/whats-new-in-react-16-3-d2c9b7b6193b)
> * 原文作者：[Bartosz Szczeciński](https://medium.com/@baphemot?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/whats-new-in-react-16-3.md](https://github.com/xitu/gold-miner/blob/master/TODO/whats-new-in-react-16-3.md)
> * 译者：
> * 校对者：

# What’s new in React 16.3(.0-alpha)

React 16.3-alpha [just hit npmjs](https://twitter.com/brian_d_vaughn/status/959535914480357376) and can be downloaded and added to your project. What are the biggest, most interesting changes?

> Update 05.02.2018 — I’ve previously made some wrong observation about the `createContext` behavior, this section was updated to reflect the actual behavior of the factory function.

### New context API

Context API was always a thing of mystery — it’s an official, documented React API but at the same time developers warned us not to use it because the API might change with time, and it was missing some documentation on purpose. Well, that time is now — the [RFC phase](https://github.com/reactjs/rfcs/blob/master/text/0002-new-version-of-context.md) has passed and the new API is merged. It is definitely more “user friendly” and might make your life a bit easier when all you want is simple state management without the “overhead” of Redux or MobX.

The new API is accessible as `React.createContext()` and creates two components for us:

![](https://cdn-images-1.medium.com/max/800/1*HgQMzO2N59Z20NeK5ACGzQ.png)

Creation of the new context via React.createContext.

Calling the factory function will return us an object that has a “Provider” and a “Consumer” in it.

The “Provider” is a special component which aims to provide data to all components in its sub-tree, so one example of usage would be:

![](https://cdn-images-1.medium.com/max/800/1*R5GQSLcfedGZiTyoSRDVsg.png)

Usage of the new context API — Context.Provider.

Here we select a sub-tree (in this case, the whole tree) to which we want to pass our “theme” context, and set the value we want to pass. The value can of course be dynamic (e.g. based on `this.state`).

Next step is to use the Consumer:

![](https://cdn-images-1.medium.com/max/800/1*XhcIeUaD1G1rpV0c8MYZvA.png)

Usage of the new context API — Context.Consumer.

If you happen to render the “Consumer” without embeding it in a corresponding “Provider”, the default value declared at `createContext` call will be used.

Please notice some things:

* the consumer must have access to the same Context component — if you were to create a new context, with the same parameter as input, a new Context would be created and the data would not be passed. For this reason please consider Context a component — it should be created once and then exported + imported whenever needed
* the new syntax uses the function as child (sometime called render prop) pattern — if you’re not familiar with this pattern I recommend reading [some articles on it](https://medium.com/merrickchristensen/function-as-child-components-5f3920a9ace9)
* it is no longer required to use `prop-types` to specify `contextProps` if you want to make use of the new Context API

The data from the context passed to the function matches the `value` prop set in the providers `Context.Provider` component, and altering the data in the Provider will cause all consumers to re-render.

### New life-cycle methods

The other [RFC](https://github.com/reactjs/rfcs/blob/master/text/0006-static-lifecycle-methods.md) to make it into the alpha release concerns deprecation of some life-cycle methods and introduction of one (four) new.

This change aims to enforce best practices (you can read up on why those functions can be tricky in [my article on life-cycle methods)](https://medium.com/@baphemot/understanding-reactjs-component-life-cycle-823a640b3e8d) which will be very crucial once the asynchronous rendering mode (which was one of React 16 “Fiber” main goals) will be fully activated.

The functions that will be in time considered deprecation are:

* `componentWillMount` — please use `componentDidMount` instead
* `componentWillUpdate` — please use `componentDidUpdate` instead
* `componentWillReceiveProps` — a new function, `static getDerivedStateFromProps` is introduced

Do not be alarm, you are still able to use those functions — the depracation notices are slotted for 16.4 and removal of them is planned in 17.0

![](https://cdn-images-1.medium.com/max/800/1*x-Sf7tN3BNWuL4SWMGyFTg.png)

Everyone panics. Dan says not to panic. Some people still panic.

You will only see the deprecation notices if you also opt in into the new `StrictMode` or `AsyncMode` in which case you can still suppress them by using:

* `UNSAFE_componentWillMount`
* `UNSAFE_componentWillReceiveProps`
* `UNSAFE_componentWillUpdate`

### static getDerivedStateFromProps

As `componentWillReceiveProps` gets removed, we need some means of updating the state based on props change (not that you should really rely on this pattern!) — the community decided to introduce a new — **static** — method to handle this.

What’s a static method? A static method is a method / function that exists on the **class** not its instance. The easiest difference to think about is that **static** method does not have access to `this` and has the keyword `static` in front of it.

Ok, but if the function has no access to `this` how are we to call `this.setState`? The answer is — we don’t. Instead the function should return the updated state data, or `null` if no update is needed:

![](https://cdn-images-1.medium.com/max/800/1*iIRN5UAvsf-6d84NweGlzQ.png)

Using getDerivedStateFromProps in order to update state.

The returned value behaves similarly to current `setState` value — you only need to return the part of state that changes, all other values will be preserved.

#### Things to keep in mind:

![](https://cdn-images-1.medium.com/max/800/1*xGRcRf9KyVNEm4r_Wt9UMw.png)

Remember to init state!

You still need to declare the initial state of the component (either in constructor or as a class field).

* * *

The function is called both on initial mounting and on re-rendering of the component, so you can use it instead of creating state based on props in constructor.

* * *

![](https://cdn-images-1.medium.com/max/800/1*Wv-6Yyg7Wd5gIIBu2IKH7w.png)

Error, please use just getDerivedStateFromProps.

If you declare both `getDerivedStateFromProps` and `componentWillReceiveProps` only `getDerivedStateFromProps` will be called, and you will see a warning in the console.

* * *

Usually, you would use a callback to make sure some code is called when the state was actually updated — in this case, please use `componentDidUpdate` instead.

* * *

If you prefer not to use the `static` keyword, you can use the alternative syntax:

![](https://cdn-images-1.medium.com/max/800/1*nb9hnMETRb8Nc26ogTlX6A.png)

Declare getDerivedStateFromProps without using static.

### StrictMode

Strict mode is a new way to make sure your code is following the best practices. It’s a component available under `React.StrictMode` and can be added to your application tree or subtree:

![](https://cdn-images-1.medium.com/max/800/1*cT32zSlTdDHMDbNDkpOwdw.png)

Usage of the ‘use strict’ … I mean StrictMode.

If one of the children components, rendered in the `StrictMode` subtree uses some of the method mentioned in previous paragraphs (like `componentWillMount`) you will then see an error message in browser console when running an development build:

![](https://cdn-images-1.medium.com/max/800/1*etTOl69nI0EmND_D68W7xA.png)

Error: unsafe lifecycle in StrictMode subtree.

Currently the error message [points](https://fb.me/react-strict-mode-warnings) to the RFC for the life-cycle methods removal.

### AsyncMode

The not-yet-active async Component support was renamed to be aligned with the `StrictMode` and is now available under `React.unsafe_AsyncMode`. Using it will also activate `StrictMode` warnings.

If you want to learn more about asynchronous components you might check some articles / examples at:

* [https://build-mbfootjxoo.now.sh/](https://build-mbfootjxoo.now.sh/)
* [https://github.com/koba04/react-fiber-resources](https://github.com/koba04/react-fiber-resources)

### New version of React Developer Tools

Additionally, a new version of the Developer Tools was released to support debugging the new components.

If you’re using Chrome — you might need to wait a bit more, as it’s not updated yet in the store, and trying to debug results in … interesting results:

![](https://cdn-images-1.medium.com/max/800/0*VzzTmbTx7dmzll94.png)

React. __SECRET_INTERNALS_DO_NOT_USE_OR_YOU_WILL_BE_FIRED is still better.

Firefox users should be able to make use of the new features already:

![](https://cdn-images-1.medium.com/max/800/1*DN9BX9MC4xDjdXKKAAAf7Q.png)

New AsyncComponent is visible in the Firefox Developer Tools.

### More to come?

Please keep in mind that this is an alpha release and the stable 16.3 might have more / fewer changes. That said, according to Dan, 16.3 should be released “sometime nex week”:

![](https://cdn-images-1.medium.com/max/800/1*JE0fFrRpCmzCaG-hVEZWpA.png)

Last’s week next week is this week.


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
