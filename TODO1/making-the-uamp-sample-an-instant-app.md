> * 原文地址：[Making the UAMP sample an instant app](https://medium.com/androiddevelopers/making-the-uamp-sample-an-instant-app-30c3f0a050af)
> * 原文作者：[Oscar Wahltinez](https://medium.com/@owahltinez)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/making-the-uamp-sample-an-instant-app.md](https://github.com/xitu/gold-miner/blob/master/TODO1/making-the-uamp-sample-an-instant-app.md)
> * 译者：
> * 校对者：

# Making the UAMP sample an instant app

Starting in Android Studio 3.3, the IDE will provide tooling support for instant apps. (As of this writing, Android Studio 3.3 is available as a [preview release](https://developer.android.com/studio/preview).) In this blog post we will cover [the steps that we took](https://github.com/googlesamples/android-UniversalMusicPlayer/commit/fc569696dd5dcaf7a8e1fa6bdeea82b30cf5f9d9) to convert the [Universal Android Music Player](https://github.com/googlesamples/android-UniversalMusicPlayer) (UAMP) sample into an instant app. For those hearing about instant apps for the first time, check out the [session from the Android Developer summit](https://www.youtube.com/watch?v=L9J2e5PYXNg), or [read the documentation](https://developer.android.com/topic/google-play-instant/) previously published about the topic.

![](https://cdn-images-1.medium.com/max/2000/0*c_CwU7uNVestpB4t)

## Requirements

To build and deploy instant apps without using the command line, we’ll need at least Android Studio 3.3. It is **very important** to also update the Android Gradle plugin to match the version of Android Studio. For example, at the time of this writing, Android Studio is on version 3.3 RC1 — so we used the following Gradle plugin version: `com.android.tools.build:gradle:3.3.0-rc01`.

## Updating the manifest

Inside of our manifest’s application tag, we need to add `<dist:module dist:instant=”true” />`. We may see an error stating that “Namespace ‘dist’ is not bound”, in which case we need to add `xmlns:dist="http://schemas.android.com/apk/distribution"` to the root manifest tag. Alternatively, we can follow the prompts from Android Studio to automatically resolve the error for us.

We can also add intent filters to handle the VIEW intent for a URL associated with our app, although this is [not the only way](https://developer.android.com/topic/google-play-instant/getting-started/feature-plugin#enable-try-now) to trigger an instant app launch. For UAMP, the updated version of the manifest looks like this:

```
<application ...>

    <!-- Enable instant app support -->
    <dist:module dist:instant="true" />

<activity android:name=".MainActivity">
        <intent-filter>
            <action android:name="android.intent.action.MAIN" />
            <category android:name="android.intent.category.LAUNCHER" />
        </intent-filter>

<!-- App links for http -->
        <intent-filter android:autoVerify="true">
            <action android:name="android.intent.action.VIEW" />
            <category android:name="android.intent.category.DEFAULT" />
            <category android:name="android.intent.category.BROWSABLE" />
            <data
                android:scheme="http"
                android:host="example.android.com"
                android:pathPattern="/uamp" />
        </intent-filter>

<!-- App links for https -->
        <intent-filter android:autoVerify="true">
            <action android:name="android.intent.action.VIEW" />
            <category android:name="android.intent.category.DEFAULT" />
            <category android:name="android.intent.category.BROWSABLE" />
            <data
                android:scheme="https"
                android:host="example.android.com"
                android:pathPattern="/uamp" />
        </intent-filter>
    </activity>
</application>
```

## Building and deploying an instant-enabled bundle

We could follow the process explained in the [Google Play Instant documentation](https://developer.android.com/topic/google-play-instant/getting-started/instant-enabled-app-bundle), but we can instead change the run configuration in Android Studio. To enable deployment as an instant app, we can select the **Deploy as instant app** undefinedcheckbox, as shown in this image:

![Enable app deployment as an instant app using the Android Studio UI](https://cdn-images-1.medium.com/max/2000/0*bCe1OhjN7ZVbv2eC)

Now, all that is left to do is click the very satisfying **Run** button in Android Studio and, if all the previous steps were done correctly, watch the instant app being deployed and launched automatically!

After this step, we will not see our app listed anywhere in the launcher. To find it, we must go to **Settings > Apps**, where the deployed instant apps are listed:

![Instant app info under Settings > Apps](https://cdn-images-1.medium.com/max/2000/0*YnFwtzi2bG-cSPuZ)

## Launching the instant app

Android will trigger the launch of an instant app in a number of ways. Outside of mechanisms that are tied to the Play Store, launching of an instant app is typically done by sending an ACTION_VIEW to one of the URLs defined as an intent filter in our manifest. For UAMP, running the following ADB command triggers our app:

```
adb shell am start -a android.intent.action.VIEW "https://example.android.com/uamp"
```

However, Android will also suggest launching our app from any other app that triggers ACTION_VIEW from URLs, which is basically every app except for web browsers:

![UAMP is launched when the **Open** button is pressed](https://cdn-images-1.medium.com/max/2160/0*LMIwDW_RUMO6PtKc)

For more information about app links, see the [relevant documentation](https://developer.android.com/training/app-links/instant-app-links) on the topic, including how to [verify the ownership of the links](https://developer.android.com/training/app-links/verify-site-associations) that your app handles.

## Known issues

For devices (or emulators) running API level 28, when we clear the **Deploy as Instant app** checkbox and try to deploy again, the following error occurs:

```
Error while executing: am start -n “com.example.android.uamp.next/com.example.android.uamp.MainActivity” -a android.intent.action.MAIN -c android.intent.category.LAUNCHER

Starting: Intent { act=android.intent.action.MAIN cat=[android.intent.category.LAUNCHER] cmp=com.example.android.uamp.next/com.example.android.uamp.MainActivity }

Error type 3

Error: Activity class {com.example.android.uamp.next/com.example.android.uamp.MainActivity} does not exist.

Error while Launching activity
```

The solution is to remove the instant app from the device, either from the **Settings > Apps** menu on a device or emulator, or by running `./gradlew uninstallAll` from the Android Studio terminal tab.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
