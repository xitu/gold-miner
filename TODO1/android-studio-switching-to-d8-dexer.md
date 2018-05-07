> * 原文地址：[Android Studio switching to D8 dexer](https://android-developers.googleblog.com/2018/04/android-studio-switching-to-d8-dexer.html)
> * 原文作者：[Jeffrey van Gogh](https://android-developers.googleblog.com/2018/04/android-studio-switching-to-d8-dexer.html)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/android-studio-switching-to-d8-dexer.md](https://github.com/xitu/gold-miner/blob/master/TODO1/android-studio-switching-to-d8-dexer.md)
> * 译者：
> * 校对者：

# Android Studio switching to D8 dexer

Faster, smarter app compilation is always a goal for the Android tools teams. That's why we previously announced [D8](https://android-developers.googleblog.com/2017/08/next-generation-dex-compiler-now-in.html), a next-generation dex compiler. D8 runs faster and produces smaller .dex files with equivalent or better runtime performance when compared to the historic compiler - DX.

We recently announced that D8 has become the default compiler in Android Studio 3.1. If you haven't previously tried D8, we hope that you notice better, faster dex compilation as you make the switch.

D8 was first shipped in Android Studio 3.0 as an opt-in feature. In addition to our own rigorous testing, we've now seen it perform well in a wide variety of apps. As a result, we're confident that D8 will work well for everyone who starts using it in 3.1. However, if you do have issues, you can always revert to DX for now via this setting in your project's gradle.properties file:

```
android.enableD8=false
```

If you do encounter something that causes you to disable D8, please [let us know](https://issuetracker.google.com/issues/new?component=192708&template=840533)!

**Next Steps**

Our goal is to ensure that everyone has access to a fast, correct dex compiler. So to avoid risking regressions for any of our users, we'll be deprecating DX in three phases

The first phase is intended to prevent prematurely deprecating DX. During this phase, DX will remain available in studio. We'll fix critical issues in it, but there won't be new features. This phase will last for at least six months, during which we'll evaluate any open D8 bugs to decide if there are regressions which would prevent some users from replacing DX with D8\. The first phase won't end until the team addresses all migration blockers. We'll be paying extra attention to the bug tracker during this window, so If you encounter any of these regressions, please [file an issue](https://issuetracker.google.com/issues/new?component=192708&template=840533).

Once we've seen a six month window without major regressions from DX to D8, we'll enter the second phase. This phase will last for a year, and is intended to ensure that even complex projects have lots of time to migrate. During this phase, we'll keep DX available, but we'll treat it as fully deprecated; we won't be fixing any issues.

During the third and final phase, DX will be removed from Android Studio. At this point, you'll need to use a legacy version of the Android Gradle Plugin in order to continue to build with DX.


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
