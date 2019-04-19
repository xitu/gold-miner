> * 原文地址：[Improving app performance with ART optimizing profiles in the cloud](https://android-developers.googleblog.com/2019/04/improving-app-performance-with-art.html)
> * 原文作者：[Calin Juravle](https://android-developers.googleblog.com/2019/04/improving-app-performance-with-art.html)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/improving-app-performance-with-art-optimizing-profiles-in-the-cloud.md](https://github.com/xitu/gold-miner/blob/master/TODO1/improving-app-performance-with-art-optimizing-profiles-in-the-cloud.md)
> * 译者：
> * 校对者：

# Improving app performance with ART optimizing profiles in the cloud

In Android Pie we launched _[ART optimizing profiles in Play Cloud](https://youtu.be/Yi9-BqUxsno?list=PLWz5rJ2EKKc9Gq6FEnSXClhYkWAStbwlC&t=985),_ a new optimization feature that greatly improves the application startup time after a new install or update. On average, we have observed that apps start 15% faster (cold startup) across a variety of devices. Some hero cases even show 30%+ faster startup times. One of the most important aspects is that users get this for free, without any effort from their side or from developers!

![Source: Google internal data](https://2.bp.blogspot.com/-J__2yBAq9SA/XJ6pHDtWtJI/AAAAAAAAHXw/xOQySRneEdQcfgIMXRsZVErzXN1y9yJgwCLcBGAs/s1600/image3.png)

## ART optimizing profiles in Play Cloud

The feature builds on previous [Profile Guided Optimization](https://source.android.com/devices/tech/dalvik/jit-compiler) (PGO) work, which was introduced in [Android 7.0 Nougat](https://www.youtube.com/watch?v=fwMM6g7wpQ8). PGO allows the Android Runtime to help improve an app's performance by building a profile of the app's most important hot code and focusing its optimization effort on it. This leads to big improvements while reducing the traditional memory and storage impact of a fully compiled app. However, it relies on the device to optimize apps based on these code profiles in idle maintenance mode, which means it could be a few days before a user sees the benefits - something we aimed to improve.

![Source: Google internal data](https://2.bp.blogspot.com/-6_ScCr79y7g/XJ6pSVfm7zI/AAAAAAAAHX0/PCTBWrbT4e87__cjtS07gE7eZetNvnQ-QCLcBGAs/s1600/image1.png)

_ART optimizing profiles in Play Cloud_ leverages the power of Android Play to bring all PGO benefits at install/update time: most users can get great performance without waiting!

The idea relies on two key observations:

1.  Apps usually have many commonly used code paths (hot code) between a multitude of users and devices, e.g. classes used during startup or critical user paths. This can often be discovered by aggregating a few hundred data points.
2.  App developers often roll-out their apps incrementally, starting with [alpha/beta channels]( https://support.google.com/googleplay/android-developer/answer/3131213?hl=en) before expanding to a wider audience. Even if there isn't an alpha/beta set, there is often a ramp-up of users to a new version of an app.

This means we can use the initial rollout of an app to bootstrap the performance for the rest of users. ART analyzes what part of the application code is worth optimizing on the initial devices, and then uploads the data to Play Cloud, which will build a core-aggregated code profile (containing information relevant to all devices). Once there is enough information, the code profile gets published and installed alongside the app's APKs.  

On a device, the code profile acts as a seed, enabling efficient profile-guided optimization at install time. These optimizations help improve [cold startup time](https://developer.android.com/topic/performance/vitals/launch-time#cold) and steady state performance, all without an app developer needing to write a single line of code.

![](https://4.bp.blogspot.com/-YZvK3UU7D20/XJ6pZ21iv4I/AAAAAAAAHX8/9dOUqVkAqAwpS7cLu4GBUxS1NbjhOQQ3gCLcBGAs/s1600/image4.png)

### Step 1: Building the code profile

One of the main goals is to build a quality, stable code profile out of aggregated & anonymized data as fast as possible (to maximize the number of users that can benefit), while also making sure we have enough data to accurately optimize an app's performance. Sampling too much data takes up more bandwidth and time at installation. In addition, the longer we take to build the code profile, the fewer users get the benefits. Sampling too little data, and the code profile won't have enough information on what to properly optimize in order to make a difference.

The outcome of the aggregation is what we call a core code profile, which only contains anonymous data about the code that is frequently seen across a random sample of sessions per device. We remove outliers to ensure we focus on the code that matters for most users.

Experiments show that the most commonly used code paths can be calculated very quickly, over a small amount of time. That means we are able to build a code profile fast enough that the majority of users will benefit from.

![*Data averaged from Google apps, Source: Google internal data](https://4.bp.blogspot.com/-ExYg7hPhU8E/XJ6pf1CSfRI/AAAAAAAAHYA/P-1tN7ehCoseEnK_lgHvfieX6bZmgh1XACLcBGAs/s1600/image5.png)

### Step 2: Installing the code profile

In Android 9.0 Pie, we introduced a new type of installation artifact: dex metadata files. Similar to the APKs, the dex metadata files are regular archives that contain data about how the APK should be optimized - like the core code profiles that have been built in the cloud. A key difference is that the dex metadata are managed solely by the platform and the app stores, and are not directly visible to developers.

There is also built-in support for [App Bundles / Google Play Dynamic Delivery](https://developer.android.com/platform/technology/app-bundle/): without any developer intervention, all the app's feature splits are optimized.

![](https://2.bp.blogspot.com/-mBErPA5xD0w/XJ6ppc6ye7I/AAAAAAAAHYE/kP_xVzVtdjY3Grrr7fHM3Oznde-s7a4jwCLcBGAs/s1600/image6.png)

### Step 3: Using the code profiles to optimize performance

To understand how these code profiles achieve better performance, we need to look at their structure. Code profiles contain information about:

*   Classes loaded during startup
*   Hot methods that the runtime deemed worthy of optimizations
*   The layout of the code (e.g. code that executes during startup or post-startup)

Using this information, we use a variety of optimization techniques, out of which the following three provide most of the benefits:

*   _[App Images](https://youtu.be/fwMM6g7wpQ8?t=2145):_ We use the start up classes to build a pre-populated heap where the classes are pre-initialized (called an app image). When the application starts, we map the image directly into memory so that all the startup classes are readily available.
    *   The benefit here is that the app's execution saves cycles since it doesn't need to do the work again, leading to a faster startup time.

*   _Code pre-compilation:_ We pre-compile all the hot code. When the apps execute, the most important parts of the code are already optimized and ready to be natively executed. The app no longer needs to wait for the JIT compiler to kick in.
    *   The benefit is that the code is mapped as clean memory (compared to the JIT dirty memory) which improves the overall memory efficiency. The clean memory can be released by the kernel when under memory pressure while the dirty memory cannot, lessening the chances that the kernel will kill the app.

*   _More efficient dex layout:_ We reorganize the dex bytecode based on method information the profile exposes. The dex bytecode layout will look like: \[startup code, post startup code, the rest of non profiled code\].
    *   The benefit of doing this is a much higher efficiency of loading the dex byte code in memory: The memory pages have a better occupancy, and since everything is together, we need to load less and we can do less I/O.

### Improvements & Observations

We rolled out profiles in the cloud to all apps on the playstore at the end of last year.

*   More than 30,000 apps have shown improvement
*   On average the cold startup is 15% faster across a variety of devices
    *   with many top apps getting 20%+ (e.g. Youtube) or even 30% (e.g. Google Search) on selected devices.
*   90%+ of the app installs on Android Pie get profiles
*   Little increase in install time for the extra optimization
*   Available to all Pie devices.

A very interesting observation is that, on average, ART profiles about 20% of the application methods (even less if we count the actual size of the code). For some apps, the profile covers only 2% of the code while for some the number goes up to 60%.

![Source: Google internal data](https://1.bp.blogspot.com/-179Ds6kuco4/XJ6pxOk4_oI/AAAAAAAAHYQ/WdjbULWQ9ZkaPjzBQKlkawPNU_xLnF4fgCLcBGAs/s1600/image2.png)

Why is this an important observation? It means that the runtime has not seen a lot of the application code, and is thus not investing in the code's optimization. While there are a lot of valid use-cases where the code will not be executed (e.g. error handling or backwards compatibility code), this may also be due to unused features or unnecessary code. The skew distribution is a strong signal that the latter could play an important role in further optimizations (e.g. lowering APK size by removing unneeded dex bytecode).

### Future Development

We're excited about the improvements that ART optimizing profiles has shown, and we'll be growing this concept more in the future. Building a profile of code per app opens opportunities for even more application improvements. Data can be used by developers to improve the app based on what's relevant and important for their end users. Using the information collected in Profiles, code can be re-organized or trimmed for better efficiency. Developers can potentially use App Bundles to split their features based on their use and avoid shipping unnecessary code to their users. We've already seen great improvements in app startup time, and hope to see additional benefits coming from profiles to make developer's lives easier while providing better experiences for our users.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
