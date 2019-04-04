> * 原文地址：[Cross-stitching Plaid and AndroidX](https://medium.com/androiddevelopers/cross-stitching-plaid-and-androidx-7603a192348e)
> * 原文作者：[Tiem Song](https://medium.com/@tiembo)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/cross-stitching-plaid-and-androidx.md](https://github.com/xitu/gold-miner/blob/master/TODO1/cross-stitching-plaid-and-androidx.md)
> * 译者：
> * 校对者：

# Cross-stitching Plaid and AndroidX

An AndroidX migration guide

![](https://cdn-images-1.medium.com/max/2560/1*XYbnKLfu7L533n8DASGvrQ.png)

Illustration by [Virginia Poltrack](https://twitter.com/vpoltrack)

Plaid is a fun Android app that showcases Material Design and a rich, interactive UI. Recently the app underwent a refresh by applying modern day Android app development techniques. To read more about the app and the vision for the redesign, check out [Restitching Plaid](https://medium.com/@crafty/restitching-plaid-9ca5588d3b0a).

* [**Restitching Plaid**: Updating Plaid to modern app standards](https://medium.com/@crafty/restitching-plaid-9ca5588d3b0a "https://medium.com/@crafty/restitching-plaid-9ca5588d3b0a")

Like most Android apps, Plaid relies on the Android Support Library which provides backwards compatibility of new Android features to phones running older versions of the OS. In September of 2018, the last version of the Support Library (28.0.0) was released. The libraries that shipped with the Support Library have been migrated to AndroidX (with the exception of the Design library which has migrated to Material Components for Android) and all new development of these libraries occur in AndroidX. Thus, the only way to receive bug fixes, new features, and other library updates was to migrate Plaid to AndroidX.

### What is AndroidX?

At Google I/O 2018, the Android team [announced AndroidX](https://android-developers.googleblog.com/2018/05/hello-world-androidx.html). It is the [open-source](https://android.googlesource.com/platform/frameworks/support/+/androidx-master-dev) project that the Android team uses to develop, test, package, version, and release libraries within [Jetpack](https://developer.android.com/jetpack/). Like the Support Library, each [AndroidX](https://developer.android.com/jetpack/androidx/) library ships separately from the Android OS and provides backwards-compatibility across Android releases. It is a major improvement and full replacement of the Support Library.

Read on to learn about how we prepared our code for the migration process and performed the migration itself.

### Prepare for migration

I highly suggest performing the migration on a version controlled branch. This way you can incrementally address any migration issues that may arise along with separating out each change for analysis. You can see our conversion progress in this [Pull Request](https://github.com/nickbutcher/plaid/pull/524) and follow along via the commit links below. Additionally, Android Studio offers an option to backup the project prior to starting the migration.

As with any large-scale code refactoring, it’s preferable to minimize merges to your main development branch while migrating to AndroidX to avoid merge conflicts. While this may not be feasible for other apps, our team was able to temporarily pause commits to our master branch to aid in the migration. It’s also essential to migrate the entire app at once, as a partial migration — using both AndroidX and the Support Libraries — will cause failures.

Finally, read the tips on [Migrating to AndroidX](https://developer.android.com/jetpack/androidx/migrate) on [developer.android.com](https://developer.android.com/). Now let’s begin!

### Identify dependencies

Before you begin, the most important piece of advice on code prep is:

> Ensure that the dependencies that you’re using are compatible with AndroidX

Libraries that depend on an older version of the support library may not be compatible with AndroidX, resulting in the likelihood that your app will not compile after the AndroidX migration. One way to find out if any of your app’s dependencies are incompatible is to visit each dependency’s project site. A more straightforward approach is to begin the migration and examine the errors that may come up.

For Plaid, we were using an older version (4.7.1) of the [Glide](https://bumptech.github.io/glide/) image loading library that wasn’t compatible with AndroidX. This caused a code generation issue after migration that left the app unbuildable (here is a similar [issue](https://github.com/bumptech/glide/issues/3126) logged in the Glide project). We upgraded to version 4.8.0 ([commit](https://github.com/nickbutcher/plaid/pull/524/commits/6b23efa838d4e9f60a3e78ae324c0c4a43ec8de0)) which added support for AndroidX annotations prior to starting the migration.

On that note, update to the latest versions of your dependencies if possible. This is especially a good idea for the Support Library, as upgrading to 28.0.0 (the final version) will make the migration smoother.

### Refactor with Android Studio

For the migration process, we used the refactoring built into Android Studio 3.2.1. The AndroidX migration tool is located under the Refactor menu > Migrate to AndroidX. This will migrate your entire project, including all of the modules.

![](https://cdn-images-1.medium.com/max/800/1*lztKTBouffsQZyUbkNkYHA.png)

The refactor preview window after running the AndroidX refactor tool

If you don’t use Android Studio or prefer to use another tool for migration, refer to the pages on [Artifact](https://developer.android.com/jetpack/androidx/migrate#artifact_mappings) and [Class](https://developer.android.com/jetpack/androidx/migrate#class_mappings) mappings. These are also available in CSV format.

The AndroidX migration tool in Android Studio is a great resource for migrating to AndroidX. The tool is continually improving, so if you encounter issues or would like to see a feature, please [file a ticket](https://issuetracker.google.com/issues/new?component=460323) on the Google issue tracker.

### Migrate the app

> **Change the minimum amount code in order to have the app run again.**

After running the AndroidX migration tool, a large amount of code changed, but the project did not build. At this point, we only [did the minimum amount of work](https://github.com/nickbutcher/plaid/compare/dd2ebf7f2de74809981e7c904c9ee22d16db5262...d2cefa384448f4d3fb92dec0ade25d9bd87efb63) to get the app running again.

This approach helps divide the process into manageable steps. We left tasks such as fixing import order, extracting dependency variables, and reducing full classpath usage for a clean up pass later.

One of the first errors that came up was a duplicate class — in this case, `PathSegment`:

```
Execution failed for task ':app:transformDexArchiveWithExternalLibsDexMergerForDebug'.

> com.android.builder.dexing.DexArchiveMergerException: Error while merging dex archives:

Learn how to resolve the issue at https://developer.android.com/studio/build/dependencies#duplicate_classes.

Program type already present: androidx.core.graphics.PathSegment
```

This was an error in the migration tool that generated an incorrect dependency (`androidx.core:core-ktx:0.3`). We manually updated ([commit](https://github.com/nickbutcher/plaid/pull/524/commits/8e60a351625b934a650b571dd67f4d206f96ac91)) to the correct one (`androidx.core:core-ktx:1.0.0`). This [bug](https://issuetracker.google.com/issues/111260482) has since been fixed and is available in Android Studio 3.3 Canary 9 and later. We wanted to point this out as you may encounter similar issues during your migration.

Next, the `Palette` API changed and is now nullable. To temporarily sidestep this ([commit](https://github.com/nickbutcher/plaid/pull/524/commits/75b8ffd621693ac52a0ce243599cfcfd25242d5f)), we added `!!` (the [not-null assertion operator](https://kotlinlang.org/docs/reference/null-safety.html#the--operator)).

We then ran into an error where `plusAssign` was missing. This overload was removed in 1.0.0. `plusAssign` usage was temporarily commented out ([commit](https://github.com/nickbutcher/plaid/pull/524/commits/d2cefa384448f4d3fb92dec0ade25d9bd87efb63)). Later in the article we’ll explore the permanent solutions for `Palette` and `plusAssign`.

The app now runs! Next, time to clean up the code.

### Clean up code

The app was running, but our Continuous Integration was reporting errors on commits:

```
Execution failed for task ':designernews:checkDebugAndroidTestClasspath'.

> Conflict with dependency 'androidx.arch.core:core-runtime' in project ':designernews'. 

Resolved versions for runtime classpath (2.0.0) and compile classpath (2.0.1-alpha01) differ. This can lead to runtime crashes. 

To resolve this issue follow advice at https://developer.android.com/studio/build/gradle-tips#configure-project-wide-properties.

Alternatively, you can try to fix the problem by adding this snippet to /.../plaid/designernews/build.gradle:

  dependencies {
    implementation("androidx.arch.core:core-runtime:2.0.1-alpha01")
  }
```

We followed the advice in the test logs and added the missing dependencies block ([commit](https://github.com/nickbutcher/plaid/pull/524/commits/aba91a9cd5a7a92dc5b9863a6b8c9f980597726b)).

We also took the opportunity to update our Gradle, Gradle wrapper, and Kotlin versions ([commit](https://github.com/nickbutcher/plaid/pull/524/commits/b38f2cf74520693699fbcedcb0119778396ba0ec)). Android Studio prompted us to install version 28.0.3 of build tools, which we complied. We ran into issues with Gradle 3.3.0-alpha13, which was resolved by downgrading back to 3.3.0-alpha08.

One drawback of the migration tool is that if you use variables in your dependencies versions, it will inline them for you. We re-extracted the versions out of build.gradle files ([commit](https://github.com/nickbutcher/plaid/pull/524/commits/0c5a3d62a83ecf400de376f4b4e6e7c3a6bf3c2a)).

We mentioned above that we put in temporary solutions for `plusAssign` and `Palette` after running the AndroidX migration tool. Now, we re-added the `plusAssign` function and associated tests ([commit](https://github.com/nickbutcher/plaid/pull/524/commits/0a5a5a3d50ece0f671201e1183b971fb4a3e158a)) by porting it from a previous version of the AndroidX library and uncommenting the code from above. Also, we updated the `Palette` parameters to be nullable ([commit](https://github.com/nickbutcher/plaid/pull/524/commits/7aad3005ea8ab222443f1a2ea34252e25328d677)), which removed the need to use `!!`.

Also, the auto conversion might change some classes to use their full classpath. It’s a good idea to make minor manual corrections. As part of the cleanup we removed the full classpath and re-added the relevant imports as necessary.

Finally, some minor test modifications were added to work around dependency conflicts during testing ([commit](https://github.com/nickbutcher/plaid/pull/524/commits/9715e2f8fdabc21b6d73e2f11f31982e90292461)) and Room tests ([commit](https://github.com/nickbutcher/plaid/pull/524/commits/a997200ec98b8466c427d5ac16eae94bae816da9)). At this point our project is fully converted and all of our tests are passing.

### Ending the thread

Despite running into a few roadblocks, the AndroidX migration went smoothly. The issues mostly involved incorrectly converted dependencies or classes, and API changes in the new libraries. Fortunately, these were all relatively easy to resolve. Plaid is now ready to wear again!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
