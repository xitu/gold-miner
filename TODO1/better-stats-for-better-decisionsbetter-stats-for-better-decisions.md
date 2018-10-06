> * 原文地址：[Better stats for better decisions](https://medium.com/googleplaydev/better-stats-for-better-decisions-3661717b4f2d)
> * 原文作者：[Google Play Apps & Games Team](https://medium.com/@googleplayteam?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/better-stats-for-better-decisionsbetter-stats-for-better-decisions.md](https://github.com/xitu/gold-miner/blob/master/TODO1/better-stats-for-better-decisions.md)
> * 译者：
> * 校对者：

# Better stats for better decisions

![](https://cdn-images-1.medium.com/max/2000/0*xQKF5835ivk1ZLVs)

## The latest Google Play Console and Firebase features to help you analyze your audience

_Authored by:_ [_Tom Grinsted_](https://medium.com/@tomgrinsted_1649) _(Product Manager for the Google Play Console) and_ [_Tamzin Taylor_](https://medium.com/@tamzint) _(Head of Apps & Games BD, Western Europe at Google Play)_

Every day Google Play generates over 3 billion events, such as store searches, listing page views, and app installs. Part of our job is turning all of these events — and all of the amazing data that comes with them — into metrics, insights, and the tools that you can use to make better decisions.

When you look at what you do in your business on a daily basis, you’ll find that you are making decisions, lots of decisions: about your business, your acquisitions, about your development, and about your product roadmaps. And, good decisions are founded on good insights and good data.

In this post, we are going to discuss some of the key tools you can use to drive discovery, acquisition, engagement, and monetization. We will also introduce the user lifecycle model that guides the development of benchmarks, insights, and tools to help with decision-making.

![](https://cdn-images-1.medium.com/max/1600/0*VRurbfuiI5T9EsYU)

### The user lifecycle

As with any great journey, you need a place to start: a framework to guide thinking about the benchmarks, insights, and tools you need, as developers, to grow your app and build your business. This framework is the user lifecycle.

![](https://cdn-images-1.medium.com/max/1600/0*BzrCmXezIGvetz2N)

The lifecycle starts with discovery and acquisition. This phase is about getting in front of people, showing them that you’ve got a really interesting app or game, and persuading them to install it.

After the install comes engagement and monetization. You now have people coming back to your product every day: opening it and (hopefully) loving it. They’re also buying your in-app products and subscriptions, so you are getting paid as well.

It would be great if this were the end of the story, if everybody you acquire continues to use your app. But unfortunately, it’s not. Some people are — for whatever reason — going to uninstall your app or game, and become a lost user.

That doesn’t have to be the end of the story. Increasingly, the user lifecycle continues by persuading people to come back, to give you a second or a third chance, by telling them about the wonderful new features your app has and convincing them that they’ll want to try it again.

And it’s within this framework that we and our colleagues at Google Play think about the challenges in front of us.

![](https://cdn-images-1.medium.com/max/1600/0*V39kFGek9nwQy46O)

### Tools for discovery and acquisition

Before we look at some of the tools to help with decision-making, there are three Google Play Store features which are worth mentioning: early access, pre-registration, and Google Play Instant.

With the **early access program** you don’t wait until your app is in production to start discovering users. When you put your app or game into an open release track in the Google Play Console, you make it available to one of the over 230 million people who have opted in to open testing, with 2.5 million more people signing up each week.

Then there is **pre-registration**. Using this feature you can put your app or game into the Play Store, but, instead of the install button, people find a Pre-Registration button. Once someone has opted in, you can tell them when your app or game goes into production.

> Ville Heijari, CMO at Rovio Entertainment Corporation, commented: “pre-registration was instrumental to get our fans excited about the upcoming game, and to notify them of the availability of the game at launch.”

The third feature is **Google Play Instant**. This is an extension of our Instant Apps, which provides people with a low friction way to experience your app by enabling people to try an app or game without installing it.

> Hothead Games implemented Google Play Instant, and director of marketing Oliver Birch has noted: “we’ve almost doubled the overall click-through rate on our Store listing. New user acquisitions are up 19%+. [As a result] we are planning to expand instant throughout our portfolio of games.”

However, you can only manage what you can measure, which is why, to support the launch of Google Play Instant and to help you understand the contribution it’s making to your bottom line, there are new stats in the Play Console.

You can now see the number of Instant App launches and conversions, the number of times someone who launched your Instant App goes on to download the full version. And, because the stats are in the Play Console, you can slice and dice this information with your other key metrics, such as installs and revenue. The latest addition to these stats is the ability to track which products — browsers, Search, and the Play Store — are driving most of your Instant App success.

![](https://cdn-images-1.medium.com/max/1600/0*Bk80wPWQh-4yY5rU)

Now, you probably care about acquiring valuable users. The buyer acquisition report has always done a good job showing you how you convert play store visitors into repeat buyers, and now it tells you about Average Revenue Per User (ARPU) at each of those stages.

![](https://cdn-images-1.medium.com/max/1600/0*yRFpGCBHKQlGJy_z)

With this change, you see exactly how much average revenue per user you’re getting from different marketing channels, including organic traffic. Whether you’re running a classic CPM model, cost-per-Install model, or you’re driving value further down the funnel, this information will help you evaluate your strategies and make better decisions.

And finally, for the discussion about discovery and acquisition, there are new benchmarks.

![](https://cdn-images-1.medium.com/max/1600/0*ezYvfaP8ns_N4Ag1)

Benchmarks are great, because they help you focus your investment on the items that will give you the best return. The retained installers benchmarks in the user acquisition funnel, which also include all your organic traffic, let you see exactly where the there are opportunities to improve and where your efforts have paid off.

> Brandon Ross of strategic partnerships at Intuit Inc. comments: “Organic Benchmarks have helped us gauge conversion performance vs. peers and helped us optimize our discovery and conversion.”

![](https://cdn-images-1.medium.com/max/1600/0*-hQDAzHzWMpsOWN7)

### Tools for engagement and monetization

Let’s broaden our horizons and talk about Firebase tools, in addition to those in the Google Play Console.

But first, don’t forget the Google Play Console **events timeline**.

![](https://cdn-images-1.medium.com/max/1600/0*bPh3Rcmatd1DIMp0)

This new report provides you with contextual information at the bottom of charts in the statistics page, Android vitals dashboard, subscription dashboard, and in other charts on the Play Console. The report shows your metrics in relation to events that affect your app, such as the rolling out of a new release. For example, you can see whether a change

in average rating correlates with the rollout of a new release, or a price change is increasing or decreasing ARPU.

When it comes to discovering how people are engaging with your app, the tools offered by Firebase now provide even more help. In particular, **Google Analytics for Firebase** is enabled just by linking the analytics SDK to your app and, of course, signing up for the service.

Out-of-the-box, Google Analytics for Firebase gives you meaningful metrics about engagement and retention. But, you can also instrument your code to track the activities that matter the most to your app or game.

![](https://cdn-images-1.medium.com/max/1600/0*wKhlf4ypBdPgQpWk)

Interpreting all the information you get back from Google Analytics for Firebase can sometimes be a challenge, however, this can now be made a lot easier by using **Firebase Predictions**.

Firebase Predictions uses analytics data combined with machine-learning and other tools to give you predictions about how people are going to behave in your app. By default, you get predictions about people’s spend and churn. Again, you can also instrument your app to get predictions about the features and behaviors that matter most to you.

Moving on to the monetization phase, there have been several enhancements to the information about subscriptions. The **subscription dashboard** which launched last year and is used on a regular basis by the majority of top-earning subscription businesses. This is why we’ve continued to enhance the dashboard, including improvements to the retention and cancellation reports.

Keep a look out for upcoming updates to the **subscription retention and cancellation reports**, which will make it easier to compare cohorts and evaluate key features, such as free trials and account hold. You will also be able to easily track more of the data that is important to you, such as renewals.

![](https://cdn-images-1.medium.com/max/1600/0*SKEE_M66uRfVJKbg)

With the new **cohort selector** you can select groups of users, selecting them by SKUs, date, and country. Use this feature to concentrate on a group of subscribers and analyze their performance. For example, you can pick an SKU with a free trial and compare it with an SKU with an introductory price to see which one earns you more revenue.

When it comes to reducing your subscription churn, updates to the **cancellation report** will help you get more information about why people unsubscribe.

![](https://cdn-images-1.medium.com/max/1600/0*WJzoyAnXXde_D6Ef)

When someone cancels a subscription, they are given the opportunity to complete a survey, so that they can explain why they’re canceling. And the results of these surveys are available on the subscription dashboard.

The dashboard now also reports on win-back features, such as **account hold** and **grace period**.

![](https://cdn-images-1.medium.com/max/1600/0*-rQoM5mDb6yXpKmm)

### Win-backs and re-installs

The Play Console provides reports about uninstalls, for example, daily uninstall metrics or the uninstall events. Also, on the retained installers acquisition report, you can find details such as how long people keep your app before uninstalling.

We have heard from many developers that they want more information, and we understand why. Later this year, you will see features such as the ability to analyze how many people are uninstalling your app and how many are installing your app again. So, stay tuned for more updates.

![](https://cdn-images-1.medium.com/max/1600/0*8iSi6BGBiDcP8t7N)

### App dashboard

All of this new information creates a challenge. As a developer, you’re already really busy. You’ve got loads of tools, both from Google and others, and many different places to visit to get all the information you need. What you need is an easy way to see what the Play Console has to offer and the information that’s important to you.

There is a solution: the **app dashboard** in the Google Play Console.

![](https://cdn-images-1.medium.com/max/1600/0*yd-BCQ5XxJKRmBlh)

The app dashboard is the landing page you arrive at after selecting an app in the Google Play Console. It starts by providing trending information: such as installs, revenue, ratings, and crashes. In the sections that follow you’ll find groups of complementary data, such as installs and uninstalls, and revenue and RPU.

The dashboard is customizable; every section can be expanded or collapsed. So, if you’re interested in your revenue you can have that section open, but less interested in preregistration you can collapse that section. The dashboard then remembers your preferences and stays exactly as you leave it.

### Final word

User lifecycle has become an important way in which new features and updates to the Google Play Console are driven. As a result, these changes are designed to help you optimize every stage, from Google Play Instant and pre-registration for discovery and acquisition through to new subscription reports, enhanced acquisition reports, the new events timeline, and the uninstall stats. This information — and other details, such as your technical performance — are wrapped together in the app dashboard.

All of these tools will help drive your success, by better understanding your audience. If you want to learn more [check out more acquisition best practices](https://developer.android.com/distribute/best-practices/grow/user-aquisition), or hear more from us about the launches in our session from I/O 2018 below.

* YouTube 视频链接：https://youtu.be/oib_gHJA_-0?list=PLWz5rJ2EKKc9Gq6FEnSXClhYkWAStbwlC

### What do you think?

Do you have thoughts on analyzing your app acquisition and engagement data? Let us know in the comments below or tweet using **#AskPlayDev** and we’ll reply from [@GooglePlayDev](http://twitter.com/googleplaydev), where we regularly share news and tips on how to be successful on Google Play.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
