> * 原文地址：[Enabling Modern JavaScript on npm](https://jasonformat.com/enabling-modern-js-on-npm/)
> * 原文作者：[Jason Miller](https://jasonformat.com/author/developit/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/enabling-modern-js-on-npm.md](https://github.com/xitu/gold-miner/blob/master/TODO1/enabling-modern-js-on-npm.md)
> * 译者：[Mirosalva](https://github.com/Mirosalva)
> * 校对者：[三月源](https://github.com/MarchYuanx)，[TiaossuP](https://github.com/TiaossuP)

# 在 npm 上启用现代 JavaScript

> 现代 JavaScript 语法让我们使用较少的代码做更多的事，然而我们传输给用户的 JavaScript，有多少是现代的呢？

![](https://res.cloudinary.com/wedding-website/image/upload/v1559234852/code-screenshot_1_zkday3.jpg)

过去的几年中我们一直在写现代 JavaScript（或者 [TypeScript](https://www.typescriptlang.org/)，它们在转译的过程中编译为 ES5。这样的做法让 JavaScript 的“最新技术”以比支持旧版浏览器时更快的速度向前发展。

最近，开发者已经采用差分的打包技术，其中两个或者更多个不同的 JavaScript 文件集被生成到不同目标环境中。这个技术最通用的例子是[模块/非模块模式](https://philipwalton.com/articles/deploying-es2015-code-in-production-today/)，它利用原生 JS 模块（也被认为『ES 模块』）支持它的『切割 mustard』测试：支持模块的浏览器请求现代版 JavaScript（~[ES2017](https://www.ecma-international.org/ecma-262/8.0/index.html)），同时旧版浏览器请求更加厚重的可兼容和编译的传统代码 bundle。为这套浏览器们做编译，取决于它们支持的 JS 模块类型，通过 [@babel/preset-env](https://babeljs.io/docs/en/babel-preset-env) 中 [targets.esmodules](https://babeljs.io/docs/en/babel-preset-env#targetsesmodules) 选项可以相对简单直接地完成编译。同时 [Webpack](https://webpack.js.org/) 插件，就像 [babel-esm-plugin](https://github.com/prateekbh/babel-esm-plugin#readme) 可以轻松生成两个 JavaScript bundle。

鉴于上述情况，所有博客文章和案例研究哪里展示了使用这种技术实现的卓越性能和 bundle 尺寸优势？事实证明，发送现代 JavaScript 代码需要的不仅仅是变更我们的转译目标。

## 这不是我们的代码

当前生成现代 bundle 与传统相对应 bundle 的解决方案仅仅关注于『业务代码』——— 我们写的应用程序代码。这些方法目前无法帮我们处理从 npm 安装的源码 ——— 这是一个问题，因为[一些代码](https://youtu.be/-xZHWK-vHbQ?t=2064)将安装类型的代码与编写类型代码的比例控制在 10:1 范围之内。尽管这个比例在每个工程内都明显不同，我们总能发现发给用户的 JavaScript 包含大量的安装类型的代码。即使回过头来看，也有明显的迹象表明生态系统倾向于安装现有模块，而非编写一次性使用模块。

![](https://res.cloudinary.com/wedding-website/image/upload/v1559231502/authored_vs_installed_ev2szc.png)

在许多方面，这代表了开源的胜利：开发人员能够在共享代码的共同价值上做转译，并在公共论坛里对需要解决的问题，协力合作出通用的解决方案。

『我们从 npm 安装的依赖项在 2014 年停滞不前』

事实证明，这个神奇的生态系统也是我们现代 JavaScript 拼图所缺失的最重要的部分：**我们从 npm 安装的依赖项在 2014 年停滞不前**。

> “我们从 npm 安装的依赖项在 2014 年停滞不前”

## 仅仅 JavaScript”

我们发布到 npm 的模块都是『JavaScript』，但那是任何对均匀性抱有期待终将落空的地方。几乎全球的前端开发者使用来自 npm 的 JavaScript 时都期望 JavaScript 运行『在一个浏览器中』。鉴于我们需要支持各种浏览器，我们最终会遇到这种情况：模块需要支持其消费者所用浏览器的目标支持版本的最小公分母。这种可能性的产生意味着我们明确地依赖于 `node_modules` 中所有代码需是 ECMAScript 5。在一些不常见的情况下，开发人员使用 bolted-on 的方法来检测非 ES5 模块，并且把这些模块预处理成他们需要的输出目标（这里有个你不该使用的 [hacky 方法](https://gist.github.com/developit/081148d83348ebe9a1bc1ba0707e1bb8)）。作为一个社区，每个新版本 ECMAScript 的向后兼容性使我们在很大程度上忽略了它对我们应用程序的影响，尽管我们编码的语法与我们最喜欢的 npm 依赖包中的语法之间的差异越来越大。

这就使得大家普遍认同：npm 模块在向仓库发布之前需要做模块转换。作者的发布过程一般包括把资源模块打包成多种格式：JS 模块、CommonJS 和 UMD。模块作者有时使用模块的 package.json 中的一组非官方字段来表示这些不同的 bundle，这个文件中 `"module"` 指向 `.mjs` 文件，`"unpkg"` 指向 UMD bundle，同时 `"main"` 仍被保留为引用一个 CommonJS 文件。

```json
{
  "main": "dist/es5-commonjs.js",
  "module": "dist/es5-modules.mjs",
  "unpkg": "dist/es5-umd.js"
}
```

所有这些格式仅影响到模块的接口 ——— 它的 import 和 export ——— 并且这形成了开发人员和工具之间的一个遗憾的共识：即使现代 JS 模块也应该被转译成库的最低支持版本。有人建议包作者可以在入口模块通过它们的 package.json 中 `module` 字段标识来开始启用现代 JavaScript 语法。遗憾的是，这种方法与如今的工具不兼容 ——— 尤其是，它与我们配置自己工具的方式不兼容。这些配置对每个工程都是不同的，由于工具本身并不需要改变，使得配置工程这件事本身就是一项繁复的任务。相反，修改需要放在每个应用程序的转译配置时。

这些约束一直坚挺的原因很大程度上是由于像 webpack 和 Rollup 这种主流打包器对是否处理从 `node_modules` 引入的 JavaScript 这件事并没有默认操作。这些工具可以轻松地配置成与原创代码相同方式处理 `node_modules` 的代码，但是它们的文档[一贯建议](https://webpack.js.org/loaders/babel-loader/#usage) 开发者为 `node_modules` [关闭 Babel 转换](https://github.com/rollup/rollup-plugin-babel#usage)。尽管较慢的转译过程为最终用户产出更好的效果，但上述建议通常在提升转译性能时会被提及。这使得从 `node_modules` 引入的代码做任何语义上的修改都非常难以在生态系统中传播，因为这些工具实际上并不控制转换的内容和方式。这种变化控制位于应用程序的开发者手中，意味着问题是分散的。

## 模块作者的观点

我们最喜欢的 npm 模块的作者们也参与了讨论。目前，模块作者们最终被迫在发布到 npm 之前将包进行 JavaScript 转换的五个主要原因是：

1. 我们知道应用开发者并没有转换 `node_modules` 中代码来匹配他们的支持目标。
2. 我们不能依赖应用开发者来设置足够的代码压缩和优化。
3. 库的大小必须以 bundled+minified+gzipped 操作之后的字节作为真实大小。
4. 以 ECMAScript 5 发布的 npm 模块仍被广泛接受。。
5. 对一个模块增加 JS 版本的要求意味着某些用户无法使用它。

合在一起，这些原因使得一个流行模块的作者几乎不可能转为默认使用现代 JavaScript。把你自己放在一个模块作者的位置来看：在知道更新结果会破坏你大多数用户的转译或者生产部署的情况下，你会愿意发布仅有现代语法的模块吗？

npm 生态系统的当前状态以及无法将经典 JavaScript 与现代 JavaScript 分离的问题，都导致我们无法完全拥抱 JS 模块和 ES20xx。

### Module authoring tools hurt, too

就像应用打包器被设置为对 `node_modules` 没有默认操作，改变模块的创作形式也是一个遗憾的分布式问题。因为大多数模块作者倾向于根据不同的项目需求推出自己的转译工具，因此实际上没有一套规范工具可以进行更改。[Microbundle](https://github.com/developit/microbundle) 作为一种共享方案一直在获得关注，还有最近发布的具有相似优化格式功能的 [@pika/pack](https://www.pikapkg.com/blog/introducing-pika-pack/)，模块可以通过它发布到 npm。遗憾的是，这些工具在得以考虑广泛传播前仍需要走很长的一段路。

假设可以影响到 Microbundle、Pika 和 Angular 的[库打包器](https://angular.io/cli/generate#library) 这样一组解决方案，或许可以使用流行模块作为示范来改变生态系统。如此规模的努力可能会遇到模块使用者的一些阻力，因为许多人还没有意识到他们的打包策略所产生的限制。然而，这些颠覆式的期望正是我们社区所需要的转变。

## 期待

这并不是所有的厄运和沮丧。尽管 Webpack 和 Rollup 只是通过它们的文档来鼓励未经处理的 npm 模块，Browserify 实际上在 `node_modules` 中默认[禁用了所有的转换](https://github.com/babel/babelify#why-arent-files-in-node_modules-being-transformed)。这意味着 Browserify 可以被修改用于自动生成现代/经典 bundle，而无需每一个应用开发者更改他们的转译配置。相似地，在 Webpack 和 Rollup 上转译的脚手架工具也提供一些集中地方，我们可以在这里进行更改，将现代 JS 引入 `node_modules`。我们在 [Next.js](https://nextjs.org/)、[Create React App](https://facebook.github.io/create-react-app/docs/getting-started), [Angular CLI](https://cli.angular.io/)、[Vue CLI](https://cli.vuejs.org/) 以及 [Preact CLI](https://github.com/developit/preact-cli) 中做这个变化，最终的转译配置将会使得相当一部分应用程序使用上述这些工具。

绝大多数 JavaScript 应用的转译系统是一次性的或者为每个项目单独定制的，没有统一的中心位置可以修改它们。一个可被我们考虑的缓慢地将社区推向现代 JS-friendly 配置方法的选择是：使得当从 `node_modules` 导入的 JavaScript 资源未被处理时，修改后的 Webpack 对此显示警告。去年 Bable [宣布了一些新功能](https://babeljs.io/blog/2018/06/26/on-consuming-and-publishing-es2015+-packages)，允许在 `node_modules` 中做一些选择性地转换，同时 Create React App 工具最近开始使用保守配置来做转换 `node_modules`。同样，可以创建工具来检查我们打包的 JavaScript，看看它有多少是过度填充或低效的传统语法。

## The last piece最后一块

假设我们可以将自动化和指导服务转译到我们的工具中，这样做最终会将使用这些工具的成千上万（甚至是百万）个应用迁移到允许在 `node_modules` 中使用现代语法的配置上。为了使这个方法产生效果，我们需要提出一致的规范来指定他们现代 JS 资源的位置，并且在该上下文中对什么是『现代』达成共识。对于 3 年前发布的软件包，『现代』可能意味着 ES2015。对于一个现今发布的包，『现代』大概会包括 [class fields](https://developers.google.com/web/updates/2018/12/class-fields)、[BigInt](https://developers.google.com/web/updates/2018/05/bigint) 或者 [Dynamic Import](https://developers.google.com/web/updates/2017/11/dynamic-import) 吧？这很难说清楚，毕竟浏览器支持程度、各个规范所处阶段都各不相同。

当我们考虑到对差分打包的影响时，这就变成了一个问题。对于那些不熟悉的人，差分打包指的是一种设置，它允许我们编写现代 JavaScript，然后针对不同环境转译单独的输出 bundle 套装。在最流行的用法中，针对较新浏览器我们有一套包含 ~ES2015 语法的 bundle，然后是针对所有其他浏览器的一套『传统』bundle，它们被转换成 ES5 并被填充。

![图表显示了多个 JavaScript 源文件被打包进入单独的 JavaScript 文件集：一个用于现代浏览器，另一个用于其他所有浏览器。](https://res.cloudinary.com/wedding-website/image/upload/v1559231328/modern_legacy_transpile_qbvkdd.png)

问题是：如果我们假设『现代』意味着『比 ES5 更新的东西』，则无法确定一个包中哪些语法应该做转换以满足给定的浏览器支持目标。我们可以通过为包创建一种表达它们所依赖的特定语法功能集的方法来定位上述问题，然而这仍需要维护大量不同的配置来控制每组输入到输出的语法对：

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

## 你会怎么做？

过度转换的 JavaScript 在我们发送给最终用户的代码中占比逐渐增加，影响了 Web 应用的初始加载时间和整体运行性能。我们相信这是一个需要解决的问题 ——— 一个需要模块作者**和**使用者达成一致的解决方案。问题空间相对较小，但是有许多具有独特约束条件的有趣部分。

我们期待社区的帮助。您对在整个 JavaScript 开源生态系统中解决这个问题有何建议？我们期待收到您的回复，与您合作，并以可扩展的形式来帮助解决此问题，以便进行新的语法修订。在 Twitter 上与我们联系：[`_developit`](https://twitter.com/_developit)、[kristoferbaxter](https://twitter.com/kristoferbaxter) 和 [nomadtechie](https://twitter.com/nomadtechie) 都期待参与讨论。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
