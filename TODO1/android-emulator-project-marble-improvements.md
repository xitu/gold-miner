> * 原文地址：[Android Emulator: Project Marble Improvements](https://medium.com/androiddevelopers/android-emulator-project-marble-improvements-1175a934941e)
> * 原文作者：[Android Developers](https://medium.com/@AndroidDev)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/android-emulator-project-marble-improvements.md](https://github.com/xitu/gold-miner/blob/master/TODO1/android-emulator-project-marble-improvements.md)
> * 译者：[qiuyuezhong](https://github.com/qiuyuezhong)

# Android 模拟器：Project Marble 中的改进

![](https://cdn-images-1.medium.com/max/3200/0*YXbEJNUcY1n4S5N1)

这是 Android Studio 团队一系列博客文章中第三篇，深入探讨了 [Project Marble](https://android-developers.googleblog.com/2019/01/android-studio-33.html) 中的细节和幕后情况。本文是由模拟器团队的 Sam Lin（产品经理），Lingfeng Yang（技术主管）和 Bo Hu（技术主管）撰写的。

今天我们很高兴地向您介绍我们在 Project Marble 期间在 Android 模拟器上取得的最新进展。我们的核心目标之一是使 Android 模拟器成为应用程序开发的必选设备。物理 Android 设备非常棒，但我们的目标是增加功能和性能，使您在开发和测试 Android 应用程序时更加高效。

我们听说很多应用程序开发者喜欢我们最近对模拟器所做的改进，从 2 秒的启动时间，GPU 图形加速，再到[屏幕快照](https://developer.android.com/studio/run/emulator#snapshots)。然而，我们也听说 Android 模拟器消耗了您开发电脑上的太多系统资源。为了解决这个问题，我们在 Project Marble 中创建了一个任务来优化 Android 模拟器的 CPU 使用率。在过去几个月的 Project Marble 中，在不违背原本设计原则的情况下，Android 模拟器的能效和绘制速度有了显著提升。在本文中，我们将介绍到目前为止在 [Canary Channel](https://developer.android.com/studio/preview/install-preview#change_your_update_channel) 上 Android Emulator 28.1 发布的一些进展。

## 在减少开销的同时保持原本设计原则

Android 模拟器的最大好处在于为开发者提供了一种可扩展的方法，通过各种设备配置和屏幕分辨率来测试最新 Android API，而无需为每个配置购买物理设备。因此，在 Android 模拟器上测试应用程序应该尽可能贴近在物理设备上的测试，并同时保持虚拟设备的优势。

为了支持最新的系统映像，我们特意设计一个尽可能接近物理设备的 Android 模拟器，而不只是一个仿真器，这种方法可以确保 API 的正确性以及 Android 系统行为和交互的高保真度。当一个新的 Android 版本推出时，我们只需要确保我们的硬件抽象层（HALs）和内核与模拟器和新的系统映像兼容，而不需要从头开始为新的 Android 版本重新实现 Android API 中的所有更改。这种体系结构最终大大地加快了模拟器采用新的系统映像的速度。

然而，这种完整的系统模拟方法在 CPU 周期和内存访问上的开销都会增加。相比之下，基于模拟器的方法在主机系统上包装类似的 API，开销可能会更低。因此，我们的挑战在于，在降低 CPU 和内存开销的同时，保持完整系统模拟的准确性和维护优势。

## 对 Android 模拟器架构的研究

Android 模拟器在称为 Android 虚拟设备（AVD）的虚拟机上运行 Android 操作系统。AVD 包含了完整的 [Android 软件栈](https://source.android.com/devices/architecture)，运行时就像在物理设备上一样。总体架构图如下。

![**Android Emulator System Architecture**](https://cdn-images-1.medium.com/max/2262/0*H8Y7VKtH1vckbx5M)

由于整个 Android 操作系统的运行和主机的操作系统完全分离，因此运行 Android 模拟器可能会导致主机机器上的后台活动，即便没有任何输入。在进行了一些技术调查之后发现，当 AVD 空闲时，如下一些任务是 CPU 周期的主要消耗者：

* Google Play Store —— 当有新版本时，应用程序会自动更新。
* 后台服务 —— 当它认为设备在充电时，一些响应式的服务会使 CPU 使用率保持在较高水平。
* 动画 —— 例如[实况壁纸](https://android-developers.googleblog.com/2010/02/live-wallpapers.html)

对于这些领域我们进行了更深入的技术研究并找到了以下 5 个解决方案来优化 Android 模拟器。

1. 默认电池模式
2. 模拟器的暂停/恢复
3. 减少绘制调用的开销
4. 减少 macOS 上主循环的 IO 开销
5. Headless 构建

### 改进 #1 —— 默认电池模式

之前，Android 模拟器把 AVD 的电池模式设置为[充电模式](https://developer.android.com/reference/android/os/BatteryManager.html#BATTERY_STATUS_CHARGING)。经过深思熟虑的讨论和数据分析，我们得出结论，最好将 AVD 默认设置为电池模式。因为大多数 Android framework，服务和应用程序都经过了优化以节省电池寿命，这些优化都只在设备（物理设备或虚拟设备）认为它在使用电池而不是充电时才开始。

然而，仅仅默认 AVD 使用电池还不够。因为处于电池模式会导致屏幕在一段时间之后自动关闭。这对于在笔记本电脑或者台式机上使用 Android 模拟器的用户来说会有一点困惑，因为他们期望应用程序不会随机进入睡眠状态，需要被唤醒。为了防止这种情况，Android 模拟器将在每次冷启动完成时用 [ADB shell 命令](https://developer.android.com/reference/android/provider/Settings.System#SCREEN_OFF_TIMEOUT)将屏幕关闭的时间设置为最大值（~24 天）。

有了这些改变，Google Play Store 不会在电池模式再自动更新应用程序，避免了系统开销。然而，在切回充电模式之后，[应用程序的自动升级]  (https://support.google.com/googleplay/answer/113412?hl=en) 仍然可以被触发。这实际上让开发者可以控制何时自动更新应用程序。这可以防止对关键用例的干扰，比如当用户只想构建和测试单个应用程序的时候。下表比较了电池模式和充电模式下的 CPU 使用状况：

![**AVD CPU Usage: Auto-update app vs Idle**](https://cdn-images-1.medium.com/max/2444/0*gt4ov7MOkjcvhFYP)

### 改进 #2 —— 模拟器暂停/恢复

在很多情况下，你可能需要立即保证模拟器不会在关键任务期间（比如编辑/生成/部署）在后台占用 CPU 周期。为了解决这个问题，我们正在研究一个控制台命令和接口，用于完全暂停模拟器 CPU 的使用。这可以通过以下控制台命令显示暂停/恢复 AVD 来完成。

![**Android Emulator: Pause command line options**](https://cdn-images-1.medium.com/max/2808/1*Q77jcfo5jiRqRwhW2l2NgA.png)

这里的挑战是如何协调 Android Studio 和 Android 模拟器状态的改变。所以当在部署应用程序时，我们会自动恢复模拟器。我们还在研究这个机制，很高兴听到您的[想法和反馈](https://source.android.com/setup/contribute/report-bugs#developer-tools)。

### 改进 #3 —— 减少绘制调用的开销

我们还对 Android 模拟器的引擎进行了修改，使其更高效的绘图，从而在测试屏幕上有很多对象的图形密集型应用程序时获得更流畅的用户体验。比如，模拟器 v28.1.10 在[GPU 模拟压力测试应用程序](https://github.com/google/gpu-emulation-stress-test)上的绘制速度比 v28.0.23 提升了 8%。我们还在 Android Q 上进行进一步的优化，并将在 [Android Q preview](https://developer.android.com/preview) 期间共享其他更新。

![**Emulator OpenGL ES FPS: 28.0.23 vs 28.1.10**](https://cdn-images-1.medium.com/max/3200/0*9SgQAdVAIYAHR_eD)

### 改进 #4 —— 减少 macOS 上主循环的 IO 开销

完整的系统模拟器必须维护一些方法，以通知虚拟操作系统磁盘和网络上的 I/O 已经完成。Android 模拟器基于 [QEMU](https://www.qemu.org/)，使用主循环和 IO 线程来做到这一点。这在 Linux 和 Windows 上的开销都比较低。然而在 macOS 上我们看到，由于使用了 select() 系统调用，主循环的 CPU 使用率更高。这通常没有高效的实现方式。macOS 提供了一个低开销的方式来等待 I/O：[kqueue](https://developer.apple.com/library/archive/documentation/System/Conceptual/ManPages_iPhoneOS/man2/kqueue.2.html)。我们发现当前基于 select() 主 I/O 循环，可以替换为基于 [kqueue](https://developer.apple.com/library/archive/documentation/System/Conceptual/ManPages_iPhoneOS/man2/kqueue.2.html) 的主 I/O 循环。这大幅降低了主循环中的 CPU 使用率，从 10% 降低到 3%。由于这并不能说明所有空闲 CPU 使用率的情况，下面的图表没有显示太多的变化。然而，这种差异仍然是可以观察到的。

![AVD Idle CPU Usage — Emulator 28.0.23 vs 28.1.10](https://cdn-images-1.medium.com/max/2444/0*O_gCbgpsbOadRFV9)

### 改进 #5 —— Headless 构建

对于那些在 Android 应用程序构建中使用持续集成系统的用户，我们也在这方面进行了性能改进。通过关闭 Android 模拟器的用户界面，您可以使用新的模拟器 Headless 模式。这种新的模式在后台运行测试，并使用更少的内存。它大概还需要 100MB，主要是因为我们在用户界面使用的 [Qt](https://www.qt.io/) 库没有加载。当不需要用户界面和交互时，这也是运行自动化测试的一个好选择。增量可以类似如下那样启动两个模拟器 AVD 实例来测量。注意，命令行示范显式地指定主机的 GPU 模式，以确保在相同的条件下进行比较。

![**Android Emulator: Headless emulator command line option**](https://cdn-images-1.medium.com/max/2808/1*qhp25FXwP_K4gE8ggOQQbQ.png)

![**AVD Idle Memory Usage — emulator vs emulator-headless**](https://cdn-images-1.medium.com/max/2402/0*DZ20pZNiqKnaydzW)

### 接下来

要使用本文中介绍的性能和资源优化，请在 [Canary Channel](https://developer.android.com/studio/preview/install-preview#change_your_update_channel) 下载 Android Emulator 28.1。我们很高兴能与您分享这次提前的进展，但我们肯定还没有完成。我们今天邀请您尝试 Android Emulator 的最新更新，并向我们发送您的[反馈](https://developer.android.com/studio/report-bugs.html#emulator-bugs)。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
