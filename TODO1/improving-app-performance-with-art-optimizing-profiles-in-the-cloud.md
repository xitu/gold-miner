> * 原文地址：[Improving app performance with ART optimizing profiles in the cloud](https://android-developers.googleblog.com/2019/04/improving-app-performance-with-art.html)
> * 原文作者：[Calin Juravle](https://android-developers.googleblog.com/2019/04/improving-app-performance-with-art.html)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/improving-app-performance-with-art-optimizing-profiles-in-the-cloud.md](https://github.com/xitu/gold-miner/blob/master/TODO1/improving-app-performance-with-art-optimizing-profiles-in-the-cloud.md)
> * 译者：[nanjingboy](https://github.com/nanjingboy)
> * 校对者：[phxnirvana](https://github.com/phxnirvana), [qiuyuezhong](https://github.com/qiuyuezhong)

# 通过 Play Cloud 的 ART 优化配置提升应用性能

在 Android Pie 中，我们在 **[Play Cloud 中推出了 ART 优化配置](https://youtu.be/Yi9-BqUxsno?list=PLWz5rJ2EKKc9Gq6FEnSXClhYkWAStbwlC&t=985)**，这是一项新的优化特性，它大大提高了新安装或更新应用后的启动时间。平均而言，在不同设备上，我们观测到应用启动时间减少了 15%（冷启动）。一些明星案例甚至减少了 30% 以上。这其中最重要的一点是用户可以免费使用该特性，而无需用户或开发者的任何额外操作！

![来源：Google 内部数据](https://2.bp.blogspot.com/-J__2yBAq9SA/XJ6pHDtWtJI/AAAAAAAAHXw/xOQySRneEdQcfgIMXRsZVErzXN1y9yJgwCLcBGAs/s1600/image3.png)

## Play Cloud 的 ART 优化配置

该特性建立在由 [Android 7.0 Nougat](https://www.youtube.com/watch?v=fwMM6g7wpQ8) 引入的 [Profile Guided Optimization](https://source.android.com/devices/tech/dalvik/jit-compiler)（PGO）基础之上。PGO 允许 Android Runtime 通过构建应用中热门代码的配置，并集中优化配置来提升应用性能。这可以带来巨大的改进，同时减少完全编译的应用在传统内存及存储上的影响。然而，它依赖于设备在空闲维护模式下根据这些代码配置来优化应用，这意味着用户可能需要几天时间才能看到这些好处 — 这是我们旨在改进的。

![来源：Google 内部数据](https://2.bp.blogspot.com/-6_ScCr79y7g/XJ6pSVfm7zI/AAAAAAAAHX0/PCTBWrbT4e87__cjtS07gE7eZetNvnQ-QCLcBGAs/s1600/image1.png)

**Play Cloud 的 ART 优化配置**利用 Android Play 的强大功能，在安装/更新时带来所有的 PGO 好处：大多数用户无需等待即可获得出色的性能！

这个想法依赖于两个关键的观测结果：

1. 应用通常在众多用户和设备之间具有许多常用的代码路径（热门代码），例如在启动或关键用户路径期间使用的类。这通常可以通过聚合几百个数据点来发现。
2. 应用开发者通常会逐步推出他们的应用，从 [alpha/beta 渠道](https://support.google.com/googleplay/android-developer/answer/3131213?hl=en)开始，然后扩展到更广泛的受众。即使没有 alpha/beta 设置，用户通常也会将应用升级到新版本。

这意味着我们可以使用应用的首次部署来引导其他用户的性能。ART 分析应用代码的哪些部分值得在初始设备上进行优化，然后将数据上传到 Play Cloud，后者将构建核心聚合代码配置文件（包含与所有设备相关的信息）。一旦有足够的信息，代码配置就会发布并与应用的 APK 一起安装。

在设备上代码配置作为种子，在安装时实现有效的配置来引导优化。这些优化有助于改善[冷启动时间](https://developer.android.com/topic/performance/vitals/launch-time#cold)以及稳定性能状态，所有这些都无需 app 开发者编写任何代码。

![](https://4.bp.blogspot.com/-YZvK3UU7D20/XJ6pZ21iv4I/AAAAAAAAHX8/9dOUqVkAqAwpS7cLu4GBUxS1NbjhOQQ3gCLcBGAs/s1600/image4.png)

### 第一步：构建代码配置

其中一个主要目标是尽可能快地从聚合及匿名数据中构建高质量、稳定的代码配置（以最大限度地增加可受益的用户数量），同时也需要确保我们有足够的数据来正确地优化应用的性能。采样过多的数据在安装时会占用更多带宽和时间。此外，我们构建代码配置的时间越长，获得好处的用户就越少。采样过少的数据，代码配置将没有足够的信息来确定适合优化的内容。

聚合的结果是我们所说的核心代码配置，它只包含有关每个设备随机会话样本中经常出现的代码的匿名数据。我们移除异常值以确保我们专注于对大多数用户而言十分重要的代码。

实验表明，在很短的时间内，最常用的代码路径可以非常快地被计算出来。这意味着我们可以有足够快的速度构建代码配置，以使大多数用户受益。

![来自 Google 应用的平均数据，来源：Google 内部数据](https://4.bp.blogspot.com/-ExYg7hPhU8E/XJ6pf1CSfRI/AAAAAAAAHYA/P-1tN7ehCoseEnK_lgHvfieX6bZmgh1XACLcBGAs/s1600/image5.png)

### 第二步：安装代码配置

在 Android 9.0 Pie 中，我们引入了一种新型安装工件：dex 元数据文件。类似于 APK，dex 元数据文件是常规的存档文件，它包含如何优化 APK 的数据 — 就像在 cloud 中构建的代码核心配置一样。它们之间一个关键的区别是 dex 元数据仅由平台和应用商店管理，并且对开发者来说是不直接可见。

还有对 [App Bundles / Google Play 动态分发](https://developer.android.com/platform/technology/app-bundle/)的内建支持：无需任何开发者干预，所有应用的功能拆分都经过优化。

![](https://2.bp.blogspot.com/-mBErPA5xD0w/XJ6ppc6ye7I/AAAAAAAAHYE/kP_xVzVtdjY3Grrr7fHM3Oznde-s7a4jwCLcBGAs/s1600/image6.png)

### 第三步：使用代码配置来优化性能

要搞明白这些代码配置究竟如何实现更好的性能，我们需要查看它们的结构。代码配置包含以下信息：

* 启动期间加载的类
* 运行时被认为值得优化的热门方法
* 代码的布局（比如，在启动或启动后执行的代码）

使用这些信息，我们使用了各种优化方法，其中以下三项提供了大部分优势：

* **[应用映像](https://youtu.be/fwMM6g7wpQ8?t=2145)**：我们使用启动类来创建需要预先填充的堆，其中类已预先初始化（称为应用映像）。当应用启动时，我们将映像直接映射到内存中，以便所有启动类都可以随时使用。

  * 这样做的好处是应用的执行可以节省周期，因为它无需再次执行，从而可以缩短启动时间。

* **代码预编译**：我们预先编译所有热门代码。当应用执行时，代码中最重要的部分已经过优化，可在本地直接执行。应用无需再等待 JIT 编译器启动。
  * 这样做的好处是代码被映射为干净的内存（与 JIT 的脏内存相比较），这提高了整体的内存的效率。内存压力下内核可以释放干净的内存，而脏内存则不能被释放，这减少了内核杀死应用的可能性。

* **更高效的 dex 布局**：我们根据配置抛出的方法信息重新组织 dex 字节码。dex 字节码布局如下所示：\[启动代码、启动后的代码、其余非配置代码\]。
  * 这样做的好处是可以更高效地将 dex 字节码加载到内存中：内存页具有更好的占用率，且由于所有内容都在一起，因此我们需要加载的更少，我们可以做更少的 I/O。

### 改进和统计

我们在去年年底向 Playstore 上的所有应用推出了 Play Cloud 的配置。

* 已超过 30,000 个应用有所改进
* 平均而言，冷启动在各种设备上的速度提高了 15%

  * 许多排名靠前的应用在所选设备上获得了 20%+（比如 Youtube）甚至 30%（比如 Google 搜索）的提升。

* 在 Android Pie 上安装的应用中有 90% 以上获得了优化
* 额外优化的安装时间几乎没有增加
* 适用于所有 Pie 设备。

一个非常有趣的观测结果是，平均而言，ART 优化了大约 20% 的应用方法（如果我们计算代码的实际大小，则更少）。而对于另一些应用，配置仅占代码量的 2%，而对于某些应用，该数字则高达 60%。

![来源：Google 内部数据](https://1.bp.blogspot.com/-179Ds6kuco4/XJ6pxOk4_oI/AAAAAAAAHYQ/WdjbULWQ9ZkaPjzBQKlkawPNU_xLnF4fgCLcBGAs/s1600/image2.png)

为什么这是一个十分重要的统计？这意味着 Runtime 没有看到太多的应用代码，因此没有对代码进行优化。虽然有很多代码不会被执行的例子（比如错误处理或向后兼容性代码），但这也可能是由于未使用的功能或不必要的代码所造成的。倾斜分布是一个强烈的信号，它表明后者可以在进一步优化中发挥重要作用（比如通过删除不需要的 dex 字节码来减少 APK 大小）。

### 未来发展

我们为 ART 优化配置所带来的改进感到兴奋，我们将会在未来更多地发展这一概念。构建每个应用的代码配置为更多应用改进提供了机会。开发者可以使用数据，以根据（功能与）终端用户的相关性及重要性来改进应用。使用配置中收集到的信息，可以重新组织或修剪代码，以提高效率。开发者可以使用 App Bundle，根据其使用情况来拆分功能，并避免向用户发送不必要的代码。我们已经看到应用启动时间的巨大改进，并希望看到配置所带来的其他额外好处，使开发者的生活更加轻松，同时为我们的用户提供更好的体验。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
