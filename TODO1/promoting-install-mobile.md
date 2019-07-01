> * 原文地址：[Patterns for Promoting PWA Installation](https://developers.google.com/web/fundamentals/app-install-banners/promoting-install-mobile?hl=zh-cn)
> * 原文作者：[Peter Mclachlan](https://developers.google.com/web/resources/contributors/pjmclachlan?hl=zh-cn)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/promoting-install-mobile.md](https://github.com/xitu/gold-miner/blob/master/TODO1/promoting-install-mobile.md)
> * 译者：
> * 校对者：

# Patterns for Promoting PWA Installation (mobile)

Progressive Web Apps (PWAs) are a [pattern](https://developers.google.com/web/progressive-web-apps/?hl=zh-cn) for creating app-like, instant loading, reliable and installable websites. Although PWAs are available for all devices, including [Desktop](https://developers.google.com/web/progressive-web-apps/desktop?hl=zh-cn), this article focuses on mobile PWA install promotion patterns.

Why would you want a user to install your app to their home screen? The same reason you’d want a user to install your app from any app store. Users who install are your most engaged audience. Users who install a PWA have better engagement metrics than typical visitors, including more repeat visits, longer time on site and higher conversion rates, often at parity with native app users on mobile devices.

**If your PWA has use cases where it’s helpful for a user to install your app, for example if you have users who use your app more than once a week, you should be promoting the installation of your PWA within the web UI of your app.**

**Note:** See [Add to Home Screen (Web)](https://developers.google.com/web/fundamentals/app-install-banners/?hl=zh-cn) for the code required to implement a PWA install promotion.

## PWA install promotion best practices

Some best practices apply no matter what promotional patterns you’re using on your site.

1. Keep promotions outside of the flow of your user journeys. For example, in a PWA login page, put the call to action below the login form and submit button. Disruptive use of promotional patterns reduce the usability of your PWA and will negatively impact your engagement metrics.
2. Include the ability to dismiss or decline the promotion. Remember the user’s preferences if they do this and only re-prompt if there’s a change in the user’s relationship with your content such as if they signed in or completed a purchase.
3. Combine more than one of these techniques in different parts of your PWA, but be careful not to overwhelm or annoy your user with install promotion. Remember rule #1!
4. Only show the promotion when you [detect](https://developers.google.com/web/fundamentals/app-install-banners/?hl=zh-cn#listen_for_beforeinstallprompt) that the `beforeinstallprompt` event has been fired.

## Automatic browser promotion

![](https://developers.google.com/web/updates/images/2018/06/a2hs-infobar-cropped.png?hl=zh-cn)

Example of the Add to Home screen mini-infobar for AirHorner

The browser already tells the user about the installability of your PWA using a mini-infobar when your PWA passes the [installability checklist](https://developers.google.com/web/fundamentals/app-install-banners/?hl=zh-cn) on Android. The mini-infobar is only meant as a helper, and it will go away in the future.

**Note:** Starting in Chrome 76, you can [prevent the mini-infobar from appearing](https://developers.google.com/web/updates/2019/05/mini-infobar-update?hl=zh-cn) by calling `preventDefault` on the `beforeinstallprompt` event. If you do not call `preventDefault`, the banner will be shown the first time a user visits your site and it meets the [installability criteria](https://developers.google.com/web/fundamentals/app-install-banners/?hl=zh-cn) on Android, and then again after approximately 90 days.

## Application UI promotional patterns

Application UI promotional patterns can be used for almost any kind of PWA and appear in the application UI, such as site navigation, banners, etc. As with any other type of promotional pattern, it’s important to be aware of the user’s context to minimize disruption of the user’s journey.

Sites which are thoughtful about when they trigger promotion UI achieve a larger number of installs and avoid interfering with the journeys of users who aren’t interested in installation.

### <a name="header"></a>Fixed header

This is an install button that is part of the header of your site. Other header content often includes site branding such as a logo and the hamburger menu. Headers may be `position:fixed` or not depending on your site’s functionality and user needs.

![](https://developers.google.com/web/fundamentals/app-install-banners/images/install-promo/header.png?hl=zh-cn)

When used appropriately, promoting PWA install from the header of your site is a great way to make it easier for your most loyal customers to return to your experience. Pixels in your PWA header are extremely valuable, so make sure your install call to action is appropriately sized, of greater importance than other possible header content, and unintrusive.

Make sure you:

* Evaluate the value of your installed use case for your users. Consider selective targeting to only present this promotion for users that are likely to benefit from it.
* Use precious header space efficiently. Consider what else would be helpful to offer your user in the header, and weigh the priority of the install promotion relative to other options.

### <a name="nav"></a>Navigation menu

Add an install button/promotion in a slide out navigation menu.

![](https://developers.google.com/web/fundamentals/app-install-banners/images/install-promo/nav.png?hl=zh-cn)

The navigation menu is a great place for promoting the installation of your app since users who open the menu are signaling engagement with your experience.

Make sure you:

* Avoid disrupting important navigational content. Put the PWA install promotion below other menu items.
* Offer a short, relevant pitch for why the user would benefit from installing your PWA.

### <a name="landing"></a>Landing page

The purpose of a landing page is to promote your products & services, so this is one place where it can be appropriate to go large with promoting the benefits of installing your PWA.

![](https://developers.google.com/web/fundamentals/app-install-banners/images/install-promo/landing.png?hl=zh-cn)

First, explain your site’s value proposition, then let visitors know what they’ll get from installation.

Make sure you:

* Appeal to features that will matter most to your visitors and emphasize keywords that might have brought them to your landing page.
* This is a landing page. After you’ve made your value proposition clear, make your install promotion and call to action eye catching!
* Consider adding an install promotion within your app where users spend most of their time.

### <a name="banner"></a>Install banner

A dismissible banner at the top of the page.

![](https://developers.google.com/web/fundamentals/app-install-banners/images/install-promo/banner.png?hl=zh-cn)

Most users have encountered install banners in mobile experiences and are familiar with the interactions offered by a banner. Banners should be used carefully because they can be very disruptive to the user experience.

Make sure you:

* Wait until the user has demonstrated interest in your site before showing a banner. If the user dismisses your banner, don’t show it again unless the user triggers a conversion event that indicates a higher level of engagement with your content such as a purchase on an eCommerce site or signing up for an account.
* Provide a brief explanation of the value of installing your PWA in the banner. For example, you can differentiate the install of a PWA from a native app by mentioning that it uses almost no storage on the user’s device or that it will install instantly without a store redirect.

## Inline promotional patterns

Inline promotional techniques interweave promotions with site content. This is often more subtle than promotion in application UI, which has tradeoffs. You want your promotion to stand out enough that interested users will notice it, but not so much that it detracts from the quality of your user experience.

### <a name="in-feed"></a>In-feed

An in-feed install promotion appears between news articles or other lists of information cards in your PWA.

![](https://developers.google.com/web/fundamentals/app-install-banners/images/install-promo/in-feed.png?hl=zh-cn)

Your goal is to show users how to access the content they’re enjoying more conveniently. Focus on promoting features and functionality that will be helpful to your users.

Make sure you:

* Limit the frequency of the promotions to avoid annoying users.
* Give your users the ability to dismiss the promotions. Remember your user’s choice to dismiss.

### <a name="journey"></a>Booking or checkout journey

Show an install promotion during or after a sequential journey, typical of booking or checkout flows. If you’re displaying the promotion after the user has completed the journey, you can often make it more prominent since the journey is completed.

![](https://developers.google.com/web/fundamentals/app-install-banners/images/install-promo/journey.png?hl=zh-cn)

Make sure you:

* Include a relevant call to action. Which users will benefit from installing your app and why? How is it relevant to the journey they are currently undertaking?
* If your brand has unique offers for installed app users, be sure to mention them here.
* Keep the promotion out of the way of next steps in your journey or you can negatively affect your journey completion rates. In the eCommerce example above, notice how the key journey call-to-action to checkout is above the app install promotion.

### <a name="sign-up"></a>Sign up, sign in, or sign out flow

This promotion is a special case of the [journey](#journey) promotional pattern where the promotion card can be a more prominent.

![](https://developers.google.com/web/fundamentals/app-install-banners/images/install-promo/sign-up.png?hl=zh-cn)

These pages are usually only viewed by engaged users, where the value proposition of your PWA has already been established. There’s also often not a lot of other useful content to place on these pages. As a result, it’s less disruptive to make a larger call-to-action as long as it’s not in the way.

Make sure you:

* Avoid disrupting the user’s journey inside the sign up form. If it’s a multi-step process, you might want to wait until the user has completed the journey.
* Promote features most relevant to a signed up user.
* Consider adding additional install promotion within the signed-in areas of your app.

## What patterns should I use?

### eCommerce

Many eCommerce brands have a core group of loyal customers. These customers want push notifications for early access to new collections and to know when their items have shipped. They want the app on their home screen for quick access to the catalog and a full screen experience.

Patterns that work well for eCommerce PWAs include:

* [Banner](#banner)
* [Header](#header)
* [Nav](#nav)
* [Landing](#landing)
* [In-feed](#in-feed)
* [Journey](#journey)
* [Sign-up](#sign-up)

#### Product Listing Page (PLP) or Category page

This is a special case of the in-feed install promotional pattern, where the feed is products or category listings.

![](https://developers.google.com/web/fundamentals/app-install-banners/images/install-promo/plp.png?hl=zh-cn)

Make sure you:

* Match the look and feel of the rest of your product listing page.
* Don’t disrupt the user’s product selection process.

### Rich media and communications

Are you building the next social phenomenon or music streaming app? When new users visit your PWA for the first time, inviting them to install your PWA is a great way to bring them back. With less storage usage than a typical native app, your users can install your PWA and see whether your product is right for them.

Patterns that work well for rich media and communications PWAs include:

* [Banner](#banner)
* [Header](#header)
* [Nav](#nav)
* [Landing](#landing)
* [Journey](#journey)
* [Sign-up](#sign-up)

### News

If you work on a content oriented site, chances are you have regular users who would be interested in installing your PWA.

Patterns that work well for news and social PWAs include:

* [Banner](#banner)
* [Header](#header)
* [Nav](#nav)
* [Landing](#landing)
* [In-feed](#in-feed)
* [Journey](#journey)
* [Sign-up](#sign-up)

### Games

The modern web is a great distribution platform for games with the biggest reach in the world.

Patterns that work well for PWA games include:

* [Banner](#banner)
* [Header](#header)
* [Nav](#nav)
* [Landing](#landing)
* [In-feed](#in-feed)
* [Journey](#journey)
* [Sign-up](#sign-up)

#### End of game

This is really just a special case of the [inline journey](#journey) UI pattern.

![](https://developers.google.com/web/fundamentals/app-install-banners/images/install-promo/game-over.png?hl=zh-cn)

Most casual and hyper casual games end quickly. If your users are enjoying the game, this is a great chance to invite them to install.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
