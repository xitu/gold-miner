> * 原文地址：[Automated npm releases with Travis CI](https://tailordev.fr/blog/2018/03/15/automated-npm-releases-with-travis-ci/)
> * 原文作者：[TailorDev](https://tailordev.fr)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/automated-npm-releases-with-travis-ci.md](https://github.com/xitu/gold-miner/blob/master/TODO/automated-npm-releases-with-travis-ci.md)
> * 译者：[Starrier](https://github.com/Starriers)
> * 校对者：[talisk](https://github.com/talisk)、[liang-kai](https://github.com/liang-kai)

# 使用 Travis CI 自动发布 npm 

在 [npm 注册表](https://www.npmjs.com/)发布一个包应该是很无聊的，在这篇博客中，我描述了如何在每次打 git 标签时使用 [Travis CI](https://travis-ci.org/) 来发布 npm 包。

![使用 Travis CI 自动发布 npm](https://tailordev.fr/img/post/2018/03/automated-npm-releases.png)

在 TailorDev，我们喜欢自动化构建软件所需的许多重要步骤。其中一个步骤是发布最终的，即可生产的应用程序包，也称为工件或者包。今天，我们关注于 JavaScript 世界，描述如何不花费太大心血而在 npm 注册表中实现包的自动化发布过程。

首先，npm 在 2017 年推出了 [双因素认证](https://docs.npmjs.com/getting-started/using-two-factor-authentication) (简称 2FA)，这是一个很好的想法，直到我们发现了它是“全部或者没有”！[:confused:](https://assets.github.com/images/icons/emoji/unicode/1f615.png ":confused:")。事实上, npm 2FA 依赖于[一次性密码](https://en.wikipedia.org/wiki/One-time_password)来保护账户以及与您账户相关的所有内容，并自动实现这一功能，从而无法实现 2FA 的功能。

**但是为什么这会如此重要呢？**我很高兴您会这么问，因为我们在续集中需要一个 API 令牌，而且目前不可能在不触发 2FA 机制的情况下生成和使用令牌。换句话说，启用 2FA，几乎不可能自动化 npm 发布过程，“几乎”是因为 npm 实现了[双级别身份认证](https://docs.npmjs.com/getting-started/using-two-factor-authentication#levels-of-authentication): **`auth-only`**  和 **`auth-and-writes`**。通过将 2FA 的使用限制在 **`auth-only`** 上，我们就可以使用 API 令牌，但安全性较低。我们真的希望 npm 可以在不久的将来为自动化任务设计的 auth 令牌，同时：

```
$ npm profile enable-2fa auth-only
```

一旦您的账户启用了 **`auth-only`** 用法的 2FA (顺便说一句，这比没有启用 2FA 更好)，那就让我们开始创建一个令牌：

```
$ npm token create

+----------------+--------------------------------------+
| token          | a73c9572-f1b9-8983-983d-ba3ac3cc913d |
+----------------+--------------------------------------+
| cidr_whitelist |                                      |
+----------------+--------------------------------------+
| readonly       | false                                |
+----------------+--------------------------------------+
| created        | 2017-10-02T07:52:24.838Z             |
+----------------+--------------------------------------+
```

这个令牌将由 Travis CI 用于代表您进行身份验证。我们也可以[使用 Travis CLI 将该令牌作为环境变量进行加密](https://docs.travis-ci.com/user/environment-variables/#Encrypting-environment-variables)或者[在 Travis CI 存储库设置中定义一个变量](https://docs.travis-ci.com/user/environment-variables/#Defining-Variables-in-Repository-Settings),，这样做将会更方便。声明两个私密环境变量 **`NPM_EMAIL`** 和 **`NPM_TOKEN`**：

![Travis CI 设置](https://tailordev.fr/img/post/2018/03/travis-ci-settings.png)

现在，最重要的部分是创建一个实际发布 npm 包的任务。我们决定利用[构建阶段（测试版）特性](https://docs.travis-ci.com/user/build-stages/)结合 [Travis CI 推荐的方式发布 npm 包](https://docs.travis-ci.com/user/deployment/npm/)。为了做记录，我们希望每次构建版本只发布一次。不管现有的构建矩阵如何，我们还希望在发布 npm 包时使用 git 标签，以便在 npm 版本和 GitHub 版本之间保持一致。

我们从一个用于 JavaScript 项目的标准 **`.travis.yml`** 文件开始，在该文中对代码进行了 Node 8 和 9 的测试，并使用 [yarn](https://yarnpkg.com/) 作为包管理器：

```
language: node_js
node_js:
  - "8"
  - "9"

cache: yarn

install: yarn
script:
  - yarn lint
  - yarn test
```

![标准 Travis CI 输出带有两个 JavaScript 任务](https://tailordev.fr/img/post/2018/03/travis-ci-two-jobs-node.png)

我们现在可以通过将以下配置添加到之前的 **`.travis.yml`** 文件中来配置“部署”任务：

```
jobs:
  include:
    - stage: npm release
      if: tag IS present
      node_js: "8"
      script: yarn compile
      before_deploy:
        - cd dist
      deploy:
        provider: npm
        email: "$NPM_EMAIL"
        api_key: "$NPM_TOKEN"
        skip_cleanup: true
        on:
          tags: true
```

让我们一行一行地分析。首先，当且仅当 **`IS 标签存在`** 时，我们“加入”一个新的 npm 发布阶段，这意味着构建已经被 git 标记触发。我们选择 node **`8`** (我们的生产版本) 并执行 **`yarn compile`** 来构建我们的包。此脚本会创建包含可以在 npm 注册表上发布包文件的 **`dist/`** 文件夹。最后但同样重要的一点是，我们调用 Travis CI **`deploy`** 命令在 npm 注册表来实际发布包（同时我们将此命令限制为 git 标记，仅作为额外的保护层）。

注意：为了防止 Travis CI 清理额外的文件夹并删除你做的改变，请在发布前将 **`skip_cleanup`** 设置为 **`true`**。 

![带有 JavaScript 的 Travis CI](https://tailordev.fr/img/post/2018/03/travis-ci-build-stages.png)

这很酷，不是么?![:sunglasses:](https://assets.github.com/images/icons/emoji/unicode/1f60e.png ":sunglasses:")

## 优点：npm 像专业版一样发布

为了创建新版本，我们使用 [**`npm 版本`**](https://docs.npmjs.com/cli/version) (它内置在 npm ![:rocket:](https://assets.github.com/images/icons/emoji/unicode/1f680.png ":rocket:"))。假设我们当前版本是 **`0.3.2`**，我们想发布 **`0.3.3`**。在 **`master`** 分支上，我们运行以下命令

```
**$ npm version patch**
```

该命令执行以下任务：

1.  在 **`package.json`** 中插入（更新）的版本号
2.  创建一个新的提交
3.  创建一个 git 标签

我们可以使用 **`npm version minor`** 从 **`0.3.1`** 发布 **`0.4.0`** (它会颠倒第二个数字并重置最后一个数字)。我们也可以使用 **`npm version major`** 从 **`0.3.1`** 发布 **`1.0.0`**。 

一旦使用 **`npm version`** 命令完成后，您就可以运行 **`git push origin master --tag`** 并稍等片刻，直到包在 npm 注册表上发布。![:tada:](https://assets.github.com/images/icons/emoji/unicode/1f389.png ":tada:")


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
