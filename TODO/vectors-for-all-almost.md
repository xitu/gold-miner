>* 原文链接 : [Vectors For All (almost)](https://blog.stylingandroid.com/vectors-for-all-almost/)
* 原文作者 : [stylingandroid](https://blog.stylingandroid.com)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : 
* 校对者:


Regular readers of Styling Android will know of my love of _VectorDrawable_ and _AnimatedVectorDrawable_. While (at the time of writing) we’re still waiting for _VectorDrawableCompat_ so we can only use them on API 21 (Lollipop) and later. However, the release of Android Studio 1.4 has just added some backwards compatibility to the build tools so we can actually begin to use _VectorDrawable_ for pre-Lollipop. In this article we’ll take a look at how this works.  

Before we begin let’s have a quick recap of what _VectorDrawable_ is. Essentially it is an Android wrapper around SVG path data. SVG paths are a way of specifying complex graphical elements in a declarative way. They are particularly suited to line drawings and vector graphics, and unsuitable for photographic images. Traditionally in Android we have _ShapeDrawable_ where we can do [some basic stuff](https://blog.stylingandroid.com/more-vector-drawables-part-2/) but often we have to convert vector and line graphics in to bitmaps at various pixel densities in order to use them.

Android Studio 1.4 introduces the ability to import SVG graphics into Android Studio and converts them automatically to _VectorDrawable_. These can be icons from the [material icons pack](https://www.google.com/design/icons/) or standalone SVG files. Importing material icons works flawlessly and provides a large and rich set of icons. However, importing standalone SVG files can be rather more problematic. The reason for this is that the _VectorDrawable_ format only supports a subset of SVG and is missing features such as gradient and pattern fills, local IRI references (the ability to give an element a unique reference and re-use it within the SVG via that reference), and transformations – which are all commonly used.

For example, even a relatively simple image such as the official [SVG logo](http://www.w3.org/2009/08/svg-logos.html) (below) fails to import because it uses local IRI references:

[![](http://ww2.sinaimg.cn/large/a490147fjw1f3qekctzbxj208c08cgm3.jpg)](https://blog.stylingandroid.com/wp-content/uploads/2015/10/svg_logo.svg)

It’s currently unclear whether these omissions are for performance reasons (for example, gradients can be complex to render) or are future developments.

With an understanding the SVG format (which is beyond the scope of this article) it is possible to manually tweak the logo to remove the local IRI references and this is identical to the one above:

[![](http://ww3.sinaimg.cn/large/a490147fgw1f3qem0ozz1j208c08cgm3.jpg)](https://blog.stylingandroid.com/wp-content/uploads/2015/10/svg_logo2.svg)

This still does not import and the error message of “premature end of file” gives little clue where the problem lies. Thanks to a suggestion from [Wojtek Kaliciński](https://plus.google.com/+WojtekKalicinski) I changed the width and height from percentage values to absolute values and the import now worked. However because translations are not supported all of the elements were positioned badly:

[![](http://ww2.sinaimg.cn/large/a490147fgw1f3qemjbtmwj208c08c3yh.jpg)](https://i1.wp.com/blog.stylingandroid.com/wp-content/uploads/2015/10/svg_logo2.png?ssl=1)

By manually applying the all of the translation and rotation transformations from the original file (by wrapping `<path></path>` elements in `<group></group>` elements which support transformations) I was able to actually get the official SVG logo to import and render correctly as a _VectorDrawable_ on Marshmallow:

[![](http://ww3.sinaimg.cn/large/a490147fjw1f3qenekno5j208c069aa3.jpg)](https://i0.wp.com/blog.stylingandroid.com/wp-content/uploads/2015/10/SVGLogo.png?ssl=1)

There is a [conversion tool](http://inloop.github.io/svg2android/) by Juraj Novák which will convert SVG directly to _VectorDrawable_. It has many of the same restrictions of not handling gradients and local IRI references, but does a much better job of converting my hand-tweaked SVG. It was not thrown by having percentage width and height values, and it has an experimental mode to apply transformations which worked well in this case. But the need to manually convert the local IRI references still required hand-tweaking of the raw SVG files.

By dropping this in our `res/drawable` folder we can now reference it as any drawable:


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


Provided that we are using gradle plugin 1.4.0 or later (at the time of writing this isn’t released but `1.4.0-beta6` does the trick) this will now work back to API 1!

So what’s happening? If we take a look in the generated code in the build folder it becomes obvious:

[![Screen Shot 2015-10-03 at 15.20.33](https://i0.wp.com/blog.stylingandroid.com/wp-content/uploads/2015/10/Screen-Shot-2015-10-03-at-15.20.33.png?resize=386%2C509&ssl=1)](https://i0.wp.com/blog.stylingandroid.com/wp-content/uploads/2015/10/Screen-Shot-2015-10-03-at-15.20.33.png?ssl=1)

For API 21 and later the XML vector drawable that we imported is used, but for earlier devices a PNG of the vector drawable is used instead.

But what if we decide that we don’t need all of these densities and are concerned about the increased size of our APK as a result of this? We can actually control which densities will be generated using the `generatedDensities` property of the build flavor:



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



If we now build (remember to clean first to remove the resources that were generated by previous builds) we can see this only creates the densities we’ve specified:

[![Screen Shot 2015-10-03 at 15.27.08](https://i0.wp.com/blog.stylingandroid.com/wp-content/uploads/2015/10/Screen-Shot-2015-10-03-at-15.27.08.png?resize=384%2C509&ssl=1)](https://i0.wp.com/blog.stylingandroid.com/wp-content/uploads/2015/10/Screen-Shot-2015-10-03-at-15.27.08.png?ssl=1)

So, let’s now actually take a look at what is produced in the png representation:

[![](http://ww2.sinaimg.cn/large/a490147fgw1f3qeortzuwj208c08c3yh.jpg)](https://i1.wp.com/blog.stylingandroid.com/wp-content/uploads/2015/10/svg_logo2.png?ssl=1)

This is essentially the same as how the imported SVG was rendered before I manually added the missing transformations. I should mention that there **is** a lint warning which indicates that `<group></group>` elements are not supported for raster image generation, but that does not detract from the fact that _VectorDrawable_ is an Android-specific format so not fully supporting it seems baffling.

We now beginning to understand why transformations are not supported by the import tool – because transformations on _VectorDrawable_ `<group></group>` elements is not supported when converting _VectorDrawable_ to a raster image for backwards compatibility. This would appear to be a major omission: Totally valid _VectorDrawable_ assets which render perfectly under Lollipop and later do not actually render correctly when converted to PNG.

To, to summarise: If you use these new tools to import assets from the material icons library they work flawlessly. However, it seems misleading to even claim that the import tool is actually capable of importing SVG when it only supports a very limited subset, and will not correctly import most real-world SVG files. Moreover the lack of support even for the full _VectorDrawable_ specification in the VectorDrawable -> raster image conversion makes the implementation feel unfinished and not really ready for general use.

For the level of manual tweaking that I was required to do to even get the official SVG logo to even be converted to a _VectorDrawable_ by the import tool it would not have required much more work to manually convert it to a _VectorDrawable_ and completely bypass the import tool altogether. Although I would still be required to manually apply my transformations to all of the coordinates within the SVG pathData elements in order to manually apply the necessary transformations.

Let’s hope that some of these issues are addressed soon so that these new potentially very useful new tools begin to fulfil some of their promise.

The source code for this article is available [here](https://github.com/StylingAndroid/Vectors4All/tree/master).


