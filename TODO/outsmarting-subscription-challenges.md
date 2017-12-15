> * 原文地址：[Outsmarting subscription challenges: Solutions to 10 common challenges developers face with subscription businesses](https://medium.com/googleplaydev/outsmarting-subscription-challenges-711216b6292c)
> * 原文作者：[George Audi](https://medium.com/@georgeaudi?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/outsmarting-subscription-challenges.md](https://github.com/xitu/gold-miner/blob/master/TODO/outsmarting-subscription-challenges.md)
> * 译者：
> * 校对者：

# Outsmarting subscription challenges

## Solutions to 10 common challenges developers face with subscription businesses

![](https://cdn-images-1.medium.com/max/800/0*VDQQKZ8jM8fvB6z7.)

Subscription businesses are complex and running them is not always easy. I’ve been focusing on this topic for a while and looking into common challenges faced by developers aiming to adopt or improve their subscription business model. If you run a subscription business on Google Play, you should (hopefully) already be familiar with our offering, so I won’t bore you with the basics here. Instead, I will share insights on how you can take your subscription business to the next level and try to help you “outsmart subscriptions challenges”.

In this article, I propose solutions to 10 common challenges facing developers with subscription business models. **Subscription challenges** can be structured into three areas which come together to impact your subscription revenue: 1) acquisition and conversion, 2) retention and recovery, and 3) pricing.

### **ACQUISITION & CONVERSION**

#### **Challenge #1:** “I don’t know where my subscribers are coming from”

![](https://cdn-images-1.medium.com/max/800/0*jK7Jet9zQQNpoGy7.)

Which markets? Which channels? Which devices? Without this information, you are unable to optimize your value proposition for markets performing less well, double down on the highest converting marketing channels, or know which are the most lucrative devices to target.

Google Play recently launched several [**subscription specific reports**](https://android-developers.googleblog.com/search/label/subscriptions) in the Google Play Console to deep dive into such issues. The user acquisition reports provide insights on the following:

*   Which markets drive highest installs / subscriptions
*   Which acquisition channels are the most effective at driving subscriptions
*   Where your subscribers are along the funnel
*   How you’re performing against peers

#### **Challenge #2:** My users are not perceiving the value of the premium service”

![](https://cdn-images-1.medium.com/max/800/0*gwlqCkHQx58lw6lp.)

We have two solutions to help resolve this issue. The first is ensure you **promote your value proposition** at various touch points in the app.

Health and Fitness app [Freeletics](https://play.google.com/store/apps/developer?id=Freeletics&hl=en_GB&e=-EnableAppDetailsPageRedesign) re-designed their onboarding to emphasize the value proposition, “_getting really fit_”. They begin by asking users “what are your goals?” (e.g. build muscle, lose weight, define body) rather than listing out app features. This increased conversion rate by 10%.

Another solution is also quite a common technique–offer a **free trial** to encourage users to try before they buy. We found that [78% of subscribers start with a free experience](http://services.google.com/fh/files/misc/subscription_apps_on_google_play.pdf). Google Play also now enables you to offer 3-day free trials (rather than previously a minimum of 7 days)–a recurrent ask from businesses with high marginal costs.

#### **Challenge #3:** “Users attempt to subscribe but do not complete their purchases”

![](https://cdn-images-1.medium.com/max/800/0*p3edHCauwiAoDg7p.)

**Google Play Billing** lets you offer multiple payment options across 130+ countries with a trusted, reliable, and easy 2-step checkout process. In the image below, you can see the friction in the flows with no Play Billing (on the left) versus the two taps in the Play Billing flow (on the right). The more seamless the payment flow, the less risk of abandonment.

![](https://cdn-images-1.medium.com/max/800/0*MVbUsr1w4H9uZFAC.)

Beyond that, starting January 1st 2018, Google Play will be updating the transaction fee for subscribers who are retained for more than 12 paid months to 15%. The goal here is to recognize apps and games businesses that maintain long-standing subscribers and create great user experiences.

#### **Challenge #4:** “I have a lot of users in the free tier who are not willing to pay”

![](https://cdn-images-1.medium.com/max/800/0*Z4bR3O6wG45Epx1f.)

A solution to this would be using [**introductory pricing**](https://support.google.com/googleplay/android-developer/answer/140504?hl=en#intro) to offer periodic sales to your users. [Cookpad](https://play.google.com/store/apps/details?id=com.mufumbo.android.recipe.search&hl=en_GB&e=-EnableAppDetailsPageRedesign), a popular cooking app in Japan, ran a 50% discount during Ramadan and saw a +4.5X increase in daily subscriptions versus a comparable period.

![](https://cdn-images-1.medium.com/max/800/0*qq5kcYw0fOg8cdsB.)

### **RETENTION & RECOVERY**

#### **Challenge #5**: “I have trouble retaining my subscribers.”

![](https://cdn-images-1.medium.com/max/800/0*LuGZIoqgAlyQ33e5.)

In some shape or form we have heard this problem from most apps and games businesses we work with. Because improving retention rate is so crucial to the bottom line of a subscription business, I will highlight two solutions.

The first is to give your users something to nurture by **gamifying the experience**. Some best practices for successfully using this tactic:

1.  Measure your user’s engagement against your own engagement objectives.
2.  Surface this measure to the user in a way that allows them to show off milestones on their profile.
3.  Consider incorporating in-app rewards or real monetary savings for hitting engagement milestones.
4.  Disincentivize subscription cancellation by making valuable rewards available to subscribers only.

An example of a service which has incorporated many of these mechanics is language learning app [Duolingo](https://play.google.com/store/apps/details?id=com.duolingo&hl=en_GB&e=-EnableAppDetailsPageRedesign).

![](https://cdn-images-1.medium.com/max/800/0*-RGr53dMELlCf-D6.)

The second solution is more straightforward–**offer users longer period plans** and present them convincingly. An incentive for users to sign up to this would be to discount the multi-frequency plans compared to monthly plans. You could also present the equivalent monthly price to highlight the cost savings (makes the math easier and clearer to get onboard with!). Also, I would recommend funneling promotions and seasonal campaigns to those longer period plans (which have higher LTV).

Korean SVOD platform [WatchaPlay](https://play.google.com/store/apps/details?id=com.frograms.watcha&hl=en&e=-EnableAppDetailsPageRedesign) diversified from one option (monthly), to four options (1/3/6/12 months) and found that 40% of users chose a multi-month plan.

![](https://cdn-images-1.medium.com/max/800/0*3Sp8GzzykR1Fs1f2.)

#### **Challenge #6:** “My subscribers are churning and I don’t really know why.”

![](https://cdn-images-1.medium.com/max/800/0*UMMjwcYUuBfrOpmE.)

As [announced at I/O](https://android-developers.googleblog.com/2017/05/make-more-money-with-subscriptions-on.html?hl=mk), the new churn reports in the Play Console give you visibility into reasons for churn: voluntary (user initiated) or involuntary (payment decline). They also tell you if the user also deleted the app.

#### **Challenge #7**: “You don’t know WHEN your subscribers are churning.”

![](https://cdn-images-1.medium.com/max/800/0*ObCXKkYnAo1NvF2U.)

This is an even bigger challenge which many of you experience. [**Real-time developer notifications**](https://developer.android.com/google/play/billing/billing_subscriptions.html#realtime-notifications) is a new feature that informs you of any change in subscriber state in real time, such as cancellation or suspension, so you can act on the information immediately.

#### **Challenge #8**: “Subscribers stay on the service a couple of months, but then they leave.”

![](https://cdn-images-1.medium.com/max/800/0*FP9LQ38OgWkTpaOW.)

Now that you can be notified about this in real time, it presents the opportunity to reach out to churned users and try to win them back. You could do this through using promotions, or simply reminding them of the benefits of your subscription offering.

[Anghami](https://play.google.com/store/apps/details?id=com.anghami&hl=en_GB&e=-EnableAppDetailsPageRedesign), a music streaming service in the Middle East, re-emphasizes one of the key premium features, offline mode, by prompting churned users to re-subscribe to bring back their downloads. Brain training app [Lumosity](https://www.google.co.uk/search?q=Lumosity+google+play&oq=Lumosity+google+play&aqs=chrome..69i57j0l5.1628j0j1&sourceid=chrome&ie=UTF-8), sends churned users emails to notify them about new content they would be missing out on.

And to close the winback loop, Google Play now makes restoring a subscription much easier with the new [**subscription restore**](https://developer.android.com/google/play/billing/billing_subscriptions.html#restore) feature recently announced at Playtime. This provides a full subscriber win back solution:

1.  The subscriber cancels
2.  Google Play notifies you in real time
3.  You send a win back message to that user
4.  And, if successful, the user can restore their subscription with the click of a button

![](https://cdn-images-1.medium.com/max/800/0*seGMbZYMvuwJOjmk.)

Google Play is constantly investing in improved winback features, so stay on the lookout!

#### **Challenge #9:** “Every month a significant percentage of my users’ payments gets declined.”

![](https://cdn-images-1.medium.com/max/800/0*5TxC7Yszcfj9LFJL.)

The previous points covered the voluntary cancellation challenges, but I want to also address users who did not even want to cancel but whose payment got declined because their credit card expired, or their transaction didn’t go through for some reason.

Again we have two solutions, which can be used in combination, or separately. The first is to **enable a** [**grace period**](https://developer.android.com/google/play/billing/billing_subscriptions.html). By enabling a grace period in the Play Console, you grant users an extra 3 or 7 days to fix payment issues. At the aggregate level, we have found that those who activate grace periods see a 50% improvement in renewal decline recovery.

I would definitely recommend you to flip the switch on grace period — it’s literally a flip in the Play Console — and to experiment with the optimal period for your business.

However, some users might keep delaying updating their form of payment during the grace period so in order to give users additional motivation, you can switch on [account hold](https://developer.android.com/google/play/billing/billing_subscriptions.html#account-holds), which was announced at I/O and is now available to all developers. With account hold, you put subscribers in suspend state until they update their form of payment.

[Univision NOW](https://play.google.com/store/apps/details?id=com.univision.univisionnow&hl=en_GB&e=-EnableAppDetailsPageRedesign) displaces a pop-up in their app to users whose payment has declined, deep-linking into the form of payment update flow on the Play Store for a frictionless update. What’s great with this feature is that if the user fixes their form of payment for ANY payment on Google Play, all their suspended subscriptions will be re-instated.

![](https://cdn-images-1.medium.com/max/800/0*5vIqduvJtdzohpZb.)

Dating app [Tinder](https://play.google.com/store/apps/details?id=com.tinder&hl=en_GB) has been an early tester of account hold, and has seen a 3x increase in payment recovery since implementing the feature.

![](https://cdn-images-1.medium.com/max/800/0*TNavY97X9WlQwn9T.)

#### **Challenge #10**: “I wonder if I’m leaving money on the table…”

![](https://cdn-images-1.medium.com/max/800/0*_M3eu3-hGwOcgzg-.)

With all the new and exciting solutions to outsmart retention challenges, let’s not forget about pricing. I hear this problem frequently. Finding the right price for any product is a science in, and of, itself. So it’s no surprise that developers wonder if they are pricing correctly.

The first solution I recommend is to **test different price points** with the help of [Firebase Remote config](https://firebase.google.com/products/remote-config/):

1.  Set up two SKUs
2.  Surface them to different user groups
3.  Compare metrics to find out which performs better

Remember that the goal is to maximize retention, not just sign-up, so this experiment might take a couple months to get right. Also, make sure your cohort groups are big enough for statistical significance.

The second solution is to **offer multiple plans with a varying set of features**. Entertainment app [CBS](https://play.google.com/store/apps/details?id=com.cbs.app&hl=en_GB&e=-EnableAppDetailsPageRedesign) caters to different audiences’ willingness to pay by offering a Limited Commercials plan and a No Commercials plan. This means that price-sensitive users can choose the cheaper plan with ads, and time-sensitive users can choose the no ads plan. CBS then allows subscribers to seamlessly move between plans, by using the [**plan upgrades/downgrades**](https://developer.android.com/google/play/billing/billing_subscriptions.html) feature of Google Play billing — which is our 3rd solution for this pricing challenge.

I know that must be a lot to take in! If you’d like a handy digest, you can find a summary of these challenges and solutions in a [**one pager**](http://services.google.com/fh/files/misc/outsmarting_subs.pdf). Hopefully these tips to overcome common issues faced by developers, and examples from other developers who have managed to find success with subscriptions businesses, will encourage you to keep going and improve the success of your subscription service.

* * *

### What do you think?

Do you agree with the solutions I’ve outlined? Any other challenges you’ve come across? What else do you do to acquire and retain your subscribers? Continue the discussion in the comments below or tweet using the hashtag #AskPlayDev and we’ll reply from [@GooglePlayDev](http://twitter.com/googleplaydev), where we regularly share news and tips on how to be successful on Google Play.


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
