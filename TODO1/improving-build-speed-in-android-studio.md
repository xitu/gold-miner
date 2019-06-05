> * 原文地址：[Improving build speed in Android Studio](https://medium.com/androiddevelopers/improving-build-speed-in-android-studio-3e1425274837)
> * 原文作者：[Android Developers](https://medium.com/@AndroidDev)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/improving-build-speed-in-android-studio.md](https://github.com/xitu/gold-miner/blob/master/TODO1/improving-build-speed-in-android-studio.md)
> * 译者：
> * 校对者：

# Improving build speed in Android Studio

**Posted by Leo Sei, Product manager on Android Studio**

![](https://cdn-images-1.medium.com/max/2048/1*_aiGAO6qGx71h8VOZpo2ww.png)

## Improving Build speed

In Android studio, we want to make you the most productive developer you can be. From various discussions and surveys with developers , we know that waiting for slow build speed takes away from that productivity.

In this article, we’ll share some of the new analytics* we’ve put in place to better pinpoint what is really affecting build speed and share more about what we’re doing about it, as well as what you can do today to help prevent your build from slowing down.

*** This is possible thanks to many developers opting-in to sharing their usage statistics with us in “preference > data sharing”**

## Measuring speed differently

The first thing we did was to create internal benchmarks* using open source projects ([SignalAndroid](https://github.com/signalapp/Signal-Android/archive/v4.19.1.zip), [Tachiyomi](https://github.com/inorichi/tachiyomi/archive/014bb2f42634765ae2fec487cf3b8dc779f23f7b.zip), [SantaTracker](https://github.com/google/santa-tracker-android) & skeleton of [Uber](https://github.com/kageiit/android-studio-gradle-test.git)) to measure the build speed impact of various changes to the project (code, resources, manifest etc).

For example, here is the benchmark looking at build speed impact of code change, showing great improvement over time.

![](https://cdn-images-1.medium.com/max/2404/0*HgKjMF_Usu73_ihR)

We also looked at “real-world” data, focusing on build speed of a couple of debug build right before and right after an upgrade of the Android Gradle plugin. We used this as a proxy of the actual improvement of a new release.

This showed really good improvement with new releases**,** helping reduce build time by almost 50% since 2.3.**

![](https://cdn-images-1.medium.com/max/2992/0*l55G21vNHzBc-D7D)

Last, we looked at the evolution of build time over time, regardless of versions. We used this as a proxy of what your actual builds speed is over time. This shows, sadly, that build speed are slowing over time.

![](https://cdn-images-1.medium.com/max/2400/0*6_PsXttatVBSBJdd)

If builds are indeed getting faster with each release, and we can see it in our data, why are they still getting slower over time?

We dug a little deeper and realized that things happening in our ecosystem are causing build to slow down faster than we can improve.

While we knew that project growth — with more code, more resource usage, more language features — was making build slower over time, we also discovered that there are many additional factors beyond our immediate control:

1. **[Spectre and Meltdown](https://meltdownattack.com/) patches** late in 2017 had some impact on new processes and I/O, slowing clean builds between 50% and 140%.
2. **Third party & custom Gradle plugins**: 96% of Android Studio developers use some additional Gradle plugin (some of which may not be using the [latest best practices](https://developer.android.com/studio/build/optimize-your-build)).
3. Most used **annotation processors were non-incremental**, leading to a full re-compilation of your code every time you make an edit.
4. **Use of Java 8** language features will cause desugaring to happen, which will impact build time. However, we have mitigated the desugaring impact with D8.
5. **Use of Kotlin**, especially annotation processing in Kotlin (KAPT), can also impact build performance. We are continuing to work with JetBrains to minimize the impact here.

*** Those projects, unlike real world projects, are not growing over time. The benchmarks simulate changes and undo them afterwards to only measure impact of our plugin over time.**

**** 3.3 focused on foundational work for future improvements (eg., namespaced resources, incremental annotation processor enablement, Gradle workers) hence the 0% improvement.**

## What are we doing about it?

> Fixing internal process & continued performance improvements

We also acknowledge that many issues come from Google owned / promoted features and we have changed internal process to better catch build regression earlier in the launch process.

We’re also working to make [annotation processors incremental](https://developer.android.com/studio/build/optimize-your-build#annotation_processors). As of this post, Glide, Dagger and Auto Service are incremental and we’re working on the others.

We also included R light class generation, lazy task and worker API in recent releases and are continuing to collaborate with Gradle inc. and JetBrains to continue improving build performance overall.

> Attribution tools

A recent survey showed us that ~60% of developers do not analyze build impact or do not know how to. Therefore we want to improve tooling in Android studio to raise awareness and transparency around build time impact in the community.

We are exploring how to better provide information about the impact of plugins & tasks on your build time directly in Android Studio.

## What can you do today

While configuration time can vary based on the number of variants, modules and other things, we wanted to share, as reference point, the configuration time associated with the **Android Gradle Plugin** from “real-world” data

![](https://cdn-images-1.medium.com/max/2400/0*-ArOM3hHce2x6Xsl)

If you find your configuration time to be much slower, you likely have custom build logic (or 3rd party Gradle plugin) affecting your configuration time.

> Tools to use

Gradle provides a set of **free** [tools](https://guides.gradle.org/performance/) to help analyze what is going on in your build.

We recommend you use [Gradle scan](https://guides.gradle.org/performance/#build_scans), that provides the most information on your build. If having some of your build information uploaded to Gradle servers is an issue, you can use [Gradle profiler](https://guides.gradle.org/performance/#profile_report) which provides less information than scan but keeps everything local.

**Note: Build scans are not as helpful to investigate configuration delays. For those you may want to use traditional JVM profilers**

> Optimize your build configuration and tasks

As you investigate build speed, here are a couple of best practices to pay attention to. You can also always review our [latest best practices](https://developer.android.com/studio/build/optimize-your-build).

Configuration

* Only use configuration to set up tasks (with lazy API), avoid doing any I/O or any other work. (Configuration is not the right place to query git, read files, search for connected device(s), do computation etc)
* Set up all the tasks in configuration. Configuration is not aware of what actually gets built.

Optimize tasks

* Ensure each task declares inputs / outputs (even non-file), and is incremental as well as cacheable.
* Split complex steps into multiple tasks to help incrementality and cacheability. 
(Some tasks can be up-to-date while others execute, or run in parallel).
* Make sure tasks don’t write into or delete other task outputs
* Write your tasks in Java/Kotlin in a plugin/buildSrc rather than in groovy directly inside build.gradle.

We care about your productivity as a developer. As we continue to work on making builds faster, hopefully the tips and guidelines here will help you keep your build times down so you can focus more on developing amazing apps.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
