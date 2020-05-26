> * 原文地址：[Android Studio Project Marble: Apply Changes](https://medium.com/androiddevelopers/android-studio-project-marble-apply-changes-e3048662e8cd)
> * 原文作者：[Jon Tsao](https://medium.com/@jontsao)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/android-studio-project-marble-apply-changes.md](https://github.com/xitu/gold-miner/blob/master/TODO1/android-studio-project-marble-apply-changes.md)
> * 译者：[qiuyuezhong](https://github.com/qiuyuezhong)
> * 校对者：[phxnirvana](https://github.com/phxnirvana)

# Android Studio Project Marble: Apply Changes

### 深入探讨 Android Studio 团队如何构建 Instant Run 的后继者 —— Apply Changes。

![](https://cdn-images-1.medium.com/max/10400/1*dAZ5ygLJ9llUxAr7_TmKrg.png)

**Android Studio 团队有一系列深入探讨 [Project Marble](https://android-developers.googleblog.com/2019/01/android-studio-33.html) 细节和幕后情况的文章，本文是其中的第一篇。从发布 [Android Studio 3.3](https://android-developers.googleblog.com/2019/01/android-studio-33.html) 开始，Project Marble 就致力于保证 IDE 基本功能的稳定性和流畅度。这篇文章是由 Apply Changes 团队的 Jon Tsao（产品经理），Esteban de la Canal（技术负责人），Fabien Sanglard（工程师）和 Alan Leung（工程师）共同完成。**

Android Studio 的一个主要目标是为你的 app 提供快速的代码编辑和验证工具。当我们创建 Instant Run 的时候，我们希望它能够明显加速你的开发流程，但是现在看来它并没有达到预期目标。作为 Project Marble 的一部分，我们一直在重新思考 Instant Run，并提出了一个更实用的替代方案 Apply Changes。Apply Changes 作为一个可以加快开发流程的新方法，最初在 Android Studio 3.5 的 Canary Channel [发布预览](https://androidstudio.googleblog.com/2019/01/android-studio-35-canary-1-available.html)。在这篇文章中，我们想深入聊聊它是如何工作的，以及迄今为止我们的工作。

## Instant Run

通过 Instant Run，我们想解决两个问题：1）节省构建和部署应用程序到设备上的时间，2）使应用程序在不丢失运行状态的情况下部署更改。为了在 Instant Run 中做到这一点，我们在构建的时候重写你的 APK 来注入钩子，以便在运行的时候进行类的替换。要更详细的了解 Instant Run 背后的架构，可以参考几年前 [Medium 上的这篇文章](https://medium.com/google-developers/instant-run-how-does-it-work-294a1633367f)。

对于简单的 app，这个方案一般都表现很好，但是对于更复杂的 app 来说，它可能会使构建时间变长，或者会由于 app 与 Instant Run 构建过程之间有冲突而导致令人头疼的错误。随着这些问题的出现，我们在后续的版本中持续改进提升 Instant Run。但是，我们无法完全解决这些问题，让它符合我们的期望。

我们后退了一步，决定从头开始构建一个新的架构，它就是 Apply Changes。和 Instant Run 不同，Apply Changes 不会在构建的时候修改你的 APK。取而代之，我们用 Android 8.0（Oreo）上支持的 Runtime Instrumentation 以及更新的设备和模拟器在运行时重定义类。

## Apply Changes

对于运行在 Android 8.0 或者更新版本上的设备和虚拟机，Android Studio 现在有三个按钮来控制应用程序重启的程度：

* **Run** 会部署所有的改动并重启应用程序。

* **Apply Changes** 会尝试应用资源和代码的更改，并只重启 Activity 而不是重启应用程序。

* **Apply Code Changes** 会尝试应用代码的更改，而不重启任何东西。

通常只有方法体内部的代码更改才对 Apply Changes 具有兼容性。

## 原则

基于在 Instant Run 上的经验和反馈，我们采用了一些原则来指导我们的架构设计和决策：

1. **将构建/部署的速度和状态丢失两者独立开**。我们想将节省构建和部署的时间，与在不丢失运行状态的情况下部署更改这两个目标分开。不管是一般的运行或者调试，或者代码的热替换，快速构建和部署应该是**所有**部署类型的目标。作为构建 Apply Changes 的一部分，我们发现了很多可以优化构建和部署速度的领域，在后面的文章中，我们会详细介绍它们。

2. **稳定性至关重要**。即便在 100 次中这个功能以极快的速度运行了 99 次，如果你的 app 因为这个功能而崩溃了一次，并且你花半个小时来尝试找出原因，那么其他 99 次获得的收益也就全部被抵消了。由于我们坚持这一原则，Apply Changes 不会像 Instant Run 那样在构建期间修改你的 APK。带来的副作用是，在我们进行稳定性优化的早期版本中，Apply Changes 会比 Instant Run 的平均速度稍慢，但是我们将继续提高构建和部署的速度。

3. **透明**。Instant Run 按钮会自动决定是否在必要时重启你的 app 或者 Activity，对于这样不可预测性和行为不一致性的反馈，我们也考虑了进来。我们希望在任何时候你都能清楚透明的了解 Apply Changes 要做什么，如果你的代码有不兼容的修改会发生什么。因此如果有检测到与 Apply Changes 不兼容的修改，我们现在会明确提示你。

## 架构

我们来深入研究下 Apply Changes 是如何工作的。在你修改 app 之后，当前设备上已经安装或正在运行的应用程序和 Android Studio 刚刚编译出来的应用程序是有差异的，Apply Changes 需要弄清楚如何应用这些差异。这个过程可以分成两个步骤：1）弄清楚差异是什么，2）将差异发送到设备上并应用它。

为了快速确定差异，Apply Changes 没有从设备抓取完整的 APK，而是向设备发送一个快速的请求，去拉取已经安装 APK 的对应[目录](https://en.wikipedia.org/wiki/Zip_(file_format)#Central_directory_file_header)和[签名](https://source.android.com/security/apksigning)。将这两部分信息和新 APK 进行比较，Apply Changes 可以高效地找出自上次部署以来修改过的文件列表，而不需要检查 APK 的所有内容。需要注意的是，这个算法并不依赖于构建系统，因为差异并不是与上一次构建相比较得到的，而是与安装到设备上的 APK 比较得来。由于 Apply Changes 只针对 APK 之间的差异进行操作，因此它并不要求 Gradle 插件版本和 Gradle 同步。这样，Apply Changes 可以运行于所有的构建系统上。

在生成更改过的文件列表之后，根据所更改的内容，需要执行不同的操作来将这些更改应用到正在运行的 app 上，这也决定了要使这些更改生效，app 需要重启到什么程度：

**更改 resource/asset 文件**。
这种情况下会重新安装应用程序，但只会重启 Activity，并获取修改后的资源。只有修改过的资源才会被发送到设备上。

**更改 [.dex](https://source.android.com/devices/tech/dalvik/dex-format) 文件**。
Android 8.0 的 Android Runtime 提供了替换已加载类的字节码的能力，只要新的字节码不会改变内存中现有对象的布局。这意味着要想兼容 Apply Changes，更改的代码会有一些限制：方法名，类名，和签名都不能更改，它们的成员变量也不能更改。

但这个机制不能在 .dex 级别，只能在类级别工作。否则，如果 .dex 文件包含成千上万个类，即便只有一个类更改了，也需要对所有类进行替换，这样效率太低。对于 .dex 文件，我们比较它的内容来找出更改过的类，只替换掉它们。如果替换成功（例如，类的布局没有改变），为了避免正在运行和已安装的 app 的版本不一致，会在后台安装 app。

**更改 .dex 文件和资源文件**。
这个情况是上面两种情况的组合。先处理代码的部分，如果成功了，会和新的资源一起安装。为了加载新的资源，主 Activity 会被重启。这是一个全做或全不做的操作，如果代码的改变不能成功地应用，正在运行的 app 什么都不会改变。

**更改其他东西**。
这是最糟的情况，比如 AndroidManifest.xml 或者 native .so 这些文件被更改了。在这种情况下，是不可能不重启应用程序来应用更改的。“Apply Changes” 和 “Apply Code Changes”这两个操作都不会试图去部署它，它们会告诉用户应用程序需要重启。

![**Flow of the architecture described above**](https://cdn-images-1.medium.com/max/2240/1*aD1y7EprEnSzM-3FwbUsRQ.png)

**关于架构的更多详细信息，请收听 Android Developers Backstage 播客的[最新一集](http://androidbackstage.blogspot.com/2019/02/episode-108-instant-re-run.html)，技术负责人 Esteban de la Canal 对 Apply Changes 进行了深入探讨。**

## 比较 .dex 文件

前一个部分解释了 Apply Changes 需要比较并确认在设备上更改（修改/添加/删除）了哪个具体的类。为了不增加从设备获取大量内容的开销，它在后台使用了 [D8](https://android-developers.googleblog.com/2018/04/android-studio-switching-to-d8-dexer.html) 的 DEX 文件分析能力来检查 Android Studio 部署到设备上的每个 .dex 文件的内容。根据 .dex 文件中的各个类，计算出校验和，并临时保存在主机的一个缓存数据库中。通过对比新编译的 .dex 文件和之前的 .dex 文件的校验和，Apply Changes 可以在很短的时间内找到更改过的类。

## Delta push

如上所述，只有更改了的文件才会被发送到设备上，我们称之为 “ delta push”。与上面提到的 DEX 文件对比类似，Apply Changes 计算已安装的 APK 和最近构建的 APK 之间的差异，而不需要从设备获取所有内容。这次，它只获取压缩文件的 [Central Directory](https://en.wikipedia.org/wiki/Zip_(file_format)#Central_directory_file_header)，并保守估计相应 APK 之间可能存在的差异。通过只传输已经改变的部分，Android Studio 传输的数据比完整的 APK 上传要少很多。在大多数情况下，总传输数据从几 MiB 减少到几 KiB。

## 接下来

现在可以在 Android Studio 3.5 的 Canary release channel 中使用 Apply Changes。我们欢迎[下载最新的 Android Studio](https://developer.android.com/studio/preview/install-preview)，将 Apply Changes 使用到你的项目中，并向我们提出早期的反馈。作为提醒，你可以同时[运行 Android Studio 的稳定版本和 canary release 版本](https://developer.android.com/studio/preview/install-preview#install_alongside_your_stable_version) 。如果你在使用 Apply Changes 时遇到任何问题，请[提交一个 bug](https://issuetracker.google.com/issues/new?component=550294&template=1207130) 并附上对应的 [idea.log 文件](https://intellij-support.jetbrains.com/hc/en-us/articles/207241085-Locating-IDE-log-files)。我们会持续优化部署性能，修复 bug，并听取你的建议和反馈。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
