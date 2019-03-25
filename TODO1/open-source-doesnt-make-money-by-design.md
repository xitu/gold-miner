> * 原文地址：[Open Source Doesn't Make Money Because It Isn't Designed To Make Money](https://www.ianbicking.org/blog/2019/03/open-source-doesnt-make-money-by-design.html)
> * 原文作者：[Ian Bicking](https://www.ianbicking.org/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/open-source-doesnt-make-money-by-design.md](https://github.com/xitu/gold-miner/blob/master/TODO1/open-source-doesnt-make-money-by-design.md)
> * 译者：[kasheemlew](https://github.com/kasheemlew)
> * 校对者：[Long Xiong](https://github.com/xionglong58), [Jack Tang](https://github.com/JackEggie)

# 开源是无法赚钱的，因为开源本身就不是为了赚钱

> 还是说：**做一件事最好的方式就是至少尝试一下**

我们都知道：在开源领域是没法赚钱的。确实如此吗？

我之所以会有这种想法，是因为 Mozilla 希望在接下来的几年里实现收入多样化，但是由于我们做的所有工作都是开源的，所以会受到一些约束。

已经有几十个（几百个？）成功的开源项目组试图转型成小型的商业企业，其中有一些做得非常认真，但结果却不尽人意。

我本人目前也在尝试推动 Mozilla 的商业化（如果制定计划但不实践可以称为“尝试”的话），在我得到的反馈中常有人提出这个问题：我们可以出售开源的东西吗？

没有任何证据表明我们可以（或者不行），但是我可以断言：我们很难出售一个本身不是为了赚钱的东西。

我们将开源视为商业产品的毒药。的确，由于开源许可证的存在，我们很难强制别人为这种产品付费，但有很多成功的商业案例并没有**强制**任何人。

我发现有一个隐含假设让这种想法更加困难：好用的东西肯定容易赚钱。这是一种不言而喻的道德期待，就像一种正义世界假说：实用的、能帮助人们、全世界都需要的、对他人有益的东西总能带来一些赚钱的机会。这种事应该有可能成为你的日常工作，让你赚钱，让你在这件事上付出的努力能够有所回报。

我们认为世界**应该**是这样的，但事实并不如此。你不可能靠从事音乐或者艺术谋生。你甚至都不能靠照顾孩子谋生。我觉得这是现在很多人批判资本主义的基础：有太多重要的、必需的东西，它们比任何可获利的东西都能充实我们，但在经济上却不可持续。

在这篇文章中，我不会尝试改变这一点，但请记住：不是所有美好的东西都能赚钱。

但我们知道软件中是有利可图的，而且有很多利！是靠闭源赚钱吗？如果 OpenSSL 是闭源的，它还能赚钱吗？如果它的许可收费，它还能赚钱吗？应该不能。许可证并无大碍，只是包装得不像赚钱的东西了。只解决重要的问题还不够。

所以你能靠什么赚钱呢？

1.  用户愿意为应用程序花点钱；但不多，只有一点点。发展需要市场和资本，这两点在开源项目中很难找到（我怀疑有些开源项目就算有了资本也不知道该怎么做）。
2.  广告总是很好赚钱。不幸的是，这可能会冒犯到一些人，他们会删除你的开源软件中的广告，然后重新打包。作为[价格歧视](https://zh.wikipedia.org/wiki/%E4%BB%B7%E6%A0%BC%E6%AD%A7%E8%A7%86)（例如，移除付费广告）的一种形式，我认为你可以避免用户流失。
3.  完全托管服务：[Automattic](https://automattic.com/) 的 wordpress.com 是一个很好的例子。[Ghost](https://ghost.org/) 做得怎么样呢？这些都是完整的解决方案：你得到的不是一个软件，而是整个网站。
4.  如果你能保证用户可以得到一个个性化的解决方案，他们会愿意付钱的。也就是咨询（consulting）。对于软件（software）来说就是 [consultingware](https://www.joelonsoftware.com/2002/05/06/five-worlds/)。尽管经常会受到诋毁，但实际上很多企业都建立在这一点之上，我认为 Drupal 就是其中之一。
5.  人们会为你的专注和持续的付出买单。换句话说：一个雇员的日常工作。将这一点放在这个列表中是不公平的，但这对于 consultingware 来说顺理成章。况且作为开源的一种主导模式，我认为它是值得肯定的。
6.  任何与物理设备配对的东西。人们会同时基于硬件和软件体验来评价一个东西的价值。
7.  我不太确定 Firefox 是否（直接）通过广告赚钱，或者把这当作对他们维持垄断地位的补偿。

我肯定还遗漏了一些有趣的想法。

但是如果你有一个商业理念，觉得它可能有效，开源和它又有什么关系呢？我们难道不知道：关注你的业务！关注你的客户！软件许可证可能是一种干扰，即使**软件**是个值得关注的问题，但这与业务无关。也许这就是你不能通过开源赚钱的原因：这是条歪路。这个问题不是对比开源和专利，而是比较开源和以商业为中心的理念。

从另一个角度看：你准备把产品卖给谁？传统的自挠其痒式的开源软件是程序员**为**程序员打造的，而且非常成功，但这是将产品卖给不愿付钱的用户。他们只想用这个软件来提高个人生产率（这种做法很明智，程序员们因此涨了工资）。我们能把开源软件卖给其他人群吗？其他人可以**利用**源码吗？

因此，我对开源能取得商业成功保持悲观，也有些心塞：**除了**商业产品，有很多软件都是开源的。尽管已经取得了巨大的成功，但自由软件的使命却止步不前：人们真正使用到的软件并不是自由开放的，这是一种遗憾。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
