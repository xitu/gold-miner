> * 原文地址：[Android Emulator : Project Marble Improvements](https://medium.com/androiddevelopers/android-emulator-project-marble-improvements-1175a934941e)
> * 原文作者：[Android Developers](https://medium.com/@AndroidDev)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/android-emulator-project-marble-improvements.md](https://github.com/xitu/gold-miner/blob/master/TODO1/android-emulator-project-marble-improvements.md)
> * 译者：
> * 校对者：

# Android Emulator : Project Marble Improvements

Posted by: Sam Lin, Product Manager, Android

![](https://cdn-images-1.medium.com/max/3200/0*YXbEJNUcY1n4S5N1)

This is the third in a series of blog posts by the Android Studio team diving into some of the details and behind the scenes of [Project Marble](https://android-developers.googleblog.com/2019/01/android-studio-33.html). The following post was written by Sam Lin (product manager), Lingfeng Yang (tech lead), and Bo Hu (tech lead) on the Emulator team.

Today we are excited to give you an update on the progress we have made in the Android Emulator during Project Marble. One of the core goals we have is to make the Android Emulator the go-to device for app development. Physical Android devices are great, but we aim to add features and performance that make you even more efficient when developing and testing your Android apps.

We have heard that many app developers like the recent improvements we have made to the emulator, from 2 second start time, GPU graphics acceleration, to [snapshots](https://developer.android.com/studio/run/emulator#snapshots). However, we have also heard that the Android Emulator consumes too many system resources on your development computer. To address this issue, we created an effort in Project Marble to optimize the CPU usage for the Android Emulator. Without deviating from the original design principles, we’ve made significant improvements to the power efficiency and draw rate of the Android Emulator over the last few months during Project Marble. In this post, we will shed some light on the progress we release so far in Android Emulator 28.1 on [the canary channel](https://developer.android.com/studio/preview/install-preview#change_your_update_channel).

## Preserving Design Principles While Reducing Overhead

The main benefit of the Android Emulator is to provide developers a scalable way to test the latest Android APIs across a variety of device configurations and screen resolutions, without buying physical devices for every configuration. As such, testing apps on Android Emulator should be as close as possible as testing on a physical device, while keeping the benefits of virtual devices.

In order to support the latest system images as soon as they are developed, we intentionally decided to design Android Emulator to be as close to a physical device as possible, as an emulator not a simulator. This approach ensures API correctness and high fidelity of Android system behaviors and interaction. When a new Android version comes out, we only need to ensure that our hardware abstraction layers (HALs) and kernel are compatible with the emulator and new system images, rather than have to re-implement all changes in the Android API for the new Android version from scratch ourselves. The net result of this architecture is that it greatly speeds up adoption of new system images for emulators.

However, such a full system emulation approach imposes overhead in both CPU cycles and memory access. In contrast, a simulator based approach would wrap analogous APIs on the host system with possibly less overhead. Therefore, our challenge is to preserve the accuracy and maintenance benefits of full system emulation while reducing the CPU and memory overhead.

## Investigation into the Android Emulator Architecture

The Android Emulator runs the Android operating system in a virtual machine called an Android Virtual Device (AVD). The AVD contains the full [Android software stack](https://source.android.com/devices/architecture), and it runs as if it were on a physical device. The high-level architecture diagram is as follows.

![**Android Emulator System Architecture**](https://cdn-images-1.medium.com/max/2262/0*H8Y7VKtH1vckbx5M)

Since the entire Android OS runs separately from the host OS, running the Android Emulator can cause background activity on the host’s machine even without any user input. After doing some technical investigation, the following tasks were some of the major consumers of CPU cycles when an AVD is idle:

* Google Play Store — app updates happen automatically when new versions are available.
* Background services — several on-demand services kept the CPU usage high when it assume the device was charging.
* Animations — such as [Live wallpapers](https://android-developers.googleblog.com/2010/02/live-wallpapers.html).

For these areas we did a deep set of technical investigations and landed on the following top five solutions to optimize the Android Emulator.

1. Battery mode by default
2. Emulator pause/resume
3. Draw call overhead reduction
4. macOS main loop IO overhead reduction
5. Headless Build

> Improvement #1 — Battery mode by default

Previously, the Android Emulator set the AVD’s battery charging mode to be on [AC power](https://developer.android.com/reference/android/os/BatteryManager.html#BATTERY_STATUS_CHARGING). After thoughtful discussions and data analysis, we concluded that it is best to set an AVD on battery mode by default. This is because most of the Android framework, services and apps are optimized to save battery life, and these optimizations only kick in if the device (either physical or virtual) thinks it’s using the battery rather than charging off AC power.

However, it’s not enough to just default the AVD to use battery. That’s because being on battery mode also causes the screen to turn off automatically after a period of time. This can be confusing to users who are using the emulator on laptops or desktop, where there is an expectation that apps don’t randomly go to sleep and need to be woken up. To avoid this condition, Android Emulator will set screen off timeout using an [ADB shell command](https://developer.android.com/reference/android/provider/Settings.System#SCREEN_OFF_TIMEOUT) to the maximum (~24 days) at each cold boot complete.

With these changes, Google Play Store will not update apps automatically on the battery mode, and avoid overloading the system. However, [the auto-updating of apps](https://support.google.com/googleplay/answer/113412?hl=en) can still be triggered by switching back to AC charging mode. This actually gives developers control on when to update apps automatically. Which can prevent interference in critical use cases, such as when the user simply wants to build and test a single app. The following chart compares CPU usage on battery versus on AC power:

![**AVD CPU Usage: Auto-update app vs Idle**](https://cdn-images-1.medium.com/max/2444/0*gt4ov7MOkjcvhFYP)

> Improvement #2 — Emulator pause/resume

In many cases, you may want an immediate guarantee that the emulator isn’t chewing up CPU cycles in the background during critical tasks such as the edit and build steps of the edit / build / deploy loop. To address this, we’re working on a console command and interface for pausing the emulator’s CPU usage completely. This can be accomplished by following console commands to pause/resume the AVD explicitly.

![**Android Emulator: Pause command line options**](https://cdn-images-1.medium.com/max/2808/1*Q77jcfo5jiRqRwhW2l2NgA.png)

The challenge here is how to coordinate this Android Emulator state change with Android Studio. So when an app deploy happens, we auto resume the emulator. We are still working on this mechanism, and happy to hear your [thoughts and feedback](https://source.android.com/setup/contribute/report-bugs#developer-tools).

> Improvement #3 — Draw call overhead reduction

We’ve also made changes in the Android Emulator engine that make it more efficient at drawing, which results in a smoother user experience when testing graphics-heavy apps with many objects on screen. For example, Emulator v28.1.10 draws 8% faster on [GPU emulation stress test app](https://github.com/google/gpu-emulation-stress-test) compared with that in v28.0.23. We are also working on further optimizations in Android Q, and will share additional updates during the [Android Q preview](https://developer.android.com/preview).

![**Emulator OpenGL ES FPS: 28.0.23 vs 28.1.10**](https://cdn-images-1.medium.com/max/3200/0*9SgQAdVAIYAHR_eD)

> Improvement #4 — macOS main loop IO overhead reduction

A full system emulator must maintain some kind of method to notify the virtual OS that I/O operations on disk & network complete. Android Emulator is based on [QEMU](https://www.qemu.org/), and uses a main loop and iothreads to accomplish this. It has low overhead on Linux and Windows. However on macOS, we have seen higher CPU usage of the main loop due to its usage of the select() system call. Which is often not implemented efficiently. macOS does provide a low overhead method to wait on I/O: [kqueue](https://developer.apple.com/library/archive/documentation/System/Conceptual/ManPages_iPhoneOS/man2/kqueue.2.html). We’ve found that the main I/O loop, that is currently based on select() can be replaced with a main I/O loop based on [kqueue](https://developer.apple.com/library/archive/documentation/System/Conceptual/ManPages_iPhoneOS/man2/kqueue.2.html). This greatly decreased the CPU usage of the main loop, from ~10% to ~3%. Since this does not account for all idle CPU usage, the chart (below) does not show much change. Nevertheless, the difference is still observable.

![AVD Idle CPU Usage — Emulator 28.0.23 vs 28.1.10](https://cdn-images-1.medium.com/max/2444/0*O_gCbgpsbOadRFV9)

> Improvement #5 — Headless Build

For those of you using continuous integration systems for your Android app builds, we also worked on performance improvements in this area as well. By turning off the user interface in the Android Emulator, you can use access a new emulator-headless mode. This new mode runs tests in the background and uses less memory. It also takes about 100MB less, mainly because the [Qt](https://www.qt.io/) libraries we use for the user interface are not loaded. This is also a good choice to run automated tests when UI and user interactions are not required. The delta can be measured by starting 2 Emulator AVD instances as follows. Note that, the command line example specifies host GPU mode explicitly to ensure the comparison is under the same conditions.

![**Android Emulator: Headless emulator command line option**](https://cdn-images-1.medium.com/max/2808/1*qhp25FXwP_K4gE8ggOQQbQ.png)

![**AVD Idle Memory Usage — emulator vs emulator-headless**](https://cdn-images-1.medium.com/max/2402/0*DZ20pZNiqKnaydzW)

> Next Steps

To use the performance and resource optimization covered in this blog, download Android Emulator 28.1 available today on [the canary channel](https://developer.android.com/studio/preview/install-preview#change_your_update_channel). We are excited to share this early checkin-in on the progress with you, but we are definitely not done yet. We invite you to try the latest updates of Android Emulator today, and send us your [feedback](https://developer.android.com/studio/report-bugs.html#emulator-bugs).

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
