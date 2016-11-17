> * 原文地址：[React Native Android App Memory Investigation](https://shift.infinite.red/react-native-android-app-memory-investigation-55695625da9c#.a1m35m6jb)
* 原文作者：[Leon Kim](https://shift.infinite.red/@blackgoat)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[PhxNirvana](https://github.com/phxnirvana)
* 校对者：[XHShirley](https://github.com/XHShirley), [jamweak](https://github.com/jamweak)

# React Native Android 应用内存使用探究


### 为什么我那台老旧的 Android 手机无法加载图片？

刚开始接触 React Native 应用时，我发现有个现象很奇怪，在 Android 手机上我无法看到任何图片，只有颜色和文字可以显示。但 iOS 手机却没有任何问题。

我以为是我新找来测试 React Native 工程的 Android 手机有问题。我甚至被这错误的想法牵着刷了 rom （基于 AOSP 5.1.1 的系统）来在更高的 Android 版本上运行 React Native，当然也有着避免被 Samsung 自带应用影响的原因。然而，除了样例工程的首屏外，其他地方仍看不到图片。于是我将这手机打入冷宫。

几天后，我的朋友指出 React Native 的 Android 应用在一些特定屏幕上无法加载图片。呃……这可真够奇怪的……等等，我好像在哪儿见过这现象……

好吧，原来不止是我的手机有这现象。

### 这……一言难尽啊。

代码很明了，在显示图片方面并没有用什么黑科技或者第三方库。我开始在不同Android版本的 GenyMotion 和 Android Virtual Device （ AVD ，Android 虚拟机）上运行（React Native应用）。

*   **我的手机**：只能在第一屏看到图片
*   **GenyMotion (API 21, API 22)**：部分节点有问题
*   **AVD (API 21, API 22, API 23)**：完全没问题？！

我本以为这是在特定机型或者 API 版本上发生的事情，但显然不是这样的。也就是说我需要考虑一堆其他的可能性。这可真让人头痛。

### 我的宿敌——内存

这应用有许多作为背景显示的图片，而且这些图片也不算小（400~800 kb）。除此之外，虽然不太可能，但仍有点可疑的是，这些图片都是通过远程 URI 获取的。

我开始对内存结构产生了好奇心，尤其是从远程加载图片时动态分配的堆空间。于是我开始追踪内存使用。

### 想要一些炫酷的内存查看工具？

几年前，我用这个来查看内存：

    adb shell dumpsys meminfo

我喜欢命令行应用，但当涉及到图形化的内存使用时，这真的不是什么界面友好的东西。







![](https://cdn-images-1.medium.com/max/1600/1*Z1SdG8xVPb_35zd5EfgfFw.png)



别告诉我你喜欢看这样的内存分享界面。

如果你在一个宿醉的周六清晨用这东西，那绝对会让你从梦魇中醒来。（不不，我绝对没干过这种事！[😉](https://linmi.cc/wp-content/themes/bokeh/images/emoji/1f609.png)） 我需要能让垃圾回收变得更容易的工具。

最容易获取（并且免费！）的内存查看器就是 **Android Device Monitor**。如果你安装过 Android Studio 的话，你就已经拥有它了。按照如下步骤来打开它： 

1.  用平常的方式运行 React Native 应用 (**_react-native run-android_**)
2.  运行 **Android Studio**
3.  在菜单栏找到并打开 **Tools → Android → Enable ADB Integration**
4.  点击 **Tools → Android → Android Device Monitor**
5.  当显示 Android Device Monitor 界面时，点击 **Monitor → Preferences**
6.  在打开的对话框中找到 **Android** → **DDMS** ，选中这两项

*   Heap updates enabled by default（默认更新堆开启）
*   Thread updates enable by default (optional)（默认更新线程开启）







![](https://cdn-images-1.medium.com/max/1600/1*mut35zka6GU77s5tup4CWQ.png)



之后你就会看到一个如图所示的界面 (**System Information tab**):







![](https://cdn-images-1.medium.com/max/1600/1*sr3QA9GwDxRtB-m1Pp87Tw.png)



如果你看到这个界面的话：







![](https://cdn-images-1.medium.com/max/1600/1*JLsrnmcD_L_W_m4Uocz2Fg.png)



执行下面这条命令来确保你的开发服务连上了设备。

    adb reverse tcp:8081 tcp:8081

当你从 Android Studio 运行一个已经通过 **_react-native run-android_** 启动的应用时，可能发生这个问题。







![](https://cdn-images-1.medium.com/max/1600/1*Gu7-0W6EWPeUiqXQakPR9Q.png)



在左边的 Devices 栏选择你的应用。现在内存检查前的工作就已经准备完毕了。

### 增加堆空间

当我运行 Android Device Monitor 并来回拖动时，我发现了一些奇怪的现象。


![](https://cdn-images-1.medium.com/max/1600/1*kNdaXpsYjMpleztZhynlMg.png)



即使第一屏使用的内存已经在124MB左右时，**堆大小**也并没有明显超过124MB的迹象。但垃圾回收却开始执行：

    I/art(27035): Background partial concurrent mark sweep GC freed 1584(69KB) AllocSpace objects, 2(30KB) LOS objects, 12% free, 108MB/124MB, paused 3.874ms total 182.718ms

于是问题来了, **“为什么堆的内存如此小？”**

Android 5.0.0 中 **ART Java Heap Parameter** 推荐的 **dalvik.vm.heapsize** 值为 **384MB**:







![](https://cdn-images-1.medium.com/max/1600/1*BZIbKcLYirq99SnSslHf7g.png)



source: [https://01.org/android-ia/user-guides/android-memory-tuning-android-5.0-and-5.1](https://01.org/android-ia/user-guides/android-memory-tuning-android-5.0-and-5.1)

我甚至去拉了我手机的 build property 文件 (**_adb -d pull /system/build.prop_**) 然后证实堆内存是 **_256 MB_**.







![](https://cdn-images-1.medium.com/max/1600/1*ZVE8sitPIMpwPK_eUaqFAQ.png)



后来我知道怎么设置大内存了，只需在 **AndroidManifest.xml** 中加这行代码： 

    <application
          android:name=".MainApplication"
          android:allowBackup="true"
          android:label="@string/app_name"
          android:icon="@mipmap/ic_launcher"
          android:theme="@style/AppTheme"
          android:largeHeap="true">

这是我开启 largeHeap 后的结果：



![](https://cdn-images-1.medium.com/max/1600/1*rCj-PMfAZC8Giv5T55ZxTQ.png)



就是这样。是的，就这么一行该死的代码。**真是够恶心的！**

所有 AVD 设备（ API 21 ~ 23）在显示图片时没有这个问题的原因是模拟器更智能。当需要时它会增大堆的大小，虽然设置堆大小（的行为）会产生警告。

    emulator: WARNING: Setting VM heap size to 384MB

### 更上一层楼——如何检查内存泄漏

确切地说，我在上文解决的问题并不算是一个应用内存问题，而是设置问题。如果你的应用有隐藏更深的内存问题，使用基于 Eclipse RCP 的 **Memory Analyzer** 来检查是否有内存泄漏是一种可行的方法。

这个工具并不需要依赖 Eclipse ，所以你可以下载单独版。链接在此： [http://www.eclipse.org/mat/downloads.php](http://www.eclipse.org/mat/downloads.php)

1.  点击 **Cause GC** 来执行垃圾回收。







![](https://cdn-images-1.medium.com/max/1600/1*mot94k1pAcMQV6_s3NklUQ.png)



2\. 点击 **Dump HPROF file** 按钮来捕获内存转储文件。







![](https://cdn-images-1.medium.com/max/1600/1*bQZOyBQ-UyBFogTU_y1wiA.png)



3\. 将 Android 转储文件转换成 Memory Analyzer 可以读取的格式。 (你需要 Android SDK的 **platform-tools** )

    hprof-conv com.leak_sample.hprof com.leak_sample_converted.hprof

4\. 运行 Memory Analyzer 打开转换后的 hprof 文件。然后选择 **Leak Suspects Report** （你可以先点取消，稍后再执行）。







![](https://cdn-images-1.medium.com/max/1600/1*Ww9lPbEwUbJB_j6UHfuKOA.png)



5\. 就是这样，喵~







![](https://cdn-images-1.medium.com/max/1600/1*ggBpH13Lc3Z9xHBPnutK9A.png)



### 举个内存泄漏的例子

假设你的 React Native 应用有个 Android 原生的模块。模块中有个单例类会在调用 listener 的 onUpdate() 函数时创建一个包含 10,000,000 个元素的 String 数组。（我知道这是个无意义类，但我们先关注主要矛盾吧。简单点。）

悲剧的是，你忘记在 onDestroy() 中取消监听了，这就会在每次旋转屏幕时导致内存泄漏。你就会奇怪为什么应用莫名其妙的崩溃了。

以下是 Memory Analyzer 在执行完上述 5 步的界面：







![](https://cdn-images-1.medium.com/max/1600/1*5HWTSNwMZixtrzGJAd1b0g.png)



如图所示， **LetsLeak** 类占用了相当多的内存。注意这只是个**假设**而不是**实际情况**。

让我们聚焦于 **Dominator Tree** 。







![](https://cdn-images-1.medium.com/max/1600/1*xupGI0OuvK5FI8tKR0_fvQ.png)



你可以在 **Top Consumers** 看到排序后的内存使用列表，但是如果是这种只有一个疑点需要仔细排查的情况， Dominator Tree 是个更好的选择。







![](https://cdn-images-1.medium.com/max/1600/1*wzmNiy_kvV5I3ZJdh8tOXQ.png)



在 **Dominator Tree** 界面, Shallow Heap 是内存引用的意思， Retained Heap 则代表所有类实际持有的内存。

在 **Inspector** 界面，你可以看到你创建的超大数组。你也许会想，**“我是在单例里创建了一个 String 数组，但为什么会持有这么大的内存？应该只有一个才对……”**之后你会意识到自己并没有释放内存，这是使用单例时的常见问题。

### 结论

将 Android Device Monitor 和 Memory Analyzer 高效地结合起来可以监视线程并且可以通过转储内存查找所有 Android 系统上的内存问题。 Android 上的 React Native 也不例外。

就像上文举例的内存泄漏问题一样，一个简单对象持有你想不到的大内存这种情况是很容易找到原因的。然而在开发环境中追踪内存泄漏还是相当困难的。毋庸置疑的是，这些工具可以带来极大的便利。

### 关于 Leon

Leon Kim 是 [Infinite Red](http://infinite.red/) 公司的软件工程师，来自远东，韩国。他在读研究生时的主要方向是 [图像处理与模式识别](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3222545/) ，研发了作为政府研究计划一部分的 [prison guard robot](http://www.reuters.com/video/2012/04/12/robo-guard-on-patrol-in-south-korean-pri?videoId=233213268) ，并有着从 LTE IPsec 安全网关到七号信令系统（Signaling System 7）的 MTP3 层再到制药自动化的不同系统的研发经验。他热爱在 [Infinite Red](http://infinite.red/) 和这群酷炫的家伙在 web 和移动端开发的生活，当然，也喜欢和朋友们在每个周五晚来一次韩式烤肉。 (불금!)

有什么问题或评论么？ 我的推特是 [@leonskim](https://twitter.com/leonskim) 。或者通过 [**Infinite Red**](http://infinite.red/) 联系我们**。**

