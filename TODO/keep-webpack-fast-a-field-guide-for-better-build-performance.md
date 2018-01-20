> * 原文地址：[Keep webpack Fast: A Field Guide for Better Build Performance](https://slack.engineering/keep-webpack-fast-a-field-guide-for-better-build-performance-f56a5995e8f1)
> * 原文作者：[Rowan Oulton](https://slack.engineering/@rowanoulton?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/keep-webpack-fast-a-field-guide-for-better-build-performance.md](https://github.com/xitu/gold-miner/blob/master/TODO/keep-webpack-fast-a-field-guide-for-better-build-performance.md)
> * 译者：
> * 校对者：

# Keep webpack Fast: A Field Guide for Better Build Performance

[webpack](https://webpack.js.org/) is a brilliant tool for bundling frontend assets. When things start to slow down, though, its batteries-included nature and the ocean of third-party tooling can make it difficult to optimize. Poor performance is the norm and not the exception. But it doesn’t have to be that way, and so — after many hours of research, trial, and error — what follows is a field guide offering up what we learned on our path towards a faster build.

![](https://cdn-images-1.medium.com/max/800/1*n7SFvwKvpLsW0ZcEDbgBtg.jpeg)

The build tools of yore: a Loom with Jacquard machine attached.

### In the land before time

2017 was an ambitious year for the frontend team at Slack. After a few years of rapid development, we had a lot of technical debt and plans to modernize on a grand scale. Top of mind: rewriting our UI components in React and making wide use of modern JavaScript syntax. Before we could hope to achieve any of that, though, we needed a build system capable of supporting a nebula of new tooling.

Up to this point, we’d survived with little more than file concatenation, and while it had gotten us this far it was clear it would get us no further. A real build system was needed. And so, as a powerful starting point and for its community, familiarity, and feature set, we chose webpack.

For the most part our transition to webpack was smooth. Smooth, that is, until it came to build performance. Our build took minutes, not seconds: a far cry from the sub-second concatenation we were used to. Slack’s web teams deploy up to 100 times on any given work day, so we felt this increase acutely.

Build performance has long been a concern among webpack’s user base and, while the core team has worked furiously over the past few months to improve it, there are many steps you can take to improve your own build. The techniques below helped us reduce our build time by a factor of 10, and we want to share them in case they help others.

### Before you begin, measure

It’s crucial to understand where time is being spent before you attempt to optimize. webpack isn’t forthcoming with this information but there are other ways to get what you need.

#### The node inspector

Node ships with an [inspector](https://nodejs.org/en/docs/inspector/) that can be used to profile builds. Those unfamiliar with performance profiling need not be discouraged: Google has worked hard to explain how to do so in [great detail](https://developers.google.com/web/tools/chrome-devtools/evaluate-performance/reference). A rough understanding of the phases of a webpack build will be of great benefit here and while [their documentation](https://webpack.js.org/concepts/) covers this in brief you may find it just as effective to read through some of the [core](https://github.com/webpack/webpack/blob/0975d13da711904429c6dd581422c755dd04869c/lib/Compiler.js) [code](https://github.com/webpack/webpack/blob/b597322e3cb701cf65c6d6166c39eb6825316ab7/lib/Compilation.js).

Note that if your build is sufficiently large (think hundreds of modules or longer than a minute), you may need to break your profiling into sections to prevent your developer tools from crashing.

#### Long-term logging

Profiling helped us identify the slow parts of our build up front, but it wasn’t well suited to the observation of trends over time. We wanted each build to report granular timing data so that we could see how much time was spent in each of our expensive steps (transpilation, minification, and localization) and to determine whether our optimizations were working.

For us, the bulk of the work was done not by webpack itself but by the scores of loaders and plugins we relied on. By and large, these dependencies didn’t provide granular timing data, and while we would love to see webpack adopt a standardized way for third-parties to report this kind of information, we found we had to hand-roll some extra logging in the meantime.

For loaders, this meant forking our dependencies. Although this is not a great strategy long-term, it was incredibly useful for us to decipher slowness while we worked on optimization. Plugins, on the other hand, were much easier to profile.

#### Measuring plugins on the cheap

Plugins attach themselves to [events](https://webpack.js.org/contribute/writing-a-plugin/) which correlate to the different phases of the build. By measuring the duration of these phases, we could roughly measure the execution time of our plugins.

[UglifyJSPlugin](https://github.com/webpack-contrib/uglifyjs-webpack-plugin) is an example of a plugin where this technique can be effective, as the bulk of its work is done during the [optimize-chunk-assets](https://github.com/webpack-contrib/uglifyjs-webpack-plugin/blob/d81ef5ac71481b9d5ba2055d55b27c7e18258739/src/index.js#L101) phase. Here’s a crude example of a plugin that measures this:

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

Example of a plugin that crudely measures the execution time of UglifyJSPlugin. Take care to understand which phases your plugins execute in, as there may be overlap.

Add it to your list of plugins, ahead of UglifyJS, and you’re good to go:

```
const CrudeTimingPlugin = require('./crude-timing-plugin');

module.exports = {
	plugins: [
		new CrudeTimingPlugin(),
		new UglifyJSPlugin(),
	]
};
```

The value of this information vastly outweighs the nuisance of getting it, and once you understand where the time is spent you can work to reduce it effectively.

### Parallelize

A lot of the work webpack does lends itself naturally to parallelism. Dramatic gains can be had by fanning out the work to as many processors as possible, and if you have CPU cores to burn, now’s the time to burn them.

Fortunately, there are a slew of packages built for this purpose:

* [parallel-webpack](https://github.com/trivago/parallel-webpack) will perform whole webpack builds in parallel. We use this at Slack to produce assets for our five supported languages
* [happypack](https://github.com/amireh/happypack) will execute loaders in parallel as will [thread-loader](https://github.com/webpack-contrib/thread-loader), an equivalent written and maintained by the core webpack team. These pair well with babel-loader and other transpilers
* Users of the UglifyJS plugin can make use of the recently added [parallel option](https://github.com/webpack-contrib/uglifyjs-webpack-plugin#options)

Be warned that there is a non-trivial cost to spinning up new threads. Apply them judiciously and only for operations that are costly enough to warrant it based on your profiling.

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

### Contribute

Infrastructure-level projects like webpack can be surprisingly under-funded; whether it’s with time or with money, contributing to the tools you use will do much to improve the ecosystem for you and everyone else in the community. Slack recently donated to the webpack project to make sure the team is able to continue their work, and we encourage others to do the same.

Contribution can come in the form of feedback, too. Authors are often keen to hear more from the users of their software, to understand where their efforts are best spent, and webpack has gone so far as to encourage users to [vote on the core team’s priorities](https://webpack.js.org/vote/). If build performance is a concern to you, or you have ideas for how to improve it, let your voice be heard.

### Last words

webpack is a fantastic, versatile, tool that does not need to cost the earth. These techniques have helped us reduce our median build time from 170 to 17 seconds and, while they have done much to improve the deployment experience for our engineers, they are by no means a complete work. If you have any thoughts on how to improve build performance further, we’d love to hear from you. And, of course, if you delight in solving these sorts of problems, [come and work with us](https://slack.com/careers)!

A huge thank you to Mark Christian, Mioi Hanaoka, Anuj Nair, Michael “Z” Goddard, Sean Larkin and, of course, Tobias Koppers for their contributions to this post and to the webpack project.

### Further reading

* [Build performance](https://webpack.js.org/guides/build-performance/), an article from the official webpack documentation
* [How we improved webpack build performance by 95%](https://blog.box.com/blog/how-we-improved-webpack-build-performance-95/) by Wenbo Yu
* [webpack on twitter.com](https://alunny.com/articles/webpack-on-twitter-com/) by Andrew Lunny
* [The official webpack blog](https://medium.com/webpack)
* [How webpack works](https://raw.githubusercontent.com/sokra/slides/master/data/how-webpack-works.pdf) slides from a talk by Tobias Koppers at [EnterJS](https://www.enterjs.de)

Thanks to [Matt Haughey](https://medium.com/@mathowie?source=post_page).


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
