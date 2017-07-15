
> * 原文地址：[Redux isn't slow, you're just doing it wrong - An optimization guide](http://reactrocket.com/post/react-redux-optimization/)
> * 原文作者：[Julian Krispel](https://twitter.com/juliandoesstuff)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/react-redux-optimization.md](https://github.com/xitu/gold-miner/blob/master/TODO/react-redux-optimization.md)
> * 译者：
> * 校对者：

# Redux isn't slow, you're just doing it wrong - An optimization guide

It's not very obvious how to optimize react applications that use Redux. But it's actually fairly straightforward. Here's a short guide, along with a few examples.

When optimizing applications that use Redux with react, I often hear people saying that Redux is slow. In 99% of cases, the cause for bad performance (this goes for any other framework) is linked to unnecessary rendering, since DOM updates are expensive! In this article, you’ll learn how to avoid unnecessary rendering when using Redux bindings for react.

Typically, to update react components whenever your Redux store updates, we use the [`connect`](https://github.com/reactjs/react-redux/blob/master/docs/api.md#connectmapstatetoprops-mapdispatchtoprops-mergeprops-options) higher order component from the [official react bindings for Redux](https://github.com/reactjs/react-redux). This is a function that wraps your component in another component, which subscribes to changes in the Redux store and renders itself and consequently it’s descendants whenever an update occurs.

## A quick dive into react-redux, the official react bindings for Redux

The `connect` higher order component is actually already optimized. To understand how to best use it it’s best to understand how it works!

Redux, as well as react-redux are actually quite small libraries so the source code isn’t impenetrable. I encourage people to read through the source code, or at least bits of it. If you want to go a step further, write your own implementation, it’ll give you thorough insight into why a library is designed the way it is.

Without further ado, let’s dive a little into how the react bindings work. As we established, the central piece of the react bindings is the `connect` higher order component, this is it’s signature:

    return function connect(
      mapStateToProps,
      mapDispatchToProps,
      mergeProps,
      {
        pure = true,
        areStatesEqual = strictEqual,
        areOwnPropsEqual = shallowEqual,
        areStatePropsEqual = shallowEqual,
        areMergedPropsEqual = shallowEqual,
        ...extraOptions
      } = {}
    ) {
    ...
    }


As a side note - The only mandatory argument is `mapStateToProps` and in most cases you will only need the first two arguments. However, I’m using the signature to here to illustrate how the react bindings work.

All arguments passed into the `connect` function are used to generate an object, which is passed onto the wrapped component as props. `mapStateToProps` is used for mapping the state from your Redux store to an object, `mapDispatchToProps` is used to produce an object containing functions - typically those functions are action creators. Finally `mergeProps` takes three arguments `stateProps`, `dispatchProps` and `ownProps`. The first is the result of `mapStateToProps`, the second the result of `mapDispatchToProps` and the third argument is the props object that is inherited from the component itself. By default `mergeProps` simply combines those arguments into one object, but if you pass in a function for the `mergeProps` argument, `connect` will instead use that to generate the props for the wrapped component.

The fourth argument of the `connect` function is an options object. This contains 5 options: `pure`, which can be either true or false as well as 4 functions (which should return a boolean) that determine whether to re-render the component or not. `pure` is by default set to true. If set to false, the `connect` hoc will skip any optimizations and the 4 functions in the options object will be irrelevant. I personally can’t think of a use-case for that, but the option to set it to false is available if you prefer to turn off optimization.

The object that our `mergeProps` function produces is compared with the last props object. If our `connect` HOC thinks the props object has changed, the component will re-render. To understand how the library decides whether there has been a change we can look at the [`shallowEqual` function](https://github.com/reactjs/react-redux/blob/master/src/utils/shallowEqual.js). If the function returns true, the component won’t re-render, if it returns false it will re-render. `shallowEqual` performs this comparison. Below you’ll see part of the `shallowEqual` method, which tells you all you need to know:

    for (let i = 0; i < keysA.length; i++) {
      if (!hasOwn.call(objB, keysA[i]) ||
          !is(objA[keysA[i]], objB[keysA[i]])) {
        return false
      }
    }


To summarize, this is what the above code does:

It loops over the keys in object a and checks if object B owns the same property. Then it checks if the property (with the same name) from object A equals the one from object B. If only one of the comparisons returns false, the objects will be deemed unequal and a re-render will occur.

This leads us to one golden rule:

## Give your component only the data it needs to render.

This is quite vague, so let’s elaborate with a bunch of practical examples.

### Split up your connected components

I’ve seen people do this. Subscribing a container component to a bunch of state and passing everything down via props.

    const BigComponent = ({ a, b, c, d }) => (
      <div>
        <CompA a={a} />
        <CompB b={b} />
        <CompC c={c} />
      </div>
    );

    const ConnectedBigComponent = connect(
      ({ a, b, c }) => ({ a, b, c })
    );


Now, every time either `a`, `b` or `c` changes, the `BigComponent`, including `CompA`, `CompB` and `CompC` will re-render.

Instead, split up your components and don’t be afraid to make more use of `connect`:


    const ConnectedA = connect(CompA, ({ a }) => ({ a }));
    const ConnectedB = connect(CompB, ({ b }) => ({ b }));
    const ConnectedC = connect(CompC, ({ c }) => ({ c }));

    const BigComponent = () => (
      <div>
        <ConnectedA a={a} />
        <ConnectedB b={b} />
        <ConnectedC c={c} />
      </div>
    );


With this update, `CompA` will only re-render when `a` has changed, `CompB` when `b` has changed, etc. Consider a scenario where each value `a`, `b` and `c` are each updated frequently. For every update, we’re now re-rendering one, instead of all components. This is barely noticeable with three components, but what if you have many more!

### Transform your state to make it as minimal as possible

Here’s a hypothetical (slightly contrived) example:

You have a large list of items, let’s say 300 or more.

    <List>
      {this.props.items.map(({ content, itemId }) => (
        <ListItem
          onClick={selectItem}
          content={content}
          itemId={itemId}
          key={itemId}
        />
      ))}
    </List>


When we click on a List Item, an action gets fired with updates a store value - `selectedItem`. Each list item connects to Redux and gets the `selectedItem`:

    const ListItem = connect(
      ({ selectedItem }) => ({ selectedItem })
    )(SimpleListItem);


We’re doing the right thing, we’re connecting the component only to the state that it needs. However when `selectedItem` gets updated, all the `ListItem` components re-render, because the object we’re returning from `selectedItem` has changed. Before it was `{ selectedItem: 123 }`, now it is `{ selectedItem: 120 }`.

Now bear in mind that we’re using the `selectedItem` value to check whether the current item is selected. So the only thing our component really needs to know is whether it is selected or not - in essence - a `Boolean`. Booleans are great since there are only two possible states, `true` or `false`. So if we return a boolean instead of `selectedItem`, only the two items for which the boolean changes will re-render, which is all we need. `mapStateToProps` actually takes in the components `props` as it’s second argument, we can use that to check whether this is in fact the selected item. Here’s how that’ll look like:

    const ListItem = connect(
      ({ selectedItem }, { itemId }) => ({ isSelected: selectedItem === itemId })
    )(SimpleListItem);


Now whenever our `selectedItem` value changes, only two components re-render - the `ListItem` that is now selected and the one that has been unselected.

### Keep your data flat

The [Redux docs mention this](http://redux.js.org/docs/recipes/reducers/NormalizingStateShape.html) as a best practice. Keeping the shape of your store flat is beneficial for a bunch of reasons. But for the purpose of this article, nesting poses a problem because for our app to be as fast as possible, we want our updates to be as granular as possible. Let’s say we have a nested shape like this:

    {
      articles: [{
        comments: [{
          users: [{
          }]
        }]
      }],
      ...
    }


In order to optimize our `Article`, `Comment` and `User` components, we’ll now need to subscribe all of them to `articles` and then reach deep into this structure to return only the state they need. It makes more sense to instead lay out your shape like so:

    {
      articles: [{
        ...
      }],
      comments: [{
        articleId: ..,
        userId: ...,
        ...
      }],
      users: [{
        ...
      }]
    }


And then select comments and user information with your mapping functions. More about this can be read in the [Redux docs on normalizing state shape](http://redux.js.org/docs/recipes/reducers/NormalizingStateShape.html).

### Bonus: Libraries for selecting Redux state

This is entirely optional and up to you. Generally all the above advice should get you far enough to write fast apps with react and Redux. But there are two excellent libraries that make selecting state a bunch easier:

[Reselect](https://github.com/reactjs/reselect) is a compelling tool for writing `selectors` for your Redux app. From the reselect docs:

- Selectors can compute derived data, allowing Redux to store the minimal possible state.
- Selectors are efficient. A selector is not recomputed unless one of its arguments change.
- Selectors are composable. They can be used as input to other selectors.

For applications with complex interfaces, complex state and/or frequent updates, reselect can help a ton to make your app faster!

[Ramda](http://ramdajs.com/) is a powerful library full of higher order functions. In other words - functions to create functions. Since our mapping functions are just that - functions, we can use Ramda to create our selectors quite conveniently. Ramda can do all that selectors do and more. Checkout the [Ramda cookbook](https://github.com/ramda/ramda/wiki/Cookbook) for some examples of what you can do with Ramda.


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
