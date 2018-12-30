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

这篇文章深入探讨了 [ Restitching Plaid ](https://medium.com/@crafty/restitching-plaid-9ca5588d3b0a) 的模块化部分。

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

Plaid 初印象

![](https://cdn-images-1.medium.com/max/800/1*vVUYtBjOkcvcX13SsMdqnA.gif)

Navigating Plaid

导航 Plaid

Plaid is an application with a delightful UI. Its home screen displays a stream of news items from several sources.  
News items can be accessed in more detail, leading to separate screens.  
The app also contains “search” functionality and an “about” screen. Based on these existing features we selected several for modularization.

Plaid 是一个具有令人感到愉悦的 UI 的应用。它的主屏幕显示的新闻来自于多个来源。这些新闻可被点击后展示详情，从而出现分屏效果。该应用同时具有搜索功能和
一个关于模块。基于这些已经存在的特征，我们选择一些来进行模块化。

The news sources, (Designer News and Dribbble), became their own dynamic feature module. The `about` and `search` features also were modularized into dynamic features.

新闻来源（Designer News 和 Dribbble）成为了它自己拥有的动态功能模块。关于和搜索特征同样被模块化为动态功能。

[Dynamic features](https://developer.android.com/studio/projects/dynamic-delivery) allow code to be shipped without directly including it in the base apk. In consecutive steps this enables feature downloads on demand.

[动态功能](https://developer.android.com/studio/projects/dynamic-delivery)允许在不直接于基础 APK 中包含代码的情况下提供代码。正因为如此，通过连续步骤可实现按需下载功能。

### What’s in the box — Plaid’s construction

接下来介绍 Plaid 结构

Like most Android apps, Plaid started out as a single monolithic module built as a universal apk. The install size was just under 7 MB. Much of this data however was never actually used at runtime.

如许多安卓应用一样，Plaid 最初是作为普通 APK 构建的单一模块。它的安装体积仅在7MB一下。然而许多数据并未在运行的时候使用到。

#### Code structure

代码结构

From a code point of view Plaid had clear boundary definitions through packages. But as it happens with a lot of codebases these boundaries were sometimes crossed and dependencies snuck in. Modularization forces us to be much stricter with these boundaries, improving the separation.

从代码角度来看，Plaid 基于包从而有明确的边界定义。但是随着大量代码库的出现，这些边界会被跨越并且依赖会潜入其中。模块化要求我们更加严格地限定这些边界，从而提高和改善代码分离。

#### Native libraries

本地库

The biggest chunk of unused data originates in [Bypass](https://github.com/Uncodin/bypass), a library we use to render markdown in Plaid. It includes native libraries for multiple CPU architectures which all end up in the universal apk taking up around 4MB. App bundles enable delivering only the library needed for the device architecture, reducing the required size to around 1MB.

最大的未用到的数据块来自 [Bypass](https://github.com/Uncodin/bypass)，一个我们用来在 Plaid 中呈现标记的库。它包括用于多核 CPU 体系架构的本地库，这些本地库最终在普通 APK 占大约4MB左右。APP 束允许仅交付设备架构所需的库，将所需体积减少1MB左右。

#### Drawable resources

可提取资源

Many apps use rasterized assets. These are density dependent and commonly account for a huge chunk of an app’s file size. Apps can massively benefit from configuration apks, where each display density is put in a separate apk, allowing for a device tailored installation, also drastically reducing download and size.

许多应用使用栅格化资产。它们与密度有关，且通常占应用文件体积很大一部分。应用可从配置 APK 中受益匪浅，在配置 APK 中，每个显示密度都被放在一个独立 APK 中，允许设备定制安装，也大大减少下载和体积。

Plaid relies heavily on [vector drawables](https://developer.android.com/guide/topics/graphics/vector-drawable-resources) to display graphical assets. Since these are density agnostic and save a lot of file size already the data savings here were not too impactful for us.

Plaid 显示图形资源时，很大程度上依赖于 [vector drawables](https://developer.android.com/guide/topics/graphics/vector-drawable-resources)。 因为这些与密度无关且已经保存了许多文件，所以此处数据节省对我们并不是太有影响。

### Stitching everything together

贴在一起

During the modularization task, we initially replaced `./gradlew assemble` with `./gradlew bundle`. Instead of producing an Android PacKage (apk), Gradle would now produce an [Android App Bundle](http://g.co/androidappbundle) (aab). An Android App Bundle is required for using the dynamic-feature Gradle plugin, which we’ll cover later on.

在模块化中，我们最初把 `./gradlew assemble` 替换为 `./gradlew bundle` 。Gradle 现在将生成一个 [Android App Bundle](http://g.co/androidappbundle) (aab) ，替换生成 APK。一个安卓应用束需要用到动态功能 Gradle 插件，我们稍后会介绍到。

#### Android App Bundles

安卓应用束

Instead of a single apk, AABs generate a number of smaller configuration apks. These apks can then be tailored to the user’s device, saving data during delivery and on disk. App bundles are also a prerequisite for dynamic feature modules.

相对于单个 APK，安卓应用束生成许多小的配置 APK。这些 APK 可根据用户设备进行定制，从而在发送过程和磁盘上保存数据。应用束也是动态功能模块的先决条件。

Configuration apks are generated by Google Play after the Android App Bundle is uploaded. With [app bundles](http://g.co/androidappbundle) being an [open spec](https://developer.android.com/guide/app-bundle#aab_format) and Open Source [tooling available](https://github.com/google/bundletool), other app stores can implement this delivery mechanism too. In order for the Google Play Store to generate and sign the apks the app also has to be enrolled to [App Signing by Google Play](https://developer.android.com/studio/publish/app-signing).

在 Google Play 上传应用束后，可以生成配置 APK。随着 [应用束](http://g.co/androidappbundle) 成为 [开放规范](https://developer.android.com/guide/app-bundle#aab_format)，其它应用商店也可以实现这种交付机制。为了 Google Play 生成并签署 APK，应用必须注册到 [由Google Play签名的应用程序](https://developer.android.com/studio/publish/app-signing)。

#### Benefits

优势

What did this change of packaging do for us?

这种封装的改变给我们带来了什么？

**Plaid is now is now more than 60 % smaller on device, which equals about 4 MB of data.**

**Plaid 现在比设备减少60%以上，等同大约4MB数据。**

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

绿色：动态功能 | 深灰色：应用模块 | 浅灰色：库

The above graph shows the current state of Plaid’s modularization:

*   `:bypass` and external `shared dependencies` are included in core
*   `:app` depends on `:core`
*   dynamic feature modules depend on `:app`

上面图表向我们展示了 Plaid 模块化的现状：

* `旁路模块`和外部`分享依赖`包含在核心模块当中
* `APP` 依赖于`核心模块`
* 动态功能模块依赖于 `APP`

#### Application module

应用模块

The `:app` module basically is the already existing `[com.android.application](https://developer.android.com/studio/build/)`, which is needed to create our app bundle and keep shipping Plaid to our users. Most code used to run Plaid doesn’t have to be in this module and can be moved elsewhere.

`APP` 模块基本上是现存的[应用](https://developer.android.com/studio/build/)，被用来创建 APP 束并且向我们展示 Plaid。许多用来运行 Plaid 的代码没必要必须包含在该模块当中，而是可以移至其它的任何地方。

#### Plaid’s `core module`

Plaid 的`核心模块`。

To get started with our refactoring, we moved all code and resources into a `[com.android.library](https://developer.android.com/studio/projects/android-library)` module. After further refactoring, our `:core` module only contains code and resources which are shared between feature modules. This allows for a much cleaner separation of dependencies.

为了开始重构，我们将所有的代码和资源都移动至一个 [com.android.library](https://developer.android.com/studio/projects/android-library) 模块。进一步重构后，我们的`核心模块`仅包含各个功能模块间共享所需要的代码和资源。这将使得更加清晰地分离依赖项。

#### External dependencies

外部库

A forked third party dependency is included in core via the `:bypass` module. Additionally, all other gradle dependencies were moved from `:app` to `:core`, using gradle’s `api` dependency keyword.

通过`旁路模块`将一个第三方依赖库包含在核心模块中。此外，通过 gradle `api` 依赖关键字，将所有其它 gradle 依赖从 `APP` 移动至`核心模块`。

_Gradle dependency declaration: api vs implementation_

Gradle 依赖声明：api vs implementation_

By utilizing `api` instead of `implementation` dependencies can be shared transitively throughout the app. This decreases file size of each feature module, since the dependency only has to be included in a single module, in our case `:core`. Also it makes our dependencies more maintainable, since they are declared in a single file instead of spreading them across multiple `build.gradle` files.

通过 `api` 代替 `implementation` 可以在整个程序中共享依赖项。这将减少每一个功能模块的体积大小，因为在本例`核心模块`中，依赖项仅需要包含在单一模块中。此外还使我们的依赖关系更加地易于维护，因为它们被声明在一个单一的文件而非在多个 `build.gradle` 文件间传播。

#### Dynamic feature modules

动态功能模块

Above I mentioned the features we identified that can be refactored into `[com.android.dynamic-feature](https://developer.android.com/studio/projects/dynamic-delivery)` modules. These are:

```
:about
:designernews
:dribbble
:search
```

上面我提到了我们识别的可被重构为 [com.android.dynamic-feature](https://developer.android.com/studio/projects/dynamic-delivery) 的模块。它们是：

```
:about
:designernews
:dribbble
:search
```

#### _Introducing com.android.dynamic-feature_

动态功能介绍

A dynamic feature module is essentially a gradle module which can be downloaded independently from the base application module. It can hold code and resources and include dependencies, just like any other gradle module. While we’re not yet making use of dynamic delivery in Plaid we hope to in the future to further shrink the initial download size.

一个动态功能模块本质上是一个 gradle 模块，可以从基础应用模块被独立地下载。它包含代码、资源、依赖，就如同其它 gradle 模块一样。虽然我们还没有在 Plaid 中使用动态交付，但是我们希望在将来可以减少最初的下载体积。

### The great feature shuffle

伟大的功能改革

After moving everything to `:core`, we flagged the “about” screen to be the feature with the least inter-dependencies, so we refactored it into a new `:about` module. This includes Activities, Views, code which is only used by this one feature. Also resources such as drawables, strings and transitions were moved to the new module.

在将所有东西都移动至核心模块后，我们将“关于”页面标记为具有最少依赖项的功能，所以我们将其重构为一个新的`关于`模块。这包括 Activties、Views、代码仅用于该功能的内容。同样，我们把所有的资源例如 drawables、strings和动画移动至一个新的模块。

We repeated these steps for each feature module, sometimes requiring dependencies to be broken up.

我们队每个功能模块进行了重复操作，这有时需要分解依赖项。

In the end, `:core` contained mostly shared code and the home feed functionality. Since the home feed is only displayed within the application module, we moved related code and resources back to `:app`.

最后，核心模块包含了大部分共享代码和主要功能。由于主要功能仅显示于应用模块中，我们把相关代码和资源移动回 `APP`。

#### A closer look at the feature structure

功能结构剖析

Compiled code can be structured in packages. Moving code into feature aligned packages is highly recommended before breaking it up into different compilation units. Luckily we didn’t have to restructure since Plaid already was well feature aligned.

编译后的代码可以在包中进行结构优化。强烈建议在将代码分解成不同的编译单元之前，将代码移动至与功能对应的包中。幸运的是我们不用必须重构，因为 Plaid 已经很好地对应了功能。

![](https://cdn-images-1.medium.com/max/800/1*kE8K32z6aVssAmdboGuloA.png)

feature and core modules with their respective architectural layers

功能和核心模块以及各自的体系结构层级

As I mentioned, much of the functionality of Plaid is provided through news sources. Each of these consists of remote and local **data** source, **domain** and **UI** layers.

正如我提到的，Plaid 的许多功能都是通过新闻源提供的。它们由远程和本地 **data** 资源、**domain**、**UI**这些层级组成。

Data sources are displayed in both the home feed and, in detail screens, within the feature module itself. The domain layer was unified in a single package. This had to be broken in two pieces: a part which can be shared throughout the app and another one that is only used within a feature.

数据源不但显示在主要功能提示中，也显示在与对应功能模块本身相关的详情页中。域名层级在一个单一的包中是唯一的。它必须分为两部分：一部分在 APP 中共享，另一部分仅用在一个功能模块中。

Reusable parts were kept inside of the `:core` library, everything else went to their respective feature modules. The data layer and most of the domain layer is shared with at least one other module and were kept in core as well.

可复用部分被保存在核心模块中，其它的所有内容都在各自功能模块中。数据层和大部分域名层至少与其它一个模块共享，并且同时也保存在核心模块中。

#### Package changes

包变化

We also made changes to package names to reflect the new module structure.  
Code only relevant only to the `:dribbble` feature was moved from `io.plaidapp` to `io.plaidapp.dribbble`. The same was applied for each feature within their respective new module names.

我们还对包名进行了优化，从而反映新的模块化结构体系。
仅与 `:dribbble` 相关的代码从 `io.plaidapp` 移动至 `io.plaidapp.dribbble`。通过各自新的模块名称，这同样运用于每一个功能。

This means that many imports had to be changed.

这意味着许多导包必须进行改变。

Modularizing resources caused some issues as we had to use the fully qualified name to disambiguate the generated `R` class. For example, importing a feature local layout’s views results in a call to `R.id.library_image` while using a drawable from `:core` in the same file resulted in calls to

对资源进行模块化会产生一些问题，因为我们必须使用限定的名称来消除生成的 `R` 类歧义。例如，导入本地布局视图会导致调用 `R.id.library_image`，而在核心模块相同文件中使用一个 drawable 会导致

```
io.plaidapp.core.R.drawable.avatar_placeholder
```

We mitigated this using Kotlin’s import aliasing feature allowing us to import core’s `R` file like this:

我们使用 Kotlin 的导入别名特性减轻了这一点，它允许我们如下导入核心 `R` 文件：

```
import io.plaidapp.core.R as coreR
```

That allowed to shorten the call site to

允许将呼叫站点缩短为

```
coreR.drawable.avatar_placeholder
```

This makes reading the code much more concise and resilient than having to go through the full package name every time.

相较于每次都必须查看完整的报名，这使得阅读代码变得简洁和灵活得多。

#### Preparing the resource move

资源移动准备

Resources, unlike code, don’t have a package structure. This makes it trickier to align them by feature. But by following some conventions in your code, this is not impossible either.

资源不同于代码，没有一个包结构。这使得通过功能划分它们变得异常困难。但是通过在你的代码中遵循一些约定，这也未尝不可能。

Within Plaid, files are prefixed to reflect where they are being used. For example, resources which are only used in `:dribbble` are prefixed with `dribbble_`.

通过 Plaid，文件在被用到的地方作为前缀。例如，资源仅用于以 `dribbble_` 为前缀的 `:dribbble`。

Further, files that contain resources for multiple modules, such as styles.xml are structurally grouped by module and each of the attributes prefixed as well.

将来，一些包含多个模块资源的文件，例如 styles.xml 将在模块基础上进行结构化分组，并且每一个属性同时也作为前缀。

To give an example: Within a monolithic app, `strings.xml` holds most strings used throughout.  
In a modularized app, each feature module holds on to its own strings.  
It’s easier to break up the file when the strings are grouped by feature before modularizing.

举个例子：在单块APP中，`strings.xml` 包含了整体所用的大部分字符串。
在一个模块化APP中，每一个功能模块仅包含对应模块本身的字符串资源。
字符串在模块化之前进行分组将更容易拆分文件。

Adhering to a convention like this makes moving the resources to the right place faster and easier. It also helps to avoid compile errors and runtime crashes.

像这样遵循约定，可以更快地、更容易地价格资源转移至正确的地方。这同样也帮助避免编译错误和运行时序错误。

### Challenges along the way

过程挑战

To make a major refactoring task like this more manageable it’s important to have good communication within the team. Communicating planned changes and making them step by step helped us to keep merge conflicts and blocking changes to a minimum.

同团队良好的沟通，对使得一个重要的重构任务像这样易于管理，是十分重要的。传递计划变更并逐步实现这些变更将帮助我们合并冲突，并且将阻塞降到最低。

#### Good intentions

善意提醒

The dependency graph from earlier in this post shows, that dynamic feature modules know about the app module. The app module on the other hand can’t easily access code from dynamic feature modules. But they contain code which has to be executed at some point.

本文前面的依赖关系图表显示，动态功能模块了解 APP 模块。另一方面，APP 模块不能轻易地从动态功能模块访问代码。但是他们包含必须在某一时间定执行的代码。

Without the app knowing enough about feature modules to access their code, there is no way to launch activities via their class name in the `Intent(ACTION_VIEW, ActivityName::class.java)` way.  
There are multiple other ways to launch activities though. We decided to explicitly specify the component name.

APP 对功能模块没足够的了解时访问代码，这将没办法在 `Intent(ACTION_VIEW, ActivityName::class.java)` 方法中通过它们的类名启动 activities。

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

为实现它，我们在核心模块开发了 `AddressableActivity` 接口。

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

使用这种方式，我们创建了一个函数来统一活动启动意图创建：

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

最简单的实现 `AddressableActivity` 方式为仅需一个显示类名作为一个字符串。通过 Plaid，每一个 `Activity` 都通过该机制启动。对一些包含意图附加部分，必须通过 APP 各个组件传递到活动中。

You can see how we did this in the whole file here:

如下文件查看我们的实现过程：

- [**AddressableActivity.kt**: Helpers to start activities in a modularized world._github.com](https://github.com/nickbutcher/plaid/blob/master/core/src/main/java/io/plaidapp/core/util/ActivityHelper.kt "https://github.com/nickbutcher/plaid/blob/master/core/src/main/java/io/plaidapp/core/util/ActivityHelper.kt")

#### Styling issues

Styleing 问题

Instead of a single `AndroidManifest` for the whole app, there are now separate `AndroidManifests` for each of the dynamic feature modules.  
These manifests mainly contain information relevant to their component instantiation and some information concerning their delivery type, reflected by the `dist:` tag.  
This means activities and services have to be declared inside the feature module that also holds the relevant code for this component.

相较于整个 APP 单一清单文件而言，现在对每一个动态功能模块，对清单文件进行了分离。
这些清单文件主要包含与它们组件实例化相关的一些信息，以及通过 `dist:` 标签反应的一些与它们交付类型相关的一些信息。
这意味着活动和服务都必须声明在包含有与组件对应的相关代码的功能模块中。

We encountered an issue with modularizing our styles; we extracted styles only used by one feature out into their relevant module, but often they built upon `:core` styles using implicit inheritance.

我们遇到了一个将样式模块化的问题；我们仅将一个功能使用的样式提取到与该功能相关的模块中，但是它们经常是通过隐式构建在核心模块之上。

![](https://cdn-images-1.medium.com/max/800/1*YJRNNNgg5JbRoe20l14Ffw.png)

Parts of Plaid’s style hierarchy

PLaid 的样式结构部分

These styles are used to provide corresponding activities with themes through the module’s `AndroidManifest`.

这些样式通过模块的清单文件以主题形式被提供给组件的活动使用。

Once we finished moving them, we encountered compile time issues like this:

```
* What went wrong:

Execution failed for task ‘:app:processDebugResources’.
> Android resource linking failed
~/plaid/app/build/intermediates/merged_manifests/debug/AndroidManifest.xml:177: AAPT:
error: resource style/Plaid.Translucent.About (aka io.plaidapp:style/Plaid.Translucent.About) not found.
error: failed processing manifest.
```

一旦我们将它们移动完毕，我们会遇到像这样的编译时问题：

```
* What went wrong:

Execution failed for task ‘:app:processDebugResources’.
> Android resource linking failed
~/plaid/app/build/intermediates/merged_manifests/debug/AndroidManifest.xml:177: AAPT:
error: resource style/Plaid.Translucent.About (aka io.plaidapp:style/Plaid.Translucent.About) not found.
error: failed processing manifest.
```

The manifest merger tries to merge manifests from all the feature modules into the app’s module. That fails due to the feature module’s `styles.xml` files not being available to the app module at this point.

清单文件合并视图将所有功能模块中的清单文件合并到 APP 模块中。合并失败将导致功能模块的样式文件在指定时间点对 APP 模块不可用。

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

为此，我们在核心模块的样式文件中，为每一样式如下创建了一份空的声明：

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

现在清单文件合并在合并过程中抓取样式，尽管样式的实际实现是通过功能模块的样式引入的。

Another way to avoid this is to keep style declarations in the core module. But this only works if all resources referenced are in the core module as well. That’s why we decided to go with the above approach.

另一种避免如上问题的做法是保持样式文件声明在核心模块中。但这仅作用于所有资源引用同时也在核心模块当中的情况。这就是我们为何决定通上述方式的原因。

#### Instrumentation test of dynamic features

动态功仪器测试

Along the modularization we found that instrumentation tests currently can’t reside within the dynamic feature module but have to be included within the application module. We’ll expand on this in an upcoming blog post on our testing efforts.

通过模块化，我们发现测试工具目前不能驻留在动态功能模块当中，而是必须包含在应用模块当中。对此，我们将在即将发布的有关测试工作的博客文章中进行详细介绍。

### What is yet to come?

还会发生什么？

#### Dynamic code loading

动态代码加载

We make use of dynamic delivery through app bundles, but don’t yet download these after initial installation through the [Play Core Library](https://developer.android.com/guide/app-bundle/playcore). This would for example allow us to mark news sources that are not enabled by default (Product Hunt) to only be installed once the user enables this source.

我们通过 APP 束使用动态交付，但是在初次安装后不要通过 [Play Core Library](https://developer.android.com/guide/app-bundle/playcore) 下载这些文件。例如这将允许我们将默认未启用的新闻源（产品搜索）标记为仅在用户允许该新闻源后安装。

#### Adding further news sources

进一步增加新闻源

Throughout the modularization process, we kept in mind the possibility of adding further news sources. The work to cleanly separate modules and the possibility of delivering them on demand makes this more compelling.

通过模块化过程，我们保持考虑进一步增加新闻源可能性。分离清洁模块的工作以及实现按需交付的可能性使得这一点更加重要。

#### Finish modularization

模块精细化

We made a lot of progress to modularize Plaid. But there’s still work to do. Product Hunt is a news source which we haven’t put into a dynamic feature module at this point. Also some of the functionality of already extracted feature modules can be evicted from core and integrated into the respective features directly.

我们在对模块化 Plaid 方面取得了很大进展。但是仍有工作要做。产品搜索是一个新的新闻源，现在我们并未放到动态功能模块当中。同时，一些已经提取的功能模块中的功能可以从核心模块当中移除，然后直接集成到各自功能中。

### So, why did we decide to modularize Plaid?

为何我决定模块化 Plaid？

Going through this process, Plaid is now a heavily modularized app. All without making changes to the user experience. We did reap several benefits in our day to day development from this effort:

通过这个过程，Plaid 现在是一个高度模块化的应用。所有这些都不会改变用户体验。我们在日常开发中确实从这些努力中获得了一些益处。

#### Install size

安装体积

Plaid is now on average more than 60 % smaller on a user’s device.  
This makes installation faster and saves on precious network allowance.

PLaid 现在在用户设备上平均减少60%的体积。
这使得安装更快，并且节省了宝贵的网络开销。

#### Compile time

编译时间

A clean debug build without caches now takes **32 instead of 48 seconds**.*  
All the while increasing from ~50 to over 250 tasks.

一个没有缓存的调试构建现在需要**32秒而不是48秒**。
同时任务从50项增长到250项。

This time saving is mainly due to increased parallel builds and compilation avoidance thanks to modularization.

这样的时间节省，主要是由于增加了并行构建以及由于模块化而避免编译。

Further, changes in single modules don’t require recompilation of every single module and make consecutive compilation a lot faster.

将来，单个模块变化不需要对所有的单个模块进行编译，并且使得连续编译速度更快。

*For reference, these are the commits I built for [before](https://github.com/nickbutcher/plaid/commit/9ae92ab39f631a75023b38c77a5cdcaa4b2489c5) and [after](https://github.com/nickbutcher/plaid/tree/f7ab6499c0ae35ae063d7fbb155027443d458b3a) timing.

* 作为引用，这些是我构建 [before](https://github.com/nickbutcher/plaid/commit/9ae92ab39f631a75023b38c77a5cdcaa4b2489c5) 和 [after](https://github.com/nickbutcher/plaid/tree/f7ab6499c0ae35ae063d7fbb155027443d458b3a) timing 的一些提交。

#### Maintainability

可维护性

We have detangled all sorts of dependencies throughout the process, which makes the code a lot cleaner. Also, side effects have become rarer. Each of our feature modules can be worked on separately with few interactions between them. The main benefit here is that we have to resolve a lot less merge conflicts.

我们在过程中分离可各种依赖项，这使得代码更加简洁。同时，副作用越来越小。我们的每个功能模块都可以在越来越少的交互下独立工作。这样的主要益处是我们必须解决越来越少的冲突合并。

### In conclusion

结语

We’ve made the app **more than 60% smaller**, improved on code structure and modularized Plaid into dynamic feature modules, which add potential for on demand delivery.

我们使得应用体积减少**超过60%**，完善了代码结构并且将 PLaid 模块化成动态功能模块以及增加了按需交付潜力。

Throughout the process we always maintained the app in a state that could be shipped to our users. You can switch your app to emit an Android App Bundle today and save install size straight away. Modularization can take some time but is a worthwhile effort (see above benefits), especially with dynamic delivery in mind.

整个过程中，我们总是将应用保持在一个可以随时发送给用户的状态。您今天可以直接切换你的应用发出一个应用束以节省安装体积。模块化需一些时间，但鉴于上文看到的好处，这是值得付出努力的，特别是考虑到动态交付。

**Go check out** [**Plaid’s source code**](https://github.com/nickbutcher/plaid) **to see the full extent of our changes and happy modularizing!**

**去查看** [**Plaid’s source code**](https://github.com/nickbutcher/plaid) **了解我们所有的变化和快乐模块化过程！**

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
