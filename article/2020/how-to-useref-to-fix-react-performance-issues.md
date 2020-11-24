> * 原文地址：[How to useRef to Fix React Performance Issues](https://medium.com/better-programming/how-to-useref-to-fix-react-performance-issues-4d92a8120c09)
> * 原文作者：[Sidney Alcantara](https://medium.com/@notsidney)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/how-to-useref-to-fix-react-performance-issues.md](https://github.com/xitu/gold-miner/blob/master/article/2020/how-to-useref-to-fix-react-performance-issues.md)
> * 译者：
> * 校对者：

# How to useRef to Fix React Performance Issues

#### And how we stopped our React context from re-rendering everything

![Photo by the author.](https://cdn-images-1.medium.com/max/3208/1*ychn1nsfNdNxt4fRIz2qkw@2x.png)

Refs are a seldom-used feature in React. If you’ve read the [official React guide](https://reactjs.org/docs/refs-and-the-dom.html), they’re introduced as an “escape hatch” out of the typical React data flow with a warning to use them sparingly. They’re primarily billed as the correct way to access a component’s underlying DOM element.

But alongside the concept of Hooks, the React team introduced the `[useRef](https://reactjs.org/docs/hooks-reference.html#useref)` Hook, which extends this functionality:

> # “`useRef()` is useful for more than the `ref` attribute. It’s [handy for keeping any mutable value around](https://reactjs.org/docs/hooks-faq.html#is-there-something-like-instance-variables) similar to how you’d use instance fields in classes.” — [React’s documentation](https://reactjs.org/docs/hooks-reference.html)

While I overlooked this point when the new Hook APIs launched, it proved to be surprisingly useful.

👉 [Click here to skip to the solution and code snippets](#f356).

---

## The Problem

I’m a software engineer working on [Firetable](https://firetable.io/?utm_source=Medium&utm_medium=blog&utm_campaign=How%20to%20useRef%20to%20Fix%20React%20Performance%20Issues&utm_content=MediumArticle), an open-source React app that combines a spreadsheet UI with the full power of Firestore and Firebase. One of its key features is the side drawer, a form-like UI to edit a single row that slides over the main table.

![](https://cdn-images-1.medium.com/max/2560/1*1h6w52_v9rflIGJ9WlDPGw.gif)

When the user clicks on a cell in the table, the side drawer can be opened to edit that cell’s corresponding row. In other words, what we render in the side drawer is dependent on the currently selected row — this should be stored in state.

The most logical place to put this state is within the side drawer component itself because when the user selects a different cell, it should **only** affect the side drawer. However:

* We need to **set** this state from the table component. We’re using `[react-data-grid](https://github.com/adazzle/react-data-grid)` to render the table itself, and it accepts a callback prop that’s called whenever the user selects a cell. Currently, it’s the only way to respond to that event.
* But the side drawer and table components are siblings, so they can’t directly access each other’s state.

React’s recommendation is to [lift this state](https://reactjs.org/docs/lifting-state-up.html) to the components’ closest common ancestor (in this case, `TablePage`). But we decided against moving the state here because:

1. `TablePage` didn’t contain any state and was primarily a container for the table and side drawer components, neither of which received any props. We preferred to keep it this way.
2. We were already sharing a lot of “global” data via a [context](https://reactjs.org/docs/context.html) located close to the root of the component tree, and we felt it made sense to add this state to that central data store.

**Note: Even if we put the state in `TablePage`, we would have run into the same problem below anyway.**

The problem was whenever the user selected a cell or opened the side drawer, the update to this global context would cause the entire app to re-render. This included the main table component, which could have dozens of cells displayed at a time, each with its own editor component. This would result in a render time of around 650 ms, which is long enough to see a visible delay in the side drawer’s open animation.

![Notice the delay between clicking the open button and when the side drawer animates to open.](https://cdn-images-1.medium.com/max/2560/1*DPrtPDYRTq3IBR9_Hsh6dQ.gif)

The reason behind this is a key feature of context — the very reason why it’s better to use in React as opposed to global JavaScript variables:

> # “All consumers that are descendants of a Provider will re-render whenever the Provider’s `value` prop changes.” — [React’s documentation](https://reactjs.org/docs/context.html)

While this Hook into React’s state and lifecycle had served us well so far, it seems we had now shot ourselves in the foot.

---

## The Aha Moment

We first explored a few different solutions (from [Dan Abramov’s post](https://github.com/facebook/react/issues/15156#issuecomment-474590693) on the issue) before settling on `useRef`:

1. Split the context (i.e. create a new `SideDrawerContext`) — The table would still need to consume the new context, which still updates when the side drawer opens, [causing the table to re-render](https://reactjs.org/docs/hooks-reference.html#usecontext) unnecessarily.
2. Wrap the table component in `React.memo` or `useMemo` — The table would still need to call `useContext` to access the side drawer’s state and [neither API prevents it from causing re-renders](https://reactjs.org/docs/react-api.html#reactmemo).
3. Memoize the `react-data-grid` component used to render the table — This would have introduced more verbosity to our code. We also found it prevented **necessary** re-renders, requiring us to spend more time fixing or restructuring our code entirely just to implement the side drawer.

While reading through the Hook APIs and `useMemo` a few more times, I finally came across that point about `useRef`:

> # “`useRef()` is useful for more than the `ref` attribute. It’s [handy for keeping any mutable value around](https://reactjs.org/docs/hooks-faq.html#is-there-something-like-instance-variables) similar to how you’d use instance fields in classes.” — [React’s documentation](https://reactjs.org/docs/hooks-reference.html)

And more importantly:

> # “`useRef` **doesn’t** notify you when its content changes. Mutating the `.current` property **doesn’t cause a re-render**.” — [React’s documentation](https://reactjs.org/docs/hooks-reference.html)

And that’s when it hit me: We didn’t need to store the side drawer’s state. We only needed a reference to the function that sets that state.

---

## The Solution

1. Keep the open and cell states in the side drawer.
2. Create a ref to those states and store it in the context.
3. Call the set state functions (inside the side drawer) using the ref from the table when the user clicks on a cell.

![](https://cdn-images-1.medium.com/max/2944/1*ywF1zWB-Z9RextkazZKKpw@2x.png)

The code below is an abbreviated version of the code used on Firetable and includes the TypeScript types for the ref:

```TSX
import { SideDrawerRef } from 'SideDrawer'

export function FiretableContextProvider({ children }) {
  const sideDrawerRef = useRef<SideDrawerRef>();

  return (
    <FiretableContext.Provider value={{ sideDrawerRef }}>
      {children}
    </FiretableContext.Provider>
  )
}
```

**Note: Since function components run the entire function body on re-render, whenever the `cell` or `open` state updates (and causes a re-render), `sideDrawerRef` always has the latest value in `.current`.**

This solution proved to be the best since:

1. The current cell and open states are stored inside the side drawer component itself — the most logical place to put it.
2. The table component has access to its sibling’s state **when** it needs it.
3. When either the current cell or open states are updated, it only triggers a re-render for the side drawer component and not any other component throughout the app.

You can see how this is used in Firetable [on GitHub](https://github.com/AntlerVC/firetable/blob/master/www/src/components/SideDrawer/index.tsx#L37).

---

## When to useRef

This doesn’t mean you should go ahead and use this pattern for everything you build, though. It’s best used when you need to access or update another component’s state at specific times, but your component doesn’t depend or render based on that state. React’s core concepts of lifting state up and one-way data flow are enough to cover most app architectures anyway.

Thanks for reading!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
