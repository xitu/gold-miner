> * 原文地址：[Whats in the APK?](http://crushingcode.co/whats-in-the-apk/)
* 原文作者：[Nishant Srivastava](http://crushingcode.co/)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[Newt0n](https://github.com/newt0n)
* 校对者：[shliujing](https://github.com/shliujing), [siegeout](https://github.com/siegeout)

# APK 里有什么?

![header](http://crushingcode.github.io/images/posts/whatsintheapk/header.jpg)

如果我给你一份 Android 应用的源码然后请你提供关于 `minSdkVersion`, `targetSdkVersion`, permissions, configurations 等 Android 应用相关的信息，相信几乎每个有 Android 开发经验的人都能在短时间内给出答案。但如果我给你一个 Android 应用的 **APK** 文件然后让你给出同样的信息呢？🤔乍一想可能会有点棘手。

事实上我就遇到了这样的情况，尽管我很早就知道 `aapt` 这类工具的存在，但当我需要获取 `apk` 里的权限声明时也不能在第一时间想到方案。很显然我需要复习下相关概念然后找到个有效的方案来解决这个问题。这篇文章将会解释我是怎么做的，在大家想对任何别的 App 做这种反向内容查找的时候也会有帮助。🤓

**最常见的解决方案一定是下面这种**

从 **[APK[1]](https://en.wikipedia.org/wiki/Android_application_package)** 的定义开始

> **Android application package (APK)** 是一种包文件格式，在 Android 操作系统里它被用来进行应用程序的分发和安装。
> 
> …**APK** 是一种存档文件, 具体的说是基于 JAR 文件格式的 **zip** 格式包，以 `.apk` 作为文件扩展名。

![header](http://crushingcode.github.io/images/posts/whatsintheapk/apk.jpg)

..嗯，所以它是基于 **ZIP** 格式的，我能做的就是把它的扩展名从 **.apk** 改为 **.zip**，然后 ZIP 解压工具应该能解压出它的内容。

![header](http://crushingcode.github.io/images/posts/whatsintheapk/rename.jpg)

![header](http://crushingcode.github.io/images/posts/whatsintheapk/zip.jpg)

这就厉害了, 所以现在我们能看到并检查 zip 文件里的内容

![header](http://crushingcode.github.io/images/posts/whatsintheapk/contents.jpg)

现在你可能会想我们已经能访问到所有的文件，马上就能提供所有文章开头要求的那些信息了。不过，并没有这么简单的，亲😬。

可以试试随便用一个文本编辑器打开 `AndroidManifest.xml` 文件看看它的内容。你应该会看到这样的文本

![header](http://crushingcode.github.io/images/posts/whatsintheapk/androidmanifest.jpg)

这意味着这个披着 `xml` 格式外衣的 `AndroidManifest.xml` 文件不再是我们人类可读的格式了。所以你已经没有机会直接查看记载着 APK 文件基本信息的 `AndroidManifest.xml` 文件了。

其实还是有办法的 😋 有一些工具可以分析 Android APK 文件，而且有一款工具从 Android 系统诞生开始就有了。

> 我想所有经验丰富的开发者都知道这款工具，但我确信还是有很多的新手和富有经验的开发者从来没听过。

这个作为 Android 构建工具的组件的小工具就是

#### **`aapt`** - [Android Asset Packaging Tool[2]](http://elinux.org/Android_aapt)

> 这个工具可以用来列举、添加、移除 APK 包里的文件，打包资源或者压缩 PNG 文件等等。

首先，这个工具到底安装在哪？🤔

这个问题问得好，在你 Android SDK 的构建工具里可以找到它。

    <path_to_android_sdk>/build-tools/<build_tool_version_such_as_24.0.2>/aapt

它到底能做些什么 ? 我们用 `man` 命令看一下，输出如下：


*   `aapt list` - 列举 ZIP, JAR 或者 APK 文件里的内容。
*   `aapt dump` - 从 APK 文件里导出指定的信息。
*   `aapt package` - 打包 Android 资源。
*   `aapt remove` - 删除 ZIP、JAR 或者 APK 文件里的内容。
*   `aapt add` - 把文件添加到 ZIP、JAR 或者 APK 文件里。
*   `aapt crunch` - 压缩 PNG 文件。

我们感兴趣的是 `aapt list` 和 `aapt dump` 命令，尤其是有什么可以帮助我们得到 `apk` 信息的东西。

让我们直接对 `apk` 文件运行下 `aapt` 工具来找找我们想要的信息。

* * *

##### 从 APK 获取基础信息

    aapt dump badging app-debug.apk 

##### > 输出

    package: name='com.example.application' versionCode='1' versionName='1.0' platformBuildVersionName=''
    sdkVersion:'16'
    targetSdkVersion:'24'
    uses-permission: name='android.permission.WRITE_EXTERNAL_STORAGE'
    uses-permission: name='android.permission.CAMERA'
    uses-permission: name='android.permission.VIBRATE'
    uses-permission: name='android.permission.INTERNET'
    uses-permission: name='android.permission.RECORD_AUDIO'
    uses-permission: name='android.permission.READ_EXTERNAL_STORAGE'
    application-label-af:'Example'
    application-label-am:'Example'
    application-label-ar:'Example'
    ..
    application-label-zu:'Example'
    application-icon-160:'res/mipmap-mdpi-v4/ic_launcher.png'
    application-icon-240:'res/mipmap-hdpi-v4/ic_launcher.png'
    application-icon-320:'res/mipmap-xhdpi-v4/ic_launcher.png'
    application-icon-480:'res/mipmap-xxhdpi-v4/ic_launcher.png'
    application-icon-640:'res/mipmap-xxxhdpi-v4/ic_launcher.png'
    application: label='Example' icon='res/mipmap-mdpi-v4/ic_launcher.png'
    application-debuggable
    launchable-activity: name='com.example.application.MainActivity'  label='' icon=''
    feature-group: label=''
      uses-feature: name='android.hardware.camera'
      uses-feature-not-required: name='android.hardware.camera.autofocus'
      uses-feature-not-required: name='android.hardware.camera.front'
      uses-feature-not-required: name='android.hardware.microphone'
      uses-feature: name='android.hardware.faketouch'
      uses-implied-feature: name='android.hardware.faketouch' reason='default feature for all apps'
    main
    other-activities
    supports-screens: 'small' 'normal' 'large' 'xlarge'
    supports-any-density: 'true'
    locales: 'af' 'am' 'ar' 'az-AZ' 'be-BY' 'bg' 'bn-BD' 'bs-BA' 'ca' 'cs' 'da' 'de' 'el' 'en-AU' 'en-GB' 'en-IN' 'es' 'es-US' 'et-EE' 'eu-ES' 'fa' 'fi' 'fr' 'fr-CA' 'gl-ES' 'gu-IN' 'hi' 'hr' 'hu' 'hy-AM' 'in' 'is-IS' 'it' 'iw' 'ja' 'ka-GE' 'kk-KZ' 'km-KH' 'kn-IN' 'ko' 'ky-KG' 'lo-LA' 'lt' 'lv' 'mk-MK' 'ml-IN' 'mn-MN' 'mr-IN' 'ms-MY' 'my-MM' 'nb' 'ne-NP' 'nl' 'pa-IN' 'pl' 'pt' 'pt-BR' 'pt-PT' 'ro' 'ru' 'si-LK' 'sk' 'sl' 'sq-AL' 'sr' 'sr-Latn' 'sv' 'sw' 'ta-IN' 'te-IN' 'th' 'tl' 'tr' 'uk' 'ur-PK' 'uz-UZ' 'vi' 'zh-CN' 'zh-HK' 'zh-TW' 'zu'
    densities: '160' '240' '320' '480' '640'

* * *

##### 从 APK 的 AndroidManifest 中获取权限声明列表

    aapt dump permissions app-debug.apk

##### > 输出

    package: com.example.application
    uses-permission: name='android.permission.WRITE_EXTERNAL_STORAGE'
    uses-permission: name='android.permission.CAMERA'
    uses-permission: name='android.permission.VIBRATE'
    uses-permission: name='android.permission.INTERNET'
    uses-permission: name='android.permission.RECORD_AUDIO'
    uses-permission: name='android.permission.READ_EXTERNAL_STORAGE'

* * *

##### 获取 APK 的配置列表

    aapt dump configurations app-debug.apk

##### > 输出

    large-v4
    xlarge-v4
    night-v8
    v11
    v12
    v13
    w820dp-v13
    h720dp-v13
    sw600dp-v13
    v14
    v17
    v18
    v21
    ldltr-v21
    v22
    v23
    port
    land
    mdpi-v4
    ldrtl-mdpi-v17
    hdpi-v4
    ldrtl-hdpi-v17
    xhdpi-v4
    ldrtl-xhdpi-v17
    xxhdpi-v4
    ldrtl-xxhdpi-v17
    xxxhdpi-v4
    ldrtl-xxxhdpi-v17
    ca
    af
    ..
    sr
    b+sr+Latn
    ...
    sv
    iw
    sw
    bs-rBA
    fr-rCA
    lo-rLA
    ...
    kk-rKZ
    uz-rUZ

..也可以试试这些

    # 打印出 APK 里的资源清单
    aapt dump resources app-debug.apk

    # 打印出指定 APK 里编译过的 xml
    aapt dump xmltree app-debug.apk

    # 打印出编译过的 xml 里的字段
    aapt dump xmlstrings app-debug.apk

    # 列出 ZIP 存档里的内容
    aapt list -v -a  app-debug.apk    

就像你看到的，你可以轻松的通过 `aapt` 工具直接从 `apk` 获取信息甚至都不用尝试解压 `apk` 文件。

`appt` 还可以完成很多操作，你可以对 `aapt` 使用 `man` 命令获取详细说明。

    aapt r[emove] [-v] file.{zip,jar,apk} file1 [file2 ...]
      从 ZIP 归档中删除指定文件

    aapt a[dd] [-v] file.{zip,jar,apk} file1 [file2 ...]
      添加指定文件到 ZIP 归档中

    aapt c[runch] [-v] -S resource-sources ... -C output-folder ...
      执行 PNG 预处理操作并把结果存储到输出文件夹中

有兴趣的话可以自己探索一下，这里就不赘述了。 🙂

欢迎评论和建议。

> 从 [AndroidWeekly Issue 224[3]](http://androidweekly.net/issues/issue-224) 获取更多文章和教程, 谢谢你们的厚爱。

如果想获得更多类似的 Android 开发技巧，敬请关注我的 **[Android Tips & Tricks[4]](https://github.com/nisrulz/android-tips-tricks)** Github 仓库。我会不断的更新内容。
