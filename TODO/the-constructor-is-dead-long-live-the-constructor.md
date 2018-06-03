> * 原文地址：[The constructor is dead, long live the constructor!](https://hackernoon.com/the-constructor-is-dead-long-live-the-constructor-c10871bea599)
> * 原文作者：[Donavon West](https://hackernoon.com/@donavon?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/the-constructor-is-dead-long-live-the-constructor.md](https://github.com/xitu/gold-miner/blob/master/TODO/the-constructor-is-dead-long-live-the-constructor.md)
> * 译者：[unicar](https://github.com/unicar9)
> * 校对者：[FateZeros](https://github.com/FateZeros), [pot-code](https://github.com/pot-code)

# 构造函数已死，构造函数万岁！


## 向 React 组件里老掉牙的类构造函数（class constructor）说再见


![](https://cdn-images-1.medium.com/max/2000/1*RKQ1VZhf-b7We4YN78xWlA.jpeg)

Photo by [Samuel Zeller](https://unsplash.com/photos/VLioQ2c-VwE?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) on [Unsplash](https://unsplash.com/?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)

尽管无状态函数组件（SFCs）是一件趁手的神兵利器，但 ES6 类组件仍旧是创建 React 组件及其状态和生命周期钩子函数的默认方式。


假设一个 ES6 类组件如下例所示（只展示简化过的部分代码）。


```
class Foo extends Component {
  constructor(props) {
    super(props); 
    this.state = { loading: true };
  }
```

```
  async componentDidMount() {
    const data = await loadStuff();
    this.setState({ loading: false, data });
  }
```

```
  render() {
    const { loading, data } = this.state;
    return (
      {loading ? <Loading /> : <View {...data} />}
    );
  }
}
```

在 `constructor` 中初始化 `state`，并于 `componentDidMount` 中异步加载数据，然后根据 `loading` 的状态来渲染 `View` 这个组件。对我而言这是相当标准的模式，如果你熟悉我之前的代码风格的话。


### 类属性


我们都知道 `constructor` 正是我们初始化实例属性的地方，就像本例中这个 `state` 一样。如果你正胸有成竹地对自己说，『正是如此！』，那么你可说对了……但对于即将问世的 ES.next 类属性提案[class properties proposal](https://github.com/tc39/proposal-class-fields) 而言却并非如此，目前这份提案正处于第三阶段。


按照新的提案来说，我们可以用如下方式直接定义类属性。


```
class Foo extends Component {
  state = { loading: true };
  ...
}
```

Babel 将会在后台转译你的代码并添加上一个 `constructor`。下图是 Babel 将你的代码片段转译过来的结果。


![](https://cdn-images-1.medium.com/max/800/1*IK4vl_NlOIdCDlFYyizEeQ.png)

请注意这里 Babel 实际上是传递了所有参数到 `super` - 不仅仅是 `props`。它也会将 `super` 的返回值传递回调用者。两者虽然感觉有些小题大做，但确实需要这样。


> 此处仍存在构造函数，你只是看不见而已。


### 绑定方法


使用 `constructor` 的另一重原因是将函数绑定到 `this`，如下所示。


```
class Foo extends Component {
  constructor(props) {
    super(props); 
    this.myHandler = this.myHandler.bind(this);
  }
```

```
  myHandler() {
    // some code here that references this
  }
  ...
}
```

但有些人用直接将函数表达式指定给一个类属性的方法完全避免了这个问题，不过这又是另一码事了。想了解更多可以参考我写的其他基于 ES6 类的 React 文章。 [**Demystifying Memory Usage using ES6 React Classes**](https://medium.com/@donavon/demystifying-memory-usage-using-es6-react-classes-d9d904bc4557 "https://medium.com/@donavon/demystifying-memory-usage-using-es6-react-classes-d9d904bc4557").



[**Demystifying Memory Usage using ES6 React Classes**](https://medium.com/@donavon/demystifying-memory-usage-using-es6-react-classes-d9d904bc4557)

那让我们假设一下你隶属 `bind` 阵营（即便不是也烦请耐心看完）。我们还是得需要在 `constructor` 进行绑定对吧？那倒不一定了。我们可以在这里使用和上述处理类属性一样的方法。


```
class Foo extends Component {
  myHandler = this.myHandler.bind(this);
  myHandler() {
    // some code here that references this
  }
  ...
}
```

### 用 props 来初始化状态


那如果你需要从 `props` 中派生出初始 `state`，比方说初始化一个默认值？那这样总该需要使用到 `constructor` 了吧？


```
class Foo extends Component {
  constructor(props) {
    super(props); 
    this.state = {
      color: this.props.initialColor
    };
  }
  render() {
    const { color } = this.state;
    return (
      <div>
       {color}
      </div>
    );
  }
}
```

并不是哦！类属性再次救人于水火！我们可以同时取到 `this` 和 `props`。


```
class Foo extends Component {
  state = {
    color: this.props.initialColor
  };
  ...
}
```

### 获取数据


那也许我们需要 `constructor` 获取数据？基本上不需要。就像我们在第一个代码示例看到的那样，任何数据的加载都应在 `componentDidMount` 里完成。但为何独独在 `componentDidMount`呢？因为这样可以确保在服务器端运行组件时不会执行获取数据 - 服务器端渲染（SSR）同理 — 因为 `componentDidMount` 不会在服务器端执行。

### 结论

综上可以看出，我们不再需要一个 `constructor`（或者其他任何实例属性）来设置初始 `state`。我们也不需要构造函数来把函数绑定到 `this`，以及从 `props` 设置初始的 `state`。同时我们也完全不需要在 `constructor` 里面获取数据。


那为什么我们还需要在 React 组件中使用构造函数呢？

怎么说呢……你还真的不需要

__不过，要是你在某些模棱两可的使用实例里，遇到需要同时从客户端和服务器端在一个组件里初始化什么东西的情况，构造函数仍然是个好的出路。你还有 `componentWillMount` 这个钩子函数可以用。 从内部机制来看，React 在客户端和服务器端都新建好了这个类（即调用构造函数）以后，就会立即调用这个钩子函数。__


所以对 React 组件来说，我坚信这一点：构造函数已死，构造函数万岁！

* * *

_I also write for the American Express Engineering Blog. Check out my other works and the works of my talented co-workers at_ [_AmericanExpress.io_](http://americanexpress.io/)_. You can also_ [_follow me on Twitter_](https://twitter.com/donavon)_._


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
