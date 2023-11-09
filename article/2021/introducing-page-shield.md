> * 原文地址：[Page Shield: Protect User Data In-Browser](https://blog.cloudflare.com/introducing-page-shield/)
> * 原文作者：[Justin Zhou](https://blog.cloudflare.com/author/justin-zhou)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/introducing-page-shield.md](https://github.com/xitu/gold-miner/blob/master/article/2021/introducing-page-shield.md)
> * 译者：[霜羽 Hoarfroster](https://github.com/PassionPenguin)
> * 校对者：

# Page Shield：保护浏览器中的用户数据

![](https://blog.cloudflare.com/content/images/2021/03/image3-31.png)

今天我们很高兴为大家介绍 Page Shield，一款客户端安全产品，用于检测终端用户浏览器中的攻击。

从 2015 年开始，一个名为 [Magecart](https://sansec.io/what-is-magecart) 的黑客组织通过用恶意代码感染第三方依赖关系来窃取在线商店的支付凭证。受感染的代码会被浏览器调用以让黑客可以获取网页上的用户信息。在抓取信息后，受感染的代码会将这些信息发送给黑客，用于转售或用于发起额外的攻击，譬如说信用卡欺诈和身份盗窃。

此后，此类[供应链攻击](https://en.wikipedia.org/wiki/Supply_chain_attack)的其他目标还包括 Ticketmaster、Newegg、英国航空等。英航的攻击源于他们的一个内置的泄露的 JavaScript 文件，使近 50 万客户的数据暴露在黑客面前。这次攻击导致了 GDPR 的罚款和[「英国历史上最大的集体诉讼隐私案」](https://www.bloomberg.com/news/articles/2021-01-12/british-airways-faces-biggest-class-action-suit-over-data-breach)。总共有数百万用户受到了这些攻击的影响。

在组织或企业内部不用担心第三方插件之类的工具，编写安全代码已经够有挑战性了。许多的 SaaS 平台为数百万个网站提供第三方代码，意味着一次的泄密都有可能会带来毁灭性的结果。Page Shield 帮助客户监控这些潜在的攻击载体，防止用户的机密信息落入黑客之手。

本周早些时候，[我们宣布为所有人提供远程浏览器隔离工具](https://blog.cloudflare.com/browser-isolation-for-teams-of-all-sizes/)，以此来减轻员工浏览器中的受到的客户端攻击。Page Shield 正在继承 Cloudflare 对客户端安全问题的保护战略，帮助减轻针对客户的攻击。

## 背景信息

Magecart 式攻击是一种在用户浏览器中进行的软件供应链攻击。攻击者的目标是第三方 JavaScript 依赖的主机，并且这些主机都获得了提供给浏览器的源代码的控制权。当受感染的代码执行时，它通常会试图窃取终端用户输入网站的敏感数据，如结账流程中的信用卡细节。

检测这些攻击富有挑战性，因为许多应用程序所有者都信任第三方的代码，相信这些 JavaScript 能够按照预期的方式运行。出于这种信任，第三方代码很少被应用程序所有者审核。在许多情况下，Magecart 攻击在被检测发现之前已经持续了几个月。

数据泄露并不是唯一源自软件供应链的风险。近年来，我们还看到黑客修改第三方代码，向用户展示欺诈性广告。用户通过点击这些广告，进入钓鱼网站，他们的个人信息被黑客窃取。其他 JavaScript 恶意软件则利用终端用户资源为攻击者挖掘加密货币，破坏网站性能。

那么应用程序所有者可以做些什么来保护自己呢？现有的浏览器技术，如内容安全策略（CSP）和子资源完整性（SRI），可以对客户端威胁提供一些保护，但也仍然存在着一些缺点。

CSP 使应用程序所有者能够向浏览器发送一个允许列表，防止列表之外的任何资源被执行。虽然这可以防止某些跨站脚本攻击（XSS），但它无法检测到现有资源从良性状态变为恶意状态。管理 CSP 在操作上也具有挑战性，因为它要求开发人员在每次向网站添加新脚本时更新允许列表。

SRI 使应用程序所有者能够为 JavaScript 和其他资源指定一个预期的文件哈希。如果获取的文件与哈希值不匹配，就会被阻止执行。但 SRI 面对着一个很大的问题 —— 供应商经常更新他们的代码，并且在某些情况下向不同的终端用户提供不同的文件。我们还发现，JavaScript 厂商有时会因为间距等小的差异，向最终用户提供不同哈希值的版本文件。这可能会导致 SRI 阻止合法文件的执行，而不是应用程序所有者的过错。

## Script Monitor 是第一个可用的 Page Shield 功能。

脚本监视器是 Cloudflare 对 Page Shield 野心的开始。开启后，它会随时间记录你网站的 JavaScript 依赖关系。当出现新的 JavaScript 依赖关系时，我们会向你发出警报，以便你可以调查它们是否是对你的网站的预期更改。这可以帮助你识别坏人是否修改了你的应用程序以请求新的恶意 JavaScript 文件。一旦测试版完成，这个初始功能集将免费提供给商业和企业客户。

## 脚本监控如何工作？

由于 Cloudflare 在应用程序源服务器和终端用户之间的独特位置，我们可以在响应到达终端用户之前对其进行修改。在这种情况下，我们会在页面通过我们的边缘时，向页面添加一个额外的内容-安全-政策-报告-只读头。当JavaScript文件试图在页面上执行时，浏览器将向 Cloudflare 发送报告。由于我们使用的是纯报告头，因此不需要应用程序所有者维护允许列表以获得相关的见解。

对于我们看到的每一份报告，我们会将 JavaScript 文件与该区域的历史依赖性进行比较，并检查该文件是否是新的。如果是，我们会发出警报，以便客户可以调查并确定是否是预期的变化。

![位于 Firewall -> Page Shield 下的 Script Monitor 用户界面](https://blog.cloudflare.com/content/images/2021/03/image1-40.png)

脚本监控界面位于防火墙->页面屏蔽下。

作为测试版参与者，你将在你的 zone 仪表板的防火墙部分下看到 Page Shield 标签。在那里，你可以找到脚本监控表，跟踪你区域的 JavaScript 依赖性。对于每个依赖项，你可以查看首次看到的日期、最后看到的日期以及检测到它的主机域。

![发现新的 JavaScript 依赖关系的电子邮件通知示例](https://blog.cloudflare.com/content/images/2021/03/image2-34.png)

你还可以在仪表板中配置脚本监视器通知。每当你的网站请求一个新的 JavaScript 文件时，这些通知就会向电子邮件或 PagerDuty 发送警报。

## 未来期望

我们的使命是帮助建立一个更好的互联网。这延伸到终端用户浏览器，在过去的几年里，我们已经看到浏览器的攻击次数惊人地增加。有了 Page Shield，我们将帮助应用程序检测并减轻这些难以捉摸的攻击，以保证用户敏感信息的安全。

我们已经在 Script Monitor 中构建了代码更改检测功能。代码更改检测将定期获取你的应用程序的 JavaScript 依赖关系并分析其行为。当检测到现有文件有新的代码行为时，我们会向你发出警报，这样你就可以查看变化，并确定新代码是良性更新还是受感染的代码。

在代码更改检测之后，即将到来的是对 JavaScript 文件的智能分析。虽然当应用程序所有者的依赖关系发生变化时提醒他们，可以深入了解感兴趣的文件，但我们可以做得更好。我们已经与安全合作伙伴合作，获取了 Magecart JavaScript 的样本，并证明我们可以准确地对恶意 JavaScript 样本进行分类。我们计划进一步完善我们的技术，并最终开始在我们认为他们的依赖关系是恶意的时候向 Page Shield 客户发出警报。

我们已经与客户进行了交流，了解到维护 CSP 允许列表在操作上具有挑战性。如果新的客户端 JavaScript 在没有被添加到允许列表中的情况下部署，那么这些新代码将被浏览器阻止。这就是为什么我们会利用我们作为反向代理的地位来运负安全模型屏蔽。这将允许应用程序所有者阻止单个脚本，而无需维护允许列表，确保客户可以在没有繁琐开销的情况下发布新代码。

## 报名参加测试版

从今天开始，所有商业和企业客户都可以在[这里](https://www.cloudflare.com/waf/page-shield/)注册，加入 Page Shield 的封闭测试版。通过加入测试版，客户将能够激活脚本监视器，并开始监控其网站的 JavaScript。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。