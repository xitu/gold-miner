> * 原文地址：[New Android Injector with Dagger 2 — part 2](https://medium.com/@iammert/new-android-injector-with-dagger-2-part-2-4af05fd783d0)
> * 原文作者：[Mert Şimşek](https://medium.com/@iammert?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/new-android-injector-with-dagger-2-part-2.md](https://github.com/xitu/gold-miner/blob/master/TODO/new-android-injector-with-dagger-2-part-2.md)
> * 译者：[woitaylor](https://github.com/woitaylor)
> * 校对者：[XPGSnail](https://github.com/XPGSnail) [LeviDing](https://github.com/leviding)

# 全新 Android 注入器 : Dagger 2 （二）

![](https://cdn-images-1.medium.com/max/2000/1*mUOY8duji6LKT9dKFpDvoA.jpeg)

- [全新 Android 注入器 : Dagger 2 （一）](https://github.com/xitu/gold-miner/blob/master/TODO/new-android-injector-with-dagger-2-part-1.md)
- [全新 Android 注入器 : Dagger 2 （二）](https://github.com/xitu/gold-miner/blob/master/TODO/new-android-injector-with-dagger-2-part-2.md)

在上一篇博客中我尝试解释了 `dagger-android` 注入。收到了一些评论，有的人说太复杂了没必要
为了使用新特性去升级。我想到会发生这种情况，但我还是觉得有必要去解释dagger在幕后所做的工作。在阅读这篇博客之前
我强烈建议先阅读第一篇博客。本文中我会使用 `**_@ContributesAndroidInjector_**` 注解来简化上篇博客中的代码。



我们通过下面的图片来回忆第一篇博客中 `dagger` 结构图。 

![](https://cdn-images-1.medium.com/max/1000/1*RbT9g29U6QErwWktV6089Q.png)

我们一步步来检查该图谱。我只介绍 `MainActivity` 这部分。其他部分的逻辑一样。
* 创建一个 `_AppComponent_` 和 `_AppModule_`。
* 创建 `_MainActivity_`， `_MainActivityComponent_`， `_MainActivityModule_`。
* 映射 `_MainActivity_` 到 `_ActivityBuilder_` （这样 `dagger` 就能够知道 `MainActivity` 将被注入）。

让我们开始吧。在 `_MainActivity_` 中调用 `**_AndroidInjection.inject(this)_**` 并且在 `_MainActivityModule_` 中添加生成实例的方法。

我们只是想注入到 `MainActivity` ，却做了很多事情。能不能进一步简化？怎么简化？

* `@Subcomponent` 注解的 `MainActivityComponent` 和 `DetailActivityComponent` 在图中只是起到类似桥梁的作用。我们能够很容易地写出这两个类。
* 每当我们添加 `UI` 组件作为新的 `subcomponent` 都必须把 `activity` 映射到 `ActivityBuilder module`。这个工作经常是重复的。

### 不要做重复性的工作

`dagger` 的作者们显然也意识到这个问题，给了一个新的解决方法。于是就有了这个新注解—— `**@ContributesAndroidInjector .**`，使用这个注解我们能够轻松地把 `activities/fragments` 添加到 `dagger` 结构中。下图为简化后的 `dagger` 结构图，代码稍后给出。

![](https://cdn-images-1.medium.com/max/1000/1*KqjANMe67JfzRNp0-QQIEw.png)

通过上面的结构图我想你们能够理解得更深。这里给出修改后的[代码](https://github.com/iammert/dagger-android-injection/commit/5cf00f738751939b0d222e5da55e7f4384fa5798)。

当然也可以从[ `android injection` ](https://github.com/iammert/dagger-android-injection/tree/dagger-simplified-with-contributes)分支中拉取代码。




---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
