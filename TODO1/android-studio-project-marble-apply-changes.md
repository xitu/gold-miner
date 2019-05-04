> * 原文地址：[Android Studio Project Marble: Apply Changes](https://medium.com/androiddevelopers/android-studio-project-marble-apply-changes-e3048662e8cd)
> * 原文作者：[Jon Tsao](https://medium.com/@jontsao)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/android-studio-project-marble-apply-changes.md](https://github.com/xitu/gold-miner/blob/master/TODO1/android-studio-project-marble-apply-changes.md)
> * 译者：
> * 校对者：

# Android Studio Project Marble: Apply Changes

### A deep dive into how the Android Studio team built Apply Changes, the successor to Instant Run.

![](https://cdn-images-1.medium.com/max/10400/1*dAZ5ygLJ9llUxAr7_TmKrg.png)

**This is the first in a series of blog posts by the Android Studio team diving into some of the details and behind the scenes of [Project Marble](https://android-developers.googleblog.com/2019/01/android-studio-33.html). Beginning with the release of [Android Studio 3.3](https://android-developers.googleblog.com/2019/01/android-studio-33.html), Project Marble is a multi-release and focused effort on making fundamental features of the IDE rock-solid and polished. The following post was written by Jon Tsao (product manager), Esteban de la Canal (tech lead), Fabien Sanglard (engineer), and Alan Leung (engineer) on the Apply Changes team.**

A key goal for Android Studio is to provide tools that allow you to quickly edit and validate code changes in your app. When we created Instant Run, we wanted to dramatically accelerate your development flow, but we know that the feature fell short of those expectations. As a part of Project Marble, we’ve been working on rethinking Instant Run, and are replacing it in Android Studio with a more practical solution called Apply Changes. Initially [previewed](https://androidstudio.googleblog.com/2019/01/android-studio-35-canary-1-available.html) in the canary channel of Android Studio 3.5, Apply Changes is the new way to predictably accelerate your development workflow. In this post, we want to give a little more insight into the feature, how it works, and our journey so far.

## Instant Run

With Instant Run, we wanted to solve two issues: 1) decrease the build and deploy speed to your device and 2) enable the ability to deploy changes to your app without losing state. To achieve this in Instant Run, we relied on rewriting your APKs at build time to inject hooks that allow class replacement on-the-fly. For a more detailed look at the architecture behind Instant Run, see [this Medium post](https://medium.com/google-developers/instant-run-how-does-it-work-294a1633367f) from a few years back.

For simple apps, this solution was usually fine, but for more complex apps, this could result in longer build times or head-scratching errors caused by conflicts between your app and Instant Run’s build process. As these issues came up, we continued to invest in improving Instant Run over subsequent releases. However, we were never able to fully resolve these issues and bring the feature in line with our expectations.

We took a step back and decided to build a new architecture from the ground up, which became Apply Changes. Unlike Instant Run, Apply Changes no longer modifies your APK during builds. Instead, we rely on runtime instrumentation that is supported in Android 8.0 (Oreo) and newer devices and emulators to redefine classes on the fly.

## Apply Changes

For devices and emulators running on Android 8.0 or newer, Android Studio now features three buttons that control how much of the application is restarted:

* **Run** will continue to deploy all changes and restart the application.

* **Apply Changes** undefinedwill attempt to apply your resource and code changes and restart only your activity without restarting your app.

* **Apply Code Changes** undefinedwill attempt to apply only your code changes without restarting anything.

Compatible code changes are generally limited to code that has changed within method bodies.

## Principles

Based on the experiences and feedback from Instant Run, we adopted a few principles for Apply Changes that guided our architecture and decision-making:

1. **Separating build/deploy speed and losing state**. We wanted to separate the two concerns of decreasing build/deploy speed from being able to see your changes without losing state. Fast builds and deploys should be a goal for **all** types of deploys, regardless of whether it’s a regular run/debug session or a hot swap of code. As part of building Apply Changes, we’ve found quite a few areas that we’ve optimized around build and deploy speed that we will detail in future posts.

2. **Stability of the feature is paramount**. Even if the feature works 99 out of 100 times at blazing fast speeds, if the app crashes once because of the feature and you spend half an hour trying to figure out why, you’ve lost the productivity gains from the other 99 times where it worked. As a result of us adhering to this principle, Apply Changes, unlike Instant Run, no longer modifies your APK during builds. One byproduct of that is that in this initial version where we’ve optimized for stability, Apply Changes is slightly slower than Instant Run on average, but we’re continuing to improve build and deploy speeds going forward.

3. **No magic**. We incorporated your feedback around the unpredictability and inconsistencies in behavior of the Instant Run button that would automatically decide whether or not to restart your app or activity if necessary. We wanted to be clear and transparent at all times as far as what you should expect out of Apply Changes and what happens if you have an incompatible change, so we now explicitly prompt you if we detect that your change is not compatible with Apply Changes.

## Architecture

Let’s dive into how Apply Changes works. Apply Changes needs to figure out how to apply the differences between the application that is installed / running on the device and the application that was just compiled in Android Studio. This process can be split into two different steps: 1) figure out what the difference is, and 2) send that difference to the device and apply it.

To determine the difference quickly, Apply Changes avoids fetching the full APK from the device. Instead, it executes a quick request to the device to pull the installed APK’s corresponding [table of contents](https://en.wikipedia.org/wiki/Zip_(file_format)#Central_directory_file_header), and [signature](https://source.android.com/security/apksigning). By comparing these two pieces of information against the newly built APK, Apply Changes efficiently generates a list of changed files since the last deployment without having to examine the full contents. Note that this algorithm does not depend on the build system, as the delta is not computed against the previous build, but against what is installed on device. Since Apply Changes operates solely on differences between APK files, it does not require the Gradle plug-in versions to be in sync with Gradle. In fact, Apply Changes will work on all build systems.

After the list of files that has changed is produced, depending on what has changed, there are different actions that need to be performed to apply these changes to the running app, and this also determines how far back the app needs to be restarted for these changes to take effect:

**Resource/asset files have changed**. 
In this case the application is reinstalled, but the application only goes through an activity restart and the modified resources are picked up. Only the changed resources are sent to the device.

**[.dex](https://source.android.com/devices/tech/dalvik/dex-format) files have changed**. 
The Android Runtime as of Android 8.0 offers the ability to swap bytecode of loaded classes, as long as the new bytecode does not alter the existing object layout in memory. This implies limitations on what code changes are compatible with Apply Changes: that method and class names and signatures do not change and neither do their fields.

This mechanism works at the class level and not at .dex level. Otherwise, if a .dex file contains hundreds or thousands of classes, it would be inefficient to attempt to swap all of the classes, even if only one has changed. Instead we compare the content of the .dex and compute the exact classes that have changed and only attempt to swap those. If the swap is successful (i.e. the class layout has not changed), then the app is also installed in the background to avoid inconsistencies between the running and installed versions of the app.

**.dex files and resources files have changed**. 
This case is a combination of the two cases above. First the code step is executed and, if it is successful, the installation proceeds with the new resources. The main Activity will need to be restarted for the new resources to be loaded. This is an all-or-nothing operation where if your code changes cannot be applied, nothing will be changed on the running app.

**Anything else has changed**. 
Worst case scenario, files like AndroidManifest.xml or native .so files have changed. In this case, it is not possible for us to apply the changes without restarting the app. Both “Apply Changes” and “Apply Code Changes” actions will not attempt to deploy and will also notify the user that the application needs to be restarted.

![**Flow of the architecture described above**](https://cdn-images-1.medium.com/max/2240/1*aD1y7EprEnSzM-3FwbUsRQ.png)

**For more details on the architecture, have a listen to the [recent episode](http://androidbackstage.blogspot.com/2019/02/episode-108-instant-re-run.html) of the Android Developers Backstage podcast, where tech lead Esteban de la Canal does a deep dive into Apply Changes.**

## Comparing .dex files

The previous section explained that Apply Changes needs to compare and extract individual classes that are changed (modified / added / deleted) in the device. In order to do so without the added overhead of fetching large chunks of content from the device, it utilizes [D8](https://android-developers.googleblog.com/2018/04/android-studio-switching-to-d8-dexer.html)’s DEX file analyzing capability in a background process to examine the content of each .dex file Android Studio deploys to a device. A checksum-based fingerprint is computed on the individual classes within the .dex files and the result is stored temporarily in a cache database on the host workstation. By comparing the fingerprints of a new compile to the fingerprints of the previous compiles, Apply Changes is able to extract changed classes efficiently within a short time frame.

## Delta push

As mentioned above, only the files that have changed will be sent to device. We call this “delta push”. Similar to the DEX files comparison mentioned above, Apply Changes needs to compute files that are different between the installed APKs and the recently built APKs without having to fetch all of the content from the device. This time around, it fetches only the [Central Directory](https://en.wikipedia.org/wiki/Zip_(file_format)#Central_directory_file_header) of the zipped file and makes a conservative estimate on what could be different between the corresponding APKs. By transmitting only the parts which have changed, Android Studio transfers much less data than a full APK upload. In most use cases, the total payload is reduced to a few KiB instead of several MiB.

## Next Steps

Apply Changes is available now in Android Studio 3.5 on the Canary release channel. We welcome you to [download the latest Android Studio](https://developer.android.com/studio/preview/install-preview), and try out Apply Changes with your project today and give us any early feedback. As a reminder, you can [run both a stable and canary release version](https://developer.android.com/studio/preview/install-preview#install_alongside_your_stable_version) of Android Studio at the same time. If you encounter any issues while using Apply Changes, please [file a bug](https://issuetracker.google.com/issues/new?component=550294&template=1207130) and attach your corresponding [idea.log file](https://intellij-support.jetbrains.com/hc/en-us/articles/207241085-Locating-IDE-log-files). We will continue to optimize the deploy performance, fix bugs, and incorporate your suggestions and feedback.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
