> * 原文地址：[Design your app for decision-making](https://medium.com/googleplaydev/design-your-app-for-decision-making-e9e5745508e4)
> * 原文作者：[Jeni](https://medium.com/@_jeniwren?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/design-your-app-for-decision-making.md](https://github.com/xitu/gold-miner/blob/master/TODO/design-your-app-for-decision-making.md)
> * 译者：[PTHFLY](https://github.com/pthtc)
> * 校对者：[ryouaki](https://github.com/ryouaki)

# 想帮助用户做决定？你的APP可以这样设计！

## _简单化，触发器，激励 — 一个优化用户行为的三步走方法_<sup><a href="#note1">[1]</a></sup>

![](https://cdn-images-1.medium.com/max/800/1*wsvauosvxPMm0R6rlKXR_g.jpeg)

如果你从事移动APP行业，每一天你都有潜在机会影响几百万人的行动。无论是参与使用一个新功能，每天访问你的应用，或是订阅你的增值服务， 你往往很可能在心里有一个希望更多用户会做的关键行为。但是你如何才能增加用户行动的机会呢？

无论你希望的行为是什么， 这篇博文将会把一个优化用户行为结果的三步走方法介绍给你，分别是简化、触发器、积极性（其中的第一部分借鉴了来自于行为经济学、心理学和游戏化的理念）。特别地，在这篇博文中我们将覆盖前两步，也就是简化和触发器。

当考虑鼓励某个特定的用户行为策略的时候，你应该从哪里开始？斯坦福 [Persuasive Tech Lab](http://captology.stanford.edu/) 的院长，BJ Fogg博士创建了 Fogg 行为模型，来评估三个因素（能力、触发器、积极性）对于给定行为发生可能性的影响：

![](https://cdn-images-1.medium.com/max/800/0*dP-BAPMCWX9uKBuj.)

Fogg 行为模型

模型指出三个影响用户行为的原因，并由此导出三个驱动行为改变的关键步骤

* 步骤一：**简化**所需的行为。通过降低（最好是移除）不利于行为发生的阻碍来鼓励有参与感、有积极性的用户发生行为。
* 步骤二：**触发**来自于积极用户<sup><a href="#note2">[2]</a></sup>的行为。『触发器』（提示、提示音、行为召唤）的出现甚至可以在积极性水平略低的情况下驱动行为。
* 步骤三：激发用户的**积极性**。积极性很难被影响，但是如果所需的行为相当『容易』去做，通过吸引人的信息或者加入游戏因素来提升积极性水平可以激励用户按你的想法行动。

到此为止还不错。但是你如何执行这些步骤呢？以下我们将会深入探讨前两项步骤。（我会在未来的博文中讨论第三步，激发用户积极性）

### 步骤一，简化所需行为

你希望用户去做的行为必须非常容易做到（做起来很少或者没有阻碍）并且容易作出决定（有清晰易懂的好处）。我们做出的每个行为都需要付出代价（比如时间、金钱和认知负担）。这些代价是一种阻碍，每个决定都在代价和收获的好处之间权衡的结果。比如，我们中许多人在年初都会有变得健康的强烈冲动，但是当真需要付出必要锻炼的时候又会导致许多决心的破产。

什么阻碍或者『要求』会降低你的用户进行行动的机会呢？通常用户会付出代价的阻碍包括繁琐的手动输入，冗余的界面，过量的选择，以及因为没有清晰告诉用户要干什么从而引起困惑的信息。这些阻碍可以通过分析用户在应用内的行为数据来定量辨别，也可以通过用户搜索等方式定性识别。一旦你已经识别了用户行动的阻碍，就到了降低或者移除它们的时候了。

#### **降低行动所需时间**

从应用被发现到下载需要有几次点击，更不用说等待下载完成的时间。然而 [Android Instant Apps](https://developer.android.com/topic/instant-apps/index.html) 是一个通过立即进行本地体验无需下载门槛，让用户快速完成许多任务的选择（例如看一个视频或者支付）。

![](https://cdn-images-1.medium.com/max/600/1*R4kv3XMr9rpphokMjS0jRA.png)

一旦你的用户打开了你的应用，注册过程是下一个繁琐、耗时的雷区。比起每次都要求用户登录，开发者们喜欢的 [Ticketmaster](https://play.google.com/store/apps/details?id=com.ticketmaster.mobile.android.uk) 和 [AliExpress](https://play.google.com/store/apps/details?id=com.alibaba.aliexpresshd) 通过整合 [Google Smart Lock](http://get.google.com/smartlock/#for-passwords) 能够有效省略手动密码这一步骤。它们随后就能看见登录失败的比例大幅下降。

通过进行漏斗分析，开发者能够跟踪核心流程中的用户流失情况，帮助定位所需行为的阻碍。在实行漏斗分析方面，食品配送公司 [Deliveroo](https://play.google.com/store/apps/details?id=com.deliveroo.orderapp) 识别了一个在首次结账环节的转换流失。他们注意到同样的流失情况并不会在已经将支付和配送信息的存储在应用中的老用户身上发生。意识到他们的注册流程可能是问题的一部分，团队优先考虑部署 [Android Pay](https://developers.google.com/android-pay/) 来为新用户创造一个简单的结账体验。

![](https://cdn-images-1.medium.com/max/600/1*bst4m7qIgfsAuyybPOIAsw.png)

#### **降低（实际存在或是可察觉的）花费**

降低花费不是意味着你应该全盘降低价格！真实含义是每个预期的购买者有一个不同的『甜蜜点』，根据应用匹配程度、用户位置以及用户综合支付能力反映出他们认为合适的价格。

Tamzin Taylor，Google Play的西欧应用主管，曾经讲出了一些有关于价格优化的最佳关键实践，比如使用 [Big Mac Index](http://www.economist.com/content/big-mac-index) 进行购买力对比，从而评估每个市场的实际支付能力。

[![Watch the video](https://raw.github.com/GabLeRoux/WebMole/master/ressources/WebMole_Youtube_Video.png)](https://www.youtube.com/embed/LQ6MsPmUa38)

另一个降低成为潜在购买者门槛花费的方法是降低初始消费要求。我们最近为应用订购做的 [Introductory Pricing](https://support.google.com/googleplay/android-developer/answer/140504#intro) 功能允许你做到这件事。

当我们考虑可察觉的花费的时候，价格显示的方式对价格的感知有重大的影响这件事很有必要被注意带。

**1. 锚定效应**

开发者和零售商经常通过[堆叠『好』、『更好』、『最好』等词](https://hbr.org/2013/02/why-good-better-best-prices-are-so-effective)试图『推动』用户去购买某个特定商品。这个方法会因为标志价格与更便宜或更贵的价格点一起放置而起作用。更高价格的『最好』选择扮演了一个参考点，或者说锚点，让用户认为标准价格看起来是个更便宜和超值的选择。

> 在一定情境里，我们倾向于中间价格因为他们看起来『公平』。
> — [Derek Thompson](https://medium.com/@dkthomp), The Atlantic

Dan Ariely 通过一个在他的书《Predictably Irrational.》中一个现在很著名的关于经济学家价格策略的例子引起了我们的注意。杂志提供了三种选择：一个 59 美金的电子版，一个 125 美金的纸质版和一个 125 美金包含纸质和电子两种版本的套餐。Ariely 指出『相对于纯纸质选择，电子+纸质的选择看起来明显超值』，这个说服我们购买第三个选择因为这个『更容易』评估某物的价值当它被放置在有另一个明显不如它的选择旁边。

**2. 框架效应**

给你两个选择：一个付 60 美金一年，一个付 5 美金每个月，你会选哪个？许多有订阅功能的应用会向潜在购买者高亮显示年付的价格，而不是月付价格。因为这会显得被察觉的价格更低，虽然在一年中他们的花费是一样的。

![](https://cdn-images-1.medium.com/max/600/1*S8DAVtjS0Z48RSJyzbzkKQ.png)

#### **降低认知负担**

你给用户提供越多选择，用户在比较选择和做决定中的心理负担就越沉重。

作为开发者，在用户使用过程的关键节点，除了评估你提供给用户的选择本身，评估你显示选择的方式也值得，因为这将会对做决定的过程有巨大的影响。

**限制的价值**

比如，在航班应用 [Skyscanner](https://play.google.com/store/apps/details?id=net.skyscanner.android.main) 中搜索经常获得上千条结果。你可以理性地辩解说顾客们应该衡量每个单独结果的价值。但是在有限时间和认知负担的阻碍下，Skyscanner 决定以一种更好理解的方式聚合结果，从而限制选择。当同样数量的结果被返回，这个页面展示上的简单改变提升了 14% 的转化率。

**默认的重要性**

总的来说，人们跟随最少阻碍的路径行动。这意味着预先设置的选项是优化用户行为的有力工具，尤其是当这些默认选项对用户有明显好处的时候。

* 例如，食谱应用 [Simple Feast](https://play.google.com/store/apps/details?id=com.simplefeast.android.app) 决定在增值服务的页面强调他们年付订阅。他们用视觉强调的方式展示，并设定为默认用户选择。结果他们发现选择年付订阅的用户增加了。

* 复选框一个表面上的小改变也有巨大的影响。默认的力量已经被利用并产生了巨大的影响，并在诸如器官捐献领域，很多国家的表格都有『自愿退出』的政策。[点击查看更高的器官捐献同意比例](http://www.dangoldstein.com/papers/JohnsonGoldstein_Defaults_Transplantation2004.pdf)。为什么？因为人们倾向于继续维持现状。

### Step 2. 触发积极用户的行为

鼓励所需用户行为的第二步是在主动用户的相关路径中设置相关触发，从而表现出可操作性。BJ Fogg有一个一个值得纪念名言：『在积极用户的使用路径上放置热点触发器』。触发器往往对于用户来说是陌生的，因为它是一个从开发者角度给出的想要影响用户下一步行为的提示、提醒或者行为召唤。一个推送在这个意义上是一个触发器，并且当它是可操作、定制化、时间合适的时候会非常有效。

语言学习软件的 [Busuu](https://play.google.com/store/apps/dev?id=8335366955203612525) 的产品主管 [Antoine Sakho](https://medium.com/@antoinesakho) 在他的 [Medium 文章](https://medium.com/@antoinesakho/designing-push-notifications-that-dont-suck-af6aaa0ea85) 中介绍了他们如何在他们的推送策略中应用 [Nir Eyal](https://medium.com/@nireyal)的[钩子模型](http://www.nirandfar.com/hooked) ，从而获得推送打开率300%的增长。他写道：

> _首先，我们通过个性化推送提示用户_ **_ (外部触发) _** _从而引发好奇_ **_(内部触发)_**_. 点击推送， 他们会经历一个测试 **_(行为)_**_。 在测试的最后， 他们会看到一个包含分数的恭喜页面_ **_(奖励)_**_。 最后，通过训练他们已经学到的词汇，他们强化了长期记忆_ **_(投入)_**.

![](https://cdn-images-1.medium.com/max/800/0*rEsZdKUne9TjMfzu.)

钩子模型，应用于 Busuu 的用户召回活动

尽管推送对于有效召回用户有一定保证，你还是应该避开这些常见陷阱：

1. 在不合适的时间推送通知或者推送与用户环境无关的信息，只会产生巨大的反作用。
2. 总是推送相同消息会很快被用户厌烦：跟随Busuu的指引，永远不要把同一条通知推送两遍。
3. 不要归于依赖推送来驱动用户行为。当无需提醒用户也能主动参与应用内容的时候，应用习惯才会最终养成。[Nir Eyal](https://medium.com/@nireyal) 在他 [Medium 文章](https://medium.com/behavior-design/the-psychology-of-notifications-how-to-send-triggers-that-work-25c7be3d84d3#.e4sbkzj7l)中总结了这些：

> _能让人养成习惯的产品会在内部触发被感知的时候（比如不确定感或者无聊感）结合外部触发器（例如推送），让用户养成习惯。_

最成功的外部刺激是立即反馈。因此你如何构建清晰的时刻。所以你如何在用户应该在确定时刻采取行动的思想下构建这种反馈？根据 [Prospect 理论](https://en.wikipedia.org/wiki/Prospect_theory)，人们行动会倾向于避免损失，因为同样数量下损失的痛苦会大于获得。这意味着比起有维护的已得的事物，我们更倾向于避免错过一些事情。

限时限量促销是核心工具，许多开发者用它来驱动用户立即购买而不是之后再说。这些手段被我们对失去的厌恶驱动。毕竟，不行动很快导致一种可能性 —— 『错过』交易或者物品。这个点子也可以被用作构建更具说服力的信息。例如，你可以选择聚焦在你用户在不行动可能失去，行动了才会获得的东西。

![](https://cdn-images-1.medium.com/max/800/0*WtMs-w9cf21LbpB0.)

健康和生活方式 app [Lifesum](https://play.google.com/store/apps/details?id=com.sillens.shapeupclub) 在加入为新用户准备的限时『新手套装』的第一天就看到了 15% 的增长。 『仅在今天』的信息形成了一种防止错过的紧迫感，驱使用户立即行动。

**关键结论总结:**

* 在代价和必要资源没有清晰地与最终价值挂钩的时候，用户将不会行动。
* 如果在可选项之间很难进行评估和选择，用户也不倾向于行动。
* 如果你在内容中给用户提供相关、可操作的触发，用户更倾向于进行按开发者意愿行动。

在 **3月19日周五****8:30 am (PST)** 加入或者访问 [Google I/O talk, “Boost User Retention with Behavioral Insights”](https://events.google.com/io/schedule/?sid=b187c653-5143-4b2d-addc-103e1f04fbc2#may-19) ，你可以获得更多的信息
。我将会和 [The Fabulous](https://play.google.com/store/apps/details?id=co.thefabulous.app) 的 CEO Sami Ben Hassine 一起，讨论开发者如何才能应用行为观点来构建更多有吸引力的应用体验。

* * *

#### 你怎么想?

你有关于在优化用户决定方面的问题或者想法吗？在下面评论区继续讨论或者通过井号标签 #AskPlayDev 通知我们，我们会在 [@GooglePlayDev](http://twitter.com/googleplaydev) （我们会定期分享在上面就如何在Google Play成功的话题分享新闻和小贴士）上回复。
* * *

_在我_ [第二篇博文](https://medium.com/googleplaydev/the-right-app-rewards-to-boost-motivation-c1ec86390450)_，我会解释一些行为改变第三步 —— 激发用户积极性的细节。我将探索积极性心理，它与游戏化的关系以及，正确的奖励方法。_

_尤其感谢_ [Aaron Otani](https://medium.com/@aaronotani) _为写这篇博文草稿时提供的反馈。_

---

译者注：

1. <a name="note1"></a> 这篇文章是作者三部曲的第一篇，续集详见：[传送门](https://medium.com/googleplaydev/the-right-app-rewards-to-boost-motivation-c1ec86390450)
2. <a name="note2"></a> 原文为`motivated users`，此处翻译为积极用户，期待指正

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juej

