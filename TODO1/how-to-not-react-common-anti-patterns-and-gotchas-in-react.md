> * 原文地址：[How to NOT React: Common Anti-Patterns and Gotchas in React](https://codeburst.io/how-to-not-react-common-anti-patterns-and-gotchas-in-react-40141fe0dcd)
> * 原文作者：[NeONBRAND](https://unsplash.com/photos/-Cmz06-0btw?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-not-react-common-anti-patterns-and-gotchas-in-react.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-not-react-common-anti-patterns-and-gotchas-in-react.md)
> * 译者：[MechanicianW](https://github.com/mechanicianw)
> * 校对者：[anxsec](https://github.com/anxsec) [ClarenceC](https://github.com/ClarenceC)

# How to NOT React： React 中常见的反模式与陷阱

什么是反模式？反模式是软件开发中被认为是糟糕的编程实践的特定模式。同样的模式，可能在过去一度被认为是正确的，但是现在开发者们已经发现，从长远来看，它们会造成更多的痛苦和难以追踪的 Bug。

作为一个 UI 库，React 已经成熟，并且随着时间的推移，许多最佳实践也逐渐形成。我们将从数千名开发者集体的智慧中学习，他们曾用笨方法（the hard way）学习这些最佳实践。

![](http://o7ts2uaks.bkt.clouddn.com/1_kD905dFJGIzg7DCjKIqwMw.gif)

此言不虚！

让我们开始吧！

### 1. 组件中的 bind() 与箭头函数

在使用自定义函数作为组件属性之前你必须将你的自定义函数写在 `constructor` 中。如果你是用 `extends` 关键字声明组件的话，自定义函数（如下面的 `updateValue` 函数）会失去 `this` 绑定。因此，如果你想使用 `this.state`，`this.props` 或者 `this.setState`，你还得重新绑定。

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

有两种方法可以将自定义函数绑定到组件的 `this`。一种方法是如上面所做的那样，在 `constructor` 中绑定。另一种方法是在传值的时候作为属性的值进行绑定：

```
<input onChange={this.updateValue.bind(this)} value={this.state.name} />
```

这种方法有一个问题。由于 `.bind()` 每次运行时都会创建一个**函数**，**这种方法会导致每次** `render` **函数执行时都会创建一个新函数。**这会对性能造成一些影响。然而，在小型应用中这可能并不会造成显著影响。随着应用体积变大，差别就会开始显现。[这里](https://medium.com/@esamatti/react-js-pure-render-performance-anti-pattern-fb88c101332f) 有一个案例研究。

箭头函数所涉及的性能问题与 `bind` 相同。

```
<input onChange={ (evt) => this.setState({ name: evt.target.value }) } value={this.state.name} />
```

这种写法明显更清晰。可以看到 prop `onChange` 函数中发生了什么。但是，这也导致了每次 `input` 组件渲染时都会创建一个新的匿名函数。因此，箭头函数有同样的性能弊端。

#### 解决方案

避免上述性能弊端的最佳方法是在函数本身的构造器中进行绑定。这样，在组件创建时仅创建了一个额外函数，即使再次执行 `render` 也会使用该函数。

有一种情况经常发生就是你忘记在构造函数中去 `bind` 你的函数，然后就会收到报错（**Cannot find X on undefined.**）。Babel 有个插件可以让我们使用箭头语法写出自动绑定的函数。插件是 [**Class properties transform**](https://babeljs.io/docs/plugins/transform-class-properties/)。现在你可以这样编写组件：

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

### 2. 在 key prop 中使用索引

遍历元素集合时，key 是必不可少的 prop。key 应该是稳定，唯一，可预测的，这样 React 才能追踪元素。key 是用来帮助 React 轻松调和虚拟 DOM 与真实 DOM 间的差异的。然而，使用某些值集例如数组**索引**，**可能会导致你的应用崩溃或是渲染出错误数据。**

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

#### 解决方案

被使用的 key 应该是：

*   **唯一的**： 元素的 key 在它的兄弟元素中应该是唯一的。没有必要拥有全局唯一的 key。
*   **稳定的**： 元素的 key 不应随着时间，页面刷新或是元素重新排序而变。
*   **可预测的**： 你可以在需要时拿到同样的 key，意思是 key 不应是随机生成的。

数组索引是唯一且可预测的。然而，并不稳定。同样，**随机数或时间戳不应被用作为 key。**

由于随机数既不唯一也不稳定，使用随机数就相当于根本没有使用 key。即使内容没有改变，组件也**会**每次都重新渲染。

时间戳既不稳定也不可预测。**时间戳也会一直递增。**因此每次刷新页面，你都会得到新的时间戳。

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

#### 问题

请注意第 11 行代码。如果你**直接**修改了 state，组件并**不会**重新渲染，修改也不会有任何体现。这是因为 state 是进行[浅比较（shallow compare）](https://stackoverflow.com/questions/36084515/how-does-shallow-compare-work-in-react)的。你应该永远都使用 `setState` 来改变 state 的值。

现在，如果你在 `setState` 中通过当前的 `state` 值来更新至下一个 state （正如第 15 行代码所做的），React **可能不会重新渲染**。这是因为 `state` 和 `props` 是异步更新的。也就是说，DOM 并不会随着 `setState` 被调用就立即更新。React 会将多次更新合并到同一批次进行更新，然后渲染 DOM。查询 `state` 对象时，你可能会收到已经过期的值。[文档](https://reactjs.org/docs/state-and-lifecycle.html#state-updates-may-be-asynchronous)也提到了这一点：

> 由于 `this.props` 和 `this.state` 是异步更新的，你不应该依赖它们的值来计算下一个 state。

另一个问题出现于一个函数中有多次 `setState` 调用时，如第 16 和 20 行代码所示。counter 的初始值是 350。假设 `this.props.increment` 的值是 10。你可能以为在第 16 行代码第一次调用 `setState` 后，counter 的值会变成 350+10 = **360。**并且，当第 20 行代码再次调用 `setState` 时，counter 的值会变成 360+10 = **370**。然而，这并不会发生。第二次调用时所看到的 `counter` 的值仍为 350。**这是因为 setState 是异步的。**counter 的值直到下一个更新周期前都不会发生改变。setState 的执行在[事件循环](https://developer.mozilla.org/en-US/docs/Web/JavaScript/EventLoop)中等待，直到 `updateCounter` 执行完毕前，`setState` 都不会执行， 因此 `state` 的值也不会更新。

#### 解决方案

你应该看看第 27 和 31 行代码使用 `setState` 的方式。以这种方式，你可以给 `setState` 传入一个接收 **currentState** 和 **currentProps** 作为参数的函数。这个函数的返回值会与当前 state 合并以形成新的 state。

#### 延伸阅读

*   [Dan Abramov](https://medium.com/@dan_abramov) 对于为什么 `setState` 是异步的所做的超级棒的[解释](https://github.com/facebook/react/issues/11527)
*   [在 `setState` 中使用函数而不是对象](https://medium.com/@wisecobbler/using-a-function-in-setstate-instead-of-an-object-1f5cfd6e55d1)
*   [Beware： React 的 setState 是异步的！](https://medium.com/@wereHamster/beware-react-setstate-is-asynchronous-ce87ef1a9cf3)

### 4. 初始值中的 props

React 文档提到这也是反模式：

> **在 getInitialState 中使用 props 来生成 state 经常会导致重复的“事实来源”，即真实数据的所在位置。这是因为 getInitialState 仅仅在组件第一次创建时被调用。**

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

#### 问题

`constructor`（getInitialState） **仅仅在组件创建阶段被调用**。也就是说，`constructor` 只被调用一次。因此，当你下一次改变 `props` 时，state 并不会更新，它仍然保持为之前的值。

经验尚浅的开发者经常设想 `props` 的值与 state 是同步的，随着 `props` 改变，`state` 也会随之变化。然而，真实情况并不是这样。

#### 解决方案

如果你需要特定的行为即**你希望 state 仅由 props 的值生成一次**的话，可以使用这种模式。state 将由组件在内部管理。

在另一个场景下，你可以通过生命周期方法 `componentWillReceiveProps` 保持 state 与 props 的同步，如下所示。

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

要注意，关于使用 `componentWillReceiveProps` 有一些注意事项。你可以在[文档](https://reactjs.org/docs/react-component.html#componentwillreceiveprops)中阅读。

最佳方法是使用状态管理库如 Redux 去 [**connect**](https://github.com/reactjs/react-redux) state 和组件。

#### 延伸阅读

*   [初始化 state 中的 props](https://github.com/vasanthk/react-bits/blob/master/anti-patterns/01.props-in-initial-state.md)

### 5. 组件命名

在 React 中，如果你想使用 JSX 渲染你的组件，组件名必须以大写字母开头。

#### Demo

```
<MyComponent>
    <app /> // 不会生效 :(
</MyComponent>

<MyComponent>
    <App /> // 可以生效！
</MyComponent>
```

#### 问题

如果你创建了一个 `app` 组件，以 `<app label="Save" />` 的形式去渲染它，React 将会报错。

![](http://o7ts2uaks.bkt.clouddn.com/1_xCB4cI255tVV41NvIozL7g.png)

使用非大写自定义组件时的警告。

报错表明 `<app>` 是无法识别的。只有 HTML 元素和 SVG 标签可以以小写字母开头。因此 `<div />` 是可以识别的，`<app>` 却不能。

#### 解决方案

你需要确保在 JSX 中使用的自定义组件是以大写字母开头的。

但是也要明白，声明组件无需遵从这一规则。因此，你可以这样写：

```
// 在这里以小写字母开头是可以的
class primaryButton extends Component {
  render() {
    return <div />;
  }
}

export default primaryButton;

// 在另一个文件中引入这个按钮组件。要确保以大写字母开头的名字引入。

import PrimaryButton from 'primaryButton';

<PrimaryButton />
```

#### 延伸阅读

*   [React 陷阱](https://daveceddia.com/react-gotchas/)

以上这些都是 React 中不直观，难以理解也容易出现问题的地方。如果你知道任何其它的反模式，请回复本文。😀

* * *

我还写了一篇 [可以帮助快速开发的优秀 React 和 Redux 包](https://codeburst.io/top-react-and-redux-packages-for-faster-development-5fa0ace42fe7)

- [**可以帮助快速开发的优秀 React 和 Redux 包**： 近些年来 React 越来越受欢迎，随之也出现了许多工具…… codeburst.io](https://codeburst.io/top-react-and-redux-packages-for-faster-development-5fa0ace42fe7)

如果你仍在学习如何构建 React 项目，这个[含有两部分的系列文章](https://codeburst.io/yet-another-beginners-guide-to-setting-up-a-react-project-part-1-bdc8a29aea22) 可以帮助你理解 React 构建系统的多个方面。

- [**又一个 React 初学者指南项目 —— 第一部分**： 过去几年中 React 发展迅猛，已发展成一个成熟的 UI 库）……codeburst.io](https://codeburst.io/yet-another-beginners-guide-to-setting-up-a-react-project-part-1-bdc8a29aea22)

- [**又一个 React 初学者指南项目 —— 第二部分**：我们在第一部分中构建了一个简单的 React 应用。使用 React， React DOM 与 webpack-dev-server 作为项目依赖…… codeburst.io](https://codeburst.io/yet-another-beginners-guide-to-setting-up-a-react-project-part-2-5d3151814333)

* * *

**我写作 JavaScript，Web 开发与计算机科学领域的文章。关注我可以每周阅读新文章。如果你喜欢，可以分享本文。**

**关注我 @** [**Facebook**](https://www.facebook.com/arfat.salman) **@** [**Linkedin**](https://www.linkedin.com/in/arfatsalman/) **@** [**Twitter**](https://twitter.com/salman_arfat)**.**

[![](http://o7ts2uaks.bkt.clouddn.com/1_i3hPOj27LTt0ZPn5TQuhZg.png)](http://bit.ly/codeburst)

> ✉️ **订阅 CodeBurst的每周邮件** [**_Email Blast_**](http://bit.ly/codeburst-email), 🐦可以在[**_Twitter_**](http://bit.ly/codeburst-twitter) 上关注 CodeBurst, 浏览 🗺️ [**_The 2018 Web Developer Roadmap_**](http://bit.ly/2018-web-dev-roadmap), 和 🕸️ [**学习 Web 全栈开发**](http://bit.ly/learn-web-dev-codeburst)。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
