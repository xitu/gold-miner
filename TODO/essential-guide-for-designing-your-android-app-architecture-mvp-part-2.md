> * 原文地址：[Essential Guide For Designing Your Android App Architecture: MVP: Part 2](https://blog.mindorks.com/essential-guide-for-designing-your-android-app-architecture-mvp-part-2-b2ac6f3f9637#.k8ic3b2b3)
* 原文作者：[Janishar Ali](https://blog.mindorks.com/@janishar.ali?source=post_header_lockup)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[tanglie1993](https://github.com/tanglie1993)
* 校对者：[skyar2009](https://github.com/skyar2009), [Danny1451](https://github.com/Danny1451)

# Android MVP 架构必要知识：第二部分 #

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/2000/1*eHluapKk6_AaHNd2gkLi3A.png">

这是本系列文章的第二部分。在第一部分，我们提出了 MVP 的概念，并做出了一个安卓应用架构的蓝图。如果你还没有阅读第一部分，那么大部分接下来的文章将对你没有多大意义。所以，在你继续读下去之前，浏览一遍第一部分。


[这是指向第一部分的链接](https://github.com/xitu/gold-miner/blob/master/TODO/essential-guide-for-designing-your-android-app-architecture-mvp-part.md):



[**Android MVP 架构必要知识：第一部分**](https://github.com/xitu/gold-miner/blob/master/TODO/essential-guide-for-designing-your-android-app-architecture-mvp-part.md) 

基于在第一部分中提出的蓝图，我们将开发一个成熟的安卓应用，通过它实现 MVP 架构。

MVP 项目的 GitHub repo 地址:

[**MindorksOpenSource/android-mvp-architecture**](https://github.com/MindorksOpenSource/android-mvp-architecture)

本项目旨在提供一种正确的安卓应用架构方式。它包括了大多数安卓应用的全部代码模块。

这个项目刚开始看起来会很复杂，但是随着你花时间去探索，你看它也会变得更清晰明了。这个项目是用 Dagger2, Rxjava, FastAndroidNetworking  和 PlaceHolderView 实现的。

> 把这个项目当作一个学习案例。研究它的每一行代码。如果这里面有任何 bug 或者你能想出一个更好的逻辑实现，创建一个 pull request。我们在逐步写测试。欢迎你为测试做贡献，并通过 pull request 的方式提交。

开发出的应用的截屏如下：

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/400/1*qJTkiwJEUD8nW3VE5qr-9Q.png">

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/400/1*DO5gQCd9qJ7_WMaIof2eBQ.png">

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/400/1*d4WOBPrzv7N19tfkeY636Q.gif">

这个应用有一个登录页面和一个主页面。登录页面实现了 Google，Facebook 和服务器登录。Google 和 Facebook 登录是通过哑 API 实现的。登录是基于获取 access token 的，接下来的调用都被这个 token 所保护。主屏幕创建了和 MVP 相关问题的答题卡。这个 repo 包含了任何应用的大多数组件所需的基本框架。

让我们看一眼项目的结构：

整个应用被打包为五个部分：

1. **data**: 它包含所有访问和操控数据的组件。
2. **di**: 使用 Dagger2 提供依赖的类。
3. **ui**: View 类和它们对应的 Presenter。
4. **service**: 应用需要的服务。
5. **utils**: 工具类。

类的设计方法是这样的：它们应该能够被继承，并能最大化代码复用。

#### 项目结构图: ####

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/1000/1*SnfdPTpsXXSvojWE-joSJw.png">

> 简单的想法包含复杂的概念。

有很多非常有趣的部分。但如果我尝试同时解释所有的部分，信息量就太大了。所以，我认为最好的做法是解释核心的理念。这样，读者就可以通过浏览项目 repo 来理解这些代码。我建议你至少花一周时间研究这个项目。按照时间从后到前的顺序研究这些主要的类。


1. 研究 build.gradle 并寻找它使用的所有依赖。
2. 探索 data 包以及 helper 类的实现。
3. ui base 包创建了Activity, Fragment, SubView 和 Presenter 的基类。所有其他相关的组件都应该从这些类派生。
4. di 包是应用中负责提供依赖的类。要理解依赖注入，请浏览我发表的由两部分组成的文章，[**Dagger2 part 1**](https://blog.mindorks.com/introduction-to-dagger-2-using-dependency-injection-in-android-part-1-223289c2a01b#.bse4rt4mz) 和 [**Dagger2 part 2**](https://blog.mindorks.com/introduction-to-dagger-2-using-dependency-injection-in-android-part-2-b55857911bcd#.lahv7yh36)。
5. 资源：Styles, fonts, drawable。

如有任何问题，请在Twitter上联系我：

[**janishar ali (@janisharali) | Twitter**
The latest Tweets from janishar ali (@janisharali): "Check out the new release of Android-Debug-Database with complete…](https://twitter.com/janisharali)

### 参考资源: ###

- **RxJava2**: [https://github.com/amitshekhariitbhu/RxJava2-Android-Samples](https://github.com/amitshekhariitbhu/RxJava2-Android-Samples) 
- **Dagger2**: [https://github.com/MindorksOpenSource/android-dagger2-example](https://github.com/MindorksOpenSource/android-dagger2-example)
- **FastAndroidNetworking**: [https://github.com/amitshekhariitbhu/Fast-Android-Networking](https://github.com/amitshekhariitbhu/Fast-Android-Networking)
- **PlaceHolderView**: [https://github.com/janishar/PlaceHolderView](https://github.com/janishar/PlaceHolderView)
- **AndroidDebugDatabase**: [https://github.com/amitshekhariitbhu/Android-Debug-Database](https://github.com/amitshekhariitbhu/Android-Debug-Database)
- **Calligraphy**: [https://github.com/chrisjenx/Calligraphy](https://github.com/chrisjenx/Calligraphy)
- **GreenDao**: [http://greenrobot.org/greendao/](http://greenrobot.org/greendao/)
- **ButterKnife**: [http://jakewharton.github.io/butterknife/](http://jakewharton.github.io/butterknife/) 

**感谢阅读本文。如果你感觉它有帮助，请点击下面的 推荐这篇文章。这将让他人在 feed 中看到这篇文章，从而传播知识。**

更多关于编程的知识，请关注 [**我**](https://medium.com/@janishar.ali) 和 [**Mindorks**](https://blog.mindorks.com/) , 这样一旦我们发了新帖，你将会收到提醒。

[Mindorks 的最佳文章都在这里](https://mindorks.com/blogs) 

Coder’s Rock :)
