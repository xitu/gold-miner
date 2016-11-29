> * 原文地址：[Making the most of the APK analyzer](https://medium.com/google-developers/making-the-most-of-the-apk-analyzer-c066cb871ea2#.k0s1s1kgl)
* 原文作者：[Wojtek Kaliciński](https://medium.com/@wkalicinski)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

# Making the most of the APK analyzer
# 利用好 Android Studio 中的 APK Analyzer






One of my favorite recent additions to Android Studio is the APK Analyzer, which you can find in the top menu under **Build** → **Analyze APK**.

最近的 Android Studio 插件中我最喜欢的是 APK Analyzer。你可以从顶端菜单栏中的 **Build** 找到 **Analyze APK**。



![](https://d262ilb51hltx0.cloudfront.net/max/800/0*RiXOWhjkTw8ELX7M.)

Pro-tip: you can also drag and drop APK files into the editor to open them

专业提示：你也可以拖拽 APK 文件到编辑栏中打开。



APK Analyzer lets you open and inspect the contents of any APK file you have on your computer, either built from your local Android Studio project or acquired from your build server or other artifact repository. It doesn’t have to be built from any project you have open in Android Studio and you don’t need the source code for that particular APK.

APK Analyzer 让你可以打开并审查存于你电脑中的 APK 文件的内容，不管它是通过本地 Android Studio 工程构建，还是需要从服务器上或者其他构件仓库中构建后得到的。它不需要在任何你所打开的 Android Studio项目中被构建，甚至也不需要它的源代码。

> **Note:** APK Analyzer works best with release builds. If you need to analyze a debug build of your app, make sure you are using an APK that is not instrumented for Instant Run. To obtain it, you can use the **Build** → **Build APK**command. You can see if you’ve opened an Instant Run instrumented APK by checking the presence of an instant-run.zip file inside the archive.

> **注意：**APK Analyzer 最好用于发布版本的构建。如果你需要分析你 app 的调试版本，确认你的 APK 不是用 Instant Run 构建出来的。如果想要了解，你可以在顶部菜单栏点击 **Build** → **Build APK**，通过查看 instant-run.zip 文件是否存在，了解你是否打开了 Instant Run。

Using the APK analyzer is a great way to poke around APK files and learn about their [structure](https://developer.android.com/topic/performance/reduce-apk-size.html#apk-structure), verify the file contents before releasing or debug some common problems, including APK size and DEX issues.

使用 APK analyzer 是一个非常好的途径来查找 APK 文件并了解他们的[结构](https://developer.android.com/topic/performance/reduce-apk-size.html#apk-structure)，在发布前或调试时验证一些常见问题，例如 APK 大小和 DEX 问题。

### Reducing app size with the APK Analyzer
###使用 APK Analyzer 减小应用的大小

The APK analyzer can give you a lot of useful, actionable info about app size. At the top of the screen, you can see the **Raw File Size** which is just the APK on-disk size. The **Download size** shows an estimate of how much data will used to download your app by taking into account compression applied by the Play Store.

APK analyzer 在应用大小方面可以给你很多有用并且可操作的信息。在屏幕的顶部，应用占磁盘大小可以从 **Raw File Size** 看到。**Download size** 是一个估计值，表示考虑到 Play Store 的压缩，多少数据会被用来下载你的应用。

The list of files and folders is sorted by total size in descending order. This makes it great for identifying the low hanging fruit of APK size optimization. Each time you drill down into a folder, you can see the resources and other entities that take up the most space in your APK.

文件和文件夹根据文件大小降序排列。这让我们很容易看出对 APK 大小优化最容易从哪里入手。每当你深入到某个文件夹的时候，你能看到资源和其他实体占用了 APK 大部分的空间。



![](https://d262ilb51hltx0.cloudfront.net/max/800/0*DRt5aMTeoIKdwYG1.)

Resources sorted in descending order according to size



In this example, when examining an APK for possible size reductions, I was able to immediately notice that a 3-frame PNG animation is the single biggest thing in our drawable resources, weighing in at 1.5MB, and that’s just for the _xxhdpi_ density!

Since these images look like perfect candidates for storing as vectors, we found the source files for the artwork and imported them as VectorDrawables using the new [PSD support in the Vector Asset import tool](https://developer.android.com/studio/write/vector-asset-studio.html)in Android Studio 2.2.

By going through the same process for the other remaining animation (_instruction_touch_*.png)_ and removing these PNG files across all densities, we were able to save over 5MB. To maintain backward compatibility we used [_VectorDrawableCompat_](https://medium.com/@chrisbanes/appcompat-v23-2-age-of-the-vectors-91cbafa87c88) from the support library.

Looking at other resource folders, it was easy to spot some uncompressed _WAV_ files that could be converted to _OGG_, which meant even more savings without touching a line of code.



![](https://d262ilb51hltx0.cloudfront.net/max/600/0*AcjFk-xj6PKOXRWe.)

Browsing other folders in the APK



Next on the list of things to check was the _lib/_ folder, which contains native libraries for the three ABIs that we support.

The decision was made to use [APK splits support](https://developer.android.com/studio/build/configure-apk-splits.html) in our Gradle build to create separate versions of the app for each ABI.

I quickly looked over the AndroidManifest.xml next and noticed that __is missing the [_android:extractNativeLibs_](https://developer.android.com/reference/android/R.attr.html#extractNativeLibs) attribute. Setting this attribute to _false_ can save some space on the device as it prevents copying out the native libraries from the APK to the filesystem. The only requirement is that the files are page aligned and stored uncompressed inside the APK, which is supported with the [new packager](http://android-developers.blogspot.com/2016/11/understanding-apk-packaging-in-android-studio-2-2.html) in the Android Gradle plugin version 2.2.0+.



![](https://d262ilb51hltx0.cloudfront.net/max/800/0*VgknN7SJh9z7hOya.)

The full AndroidManifest.xml as viewed in APK Analyzer



After I made these modifications, I was curious to see how the new version of the app compares to the previous one. To do that, I checked out the source from the git commit with which I started, compiled the APK and saved it in another folder. I then used the **Compare with…** feature to see a breakdown of size differences between the old and new builds.



![](https://d262ilb51hltx0.cloudfront.net/max/800/0*W_ZzJpAzon5xAHpc.)

APK comparison — access it through the button on the top-right



We made a lot of progress on the resources and native libraries, saving a total of 17MB with very little changes in the app. However, I can see that our DEX size regressed, with the classes2.dex growing by 400KB.

### Debugging DEX issues

In this case, the difference came from upgrading our dependencies to newer versions and adding new libraries. [Proguard](https://developer.android.com/studio/build/shrink-code.html#shrink-code) and [Multidex](https://developer.android.com/studio/build/multidex.html) were already enabled for our builds so there’s not much that can be done about our DEX size. Still, APK analyzer is a great tool to debug any issues with this setup, especially when you’re enabling Multidex or Proguard for your project for the first time.



![](https://d262ilb51hltx0.cloudfront.net/max/800/0*bOKK2M9iFTXVfUrs.)

Exploring the contents of classes.dex



When you click on any DEX file, you will see a summary of how many classes and methods it defines, and how many total references it contains (it’s references that count against the [64K limit](https://developer.android.com/studio/build/multidex.html#about) in a single DEX file). In this example screenshot, the app is just about to reach the limit, which means it will need MultiDex to split the classes into separate files in the near future.

You can drill down into the packages to see which ones are using up all of the references. In this case, we can see that the Support library and Google Play Services are the main causes for this situation:



![](https://d262ilb51hltx0.cloudfront.net/max/800/0*_X6y5PXnNG_e_QK-.)

Reference counts per package



Once you’ve enabled MultiDex and compiled your app, you will notice a second classes2.dex file (and possibly classes3.dex, and so on). The MultiDex solution in the Android gradle plugin figures out which classes are needed to start your app and puts them into the primary classes.dex file, but in the rare case when it doesn’t work and you get a ClassNotFoundException, you can use APK Analyzer to inspect the DEX files, and then [force the missing classes to be put in the primary DEX file](http://google.github.io/android-gradle-dsl/2.2/com.android.build.gradle.internal.dsl.ProductFlavor.html#com.android.build.gradle.internal.dsl.ProductFlavor:multiDexKeepFile).

You will encounter similar issues when enabling Proguard and using classes or methods by reflection or from XML layouts. The APK Analyzer can help you with verifying that your Proguard configuration is correct, by letting you easily check if the methods and classes you require are present in the APK and if they are being renamed (obfuscated). You can also make sure that classes you want gone are actually removed, and not taking up your precious reference method count.

We’re curious to hear what other uses you find for the APK Analyzer and what other features you’d like to see integrated in the tool!





