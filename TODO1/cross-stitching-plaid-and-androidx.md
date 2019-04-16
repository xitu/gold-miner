> * 原文地址：[Cross-stitching Plaid and AndroidX](https://medium.com/androiddevelopers/cross-stitching-plaid-and-androidx-7603a192348e)
> * 原文作者：[Tiem Song](https://medium.com/@tiembo)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/cross-stitching-plaid-and-androidx.md](https://github.com/xitu/gold-miner/blob/master/TODO1/cross-stitching-plaid-and-androidx.md)
> * 译者：[Mirosalva](https://github.com/Mirosalva)
> * 校对者：[PhxNirvana](https://github.com/phxnirvana)

# Plaid 应用迁移到 AndroidX 的实践经历

一份 AndroidX 的迁移指南

![](https://cdn-images-1.medium.com/max/2560/1*XYbnKLfu7L533n8DASGvrQ.png)

由 [Virginia Poltrack](https://twitter.com/vpoltrack) 提供图片。

Plaid 是一款呈现 Material Design 风格和丰富交互界面的有趣应用。最近这款应用通过现今的 Android 应用开发技术实现了一番重构。获取更多应用信息和重新设计的视觉效果，可以查阅 [Restitching Plaid](https://medium.com/@crafty/restitching-plaid-9ca5588d3b0a)。

* [**Restitching Plaid**: 把 Plaid 更新到最新应用标准](https://medium.com/@crafty/restitching-plaid-9ca5588d3b0a "https://medium.com/@crafty/restitching-plaid-9ca5588d3b0a")

和大多数 Android 应用一样，Plaid 依赖 Android Support Library，该库可以为新 Android 特性提供向后兼容性，以便可以运行在旧版操作系统的 Android 机上。在 2018 年的 9 月份，最新的 Support Library 版本（28.0.0）被发布，和 Support Library 一起发布的 Android 库已经被迁移到 AndroidX（除了 Design 库被迁移到 Android 的 Material Components），并且这些库的新增开发都是基于 AndroidX。因此，接收 bug 修复、新功能和其他库更新的唯一选择就需要将 Plaid 迁移到 AndroidX。

### 什么是 AndroidX?

在 2018 Google I/O 大会上，Android 团队[发布了 AndroidX](https://android-developers.googleblog.com/2018/05/hello-world-androidx.html)。它是 Android 团队用于开发、测试、打包、定版以及在 [Jetpack](https://developer.android.com/jetpack/) 中发布库时所用到的[开源代码](https://android.googlesource.com/platform/frameworks/support/+/androidx-master-dev)。和 Support Library 类似，每一个 [AndroidX](https://developer.android.com/jetpack/androidx/) 库都是独立于 Android OS 来发布，并且提供了跨 Android 版本的向后兼容性。它是对 Support Library 的重大改进和全面替代方案。

阅读下文来了解我们如何为迁移过程准备自己的代码，以及执行迁移过程。

### 迁移前准备

我强烈建议在一个版本可控的分支做迁移工作。这样你可以逐步解决可能出现的任何迁移问题，同时分离出每个变更用于分析定位问题。你可以在这个 [Pull Request](https://github.com/nickbutcher/plaid/pull/524) 下查看我们的讨论过程，并且通过点击下面的提交链接来跟进最新信息。另外 Android Studio 提供了一个迁移前做工程备份的可选服务。

和任何大规模代码的重构工作一样，最好在迁移到 AndroidX 期间，迁移分支与主要开发分支之间做到最少合并来避免合并冲突。虽然对其他应用来说不可行，但是我们团队能够临时暂停向主分支提交代码以帮助迁移。一次性迁移整个应用也非常必要，因为部分迁移——同时使用 AndroidX 和 Support 库将会导致迁移过程中的失败。

最后，请阅读 [developer.android.com](https://developer.android.com/) 网站上[迁移至 AndroidX](https://developer.android.com/jetpack/androidx/migrate) 文中的提示。现在让我们开始吧！

### 依赖标识

在你开始之前，对代码准备的最重要的一点建议是：

> 确保你正在使用的依赖库是与 AndroidX 兼容的。

依赖于一个旧版 support 库的第三方库可能与 AndroidX 不兼容，这很有可能导致你的应用在迁移到 AndroidX 后无法编译。检查你的应用任意依赖是否兼容的一个方法是访问这些依赖的项目站点。一个更直接的方法是开始迁移，并且检查可能出现的报错。

对于 Plaid 应用，我们使用了一个与AndroidX 不兼容的图形加载库 [Glide](https://bumptech.github.io/glide/) 的旧版本（4.7.1）。这导致迁移后出现一个让应用无法构建的代码生成问题（这是一个记录在 Glide 工程下的类似[问题](https://github.com/bumptech/glide/issues/3126)），在开始迁移之前我们把 Glide 更新到版本 4.8.0（参考这次[提交](https://github.com/nickbutcher/plaid/pull/524/commits/6b23efa838d4e9f60a3e78ae324c0c4a43ec8de0)），这个版本添加了对 AndroidX 注解的支持。

关于这一点，请尽可能地更新到你的应用所依赖第三方库的最新版本。这对 Support 库而言尤其是一个好主意，因为升级到 28.0.0（截至撰写本文的最终版本）将使迁移更加顺畅。

### 使用 Android Studio 进行重构

迁移过程中我们使用了 Android Studio 3.2.1 版本中内置的重构工具。 AndroidX 迁移工具位于菜单栏的 Refactor > Migrate to AndroidX 选项。这个选项将迁移整个项目的所有模块。

![](https://cdn-images-1.medium.com/max/800/1*lztKTBouffsQZyUbkNkYHA.png)

运行 AndroidX 重构工具后的预览窗口。

如果你不使用 Android Studio 或者更倾向于其他工具来做迁移，请参考 [Artifact](https://developer.android.com/jetpack/androidx/migrate#artifact_mappings) 和 [Class](https://developer.android.com/jetpack/androidx/migrate#class_mappings) 来对比新旧支持库间架构和类的改动，这些材料也有提供 CSV 格式。

Android Studio 中的 AndroidX 迁移工具是 AndroidX 迁移的主要方式。这个工具正在持续的优化中，所以如果你遇到问题或者希望查看某个功能，请在 Google 问题追踪页[提交一票](https://issuetracker.google.com/issues/new?component=460323)。

### 迁移应用

> **变更最少的代码以保证应用可以仍能正常运行。**

在运行 AndroidX 迁移工具后，大量的代码被变更，然而项目却无法编译成功。此时，我们仅仅[做了最少量的工作](https://github.com/nickbutcher/plaid/compare/dd2ebf7f2de74809981e7c904c9ee22d16db5262...d2cefa384448f4d3fb92dec0ade25d9bd87efb63)来使应用重新运行起来。

这个方法有利于把流程拆解为可控的步骤。我们留下了一些任务，诸如修复导入顺序、提取依赖变量、减少完整 classpath 的使用，以便后续的清理工作。

刚开始出现的报错之一是重复的类 —— 像这种情况，`PathSegment`：

```
Execution failed for task ':app:transformDexArchiveWithExternalLibsDexMergerForDebug'.

> com.android.builder.dexing.DexArchiveMergerException: Error while merging dex archives:

如何解决这个问题参考这里： https://developer.android.com/studio/build/dependencies#duplicate_classes.

Program type already present: androidx.core.graphics.PathSegment
```

这是一个由迁移工具生成错误依赖（`androidx.core:core-ktx:0.3`）导致的报错。我们手动更新（参考这次[提交](https://github.com/nickbutcher/plaid/pull/524/commits/8e60a351625b934a650b571dd67f4d206f96ac91)）到正确的依赖版本（`androidx.core:core-ktx:1.0.0`）。这个[bug](https://issuetracker.google.com/issues/111260482) 已经在 Android Studio 3.3 Canary 9 及之后的版本被修复。我们指出这点是因为你或许在迁移过程中会遇到类似的问题。

接下来，`Palette` API 在新版中变得可以为空，为了暂时避开（参考这次[提交](https://github.com/nickbutcher/plaid/pull/524/commits/75b8ffd621693ac52a0ce243599cfcfd25242d5f)）这点，我们添加了`!!`（[非空断言操作符](https://kotlinlang.org/docs/reference/null-safety.html#the--operator)）。

然后我们遇到了一个 `plusAssign` 缺失的报错。这个加载在 1.0.0 版本中被移除。`plusAssign` 的使用被临时注释掉了（参考这次[提交](https://github.com/nickbutcher/plaid/pull/524/commits/d2cefa384448f4d3fb92dec0ade25d9bd87efb63)）。本文的后面我们会研究对 `Palette` 和 `plusAssign` 问题的可持续解决方案。

现在应用可以运行了，到清理代码的时候了！

### 清理代码

应用在运行中，但是我们的持续集成系统报告了代码提交后的构建错误：

```
Execution failed for task ':designernews:checkDebugAndroidTestClasspath'.

> Conflict with dependency 'androidx.arch.core:core-runtime' in project ':designernews'. 

Resolved versions for runtime classpath (2.0.0) and compile classpath (2.0.1-alpha01) differ. This can lead to runtime crashes. 

To resolve this issue follow advice at https://developer.android.com/studio/build/gradle-tips#configure-project-wide-properties.

Alternatively, you can try to fix the problem by adding this snippet to /.../plaid/designernews/build.gradle:

  dependencies {
    implementation("androidx.arch.core:core-runtime:2.0.1-alpha01")
  }
```

我们依照测试日志中的参考建议，添加了缺失的依赖模块（参考这次[提交](https://github.com/nickbutcher/plaid/pull/524/commits/aba91a9cd5a7a92dc5b9863a6b8c9f980597726b)）。

我们也借此机会更新了我们的 Gradle 插件版本、Gradle wrapper 版本、Kotlin 版本（参考这次[提交](https://github.com/nickbutcher/plaid/pull/524/commits/b38f2cf74520693699fbcedcb0119778396ba0ec)）。Android Studio 推荐我们安装 28.0.3 版本的构建工具，我们也照做了。在使用 Gradle 3.3.0-alpha13 版本插件时我们遇到的问题，通过降级到 3.3.0-alpha8 版本的方式得到解决。

迁移工具的一个缺点是：如果你在依赖版本项使用了变量，迁移工具把它们自动内联。我们从 build.gradle 文件中重新提取了这些版本（参考这次[提交](https://github.com/nickbutcher/plaid/pull/524/commits/0c5a3d62a83ecf400de376f4b4e6e7c3a6bf3c2a)）。

上文中我们提到了运行 AndroidX 迁移工具后对 `plusAssign` 和 `Palette` 问题的临时解决方案。我们通过将 AndroidX 版本降低来重新添加了 plusAssign 函数和相关测试（参考这次[提交](https://github.com/nickbutcher/plaid/pull/524/commits/0a5a5a3d50ece0f671201e1183b971fb4a3e158a)），并且恢复了被注释了的代码。与此同时，我们把 `Palette` 参数更新到可以为空的这个版本（参考这次[提交](https://github.com/nickbutcher/plaid/pull/524/commits/7aad3005ea8ab222443f1a2ea34252e25328d677)），这样就无需使用操作符 `!!`。

同样的，自动转化可能使得某些类需要使用它们的完整类路径。做最少的手工修正是一个好的思路。作为清理工作的一部分，我们移除了完整类路径，并在必要时重新添加了相关引用。

最后，一些少量测试相关的修改被加入工程，围绕着测试过程中的依赖冲突（参考这次[提交](https://github.com/nickbutcher/plaid/pull/524/commits/9715e2f8fdabc21b6d73e2f11f31982e90292461)）和 Room 的测试用例（参考这次[提交](https://github.com/nickbutcher/plaid/pull/524/commits/a997200ec98b8466c427d5ac16eae94bae816da9)）。这时我们的工程完成全部转化，并且我们的测试都已通过。

### 结束过程

尽管遇到了一些障碍，AndroidX 的迁移进展得比较顺利。遇到的问题主要涉及依赖库或类的错误转换，以及新库中的 API 变化。 幸运的是这些都相对容易解决。Plaid 现在已经准备好再被用起来了！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
