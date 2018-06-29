> * 原文地址：[To Yarn and Back (to npm) Again](https://mixmax.com/blog/to-yarn-and-back-again-npm)
> * 原文作者：[Spencer Brown](http://spencer.sx/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/to-yarn-and-back-again-npm.md](https://github.com/xitu/gold-miner/blob/master/TODO1/to-yarn-and-back-again-npm.md)
> * 译者：[DM.Zhong](https://github.com/zhongdeming428)
> * 校对者：[Starriers](https://github.com/Starriers)

# 将项目迁移到 Yarn 然后又迁回 npm

去年，[我们决定将所有 JavaScript 项目从 npm 迁移到 Yarn](https://mixmax.com/blog/yarn-ifying-mixmax)。

之所以这样做，有以下两个主要原因：

*   `yarn install` 比 `npm install` 快 20 倍。`npm install` 在我们的一些大型项目中往往需要消耗 20 分钟。
*   Yarn 的依赖锁定比 npm 的更加可靠。

查看去年的一篇博客（链接在上方给出了）可以了解更多。

## 使用 Yarn 的 13 个月

Yarn 解决了我们在使用 npm 时所遇到的一些烦人的问题，但是它自身也带来了许多的问题：

*   Yarn 出现了[非常不好的回归](https://github.com/yarnpkg/yarn/issues/3765)，这让我们不太敢升级它。
*   Yarn 经常会在你运行 `add`，`remove` 或者 `update` 的时候生成无效的 `yarn.lock` 文件。这就使得开发者在进行`移除`和`添加`有冲突的包时会做一些冗余的工作，直到 Yarn 找出解决方案以使得 `yarn check` 能够通过，才能改善这一现象。
*   很多时候，因为 Yarn [进行了优化](https://github.com/yarnpkg/yarn/issues/4379#issuecomment-332512206),所以当开发人员在拉取项目的最新变化后运行 `yarn` 时，他们的 `yarn.lock` 文件会变的很“脏”，。为了解决这个问题，需要开发人员推送与他们工作无关的更改。Yarn 需要在使用命令 `yarn lock` 更新时立即优化，而不是在下一次使用 `yarn` 命令时。
*   `yarn publish` 不是很可靠（存在问题？）（[tracked issues #1](https://github.com/yarnpkg/yarn/issues/1619), [tracked issue #2](https://github.com/yarnpkg/yarn/issues/1182)），这意味着我们不得不使用 `npm publish` 来发布包。很容易忘记我们在这种特殊场景下需要使用 npm，并且意外地使用 Yarn 发布包导致发布的包无法安装。

不幸的是，在我们使用 Yarn 的 13 个月里，这些工作流很混乱的问题一个都没有被修复。

在经历了特别痛苦的的几个星期（经常开 15 分钟的 Yarn 问题解决会议）后，我们决定回归到 npm。

## npm 6

在我们使用 Yarn 的这段时间里，npm 做出了重大的改善，以期拥有 Yarn 的速度及其依赖锁定的可靠性 —— 这些问题曾使得我们转向了 Yarn。就像 Yarn 里面的那些烦人的问题一样，我们无法离开这些好处，因此我们首先需要验证一下 npm 是否解决了原来的那些问题。

我们决定尝试一下当前能够获取到的最新版本的 npm，`npm@​6.0.0`，因为我们想要利用尽可能多的速度改善和 bug 修复。据传 `npm​@6.0.0` 是一个[相对较小的重大更新](https://github.com/npm/npm/releases/tag/v6.0.0-next.0)，因此我们人为使用它不会冒很大的风险。不可思议的是，`npm​@5.8.1` 使我们在 6.0.0 发布之前测试过的版本，在我们许多开发工程师的机器上（OS X Sierra/High Sierra，`node​@v8.9.3`）安装依赖失败了，出现了许多错误（比如 [`cb() never called!`](https://github.com/npm/npm/issues?utf8=%E2%9C%93&q=is%3Aissue+is%3Aopen+cb+never+called)）。

### 速度

我们很高兴地发现，在每个包管理器试用五个案例后，npm的平均成绩与 Yarn 相当：

*   Yarn：`$ rm -rf node_modules && time yarn`：126s
*   npm：`$ rm -rf node_modules && time npm i`：132s

在正确的方向上迈出了正确的一步。我们的试验还会继续 :)。

### Locking

npm 在 `npm@​5.0.0` 引入了 [`package-lock.json`](https://docs.npmjs.com/files/package-lock.json) 等价于 Yarn 中的 `yarn.lock`。[`npm shrinkwrap`](https://docs.npmjs.com/cli/shrinkwrap) 仍然可以被用于创建 [`npm-shrinkwrap.json`](https://docs.npmjs.com/files/shrinkwrap.json) 文件，但是根据 [npm 文档](https://docs.npmjs.com/files/shrinkwrap.json)的描述，这些文件的使用场景有了一些不同：

> 推荐的 npm-shrinkwrap.json 使用场景是通过发布过程在注册表中部署的应用程序：例如，用作全局安装或 devDependencies 的守护程序和命令行工具。对于库作者发布这个文件非常不鼓励，因为这会阻止最终用户控制传递依赖关系更新。

`另一方面，package-lock.json` 文件[不跟随包一起发布](https://docs.npmjs.com/files/package-lock.json)。这相当于 Yarn 如何不尊重依赖关系的 `yarn.lock` 文件 —— 父项目管理自己的依赖关系和子依赖关系（但要注意的是，如果库**的确**在不应该的时候发布 `npm-shrinkwrap.json` 文件,那么您将会使用它们的依赖性）。

#### Locking 验证

npm 没有与 Yarn 的 [`yarn check`](https://yarnpkg.com/lang/en/docs/cli/check/) 相对应的功能，但 `yarn check` 看起来像一些人（如 Airbnb）使用 `npm ls> / dev / null` 来检查安装错误，如缺少软件包。

不幸的是，检查将 peer 依赖警告视为错误，这阻止了我们使用它，因为[我们经常通过 CDN 实现 peer 依赖关系](https://mixmax.com/blog/rollup-externals)。

npm 最近引入了 [`npm ci`](https://docs.npmjs.com/cli/ci)，很幸运它提供了一些验证功能。`npm ci` 确保了 `package-lock.json` 和 `package.json` 在同一验证形式下是同步的。它同样提供了一些其它好处 —— 查看文档了解更多。

之前在使用 npm 时，我们从未意识到 `install` 的不一致性（似乎只有 Yarn 有这些问题 :)），因此我们认为只使用 `npm ci` 是安全的。

### 使用 Yarn 的烦恼

除了追上 Yarn 的速度和拥有 Yarn 依赖关系锁定的保证之外，npm 似乎没有任何使用 Yarn 时困扰我们的问题！

### Check, check, check

`npm​@6.0.0` 为我们检查了所有的盒子，所有我们决定以后继续使用它！

在对我们的一个服务进行为期三周的试验成功后，我们将剩余的其它服务和项目也迁移到了 npm！

## 建议

### `deyarn`

我们已经发布了一个叫做 [`deyarn`](https://github.com/mixmaxhq/deyarn) 的开源模块，它可以帮助你将项目从 Yarn 迁移到 npm。

### 通过 `engines` 强制使用 npm

我们推荐使用 [`engines` 选项](https://docs.npmjs.com/files/package.json#engines)，它可以让你避免在应该使用 npm 的时候却意外地使用了 Yarn 了。

我们已经添加了一个配置如下：

```
{
    "engines": {
    "yarn": "NO LONGER USED - Please use npm"
    }
}
```
    

对于我们内部项目的所有的 `package.json` 而言。`deyarn`（链接在上方给出）会帮你管理 :)。

### 试试它！

我们测试过这个工作流能够满足我们的需求，并且我们也推荐你使用它。如果你需要一个极致快速的包管理器，然后你会发现 [Yarn 仍然是最佳之选](https://www.google.com/search?q=yarn%20vs%20npm%20speed)。但是如果你需要一个建立起来比较简单的包管理器，我们发现 npm 6 在速度与可靠性上保持了很好的平衡。

[想要帮助我们使用 npm 建立未来的社区吗？](https://mixmax.com/careers)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
