> * 原文地址：[Frontend in 2017: The important parts](https://blog.logrocket.com/frontend-in-2017-the-important-parts-4548d085977f)
> * 原文作者：[Kaelan Cooter](https://blog.logrocket.com/@eranimo?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/frontend-in-2017-the-important-parts.md](https://github.com/xitu/gold-miner/blob/master/TODO/frontend-in-2017-the-important-parts.md)
> * 译者：
> * 校对者：

# **Frontend in 2017: The important parts**

![](https://cdn-images-1.medium.com/max/1000/1*kTjbJH9x_nfRNgBduM3Oqg.png)

A lot has happened in 2017, and it can be a bit overwhelming to think about. We all like to joke about how quickly things change in frontend engineering, and for the last few years that has probably been true.

At this risk of sounding cliché, I’m here to tell you that this time it’s different.

Frontend trends are starting to stabilize — popular libraries have largely gotten _more_ popular instead of being disrupted by competitors — and web development is starting to look pretty awesome.

In this post, I’ll summarize some of the important things that happened this year in the frontend ecosystem with an eye toward big-picture trends.

#### **Crunching the numbers**

It’s hard to tell when something is the next big thing, especially when you’re still on the last big thing. Getting accurate usage data for open source tools is tricky. Typically we look in a few places:

* **GitHub star counts** are loosely correlated with a library’s popularity, but people often star libraries that look interesting and then never return.
* **Google Trends** is helpful for seeing trends at a rough level, but doesn’t offer data with enough granularity to accurately compare a particular set of tools.
* **Stack Overflow question volume** is more of an indication of how confused people are using a technology rather than how popular it is.
* **NPM download** **stats** is the most accurate measure of how many people are actually using a particular library. Even these might not be totally accurate since this number also includes automatic downloads like those done in continuous integration tools.
* **Surveys** like the [State of JavaScript 2017](https://stateofjs.com/) are helpful for seeing trends among a large sample size (20,000 developers).

### Frameworks

#### React

[React 16](https://reactjs.org/blog/2017/09/26/react-v16.0.html) was released in September, bringing with it a complete rewrite of the internal core architecture without any major API changes. The new version offers improved error handling with the introduction of [error boundaries](https://reactjs.org/blog/2017/07/26/error-handling-in-react-16.html) as well as support for rendering a subsection of the render tree onto another DOM node.

The React team chose to rewrite the core architecture in order to support asynchronous rendering in a future release, something that was impossible with the previous architecture. With async rendering, React would avoid blocking the main thread when rendering heavy applications. The plan is to offer it as an opt-in feature in a future minor release of React 16, so you can expect it some time in 2018.

React also [switched to an MIT license](https://code.facebook.com/posts/300798627056246/relicensing-react-jest-flow-and-immutable-js/) after a period of controversy over the previous BSD license. It was widely believed that the patent clause was too restrictive, causing many teams to consider switching to an alternative Javascript view framework. However, it has been argued that the controversy was [unfounded](https://blog.cloudboost.io/3-points-to-consider-before-migrating-away-from-react-because-of-facebooks-bsd-patent-license-b4a32562d268), and that the new patent actually leaves React users less protected than before.

#### Angular

After eight beta releases and six release candidates, Angular 4 was released in March. The key feature in this release is ahead of time compilation — views are now compiled at build-time instead of render time. This means that Angular apps no longer need to ship with a compiler for application views, reducing the bundle size significantly. This release also improves support for server-side rendering and adds many small “quality of life” improvements to the Angular template language.

Over the course of 2017, Angular has continued to lose ground compared to React. Although the release of Angular 4 has been a popular release, it is now even farther away from the top spot than it was at the beginning of the year.

![](https://cdn-images-1.medium.com/max/800/0*EElb5vgfVEQaMzL3.)

NPM downloads of Angular, React, and Vue

Source: npmtrends.com

#### Vue.js

2017 has been a great year for Vue, allowing it to take its place as a premiere frontend view framework alongside React and Angular. It has become popular because of its simple API and comprehensive suite of companion frameworks. Since it has a template language similar to Angular and the component philosophy of React, Vue is often seen as occupying a sort of “middle ground” between the two options.

There has been an explosion of growth in Vue in the last year. This has generated a considerable amount of press and dozens of [popular UI libraries](https://github.com/vuejs/awesome-vue#components--libraries) and boilerplate projects. Large companies have started to adopt Vue — Expedia, Nintendo, GitLab [among many others](https://madewithvuejs.com/).

At the beginning of the year, Vue had 37k stars on Github and 52k downloads on NPM per week. By the middle of December, it had 76k stars on Github and 266k downloads per week, twice as many stars and five times as many downloads.

This still pales in comparison to React, which had 1.6 million downloads per week in the middle of December according to NPM Stats. One can expect Vue to continue its rapid growth and perhaps become one of the top two frameworks in 2018.

**TL;DR:** React has won for now but Angular is still kicking. Meanwhile, Vue is surging in popularity.

### ECMAScript

The 2017 edition of the ECMAScript specification underlying Javascript was released in June after an [exhaustive proposal process](https://github.com/tc39/ecma262) concluded with several groundbreaking features such as asynchronous functions and shared memory and atomic operations.

Async functions allow for writing clear and concise asynchronous Javascript code. They are now [supported](https://caniuse.com/#search=async%20fun) in all major browsers. NodeJS added support in v7.6.0 after they upgraded to V8 5.5, which was released in late 2016 and also brought significant performance and memory improvements.

[Shared Memory and atomic operations](http://2ality.com/2017/01/shared-array-buffer.html) are a hugely significant feature that hasn’t gotten a lot of notice. Shared Memory is implemented using the _SharedArrayBuffer_ construct, which allows web workers to access the same bytes of a typed array in memory. Workers (and the main thread) use atomic operations provided by the new _Atomics_ global to safely access this memory across different execution contexts. SharedArrayBuffer offers a much faster method of communication between workers compared to message sending or transferrable objects.

Adoption of shared memory will be hugely significant in the years to come. Near-native performance for JavaScript applications and games means that the web becomes a more competitive platform. Applications can become more complex and do more expensive operations in the browser without sacrificing performance or offloading tasks to the server. A truly parallel architecture with shared memory is a great asset for anyone trying to create games with WebGL and web workers.

As of December 2017 they are supported by all major browsers, and Edge starting with v16. Node does not currently support web workers, so they have no plans on supporting Shared Memory. However, they are currently [rethinking their worker support](https://github.com/nodejs/node/issues/13143), so it’s possible that it might find its way into Node in the future.

**TL;DR:** Shared memory will make high-performance parallel computing in JavaScript _much_ easier to work with and far more efficient.

### WebAssembly

WebAssembly (or WASM) provides a way to compile code written in other languages to a form that can be executed in the browser. This code is a low-level assembly-like language that is designed to run at near-native performance. JavaScript can load and execute WebAssembly modules using a new API.

The API also provides a [memory constructor](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_objects/WebAssembly/Memory) that provides a way for JavaScript to directly read and manipulate the memory accessed by a WebAssembly module instance, allowing for a higher degree of integration with JavaScript applications.

[All major browsers](https://caniuse.com/#feat=wasm) now support WebAssembly, with Chrome support arriving in May, Firefox in March, and Edge in October. Safari supports it in their 11th release, which ships with MacOS High Sierra and an update is available for the Sierra and El Capitan releases. Chrome for Android and Safari Mobile also support WebAssembly.

You can compile C/C++ code to WebAssembly using the [emscripten](http://kripken.github.io/emscripten-site/index.html) compiler and [configuring it to target WebAssembly](https://developer.mozilla.org/en-US/docs/WebAssembly/C_to_wasm). You can also [compile Rust to WebAssembly](https://hackernoon.com/compiling-rust-to-webassembly-guide-411066a69fde), as well as [OCaml](https://github.com/sebmarkbage/ocamlrun-wasm). There are multiple ways to compile JavaScript (or something close to it) to WebAssembly. Some of these, like [Speedy.js](https://github.com/MichaReiser/speedy.js) and [AssemblyScript](https://github.com/AssemblyScript/prototype) leverage TypeScript for type checking but add lower-level types and basic memory management.

None of these projects are production-ready and their APIs are changing frequently. Given the [desire](https://github.com/WebAssembly/design/issues/219) for compiling JS to WebAssembly one can expect these projects to gain momentum as WebAssembly becomes more popular.

There are already a lot of [really interesting WebAssembly projects](https://github.com/mbasso/awesome-wasm). There is a [virtual DOM implementation](https://github.com/mbasso/asm-dom) targeting C++, allowing to create an entire frontend application in C++. If your project uses Webpack, there is a [wasm-loader](https://github.com/ballercat/wasm-loader) that eliminates the need to manually fetch and parse .wasm files directly. [WABT](https://github.com/WebAssembly/wabt) offers a suite of tools that allow you to transform between the binary and text WebAssembly formats, print information about WASM binaries, and merge .wasm files.

Expect WebAssembly to become more popular in the coming year as more tools are developed and the JavaScript community wakes up to its possibilities. It’s currently in the “experimental” phase, and browsers have only recently begun to support it. It will become a niche tool for speeding up CPU-intensive tasks like image processing and 3D rendering. Eventually as it matures I suspect that it will find use cases in more everyday applications.

**TL;DR:** WebAssembly will change everything eventually, but it’s still pretty new.

### Package Managers

2017 was a great year for JavaScript package management. Bower continued it’s decline and replacement by NPM. It’s last release was November 2016 and its maintainers now [officially recommend](https://github.com/bower/bower/pull/2458) that users use NPM for frontend projects.

Yarn was introduced in October of 2016 and brought innovation to JavaScript package management. Although it uses the same public package repository as NPM, Yarn offered faster dependency download and installation times and a more user-friendly API.

Yarn introduced lock files which allowed for reproducible builds across different machines and an offline mode that allowed users to reinstall packages without an internet connection. As a result its popularity exploded and thousands of projects started using it.

![](https://cdn-images-1.medium.com/max/800/0*nn0TySEdCgPs-G0x.)

_GitHub stars for Yarn (purple) vs NPM (brown)._ Source: GitHub Star History

NPM responded with a massive v5 release which significantly improved performance and overhauling the API. Yarn responded with introducing [Yarn Workspaces](https://yarnpkg.com/blog/2017/08/02/introducing-workspaces/), allowing first-class support for monorepo package management similar to the popular [Lerna](https://github.com/lerna/lerna) tool.

There are now more options for NPM clients than just Yarn and NPM. [PNPM](https://github.com/pnpm/pnpm) is another popular option, billing itself as “fast, disk space efficient package manager”. Unlike Yarn and NPM it keeps a global cache of every package version ever installed which it symlinks into the node_modules folder of your package.

**TL;DR:** NPM has adapted quickly to Yarn’s surge in popularity, both are now popular.

### Stylesheets

#### Recent Innovations

Within the last few years CSS preprocessors like SASS, Less, and Stylus have become popular. [PostCSS](https://github.com/postcss/postcss) — which was introduced way back in 2014 — really took off in 2017, becoming by far the most popular CSS preprocessor. Unlike the other preprocessors, PostCSS adopts a modular plugin approach similar to what Babel does for JavaScript. In addition to transforming stylesheets it also provides linters and other tools.

![](https://cdn-images-1.medium.com/max/800/0*YPde_bP7PQlyGuxs.)

NPM downloads for PostCSS, SASS, Stylus, and Less in 2017

Source: NPM Stats accessed on December 15, 2017

There has always been a desire to solve some of the lower-level problems with CSS that make it difficult to use it in concert with component-based development. Particularly, the global namespace makes it difficult to create styles that are isolated within a single component. Keeping CSS in a different file than the component code means that smaller components take up a larger footprint and require two files to be open in order to develop.

[CSS Modules](https://github.com/css-modules/css-modules) augments normal CSS files by adding namespaces that can be used to isolate component styles. This works by generating a unique class name for each “local” class. This has become a viable solution with the widespread adoption of frontend build systems like Webpack, which has support for CSS Modules with its [css-loader](https://github.com/webpack-contrib/css-loader). PostCSS has a [plugin](https://github.com/css-modules/postcss-modules) to provide the same functionality. However, with this solution CSS remains in a separate file from component code.

#### Other Solutions

“CSS in JS” was an idea introduced in [a famous talk](https://speakerdeck.com/vjeux/react-css-in-js) in late 2014 by Christopher “Vjeux” Chedeau, a Facebook engineer on the React development team. This has spawned several influential libraries making it easier to create componentized styles. By far the most popular solution has been [styled-components](https://github.com/styled-components/styled-components), which uses ES6 [tagged template literals](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Template_literals) to create React components from CSS strings.

Another popular solution is [Aphrodite](https://github.com/Khan/aphrodite), which uses JavaScript object literals to create framework-agnostic inline styles. In the [State of JavaScript 2017](https://stateofjs.com/2017/css/results/) survey, 34% of developers said that they have used CSS-in-JS.

**TL;DR:** PostCSS is the preferred CSS preprocessor, but many are switching to CSS-in-JS solutions.

### Module Bundlers

#### Webpack

In 2017 Webpack as solidified its lead over the previous generation of JavaScript bundling tools by a wide margin:

![](https://cdn-images-1.medium.com/max/800/0*93D2VJU6CrNg6QLv.)

NPM downloads of Webpack, Gulp, Browserify, Grunt

Source: npmtrends.com

Webpack 2 was released in February of this year. It brought important features like ES6 modules (no longer requiring Babel to transpile import statements) and tree shaking (which eliminates unused code from your bundles). V3 was released shortly after that, bringing a feature called “scope hoisting” which places all of your webpack modules into a single JavaScript bundle, significantly reducing its size.

In July the Webpack team [received](https://medium.com/webpack/webpack-awarded-125-000-from-moss-program-f63eeaaf4e15) a grant from the Mozilla Open Source Support program in order to develop first-class support for WebAssembly. The plan is to eventually offer deep integration with WebAssembly and the JavaScript module system.

There has been innovation in the module bundler space not related to Webpack. While it remains popular, developers have complained about the difficulty in configuring it correctly and the wide array of plugins required to get acceptable performance on large projects.

#### Parcel

[Parcel](https://github.com/parcel-bundler/parcel) is an interesting project that gained notice in early December (10,000 stars on Github in only 10 days!). It bills itself as a “blazing fast, zero configuration web application bundler”. It largely achieves this by utilizing multiple CPU cores and an efficient filesystem cache. It also operates on abstract syntax trees instead of strings like Webpack. Like Webpack, Parcel also handles non-JavaScript assets like images and stylesheets.

The module bundler space displays a common pattern in the JavaScript community: the constant back-and-forth between the “batteries included” (aka centralized) and “configure everything” (aka decentralized) approaches.

We see this in the transition from Angular to React / Redux and from SASS to PostCSS. Webpack and the bundlers and task-runners before it were all decentralized solutions with many plugins.

In fact, Webpack and React share similar complaints in 2017 for nearly the same reasons. It makes total sense that people would desire a “batteries included” solution for bundling as well.

#### Rollup

Rollup generated a considerable amount of attention before the release of Webpack 2 in 2016 by introducing a popular feature known as _tree shaking_, which is just a fancy way of saying _dead-code elimination_. Webpack responded with [support](https://webpack.js.org/guides/tree-shaking/) for Rollup’s signature feature in its second release. Rollup [bundles modules differently](https://stackoverflow.com/questions/43219030/what-is-flat-bundling-and-why-is-rollup-better-at-this-than-webpack) than Webpack, making the overall bundle size smaller but at the same time preventing important features like code splitting, which Rollup [does not support](https://github.com/rollup/rollup/issues/372).

In April the React team [switched](https://github.com/facebook/react/pull/9327) to Rollup from Gulp, prompting many to ask why they chose Rollup over Webpack. The Webpack team responded to this confusion by actually [recommending](https://medium.com/webpack/webpack-and-rollup-the-same-but-different-a41ad427058c) Rollup for library development and Webpack for app development.

**TL;DR:** Webpack is still by far the most popular module bundler, but it might not be forever.

### TypeScript

In 2017 [Flow](https://github.com/facebook/flow) lost considerable ground to [TypeScript](https://github.com/Microsoft/TypeScript):

![](https://cdn-images-1.medium.com/max/800/0*1WUQKu98izZcyQwf.)

Flow vs TypeScript NPM downloads in 2017_ Source: NPM Trends

Although this trend has existed for the last few years, it’s picked up pace in 2017. TypeScript is now the [third-most loved language](https://insights.stackoverflow.com/survey/2017#technology) according to the 2017 Stack Overflow Developer Survey (Flow didn’t even garner a mention).

Reasons often cited as for why TypeScript won include: superior tooling (especially with editors like [Visual Studio Code](https://code.visualstudio.com/)), linting support ([tslint](https://github.com/palantir/tslint) has become quite popular) larger community, larger database of third-party library type definitions, better documentation, and easier configuration. Early on TypeScript got automatic popularity by virtue of being the language of choice for the Angular project, but in 2017 has solidified its usage across the entire community. According to [Google Trends](https://trends.google.com/trends/explore?date=2015-12-15%202017-12-15&q=%2Fm%2F0n50hxv), TypeScript grew twice as popular over the course of the year.

TypeScript has adopted a [rapid release schedule](https://github.com/Microsoft/TypeScript/wiki/Roadmap) that has allowed it to keep up the pace with JavaScript language development while also fine-tuning the type system. It now supports ECMAScript features like iterators, generators, async generators, and dynamic imports. You can now [typecheck JavaScript](https://www.typescriptlang.org/docs/handbook/type-checking-javascript-files.html) using TypeScript, which is achieved through type inference and JSDoc comments. If you use Visual Studio Code, TypeScript now supports powerful transformation tools in-editor which allow you to rename variables and automatically import modules.

**TL;DR:** TypeScript is winning against Flow.

### State Management

Redux continues to be the preferred state management solution for React projects, enjoying 5x growth in NPM downloads throughout 2017:

![](https://cdn-images-1.medium.com/max/800/0*dgXzSYQF9HFyVEvc.)

NPM downloads for Redux in 2017

Source: NPM Trends

Mobx is an interesting competitor to Redux for client-side state management. Unlike Redux, MobX uses observable state objects and an API inspired by [functional reactive programming](https://github.com/lucamezzalira/awesome-reactive-programming) concepts. Redux in contrast was heavily influenced by classic functional programming and favors pure functions. Redux can be considered a “manual” state manager in that actions and reducers explicitly describe state changes; MobX in contrast is a “automatic” state manager because the observable pattern does all of that for you behind the scenes.

MobX makes very little assumptions about how you structure your data, what type of data you’re storing, or whether or not it’s JSON-serializable. The above reasons makes it very easy for beginners to start using MobX.

Unlike Redux, MobX is not transactional and deterministic, meaning you don’t automatically get all of the benefits Redux enjoys with debugging and logging. You can’t easily take a snapshot of the entire state of a MobX application, meaning that debugging tools like [LogRocket](https://logrocket.com/) have to watch each of your observables manually.

It’s used by several high-profile companies like Bank of America, IBM, and Lyft. There is also a [growing community](https://github.com/mobxjs/awesome-mobx) of plugins, boilerplates, and tutorials. It’s also growing really fast: from 50k NPM downloads at the beginning of the year to a peak of 250k NPM downloads in October.

Because of the aforementioned limitations, the MobX team has been hard at work at combining the best of both world of Redux and MobX in a project called [mobx-state-tree](https://github.com/mobxjs/mobx-state-tree) (or MST). It’s essentially a state container that uses MobX behind the scenes to provide a way to work with immutable data as easy as working with mutable data. Basically, your state is still mutable, but you work with an immutable copy of this state referred to as a _snapshot_.

There is already a plethora of developer tools that help debug and inspect your state trees — [Wiretap](https://wiretap.debuggable.io/) and [mobx-devtools](https://github.com/andykog/mobx-devtools) are great options. Because they operate in a similar way, you can even use Redux devtools with mobx-state-tree.

**TL;DR:** Redux is still king, but look out for MobX and mobx-state-tree.

### GraphQL

GraphQL is a query language and runtime for APIs that offers a more descriptive and easy-to-use syntax for reasoning about your data sources. Instead of building REST endpoints, GraphQL provides a typed query syntax that allows JavaScript clients to request only the data that they need. It is perhaps the most important innovation in API development within the last few years.

Although the GraphQL language spec hasn’t changed since [October 2016](http://facebook.github.io/graphql/October2016/), interest in it has continued to climb. Over the last year, Google Trends has seen a [4x increase](https://trends.google.com/trends/explore?q=GraphQL) in searches for GraphQL, NPM has seen a [13x increase](http://www.npmtrends.com/graphql) in NPM downloads for the JavaScript reference [GraphQL client](https://github.com/graphql/graphql-js).

There are now many client and server implementations to choose from. [Apollo](https://www.apollographql.com/) is an popular client and server choice, adding comprehensive cache controls and integrations with many popular view libraries like React and Vue. [MEAN](https://github.com/linnovate/mean) is a popular full-stack framework that uses GraphQL as an API layer.

Within the last year the [community behind GraphQL](https://github.com/chentsulin/awesome-graphql) has also grown immensely. It has created server implementations in over 20 languages and thousands of tutorials and starter projects. There is a very popular “[awesome list](https://github.com/chentsulin/awesome-graphql)”.

[React-starter-kit](https://github.com/kriasoft/react-starter-kit) — the most popular React boilerplate project — also uses GraphQL.

**TL;DR:** GraphQL is gaining momentum.

### Also worth mentioning…

#### NapaJS

Microsoft’s new multi-threaded JavaScript runtime is built on top of V8\. [NapaJS](https://github.com/Microsoft/napajs) provides a way to use multithreading in a Node environment, allowing expensive CPU-bound tasks to be performed that otherwise would have been slow using the existing Node architecture. It offers a thread alternative to Node’s multiprocessing model, implemented as a module and available in NPM like any other library.

While it has been possible to use threads in Node using the [node-webworker-threads](https://github.com/audreyt/node-webworker-threads) package and by interfacing with lower-level languages, Napa makes this seamless with the rest of the Node ecosystem by adding the ability to use the Node modules system from inside worker threads. It also includes a comprehensive API for sharing data across workers, similar to the newly released shared memory standard.

The project is Microsoft’s effort to use bring high-performance architecture to the Node ecosystem. It’s currently used by the Bing search engine as part of its backend stack.

Given that it has the support of a major company like Microsoft, you can expect long term stability. It will be interesting to see how far the Node community goes with multithreading.

#### Prettier

The trend in recent years has overwhelmingly been an increase in the importance of and complexity of build tools. With the debut of [Prettier](https://github.com/prettier/prettier), code formatting is now a popular addition to a frontend build pipeline. It bills itself as an “opinionated” code formatter designed to enforce a consistent coding style by parsing and reprinting it.

While linting tools like [ESLint](https://eslint.org/) have long been able to [automatically enforce linting rules](https://eslint.org/docs/user-guide/command-line-interface#--fix), prettier is the most feature rich solution. Unlike ESLint, Prettier also supports JSON, CSS, SASS, and even GraphQL and Markdown. It also offers deep [integration with ESLint](https://prettier.io/docs/en/eslint.html) and many [popular editors](https://prettier.io/docs/en/editors.html). Now if we could just agree on semicolons, we’d be alright.

* * *

### Plug: LogRocket, a DVR for web apps

</div>

![](https://cdn-images-1.medium.com/max/1000/1*s_rMyo6NbrAsP-XtvBaXFg.png)

[LogRocket](https://logrocket.com) is a frontend logging tool that lets you replay problems as if they happened in your own browser. Instead of guessing why errors happen, or asking users for screenshots and log dumps, LogRocket lets you replay the session to quickly understand what went wrong. It works perfectly with any app, regardless of framework, and has plugins to log additional context from Redux, Vuex, and @ngrx/store.

In addition to logging Redux actions and state, LogRocket records console logs, JavaScript errors, stacktraces, network requests/responses with headers + bodies, browser metadata, and custom logs. It also instruments the DOM to record the HTML and CSS on the page, recreating pixel-perfect videos of even the most complex single page apps.


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
