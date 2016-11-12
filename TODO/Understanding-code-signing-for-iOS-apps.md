> * 原文地址：[Understanding code signing for iOS apps](https://engineering.nodesagency.com/articles/iOS/Understanding-code-signing-for-iOS-apps/)
* 原文作者：[MariusConstantinescu](https://twitter.com/marius_const)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者： [Nicolas(Yifei) Li](https://github.com/yifili09)
* 校对者： [Tuccuay](https://github.com/Tuccuay), [fengzhihao123](https://github.com/fengzhihao123)

# 理解 `iOS` 应用程序的代码签名机制


如果你是一位 `iOS` 应用程序开发者，你有可能已经使用过代码签名了。如果你是一位初级的 `iOS` 应用程序开发者，你可能对开发者网站上那些有关 "Certificates，Identifiers & Profiles" 的部分感到不知所措。

![](https://d1gwekl0pol55k.cloudfront.net/image/baas/translate_values/hbikk_ospmSpNLyW.gif)

本文的目的是帮助初级 `iOS` 应用程序开发者从宏观角度理解代码签名是什么。这不是一个如何按部就班地对你的应用程序进行代码签名的操作手册。理想化来说，在你阅读完这篇文章后，你能够对应用程序进行代码签名而不需要按照任何操作手册。

我不准备对底层细节进行讨论，但是我们将讨论一些非对称加密技术的内容。

### [](#Asymmetric-cryptography "Asymmetric cryptography")非对称加密技术

你至少要知道的是，非对称加密技术使用一个**公钥**和一个**私钥**。用户需要保留自己的私钥，但是他们能把公钥分享出去。并且使用这些公钥和私钥，用户就能证明那确实就是他自己。

[这里](https://blog.vrypan.net/2013/08/28/public-key-cryptography-for-non-geeks/) 有一篇浅显易懂地解释什么是非对称加密技术的文章。如果你想知道实现这个技术的细节或者背后用到了哪些数学算法原理，在网络上有很多这样的文章。

### [](#App-ID "App ID")App ID

`App ID` 是你应用程序的唯一识别符。它由苹果为你创建的 `team id （团队 id）`（你无法插手） 和你应用程序的 `bundle id （程序包 id）` （比如，`com.youcompany.yourapp`）组成。

也有通配符形式的 `App ID`: `com.yourcompany.*`。它们会匹配多个 `bundle id`。

总而言之，你的应用程序会有一个明确的 `App ID`，而不是一个通配符形式的。

### [](#Certificates "Certificates")Certificates / 证书

你可能已经注意到，为了在苹果开发者网站上创建一个证书 / certificate，你需要上传一个签名证书申请 (Certificate Signing Request)。你能通过 `Keychain` 创建这个 `CSR` 文件，并且这个 `CSR` 文件包含一个私钥。

之后在开发者网站上，你能使用这个 `CSR` 文件创建一个证书 （certificate）。

证书 (certificates) 的类型有很多种。最常见的是:

* 应用程序开发证书 (`iOS` 应用程序开发) - 你需要使用这些证书才能让 `XCode` 中的应用程序运行在设备上。 
* 应用程序分发证书 (苹果应用市场和内部分发渠道) - 你需要使用这些证书，它能让你把应用程序提交到苹果应用市场或者内部分发渠道。
* `APNS` (Apple Push Notification Service / 苹果推送通知服务系统) - 你需要使用这些证书，它能让你推送内容到你的应用程序中。与应用程序的开发证书和分发证书不同，`APNS` 与 `APP ID` 有关。`APNS` 有两种证书，对于开发环境来说 - Apple Push Notification Service / 苹果推送通知服务 SSL (适用于沙盒环境)，对生产环境来说 - Apple Push Notification Service / 苹果推送通知服务 `SSL` (适用于沙盒和生产环境)。如果你想让推送服务在调试和分发程序上都能使用，你需要创建这两个证书。

### [](#Devices "Devices")Devices / 设备

在你账户每年的会员期内，你能为每个产品添加最多 100 个设备。100 个 iPhone, 100 个 iPad, 100 个 iPod Touch， 100 个 Apple Watche 和 100 个 Apple TV。为了把设备添加到你的账户下，你需要添加该设备的唯一识别码。你能在 `Xcode` 中方便地找到它，或在 `iTunes` 中（可能会稍微麻烦点儿）。[这里](https://developer.apple.com/library/content/documentation/IDEs/Conceptual/AppDistributionGuide/MaintainingProfiles/MaintainingProfiles.html#//apple_ref/doc/uid/TP40012582-CH30-SW10) 有一份详细的指导手册教你如何添加设备到你的账户下。

### [](#Provisioning-profiles "Provisioning profiles")Provisioning profiles / 配置文件

配置文件将 `App ID`，开发者或者内部分发证书和一些设备联系起来。你在苹果开发者网站上创建这些配置文件，然后在 `Xcode` 内下载它们。

### [](#Usage "Usage")使用方法

在你创建了这些以后，回到 `Xcode` 页面，添加你的证书，更新你的配置文件，之后选择你想要的那个配置文件。从这些配置文件中，你能选择需要的签名身份(这取决于联系到它的证书)。

### [](#F-A-Q "F.A.Q.")常见问题解答

多年来在 `iOS` 开发的过程中，我问过也被很多人问过有关代码签名的问题。比如下面的这些。

* **问题**: 我已经从开发者网站上下载了配置文件和证书，但是我还是不能对应用程序签名。       
    **解答**: 是的，因为你没有私钥，就是那个在证书签名申请中使用的那个。可能是之前其他团队的成员创建了这些证书和配置文件。你能从原来的开发者那里获得这些私钥，重新激活这个证书并且创建一个新的 (和这个证书有联系的所有配置文件都会失效，但是不会对任何应用市场上使用这些证书的应用程序造成问题) 或者如果可能的话，创建一个全新的证书。（目前，每一个开发者账户最多申请 3 个应用程序分发证书。）

* **问题**: 那有关推送服务的证书呢？我想让应用程序能接收推送通知。难道我不应该使用 `APNS` 证书创建一个配置文件么？            
    **解答**: 不是这样的。当你创建一个 `APNS` (Apple Push Notification Service / 苹果推送通知服务) 证书的时候，你把 `APP ID` 联系到这个证书上。所以，首先要有 `CSR` 文件，之后通过这个 `CSR` 文件创建一个新的 `APNS`，下载后在 `Keychain` 中打开它，并以 `.p12` 文件格式导出，之后把这个文件上传到你的推送服务提供商处。这个 `.p12` 文件知道它是和那个应用程序联系的，并且它会只推送内容到这个应用程序。这也是为什么你不能把一个 `APNS` 证书联系到通配符形式的 `APP ID` (com.youcompany.*)。推送通知的服务器需要知道，它需要推送内容到哪个应用程序。

* **问题**: 我买了一个新的 `mac` 计算机，为了代码签名能正常工作，我应该从旧的 `mac` 计算机上 `keychain` 中导出什么到新的 `mac` 计算机中？         
    **解答**: 你可能想把所有 `keychain`　中的内容导出到新的 `mac` 计算机中。你可以通过 [这些步骤](https://support.apple.com/kb/PH20120?locale=en_US) 完成。但是如果你想导出一个证书，确保你也能导出这个私钥。在 `Keychain` 中，你应该可以通过点击证书旁边的三角选项展开它的内容，之后你就会看到这个私钥。这些证书都能以 `.p12` 文件格式导出。否则，他们会以 `.cer` 格式导出，没有私钥，这个文件是没用的。

* **问题**: 我的 `iOS` 应用程序分发证书过期了，我的应用程序还能继续工作么？          
    **解答**: 当你的证书过期了，使用这个证书的配置文件就会失效了。在应用程序市场（`App Store`）上，只要你的开发者账号还有效，这个应用程序还是能正常使用的。但是通过这个证书在内部渠道分发的应用程序就不能继续使用了。

* **问题**: 我的 `APNS` 证书过期了，现在会发生什么？           
    **解答**: 你不能再发送推送通知给应用程序。通过创建一个与 `App ID` 联系的 新的 `APNS` 证书，下载并导出这个 `.p12` 文件，之后把它上上传给你的推送通知服务提供商。并且不需要为此而更新应用程序。

### [](#Summary "Summary")总结

我想再次强调有关代码签名的是:

* 每一个应用程序都有一个 `App ID`
* 对所有使用中的证书，你都必须存有相关的**私钥**
* 一个**调试版本的配置文件**把 `APP ID`，调试设备和应用程序开发证书联系在一起。
* 一个**内部分发渠道的配置文件**把 `App ID`，调试设备和应用程序分发证书联系在一起。
* 一个**应用程序市场 （`App Store`）的配置文件**把 `App ID` 和你的应用程序分发证书联系在一起。
* 对于推送通知，创建一个 **APNS 证书**，它和 `App ID` 联系在一起，下载并以 `.p12` 文件格式导出，并上传这个文件到推送通知服务供应商处；如果你想要这个推送通知在调试和生产环境下都起作用，你不得不分别为开发调试和生产环境创建 2 个 `APNS` 证书。

通晓这些能帮助你更好的理解代码签名机制，并且最终省去了很多时间。

![](https://d1gwekl0pol55k.cloudfront.net/image/baas/translate_values/success_YGu5HHLDK6.jpg)

### [](#Further-reading "Further reading")延伸阅读

* [深入理解代码签名机制](https://www.objc.io/issues/17-security/inside-code-signing/)
* [官方指南 - 代码签名](https://developer.apple.com/support/code-signing/) 
* [从入门到放弃 - `iOS` 代码签名和配置文件](https://medium.com/ios-os-x-development/ios-code-signing-provisioning-in-a-nutshell-d5b247760bef)

