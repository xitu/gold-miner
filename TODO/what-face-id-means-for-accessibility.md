> * 原文地址：[What Face ID Means for Accessibility](https://www.stevensblog.co/blogs/what-face-id-means-for-accessibility?utm_source=SitePoint&utm_medium=email&utm_campaign=Versioning)
> * 原文作者：[steven](https://www.stevensblog.co)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/what-face-id-means-for-accessibility.md](https://github.com/xitu/gold-miner/blob/master/TODO/what-face-id-means-for-accessibility.md)
> * 译者：[winry](https://github.com/winry01)
> * 校对者：[Ziheng Gao](https://github.com/noahziheng) [Yong Li](https://github.com/NeilLi1992)

# FACE ID 对易用性意味着什么

当苹果在 2013 年 iPhone 5s 中引入 Touch ID 时，我写了 [一篇](https://medium.com/@steven_aquino/on-touch-id-and-accessibility-eff1391cff91) 有关指纹识别在易用性方面的改善的文章。其中一部分我写到：

> 我了解到的 Touch ID 正是通过简单的使用拇指（或其它手指）的指纹替代密码来解锁他们的手机，从而帮助人们解决前述的运动灵敏度问题。更特别的是，Touch ID 使使用者免于手动输入密码的困扰。
> 
> 我的看法与其说是关于便利性（的确很棒）倒不如说是可用性。我知道许多有视力和运动问题的人会抱怨 iOS 的密码输入，因为这不仅需要时间，而且输入密码也不是一件容易的事情。事实上，不少人不止抱怨，甚至彻底取消了密码，因为这样做非常耗时，而且很痛苦（有时候这毫不夸张）。

四年后，iPhone X 上 Face ID 的诞生象征着生物识别的安全性进入下一个阶段。这也是很特别很出色的，尽管在安全性，便利性**和**易用性方面 Touch ID 同样优秀，但 Face ID 甚至更好。[在我短暂的 iPhone X 使用体验中](https://www.stevensblog.co/blogs/my-first-week-with-iphone-x)，我已经发现 Apple 的面部识别技术几乎可以在任何领域击败 Touch ID 。更别提我能**用我的脸**来解锁我的手机和购物是多么酷炫的事情。

生活在前沿技术的时代很有趣。

## 面对我的 Face ID 难题

在我的第一印象中，我注意到 iPhone X 上的 Face ID 是迄今为止这台设备上「最赞」的特性。它启发我认识到我是一个特例。自我使用苹果产品以来，这是第一次我感觉到自己被迫适应技术，而不是让技术适应我。

困难在于，我有一种特殊状况称为 [斜视](https://en.wikipedia.org/wiki/Strabismus)，就是一个或两个眼睛不能直看。对我来说，是左眼 —— 巧合的是，也是我的主力眼 —— 似乎对 TrueDepth 相机系统造成了混乱。在我最初尝试设置 Face ID 时，我不能用 Face ID 来解锁我的电话。设置过程很顺利 —— Face ID 成功地获取到我的脸部，但是，当我再一次解锁电话或登录应用程序如「1Password」时它不能识别到我。这很让人沮丧。

由于 Face ID **是** iPhone X 的最重要的功能，这体验很不好。

经过一些错误定位，总算有了一个解决方案。通过一些测试，我判断我是属于无法通过「眼神交流」来使 iPhone X 正常工作的特殊用户之一。因此，解决的办法是去 Face ID 的设置并关闭「注视感知功能」功能(「设置」>「面容 ID 与密码」>「注视感知功能」)。通过禁用「注视感知功能」，Face ID 如臂使指。完成诸如解锁我的手机，登录「1Password」和苹果支付等任务都是很轻松的。

唯一需要注意的是，我仍然不习惯把手机放在足够远的地方让 Face ID 可以读取到我的脸部信息。由于我的视力低，需要靠近看，我会本能地把手机靠近我的脸。Face ID 显然不能在这个角度识别我，所以我倾向于使用接触，你无法使劲「摇头」登录。我拥有 iPhone X 仅有两周，所以还要花费更多的时间来开发新的肌肉记忆。不过，我可以解决这个问题，因为我知道这个技术没有问题，苹果也不会给我一个修复过的特殊版本，正如我最初担心的那样。一切都按照预期设计地工作 —— 我只需要学习新的习惯。

特别是 iPhone X，背负着十年的 iPhone 使用习惯要忘却。

## 为什么 Face ID 击败了 Touch ID

所以什么使 Face ID 比 Touch ID更易用？

其中一点，设置速度要快得多，而且更不费力。虽然录入 Touch ID 一点也不困难，但速度相对较慢并且「要求精确」。iOS 提示你这样那样移动手指，并且当你不按照它的指示操作时会出现问题。如果你是一个精细运动技能有限的人，那么 Touch ID 的设置就是一种痛苦。

相反，设置 Face ID 至少**感觉**更合理更简洁。正如苹果给我描述的一样，移动你的头「像你在用你的脸画一个圈」，对于有点 “非精细运动技能” 受限的人来说可能很困难，但有一个易用性选项来省略这一步骤。（系统将以固定的角度进行单次拍摄，而不是移动头部以获取深度图。）如果对你来说转动脑袋不太可能或很烦，苹果也通过设置界面覆盖了你这样的用户。虽然，Touch ID 并不差，但我发现，设置 Face ID 比以前更简单快捷。这当然都是因为苹果数年研究用户数据和微调 BiometricKit 的缘故。

除了设置之外，面部识别的另一个优势在于它的存在为许多残疾用户消除了不便（Touch ID 传感器）。不管 Touch ID 有多易用，需要触碰和/或按动对很多人而言仍是麻烦。现在人们要做的只是是**注视**他们的手机，而无需再用触碰来授权一切。。这无疑也是方便的，但重要的是从易用性角度看，面部意味着自由。自由是指有一个更好的依赖于技术的前进方向，也意味着减少可能的障碍。

苹果公司在 iOS 平台上基于硬件和软件方面建立了 Face ID ，使得使用 iPhone 在许多方面具有真正意义上的「免提」体验。这还不用提其它独立的辅助功能，如开关控制或AssistiveTouch。这对具有身体缺陷，即使最基础的任务（例如，解锁一个设备）都无法完成的用户，包括我自己来说，确实是巨大的改进。就像许多与易用性相关的话题一样，那些被认为是理所当然的小事总是在塑造积极体验方面产生最大的变化。

## 关于 Face ID 和苹果支付

作为一种无障碍的支付方式，我写下了（[这篇](http://m.imore.com/apple-pay-and-empowering-nature-inclusive-design) 和 [这篇](http://www.imore.com/apple-watch-makes-apple-pay-even-better-accessibility)）来赞美苹果支付。自 2014 年首次亮相以来，我一直使用它，但仍然惊讶它做的很棒。这真是一个神奇的服务。

在 iPhone X 上的 Face ID 将苹果支付带向了下一个级别。我在 iPhone X 上为数不多的几次苹果支付的使用中（为了支付 Lyft 乘车），Face ID 提供了更加无缝的体验。与解锁一样，苹果支付与 Face ID 绑定的优势在于确认您的购买。（双击侧按钮启动即可。）它的免提性意味着我不必担心让我的拇指处于正确的位置，或者花时间等待授权。

因为我是 Apple Watch 的佩戴者，尽管苹果支付在手机上很好，但我不经常在 iPhone 上使用这项服务。在我的手腕上使用更好，但我很高兴苹果让手势在各种设备上更加一致。不论如何，我**确实**在 iPhone 上使用苹果支付时，Face ID 使得它更快，更容易，更易于使用。

## 关于 Touch ID API 的简要说明

值得一提的是，我相信公共的 Touch ID/Face ID API 在易用性上有很大影响。对我来说，出乎意料的好。

原因在于，通过让开发人员将生物识别技术整合到应用程序中，苹果正在有效地确保第三方应用程序更易于访问。我仍然同意 Marco Arment 的看法 [认为公司应该把易用性作为应用程序审查的一个重点](https://marco.org/2014/07/10/app-review-should-test-accessibility)，但就目前而言，仅仅是 App Store 中的应用能够调用生物识别功能这一事实，已经使他们在易用性方面立于不败之地。我已经能够使用我的拇指（现在我的脸）进入我的「1Password」，意味着应用程序已经很容易访问，甚至无需评价其它设计细节。这样肯定胜过每次都输入一个密码。

当然 [许多开发者需要做的是](http://techcrunch.com/2014/08/02/reuters-rebuttal/) 确保他们的应用程序是所有人可以访问的，但是这些 API 肯定会让他们和用户遥遥领先。这并不是微不足道的，苹果在认识到这方面好处上可能很有先见之明，这是值得赞扬。 这是该工具包的一个重要补充。

## （无障碍）智能手机的未来

现在每个拥有 iPhone X 的人都仍然处于蜜月期，时间会告诉你随着设备的老化而变化的感觉。我自己用到目前为止，我很清楚，苹果用这样一种方式来创造 iPhone X，使得智能手机更加易用的「未来」是可以实现的。

iPhone X 取得了很多的飞跃，但 Face ID 仍是最大的。 它比配备了广受赞誉的 Touch ID 功能的前代产品更为出色。从我的角度来看它还需要一些必要的调整，但但我仍对 Face ID 赞不绝口。这实在是愉快的，可靠的，易用的。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
