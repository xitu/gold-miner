> * 原文地址：[Five tips to improve your games-as-a-service monetization](https://medium.com/googleplaydev/five-tips-to-improve-your-games-as-a-service-monetization-1a99cccdf21)
> * 原文作者：[Moonlit Beshimov](https://medium.com/@moonlit_b?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/five-tips-to-improve-your-games-as-a-service-monetization.md](https://github.com/xitu/gold-miner/blob/master/TODO/five-tips-to-improve-your-games-as-a-service-monetization.md)
> * 译者：[PTHFLY](http://github.com/pthtc)
> * 校对者：

# 游戏即服务的五条建议，提升游戏变现能力

## 不赶走玩家的情况下提升收入的实用建议

![](https://cdn-images-1.medium.com/max/800/0*hsST-E5US6caYOgf.)

在当今世界移动端的游戏即服务，想搞清楚玩家的生命周期价值（ LTV ）变得非常复杂。与传统主机游戏不同，现在的收入并非由单次购买，而是许多微小的交易组成的。然而，即使没有一个精确的统计模型，你也能意识到一个玩家在你的游戏中花的时间越多，就会花掉更多的钱和产生更高的生命周期价值。

然而，我总是被移动游戏开发者问『我们如何才能在不赶走玩家的情况下提升收入呢？』往往我会建议他们遵循这些最佳实践中的某一条：

![](https://cdn-images-1.medium.com/max/800/0*-TVBHI4t0wgAg5Jd.)

**1. 跟踪与生命周期价值有强关联正相关的用户行为特征**

理解你的游戏是如何与行业平均作斗争的。有一个给力的报告计划会帮你发现游戏的改善是如何影响玩家的。最重要的、与玩家生命周期价值最相关的措施是：

* **第 1 ， 7 ， 30 天留存** 是用户安装后第 X 天回归的比例。这些能衡量你留存用户的能力，也因此能衡量休闲玩家被转化为忠实玩家的程度。
* **上线时长和频次** 根据用户在你游戏上花费的时间和访问的频繁程度衡量了平均用户参与度。
* **重要里程碑完成率** 可以衡量和定位流失。
* **购买者和重复购买者转化** 衡量你的游戏能把多少人转化为购买者和更高价值的重复购买者。通常来说反复购买者是你最具价值的用户群。

例如，当观察不同游戏类型的 30 天留存时，典型的，我们会发现：

* 休闲: 18~23%
* 中度硬核: 14~18%
* 硬核: 10~14%

![](https://cdn-images-1.medium.com/max/800/0*05Iz6B7rIIe5VWXR.)

[不同游戏分类的 30 天留存]

如果你没有实现接近行业平均水平，你需要专心提高你游戏中基于留存的长期参与度。

对于其他游戏类型，你可以在 Acquisition reports 下的 Play Console 里找到行业平均水平的更多细节。

![](https://cdn-images-1.medium.com/max/800/0*FyWZeognksuw5xyl.)

**2. 优化长期参与度和取悦你最好的玩家**

留存是优秀和平庸第一分水岭。在用户生命周期持续拥有更高留存比例的游戏能够更好地变现。留存为王，尤其是**长期留存必须优先考虑。**

![](https://cdn-images-1.medium.com/max/800/0*zuHQR1AFND-kYyPu.)

[说明: 顶级应用和游戏的玩家留存]

当考虑到长期留存，专注于实现一个好的 30 天目标，但是**也要向头 30 天之后展望**。通过评估以下的比例来衡量长期留存： 30 天到 60 天， 30 天到 90 天， 30 天到 180 天。这个比例越高，你的游戏长期粘性就越强，从而玩家的生命周期价值会增加。因此，当设计游戏的时候，以创造好玩有吸引力的体验为目标来取悦你最忠诚的玩家。

也许这里最大的挑战是提前规划。这意味着当设计和构建游戏的时候，在发布之前思考：规划你会如何放出新功能和挑战以及他们会如何被使用。拥有持续内容上线计划的游戏更快呢实现更高的长期留存比例。

同时, **使得** **内容对于那些在游戏里会玩到很高等级和花费很长时间的玩家足够丰富有趣**。这对于确保你不会拒绝最活跃的玩家或因为缺少内容二阻碍他们的游戏过程很重要：总是给玩家持续游玩的理由。记住，越多花在游戏里的时间，会产生更高参与度以及最终产生更高的生命周期价值。

![](https://cdn-images-1.medium.com/max/800/0*Y5iRJYZAkpZSi08R.)

**3. 通过靶向邀请提高用户转化Increase buyer conversion through targeted offers**

一个购买者的第一次转化是最重要的，因为**流失比例在第一次购买之后迅速降低**。当除去首充的总金额之后结果是相似的，还有很有趣的一点是：过去购买行是未来购买的最佳预测者。你可以在 [Play Console.](https://developer.android.com/distribute/users/user-acquisition.html) 找到你首次和重复购买者的比例。

使用 A/B 测试来 **发现利益最大化的定价**。对于每个用户来说，对于给定商品的支付意愿是不同的，支付价格和数量也将会因为商品的不同而有所改变，因此请有策略地管理降价。

例如， [Spellstone](https://play.google.com/store/apps/details?id=com.kongregate.mobile.spellstone.google&hl=en_GB) by Kongregate 给用户提供了 ShardBot 一个连续 30 天获得的游戏附加货币（ Shard ）的计划。做为这个商品促销的一部分， Kongregate 测试了两种 ShardBot 套餐：一种 4 美金的 ShardBot，用户每天可以获得 5 个 shard ；一种 8 美金的 ShardBot，用户每天可以获得 10 个 shard 。结果显示，在两种套餐都获得差不多的留存比例的同时，玩家有**对于更高价套餐巨大的偏好**。

![](https://cdn-images-1.medium.com/max/800/0*SwSWzbGwZRWEiJYx.)

[说明：玩家偏爱产生更高收入的高价套餐]

![](https://cdn-images-1.medium.com/max/800/0*PA2hSvOxJl7OB03z.)

[说明：ShardBot 和 Super ShardBot 的留存比例非常相似]

这些结果显示玩家行为不总是可预测的。开发者可能预测更低价套餐会更受欢迎，但是高价买家可能更可能被留存。这是为什么测试总是了解玩家支付意愿、发现收益最大化价格点的最好的方法。

![](https://cdn-images-1.medium.com/max/800/0*xNOcOATy5U2zEnFx.)

**4. 无论投入使用 _什么_  变现方法，请把 _为什么，什么时候_ 以及 _怎么做_ 纳入考虑范围：**

**_为什么：_ 『购买者意图』很重要并且玩家购买是因为他们 _想买_ 而不是 _必须买_ 。因此请让每一件带着价签的物品都被设计得能够提升玩家的游戏体验。** 这事也确保你不会因为『必须支付』选项来阻碍玩家游戏过程的关键。取而代之的是，确保在免费体验上给他们一些附加的东西，比如专属等级，装备酷炫的能力提升或者一些对于玩家有价值和兴奋点的东西。快乐的用户意味着他们会在你的游戏里花费更多的时间，这也意味着更高的收入。通过在新手教程中赠送免费商品或者货币来教育用户也很重要，这会**让用户及早体验到 IAP （应用内支付）带来的好处**。

**_什么时候：_ 在用户最需要的时候提示购买**。如果一个 IAP 能在超时后能够继续当前游戏，你应该在计时停止时告诉用户。如果另一个 IAP 提供了附加装备，应该在用户给人物换装的时候提示他们。这些购买邀请应该与当前情况相关，内容应该满足玩家在游戏内的当前状态和需求。

尤其是，新手套餐或者首充促销需要精心确定时间。在被展示优惠之前，玩家需要充分理解所有物品的价值和重要性。如果展示得太早了，玩家不会非常迫切地购买。如果展示太晚，购买邀请优惠显得不够难以抗拒。**新手套餐应该根据游戏的实际情况，在安装后 3 到 5 轮后显示**。另外，在 3 到 5 天内限制它的可获得性会鼓励用户做出购买决定。

在 [BattleHand](https://play.google.com/store/apps/details?id=com.kongregate.mobile.battlehand.google&hl=en&e=-EnableAppDetailsPageRedesign) 的例子中，新手套餐在第四轮展示的，并且仅有 36 消失的购买时间。套餐中包括这些在游戏各个层面帮助玩家的物品：

* 在战斗中可立即生效的强力卡片。
* 用于升级卡组的高度稀有升级材料。
* 一笔丰厚的软性货币，可用于游戏的任何地方。
* 一笔丰厚的硬性货币，可用于玩家购买增值商店物品。an purchase premium store items.
* 英雄的珍贵升级材料。

![](https://cdn-images-1.medium.com/max/800/0*8zXCgdJ43IZOEbf7.)

[Battle Hands 中提供的新手套餐]

感谢如此巨大的促销力度，超过 50% 的玩家都选择购买新手包而不是购买普通宝石：

![](https://cdn-images-1.medium.com/max/800/0*F6-8a6lioA7K_B2W.)

[特殊优惠的新手包和普通报价在新用户转化上的对比]

**_怎么做：_ 有许多方法可以在你的游戏里添加增值内容，比如能力提升、人物、装备、地图、提示、章节和其他。** 以下三个变现设计影响力最大：

**IAP 商店优化** — 在游戏流中显示 IAP （应用内支付）内容可以很好地驱动销售。不要小看你的游戏内商店。习惯于购买的玩家会经常探索可购买的选项，希望找到可以提升他们游戏性的内容。

![](https://cdn-images-1.medium.com/max/800/0*O8M0nCPolalT0YCW.)

因此，保持你商店内容更新和相关是很重要的，但是也要让这些内容精准符合玩家的游玩和购买习惯。可以使用这些方法：

![](https://cdn-images-1.medium.com/max/800/0*_QPp5_oSUwTMwDHB.)

* 隐藏高价物品，直到用户完成首充。社会心理学家把这个叫做[登门槛技术](https://en.wikipedia.org/wiki/Foot-in-the-door_technique)。
* 以固定的时间间隔和玩家在游戏内的进程增加新的 IAP 物品。
* 当提供套餐的时候，确保你着重显示了购买套餐的『福利』。
* 当你了解了玩家的购买习惯，在商店顶部显示与他们最近购买的物品相似的商品。

**开箱** — 有许多方法来设计、展示、平衡开箱，但是其中的关键是随机奖励。这使得你可以销售一些玩家想要的超强大物品，同时也不用收取超高价格。

![](https://cdn-images-1.medium.com/max/800/0*QM5Lh_Yq9vFljyVn.)

[Raid Brigade](https://play.google.com/store/apps/details?id=com.kongregate.mobile.raidbrigade.google&hl=en_GB) 的随机奖励是箱子。

**LiveOps** — 一直提供限时优惠创造了一种让玩家无法抗拒的机会，在游戏里参与和投资更多。比如， [Adventure Capitalist](https://play.google.com/store/apps/details?id=com.kongregate.mobile.adventurecapitalist.google&hl=en_GB) 定期放出限量、主题、限时事件让每个人都可以尝试固定内容，同时也提供定制化发展路线、成就以及 IAP 优惠。

![](https://cdn-images-1.medium.com/max/800/1*EsNIihb-4KgbVA-6vb1iFg.png)

[ Adventure Capitalist 中的一个限时优惠活动]

在活动中，这主动提升了参与度和收入，同时也没有透支非活动手段的收益与参与度。

![](https://cdn-images-1.medium.com/max/800/1*go7Rc9Ex5f0O7POubTM4JA.png)

[峰值显示了限时活动对于参与度与收入的影响]

![](https://cdn-images-1.medium.com/max/800/0*KRW6WPnmCiQpGj_1.)

**5. 考虑本地价格和价格模型**

人与人之间消费意愿有差异，**不同市场的购买力也同样有差异**。

* **测试每个主要市场行之有效的价格点** 根据购买力的巨大不同进行调整。你也许发现降低价格事实上会增加你的总收入。当[ Divmob 介绍在许多市场中的低于一美元定价策略](https://android-developers.googleblog.com/2016/06/android-developer-story-vietnamese.html)，他们发现付费用户增加了三倍。但是再次强调，不要仅仅是想着打折，找到最大总收入的价格点。
* **考虑有吸引力的价格，但是记住它不会在哪都适用。**比如，在美国价格总是以 .99 结尾，但是在日本和韩国就不是这么回事，那里用整数结尾。定价依照当地玩家的惯用标志，会显示你关心他们并用心为他们设计游戏。Play Console 现在自动为你使用每种货币的[本地货币转换](https://support.google.com/googleplay/android-developer/answer/6334373?hl=en&ref_topic=6075663)。

为了增加你的移动游戏即服务变现能力，你可以做的最重要的事情是创造持久的娱乐体验。我不能更强调参与度是持续和长期变现的第一步。你也需要确保任何带着价签的东西都能增进玩家的游戏体验，因为如果他们的付出没有获得更大的愉悦，他们会失去兴趣。

明天你应该问自己，我如何让自己的游戏更好？持续提供升级是重要的，希望通过遵循这篇博文里的建议和提示，你会有一些可以操作的新点子。请在评论里分享你的创新和成果，我很愿意听到一些反馈。

尤其感谢 [Kongregate](http://developers.kongregate.com/)的移动产品总监 [Tammy Levy](https://medium.com/@talech) 在提炼建议和提供优秀案例方面的帮助。

* * *

#### 你怎么想？

你有关于在优化用户决定方面的问题或者想法吗？在下面评论区继续讨论或者通过井号标签 #AskPlayDev 通知我们，我们会在 [@GooglePlayDev](http://twitter.com/googleplaydev) （我们会定期分享在上面就如何在Google Play成功的话题分享新闻和小贴士）上回复。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
