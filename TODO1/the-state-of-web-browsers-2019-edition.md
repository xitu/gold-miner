> * 原文地址：[The State of Web Browsers 2019 edition](https://ferdychristant.com/the-state-of-web-browsers-88224d55b4e6)
> * 原文作者：[Ferdy Christant](https://ferdychristant.com/@ferdychristant)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/the-state-of-web-browsers-2019-edition.md](https://github.com/xitu/gold-miner/blob/master/TODO1/the-state-of-web-browsers-2019-edition.md)
> * 译者：
> * 校对者：

# The State of Web Browsers 2019 edition

![](https://cdn-images-1.medium.com/max/800/1*mkxbYIvO9oe1xsjjezUELA.png)

Two days ago, I published a bitter sweet article on the [state of web browsers](https://github.com/xitu/gold-miner/blob/master/TODO1/the-state-of-web-browsers.md), triggered by the news that Microsoft would abandon their EdgeHTML engine, replacing it with Chromium. Which was the final nail in the coffin, effectively establishing Chromium as the web’s engine, combined with Safari’s webkit. The only resistance to this monopoly, Mozilla, finds itself without any significant allies or traction to counter this development.

The article got some readership and a fair amount of feedback. The general consensus seems to be that the article is truthful but depressing.

Critical notes suggest that some statements are true-ish but too broad, lacking finer details and nuance. I agree. Some statements could be more polished, but it would make the article twice as long, and not all of those details matter for the larger conclusions I was going for. To illustrate, the article got tens of thousands of views, only 25% bothered to actually read it. Which surely has to do with length, and I suppose some were so disgusted halfway-in, they gave up, saving both time and the chance of a clinical depression.

Only a few critiqued the delivery style of brutal honesty, most seemed to appreciate it. And some don’t, it comes with the territory. All I can say is that I won’t tone it down, I was actually in a mild mood that day. I don’t apply brutal honesty for shock value or attention, I genuinely believe that in a world ruled by tech, we need no nonsense critique, not sugar coated suggestions. Plus, I’m dutch, this is our default tone of voice.

Back on point, why a second article? I want to address the depressing part of the original article. If you were brave enough to read it to the end, you’d notice the lack of a happy ending. You could be under the impression that the web is a lost cause, the open web in great danger, and that we’ve returned to medieval IE times. It would take the greatest of optimists to wade through that article without it ruining your day, if you care about the web.

I cannot change the fact that the road to Chromium/Webkit dominance was messy or even abusive. It is a questionable history that will not be undone. We’re going to leave this one to the lawyers, but sure enough, those browsers aren’t going to be uninstalled. It’s a done deal.

In this article, we’re going to accept the new state, where Chromium dominates the web, and look **ahead**. To see what Chromium dominance means for users, developers and the open web. The spoiler is of course that there’s plenty of reasons to be happy, optimistic, and even excited about this new state, even if the new state came into existence in unfair ways.

### Chromium for users: the web works

By a rough estimation of global market share, Chromium/Chrome browsers would make up for at least 70% of users. Then there’s 15% of Webkit, mostly mobile Safari.

No sane developer would ignore mobile Safari, and Webkit is in many ways similar to Chromium (although growing apart), therefore, a base starting point is that 85% of users will experience a website exactly as it was intended. **At least**. That’s pretty awesome.

It gets even better. Most websites do not use bleeding edge features or Chromium-only features, therefore Chromium dominance does not mean the same website would not work just as well in Firefox. Firefox is close to on par with Chromium regarding web standards. Even if slightly lagging behind, it doesn’t mean websites will break in Firefox at scale. And if there’s any issues, surely Mozilla will be eager to achieve compatibility asap.

Therefore, my very rough assessment is that for 90% of users, pretty much all of the web will work correctly and as intended by the creator. The exception would be parts of the web that are bleeding edge or experimental.

As strange as it sounds, in a competitive browser landscape where 3 engines would have an equal share, the above would not be as true. There would be far more compatibility issues. With our user hat on, the web works quite well in a Chromium world, where mobile Safari and Firefox combined are large enough to still keep the dominant engine in check.

The other 10% is stuff like old IE, slow as its death will be, it will shrink eventually, boosting our 90% even further.

And there’s more good news for users. With the exception of mobile Safari, all these browsers auto update on a frequent basis. Almost all web users will have up-to-date browsers to use an ever-improving web experience.

### Chromium for developers: life could get easier

A negative spin on the statement “The web runs on a single engine, Chromium” could be:

*   Developers build Chromium-only websites instead of standards-based websites, and they do this at scale.
*   Chromium is full of non-standard features and actively sabotages an open web or web standards

Both are overly dramatic conclusions that I don’t believe to be accurate.

First, yes, there was a low period a few years ago when the mobile revolution was in full swing where developers could not wait for web standards and massively used vendor-prefixed or Chrome/Webkit-only features to maximize what they could do on mobile, this whole new exciting category of the web. This practice got so far out of hand that competing browsers had to implement vendor prefixed features **of their competitors** just to stay in the game.

This period is largely behind us now. Every major browser vendor has agreed that vendor prefixes were a bad idea. New features are now behind a flag, which means developers cannot deploy them to users before they mature. Existing problematic prefixes that we cannot undo from the wild are now built into each browser to ensure compatibility.

So, no, developers using non-standard Chromium features does not seem like a huge problem to me these days.

What about Chromium-only standards-based features? Here we have the situation where Chromium shipped a new standards-based feature not yet available in other engines.

A short-sighted developer could conclude that they can just use it without fallback since the world runs Chromium anyway. Well, no. Good old lagging mobile Safari comes to the rescue. Very likely, mobile Safari will not have that new feature and it may not have it for years to come.

You cannot afford to ship a web experience that breaks in mobile Safari. Mobile Safari has 15% market share across devices. On mobile it’s 25%. In some major markets, it may even be as high as 40% on mobile.

**The fallback is a must in almost any case** and by developing the fallback, you are quite likely to support that other browser as well: Firefox.

As for Chromium and the relation to web standards, I’ll discuss it in a separate chapter. Let’s first now consider what the new state of browsers means for developers.

There is news, and there is no news. A first and clear positive workflow improvement is that you no longer have to test for EdgeHTML compatibility.

You’ll have to keep testing for Firefox, but here I expect improvements too. Mozilla will now be in survival mode and I expect them to prioritize compatibility with Chromium in an effort not decline any further.

The lack of bigger workflow improvements is in Safari lagging behind, forcing us into fallbacks, polyfills, transpilations, the like.

Rather than to keep bashing mobile Safari, I’m going to deliver a new take on it. Let’s make the rough assessment that Safari lags behind in supporting major new web standards by about 1–2 years in general.

Now be very serious when you ask yourself this question: given your audience and product, can you create the web experience you want your users to enjoy using web standards generally available 1–2 years ago?

If the answer to that question is YES, and I believe it very often can be, you may simplify your workflow significantly. Possibly, you can say goodbye to polyfills, transpilation and auto prefixing altogether. Because the web of 1–2 years ago really is no joke.

There are examples of emerging web standards where you do need the latest and greatest, for example Web Components. Still here you could ask the question if your users really need Web Components. Be honest, it’s you that wants Web Components, not your users. I won’t judge, I love web tech too.

I would welcome a simpler development workflow, I think the current one is rather shit. Absurdly complex, slow, constantly breaking, and obsolete by the time you have it working. I would welcome a return to just entering code and running it, without a 100,000 node modules processing my input. Maybe web development could once again become accessible and fun to those who are not hardcore engineers. Because the web belongs to all of us, and they are just as entitled as the rest of us to work on it. Even as an experienced developer you must admit the current state of affairs is rather involved and messy, even if you learned to cope with it.

### Chromium and web standards

We’ve established that we live in a Chromium monopoly which triggers deep concerns on the future of web standards, the standardization process itself, and the enormous control one party has over the future direction of the web. In this section, we’re going to explore how bad, or not so bad things are at a practical level.

Let us make the assumption that Google is at the steering wheel of both standards creation and standards implementation. It isn’t an absolute 100% power, yet a decisive power. Let’s explore how such a dominant position could potentially be abused, and whether it is likely to occur.

#### Incentive

First, we should take away one major concern, or even the biggest concern. Unlike old Microsoft or current Apple, Google has no business incentive to hurt or hold back the web or web technology in any serious ways. It is a company born on the web with an incentive for the web and web technology to thrive. Stagnation or intentionally introducing incompatibilities makes no logical sense, and no financial sense. In many or most cases, Google’s direction of the web benefits users, developers and themselves all at once. Interests align. Not perfectly, and not at all times, but most of the time they do.

Therefore at a very fundamental level, surely the web or web technology isn’t doomed at all. It is in the hands of a party that has just as much interest as us in preserving and improving it.

The devil is in the details, therefore let’s explore a few risks in detail:

#### Google just making stuff up in Chromium

With Chromium so dominant, Google could in theory bypass standards creation entirely and just go all rogue in pushing new features that fit their agenda. After all, if it’s implemented in Chromium, it has basically become a standard, right?

They can, occasionally, but they can’t go too far. Truly bullshit features will never make it to webkit or Firefox, which is a problem, as Google surely doesn’t want the web to be incompatible for hundreds of millions of users given their widely spread web properties.

Plus, if the feature is truly insane and openly against general interests, there will be push-back from other stakeholders, and subsequently, bad PR.

Finally, as said, “fit their agenda” very often aligns with the agenda of users and developers. So all in all, I’m not too worried about this one.

#### Google dictating priorities of implementation

In this scenario, Google would influence the logical order of implementation regarding web standards in a way that puts their interests first.

For example, imagine we’re all waiting for subgrids to be implemented, a feature that will widely benefit all of us. Meanwhile, Google prioritizes the implementation of KeyboardSynthesizerVoiceMachineLearningCloudWorklet instead, an essential API for their new chat client #735, code-named “Hola!”, to be announced at I/O 2019 and to be sunset 6 weeks later, for it had a disappointing 300 million users only.

Yes, this could happen and I think it does happen. Following Chrome release notes closely for a long time (which I realize is not the same as Chromium but close enough), I do find myself occasionally surprised at updates to APIs I never heard of or can’t imagine being widely needed, whilst there would be candidate features with a far wider use case not being delivered (yet).

It’s not as bad as it sounds. It doesn’t mean the more important feature does not get delivered. The web moves pretty fast these days. Also, there isn’t always some evil plan behind a more important feature not getting delivered first. It could simply be more complex or have more dependencies. With many people working on many things in parallel, there’s no guarantee that the most important feature gets delivered first.

So whilst Google may incidentally prioritize self-serving features, in practice I’m not seeing a huge risk. Once again, remember that the world is watching.

#### Google says NO

The opposite of prioritizing self-serving features is to de-prioritize or downright block ideas of others. Let’s assume the idea or proposal is serious and has consensus from many stakeholders. Yet for whichever reason, Google doesn’t like it, and blocks implementation.

This is a tricky one, where all we can do is look at track records and incentives. I’ll admit that I don’t follow Chromium discussions in detail, because I chose life. Possible there’s tons of examples where this happens, if so, let me know.

A memorable example I have of this happening is CSS Regions. It’s a giant spec and enormous code commit by Adobe that was blocked. Whether it was blocked for good reasons or bad, I’m unable to answer, given the enormous complexity of the discussion. You could cancel your Netflix subscription and be entertained for two months just soaking up this epic mud fight.

A more recent example is dropping HTML Imports, but here too it’s not clear at all whether it was a wrong move, given other browsers’ reluctance to implement it. It was blocked for technical reasons, not corporate reasons.

I’d say Google is unlikely to say no to ideas that help the web forward as its in their interest to help the web forward too. This will apply to any idea, for as long as those ideas do not threaten their business.

It’s easy to think of a web standards idea that is threatening: pretty much anything related to privacy. If the world agrees that 3rd party tracking should become impossible at a technical level via a web standard, you can be sure that there will be resistance from a company earning money from personal data. Yet here too the world is watching, and if Google protects their business too obscenely, they’re leaving open major opportunities for competing browsers to thrive. To fork Chromium. For Firefox to make a comeback. For Apple’s Safari to exploit their strength in privacy protection. It’s a careful balancing act.

So bottom line: Google generally has no incentive or track record of saying no to good ideas, and in cases where they do, the damage will not be disastrous nor can they go overboard.

#### Google outside Chromium

In the above sections I have illustrated how I believe Google at the steering wheel of the world’s web engine isn’t as bad for the web as it sounds. Just because they have the position, does not mean it will be abused. And I don’t believe it will be abused frequently or in major ways, minus a few incidental cases. There is no track record to assume that nor is there incentive. We can further strengthen that conclusion by knowing that despite a dominant position, there’s still checks and balances in place. For example, Microsoft and hopefully others are donating resources into the engine.

Indeed, at a practical level I have no immediate existential concern for the future of the web, web technology or web standards. If I was to be in an overly optimistic mood, I could be even be excited about it, given Google’s track record in improving the web. The web will continue to improve, in rapid pace, and those improvements will be deployed instantly to the vast majority of web users. It’s hard to see that as a negative. Even more so if you’re as old as me, having lived through times where pretty much nothing happened.

And this is where you watch a movie and the main characters seem to be happy for about 10 minutes. You know something bad is coming.

I can’t skip over the thought that if there is any threat to the web and its users, it isn’t in Chromium, it’s outside of it. Most questionable moves by Google take place outside of Chromium, and I’ll hereby discuss a few examples:

By far the most prominent example I can think of is AMP. I consider it a violent attack on open web principles. If you want to know why, I have a separate [article](https://ferdychristant.com/amp-the-missing-controversy-3b424031047) for that. Despite a storm of criticism from the web community, Google hasn’t changed its course, instead they’re doubling down on AMP.

Another recent controversy is in Chrome, which is not pure Chromium, therefore outside of Chromium. Google decided to secretly log you into the browser itself whenever logging into a Google service. It actively held back information about this change (unlike normal release notes) which is super shady, it proves that they know it to be a shitty move. When exposed, suddenly there’s “reasons” and “listening to feedback”.

A third concern is Google’s aggressive deprecation policy that lacks empathy. This is an area I have experience with. Because of some of my other hobbies (wildlife photography) I spent a lot of time on websites that deal with zoology: describing species. These websites are often made by amateurs, hobbyists, people that are not professional web developers. Also, some of these websites haven’t been touched (in terms of code) for years. Let’s call all of this the “old web”.

How big is this old web? I don’t know, but I’m willing to bet that most of the world’s web pages aren’t under active maintenance. The thing is, many of these websites are breaking. Partly, or as a whole. They’re falling apart, bit by bit. Because of deprecations, new expectations (for example HTTPS), but even more so by breaking API changes of 3rd party services, like Maps. Or, they are massively de-ranked for not complying with new expectations and therefore wiped from existence.

Yet these websites still have value. Tech companies owe it to these website owners for their site that once worked, to keep working years after. It’s part of the promise of the web: backwards compatibility. The gut reaction that these website owners should update their shit and get with the times is arrogant and lacks empathy. It is based on the faulty assumption that behind every website, there’s some team of developers maintaining it throughout its entire life cycle.

Even if you believe its their problem, consider this analogy. Say you have a computer illiterate mother (I do). She struggles with basic computing and needs constant help. You could now be all smug and tell her to brush up her computing skills, to “get with the times”. You could technically be right, but I sure hope she kicks your arrogant ass. Even if right, the problem isn’t going to be solved, and therefore empathy is the answer. And that’s how I feel about the old web: it must be preserved with empathy. Google has a very poor track record in this area.

I’m getting side tracked here, and breaking my promise of making this an optimistic article. I could make the above list a lot longer but my main point here is that most of Google’s questionable moves regarding the web and its users do not take place in Chromium, instead outside of it.

I don’t have a solution for it, it’s just an observation.

### The downsides of power

On to more positive thoughts. For us that is, not for Google. Sorry, Googlers. This one isn’t personal though, I promise. It may scare the shit out of you though. I want to talk about the downsides of power, of which there are many.

Whenever I see the CEO of a big company, my immediate thought is pity, not admiration. At the top of the food chain, it’s all eyes on you. There’s nobody to hide behind. Expectations are sky high, relentless, and constant. Mistakes, made by any human being, can have disastrous consequences which will forever be linked to you. Even the upsides aren’t that great. Fame has downsides. Money is not that great if you don’t have the time to enjoy it. There’s even personal security risks and legal risks. You don’t even know if your friends are really your friends.

No, I wouldn’t want to trade with a CEO, world leader, or anybody else at the top of a giant food chain. I prefer being a nobody in the shadows.

A fitting example of this I saw a few years ago in a nature documentary. It was documenting a group of monkeys. The monkey society was organized by dominant males ruling a harem of about 20 females. One dominant male was followed for years in its day-to-day activities which pretty much consisted of keeping the females happy and fighting of any challengers to its rule.

Until the day when the male got too old to do so, and a young male kicked his ass, ending his rule. From absolute power to zero, in one minute. And you know what happened? Rather than depressed by its defeat, the old male seemed to be celebrating, visibly relieved. Because dominance is stressful, tiring, relentless and not at all as awesome as you may think it to be. I believe I even saw the old male laughing at the young new ruler: oh boy, if only you’d know. Well no, I made that part up.

The point? Google is the red ass monkey. Being at the top of this giant food chain has all the downsides discussed. Rather than a comfortable stronghold, it’s a position of stress, risk, high stakes and volatility. An abuse of power can lead to competitors stepping in the gap, massive revolts of users, billions lost, enormous legal claims, and more. A single technical innovation can wipe out enormous parts of your business. It is an inevitability that no power lasts forever, it has never done so, ever.

Rather than being afraid of Google for its dominance, it is in fact Google that should be afraid. Because once you win, you can’t go up, and everybody wants you to go down. We’re just waiting, whilst you face all the downsides of being a winner.

If I were more intelligent and qualified to be a browser engineer, I’d be absolutely terrified to work on Chromium, the “winner”. I’d be totally relaxed, optimistic and laughing when working on Firefox, the “loser”. It’s the difference between having everything to lose with the whole world watching, and having nothing to lose and everything to win, with nobody watching. It is the difference between the highly stressful task of trying to keep a container ship running on which everything depends and having the freedom of thought to invent a wildly cool new speed boat.

How is this good for us? Google comes across as a rational and intelligent company and I expect them to realize how fragile their position really is. If so, it is a powerful safeguard against actions that are too hostile to the web. They simply can’t afford to. The previous one that tried, Microsoft, has been decimated. It only takes time. A mistake. Being too arrogant. Doing too many wrongs. One lawsuit. Power never lasts, and that is a good thing.

So instead of freaking out about this dominance, let’s instead sit back, relax and grab some popcorn. The pressure isn’t on us. The web cannot be killed or uninstalled and in the long term, truly isn’t owned by anybody, it’s a temporary illusion at best.

### The opposition is down, but alive

The biggest victim of this round of browser wars is Firefox. As discussed in the previous article, they’re in deep trouble. Near-zero presence on mobile, and a declining market share on desktop that without intervention is heading towards dangerous territories.

What message of hope can be distilled from this disaster? There’s a few I can think of:

*   Whereas part of the desktop loss is due to Chrome being aggressively pushed (combined with Chrome being a great browser), another part of the loss may be due to Mozilla’s neglect of the desktop browser during the Firefox OS years. Another reason could be a series of painful changes to the UI and web extensions. The point here is that there is a sizable audience that can be regained, and isn’t lost forever. I’m talking a few percentage points here. Which doesn’t mean dominance, it still means dozens of millions of users.
*   Maybe WebRenderer really is as unique and awesome as I dream it to be. And maybe some major player builds a game or other killer app which will let it shine, whilst Chromium can’t run it ever. Maybe a technically superior browser does matter, if only the right application exists for it that people love or find important.
*   We live in privacy aware times. The party of unlimited data harvesting is largely over or past its peak. Whilst the general public doesn’t seem to care that much yet in terms of which technology they use, it doesn’t mean this state of indifference is forever. It just takes the right push of buttons to set big things in motion, like the butterfly causing a hurricane. Beneficiaries would be Firefox and mobile Safari.
*   Maybe some major Android manufacturer is tired of Google’s abusive shit and says to hell with it: I’m shipping Firefox to the home screen. Could happen any day, as the relation between Google and Android manufacturers is dual: allies as well as competitors. Firefox mobile can’t go down much, but it can go up a lot.

I’m making up all of these scenarios. Each one may be highly unlikely to happen but for **any** unlikely event to happen, is highly likely. Unlikely things happen all the time, we don’t know which or when, but they will happen.

The young monkeys are waiting, and they are patient. Their time will come.

### Wrapping up

I’m thinking I’m not that good in writing positive articles after all, but let me try to wrap up why I believe the situation of Chromium as the dominant engine to run the web isn’t as bad or depressing as my previous article suggested:

*   To users, the web will work. Almost every user will experience websites the way they were intended to be experienced. Users will experience a rapidly improving web by means of their engine constantly updated, instead of being tied in to some OS (except for iOS users, who are on a slower pace)
*   To developers, one engine less means a simpler workflow. The dominant engine, Chromium, is also a really great if not the best engine. With almost every web user on a great engine and by targeting web features smartly, you can even drastically simplify your workflow.
*   As for standards, Chromium incompatibilities or vendor prefixes are largely a thing of the past and there is a strong disincentive to introduce new incompatibilities (because of mobile Safari). Furthermore, Google has no track record or incentive to sabotage web standards from moving forward, the opposite is true. The open web and web standards are not dead, they could even thrive. Chromium moves fast and it being the leading engine deployed to almost every user, means the web as a whole moves fast.
*   Google may incidentally put its own interests overall general interests, yet it is unlikely to do so at Chromium level. As discussed, this is more likely to happen outside of Chromium, at other properties they own.
*   Power is temporary, even more so in the tech industry. The competition is down but never asleep, and this provides a strong incentive for our overlord to behave, if not for the army of people caring about the web with powerful ways to speak up.

In 2019, there’s no reason to be depressed about the state of the web, even if it’s not in an ideal state.

Web technology is more capable than ever, and will continue to evolve rapidly. There is no sign of anything slowing down. Web technology will be more compatible than before, and users will experience a compatible web no matter their browser.

The ever improving web will inevitably lead to a sustainable web app platform that once robust enough, will break the chains of walled native app gardens. It’s an inevitable path forward that can be slowed down, but not stopped. Rather than reduced, the web’s role in computing will grow again at the cost of proprietary solutions.

The web will continue to evolve based on web standards, discussed in the open. The latest, standards-based web tech instantly deployed to almost every user, may ultimately make web development a whole lot simpler, bringing in new creators.

Is it perfect? No. But there’s lots to be excited about. Look past the mono-culture to see that compared to multiple incompatible engines with heavy feature disparity, we may be in for quite a ride of web awesomeness.

With that, I wish you happy holidays.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
