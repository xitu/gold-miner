> * 原文地址：[Under the hood of React’s hooks system](https://medium.com/the-guild/under-the-hood-of-reacts-hooks-system-eb59638c9dba)
> * 原文作者：[Eytan Manor](https://medium.com/@eytanmanor)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/under-the-hood-of-reacts-hooks-system.md](https://github.com/xitu/gold-miner/blob/master/TODO1/under-the-hood-of-reacts-hooks-system.md)
> * 译者：[EmilyQiRabbit](https://github.com/EmilyQiRabbit)
> * 校对者：[sunui](https://github.com/sunui)，[hanxiansen](https://github.com/hanxiansen)

# 深入 React Hook 系统的原理

首先我们看看它是如何实现的，然后再从里到外地了解它。

![](https://cdn-images-1.medium.com/max/800/1*pS_DCyF0S1gIjbxt6FAuPg.jpeg)

我们都听说过了它了。React 16.7 中的新特性：hook 系统，它已经在社区中激起了热议。我们都试用过并测试过它，对于它和它的潜能感到非常兴奋。你认为 hook 很神奇，React 竟然可以在不暴露实例的情况下（不需要使用 `this` 关键字），帮助你管理组件。那么 React 究竟是怎么做到的呢？

今天，我就要深入探究 React 是如何实现 hook 的，这样我们就能更好地理解它。像这样神奇特性存在的不足就是：当出现问题的时候，调试就非常困难，这是因为它是由复杂的栈踪迹（stack trace）支持的。因此，通过深入学习 React 的新 hook 系统，我们就能在遇到问题以后比较快地解决它，甚至可以直接杜绝问题的发生。

> **在开始之前，我想先声明我不是 React 的开发者或者维护者，所以我的话可能也并不是完全正确。我确实非常深入地研究过了 React 的 hook 系统，但是无论如何我仍无法保证这就是 React 实际的工作方式。话虽如此，我还是会用 React 源代码中的证据和引用来支持我这篇文章，使我的论点尽可能坚实。**

![](https://cdn-images-1.medium.com/max/800/1*R-oovJm4IQBLDjZy6DvbBg.png)

React hook 系统的简单示意图

* * *

首先，我们简单了解它的运行机制，确保 hook 在 React 的作用域内使用，因为也许你已经知道，如果 hook 不在正确的上下文中被调用，它就是无意义的：

### Dispatcher

Dispatcher 是一个包含了 hook 函数的共享对象。基于 ReactDOM 的渲染状态，它将会被动态的分配或者清理，并且它将会确保用户不能在 React 组件之外获取到 hook（详见[源码](https://github.com/facebook/react/tree/5f06576f51ece88d846d01abd2ddd575827c6127/packages/react-reconciler/src/ReactFiberDispatcher.js#L24)）。

在切换到正确的 Dispatcher 来呈现根组件之前，我们通过一个名为 `enableHooks` 的标志来启用/禁用 hook；在技术上来说，这就意味着我们可以在运行时开启或关闭 hook。React 16.6.X 版本的实验性功能中也加入了它，但它默认处于禁用状态（详见[源码](https://github.com/facebook/react/tree/5f06576f51ece88d846d01abd2ddd575827c6127/packages/react-reconciler/src/ReactFiberScheduler.js#L1211)）。

当我们完成渲染工作后，我们会废弃 dispatcher 并禁止 hook，来防止在 ReactDOM 的渲染周期之外不小心使用了它。这个机制能够保证用户不会做傻事（详见[源码](https://github.com/facebook/react/tree/5f06576f51ece88d846d01abd2ddd575827c6127/packages/react-reconciler/src/ReactFiberScheduler.js#L1376)）。

Dispatcher 在每次 hook 的调用中都会被函数 `resolveDispatcher()` 解析。正如我之前所说，在 React 的渲染周期之外，这就是无意义的了，React 将会打印出警告信息：**“Hooks 只能在函数组件内部调用”**（详见[源码](https://github.com/facebook/react/tree/5f06576f51ece88d846d01abd2ddd575827c6127/packages/react/src/ReactHooks.js#L17)）。

```
let currentDispatcher
const dispatcherWithoutHooks = { /* ... */ }
const dispatcherWithHooks = { /* ... */ }

function resolveDispatcher() {
  if (currentDispatcher) return currentDispatcher
  throw Error("Hooks can't be called")
}

function useXXX(...args) {
  const dispatcher = resolveDispatcher()
  return dispatcher.useXXX(...args)
}

function renderRoot() {
  currentDispatcher = enableHooks ? dispatcherWithHooks : dispatcherWithoutHooks
  performWork()
  currentDispatcher = null
}
```

**Dispatcher 的简单实现方式。**

* * *

现在我们了解了简单的封装机制，我们继续学习本文的核心 —— hook。接下来，我想给你介绍一个新的概念：

### Hook 队列

在 React 后台，hook 会被表示为节点，并以调用顺序连接起来。这样表示的原因是 hook 并不是被简单的创建然后丢弃，它们有一套独有的机制。一个 hook 会有数个属性，我希望在继续学习之前，你能记住它们：

*   在初次渲染的时候，它的初始状态会被创建
*   它的状态可以在运行时更新
*   React 可以在后续渲染中记住 hook 的状态
*   React 能根据调用顺序提供给你正确的状态
*   React 知道当前 hook 属于哪个部分

另外，我们需要重新思考我们看待组件状态的方式。目前，我们只把它看作一个简单的对象：

```
{
  foo: 'foo',
  bar: 'bar',
  baz: 'baz',
}
```

React 状态 —— 旧视角

但是当处理 hook 的时候，状态需要被看作是一个队列，每个节点都表示了对象的一个模块：

```
{
  memoizedState: 'foo',
  next: {
    memoizedState: 'bar',
    next: {
      memoizedState: 'bar',
      next: null
    }
  }
}
```

React 状态 —— 新的视角

单个 hook 节点的结构可以在[源码中](https://github.com/facebook/react/tree/5f06576f51ece88d846d01abd2ddd575827c6127/packages/react-reconciler/src/ReactFiberHooks.js#L243)查看。你将会发现，hook 还有一些附加的属性，但是弄明白 hook 运行的关键代码在于 `memoizedState` 和 `next`。其他的属性会被 `useReducer()` hook 使用，来缓存发送过的 action 以及基本的状态，这样在一些情况下，缩减（reduction）过程还可以作为后备被重复一次：

*   `baseState` —— 传给 reducer 的状态对象。
*   `baseUpdate` —— 最近一次创建 `baseState` 的已发送的 action。
*   `queue` —— 已发送 action 组成的队列，等待传入 reducer。

不幸的是，我还没有完全掌握 reducer 的 hook，因为我没办法复现它任何的边缘情况，所以讲述这部分就很困难。我就只简单的说一下，reducer 的实现显得很不一致，甚至它自己[源码](https://github.com/facebook/react/tree/5f06576f51ece88d846d01abd2ddd575827c6127/packages/react-reconciler/src/ReactFiberHooks.js:381)中的评论都声明“不确定这些是否是所需要的语义”；所以我怎么可能确定呢？！

所以我们还是回到对 hook 的讨论，在每个函数组件调用前，一个名为 [`prepareHooks()`](https://github.com/facebook/react/tree/5f06576f51ece88d846d01abd2ddd575827c6127/react-reconciler/src/ReactFiberHooks.js:123) 的函数将先被调用，在这个函数中，当前结构和 hook 队列中的第一个 hook 节点将被保存在全局变量中。这样，我们无论何时调用 hook 函数（`useXXX()`），它都能知道运行上下文。

```
let currentlyRenderingFiber
let workInProgressQueue
let currentHook

// 源代码：https://github.com/facebook/react/tree/5f06576f51ece88d846d01abd2ddd575827c6127/react-reconciler/src/ReactFiberHooks.js:123
function prepareHooks(recentFiber) {
  currentlyRenderingFiber = workInProgressFiber
  currentHook = recentFiber.memoizedState
}

// 源代码：https://github.com/facebook/react/tree/5f06576f51ece88d846d01abd2ddd575827c6127/react-reconciler/src/ReactFiberHooks.js:148
function finishHooks() {
  currentlyRenderingFiber.memoizedState = workInProgressHook
  currentlyRenderingFiber = null
  workInProgressHook = null
  currentHook = null
}

// 源代码：https://github.com/facebook/react/tree/5f06576f51ece88d846d01abd2ddd575827c6127/react-reconciler/src/ReactFiberHooks.js:115
function resolveCurrentlyRenderingFiber() {
  if (currentlyRenderingFiber) return currentlyRenderingFiber
  throw Error("Hooks can't be called")
}
// 源代码：https://github.com/facebook/react/tree/5f06576f51ece88d846d01abd2ddd575827c6127/react-reconciler/src/ReactFiberHooks.js:267
function createWorkInProgressHook() {
  workInProgressHook = currentHook ? cloneHook(currentHook) : createNewHook()
  currentHook = currentHook.next
  workInProgressHook
}

function useXXX() {
  const fiber = resolveCurrentlyRenderingFiber()
  const hook = createWorkInProgressHook()
  // ...
}

function updateFunctionComponent(recentFiber, workInProgressFiber, Component, props) {
  prepareHooks(recentFiber, workInProgressFiber)
  Component(props)
  finishHooks()
}
```

**Hook 队列的简单实现。**

一旦更新完成，一个名为 [`finishHooks()`](https://github.com/facebook/react/tree/5f06576f51ece88d846d01abd2ddd575827c6127/react-reconciler/src/ReactFiberHooks.js:148) 的函数将会被调用，在这个函数中，hook 队列的第一个节点的引用将会被保存在渲染了的结构的 `memoizedState` 属性中。这就意味着，hook 队列和它的状态可以在外部定位到。

```
const ChildComponent = () => {
  useState('foo')
  useState('bar')
  useState('baz')

  return null
}

const ParentComponent = () => {
  const childFiberRef = useRef()

  useEffect(() => {
    let hookNode = childFiberRef.current.memoizedState

    assert(hookNode.memoizedState, 'foo')
    hookNode = hooksNode.next
    assert(hookNode.memoizedState, 'bar')
    hookNode = hooksNode.next
    assert(hookNode.memoizedState, 'baz')
  })

  return (
    <ChildComponent ref={childFiberRef} />
  )
}
```

从外部读取某一组件记忆的状态

* * *

下面我们来更加专门的讨论某一类 hook，首先从使用最广泛的内容开始 —— state hook：

### State hook

你一定会很吃惊，但是 `useState` 这个 hook 在后台使用了 `useReducer`，并且它将 `useReducer` 作为预定义的 reducer（详见[源码](https://github.com/facebook/react/blob/5f06576f51ece88d846d01abd2ddd575827c6127/packages/react-reconciler/src/ReactFiberHooks.js#L339)）。这意味着，`useState` 返回的结果实际上已经是 reducer 的状态，同时也是 action dispatcher。请你看如下的 state hook 使用的 reducer 处理器：

```
function basicStateReducer(state, action) {
  return typeof action === 'function' ? action(state) : action;
}
```

State hook 的 reducer，又名基础状态 reducer。

所以正如你期望的那样，我们可以直接将 action dispatcher 和新的状态传入；但是你看到了吗？！我们也可以传入带 **action 函数**的 dispatcher，**这个 action 函数可以接收旧的状态并返回新的**。（在本篇文章写就时，这种方法并没有记录在[ React 官方文档](https://reactjs.org/docs/hooks-reference.html#functional-updates)中，很遗憾的是，它其实非常有用！）这意味着，当你向组件树发送状态设置器的时候，你可以修改父级组件修改状态，同时不用将它作为另一个属性传入，例如：

```
const ParentComponent = () => {
  const [name, setName] = useState()
  
  return (
    <ChildComponent toUpperCase={setName} />
  )
}

const ChildComponent = (props) => {
  useEffect(() => {
    props.toUpperCase((state) => state.toUpperCase())
  }, [true])
  
  return null
}
```

根据旧状态返回新状态。

* * *

最后，effect hook —— 它对于组件的生命周期影响很大，以及它是如何工作的：

### Effect hook

Effect hook 和其他 hook 的行为有一些区别，并且它有一个附加的逻辑层，这点我在后文将会解释。在我分析源码之前，我要重申一次，提到 effect hook 的属性的内容可能并不完全正确，大家要抱着质疑的态度。

*   它们在渲染时被创建，但是在浏览器绘制**后**运行。
*   如果给出了销毁指令，它们将在下一次绘制前被销毁。
*   它们会按照定义的顺序被运行。

> **注意，我使用了“绘制”而不是“渲染”。它们是不同的事情，在最近的 [React 会议](https://conf.reactjs.org/)中，我看到很多发言者错误的使用了这两个词！甚至在官方 [React 文档](https://reactjs.org/docs/hooks-reference.html#useeffect)中，也有写“在渲染生效于屏幕之后”，其实这个过程更像是“绘制”。渲染函数只是创建了组件节点，但是并没有绘制任何内容。**

因此，就应该有另一个队列，来保存这些 effect hook，并且在绘制后能够被定位到。通常来说，应该是组件保存包含了 effect 节点的队列。每个 effect 节点都是一个不同的类型，并能在适当的时候被定位到：

*   在修改之前调用 `getSnapshotBeforeUpdate()` 实例（详见[源码](https://github.com/facebook/react/tree/5f06576f51ece88d846d01abd2ddd575827c6127/packages/react-reconciler/src/ReactFiberScheduler.js#L646)）。

*   运行所有插入，更新，删除和 ref 的卸载（详见[源码](https://github.com/facebook/react/tree/5f06576f51ece88d846d01abd2ddd575827c6127/packages/react-reconciler/src/ReactFiberScheduler.js#L687)）。

*   运行所有生命周期函数和 ref 回调函数。生命周期函数会在一个独立的通道中运行，所以整个组件树中所有的替换、更新、删除都会被调用。这个过程还会触发任何特定于渲染器的初始 effect hook（详见[源码](https://github.com/facebook/react/tree/5f06576f51ece88d846d01abd2ddd575827c6127/packages/react-reconciler/src/ReactFiberScheduler.js#L732)）。

*   `useEffect()` hook 调度的 effect —— 也被称为“被动 effect”，它基于[这部分代码](https://github.com/facebook/react/tree/5f06576f51ece88d846d01abd2ddd575827c6127/packages/react-reconciler/src/ReactFiberScheduler.js#L779)（也许我们要开始在 React 社区内使用这个术语了？！）。

Hook effect 将会被保存在组件一个称为 `updateQueue` 的属性上，每个 effect 节点都有如下的结构（详见[源码](https://github.com/facebook/react/tree/5f06576f51ece88d846d01abd2ddd575827c6127/packages/react-reconciler/src/ReactFiberHooks.js#L477)）：

*   `tag` —— 一个二进制数字，它控制了 effect 节点的行为（后文我将详细说明）。
*   `create` —— 绘制**之后**运行的回调函数。
*   `destroy` —— 它是 `create()` 返回的回调函数，将会在初始渲染**前**运行。
*   `inputs` —— 一个集合，该集合中的值将会决定一个 effect 节点是否应该被销毁或者重新创建。
*   `next` —— 它指向下一个定义在函数组件中的 effect 节点。

除了 `tag` 属性，其他的属性都很简明易懂。如果你对 hook 很了解，你应该知道，React 提供了一些特殊的 effect hook：比如 `useMutationEffect()` 和 `useLayoutEffect()`。这两个 effect hook 内部使用了 `useEffect()`，实际上这就意味着它们能创建 effect hook，但是却使用了不同的 tag 属性值。

这个 tag 属性值是由二进制的值组合而成（详见[源码](https://github.com/facebook/react/tree/5f06576f51ece88d846d01abd2ddd575827c6127/packages/react-reconciler/src/ReactHookEffectTags.js)）：

```
const NoEffect = /*             */ 0b00000000;
const UnmountSnapshot = /*      */ 0b00000010;
const UnmountMutation = /*      */ 0b00000100;
const MountMutation = /*        */ 0b00001000;
const UnmountLayout = /*        */ 0b00010000;
const MountLayout = /*          */ 0b00100000;
const MountPassive = /*         */ 0b01000000;
const UnmountPassive = /*       */ 0b10000000;
```

React 支持的 hook effect 类型

这些二进制值中最常用的情景是使用管道符号（`|`）连接，将比特相加到单个某值上。然后我们就可以使用符号（`&`）检查某个 tag 属性是否能触发一个特定的动作。如果结果是非零的，就表示能触发。

```
const effectTag = MountPassive | UnmountPassive
assert(effectTag, 0b11000000)
assert(effectTag & MountPassive, 0b10000000)
```

如何使用 React 的二进制设计模式的示例

这里是 React 支持的 hook effect，以及它们的 tag 属性（详见[源码](https://github.com/facebook/react/tree/5f06576f51ece88d846d01abd2ddd575827c6127/packages/react-reconciler/src/ReactFiberHooks.js:520)）：

*   Default effect — `UnmountPassive | MountPassive`.
*   Mutation effect — `UnmountSnapshot | MountMutation`.
*   Layout effect — `UnmountMutation | MountLayout`.

以及这里是 React 如何检查动作触发的（详见[源码](https://github.com/facebook/react/tree/5f06576f51ece88d846d01abd2ddd575827c6127/packages/react-reconciler/src/ReactFiberCommitWork.js#L309)）：

```
if ((effect.tag & unmountTag) !== NoHookEffect) {
  // Unmount
}
if ((effect.tag & mountTag) !== NoHookEffect) {
  // Mount
}
```

React 源码节选

所以，基于我们刚才学习的关于 effect hook 的知识，我们可以实际操作，从外部向组件插入一些 effect：

```
function injectEffect(fiber) {
  const lastEffect = fiber.updateQueue.lastEffect

  const destroyEffect = () => {
    console.log('on destroy')
  }

  const createEffect = () => {
    console.log('on create')

    return destroy
  }

  const injectedEffect = {
    tag: 0b11000000,
    next: lastEffect.next,
    create: createEffect,
    destroy: destroyEffect,
    inputs: [createEffect],
  }

  lastEffect.next = injectedEffect
}

const ParentComponent = (
  <ChildComponent ref={injectEffect} />
)
```

插入 effect 的示例

* * *

这就是 hook 了！阅读本文你最大的收获是什么？你将如何把新学到的知识应用于 React 应用中？希望看到你留下有趣的评论！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
