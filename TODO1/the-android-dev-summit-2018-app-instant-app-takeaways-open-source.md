> * 原文地址：[The Android Dev Summit 2018 app (instant app takeaways + open source)](https://medium.com/androiddevelopers/the-android-dev-summit-2018-app-instant-app-takeaways-open-source-e5b590f78f38)
> * 原文作者：[Jose Alcérreca](https://medium.com/@JoseAlcerreca)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/the-android-dev-summit-2018-app-instant-app-takeaways-open-source.md](https://github.com/xitu/gold-miner/blob/master/TODO1/the-android-dev-summit-2018-app-instant-app-takeaways-open-source.md)
> * 译者：[DevMcryYu](https://github.com/devmcryyu)
> * 校对者：[ScDadaguo](https://github.com/ScDadaguo)

# Android Dev Summit 2018 应用（instant app 的总结 + 开源）

创建 Android Dev Summit 应用并发布具有即时体验的应用程序包的总结。

11 月 7 日和 8 日，在加利福尼亚州山景城的 [Android Dev Summit](https://developer.android.com/dev-summit/) 举办时，会议使用的应用程序已经发布给所有与会者及远程观众。

![](https://cdn-images-1.medium.com/max/2000/1*F12l55pOjn7vPiXBrbklCg.png)

**Android Dev Summit 应用**

### 从 IO-Sched 到 ADS-Sched

The Android Dev Summit 应用（[adssched](https://github.com/google/iosched/tree/adssched)）基于 Google I/O 应用（iosched）开发，这是一个[在 Github 上可用的](https://github.com/google/iosched/)开源项目。移除了一些不需要的功能，比如：

*   **预约** [[main commit](https://github.com/google/iosched/commit/65a5eb2d61bdd7507148db4d3b32a34f85a9e422)]。此功能与应用的每一层深度耦合，严重增加了数据库的复杂度。在 I/O 应用中，我们使用了一个 endpoint 来指明一个用户是否是注册的与会者。未注册的与会者具有不同的用户体验。在 adssched 中，所有的用户都是相同的，这使得业务逻辑更加简洁。
*   **地图** [[commit](https://github.com/google/iosched/commit/36c1e942379fcfac9181dcac58db434ebcdbb532)]。会议只有两条路线，因此不需要地图。这在底部导航中释放了位置，让我们能够将议程提升到醒目的位置。

我们还添加了一些新功能：

*   **通知** [[commit](https://github.com/google/iosched/commit/a13dcdae7e2bee6c287549ef4674a84b78f2218c)]。使用 AlarmManager 在已加星标的项目开始时间 5 分钟前设置提醒。
*   **即时应用** [[commit](https://github.com/google/iosched/commit/07092236185425bb5e10c5b5629377ed9dcc6e10)]。从一个 Android Studio 项目构建一个 instant app 非常容易。我们使用 flavor 来生成两个不同的 bundle（installed
/instant）这是目前的要求，但是在将来你能够上传单个 bundle。

### 即时应用统计信息

这是我们第一次发布会议应用程序作为即时应用，我们很好奇有多少人会使用这个模型。

![](https://cdn-images-1.medium.com/max/1600/1*neTrUNi4qRnDiTPMmEEfeQ.png)

**安装的应用程序与即时体验的应用程序使用情况对比 [10 月 30 日至 11 月 15 日]**

大约 25% 的即时用户（占总用户的 15%）**跳转到已安装的应用**：

![](https://cdn-images-1.medium.com/max/1600/1*KomG5B1oxInVkNwXPZkc4w.png)

**即时体验使用 + 已安装的应用使用情况**

#### 采纳：

*   在会议召开一周前[公布](https://android-developers.googleblog.com/2018/10/the-android-dev-summit-app-is-live-get.html)应用程序时，我们看到大约 **40% 的用户通过即时应用体验程序**。即时应用可以通过在搜索结果和 Play 上的**立即尝试**按钮访问。

![](https://cdn-images-1.medium.com/max/1600/1*MLOghqlxxrXtgc38JTcW6A.png)

[“立即尝试”按钮](https://play.google.com/store/apps/details?id=com.google.samples.apps.adssched)可提供即时体验

*   在会议期间，该数字**下降到 30%**，可能是由于通知的可用性。
*   同样有趣的时，会议结束后安装次数减少，即时应用用户数量增加。用户似乎发现了通知时两者之间的唯一区别。

在发布即时应用之前，请按照[本指南设置分析](https://developer.android.com/topic/google-play-instant/guides/analytics)，并为即时安装流程添加事件（遗憾的是我们没有！）。

### 添加即时体验后的分析

运作良好的：

*   **认证**机制不需要修改。[Firebase Auth](https://firebase.google.com/docs/auth/) 和 Google Smart Lock for Passwords 负责一切，因此即时应用登录体验非常流畅。
*   用户在 Android 手机上**搜索**峰会即可找到即时应用。

![](https://cdn-images-1.medium.com/max/1600/1*YbmaVwK6kxnXdyf8dJ8C2g.png)

**Google 搜索结果显示峰会的即时应用**

*   从即时应用到**安装应用程序的流程**由 Google Play 无缝处理。

![](https://cdn-images-1.medium.com/max/1600/1*79wg9dJRlV4ulAaTkp4f1Q.gif)

**Google Play 从即时应用到安装应用的流程**

可以改进的地方：

*   **问题** activity-alias 标签阻止了应用程序在即时应用启动后出现在启动器上。它出现在**最近**页面上，但这[远非理想中的效果](https://twitter.com/lehtimaeki/status/1058077669076729857)。由于时间限制，我们未能及时发布[错误修复程序](https://github.com/google/iosched/commit/d5f1fdbfdb9d6c49a256fdaad52a9ea73392c71e)。
*   即时应用无法直接提供**通知**功能。但你可以通过 Play 服务发送推送通知(目前处于[测试阶段](https://docs.google.com/forms/d/e/1FAIpQLSeu5yabEoJNXfTIugoqqhAqI6HMu2ebpLhyHuWZ2D85s4rRLw/viewform)）。但这需要后端代码的支持，所以我们决定从即时应用转化到安装应用后才可展示通知。这也是两者间的唯一区别。

### 开源 adssched

IOSched 原意始终是一个示例（从包名可以看出）用以学习目的以及作为其他会议应用程序的基础。但是，I/O 具有的某些要求使得其相对常规会议应用的需求复杂很多（例如预定系统）。

Android Dev Summit 的规模和要求与其他会议类似，**因此更适合 Fork** 并重用。新版本仅需要 Firebase 项目（我们建议使用第二个暂存项目，链接到 Debug 构建类型）和一个托管[会议 JSON 数据文件](https://github.com/google/iosched/blob/adssched/shared/src/main/resources/conference_data_2018.json)，它的格式很简单。

➡ [https://github.com/google/iosched/tree/adssched](https://github.com/google/iosched/tree/adssched)

如果你需要我们帮助为会议创建分支，随时可以在 [Github 项目上](https://github.com/google/iosched)打开一个问题。

* * *

这个即时应用实验取得了成功并**带来了非常有趣的数据**，但我们的需求非常简单，因此完整的应用也足够小。我们只有一个即时入口点，用户群体也有限。我们等不及想要看看开发人员会在哪些场景使用即时应用程序以及社区会用 adssched 构建什么新东西了！

**致谢：[Ben Weiss](https://medium.com/@keyboardsurfer)（adssched 即时应用功能的所有者），[Nick Butcher](https://medium.com/@crafty)（魔法 GIF 的创造者）**

感谢 [Nick Butcher](https://medium.com/@crafty?source=post_page) 和 [Ben Weiss](https://medium.com/@keyboardsurfer?source=post_page)。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
