>* 原文链接 : [Vectors For All (finally)](https://blog.stylingandroid.com/vectors-for-all-finally/)
* 原文作者 : [stylingandroid](https://blog.stylingandroid.com)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : 
* 校对者:


This is the third post in an occasional series looking at the state of _VectorDrawable_ support for Android. The previous articles are [Vectors For All (almost)](https://blog.stylingandroid.com/vectors-for-all-almost/) which was followed by [Vectors For All (slight return)](https://blog.stylingandroid.com/vectors-for-all-slight-return/). While these posts show that there has been a big improvement in the VectorDrawable tools available to us, but the eagerly awaited _VectorDrawableCompat_ was still missing. Until now. On 24th February 2016 Google released Android Support Library 23.2 which, among other things contains the eagerly anticipated _VectorDrawableCompat_.  

I’m not going to give a lengthy howto of the ins and outs of using _VectorDrawableCompat_ because [Chris Banes](https://chris.banes.me/) has already done that in a fairly in-depth [blog post](https://medium.com/@chrisbanes/appcompat-v23-2-age-of-the-vectors-91cbafa87c88#.kf57cowuy). Chris has already done an excellent job of explaining how to use _VectorDrawableCompat_ so it would serve little useful purpose to simply repeat that here.

So let’s take a look at the changes that we need to make to the project that we’ve used in the previous articles in order to use _VectorDrawableCompat_. The first thing that we need to do is make the modifications to our _build.gradle_ file that Chris explains in his post.

For the sample code I’m using Android Gradle plugin 1.5.0 and not the newer 2.0.0 beta one. The reason for this is that the beta plugin has built in expiry, and I prefer to publish sample code that should compile in weeks and months time – I’ll happily move to 2.0.0 once a stable version is released. That said, we need to make the following changes (it’s different for 2.0.0 – see Chris’ post for details – but I’ve tested that method as well and it works perfectly):

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

What this does it essentially turn off the auto-generation of PNG assets from our _VectorDrawable_ ones which was a previous way of doing things.

The next thing that we need to do is switch to `app:srcCompat` instead of `android:src` for the _ImageView_ in our layout:

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

That’s all there is to it! Our _Activity_ already extends _AppCompatActivity_ which is the other prerequisite.

the only minor niggle here is that Android Studio (I’m using 2.0 beta 6 at the time of writing) doesn’t recognise the `app:srcCompat` attribute and so gives an error. But everything compiles correctly. We also get a few false lint warnings but these can be suppressed, if necessary. I expect these false errors & warnings will be fixed fairly soon.

So if we run that on a Marshmallow device all looks good, as we’d expect:

[![compat-m](https://i1.wp.com/blog.stylingandroid.com/wp-content/uploads/2016/02/compat-m.png?resize=300%2C225&ssl=1%20300w,%20https://i1.wp.com/blog.stylingandroid.com/wp-content/uploads/2016/02/compat-m.png?resize=768%2C576&ssl=1%20768w,%20https://i1.wp.com/blog.stylingandroid.com/wp-content/uploads/2016/02/compat-m.png?resize=1024%2C768&ssl=1%201024w,%20https://i1.wp.com/blog.stylingandroid.com/wp-content/uploads/2016/02/compat-m.png?resize=624%2C468&ssl=1%20624w)](https://blog.stylingandroid.com/?attachment_id=3696)

And if we run it on a Jelly Bean emulator it looks pretty much identical:

[![compat-jb](https://i0.wp.com/blog.stylingandroid.com/wp-content/uploads/2016/02/compat-jb.png?resize=180%2C300&ssl=1%20180w,%20https://i0.wp.com/blog.stylingandroid.com/wp-content/uploads/2016/02/compat-jb.png?w=480&ssl=1%20480w)](https://blog.stylingandroid.com/?attachment_id=3697)

So what about _AnimatedVectorDrawableCompat_? Let’s re-visit the samples from the [Styling Android series on VectorDrawable](https://blog.stylingandroid.com/vectordrawables-part-1/) to see how they work.

We modify the project in much the same way as we did before – one difference is that we need to change our Activity to extend AppCompatActivity this time. So let’s step through our examples:

First there is the static Android logo:

[![screenshot-2016-02-27_11.03.32.637](https://i0.wp.com/blog.stylingandroid.com/wp-content/uploads/2016/03/screenshot-2016-02-27_11.03.32.637.png?resize=300%2C180&ssl=1%20300w,%20https://i0.wp.com/blog.stylingandroid.com/wp-content/uploads/2016/03/screenshot-2016-02-27_11.03.32.637.png?resize=768%2C461&ssl=1%20768w,%20https://i0.wp.com/blog.stylingandroid.com/wp-content/uploads/2016/03/screenshot-2016-02-27_11.03.32.637.png?resize=1024%2C614&ssl=1%201024w,%20https://i0.wp.com/blog.stylingandroid.com/wp-content/uploads/2016/03/screenshot-2016-02-27_11.03.32.637.png?resize=624%2C374&ssl=1%20624w,%20https://i0.wp.com/blog.stylingandroid.com/wp-content/uploads/2016/03/screenshot-2016-02-27_11.03.32.637.png?w=1280&ssl=1%201280w)](https://blog.stylingandroid.com/?attachment_id=3699)

As this is a static _VectorDrawable_ we’d expect it to work, and it looks great. What happens when we animate it (these examples are all from a GenyMotion JellyBean emulator):

![](http://ww4.sinaimg.cn/large/a490147fgw1f3qiw99kzeg20qo0g01es.gif)

The frame-rate is pretty good – and this is on an emulator rather than a real device! Obviously frame-rates will be worse on lower powered devices, and we’re likely to encounter many more of them when targeting earlier versions of Android, but the results are pretty impressive, nonetheless.

So how about the `trimPath` animation?:

![](http://ww2.sinaimg.cn/large/a490147fgw1f3qizfsrzjg20qo0g04ly.gif)

Once again, this is pretty impressive – it works as it should and is very smooth.

The final example from the previous series does not work, sadly. This is because it directly animates `pathData` and, as Chris mentions, this is not currently supported by _AnimatedVectorDrawableCompat_. However Chris does use the word “currently” – so perhaps a future version of the library will support this extremely powerful feature.

So that’s it for the Compat library – it really does perform well and is pretty easy to integrate in to your current app. A massive hat tip to Chris and the rest of the team who have worked on bringing this functionality to the masses.

So, let’s now turn our attention to the other aspect of using vectors in our apps – actually converting SVG assets in to _VectorDrawable_. Previously we saw how there were some omissions in the SVG support which meant that we were unable to import the official SVG logo (which should be considered a benchmark for basic SVG support) using both Android Studio import and the [third party SVG to VectorDrawable tool](http://inloop.github.io/svg2android/). There’s good news and there’s bad news.

First the bad news: Sadly Android Studio still does not import the logo without errors – I’ve tested on Android Studio 2.0 beta 6, and it’s still not supported.

However the good news is that shortly after I published the last article in this series I was contacted by Juraj Novák (the creator of the third party tool) to say that the missing missing support for local IRI references (see my earlier articles for a explanation of this) had been added. There is one small caveat: You **must** select the “`Bake transforms into path (experimental)`” option when converting the SVG logo asset but, provided you do, it is converted faithfully in to a _VectorDrawable_ xml which you can drop in to your project.

There is still no support for SVG gradients and patterns, but this is because they are not supported in _VectorDrawable_ itself – only SVG path data is actually supported.

With Juraj’s conversion tool, and the new _VectorDrawableCompat_ library this stuff really now is ready for the mainstream. So get out there and Vector, people!

There is updated code supporting the Compat library for both the previous [Vectors For All](https://github.com/StylingAndroid/Vectors4All/tree/finally) posts and [VectorDrawable](https://bitbucket.org/StylingAndroid/vectordrawables/src/a27f80278eac093b68161ec52a29ffd480e937c1/?at=Part3).

