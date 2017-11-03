> * 原文地址：[Making the most of the APK analyzer](https://medium.com/google-developers/making-the-most-of-the-apk-analyzer-c066cb871ea2#.k0s1s1kgl)
* 原文作者：[Wojtek Kaliciński](https://medium.com/@wkalicinski)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[XHShirley](https://github.com/XHShirley)
* 校对者：[phxnirvana](https://github.com/phxnirvana), [ZiXYu](https://github.com/ZiXYu)


# 利用好 Android Studio 中的 APK Analyzer

最近的 Android Studio 插件中我最喜欢的是 APK Analyzer。你可以从顶端菜单栏中的 **Build** 找到 **Analyze APK**。
![](https://d262ilb51hltx0.cloudfront.net/max/800/0*RiXOWhjkTw8ELX7M.)

专业提示：你也可以拖拽 APK 文件到编辑栏中打开。

APK Analyzer 让你可以打开并审查存于你电脑中的 APK 文件的内容，不管它是通过本地 Android Studio 工程构建，还是需要从服务器上或者其他构件仓库中构建后得到的。它不需要必须要在任何你所打开的 Android Studio 项目中被构建，甚至也不需要它的源代码。

> **注意：**APK Analyzer 最好用于发布版本的构建。如果你需要分析你 app 的调试版本，确认你的 APK 不是通过 Instant Run 构建出来的。如果想要确认这一点，你可以在顶部菜单栏点击 **Build** → **Build APK**，通过查看 instant-run.zip 文件是否存在，来确认你是否打开了通过 Instant Run 构建 APK。

使用 APK analyzer 是一个非常好的途径来查找 APK 文件并了解它们的[结构](https://developer.android.com/topic/performance/reduce-apk-size.html#apk-structure)，并同时在发布前或调试时验证一些常见问题，例如 APK 大小和 DEX 问题。

###利用 APK Analyzer 为应用“瘦身”

APK analyzer 在应用大小方面可以给你很多有用并且可操作的信息。在屏幕的顶部，你可以从 **Raw File Size** 看到应用占磁盘大小。**Download size** 是一个估计值，表示考虑到在经过 Play Store 的压缩后，你还需要多少流量来下载应用。

文件和文件夹根据文件大小降序排列。这让我们很容易看出对 APK 大小优化最容易从哪里入手。每当你深入到某个文件夹的时候，你能看到占用了 APK 大部分空间的资源和其他实体。

![](https://d262ilb51hltx0.cloudfront.net/max/800/0*DRt5aMTeoIKdwYG1.)
资源根据文件大小以降序的方式排列。

在此例中，在检查一个 APK 是否可能减小大小时，我马上注意到在我们的 drawable 资源中最大的东西是一个 1.5 MB 的 3 帧 PNG 动画，并且这只是一个 **xxhdpi** 的分辨率啊！

显然这些图片都非常适合用向量来储存，所以我们使用 Android Studio 2.2里 [向量资源导入工具新的 PSD 支持功能](https://developer.android.com/studio/write/vector-asset-studio.html)，找到对应图片的资源文件并把它们作为 VectorDrawable 引用

对其他剩余的动画 (**instruction_touch***.png)_ 重复这个步骤直到把所有分辨率文件夹里的 PNG 文件都移除，那么我们就能节省 5MB 的空间。我们使用支持库中的 [_VectorDrawableCompat_](https://medium.com/@chrisbanes/appcompat-v23-2-age-of-the-vectors-91cbafa87c88) 来保持向前兼容。

我们同样也容易发现，在其他的资源文件中，一些没有被压缩的 **WAV** 文件可以被转换成 **OGG** 文件。这意味着我们不用动一行代码就可以节省更多的空间。

![](https://d262ilb51hltx0.cloudfront.net/max/600/0*AcjFk-xj6PKOXRWe.)
浏览 APK 里的其它文件夹

接下来要检查的是包含了我们支持的3个 ABI 的本地库， **lib/** 文件夹，

我们决定用 Gradle 构建里的 [APK 分离支持](https://developer.android.com/studio/build/configure-apk-splits.html) 为每个 ABI 各创建一个版本。

我快速浏览了一遍 AndroidManifest.xml 并发现缺少 [**android:extractNativeLibs**](https://developer.android.com/reference/android/R.attr.html#extractNativeLibs) 属性。把它设置为 **false** 可以节省一点设备上的空间，因为它能阻止把本地库从 APK 拷贝到文件系统上。唯一的要求是文件已经经过整理并且未压缩地存于 APK 里。这个功能仅在高于 2.2.0 版本的 Android Gradle 插件中使用。

![](https://d262ilb51hltx0.cloudfront.net/max/800/0*VgknN7SJh9z7hOya.)
在 APK Analyzer 中浏览到的整个 AndroidManifest.xml 文件

做完这些修改，我想知道现在的新版本跟旧版本对比有什么不同。我切换到我最开始提交的地方，编译 APK 并保存在别的文件夹。然后，我用 **Compare with…** 功能查看新版本和旧版本的大小差异。

![](https://d262ilb51hltx0.cloudfront.net/max/800/0*W_ZzJpAzon5xAHpc.)
APK 对比 － 右上角按钮

可以看到，我们对资源和本地库的修改取得了很大的成效，只用很少的更改节省了 17MB 的总大小。但是，我们的 DEX 却增加了 400KB。

### 调试 DEX 增大的问题

在这个例子中，大小的差异来源于升级我们的依赖到最新的版本并且添加了新的库。我们已经使用了 [Proguard](https://developer.android.com/studio/build/shrink-code.html#shrink-code) 和 [Multidex](https://developer.android.com/studio/build/multidex.html) 来构建，所以我们无法再对 DEX 的大小做更多修改。但 APK analyzer 仍然是调试这些配置的利器，特别是当你在工程中第一次开启 Multidex 或者 Proguard。

![](https://d262ilb51hltx0.cloudfront.net/max/800/0*bOKK2M9iFTXVfUrs.)
探索 classes.dex 的内容

当你点击任何 DEX 文件，你可以看到一个含有多少类和方法被定义，以及它包含的总引用数（引用数不包括在单个 DEX 文件的 [64K 限制](https://developer.android.com/studio/build/multidex.html#about)里）的总结。在示例的截屏中，应用程序刚好达到限制，这意味着它马上将需要 MultiDex 去分离类到不同的文件中。

你可以深入到包里查看到底是谁使用了这些引用。在本例中，支持库和 Google Play 服务是造成这个情况的主要原因：

![](https://d262ilb51hltx0.cloudfront.net/max/800/0*_X6y5PXnNG_e_QK-.)
每个包的引用数

一旦你启用了 MultiDex 并编译你的应用，你会发现第二个 DEX 文件，classes2.dex（还可能有第三个 classes3.dex 或者更多）。Android gradle 插件会找出启动应用所需的类文件，并把它们放在主要的 classes.dex 文件。但是也有极少情况，它不能识别这些文件，并抛出 ClassNotFoundException 的错误。这种情况下，你可以用 APK analyzer 去检查 DEX 文件，然后[强制把缺少的类放进主要的 DEX 文件](http://google.github.io/android-gradle-dsl/2.2/com.android.build.gradle.internal.dsl.ProductFlavor.html#com.android.build.gradle.internal.dsl.ProductFlavor:multiDexKeepFile).

当你开启了 Proguard 并且利用反射或者在 XML 布局中调用类或方法，你会遇到类似的问题。APK Analyzer 可以帮助你验证你的 Proguard 的配置是否正确，比如查看你需要的方法或类是否在 APK 中存在或者它们是否被重命名（混淆）。你可以确定你不需要的类是不是被移除了，且没有占用之前说的引用方法数。

我们真的非常想知道你所知道的 APK Analyzer 的其它功能以及你期待这个工具还应该具备怎么样的功能！
