> * 原文地址：[Implementing linkedPurchaseToken correctly to prevent duplicate subscriptions](https://medium.com/androiddevelopers/implementing-linkedpurchasetoken-correctly-to-prevent-duplicate-subscriptions-82dfbf7167da)
> * 原文作者：[Emilie Roberts](https://medium.com/@emilieroberts?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/implementing-linkedpurchasetoken-correctly-to-prevent-duplicate-subscriptions.md](https://github.com/xitu/gold-miner/blob/master/TODO1/implementing-linkedpurchasetoken-correctly-to-prevent-duplicate-subscriptions.md)
> * 译者：
> * 校对者：

# Implementing linkedPurchaseToken correctly to prevent duplicate subscriptions

Do you use Google Play subscriptions? Make sure your back-end server implements them correctly.

The subscription REST APIs are the source of truth for managing user subscriptions. The [Purchases.subscriptions API](https://developers.google.com/android-publisher/api-ref/purchases/subscriptions#resource) response contains an important field called **linkedPurchaseToken.** Proper treatment of this field is critical for ensuring the correct users have access to your content.

![](https://cdn-images-1.medium.com/max/800/1*akzNIZFqfp7xMmv2DYSlVA.jpeg)

### How does it work?

As outlined in the [subscriptions documentation](https://developer.android.com/google/play/billing/billing_subscriptions#Allow-upgrade), every new Google Play purchase flow–initial purchase, upgrade, downgrade, and [resignup¹](#eb81)–generates a new purchase token. The **linkedPurchaseToken** field makes it possible to recognize when multiple purchase tokens belong to the same subscription.

For example, a user buys a subscription and receives a purchase token A. The **linkedPurchaseToken** field (grey circle) will not be set in the API response because the purchase token belongs to a brand new subscription.

![](https://cdn-images-1.medium.com/max/800/1*GRrs01R-tlUNxzDGnQqGSw.png)

If the user upgrades their subscription, a new purchase token B will be generated. Since the upgrade is replacing the subscription from purchase token A, the **linkedPurchaseToken** field for token B (shown in the grey circle) will be set to point to token A. Notice it points backwards in time to the original purchase token.

![](https://cdn-images-1.medium.com/max/800/1*TeEsm7UtgRWQbgDizGEIjQ.png)

Purchase token B will be the only token that renews. Purchase token A should not be used to grant users access to your content.

**Note:** at the time of upgrade, both purchase token A and B will indicate they are active if you query the Google Play Billing server. We will talk about this more in the [next section](#14e4).

Now, let’s suppose a different user performs the following actions: subscribe, upgrade, downgrade. The original subscription will create purchase token C, the upgrade will create purchase token D, and the downgrade will create purchase token E. Each new token will link backward in time to the previous one.

![](https://cdn-images-1.medium.com/max/800/1*T_m70ZdZp_PINQW4WFGmow.png)

Let’s add a third user to the example. This user keeps changing their mind. After an initial subscription, the user cancels and re-subscribes ([resignup](#eb81)) three times in a row. The initial subscription will create purchase token F, and the resignups create G, H, and I. The purchase token I is the most recent token.

![](https://cdn-images-1.medium.com/max/800/1*PXSvlU_mV6F3DbZmm2Pb_w.png)

The most recent tokens–B, E, and I–represent the subscriptions that users 1, 2, and 3, respectively, are entitled to and paying for. Only these most recent tokens are valid for entitlement. However, all of the tokens in the chain are “valid” as far as Google Play is concerned, if the initial expiry date has not yet passed.

In other words, if you query the [Subscriptions Get API](https://developers.google.com/android-publisher/api-ref/purchases/subscriptions/get#response) for any of the tokens, including A, C, D, F, G, or H in the diagram above, you will get a [Subscription Resource Response](https://developers.google.com/android-publisher/api-ref/purchases/subscriptions#resource) that indicates that the subscription has not expired and that the payment has been received, even though you should only grant entitlement for the latest tokens.

This may seem odd at first: why would the original tokens appear to be valid even after they have been upgraded? The short answer is that this implementation offers developers more flexibility when providing content and services to their users and helps Google protect user privacy. However, it does require you to do some important bookkeeping on your back-end server.

### Handling linkedPurchaseToken

Every time you verify a subscription, your back-end should check if the **linkedPurchaseToken** field is set. If it is, the value in that field represents the previous token that has now been replaced. You should immediately mark that previous token as invalid so that users cannot use it to access your content.

So for User 1 in the example above, when the back-end receives the purchase token A for the initial purchase, with an empty **linkedPurchaseToken** field, it enables entitlement for that token. Later, when the back-end receives the new purchase token B after the upgrade, it checks the **linkedPurchaseToken** field, sees that it is set to A, and disables entitlement for purchase token A.

![](https://cdn-images-1.medium.com/max/800/1*AelIWEUip7r0BfdTrYwnMQ.png)

In this way, the back-end database is always kept up-to-date with which purchase tokens are valid for entitlement. In the case of User 3, the state of the database would evolve as follows:

![](https://cdn-images-1.medium.com/max/800/1*ZnPLMmL6oAeLtYX-OBtEgw.png)

Pseudo-code for checking **linkedPurchaseToken**:

You can see an example of this in the Firebase back-end of [Classy Taxi](https://github.com/googlesamples/android-play-billing/tree/master/ClassyTaxi), an open-source end-to-end subscription app. Specifically, see the **disableReplacedSubscription** method in [PurchasesManager.ts](https://github.com/googlesamples/android-play-billing/blob/5415f5563d5aeaf3f0e7e4457f826de9bf12a590/ClassyTaxi/firebase/server/src/play-billing/PurchasesManager.ts#L163).

### Clean up an existing database

Now your back-end will be kept up-to-date with new, incoming purchase tokens, you will check each new purchase for the **linkedPurchaseToken** field, and any tokens corresponding to a replaced subscription will be correctly disabled. Awesome!

But what if you have an existing database of subscriptions which did not account for the **linkedPurchaseToken** field? You will need to run a one-time clean-up algorithm on your existing database.

In many cases, the most important thing when cleaning up a database is whether or not a given token is entitled to content/services. In other words: it may not be necessary to recreate the upgrade/downgrade/resignup purchase history for each subscription, only to determine the correct entitlement for each individual token. A one-time clean-up of the database will get things into shape and, moving forward, new incoming subscriptions just need to be handled as described in the previous section.

Imagine the purchase tokens for our three users above are stored in a database. These purchases may have happened over time and could appear in any order. If the clean-up function does this right, tokens B, E, and I should end up marked as valid for entitlement and all the other tokens should be disabled.

Pass one time through the database and check each element. If the **linkedPurchaseToken** field is set, then disable the token contained in that field. For the diagram below, we move through from top to bottom:

![](https://cdn-images-1.medium.com/max/800/1*vl8exBJCC-F-dKcE9hSmFg.png)

Element A: linkedPurchaseToken not set, move to next  
Element D: linkedPurchaseToken == C, disable C  
Element G: linkedPurchaseToken == F, disable F  
Element E: linkedPurchaseToken == D, disable D  
Element F: linkedPurchaseToken not set, move to next  
Etc.

Pseudo-code for cleaning-up existing database:

After running this one-time clean up, all the old tokens will be disabled and your database will be ready to go.

### Simple but important

Now that you understand how the **linkedPurchaseToken** field works, make sure to handle it correctly in your back-end. Every app with subscriptions should be checking this field. Correctly keeping track of entitlement is crucial to ensuring the right user is granted the right entitlement at the right time.

### Resources

*   Google [Play Billing Library](https://developer.android.com/google/play/billing/billing_library_overview)
*   Subscription [upgrades and downgrades](https://developer.android.com/google/play/billing/billing_subscriptions#Allow-upgrade)
*   [Subscriptions API](https://developers.google.com/android-publisher/api-ref/purchases/subscriptions#resource)
*   [ClassyTaxi](https://github.com/googlesamples/android-play-billing/tree/master/ClassyTaxi) end-to-end subscriptions sample app

[**_¹Resignup_**](#895f) _refers to when a user subscribes, cancels their subscription, and then re-subscribes before the original subscription has expired. Although they have not lost entitlement and the new subscription will be the same as the previous one, they will go through another purchase flow as they are committing to future payments. They will receive a new purchase token and the linkedPurchaseToken field will be set, as in the case of an upgrade or downgrade._

> _All code found here is licensed under the_ [_Apache 2.0 license_](https://www.apache.org/licenses/LICENSE-2.0)_. Nothing here is part of any official Google product and is for reference only._

> Token image at start of article was copied from [this url](https://commons.wikimedia.org/wiki/File:French_revolutionary_shop_token_%28FindID_530752%29.jpg). Attribution: The Portable Antiquities Scheme/ The Trustees of the British Museum. Licensed under the [Creative Commons](https://en.wikipedia.org/wiki/en:Creative_Commons "w:en:Creative Commons") [Attribution-Share Alike 2.0 Generic](https://creativecommons.org/licenses/by-sa/2.0/deed.en) license.

Thanks to [Cartland Cartland](https://medium.com/@cartland_88360?source=post_page).

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
