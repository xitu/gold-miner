> * 原文地址：[A New Standard for Mobile App Security](https://security.googleblog.com/2021/04/a-new-standard-for-mobile-app-security.html)
> * 原文作者：[Brooke Davis and Eugene Liderman, Android Security and Privacy Team](https://security.googleblog.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/a-new-standard-for-mobile-app-security.md](https://github.com/xitu/gold-miner/blob/master/article/2021/a-new-standard-for-mobile-app-security.md)
> * 译者：[霜羽 Hoarfroster](https://github.com/PassionPenguin)
> * 校对者：[Chorer](https://github.com/Chorer)、[CarlosChenN](https://github.com/CarlosChenN)

# 移动应用安全的新标准

![](https://1.bp.blogspot.com/-TNecO7NNDL8/YHdg3EKOL3I/AAAAAAAADsc/EW2Jj7nVYaQxkZSvrxpmXZudgt1yrtwIwCNcBGAsYHQ/s0/Image%2B%23%2B0.png)

面对过去一年带来的所有挑战，用户越来越依赖他们的移动设备来制定健身计划、与亲人保持联系、远程工作以及轻松订购杂货等。根据 [eMarketer](https://www.emarketer.com/content/us-adults-will-spend-over-three-hours-per-day-on-mobile-apps-2020) 的数据，2020 年用户每天花费超过三个半小时使用移动应用程序。由于在移动设备上花费了大量时间，因此确保移动应用程序的安全性比以往任何时候都更加重要。尽管数字安全很重要，但并没有一个一致的行业标准来评估移动应用程序。对于普通开发者而言，现有的指南要么太轻量级，要么太繁重，同时也缺乏合规性。这就是为什么我们很高兴与大家分享 [ioXt 的公告](https://www.ioxtalliance.org/news-events-blog/ioxt-alliance-expands-certification-program-for-mobile-and-vpn-security) —— 一份新的[移动应用程序标准](https://static1.squarespace.com/static/5c6dbac1f8135a29c7fbb621/t/604aa3fa668a8e3b50630433/1615504379349/Mobile_Application_Profile.pdf)。这份标准能够为应用程序提供一组定义的安全性和隐私要求，让开发者们可以根据这些意见验收他们的应用程序。

包括 **Google**、**Amazon** 在内的 20 多个行业利益相关者，以及 **NCC Group** 和 **Dekra** 等多家认证实验室，以及 ** NowSecure** 等自动化移动应用安全测试供应商合作开发了这一新的移动应用安全标准。我们已经看到物联网（IoT）和虚拟专用网络（VPN）开发者对此标准的兴趣，但是该标准还同样适用于任何云连接服务，例如社交、消息传递、健身或生产力应用程序。

[安全物联网联盟 (ioXt)](http://ioxtalliance.org/) 管理连接设备的安全合规性评估计划。ioXt 在各个行业拥有 300 多个成员，包括谷歌、亚马逊、Facebook、T-Mobile、康卡斯特、Zigbee 联盟、Z-Wave 联盟、罗格朗、Resideo、施耐德电气等。由于涉及的公司如此之多，ioXt 涵盖了广泛的设备类型，包括智能照明、智能扬声器和网络摄像头，并且由于大多数智能设备是通过应用程序管理的，因此随着此标准的发布，它们扩大了覆盖范围以包括移动应用程序。

ioXt 的 [移动应用程序标准](https://static1.squarespace.com/static/5c6dbac1f8135a29c7fbb621/t/604aa3fa668a8e3b50630433/1615504379349/Mobile_Application_Profile.pdf) 指出了在所有移动连接设备上运行的最低限度的云连接应用程序商业最佳实践集。此安全标准有助于缓解常见威胁并降低出现重大漏洞的可能性。该标准参考了 [OWASP MASVS](https://mobile-security.gitbook.io/masvs/) 和 **[VPN Trust Initiative](https://vpntrust.net/)** 制定的现有标准和原则，并允许开发人员围绕密码学、身份验证、网络安全和漏洞披露程序质量区分安全功能。该标准还提供了一个框架来评估应用程序类别的特定要求，可以根据应用程序中包含的功能应用这些要求。例如，物联网应用程序只需在**移动应用程序标准**下进行认证，而 VPN 应用程序必须符合**移动应用程序标准以及 VPN 扩展标准**。

认证允许开发人员展示产品安全性，我们很高兴有机会推动该行业向前发展。我们观察到，应用程序开发人员可以非常迅速地解决在黑盒评估期间根据这一新标准发现的任何问题，通常在几天内就能解决问题。在发布时，以下应用程序已通过认证：[Comcast](https://compliance.ioxtalliance.org/product/157)、[ExpressVPN](https://compliance.ioxtalliance.org/product/135)、[GreenMAX ](https://compliance.ioxtalliance.org/product/68)、[Hubspace](https://compliance.ioxtalliance.org/product/174)、[McAfee Innovations](https://compliance.ioxtalliance.org /product/173)、[NordVPN](https://compliance.ioxtalliance.org/product/107)、[OpenVPN for Android](https://compliance.ioxtalliance.org/product/144)、[Private Internet Access](https://compliance.ioxtalliance.org/product/141)、[VPN Private](https://compliance.ioxtalliance.org/product/169)，以及 [Google One](https://compliance.ioxtalliance.org/product/143) 应用程序，包括 [VPN by Google One](https://compliance.ioxtalliance.org/product/143)。

我们期待看到标准的采用率随着时间的推移而增长，并且那些已经投资于安全最佳实践的应用程序开发人员能够突出他们的努力。该标准会像灯塔一样，激励更多开发人员投入到移动应用程序安全。如果您有兴趣了解有关 ioXt 联盟的更多信息以及如何获得您的应用程序认证，请访问 [https://compliance.ioxtalliance.org/sign-up](https://compliance.ioxtalliance.org/sign-up) 并查看 Android 的关于构建安全应用程序的[指南](https://developer.android.com/security)。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

------

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
