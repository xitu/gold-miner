> * 原文地址：[A Complete React Redux Tutorial for 2019](https://daveceddia.com/redux-tutorial/)
> * 原文作者：[Dave Ceddia](https://daveceddia.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/redux-tutorial.md](https://github.com/xitu/gold-miner/blob/master/TODO1/redux-tutorial.md)
> * 译者：
> * 校对者：

# A Complete React Redux Tutorial for 2019
# 2019 React Redux 完全指南

![A Complete Redux Tutorial (2019): why use it? - store - reducers - actions - thunks - data fetching](https://daveceddia.com/images/complete-redux-tutorial-2019.png)

Trying to understand Redux, it's really confusing how it all works. Especially as a beginner.
想要理解 Redux 的完整工作机制真的让人头疼。特别是作为初学者。

So much terminology! Actions, reducers, action creators, middleware, pure functions, immutability, thunks...
术语太多了！Actions, reducers, action creators, middleware, pure functions, immutability, thunks...

How does it all fit together with React to make a working app?
怎么把所有这些都与 React 结合在一起构建一个可运行应用？

You can spend hours reading blogs and trying to sift through complex "real world" apps trying to piece it together.
你可以花数小时阅读博客以及尝试从复杂的“真实世界”应用中筛选以将它拼凑在一起。

In this Redux tutorial I'm going to explain how to use Redux with React incrementally -- starting with plain React -- and a very simple React + Redux example. I'll explain *why* each feature is useful (and when you can skip some).
在本篇 Redux 教程中，我会渐进地解释如何将 Redux 与 React 搭配使用——从简单的 React 开始——以及一个非常简单的 React + Redux 案例。我会解释**为什么**每个功能都很有用（以及什么情况下做取舍）

Then we'll look at the more advanced topics, one-by-one, until you understand *all of it*. Here we go :)
然后我们会看更加进阶的内容，手把手，直到你*全部*都理解。我们开始吧 :)

Quick warning though: this tutorial is *compleeete*. And by that I mean *looong*. I turned this into a full-fledged free course, *and* I made a nice-looking PDF you can read on your iPad or [whatever Android device is cool these days]. Drop your email in the box to get both right now.
请注意：本教程是*很齐齐齐全的*。也就意味篇幅着*特别长*。我把它变成了一个完整的免费课程，*并且*我制作了好看的 PDF 你可以在 iPad 或者[任何 Android 设备]上阅读。留下你的邮箱地址即可立即获取。

## Redux Essentials in One Video
## 视频概述 Redux 要点

If you prefer watching to reading, this video covers how to add Redux to a React app step-by-step:
如果比起阅读你更喜欢看视频，这个视频涵盖如何在 React 应用中添加 Redux 的每一步：

[Watch this video](https://youtu.be/sX3KeP7v7Kg)
[看这个视频](https://youtu.be/sX3KeP7v7Kg)

This parallels the first part of this tutorial, where we'll take a plain React app and add Redux to it one piece at a time.
这与本教程的第一部分相似，我们都会在一个简单 React 应用中逐步地添加 Redux。

Or, keep reading! The tutorial below covers everything in the video and then some.
或者，继续看下去！本教程不仅涵盖视频中的所有内容，还有其他干货。

## Should You Use Redux?
## 你应该用 Redux 吗？

It's especially valid, in 2019, to wonder... should you still use Redux? Is there something better out now, with Hooks or Context or some other library?
都 9102 年了，弄清楚你是否还应该使用 Redux 特别有用。现在有更好的替代品出现吗，使用 Hooks 或者 Context 或者其他库？

The short answer: Even with plenty of alternatives, [Redux is not dead yet](https://blog.isquaredsoftware.com/2018/03/redux-not-dead-yet/). But whether or not it makes sense for your app... well, it depends.
简而言之：即使有很多替代品，[Redux 仍旧不死](https://blog.isquaredsoftware.com/2018/03/redux-not-dead-yet/)。但是是否适用于你的应用，好吧，得视情况而定。

Super simple? Only a few bits of state in one or two places? Local component state will probably be great. You can do that with classes, [Hooks](https://daveceddia.com/intro-to-hooks/), or both.
超级简单？只有一两个地方需要用到几个 state？组件内部 state 就很好了。你可以通过 classes，[Hooks](https://daveceddia.com/intro-to-hooks/) 或者二者一起来实现。

A bit more complex, with a few "global" things that need to be shared across the app? The [Context API](https://daveceddia.com/context-api-vs-redux/) might be perfect for you.
再复杂一点，有一些“全局”的东西需要在整个应用中共享？[Context API](https://daveceddia.com/context-api-vs-redux/) 可能完美适合你。

Lots of global state, with interactions between disconnected parts of the app? Or a big app that will only get bigger over time? Give Redux a try.
很多全局的 state，与应用中独立部分之间的交互？或者一个大型应用并且随着时间推移只会越来越大？试试 Redux 吧。

You can always add Redux *later*, too. You don't have to decide on Day 1. Start simple and add complexity when and where you need it.
你也可以*以后*再使用 Redux，不必在第一天就下决定。从简单开始，在你需要的时候随时随地增加复杂性。

### Do You Know React Yet?
### 你知道 React 吗？

React can be used on its own without Redux. Redux is an *add-on* to React.
React 可以脱离 Redux 单独使用。Redux 是 React 的*附加项*。

Even if you intend on using them both, I super strongly recommend learning pure React *without* Redux initially. Understand props, state, and one-way data flow, and learn to "think in React" before trying to learn Redux. Learning them both at the same time is a surefire recipe for confusion.
即使你打算同时使用它们，我还是强烈建议先*脱离* Redux 学习纯粹的 React。理解 props，state 以及单向数据流，在学习 Redux 之前先学习“React 编程思想”。同时学习它们是搞晕自己的万全之策。

If you want a primer on React, I put together a 5-day free course that teaches all the basics:
如果你想要 React 的入门读物，我整理了一个为期 5 天的免费课程，教授所有基础知识：

Learn React by building a few simple apps over the next 5 days.
接下来的 5 天通过构建一些简单的应用来学习 React。

Get Lesson 1
第一课

## The Benefits of Redux
## Redux 的好处

If you've used React for more than a few minutes, you probably know about props and one-way data flow. Data is passed *down* the component tree via props. Given a component like this:
如果你稍微使用过 React 一段时间，你可能就了解了 props 和单向数据流。数据通过 props 在组件树间向*下*传递。就像这个组件一样：

![Counter component](https://daveceddia.com/images/counter-component.png)

The `count`, stored in `App`'s state, would be passed down as a prop:
`count` 存在 `App` 的 state 里，会以 prop 的形式向下传递：

![Passing props down](https://daveceddia.com/images/passing-props-down.png)

For data to come back *up* the tree, it needs to flow through a callback function, so that callback function must first be passed *down* to any components that want to call it to pass data up.
要想数据向*上*传递，需要通过回调函数实现，因此必须首先将回调函数向*下*传递到任何想通过调用它来传递数据的组件中。


![Passing callbacks down](https://daveceddia.com/images/passing-callbacks-down.png)

You can think of the data like *electricity*, connected by colored wires to the components that care about it. Data flows down and up through these wires, but the wires can't be run through thin air -- they have to be chained from one component to the next.
你可以把数据想象成*电流*，通过彩色电线连接关心它的组件。数据通过线路上下流动，但是线路不能在空气中贯穿——它们必须从一个组件连接到另一个组件。

### Passing Data Multiple Levels is a Pain
### 多级传递数据是一种痛苦

Sooner or later you run into a situation where a top-level container has some data, and a child 4+ levels down needs that data. Here's an example from Twitter, with all the avatars highlighted:
迟早你会陷入这类场景，顶级容器组件有一些数据，有一个 4 级以上的子组件需要这些数据。这有一个 Twitter 的例子，所有头像都圈出来了：

![Twitter user data](https://daveceddia.com/images/twitter-user-data.png)

Let's pretend the top-level `App` component holds the `user` object in state. The `user` contains the current user's avatar, handle, and other profile info.
我们假设顶级 `App` 组件的 state 有 `user` 对象。该对象包含当前用户头像，昵称和其他资料信息。

In order to deliver the `user` data to all 3 `Avatar` components, the `user` needs to be woven through a bunch of intermediate components that don't need the data.
为了把 `user` 数据传递给全部 3 个 `Avatar` 组件，必须要经过一堆并不需要该数据的中间组件。

![Sending the user data down to the Avatar components](https://daveceddia.com/images/twitter-hierarchy.png)

Getting the data down there is like threading a needle through a mining expedition. Wait that doesn't make any sense. Anyway, *it's a pain*. Also known as "prop-drilling".
获取数据就像在采矿探险中穿针一样。等等，那根本没有意义。无论如何，*这很痛苦*。也被称为 “prop-drilling”。

More importantly, it's not very good software design. Intermediate components are forced to accept and pass along props that they don't care about. This means refactoring and reusing those components will be harder than it needs to be.
更重要的是，这不是好的软件设计。中间组件被迫接受和传递他们并不关心的 props。也就意味着重构和重用这些组件会变得比原本更难。

Wouldn't it be nice if the components that didn't need the data didn't have to see it at all?
如果不需要这些数据的组件根本不用看到它们难道不是很棒吗？

Redux is one way to solve this problem.
Redux 就是解决这个问题的一种方法。

### Passing Data Between Adjacent Components
### 相邻组件间的数据传递

If you have components that are siblings and need to share data, the way to do that in React is to pull that data *up* into a parent component and pass it down with props.
如果你有些兄弟组件需要共享数据，用 React 的方式就是把数据向*上*传到父组件，然后再通过 props 向下传递。

That can be cumbersome though. Redux can help by giving you one global "parent" where you can store the data, and then you can `connect` the sibling components to the data with React-Redux.
但这可能很麻烦。Redux 会为你提供一个可以存储数据的全局 “parent”，然后你可以通过 React-Redux 把兄弟组件和数据 `connect` 起来。

### Use React-Redux to Connect Data to Any Component
### 使用 React-Redux 将数据连接到任何组件

Using the `connect` function that comes with `react-redux`, you can plug any component into Redux's store and pull out the data it needs.
使用 `react-redux` 的 `connect` 函数，你可以将任何组件插入 Redux 的 store 以及取出需要的数据。

![Connecting Redux to the Avatar components](https://daveceddia.com/images/redux-connected-twitter.png)

Redux does some other cool stuff too, like make debugging easier (Redux DevTools let you inspect every single state change), time-travel debugging (you can *roll back* state changes and see how your app looked in the past), and it can make your code more maintainable in the long run. It'll teach you more about functional programming too.
Redux 还做了一些很酷的事情，比如使调试更轻松（Redux DevTools 让你检查每一个 state 的变化），时间旅行调试（你可以*回滚* state 变化，看看你的应用以前的样子），从长远来看，它让代码变得更易于维护。它也会教你更多关于函数式编程的知识。

## Built-in Redux Alternatives
## 内置 Redux 替代品

If Redux seems like overkill for your situation, give these alternatives a look. They're built right in to React.
如果 Redux 对你来说太过繁琐了，可以看看这些替代品。它们内置在 React 中。

### Redux Alternative: The React Context API
### Redux 替代品: The React Context API

Under the hood, React-Redux uses React's built-in Context API to pass data around. If you want to, you can cut out the middleman and use Context directly. You'll miss out on the nice features of Redux mentioned above, but if your app is simple and you want an easy way to pass data around, Context might be perfect.
在底层，React-Redux 使用 React 内置的 Context API 来传递数据。如果你愿意，你可以砍掉“中间商”直接使用 Context。你会错过上面提到的 Redux 很棒的特性，但是如果你的应用很简单并且想用简单的方式传递数据，Context 就够了。

Since you're here, I'm gonna assume you want to learn Redux, and I won't [compare Redux to the Context API](https://daveceddia.com/context-api-vs-redux/) or the [useContext](https://daveceddia.com/usecontext-hook/) and [useReducer](https://daveceddia.com/usereducer-hook-examples/) Hooks right here. You can learn more at those links.
既然你读到这里，我认为你想学习 Redux，我不会在这里[比较 Redux 和 Context API](https://daveceddia.com/context-api-vs-redux/) 或者[使用 Context](https://daveceddia.com/usecontext-hook/) 和[使用 Reducer](https://daveceddia.com/usereducer-hook-examples/) Hooks。你可以点击链接详细了解。

If you want a deep dive on the Context API, watch my course [React Context for State Management](https://egghead.io/courses/react-context-for-state-management) at egghead.
如果你想深入研究 Context API，看我在 egghead 的课程 [React Context 状态管理](https://egghead.io/courses/react-context-for-state-management)

### Another Alternative: Use the `children` Prop
### 其他替代品：使用 `children` Prop

Depending on how you structure your app, you might be able to pass data to child components more directly using a combination of the `children` prop and other props as "slots". You can effectively skip a few levels in the hierarchy if you arrange it right.
取决于你构建应用程序的方式，你可能会用更直接的方式把数据传递给子组件，那就是使用 `children` 和其他 props 结合的方式作为 "slots"。如果你组织的方式正确，就可以有效地跳过层次结构中的几个层级。

I have an article about this ["slots" pattern and how to arrange your component tree](https://daveceddia.com/pluggable-slots-in-react-components/)to pass data more efficiently.
我有一篇相关文章 [“slots” 模式以及如何组织组件树](https://daveceddia.com/pluggable-slots-in-react-components/) 来有效地传递数据。

## Learn Redux, Starting With Plain React
## 学习 Redux，从简单 React 开始

We're going to take an incremental approach, starting with a plain React app with component state, adding parts of Redux piece-by-piece, and dealing with the errors along the way. Let's call it "Error-Driven Development" :)
我们将采用增量的方法，从带有组件 state 的简单 React 应用开始，一点点添加 Redux，以及解决过程中遇到的错误。我们称之为“错误驱动型开发” :)

Here is a counter:
这是一个计数器：

![Counter component](https://daveceddia.com/images/counter-plain.png)

In this example, the Counter component holds the state, and the App surrounding it is a simple wrapper.
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

As a quick review, here's how this works:
快速回顾一下，这是如何工作的：

-   The `count` state is stored in the `Counter` component
-   When the user clicks "+", the button's `onClick` handler is called, which calls the `increment` function.
-   The `increment` function updates the state with the new count.
-   Because state was changed, React re-renders the `Counter` component (and its children), and the new counter value is displayed.

- `count` state 存储在 `Counter` 组件
- 当用户点击 “+” 时，会调用 button 的 `onClick` handler，也就是 `increment` 函数。
- `increment` 函数会更新 state 的 count 值。
- 因为 state 改变了，React 会重绘 `Counter` 组件（以及它的子元素），这样就会显示新计数值。

If you need more detail about how state changes work, go read [A Visual Guide to State in React](https://daveceddia.com/visual-guide-to-state-in-react/) and then come back here.
如果你需要了解 state 变化机制的更多细节，去看 [React 中的 state 可视指南](https://daveceddia.com/visual-guide-to-state-in-react/)然后再回到这里。

But seriously: if the above was *not* review for you, you need to learn how React state works *before* you learn Redux, or it'll be mega-confusing. Take my [free 5-day React course](https://daveceddia.com/pure-react-email-course), gain confidence with plain React, then come back here.
不过说实话：如果上面内容对你来讲*不是*回顾的话，你需要在学 Redux *之前*了解下 React 的 state 如何工作，否则你会巨困惑。参加我 [免费的 5 天 React 课程](https://daveceddia.com/pure-react-email-course)，用简单的 React 获得信息，然后再回到这里。

### Follow Along!
### 接着！

The best way to actually learn this stuff is to try it! So here's a CodeSandbox where you can follow along:
最好的学习方式就是动手尝试！所以这有个 CodeSandbox 你可以跟着做：

--> [Open this CodeSandbox in a separate tab](https://codesandbox.io/s/98153xy79w)
--> [在新 tab 中打开 CodeSandbox](https://codesandbox.io/s/98153xy79w)

I highly recommend you keep the CodeSandbox in sync with the tutorial and actually type out the examples as you go along.
我强烈建议你将 CodeSandbox 与该教程保持同步并且随着你进行时实际动手敲出这些例子。

## Add Redux To The React App
## 在 React 应用中添加 Redux

In CodeSandbox, expand the Dependencies section in the left pane, and click Add Dependency.
在 CodeSandbox 中，展开左侧的 Dependencies 选项，然后点击 Add Dependency。


Search for `redux`, add it, then click Add Dependency again and search for `react-redux` and add it.
搜索 `redux` 添加依赖，然后再次点击 Add Dependency 搜索 `react-redux` 添加。

![](https://daveceddia.com/images/add-redux-in-codesandbox.gif)

In a local project, you can install them with Yarn or NPM: `npm install --save redux react-redux`.
在本地项目，你可以通过 Yarn 或者 NPM 安装：`npm install --save redux react-redux`。

### redux vs react-redux
### redux vs react-redux

`redux` gives you a store, and lets you keep state in it, and get state out, and respond when the state changes. But that's all it does.
`redux` 给你一个 store，让你可以在里面保存 state，取出 state，以及当 state 发生改变时做出响应。但那就是它所有能做的事。

It's actually `react-redux` that lets you connect pieces of the state to React components.
实际上是 `react-redux` 把各个 state 和 React 组件连接起来。

That's right: `redux` knows nothing about React *at all*.
没错：`redux` 对 React *根本*不了解。

These libraries are like two peas in a pod, though. 99.999% of the time, when anyone mentions "Redux" in the context of React, they are referring to both of these libraries in tandem. So keep that in mind when you see Redux mentioned on StackOverflow, or Reddit, or elsewhere.
虽然，这两个库就像豆荚里的两个豌豆。99.999% 的情况下，当任何人在 React 的场景下提到 “Redux”，他们指的是这两个库。因此当你在 StackOverflow、Reddit 或者其他地方看到 Redux 时，记住这一点。

The `redux` library can be used outside of a React app too. It'll work with Vue, Angular, and even backend Node/Express apps.
`redux` 库可以脱离 React 应用使用。它可以和 Vue，Angular 甚至后端的 Node/Express 应用一起使用。

## Redux Has One Global Store
## Redux 有一个全局 Store

We're going to start by looking at just Redux by itself, and just one piece of it: the store.
我们将首先看一下 Redux 本身，只看其中一部分：store。

We've talked about how Redux keeps the state of your app in a single store. And how you can extract parts of that state and plug it into your components as props.
我们已经讨论过 Redux 怎样在一个独立 store 里保存你应用的 state。以及怎样提取 state 的一部分把它作为 props 嵌入你的组件。

You'll often see the words "state" and "store" used interchangeably. Technically, the state is the data, and the store is where it's kept.
你会经常看到 “state” 和 “store” 这两个词互换使用。技术上来讲，state 是数据，store 是保存数据的地方。

So: as step 1 of our refactoring from plain React to Redux, we need to create a store to hold the state.
因此：作为我们从简单的 React 到 Redux 重构的第一步，我们要创建一个 store 来保持 state。

## Create the Redux Store
## 创建 Redux Store

Redux comes with a handy function that creates stores, and it's called `createStore`. Logical enough, eh?
Redux 有一个很方便的函数用来创建 stores，叫做 `createStore`。很合逻辑，嗯？

In `index.js`, let's make a store. Import `createStore` and call it like so:
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

This should fail with the error "Expected the reducer to be a function."
这样会遇到 "Expected the reducer to be a function." 错误。

![Error: Expected the reducer to be a function.](https://daveceddia.com/images/error-expected-reducer-to-be-a-function.png)

### The Store Needs a Reducer
### Store 需要一个 Reducer

So, here's the thing about Redux: it's not very smart.
因此，有件关于 Redux 的事：它并不是非常智能。

You might expect that by creating a store, it would give your state a nice default value. Maybe an empty object, perhaps?
你可能期待通过创建一个 store，它会给你的 state 一个合适的默认值。可能是一个空对象，或许？

But no. No convention-over-configuration here.
但是并非如此。这里没有约定大于配置。

Redux makes *zero* assumptions about the shape of your state. It could be an object, or a number, or a string, or whatever you need. It's up to you!
Redux *不会*对你的 state 做任何假设。它可能是一个 object，一个 number，一个 string，或者任何你需要的。这取决于你。

We have to provide a function that will return the state. That function is called a reducer (we'll see why in a minute). So let's make a really simple one, pass it into `createStore`, and see what happens:
我们必须提供一个返回 state 的函数。这个函数被称为 reducer（我们马上就知道为什么了）。那么我们创建一个非常简单的 reducer，把它传给 `createStore`，然后看会发生什么：

index.js

```js
function reducer(state, action) {
  console.log('reducer', state, action);
  return state;
}

const store = createStore(reducer);
```

After you make this change, open up the console (in CodeSandbox, click the Console button at the bottom).
修改完后，打开控制台（在 CodeSandbox 里，点击底部的 Console 按钮）。

You should see a message logged there, something like this:
你应该可以看到类似这样的日志信息：

![reducer undefined Object { type: @@redux/INIT }](https://daveceddia.com/images/reducer-console-log.png)

(the letters and numbers after INIT are randomized by Redux)
（INIT 后面的字母和数字是 Redux 随机生成的）

Notice how Redux called your reducer at the time you created the store. (To prove it: put a `console.log` immediately after the call to `createStore` and notice how it prints out after the reducer)
注意在你创建 store 的同时 Redux 如何调用你的 reducer。（为了证实这点：调用 `createStore` 之后立即输出 `console.log`，看看 reducer 后面会打印什么）

Also notice how Redux passed a `state` of `undefined`, and the action was an object with a `type` property.
同样注意 Redux 如何传递了一个 `undefined` 的 `state`，同时 action 是一个有 `type` 属性的对象。

We'll talk more about actions in a minute. For now, let's go over the *reducer*.
我们稍后会更多地讨论 actions。现在，我们先看看 *reducer*。

## What Is a Redux Reducer?
## Redux Reducer 是什么？

The term "reducer" might seem a bit scary and foreign, but after this section I think you'll come to agree that it is, as the saying goes, "just a function."
"reducer" 术语看起来可能有点陌生和害怕，但是本节过后，我认为你会同意，正如俗话所说的那样，“只是一个函数”。

Have you ever used the `reduce` function on an array?
你用过数组的 `reduce` 函数吗？

Here's how it works: You pass it a function, and it calls your function once for each element of the array, similar to how `map` works -- you're probably familiar with `map` from rendering lists of things in React.
它是这样用的：你传入一个函数，遍历数组的每一个元素时都会调用你传入的函数，类似 `map` 的作用——你可能在 React 里面渲染列表而对 `map` 很熟悉。

Your function gets called with 2 arguments: the last iteration's result, and the current array element. It combines the current item with the previous "total" result and returns the new total.
你的函数调用时会接收两个参数：上一次迭代的结果，和当前数组元素。它结合当前元素和之前的 “total” 结果然后返回新的 total 值。

This will make more sense with an example:
结合下面例子看会更加清晰明了：

```js
var letters = ['r', 'e', 'd', 'u', 'x'];

// `reduce` takes 2 arguments:
//   - a function to do the reducing (you might say, a "reducer")
//   - an initial value for accumulatedResult
var word = letters.reduce(
  function(accumulatedResult, arrayItem) {
    return accumulatedResult + arrayItem;
  },
''); // <-- notice this empty string argument: it's the initial value

console.log(word) // => "redux"
```

The function you pass in to `reduce` could rightfully be called a "reducer"... because it *reduces* a whole array of items down to a single result.
你给 `reduce` 传入的函数理所应当被叫做 “reducer”，因为它将整个数组的元素 *reduces* 成一个结果。

Redux is *basically* a fancy version of Array's `reduce`. Earlier, you saw how Redux reducers have this signature:
Redux *基本上*是数组 `reduce` 的奇幻版本。之前，你看到 Redux reducers 怎样拥有这个显著特征：

```js
(state, action) => newState
```

Meaning: it takes the current `state`, and an `action`, and returns the `newState`. Looks a lot like the signature of an `Array.reduce` reducer!
含义：它接收当前 `state` 和一个 `action`，然后返回 `newState`。看起来很像 `Array.reduce` 里 reducer 的特点！

```js
(accumulatedValue, nextItem) => nextAccumulatedValue
```

Redux reducers work just like the function you pass to Array.reduce! :) The thing they reduce is actions. They reduce a set of actions (over time) into a single state. The difference is that with Array's reduce it happens all at once, and with Redux, it happens over the lifetime of your running app.
Redux reducers 就像你传给 Array.reduce 的函数作用一样！:) 它们 reduce 的是 actions。它们把一组 actions（随着时间）reduce 成一个单独的 state。不同之处在于 Array 的 reduce 立即发生，而 Redux 则随着正运行应用的生命周期一直发生。

If you're still super unsure, check out my guide to [how Redux reducers work](https://daveceddia.com/what-is-a-reducer/). Otherwise, let's forge ahead.
如果你仍然非常不确定，检查下我的 [Redux reducers 工作机制]指南(https://daveceddia.com/what-is-a-reducer/)。不然，让我们继续向下看。

## Give the Reducer an Initial State
## 给 Reducer 一个初始状态

Remember that the reducer's job is to take the current `state` and an `action` and return the new state.
记住 reducer 的职责是接收当前 `state` 和一个 `action` 然后返回新的 state。

It has another job, too: It should return the initial state the first time it's called. This is sort of like "bootstrapping" your app. It's gotta start somewhere, right?
它还有另一个职责：在首次调用的时候应该返回初始 state。它有点像应用的“引导页”。它必须从某处开始，对吧？

The idiomatic way to do that is to define an `initialState` variable and use the ES6 default argument syntax to assign it to `state`.
惯用的方式是定义一个 `initialState` 变量然后使用 ES6 默认参数给 `state` 赋初始值。

Since we're gonna be moving our `Counter` state into Redux, let's set up its initial state right now. Inside the `Counter` component our state is represented as an object with a `count`, so we'll mirror that same shape here.
既然要把 `Counter` state 迁移到 Redux，让我们先立马创建它的初始 state。在 `Counter` 组件里，我们的 state 是一个有 `count` 属性的对象，所以我们在这创建一个一样的 initialState。

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

If you look at the console again, you'll see it printed `{count: 0}` as the value for `state`. That's what we want.
如果你再看下控制台，你会看到 `state` 打印的值为 `{count: 0}`。那就是我们想要的。

So that brings us to an important rule about reducers.
所以这告诉我们一条关于 reducers 的重要规则。

Important Rule of Reducers #1: Never return undefined from a reducer.
Reducers 重要规则一：reducer 绝不能返回 undefined。

You always want your state to be defined. A defined state is a happy state. An *un*defined state is *un*happy (and will likely break your app).
你总是想让 state 是已定义的。一个已定义的 state 是快乐的 state。一个*未*定义的 state 是*不*快乐的（并且会破坏你的应用）。

## Dispatch Actions to Change the State
## Dispatch Actions 来改变 State

Yep, two new terms at once: we're gonna "dispatch" some "actions."
是的，一下来了两个名字：我们将 “dispatch” 一些 “actions”。

### What is a Redux Action?
### 什么是 Redux Action？

An action is Redux-speak for a plain object with a property called `type`. That's pretty much it. Following those 2 rules, this is an action:
对于具有名为 `type` 的属性的普通对象，action 是 Redux-speak。这就是它。遵循这两个规则，那就是一个 action：

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

Actions are very free-form things. As long as it's an object with a `type` it's fair game.
Actions 的格式非常自由。只要它是个带有 `type` 属性的对象就可以了。

In order to keep things sane and maintainable, we Redux users usually give our actions types that are plain strings, and often uppercased, to signify that they're meant to be constant values.
为了保证事务的合理性和可维护性，我们 Redux 用户通常给 actions 的 type 属性赋简单字符串，并且通常是大写的，来表明它们是常量。

An action object describes a change you want to make (like "please increment the counter") or an event that happenend (like "the request to the server failed with this error").
Action 对象描述你想做出的改变（如“增加 counter”）或者将触发的事件（如“请求服务失败并显示错误信息”）。

Actions, despite their active-sounding name, are boring, inert objects. They don't really *do* anything. Not on their own, anyway.
尽管 Actions 名声响亮，但它是无趣的，呆板的对象。它们事实上不*做*任何事情。反正它们自己不做。

In order to make an action DO something, you need to dispatch it.
为了让 action **做**点事情，你需要 dispatch。

## How Redux Dispatch Works
## Redux Dispatch 工作机制

The store we created earlier has a built-in function called `dispatch`. Call it with an action, and Redux will call your reducer with that action (and then replace the state with whatever your reducer returned).
我们刚才创建的 store 有一个内置函数 `dispatch`。调用的时候携带 action，Redux 调用 reducer 时就会携带 action（然后 reducer 的返回值会更新 state）。

Let's try it out with our store.
我们来试试 store。

index.js

```js
const store = createStore(reducer);
store.dispatch({ type: "INCREMENT" });
store.dispatch({ type: "INCREMENT" });
store.dispatch({ type: "DECREMENT" });
store.dispatch({ type: "RESET" });
```

Add those dispatch calls to your CodeSandbox and check the console.
在你的 CodeSandbox 中添加这些 dispatch 调用然后检查控制台

![reducer undefined Object { type: @@redux/INIT }](https://daveceddia.com/images/dispatching-redux-actions.png)

Every call to `dispatch` results in a call to your reducer!
每一次调用 `dispatch` 最终都会调用 reducer！

Also notice how the state is the same every time? `{count: 0}` never changes.
同样注意到 state 每次都一样？`{count: 0}` 一直没变。


That's because our reducer is not *acting on* those actions. That's an easy fix though. Let's do that now.
这是因为我们的 reducer 没有*作用于*那些 actions。不过很容易解决。开始吧。

## Handle Actions in the Redux Reducer
## 在 Redux Reducer 中处理 Actions

To make actions actually do something, we need to write some code in the reducer that will inspect the `type` of each action and update the state accordingly.
为了让 actions 做点事情，我们需要在 reducer 里面写几行代码来根据每个 action 的 `type` 值来对应得更新 state。

There are a few ways to do this.
有几种方式实现。

You could make a fancy object where you look up a handler function by the action's type...
你可以创建一个对象来通过 action 的 type 来查找对应的处理函数。

Or you could write a bunch of if/else statements...
或者你可以写一大堆 if/else 语句

```js
if(action.type === "INCREMENT") {
  ...
} else if(action.type === "RESET") {
  ...
}
```

Or you could use a simple `switch` statement, which is what I'll show below because it's straightforward, and a very common way to do it.
或者你可以用一个简单的 `switch` 语句，也是我下面采用的方式，因为它很直观，也是这种场景的常用方法。

Some people hate the `switch` though. If that's you -- please feel free to write your reducers however you want :)
尽管有些人讨厌 `switch`，如果你也是——随意用你喜欢的方式写 reducers 就好 :)

Here's how we'll handle the actions:
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

Try this out and take a look at the console.
试一下然后在控制台看看会输出什么。

![reducer undefined Object { type: @@redux/INIT }](https://daveceddia.com/images/handling-redux-actions.png)

Hey look at that! The `count` is changing!
快看！`count` 变了!

We're about ready to hook this up to React, but let's talk about this reducer code for a second.
我们准备好把它连接到 React 了，在此之前让我们先谈谈这段 reducer 代码。

## How to Keep Your Reducers Pure
## 如何保持 Reducers 纯粹

Another rule about reducers is that they must be pure functions. This means that they can't modify their arguments, and they can't have side effects.
另一个关于 reducers 的规则是它们必须是纯函数。也就是说不能修改它们的参数，也不能有 side effects。

Reducer Rule #2: Reducers must be pure functions.
Reducer 规则二：Reducers 必须是纯函数。

A "side effect" is any change to something outside the scope of the function. Don't change variables outside the scope of the function, don't call other functions that change things (like `fetch`, which affects the network and other systems), don't dispatch actions, and so on.
“side effect” 是指对函数作用域之外的任何更改。不要改变函数作用域以外的变量，不要调用其他会改变的函数（比如 `fetch`，跟网络和其他系统有关），也不要 dispatch actions 等。

Technically `console.log` is a side effect, but we'll allow that one.
技术角度来看 `console.log` 是 side effect，但是我们放过它。

The most important thing is this: don't modify the `state` argument.
最重要的事情是：不要修改 `state` 参数。

This means you can't do `state.count = 0` or `state.items.push(newItem)` or `state.count++`, or any other kind of mutation -- not to `state` itself, and not to any of the sub-properties of `state`.
这意味着你不能执行 `state.count = 0`， `state.items.push(newItem)`， `state.count++` 及其他类型的变动——不要对 `state` 本身，及其任何子属性。

Think of it like a game where the only thing you can do is `return { ... }`. It's a fun game. Maddening at first. But you'll get better at it with practice.
你可以把它想成一个游戏，你唯一能做的事就是 `return { ... }`。这是个有趣的游戏。开始会有点恼人。但是通过练习你会变得更好。

I put together a full guide to [How to do Immutable Updates in Redux](https://daveceddia.com/react-redux-immutability-guide/), showing 7 common patterns for updating state within objects and arrays.
我整理了一个[如何在 Redux 里做 Immutable 更新](https://daveceddia.com/react-redux-immutability-guide/)完全指南，包含更新 state 中对象和数组的七个通用模式。

Another great option is to install the [Immer](https://github.com/mweststrate/immer) library and use it in your reducers. Immer lets you write regular mutable-looking code and produces immutable updates automagically. [Learn how to use Immer here](https://daveceddia.com/react-redux-immutability-guide/#easy-state-updates-with-immer).
安装 [Immer](https://github.com/mweststrate/immer) 在 reducers 里面使用也是一种很好的方式。Immer 让你可以像写普通 mutable 代码一样，最终会自动生成 immutable 代码。[点击了解如何使用 Immer](https://daveceddia.com/react-redux-immutability-guide/#easy-state-updates-with-immer)。

My advice: if you're starting a brand new app, use Immer from the beginning. It'll save you a lot of hassle. But I'm showing you the "hard" way because that's how a lot of code still does it, and you're bound to see reducers written without Immer.
建议：如果你是开始一个全新的应用程序，一开始就使用 Immer。它会为你省去很多麻烦。但是我向你展示这种*困难*方式是因为很多代码仍然采用这种方式，你一定会看到没有用 Immer 写的 reducers

## All These Rules...
## 全部规则

Always return a state, never change state, don't connect every component, eat your broccoli, don't stay out past 11... it's exhausting. It's like a rules factory, and I don't even know what that is.
必须返回一个 state，不要改变 state，不要 connect 每一个组件，要吃西兰花，11 点后不要外出···这太很累人。就像一个规则工厂，我甚至不知道那是什么。

Yeah, Redux can be like an overbearing parent. But it comes from a place of love. Functional programming love.
是的，Redux 就像一个霸道的父母。但它是出于爱。函数式编程的爱。

Redux is built on the idea of immutability, because mutating global state is the road to ruin.
Redux建立在不变性的基础上，因为变化的全局 state 是一条废墟之路。

Have you ever tried keeping your state in a global object? It works great at first. Nice and easy. Everything can access the state because it's always available, and making changes is simple.
你试过在全局对象里面保存你的 state 吗？起初它还很好。美妙并且简单。任何东西都能接触到 state 因为它一直是可用的并且很容易更改。

And then the state starts changing in unpredictable ways and it becomes impossible to find the code that's changing it.
然后 state 开始以不可预测的方式发生改变，想要找到改变它的代码变得几乎不可能。

Redux avoids these problems with some simple rules.
为了避免这些问题，Redux 提出了以下规则。

-   State is read-only, and actions are the only way to modify it.
-   Changes happen one way, and one way only: dispatch(action) -> reducer -> new state.
-   The reducer function must be "pure" -- it cannot modify its arguments, and it can't have side effects.

- State 是只读的，唯一修改它的方式是 actions。
- 更新的唯一方式：dispatch(action) -> reducer -> new state。
- Reducer 函数必须是“纯”的——不能修改它的参数，也不能有副作用。

## How to Use Redux with React
## 如何在 React 中使用 Redux

At this point we have a lovely little `store` with a `reducer` that knows how to update the `state` when it receives an `action`.
此时我们有个很小的带有 `reducer` 的 `store`，当接收到 `action` 时它知道如何更新 `state`。

Now it's time to hook up Redux to React.
现在是时候将 Redux 连接到 React 了。

To do that, the `react-redux` library comes with 2 things: a component called `Provider`, and a function called `connect`.
要做到这一点，要用到 `react-redux` 库的两样东西：一个名为 `Provider` 的组件和一个 `connect` 函数。

By wrapping the entire app with the `Provider` component, *every component* in the app tree will be able to access the Redux store if it wants to.
通过用 `Provider` 组件包装整个应用，如果它想的话，应用树里的*每一个组件*都可以访问 Redux store。

In `index.js`, import the `Provider` and wrap the contents of `App` with it. Pass the `store` as a prop.
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

After this, `Counter`, and children of `Counter`, and children of their children, and so on -- all of them can now access the Redux store.
这样之后，`Counter`， `Counter` 的子元素，以及子元素的子元素等等——所有这些现在都可以访问 Redux stroe。

But not automatically. We'll need to use the `connect` function on our components to access the store.
但不是自动的。我们需要在我们的组件使用 `connect` 函数来访问 store。

### How the React-Redux Provider Works
### React-Redux Provider 工作机制

This `Provider` thing might seem like total magic. It is a little bit; it actually uses React's [Context feature](https://daveceddia.com/context-api-vs-redux/) under the hood.
`Provider` 可能看起来像是魔法。有一点点；它在底层实际是用了 React 的 [Context 特性](https://daveceddia.com/context-api-vs-redux/)。

Context is like a secret passageway connected to every component, and using `connect` opens the door to the passageway.
Context 就像是连接每个组件的秘密通道，使用 `connect` 就可打开秘密通道的大门。

Imagine pouring syrup on a pile of pancakes, and how it manages to make its way into ALL the pancakes even though you only poured it on the top one. `Provider`does that for Redux.
想象一下，在一堆煎饼上浇糖浆以及它如何铺满**整个**煎饼的方式，即使你只在最上层倒了糖浆。`Provider` 对 Redux 做了同样的事情。

## Prepare the Counter Component for Redux
## 为 Redux 准备 Counter 组件

Right now the Counter has local state. We're going to rip that out, in preparation to get the `count` as a prop from Redux.
现在 Counter 有了内部 state。我们打算把它干掉，为从 Redux 以 prop 方式获取 `count` 做准备。

Remove the state initialzation at the top and the `setState` calls inside `increment` and `decrement`. Then, replace `this.state.count` with `this.props.count`.
移除顶部的 state 初始化，以及 `increment` 和 `decrement` 内部调用的 `setState`。然后，把 `this.state.count` 替换成 `this.props.count`。

Counter.js

```js
class Counter extends React.Component {
  // state = { count: 0 }; // remove this

  increment = () => {
    /*
    // Remove this
    this.setState({
      count: this.state.count + 1
    });
    */
  };

  decrement = () => {
    /*
    // Also remove this
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
            // Replace state:
            //// this.state.count
            // With props:
            this.props.count
          }</span>
          <button onClick={this.increment}>+</button>
        </div>
      </div>
    );
  }
}
```

This will leave `increment` and `decrement` empty. We'll fill them in again soon.
现在 `increment` 和 `decrement` 是空的。我们会很快再次填充它们。

You'll also notice the count has disappeared -- which it should, because nothing is passing a `count` prop to `Counter` yet.
你会注意到 count 消失了——它确实应该这样，因为目前还没有给 `Counter` 传递 `count` prop。

## Connect the Component to Redux
## 把组件和 Redux Connect 起来

To get the `count` out of Redux, we first need to import the `connect` function at the top of Counter.js:
要从 Redux 获取 `count`，我们首先需要在 Counter.js 顶部引入 `connect` 函数。

Counter.js

```js
import { connect } from 'react-redux';
```

Then we need to "connect" the Counter component to Redux at the bottom:
然后我们需要在底部把 Counter 组件和 Redux “connect” 起来：

Counter.js

```js
// Add this function:
function mapStateToProps(state) {
  return {
    count: state.count
  };
}

// Then replace this:
// export default Counter;

// With this:
export default connect(mapStateToProps)(Counter);
```

Previously we were exporting the component itself. Now we're wrapping it with this `connect` function call, so we're exporting the *connected* Counter. As far as the rest of your app is concerned, this looks like a regular component.
之前我们只导出了组件本身。现在我们用 `connect` 函数调用把它包装起来，这样我们就可以导出 *connected* Counter。至于你的应用程序的其余部分，看起来就像一个常规组件。

And the count should reappear! Except it's frozen until we reimplement increment/decrement.
然后 count 应该就重新出现了！直到我们重新实现 increment/decrement，它是不会变化的。

## How to Use React Redux `connect`
## 如何使用 React Redux `connect`

You might notice the call looks little... weird. Why `connect(mapStateToProps)(Counter)` and not `connect(mapStateToProps, Counter)` or `connect(Counter, mapStateToProps)`? What's that doing?
你可能注意到这个调用看起来有点···奇怪。为什么是 `connect(mapStateToProps)(Counter)` 而不是 `connect(mapStateToProps, Counter)` 或者 `connect(Counter, mapStateToProps)`？它做了什么？

It's written this way because `connect` is a *higher-order function*, which is a fancy way of saying it returns a function when you call it. And then calling *that* function with a component returns a new (wrapped) component.
这样写是因为 `connect` 是一个*高阶函数*，它简单说就是当你调用它时会返回一个函数。然后调用*返回的*函数传入一个组件时，它会返回一个新（包装的）组件。

Another name for this is a [*higher-order component*](https://daveceddia.com/extract-state-with-higher-order-components/) (aka "HOC"). HOCs have gotten some bad press in the past, but it's still quite a useful pattern, and `connect` is a good example of a useful one.
它的另一个名称是 [*高阶组件*](https://daveceddia.com/extract-state-with-higher-order-components/) (简称 "HOC").HOCs 过去曾有过一些糟糕的新闻，但它仍然是一个相当有用的模式，`connect` 就是一个很好的例子。

What `connect` does is hook into Redux, pull out the entire state, and pass it through the `mapStateToProps` function that you provide. This needs to be a custom function because only *you* know the "shape" of the state you've stored in Redux.
`Connect` 做的是在 Redux 内部 hook，取出整个 state，然后把它传进你提供的 `mapStateToProps` 函数。它是个自定义函数，因为只有*你*知道你存在 Redux 里面的 state 的“结构”。

## How mapStateToProps Works
## mapStateToProps 工作机制

`connect` passes the entire state to your `mapStateToProps` function as if to say, "Hey, tell me what you need out of this jumbled mess."
`connect` 把整个 state 传给了你的 `mapStateToProps` 函数，就好像在说，“嘿，告诉我你想从这堆东西里面要什么。”

The object you return from `mapStateToProps` gets fed into your component as props. The example above will pass `state.count` as the value of the `count`prop: the keys in the object become prop names, and their corresponding values become the props' values. So you see, this function literally *defines a mapping from state into props*.
`mapStateToProps` 返回的对象以 props 形式传给了你的组件。以上面为例就是把 `state.count` 的值用 `count` prop 传递：对象的属性变成了 prop 名称，它们对应的值会变成 props 的值。你看，这个函数就像字面含义一样*定义从 state 到 props 的映射*。

By the way -- the name `mapStateToProps` is conventional, but it's not special in any way. You can shorten it to `mapState` or call it whatever you want. As long as it takes the `state` object and returns an object full of props, you're good.
顺便说说——`mapStateToProps` 的名称是使用惯例，但并不是特定的。你可以简写成 `mapState` 或者用任何你想的方式调用。只要你接收 `state` 对象然后返回全是 props 的对象，那就没问题。

### Why not pass the whole state?
### 为什么不传整个 state？

In the example above, our state is *already* in the right shape... and it seems like maybe `mapDispatchToProps` is unnecessary. If it essentially copies the argument (state) into an object that is identical to the state, what good is it?
在上面的例子中，我们的 state 结构*已经*是对的了···看起来 `mapDispatchToProps` 可能是不必要的。如果你实质上复制参数（state）给一个跟 state 相同的对象，这有什么意义呢？

In really small examples that might be all it does, but usually you'll be picking out pieces of data the component needs from a larger collection of state.
在很小的例子中，可能会传全部 state，但通常你只会从更大的 state 集合中选择部分组件需要的数据。

And also, without the `mapStateToProps` function, `connect` won't pass in any state data at all.
并且，没有 `mapStateToProps` 函数，`connect` 不会传递任何 state。

You *could* pass in all of the state, and let the component sort it out. That's not a great habit to get into though, because the component will need to know the shape of the Redux state to pick out what it needs, and it'll be harder to change that shape later, if you need.
你*可以*传整个 state，然后让组件梳理。但那不是一个很好的习惯，因为组件需要知道 Redux state 的结构然后从中挑选它需要的数据，后面如果你想更改结构会变得更难。

## Dispatch Redux Actions from a React Component
## 从 React 组件 Dispatch Redux Actions

Now that our Counter is `connect`ed, we've got the `count` value. Now how can we dispatch actions to change the count?
现在我们的 Counter 已经被 `connect` 了，我们也获取到了 `count` 值。现在我们如何 dispatch actions 来改变 count？

Well, `connect` has your back: in addition to passing in the (mapped) state, it *also* passes in the `dispatch` function from the store!
好吧，`connect` 为你提供支持：除了传递（mapped）state，它*还*从 store 传递了 `dispatch` 函数!

To dispatch an action from inside the Counter, we can call `this.props.dispatch`with an action.
要在 Counter 内部 dispatch action，我们可以调用 `this.props.dispatch` 携带一个 action。

Our reducer is already set up to handle the `INCREMENT` and `DECREMENT` actions, so let's dispatch those from increment/decrement:
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

And now we're done. The buttons should work again.
现在我们完成了.按钮应该又重新生效了。

### Try this! Add a Reset Button
### 试试这个！加一个重置按钮

Here's a little exercise to try: add a "Reset" button to the counter that dispatches the "RESET" action when clicked.
这有个小练习：给 counter 添加”重置“按钮，点击时 dispatch “RESET” action。

The reducer is already set up to handle this action, so you should only need to modify Counter.js.
Reducer 已经写好处理这个 action，因此你只需要修改 Counter.js。

## Action Constants
## Action 常量

In most Redux apps, you'll see action constants used in place of plain strings. It's an extra level of abstraction that can save you some time in the long run.
在大部分 Redux 应用中，你可以看到 action 常量都是一些简单字符串。这是一个额外的抽象级别，从长远来看可以为你节省不少时间。

Action constants help avoid typos, and typos in action names can be a huge pain: no errors, no visible sign that anything is broken, and your actions don't appear to be doing anything? Could be a typo.
Action 常量帮你避免错别字，action 命名的错别字会是一个巨大的痛苦：没有错误，没有哪里坏掉的明显标志，并且你的 action 没有做任何事情？可能是个错别字。

Action constants are easy to write: store your action strings in variables.
Action 常量很容易编写：用变量保存你的 action 字符串。

A good place to put these is in an `actions.js` file (when your app is small, anyway).
把这些变量放在一个 `actions.js` 文件里是个好办法（当你的应用很小时）。

actions.js

```js
export const INCREMENT = "INCREMENT";
export const DECREMENT = "DECREMENT";
```

Then you can import the action names, and use those instead of writing the strings:
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

## What is a Redux Action Creator?
## Redux Action 生成器是什么？

Up til now we've been writing out action objects manually. Like heathens.
现在我们已经手写 action 对象。像个异教徒。

What if you had a *function* that would write them for you? No more mis-written actions!
如果你有一个*函数*会为你编写它会怎么样？不要再误写 actinos 了！

I can tell you think this is crazy. How hard is it to write `{ type: INCREMENT }`without messing up?
我可以告诉你，这很疯狂。手写 `{ type: INCREMENT }` 并保证没有弄乱有多困难？

As your app grows larger, and you have more than 2 actions, and those actions start to get more complex -- passing around more data than just a `type` -- action creators can be helpful to have.
当你的应用变得更大，不止有两个 actions，并且这些 actions 开始变得更负责——要传更多数据而不仅是一个 `type`——action 生成器会帮上大忙。

Like action constants, they're not a *requirement* though. This is another layer of abstraction and if you don't want to bother with it in your app, that's fine.
就像 action 常量一样，但它们不是*必须品*。这是另一层的抽象，如果你不想在你的应用里面使用，那也没关系。

I'll explain what they are anyway, though. You can decide if you want to use them sometimes/always/never.
不过我还是会解释下它们是什么。然后你可以决定你是否有时/总是/绝不想使用它们。

An action creator in Redux terms is a fancy term for function that returns an action object. That's all it is :)
Actions 生成器在 Redex 术语中是一个简单的函数术语，它返回一个 action 对象。就这些 :)

Here are two of them, returning familiar actions. These go nicely in `actions.js`alongside the action constants, by the way.
这是其中两个，返回熟悉的 actions。顺便说一句，它们在 action 常量的 “actions.js” 中完美契合。

actions.js

```js
export const INCREMENT = "INCREMENT";
export const DECREMENT = "DECREMENT";

export function increment() {
  return { type: INCREMENT };
}

export const decrement = () => ({ type: DECREMENT });
```

I wrote them two different ways -- as a `function` and as an arrow -- to show that it doesn't matter how you write them. Pick your fave and go with it.
我用了两种不同方式——一个 `function` 和一个箭头函数——来表明你用哪种方式写并不重要。挑选你喜欢的方式就好。

You'll notice that the function names are camelCase (well, they would be ifTheyWereLonger) while the action constants are `UPPER_CASE_WITH_UNDERSCORES`. That, too, is just a convention. Helps you know if you're looking at an action creator function or an action constant. But feel free to name yours how you like. Redux doesn't care.
你可能注意到函数命名是小写的（好吧，如果较长的话会是驼峰命名），而 action 常量会是 `UPPER_CASE_WITH_UNDERSCORES`。同样，这也只是惯例。这会让你一眼区分 action 生成器和 action 常量。但你也可以按你喜欢的方式命名。Redux 并不关心。

Now... what do you do with an action creator? Import it and dispatch it, of course!
现在，如何使用 action 生成器呢？引入然后 dispatch 就好了，当然！

Counter.js

```js
import React from "react";
import { increment, decrement } from './actions';

class Counter extends React.Component {
  state = { count: 0 };

  increment = () => {
    this.props.dispatch(increment()); // << use it here
  };

  decrement = () => {
    this.props.dispatch(decrement());
  };

  render() {
    ...
  }
}
```

The key thing is to remember to call the action creator()!
关键是要记得调用 action creator()！

Don't `dispatch(increment)` 🚫
不要 `dispatch(increment)` 🚫

Do `dispatch(increment())` ✅
应该 `dispatch(increment())` ✅

Remember that an action creator is a plain old function. Dispatch wants an action *object*, not a function.
牢记 action 生成器是一个平凡无奇的函数。Dispatch 需要 action 是一个*对象*，而不是函数。

Also: you will almost definitely mess this up and be very confused. At least once, probably many times. That's normal. I *still* forget sometimes.
而且：你几乎肯定会出错并且非常困惑。至少一次，或许很多次。那很正常。我有时也*仍然*会忘记。

## How to Use React Redux mapDispatchToProps
## 如何使用 React Redux mapDispatchToProps

Now that you know what an action creator is, we can talk about *one more* level of abstraction. (I know. I KNOW. It's optional though.)
现在你知道 action 生成器是什么，我们可以讨论*又一个*级别的抽象。（我知道，我**知道**。这是选读的。）

You know how `connect` passes in a `dispatch` function? And you know how you get really tired of typing `this.props.dispatch` all the time and it bothers you how messy that looks? (go with me here)
你知道 `connect` 如何传递 `dispatch` 函数吗？你知道你是如何厌倦一直敲 `this.props.dispatch` 并且它看起来多么混乱？（跟我来）

By writing a `mapDispatchToProps` object (or function! but usually object) and passing it to `connect` when you wrap your component, you'll receive those action creators as *callable props*. Here's what I mean:
写一个 `mapDispatchToProps` 对象（或者函数！但通常是对象）然后传给你要包装组件的 `connect` 函数，你将收到这些 action 生成器作为*可调用 props*。看代码：

Counter.js

```js
import React from 'react';
import { connect } from 'react-redux';
import { increment, decrement } from './actions';

class Counter extends React.Component {
  increment = () => {
    // We can call the `increment` prop,
    // and it will dispatch the action:
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

// in this object, keys become prop names,
// and values should be action creator functions.
// They get bound to `dispatch`.
const mapDispatchToProps = {
  increment,
  decrement
};

export default connect(mapStateToProps, mapDispatchToProps)(Counter);
```

This is nice because it saves you from having to call `dispatch` manually.
这很棒，因为它把你从手动调用 `dispatch` 中解放出来。

You can also write `mapDispatch` as a function, but the object covers probably 95% of what you need. You can read more about the [functional mapDispatch form and why you probably don't need it](https://daveceddia.com/redux-mapdispatchtoprops-object-form/).
你可以把 `mapDispatch` 写成一个函数，但是对象能满足 95% 你所需的场景。详细内容请看 [函数式 mapDispatch 以及为什么你可能并不需要它](https://daveceddia.com/redux-mapdispatchtoprops-object-form/)。

## How to Fetch Data with Redux Thunk
## 如何使用 Redux Thunk 获取数据

Since reducers are supposed to be "pure," we can't do any API calls or dispatch actions from inside a reducer.
既然 reducers 应该是“纯” 的，我们不能做在 reducer 里面做任何 API 调用或者 dispatch actions。

We also can't do that stuff inside a plain action creator!
我们也不能在 action creatore 里面做这些事！

But what if we could make an action creator *return* a function that could do our work? Something like this:
但是如果我们把 action 生成器*返回*一个可以处理我们工作的函数会怎样呢？就像这样：

```js
function getUser() {
  return function() {
    return fetch('/current_user');
  };
}
```

Out of the box, Redux doesn't support actions like this. Stock Redux only accepts *plain objects* as actions.
越界了，Redux 不支持这种 actions。固执的 Redux 只接受*简单对象*作为 actions。

This is where redux-thunk comes in. It is a middleware, basically a plugin for Redux, that enables Redux to deal with actions like `getUser()`, above.
这时就需要 redux-thunk 了。它是个中间件，基本是 Redux 的一个插件，它可以使 Redux 处理像上面 `getUser()` 那样的 actions。

You can dispatch these "thunk actions" like any other action creator: `dispatch(getUser())`.
你可以像其他 action 生成器一样 dispatch 这些 "thunk actions"：`dispatch(getUser())`。

### What's a "thunk"?
### "thunk" 是什么？

A "thunk" is a (uncommon) name for a *function* that's returned by another function.
"thunk" 是（少见）指被其它函数作为返回值的*函数*。

In Redux terms, it's an action creator that returns a function instead of a plain action object, like this:
在 Redux 术语中，它是一个返回函数而非简单 action 对象的 action 生成器，就像这样：

```js
function doStuff() {
  return function(dispatch, getState) {
    // dispatch actions here
    // or fetch data
    // or whatever
  }
}
```

If you wanna get technical, the function being returned is the "thunk", and the one that returns it is the "action creator". Usually I call the whole bundle a "thunk action."
从技术角度讲，被返回的函数就是 "thunk"，把它作为返回值的就是“action 生成器”。通常我把它们一起称为 "thunk action"。

The function you return from your action creator will be passed 2 arguments: the `dispatch` function, and `getState`.
Action 生成器返回的函数接收两个参数：`dispatch` 函数和 `getState`。

Most of the time you'll only need `dispatch`, but sometimes you want to do something conditionally, based on some value in the Redux state. In that case, call `getState()` and you'll have the entire state to read as needed.
大多数场景你只需要 `dispatch`，但有时你想根据 Redux state 里面的值额外做些事情。这种情况下，调用 `getState()` 你就会获得整个 state 的值然后按需所取。

## How to Setup Redux Thunk
## 如何安装 Redux Thunk

To install redux-thunk with NPM or Yarn, run `npm install --save redux-thunk`.
使用 NPM 或者 Yarn 安装 redux-thunk，运行 `npm install --save redux-thunk`。

Then, in index.js (or wherever you create your store), import `redux-thunk` and apply it to the store with Redux's `applyMiddleware` function:
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

Just make sure to wrap `thunk` in the `applyMiddlware` call or it won't work. Don't pass `thunk` directly.
必须确保 `thunk` 包装在 `applyMiddleware` 调用里面，否则不会生效。不要直接传 `thunk`。

## An Example of Fetching Data with Redux
## 结合 Redux 请求数据的例子

Let's imagine you want to display a list of products. You've got a backend API that answers to `GET /products`, so you create this thunk action to do the fetching:
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

The `fetch("/products")` part is what's actually fetching the data. Then we have a few calls to `dispatch` before and after.
`fetch("/products")` 是实际上请求数据的部分。然后我们在它前后分别做了一些 `dispatch` 调用。

## Dispatch the Action to Fetch the Data
## Dispatch Action 来请求数据

To kick off the call and actually fetch the data, we need to dispatch the `fetchProducts` action.
要启动调用并且实际获取数据，我们需要 dispatch `fetchProducts` action。

Where should you do it?
在哪里调用呢？

If a particular component needs the data, the best place to kick off the fetch is usually right *after* that component mounts, in its `componentDidMount` lifecycle method.
如果某一特定的组件需要数据，最好的调用地方通常是在组件加载*之后*，也就是它的 `componentDidMount` 生命周期函数。

Or, if you're using Hooks, inside the useEffect hook is a good spot.
或者，如果你在使用 Hooks，useEffect hook 里面也是个好地方。

Sometimes you're fetching truly *global* data that the whole app needs -- think "user profile" or "i18n translations". In those cases, dispatch the action right after you create the store, with `store.dispatch`, rather than waiting for a component to mount.
有时你要获取整个应用都需要的真正的*全局*数据——如 "用户信息" 或者 "国际化"。这种场景，就在你创建 store 后使用 `store.dispatch` 来 dispatch action，而不是等待组件加载后。

### How to Name Your Redux Actions
### 如何给 Redux Actions 命名

Redux actions that fetch data usually come in triplets: BEGIN, SUCCESS, FAILURE. This isn't a requirement, it's only a convention.
获取数据的 Redux actions 通常使用标准三连：BEGIN, SUCCESS, FAILURE。这不是硬性要求，只是惯例。

This BEGIN/SUCCESS/FAILURE pattern is nice because it gives you hooks to keep track of what's happening -- say, by setting a "loading" flag `true` in response to the BEGIN action, and then `false` after SUCCESS or FAILURE.
BEGIN/SUCCESS/FAILURE 模式很棒，因为它给你钩子来跟踪发生了什么——比如，设置 "loading" 标志为 "true" 以响应 BEGIN 操作，在 SUCCESS 或 FAILURE 之后设为 `false`。

And, as with pretty much everything else in Redux... this, too, is a convention you can feel free to ignore if you don't you need it.
而且，与 Redux 中的其他所有内容一样，这个也是一个惯例，如果你不需要的话可以忽略掉。

*Before* you start the API call, you dispatch the BEGIN action.
在你调用 API *之前*，dispatch BEGIN action。

Then *after* the call succeeds, you dispatch SUCCESS with the data. If it failed instead, you dispatch FAILURE with the error.
调用成功*之后*，你可以 dispatch SUCCESS 数据。如果请求失败，你可以 dispatch 错误信息。

Sometimes the last one is called ERROR instead. It doesn't really matter what you call it, as long as you're consistent about it.
有时最后一个调用 ERROR。其实调用什么一点也不重要，只要你保持一致就好。

Careful: Dispatching an ERROR action and handling a FAILURE will lead to no end of hair pulling as you trace through your code, realizing the action is dispatching correctly but the data is never updating. Learn from my mistakes :)
注意：dispatch Error action 来处理 FAILURE 会导致你跟踪代码的时候毫无头绪，知道 action 正确 dispatch 但是数据却没更新。吸取我的教训 :)

Here's what those actions look like, along with action creators for them:
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

We'll write a reducer to save the products into the Redux store when it receives the `FETCH_PRODUCTS_SUCCESS` action. It'll also set a `loading` flag to true when the fetch begins, and false when it finishes or fails.
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
      // Mark the state as "loading" so we can show a spinner or something
      // Also, reset any errors. We're starting fresh.
      return {
        ...state,
        loading: true,
        error: null
      };

    case FETCH_PRODUCTS_SUCCESS:
      // All done: set loading "false".
      // Also, replace the items with the ones from the server
      return {
        ...state,
        loading: false,
        items: action.payload.products
      };

    case FETCH_PRODUCTS_FAILURE:
      // The request failed. It's done. So set loading to "false".
      // Save the error, so we can display it somewhere.
      // Since it failed, we don't have items to display anymore, so set `items` empty.
      //
      // This is all up to you and your app though:
      // maybe you want to keep the items around!
      // Do whatever seems right for your use case.
      return {
        ...state,
        loading: false,
        error: action.payload.error,
        items: []
      };

    default:
      // ALWAYS have a default case in a reducer
      return state;
  }
}
```

Finally, we need to pass the products into a `ProductList` component that will display them, and also be responsible for kicking off the data fetching.
最后，我们需要把产品数据传进展示它们并且也负责开始数据请求的 `ProductList` 组件。

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

I'm referring to the data with `state.products.<whatever>` instead of just `state.<whatever>` because I'm making the assumption that you'll probably have more than one reducer, each handling its own slice of state. To make this work, we can write a `rootReducer.js` file that pulls them all together:
我指的是带有 `state.products.<whatever>` 的数据而不仅仅是 `state.<whatever>`，因为我假设你可能会有不止一个 reducer，每一个都处理各自的 state。为了确保这样，我们可以写一个 `rootReducer.js` 文件把它们维护在一起：

rootReducer.js

```js
import { combineReducers } from "redux";
import products from "./productReducer";

export default combineReducers({
  products
});
```

Then, when we create our store, we can pass this "root" reducer:
然后，当我们创建 store 我们可以传递这个"根" reducer：

index.js

```js
import rootReducer from './rootReducer';

// ...

const store = createStore(rootReducer);
```

## Error Handling in Redux
## Redux 中错误处理

The error handling here is pretty light, but the basic structure will be the same for most actions that make API calls. The general idea is:
这里的错误处理比较轻量，但是对大部分调用 API 的 actions 来说基本结构是一样的。基本观点是：

1.  Dispatch a FAILURE action when the call fails
2.  Handle that FAILURE action in the reducer by setting some kind of flag and/or saving the error message.
3.  Pass the error flag and the message (if you have one) into components that need to handle errors, and conditionally render the error however you see fit.

1. 当调用失败时，dispatch 一个 FAILURE action。
2. 通过设置一些标志变量和/或保存错误信息来处理 reducer 中的 FAILURE action。
3. 把错误标志和信息（如果有的话）传给需要处理错误的组件，然后根据任何你觉得合适的方式渲染错误。

### Can You Avoid the Double Render?
### 如果避免二次渲染？

This is a really common concern. And yes, it *will* render more than once.
这确实个常见问题。是的，它*会*不止一次触发渲染。

It will render in an empty state, then re-render in a loading state, and then re-render *again* with products to show. The horror! 3 renders! (you could get it down to 2 if you skip straight to the "loading" state)
它首先会渲染空 state，然后再渲染 loading state，接着会*再次*渲染展示产品。可怕！三次渲染！（如果你直接跳过 "loading" state 就可以把渲染次数将为两次）

You may be worried about unnecessary renders because of performance, but don't be: single renders are very fast. If you're working on an app where they are slow enough to notice, do some profiling and figure out why that's the case.
你可能会担心不必要的渲染影响性能，但是不会：单次渲染非常快。如果你在开发的应用肉眼可见的慢的话，分析一下找出慢的原因。

Think of it this way: the app needs to show *something* when there are no products, or when they're loading, or when there's an error. You probably don't want to just show a blank screen until the data is ready. This gives you an opportunity to make that user experience shine.
这样想吧：当没有商品或者正在加载或者发生错误的时候应用需要展示*一些东西*。在数据准备好之前，你可能不想只展示一个空白屏幕。这给你了一个提供良好用户体验的机会。

## What Next?
## 接下来呢？

Hopefully this tutorial helped you make more sense of Redux!
希望这篇教程能帮你更加理解 Redux！

If you want a deep dive on the specifics, the [Redux docs](https://redux.js.org/) have a lot of good examples. Mark Erikson (one of the Redux maintainers) has a good [series on idiomatic Redux](https://blog.isquaredsoftware.com/series/idiomatic-redux/) at his blog, too.
如果你想深入了解里面的细节，[Redux 文档](https://redux.js.org/)有很多很好的例子。Mark Erikson (Redux 维护者之一)的博客有一个不错的 [常用的 Redux 系列](https://blog.isquaredsoftware.com/series/idiomatic-redux/)。

And next week, I am releasing a new course, [Pure Redux](https://daveceddia.com/pure-redux/), covering everything here, plus more detail on:
下周，我会发布一个新课程，[纯 Redux](https://daveceddia.com/pure-redux/)，涵盖这里的所有，加上更多细节：

-   How to do immutable updates
-   Using Immer for easy immutability
-   Debugging apps with the Redux DevTools
-   Writing tests for reducers, actions, and thunk actions

- 如何做 immutable 更新
- 使用 Immer 轻松实现不变性
- 使用 Redux DevTools 调试应用
- 为 reducers, actions, 和 thunk actions 编写单元测试

And there's a whole module where we build a full app, beginning to end, covering things like:
并且有一整个模块讲解我们创建创建一个完整的应用，从开始到结束，涵盖这些：

-   Integrating CRUD operations with Redux -- creating, listing, editing, and deleting items
-   Setting up an API server
-   Routing with Reach Router, and fetching data when routes load
-   Handling modal dialogs
-   Combining multiple reducers with combineReducers
-   How to use Selectors and `reselect` to improve performance & maintainability
-   Authentication and session management
-   Separate views for Admins and Users

- 将 CRUD 操作与 Redux 集成——增删查改
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
