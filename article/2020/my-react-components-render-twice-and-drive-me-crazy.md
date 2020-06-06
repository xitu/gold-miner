> * 原文地址：[My React components render twice and drive me crazy](https://mariosfakiolas.com/blog/my-react-components-render-twice-and-drive-me-crazy/)
> * 原文作者：[Marios Fakiolas](https://mariosfakiolas.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/my-react-components-render-twice-and-drive-me-crazy.md](https://github.com/xitu/gold-miner/blob/master/article/2020/my-react-components-render-twice-and-drive-me-crazy.md)
> * 译者：
> * 校对者：

# My React components render twice and drive me crazy

Many frontend developers who use modern React, have been pulling their hair out from time to time trying to figure out why their components render twice during development.

Others have noticed this behaviour, but they believe this is how `React` works under the hood while some have opened even tickets in the `React` official repository, reporting this as a bug.

So there is definitely some confusion in the community about this 😬

The reason why all these happen is `React.StrictMode`.

Let's dive into some real examples in order to replicate this and then investigate why this is happening in the first place.

## Example with a function component

We can start by running a brand new `CRA` installation:

```bash
npx create-react-app my-app && cd my-app

```

We tweak `App.js` a bit by adding a dead-simple `console.log` statement:

```jsx
function App() {
  console.log('I render 😁');

  return (
    <div className="App">
      <header className="App-header">
        <img src={logo} className="App-logo" alt="logo" />
      </header>
    </div>
  );
}
```

Now we can launch our application with `yarn start` and open `http://localhost:3000` in the browser:

![My React components render twice and drive me crazy](https://d33wubrfki0l68.cloudfront.net/78209eaf74cbe91d5550a535981e6f4aa460985c/410d0/uploads/my-react-components-render-twice-and-drive-me-crazy-1.gif)

Hmmm, the `I render 😁` statement got printed just once, so we cannot reproduce double-rendering with a dead simple function component.

## Example with a function component with state

What will happen though when we use a React hook and add some state management to our function component?

```jsx
function App() {
  const [clicks, setClicks] = React.useState(0);

  console.log('I render 😁');

  return (
    <div className="App">
      <header className="App-header">
        <img src={logo} className="App-logo" alt="logo" />

        <button onClick={() => setClicks(clicks => clicks + 1)}>
            Clicks: {clicks}
        </button>
      </header>
    </div>
  );
}

```

Let's check the browser once again:

![My React components render twice and drive me crazy](https://d33wubrfki0l68.cloudfront.net/2db0d90efee738447ab91895cbf7d210d5bcc160/c47b8/uploads/my-react-components-render-twice-and-drive-me-crazy-2.gif)

Here we are!! So it rendered twice at first and then it kept rendering twice every time we clicked that button we added.

Obviously, `React.useState` affected our component's behaviour regarding re-renderings.

## Example with a function component with state in production

What about the production bundle? In order to check this, we need to build our application first, and then we can serve it with a package like `serve` in port 3000:

```bash
yarn build && npx serve build -l 3000

```

Open `http://localhost:3000` in the browser one more time:

![My React components render twice and drive me crazy](https://d33wubrfki0l68.cloudfront.net/5984fc8b95768e6bb1b073880dedfe04c148563c/ee899/uploads/my-react-components-render-twice-and-drive-me-crazy-3.gif)

Phew!!! The debugging statement got printed once at the beginning and once again every time we clicked the button.

The double-rendering behaviour is definitely not reproducible in production as we see despite the fact that we had exactly the same setup by using `React.useState`.

## Why this is happening?

As mentioned above the reason why is `React.StrictMode`. If we check the file `src/index.js` in the application we launched before with `CRA`, we 'll see that our `<App />` component is wrapped with it:

```jsx
ReactDOM.render(
  <React.StrictMode>
    <App />
  </React.StrictMode>,
  document.getElementById('root')
);

```

Obviously that re-rendering thing is definitely not a bug, or something related with the library's render mechanism. On the contrary it is a debugging mechanism provided by `React` 🤗

## [#](/blog/my-react-components-render-twice-and-drive-me-crazy#what-is-reactstrictmode) What is React.StrictMode?

`React.StrictMode` is a wrapper introduced in version [16.3.0](https://github.com/facebook/react/releases/tag/v16.3.0) back in 2018. At first, it was applied only for class components and after [16.8.0](https://github.com/facebook/react/releases/tag/v16.8.0) it is applied also for hooks.

As mentioned in the release notes:

> React.StrictMode is a wrapper to help prepare apps for async rendering

So it is meant to help engineers to avoid common pitfalls and upgrade their `React` applications progressively by dropping legacy APIs.

These hints are extremely helpful for better debugging, since the library is moving towards to the async rendering era so big changes take place from time to time.

How useful, right?

## Why the double rendering then?

One of the benefits that we get from `React.StrictMode` usage, is that it helps us to detect unexpected side effects in the render-phase lifecycles.

These lifecycles are:

* `constructor`
* `componentWillMount` (or UNSAFE_componentWillMount)
* `componentWillReceiveProps` (or UNSAFE_componentWillReceiveProps)
* `componentWillUpdate` (or UNSAFE_componentWillUpdate)
* `getDerivedStateFromProps`
* `shouldComponentUpdate`
* `render`
* `setState` updater functions (the first argument)

All these methods are called more than once, so it is important to avoid having side-effects in them. If we ignore this principle it is likely to end up with inconsistent state issues and memory leaks.

`React.StrictMode` cannot spot side-effects at once, but it can help us find them by intentionally invoking twice some key functions.

These functions are:

* Class component `constructor`, `render`, and `shouldComponentUpdate` methods
* Class component static `getDerivedStateFromProps` method
* Function component bodies
* State updater functions (the first argument to `setState`)
* Functions passed to `useState`, `useMemo`, or `useReducer`

This behaviour definitely has some performance impact, but we should not worry since it takes place only in development and not in production.

That is why we managed to reproduce double-rendering only in development for a function component that was using `React.useState`. Cheers!!

You can read the [official documentation](https://reactjs.org/docs/strict-mode.html) if you need to go deeper regarding React.StrictMode

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
