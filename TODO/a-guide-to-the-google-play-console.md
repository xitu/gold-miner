> * 原文地址：[A guide to the Google Play Console](https://medium.com/googleplaydev/a-guide-to-the-google-play-console-1bdc79ca956f)
> * 原文作者：[Dom Elliott](https://medium.com/@iamdom?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/a-guide-to-the-google-play-console.md](https://github.com/xitu/gold-miner/blob/master/TODO/a-guide-to-the-google-play-console.md)
> * 译者：
> * 校对者：

# A guide to the Google Play Console

## Whether you’re in a business or technical role, in a team of 1 or 100, the Play Console can help you with more than publishing

![](https://cdn-images-1.medium.com/max/800/1*VRf8qf0oY8dxrdAfBFE3fg.png)

Y ou may may have used the [Google Play Console](http://g.co/play/console) to upload an Android app or game, create a store listing, and hit publish to reach an audience on Google Play. But you may not realize that the Play Console has a lot more to offer, especially to those focused on improving the quality and business performance of their app.

Join me for a tour of the Play Console; I’ll introduce each feature and point you to some useful resources to make the most of them. Once you become familiar with the features, you can take advantage of user management controls to grant your teammates access to the right features or data that they need. Note: when I say ‘app’ in this post, I generally mean ‘app or game’.

Jump to a section:

*   [Find your way around](#8b10)
*   [Dashboard and statistics](#a5a0)
*   [Android vitals](#ed9a)
*   [Development tools](#add5)
*   [Release management](#4e06)
*   [Store presence](#c527)
*   [User acquisition](#111b)
*   [Financial reports](#fb37)
*   [User feedback](#d92a)
*   [Global Play Console sections](#4f14)
*   [Get the Play Console app](#a696)
*   [Stay up to date](#eb8c)
*   [Questions?](#3882)

* * *

### Find your way around

If you’ve been invited to help manage an app or you’ve already uploaded an app, when you access the Play Console you’ll see something like this:

![](https://cdn-images-1.medium.com/max/800/1*_aVpZRSbE9Fc8NVdulvk4w.png)

The signed-in view of the Play Console when you have an app or game.

In this post I’ll assume you have an app. If you’re getting started and publishing your first app, take a look at the [launch checklist](https://developer.android.com/distribute/best-practices/launch/launch-checklist.html). I’ll come back to the global menu options (games services, alerts, and settings) later.

Pick an app from the list and you are taken to its dashboard. On the left-hand side there is a navigation menu (☰) with quick access to all the Play Console’s tools, let’s look at each in turn.

* * *

### Dashboard and statistics

The first two items are dashboard and statistics. These related reports give you an overview of how your app is performing.

The **dashboard** provides a summary of installs and uninstalls, top installing countries, active installs, ratings volume and value, crashes, a summary of Android vitals, and a list of pre-launch reports. For each summary, click **view details** for more detailed information. You can switch the view between 7 days, 30 days, 1 year, and the app’s lifetime.

![](https://cdn-images-1.medium.com/max/800/1*giTv35N9RabYBOfzwQmejw.png)

An app’s dashboard.

Hopefully, the summary shows your app is succeeding with great install rates and few crashes. A quick glance at the dashboard is a simple way to see if anything isn’t going as expected, look out for: increasing uninstalls, increasing crashes, a sliding rating, and other poorly performing metrics. If all isn’t as you hoped, then you or your engineers can access more details to find the cause of different issues.

**Statistics** lets you build a view of the app data that matters to you. In addition to seeing data over any date range, you can plot two metrics simultaneously and compare them to a previous period. You can get a full breakdown of statistics by a chosen dimension (such as device, country, language, or app version) in a table below the graph. Some stats offer plots at hourly intervals, for more detailed insights. Events (such as app releases or sales) appear on the graph and in the events timeline below it, so you can see how they impacted your stats.

![](https://cdn-images-1.medium.com/max/800/1*Abi3DL27q_HXPXxO4gDDHQ.png)

Statistics.

As an example, you might be running a new app promotion in Brazil. You can configure the report to show installs by country, filter the country list down to Brazil (from the dimensions table), and then compare the data with that from an earlier campaign to get a clear picture of how your promotion is going.

> **More resources for the dashboard and statistics
> **- [Monitor your app’s stats, and review alerts for unexpected changes](https://developer.android.com/distribute/best-practices/launch/monitor-stats.html)

* * *

### Android vitals

> Big Fish Games [used Android vitals to reduce crashes by 21%](https://www.youtube.com/watch?v=qRXkEQOtQ98) in their hit time management game, [Cooking Craze](https://play.google.com/store/apps/details?id=com.bigfishgames.cookingcrazegooglef2p).

**Android vitals** is all about your app’s quality, as measured by its performance and stability. An internal Google study conducted last year looked at one-star reviews on the Play Store and found 50% mentioned app stability and bugs. By addressing these issues you’ll positively impact user satisfaction, resulting in more people leaving positive reviews and keeping your app installed. Android vitals provides information about three aspects of your app’s performance: stability, rendering (also known as jank), and battery life.

![](https://cdn-images-1.medium.com/max/800/1*yPQRAKol71_5xpShvtRUsQ.png)

Android vitals (each only appears if Play has enough data for your app).

The first two measures — **stuck wake locks** and **excessive wakeups** — indicate if the app is adversely affecting battery life. The reports show where the app has asked a device to remain on for long periods (an hour or more), or is frequently asking the device to wake up (more than 10 wakeups per hour since a device was fully charged).

Information on app stability takes the form of the **ANR (App Not Responding)** and **crash rate** reports. The summary, as all the summaries in this section do, provides breakdowns by app version, device, and Android version. From the summary, you can drill down into details designed to help developers identify the cause of these issues. Recent improvements to the dashboard provide significantly more detail on ANRs and crashes, making them easier to diagnose and fix. Engineers can get more details from the **ANRs & crashes** section and load **de-obfuscation files**, which help improve the readability of crash reports.

The next two measures — **slow rendering** and **frozen frames** — relate to what developers call _jank_, or an inconsistent frame rate within an app’s UI. When jank occurs, an app’s UI judders and stalls, leading to a poor user experience. These stats tell you about the number of users who have:

*   Had more than 15% of frames take over 16 milliseconds to render, or
*   Experienced at least one frame out of 1,000 with a render time of greater than 700 milliseconds.

**Behavior thresholds**

For each metric, you’ll see a **bad behavior threshold**. If one of your Android vitals exceeds the bad behavior threshold, you see a red error icon. This icon means your app’s score is higher than other apps for that metric (and, in this case, being higher is worse!). You should address this poor performance as soon as possible, because your audience is having bad user experience, andyour app will be performing worse on the Play Store. This is because Google Play’s search and ranking algorithms, as well as all promotional opportunities that include the Google Play Awards, take into account an app’s vitals. Exceeding bad behavior thresholds contributes to downranking.

> **More resources for Android vitals
> **- [Use Android vitals to improve your app’s performance and stability](https://developer.android.com/distribute/best-practices/develop/android-vitals.html)
> - [Learn how to debug and fix issues in the Android vitals documentation](https://developer.android.com/topic/performance/vitals/index.html)
> - [Quality over quantity: why quality matters](https://www.youtube.com/watch?v=hfpnldMBN38) (Playtime ‘17 session)
> - [10 secrets to optimize Android apps for stellar user retention](https://www.youtube.com/watch?v=ovPCRS_lEWU) (I/O ‘17 session)
> - [Engineer for high performance with tools from Android & Play](https://www.youtube.com/watch?v=ySxCrzsKSGI) (I/O ‘17 session)

* * *

### Development tools

I’ll pass over this section; it’s a few tools for technical users of the console. The **services and APIs** section lists the keys and IDs for various services and APIs, such as Firebase Cloud Messaging and Google Play games services. While **FCM statistics** shows you data associated with messages sent through Firebase Cloud Messaging. For more info [visit the help center](https://support.google.com/googleplay/android-developer/answer/2663268).

* * *

### Release management

> [Zalando](https://play.google.com/store/apps/details?id=de.zalando.mobilehttps://play.google.com/store/apps/details?id=de.zalando.mobile) focused on quality and used release management tools to [reduce crashes by 90% and increase user lifetime value by 15%](https://youtu.be/Aau8LWGdBFE) on a quarterly basis.

In the **release management** section, you control how your new or updated app gets to people’s devices. This includes testing your app before release, setting the right device targeting, and managing and monitoring updates in the testing and production tracks in real-time.

As an app release is taking place, the **release dashboard** gives you a holistic view of important statistics. You can also compare your current release with a past release. You might want to compare against a less satisfactory release, to make sure that similar trends aren’t repeating. Or, you can compare against your best release to see if you’ve improved further.

![](https://cdn-images-1.medium.com/max/800/1*HfxpJpQzXrPj77c6MATgkA.png)

Release dashboard.

You should use **staged rollouts** for your releases. You choose a percentage of your audience to receive the app update, then monitor the release dashboard. If things aren’t going well — for example, crashes are spiking, ratings are falling, or uninstalls are increasing — before too many users are affected, you can click **manage release** and suspend the rollout. Hopefully, an engineer then resolve the issue before resuming the rollout (if the issue didn’t need an app update) or starting a new release (if an update was needed). When everything is going well, you can continue to increase the percentage of your audience who receive the update, until you reach 100%.

> Google Play allows you to go through beta to your soft launch right through to global launch, constantly getting feedback from users. And this allows us to look at real data and to make the best possible game for our players.

> — [David Barretto, Co-Founder and CEO of Hutch Games](https://www.youtube.com/watch?v=jLOIwdKiSd0)

**App releases** is where app packages (your APKs) are uploaded and prepared for release. Apps can be released to different tracks: **alpha**, **beta**, and **production**. Use the alpha and beta tracks to run closed tests involving trusted users or open betas anyone can join. When preparing a release you can save it as a draft, which gives you the opportunity to iterate and carefully edit your app’s details until you’re ready to roll out your release.

> _[Instant Apps] makes it easy for a user to have a great app experience without the extra step of installing the app from the Play Store. We are already seeing great success with our instant app._

> - [Laurie Kahn, Principal Product Manager at Realtor.com](https://developer.android.com/stories/instant-apps/realtor-com.html)

The **Android Instant Apps** section is like app releases, except it’s for instant apps. If you’re not familiar with instant apps, they allow users to instantly access a part of your app’s functionality from a link, rather than having to spend time downloading your full app from the Play Store. Check out the [Android Instant Apps](https://developer.android.com/topic/instant-apps/index.html) documentation for more details.

The **artifact library** is a technical section. It’s a collection of all the files, such as APKs, you’ve uploaded for your releases. If there’s some reason you need to, you can look back and download certain, old APKs from here.

> On first use, [the device catalog] saved me from making a bad, uninformed decision. I was planning to exclude a device, but then I discovered it had good installs, a 4.6 rating, and significant 30d revenue. Having such data in the catalog is awesome!

> - Oliver Miao, Founder and CEO of [Pixelberry Studios](https://play.google.com/store/apps/developer?id=Pixelberry&hl=en)

The **device catalog** includes thousands of Android and Chrome OS devices certified by Google, offering the ability to search and view device specs. With the granular filtering controls available, you can exclude a narrow range of problem devices in order to offer the best experience on all devices your app supports. You can individually exclude devices and/or set rules by performance indicators such as RAM and System on Chip. The catalog also shows installs, ratings, and revenue contributed by each device type. A low average rating on a specific device, for example, could be the result of a device issue not caught in general testing. You could exclude a device like that and temporarily halt new installs until you’ve rolled out a fix.

![](https://cdn-images-1.medium.com/max/800/1*5bPHUQncjHlGsIPD2rnIBA.png)

Device catalog.

**App signing** is a service we introduced to help keep your app signing key secure. Every app on Google Play is signed by its developer, providing a traceable verification that the developer who claims to have written the app _did_ write the app. If the key used to sign an app is lost, it’s a major issue. You wouldn’t be able to update your app. Instead, you’d need to upload a new app, losing the app’s history of installs, ratings, and reviews and potentially causing user confusion when you try to get them to switch over. With app signing, after opting in you upload your app signing keys to store them securely in Google’s cloud. It’s the same technology we use at Google to store our app keys, backed by our industry-leading security infrastructure. The uploaded keys are then used to sign your apps when you submit updates. When you upload a brand new app, it’s easy to enroll in app signing during the first upload. We’ll generate an app signing key for you.

![](https://cdn-images-1.medium.com/max/800/1*6RcDJJp7WPjANQKcMjuYtQ.png)

App signing (a service provided by Google Play).

> Language learning app developer [Erudite](https://play.google.com/store/apps/dev?id=7358092740483658893&hl=en) attributed [use of the pre-launch report to increasing retention rate by 60%](https://www.youtube.com/watch?v=WMJR6CuPp4w&list=PLWz5rJ2EKKc9ofd2f-_-xmUi07wIGZa1c&index=17v).

The final option in this section is **pre-launch report**. When you upload an alpha or beta version of your app, we’ll run automated tests on popular devices with a range of specifications in the Firebase Test Lab for Android and share the results. These tests look for certain errors and issues relating to crashes, performance, and security vulnerabilities. Screenshots of your app running on different devices and in different languages are available to view. You can set up credentials so the tests can be performed behind a login, and test apps using Google Play licensing services.

![](https://cdn-images-1.medium.com/max/800/1*bc-LZ91iCVuIXTNjq5XlyQ.png)

Pre-launch report (automatically generated for alphas/betas).

Limited or incomplete testing can result in the launch of an app whose quality leads to low ratings and negative reviews, a situation that can be difficult to recover from. The pre-launch report is a good starting point for a thorough test strategy and can help you identify and fix common issues in your app. However, you’ll still need to run a suite of tests that comprehensively check your app. Building tests in the [**Firebase Test Lab for Android**](https://firebase.google.com/docs/test-lab/), which offers additional functionality over the pre-launch report, and taking advantage of the lab’s ability to run those tests automatically on multiple devices, can be more effective and efficient than manual testing.

> **More resources for release management
> **- [Meet user expectations by testing against the quality guidelines](https://developer.android.com/distribute/best-practices/develop/quality-guidelines.html)
> - [Use pre-launch and crash reports to improve your app](https://developer.android.com/distribute/best-practices/launch/pre-launch-crash-reports.htmlhttps://developer.android.com/distribute/best-practices/launch/pre-launch-crash-reports.html)
> - [Beta test your app with users to get invaluable early feedback](https://developer.android.com/distribute/best-practices/launch/beta-tests.html)
> - [Release updates progressively to ensure a positive reception](https://developer.android.com/distribute/best-practices/launch/progressive-updates.html)
> - [A new era of launching mobile games](https://medium.com/googleplaydev/a-new-era-of-launching-mobile-games-ef2453686f73) (Medium post)
> - [Derisk your game launch](https://www.youtube.com/watch?v=rV9Q6AMdt84) (Playtime ‘17 session)
> - [New release & device targeting tools](https://www.youtube.com/watch?v=peCWuCSIv7U) (I/O ‘17 session)
> - [Enroll in app signing to secure your app keys](https://www.youtube.com/watch?v=PuaYhnGmeEk) (DevByte video)

* * *

### Store presence

This section is where you manage your app’s presentation on Google Play, run experiments on your app’s listing content, set pricing and markets, get a content rating, manage in-app products, and get translations.

The **store listing** section is what you’d expect — it’s the place where you maintain your app’s metadata such as its title, descriptions, icon, feature graphic, feature video, screenshots, store categorization, contact details, and privacy policy.

![](https://cdn-images-1.medium.com/max/800/1*GGu4yJsG73asnwF8X_QFmQ.png)

Store listing.

A great store listing has an eye-catching icon; a feature graphic, video, and screenshots (from all device categories and in all orientations supported) that show what’s special about the app; and an attention-grabbing description. For games, upload a video and at least three landscape screenshots to ensure your game is eligible for video/screenshot clusters in the games section of the Play Store. Knowing what content will work best and drive the most installs can be a challenge. However, the next section of the console is designed to take the guesswork out of answering that question.

> After running store listing experiments with the app icon and screenshots, Japanese real estate app [LIFULL HOME’S](https://play.google.com/store/apps/details?id=jp.co.homes.android3) [saw installation rates increase by 188%](https://www.youtube.com/watch?v=PXW6zcm3-4c&index=7&list=PLWz5rJ2EKKc9ofd2f-_-xmUi07wIGZa1c).

**Store listing experiments** enable you to test many aspects of your store listing, such as its descriptions, app icon, feature graphic, screenshots, and promo video. You can run global experiments on images and videos and localized experiments on text. When you run an experiment, you specify up to three variants of the item you want to test and a percentage of the store visitors who will see the test variants. The experiment runs until it has been exercised by a statistically significant number of store visitors and then tells you how the variants compared. If you have a clear winner, you can choose to apply that variant to your store listing and display it to all visitors.

![](https://cdn-images-1.medium.com/max/800/1*xbwluyqq7-UQhO-Auce_hg.png)

Store listing experiments.

Effective experiments start with a clear objective. Test your app icon first because it’s the most visible part of your listing, followed by the other listing content. Test one content type per experiment to get more reliable results. Experiments should be run over at least seven days and, particularly where store traffic is low, on 50% of store visitors — but, if the test could be a little risky, keep the percentage low. Plan for iteration by taking the winning content from one experiment and testing against further variations on the theme. For example, if your first test finds a better character to include in a game’s icon, your next experiment could test the effect of variations in icon background color.

**Pricing & distribution** is where you set the price for your app and can restrict the countries to which its distributed. This is also where you indicate whether your app is optimized for specific device categories such as Android Wear and where you opt your app into programs such as Designed for Families. Each device category and program has requirements and best practices, I’ve added links to more information about each below.

![](https://cdn-images-1.medium.com/max/800/1*AV9a0VumHeQwlGUkqgiDOQ.png)

Pricing & distribution.

As you set your prices, you’ll notice a localization feature where the console automatically rounds prices to match the convention most appropriate for a particular country. For example, ending prices in .00 for Japan. At this point, you may also want to create a **pricing template**. With a pricing template, you create a set of prices by country that you then apply to multiple paid apps and in-app products. Any changes to the template are automatically applied to all the apps or products whose prices are set with the template. Find your pricing templates in the global settings menu of the console.

Having set the details for your app, the most likely reasons for returning to this section are to run a paid app sale, opt-in to a new program, or update the list of countries in which your app is distributed.

> **Learn more about distribution device categories and programs
> **- [Distribute to Android Wear](https://developer.android.com/distribute/best-practices/launch/distribute-wear.html)
> - [Distribute to Android TV](https://developer.android.com/distribute/best-practices/launch/distribute-tv.html)
> - [Distribute to Android Auto](https://developer.android.com/distribute/best-practices/launch/distribute-auto.html)
> - [Optimize for Chrome OS devices](https://developer.android.com/distribute/best-practices/engage/optimize-for-chromebook.html)
> - [Distribute to Daydream](https://developer.android.com/distribute/best-practices/develop/daydream-and-cardboard-vr.html)
> - [Distribute to enterprises and organizations using managed Google Play](https://developer.android.com/distribute/google-play/work.html)
> - [Distribute family or kid-focused apps and games](https://developer.android.com/distribute/google-play/families.html)

Next up is your app’s **content rating**. A rating is obtained by responding to a content rating questionnaire and, once complete, your app receives the appropriate rating badges from recognized authorities around the world. Apps without a content rating will be removed from the Play Store.

The **in-app products** section is where you maintain a catalog of the products and subscriptions sold from your app. Adding items here doesn’t add functionality to your app or game, the delivery or unlocking of each product or subscription needs to be coded into the app. The information here governs what the store does with these items, such as how much it charges users and when it renews subscriptions. So, for in-app products, you add their descriptions and prices while for subscriptions, in addition to descriptions and price details, you add a billing cycle, trial period, and non-payment grace period. Item prices can be set up individually or based on a pricing template. Where prices are set individually for countries, you may accept the price based on the prevailing exchange rate or set each price manually.

![](https://cdn-images-1.medium.com/max/800/1*EzneiTuF-mc_0U9JrWfpBw.png)

In-app products.

> Noom [grew international revenue by 80%](https://developer.android.com/stories/apps/noom-health.html) by localizing their app on Google Play.

The last option in this section is the **translation service**. The Play Console gives you access to reliable, vetted translators to translate your app into new languages. You’re much more likely to increase your store listing conversion rate and increase your installs in a particular country when your app is available in the local language. There are tools in the Play Console that can help identify suitable languages to translate into. For example, using the acquisition report you can identify the countries with many visits to your store listing but low installs. If your technical team is working on translating your app’s user interface via this service, you can get your text translated too. Do this by including store listing metadata, in-app product names, and universal app campaign text in the strings.xml file before it’s submitted for translation.

> **More resources for store presence
> **- [Make a compelling Google Play Store listing to drive more installs](https://developer.android.com/distribute/best-practices/launch/store-listing.html)
> - [Showcase your app with an attention grabbing feature graphic](https://developer.android.com/distribute/best-practices/launch/feature-graphic.html)
> - [Convert more visits to installs with store listing experiments](https://developer.android.com/distribute/best-practices/grow/store-listing-experiments.html)
> - [Go global and successfully grow valuable audiences in new countries](https://developer.android.com/distribute/best-practices/grow/go-global.html)

* * *

### User acquisition

> Peak Games [average cost per acquisition has been about 30–40% lower](https://www.youtube.com/watch?v=eNpDqYoHFZk) on Android than on other mobile platforms.

Every developer wants to reach an audience, and this section of the Play Console is about understanding and optimizing your user acquisition and retention.

In **acquisition reports,** you access up to three reports (the tabs at the top) depending on whether you sell in-app products or subscriptions:

*   **Retained Installers **— shows the number of visitors to your app’s store page, then how many of them installed your app and kept it installed over 30 days.
*   **Buyers **— shows the number of visitors to your app’s store page, then how many of them installed your app and went on to buy one or more in-app products or subscriptions.
*   **Subscribers **— shows the number of visitors to your app’s store page, then how many of them installed your app and went on to activate an in-app subscription.

Each report includes a graph that shows the number of unique users who visited your app’s store listing during the reporting period, followed by the number of installers, retained installers, and (on the buyers or subscribers report) buyers or subscribers. Some reports will be blank if we’ve determined there’s not enough data to show. Use the “measured by” dropdown to switch between data broken down by:

*   **Acquisition channel **— shows a table of data broken down by where visitors come from, such as the Play Store, Google Search, AdWords, etc.
*   **Country** — shows the total number of visitors for each country.
*   **Country (Play Store organic)** — filters the country totals to show you visitors coming to your store listing organically by searching and browsing on Google Play.

On all the reports, you can toggle the option to view installers who didn’t visit the store listing page, such as those installing directly from Google Search results or on play.google.com/store.

![](https://cdn-images-1.medium.com/max/800/1*2SKVVb8Osd4EE15tlkq9Bg.png)

Acquisition reports.

When reviewing the report by acquisition channel or country (Play Store organic), when there’s enough data you’ll be able to view **conversion rate benchmarks**. Based on your app’s category and monetization method, these benchmarks give you a comparison of your app’s performance with all similar apps in the Play Store. Benchmarks are a handy way of checking whether you’re doing a good job driving installs.

![](https://cdn-images-1.medium.com/max/800/1*Mkdd5i--pE8ha_iZu-8U_w.png)

Conversion rate benchmarks.

One way of increasing your installs is to run an advertising campaign, and you can get started quickly from **AdWords campaigns**. You can create and track a universal app campaign from this section. This type of campaign uses Google’s machine learning algorithms to find the best acquisition channel for your app and target cost per install (CPI). Provide text, images, and videos for the campaign and AdWords does the rest, placing ads on Google Play, Google Search, YouTube, in other apps via the AdMob network, and on mobile sites on the Google Display Network.

Once your universal app campaign is up and running, you’ll get additional data in the acquisitions reports. For detailed tracking, check out the reporting in your AdWords account.

Another option for driving installs and engagement is to run **promotions**. Here you create promotion codes and manage promotion campaigns, so that you can give away copies of your app or in-app products for free. You can use the promotion codes in your marketing on social media, for example, or in an email campaign.

The final feature in this section is **optimization tips**. These tips are generated automatically when we detect changes that can improve your app and its performance. Optimization tips may suggest languages to translate your app into based on where it’s popular, recognize the use of certain outdated Google APIs, identify when you might benefit from using Google Play games services, or detect when your app is not optimized for tablets, among other tips. Each tip includes instructions to help you with implementation.

> **More resources for user acquisition and retention
> **- [Understand where your valuable users come from and optimize your marketing](https://developer.android.com/distribute/best-practices/grow/user-aquisition.html)
> - [Increase downloads with universal app campaigns](https://developer.android.com/distribute/best-practices/grow/install-ads.html)
> - [Go global and successfully grow valuable audiences in new countries](https://developer.android.com/distribute/best-practices/grow/go-global.html)
> - [Taking the guesswork out of paid user acquisition](https://medium.com/googleplaydev/taking-the-guesswork-out-of-paid-user-acquisition-720d9d74882e) (Medium post)
> - [Shrinking APKs, growing installs](https://medium.com/googleplaydev/shrinking-apks-growing-installs-5d3fcba23ce2) (Medium post)
> - [How to optimize your Android app for emerging markets](https://medium.com/googleplaydev/how-to-optimize-your-android-app-for-emerging-markets-7124c4180fc) (Medium post)
> - [Making data on Google Play work for you](https://www.youtube.com/watch?v=Dr82cv6Lj0c) (I/O ‘17 session)

* * *

### Financial reports

> The analytics and testing capabilities offered by Play are unparalleled and equip developers like Hooked with key insights that help us grow, and are crucial in helping us understand and optimize our revenue.

> —Prerna Gupta, Founder & CEO, [HOOKED](https://play.google.com/store/apps/details?id=tv.telepathic.hooked)

If you sell your app, in-app products, or subscriptions, you’ll want to track and understand how your revenue is going. The **financial reports** section provides you with access to several dashboards and reports.

The section’s first report provides an **overview** of revenue and buyers. The report shows how your revenue and buyer performance has changed compared to the last report period.

![](https://cdn-images-1.medium.com/max/800/1*0gplcgqBGeRlPJ6wgQp-oQ.png)

Financial reports.

Separate reports offer a detailed breakdown of **revenue**, **buyers**, and **conversions** offering insight into users’ spending patterns. Each report lets you view data for specific periods such as the last day, 7 days, 30 days, or over the app’s lifetime. You can also drill down into device and country data on the revenue and buyers reports.

The conversions report helps you understand users’ spending patterns. The **conversion rate** table shows what percentage of your audience is purchasing items in your app and helps you see the impact of recent changes on conversion. The **spending per buyer** table gives you insight into how users’ spending habits change and the lifetime value of your paying users.

> **More resources for monetization
> **- [Sell in-app products with Google Play Billing](https://developer.android.com/distribute/best-practices/earn/in-app-purchases.html)
> - [Design your app to drive conversions](https://developer.android.com/distribute/best-practices/develop/design-to-drive-conversions.html)
> - [Improve conversions using Google Analytics for Firebase](https://developer.android.com/distribute/best-practices/earn/improve-conversions.html)
> - [From app explorer to first-time buyer](https://medium.com/googleplaydev/from-app-explorer-to-first-time-buyer-6476be50893) (Medium post)
> - [Predicting your app’s monetization future](https://medium.com/googleplaydev/predicting-your-apps-future-65b741999e0e) (Medium post)
> - [Five tips to improve your games-as-a-service monetization](https://medium.com/googleplaydev/five-tips-to-improve-your-games-as-a-service-monetization-1a99cccdf21) (Medium post)
> - [Driving conversions on Android apps](https://www.youtube.com/watch?v=P2z1CnNj6ag) (Playtime ‘17 session)
> - [Playing with games lifetime value](https://www.youtube.com/watch?v=mZIIMRbh8z8) (Playtime ‘17 session)
> - [Making money on Google Play](https://www.youtube.com/watch?v=LQ6MsPmUa38) (DevByte)
> - [Play Billing Library 1.0](https://www.youtube.com/watch?v=y78ugwN4Obg) (DevByte video)

> Subscription data that’s readily available for analysis is valuable. Being able to see how subscriptions perform over time is something many developers would find useful.

> —Kyle Grymonprez, Head of Cross-Platform and Android development at [Glu](https://play.google.com/store/apps/developer?id=Glu)

Finally, if you offer **subscriptions**, the dashboard gives you a comprehensive view of how subscriptions are performing to help you make better decisions about how to grow subscriptions, decrease cancellations, and increase revenue. The dashboard includes an overview, a detailed subscriptions acquisition report, a lifetime retention report, and a cancellation reports. You can use this information to identify opportunities to optimize your marketing and in-app messaging to drive new subscribers and reduce churn.

![](https://cdn-images-1.medium.com/max/800/1*AunDgPC8DHfFXLBzlN3PXg.png)

Subscriptions dashboard.

> **More resources for subscriptions
> **- [Sell subscriptions with Google Play Billing](https://developer.android.com/distribute/best-practices/earn/subscriptions.html)
> - [Building a subscriptions business for all seasons](https://medium.com/googleplaydev/building-a-subscriptions-business-for-all-seasons-7ffd95b3f929) (Medium post)
> - [How to hold on to your app’s subscribers](https://medium.com/googleplaydev/how-to-hold-on-to-your-apps-subscribers-eebb5965e267) (Medium post)
> - [Outsmarting subscription challenges](https://medium.com/googleplaydev/outsmarting-subscription-challenges-711216b6292c) (Medium post)
> - [Use behavioural economics to convey the value subscriptions](https://medium.com/googleplaydev/using-behavioural-economics-to-convey-the-value-of-paid-app-subscriptions-cd96ca171d5b) (Medium post)
> - [Make more money with subscriptions on Google Play](https://www.youtube.com/watch?v=hRZPXgRhOH0) (I/O ‘17 session)

* * *

### User feedback

> _The ratings and review section is a powerful tool to learn from your community. We are answering them in their native language with the help of Google Translate. As a result, we’ve seen a great improvement in user ratings. In fact, all of them are 4.4 stars or even higher on average._

> _—_ [_Andres Ballone, Chief Product Officer at Papumba_](https://www.youtube.com/watch?v=9M9mAhYAspU)

Ratings and user feedback via reviews are important. Play Store visitors consider your app’s ratings and reviews when they’re deciding whether to install it. Reviews also provide a way to engage with your audience and gather useful feedback about your app.

**Ratings** is where you get a summary of all ratings with breakdowns over time by country, language, app version, Android version, device, and carrier. You can drill down into this data to see how your app’s rating compares to the benchmark rating for its app category.

When it comes to analyzing this data, there are two key things to look for. The first is ratings over time, particularly whether ratings are going up or down. Decreasing ratings suggest you need to review recent updates. Perhaps updates have made the app harder to use or introduced issues that cause it to crash more often. The second use is to look for areas where ratings are out of line. Perhaps there is a low rating for a language — suggesting your translation isn’t up to scratch. Or ratings could be low on a specific device — suggesting your app isn’t optimized for that device. Where you have a generally good rating, finding and addressing poor rating ‘pockets’ can help you lift the ratings, particularly when app improvement opportunities are harder to find.

![](https://cdn-images-1.medium.com/max/800/0*Qv_i6KSksTlTz8sL.)

Ratings.

> _We use_ **_reviews analysis_** _to gather feedback from users on Google Play and use them to polish Erudite’s features. It also allows us to reply to users directly and individually, so we can improve the communication with our users and know their true requirements._

> _—_ [_Benji Chan, Product Manager at Erudite_](https://www.youtube.com/watch?v=WMJR6CuPp4w)

Users can provide ratings for your app without providing a review, but when they do include a review its content can provide insight into what is driving their rating. This is where the **reviews analysis** section comes into play. It provides three insights: updated ratings, benchmarks, and topic analysis.

![](https://cdn-images-1.medium.com/max/800/0*pijImEKdKgfJG-hF.)

Reviews analysis.

**Updated ratings** helps you understand how users who change their reviews also change the rating they provide. The data is broken down between reviews where you responded and those where you didn’t. You should find that the report shows that responding to poor reviews (for example, if you replied to let a user know an issue has been fixed) often results in users returning and revising their rating upward.

**Benchmarks** provides an analysis of ratings based on common review topics for an app category. So, for example, you can see how users are mentioning your app’s sign up experience and how reviews on that subject are contributing to your rating. Also, you can see how your rating and number of reviews compare to similar apps in the same category. If you want to explore further, clicking a topic takes you through to the reviews that made up this analysis.

**Topics** provides information about key words used in your app’s reviews and their effect on ratings. From each word, you can drill down to see the details of the reviews that it appears in, to get a more detailed understanding of what is going on. This feature provides analysis for reviews in English, Hindi, Italian, Japanese, Korean, and Spanish.

> _It makes it easy for us to search through the reviews, contact users when we need to get more information from them and, just in general, it has saved me a tremendous amount of time, anywhere between 5 and 10 hours a week._

> _— Olivia Schafer, Community Support Specialist at_ [_Aviary_](https://play.google.com/store/apps/dev?id=5644820617218674509)

In the **reviews** section itself, you get to see individual reviews. The default view shows the most recent reviews from all sources and in all languages. Use the filter option to refine the list. Notice the **all reply states** option. Filter the reviews to look at those you haven’t replied to, as well as the reviews where you replied and users have subsequently updated their review or rating. Replying to reviews is easy, in a review simply click **reply to this review**.

Occasionally you’ll come across reviews that break the [Comment Posting Policy](https://play.google.com/about/comment-posting-policy.html). When you do, you can report these reviews by clicking the flag in the review’s tile.

![](https://cdn-images-1.medium.com/max/800/0*9rElhiblAG0KXrJ5.)

Reviews.

> _Using beta feedback, with_ [_Early Access_](https://developer.android.com/distribute/google-play/startups.html#be-part-of-early-access)_, Spanish game developer_ [_Omnidrone_](https://play.google.com/store/apps/developer?id=Omnidrone&hl=en) _was able to_ [_improve retention by 41%, engagement by 50%, and monetization by 20%_](https://www.youtube.com/watch?v=LzGC6V_YnlE&index=10&list=PLWz5rJ2EKKc9ofd2f-_-xmUi07wIGZa1c)_._

There’s a section specifically for **beta feedback**. When you run an open beta test of your app, any feedback provided by testers ends up here — it doesn’t get included in your production app’s ratings and reviews and isn’t visible publicly. The features are like those for public feedback: you can filter reviews, reply to reviews, and see the history of conversations with users.

> **More resources for user feedback
> **- [Browse and reply to app reviews to positively engage with users](https://developer.android.com/distribute/best-practices/engage/user-reviews.html)
> - [Analyze user reviews to understand opinions about your app](https://developer.android.com/distribute/best-practices/grow/user-reviews.html)

* * *

### Global Play Console sections

So far, I’ve looked at the Play Console features that are available for each app. Before finishing, I want to give you a brief guide to the global Play Console features: games services, order management, download reports, alerts, and settings.

> [_Senri implemented Play games services_](https://developer.android.com/stories/games/leos-fortune.html) _saved games in Leo’s Fortune as well as one Leaderboard per chapter. Google Play games services users were 22% more likely to come back after 1 day and 17% more likely after 2 days._

**Google Play games services** offers a range of tools that provide game features to help drive player engagement, such as:

*   **Leaderboards** — a place for players to compare their scores with friends and compete with top players.
*   **Achievements** — set goals in your game that players earn experience points (XP) for completing.
*   **Saved Games** — store game data and synchronize it across devices so players can easily resume play.
*   **Multiplayer** — bring players together with real-time and turn-by-turn multiplayer gaming.

A number of these features can be updated and managed without changing the game’s code.

> _Eric Froemling used player analytics to_ [_grow average revenue per user by 140% and increase average revenue per paying user by 67%_](https://www.youtube.com/watch?v=3ks0IwqLNnI)_, for the game_ [_Bombsquad_](https://play.google.com/store/apps/details?id=net.froemling.bombsquad)_._

**Player analytics** puts valuable information about your game’s performance in one place, with a set of free reports to help you manage your game’s business and understand in-game player behavior. It comes as standard when you integrate Google Play games services to your game.

![](https://cdn-images-1.medium.com/max/800/0*ihSQz7lO1yVCO4y3.)

Player analytics (enabled as part of Google Play games services).

You can set a daily goal for player spending, then monitor performance in the **target vs. actual chart** and identify how your players’ spending compares to benchmarks from similar games in the **business drivers** report. You can track player retention by new user cohort using the **retention** report and see where players are spending their time, struggling, and churning with the **player progression** report. Then get help managing your in-game economy with the **sources and sinks** report and check, for example, that you’re not giving away a resource faster than players are using it.

You can also drill into details of player behavior. Use **funnels** to create a chart from any sequenced events, such as achievements, spend, and custom events or use the **cohorts** report to compare the cumulative event values, for any event, by new user cohorts. Get insights into what happens to your players during critical moments with the player **time series** explorer and create reports based on your custom Play Games’ events with the **events viewer**.

> **More resources for Google Play games services:
> **- [Use Google Play games services to create more engaging game experiences](https://developer.android.com/distribute/best-practices/engage/games-services.htmlhttps://developer.android.com/distribute/best-practices/engage/games-services.html)
> - [Use player analytics to understand better how players behave in your game](https://developer.android.com/distribute/best-practices/engage/player-analytics.html)
> - [Manage your games business with revenue targets through player analytics](https://developer.android.com/distribute/best-practices/earn/grow-game-revenue.html)
> - [Medium posts for game developers](https://medium.com/googleplaydev/tagged/game-development)

**Order management** provides access to details of all payments made by users. Members of your customer service team will use this section to find and refund payments or cancel subscriptions.

![](https://cdn-images-1.medium.com/max/800/1*Gab41EMLdSrFdY-fLwMkew.png)

Order management.

**Download reports** to obtain data including details for crashes & application not responding errors (ANRs), reviews, and financial reports. Also, aggregated data for installs, ratings, crashes, Firebase Cloud Messaging (FCM), and subscriptions is available. You can use these downloads to analyze the data captured by the Play Console using your tools.

**Alerts** surfaces issues related to crashes, installs, ratings, uninstalls, and security. For games using Google Play games services, there are alerts for game features that may be blocked because they aren’t being used correctly, for reaching limits or exceeding quota for API calls, and others. You can opt-in to receive alerts via email in the notifications section of the settings menu.

**Settings** provides various options to control your developer account and the behavior of the Play Console.

One settings feature under **developer account** that I want to highlight is **user accounts & rights**. You have complete control over who can access features and data for your app in the console. You can provide each of your team member’s with view or edit access to the whole account or just to specific sections. For example, you might choose to grant your marketing lead edit access to your store listing, reviews, and AdWords campaigns, but not to other sections of the console. Another common use of access rights is to make your financial reports visible _only_ to those that need to see them.

You should set up your **developer page** to showcase your apps or games and company’s brand on the store when people tap your developer name. You can add a header image, your logo, a brief description, your website URL, and pick a featured app (a full list of your apps is automatically visible).

In **preferences**, you can choose which Play Console notifications you receive via the web interface or email, [sign up for news](http://g.co/play/monthlynews) and elect to take part in feedback and surveys, tell us about your role, and change your preference to share your console use data with us.

* * *

### Get the Play Console app

The screenshots throughout this post show the Play Console in a web browser, however there’s a Play Console app available for your Android device too. Get quick access to your app’s statistics, ratings, reviews, and release information. Get notifications for important updates, like when your latest release is actually live on the store, and perform quick actions like replying to reviews.

[Get it on Google Play](https://play.google.com/store/apps/details?id=com.google.android.apps.playconsole&hl=en).

* * *

### Stay up to date

There are several ways to stay up-to-date with the latest and greatest from Google Play:

*   Tap the 🔔 in the top right hand corner of the Play Console to see notifications about new features and changes you should know about.
*   [Sign up to get news and tips by email](http://g.co/play/monthlynews) including our monthly newsletters.
*   [Follow us here on Medium](https://medium.com/googleplaydev) for longform posts from the team with best practices, business strategies, research, and industry thoughts.
*   [Connect with us on Twitter](https://twitter.com/googleplaydev) or [Linkedin](https://www.linkedin.com/showcase/googleplaydev/) and start up a conversation.
*   Get the [Playbook app for developers](https://play.google.com/store/apps/details?id=com.google.android.apps.secrets&hl=en) for curated posts (including all our blog and Medium posts) and YouTube videos to help you grow a successful business on Google Play, and choose what you get notified about.

* * *

**Questions or feedback about the Play Console? Get in touch!
**Comment below or tweet at us using the hashtag **#AskPlayDev** and we’ll reply from [@GooglePlayDev](http://twitter.com/googleplaydev), where we regularly share news and tips on how to be successful on Google Play.


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
