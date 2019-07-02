> * 原文地址：[Google Santa Tracker — Moving to an Android App Bundle](https://medium.com/androiddevelopers/google-santa-tracker-moving-to-an-android-app-bundle-dde180716096)
> * 原文作者：[Chris Banes](https://medium.com/@chrisbanes)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/google-santa-tracker-moving-to-an-android-app-bundle.md](https://github.com/xitu/gold-miner/blob/master/TODO1/google-santa-tracker-moving-to-an-android-app-bundle.md)
> * 译者：[phxnirvana](https://github.com/phxnirvana)
> * 校对者：[portandbridge](https://github.com/portandbridge)

# 谷歌寻踪圣诞老人应用（Santa Tracker）迁移到 Android App Bundle 记录

![](https://cdn-images-1.medium.com/max/4240/1*ksxyyNT2V-A2N626DZ9D7A.png)

**本文是 2018 谷歌寻踪圣诞老人应用改进探索系列文章的第一篇。**

寻踪圣诞老人是谷歌每年都会发布的一款应用，这款应用让人们可以在全球追寻圣诞老人的足迹。不幸的是，这款应用在经过几年的迭代后，体积剧增，2017 年甚至达到了 **60MB**。我们在刚刚过去的圣诞季的目标是帮它大量减肥，本文讲述了我们实现该目标的过程。

***

如果读者体验过 [寻踪圣诞老人应用](https://play.google.com/store/apps/details?id=com.google.android.apps.santatracker) 的话，就会发现该应用有两大特色，「追踪器」让用户得以在全球范围内寻觅圣诞老人，另外一系列在十二月提供的小游戏来帮助用户享受圣诞季🎄。

「追踪器」是该应用的主要功能，也是最多被用户使用的功能。该功能事实上只在圣诞节前 26 小时（12 月 24 日）可用，在此期间，追踪器是最多被使用的功能。更准确地说，在 12 月的所有界面使用统计中，**37%** 是在 12 月 24 日 使用的，而那一天，追踪器的使用率超过了 **65%**。

那么，为什么这项功能如此重要呢？只有了解我们的主要特色是什么，才能让我们想明白，哪些是应用首次安装时最关键的功能，哪些是次要的、可以移到另外 module 中动态下发的功能，这样就使得我们的首次安装体积变小。2017 年发布的 app 包含全部功能，其中包括全部的游戏，即使用户根本不玩这些游戏。

是时候对寻踪圣诞老人动刀子了，我们设立了将首次下载体积减少到**仅仅** 10MB 的目标😥。

什么，为什么是这个数字？因为数据显示，相比 100MB 的应用，10MB 的应用提高了 30% 的转化率。当然，尽管许多应用都在追踪转化率，寻踪圣诞老人却并不是我们追踪转化率的 app。10MB 也是一个尝试起来很难达到的目标，我们想看看这究竟是不是可行的。关于更多统计背后的信息，可以阅读 [Google Play 团队](https://medium.com/googleplaydev) 的这篇文章：

- [**体积越小，安装率越高**：应用 APK 的体积是如何影响安装率的](https://medium.com/googleplaydev/shrinking-apks-growing-installs-5d3fcba23ce2)

## 动态分发

读者可能听说过 [Android App Bundle](https://developer.android.com/platform/technology/app-bundle/) 这项新技术，该技术使得 Google Play 商店可以动态下发仅仅和用户设备相关的定制应用。这项技术也帮助我们开了个好头。只需上传 AAB（Android App Bundle）来代替 APK，我们就马上让下载体积减少了将近 **20%** ，达到了 **48.5MB**（从 60MB）。们只不过是花了**一小步**的功夫，就在缩减体积方面迈进了**一大步**！

> 如果只打算从本文中学一项技术，一定得是上传 AAB 来取代 APK。这一小改动有很大机会来节省用户的时间和金钱。

Google Play 是怎么实现这种瘦身的呢？这一做法能够分发针对个别设备的优化包，这么一来，相应工具就能从安装包中移除所有不适用于设备的语言资源、分辨率资源以及本地库。比如，如果你的设备设置是 `fr-FR`（法语），分辨率是 `xxhdpi` ，CPU是 `arm64-v8a` 架构的，下发的 APK 便只会包含必要的资源，而不会包含诸如针对西班牙语本地化的字符串之类的东西。当发现本地化字符串占用的空间有多大时，你一定会大吃一惊。

不要忘了观看 [Android 开发大会 ’18](https://developer.android.com/dev-summit/) 上的 ‘[优化应用的体积](https://www.youtube.com/watch?v=QdoEcfibG-s)’ 演讲来获取更多信息：

- YouTube 视频链接：https://youtu.be/QdoEcfibG-s

## 功能模块

尽管我们有着良好的开头，却仍距离 10MB 的目标十万八千里！所以我们开始考虑哪些功能可以被拆到动态功能模块中，用户可以通过 [Play Core library](https://developer.android.com/guide/app-bundle/playcore) 来获取所需的模块。好消息是我们已经按逻辑分离了一大模块：游戏🎮。

于是便有了如下的计划：将每个游戏拆分到单独的功能模块中，并只当用户第一次打开特定游戏的时候才安装。听起来很棒，不是么？尽管逻辑上游戏都分离了，但基础代码却**并没有**分离。经过数年的功能变迁，它们已经缠缠绵绵难以分离了。应用中的库模块层层叠叠，而且到处是重复的资源。

我们的首要工作是将其解耦和，并在游戏模块之间建立足够清晰的边界。我们小心翼翼地分离了全部的游戏模块，通过使用新的 `com.android.dynamic-feature` Gradle 插件，现在每个游戏都是完全独立的模块了。对于那些有着相同依赖的游戏（比如 ‘Penguin Swim’ 和 ‘Elf Jetpack’ 共享了许多代码），依赖被添加到 ‘base’ 模块中，这样一来，就可以只安装一次（同时玩两个游戏）了。

### 功能模块的实现

正如之前说过的那样，模块迁移中占大头的工作是已有代码的重新组织，另外也有一些小的整合工作需要通过 [Play Core library](https://developer.android.com/guide/app-bundle/playcore) 来将其穿插起来。

首先是用户启动游戏时的 UX。我们首先打开显示 logo 和游戏标题的 ‘启动页（splash screen）’ activity，过一小段时间再运行游戏。运行游戏需要的全部信息都作为 intent extras 传送到启动页了。数年来该行为都没有变化，我们也并不打算修改这一行为。相反，我们从中找到了动态分发功能模块的切入点。

2018 年我们更新了启动行为，发送了四点信息：游戏标题、游戏图标、要运行的 Activity 类以及该功能模块的 ID。一旦启动页展示出来，就检查是否安装了相关模块。如果安装了，就直接运行，反之则通过 Play Core library 请求安装，并展示下载进度条：

![](https://cdn-images-1.medium.com/max/2000/1*KPoBN-zNlJPVmjrIy8A8jQ.gif)

我们在早期测试中发现需要小心处理下载安装时的场景。我们并不想因为在用户处于移动网络时安装功能模块，而无意中让他们花钱。为了应对这种情形，我们在检测到当前网络是流量网络（如移动网络）时增加了确认对话框：

![当连接到流量网络时的确认对话框](https://cdn-images-1.medium.com/max/2160/1*2qCP_mHG0gr4eKJ0Md0H1A.png)

整体逻辑如下：

```
/* Copyright 2018 Google LLC.
   SPDX-License-Identifier: Apache-2.0 */

override fun onCreate(savedInstanceState: Bundle?) {
    // ... 安装

    // 游戏功能模块的 Id 
    val featureModuleId = intent.getStringExtra(...)

    if (featureModuleName in splitInstallManager.installedModules) {
        // 功能模块已经安装，直接运行
        launchTargetActivity()
    } else {
        // 功能模块没有安装，请求安装
        val mgr = getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
        if (mgr.activeNetworkInfo?.isConnected == true) {
            // 有网络...
            if (mgr.isActiveNetworkMetered) {
                // TODO ...流量网络，请求用户确认
                showMeteredNetworkConfirmDialog()
            } else {
                // ...否则，直接下载
                startModuleInstall(featureModuleId)
            }
        } else {
            // 没有网络，显示错误框并退出
            onFeatureModuleLaunchFailure()
        }
    }
}
```

由于 Play Core API 的缘故，`startModuleInstall()` 的方法看起来有些复杂。需要在安装时添加一个用于回调的 listener，然后再请求安装，如下所示：

```
/* Copyright 2018 Google LLC.
   SPDX-License-Identifier: Apache-2.0 */

private lateinit var splitInstallManager: SplitInstallManager
private lateinit var installListener: SplitInstallStateUpdatedListener

private fun startModuleInstall(featureModuleId: String) {
    // 显示进度条
    progressbar.isVisible = true
    progressbar.isIndeterminate = true

    // 添加 listener
    splitInstallManager.registerListener(installListener)
    
    // 发送请求，开始安装
    val request = SplitInstallRequest.newBuilder()
            .addModule(featureModuleId)
            .build()
    splitInstallManager.startInstall(request)
}
```

listener 会监听到安装完成的信号，然后运行游戏。可以在 [这里](https://github.com/google/santa-tracker-android/tree/master/santa-tracker/src/main/java/com/google/android/apps/santatracker/games/SplashActivity.kt) 找到完整代码。

## 成果

如果你读到这里了，一定会想知道我们的成果如何……

Android Studio 分析 App Bundle（以及 APK）的工具相当好用，可以深入观察每个功能模块的下载体积。我们可以在其中看到我们应用的初始下载体积是  11.6MB （并没有达到 10MB 的目标），总下载体积是 25.5MB。

![**使用 Android Studio 中 Analyze Bundle 功能计算的下载体积**](https://cdn-images-1.medium.com/max/3652/1*z6BiUOLlfqpwx58ywfSsVw.png)

![展示模块体积对比的图表](https://cdn-images-1.medium.com/max/3592/1*aamb-oJ9fhE-7VPpvHh-bA.png)

但……这些值只展示了生成的 Android App Bundle 文件，并没有计算 Google Play 动态下发（上文讨论过）节省的体积。观察特定设备下载体积最准确的方式是在 [Google Play 开发者控制台](https://play.google.com/apps/publish/) 中。上传 App Bundle 后，就可以在 ‘Release Management’ -> ‘Artifact Library’ 看到特定设备的下发包体积：

![计算结果是……](https://cdn-images-1.medium.com/max/2516/1*yno3GA8adiZ14mVoxpwTVw.png)

可以看到我们达到了 10MB 的目标，下载体积只有 **9.21MB**！相比 2017 年 60MB 的应用，我们减少了 **85%** 的体积！ 🎉🎆

![高画质的实际截图](https://cdn-images-1.medium.com/max/2048/1*UT_XNkjswxZIyvLT2l-nyg.gif)

### 普惠众生

希望本文展示了迁移到 App Bundle 可以带给用户的巨大收益。尽管分离模块并不是什么举手之劳，但好的代码实践诸如高内聚低耦合也会收益良多。

关于上面的数字还有一小点要注意的是，其中也有我们使用的其他体积压缩技术的功劳，包括 asset 压缩和迁移到 R8。我们会在下篇文章中讨论这些。

* **读者可能会好奇为什么是 26 个小时而不是 24？这是因为国际日期变更线 [并不是一条直线](https://en.wikipedia.org/wiki/International_Date_Line#/media/File:International_Date_Line.png)。基里巴斯的时区是 [UTC+14](https://www.timeanddate.com/worldclock/difference.html?p1=274)，这意味着它和豪兰岛和贝克岛（UTC-12 时区）间有 26 小时的时差。**

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
