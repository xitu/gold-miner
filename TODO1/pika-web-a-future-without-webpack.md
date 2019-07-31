> * 原文地址：[A Future Without Webpack](https://www.pika.dev/blog/pika-web-a-future-without-webpack/)
> * 原文作者：[FredKSchott](https://twitter.com/FredKSchott)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/pika-web-a-future-without-webpack.md](https://github.com/xitu/gold-miner/blob/master/TODO1/pika-web-a-future-without-webpack.md)
> * 译者：
> * 校对者：

# A Future Without Webpack

> @pika/web installs npm packages that run natively in the browser. Do you still need a bundler?

![](https://www.pika.dev/static/img/bundling-cover.jpg)

The year is 1941. Your name is Richard Hubbell. You work at an experimental New York television studio owned by CBS. You are about to give one of the world’s first major TV news broadcasts, and you have 15 minutes to fill. What do you do?

In a world that has only known radio, you stick to what you know. That is, you read the news. [“Most of the \[televised\] newscasts featured Hubbell reading a script with only occasional cutaways to a map or still photograph.”](https://books.google.com/books?id=yWrEDQAAQBAJ&lpg=PA132&ots=WBn6zP9HAW&dq=newscasts%20featured%20Hubbell%20reading%20a%20script%20with%20only%20occasional%20cutaways&pg=PA132#v=onepage&q=newscasts%20featured%20Hubbell%20reading%20a%20script%20with%20only%20occasional%20cutaways&f=false) It would be a while before anyone would show actual video clips on the TV news.

As a JavaScript developer in 2019, I can relate. We have this new JavaScript module system [(ESM)](https://flaviocopes.com/es-modules/) that runs natively on the web. Yet we continue to use bundlers for every single thing that we build. Why?

Over the last several years, JavaScript bundling has morphed from a production-only optimization into a required build step for most web applications. Whether you love this or hate it, it’s hard to deny that bundlers have added a ton of new complexity to web development – a field of development that has always taken pride in its view-source, easy-to-get-started ethos.

##### @pika/web is an attempt to free web development from the bundler requirement. In 2019, you should use a bundler because you want to, not because you need to.

<img height="310" width="50%" src="https://www.pika.dev/static/img/bundling-webpack-graph.jpeg"/><img height="310" width="50%" src="https://www.pika.dev/static/img/bundling-crazy-charlie.jpeg"/>

**Credit: [@stylishandy](https://twitter.com/stylishandy/status/1105049564237754373)**

### Why We Bundle

JavaScript bundling is a modern take on an old concept. Back in the day (lol ~6 years ago) it was common to minify and concatenate JavaScript files together in production. This would speed up your site and get around [HTTP/1.1’s 2+ parallel request bottleneck](https://stackoverflow.com/a/985704).

How did this nice-to-have optimization become an absolute dev requirement? Well, that’s the craziest part: Most web developers never specifically asked for bundling. Instead, we got bundling as a side-effect of something else, something that we wanted realllllllly badly: **npm.**

[npm](https://npmjs.com) – which at the time stood for “Node.js Package Manager” – was on its way to becoming the largest code registry ever created. Frontend developers wanted in on the action. The only problem was that its Node.js-flavored module system (Common.js or CJS) wouldn’t run on the web without bundling. So Browserify, [Webpack](https://webpack.js.org), and the modern web bundler were all born.

![a visualization of Create React App showing a ton of different dependencies](https://www.pika.dev/static/img/bundling-cra-graph-2.jpg)

**[Create React App visualized:](https://npm.anvaka.com/#/view/2d/react-scripts) 1,300 dependencies to run "Hello World"**

### Complexity Stockholm Syndrome

Today, it’s nearly impossible to build for the web without using a bundler like [Webpack](https://webpack.js.org). Hopefully, you use something like [Create React App (CRA)](https://facebook.github.io/create-react-app/) to get started quickly, but even this will install a complex, 200.9MB `node_modules/` directory of 1,300+ different dependencies just to run ”Hello World!”

Like Richard Hubbell, we are all so steeped in this world of bundlers that it’s easy to miss how things could be different. We have these great, modern ESM dependencies now [(almost 50,000 on npm!)](https://www.pika.dev/about/stats). What’s stopping us from running them directly on the web?

Well, a few things. 😕 It’s easy enough to write web-native ESM code yourself, and it is true that some npm packages without dependencies can run directly on the web. Unfortunately, most will still fail to run. This can be due to either legacy dependencies of the package itself or the special way in which npm packages import dependencies by name.

This is why [@pika/web](https://github.com/pikapkg/web) was created.

### @pika/web: Web Apps Without the Bundler

[@pika/web](https://github.com/pikapkg/web) installs modern npm dependencies in a way that lets them run natively in the browser, even if they have dependencies themselves. That’s it. It’s not a build tool and it’s not a bundler (in the traditional sense, anyway). @pika/web is a dependency install-time tool that lets you dramatically reduce the need for other tooling and even skip [Webpack](https://webpack.js.org) or [Parcel](https://parceljs.org/) entirely.

```bash
npm install && npx @pika/web
✔ @pika/web installed web-native dependencies. [0.41s]
```

@pika/web checks your `package.json` manifest for any `"dependencies"` that export a valid ESM “module” entry point, and then installs them to a local `web_modules/` directory. @pika/web works on any ESM package, even ones with ESM & Common.js internal dependencies.

Installed packages run in the browser because @pika/web bundles each package into a single, web-ready ESM `.js` file. For example: The entire “preact” package is installed to `web_modules/preact.js`. This takes care of anything bad that the package may be doing internally, while preserving the original package interface.

**“Ah ha!”** you might say. **[“That just hides bundling in a different place!”](https://twitter.com/TheLarkInn/status/1102462419366891522)**

**Exactly!** @pika/web leverages bundling internally to output web-native npm dependencies, which was the main reason that many of us started using bundlers in the first place!

With @pika/web all the complexity of the bundler is internalized in a single install-time tool. You never need to touch another line of bundler configuration if you don’t want to. But of course, you can continue to use whatever other tools you like: Beef up your dev experience ([Babel](https://babeljs.io/), [TypeScript](https://www.typescriptlang.org)) or optimize how you ship in production ([Webpack](https://webpack.js.org), [Rollup](https://rollupjs.org/)).

**This is the entire point of @pika/web: Bundle because you want to, not because you need to.**

![a view-source screenshot](https://www.pika.dev/static/img/bundling-view-source.png)

**PS: Oh yea, and [view source is back!](https://www.pika.dev/js/PackageList.js)**

### Performance

Installing each dependency this way (as a single JS file) gets you one big performance boost over most bundler setups: dependency caching. When you bundle all of your dependencies together into a single large `vendor.js` file, updating one dependency can force your users to re-download the entire bundle. Instead, with @pika/web, updating a single package won’t bust the rest of the user’s cache.

@pika/web saves you from this entire class of performance footguns introduced by bundlers. [Duplicated code across bundles](https://formidable.com/blog/2018/finding-webpack-duplicates-with-inspectpack-plugin/), [slow first page load due to unused/unrelated code](https://medium.com/webpack/better-tree-shaking-with-deep-scope-analysis-a0b788c0ce77), [gotchas and bugs across upgrades to Webpack’s ecosystem](https://medium.com/@allanbaptista/the-problem-with-webpack-8a025268a761)… Entire articles and tools are devoted to solving these issues.

To be clear, leaving your application source unbundled isn’t all sunshine and roses, either. Large JavaScript files do compress better over the wire than smaller, more granular files. And while multiple smaller files load just as well over [HTTP/2](https://developers.google.com/web/fundamentals/performance/http2/#request_and_response_multiplexing), the browser loses time parsing before then making follow-up requests for imports.

It all comes down to a tradeoff between performance, caching efficiency, and how much complexity you feel comfortable with. And again, this is the entire point of @pika/web: Add a bundler because it makes sense to your situation, not because you have no other choice.

![a bunch of legos](https://www.pika.dev/static/img/bundling-legos.jpg)

### The Pika Web App Strategy

@pika/web has completely changed our approach to web development. Here is the process we used to build [pika.dev](https://www.pika.dev/), and how we recommend you build your next web application in 2019:

1. For new projects, skip the bundler. Write you application using modern ESM syntax and use @pika/web to install npm dependencies that runs natively on the web. No tooling required.
2. Add tooling as you go. Add [TypeScript](https://www.typescriptlang.org) if you want a type system, add [Babel](https://babeljs.io/) if you want to use experimental JavaScript features, and add [Terser](https://github.com/terser-js/terser) if you want JS minification. After 6+ months, [pika.dev](https://www.pika.dev/) is still happily at this phase.
3. When you feel the need & have the time, experiment by adding a simple bundler for your application source code. Performance test it. Is it faster on first page load? Second page load? If so, ship it!
4. Keep optimizing your bundler config as your application grows.
5. When you have enough money, hire a Webpack expert. Congratulations! If you have the resources to hire a Webpack expert you have officially made it.

### Examples? We Got ‘em

* A simple project: [\[Source\]](https://glitch.com/edit/#!/pika-web-example-simple) [\[Live Demo\]](https://pika-web-example-simple.glitch.me/)
* A Preact + HTM project: [\[Source\]](https://glitch.com/edit/#!/pika-web-example-preact-htm) [\[Live Demo\]](https://pika-web-example-preact-htm.glitch.me)
* Electron, Three.js… [See our full list of examples →](https://github.com/pikapkg/web/blob/master/EXAMPLES.md)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
