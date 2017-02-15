> * 原文地址：[Sharing files through Intents: are you ready for Nougat?](https://medium.com/@quiro91/sharing-files-though-intents-are-you-ready-for-nougat-70f7e9294a0b#.8d2johavz)
* 原文作者：[Lorenzo Quiroli](https://medium.com/@quiro91?source=post_header_lockup)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

# Sharing files through Intents: are you ready for Nougat? #

*Since Android 7.0 Nougat you can’t expose a file:// URI with an Intent outside your package domain, but don’t worry: here’s how you can fix it.*

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*OlPkbZzZ4fNdrPNcewWAlA.jpeg">

**Android 7.0 Nougat** introduced some **file system permission changes** in order to improve security. If you’ve already updated your app to *targetSdkVersion* 24 (or higher) and you’re passing a *file://*[URI](https://developer.android.com/reference/android/net/Uri.html) outside your package domain through an [Intent](https://developer.android.com/reference/android/content/Intent.html) , then what you’ll get is a [FileUriExposedException](https://developer.android.com/reference/android/os/FileUriExposedException.html) .

#### Why is this happening? ####

According to the official documentation:

> In order to improve the security of private files, the private directory of apps targeting Android 7.0 or higher has restricted access (`0700`). This setting prevents leakage of metadata of private files, such as their size or existence.

When you share a file with a *file://* [URI](https://developer.android.com/reference/android/net/Uri.html) , you also modify the file system permission of it and make it available to any app (until you change it again). There’s no need to say that this approach is insecure.

#### Ok, but it’s affecting only Nougat, do I really have to fix it now? ####

TL;DR YES

It’s true, it’s not affecting a wide range of Android device as of right now, but this is not just a feature you’re not taking advantage of: it’s going to crash on Nougat, and it’s also insecure on previous versions. And the fix is not that hard to make, so it’s definitely worth to deal with this now before your app starts crashing and your users start complaining.

#### Time to show some code ####

The most basic example, which is also how I found out about this condition, is when you’re passing a file [URI](https://developer.android.com/reference/android/net/Uri.html) to the camera to take a picture. You can find a GitHub repo sample at the end of this post if you want to take a look at it.

![Markdown](http://p1.bqimg.com/1949/46be5570af09f88d.png)

We create a file and then we pass the [URI](https://developer.android.com/reference/android/net/Uri.html) of that file to the [Intent](https://developer.android.com/reference/android/content/Intent.html) which is going to get caught from a camera app (outside our package domain of course). This code will work fine if you’re on Marshmallow or a lower version, but it will throw an exception if you’re on Nougat and targeting sdk 24 or higher, and you’ll get a stacktrace similar to this:

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

#### FileProvider to the rescue ####

FileProvider is a special subclass of ContentProvider which allows us to securely share file through a *content://* URI instead of *file://* one. Why is this a better approach? Because you’re granting a temporary access to the file, which will be available for the receiver activity or service until they are active / running.

We start by adding the `FileProvider` in our *AndroidManifest.xml*:

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

We’re going to set `android:exported` to false because we don’t need it to be public, `android:grantUriPermissions` to true because it will grant temporary access to files and `android:authorities` to a domain you control, so if your domain is `com.quiro.fileproviderexample` then you can use something like `com.quiro.fileproviderexample.provider`. The authority of a provider should be unique and that’s the reason why we are using our application ID plus something like *.fileprovider:*

```
<string name="file_provider_authority" 
translatable="false">com.quiro.fileproviderexample.fileprovider</string>
```

Then we need to create the file_provider_path in the res/xml folder. That’s the file which defines the folders which contain the files you will be allowed to share safely. In our case we just need access to the external storage folder:

```
<?xml version="1.0" encoding="utf-8"?>
<paths>
    <external-path
        name="external_files" path="." />
</paths>
```

Finally, we just have to change our code:

![Markdown](http://p1.bqimg.com/1949/2d62a56e6e9d8909.png)

Instead of using `Uri.fromFile(file)` we create our URI with `FileProvider.getUriForFile(context, string, file)` which will generate a new *content://* URI with the authority defined pointing to the file we passed in.

The receiver app will be able to open the file by calling [ContentResolver.openFileDescriptor](https://developer.android.com/reference/android/content/ContentResolver.html#openFileDescriptor%28android.net.Uri,%20java.lang.String%29) . In our case the `Intent` is handled by the camera, so we don’t have to add any more code.
