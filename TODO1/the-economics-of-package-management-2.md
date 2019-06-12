> * 原文地址：[The economics of package management](https://github.com/ceejbot/economics-of-package-management/blob/master/essay.md)
> * 原文作者：[ceejbot](https://github.com/ceejbot)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/the-economics-of-package-management-2.md](https://github.com/xitu/gold-miner/blob/master/TODO1/the-economics-of-package-management-2.md)
> * 译者：
> * 校对者：

# The economics of package management - 下半部分

> 如果你还没读过本系列的上半部分，请先阅读：
> 
> * [The economics of package management - 上半部分](https://github.com/xitu/gold-miner/blob/master/TODO1/the-economics-of-package-management-1.md)

For us, in the Javascript community, our commons includes the language spec itself. That's owned by an organization set up to allow all Javascript's stakeholders to cooperate to design and build it. TC39 has done pretty well by Javascript.

Another thing our commons includes is all our shared code. The source code for Babel, the source code for webpack, the source code for TypeScript, for React, for Angular— these and thousands of other packages make up our commons. The _registry that lists all of this shared code_ is also part of our commons. It’s how we share all that stuff with each other, how we find it. Another thing that’s part of our commons is the set of conventions we've evolved around that -- the ways we agree to name and update the things we share.

But all of _that_ is wholly owned by a VC-funded private company.

Last year at this conference, Ryan Dahl, the inventor of node, came back to make another announcement. He talked about [design mistakes](~~https://tinyclouds.org/jsconf2018.pdf~~) he thought he’d made with node. Here's one.

> It’s unfortunate that there is a centralized (privately controlled even) repository for modules. --Ryan Dahl

When I first saw that, I was inclined to argue with Dahl about centralization, but I had to agree with his comment about private control.

Let's talk about that for a moment. The list of shared Javascript packages we all made to share with each other is under private control. What does that mean?

Policies for managing that list are controlled by a single company, not by the Javascript community. What gets a package removed? How are disputes among people using package names resolved? This is a controversial topic! Remember left-pad?

That was an incident where a package that was a dependency of a dependency vanished from the registry suddenly, breaking every CI build that depended on installing babel. Why did left-pad suddenly vanish? Buy me a drink and I'll tell you! But the unpublication policy didn't exist before this fight, and it's both making your life better and worse daily.

Want package signing? Good luck! That feature doesn't make the company money, so you are unlikely to see it. Perhaps fear of a security incident, or major public outcry would get this done.

Note here that I’m talking about the _package registry_ almost exclusively here. The registry is closed source, and the policies that regulate it are not open to our influence. The npm cli is open source, but it is unimportant. The API is open, for now, and the important building blocks you would need for writing your own cli are all open-source and not under npm’s control. About a third of you use another client to interact with npm, anyway. You can tell the cli doesn't matter because they seek out community participation in it.

The API is open because the company chooses to allow it to be open. You don't have any control over that. You also can't influence that API and get changes that the ecosystem might benefit from.

The management of your commons is opaque to you. It will remain opaque to you until the company that owns it has a financial incentive to change that. You do not know what it's doing with your package data-- you cannot know. You have to trust it.

There can be no trust without accountability, and we as the Javascript community have no way to hold npm Inc accountable.

Now, when I was there, I could tell myself that I trusted myself and my team, and I knew our motivations were good. This was not a good answer and I was wrong to have relied on it.  You had no way to hold _me_ accountable and to test that I was trustworthy.

Whoops.

So npm Inc is a private entity in control of our commons, and we are not. Does that make it evil? No. It doesn’t. It doesn’t make it good, either. The question of its benevolence is the wrong question to ask.

npm is not a benevolent institution. It *cannot* be one. The possibility of it being that ended the day its owner took VC funding instead of putting it into a foundation or some other form of community ownership. That decision turned npm into a *financial instrument*.

I mean something very specific when I say that.

Financial instruments are monetary contracts between parties. They're widgets that can be created and traded. npm Inc the company— the thing that owns our language ecosystem, the thing that owns the registry of packages, the collection of software packaged as the cli you use every day— that is a thing that might as well be a collection of pork bellies as far as its owners are concerned. They make contracts with each other and trade bits of it around.

npm-the-company is a means for turning some money into more money for the people who own it.

It’s important to keep this in mind as you evaluate all your interactions with it, and as you evaluate all your interactions with the people who represent it. What this means is *look at incentives*. Money turns out to be the incentive for a lot of people in this story.

Follow the money.

Companies don’t love you, not even ones that make things you like.

That phrase is a marketing message, designed to get you to mistake the financial instrument for something that might be your friend. That marketing message has been pretty powerful over the years, hasn't it? You've got a cuddly wombat mascot and awesome stickers. Add a red emoji heart and you're on board, right?

npm does not love you. npm cannot love you. npm Inc is a Delaware corporation founded as a financial instrument intended to turn money into more money for a handful of men.

When I initially knew I wanted to start talking about this problem in public, instead of in corners with friends, I thought I’d be fighting an uphill battle. The VC-funded package management company was beloved, and my work was one of the reasons why. I had participated in this whole rise to prominence— I made it possible. I stood on stage in front of you all and parroted that marketing message. What I meant by it was, "I, C J Silverio, feel affection for you all," and that was true.

Now I don't think anybody can stand up in front of you and say "npm loves you" without being yelled at. npm has burned all of its goodwill over the last few months. It didn't have to happen-- it was a choice made by the people who run the company. They made that choice, though, and they doubled-down on it, and here we are.

How did that happen? Why did the cuddly wombat get set on fire? Let's move our story forward, shall we?

We pick up in, oh, I don’t know, 2018. You all have been drinking from the firehose of Javascript packages which have been, for you, free. You do not think about or care about where they come from, or who is paying for the servers. You just type `install` and the packages arrive.

But the bandwidth costs money, and somebody pays for it.

In this case, npm had been spending the dollars given to it by its venture capital investors to pay for the servers and the bandwidth. And eventually the inevitable consequences of taking VC money started to knock on the door and clear their throats. *Ahem. Remember us? We want our money.* We've established that VC-funded companies are financial instruments. They have to start making that famous 10x return on investment. They have to promise somehow that their owners are going to end up winners. This isn’t always about being profitable, but if you don’t manage to do that you have to tell a persuasive enough story that you can raise more money and keep the scheme going.

There is absolutely nothing wrong with taking VC money inherently, in my opinion. Many ventures have goals well-aligned with the goals of VC money, and not all VC money is shaped alike. Some funds play long games. Funds like Futureshape are explicitly interested in bettering the world. But mostly, VC money is interested in returning the investment.  That’s where the incentives point: make money, be sold to new owners for enough money to return the investment ten times over. Grow fast. Go big or go home.

Remember that npm Inc’s obligations are to the people who own it, not the people who donated their work toward its dragon hoard of packages.

So npm Inc has to make money, or failing that tell a story about making more money so it can raise money to spend on making money.

The ex-Yahoo employee who thought that sharing the Yahoo package manager with the world was a pretty neat idea was right about that, but he didn’t have many ideas beyond that, and it turns out running companies is a lot of work. So in 2018 he hired a new CEO to do that work for him, and well, here we go. The first thing this new CEO wanted to do was change npm’s culture— you know, the thing it had exported as its marketing message. The sustainable, compassionate culture was the first thing to go when this new guy arrived.

npm’s PR troubles as a result are probably known to you now. We’re a community that enjoys our drama. It's possible that if a saint were in charge, I wouldn't be standing here. But maybe I would be, because even a decent human being in that spot has a big problem to solve.

Here’s the problem.

The public registry — the place where all your packages are indexed and stored— that’s the part you care about. That’s the part that is an enormous drain on npm’s budget _and_ simultaneously its value to investors. It controls all Javascript development, because all Javascript development proxies through it willingly. That data — the data gathered from your usage of it— is the valuable part. Every package-lock file npm has ever seen is sitting in an s3 bucket somewhere, chock-full of interesting data nuggets about what you've been up to. It’s also a perverse incentive influencing API design. The company has no incentive to reduce the number of times a client has to phone home when installing, because those calls homeward generate valuable data.

The registry is a drain on npm. The work of keeping up with continuous near-exponential growth is itself continuous. During my time there this work occupied most of a very tiny engineering team. Why was the team tiny? Well, npm had no money because it did a pretty bad job of telling its story to new investors and raising more money. Or the story it had to tell was just bad and potential investors knew that. I’m not sure which it was. But either way, npm had enough money to keep the free Javascript flowing to you, but not to make decent products to sell. Eventually the VC bill was going to come due. Eventually they’d have to show growth or die.

Follow the money.

So we’re in this situation we’re in now, where npm Inc hasn’t fully had its reckoning with its true destiny as a way to make money for some people who aren’t Javascript programmers.  Maybe it's going to show growth. Maybe it's going to die. Maybe it's going to do something none of us like to make money, leveraging that enormous data trove that is their view of the development habits of every single one of you.

We are all aware now that npm doesn't love us, and it doesn't love its employees either. It has no more good will from us, but we are all still installing packages through it. I,  for one, find this situation uneasy. I suspect it won't last very long.

Our story didn't have to go this way. Our major actors could have chosen differently, right up to and including their choices in recent months. But here we are. Our commons are in the hands of something I do not believe we can trust, because its incentives are not aligned with what we, as a community of Javascript programmers, need from it.

What are we going to do about it?

One answer is, we do nothing. Say we can't do anything. We made our community decision in 2013 and we're stuck with it. We wait for npm Inc to fail and when it does, we have a nasty couple of months replacing the registry.

I don’t much like this answer.

Imagine npm Inc in the hands of a corporate pirate, somebody who takes over ailing companies adversarially and shakes them down for change. Somebody like this might have no incentive to keep the public registry running, or might consider it something that can be mined for your usage data. We, npm’s users, are held hostage to the decisions of a board of directors that hasn't done a very good job thus far, so I find this scenario quite possible.

This is a more optimistic outcome. A larger corporate savior might swoop in and rescue npm, our beloved package registry, and keep our commons alive. But even if the registry ends up owned by a secure company, I think this merely punts the problem down the road. Microsoft is a benevolent actor today, but they sure haven't always been. Google was once a benevolent actor, but they're now acting exactly like the monopolist Microsoft was in the 90s.

I'd like us to avoid a repeat of this talk a decade from now.

I think, in the end, I agree with Ryan Dahl. Javascript's package registry should not be privately controlled. I think centralization is a burden that will inevitably lead toward private control, because, well, the servers always cost money. If we can diffuse the load out among many people, we can share the burden.

This probably sounds impossible to you all. You're thinking that npm is entrenched. A few months ago I might have agreed, but then the company set on fire every bit of goodwill it had ever had for no reason anybody can see, all the trust people like me had ever earned it as benevolent stewards. Just poof. Up in flames. They’re so bad at community, and values, and people, it looks intentional. [exasperated gesture]

Also, I’m not much a person for hand-wringing. The do-nothing answer doesn’t sit well with me as a human.

The other confession I’ll make is that I believe in the potlatch economy despite everything. I think it's good for us as humans to give things to each other, and I think I'm at peace with the idea that some corporations will make money from it.

So I have an announcement. I would like to give away something to you all today. And it’s not just me giving this away. My colleague Chris Dickinson and I have been working on this together.

Today I'd like to introduce you to entropic, a federated package manager for Javascript.

Entropic is Apache 2 licensed, and everything you need to run your own registry is included.

Entropic comes with its own cli, which we’re calling `ds` , the entropy delta,.

Entropic offers a new API for publication and for installation, one that drastically reduces the amount of network traffic needed. The unit of installation is a single file, not a tarball.

Entropic is federated. You can depend on packages from any other Entropic instance, and your home instance will mirror all your dependencies for you so you remain self-sufficient.

Entropic will mirror all packages you install from the legacy package manager.

The requirements list is short, and we’ve dockerized it all.

You sign in with your GitHub account, and any oauth provider is pluggable.

[ show a short video of a demo ]

The project is only a month old. It's not ready for anybody but people on the bleeding edge to use yet, but it's self-hosting already.

There are more features, and a fairly huge to-do list. It doesn’t have a web site to speak of right now, for instance, and it needs one. The repo has a long list of issues if you’re interested.

What are my goals with entropic?

First, I want to prove to you all that there are options beyond doing nothing. We don’t have to sit here and wait for npm to shut down before we do something. Be optimistic. Be pro-active. You have power.

Second, Chris and I are among a handful of humans who deeply understand the problems a language package registry needs to solve, particularly at scale. That expertise is needed by our community right now, and we want to share it. We choose to give something valuable away. Potlatch: this is our gift to you of our expertise.

Third, I think it’s right that the pendulum is swinging away from centralization and I want to lend my push to the swing. The last decade has been about consolidation and monolithic services, but the coming decade is going to be federated. Federation spreads out costs. It spreads out control. It spreads out policy-making. It hands control of your slice of our language ecosystem to you.

My hope is that by giving Entropic away, I’ll help us take our language commons back. We'll take it back so we’re not held hostage by the needs of venture capitalists. Take it back so it's possible for us all to make a decision different from the decision we all made at the end of 2013. Take it back. As a community of millions of developers, it's in our power to take it back. Entropic is our kick-start to this movement to take our language back.

There’s a lot more to say about Entropic, and a lot more work to do on it, but it’s time for me to share it with you.

If we’ve learned that npm doesn’t love you—and it doesn’t-- and we’ve learned that a private company shouldn’t control the commons—and it shouldn‘t, then it’s time to move with your feet. I believe the Node community is good, comprised of good people with the talent and the interest in building amazing things. We should not be defined by a single corporation, and we shouldn’t let them control our destiny when so much—the future of the web!—is at stake. We need to take back control, and to do that, we need to finish building Entropic, together.

With love from two human beings, from us to you. Please do something good with this.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
