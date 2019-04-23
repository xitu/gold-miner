> * 原文地址：[Google Santa Tracker — Moving to an Android App Bundle](https://medium.com/androiddevelopers/google-santa-tracker-moving-to-an-android-app-bundle-dde180716096)
> * 原文作者：[Chris Banes](https://medium.com/@chrisbanes)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/google-santa-tracker-moving-to-an-android-app-bundle.md](https://github.com/xitu/gold-miner/blob/master/TODO1/google-santa-tracker-moving-to-an-android-app-bundle.md)
> * 译者：
> * 校对者：

# Google Santa Tracker — Moving to an Android App Bundle

![](https://cdn-images-1.medium.com/max/4240/1*ksxyyNT2V-A2N626DZ9D7A.png)

**This post is the first in the series which explores the improvements made to the Google Santa Tracker Android app for 2018.**

Santa Tracker is an app which Google releases every year, allowing users to track Santa as he makes his way around the globe. Unfortunately Santa Tracker has drastically grown in size over the years, resulting in a hefty **60MB** download size in 2017. Our goal for the recent holiday season was to drastically reduce that, and this post talks through how we did that.

***

If you’ve used the [Google Santa Tracker Android app](https://play.google.com/store/apps/details?id=com.google.android.apps.santatracker) you’ll know that it has two main features, the “Tracker” which allows users to track Santa as he makes his journey across the globe, and a collection of mini-games which are available to play throughout December, designed to help users to get into the holiday spirit 🎄.

The “Tracker” is the primary feature of the app and is where most of our usage comes from. The feature is actually only available for the 26 hours* before Christmas (December 24th), and during that time the tracker is the most used feature. To give you an idea of numbers, **37%** of all screen views (during December) happened on the 24th December, and over **65%** of screen views on that day were on the tracker.

So why is this important? Knowing what our primary feature was allowed us to think about what parts of the app were critical in the initial install, and which parts were secondary and could potentially be split out into separate modules which could be dynamically installed, making our initial install smaller. The 2017 app was released as a single APK which contained everything, including all of the games, even if the user did not play them.

We knew it was time for Santa Tracker to go on a diet, so we set a goal of shrinking our initial download size down to **just** 10MB 😥.

Why that size you ask? Well it is shown to have a 30% higher conversion rate than a 100MB sized app. Santa Tracker is not an app where we track conversion rate but a lot of apps do. 10MB was also a very low goal to try and achieve, to see if it was even possible. For more info on the stats behind this, read this article from the [Google Play team](https://medium.com/googleplaydev):
[**Shrinking APKs, growing installs**
**How your app’s APK size impacts install conversion rates**medium.com](https://medium.com/googleplaydev/shrinking-apks-growing-installs-5d3fcba23ce2)

## Dynamic Delivery

You may have heard about the new [Android App Bundle](https://developer.android.com/platform/technology/app-bundle/) format, which allows the Google Play store to dynamically deliver a customized app with only the parts relevant to the device. This was an easy first step for us. By simply uploading an AAB (Android App Bundle) instead of an APK, we instantly managed to reduce the download size by nearly **20%** to **48.5MB** (from 60MB). That’s a **huge** saving for the **tiny** amount of work we had to do!
> # If you only take away one thing from reading this post, make sure it is to try uploading an AAB instead of an APK for your app. The chances are high that this small change will save your users time and money.

So how does Google Play achieve that saving? By being able to deliver something optimized for a single device, the infrastructure can remove all of the language resources, density resources, and native libraries which are not applicable for the device. Example, if your device set to `fr-FR`, has a `xxhdpi` display, with an `arm64-v8a` CPU, the APK delivered will only include the necessary resources, and not for example, any strings localized to Spanish. You’d be surprised at how much space things like localized strings can take up.

Make sure to watch the ‘[Optimize Your App Size](https://www.youtube.com/watch?v=QdoEcfibG-s)’ talk from [Android Dev Summit ’18](https://developer.android.com/dev-summit/) for more info:


## Feature modules

While we made a good start, we were quite far away from our goal of 10MB! So we started thinking about which features of the app could be split out as dynamic feature modules, where they could be fetched on demand using the [Play Core library](https://developer.android.com/guide/app-bundle/playcore). Luckily our app was already logically split out into nice separate chunks: the games 🎮.

A plan formed to convert each game into a separate feature module, and install them only when the user first chose to play that particular game. Sounds great, right? Well while logically the games were all separate, the code base was… **not**. It had grown over several years into a tangled heap of interdependent modules, layers of libraries modules underneath everything, and duplicate resources everywhere.

Our first job was to fix the tight coupling and assert some clean separation between the game modules. We painstakingly untangled all of the game modules so that each was a completely separate module, using the new `com.android.dynamic-feature` Gradle plugin. For any games which had shared dependencies (e.g, the ‘Penguin Swim’ and ‘Elf Jetpack’ games share a lot of code), the dependencies were added into the ‘base’ module so that they would be only installed once.

### Implementing feature modules

As discussed above, the majority of the work in moving to feature modules is actually organizing existing code, but there is still some integration which needs to be done with the [Play Core library](https://developer.android.com/guide/app-bundle/playcore) to hook it all up.

First let’s talk about the UX when a user launches a game. We start a ‘splash screen’ activity, which displays the logo and title of the game, and then after a brief period it launches the game. All of the information about the game to launch is passed to the splash activity as intent extras. This behavior has been the same in the app for a number of years and wasn’t something that we wanted to change. It did however provide a very nice integration point for fetching dynamic feature modules.

For 2018 we updated the splash behavior so that we send four key pieces of information, the title of the game, game icon, Activity class to launch, and the ID of the feature module it is in. Once the splash activity is shown, it checks whether the relevant feature module is installed. If it is, it just launches the game as normal. If not, it requests an install via the Play Core library, displaying a progress bar indicating the ongoing download:

![](https://cdn-images-1.medium.com/max/2000/1*KPoBN-zNlJPVmjrIy8A8jQ.gif)

We found out early on in testing that you need to be careful about the conditions in which you install a feature module. We did not want to inadvertently cost the user money by installing feature modules while they were on their mobile network. To combat that we added a confirmation dialog when we detected that the device was connected to a metered network (such as a mobile network):

![Confirmation dialog shown when the device is connected to a metered network](https://cdn-images-1.medium.com/max/2160/1*2qCP_mHG0gr4eKJ0Md0H1A.png)

The overall logic for this looks like this:


The `startModuleInstall()` method is a little more complex due to how the Play Core API works. You need to attach a listener which will be invoked during an install, and then request an install, like so:


The listener will later receive an install complete signal, and finally we launch the game. You can find the complete code [here](https://github.com/google/santa-tracker-android/tree/master/santa-tracker/src/main/java/com/google/android/apps/santatracker/games/SplashActivity.kt).

## Results

If you’ve got this far into the post you probably want to see how we did…

Android Studio has a great way to analyze your App Bundles (and APKs), to drill down and see a download size value for each feature module. Using that we can see that our initial download size is 11.6MB (missing out on our 10MB goal), and our total download size is 25.5MB.

![*** Download size calculated using Analyze Bundle feature in Android Studio**](https://cdn-images-1.medium.com/max/3652/1*z6BiUOLlfqpwx58ywfSsVw.png)

![Chart showing how the module sizes compare](https://cdn-images-1.medium.com/max/3592/1*aamb-oJ9fhE-7VPpvHh-bA.png)

But…. these values are only looking at the generated Android App Bundle archive, and do not take into account any savings which Google Play can provide through Dynamic Delivery (which we discussed above). The most sure way to see the download size for a particular device is by looking on the [Google Play Developer Console](https://play.google.com/apps/publish/). After uploading an App Bundle, you can see the delivered size for a typical device under ‘Release Management’ -> ‘Artifact Library’:

![And the survey says…](https://cdn-images-1.medium.com/max/2516/1*yno3GA8adiZ14mVoxpwTVw.png)

You can see that we hit our 10MB goal and then some, with a download size of only **9.21MB**! Compared to the 2017 app, at 60MB, we’ve managed to reduce the size by **85%**! 🎉🎆

![Actual footage from Santa HQ](https://cdn-images-1.medium.com/max/2048/1*UT_XNkjswxZIyvLT2l-nyg.gif)

### Benefits for all

Hopefully this post has shown you that moving to App Bundles can have massive benefits for your users. Yes, it can be a non-trivial amount of work to split out all of your modules, but the benefits of that work also enforce good code practices like cohesive and decoupled modules.

One small caveat to the numbers above is that they also contain the results of the other size reduction techniques we used, including asset compression and moving to R8. We will discuss this more in the next blog post.

***You might be wondering why 26 hours instead of 24? This is because the International date line [is not a straight line](https://en.wikipedia.org/wiki/International_Date_Line#/media/File:International_Date_Line.png). Kiribati has a timezone of [UTC+14](https://www.timeanddate.com/worldclock/difference.html?p1=274), which means a 26 hour time difference to Howland and Baker Islands, which use UTC-12.**

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
