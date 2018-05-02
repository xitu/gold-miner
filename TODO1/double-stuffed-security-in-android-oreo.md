> * 原文地址：[Double Stuffed Security in Android Oreo](https://android-developers.googleblog.com/2017/12/double-stuffed-security-in-android-oreo.html)
> * 原文作者：[Gian G Spicuzza](https://android-developers.googleblog.com/2017/12/double-stuffed-security-in-android-oreo.html)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/double-stuffed-security-in-android-oreo.md](https://github.com/xitu/gold-miner/blob/master/TODO1/double-stuffed-security-in-android-oreo.md)
> * 译者：
> * 校对者：

# Double Stuffed Security in Android Oreo

Android Oreo is stuffed full of security enhancements. Over the past few months, we've covered how we've improved the security of the Android platform and its applications: from [making it safer to get apps](https://android-developers.googleblog.com/2017/08/making-it-safer-to-get-apps-on-android-o.html), dropping [insecure network protocols](https://android-developers.googleblog.com/2017/04/android-o-to-drop-insecure-tls-version.html), providing more [user control over identifiers](https://android-developers.googleblog.com/2017/04/changes-to-device-identifiers-in.html), [hardening the kernel](https://android-developers.googleblog.com/2017/08/hardening-kernel-in-android-oreo.html), [making Android easier to update](https://android-developers.googleblog.com/2017/07/shut-hal-up.html), all the way to [doubling the Android Security Rewards payouts](https://android-developers.googleblog.com/2017/06/2017-android-security-rewards.html). Now that Oreo is out the door, let's take a look at all the goodness inside.

### Expanding support for hardware security

Android already supports [Verified Boot](https://source.android.com/security/verifiedboot/), which is designed to prevent devices from booting up with software that has been tampered with. In Android Oreo, we added a reference implementation for Verified Boot running with [Project Treble](https://source.android.com/devices/architecture/treble), called Android Verified Boot 2.0 (AVB). AVB has a couple of cool features to make updates easier and more secure, such as a common footer format and rollback protection. Rollback protection is designed to prevent a device to boot if downgraded to an older OS version, which could be vulnerable to an exploit. To do this, the devices save the OS version using either special hardware or by having the Trusted Execution Environment (TEE) sign the data. Pixel 2 and Pixel 2 XL come with this protection and we recommend all device manufacturers add this feature to their new devices.

Oreo also includes the new [OEM Lock Hardware Abstraction Layer](https://android-review.googlesource.com/#/c/platform/hardware/interfaces/+/527086/-1..1/oemlock/1.0/IOemLock.hal) (HAL) that gives device manufacturers more flexibility for how they protect whether a device is locked, unlocked, or unlockable. For example, the new Pixel phones use this HAL to pass commands to the bootloader. The bootloader analyzes these commands the next time the device boots and determines if changes to the locks, which are securely stored in Replay Protected Memory Block (RPMB), should happen. If your device is stolen, these safeguards are designed to prevent your device from being reset and to keep your data secure. This new HAL even supports moving the lock state to dedicated hardware.

Speaking of hardware, we've invested support in tamper-resistant hardware, such as the [security module](https://android-developers.googleblog.com/2017/11/how-pixel-2s-security-module-delivers.html) found in every Pixel 2 and Pixel 2 XL. This physical chip prevents many software and hardware attacks and is also resistant to physical penetration attacks. The security module prevents deriving the encryption key without the device's passcode and limits the rate of unlock attempts, which makes many attacks infeasible due to time restrictions.

While the new Pixel devices have the special security module, all new [GMS](https://www.android.com/gms/) devices shipping with Android Oreo are required to implement [key attestation](https://android-developers.googleblog.com/2017/09/keystore-key-attestation.html). This provides a mechanism for strongly [attesting IDs](https://source.android.com/security/keystore/attestation#id-attestation) such as hardware identifiers.

We added new features for enterprise-managed devices as well. In work profiles, encryption keys are now ejected from RAM when the profile is off or when your company's admin remotely locks the profile. This helps secure enterprise data at rest.

### Platform hardening and process isolation

As part of [Project Treble](https://android-developers.googleblog.com/2017/05/here-comes-treble-modular-base-for.html), the Android framework was re-architected to make updates easier and less costly for device manufacturers. This separation of platform and vendor-code was also designed to improve security. Following the [principle of least privilege](https://en.wikipedia.org/wiki/Principle_of_least_privilege), these HALs run in their [own sandbox](https://android-developers.googleblog.com/2017/07/shut-hal-up.html) and only have access to the drivers and permissions that are absolutely necessary.

Continuing with the [media stack hardening](https://android-developers.googleblog.com/2016/05/hardening-media-stack.html) in Android Nougat, most direct hardware access has been removed from the media frameworks in Oreo resulting in better isolation. Furthermore, we've enabled Control Flow Integrity (CFI) across all media components. Most vulnerabilities today are exploited by subverting the normal control flow of an application, instead changing them to perform arbitrary malicious activities with all the privileges of the exploited application. CFI is a robust security mechanism that disallows arbitrary changes to the original control flow graph of a compiled binary, making it significantly harder to perform such attacks.

In addition to these architecture changes and CFI, Android Oreo comes with a feast of other tasty platform security enhancements:

*   **[Seccomp filtering](https://android-developers.googleblog.com/2017/07/seccomp-filter-in-android-o.html)**: makes some unused syscalls unavailable to apps so that they can't be exploited by potentially harmful apps.
*   **[Hardened usercopy](https://lwn.net/Articles/695991/)**: A recent [survey of security bugs](https://events.linuxfoundation.org/sites/events/files/slides/Android-%20protecting%20the%20kernel.pdf) on Android revealed that invalid or missing bounds checking was seen in approximately 45% of kernel vulnerabilities. We've backported a bounds checking feature to Android kernels 3.18 and above, which makes exploitation harder while also helping developers spot issues and fix bugs in their code.
*   **Privileged Access Never (PAN) emulation**: Also backported to 3.18 kernels and above, this feature prohibits the kernel from accessing user space directly and ensures developers utilize the hardened functions to access user space.
*   **Kernel Address Space Layout Randomization (KASLR)**: Although Android has supported userspace Address Space Layout Randomization (ASLR) for years, we've backported KASLR to help mitigate vulnerabilities on Android kernels 4.4 and newer. KASLR works by randomizing the location where kernel code is loaded on each boot, making code reuse attacks probabilistic and therefore more difficult to carry out, especially remotely.

### App security and device identifier changes

[Android Instant Apps](https://developer.android.com/topic/instant-apps/index.html) run in a restricted sandbox which limits permissions and capabilities such as reading the on-device app list or transmitting cleartext traffic. Although introduced during the Android Oreo release, Instant Apps supports devices running [Android Lollipop](https://www.android.com/versions/lollipop-5-0/) and later.

In order to handle untrusted content more safely, we've [isolated WebView](https://android-developers.googleblog.com/2017/06/whats-new-in-webview-security.html) by splitting the rendering engine into a separate process and running it within an isolated sandbox that restricts its resources. WebView also supports [Safe Browsing](https://safebrowsing.google.com/) to protect against potentially dangerous sites.

Lastly, we've made [significant changes to device identifiers](https://android-developers.googleblog.com/2017/04/changes-to-device-identifiers-in.html) to give users more control, including:

*   Moving the static _Android ID_ and _Widevine_ values to an app-specific value, which helps limit the use of device-scoped non-resettable IDs.
*   In accordance with [IETF RFC 7844](https://tools.ietf.org/html/rfc7844#section-3.7) anonymity profile, `net.hostname` is now empty and the DHCP client no longer sends a hostname.
*   For apps that require a device ID, we've built a `Build.getSerial() API` and protected it behind a permission.
*   Alongside security researchers<sup>1</sup>, we designed a robust MAC address randomization for Wi-Fi scan traffic in various chipsets firmware.

Android Oreo brings in all of these improvements, and [many more](https://www.android.com/versions/oreo-8-0/). As always, we appreciate feedback and welcome suggestions for how we can improve Android. Contact us at security@android.com.

> 1: Glenn Wilkinson and team at Sensepost, UK, Célestin Matte, Mathieu Cunche: University of Lyon, INSA-Lyon, CITI Lab, Inria Privatics, Mathy Vanhoef, KU Leuven.


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
