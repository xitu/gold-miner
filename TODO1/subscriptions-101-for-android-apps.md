> * 原文地址：[Subscriptions 101 for Android Apps](https://medium.com/androiddevelopers/subscriptions-101-for-android-apps-b7005a7e93a6)
> * 原文作者：[Emilie Roberts](https://medium.com/@emilieroberts)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/subscriptions-101-for-android-apps.md](https://github.com/xitu/gold-miner/blob/master/TODO1/subscriptions-101-for-android-apps.md)
> * 译者：[Fxymine4ever](https://github.com/Fxy4ever)

# Android 应用程序的订阅 101 系列视频

[订阅 Google Play 结算](https://developer.android.com/google/play/billing/billing_subscriptions)是拓展你业务极好的方法。然而，你的 Android 应用程序与后端服务器之间的协调问题可能会很棘手。

![](https://cdn-images-1.medium.com/max/7448/1*UvuzX1CDUzXPCOc60H9AVA.png)

[订阅 101 系列视频](https://www.youtube.com/playlist?list=PLWz5rJ2EKKc9J8ylTbNo1mnwciEyMbxZG)会帮助你明白如何将订阅里的所有部分组合在一起的，其包括搭建基础的服务器、[实时开发人员通知](https://developer.android.com/google/play/billing/realtime_developer_notifications)、[升级和降级](https://developer.android.com/google/play/billing/billing_subscriptions#Allow-upgrade)、[连接购买令牌](https://medium.com/androiddevelopers/implementing-linkedpurchasetoken-correctly-to-prevent-duplicate-subscriptions-82dfbf7167da)、[宽限期](https://developer.android.com/google/play/billing/billing_subscriptions#account-hold---subscription_on_hold)以及其它东西。

## 了解订阅

第一个视频概述了整个系列视频中使用到的术语以及你需要使用到的组件，它们包括：你的 Android 应用程序、你的后台服务器、[Google 应用内购买结算依赖库](https://developer.android.com/google/play/billing/billing_library_overview)、[Google Play 开发者 API](https://developers.google.com/android-publisher/) 和 [Google Cloud Pub/Sub](https://developer.android.com/google/play/billing/realtime_developer_notifications)。

## 订阅计费流程

这个视频讲述了订阅的计费流程。你可以使用 [Google 应用内购买结算依赖库](https://developer.android.com/google/play/billing/billing_library_overview)去[检查现有的订阅](https://developer.android.com/reference/com/android/billingclient/api/BillingClient#queryPurchases(java.lang.String))以及[启动注册的计费流程](https://developer.android.com/reference/com/android/billingclient/api/BillingClient#launchBillingFlow(android.app.Activity,%20com.android.billingclient.api.BillingFlowParams))。在成功购买后，你会得到[购买令牌](https://developer.android.com/google/play/billing/billing_overview#purchase-tokens-and-order-ids)以及[订单 ID](https://developer.android.com/google/play/billing/billing_overview#purchase-tokens-and-order-ids)，其分别代表着用户的权利和与 Google 的交易。你可以在后台服务器上跟踪该信息，以便正确授权你的产品或服务。

## 实时开发者通知

[实时开发者通知（Real-time Developer notification, RTDN）](https://developer.android.com/google/play/billing/realtime_developer_notifications) 允许你通过 [Google Cloud Pub/Sub](https://cloud.google.com/pubsub/docs/) 向服务器发送通知，了解到最新的订阅状态。

当你接收到了实时开发者通知后，请验证通知内的购买令牌以及使用 [Google Play 开发者 API](https://developers.google.com/android-publisher/) 来检索该订阅的[详细信息](https://developers.google.com/android-publisher/api-ref/purchases/subscriptions)。

## 升级与降级

你可以让用户在你的应用程序内使用 [Google 应用内购买结算依赖库](https://developer.android.com/google/play/billing/billing_library_overview)去升级或降级订阅。首先，调用 [queryPurchases()](https://developer.android.com/reference/com/android/billingclient/api/BillingClient#queryPurchases(java.lang.String)) 方法验证你的用户是否拥有当前订阅。然后，使用 SKU 调用 [setOldSku()](https://developer.android.com/reference/com/android/billingclient/api/BillingFlowParams.Builder.html#setOldSku(java.lang.String)) 方法来获取即将被替换的订阅。最后，使用新的订阅的 SKU 来调用 [setSku()](https://developer.android.com/reference/com/android/billingclient/api/BillingFlowParams.Builder.html#setOldSku(java.lang.String)) 方法。这将会返回代表着升级或降级的新的购买令牌。请确保正确地[处理连接购买令牌](https://medium.com/androiddevelopers/implementing-linkedpurchasetoken-correctly-to-prevent-duplicate-subscriptions-82dfbf7167da)。

## 宽限期

这个视频介绍了如何为订阅设置宽限期。这将允许订阅失败的用户在短时间内修复他们的付款信息，从而帮你留住用户。

在 Google Play 控制台中，启动宽限期，同时在每一个订阅的设置中选择其宽限期的时长。当在你接收到了 RTDN，它提醒你用户正处于宽限期的时候，使用 [Google Play 开发者 API](https://developers.google.com/android-publisher/) 验证订阅状态。然后，在你的应用程序中为用户提供通知，用户可以使用 [deep-link](https://developer.android.com/google/play/billing/billing_subscriptions#deep-links-manage-subs) 跳转到[订阅中心](https://play.google.com/store/account/subscriptions)，这使得用户能够轻松修复他们的付款设置。请记住，用户在宽限期间时应该保留其对订阅的访问权限。

## 账户保留

这个视频介绍了[账户保留](https://developer.android.com/google/play/billing/billing_subscriptions#account-hold---subscription_on_hold)，这对于其付款方式有问题的用户而言是一种方法。用户可以无需重新订阅，即可恢复他们对应用内容的访问权限。这可以提高用户保留率。

在 Google Play 控制台 —— 应用内产品部分 —— 订阅选项卡中，展开里面的订阅设置菜单，在所有应用的订阅里启动账户保留。在你的后端服务器中，当你收到 RTDN，它提醒你用户正处于账户保留状态时，请使用 [Google Play 开发者 API](https://developers.google.com/android-publisher/) 来验证订阅状态。然后，你应该阻止用户对订阅的访问，并让用户知道他们的付款方法有问题，然后提供一个 [deep-link](https://developer.android.com/google/play/billing/billing_subscriptions#deep-links-manage-subs) 跳转到[订阅中心](https://play.google.com/store/account/subscriptions)，以便他们可以很轻松地修复其支付设置。

## 取消与恢复

允许用户在取消订阅后能很轻松地[恢复](https://developer.android.com/google/play/billing/billing_subscriptions#restore)订阅，这可以帮助你重新获得并保留以前的活跃用户。在用户已经取消了订阅后，他们将保留对你应用程序内容的访问权限，直到订阅期限到期。在这期间，他们可以轻松地在 [Google Play 订阅中心](https://play.google.com/store/account/subscriptions)中恢复订阅。

当你收到的 RTDN，它提醒你用户取消了订阅。你可能希望在你的应用程序中礼貌地提醒用户关于即将到来的截止日期，并提供 [deep-link](https://developer.android.com/google/play/billing/billing_subscriptions#deep-links-manage-subs) 跳转到[订阅中心](https://play.google.com/store/account/subscriptions)，以便他们轻松恢复订阅。

## 推迟结算

[推迟结算日期](https://developer.android.com/google/play/billing/billing_subscriptions#Defer)是一个简单的方法，它可以免费向用户提供临时访问权限，作为促销或者如果他们遇到了服务中断。你可以使用 [Google Play 开发者 API](https://developers.google.com/android-publisher/api-ref/purchases/subscriptions/defer) 用来提前用户的计费日期，以便让他们在一个指定的时间段内免费访问你的服务。然后订阅续订的日期会被调整，用来反映的新的计费日期（这个日期用于传递给 API）。

## 准备好了吗？Go！

我希望这些视频会帮助你明白如何在你的应用程序里面使用订阅！准备好了吗？Go！

## 资源

* [订阅 101 YouTube 视频播放列表](https://www.youtube.com/playlist?list=PLWz5rJ2EKKc9J8ylTbNo1mnwciEyMbxZG)
* [Google 应用内购买结算依赖库](https://developer.android.com/google/play/billing/billing_library_overview)
* [订阅，购买资源](https://developers.google.com/android-publisher/api-ref/purchases/subscriptions#resource)，来自 Google Play 开发者 API
* 使用[连接购买令牌](https://medium.com/androiddevelopers/implementing-linkedpurchasetoken-correctly-to-prevent-duplicate-subscriptions-82dfbf7167da)
* [Classy Taxi](https://github.com/googlesamples/android-play-billing/tree/master/ClassyTaxi)，一个端对端订阅的 Demo 应用程序

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
