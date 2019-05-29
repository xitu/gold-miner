> * 原文地址：[Redux vs. The React Context API](https://daveceddia.com/context-api-vs-redux/)
> * 原文作者：[Dave Ceddia](https://daveceddia.com)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/context-api-vs-redux.md](https://github.com/xitu/gold-miner/blob/master/TODO1/context-api-vs-redux.md)
> * 译者：[Xuyuey](https://github.com/Xuyuey)
> * 校对者：[Minghao](https://github.com/Minghao23), [Baddyo](https://github.com/Baddyo)

# Redux vs. React 的 Context API

![](https://daveceddia.com/images/context-vs-redux.png)

React 在 16.3 版本里面引入了新的 Context API —— 说它是**新的**是因为**老版本**的 context API 是一个幕后的试验性功能，大多数人要么不知道，要么就是依据官方文档所说，尽量避免使用它。

但是，现在 Context API 摇身一变成为了 React 中的一等公民，对所有人开放（不像是之前那样，现在是被官方所提倡使用的）。

React 16.3 版本一发布，宣称新的 Context API 将要取缔 Redux 的文章在网上铺天盖地而来。但是，如果你去问问 Redux，我认为它会说“那些宣告我会死亡的报道实在是[言过其实](https://blog.isquaredsoftware.com/2018/03/redux-not-dead-yet/)”。

在这篇文章中，我想向大家介绍一下新的 Context API 是如何工作的，它与 Redux 的相似之处，什么情况下可以使用 Context API **而不是** Redux，以及为什么不是所有情况下 Context API 都可以替换 Redux 的原因。

**如果你只是想了解 Context 的概述，可以[跳转到这一节](#如何使用-react-context-api)。**

## 一个简单的 React 例子

这里假设你已经了解了 React 的基础知识（props 和 state），但是如果你还没有，你可以参加我的 5 天免费课程，来学习 React 基础知识。

让我们看一个可以让大多数人接触 Redux 的例子。我们将从一个单纯的 React 版本开始介绍，然后看看它在 Redux 中的样子，最后是 Context。

![组件层级](https://daveceddia.com/images/context-v-redux-app-screenshot.png)

在该应用中用户信息显示在两个位置：导航栏的右上角以及主要内容旁边的侧边栏。

（你可能会注意到它看起来很像 Twitter。这绝对不是碰巧的！磨练 React 技能的最佳方法之一就是通过[复制 —— 构建现有应用的副本](https://daveceddia.com/learn-react-with-copywork/)）。

组件结构如下所示：

![组件层级](https://daveceddia.com/images/context-v-redux-app-tree.png)

使用纯 React（仅仅是常规的 props），我们需要在组件树中足够高的位置存储用户信息，这样我们才可以将它向下传递给每一个需要它的组件。在我们的例子中，用户信息必须存储在 `App` 中。

接着，为了将用户信息向下传递给需要它的组件，App 需要先将它传递给 Nav 和 Body。然后，**再次**向下传递给 UserAvatar（万岁！终于到了）和 Sidebar。最后，Sidebar 还要再将它传递给 UserStats。

让我们来看看代码是怎么工作的（为了方便阅读，我将所有的内容放在一个文件内，但实际上这些内容可能会按照[某种标准结构](https://daveceddia.com/react-project-structure/)分成几个文件）。

```js
import React from "react";
import ReactDOM from "react-dom";
import "./styles.css";

const UserAvatar = ({ user, size }) => (
  <img
    className={`user-avatar ${size || ""}`}
    alt="user avatar"
    src={user.avatar}
  />
);

const UserStats = ({ user }) => (
  <div className="user-stats">
    <div>
      <UserAvatar user={user} />
      {user.name}
    </div>
    <div className="stats">
      <div>{user.followers} Followers</div>
      <div>Following {user.following}</div>
    </div>
  </div>
);

const Nav = ({ user }) => (
  <div className="nav">
    <UserAvatar user={user} size="small" />
  </div>
);

const Content = () => <div className="content">main content here</div>;

const Sidebar = ({ user }) => (
  <div className="sidebar">
    <UserStats user={user} />
  </div>
);

const Body = ({ user }) => (
  <div className="body">
    <Sidebar user={user} />
    <Content user={user} />
  </div>
);

class App extends React.Component {
  state = {
    user: {
      avatar:
        "https://www.gravatar.com/avatar/5c3dd2d257ff0e14dbd2583485dbd44b",
      name: "Dave",
      followers: 1234,
      following: 123
    }
  };

  render() {
    const { user } = this.state;

    return (
      <div className="app">
        <Nav user={user} />
        <Body user={user} />
      </div>
    );
  }
}

ReactDOM.render(<App />, document.querySelector("#root"));
```

[查看 CodeSandbox 中的在线示例](https://codesandbox.io/s/q8yqx48074)。

在这里，`App` [初始化 state](https://daveceddia.com/where-initialize-state-react/) 时已经包含了 “user” 对象 —— 但是在真实应用中你可能会需要[从服务器上获取该数据](https://daveceddia.com/ajax-requests-in-react/)并将它保存在 state 中，以便渲染。

这种 prop drilling（译者注：属性的向下传递）的方式，并非**糟糕**的做法。它工作的还不错。并不是所有情况下都不鼓励 “prop drilling”；它是一种完美的有效模式，是支持 React 工作的核心。但是如果组件的层次太深，在你编写的时候就会有点烦人。特别是当你向下传递不止一个属性，而是一大堆的时候，它会变得更加烦人。

然而，这种 “prop drilling” 策略有一个更大的缺点：它会让本应该独立的组件耦合在一起。在上面的例子中，`Nav` 组件需要接收一个 “user” 属性，再将它传递给 `UserAvatar`，即使 `Nav` 中没有任何其它的地方需要用到 `user` 属性。

紧密耦合的组件（就像那些向它们的子组件传递属性的组件）更加难以被复用，因为无论什么时候你要在新的地方使用它，你都必须将它们和新的父组件联系起来。

让我们来看看如何改进。

## 在使用 Context 或者 Redux 之前……

如果你可以找到一种方法来**合并**应用的结构，并利用好 `children` 属性，这样，无需借助深层次的 prop drilling **或是 Context，或是 Redux**，你也可以让代码结构变得更清晰。

对于那些需要使用通用占位符的组件，例如本例中的 `Nav`、`Sidebar` 和 `Body`，children 属性是一个很好的解决方案。还要知道，你可以传递 JSX 元素给**任意**属性，并不仅仅是 “children” —— 所以如果你想使用不止一个 “slot” 来插入组件时，请记住这一点。

这个例子中 `Nav`、`Sidebar` 和 `Body` 接收 children，然后按照它们的样子渲染出来。这样，组件的使用者不用担心传递给组件的特定数据 —— 他只需要使用组件内定义的数据，并按照组件的原始需求简单地渲染组件。这个例子中还说明了怎样使用**任意**属性传递 children。

（感谢 Dan Abramov 的[这个建议](https://twitter.com/dan_abramov/status/1021850499618955272)！)

```js
import React from "react";
import ReactDOM from "react-dom";
import "./styles.css";

const UserAvatar = ({ user, size }) => (
  <img
    className={`user-avatar ${size || ""}`}
    alt="user avatar"
    src={user.avatar}
  />
);

const UserStats = ({ user }) => (
  <div className="user-stats">
    <div>
      <UserAvatar user={user} />
      {user.name}
    </div>
    <div className="stats">
      <div>{user.followers} Followers</div>
      <div>Following {user.following}</div>
    </div>
  </div>
);

// 接收并渲染 children
const Nav = ({ children }) => (
  <div className="nav">
    {children}
  </div>
);

const Content = () => (
  <div className="content">main content here</div>
);

const Sidebar = ({ children }) => (
  <div className="sidebar">
    {children}
  </div>
);

// Body 需要一个 sidebar 和 content，但是可以按照这样的方式写，
// 它们可以是任意属性
const Body = ({ sidebar, content }) => (
  <div className="body">
    <Sidebar>{sidebar}</Sidebar>
    {content}
  </div>
);

class App extends React.Component {
  state = {
    user: {
      avatar:
        "https://www.gravatar.com/avatar/5c3dd2d257ff0e14dbd2583485dbd44b",
      name: "Dave",
      followers: 1234,
      following: 123
    }
  };

  render() {
    const { user } = this.state;

    return (
      <div className="app">
        <Nav>
          <UserAvatar user={user} size="small" />
        </Nav>
        <Body
          sidebar={<UserStats user={user} />}
          content={<Content />}
        />
      </div>
    );
  }
}

ReactDOM.render(<App />, document.querySelector("#root"));
```

[查看 CodeSandbox 中的在线示例](https://codesandbox.io/s/mj19ywz0oy)。

如果你的应用太复杂了（比这个例子更复杂！），也许很难弄清楚如何调整 `children` 模式。让我们来看看如何用 Redux 替换 prop drilling。

## 使用 Redux 的例子

这里我会快速过一下 Redux 示例，这样我们可以多用点时间深入地了解 Context 的工作原理，所以如果你不是很清楚 Redux，可以先去看看我的 [Redux 简介](https://daveceddia.com/how-does-redux-work/)（或者[观看视频](https://youtu.be/sX3KeP7v7Kg)）。

我们使用的还是上面的 React 应用，这里我们将它重构为 Redux 版本。`user` 信息被移入了 Redux 存储，这意味着我们可以使用 react-redux 的 `connect` 函数，直接将 `user` 属性注入到需要它的组件中。

这在解耦方面是一个巨大的胜利。看看 `Nav`、`Sidebar` 和 `Body`，你会发现它们不再接收和向下传递 `user` 属性了。不用再玩 props 这块烫手山芋了。当然也不会有更多不必要的耦合。

这里的 reducer 没有做很多工作；非常的简单。我在其它地方有更多关于 [Redux Reducer 如何工作](https://daveceddia.com/what-is-a-reducer/)以及[如何编写其中的不可变代码](https://daveceddia.com/react-redux-immutability-guide/)的文章，你可以看看。

```js
import React from "react";
import ReactDOM from "react-dom";

// 我们需要 createStore、connect 和 Provider:
import { createStore } from "redux";
import { connect, Provider } from "react-redux";

// 创建一个初始 state 为空的 reducer
const initialState = {};
function reducer(state = initialState, action) {
  switch (action.type) {
    // 响应 SET_USER 行为并更新
    // 相应的 state
    case "SET_USER":
      return {
        ...state,
        user: action.user
      };
    default:
      return state;
  }
}

// 使用 reducer 创建 store
const store = createStore(reducer);

// 触发设置 user 的行为
// （因为 user 初始化时为空）
store.dispatch({
  type: "SET_USER",
  user: {
    avatar: "https://www.gravatar.com/avatar/5c3dd2d257ff0e14dbd2583485dbd44b",
    name: "Dave",
    followers: 1234,
    following: 123
  }
});

// 函数 mapStateToProps 从 state 对象中提取 user 值
// 并将它作为 `user` 属性传递
const mapStateToProps = state => ({
  user: state.user
});

// connect() UserAvatar 以便它可以直接接收 `user` 属性，
// 而无需从上层组件中获取

// 也可以把它分成下面 2 个变量：
//   const UserAvatarAtom = ({ user, size }) => ( ... )
//   const UserAvatar = connect(mapStateToProps)(UserAvatarAtom);
const UserAvatar = connect(mapStateToProps)(({ user, size }) => (
  <img
    className={`user-avatar ${size || ""}`}
    alt="user avatar"
    src={user.avatar}
  />
));

// connect() UserStats 以便它可以直接接收 `user` 属性，
// 而无需从上层组件中获取
// （同样使用 mapStateToProps 函数）
const UserStats = connect(mapStateToProps)(({ user }) => (
  <div className="user-stats">
    <div>
      <UserAvatar />
      {user.name}
    </div>
    <div className="stats">
      <div>{user.followers} Followers</div>
      <div>Following {user.following}</div>
    </div>
  </div>
));

// Nav 不再需要知道 `user` 属性
const Nav = () => (
  <div className="nav">
    <UserAvatar size="small" />
  </div>
);

const Content = () => (
  <div className="content">main content here</div>
);

// Sidebar 也不再需要知道 `user` 属性
const Sidebar = () => (
  <div className="sidebar">
    <UserStats />
  </div>
);

// body 同样不需要知道 `user` 属性
const Body = () => (
  <div className="body">
    <Sidebar />
    <Content />
  </div>
);

// App 不再需要保存 state，
// 所以可以把它写成一个无状态组件
const App = () => (
  <div className="app">
    <Nav />
    <Body />
  </div>
);

// 用 Provider 包裹整个 App，
// 以便 connect() 可以连接到 store
ReactDOM.render(
  <Provider store={store}>
    <App />
  </Provider>,
  document.querySelector("#root")
);
```

[查看 CodeSandbox 中的在线示例](https://codesandbox.io/s/943yr0qp3o)。

现在你可能想知道 Redux 如何能实现这样神奇的功能。“想知道”是一件好事情。React 不支持跨越多个层级传递属性，那为何 Redux 可以实现呢？

答案是 Redux 使用了 React 的 **context**（**上下文**）特性。不是现在我们说的 Context API（还不是）—— 而是旧的那个。就是 React 文档说不要使用的那个，除非你在写库文件或者你知道在做什么。

Context 就像一个在每个组件背后运行的电子总线：要接收它传递的电源（数据），你只需要插入插头就好。而（React-）Redux 的 `connect` 函数就是做这件事的。

不过，Redux 的这个功能只是冰山一角。可以在所有地方传递数据只是 Redux 最**明显**的功能。以下是你可以开箱即用的其他一些好处：

### `connect` 使你的组件很纯粹

`connect` 可以让被连接的组件很“纯粹”，意味着它们只需要在自己的属性改变时重新渲染 —— 也就是在它们的 Redux 状态切片发生改变时。这可以防止不必要的重复渲染，使你的应用能够快速运行。DIY 方法：创建一个类继承 `PureComponent`，或是自己实现 `shouldComponentUpdate`。

### 使用 Redux 轻松调试

虽然写 action 和 reducer 有一点复杂，但是我们可以使用它提供给我们的强大调试能力来平衡这一点。

使用 [Redux DevTools 扩展](https://github.com/zalmoxisus/redux-devtools-extension)，应用程序执行的每个操作都会被自动记录下来。你可以随时打开它，查看触发的操作，有效负载是什么，以及操作发生前后的 state。

![Redux 调试工具示例](https://daveceddia.com/images/redux-devtools.gif)

Redux DevTools 提供了另一个很棒的功能 —— **time travel debugging**（**时间旅行调试**），也就是说，你可以点击任何过去的动作并跳转到那个时间点，它基本上可以重放每一个动作，包括现在的那个，但不包括还没有触发的动作。其原理是每个动作都会**不可变**地更新 state，所以你可以拿到记录了 state 更新的列表并重放它们，跳转到你想去的地方，而且没有任何副作用。

而且目前有像 [LogRocket](https://logrocket.com/) 这样的工具，可以为你的每一个用户在**生产环境**中提供一个永远在线的 Redux DevTools。有 bug 报告？没关系。在 LogRocket 中查找该用户的会话，你可以看到他们所做的所有事情以及确切触发的操作。这一切都可以通过使用 Redux 的操作流来实现。

### 使用中间件自定义 Redux

Redux 支持**中间件**（**middleware**）的概念，代表着“每次调度某个动作之前都会运行的函数”。编写自己的中间件并不像看起来那么难，它可以实现一些强大的功能。

例如……

* 想要在每个命名以 `FETCH_` 开头的操作中提交 API 请求？你可以使用中间件。
* 想要为你的分析软件在一个集中的地方记录事件的日志？中间件是一个好地方。
* 想要在特定的时间阻止某些行为的触发？你可以用中间件实现，而且对应用的其它部分是透明的。
* 想要拦截具有 JWT 令牌的操作并自动将其保存到 localStorage？是的，你还可以用中间件。

这里有一篇很好的文章，里面有一些[如何编写 Redux 中间件的示例](https://medium.com/@jacobp100/you-arent-using-redux-middleware-enough-94ffe991e6)。

## 如何使用 React Context API

但是，也许你不需要 Redux 所有那些花哨的功能。也许你不关心简单调试、自定义或是性能的自动化提升 —— 你想做的只是轻松地传递数据。也许你的应用很小，或者现在你只是需要让应用运转起来，以后再去考虑那些花哨的东西。

React 的新 Context API 可能符合你的要求。让我们看看它是如何工作的。

如果你更愿意看视频（时长 3:43）而不是读文章，我在 Egghead 上发布了一个简短的 Context API 课程：

[![Egghead.io 上的 Context API 课程](https://daveceddia.com/images/context-api-egghead-video.png)](https://egghead.io/lessons/react-pass-props-through-multiple-levels-with-react-s-context-api)

Context API 中有 3 个重要的部分：

* `React.createContext` 函数：创建上下文
* `Provider`（由 `createContext` 返回）：在组件树中构建“电子总线”
* `Consumer`（同样由 `createContext` 返回）：接入“电子总线”来获取数据

这里的 `Provider` 和 React-Redux 的 `Provider` 非常相似。它接收一个 `value` 属性，这个属性可以是任何你想要的东西（甚至可以是一个 Redux store……但是这很傻）。它很可能是一个对象，包括你的数据以及你希望对数据执行的操作。

这里的 `Consumer` 工作方式有点像 React-Redux 的 `connect` 函数，接收数据以供组件使用。

以下是重点：

```js
// 在最开始，我们创建了一个新的上下文
// 它是一个拥有两个属性 { Provider, Consumer } 的对象
// 注意这里用的是 UpperCase 命名，不是 camelCase
// 这很重要，因为我们一会要以组件的方式使用它
// 而组件的名称必须以大写字母开头
const UserContext = React.createContext();

// 下面是需要从上下文中获取数据的组件
// 可以通过使用 UserContext 的 Consumer 属性
// Consumer 使用的是 "render props" 模式
const UserAvatar = ({ size }) => (
  <UserContext.Consumer>
    {user => (
      <img
        className={`user-avatar ${size || ""}`}
        alt="user avatar"
        src={user.avatar}
      />
    )}
  </UserContext.Consumer>
);

// 注意我们不再需要 'user' 属性了
// 因为 Consumer 可以直接从上下文中获取
const UserStats = () => (
  <UserContext.Consumer>
    {user => (
      <div className="user-stats">
        <div>
          <UserAvatar user={user} />
          {user.name}
        </div>
        <div className="stats">
          <div>{user.followers} Followers</div>
          <div>Following {user.following}</div>
        </div>
      </div>
    )}
  </UserContext.Consumer>
);

// …… 所有其它的组件 ……
// ……（就是那些不会用到 `user` 的组件）……

// 在最下面，App 的内部
// 我们用 Provider 在整棵树中传递上下文
class App extends React.Component {
  state = {
    user: {
      avatar:
        "https://www.gravatar.com/avatar/5c3dd2d257ff0e14dbd2583485dbd44b",
      name: "Dave",
      followers: 1234,
      following: 123
    }
  };

  render() {
    return (
      <div className="app">
        <UserContext.Provider value={this.state.user}>
          <Nav />
          <Body />
        </UserContext.Provider>
      </div>
    );
  }
}
```

这里是 [CodeSandbox 中的完整示例](https://codesandbox.io/s/q9w2qrw6q4)。

让我们来看看它是如何工作的。

记住有 3 个部分：上下文本身（由 `React.createContext` 创建），以及和它对话的两个组件（`Provider` 和 `Consumer`）。

### Provider 和 Consumer 是一对好基友

Provider 和 Consumer 被捆绑在一起。形影不离。而且它们只知道如何和**对方**对话。如果你创建两个单独的上下文，例如 “Context1” 和 “Context2”，那么 Context1 的 Provider 和 Consumer 是不可能和 Context2 的 Provider 和 Consumer 通信的。

### 上下文中不保存 state

注意上下文**没有**自己的 state。它只是数据的管道。你必须将值传递给 `Provider`，然后这个确切的值会被传递给任何知道如何获取它的 `Consumer`（Consumer 和 Provider 绑定的是同一个上下文）。

创建上下文时，可以传入一个“默认值”，如下所示：

```js
const Ctx = React.createContext(yourDefaultValue);
```

当 `Consumer` 被放在一个没有 `Provider` 包裹的树上时，它会收到这个默认值。如果你没有传入默认值，这个值会为 `undefined`。但要注意这是默认值，而不是初始值。上下文不保留任何内容；它只是分发你传入的数据。

### Consumer 使用 Render Props 模式

Redux 的 `connect` 函数是一个高阶组件（或简称 HoC）。它**包裹**另外一个组件，并将 props 传递给它。

上下文的 `Consumer` 则相反，它期望子组件是一个函数。然后它在渲染的时候调用这个函数，将它从包裹它的 `Provider` 上获得的值（或上下文的默认值，如果你没有传入默认值，那也可能是 `undefined`）传给子组件。

### Provider 接收单个值

它接收 `value` 属性，仅此一个值。但请记住这个值可以是任何东西。在实践中，如果你想要向下传递多个值，你必须创建一个包含这些值的对象，再将**这个对象**传递下去。

这几乎是 Context API 的最核心的东西。

## 灵活的 Context API

因为创建上下文为我们提供了两个可以使用的组件（Provider 和 Consumer），因此我们可以随意使用它们。这里有几个想法。

### 将 Consumer 变成高阶组件

不喜欢在每个需要使用 `UserContext.Consumer` 的地方都添加它的用法？嗯，这是你的代码！你可以做任何你想做的事。你是个成年人了。

如果你更愿意接收一个作为属性的值，你可以为 `Consumer` 写一个包裹器，像下面这样：

```js
function withUser(Component) {
  return function ConnectedComponent(props) {
    return (
      <UserContext.Consumer>
        {user => <Component {...props} user={user}/>}
      </UserContext.Consumer>
    );
  }
}
```

然后你可以重写你的代码，比如使用了新 `withUser` 函数的 `UserAvatar` 组件：

```js
const UserAvatar = withUser(({ size, user }) => (
  <img
    className={`user-avatar ${size || ""}`}
    alt="user avatar"
    src={user.avatar}
  />
));
```

BOOM，上下文可以像 Redux 的 `connect` 那样工作。让你的组件很纯粹。

这里是[带有这个高阶组件的 CodeSandbox 示例](https://codesandbox.io/s/jpy76nm1v)。

### 用 Provider 保存 state

记住，上下文的 Provider 只是一个管道。它不保留任何数据。但这并不能阻止你制作**自己**的包裹器来保存数据。

在上面的示例中，我用 `App` 保存数据，因此这里你唯一需要了解的新事物就是这个 Provider + Consumer 组件。但也许你想写一个自己的 “store”，等等。你可以创建一个组件来保存数据，并通过上下文传递它们。

```js
class UserStore extends React.Component {
  state = {
    user: {
      avatar:
        "https://www.gravatar.com/avatar/5c3dd2d257ff0e14dbd2583485dbd44b",
      name: "Dave",
      followers: 1234,
      following: 123
    }
  };

  render() {
    return (
      <UserContext.Provider value={this.state.user}>
        {this.props.children}
      </UserContext.Provider>
    );
  }
}

// ……略过中间的内容……

const App = () => (
  <div className="app">
    <Nav />
    <Body />
  </div>
);

ReactDOM.render(
  <UserStore>
    <App />
  </UserStore>,
  document.querySelector("#root")
);
```

现在，你的用户数据被很好地包含在它自己的组件中了，这个组件**唯一**关注的就是用户数据。很棒。`App` 又可以再次变成无状态组件了。我认为它看起来更整洁了。

这里是[带有这个 UserStore 的 CodeSandbox 示例](https://codesandbox.io/s/jpy76nm1v)。

### 通过上下文传递操作

记住通过 Provider 传递的对象可以包含你想要的任何东西。这意味着它可以包含函数。你甚至可以称之为“操作（action）”。

这是一个新例子：一个简单的房间，带有一个可以切换背景颜色的开关 —— 抱歉，我的意思是灯光。

![灯灭屋黑。](https://daveceddia.com/images/lightswitch-app.gif)

State 被保存在 store 中，store 中还有切换灯光的函数。State 和函数都通过上下文传递。

```js
import React from "react";
import ReactDOM from "react-dom";
import "./styles.css";

// 简单的空上下文
const RoomContext = React.createContext();

// 一个组件
// 唯一的工作就是管理 Room 的 state
class RoomStore extends React.Component {
  state = {
    isLit: false
  };

  toggleLight = () => {
    this.setState(state => ({ isLit: !state.isLit }));
  };

  render() {
    // 传递 state 和 onToggleLight 操作
    return (
      <RoomContext.Provider
        value={{
          isLit: this.state.isLit,
          onToggleLight: this.toggleLight
        }}
      >
        {this.props.children}
      </RoomContext.Provider>
    );
  }
}

// 从 RoomContext 中接收灯光的 state
// 以及切换灯光的函数
const Room = () => (
  <RoomContext.Consumer>
    {({ isLit, onToggleLight }) => (
      <div className={`room ${isLit ? "lit" : "dark"}`}>
        The room is {isLit ? "lit" : "dark"}.
        <br />
        <button onClick={onToggleLight}>Flip</button>
      </div>
    )}
  </RoomContext.Consumer>
);

const App = () => (
  <div className="app">
    <Room />
  </div>
);

// 用 RoomStore 包裹整个 App
// 它可以像在 `App` 内那样工作
ReactDOM.render(
  <RoomStore>
    <App />
  </RoomStore>,
  document.querySelector("#root")
);
```

这里是 [CodeSandbox 中的完整示例](https://codesandbox.io/s/jvky9o0nvw)。

## 应该使用 Context 还是 Redux？

既然你已经看过两种方式了 —— 那你应该使用哪种方式呢？好吧，这里有一件事会让你的应用**更好**并且**写起来更有趣**，那就是**做决策**。我知道你可能只想要“答案”，但我很遗憾地告诉你，“这视情况而定”。

这取决于你的应用程序有多大或将会变成多大。有多少人会参与其中 —— 只有你还是有更大的团队？你或你的团队对于 Redux 所依赖的函数式概念（如不变性和纯函数）的经验。

在 JavaScript 生态系统中存在的一个巨大的恶性谬论是**竞争**的概念。有观点认为，每一次选择都是一个零和游戏；如果你使用**库 A**，你就不能使用**它的竞争对手库 B**。这个想法是说当出现了一个在某种程度上更好的新库，它必须取代现有的库。这是一种「或者……或者……」的感觉，你必须选择目前最好的库，或者和过去的人一起使用之前的库。

更好的方法是拥有一个像是你的**工具箱**一样的东西，可以把你的选择项都放进去。就像是选择使用螺丝刀还是冲击钻。对于 80% 的工作，使用冲击钻拧螺丝都比螺丝刀更快。但对于另外的 20%，螺丝刀实际上是更好的选择 —— 或许因为空间比较狭小，或是物品很精细。当我有一个冲击钻时，我并没有立即扔掉我的螺丝刀，甚至是我的非冲击钻。冲击钻没有**取代**它们，它只是给了我另外一种选择。另外一种解决问题的方法。

React 会“替代” Angular 或 jQuery，但 Context 不会像这样“替代” Redux。哎呀，当我需要快速完成一些事情时，我仍然会使用 jQuery。我有时仍会使用服务器渲染的 EJS 模板，而不是使用整个 React 应用程序。有时 React 比你手上的任务需求更庞大。有时 Redux 里也会有你不需要的功能。

现在，当 Redux 超出你的需求时，你可以使用 Context。

### 翻译

* [Russian](https://habr.com/post/419449/)（由 Maxim Vashchenko 提供）
* [Japanese](https://qiita.com/ossan-engineer/items/c3e5bd4d9bb4db04f80d)（由 Kiichi 提供）
* [Portuguese](https://www.linkedin.com/pulse/redux-vs-react-context-api-wenderson-pires/)（由 Wenderson Pires 提供）

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
