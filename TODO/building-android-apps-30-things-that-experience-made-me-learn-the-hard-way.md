> * 原文地址：[Building Android Apps — 30 things that experience made me learn the hard way](https://medium.com/@cesarmcferreira/building-android-apps-30-things-that-experience-made-me-learn-the-hard-way-313680430bf9#.6cszf7t9m)
* 原文作者：[César Ferreira](https://medium.com/@cesarmcferreira)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者： [Nicolas(Yifei) Li](https://github.com/yifili09)
* 校对者：

# 构建 Android Apps 一定要绕过的 30 个坑

来自 [https://ramotion.com](https://ramotion.com) 的惊艳设计

有两类人 - 那些通过艰苦努力学习的人们和那些采纳别人意见学习的人们。在此，我想分享一些自己的经验给大家:







1. 请再三思考后，再决定是否增加第三方依赖库，它**绝对是一个严肃的**承诺;
2.  如果用户看不见它, [**请一定不要绘制**](http://riggaroo.co.za/optimizing-layouts-in-android-reducing-overdraw/)!;
3. 请在**你真的万不得已**的时候才使用数据库;
4.  突破 65k 方法数的限制会变得很快，我说的是真的很快！[**multidexing** 能拯救你](https://medium.com/@rotxed/dex-skys-the-limit-no-65k-methods-is-28e6cb40cf71);
5.  [RxJava](https://github.com/ReactiveX/RxJava) 是对 [更多的AsyncTasks](https://medium.com/swlh/party-tricks-with-rxjava-rxandroid-retrolambda-1b06ed7cd29c) **最好的**替代方法;
6.  [Retrofit](http://square.github.io/retrofit/) 是目前**最好的处理网络事务的依赖库** 
7. 使用 [**Retrolambda**](https://medium.com/android-news/retrolambda-on-android-191cc8151f85) 来精简你的代码;
8. [**将 Retrofit 和 Retrolambda 整合进 RxJava**](https://medium.com/swlh/party-tricks-with-rxjava-rxandroid-retrolambda-1b06ed7cd29c) 获得最大疗效;
9. [EventBus](https://github.com/greenrobot/EventBus) 非常好用, 但是我**不会**使用太多因为它会让代码库变得更混乱;
10. [按照特性来封装，而非界面](https://medium.com/the-engineering-team/package-by-features-not-layers-2d076df1964d);
11. 把_每一个事务_都从应用程序主线程移除;
12.  [lint](http://developer.android.com/tools/help/layoutopt.html) 帮助优化你的界面和层级，所以你能识别出哪些是可能被移除的重复视图;
13. 如果你正在用  _gradle_ , [你能如何加速它的执行速率](https://medium.com/the-engineering-team/speeding-up-gradle-builds-619c442113cb);
14. 执行一个 [构建分析报告](https://medium.com/the-engineering-team/speeding-up-gradle-builds-619c442113cb) 来检查下构建的过程中时间都花费在哪里了;
15. 使用一个 [知名的代码架构](http://fernandocejas.com/2015/07/18/architecting-android-the-evolution/) ;
16.  [众所周知，测试会花费很多时间，一旦你被某个问题困住，你就会明白有了测试用例会让你提高开发效率并且增加应用程序的健壮性。](http://stackoverflow.com/a/67500/794485) ;
17.  请使用 [依赖注入](http://fernandocejas.com/2015/04/11/tasting-dagger-2-on-android/) 来使你的应用程序更模块化，因此它也更加容易被测试;
18. 收听 [碎片广播](http://fragmentedpodcast.com/) 会大大帮助你;
19. [**永远不要** 使用你的个人 email 作为 android 应用发布市场的账号名](https://www.reddit.com/r/Android/comments/2hywu9/google_play_only_one_strike_is_needed_to_ruin_you/);
20. **请一直**使用 [合适的](http://developer.android.com/training/keyboard-input/style.html) 输入类型;
21. 使用 **分析模块** 来查找可用的模式和分离 bugs;
22. 保持最新的 [依赖库](http://android-arsenal.com/) (使用 [演习](https://github.com/cesarferreira/dryrun) 来更快的测试他们);
23. 你的服务应该尽快执行所需要的任务并且及时**被终止**;
24. 使用 [Account Manager](http://developer.android.com/reference/android/accounts/AccountManager.html) 来建议登录的用户名和 email 地址;
25. 使用 **CI** (持续集成) 来构建和分发你的测试和生产环境的 `apks`;
26. 请不要建立和运行你自己的 **CI** 服务器，维护这个服务器是很耗时的，因为会有磁盘空间问题，磁盘安全性问题 / 升级服务器来避免来自 `SSL` 的攻击，等等。可以使用 `circleci`，`travis`，`shippable`，他们不是很贵并且只需要关注价格九星;
27.  [使用 `playstore` 来自动化你的发布过程;](https://github.com/Triple-T/gradle-play-publisher)
28. 如果一个依赖库很庞大并且你只是使用其中一小部分的功能，你应该考虑一些其他**精简**的选择 (比如可以依赖 [proguard](http://developer.android.com/tools/help/proguard.html));
29. 不要使用你不需要的模块。如果_那个_模块并不需要常常修改，考虑从零开始构建的时间是很重要的(使用 **CI** 构建就是一个很好的例子)，或者检查之前那个单独构建的模型是否是最新的，相比起来只是简单的装载那些二进制的 `.jar/.aar` 依赖库，它能带来 4 倍的提升;
30. [开始考虑用 SVGs 替换 PNGs](http://developer.android.com/tools/help/vector-asset-studio.html);
31. 如果你只需要改变一个地方(例如，**_AppLogger.d(“message”)_** 能包含 **_Log.d(TAG, message)_** 并且之后发现 [**_Timber.d(message)_**](https://github.com/JakeWharton/timber) 会是一个更好的解决方案)，为依赖库制作抽象的类会让切换到新库变得很容易;
32. 监视连接状态和连接的种类 (**在 WIFI 通道上是不是有更多的更新数据**?);
33. 监视电源和电池 (**在充电的过程中，是不是有更多的更新数据？ 当电池电量低的时候，更新过程会不会被暂缓**);
34. 用户界面好像一个笑话。如果你不得不去解释，它不会和表现得那么好;
35.  [测试能带来性能的提升: 慢工出细活（但是正确），之后验证最佳实践并不会因为有了测试而被破坏](https://twitter.com/danlew42/status/677151453476032512)。













如果你对上面的建议有任何问题，请通过 tweet @[cesarmcferreira](https://twitter.com/cesarmcferreira)` 告诉我!




