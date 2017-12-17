> * 原文地址：[What Face ID Means for Accessibility](https://www.stevensblog.co/blogs/what-face-id-means-for-accessibility?utm_source=SitePoint&utm_medium=email&utm_campaign=Versioning)
> * 原文作者：[steven](https://www.stevensblog.co)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/what-face-id-means-for-accessibility.md](https://github.com/xitu/gold-miner/blob/master/TODO/what-face-id-means-for-accessibility.md)
> * 译者：[winry01](https://github.com/winry01)
> * 校对者：

# FACE ID 对易用性意味着什么

当苹果在 2013 年 iPhone 5s 中引入 Touch ID 时，我写了 [一篇](https://medium.com/@steven_aquino/on-touch-id-and-accessibility-eff1391cff91) 假定指纹识别在优化易用性的文章。我写到，一部分是:

> 我了解到的 Touch ID 正是通过简单的使用拇指指纹（或其它手指）替代密码来解锁他们的手机，从而帮助人们解决前述的运动灵敏问题。更特别的是，Touch ID 使使用者免于手动输入密码的困扰。
> 
> 我的看法与其是关于便利性（的确很棒）倒不如说是可用性。我知道许多有视力和运动问题的人会抱怨 iOS 的密码提示，因为这不仅需要时间，而且输入密码也不是一件容易的事情。事实上，不止一些人感叹这样的话，他们总是放弃密码，因为这样做非常耗时，而且很痛苦（有时候这毫不夸张）。

四年后，iPhone X 上 Face ID 的诞生象征着生物识别安全进入下一个阶段。这也是很特别很出色的，尽管在安全性，便利性**和**易用性方面 Touch ID 同样优秀，但Face ID 甚至更好。[在我短暂的 iPhone X 时光](https://www.stevensblog.co/blogs/my-first-week-with-iphone-x)，我已经发现 Apple 的面部识别技术几乎可以在任何领域击败 Touch ID 。更别提我能**用我的脸**来解锁我的手机和购物是多么酷炫的事情。

生活在前沿技术的时代很有趣。

## 面对我的 Face ID 难题

在我的第一印象故事中，我注意到 iPhone X 上的 Face ID 是迄今为止“最具启发性”的设备。具有启发性的是它教给我关于我自身事情的方式，即我是一个边缘案例。我第一次使用苹果产品时，我感觉到自己被迫适应技术，而不是让技术适应我。

也就是说，我有一种特殊状况称为 [斜视](https://en.wikipedia.org/wiki/Strabismus)，就是一个或两个眼睛不能直看。对我来说，是左眼 —— 巧合的是，也是我的主力眼 —— 似乎对 TrueDepth 相机系统造成了混乱。在我最初尝试设置 Face ID 时，我不能用 Face ID 来解锁我的电话。设置过程很顺利 —— Face ID 成功的获取到我的脸部，但是再一次，当解锁电话或登录应用程序如 1Password 时它不能识别到我。这很让人沮丧。

由于 Face ID **是** iPhone X的最重要的功能，这体验很不好。

在一些错误定位后，总算有一个解决方案。通过一些测试，我判断我是那些需要与 iPhone X「眼神交流」才能使它正常工作的用户之一。因此，解决的办法是去 Face ID 的设置并关闭需要注意的特征（Settings > Face ID & Passcode > Require Attention for Face ID）。通过禁用Require Attention，Face ID 如臂使指。做诸如解锁我的手机，登录 1Password 和苹果支付等都是很轻松的。

唯一需要注意的是，我仍然不习惯把手机放在足够远的地方让 Face ID 可以读取到我的脸部信息。由于我的视力低，需要靠近看，本能地把手机靠近我的脸。Face ID 显然不能在这个角度识别我，所以我倾向于使用接触，你无法使劲「摇头」登录。我拥有 iPhone X 仅有两周，所以还要花费更多的时间来开发新的肌肉记忆。不过，我可以解决这个问题，因为我知道这个技术没有问题，苹果也不会给我一个修复过的特殊版本，正如我最初担心的那样。 一切都按照预期设计地工作 —— 我只需要学习新的习惯。

特别是 iPhone X，用十年的 iPhone 使用习惯来忘却。

## 为什么 Face ID 击败 Touch ID

所以什么使 Face ID 比 Touch ID更易访问？

就一点，设置速度要快得多，而且更不费力。虽然录入 Touch ID 一点也不困难，但速度相对较慢并且「准确」。iOS 提示你这样那样移动手指，并且当你不按照它的指示操作时会出现问题。如果你是一个精细运动技能有限的人，那么 Touch ID 的设置就是一种痛苦。

相反，设置 Face ID 至少**感觉**更合理更简洁。正如苹果给我描述的一样，移动你的头「像你在用你的脸画一个圈」，对于某些确实严重运动受限的人来说可能很困难，但有一个易用性选项来省略这一步骤。（系统将以固定的角度进行单次拍摄，而不是移动头部以获取深度图。）如果对你来说转动脑袋不太可能或很烦，苹果也通过设置界面覆盖了你这样的用户。虽然，Touch ID 并没有衰退，但我发现，设置Face ID 比以前更简单快捷。这当然都是因为苹果数年研究用户数据和微调 BiometricKit 的缘故。

除了安装之外，面部识别的另一个优势在于它的存在为许多残疾用户消除了摩擦点（Touch ID 传感器）。不管 Touch ID 有多易用，需要触碰和/或按动对很多人而言仍是麻烦。替代了通过触碰来鉴权所有事务，现在人们要做的只是是**注视**他们的手机。这无疑也是方便的，但重要的是从易用性角度看，面部意味着自由。自由是指有一个更好的依赖于技术的前进方向，也意味着减少可能的障碍。

苹果公司在 iOS 平台上基于硬件和智能软件建立了 Face ID ，使得使用 iPhone 在许多方面具有真正意义上的「免提」体验。这没有辅助功能，如开关控制或AssistiveTouch。这对包括我自己在内的用户产生了重大的影响，使具有身体缺陷的我们面对即使是最平凡的任务（例如，解锁一个设备）也显得棘手。就像许多与易用性相关的话题一样，那些被认为是理所当然的小事总是在塑造积极体验方面产生最大的变化。

## 在  Face ID 上苹果支付

作为一种无障碍的支付方式，我已经记录文章（[这篇](http://m.imore.com/apple-pay-and-empowering-nature-inclusive-design) 和 [这篇](http://www.imore.com/apple-watch-makes-apple-pay-even-better-accessibility)）来赞美苹果支付。自 2014 年首次亮相以来，我一直使用它，但仍然惊讶它做的很棒。这真是一个神奇的服务。

在 iPhone X 上的 Face ID 将苹果支付带向了下一个级别。在少数时间我在 iPhone X 上使用苹果支付（为了支付 Lyft 游戏机），Face ID 提供了更加无缝的体验。与解锁一样，苹果支付与 Face ID 绑定的优势在于确认您的购买。（双击侧按钮启动即可。）它的免提性意味着我不必担心让我的拇指处于正确的位置，或者花时间等待授权。

因为我是 Apple Watch 的佩戴者，尽管苹果支付在手机上很好，但我不经常在 iPhone 上使用这项服务。在我的手腕上使用更好，但我很高兴苹果让手势在各种设备上更加一致。不论如何，我**确实**在 iPhone 上使用苹果支付时，Face ID 使得它更快，更容易，更易于使用。

## 关于 Touch ID API 的简要说明

值得一提的是，我相信共用的 Touch ID/Face ID API 在易用性上有很大影响。对我来说，出乎意料的好。

原因在于，通过让开发人员将生物识别技术整合到应用程序中，苹果正在有效地确保第三方应用程序更易于访问。
我仍然同意 Marco Arment 的看法 [认为公司应该使得应用程序成为其审查的一个大门](https://marco.org/2014/07/10/app-review-should-test-accessibility)，但就目前而言，仅仅事实上，App Store 应用程序有权访问这些生物识别功能，智能访问。我已经能够使用我的拇指（现在我的脸）进入我的 1Password，意味着应用程序已经很容易访问，没有任何设计细节的批评。这样肯定胜过每次都输入一个密码。

当然 [许多开发者需要做的是](http://techcrunch.com/2014/08/02/reuters-rebuttal/) 确保他们的应用程序是所有人可以访问的，但是这些 API 肯定会让他们和用户遥遥领先。这并不是微不足道的，苹果在认识到这方面好处上可能很有先见之明，这是值得赞扬。 这是该工具包的一个重要补充。

## （无障碍）智能手机的未来

现在每个拥有 iPhone X 的人都仍然处于蜜月期，时间会告诉你随着设备的老化而变化的感觉。在我的使用到目前为止，我很清楚，苹果建立 iPhone X 的方式，所谓的智能手机的「未来」是可预见的。

iPhone X 取得了很大的飞跃，但 Face ID 仍是最大的。 它比配有获得高度评价的 Touch ID 的前代产品更为出色。 在我的文章部分有一些必要的调整，但我仍未完结对 Face ID 的畅所欲言。 这实在是愉快的，可靠的，易用的。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
