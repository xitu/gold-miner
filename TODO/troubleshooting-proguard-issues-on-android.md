> * 原文地址：[Troubleshooting ProGuard issues on Android](https://medium.com/google-developers/troubleshooting-proguard-issues-on-android-bce9de4f8a74)
> * 原文作者：[Wojtek Kaliciński](https://medium.com/@wkalicinski?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/troubleshooting-proguard-issues-on-android.md](https://github.com/xitu/gold-miner/blob/master/TODO/troubleshooting-proguard-issues-on-android.md)
> * 译者：[dieyidezui](http://www.dieyidezui.com)
> * 校对者：[corresponding](https://github.com/corresponding)

# ProGuard 在 Android 上的使用姿势

## 为什么使用 ProGuard

ProGuard 是一个压缩、优化、混淆代码的工具。尽管有很多其他工具供开发者们使用，但是 ProGuard 作为 Android Gradle 构建过程的一部分，已经打包在 SDK 中。

当我们构建应用时，使用 ProGuard 有很多好处。有的开发者更关心混淆这块功能，对我而言最大的用处是打包时移除 dex 中的无用代码。

![](https://cdn-images-1.medium.com/max/800/0*qPTtQ4y-0g9kMye3.)

一个 Android 示例应用的空间分布图，源码地址  [Topeka sample app](https://github.com/googlesamples/android-topeka)。

减少包体积的好处有很多，比如增加用户黏性和满意度，提升下载速度，减少安装时间，以便在终端设备上连接用户，尤其是在新兴市场。当然，有时候您不得不限制您的应用的大小，比如 [Instant App 限制大小 4 MB](https://developer.android.com/topic/instant-apps/faqs.html#apk-size)，此时 ProGuard 显得必不可少了。

如果以上还不足以说服您使用 ProGuard，其实移除无用代码和混淆所有名称还有其他更多的优化效果：

* 在一些版本的 Android 设备上，DEX 代码会在安装或者运行时被编译成机器码。原始的 DEX 和优化后的机器码都会保留在设备中，所以算一下就知道：**代码越少，意味着编译时间越短，存储占用越少**。
* ProGuard 除了可以大幅减少代码的空间之外，还可以**让所有的标识符（包、类和成员）都使用更短的名字**，如 `a.A` 和 `a.a.B`。这个过程就是混淆。混淆通过两种方式来减少代码：让表示名称的字符串更短；在这些方法或者属性有相同的签名情况，下这些字符串更容易被复用，最终减少了字符串池的数目。
* 使用 ProGuard 是开启[资源压缩](https://developer.android.com/studio/build/shrink-code.html#shrink-resources)的前提条件. **资源压缩功能会移除您项目中代码没有引用到的资源文件**（如图片资源，这一般是 APK 中占比最大的部分了）.
* 通过仅将您代码中实际使用的方法打包到 APK 中，**移除代码会帮您避免** [**64K dex 方法引用问题**](https://developer.android.com/studio/build/multidex.html)。尤其是您引用了很多第三方库的时候，这样可以大大降低在您应用中使用 Multidex 的需求。

> **每个 Android 应用都应该使用代码压缩吗？我认为是的！**

但是在您激动的跳起来之前，请先继续阅读下去。当您开启 ProGuard 时，在某些非常微妙的情况下会让您的应用崩溃。虽然有些错误会在构建应用时发生，您能及时发现，但是也有些错误您只能在运行时发现，所以请确保您的应用经过彻底的测试。

### 如何使用 ProGuard？

在您的项目中开启 ProGuard 只需简单到添加如下几行代码在您的主应用模块的 `build.gradle` 文件中：

```
buildTypes {
/* you will normally want to enable ProGuard only for your release
builds, as it’s an additional step that makes the build slower and can make debugging more difficult */
  
  release {
    minifyEnabled true
    proguardFiles getDefaultProguardFile(‘proguard-android.txt’), ‘proguard-rules.pro’
  }
}
```

ProGuard 自身的配置已经在另外一个单独的配置文件中完成了。上面的代码中，我给出了 Android Gradle 打包插件中的默认配置[¹](#9ca6)，接下去我会在 `proguard-rules.pro` 中加入其他的配置。

在 ProGuard 官网您可以找到一个 [使用手册](https://www.guardsquare.com/en/proguard/manual/usage#keepoptions)。
在您深入研究这些配置之前，最好先大概理解 ProGuard 是如何工作的和我们为什么要指定一些额外的选项。

![](https://cdn-images-1.medium.com/max/800/0*Y0tJVDd5RnFy_qUL.)

您也可以去观看 [part of this Google I/O session](https://youtu.be/AdfKNgyT438?t=6m50s) Shai Barack 的教学视频。

简单来说，ProGuard 将您项目中的 .class 文件做为输入，然后寻找代码中所有的调用点，计算出代码中所有可达的调用关系图，然后移除剩余的部分（即不可达的代码和那些不会被调用的代码）。

在您读 ProGuard 手册时，您没必要看那些 输入 / 输出的部分，因为这些 Android Gradle 打包插件会替您指定输入源（您和第三方库的代码) 和 Android jar 库（您构建应用时用到的 Android 框架类）。

想要正确配置 ProGuard，最重要的就是让它知道运行时您的哪些代码不应该被移除（如果开启混淆的话，当然也要保持他们的名称不变）。当一些类和方法会被动态访问到时（如使用反射），在某些情况下，ProGuard 在构建调用图时不能正确的决定他们的「生死」，导致这些代码被错误的移除掉。当您只从 XML 资源引用您的代码会时（通常使用底层的反射），这个情况也会发生。

在一次 Android 典型的构建过程中，AAPT（处理资源的工具）会生成一个额外的 ProGuard 规则文件。它会为 Android 应用添加一些特别的 [**keep 规则**](https://www.guardsquare.com/en/proguard/manual/usage#keepoptions)，所以您在 Android Manifest.xml 中记录的 Activities、Services、BroadcastReceivers 和 ContentProviders  会保持不动. 这就是为什么在上面动图中 `MyActivity` 类没有被被移除或者重命名.

AAPT 也会 **keep** 住所有在 XML 布局文件使用到的 View 类（和它们的构造函数）和其他一些类，如在过渡动画资源中引用到的过渡类。 您可以在构建后直接看这个 AAPT 生成的配置文件，位置是：`<your_project>/<app_module>/build/intermediates/proguard-rules/<variant>/aapt_rules.txt`。

![](https://cdn-images-1.medium.com/max/800/0*nVWailJWyOyv4sa5.)

在构建时 AAPT 生成的一个示例 ProGuard 配置文件

我会在本文[后面章节](#5a16)中讨论更多关于 **keep** 规则，但是在那之前我们最好先学一下在以下情况时应该怎么做：

## 当 ProGuard 打断了您的构建

在您可以测试是否开启 ProGuard 后所有代码在运行时都能正常工作前，您需要先构建您的应用。不幸的是，ProGuard 可能会发现一些引用的类缺失，并给予告警，导致您的构建失败。

修复这个问题的关键是仔细观察构建时输出的消息，理解这些警告的内容并定位他们。通常的途径是修正您的依赖或者在您的 ProGuard 配置中添加 [**-dontwarn**](https://www.guardsquare.com/en/ProGuard/manual/usage#dontwarn) 规则。

这些警告的一个原因就是，您的构建路径中没有加入需要依赖的 JARs，如使用了 _provided_ （仅编译时）依赖。而有时候，在 Android 上这些代码的依赖在运行时并不会被真正的调用。让我们看一个真实的例子。

![](https://cdn-images-1.medium.com/max/800/0*a4_7ZBbkOG3gncuN.)

一个项目依赖 OkHttp 3.8.0 构建时的消息。

OkHttp 库在 3.8.0 版本的类中添加了新的注解（`javax.annotation.Nullable`）。但是因为它们使用了编译时的依赖，所以这些注解在最终构建时不会被打包进去（哪怕应用显式的依赖了 `com.google.code.findbugs:jsr305`），因此 [ProGuard 会抱怨](https://github.com/square/okhttp/issues/3355) 缺失了这些类.

因为我们知道这些注解类在运行时不会被使用，我们可以通过在 ProGuard 配置中添加 **-dontwarn** 规则来安全地忽略掉这些警告，如  [在 OkHttp 文档中加入这些规则](https://github.com/square/okhttp/pull/3354/files)：

```
-dontwarn javax.annotation.Nullable  
-dontwarn javax.annotation.ParametersAreNonnullByDefault
```

您应该经历过类似的过程，在输出消息中看到这些警告，然后重新构建直到构建通过。重要的是去理解为什么您会收到这些警告以及您在构建时是否真的缺少这些类。

现在您可能会尝试使用 **-**[**ignorewarnings**](https://www.guardsquare.com/en/proguard/manual/usage#ignorewarnings) 选项直接忽略所有的警告，但这通常不是个好注意。在某些情况下，ProGuard 的警告确实有助于您发现闪退的罪魁祸首和关于[您配置上的其他问题](https://www.guardsquare.com/en/proguard/manual/troubleshooting#dynamicalclass)。

您可能需要了解一下 Progard的 _notes_ （优先级低于警告的消息），它可以帮您发现一些反射相关的问题。虽然它不会打断您的构建，但是在运行时可能会闪退。这会在下面的场景中发生：

## 当 ProGuard 移除过多的类

在某些情况下，ProGuard 并不知道一个类或者方法被使用了，例如这个类仅在反射时被使用或者仅在 XML 中被引用。为了阻止这样的代码被移除或混淆，您应当在 ProGuard 配置中指定额外 [**keep** 规则](https://www.guardsquare.com/en/proguard/manual/usage#keepoptions)。这取决于作为应用开发者的你，需要去发现哪些部分代码有问题并提供必要的规则。

当运行时发生了 `ClassNotFoundException` 或 `MethodNotFoundException` 异常意味着您肯定缺失了某些类或者方法，也许是 ProGuard  移除了他们，又或者是因为错误配置依赖而导致无法找到他们。所以生产环境的构建（开启 ProGuard 时）一定要注重彻底的测试并正视这些错误。


您有很多选项来配置您的 ProGuard：

* **keep **— 保留所有匹配的类和方法
* **keepclassmembers **— 当且仅当它们的类因为其他的原因被保留时（被其他调用点引用到或者被其他的规则 keep 住），keep 住指定的一些成员
* **keepclasseswithmembers **— 当且仅当所有的成员在匹配的类中存在时，会 keep 住 这些类和它的成员

我建议您从 ProGuard 的这篇 [class specification syntax](https://www.guardsquare.com/en/proguard/manual/usage#classspecification) 开始熟悉，此文讨论了上述所有的 keep 规则和前一段讨论到的 **-dontwarn** 选项。另外这三个 keep 规则也各有一个不同的版本支持仅保留混淆（重命名），不保留压缩。您可以在 ProGuard 官网的[表格](https://www.guardsquare.com/en/proguard/manual/usage#keepoverview)看一下概览。

作为一个可选的方案来写 ProGuard 规则，您可以直接在某个不想被混淆和移除的类、方法、属性上添加 [**@Keep**](https://developer.android.com/reference/android/support/annotation/Keep.html)  注解。注意，如果这样做的话，您需要把 Android 默认的 ProGuard 配置加入到您的构建中。

## APK Analyzer 和 ProGuard

Android Studio 集成的 [APK Analyzer](https://developer.android.com/studio/build/apk-analyzer.html) 可以帮您看到哪些类被 ProGuard 移除了并支持为它们生成 keep 规则。当您构建 APK 时开启了 ProGuard，那么会额外输出一些文件在 `<app_module>/build/outputs/mapping/` 目录下。这些文件包含了移除代码的信息、混淆的映射关系。

![](https://cdn-images-1.medium.com/max/800/0*ds03uyRBXdHyi7pV.)

加载 ProGuard 映射文件到 APK Analyzer 可以看到 DEX 视图中更多的信息

当您加载了映射文件到 APK Analyzer时（点击 _“Load Proguard mappings… “_ 按钮）， 您可以在 DEX 视图树中看到一些额外功能：

* 所有的名字都是混淆前的（即您可以看到原始的名字）
* 被 ProGuard 配置规则 **kept** 的包，类，方法和属性会显示成粗体
* 您可以开启 “Show removed nodes” 选项来看任何被 ProGuard 移除的内容（字体上会有删除线）。右击树上的一个节点可以让您生成一个 keep 规则以便您粘贴到您的配置文件中。

## 当 ProGuard 移除过少的类

所有应用都可以使用 Android 内置的 ProGuard 的一些安全的默认规则，如保留 `View`  的 getter 和 setter 方法，因为他们通常会被反射来访问，以及其他一些普通的方法和类都不会被移除。 这在许多情况下可以时您的应用避免崩溃的发生，但是这些配置并不是 100% 适合您的应用。您可以移除掉默认的 ProGuard 文件而使用您自己的。

如果您希望 ProGuard 移除所有未使用的代码，您应当避免 keep 规则写的太宽泛，如加入通配符匹配整个包，而是使用类相关的匹配规则或者使用上面提及的 `@Keep` 注解。

![](https://cdn-images-1.medium.com/max/800/0*p4zsl6tqrwy6jOUr.)

使用 `-whyareyoukeeping <class-specification>` 选项来观察为什么这些类没有被移除。

如果您实在不确定为什么 ProGuard 没有移除您期望它移除的代码，，您可以添加 [**-whyareyoukeeping**](https://www.guardsquare.com/en/proguard/manual/usage#whyareyoukeeping) 选项至 ProGuard 配置文件中，然后重新构建您的应用。在构建输出中，您会看到是什么调用链决定了 ProGuard 保留这些代码。

![](https://cdn-images-1.medium.com/max/800/0*SFubaEvLatNnVmDr.)

在 APK Analyzer 中追踪是什么在 DEX 中 keep 住了这些类和方法

另一种方法不那么精准，但在任何应用都不需要重新构建和额外的工作量。那就是在 APK Analyzer 中打开 DEX 文件，然后右击您关注的类、方法。选择 “_Find usages_” 您将看到引用链，这也许会引导您了解哪部分代码使用指定的类、方法从而阻止了它被移除。

## ProGuard 和 混淆后的堆栈

我之前提及到，在构建过程中 ProGuard 会在处理类文件时输出映射关系和日志文件。当您需要保留构建产物时，您应当保存好这些文件和 APK 在一起。这些映射文件不能被其他的构建所使用，而只会在与它们一起生成的 APK 配合使用时才能确保正确。有了这些映射关系，您才能有效地 debug 用户设备的发生的崩溃。否则太难去定位问题了，因为名字都混淆过了。

![](https://cdn-images-1.medium.com/max/800/0*wzjVsQyikWNXSjbO.)


上传 APK 对应的 ProGuard 映射文件至 Google Play 控制台，从而获得混淆前的堆栈信息。

您在 Google Play 控制台发布混淆后的生产 APK时，记得为每个版本上传对应的映射文件。这样的话当您看 _ANRs & crashes_ 页面时，上报的堆栈都会现实真实的类名、方法名和行号而不是缩短的混淆后的那些。

## 关于 ProGuard 和 第三方库

就像您有责任为您自己的代码提供 keep 规则一样，那些第三方库的作者们也有义务向您提供必要的混淆规则配置来避免开启 Proguard 导致的构建失败或者应用崩溃。

有些项目简单地在他们的文档或者 README 上提及了必要的混淆规则，所以您需要复制粘贴这些规则到您的主 ProGuard 配置文件中。不过有个更好的方法，第三方库的维护者们如果发布的库是 AAR ，那么可以指定规则打包在 AAR 中并会在应用构建时自动暴露给构建系统，通过添加下面几行代码到库模块的 `build.gradle` 文件中：

```
release { //or your own build type  
  consumerProguardFiles ‘consumer-proguard.txt’  
}
```

您写入在 `consumer-proguard.txt` 文件中的规则将会在应用构建时附加到应用主 ProGuard 配置并被使用。

* * *

> **如果想了解更多关于代码和资源压缩的信息，请参考我们的**[**文档页面**](https://developer.android.com/studio/build/shrink-code.html) 
* * *

开启 ProGuard 可能一开始会比较困难，但是我个人认为这些代价是值得的。只要投入一点点时间，您将会获得一个轻量、优化后的应用。此外，现在花费时间去配置您的应用意味着当[实验性的 ProGuard 替代者](https://r8.googlesource.com/r8) R8 就绪时，您已经准备好了。因为 R8 也是用现有的 ProGuard 规则文件来工作的。

除了让您的代码更小巧之外， ProGuard 和 R8 可以选择优化您的代码让它运行得更快，当然这又是另一篇文章的话题了……

* * *

[¹](#6c8e) proguard-android.txt 文件之前是在 SDK tools 目录下（`SDK/tools/proguard/proguard-android.txt`），但在新版的 SDK Tools 和 Android Gradle 插件版本2.2.0+上，可以在构建时从 Android 插件的 jar 中解压出来。在构建您的项目后，您可以在 `<your_project>/build/intermediates/proguard-files/` 目录下找到这个配置文件。

感谢 [Daniel Galpin](https://medium.com/@dagalpin?source=post_page)。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。


