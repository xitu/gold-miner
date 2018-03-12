> * 原文地址：[Trusting third party SDKs](https://krausefx.com/blog/trusting-sdks)
> * 原文作者：[Felix Krause](https://krausefx.com)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/trusting-sdks.md](https://github.com/xitu/gold-miner/blob/master/TODO/trusting-sdks.md)
> * 译者：[CACppuccino](https://github.com/CACppuccino)
> * 校对者：[hanliuxin5](https://github.com/hanliuxin5) 

# 对第三方 SDK 的信任问题

第三方的 SDK 常常会在你下载他们的时候被轻易地**修改**！只要使用简单的[中间人攻击](https://wikipedia.org/wiki/Man_in_the_middle_attack)，任何位于同一网络中的人都可以插入病毒代码至代码库中，并随之进入你的应用中，从而在你的用户的手机中运行。

在最热门的闭源 iOS SDK 中，**31%**的 SDK 和 CocoaPods 中的 **623个库** 对于这种攻击是没有抵抗力的。作为研究的一部分，我通知了被影响的组织，并向 CocoaPods 提交了补丁，来提醒开发者和 SDK 提供者们。

## 一个 SDK 被修改潜在后果是什么？

若某人在你安装一个 SDK 之前修改了它，那么情况会变得十分的危险。因为你正在将你的 app 和那些危险的代码一起传送给用户。它会在几天内在成千上万的设备中运行。同时，它拥有和你的 app **一模一样**的权限。

这意味着任何你在 app 中引用的 SDK 拥有：

*   任何你的 app 能接触到的 keychain
*   任何你的 app 有权限接触到的文件、文件夹
*   任何你的 app 所拥有的权限，例如：定位信息，相册权限等
*   你的 app 的 iCloud 存储内容
*   你的 app 与 web 服务器交换的所有数据，例如：用户登录信息，个人信息等

Apple 强制要求 iOS app 应用使用沙箱是有很好的理由的，因此不要忘记**任何你的 app 所包含的 SDK 在你的 app 的沙箱中运行**，并且能够接触所有你的 app 有权限接触的东西。

一个含病毒的 SDK 最坏会做什么？

*   偷取用户敏感信息，通常会在你的 app 中加入一个键盘记录器，并记录每一次点击
*   偷取密钥和用户的凭据
*   [获取用户历史定位信息并卖给第三方](https://krausefx.com/blog/ios-privacy-detectlocation-an-easy-way-to-access-the-users-ios-location-data-without-actually-having-access)
*   [显示 iCloud 的钓鱼弹窗，或其他的登录凭据](https://krausefx.com/blog/ios-privacy-stealpassword-easily-get-the-users-apple-id-password-just-by-asking)
*   [在后台获取照片而不告诉用户](https://krausefx.com/blog/ios-privacy-watchuser-access-both-iphone-cameras-any-time-your-app-is-running)

这里描述的攻击方法展示了攻击者是如何利用**你的手机 app** 来偷取用户敏感数据的。

## 网络安全 101

为了使你明白病毒代码是如何在未经你的允许或注意的情况下与你的 app 绑定的，我会提供必要的知识背景来让你明白[MITM 攻击](https://wikipedia.org/wiki/Man_in_the_middle_attack)是如何进行的，以及如何避免它。

为了使一个移动端开发者在即使没有太多的网络通信知识的情况下，仍然能够了解这是如何工作的以及它们是如何保护自己的，下面的信息已经被简化了。

### HTTPs vs HTTP

**HTTP**: 未加密传输，任何位于同一网络（WiFi 或以太网）的人都可以轻易地监听网络包。在未加密的 WiFi 网络上这样监听的方法非常简单直观，而实际上在受保护的 WiFi 或以太网上依然是同样简单的。你的计算机不会去验证你所请求数据的主机的网络包；其它的计算机可以在你之前接收包裹，打开并修改它们，之后再将更改过的版本发送给你。

**HTTPs**: 在 HTTPs 传输中，其它在网络中的主机仍能监听你的包裹但不能打开它们。它们仍然能够获取一些基本的元数据，如主机名，但无法得到详细数据（如数据的 body 部分，完整的 URL 等...）。另外，你的客户端会验证你的数据包是否来自原始的主机，且没有人修改过内容。HTTPs 技术是基于 TLS 的。

### 浏览器是如何从 HTTP 切换至 HTTPs 的

在你的浏览器中输入“[http://google.com](http://google.com)” (请输入 “http”, 而不是 “https”)。你会看见浏览器是如何自动的从 “http” 端口切换至 “https” 的。

这个切换并不是在你的浏览器中发生，而是来自于远端的服务器（google.com），因为你的客户端（现在即浏览器）并不知道主机支持哪一种端口。（除了使用 [HSTS](https://en.wikipedia.org/wiki/HTTP_Strict_Transport_Security) 的主机）

![](https://krausefx.com/assets/posts/trusting-sdks/image_0.png)

最初的请求是通过“http”发生的，所以服务器只能通过“http”明文来告诉客户端切换至安全的“https”端口，响应的代码为“301 Moved Permanently”。

你可能已经看到这里的问题所在了：由于第一个响应是使用明文，攻击者可以改变特定的网络包来替换掉重定向的 URL 并保持不加密的 “http”。这叫做 SSL 剥离，我们会在之后更多地谈及它。

### 网络请求是如何工作的

简单来讲，网络请求工作在多层模型上。不同的层上有不同的信息，告诉网络包如何路由：

*   最底层（数据链路层）使用 MAC 地址来定位主机在网络中的地址
*   上面的一层（网络层）使用 IP 地址来定位主机在网络中的地址
*   再上面的层会添加端口信息和实际要传递的消息内容

> 如果你对此感兴趣，你可以学习 OSI 模型是如何工作的，特别是在实现 TCP/IP 协议时 （例如 [http://microchipdeveloper.com/tcpip:tcp-ip-five-layer-model（tcp/ip 五层模型）](http://microchipdeveloper.com/tcpip:tcp-ip-five-layer-model)）。

所以，如果你的计算机将一个网络包传输给路由器，它是如何基于第一层（MAC address）知道怎么去将网络包路由的呢？为了解决这个问题，路由器采用了一种端口叫做 ARP （Address Resolution Protocol）。

### ARP 的工作原理以及是如何被滥用的

简单来讲，网络中的设备利用 ARP 映射来记住去将含有特定 MAC 地址的网络包送到哪里。ARP 的工作原理很简单：如果一个设备知道该一个网络包所应送入的 IP 地址，它就会询问网络中的所有人：“这个 MAC 地址应该与哪个 IP 地址对应？”拥有那个 IP 地址的设备就会回复该信息 ✋

![](https://krausefx.com/assets/posts/trusting-sdks/image_1.png)

不幸的是，设备无法验证 ARP 消息发送者的身份。因此攻击者可以快速地响应另一台设备的 ARP 声明：“请将所有 IP 为 X 的网络包发送至这个 MAC 地址。”路由器就会记住并在以后对所有相关的请求应用该信息。这被称为“ARP 欺骗”。

![](https://krausefx.com/assets/posts/trusting-sdks/image_2.png)

明白所有的网络包是如何经过攻击者而不是直接从主机路由至你的计算机上的了吗？

只要网络包经过攻击者的机器，就会有一些风险。与你使用你信任的 ISP 或 VPN 服务的风险一样：如果你使用的服务进行了合适的加密，他们就不能得知你正在做的事情或在你的客户端（比如浏览器）注意不到的情况下修改你的网络包。如之前所说，仍然有一些信息如特定的元信息是可见的（例如主机名）。

如果存在未加密的网络包（例如 HTTP），那么攻击者不仅可以查阅里面的内容，同时还可以随意改写任何信息而不被发现。

**注意**: 上面所述的技术与你可能读过的公共 WiFi 安全问题是不同的。公共 WiFi 的问题在于任何人都可以读取在其中所传送的网络包，如果这些网络包是没有加密的 HTTP，那么很容易就解读出正在发生的事情。ARP 污染作用于所有的网络，无论是公共与否，WiFi 还是以太网。

## 让我们看看它在实践中如何作用

让我们看看一些 SDK，它们是如何发布它们的文件的，然后我们看看能不能找到什么。

### CocoaPods

**开源 Pods**: CocoaPods 在底层使用 git 来从如 GitHub 等服务下载代码。 `git://`端口使用`ssh://`，与 HTTPs 的加密相似。总体上，如果你使用 CocoaPods 从 GitHub 上安装开源 SDK，你还是很安全的。

**闭源 Pods**: 在准备这篇文章时，我注意到 Pods 可以定义一个 HTTP URL 来指向二进制 SDK，所以我提交了一个 pull request（[1](https://github.com/CocoaPods/CocoaPods/pull/7249) 和 [2](https://github.com/CocoaPods/CocoaPods/pull/7250)），合并后发布为[CocoaPods 1.4.0](https://blog.cocoapods.org/CocoaPods-1.4.0/) 来在一个 Pod 使用未加密的 http 时产生警告。

### Crashlytics SDK

Crashlytics 使用 CocoaPods 作为默认的发布，但还有 2 种可选的安装方式：Fabric Mac app 或手动安装，这两种都是 https 加密的，所以我们在这没有太多可做的。

### [Localytics](http://docs.localytics.com/dev/ios.html)

让我们看一下一个 SDK 样例，文档页面是通过未加密的 http 传输的（见地址栏）

![](https://krausefx.com/assets/posts/trusting-sdks/image_3.png)

所以你可能会想：“啊，我只是在这里查阅文档而已，我又不在乎它没有被加密。”但问题在于，这里的下载链接（蓝色的）也是网站的一部分，意味着一个攻击者可以轻易地将 `https://` 链接替换为 `http://`，使得实际的文件下载并不安全。

或者，攻击者也可以选择只是将 https:// 链接换为看起来相似的攻击者的链接。

*   [https://s3.amazonaws.com/localytics-sdk/sdk.zip](https://s3.amazonaws.com/localytics-sdk-docs/sdk.zip)
*   [https://s3.amazonaws.com/localytics-sdk-binaries/sdk.zip](https://s3.amazonaws.com/localytics-sdk-docs/sdk.zip)

同时，用户没有好的方法来验证特定主机的身份，URL 或者 SDK 作者的 S3 bucket。

为了验证这点，我设置了我的[树莓派](https://www.raspberrypi.org/) 来劫持流量并实现多种 SSL 欺骗（将 HTTPs 链接降级为 HTTP），从 JavaScript 文件，图片文件，到下载链接。

![](https://krausefx.com/assets/posts/trusting-sdks/image_4.png)

一旦下载链接被降级为 HTTP，就很容易将 zip 文件的内容替换掉：

![](https://krausefx.com/assets/posts/trusting-sdks/image_5.png)

在传输中替换 HTML 文本很容易，但一个攻击者如何替换一个 zip 文件或者二进制文件呢？

1.  攻击者下载原来的 SDK
2.  攻击者将病毒代码插入 SDK
3.  攻击者压缩更改后的 SDK
4.  攻击者等待来往的网络包，并将所有拥有特定特征的文件替换为攻击者准备好的 zip 文件

(这与[图片替换技巧](https://charlesreid1.com/wiki/MITM_Labs/Bettercap_to_Replace_Images)中使用的方法一样：每个通过 HTTP 传输的图片都被一个表情替换)

结果是，所下载的 SDK 可能包含被修改过的额外的文件或代码：

![](https://krausefx.com/assets/posts/trusting-sdks/image_6.png)

要让这个攻击生效，所需的是：

*   攻击者与你位于同一网络
*   文档网页是未加密的并且所有的链接都能够使用 SSL 欺骗

![](https://krausefx.com/assets/posts/trusting-sdks/image_7.png)

Localytics 在问题被披露后解决了它，所以文档页面和下载现在都是 HTTPs 加密的了。

### [AskingPoint](https://www.askingpoint.com/documentation-ios-sdk/)

看下下一个 SDK，它的文档页面是 HTTPs 加密的，从截图来看，似乎是安全的：

![](https://krausefx.com/assets/posts/trusting-sdks/image_8.png)

然而，这个基于 HTTPs 的网站链接指向了一个未加密的 HTTP 文件，而浏览器在这种情况下是不会警告用户的（[一些浏览器已经会在 JS/CSS 文件通过 HTTP 下载时发出警告](https://developers.google.com/web/fundamentals/security/prevent-mixed-content/what-is-mixed-content)）。对于用户来说，很难发现这里发生着什么，除非他们会手动比较所提供的哈希值。作为这个项目的一部分，我撰写了一份安全报告，针对 Google Chrome （[794830](https://bugs.chromium.org/p/chromium/issues/detail?id=794830)） 和 Safari ([rdar://36039748](https://openradar.appspot.com/radar?id=5000976083714048)）来警告那些从 HTTPs 网站下载未加密文件的用户们。

### [AWS SDK](https://aws.amazon.com/mobile/sdk/)

![](https://krausefx.com/assets/posts/trusting-sdks/image_9.png)

在我进行这项研究的时候，AWS iOS SDK 的下载页面使用了 HTTPs 加密，但链接至了一个未经加密的 zip 下载文件，与之前所提到的 SDK 相似。这个问题在被披露后，亚马逊解决了它。

## 总而言之

回想起之前提到过的 iOS 隐私漏洞（iCloud 钓鱼，通过图片获得定位，在后台使用摄像头），如果我们谈论的不是那些针对用户的恶意开发者，而是那些**针对你，一个 iOS 开发人员**的攻击者，为了在短时间内接触到上百万用户呢？

### 攻击开发者

如果一个 SDK 在你下载的时候被使用中间人攻击修改了内容，并插入了病毒代码，导致用户对你的信任破裂，你会怎么办呢？让我们以 iCloud 钓鱼弹窗为例，要想使用其它开发者的 app 来偷取用户的密码，并发送至你的远程服务器上，到底有多难？

在下面的视频中，你可以看到一个 iOS 样例 app，有地图展示功能。在下载并将 AWS SDK 加入这个项目后，你可以看到病毒代码是如何被执行的，在这个案例中 iCloud 弹窗钓鱼显示了出来，然后 iCloud 的明文密码被读取并传送到一个远程服务器上。

YouTube 视频请见：https://youtu.be/Mx2oFCyWg2A

这个攻击唯一的发动前提就是攻击者需要与你在你一个网络上（例如在同一个会议酒店中）。或者攻击也可以通过你使用的 ISP 或 VPN 服务来完成。我的 Mac 使用的是默认的 macOS 配置，意味着是没有代理，自定义 DNS 或者 VPN 设置的。

设置这样的攻击简单地令人惊讶，因为可以使用专为 SSL 欺骗，ARP 污染和替换多种请求内容而设计的工具来自动完成攻击。如果你之前实现过攻击，在其他任意的计算机上仅需不到一个小时就能完成设置，包括像我用于这次研究的树莓派上。因此整个攻击的花费不到 $50 美元。

![](https://krausefx.com/assets/posts/trusting-sdks/image_10.jpg)

我决定不公开我所使用的工具名称，以及我写的代码。你可以看看一些有名的工具如 [sslstrip](https://moxie.org/software/sslstrip/)， [mitmproxy](https://mitmproxy.org/) 和 [Wireshark](https://www.wireshark.org/)

### 在开发者的机器上运行任意的代码

在之前的例子中，攻击者通过劫持 SDK 来向 iOS app 中插入病毒代码。另一个攻击方向是开发者的 Mac。一旦攻击者可以在你的机器上运行代码，甚至拥有远程 SSH 权限，那么损害将会变的巨大：

*   激活管理员账户的远程 SSH 权限
*   安装键盘记录器来获取管理员密码
*   使用密码来解密 keychain，并将所有登录凭据传送至远程服务器
*   获取本地机密，如 AWS 凭据，CocoaPods 和 RubyGems 的上传令牌还有：
    *   如果开发者拥有着一个受欢迎的 CocoaPod，你可以将病毒代码散播到更多的 SDK 中
*   接触你的 Mac 上几乎所有的文件及数据库，包括 iMessage 的对话，邮件和源代码
*   在用户不知情的情况下录屏
*   安装一个新的 root 下的 SSL 证书，使得攻击者能够监听你大部分加密的网络请求

为了证明这是可以发生的，我查找了如何在开发者本地运行的 shell 文本中插入病毒代码，在 BuddyBuild 案例中：

*   与之前的前提相同，攻击者需要在同一个网络中
*   BuddyBuild 文档告诉用户去 `curl` 一个未加密的 URL 来通过 `sh` 进行操作，意味着任何 `curl` 命令返回的代码都会被执行
*   修改过的 `UpdateSDK` 由攻击者（树莓派）提供，并且询问管理员密码（通常 BuddyBuild 的更新脚本不会询问这个）
*   在一秒钟之内，病毒脚本可以做到：
    *   为当前账户启动远程 SSH 权限
    *   安装并配置键盘记录器，用于自动记录你的登录操作

一旦攻击者获得了 root 密码和 SSH 权限，他们可以去做任何上述的事情。

YouTube 视频请见：https://youtu.be/N1Wj6ipc-HU

BuddyBuild 在问题反馈后解决了这一问题。

### 这样的攻击有多现实？

**非常现实！**打开你的 Mac 的网络设置，并查看你的 Mac 连接过的 WiFi 列表。对我来说，我的 MacBook 曾连接过超过 200 个热点。而其中有多少你可以完全相信呢？即使在相信的网络中，其它的机器也可能在之前被侵入，而实现远程控制攻击（见上部分）。

SDK 和 开发者工具成为了越来越多的攻击者的目标。这里有一些过去几年的例子：

*   [Xcode Ghost](https://en.wikipedia.org/wiki/XcodeGhost) 影响了近 4000 个 iOS app，包括微信：
    *   攻击者对任何使用这些 app 的机器拥有远程登录权限
    *   展示钓鱼弹窗
    *   拥有阅读并更改粘贴板的权限（当使用密码管理器的时候这会变得很危险）
*   [NSA 致力于寻找 iOS 漏洞](https://9to5mac.com/2017/03/07/cia-ios-malware-wikileaks/)
*   [Pegasus](https://www.kaspersky.com/blog/pegasus-spyware/14604/)：针对非越狱 iPhone 的恶意软件, [被政府利用](https://citizenlab.ca/2016/08/million-dollar-dissident-iphone-zero-day-nso-group-uae/)
*   [KeyRaider](https://en.wikipedia.org/wiki/KeyRaider)：仅影响越狱 iPhone，但仍然偷取了超过 200,000 终端用户的用户凭证
*   在仅仅几周之前，有很多关于这是如何影响网站项目的博文被发出 （例如[1](https://hackernoon.com/im-harvesting-credit-card-numbers-and-passwords-from-your-site-here-s-how-9a8cb347c5b5), [2](https://scotthelme.co.uk/protect-site-from-cyrptojacking-csp-sri/)）

[以及更多类似的事件](https://www.theiphonewiki.com/wiki/Malware_for_iOS)。另一个方法是获取下载服务器的权限（例如 S3 bucket 使用权限密钥）并替换掉二进制文件。这在过去几年中常常发生，例如 [Mac app 传输事件](https://www.macrumors.com/2016/03/07/transmission-malware-downloaded-6500-times/)。这开启了攻击领域的另一个层级，是我在这篇博文中没有讲到的。

### 会议中心，酒店，咖啡厅

每当你在会议中心，酒店或者咖啡厅链接 WiFi 时，你会成为一个易于攻击的目标。攻击者知道这里有大量的开发者在会议中，并可以轻易地利用这点。

### SDK 提供者如何保护他们的用户呢？

这会超出这篇博文的讨论范围。Mozilla 提供了一份[安全指导](https://developer.mozilla.org/en-US/docs/Web/Security) 是一个不错的主意。 Mozilla 还提供了一个工具叫做[observatory](https://observatory.mozilla.org) ，能够自动检查服务器的配置和证书。

### 有多少热门的 SDK 被这一弱点影响了？

![](https://krausefx.com/assets/posts/trusting-sdks/image_11.png)

![](https://krausefx.com/assets/posts/trusting-sdks/image_12.png)

![](https://krausefx.com/assets/posts/trusting-sdks/image_13.png)

我从 2017 年 11 月 23 日开始研究，根据 [AppSight](https://www.appsight.io/?asot=2&o=top&os=ios)（将所有 Facebook 和 Google 的 SDK 算作一个，因为他们都采用了同一种安装方法——略过所有在 GitHub 上开源的 SDK），调查了 41 个最受欢迎的移动端 SDK。

*   **41** 个检查的 SDK 中
    *   **23** 个是闭源的且你只能下载二进制文件
    *   **18** 个是开源的（它们都在 GitHub 上）
*   **13** 是容易成为中间人攻击而用户无法得知任何情况的目标
    *   **10** 个为闭源 SDK
    *   **3** 个是开源的 SDK，意味着用户们既可以从未加密的官网 HTTP 渠道下载，也可以安全地从 GitHub 上下载源代码
*   **5** 个 SDK没有任何安全的下载方法，意味着他们或者对应的服务（如 GitHub）完全不支持 HTTPs
*   **31%** 的 SDK 是极易被这类攻击攻陷的目标
*   **5** 个另外的 SDK 需要账户来下载（难道他们有什么要隐藏的东西么？）

我在 2017 年的 11 和 12 月通知了所有可能被攻击影响的目标，在公开谈论这件事之前给予他们两个月的时间来解决这个问题。在这 13 个被影响的 SDK 中：

*   **1** 个在三个工作日内解决了问题
*   **5** 个在一个月内解决了问题
*   **7** 个 SDK 在这篇博文被发出时仍然保留着弱点

仍被该漏洞影响的 SDK 提供者们尚未对我的邮件做出回应，或者仅仅回复了“我们会去看一下它的”——它们都在使用量最高的前 50 个 SDK 中。

从 CocoaPods 中来看，有总计 **4,800** 个发布版本被影响，来自 **623** 个 CocoaPods。我在本地对 `Specs` 目录通过 `grep -l -r '"http": "http://' *` 得到的这些数据。

### 开源 vs 闭源

从上文的数字来看，如果你使用闭源的 SDK，那么你很可能被攻击波及到。更重要的是，当 SDK 是闭源的时候，你很难验证依赖库的完整性。如你所知，你应该总是[利用版本控制检查 Pods 目录](https://guides.cocoapods.org/using/using-cocoapods.html#should-i-check-the-pods-directory-into-source-control)，来检测其中的变化，审计你的依赖库的更新。我所调查的开源 SDK 中，100% 都可以从 GitHub 中直接使用，意味着如果你使用 GitHub 的版本而不是提供者网站的版本，即使使用上文中那三个被影响的 SDK，你也不会受到影响。

基于上面的数字，可以很清楚的知道，你除了不能深入闭源 SDK 的源代码之外，还会有比较高的被攻击的风险。不仅仅是中间人攻击，还包括：

*   攻击者获取了 SDK 下载服务器的权限
*   提供 SDK 的公司被渗透
*   当地政府强制公司包含后门
*   提供 SDK 的公司本身有不良意图，并包含了你不想要的追踪以及代码

**你应该对你传送的代码负责！** 你应该保证你没有辜负用户对你的信任，违背欧盟的数据保护法([GDPR](https://www.eugdpr.org/))，或通过病毒 SDK 偷取用户的凭据。

## 总结

作为开发者，我们有责任仅将我们信任的代码传送给客户。现在最简单的一种攻击就是通过 SDK 病毒实现的。如果一个 SDK 是在 GitHub 上开源的，并通过 CocoaPods 安装，那么你还是很安全的。要特别注意绑定的二进制闭源代码或你不完全信任的 SDK。

由于这种攻击的留下的痕迹很小，你很难发现你的代码被改变了。而使用开源代码，我们作为开发者可以最好地保护自己，和我们的客户。

参考我的 [其它与隐私和安全相关的文献](https://krausefx.com/privacy).

## 鸣谢

特别感谢 [Manu Wallner](https://twitter.com/acrooow) 为视频提供的录音。

特别感谢我的朋友们对于这篇文章的反馈： [Jasdev Singh](https://twitter.com/jasdev), [Dave Schukin](https://twitter.com/schukin), [Manu Wallner](https://twitter.com/acrooow), [Dominik Weber](https://twitter.com/domysee), [Gilad](https://twitter.com/giladronat), [Nicolas Haunold](http://haunold.me/) 以及 Neel Rao.

除非在文章中特别提到，否则这些项目皆为我利用周末及晚上的时间来完成的业余项目，与我所做的工作和雇主无关。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
