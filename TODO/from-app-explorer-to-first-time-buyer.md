> * 原文地址：[From app explorer to first-time buyer: A look at how rising star apps and games engage users through in-app purchases](https://medium.com/googleplaydev/from-app-explorer-to-first-time-buyer-6476be50893)
> * 原文作者：[Aviv Shalgi](https://medium.com/@avivshalgi?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/from-app-explorer-to-first-time-buyer.md](https://github.com/xitu/gold-miner/blob/master/TODO/from-app-explorer-to-first-time-buyer.md)
> * 译者：
> * 校对者：

# From app explorer to first-time buyer

## A look at how rising star apps and games engage users through in-app purchases

![](https://cdn-images-1.medium.com/max/800/0*3ZlKEJyi-aiyjxnY.)

Every day we hear about successful, rising-star apps and games that have, apparently, come from nowhere. Ever wondered how do they do it? What is it that makes some so successful while others, which may look more interesting and appealing, don’t do as well?

As part of my MBA, I’ve had the privilege to spend the summer working with the Google Play Strategy & Business Operations team in Mountain View. I’m now back at The University of Chicago Booth School of Business for the second year of my MBA studies. Reflecting on my time with Google, I’d like to share some insights I’ve gained into what is going on with these rising-star apps.

While all developers, big and small, veterans and startups, are all looking for success, some are forgetting the basics: steps that, when missed, could limit the financial success of an app. Even some successful developers are accidentally overlooking these basics in some of their latest apps.

While success can rely on many business models, I am focusing specifically on **driving in-app purchases** — be they some form of in-app product or a subscription. It’s not just about revenue. Sometimes, if the user doesn’t makes a purchase, they may not experience everything an app or game has to offer. They many not stay as engaged, rate it as highly, share it with friends — you get the picture. So, getting back to basics: it should be as easy as possible for users to make purchases in your app if they want to do so.

This is no small challenge, in May 2016 [Appsflyer](https://www.appsflyer.com/pr/new-report-global-app-spending-habits-finds-asian-consumers-spend-40-apps-rest-world/) found that only 5.2% of users pay for in-app purchases on a mobile device. So, increasing your first-time buyer conversion rate (the percentage of non-paying users who become first-time buyers) could have a tremendous impact on your monetization.

### **Choose the right _style_ of products to sell**

For some apps it might be quite clear what you are selling — such as a news app selling premium content — however, it’s not always that simple, particularly for games. So, there is often a choice to be made between **selling limited resources or offering premium content**.

With **limited resources, you sell finite products**. This is the approach taken in [Candy Crush](https://play.google.com/store/apps/details?id=com.king.candycrushsaga&hl=en_GB&e=-EnableAppDetailsPageRedesign) where players buy lives, bombs, and other resources they use in the game. In contrast, with **premium content, you sell products that elevate the gameplay experience**. For example, special levels that can’t be accessed through the free-to-play game. Premium content can also include products that don’t directly affect the game, for example, clothing for a game character or furniture for game scenes or locations. This second approach is often used in role-playing games (RPG) and Invest-Express games (games where players invest in building something and then can buy or earn features to express their style or personality). For example, in games such as [Clash of Clans](https://play.google.com/store/apps/details?id=com.supercell.clashofclans) and [Farmville](https://play.google.com/store/apps/details?id=com.zynga.FarmVille2CountryEscape) users can buy bushes and statues to add to their villages and farms.

Matching the right product style to your users isn’t just for games, it can apply to any app selling in-app products. For example, an outdoor activities app might consider selling users a national park map and including trail guides for free, or offer users tokens to access several trail guides and providing the map for free. Correctly matching the product style with user expectation and app journeys will increase the likelihood of making a sale.

However, the choice is often not clear-cut. You can run in-app A/B tests and make sure you test the balance between initial resources or free content and paid products. To find the right balance I suggest looking at whether your resources are aligned with the strategy for conversion. That is, are you supplying the user with enough free or trial products to get them to understand and like your product, and reach the point of conversion? Or could you be supplying too little, causing users to churn before fully understanding the value proposition?

### **Show users the value of in-app purchases**

![](https://cdn-images-1.medium.com/max/800/0*wgYXS-dCLJ8P3QBg.)

Today, the majority of apps and games are free-to-download, and users are accustomed to getting content or features for free before paying for them. This means that **users need to understand the value** you’re providing them, before they’ll provide value back to you by making an in-app purchase.

A way to highlight value in your onboarding flow and the first-time user experience (FTUE) could be to use a tutorial or messaging. An onboarding tutorial or messaging tied to app events presents another opportunity to highlight the value of the items you’re trying to sell. A good tip is to **highlight and focus on the best value or most popular item**s.

Where possible don’t just tell the user about the value of an in-app purchase, **show them with a free trial**. For example, [Clash of Clans](https://play.google.com/store/apps/details?id=com.supercell.clashofclans&hl=en) gives users 5 gems — the game’s in-app currency — during the onboarding tutorial.

> [Hearthstone](https://play.google.com/store/apps/details?id=com.blizzard.wtcg.hearthstone&hl=en) takes an alternative approach by letting players make several in-app purchases for free. This walks users through the purchase flow and familiarizes them with the process of making future (paid) purchases.

If your app offers subscriptions, then a **free trial with access to premium content** could be the way to go, and these are easy to [set up from the Google Play Console](https://support.google.com/googleplay/android-developer/answer/140504#trial). This feature works equally well in apps and games!

### **Make the first (and every) purchase as easy as possible for the user**

![](https://cdn-images-1.medium.com/max/800/0*w1t1ucg51mMtRrAR.)

Hard tasks are most often those that remain undone. It may seem obvious, but make it is as easy as possible for your users to make a purchase:

*   **Think of the journey.** Guide users through their purchase journey. Imagine entering a brick-and-mortar store, you find the item you want to buy, but then start wandering around the store looking for the cashier. The checkouts are either positioned near the exit or signposted with ceiling signs so you can see from just about anywhere in the store. Is your in-app store as easy for people to find?
*   **Lead by example.** Make users’ lives easier by showing them exactly how to make a purchase by adding it to your onboarding tutorial.
*   **Timing is everything.** Look at the typical user journey and show users the purchase tutorial at moments you want them to make that first purchase, if it makes sense to.
*   **Make it visible.** Make it easy to see the checkout throughout the user journey. Showing new users how to make a purchase is critical to their future purchases, and remember to always have the cashier available to them for when they want to make a purchase!
*   **Do your research.** Even if you think you know how your users will behave in your app and where they will be most receptive to a purchasing tutorial, think again! Users rarely behave as you expect, so it’s always worth running [in-app A/B tests](https://developer.android.com/distribute/best-practices/develop/in-app-a-b-testing.html), to find what works best. [Memrise](https://play.google.com/store/apps/details?id=com.memrise.android.memrisecompanion&hl=en_GB&e=-EnableAppDetailsPageRedesign) tested the cadence of when they offered a free trial and [increased conversion rates by 50%](https://android-developers.googleblog.com/2016/11/learn-tips-from-memrise-to-increase-in-app-conversions-with-pricing-experiments.html) in one experiment.

However, easy can mean different things to different users. Your users will differ on many characteristics. Do not assume everyone is as tech savvy as you and your team, the average person might not understand it as easily as you do! When setting up your in-app store:

*   **Provide multiple entry points.** These might include a store icon, clicking on a resource bar, or a special promotion or limited-time offer icon hovering over the screen.
*   **Highlight the in-game (real currency) store.** You want users to know where they can buy if they want to.
*   **When a user has entered the purchase flow, keep it as short as possible.** Overall, the maxim should be: less is more, in this case: fewer clicks is always better.
*   **Offer new users a bargain-basement starting price**. Consider a game where new users see 5 in-app products priced at $4.99 and above (up to $99.99). A new user might not be interested in paying $4.99 upfront; they might prefer to buy a simple starter pack between $0.99 and $2.99 to check out the game’s value, before committing to more expensive purchases. This is especially true when the price-jumps between products aren’t in the $1 to $2 range, as in $4.99, $9.99, $19.99, $49.99, and $99.99, as is some cases.

To determine the best pricing strategy, use **in-app A/B testing for different price points** against similar value packages with your users. Sometimes willingness to pay varies among user segments; such as countries, in-app behavior, in-app stages or levels, and so on. Tailoring your offering to different segments could be invaluable. Using a single ‘compromise’ price point to cover everyone could scare some users away.

Also, **consider the mix and value of the items** in each product, particularly for starter packs. For example, if your game offers several in-app products, a starter pack with a wide range of products but fewer units of each, may appeal more than a pack with fewer more popular products with more items per product. Again, run in-app A/B tests across your user segments, and remember you probably cannot segment your users too much, so go as far as you can while keeping tests practical and timely.

### **Offer users a variety of purchasing options, but not too many**

![](https://cdn-images-1.medium.com/max/800/0*4hxwUegaXYDcaiyG.)

People like options. Our human nature wants the ability to control our outcome, but too many options can hinder decision, leaving users stuck in an analysis-paralysis limbo. It’s important, therefore, to give new users — indeed all users — a relevant and controlled (but not too limited) set of purchase options.

There are two approaches you can use here: **bucketing and bundling**.

When the user enters the in-app store they are offered 3 to 6 of the “best value” and “most sold” items in their segment (that is, for users in a similar position in the game, with similar in-game behavior). With **bucketing**, you then give the user the **option to view more similar offers**. For example, if there is an offer on screen for 20 gems, a button could let the user see all gem offers. The key here is not to overwhelm the user with 20, 40, or more products on the same screen.

Another option for controlling the number of products is **bundling: combining** **different app or game features in one product**. For example, in a game where the user can purchase a range of resources — for example wood, gold, gems, food, and so on — products can bundle varying quantities of each resource. This not only allows you to offer a large array of goods through a small number of products, but you can also use imaginative product naming as an added enticement to the player: The Lord’s Loot, The Peasant Pleaser, and, well, the possibilities are endless.

While I’d always advocate keeping control on the product range you offer to users, remember that you will sometimes want to add products that provide a comparison incentive. For example, you might include an apparently poor value offer — 10 gems for $5 — to incentivize the purchase of your target products — 5 gems for $1\. Just remember to personalize the offerings based on the user’s progress through the app or game.

And again, run in-app A/B tests to explore what is the right number, price, and range of products to display to users.

### **When you go global, remember to price local**

![](https://cdn-images-1.medium.com/max/800/0*gr0yYnS22LoryNOH.)

It shouldn’t come as much of a surprise to learn that what looks like a cheap in-app purchase to a player in the US can be a relatively expensive purchase to someone in Vietnam. A simple step to **localizing prices** is to let the Play Store calculate local prices based on the current exchange rate. The console will even apply locally relevant pricing patterns, so your US$2.49 product ends up displaying at 1.99€ (not a slightly odd direct conversion value of, say, 2.07€).

[Papumba](https://play.google.com/store/apps/dev?id=6367889262833462420&hl=en) is one developer that has seen the value of local pricing. This Argentinian developer creates educational games for kids and families. After localizing app pricing, they’ve seen a [20% increase in revenue](https://www.youtube.com/watch?v=9M9mAhYAspU&list=PLWz5rJ2EKKc9ofd2f-_-xmUi07wIGZa1c&index=19), showing how this approach can significantly improve the appeal of in-app purchases in local markets.

However, exchange rates don’t fully allow for real local purchasing power. Other measures, such as the [Big Mac Index](http://www.economist.com/content/big-mac-index) can help determine more representative local pricing. Google Play’s [sub-dollar pricing](https://support.google.com/googleplay/android-developer/table/3541286) helps to address this in over 17 countries around the world.

Vietnamese games developer [DIVMOB](https://play.google.com/store/apps/dev?id=8029000350509758753&hl=en) found that by [introducing local sub-dollar pricing](https://www.youtube.com/watch?v=bXxKZjQC5zc&index=30&list=PLWz5rJ2EKKc9ofd2f-_-xmUi07wIGZa1c) they increased transaction volumes by 300%.

To add to the potential challenge of setting suitable local pricing, you may also need to **consider the local interest** in an app or game genre. Once again, using carefully designed in-app A/B tests can be just as valuable, if not more so, than studying exchange rates and standard of living indexes.

### **Lastly, don’t overlook loyal non-paying users**

![](https://cdn-images-1.medium.com/max/800/0*OPH34IYNPojiMU6O.)

While many of the tactics discussed assume you’re addressing new users who hadn’t used the app much, it’s also critical to make sure you are relevant to high retention users who aren’t paying. These are people who are highly engaged, have used the app or game for some time, and haven’t churned. This is the audience you want using your app.

Make sure you include starter packs, bundles, and pricing for these high tenured users throughout their journey. Maybe they haven’t seen anything they would like to pay for yet, but that doesn’t mean they’ve ruled it out. It may require some careful in-app A/B testing of offers to find what it is they’re looking for. However, once you have figured out what they want, this audience is potentially very valuable, after all, you already know they will probably be sticking around.

Here, I’ve covered insights into how to encourage users through the journey to purchase, from choosing the right style of products to sell, to showing their value, using the right pricing and purchase models, and importantly how to make purchasing easy for users. Although we mostly discussed first time buyer tactics, we also considered your loyal customers and their value. Hopefully you will find these tips helpful in your quest to design and improve the optimum path to purchase in your app or game.

* * *

### What do you think?

Do you have questions or thoughts on tactics for encouraging first-time buyers? Continue the discussion in the comments below or tweet using the hashtag #AskPlayDev and we’ll reply from [@GooglePlayDev](http://twitter.com/googleplaydev), where we regularly share news and tips on how to be successful on Google Play.


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
