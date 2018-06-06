> * 原文地址：[How to optimize your app for Android (Go edition)](https://medium.com/googleplaydev/how-to-optimize-your-app-for-android-go-edition-f0d2bedf9e03)
> * 原文作者：[Raj Ajrawat](https://medium.com/@rajamatage?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-optimize-your-app-for-android-go-edition.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-optimize-your-app-for-android-go-edition.md)
> * 译者：
> * 校对者：

# How to optimize your app for Android (Go edition)

## Insights to help you create apps which work on Android phones around the world

![](https://cdn-images-1.medium.com/max/800/1*ZlH0h5W_-kszqcRfw6BLEw.png)

Android (Go edition) was announced at last year’s Google I/O, with a goal to bring high-quality smartphone experiences to entry-level devices across the globe. Earlier this year, 6 OEMs announced their devices at [Mobile World Congress](https://www.blog.google/products/android/case-you-missed-it-android-announcements-mobile-world-congress/), and many more OEMs are committed to building new Android (Go edition) devices in the future. We’re really excited about this momentum, and we encourage you to go out and buy your very own Android (Go edition) device from one of our partners!

Our OEM partners have been hard at work to get devices to market, and we are starting to see these devices become available to users. In parallel, I’ve been working with the Google Play team to collaborate with the Android developer community to ensure that developers are optimizing their app experiences for these devices where appropriate. In this post, I will share our partners’ work to optimize their apps and games for Android (Go edition).

### Understanding the opportunity

As discussed during our [Google I/O session](https://www.youtube.com/watch?v=-g7yxxTpF2o&list=PLOU2XLYxmsIInFRc3M44HUTQc3b_YJ4-Y&index=69&t=0s), Android (Go edition) is designed to improve the experiences on entry-level devices (devices with <1GB of RAM). Users around the world have struggled with battery issues, a lack of storage on device, data constraints and poor processor speeds, which created churn and dissatisfaction with their phones. While Google has done a lot of work to optimize our apps, like [Search](https://play.google.com/store/apps/details?id=com.google.android.apps.searchlite), the [Assistant](https://play.google.com/store/apps/details?id=com.google.android.apps.assistant), [Maps](https://play.google.com/store/apps/details?id=com.google.android.apps.mapslite) and [YouTube](https://play.google.com/store/apps/details?id=com.google.android.apps.youtube.mango), it is also important that app and game developers ensure their offerings work well on these devices, so that users have a premium experience at an entry-level price point.

The requirements we outlined for Android (Go edition) are meant to help you deliver a great experience for users on entry-level devices. And as you will see, many of the optimizations you apply will actually benefit all of your users across all devices, globally, with a smaller app that is more performant.

### To optimize, or to start fresh? Choose your app strategy

![](https://cdn-images-1.medium.com/max/800/0*gDxkFwplfrjaNDN8.)

The first question many of you ask yourselves is: “Should I optimize my existing app or build a new one?” While the question is deceptively simple, the answer can be a little more complex. It also depends on factors such as how much development resources you have; whether or not you can keep features in your app that are optimized for these devices; and what type of distribution scenarios you want to enable to end-users around the world.

There are three scenarios that can be identified:

*   **One app for all.** Use the same app for Android (Go edition) devices and all other devices with an identical experience. In this case, you are optimizing your existing app to run well on these devices, and your existing users gain performance benefits from those optimizations. This app may be multi-binary, but does not have a specific experience for low ram devices. We highly encourage you to use the new [Android App Bundle](https://developer.android.com/platform/technology/app-bundle/) to experience up to 65% in size savings, without having to refactor your code.
*   **One app, different APKs.** Use the same app for Android (Go edition) devices and all other devices, but different experiences. Create different APKs; one APK to target the new android.hardware.ram.low dimension vs APK(s) targeting all other devices.
*   **Two apps.** Create a new “lite” app and target Android (Go edition) devices. You can leave your existing app as is. The “lite” app can still target all devices in all locales as there is no requirement for this “lite” app to only target Android (Go edition) devices.

There are pros and cons to each of these, and it would be best to evaluate all of these scenarios against your particular business goals.

### Tips for optimizing your app

![](https://cdn-images-1.medium.com/max/800/0*ebE0B6_J372H-oeR.)

Once you’ve decided on an app strategy, there are some key considerations when it comes to optimizing your app for these devices:

1.  Making sure your app functions without ANRs and crashes
2.  Targeting Android Oreo
3.  Keeping your installed size below 40MB for apps, and 65MB for games
4.  Keeping PSS under 50MB for apps, and 150MB for games
5.  Keeping your app or game’s cold start time under 5 seconds

Let’s dive into each of these performance indicators with examples from existing Android developers.

#### Make sure your app functions without ANRs and crashes

Studies have shown that ANR (application not responding) errors and crashes can have a significant negative effect on user retention and can lead to high uninstall rates. While some of the consumers buying Android (Go edition) phones will be buying their first smartphone, they will expect a zippy, clean, and efficient experience that doesn’t freeze up their phone. [Android vitals](https://developer.android.com/topic/performance/vitals/index.html) in the Google Play Console, allows you to track ANRs and crashes, as well as dive deep on bugs that are affecting certain users or types of devices. The tool has been indispensable for many of our developers in identifying, triaging and fixing issues that come up with their apps.

![](https://cdn-images-1.medium.com/max/800/0*TjnO4X-3zCNH1Imw.)

> “For crash rate and ANR reduction, we use Android vitals and Crashlytics by Firebase for active monitoring and have managed to operate at ~99.9% crash free sessions and ANR rate of <0.1%, thus bringing down our crashes by 10 times as compared to our earlier versions,” says Arindam Mukherjee, Senior Director, User Experience & Growth at [Flipkart](https://play.google.com/store/apps/details?id=com.flipkart.android). “In order to achieve this, we have followed a phased rollout of our app — monitoring for crashes and ANRs, extensively using Nullity Annotations to figure out NullPointerException issues when running the static code analysis tool. We also do the testing on the ProGuard enabled release build, which helps us catch the obfuscation related issues early in the cycle.”

There are some common patterns to look for when diagnosing ANRs:

*   The app is doing slow operations involving I/O on the main thread.
*   The app is doing a long calculation on the main thread.
*   The main thread is doing a synchronous binder call to another process, and that other process is taking a long time to return.
*   The main thread is blocked waiting for a synchronized block for a long operation that is happening on another thread.
*   The main thread is in a deadlock with another thread, either in your process or via a binder call. The main thread is not just waiting for a long operation to finish, but is in a deadlock situation. For more information, see [Deadlock](https://developer.android.com/topic/performance/vitals/anr#deadlocks).

Be sure to learn more about [diagnosing and reproducing crashes](https://developer.android.com/topic/performance/vitals/crash.html#diagnose_the_crashes), and check out this recent video from [Flipkart](https://play.google.com/store/apps/details?id=com.flipkart.android) about optimising for Android (Go edition):

YouTube 视频链接：https://youtu.be/4lHfTteF8tE?list=PLWz5rJ2EKKc9ofd2f-_-xmUi07wIGZa1c

#### Target Android Oreo

Android Oreo (target API 26) includes a lot of [resource optimizations](https://developer.android.com/about/versions/oreo/android-8.0.html#art) such as [Background Execution Limits](https://developer.android.com/about/versions/oreo/background.html), which ensures that processes run properly in the background while keeping the phone operating smoothly. Many of these features were specifically designed to improve battery life and overall phone performance, and are key to ensuring that those using these devices will have a great experience with your app. I highly recommend you [read through the migration guide](https://developer.android.com/distribute/best-practices/develop/target-sdk.html) put together by Google Play if your app or game is still not targeting API 26 or above. In particular, pay close attention to [background execution limits](https://developer.android.com/about/versions/oreo/background.html) and [notification channels](https://developer.android.com/about/versions/oreo/android-8.0.html#notifications). Remember that [there have been security updates announced](https://android-developers.googleblog.com/2017/12/improving-app-security-and-performance.html): new apps published to the Play Console will need to target at least API 26 (Android 8.0) or higher by August 1, 2018, while updates to existing/published apps will need to do so by November 1, 2018. To comply with these requirements, you’ll need to target Oreo as soon as possible.

#### Keep installed size small

![](https://cdn-images-1.medium.com/max/800/0*BqSRQQuWQ7Q_Xna1.)

There is a [very clear correlation between APK size and install rates](https://medium.com/googleplaydev/shrinking-apks-growing-installs-5d3fcba23ce2): the lower your APK size, the higher your installs. People on Android (Go edition) devices will be very sensitive to on disk size, as these phones generally have limited storage capacity. That is one of the reasons why the Play Store will display app size over app rating in certain situations like search results and Play Store listings. While the Play Store on Android (Go edition) devices is the same Google Play Store that is available to users on all devices all around the world, we are customizing the Store experience where we feel it is important to users on these devices.

> “A key focus for our Android team has been to have empathy for users working with constricted network and device resources,” says AJ Cihla, Head of International Growth at [Tinder](https://play.google.com/store/apps/details?id=com.tinder). “Even better, with the launch of the Android App Bundle, we were able to trim down another 20% and do so in a simple, sustainable way that naturally fits into our continuous integration and deployment pipeline. All in all, we are looking at a 27MB APK for Android Go devices; a massive leap forward from the 90MB+ package we were distributing this time last year.”

Because of capacity constraints on these devices, it’s best to keep your app under 40MB and your game under 65MB. Many Google Play developers found this to be a key reason as to why they decided to either optimize their existing APK, or build a separate APK that is targeted to Android (Go edition) devices. Here are some suggestions on how to keep APK size small:

*   **Use the new Android App Bundle to immediately find size savings.** At Google I/O this year, we announced the Android App Bundle, which is a new publishing format from Google Play. With the Android App Bundle, you build one artifact that includes all of your app’s compiled code, resources, and native libraries for your app. You no longer need to build, sign, upload, and manage version codes for multiple APKs. This has saved developers up to 65% in app size for their users, with relatively little work upfront. To learn more, check out [Android App Bundle](https://developer.android.com/platform/technology/app-bundle/).
*   **Replace PNG/JPG files (if any) with WebP assets**. With lossy WebP compression, nearly identical images can be produced with significantly smaller file sizes. For vector graphics, use SVGs. For more details, check out [Connectivity for billions: Optimize images](https://developer.android.com/distribute/essentials/quality/billions/connectivity.html#images) and this [overview of WebP](https://developers.google.com/speed/webp/).
*   **Replace raw audio formats (e.g. WAV) with MP3 or AAC for all audio resources**. The loss in any sound quality should be imperceptible to most users, and will still deliver a quality playback/audio listening experience with less resources.
*   **Ensure the libraries used are up-to-date and are necessary**. Consider removing duplicated libraries and update deprecated libraries. Also, when available, please use mobile optimized libraries instead of server optimized libraries. To learn more, check out [ClassyShark](https://github.com/google/android-classyshark).
*   **Keep DEX within reason**. The dex code can take up significant space in the APK. Consider further optimizing the code to reduce the APK size. Learn more about [minifying code](https://medium.com/google-developers/smallerapk-part-2-minifying-code-554560d2ed40) and check out relevant details in our [Building for Billions guidelines](https://developer.android.com/distribute/essentials/quality/billions.html#appsize).

> [AliExpress](https://play.google.com/store/apps/details?id=com.alibaba.aliexpresshd) knew that keeping their APK means good business sense: remember, [the smaller the APK, the more installs you get](https://medium.com/googleplaydev/shrinking-apks-growing-installs-5d3fcba23ce2). “To keep our Android Go APK size small, we first split our code into multiple modules, then used product flavors to define the specific Go and regular builds,” says Donghua Xun, Senior Android Engineer at AliExpress. “This allowed us to pick and choose feature-specific modules (e.g. live video) to exclude from our Go version. We then used a Gradle script to package this Go-edition APK, along with our regular APK, all from the same code base. We also overwrote images in third-party libraries with dummy images of a much smaller size. All this work resulted in a reduction of an Android Go APK size of 8.8MB, v.s. a regular APK size of 43MB.”

If you are interested in learning more about how you can deliver on-demand features to your users (thereby keeping initial download size light), [please fill out our interest form](http://g.co/play/dynamicdeliverybeta).

#### Keep your memory footprint light

![](https://cdn-images-1.medium.com/max/800/0*A86M_KgUgfZyN-cR.)

Android (Go edition) phones are devices that have <1GB of RAM on device. The OS is optimized to run well and efficiently in low memory environments, and a key focus for developers is to ensure that their app or game is optimized to utilize memory efficiently. When testing your APK, we look at [PSS](https://en.wikipedia.org/wiki/Proportional_set_size) (Proportional Set Size) to see how much memory an app or game takes on cold start on a device. PSS is measured as the sum of the private memory of your app plus the proportion of shared memory that your app uses on the device.

Follow the instructions below to test memory allocations:

1.  With the app installed and the device connected to a workstation/laptop, launch the app and wait to arrive at the welcome screen (_we recommend waiting 5 seconds to ensure that everything is loaded in_)
2.  In terminal, run the command **adb shell dumpsys meminfo _<com.test.app>_ -d** (Where **_<com.test.app>_** is the pkg_id of the app being tested e.g. com.tinder)
3.  Record the value in the row **Total**, for the column **PssTotal** (this value is reported in KB -> convert to MB by dividing by 1000)
4.  Repeat steps 2 & 3 multiple (at least 5) times and average the **PssTotal** (KB) value

> [Mercado Libre](https://play.google.com/store/apps/details?id=com.mercadolibre), LATAM’s largest shopping app, was able to address both memory allocations and APK size requirements by focusing their efforts on their app’s architecture. “In order to reduce the size of our APK, we first implemented multi-APK by architecture and density and then striped out any extra class or resources in external libraries through ProGuard,” says Nicolas Palermo, Engineer at Mercado Libre. “From there, we focused on our code and our resources, by analyzing whether or not we needed certain libraries, and removing the ones we didn’t. All of our images were changed to WebP where possible, and any images not converted to WebP were compressed strictly to the quality that we needed. Last, we used APK Analyzer to learn more about our memory usage to ensure our PSS was within the acceptable range.”

> “I started off by targeting SDK 26 to ensure users were getting the latest Android experience. From there, I located all static functions and static variables to see if they were really necessary, and removed ones that were not. To transfer values between Activities and Fragments replace public static functions by public interfaces,” says Michel Carvajal, creator of the budgeting app [Gastos Diarios 3](https://play.google.com/store/apps/details?id=mic.app.gastosdiarios). He adds, “I also located cycles such as While and For that executed actions for reading a database and tried to place the majority of these processes within asynchronous classes with AsyncTask. And last, I searched for ambiguous SQL statements to replace for more efficient SQL statements. All of these items together, along with a few others, collectively helped me reduce my PSS by almost 60%.”

#### Keep your cold startup time under 5 seconds

Perception is key here. In user testing and studies, people become frustrated after 5 seconds of waiting for an app or game to load, which leads to abandonment and uninstall. You should treat this as your window to make sure you capture a user and don’t give them an opportunity to abandon your app after they have installed your app on their phone. We always measure cold startup time as the time it takes for your app to be fully interactive to the user. It’s best to run tests for cold startup time after doing a full reboot of your test device.

> “When looking at the size requirement, we focused our efforts on compression format of images, length of sound clips and resolution of images,” says Amitabh Lakhera, Vice President of Production of JetSynthesys, makers of [Sachin Saga Cricket Champions](https://play.google.com/store/apps/details?id=com.jetplay.sachinsagacc). “For Startup time optimisation, reducing data load, setup and background utilities, helped achieve large time savings. In addition optimising game shaders, and avoiding checks like player profile, game balancing files and force updates significantly sped up game start. Removing internet connectivity at startup and using anti cheat tools prevented any potential misbehaviour in game by players and reduced memory usage as well.”

Overall, as you think about how to get your app ready for Android (Go edition), keep in mind the various optimizations and adjustments as outlined above. With all the work developers have done to optimize their apps and games using the guidance above, I’m confident you will be able to achieve similar results! If you would like to learn more about building for Android Go and how to optimize for global markets, check out the session from Google I/O this year.

YouTube 视频链接：https://youtu.be/-g7yxxTpF2o?list=PLWz5rJ2EKKc9Gq6FEnSXClhYkWAStbwlC

* * *

### **What do you think?**

Do you have thoughts on how to develop for global markets and optimize your app strategy? Let us know in the comments below or tweet using **#AskPlayDev** and we’ll reply from [@GooglePlayDev](http://twitter.com/googleplaydev), where we regularly share news and tips on how to be successful on Google Play.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
