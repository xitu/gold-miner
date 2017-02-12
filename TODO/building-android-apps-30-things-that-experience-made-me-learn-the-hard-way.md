> * 原文地址：[Building Android Apps — 30 things that experience made me learn the hard way](https://medium.com/@cesarmcferreira/building-android-apps-30-things-that-experience-made-me-learn-the-hard-way-313680430bf9#.6cszf7t9m)
* 原文作者：[César Ferreira](https://medium.com/@cesarmcferreira)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者： [Nicolas(Yifei) Li](https://github.com/yifili09)
* 校对者：[PhxNirvana](https://github.com/phxnirvana), [XHShirley](https://github.com/XHShirley)

# 构建 Android 应用程序一定要绕过的 30 个坑

来自 [https://ramotion.com](https://ramotion.com) 的惊艳设计

学习领域有两类人 - 一类是那些通过艰苦努力一步一步学习的人，一类是学习别人的经验教训走捷径的人。在此，我想分享一些自己的经验给大家:







1. 添加使用第三方依赖库前，请再三思考，它**绝对是一个慎重的**决定;
2.  如果用户看不见有些界面, [**请一定不要绘制它**](http://riggaroo.co.za/optimizing-layouts-in-android-reducing-overdraw/)!;
3. 除非**真的需要**，否则不要使用数据库;
4. 应用程序中 65k 方法数的限制很快就能达到，我意思是真的很快！[不过 **multidexing** 能拯救你](https://medium.com/@rotxed/dex-skys-the-limit-no-65k-methods-is-28e6cb40cf71);
5.  [RxJava](https://github.com/ReactiveX/RxJava) 是对 [AsyncTask 和其它异步任务类](https://medium.com/swlh/party-tricks-with-rxjava-rxandroid-retrolambda-1b06ed7cd29c) **最好的**替代品;
6.  [Retrofit](http://square.github.io/retrofit/) 是目前 android **最好的处理网络事务的依赖库** 
7. 使用 [**Retrolambda**](https://medium.com/android-news/retrolambda-on-android-191cc8151f85) 来精简你的代码;
8. [**把 RxJava 与 Retrofit 和 Retrolambda 整合在一起**](https://medium.com/swlh/party-tricks-with-rxjava-rxandroid-retrolambda-1b06ed7cd29c) 来达到最佳效果!;
9. [EventBus](https://github.com/greenrobot/EventBus) 非常好用, 但是我**不会**使用太多因为它会让代码库变得更混乱;
10. [按照应用功能来封装，而非所属类别](https://medium.com/the-engineering-team/package-by-features-not-layers-2d076df1964d);
11. 把_每一个事务_都从应用程序主线程移除;
12.  [lint](http://developer.android.com/tools/help/layoutopt.html) 这个工具能帮助优化你的界面和层级，所以你能识别出哪些是可能被移除的重复视图;
13. 如果你正在用  _gradle_ , [尽你所能加速它的执行效率](https://medium.com/the-engineering-team/speeding-up-gradle-builds-619c442113cb);
14. 执行一个 [Profile report / 构建分析报告](https://medium.com/the-engineering-team/speeding-up-gradle-builds-619c442113cb) 来检查下构建的过程中时间都花费在哪里了;
15. 使用一个 [众所周知的代码架构](http://fernandocejas.com/2015/07/18/architecting-android-the-evolution/) ;
16.  [测试会花费很多时间，一旦你被某个问题困住，你就会明白有了测试用例会让你提高开发效率并且增加应用程序的健壮性。](http://stackoverflow.com/a/67500/794485) ;
17.  请使用 [依赖注入](http://fernandocejas.com/2015/04/11/tasting-dagger-2-on-android/) 来使你的应用程序更模块化，因此它也更加容易被测试;
18. 收听 [Fragmented 播客](http://fragmentedpodcast.com/) 会大大帮助你;
19. [**永远不要** 使用你的个人 email 作为 android 应用发布市场的账号名](https://www.reddit.com/r/Android/comments/2hywu9/google_play_only_one_strike_is_needed_to_ruin_you/);
20. **请一直**使用 [合适的](http://developer.android.com/training/keyboard-input/style.html) 输入类型;
21. 使用 **Analytics** 来查找可用的模式和分离 bug;
22. 保持最新的 [依赖库](http://android-arsenal.com/) (使用 [dryrun](https://github.com/cesarferreira/dryrun) 来更快的测试他们);
23. 你的服务应该尽快执行所需要的任务并且及时**被终止**;
24. 使用 [Account Manager](http://developer.android.com/reference/android/accounts/AccountManager.html) 来提示登录的用户名和 email 地址;
25. 使用 **CI** (持续集成) 来构建和分发你的测试和生产环境的 `apk`;
26. 请不要建立和运行你自己的 **CI** 服务器，维护这个服务器是很耗时的，因为会有磁盘空间问题，磁盘安全性问题 / 升级服务器来避免来自 `SSL` 漏洞的攻击，等等。可以使用 `circleci`，`travis`，`shippable`，他们不是很贵并且只需要关注价格就行;
27.  [使用 `playstore` 来自动化你的发布过程;](https://github.com/Triple-T/gradle-play-publisher)
28. 如果一个依赖库很庞大并且你只是使用其中一小部分的功能，你应该考虑一些其他**更精简**的选择 (比如可以依赖 [proguard](http://developer.android.com/tools/help/proguard.html));
29. 不要使用你不需要的模块。如果_那个_模块并不需要常常修改，考虑从零开始构建的时间是很重要的(使用 **CI** 构建就是一个很好的例子)，或者检查之前那个单独构建的模块是否是最新的，相比起来只是简单的装载那些二进制的 `.jar/.aar` 依赖库，它能带来 4 倍的提升;
30. [开始考虑用 SVG 替换 PNG](http://developer.android.com/tools/help/vector-asset-studio.html);
31. 如果你只需要改变一个地方(例如，**_AppLogger.d(“message”)_** 能包含 **_Log.d(TAG, message)_** 并且之后发现 [**_Timber.d(message)_**](https://github.com/JakeWharton/timber) 会是一个更好的解决方案)，为依赖库制作抽象的类会让切换到新库变得很容易;
32. 监视连接状态和连接的种类 (**在 WIFI 连接状态下，是不是有更多的数据更新**?);
33. 监视电源和电池 (**在充电的过程中，是不是有更多的数据更新？ 当电池电量低的时候，更新过程会不会被暂缓**);
34. 如果一个笑话是需要解释才能明白的话，那肯定是一个失败的笑话，用户界面亦是如此;
35.  [测试能带来性能的提升: 慢工出细活（并且保证内容的正确性），之后验证优化，这不会影响任何测试内容。](https://twitter.com/danlew42/status/677151453476032512)













如果你对上面的建议有任何问题，请通过 tweet @[cesarmcferreira](https://twitter.com/cesarmcferreira) 告诉我!




