> * 原文地址：[Imaginary problems, the root of bad software](https://medium.com/@george3d6/imaginary-problems-d4f2921bd1b8)
> * 原文作者：[George](https://medium.com/@george3d6?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/imaginary-problems.md](https://github.com/xitu/gold-miner/blob/master/TODO1/imaginary-problems.md)
> * 译者：
> * 校对者：

# Imaginary problems, the root of bad software

There are many factors which can be a catalyst for bad software, from the tools being used, to the quality of communication inside your team, to the personal stake developers have in its success, to the testing methodology you use.

I propose that there is one problem chief among them, an impetus for bad software from which almost all of the others take root: **imaginary problems**.

Most complicated or broken software is not designed to be overly complex or dysfunctional. It’s just designed to do something else than its intended purpose.

### The podcast app

Let’s say you are a podcast host and you want a custom website where you can sell your promotional products, make advertising money without a 3-rd party cutting in and, most importantly, deliver podcasts, videos and blog posts to your audience.

The requirements for your little webapp might have been:

*   Fast load time in North America and real-time podcast streaming and downloads.
*   Doesn’t crash or freeze in the first 15 minutes for 99.99% of users, preferably never crashes or freezes .
*   Integrates well with google adwords, maybe with some other  
    ad providers as well, if there’s time.
*   Dynamically links to the latest products on my Zazzle page, if possible, gives recommendations to users based on the episodes they watch.
*   Integrates with Facebook live player, since that’s how I stream my stuff. If it’s easy to create an alternative solution for streaming that doesn’t require Facebook, even better.

You give this to a team of contractors, and you chat about it a bit. After 2 months, they show you the MVP and your face turns red, you’ve just wasted 15,000$ on a piece of garbage, you want your money back.

It’s normal to get mad at this app, because the first time you open it the screen froze. You asked the guy how to select the type of ads allowed to run on the website… and he pointed you to an ugly and hard to understand custom UI. Half the links to your merchandise on Zazzle are broken or lack an image and the Facebook live stream is laggy !

But the dev team is confused at your anger, and rightfully so, from their point of view, they’ve gone to hell and back for you.

They’ve put their heart and soul into creating this app, it has some amazing features:

*   A state of the art recommender system.
*   An algorithm generating the transcript of all your streams, LIVE (for usage in the previously mentioned recommender).
*   Your front-page loads in sub 200ms times all over the world.
*   A streaming protocol and client build almost from scratch, in case you want to switch from Facebook live.
*   A service that allows you to easily integrate with over 20 ad exchanges.

The problem, is that you thought you requested a core product, with some extra features, if they were easy enough to implement. The dev team, however, heard something else. The dev team heard about some exciting challenges they could work on…. and a slew of boring, basic features they couldn’t be bothered to test properly or care about.

Even worse, you didn’t communicate directly with the devs, you communicated through a game of Chinese whispers. You spoke to a sales guy, which held a meeting with some middle management chap, which then wrote some business specs and gave them to a PM, which wrote some technical specs and gave them to a team lead/architect, which then started designing the product with his team. Every single one of them, put a bit of a twist on it.

### A coping mechanism

Imaginary problems are often more fun to solve than real ones. Extremely intelligent people play competitive games, construct and solve math problems and write books that try answering abstract questions about the human condition, all of them for free. A mediocre programmer, however, will probably charge you a fair amount to build a simple Android app for you. That’s not because mediocre programmers are harder to find than geniuses, but because the former activities are all fun, the later can be rather boring.

Most programmers want to get paid and have fun at the same time. However, for most people, this can be rather hard. Of course, the definition of “fun” is quite different for most of us, but for many engineers, it boils down to interesting and challenging problems that are within the realm of solvability.

Give a somewhat intelligent person too many boring tasks which are impossible to automate and you will sooner or later drive them mad. The human brain however, after billions of years of evolution, is quite talented at keeping its sanity. Much like victims of childhood hardship or abuse can find an escape in fantasy books, victims of enterprise programming or freelance web development can find their escape in solving imaginary problems.

![](https://cdn-images-1.medium.com/max/1000/1*8jPa3TYWKxx2PU5A87_4Xg.png)

The amount of imaginary problems a software engineer can create for themselves is a function of their imagination and the difficulty of the real problems they’re supposed to solve.

It should be noted, this issue isn’t unique to developers. Management, sales, HR, support, legal and even accounting have their own unique ways of creating imaginary problems. They try to involve themselves too much in a decision, when their presence at a meeting is just a formality or wasn’t requested at all. They overemphasize a minute problem that is related to their role (e.g: Our dog daycare app must be 101% GDPR compliant from day 1, we can’t wait for a legal precedent). They hire a much larger team than necessary, to feel like they are important and to work on the logistic challenges involved.

Many individuals are intelligent, but many problems are dumb, so intelligent individuals will find a **way of coping**.

### Chinese whispers driven design

But imaginary problems aren’t just the result of bored developers, they are also the result of long chains of communication.

I occasionally do freelance work, in the past I couldn’t afford to pick my clients, which means I saw my fair share of dissociative identity disorder and ADHD cases. I’ve had chains of 100+ emails discussing insignificant details about internal MVPs. I’ve had people change every single requirement on a project within the span of a week. I’ve had clients that asked questions such as “Could this be ICO-ed ?” or “Can we add some AI in here ?”.

Granted, most clients are saner than that, but they often lack a bit of the knowledge necessary to articulate or construct some of their requirements. That is fine, since part of my job as “the computer guy”, is to help people figure out what they need and don’t need in their software based on their usecases. But it can become much harder to do so when there’s a few layers between you and the client.

Most companies like having a sales guy that pitches potential customers, negotiates prices and outlines the features that could be included given said prices. They have a [people person](https://www.youtube.com/watch?v=hNuu9CpdjIo) discuss more in depth requirements and details with the customer, usually also a sales guy, but with a slightly different title, or a manger of sorts. Then there’s the internal facing chain of command, various levels of management and possibly some hierarchy within the technical team.

When requirements go through so many people, even if those people have the best of intentions, some things will get changed. Some things might get changed because they make no sense, they need to be redefined because the definition is stupid. The sales guy might have said “For only 39,999 extra we can do this on the Blockchain”… leaving everyone else down the line of define what the hell “doing it on the Blockchain” means.

Though more often than not, requirements get changed because someone either misunderstood something or because someone was using the aforementioned coping mechanism to make his job or the job of his team more interesting and impressive.

So the original requirements, the real problems that have to be solved, get lost in transcription. They are replaced with imaginary problems and with voids, and you’ve got plenty of people ready and willing to fill those voids with their own imaginary problems, because the problems they have to solve are boring, and filling the voids gives them a **way of coping**.

### Overcomplexity and natural selection

Often enough, there’s an even darker reason for the existence of imaginary problems, they help a team or a company grow and they become an integral part of its function.

> People who are bred, selected and compensated to find complicated solutions do not have an incentive to implement simplified ones. — Taleb

Have you ever heard about those three engineers that figured out online banking is actually quite an easy problem ? They developed some flawless banking software from scratch, using a functional design methodology and memory safe languages, then started migrating major banks to their amazing infrastructure.

Probably not, because they don’t exist. There are however, plenty of teams of [thousands of developers, that are unable to grasp simple concepts such “rollbacks”](https://www.theguardian.com/business/2018/apr/28/warning-signs-for-tsbs-it-meltdown-were-clear-a-year-ago-insider), perpetually creating banking software.

That’s not because the storage and transfer of numbers is a particularly hard problem. Indexing the whole content of the internet and providing relevant results to natural language queries from it, in sub second times, is a hard problem, [but just a few smart guys managed to solve it](https://en.wikipedia.org/wiki/History_of_Google).

No, the problems is that the banking ecosystem has become really good at keeping its drones alive. A well oiled machine meant to preserve its own money grabbing hierarchy. Its leaders are [corrupt leaches](https://en.wikipedia.org/wiki/Ben_Bernanke) that prey on society, but the leaders in an organizations are just a symptom of its members.

I wouldn’t suggest most underling working for banks are evil or malicious in any way. Far from it, they are usually friendly lads, working to provide food, shelter and an education for their families. But their chief incentive is not fixing the banking software, their chief incentive is staying employed. Losing your job in today’s economy is no joking matter for some… and a big mouth or too much initiative is an easy way find yourself in front of a disciplinary committee in the banking industry.

So banking remains the same not because it’s efficient, but because it has inertia. This inertia comes in the form of working on imaginary problems in order to avoid fixing real problems. Real problems which, once pointed out, would threaten the jobs of other people. Which may well lead to you getting fired, or in the case of some particularly nasty “institutions” like Goldman Sachs, [getting a few brown envelopes sent to a few FBI officers and ruining your whole life or getting you to commit a strange suicide.](https://en.wikipedia.org/wiki/Sergey_Aleynikov)

> **It is difficult to get a man to understand something, when his salary depends upon his not understanding it!** — Upton Sinclair

The C-suite ignores the fact that their upper management spends 90% of their time on “client meetings” that involve tropical islands and million dollar budgets for “other expenses”. Because upper management tuns a blind eye to their superior’s corruption.

The upper management ignores middle managers buying eccentric offices and hiring themselves three secretaries and a dozen interns. Because middle management encourages them to live in their Wolf of Wall Street fantasy.

Middle management ignores the fact that line managers spend their time working on power point presentations about “Improving our Agile methodology” instead of cutting costs. Because line management doesn’t complain about their little dictatorial power fantasy.

Line managers ignore the team leads and architects talking about “Next generation interfacing between our systems using JRPC and microserviceization using Hibernate and Spring”… instead of getting those bloody Mysql queries to take less than a day. Because the team leads don’t seem to notice the fact that their superiors can’t even use Excel properly and only hit the office every few weeks.

Team leads don’t complain about their developers re-designing the UI for the 10th time that year using a new JS framework, instead of looking at an EXPLAIN for the aforementioned slow query. Because the developers don’t seem to notice their leads don’t really write any code except DOT diagrams.

It’s a vicious cycle of solving imaginary problems, from the CEO that doesn’t realize stealing another 30 million won’t make his dad love him. To the UX intern that doesn’t realize redesigning the “submit” button using Angular-Material-Boostrap 19.13.5, won’t make the fact that they store passwords in plain text (and use them as part of the auth cookie) go away.

But everyone needs to keep solving the imaginary problems, because if they stop, if they start focusing on the real problems, they might realize the whole system is broken. They might realize Debra has been sitting in that corner, staring at uptime graphs of the internal server farm for 10 years, despite the fact the company moved to AWS 5 years ago. They might realize 99% of their job is to perpetuate the existence of someone else’s job… and that’s a hard realization to take in, an impossible one for most, I dare say, so they find a **way of coping**.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
