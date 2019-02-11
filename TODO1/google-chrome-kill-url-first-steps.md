> * 原文地址：[GOOGLE TAKES ITS FIRST STEPS TOWARD KILLING THE URL](https://www.wired.com/story/google-chrome-kill-url-first-steps/)
> * 原文作者：[wired.com](https://www.wired.com/story/google-chrome-kill-url-first-steps/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/google-chrome-kill-url-first-steps.md](https://github.com/xitu/gold-miner/blob/master/TODO1/google-chrome-kill-url-first-steps.md)
> * 译者：
> * 校对者：

# 谷歌迈出了消除 URL 的第一步

![](https://media.wired.com/photos/5c50d1e7ffef4d2c9d62f609/master/w_1164,c_limit/Google%20Takes%20Its%20First%20Steps%20Toward%20Killing%20the%20URL.jpg)

今年9月，谷歌 Chrome 安全团队成员提出了一项 [激进的提议](https://www.wired.com/story/google-wants-to-kill-the-url/)：按照我们所知的方式取消网址。研究人员实际上并不主张改变网络的底层基础设施，但是，他们确实希望通过重新设计浏览器来表示您正在查看的网站，这样您就不必面对越来越长且难以理解的网址，以及由于它们 [不断涌现](https://www.wired.com/story/phishing-schemes-use-encrypted-sites-to-seem-legit/) 的欺诈行为。周二在湾区的 Enigma 安全会议上的一次演讲中，Chrome 用户安全团队主管 Emily Stark 谈及了这一充满争论的提议，详细介绍了 Google 迈向更强大的网站标识的第一步。

Stark 强调，谷歌并没有试图通过消除网址来引发混乱。相反，它希望黑客更难以利用用户对网站标识的困惑。目前，复杂 URL 的无尽阴霾让攻击者可以实施有效的诈骗。他们可以创建看似指向合法网站的恶意链接，但实际上会自动将受害者重定向到网络钓鱼页面。或者他们可以设计具有和真实网址看起来一模一样的恶意网页，只要受害者没有注意到他们是在 G00gle 下而不是 Google 就会上当受骗。由于有如此多的恶意网址欺骗，Chrome 团队已经开展了两个项目，旨在为用户提供一些辨识清晰度。

“我们真正讨论的是改变网站标识的呈现方式，”斯塔克告诉 WIRED ，“人们应该很容易知道他们所在的网站，并且他们不应该被误导认为他们在另一个网站上，用户不需要有特别专业的互联网工作原理知识就能解决这个问题。”

到目前为止，Chrome 团队的工作重点是找出如何检测出在某种程度上偏离标准做法的网址，其基础是一个名为 TrickURI 的开源工具，与 Stark 的会议论坛同步发布，可帮助开发人员检查他们的软件是否始终准确地显示 URL 。该工具地目标是为开发人员提供一些测试方法，以便他们知道在不同情况下 URL 将如何呈现给用户。在 TrickURI 工具之外，Stark 和她的同事也在致力于当用户访问地 URL 具有钓鱼页面的潜在可能时为用户创建警告。这些功能仍在进行内部测试，因为复杂的部分正在开发启发式方法，可以正确地标记恶意网站而不会标记合法的网站。*

对于谷歌用户来说，防范网络钓鱼和其他在线诈骗的第一道防线仍然是该公司的 [安全浏览平台](https://www.wired.com/story/google-safe-browsing-oral-history/)。但Chrome团队正在探索安全浏览的补充，专门针对标记粗略网址。

谷歌

“我们用于检测误导性 URL 的启发式方法包括比较看起来彼此相似的字符以及仅由少量字符相互变化的域名，”Stark说，“我们的目标是开发一套启发式方法通过极具误导性的URL将攻击者隔离，其中最大的挑战便是避免将合法域名标记为可疑。这就是我们将其作为一个实验性的功能慢慢发布的原因。”

谷歌表示，在 Chrome 团队改进了这些检测功能之前尚未开始向普通用户群开放警告功能。虽然网址可能不会很快到达任何地方，但 Stark 强调，关于如何让用户关注网址的重要部分以及改进 Chrome 呈现网页标识的形式还有很多需要做的工作。最大的挑战是向人们展示与其安全性和在线决策相关的 URL 部分，同时以某种方式过滤掉使 URL 难以阅读的所有额外组成部分。浏览器有时也需要通过缩短或截断的URL来帮助用户解决问题。

“整个项目非常具有挑战性，因为 URL 现在对某些人和使用场景还能够得到很好的使用，很多人都喜欢它们，” Stark 说，“我们对使用新的开源 URL-display TrickURI 工具以及我们对可能被混淆的 URL 的还在探索的警告功能所取得的进展感到兴奋。”

Chrome 安全团队之前已经解决了很多互联网范围内的安全问题，并在 Chrome 中为他们开发了修复程序，然后抛出了 Google 的重要性以激励每个人采用这种做法。在过去的五年中，该策略在[促进普遍采用](https://www.wired.com/2016/11/googles-chrome-hackers-flip-webs-security-model/) 网络加密的过程中取得了特别的成功。Bu但是[这种方法的批判者](https://www.wired.com/story/google-chrome-https-not-secure-label/)担心 Chrome 的功能和普遍存在的缺点在用于积极的改变的同时也可能被误用或滥用。作为URL的基础，批判者们担心 Chrome 团队会利用修改网站标识的显示策略，这些策略对 Chrome 有利，做一些实际上并没有使网页的其余部分受益的行为。即使是看似微不足道的 Chrome 变化也对 Web 社区的产生了[重大影响](https://www.wired.com/story/google-chrome-login-privacy/)。

此外，这种无处不在的权衡取决于对风险厌恶的企业客户。专注于披露漏洞的公司 Luta Security 的创始人 Katie Moussouris 说：“线上的网址通常无法传达给用户可以快速识别的风险等级，但随着 Chrome 在企业级的选择，而不是消费领域，他们能够彻底改变可见界面和底层安全架构的能力而将因客户的压力而降低。大受欢迎的不仅仅是保护人们安全的重大责任，还有最大限度地减少原本特色的流失、提升可用性和向后兼容性。”

如果这听起来像特别令人困惑和令人沮丧的工作，那就说明它一定是重点。接下来的问题将是 Chrome 团队的新想法如何在实践中发挥作用，以及它们是否真的最终让您在互联网上更安全。

*_Correction January 29, 10:30pm: This story originally stated that TrickURI uses machine learning to parse URL samples and test warnings for suspicious URLs. It has been updated to reflect that the tool instead assesses whether software displays URLs accurately and consistently._
* 更正于1月29日晚上10:30：这篇文章最早写的是 TrickURI 使用机器学习来解析 URL 样本并测试可疑 URL 的警告。它已经过更新，以反映该工具是评估软件是否能够一直准确地显示URL。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
