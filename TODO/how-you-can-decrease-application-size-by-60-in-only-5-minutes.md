> * 原文地址：[How you can decrease application size by 60% (In only 5 minutes)?](https://medium.com/@kevalpatel2106/how-you-can-decrease-application-size-by-60-in-only-5-minutes-47eff3e7874e#.n28fz5n36)
> * 原文作者：本文已获作者 [Keval Patel](https://medium.com/@kevalpatel2106) 授权
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：[jifaxu](https://github.com/jifaxu)
> * 校对者：[gaozp](https://github.com/gaozp), [ZiXYu](https://github.com/ZiXYu)

# 我是如何做到在 5 分钟之内将应用大小减少 60% 的

![](https://cdn-images-1.medium.com/max/800/1*ShbFj2IhKm6Cbn9qATiGug.png)

移动设备的资源总是有限的。有限的电量，有限的存储，有限的处理能力，有限的内存，有限的网络带宽……无论你面对的是 Android 还是 iOS，这都是真理。

在前几个月，我在开发一个安卓应用 [**Anti-Theft Screen Lock**](https://play.google.com/store/apps/details?id=com.antitheftlock)。当有人尝试用错误的密码解锁设备时，这个应用会通过前置摄像头拍照并播放警示音。如果你想了解更多，这里有 Play 商店的页面：

[**Anti-Theft Screen Lock - Android Apps on Google Play**](https://play.google.com/store/apps/details?id=com.antitheftlock)

在这儿我会教你一些我用来减小应用体积的技巧。这些技巧都简单且易用，会在现在或将来为你提供一些帮助。

---

### 越小越好

作为一个开发者我们总是更关心应用的性能，设计和用户体验。但是，大多数开发者都忘了（或低估）一件事：**应用体积**。如果你希望你的应用能吸引大量用户，这是非常核心的一点。

市场上大概有 11000 种安卓机型，而其中大部分都是低端机，有限的存储（1GB 到 8GB），甚至用的还是 2G 或者 3G 网络。这些设备在印度，巴其尔等非洲发展中国家占有大量市场，你可以在这些地方获得大量的用户。

让你的应用大小保持最佳变得尤其重要。**你的应用体积越小，你的用户就有更多的空间来存储他们的视频和图片**。说实话，你肯定不希望用户因为“存储空间不足”的提示删除你的应用。

![](https://cdn-images-1.medium.com/max/800/1*cjMsR_IEniBq3SXQ3YtJ6g.jpeg)

如果用户的存储空间不够的话，他们会卸载你的应用。
这些发展中国家用户使用的依然是速度有限的 2G/3G 网。所以，如果你的应用体积太大，将会需要更多的时间来下载（更可能的情况时用户根本不会去下载）。同样的，大多数用户流量有限，用户下载的每个字节都是在花钱。

所以，很明显了，应用程序界的真理就是：

> 越小越好

---

### 使用 APK Analyser 分解你的 APK

Android Studio 提供了一个有用的工具：[**APK Analyser**](https://developer.android.com/studio/build/apk-analyzer.html)。APK Analyser 将会拆解你的应用并让你知道 .apk 文件中的那个部分占据了大量空间。让我们看一下 Anti-Theft 在没有经过优化之前的截图。

![](https://cdn-images-1.medium.com/max/1000/1*qwluezWR7KE9-raJVkAc9A.png)

从 Apk Analyser 的输出来看，应用的原大小是 3.1MB。经过 Play 商店的压缩，大致是 2.5MB。

从截图中可以看出主要有 3 个文件夹占据了应用的大多数空间。

- **classes.dex** —— 这是 dex 文件，包含了所有会运行在你的 DVM 或 ART 里的字节码文件。
- **res** —— 这个文件夹包含了所有在 res 文件夹下的文件。大部分情况下它包含所有图片，图标和源文件，菜单文件和布局。  

![](https://cdn-images-1.medium.com/max/1000/1*8ITi0D6JrpibvAC9iTG2rA.png)

- **resources.arsc** —— 这个文件包含了所有 value 资源。这个文件包含了你 value 目录下的所有数据。包括 strings、dimensions、styles、intergers、ids 等等。

![](https://cdn-images-1.medium.com/max/1000/1*B1MMigEQSVfKIJRmujeIag.png)

---

所以，现在你知道 APK 是怎么组成的了。让我们接着看看该怎么一块块的优化它以减小应用体积。

### **减小 classes.dex**

classes.dex 包含了所有 Java 代码。当你编译你的应用时，gradle 会将你的所有模块里的 .class 文件转换成 .dex 文件并将这些文件合成一个 classes.dex 文件。

> 如果你很好奇，编译的过程是怎样的，看我的另一篇博客：[The Jack and Jill: Should you use in your next Android Application?](https://blog.mindorks.com/the-jack-and-jill-should-you-use-in-your-next-android-application-ce7d0b0309b7#.gq31gtrdj)

单个的 classes.dex 文件可以容纳大约 64K 方法。如果你达到了这个限制，你必须要在你的工程中启用 [multidexing](https://developer.android.com/studio/build/multidex.html)。这将会创建另一个 classes1.dex 文件去存储剩下的方法。所以 classes.dex 文件数目由你的方法数而定。

![](https://cdn-images-1.medium.com/max/1000/1*koKowwJQ0aavZ6-Sh1I6AQ.png)

你可以看到现在的 “Anti-Theft Screen Lock” 包含 4392 个类和 29897 个方法。这个结果是没有经过混淆的。你有两个默认的混淆文件。

- **proguard-android-optimize.txt**
- **proguard-android.txt**

就像文件名写的那样，“*proguard-android-optimize.txt*”是更积极的混淆选项。我们将这个作为默认的混淆配置。你可以在 */app* 目录下的 *proguard-rules.pro* 里添加自定义的混淆配置。

```
 release {
    //Enable the proguard
    minifyEnabled true
    proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), "proguard-rules.pro"

    //Other parameters
    debuggable false
    jniDebuggable false
    renderscriptDebuggable false
    signingConfig playStoreConfig //Add your own signing config
    pseudoLocalesEnabled false
    zipAlignEnabled true
}
```

通过设置 *minifyEnabled* 为 true，混淆将会移除所有未使用的方法、指令以减小 classes.dex 文件。

这是启用了 minify 之后的 APK。

![](https://cdn-images-1.medium.com/max/1000/1*FPR6BZkWLBYhHs6YO9lLvA.png)

你可以看到在为每个模块启用了混淆之后我们的 classes.dex 大小减小了几乎 50%。同时你可以看到方法数从 29897 降到了 15168（几乎 50%）。恭喜……🎊🎉

> 体积从 3.1MB 降到了 1.98MB。**(缩小约 50%)**

---

### 减小 res：

下一大块就是 res 文件夹，它包括了所有的图片，raw 文件和 XML。你不能添加/删除/修改你的 XML，因为它们包含了你的布局。但是我们可以减小图片文件。

- “***shrinkResources***” 属性将会移除所有在工程中没有用到的资源。在 build.gradle 中像下面这样启用它：

```
release{
  //...
  //...
  shrinkResources true
  //...
}
```

- “***resConfigs***” 属性将会在构建过程中移除所有本地化资源。app “Anti-Theft Screen Lock” 只需要支持英语。而很多的支持库都可能有其它语言的本地化文件夹。这些是我不需要的。所以，添加下面的这些代码让应用只支持英语。

```
defaultConfig {
    //...
    //...
    //...

    //strip other than english resources
    resConfigs "en"
}
```

- 如果你在用 Android Studio 2.3，并且你的应用的最低支持版本大于 18，你可以使用 [**webp**](https://en.wikipedia.org/wiki/WebP) 替代 png。webp 图片比 png 体积更小但质量一样。而且 Android 支持 webp。所以你可以在 ImageView 中像加载其它光栅图片一样加载 webp 图片。这不需要改变你的布局。

你可以在工程选择 drawable 和 mipmap 文件夹，右击并选择 **convert to webp**。这将会打开下面这样的配置弹框。

![](https://cdn-images-1.medium.com/max/800/1*Y51gzPlk1Pcd_0s8lqcc9Q.png)

点击 ok，将会将所有 png 图片转成 webp。如果 webp 图片比 png 更大，Android Studio 将会自动跳过这个文件。

让我们看下最终效果：

![](https://cdn-images-1.medium.com/max/1000/1*UiwJkvIhWjrNNj2DU7Z3kA.png)

喔！！！res 文件夹从 710KB 降到了 597KB。

> 体积减小了 105KB。（降低了 16%）

> 你也可以将图片转为矢量图。但是这样你需要对它的向后兼容性进行一些处理。如果你想了解更多 vector 的相关知识，看看 [Chris Banes 的这篇博客](https://medium.com/@chrisbanes/appcompat-v23-2-age-of-the-vectors-91cbafa87c88#.ust6pssbk)。

---

### TL;DR:

- 通过在你的 release build type 中加上下面这些代码启用混淆。
- 启用 shrinkResources。
- 通过在 “resConfigs” 里添加需要的资源名移除所有不需要的本地化资源。
- 将所有图片转为 webp 或者矢量图。

---

### 总结：

通过使用上面这些简单的技巧我将应用体积从 3.19MB 降至了 1.89MB。


这些只是最简单的方式，还有很多减小应用体积的方法。但是，你应该始终使用上面这些简单的方法来保证已经尽可能的减小了应用体积。

你可以在[这儿](https://developer.android.com/topic/performance/reduce-apk-size.html)学习更多的技巧。

> 记住：越小越好。😉
