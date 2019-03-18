> * 原文地址：[Under the hood of React’s hooks system](https://medium.com/the-guild/under-the-hood-of-reacts-hooks-system-eb59638c9dba)
> * 原文作者：[Eytan Manor](https://medium.com/@eytanmanor)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/under-the-hood-of-reacts-hooks-system.md](https://github.com/xitu/gold-miner/blob/master/TODO1/under-the-hood-of-reacts-hooks-system.md)
> * 译者：
> * 校对者：

# Under the hood of React’s hooks system

Looking at the implementation and getting to know it inside out

![](https://cdn-images-1.medium.com/max/800/1*pS_DCyF0S1gIjbxt6FAuPg.jpeg)

We’ve all heard about it. The new hook system of React 16.7 has made a lot of noise in the community. We’ve all tried it and tested it, and got really excited about it and its potential. When you think about hooks they’re kind of magical, somehow React manages your component without even exposing its instance (no use of `this` keyword). So how the heck does React does that?

Today I would like to dive into React’s implementation of hooks so we can understand it better. The problem with magical features is that it’s harder to debug a problem once it happens, because it’s backed by a complex stack trace. Thus, by having a deep knowledge regards React’s new hook system, we would be able to solve issues fairly quick once we encounter them, or even avoid them in the first place.

> _Before I begin I would just like to say that I’m not a developer/maintainer of React and that my words should be taken with a grain of salt. I did dive very deeply into the implementation of React’s hooks system, but by all means I can’t guarantee that this is how React actually works. With that said, I’ve backed my words with proofs and references from React’s source code, and tried to make my arguments as solid as possible._

![](https://cdn-images-1.medium.com/max/800/1*R-oovJm4IQBLDjZy6DvbBg.png)

A rough schematic representation of React’s hooks system

* * *

First of all, let’s go through the mechanism that ensures that hooks are called within React’s scope, because you’d probably know by now that hooks are meaningless if not called in the right context:

### The dispatcher

The dispatcher is the shared object that contains the hook functions. It will be dynamically allocated or cleaned up based on the rendering phase of ReactDOM, and it will ensure that the user doesn’t access hooks outside a React component (see [implementation](https://github.com/facebook/react/tree/5f06576f51ece88d846d01abd2ddd575827c6127/packages/react-reconciler/src/ReactFiberDispatcher.js#L24)).

The hooks are enabled/disabled by a flag called `enableHooks` right before we render the root component by simply switching to the right dispatcher; this means that technically we can enable/disable hooks at runtime. React 16.6.X also has the experimental feature implemented, but it’s actually disabled (see [implementation](https://github.com/facebook/react/tree/5f06576f51ece88d846d01abd2ddd575827c6127/packages/react-reconciler/src/ReactFiberScheduler.js#L1211)).

When we’re done performing the rendering work, we nullify the dispatcher and thus preventing hooks from being accidentally used outside ReactDOM’s rendering cycle. This is a mechanism that will ensure that the user doesn’t do silly things (see [implementation](https://github.com/facebook/react/tree/5f06576f51ece88d846d01abd2ddd575827c6127/packages/react-reconciler/src/ReactFiberScheduler.js#L1376)).

The dispatcher is resolved in each and every hook call using a function called `resolveDispatcher()`. Like I said earlier, outside the rendering cycle of React this should be meaningless, and React should print the warning message: _“Hooks can only be called inside the body of a function component”_ (see [implementation](https://github.com/facebook/react/tree/5f06576f51ece88d846d01abd2ddd575827c6127/packages/react/src/ReactHooks.js#L17)).

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

_Dispatcher implementation in a nutshell._

* * *

Now that we got that simple encapsulation mechanism covered, I would like us to move to the core of this article — the hooks. Right of the bet I’d like to introduce you to a new concept:

### The hooks queue

Behind the scenes, hooks are represented as nodes which are linked together in their calling order. They’re represented like so because hooks are not simply created and then left alone. They have a mechanism which allows them to be what they are. A hook has several properties which I would like you to bare in mind before diving into its implementation:

*   Its initial state is created in the initial render.
*   Its state can be updated on the fly.
*   React would remember the hook’s state in future renders.
*   React would provide you with the right state based on the calling order.
*   React would know which fiber does this hook belong to.

Accordingly, we need to rethink the way we view the a component’s state. So far we have thought about it as if it’s a plain object:

```
{
  foo: 'foo',
  bar: 'bar',
  baz: 'baz',
}
```

React state — the old way.

But when dealing with hooks it should be viewed as a queue, where each node represents a single model of the state:

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

React state — the new way.

The schema of a single hook node can be viewed in the [implementation](https://github.com/facebook/react/tree/5f06576f51ece88d846d01abd2ddd575827c6127/packages/react-reconciler/src/ReactFiberHooks.js#L243). You’ll see that the hook has some additional properties, but the key for understanding how hooks work lies within `memoizedState` and `next`. The rest of the properties are used specifically by the `useReducer()` hook to cache dispatched actions and base states so the reduction process can be repeated as a fallback in various cases:

*   `baseState` - The state object that would be given to the reducer.
*   `baseUpdate` - The most recent dispatched action that created the `baseState`.
*   `queue` - A queue of dispatched actions, waiting to go through the reducer.

Unfortunately I haven’t managed to get a good grasp around the reducer hook because I didn’t manage to reproduce almost any of its edge cases, so I wouldn’t feel comfortable to elaborate. I will only say that the reducer implementation is so inconsistent that even one of the comments in the [implementation](https://github.com/facebook/react/tree/5f06576f51ece88d846d01abd2ddd575827c6127/packages/react-reconciler/src/ReactFiberHooks.js:381) itself states that “(it’s) not sure if these are the desired semantics”; so how am I supposed to be sure?!

So back to hooks, before each and every function Component invocation, a function named `[prepareHooks()](https://github.com/facebook/react/tree/5f06576f51ece88d846d01abd2ddd575827c6127/react-reconciler/src/ReactFiberHooks.js:123)` is gonna be called, where the current fiber and its first hook node in the hooks queue are gonna be stored in global variables. This way, any time we call a hook function (`useXXX()`) it would know in which context to run.

```
let currentlyRenderingFiber
let workInProgressQueue
let currentHook

// Source: https://github.com/facebook/react/tree/5f06576f51ece88d846d01abd2ddd575827c6127/react-reconciler/src/ReactFiberHooks.js:123
function prepareHooks(recentFiber) {
  currentlyRenderingFiber = workInProgressFiber
  currentHook = recentFiber.memoizedState
}

// Source: https://github.com/facebook/react/tree/5f06576f51ece88d846d01abd2ddd575827c6127/react-reconciler/src/ReactFiberHooks.js:148
function finishHooks() {
  currentlyRenderingFiber.memoizedState = workInProgressHook
  currentlyRenderingFiber = null
  workInProgressHook = null
  currentHook = null
}

// Source: https://github.com/facebook/react/tree/5f06576f51ece88d846d01abd2ddd575827c6127/react-reconciler/src/ReactFiberHooks.js:115
function resolveCurrentlyRenderingFiber() {
  if (currentlyRenderingFiber) return currentlyRenderingFiber
  throw Error("Hooks can't be called")
}
// Source: https://github.com/facebook/react/tree/5f06576f51ece88d846d01abd2ddd575827c6127/react-reconciler/src/ReactFiberHooks.js:267
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

_Hooks queue implementation in a nutshell._

Once an update has finished, a function named `[finishHooks()](https://github.com/facebook/react/tree/5f06576f51ece88d846d01abd2ddd575827c6127/react-reconciler/src/ReactFiberHooks.js:148)` will be called, where a reference for the first node in the hooks queue will be stored on the rendered fiber in the `memoizedState` property. This means that the hooks queue and their state can be addressed externally:

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

An external read of a component’s memoized state.

* * *

Let’s get more specific and talk about individual hooks, starting with the most common of all — the state hook:

### State hooks

You would be surprised to know, but behind the scenes the `useState` hook uses `useReducer` and it simply provides it with a pre-defined reducer handler (see [implementation](https://github.com/facebook/react/blob/5f06576f51ece88d846d01abd2ddd575827c6127/packages/react-reconciler/src/ReactFiberHooks.js#L339)). This means that the results returned by `useState` are actually a reducer state, and an action dispatcher. I would like you to take a look at the reducer handler that the state hook uses:

```
function basicStateReducer(state, action) {
  return typeof action === 'function' ? action(state) : action;
}
```

State hook reducer, aka basic state reducer.

So as expected, we can provide the action dispatcher with the new state directly; but would you look at that?! We can also provide the dispatcher with _an action function that will receive the old state and return the new one._ T̶̶̶h̶̶̶i̶̶̶s̶̶̶ ̶̶̶i̶̶̶s̶̶̶n̶̶̶’̶̶̶t̶̶̶ ̶̶̶d̶̶̶o̶̶̶c̶̶̶u̶̶̶m̶̶̶e̶̶̶n̶̶̶t̶̶̶e̶̶̶d̶̶̶ ̶̶̶a̶̶̶n̶̶̶y̶̶̶w̶̶̶h̶̶̶e̶̶̶r̶̶̶e̶̶̶ ̶̶̶i̶̶̶n̶̶̶ ̶̶̶t̶̶̶h̶̶̶e̶̶̶ ̶̶̶[o̶̶̶f̶̶̶f̶̶̶i̶̶̶c̶̶̶i̶̶̶a̶̶̶l̶̶̶ ̶̶̶R̶̶̶e̶̶̶a̶̶̶c̶̶̶t̶̶̶ ̶̶̶d̶̶̶o̶̶̶c̶̶̶u̶̶̶m̶̶̶e̶̶̶n̶̶̶t̶̶̶a̶̶̶t̶̶̶i̶̶̶o̶̶̶n̶̶̶](https://reactjs.org/docs/hooks-reference.html#functional-updates) ̶̶̶(̶̶̶a̶̶̶s̶̶̶ ̶̶̶f̶̶̶o̶̶̶r̶̶̶ ̶̶̶t̶̶̶h̶̶̶e̶̶̶ ̶̶̶t̶̶̶i̶̶̶m̶̶̶e̶̶̶ ̶̶̶t̶̶̶h̶̶̶i̶̶̶s̶̶̶ ̶̶̶a̶̶̶r̶̶̶t̶̶̶i̶̶̶c̶̶̶l̶̶̶e̶̶̶ ̶̶̶w̶̶̶a̶̶̶s̶̶̶ ̶̶̶w̶̶̶r̶̶̶i̶̶̶t̶̶̶t̶̶̶e̶̶̶n̶̶̶)̶̶̶ ̶̶̶a̶̶̶n̶̶̶d̶̶̶ ̶̶̶ ̶t̶h̶a̶t̶’̶s̶ ̶a̶ ̶p̶i̶t̶y̶ ̶b̶e̶c̶a̶u̶s̶e̶ ̶i̶t̶’̶s̶ ̶e̶x̶t̶r̶e̶m̶e̶l̶y̶ ̶u̶s̶e̶f̶u̶l̶!̶ This means that when you send the state setter down the component tree you can run mutations against the current state of the parent component, without passing it as a different prop. For example:

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

Returning a new state relatively to the old one.

* * *

Lastly, effect hooks — which made a major impact on a component’s life cycle and how it works:

### Effect hooks

Effect hooks behave slightly differently and has an additional layer of logic that I would like to explain. Again, there are things I would like you to bare in mind regards the properties of the effect hooks before I dive into the implementation:

*   They’re created during render time, but they run _after_ painting.
*   If given so, they’ll be destroyed right before the next painting.
*   They’re called in their definition order.

> _Note that I’m using the “painting” term and not “rendering”. These two are different things, and I’ve seen many speakers in the recent_ [_React Conf_](https://conf.reactjs.org/) _use the wrong term! Even in the official_ [_React docs_](https://reactjs.org/docs/hooks-reference.html#useeffect) _they say “after the render is committed to the screen”, which is kind of like “painting”. The render method just creates the fiber node but doesn’t paint anything yet._

Accordingly, there should be another an additional queue that should hold these effects and should be addressed after painting. Generally speaking, a fiber holds a queue which contains effect nodes. Each effect is of a different type and should be addressed at its appropriate phase:

*   Invoke instances of `getSnapshotBeforeUpdate()` before mutation (see [implementation](https://github.com/facebook/react/tree/5f06576f51ece88d846d01abd2ddd575827c6127/packages/react-reconciler/src/ReactFiberScheduler.js#L646)).

*   Perform all the host insertions, updates, deletions and ref unmounts (see [implementation](https://github.com/facebook/react/tree/5f06576f51ece88d846d01abd2ddd575827c6127/packages/react-reconciler/src/ReactFiberScheduler.js#L687)).

*   Perform all life-cycles and ref callbacks. Life-cycles happen as a separate pass so that all placements, updates, and deletions in the entire tree have already been invoked. This pass also triggers any renderer-specific initial effects (see [implementation](https://github.com/facebook/react/tree/5f06576f51ece88d846d01abd2ddd575827c6127/packages/react-reconciler/src/ReactFiberScheduler.js#L732)).

*   Effects which were scheduled by the `useEffect()` hook - which are also known as “passive effects” based on the [implementation](https://github.com/facebook/react/tree/5f06576f51ece88d846d01abd2ddd575827c6127/packages/react-reconciler/src/ReactFiberScheduler.js#L779) (maybe we should start using this term within the React community?!).

When it comes to the hook effects, they should be stored on the fiber in a property called `updateQueue`, and each effect node should have the following schema (see [implementation](https://github.com/facebook/react/tree/5f06576f51ece88d846d01abd2ddd575827c6127/packages/react-reconciler/src/ReactFiberHooks.js#L477)):

*   `tag` - A binary number which will dictate the behavior of the effect (I will elaborate soon).
*   `create` - The callback that should be ran _after_ painting.
*   `destroy` - The callback returned from `create()` that should be ran _before_ the initial render.
*   `inputs` - A set of values that will determine whether the effect should be destroyed and recreated.
*   `next` - A reference to the next effect which was defined in the function Component.

Besides the `tag` property, the other properties are pretty straight forward and easy to understand. If you’ve studied hooks well, you’d know that React provides you with a couple of special effect hooks: `useMutationEffect()` and `useLayoutEffect()`. These two effects internally use `useEffect()`, which essentially mean that they create an effect node, but they do so using a different tag value.

The tag is composed out of a combination of binary values (see [implementation](https://github.com/facebook/react/tree/5f06576f51ece88d846d01abd2ddd575827c6127/packages/react-reconciler/src/ReactHookEffectTags.js)):

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

Supported hook effect types by React.

The most common use cases for these binary values would be using a pipeline (`|`) and add the bits as is to a single value. Then we can check whether a tag implements a certain behavior or not using an ampersand (`&`). If the result is non-zero, it means that the tag implements the specified behavior.

```
const effectTag = MountPassive | UnmountPassive
assert(effectTag, 0b11000000)
assert(effectTag & MountPassive, 0b10000000)
```

An example which shows how to use React’s binary design pattern.

Here are the supported hook effect types by React along with their tags (see [implementation](https://github.com/facebook/react/tree/5f06576f51ece88d846d01abd2ddd575827c6127/packages/react-reconciler/src/ReactFiberHooks.js:520)):

*   Default effect — `UnmountPassive | MountPassive`.
*   Mutation effect — `UnmountSnapshot | MountMutation`.
*   Layout effect — `UnmountMutation | MountLayout`.

And here’s how React checks for behavior implementation (see [implementation](https://github.com/facebook/react/tree/5f06576f51ece88d846d01abd2ddd575827c6127/packages/react-reconciler/src/ReactFiberCommitWork.js#L309)):

```
if ((effect.tag & unmountTag) !== NoHookEffect) {
  // Unmount
}
if ((effect.tag & mountTag) !== NoHookEffect) {
  // Mount
}
```

A real snapshot from React’s implementation.

So, based on what we’ve just learned regards effect hooks, we can actually inject an effect to a certain fiber externally:

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

Example of effects injection.

* * *

So that was it! What was your biggest takeout from this article? How are you gonna use this new knowledge in your React apps? Would love to see interesting comments!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
