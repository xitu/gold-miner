> * 原文地址：[Top React and Redux Packages for Faster Development](https://codeburst.io/top-react-and-redux-packages-for-faster-development-5fa0ace42fe7)
> * 原文作者：[Arfat Salman](https://codeburst.io/@arfatsalman)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/top-react-and-redux-packages-for-faster-development.md](https://github.com/xitu/gold-miner/blob/master/TODO1/top-react-and-redux-packages-for-faster-development.md)
> * 译者：
> * 校对者：

# Top React and Redux Packages for Faster Development

![](https://cdn-images-1.medium.com/max/2000/1*mOfFxGkE0FP-eQ30xoYxlQ.jpeg)

Photo by [Fleur Treurniet](https://unsplash.com/photos/dQf7RZhMOJU?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) on [Unsplash](https://unsplash.com/search/photos/tools?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText).

React has grown in popularity over the last few years. With that, a lot of tools have emerged that make developer’s life easy and development fun. They are going to help us in achieving the extra productivity that we want. After all, we always want our development tools to

![](https://cdn-images-1.medium.com/max/800/1*lUkZYUKtkykpHNIOz3c0gg.gif)

Via [Giphy](https://gph.is/1VO6H7f)

If you are a beginner in React, you may find some of the packages helpful in debugging or visualising various abstract parts of your app.

Let’s begin!

### React Storybook

While creating applications in React, you must have had this thought at least once: _What if I could see a rendition of the component that I am using(or making) and see how it behaves under different combinations of props, states, and actions._ Well, there is a package for this. It’s called Storybook.

React storybook is a visual development environment for React. **It allows you to browse a component library, view the different states of each component, and interactively develop and test components.** It allows you to quickly prototype components and see changes on every state and prop changes. Here’s a link to their GitHub’s [repo](https://github.com/storybooks/storybook).

You should definitely check out their [examples](https://storybook.js.org/examples/) page.

![](https://cdn-images-1.medium.com/max/800/1*TxuoKupMwNqsEKyrCdB9cQ.gif)

Demo from [storybook’s](https://github.com/storybooks/storybook) repo.

**Some highlights are —**

*   Storybook runs outside of your app.
*   This allows the components to be developed in isolation from the app development.
*   It also means that you do not have to worry about various dependencies while creating the components.

Other similar packages are: [React Cosmos](https://github.com/react-cosmos/react-cosmos), [React Styleguidist](https://github.com/styleguidist/react-styleguidist)

### React Dev Tools

This is the most famous React development package. **It lets you inspect the React component elements and their hierarchy like HTML elements, including component props and state.** Also, you can search for a particular components using regular expressions, and see how it affects the rendering of other components using a nifty feature called ‘**Highlight Updates**’.

![](https://cdn-images-1.medium.com/max/800/1*9XrmfPqh_naIBlTi7dv3Hw.gif)

React DevTools demo.

It is available as an [extension](https://chrome.google.com/webstore/detail/react-developer-tools/fmkadmapgofadopljbjfkapdkoienihi) of Google Chrome, and as an [add-on](https://addons.mozilla.org/firefox/addon/react-devtools/) for Firefox. It is available as an standalone [app](https://github.com/facebook/react-devtools/tree/master/packages/react-devtools) too. Installing it is as simple as downloading the extension(or addon). Once installed, there should be a new tab called ‘React’ in Developers Tools(in Chrome).

![](https://cdn-images-1.medium.com/max/800/1*3qBkNUef0uvzZvI_U8ZhLA.gif)

Highlight Updates of React Dev Tools.

**Tips —**

*   **Highlight Updates:** Focus on the colourful lines that are appearing at the bottom of **Submit** button in the above-mentioned gif. When I type in the input box, **the whole component is being re-rendered!**
*   If causing an action in one place highlight many others, isolated components, it is a cause for concern.
*   In most cases, the component is too large and should be refactored into smaller, modular components.
*   You can also see the current props and state (email and password) of the component at the right bottom corner. It is a really cool way to see the effect of state changes across the app.

### Why did you update?

We spoke about unnecessary rendering in the last segment. It’s not always easy to visually gauge which components are re-rendering needlessly. Thankfully, there is a package for that. It **notifies you in the console when potentially unnecessary re-renders occur.** It keeps track of the props and states, and when a component is re-rendered without any change in the props or the state, the package logs the details in the console. Make sure to not use this in production. Check it out [here](https://github.com/maicki/why-did-you-update).

![](https://cdn-images-1.medium.com/max/800/1*CL5jum98a0QxOWeIb9QRBg.png)

Image from [Why did you update](https://github.com/maicki/why-did-you-update)’s repo.

### Create React App(CRA)

Not exactly a development tool, but over the years I have found that this package is really helpful in creating rapid prototypes. Setting up a working React project is really hard. Understand various parts of its structure like Babel and webpack is even harder for a beginner. I wrote a two-part series just to explain that. It’s **Yet another Beginner’s Guide to setting up a React Project **— [Part 1](https://codeburst.io/yet-another-beginners-guide-to-setting-up-a-react-project-part-1-bdc8a29aea22) and [Part 2](https://codeburst.io/yet-another-beginners-guide-to-setting-up-a-react-project-part-2-5d3151814333). I explained the need of JSX, Babel and webpack.

Once you understand the basics, you’ll need to repeat the same set of steps every time you create a new project. And, you **_will_** need to create multiple project. Hence, to save developer’s time, Facebook created a package that encapsulates the complexity. Try it [here](https://github.com/facebook/create-react-app).

![](https://cdn-images-1.medium.com/max/800/1*O1N_DRWt0EKJ-uzBTNE-tg.png)

A successful execution of create-react-app.

* * *

There’s a high chance that you are using [Redux](https://redux.js.org/) for state management in your React app. Here are some Redux specific tools —

### Redux Dev Tools

Like React Dev Tools, but for redux. It is also available as a Chrome [Extension](https://github.com/zalmoxisus/redux-devtools-extension), and Firefox [addon](https://github.com/zalmoxisus/redux-devtools-extension). Its features are —

*   It lets you inspect every state and action payload
*   It lets you go back in time by “cancelling” actions. It is also called **Time Travel Debugging.** There is a great video on this by the creator Redux Dev Tools himself, [Dan Abramov](https://medium.com/@dan_abramov). Watch it [here](http://youtube.com/watch?v=xsSnOQynTHs).
*   If you change the reducer code, each “staged” action will be re-evaluated
*   If the reducers throw, you will see during which action this happened, and what the error was.
*   The dev tools logging UI (called LogMonitor) can be customised according to your needs. It’s a just another React Component. So it is not that difficult to customise it. Here’s a challenge by [Dan Abramov](https://medium.com/@dan_abramov) urging you to [create](https://github.com/gaearon/redux-devtools/issues/3) your own LogMonitor.

Some other monitors are: [Diff Monitor](https://github.com/whetstone/redux-devtools-diff-monitor), [Inspector](https://github.com/alexkuz/redux-devtools-inspector), [Filterable Log Monitor](https://github.com/bvaughn/redux-devtools-filterable-log-monitor/), [Chart Monitor](https://github.com/romseguy/redux-devtools-chart-monitor)

![](https://cdn-images-1.medium.com/max/800/1*lAp8ZAk5uNFTuxjhx4GTdw.gif)

### redux-immutable-state-invariant

Due to constraints put by functional programming style and the way redux behaves, [we are never supposed to mutate state](https://redux.js.org/troubleshooting#never-mutate-reducer-arguments). **However, it is not readily clear when we are mutating the state and when we are _replacing_ the existing state by a new one.**

This redux middleware will ensure that you inadvertently never do that. When the state is mutated, it will throw an error. Check it [here](https://github.com/leoasis/redux-immutable-state-invariant).

![](https://cdn-images-1.medium.com/max/1000/1*oOB0xSGDesQrkgAmMawR-Q.png)

Error when the state is mutated.

**Tips—**

*   Make sure that the state does not contain non-serialisable values such as functions. Otherwise, it will throw `RangeError: Maximum call stack size exceeded`.
*   Make sure to **not** use this package in production as the package involves lot of object copying and is really inefficient.

### redux-diff-logger

Chances are that you `console.log` the state whenever you need to examine it. Or better yet, you use the `[debugger](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/debugger)` statement and use dev tools to debug the state. In both cases, you need to see the **_changed values_** between the previous state and the current state. Redux diff logger does exactly that. **It logs the values that have changed between the states.**

![](https://cdn-images-1.medium.com/max/800/1*dwqA2l5S7nKPjY8cOoL1rA.png)

Image from [redux-diff-logger](https://github.com/evgenyrodionov/redux-diff-logger)’s repo.

What if you need to see the entire state and not just the changed values? Well, you are in luck: **Here’s another logger tool by the same author**: [redux-logger](https://github.com/evgenyrodionov/redux-logger).

* * *

I have also written about [Top Webpack Plugins for faster development](https://codeburst.io/top-webpack-plugins-for-faster-development-a2f6accb7a3e). It lists webpack plugins that simplify our life.

* * *

We are always looking for talented, curious people to [join the team](https://goo.gl/gePhPg).

**I write about JavaScript, web development, and Computer Science. Follow me for weekly articles.**

**Reach out to me on @** [**Facebook**](https://www.facebook.com/arfat.salman) **@** [**Linkedin**](https://www.linkedin.com/in/arfatsalman/) **@** [**Twitter**](https://twitter.com/salman_arfat)**.**


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
