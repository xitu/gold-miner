> * 原文地址：[How To Write Better Code In React](https://blog.bitsrc.io/how-to-write-better-code-in-react-best-practices-b8ca87d462b0)
> * 原文作者：[Rajat S](https://blog.bitsrc.io/@geeky_writer_?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-write-better-code-in-react-best-practices.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-write-better-code-in-react-best-practices.md)
> * 译者：[jonjia](https://github.com/jonjia)
> * 校对者：[jasonxia23](https://github.com/jasonxia23) [老教授](https://github.com/weberpan)

# 如何写出更好的 React 代码

## 写出更好的 React 代码的 9 条实用提示：了解代码检查、propTypes、PureComponent 等。

![](https://cdn-images-1.medium.com/max/2000/1*4ihBhwd0DygCWHN-Bo24BA.png)

使用 [React](https://reactjs.org/) 可以轻松创建交互式界面。为应用中的每个状态设计简单的视图，当数据变化时，React 会高效地更新和渲染正确的组件。

这篇文章中，我会介绍一些使你成为更好的 React 开发者的方法。包括从工具到代码风格等一系列内容，这些都可以帮助你提升 React 相关技能。 💪

* * *

### 代码检查

要写出更好代码，很重要的一件事就是使用好的代码检查工具。如果我们配置好了一套代码检查规则，代码编辑器就能帮我们捕捉到任何可能出现的代码问题。

但除了捕捉问题，[ES Lint](https://eslint.org/) 也会让你不断学习到 React 代码的最佳实践。

```
import react from 'react';
/* 其它 imports */

/* Code */

export default class App extends React.Component {
  render() {
    const { userIsLoaded, user } = this.props;
    if (!userIsLoaded) return <Loader />;
    
    return (
      /* Code */
    )
  }
}
```

看一下上面的代码。假设你想在 `render()` 方法中引用一个叫做 `this.props.hello` 的新属性。代码检查工具会马上把代码变红，并提示：

```
props 验证没有 'hello' (react/prop-types)
```

代码检查工具会让你认识到 React 的最佳实践并塑造你对代码的理解。很快，之后写代码的时候，你就会开始避免犯错了。

你可以去 [ESLint 官网](https://eslint.org) 为 JavaScript 配置代码检查工具，或者使用 [Airbnb’s JavaScript Style Guide](https://github.com/airbnb/javascript)。也可以安装 [React ESLint Package](https://www.npmjs.com/package/eslint-plugin-react)。

* * *

### [propTypes](https://www.npmjs.com/package/prop-types) 和 defaultProps

上一节中，我谈到了当使用一个不存在的 prop 时，我的代码检查工具是如何起作用的。

```
static propTypes = {
  userIsLoaded: PropTypes.boolean.isRequired,
  user: PropTypes.shape({
    _id: PropTypes.string,
  )}.isRequired,
}
```

在这里，如果 `userIsLoaded` 不是必需的，那么我们就要在代码中添加说明：

```
static defaultProps = {
 userIsLoaded: false,
}
```

所以每当我们要在组件中使用 `参数类型检查`，就要为它设置一个 propType。如上，我们告诉 React：`userIsLoaded` 的类型永远是一个布尔值。

如果我们声明 `userIsLoaded` 不是必需的值，那么我们就要为它定义一个默认值。如果是必需的，就没有必要定义默认值。但是，规则还指出不应该使用像对象或数组这样不明确的 propTypes。

为什么使用 `shape` 方法来验证 `user` 呢，因为它内部需要有一个 类型为字符串的 `id` 属性，而整个 `user` 对象又是必需的。

确保使用了 `props` 的每个组件都声明了 `propTypes` 和 `defaultProps`，这对写出更好的 React 代码很有帮助。

当 props 实际获取的数据和期望的不同时，错误日志就会让你知道：要么是你传递了错误的数据，要么就是没有得到期望值，特别是写可重用组件时，找出错误会更容易。这也会让这些可重用组件更可读一些。

#### 注意：

React 从 v15.5 版本开始，不再内置 proptypes，需要作为独立的依赖包添加到你的项目中。

点击下面的链接了解更多：

- [**prop-types**：用于运行时检查 React props 和类似对象类型的工具](https://www.npmjs.com/package/prop-types)

* * *

### 知道何时创建新组件

```
export default class Profile extends PureComponent {
  static propTypes = {
    userIsLoaded: PropTypes.bool,
    user: PropTypes.shape({
      _id: PropTypes.string,
    }).isRequired,
  }
  
  static defaultProps = {
    userIsLoaded: false,
  }
  
  render() {
    const { userIsLoaded, user } = this.props;
    if (!userIsLoaded) return <Loaded />;
    return (
      <div>
        <div className="two-col">
          <section>
            <MyOrders userId={user._id} />
            <MyDownloads userId={user._id} />
          </section>
          <aside>
            <MySubscriptions user={user} />
            <MyVotes user={user} />
          </aside>
        </div>
        <div className="one-col">
          {isRole('affiliate', user={user._id) &&
            <MyAffiliateInfo userId={user._id} />
          }
        </div>
      </div>
    )
  }
}
```

上面有一个名为 `Profile` 的组件。这个组件内部还有一些像 `MyOrder` 和 `MyDownloads` 这样的其它组件。因为它们从同一个数据源（`user`）获取数据，所以可以把所有这些组件写到一起。把这些小组件变成一个巨大的组件。

尽管什么时候才要创建一个新组件没有任何硬性规定，但问问你自己：

*   代码的功能变得笨重了吗？
*   它是否只代表了自己的东西？
*   是否需要重用这部分代码？

如果上面有一个问题的答案是肯定的，那你就需要创建一个新组件了。

记住，任何人如果看到你的有 200–300 行的组件时都会抓狂的，然后没人会想再看你的代码。

* * *

### Component vs PureComponent vs Stateless Functional Component

对于一个 React 开发者，知道在代码中什么时候该使用 **Component**、 **PureComponent** 和 **Stateless Functional Component** 是非常重要的。

你可能注意到了在上面的代码中，我没有将 `Profile` 继承自 `Component`，而是 `PureComponent`。

首先，来看看无状态函数式组件。

#### Stateless Functional Component（无状态函数式组件）

```
const Billboard = () => (
  <ZoneBlack>
    <Heading>React</Heading>
    <div className="billboard_product">
      <Link className="billboard_product-image" to="/">
        <img alt="#" src="#">
      </Link>
      <div className="billboard_product-details">
        <h3 className="sub">React</h3>
        <p>Lorem Ipsum</p>
      </div>
    </div>
  </ZoneBlack>
);
```

无状态函数式组件是一种很常见的组件类型。它为我们提供了一种非常简洁的方式来创建不使用任何 [**state**](https://reactjs.org/docs/faq-state.html)、[**refs**](https://hackernoon.com/refs-in-react-all-you-need-to-know-fb9c9e2aeb81) 或 [**生命周期方法**](https://reactjs.org/docs/state-and-lifecycle.html) 的组件。

无状态函数式组件的特点是没有状态并且只有一个函数。所以你可以把组件定义为一个返回一些数据的常量函数。

简单来说，无状态函数式组件就是返回 JSX 的函数。

#### [PureComponents](https://reactjs.org/docs/react-api.html#reactpurecomponent)

通常，一个组件获取了新的 prop，React 就会重新渲染这个组件。但有时，新传入的 prop 并没有真正改变，React 还是触发重新渲染。

使用 `PureComponent` 可以帮助你避免这种重新渲染的浪费。例如，一个 prop 是字符串或布尔值，它改变后，`PureComponent` 会识别到这个改变，但如果 prop 是一个对象，它的属性改变后，`PureComponent` 不会触发重新渲染。

那么如何知道 React 何时会触发一个不必要的重新渲染呢？你可以看看这个叫做 [Why Did You Update](http://github.com/maicki/why-did-you-update) 的 React 包。当不必要的重新渲染发生时，这个包会在控制台中通知你。

![](https://cdn-images-1.medium.com/max/800/1*CL5jum98a0QxOWeIb9QRBg.png)

一旦你确认了一个不必要的重新渲染，就可以使用 `PureComponent` 替换 `Component` 来避免。

* * *

### 使用 React 开发者工具

如果你真想成为一个专业的 React 开发者，那么在开发过程中，就应该经常使用 React 开发者工具。

如果你使用过 React，你的控制台很可能建议过你使用 React 开发者工具。

React 开发者工具适用于所有主流浏览器，例如：[Chrome](https://chrome.google.com/webstore/detail/react-developer-tools/fmkadmapgofadopljbjfkapdkoienihi?hl=en) 和 [Firefox](https://addons.mozilla.org/en-US/firefox/addon/react-devtools/)。

通过 React 开发者工具，你可以看到整个应用结构和应用中正在使用的 props 和 state。
 
React 开发者工具是探索 React 组件的绝佳方式，也有助于诊断应用中的问题。

* * *

### 使用内联条件语句

这个观点可能会引起一些争议，但我发现使用内联条件语句可以明显简化我的 React 代码。

如下：

```
<div className="one-col">
  {isRole('affiliate', user._id) &&
    <MyAffiliateInfo userId={user._id} />
  }
</div>
```

上面代码中，有一个检查这个人是否是 “affiliate” 的方法，后面跟了一个叫做 `<MyAffiliateInfo/>` 的组件。

这样做的好处是：

*   不必编写单独的函数
*   不必在 render 方法中使用 “if” 语句
*   不必为组件中的其它位置创建“链接”

使用内联条件语句非常简洁。开始你可以把条件写为 true，那么 `<MyAffiliateInfo />` 组件无论如何都会显示。

然后我们使用 `&&` 连接条件和 `<MyAffiliateInfo />`。这样当条件为真时，组件就会被渲染。

* * *

### 尽可能使用代码片段库

打开一个代码编辑器（我用的是 VS Code），新建一个 js 文件。

在这个文件中输入 `rc`，就会看见如下提示：

![](https://cdn-images-1.medium.com/max/800/1*DKVKG5IQB2XQ4GR1uEVDUw.png)

按下回车键，会立刻得到下面的代码片段：

![](https://cdn-images-1.medium.com/max/800/1*ICQlmjGkoM_27Mz8tD1ZyA.png)

这些代码片段的优点不仅是帮助你减少 bug，还能帮助你获取到最新最棒的写法。

你可以在代码编辑器中安装许多不同的代码片段库。我用于 [VS Code](https://code.visualstudio.com/) 的叫做 [ES7 React/Redux/React-Native/JS Snippets](https://marketplace.visualstudio.com/items?itemName=dsznajder.es7-react-js-snippets)。

* * *

### [React Internals](http://www.mattgreer.org/articles/react-internals-part-one-basic-rendering/) — 了解 React 内部如何工作

React Internals 是一个共五篇的系列文章，帮助我理解 React 的基础知识，最终帮助我成为一个更好的 React 开发者！

如果你对某些问题不能完全理解，或者你知道 React 的工作原理，那么 React Internals 可以帮助你理解**何时、如何**在 React 中做对的事。

这对那些不清楚在哪里执行代码的人特别有用。

理解 React 内部运行原理会帮助你成为更好的 React 开发者。

* * *

### 在你的组件中使用 [Bit](https://bitsrc.io) 和 [StoryBook](https://storybook.js.org/)

[Bit](https://bitsrc.io) 是一个将你的 UI 组件转化为可以在不同应用中分享、开发和同步的构建块的工具。

你也可以利用 Bit 管理团队组件，通过 [线上组件区](https://blog.bitsrc.io/introducing-the-live-react-component-playground-d8c281352ee7)，可以使它们容易获取和使用，也便于单独测试。

- [**Bit — 共享共创代码组件**：Bit 让使用小组件构建软件更简单有趣，在你的团队中分享同步这些组件](https://bitsrc.io)

[Storybook](https://github.com/storybooks/storybook) 是用于 UI 组件的快速开发环境，可以帮助你浏览一个组件库，查看每个组件的不同状态，交互式开发和测试组件。

Storybook 提供了一个帮你快速开发 React 组件的环境，通过它，当你操作组件的属性时，Web 页面会热更新，让你看到组件的实时效果。

* * *

### 快速回顾

1. 使用代码检查工具，使用 ES Lint、Airbnb’s JavaScript Style Guide 和 ESLint React 插件。
2. 使用 propTypes 和 defaultProps。
3. 知道何时创建新组件。
4. 知道何时使用 Component、PureComponent 和 Stateless Functional Component。
5. 使用 React 开发者工具。
6. 使用内联条件语句。
7. 使用代码片段库，节省浪费在样板代码上的时间。
8. 通过 React Internals 了解 React 如何工作。
9. 使用像 Bit、StoryBook 这样的工具来优化开发流程。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
