> * 原文地址：[How to win back subscribers who cancel: Learn how developers spot at-risk subscribers, and win them back if they leave](https://medium.com/googleplaydev/how-to-win-back-subscribers-who-cancel-9960731adeb)
> * 原文作者：[Laura Willis](https://medium.com/@laura.willis22?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-win-back-subscribers-who-cancel.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-win-back-subscribers-who-cancel.md)
> * 译者：[allenlongbaobao](https://github.com/allenlongbaobao)
> * 校对者：[LuoJiacheng](https://github.com/LuoJiacheng)、[Starrier](https://github.com/Starrier)

# 怎样把取消订阅的用户吸引回来

## 学习作为开发者如何识别有离开风险的用户，并且如果他们离开的话，怎样吸引回来。

![](https://cdn-images-1.medium.com/max/800/1*wLhnuD2dXjD5xdrYhqQ5ZQ.png)

在「[如何留住你的产品用户](https://medium.com/googleplaydev/how-to-hold-on-to-your-apps-subscribers-eebb5965e267)」一文中，我的同事 [Danielle Stein](https://medium.com/@daniellestein_60947) 讨论了如何吸引用户，这样他们就不会流失了。但是，我肯定很大一部分的开发者知道，用户流失是客观存在的。那么，你怎么把这些离开的用户吸引回来呢？下面我将分享从在 Google Play 上有着成功吸引客户经验的开发者身上学到的知识。

### **知识（信息）就是力量！**

谜题的第一个答案就是：监控你的用户。这样一来，如果他们处在取消订阅边缘或者正在取消的时候你就会知道。做到这一点有很多方法。[**开发者实时通知**](https://developer.android.com/google/play/billing/realtime_developer_notifications.html)，它会给你推送通知，比如「取消」、「暂停」、「重启」，总之，只要用户的状态一改变，就会推送通知。另外，当用户打开你的应用的时候，你可以检查他的订阅状态。有了这些信息之后，你就可以围绕它展开一些行动了！你可以呼吁用户修改他们的支付订单，或者给他们提供一些折扣以免他们离开，又或者通过展示产品新内容新特性来说服他们回归。

> 使用实时用户通知工具允许 [Elevate](https://docs.google.com/document/d/15GL1p5Kck8GwYIkcvMpYxi9HvGqEiuN2QOmESDrFHOA/edit?ts=5a98636f#heading=h.zhm9jn6w7dxv) 给那些离开的用户发一封邮件，提醒他们如果离开，会蒙受哪些损失，并邀请他们重新订阅产品。

![](https://cdn-images-1.medium.com/max/800/0*6gFz6HN_mFNXCJWu.)

### 确保你不会因为意外而损失用户

你知道真正难办的是什么吗？因为支付失败而意外损失用户，它被称作是 **不自主的流失**。Google Play 提供了几种高效工具来帮助你阻止这些发生。设置一个[**宽限期**](https://developer.android.com/google/play/billing/billing_subscriptions.html#grace-period)对用户进行保留，这样一来，当用户续费失败的时候，你就有额外的 3 - 7 天来修复支付问题。自从使用了宽限期这个功能，Google Play 上的开发者发现续费失败用户的重新订阅比例高达 57%。这个功能可以在 [**Google Play 控制台**](https://play.google.com/apps/publish)中开启一个开关来轻松实现，不需要任何代码参与进来。如果这还不能说服你，那么 ———— 实际上，Google Play 上 80% 的顶尖开发者都开启了宽限期功能。

![](https://cdn-images-1.medium.com/max/800/0*eLdFcYo11r5ACRNB.)

关于宽限期，再补充一点：你可以增加[账户保留](https://developer.android.com/google/play/billing/billing_subscriptions.html#account-holds)功能。有了它，你可以将支付失败的用户放入一个挂起状态，并阻止他们访问内容直到支付成功，这样也能促进他们去进一步支付。然而，账户挂起需要一些额外的代码，不像宽限期，后者不需要浪费你额外的时间去提供内容。

![](https://cdn-images-1.medium.com/max/800/1*OYTPoI-4oIjizpC_qTDB2Q.png)

这里有一些反馈来自 **大量** 开发者，他们的回归率因为账户保留而得到了提升。

![](https://cdn-images-1.medium.com/max/800/1*Z0tBEGEwoAxr6aTVOzuMhg.png)

> [火种，](https://play.google.com/store/apps/details?id=com.tinder&hl=en) 一个流行的约会软件，自从实现了账户保留，**回归率得到 3 倍提升**。「账户保留让我们能够恢复支付，正常的话可能流失了。这是一个傻瓜式操作，而且部署很简单，」Yiqi Meng，火种软件工程师。

![](https://cdn-images-1.medium.com/max/800/1*MTtL-UHf1v9hJiawrO8zVw.png)

> 当 [Keepsafe](https://play.google.com/store/apps/details?id=com.kii.safe&hl=en) （一个加密相片、视频的应用）集成了账户保留功能，他们 **在安卓上的续费率提升了 25%** ———— 来自 Keepsafe Photo Valut 的开发者。Keepsafe 的用户信赖他们的付费账户，这样他们能够加密相片和视频，相当于购买了安全。所以，当他们的账户因为支付失败被挂起的会后，他们极大可能重新提交支付信息来解决这个问题。

那么，你会选择哪一种呢？我们看得到最佳结果是开发者两者（宽限期和账号保留）都启用了，当然，你也可以只选择其中的一种。

### **提供他们无法拒绝的服务**

我们假设可怕的事情发生了，一个用户想要取消订阅或者离开。使用不同的消息渠道，比如 **站内信息**，**通知**，**邮件**，**短信**，可以看到，开发者成功使用不同的方式去说服用户改变他们的注意。Google Play 研究显示，那些赢回用户的方式更多地只是一种呼吁，因为，他们没有准确定位用户取消订阅的特殊原因，他们没有做假设。比如，不要假设价格是用户取消的唯一原因，想当然地提供一个折扣。有些用户取消的原因可能是他们觉得内容不够新，如果你能向他们展示你添加的新内容，可能更有说服力。

*   **给用户一个选择不同方案的机会。** 有时候一个用户想要取消，可能是因为他们当前的购买方案和需求不相匹配。也许是因为太贵并且有些功能他们用不到，或者他们之前忘了还有一种购买方案拥有一些当前方案没有的功能。给用户提供[**升级或者降级**](https://developer.android.com/google/play/billing/billing_reference.html#upgrade-getBuyIntentToReplaceSkus)到不同的产品方案的能力，从而避免用户取消订单。举个例子，当一个收音机应用的「高级用户」想要离线收听，他们会被提示在应用内升级为「最高级用户」。你也可以在应用内创建一个 「管理服务」的按钮来展示这一功能。

![](https://cdn-images-1.medium.com/max/800/1*H0gP5CrTZjTMGUiKYvJ8aw.png)

*   **使用一些赠品，比如，给用户提供有期限的服务，作为网络不稳定或者服务出错的补偿策略。** [终极吉他](https://play.google.com/store/apps/details?id=com.ultimateguitar.tabs&hl=en) 使用实时用户通知工具来感知用户何时取消了订单。随后，他们会联系取消用户并提供他们几个星期的免费服务，原因是一些用户提出的问题，比如产品不稳定。终极吉他介绍，这些收到免费服务的用户「感觉我们很在乎他们的用户体验，然后成为了忠实用户。」你可以使用 [**Google Play Developer API**](https://developer.android.com/google/play/developer-api.html#subscriptions_api_overview) 为你的用户延缓订单。
*   **高亮用户没有使用过的或者他们取消后将失去的内容或者特性**。[Google Play 研究](https://g.co/play/subscriptioninsights2017)显示访问内容是大部分用户起初订阅或者持续订阅的原因，因此将内容作为留住用户的保留策略。对于那些有免费试用者的产品，如果有人一直使用试用版本，那么站内消息十分有用。比如，流音乐服务 [Anghami](https://play.google.com/store/apps/details?id=com.anghami&hl=en) 反复强调他们的离线模式这一核心付费功能，敦促那些即将离开的订阅者去重新订阅，他们会对用户说：「恢复你曾下载过的 38 首歌。」

![](https://cdn-images-1.medium.com/max/800/1*lIeLgzpRAa4FuxqOkcAcGA.png)

现在，你可以让用户恢复之前取消的订阅，但必须是他们的订阅还未到期。在订阅到期之前，你可以引导用户去[**订阅恢复**](https://developer.android.com/google/play/billing/billing_subscriptions.html#restore)按钮。我们的数据显示 18% 的主动离开发生在用户注册的第一天，30-40% 发生在第一个星期。这一情况表明使用恢复功能去赢回用户是个机会，因为他们有大量的时间去改变主意，他们只要重新加入，并恢复订阅，而不需要再走一次注册流程。

*   **给订阅者一个重新订阅折扣，可以提供** [**介绍价格**](https://support.google.com/googleplay/android-developer/answer/140504?hl=en#intro) **或者** [**免费试用**](https://developer.android.com/google/play/billing/billing_subscriptions.html#trials)**。** 许多开发者使用介绍价格和免费试用来争取用户，但是它也可以帮你留住订阅者，特别是如果付费存在问题的话。约会软件 [Jaumo](https://play.google.com/store/apps/details?id=com.jaumo&hl=en) 在用户付费订阅结束后的 3 天，提供 30% 折扣。通过这个服务，他们能够 **赢回大概 5% 的订阅者**

无论哪一种服务，它们都不是唯一的选择，测试是检测它是否对你的用户有帮助的最好方法。Google Play 研究显示当用户浏览挽回服务的时候，他们会对选项估值，比如选择重新激活时间，选择多种计划，选择不同的服务。对不同的库存量（SKU）采用 A/B 测试，计算支出，看看哪种方式对你的产品更有用。在产品内做 A/B 测试，你可以选择自己设置，也可以使用 [Firebase remote config](https://firebase.google.com/docs/remote-config/abtest-config)。

好了，你学到了！有了这些提示和方法，你再也不会流失一个订阅者了，对吧？我们都知道，这并不是这样简单，用户保留是订阅产品的开发者面临的重大挑战之一。你可以下载[**这篇文章的 PDF 版本**](http://services.google.com/fh/files/misc/win_back_subscribers_googleplay.pdf)，总结我以上讨论的要点，分享给那些不愿意阅读整篇文章的朋友。

* * *

### **你怎么看？**

关于怎么把订阅者吸引回来，如何防止用户流失，你有其他想法吗？哪种方法最适合你？在下方积极留言吧，或者在推特上关注 **AskPlayDev** 标签，我们会使用 [@GooglePlayDev](http://twitter.com/googleplaydev) 账号来回复，这个账号上，我们还会经常分享如何在 Google Play 上取得成功的新闻和技巧。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
