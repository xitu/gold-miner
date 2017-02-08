> * 原文地址：[React Native at Instagram](https://engineering.instagram.com/react-native-at-instagram-dd828a9a90c7#.qkzn45yv0)
* 原文作者：[Instagram Engineering
](https://engineering.instagram.com/@InstagramEng?source=post_header_lockup)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：


# React Native at Instagram #

React Native has come a long way since it was open-sourced in 2015. Fewer than two years later, it’s being used not only in Facebook and Facebook Ads Manager, but also in [many other companies, from Fortune 500 companies to hot new startups](https://facebook.github.io/react-native/showcase.html) . 
 
*Developer velocity is a defining value of Instagram’s mobile engineering*. In early 2016, we started exploring using React Native to allow product teams to **ship features faster** through *code sharing* and *higher iteration speeds, *using tools like [Live Reload and Hot Reloading](https://facebook.github.io/react-native/blog/2016/03/24/introducing-hot-reloading.html)  that eliminate compile-install cycles.

### Challenges ###

Integrating React Native into an existing native app can create challenges and additional work that you don’t encounter when you start an app from scratch. With this in mind, we decided to start exploring these challenges by porting the simplest view we could think of: the *Push Notifications* view. This view was originally implemented as a WebView, so we thought that it wouldn’t be too hard to beat its start up times. On top of that, this view didn’t require us to build much navigation infrastructure — the UI was quite simple and translations were determined by the server.

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/1600/1*nfLpyxC12oY9j9eBKBVmhA.png">

### Android Methods Count ###

The first problem that popped up was **adding React Native as a dependency without pulling in the entire library**. Doing so would not only increase the binary size, but would also have a large impact on methods count, making Instagram for Android go multi-dex with all the performance consequences this entails (yes, Instagram is still **single-dex!**). We ended up *selectively pulling in only the view managers we needed* at that time and writing our own implementations for the ones that depended on libraries we didn’t want to pull in. Ultimately, React Native ended up adding ~3500 methods. Features written in React Native barely require defining Java methods, so we believe this investment will be worthwhile in the long run.

### Metrics ###

As part of the Push Notification Settings experiment, we audited React Native’s impact on several metrics, including crashes and out of memories. We found these metrics to be neutral both on the initial experiment and when we looked into retaining the bridge instance when the user left a React Native feature (so the next time they enter one we didn’t have to re-create it).

### Start Up Performance ###

React Native has a start up overhead mostly caused by having to inject the JavaScript bundle into JavaScriptCore (the VM used by React Native both on iOS and Android) and instantiate native modules and view managers. Although the React Native team has come a long way in [improving performance](https://code.facebook.com/posts/895897210527114/dive-into-react-native-performance/) , for Instagram integration we wanted to measure this gap to figure if the tradeoffs would make sense for us. To do so, we ported the existing native *Edit Profile* view to React Native. Along the way, we built product infrastructure that started being used by product teams in parallel (e.g. navigation, translations, core components).

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/1600/1*m3LQkenqjW9XgY1rSZsXfg.png">

We ended up leveraging ideas and infra already built by the React Native team, namely *Random Access Module Bundling*, *Inline Requires*, *Native Parallel Fetching* and plenty more already integrated into the framework.

### Products ###

As mentioned on the previous section, the Core Client team ported the Push Notification Settings and the Edit Profile views to React Native. We also ported the *Photos Of* view to start looking into performance when powering lists with React Native:

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/1600/1*Z5v92B0R1s6JKzRxvWmZ1A.png">

In addition to these examples, several product teams have shipped features in React Native.

### Post Promote ###

Instagram has a lightweight interface for promoting posts called *Post Promote*. This product was originally implemented as a WebView because that technology allowed the team to iterate faster than with native code. The problem with WebViews is that the UX doesn’t feel native and start up is pretty slow. The promote team ported this feature to React Native and got fantastic improvements on startup times and user experience. It is worth mentioning that despite this being a very complex creation flow,it only added 6 methods to the Android DEX.

[![Markdown](http://p1.bpimg.com/1949/5f46ccb1c23ebc2b.png)](https://youtu.be/DvM4DGEd7lg)

### Save ###

Over 600M people come to Instagram every month and discover a wealth of new interest-based inspiration while connecting with their communities. However, they’re not always ready to act on this inspiration at the moment of discovery, and often want to revisit this content later when they’re ready. In response to this need, the Save team implemented support for [saving posts](http://blog.instagram.com/post/154465796577/161214-savedposts)  and revisiting them when they want to via a new, private tab on their profile that is only visible to them.
 
The Save team implemented the iOS version of the list of saved posts in React Native.

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/1600/1*091Mys29WC9lIAWds-TAWw.png">

### Checkpoints ###

Checkpoints are flows triggered from the server in response to suspicious actions (e.g: when we need to verify your phone number, when we think your account might have been compromised, etc).
 
Historically, checkpoints have been implemented using WebViews. As mentioned before, WebViews are good for code sharing and fast iteration speeds, but the UX doesn’t feel native and startup times can be slow. 
 
The Protect and Care team started working on revamping some of these flows. They decided to use React Native to leverage code sharing while keeping a great user experience and low startup times.

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/1600/1*n-_t4z09MG35Z6GSQVnU1g.png">

### Comment Moderation ###

We want Instagram to be a safe place where everybody can capture and share their most important moments. As the Instagram community grows and people from every corner of the world share more content we want to work diligently to maintain what has kept Instagram positive and safe, especially regarding the comments on your photos and videos. With this goal in mind, the Feed team launched a feature that allows users to moderate the comments they receive on their posts.

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/1600/1*XZpJHRB1tZotUO8ko_wI0w.png">

### Lead Gen Ads ###

Lead Gen Ads is a call to action surface that allows users to share information with advertisers. Advertisers can customize the forms on this surface.

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/1600/1*W_TAz1BrjzN-YUGL5vASNQ.png">

### Results ###

React Native allowed product teams to ship features faster to both our iOS and Android apps. The list below shows the percentage of code shared between the apps for some of the products, which could be used as a proxy to measure how we managed to improve developer velocity:

- Post Promote: 99%

- SMS Captcha Checkpoint: 97%

- Comment Moderation: 85%

- Lead Gen Ads: 87%

- Push Notification Settings: 92%

### Footnote ###

We recently moved our mobile infrastructure engineering teams (iOS and Android) to New York City. If this blog post got you excited about what we’re doing, we’re hiring — check out our [*careers page*](https://www.instagram.com/about/jobs/).

[*Martin Bigio*](https://twitter.com/martinbigio) , [*Don Yu*](http://github.com/donyu), [*Brian Rosenfeld*](https://www.instagram.com/brosenfeld/) and [*Grace Ku*](http://twitter.com/cakerug)  are Software Engineers on the Core Client team at Instagram New York.
