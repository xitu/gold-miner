> * 原文地址：[Double Stuffed Security in Android Oreo](https://android-developers.googleblog.com/2017/12/double-stuffed-security-in-android-oreo.html)
> * 原文作者：[Gian G Spicuzza](https://android-developers.googleblog.com/2017/12/double-stuffed-security-in-android-oreo.html)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/double-stuffed-security-in-android-oreo.md](https://github.com/xitu/gold-miner/blob/master/TODO/double-stuffed-security-in-android-oreo.md)
> * 译者：[一只胖蜗牛](https://github.com/XPGSnail)
> * 校对者：[corresponding](https://github.com/corresponding)，[SumiMakito](https://github.com/SumiMakito)

# [像奥利奥一样的双重安全措施，尽在 Android Oreo](https://android-developers.googleblog.com/2017/12/double-stuffed-security-in-android-oreo.html)

由 Android 安全团队的 Gian G Spicuzza 发表

Android Oreo 中包含很多安全性提升的更新。几个月以来，我们讨论了如何增强 Android 平台及应用的安全性: 从[提供更安全的获取应用渠道](https://android-developers.googleblog.com/2017/08/making-it-safer-to-get-apps-on-android-o.html)，移除[不安全的网络协议](https://android-developers.googleblog.com/2017/04/android-o-to-drop-insecure-tls-version.html)，提供更多[用户控制符](https://android-developers.googleblog.com/2017/04/changes-to-device-identifiers-in.html)，[加固内核](https://android-developers.googleblog.com/2017/08/hardening-kernel-in-android-oreo.html)，[使 Android 更易于更新](https://android-developers.googleblog.com/2017/07/shut-hal-up.html),直到[加倍 Android 安全奖励奖励项目的支出](https://android-developers.googleblog.com/2017/06/2017-android-security-rewards.html)。如今 Oreo 终于正式和大家见面了，让我们回顾下这其中的改进。  

### 扩大硬件安全支持

Android 早已支持[开机验证模式(Verified Boot)](https://source.android.com/security/verifiedboot/)，旨在防止设备软件被篡改的情况下启动。在 Android Oreo 中，我们随着[ Project Treble ](https://source.android.com/devices/architecture/treble)一同运行的验证开机模式(Verified Boot)，称之为 Android 验证开机模式2.0(Android Verified Boot 2.0)(AVB)。AVB 有一些使得更新更加容易、安全的功能，例如通用的分区尾部（AVB 中位于文件系统分区尾部的结构）以及回滚保护。回滚保护旨在保护 OS 降级的设备，防止降级到到低版本的系统后被人攻击。为此，设备将通过专用的硬件保存系统版本信息或使用可信执行环境（Trusted Execution Environment, TEE）对数据进行签名。 Pixel 2 和 Pixel 2 XL 自带这种保护，并且我们建议所有设备制造商将这个功能添加到他们的新设备中。

Oreo 还包括新的[原始设备制造商锁(OEM Lock)硬件抽象层(HAL)](https://android-review.googlesource.com/#/c/platform/hardware/interfaces/+/527086/-1..1/oemlock/1.0/IOemLock.hal)使得设备制造商能够更加灵活的保护设备，无论设备处于锁定、解锁或者可解锁状态。例如，新的 Pixel 设备通过硬件抽象层命令向启动引导程序（bootloader）传递命令。启动引导装载程序会在下次开机分析这些命令并检查安全存储于有重放保护的内存区（Replay Protected Memory Block, RPMB）中对锁更改的信息是否合法。如果你的设备被偷了，这些保护措施旨在保护你的设备被重置，从而保护你的数据安全。新的硬件抽象层(HAL)甚至支持将锁移动到专用的硬件中。

谈到硬件，我们添加了防伪硬件支持，例如在每一个 Piexl 2 和 Piexl 2 XL 设备中内嵌的[安全模块](https://android-developers.googleblog.com/2017/11/how-pixel-2s-security-module-delivers.html)。这种物理芯片可以防止很多软硬件攻击，并且还抵抗物理渗透攻击. 安全模块防止推导设备密码及限制解锁尝试的频率，使得很多攻击由于时间限制而失效。

新的 Pixel 设备配有特殊的安全模块，所有搭载Android Oreo 的[谷歌移动服务(GMS)](https://www.android.com/gms/)的设备也需要实现[密钥验证](https://android-developers.googleblog.com/2017/09/keystore-key-attestation.html)。这提供了一种强[验证标识符](https://source.android.com/security/keystore/attestation#id-attestation)机制，例如硬件标识符。

我们也为企业管理设备添加了新的功能。当配置文件或者公司管理员远程锁定配置文件时，加密密钥会从内存（RAM）中移除.这有助于保护企业数据的安全。

### 平台加固及进程隔离

作为[ Project Treble ](https://android-developers.googleblog.com/2017/05/here-comes-treble-modular-base-for.html)的一部分，为了使设备厂商可以更简单、低成本地更新，我们对 Android 的框架也进行了重构。将平台和供应商代码分离的目的也是为了提高安全性，根据[最小特权原则](https://en.wikipedia.org/wiki/Principle_of_least_privilege)，这些硬件抽象层(HALs)运行在[自己的沙盒中](https://android-developers.googleblog.com/2017/07/shut-hal-up.html)，只对有权限的驱动设备开放。

追随着Android Nougat 中[媒体堆栈加固](https://android-developers.googleblog.com/2016/05/hardening-media-stack.html)，我们在Android Oreeo 媒体框架中移除了许多直接访问硬件的模块，从而创造了更好的隔离环境。此外，此外我们启用了所有媒体组件中的控制流完整性（Control Flow Integrity, CFI）保护。这种缺陷可以通过破坏应用的正常控制流，从而利用这种特权执行恶意的活动。 CFI 拥有健全的安全验证机制，不允许随意更改原来编译后二进制文件的控制流程图，也使得这样的攻击难以执行。

除了这些架构改变和CFI以外，Android Oreo 还带来了其他平台安全性相关的提升：

* **[Seccomp（Secure computing mode, 安全计算模式）过滤](https://android-developers.googleblog.com/2017/07/seccomp-filter-in-android-o.html)**: 一些系统层的调用不再对应用开放，从而减少潜在损害应用途径。
* **[加固用户拷贝](https://lwn.net/Articles/695991/)**: 一个最新的 Android [安全漏洞掉渣](https://events.linuxfoundation.org/sites/events/files/slides/Android-%20protecting%20the%20kernel.pdf)显示：在内核漏洞中，失效的或者无边界检查情况约占 45%。在 Android 内核 3.18 及以上版本中，我们新增了一个边界检查的补丁，使得利用这个漏洞变得更困难，同时还同帮助开发者在他们代码中查找问题并修复问题。
* **Privileged Access Never(PAN)仿真**: 同时针对 3.18 以上的内核新增了补丁，这个功能禁止内核直接访问用户空间，同时确保开发者利用加固后的方式开访问用户空间。
* **内核地址空间布局随机化(KASLR)**：虽然Android已经支持地址空间布局随机化（ASLR）好多年了，我们仍针对 Android 内核 4.4 及以上版本提供了内核地址空间布局随机化（KASLR）补丁减少风险。内核地址空间布局随机化（KASLR）将在每次设备启动加载内核代码时随机分配地址，使得代码复用攻击，尤其是远程攻击更加难以执行。

### 应用程序安全性及设备标示变更

[Android 即时运行应用](https://developer.android.com/topic/instant-apps/index.html)运行在一个受限制的沙盒中，因此限制了部分权限和功能，例如访问设备内应用列表或者着明文传递数据。虽然是从 Android Oreo 才发布,但是即时运行应用支持在 [Android Lollipop](https://www.android.com/versions/lollipop-5-0/) 及以上版本的设备上运行。

为了更安全的处理不可信内容，我们通过将渲染引擎放到另一个进程中并将它运行在一个独立的资源受限的沙盒中来[隔离 WebView](https://android-developers.googleblog.com/2017/06/whats-new-in-webview-security.html)。此外，WebView 还支持[安全浏览](https://safebrowsing.google.com/)，从而保护使用者浏览含有潜在危险的网站。

最后，我们针对[设备标识做了重大的改变](https://android-developers.googleblog.com/2017/04/changes-to-device-identifiers-in.html)开放给用户更多的控制权，包括：

* 静态的 Android ID 和 Widevine 将变为基于应用变化的值，这有助于限制设备中无法重置的标识符的使用。
* 依照 [IETF RFC 7844](https://tools.ietf.org/html/rfc7844#section-3.7)，现在 `net.hostname` 将为空且 DHCP 客户端也将不再发送主机名称（hostname)。
* 对于需要设备标识符的应用，我们新增了一个 `Build.getSerial() API` 并且通过权限对其进行保护。
* 我们与安全研究人员一起 <sup>1</sup> 在各种芯片组固件中的 Wi-Fi 扫描环节中新增一个健全的MAC地址随机化功能.

Android Oreo 带来远不止这些改进，还有[更多](https://www.android.com/versions/oreo-8-0/)。一如既往，如果您有关于 Android 的反馈或是改进建议。欢迎发送邮件至 security@android.com。

---

1:Glenn Wilkinson 以及在英国 SensePost 的团队、Célestin Matte、Mathieu Cunche：里昂大学，国立里昂应用科学学院，CITI 实验室，Mathy Vanhoef，KU Leuven

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
