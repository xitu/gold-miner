> * 原文地址：[Exploring Firebase on Android & iOS: Analytics](https://medium.com/exploring-android/exploring-firebase-on-android-ios-analytics-8484b61a21ba#.b0hgigy3r)
* 原文作者：[Joe Birch](https://medium.com/@hitherejoe)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[Nicolas(Yifei) Li](https://github.com/yifili09)
* 校对者：[Danny1451](https://github.com/Danny1451), [owenlyn](https://github.com/owenlyn)

# 探索 `Firebase` 在 `Android` 和 `iOS` 的使用: 分析








`Firebase` 是一个令人惊艳的新的服务类聚合框架, 我已经对它进行了深入的阅读和实验。在这个新的系列文章中，我们会涵盖这些 `firebase` 的特性，去学习整合每一个功能能为我们带来什么。在本次章节中，我们准备看看 **`Firebase Analytics`** - 整合这个 `Analytics` 的功能使我们仅需要几个步骤就能开始追踪用户和应用程序的数据。










* * *







`Analytics` 对能更多地了解有关你的应用程序和用户来说是至关重要的。追踪一些事件能让你了解，例如，你的应用程序做了什么，有些用户可能未必知道的功能，用户是怎么探索你的应用程序的，或者当面对需要选择时，用户是怎么做出决定的。从这些数据中学习不仅能帮助你提高应用程序带来的用户体验度，也能帮助你提高应用程序的收入，并且能让你了解什么是需要改进提高的和为未来布局什么新特性。

`Firebase Analytics` 是一个工具，它能真真正正的帮助你了解我们的 `Android` 和 `iOS` 的用户是如何使用我们的应用程序。从启动开始，它会自动开始追踪一些预先设定好的事件 - 这意味着从第一步开始我们就能了解一些事件。在这基础上，我们还能够增加一些我们需要追踪的自定义事件。所有这些事件都能从 `Firebase` 的仪表板中的控制台中观察到 - 它是我们一个集中的入口，包括访问分析报告和其他的 `Firebase` 服务。

一旦我们已经追踪和分析了这些数据，我们可以决定未来对我们的应用程序做出什么修改能带来更好的用户体验。如果你还需要更多，**`Firebase Crash Reporting / Firebase 奔溃报告系统`** 也已经整合进了 `Firebase Analytics / Firebase 分析系统`，它能为观察者创建用户使用中应用程序奔溃的日志报告， **`Firebase Notifications / Firebase 通知系统`** 将为观察者发送通知并且追踪基于有交互通知的事件， **`Firebase Remote Config / Firebase 远程配置系统** 可以帮助观察者远程改变应用程序的外观感受和我们的应用程序的表现， **BigQuery** 用于针对我们一些追踪的事件执行更高级的数据分析,并且 **`Google Tag Manager / 谷歌标记管理器`** 可以让我们通过其他网页应用软件来远程建立我们的 `Firebase Analytics / Firebase 分析系统`。  











* * *







我也正在着手编辑一个全方位介绍如何整合 `Firebase 特性` 的指导手册，该手册将对每一个 `Firebase` 的内容进行更加详细的指导，它将会以电子书的形式发布。🙂  对于分析来说，在这本书中，我们会深入如何追踪分析和使用 `Firebase 终端`。请点击下方的图片，当我们发布这本电子书的时候会通知你知道！












![](https://cdn-images-1.medium.com/max/2000/1*frcwQV3MRhXAlm76fYKs5g.png)















* * *







### `Firebase Analytics` 和 `Google Analytics` 有什么不同? 

当我开始阅读有关 `Firebase Analytics` 的时候，潜意识里一下子让我想到，"那我已经设置好的 Google Analytics 怎么办？"。所以，如果你已经在使用 `Google Analytics`，那为什么你想要改变到 `Firebase Analytics` 呢？ 好吧，他们两者当然有很多的不同:

**观察者**

我们能使用 `Firebase Analytics` 创建观察者 - 这些是用户的组群，我们之后能使用其他的 `Firebase` 服务和这些组群互动，例如 `Firebase Notifications / Firebase 通知系统` 或者 `Firebase Remote Config / Firebase 远程配置系统`。

**整合其他 `Firebase` 服务**

我们能整合其他 `Firebase` 的服务到 `Firebase Analytics` 中，这是它的一个很棒的特性！举例来说，通过 `Firebase Crash Reporting / Firebase 奔溃报告系统`，为观察者创建遇到应用程序意外奔溃的日志报告。

**更少的接口方法**

`Google Analytics` Android 上一共有 18,607 个方法，依赖库一共占用了 `4kb` 的存储空间。另一方面来说，`Firebase Core` （对于分析服务） 有 15,130 个方法，并且依赖库仅仅占用了 `1kb` 的存储空间。

**自动追踪**

当我们增加了 `Firebase` 的核心依赖库，它就会为我们自动开始追踪一些用户的使用事件和设备的基本信息 - 如果你只需要一些对应用程序使用的基本数据，这是非常有用的。

**无限制的服务日志报告**

`Firebase Analytics` 提供给我们 `500` 多个事件的日志报告，它们都是无限制的并且免费的！

**不需要初始化单例**

当在 `Android` 上创建 `Google Analytics` 的时候，我们需要初始化一个单例。`Firebase Analytics` 可以在我们需要追踪数据的地方，方便地获得实例。当然这并不是什么大事，但是可以让建立过程更加简单。 

**单独的控制台**

每一个 `Firebase` 服务的所有数据都能从一个单独的控制台获取到。它让我们更加方便和快捷的对我们的应用程序在查看分析状态到观看最新的崩溃日志报告之间切换导航。











* * *







### 我们能追踪什么？

`Firebase` 的开发包提供了一系列以预定义常量的形式定义的常用事件，当追踪事件的时候，它能被使用。如果你只执行一些简单的追踪，那这些预定义的事件应该能覆盖你的需求。换句话说，使用以自定义命名的事件将允许你追踪那些对你应用程序来说很特别的事件，当看到那些由追踪到的结果所生成的报告的时候，它将会对你的应用程序有一个更深层次的分析和认识。

如前文提到的，一旦我们增加了核心依赖，`Firebase Analytics` 会自动为我们开始追踪事件 - 它们是: 

* **first_open** - 当用户在首次安装或者重新安装应用程序后，首次启动这个应用程序的时候，这个事件就被追踪了。注意，它并不表示这个应用程序被下载了多少次。
* **in_app_purchase** - 每当用户通过 `Google Play` 或者 `iTunes` 执行了一次应用内的购买，这个事件就被追踪了。当追踪的时候，这个事件会使用程序的 `name / 名字`，`产品的 ID`，与产品的数量和当前的货币信息来完成应用程序的购买。
* **user_engagement** - 这个事件追踪用户对应用程序的参与度，也同时记录应用程序在后台的情况。
* **session_start** - 当用户开始使用这个应用程序的时间超过某一个长度后，这个事件就被追踪了。
* **app_update** - 当用户把应用程序更新到一个更新的版本并且重新启动的时候，这个事件就被追踪了。当追踪的时候，之前应用程序的版本号会被作为一个参数发送 - 这为了显示与更新版本的差别。
* **app_remove** - 当用户删除了一个已经安装的应用程序包或者通过他们设备上的应用程序管理器卸载了这个应用程序的时候，这个事件就被追踪了。
* **os_update** - 当用户更新了他们设备的操作系统的时候，这个事件就被追踪了。当被追踪时，这个操作系统之前的版本会被作为一个参数发送回来。
* **app_clear_data** - 当用户在他们被追踪的应用程序的设备上清除或者重置了数据，这个事件就被追踪了。
* **app_exception** - 当这个应用程序抛出一些奔溃的异常信息的时候，这个事件就被追踪了。
* **notification_foreground** - 当这个应用程序在前台并且收到了一个由 `Firebase Notification` 发来的通知时，这个事件就被追踪了。
* **notification_receive** - 当这个应用程序在后台并且收到了一个由 `Firebase Notification` 发来通知的时候，这个事件就被追踪了。注意，这个事件仅追踪 `Android` 设备。
* **notification_open** - 当这个通知被打开了并且使用 `Firebase Notifications` 发送，这个事件就被追踪了。
* **notification_dismiss** - 当一个通知被取消并且使用 `Firebase Notifications` 发送，这个事件就被追踪了。
* **dynamic_link_first_open** - 当这个应用程序首次通过一个动态链接被启动了，这个事件就被追踪了。
* **dynamic_link_app_open** - 当这个应用程序使用了一个动态链接启动的时候，这个事件就被追踪了。
* **dynamic_link_app_update** - 当这个应用程序通过一个动态链接更新了，这个事件就被追踪了。注意，这个事件只能追踪 `Android` 设备。 

我们也可以使用自定义事件来追踪我们的应用程序。`Firebase` 提供了一份自定义事件列表，我们可能会通过这些分类来使用，例如:

*   [所有的应用程序](https://support.google.com/firebase/answer/6317498?hl=en&ref_topic=6317484)
*   [零售商 / 电子商务 ](https://support.google.com/firebase/answer/6317499?hl=en&ref_topic=6317484)
*   [工作，教育，本地产品推介，房地产](https://support.google.com/firebase/answer/6375140?hl=en&ref_topic=6317484)
*   [旅行产品](https://support.google.com/firebase/answer/6317508?hl=en&ref_topic=6317484)
*   [游戏产品](https://support.google.com/firebase/answer/6317494?hl=en&ref_topic=6317484)

除了这些，我们也能在我们的应用内定义我们自己的事件。我们会在之后的章节详细讨论!











* * *







### 开始使用

开始使用 `Firebase` 是非常简单的。首先，我们需要开始把应用程序增加到 [`Firebase 控制台`](https://console.firebase.google.com/)。一旦我们完成了这步，我们就能把 `Firebase` 的核心依赖增加到我们的项目工程中，开始自动从我们的应用程序的使用中追踪这些事件。让我们开始吧！

### 开始在 `Android` 上使用

**增加核心依赖**

`Firebase Analytics` 的功能可以在 `Firebase` 核心依赖中被发现。所以在我们的应用程序中追踪这些分析的事件，我们需要开始把 `firebase analytics` 的依赖增加到我们的 **build.gradle** 文件中。 

    compile 'com.google.firebase:firebase-core:9.4.0'

**获取这个 `Analytics` 的实例**

一旦我们增加了这个依赖，我们的应用程序将会自动开始追踪这些从应用程序来的默认的事件，例如，启动应用程序，设备信息，地区和其他的标准数据。

    private FirebaseAnalytics firebaseAnalytics;

现在我们已经增加了依赖，我们就可以继续并且使用这些类，我们会使用 `FirebaseAnalytics` 这个类来追踪需要分析的事件。我们需要从在这个类中申明我们想使用的那些对象开始（举个例子来说，这个可能是一个 `activity` 或者 `fragment`）。

    firebaseAnalytics = FirebaseAnalytics.getInstance(this);

一旦这个被申明过了，我们就能从 `Activity / Fragment` 中的 `onCreate()` 方法获取到 `FirebaseAnalytics` 的实例。 

在任何你想发送事件到 `Firebase` 的地方，你都需要取得这个实例。如果你正在使用依赖注入，你能简化这个 - 比如使用 `Dagger 2`:

    @Provides
    FirebaseAnalytics providesFirebaseAnalytics() {
        return FirebaseAnalytics.getInstance(activity);
    }

之后，每当我们想使用这个 `FirebaseAnalytics` 的实例，我们能通过简单的注入一个实例到我们想要的类中，比如:

    @Inject FirebaseAnalytics firebaseAnalytics;











* * *







### 开始在 `iOS` 上使用

**增加核心依赖**

`Firebase Analytics` 的功能可以在 `Firebase` 核心依赖中被发现。所以在我们的应用程序中追踪这些分析的事件，我们需要开始把 `Firebase analytics` 的依赖增加到我们的 **Podfile** 文件中。 

    pod ‘Firebase/core’

一旦增加了，确保记得运行以下命令来安装依赖:

    pod install

几乎都完成了！之后，我们需要导入这个依赖，所以我们能在这个应用程序中使用它。为了这个，我们需要增加这个导入的申明到我们的 `.xcworkspace` 文件。

在 `Objective-C` 中:

    @import Firebase;

在 `Swift` 中:

    import Firebase

**配置 `Analytics` 的实例**

一旦我们已经增加了这个依赖到我们的 `podfile` 文件，我们需要配置这个 `Firebase Analytics` 的实例。一旦完成这步，我们的应用程序将会自动开始追踪这些从应用程序来的默认的事件，例如，启动应用程序，设备信息，地区和其他的标准数据。

我们能在 `Objective-C` 中这么做，比如:

    [FIRApp configure];

并且在 `Swift` 中:

    FIRApp.configure()











* * *







### 在 `Android` 设备上追踪事件

现在我们已经访问到了 `FirebaseAnalytics` 的类，我们能在应用程序内追踪这个事件了。我们使用由 `Firebase SDK` 提供的 **logEvent()** 方法来追踪这些事件。这个方法需要两个参数:

* **name** - 用字符串来表示事件的名字。这个名字是**区分大小写的**并且最多使用 32 个字符且只能由字母和下划线组成。**注意:** 这个名字必须由一个字母开始。
* **params** - 一个 `Bundle` 对象包含了一些参数，他们都被相关的事件追踪。这个参数的名字至多可以使用 24 个字符并且就像名字，他们只能由字母和下划线组成，也只能由子母开始。参数取值的类型可以是 `String`, `long` 或者 `double`，并且不能超多 36 个字符。

我们也能通过简单直接调用无参数形的 **logEvent()** 来追踪一个事件，直接把 `null / 空值` 传送到参数就可以。

    firebaseAnalytics.logEvent(“checkout_complete”, null);

然而，如果我们想让参数和事件一同发送，那我们可以把他们包装在一起放到一个 `Bundle` 实例中。这允许我们用一个单独的对象发送多个参数。

    Bundle bundle = new Bundle();

    bundle.putString(“item_purchased”, “Pizza”);

    bundle.putInt(“item_quantity”, 1);

    firebaseAnalytics.logEvent(“checkout_complete”, bundle);

一旦我们调用这个 **logEvent()** 方法，我们的事件就被追踪，并且代表 `Firebase SDK` 发送给 `Firebase` 服务。  












* * *







### **在 `iOS` 设备上追踪事件**

现在我们已经访问到了 `FirebaseAnalytics` 的类，我们能在应用程序内追踪这个事件了。我们使用由 `Firebase SDK` 提供的 **logEvent()** 方法来追踪这些事件。这个方法需要两个参数:

* **name** - 用字符串来表示事件的名字。这个名字是**区分大小写的**并且最多使用 32 个字符且只能由字母和下划线组成。**注意:** 这个名字必须由一个字母开始。
* **params** - 一个 `Bundle` 对象包含了一些参数，他们都被相关的事件追踪。这个参数的名字至多可以使用 24 个字符并且就像名字，他们只能由字母和下划线组成，也只能由子母开始。参数取值的类型可以是 `String`, `long` 或者 `double`，并且不能超多 36 个字符。

举例来说，我们想要追踪那些，当用户通过我们的应用程序分享了一部分内容的时候。

    [FIRAnalytics logEventWithName:Share parameters:@{

        kFIRParameterContentType:@”Facebook article”,

        kFIRParameterId:@”01234”

    }];

所有提供的时间和参数都定义在了 **`FIREventName.h`** 和 **`FIRParameterNames.h`** 头文件中。然而，如果我们希望追踪自定义的事件或者参数，我们能在应用程序内定义自定义的事件和参数 - 这让我们能追踪更多自定义的事件。自定义事件的名字让我们能更灵活地对事那些并没有定义在 `FIREventNames.h` 头文件中的事件进行追踪，同时自定义的参数允许我们追踪与这些事件相关的东西，它可能没有被定义在 `FIREventParameters.h` 的文件中。我们能类似这样追踪自定义的事件和参数:

    [FIRAnalytics logEventWithName:@”share_facebook” parameters:@{

        @”article_name”: articleName,

        @”shared_by”: username,

        @”article_id”: articleId

    }];

**在 `Android` 设备上完整的日志记录**

激活完整的日志记录能让你检查自动和手动配置的事件是否被 `Firebase SDK` 正确的记录在日志中。我们可以在终端中通过输入以下 **`adb`** 命令来开启完整的日志记录:

    adb shell setprop log.tag.FA VERBOSE

    adb shell setprop log.tag.FA-SVC VERBOSE

    adb logcat -v time -s FA FA-SVC

一旦你激活了这个，你能运行调试版本的应用程序并且执行触发需要分析的事件。当事件被触发了，你应该能看到他们被显示在终端控制台中，如下所示:









![](https://cdn-images-1.medium.com/max/1600/1*rI8XxWJAMWSV3IxIAAHuBw.png)



将事件记录在终端中



如果你不能看到事件被记录，请确认检查你正确调用了前文中讨论的 **logEvent()**方法！

**在 `iOS` 设备上完整的日志记录**

为了确保我们的事件被正确的追踪，我们能方便地通过 `xcode` 来调试我们的 `Firebase Analytics` 的事件 - 事件可能需要花费好几个小时才能被显示在 `firebase` 的控制台中是常有的事。为了用 `xcode` 进行调试:

* 你需要先打开 **`Edit scheme`** 窗口。可以通过从 **`Product`** 到  **`Scheme`**并且从下拉框中选择 **`Edit Scheme`**。 
* 下一步，在你左手边，你需要从菜单中选择 **`Run`**。
* 之后，选择刚刚打开的 **`Run`** 窗体中的 **`Arguments`** 标签。
* 最后，在 **`Arguments Passed on Launch`** 标签内你需要增加： 

    -FIRAnalyticsDebugEnabled

这是一个必须的编译标识，它通知 `SDK` 去输出一些分析的事件到控制台。











* * *







### 用户信息

用户信息允许我们追踪那些使用我们应用程序的用户数据。这让我们可以追踪那些和应用程序本身无关的用户数据，以便我们更加注重用户的需求。就好像事件，`Firebase SDK` 会自动追踪一系列不同用户的信息。这些是:

* **App Version** - 用户安装在设备上的该应用程序的版本。在 `Android` 设备中追踪的是 `versionName`，而在 `iOS` 设备上是 `Bundle` 版本。
* **Device Model** - 安装了这个应用程序的设备型号。这是设备模型的名字，举例来说，`iPhone 6s`，或者 `SM-G9300`。
* **Gender** - 在设备上安装了应用程序的用户的性别。
* **Age** - 在设备上安装了应用程序的用户的年龄。它的数值分为: `18-24`, `25-34`，`35-44`，`45-54`，`55-64` 或者 `65+`。
* **Interests** - 在设备上安装了应用程序的用户感兴趣的分类。
* **OS Version** - 该设备运行的操作系统的版本。一般来说是一个数字格式，例如 `6.0` 或者 `9.3.1`
* **New / Established** - 两个数值来表示应用程序的使用程度。**New** 表示当用户在 7 天内就开始使用了应用程序，然而 **established** 表示用户 7 天前就开始使用应用程序。

**增加一个新的用户属性**

然而，我们并不仅限制单独使用这些属性 - 我们能在 `firebase` 控制台中自定义用户属性。我们能通过导航到 **User Properties** 的标签页，并且选择 **New User Property** 按钮。








![](https://cdn-images-1.medium.com/max/1600/1*mRXwy1QL936bFf9DqbVe6A.png)





一旦你选择了那个按钮，屏幕上会显示一个弹窗，你可以在弹窗里输入 **User Property** 的详细信息:

* **User property name** - 这个名字被用于识别用户属性。它应该用小写字母，并用下划线分割单词而不是用空格。
* **Description** - 一个简短的有关这个属性是干什么的描述 (最多 150 字符)。它应该是简洁的但不失描述性，所以你自己和其他人都能轻易明白这个属性在未来表示了什么。









![](https://cdn-images-1.medium.com/max/1600/1*blLCcbcFLOzlesPBsQ9BEg.png)





**在 `Android` 中设立用户属性**

在 `Android` 应用程序中追踪用户属性和追踪事件的方式一样。一旦我们在 `Firebase` 中注册了这个属性（在之前的章节有了详细的介绍），它很方便就如同从 `Firebase SDK` 中调用 **setUserProperty()** 方法。这个方法需要两个参数，他们是 **User Property Name** 和 **User Property Value**，亦是我们想设定的属性。 

    firebaseAnalytics.setUserProperty(
               “favourite_film_genre”, filmGenre);

一旦追踪了，我们能从 `Firebase` 控制台内观察到被追踪的用户属性。请记住，你会需要等待几个小时才能看到这个更新在控制台内出现。

**在 `iOS` 中设立用户属性**

在 `iOS` 应用程序中追踪用户属性和追踪事件的方式一样。一旦我们在 `Firebase` 中注册了这个属性（在之前的章节有了详细的介绍），它很方便就如同从 `Firebase SDK` 中调用 **setUserProperty()** 方法。这个方法需要两个参数，他们是 **User Property Name** 和 **User Property Value**，亦是我们想设定的属性。 


在 `Objective-C` 代码中，我们能这么干:

    [FIRAnalytics setUserPropertyString:filmGenre       
                                  forName:@”favourite_film_genre”]

在 `Swift` 代码中，它看上去是这样的：

    FIRAnalytics.setUserPropertyString(filmGenre   
                                  forName:”favourite_film_genre”)











* * *







### 总结！

这就是 `Firebase Analytics` 能为我们做到的事情，并且怎么在我们的应用程序中开始实现追踪事件的能力。我希望通过这篇文章你能看到 `Firebase` 为我们带来的好处和方便快捷的搭建方式。

如果你想要学习更多有关 `Firebase analytics` 的内容和其他整合资料，请记得先注册，当我的 `Firebase` 电子书面世的时候会通知提醒你们! ![🚀](https://linmi.cc/wp-content/themes/bokeh/images/emoji/1f680.png)








