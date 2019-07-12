> * 原文地址：[Subscriptions 101 for Android Apps](https://medium.com/androiddevelopers/subscriptions-101-for-android-apps-b7005a7e93a6)
> * 原文作者：[Emilie Roberts](https://medium.com/@emilieroberts)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/subscriptions-101-for-android-apps.md](https://github.com/xitu/gold-miner/blob/master/TODO1/subscriptions-101-for-android-apps.md)
> * 译者：
> * 校对者：

# Subscriptions 101 for Android Apps

[Subscriptions on Google Play Billing](https://developer.android.com/google/play/billing/billing_subscriptions) can be an excellent way to grow your business. However, coordinating between your Android app and back-end server can be daunting.

![](https://cdn-images-1.medium.com/max/7448/1*UvuzX1CDUzXPCOc60H9AVA.png)

The [Subscriptions 101 video series](https://www.youtube.com/playlist?list=PLWz5rJ2EKKc9J8ylTbNo1mnwciEyMbxZG) will help you understand how all the pieces of the subscription puzzle fit together, including basic server setup, [real-time developer notifications](https://developer.android.com/google/play/billing/realtime_developer_notifications), [upgrades and downgrades](https://developer.android.com/google/play/billing/billing_subscriptions#Allow-upgrade), [linkedPurchaseToken](https://medium.com/androiddevelopers/implementing-linkedpurchasetoken-correctly-to-prevent-duplicate-subscriptions-82dfbf7167da), [grace period](https://developer.android.com/google/play/billing/billing_subscriptions#account-hold---subscription_on_hold), and more.

## Understanding Subscriptions

The first video outlines the terminology that will be used throughout the video series and describes the various components you’ll need including: your Android app, your back-end server, the [Google Play Billing Library](https://developer.android.com/google/play/billing/billing_library_overview), the [Google Play Developer API](https://developers.google.com/android-publisher/), and [Google Cloud Pub/Sub](https://developer.android.com/google/play/billing/realtime_developer_notifications).

## Subscription Purchase Flow

This video describes the purchase flow for subscriptions. Using the [Google Play Billing Library](https://developer.android.com/google/play/billing/billing_library_overview), you can [check for existing subscriptions](https://developer.android.com/reference/com/android/billingclient/api/BillingClient#queryPurchases(java.lang.String)) and [launch the billing flow](https://developer.android.com/reference/com/android/billingclient/api/BillingClient#launchBillingFlow(android.app.Activity,%20com.android.billingclient.api.BillingFlowParams)) for new signups. After a successful purchase, you will get back a [purchase token](https://developer.android.com/google/play/billing/billing_overview#purchase-tokens-and-order-ids) and the [order ID](https://developer.android.com/google/play/billing/billing_overview#purchase-tokens-and-order-ids), which represent the user’s entitlement and transaction with Google respectively. Keep track of this information on your secure back-end server in order to correctly grant access to your product or services.

## Real-time Developer Notifications

[Real-time Developer Notifications (RTDN)](https://developer.android.com/google/play/billing/realtime_developer_notifications) allow you to stay up-to-date with the state of your subscriptions via notifications to your server from [Google Cloud Pub/Sub](https://cloud.google.com/pubsub/docs/).

When you receive an RTDN notification, verify the purchase token contained in that notification and retrieve [detailed information](https://developers.google.com/android-publisher/api-ref/purchases/subscriptions) about that subscription using the [Google Play Developer API](https://developers.google.com/android-publisher/).

## Upgrade and Downgrade

You can let users [upgrade and downgrade](https://developer.android.com/google/play/billing/billing_subscriptions#Allow-upgrade) a subscription in your app using the [Google Play Billing Library](https://developer.android.com/google/play/billing/billing_library_overview). First, verify that the user has a current subscription with [queryPurchases()](https://developer.android.com/reference/com/android/billingclient/api/BillingClient#queryPurchases(java.lang.String)). Then call [setOldSku()](https://developer.android.com/reference/com/android/billingclient/api/BillingFlowParams.Builder.html#setOldSku(java.lang.String)) with the SKU for the subscription that will be replaced. Finally, call [setSku()](https://developer.android.com/reference/com/android/billingclient/api/BillingFlowParams.Builder.html#setOldSku(java.lang.String)) using the new subscription SKU. This will return a new purchase token representing the upgraded or downgraded subscription. Be sure to [handle linkedPurchaseToken](https://medium.com/androiddevelopers/implementing-linkedpurchasetoken-correctly-to-prevent-duplicate-subscriptions-82dfbf7167da) correctly.

## Grace Period

This video covers setting up a [grace period](https://developer.android.com/google/play/billing/billing_subscriptions#user-is-in-a-grace-period---subscription_in_grace_period) for a subscription, which can help you retain users by allowing them a short time to fix their payment information in case of a renewal failure.

In the Google Play Console, enable grace period and choose its length of time in each individual subscription’s settings. When you receive an RTDN notifying you that a user is in a grace period, verify the subscription status using the [Google Play Developer API](https://developers.google.com/android-publisher/). Then, provide the user with a notice in your app with a [deep-link](https://developer.android.com/google/play/billing/billing_subscriptions#deep-links-manage-subs) to the [subscriptions center](https://play.google.com/store/account/subscriptions) so they can easily fix their payment settings. Remember, a user should retain access to the subscription during the grace period.

## Account Hold

This video describes [account hold](https://developer.android.com/google/play/billing/billing_subscriptions#account-hold---subscription_on_hold), a way for users who have an issue with their payment method to easily restore access to an app’s content without having to re-subscribe. This can increase user retention.

Enable account hold for all of an app’s subscriptions by expanding the Subscription Settings menu in the Subscriptions tab of the In-App Products sections of the Google Play Console. On your back-end, when you receive an RTDN notifying you a user is in account hold, verify the subscription status using the [Google Play Developer API](https://developers.google.com/android-publisher/). You should then block access to the subscription and let the user know there is an issue with their payment method, providing a [deep-link](https://developer.android.com/google/play/billing/billing_subscriptions#deep-links-manage-subs) to the [subscriptions center](https://play.google.com/store/account/subscriptions) so they can easily fix their payment settings.

## Cancel and Restore

Allowing users to easily [restore](https://developer.android.com/google/play/billing/billing_subscriptions#restore) their subscriptions after cancellation helps regain and retain previously active users. After a user has cancelled a subscription, they retain access to your app’s content until the expiration of the subscription period. During this time they can easily restore their subscription in the [Google Play Subscriptions Center](https://play.google.com/store/account/subscriptions).

After receiving an RTDN notifying you that a user has cancelled a subscription, you may wish to show a polite reminder about the upcoming expiration date in your app and provide a [deep-link](https://developer.android.com/google/play/billing/billing_subscriptions#deep-links-manage-subs) to the subscriptions center to allow them to easily restore their subscription.

## Defer Billing

[Deferring a billing date](https://developer.android.com/google/play/billing/billing_subscriptions#Defer) is an easy way to provide temporary access without charge to subscribers as a promotion or if they experienced a service outage. Using the [Google Play Developer API](https://developers.google.com/android-publisher/api-ref/purchases/subscriptions/defer), you can advance a subscribed user’s billing date to offer them free access to your services for a specified period of time. The subscription renewal date will be adjusted to reflect the new billing date passed to the API.

## Ready? Go!

I hope these videos help you understand how to implement subscriptions in your app! Ready? Go!

## Resources

* [Subscriptions 101 YouTube playlist](https://www.youtube.com/playlist?list=PLWz5rJ2EKKc9J8ylTbNo1mnwciEyMbxZG)
* [Google Play Billing Library](https://developer.android.com/google/play/billing/billing_library_overview)
* [Subscriptions.purchase resource](https://developers.google.com/android-publisher/api-ref/purchases/subscriptions#resource) from the Google Play Developer API
* Implementing [linkedPurchaseToken](https://medium.com/androiddevelopers/implementing-linkedpurchasetoken-correctly-to-prevent-duplicate-subscriptions-82dfbf7167da)
* [Classy Taxi](https://github.com/googlesamples/android-play-billing/tree/master/ClassyTaxi), an end-to-end subscriptions sample app

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
