> * 原文地址：[A Future Without Webpack](https://www.pika.dev/blog/pika-web-a-future-without-webpack/)
> * 原文作者：[FredKSchott](https://twitter.com/FredKSchott)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/pika-web-a-future-without-webpack.md](https://github.com/xitu/gold-miner/blob/master/TODO1/pika-web-a-future-without-webpack.md)
> * 译者：[Badd](https://juejin.im/user/5b0f6d4b6fb9a009e405dda1)
> * 校对者：[MarchYuanx](https://github.com/MarchYuanx)

# 愿未来没有 Webpack

> 用 @pika/web 安装的 npm 包可以直接在浏览器中运行。这样的话你还需要一个打包工具（bundler）吗？

![](https://www.pika.dev/static/img/bundling-cover.jpg)

现在是 1941 年。你的名字是 Richard Hubbell。你在 CBS 旗下的一个试验性的纽约电视演播室工作。你将要主持一场主要电视新闻广播，这是世界上首批电视节目之一，你还有 15 分钟就要上场了。你知道你一会儿要干嘛吗？

在一个人们只知道收音机的世界里，你会坚信你的认知。而你此刻的认知就是，你要把新闻稿读出来。[“Hubbell 主持的电视新闻节目几乎都是照本宣科，偶尔把镜头切到一张地图或者静态图片上。”](https://books.google.com/books?id=yWrEDQAAQBAJ&lpg=PA132&ots=WBn6zP9HAW&dq=newscasts%20featured%20Hubbell%20reading%20a%20script%20with%20only%20occasional%20cutaways&pg=PA132#v=onepage&q=newscasts%20featured%20Hubbell%20reading%20a%20script%20with%20only%20occasional%20cutaways&f=false)还得过一阵子，人们才能在电视新闻上看到真实的视频片段。

作为一名身处 2019 年的 JavaScript 开发者，我也有同感。我们明明已经拥有了这个崭新的 JavaScript 模块系统（[ESM](https://flaviocopes.com/es-modules/)），它可以直接在 Web 环境中运行。可每次开发点什么，我们还是得用打包工具处理一下。这到底为什么？

在过去的几年里，JavaScript 打包界的炙手可热已经从只优化生产环境转变到了逢开发必打包的程度。不论你喜欢与否，都很难否认打包工具给 Web 开发带来了变态级别的复杂性，而 Web 开发明明是一个一贯以源码可见和轻松上手的精神为自豪的领域啊。

##### @pika/web 试图将 Web 开发者从打包地狱中解救出来。都 2019 年了，你使用打包工具应该是因为你想要用，而不是因为你不得不用。

<img height="310" width="50%" src="https://www.pika.dev/static/img/bundling-webpack-graph.jpeg"/><img height="310" width="50%" src="https://www.pika.dev/static/img/bundling-crazy-charlie.jpeg"/>

**Credit: [@stylishandy](https://twitter.com/stylishandy/status/1105049564237754373)**

### 我们为什么要打包

JavaScript 打包不过是旧瓶装新酒罢了。在过去（哈哈，大概 6 年前），在生产环境中将 JavaScript 文件压缩并合并是家常便饭。这样做能够提升网站的加载速度，并绕开 [HTTP/1.1 的并行请求瓶颈](https://stackoverflow.com/a/985704)。

本来这个优化有它更好没有也行，怎么后来就变成了开发过程中绝对必须的步骤了呢？这就是最疯狂的地方：大多数 Web 开发者从来没有特地要求过必须打包。相反，打包只是个副作用，我们真正渴求的另有其物 —— **npm**。

[npm](https://npmjs.com) —— 彼时代表着“Node.js 包管理工具” —— 正在逐渐成为有史以来最大的代码注册中心。前端开发者们希望能参与其中。唯一的问题在于，其 Node.js 风格的模块系统（Common.js 或 CJS）不经过打包就不能在 Web 环境中运行。故此，Browserify、[Webpack](https://webpack.js.org) 以及其他现代 Web 打包工具应运而生。

![创建 React 应用的视觉化展现：一大堆依赖包](https://www.pika.dev/static/img/bundling-cra-graph-2.jpg)

**[直观感受创建 React 应用](https://npm.anvaka.com/#/view/2d/react-scripts)：运行“Hello World”需要安装超过 1300 个依赖包**

### 复杂性斯德哥尔摩综合征

如今，想要开发 Web 项目，不用 [Webpack](https://webpack.js.org) 之类的打包工具基本是不可能了。就拿 [Create React App（CRA）](https://facebook.github.io/create-react-app/)快捷方式举例子，当你满心希望能快速创建项目，却发现需要先安装超过 1300 个不同的依赖包，整个臃肿的 `node_modules` 文件夹足足有 200.9MB 大小，而你只是想运行个“Hello World”啊！

就像 Richard Hubbell 那样，我们都深陷于打包工具的泥沼之中，太容易忽略事物本可以截然不同。我们现在有这么多优秀的现代 ESM 依赖包可以使用（[npm 上差不多有 50000 个！](https://www.pika.dev/about/stats)）。是什么阻止我们直接在 Web 环境上使用它们？

嗯，还真有那么几个原因。😕 自己写 Web 原生的 ESM 模块极其容易，而且确实有一些没有依赖的 npm 包能够直接在 Web 环境中运行。但不幸的是 ，绝大多数 npm 包是行不通的。包本身会继承其依赖的依赖，或者 npm 包通过包名导入依赖包这种特殊方式，这些都是原因。

这就是为何要创造 [@pika/web](https://github.com/pikapkg/web)。

### @pika/web：无需打包的 Web 应用。

用 [@pika/web](https://github.com/pikapkg/web) 安装的现代 npm 依赖可以直接在浏览器中运行，即使这些依赖包本身也有它们自己的依赖包。一步搞定。它不是一个构建工具，也不是一个（传统意义的）打包工具。@pika/web 是一种依赖包安装时（install-time）工具，它极大地降低你对其他工具的使用欲望，甚至能够完全甩开 [Webpack](https://webpack.js.org) 或 [Parcel](https://parceljs.org/) 这类绊脚石。

```bash
npm install && npx @pika/web
✔ @pika/web installed web-native dependencies. [0.41s]
```

@pika/web 会查看 `package.json` 文件，核对 `"dependencies"` 中所有导出了有效 ESM 模块入口点的依赖，然后把它们安装到本地的 `web_modules` 文件夹中。@pika/web 对所有的 ESM 包都有效，即使某些包带有 ESM 混合 Common.js 的内部依赖。

安装后的依赖包之所以能够在浏览器中运行，是因为 @pika/web 把每个包打包成了一个单独的、Web 环境能够支持的 ESM 模块 `.js` 文件。例如：整个“preact”包对应着文件 `web_modules/preact.js`。这样的机制可以处理包内部可能出现的弊端，同时保留原始的包接口。

“哎你等会儿！”你可能会说，[**“这不就是换了个地方打包吗？换汤不换药啊！”**](https://twitter.com/TheLarkInn/status/1102462419366891522)

**没错！**@pika/web 利用内部打包机制来输出 Web 原生支持的 npm 依赖，这也正是我们很多人从一开始就使用打包工具的主要原因！

有了 @pika/web，打包工具带来的所有麻烦都被这个安装时工具内部消化了。只要你不想，打包工具的配置代码你一行都不用看。但话说回来，你当然可以继续使用你喜欢的其他工具：提升开发体验的（[Babel](https://babeljs.io/)、[TypeScript](https://www.typescriptlang.org)），抑或优化产品的（[Webpack](https://webpack.js.org)、[Rollup](https://rollupjs.org/)）。

**这就是 @pika/web 的精神所在：打包，只因你想，而非必须。**

![截图：源码可见](https://www.pika.dev/static/img/bundling-view-source.png)

**附言：哦耶，[我源码可见又回来了！](https://www.pika.dev/js/PackageList.js)**

### 性能

相较大多数打包工具的安装方式，以 @pika/web 的方式（作为单个 JavaScript 文件的方式）安装每个依赖，会带给你极大的性能提升：依赖缓存。当你把所有依赖包打包成一个庞大的 `vendor.js` 文件，每当更新一个依赖，你就不得不迫使用户重新下载整个 `vendor.js`。而如果用 @pika/web 的话，更新某个依赖包不会让用户重新缓存所有依赖。

@pika/web 帮你摆脱这些因打包工具导致的性能方面的拖累。 [多个打包文件中冗余的相同代码](https://formidable.com/blog/2018/finding-webpack-duplicates-with-inspectpack-plugin/)、[无用或无关代码导致的首屏加载缓慢](https://medium.com/webpack/better-tree-shaking-with-deep-scope-analysis-a0b788c0ce77)、[Webpack 生态升级带来的坑和 Bug](https://medium.com/@allanbaptista/the-problem-with-webpack-8a025268a761)……所有这些文章和工具，都是人们使出浑身解数解决打包工具带来的副作用的佐证。

要说明的是，不对源代码进行打包处理，也不尽然总是十全十美的。针对在网络传输过程中的压缩效果而言，体积大的 JavaScript 文件要好于体积小、粒度细的文件。而在 [HTTP/2](https://developers.google.com/web/fundamentals/performance/http2/#request_and_response_multiplexing) 协议下，浏览器要花更多的时间去解析导入多个小文件的请求，解析完才能将后续请求发出去。

这就需要你在性能、缓存效率和自己能接受的复杂度之间权衡。再说一遍，这是 @pika/web 的精神所在：打包，只因你想，而非必须。

![一堆乐高积木](https://www.pika.dev/static/img/bundling-legos.jpg)

### Pika Web 开发策略

@pika/web 完全改变了我们做 Web 开发的方式。下面是我们之前搭建 [pika.dev](https://www.pika.dev/) 的过程，我们向 2019 年的你强烈推荐，下一个 Web 应用就用 @pika/web 来帮助开发吧：

1. 开始新项目时，先别引入打包工具。用现代 ESM 语法写代码，用 @pika/web 安装可以直接在 Web 环境运行的 npm 依赖包。不需要什么工具。
2. 你可以随时添加工具。如果需要强类型机制，那就添加 [TypeScript](https://www.typescriptlang.org)；如果需要使用试验性的 JavaScript 功能，那就添加 [Babel](https://babeljs.io/)；如果需要压缩 JavaScript 代码，那就添加 [Terser](https://github.com/terser-js/terser)。半年多过去了，[pika.dev](https://www.pika.dev/) 在此阶段的开发过程仍然顺风顺水。
3. 当你感觉需要用并且有时间用打包工具了，可以尝试给项目添加一个简单的打包工具。测试其性能如何。首屏加载是否迅速？那第二屏呢？如果都没问题，安排！
4. 随着开发进程的推进，不断优化打包工具的配置。
5. 等你预算充足了，就聘请一位 Webpack 专家。恭喜恭喜！如果你有足够资源能聘到一位 Webpack 专家，那你就算是正式地修成正果了。

### 想看些示例？有有有！

* 一个简单的项目：[\[源代码\]](https://glitch.com/edit/#!/pika-web-example-simple) [\[在线 Demo\]](https://pika-web-example-simple.glitch.me/)
* 一个 Preact + HTM 的项目： [\[源代码\]](https://glitch.com/edit/#!/pika-web-example-preact-htm) [\[在线 Demo\]](https://pika-web-example-preact-htm.glitch.me)
* Electron、Three.js…… [点击此处查看全部示例](https://github.com/pikapkg/web/blob/master/EXAMPLES.md)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
