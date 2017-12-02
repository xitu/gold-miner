> * 原文地址：[Sharing files through Intents: are you ready for Nougat?](https://medium.com/@quiro91/sharing-files-though-intents-are-you-ready-for-nougat-70f7e9294a0b#.8d2johavz)
* 原文作者：[Lorenzo Quiroli](https://medium.com/@quiro91?source=post_header_lockup)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[skyar2009](https://github.com/skyar2009)
* 校对者：[dubuqingfeng](https://github.com/dubuqingfeng), [tanglie1993](https://github.com/tanglie1993)

# Android Nougat 中通过 Intents 共享文件，你准备好了吗？

**从 Android 7.0 Nougat 开始，你将不能使用 Intent 传递 file:// URI 的方式访问你主包之外的文件，但是无需苦恼：下面将介绍如何解决这个问题。**

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*OlPkbZzZ4fNdrPNcewWAlA.jpeg">

**Android 7.0 Nougat** 为了提高安全性引入了一些 **文件系统权限变更**。如果你已经将 app 的 **targetSdkVersion** 升级为 24 （或者更高），并且你通过 [Intent](https://developer.android.com/reference/android/content/Intent.html) 传递 **file://**[URI](https://developer.android.com/reference/android/net/Uri.html) 来访问你的主包之外的文件，那么你将会遇到 [FileUriExposedException](https://developer.android.com/reference/android/os/FileUriExposedException.html) 的异常。

#### 为什么会这样呢？ ####

根据官方文档介绍：

> 为提高私有文件的安全性，在 Android 7.0 及以上的应用中的私有目录有着更严格的访问权限 （`0700`）。这个设定可以防止私有文件元数据的泄漏（比如文件的大小或者是否存在）。

当你通过 **file://** [URI](https://developer.android.com/reference/android/net/Uri.html)方式共享一个文件时，你同时修改了它的文件系统权限，使得它对所有应用都是可访问的（直到你再次修改它）。毋庸置疑这种方法是不安全的。

#### Ok, 但是这个问题只会影响 Nougat, 那我现在还需要修复吗？ ####

长话短说，当然需要。

确实，目前来说这个问题并不会影响很大范围的 Android 设备，但是这不仅仅是你不采用新特性的问题 —— 如果不解决，在 Nougat 设备上会崩溃，并且在以前的版本上是不安全的。而且修复这个问题并不困难，所以在你的应用发生奔溃以及你的用户开始抱怨之前，修复这个问题确实是值得的。

#### 是时候亮代码了 ####

最典型的例子（我也是通过它发现的这种问题），是当拍照时你给相机传递了一个文件 [URI](https://developer.android.com/reference/android/net/Uri.html) 来获取拍照后的照片。如果你想具体看看，在本文的结尾你可以找到一个 GitHub 代码库。

![Markdown](http://p1.bqimg.com/1949/46be5570af09f88d.png)

我们创建了一个文件，并把文件的 [URI](https://developer.android.com/reference/android/net/Uri.html) 传给了 [Intent](https://developer.android.com/reference/android/content/Intent.html) 来从相机应用接收文件（我们应用主包之外的路径）。这段代码在 Marshmallow 或更低版本上是正常的，在 Nougat、 SDK 24 版本或更高的版本，你会遇到类似下面的堆栈信息：

```

02-06 17:30:00.476 22265-22265/com.quiro.fileproviderexample E/AndroidRuntime: FATAL EXCEPTION: main

Process: com.quiro.fileproviderexample, PID: 22265
android.os.FileUriExposedException: file:///storage/emulated/0/Pictures/pics/JPEG_20170206_173000966174899.jpg exposed beyond app through ClipData.Item.getUri()
at android.os.StrictMode.onFileUriExposed(StrictMode.java:1799)
at android.net.Uri.checkFileUriExposed(Uri.java:2346)
at android.content.ClipData.prepareToLeaveProcess(ClipData.java:845)
at android.content.Intent.prepareToLeaveProcess(Intent.java:8941)
at android.content.Intent.prepareToLeaveProcess(Intent.java:8926)
at android.app.Instrumentation.execStartActivity(Instrumentation.java:1517)
at android.app.Activity.startActivityForResult(Activity.java:4225)
at android.support.v4.app.BaseFragmentActivityJB.startActivityForResult(BaseFragmentActivityJB.java:50)
at android.support.v4.app.FragmentActivity.startActivityForResult(FragmentActivity.java:79)
at android.app.Activity.startActivityForResult(Activity.java:4183)
at android.support.v4.app.FragmentActivity.startActivityForResult(FragmentActivity.java:859)
at com.quiro.fileproviderexample.MainActivity.takePicture(MainActivity.java:70)
at com.quiro.fileproviderexample.MainActivity$1.onClick(MainActivity.java:42)
at android.view.View.performClick(View.java:5637)
at android.view.View$PerformClick.run(View.java:22429)
at android.os.Handler.handleCallback(Handler.java:751)
at android.os.Handler.dispatchMessage(Handler.java:95)
at android.os.Looper.loop(Looper.java:154)
at android.app.ActivityThread.main(ActivityThread.java:6119)
at java.lang.reflect.Method.invoke(Native Method)
at com.android.internal.os.ZygoteInit$MethodAndArgsCaller.run(ZygoteInit.java:886)
at com.android.internal.os.ZygoteInit.main(ZygoteInit.java:776)                                                                                  
```

#### 解决方案 —— FileProvider ####

FileProvider 是 ContentProvider 的子类，FileProvider 允许我们使用 *content://* URI 的方式取代 *file://* 实现文件的安全共享。为什么这种方法更好？因为你为文件赋予了临时的访问权限 —— 仅仅允许接收者 activity 和 service 运行时才能访问。

首先，我们在 *AndroidManifest.xml* 中添加 `FileProvider`

```
<manifest>
    ...
    <application>
        ...
        <provider
            android:name="android.support.v4.content.FileProvider"
            android:authorities="@string/file_provider_authority"
            android:exported="false"
            android:grantUriPermissions="true">
            <meta-data
                android:name="android.support.FILE_PROVIDER_PATHS"
                android:resource="@xml/file_provider_paths" />
        </provider>
        ...
    </application>
</manifest>
```

我们将 `android:exported` 设置为禁止，因为我们不需要在其他应用使用；将 `android:grantUriPermissions` 设置为允许，因为这样才能给予文件临时访问权限；以及通过 `android:authorities` 设置管理的域。如果你的域为 `com.quiro.fileproviderexample`，你可以使用类似 `com.quiro.fileproviderexample.provider` 的内容来访问。提供者的授权标识应该是唯一的，所以我们往往会使用应用的包名加上类似 **.fileprovider:** 的内容。

```
<string name="file_provider_authority" 
translatable="false">com.quiro.fileproviderexample.fileprovider</string>
```

接下来我们需要在 res/xml 目录下创建 file_provider_path。这个文件用来定义允许安全共享的文件目录。在我们的例子中，我们只需要访问外部存储目录：

```
<?xml version="1.0" encoding="utf-8"?>
<paths>
    <external-path
        name="external_files" path="." />
</paths>
```

最后，修改我们的代码：

![Markdown](http://p1.bqimg.com/1949/2d62a56e6e9d8909.png)

用 `FileProvider.getUriForFile(context, string, file)` 的方式取代 `Uri.fromFile(file)` 来创建我们的 URI，`FileProvider.getUriForFile(context, string, file)` 会生成一个有权限访问我们所指向文件的 content://* URI。

接收者应用通过调用 [ContentResolver.openFileDescriptor](https://developer.android.com/reference/android/content/ContentResolver.html#openFileDescriptor%28android.net.Uri,%20java.lang.String%29) 来访问文件。在我们代码中 `Intent` 是供相机应用使用的，所以我们无需添加其他代码。
