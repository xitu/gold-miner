> * 原文地址：[Better stats for better decisions](https://medium.com/googleplaydev/better-stats-for-better-decisions-3661717b4f2d)
> * 原文作者：[Google Play Apps & Games Team](https://medium.com/@googleplayteam?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/better-stats-for-better-decisionsbetter-stats-for-better-decisions.md](https://github.com/xitu/gold-miner/blob/master/TODO1/better-stats-for-better-decisions.md)
> * 译者：[BriFuture](https://github.com/BriFuture)
> * 校对者：[jianboy](https://github.com/jianboy)

# 更好的数据，更明智的决策

![](https://cdn-images-1.medium.com/max/2000/0*xQKF5835ivk1ZLVs)

## 最新的 Google Play Console 和 Firebase 能够帮助你分析你的用户

**作者：**[_Tom Grinsted_](https://medium.com/@tomgrinsted_1649)（Google Play Console 的产品经理）和 [_Tamzin Taylor_](https://medium.com/@tamzint)（_Google Play_ 西欧区应用及游戏部主管）

Google Play 每天可产生逾 30 亿次事件，包括商店搜索，详情页浏览以及应用安装等事件。将所有事件和随之而来的数据量化成指标，做出分析并做成可以让你做出更明智的决策的工具，是我们的一部分工作。

回想一下你每天在业务中所做的事情时，你就会发现你总是在做决策，很多决策：关于业务、关于获取、关于开发以及关于产品规划的。良好的数据分析才能做出明智的决策。

本篇文章我们会讨论一些能用来进行发现、获取、互动和获利的重要工具。我们还会介绍用户生命周期模型中，有助于基准、观点和帮助制定决策的工具。

![](https://cdn-images-1.medium.com/max/1600/0*VRurbfuiI5T9EsYU)

### 用户生命周期

和每一段美好的旅途一样，你要从某个位置出发：你需要一个框架，它能让你以开发者的身份思考，需要哪些基准、观点和工具，还能为你完善应用、开创事业。这个框架就是用户生命周期。

![](https://cdn-images-1.medium.com/max/1600/0*BzrCmXezIGvetz2N)

生命周期始于发现和获取。这一阶段是，在大家面前，告诉他们你制作了一个十分有趣的应用或者游戏，并且安利他们安装。

安装完毕后就是交互和获利了。现在你得让人们每天都使用你的产品：打开它并且（最好是）爱上它。他们还会购买应用内商品并且订阅，因此你也可以获得收入。

如果你获得的每个人都会一直使用你的应用，而这就是故事的结局，那就真是太好了，但很不幸，你想多了。不论什么原因，有些人都会卸载你的应用或者游戏，从而成为流失的用户。

这不一定是故事的结局。劝服大家回归，用户生命周期才能延续，给你第二次或第三次机会，告诉他们在你应用中的美妙的新特性，让他们相信他们会想再次尝试这个应用。

正是在这个框架中，我们和 Google Play 的同事思考了摆在我们面前的挑战。

![](https://cdn-images-1.medium.com/max/1600/0*V39kFGek9nwQy46O)

### 用于发现和获取的工具

在我们查看有助于制定决策的工具前，先看看 Google Play Store 中的 3 个功能：抢先体验，预注册和 Google Play 免安装（Instant）。

**抢先体验程序（early access program）**让你可以在正式版应用发布前就开始发现用户。当你将应用或者游戏放到 Google Play Console 的开放下载渠道，就让 2 亿 3000 万用户中的某一个获取这款应用，他们参加了开放测试，而且每周还有 250 多万新人注册。

然后是 **预注册**。使用这个功能你可以把应用或者游戏放到 Play 商店，但人们只能看到预注册（Pre-Registration）按钮而不是安装按钮。一旦有人参加，你就可以告诉他们，这款应用或者游戏什么时候发布正式版。

> Ville Heijari, Rovio 娱乐公司的市场总监，评论道：“预注册很有用，能让你的粉丝对即将到来的游戏充满期待，并且在游戏发布时让他们得到通知。”

第三个功能是 **Google Play Instant（免安装）**。这是对免安装应用的扩展，它可以提供一小部分的应用体验，让用户不安装应用就可以尝试体验一款应用或者游戏。

> Hothead Games 公司启用了 Google Play Instant 功能，其市场预测师 Oliver Birch 表示：“我们几乎已经让商店列表中所有的应用点击率翻倍了。新用户增长率超过 19%。（因此）我们正计划对我们的所有游戏进行免安装推广。”

然而，你只可以管理你能够估量的东西。为了支持 Google Play Instant 的启动，帮助你了解它对你的底线的贡献，才有了 Play Console 中新的统计数据，

你现在可以查看免安装应用（Instant App）启动和转化的数量，某个用户打开你的免安装应用，进而下载完整版本的次数。而且，由于数据在 Play Console 中，你可以使用其他的关键指标，如安装和收入，切分整合信息。新增的数据能够跟踪是哪款产品——浏览器，Search 还是 Play 商店，推动你的免安装应用成功。

![](https://cdn-images-1.medium.com/max/1600/0*Bk80wPWQh-4yY5rU)

现在你可能在意如何获取有价值的用户。购买者的获取报告总是能做好这个工作，它将向你展示如何将 Play 商店中的访客变成回头客，并且现在它会告诉你在每个阶段中，每个用户带来的平均收入（ARPU）。

![](https://cdn-images-1.medium.com/max/1600/0*yRFpGCBHKQlGJy_z)

有了这一改进，你可以清楚的看到每个用户的平均花费是多少，你从不同的市场渠道中获取，包含自然流量。无论你要使用经典的 CPM 模型，还是要使用每次安装的花费（cost-per-Install）模型，或是要把价值推向漏斗尖部，这一信息对你评估自己的策略和制定更好的决策都非常重要。

最后，关于发现和获取的讨论，有新的基准。

![](https://cdn-images-1.medium.com/max/1600/0*ezYvfaP8ns_N4Ag1)

基准很棒，因为它们帮助你专注于投资那些收益最高的东西。保留应用的安装者是用户获取漏斗的基准，这也包含所有的自然流量，让你看看到底哪里有机会进行改进，哪里让你的投入获得回报。

> Intuit 合作公司的合作策略师 Brandon Ross 评论道：“自然基准帮助我们衡量与同行的转化率对比，并且帮助我们优化了查找和转化。”

![](https://cdn-images-1.medium.com/max/1600/0*-hQDAzHzWMpsOWN7)

### 增强和获利的工具

让我们拓宽眼界，谈谈 Firebase 工具，还有 Google Play Console 中的工具。

首先，不要忘了 Google Play Console 中的 **事件时间线（events timeline）**。

![](https://cdn-images-1.medium.com/max/1600/0*bPh3Rcmatd1DIMp0)

这篇新报告在统计页中图表的底部，Android vitas 控制面板，订阅控制面板，还有 Play Console 上的其他图表中提供了情境信息。报告将会展示对应用有影响的相关事件信息，比如新版本的占有率。举个例子，你可以看到与发行新版本相关的平均比率变化或价格变化是增加还是减少了 ARPU。



涉及到探索人们与应用的交互方式，Firebase 提供的这一工具现在可以提供更多的帮助。特别是，将分析 SDK 链接到你的应用中就能启用 **Google Analytics for Firebase**，当然，这需要注册相应服务。

开箱即用，Google Analytics for Firebase 提供了关于交互和保留用户的有意义的指标。但是，你也可以编写代码来追踪对你的应用或者游戏影响最大的活动。

![](https://cdn-images-1.medium.com/max/1600/0*wKhlf4ypBdPgQpWk)

解析你从 Google Analytics for Firebase 获得的所有信息，这有时候可能是个难题，但是 **Firebase Predictions** 可以让它变得简单得多。

Firebase Predictions 使用解析数据，结合机器学习和其他工具，为你预测人们使用应用的方式。默认地，你可以获取用户花费和流失的预测。而且，你可以构建自己的应用，预测对你而言最重要的功能和行为。

接着是获利阶段，已经有一些针对订阅信息的改进。自去年启用的 **订阅控制面板（subscription dashboard）**被由大多数最赚钱的订阅业务定期使用。这就是为什么我们一直在加强这个面板的功能，包括改进用户保留和删除的报告。

注意观察即将到来的 **订阅、保留和删除报告** 的更新，它会让同类群组的比较及免费试用和账号保留等重要功能的评估变得更加简单。你也能够轻松地追踪更多像续费这样的重要数据。

![](https://cdn-images-1.medium.com/max/1600/0*SKEE_M66uRfVJKbg)

通过 **同类群组选择器**，你可以通过 SKU（库存量单位），日期和国家选出一组用户，使用这个功能，专注于一组订阅者并分析他们的行为。比如，你可以选择一个免费尝试的 SKU，将它与一个产品价格的 SKU 对比，看看哪一个获利更多。

涉及到减少订阅时，更新 **卸载报告** 会帮你获得更多关于人们取消订阅的原因的信息。

![](https://cdn-images-1.medium.com/max/1600/0*WJzoyAnXXde_D6Ef)

当某个用户取消了订阅，让他们填写一份调查表，这样他们就可以解释为什么取消。并且这些调查的结果可以从订阅控制面板上查看。

控制面板现在也可以报告用户回归特征，诸如 **账号保留** 和 **使用周期**。

![](https://cdn-images-1.medium.com/max/1600/0*-rQoM5mDb6yXpKmm)

### 用户回归、重新安装

Play Console 提供关于卸载的报告，比如，每日的卸载信息或者卸载事件。而且，在保存的安装者获取报告中，你可以找到诸如人们保留应用的时间。

我们从很多开发者那里获知，他们想要更多信息，我们能理解其中的原因。今年稍晚时候，你会看到一些新功能，比如能够分析有多少人卸载你的应用，有多少人在安装你的应用。因此保持关注以便获得更多更新。

![](https://cdn-images-1.medium.com/max/1600/0*8iSi6BGBiDcP8t7N)

### 应用控制面板

所有的新信息带来了挑战。作为开发者，你已经够忙了。你有一堆来自 Google 或其它公司的工具，并且要从许多地方获取你需要的所有信息。你需要的是用简单的方式来查看 Play Console 必须提供的，并且对你而言重要的信息。

一个解决方案是：Google Play Console 中的 **应用控制面板**。

![](https://cdn-images-1.medium.com/max/1600/0*yd-BCQ5XxJKRmBlh)

在 Google Play Console 中选中一款应用后打开的页面就是应用控制面板。最前面的是提供的趋势信息：如安装，收益，评分和崩溃等。后面是一组互补的数据，如安装和卸载，总收益和每位用户带来的收入（RPU）。

面板可以定制，每一部分都能被展开或者折叠。因此如果你对收益感兴趣，你可以展开这一部分，但对预注册部分不那么感兴趣，就可以将这一部分折叠。面板会记住你的偏好，并保持你离开时的状态。

### 终语

用户生命周期已经成为促使 Google Play Console 的新功能和更新的重要方式了。结果，这些变化是为了帮助你优化每一个阶段：从用于发现和获取的 Google Play Instant 和预注册，到新的订阅报告、加强的获取报告、新的事件时间线以及卸载统计。这一信息和其它的细节，比如技术性能，都包含在了应用控制面板中。

这里的所有工具将会帮助你走向成功，通过让你更好的理解用户。如果你想了解更多内容，[查看更多关于获取的最佳实践](https://developer.android.com/distribute/best-practices/grow/user-aquisition)，或者在下方的 I/O 2018 会议中了解更多发布内容。

* YouTube 视频链接：https://youtu.be/oib_gHJA_-0?list=PLWz5rJ2EKKc9Gq6FEnSXClhYkWAStbwlC

### 你怎么看？

你有什么关于分析应用获取和交互的想法吗？在下方的评论区留言或者在推特上参加 **#AskPlayDev** 的讨论，我们会用 [@GooglePlayDev](http://twitter.com/googleplaydev) 账号进行回复，我们经常在推特上分享一些如何在 Google Play 中获得成功的消息和小窍门。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
