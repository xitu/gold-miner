> * 原文地址：[12 best practices for user account, authorization and password management](https://cloudplatform.googleblog.com/2018/01/12-best-practices-for-user-account.html)
> * 原文作者：[Google Cloud Platform](https://cloudplatform.googleblog.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/12-best-practices-for-user-account.md](https://github.com/xitu/gold-miner/blob/master/TODO/12-best-practices-for-user-account.md)
> * 译者：[Wangalan30](https://github.com/Wangalan30)
> * 校对者：[ryouaki](https://github.com/ryouaki), [Potpot](https://github.com/Potpot)

# 用户账户、授权和密码管理的 12 个最佳实践

账户管理、授权和密码管理问题可以变得很棘手。对于很多开发者来说，账户管理仍是一个盲区,并没有得到足够的重视。而对于产品管理者和客户来说，由此产生的体验往往达不到预期的效果。

幸运的是，[Google Cloud Platform](https://cloud.google.com/) (GCP) 上有几个工具，可以帮助你在围绕用户账户（在这里指那些在你的系统中认证的客户和内部用户）进行的创新、安全处理和授权方面做出好的决定。无论你是在 [Google Kubernetes Engine](https://cloud.google.com/kubernetes-engine/) 上负责网站托管，还是 [Apigee](https://cloud.google.com/apigee-api-management/) 上的一个 API，亦或是 一个应用[Firebase](https://firebase.google.com/) 或其他拥有经过身份认证用户服务的 APP，这篇文章都会为你展示出最佳实践，来确保你拥有一个安全、可扩展、可使用的账户认证系统。

## 对密码进行散列处理

账户管理最重要的准则是安全地存储敏感的用户信息，包括他们的密码。你必须神圣地对待并恰当地处理这些数据。

不要在任何情况下存储明文密码。相反，你的服务应该存储经过散列处理之后的、不可逆转的密码 —— 比如，可以用 PBKDF2、SHA3、Scrypt 或 Bcrypt 等这些散列算法。同时，散列时还要进行 [加盐](https://www.owasp.org/index.php/Password_Storage_Cheat_Sheet#Use_a_cryptographically_strong_credential-specific_salt) 处理，同时，盐值也不能和登陆用的验证信息相同。不要用已经弃用的哈希技术比如 MDS 和 SHA1，并且，任何情况下都不要使用可逆加密方式或者 [试着发明自己的哈希算法](https://www.schneier.com/blog/archives/2011/04/schneiers_law.html)。

在设计系统时，应该假设你的系统会受到攻击，并以此为前提设计系统。设计系统时要考虑“如果我的数据库今天受损，用户在我或者其他服务上的安全和保障会有危险吗？我们怎样做才能减小事件中的潜在损失。”

另外一点：如果你能够根据用户提供的密码生成明文密码，那么你的系统就是有问题的。

## 如果可以的话，允许第三方提供身份验证

使用第三方提供身份验证，你就可以依赖一个可靠的外部服务来对用户的身份进行验证。Google、Facebook 和 Twitter 都是常用的身份验证提供者。

你可以使用 [Firebase Auth](https://firebase.google.com/docs/auth/) 这样的平台在已有的身份验证体系的基础上再添加额外的身份验证方式。使用 Firebase Auth 有许多好处，比如更简单的管理、更小的受攻击面和一个多平台的 SDK。通过这个清单我们可以接触更多的益处。查看我们专为企业设计的的 [案例](https://firebase.google.com/docs/auth/case-studies/)，可以让你在一日之内集成 Firebase Auth。

## 区分用户身份和用户账户的概念

你的用户并不是一个邮件地址，也不是一个电话号码，更不是由一个 OAUTH 回复提供的特有 ID。他们是你的服务中，所有与之相关的独特、个性化的数据和经验呈现的最终结果。一个设计优良的用户管理系统在不同用户的个人简介之间低耦合且高内聚。

在概念上将用户账户和证书区分开可以极大地简化使用第三方身份验证的过程，允许用户修改自己的用户名，并关联多个身份到单一用户账户上。在实用阶段，这样可以使我们对每个用户都有一个内部的全局标识符，并通过这个 ID 将他们的个人简介与身份验证相关联，而不是将它全部堆放在一条记录里。

## 允许单一用户账户关联多重身份

一个每星期用 [用户名和密码](https://firebase.google.com/docs/auth/web/password-auth) 在你的服务上认证的用户，往往会选择下次登录使用 [Google 登录](https://firebase.google.com/docs/auth/web/google-signin)，但是他们可能没意识到这样会创建重复的账户。同样的，一个用户可能将多个邮件地址连接到你的服务上。如果你能够正确地将用户的身份和认证区分开，那么 [关联多个身份](https://firebase.google.com/docs/auth/web/account-linking) 到一个单一用户上将是一件十分简单的事情。

你的系统需要考虑这样一种情况：当用户已经进行了一部分或者已经完成了整个注册过程之后，他们才意识到，他们正在使用一个与他们已有的账户完全无关的新的第三方身份。要解决这个问题可以简单地要求客户提供一份普通的身份细节，比如邮件地址、电话或用户名等。如果这份数据与系统中已有的用户相匹配，则需要他们使用已知的身份认证，并将新的 ID 关联到他们已有的账户上。

## 不要限制较长或者复杂的密码

NIST 最近在 [密码的复杂度和强度](https://pages.nist.gov/800-63-3/sp800-63b.html#appendix-astrength-of-memorized-secrets) 上更新了指南。既然你正在（或者很快就要）使用一个强加密的哈希值来进行密码存储，那么大部分的问题已经解决了。无论输入内容的长短，哈希值总会生成一个固定长度的输出值，所以你的用户应该根据自己喜好的长度设置自己的用户密码。如果你必须限制密码的长度，请按照你的服务器所允许的 POST 的最大值来设置。实际来说。这通常超过1M。

你的哈希密码将包含一小部分已知的 ASCII 码。如果不是，你可以轻易地将一个二进制的哈希值转成 [Base64](https://en.wikipedia.org/wiki/Base64)。考虑到这一点，你应该允许你的用户在设置密码时自由地使用任何他们想要的字符。如果有人想要一个由 [Klingon](https://en.wikipedia.org/wiki/Klingon_alphabets)、[Emoji](https://en.wikipedia.org/wiki/Emoji#Unicode_blocks) 以及两端带有空格的控制字符组成的密码，你不能因任何技术实现上的理由而拒绝他们。

## 不要对用户名强加不合理的规则

如果一个网站或服务要求用户名长度必须大于两个或三个字 符、限制隐藏字符或不允许用户名的两端带有空格，这都不属于不合理的范畴。然而，有些网站的要求未免有些极端，比如，最小长度为八个字符或不允许使用任何大于 7bit 的 ASCII 字母和数字。

一个对用户名要求严格的站点会给开发者提供一些捷径，但这却是以用户的损失为代价的，同时，一些极端的情况也会带走一定数量的用户。

有些情况需要我们分配用户名。如果你的服务属于这些情况，要确保用户名能够使用户在回想或交流时感觉到足够友好。由字母和数字组成的 ID 应该尽量避免会在视觉上会产生歧义的符号，比如“Il1O0”。同时，我们建议你对所有随机生成的字符串进行字典扫描，以确保没有嵌入用户名中的意外信息。这些相同的准则适用于自动生成的密码。

## 允许用户修改用户名

令人普遍感到惊讶的是，原有系统或是其他提供邮箱账户的平台都不允许用户修改他们的用户名。我们有很多 [正当理由](https://www.computerworld.com/article/2838283/facebook-yahoo-prevent-use-of-recycled-email-addresses-to-hijack-accounts.html) 不允许重用已经自动回收的用户名，但是如果你的长期用户突然想要换个新的用户名，最好能不用另外新建一个账户。

你可以允许使用别名，并让你的用户选择一个首要的别名，以此来满足他们想要修改自己用户名的要求。你可以在此功能之上应用任何你需要的商务规则。有些系统可能会允许用户一年修改一次用户名或者只显示用户的别名。电子邮件服务提供商应该可以确保用户在将旧用户名与他们的账户分离开，或是完全禁止断开旧用户名之前，已经充分的了解了其中的风险。

为你的平台选择正确的规则，但是要确保他们允许你的用户随着时间增长和变化。

## 让你的用户删掉他们的账户

没有提供自助服务的服务系统数量惊人，这对一个用户来说就意味着删掉他们的账户和相关数据。对一个用户来说，永久地关掉一个账户并删掉所有的个人数据有很多的好理由。这些需求点需要与你的安全性和顺从性需求相平衡，但大多数受监管的环境都会提供有关数据存储的相关指导。为避免顺从性以及黑客的关注，一个较普遍的做法是让用户安排他们的账户，以便未来自动删除。

在某些情况下，你可能会 [被合法地要求遵照](http://ec.europa.eu/justice/data-protection/files/factsheets/factsheet_data_protection_en.pdf) 用户的需求及时的删掉他们的数据。同样，当“已关闭”账户的数据泄漏时，你也会极大的增加你的曝光率。

## 在对话长度上做出理智的选择

安全和认证中一个经常被忽视的方面是 [会话长度](https://firebase.google.com/docs/auth/web/auth-state-persistence)。Google 在 [确保用户是他们所说的人](https://support.google.com/accounts/answer/7162782?co=GENIE.Platform%3DAndroid&hl=en) 方面做了很多努力，并将基于某些事件或行为进行二次确认。用户可以采取措施 [进一步提高自己的安全度](https://support.google.com/accounts/answer/7519408?hl=en&ref_topic=7189123)。

你的服务可能有充分的理由为非关键的分析目的保持一段会话无限期开放，但是这应该有 [门槛](https://pages.nist.gov/800-63-3/sp800-63b.html#aal1reauth)，要求输入密码，第二因素或其他用户验证。

考虑一个用户在重新认证之前需要保持多长时间的非活跃状态。如果某人想要执行密码重置，需要在所有活跃会话中验证用户身份。如果一个用户想要更改他们个人信息的核心内容，或者当他们在执行一次敏感的行为时，提示进行身份验证或第二因素。要考虑不允许同时在不同设备或地址登录是否有意义。

当你的服务终止用户会话或需要再次验证时，实时提示用户或提供一种机制来保存自他们上次验证后还没来得及保存的全部活动。对用户来说，当他们填好一份很长的表格并在之后提交，却发现他们输入的所有信息全部丢失且他们必须再次登录，这是十分令人沮丧的。

## 使用两步身份验证

要考虑当用户选择 [两步验证](https://www.google.com/landing/2step/) (也称两因素验证或只是 2FA)方法而账户被盗后的实际影响。由于有许多缺陷，SMS 2FA 认证 [被 NIST 反对](https://pages.nist.gov/800-63-3/sp800-63b.html)，然而，它或许是你的用户考虑到这是一项微不足道的服务时会接受的最安全的选择了。请尽可能提供你能提供的最安全的 2FA 认证。支持第三方身份验证和在他们的 2FA 上面打包是个十分简单的方法，使你能够不花费太多力气就能提高你的安全度。

## 用户 ID 不区分大小写

你的用户不会关心或者甚至可能并不记得他们确切的用户名。用户名应该完全不区分大小写。与输入时将所有字符转换为小写相比，存储时将用户名和邮件地址全部保存为小写显得十分微不足道。

智能手机的使用代表用户设备所占的比重不断增加。他们大多数提供纯文本字段的自动更正和首字母自动大写功能。

## 建立一个安全认证系统

如果你在使用一个像 Firebase Auth 一样的设备，大量的安全隐患都会自动帮你处理。然而，你的设备总是需要正确地设计以防滥用。核心的问题包括实现 [密码重置](https://firebase.google.com/docs/auth/web/manage-users#send_a_password_reset_email)而不是密码检索，详细账户活动日志，限制登录尝试率，多次登录尝试不成功后锁定账户以及需双因素识别已长时间限制的未知设备或账户。安全认证系统还有很多方面，所以请查看下方的链接获取更多信息。

## 进一步阅读

还有很多优秀的可用资源可以指导你的开发进程,更新或迁移你的账户和认证管理系统。我建议以下为出发点:

- NIST 800-063B 包含认证和生命周期管理
- OWASP 持续更新密码存储备忘单
- OWASP 使用认证备忘单进行深入研究 
- Google 的 Firebase 认证网站有丰富的指南库,参考资料和示例代码


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
