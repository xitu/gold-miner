> * 原文地址：[“Expert” hackers used 11 zerodays to infect Windows, iOS, and Android users](https://arstechnica.com/information-technology/2021/03/expert-hackers-used-11-zerodays-to-infect-windows-ios-and-android-users/)
> * 原文作者：DAN GOODIN
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/expert-hackers-used-11-zerodays-to-infect-windows-ios-and-android-users.md](https://github.com/xitu/gold-miner/blob/master/article/2021/expert-hackers-used-11-zerodays-to-infect-windows-ios-and-android-users.md)
> * 译者：
> * 校对者：

# “Expert” hackers used 11 zerodays to infect Windows, iOS, and Android users

A team of advanced hackers exploited no fewer than 11 zeroday vulnerabilities in a nine-month campaign that used compromised websites to infect fully patched devices running Windows, iOS, and Android, a Google researcher said.

Using novel exploitation and obfuscation techniques, a mastery of a wide range of vulnerability types, and a complex delivery infrastructure, the group [exploited four zerodays](https://arstechnica.com/information-technology/2021/01/hackers-used-4-0days-to-infect-windows-and-android-devices/) in February 2020. The hackers’ ability to chain together multiple exploits that compromised fully patched Windows and Android devices led members of Google’s Project Zero and Threat Analysis Group to call the group “highly sophisticated.”

## Not over yet

On Thursday, Project Zero researcher Maddie Stone said that, in the eight months that followed the February attacks, the same group exploited seven more previously unknown vulnerabilities, which this time also resided in iOS. As was the case in February, the hackers delivered the exploits through watering-hole attacks, which compromise websites frequented by targets of interest and add code that installs malware on visitors’ devices.

In all the attacks, the watering-hole sites redirected visitors to a sprawling infrastructure that installed different exploits depending on the devices and browsers visitors were using. Whereas the two servers used in February exploited only Windows and Android devices, the later attacks also exploited devices running iOS. Below is a diagram of how it worked:

![](https://cdn.arstechnica.net/wp-content/uploads/2021/03/device-flow-diagram.jpg)

The ability to pierce advanced defenses built into well-fortified OSes and apps that were fully patched—for example, Chrome running on Windows 10 and Safari running on iOSA—was one testament to the group’s skill. Another testament was the group’s abundance of zerodays. After Google patched a code-execution vulnerability the attackers had been exploiting in the [Chrome renderer](https://nvd.nist.gov/vuln/detail/CVE-2020-15999) in February, the hackers quickly added a new code-execution exploit for the Chrome V8 engine.

In a [blog post](https://googleprojectzero.blogspot.com/2021/03/in-wild-series-october-2020-0-day.html) published Thursday, Stone wrote:

> The vulnerabilities cover a fairly broad spectrum of issues—from a modern JIT vulnerability to a large cache of font bugs. Overall each of the exploits themselves showed an expert understanding of exploit development and the vulnerability being exploited. In the case of the Chrome Freetype 0-day, the exploitation method was novel to Project Zero. The process to figure out how to trigger the iOS kernel privilege vulnerability would have been non-trivial. The obfuscation methods were varied and time-consuming to figure out.

In all, Google researchers gathered:

> 1 full chain targeting fully patched Windows 10 using Google Chrome2 partial chains targeting 2 different fully patched Android devices running Android 10 using Google Chrome and Samsung Browser, andRCE exploits for iOS 11-13 and privilege escalation exploit for iOS 13

The seven zerodays were:

> CVE-2020-15999 - Chrome Freetype heap buffer overflowCVE-2020-17087 - Windows heap buffer overflow in cng.sysCVE-2020-16009 - Chrome type confusion in TurboFan map deprecationCVE-2020-16010 - Chrome for Android heap buffer overflowCVE-2020-27930 - Safari arbitrary stack read/write via Type 1 fontsCVE-2020-27950 - iOS XNU kernel memory disclosure in mach message trailersCVE-2020-27932 - iOS kernel type confusion with turnstiles

## Piercing defenses

The complex chain of exploits is required to break through layers of defenses that are built into modern OSes and apps. Typically, the series of exploits are needed to exploit code on a targeted device, have that code break out of a browser security sandbox, and elevate privileges so the code can access sensitive parts of the OS.

Thursday’s post offered no details on the group responsible for the attacks. It would be especially interesting to know if the hackers are part of a group that’s already known to researchers or if it’s a previously unseen team. Also useful would be information about the people who were targeted.

The importance of keeping apps and OSes up to date and avoiding suspicious websites still stands. Unfortunately, neither of those things would have helped the victims hacked by this unknown group.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
