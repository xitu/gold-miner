> * 原文地址：[Implementing linkedPurchaseToken correctly to prevent duplicate subscriptions](https://medium.com/androiddevelopers/implementing-linkedpurchasetoken-correctly-to-prevent-duplicate-subscriptions-82dfbf7167da)
> * 原文作者：[Emilie Roberts](https://medium.com/@emilieroberts?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/implementing-linkedpurchasetoken-correctly-to-prevent-duplicate-subscriptions.md](https://github.com/xitu/gold-miner/blob/master/TODO1/implementing-linkedpurchasetoken-correctly-to-prevent-duplicate-subscriptions.md)
> * 译者：[yuwhuawang](https://github.com/yuwhuawang)
> * 校对者：[zx-Zhu](https://github.com/zx-Zhu)

# 正确实现 linkedPurchaseToken 以避免重复订阅

你是否在使用 Google Play 的订阅功能？要确保你的后端服务实现的方式是正确的。

订阅 REST APIs 是管理用户订阅的真实可信来源。[Purchases.subscriptions API](https://developers.google.com/android-publisher/api-ref/purchases/subscriptions#resource) 的返回包括一个非常重要的字段叫做 **linkedPurchaseToken。** 恰当的处理这个字段，对于保证正确的用户能够访问你的内容是非常重要的。

![](https://cdn-images-1.medium.com/max/800/1*akzNIZFqfp7xMmv2DYSlVA.jpeg)

### 它是如何工作的？

就像 [订阅文档](https://developer.android.com/google/play/billing/billing_subscriptions#Allow-upgrade) 里指出的, 每一笔新的 Google Play 的购买流程 —— 初始化购买、升级和降级还有 [重新注册¹](#eb81) —— 都会产生一个新的购买令牌。而 **linkedPurchaseToken** 字段则可以用来识别属于同一个订阅的多个购买令牌。

打个比方，一个用户购买了一个订阅并且收到一个购买令牌 A。**linkedPurchaseToken** 字段（灰色圆圈）在 API 的返回里没有值，因为这个购买令牌属于一个全新的订阅。

![](https://cdn-images-1.medium.com/max/800/1*GRrs01R-tlUNxzDGnQqGSw.png)

如果用户升级了他们的订阅，一个新的购买令牌 B 产生了。既然这个升级替代了购买令牌 A 代表的订阅，令牌 B 的 **linkedPurchaseToken** 字段（灰色圆圈显示的）将会指向令牌 A。注意它按照时间的逆序指向原始的购买令牌。

![](https://cdn-images-1.medium.com/max/800/1*TeEsm7UtgRWQbgDizGEIjQ.png)

购买令牌 B 将会是唯一被更新的令牌。购买令牌 A 不应该用来授权用户获取你的内容。

**注意：** 更新订阅时，如果你查询 Google Play 的订单服务器，购买令牌 A 和 B 都会是激活的。我们会在 [下一节](#14e4) 里讨论这个问题。

现在，让我们假设一个另一个用户执行了以下操作：订阅、升级和降级。原始的订阅会创建购买令牌 C，升级操作会创建购买令牌 D，降级操作会创建购买令牌 E。每一个令牌都会按照时间的逆序指向前一个令牌。

![](https://cdn-images-1.medium.com/max/800/1*T_m70ZdZp_PINQW4WFGmow.png)

让我们在这个例子里加上第三个用户。这个用户一直在改变主意。在初始化订阅之后，用户又一连三次取消了订阅然后重新订阅（[重新订阅](#eb81)）。初始化订阅创建了购买令牌 F，重新订阅创建了 G、H 和 I。购买令牌 I 是最近的令牌。

![](https://cdn-images-1.medium.com/max/800/1*PXSvlU_mV6F3DbZmm2Pb_w.png)

最近的令牌 B、E 和 I 分别代表了用户 1、2、3 的最终授权和付账的订阅。只有这些最近的令牌才有相应的权利。然而对于 Google Play 来讲，如果初始的过期时间还没到，所有的令牌都是“有效的”。

也就是说，如果你通过 [获取订阅 API](https://developers.google.com/android-publisher/api-ref/purchases/subscriptions/get#response) 来查询这些令牌，包括上面的图表内的 A, D, F, G和H，你会得到 [订阅资源响应](https://developers.google.com/android-publisher/api-ref/purchases/subscriptions#resource) ，响应里表明订阅还没有过期并且付款已经收到，即便如此你也只应该根据最近的令牌来授权。

第一眼看上去很奇怪：为什么最初的令牌还是在被更新后还是有效的？简单来说是这样实现能让开发者更灵活地提供内容和服务，也让 Google 更好的保护用户隐私。然而这也确实需要你在后端服务器上进行重点记录

### 操作 linkedPurchaseToken

每次当你确认一个订阅，你的后台服务都应该检查 **linkedPurchaseToken** 字段有没有被设定。如果已经被设定，该字段的值就代表着前一个被替换的令牌。你应该立刻把前一个令牌标记为失效，这样用户就不能使用这个令牌访问你的内容。

我们再来看看上面例子里的用户 1, 当后端服务器收到了代表初始购买的凭证 A，该凭证 A 的 **linkedPurchaseToken** 字段为空，这时应根据凭证进行授权。接下来，当后端服务器接收到更新后新的购买凭证 B，服务器会检查 **linkedPurchaseToken** 字段，发现它被设置为令牌 A，于是就禁掉令牌 A 的授权。

![](https://cdn-images-1.medium.com/max/800/1*AelIWEUip7r0BfdTrYwnMQ.png)

这样的话，后端数据库总是保存有效权限的购买凭证。以用户 3 的例子来说，数据库的状态变化应该如下图：

![](https://cdn-images-1.medium.com/max/800/1*ZnPLMmL6oAeLtYX-OBtEgw.png)

检查 **linkedPurchaseToken** 的伪代码：

你可以在一个开源的，端对端订阅的应用 [优雅出租车](https://github.com/googlesamples/android-play-billing/tree/master/ClassyTaxi) 的后台 Firebase 上看一些例子，特别是看 **disableReplacedSubscription** 方法，它在 [PurchasesManager.ts](https://github.com/googlesamples/android-play-billing/blob/5415f5563d5aeaf3f0e7e4457f826de9bf12a590/ClassyTaxi/firebase/server/src/play-billing/PurchasesManager.ts#L163) 里。

### 清理现有的数据库

现在你的后端应该和最新的，接连到来的购买令牌保持同步，你会检查每一个购买的 **linkedPurchaseToken** 字段，并且每一个对应着被替换订阅的令牌，都被正确的禁用了。这太棒了！

但是如果你有一个已有的订阅数据的数据库，并且没有根据 **linkedPurchaseToken** 字段来调整？你需要在这个数据库上跑一个一次性的清理算法。

在很多情况下清理数据库中最重要的工作就是，一个令牌是否被能够授权相应的内容和服务。也就是说：并不需要对每一个订阅重新创建升级/降级/重新订阅的购买历史，而只需要确定每个令牌正确的授权情况。一次性的数据库清理任务就可以把订阅状态整理清楚。接下来，新到来的订阅就需要像上一节中描述的那样处理。

想象一下上面三个用户的购买凭证都存在数据库里。这些购买可能出现在任何时间，顺序也不一样。如果清理功能正确处理的话，令牌 B、E 和 I 最终会被标记为有效授权，而其他的令牌则会被禁用。

对数据库进行一次遍历，并检查每一项。如果 **linkedPurchaseToken** 字段被设置，就把这个字段包括的字段禁用。根据下面的图表，我们从上到下移动：

![](https://cdn-images-1.medium.com/max/800/1*vl8exBJCC-F-dKcE9hSmFg.png)

元素 A：linkedPurchaseToken 没有被设定，移至下一项
元素 D：linkedPurchaseToken == C，禁用 C
元素 G：linkedPurchaseToken == F，禁用 F
元素 E：linkedPurchaseToken == D，禁用 D
元素 F：linkedPurchaseToken 没有被设定，移至下一项
等等。

清理现有数据库的伪代码：

执行完一次性的清理之后，所有的旧令牌都会被禁用，你的数据库也就准备好了。

### 简单但是重要的事

现在你已经理解 **linkedPurchaseToken** 字段是怎么工作的，确保在你的后端正确的处理它。每一个有订阅功能的应用都应该检查这个字段。正确的追踪授权对于保证正确的用户，在正确的时间，被授予了正确的权利这一点来说，非常关键。

### 参考资料

*   Google [Play Billing Library](https://developer.android.com/google/play/billing/billing_library_overview)
*   Subscription [upgrades and downgrades](https://developer.android.com/google/play/billing/billing_subscriptions#Allow-upgrade)
*   [Subscriptions API](https://developers.google.com/android-publisher/api-ref/purchases/subscriptions#resource)
*   [ClassyTaxi](https://github.com/googlesamples/android-play-billing/tree/master/ClassyTaxi) 端对端订阅的简单应用

[**¹重新注册](#895f) 是指当一个用户订阅，然后取消订阅，接着又在初始的订阅过期之前重新订阅。尽管用户不会丢失授权，新的订阅也和之前的一样，他们还是会经历另一个付款流程，因为他们承诺了未来的付款。他们会收到新的购买令牌并且 linkedPurchaseToken 字段会在升级或者降级的时候被设置。**

> **本文所有的代码都遵循 [Apache 2.0 许可](https://www.apache.org/licenses/LICENSE-2.0)。本文不包括 Google 正式产品任何部分，并且只是为了参考使用。**

> 文章开始的令牌图片是从 [该链接](https://commons.wikimedia.org/wiki/File:French_revolutionary_shop_token_%28FindID_530752%29.jpg) 复制的。归属：便携式古物计划/大英博物馆基金会。[知识共享](https://en.wikipedia.org/wiki/en:Creative_Commons "w:en:Creative Commons") 下 [归属共享 2.0](https://creativecommons.org/licenses/by-sa/2.0/deed.en) 许可。

感谢 [Cartland Cartland](https://medium.com/@cartland_88360?source=post_page)。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
