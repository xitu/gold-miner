> * 原文地址：[A Complete React Redux Tutorial for 2019](https://daveceddia.com/redux-tutorial/)
> * 原文作者：[Dave Ceddia](https://daveceddia.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/redux-tutorial.md](https://github.com/xitu/gold-miner/blob/master/TODO1/redux-tutorial.md)
> * 译者：[xilihuasi](https://github.com/xilihuasi)
> * 校对者：[xionglong58](https://github.com/xionglong58)、[Fengziyin1234](https://github.com/Fengziyin1234)

# 2019 React Redux 完全指南

![A Complete Redux Tutorial (2019): why use it? - store - reducers - actions - thunks - data fetching](https://daveceddia.com/images/complete-redux-tutorial-2019.png)

想要理解 Redux 完整的工作机制真的让人头疼。特别是作为初学者。

术语太多了！Actions、reducers、action creators、middleware、pure functions、immutability、thunks 等等。

怎么把这些全都与 React 结合起来构建一个可运行的应用？

你可以花几个小时阅读博客以及尝试从复杂的“真实世界”应用中研习以将它拼凑起来。

在本篇 Redux 教程中，我会渐进地解释如何将 Redux 与 React 搭配使用 —— 从简单的 React 开始 —— 以及一个非常简单的 React + Redux 案例。我会解释**为什么**每个功能都很有用（以及什么情况下做取舍）。

接着我们会看到更加进阶的内容，手把手，直到你**全部**都理解为止。我们开始吧 :)

请注意：本教程**相当齐全**。也就意味篇幅着**比较长**。我把它变成了一个完整的免费课程，**并且**我制作了精美的 PDF 你可以在 iPad 或【任何 Android 设备】上阅读。留下你的邮箱地址即可立即获取。

## 视频概述 Redux 要点

如果你更喜欢看视频而不是阅读，这个视频涵盖了如何在 React 应用中一步步添加 Redux：

[视频地址](https://youtu.be/sX3KeP7v7Kg)

这与本教程的第一部分相似，我们都会在一个简单 React 应用中逐步地添加 Redux。

或者，继续看下去！本教程不仅涵盖视频中的所有内容，还有其他干货。

## 你应该用 Redux 吗？

都 9102 年了，弄清楚你是否还应该使用 Redux 十分必要。现在有更好的替代品出现吗，使用 Hooks，Context 还是其他库？

简而言之：即使有很多替代品，[Redux 仍旧不死](https://blog.isquaredsoftware.com/2018/03/redux-not-dead-yet/)。但是是否适用于你的应用，还得看具体场景。

超级简单？只有一两个地方需要用到几个 state？组件内部 state 就很好了。你可以通过 classes，[Hooks](https://daveceddia.com/intro-to-hooks/) 或者二者一起来实现。

再复杂一点，有一些“全局”的东西需要在整个应用中共享？[Context API](https://daveceddia.com/context-api-vs-redux/) 可能完美适合你。

很多全局的 state，与应用的各独立部分都有交互？或者一个大型应用并且随着时间推移只会越来越大？试试 Redux 吧。

你也可以**以后**再使用 Redux，不必在第一天就决定。从简单开始，在你需要的时候再增加复杂性。

### 你知道 React 吗？

React 可以脱离 Redux 单独使用。Redux 是 React 的**附加项**。

即使你打算同时使用它们，我还是强烈建议先**脱离** Redux 学习纯粹的 React。理解 props，state 以及单向数据流，在学习 Redux 之前先学习 “React 编程思想”。同时学习这两个肯定会把你搞晕。

如果你想要入门 React ，我整理了一个为期 5 天的免费课程，教授所有基础知识：

接下来的 5 天通过构建一些简单的应用来学习 React。

第一课

## Redux 的好处

如果你稍微使用过一段时间的 React，你可能就了解了 props 和单向数据流。数据通过 props 在组件树间向**下**传递。就像这个组件一样：

![Counter component](https://daveceddia.com/images/counter-component.png)

`count` 存在 `App` 的 state 里，会以 prop 的形式向下传递：

![Passing props down](https://daveceddia.com/images/passing-props-down.png)

要想数据向**上**传递，需要通过回调函数实现，因此必须首先将回调函数向**下**传递到任何想通过调用它来传递数据的组件中。

![Passing callbacks down](https://daveceddia.com/images/passing-callbacks-down.png)

你可以把数据想象成**电流**，通过彩色电线连接需要它的组件。数据通过线路上下流动，但是线路不能在空气中贯穿 —— 它们必须从一个组件连接到另一个组件。

### 多级传递数据是一种痛苦

迟早你会陷入这类场景，顶级容器组件有一些数据，有一个 4 级以上的子组件需要这些数据。这有一个 Twitter 的例子，所有头像都圈出来了：

![Twitter user data](https://daveceddia.com/images/twitter-user-data.png)

我们假设根组件 `App` 的 state 有 `user` 对象。该对象包含当前用户头像、昵称和其他资料信息。

为了把 `user` 数据传递给全部 3 个 `Avatar` 组件，必须要经过一堆并不需要该数据的中间组件。

![Sending the user data down to the Avatar components](https://daveceddia.com/images/twitter-hierarchy.png)

获取数据就像用针在采矿探险一样。等等，那根本没有意义。无论如何，**这很痛苦**。也被称为 “prop-drilling”。

更重要的是，这不是好的软件设计。中间组件被迫接受和传递他们并不关心的 props。也就意味着重构和重用这些组件会变得比原本更难。

如果不需要这些数据的组件根本不用看到它们的话不是很棒吗？

Redux 就是解决这个问题的一种方法。

### 相邻组件间的数据传递

如果你有些兄弟组件需要共享数据，React 的方式是把数据向**上**传到父组件中，然后再通过 props 向下传递。

但这可能很麻烦。Redux 会为你提供一个可以存储数据的全局 "parent"，然后你可以通过 React-Redux 把兄弟组件和数据 `connect` 起来。

### 使用 React-Redux 将数据连接到任何组件

使用 `react-redux` 的 `connect` 函数，你可以将任何组件插入 Redux 的 store 以及取出需要的数据。

![Connecting Redux to the Avatar components](https://daveceddia.com/images/redux-connected-twitter.png)

Redux 还做了一些很酷的事情，比如使调试更轻松（Redux DevTools 让你检查每一个 state 的变化），time-travel debugging（你可以**回滚** state 变化，看看你的应用以前的样子），从长远来看，它让代码变得更易于维护。它也会教你更多关于函数式编程的知识。

## 内置 Redux 替代品

如果 Redux 对你来说太过繁琐了，可以看看这些替代品。它们内置在 React 中。

### Redux 替代品: The React Context API

在底层，React-Redux 使用 React 内置的 Context API 来传递数据。如果你愿意，你可以跳过 Redux 直接使用 Context。你会错过上面提到的 Redux 很棒的特性，但是如果你的应用很简单并且想用简单的方式传递数据，Context 就够了。

既然你读到这里，我认为你真想学习 Redux，我不会在这里[比较 Redux 和 Context API](https://daveceddia.com/context-api-vs-redux/) 或者[使用 Context](https://daveceddia.com/usecontext-hook/) 和[使用 Reducer](https://daveceddia.com/usereducer-hook-examples/) Hooks。你可以点击链接详细了解。

如果你想深入研究 Context API，看我在 egghead 的课程 [React Context 状态管理](https://egghead.io/courses/react-context-for-state-management)

### 其他替代品：使用 `children` Prop

取决于你构建应用程序的方式，你可能会用更直接的方式把数据传递给子组件，那就是使用 `children` 和其他 props 结合的方式作为“插槽”。如果你组织的方式正确，就可以有效地跳过层次结构中的几个层级。

我有一篇相关文章 [“插槽”模式以及如何组织组件树](https://daveceddia.com/pluggable-slots-in-react-components/) 来有效地传递数据。

## 学习 Redux，从简单 React 开始

我们将采用增量的方法，从带有组件 state 的简单 React 应用开始，一点点添加 Redux，以及解决过程中遇到的错误。我们称之为“错误驱动型开发” :)

这是一个计数器：

![Counter component](https://daveceddia.com/images/counter-plain.png)

这本例中，Counter 组件有 state，包裹着它的 App 是一个简单包装器。

Counter.js

```js
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

快速回顾一下，它是如何运行的：

- `count` state 存储在 `Counter` 组件
- 当用户点击 "+" 时，会调用按钮的 `onClick` 处理器执行 `increment` 函数。
- `increment` 函数会更新 state 的 count 值。
- 因为 state 改变了，React 会重新渲染 `Counter` 组件（以及它的子元素），这样就会显示新计数值。

如果你想要了解 state 变化机制的更多细节，去看 [React 中的 state 可视指南](https://daveceddia.com/visual-guide-to-state-in-react/)然后再回到这里。

不过说实话：如果上面内容对你来讲**不是**复习的话，你需要在学 Redux **之前**了解下 React 的 state 如何工作，否则你会巨困惑。参加我[免费的 5 天 React 课程](https://daveceddia.com/pure-react-email-course)，用简单的 React 获得信心，然后再回到这里。

### 跟上来！

最好的学习方式就是动手尝试！所以这有个 CodeSandbox 你可以跟着做：

--> [在新 tab 中打开 CodeSandbox](https://codesandbox.io/s/98153xy79w)

我强烈建议你将 CodeSandbox 与该教程保持同步并且随着你进行时实际动手敲出这些例子。

## 在 React 应用中添加 Redux

在 CodeSandbox 中，展开左侧的 Dependencies 选项，然后点击 Add Dependency。

搜索 `redux` 添加依赖，然后再次点击 Add Dependency 搜索 `react-redux` 添加。

![](https://daveceddia.com/images/add-redux-in-codesandbox.gif)

在本地项目，你可以通过 Yarn 或者 NPM 安装：`npm install --save redux react-redux`。

### redux vs react-redux

`redux` 给你一个 store，让你可以在里面保存 state，取出 state，以及当 state 发生改变时做出响应。但那就是它所有能做的事。

实际上是 `react-redux` 把各个 state 和 React 组件连接起来。

没错：`redux` 对 React **根本**不了解。

虽然，这两个库就像豆荚里的两个豌豆。99.999% 的情况下，当任何人在 React 的场景下提到 "Redux"，他们指的是这两个库。因此当你在 StackOverflow、Reddit 或者其他地方看到 Redux 时，记住这一点。

`redux` 库可以脱离 React 应用使用。它可以和 Vue、Angular 甚至后端的 Node/Express 应用一起使用。

## Redux 有全局唯一 Store

我们将首先从 Redux 中的一小部分入手：store。

我们已经讨论过 Redux 怎样在一个独立 store 里保存你应用的 state。以及怎样提取 state 的一部分把它作为 props 嵌入你的组件。

你会经常看到 "state" 和 "store" 这两个词互换使用。技术上来讲，state 是数据，store 是保存数据的地方。

因此：作为我们从简单的 React 到 Redux 重构的第一步，我们要创建一个 store 来保持 state。

## 创建 Redux Store

Redux 有一个很方便的函数用来创建 stores，叫做 `createStore`。很合逻辑，嗯？

我们在 `index.js` 中创建一个 store。引入 `createStore` 然后像这样调用：

index.js

```js
import { createStore } from 'redux';

const store = createStore();

const App = () => (
  <div>
    <Counter/>
  </div>
);
```

这样会遇到 "Expected the reducer to be a function." 错误。

![Error: Expected the reducer to be a function.](https://daveceddia.com/images/error-expected-reducer-to-be-a-function.png)

### Store 需要一个 Reducer

因此，有件关于 Redux 的事：它并不是非常智能。

你可能期待通过创建一个 store，它会给你的 state 一个合适的默认值。或许是一个空对象？

但是并非如此。这里没有约定优于配置。

Redux **不会**对你的 state 做任何假设。它可能是一个 object、number、string，或者任何你需要的。这取决于你。

我们必须提供一个返回 state 的函数。这个函数被称为 reducer（我们马上就知道为什么了）。那么我们创建一个非常简单的 reducer，把它传给 `createStore`，然后看会发生什么：

index.js

```js
function reducer(state, action) {
  console.log('reducer', state, action);
  return state;
}

const store = createStore(reducer);
```

修改完后，打开控制台（在 CodeSandbox 里，点击底部的 Console 按钮）。

你应该可以看到类似这样的日志信息：

![reducer undefined Object { type: @@redux/INIT }](https://daveceddia.com/images/reducer-console-log.png)

（INIT 后面的字母和数字是 Redux 随机生成的）

注意在你创建 store 的同时 Redux 如何调用你的 reducer。（为了证实这点：调用 `createStore` 之后立即输出 `console.log`，看看 reducer 后面会打印什么）

同样注意 Redux 如何传递了一个 `undefined` 的 `state`，同时 action 是一个有 `type` 属性的对象。

我们稍后会更多地讨论 actions。现在，我们先看看 **reducer**。

## Redux Reducer 是什么？

"reducer" 术语看起来可能有点陌生和害怕，但是本节过后，我认为你会同意如下观点，正如俗话所说的那样，“只是一个函数”。

你用过数组的 `reduce` 函数吗？

它是这样用的：你传入一个函数，遍历数组的每一个元素时都会调用你传入的函数，类似 `map` 的作用 —— 你可能在 React 里面渲染列表而对 `map` 很熟悉。

你的函数调用时会接收两个参数：上一次迭代的结果，和当前数组元素。它结合当前元素和之前的 "total" 结果然后返回新的 total 值。

结合下面例子看会更加清晰明了：

```js
var letters = ['r', 'e', 'd', 'u', 'x'];

// `reduce` 接收两个参数:
//   - 一个用来 reduce 的函数 (也称为 "reducer")
//   - 一个计算结果的初始值
var word = letters.reduce(
  function(accumulatedResult, arrayItem) {
    return accumulatedResult + arrayItem;
  },
''); // <-- 注意这个空字符串：它是初始值

console.log(word) // => "redux"
```

你给 `reduce` 传入的函数理所应当被叫做 "reducer"，因为它将整个数组的元素 **reduces** 成一个结果。

Redux **基本上**是数组 `reduce` 的豪华版。前面，你看到 Redux reducers 如何拥有这个显著特征：

```js
(state, action) => newState
```

含义：它接收当前 `state` 和一个 `action`，然后返回 `newState`。看起来很像 `Array.reduce` 里 reducer 的特点！

```js
(accumulatedValue, nextItem) => nextAccumulatedValue
```

Redux reducers 就像你传给 Array.reduce 的函数作用一样！:) 它们 reduce 的是 actions。它们把一组 actions（随着时间）reduce 成一个单独的 state。不同之处在于 Array 的 reduce 立即发生，而 Redux 则随着正运行应用的生命周期一直发生。

如果你仍然非常不确定，查看下我的 [Redux reducers 工作机制]指南(https://daveceddia.com/what-is-a-reducer/)。不然的话，我们继续向下看。

## 给 Reducer 一个初始状态

记住 reducer 的职责是接收当前 `state` 和一个 `action` 然后返回新的 state。

它还有另一个职责：在首次调用的时候应该返回初始 state。它有点像应用的“引导页”。它必须从某处开始，对吧？

惯用的方式是定义一个 `initialState` 变量然后使用 ES6 默认参数给 `state` 赋初始值。

既然要把 `Counter` state 迁移到 Redux，我们先立马创建它的初始 state。在 `Counter` 组件里，我们的 state 是一个有 `count` 属性的对象，所以我们在这创建一个一样的 initialState。

index.js

```js
const initialState = {
  count: 0
};

function reducer(state = initialState, action) {
  console.log('reducer', state, action);
  return state;
}
```

如果你再看下控制台，你会看到 `state` 打印的值为 `{count: 0}`。那就是我们想要的。

所以这告诉我们一条关于 reducers 的重要规则。

Reducers 重要规则一：reducer 绝不能返回 undefined。

通常 state 应该总是已定义的。已定义的 state 是良好的 state。而**未**定义的则**不**那么好（并且会破坏你的应用）。

## Dispatch Actions 来改变 State

是的，一下来了两个名字：我们将 "dispatch" 一些 "actions"。

### 什么是 Redux Action？

在 Redux 中，具有 `type` 属性的普通对象就被称为 action。就是这样，只要遵循这两个规则，它就是一个 action：

```js
{
  type: "add an item",
  item: "Apple"
}
```

This is also an action:

```js
{
  type: 7008
}
```

Here's another one:

```js
{
  type: "INCREMENT"
}
```

Actions 的格式非常自由。只要它是个带有 `type` 属性的对象就可以了。

为了保证事务的合理性和可维护性，我们 Redux 用户通常给 actions 的 type 属性赋简单字符串，并且通常是大写的，来表明它们是常量。

Action 对象描述你想做出的改变（如“增加 counter”）或者将触发的事件（如“请求服务失败并显示错误信息”）。

尽管 Actions 名声响亮，但它是无趣的，呆板的对象。它们事实上不**做**任何事情。反正它们自己不做。

为了让 action **做**点事情，你需要 dispatch。

## Redux Dispatch 工作机制

我们刚才创建的 store 有一个内置函数 `dispatch`。调用的时候携带 action，Redux 调用 reducer 时就会携带 action（然后 reducer 的返回值会更新 state）。

我们在 store 上试试看。

index.js

```js
const store = createStore(reducer);
store.dispatch({ type: "INCREMENT" });
store.dispatch({ type: "INCREMENT" });
store.dispatch({ type: "DECREMENT" });
store.dispatch({ type: "RESET" });
```

在你的 CodeSandbox 中添加这些 dispatch 调用然后检查控制台

![reducer undefined Object { type: @@redux/INIT }](https://daveceddia.com/images/dispatching-redux-actions.png)

每一次调用 `dispatch` 最终都会调用 reducer！

同样注意到 state 每次都一样？`{count: 0}` 一直没变。

这是因为我们的 reducer 没有**作用于**那些 actions。不过很容易解决。现在就开始吧。

## 在 Redux Reducer 中处理 Actions

为了让 actions 做点事情，我们需要在 reducer 里面写几行代码来根据每个 action 的 `type` 值来对应得更新 state。

有几种方式实现。

你可以创建一个对象来通过 action 的 type 来查找对应的处理函数。

或者你可以写一大堆 if/else 语句

```js
if(action.type === "INCREMENT") {
  ...
} else if(action.type === "RESET") {
  ...
}
```

或者你可以用一个简单的 `switch` 语句，也是我下面采用的方式，因为它很直观，也是这种场景的常用方法。

尽管有些人讨厌 `switch`，如果你也是 —— 随意用你喜欢的方式写 reducers 就好 :)

下面是我们处理 actions 的逻辑：

index.js

```js
function reducer(state = initialState, action) {
  console.log('reducer', state, action);

  switch(action.type) {
    case 'INCREMENT':
      return {
        count: state.count + 1
      };
    case 'DECREMENT':
      return {
        count: state.count - 1
      };
    case 'RESET':
      return {
        count: 0
      };
    default:
      return state;
  }
}
```

试一下然后在控制台看看会输出什么。

![reducer undefined Object { type: @@redux/INIT }](https://daveceddia.com/images/handling-redux-actions.png)

快看！`count` 变了!

我们准备好把它连接到 React 了，在此之前让我们先谈谈这段 reducer 代码。

## 如何保持纯 Reducers

另一个关于 reducers 的规则是它们必须是纯函数。也就是说不能修改它们的参数，也不能有副作用（side effect）。

Reducer 规则二：Reducers 必须是纯函数。

“副作用（side effect）”是指对函数作用域之外的任何更改。不要改变函数作用域以外的变量，不要调用其他会改变的函数（比如 `fetch`，跟网络和其他系统有关），也不要 dispatch actions 等。

技术角度来看 `console.log` 是副作用（side effect），但是我们忽略它。

最重要的事情是：不要修改 `state` 参数。

这意味着你不能执行 `state.count = 0`、`state.items.push(newItem)`、`state.count++` 及其他类型的变动 —— 不要改变 `state` 本身，及其任何子属性。

你可以把它想成一个游戏，你唯一能做的事就是 `return { ... }`。这是个有趣的游戏。开始会有点恼人。但是通过练习你会变得更好。

我整理了一个[如何在 Redux 里做 Immutable 更新](https://daveceddia.com/react-redux-immutability-guide/)完全指南，包含更新 state 中对象和数组的七个通用模式。

安装 [Immer](https://github.com/mweststrate/immer) 在 reducers 里面使用也是一种很好的方式。Immer 让你可以像写普通 mutable 代码一样，最终会自动生成 immutable 代码。[点击了解如何使用 Immer](https://daveceddia.com/react-redux-immutability-guide/#easy-state-updates-with-immer)。

建议：如果你是开始一个全新的应用程序，一开始就使用 Immer。它会为你省去很多麻烦。但是我向你展示这种**困难**方式是因为很多代码仍然采用这种方式，你一定会看到没有用 Immer 写的 reducers

## 全部规则

必须返回一个 state，不要改变 state，不要 connect 每一个组件，要吃西兰花，11 点后不要外出…这简直没完没了。就像一个规则工厂，我甚至不知道那是什么。

是的，Redux 就像一个霸道的父母。但它是出于爱。函数式编程的爱。

Redux 建立在不变性的基础上，因为变化的全局 state 是一条通往废墟之路。

你试过在全局对象里面保存你的 state 吗？起初它还很好。美妙并且简单。任何东西都能接触到 state 因为它一直是可用的并且很容易更改。

然后 state 开始以不可预测的方式发生改变，想要找到改变它的代码变得几乎不可能。

为了避免这些问题，Redux 提出了以下规则。

- State 是只读的，唯一修改它的方式是 actions。
- 更新的唯一方式：dispatch(action) -> reducer -> new state。
- Reducer 函数必须是“纯”的 —— 不能修改它的参数，也不能有副作用（side effect）。

## 如何在 React 中使用 Redux

此时我们有个很小的带有 `reducer` 的 `store`，当接收到 `action` 时它知道如何更新 `state`。

现在是时候将 Redux 连接到 React 了。

要做到这一点，要用到 `react-redux` 库的两样东西：一个名为 `Provider` 的组件和一个 `connect` 函数。

通过用 `Provider` 组件包装整个应用，如果它想的话，应用树里的**每一个组件**都可以访问 Redux store。

在 `index.js` 里，引入 `Provider` 然后用它把 `App` 的内容包装起来。`store` 会以 prop 形式传递。

index.js

```js
import { Provider } from 'react-redux';

...

const App = () => (
  <Provider store={store}>
    <Counter/>
  </Provider>
);
```

这样之后，`Counter`， `Counter` 的子元素，以及子元素的子元素等等——所有这些现在都可以访问 Redux stroe。

但不是自动的。我们需要在我们的组件使用 `connect` 函数来访问 store。

### React-Redux Provider 工作机制

`Provider` 可能看起来有一点点像魔法。它在底层实际是用了 React 的 [Context 特性](https://daveceddia.com/context-api-vs-redux/)。

Context 就像是连接每个组件的秘密通道，使用 `connect` 就可打开秘密通道的大门。

想象一下，在一堆煎饼上浇糖浆以及它铺满**所有**煎饼的方式，即使你只在最上层倒了糖浆。`Provider` 对 Redux 做了同样的事情。

## 为 Redux 准备 Counter 组件

现在 Counter 有了内部 state。我们打算把它干掉，为从 Redux 以 prop 方式获取 `count` 做准备。

移除顶部的 state 初始化，以及 `increment` 和 `decrement` 内部调用的 `setState`。然后，把 `this.state.count` 替换成 `this.props.count`。

Counter.js

```js
class Counter extends React.Component {
  // state = { count: 0 }; // 删除

  increment = () => {
    /*
    // 删除
    this.setState({
      count: this.state.count + 1
    });
    */
  };

  decrement = () => {
    /*
    // 同样删除
    this.setState({
      count: this.state.count - 1
    });
    */
  };

  render() {
    return (
      <div className="counter">
        <h2>Counter</h2>
        <div>
          <button onClick={this.decrement}>-</button>
          <span className="count">{
            // 把 state:
            //// this.state.count
            // 替换成:
            this.props.count
          }</span>
          <button onClick={this.increment}>+</button>
        </div>
      </div>
    );
  }
}
```

现在 `increment` 和 `decrement` 是空的。我们会很快再次填充它们。

你会注意到 count 消失了 —— 它确实应该这样，因为目前还没有给 `Counter` 传递 `count` prop。

## 连接组件和 Redux

要从 Redux 获取 `count`，我们首先需要在 Counter.js 顶部引入 `connect` 函数。

Counter.js

```js
import { connect } from 'react-redux';
```

然后我们需要在底部把 Counter 组件和 Redux 连接起来：

Counter.js

```js
// 添加这个函数:
function mapStateToProps(state) {
  return {
    count: state.count
  };
}

// 然后把:
// export default Counter;

// 替换成:
export default connect(mapStateToProps)(Counter);
```

之前我们只导出了组件本身。现在我们用 `connect` 函数调用把它包装起来，这样我们就可以导出**已连接的** Counter。至于应用的其余部分，看起来就像一个常规组件。

然后 count 应该就重新出现了！直到我们重新实现 increment/decrement，它是不会变化的。

## 如何使用 React Redux `connect`

你可能注意到这个调用看起来有点……奇怪。为什么是 `connect(mapStateToProps)(Counter)` 而不是 `connect(mapStateToProps, Counter)` 或者 `connect(Counter, mapStateToProps)`？它做了什么？

这样写是因为 `connect` 是一个**高阶函数**，它简单说就是当你调用它时会返回一个函数。然后调用**返回的**函数传入一个组件时，它会返回一个新（包装的）组件。

它的另一个名称是 [**高阶组件**](https://daveceddia.com/extract-state-with-higher-order-components/) (简称 "HOC")。HOCs 过去曾有过一些糟糕的新闻，但它仍然是一个相当有用的模式，`connect` 就是一个很好的例子。

`Connect` 做的是在 Redux 内部 hook，取出整个 state，然后把它传进你提供的 `mapStateToProps` 函数。它是个自定义函数，因为只有**你**知道你存在 Redux 里面的 state 的“结构”。

## mapStateToProps 工作机制

`connect` 把整个 state 传给了你的 `mapStateToProps` 函数，就好像在说，“嘿，告诉我你想从这堆东西里面要什么。”

`mapStateToProps` 返回的对象以 props 形式传给了你的组件。以上面为例就是把 `state.count` 的值用 `count` prop 传递：对象的属性变成了 prop 名称，它们对应的值会变成 props 的值。你看，这个函数就像字面含义一样**定义从 state 到 props 的映射**。

顺便说说 —— `mapStateToProps` 的名称是使用惯例，但并不是特定的。你可以简写成 `mapState` 或者用任何你想的方式调用。只要你接收 `state` 对象然后返回全是 props 的对象，那就没问题。

### 为什么不传整个 state？

在上面的例子中，我们的 state 结构**已经**是对的了，看起来 `mapDispatchToProps` 可能是不必要的。如果你实质上复制参数（state）给一个跟 state 相同的对象，这有什么意义呢？

在很小的例子中，可能会传全部 state，但通常你只会从更大的 state 集合中选择部分组件需要的数据。

并且，没有 `mapStateToProps` 函数，`connect` 不会传递任何 state。

你**可以**传整个 state，然后让组件梳理。但那不是一个很好的习惯，因为组件需要知道 Redux state 的结构然后从中挑选它需要的数据，后面如果你想更改结构会变得更难。

## 从 React 组件 Dispatch Redux Actions

现在我们的 Counter 已经被 `connect` 了，我们也获取到了 `count` 值。现在我们如何 dispatch actions 来改变 count？

好吧，`connect` 为你提供支持：除了传递（mapped）state，它**还**从 store 传递了 `dispatch` 函数!

要在 Counter 内部 dispatch action，我们可以调用 `this.props.dispatch` 携带一个 action。

我们的 reducer 已经准备好处理 `INCREMENT` 和 `DECREMENT` actions 了，那么接下来从 increment/decrement 中 dispatch：

Counter.js

```js
increment = () => {
  this.props.dispatch({ type: "INCREMENT" });
};

decrement = () => {
  this.props.dispatch({ type: "DECREMENT" });
};
```

现在我们完成了。按钮应该又重新生效了。

### 试试这个！加一个重置按钮

这有个小练习：给 counter 添加“重置”按钮，点击时 dispatch "RESET" action。

Reducer 已经写好处理这个 action，因此你只需要修改 Counter.js。

## Action 常量

在大部分 Redux 应用中，你可以看到 action 常量都是一些简单字符串。这是一个额外的抽象级别，从长远来看可以为你节省不少时间。

Action 常量帮你避免错别字，action 命名的错别字会是一个巨大的痛苦：没有报错，没有哪里坏掉的明显标志，并且你的 action 没有做任何事情？那就可能是个错别字。

Action 常量很容易编写：用变量保存你的 action 字符串。

把这些变量放在一个 `actions.js` 文件里是个好办法（当你的应用很小时）。

actions.js

```js
export const INCREMENT = "INCREMENT";
export const DECREMENT = "DECREMENT";
```

然后你就可以引入这些 action 名称，用它们来代替手写字符串：

Counter.js

```js
import React from "react";
import { INCREMENT, DECREMENT } from './actions';

class Counter extends React.Component {
  state = { count: 0 };

  increment = () => {
    this.props.dispatch({ type: INCREMENT });
  };

  decrement = () => {
    this.props.dispatch({ type: DECREMENT });
  };

  render() {
    ...
  }
}
```

## Redux Action 生成器是什么？

现在我们已经手写 action 对象。像个异教徒。

如果你有一个**函数**会为你编写它会怎么样？不要再误写 actinos 了！

我可以告诉你，这很疯狂。手写 `{ type: INCREMENT }` 并保证没有弄乱有多困难？

当你的应用变得越来越大，actions 越来越多，并且这些 actions 开始变得更复杂 —— 要传更多数据而不仅是一个 `type` —— action 生成器会帮上大忙。

就像 action 常量一样，但它们不是**必须品**。这是另一层的抽象，如果你不想在你的应用里面使用，那也没关系。

不过我还是会解释下它们是什么。然后你可以决定你是否有时/总是/绝不想使用它们。

Actions 生成器在 Redex 术语中是一个简单的函数术语，它返回一个 action 对象。就这些 :)

这是其中两个，返回熟悉的 actions。顺便说一句，它们在 action 常量的 "actions.js" 中完美契合。

actions.js

```js
export const INCREMENT = "INCREMENT";
export const DECREMENT = "DECREMENT";

export function increment() {
  return { type: INCREMENT };
}

export const decrement = () => ({ type: DECREMENT });
```

我用了两种不同方式——一个 `function` 和一个箭头函数——来表明你用哪种方式写并不重要。挑选你喜欢的方式就好。

你可能注意到函数命名是小写的（好吧，如果较长的话会是驼峰命名），而 action 常量会是 `UPPER_CASE_WITH_UNDERSCORES`。同样，这也只是惯例。这会让你一眼区分 action 生成器和 action 常量。但你也可以按你喜欢的方式命名。Redux 并不关心。

现在，如何使用 action 生成器呢？引入然后 dispatch 就好了，当然！

Counter.js

```js
import React from "react";
import { increment, decrement } from './actions';

class Counter extends React.Component {
  state = { count: 0 };

  increment = () => {
    this.props.dispatch(increment()); // << 在这使用
  };

  decrement = () => {
    this.props.dispatch(decrement());
  };

  render() {
    ...
  }
}
```

关键是要记得调用 action creator()！

不要 `dispatch(increment)` 🚫

应该 `dispatch(increment())` ✅

牢记 action 生成器是一个平凡无奇的函数。Dispatch 需要 action 是一个**对象**，而不是函数。

而且：你肯定会在这里出错并且非常困惑。至少一次，或许很多次。那很正常。我有时也**依旧**会忘记。

## 如何使用 React Redux mapDispatchToProps

现在你知道 action 生成器是什么，我们可以讨论**又一个**级别的抽象。（我知道，我**知道**。这是可选的。）

你知道 `connect` 如何传递 `dispatch` 函数吗？你知道你是如何厌倦一直敲 `this.props.dispatch` 并且它看起来多么混乱？（跟我来）

写一个 `mapDispatchToProps` 对象（或者函数！但通常是对象）然后传给你要包装组件的 `connect` 函数，你将收到这些 action 生成器作为**可调用 props**。看代码：

Counter.js

```js
import React from 'react';
import { connect } from 'react-redux';
import { increment, decrement } from './actions';

class Counter extends React.Component {
  increment = () => {
    // 我们可以调用 `increment` prop,
    // 它会 dispatch action:
    this.props.increment();
  }

  decrement = () => {
    this.props.decrement();
  }

  render() {
    // ...
  }
}

function mapStateToProps(state) {
  return {
    count: state.count
  };
}

// 在这个对象中, 属性名会成为 prop 的 names,
// 属性值应该是 action 生成器函数.
// 它们跟 `dispatch` 绑定起来.
const mapDispatchToProps = {
  increment,
  decrement
};

export default connect(mapStateToProps, mapDispatchToProps)(Counter);
```

这很棒，因为它把你从手动调用 `dispatch` 中解放出来。

你可以把 `mapDispatch` 写成一个函数，但是对象能满足 95% 你所需的场景。详细内容请看 [函数式 mapDispatch 以及为什么你可能并不需要它](https://daveceddia.com/redux-mapdispatchtoprops-object-form/)。

## 如何使用 Redux Thunk 获取数据

既然 reducers 应该是“纯”的，我们不能做在 reducer 里面做任何 API 调用或者 dispatch actions。

我们也不能在 action 生成器里面做这些事！

但是如果我们把 action 生成器**返回**一个可以处理我们工作的函数会怎样呢？就像这样：

```js
function getUser() {
  return function() {
    return fetch('/current_user');
  };
}
```

越界了，Redux 不支持这种 actions。固执的 Redux 只接受**简单对象**作为 actions。

这时就需要 redux-thunk 了。它是个中间件，基本是 Redux 的一个插件，它可以使 Redux 处理像上面 `getUser()` 那样的 actions。

你可以像其他 action 生成器一样 dispatch 这些 "thunk actions"：`dispatch(getUser())`。

### "thunk" 是什么？

"thunk" 是（少见）指被其它函数作为返回值的**函数**。

在 Redux 术语中，它是一个返回值为函数而非简单 action 对象的 action 生成器，就像这样：

```js
function doStuff() {
  return function(dispatch, getState) {
    // 在这里 dispatch actions
    // 或者获取数据
    // 或者该干啥干啥
  }
}
```

从技术角度讲，被返回的函数就是 "thunk"，把它作为返回值的就是“action 生成器”。通常我把它们一起称为 "thunk action"。

Action 生成器返回的函数接收两个参数：`dispatch` 函数和 `getState`。

大多数场景你只需要 `dispatch`，但有时你想根据 Redux state 里面的值额外做些事情。这种情况下，调用 `getState()` 你就会获得整个 state 的值然后按需所取。

## 如何安装 Redux Thunk

使用 NPM 或者 Yarn 安装 redux-thunk，运行 `npm install --save redux-thunk`。

然后，在 index.js（或者其他你创建 store 的地方），引入 `redux-thunk` 然后通过 Redux 的 `applyMiddleware` 函数把它应用到 store 中。

```js
import thunk from 'redux-thunk';
import { createStore, applyMiddleware } from 'redux';

function reducer(state, action) {
  // ...
}

const store = createStore(
  reducer,
  applyMiddleware(thunk)
);
```

必须确保 `thunk` 包装在 `applyMiddleware` 调用里面，否则不会生效。不要直接传 `thunk`。

## 结合 Redux 请求数据的例子

设想一下你想展示一个产品列表。你已经获得了后端 API 可以响应 `GET /products`，所以你创建了一个 thunk action 来从后端请求数据：

productActions.js

```js
export function fetchProducts() {
  return dispatch => {
    dispatch(fetchProductsBegin());
    return fetch("/products")
      .then(res => res.json())
      .then(json => {
        dispatch(fetchProductsSuccess(json.products));
        return json.products;
      })
      .catch(error => dispatch(fetchProductsFailure(error)));
  };
}
```

`fetch("/products")` 是实际上请求数据的部分。然后我们在它前后分别做了一些 `dispatch` 调用。

## Dispatch Action 来获取数据

要开始调用并且实际获取数据，我们需要 dispatch `fetchProducts` action。

在哪里调用呢？

如果某一特定的组件需要数据，最好的调用地方通常是在组件刚刚加载**之后**，也就是它的 `componentDidMount` 生命周期函数。

或者，如果你在使用 Hooks，useEffect hook 里面也是个好地方。

有时你要获取整个应用都需要的真正的**全局**数据 —— 如“用户信息”或者“国际化”。这种场景，就在你创建 store 后使用 `store.dispatch` 来 dispatch action，而不是等待组件加载后。

### 如何给 Redux Actions 命名

获取数据的 Redux actions 通常使用标准三连：BEGIN、SUCCESS、FAILURE。这不是硬性要求，只是惯例。

BEGIN/SUCCESS/FAILURE 模式很棒，因为它给你提供钩子来跟踪发生了什么 —— 比如，设置 "loading" 标志为 "true" 以响应 BEGIN 操作，在 SUCCESS 或 FAILURE 之后设为 `false`。

而且，与 Redux 中的其他所有内容一样，这个也是一个惯例，如果你不需要的话可以忽略掉。

在你调用 API **之前**，dispatch BEGIN action。

调用成功**之后**，你可以 dispatch SUCCESS 数据。如果请求失败，你可以 dispatch 错误信息。

有时最后一个调用 ERROR。其实调用什么一点也不重要，只要你保持一致就好。

注意：dispatch Error action 来处理 FAILURE 会导致你跟踪代码的时候毫无头绪，知道 action 正确 dispatch 但是数据却没更新。吸取我的教训 :)

这是那几个 actions，以及它们的 action 生成器：

productActions.js

```js
export const FETCH_PRODUCTS_BEGIN   = 'FETCH_PRODUCTS_BEGIN';
export const FETCH_PRODUCTS_SUCCESS = 'FETCH_PRODUCTS_SUCCESS';
export const FETCH_PRODUCTS_FAILURE = 'FETCH_PRODUCTS_FAILURE';

export const fetchProductsBegin = () => ({
  type: FETCH_PRODUCTS_BEGIN
});

export const fetchProductsSuccess = products => ({
  type: FETCH_PRODUCTS_SUCCESS,
  payload: { products }
});

export const fetchProductsFailure = error => ({
  type: FETCH_PRODUCTS_FAILURE,
  payload: { error }
});
```

接收到 `FETCH_PRODUCTS_SUCCESS` action 返回的产品数据后，我们写一个 reducer 把它存进 Redux store 中。开始请求时把 `loading` 标志设为 true，失败或者完成时设为 false。

productReducer.js

```js
import {
  FETCH_PRODUCTS_BEGIN,
  FETCH_PRODUCTS_SUCCESS,
  FETCH_PRODUCTS_FAILURE
} from './productActions';

const initialState = {
  items: [],
  loading: false,
  error: null
};

export default function productReducer(state = initialState, action) {
  switch(action.type) {
    case FETCH_PRODUCTS_BEGIN:
      // 把 state 标记为 "loading" 这样我们就可以显示 spinner 或者其他内容
      // 同样，重置所有错误信息。我们从新开始。
      return {
        ...state,
        loading: true,
        error: null
      };

    case FETCH_PRODUCTS_SUCCESS:
      // 全部完成：设置 loading 为 "false"。
      // 同样，把从服务端获取的数据赋给 items。
      return {
        ...state,
        loading: false,
        items: action.payload.products
      };

    case FETCH_PRODUCTS_FAILURE:
      // 请求失败，设置 loading 为 "false".
      // 保存错误信息，这样我们就可以在其他地方展示。
      // 既然失败了，我们没有产品可以展示，因此要把 `items` 清空。
      //
      // 当然这取决于你和应用情况：
      // 或许你想保留 items 数据！
      // 无论如何适合你的场景就好。
      return {
        ...state,
        loading: false,
        error: action.payload.error,
        items: []
      };

    default:
      // reducer 需要有 default case。
      return state;
  }
}
```

最后，我们需要把产品数据传给展示它们并且也负责请求数据的 `ProductList` 组件。

ProductList.js

```js
import React from "react";
import { connect } from "react-redux";
import { fetchProducts } from "/productActions";

class ProductList extends React.Component {
  componentDidMount() {
    this.props.dispatch(fetchProducts());
  }

  render() {
    const { error, loading, products } = this.props;

    if (error) {
      return <div>Error! {error.message}</div>;
    }

    if (loading) {
      return <div>Loading...</div>;
    }

    return (
      <ul>
        {products.map(product =>
          <li key={product.id}>{product.name}</li>
        )}
      </ul>
    );
  }
}

const mapStateToProps = state => ({
  products: state.products.items,
  loading: state.products.loading,
  error: state.products.error
});

export default connect(mapStateToProps)(ProductList);
```

我指的是带有 `state.products.<whatever>` 的数据而不仅仅是 `state.<whatever>`，因为我假设你可能会有不止一个 reducer，每一个都处理各自的 state。为了确保这样，我们可以写一个 `rootReducer.js` 文件把它们放在一起：

rootReducer.js

```js
import { combineReducers } from "redux";
import products from "./productReducer";

export default combineReducers({
  products
});
```

然后，当我们创建 store 我们可以传递这个“根” reducer：

index.js

```js
import rootReducer from './rootReducer';

// ...

const store = createStore(rootReducer);
```

## Redux 中错误处理

这里的错误处理比较轻量，但是对大部分调用 API 的 actions 来说基本结构是一样的。基本观点是：

1. 当调用失败时，dispatch 一个 FAILURE action
2. 通过设置一些标志变量和/或保存错误信息来处理 reducer 中的 FAILURE action。
3. 把错误标志和信息（如果有的话）传给需要处理错误的组件，然后根据任何你觉得合适的方式渲染错误信息。

### 能避免重复渲染吗？

这确实个常见问题。是的，它**会**不止一次触发渲染。

它首先会渲染空 state，然后再渲染 loading state，接着会**再次**渲染展示产品。可怕！三次渲染！（如果你直接跳过 "loading" state 就可以把渲染次数将为两次）

你可能会担心不必要的渲染影响性能，但是不会：单次渲染非常快。如果你在开发的应用肉眼可见的慢的话，分析一下找出慢的原因。

这样想吧：当没有商品或者正在加载或者发生错误的时候应用需要展示**一些东西**。在数据准备好之前，你可能不想只展示一个空白屏幕。这给你了一个提供良好用户体验的机会。

## 接下来呢？

希望这篇教程能帮你更加理解 Redux！

如果你想深入了解里面的细节，[Redux 文档](https://redux.js.org/)有很多很好的例子。Mark Erikson (Redux 维护者之一)的博客有一个不错的[常用的 Redux 系列](https://blog.isquaredsoftware.com/series/idiomatic-redux/)。

下周，我会发布一个新课程，[Pure Redux](https://daveceddia.com/pure-redux/)，涵盖这里的所有内容，丰富了更多细节：

- 如何做 immutable 更新
- 使用 Immer 轻松实现 immutable
- 使用 Redux DevTools 调试应用
- 为 reducers、actions 和 thunk actions 编写单元测试

还有一整个模块讲解我们创建一个完整的应用，从开始到结束，包含这些：

- 将 CRUD 操作与 Redux 集成 —— 增删查改
- 创建 API 服务
- 可访问路由以及路由加载时请求数据
- 处理模态对话框
- 将多个 reducer 与 combineReducers 结合使用
- 如何使用选择器以及 `reselect` 以提高性能和可维护性
- 权限和 session 管理
- 管理员和普通用户视图分离

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
