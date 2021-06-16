> * 原文地址：[Svelte for the Experienced React Dev](https://css-tricks.com/svelte-for-the-experienced-react-dev/)
> * 原文作者：[Adam Rackis](https://css-tricks.com/author/adam-rackis/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/svelte-for-the-experienced-react-dev.md](https://github.com/xitu/gold-miner/blob/master/article/2021/svelte-for-the-experienced-react-dev.md)
> * 译者：
> * 校对者：

# Svelte for the Experienced React Dev

This post is an accelerated introduction to Svelte from the point of view of someone with solid experience with React. I’ll provide a quick introduction, and then shift focus to things like state management and DOM interoperability, among other things. I plan on moving somewhat quickly, so I can cover a lot of topics. At the end of the day, I’m mainly hoping to spark some interest in Svelte.

For a straightforward introduction to Svelte, no blog post could ever beat the official [tutorial](https://svelte.dev/tutorial/basics) or [docs](https://svelte.dev/docs).

## “Hello, World!” Svelte style

Let’s start with a quick tour of what a Svelte component looks like.

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

That content goes in a `.svelte` file, and is processed by the [Rollup](https://github.com/sveltejs/rollup-plugin-svelte) or [webpack](https://github.com/sveltejs/svelte-loader) plugin to produce a Svelte component. There’s a few pieces here. Let’s walk through them.

First, we add a `<script>` tag with any state we need.

We can also add a `<style>` tag with any CSS we want. These styles are **scoped to the component** in such a way that, here, `<h1>` elements in **this** component will be blue. Yes, scoped styles are built into Svelte, without any need for external libraries. With React, you’d typically need to use a third-party solution to achieve scoped styling, such as [css-modules](https://github.com/css-modules/css-modules), [styled-components](https://styled-components.com/), or the like (there are dozens, if not hundreds, of choices).

Then there’s the HTML markup. As you’d expect, there are some HTML bindings you’ll need to learn, like `{#if}`, `{#each}`, etc. These domain-specific language features might seem like a step back from React, where everything is “just JavaScript.” But there’s a few things worth noting: Svelte allows you to put arbitrary JavaScript **inside** of these bindings. So something like this is perfectly valid:

```svelte
{#if childSubjects?.length}
```

If you jumped into React from Knockout or Ember and never looked back, this might come as a (happy) surprise to you.

Also, the way Svelte processes its components is very different from React. React re-runs all components any time any state within a component, or anywhere in an ancestor (unless you “memoize”), changes. This can get inefficient, which is why React ships things like `useCallback` and `useMemo` to prevent un-needed re-calculations of data.

Svelte, on the other hand, analyzes your template, and creates targeted DOM update code whenever any **relevant** state changes. In the component above, Svelte will see the places where `number` changes, and add code to update the `<h1>` text after the mutation is done. This means you never have to worry about memoizing functions or objects. In fact, you don’t even have to worry about side-effect dependency lists, although we’ll get to that in a bit.

But first, let’s talk about …

## State management

In React, when we need to manage state, we use the `useState` hook. We provide it an initial value, and it returns a tuple with the current value, and a function we can use to set a new value. It looks something like this:

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

Our `setNumber` function can be passed wherever we’d like, to child components, etc.

Things are simpler in Svelte. We can create a variable, and update it as needed. Svelte’s [ahead-of-time compilation](https://en.wikipedia.org/wiki/Ahead-of-time_compilation) (as opposed to React’s just-in-time compilation) will do the footwork of tracking where it’s updated, and force an update to the DOM. The same simple example from above might look like this:

```jsx
<script>
  let number = 0;
</script>

<h1>Value: {number}</h1>
<button on:click={() => number++}>Increment</button>
<button on:click={() => number--}>Decrement</button>
```

Also of note here is that Svelte requires no single wrapping element like JSX does. Svelte has no equivalent of the React fragment `<></>` syntax, since it’s not needed.

But what if we want to pass an updater function to a child component so it can update this piece of state, like we can with React? We can just write the updater function like this:

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

Now, we pass it where needed — or stay tuned for a more automated solution.

### Reducers and stores

React also has the `useReducer` hook, which allows us to model more complex state. We provide a reducer function, and it gives us the current value, and a dispatch function that allows us to invoke the reducer with a given argument, thereby triggering a state update, to whatever the reducer returns. Our counter example from above might look like this:

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

Svelte doesn’t **directly** have something like this, but what it does have is called a **store**. The simplest kind of store is a writable store. It’s an object that holds a value. To set a new value, you can call `set` on the store and pass the new value, or you can call update, and pass in a callback function, which receives the current value, and returns the new value (exactly like React’s `useState`).

To read the current value of a store at a moment in time, there’s a [`get` function](https://svelte.dev/docs#get) that can be called, which returns its current value. Stores also have a subscribe function, which we can pass a callback to, and that will run whenever the value changes.

Svelte being Svelte, there’s some nice syntactic shortcuts to all of this. If you’re inside of a component, for example, you can just prefix a store with the dollar sign to read its value, or directly assign to it, to update its value. Here’s the counter example from above, using a store, with some extra side-effect logging, to demonstrate how subscribe works:

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

Notice that I also added a derived store above. [The docs](https://svelte.dev/docs#derived) cover this in depth, but briefly, `derived` stores allow you to project one store (or many stores) to a single, new value, using the same semantics as a writable store.

Stores in Svelte are incredibly flexible. We can pass them to child components, alter, combine them, or even make them read-only by passing through a derived store; we can even re-create some of the React abstractions you might like, or even need, if we’re converting some React code over to Svelte.

### React APIs with Svelte

With all that out of the way, let’s return to React’s `useReducer` hook from before.

Let’s say we really like defining reducer functions to maintain and update state. Let’s see how difficult it would be to leverage Svelte stores to mimic React’s `useReducer` API. We basically want to call our own `useReducer`, pass in a reducer function with an initial value, and get back a store with the current value, as well as a dispatch function that invokes the reducer and updates our store. Pulling this off is actually not too bad at all.

```jsx
export function useReducer(reducer, initialState) {
  const state = writable(initialState);
  const dispatch = (action) =>
    state.update(currentState => reducer(currentState, action));
  const readableState = derived(state, ($state) => $state);

  return [readableState, dispatch];
}
```

The usage in Svelte is almost identical to React. The only difference is that our current value is a store, rather than a raw value, so we need to prefix it with the `$` to read the value (or manually call `get` or `subscribe` on it).

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

### What about `useState`?

If you really love the `useState` hook in React, implementing that is just as straightforward. In practice, I haven’t found this to be a useful abstraction, but it’s a fun exercise that really shows Svelte’s flexibility.

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

### Are two-way bindings **really** evil?

Before closing out this state management section, I’d like to touch on one final trick that’s specific to Svelte. We’ve seen that Svelte allows us to pass updater functions down the component tree in any way that we can with React. This is frequently to allow child components to notify their parents of state changes. We’ve all done it a million times. A child component changes state somehow, and then calls a function passed to it from a parent, so the parent can be made aware of that state change.

In addition to supporting this passing of callbacks, Svelte also allows a parent component to two-way bind to a child’s state. For example, let’s say we have this component:

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

This creates a component, with a `val` prop. The `export` keyword is how components declare props in Svelte. Normally, with props, we **pass them in** to a component, but here we’ll do things a little differently. As we can see, this prop is modified by the child component. In React this code would be wrong and buggy, but with Svelte, a component rendering this component can do this:

```svelte
<!-- Parent.svelte -->
<script>
  import Child from "./Child.svelte";
        
  let parentVal;
</script>

<Child bind:val={parentVal} />
Parent Val: {parentVal}
```

Here, we’re **binding** a variable in the parent component, to the child’s `val` prop. Now, when the child’s `val` prop changes, our `parentVal` will be updated by Svelte, automatically.

Two-way binding is controversial for some. If you hate this then, by all means, feel free to never use it. But used sparingly, I’ve found it to be an incredibly handy tool to reduce boilerplate.

## Side effects in Svelte, without the tears (or stale closures)

In React, we manage side effects with the `useEffect` hook. It looks like this:

```jsx
useEffect(() => {
  console.log("Current value of number", number);
}, [number]);
```

We write our function with the dependency list at the end. On every render, React inspects each item in the list, and if any are referentially different from the last render, the callback re-runs. If we’d like to cleanup after the last run, we can return a cleanup function from the effect.

For simple things, like a number changing, it’s easy. But as any experienced React developer knows, `useEffect` can be insidiously difficult for non-trivial use cases. It’s surprisingly easy to accidentally omit something from the dependency array and wind up with a stale closure.

In Svelte, the most basic form of handling a side effect is a reactive statement, which looks like this:

```svelte
$: {
  console.log("number changed", number);
}
```

We prefix a code block with `$:` and put the code we’d like to execute inside of it. Svelte analyzes which dependencies are read, and whenever they change, Svelte re-runs our block. There’s no direct way to have the cleanup run from the last time the reactive block was run, but it’s easy enough to workaround if we really need it:

```svelte
let cleanup;
$: {
  cleanup?.();
  console.log("number changed", number);
  cleanup = () => console.log("cleanup from number change");
}
```

No, this won’t lead to an infinite loop: re-assignments from within a reactive block won’t re-trigger the block.

While this works, typically these cleanup effects need to run when your component unmounts, and Svelte has a feature built in for this: it has an [`onMount`](https://svelte.dev/docs#onMount) function, which allows us to return a cleanup function that runs when the component is destroyed, and more directly, it also has an [`onDestroy`](https://svelte.dev/docs#onDestroy) function that does what you’d expect.

### Spicing things up with actions

The above all works well enough, but Svelte really shines with actions. Side effects are frequently tied to our DOM nodes. We might want to integrate an old (but still great) jQuery plugin on a DOM node, and tear it down when that node leaves the DOM. Or maybe we want to set up a `ResizeObserver` for a node, and tear it down when the node leaves the DOM, and so on. This is a common enough requirement that Svelte builds it in with [actions](https://svelte.dev/docs#use_action). Let’s see how.

```svelte
{#if show}
  <div use:myAction>
    Hello                
  </div>
{/if}
```

Note the `use:actionName` syntax. Here we’ve associated this `<div>` with an action called `myAction`, which is just a function.

```js
function myAction(node) {
  console.log("Node added", node);
}
```

This action runs whenever the `<div>` enters the DOM, and passes the DOM node to it. This is our chance to add our jQuery plugins, set up our `ResizeObserver`, etc. Not only that, but we can also return a cleanup function from it, like this:

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

Now the `destroy()` callback will run when the node leaves the DOM. This is where we tear down our jQuery plugins, etc.

### But wait, there’s more!

We can even pass arguments to an action, like this:

```svelte
<div use:myAction={number}>
  Hello                
</div>
```

That argument will be passed as the second argument to our action function:

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

And if you’d like to do additional work whenever that argument changes, you can return an update function:

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

When the argument to our action changes, the update function will run. To pass multiple arguments to an action, we pass an object:

```svelte
<div use:myAction={{number, otherValue}}>
  Hello                
</div>
```

…and Svelte re-runs our update function whenever any of the object’s properties change.

Actions are one of my favorite features of Svelte; they’re incredibly powerful.

## Odds and Ends

Svelte also ships a number of great features that have no counterpart in React. There’s a number of form bindings (which [the tutorial covers](https://svelte.dev/tutorial/text-inputs)), as well as CSS [helpers](https://svelte.dev/docs#class_name).

Developers coming from React might be surprised to learn that Svelte also ships animation support out of the box. Rather than searching on npm and hoping for the best, it’s… built in. It even includes support for [spring physics, and enter and exit animations](https://css-tricks.com/svelte-and-spring-animations/), which Svelte calls **transitions**.

Svelte’s answer to `React.Chidren` are slots, which can be named or not, and are [covered nicely in the Svelte docs](https://svelte.dev/docs#slot). I’ve found them much simpler to reason about than React’s Children API.

Lastly, one of my favorite, almost hidden features of Svelte is that it can compile its components into actual web components. The [`svelte:options`](https://svelte.dev/docs#svelte_options) helper has a `tagName` property that enables this. But be sure to set the corresponding property in the webpack or Rollup config. With webpack, it would look something like this:

```js
{
  loader: "svelte-loader",
  options: {
    customElement: true
  }
}
```

## Interested in giving Svelte a try?

Any of these items would make a great blog post in and of itself. While we may have only scratched the surface of things like state management and actions, we saw how Svelte’s features not only match up pretty with React, but can even mimic many of React’s APIs. And that’s before we briefly touched on Svelte’s conveniences, like built-in animations (or transitions) and the ability to convert Svelte components into bona fide web components.

I hope I’ve succeeded in sparking some interest, and if I have, there’s no shortage of docs, tutorials, online courses, etc that dive into these topics (and more). Let me know in the comments if you have any questions along the way!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
