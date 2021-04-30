> * 原文地址：[Here’s Exactly What You Need to Know About Apple’s App Tracking Transparency](https://onezero.medium.com/heres-exactly-what-you-need-to-know-about-apple-s-app-tracking-transparency-bdb06c0b58c0)
> * 原文作者：[Lance Ulanoff](https://medium.com/@LanceUlanoff)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/heres-exactly-what-you-need-to-know-about-apple-s-app-tracking-transparency.md](https://github.com/xitu/gold-miner/blob/master/article/2021/heres-exactly-what-you-need-to-know-about-apple-s-app-tracking-transparency.md)
> * 译者：
> * 校对者：

# Here’s Exactly What You Need to Know About Apple’s App Tracking Transparency

![Photo by [Dan Nelson](https://unsplash.com/@danny144?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/10368/0*B4ygEL8TGVED_RdC)

There’s a new privacy sheriff in town. His name is ATT and he rode in Monday on a horse named iOS 14.5. He likes apps just fine but not ones that pick your pockets for bits and pieces of data debris that he can share with his posse.

I don’t think it’s stretching the analogy too far to say that Apple’s App Tracking Transparency (ATT) policy for app developers is one of the most talked-about and potentially feared updates since Wyatt Earp strolled into Tombstone.

Now that it’s here, though, I’m astounded at all the misinformation and confusion surrounding this relatively straightforward concept.

In the space of two hours, I had one person ask me to talk about “Apple’s new requirement that app developers collect consumer data,” and someone else on Twitter wonder if it was up to app developers whether to comply with Apple’s new rules. Others wondered if app developers could acknowledge you opting out of their data collection schemes and then grab your data anyway.

Apple spells out the rules quite clearly in their iOS 14.5 documentation, which, even though you will certainly install the iPhone (and iPad) update sometime within the next few weeks, you may never read.

Hidden under iOS Settings/Privacy/Tracking is the new switch “Allow Apps to Request to Track,” under which it says, “Allow apps to ask to track your activities across other companies’ apps and web sites.”

I understand that language might throw you: “I’m allowing companies to ask me to allow them to ask me about collecting my data?”

Right, but if you turn it off, your new options are also a tad fuzzy:

“Allow Apps to Continue Tracking” (trust me, you already have dozens of installed apps that have been doing this data sucking and sharing for years)

and

“Ask Apps to Stop Tracking”

This second choice instantly turns off the tracking permissions you previously offered to apps (in my case, I only showed three doing it) and then sets up that ATT roadblock, which will force apps to ask you for new permission to track and share data.

Apple gave developers many months to build this into their apps and, I assume, figure out new ways of working with third parties who relied on these consumer data feeds.

None of this will have any real impact on your mobile device activities aside from, perhaps, less of your private data floating from one third-party app partner to another. There might also be fewer instances of people wondering why a random website has an ad for Cancun after you happen to mention the Mexican getaway destination to a friend on Facebook.

That’s sort of the sum of Apple’s ATT, but there’s also more to it. I’d recommend digging a little further and reading the details under the “Learn More” link in the “Allow Apps to Request to Track” section.

For one thing, Apple makes clear exactly what happens when you don’t give permission to track your activity: “The app is prevented from accessing your device’s Advertising Identifier.” It also adds that “App developers are responsible for ensuring they comply with your choices.”

That last part left me scratching my head: What if developers don’t comply? If the responsibility is in their court, enforcement must be in Apple’s, right?

It’s also worth learning what Apple does and doesn’t consider tracking:

“It is not considering tracking when the app developer combines information about you or your device for targeted advertising or advertising measurement purposes **if the developer is doing so solely on your device and not sending the information off your device in a way that identifies you**.”

I added the italics for emphasis because I think this part is key. It’s how Facebook, one of the [biggest consumer data vacuums](https://medium.com/@LanceUlanoff/the-great-unraveling-dc17eae49a63) on the planet, may be able to skate on through ATT.

You see, in Facebook’s world, it’s generally the only one that knows the connection between you and your private Facebook data. What it shares with third-party advertisers does not identify you. Instead, it identifies behavior patterns that might be attractive to advertisers and then connects that data to the ad, which is how you see it. The advertiser, though, doesn’t have your info.

There are cases in which Facebook has handed real data to partners who were not supposed to share it with anyone else and use it for marketing, targeting, or ad purposes, and then those partners did so anyway: [See Cambridge Analytica](https://www.nytimes.com/2018/04/04/us/politics/cambridge-analytica-scandal-fallout.html). Apple’s ATT will prevent that overtly.

There’s still ample room for developers to collect data locally and deliver ads based on that information. And it sounds like your data can still leave the phone if it’s anonymized. For instance, if your Facebook page says, “I like mint chocolate chip ice cream,” Facebook could still let an advertiser know that it has one or more consumers interested in mint chip ice cream, get an ad from that partner, and then pop it into your Facebook app feed.

Apple’s ATT is a big deal, and I know it’s forcing change and bringing greater awareness and transparency to how developers use our data. It’s not, though, changing the entire game, and, I suspect, Facebook will be fine.

In the meantime, take my advice and read all of Apple’s App Tracking Transparency fine print.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
