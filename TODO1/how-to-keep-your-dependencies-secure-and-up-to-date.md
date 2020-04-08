> * 原文地址：[How to Keep Your Dependencies Secure and Up to Date](https://medium.com/better-programming/how-to-keep-your-dependencies-secure-and-up-to-date-92578c7f3c9c)
> * 原文作者：[Patrick Kalkman](https://medium.com/@pkalkman)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-keep-your-dependencies-secure-and-up-to-date.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-keep-your-dependencies-secure-and-up-to-date.md)
> * 译者：[chaingangway](https://github.com/chaingangway)
> * 校对者：[QinRoc](https://github.com/QinRoc)

# 怎样让依赖库保持安全和最新

![Photo by [Lenin Estrada](https://unsplash.com/@lenin33?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) on [Unsplash](https://unsplash.com/s/photos/robot?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)](https://cdn-images-1.medium.com/max/4320/1*dJ1mhPOPA1MVEnUfpaCGjA.jpeg)

> 用 Dependabot 自动更新你的依赖

几周前，为了撰写关于[开闭原则](https://medium.com/better-programming/do-you-use-the-most-crucial-principle-of-object-oriented-design-9045dbd1321e)的文章，我在 GitHub 上搜索相关案例作为素材。在浏览 [.NET Core repository](https://github.com/dotnet/core) 的时候，我发现一个没见过的目录。

这个 `.dependabot` 目录下，只包含一个文件 `config.yml`。它是 GitHub 上一个叫做 Dependabot 的新服务的配置文件。

我之前不知道有这个服务。

稍加调研之后，我发现 Dependabot 是一个扫描仓库中依赖的服务。扫描之后，Dependabot 会验证你的外部依赖是否是最新的。

这个服务的真正实用之处在于：

**Dependabot 会自动创建 PR 用来更新依赖。**

我开始在我大多数的仓库中使用 Dependabot。在这篇文章中，我会告诉你怎样使用和配置 Dependabot。

## 使用 Dependabot

如果你在 GitHub 上有公有仓库，你可能见过下图所示的安全警告。GitHub 会自动扫描所有的公有仓库，如果检测到了安全漏洞，它会发出警告。

![A security alert from Github.com](https://cdn-images-1.medium.com/max/3928/1*0JG50XF4d8nYeLImgp3eoQ.png)

如果想要 GitHub 扫描你的私有仓库，你必须手动打开安全通知选项。GitHub 检测漏洞依赖的数据来自于 [GitHub Advisory Database](https://github.com/advisories) 和 [WhiteSource](https://www.whitesourcesoftware.com/whitesource-for-developers/)。

GitHub 发出的警告中还会包含修复方法。

Dependabot 在这个过程中会想得更远，它会自动为你的仓库创建 PR，这个 PR 可以解决你的安全漏洞。

#### 从 Dependabot 开始

要想使用 Dependabot，首先，你需要 [注册](https://app.dependabot.com/auth/sign-up)。GitHub 已经收购了 Dependabot，所以可以免费使用。

注册之后，你必须授予 Dependabot 访问仓库的权限。你可以在 Dependabot 的界面上操作，或者在你的仓库中添加 `config.yml` 文件。

![Give Dependabot access to your repositories](https://cdn-images-1.medium.com/max/3364/1*d3x8R3Zqgrj2LlvJYuzZXQ.png)

#### 配置 Dependabot

你可以在仓库根目录下的 `.dependabot` 目录里保存 `config.yml` 文件，用来配置 Dependabot。

#### 必选项

下面的配置文件来自于我的仓库之一。它只包含了必选项。


```YAML
version: 1
update_configs:
  - package_manager: "javascript"
    directory: "/WorkflowEngine"
    update_schedule: "live"
  - package_manager: "javascript"
    directory: "/WorkflowEncoder"
    update_schedule: "live"
```
这个配置文件仅仅使用了必要的 Dependabot 选项。因为在这个仓库里有很多项目，所以我指定了两个更新配置。

* `package_manager` 指定了你所使用的包管理器。Dependabot 支持很多不同的包管理器，比如 JavaScript，[Bundler](https://bundler.io/), [Composer](https://getcomposer.org/), Python, [Maven](https://maven.apache.org/) 等等。完整的列表，请看 [文档](https://dependabot.com/docs/config-file/)。
* `directory` 指定了包配置的路径。通常，它是你仓库的根目录。如果你在一个仓库中有多个项目，就像我上面的例子一样，你可以指定一个次级目录。
* 在 `update_schedule` 中，你可以指定 Dependabot 检测更新的频率。Live 意味着尽快。其他的选项是 daily、weekly 和 monthly。

Dependabot **总是** 尽快地创建安全更新。

#### 可选项

Dependabot 有一些额外的选项，可以修改一些东西，比如分支，提交记录，PR 的处理者。下面是完整列表：

* `target_branch `— 创建 PR 的目标分支。
* `default_reviewers `— 设置 PR 的评审员。
* `default_assignees` — 设置 PR 的处理者。
* `default_labels` — 设置 PR 的标签。
* `default_milestone` — 设置 PR 的里程碑。
* `allowed_updates` — 设置允许哪次更新。
* `ignored_updates` — 忽略特定的依赖或者依赖的版本。
* `automerged_updates` — Dependabot 应该自动合并的更新。
* `version_requirement_updates` — 怎样更新 App 的版本。
* `commit_message` — 附加在提交信息上的内容。

#### 验证配置文件

在 Dependabot 网站上有一个[页面](https://dependabot.com/docs/config-file/validator/)可以验证你的配置文件。请确保你的配置文件是正确的。

## 总结

我现在已经使用 Dependabot 几个星期了。最开始，我用的是 “live” 更新计划， 由于 “live” 产生了太多的警告，我又改成了 “weekly”。

我现在每周合并一次 Dependabot 提交的 PR。

你必须让你的依赖保持最新。如果你不更新，你使用的版本和最新版本的差异会增加。这种日益增加的差异会让之后更新依赖更加困难。

感谢阅读。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
