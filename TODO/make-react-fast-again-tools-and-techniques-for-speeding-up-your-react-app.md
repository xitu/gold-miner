
> * 原文地址：[High Performance React: 3 New Tools to Speed Up Your Apps](https://medium.freecodecamp.org/make-react-fast-again-tools-and-techniques-for-speeding-up-your-react-app-7ad39d3c1b82)
> * 原文作者：[Ben Edelstein](https://medium.freecodecamp.org/@edelstein)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/make-react-fast-again-tools-and-techniques-for-speeding-up-your-react-app.md](https://github.com/xitu/gold-miner/blob/master/TODO/make-react-fast-again-tools-and-techniques-for-speeding-up-your-react-app.md)
> * 译者：
> * 校对者：

# High Performance React: 3 New Tools to Speed Up Your Apps

![](https://cdn-images-1.medium.com/max/2000/1*mJFYp7LKVzZM3PPjFb0QXQ.png)

React is usually pretty fast, but it’s easy to make small mistakes that lead to performance issues. Slow component mounts, deep component trees, and unnecessary render cycles can quickly add up to an app that feels slow.

Luckily there are lots of tools, some even built in to React, that help with diagnosing performance issues. In this post I’ll highlight tools and techniques for making React apps fast. Each section also has an interactive, and (hopefully) fun demo!

### Tool #1: The Performance Timeline

React 15.4.0 introduced a new performance timeline feature that lets you see exactly when components get mounted, updated, and unmounted. It also lets you visualize component lifecycles in relation to each other.

**Note:** For now, this feature only works in Chrome, Edge, and IE, since it leverages the User Timing API which has yet to be implemented in all browsers.

#### How it works

1. Open your app and append the query param: `react_perf`. For example, `[http://localhost:3000?react_perf](http://localhost:3000?react_perf)`
2. Open the Chrome DevTools **Performance** tab and press **Record**.
3. Perform the actions that you want to analyze.
4. Stop recording.
5. Inspect the visualization under **User Timing.**

![](https://cdn-images-1.medium.com/max/1000/1*cOO5vUnbkdDUcqMW8ebJqA.png)

#### Understanding the output

Each colored bar shows time that a component is doing “work”. Since JavaScript is single-threaded, whenever a component is mounting or rendering, it’s hogging the main thread and preventing other code from running.

The text in brackets like `[update]` describes which part of the component lifecycle is taking place. The timeline breaks down each step, so you can see fine-grained timings on methods like `[componentDidMount]``[componentWillReceiveProps]``[ctor]` (constructor) and `[render].`

Bars that are stacked represent component trees. While it is typical to have fairly deep component trees in React, if you are optimizing a component that is mounted frequently, it can help to reduce the number of wrapper components since each adds a small performance and memory penalty.

One caveat here is that the timing numbers in the timeline are for the development build of React, which is much slower than prod. In fact, the performance timeline itself even slows down your app. While these numbers shouldn’t be considered representative of real-world performance, the *relative *timings between different components are accurate. Also, whether or not a component updates at all is not dependent on a prod build.

#### Demo #1

For fun, I rigged the TodoMVC app to have some *serious *performance problems. You can [try it out here](https://perf-demo.firebaseapp.com/?react_perf).

To see the timeline, open the Chrome dev tools, go to the “Performance” tab, and click Record. Then add some TODOs in the app, stop the recording, and inspect the timeline. See if you can spot which components are causing the performance problems :)

### Tool #2: why-did-you-update

One of the most common issues that affects performance in React is unnecessary render cycles. By default, React components will re-render whenever their parent renders, even if their props didn’t change.

For example, if I have a simple component like this:

    class DumbComponent extends Component {
      render() {
        return <div> {this.props.value} </div>;
      }
    }

With a parent component like this:

    class Parent extends Component {
      render() {
        return <div>
          <DumbComponent value={3} />
        </div>;
      }
    }

Whenever the parent component renders, `DumbComponent` will re-render, despite its props not changing.

Generally, if `render` runs, and there were no changes to the virtual DOM, it is a wasted render cycle since the `render` method should be pure and not have any side effects. In a large-scale React app, it can be tricky to detect places where this happens, but luckily, there’s a tool that can help!

#### Using why-did-you-update

![](https://cdn-images-1.medium.com/max/1000/1*Lb4nr_WLwnLt63jUoszrnQ.png)

`why-did-you-update` is a library that hooks into React and detects potentially unnecessary component renders. It detects when a component’s `render` method is called despite its props not having changed.

#### Setup

1. Install with npm: `npm i --save-dev why-did-you-update`
2. Add this snippet anywhere in your app:

    import React from 'react'

    if (process.env.NODE_ENV !== 'production') {
      const {whyDidYouUpdate} = require('why-did-you-update')
      whyDidYouUpdate(React)
    }

**Note** that this tool is great in local development but make sure it’s disabled in production since it will slow down your app.

#### Understanding the output

`why-did-you-update` monitors your app as it runs and logs components that may have changed unnecessarily. It lets you see the props before and after a render cycle it determined may have been unnecessary.

#### Demo #2

To demonstrate `why-did-you-update`, I installed the library in the TodoMVC app on Code Sandbox, an online React playground. Open the browser console and add some TODOs to see the output.

[Here’s the demo](https://codesandbox.io/s/xGJP4QExn).

Notice that a few components in the app are rendering unnecessarily. Try implementing the techniques described above to prevent unnecessary renders. If done correctly, there should be no output from `why-did-you-update` in the console.

### Tool #3: React Developer Tools

![](https://cdn-images-1.medium.com/max/1000/1*1Ih6h8djFyH13tfFK3D1sw.png)

The React Developer Tools Chrome extension has a built-in feature for visualizing component updates. This is helpful for detecting unnecessary render cycles. To use it, first make sure to [install the extension here](https://codesandbox.io/s/xGJP4QExn).

Then, open the extension by clicking the “React” tab in the Chrome DevTools and check “Highlight Updates”.

![](https://cdn-images-1.medium.com/max/800/1*GP4vXvW3WO0vTbggDfus4Q.png)

Then, simply use your app. Interact with various components and watch the DevTools work its magic.

#### Understanding the output

The React Developer Tools highlights components that are re-rendering at a given point in time. Depending on the frequency of updates, a different color is used. Blue shows infrequent updates, ranging to green, yellow, and red for components that update frequently.

Seeing yellow or red isn’t *necessarily* a bad thing. It would be expected when adjusting a slider, or other UI element that triggers frequent updates. But if you click a simple button and see red- it may mean that something is awry. The purpose of the tool is to spot components that are updating *unnecessarily*. As the app developer, you should have a general idea which components should be updating at a given time.

#### Demo #3

To demonstrate the component highlighting, I rigged the TodoMVC app to update some components unnecessarily.

[Here’s the demo](https://highlight-demo.firebaseapp.com/).

Open the link above, and then open the React Developer Tools and enable update highlighting. When you type in the top text input, you’ll see all of the TODOs highlight unnecessarily. As you type faster, you’ll see the color change to indicate more frequent updates.

### Fixing unnecessary renders

Once you’ve identified components in your app that are re-rendering unnecessarily, there are a few easy fixes.

#### Use PureComponent

In the above example, `DumbComponent` is a pure function of its props. That is, the component only needs to re-render when its props change. React has a special type of component built-in called `PureComponent` that is meant for exactly this use case.

Instead of inheriting from React.Component, use React.PureComponent like this:

    class DumbComponent extends PureComponent {
      render() {
        return <div> {this.props.value} </div>;
      }
    }

Then, the component will only re-render when its props actually change. That’s it!

Note that `PureComponent` does a shallow comparison of props, so if you use complex data structures, it may miss some prop changes and not update your components.

#### Implement shouldComponentUpdate

`shouldComponentUpdate` is a component method called before `render` when either `props` or `state` has changed. If `shouldComponentUpdate` returns true, `render` will be called, if it returns false, nothing happens.

By implementing this method, you can instruct React to avoid re-rendering a given component if its props don’t change.

For example, we could implement `shouldComponentUpdate` in our dumb component from above like this:

    class DumbComponent extends Component {
      shouldComponentUpdate(nextProps) {
        if (this.props.value !== nextProps.value) {
          return true;
        } else {
          return false;
        }
      }

    render() {
        return <div>foo</div>;
      }
    }

### Debugging Performance Issues in Production

The React Developer Tools only work if you are running your app on your own machine. If you’re interested in understanding performance issues that users see in production, try [LogRocket](https://logrocket.com).

![](https://cdn-images-1.medium.com/max/1000/1*s_rMyo6NbrAsP-XtvBaXFg.png)

[LogRocket](https://logrocket.com) is like a DVR for web apps, recording *literally**everything* that happens on your site. Instead of guessing why problems happen, you can replay sessions with bugs or performance issues to quickly understand the root cause.

LogRocket instruments your app to record performance data, Redux actions/state, logs, errors, network requests/responses with headers + bodies, and browser metadata. It also records the HTML and CSS on the page, recreating pixel-perfect videos of even the most complex single-page apps.

[**LogRocket | Logging and Session Replay for JavaScript Apps**
*LogRocket helps you understand problems affecting your users, so that you can get back to building great software.*logrocket.com](https://logrocket.com/)

---

Thanks for reading. I hope these tools and techniques help in your next React project!


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
