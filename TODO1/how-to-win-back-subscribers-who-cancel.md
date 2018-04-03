> * 原文地址：[How to win back subscribers who cancel: Learn how developers spot at-risk subscribers, and win them back if they leave](https://medium.com/googleplaydev/how-to-win-back-subscribers-who-cancel-9960731adeb)
> * 原文作者：[Laura Willis](https://medium.com/@laura.willis22?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-win-back-subscribers-who-cancel.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-win-back-subscribers-who-cancel.md)
> * 译者：
> * 校对者：

# How to win back subscribers who cancel

## Learn how developers spot at-risk subscribers, and win them back if they leave

![](https://cdn-images-1.medium.com/max/800/1*wLhnuD2dXjD5xdrYhqQ5ZQ.png)

In ‘[**How to hold on to your app’s subscribers**](https://medium.com/googleplaydev/how-to-hold-on-to-your-apps-subscribers-eebb5965e267)’, my colleague [Danielle Stein](https://medium.com/@daniellestein_60947) discussed how to keep people engaged so they don’t churn. But, as I’m sure far too many developers know, churn happens! So what can you do to win back subscribers if they do unsubscribe? I am sharing lessons learned from developers who are growing successful subscription businesses on Google Play.

### **Knowledge is power!**

The first piece of the puzzle is to monitor your subscribers so you are aware if they’re at risk of cancelling or do actually cancel. There are several ways to do this. [**Real-time developer notifications**](https://developer.android.com/google/play/billing/realtime_developer_notifications.html) allow you to receive notifications, such as “cancelled”, “on hold”, and “restarted”, as soon as a subscriber’s state changes. Additionally, you can check someone’s subscription status each time they open your app. Armed with this information, you can do something about it! You can reach out to subscribers urging them to fix their form of payment, or offer them a discount not to leave, or persuade them to come back by showcasing new content or app features.

> Using real-time developer notifications has allowed [Elevate](https://docs.google.com/document/d/15GL1p5Kck8GwYIkcvMpYxi9HvGqEiuN2QOmESDrFHOA/edit?ts=5a98636f#heading=h.zhm9jn6w7dxv) to send people who have cancelled their subscriptions an email reminding them what they’ll lose when their subscription ends and inviting them to resubscribe.

![](https://cdn-images-1.medium.com/max/800/0*6gFz6HN_mFNXCJWu.)

### Make sure you don’t lose subscribers by accident

You know what’s really frustrating? Losing subscribers unintentionally because their form of payment fails. This is known as **involuntary churn**. Google Play provides several highly effective tools which can help you prevent this from happening. Setting up a [**grace period**](https://developer.android.com/google/play/billing/billing_subscriptions.html#grace-period) helps with retention by allowing you to give people an extra 3 or 7 days to fix payment issues when their renewal declines. Developers on Google Play who use a grace period see a **57% higher recovery rate** from renewal declines. This can be done simply by flipping a switch in the [**Google Play Console**](https://play.google.com/apps/publish) without any coding involved. And if that hasn’t convinced you — 80% of the top developers on Google Play all have grace period turned on.

![](https://cdn-images-1.medium.com/max/800/0*eLdFcYo11r5ACRNB.)

In addition to grace period, you can add [**account hold**](https://developer.android.com/google/play/billing/billing_subscriptions.html#account-holds). With account hold, you put subscribers with payment failures in a suspended state and block access to content until they update their form of payment in hope that this motivates them to do so. While account hold does require some additional coding, unlike grace period, it doesn’t cost you any additional days of content to provide.

![](https://cdn-images-1.medium.com/max/800/1*OYTPoI-4oIjizpC_qTDB2Q.png)

Here are some insights from the **many** developers whose recovery rates have improved thanks to account hold.

![](https://cdn-images-1.medium.com/max/800/1*Z0tBEGEwoAxr6aTVOzuMhg.png)

> [Tinder,](https://play.google.com/store/apps/details?id=com.tinder&hl=en) the popular dating app, has seen a** 3X increase in recovery rate** since implementing account hold. “Account hold allows us to recover purchases that would have been lost normally. It’s a no-brainer and very easy to integrate,” said Yiqi Meng, Engineering Manager at Tinder.

![](https://cdn-images-1.medium.com/max/800/1*MTtL-UHf1v9hJiawrO8zVw.png)

> When [Keepsafe](https://play.google.com/store/apps/details?id=com.kii.safe&hl=en), the developer of Keepsafe Photo Vault, a photo locker for locking down private pictures and videos, integrated account hold, their r**enewal rate on Android increased by 25%**. Keepsafe users rely on their premium account for private access to their pictures and videos, as well enhanced security. So when users’ accounts are suspended due to faulty payments, they are more likely to fix the problem by updating their form of payment.

So which one should you use? We see the best results when developers enable **both** grace period and account hold for their subscriptions, but you can also use either grace period or account hold independently.

### **Make them an offer they can’t refuse**

Let’s say the dreaded happens and a subscriber wants to cancel or churns. Using various channels, such as **in-product messaging**, **notifications**, **email** and **SMS**, we’ve seen developers have success using different ways to convince people to change their minds. Google Play research shows that winback offers are most appealing when they address peoples’ specific reasons for cancelling without making assumptions. For example, don’t assume price is the only reason someone is canceling and automatically offer them a discount. The person might want to cancel because they think the content is stale, so it would be more effective to show them new content you’ve added.

*   **Give people the option to choose a different plan.** Sometimes a subscriber wants to cancel because their current plan isn’t meeting their needs. Perhaps it’s too expensive and there are features they’re not using. Or, perhaps they’ve forgotten that there is another tier that has features they feel their current plan lacks. Keep a subscriber from canceling by offering them the ability to [**upgrade or downgrade**](https://developer.android.com/google/play/billing/billing_reference.html#upgrade-getBuyIntentToReplaceSkus) to a different tier from within the app. For example, when a subscriber to the ‘Plus tier’ of iHeartRadio tries to listen offline, they are prompted to upgrade to the ‘All Access Plan’ from within the app. You can also create a “Manage Plans” button within your app to surface this capability.

![](https://cdn-images-1.medium.com/max/800/1*H0gP5CrTZjTMGUiKYvJ8aw.png)

*   **Use gifting, i.e. giving people free service for a set period of time, as a retention tactic to address outages or service issues**. [Ultimate Guitar](https://play.google.com/store/apps/details?id=com.ultimateguitar.tabs&hl=en) used real-time developer notifications to know when someone cancelled a subscription. They then contacted canceled subscribers and offered them free weeks of service to address a number of customer issues, such as app instability. Ultimate Guitar said these customers “felt that we care about their user experience and as a result became loyal customers.” You can use the [**Google Play Developer API**](https://developer.android.com/google/play/developer-api.html#subscriptions_api_overview) to defer billing for those using your app.
*   **Highlight content or features that people haven’t tried, or that they’ll lose if they cancel**. [Google Play research](https://g.co/play/subscriptioninsights2017) shows that access to content is the main reason people initially subscribe and keep subscribing, so use content as a retention tactic when trying to keep your customers. For apps that have a free tier, in-product messaging can be effective if someone is still using the free version of the app. For example, streaming music service [Anghami](https://play.google.com/store/apps/details?id=com.anghami&hl=en) re-emphasizes one of their key premium features, offline mode, by prompting churned subscribers in the app to re-subscribe in order to “bring your 38 downloads back”.

![](https://cdn-images-1.medium.com/max/800/1*lIeLgzpRAa4FuxqOkcAcGA.png)

And now, you can allow people to restore their subscription after they cancel but before their subscription expires with just one touch. Before their subscription expires, you can direct people to the [**subscription restore**](https://developer.android.com/google/play/billing/billing_subscriptions.html#restore) button. Our data shows that 18% of all voluntary churn happens on the first day that the user signs up and 30–40% of all voluntary churn happens in the first week. This presents an opportunity to win users back using restore since there is plenty of time for them to change their mind, re-engage, and restore their subscription without going through the entire sign-up process again.

*   **Offer subscribers a discount for re-subscribing by providing an** [**intro price**](https://support.google.com/googleplay/android-developer/answer/140504?hl=en#intro) **or** [**free trial**](https://developer.android.com/google/play/billing/billing_subscriptions.html#trials)**.** Many developers use intro pricing and free trials to help with acquisition, but it also can help you keep subscribers, especially if price is an issue. Dating app [Jaumo](https://play.google.com/store/apps/details?id=com.jaumo&hl=en) offers people a 30% discount three days after their premium subscription ends. They are able to **win back about 5% of subscribers** through the offer.

As with any type of offer, there is not just one way to do it, and testing is the best way to see what is most effective for your customers. Google Play research has shown that people value having options when viewing winback offers, like being able to choose re-activation dates, choosing from multiple plans, or choosing from different offers. Run A/B tests with different SKUs and measure the outcome to see what makes the most sense for your business. To do in-app A/B testing, you can either set this up yourself or use [Firebase remote config](https://firebase.google.com/docs/remote-config/abtest-config).

So there you have it! With these tips and tricks, you’ll never lose a single subscriber again, right? We all know it’s not that easy, and that retention is one of the main challenges that developers face with their subscription apps. You can download [**this PDF**](http://services.google.com/fh/files/misc/win_back_subscribers_googleplay.pdf) that summarizes what I’ve discussed above and share with others who may not want to read the entire post.

* * *

### **What do you think?**

Do you have other thoughts on winning back subscribers and preventing churn? What has worked best for you? Join the discussion in the comments below or tweet using the hashtag **#AskPlayDev** and we’ll reply from [@GooglePlayDev](http://twitter.com/googleplaydev), where we regularly share news and tips on how to be successful on Google Play.


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
