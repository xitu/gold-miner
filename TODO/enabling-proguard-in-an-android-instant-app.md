> * 原文地址：[Enabling ProGuard in an Android Instant App](https://medium.com/google-developers/enabling-proguard-in-an-android-instant-app-fbd4fc014518)
> * 原文作者：[Wojtek Kaliciński](https://medium.com/@wkalicinski?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/enabling-proguard-in-an-android-instant-app.md](https://github.com/xitu/gold-miner/blob/master/TODO/enabling-proguard-in-an-android-instant-app.md)
> * 译者：
> * 校对者：

# Enabling ProGuard in an Android Instant App

**_Update 2018–01–18:_** _important update in STEP 5 of the guide,
an additional step is required for non-base modules_

### Instant Apps and the 4 Megabyte limit

Converting an existing app project into an [Android Instant App](https://developer.android.com/topic/instant-apps/index.html) can be challenging, but it is also a great exercise in [modularizing and structuring your project](https://developer.android.com/topic/instant-apps/getting-started/structure.html), updating SDKs, and complying with all of the [Instant Apps sandbox restrictions](https://developer.android.com/topic/instant-apps/getting-started/prepare.html) that were put in place to keep Instant Apps secure and loading fast.

One of the restrictions states that for every URL handled by your instant app, the total size of the required feature module and base module delivered to the client device must not exceed 4 Megabytes.

Think about a typical _common_ module that you might have in your project (in Instant Apps terminology we will call this module the _base feature_ module): it probably depends on many parts of the support library, contains SDKs, image loading libraries, common networking code etc. That’s usually a lot of code for a start, and doesn’t leave much space for your actual feature module code and resources to fit in that 4 Megabyte limit.

There are many [general](https://developer.android.com/topic/performance/reduce-apk-size.html) and [AIA-specific](https://android-developers.googleblog.com/2017/08/android-instant-apps-best-practices-for.html) techniques for reducing APK size and you should definitely go over them all, but there’s one thing that’s absolutely essential for Instant Apps — removing unused code with ProGuard, which helps slim down all those dependencies by dropping parts of imported libraries and your own code that you never actually use.

ProGuard can be pretty challenging to [configure even for regular projects](https://medium.com/google-developers/troubleshooting-proguard-issues-on-android-bce9de4f8a74), but when enabling it for an Instant App it will almost certainly fail your build or crash your app. The new `com.android.feature` Gradle plugin (used for building AIA modules) simply didn’t exist back when ProGuard was integrated in the Android build, and ProGuard doesn’t take into account how modules are loaded together at runtime.

Fortunately, there is a step-by-step process you can follow that will make it easier to configure ProGuard for your Instant App, which I will outline in this article.

### Understanding the problem — two builds

In a typical scenario, after you modularize your app and use the new Gradle plugins, your project structure will look something like this:

![](https://cdn-images-1.medium.com/max/800/1*6smk7bsLQmg1kIipUR_V6w.png)

A typical multi-feature installable + instant app project.

In a shared instant app / installable app project, feature modules replace the old `com.android.library` modules.

**When building an installable app, ProGuard runs at the end of the build process.** Feature modules behave exactly like libraries — they contribute code and resources to the final stage of compilation, which happens in the app module, before packaging everything into an APK. In this scenario, ProGuard is able to analyze your entire code base to figure out which classes are used and which ones can be safely removed.

**In an Instant App build, each feature module produces its own APK.** Because of that, as opposed to an installable app build, **ProGuard runs for every feature module’s code independently**. For example: the base feature compilation, code shrinking and packaging happens without looking at any code contained in Features 1 and 2.

To put it simply: if your base feature contains common elements (such as AppCompat widgets) that are only used in Feature 1 and/or Feature 2 and not in the base feature itself, these elements will be removed by ProGuard, which in turn will result in a runtime crash.

Now that we understand why ProGuard fails, it’s time to fix that by making sure we add the necessary keep rules to our project’s configuration to **prevent classes that are used across different modules (defined in one module, used from another) from being removed or obfuscated.**

### The step-by-step solution

#### 1. Get your installable app build working with ProGuard enabled and fix any runtime errors.

This is the most difficult part and the only one which is not easily repeatable, as the required ProGuard configuration rules will differ for each project. I recommend becoming familiar with the [Android Studio documentation](https://developer.android.com/studio/build/shrink-code.html), the [ProGuard manual](https://www.guardsquare.com/en/proguard/manual/introduction) and my [previous article](https://medium.com/google-developers/troubleshooting-proguard-issues-on-android-bce9de4f8a74) on dealing with ProGuard errors.

We will need the rules from the installable app in our instant app ProGuard configuration later on.

#### 2. Enable ProGuard for all of your instant app features

In the installable app build, ProGuard runs only once: in the module using the `com.android.application` plugin. In an instant app build, we need to add the ProGuard configuration to all feature modules, as they all produce APKs.

Open the `build.gradle` files in each of your `com.android.feature` modules and make sure they have the following configuration:

```
android {
  buildTypes {
    release {
      minifyEnabled true
      proguardFiles getDefaultProguardFile('proguard-android.txt'), 'aia-proguard-rules.pro'
    }
  }
  ...
}
```

In the snippet above I chose to use a file named `aia-proguard-rules.pro` for my Android Instant App specific ProGuard config. For the initial contents of that file you should copy and paste the rules from your installable app (from step 1 of this guide).

If you prefer, instead of creating separate rule files for each feature, you can point all your feature modules to a single file by using relative paths such as `'../aia-proguard-rules.pro'`

#### 3. Add keep rules for classes used across modules from code

We need to figure out which classes that are included in the base module are used from your feature APKs. You could track that down manually by inspecting the source, but for a large project that’s infeasible. There’s a trick to doing this almost automatically using tools available in the Android SDK.

First, have a debug build (or just one without ProGuard enabled) of your instant app ready. Unpack the ZIP file (usually found in `<instant-module-name>/build/outputs/apks/debug`) so you have easy access to your feature and base APKs.

```
$ unzip instant-debug.zip
Archive: instant-debug.zip
  inflating: base-debug.apk
  inflating: main-debug.apk
  inflating: detail-debug.apk
```

Each of the APKs contains a `classes.dex` file (or files) that holds all the code for the module it was built from. With a little knowledge about the _DEX_ format and the [command line APK Analyzer](https://developer.android.com/studio/command-line/apkanalyzer.html) (a tools that lets us analyze DEX files in APKs), we can easily find which classes are used by, but not defined in, any given module. Let’s look at the DEX contents of the _detail_ module:

```
$ ~/Android/Sdk/tools/bin/apkanalyzer dex packages detail-debug.apk
P d 23 37 3216 com.example.android.unsplash
C d 10 20 1513 com.example.android.unsplash.DetailActivity
M d 1  1  70   com.example.android.unsplash.DetailActivity <init>()
...
P r 0 8 196 android.support.v4.view
C r 0 8 196 android.support.v4.view.ViewPager
```

The output shows us (P)ackages, (C)lasses and (M)ethods (_P/C/M_ in column 1 above) that are (d)efined or just (r)eferenced (_d/r_ in column 2 above) by this file.

The _referenced_ classes can only come from two places: the Android framework or another module that this one depends on… Bingo! With a little shell magic (I’m using bash on Linux in all following command line snippets) we can get a list of classes that need to be kept by ProGuard rules:

```
$ apkanalyzer dex packages detail-debug.apk | grep "^C r" | cut -f4
com.example.android.unsplash.ui.pager.DetailViewPagerAdapter
com.example.android.unsplash.ui.DetailSharedElementEnterCallback
com.example.android.unsplash.data.PhotoService
android.support.v4.view.ViewPager
android.transition.Slide
android.transition.TransitionSet
android.transition.Fade
android.app.Activity
...
```

Can we do anything to get rid of the classes that come from the framework (we don’t need to include rules for those, as they’re not part of the app’s APK), such as `android.app.Activity`? We could filter them by first getting a list of framework classes from the android.jar in the SDK:

```
$ jar tf ~/Android/Sdk/platforms/android-27/android.jar | sed s/.class$// | sed -e s-/-.-g
java.io.InterruptedIOException
java.io.FileNotFoundException
...
android.app.Activity
android.app.MediaRouteButton
android.app.AlertDialog$Builder
android.app.Notification$InboxStyle
```

And finally using the `[comm](https://linux.die.net/man/1/comm)` command (compare two sorted files line by line) to list classes that are only present in the first list, by piping the sorted output of the two previous commands as inputs:

```
$ comm -23 <(apkanalyzer dex packages detail-debug.apk | grep "^C r" | cut -f4 | sort) <(jar tf ~/Android/Sdk/platforms/android-27/android.jar | sed s/.class$// | sed -e s-/-.-g | sort)
android.support.v4.view.ViewPager
com.example.android.unsplash.data.PhotoService
com.example.android.unsplash.ui.DetailSharedElementEnterCallback
com.example.android.unsplash.ui.pager.DetailViewPagerAdapter
```

Phew! Who doesn’t love a little text processing in shell? All that’s left is to take each line of the output and transform it into a ProGuard keep rule in the `aia-proguard-rules.pro` file. It should look something like this:

```
-keep, includedescriptorclasses class android.support.v4.view.ViewPager {
  public protected *;
}
-keep, includedescriptorclasses class com.example.android.unsplash.data.PhotoService {
  public protected *;
}
#and so on for every class in the output…
```

#### 4. Add keep rules for classes used across modules from resources

We’re almost done, but there’s one more detail we need to take care of. Sometimes it happens that you use a class from an Android resource, such as instantiating a widget from an XML layout file, but you never actually reference that class from code.

In an installed app build, this is taken care of for you automatically by AAPT (part of the build which processes resources). It generates the required ProGuard rules for classes used in resources and in the Android Manifest, but in the case of an instant app build, they might end up in the wrong module.

To fix that, first build your instant app with ProGuard enabled (such as using the release build that you just set up in previous steps). Then go into each module’s build folder, find the `aapt_rules.txt` file (look under a path similar to this: `build/intermediates/proguard-rules/feature/release/aapt_rules.txt`) and copy and paste its contents into your `aia-proguard-rules.pro` configuration.

#### 5. NEW: Disable obfuscation in non-base modules

It occurred to me I made an important (and obvious now that I see it) omission in my guide. Because non-base modules are ProGuarded independently of each other, classes in those modules can easily get assigned the same name during obfuscation.

For example, in module _detail_ a class called `com.sample.DetailActivity` becomes `com.sample.a`, and in the module _main_ the class `com.sample.MainActivity` also becomes `com.sample.a`. This could result in a _ClassCastException_ or other weird behaviors at runtime, as only one of the resulting classes will be loaded and used.

There are two ways of doing this. The more optimal is to reuse the ProGuard mapping file from a full, installable app build, but it’s tricky to set up and maintain. The easier one is to simply disable obfuscation in non-base features. As a result, your APK will get slightly bigger because of longer class and method names, but you still retain the benefit of code removal which is the most important part.

To disable obfuscation for non-base modules, add this rule to their ProGuard configuration:

```
-dontobfuscate
```

If you have a shared configuration file between the base and non-base modules, I recommend you create a separate one. The base module can still benefit from obfuscation. You can specify additional files in your build.gradle:

```
release {
  minifyEnabled true
  signingConfig signingConfigs.debug
  proguardFiles getDefaultProguardFile("proguard-android.txt"), "../instant/proguard.pro", "non-base.pro"
}
```

#### 6. Build and test your instant app

If you got the initial ProGuard setup from step 1 right and followed steps 2–4 correctly, by now you should have a smaller, optimized instant app that doesn’t crash because of ProGuard issues. Remember to test it thoroughly by running the app and checking all possible scenarios, as some errors can only occur at runtime.

* * *

Hopefully this guide gives you a better understanding of why ProGuard can be broken for your instant app. Following the steps should take you to a working build and stop your instant app from crashing.

You can take a look at some of the [instant app samples](https://github.com/googlesamples/android-instant-apps/blob/master/multi-feature-module/proguard.pro) on GitHub which were recently updated with ProGuard configurations to compare your setup or even practice the method I described in this article on a sample project.

I acknowledge that the solution above could be improved by setting keep rules per-method and not per-class (the command for listing referenced methods would be: `apkanalyzer dex packages detail-debug.apk | grep "^M r" | cut -f4`), which could lead to bigger size savings. It would make the rest of this tutorial (such as filtering out the framework classes) more complicated however, so I’m leaving it as an exercise for the reader.


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
