> * 原文地址：[A comprehensive look back at front-end in 2018](https://blog.logrocket.com/a-comprehensive-look-back-at-frontend-in-2018-8122e724a802)
> * 原文作者：[Kaelan Cooter](https://blog.logrocket.com/@eranimo)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/a-comprehensive-look-back-at-frontend-in-2018.md](https://github.com/xitu/gold-miner/blob/master/TODO1/a-comprehensive-look-back-at-frontend-in-2018.md)
> * 译者：
> * 校对者：

A comprehensive look back at front-end in 2018

Grab a coffee, settle in, and read slow. Our review doesn’t miss much.

![](https://cdn-images-1.medium.com/max/800/1*h4mMvgiilV-JPS1Ytpndyg.png)

Web development has always been a fast-moving field — making it hard to keep up with all the browser changes, library releases, and new programming trends that can inundate your mind over the course of the year.

The industry is growing bigger every year, making it harder for the average developer to keep up. So let’s take a step back and review what changed in the web development community in 2018.

We have witnessed an explosive evolution of Javascript over the last few years. As the internet became even more important to the global economy, powerful commercial stakeholders like Google and Microsoft realized that they needed better tools to create the next generation of web applications.

This led to the largest wave of changes to Javascript since its inception, starting with ECMAScript 2015 (aka ES6). There are now yearly releases which have brought us exciting new features like classes, generators, iterators, promises, a completely new module system, and much more.

This launched a golden age of web development. Many of the most popular tools, libraries, and frameworks today first became popular right after ES2015 was released. Even before major browser vendors supported even half of the new standard, the [Babel](https://babeljs.io/) compiler project allowed thousands of developers to get a head start and experiment with the new features themselves.

Frontend developers for the first time were not beholden to the oldest browser their company supports but were free to innovate at their own pace. Three years and three ECMAScript editions later, this new age of web development shows no signs of slowing down.

### New JS language features

Compared to previous editions, ECMAScript 2018 was rather light feature-wise, only adding [object rest / spread properties](https://github.com/tc39/proposal-object-rest-spread), [asynchronous iteration](https://github.com/tc39/proposal-async-iteration), and [Promise.finally](https://github.com/tc39/proposal-promise-finally), all of which have been supported by Babel and [core-js](https://github.com/zloirock/core-js#stage-3-proposals) for a while now. [Most browser](http://kangax.github.io/compat-table/es2016plus/#test-Asynchronous_Iterators) and [Node.js](https://node.green/) all of ES2018 except Edge, which only supports Promise.finally. For many developers, this means that all the language features they need are supported in all browsers they support — some wonder whether Babel is really necessary anymore.

### New regular expression features

Javascript has always been lacking some of the more advanced regular expression features that other languages like Python have — that is, until now. ES2018 adds four new features:

*   [Lookbehind assertions](https://github.com/tc39/proposal-regexp-lookbehind), providing the missing complement to the lookahead assertions that have been in the language since all the way back in 1999.
*   [s (dotAll) flag](https://github.com/tc39/proposal-regexp-dotall-flag), which matches any single character except line terminators.
*   [Named capture groups](https://github.com/tc39/proposal-regexp-named-groups), which make using regular expressions easier by allowing property-based lookup for capture groups.
*   [Unicode property escape](https://github.com/tc39/proposal-regexp-unicode-property-escapes), which makes it possible to write regular expressions that are aware of unicode.

Although many of these features have had workarounds and alternative libraries for years, none could hope to match the speed that native implementations provide.

### New browser features

There has been an incredible amount of new Javascript browser APIs released this year. Almost everything has seen improvement — web security, high-performance computing, and animations to name a few. Let’s break them down by domain to get a better sense of their impact.

### WebAssembly

Although WebAssembly v1 support was added to major browsers last year, it has not yet been widely adopted by the developer community. The WebAssembly Group has an [ambitious feature roadmap](https://webassembly.org/docs/future-features/) for features like [garbage collection](https://github.com/WebAssembly/gc), ECMAScript module integration, and [threads](https://developers.google.com/web/updates/2018/10/wasm-threads). Perhaps with these features, we will start to see widespread adoption in web applications.

Part of the problem is that WebAssembly requires a lot of setup to get started and many developers used to Javascript are not familiar with working with traditional compiled languages. Firefox launched an online IDE called [WebAssembly Studio](https://hacks.mozilla.org/2018/04/sneak-peek-at-webassembly-studio/) that makes it as easy as possible to get started with WebAssembly. If you’re looking to integrate it into an existing app, there are now plenty of tools to choose from. Webpack v4 added experimental [built-in support](https://github.com/webpack/webpack/releases/tag/v4.0.0) for WebAssembly modules tightly integrated into the build and module systems and with source map support.

Rust has emerged as a favorite language to compile to WebAssembly. It offers a robust package ecosystem with [cargo](https://github.com/rust-lang/cargo), reliable performance, and an [easy to learn](https://doc.rust-lang.org/book/) syntax. There’s already an emerging ecosystem of tools that integrate Rust with Javascript. You can publish Rust WebAssembly packages to NPM using [wasm-pack](https://github.com/rustwasm/wasm-pack). If you use Webpack, you can now seamlessly integrate Rust code in your app using the [rust-native-wasm-loader](https://github.com/dflemstr/rust-native-wasm-loader).

If you’d rather not abandon Javascript to use WebAssembly, you’re in luck — there are now several options to choose from. If you’re familiar with Typescript, there’s the [AssemblyScript](https://github.com/AssemblyScript/assemblyscript) project which uses the official [Binaryen](https://github.com/WebAssembly/binaryen) compiler together with Typescript.

Therefore, it works well with existing Typescript and WebAssembly tools. [Walt](https://github.com/ballercat/walt) is another compiler that sticks to the Javascript syntax (with Typescript-like type hints) and compiles directly to the WebAssembly text format. It has zero dependencies, very fast compilation times, and integration with Webpack. Both projects are in active development, and depending on your standards they might not be considered “production ready”. Regardless, they are worth checking out.

### Shared memory

Modern Javascript applications often do heavy computation in [Web Workers](https://developer.mozilla.org/en-US/docs/Web/API/Worker) to avoid blocking the main thread and interrupting the browsing experience. While workers have been available for several years now, their limitations prevented them from being more widely adopted. Workers can transfer data between other threads using the [postMessage](https://developer.mozilla.org/en-US/docs/Web/API/Worker/postMessage) method, which either clones the data being sent (slower) or uses [transferable objects](https://developer.mozilla.org/en-US/docs/Web/API/Transferable) (faster). Thus, communication between threads is either slow or one-way. For simple applications this is fine, but it has prevented more complex architectures from being built using workers.

[SharedArrayBuffer](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/SharedArrayBuffer) and [Atomics](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Atomics) are new features that allow Javascript applications to share a fixed memory buffer between contexts and perform atomic operations on them. However, browser support was temporarily removed after it was discovered that shared memory makes browsers vulnerable to a previously unknown timing attack known as [Spectre](https://meltdownattack.com/). Chrome re-enabled SharedArrayBuffers in July when they released a [new security feature](https://www.techrepublic.com/article/google-enabled-site-isolation-in-chrome-67-heres-why-and-how-it-affects-users/) which mitigated the vulnerability. In Firefox its disabled by default but can be [re-enabled](https://blog.mozilla.org/security/2018/01/03/mitigations-landing-new-class-timing-attack/). Edge has [removed support completely](https://blogs.windows.com/msedgedev/2018/01/03/speculative-execution-mitigations-microsoft-edge-internet-explorer/#Yr2pGlOHTmaRJrLl.97) and Microsoft hasn’t indicated when it’s going to be re-enabled. Hopefully, by next year all browsers will have mitigation strategies in place so that this critical missing feature can be used.

### Canvas

Graphics APIs such as Canvas and WebGL have been supported for several years now, but they have always been limited to rendering only in the main thread. Rendering can, therefore, be blocking. And that leads to poor user experiences. The [OffscreenCanvas](https://developer.mozilla.org/en-US/docs/Web/API/OffscreenCanvas#Asynchronous_display_of_frames_produced_by_an_OffscreenCanvas) API solves that problem by allowing you to transfer control of a canvas context (2D or WebGL) to a web worker. The worker can then use the Canvas APIs like normal while render seamlessly in the main thread without blocking.

Given the significant performance savings, you can expect chart and drawing libraries to look into supporting it soon. [Browser support](https://caniuse.com/#feat=offscreencanvas) right now is limited to Chrome, Firefox supports it behind a flag, and the Edge team hasn’t made any public indication of support. You can expect it to pair well with SharedArrayBuffers and WebAssembly, allowing a Worker to render based on data existing in any thread, from code written in any language, all without a janky user experience. This might make the dream of high-end gaming on the web a reality, and allow even more complex graphics in web applications.

There is a major effort underway to bring new drawing and layout APIs to CSS. The goal is to expose parts of the CSS engine to web developers to demystify some of the “magic” of CSS. The [CSS Houdini Task Force](https://github.com/w3c/css-houdini-drafts/wiki) at W3C, made up of engineers from major browser vendors has been hard at work over the last two years publishing [several draft specifications](https://drafts.css-houdini.org/) which are now in the final stages of design.

The [CSS Paint API](https://developers.google.com/web/updates/2018/01/paintapi) is among the first to reach browsers, landing in Chrome 65 back in January. It allows developers to paint an image using a context-like API that can be used wherever an image is called for in CSS. It uses the new [Worklet](https://drafts.css-houdini.org/worklets) interface, which are basically lightweight, high-performance [Worker](https://developer.mozilla.org/en-US/docs/Web/API/Worker)-like constructs intended for specialized tasks. Like Workers, they run in their own execution context, but unlike Workers, they are thread-agnostic (the browser chooses what thread they run on) and they have access to the rendering engine.

With a Paint Worklet, you could create a background image that automatically redraws when the element it’s contained in changes. Using CSS properties you can add parameters that trigger re-drawing when changed and can be controlled via Javascript. [All browsers](https://ishoudinireadyyet.com/) except Edge have pledged support, but for now, there’s a [polyfill](https://github.com/GoogleChromeLabs/css-paint-polyfill). With this API we will begin to see componentized images used in a similar way we now see components.

### Animations

Most modern web applications use animations as an essential part of the user experience. Frameworks like Google’s Material Design have made them essential parts of their [design language](https://material.io/design/motion/understanding-motion.html#principles), arguing that they are essential to making expressive and easy-to-understand user experiences. Given their elevated importance, there has been a push recently to bring a more powerful animations API to Javascript, and this has resulted in the Web Animations API (WAAPI).

As [CSS-Tricks notes](https://css-tricks.com/css-animations-vs-web-animations-api/), WAAPI offers a significantly better developer experience over just CSS animations, and you can easily log and manipulate the state of an animation defined in JS or CSS. [Browser support](https://caniuse.com/#feat=web-animation) at the moment is mostly limited to Chrome and Firefox, but there is an [official polyfill](https://github.com/web-animations/web-animations-js/tree/master) that does everything you need.

Performance has always been an issue with web animations, and this has been addressed by introducing the [Animation Worklet](https://wicg.github.io/animation-worklet/). This new API allows complex animations to run in parallel — meaning higher frame rate animations that aren’t impacted by main thread jank. Animation Worklets follow the same interface as the Web Animations API, but inside the Worklet execution context.

It’s [due to be released](https://www.chromestatus.com/features/5762982487261184) in Chrome 71 (the next version as of the time of writing), and other browsers likely sometime next year. There’s an official [polyfill and example repo](https://github.com/GoogleChromeLabs/houdini-samples/tree/master/animation-worklet) available on GitHub if you’d like to try it out today.

### Security

The Spectre timing attack wasn’t the only web security scare of the year. The inherent vulnerability of NPM has been [written about a lot in the past](https://hackernoon.com/im-harvesting-credit-card-numbers-and-passwords-from-your-site-here-s-how-9a8cb347c5b5), and last month we got an [alarming reminder](https://blog.logrocket.com/the-latest-npm-breach-or-is-it-a427617a4185). This was not a security breach of NPM itself, but a single package called [event-stream](https://www.npmjs.com/package/event-stream) that is used by many popular packages. NPM allows package authors to transfer ownership to any other member, and the hacker convinced the owner to transfer it to them. The hacker then published a new version with a new dependency on a package they created called [flatmap-stream](https://www.npmjs.com/package/flatmap-stream), which had code designed to steal [bitcoin wallets](https://copay.io/) if the malicious package was installed alongside the [copay-dash](https://www.npmjs.com/package/copay-dash) package.

These kinds of attacks will only become more common given how NPM works and the communities’ cavalier propensity to install random NPM packages that appear useful. The community places a great deal of trust on package owners, trust that has been questioned greatly. NPM users should aware of each package they are installing (dependencies of dependencies included), use a lock file to lock down versions and sign up for security alerts like those [provided by Github](https://blog.github.com/2017-11-16-introducing-security-alerts-on-github/).

NPM is [aware of the security concerns](https://blog.npmjs.org/post/172774747080/attitudes-to-security-in-the-javascript-community) of the community and they have taken steps to improve it over the last year. You can now secure your NPM account with [two-factor authentication](https://blog.npmjs.org/post/166039777883/protect-your-npm-account-with-two-factor), and NPM v6 now includes a [security audit](https://docs.npmjs.com/auditing-package-dependencies-for-security-vulnerabilities) command.

### Monitoring

The [Reporting API](https://developers.google.com/web/updates/2018/09/reportingapi) is a new standard that aims to make it easier for developers to discover problems with their applications by alerting when issues happen. If you’ve used the Chrome DevTools console within the last few years you might have seen the _\[intervention\]_ warning messages for using obsolete APIs or doing potentially unsafe things. These messages have been limited to the client, but now you can report them to analytics tools using the new [ReportingObserver](https://developers.google.com/web/updates/2018/07/reportingobserver).

There are two kinds of reports:

*   [Deprecations](https://developers.google.com/web/updates/tags/deprecations), which warn you when you’re using an obsolete API and tell you when it’s expected to be removed. It will also tell you filename and line number of where it was used.
*   [Interventions](https://www.chromestatus.com/features#intervention), which warn you when you’re using an API in an unintended, dangerous, or insecure way.

While tools like [LogRocket](https://logrocket.com/) give developers insight into errors in their applications. Until now, there hasn’t been any reliable way for third-party tools to record these warnings. This means issues either go unnoticed or manifest themselves as difficult-to-debug error messages. Chrome currently supports the ReportingObserver API, and other browsers will support it soon.

### CSS

Although Javascript gets all the attention, there have been several interesting new CSS features landing in browsers this year.

For those unaware, there is no unified CSS3 specification analogous to ECMAScript. The last official unified standard was CSS2.1, and CSS3 has come to refer to anything published after that. Instead, each section is standardized separately as a “CSS Module”. MDN has an [excellent overview](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS3) of each module standard and their status.

As of 2018, some newer features are now fully supported in all major browsers (this is 2018, IE is not a major browser). This includes [flexbox](https://blog.logrocket.com/flexing-with-css-flexbox-b7940b329a8a), [custom properties](https://caniuse.com/#feat=css-variables) (variables), and [grid layout](https://blog.logrocket.com/the-simpletons-guide-to-css-grid-1767565b3cf7).

While there has been [talk in the past](https://tabatkins.github.io/specs/css-nesting/) of adding support for nested rules to CSS (like LESS and SASS), those proposals didn’t go anywhere. In July the CSS working group at W3C [decided to take](https://github.com/w3c/csswg-drafts/issues/2701#issuecomment-402392212) another look at the proposal, but it’s unclear if it’s a priority at all.

### Node.js

Node continues to make excellent progress keeping up with ECMAScript standards and as of December, they [support all of ES2018](https://node.green/). On the other hand, they have been slow to adopt the ECMAScript module system and thus are missing a critical feature that is preventing feature parity with browsers, which have supported ES modules for over a year now. Node actually added [experimental support](https://nodejs.org/api/esm.html) in v11.4.0 behind a flag, but this requires that files use the new .mjs extension, leading to [concerns](https://github.com/nodejs/modules/issues/57) about slow adoption and what impact this would have on Node’s rich package ecosystem.

If you’re looking to get a jump start and you’d rather not use the experimental build-in support, there’s an interesting project from the creator of Lodash called [esm](https://medium.com/web-on-the-edge/tomorrows-es-modules-today-c53d29ac448c) which gives Node ES module support with better interoperability and performance than the official solution.

### Tools and Frameworks

#### React

[React](https://reactjs.org/) had two notable releases this year. React 16.3 shipped with support for a new set of [lifecycle methods](https://reactjs.org/blog/2018/03/29/react-v-16-3.html#component-lifecycle-changes) and a new official [Context API](https://reactjs.org/blog/2018/03/29/react-v-16-3.html#official-context-api). React 16.6 added a new feature called “Suspense” that gives React the ability to suspend rendering while components wait for a task to be completed like data fetching or [code splitting](https://reactjs.org/docs/code-splitting.html#reactlazy).

The most talked about React topic this year was the introduction of [React Hooks](https://reactjs.org/docs/hooks-intro.html). The proposal was designed to make it easier to write smaller components without sacrificing useful features that were until now limited to class components. React will ship with two built-in hooks, the State Hook, which lets functional components use state, and the [Effect Hook](https://reactjs.org/docs/hooks-effect.html#tip-use-multiple-effects-to-separate-concerns), which lets you perform side effects in function components. While there is no plan to remove classes from React, the React team clearly intends Hooks to be central to the future of React. After they were announced, there was a positive reaction from the community ([some might say overhyped](https://twitter.com/dan_abramov/status/1057027428827193344)). If you’re interested in learning more, check out [Dan Abramov’s blog post](https://medium.com/@dan_abramov/making-sense-of-react-hooks-fdbde8803889) comprehensive overview.

Next year React plans on releasing a new feature called [Concurrent mode](https://reactjs.org/blog/2018/11/27/react-16-roadmap.html#react-16x-q2-2019-the-one-with-concurrent-mode) (formerly known as “async mode” or “async rendering”). This would allow React to render large component trees without blocking the main thread. For large apps with deep component trees, the performance savings could be significant. It’s unclear exactly what the API looks like at the moment, but the React team is aiming to finalize it soon and release sometime next year. If you’re interested in adopting this feature, make sure your codebase is compatible by adopting the new lifecycle methods released in React 16.3.

React continues to grow in popularity, and [according to the State of JavaScript 2018 survey](https://2018.stateofjs.com/front-end-frameworks/react/) 64% of those polled use it and would use it again (+7.1% since last year), compared to [28% for Vue](https://2018.stateofjs.com/front-end-frameworks/vuejs/) (+9.2%) and [23% for Angular](https://2018.stateofjs.com/front-end-frameworks/angular/) (+5.1%).

#### Webpack

[Webpack](https://webpack.js.org) 4 was [released in February](https://github.com/webpack/webpack/releases/tag/v4.0.0-beta.0), bringing huge performance improvements, build-in production and development modes, easy to use optimizations like code splitting and minification, experimental WebAssembly support, and ECMAScript module support. Webpack is now much easier to use than previous versions and previously complicated features like code splitting and optimization are now quite simple to set up. Combined with Typescript or Babel, webpack remains the bedrock tool for web developers and it seems unlikely a competitor will come along and replace it in the near future.

#### Babel

[Babel](https://babeljs.io) 7 was [released this August](https://babeljs.io/blog/2018/08/27/7.0.0), the first major release in almost three years. Major changes include [faster build times](https://twitter.com/left_pad/status/927554660508028929), a new package namespace, and deprecation of the various “stage” and yearly ECMASCript preset packages in favor of [preset-env](https://babeljs.io/docs/en/next/babel-preset-env.html), which vastly simplifies configuring Babel by automatically including the plugins you need for the browsers you support. This release also adds [automatic polyfilling](https://babeljs.io/blog/2018/08/27/7.0.0#automatic-polyfilling-experimental), which removes the need to either import the entire Babel polyfill (which is rather large) or explicitly importing the polyfills you need (which can be time-consuming and error-prone).

Babel also now [supports the Typescript syntax](https://blogs.msdn.microsoft.com/typescript/2018/08/27/typescript-and-babel-7/), making it easier for developers to use Babel and Typescript together. Babel 7.1 also added support for the new [decorators proposal](https://babeljs.io/blog/2018/09/17/decorators), which is incompatible with the obsolete proposal widely adopted by the community but matches what browsers will be supporting. Thankfully, the Babel team has published a [compatibility package](https://babeljs.io/blog/2018/09/17/decorators#upgrading) that will make upgrading easier.

#### Electron

[Electron](https://electronjs.org/) continues to be the most popular way to package Javascript applications for the desktop, although whether or not that’s a good thing is somewhat of a controversy. Some of the most popular desktop applications now use Electron to reduce development costs by making it easy to develop cross-platform applications.

A [common complaint](https://www.theverge.com/circuitbreaker/2018/5/16/17361696/chrome-os-electron-desktop-applications-apple-microsoft-google) is that applications that use Electron tend to use too much memory since each app packages an entire instance of Chrome (which is very memory-intensive). [Carlo](https://github.com/GoogleChromeLabs/carlo) is an Electron alternative from Google that uses the locally installed version of Chrome (which it requires), resulting in a less memory hungry application. Electron itself hasn’t made much progress with improving performance, and [recent updates](https://electronjs.org/blog/electron-3-0) have focused on updating the Chrome dependency and small API changes.

#### Typescript

[Typescript](https://www.typescriptlang.org/) has greatly increased in popularity over the last year, emerging as a genuine challenger to ES6 as the dominant flavor of JavaScript. Since Microsoft releases new versions monthly, development has progressed pretty rapidly over the last year. The Typescript team has put a strong focus on developer experience, for both the language itself and the editor tools that surround it.

Recent releases have added more developer-friendly [error formatting](https://blogs.msdn.microsoft.com/typescript/2018/07/30/announcing-typescript-3-0/#improved-errors-and-ux) and powerful refactoring features like [automatic import updating](https://blogs.msdn.microsoft.com/typescript/2018/05/31/announcing-typescript-2-9/#rename-move-file) and [import organizing](https://blogs.msdn.microsoft.com/typescript/2018/03/27/announcing-typescript-2-8/#organize-imports), among others. At the same time, work continues on improving the type system with recent features like [conditional types](https://blogs.msdn.microsoft.com/typescript/2018/03/27/announcing-typescript-2-8/#conditional-types) and [unknown type](https://blogs.msdn.microsoft.com/typescript/2018/07/30/announcing-typescript-3-0/#the-unknown-type).

The State of JavaScript Survey 2018 notes that [nearly half of respondents](https://2018.stateofjs.com/javascript-flavors/typescript/) use TypeScript, with a strong upward trend over the last two years. In contrast, it’s chief competitor Flow has [stagnated](https://2018.stateofjs.com/javascript-flavors/flow/) in popularity, with most developers saying they dislike its lack of tooling and popular momentum. Typescript is admired for making it easy for developers to write robust and elegant code backed up by powerful editor support. It’s sponsor, Microsoft, seems to be more willing to support it than Facebook is with Flow, and developers have clearly noticed.

* * *

### Plug: [LogRocket](https://logrocket.com/signup/), a DVR for web apps

[![](https://cdn-images-1.medium.com/max/1000/1*s_rMyo6NbrAsP-XtvBaXFg.png)](https://logrocket.com/signup/)

[LogRocket](https://logrocket.com/signup/) is a frontend logging tool that lets you replay problems as if they happened in your own browser. Instead of guessing why errors happen, or asking users for screenshots and log dumps, LogRocket lets you replay the session to quickly understand what went wrong. It works perfectly with any app, regardless of framework, and has plugins to log additional context from Redux, Vuex, and @ngrx/store.

In addition to logging Redux actions and state, LogRocket records console logs, JavaScript errors, stacktraces, network requests/responses with headers + bodies, browser metadata, and custom logs. It also instruments the DOM to record the HTML and CSS on the page, recreating pixel-perfect videos of even the most complex single page apps.

[Try it for free.](https://logrocket.com/signup/)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
