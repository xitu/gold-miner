> * 原文地址：[How to NOT React: Common Anti-Patterns and Gotchas in React](https://codeburst.io/how-to-not-react-common-anti-patterns-and-gotchas-in-react-40141fe0dcd)
> * 原文作者：[NeONBRAND](https://unsplash.com/photos/-Cmz06-0btw?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-not-react-common-anti-patterns-and-gotchas-in-react.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-not-react-common-anti-patterns-and-gotchas-in-react.md)
> * 译者：[MechanicianW](https://github.com/mechanicianw)
> * 校对者：

# How to NOT React: Common Anti-Patterns and Gotchas in React

什么是反模式？反模式是软件开发中被认为是糟糕的编程实践的特定模式。同样的模式，可能在过去一度被认为是正确的，但是现在开发者们已经发现，从长远来看，它们会造成更多的痛苦和难以追踪的 Bug。

作为一个 UI 库，React 已经成熟，并且随着时间的推移，许多最佳实践也逐渐形成。我们将从数千名开发者集体的智慧中学习，他们曾用笨方法（the hard way）学习这些最佳实践。

![](http://o7ts2uaks.bkt.clouddn.com/1_kD905dFJGIzg7DCjKIqwMw.gif)

此言不虚！

让我们开始吧！

### 1. 组件中的 bind() 与箭头函数

你一定做过，在把自定义函数作为 props 传给组件之前，就在 `constructor` 函数中绑定了自定义函数。如果你是用 `extends` 关键字声明组件的话，自定义函数（如下面的 `updateValue` 函数）会失去 `this` 绑定。因此，如果你想使用 `this.state`，`this.props` 或者 `this.setState`，你还得重新绑定。

#### Demo

```
class app extends Component {
  constructor(props) {
    super(props);
    this.state = {
      name: ''
    };
    this.updateValue = this.updateValue.bind(this);
  }

updateValue(evt) {
    this.setState({
      name: evt.target.value
    });
  }

render() {
    return (
      <form>
        <input onChange={this.updateValue} value={this.state.name} />
      </form>
    )
  }
}
```

#### 问题

有两种方法可以将自定义函数绑定到组件的 `this`。一种方法是如上面所做的那样，在 `constructor` 中绑定。另一种方法是在将自定义函数作为 prop 值传递时绑定：

```
<input onChange={this.updateValue.bind(this)} value={this.state.name} />
```

这种方法有一个问题。由于 `.bind()` 每次运行时都会创建一个**函数**，**这种方法会导致每次** `render` **函数执行时都会创建一个新函数。**这会对性能造成一些影响。然而，在小型应用中这可能并不会造成显著影响。随着应用体积变大，差别就会开始显现。[这里](https://medium.com/@esamatti/react-js-pure-render-performance-anti-pattern-fb88c101332f) 有一个案例研究。

箭头函数所涉及的性能问题与 `bind` 相同。

```
<input onChange={ (evt) => this.setState({ name: evt.target.value }) } value={this.state.name} />
```

这种写法明显更清晰。可以看到 prop `onChange` 函数中发生了什么。但是，这也导致了每次 `input` 组件渲染时都会创建一个新的匿名函数。因此，箭头函数有同样的性能弊端。

#### 解决

避免上述性能弊端的最佳方法是在函数本身的构造器中进行绑定。这样，在组件创建时仅创建了一个额外函数，即使再次执行 `render` 也会使用该函数。

经常发生忘记在构造器中 `bind` 函数这种情况，然后就会收到报错（**Cannot find X on undefined.**）。Babel 有个插件可以让我们使用箭头语法写出自动绑定的函数。插件是 [**Class properties transform**](https://babeljs.io/docs/plugins/transform-class-properties/)。现在你可以这样编写组件：

```
class App extends Component {
  constructor(props) {
    super(props);
    this.state = {
      name: ''
    };

// 看！无需在此处进行函数绑定！

}
updateValue = (evt) => {
    this.setState({
      name: evt.target.value
    });
  }

render() {
    return (
      <form>
        <input onChange={this.updateValue} value={this.state.name} />
      </form>
    )
  }
}
```

#### 延伸阅读

*   [React 绑定模式： 5 个处理 `this` 的方法](https://medium.freecodecamp.org/react-binding-patterns-5-approaches-for-handling-this-92c651b5af56)
*   [React.js pure render 性能反模式](https://medium.com/@esamatti/react-js-pure-render-performance-anti-pattern-fb88c101332f)
*   [React —— 绑定还是不绑定](https://medium.com/shoutem/react-to-bind-or-not-to-bind-7bf58327e22a)
*   [在 React component classes 中绑定函数的原因及方法](http://reactkungfu.com/2015/07/why-and-how-to-bind-methods-in-your-react-component-classes/)

### 2. 在 key Prop 中使用索引

遍历元素集合时，Key 是必不可少的 prop。Key 应该是稳定，唯一，可预测的，这样 React 才能追踪元素。Key 是用来帮助 React 轻松调和虚拟 Dom 与真实 Dom 间的差异的。然而，使用某些值集例如数组**索引**，**可能会导致你的应用崩溃或是渲染出错误数据。**

#### Demo

```
{elements.map((element, index) =>
    <Display
       {...element}
       key={index}
       />
   )
}
```

#### 问题

当子元素有了 key，React 就会使用 key 来匹配原始树结构和后续树结构中的子元素。**key 被用于作身份标识。**如果两个元素有同样的 key，React 就会认为它们是相同的。当 key 冲突了，即超过两个元素具有同样的 key，React 就会抛出警告。

![](http://o7ts2uaks.bkt.clouddn.com/1_3C-F1fs7E5fK9R8XlLk62g.png)

警告出现重复的 key。

[这里](https://reactjs.org/redirect-to-codepen/reconciliation/index-used-as-key) 是 CodePen 上使用索引作为 key 可能导致的问题的一个示例。

#### 解决

被使用的 key 应该是：

*   **唯一的**： 元素的 key 在它的兄弟元素中应该是唯一的。没有必要拥有全局唯一的 key。
*   **稳定的**： 元素的 key 不应随着时间，页面刷新或是元素重新排序而变。
*   **可预测的**： 你可以在需要时拿到同样的 key，意思是 key 不应是随机生成的。

数组索引是唯一且可预测的。然而，并不稳定。同样，**随机数或时间戳不应被用作为 key。**

由于随机数既不唯一也不稳定，使用随机数就相当于根本没有使用 key。即使内容没有改变，组件也**会**每次都重新渲染。

时间戳即不稳定也不可预测。**时间戳也会一直递增。**因此每次刷新页面，你都会得到新的时间戳。

通常，你应该依赖于数据库生成的 ID 如关系数据库的主键，Mongo 中的对象 ID。如果数据库 ID 不可用，你可以生成内容的哈希值来作为 key。关于哈希值的更多内容可以在[这里](https://en.wikipedia.org/wiki/Hash_function)阅读。

#### 延伸阅读

*   [将索引作为 key 是一种反模式](https://medium.com/@robinpokorny/index-as-a-key-is-an-anti-pattern-e0349aece318)
*   [React 中集合为何需要 key](https://paulgray.net/keys-in-react/)
*   [为何你不应该使用随机数作为 key](https://github.com/facebook/react/issues/1342#issuecomment-39230939).

### 3. setState() 是异步的

React 组件主要由三部分组成：`state`，`props` 和标记（或其它组件）。props 是不可变的，state 是可变的。state 的改变会导致组件重新渲染。如果 state 是由组件在内部管理的，则使用 `this.setState` 来更新 state。关于这个函数有几件重要的事需要注意。我们来看看：

#### Demo

```
class MyComponent extends Component {
  constructor(props) {
    super(props);
    this.state = {
      counter: 350
    };
  }

  updateCounter() {
    // 这行代码不会生效
    this.state.counter = this.state.counter + this.props.increment;

    // ---------------------------------

    // 不会如预期生效
    this.setState({
      counter: this.state.counter + this.props.increment; // 可能不会渲染
    });

    this.setState({
      counter: this.state.counter + this.props.increment; // this.state.counter 的值是什么？
    });

    // ---------------------------------

    // 如期生效
    this.setState((prevState, props) => ({
      counter: prevState.counter + props.increment
    }));

    this.setState((prevState, props) => ({
      counter: prevState.counter + props.increment
    }));
  }
}
```

#### Problems

Focus on line 11. If you mutate the state _directly,_ the component will **not** be re-rendered and the changes will not be reflected. This is because the state is compared [shallowly](https://stackoverflow.com/questions/36084515/how-does-shallow-compare-work-in-react). You should always use `setState` for changing the value of the state.

Now, in `setState` if you use the value of current `state` to update to the next state (as done in line 15), React **may or may not** **re-render**. This is because, `state` and `props` are updated asynchronously. That is, the DOM is not updated as soon as `setState` is invoked. Rather, React batches multiple updates into one update and then renders the DOM. You may receive outdated values while querying the `state` object. The [docs](https://reactjs.org/docs/state-and-lifecycle.html#state-updates-may-be-asynchronous) also mention this —

> Because `this.props` and `this.state` may be updated asynchronously, you should not rely on their values for calculating the next state.

Another problem is when you have multiple `setState` calls in a single function, as shown above on line 16 and 20. Initial value of the counter is 350. Assume the value of `this.props.increment` is 10. You might think that after the first `setState` invocation on line 16, the counter’s value will change to 350+10 = **360.** And, when the next `setState` is called on line 20, the counter’s value will change to 360+10 = **370**. However, this does not happen. The second call still sees the value of `counter` as 350. **This is because setState is async**. The counter’s value does not change until the next update cycle. The execution of setState is waiting in the [event loop](https://developer.mozilla.org/en-US/docs/Web/JavaScript/EventLoop) and until `updateCounter` finishes execution, `setState` won’t run and hence won’t update the `state`.

#### Solution

You should use the other form of `setState` as done on line 27 and 31. In this form, you can pass a function to `setState` which receives _currentState_ and _currentProps_ as arguments. The return value of this function is merged in with the existing state to form the new state.

#### Read More —

*   A wonderful [explanation](https://github.com/facebook/react/issues/11527) of why `setState` is async by [Dan Abramov](https://medium.com/@dan_abramov).
*   [Using a function in `setState` instead of an object](https://medium.com/@wisecobbler/using-a-function-in-setstate-instead-of-an-object-1f5cfd6e55d1)
*   [Beware: React setState is asynchronous!](https://medium.com/@wereHamster/beware-react-setstate-is-asynchronous-ce87ef1a9cf3)

### 4. Props in Initial State

The React docs mention this anti-pattern as —

> _Using props to generate state in_ getInitialState _often leads to duplication of “source of truth”, i.e. where the real data is. This is because getInitialState is only invoked when the component is first created._

#### Demo

```
import React, { Component } from 'react'

class MyComponent extends Component {
  constructor(props){
    super(props);
    this.state = {
      someValue: props.someValue,
    };
  }
}
```

#### Problems

The `constructor` or (getInitialState) is called **only at the time of component creation**. That is, `constructor` is invoked only once. Hence, when you change the `props` next time, the state won’t be updated and will retain its previous value.

Young developers often assume that the `props` values will be in sync with the state, and as `props` change, the `state` will reflect those values. However, that is not true.

#### Solutions

You can use this pattern if you want a specific behaviour. That is, **you want the state to be _seeded_ by the values of props only once**. The state will be managed internally by the component.

In other cases, you can use `componentWillReceiveProps` lifecycle method to keep the state and props in sync, as shown here.

```
import React, { Component } from 'react'

class MyComponent extends Component {
  constructor(props){
    super(props);
    this.state = {
      someValue: props.someValue,
    };
  }

  componentWillReceiveProps(nextProps){
    if (nextProps.inputValue !== this.props.inputValue) {
      this.setState({ inputVal: nextProps.inputValue })
    }
  }
}
```

Beware that using `componentWillReceiveProps` has it own caveats. You can read about it the [Docs](https://reactjs.org/docs/react-component.html#componentwillreceiveprops).

The best approach would be to use a state management library such as Redux to [_connect_](https://github.com/reactjs/react-redux) the state and the component.

#### Read More —

*   [Props in Initial State](https://github.com/vasanthk/react-bits/blob/master/anti-patterns/01.props-in-initial-state.md)

### 5. Components Name

In React, if you are rendering your component using JSX, the name of that component has to begin with with a capital letter.

#### Demo

```
<MyComponent>
    <app /> // Will not work :(
</MyComponent>

<MyComponent>
    <App /> // Will work!
</MyComponent>
```

#### Problems

If you create a component `app` and render it using JSX as `<app label="Save" />`, React will throw an error.

![](https://cdn-images-1.medium.com/max/1000/1*xCB4cI255tVV41NvIozL7g.png)

Warning when using non-capitalised custom components.

The error says that `<app>` is not recognised. Only HTML elements and SVG tags can begin with a lowercase. Hence, `<div />` is okay but `<app>` is not.

#### Solution

You need to make sure that while using custom component in JSX, it ashould begin with a capital letter.

But, also understand that declaring components does not adhere to this rule. Hence, you can do this —

```
// Here lowercase is fine.
class primaryButton extends Component {
  render() {
    return <div />;
  }
}

export default primaryButton;

// In a different file, import the button. However, make sure to give a name starting with capital letter.

import PrimaryButton from 'primaryButton';

<PrimaryButton />
```

#### Read More —

*   [React Gotchas](https://daveceddia.com/react-gotchas/)

These were some unintuitive hard-to-understand bug-makers in React. If you know about any other anti-pattern, respond to this article. 😀

* * *

I have also written [Top React and Redux Packages for Faster Development](https://codeburst.io/top-react-and-redux-packages-for-faster-development-5fa0ace42fe7)

- [**Top React and Redux Packages for Faster Development**: React has grown in popularity over the last few years. With that, a lot of tools have emerged that make developer’s… codeburst.io](https://codeburst.io/top-react-and-redux-packages-for-faster-development-5fa0ace42fe7)

If you are still learning how to setup a React Project, this [two-part series](https://codeburst.io/yet-another-beginners-guide-to-setting-up-a-react-project-part-1-bdc8a29aea22) might be helpful in understanding various aspects of React build system.

- [**Yet another Beginner’s Guide to setting up a React Project — Part 1**: React has gained considerable momentum in the last few years and has turned into a mature and stable UI library. It has… codeburst.io](https://codeburst.io/yet-another-beginners-guide-to-setting-up-a-react-project-part-1-bdc8a29aea22)

- [**Yet another Beginner’s Guide to setting up a React Project — Part 2**: We set up a simple React App in Part 1\. We used React, React DOM and webpack-dev-server as our dependencies. We will… codeburst.io](https://codeburst.io/yet-another-beginners-guide-to-setting-up-a-react-project-part-2-5d3151814333)

* * *

**I write about JavaScript, web development, and Computer Science. Follow me for weekly articles. Share this article if you like it.**

**Reach out to me on @** [**Facebook**](https://www.facebook.com/arfat.salman) **@** [**Linkedin**](https://www.linkedin.com/in/arfatsalman/) **@** [**Twitter**](https://twitter.com/salman_arfat)**.**

[![](https://cdn-images-1.medium.com/max/1000/1*i3hPOj27LTt0ZPn5TQuhZg.png)](http://bit.ly/codeburst)

> ✉️ _Subscribe to_ CodeBurst’s _once-weekly_ [**_Email Blast_**](http://bit.ly/codeburst-email)**_,_ **🐦 _Follow_ CodeBurst _on_ [**_Twitter_**](http://bit.ly/codeburst-twitter)_, view_ 🗺️ [**_The 2018 Web Developer Roadmap_**](http://bit.ly/2018-web-dev-roadmap)_, and_ 🕸️ [**_Learn Full Stack Web Development_**](http://bit.ly/learn-web-dev-codeburst)_._


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
