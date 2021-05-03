> * 原文地址：[Better Privacy with Chromium’s Privacy Sandbox](https://blog.bitsrc.io/better-privacy-with-chromiums-privacy-sandbox-6134117f74be)
> * 原文作者：[Mahdhi Rezvi](https://medium.com/@mahdhirezvi)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/better-privacy-with-chromiums-privacy-sandbox.md](https://github.com/xitu/gold-miner/blob/master/article/2021/better-privacy-with-chromiums-privacy-sandbox.md)
> * 译者：[Badd](https://juejin.cn/user/1134351730353207)
> * 校对者：[CristoMonte](https://github.com/CristoMonte)，[PingHGao](https://github.com/PingHGao)，[PassionPenguin](https://github.com/PassionPenguin)，[Chorer](https://github.com/Chorer)

# Chromium 隐私沙盒让用户隐私更安全

![图片由 [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral) 的 [Dan Nelson](https://unsplash.com/@danny144?utm_source=medium&utm_medium=referral) 提供](https://cdn-images-1.medium.com/max/10368/0*IeaUrcmOuZUgq-Jn)

近来关于隐私安全的讨论非常之多，尤其是浏览器相关的话题，更是议论纷纭。不久前，WhatsApp 的一则声明引起了轩然大波，他们宣布将与其母公司 Facebook 共享用户数据。据 [Wired](https://www.wired.com/story/whatsapp-facebook-data-share-notification/) 爆料，WhatsApp 与 Facebook 共享用户数据已有数年之久。这场骚动引发了关于把用户数据用于广告服务的讨论。

你可能会说，个人数据不应共享给 Facebook 用于广告的精准投放。但我相信，如果这个过程能够以恰当而合法的手段实施的话，是利大于弊的。想象一下，你和朋友刚刚在 WhatsApp 上聊到一款手机，而下一秒，你就在 Facebook 上看到了这款手机的广告。尽管你的第一反应会是细思极恐，但如果没有这些定制化的广告，你就不会知道这家店正在以非常诱人的价格售卖这款手机。

鉴于用户和企业都从中受益颇多，许多改变广告的运作方式的提议涌现了出来。而隐私沙盒正是 Google 提出的这样一套新方案，目的在于让网络生态环境越来越好的同时，保证企业能够通过广告获取收益。

## 隐私沙盒是什么？

隐私沙盒是来自 Google 的一套方案，旨在“创造一个欣欣向荣的网络生态环境，用户及其隐私权益在这样的环境中能够得到最起码的尊重”。这套方案提供了一套隐私保护 API，既可以保证企业盈利，又无需使用第三方 Cookie 等手段来跟踪用户。在这种无 Cookie 的场景中，Google 希望能够按照隐私沙盒设置的标准进行广告的精准投放、流量转化和预防欺诈。与此同时，这个场景下的 Cookie 将被上文提到的隐私保护 API 取而代之。

在软件工程的术语里，“沙盒”一词指的是一种受保护的环境。在这套隐私沙盒方案中，用户数据被牢牢保护在浏览器中的一个安全的本地环境里。广告商只能通过给定的 API 访问到所需信息。这些 API 不会暴露除了广告商所必需的信息之外的任何数据。

隐私沙盒的重要原则之一就是：用户的私人数据应该受到保护，绝不能以能够跨站识别用户的方式分享出去。

下面就让我们来看看，隐私沙盒是如何在不使用第三方 Cookie 的情况下改变我们的上网方式的。

![图片来自 [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral) 的 [Paula Guerreiro](https://unsplash.com/@pguerreiro?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/11850/0*Tyf4CKlKHucwp3PV)

## 基于用户兴趣的广告投放

[群组联合学习（Federated Learning of Cohorts，简称 FLoC）](https://github.com/jkarlin/floc)是用于在定向广告投放中替换掉第三方 Cookie 的方案之一。该方案希望改变跟踪用户的方式，与其观察每个人的浏览行为，不如观察一组相似人群的行为。这种新的方式使企业能够把兴趣相似的用户进行分群，让定向广告匹配到适合的用户。这种新颖的方式将**单个用户**“隐之于众”，并使用设备端（On-device）的处理方式来保证用户数据在本地的安全。

Google 广告团队的这套方案已经成功通过测试，并发现**与基于 Cookie 的广告方案相比，广告商每花费一美元预计可以得到的转化率至少是前者的 95%**。这项发现足以证明，FLoC 就是隐私为重趋势下的未来之路。

Chrome 团队期望在 2021 年 3 月开始进行公开测试。详情[见此](https://github.com/WICG/floc)。

## 创造受众

一次成功的广告投放，其要素之一就是如何创造受众。对于如何让营销商和广告商不用第三方 Cookie 就能精准地创造受众，隐私沙盒自有妙计。Chrome 团队公布了一项名为 [FLEDGE](https://github.com/WICG/turtledove/blob/master/FLEDGE.md) 的新提案，该提案基于此前的一项名为 [TURTLEDOVE](https://github.com/WICG/turtledove) 的 Chrome 提案。这项新提案吸收了业界对 TURTLEDOVE 的反馈，并集成了“**可信服务器**”等特性。可信服务器用于存储广告投放活动的出价、预算等信息。

FLEDGE 本质上是 Google 提供给有特定需求的广告商的选项，这些广告商想要通过再次营销（Remarketing）触达那些之前访问过他们网站的用户。FLEDGE 有望能在今年晚些时候开启试用，[详情见此](https://github.com/WICG/turtledove/blob/master/FLEDGE.md)。

## 衡量转化效果

Google 提出了多种让营销商可以量化转化效果的提案。这些提议能在支撑广告商的关键需求的同时，确保用户的隐私得到保护。像事件级（Event-level）报告和聚合级（Aggregate-level）报告这类技术会被应用于对转化效果的量化中。这些数据报告技术让竞价模型能够识别数据中的模式，并针对消费群体进行精确度量。

Google 还计划使用信息聚合、添加干扰以及限制设备数据发送量等技术来保护消费者的隐私权益。因此，广告商将不得不优先转化那些对他们的报告重要的数据，并且只能访问到这些数据。但 Google 目前仍在广泛收集反馈，而衡量转化的原型尚未建成。

## 防止广告欺诈

要保持良好的网络生态模式，广告投放要能够区分真实用户流量和欺诈流量。Google 计划借助一种名为可信 Token API 的特性实现这样的能力。可信 Token API 是一种新的 API，有助于反欺诈、区分真实用户和机器人。这个特性让一个源（Origin）可以给信任的用户生成加密的 Token。这些 Token 存储于用户的浏览器中，用于在其他场景中评估用户身份。

Google 预计于今年 3 月开放试用，跟随下一版本的 Chrome 发布，该版本支持升级版的可信 Token API，详情[见此](https://web.dev/trust-tokens/)。

## 反指纹追踪

关于浏览器指纹识别及其危险性，我曾写过几篇文章，详情[见此]((https://blog.bitsrc.io/the-darker-side-of-pwas-you-might-not-be-aware-of-ffa7b1d08888))。

浏览器指纹识别是一种识别和追踪用户的技术，营销商通过一些简单的信息，例如用户浏览器型号和版本、操作系统、插件、时区、语言、屏幕分辨率等其他设置信息就能确定唯一用户并对其进行跟踪。

为了使隐私沙盒能防御指纹识别，Google 给出了一种反指纹识别的方法。这种新方法叫做 [Gnatcatcher](https://github.com/bslassey/ip-blindness)，它会试图隐藏用户的 IP 地址，同时不干涉网站的正常行为。由于 Gnatcatcher 还处于开发中，所以它会根据社区反馈不断进行优化。

关于 Gnatcatcher 的更多细节[见此](https://github.com/bslassey/ip-blindness)。

[这里](https://developer.chrome.com/blog/privacy-sandbox-update-2021-jan/)是 Chrome 团队 2021 年 1 月的更新。

## 总结

为了改变网络生态环境，人们做出过许多大胆的尝试。但大多数尝试都以失败告终，主要原因在于抵触改变的利益相关者何止一二。但若是使用了隐私沙盒方案，Google 声称，与第三方 Cookie 方案相比，广告商和营销商每花费一美元的转化率最多只会下降 5%。另一方面，消费者总是会乐于看到他们的隐私信息在新的模型中更加安全。

但广告和营销领域的从业者自有他们的担忧。他们怀疑 Google 是否能对自家团队和外人做到一碗水端平。Google 自己有专门的广告团队。专家们想知道这些内部团队是否也和外部营销商、广告商及其他广告从业者一样，只能拿到同样的聚合数据。已经有[事实](http://digiday.com/uk/google-winner-googles-anti-tracking-moves-slow-amazons-ad-growth/)能证明 Google 曾经耍花招来保护自己的广告收入份额。如果这次仍是故技重施，那就意味着 Google 的自家团队能获取到更多细粒度的用户数据，这对广告行业的其他从业者是不公平的。如果 Google 打算耍什么花招，等着瞧吧，绝对是一场大乱。

你如何看待这项新提案？它能让网络生态环境更加安全吗？还是说会把权杖递到垄断者的手里？

感谢阅读！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
