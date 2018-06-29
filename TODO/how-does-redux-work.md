> * 原文地址：[How Redux Works: A Counter-Example](https://daveceddia.com/how-does-redux-work/)
> * 原文作者：[Dave Ceddia](https://daveceddia.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/how-does-redux-work.md](https://github.com/xitu/gold-miner/blob/master/TODO/how-does-redux-work.md)
> * 译者：[hexianga](https://github.com/hexianga)
> * 校对者：[薛定谔的猫](https://github.com/Aladdin-ADD)，[guoyang](https://github.com/gy134340)

# Redux 的工作过程: 一个计数器例子

在学习了一些 React 后开始学习 Redux，Redux 的工作过程让人感到很困惑。

Actions，reducers，action creators（Action 创建函数），middleware（中间件），pure functions（纯函数），immutability（不变性）…

这些术语看起来非常陌生。

所以在这篇文章中我将用一种有利于大家理解的反向剖析的方法去揭开 Redux **怎样**工作的神秘面纱。在 [上一篇](https://daveceddia.com/what-does-redux-do/) 中，在提出专业术语之前我将尝试用简单易懂的语言去解释 Redux。

如果你还不明确 **Redux 是干什么的** 或者为什么要使用它，请先移步 [这篇文章](https://daveceddia.com/what-does-redux-do/) 然后再回到这里继续阅读。

## 第一：明白 React 的状态 state

我们将从一个简单的使用 React 状态的例子开始，然后一点一点地添加Redux。

这是一个计数器：

![计数器组件](https://daveceddia.com/images/counter-plain.png)

这里是代码 (为了使代码简单我没有贴出 CSS 代码，所以下面代码的效果会不会像上面图片一样美观)：

```
import React from 'react';

class Counter extends React.Component {
  state = { count: 0 }

  increment = () => {
    this.setState({
      count: this.state.count + 1
    });
  }

  decrement = () => {
    this.setState({
      count: this.state.count - 1
    });
  }

  render() {
    return (
      <div>
        <h2>Counter</h2>
        <div>
          <button onClick={this.decrement}>-</button>
          <span>{this.state.count}</span>
          <button onClick={this.increment}>+</button>
        </div>
      </div>
    )
  }
}

export default Counter;
```

简单的看一下他是怎样跑起来的：

* 这个 `count` 状态被存储在最外层组件 `Counter` 里面
* 当用户点击 “+”，这个按钮的 `onClick` 回调函数被触发, 也就是组件 `Counter` 里面的 `increment` 方法被调用。
*  `increment` 方法用新的数字更新状态 count。
* 由于状态被改变了, React 重新渲染 `Counter` 组件 (还有它的子组件), 然后显示新的计数器的值.

如果你想要了解更多的状态怎么被改变的细节，去阅读 [React 中状态的图形化指南](https://daveceddia.com/visual-guide-to-state-in-react/) 然后再回到这里。严格来讲：如果上面的例子没有帮助你回顾起 React 的 state ，那么在你学习 Redux 之前应该去学习 React 的 state 是怎么工作的。

#### 快速开始

如果你想通过代码学习，现在就创建一个项目:

* 如果你之前没有安装 create-react-app ，那么先安装 (`npm install -g create-react-app`)
* 创建一个项目: `create-react-app redux-intro`
* 打开 `src/index.js` 然后用下面的代码进行替换:

```
import React from 'react';
import { render } from 'react-dom';
import Counter from './Counter';

const App = () => (
  <div>
    <Counter />
  </div>
);

render(<App />, document.getElementById('root'));
```

* 用上面的计数器代码创建一个 `src/Counter.js` 

## 现在: 添加 Redux

在 [第一部分中讨论到](https://daveceddia.com/what-does-redux-do/)，Redux 保存应用程序的状态 **state** 在单一的状态树 **store**中。然后你可以将 state 的部分抽离出来，然后以 props 的方式传入组件。这使你可以把数据保存在一个全局的位置（状态树 store ）然后将其注入到应用程序中的**任何一个**组件中，而不用通过多层级的属性传递。

注意：你可能经常看到 “state” 和 “store” 混着使用，但是严格来讲： **state**是数据，而 **store** 是数据保存的地方。

我们接着往下走，利用你的编辑器继续编辑我们下面的代码，它将帮助你理解 Redux 怎么工作（我们通过讲解一些错误来继续）。

添加 Redux 到你的项目中:

```
$ yarn add redux react-redux
```

#### redux vs react-redux

等等 — 这是两个库吗？你可能会问 “react-redux 是什么”？对不起，我一直在骗你。

你看，`redux` 给了你一个状态树 store，让你可以把状态 state 存在里面，然后可以把状态取出来，当状态改变的时候可以做出响应。然而这是他它做的所有事。实际上正是 `react-redux` 将 state 与 React 组件联系起来。实际上：`redux` 和 React **一点儿也没有**关系。

这些库就像豌豆荚里面的两粒豌豆，99.999% 的时候当有人在 React 的背景下提到 “Redux” 的时候，他们指的是这两个库。所以记住：当你在 StackOverflow 或者 Reddit 或者[其它任何地方](https://daveceddia.com/keeping-up-with-javascript/)看到 Redux 时，他指的是这两个库。

## 最后一件事

大多数教程一开始就创建一个 store 状态树，设置 Redux，写一个 reducer，等等，出现在屏幕上的任何效果在展现出来之前都会经过大量的操作。 

我将采用一种反向推导的方法，使用同样多的代码展现出同样的效果。但是希望每一个步骤后面的原理都能展现地更加清楚。

回到计数器的应用程序，我们把组件的状态转移到 Redux。

我们把状态从组件里面移除，因为我们很快可以从 Redux 中获取它们：

```
import React from 'react';

class Counter extends React.Component {
  increment = () => {
    // 后面填充
  }

  decrement = () => {
    // 后面填充
  }

  render() {
    return (
      <div>
        <h2>Counter</h2>
        <div>
          <button onClick={this.decrement}>-</button>
          <span>{this.props.count}</span>
          <button onClick={this.increment}>+</button>
        </div>
      </div>
    )
  }
}

export default Counter;
```

## 计数器的流程

我们注意到 `{this.state.count}` 改变成了 `{this.props.count}`。当然这不会起作用，因为计数器组件还没有接受 `count` 属性，我们通过 Redux 注入这个属性。

为了从 Redux 中获得状态 count，我们需要在模块的顶部导入 `connect` 方法：

```
import { connect } from 'react-redux';
```

然后接下来我们需要 “connect” 计数器组件到 Redux 中：

```
// 添加这个函数：
function mapStateToProps(state) {
  return {
    count: state.count
  };
}

// 然后这样替换：
// 默认导出计数器组件；

// 这样导出：
export default connect(mapStateToProps)(Counter);
```

这将发生错误 (在第二部分会有更多错误)。

以前我们导出函数本身，现在我们把它用 `connect` 函数包装后调用。

#### 什么是 `connect`？

你可能注意到这个函数调用看起来有一些奇怪。为什么是 `connect(mapStateToProps)(Counter)` 而不是 `connect(mapStateToProps, Counter)` 或者 `connect(Counter, mapStateToProps)`？这将发生什么呢？

之所以这样写是因为 `connect` 是一个**高阶函数**，当你调用它的时候会返回一个函数，然后用一个组件做参数调用**那个函数**返回一个新的包装过的组件。

返回的组件另一个名字叫做[高阶组件](https://daveceddia.com/extract-state-with-higher-order-components/) (又叫做 “HOC”)。高阶组件被指责有很多的缺点，但是他们仍然非常有用，`connect` 就是一个很好的例子。

`connect` 连接整个状态到了Redux，通过你自己提供的 `mapStateToProps` 函数， 这需要一个自定义的函数因为只有你自己知道状态在 Redux 中的模型。

`connect` 连接了所有的状态，“嘿，告诉我你需要从混乱的状态中得到什么”。

从 `mapStateToProps` 函数中返回的状态作为属性注入到你的组件中。上面例子中的 `state.count` 作为 `count` 属性：对象中的键名作为属性名，它们对应的值作为属性的值。所以你看，从函数的字面意思上是**定义了状态到属性的映射**。

## 错误意味着有进展!

代码进行到这里，你会在控制台里面看到下面的错误：

> Could not find “store” in either the context or props of “Connect(Counter)”. Either wrap the root component in a <provider>, or explicitly pass "store" as a prop to "Connect(Counter)".</provider>

因为 `connect` 从 Redux store 树里面获取状态，而我们还没有创建状态树或者说告诉 app 怎样去找到 store 树，这是一个合乎逻辑的错误，Redux 还不知道现在发生了什么事。

## 提供一个状态树 store

Redux 控制着整个 app 的全部状态，通过 `react-redux` 里面的 `Provider` 组件包裹着整个 app，app 里面的**每一个组件**都可以通过 `connect` 去进入到 Redux store 里面获取状态。

这意味着最外围的 `App` 组件，以及 `App` 的子组件（像 `Counter`），甚至他们子组件的子组件等等，所有的组件都可以访问状态树 store，只要把他们通过 `connect` 函数调用。

我不是说要把每一个组件都用 `connect` 函数调用，那是一个很糟糕的做法(设计混乱而且太慢了)。

`Provider` 看起来很具有魔性，实际上在挂载的时候使用了 React 的 “context” 特性。

 `Provider` 就像一个秘密通道连接到了每一个组件，使用 `connect` 打开了通向每一个组件的大门。

想象一下，把糖浆倒在一堆煎饼上，假如你只把糖浆倒在了最上面的煎饼上，怎么才能让所有的煎饼都能蘸到糖浆呢。 `Provider` 为 Redux 做了这件事。 

在文件 `src/index.js`中，导入 `Provider` 组件并且用它来包裹 `App` 组件的内容。

```
import { Provider } from 'react-redux';
...

const App = () => (
  <Provider>
    <Counter/>
  </Provider>
);
```

我们仍然会遇到报错，因为 `Provider` 需要一个 store 状态树才能起作用，它会把 store 作为属性，所以我们首先需要创建一个 store。

## 创建一个 store

Redux 使用一个方便的函数来创建 stores，这个函数就是 `createStore`。好了，现在让我们来创建一个 store 然后把它作为属性传入 Provider 组件：

```
import { createStore } from 'redux';

const store = createStore();

const App = () => (
  <Provider store={store}>
    <Counter/>
  </Provider>
);
```

又产生了另外一个不同的错误：

> Expected the reducer to be a function.

现在是 Redux 的问题了，Redux 不是那么的智能，你可能希望创建一个 store，它就会从 store 中 给你一个中很好的默认的值，哪怕是一个空对象？

但是绝不会这样，Redux 不会对你的状态的组成做出任何的猜测，状态的组成结构完全取决于你自己。他可以是一个对象, 一个数字, 一个字符串, 或者是你需要的任何形式。所以我们必须提供一个函数去返回这个状态，这个函数就叫做**reducer**(后面会解释为什么这么命名)。让我们来看看函数最简单的情况，将它作为函数 `createStore` 的参数，看看会发生什么：

```
function reducer() {
  // just gonna leave this blank for now
  // which is the same as `return undefined;`
}

const store = createStore(reducer);
```

## Reducer 必须要有返回值

又产生了另外的错误：

> Cannot read property ‘count’ of undefined

产生这个错误是因为我们试图去取得 `state.count`，但是 `state` 却没有定义。Redux 希望 `reducer` 函数为 `state`  返回一个值，而不是返回一个 `undefined`。

reducer 函数应该返回一个状态，实际上它应该用利用**当前状态**去返回**新的状态**。

让我们用 reducer 函数去返回满足我们需要的状态形式：一个含有 `count` 属性的对象。

```
function reducer() {
  return {
    count: 42
  };
}
```

嘿！这个 count 现在显示为 “42”，神奇吧。

只是有一个问题：count 一直显示为42。

## 目前为止

在我们进一步了解怎么**更新**计数器的值之前，我们先来了解一下到目前为止我们做了些什么：

* 我们写了一个 `mapStateToProps` 函数，该函数的作用是：把 Redux 中的状态转换成一个包含属性的对象。
* 我们用模块 `react-redux` 中的函数 `connect` 把 Redux store 状态树和 `Counter` 组件连接起来，使用 `mapStateToProps` 函数配置了怎么联系。
* 我们创建了一个 `reducer` 函数去告诉 Redux 我们的状态应该是什么形式的。
* 我们使用 `reducer` 做 `createStore` 函数的参数，用它创建了一个 store。
* 我们把整个组件包裹在了 `react-redux` 中的组件 `Provider` 中，向该组件传入了 store 作为属性。
* 这个程序工作的很好，唯一的问题是计数器显示停留在了42。

你跟着我做到现在了吗？

## 互动起来 (让计数器工作)

我知道到目前为止我们的程序是很差劲的，你们已经写了一个显示着数字 “42” 和两个无效的按钮的静态的 HTML 页面，不过你还在继续阅读，接下来将继续用 React 和 Redux 和其它的一些东西让我们的程序变得复杂起来。

我保证接下来做的事情会让上面做的一切都值得。

事实上，我收回刚才那句话，一个简单的计数器的例子是一个很好的教学例子，但是 Redux 让应用变得复杂了，React 的 state 应用起来其实也很简单，甚至一般的 JS 代码也能够实现的很好，挑选正确的工具做正确的事，Redux 不总是那个合适的工具，不过我偏题了。

## 初始化状态

我们需要一个方式去告诉 Redux 改变计数器的值。

还记得我们写的 `reducer` 函数吗？（当然你肯定记得，因为那是两分钟之前的事）。

还记得我说过它会使用**当前状态**返回**新的状态**吗？好的，我再重复一次，实际上，它使用当前状态和一个 **action** 作为参数，然后返回一个新的状态，我们应该这样写：

```
function reducer(state, action) {
  return {
    count: 42
  };
}
```

Redux 第一次调用这个函数的时候会以 `undefined` 作为实参替代 `state`，意味着返回的是**初始状态**，对于我们来说，可能返回的是一个属性 `count` 值为 0 的对象。

在 reducer 上面写初始状态是很常见的，当 `state` 参数未定义的时候，使用 ES6 的默认参数的特性为 `state` 参数提供一个参数。

```
const initialState = {
  count: 0
};

function reducer(state = initialState, action) {
  return state;
}
```

这样子试试呢，代码仍然会起作用，不过现在计数器停留在了 0 而不是 42，多么让人惊讶。

## Action

我们最后谈谈 `action` 参数，这是什么呢？它来自哪里呢？ 我们怎么用它去改变不变的 counter 呢？

一个 “action” 是一个描述了我们想要改变什么的 JS 对象，为一个要求就是对象必须要有一个 `type` 属性，它的值应该是一个字符串，这里有一个例子：

```
{
  type: "INCREMENT"
}
```

这是另外一个例子：

```
{
  type: "DECREMENT"
}
```

你的大脑在快速运转吗？你知道接下来我们要做什么吗？

## 对 Actions 做出响应

还记得 reducer 的作用是用**当前状态**和一个**action**去计算出新的状态吧。所以如果一个 reducer 接受了一个 action 例如 `{ type: "INCREMENT" }`，你想要返回什么作为新的状态呢？

如果你像下面这样想，那么你就想对了：

```
function reducer(state = initialState, action) {
  if(action.type === "INCREMENT") {
    return {
      count: state.count + 1
    };
  }

  return state;
}
```

使用 `switch` 语句和 `case` 语句处理每一个 action 是很常见的写法把你的 reducer 函数写成下面这样子：

```
function reducer(state = initialState, action) {
  switch(action.type) {
    case 'INCREMENT':
      return {
        count: state.count + 1
      };
    case 'DECREMENT':
      return {
        count: state.count - 1
      };
    default:
      return state;
  }
}
```

#### 总是返回一个状态

你会注意到**函数**默认返回的是 `return state`。这很重要，因为 action 不知道要做什么，Redux 通过 action 去调用你的 reducer 函数。实际上 你接受的第一个 action 是 `{ type: "@@redux/INIT" }`。试着在 `switch` 前面写一个 `console.log(action)` 看看会打印出什么。

还记得 reducer 的工作是返回一个**新状态**吧，即使当前状态没有发生改变也要返回。 你不想从 “有一个状态” 变成 “state = undefined” 吧？ 在你忘了 `default` 情况的时候就会发生这样的事，不要这样做。

#### 永远不要改变状态

永远不要去做这件事：不要**改变** `state`。State 是不可变的。你不可以改变它，意味着你不能这样做：

```
function brokenReducer(state = initialState, action) {
  switch(action.type) {
    case 'INCREMENT':
      // 不，不要这样做，这样正在改变状态
      state.count++;
      return state;

    case 'DECREMENT':
      // 不要这样做，这也是在改变状态
      state.count--;
      return state;

    default:
      // 这样做是很好的.
      return state;
  }
}
```

你也不要做这样的事，比如写 `state.foo = 7` 或者 `state.items.push(newItem)`，或者 `delete state.something`。

把这想象为一场游戏，你唯一能做的事就是 `return { ... }`，这是一个有趣的游戏，一开始游戏有些让人抓狂，但是随着你的练习你会觉得游戏越来越有意思。

我编写了一个简短的指南关于怎么去处理不可变的更新，展示了七种常见的包括对象和数组在内的更新模式。

#### 所有的规则…

总是返回一个状态，不要去改变状态，不要连接到每一个组件，吃你自己的西蓝花，不要在外面待着超过 11 点...，真累啊。这就像一个规则工厂，我甚至不知道那是什么。

是的，Redux 可能就像一个霸道的父母。但是都是出于爱。来自函数式编程的爱。

Redux 建立在不变性的基础上，因为改变全局的状态就是一条通向毁灭的道路。

你是否使用一个全局对象去保存整个 app 的状态？一开始运行的很好，很容易，然后状态在没有任何预测的情况下发生了改变，而且几乎不可能去找到改变状态的代码。

Redux 使用一些简单的规则去避免了这样的问题，State 是只读的，actions 是唯一修改状态的方式，改变状态只有一种方式：这个方式就是：action -> reducer -> 新的状态。reducer 必须是一个**纯函数**，它不能修改它的参数。

有插件可以帮助你去记录每一个 action，追溯它们，你可以想象到的一切。从时间上追溯调试是创建  Redux 的动机之一。

## Actions 来自哪里呢？

让人迷惑的一部分仍然存在：我们需要一个方式去让一个 action 进入到我们的 reducer 中，我们才能增加或者减少这个计数器。

Action 不是被生成的，它们是被**dispatched**的，有一个小巧的函数叫做dispatch。

`dispatch` 函数由 Redux store 的实例提供，也就是说，你不可以仅仅通过 `import { dispatch }`获得 `dispatch` 函数。你可以调用 `store.dispatch(someAction)`，但是那不是很方便，因为 `store` 的实例只在一个文件里面可以被获得。

很幸运，我们还有 `connect` 函数。除了注入 `mapStateToProps` 函数的返回值作为属性以外，`connect` 函数**也**把 `dispatch` 函数作为属性注入了组件，使用这么一点知识，我们又可以让计数器工作起来了。

这里是最后的组件形式，如果你一直跟着写到了这里，那么唯一要改变的实现就是 `increment` 和 `decrement`：它们现在可以调用 `dispatch` 属性，通过它分发一个 action。

```
import React from 'react';
import { connect } from 'react-redux';

class Counter extends React.Component {
  increment = () => {
    this.props.dispatch({ type: 'INCREMENT' });
  }

  decrement = () => {
    this.props.dispatch({ type: 'DECREMENT' });
  }

  render() {
    return (
      <div>
        <h2>Counter</h2>
        <div>
          <button onClick={this.decrement}>-</button>
          <span>{this.props.count}</span>
          <button onClick={this.increment}>+</button>
        </div>
      </div>
    )
  }
}

function mapStateToProps(state) {
  return {
    count: state.count
  };
}

export default connect(mapStateToProps)(Counter);
```

整个项目的代码（它的两个文件）可以在[ Github](https://github.com/dceddia/redux-intro)上面找到。

## 现在怎样了呢？

利用 Counter 程序作为一个传送带，你可以继续学习会更多的 Redux 知识了。

> “什么?! 还有更多?!”

还有很多的地方我没有讲到，我希望这个介绍是容易理解的 – action constants, action 创建函数, 中间件, thunks 和异步调用, selectors, 等等。 还有很多。这个 [Redux docs](https://redux.js.org/) 文档写的很好，覆盖了我讲到的所有知识和更多的知识。

你已经了解到了基本的思想，希望你理解了数据怎么 Redux 里面变化 (`dispatch(action) -> reducer -> new state -> re-render`)，reducer 做了什么，action 又做了什么，它们是怎么作用在一起的。

我将会发布一个新的课程，课程涵盖到所有的这些东西和更多的知识！[这里登录](#ck_modal) 去关注.

以循序渐进的方式学习 React，查看我的[书](https://daveceddia.com/pure-react/?utm_campaign=after-post) - 免费查看两个示例章节。

就我而言，即使是免费的介绍也是值得的。 — Isaac


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
