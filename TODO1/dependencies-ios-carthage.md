> * 原文地址：[Building Dependencies on iOS with Carthage](https://appunite.com/blog/dependencies-ios-carthage)
> * 原文作者：[Szymon Mrozek](https://appunite.com/blog/author/szymon-mrozek)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/dependencies-ios-carthage.md](https://github.com/xitu/gold-miner/blob/master/TODO1/dependencies-ios-carthage.md)
> * 译者：[iWeslie](https:github.com/iWeslie)
> * 校对者：[kirinzer](https://github.com/kirinzer)

# 在 iOS 上使用 Carthage 建立依赖

## 可爱的 Carthage

在本文中，我想通过使用 Carthage 分享构建依赖关系的经验。Carthage 简洁明了，只需在 `Cartfile` 中添加适当的内容并运行 `carthage update` 就可以在 Xcode 项目中使用一些外部依赖项。但众所周知的是，现实是残酷的，有时我们需要考虑更加复杂的例子。

我们假设有一个 iOS 开发团队。Tony、John 和 Keith 都正在使用 **大约15个** 流行的第三方依赖库，如 Alamofire、Kingfisher、ReactiveCocoa 等。

### 他们可能会遇到的问题

*   **不同的编译器** - 一些库是用 Swift 编写的，这意味着每个不同的编译器运行时都与其他编译器不相兼容。如果这些开发人员使用不同版本的 Xcode，这可能产生一个巨大的问题，他们每个人都需要构建自己的框架版本或使用相同版本的 Xcode。
*   **清理编译时间** - 这是最近的热门话题，有时我们需要关心编译时间，特别是在 CI 和分支之间切换时。一个团队就意味着他们不想用 1 小时或者更久来浪费在等待发布上，因此这个问题可能很关键。
*   **仓库大小** - 一些开发者更喜欢在仓库下包含已编译好的框架。假设这个团队正在使用免费的 GitHub 计划，因此他们的仓库最大为 1 GB。在仓库中存储别的框架可能导致其大小大幅增加，甚至可能有 5 GB。即使仓库存储限制不是问题，克隆这样的仓库也需要花费 **相当多的时间**。这可能会对清理编译时间产生巨大影响，尤其是在将 CI 与虚拟机一起使用时。
*   **更新框架** - 当你运行 `carthage update`，如果没有别的额外工作，carthage 将重新编译 **所有** 框架。在项目开始时，我们会经常这样做。团队正在寻找一种更快速的解决方案。

**天下没有免费的午餐** 我同意，但是同时我相信有时候你花一些时间来改善你的日常用到的工具是很值得的。我花了 **很多时间** 试验依赖库管理器，甚至是缓存他们产生的依赖库等等。下面让我告诉你三个维护 carthage 框架的流行解决方案把。

**在你开始之前**

* 如果您不熟 Carthage，请首先看看它的 [目录](https://github.com/Carthage/Carthage)。
* 我不会考虑直接在项目仓库中直接存储 Carthage 框架。

## 简单的方法

故事开始了，Tony 是团队领导，他决定使用 Carthage 来管理依赖库，他在使用外部框架时为其他开发者定义了一些规则：

* 把 `Carthage/Build` 和 `Carthage / Checkouts` 添加到 `.gitignore`
* 第一次克隆仓库时，你需要运行 `carthage bootstrap` 来重建所有依赖项。在 CI 中则需要为每个管道运行。
* 更新框架时，只更新一个，例如 `carthage update ReactiveSwift`。

这些都是非常简单的规则，但是它们的优缺点如何呢？

### 优点：

* 完全免费
* 仓库大小不会迅速增加

### 缺点：

* 清理编译时间很长
* 绝对不会重复使用预编译的框架
* 你的仓库中的将多出其他代码

让我们将此解决方案与可能出现的问题进行比较：

| 问题 | 已经解决？ | 还缺少什么？ |
| :--: | :--: | :--: |
| 不同的编译器 | 否   | 所有开发者的编译器版本必须相同 |
| 清理编译时间 | 是  | CI 将只会编译程序部分的代码并且为每个管道重用预编译好的所有依赖库 |
| 仓库大小 | 是   | - |
| 更新框架 | 否   | 没有改善，开发者需要在升级时重新编译框架和依赖库 |

总结一下，这种方法的最大的问题是 **时间**。唯一完全解决的问题是仓库的大小。CI 编译时间非常长，并且会随着依赖项的数量相应地增长。正如你所看到的，还有很多需要改进的地方。让我们尝试不同的解决方案吧！

## Git 里的 LFS

有一天一个开发者 John 发现了 GitHub 允许在它们的 LFS（大文件存储系统）下存储很大的文件。他意识到这可能是一个很好的机会，来把预编译的框架放到 git 仓库里下，同时保证了仓库还是比较小的。他把 Tony 的规则做了一点店修改：

* **同时** 把 `Carthage/Build` **和** `Carthage/Checkouts` 添加到 `.gitignore`，
* 当第一次克隆仓库的时候，你 **不必** 运行 `carthage bootstrap` 来重新编译所有依赖，但是你需要从 LFS 里抽取框架，
* 当更新框架时，请使用例如 `carthage update ReactiveSwift` 来更新, **还有一些工作需要做**，你需要把那些框架归档，添加至 `.gitattributes`，压缩并上传到 LFS，
* **所有的项目组成员** 必须保持 Xcode 和 Swit 的版本一致。

这个解决方案更加复杂，因为需要额外的压缩和上传框架的操作。这里有一篇 [很好的文章](https://medium.com/@rajatvig/speeding-up-carthage-for-ios-applications-50e8d0a197e1)，它提供了详细的操作讲解并提供了一些原始的 `Makefile`，可以让这些操作自动进行。

### 优点；

* 仓库的大小仍然没有增加
* 只需要克隆仓库后再提取框架

### 缺点：

* 大部分情况下不免费（1 GB 的 LFS 每月需要 5 美元）
* 所有的开发者 Xcode 版本必须相同
* 没有使框架更新加快的机制

让我们比较一下这个方案所能解决的问题和文章开头提出的问题：

|     问题     | 已经解决？ |                      还缺少什么？                      |
| :----------: | :--------: | :----------------------------------------------------: |
| 不同的编译器 |  部分解决  |   如果两个开发者使用相同的 Xcode，他们都需要重新编译   |
| 清理编译时间 |     否     | 编译将持续很长时间，每次都会把 CI 上的所有依赖重新编译 |
|   仓库大小   |     是     |                           -                            |
|   更新框架   |     否     |    没有改善，开发者需要在升级时重新编译框架和依赖库    |

毕竟我认为这看起来好多了！对于大多数团队而言，快速清理构建相比于在开发者之间可能使用不同 Xcode 来说更为重要。他们仍然可以安装不同的版本，只在特定项目之间切换。我相信每月 5 美元的 LFS 并不算贵。所以这是一个更好，同时也更难的解决方案，但仍有一些改进空间...

## Rome

现在 Keith 又出现了，他很欣赏其他开发者的研究，但 Keith 非常在意团队合作。他认为也许可以在不同项目之间共享由不同版本的 Swift 编译器预编译的不同版本的框架，这种情况很多，但幸运的是有这样一个工具！它被称为 `Rome`。我强烈建议您查看 [相关文档](https://github.com/blender/Rome)。通常此工具使用 Amazon S3 Bucket 来共享框架，Keith 再一次地改变了规则：

* 把 `Carthage/Build` **和** `Carthage/Checkouts` **都** 添加到 `.gitignore`，
* 当第一次克隆仓库的时候，当第一次克隆仓库的时候，你 **不必** 运行 `carthage bootstrap` 来重新编译所有依赖，但是你需要从 Amazon S3 上下载它们，
* 当更新框架时，请使用例如 `carthage update ReactiveSwift --no-build` 仅仅更新一个框架 **版本**，尝试从 Amazon 下载它，并且如果它不存在的话就把它编译并上传，
* 你需要定义 `RepositoryMap` 来告诉 Rome 你使用了哪一个由 Carthage 编译的依赖。

通过使用一些 **非常简单的** 的辅助脚本，这些规则几乎与一开始 `天真的方法` 中的规则一样简单。我对此工具的印象非常深刻，尤其是仅限的一些步骤带来了显著的成效，下面来让我们看看这个解决方案的优缺点：

### 优点：

* 仓库的大小仍然没有增加
* 只需要克隆仓库和下载资源
* 在所有公司的开发者间共享框架，由于其他人可能已经为你编译好了适当版本的框架，你更新框架起来就非常容易
* 可以使用不同版本的 Xcode
* 由于 `RepositoryMap` 的使用你更加了解依赖的相关知识
* 在 CI 上可计划编译依赖并在本地使用

### 缺点：

* 不免费，但是仍然比 **LFS** (`$0.023 / GB`) 便宜

和上一个解决方案相比：

|     问题     | 已经解决？ | 还缺少什么？ |
| :----------: | :--------: | :----------: |
| 不同的编译器 |     是     |      -       |
| 清理编译时间 |     是     |      -       |
|   仓库大小   |     是     |      -       |
|   更新框架   |     是     |      -       |

在我看来这个解决方案将为你在依赖管理上节省大量时间，当然有时你将需要在你自己的电脑或是 CI 上编译，但是你需要保证此工作会被重用。

## 回顾

所以你应该已经意到我相信 Rome 才是目前最好的解决方案，我强烈建议你使用它，但以上的故事表明总有一些东西是可以进行改进的。你应该尝试不同的方法并选择最佳解决方案。我相信在阅读 Tony，John 和 Keith 的故事时，你注意到的不仅仅是 Rome 是 Carthage 的最佳搭档，还应该联系到团队工作和工作流程的改进。CI 做为虚拟的第四位团队成员，其他几个人一直试图解协作开发的问题，最后他们中的一个找到了一个理想的解决方案来满足他们的需求。

### 几个有用的链接：

*   [Github 上的 Carthage](https://github.com/Carthage/Carthage)
*   [Git LFS](https://git-lfs.github.com)
*   [Medium 上关于 Carthage 和 LFS 的文章](https://medium.com/@rajatvig/speeding-up-carthage-for-ios-applications-50e8d0a197e1)
*   [BFG - 向 LFS 合并的工具](https://github.com/rtyley/bfg-repo-cleaner/releases/tag/v1.12.5)
*   [Github 上的 Rome](https://github.com/blender/Rome)
*   [AWS 简介](https://aws.amazon.com/blogs/security/a-new-and-standardized-way-to-manage-credentials-in-the-aws-sdks)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
