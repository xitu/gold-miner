> * 原文地址：[Building Dependencies on iOS with Carthage](https://appunite.com/blog/dependencies-ios-carthage)
> * 原文作者：[Szymon Mrozek](https://appunite.com/blog/author/szymon-mrozek)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/dependencies-ios-carthage.md](https://github.com/xitu/gold-miner/blob/master/TODO1/dependencies-ios-carthage.md)
> * 译者：[iWeslie](https:github.com/iWeslie)
> * 校对者：

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

## 天真的方法

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

总结一下，这种方法的最大的问题是 **时间**。唯一完全解决的问题是仓库的大小。CI 编译时间非常长，并且会随着依赖项的数量成比例增加。正如你所看到的，还有很多需要改进的地方。让我们尝试不同的解决方案吧！

## Git LFS

Some day one of the developers - John - found that github allows storing large files in their LFS (large file system). He noticed that this might be great oportunity to start including pre-compiled frameworks in git repo, but still keep it small. He modified Tony’s rules a little:

*   Add **both** `Carthage/Build` **and** `Carthage/Checkouts` to `.gitignore`,
*   When cloning repository for the first time - you **don’t** need to run `carthage bootstrap` (rebuild all dependencies), but you need to extract frameworks from LFS,
*   When updating framework please only update one framework like `carthage update ReactiveSwift`, **some extra work is needed** \- you need to archive those frameworks, zip them and upload to git-lfs (add to `.gitattributes`),
*   **All team members** must have the same Swift compiler version (Xcode version).

This solution is much more complicated especially because of extra steps with zipping and uploading frameworks. There is a [great article](https://medium.com/@rajatvig/speeding-up-carthage-for-ios-applications-50e8d0a197e1) that describes this and offers some simple `Makefile` to automate this step.

### Pros:

*   Repository size still not growing
*   After cloning and extracting you’re ready to go

### Cons:

*   In most cases not free (costs `5$` per month after reaching 1GB on LFS)
*   Each developer must work with the same Xcode version
*   No mechanism for speeding up update of frameworks

Let’s compare this solution to problems defined at the begining of the article:

![LFS approach](https://www.dropbox.com/s/wddhmpli1yyiqgv/naive-table.png?raw=1)

After all I think that this looks much better! Having fast clean builds is much more important for most teams than possibility to use different Xcodes between developers. They are still able to have differen versions installed and only switch between them for specific projects. I believe `5$` per month for LFS is not a big deal. So it’s much a better (and difficult) solution, but there is still some room for improvement …

## Rome

So, time for Keith to show up. He appreciate other developers’ research, but Keith cares a lot about team work. He thought that maybe it’s possible to share different versions of pre-compiled frameworks compiled by different versions of swift compiler between different projects? That’s a lot of variety, but fortunately there is a tool for that! It’s called `Rome`. I highly encourage you to take a look at documentation on [github](https://github.com/blender/Rome). In general this tool shares frameworks using Amazon S3 Bucket. Again, Keith changed the rules:

*   Add **both** `Carthage/Build` **and** `Carthage/Checkouts` to `.gitignore`,
*   When cloning repository for the first time - you **don’t** need to run `carthage bootstrap` (rebuild all dependencies) but you need download them from Amazon S3,
*   When updating framework please only update one framework **version** like `carthage update ReactiveSwift --no-build` and then try to download it from Amazon and if it does not exist build it and upload,
*   You need to define `RepositoryMap` which tells Rome which dependencies compiled by Carthage you use.

By using some **very simple** helper script those rules seem to be almost as simple as the one from `Naive approach` section. I’m very impressed by this tool especially by the relation between amount of required setup work and given benefits. Let’s see what are pros and cons of this solution:

### Pros:

*   Repository size still not growing
*   After cloning and downloading you’re ready to go
*   Share frameworks between all company developers (very simple framework update because someone possibly already compiled proper version for you)
*   Feel free to use different versions of Xcode
*   Better knowlage of dependencies that you use because of `RepositoryMap`
*   Ability to schedule building dependencies on CI and then using them locally

### Cons:

*   Not free, but it’s still cheaper than **LFS** (`$0.023 / GB`)

And comparison with an obvious result:

![Rome approach](https://www.dropbox.com/s/9ffe5v1gxkvo7nx/rome-table.png?raw=1)

In my opinion this solution is the one that saves you a lot of hours spent on dependency management. Of course sometimes you’ll need to build on your machine / CI but you have to guarantee that this job will be reused.

## Recap

So you already noticed that I believe Rome is the best solution for now and I highly encourage you to use this, but the story shows that there is always something we can improve. You should experiment with different approaches and pick the one that solves your problems. I believe that during reading a story of Tony, John and Keith, you noticed more than just the best friend of Carthage (Rome). It’s about team work and improving team workflow. Those guys tried all the time to solve the problem of working together (with CI as a virtual fourth team member) and finally one of them found a solution that fits ideally to their needs!

### Useful links:

*   [Carthage github](https://github.com/Carthage/Carthage)
*   [Git LFS](https://git-lfs.github.com)
*   [Medium article about Carthage + LFS](https://medium.com/@rajatvig/speeding-up-carthage-for-ios-applications-50e8d0a197e1)
*   [BFG - tool for migrating to LFS](https://github.com/rtyley/bfg-repo-cleaner/releases/tag/v1.12.5)
*   [Rome github](https://github.com/blender/Rome)
*   [AWS credentials](https://aws.amazon.com/blogs/security/a-new-and-standardized-way-to-manage-credentials-in-the-aws-sdks)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
