> * 原文地址：[Providing a safe and secure experience for our users](https://android-developers.googleblog.com/2018/10/providing-safe-and-secure-experience.html)
> * 原文作者：[]()
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/providing-safe-and-secure-experience.md](https://github.com/xitu/gold-miner/blob/master/TODO1/providing-safe-and-secure-experience.md)
> * 译者：
> * 校对者：

# Providing a safe and secure experience for our users

_Posted by Paul Bankhead, Director, Product Management, Google Play_

We focus relentlessly on security and privacy on the Google Play Store to ensure Android users have a positive experience discovering and installing apps and games they love. We regularly update our [Google Play Developer policies](https://play.google.com/about/developer-content-policy/) and today have introduced stronger controls and [new policies](https://play.google.com/about/updates-resources/) to keep user data safe. Here are a few updates:

## Upgrading for security and performance

As previously [announced](https://android-developers.googleblog.com/2017/12/improving-app-security-and-performance.html), as of November 1, 2018, Google Play will [require](https://developer.android.com/distribute/best-practices/develop/target-sdk) updates to existing apps to target API level 26 (Android 8.0) or higher (this is already required for all new apps). Our goal is to ensure all apps on Google Play are built using the latest APIs that are optimized for security and performance.

## Protecting Users

Our Google Play Developer policies are designed to provide a safe and secure experience for our users while also giving developers the tools they need to succeed. For example, we have always required developers to limit permission requests to only what is needed for their app to function and to be clear with users about what data they access.

As part of today's Google Play Developer Policy [update](https://play.google.com/about/updates-resources/), we're announcing changes related to SMS and Call Log permissions. Some Android apps ask for permission to access a user's phone (including call logs) and SMS data. Going forward, Google Play will limit which apps are allowed to ask for these permissions. Only an app that has been selected as a user's default app for making calls or text messages will be able to access call logs and SMS, respectively.

Please visit our [Google Play Developer Policy Center](https://play.google.com/about/developer-content-policy/#!?modal_active=none) and this [Help Center](https://support.google.com/googleplay/android-developer/answer/9047303) article for detailed information on product alternatives to SMS and call logs permissions. For example, the [SMS Retriever API](https://developers.google.com/identity/sms-retriever/overview) enables you to perform SMS-based user verification and [SMS Intent](https://developer.android.com/guide/components/intents-common#SendMessage) enables you to initiate an SMS or MMS text message to share content or invitations. We'll be working with our developer partners to give them appropriate time to adjust and update their apps, and will begin enforcement 90 days from this policy update.

In the coming months, we'll be rolling out additional controls and policies across our various products and platforms, and will continue to work with you, our developers, to help with the transition.

The trust of our users is critical and together we'll continue to build a safe and secure Android ecosystem.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
