> * 原文地址：[How to JavaScript in 2018](https://www.telerik.com/blogs/how-to-javascript-in-2018)
> * 原文作者：[Tara Z. Manicsic](https://www.telerik.com/blogs/author/tara-manicsic)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/how-to-javascript-in-2018.md](https://github.com/xitu/gold-miner/blob/master/TODO/how-to-javascript-in-2018.md)
> * 译者：
> * 校对者：

# How to JavaScript in 2018

![](https://d585tldpucybw.cloudfront.net/sfimages/default-source/default-album/js_870x220_2.png?sfvrsn=2cce35f7_1)

**From command-line tools and webpack to TypeScript, Flow and beyond, let's talk about how to use JavaScript in 2018.**

Last year many people, including myself, were [talking about JavaScript fatigue](https://developer.telerik.com/topics/web-development/javascripts-journey-2016/). No, the ways to write a JavaScript application have not really slimmed down, BUT with a lot of command-line tools doing much of the heavy lifting, transpiling becoming less crucial and TypeScript trying to minimize type errors, we can relax a little.

Note: This blog post is part of our whitepaper, "[The Future of JavaScript: 2018 and Beyond](https://www.telerik.com/campaigns/kendo-ui/wp-javascript-future-2018)", which offers our future-looking analysis and predictions about the latest in JavaScript.

## Command-line Tools

Most libraries and frameworks have a [command-line tool](https://www.telerik.com/campaigns/aspnet-mvc/net-cli-reinvented) that, with one command, will spin up skeleton projects for us to quickly create whatever our little hearts desire. This will often include a start script (sometimes with an auto re-loader), build scripts, testing structures and more. These tools are relieving us of a lot of redundant file making when we create new projects. Let's look at few more things some command line tools are taking off our plates.

### Webpack Configurations

Configuring your webpack build process and really understanding what you were doing, was probably one of the more daunting learning curves of 2017. Thankfully, they had one of their core contributors, [Sean Larkin](https://twitter.com/thelarkinn), running around the world supplying us with [great talks](https://www.youtube.com/watch?v=4tQiJaFzuJ8&t=3526s) and [really fun and helpful tutorials](https://www.twitch.tv/videos/209664650?t=1h57m40s).

Many frameworks nowadays not only create the webpack config files for you, but even populate them to the point that you may not even have to LOOK at it 😮. [Vue's CLI tool](https://github.com/vuejs/vue-cli) even has a [webpack-specific template](https://github.com/vuejs-templates/webpack) giving you a full-featured Webpack setup. Just to give you the full idea of what command line tools are providing, here’s what this Vue CLI template includes, straight from the repo:

*   `npm run dev`: first-in-class development experience
    *   Webpack + `vue-loader` for single file Vue components
    *   State preserving hot-reload
    *   State preserving compilation error overlay
    *   Lint-on-save with ESLint
    *   Source maps
*   `npm run build`: Production ready build
    *   JavaScript minified with [UglifyJS v3](https://github.com/mishoo/UglifyJS2/tree/harmony)
    *   HTML minified with< [html-minifier](https://github.com/kangax/html-minifier)
    *   CSS across all components extracted into a single file and minified with [cssnano](https://github.com/ben-eb/cssnano)
    *   Static assets compiled with version hashes for efficient long-term caching, and an auto-generated production index.html with proper URLs to these generated assets
    *   Use `npm run build --report` to build with bundle size analytics
*   `npm run unit`: Unit tests run in [JSDOM](https://github.com/tmpvar/jsdom) with [Jest](https://facebook.github.io/jest/), or in PhantomJS with Karma + Mocha + karma-webpack
    *   Supports ES2015+ in test files
    *   Easy mocking
*   `npm run e2e`: End-to-end tests with [Nightwatch](http://nightwatchjs.org/)
    *   Run tests in multiple browsers in parallel
    *   Works with one command out of the box:
        *   Selenium and chromedriver dependencies automatically handled
        *   Automatically spawns the Selenium server

The [preact-cli](https://github.com/developit/preact-cli#webpack), on the other hand, takes care of the standard webpack functionality. Then if you need to customize your webpack configurations you just create a `preact.config.js` file which exports a function that makes your webpack changes. So many tools, so much help; developers helping developers 💞.

## Babel On or Off

Get it? Sounds like Babylon 😂. I crack myself up. I'm not _exactly_ tying Babel to the ancient city of Babylon, but there has been [talk](https://medium.freecodecamp.org/you-might-not-need-to-transpile-your-javascript-4d5e0a438ca) of possibly removing our reliance on transpiling. Babel has been a big deal for the past few years because we wanted all the shiny that ECMAScript was proposing but didn't want to wait for the browsers to catch up. With ECMAScript moving to yearly small releases browsers may be able to keep up. What is a JavaScript post without some of the awesome [kangax compatibility](https://twitter.com/kangax?lang=en) charts.

These images of these charts aren't legible because I wanted to showcase just how green they are! For full detail click the links below the images to inspect the charts further.

[![look at all that green](//d585tldpucybw.cloudfront.net/sfimages/default-source/blogs/2018/2018-02/compatibility-es6.png?sfvrsn=81c1b8d1_1 "look at all that green")](//d585tldpucybw.cloudfront.net/sfimages/default-source/blogs/2018/2018-02/compatibility-es6.png?sfvrsn=81c1b8d1_1)

[Compatibility for es6](http://kangax.github.io/compat-table/es6/)

[![still looking green](//d585tldpucybw.cloudfront.net/sfimages/default-source/blogs/2018/2018-02/compatibility-2016.png?sfvrsn=43f89061_1 "still looking green")](//d585tldpucybw.cloudfront.net/sfimages/default-source/blogs/2018/2018-02/compatibility-2016.png?sfvrsn=43f89061_1)

[Compatibility for 2016+](http://kangax.github.io/compat-table/es2016plus/)

In the first graph those red chunks on the left are compilers (e.g. es-6 shim, Closure, etc.) and older browsers (i.e. Kong 4.14 and IE 11). Then the five mostly red columns on the right are the server/compilers PJS, JXA, Node 4, DUK 1.8 and DUK 2.2. On the lower graph that red section that kind of looks like a bad drawing of a dog looking at a messed up exclamation point are servers/runtimes with only Node 6.5+ having green streaks. The makeup of the left red square are the compilers/polyfils and IE 11. More importantly, LOOK AT ALL THAT GREEN! In the most popular browsers, we have practically all green. The only red mark for 2017 features is on Firefox 52 ESR for Shared Memory and Atomics.

To put some of this into perspective here are some browser usage percentages from [Wikipedia](https://en.wikipedia.org/wiki/Usage_share_of_web_browsers).

[![browser user statistics](//d585tldpucybw.cloudfront.net/sfimages/default-source/blogs/2018/2018-02/browser-user-statistics.png?sfvrsn=896a6611_1 "browser user statistics")](//d585tldpucybw.cloudfront.net/sfimages/default-source/blogs/2018/2018-02/browser-user-statistics.png?sfvrsn=896a6611_1)

Okay, turning off Babel may be a long ways aways because when it comes down to it we want to make a concerted effort to be accessible to as many users as we can. It is interesting to consider that we may be able to get rid of that extra step. You know, like before, when we didn't use transpilers 😆.

## TypeScript Talk

If we're talking about how to JavaScript we must talk about [TypeScript](https://www.typescriptlang.org/). TypeScript came out of the Microsoft office five years ago but has become the cool kid in town 😎 in 2017. There was rarely a conference that didn't have a "Why We Love TypeScript" talk; it's like the new dev heartthrob. Without writing a sonnet to TypeScript, let's talk a bit about why developers are crushing hard.

For everyone who wanted types in JavaScript, TypeScript is here to offer a strict syntactical superset of JavaScript which gives optional static typing. Pretty cool, if you're into that kind of thing. Of course, if you take a look at the newest results from the [State of JavaScript](https://stateofjs.com/2017/introduction/) survey, it seems that a lot of people ARE, in fact, into that kind of thing.

[![JS Flavors Comparison](//d585tldpucybw.cloudfront.net/sfimages/default-source/blogs/2018/2018-02/js-flavors-comparison.png?sfvrsn=14077aa8_1 "JS Flavors Comparison")](//d585tldpucybw.cloudfront.net/sfimages/default-source/blogs/2018/2018-02/js-flavors-comparison.png?sfvrsn=14077aa8_1)

From [State of JavaScript](https://stateofjs.com/2017/introduction/).

To hear it straight from the source, check out this quote from Brian Terlson:

> Speaking as someone who proposed types for JavaScript in 2014: I do not believe types are in the cards for the near future. This is an extremely complex problem to get right from a standards perspective. Just adopting TypeScript as the standard would of course be great for TypeScript users, but there are other typed JS supersets with pretty significant usage including closure compiler and flow. These tools all behave differently and it’s not even clear that there’s a common subset to work from (I don’t think there is in any appreciable sense). I’m not entirely sure what a standard for types looks like, and I and others will continue to investigate this as it could be very beneficial, but don’t expect anything near term - [HashNode AMA with Brian Terlson](https://hashnode.com/ama/with-brian-terlson-cj6vu9vjv01nmo1wu8vmtt1x9#cj6vuspfq01oso1wuhjo5zvd6)

### TypeScript ❤s Flow

In 2017, you have probably seen many [blog posts](http://thejameskyle.com/adopting-flow-and-typescript.html) discussing the TypeScript + Flow combo. [Flow](https://flow.org/) is a static type checker for JavaScript. Flow, as you can see in the State of JavaScript survey chart list above, has about as many people interested as they do uninterested. More interesting is the stats showing how many of the people surveyed haven't heard of Flow, yet ⏰. As people learn more about Flow in 2018 maybe they will find it as beneficial as [Minko Gechev](https://twitter.com/mgechev/status/940131449025347589) does:

> TypeScript & Flow eliminate ~15% of your production bugs! Still think type systems are not useful? [https://t.co/koG7dFCSgF](https://t.co/koG7dFCSgF)
> 
> — Minko Gechev (@mgechev) [December 11, 2017](https://twitter.com/mgechev/status/940131449025347589?ref_src=twsrc%5Etfw)

### Angular ❤s TypeScript

One may notice that all the code samples in Angular documentation are written in TypeScript. At one point, there was an option that you could choose to walk through the tutorial in JavaScript or TypeScript, but it seems Angular's heart has been swayed. Looking at the chart below connecting Angular to JS flavors we can see that there are actually a tiny bit more users connecting Angular to ES6 (TypeScript: 3777, ES6: 3997). We'll see if all of this affects Angular in 2018.

[![angular connections](//d585tldpucybw.cloudfront.net/sfimages/default-source/blogs/2018/2018-02/angular-connections.png?sfvrsn=192c96f4_1 "angular connections")](//d585tldpucybw.cloudfront.net/sfimages/default-source/blogs/2018/2018-02/angular-connections.png?sfvrsn=192c96f4_1)

From [State of JavaScript](https://stateofjs.com/2017/introduction/).

For expert advice on how to choose the right JavaScript framework for your next application, check out [this great whitepaper](https://www.telerik.com/campaigns/kendo-ui/wp-javascript-future-2018).

Undoubtedly, the way we JavaScript will evolve in 2018. As programmers we like to make and use tools that make our lives easier. Unfortunately, that can sometimes lead to more chaos and too many choices. Thankfully, command line tools are relieving us of some grunt work and TypeScript has satiated the type-hungry who were sick of type errors.

### The Future of JavaScript

Curious to dive deeper into our take on where JavaScript is headed? Check out our new paper, The Future of JavaScript in 2018 and Beyond.


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
