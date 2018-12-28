> * 原文地址：[The State of Web Browsers: Late 2018 edition](https://ferdychristant.com/the-state-of-web-browsers-f5a83a41c1cb)
> * 原文作者：[Ferdy Christant](https://ferdychristant.com/@ferdychristant?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/the-state-of-web-browsers.md](https://github.com/xitu/gold-miner/blob/master/TODO1/the-state-of-web-browsers.md)
> * 译者：
> * 校对者：

# The State of Web Browsers: Late 2018 edition

![](https://cdn-images-1.medium.com/max/800/1*ysSQaD2xD85QT2Zz2kFxZw.png)

**Update (Dec 6, 2018):** Microsoft has [confirmed](https://blogs.windows.com/windowsexperience/2018/12/06/microsoft-edge-making-the-web-better-through-more-open-source-collaboration/) the rumor to be true. We now have one less browser engine, and a last man standing (Firefox) in deep trouble (reasons below). If you agree that this sucks, [install Firefox](https://www.mozilla.org/en-US/firefox/). Also on mobile. Here’s instructions on how to [switch from Chrome](https://www.mozilla.org/en-US/firefox/switch/).

**Update (Dec 8, 2018):** The below article is a truthful but depressing read. I’ve published a follow-up article that radiates hope for what is to come in 2019 [here](https://ferdychristant.com/the-state-of-web-browsers-88224d55b4e6).

### Introduction

_Warning: this article contains several words_.

Yesterday, [Windows Central](https://www.windowscentral.com/microsoft-building-chromium-powered-web-browser-windows-10) published a rumour that Microsoft is ditching its Edge browser, or more accurately put, to relaunch a new browser using the Chromium engine. The rumour has been picked up by mainstream media and as far as I know, not denied by Microsoft, therefore I assume it to be factual. A good reason as any for me to share some thoughts on the current landscape of web browsers.

If you’re new to my blog, I’ll add the background that I’ve been in the web game since 1996, and have seen every iteration of the browser wars up close. In terms of mindset, I’m from the Zeldman school of thought: a deep believer and proponent of the open web, web standards, a shared web.

I’ll also warn you that I am direct, frank, cynical, love dark humour, and don’t take many things serious, including myself. With that in mind, let’s go.

#### Microsoft Edge: doomed to fail

Let’s first establish the market share failure that Edge is after 3 years of existence. Depending on the source to use, it is listed at around 4–5%. This is from a company still running a desktop semi-monopoly and having the ability to push it down our throats in subtle, or not so subtle ways. It is from the same company who once had a 80–90% market share, an almost complete monopoly.

It gets worse, combined with mobile, market share plummets to about 2%. In the range of 2–5%, Edge joins a long list of browsers nobody really cares about. Like Opera, or Vivaldi, or Samsung Internet. Sure, each may have a loyal following and they may even be great browsers in their niche, but they are not major players, nor would any developer care explicitly about them.

The situation for Edge is in fact worse compared to small browsers like Opera. At least those browsers are compatible with the web. Websites will work in them because websites are built to work in Chromium. Edge doesn’t have that luxury, because they have their own engine to maintain, playing constant catch up in an effort to get the modern web to work in an engine of their own making.

Having virtually no presence on mobile and failing to gain traction on a market you control, desktop, can be considered a failure. Here’s some thoughts on how Edge could have done better. These are mere opinions, and we all know hindsight is 20/20:

*  The biggest opportunity for market share was missed during launch. No matter how much you hate Internet Explorer, you have to acknowledge that hundreds of millions of users have been trained to consider it “the internet” out of sheer muscle memory. Some because they’re forced to use it, some because they don’t know any better, and it works for them. This large audience was not captured when Edge launched. There’s no guidance from IE to Edge. Edge is as alien to an IE user as any other new browser they have failed to switch to in all those years. Hell, Microsoft could have even kept the icon the same, and switch rendering engines behind the scenes to capture this audience. But they didn’t, so nobody switched, not in great numbers. All of this happened during a larger move, the deeply confusing Windows 8 era. Here finally the word clusterfuck would be accurate, as it really was a cluster of several failings at once.

*  To those IE users who are aware of what a browser is, and that there are competing browsers, it’s not clear how Edge is better compared to that other new default, Chrome. It doesn’t seem to be better at anything, and quite a lot worse in some things. And to alienate traditional desktop users even further, Edge has a touch-first design. Everything is giant, tucked away, flat. Basic expectations of desktop usability is broken exactly for that audience most promising to Edge: IE users.

*  To developers, Edge is just another IE. Another pain. It’s better than IE, but it remains the browser lagging behind in features and web standards, the browser in which things don’t work or render differently. It’s not due to the Edge team itself. In my interactions with them, I found them to be awesome. Great engineers, proponents of an open web. It seems to me the team is rather small, and perhaps doesn’t have enough resources. Also, Microsoft once again insisted on the fail strategy to ship browser updates as part of OS updates, whilst the competition ships every 6 weeks. A losing proposition. The best possible outcome in these conditions is shipping a browser that is slightly worse than the competition, so why bother at all.

*  A lack of marketing. Sometimes Microsoft is stuck in its old ways. They ship something and believe just shipping it triggers mass adoption. Like it always did in their decades-long dominance. Those days are over, you need to compete, market, win hearts and minds and do so aggressively for a long time. Has this been done for Edge? I don’t think so. Years after launch, still Edge has no significant mind share.

All of the above said, I don’t think these reasons matter much at all. Had all these things be handled better, perhaps 4% would be 6%. It most certainly would not make Edge truly significant in terms of market share, nor would there be any hope of ever achieving good old dominant market share.

The reasons for that, in short, are: mobile. If a typical website gets 50–60% mobile traffic these days, and if billions of people are joining the web with mobile as their only device, it’s safe to say that you lost the browser game if you have no (meaningful) presence there.

Desktop still is a sizable and interesting market though, and here Microsoft finds itself stacked up against Google. Who owns the world’s most important web services and can easily push Chrome to its billions of users. Users that Microsoft does not have, as it doesn’t operate a single meaningful web service. Google will even go as far as making their services only work in Chrome, or actively hamper the operation of a service to users of other browsers (allegedly). They force Android manufacturers to ship Chrome and countless other Google apps as defaults towards billions of users.

It’s hard to miss the historical karma game going on here. Microsoft had previously acquired dominant browser market share using deeply unethical and anti-competitive ways. Now their competitor is doing the exact same thing, and they are at the losing end.

So I conclude that Edge is doomed. It was doomed and its next version will be equally doomed from the start. For the simple reason that Microsoft has close to no say in how browsers get installed: on mobile as a default app, and on desktop via web services under the control of Google. Switching to Chromium makes no difference in market share, as the only way to compete now is through the browser’s UI, not via the engine. Which isn’t a competition at all, since browser UI is a commodity.

#### Microsoft Edge on Chromium

Assuming the rumor to be true, what would it mean if Edge switched to Chromium as a render engine?

For market share, not much, see the previous section. Potentially, it could mean a tiny bump up, as Edge would become more compatible with the Chromium-dominated web and therefore attract more users as a browser in which the web “works”. I don’t think that would make a serious dent though, because it’s not a unique capability.

For developers, it’s one less browser engine to worry about, if they were worrying about it in the first place (unlikely). Less testing effort, less browser-specific bug fixing, a slight productivity boost.

For the open web: it’s complicated. If I were to put on the hat of a pragmatic developer, I fail to see the big gain in having competing browser engines. Pragmatically speaking, if I enter code and run it, I want the output to be the same, no matter the engine. Getting different results or even bugs in this output is not a gain, it is a pain. Having feature disparity between engines sucks, it means building multiple versions of the same thing. You can give it nice names like “progressive enhancement” but that doesn’t change the fact that it sucks, from a purely pragmatic productivity point of view.

So what is the whole point of having different engines? Speed could be an argument, but I hardly consider it a strong point these days. The speed of each engine currently out there seems superficially similar.

Which leaves innovation coming from engines as the sole benefit of having multiple engines. Whereas in practice different engines primarily create lots of pain, they do at times provide benefits to the open web as a whole. There are countless examples of browser vendors inventing new features that ultimately become useful web standards. Yet even in that case, a counterpoint is easy to make: that new feature could also have been built into a shared, open source engine. Like Chromium. If that engine is truly open source in the democratic sense, that is.

My take on this is that when it comes to the open web, it’s not browser engines being the driving force of keeping the web open. If that would be true, the open web is already lost, given the Chromium dominance. Instead, I opt for diversity, competition and collaboration in the decision making process regarding web standards. Less engines could be acceptable for as long as ownership and the standards process regarding those fewer engines are diverse, and not controlled by one organization.

To make that a whole lot more explicit: At a W3C meeting or standards discussion, the room should not be 60–70% Googlers. Likewise, Google should not have veto power over an “open source” project like Chromium. Microsoft, Mozilla, Adobe and the like should get equal representation there so that even with less engines, we have shared ownership and decision making on what will be in that engine.

The other aspect of browser innovation is outside the engine, it’s in the UI itself. I can be rather quick about this one: I am totally indifferent to it. They’re all the same to me.

As for Microsoft’s perspective on the switch to Chromium, one can only speculate, so let’s. I think they realize they can’t win significant market share with Edge, and as such, find themselves having a money drain with no light at the end of the tunnel. It’s costly and painful to develop a browser engine and with zero business benefits, they might as well adopt to the “standard”. An admission of defeat. Since they lost mobile and are increasingly a service company, they’re forced to make all their products 100% compatible with Chromium anyway, so why have a home grown engine that is less capable? Even within Microsoft itself, Chromium is the first-class citizen, not Edge.

One could wonder why they would launch another browser at all. Surely the new browser will not outperform Edge in market share, so why have one at all? Practical reasons, I suppose. They can plug and integrate a few features exclusive to some Windows devices into the browser, for example drawing on a web page. Plus, it’s embarrassing to ship an OS without a first party browser. People would have no way to download Chrome.

#### Firefox: the long road to irrelevance

If you think Edge’s situation was and is dire, things are about to get even more grim. Let me first show my true colors: I root for Firefox’s success. I have been doing so since they made the first crack in Microsoft’s IE dominance and have been doing ever since. Not because I think they have the best browser, instead because of sentimental reasons: they are the only independent browser, guardians of an open, shared web. They have superior, human values compared to the rest. I want them to do well.

But they’re not doing well. They’ve already lost, and keep losing some more. First, their Firefox OS initiative failed and just like Microsoft, they now find themselves without meaningful presence on mobile. Mobile market share barely registers at around 1%, even worse than Edge.

We can reiterate the simple conclusion here that without mobile presence, you lost. The majority of web traffic is mobile, it’s that simple.

But again, desktop is not totally irrelevant. Yet here too Firefox is failing hard, and has been failing for a long time, in spectacular ways:

![](https://cdn-images-1.medium.com/max/1000/1*a0-r-zbZqI0PnCcYSjUCuA.png)

The above desktop-only view of browser market share is telling. There’s Chrome, and there’s everybody else. Everybody else can be split into two groups: Firefox and the pit of despair: a larger group of small browsers with no meaningful market share.

Firefox stands above that lowest group by having more market share, which used to be enough to be considered a major browser, a serious player. A weighty means of resistance against one browser monopolizing the game. Not as a dominant player, yet still as a major player.

Well, no more. According to most sources, Firefox has dipped below 10% market share. On desktop. Cross device it would be far lower still. And the trend is negative. Hard to see in the above chart, but they lost a whopping 3% in the last year. Despite their marketing efforts and emphasis on making Firefox competitive again, it’s clearly not working. Or not yet.

A cross device view on market share is even more shocking:

![](https://cdn-images-1.medium.com/max/1000/0*UKH_lV5-RXgDUAFm.png)

Source: [https://en.wikipedia.org/wiki/Usage_share_of_web_browsers](https://en.wikipedia.org/wiki/Usage_share_of_web_browsers)

From over a 30% market share as a peak to almost complete irrelevance, in 8 years. The chart is clear about the mobile revolution being a primary reason, given the rise of both Chrome and mobile Safari. Yet as we saw in the desktop chart too, there they are moving fast to join the gang of irrelevant browsers.

Firefox is now an irrelevant browser in total market share, and well on its way to become irrelevant on desktop as well, if it isn’t already. The first signs of it are already visible. In the past decade, no web developer would ever launch anything that doesn’t work in Firefox. You’d be ridiculed. It was a developer-default browser, a starting point.

Well, no more. Increasingly I’m seeing sites, code experiments, all kinds of things not working well or not working at all in Firefox. And nobody cares. The behavior of seeing Firefox as an unimportant browser is slowly normalized. The question of whether Firefox is relevant is already answered: it isn’t. The only question is how irrelevant it will become.

Mozilla has two weapons to combat the decline, both of which will horribly fail, I’m pained to say. Not because I want them to fail, or to be overly negative or pessimistic. They will fail because both weapons do not address the root cause of the decline.

Weapon 1 is technology. Mozilla is doing fantastic things in rewriting their browser, from an engineering perspective that is. There’s Servo, Rust, WebRenderer which all look highly innovative, and will ultimately produce a better browser. They may soon have a little peak in delivering the world’s best desktop browser, from a technical point of view.

Firefox loyalists (like me) will love it, and 3 new people will agree it’s awesome. And that’s the end of it. The enormous market shifts in browser market share are not caused by browser features or performance. They are caused by the mobile-first revolution and dominant parties being able to ship default browsers to billions of users. Non-technical users do not consciously pick a browser based on features or speed, and even if they did, modern browsers are all fast. I honestly can’t tell the difference between any of them, not even on mediocre hardware. Firefox’s decline and the sharp rise of competitors is not due to engineering, therefore the solution also does not lie in engineering. And even if you did believe engineering is the solution, let’s establish that you can’t out engineer Google. You can win a battle, but not the war.

Weapon 2 is mind share. Firefox as the good guy, guardian of your privacy, an independent force for good. I care, and I’m on board with these sentimental reasons, but we have to be honest that most people don’t care. When choosing between convenience and principles, most people pick convenience. Or, they don’t even spend a second thinking about it because they don’t hear you preaching, or know you even exist (reach). Most certainly there are people who do care, but there’s not enough of us to save Firefox, I’m afraid. A telling example is when Facebook acquired WhatsApp, triggering mainstream discussions on how vast groups would ditch it because of privacy concerns. Nobody did. Whatsapp grew a lot in users that year.

Ugh, a bleak picture of Firefox’s state and its future. What is to become of it? Not much. The best outcome would be that they stop the decline and settle at the current level. Even if they did so, their market share would still decline in total as mobile keeps growing and Firefox has nothing significant there. Desktop market share could become a steady line yet are unlikely to rise significantly because there’s not a single reason I could think of why that would happen.

The worst scenario is that on desktop they too keep declining into the territory of 5% browsers or less. When this happens, they have become totally irrelevant. And not just that: they would be an irrelevant browser with a different browser engine. Like Edge.

Note that when I say irrelevant, I don’t mean dead or meaningless or without future. As a 5% browser, you can still provide meaning and relevance to perhaps a 100 million users. That’s a lot of people. Most of us work on products several scales below that. With irrelevant I mean irrelevant to the browser wars at a worldwide scale.

Our cup of poison isn’t empty yet. Microsoft, in their abandonment of Edge and their own rendering engine, could have done the right thing. Which is to collaborate with Mozilla. It would make for a powerful alliance against Chromium/Chrome dominance. At least on desktop, it could have made a meaningful difference.

But they didn’t, they didn’t choose the right path, they chose the easy short term path. Because doing right is for losers, like Firefox. Nice guys finish last, at least in this round of the wars.

#### Chrome, also called “the web”

A lot has been said about Chrome already, and my opinion on it is complex, you could say it has “layers”.

First, strictly speaking regarding personal usage, I think Chrome is the best browser out there. It’s fast, has a pretty good UI, extension support is great, and the developer tools are out of this world. Which is not to say other browsers are crap. They are good too, Chrome is just slightly better.

From a developer point of view, as said, best dev tools. More importantly, Chrome is that browser typically first to ship new web features. As a developer, I pretty much never face the situation where something doesn’t work in Chrome, yet does work in competing browsers. The opposite happens to me daily.

So yes, Chrome makes me happy as a user and a developer. It’s a great browser. And let’s continue the cheering: there is no organization in the history of the web who has done more for the betterment of the web platform than Google.

Yes they have the resources to do so. So has Microsoft, who for the largest part of their history, actively sabotaged the web. Big difference. Yes, improving the web may serve Google’s own interests. But they’re doing it. Without Google’s weight and pace in improving the web, we would be in darker times, technically speaking.

If you’ve never lived through those darker times yourself, I can sum it up: browsers never ship anything, and it takes 5 years for even the simplest new feature to become widely available. And then it still wouldn’t work. Google made the web a first-class citizen and in recent years is almost solely responsible for making it a sustainable app platform, or at least is the biggest driver in doing so.

And now the stabbing can begin. Sure enough, Chrome as a browser is good and a good browser can grow market share organically, simply for being good. Part of the rise of Chrome in market share can be explained by the quality of the browser itself. For it being a user preferred browser.

It would be naive to think though that out of the blue, billions of users collectively decided to use Chrome as a default, out of pure awesomeness. Word of mouth does not work that fast, nor do people select browsers on rational and technical grounds.

Clearly, the drastic upward rise in market share is realized in other ways, by means of Google’s dominance in other markets:

*  If you want to include the Playstore on your Android device, you’re forced to put Google’s suite of apps on the device, which includes Chrome. If you don’t want the Playstore, you might as well not launch the device at all, so it’s not really an option. It comes down to this simple equation: if you’re not Apple and launching a mobile device, you **will** ship Chrome. You may now mention niches of Android where no Playstore is used, it doesn’t change the overall point for the vast majority of devices.

*  Besides the ability to force-ship Chrome to billions of users, Google also owns some of the world’s most widely used web services. Search, Maps, Gmail, Youtube and the like. Which all work better on Chrome, or contains ads to install Chrome. Another example of a method where their dominance in one market, allows an advantage in another. Here the advantage is not a brute force install as with Android, yet it’s still an aggressive push.

*  There are various other ways in which Chrome is shipped to the user without an actual user-triggered action. Shipping it as part of some other bundle of software is an example.

I believe capturing market B via your dominance in market A, is anti-competitive behavior. “Dominance” is the keyword here. It’s business as usual for a company to do this at small scale, and generally allowed. Ford may ship a Ford car radio (I know, not the best example) and nobody cares. Nor is it illegal, as it doesn’t really disturb a secondary market.

At a monopoly scale, it becomes a different matter. It’s the same behavior Microsoft was convicted of (without any meaningful consequence).

You can disagree and go all neoliberal to say that any company can do whatever they want on their own OS or web service. It’s an opinion you can have. I would disagree, for the record. In any case, it doesn’t change the outcome. Google is the only entity in the world with the power to ship a (default) browser to so many users, by means of their mobile dominance, and their web service dominance.

Chrome, once pushed to these billions of users, turns out to be quite a great browser. It really is a good browser. And important Google services work so well in it. So it sticks, and becomes the new default. Chrome being a really good browser, combined with unique capabilities to push it to billions of users is how we got to a market share of 60–70%. It then becomes a developer default and all kinds of side projects (like Electron and various Chromium clones) pop up to strengthen the dominance even further.

Mozilla nor Microsoft can win back lost market share for the obvious reasons mentioned above. They are near-absent on mobile, and they don’t operate a single meaningful web service. Microsoft kind of had the ability to push a browser via Windows, but they screwed up. Now, it doesn’t matter how good they make their browser. They can’t ship or push it at scale.

And so we live in a Chromium/Chrome world now, or have been living in it for some time. It seems a return to Microsoft’s past dominance with IE, yet the situation is significantly different.

Microsoft had a browser that sucked (IE6). Google does not. Chrome is great. Microsoft’s browser was non-standard, intentionally and openly so. Chrome is largely standards-based (even if Google has a large say in those standards). Microsoft didn’t invest a penny in bettering the web, and didn’t touch IE for years, sabotaging the web, bleeding it to death. Google does the opposite, they aggressively invest in bettering the web.

It’s a better kind of dominance. Like a friendlier dictator. But still a dictator. The practical consequence for a developer in the short run is likely to be received as a positive. A great browser, a great browser engine, and most of the world making use of it. The day-to-day concern of a developer is to ship things, which is easier in a monoculture, like it or not.

The longer term faith of the open web, it hangs in the balance. I don’t believe implementers can break the dominance anytime soon via an actual browser or browser engine, which is why I’ll reiterate what I already said: there must be equal representation in the process where web standards get created, as well as in the decision making process where priorities for implementation get set. We’d then have less engines, basically only one, yet what gets build for it in which order would be shared. An open decision making process, followed by implementation in a single engine. It would be a kind-of open web.

No, not even that is ideal, I know. I’m keeping it real. A kind-of open web is superior to the situation of having a single engine with a single private organization calling the shots. The idealistic scenario of a multi-engine open web is dead or dying, as discussed above.

#### Safari

I believe we have now moved past the peak and essence of this article, yet I’ll give some thoughts on browser players of lesser significance. Furthermore, I have to finish my tour of bashing every single tech giant, to ensure to never receive a job offer from any of them, ever. I don’t like loose ends.

Safari, of course, has reached significant market share thanks to Apple’s mobile success, combined with a complete lock-down on which browsers users can install (or more accurately said, which browser engine they can use). Whilst not a force as dominant as Google, it’s a sizable force.

We can once again go back to the simple observation that Microsoft and Mozilla can’t do such a push or lock-down, since they basically don’t exist on mobile. And this proves that the quality or features of a web browser hardly matter. Because if it did matter, Safari would be dead.

Mobile Safari most certainly would not be a browser with 15% market share (much higher if you include mobile only) because it is so awesome. It’s not awesome. It’s a reasonably capable browser that lags behind Chrome, Firefox, and even Edge in terms of features and web standards support. Take any Chromium clone that has near zero market share and it is functionally and technically better than mobile Safari.

Surely, Safari lagging behind has to be intentional. If you want to have an underwhelming experience, have a look at Safari’s release notes. Bugs are open for years and when a new web feature is shipped, it’s often incomplete, buggy, and unusable. If you’re in the game of trying to ship web apps at the quality level of a native app, your number one enemy will be mobile Safari.

Apple, being a trillion dollar company, could out engineer Google just by having even deeper pockets. Or at least try to. They could also apply their much praised quality mindset to their browser. They don’t. They seem fine in it slugging along, in it being buggy. To invest just enough to not let it bleed to death, yet not enough to actually make it a powerful app platform. Because any platform that is powerful that is not owned by Apple itself, is not a priority, or even a threat.

Once again I will say that the actual team behind the browser is not at fault, it never is. They mean well. They do support an open web. They are amazing engineers. It’s just that the mother ship holds them back, because interests don’t align. It happens in big corporations. I know, I work for one.

#### Internet Explorer

What is left to be said about Internet Explorer? Not much, other than it being the slowest death of a browser in history. Even Microsoft’s burial of their own browser does not kill it. At this point in time, many developers are in a position where they finally can ignore old IE as a whole, or have been doing so for a few years.

But don’t underestimate the rest of us. For example, I work for a healthcare company, where customers seemingly love IE. I’m talking a 10% market share, which is too big to ignore. And the number doesn’t seem to be going down that much, which is highly depressing. Building a modern web experience with old IE in mind is like adding a square wooden wheel to a Tesla.

And then there’s corporate internal. Which has shitty age-old IE-only applications. That everybody hates yet somehow have to keep running. I always wonder what the owners of these systems expect to happen exactly. They want to keep the system up yet not invest a dime in it. As if complete inaction will ultimately solve it. The system is dead. It has no future. It has to be replaced, waiting does not solve the problem.

#### Everybody else

To finish our round of browsers, there’s everybody else. Mostly Chromium-based browsers. They compete via their UI, not their engine. I don’t have much to say about these browsers. They can each attract their niche audience, but they hardly matter in the bigger picture. They can win or lose a percentage or two, yet never rise above the 10% threshold that I’ve arbitrarily set as an important browser.

### Wrapping up

I had not expected to do such a long write-up, nor did I plan to make it so sour and bitter. I’ve tried to call things for what they are even if those things are ugly. And ugly things are:

The web now runs on a single engine. There is not a single browser with a non-Chromium engine on mobile of any significance other than Safari. Which runs webkit, kind of the same engine as Chromium, which is based on webkit.

On desktop, Edge’s departure from running their own engine, means there’s only one last man standing to counter the Chromium dominance: Firefox. Which is falling from a cliff, on its way to join the “everybody else” gang of insignificant browsers. With no serious way to truly counter it due to their near-absence on mobile, and their lack of control in pushing browser installs.

So Chromium it is. If you’re now waiting for a message of hope or a happy ending, I have none. Just like the IE era, the new monopoly was not created by means of a level playing field where the best browser has won, the world is a lot messier than that. The new monopoly was created by control over markets, and the ability to push a browser to billions of users in ways subtle and not so subtle. In this round, it was done via a capable browser (Chrome) unlike the previous round (IE6).

The victor is clear, and balance will not be restored unless these market dynamics change in radical ways. Until that day, enjoy Chromium.

**Update:** To compensate for the depressing ending of the above story, I’ve written a follow-up article aiming to give people caring about the web some much needed reasons to be optimistic, despite all of the above. Check it out [here](https://ferdychristant.com/the-state-of-web-browsers-88224d55b4e6).

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
