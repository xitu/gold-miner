> * 原文地址：[How to grow your app business in Southeast Asia](https://medium.com/googleplaydev/building-a-successful-app-or-game-business-in-southeast-asia-29e6eea0defb)
> * 原文作者：[Guy Charusadhirakul](https://medium.com/@guycharusa?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/building-a-successful-app-or-game-business-in-southeast-asia.md](https://github.com/xitu/gold-miner/blob/master/TODO1/building-a-successful-app-or-game-business-in-southeast-asia.md)
> * 译者：
> * 校对者：

# How to grow your app business in Southeast Asia

## Four key strategies for localization and growing to new markets with Android (Go edition)

![](https://cdn-images-1.medium.com/max/1600/1*mNb91X17FSyOL7CKXh6E-A.png)

Southeast Asia is a large and diverse region spanning 10 countries, with a [population of over 630 million](https://aseanup.com/asean-infographics-population-market-economy/). With over [330 million internet users](https://www.thinkwithgoogle.com/intl/en-apac/trends-and-insights/e-conomy-sea-unlocking-200b-digital-opportunity/) — already more internet users than the US — the region is ripe for an explosive digital and mobile revolution. [Research by Google and Temasek](https://www.thinkwithgoogle.com/intl/en-apac/trends-and-insights/e-conomy-sea-unlocking-200b-digital-opportunity/) highlights that the Southeast Asia (SEA) digital economy will be worth over US$200 billion by 2025.

Unlike regions with more developed internet infrastructure, people in SEA rely on smartphones to access information, share content on social media, and consume entertainment. In fact, people in Southeast Asia [spend 3.6 hours on the mobile internet every day](https://www.blog.google/around-the-globe/google-asia/sea-internet-economy/), more time than anywhere else in the world.

With fast-growing disposable income and rapid growth in smartphone ownership, Southeast Asia represents an opportunity for app and game developers to expand their user base and business.

However, Southeast Asia presents unique challenges for global app and game developers. While countries in the region share many cultural and economic characteristics, they speak different languages and have unique consumer preferences. Many consumers in the region are still getting used to making purchases on their smartphones and, at the same time, becoming familiar with new payment methods.

Based on my experience, as a Southeast Asian native and from my work across the region, I have synthesized 4 key strategies for app and game developers to help grow their business in Southeast Asia.

![](https://cdn-images-1.medium.com/max/1600/0*SP1YjLo_uniUb49G)

### Strategy 1: Localize your content

Localization is key. I recommend translating app and game contents along with their Google Play store listing into the local languages. This is critical for markets such as Thailand, Indonesia, and Vietnam where English is not widely used. Developers that have translated have seen increased growth in app installs, users, and spending.

> _For example, based on comparing in-app spending in the 3 months before localization to the 3 months after, Legacy of Discord-FuriousWings by GTarcade reported that they saw 150% growth in spending when the game was localized into Thai and 40% growth from their Bahasa Indonesia version. Similarly, Supercell data shows 40% increase in spending after localizing_ [_Hay Day_](https://play.google.com/store/apps/details?id=com.supercell.hayday) _into Thai._

Where you’re unfamiliar with the new market, use [store listing experiments](https://developer.android.com/distribute/best-practices/grow/store-listing-experiments) to test versions of the store listing in the languages you’re targeting.

In addition to translating the content, you should consider localizing in-app or game content to fit the local cultural norms. Creating a cultural fit makes apps and games feel relevant to people.

> _For example,_ [_Smule_](https://play.google.com/store/apps/developer?id=Smule) _works with artists to offer relevant songs to listeners in Indonesia and Malaysia. Smule is consistently one of the top grossing apps on the Google Play Store in these countries._

![](https://cdn-images-1.medium.com/max/1600/0*2BmnPD79f2EoGRII)

### Strategy 2: Localize price and think about local payments

Consumers in Southeast Asia have lower disposable incomes relative to developed markets. GDP per capita for 2016 is estimated at [US$ 4,034](https://www.aseanstats.org/wp-content/uploads/2018/01/ASYB_2017-rev.pdf). Therefore, consider pricing in-app purchases or subscriptions to match consumers income.

> _Smule price their monthly subscription in Indonesia at IDR 12,000, which is $US0.83. This compares with US$4.99/month in the US. By setting the price of in-game currencies 30–40% lower than the North Asia version,_ [_Dragon Nest M_](https://play.google.com/store/apps/details?id=com.playfungame.ggplay.lzgsea)_, a popular action game in SEA, reported net positive revenue._

Google Play also provides for in-app purchases to be priced below $US0.99 for all markets in Southeast Asia, except Singapore.

In addition to localizing pricing items to local users’ ability to pay, direct carrier billing and gift cards are popular payment methods in the region. These are good alternatives, as credit card ownership is not widespread in Southeast Asia. Google Play has partnerships with 24 carriers in Southeast Asia to make it easy for consumers to make purchases in your apps.

![](https://cdn-images-1.medium.com/max/1600/0*cBlieEiL3XU7Gu3b)

### Strategy 3: Optimize your apps and games for those in emerging markets, such as SEA

Southeast Asian consumers use a wide variety of devices — from high-end smartphones to entry-level Android phones. To ensure the best user experience on entry-level devices, many developers optimize their apps by reducing APK size and optimizing memory use. This is in line with the result of [Google’s survey of Android user](https://medium.com/googleplaydev/shrinking-apks-growing-installs-5d3fcba23ce2): ~70% of people in emerging markets consider the size of an app before downloading it out of concerns for data cost and phone storage space.

> _The developer of_ [_Garena Free Fire_](https://play.google.com/store/apps/details?id=com.dts.freefireth) _optimized this game for emerging markets by reducing APK size through audio, image, and data compression. The developer also optimized memory use by using different texture resolution depending on the graphics quality. As a result, Free Fire has been one of the top-downloaded games in Southeast Asia._

You can further optimize your apps for [Android Oreo (Go Edition)](https://www.android.com/versions/oreo-8-0/go-edition/). Do this by reducing APK size, optimizing memory use, and reducing app start-up time. [Viki](https://play.google.com/store/apps/details?id=com.viki.android), [Shopback](https://play.google.com/store/apps/details?id=com.shopback.app), [Tokopedia](https://play.google.com/store/search?q=Tokopedia&c=apps&sticky_source_country=ID), and [Picmix](https://play.google.com/store/apps/details?id=com.picmix.mobile) are examples of apps popular in Southeast Asia which have been optimized for Android Oreo (Go edition) to better serve people in the region.

You should also pay attention to [Android vitals](https://developer.android.com/topic/performance/vitals/), which measures app health signals such as crash rate, app-not-responding, and battery draining wake locks. These are very relevant to users and devices in emerging markets, such as SEA. You can monitor Android vitals in the Google Play Console.

However, if your app or game needs a higher spec device to provide a good experience, take advantage of [device catalog](https://support.google.com/googleplay/android-developer/answer/7353455?hl=en). This Google Play Console feature enables you to filter devices to ensure that only consumers with suitable phones can install your app or game.

![](https://cdn-images-1.medium.com/max/1600/0*_D796bdhi6hvwiNy)

### Strategy 4: Build local communities and engage with local users

Southeast Asian users are highly social: online and offline. Successful developers have harnessed the power of community to acquire users, educate people about their apps and games, and keep users engaged and coming back. Here are some tips that can help build a strong community in Southeast Asia:

*   **Communicate with people in their language:** To build a strong community you need to communicate with people in their language. This means having native speakers responding to user reviews on the Play Store and providing communications through other channels too. When Netmarble launched their popular game [Lineage2 Revolution](https://play.google.com/store/apps/details?id=com.netmarble.revolutionthm) in Indonesia, they responded to user reviews on Google Play in Bahasa Indonesian — the local language. Lineage2 Revolution has consistently been among the top 3 grossing titles in Indonesia on Google Play since it’s launch.
*   **Build a local social media presence:** Successful developers use popular social media in local markets to regularly communicate relevant news and content to their community. These social channels are also popular ways for people to relay customer service issues to you. For example, [IGG.COM](https://play.google.com/store/apps/dev?id=8895734616362643252) estimates that more than 50% of their customer service issues in SEA come through social channels.
*   **Consider working with content creators:** YouTube is extremely popular in Southeast Asia. In fact, Thailand and Indonesia have the [highest proportion of people who watch YouTube on mobile](https://www.thinkwithgoogle.com/intl/en-apac/trends-and-insights/beyond-numbers-youtube-shapes-lives-thailand-indonesia/). As a result, many game developers work with creators to stream gameplay that helps educate and re-engage players.
*   **Don’t underestimate offline:** Offline events are an important element of building community in Southeast Asia. Developers such as [Com2uS](https://play.google.com/store/apps/dev?id=6850516909323484758) and [Siamgame](https://play.google.com/store/apps/dev?id=6476992165808510390) regularly hold offline events for their most avid fans, to foster a strong sense of community and increase re-engagement. eSport is becoming popular in SEA and it is even being included in this year’s Asian Games, hosted in Jakarta and Palembang, Indonesia. [Hero Games](https://play.google.com/store/apps/dev?id=9060101706093336387) and [Garena](https://play.google.com/store/apps/details?id=com.dts.freefireth) have credited eSport as being a major factor in driving engagement with the gamer community in Southeast Asia.

### Final word

The Southeast Asia market offers a tremendous opportunity to find new users and grow revenue as the economies in this dynamic region continue to grow. The key to success is to tailor your business to the market you are targeting — localize your content, set pricing to local incomes, optimize for Android Oreo (Go Edition), and build communities. If you want more guidance, check out the [Build for billions](https://developer.android.com/docs/quality-guidelines/building-for-billions/) page for Android developers.

* * *

### What do you think?

Do you have thoughts on building app and games businesses in SEA? Let us know in the comments below or tweet using **#AskPlayDev** and we’ll reply from [@GooglePlayDev](http://twitter.com/googleplaydev), where we regularly share news and tips on how to be successful on Google Play.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
