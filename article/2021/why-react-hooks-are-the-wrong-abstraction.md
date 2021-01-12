> * 原文地址：[Why React Hooks Are the Wrong Abstraction](https://medium.com/better-programming/why-react-hooks-are-the-wrong-abstraction-8a44437747c1)
> * 原文作者：[Austin Malerba](https://medium.com/@austinmalerba)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/why-react-hooks-are-the-wrong-abstraction.md](https://github.com/xitu/gold-miner/blob/master/article/2021/why-react-hooks-are-the-wrong-abstraction.md)
> * 译者：
> * 校对者：

# Why React Hooks Are the Wrong Abstraction

![Photo by the author.](https://cdn-images-1.medium.com/max/5576/1*LVjLXZ8-mBmhJZoJj3w_3w.png)

Before I get started, I’d like to express how grateful I am for all of the work that the React team has put in over the years. They’ve created an awesome framework that, in many ways, was my introduction to the modern web. They have paved the path for me to believe in the ideas I’m about to present and I would not have arrived at these conclusions without their ingenuity.

In today’s article, I would like to walk through my observed shortcomings of Hooks and propose an alternative API that is as capable but with fewer caveats. I’ll say right now that this [alternative API](https://malerba118.github.io/elementos-docs/) is a bit verbose, but it is less computationally wasteful, more conceptually accurate, and it’s framework-agnostic.

## Hooks Problem #1: Attached During Render

As a general rule of design, I’ve found that we should always first try to disallow our users from making mistakes. Only if we’re unable to prevent the user from making a mistake should we then inform them of the mistake after they’ve made it.

For example, when allowing a user to enter a quantity in an input field, we could allow them to enter alphanumeric characters and then show them an error message if we find an alphabetic character in their input. However, we could provide better UX if we only allowed them to enter numeric characters in the field, which would eliminate the need to check whether they have included alphabetic characters.

React behaves quite similarly. If we think about Hooks conceptually, they are static through the lifetime of a component. By this, I mean that once declared, we cannot remove them from a component or change their position in relation to other Hooks. React uses lint rules and will throw errors to try to prevent developers from violating this detail of Hooks.

In this sense, React allows the developer to make mistakes and then tries to warn the user of their mistakes afterward. To see what I mean, consider the following example:

```JSX
const App = () => {
  const [countOne, setCountOne] = useState(0);
  if (countOne === 0) {
    const [countTwo, setCountTwo] = useState(0);
  }

  return (
    <button
      onClick={() => {
        setCountOne((prev) => prev + 1);
      }}
    >
      Increment Count One: {countOne}
    </button>
  );
};
```

This produces an error on the second render when the counter is incremented because the component will remove the second `useState` hook:

```
Error: Rendered fewer hooks than expected. This may be caused by an accidental early return statement.
```

The placement of our Hooks during a component’s first render determines where the Hooks must be found by React on every subsequent render.

Given that Hooks are static through the lifetime of a component, wouldn’t it make more sense for us to declare them on component construction as opposed to during the render phase? If we attach Hooks during the construction of a component, we no longer need to worry about enforcing the rules of Hooks because a hook would never be given another chance to change positions or be removed during the lifetime of a component.

Unfortunately, function components were given no concept of a constructor, but let’s pretend that they were. I imagine that it would look something like the following:

```JSX
const App = createComponent(() => {
  // This is a constructor function that only runs once 
  // per component instance.
  
  // We would declare our hooks in the constructor.
  const [count, setCount] = useState(0)
  
  // The constructor function returns a render function.
  return (props, state) => (
    <div>
      {/*...*/}
    </div>
  );
});
```

By attaching our Hooks to the component in a constructor, we wouldn’t have to worry about them shifting during re-renders.

If you’re thinking, “You can’t just move Hooks to a constructor. They **need** to run on every render to grab the latest value” at this point, then you’re totally correct!

We can’t just move Hooks out of the render function because we will break them. That’s why we’ll have to replace them with something else. But first, the second major problem of Hooks.

## Hooks Problem #2: Assumed State Changes

We know that any time a component’s state changes, React will re-render that component. This becomes problematic when our components become bloated with lots of state and logic. Say we have a component that has two unrelated pieces of state: A and B. If we update state A, our component re-renders due to the state change. Even though B has not changed, any logic that depends on it will re-run unless we wrap that logic with `useMemo`/`useCallback`.

This is wasteful because React essentially says “OK, recompute all these values in the render function” and then it walks back that decision and bails out on bits and pieces whenever it encounters `useMemo` or `useCallback`. However, it would make more sense if React would only run exactly what it needed to run.

## Reactive Programming

Reactive programming has been around for a long time but has recently become a popular programming paradigm among UI frameworks.

The core idea of reactive programming is that variables are observable, and whenever an observable’s value changes, observers will be notified of this change via a callback function:

```JavaScript
const count$ = observable(5)

observe(count$, (count) => {
  console.log(count)
})

count$.set(6)
count$.set(7)

// Output:
// 6
// 7
```

Note how the callback function passed to `observe` executes any time that we change the `count$` observable's value. You might be wondering about the `$` on the end of `count$`. This is known as [Finnish Notation](https://medium.com/@benlesh/observables-and-finnish-notation-df8356ed1c9b) and simply indicates that the variable holds an observable.

In reactive programming, there is also a concept of computed/derived observables that can both observe and be observed. Below is an example of a derived observable that tracks the value of another observable and applies a `transform` to it:

```JavaScript
const count$ = observable(5)
const doubledCount$ = derived(count$, (count) => count * 2)

observe(doubledCount$, (doubledCount) => {
  console.log(doubledCount)
})

count$.set(6)
count$.set(7)

// Output:
// 12
// 14
```

This is similar to our previous example, except now we will log a doubled count.

## Improving React With Reactivity

With the basics of reactive programming covered, let’s look at an example in React and improve upon it by making it more reactive.

Consider an app with two counters and a piece of derived state that depends on one of the counters:

```JSX
const App = () => {
  const [countOne, setCountOne] = useState(0);
  const [countTwo, setCountTwo] = useState(0);

  const countTwoDoubled = useMemo(() => {
    return countTwo * 2;
  }, [countTwo]);

  return (
    <div>
      <button
        onClick={() => {
          setCountOne((prev) => prev + 1);
        }}
      >
        Increment Count One: {countOne}
      </button>
      <button
        onClick={() => {
          setCountTwo((prev) => prev + 1);
        }}
      >
        Increment Count Two: {countTwo}
      </button>
      <p>Count Two Doubled: {countTwoDoubled}</p>
    </div>
  );
};
```

Here, we have logic to double the value of `countTwo` on each render, but if `useMemo` finds that `countTwo` holds the same value that it did on the previous render, then the doubled value will not be re-derived on that render.

Combining our earlier ideas, we can pull state responsibilities out of React and instead set up our state as a graph of observables in a constructor function. The observables will notify the component whenever an observable changes so that it knows to re-render:

```JSX
const App = createComponent(({ setState }) => {
  // This is a constructor layer that only runs once.
  // Create observables to hold our counter state.
  const countOne$ = observable(0);
  const countTwo$ = observable(0);
  const countTwoDoubled$ = derived(countTwo$, (countTwo) => {
    return countTwo * 2;
  });

  observe(
    [countOne$, countTwo$, countTwoDoubled$],
    (countOne, countTwo, countTwoDoubled) => {
      setState({
        countOne,
        countTwo,
        countTwoDoubled
      });
    }
  );

  // The constructor returns the render function.
  return (props, state) => (
    <div>
      <button
        onClick={() => {
          countOne$.set((prev) => prev + 1);
        }}
      >
        Increment Count One: {state.countOne}
      </button>
      <button
        onClick={() => {
          countTwo$.set((prev) => prev + 1);
        }}
      >
        Increment Count Two: {state.countTwo}
      </button>
      <p>Count Two Doubled: {state.countTwoDoubled}</p>
    </div>
  );
});
```

In the example above, the observables we create in the constructor are available in the render function via closure, which allows us to set their values in response to click events. `doubledCountTwo$` observes `countTwo$` and doubles its value **only** when the value of `countTwo$` changes. Notice how we don't derive the doubled count during the render but prior to it. Lastly, we use the `observe` function to re-render our component any time that any of the observables change.

This is an elegant solution for several reasons:

1. State and effects are no longer the responsibility of React but rather that of a dedicated state management library that can be used across frameworks or even without a framework.
2. Our observables are initialized only on construction, so we don’t have to worry about violating the rules of Hooks or re-running Hook logic unnecessarily during renders.
3. We avoid re-running derivational logic at unnecessary times by choosing to re-derive values only when their dependencies change.

With a little hacking on the React API, we can make the code above a reality.

[**Try our demo in this sandbox!**](https://codesandbox.io/s/alternate-react-api-kyutz)

This is actually quite similar to the way Vue 3 works with its composition API. Though the naming is different, look how strikingly similar this Vue snippet is:

```JavaScript
// Example taken from https://composition-api.vuejs.org/#usage-in-components
import { reactive, computed, watchEffect } from 'vue'

function setup() {
  const state = reactive({
    count: 0,
    double: computed(() => state.count * 2)
  })

  function increment() {
    state.count++
  }

  return {
    state,
    increment
  }
}

const renderContext = setup()

watchEffect(() => {
  renderTemplate(
    `<button @click="increment">
      Count is: {{ state.count }}, double is: {{ state.double }}
    </button>`,
    renderContext
  )
})
```

If this isn’t convincing enough, look how simple `refs` become when we introduce a constructor layer to React function components:

```JSX
const App = createComponent(() => {  
  // We can achieve ref functionality via closures
  let divEl = null;
  
  return (props, state) => (
    <div ref={(el) => divEl = el}>
      {/*...*/}
    </div>
  );
});
```

We actually eliminate the need for `useRef` because we can declare variables in the constructor and then read/write them from anywhere through the lifetime of the component.

Perhaps cooler yet, we could easily make `refs` observable:

```JSX
const App = createComponent(() => {  
  const divEl$ = observable(null);
  
  // Do something any time our "ref" changes
  observe(divEl$, (divEl) => {
    console.log(divEl)
  });
  
  return (props, state) => (
    <div ref={divEl$.set}>
      {/*...*/}
    </div>
  );
});
```

Of course, my implementations of `observable`, `derived`, and `observe` here are buggy and do not form a complete state management solution. Not to mention these contrived examples leave out several considerations, but no worries: I have put a lot of thought into this matter, and my thoughts have culminated in a new reactive state management library called [Elementos](https://malerba118.github.io/elementos-docs/)!

![Photo by the author.](https://cdn-images-1.medium.com/max/5020/1*k1YTEm4t8HpWLaUcM7yfmg.png)

Elementos is a framework-agnostic, reactive state management library with an emphasis on state composability and encapsulation. If you’ve enjoyed this article, I’d highly encourage you to check it out!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
