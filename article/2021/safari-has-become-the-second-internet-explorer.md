> * 原文地址：[Safari Has Become The Second Internet Explorer](https://medium.com/javascript-in-plain-english/safari-has-become-the-second-internet-explorer-e2c2dd114837)
> * 原文作者：[Golosay Volodymyr](https://medium.com/@golosay)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/safari-has-become-the-second-internet-explorer.md](https://github.com/xitu/gold-miner/blob/master/article/2021/safari-has-become-the-second-internet-explorer.md)
> * 译者：
> * 校对者：

# Safari Has Become The Second Internet Explorer

#### The more I work with it, the more it reminds me of IE

![Safari sometimes looks like IE](https://cdn-images-1.medium.com/max/2300/1*obluMaNgoWxwefRpP__Elg.png)

If you ask a developer what he feels when he hears IE (Internet Explorer), the most common answer is — pain. And I’m not an exception. I work as a web developer for more than ten years. During this time, I had many different projects where we had to support IE. I know this despondency when the browser doesn’t support some common for rest browsers functionality. Or when it displays elements in the wrong places. And the worst thing, when you need to debug unexpected behavior.

Fortunately, in regular life, I use MacBook Pro with M1. I like to use Apple’s software because it’s fast, energy-efficient, and beautiful. Safari is one of Apple’s applications. And I want to like it, but the more I work with it, the more it reminds me of IE. That’s why it’s important to highlight issues, which touch each of us. For some of them, I will provide solutions.

---

## Progressive Web Apps Support

PWA support, more precisely lack of support, is one of the most critical blockers nowadays. Do you know what is PWA? It’s a web app, which you can open in a browser and install locally. It will look like a common app installed from the app store, with the ability to launch it offline. In theory, you can do it even now (on iPhone), but Apple doesn’t allow you an entire list of limitations:

* You can not store more than 50 Mb
* No Bluetooth access
* Web Share for accessing native share dialog is not available
* No background sync and Web Push Notifications
* No Web App Banner to invite the user to install the app
* You can not customize the splash screen

These limitations make technology useless. Apple wants to control the market, and allow users to install “real” apps through the App Store only.

In Safari on Mac, you can not do it at all.

## Web Push Notifications

This topic was in the PWA limitation list, but deserves extra talk.

On Mac, web versions of some apps can not provide full functionality because they can not send push notifications.

![Push notifications browser support](https://cdn-images-1.medium.com/max/2396/1*ekXAvagYefIA-VZ_N_8qQg.png)

Messengers are the best example. In nowadays, telegram or FB messenger can notify users about a new message only when the site is opened, with the title switch and sound. If the user minimizes his browser with muted sound, obviously he misses the message.

Only one benefit of this limitation, there are no annoying proposals from news sites to subscribe for their notifications. But it doesn’t mean that we don’t need a notification feature.

## Scrolling behavior

Apple is so proud of Safari’s performance and energy efficiency. And this is not unreasonable!

To achieve such a good performance, they implemented a lot of optimizations. One of them is blocking DOM updates while the kinetic scroll is in progress. Maybe it’s not the only optimization, but after that, users started experiencing some scrolling lags. The most well-known issue — comments scrolling on the YouTube video page. There are discussions on the [official support forum](https://discussions.apple.com/thread/250853003) and MacRumors.

To solve this issue, you have to install the UserScripts extension and add some CSS styles.

```SCSS
// ==UserScript==
// @name        FixYouTubeScrolling
// @description Stop improper styling, Google
// @match       *://*youtube.*
// ==/UserScript==
ytd-page-manager {
  overflow-y: unset !important;
}

#page-manager.ytd-app {
  overflow-x: unset !important;
}
```

But this is not the only place, where this issue exists. I see some kind of scrolling issues on many different sites, like youtube music, Facebook, Reddit, and others, where on scroll event attached lots of functionality.

It’s a payment for fast scrolling, so I hope Apple would find a better balance.

## YouTube

As we started to talk about YouTube, probably, you saw an issue, when some thumbnails or avatars are not loading. You can find many different topics about this issue on apple discussions (e.g. [here](https://discussions.apple.com/thread/252092264) and [here](https://forums.macrumors.com/threads/youtube-website-scrolling-issue.2272026/)).

I don’t know the root of the issue, but a bug is in the cache. Clearing the cache solves the issue. But from time to time it can repeat.

There are two variants of how to clear the cache in Safari:

1. Press **Shift** on your keyboard while clicking the **Refresh button** in Safari.
2. Press **Command (⌘)** + **Option (**⌥**)** + **R** on your keyboard.

Choose whatever you want.

## Favicons

Have you seen the Instagram favicon in Safari on Mac? For some reason, it’s black & white.

![Black & White icon in the left corner](https://cdn-images-1.medium.com/max/5744/1*GgbMRIpIX_cuz6eCaLSoXA.png)

Minor, but strange issue. You can check by yourself, the real icon is colored. I have this issue on many sites, even on my [methodist.io](https://methodist.io). If you know why this issue happens and how to fix it, please share it in the comments.

## Extensions

Before 2018 Safari had its framework for building browser extensions. That’s why there are much fewer extensions in App Store. Only after 2018, they started to use WebExtensions Api like Chrome. It’s a huge step forward for extension developers because the core API is the same across main browsers. But the time is gone, and there is a big difference in the number of extensions comparing with other browsers.

## Media format standardization

You probably all know jpeg and png image formats. They are old (since 1992) and heavy, that’s why in 2017, tech giants decided to design more efficient media formats. Apple released HEIC (High-Efficiency Image Coding), and Google implemented WebP. But for some reason, they didn’t agree on which one is better. Chrome supports only WebP, and Safari respects only HEIC. Only in the middle of 2020, Apple added WebP support in Safari.

This story is about images, but the same is about videos. Google designed **WebM** format for videos, and even now (January 2021), **Safari doesn’t support it**.

In 2019 IT giants collaborated and started to work on the most modern and free video codec — **AV1**. Apple, Google, Netflix, and many more (the list is impressive) founded a company “Alliance for Open Media”. These companies shared their technologies and patents to create the codec of the future. The codec is ready. Netflix already uses it in their apps, but **Safari doesn’t support it also**.

![Alliance for Open Media](https://cdn-images-1.medium.com/max/2000/1*4Hu_Vd2eexqGCyRn16_AZg.jpeg)

As you can see, Safari is a pretty conservative browser, and Apple has its interests that don’t always align with users’ wishes.

## Conclusion

Safari is fast, energy-efficient, maybe even a safe browser. But the company which stays behind this browser has its own strategy. Of course, the main goal of this strategy is earning money. Giving users the ability to install apps avoiding App Store is not a profitable idea. Maybe the same explanation valid for using all popular media formats. But these issues block technology growth and add more headaches for developers.

**Thanks for reading!**

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
