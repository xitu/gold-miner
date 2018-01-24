> * 原文地址：[Keep webpack Fast: A Field Guide for Better Build Performance](https://slack.engineering/keep-webpack-fast-a-field-guide-for-better-build-performance-f56a5995e8f1)
> * 原文作者：[Rowan Oulton](https://slack.engineering/@rowanoulton?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/keep-webpack-fast-a-field-guide-for-better-build-performance.md](https://github.com/xitu/gold-miner/blob/master/TODO/keep-webpack-fast-a-field-guide-for-better-build-performance.md)
> * 译者： [Noah Gao](https://noahgao.net)
> * 校对者：

# 保持 webpack 快速运行的诀窍：一本提高构建性能的现场指导手册

[webpack](https://webpack.js.org/) 是用于打包前端资源的绝佳工具。然而，当环境开始变慢时，开箱即用的生态和大量的第三方工具使得优化变得十分困难。虽然性能不佳是一种常态而不是特例。但也不是没有办法来优化，经过几个小时的研究、试验和错误，我完成了这样一份现场指南，用于加快构建的道路上学到更多新知识。

![](https://cdn-images-1.medium.com/max/800/1*n7SFvwKvpLsW0ZcEDbgBtg.jpeg)

昔日的构建工具：连接提花机的织机。

### 前言

2017 年是 Slack 前端团队雄心勃勃的一年。经过几年的快速迭代开发，我们有不少的技术债务和进行大规模现代化的宏伟计划。首先，我们计划用 React 重写我们的 UI 组件，并全面使用上现代 JavaScript 语法。然而在我们希望这一点能够实现之前，我们需要一套构建系统来支持这一新的工具星云。

到目前为止，我们只能依靠文件的简单连接，虽然这一体系已经让我们走到了这一步，但显然它不会让我们再更进一步了。 我们需要一套真正的构建系统。所以，作为一个具有良好的社区支持、易用性和功能集的强大起点，我们选择了webpack。

我们的项目切换到 webpack 的过渡大部分是平稳的。很平稳，直到，它遇到了构建性能问题。我们的构建花了几分钟，而不是几秒钟：与我们曾经习惯的秒级连接相差甚远。Slack 的 Web 团队在任何一个工作日都可以部署 100 次，所以我们感觉到了构建时间的急剧增长。

构建性能一直是 webpack 用户群的关注重点，尽管核心团队在过去几个月里一直在努力改进，但你仍然可以采取很多方法来自行改进自己的构建。下面的这些技巧帮助我们将构建时间缩短了10倍，我们将它们分享出来，希望能帮助到大家。

### 开始前，先测量

在尝试优化之前，最重要的是了解时间在哪里被浪费掉了。webpack 没有提供这些信息，但这些必需的信息还有其他的方法来得到。

#### Node.js 的 inspector

Node自带了一个可以用来分析构建的 [inspector](https://nodejs.org/en/docs/inspector/)。如果你不熟悉性能分析，不需要灰心：Google很努力地解释了 [实现的细节](https://developers.google.com/web/tools/chrome-devtools/evaluate-performance/reference)。对 webpack 构建阶段的粗略理解在这里将是非常有益的，尽管[他们的文档](https://webpack.js.org/concepts/) 简要介绍了这一点，但如果阅读一些 [核心](https://github.com/webpack/webpack/blob/0975d13da711904429c6dd581422c755dd04869c/lib/Compiler.js) [代码](https://github.com/webpack/webpack/blob/b597322e3cb701cf65c6d6166c39eb6825316ab7/lib/Compilation.js) 是非常有益的。

请注意，如果您的构建足够大（比如有数百个模块或是需时超过一分钟），则可能需要将分析过程分解为多个部分，以防止开发人员工具崩溃。

#### 长期记录

分析帮助我们确定了我们构建前端的缓慢部分，但是它不适合随着时间的推移观察趋势。 我们希望每次构建都能够报告精确的时序数据，以便我们可以看到在每个昂贵的步骤（转译，简化和本地化）中花费了多少时间，并确定我们的优化是否有效。

对于我们来说，大部分的工作不是由 webpack 本身完成的，而是由我们所依赖的各种加载器和插件完成的。总的来说，这些依赖并没有提供精确的时序数据，虽然我们希望看到 webpack 采用标准化的方式来向第三方报告这种信息，但是我们发现我们不得不与此同时手动进行一些额外的日志记录。

对于加载器来说，这意味着分开我们的依赖关系。虽然这不适合作为一个长期策略，但是在我们进行优化的时候，对于我们辨认出过程中缓慢的部分是非常有用的。另一方面，插件更容易分析。

#### 便宜的测量插件

插件将自己附加到与构建的不同阶段相关的 [事件](https://webpack.js.org/contribute/writing-a-plugin/) 上。通过测量这些阶段的持续时间，我们可以粗略的测量我们插件的执行时间。

[UglifyJSPlugin](https://github.com/webpack-contrib/uglifyjs-webpack-plugin) 是一个典型的测量插件，这种技术是有效的，因为其大部分工作是在 [optimize-chunk-assets](https://github.com/webpack-contrib/uglifyjs-webpack-plugin/blob/d81ef5ac71481b9d5ba2055d55b27c7e18258739/src/index.js#L101) 阶段。 下面是一个简单的插件例程：

```
let CrudeTimingPlugin = function() {};

CrudeTimingPlugin.prototype.apply = function(compiler) {
	compiler.plugin('compilation', (compilation) => {
		let startOptimizePhase;

		compilation.plugin('optimize-chunk-assets', (chunks, callback) => {
			// Cruddy way of measuring minification time. UglifyJSPlugin does all
			// its work in this phase of compilation so we time the duration of
			// the entire phase
			startOptimizePhase = Date.now();
      
			// For async phases: don't forget to invoke the callback
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

上面的例子目的是粗略地测量 UglifyJSPlugin 的执行时间插。请注意了解插件将在哪些阶段执行，因为可能有重叠。

把它添加到你的插件列表里，在 UglifyJS  之前，就像这样：

```
const CrudeTimingPlugin = require('./crude-timing-plugin');

module.exports = {
	plugins: [
		new CrudeTimingPlugin(),
		new UglifyJSPlugin(),
	]
};
```

这些信息的价值大大超过了获取它的花费，一旦你明白了时间花在了哪里，就能够有效地减少花费的时间。

### 并行操作

webpack 的很多工作本身就是并行的。 通过把工作扩展到尽可能多的处理器上来获得巨大的效果，如果你有多余的CPU核心可“烧”，现在是“烧掉它”的时候了。

幸运的是，有一堆以此为目的打造的软件包:

* [parallel-webpack](https://github.com/trivago/parallel-webpack) 将并行执行整个 webpack 构建。我们在 Slack 中使用它来为我们的五种编程语言生成对应的资源。
* [happypack](https://github.com/amireh/happypack) 将会并行地执行加载器，就像 [thread-loader](https://github.com/webpack-contrib/thread-loader) 一样，由 webpack 核心团队编写和维护。并可以与babel-loader和其他转译器搭配起来。
* UglifyJS 插件的用户可以使用最近添加的 [并行选项](https://github.com/webpack-contrib/uglifyjs-webpack-plugin#options)

注意，拉起新线程有一个不小的成本。建议只在消耗较大的操作中,基于你之前的分析，灵活地应用它们。

### Reduce the workload

As our implementation of webpack matured, we realized it was doing more work than necessary in several places. Chipping away at these areas saved us a surprising amount of time:

#### **Simpler minification**

Minification is a huge time sink — it was between half and a third of our build time. We evaluated different tooling, from [Butternut](https://github.com/Rich-Harris/butternut) to [babel-minify](https://github.com/babel/minify), but found that UglifyJS in a parallel configuration was the quickest.

What really sealed the deal for us, though, was a note on performance [buried beneath a long readme](https://github.com/mishoo/UglifyJS2/blob/ae67a4985073dcdaa2788c86e576202923514e0d/README.md#uglify-fast-minify-mode) from the author:

> It’s not well known, but whitespace removal and symbol mangling accounts for 95% of the size reduction in minified code for most JavaScript — not elaborate code transforms. One can simply disable compress to speed up Uglify builds by 3 to 4 times.

We tried it and the results were staggering. As promised, minification was 3 times as fast and our bundle sizes had hardly grown at all. React users wishing to disable compression in this way should be wary of one caveat: the [detection methods](https://github.com/facebook/react-devtools/blob/7443291103bc619e7e9b8ab009fb6da1281ba302/backend/installGlobalHook.js#L52-L118) used by [react-devtools](https://github.com/facebook/react-devtools) can report that you’re shipping a development version of React. After some trial and error, we found the following configuration fixed the problem:

```
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

      // Switch off all types of compression except those needed to convince
      // react-devtools that we're using a production build
      conditionals: true,
      dead_code: true,
      evaluate: true,
    },
    mangle: true,
  },
}),
```

Note: this configuration is for version 1.1.2 of the UglifyJS webpack plugin.

Detection varies by version and React 16 users may get away with _compress: false_ alone.

Fewer bytes for the end-user is often the priority so take care to strike the right balance between the needs of your engineering team and those of the people downloading your application.

#### **Sharing code**

It’s typical for the same code to find its way into more than one bundle. When this happens the minifier’s work will be multiplied unnecessarily. We put our bundles under the microscope with both the [webpack Bundle Analyzer](https://www.npmjs.com/package/webpack-bundle-analyzer) and [Bundle Buddy](https://github.com/samccone/bundle-buddy) to find duplicates and split them out into shared chunks with webpack’s [CommonsChunkPlugin](https://webpack.js.org/plugins/commons-chunk-plugin/).

#### **Skip parsing**

webpack will parse every JavaScript file it sees into a [syntax tree](https://en.wikipedia.org/wiki/Abstract_syntax_tree) while it hunts for dependencies. This process is expensive so if you are certain that a file (or set of files) will never use import, require, or define statements, you can tell webpack to exclude them from this process. Skipping large libraries in this way can really boost performance. See the [noParse](https://webpack.js.org/configuration/module/#module-noparse) option for more detail.

#### **Exclusions**

In a similar vein, you can [exclude](https://webpack.js.org/configuration/module/#rule-exclude) files from loaders, and many plugins offer [similar options](https://github.com/webpack-contrib/uglifyjs-webpack-plugin#options) too. This can really improve performance for tools like transpilers and minifiers that also rely on syntax trees to do their surgical work. At Slack we only transpile code we know will use ES6 features and skip minification for non-customer facing code altogether.

#### **The DLL plugin**

[DllPlugin](https://webpack.js.org/plugins/dll-plugin/) will let you carve off prebuilt bundles for consumption by webpack at a later stage and is well suited to large, slow-moving dependencies like vendor libraries. While it has traditionally been a plugin that required an enormous amount of configuration, [autodll-webpack-plugin](https://github.com/asfktz/autodll-webpack-plugin) is paving the way to a simpler implementation and is well worth a look.

#### **Use records to stabilize module IDs**

webpack assigns an ID to every module in your dependency tree. As new modules are added and others removed, the tree changes and so too do the IDs of each module within it. These IDs are baked into every file that webpack emits and a high level of module churn can result in unnecessary rebuilds. Prevent this by using [records](https://webpack.js.org/configuration/other-options/#recordspath) to stabilize your module IDs between builds.

#### **Create a manifest chunk**

At Slack we use hashed filenames to cache-bust every time a new version is shipped. Open the Network tab of your browser’s developer tools and you’ll see requests for files like “_application.d4920286de51402132dc.min.js_”. This technique is fantastic for cache control, but means webpack can no longer map a module to its respective filename without the help of a digest.

The digest is a simple map of module IDs to hashes that webpack will use to resolve a filename when [importing modules asynchronously](https://webpack.js.org/api/module-methods/#import-):

```
{
    0: "d4920286de51402132dc", /* ← hash for the application bundle */
    1: "29a3cf9344f1503c9f8f",
    2: "e22b11ab6e327c7da035",
    /* .. and so on ... */
}
```

By default, webpack will include this digest in the boilerplate code it adds to the top of every bundle. This was problematic as the digest had to be updated every time a module was added or removed — a daily occurrence for us. Whenever the digest changed, not only did we have to wait for all of our bundles to be rebuilt but they were cache-busted too, forcing our customers to re-download them.

Keeping module IDs stable wasn’t enough. We needed to extract the module digest into a separate file entirely; one that could change regularly without us or our customers paying the cost of rebuilding and re-downloading everything. So we created a [manifest file](https://webpack.js.org/plugins/commons-chunk-plugin/#manifest-file) with the CommonsChunk plugin. This greatly reduced the frequency of rebuilds and had the added bonus of letting us ship only a single copy of webpack’s boilerplate code too.

#### **Source maps**

Source maps are a crucial tool for debugging, but generating them can be incredibly time-consuming. Consult webpack’s [menu of devtool options](https://webpack.js.org/configuration/devtool/) and see if a cheaper style will provide the debuggability you need. We found _cheap-source-map_ struck a good balance between build performance and debuggability.

### Cache

Our deployment cadence is rapid, and this means there are usually only small differences between the current build and its ancestors. With caching in the right place we could shortcut most of the work webpack would have done otherwise.

We use [cache-loader](https://github.com/webpack-contrib/cache-loader/) to cache loader results (users of babel-loader can choose to use it’s [built-in caching](https://github.com/babel/babel-loader#options) if they prefer), UglifyJSPlugin’s [built-in caching](https://github.com/webpack-contrib/uglifyjs-webpack-plugin#options), and last but not least the [HardSourceWebpackPlugin](https://github.com/mzgoddard/hard-source-webpack-plugin).

#### A note on HardSourceWebpackPlugin

A lot of the work that webpack does is outside of loader/plugin execution and much of that work has traditionally evaded caching altogether. To solve this problem, we brought in [HardSourceWebpackPlugin](https://github.com/mzgoddard/hard-source-webpack-plugin), a plugin designed to cache the intermediate results of webpack’s internal module processing.

For it to work we had to carefully enumerate all the external factors that might require the cache to be broken and test it thoroughly. In our case: translations, CDN asset paths, and dependency versions. This isn’t for the faint-hearted but the results were well worth the effort — after priming the cache our warm builds were a full 20 seconds faster.

As a final note, remember to clear your cache whenever package dependencies change — something you can automate with an [npm postinstall script](https://docs.npmjs.com/misc/scripts). A stale, incompatible cache can wreak havoc on your build and break it in new and interesting ways.

### Stay up to date

In the webpack ecosystem it pays to stay up to date. Steady work has been done by the core team to improve build speed in recent times and if you aren’t using the latest release of your dependencies you may be leaving performance gains on the table. In our upgrade from webpack 3.0 to 3.4, we saw tens of seconds eliminated without any change to our configuration at all, and the improvements keep coming.

Upgrade regularly and keep abreast of new functionality like the parallelism mentioned earlier. At Slack we keep an eye out for releases on Github, try to contribute where we can, and follow the inimitable efforts of [webpack](https://medium.com/webpack), [babel](https://github.com/babel/notes), and others who blog about their work.

Don’t forget to keep your version of Node up to date too — packages aren’t the only avenue for improvement here.

### Invest in hardware

At the end of the day your build has to run somewhere, and on something. That something can have a great deal of impact on your overall build performance and even the most heroic effort to optimize will be met with failure if, ultimately, the build runs on prehistoric metal.

When we began our quest, our build server was a member of the C3 Amazon EC2 family. By switching to an instance type in the more recent C4 offering, where processors are faster and more plentiful, we saw a significant improvement in both build time and in the options available to us for scaling parallelism as our codebase grew. Users worried about the transition from an instance-backed machine to EBS need not despair: webpack caches file operations aggressively and we saw no measurable degradation in performance on moving to EBS.

If it is within your power (and budget) to do so, evaluate better hardware and benchmark to find the sweet spot for your configuration.

### 贡献

像 webpack 这样的基础设施项目几乎都出奇的穷; 无论是时间还是金钱，对您使用的工具做出贡献将为您和社区中的其他人改善这一工具的生态系统。Slack 最近为 webpack 项目做了捐赠，以确保团队能够继续工作，我们鼓励其他人也这样做。

贡献也可以通过反馈的形式进行。作者往往热衷于听到他们的用户提供的更多信息，了解他们需要在哪里花费最多的精力，而且 webpack 甚至鼓励用户[对核心团队的优先事项投票](https://webpack.js.org/vote/)。 如果你关心构建性能，或者你已经有了改进的想法，那就让你的声音被大家听到吧。

### 后话

webpack 是一个梦幻般的，多功能工具，不需要花费天价。这些技术帮助我们将建造时间的中位数从 170 秒缩短到了 17 秒，尽管他们为我们的工程师们提高了部署经验，但他们并不是一个已经十分完善的项目。如果您对如何进一步提高构建性能有任何想法，我们很乐意听取您的意见。当然，如果你喜欢解决这些问题[来和我们一起工作吧](https://slack.com/careers)！

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
