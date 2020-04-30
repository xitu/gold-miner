> * 原文地址：[A deep dive into React Fiber internals](https://blog.logrocket.com/deep-dive-into-react-fiber-internals/)
> * 原文作者：[Karthik Kalyanaraman](https://blog.logrocket.com/author/karthikkalyanaraman/) 
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/deep-dive-into-react-fiber-internals.md](https://github.com/xitu/gold-miner/blob/master/TODO1/deep-dive-into-react-fiber-internals.md)
> * 译者：[MarchYuanx](https://github.com/MarchYuanx)
> * 校对者：

# 深入了解 React Fiber 内部实现

![深入了解 React Fiber 内部实现](https://i1.wp.com/blog.logrocket.com/wp-content/uploads/2019/11/deep-dive-react-fiber-internals.jpeg?fit=730%2C486&ssl=1)

有没有想过当你调用 `ReactDOM.render(<App />, document.getElementById('root'))` 时发生了什么？

我们知道 ReactDOM 会在后台构建 DOM 树并将应用渲染在屏幕上。那么 React 实际上是如何构建 DOM 树的呢？当应用的 state 改变时，它又如何更新 DOM 树？

在本文中，我将首先说明在 React 15.0.0 之前 React 是如何构建 DOM 树的，这种模式的陷阱，以及 React 16.0.0 的新模型如何解决这些问题。这篇文章将涵盖广泛的概念，这些概念纯属内部实现细节，对于使用 React 进行的实际的前端开发，并不是绝对必要的。

## 栈协调器

让我们从熟悉的 `ReactDOM.render(<App />, document.getElementById('root'))` 开始。

ReactDOM 模块将把 `<App />` 传递给协调器。这里有两个问题：

1. `<App />` 指的是什么?
2. 协调器是什么?

让我们解开这两个问题。

`<App />` 是一个 React 元素，“描述树的元素”。

> “React 元素是描述对象实例或 DOM 节点及其所需属性的普通对象。” —— [React 博客](https://reactjs.org/blog/2015/12/18/react-components-elements-and-instances.html#elements-describe-the-tree)

换句话说，React 元素*不是*实际的 DOM 节点或组件实例；它们是一种*描述* React 的方式，它们是什么类型的元素，它们拥有的属性以及它们的子元素。

这正是 React 厉害之处。React 抽象了如何构建、渲染、管理真实 DOM 树的生命周期的所有复杂部分，从而有效地简化了开发人员的工作。要了解其真正含义，让我们看一下使用面向对象概念的传统方法。

在典型的面向对象的编程世界中，开发者需要实例化并管理每个 DOM 元素的生命周期。例如，如果你想要创建一个简单的表单和一个提交按钮，那么状态管理甚至对于像这样简单的事情都需要开发者的一些功夫。

[](https://blog.logrocket.com/deep-dive-into-react-fiber-internals/)

假设 Button 组件有一个 state 变量 isSubmitted。Button 组件的生命周期类似于以下流程图，其中每个 state 都需要由应用程序处理：

![按钮组件生命周期流程图](https://i0.wp.com/blog.logrocket.com/wp-content/uploads/2019/11/button-component-lifecycle.png?resize=730%2C465&ssl=1)

流程图的大小和代码行数随着 state 数量的增加而呈指数增长。

React 具有精确解决此问题的元素。在 React 中，有两种元素：

- DOM 元素: 当元素的类型为字符串时，例如 `<button class="okButton"> OK </button>`
- 组件元素: 当类型是类或函数时，例如 `<Button className="okButton"> OK </Button>`，其中 `<Button>` 是类或函数组件。这些是我们常用的典型的 React 组件

重要的是要了解这两种类型都是简单的对象。它们只是对需要在屏幕上渲染的内容的描述，在你创建实例化它们时并不会有实际的渲染发生。这使得 React 更容易解析和遍历它们来构建 DOM 树。实际的渲染将在遍历完成后进行。

当 React 遇到一个类或一个函数组件时，它会询问该元素，根据它的 props 该元素应该如何渲染。例如，如果 `<App>` 组件渲染以下内容：

```html
<Form>
  <Button>
    Submit
  </Button>
</Form>
```

然后 React 会根据它们对应的 props 询问`<Form>`和`<Button>`组件它们渲染什么。例如，如果`表单`组件是一个函数组件，如下所示：

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

此名称是从“栈”数据结构派生的，该数据结构是一种后进先出的机制。栈与我们刚刚看到的内容有什么关系？好吧，事实证明，由于我们有效地进行了递归，因此它与栈有关。

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

如我们所见，调用栈将每个对 `fib()` 的调用入栈，直到 `fib(1)` 出栈，这是返回的第一个函数调用。然后，它继续递归调用入栈，并在到达 return 语句时再次出栈。 这样，它有效地使用了调用栈，直到 fib(3) 返回并成为出栈的最后一项为止。

我们刚刚看到的协调算法是纯递归算法。更新导致整个子树立即重新渲染。虽然这很好用，但是有一些限制。如 [Andrew Clark 指出](https://github.com/acdlite/react-fiber-architecture)：

- 在用户界面中，无需立即应用每个更新；实际上，这样做可能是浪费的，导致丢帧并降低用户体验。
- 不同类型的更新具有不同的优先级 —— 动画更新需要比数据存储中的更新更快地完成。

现在，当我们说丢帧时，我们说的是什么？为什么递归方法会出现这个问题？为了掌握这一点，让我从用户体验的角度简要说明什么是帧频以及为什么它很重要。

帧频是连续图像出现在显示器上的频率。我们在计算机屏幕上看到的所有内容都是由屏幕上播放的帧或图像组成，并且以瞬时出现的速率显示。

要理解这是什么意思，可以将计算机显示屏看作一本翻页书，而将翻页书的页面看作是翻页时以一定速率播放的帧。换句话说，计算机显示器不过是一本自动翻页书，当屏幕上的事物发生变化时，它会一直播放。如果不够清楚，请观看[此视频](https://youtu.be/FV97j-z3B7U)。

通常，如果要让人眼对视频感觉到平滑并即时，那么视频需要以每秒 30 帧（FPS）的频率播放。高于此值将提供更好的体验。这就是为什么游戏玩家在玩第一人称射击游戏中喜欢更高的帧频的主要原因之一，精确度非常重要。

话虽这么说，如今大多数设备以 60 FPS 刷新屏幕，换句话说就是 1/60 = 16.67ms，这意味着每 16ms 就会显示一个新帧。这个数字非常重要，因为如果 React 渲染器花费 16ms 以上的时间在屏幕上渲染某些东西，浏览器将丢帧。

但是，实际上，浏览器有“家务活”要做，因此你的所有工作都需要在 10 ms 内完成。当你不能满足这个预算时，帧频下降，屏幕上的内容会抖动。这通常被称为 jank，会对用户体验产生负面影响。

当然，对于静态和文本内容来说，这并不是什么大问题。但在显示动画的情况下，此数字至关重要。因此，如果每次有更新时 React 协调算法遍历整个 `App` 树并重新渲染，如果遍历时间超过 16 ms，则会导致讨厌的丢帧的问题。

这是为什么最好按优先级对更新进行分类，而不是盲目地应用传递给协调器的每个更新的重要原因。另外，另一个不错的功能是能够在下一帧中暂停和恢复工作。这样，React 可以更好地控制其渲染用的 16 ms 预算。

这导致 React 团队重写了协调算法，新算法称为 Fiber。我认为有必要去了解 Fiber 是如何存在，为什么存在，它有什么意义。让我们看看 Fiber 是如何解决这个问题的。

## Fiber 工作原理

现在我们知道了 Fiber 的开发动机是什么，让我们总结实现 Fiber 所需的功能。

再次，我将引用 Andrew Clark 所指出的：

- 为不同类型的工作分配优先级
- 暂停工作，稍后再返回
- 如果不再需要，就中止工作
- 复用先前完成的工作

实现这样的事情的挑战之一是 JavaScript 引擎的工作方式，并且在某种程度上该语言缺乏线程。为了理解这一点，让我们简要地探讨一下 JavaScript 引擎如何处理执行上下文。

### JavaScript 执行栈

每当你使用 JavaScript 编写函数时，JS 引擎都会创建所谓的函数执行上下文。另外，每次 JS 引擎启动时，它都会创建一个全局执行上下文，其中包含全局对象 —— 例如，浏览器中的 `window` 对象和 Node.js 中的 `global` 对象。这两个上下文都是在 JS 中使用栈数据结构（也称为执行栈）处理的。

So, when you write something like this:

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

The JavaScript engine first creates a global execution context and pushes it into the execution stack. Then it creates a function execution context for the function `a()`. Since `b()` is called inside `a()`, it will create another function execution context for `b()` and push it into the stack.

When the function `b()` returns, the engine destroys the context of `b()`, and when we exit function `a()`, the context of `a()` is destroyed. The stack during execution looks like this:

![Execution Stack Diagram](https://i2.wp.com/blog.logrocket.com/wp-content/uploads/2019/11/execution-stack.png?resize=534%2C822&ssl=1)

But what happens when the browser makes an asynchronous event like an [HTTP request](https://blog.logrocket.com/how-to-make-http-requests-like-a-pro-with-axios/)? Does the JS engine stock the execution stack and handle the asynchronous event, or wait until the event completes?

The JS engine does something different here. On top of the execution stack, the JS engine has a queue data structure, also known as the event queue. The event queue handles asynchronous calls like HTTP or network events coming into the browser.

![Event Queue Diagram](https://i1.wp.com/blog.logrocket.com/wp-content/uploads/2019/11/event-queue-diagram.png?resize=730%2C542&ssl=1)

The way the JS engine handles the stuff in the queue is by waiting for the execution stack to become empty. So each time the execution stack becomes empty, the JS engine checks the event queue, pops items off the queue, and handles that event. It is important to note that the JS engine checks the event queue only when the execution stack is empty or the only item in the execution stack is the global execution context.

Although we call them asynchronous events, there is a subtle distinction here: the events are asynchronous with respect to when they arrive into the queue, but they're not really asynchronous with respect to when they get actually get handled.

Coming back to our stack reconciler, when React traverses the tree, it is doing so in the execution stack. So when updates arrive, they arrive in the event queue (sort of). And only when the execution stack becomes empty, the updates get handled. This is precisely the problem Fiber solves by almost reimplementing the stack with intelligent capabilities --- pausing and resuming, aborting, etc.

Again referencing Andrew Clark's notes here:

> "Fiber is reimplementation of the stack, specialized for React components. You can think of a single fiber as a virtual stack frame.
>
> The advantage of reimplementing the stack is that you can keep stack frames in memory and execute them however (and whenever) you want. This is crucial for accomplishing the goals we have for scheduling.
>
> Aside from scheduling, manually dealing with stack frames unlocks the potential for features such as concurrency and error boundaries. We will cover these topics in future sections."

In simple terms, a fiber represents a unit of work with its own virtual stack. In the previous implementation of the reconciliation algorithm, React created a tree of objects (React elements) that are immutable and traversed the tree recursively.

In the current implementation, React creates a tree of fiber nodes that can be mutated. The fiber node effectively holds the component's state, props, and the underlying DOM element it renders to.

And since fiber nodes can be mutated, React doesn't need to recreate every node for updates --- it can simply clone and update the node when there is an update. Also, in the case of a fiber tree, React doesn't do a recursive traversal; instead, it creates a singly linked list and does a parent-first, depth-first traversal.

### Singly linked list of fiber nodes

A fiber node represents a stack frame, but it also represents an instance of a React component. A fiber node comprises the following members:

#### Type

`<div>`, `<span>`, etc. for host components (string), and class or function for composite components.

#### Key

Same as the key we pass to the React element.

#### Child

Represents the element returned when we call `render()` on the component. For example:

```jsx
const Name = (props) => {
  return(
    <div className="name">
      {props.name}
    </div>
  )
}
```

The child of `<Name>` is `<div>` here as it returns a `<div>` element.

#### Sibling

Represents a case where `render` returns a list of elements.

```jsx
const Name = (props) => {
  return([<Customdiv1 />, <Customdiv2 />])
}
```

In the above case, `<Customdiv1>` and `<Customdiv2>` are the children of `<Name>`, which is the parent. The two children form a singly linked list.

#### Return

Represents the return back to the stack frame, which is logically a return back to the parent fiber node. Thus, it represents the parent.

#### `pendingProps` and `memoizedProps`

Memoization means storing the values of a function execution's result so you can use it later on, thereby avoiding recomputation. `pendingProps` represents the props passed to the component, and `memoizedProps` gets initialized at the end of the execution stack, storing the props of this node.

When the incoming `pendingProps` are equal to `memoizedProps`, it signals that the fiber's previous output can be reused, preventing unnecessary work.

#### `pendingWorkPriority`

A number indicating the priority of the work represented by the fiber. The [`ReactPriorityLevel`](https://github.com/facebook/react/blob/master/src/renderers/shared/fiber/ReactPriorityLevel.js) module lists the different priority levels and what they represent. With the exception of `NoWork`, which is zero, a larger number indicates a lower priority.

For example, you could use the following function to check if a fiber's priority is at least as high as the given level. The scheduler uses the priority field to search for the next unit of work to perform.

```js
function matchesPriority(fiber, priority) {
  return fiber.pendingWorkPriority !== 0 &&
         fiber.pendingWorkPriority <= priority
}
```

#### Alternate

At any time, a component instance has at most two fibers that correspond to it: the current fiber and the in-progress fiber. The alternate of the current fiber is the fiber in progress, and the alternate of the fiber in progress is the current fiber. The current fiber represents what is rendered already, and the in-progress fiber is conceptually the stack frame that has not returned.

#### Output

The leaf nodes of a React application. They are specific to the rendering environment (e.g., in a browser app, they are `div`, `span`, etc.). In JSX, they are denoted using lowercase tag names.

Conceptually, the output of a fiber is the return value of a function. Every fiber eventually has output, but output is created only at the leaf nodes by host components. The output is then transferred up the tree.

The output is eventually given to the renderer so that it can flush the changes to the rendering environment. For example, let's look at how the fiber tree would look for an app whose code looks like this:

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

![Fiber Tree Diagram](https://i0.wp.com/blog.logrocket.com/wp-content/uploads/2019/11/fiber-tree-diagram.png?resize=730%2C586&ssl=1)

We can see that the fiber tree is composed of singly linked lists of child nodes linked to each other (sibling relationship) and a linked list of parent-to-child relationships. This tree can be traversed using a [depth-first search](https://en.wikipedia.org/wiki/Depth-first_search).

### Render phase

In order to understand how React builds this tree and performs the reconciliation algorithm on it, I decided to write a unit test in the React source code and attached a debugger to follow the process.

If you're interested in this process, clone the React source code and navigate to [this directory](https://github.com/facebook/react/tree/769b1f270e1251d9dbdce0fcbd9e92e502d059b8/packages/react-dom/src/__tests__). Add a Jest test and attach a debugger. The test I wrote is a simple one that basically renders a button with text. When you click the button, the app destroys the button and renders a `<div>` with different text, so the text is a state variable here.

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

In the initial render, React creates a current tree, which is the tree that gets rendered initially.

`[createFiberFromTypeAndProps()](https://github.com/facebook/react/blob/f6b8d31a76cbbcbbeb2f1d59074dfe72e0c82806/packages/react-reconciler/src/ReactFiber.js#L593)` is the function that creates each React fiber using the data from the specific React element. When we run the test, put a breakpoint at this function, and look at the call stack, it looks something like this:

![createFiberFromTypeAndProps() Call Stack](https://i1.wp.com/blog.logrocket.com/wp-content/uploads/2019/11/function-call-stack-1.png?resize=730%2C716&ssl=1)

As we can see, the call stack tracks back to a `render()` call, which eventually goes down to `createFiberFromTypeAndProps()`. There are a few other functions that are of interest to us here: `workLoopSync()`, `performUnitOfWork()`, and `beginWork()`.

```js
function workLoopSync() {
  // Already timed out, so perform work without checking if we need to yield.
  while (workInProgress !== null) {
    workInProgress = performUnitOfWork(workInProgress);
  }
}
```

`workLoopSync()` is where React starts building up the tree, starting with the `<App>` node and recursively moving on to `<div>`, `<div>`, and `<button>`, which are the children of `<App>`. The `workInProgress` holds a reference to the next fiber node that has work to do.

`performUnitOfWork()` takes a fiber node as an input argument, gets the alternate of the node, and calls `beginWork()`. This is the equivalent to starting the execution of the function execution contexts in the execution stack.

When React builds the tree, `beginWork()` simply leads up to `createFiberFromTypeAndProps()` and creates the fiber nodes. React recursively performs work and eventually `performUnitOfWork()` returns a null, indicating that it has reached the end of the tree.

Now what happens when we do `instance.handleClick()`, which basically clicks the button and triggers a state update? In this case, React traverses the fiber tree, clones each node, and checks whether it needs to perform any work on each node. When we look at the call stack of this scenario, it looks something like this:

![instance.handleClick() Call Stack](https://i1.wp.com/blog.logrocket.com/wp-content/uploads/2019/11/function-call-stack-2.png?resize=730%2C517&ssl=1)

Although we did not see `completeUnitOfWork()` and `completeWork()` in the first call stack, we can see them here. Just like `performUnitOfWork()` and `beginWork()`, these two functions perform the completion part of the current execution which effectively means returning back to the stack.

As we can see, these four functions together perform the work of executing the unit of work, and also give control over the work being done currently, which is exactly what was missing in the stack reconciler. As we can see from the image below, each fiber node is composed of four phases required to complete that unit of work.

![Fiber Node Diagram](https://i0.wp.com/blog.logrocket.com/wp-content/uploads/2019/11/fiber-node-diagram.png?resize=730%2C405&ssl=1)

It's important to note here that each node doesn't move to `completeUnitOfWork()` until its children and siblings return `completeWork()`. For instance, it starts with `performUnitOfWork()` and `beginWork()` for `<App/>`, then moves on to `performUnitOfWork()` and `beginWork()` for Parent1, and so on. It comes back and completes the work on `<App>` once all the children of `<App/>` complete work.

This is when React completes its render phase. The tree that's newly built based on the `click()` update is called the `workInProgress` tree. This is basically the draft tree waiting to be rendered.

## Commit phase

Once the render phase completes, React moves on to the commit phase, where it basically swaps the root pointers of the current tree and `workInProgress` tree, thereby effectively swapping the current tree with the draft tree it built up based on the `click()` update.

![Commit Phase Diagram](https://i1.wp.com/blog.logrocket.com/wp-content/uploads/2019/11/commit-phase-diagram.png?resize=730%2C874&ssl=1)

Not just that, React also reuses the old current after swapping the pointer from Root to the `workInProgress` tree. The net effect of this optimized process is a smooth transition from the previous state of the app to the next state, and the next state, and so on.

And what about the 16ms frame time? React effectively runs an internal timer for each unit of work being performed and constantly monitors this time limit while performing the work. The moment the time runs out, React pauses the current unit of work being performed, hands the control back to the main thread, and lets the browser render whatever is finished at that point.

Then, in the next frame, React picks up where it left off and continues building the tree. Then, when it has enough time, it commits the `workInProgress` tree and completes the render.

## 结论

希望你喜欢这篇文章。如果有任何意见或问题，请随时发表。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
