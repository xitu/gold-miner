> * 原文地址：[A deep dive into React Fiber internals](https://blog.logrocket.com/deep-dive-into-react-fiber-internals/)
> * 原文作者：[Karthik Kalyanaraman](https://blog.logrocket.com/author/karthikkalyanaraman/) 
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/deep-dive-into-react-fiber-internals.md](https://github.com/xitu/gold-miner/blob/master/TODO1/deep-dive-into-react-fiber-internals.md)
> * 译者：[MarchYuanx](https://github.com/MarchYuanx)
> * 校对者：[JohnieXu](https://github.com/JohnieXu) [CoolRice](https://github.com/CoolRice)

# 深入了解 React Fiber 内部实现

![深入了解 React Fiber 内部实现](https://i1.wp.com/blog.logrocket.com/wp-content/uploads/2019/11/deep-dive-react-fiber-internals.jpeg?fit=730%2C486&ssl=1)

你是否曾思考过当调用 `ReactDOM.render(<App />, document.getElementById('root'))` 时 React 内部到底发生了什么？

我们知道 ReactDOM 会在后台构建 DOM 树并将应用渲染在屏幕上。那么 React 实际上是如何构建 DOM 树的呢？当应用的 state 改变时，它又如何更新 DOM 树？

在本文中，我将先介绍在 React 15.0.0 之前 React 构建 DOM 树的原理，以及其不足之处，然后再讲解 React 16.0.0 新的 DOM 渲染机制。这篇文章将涵盖大量关于 React 内部实现原理的细节，对于在常规使用 React 进行项目开发，这些可能并非必须掌握的。以及这个新的渲染机制解决是如何解决前一版本的不足的。

## 栈协调器

让我们从之前提到的 `ReactDOM.render(<App />, document.getElementById('root'))` 这段代码开始。

这里 `ReactDOM` 接收 `<App />` 作为参数，并将其传递给协调器（reconciler）。你可能会有如下两个疑问：

1. `<App />` 指的是什么?
2. 协调器（reconciler）又是什么?

下面将来回答这两个问题。

`<App />` 是一个 React 元素，用于描述 DOM 树的元素。

> “React 元素是描述组件实例或 DOM 节点及其所需属性的普通对象。” —— [React 博客](https://reactjs.org/blog/2015/12/18/react-components-elements-and-instances.html#elements-describe-the-tree)

换句话说，React 元素并非真实的 DOM 节点或组件实例，而是一种描述方式，用于描述 DOM 元素的类型、拥有的属性以及包含的子元素。

这正是 React 的核心所在，React 将构建、渲染以及管理真实 DOM 树生命周期这些复杂的逻辑进行了抽象，从而有效地简化了开发人员的工作。要彻底理解这样做的独到之处，我们可以对比看一下使用传统的面向对象思想如何处理。

在典型的面向对象的编程世界中，开发者需要实例化并管理每个 DOM 元素的生命周期。例如，如果开发者想要创建一个简单的表单和一个提交按钮，即使是对于它们的简单的状态管理，都需要开发者去单独维护。

[](https://blog.logrocket.com/deep-dive-into-react-fiber-internals/)

假设 `Button` 组件有一个 state 变量 `isSubmitted`。`Button` 组件的生命周期类似于以下流程图，其中每个 state 都需要由应用程序处理：

![Button 组件生命周期流程图](https://i0.wp.com/blog.logrocket.com/wp-content/uploads/2019/11/button-component-lifecycle.png?resize=730%2C465&ssl=1)

流程图的规模和代码行数随着 state 数量的增加而呈指数增长。

React 使用元素来巧妙地解决了这个问题。React 中存在两种元素：

- DOM 元素: 当元素的类型为字符串时，例如 `<button class="okButton"> OK </button>`
- 组件元素: 当类型是类或函数时，例如 `<Button className="okButton"> OK </Button>`，其中 `<Button>` 就是我们常用的典型的类组件、函数组件之一

重要的是要了解这两种类型都是简单的对象。它们只是对需要在屏幕上渲染的内容的描述，在你创建、实例化它们时并不会有实际的渲染发生。这使得 React 更容易解析和遍历它们来构建 DOM 树。而实际的渲染将在遍历完成后进行。

当 React 遇到一个类或一个函数组件时，它会询问该元素，根据它的 props 该元素应该如何渲染。例如，如果 `<App>` 组件渲染以下内容：

```html
<Form>
  <Button>
    Submit
  </Button>
</Form>
```

然后 React 会根据它们对应的 props 询问 `<Form>` 和 `<Button>` 组件它们渲染什么。例如，如果 `Form` 组件是一个函数组件，如下所示：

```jsx
const Form = (props) => {
  return(
    <div className="form">
      {props.form}
    </div>
  )
}
```

React 会调用 `render()` 以了解它渲染的元素，并最终会看到它渲染了一个带有子元素的 `<div>`。React 将重复此过程，直到知道页面上每个组件的基础 DOM 标签元素为止。

递归遍历树以了解 React 应用程序组件树的底层 DOM 标签元素的确切过程称为协调。在协调结束时，React 知道了 DOM 树的结果，并且像 react-dom 或 react-native 这样的渲染器将应用更新 DOM 节点所需的最小更改集。

因此，这意味着当你调用 `ReactDOM.render()` 或 `setState()` 时，React 将执行协调。在 setState 的情况下，它执行遍历并通过将新树与已渲染的树进行区分来找出树中发生了什么变化。然后，将这些更改应用于当前树，从而更新与 `setState()` 调用相关的 state。

现在我们了解了协调是什么，让我们看一下该模式的陷阱。

哦，顺便说一句 —— 为什么将此称为“栈”协调器？

此名称是从“栈”数据结构派生的，该数据结构是一种后进先出的机制。栈与我们刚刚看到的内容有什么关系？好吧，事实证明，由于我们实际上进行了递归，因此它与栈有关。

## 递归

要了解为什么会发生这种情况，让我们举一个简单的例子，看看[调用栈](https://developer.mozilla.org/en-US/docs/Glossary/Call_stack)中会发生什么。

```js
function fib(n) {
  if (n < 2){
    return n
  }
  return fib(n - 1) + fib (n - 2)
}

fib(10)
```

![调用栈图](https://i1.wp.com/blog.logrocket.com/wp-content/uploads/2019/11/call-stack-diagram.png?resize=730%2C352&ssl=1)

如我们所见，调用栈将每个对 `fib()` 的调用入栈，直到 `fib(1)` 出栈，这是返回的第一个函数调用。然后，它继续递归调用入栈，并在到达 return 语句时再次出栈。这样，它实际上使用了调用栈，直到 fib(3) 返回并成为出栈的最后一项为止。

我们刚刚看到的协调算法是纯递归算法。更新导致整个子树立即重新渲染。虽然这很好用，但是有一些限制。如 [Andrew Clark 指出](https://github.com/acdlite/react-fiber-architecture)：

- 在用户界面中，无需立即应用每个更新；实际上，这样做可能是浪费的，导致丢帧并降低用户体验。
- 不同类型的更新具有不同的优先级 —— 动画更新需要比数据存储中的更新更快地完成。

现在，当我们说丢帧时，我们说的是什么？为什么递归方法会出现这个问题？为了掌握这一点，让我从用户体验的角度简要说明什么是帧频以及为什么它很重要。

帧频是连续图像出现在显示器上的频率。我们在计算机屏幕上看到的所有内容都是由屏幕上播放的帧或图像组成，并且以瞬时出现的速率显示。

要理解这是什么意思，可以将计算机显示屏看作一本翻页书，而将翻页书的页面看作是翻页时以一定速率播放的帧。换句话说，计算机显示器不过是一本自动翻页书，当屏幕上的事物发生变化时，它会一直播放。如果不够清楚，请观看[此视频](https://youtu.be/FV97j-z3B7U)。

通常，如果要让人眼对视频感觉到平滑并即时，那么视频需要以每秒 30 帧（FPS）的频率播放。高于此值将提供更好的体验。这就是为什么游戏玩家在玩第一人称射击游戏中喜欢更高的帧频的主要原因之一，精确度非常重要。

话虽这么说，如今大多数设备以 60 FPS 刷新屏幕，换句话说就是 1/60 = 16.67ms，这意味着每 16ms 就会显示一个新帧。这个数字非常重要，因为如果 React 渲染器花费 16ms 以上的时间在屏幕上渲染某些东西，浏览器将丢帧。

但是，实际上，浏览器有“家务活”要做，因此你的所有工作都需要在 10 ms 内完成。当你不能满足这个预算时，帧频下降，屏幕上的内容会抖动。这通常被称为 jank，会对用户体验产生负面影响。

当然，对于静态和文本内容来说，这并不是什么大问题。但在显示动画的情况下，此数字至关重要。因此，如果每次有更新时 React 协调算法遍历整个 `App` 树并重新渲染，如果遍历时间超过 16 ms，则会导致令人讨厌的丢帧的问题。

这就是为什么最好按优先级对更新进行分类，而不是盲目地应用传递给协调器的每个更新的重要原因。另外，另一个不错的功能是能够在下一帧中暂停和恢复工作。这样，React 可以更好地控制其渲染用的 16 ms 预算。

这导致 React 团队重写了协调算法，新算法称为 Fiber。我认为有必要去了解 Fiber 是如何存在，为什么存在，它有什么意义。让我们看看 Fiber 是如何解决这个问题的。

## Fiber 工作原理

现在我们知道了 Fiber 的开发动机是什么，让我们总结实现 Fiber 所需的功能。

再次，我将引用 Andrew Clark 所指出的：

- 为不同类型的工作分配优先级
- 暂停和恢复工作
- 如果不再需要，就中止工作
- 复用先前完成的工作

实现这样的事情的挑战之一是 JavaScript 引擎的工作方式，并且在某种程度上该语言缺乏线程。为了理解这一点，让我们简要地探讨一下 JavaScript 引擎如何处理执行上下文。

### JavaScript 执行栈

每当你使用 JavaScript 编写函数时，JS 引擎都会创建所谓的函数执行上下文。另外，每次 JS 引擎启动时，它都会创建一个全局执行上下文，其中包含全局对象 —— 例如，浏览器中的 `window` 对象和 Node.js 中的 `global` 对象。这两个上下文都是在 JS 中使用栈数据结构（也称为执行栈）处理的。

因此，当你编写如下内容时：

```js
function a() {
  console.log("i am a")
  b()
}

function b() {
  console.log("i am b")
}

a()
```

JavaScript 引擎首先创建一个全局执行上下文，并将其推入执行栈。然后为 `a()` 函数创建函数执行上下文。由于 `b()` 在 `a()` 内部被调用，它将为 `b()` 创建另一个函数执行上下文并将其入栈。

当函数 `b()` 返回时，引擎将清除 `b()` 的上下文，而当我们退出函数 `a()` 时，将清除 `a()` 的上下文。执行期间的栈如下所示：

![执行栈图](https://i2.wp.com/blog.logrocket.com/wp-content/uploads/2019/11/execution-stack.png?resize=534%2C822&ssl=1)

但是，当浏览器发出像 [HTTP 请求](https://blog.logrocket.com/how-to-make-http-requests-like-a-pro-with-axios/)这样的异步事件时会发生什么？JS 引擎是存储执行栈并处理异步事件，还是等到事件完成？

JS 引擎在这里做了一些不同的事情。在执行堆栈的顶部，JS 引擎具有队列数据结构，也称为事件队列。事件队列处理进入浏览器的异步调用，例如 HTTP 请求或网络事件。

![事件队列图](https://i1.wp.com/blog.logrocket.com/wp-content/uploads/2019/11/event-queue-diagram.png?resize=730%2C542&ssl=1)

JS 引擎处理队列中内容的方式是等待执行栈变空。因此，每次执行堆栈变空时，JS 引擎都会检查事件队列，将里面的项目弹出队列，然后处理该事件。需要注意的是，JS 引擎只在执行栈为空或执行栈中只有全局执行上下文时才检查事件队列。

尽管我们称它们为异步事件，但这里有一个微妙的区别：事件相对于它们何时进入队列是异步的，但是相对于它们何时真正得到处理，它们并不是真正的异步。

回到我们的栈协调器，当 React 遍历树时，它正在执行栈中执行。因此，当获得更新时，它们到达事件队列（某种程度上）。只有当执行堆栈为空时，更新才会得到处理。这正是 Fiber 通过智能功能几乎重新实现栈来解决的问题 —— 暂停、继续和中止等。

在这里再次引用 Andrew Clark 所提到的：

> “Fiber 是对栈的重新实现，专用于 React 组件。你可以将单个的 Fiber 视为虚拟栈的帧。
>
> 重新实现栈的优点是，你可以将栈帧保留在内存中，并根据需要（以及在任何时候）执行它们。这对于实现我们计划的目标至关重要。
>
> 除了调度之外，手动处理堆栈帧还可以开放并发和错误边界等功能。我们将在以后的章节中介绍这些主题。”

简单来说，一个 fiber 相当于具有自己的虚拟栈的工作单元。在之前的协调算法实现中，React 创建了一个不可变的对象树（React 元素），并且递归遍历该树。

在当前的实现中，React 创建了一个可以变化的 fiber 节点树。fiber 节点有效地保存组件的 state、props 和它渲染的底层 DOM 元素。

而且由于 fiber 节点可以变化，React 不需要重新创建每个节点来进行更新 —— 它可以在更新时简单地克隆并更新节点。另外，对于 fiber 树，React 不会进行递归遍历。而是创建一个单链表，进行父级优先、深度优先的遍历。

### fiber 节点的单链表

一个fiber 节点代表一个栈帧，也代表一个 React 组件的实例。一个fiber 节点包括以下成员：

#### 类型

原生组件（字符串）的 `<div>`、`<span>` 等，复合组件的类或函数。

#### 健

与传给 React 元素的键相同。

#### 子元素

表示当我们在组件上调用 `render()` 时返回的元素。例如：

```jsx
const Name = (props) => {
  return(
    <div className="name">
      {props.name}
    </div>
  )
}
```

`<Name>` 的子元素是 `<div>`，因为它返回一个 `<div>` 元素。

#### 兄弟元素

代表 `render` 返回元素列表的情况。

```jsx
const Name = (props) => {
  return([<Customdiv1 />, <Customdiv2 />])
}
```

在上述情况下，`<Customdiv1>` 和 `<Customdiv2>` 是父元素 `<Name>` 的子元素。这两个子元素组成一个单链表。

#### 返回

表示返回栈帧，从逻辑上讲，它是返回到父 fiber 节点。 因此，它代表父级。

#### `pendingProps` 和 `memoizedProps`

记忆化指存储函数执行结果的值，以便以后可以使用它，从而避免重新计算。`pendingProps` 表示传递给组件的 props，而 `memoizedProps` 在执行栈的末尾初始化，存储该节点的 props。

当传入的 `pendingProps` 等于 `memoizedProps` 时，它表示 fiber 之前的输出可以复用，从而避免不必要的工作。

#### `pendingWorkPriority`

表示 fiber 工作优先级的数字。[`ReactPriorityLevel`](https://github.com/facebook/react/blob/master/src/renderers/shared/fiber/ReactPriorityLevel.js) 模块列出了不同的优先级及其代表的含义。除了为零的 `NoWork` 之外，数字越大优先级越低。

例如，可以使用以下函数检查某个 fiber 的优先级是否至少与给定的级别一样高。调度程序使用优先级字段搜索要执行的下一个工作单元。

```js
function matchesPriority(fiber, priority) {
  return fiber.pendingWorkPriority !== 0 &&
         fiber.pendingWorkPriority <= priority
}
```

#### 备用

任何时候，一个组件实例最多具有两个与其对应的 fiber：当前 fiber 和进行中 fiber。它们互为彼此的备用。当前 fiber 表示已经渲染的内容，而进行中 fiber 从概念上讲是尚未返回的栈帧。

#### 输出

React 应用程序的叶节点。它们专用于渲染环境（例如，在浏览器应用中，它们是 `div`、`span` 等）。在 JSX 中，它们用小写标签名表示。

从概念上讲，fiber 的输出是函数的返回值。每个 fiber 最终都有输出，但是输出仅由原生组件在叶节点上创建。输出之后将传到树上。

最终将输出提供给渲染器，以便可以将更改刷新到渲染环境。例如，让我们看看 fiber 树将如何查找代码如下所示的应用程序：

```jsx
const Parent1 = (props) => {
  return([<Child11 />, <Child12 />])
}

const Parent2 = (props) => {
  return(<Child21 />)
}

class App extends Component {
  constructor(props) {
    super(props)
  }
  render() {
    <div>
      <Parent1 />
      <Parent2 />
    </div>
  }
}

ReactDOM.render(<App />, document.getElementById('root'))
```

![Fiber 树图](https://i0.wp.com/blog.logrocket.com/wp-content/uploads/2019/11/fiber-tree-diagram.png?resize=730%2C586&ssl=1)

我们可以看到，fiber 树由相互链接的子节点的单链表（兄弟关系）和父子关系的链表组成。可以使用[深度优先搜索](https://en.wikipedia.org/wiki/Depth-first_search)遍历此树。

### 渲染阶段

为了理解 React 如何构建此树并对其执行协调算法，我决定在 React 源码中写一个单元测试，并附加一个调试器来追踪该过程。

如果你对此过程感兴趣，复制 React 源码并导航到[此目录](https://github.com/facebook/react/tree/769b1f270e1251d9dbdce0fcbd9e92e502d059b8/packages/react-dom/src/__tests__)。添加一个 Jest 测试并附加调试器。我编写的测试是一个简单的测试，基本上是渲染一个带文本的按钮。当你点击按钮时，应用程序会销毁该按钮，并渲染一个带不同文本的 `<div>`，因此文本在这里是一个 state 变量。

```jsx
'use strict';

let React;
let ReactDOM;

describe('ReactUnderstanding', () => {
  beforeEach(() => {
    React = require('react');
    ReactDOM = require('react-dom');
  });

  it('works', () => {
    let instance;
  
    class App extends React.Component {
      constructor(props) {
        super(props)
        this.state = {
          text: "hello"
        }
      }

      handleClick = () => {
        this.props.logger('before-setState', this.state.text);
        this.setState({ text: "hi" })
        this.props.logger('after-setState', this.state.text);
      }

      render() {
        instance = this;
        this.props.logger('render', this.state.text);
        if(this.state.text === "hello") {
        return (
          <div>
            <div>
              <button onClick={this.handleClick.bind(this)}>
                {this.state.text}
              </button>
            </div>
          </div>
        )} else {
          return (
            <div>
              hello
            </div>
          )
        }
      }
    }
    const container = document.createElement('div');
    const logger = jest.fn();
    ReactDOM.render(<App logger={logger}/>, container);
    console.log("clicking");
    instance.handleClick();
    console.log("clicked");

    expect(container.innerHTML).toBe(
      '<div>hello</div>'
    )

    expect(logger.mock.calls).toEqual(
      [["render", "hello"],
      ["before-setState", "hello"],
      ["render", "hi"],
      ["after-setState", "hi"]]
    );
  })

});
```

在初始渲染中，React创建一个当前树，该树是最初被渲染的树。

`[createFiberFromTypeAndProps()](https://github.com/facebook/react/blob/f6b8d31a76cbbcbbeb2f1d59074dfe72e0c82806/packages/react-reconciler/src/ReactFiber.js#L593)` 是使用来自特定 React 元素的数据创建每个 React fiber 的函数。当我们运行测试时，在此函数处放置一个断点，并查看调用栈，它看起来像这样：

![createFiberFromTypeAndProps() 调用栈](https://i1.wp.com/blog.logrocket.com/wp-content/uploads/2019/11/function-call-stack-1.png?resize=730%2C716&ssl=1)

如我们所见，调用栈会追踪到一个 `render()` 调用，该调用最终会返回到 `createFiberFromTypeAndProps()`。这里还有一些我们感兴趣的其他函数：`workLoopSync()`、`performUnitOfWork()` 和 `beginWork()`。

```js
function workLoopSync() {
  // Already timed out, so perform work without checking if we need to yield.
  while (workInProgress !== null) {
    workInProgress = performUnitOfWork(workInProgress);
  }
}
```

`workLoopSync()` 是 React 开始构建树的地方，从 `<App>` 节点开始，递归地转到 `<div>`、`<div>` 和 `<button>`，这些是 `<App>` 的子节点。`workInProgress` 保存对下一个有工作要做的 fiber 节点的引用。

`performUnitOfWork()` 将一个 fiber 节点作为输入参数，获取该节点的备用节点，然后调用 `beginWork()`。这相当于在执行栈中开始执行函数执行上下文。

当 React 构建树时, `beginWork()` 只会指向 `createFiberFromTypeAndProps()` 并创建 fiber 节点。React 递归执行工作，最终 `performUnitOfWork()` 返回 null, 表示它已到达树的末尾。

现在，当我们执行 `instance.handleClick()` 时会发生什么，基本上是单击按钮并触发状态更新？在这个情况，React 遍历 fiber 树，克隆每个节点，并检查它是否需要在某些节点上执行某些工作。当我们查看这个情况的调用栈时，它看起来像这样：

![instance.handleClick() 调用栈](https://i1.wp.com/blog.logrocket.com/wp-content/uploads/2019/11/function-call-stack-2.png?resize=730%2C517&ssl=1)

尽管我们在第一个调用堆栈中没有看到 `completeUnitOfWork()` 和 `completeWork()`，但是我们可以在这里看到它们。就像 `performUnitOfWork()` 和 `beginWork()` 一样，这两个函数执行当前执行的完成部分，这实际上意味着返回到栈。

如我们所见，这四个函数一起执行工作单元的工作，并且还控制当前正在完成的工作，这正是栈协调器中缺少的。如下图所示，每个 fiber 节点由完成该工作单元所需的四个阶段组成。

![Fiber 节点图](https://i0.wp.com/blog.logrocket.com/wp-content/uploads/2019/11/fiber-node-diagram.png?resize=730%2C405&ssl=1)

这里需要注意的是，在其子节点和兄弟节点返回 `completeWork()` 之前，每个节点都不会移动到 `completeUnitOfWork()`。例如，对于 `<App/>`，它从 `performUnitOfWork()` 和 `beginWork()` 开始，对于 Parent1，则转到 `performUnitOfWork()` 和 `beginWork()`，依此类推。一旦 `<App/>` 的所有子节点完成工作，它将返回并完成对 `<App>` 的工作。

这是 React 完成其渲染阶段的时间。 基于 `click()` 更新而新建的树称为 `workInProgress` 树。这基本上是等待渲染的草稿树。

## 提交阶段

渲染阶段完成后，React 进入提交阶段，在提交阶段，基本上是交换当前树和 `workInProgress` 树的根指针，从而有效地交换当前树与基于 `click()` 更新创建的草稿树。

![提交阶段图](https://i1.wp.com/blog.logrocket.com/wp-content/uploads/2019/11/commit-phase-diagram.png?resize=730%2C874&ssl=1)

不仅如此，在交换根指针到 `workInProgress` 树后，React 还复用了老的当前树。这个优化过程的净效果是从应用程序的前一个状态平稳过渡到下一个状态，下下个状态，依此类推。

那么 16 ms 的帧时间呢？React 有效地为正在执行的每个工作单元运行一个内部计时器，并在执行工作时持续监视此时间限制。时间一到，React 就会暂停当前正在执行的工作单元，交给主线程控制，并让浏览器渲染此时完成的所有内容。

然后，在下一帧，React 从它停止的地方开始，继续构建树。然后，当有足够的时间，它会提交 `workInProgress` 树并完成渲染。

## 结论

希望你喜欢这篇文章，如果有任何意见或问题，请在文章后面评论留言。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
