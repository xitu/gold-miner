> * 原文地址：[Enabling Modern JavaScript on npm](https://jasonformat.com/enabling-modern-js-on-npm/)
> * 原文作者：[Jason Miller](https://jasonformat.com/author/developit/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/enabling-modern-js-on-npm.md](https://github.com/xitu/gold-miner/blob/master/TODO1/enabling-modern-js-on-npm.md)
> * 译者：
> * 校对者：

# Enabling Modern JavaScript on npm

> Modern JavaScript syntax lets you do more with less code, but how much of the JavaScript we ship to users is actually modern?

![](https://res.cloudinary.com/wedding-website/image/upload/v1559234852/code-screenshot_1_zkday3.jpg)

For the past few years we’ve been writing modern JavaScript (or [TypeScript](https://www.typescriptlang.org/)), which is then transpiled to ES5 as a build step. This has let the “state of the art” of JavaScript move forward at a faster pace than could have otherwise been achieved while supporting older browsers.

More recently, developers have adopted differential bundling techniques where two or more distinct sets of JavaScript files are produced to target different environments. The most common example of this is the [module/nomodule pattern](https://philipwalton.com/articles/deploying-es2015-code-in-production-today/), which leverages native JS Modules (also known as "ES Modules") support as its “cutting the mustard” test: modules-supporting browsers request modern JavaScript (~[ES2017](https://www.ecma-international.org/ecma-262/8.0/index.html)), and older browsers request the more heavily polyfilled and transpiled legacy bundles. Compiling for the set of browsers defined by their JS Modules support is made relatively straightforward courtesy of the [targets.esmodules](https://babeljs.io/docs/en/babel-preset-env#targetsesmodules) option in [@babel/preset-env](https://babeljs.io/docs/en/babel-preset-env), and [Webpack](https://webpack.js.org/) plugins like [babel-esm-plugin](https://github.com/prateekbh/babel-esm-plugin#readme) make producing two sets of JavaScript bundles mostly painless.

Given the above, where are all the blog posts and case-studies showing the glorious performance and bundle size benefits that have been achieved using this technique? It turns out, shipping modern JavaScript requires more than changing our build targets.

## It’s not our code

Current solutions for producing paired modern & legacy bundles focus solely on “authored code” - the code we write that implements an application. These solutions can’t currently help with the code we install from sources like npm - that’s a problem, since [some sources](https://youtu.be/-xZHWK-vHbQ?t=2064) place the ratio of installed code to authored code is somewhere in the ballpark of 10:1. While this ratio will clearly be different for every project, we've consistently found that the JavaScript shipped to users contains a high amount of installed code. Even walking this estimate back, there are clear indications that the ecosystem favors installing existing modules over authoring new one-off modules.

![](https://res.cloudinary.com/wedding-website/image/upload/v1559231502/authored_vs_installed_ev2szc.png)

In many ways this represents a triumph for Open Source: developers are able to build on the communal value of shared code and collaborate on generalized solutions to their problems in a public forum.

“the dependencies we install from npm are stuck in 2014”

As it turns out, this amazing ecosystem also holds the most important missing piece of our modern JavaScript puzzle: **the dependencies we install from npm are stuck in 2014.**

> “the dependencies we install from npm are stuck in 2014”

## “Just JavaScript”

The modules we publish to npm are “JavaScript”, but that’s where any expectation of uniformity ends. Front-end developers consuming JavaScript from npm near universally expect that JavaScript to run “in a browser”. Given the diverse set of browsers we need to support, we end up in a situation where modules need to support the Lowest Common Denominator from their consumers’ browser support targets. The eventuality that played out means we have come to explicitly depend on all code in `node_modules` being ECMAScript 5. In some very rare cases, developers use bolted-on solutions to detect non-ES5 modules and preprocess them down to their desired output target (here’s [a hacky approach](https://gist.github.com/developit/081148d83348ebe9a1bc1ba0707e1bb8) you shouldn’t use). As a community, the backwards compatibility of each new ECMAScript version has allowed us to largely ignore the effect this has had on our applications, despite an ever-widening gap between the syntax we write and the syntax found in most of our favorite npm dependencies.

This has led to a general acceptance that npm modules should be transpiled before they are published to the registry. The publishing process for authors generally involves bundling source modules to multiple formats: JS Modules, CommonJS and UMD. Module authors sometimes denote these different bundles using a set of unofficial fields in a module’s package.json, where `"module"` points to an `.mjs` file, `"unpkg"` points to the UMD bundle, and `"main"` is still left to reference a CommonJS file.

```json
{
  "main": "dist/es5-commonjs.js",
  "module": "dist/es5-modules.mjs",
  "unpkg": "dist/es5-umd.js"
}
```

All of these formats affect only a module’s interface - its imports and exports - and this lead to an unfortunate consensus among developers and tooling that even modern JS Modules should be transpiled to a library’s lowest support target. It has been suggested that package authors could begin allowing modern JavaScript syntax in the entry module denoted in their package.json via the `module` field. Unfortunately, this approach is incompatible with today’s tooling - more specifically, it’s incompatible with the way we’ve all configured our tooling. These configurations are different for every project, which makes this a massive undertaking since the tools themselves are not what needs to be changed. Instead, the changes would need to be made in each and every application’s build configuration.

The reason these constraints hold firm is in large part due to popular bundlers like Webpack and Rollup shipping without a default behavior for whether JavaScript imported from `node_modules` should be processed. These tools can be easily configured to treat `node_modules` the same as authored code, but their documentation [consistently recommends](https://webpack.js.org/loaders/babel-loader/#usage) developers [disable Babel transpilation](https://github.com/rollup/rollup-plugin-babel#usage) for `node_modules`. This recommendation is generally given citing build performance improvements, even though the slower build produces better results for end users. This makes any in-place changes to the semantics of importing code from `node_modules` exceptionally difficult to propagate through the ecosystem, since the tools don’t actually control what gets transpiled and how. This control rests in the hands of application developers, which means the problem is decentralized.

## The module author’s perspective

The authors of our favorite npm modules are also involved. At present, there are five main reasons why module authors end up being forced to transpile their JavaScript before publishing it to npm:

1. We know app developers aren’t transpiling `node_modules` to match their support targets.
2. We can’t rely on app developers to set up sufficient minification and optimization.
3. Library size must be measured in bundled+minified+gzipped bytes to be realistic.
4. There is still a widespread expectation that npm modules are delivered as ECMAScript 5.
5. Increasing a module’s JS version requirement means the code is unavailable to some users.

When combined, these reasons make it virtually impossible for the author of a popular module to move to modern JavaScript by default. Put yourself in the shoes of a module author: would you be willing to publish only modern syntax, knowing the resulting update would break builds or production deploys for the majority of your users?

The npm ecosystem’s current state and inability to bifurcate classic vs modern JavaScript publishing is what holds us back from collectively embracing JS Modules and ES20xx.

### Module authoring tools hurt, too

Just like with application bundlers being configurable without an implied default behaviour for `node_modules`, changing the module authoring landscape is an unfortunately distributed problem. Since most module authors tend to roll their own build tooling as requirements vary from project to project, there isn’t really a set of canonical tools to which changes could be made. [Microbundle](https://github.com/developit/microbundle) has been gaining traction as a shared solution, and [@pika/pack](https://www.pikapkg.com/blog/introducing-pika-pack/) recently launched with similar goals to optimize the format in which modules are published to npm. Unfortunately, these tools still have a long way to go before being considered widespread.

Assuming a group of solutions like Microbundle, Pika and Angular’s [library bundler](https://angular.io/cli/generate#library) could be influenced, it may be possible to shift the ecosystem using popular modules as an example. An effort on this scale would be likely to encounter some resistance from module consumers, since many are not yet aware of the limitations their bundling strategies impose. However, these upended expectations are the very shift our community needs.

## Looking Forward

It’s not all doom and gloom. While Webpack and Rollup encourage unprocessed npm module usage only through their documentation, Browserify actually [disables all transforms](https://github.com/babel/babelify#why-arent-files-in-node_modules-being-transformed) within `node_modules` by default. That means Browserify could be modified to produce modern/legacy bundles automatically, without requiring every single application developer to change their build configuration. Similarly, opinionated tools built atop Webpack and Rollup provide a few centralized places where we could make changes that bring modern JS to `node_modules`. If we made these changes within [Next.js](https://nextjs.org/), [Create React App](https://facebook.github.io/create-react-app/docs/getting-started), [Angular CLI](https://cli.angular.io/), [Vue CLI](https://cli.vuejs.org/) and [Preact CLI](https://github.com/developit/preact-cli), the resulting build configurations would eventually make their way out to a decent fraction of applications using those tools.

Looking to the vast majority of build systems for JavaScript applications that are one-off or customized per-project, there is no central place to modify them. One option we could consider as a way to slowly move the community to Modern JS-friendly configurations would be to modify Webpack to show warnings when JavaScript resources imported from `node_modules` are left unprocessed. Babel [announced some new features](https://babeljs.io/blog/2018/06/26/on-consuming-and-publishing-es2015+-packages) last year that allow selective transpiling of `node_modules`, and Create React App recently started transpiling `node_modules` using a conservative configuration. Similarly, tools could be created for inspecting our bundled JavaScript to see how much of it is shipped as over-polyfilled or inefficient legacy syntax.

## The last piece

Let’s assume we could build automation and guidance into our tools, and that doing so would eventually move the thousands (millions?) of applications using those tools over to configurations that allow modern syntax to be used within `node_modules`. In order for this to have any effect, we need to come up with a consistent way for package authors to specify the location of their modern JS source, and also get consensus on what “modern” means in that context. For a package published 3 years ago, “modern” could have meant ES2015. For a package published today, would “modern” include [class fields](https://developers.google.com/web/updates/2018/12/class-fields), [BigInt](https://developers.google.com/web/updates/2018/05/bigint) or [Dynamic Import](https://developers.google.com/web/updates/2017/11/dynamic-import)? It’s hard to say, since browser support and specification stage vary.

This comes to a head when we consider the effect on differential bundling. For those not familiar, Differential Bundling refers to a setup that lets us write modern JavaScript, then build separate sets of output bundles targeting different environments. In the most popular usage, we have a set of bundles targeting newer browsers that contains ~ES2015 syntax, and then a “legacy” set of bundles for all other browsers that is transpiled down to ES5 and polyfilled.

![Diagram showing multiple JavaScript source files being bundled into separate sets of JavaScript files: one for modern browsers, and another for all other browsers.](https://res.cloudinary.com/wedding-website/image/upload/v1559231328/modern_legacy_transpile_qbvkdd.png)

The problem is that, if we assume “modern” to mean “anything newer than ES5”, it becomes impossible to determine what syntax a package contains that needs to be transpiled in order to meet a given browser support target. We can address this problem by establishing a way for packages to express the specific set of syntax features they rely on, however this still requires maintaining many variant configurations to handle each set of input→output syntax pairs:

| Package Syntax     | Output Target          | Example “Downleveling” Transformations                          |
| ------------------ | ---------------------- | --------------------------------------------------------------- |
| ES5	               | ES5/nomodule           | none                                                            |
| ES5	               | `<script type=module>` | none                                                            |
| ES2015(classes)    | ES5 / nomodule         | classes & tagged templates                                      |
| ES2015(classes)    | `<script type=module>` | none                                                            |
| ES2017(async/await)| ES5 / nomodule         | async/await, classes & tagged templates                         |
| ES2017(async/await)| `<script type=module>` | none                                                            |
| ES2019             | ES5 / nomodule         | rest/spread, for-await, async/await, classes & tagged templates |
| ES2019             | `<script type=module>` | rest/spread & for-await                                         |

## What would you do?

Over-transpiled JavaScript is an increasing fraction of the code we ship to end users, impacting initial load time and overall runtime performance of the web. We believe this is a problem needing a solution – a solution module authors **and** consumers can agree upon. The problem space is relatively small, but there are many interested parties with unique constraints.

We’re looking to the community for help. What would you suggest to remediate this problem for the entire ecosystem of Open Source JavaScript? We want to hear from you, work with you, and help solve this problem in a scalable way for new syntax revisions. Reach out us on Twitter: [_developit](https://twitter.com/_developit), [kristoferbaxter](https://twitter.com/kristoferbaxter) and [nomadtechie](https://twitter.com/nomadtechie) are all eager to discuss.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
