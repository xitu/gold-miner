> * 原文地址：[Immutable Data with Immer and React setState](https://codeburst.io/immutable-data-with-immer-and-react-setstate-887e8f3ad667)
> * 原文作者：[Jason Brown](https://codeburst.io/@browniefed?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/immutable-data-with-immer-and-react-setstate.md](https://github.com/xitu/gold-miner/blob/master/TODO1/immutable-data-with-immer-and-react-setstate.md)
> * 译者：
> * 校对者：

# Immutable Data with Immer and React setState

[Immer](https://github.com/mweststrate/immer) is an incredible new library for JavaScript immutability. In previously libraries like [Immutable.js](https://github.com/facebook/immutable-js) it required whole new methods of operating on your data.

This was great but required complicated adapters and converting back and forth between JSON and Immutable in order to work with other libraries if needed.

Immer simplifies this and you use data and JavaScript objects as your normally would. This means when you need performance and need to know when something changes you can use a triple equal strict equality check and prove that something has indeed changed or not changed.

Your `shouldComponentUpdate` calls are no longer require shallow or deep equals to traverse all the data and compare.

### Screencast of Article

![](https://s1.ax2x.com/2018/09/28/5HELrX.png)

注：此处为截图，原文为视频，建议看英文原文。

### Spread Operator

In latest JavaScript many developers depend on the spread operator `...` to do immutability. For example you can spread the previous object in and override specific keys, or add in new keys. This will use `Object.assign` under the hood and return a new object.

```

const prevObject = {
  id: "12345",
  name: "Jason",
};

const newObject = {
  ...prevObject,
  name: "Jason Brown",
};
```

Our `newObject` will now be a completely different object so any strict equality checking (`prevObject === newObject` ) will be false. So it is indeed creating a new object. The name will no longer just be `Jason` but will be `Jason Brown` and because we didn't do anything with the `id` key it stays the same.

This applies to React in that if you have a nested object on `state` you need to update and spread in the previous object because React will only merge `state` at the base level of keys.

Lets look at an example. Say we have 2 nested counters but we only want to update one and not mess with the other.

```
import React, { Component } from "react";

class App extends Component {
  state = {
    count: {
      counter: 0,
      otherCounter: 5,
    },
  };

  render() {
    return <div className="App">{this.state.count.counter}</div>;
  }
}

export default App;
```

Next in our `componentDidMount` we'll set up an interval and update our nested counter. However we want to preserve the `otherCounter` value so we need to use the spread operator to bring over the previous nested state.

```
componentDidMount() {
    setInterval(() => {
      this.setState(state => {
        return {
          count: {
            ...state.count,
            counter: state.count.counter + 1,
          },
        };
      });
    }, 1000);
  }
```

This is an all too common scenario in React, and if your data is really nested it adds complexity when you need to spread more than one level deep.

### Immer Produce Basic

Immer allows for us to still use the mutations (directly modifying a value) but without actually worrying about managing the number of spreads, or even what data was touched and needs to be immutable.

Lets setup a scenario where you are passing in a value to increase a counter by and additionally have a user object that isn’t going to be touched.

Here we render our app and pass in the increment value.

```
ReactDOM.render(<App increaseCount={5} />, document.getElementById("root"));
```

```
import React, { Component } from "react";

class App extends Component {
  state = {
    count: {
      counter: 0,
    },
    user: {
      name: "Jason Brown",
    },
  };

  componentDidMount() {
    setInterval(() => {}, 1000);
  }

  render() {
    return <div className="App">{this.state.count.counter}</div>;
  }
}

export default App;
```

We setup our app just like before now with a user object and a nested counter.

We’ll import `immer` and name the default import `produce`. As in when given the current state, it'll help us produce the next state.

```
import produce from "immer";
```

Next we’ll create a function called `counter` that takes state and props so we can read the current count and then update with the next count based upon the requested `increaseCount` prop.

```
const counter = (state, props) => {};
```

The produce method of Immer takes a `state` as it's first argument, and a function to mutate your data for the next state as it's second argument.

```
produce(state, draft => {
  draft.count.counter += props.increaseCount;
});
```

Now if we put it all together. We can create a counter function that takes some state and some props and calls the produce function. We then mutate the `draft` of what the next state should look like and the Immer produce function will create a new immutable state for us.

```
const counter = (state, props) => {
  return produce(state, draft => {
    draft.count.counter += props.increaseCount;
  });
};
```

Our updated interval function might look something like this.

```
componentDidMount() {
    setInterval(() => {
      const nextState = counter(this.state, this.props);
      this.setState(nextState);
    }, 1000);
  }
```

However we only touched the `count` and `counter`, what happened to our `user` object? Did that object reference get changed as well? The answer is no. Immer knows exactly what data has been touched. So if we did an strict equality check after the component has been updated we can see that the previous user object and the next user object in state are exactly the same.

```
componentDidUpdate(prevProps, prevState) {
    console.log(this.state.user === prevState.user); // Logs true
  }
```

This is huge for when performance might matter when you use `shouldComponentUpdate` or need an easy way to know if a row has updated for something like `FlatList` in React Native.

### Immer Currying

Immer can make operations even easier. If it sees that you are passing in a function as the first argument instead of an object it will create a curried function for you. So rather than the a new object the `produce` function returns another function.

It will take the first argument when it’s called and use that as the `state` you want to mutate, and then additionally any other arguments will also be passed along.

So rather than a function we could create a counter function and the `props` will be proxied along.

```
const counter = produce((draft, props) => {
  draft.count.counter += props.increaseCount;
});
```

Then because `produce` returned a function we can pass this directly into our `setState` which has the ability to take a function. You should use a functional `setState` when you are referencing your previous state, and in our case we need to reference the previous count to increase it to it's new count. It will pass in the current state and props which is exactly what we've set our `counter` to expect.

So our new interval will just have `this.setState` receiving `counter` which is a function.

```
componentDidMount() {
    setInterval(() => {
      this.setState(counter);
    }, 1000);
  }
```

### Ending

![](https://cdn-images-1.medium.com/max/800/1*zcy1pxsvHOm2bqjkPCaMVw.png)

This is obviously a contrived example but has huge real world applications. Long lists of data where a single field is updated can be easily compared and only the single row updated. Large nested forms only need to update the specific parts that were touched.

You no longer have to do a shallow or deep comparison and can now do a strict equality check and know for certain whether or not your data has actually changed and if you need to re-render.

* * *

_Originally published at_ [_Code_](https://codedaily.io/tutorials/58/Immutable-Data-with-Immer-and-React-setState).

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
