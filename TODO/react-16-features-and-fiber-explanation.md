
> * 原文地址：[What’s New in React 16 and Fiber Explanation](https://edgecoders.com/react-16-features-and-fiber-explanation-e779544bb1b7)
> * 原文作者：[Trey Huffine](https://edgecoders.com/@treyhuffine?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/react-16-features-and-fiber-explanation.md](https://github.com/xitu/gold-miner/blob/master/TODO/react-16-features-and-fiber-explanation.md)
> * 译者：
> * 校对者：

# What’s New in React 16 and Fiber Explanation

## An overview of the features and updates for the highly anticipated release for React.

![](https://cdn-images-1.medium.com/max/2100/1*i3hzpSEiEEMTuWIYviYweQ.png)

The update to the React core algorithm has been years in the making — it offers a ground-up rewrite for how React manages reconciliation. React will maintain the same public API and should allow for immediate upgrade for most projects (assuming you’ve fixed the deprecation warnings). The main goals of the release are the following:

* Ability to split interruptible work in chunks.

* Ability to prioritize, rebase and reuse work in progress.

* Ability to yield back and forth between parents and children to support layout in React.

* Ability to return multiple elements from `render()`.

* Better support for error boundaries.

* [**Follow me on gitconnected >](https://gitconnected.com/treyhuffine)**

## Features

### Core Algorithm Rewrite

The primary feature of the rewrite is async rendering. (**Note**: this is not available in the 16.o release but will be an opt-in feature in a future 16.x release). In addition, it removes old internal abstractions that didn’t age well and hindered internal changes.

> Much of this was derived from [Lin Clark’s presentation](https://www.youtube.com/watch?v=ZCuYPiUIONs), so please check that out and [show her some love](https://twitter.com/linclark) for such an incredible overview.

What async rendering means is that the rendering work can be split into chunks and spread out over multiple frames. The rendering engine for the browser is single threaded, which means nearly all actions happen synchronously. React 16 manages the main thread and rendering using native browser APIs by intermittently checking to see if there is other work that needs to be performed. An example of the main thread of the browser in Firefox is simply:

```
while (!mExiting) {
    NS_ProcessNextEvent(thread);
}
```

Previously, React would block the entire thread as it calculated the tree. This process for reconciliation is now named “stack reconciliation”. While React is known to be very fast, blocking the main thread could still cause some applications to not feel fluid. Version 16 aims to fix this problem by not requiring the render process to complete once it’s initiated. React computes part of the tree and then will pause rendering to check if the main thread has any paints or updates that need to be performed. Once the paints and updates have been completed, React begins rendering again. This process is accomplished by introducing a new data structure called a “fiber” that maps to a React instance and manages the work for the instance as well as know its relationship to other fibers. A fiber is just a JavaScript object. These images depict the old versus new rendering methods.

![Stack reconciliation — updates must be completed entirely before returning to main thread (credit Lin Clark)](https://cdn-images-1.medium.com/max/3304/1*QtyRyjiedObq7_khCw5GlA.png)

![Fiber reconciliation — updates will be batched in chunks and React will manage the main thread (credit Lin Clark)](https://cdn-images-1.medium.com/max/2000/1*LEPjfYL6Bd4nkcCRMB6vog.png)

React 16 will also prioritize updates by importance. This allows high priority updates to jump to the front of the line and be processed first. An example of this would be something like a key input. This is high priority because the user needs that immediate feedback to feel fluid as opposed to a low priority update like an API response which can wait an extra 100–200 milliseconds.

![React priorities (credit Lin Clark)](https://cdn-images-1.medium.com/max/3428/1*RZYe9LuwfybI9zDxCL28NQ.png)

By breaking the UI updates into smaller units of work, a better overall user experience is achieved. Pausing reconciliation work to allow the main thread to execute other necessary tasks provides a smoother interface and better perceived performance.

### Error Handling

Errors in React have been a little bit of mess to work with, but this is changing in version 16. Previously, errors inside components would corrupt React’s state and provide cryptic errors on subsequent renders.

![lol wut?](https://cdn-images-1.medium.com/max/2000/1*BLyT8jKqOPRAKt_iUXCNeg.png)

React 16 includes error boundaries will not only provide much clearer error messaging, but also prevent the entire application from breaking. After being added to your app, error boundaries catch errors and gracefully display a fallback UI without the entire component tree crashing. The boundaries can catch errors during rendering, in lifecycle methods, and in constructors of the whole tree below them. Error boundaries are simply implemented through the new lifecycle method componentDidCatch(error, info).

```
class ErrorBoundary extends React.Component {
  constructor(props) {
    super(props);
    this.state = { hasError: false };
  }

  componentDidCatch(error, info) {
    // Display fallback UI
    this.setState({ hasError: true });
    // You can also log the error to an error reporting service
    logErrorToMyService(error, info);
  }

  render() {
    if (this.state.hasError) {
      // You can render any custom fallback UI
      return <h1>Something went wrong.</h1>;
    }
    return this.props.children;
  }
}

<ErrorBoundary>
  <MyWidget />
</ErrorBoundary>
```

Here, any error that happens in `<MyWidget/>` or its children will be captured by the `<ErrorBoundary>` component. This functionality behaves like a `catch {}` block in JavaScript. If the error boundary receives an error state, you as a developer are able to define what is displayed in the UI. Note that the error boundary will only catch errors in the tree below it, but it will not recognize errors in itself.

Moving forward, you’ll see robust and actionable errors like this:

![omg that’s nice (credit Facebook)](https://cdn-images-1.medium.com/max/3202/1*Icy2gSlrGAifYrI-cNddIg.png)

## Compatibility

### Async Rendering

The focus of the initial 16.0 release is on compatibility for existing applications. Async rendering will not be an option initially, but in later 16.x releases, it will be included as an opt-in feature.

### Browser Compatibility

React 16 is dependent on `Map` and `Set`. To ensure compatibility with all browsers, you must include a polyfill. Popular options are [core-js](https://github.com/zloirock/core-js) or [babel-polyfill](https://babeljs.io/docs/usage/polyfill/).

In addition, it will also depend on `requestAnimationFrame`, including for tests. A simple shim for test purposes would be:

```
global.requestAnimationFrame = function(callback) {
  setTimeout(callback);
};
```

### Component Lifecycle

Since React prioritizes the rendering, you are no longer guaranteed `componentWillUpdate` and `shouldComponentUpdate` of different components will fire in a predictable order. The React team is working to provide an upgrade path for apps that would break from this behavior.

### Usage

Currently React 16 is in beta, but it will be released soon. You can start using version 16 now by doing the following:

```
# yarn
yarn add react@next react-dom@next

# npm
npm install --save react@next react-dom@next
```

*If you found this article helpful, please tap the *👏*. [Follow me](https://medium.com/@treyhuffine) for more articles on React, Node.js, JavaScript, and open source software! You can also find me on [Twitter](https://twitter.com/twitter) or [gitconnected](https://gitconnected.com/treyhuffine).*
[**gitconnected - The community for developers and software engineers**
*Create an account or log in to gitconnected, the largest network connecting people like you. Follow the latest open…*gitconnected.com](https://gitconnected.com/treyhuffine)


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
