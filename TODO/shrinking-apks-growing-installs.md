> * 原文地址：[Shrinking APKs, growing installs: How your app’s APK size impacts install conversion rates](https://medium.com/googleplaydev/shrinking-apks-growing-installs-5d3fcba23ce2)
> * 原文作者：[Sam Tolomei](https://medium.com/@samueltolomei?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/shrinking-apks-growing-installs.md](https://github.com/xitu/gold-miner/blob/master/TODO/shrinking-apks-growing-installs.md)
> * 译者：
> * 校对者：

# Shrinking APKs, growing installs

## How your app’s APK size impacts install conversion rates

![](https://cdn-images-1.medium.com/max/800/0*f1gQ1k1n3_d4-x9t.)

Since the launch of Android Marketplace in March 2012, the precursor to Google Play, the **average app size has** **quintupled.** As the mobile app space has matured over time, developers have added new features to serve and attract users, which has benefited many. However, as an increasing number of features are added to apps — more SDKs, higher resolution images, and better graphics — the larger APK sizes become. In this article I discuss the significance of APK size and analyze results in UX studies conducted by Google over the past 2 years.

![](https://cdn-images-1.medium.com/max/800/0*nLLV6VxsHaagxgCk.)

Average downloaded APK size over time (Google internal data)

Understanding that APK sizes are growing, we analyzed the effect an APK size has on install conversion rate. We found that **smaller APK sizes correlate with higher install conversion rates,** with an even larger impact on conversion rates for users in emerging markets. As many developers are shifting their focus towards expansion into new markets, particularly emerging markets, it is important to be cognizant of your app’s size.

### **Does APK size impact install conversion rate?**

To see if APK size has a demonstrable impact on the choices your user makes, we analyzed **the** **percentage of users who successfully installed an app after visiting a Play store listing**.

![](https://cdn-images-1.medium.com/max/800/1*XxnZXaLarvTKJD-pnhVBUg.png)

You can see the size of an app on its store listing, after tapping “Read More”.

…and there seems to be something to it! Globally, we see a negative correlation between APK size and install conversion rate for apps with sizes below 100MB.**For every 6 MB increase to an APK’s size, we see a decrease in the install conversion rate of 1%.** In a world where marketing teams use A/B tests to optimize for fractions of improvements in install conversion rates, APK size has a big impact.

A significant amount of the decline in this conversion rate is not only due to people simply choosing not to install, but also the install not completing for a variety of reasons. We found that the download completion rate of an app with an APK size of around 10MB will be **~30% higher** than an app with an APK size of 100MB.

This may result from:

1.  People considering **how much data** the app needs to download (and the **cost** of that data).
2.  **How long it will take to download** on their cellular network or wifi (often people have the mindset of “_I need the app now!”_).
3.  **Internet connectivity issues** that arise during download sessions.

### **Do people’s preferences and conversion rates for APK sizes vary by geography?**

This is a great question, and they do. APK size has a real data cost for many, and many people in emerging markets lack consistent access to wifi.

**>50% of Indian and Indonesia Android smartphone users do not have any access to wifi**. So if a user wants to download an app, they likely will be paying data costs for every MB of the APK (Google internal data, 2017).

![](https://cdn-images-1.medium.com/max/800/0*TNaKtrVPw31uV3me.)

Indian wifi availability survey (Google internal Android user survey)

Similarly, **~70% of people in emerging markets consider the size of an app before downloading it** out of concerns for data cost and phone storage space.

![](https://cdn-images-1.medium.com/max/800/0*OH32EpFgpqb-tm2P.)

% of Indonesian users surveyed who consider the size of an app when installing (Google internal Android user survey)

![](https://cdn-images-1.medium.com/max/800/0*juzFS4rHk1SJqa5a.)

Of the Indonesian users who consider the size of an app when installing, the reasons they cite as to why (Google internal Android user survey)

We can see these market preferences play out in the data. For example, the average app APK downloaded in emerging markets, such as by people in the Middle East, Africa and South East Asia, are a **quarter of the size of apps downloaded by people in developed markets**, such as in the US and Western Europe.

![](https://cdn-images-1.medium.com/max/800/0*PgaK63Sz_T4s0Ezw.)

Median APK Size, weighted by install volume, by Market. Green = larger median APK, Red = smaller median APK (Google internal data)

Diving into the conversion rate data, there is a sizeable distinction between how people react to increasing APK sizes in emerging markets (like India and Brazil), versus those in developed markets (such as Japan, USA, and Germany).

![](https://cdn-images-1.medium.com/max/800/1*oa_4HPWrqANWG7WKwJl3OQ.png)

Install conversion rate increase per 10MB decrease in APK size by select market (Google internal data)

From the above graph, we can see a 10MB decrease in APK size has a larger impact in India and Brazil than Germany, USA and Japan. The removal of 10MB from an app’s APK size in emerging markets correlates **with an increase in install conversion rate by ~2.5%**.

Let’s put some real numbers to these conversion rate improvements: if your app gets 10,000 installs per month in India, at a conversion rate of 20%, a 10MB reduction could result in an extra ~1,140 installs per month.

Lastly, when comparing apps (which aren’t games) to games, we see similar correlations between install conversion rates and APK size. However, one thing to note for games with APK sizes greater than 500MB, is that we see that people become much less sensitive to small changes in APK size. For games in the range of 500MB-3,000MB, install conversion rate only increases by 1% for every 200MB decrease in APK size.

### **Given all this, should I reduce my APK size? If so, how?**

From the above data, it’s pretty clear APK size matters to people around the world.

“That’s great and all” you say, “but what can I actually do to reduce my APK size?” I’m glad you asked! There are several great primers available on how to reduce the size of your existing APK:

*   [**Reduce APK Size**](https://developer.android.com/topic/performance/reduce-apk-size.html)primer on the Android Developers website, which covers topics including removing unused resources and compressing image files.
*   [**Building for Billions guidelines**](https://developer.android.com/develop/quality-guidelines/building-for-billions.html), on the Android Developers website, which discusses APK downsizing along with other considerations for apps being used in emerging markets.
*   [**How to Optimize Your Android App for Emerging Markets**](https://medium.com/googleplaydev/how-to-optimize-your-android-app-for-emerging-markets-7124c4180fc), another Medium post by our team, which focuses on three apps case studies and how readying their apps for emerging markets helped their performance.

For other considerations for your app in emerging markets, check out Google Play’s [Building for Billions](https://developer.android.com/topic/billions/index.html) guidelines site.

I talked a lot about the benefit of reducing your APK size in emerging markets, but another use case is Android Instant Apps, which require a smaller APK size. Instant Apps allows Android users to run your apps without installation and are another way for users to discover your apps. Find more information on getting started with [Android Instant Apps](https://developer.android.com/topic/instant-apps/index.html). You can also learn more [best practices for managing download size](https://android-developers.googleblog.com/2017/08/android-instant-apps-best-practices-for.html).

* * *

### What do you think?

I hope you found these insights helpful. Do you have questions or thoughts about APK sizes, or stories of how you were able to reduce your app’s size? Continue the discussion in the comments below or tweet using the hashtag #AskPlayDev and we’ll reply from [@GooglePlayDev](http://twitter.com/googleplaydev), where we regularly share news and tips on how to be successful on Google Play.


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
