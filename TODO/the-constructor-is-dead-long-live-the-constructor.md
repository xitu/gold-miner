> * 原文地址：[The constructor is dead, long live the constructor!](https://hackernoon.com/the-constructor-is-dead-long-live-the-constructor-c10871bea599)
> * 原文作者：[Donavon West](https://hackernoon.com/@donavon?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/the-constructor-is-dead-long-live-the-constructor.md](https://github.com/xitu/gold-miner/blob/master/TODO/the-constructor-is-dead-long-live-the-constructor.md)
> * 译者：
> * 校对者：

# The constructor is dead, long live the constructor!

## Say goodbye to the medieval class constructor in your React components.

![](https://cdn-images-1.medium.com/max/2000/1*RKQ1VZhf-b7We4YN78xWlA.jpeg)

Photo by [Samuel Zeller](https://unsplash.com/photos/VLioQ2c-VwE?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) on [Unsplash](https://unsplash.com/?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)

While Stateless Function Components (SFCs) are a handy tool in your arsenal, ES6 Class Components are still the de-facto way to write React components that utilizes state or lifecycle hooks.

A hypothetical ES6 Class Component might look something like this (over-simplified without error checking, of course).

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

We initialize our `state` in the `constructor`, asynchronously load our data in `componentDidMount`, and render our `View` component based on the `loading` state. A pretty standard pattern — at least for me, if you’ve been following my work.

### Class properties

We’ve all been taught that the `constructor` is where we initialize our instance properties, `state` in this case. And if you are saying to yourself, “Exactly!”, then you would be absolutely correct… if not for the upcoming ES.next [class properties proposal](https://github.com/tc39/proposal-class-fields), currently in stage 3.

With it we can now define class properties directly, like this.

```
class Foo extends Component {
  state = { loading: true };
  ...
}
```

Babel will transpile your code and add a `constructor` for you behind the scenes. Here is the output from Babel when we transpile the code snippet above.

![](https://cdn-images-1.medium.com/max/800/1*IK4vl_NlOIdCDlFYyizEeQ.png)

Note that Babel is actually passing all args — not just `props` — down to `super`. It is also taking `super`’s return value and passing it back to the caller. Both may be a bit overkill, but exactly what it should be doing.

> There’s still a constructor, you just don’t see it.

### Binding methods

Another reason that we’re taught to use the `constructor` is for binding methods to `this`, like so.

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

Some people ignore this all together by assigning a function expression to a class property, but that’s a different story all-together. Read more about this in my other ES6 React Classes article [**Demystifying Memory Usage using ES6 React Classes**](https://medium.com/@donavon/demystifying-memory-usage-using-es6-react-classes-d9d904bc4557 "https://medium.com/@donavon/demystifying-memory-usage-using-es6-react-classes-d9d904bc4557").

[**Demystifying Memory Usage using ES6 React Classes**](https://medium.com/@donavon/demystifying-memory-usage-using-es6-react-classes-d9d904bc4557)

Let’s assume for a moment that you are in the `bind` camp (and even if you’re not, bear with me). We’ll need to bind in the `constructor`, right? Not necessarily. We can do the same thing that we did for class properties above.

```
class Foo extends Component {
  myHandler = this.myHandler.bind(this);
  myHandler() {
    // some code here that references this
  }
  ...
}
```

### Initializing state with props

What about when you need to derive your initial `state` from `props`, say for initializing a default value? Surely we need the `constructor` for that?

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

Nope! Again, class properties to the rescue! We have access to both `this` and `props`.

```
class Foo extends Component {
  state = {
    color: this.props.initialColor
  };
  ...
}
```

### Data fetching

Maybe we need a `constructor` to fetch data? Hardly. As we saw in our first code sample, any data loading should be done in `componentDidMount`. But why `componentDidMount`? We do it there so that the fetch isn’t performed when running the component on the server — as is the case when doing Server Side Rendering (SSR) — as `componentDidMount` is _not_ performed server side.

### Conclusion

We’ve seen that for setting our initial `state`, we no longer need a `constructor` (or any other instance property for that matter). We also don’t need it for binding methods to `this`. Same for setting initial `state` from `props`. And we would most definitely never fetch data in the `constructor`.

Why then would we ever need the `constructor` in a React component?

Well… you don’t.

_[However… If you find some obscure use case where you need to initialize something in a component, both client-side and server-side, you still have an out. There’s always_ `_componentWillMount_`_. Internally, React calls this hook right after “newing” the class (which calls the_ `_constructor_`_) on both the client and the server.]_

So I maintain that for React components: The constructor is dead, long live the constructor!

* * *

_I also write for the American Express Engineering Blog. Check out my other works and the works of my talented co-workers at_ [_AmericanExpress.io_](http://americanexpress.io/)_. You can also_ [_follow me on Twitter_](https://twitter.com/donavon)_._


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
