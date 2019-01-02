>* 原文链接 : [Vectors For All (finally)](https://blog.stylingandroid.com/vectors-for-all-finally/)
* 原文作者 : [stylingandroid](https://blog.stylingandroid.com)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [Jaeger](https://github.com/laobie)
* 校对者: [zhangzhaoqi](https://github.com/joddiy), [SatanWoo](https://github.com/SatanWoo)

# Vectors For All (最终篇)

这是关注 Android 的 __VectorDrawable__ 系列博文中的第三篇，之前的文章是[Vectors For All (almost)](http://gold.xitu.io/entry/574e8b192b51e900560074f8)，在此之前的另外一篇是[Vectors For All (slight return)](http://gold.xitu.io/entry/5756697ea341310063dd532c)。这两篇文章向我们展示了 VectorDrawable 的可用性有了很大的提升，但是对 _VectorDrawableCompat_ 的热切等待一直落空。直到2016年2月24号，Google 发布了 Android Support Library 23.2 版本，其中就包含了一直期待的 _VectorDrawableCompat_ 。

我不会给你长篇大论地讲解 _VectorDrawableCompat_ 的使用细节，因为 [Chris Banes](https://chris.banes.me/) 已经写了一篇很有深度的 [博文](https://medium.com/@chrisbanes/appcompat-v23-2-age-of-the-vectors-91cbafa87c88#.kf57cowuy) ，解释了如何使用 _VectorDrawableCompat_ ，因此在这就做重复性工作了。

因此，让我们看一下，我们需要对之前文章中使用的项目做些什么样的改动，以便可以使用 _VectorDrawableCompat_ 。首先要做的事就是修改我们的 _build.gradle_ 文件，正如 Chris 在他的文章中介绍的那样。

在示例代码中我使用的 Android Gradle 插件是 1.5.0 版本，而不是比较新的 2.0.0 beta 版本。因为 beta 版本插件容易失效，而我希望发布的代码在未来的几周或几个月内仍然可以成功编译——如果 2.0.0 发布了正式版，我将很乐意立即升级到 2.0.0 版本。即便如此，我们需要做以下几处修改（对于 2.0.0 版本，这些修改是不同的——可以去看 Chris 的文章了解更多细节——我也测试了 Chris 文中提到的方法，同样也是有效的）：

    apply plugin: 'com.android.application'

    android {
        compileSdkVersion 23
        buildToolsVersion "23.0.2"

        defaultConfig {
            applicationId "com.stylingandroid.vectors4all"
            minSdkVersion 7
            targetSdkVersion 23
            versionCode 1
            versionName "1.0"
            generatedDensities = []
        }
        aaptOptions {
            additionalParameters "--no-version-vectors"
        }
        buildTypes {
            release {
                minifyEnabled false
                proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
            }
        }
    }

    dependencies {
        compile fileTree(dir: 'libs', include: ['*.jar'])
        testCompile 'junit:junit:4.12'
        compile 'com.android.support:appcompat-v7:23.2.0'
    }

    apply from: '../config/static_analysis.gradle'

这样做的实质是关闭了过去从 _VectorDrawable_ 自动生成 PNG 资源的方式。

接下来我们需要做的是使用 `app:srcCompat` 代替 `android:src` 为我们的布局中的 _ImageView_ 设置图片资源：

    <?xml version="1.0" encoding="utf-8"?>
    <RelativeLayout xmlns:android="http://schemas.android.com/apk/res/android"
      xmlns:app="http://schemas.android.com/apk/res-auto"
      xmlns:tools="http://schemas.android.com/tools"
      android:layout_width="match_parent"
      android:layout_height="match_parent"
      android:paddingBottom="@dimen/activity_vertical_margin"
      android:paddingLeft="@dimen/activity_horizontal_margin"
      android:paddingRight="@dimen/activity_horizontal_margin"
      android:paddingTop="@dimen/activity_vertical_margin"
      tools:context=".MainActivity">

      <ImageView
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:contentDescription="@null"
        app:srcCompat="@drawable/svg_logo2" />

    </RelativeLayout>

这样就可以啦！当然确保我们的 _Activity_ 已经继承自 _AppCompatActivity_ ，这是使用 _VectorDrawableCompat_ 的前提。

唯一一点让我发牢骚的是 Android Studio （当我写这篇文章时，我正在使用 2.0 beat 6 版本）不识别 `app:srcCompat` 属性，因此报错了。但一切都可以正常编译。 我们也收到了一些错误的 Lint（译者注：静态代码检查工具）警告，但是如果你觉得有必要的话，这些警告是可以被关闭的。我希望这些错误的报错和警告问题能够尽快修复。

如果我们在一台 6.0 的设备上运行，一切看起来都不错，正如我们所预期的那样：

[![compat-m](https://i1.wp.com/blog.stylingandroid.com/wp-content/uploads/2016/02/compat-m.png?resize=300%2C225&ssl=1%20300w,%20https://i1.wp.com/blog.stylingandroid.com/wp-content/uploads/2016/02/compat-m.png?resize=768%2C576&ssl=1%20768w,%20https://i1.wp.com/blog.stylingandroid.com/wp-content/uploads/2016/02/compat-m.png?resize=1024%2C768&ssl=1%201024w,%20https://i1.wp.com/blog.stylingandroid.com/wp-content/uploads/2016/02/compat-m.png?resize=624%2C468&ssl=1%20624w)](https://blog.stylingandroid.com/?attachment_id=3696)

如果我们在一个 4.4 的模拟器上运行这个程序，看起来几乎一致。

[![compat-jb](https://i0.wp.com/blog.stylingandroid.com/wp-content/uploads/2016/02/compat-jb.png?resize=180%2C300&ssl=1%20180w,%20https://i0.wp.com/blog.stylingandroid.com/wp-content/uploads/2016/02/compat-jb.png?w=480&ssl=1%20480w)](https://blog.stylingandroid.com/?attachment_id=3697)

_AnimatedVectorDrawableCompat_ 又是怎样的呢？让我们再次看看 [Styling Android series on VectorDrawable](https://blog.stylingandroid.com/vectordrawables-part-1/) 中的例子是如何做的。

我们和前面一样修改这个示例项目，唯一不同的是这次我们需要修改 Activity 继承自 AppCompatActivity 。让我们来一步步调试我们的例子：

首先这是一个静态的 Android 标志：

[![screenshot-2016-02-27_11.03.32.637](https://i0.wp.com/blog.stylingandroid.com/wp-content/uploads/2016/03/screenshot-2016-02-27_11.03.32.637.png?resize=300%2C180&ssl=1%20300w,%20https://i0.wp.com/blog.stylingandroid.com/wp-content/uploads/2016/03/screenshot-2016-02-27_11.03.32.637.png?resize=768%2C461&ssl=1%20768w,%20https://i0.wp.com/blog.stylingandroid.com/wp-content/uploads/2016/03/screenshot-2016-02-27_11.03.32.637.png?resize=1024%2C614&ssl=1%201024w,%20https://i0.wp.com/blog.stylingandroid.com/wp-content/uploads/2016/03/screenshot-2016-02-27_11.03.32.637.png?resize=624%2C374&ssl=1%20624w,%20https://i0.wp.com/blog.stylingandroid.com/wp-content/uploads/2016/03/screenshot-2016-02-27_11.03.32.637.png?w=1280&ssl=1%201280w)](https://blog.stylingandroid.com/?attachment_id=3699)

正如我们所期待的那样，由于它是一个静态的_vectorDrawable，所以它的效果看起来很棒。当我们给它添加动画之后会发生什么呢？（这些例子全运行在 Android 4.4 的 GenyMotion 模拟器上）：

![](http://ww4.sinaimg.cn/large/a490147fgw1f3qiw99kzeg20qo0g01es.gif)

要知道这可是在模拟器上而不是真机上运行。显然，低配置的机器上帧率会差一些，同样，当我们适配更早的 Android 版本时，也会遇到许多类似的情况，但不管怎么说，这个结果是令人振奋的。

`trimPath` 动画表现的怎么样呢？

![](http://ww2.sinaimg.cn/large/a490147fgw1f3qizfsrzjg20qo0g04ly.gif)

再一次，`trimPath` 的效果也是令人叹服的——它达到了预期的效果，并且相当流畅。

不幸的是，上一系列的最后一个例子没生效。这是因为它是直接根据 `pathData` 来执行动画的，正如 Chris 提到的，目前 _AnimatedVectorDrawableCompat_ 并不支持这种方式。然而 Chris 使用了 “目前” 这个词——因此在这个库将来的某个版本中，可能会支持这种非常强大的特性。

这是对该兼容库的总结：该兼容库的表现相当棒，且集成到你当前的应用中也非常容易。感谢 Chris 和其他为此工作的团队成员，为我们带来了如此实用的功能。

因此，让我们关注下在我们的应用中使用矢量图需要注意的其他部分——将 SVG 资源转换成 _VectorDrawable_ 。据我们了解，过去 SVG 支持是有一些疏漏的，这意味着我们无法通过 Android Studio 的导入功能或者  [第三方 SVG 转 VectorDrawable 工具](http://inloop.github.io/svg2android/) 来导入官方的SVG Logo （这本应被认为是对基础 SVG 支持的一个基准）。现在这有好消息也有坏消息。

第一个坏消息是：Android Studio 仍然不能正确导入这个官方 SVG 标志——我已经测试了 Android Studio 2.0 beat 6 版本，仍然不支持。

但是也有个好消息，在我发布了该系列的上一篇文章之后不久，Juraj Novák （第三方转换工具的作者）联系了我，告知对本地 IRI 引用的支持遗漏（我早期的文章提到了这个）已经加上去了。不过有个小提示：当你转换这个 SVG 标志资源的时候，你**必须**勾选上提供给你的 “`Bake transforms into path (experimental)`” 选项，这个将会如实转换成一个你可以直接放到你项目中使用的 _VectorDrawable_ xml 文件。

第三方转换工具目前还不支持 SVG 的渐变和图样，但是这个是因为 _VectorDrawable_ 本身就不支持——只有 SVG 的 path data 是确切支持的。

使用 Juraj 的转换工具和最新的 _VectorDrawableCompat_ 库，这一切都为使用矢量图作为主流方式作好了准备，伙计们，让我们进入矢量图时代吧！（这段原文实在不好翻译= =）

这里是更新后支持兼容库的 [Vectors For All](https://github.com/StylingAndroid/Vectors4All/tree/finally) 文章和 [VectorDrawable](https://bitbucket.org/StylingAndroid/vectordrawables/src/a27f80278eac093b68161ec52a29ffd480e937c1/?at=Part3) 代码。

