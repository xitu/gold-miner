
> * 原文地址：[What’s New in React 16 and Fiber Explanation](https://edgecoders.com/react-16-features-and-fiber-explanation-e779544bb1b7)
> * 原文作者：[Trey Huffine](https://edgecoders.com/@treyhuffine?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/react-16-features-and-fiber-explanation.md](https://github.com/xitu/gold-miner/blob/master/TODO/react-16-features-and-fiber-explanation.md)
> * 译者：[yoyoyohamapi](https://github.com/yoyoyohamapi)
> * 校对者：[Tina92](https://github.com/Tina92) [sunui](https://github.com/sunui)

# React 16 带来了什么以及对 Fiber 的解释

## 特性概览 —— 万众期待的 React 16 

![](https://cdn-images-1.medium.com/max/2100/1*i3hzpSEiEEMTuWIYviYweQ.png)

React 核心算法的更新已经进行了多年了 —— 这次更新提供了一个从底层重写了 React 的 reconciliation 算法（译注：reconciliation 算法，是 React 用来比较两棵 DOM 树差异、从而觉得哪一部分应当被更新的算法）。React将维护相同的公共API，并允许大多数项目立即升级（假设您已经修复了弃用警告）。新版本的发布主要有如下目的：

* 能够将渲染流程中可中断的工作（interruptible work）换划分为一个个的 chunk。 

* 能够为渲染流程中的工作提供优先级划分，rebase 以及重用能力。

* 在渲染流程中，能够自如地在父子组件中切换，这使得在 React 实现 layout 成为了可能。

* 能够从 `render()` 函数返回多个 element。

* 对 error boundary 提供了更好的支持。

* [**可以在 gitconnected 上关注我 >](https://gitconnected.com/treyhuffine)**

## 特性

### 核心算法重写

这次算法重写带来的主要特性是异步渲染。（**注意**：在 16.0 中尚不支持，但是在未来的 16.x 版本中将会做为可选特性）。另外，新的重写删除了一些不成熟的、妨碍了内部变化的抽象。

> 这些多来自于 [Lin Clark 的演讲](https://www.youtube.com/watch?v=ZCuYPiUIONs)，所以你可以看看这个演讲，再在 twitter 上 [关注并点赞 Clark](https://twitter.com/linclark) 来支持她这个视角独特的概述。

异步渲染的意义在于能够将渲染任务划分为多块。浏览器的渲染引擎是单线程的，这意味着几乎所有的行为都是同步发生的。React 16 使用原生的浏览器 API 来间歇性地检查当前是否还有其他任务需要完成，从而实现了对主线程和渲染过程的管理。在 Firefox 中，一个浏览器主线程的例子很简单：

```js
while (!mExiting) {
    NS_ProcessNextEvent(thread);
}
```

在之前的版本中，React 会在计算 DOM 树的时候锁住整个线程。这个 reconciliation 的过程现在被称作 “stack reconciliation”。尽管 React 已经是以快而闻名了，但是锁住整个线程也会让一些应用运行得不是很流畅。16 这个版本通过不要求渲染过程在初始化后一次性完成修复了该问题。React 计算了 DOM 树的一部分，之后将暂停渲染，来看看主线程是否有任何的绘图或者更新需要去完成。一旦绘图和更新完成了，React 就会继续渲染。这个过程通过引入了一个新的，叫做 “fiber” 的数据结构完成，fiber 映射到了一个 React 实例并为该实例管理其渲染任务，它也知道它和其他 fiber 之间的关系。一个 fiber 仅仅是一个 JavaScript 对象。下面的图片对比了新旧渲染方法。

![Stack reconciliation — updates must be completed entirely before returning to main thread (credit Lin Clark)](https://cdn-images-1.medium.com/max/3304/1*QtyRyjiedObq7_khCw5GlA.png)

![Fiber reconciliation — updates will be batched in chunks and React will manage the main thread (credit Lin Clark)](https://cdn-images-1.medium.com/max/2000/1*LEPjfYL6Bd4nkcCRMB6vog.png)

React 16 也会在必要的时候管理各个更新的优先级。这就允许了高优先级更新能够排到队列开头从而被首先处理。关于此的一个例子就是按键输入。鉴于应用流畅性的考虑，用户需要立即获得按键响应，因而相对于那些可以等待 100-200 毫秒的低优先级更新任务，按键输入拥有较高优先级。

![React priorities (credit Lin Clark)](https://cdn-images-1.medium.com/max/3428/1*RZYe9LuwfybI9zDxCL28NQ.png)

通过将 UI 的更新划分为若干小的工作单元，用户体验获得了提高。暂停 reconciliation 任务来允许主线程执行其他紧急的任务，这提供了更平滑的接口和可感知到的性能提升。

### 错误处理

在 React 中，错误总是难于处理，但在 React 16 中，一切发生了变化。之前版本中，组件内部发生的错误将污染 React 的状态，并且在后续的渲染中引起更多含义模糊的错误。

![lol wut?](https://cdn-images-1.medium.com/max/2000/1*BLyT8jKqOPRAKt_iUXCNeg.png)

React 16 含有的 error boundary 不只能够提供清晰的错误信息，还能防止整个应用因错误而崩溃。将 error boundary 添加到你的应用之后，它能够 catch 住错误并且展示一个对应的 UI 而不会造成整个组件树崩溃。boundary 能够在组建的渲染期、生命周期方法及所有其子树的构造方法中 catch 错误。error boundary 通过一个新的生命周期方法 componentDidCatch(error, info) 就可以轻松实现。

```js
class ErrorBoundary extends React.Component {
  constructor(props) {
    super(props);
    this.state = { hasError: false };
  }

  componentDidCatch(error, info) {
    // 展示一个回退 UI
    this.setState({ hasError: true });
    // 你也可以将错误日志输出到一个错误报告服务
    logErrorToMyService(error, info);
  }

  render() {
    if (this.state.hasError) {
      // 你可以渲染任意的自定义回退 UI
      return <h1>Something went wrong.</h1>;
    }
    return this.props.children;
  }
}

<ErrorBoundary>
  <MyWidget />
</ErrorBoundary>
```

在该例子中，任何发生在 `<MyWidget/>` 或者其子组件中的错误都能被 `<ErrorBoundary>` 组件所捕获。这个功能类似于 JavaScript 中的 `catch {}` 块。如果 error boundary 收到了一个错误状态，作为开发者的你能够确定此时应当展示的 UI。注意到 error boundary 只会 catch 其子树的错误，但不会识别自身的错误。

进一步，你能看到如下健全的、可控的错误信息：

![omg that’s nice (credit Facebook)](https://cdn-images-1.medium.com/max/3202/1*Icy2gSlrGAifYrI-cNddIg.png)

## 兼容性

### 异步渲染

React 16.0 的初始版本将聚焦于对现有应用的兼容性。异步渲染不会再一开始作为一个可选项，但是在之后的 16.x 的版本中，异步渲染会作为一个可选特性。

### 浏览器兼容性

React 16 依赖于 `Map` 及 `Set`。为了确保对所有浏览器兼容，你需要要引入相关 polyfill。目前流行的 polyfill 可选 [core-js](https://github.com/zloirock/core-js) 或 [babel-polyfill](https://babeljs.io/docs/usage/polyfill/)。

另外，React 16 也依赖于 `requestAnimationFrame`，这个依赖主要服务于测试。一个针对测试目的的 shim 可以是：

```js
global.requestAnimationFrame = function(callback) {
  setTimeout(callback);
};
```

### 组件声明周期

由于 React 实现了渲染的优先级设置，你无法再确保不同组件的 `componentWillUpdate` 和 `shouldComponentUpdate` 会按期望的顺序被调用。React 团队目前正致力于提供一个更新路径，来防止这些应用受到上面的行为的影响。

### 使用

截止到本文发布，目前的 React 16 还处于 beta 版本，但是很快它就会正式发布。你可以通过下面的方式尝试 React 16：

```
# yarn
yarn add react@next react-dom@next

# npm
npm install --save react@next react-dom@next
```

**如果你觉得本文对你很有用，请给我一个 *👏*。 [在 Medium 上关注我](https://medium.com/@treyhuffine)，你能阅读更多关于 React、Nonde.js、JavaScript 和开源软件的文章。你也可以在 [Twitter](https://twitter.com/twitter) 或者 [gitconnected](https://gitconnected.com/treyhuffine) 找到我。**
**gitconnected —— 一个软件开发者和工程师的社区。创建一个账户并登陆 gitconnected，这是一个当前最大的沟通开发者的社区。这是它的最新地址 [gitconnected.com](https://gitconnected.com/treyhuffine)**


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
