> * 原文地址：[Svelte for the Experienced React Dev](https://css-tricks.com/svelte-for-the-experienced-react-dev/)
> * 原文作者：[Adam Rackis](https://css-tricks.com/author/adam-rackis/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/svelte-for-the-experienced-react-dev.md](https://github.com/xitu/gold-miner/blob/master/article/2021/svelte-for-the-experienced-react-dev.md)
> * 译者：[没事儿](https://github.com/Tong-H)
> * 校对者：[liyaxuanliyaxuan](https://github.com/liyaxuanliyaxuan)、[CarlosChenN](https://github.com/CarlosChenN)、[霜羽 Hoarfroster](https://github.com/PassionPenguin)

# 面向具有 React 开发经验的开发者介绍 Svelte

这篇文章将从富有 React 开发经验的开发者的角度快速的介绍 Sevlte。首先我会做一个概览，然后重点关注 state 管理和 DOM 交互能力等等。我打算把进度加快一点，这样就能覆盖更多的话题。总之，希望能引起你对 Svelte 的兴趣。

关于对 Svelte 的介绍，没有任何博客可以和官方[教程](https://svelte.dev/tutorial/basics)和[文档](https://svelte.dev/docs)相比。

## “Hello, World!” Svelte 风格

让我们先快速浏览一遍 Svelte 的组件风格

```svelte
<script>
  let number = 0;
</script>

<style>
  h1 {
    color: blue;
  }
</style>

<h1>Value: {number}</h1>

<button on:click={() => number++}>Increment</button>
<button on:click={() => number--}>Decrement</button> 
```

这个内容被存放在 `.svelte` 文件中，通过 [Rollup](https://github.com/sveltejs/rollup-plugin-svelte) 或 [webpack](https://github.com/sveltejs/svelte-loader) 插件加工后生成 Svelte 组件。我们可以通过一些小片段了解。

首先，我们添加一个 `<script>` 标签存放所有我们需要的 state。

我们也可以添加一个 `<style>` 标签存放所有我们需要的 CSS。这些样式 **只作用于这个组件**，所以 `<h1>` 元素在**这个** 组件中将会是蓝色的。是的，被限制作用域的样式内置于 Svelte，不需要外部依赖。在 React 中，想要达到这样受限制的样式，你需要使用第三方插件类似 [css-modules](https://github.com/css-modules/css-modules), [styled-components](https://styled-components.com/), 或者其他的 (有几十种，甚至上百种选择).

接下来是一些 html 标记，像你预期的，你将需要学习类似 `{#if}`、`{#each}` 等 html 捆绑方法。相较于在 React 中，一切皆 JavaScript 的概念而言，这类特殊领域的语言功能可能看上去像是一个退步。但有几件事值得注意，Svelte 允许你在这些捆绑中放入任意的 JavaScript 代码。所以类似下面这类代码是完全有效的。

```svelte
{#if childSubjects?.length}
```

如果你之前是使用 Knockout 或者 Ember，但现在使用并且忠于 React，那么这可能会令你感到惊喜。

还有，Svelte 处理组件的方法和 React 完全不同。只要一个组件的状态或者父组件中的任何地方(除非你缓存了)发生了改变，React 会重新运行所有的组件。这可能会导致效率低下，这也是为什么 React 会使用 `useCallback` 和 `useMemo` 来防止额外的重新计算数据。

在另一方面，Svelte 会分析你的模板，并且在相关的状态改变时创建目标 DOM 的更新代码。在上面的组件中，Svelte 将会看到 `number`  在哪里改变，然后在变更完成后添加代码去更新 `<h1>`的内容，这表示你不需要担心函数或者对象的缓存。事实上，你甚至不需要担心副作用的依赖列表，我们稍后会讨论这个问题。

但是我们先谈论……

## State 管理

在 React 中，当我们需要管理 state 的时候，我们使用 `useState` hook。我们向它提供一个初始值，然后得到一个包含当前值和用于设置新值的函数的元组。看起来可能是这样： 

```jsx
import React, { useState } from "react";

export default function (props) {
  const [number, setNumber] = useState(0);
  return (
    <>
      <h1>Value: {number}</h1>
      <button onClick={() => setNumber(n => n + 1)}>Increment</button>
      <button onClick={() => setNumber(n => n - 1)}>Decrement</button>
    </>
  );
}
```

`setNumber`函数可以传递到任何地方，比如子组件等。

这个在 Svelte 中会简单点。我们可以创建一个变量，在需要时更新它。 Svelte 的[提前编译](https://en.wikipedia.org/wiki/Ahead-of-time_compilation)(和 React 即时更新不同)将会追踪变量更新的脚步，然后推动 DOM 更新。和上面一样简单的例子:

```jsx
<script>
  let number = 0;
</script>

<h1>Value: {number}</h1>
<button on:click={() => number++}>Increment</button>
<button on:click={() => number--}>Decrement</button>
```

 另一个需要注意的是，Svelte 不需要 JSX 那样的单独的包裹元素，也没有 React 片段语法 `<></>` 的等价物。

但如果我们想要传递一个更新函数给子组件呢？使它能更新这块的状态，就像我们用 React 做的那样，我们可以写一个更新函数：

```svelte
<script>
  import Component3a from "./Component3a.svelte";
        
  let number = 0;
  const setNumber = cb => number = cb(number);
</script>

<h1>Value: {number}</h1>

<button on:click={() => setNumber(val => val + 1)}>Increment</button>
<button on:click={() => setNumber(val => val - 1)}>Decrement</button>
```

现在，我们可以把这个更新函数传递到任何我们需要的地方，或者继续期待一个更自动化的解决方案。

### Reducer 和 store

React 还有 `useReducer` hook，让我们可以塑造更复杂的状态。我们提供一个 reducer 函数，然后得到我们当前的值，以及一个 dispatch 函数让我们可以用一个给定的参数去调用 reducer，从而触发一个状态更新，不管 reducer 返回的是什么。我们上面的计数器例子可能看起来会是这样：

```jsx
import React, { useReducer } from "react";

function reducer(currentValue, action) {
  switch (action) {
    case "INC":
      return currentValue + 1;
    case "DEC":
      return currentValue - 1;
  }
}

export default function (props) {
  const [number, dispatch] = useReducer(reducer, 0);
  return (
    <div>
      <h1>Value: {number}</h1>
      <button onClick={() => dispatch("INC")}>Increment</button>
      <button onClick={() => dispatch("DEC")}>Decrement</button>
    </div>
  );
}
```

Svelte 没有类似的功能，但是它有一个称为 **store** 的模块。最简单的是 writable store，是持一个值的 object。想要设置一个新值，你可以调用 store 上的 `set` 方法并传递一个新值，或者调用 update，传入一个回调函数，这个函数接受当前值并且返回新值(和 React 的 `useState`一样).

在需要时读取 store 的当前值，可以调用[`get` 函数](https://svelte.dev/docs#get)，它会返回当前值。Store 也有一个 subscribe 函数，我们可以传入一个回调函数，在值改变时被执行。

Svelte 是简洁轻量的，其中有一些不错的语法快捷方式。如果你在一个组件内部，你可以给 store 加一个 $ 前缀用于读取其值，或者通过直接赋值去更新值。这是上面的计数器例子，使用了一个 store，以及一些额外的副作用日志打印用于展示 subscribe 是如何工作的：

```svelte
<script>
  import { writable, derived } from "svelte/store";
        
  let writableStore = writable(0);
  let doubleValue = derived(writableStore, $val => $val * 2);
        
  writableStore.subscribe(val => console.log("current value", val));
  doubleValue.subscribe(val => console.log("double value", val))
</script>

<h1>Value: {$writableStore}</h1>

<!-- manually use update -->
<button on:click={() => writableStore.update(val => val + 1)}>Increment</button>
<!-- use the $ shortcut -->
<button on:click={() => $writableStore--}>Decrement</button>

<br />

Double the value is {$doubleValue}
```

注意，我在上面添加了一个 `derived` store。[文档](https://svelte.dev/docs#derived)深入的介绍了这个，但简单来说，`derived` store 让你可以使用和 writable store 一样的语法，让一个 store (或许多 store) 映射出一个新值。

Svelte 中的 Store 非常灵活。我们可以将多个 store 传递到子组件中，更改、组合它们，甚至通过传递一个 derived store 使它们只读。如果我们要把一些 React 的代码转化为 Svelte，我们甚至可以重建一些你可能喜欢或需要的 React 抽象。

### React API 与 Svelte

说完这些，让我们回到之前 React 的 `useReducer` hook 上。

我们的确是真的喜欢通过定义 reducer 函数来维护和更新 state。让我们看看使用 Svelte 的 store 去模仿 React 的 `useReducer` 会有多难。我们想要调用我们自己的 `useReducer`，传入一个带有初始值的 reducer 函数，然后得到带有当前值的 store，这和 dispatch 函数调用 reducer 去更新 store 是一样的，完成这个任务实际上不算太糟糕。

```jsx
export function useReducer(reducer, initialState) {
  const state = writable(initialState);
  const dispatch = (action) =>
    state.update(currentState => reducer(currentState, action));
  const readableState = derived(state, ($state) => $state);

  return [readableState, dispatch];
}
```

Svelte 的用法和 React 几乎是一样的。唯一的区别是我们当前的值是一个 store，而不是一个原始值，所以我们需要加上一个 `$` 前缀来读取值(或者手动调用 store 上的 `get` 或 `subscribe` )。

```svelte
<script>
  import { useReducer } from "./useReducer";
        
  function reducer(currentValue, action) {
    switch (action) {
      case "INC":
        return currentValue + 1;
      case "DEC":
        return currentValue - 1;
    }
  }
  const [number, dispatch] = useReducer(reducer, 0);      
</script>

<h1>Value: {$number}</h1>

<button on:click={() => dispatch("INC")}>Increment</button>
<button on:click={() => dispatch("DEC")}>Decrement</button>
```

### 那么 `useState` 呢？

如果你真的喜欢 React 的 `useState` hook，实现也很简单。实际上，我并没有觉得这是一个很有用的抽象，但这是个有趣的练习，可以展示 Svelte 的灵活性。

```svelte
export function useState(initialState) {
  const state = writable(initialState);
  const update = (val) =>
    state.update(currentState =>
      typeof val === "function" ? val(currentState) : val
    );
  const readableState = derived(state, $state => $state);

  return [readableState, update];
}
```

### 双向绑定**真的**糟糕吗？

在结束 state 管理这部分之前，我要提及最后一个对 Svelte 而言比较特殊的技巧。我们已经知道了 Svelte 允许我们使用任何我们能用的 Rect 方法来传递更新函数到组件树。允许子组件通知他们的父组件，state 变化，这是个频繁的操作，我们已经做了几千次。一个子组件改变了 state，然后调用一个父组件传递过来的函数，这样父组件就可以接收 state 改变。

除了支持回调函数的传递，Svelte 也允许父组件与子组件 state 的双向绑定。比如，我们有这样一个组件：

```svelte
<!-- Child.svelte -->
<script>
  export let val = 0;
</script>

<button on:click={() => val++}>
  Increment
</button>

Child: {val}
```

上面的例子创建一个带有 `val` 属性的组件。在 Svelte 中，`export` 关键字用于组件声明 props。通常，我们会把 props 传入到一个组件中，但这里有点不同。比如上面的例子，`val` prop 被子组件修改了。在 React 中，这是错误的，可能会引发 bug，但在 Svelte 中，渲染这个组件的组件可以做这个。

```svelte
<!-- Parent.svelte -->
<script>
  import Child from "./Child.svelte";
        
  let parentVal;
</script>

<Child bind:val={parentVal} />
Parent Val: {parentVal}
```

这里，在父组件中我们为子组件的 `val` prop 重新**绑定**了一个变量。如果子组件的 `val` prop 变化，那么父组件的 `parentVal` 也会自动被 Svelte 更新。

双向绑定是存在一些争论。如果你不喜欢，那就不要用它。但是少量使用，我认为这会是一个非常方便的工具，可以减少模板。

## Svelte 中的副作用没有分离(或者过时的闭包)

在 React 中，我们使用 `useEffect` hook 管理副作用。像这样：

```jsx
useEffect(() => {
  console.log("Current value of number", number);
}, [number]);
```

我们写了一个函数，以及依赖列表。每一次渲染，React 都会检查列表中的每一个元素，如果有一个与上一次渲染时不同，那么这个回调函数就会再次运行。如果我们想要在上一次运行后运行一个 cleanup 函数，那么我们可以从 effect 中返回一个 cleanup 函数。

像数字变化这类简单的需求，这很简单。但是任何有经验的 React 开发者都知道，对于非琐碎的使用案例，`useEffect` 会是个潜在的麻烦。这非常容易，在依赖列表遗漏一些什么从而引发过时的闭包问题。

在 Svelte 中，操作副作用最基础的形式是反应性的声明。看起来像这样。

```svelte
$: {
  console.log("number changed", number);
}
```

给一个代码块加上一个前缀 `$:`，然后放入我们想要执行的代码。Svelte 分析哪个依赖被读，只要它们改变，Svelte 会重新运行这个代码块。没有直接的方法可以在上一次这个反应性代码块运行后去运行 cleanup，如果真的需要可以做一个替代方法，这非常简单。

```svelte
let cleanup;
$: {
  cleanup?.();
  console.log("number changed", number);
  cleanup = () => console.log("cleanup from number change");
}
```

这并不会导致无限循环：在一个反应性的代码块内重新赋值不会再引发这个代码块运行。

这是有效的，cleanup effects 通常会用在组件卸载时，Svelte 对此有一个内置功能 [`onMount`函数](https://svelte.dev/docs#onMount)，使我们可以返回一个 cleanup 函数能够在组件销毁时执行，更直接还有一个[`onDestroy`函数](https://svelte.dev/docs#onDestroy)，可以做我们想做的事。

### action 来增加一些趣味

以上的一切都很好用，但 action 才是 Svelte 的最大亮点。副作用频繁的捆绑 DOM 节点。我们可能想在一个 DOM 节点上集成一个老式的(但仍然很不错) jQuery 插件，然后在节点离开 DOM 的时候拆除它；或者我们想为一个节点设置一个 `ResizeObserver`，然后在节点离开 DOM 的时候分离它，等等。这是非常普通的需求，Svelte 将其内置在 [action](https://svelte.dev/docs#use_action) 中。让我们一起去看看。

```svelte
{#if show}
  <div use:myAction>
    Hello                
  </div>
{/if}
```

注意这个语法 `use:actionName`。这里我们将 `<div>` 与一个称作 `myAction` 的 action 捆绑，这个 action 只是个函数。

```js
function myAction(node) {
  console.log("Node added", node);
}
```

只要 `<div>` 进入 DOM，就会调用这个 action，并且传递这个 DOM 节点给 action。这是一个时机可以去添加 jQuery 插件以及设置 `ResizeObserver` 等等。不只这样，我们还可以从中返回一个 cleanup 函数，比如这样：

```js
function myAction(node) {
  console.log("Node added", node);

  return {
    destroy() {
      console.log("Destroyed");
    }
  };
}
```

当节点离开 DOM 的时候，`destroy()` 将会执行，这是我们销毁 jQuery 插件的地方。

### 慢着，还有！

我们还可以传递参数给 action, 像这样：

```svelte
<div use:myAction={number}>
  Hello                
</div>
```

这个参数将作为 action 函数的第二个参数。

```js
function myAction(node, param) {
  console.log("Node added", node, param);

  return {
    destroy() {
      console.log("Destroyed");
    }
  };
}
```

如果你想在参数变化时做额外的工作，你可以返回一个 update 函数。

```js
function myAction(node, param) {
  console.log("Node added", node, param);

  return {
    update(param) {
      console.log("Update", param);
    },
    destroy() {
      console.log("Destroyed");
    }
  };
}
```

当传递给 action 的参数变化时，update 函数将会运行。向一个 action 传递多个参数，我们可以传递一个 object。

```svelte
<div use:myAction={{number, otherValue}}>
  Hello                
</div>
```

只要 object 的属性改变，Svelte 就会再次运行 update 函数。

Actions 是我最喜欢的 Svelte 功能之一，它们非常强大。

## 其他

Svelte 还有很多其他的，React 没有与之相对的功能。还有很多表单捆绑（[教程有涵盖](https://svelte.dev/tutorial/text-inputs)），以及 CSS [辅助](https://svelte.dev/docs#class_name)。

来自 React 的开发者可能会惊喜，Svelte 开箱即用的动画。与其在 npm 里搜索然后希望能找到最好的，不如…内置。它甚至包含了[弹性动画，进入离开的动画](https://css-tricks.com/svelte-and-spring-animations/)，Svelte 称之为**transitions**。

对于 `React.Chidren`，Svelte 与之对应的是 slots，[Svelte 的文档很好的讲解了这个](https://svelte.dev/docs#slot)。我发现它们比 React’s Children API 更简单些。

最后，我最喜欢的功能之一，几乎算是隐藏的功能，通过 [`svelte:options`](https://svelte.dev/docs#svelte_options) 的属性`tagName`，Svelte 可以将自己的组件编译为真实的 web 组件。但一定要在 webpack 或 Rollup 配置中设置对应的属性。在 webpack 中是这样的：

```js
{
  loader: "svelte-loader",
  options: {
    customElement: true
  }
}
```

## 有兴趣试试 Svelte 吗

这篇文章中的任何一个知识点都可以单独拧出来写一个 blog 了，比如 state 管理和 actions，而我们可能只了解到了一些皮毛，我们看到了 Svelte 的功能，不仅是与 React 相匹配，甚至可以模仿很多 React 的 API。然后之前我们简单的谈到了一些 Svelte 的便利，比如内置动画（或者过渡）以及将 Svelte 组件转化为真实的 web 组件。

我希望我成功的激起了你的兴趣，有很多文章，教程或者在线课程等等可以更深入探究。如果你有任何问题可以在评论区告诉我。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
