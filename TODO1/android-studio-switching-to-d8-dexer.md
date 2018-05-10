> * 原文地址：[Android Studio switching to D8 dexer](https://android-developers.googleblog.com/2018/04/android-studio-switching-to-d8-dexer.html)
> * 原文作者：[Jeffrey van Gogh](https://android-developers.googleblog.com/2018/04/android-studio-switching-to-d8-dexer.html)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/android-studio-switching-to-d8-dexer.md](https://github.com/xitu/gold-miner/blob/master/TODO1/android-studio-switching-to-d8-dexer.md)
> * 译者：[Starrier](https://github.com/Starriers)
> * 校对者：[wavezhang](https://github.com/wavezhang)

# Android Studio 切换至 D8 dexer

更快、更智能的应用程序编译始终是 Android 工具团队的目标。这就是我们之前宣布 [D8](https://android-developers.googleblog.com/2017/08/next-generation-dex-compiler-now-in.html) 作为下一代 dex 编译器的原因。与之前的编译器 —— DX 相比，D8 运行速度更快，生成的 .dex 文件更小且具有同等或更好的运行时性能。

我们最近已经宣布 D8 成为 Android Studio 3.1 的默认编译器。如果您之前没有尝试 D8，我们希望你在切换时关注到其 dex 编译器更快、更好的特性。 

D8 最初在 Android Studio 3.0 作为可选功能发布。除了我们自己的严格测试之外，我们现在已经看到它在各种各样的应用程序中表现优异。因此，我们相信 D8 将很好地适用于在 3.1 中开始使用它的每一位开发者。但是，如果确实有问题，可以通过设置项目的 gradle.properties 文件来暂时恢复至 DX：

```
android.enableD8=false
```

如果你确实遇到了需要禁用 D8 的情况，请[联系我们](https://issuetracker.google.com/issues/new?component=192708&template=840533)！

**下一步**

我们的目标是确保每个人都可以快速、正确地使用 dex 编译器。因此，为避免我们的任何用户面临回退的风险，我们将分三个阶段淘汰 DX

第一阶段旨在防止过早弃用 DX。在这个阶段，DX 将继续在 Stduio 中可用。我们将解决关键性问题，但不会添加新功能。这个阶段将持续至少六个月，在此期间，我们将评估开发 D8 时产生的任何错误，以确定是否存在会阻止某些用户使用 D8 取代 DX 的回归。第一阶段在小组解决所有迁移滞后者之前不会结束。在此窗口中，我们将特别关注缺陷跟踪系统，因此如果存在任何问题，请[提 issue](https://issuetracker.google.com/issues/new?component=192708&template=840533)。

一旦我们看到六个月的时间窗口没有从 DX 到 D8 的重大回归，我们将进入第二阶段。这一阶段将持续一年，旨在确保即使是复杂的项目也有大量的时间进行迁移。在这个阶段，我们会保证 DX 可用，但我们会将其视为已奔完全弃用；因此我们不会修复任何问题。

在第三阶段也就是最后阶段，DX 将从 Android Studio 中移除。此时，你需要使用旧版本的 Android Gradle 插件才可以继续使用 DX 进行构建。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
