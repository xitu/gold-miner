>* 原文链接 : [Vectors For All (almost)](https://blog.stylingandroid.com/vectors-for-all-almost/)
* 原文作者 : [stylingandroid](https://blog.stylingandroid.com)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [edvardhua](https://github.com/edvardHua)
* 校对者: [SatanWoo](https://github.com/SatanWoo), [zhangzhaoqi](https://github.com/joddiy)

# Vectors For All (almost)

经常阅读 Styling Android 的读者会知道我有多么喜欢用 _VectorDrawable_ 和 _AnimatedVectorDrawable_ 。直到我在写这篇文章之前我还在等待 _VectorDrawableCompat_ （译者注：之前大家以为官方会出兼容 Support ，后来官方使用了另外一种方案，详细内容可戳该[链接](http://blog.chengyunfeng.com/?p=836&utm_source=tuicool&utm_medium=referral)），所以目前矢量图只能够在 API 21+ (Lollipop) 上面使用。然而，Android Studio 1.4 增加了对旧 android 的兼容，所以，实际上可以在低于 Lollipop 版本的机器上面使用 _VectorDrawable_ 。

在使用之前先来快速回顾一下什么是 _VectorDrawable_ 。 本质上来说它其实就是安卓对 SVG path data 的一层封装。而 SVG paths 是一种以 xml 方式描述复杂图形元素的东西。(译者注：感兴趣的可以阅读 W3C 的[官方文档](http://www.w3school.com.cn/svg/svg_reference.asp)) SVG 很适合用来储存线条和矢量图像，但不适合用来储存摄影图像。通常在Android中 _ShapeDrawable_ 可以实现一些线条和形状的[绘画](https://blog.stylingandroid.com/more-vector-drawables-part-2/)。 但大多数情况我们会将这些矢量图转换成不同像素密度位图来使用。在这篇文章中，我们将会一起来探索如何使用它。

Android Studio 1.4 介绍了如何将SVG图像导入到 Android Studio 然后再自动转换为 _VectorDrawable_ 。这些图标可以来自 [material icons pack](https://www.google.com/design/icons/) 或者是单独的 SVG 文件。导入 material icons 的确可以和 VectorDrawable 配合的天衣无缝，同时 google 也提供了大量的 icon 供我们选择。然而，导入单独的 SVG 文件会产生诸多的问题。产生这些问题的主要原因是 _VectorDrawable_ 只支持一部分的 SVG 特性，而像图像渐变，填充和本地 IRI 引用（能够给元素一个唯一的索引，然后在 SVG 内通过索引重用）以及图像的变换等一些我们经常使用的特性都不支持。

举个例子，即使是如官网 LOGO 这样简单的一个[SVG图像](http://www.w3.org/2009/08/svg-logos.html)(如下图所示)都不能导入到 Android 中，因为他使用了本地的IRI引用。

[![](http://ww2.sinaimg.cn/large/a490147fjw1f3qekctzbxj208c08cgm3.jpg)](https://blog.stylingandroid.com/wp-content/uploads/2015/10/svg_logo.svg)

现在还不太清楚 Android 去除这些特性是否是出于性能方面原因，（譬如，渐变效果的渲染会比较复杂一点）或者说是为了以后开发的考虑。

如果你足夠了解 SVG 的格式（这个已经不属于本文的讨论范畴了）我们可以手动的修改图标，然后移除本地 IRI 引用，我们可以对刚才提到的图标可以使用这个方法。

[![](http://ww3.sinaimg.cn/large/a490147fgw1f3qem0ozz1j208c08cgm3.jpg)](https://blog.stylingandroid.com/wp-content/uploads/2015/10/svg_logo2.svg)

然而仍然不能够导入到 Android ，因为会抛出 “premature end of file” 的错误信息，并且会指出出现问题的那行。感谢来自[Wojtek Kaliciński](https://plus.google.com/+WojtekKalicinski) 的建议，我将 SVG 中 width 和 height 的值从百分比改成绝对值之后就可以导入到 Android 中去了。但是因为水平和竖直移动（Translations）特性不支持，导致所有的元素摆放位置不好。

[![](http://ww2.sinaimg.cn/large/a490147fgw1f3qemjbtmwj208c08c3yh.jpg)](https://i1.wp.com/blog.stylingandroid.com/wp-content/uploads/2015/10/svg_logo2.png?ssl=1)

通过手动将所有的平移（translation）和旋转（rotation）变换从原来的 SVG 格式转换到 Android 中所支持的格式后（在`<group></group>`包含`<path></path>`来支持变换），我终于能够将 SVG 图标导入，并使用 VectorDrawable 将其在 Marshmallow 上正确渲染。

[![](http://ww3.sinaimg.cn/large/a490147fjw1f3qenekno5j208c069aa3.jpg)](https://i0.wp.com/blog.stylingandroid.com/wp-content/uploads/2015/10/SVGLogo.png?ssl=1)

使用 Juraj Novák 所开发的 [svg2android](http://inloop.github.io/svg2android/) 工具可以方便的将 SVG 转换成 _VectorDrawable_ 。该工具也有限制，那就是不能处理渐变和本地 IRI 引用的问题。但是可以省去我们手动微调的工作还是很不错的，像我刚才提到的宽高的问题，使用该工具转换则没有抛出错误。该工具开启实验性模式后还支持图像的变换（Transformation）并且支持的很好。但是对于本地的IRI引用还是需要我们手动的去修改原生的 SVG 文件。

将转换后的文件放到 `res/drawable` 文件夹后，我们可以直接当成 drawable 来引用，如下代码所示：


    <?xml version="1.0" encoding="utf-8"?>
    <RelativeLayout xmlns:android="http://schemas.android.com/apk/res/android"
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
        android:src="@drawable/svg_logo2" />
    </RelativeLayout>

假如我们使用的 gradle plugin 版本是 1.4.0 或者更高的话（截至到我写这篇文章之前，还未正式发布1.4.0，但是 `1.4.0-beta6` 已经可以实现这个效果了），那么他将适配到 Android API 1。

那么，适配低版本的原因是什么呢？让我们来看一下Build文件夹里面所生成的代码，答案就已经很明显了。

[![Screen Shot 2015-10-03 at 15.20.33](https://i0.wp.com/blog.stylingandroid.com/wp-content/uploads/2015/10/Screen-Shot-2015-10-03-at-15.20.33.png?resize=386%2C509&ssl=1)](https://i0.wp.com/blog.stylingandroid.com/wp-content/uploads/2015/10/Screen-Shot-2015-10-03-at-15.20.33.png?ssl=1)

针对于 API 21 或者更高版本的设备，我们导入的矢量 XML drawable 文件将会被使用，但是对于早起的版本，我们则使用 PNG 代替矢量的 drawable 。

但是如果我们出于 apk 大小的考虑，并不想生成多个 PNG 文件来适配多个分辨率呢？我们可以通过设置 `generatedDensities` 的值来决定需要生成 PNG 的分辨率和数量。


    apply plugin: 'com.android.application'

    android {
        compileSdkVersion 23
        buildToolsVersion "23.0.1"

        defaultConfig {
            applicationId "com.stylingandroid.vectors4all"
            minSdkVersion 7
            targetSdkVersion 23
            versionCode 1
            versionName "1.0"
            generatedDensities = ['mdpi', 'hdpi']
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
        compile 'com.android.support:appcompat-v7:23.0.1'
    }


如果我们现在进行 build ，我们会发现它（记住，在 build 之前先清除上一次 build 生成的 PNG 文件）只生成了我们指定的分辨率大小的 PNG 文件。

[![Screen Shot 2015-10-03 at 15.27.08](https://i0.wp.com/blog.stylingandroid.com/wp-content/uploads/2015/10/Screen-Shot-2015-10-03-at-15.27.08.png?resize=384%2C509&ssl=1)](https://i0.wp.com/blog.stylingandroid.com/wp-content/uploads/2015/10/Screen-Shot-2015-10-03-at-15.27.08.png?ssl=1)

所以，现在来看一下这些 PNG 图片里面的内容是什么：

[![](http://ww2.sinaimg.cn/large/a490147fgw1f3qeortzuwj208c08c3yh.jpg)](https://i1.wp.com/blog.stylingandroid.com/wp-content/uploads/2015/10/svg_logo2.png?ssl=1)

这些图片本质上跟我之前未修改的 SVG 图像的内容是相同的。我需要提醒大家，这里会抛出警告信息，告诉我们 `<group></group>`  元素不支持生成栅格化的图片格式。但是这并不能消除 _VectorDrawable_ 是 Android 中特有的格式，而且该格式不支持上述特性，这让我们感到很困惑的事实。

我们现在开始了解为什么图像的变换特性在导入工具中不被支持了，因为 _VectorDrawable_ 中的 `<group></group>` 元素不支持导出栅格化的图片格式，从而导致不能够向前兼容的问题。这个看上去是一个重大的疏忽：因为在 Lollipop 上面渲染正常的 _VectorDrawable_ 资源，在将他们转换成 PNG 后则不能够正确的渲染。

总结：如果使用这些新的工具从 material icons 库导入资源，那么它们则能够完美无瑕的渲染。但是，我们需要注意的是它们只具备导入 SVG 的能力以及只支持 SVG 一部分特性的转换，所以这导致了它们不能够导入现实世界中大部分的 SVG 文件。此外，对于新工具中将 _VectorDrawable_ 转换成 PNG 来适配低版本的机器的时候是不支持像素图转换的，这让我们觉得新工具的功能还没有完成还不能够拿来使用。

其实这种层次的手动微调花不了太多的时间（譬如修改官方 logo ），尤其我们是先用转换工具将它们转换成 _VectorDrawable_ 后。尽管我仍然需要手动的修改图像变换所涉及到的全部坐标，也就是 SVG pathData 的元素内容。

让我们期望这些问题在新的工具上会得到解决。这样这些有潜力的新工具才能够开始达到它们原来的目标。

这篇文章的源代码可以在[这里](https://github.com/StylingAndroid/Vectors4All/tree/master)找到。
