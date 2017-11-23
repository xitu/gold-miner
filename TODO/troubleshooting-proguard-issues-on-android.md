> * 原文地址：[Troubleshooting ProGuard issues on Android](https://medium.com/google-developers/troubleshooting-proguard-issues-on-android-bce9de4f8a74)
> * 原文作者：[Wojtek Kaliciński](https://medium.com/@wkalicinski?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/troubleshooting-proguard-issues-on-android.md](https://github.com/xitu/gold-miner/blob/master/TODO/troubleshooting-proguard-issues-on-android.md)
> * 译者：
> * 校对者：

# Troubleshooting ProGuard issues on Android

## Why ProGuard?

ProGuard is a tool that shrinks, optimizes and obfuscates code. While there are other tools available for developers, ProGuard is readily available as part of the Android Gradle build process and ships with the SDK.

There are many reasons why you might want to enable ProGuard when building your app. Some developers care about the obfuscation part more, but for me the main benefit is the removal of all unused code that you otherwise ship with your APK as part of the classes.dex file.

![](https://cdn-images-1.medium.com/max/800/0*qPTtQ4y-0g9kMye3.)

An example size distribution chart of an Android app. Data source: [Topeka sample app](https://github.com/googlesamples/android-topeka).

There are many tangible benefits of making your code size (and app) smaller, such as increased user retention and satisfaction, faster download and install times, and reaching users on lower-end devices, especially in emerging markets. There are even some situations when you are required to limit your app size, such as the [4MB limit for Instant Apps](https://developer.android.com/topic/instant-apps/faqs.html#apk-size), for which ProGuard can prove to be indispensable.

If that’s not enough to convince you, consider that stripping out unused code and obfuscating all names has a cumulative effect and can unlock even more optimizations:

* On some versions of Android, DEX code gets compiled into machine code either at install time or during runtime. Both the original DEX and the optimized code remain on the device at all times, so the math is simple: **less code equals shorter compilation times on the device and less storage used**.
* Another thing that ProGuard can do, which makes a big impact on code size, is **change all identifiers (package, class and class members) to use short names**, such as `a.A` and `a.a.B`. This process is known as _obfuscation_. Obfuscation reduces code size in two ways: the actual strings representing these names are shorter, and moreover they now have a higher chance of being reused by different methods and fields if they share the same signature, which decreases the total number of items in the string pool.
* Using ProGuard is a prerequisite for enabling the [resource shrinker](https://developer.android.com/studio/build/shrink-code.html#shrink-resources). The **resource shrinker** **strips out resources that are not referenced from code in your project** (such as images, which are often the largest part of the APK).
* **Removing code can also save you from the** [**64K dex method reference problem**](https://developer.android.com/studio/build/multidex.html). By only packaging the methods your code actually uses into the APK, especially when you take into account third party libraries, you can greatly reduce the need for using Multidex in your app.

> **Do I think every Android app should use code shrinking? Yes!**

But before you take the leap, continue reading to learn about things that can break in your app, sometimes in very subtle ways, when you enable ProGuard. While some errors will prevent you from building your app, there are also those that you can only catch at runtime, so make sure you test your app thoroughly.

### How to ProGuard?

Enabling ProGuard in your project is as simple as adding these lines (if they’re not already there) to your main application module’s `build.gradle` file:

```
buildTypes {
/* you will normally want to enable ProGuard only for your release
builds, as it’s an additional step that makes the build slower and can make debugging more difficult */
  
  release {
    minifyEnabled true
    proguardFiles getDefaultProguardFile(‘proguard-android.txt’), ‘proguard-rules.pro’
  }
}
```

The configuration of ProGuard itself is done through a separate configuration file. You can see in the snippet above that I’ve included the default configuration that is supplied[¹](#9ca6) with the Android Gradle Plugin and then I’m going to add some options relevant to my project on top of that in `proguard-rules.pro`.

You can find a [manual describing all the possible options](https://www.guardsquare.com/en/proguard/manual/usage#keepoptions) on the ProGuard site. Before you delve deeper into the configuration, it’s good to start with a basic understanding of how ProGuard works and why we even need to specify additional options.

![](https://cdn-images-1.medium.com/max/800/0*Y0tJVDd5RnFy_qUL.)

You can also watch [part of this Google I/O session](https://youtu.be/AdfKNgyT438?t=6m50s) to see Shai Barack’s explanation.

In short, ProGuard takes your project’s class files as input, then looks at all possible application entry points and calculates the map of all code reachable from those entry points, then removes the rest (dead code, or code that can never run because it’s never called).

When reading the ProGuard manual, you should skip the Input/Output section, as the Android Gradle Plugin will specify the inputs (your classes) and the library jars (the Android framework classes against which you’re building your app) for you.

The important part of correctly configuring ProGuard is letting it know which parts of your code are accessed at runtime and shouldn’t be removed (and that also should have their names left intact when obfuscation is turned on). When classes or methods are only accessed dynamically (using reflection), ProGuard sometimes cannot determine their “liveness” when building the graph of used code and will erroneously remove these classes. This could also happen whenever you only reference your code from XML resources (which usually uses reflection under the hood).

During a typical Android build, AAPT (the tool that processes resources) generates an additional ProGuard rules file. It adds explicit [**keep rules**](https://www.guardsquare.com/en/proguard/manual/usage#keepoptions)forAndroid application entry points, so all your Activities, Services, BroadcastReceivers and ContentProviders from the Android Manifest should be left intact. That’s why, in the animation above, the `MyActivity` class doesn’t get removed or renamed.

AAPT will also **keep** all Views (and their constructors) that are used in XML layouts and some other classes such as transitions referenced from animation transition resources. You can examine the configuration file generated by AAPT after performing a build by opening `<your_project>/<app_module>/build/intermediates/proguard-rules/<variant>/aapt_rules.txt:`

![](https://cdn-images-1.medium.com/max/800/0*nVWailJWyOyv4sa5.)

An example ProGuard configuration created by AAPT during build

I will talk more about the **keep** rules in a [later section](#5a16) of this article, but before we get there it’s best to learn what to do when…

## When enabling ProGuard breaks your build

Before you can test if everything works correctly at runtime with ProGuard enabled, first you need to build your app. Unfortunately, ProGuard can fail your build by emitting warnings at compile time when it detects problems with your code, such as referencing missing classes.

The key to fixing the build is looking at the build output messages, understanding what the warnings are about and addressing them, usually by fixing your dependencies or adding [**-dontwarn**](https://www.guardsquare.com/en/proguard/manual/usage#dontwarn) rules to your ProGuard config.

One of the reasons warnings can appear is when one of your dependencies is compiled against JARs that are not on your build path, such as when using _provided_ (compile-time only) dependencies. Sometimes, the code paths using these dependencies aren’t actually invoked when running the library code on Android. Let’s look at a real world example.

![](https://cdn-images-1.medium.com/max/800/0*a4_7ZBbkOG3gncuN.)

Build output when building a project depending on OkHttp 3.8.0.

The OkHttp library added new annotations (`javax.annotation.Nullable`) to their classes in version 3.8.0\. Because they use a compile-time dependency, the annotations themselves don’t make it into the final build of an app that depends on OkHttp (unless the app adds `com.google.code.findbugs:jsr305` explicitly) and [ProGuard will complain](https://github.com/square/okhttp/issues/3355) about missing classes.

Because we know these annotation classes are not used at runtime, we can safely ignore that warning by adding the **-dontwarn** rules to the ProGuard configuration, as [suggested in the OkHttp manual](https://github.com/square/okhttp/pull/3354/files):

```
-dontwarn javax.annotation.Nullable  
-dontwarn javax.annotation.ParametersAreNonnullByDefault
```

You should go through a similar process for all warnings you see in the output, then rebuild and try again until your build passes. The important part is to understand why you’re getting the warning and if it’s safe to ignore it or if you really are missing some classes in your build.

Now you might be tempted to just ignore all warnings using the **-**[**ignorewarnings**](https://www.guardsquare.com/en/proguard/manual/usage#ignorewarnings) option, but that is rarely a good idea. In some cases, ProGuard warnings will actually let you know about errors that will prevent your app from working and about [other problems with your config](https://www.guardsquare.com/en/proguard/manual/troubleshooting#dynamicalclass).

You might also want to read the ProGuard _notes_ (messages with lower priority than Warnings), which can highlight problems with classes accessed by reflection. While they don’t break your build, these can produce nasty runtime crashes. That can happen when…

## When ProGuard removes too much

In some cases ProGuard can’t know that a class or method is being used, such as when it’s only referenced by reflection or from XML. To prevent that code from being stripped out or renamed, you have to specify additional [**keep** rules](https://www.guardsquare.com/en/proguard/manual/usage#keepoptions) in the ProGuard configuration. It is up to you, the developer, to figure out which parts of your code can be problematic and supply the necessary rules.

Getting a `ClassNotFoundException` or `MethodNotFoundException` at runtime is a sure sign you are missing classes or methods, either because ProGuard removed them or because they were missing in the first place because of misconfigured dependencies. It is very important to test the release build (with ProGuard enabled) of your app thoroughly and deal with these errors.

There are different flavors of the keep option that you can use to configure Proguard:

* **keep **— preserves all classes and methods matching the class specification
* **keepclassmembers — **specifies members to be kept, but only if their parent class is being preserved for some other reason (it’s reachable from an entry point or is kept by another rule)
* **keepclasseswithmembers **— will keep the class and its members, but only if all the members listed in the class specification are present

I suggest you become familiar with the [class specification syntax](https://www.guardsquare.com/en/proguard/manual/usage#classspecification) in ProGuard, which is used by all keep rules mentioned above and also by the **-dontwarn** option discussed in the previous section. There are also versions of the three keep rules that only prevent obfuscation (renaming), but don’t prevent shrinking. You can take look at an overview of all the keep options in a handy [table](https://www.guardsquare.com/en/proguard/manual/usage#keepoverview) on the ProGuard site.

As an alternative to writing complicated ProGuard rules, you can just add a `[**@Keep**](https://developer.android.com/reference/android/support/annotation/Keep.html)` [annotation](https://developer.android.com/reference/android/support/annotation/Keep.html) on single classes/methods/fields that you don’t want removed or renamed by ProGuard. You need the default Android ProGuard configuration file included in your build to use this technique.

## APK Analyzer and ProGuard

The [APK Analyzer](https://developer.android.com/studio/build/apk-analyzer.html) in Android Studio can help you see which classes were removed by ProGuard and generate keep rules for them. When you build an APK with ProGuard enabled, there are additional output files created in `<app_module>/build/outputs/mapping/`that contain information about removed code and mappings from the obfuscated names to the original names.

![](https://cdn-images-1.medium.com/max/800/0*ds03uyRBXdHyi7pV.)

Loading ProGuard mappings in APK Analyzer unlocks more information in the DEX viewer.

When you load these mappings into the APK Analyzer (using the _“Load Proguard mappings… “_ button), you get some additional functionality in the DEX tree view:

* All names are deobfuscated (you can see original names)
* Packages, classes, methods and fields which were **kept** by a ProGuard configuration rule are shown in **bold**
* You can enable the “Show removed nodes” option to see anything that was removed by ProGuard (shown in strikethrough). Right clicking on a node in the tree lets you generate a keep rule that you can paste in your ProGuard configuration file.

## When ProGuard removes too little

The Android ProGuard rules include some safe defaults for every Android app, such as making sure `View` getters and setters - which are normally accessed through reflection - and many other common methods and classes are not stripped out. While this will prevent your app from crashing in many situations, the config might not be 100% ideal for your app. You can remove the default ProGuard file and use your own.

If you want ProGuard to remove all unused code, you should avoid keep rules that are too broad, such as involving wildcard matching for whole packages. Instead opt for class-specific rules or using the `@Keep` annotation mentioned before.

![](https://cdn-images-1.medium.com/max/800/0*p4zsl6tqrwy6jOUr.)

Use the `-whyareyoukeeping <class-specification>` option to see why classes are not removed.

If you’re unsure as to why ProGuard did not remove part of your code when you were expecting it to be gone, you can add the [**-whyareyoukeeping**](https://www.guardsquare.com/en/proguard/manual/usage#whyareyoukeeping) option to the ProGuard configuration file and then build your APK again. In the build output, you will then be able to see the chain of usages that made ProGuard decide to keep the code.

![](https://cdn-images-1.medium.com/max/800/0*SFubaEvLatNnVmDr.)

See references to classes and methods in APK Analyzer to track down what’s keeping them in the DEX.

Another way that’s not as accurate, but doesn’t require a rebuild and works on any APK, is to open the DEX file in the APK Analyzer and right-click on the class/method you’re interested in. Select “_Find usages_” and you’ll be able to browse a chain of references that might guide you as to which part of code is using the given class/method and thus preventing it from being removed.

## ProGuard and obfuscated stack traces

I mentioned that ProGuard outputs mappings and logs when processing class files during a build. You should save these files alongside your APK whenever you store build artifacts. The mapping files cannot be used across different builds and will only work correctly with the APK they were produced with. Having the mappings available will help you debug crashes coming from users’ devices that would otherwise be difficult to inspect because of obfuscated names.

![](https://cdn-images-1.medium.com/max/800/0*wzjVsQyikWNXSjbO.)

Upload the ProGuard mapping file with your APK to Google Play Console in order to get deobfuscated stack traces.

When publishing your obfuscated release APK on the Play Console remember to also upload the mapping file for each version. That way whenever you go to the _ANRs & crashes_ page, the reported stack traces will show real class and method names and line numbers instead of the shortened and obfuscated ones.

## About ProGuard and third-party libraries

Just as it is your responsibility to provide the keep rules for your own code, it should be the responsibility of third-party library creators to provide you with the necessary config so that your build doesn’t fail or app doesn’t crash when ProGuard is enabled.

Some projects simply mention the necessary rules in their manual or README so that you can copy and paste them to your main ProGuard file. There is a better way however. For library modules and for libraries distributed as AARs, the maintainer of the library can specify rules that will be supplied with the AAR and automatically exposed to the library consumer’s build system by adding this snippet to the module’s `build.gradle` file:

```
release { //or your own build type  
  consumerProguardFiles ‘consumer-proguard.txt’  
}
```

The rules that you put in the `consumer-proguard.txt` file will be appended to the main ProGuard configuration and used during the full application build.

* * *

> **Please refer to our** [**documentation pages**](https://developer.android.com/studio/build/shrink-code.html) **for more information about code and resource shrinking.**

* * *

Enabling ProGuard can be a little daunting at first, but I personally think the benefits are worth it and, with a little time investment, you’ll get a slimmer, more optimized app. What’s more, taking the time to configure your app now means you’ll be ready when the [experimental ProGuard replacement](https://r8.googlesource.com/r8) called R8 is introduced, which will work with the existing ProGuard rules files.

Apart from making your code smaller, ProGuard and R8 can optionally apply optimizations which transform your code allowing it to run faster, but that’s a topic for another article…

* * *

[¹](#6c8e) The ProGuard-android.txt file was previously taken from the Sdk tools folder (`Sdk/tools/ProGuard/ProGuard-android.txt`), but in newer versions of SDK Tools and Android Gradle plugin 2.2.0+, it is unzipped from the Android plugin jar during build. You can find the configuration file after building your project in`<your_project>/build/intermediates/ProGuard-files/`.

Thanks to [Daniel Galpin](https://medium.com/@dagalpin?source=post_page).


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
