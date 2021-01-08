> * 原文地址：[Making the UAMP sample an instant app](https://medium.com/androiddevelopers/making-the-uamp-sample-an-instant-app-30c3f0a050af)
> * 原文作者：[Oscar Wahltinez](https://medium.com/@owahltinez)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/making-the-uamp-sample-an-instant-app.md](https://github.com/xitu/gold-miner/blob/master/TODO1/making-the-uamp-sample-an-instant-app.md)
> * 译者：[Mirosalva](https://github.com/Mirosalva)
> * 校对者：[Qiuk17](https://github.com/Qiuk17)

# 将通用安卓音乐播放器转化为 instant 应用

从 Android Studio 的 3.3 版本开始，IDE 将会为 instant 应用提供工具支持。（撰写至本文时，Android Studio 3.3 的可下载版本是 [preview release](https://developer.android.com/studio/preview)，撰写至译文时，3.3 版本已更新到正式 release 版）。这篇博文中我们将介绍 [我们即将采取的步骤](https://github.com/googlesamples/android-UniversalMusicPlayer/commit/fc569696dd5dcaf7a8e1fa6bdeea82b30cf5f9d9) 来把[通用安卓音乐播放器](https://github.com/googlesamples/android-UniversalMusicPlayer) (UAMP) 转换成 instant 应用。对于首次听说 instant 应用的人，可以查看 [Android 开发者峰会上的会话](https://www.youtube.com/watch?v=L9J2e5PYXNg)，或者之前发布的与该话题有关的[阅读文档](https://developer.android.com/topic/google-play-instant/)。 

![](https://cdn-images-1.medium.com/max/2000/0*c_CwU7uNVestpB4t)

## 需求

为了在不使用命令行的情况下构建和部署 instant 应用，我们需要最低版本为 Android Studio 3.3。升级 Android Gradle 插件来匹配 Android Studio 的版本也是**非常重要的**。例如，在撰写本文时，Android Studio 的版本最新为 3.3 RC1，因此我们使用如下 Gradle 插件版本：`com.android.tools.build:gradle:3.3.0-rc01`。

## 更新清单文件

在我们清单文件的 application 标签内部，我们需要添加代码 `<dist:module dist:instant=”true” />`。我们可能会看到报错信息表示『命名空间 ‘dist’ 没有被约束』，这里我们需要添加代码 `xmlns:dist="http://schemas.android.com/apk/distribution"` 到清单代码的根标签内。或者，我们可以按照 Android Studio 的提议为我们自动解决报错问题。

我们也可以添加 intent filters 属性来处理一个 VIEW intent，它与一个绑定我们应用的 URL 有关，尽管这[不是唯一的办法](https://developer.android.com/topic/google-play-instant/getting-started/feature-plugin#enable-try-now)来触发 instant 应用启动。对于 UMAP 来说，更新后的清单文件像下面代码这样：

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

## 构建和部署一个具备 instant 特性的应用包

我们可以遵照 [Google Play Instant 文档](https://developer.android.com/topic/google-play-instant/getting-started/instant-enabled-app-bundle)中解释的流程，我们也可以在 Android Studio 中更改运行配置。为了启用 instant 应用的部署，我们可以选择应用菜单中 **Deploy as instant app** 选择框，如下图所示：

![使用 Android Studio 界面来使应用部署为 instant 应用](https://cdn-images-1.medium.com/max/2000/0*bCe1OhjN7ZVbv2eC)

现在，剩下要做的就是在 Android Studio 中点击非常令人满意的 **Run** 按钮，如果前面所有步骤都正确执行，那就等着看 instant 应用被自动部署和启动吧！

这个步骤之后，我们不会看到我们的应用在启动时出现在任何列表中。为了找到它，我们需要进入菜单 **Settings > Apps**，已部署的 instant 应用被列在这里：

![Settings 列表下的 Instant 应用 > 应用](https://cdn-images-1.medium.com/max/2000/0*YnFwtzi2bG-cSPuZ)

## 启动 instant 应用

Android 系统可以通过很多种方式来触发启动一个 instant 应用。除了与 Play 商店绑定的机制之外，启动 instant 应用通常是通过将 ACTION_VIEW 发送到 URL 路径所对应的对象，这个 URL 在我们的清单文件中以 intent filter 的形式来定义。对于 UAMP 应用，通过运行下面的 ADB 指令来触发我们的应用：

```
adb shell am start -a android.intent.action.VIEW "https://example.android.com/uamp"
```

然而，Android 系统也会建议通过其他应用触发 ACTION_VIEW 对应的 URL 路径来启动我们的应用，这基本上适用于除了 web 浏览器外的所有应用。

![当**打开**按钮被按下时会启动 UAMP 应用](https://cdn-images-1.medium.com/max/2160/0*LMIwDW_RUMO6PtKc)

有关应用链接的更多信息，查看这个主题的[相关文档](https://developer.android.com/training/app-links/instant-app-links)，包括你的应用处理如何[验证链接的归属方](https://developer.android.com/training/app-links/verify-site-associations)的方法。

## 已知问题

对于运行 API 28 版本的设备（模拟器），当我们清除菜单上 **Deploy as Instant app** 选择按钮并试图再次部署时，会报如下的错误：

```
Error while executing: am start -n “com.example.android.uamp.next/com.example.android.uamp.MainActivity” -a android.intent.action.MAIN -c android.intent.category.LAUNCHER

Starting: Intent { act=android.intent.action.MAIN cat=[android.intent.category.LAUNCHER] cmp=com.example.android.uamp.next/com.example.android.uamp.MainActivity }

Error type 3

Error: Activity class {com.example.android.uamp.next/com.example.android.uamp.MainActivity} does not exist.

Error while Launching activity
```

解决办法是移除设备上的 instant 应用，既可以从设备或模拟器的设置菜单 **Settings > Apps** 中卸载，也可以通过 Android Studio 工具的标签 terminal 中执行指令 `./gradlew uninstallAll`。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
