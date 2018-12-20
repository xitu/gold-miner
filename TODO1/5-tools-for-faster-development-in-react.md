> * 原文地址：[5 Tools for Faster Development in React](https://blog.bitsrc.io/5-tools-for-faster-development-in-react-676f134050f2)
> * 原文作者：[Jonathan Saring](https://blog.bitsrc.io/@JonathanSaring?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/5-tools-for-faster-development-in-react.md](https://github.com/xitu/gold-miner/blob/master/TODO1/5-tools-for-faster-development-in-react.md)
> * 译者：
> * 校对者：

# 5 Tools for Faster Development in React

_5 tools to speed the development of your React UI components and applications._

React is great for quickly developing an application with a beautiful interactive UI. React components are a great way to create isolated and reusable building blocks for developing different applications.

While some [best practices](https://blog.bitsrc.io/how-to-write-better-code-in-react-best-practices-b8ca87d462b0) help develop a better application, the right tools can make the developments process faster. Here are 5 (+) useful tools to speed the development of your components and applications.

You are welcome to comment and suggest your own.

### 1. [Bit](https://bitsrc.io)

- [**Bit — Share and build with code components**: Bit helps you share, discover and use code components between projects and applications to build new features and...](https://bitsrc.io "https://bitsrc.io")

[Bit](https://bitsrc.io) is an open-source platform for building applications using components.

Using Bit you can organize components from your different apps and projects (without any refactoring), and make them accessible to discover, use, develop and collaborate on when building new features and applications.

- YouTube 视频链接：https://youtu.be/P4Mk_hqR8dU

Components shared with Bit become automatically available to install with NPM/Yarn, or to be consumed with Bit itself. The later enables you to simultaneously develop the components from different projects, and easily update (and merge) changes between them.

![](https://cdn-images-1.medium.com/max/1000/1*1aWFQBNr5aEQ1OnquZrIxw.png)

To make components more discoverable, Bit presents components with [visual rendering](https://blog.bitsrc.io/introducing-the-live-react-component-playground-d8c281352ee7), test results (Bit runs component unit-tests in isolation) and docs parsed from the sourcecode itself.

Using Bit, you can develop multiple applications faster, collaborate as a team and use your components as building blocks for new features and projects.

### 2. [StoryBook](https://storybook.js.org/) / [Styleguidist](https://react-styleguidist.js.org/)

Storybook and Styleguidist are environments for rapid UI development in React. Both are great tools for speeding development of your Reacts apps.

There are a few important differences between the two, which can also be combined to complete your component development system.

With Storybook you write _stories_ in JavaScript files. With Styleguidist you write _examples_ in Markdown files. While Storybook shows one variation of a component at a time, Styleguidist can show multiple variations of different components. Storybook is great for showing a component’s states, and Styleguidist is useful for documentation and demos of different components.

Here’s a short rundown.

#### [StoryBook](https://storybook.js.org/)

- [**storybooks/storybook**: storybook — Interactive UI component dev & test: React, React Native, Vue, Angular.](https://github.com/storybooks/storybook "https://github.com/storybooks/storybook")

[Storybook](https://github.com/storybooks/storybook) is a rapid development environment for UI components.

It allows you to browse a component library, view the different states of each component, and interactively develop and test components.

![](https://cdn-images-1.medium.com/max/800/1*8T0opytn0oYuEMpd8PRTsw.gif)

StoryBook helps you develop components in isolation from your app, which also encourages better reusability and testability for your components.

You can browse components from your library, play with their properties and get an instant impression with hot-reload on the web. You can find some popular examples [here](https://storybook.js.org/examples/).

Different plugins can help make your development process even faster, so you can shorten the cycle between code tweaking to visual output. StoryBook also supports [React Native](https://facebook.github.io/react-native/) and [Vue.js](https://vuejs.org/).

#### [Styleguidist](https://react-styleguidist.js.org/)

- [**React Styleguidist: isolated React component development environment with a living style guide**: Isolated React component development environment with a living style guide.](https://react-styleguidist.js.org/ "https://react-styleguidist.js.org/")

React [Styleguidist](https://github.com/styleguidist/react-styleguidist) is a component development environment with hot reloaded dev server and a living style guide that lists component `propTypes` and shows editable usage examples based on .md files.

![](https://cdn-images-1.medium.com/max/800/1*9V2nSEgH1VUbmXd5Dq-hnA.gif)

It supports ES6, Flow and TypeScript and works with Create React App out of the box. The auto-generated usage docs can help Styleguidist function as a documentation portal for your team’s different components.

*   Also check out [**React Live**](https://github.com/FormidableLabs/react-live) by Formidable Labs. This component rendering environment is also used in [Bit’s live component playground](https://bitsrc.io/bit/movie-app/components/hero).

### 3. [React devTools](https://chrome.google.com/webstore/detail/react-developer-tools/fmkadmapgofadopljbjfkapdkoienihi?hl=en)

![](https://cdn-images-1.medium.com/max/800/1*9XrmfPqh_naIBlTi7dv3Hw.gif)

This official React Chrome devTools [extension](https://chrome.google.com/webstore/detail/react-developer-tools/fmkadmapgofadopljbjfkapdkoienihi?hl=en) allows you to inspect the React component hierarchies in the Chrome Developer Tools. It is also available as a [FireFox Add-On](https://addons.mozilla.org/en-US/firefox/addon/react-devtools/).

Using React devTools you can inspect and edit a component props and state, while navigating through your component hierarchy tree. This feature lets you see how component changes affect other components, to help design your UI with the right component structure and separation.

The extension’s search bar can enables you to quickly find and inspect the components you need, to save precious development time.

![](https://cdn-images-1.medium.com/max/800/1*GAPOIeQHhPFS5D0ccHHy7w.gif)

Check out the [standalone app](https://github.com/facebook/react-devtools/tree/master/packages/react-devtools) which works with Safari, IE and React Native.

### 4. [Redux devTools](http://extension.remotedev.io/)

![](https://cdn-images-1.medium.com/max/800/1*RESAzFvlkgBlU4IgRGQjaA.gif)

This [Chrome extension](https://github.com/zalmoxisus/redux-devtools-extension) (and [FireFox Add-On](https://addons.mozilla.org/en-US/firefox/addon/remotedev/)) is a development time package that provides power-ups for your Redux development workflow. It lets you inspect every state and action payload, re-evaluating “staged” actions.

You can integrate [Redux DevTools Extension](https://github.com/zalmoxisus/redux-devtools-extension) with any architecture which handles the state. You can have multiple stores or different instances for every React component’s local state. You can even “time travel” to cancel actions (watch this [Dan Abramov](https://medium.com/@dan_abramov) [video](https://www.youtube.com/watch?v=xsSnOQynTHs)). The logging UI itself can even be customized as a React component.

### 5. Boilerplates & Kick-Starters

While these aren’t exactly devTools, they help to quickly setup your React application while saving time around build and other configurations. While there are many [starter-kits](https://reactjs.org/community/starter-kits.html) for React, here are some of the best.

When combined with pre-made components (on [Bit](https://bitsrc.io) or other sources), you can quickly create an app structure and compose components into it.

#### [Create React App](https://github.com/facebook/create-react-app) (50k stars)

![](https://cdn-images-1.medium.com/max/800/1*2aquNYnmp7YHa2TeefS9Ew.gif)

This widely used and popular project is probably the most efficient way to quickly create a new React application and get it up and running from scratch.

This package encapsulates the complicated configurations (Babel, Webpack etc) needed for a new React app, so you can save this time for a new app.

To create a new app, you just need to run a single command.

npx create-react-app my-app

This command create a directory called `my-app` inside the current folder.  
Inside the directory, it will generate the initial project structure and install the transitive dependencies so you can simply start coding.

#### [React Boilerplate](https://github.com/react-boilerplate/react-boilerplate) (18k stars)

This React boilerplate template by [Max Stoiber](https://medium.com/@mxstbr) provides a kick-start template for your React applications which focuses on offline development and is built with scalability and performance in mind.

It’s quick scaffolding helps to create components, containers, routes, selectors and sagas — and their tests — right from the CLI, while CSS and JS changes can be reflected instantly while you make them.

Unlike create-react-app this boilerplate isn’t designed for beginners, but rather to provide seasoned developers with the tools to manage performance, asynchrony, styling, and more to build a production-ready  application.

#### [React Slingshot](https://github.com/coryhouse/react-slingshot) (8.5k stars)

This wonderful project by [Cory House](https://medium.com/@housecor) is a React + Redux starter kit / boilerplate with Babel, hot reloading, testing, linting and more.

Much like React Boilerplate, this starter-kit focuses on the developer experience for rapid development. Every time you hit “save”, changes are hot-reloaded and automated tests are being run.

The project even includes an example app so you can start working without having to read too much through the docs.

*   Also check out [**simple-react-app**](https://github.com/Kornil/simple-react-app)  which is explained in [this post](https://medium.com/@francesco.agnoletto/i-didnt-like-create-react-app-so-i-created-my-own-boilerplate-190a7dd5d74).

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
