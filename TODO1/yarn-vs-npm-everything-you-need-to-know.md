> * 原文地址：[Yarn vs npm: Everything You Need to Know](https://www.sitepoint.com/yarn-vs-npm/)
> * 原文作者：[Tim Severien](https://www.sitepoint.com/author/tseverien/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/yarn-vs-npm-everything-you-need-to-know.md](https://github.com/xitu/gold-miner/blob/master/TODO1/yarn-vs-npm-everything-you-need-to-know.md)
> * 译者：[EmilyQiRabbit](https://github.com/EmilyQiRabbit)
> * 校对者：

# 关于 Yarn 和 npm 你所需要知道的一切

Yarn 是一个由 Facebook，Google，Exponent 和 Tilde 构建的新的 JavaScript 包管理器。正如[官方公告](https://code.facebook.com/posts/1840075619545360)所写，它的目标就是解决这些团队使用 npm 的时候所遇到的几个问题，即：

*   安装包不够快速和稳定，以及
*   存在安全隐患，因为 npm 允许包在安装的时候运行代码

但是，不必慌张！它并不是想要完全替代 npm。Yarn 仅仅是一个新的能够从 npm 注册处获取到模块的 CLI 客户端。 

应该每个人都现在就登上 Yarn 这辆快车吗？可能你在使用 npm 的时候你从没遇到过这些问题。在这篇文章中，我们将会比对 npm 和 Yarn，所以你就能够决定哪个对你来说是最好的。

![Yarn 标志](https://dab1nmslvvntp.cloudfront.net/wp-content/uploads/2016/10/1476870188yarn.jpg)

## Yarn 和 npm：功能差异

初看 Yarn 和 npm，它们很相似。但正如我们深入了解所知，Yarn 和 npm 是有所区别的。

### yarn.lock 文件

`package.json` 文件中有 npm 和 Yarn 追踪项目依赖的信息，版本号并不总是确切的。但是，你可以定义版本的范围。这样你可以选择包的最高和最低版本，但是允许 npm 安装最新的布丁，来修复一些 bug。

在 [语义版本控制](http://semver.org/) 的理想世界里，发布的补丁不应该包括任何实质性的修改。但是很不幸，这并不总是事实。npm 的策略可能会导致两台设备使用同样的 `package.json` 文件，但安装了不同版本的包，这可能导致故障。

为了避免包版本的错误匹配，在锁定文件中需要固定安装的确切版本。每次添加模块，Yarn 会创建（或更新）一个 `yarn.lock` 文件。这样你就能保证在 `package.json` 文件中定义一个可选版本范围的同时，其他设备都安装一样的包。

在 npm 命令中，`npm shrinkwrap` 同样可以生成一个锁定文件，并且 `npm install` 在读取 `package.json` 之前会先读这个锁文件，和 Yarn 会首先读取 `yarn.lock` 的方式类似。最关键的区别是，Yarn 一定会创建并更新 `yarn.lock`，但是 npm 默认不会创建，并且只会当文件 `npm-shrinkwrap.json` 存在时更新它。

1.  [yarn.lock 文档](https://yarnpkg.com/en/docs/configuration#toc-use-yarn-lock-to-pin-your-dependencies)
2.  [npm shrinkwrap 文档](https://docs.npmjs.com/cli/shrinkwrap)

### 并行安装

无论何时 npm 或者 Yarn 需要安装包，都会产出一系列的任务。使用 npm 时，这些任务按包顺序执行，也就是只有当一个包全部安装完成后，才会安装下一个。Yarn 则是并行执行任务，提高了性能。

对比来说，我同时使用 npm 和 Yarn 安装了包 [express](https://www.npmjs.com/package/express)，它们都没有 shrinkwrap 或者 lock 文件也没有缓存。这次安装一共包括 42 个包。

propertag.cmd.push(function() { proper_display('sitepoint_content_1'); });

*   npm：9 秒
*   Yarn：1.37 秒

我简直不敢相信我的眼睛。重复这个步骤的结果是相似的。然后我安装了包 [gulp](https://www.npmjs.com/package/gulp)，共下载 195 个依赖包。

*   npm：11 秒
*   Yarn：7.81 秒

看起来，下载时间的差异很大程度取决于安装的软件包的数量。但是无论那种，Yarn 都更快。

### 更清晰的输出

npm 的输出默认就很详细。例如，当运行 `npm install <package>` 的时候，它将会递归的列出所有安装了的包。而另一方面，Yarn 就很简略。它只列出很少的重要信息并配合适当的 emojis（除非你用的是 Windows 系统），而详细信息可以通过其他命令获取。

![“yarn install” 命令的输出](https://dab1nmslvvntp.cloudfront.net/wp-content/uploads/2016/10/1476651912yarn-install-output.png)

## Yarn 和 npm：CLI 的区别

除了功能上的区别，Yarn 还有一些不同的命令。去掉了一些 npm 的命令，其他的也做了修改，另外还有添加了一些有意思的命令。

### 全局 yarn

和 npm 在全局安装操作时需要使用 `-g` 或者 `--global` 标志不同，Yarn 命令需要用 `global` 作为前缀。和 npm 一样，具体项目的依赖性不应该全局安装。

`global` 前缀仅适用于 `yarn add`，`yarn bin`，`yarn ls` 和 `yarn remove`。除了 `yarn add`，这些命令都和 npm 命令一样。

1.  [yarn global 文档](https://yarnpkg.com/en/docs/cli/global)

### yarn 安装

`npm install` 命令将会依照 `package.json` 文件安装依赖，并且允许你添加新的包。`yarn install` 仅下载 `yarn.lock` 列出的依赖，如果没有该文件，则下载 `package.json` 列出的。

1.  [yarn install 文档](https://yarnpkg.com/en/docs/cli/install)
2.  [npm install 文档](https://docs.npmjs.com/cli/install)

### yarn add [–dev]

和 `npm install <package>` 类似，`yarn add <package>` 让你能添加并安装依赖。正如命令名的字面义，它能添加依赖，同时意味着它将自动的把包的引用添加到 `package.json` 文件中，和 npm 的 `--save` 标志一样。Yarn 的 `--dev` 标志会把包作为开发模式的依赖，和 npm 的 `--save-dev` 标志一样。

1.  [yarn add 文档](https://yarnpkg.com/en/docs/cli/add)
2.  [npm install 文档](https://docs.npmjs.com/cli/install)

### yarn licenses [ls|generate-disclaimer]

在写本篇文章的时候，没有等价的可用的 npm 命令。`yarn licenses ls` 能够列出所有安装包的许可协议。`yarn licenses generate-disclaimer` 能生成包括所有包的所有许可协议的免责声明。一些许可协议声明了你必须在你的项目中包含该项目协议，此时该命令就是一个很有用的工具了。

1.  [yarn licenses 文档](https://yarnpkg.com/en/docs/cli/licenses)

### yarn why

这个命令能够分析依赖图然后找出为什么指定的包会被安装到你的项目中。也许是你明确指定安装它的，或许它是你安装的包的依赖之一。`yarn why` 将帮助你查明原因。

1.  [yarn why 文档](https://yarnpkg.com/en/docs/cli/why)

### yarn upgrade [package]

这个命令将更新包到符合 `package.json` 设定规则的最新的版本，并重新创建 `yarn.lock` 文件。它和 `npm update` 类似。

有趣的是，当指定包的时候，它将会将这个包更新到最新版并更新 `package.json` 中定义的标签。这意味着这个命令可能将包更新到一个新的 major 发布。

1.  [yarn upgrade 文档](https://yarnpkg.com/en/docs/cli/upgrade)

### yarn generate-lock-entry

`yarn generate-lock-entry` 命令将生成一个 `yarn.lock` 文件，它是基于 `package.json` 中的依赖设定的。这和 `npm shrinkwrap` 很类似。使用这个命令要谨慎，因为它将生成锁定文件，并且当你通过 `yarn add` 和 `yarn upgrade` 更新依赖的时候，它会自动更新。

1.  [yarn generate-lock-entry 文档](https://yarnpkg.com/en/docs/cli/generate-lock-entry)
2.  [npm shrinkwrap 文档](https://docs.npmjs.com/cli/shrinkwrap)

## 稳定性和可靠性

Yarn 的快车可能脱轨吗？在发布的第一天，它确实收到了很多[问题反馈](https://github.com/yarnpkg/yarn/issues)，但是解决问题的比率同样惊人。这都意味着社区在努力寻找并解决问题。看看这些问题的数量和种类后我们知道，Yarn 对于大多数用户都是更加稳定的，但是对于一些边缘情况，可能就不太适合了。

注意，尽管可能包管理对于你的项目非常重要，它也仅仅是一个包管理器。如果真的有什么问题出现了，重装包并不难，切回使用 npm 也不难。

## 展望将来

也许你知道 Node.js 和 io.js 的历史。概括的说，io.js 是 Node.js 的一个分叉，由于 Node.js 项目的管理出现了分歧，一些核心贡献者就创建了 io.js。但是，io.js 选择了开源。不到一年的时间，两个团队又达成了一致，于是 io.js 又合并回了 Node.js，io.js 的研发也就不再进行了。忽略对与错，这件事的结果是为 Node.js 引入了很多很棒的功能。

我现在在 npm 和 Yarn 上看到了类似的模式。尽管 Yarn 不是一个分叉，但是它改进了数个 npm 的漏洞。如果 npm 从中学习，并要求 Facebook，Google 以及其他 Yarn 贡献者转而帮助 npm 优化，这不是很好的事情吗？尽管现在这样说有些早了，但是我希望如此。

不管怎样，Yarn 的未来都是光明的。这个新的包管理器的出现让社区里的人都感到很兴奋，并且人们也渐渐接受了它。不幸的是，它没有任何规划说明，所以我也不知道 Yarn 会给我们准备什么惊喜。

## 总结

和 npm 相比，Yarn 的评分更高。我们可以自由的获取锁定文件，安装包的速度也惊人的快，而且它们会被自动的保存到 `package.json`。安装并使用 Yarn 的缺点也很少。你可以先在一个项目中试用它，看看是否适合于你。这样，Yarn 就成为了 npm 一个替代品。

propertag.cmd.push(function() { proper_display('sitepoint_content_2'); });

我强烈推荐你在一个项目中试试看 Yarn。如果你对于安装和使用新的软件很谨慎，也请给它几个月的时间。毕竟，npm 是经过实战检验的，这在软件开发的世界中，绝对值得。

如果你正巧在等着 npm 安装包，也许正好可以读一读[迁移到 Yarn 的指南](https://yarnpkg.com/en/docs/migrating-from-npm) ;)

你怎么想？你已经在使用 Yarn 了吗？你愿意尝试吗？或者你认为这仅会导致一个已经很分散的生态圈的进一步分裂？请在评论区写下你的看法。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
