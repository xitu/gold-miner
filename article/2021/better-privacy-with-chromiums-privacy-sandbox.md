> * 原文地址：[Better Privacy with Chromium’s Privacy Sandbox](https://blog.bitsrc.io/better-privacy-with-chromiums-privacy-sandbox-6134117f74be)
> * 原文作者：[Mahdhi Rezvi](https://medium.com/@mahdhirezvi)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/better-privacy-with-chromiums-privacy-sandbox.md](https://github.com/xitu/gold-miner/blob/master/article/2021/better-privacy-with-chromiums-privacy-sandbox.md)
> * 译者：
> * 校对者：

# Better Privacy with Chromium’s Privacy Sandbox

![Photo by [Dan Nelson](https://unsplash.com/@danny144?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/10368/0*IeaUrcmOuZUgq-Jn)

There has been a lot of buzz about privacy these days, especially concerning browsers. Recently there was a huge uproar when Whatsapp announced that it would start sharing user data with its parent company, Facebook. According to [Wired](https://www.wired.com/story/whatsapp-facebook-data-share-notification/), Whatsapp has been sharing our data with Facebook for several years. This uproar sparked the debate for using user data for advertising services.

You might simply say that your own personal data should not be shared with Facebook to make the advertisements more catered towards. But I believe that if this process is done with proper legal measures, it brings us more benefits than problems. Imagine an instance where you chat with your friend about a mobile device on WhatsApp, and the next moment, you see an advertisement for that same product on Facebook. Your initial reaction would be to freak out, but if not for these personalized advertisements, you wouldn’t have known about this particular store selling the phone you wanted to buy, at an awesome price.

Due to these numerous benefits for both users and companies, there have been proposals to change the way ads work. The Privacy Sandbox is an initiative of Google that contains such proposals to make the web a better place and still allow companies to earn revenue via advertising.

## What is Privacy Sandbox?

The Privacy Sandbox is an initiative by Google that intends to “Create a thriving web ecosystem that is respectful of users and private by default”. This proposes a set of privacy-preserving APIs to support business models to earn revenue without the need for tracking solutions like 3rd party cookies. In this cookieless scenario, Google wants targeted ads, conversion measurements, and fraud prevention to happen according to the standards set by Privacy Sandbox. In this scenario, cookies will be replaced by the privacy-preserving APIs mentioned above.

In software engineering terms, the word sandbox refers to a protected environment. In this Privacy Sandbox initiative, your data is kept protected in a secure local environment, within your device browser. Advertisers will only be able to access the necessary information via the provided APIs. These APIs reveal only the information needed by the advertisers and nothing more than what’s necessary.

A vital principle of the Privacy Sandbox is that a user’s personal information should be protected and not shared in a way that lets the user be identified across sites.

Let’s have a look at how Privacy Sandbox can change the way we surf the web without third-party cookies.

![Photo by [Paula Guerreiro](https://unsplash.com/@pguerreiro?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/11850/0*Tyf4CKlKHucwp3PV)

## Interest-based Advertising

One of the proposals that were intended to replace third-party cookies in targeted advertising is [Federated Learning of Cohorts (FLoC)](https://github.com/jkarlin/floc). This proposes a change in the way users are tracked, where rather than observing the browsing behavior of individuals, we observe the behavior of a cohort of similar people. This new way enables businesses to reach individuals with targeted ads by clustering groups of people with similar interests. This novel approach hides **individuals** “in the crowd” and uses on-device processing to keep their data safe locally.

Google’s ads team was able to successfully test this proposal and found out that **advertisers can expect to see at least 95% of the conversions per dollar spent when compared to cookie-based advertising.** This finding proves that FLoC is the path of the future with priority for privacy.

The Chrome team expects to start public testing of FLoC by March 2021. You can read more about FLoC over [here](https://github.com/WICG/floc).

## Creating Audience

One of the essentials of a successful advertising campaign is the creation of audiences. Privacy Sandbox includes proposals on how marketers and advertisers can create their own audiences without the need for third-party cookies. The Chrome team published a new proposal called [FLEDGE](https://github.com/WICG/turtledove/blob/master/FLEDGE.md) which is based on a previous Chrome proposal called [TURTLEDOVE](https://github.com/WICG/turtledove). This new proposal takes into account the industry feedback given for TURTLEDOVE and integrates features like “**trusted server**”. The trusted server is used to store information about a campaign’s bids and budgets.

FLEDGE is essentially Google’s option for advertisers who want to reach prior visitors to their website via remarketing. FLEDGE is expected to hit trials later this year. You can read more about FLEDGE over [here](https://github.com/WICG/turtledove/blob/master/FLEDGE.md).

## Measuring Conversion

Google has proposed several methods that would allow marketers to measure conversion. These proposals make sure that the privacy of users is kept protected while supporting key advertiser requirements. Techniques such as event-level reporting and aggregate-level reporting will be used to measure conversion. These reporting techniques allow bidding models to recognize patterns in data and deliver accurate measurements over clustered groups of consumers.

Google also plans to use techniques like aggregating information, adding noise, and limiting the amount of data sent out from your device to preserve the privacy of consumers. Due to this, advertisers will have to prioritize the conversions which are important for their reporting and access only them. But the company is still calling for wide feedback and a measurement prototype is yet to be built.

## Ad Fraud Prevention

The well-being of the advertising-supported web model depends on the ability to distinguish traffic from actual users and fraudulent traffic. Google plans to verify this with the help of a feature called Trust Tokens API. Trust Tokens is a new API to help combat fraud and distinguish bots from real humans, without passive tracking. This feature allows an origin to issue cryptographic tokens to a user it trusts. These tokens are stored in the user browser and can evaluate the user’s authenticity in other contexts.

Google expects to start trials by March this year with the launch of their next release that supports an updated version of Trust Tokens. You can read more about Trust Tokens [here](https://web.dev/trust-tokens/).

## Anti-fingerprinting

I have written several articles on fingerprinting in browsers and how dangerous it can be. You can read more over [here]((https://blog.bitsrc.io/the-darker-side-of-pwas-you-might-not-be-aware-of-ffa7b1d08888)).

Browser fingerprinting is a technique used by marketers to identify and track individuals uniquely with easily available simple information such as your browser type and version, as well as your operating system, active plugins, timezone, language, screen resolution, and various other active settings.

To make Privacy Sandbox secure from fingerprinting, Google has proposed an anti-fingerprinting approach. This new proposal called [Gnatcatcher](https://github.com/bslassey/ip-blindness) tries to mask an individual's IP address in such a way that it does not interfere with the normal operations of a website. Since this is a work in progress, it will be continuously improved with feedback from the community.

You can read more about this technique over [here](https://github.com/bslassey/ip-blindness).

[Here](https://developer.chrome.com/blog/privacy-sandbox-update-2021-jan/) is the Chrome team's Jan update for 2021.

## Conclusion

There have been many brave attempts to change the way our web works. But most of them turned out to be failures mainly due to the fact that at least one of the main stakeholders was not happy with the change. But in the case of the Privacy Sandbox, Google says that advertisers and marketers will lose at most a 5% drop in conversions per dollar spent compared to third-party cookies. On the other hand, consumers would anyways be happy as their privacy is safer with this new model.

But industry players in the advertising and marketing fields have their own concerns. They doubt whether Google will be fair and square with its internal teams and the outside world. Google has dedicated internal teams who work under advertising. Experts are wondering whether these internal teams will have access only to the same aggregated data given to outside marketers, advertisers, and other advertising vendors. There have [been instances](http://digiday.com/uk/google-winner-googles-anti-tracking-moves-slow-amazons-ad-growth/) where Google has played tricks to protect its share of advertising revenue. If that is the case, Google’s internal teams would have access to more granular-level user data that would make it unfair for the rest of the players in the advert industry. If Google pulls any tricks up their sleeve, you can expect huge chaos.

What do you think about this novel proposal? Would it make the web a safer place? Or will it hand over the controlling power to a monopoly?

Thank you for reading!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
