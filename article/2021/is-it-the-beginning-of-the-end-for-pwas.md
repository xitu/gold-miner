> * 原文地址：[Is It the Beginning of the End for PWAs?](https://blog.bitsrc.io/is-it-the-beginning-of-the-end-for-pwas-da0fb032d545)
> * 原文作者：[Mahdhi Rezvi](https://medium.com/@mahdhirezvi)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/is-it-the-beginning-of-the-end-for-pwas.md](https://github.com/xitu/gold-miner/blob/master/article/2021/is-it-the-beginning-of-the-end-for-pwas.md)
> * 译者：
> * 校对者：

# Is It the Beginning of the End for PWAs?

![Photo by [Szabo Viktor](https://unsplash.com/@vmxhu?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/11232/0*LmCaetpJHYbKh2bn)

Progressive web apps are changing the way we understand applications by providing an app-like experience in the web form. It was a way of describing applications that take advantage of new features supported by modern browsers, including service workers and web app manifests, and also lets users upgrade web apps to progressive web applications regardless of their native operating system.

But PWAs have been linked with several privacy concerns over the years. This had led to Apple blocking several PWA features on Safari. You can read more about them [over here](https://blog.bitsrc.io/the-darker-side-of-pwas-you-might-not-be-aware-of-ffa7b1d08888).

Nevertheless, other browsers such as Chrome and Firefox had continued to support the development of PWAs immensely.

Recently, Mozilla had released Firefox 85 which was aimed at protecting against **supercookies**. This version also appears to have dropped support for an essential feature for desktop PWAs. Let’s have a look at what it is.

## What Was Dropped?

Firefox is dropping an experimental feature that supports installing Progressive Web Apps to the desktop. This feature is known as **Site Specific Browser — SSB**.

For those who were observing the situation, Mozilla had [already indicated](https://bugzilla.mozilla.org/show_bug.cgi?id=1682593) that they might drop support for SSB in future releases. The reason for this removal can be found in the bug tracker comment.

> The SSB feature has only ever been available through a hidden pref and has multiple known bugs. Additionally user research found little to no perceived user benefit to the feature and so there is no intent to continue development on it at this time. As the feature is costing us time in terms of bug triage and keeping it around is sending the wrong signal that this is a supported feature we are going to remove the feature from Firefox.

#### What is SSB?

SSB is an experimental feature that allows any website to run in desktop mode, with its own window. The Site Specific Browser feature, which was available in Firefox 73 and above, allowed you to launch any website in a window with a minimal UI.

## Is This A Deal Breaker?

It all depends on your perspective and intended usage of PWAs. If you think that PWAs are a way of getting applications that are platform-independent and perform like native applications, then you might be disappointed with this decision. If you think PWAs are simply a shortcut on your desktop, you probably wouldn’t bother about this change.

There are a number of people who are unhappy about this decision, but the numbers are quite low compared to the total number of users. This is mainly because this was an experimental feature and was not known to many.

As [Ian says](https://www.i-programmer.info/news/87-web-development/14261-firefox-drops-support-for-pwa.html),

> Users aren’t going to get upset because they have no idea what is being denied them and anyway why should they care that you have had to put extra effort in to create a native app?

Since technology is evolving at a rapid pace, companies spend a lot of resources on R&D. Experimental features are essential as they decide the future of the application. When something significant is dropped, it sends the wrong signal to the users.

But when the time comes and when PWAs become a highlighted browser feature, Firefox might lose a considerable amount of users to alternative browsers due to this move.

## Why The Fuss?

You might start wondering whether this article title is clickbait. No, it is not.

A common trend in the tech world is when,

1. A company makes a radical move
2. Competitors mock them
3. After a few years, the competitors who mocked the move, adopt the same move

You can relate this to several notable incidents such as the removal of the headphone jack, the removal of the home button in mobile phones, and the most recent buzz — removal of the charger from the mobile phone box.

The reason for the removal of SSB was mentioned to be the bugs that were causing trouble and precious time. If that’s the case, alternate browsers such as Chrome and Edge might also feel that this move will be beneficial for them. In such a scenario, we might lose PWAs for desktops for a while as similar incidents have happened in the past. Although this is highly unlikely, there is always a chance for something like this to happen, especially in the world of tech.

What do you think about Mozilla’s move? Comment them below.

Thank you for reading.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
