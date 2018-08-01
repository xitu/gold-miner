> * 原文地址：[Apple has no idea what’s next, so it’s just banging on the same old drum](https://medium.com/@ow/apple-has-no-idea-whats-next-so-it-s-just-banging-on-the-same-old-drum-dcfd0179cf80)
> * 原文作者：[Owen Williams](Owen Williams)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/apple-has-no-idea-whats-next-so-it-s-just-banging-on-the-same-old-drum.md](https://github.com/xitu/gold-miner/blob/master/TODO1/apple-has-no-idea-whats-next-so-it-s-just-banging-on-the-same-old-drum.md)
> * 译者：
> * 校对者：

# Apple has no idea what’s next, so it’s just banging on the same old drum

If you want to witness a company that’s simultaneously in its prime and losing control over its own narrative, look no further than WWDC, Apple’s second-most splashy event of the year, designed to offer a glimpse of the future.

The annual developer event is a spectacle that I’ve watched live for almost a decade, but this year was different: it showcased a company that’s lost in the woods, playing the same old hits on repeat, in the same old format.

Not only was it painful to watch, it demonstrated that Apple doesn’t really have a coherent plan, or understanding, of where it should take its core platform, let alone the ones it’s tried to build around it.

It’s fine to have an off year, but what struck me was how… random it felt, and how little insight or forward thinking there was. Apple’s own platform advantages, company culture, and whatever else, seem to be pigeonholing its trajectory, driving it down a path that looks increasingly dated, and leaving me to wonder if the company is self-aware enough to see the shifting tide before it’s lost at sea.

#### Big, slow, yearly

![](https://cdn-images-1.medium.com/max/1000/1*tIUbwrpHZPbdNPXB569wPQ.png)

Apple struggled throughout 2017 to ship flagship features it promised at WWDC 2017, including Airplay 2 and iCloud Messages, delivering them quietly just days before this year’s event.

Alongside a scandal about performance throttling, a series of major security slip-ups, and hardware that shipped without long-touted features, many have loudly asked what’s causing these issues — and why a company with so many engineers is fundamentally failing to ship.

Performance improvements are arguably the biggest focus of iOS 12. They’ll be welcome for many users, along with several additional improvements: streamlined notifications, a new ‘shortcuts’ feature for custom buttons, usage reporting, group FaceTime, AR updates and a number of other minor improvements to create a major release, iOS 12.

The company’s other platforms received similar treatment, including macOS. Apple finished dark mode, a feature it [half-introduced](https://9to5mac.com/2014/11/08/yosemite-dark-mode/) all the way back in Yosemite, added basic functionality to Finder, threw in a new way to organize your desktop, and _boom — _there’s your major release, 10.14.

None of these things are inherently bad — in fact, people have been complaining about the lack of improvements to things like FaceTime for years — but what’s interesting is Apple’s choice to bundle them together as a way to make them look truly meaningful, rather than just fixing many of these issues sooner, in a point release. I’m aware there’s a slew of tiny other fixes and features I haven’t listed here, but that’s my point: it’s a hodgepodge of things that have been neglected over the years after being debuted once and forgotten about.

**Here’s the rub:** Apple could arguably ship notification improvements to iOS users tomorrow in a point release, iOS 11.5, but it won’t. Combining them provides the illusion of progress. Instead of servicing users and giving them features sooner, on a regular basis, Apple chooses to hold back simple functionality longer, for its bottom line.

As Martin Bryant points out, [Apple may have a timing problem](https://www.getrevue.co/profile/bigrevolution/issues/big-revolution-apple-has-a-timing-problem-117182):

> Yes, Apple needs to take the time to do ‘boring’ optimisation work on iOS, but why build iOS around these big, annual feature bumps and then disappoint people when the bumps aren’t very big?

![](https://cdn-images-1.medium.com/max/1000/1*xyYGoFI-pve4NohGovx0Eg.png)

Interestingly, the narrative here actually doesn’t make sense anymore, either. Every year, Apple takes the time to point out how _dire_ the state of the competition is: Nobody’s Android phones get updates! Android people don’t get any the latest features! Your phones all suck! The reality is different: Android users, regardless of manufacturer, frequently get them sooner than iOS users do, because Google divorced the operating system and core application suite from one another.

Google’s approach to unbundling Android has, for the most part, been quietly successful — in an unexpected way. Instead of shipping monolithic feature updates, Google’s applications are now updated via the Play Store, from the clock app to the calculator and even the camera (unless you’re Samsung).

Apple has made a yearly ritual out of jabbing competitors for poor update histories, but conveniently omits the reality that improvements to Google Assistant, the built-in web browser, or even just the OS keyboard will reach billions of users in a matter of hours without needing to update the entire phone. [Android’s support libraries](https://developer.android.com/topic/libraries/support-library/) mean developers can target older devices, with new features, regardless of whether or not they received the OS update.

Meanwhile, if you find a bug in the iOS keyboard, or some weird security flaw in Safari’s web view, you hope it gets fixed in the next version of the operating system. Maybe next year, or the year after that. It depends how bad it is, or if Apple is actively maintaining the feature, as to when it’ll get serviced.

Don’t get me wrong, Android has a terrible history of updates that is only now beginning to change, ten years after the fact. Google has made strides with Project Treble, which makes an end-run around the device maker itself, but it’s only in its infancy with new devices picking it up today. That’s not good enough either; but it’s gaining traction _and_ getting things into people’s hands.

![](https://i.loli.net/2018/07/23/5b556d7e1426b.png)

For each platform update, Apple dangles a carrot. That’s the flagship feature to convince you it’s a Big Update™ worth having immediately. On macOS this year, that’s dark mode, and on iOS, the promise of performance improvements and, _god forbid_, actually decent notification management.

Arguably the most interesting segment out of WWDC happens at the very end of the two-hour keynote: [a peek at Project Marzipan](https://www.imore.com/marzipan), a long-term effort to unify the interface framework developers use to build apps for iOS and macOS, which is expected to ship to everyone in 2019.

![](https://cdn-images-1.medium.com/max/2000/1*Ukm9QN-FSM6m8gjZb-bL7g.png)

From where I sit, this is an impressive, massive project that doesn’t do much more than play defense against Electron’s continued march on Apple’s territory, threatening to kill native application development altogether. Why build anything native at all, when you can write once, and run everywhere? Anti-Electron fans will run rabid at the idea, but as the technology has become more efficient and introduced lower-level API access, it only makes even more business sense.

Marzipan is an audacious plan to defend against that by making it easier to build cross-platform apps. It’s a genuinely fascinating play with fewer apparent benefits in the short term over just building an Electron app, which addresses an additional billion users, allows developers to use familiar web technology _and_ is truly write-once-run-everywhere.

Over time, Marzipan may win favor with developers, but I’m not convinced it’ll stop web-based technologies swallowing native app development whole, particularly given that both Microsoft _and_ Google have now bet their entire strategies on Progressive Web Applications, and how low the barrier of entry has come as a result of Electron’s success.

Marzipan indicates something bigger, of course, such as an impending shift away from Intel chipsets entirely to some sort of custom Apple ARM-based silicon in — _shock horror — _a productivity form factor. If anything, what will win as a result will be that control, and what it could ship in a end-to-end device: true all-day battery? Always-on LTE with desktop class apps?

If so, the message is this: lock in with us, develop for our platforms, and we’ll reward you. Don’t, and you’ll be shut out and stuck on the outside.

#### Hey Siri, where’s the vision?

![](https://cdn-images-1.medium.com/max/1000/1*CRkO0VCT6Mh2CFRtbhhfmA.png)

What’s clearly missing in all of this is a willingness to take risks, or go for the long view on what’s better than the status quo for Apple’s users. Instead of looking at how phone usage is changing and redesigning the nature of iOS, it’s another year of shoehorning new features into a decade-old shell.

The new shortcuts feature promises to let users wire up workflows of their dreams, chaining together tasks behind a single button. Yes, this is a great improvement to iOS that addresses a problem without actually improving on the reason anyone needs this in the first place — it’s just glued onto the homescreen that’s responsible for causing the need for it in the first place.

Apple could have offered up a way to surface the weather right there, deeply integrated with the lock screen, or calendar events at the top of your home screen along with the icons, but it didn’t. Instead, it slathered what appears to be a UX hack in the shape of a notification, and tries to guess when you want to see it.

Google’s own developer conference, just down the street in Mountain View, was held in May and offered a clearer, if poorly highlighted, view of the future: AI is a core part of mobile devices going forward, so we’re beginning to add it everywhere.

![](https://cdn-images-1.medium.com/max/600/1*lTYCJE8xA9-M8G61QkAKsA.gif)

The Android alternative to Shortcuts, Slices and App Actions, surfaces the device’s best guess at your next action as a deeply integrated interface component, where you can actually see information before actually going further in, or taking an action.

Want a button to order a Lyft? Great, here’s a button embedded within the system’s app tray, with the current estimated price of your ride, which orders it right now with a single tap. Much of this data is crunched on device, just like Apple’s audacious claims to privacy brag about as well, but instead of being a UX hack to add buttons that summon help, the information is already right there, on hand, without opening anything, even Assistant.

Google and Apple both anticipate a future in which we use our phones less — time well spent is a core part of this driver — and as a result, it appears Google has spent a lot of time thinking about how AI can help get the right information to the user. The result is the exact button they need at the right time, with relevant information, sans the need to actually go away and do something.

To facilitate this, Google is willing to rejig the UX of its devices, mess with the sea of icons, and has invested heavily in serendipitous computing with Google Home alongside this, so it can get you there faster regardless of if the phone is in your hand.

![](https://cdn-images-1.medium.com/max/2000/1*eCsl8DddzfF1WJRNk4QfZA.png)

Google’s vision of the future of smartphones, mobile operating systems, and the way we’ll interact with devices over the long haul is a coherent, well-told story: get more out of your day, get the devices out of the way. It even has a [fantastic page](https://store.google.com/us/magazine/google_cross_product_experience?hl=en-US) that showcases how its own ecosystem works better, together, than I’ve ever seen explained about Apple’s ecosystem on its own site.

As for _why_ all of this happens, I suspect it’s a difference in strategy and approach. Apple’s strategy has long been to monetize its existing cash cows as long as it can by throwing out new stuff to see what sticks and doubling down on that, rather than creating any sort of coherent narrative of what the future actually looks like, operating in secrecy until it somehow lands upon it.

Incremental improvement is fine, but there’s a distinct lack of forward-looking, and a whole lot of looking over the fence at what everyone else is doing to bash it instead.

#### Apples, oranges and comparing the two

![](https://cdn-images-1.medium.com/max/1000/1*GXShGcoP70vKsNXCqfWByQ.png)

It’s easy to compare and contrast Google and Apple because they are very different companies, but what they’re both claiming to do is the same: invent the future, whatever that actually might be.

Their approaches, however, are increasingly diverging: Apple’s squeezing more out of less, shipping flashy features, and focusing on privacy, while Google and others have pushed further into understanding the user and getting out of their way.

Most of this comes down to business model.

Apple’s focus on features by piling them together drives more sales of iPhone, which drives reliable revenue on a yearly basis. Google’s is on advertising and relevance to the user, which doesn’t depend on a particular feature or thing to tout, it just needs you to love using its tools (and not mind advertising).

Apple’s entire strategy over the last two decades has pivoted around the exploitation of a product line until something new comes along, then rinse and repeat. This is framed around improving your life and often actually does, even if that is by proxy. I’d argue that the company’s vision of the future isn’t to enrich, or drive progress, but to squeeze as much revenue as possible out of slick, well-designed and marketed ideas. The products it builds, the cycles they’re released in and the way that Apple’s entire software cycle works reflects this.

An example of the manifestation of this is perhaps HomePod’s requirement to have a locally available iPhone to do anything interesting, leaving it crippled without one, and Animoji’s debut only to be locked away in Messages instead of somewhere like the camera.

![](https://cdn-images-1.medium.com/max/1000/1*qf_K81yBsB-b2yJ9explpw.png)

Google, a latecomer in the game, has the luxury — and peril — of not depending on phone revenue, so it can risk it all and get weird, since it’s not fundamentally critical to the company’s continued trajectory. Microsoft has done the same, now finding itself the underdog, risked it all and [moved to an ‘OS-as-a-service’ model](https://docs.microsoft.com/en-us/windows/deployment/update/waas-overview) in which it ships features when they’re ready instead of waiting for flashy releases.

Apple, on the other hand, begins and ends with the iPhone today, the rest flows from there. It can’t just rip up the foundation on which its revenue exists, and Tim Cook hasn’t shown a flair for doing so. iOS is too valuable to go away and tear down to just reimagine it for fun, so it’s the status quo, with experiments like HomePod and AirPods on the side, where it _can_ get weird and sometimes wonderful. That’s fine, because Apple has plenty of cash lying around, but it’s interesting how limiting the approach can become.

As we hurtle toward peak smartphone, the cracks here are beginning to show because Apple don’t _have_ the next big thing yet — that we know of, naturally — and it’s taking a long time to get here. We’re essentially watching the bottom of the metaphorical tube of toothpaste being squeezed, while others are trying to figure out if maybe the tube should work completely differently.

AR is potentially the next platform, yes, [and it’s clear that Apple is pushing forward on that](https://www.wired.com/story/apple-wwdc-augmented-reality-wearables/%5C) in a big way, so it’s easy to imagine a scenario in which it makes sense to shift precious resources there instead of focusing on iOS which may wind up unimportant in a year or two. I’m not convinced that in the short term, such as the oft-claimed 2020 launch date of an Apple VR/AR headset, that we’ll be headed there in any meaningful capacity. I mean, Magic Leap, a bajillion dollar company building the future of AR showed off its hardware yesterday on Twitch, quipping that “you better not put it in your pocket or it’ll overheat.”

I’m happy to be wrong, and I write this knowing I’ll probably be that guy who [very publically crapped on the iPhone at launch later](http://bgr.com/2015/04/07/original-iphone-reaction-comments/). Apple’s worth a very large amount of money, which is more than enough proof that it’s good at many things, including convincing people to buy a phone every year.

![](https://cdn-images-1.medium.com/max/1000/1*_fmWBe3iuLHDiDezd6PR9g.png)

So, what if the next platform just doesn’t arrive any time soon? We’re reaching a plateau as computing performance and power improvements level out, and the pace of innovation the iPhone — and all smartphones — relied on to exist is drying up. The software platforms have shifted entirely, like Microsoft’s focus to almost entirely be on enterprise productivity, and Google’s on being available wherever the user is in the ecosystem. They stand poised to benefit, as they offer a growing array of capabilities across the spectrum, from the smart home to a reinvention of human-computer interaction via voice assistants, and the competition further locks down the moats.

In a new world that’s defined by ambient, intelligent computing, that just does stuff on our behalf and our tools having the context they need about us to be useful, Apple may be out of its depth or simply unwilling to risk making a bold enough bet to go beyond the iPhone.

I think it’s a bit of both, and it’s on full display as unlikely new underdogs emerge. None of this is to say Google, Microsoft or anyone else is any better: they all have their own disadvantages, absurd inconsistencies or weird narratives at times, but a shift certainly _feels_ like it’s happening below the surface, and there’s a window of opportunity in which Google seems to be executing extremely well so far.

Yeah, in the end these are all just tools; a way to get things done. Some people like one thing, others like the other.

People will always choose whatever helps them get more out of their lives, and what best fits their lifestyle. For years, that default for many has been the iPhone, but nothing is forever. I think people are starting to notice.

* * *

_If you enjoyed this and want more insights into the technology industry, my weekday morning briefing helps you understand what’s worth knowing and why. Use the code_ **_medium-friend_** _at checkout for 40% off the first month. ♥️_

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
