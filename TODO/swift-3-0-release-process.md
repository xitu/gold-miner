>* 原文链接 : [Swift 3.0 Release Process](https://swift.org/blog/swift-3-0-release-process/)
* 原文作者 : [Ted Kremenek](https://github.com/tkremenek/)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [Tuccuay](https://github.com/Tuccuay)
* 校对者 : [Wilson Yuan](https://github.com/devSC), [Jasper Zhong](https://github.com/DeadLion)


这篇文章介绍了 Swift 3.0 的目标、发布进程和预计的时间表。

Swift 3.0 是一个不兼容 Swift 2.2 语法的大版本更新。它对语法和基本库有着根本性的改变。Swift 3.0 实现的完整修改列表可以在 [Swift evolution site](https://github.com/apple/swift-evolution#implemented-proposals-for-swift-3) 中查看。

Swift 3.0 是首个包含 [Swift Package Manager](https://swift.org/package-manager/) 的发布版本。现在 Swift Package Manager 还处于早期开发版本，它支持开发和发布跨平台的 Swift 包。Swift Package Manager 将同时支持 Drawin 和 Linux 两个平台。

对于 Linux，Swift 3 将会是第一个包含 [Swift Core Libraries](https://swift.org/core-libraries/) 的发布版本。

Swift 3.0 预计在 2016 年后半年的某个时候发布。除了 Swift.org 的版本，Swift 3.0 也会被包含在未来的 Xcode 中。

## 开发前瞻

* Swift 3.0 将会有一系列的开发者预览版本（例如「种子版」或「测试版」），以提供合格且聚合的 Swift 3 构建版本。其目标是为用户提供更稳定和高质量的 Swift 二进制文件 [下载](https://swift.org/download) 并尝试，而不仅仅是对 `master` 分支抓取最新的快照。

* 开发者预览版的发布节奏可能是不规律的，但通常会在 4~6 周之间。这将取决于变更进入 `master` 分支和让开发者预览版稳定下来的时间。

* Swift 3.0 会将最后一个开发者预览版的分支标记为 "GM" 版本。

* 进入开发者预览版的内容将由合适的发行管理者（见下文）管理。

## 了解 Swift 3.0 的变化

### 分支

* **master**: Swift 3.0 的开发都发生在 `master`。所有的改动都将合并到 `master` 并被作为 Swift 3.0 最终版本的一部分，直到最后一个开发者预览版本分支被创建。并且这个 `master` 将继续跟进未来版本的 Swift。

* **swift-3.0-preview--branch**: 这些分支都将从 `master` 创建。所有的合并请求都需要通过持续集成测试才能提交。这个分支用来管理和批准贡献者合并代码到开发者预览版分支的请求。

* **swift-3.0-branch**: 最后一个从 `master` 分支创建的开发者预览版本将会被命名为 `swift-3.0-branch`。这是最终的「发布分支」。

### 谈谈 Swift 3.0 理念上的变化

* 在 Swift 3.0 中仅收录经过缜密考虑符合核心发行目标的改动。

* 对于语言崩坏性的改动将在经过逐个审查的基础上考虑。

* Swift 3.0 所有的语言和 API 变化都将经过 [Swift Evolution](https://github.com/apple/swift-evolution) 过程。

* 准则 - 由发行管理者决定 - 对于接受变更的政策将会随着版本发布的临近而变得越来越严格，相同的策略也使用于开发者预览分支，开发者预览分支本质上是 mini-releases。

## 时间表

* 第一个开发者预览分支 `swift-3.0-preview-1-branch` 将会在 5 月 12 日从 `master` 分支创建，将会在 4~6 周后发布。

* 而创建最后一个开发者预览版分支 —— `swift-3.0-branch` 的时间则尚未确定。当这个计划时间被确定后将会在 [swift-dev](https://lists.swift.org/mailman/listinfo/swift-dev) 通知，同时也会在这个帖子（译注：指英文原文）更新。

## 受影响的仓库

以下仓库也将会拥有 `swift-3.0-preview-<x>-branch</x>`/`swift-3.0-branch` 分支并成为 Swift 3.0 的一部分发布：

* [swift](https://github.com/apple/swift)
* [swift-lldb](https://github.com/apple/swift-lldb)
* [swift-cmark](https://github.com/apple/swift-cmark)
* [swift-llbuild](https://github.com/apple/swift-llbuild)
* [swift-package-manager](https://github.com/apple/swift-package-manager)
* [swift-corelibs-libdispatch](https://github.com/apple/swift-corelibs-libdispatch)
* [swift-corelibs-foundation](https://github.com/apple/swift-corelibs-foundation)
* [swift-corelibs-xctest](https://github.com/apple/swift-corelibs-xctest)

以下仓库将只有一个 `swift-3.0-branch` 取代开发者预览分支，因为他们已经很好的融合。

*   [swift-llvm](https://github.com/apple/swift-llvm)
*   [swift-clang](https://github.com/apple/swift-clang)

## 发行管理者

所有的发布管理都将由以下人员进行监督，他们将会严格控制进入 Swift 3.0 的变更。

* [Ted Kremenek](https://github.com/tkremenek) 将作为整个 Swift 3.0 的发行管理者。

*   [Frédéric Riss](https://github.com/fredriss) 将作为 [swift-llvm](https://github.com/apple/swift-llvm) 和 [swift-clang](https://github.com/apple/swift-clang) 的发行管理者。　

*   [Kate Stone](https://github.com/k8stone) 将作为 [swift-lldb](https://github.com/apple/swift-lldb) 的发行管理者。

*   [Tony Parker](https://github.com/parkera) 将作为 [swift-corelibs-foundation](https://github.com/apple/swift-corelibs-foundation) 的发行管理者。

*   [Daniel Steffen](https://github.com/das) 将作为 [swift-corelibs-libdispatch](https://github.com/apple/swift-corelibs-libdispatch) 的发行管理者

*   [Mike Ferris](https://github.com/mike-ferris-apple) 将作为 [swift-corelibs-xctest](https://github.com/apple/swift-corelibs-xctest) 的发行管理者。

*   [Rick Ballard](https://github.com/rballard) 将作为 [swift-package-manager](https://github.com/apple/swift-package-manager) 的发行管理者。

如果你对发信管理过程有任何疑问随身都可以通过邮件列表 [swift-dev](https://lists.swift.org/mailman/listinfo/swift-dev) 或者直接联系 [Ted Kremenek](https://github.com/tkremenek)。

## 对开发者预览版的合并请求

所有对开发者预览版的合并请求提出的变更都需要包含以下信息：

* **描述**：对于修复问题或者增强性能的介绍。可以简短但必须清晰。

* **影响范围**：影响范围和重要性的评估。例如「这个修改对语法有破坏性的改变」等等。

* **SR Issue**：这个改动 修复/执行 了一个 [bugs.swift.org](https://bugs.swift.org) 上的 问题/优化。

* **风险**：这个改动会产生什么（特定的）风险？

* **测试**：已经采取了什么测试手段或者需要进行什么样的进一步测试来评估这个改动所带来的影响？

对于那些受影响的组件，一个或更多 [代码所有者](https://swift.org/community/#code-owners) 应该审核改动。技术审查可以由代码所有者委托其他人审核，或者其它合适、有效的方法。

**所有的变更**进入开发者预览版分支**都必须经过合并请求**并且由相应的发行管理者审核。
