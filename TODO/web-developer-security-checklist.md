> * 原文地址：[Web Developer Security Checklist](https://simplesecurity.sensedeep.com/web-developer-security-checklist-f2e4f43c9c56)
> * 原文作者：[Michael O'Brien](https://simplesecurity.sensedeep.com/@sensedeep)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者： [GangsterHyj](https://github.com/gangsterhyj)
> * 校对者： [zaraguo](https://github.com/zaraguo), [yzgyyang](https://github.com/yzgyyang)


# Web 开发者安全清单

![](https://cdn-images-1.medium.com/max/800/1*UOl3ydmbG1ehgoSpBxdGFA.jpeg)

开发安全、健壮的云端 web 应用程序是**非常困难**的事情。如果你认为这很容易，要么你过着更高级的生活，要么你还正走向痛苦觉醒的路上。

倘若你已经接受 [MVP（最简可行产品）](https://en.wikipedia.org/wiki/Minimum_viable_product) 的开发理念，并且相信能在一个月内创造既有价值又安全的产品 —— 在发布你的“原型产品”之前请再三考虑。在你检查下面列出的安全清单后，意识到你在开发过程中忽视了很多极其重要的安全问题。至少要对你潜在的用户坦诚，让他们知道你并没有真正完成产品，而仅仅只是提供没有充分考虑安全问题的原型。

这份安全清单很简单，绝非覆盖所有方面。它列出了在创建 web 应用时需要考虑的比较重要的安全问题。

如果下面的清单遗漏了你认为很重要的问题，请发表评论。

### **数据库** ###

-  对识别用户身份的数据和诸如访问令牌、电子邮箱地址或账单明细等敏感数据进行加密。
-  如果数据库支持在空闲状态进行低消耗的数据加密 (如 [AWS Aurora](https://aws.amazon.com/about-aws/whats-new/2015/12/amazon-aurora-now-supports-encryption-at-rest/))，那么请激活此功能以加强磁盘数据安全。确保所有的备份文件也都被加密存储。
-  对访问数据库的用户帐号使用最小权限原则，禁止使用数据库 root 帐号。
-  使用精心设计的密钥库存储和分发密钥，不要对应用中使用的密钥进行硬编码。
-  仅使用 SQL 预备语句以彻底阻止 SQL 注入。例如，如果使用 NPM 开发应用，连接数据库时不使用 npm-mysql ，而是使用支持预备语句的 npm-mysql2 。

### **开发** ###

-  确保已经检查过软件投入生存环境使用的每个版本中所有组件的漏洞，包括操作系统、库和软件包。此操作应该以自动化的方式加入 CI/CD（持续集成/持续部署） 过程。
-  对开发环境系统的安全问题保持与生产环境同样的警惕，从安全、独立的开发环境系统构建软件。

### **认证** ###

-  确保所有的密码都使用例如 bcrypt 之类的合适的加密算法进行哈希。绝对不要使用自己写的加密算法，并正确地使用随机数初始化加密算法。
-  使用简单但充分的密码规则以激励用户设置长的随机密码。
-  使用多因素身份验证方式实现对服务提供商的登录操作。

### **拒绝服务防卫** ###

-  确保对 API 进行 DOS 攻击不会让你的网站崩溃。至少增加速率限制到执行时间较长的 API 路径（例如登录、令牌生成等程序）。
-  对用户提交的数据和请求在大小和结构上增强完整性限制。
-  使用类似 [CloudFlare](https://www.cloudflare.com/) 的全局缓存代理服务应用以缓解 [Distributed Denial of Service](https://en.wikipedia.org/wiki/Denial-of-service_attack) （DDOS，分布式拒绝服务攻击）对网站带来的影响。它会在你遭受 DDOS 攻击时被激活，并且还具有类似 DNS 查找等功能。


### **网络交通** ###

-  整个网站使用 TLS （安全传输层协议），不要仅对登录表单使用 TLS。
-  Cookies 必须添加 httpOnly 和 secure 属性，且由属性 path 和 domain 限定作用范围。
-  使用 [CSP（内容安全策略）](https://en.wikipedia.org/wiki/Content_Security_Policy) 以禁止不安全的后门操作。策略的配置很繁琐，但是值得。
-  使用 X-Frame-Option 和 X-XSS-Protection 响应头。
-  使用 HSTS(HTTP Strict Transport Security) 响应强迫客户端仅使用 TLS 访问服务器，同时服务端需要将所有 HTTP 请求重定向为 HTTPS。
-  在所有表单中使用 CSRF 令牌，使用新响应头 [SameSite Cookie](https://scotthelme.co.uk/csrf-is-dead/) 一次性解决 CSRF 问题， SameSite Cookie 适用于所有新版本的浏览器。

### **APIs** ###

-  确保公有 API 中没有可枚举的资源。
-  确保每个访问 API 的用户都能被恰当地认证和授权。

### **校验** ###

-  使用客户端输入校验以及时给予用户反馈，但是不能完全信任客户端校验结果。
-  使用服务器的白名单校验用户输入。不要直接向响应注入用户信息，切勿在 SQL 语句里使用用户输入。

### **云端配置** ###

-  确保所有服务开放最少的端口。尽管通过隐藏信息来保障安全是不可靠的，使用非标准端口将使黑客的攻击操作更加困难。
-  在对任何公有网络都不可见的私有 VPC 上部署后台数据库和服务。在配置 AWS 安全组和对等互联多个 VPC 时务必谨慎（可能无意间使服务对外部可见）。
-  不同逻辑的服务部署在不同的 VPC 上，VPC 之间通过对等连接进行内部服务的访问。
-  让连接服务的 IP 地址个数尽可能少。
-  限制对外输出的 IP 和端口流量，以最小化 APT（高级持续性威胁）和“警告”。
-  始终使用 AWS 的 IAM（身份与访问管理）角色，而不是使用 root 的认证信息。
-  对所有操作和开发人员使用最小访问权限原则。
-  按照预定计划定期轮换密码和访问密钥。

### **基础架构** ###

-  确保在不停机的情况下对基础架构进行升级，确保以全自动的方式快速更新软件。
-  利用 Terraform 等工具创建所有的基础架构，而不是通过云端命令行窗口。基础架构应该代码化，仅需一个按钮的功夫即可重建。请不要手动在云端创建资源，因为使用 Terraform 就可以通过配置自动创建它们。
-  为所有服务使用集中化的日志记录，不该再利用 SSH 访问或检索日志。
-  除了一次性诊断服务故障以外，不要使用 SSH 登录进服务。频繁使用 SSH ，意味着你还没将执行重要任务的操作自动化。
-  不要长期开放任何 AWS 服务组的22号端口。
-  创建 [immutable hosts（不可变主机）](http://chadfowler.com/2013/06/23/immutable-deployments.html) 而不是使用一个经过你长期提交补丁和更新的服务器。。（详情请看博客 [Immutable Infrastructure Can Be More Secure](https://simplesecurity.sensedeep.com/immutable-infrastructure-can-be-dramatically-more-secure-238f297eca49)）。
-  使用如 [SenseDeep](https://www.sensedeep.com/) 的 [Intrusion Detection System（入侵检测系统）](https://en.wikipedia.org/wiki/Intrusion_detection_system) 或服务，以最小化 [APTs（高级持续性威胁）](https://en.wikipedia.org/wiki/Advanced_persistent_threat) 。

### **操作** ###

-  关闭未使用的服务和服务器，关闭的服务器是最安全的。

### **测试** ###

-  审核你的设计与实现。
-  进行渗透测试 — 攻击自己的应用，让其他人为你的应用编写测试代码。

### **最后，制定计划** ###

-  准备用于描述网络攻击防御的威胁模型，列出可能的威胁和网络攻击参与者，并按优先级对其排序。
-  制定经得起实践考验的安全事故计划，总有一天你会用到它。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
