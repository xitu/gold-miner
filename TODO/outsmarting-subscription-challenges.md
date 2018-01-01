> * 原文地址：[Outsmarting subscription challenges: Solutions to 10 common challenges developers face with subscription businesses](https://medium.com/googleplaydev/outsmarting-subscription-challenges-711216b6292c)
> * 原文作者：[George Audi](https://medium.com/@georgeaudi?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/outsmarting-subscription-challenges.md](https://github.com/xitu/gold-miner/blob/master/TODO/outsmarting-subscription-challenges.md)
> * 译者：[pot-code](https://github.com/pot-code)
> * 校对者：[Wangalan30](https://github.com/Wangalan30), [IllllllIIl](https://github.com/IllllllIIl)

# 智对订阅难点

## 教你如何应对工作中 10 种常见订阅问题

![](https://cdn-images-1.medium.com/max/800/0*VDQQKZ8jM8fvB6z7.)

订阅业务十分复杂，要想经营好并不容易。对此我也关注了一段时间，总结了一些工作中大家基本都会碰到的问题，希望这些经验能给正面临这些问题的朋友们一些启发和思考。在看文章前，我假设你已经有 Google Play 订阅业务的运营经验，所以基础的东西我就不讲了，本文旨在将你解决订阅问题的能力再拔高一层，最终能融会贯通，熟练运用，真正做到“智对之”。

总的来说，订阅问题可以分为三类：1）引流和转化、2）黏度和挽回、3）定价，这三类问题对订阅业务利润的影响可谓是深远又重大。

### **引流和转化**

#### **难点 1**：“不知客从何处来”

![](https://cdn-images-1.medium.com/max/800/0*jK7Jet9zQQNpoGy7.)

用户来自哪个市场？哪个渠道的？哪部设备的？没有这些信息，你就没法针对性的进行市场调研、不知道侧重在哪个渠道、不知道哪个设备平台的回报更大。

针对这个问题，Google Play 最近在 Google Play Console 上面发布发表了几篇[**订阅报告**](https://android-developers.googleblog.com/search/label/subscriptions)，讲解了如何使用 Google Play Console 来对订阅信息进行可视化分析。目前，你可以在 Google Play Console 看到的数据有：

*   哪个市场的安装／订阅量最高
*   哪个渠道最能吸引用户订阅
*   用户所在地区分布情况
*   在同类应用中的表现

#### **难点 2**：“用户对会员服务并不感冒”

![](https://cdn-images-1.medium.com/max/800/0*gwlqCkHQx58lw6lp.)

这里有两种解决方案，第一种是多样化切入应用的卖点所在。

举个例子，健身类应用 [Freeletics](https://play.google.com/store/apps/developer?id=Freeletics&hl=en_GB&e=-EnableAppDetailsPageRedesign) 重新设计了它们的欢迎页，为了强调他们的卖点 —— 真正教你变强壮，他们采用问卷形式来挖掘用户健身的目的（像是为了练肌肉、减肥或是塑形），而不是一上来就直接列出这个 app 的所有功能，这样至少能提高 10% 的转化率。

另一种方法同样也十分常见 —— 在用户购买前为他们提供**免费试用**。我们发现，[**78% 的会员都是先试用再订阅的**](http://services.google.com/fh/files/misc/subscription_apps_on_google_play.pdf)。值得一提的是，Google Play 也调整了试用政策，现在可以提供仅 3 天的试用期（以前最少 7 天）—— 一些边际成本比较高的商家可能会比较关心。

#### **难点 3**：“用户支付中途放弃”

![](https://cdn-images-1.medium.com/max/800/0*p3edHCauwiAoDg7p.)

**Google Play Billing** 可以让你为超过 130 个国家和地区的用户提供可靠、便捷的支付体验。在下面的图示中，相比左侧冗杂、跳来跳去的支付流程，右侧显得更清爽、便捷的多，点两下就完成支付了。所以支付环节的无缝程度能很大的降低用户支付中途放弃的风险。

![](https://cdn-images-1.medium.com/max/800/0*MVbUsr1w4H9uZFAC.)

此外，从 2018 年 1 月 1 日开始，Google Play 将调整付费用户的交易税率，针对那些订阅超过一年的付费用户，税率下降到 15%。此举是为了凸显出那些拥有长期客户的商家，以便提供更好的用户体验。

#### **难点 4**：“付费用户太少”

![](https://cdn-images-1.medium.com/max/800/0*Z4bR3O6wG45Epx1f.)

针对这个问题，可以使用[**推广价**](https://support.google.com/googleplay/android-developer/answer/140504?hl=en#intro)来吸引顾客，即在特殊节日进行打折。

例如 [Cookpad](https://play.google.com/store/apps/details?id=com.mufumbo.android.recipe.search&hl=en_GB&e=-EnableAppDetailsPageRedesign)，一个在日本很火的烹饪 app，在每年的斋月（该月内伊斯兰教徒每日从黎明到日落禁食）放出 50% 的折扣价，相比平时，在这期间每天订阅的用户数能以至少 4.5 倍的速度增长。

![](https://cdn-images-1.medium.com/max/800/0*qq5kcYw0fOg8cdsB.)

### **黏度和挽回**

#### **难点 5**：“用户缺乏黏性”

![](https://cdn-images-1.medium.com/max/800/0*LuGZIoqgAlyQ33e5.)

我接触过的商家多少都会碰到这方面的问题，如何才能提升用户黏度，是关系到公司订阅业务利润增长最起码的问题，对此，我总结出以下两种解决方案：

第一种，使用成就系统，让用户在“玩”的过程中形成依赖感。要想效果明显，你需要注意以下几点：

1.  评估用户希望达成的目标和你设计的目标。
2.  用户达成一定目标后，要能以某种形式展现在用户的个人档里，满足用户的虚荣心。
3.  可以考虑加入一些激励，必要的话也可以加入现金奖励。当用户的参与度达到了一定程度之后，可以向用户发放这些激励。
4.  将真正有价值的激励限制在订阅付费用户范围内，从而减少付费用户的流失。

以下是一个囊括了以上要素的语言学习类应用 [Duolingo](https://play.google.com/store/apps/details?id=com.duolingo&hl=en_GB&e=-EnableAppDetailsPageRedesign)。

![](https://cdn-images-1.medium.com/max/800/0*-RGr53dMELlCf-D6.)

第二种方式比较直白，直接告诉用户你这里提供了长期订阅套餐，这样，你只需要说服用户买单。比如，你告诉用户，订阅的时间越长越优惠，最好能突出显示长期订阅的月均消费和单月订阅的价差（不要让用户自己去算）。此外，你还可以使用漏斗推广模型，同时推出一些季度套餐 (这样能获得更高的 LTV)。

例如韩国的付费点播平台 [WatchaPlay](https://play.google.com/store/apps/details?id=com.frograms.watcha&hl=en&e=-EnableAppDetailsPageRedesign)，就从原有的单月套餐发展成现在的四种套餐（1/3/6/12 个月），并且发现 40% 的用户选择了多月套餐。

![](https://cdn-images-1.medium.com/max/800/0*3Sp8GzzykR1Fs1f2.)

#### **难点 6**：“用户流失”

![](https://cdn-images-1.medium.com/max/800/0*UMMjwcYUuBfrOpmE.)

根据 [Google I/O ](https://android-developers.googleblog.com/2017/05/make-more-money-with-subscriptions-on.html?hl=mk)大会上的声明，Google Play Console 可以向开发者提供用户流失的原因：是用户主动还是被动（例如因为交易失败），甚至还能通知开发者用户卸载了你的应用。

#### **难点 7**：“对用户的流失并不知情”

![](https://cdn-images-1.medium.com/max/800/0*ObCXKkYnAo1NvF2U.)

这个问题比前几个还要棘手，不过好在 Google play 提供了[**即时通知**](https://developer.android.com/google/play/billing/billing_subscriptions.html#realtime-notifications) 的功能，当用户的订阅状态发生变更时会即时通知开发者，方便尽快作出回应。

#### **难点 8**：“用户不再续订”

![](https://cdn-images-1.medium.com/max/800/0*FP9LQ38OgWkTpaOW.)

因为有了上面提到的**即时通知**的功能，你还有机会让用户回头。例如，你可以再次向用户确认是否真的不再续订，或者再多宣传宣传订阅服务能带来的各种好处。

[Anghami](https://play.google.com/store/apps/details?id=com.anghami&hl=en_GB&e=-EnableAppDetailsPageRedesign) 是中东的一个音乐 app，在用户订阅到期时，它强调用户将失去一个重要的服务 —— 离线模式，并提醒用户，如果不继续订阅，那么就访问不到已下载的内容了。大脑训练应用 [Lumosity](https://www.google.co.uk/search?q=Lumosity+google+play&oq=Lumosity+google+play&aqs=chrome..69i57j0l5.1628j0j1&sourceid=chrome&ie=UTF-8) 则是向用户发送邮件，告诉用户又错过了哪些新内容。

为了方便订阅用户的回归，Google Play 提供了[**订阅恢复**](https://developer.android.com/google/play/billing/billing_subscriptions.html#restore)的功能，可以让你使用以下方式来挽留用户：

1. 用户取消了订阅。
2. Google Play 即时通知你。
3. 你向用户发送挽留的信息。
4. 如果挽留成功，用户只需点击一个按钮就能立刻恢复订阅（见下图）。

![](https://cdn-images-1.medium.com/max/800/0*seGMbZYMvuwJOjmk.)

Google Play 在这方面也在持续改进，建议时刻关注新的进展！

#### **难点 9**：“交易失败”

![](https://cdn-images-1.medium.com/max/800/0*5TxC7Yszcfj9LFJL.)

前面讲的都是针对用户主动取消订阅而流失的情况，这里我要讲因支付失败而导致的问题，其原因可能是因为用户信用卡失效，或是支付流程出了点问题。

对于这个问题同样有两种解决方案，分开或者结合使用都可以。

第一种，在 Play Console 里启用宽限期，这样能给予用户 3 -7 天的宽限期来解决支付问题。统计得出，提供了宽限期的商家提高了至少 50% 因支付失败的客户回归率。

我个人极力推荐各位开启宽限期，也就打开一个开关的事。尝试不同的期限，寻找最适合你的情况的时长。

事情都有两面性，你开启了宽限期，用户可能因为存在宽限期而迟迟不付款，对此，你可以适当的施行一些惩措。例如，你可以开启 I/O 大会上提到的 [账户保持（account hold）](https://developer.android.com/google/play/billing/billing_subscriptions.html#account-holds)功能，这样，你可以暂时挂起他们的账户，直到他们付款为止。

第二种是使用 [Univision NOW](https://play.google.com/store/apps/details?id=com.univision.univisionnow&hl=en_GB&e=-EnableAppDetailsPageRedesign) ，Univision NOW 可以在用户支付失败时提供一个弹窗，按钮链接到一个更新用户支付信息的快速通道。这个功能的方便之处就在于一旦用户修复或者更新了支付信息，所有被挂起的订阅都会立即恢复。

![](https://cdn-images-1.medium.com/max/800/0*5vIqduvJtdzohpZb.)

约会应用 [Tinder](https://play.google.com/store/apps/details?id=com.tinder&hl=en_GB) 作为账户保持（account hold）功能的最初尝试者之一，已经提高了 3 倍的回归率。

![](https://cdn-images-1.medium.com/max/800/0*TNavY97X9WlQwn9T.)

#### **难点 10**：“放着钱不赚”

![](https://cdn-images-1.medium.com/max/800/0*_M3eu3-hGwOcgzg-.)

不要忘了还有定价这个问题，我已经被问过很多次这个问题了。产品定价本身就是一门学科，也无怪乎开发者们不确定自己的定价是否合理。

对此也有两种解决方案：

第一种是[使用 Firebase 做远程配置](https://firebase.google.com/products/remote-config/)来测试不同定价的表现：

1.  设置两个 SKU（最小货存单元）
2.  针对不同的用户群体使用不同的价格配置
3.  根据反馈结果得出最佳定价

要记住一点，我们的目标是最大化用户黏度，不仅仅只是注册量而已，所以这个测试的时间周期可能会有点长。此外，你还要保证统计样本足够大，这样得出来的结果才有意义。

第二种是提供一系列套餐计划，每种套餐包含不同的功能，也对应不同的价格。例如娱乐应用 [CBS](https://play.google.com/store/apps/details?id=com.cbs.app&hl=en_GB&e=-EnableAppDetailsPageRedesign) 为了迎合不同观众的需求，提供了含部分广告和不含广告两种套餐。那些对钱比较敏感的用户为了少花钱会更倾向于选择便宜的、但是包含部分广告的套餐，而对时间更敏感的用户则会用钱去换取时间 —— 购买无广告但是价格更高的套餐。不仅如此，CBS 还允许订阅用户在这两种套餐间无缝切换 —— 使用 Google Play billing 提供的[**套餐升降级（plan upgrades/downgrades）**](https://developer.android.com/google/play/billing/billing_subscriptions.html)功能（这也是我要说的第三种方案）

讲的有点多，可能需要点时间消化，所以，为了方便需要快速阅读的读者，这里也提供了一份[**总结**](http://services.google.com/fh/files/misc/outsmarting_subs.pdf)。希望这些示例和经验不仅仅局限于解决你现在的问题，还能助你在此基础上将之发扬光大、不断改进，最终能完全摆脱这些问题。

* * *

### 谈谈你的看法

你赞同我给出的解决方案吗？你碰到过其他的难题吗？你在引流和保持用户黏度方面有更好的方法吗？欢迎在评论区继续讨论这个问题，或着在发推时加上 #AskPlayDev 话题标签一起参与进来，我们会通过 [@GooglePlayDev](http://twitter.com/googleplaydev) 来答复你，在上面我们会发些教你如何在 Google Play 上获得成功的文章，期待你的关注！

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
