> * 原文地址：[Enabling ProGuard in an Android Instant App](https://medium.com/google-developers/enabling-proguard-in-an-android-instant-app-fbd4fc014518)
> * 原文作者：[Wojtek Kaliciński](https://medium.com/@wkalicinski?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/enabling-proguard-in-an-android-instant-app.md](https://github.com/xitu/gold-miner/blob/master/TODO/enabling-proguard-in-an-android-instant-app.md)
> * 译者：[JayZhaoBoy](https://github.com/JayZhaoBoy)
> * 校对者：[hanliuxin5](https://github.com/hanliuxin5)

# 在 Android Instant App（安卓即时应用程序）中启用 ProGuard （混淆）

**_更新于 2018–01–18:_** _指南第五步中的重要更新，是对非基础模块的必要补充_

### Instant Apps（即时应用）和 4 MB 字节的限制

把一个已经存在的应用程序转换成 [Android Instant App（安卓即时应用程序）](https://developer.android.com/topic/instant-apps/index.html)是很有挑战性的，但对于[模块及结构化你的项目](https://developer.android.com/topic/instant-apps/getting-started/structure.html)而言却是一个很好的练习，更新 SDKs（开发工具包）并遵守所有的 [Instant Apps（即时应用程序）沙箱限制](https://developer.android.com/topic/instant-apps/getting-started/prepare.html)以确保即时应用程序的安全和更快的加载速度。

其中一项限制规定，对于即时应用处理的每个 URL，传送到客户端设备上的功能模块和基本模块的总大小不得超过 4 MB 字节。

想一下你的项目中可能存在的典型的 _common（公共）_ 模块（在 Instant Apps（即时应用程序）术语中，我们将称这个模块为 _base feature（基础功能）_ 模块）：它可能依赖于支持库的许多部分，包含 SDK，图像加载库，公共网络代码等等。这些大量的代码通常只是为了启动，因此不能为实际功能模块代码和资源留出足够的空间来解决 4 MB 字节的限制。

这里有许多[通用](https://developer.android.com/topic/performance/reduce-apk-size.html)和 [安卓即时程序专用（AIA 意为 Android Instant Apps）](https://android-developers.googleblog.com/2017/08/android-instant-apps-best-practices-for.html)的技术可以减少 APK 大小，你应该都去了解一下，但使用 ProGuard（混淆）来移除未使用的代码对 nstant Apps（即使应用程序）而言却是必不可少的，通过丢弃那些你从来不会使用的导入库和代码将有助于缩减所有的这些依赖。

即使[对于常规项目](https://medium.com/google-developers/troubleshooting-proguard-issues-on-android-bce9de4f8a74)配置 ProGuard（混淆）也是很有挑战性的，更何况是 Instant App（即时应用），当你启动的时候，你几乎肯定会遇到构建失败或者程序崩溃的情况。当 ProGuard（混淆）集成到 Android 构建中时，新的 `com.android.feature` Gradle 插件（用于构建 AIA （安卓即时应用程序）模块）根本不存在，并且 ProGuard（混淆）没有考虑模块在运行时如何加载在一起。

幸运的是，你可以一步一步按照下面的流程进行操作，这样可以更轻松地为你的 Instant App（即时应用程序）配置 ProGuard（混淆），本文将对此进行概述。

### 问题剖析 － 两种不同的构建方式

在一个典型的场景中，在模块化应用程序并使用新的 Gradle 插件后，您的项目结构将如下所示：

![](https://cdn-images-1.medium.com/max/800/1*6smk7bsLQmg1kIipUR_V6w.png)

一个典型的多功能安装 + 即时应用程序项目。

在共享的即时应用程序/可安装应用程序项目中，功能模块替换旧的 `com.android.library` 模块。


**当构建一个可安装的应用程序时，ProGuard（混淆）会在构建过程结束时运行**。功能模块的行为与库相似，它们都将代码和资源提供给编译的最后阶段，在应用程序模块中这些都发生在将所有东西打包成一个 APK 之前。在这种情况下，ProGuard（混淆）能够分析你的整个代码库，找出哪些类被使用，哪些可以被安全地删除。

**在即时应用程序构建中，每个功能模块都会生成自己的 APK。**因此，与可安装的应用程序构建相反，**ProGuard（混淆）可以独立运行在每个功能模块的代码中**。例如：base feature 编译，代码缩减和打包发生时无需查看 feature 1 和 2 中包含的任何代码。

简单地说：如果你的 base feature 包含的公共元素（例如 AppCompat 小部件）仅在功能 1 和/或功能 2 中使用但并未在基本功能本身中，则这些元素将被 ProGuard（混淆）删除，导致运行时崩溃。

现在我们明白了为什么 ProGuard（混淆）会失败了，是时候解决这个问题了：确保我们为项目配置添加必要的保留规则，**以防止在不同模块（在一个模块中定义，在另一个中使用）之间的类被移除或混淆。**

### 层层深入的解决方案

#### 1. 在你构建你的可安装程序中启用 ProGuard（混淆）并修复所有的运行时异常

这是最困难的部分，也是唯一不容易复现的部分，因为每个项目所需的 ProGuard（混淆）配置规则会有所不同。我建议在处理 ProGuard（混淆）错误前熟读 [Android Studio 文档](https://developer.android.com/studio/build/shrink-code.html)，[ProGuard （混淆）手册](https://www.guardsquare.com/en/proguard/manual/introduction) 以及我的[上一篇文章](https://medium.com/google-developers/troubleshooting-proguard-issues-on-android-bce9de4f8a74) 。

接下来我们将在即时应用程序 ProGuard（混淆）配置来自可安装应用中的规则。

#### 2. 为你所有的即时应用功能启用 ProGuard（混淆）

在可安装的应用程序版本构建过程中，ProGuard（混淆）只运行一次：在使用 `com.android.application` 插件的模块中。在即时应用程序构建过程中，我们需要将 ProGuard（混淆）配置添加到所有功能模块，因为它们都会生成 APK。

打开每个 `com.android.feature` 模块中的 `build.gradle` 文件，并为它们添加以下配置：

```
android {
  buildTypes {
    release {
      minifyEnabled true
      proguardFiles getDefaultProguardFile('proguard-android.txt'), 'aia-proguard-rules.pro'
    }
  }
  ...
}
```

在上面的代码片段中，我选择了一个名为 `aia-proguard-rules.pro` 的文件用于我的 Android Instant App（安卓即时应用程序）专用 ProGuard（混淆）配置。对于该文件的初始内容，您应该复制并粘贴可安装应用程序中的规则（从本指南的第 1 步中）。

如果你愿意，不必为每个功能创建单独的规则文件，您可以使用相对路径（例如「../ aia-proguard-rules.pro」）将所有功能模块指向单个文件。

#### 3. 为从代码中使用了跨模块的类添加保留规则

我们需要从功能 APKs 中找出使用基本模块中的哪些类。你可以通过检查来源手动追踪，但对于大型项目这种方法是不可行的。窍门是使用 Android SDK 中提供的工具来近乎自动化的执行这个操作。

首先，准备好一个调试版本（或者没有启用 ProGuard（混淆）的调试版本）。解压 ZIP 文件（通常在 `<instant-module-name> / build / outputs / apks / debug` 中找到），以便你可以轻松访问这些 feature 和 base APK。。

```
$ unzip instant-debug.zip
Archive: instant-debug.zip
  inflating: base-debug.apk
  inflating: main-debug.apk
  inflating: detail-debug.apk
```

每个 APK 都包含一个（或多个）`classes.dex` 文件，该文件包含从其构建的模块的所有代码。有了关于 _DEX_ 格式和[命令行 APK 分析器](https://developer.android.com/studio/command-line/apkanalyzer.html)（一个分析 APK 中 DEX 文件的工具）的一些知识，我们可以很容易地找到所选模块中哪些被使用了但没有定义的类。我们来看看 _detail_ 模块的 DEX 内容：

```
$ ~/Android/Sdk/tools/bin/apkanalyzer dex packages detail-debug.apk
P d 23 37 3216 com.example.android.unsplash
C d 10 20 1513 com.example.android.unsplash.DetailActivity
M d 1  1  70   com.example.android.unsplash.DetailActivity <init>()
...
P r 0 8 196 android.support.v4.view
C r 0 8 196 android.support.v4.view.ViewPager
```

输出结果显示了 (P)ackages，(C)lasses 以及 (M)ethods（上文第 1 列中的 _P / C / M_ ）是被这个文件所 (d)efined（定义）又或者仅仅被 (r)eferenced（引用）（上文第 2 列中的 _s / r_ ）。

_referenced_ 类只能来自两个地方：Android 框架或其他模块，这取决于...答对了！使用一点 shell 魔法（我在后面的所有命令都是基于 Linux 系统的 bash命令），我们可以得到 ProGuard（混淆）规则中需要保留的类的列表：

```
$ apkanalyzer dex packages detail-debug.apk | grep "^C r" | cut -f4
com.example.android.unsplash.ui.pager.DetailViewPagerAdapter
com.example.android.unsplash.ui.DetailSharedElementEnterCallback
com.example.android.unsplash.data.PhotoService
android.support.v4.view.ViewPager
android.transition.Slide
android.transition.TransitionSet
android.transition.Fade
android.app.Activity
...
```

我们可以通过任何手段摆脱哪些来自框架的类（我们不需要包含这些规则，因为它们不是应用程序 APK 的一部分），比如 `android.app.Activity`？因此我们可以先通过 SDK 中的 android.jar 获取框架类的列表来进行过滤：

```
$ jar tf ~/Android/Sdk/platforms/android-27/android.jar | sed s/.class$// | sed -e s-/-.-g
java.io.InterruptedIOException
java.io.FileNotFoundException
...
android.app.Activity
android.app.MediaRouteButton
android.app.AlertDialog$Builder
android.app.Notification$InboxStyle
```

最后使用`[comm](https://linux.die.net/man/1/comm)` 命令（逐行比较两个已排序的文件）列出仅存在于第一个列表中的类，通过管道按照前两个命令输出的排序进行输入：

```
$ comm -23 <(apkanalyzer dex packages detail-debug.apk | grep "^C r" | cut -f4 | sort) <(jar tf ~/Android/Sdk/platforms/android-27/android.jar | sed s/.class$// | sed -e s-/-.-g | sort)
android.support.v4.view.ViewPager
com.example.android.unsplash.data.PhotoService
com.example.android.unsplash.ui.DetailSharedElementEnterCallback
com.example.android.unsplash.ui.pager.DetailViewPagerAdapter
```

唷！谁会不喜欢 shell 中的一些文本处理呢？剩下的就是取出输出的每一行，并将其转换为 `aia-proguard-rules.pro` 文件中的 ProGuard（混淆）保留规则。 它看起来应该像这样：

```
-keep, includedescriptorclasses class android.support.v4.view.ViewPager {
  public protected *;
}
-keep, includedescriptorclasses class com.example.android.unsplash.data.PhotoService {
  public protected *;
}
#and so on for every class in the output…
```

#### 4. 为从资源文件中出现的跨模块类添加保留规则

我们差不多完成了，但还有一个细节需要我们处理。有时我们偶尔会使用 Android 资源中的类，例如从 XML 布局文件中实例化一个小部件，但实际上从未实际从代码中引用该类。

在已安装的应用程序构建中，AAPT（处理资源构建的一部分）会自动为你处理。它为资源文件和 Android Manifest 中使用的类生成所需的 ProGuard（混淆）规则，但在构建即时应用程序的情况下，它们最终可能会出现在错误的模块中。

要解决这个问题，首先要启用 ProGuard（混淆）来开发即时应用程序（例如使用刚刚在前面步骤中设置的构建方式）。然后进入每个模块的构建文件夹，找到 `aapt_rules.txt` 文件（查看与此类似的路径：`build / intermediates / proguard-rules / feature / release / aapt_rules.txt`）并将其内容复制并粘贴到你的`aia-proguard-rules.pro`配置中。

#### 5. 新功能：禁用非基本模块中的混淆

现在看来，我在我的指南中遗漏了一个重要的（现在很明显就发现了）的点。由于非基本模块会被独立地 ProGuard（混淆），因此这些模块中的类可以在混淆期间轻松地分配相同的名称。

例如，在模块 _detail_ 中，名为 `com.sample.DetailActivity` 的类变为`com.sample.a`，而在模块 _main_ 中，类  `com.sample.MainActivity` 也变为 `com.sample.a`。这可能会在运行时导致 _ClassCastException_ 或其他奇怪的行为，因为只能有一个结果类将会被加载和使用。

有两种方法可以做到这一点。更好的方法是在完整的，可安装的应用程序中重新使用 ProGuard（混淆）映射文件，但设置和维护起来很困难。更简单的方法是简单地禁用非基本特征中的混淆。因此，由于类和方法名较长，你的 APK 会稍微大一点，但你仍然享受这删除代码带来的好处，这是最重要的部分。

要为非基本模块禁用混淆处理，请将此规则添加到其ProGuard（混淆）配置中：

```
-dontobfuscate
```

如果你在基本模块和非基本模块之间有共享配置文件，我建议你创建一个单独的配置文件。基础模块仍然可以使用混淆。你可以在 build.gradle 中指定其他文件：

```
release {
  minifyEnabled true
  signingConfig signingConfigs.debug
  proguardFiles getDefaultProguardFile("proguard-android.txt"), "../instant/proguard.pro", "non-base.pro"
}
```

#### 6. 构建并测试你的即时应用程序

如果你按照步骤 1 中进行了最初的 ProGuard（混淆）设置，并且正确执行了步骤 2-4，那么到目前为止，你应该拥有一个较小的，经过优化的即时应用，该应用不会因 ProGuard（混淆）问题而崩溃。请记住通过运行应用程序并检查所有可能的情况来彻底进行测试，因为某些错误只能在运行时发生。

* * *

希望本指南能够让你更好地理解为什么 ProGuard（混淆）可以使你的即时应用程序崩溃。遵循这些步骤应该能带你完成构建，并防止你的即时应用程序崩溃。

你可以在 GitHub 上看看最新的一些使用 ProGuard（混淆）配置的[即时应用示例](https://github.com/googlesamples/android-instant-apps/blob/master/multi-feature-module/proguard.pro) 来和你的相比较，或者练习本文中介绍的相关示例项目的方法。

我承认可以通过设置每个方法的保留规则而不是每个类来改进上面的解决方案（引用方法列表的命令是：`apkanalyzer dex packages detail-debug.apk | grep"^ M r"| cut - f4`），这可能节省出更大的空间。但这会让本教程的其余部分（例如筛选框架类）变得更加复杂，所以我将它作为练习给读者你。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
