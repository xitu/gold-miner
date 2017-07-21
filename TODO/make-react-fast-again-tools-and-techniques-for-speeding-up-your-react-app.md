
> * 原文地址：[High Performance React: 3 New Tools to Speed Up Your Apps](https://medium.freecodecamp.org/make-react-fast-again-tools-and-techniques-for-speeding-up-your-react-app-7ad39d3c1b82)
> * 原文作者：[Ben Edelstein](https://medium.freecodecamp.org/@edelstein)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/make-react-fast-again-tools-and-techniques-for-speeding-up-your-react-app.md](https://github.com/xitu/gold-miner/blob/master/TODO/make-react-fast-again-tools-and-techniques-for-speeding-up-your-react-app.md)
> * 译者：[sunui](https://github.com/sunui)
> * 校对者：[yzgyyang](https://github.com/yzgyyang)、[reid3290](https://github.com/reid3290)

# 高性能 React：3 个新工具加速你的应用

![](https://cdn-images-1.medium.com/max/2000/1*mJFYp7LKVzZM3PPjFb0QXQ.png)

通常来说 React 是相当快的，但开发者也很容易犯一些错误导致出现性能问题。组件挂载过慢、组件树过深和一些非必要的渲染周期可以迅速地联手拉低你的应用速度。

幸运的是有大量的工具，甚至有些是 React 内置的，可以帮助我们检测性能问题。本文将着重介绍一些加快 React 应用的工具和技术。每一部分都配有一个可交互而且（希望是）有趣的 demo！

### 工具 #1: 性能时间轴

React 15.4.0 引入了一个新的性能时间轴特性，可以精确展示组件何时挂载、更新和卸载。也可以让你可视化地观察组件生命周期相互之间的关系。

**注意：** 目前，这一特性仅支持 Chrome、Edge 和 IE，因为它调用的 User Timing API 还没有在所有浏览器中实现。

#### 如何使用

1. 打开你的应用并追加一个参数：`react_perf`。例如， [`http://localhost:3000?react_perf`](http://localhost:3000?react_perf)
2. 打开 Chrome 开发者工具 **Performance** 栏并点击 **Record**。
3. 执行你想要分析的操作。
4. 停止记录。
5. 观察 **User Timing** 选项下的可视化视图。

![](https://cdn-images-1.medium.com/max/1000/1*cOO5vUnbkdDUcqMW8ebJqA.png)

#### 理解输出结果

每一个色条显示的是一个组件做“处理”的时间。由于 JavaScript 是单线程的，每当一个组件正在挂载或渲染，它都会霸占主线程，并阻塞其他代码运行。

像 `[update]` 这样中括号内的文字描述的是生命周期的哪一个阶段正在发生。把时间轴按照步骤分解，你可以看到依据方法的细粒度的计时，比如  `[componentDidMount]` `[componentWillReceiveProps]` `[ctor]` (constructor) 和 `[render]`。

堆叠的色条代表组件树，虽然在 React 拥有过深的组件树也比较典型，但如果你想优化一个频繁挂载的组件，减少嵌套组件的数量也是有帮助的，因为每一层都会增加少量的性能和内存消耗。

这里需要注意的是时间轴中的计时时长是针对 React 的开发环境构建的，会比生产环境慢很多。实际上性能时间轴本身也会拖慢你的应用。虽然这些时长不能代表真正的性能指标，但不同组件间的**相对**时间是精确的。而且一个组件是否完全被更新不取决于是否是生产环境的构建。

#### Demo #1

出于乐趣，我故意写了一个具有**严重**性能问题的 TodoMVC 应用。你可以[在这里尝试](https://perf-demo.firebaseapp.com/?react_perf)。

打开 Chrome 开发者工具，切换到 “Performance” 栏，点击 Record 开始记录时间轴。然后在应用中添加一些 TODO，停止记录，检查时间轴。看看你能不能找出造成性能问题的组件 :)

### Tool #2: why-did-you-update

在 React 中最影响性能的问题之一就是非必要的渲染周期。默认情况下，一旦父组件渲染，React 组件就会跟着重新渲染，即使它们的 props 没有变化也是如此。

举个例子，如果我有一个简单的组件长这样：

    class DumbComponent extends Component {
      render() {
        return <div> {this.props.value} </div>;
      }
    }

它的父组件是这样：

    class Parent extends Component {
      render() {
        return <div>
          <DumbComponent value={3} />
        </div>;
      }
    }

每当父组件渲染，`DumbComponent` 就会重新渲染，尽管它的 props 没有改变。

一般来讲，如果 `render` 运行，并且虚拟 DOM 没有改变，而且既然 `render` 应该是个纯净的没有任何副作用的方法，那么这就是一个不必要的渲染周期。在一个大型应用中检测这种事情是非常困难的，但幸运的是有一个工具可以帮得上忙。

#### 使用 why-did-you-update

![](https://cdn-images-1.medium.com/max/1000/1*Lb4nr_WLwnLt63jUoszrnQ.png)

`why-did-you-update` 是一个 React 钩子工具，用来检测潜在的非必要组件渲染。它会检测到被调用但 props 没有改变的组件 `render`。

#### 安装

1. 使用 npm 安装： `npm i --save-dev why-did-you-update`
2. 在你应用中的任何地方添加下面这个片段：

```
import React from 'react'

if (process.env.NODE_ENV !== 'production') {
    const {whyDidYouUpdate} = require('why-did-you-update')
    whyDidYouUpdate(React)
}
```

**注意：** 这个工具在本地开发环境使用起来非常棒，但是要确保生产环境要禁用掉，因为它会拖慢你的应用。

#### 理解输出结果

`why-did-you-update` 在运行时监听你的应用，并用日志输出可能存在非必要更新的组件。它让你看到一个渲染周期前后的 props 对比，来决定是否可能存在非必要的更新。

#### Demo #2

为了演示 `why-did-you-update`，我在 TodoMVC 中安装了这个库并放在 Code Sandbox 网站上，这是一个在线的 React 练习场。 打开浏览器控制台，并添加一些 TODO 来查看输出。

[这里查看 demo](https://codesandbox.io/s/xGJP4QExn)。

注意这个应用中很少的组件存在非必要渲染。尝试执行上述的技术来避免非必要渲染，如果操作正确，`why-did-you-update` 不会在控制台输出任何内容。

### Tool #3: React Developer Tools

![](https://cdn-images-1.medium.com/max/1000/1*1Ih6h8djFyH13tfFK3D1sw.png)

React Developer Tools 这个 Chrome 扩展有一个内置特性用来可视化组件更新。这有助于防止非必要的渲染周期。使用它，首先要确保[在这里安装了这个扩展](https://codesandbox.io/s/xGJP4QExn)。

然后点击 Chrome 开发者工具中的 “React” 选项卡打开扩展并勾选“Highlight Updates”。

![](https://cdn-images-1.medium.com/max/800/1*GP4vXvW3WO0vTbggDfus4Q.png)

然后简单操作你的应用。和不同的组件交互并观察 DevTools 施展它的魔法。

#### 理解输出结果

React Developer Tools 在给定的时间点高亮正在重新渲染的组件。根据更新的频率，使用不同的颜色。蓝色显示罕见更新，经过绿色、黄色的过渡，一直到红色用来显示更新频繁的组件。

看到黄色或红色并不**必要**觉得一定是坏事。它可能发生在调整一个滑块或频繁触发更新的其他 UI 元素，这属于意料之中。但如果当你点击一个简单的按钮并且看到了红色这可能就意味着事情不对了。这个工具的目的就是识破正在发生**非必要**更新的组件。作为应用的开发者，你应该对给定时间内哪个组件应该被更新有一个大体的概念。

#### Demo #3

为了演示高亮，我故意让 TodoMVC 应用更新一些非必要的组件。

[这里查看 demo](https://highlight-demo.firebaseapp.com/)。

打开上面的链接，然后打开 React Developer Tools 并启用更新高亮。当你在上面的文字输入框中输入内容时，你将看到所有的 TODO 非必要地高亮。你输入得越快，你会看到颜色变化指示更新越来越频繁。

### 修复非必要渲染

一旦你已经确定应用中非必要重新渲染的组件，有几种简单的方法来修复。

#### 使用 PureComponent

在上面的例子中，`DumbComponent` 是只接收属性的纯函数。这样，组件就只有当它的 props 变化的时候才重新渲染。React 有一个特殊的内置组件类型叫做 `PureComponent`，就是适用这种情况的用例。

与继承自 React.Component 相反，像这样使用 React.PureComponent：

    class DumbComponent extends PureComponent {
      render() {
        return <div> {this.props.value} </div>;
      }
    }

那么只有当这个组件的 props 实际发生变化时它才会被重新渲染了。就是这样！

注意 `PureComponent` 对 props 做了一个浅对比，因此如果你使用复杂的数据结构，它可能会错失一些属性变化而不会更新你的组件。

#### 调用 shouldComponentUpdate

`shouldComponentUpdate` 是一个在 `render` 之前 `props` 或 `state` 发生改变时被调用的组件方法。如果 `shouldComponentUpdate` 返回 true，`render` 将会被调用，如果返回 false 什么也不会发生。

通过执行这个方法，你可以命令 React 在 props 没有发生改变的时候避免给定组件的重新渲染。

例如，我们可以在上文中的 DumbComponent 中这样调用 `shouldComponentUpdate`。

    class DumbComponent extends Component {
      shouldComponentUpdate(nextProps) {
        if (this.props.value !== nextProps.value) {
          return true;
        } else {
          return false;
        }
      }

    render() {
        return <div>foo</div>;
      }
    }

### 在生产环境中调试性能问题

React Developer Tools 只能在你自己的机器上运行的应用中使用。如果您有兴趣了解用户在生产中看到的性能问题，试试 [LogRocket](https://logrocket.com)。

![](https://cdn-images-1.medium.com/max/1000/1*s_rMyo6NbrAsP-XtvBaXFg.png)

[LogRocket](https://logrocket.com) 就像是 web 应用的 DVR，会记录发生在你的站点上的**所有的一切**。你可以重现带有 bug 或性能问题的会话来快速了解问题的根源，而不用猜测问题发生的原因。

LogRocket 工具为你的应用记录性能数据、Redux actions/state、日志、带有请求头和请求体的网络请求和响应以及浏览器的元数据。它也能记录页面上的 HTML 和 CSS，甚至可以为最复杂的单页面应用重新创建完美像素的视频。

[**LogRocket | 为 JavaScript 应用而生的日志记录和会话回放工具** 
LogRocket 帮助你了解用影响你用户的问题，这样你就可以回过头来构建伟大的软件了。
logrocket.com](https://logrocket.com/)

---

感谢阅读，希望这些工具和技术能在你的下一个 React 项目中帮到你！


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
