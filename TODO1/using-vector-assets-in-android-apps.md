> * 原文地址：[Using vector assets in Android apps](https://medium.com/androiddevelopers/using-vector-assets-in-android-apps-4318fd662eb9)
> * 原文作者：[Nick Butcher](https://medium.com/@crafty)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/using-vector-assets-in-android-apps.md](https://github.com/xitu/gold-miner/blob/master/TODO1/using-vector-assets-in-android-apps.md)
> * 译者：
> * 校对者：

# Using vector assets in Android apps

![Illustration by [Virginia Poltrack](https://twitter.com/VPoltrack)](https://cdn-images-1.medium.com/max/8418/1*oqnL46dzsUEDsmfABwTapg.png)

In previous posts we’ve looked at Android’s `VectorDrawable` image format and what it can do:

- [**Understanding Android’s vector image format: VectorDrawable**: Android devices come in all sizes, shapes and screen densities. That’s why I’m a huge fan of using resolution...](https://medium.com/androiddevelopers/understanding-androids-vector-image-format-vectordrawable-ab09e41d5c68)

- [**Draw a Path: Rendering Android VectorDrawables**: In the previous article, we looked at Android’s VectorDrawable format, going into its benefits and capabilities.](https://medium.com/androiddevelopers/draw-a-path-rendering-android-vectordrawables-89a33b5e5ebf)

In this post we’ll dive into how to **use** them in your apps. `VectorDrawable` was introduced in Lollipop (API 21) and is also available in AndroidX (as `VectorDrawableCompat`) bringing support all the way back to API 14 (over [99% of devices](https://developer.android.com/about/dashboards/)). This post will outline advice for actually using `VectorDrawables` in your apps.

## AndroidX First

From Lollipop onward, you can use `VectorDrawables` anywhere you would use other drawable types (referring to them using the standard `@drawable/foo` syntax) but I would *instead* recommend to **always** use the AndroidX implementation. This obviously increases the range of platforms you can use them on but more than this, it enables backporting of features and bug fixes to older platforms too. For example, using `VectorDrawableCompat` from AndroidX enables:

* Both `nonZero` and `evenOdd` path `fillTypes` —the two common ways of [defining the *inside *of a shape](https://www.sitepoint.com/understanding-svg-fill-rule-property/), often used in SVGs (`evenOdd` added to platform impl in API 24)
* Gradient & `ColorStateList` fills/strokes (added to platform impl in API 24)
* Bug fixes

In fact, AndroidX will use the compat implementation even on some platforms where a native implementation exists ([currently APIs 21–23](https://android.googlesource.com/platform/frameworks/support/+/androidx-master-dev/appcompat/src/main/java/androidx/appcompat/widget/AppCompatDrawableManager.java#100)) to deliver the above benefits. Otherwise it delegates to the platform implementation, so still receives any improvements on newer releases (for example `VectorDrawable` was re-implemented in C in API 24 for increased performance).

For these reasons you should **always** use AndroidX, even if you’re fortunate enough to have a `minSdkVersion` of 24. There’s little downside and *if/when* `VectorDrawable` is extended with new capabilities in the future *and* they’re also added to AndroidX, then they’ll be available straight away without having to revisit your code.

[Alex Lockwood](undefined) *gets it*:

![](https://user-images.githubusercontent.com/26959437/53942808-b4be1780-40f6-11e9-8260-902527955400.png)

## How?

To use the AndroidX vector support, there are *2 things* that you need to do:

### 1. Enable Support

You need to opt in to AndroidX vector support in your app’s `build.gradle`:

```
android {
    defaultConfig {
        vectorDrawables.useSupportLibrary = true
    }
}
```

This flag prevents the Android Gradle Plugin from [generating PNG versions](https://developer.android.com/studio/write/vector-asset-studio#apilevel) of your vector assets if your `minSdkVersion` is < 21—we don’t need this as we’ll use the AndroidX library instead.

It is also passed to the build toolchain. By default [AAPT](https://developer.android.com/studio/command-line/aapt2) (Android Asset Packaging Tool) *versions* resources. That means if you declare a `VectorDrawable` in `res/drawable/` it will move it to `res/drawable-v21/` for you as it knows this is when the `VectorDrawable` class was introduced.

>  This prevents attribute ID clashes — the attributes you use in `VectorDrawables` (`android:pathData`, `android:fillColor` etc) each have an integer ID associated with them, which were added in API 21. On older versions of Android, there was nothing preventing OEMs from using any ‘unclaimed’ IDs, making it unsafe to use a newer attribute on an older platform.

This versioning would prevent the asset from being accessed on older platforms, making a backport impossible—the gradle flag disables this versioning for vector drawables. This is why you use `android:pathData` etc within your vectors rather than having to switch to `app:pathData` etc like other backported functionality.

### 2. Load with AndroidX

When loading drawables you need to use methods from AndroidX which provide the backported vector support. The entry point for this is to **always** load drawables with [`AppCompatResources.getDrawable`](https://developer.android.com/reference/androidx/appcompat/content/res/AppCompatResources.html#getDrawable(android.content.Context,%20int)). While there are a [number](https://developer.android.com/reference/android/content/Context#getDrawable(int)) [of](https://developer.android.com/reference/android/support/v4/content/res/ResourcesCompat.html#getDrawable(android.content.res.Resources,%20int,%20android.content.res.Resources.Theme)) [ways](https://developer.android.com/reference/android/content/Context#getDrawable(int)) to load drawables (because reasons), you **must** use AppCompatResources if you want to use compat vectors. If you fail to do this, then you won’t hook into the AndroidX code path and your app might crash when trying to use any features not supported by the platform you’re running on.

>  `VectorDrawableCompat` also offers a `create` method. I’d recommend always using `AppCompatResources` instead as this adds a layer of caching.

If you want to set drawables declaratively (i.e. in your layouts) then `appcompat` offers a number of `*Compat` attributes that you should use **instead** of the standard platform ones:

`ImageView`, `ImageButton`:

* Don’t: `android:src`
* Do: `app:srcCompat`

`CheckBox`, `RadioButton`:

* Don’t: `android:button`
* Do: `app:buttonCompat`

`TextView` ([as of `appcompat:1.1.0`](https://developer.android.com/jetpack/androidx/androidx-rn#2018-dec-03-appcompat)):

* Don’t: `android:drawableStart` `android:drawableTop` etc.
* Do: `app:drawableStartCompat` `app:drawableTopCompat` etc.

As these attributes are part of the `appcompat` library, be sure to use the app: namespace. Internally these `AppCompat*` views use `AppCompatResources` themselves to enable loading vectors.

>  If you want to understand how `appcompat` swaps out the `TextView` etc you declare for an `AppCompatTextView` which enables this functionality then check out this article: [https://helw.net/2018/08/06/appcompat-view-inflation/](https://helw.net/2018/08/06/appcompat-view-inflation/)

## In Practice

These requirements effect the way you might create a layout or access resources. Here are some practical considerations.

### Views without compat attributes

Unfortunately there are a number of places you may want to specify drawables on views that don’t offer compat attributes (e.g. there’s no `indeterminateDrawableCompat` attribute for `ProgressBar`s) i.e. anything not listed above. It’s still possible to use AndroidX vectors, but you’ll need to do this from code:

```
/* Copyright 2018 Google LLC.
   SPDX-License-Identifier: Apache-2.0 */
val progressBar = findViewById<ProgressBar>(R.id.loading)
val drawable = AppCompatResources.getDrawable(context, R.drawable.loading_indeterminate)
progressBar.indeterminateDrawable = drawable
```

If you are using [Data Binding](https://developer.android.com/topic/libraries/data-binding/) then this can be accomplished using a custom binding adapter:

```
/* Copyright 2018 Google LLC.
   SPDX-License-Identifier: Apache-2.0 */
@BindingAdapter("indeterminateDrawableCompat")
fun bindIndeterminateProgress(progressBar: ProgressBar, @DrawableRes id: Int) {
  val drawable = AppCompatResources.getDrawable(progressBar.context, id)
  progressBar.indeterminateDrawable = drawable
}
```

Note that we **don’t** want data binding to load the drawable for us (as it doesn’t use `AppCompatResources` to load drawables [*currently](https://issuetracker.google.com/issues/111345022)*) so can’t refer to the drawable directly like `@{@drawable/foo}`. Instead we want to pass the drawable **id **to the binding adapter, so need to import the `R` class to reference it:

```
<!-- Copyright 2018 Google LLC.
     SPDX-License-Identifier: Apache-2.0 -->
<layout ...>
  <data>
    <import type="your.package.R" alias="R" />
    ...
  </data>

  <ProgressBar ...
    app:indeterminateDrawableCompat="@{R.drawable.foo}" />

</layout>
```

### Nested drawables

Some drawable types are nestable e.g. `StateListDrawables`, `InsetDrawables` or `LayerDrawables` contain other child drawables. The AndroidX support works by explicitly knowing how to inflate `<vector>` elements (also `animated-vector`s and `animated-selector`s, but we’ll focus on static vectors today). When you call `AppCompatResources.getDrawable`, it peeks at the resource with the given `id` and if it is a vector (i.e. the root element is `<vector>`), it manually inflates it for you. Otherwise, it hands it off to the platform to inflate — when doing so, there’s no way for AndroidX to *re-insert* itself back into the process. That means that if you have an `InsetDrawable` containing a vector and ask `AppCompatResources` to load it for you, it will see the `<inset>` tag, shrug, and hand it to the platform to load. It therefore will not get a chance to load the nested `<vector>` so this will either fail (on API <21) or just fall back to the platform support.

To work around this, you can create drawables in code; i.e. use `AppCompatResources` to inflate the vector and then create the `InsetDrawable` drawable manually.

One exception is a recent addition to AndroidX ([from `appcompat:1.0.0`](https://developer.android.com/jetpack/androidx/androidx-rn#1.0.0-new)) back-ported [`AnimatedStateListDrawable`](https://developer.android.com/reference/androidx/appcompat/graphics/drawable/AnimatedStateListDrawableCompat)s. This is a version of `StateListDrawable` with animated transitions between states (in the form of `AnimatedVectorDrawables`). But there is nothing *requiring* you to declare transitions. So if you just need a `StateListDrawable` which can inflate child vectors using AndroidX, then you could use this:

```
<!-- Copyright 2018 Google LLC.
     SPDX-License-Identifier: Apache-2.0 -->
<animated-selector ...>
  <item android:state_foo="true" android:drawable="@drawable/some_vector" />
  <item android:drawable="@drawable/some_other_vector" />
  <!-- no transitions specified -->
</animated-selector>
```

Credit for this genius hack: https://twitter.com/alexjlockwood/status/1029088247131996160

>  There is a way to enable vectors in nested drawables using [*AppCompatDelegate#setCompatVectorFromResourcesEnabled](https://developer.android.com/reference/android/support/v7/app/AppCompatDelegate.html#setCompatVectorFromResourcesEnabled(boolean))* but it has a number of drawbacks. Be sure to read the javadoc carefully.

### Out of process loading

Sometime you need to provide drawables in places where you don’t control *when* or *how* they are loaded. For example: notifications, homescreen widgets or some assets specified in your theme (e.g. setting `android:windowBackground` which is loaded by the platform when creating a preview window). In these cases you aren’t responsible for loading the drawable so there’s no opportunity to integrate AndroidX support and you cannot use vectors pre-API 21 😞.

You can of course use vectors on API 21+ but be aware that you might not enjoy the features/bugfixes provided by AndroidX. For example while it’s great that AndroidX backports `fillType="evenOdd"`, a vector which uses this *outside* of AndroidX support on an API 21–23 device won’t understand this attribute. For this specific example, I’ll cover how to convert fillType at design time in the next article. Otherwise, you may need to provide alternate resources for different API levels:

```
res/
  drawable-xxhdpi/
    foo.png             <-- raster
  drawable-anydpi-v21/
    foo.xml             <-- vector
  drawable-anydpi-v24/
    foo.xml             <-- vector with fancy features
```

Note that we need to include the `anydpi` resource qualifier here in addition to the api level qualifier. This is due to the way that [resource qualifier precedence](https://developer.android.com/guide/topics/resources/providing-resources#BestMatch) works; any asset in `drawable-<whatever>dpi` would be considered a better match then one in just `drawable-v21`.

## X Marks the Spot

Hopefully this article has highlighted the benefits of using the AndroidX vector support and some limitations that you need to be aware of. Using the AndroidX support both enables vectors on more platform versions and backports functionality but *also* sets you up to receive any *future* updates.

Now that we understand both *why* and *how* you should *use* vectors, the next article dives into how to *create* them.

Coming soon: Creating vector assets for Android
Coming soon: Profiling Android `VectorDrawable`s

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
