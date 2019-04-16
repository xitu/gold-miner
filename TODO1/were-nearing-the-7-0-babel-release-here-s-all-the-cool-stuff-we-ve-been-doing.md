> * 原文地址：[We’re nearing the 7.0 Babel release. Here’s all the cool stuff we’ve been doing.](https://medium.freecodecamp.org/were-nearing-the-7-0-babel-release-here-s-all-the-cool-stuff-we-ve-been-doing-8c1ade684039)
> * 原文作者：[Henry Zhu](https://medium.freecodecamp.org/@left_pad?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/were-nearing-the-7-0-babel-release-here-s-all-the-cool-stuff-we-ve-been-doing.md](https://github.com/xitu/gold-miner/blob/master/TODO1/were-nearing-the-7-0-babel-release-here-s-all-the-cool-stuff-we-ve-been-doing.md)
> * 译者：[xueshuai](https://github.com/xueshuai)
> * 校对者：[Colafornia](https://github.com/Colafornia)

# Babel 7.0 版本将带来的很酷的事情

![](https://cdn-images-1.medium.com/max/1000/1*vLtFVPTHJGDfw3XOl4C1Sw.jpeg)

图片来自 [“My Life Through A Lens”](https://unsplash.com/photos/bq31L0jQAjU?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)，发布于 [Unsplash](https://unsplash.com/search/photos/change?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)

来看这👋！我是 [Henry](http://twitter.com/left_pad)，[Babel](http://babeljs.io) 的维护者之一。

> 编辑：我已经离开了 [Behance](https://www.henryzoo.com/blog/2018/02/15/leaving-behance.html) 并制作了 [Patreon](https://www.patreon.com/henryzhu)，尝试 [全职投入到开源工作上](https://www.henryzoo.com/blog/2018/03/02/in-pursuit-of-open-source-part-1.html)，请你或你的公司考虑捐献。

#### Babel 简介

有些人可能把 Babel 看作是一个让你写 ES6 代码的工具。更准确的说，Babel 是把 ES6 代码转换为 ES5 代码的 JavaScript 编译器。当它的名字是 6to5 时，这很适合，但是我认为 Babel 已经变得不只是这些了。

现在让我们聊一些背景。这一点非常必要，因为不像运行在服务器上的其他语言（甚至是  Node.js），你能运行的的 JavaScript 版本取决于你的浏览器的特定版本。如果你使用最新的浏览器，而你的用户（你想留住的）仍然使用 IE，是没有关系的。但是，举个例子，如果你想写 `class A {}` ，那么你就很不幸了 - 你的一些用户将会得到一个 `SyntaxError` 和一个空白页面。

所以这就是创建 Babel 的原因。它允许你写你想写的 JavaScript 版本，你知道它会在你支持的所有（更老）的浏览器上正确的运行。

但是，它并不停止于 “ES6”（有些人喜欢说 ES2015）。Babel 已经确实扩展了他的最初目标，即只编译 ES6 代码。现在，它能够编译任意一个你想要的 ES20XX 版本（JavaScript 最新版本）到 ES5.

#### 正在进行的进程

关于这个项目的一个有趣的事情是，只要 JavaScript 语法被加进去，Babel 就需要实现一个转换器去转化它。

但是你可能会想，为什么我们要给已经支持该语法的浏览器发送一个编译过的版本（更大的代码体积）？我们怎么知道每个浏览器支持什么语法？

好了，我们制作了一个让你能够指定你支持哪个浏览器的工具 [babel-preset-en](https://babeljs.io/docs/plugins/preset-env)，来帮助解决这个问题。它将会自动地只转换那些浏览器原生不支持的东西。

除此之外，Babel（因为它在社区的使用）能够影响 JavaScript 语言自身的未来。鉴于它是用于转换 JS 代码的工具，它也可以用于实现提交给 [TC39](http://2ality.com/2015/11/tc39-process.html) 的任何提案（Ecma Technical Committee 39，一个使 JavaScript 作为标准向前发展的组织）。

一个 “提案” 进入到语言中会经历从 Stage 0 到 Stage 4 的一个完整流程。Babel，作为一个工具，在正确的地方测试新的想法并且让开发者在他们的应用中使用它，以便他们可以向委员会提供反馈。

出于以下原因，这一点非常重要：委员会想确信他们做出的更改是社区想要的（一致，直观，有效）。在浏览器里实现一个不明的想法是缓慢的（浏览器中的 C++ 对比 Babel 中的 JavaScript），昂贵的，并且要求用户在浏览器中使用一个标志，而不是更改他们的 Babel 配置文件。

因为 Babel 已经非常普及了，这是有一个好的机会使真正的用途出现。这将使提案比那个没有广大社区开发者反馈的实现更好。

而且他不只是在产品中有用。我们的在线 [REPL](https://babeljs.io/repl) 对人们学习 JavaScript 有帮助，并且允许他们测试东西。

我认为 Babel 是一个能够让程序员们了解 JavaScript 如何工作的非常好的工具。通过给这个项目做贡献，他们将会学习很多其他的概念，例如 AST，编译器，语言规范等等。

我们真的对这个项目的未来很兴奋，并且迫不及待的要知道这个团队能够走到哪里。请加入并帮助我们！

#### 我的故事

这里有一些我希望每天都工作在这个项目上的原因，特别是作为一个维护者。大多数当前的维护者，包括我自己，并不是创建这个项目的人，而是在一年之后加入的 - 想起我开始的地方仍然很[兴奋](https://medium.com/@left_pad/ossthanks-some-thoughts-d0267706c2c6)。

至于我，我认识到一个需求和一个有趣的项目。我慢慢并持续地有更多的参与，现在我已经能够有了我的雇主，[Behance](https://www.behance.net/)，资助我一半的时间工作在 Babel 上。

有时候“维护”只是意味着修复 bugs，在 Slack 或 [Twitter](https://twitter.com/babeljs/) 上回答问题，或是编写更新日志（这真的取决于我们每一个人）。但是最近，我已经减少了在 bug 修复和特性上的注意力。取而代之的是我把时间放在了思考更多高层次的问题上，例如：这个项目的未来是什么？我们如何就维护者与用户的数量而言，使我们的社区增长。我们如何在资金方面维持这个项目？我们如何整体的融入 JavaScript 生态系统（教育，[TC39](https://github.com/tc39/proposals)，工具）？这里有没有一个适合我们的角色来帮助新人加入开源项目（[RGSoC](https://twitter.com/left_pad/status/959439119960215552) 和 [GSoC](https://summerofcode.withgoogle.com/)）？

因为这些问题，这个版本最让我感到兴奋的地方不是那些特性（有很多：初步实施的新提案比如 [Pipeline Operator (a |> b)](https://github.com/babel/babel/tree/master/packages/babel-plugin-proposal-pipeline-operator)，有 TS 团队提供帮助的 [new TypeScript preset](https://github.com/babel/babel/tree/master/packages/babel-preset-typescript) 和 .babelrc.js 文件）。

而是我对这些特性所代表的东西更兴奋：一年来不懈的努力不去打破一切，平衡用户的期望（为什么构建这么慢/代码输入这么大，为什么代码没有足够的兼容，为什么这个工作不能没有配置，为什么这里没有一个对其他情况的选择）和维持一个由志愿者组成的坚实团队。

并且我知道我们的行业对“主要版本”有一个很大的关注，大肆宣传特性和 stars，但那只是一个衰落的日子。我想建议我们继续想一想什么使生态系统以一个健康的方式持续向前推进。

这可能仅仅意味着思考维护者的心理和情绪上的负担。这可能意味着思考如何提供指导，期望管理，平衡工作/生活的建议和其他的人们想要加入的资源，而不只是鼓励开发者来期待即时的，免费的帮助。

#### 深入更新日志

嗯，我希望你能享受这个长的更新日志 😊。如果你对帮助我们感兴趣，请让我们知道，我们将很乐意多谈。

![](https://cdn-images-1.medium.com/max/800/0*zvhm_vD3VWFaWA1c.png)

因为人们想更多地了解关于 Babel 如何工作和回馈，我们开放了一个新的 [视频页面](https://babeljs.io/docs/community/videos/)。这个页面包含了 Babel 会议谈话的视频，来自团队成员和社区人们的相关概念。

![](https://cdn-images-1.medium.com/max/800/0*8q5nV1APkAFKydrZ.png)

我们同样创建了一个新的 [团队页面](https://babeljs.io/team)！我们将在未来使用更多的关于人们在做什么工作和为什么他们加入的信息来更新这个页面。对于一个这样大的项目，这里有很多方法参与其中并帮忙。

这有一些亮点和简短的事实：

*   Babel 在 [2017 年 10 月 28 日](https://babeljs.io/blog/2017/10/05/babel-turns-three) 已经 3 岁了！
*   Daniel 把 `babel/babylon` 和 `babel/babel-preset-env` [移动到](https://twitter.com/left_pad/status/926096965565370369) 主要的 Babel monorepo 里，[babel/babel](https://github.com/babel/babel)。这包含 Git 历史，标签和提案。
*   我们从 Facebook Open Source 收到了 [每月 1000 美元的捐赠](https://twitter.com/left_pad/status/923696620935421953)！
*   这是我们从一开始收到的最高的月度捐赠（下一个是 100 美元/月）。
*   同时，我们将用我们的资金去亲自会见，并派人去 TC39 会议。这些会议每隔 2 个月在世界各地举行。
*  如果一个公司想制定赞助什么，我们能创建一个单独的议题来跟踪。这在之前是困难的，因为我们必须用从口袋掏钱支付，或者在同一周找到一个会议发言来帮助支付费用。

#### 你怎么才能帮忙

如果你的公司愿意通过支持一个 JavaScript 开发的基础部分和他的未来作为 **回报**，考虑一下给我们的 [Open Collective](https://opencollective.com/babel) 捐献。你也能贡献开发时间来帮助维护这个项目。

#### #1：帮助维护项目（工作中开发人员的时间）

![](https://i.loli.net/2018/05/10/5af3a5e7b9a3f.png)

对 Babel 最好的事情就是找愿意帮助项目的人，他们能够承担大量的工作并对需求负责。再说一下，[我从来没觉得准备好](https://dev.to/hzoo/im-the-maintainer-of-babel-ask-me-anything-282/comments/1k6d) 成为一个维护者，但不知道怎么的，就发现已经这样了。但是我只是一个人，并且我的团队只有少数几个人。

#### #2：帮助资助开发

![](https://i.loli.net/2018/05/10/5af3a5e8009bc.png)

我无疑是想能够给团队的人资金使他们能够全职工作。尤其是 Logan，不久以前离开了他的工作并且用我们的资金来进行 Babel 的兼职工作。

#### #3 从其他渠道做贡献

例如，[Angus](https://twitter.com/angustweets) 给我们制作了一个 [官方歌曲](https://medium.com/@angustweets/hallelujah-in-praise-of-babel-977020010fad)！

#### 升级

我们也将升级帮助你 [重写你的 package.json/.babelrc 文件](https://github.com/babel/notes/issues/44) 的工具和其他更多的东西。 理想情况下，这意味着它将修改任何必要的版本号变更，包的重命名和配置的变更。

当尝试更新的时候，请伸出手来帮助并发布议题。这是一个参与其中并帮助生态系统更新的绝好的机会。

#### [前一个发布](https://babeljs.io/blog/2017/09/12/planning-for-7.0) 总结

*   放弃对 Node 0.10/0.12/5 的支持
*   更新 [TC39 提案](https://github.com/babel/proposals/issues)
*   数字分隔符： `1_000`
*   可选的链接操作符： `a?.b`
*   `import.meta` （可解析）
*   可选的 Catch 绑定：`try { a } catch {}`
*   BigInt（可解析）：`2n`
*   分割导出扩展到 `export-default-from` 和 `export-ns-form`
*   支持 `.babelrc.js`（使用 JavaScript 代替 JSON 的配置）
*   增加一个新的 Typescript Preset 和拆分 React/Flow presets
*   增加 [JSX 分段支持](https://reactjs.org/blog/2017/11/28/react-v16.2.0-fragment-support.html) 和 各种 Flow 更新
*   为了更小的体积，删除内部 `babel-runtime` 依赖

#### 最新更新的 TC39 提案

*   Pipeline 操作符：`a |> b`
*   Throw 表达式：`() => throw 'hi'`
*   无效合并操作符：`a ?? b`

#### 弃用年份 presets（例如，babel-preset-es20xx）

注意：使用 `babel-preset-env`：

这比你决定使用哪个 Babel preset 更好的地方是什么？已经为你完成了，自动地！

尽管维护数据列表的工作量很大 - 再一次，我们需要帮助 - 它解决了很多问题。它确保了用户能够及时了解规范。它意味着较少的配置/包的混乱。它意味着一个简单升级之路。并且它意味着更少的什么是什么的问题。

`babel-preset-env` 其实是一个很 _老_ 的 preset，它代替了每个其他的你将需要的（es2015，es2016，es2017，es20xx，latest 等等）句法 preset。

![](https://cdn-images-1.medium.com/max/800/0*wgAjmRI1MVcI_Veg.png)

它代替了所有的老的 presets 来编译最新年度的 JavaScript 版本（Stage 4 里的无论什么）。但是它也有能力根据你指定的目标环境编译：它能够处理开发模式，比如最新版本的浏览器，或是多重构建，例如 IE 版本。 它甚至有另一个为了流行多年的浏览器提供的版本

#### 没有移除 Stage presets（babel-preset-stage-x）

![](https://i.loli.net/2018/05/10/5af3a6239956e.png)

我们可以随时更新它，或许我们只需要决定一个比当前 presets 更好的系统。

现在，stage presets 只是我们在每个 TC39 会议后手动更新的插件列表。要使这个可管理，我们需要允许主要的版本为这些“不稳定”的包做缓冲。这是一部分，因为委员会无论怎样都将重建这些包。所以我们可能会从一个官方包做这件事，并且之后我们有能力提供过更好的消息等等。

#### 重命名：Scoped Packages（`@babel/x`）

这里是一个大约一年前我发布的投票：

![](https://i.loli.net/2018/05/10/5af3a6402f8b7.png)

那时候，没有很多项目使用 scoped packages，所以很多人甚至不知道它们的存在。那时候你可能必须为了一个 npm org 的账户花钱，而现在它是免费的（并且支持也 non-scoped packages）。

搜索 scoped packages 的问题已经被解决了，下载计数也已经生效。唯一一个绊脚石就是一些第三方注册仍然不支持 scoped packages。但是我想我们现在正处于一个点，在这里看起来等待很不合理。

为什么我们更喜欢 scoped packages：

*   命名困难：我们不需要去检查别人是否决定在他们的插件上使用我们的命名惯例
*   在 package squatting 上我们有类似的问题
*   有些时候人们创建 `babel-preset-20xx` 或是其他的包是因为好玩。我们必须发布一个议题，并且发邮件把它要回来
*   有人有一个合法的包，但是它恰好和我们想叫的名字是一样的
*   有人看到一个新的提案正在 merging（像 optional chaining 或者 pipeline 操作符），并且决定使用同样的名字来 fork 和 publish。然后，当我们发布的时候，我们就被告知包已经被发布了 🤔。所以我必须找到他们和 npm 支持团队双方的电子邮件，把包拿回来再重新发布。
*   同一个名字下，什么是“官方”包，什么是用户/社区包？我们收到了有些人使用错误的名字或者非官方包的问题报告，原因是他们以为这是 Babel 的一部分。关于这个一个例子是有一份报告说 `babel-env` 重写了他们的 `.babelrc` 文件。他们花了一些时间才意识到它不是 `babel-preset-env`。

所以，这已经很清楚了，我们应该使用 scoped packages，并且，不论什么，我们应该快一些完成它！

scoped name 更改的例子:

*   `babel-cli` -> `@babel/cli`
*   `babel-core` -> `@babel/core`
*   `babel-preset-env` -> `@babel/preset-env`

#### 重命名：`-proposal-`

现在任何提案都将被以 `-proposal-` 命名来标记他们还没有在 JavaScript 官方之内。

所以 `@babel/plugin-transform-class-properties` 变成 `@babel/plugin-proposal-class-properties`，当它进入 Stage 4 后，我们会把它命名回去。

#### 重命名：把插件名字里的年份去掉

之前的 plugins 名字里有年份，但是现在似乎并不是必须的。

所以 `@babel/plugin-transform-es2015-classes` 变成 `@babel/plugin-transform-classes`。

因为年份只是用于 es3/es2015，我们没有从 es2016 或 es2017 里改变任何东西。无论怎样，我们将那些 presets 设置为 preset-env，并且，对于字面模板调整，我们只是简单地把它添加到字面模板转换里。

#### Peer dependencies 和 integrations

我们介绍一下 `@babel/core` 上的 peer dependencies，用于所有的 plugins（`@babel/plugin-class-properties`），presets（`@babel/preset-env`）和 top level packages（`@babel/cli`，`babel-loader`）

> peerDependencies 是被你的代码期望使用的依赖，与只被用于实现细节的 dependencies 相反。- [Stijn de Witt 在 StackOverflow 上的回答](https://stackoverflow.com/a/34645112)

`babel-loader` 在 `babel-core` 上 已经有一个 `peerDependency` 了，所以这个只是把它变成了 `@babel/core`。这个改变阻止了人们尝试去安装这些 Babel 包的错误版本。

对于在 `babel-core` 已经有 `peerDependency` 和没有准备好主要更新（因为改变 peer dependency 是一个 breaking change）的工具，我们已经发布了一个新版本的 `babel-core` 来桥接新版本上的改变 [babel-core@7.0.0-bridge.0](https://github.com/babel/babel-bridge)。想获得更多地信息，查看 [这个议题](https://github.com/facebook/jest/pull/4557#issuecomment-344048628)。

类似的，像 `gulp-babel`，`rollup-plugin-babel` 等等的包都曾经把 `babel-core` 作为一个 dependency。现在，这些将仅仅在 `@babel/core` 上有 `peerDependency`。因为这个，这些包没有必要在 `@babel/core` API 改变的时候升级主要版本

#### [#5224](https://github.com/babel/babel/pull/5224)：独立发布 experimental packages

我在 [Babel 的状态](http://babeljs.io/blog/2016/12/07/the-state-of-babel) 的 `Versioning` 部分提到过这个。这里是 [Github Issue](https://github.com/babel/babylon/issues/275)。

你可能记得在 Babel 6 之后，Babel 变成了一个拥有它自己的生态系统的一套 npm 包，这个生态系统有 custom presets 和 plugins。

然而，从那以后，我们一直使用一个 “fixed/synchronized” 的版本系统（所以没有包是在 v7.0 或者是以上的）。当我们做一个新的发布，例如 `v6.23.0`，只有源代码更新过的包才会随着新版本一起被发布。其余的包保持原样。这在实践中大多是管用的，因为我们在我们的包中使用了 `^`。

不幸的是，当一个包需要发布一个主版本时，这种系统需要为所有的包都发布一个。这要不意味着我们做了很多小的 breaking changes（不必要的），要不就意味着我们我们打包了很多 breaking changes 到一个发布中。相反，我们想把 experimental packages（Stage 0 等等）和 所有其他的（es2015）区分开。

因为这个，当规范变化时，我们打算将所有的 experimental proposal plugins 的主版本迭代，而不只是等待去更新所有的 Babel。所以，任何 Stage 4 之前的东西都将以主版本迭代的形式开放给 breaking changes。Stage presets 自身也是一样的（如果我们不把他们整个扔掉）。

与这个随之而来的是我们要求 TC39 提案使用 `-proposal-` 的名字的决定，我们将对插件及其所属的 preset 做一个主版本迭代（而不是只做一个可能让人失望的补丁版本）。然后，我们将需要弃用旧的版本，并且建立一个不管规范变成什么样子都将自动更新使人们保持最新的框架（并使他们不被什么东西卡住。我们没有像 decorators 那么幸运。）。

#### `.babelrc` 中的 `env` 选项没有没弃用

不像[最后一个提交](https://babeljs.io/blog/2017/09/12/planning-for-7.0#deprecate-the-env-option-in-babelrc)，我们只是修复了合并的行为来使其[更兼容](https://twitter.com/left_pad/status/936687774098444288)

`env` 中的配置被赋予了比根配置项更高的优先级。并且现在根据它们的标识来合并，而不是只是同时使用 plugins 和 presets 这种奇怪的实现，所以现在我们可以这样做：

```
{  presets: [    ['env', { modules: false}],  ],  env: {    test: {      presets: [         'env'      ],    }  },}
```

有了 `BABEL_ENV=test`，它将使用没有选项的 test 中的配置来替换根环境配置。

#### 支持 `[class A extends Array](https://twitter.com/left_pad/status/940723982638157829)` (最早的警告)

Babel 将自动包含像 `Array`， `Error` 和 `HTMLElement` 的原生 built-ins，所以做这个会在编译 classes 的时候生效。

#### 速度

*   很多来自 v8 团队 [bmeurer](https://twitter.com/bmeurer) 的[修复](https://twitter.com/rauchg/status/924349334346276864)！
*   通过 [web-tooling-benchmark](https://github.com/v8/web-tooling-benchmark) [https://twitter.com/left_pad/status/927554660508028929](https://twitter.com/left_pad/status/927554660508028929) 提速 60%

#### preset-env：`"useBuiltins"："usage"`

`babel-preset-env` 介绍了编译语法到不同的目标的想法。它同时介绍了通过 `useBuiltIns` 选项，只为目标添加不支持的 polyfills 的能力。

所以有了这个选项，一些事情比如：

```
import "babel-polyfill";
```

能够变成

```
import "core-js/modules/es7.string.pad-start";import "core-js/modules/es7.string.pad-end";// ...
```

如果目标环境恰巧支持 `padStart` 或 `padEnd` 之外的 polyfills。

但是为了使它更好，我们应该仅仅引入代码库自身“使用”的 polyfills。如果它在代码中没有使用 `padStart`，为什么引入？

`"useBuiltins": "usage"` 是我们解决那个想法的第一次尝试。它在每个文件的头部执行了一个引入，但是只有在找到它在代码中被使用的时候才添加引用。这个实现意味着我们能够为应用引入最小量的，必须的 polyfills（并且只有在目标环境不支持它的时候）。

所以如果你在代码中使用 `Promise`，它将在文件的头部引入它（如果你的目标不支持它）。如果它是重复的，Bundlers 将会删除重复的部分，所以这个实现不会造成 polyfills 的多重引用。

```
import "core-js/modules/es6.promise";var a = new Promise();
```

```
import "core-js/modules/es7.array.includes";[].includesa.includes
```

通过类型推断我们能知道一个像 `.includes` 的实例是否是一个 array。在逻辑变得更好之前，得到一个 false positive 是可以的，因为它仍旧是优于之前引入整个 polyfill 的。

#### 其他更新

*   `[babel-template](https://github.com/babel/babel/blob/master/packages/babel-template)` 更快并且用起来更简单
*   [regenerator](https://github.com/facebook/regenerator) 在 [MIT 证书](https://twitter.com/left_pad/status/938825429955125248)下发布 - 它是用来编译 generators/async 的依赖
*   通过 [#6952](https://github.com/babel/babel/pull/6952) 的 `modules-commonjs` plugin 的 “lazy” 选项
*   你现在能在 .babelrc 中使用 `envName: "something"` 或者 在命令行输入 `babel --envName=something` 来取代必须使用`process.env.BABEL_ENV` 或 `process.env.NODE_ENV`
*   `["transform-for-of", { "assumeArray": true }]` 来使所有的 for-of 循环按照规则数组输出
*   为了 preset-env [#6831](https://github.com/babel/babel/pull/6831)，在松散模式中排除 `transform-typeof-symbol`
*   [实现 PR 来获得更好的语法错误消息](https://twitter.com/left_pad/status/942859244759666691)

#### 发布之前需要做的

*   [Handle](https://github.com/babel/babel/issues/6766) `[.babelrc](https://github.com/babel/babel/issues/6766)` [lookup](https://github.com/babel/babel/issues/6766)（想在第一次 RC 发布之前完成）
*   [“overrides” support](https://github.com/babel/babel/pull/7091)：基于全局模式的差异配置
*   babel-core 中的缓存和无效逻辑
*   围绕外部 helpers 的更好的 story。
*   对于迭代和处理 independently 对于 helpers 的独立性，实现它或者是有一个成熟的计划，所以我们不是明确的与 core-js 2 或 3 绑定。人们可能有东西依赖于一个或者其他，并且不想同时加载两者太多。
*   不管是一个[working decorator 的实现](https://github.com/babel/babel/pull/6107)，或者是 functional legacy 的实现，在 7.x’s 的有效期内，有一个明确的路径实现当前标准的行为。

#### 感谢

向我们的志愿者团队致意：

[Logan](https://twitter.com/loganfsmyth) 已经很努力的推进修复很多我们关于配置及更多的核心问题。他就是那个做了所有困难工作的人。

[Brian](https://twitter.com/existentialism) 已经接管很多 preset-env 的维护工作，无论以前我做过什么 😛

[Daniel](https://twitter.com/TschinderDaniel) 一直在我们需要的帮助的时候介入，不管是维护 babel-loader 或是帮助迁移 babylon/babel-preset-env 库。同样的，[Nicolo](https://twitter.com/NicoloRibaudo)，[Sven](https://twitter.com/svensauleau)，[Artem](https://twitter.com/yavorsky_) 和 [Diogo](https://twitter.com/kovnsk)，在上一年帮助做了更多。

我真的很期待一个发布（我也累了 - 已经快一年了 😝）。但是我也不想催促任何东西，因为在这个版本中已经有很多的起伏了。我确实学到了很多东西，我相信团队的其他成员也是如此。

如果我今年学到了什么，我应该真正的听从这个建议而不只是写下来。

![](https://i.loli.net/2018/05/10/5af3a67ab1365.png)

> 同样感谢 [Mariko](https://twitter.com/kosamari) 的[轻推](https://twitter.com/kosamari/status/944272286055530496)，实际完成了这个发布（两个月的制作）。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
