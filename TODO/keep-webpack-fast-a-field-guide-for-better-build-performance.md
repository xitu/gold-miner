> * 原文地址：[Keep webpack Fast: A Field Guide for Better Build Performance](https://slack.engineering/keep-webpack-fast-a-field-guide-for-better-build-performance-f56a5995e8f1)
> * 原文作者：[Rowan Oulton](https://slack.engineering/@rowanoulton?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/keep-webpack-fast-a-field-guide-for-better-build-performance.md](https://github.com/xitu/gold-miner/blob/master/TODO/keep-webpack-fast-a-field-guide-for-better-build-performance.md)
> * 译者：[Noah Gao](https://noahgao.net)
> * 校对者：[tvChan](https://github.com/tvChan)，[MechanicianW](https://github.com/MechanicianW)

# 保持 webpack 快速运行的诀窍：一本提高构建性能的现场指导手册

[webpack](https://webpack.js.org/) 是用于打包前端资源的绝佳工具。然而，当运行开始变慢时，开箱即用的生态和大量的第三方工具使得优化变得十分困难。虽然性能不佳是一种常态而不是特例。但也不是没有办法来优化，经过几个小时的调研与试错，我完成了这样一份现场指南，可以让我们在加快构建的道路上学到更多知识。

![](https://cdn-images-1.medium.com/max/800/1*n7SFvwKvpLsW0ZcEDbgBtg.jpeg)

昔日的构建工具：连接提花机的织机。

### 前言

2017 年是 Slack 前端团队雄心勃勃的一年。经过几年的快速迭代开发，我们有不少的技术债务和进行大规模现代化的宏伟计划。首先，我们计划用 React 重写我们的 UI 组件，并全面使用上现代 JavaScript 语法。然而在我们希望这一点能够实现之前，我们需要一套构建系统来支持这一新的工具星云。

到目前为止，我们只能依靠文件的简单连接，虽然这一体系已经让我们走到了这一步，但显然它不会让我们再更进一步了。 我们需要一套真正的构建系统。所以，作为一个具有良好的社区支持、易用性和功能集的强大起点，我们选择了 webpack。

我们的项目切换到 webpack 的过渡大部分是平稳的。很平稳，直到，它遇到了构建性能问题。我们的构建花了几分钟，而不是几秒钟：与我们曾经习惯的秒级连接相差甚远。Slack 的 Web 团队在任何一个工作日都可以部署 100 次，所以我们感觉到了构建时间的急剧增长。

构建性能一直是 webpack 用户群的关注重点，尽管核心团队在过去几个月里一直在努力改进，但你仍然可以采取很多方法来自行改进自己的构建。下面的这些技巧帮助我们将构建时间缩短了 10 倍，我们将它们分享出来，希望能帮助到大家。

### 开始前，先测量

在尝试优化之前，最重要的是了解时间在哪里被浪费掉了。webpack 没有提供这些信息，但这些必需的信息还能通过其他的方法来得到。

#### Node.js 的 inspector

Node 自带了一个可以用来分析构建的 [inspector](https://nodejs.org/en/docs/inspector/)。如果你不熟悉性能分析，不需要灰心：Google 很努力地解释了 [实现的细节](https://developers.google.com/web/tools/chrome-devtools/evaluate-performance/reference)。对 webpack 构建阶段的粗略理解在这里将是非常有益的，尽管[他们的文档](https://webpack.js.org/concepts/) 简要介绍了这一点，但阅读一些 [核心](https://github.com/webpack/webpack/blob/0975d13da711904429c6dd581422c755dd04869c/lib/Compiler.js) [代码](https://github.com/webpack/webpack/blob/b597322e3cb701cf65c6d6166c39eb6825316ab7/lib/Compilation.js) 是非常有益的。

请注意，如果您的构建内容足够大（比如有数百个模块或是需时超过一分钟），则可能需要将分析过程分解为多个部分，以防止开发人员工具崩溃。

#### 长期记录

分析帮助我们确定了我们构建前端的缓慢部分，但是它不适合随着时间的推移观察趋势。我们希望每次构建都能够报告精确的时序数据，以便我们可以看到在每个昂贵的步骤（转译，压缩和本地化）中花费了多少时间，并确定我们的优化是否有效。

对于我们来说，大部分的工作不是由 webpack 本身完成的，而是由我们所依赖的各种加载器和插件完成的。总的来说，这些依赖并没有提供精确的时序数据，虽然我们希望看到 webpack 采用标准化的方式来向第三方报告这种信息，但是与此同时我们发现我们必须手动进行一些额外的日志记录。

对于加载器来说，这意味着解除我们的依赖关系。虽然这不适合作为一个长期策略，但是在我们进行优化的时候，对于我们辨认出过程中缓慢的部分是非常有用的。另一方面，插件更容易分析。

#### 便宜的测量插件

插件将自己附加到与构建的不同阶段相关的 [事件](https://webpack.js.org/contribute/writing-a-plugin/) 上。通过测量这些阶段的持续时间，我们可以粗略的测量我们插件的执行时间。

[UglifyJSPlugin](https://github.com/webpack-contrib/uglifyjs-webpack-plugin) 是一个典型的测量插件，这种技术是有效的，因为其大部分工作是在 [optimize-chunk-assets](https://github.com/webpack-contrib/uglifyjs-webpack-plugin/blob/d81ef5ac71481b9d5ba2055d55b27c7e18258739/src/index.js#L101) 阶段。下面是一个简单的插件例程：

```javascript
let CrudeTimingPlugin = function() {};

CrudeTimingPlugin.prototype.apply = function(compiler) {
  compiler.plugin('compilation', (compilation) => {
    let startOptimizePhase;

    compilation.plugin('optimize-chunk-assets', (chunks, callback) => {
      // 使用粗略测量压缩时间的方法。
      // UglifyJSPlugin 在这个编译阶段完成全部工作，
      // 所以我们计算整个阶段的时间。
      startOptimizePhase = Date.now();

      // 对于异步阶段，不要忘记调用回调函数
      callback();
    });

    compilation.plugin('after-optimize-chunk-assets', () => {
      const optimizePhaseDuration = Date.now() - startOptimizePhase;
        console.log(`optimize-chunk-asset phase duration: ${optimizePhaseDuration}`);
      });
    });
};

module.exports = CrudeTimingPlugin;
```

上面的例子目的是粗略地测量 UglifyJSPlugin 的执行时间差。请注意了解插件将在哪些阶段执行，因为可能有重叠。

把它添加到你的插件列表里，在 UglifyJS 之前，就像这样：

```javascript
const CrudeTimingPlugin = require('./crude-timing-plugin');

module.exports = {
plugins: [
    new CrudeTimingPlugin(),
    new UglifyJSPlugin(),
  ]
};
```

这些信息的价值大大超过了获取它的成本，一旦你明白了时间花在了哪里，就能够有效地减少花费的时间。

### 并行操作

webpack 的很多工作本身就是并行的。通过把工作扩展到尽可能多的处理器上来获得巨大的效果，如果你有多余的 CPU 核心可“烧”，现在是“烧掉它”的时候了。

幸运的是，有一堆以此为目的打造的软件包：

* [parallel-webpack](https://github.com/trivago/parallel-webpack) 将并行执行整个 webpack 构建。我们在 Slack 中使用它来为我们的五种编程语言生成对应的资源。
* [happypack](https://github.com/amireh/happypack) 将会并行地执行加载器，就像 [thread-loader](https://github.com/webpack-contrib/thread-loader) 一样，由 webpack 核心团队编写和维护。并可以与  babel-loader 和其他转译器搭配起来。
* UglifyJS 插件的用户可以使用最近添加的 [并行选项](https://github.com/webpack-contrib/uglifyjs-webpack-plugin#options)

注意，拉起新线程有一个不小的成本。建议只在消耗较大的操作中，基于你之前的分析，灵活地应用它们。

### 降低工作负载

当我们的 webpack 测量实现完成时，我们意识到在几个地方做了不必要的工作。砍掉这些地方为我们节省了大量的时间：

#### **简化压缩**

压缩是一个巨大的时间沉淀 —— 占据我们三分之一到一半的构建时间。我们评估了不同的工具，从 [Butternut](https://github.com/Rich-Harris/butternut) 到 [babel-minify](https://github.com/babel/minify)，结果却发现 UglifyJS 在并行配置下是最快的。

然而，对我们来说，关于要处理的性能问题相关的核心信息 [被埋在作者的长篇大论之下](https://github.com/mishoo/UglifyJS2/blob/ae67a4985073dcdaa2788c86e576202923514e0d/README.md#uglify-fast-minify-mode)

> 同大家认为的不同，对于大多数 JavaScript 来说，空白的去除和符号的改变能够压缩代码的 95％，是主要代码压缩的核心，而不是精心设计的代码转换。人们可以简单地禁用压缩加速 Uglify 构建 3 至 4 倍。

我们试了一下，结果令人咋舌。就像承诺的那样，压缩速度是原来的 3 倍，而且我们生成的打包文件大小几乎没有增长。不过 React 用户以这种方式禁用压缩应该警惕一个警告：[detection methods](https://github.com/facebook/react-devtools/blob/7443291103bc619e7e9b8ab009fb6da1281ba302/backend/installGlobalHook.js#L52-L118) 被 [react-devtools](https://github.com/facebook/react-devtools) 用来报告你正在使用 React 的开发版本。经过一些试错，我们发现以下配置解决了这个问题：

```javascript
new UglifyJsPlugin({
  uglifyOptions: {
    compress: {
      arrows: false,
      booleans: false,
      cascade: false,
      collapse_vars: false,
      comparisons: false,
      computed_props: false,
      hoist_funs: false,
      hoist_props: false,
      hoist_vars: false,
      if_return: false,
      inline: false,
      join_vars: false,
      keep_infinity: true,
      loops: false,
      negate_iife: false,
      properties: false,
      reduce_funcs: false,
      reduce_vars: false,
      sequences: false,
      side_effects: false,
      switches: false,
      top_retain: false,
      toplevel: false,
      typeofs: false,
      unused: false,

      // 除非声明了正在使用生产版本的react-devtools，
      // 否则关闭所有类型的压缩。
      conditionals: true,
      dead_code: true,
      evaluate: true,
    },
    mangle: true,
  },
}),
```

注意：此配置适用于 UglifyJS webpack 插件的 1.1.2 版本。

检测变量根据版本而不同，React 16用户可能单独使用_compress：false_。

通常优先考虑最终发送给用户的字节数，所以请注意在工程团队和下载应用程序的用户之间取得平衡。

#### **代码重用**

开发中需要找到并进入多个相同代码的包是很常见的事。当这种情况发生时，压缩器的工作将不必要地增加。 我们把打包通过 [webpack Bundle Analyzer](https://www.npmjs.com/package/webpack-bundle-analyzer) 和 [Bundle Buddy](https://github.com/samccone/bundle-buddy) 这两部显微镜找到重复的项，并将其用 webpack 的 [CommonsChunkPlugin](https://webpack.js.org/plugins/commons-chunk-plugin/) 分成共享块。

#### **跳过部分解析**

webpack 会在查找依赖关系的同时，将每个 JavaScript 文件解析为 [语法树](https://en.wikipedia.org/wiki/Abstract_syntax_tree)。这个过程是很昂贵的，所以如果你确定一个文件（或一组文件）永远不会使用 import，require 或者 define 语句，你可以告诉 webpack 在这个过程中排除它们。以这种方式跳过大型库可以大幅提高效率。有关更多详细信息，请参见 [noParse](https://webpack.js.org/configuration/module/#module-noparse) 选项。

#### **排除**

通过类似的方式，你可以从加载器 [排除](https://webpack.js.org/configuration/module/#rule-exclude) 文件，许多插件提供 [类似的选项](https://github.com/webpack-contrib/uglifyjs-webpack-plugin#options)。这可以实在的提高工具的性能，例如也依靠语法树来完成自身工作的转译器和压缩器。在 Slack 中，我们只编译我们确认使用了 ES6 特性的代码，并且忽略不直接提供给客户的代码的压缩。

#### **DLL 插件**

[DllPlugin](https://webpack.js.org/plugins/dll-plugin/) 将允许你在后面的阶段剥离预先构建好的包供 webpack 使用，非常适合像 Vendor 库这样的大型，较少移动的依赖项。虽然它传统上是一个需要大量配置的插件，但是 [autodll-webpack-plugin](https://github.com/asfktz/autodll-webpack-plugin) 为更简单的实现铺平了道路，值得一看。

#### **使用记录来稳定模块 ID**

webpack 为依赖关系树中的每个模块分配一个 ID。随着新模块的添加以及其他模块的移除，树会发生变化，同时也会改变其中每个模块的 ID。这些 ID 被置入每个 webpack 发出的文件中，而高级别的模块混合（译者注：应指交叉依赖，npm 一直以来的的一大严重问题）可能导致不必要的重建。 通过使用 [records](https://webpack.js.org/configuration/other-options/#recordspath) 来防止这种情况，在构建之间稳定您的模块ID。

#### **创建一个清单块**

在 Slack，每次发布新版本时，我们都会使用哈希文件名来缓存破解。打开浏览器开发人员工具的“网络”选项卡，您将看到“_application.d4920286de51402132dc.min.js”文件的请求。这种技术对于缓存控制来说是非常棒的，但是这也意味着 webpack 无法在不借助摘要的情况下将模块映射到相应的文件名。

摘要是模块 ID 到哈希的简单映射，当 [异步导入模块](https://webpack.js.org/api/module-methods/#import-)时，webpack 将用它来解析文件名：

```JSON
{
    0: "d4920286de51402132dc", /* ← 为应用打包而生成的哈希值 */
    1: "29a3cf9344f1503c9f8f",
    2: "e22b11ab6e327c7da035",
    /* .. 等等等 ... */
}
```

默认情况下，webpack 将在它添加到每个打包文件顶部的样板代码中包含这个摘要。然而这是有问题的，因为每次添加或删除模块时摘要都必须更新 —— 这种情况我们每天都会发生。每当摘要发生变化时，我们不仅需要等待所有打包文件的重建，而且还要破坏缓存，迫使我们的客户重新下载它们。

仅仅保持模块ID稳定是不够的。我们需要将模块摘要完全提取到一个单独的文件中；在我们或是我们的客户没有花费重建和重新下载任何东西的成本的情况下，就能够定期改变。所以我们用CommonsChunk插件创建了一个 [manifest文件](https://webpack.js.org/plugins/commons-chunk-plugin/#manifest-file)。这大大减少了重建的频率，而且还让我们只发送了一个 webpack 的样板代码的副本。

#### **Source maps**

源地图（Source maps）是调试时用到的关键工具，但是生成它们将花费一定时间，改动 webpack 的 [开发工具菜单选项](https://webpack.js.org/configuration/devtool/) 并选择一个最合适自己的调试风格。 _cheap-source-map_ 方案在构建性能和可调试性间取得了不错的平衡。

### 缓存

我们的部署节奏很快，这意味着当前的构建和之前的之间通常只有很小的差异。随着在正确的地方被缓存，我们可以加速大部分 webpack 本来会做的工作。

我们使用 [cache-loader](https://github.com/webpack-contrib/cache-loader/) 来缓存结果（babel-loader 的用户通常会优先选择使用它的 [内建缓存](https://github.com/babel/babel-loader#options)，UglifyJSPlugin 的 [内建缓存](https://github.com/webpack-contrib/uglifyjs-webpack-plugin#options)，以及加入了 [HardSourceWebpackPlugin](https://github.com/mzgoddard/hard-source-webpack-plugin)。

#### 有关 HardSourceWebpackPlugin 的一点笔记

webpack 所做的很多工作都在加载器/插件执行之外，而且大部分工作都会遵循传统避开缓存。为了解决这个问题，我们引入了一个插件 [HardSourceWebpackPlugin](https://github.com/mzgoddard/hard-source-webpack-plugin)，用于缓存 webpack 内部模块处理的中间结果。

为此，我们必须仔细列举可能需要缓存的所有外部因素，并彻底地进行测试。在我们的例子中包括：转移，CDN 资源路径和依赖版本。这不是个轻松地差事，但结果是值得的 —— 启动缓存后，我们的热构建快了 20 秒。

最后要注意的是，每当程序包依赖性发生变化时，请记住清除缓存 - 可以使用 [npm postinstall script](https://docs.npmjs.com/misc/scripts) 自动执行。一个陈旧、不兼容的缓存可能会以新的和有趣的方式对你的构建造成严重破坏。

### 保持版本最新

在 webpack 生态系统中，保持最新状态是值得的。核心团队近期已经做了很多工作来提高构建速度，如果你没有使用最新版本的依赖项，你可能会错过大量的性能提升。 当我们从 webpack 3.0 升级到 3.4 时，我们发现加速了几十秒钟，而我们完全没有改变配置，并且这样的改进还在继续。

定期升级并跟上前面提到的如并行性等新功能的更新。在 Slack ，我们尽我们所能地留意 Github 上的发布，[webpack团队博客](https://medium.com/webpack), [babel团队博客](https://github.com/babel/notes)以及其他有关他们工作的博客。

不要忘记让你的 Node 保持在最新的版本 — 软件包不是唯一的改进途径。

### 硬件上的投资

当一天结束的时候，你的构建必须在某个地方运行，并且要在某个东西上运行。 如果最终的构建是在史前级的设备上进行的话，那么对整体构建性能，即便进行了最优秀的优化，都会产生很大的影响。

当我们的任务刚开始进行时，我们的构建服务器是 Amazon EC2 家族的成员，C3。 通过将实例类型更新到 C4 产品（处理器更快，更强大），随着代码库的增长，我们看到了构建时间和可用于扩展的并行能力相关选项的显著改进。 用户通常担心的从实例支持的机器到 EBS 的过渡过程不需要感到绝望：webpack 积极地缓存文件操作，我们没有发现迁移到 EBS 后性能存在降低现象。

如果它在您的能力（和预算）范围内，那么请评估更好的硬件和基准，以找到最佳的配置。

### 贡献

像 webpack 这样的基础设施项目几乎都出奇的穷; 无论是时间还是金钱，对您使用的工具做出贡献将为您和社区中的其他人改善这一工具的生态系统。Slack 最近为 webpack 项目做了捐赠，以确保团队能够继续工作，我们鼓励其他人也这样做。

贡献也可以通过反馈的形式进行。作者往往热衷于听到他们的用户提供的更多信息，了解他们需要在哪里花费最多的精力，而且 webpack 甚至鼓励用户 [对核心团队的优先事项投票](https://webpack.js.org/vote/)。 如果你关心构建性能，或者你已经有了改进的想法，那就让你的声音被大家听到吧。

### 后话

webpack 是一个梦幻般的，多功能工具，不需要花费天价。这些技术帮助我们将建造时间的中位数从 170 秒缩短到了 17 秒，尽管他们为我们的工程师们提高了部署经验，但他们并不是一个已经十分完善的项目。如果您对如何进一步提高构建性能有任何想法，我们很乐意听取您的意见。当然，如果你喜欢解决这些问题 [来和我们一起工作吧](https://slack.com/careers)!

非常感谢 Mark Christian, Mioi Hanaoka, Anuj Nair, Michael “Z” Goddard, Sean Larkin and, of course, Tobias Koppers 对这篇文章和  webpack 项目做出的贡献。

### 扩展阅读

* [Build performance](https://webpack.js.org/guides/build-performance/)，webpack 官方文档中的介绍
* [How we improved webpack build performance by 95%](https://blog.box.com/blog/how-we-improved-webpack-build-performance-95/) by Wenbo Yu
* [webpack on twitter.com](https://alunny.com/articles/webpack-on-twitter-com/) by Andrew Lunny
* [The official webpack blog](https://medium.com/webpack)
* [How webpack works](https://raw.githubusercontent.com/sokra/slides/master/data/how-webpack-works.pdf)，一篇 Tobias Koppers  在 [EnterJS](https://www.enterjs.de) 上的演讲幻灯片

感谢 [Matt Haughey](https://medium.com/@mathowie?source=post_page) 的支持。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
