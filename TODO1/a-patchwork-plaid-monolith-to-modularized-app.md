> * 原文地址：[Patchwork Plaid — A modularization story](https://medium.com/androiddevelopers/a-patchwork-plaid-monolith-to-modularized-app-60235d9f212e)
> * 原文作者：[Ben Weiss](https://medium.com/@keyboardsurfer?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/a-patchwork-plaid-monolith-to-modularized-app.md](https://github.com/xitu/gold-miner/blob/master/TODO1/a-patchwork-plaid-monolith-to-modularized-app.md)
> * 译者：
> * 校对者：

# Patchwork Plaid — A modularization story

![](https://cdn-images-1.medium.com/max/800/0*7f6VI2TLc-P5iokR)

格子拼贴 — 关于模块化的故事

Illustrated by [Virginia Poltrack](https://twitter.com/VPoltrack)

插图来自 [Virginia Poltrack](https://twitter.com/VPoltrack)

#### _How and why we modularized Plaid and what’s to come_

我们为什么以及如何进行模块化，模块化后会发生什么？

_This article dives deeper into the modularization portion of_ [_Restitching Plaid_](https://medium.com/@crafty/restitching-plaid-9ca5588d3b0a)_._

这篇文章深入探讨了 [_Restitching Plaid_](https://medium.com/@crafty/restitching-plaid-9ca5588d3b0a) 的模块化部分。

In this post I’ll cover how we refactored Plaid away from a monolithic universal application to a modularized app bundle. These are some of the benefits we achieved:

这篇文章中，我将全面介绍如何将一个整体的、庞大的、普通的应用转化为一个模块化应用束。以下是我们已经取得的成果：

*   more than 60% reduction in install size
*   greatly increased code hygiene
*   potential for dynamic delivery, shipping code on demand

* 整体体积减少超过60%
* 极大地增强代码健壮性
* 支持动态交付，以及按需打包代码

During all of this we did not make changes to the user experience.

我们所做的所有事情，都不会对用户体验造影响。

### A first glance at Plaid

Plaid初印象

![](https://cdn-images-1.medium.com/max/800/1*vVUYtBjOkcvcX13SsMdqnA.gif)

Navigating Plaid

导航Plaid

Plaid is an application with a delightful UI. Its home screen displays a stream of news items from several sources.  
News items can be accessed in more detail, leading to separate screens.  
The app also contains “search” functionality and an “about” screen. Based on these existing features we selected several for modularization.

Plaid是一个具有令人感到愉悦的UI的应用。它的主屏幕显示的新闻来自于多个来源。这些新闻可被点击后展示详情，从而出现分屏效果。该应用同时具有搜索功能和
一个关于模块。基于这些已经存在的特征，我们选择一些来进行模块化。

The news sources, (Designer News and Dribbble), became their own dynamic feature module. The `about` and `search` features also were modularized into dynamic features.

新闻来源（Designer News 和 Dribbble）成为了它自己拥有的动态功能模块。关于和搜索特征同样被模块化为动态功能。

[Dynamic features](https://developer.android.com/studio/projects/dynamic-delivery) allow code to be shipped without directly including it in the base apk. In consecutive steps this enables feature downloads on demand.

[动态功能](https://developer.android.com/studio/projects/dynamic-delivery)允许在不直接于基础APK中包含代码的情况下提供代码。正因为如此，通过连续步骤可实现按需下载功能。

### What’s in the box — Plaid’s construction

接下来介绍Plaid的结构

Like most Android apps, Plaid started out as a single monolithic module built as a universal apk. The install size was just under 7 MB. Much of this data however was never actually used at runtime.

如许多安卓应用一样，Plaid最初是作为普通APK构建的单一模块。它的安装体积仅在7MB一下。然而许多数据并未在运行的时候使用到。

#### Code structure

代码结构

From a code point of view Plaid had clear boundary definitions through packages. But as it happens with a lot of codebases these boundaries were sometimes crossed and dependencies snuck in. Modularization forces us to be much stricter with these boundaries, improving the separation.

从代码角度来看，Plaid基于包从而有明确的边界定义。但是随着大量代码库的出现，这些边界会被跨越并且依赖会潜入其中。模块化要求我们更加严格地限定这些边界，从而提高和改善代码分离。

#### Native libraries

本地库

The biggest chunk of unused data originates in [Bypass](https://github.com/Uncodin/bypass), a library we use to render markdown in Plaid. It includes native libraries for multiple CPU architectures which all end up in the universal apk taking up around 4MB. App bundles enable delivering only the library needed for the device architecture, reducing the required size to around 1MB.

最大的未用到的数据块来自 [Bypass](https://github.com/Uncodin/bypass)，一个我们用来在Plaid中呈现标记的库。它包括用于多核CPU体系架构的本地库，这些本地库最终在普通APK中占用大约4MB左右。APP束允许仅交付设备架构所需的库，将所需体积减少1MB左右。

#### Drawable resources

可提取资源

Many apps use rasterized assets. These are density dependent and commonly account for a huge chunk of an app’s file size. Apps can massively benefit from configuration apks, where each display density is put in a separate apk, allowing for a device tailored installation, also drastically reducing download and size.

许多应用使用栅格化资产。它们与密度有关，且通常占应用文件体积很大一部分。应用可从配置APK中受益匪浅，在配置APK中，每个显示密度都被放在一个独立APK中，允许设备定制安装，也大大减少下载和体积。

Plaid relies heavily on [vector drawables](https://developer.android.com/guide/topics/graphics/vector-drawable-resources) to display graphical assets. Since these are density agnostic and save a lot of file size already the data savings here were not too impactful for us.

Plaid显示图形资源时，很大程度上依赖于 [vector drawables](https://developer.android.com/guide/topics/graphics/vector-drawable-resources)。 因为这些与密度无关且已经保存了许多文件，所以此处数据节省对我们并不是太有影响。

### Stitching everything together

贴在一起

During the modularization task, we initially replaced `./gradlew assemble` with `./gradlew bundle`. Instead of producing an Android PacKage (apk), Gradle would now produce an [Android App Bundle](http://g.co/androidappbundle) (aab). An Android App Bundle is required for using the dynamic-feature Gradle plugin, which we’ll cover later on.

在模块化中，我们最初把 `./gradlew assemble` 替换为 `./gradlew bundle` 。Gradle现在将生成一个 [Android App Bundle](http://g.co/androidappbundle) (aab) ，替换生成APK。一个安卓应用束需要用到动态功能Gradle插件，我们稍后会介绍到。

#### Android App Bundles

安卓应用束

Instead of a single apk, AABs generate a number of smaller configuration apks. These apks can then be tailored to the user’s device, saving data during delivery and on disk. App bundles are also a prerequisite for dynamic feature modules.

相对于单个APK，安卓应用束生成许多小的配置APK。这些APK可以根据用户的设备进行定制，从而在发送过程和磁盘上保存数据。应用束也是动态功能模块的先决条件。

Configuration apks are generated by Google Play after the Android App Bundle is uploaded. With [app bundles](http://g.co/androidappbundle) being an [open spec](https://developer.android.com/guide/app-bundle#aab_format) and Open Source [tooling available](https://github.com/google/bundletool), other app stores can implement this delivery mechanism too. In order for the Google Play Store to generate and sign the apks the app also has to be enrolled to [App Signing by Google Play](https://developer.android.com/studio/publish/app-signing).

在Google Play上传应用束后，可以生成配置APK。随着 [应用束](http://g.co/androidappbundle) 成为 [开放规范](https://developer.android.com/guide/app-bundle#aab_format)，其它应用商店也可以实现这种交付机制。为了Google Play生成并签署APK，应用必须注册到 [由Google Play签名的应用程序](https://developer.android.com/studio/publish/app-signing)。

#### Benefits

优势

What did this change of packaging do for us?

这种封装的改变给我们带来了什么？

**Plaid is now is now more than 60 % smaller on device, which equals about 4 MB of data.**

**Plaid现在比设备减少60%以上，等同大约4MB数据。**

This means that each user has some more space for other apps.  
Also download time has improved due to decreased file size.

这意味着每一位用户都能够为其它应用预留更多的空间。
同时下载时间也因文件大小缩小而得到改善。

![](https://i.loli.net/2018/12/17/5c179ef2e5c9c.png)

Not a single line of code had to be touched to achieve this drastic improvement.

无需修改任何一行代码，即可实现这一大幅度改进。

### Approaching modularization

实现模块化

The overall approach we chose for modularizing is this:

我们为实现模块化所选的总体方法：

1.  Move all code and resources into a core module.
2.  Identify modularizable features.
3.  Move related code and resources into feature modules.

1. 将所有代码和资源块移动到核心模块中。
2. 识别可模块化的功能。
3. 将相关代码和资源移动到功能模块中。

![](https://cdn-images-1.medium.com/max/800/1*3OniQxsZEShiTnQLyuBwtQ.png)

green: dynamic features | dark grey: application module | light grey: libraries

The above graph shows the current state of Plaid’s modularization:

*   `:bypass` and external `shared dependencies` are included in core
*   `:app` depends on `:core`
*   dynamic feature modules depend on `:app`

#### Application module

The `:app` module basically is the already existing `[com.android.application](https://developer.android.com/studio/build/)`, which is needed to create our app bundle and keep shipping Plaid to our users. Most code used to run Plaid doesn’t have to be in this module and can be moved elsewhere.

#### Plaid’s `core module`

To get started with our refactoring, we moved all code and resources into a `[com.android.library](https://developer.android.com/studio/projects/android-library)` module. After further refactoring, our `:core` module only contains code and resources which are shared between feature modules. This allows for a much cleaner separation of dependencies.

#### External dependencies

A forked third party dependency is included in core via the `:bypass` module. Additionally, all other gradle dependencies were moved from `:app` to `:core`, using gradle’s `api` dependency keyword.

_Gradle dependency declaration: api vs implementation_

By utilizing `api` instead of `implementation` dependencies can be shared transitively throughout the app. This decreases file size of each feature module, since the dependency only has to be included in a single module, in our case `:core`. Also it makes our dependencies more maintainable, since they are declared in a single file instead of spreading them across multiple `build.gradle` files.

#### Dynamic feature modules

Above I mentioned the features we identified that can be refactored into `[com.android.dynamic-feature](https://developer.android.com/studio/projects/dynamic-delivery)` modules. These are:

```
:about
:designernews
:dribbble
:search
```

#### _Introducing com.android.dynamic-feature_

A dynamic feature module is essentially a gradle module which can be downloaded independently from the base application module. It can hold code and resources and include dependencies, just like any other gradle module. While we’re not yet making use of dynamic delivery in Plaid we hope to in the future to further shrink the initial download size.

### The great feature shuffle

After moving everything to `:core`, we flagged the “about” screen to be the feature with the least inter-dependencies, so we refactored it into a new `:about` module. This includes Activities, Views, code which is only used by this one feature. Also resources such as drawables, strings and transitions were moved to the new module.

We repeated these steps for each feature module, sometimes requiring dependencies to be broken up.

In the end, `:core` contained mostly shared code and the home feed functionality. Since the home feed is only displayed within the application module, we moved related code and resources back to `:app`.

#### A closer look at the feature structure

Compiled code can be structured in packages. Moving code into feature aligned packages is highly recommended before breaking it up into different compilation units. Luckily we didn’t have to restructure since Plaid already was well feature aligned.

![](https://cdn-images-1.medium.com/max/800/1*kE8K32z6aVssAmdboGuloA.png)

feature and core modules with their respective architectural layers

As I mentioned, much of the functionality of Plaid is provided through news sources. Each of these consists of remote and local **data** source, **domain** and **UI** layers.

Data sources are displayed in both the home feed and, in detail screens, within the feature module itself. The domain layer was unified in a single package. This had to be broken in two pieces: a part which can be shared throughout the app and another one that is only used within a feature.

Reusable parts were kept inside of the `:core` library, everything else went to their respective feature modules. The data layer and most of the domain layer is shared with at least one other module and were kept in core as well.

#### Package changes

We also made changes to package names to reflect the new module structure.  
Code only relevant only to the `:dribbble` feature was moved from `io.plaidapp` to `io.plaidapp.dribbble`. The same was applied for each feature within their respective new module names.

This means that many imports had to be changed.

Modularizing resources caused some issues as we had to use the fully qualified name to disambiguate the generated `R` class. For example, importing a feature local layout’s views results in a call to `R.id.library_image` while using a drawable from `:core` in the same file resulted in calls to

```
io.plaidapp.core.R.drawable.avatar_placeholder
```

We mitigated this using Kotlin’s import aliasing feature allowing us to import core’s `R` file like this:

```
import io.plaidapp.core.R as coreR
```

That allowed to shorten the call site to

```
coreR.drawable.avatar_placeholder
```

This makes reading the code much more concise and resilient than having to go through the full package name every time.

#### Preparing the resource move

Resources, unlike code, don’t have a package structure. This makes it trickier to align them by feature. But by following some conventions in your code, this is not impossible either.

Within Plaid, files are prefixed to reflect where they are being used. For example, resources which are only used in `:dribbble` are prefixed with `dribbble_`.

Further, files that contain resources for multiple modules, such as styles.xml are structurally grouped by module and each of the attributes prefixed as well.

To give an example: Within a monolithic app, `strings.xml` holds most strings used throughout.  
In a modularized app, each feature module holds on to its own strings.  
It’s easier to break up the file when the strings are grouped by feature before modularizing.

Adhering to a convention like this makes moving the resources to the right place faster and easier. It also helps to avoid compile errors and runtime crashes.

### Challenges along the way

To make a major refactoring task like this more manageable it’s important to have good communication within the team. Communicating planned changes and making them step by step helped us to keep merge conflicts and blocking changes to a minimum.

#### Good intentions

The dependency graph from earlier in this post shows, that dynamic feature modules know about the app module. The app module on the other hand can’t easily access code from dynamic feature modules. But they contain code which has to be executed at some point.

Without the app knowing enough about feature modules to access their code, there is no way to launch activities via their class name in the `Intent(ACTION_VIEW, ActivityName::class.java)` way.  
There are multiple other ways to launch activities though. We decided to explicitly specify the component name.

To do this we created an `AddressableActivity` interface within core.

```
/**
 * An [android.app.Activity] that can be addressed by an intent.
 */
interface AddressableActivity {
    /**
     * The activity class name.
     */
    val className: String
}
```

Using this approach, we created a function that unifies activity launch intent creation:

```
/**
 * Create an Intent with [Intent.ACTION_VIEW] to an [AddressableActivity].
 */
fun intentTo(addressableActivity: AddressableActivity): Intent {
    return Intent(Intent.ACTION_VIEW).setClassName(
            PACKAGE_NAME,
            addressableActivity.className)
}
```

In its simplest implementation an `AddressableActivity` only needs an explicit class name as a String. Throughout Plaid, each `Activity` is launched through this mechanism. Some contain intent extras which also have to be passed through to the activity from various components of the app.

You can see how we did this in the whole file here:

- [**AddressableActivity.kt**: Helpers to start activities in a modularized world._github.com](https://github.com/nickbutcher/plaid/blob/master/core/src/main/java/io/plaidapp/core/util/ActivityHelper.kt "https://github.com/nickbutcher/plaid/blob/master/core/src/main/java/io/plaidapp/core/util/ActivityHelper.kt")

#### Styling issues

Instead of a single `AndroidManifest` for the whole app, there are now separate `AndroidManifests` for each of the dynamic feature modules.  
These manifests mainly contain information relevant to their component instantiation and some information concerning their delivery type, reflected by the `dist:` tag.  
This means activities and services have to be declared inside the feature module that also holds the relevant code for this component.

We encountered an issue with modularizing our styles; we extracted styles only used by one feature out into their relevant module, but often they built upon `:core` styles using implicit inheritance.

![](https://cdn-images-1.medium.com/max/800/1*YJRNNNgg5JbRoe20l14Ffw.png)

Parts of Plaid’s style hierarchy

These styles are used to provide corresponding activities with themes through the module’s `AndroidManifest`.

Once we finished moving them, we encountered compile time issues like this:

```
* What went wrong:

Execution failed for task ‘:app:processDebugResources’.
> Android resource linking failed
~/plaid/app/build/intermediates/merged_manifests/debug/AndroidManifest.xml:177: AAPT:
error: resource style/Plaid.Translucent.About (aka io.plaidapp:style/Plaid.Translucent.About) not found.
error: failed processing manifest.
```

The manifest merger tries to merge manifests from all the feature modules into the app’s module. That fails due to the feature module’s `styles.xml` files not being available to the app module at this point.

We worked around this by creating an empty declaration for each style within `:core`’s `styles.xml` like this:

```
<! — Placeholders. Implementations in feature modules. →

<style name=”Plaid.Translucent.About” />
<style name=”Plaid.Translucent.DesignerNewsStory” />
<style name=”Plaid.Translucent.DesignerNewsLogin” />
<style name=”Plaid.Translucent.PostDesignerNewsStory” />
<style name=”Plaid.Translucent.Dribbble” />
<style name=”Plaid.Translucent.Dribbble.Shot” />
<style name=”Plaid.Translucent.Search” />
```

Now the manifest merger picks up the styles during merging, even though the actual implementation of the style is being introduced through the feature module’s styles.

Another way to avoid this is to keep style declarations in the core module. But this only works if all resources referenced are in the core module as well. That’s why we decided to go with the above approach.

#### Instrumentation test of dynamic features

Along the modularization we found that instrumentation tests currently can’t reside within the dynamic feature module but have to be included within the application module. We’ll expand on this in an upcoming blog post on our testing efforts.

### What is yet to come?

#### Dynamic code loading

We make use of dynamic delivery through app bundles, but don’t yet download these after initial installation through the [Play Core Library](https://developer.android.com/guide/app-bundle/playcore). This would for example allow us to mark news sources that are not enabled by default (Product Hunt) to only be installed once the user enables this source.

#### Adding further news sources

Throughout the modularization process, we kept in mind the possibility of adding further news sources. The work to cleanly separate modules and the possibility of delivering them on demand makes this more compelling.

#### Finish modularization

We made a lot of progress to modularize Plaid. But there’s still work to do. Product Hunt is a news source which we haven’t put into a dynamic feature module at this point. Also some of the functionality of already extracted feature modules can be evicted from core and integrated into the respective features directly.

### So, why did we decide to modularize Plaid?

Going through this process, Plaid is now a heavily modularized app. All without making changes to the user experience. We did reap several benefits in our day to day development from this effort:

#### Install size

Plaid is now on average more than 60 % smaller on a user’s device.  
This makes installation faster and saves on precious network allowance.

#### Compile time

A clean debug build without caches now takes **32 instead of 48 seconds**.*  
All the while increasing from ~50 to over 250 tasks.

This time saving is mainly due to increased parallel builds and compilation avoidance thanks to modularization.

Further, changes in single modules don’t require recompilation of every single module and make consecutive compilation a lot faster.

*For reference, these are the commits I built for [before](https://github.com/nickbutcher/plaid/commit/9ae92ab39f631a75023b38c77a5cdcaa4b2489c5) and [after](https://github.com/nickbutcher/plaid/tree/f7ab6499c0ae35ae063d7fbb155027443d458b3a) timing.

#### Maintainability

We have detangled all sorts of dependencies throughout the process, which makes the code a lot cleaner. Also, side effects have become rarer. Each of our feature modules can be worked on separately with few interactions between them. The main benefit here is that we have to resolve a lot less merge conflicts.

### In conclusion

We’ve made the app **more than 60% smaller**, improved on code structure and modularized Plaid into dynamic feature modules, which add potential for on demand delivery.

Throughout the process we always maintained the app in a state that could be shipped to our users. You can switch your app to emit an Android App Bundle today and save install size straight away. Modularization can take some time but is a worthwhile effort (see above benefits), especially with dynamic delivery in mind.

**Go check out** [**Plaid’s source code**](https://github.com/nickbutcher/plaid) **to see the full extent of our changes and happy modularizing!**

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
