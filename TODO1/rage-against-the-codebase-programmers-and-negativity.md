> * 原文地址：[Rage Against the Codebase: Programmers and Negativity](https://medium.com/@way/rage-against-the-codebase-programmers-and-negativity-d7d6b968e5f3)
> * 原文作者：[Way Spurr-Chen](https://medium.com/@way)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/rage-against-the-codebase-programmers-and-negativity.md](https://github.com/xitu/gold-miner/blob/master/TODO1/rage-against-the-codebase-programmers-and-negativity.md)
> * 译者：
> * 校对者：

# Rage Against the Codebase: Programmers and Negativity

![how could they have done this to us](https://cdn-images-1.medium.com/max/2800/0*txg_xQ7yZ5ucNocs)

**(This article has been translated into [Russian](https://habr.com/ru/company/mailru/blog/448956/) and [Spanish](http://blog.pabloreyes.es/personal/programadores-negatividad/), with much thanks to the translators.)**

I’m staring at a block of code. It is, arguably, some of the worst code I’ve ever seen. In order to update a single record in a database, it fetches every record in the collection, and then sends an update request **for every single record** in the database — not just the record that needs updating. There’s a map function that does nothing but return the value it was passed. There are conditional checks for variations of seemingly the same values, named in different case styles (`firstName` and `first_name`). For every update (on every record, even the ones that haven’t changed) it sends a message to a message bus that calls another serverless function that does all the work for another collection in the same database. Did I forget to mention that this is one serverless function in a cloud “service”-oriented “architecture” of over 100 functions per environment?

How could anyone do this? I bury my eyes into my fists and laugh-weep audibly. My coworkers ask me what’s wrong and I give a dramatic retelling of the Worst Hits Of BulkDataImporter.js 2018, courtesy of Chuck Parsley*. Everyone nods sympathetically and we agree: how could they have done this to us?

## Negativity: programming culture’s emotional tool

Negativity plays an important role in programming. It’s embedded into our culture at various levels as a way to share learnings and war stories (“you won’t **believe** what that codebase was like”), express and commiserate over frustrations (“for the love of Hermes WHY would anyone do that”), making ourselves look better (“I would never do **that**”), shifting blame (“we failed because of Chuck Parsley’s unmaintainable code”), or in the most toxic organizations, a way to shame and control others (“what were you thinking? fix it”).

![via [ProgrammerHumor](https://www.reddit.com/r/ProgrammerHumor/comments/b4jfr7/i_cant_be_the_only_one/)](https://cdn-images-1.medium.com/max/2000/0*pa37xHLBNNcqhOrg)

Negativity is so important to programmers because it’s a very effective way to communicate value. When I taught at a coding bootcamp, it was standard practice to inculcate students into industry culture with a healthy dose of memes, stories, and videos, some of the most popular of which revolve around [programmers’ frustration with people who just don’t get it](https://www.youtube.com/watch?v=BKorP55Aqvg). It’s good to be able to use emotive tools to point to practices and habits that are Good, ones that are Bad, and ones that are Awful, Never Do That, Ever. It’s also good to prepare newer programmers for the fact that they will probably be misunderstood in one way or another by nontechnical colleagues, that they should prepare for all of their friends to tell them their “million” dollar app ideas, that they should prepare for unending mazes of legacy code with more than one minotaur waiting around the corner.

When we’re first learning to code, our model of what the depth of the “coding experience” is is based off of observing other people’s emotional reactions to the act. You can see this pretty clearly by watching [ProgrammerHumor subreddit](https://www.reddit.com/r/programmerhumor) for a while, which is populated by many newer programmers. Many posts express humor with various shades of negativity: frustration, pessimism, outrage, disillusionment, condescension, and more. (And if you really want to find the negativity, read the comments.)

![source: [ProgrammerHumor](https://www.reddit.com/r/ProgrammerHumor/comments/b7mlgt/programmers_d/), also [Twitter](https://twitter.com/type__error/status/1111972689609138177), the home of rage](https://cdn-images-1.medium.com/max/2000/0*jpOE1g8Udhv_0WRk)

I notice that programmers often follow an upward curve of negativity as they gain experience. Fresh and new, unknowing of what difficulties await them, they start out with enthusiasm and a willingness to believe that the reason things are hard is just because they’re inexperienced and don’t know anything and they’ll eventually have a grasp of it all.

As time goes on and they learn more, they gain the ability to differentiate between code that is Good and code that is Bad. Once this happens, they directly experience the frustration of working with bad code that they know is bad, and if they work in a community (whether online or in a team), they frequently adopt the emotional habits of programmers more senior to them. Frequently, this results in an increase in negativity, as they’re now able to talk intelligently about code and separate good from bad in a way that shows that they “get it”. It pays to be more negative: it’s easy to bond with coworkers over frustrations and become part of the in-group, it increases your status by decreasing the status of the Bad code in comparison, and it can help you be perceived as a better engineer: [people who express opinions negatively are frequently viewed as both more intelligent and more competent](https://www.wired.com/2014/11/be-mean-online/).

This increase in negativity isn’t necessarily a bad thing. Discourse about programming is, above all things, extremely focused on the **quality** of the code written. What the code actually **is** determines everything about the function that it’s designed to do (handwaving away hardware, networks, etc.), so being able to express an opinion about code is important. Almost all discussion of code comes down to a decision about whether it’s good enough or not, and the judgment of bad code manifests itself in a statement whose emotive charge implies the quality (or lack thereof) of the code:

* “That module has many logical inconsistencies and is a good candidate for significant performance optimizations”
* “That module is pretty bad, we should refactor it”
* “That module makes no sense, it needs to be rewritten”
* “That module sucks, it needs to be patched up”
* “That module is a piece of shit and should never have been written, what the fuck was Parsley thinking”

(Incidentally, this “emotive charge” is what leads developers to call code “sexy”, which is rarely deserved — unless you work at PornHub.)

The issue, of course, is that human beings are weird, wiggly little water-filled emotion sacks and both receiving **and** expressing any emotion changes us — microscopically at first, and over the long run, fundamentally.

## The wiggly watery slippery slope of negativity

A few years ago I was an informal team lead, interviewing a developer for my company. We liked him a lot; he was sharp, asked good questions, had the technical chops, and he was a great culture fit. I particularly liked how positive and how much of a “go-getter” he seemed to be. So we hired him.

At this time, I had been at my company for a couple years and had perceived a lack of follow-through in the company culture. We tried to launch a product twice, thrice, and and a couple more times before I had arrived, leading to expensive rewrites with nothing to show for it but many long nights, punted deadlines, and kind-of-working products. While I still showed up and worked hard, I was vocal about my skepticism about the latest deadline handed down from management. I swore casually when discussing certain unfavorites in the code with my colleagues.

I shouldn’t have been surprised — but I was — when a few weeks in, the new developer we had hired expressed the same type of negativity I had (including the cussing). I got the feeling that this wasn’t how he would act on his own or in another company with a different culture. Rather, he was adopting the culture **that I had set** in order to fit in. I felt a pang of guilt. Because of my own subjective experience, I managed to set a pessimistic tone for a new employee who I perceived to be very much **not** that way. Even if it wasn’t a sentiment he really believed, and only expressed himself that way in an attempt to show that he could fit in with his peers, I had pushed my shitty attitude onto him. And things said, even in jest or to get along, have a bad habit of becoming things believed.

![original source: [Nedroid](https://nedroidcomics.tumblr.com/post/41879001445/the-internet)](https://cdn-images-1.medium.com/max/2000/1*GIkVcbGg5anbC_ONap_1FA.png)

## The paths of negativity

A happy story for our now-intermediate developer from before who has gained a little wisdom and a little experience goes like this: they get to see more of the programming industry, and realize that bad code is everywhere and inescapable. Bad code exists in even the most cutting edge, quality-focused companies. (And let me tell you — modernity is not always the antidote to bad code it often seems like.)

Going into the future, they begin to accept that bad code is simply a reality of software, and it’s their job to make it better. Since there’s no escaping bad code, there’s not much point to making a fuss about it, either. They approach the path of zen, focus on how to solve the problem or task put before them, learn how to accurately measure and convey the quality of software to business stakeholders, create beautifully described estimates from their many years of experience, and end up being rewarded handsomely for their incredible and consistent value to the business. They do such a good job that they’re awarded a $10 million spot bonus and they retire to do whatever they want for the rest of their life. (Please don’t take this from me.)

![something like that](https://cdn-images-1.medium.com/max/2000/1*TeH2pZNcdmMlT8QyDsSWXg.png)

The flip side is the path of darkness. Instead of accepting that bad code is an inevitability, they take up the mantle of proclaiming all that is wrong with the world of code so that they might vanquish it. They refuse to normalize the existence bad code for a lot of good reasons: people should know better and be less stupid; it’s offensive; it’s bad for the business; this is proof of how smart I am; if I don’t express just how shit this code is this entire company is going to detach from the country and sink into the ocean; etc.

Likely in a position where they are unable to make the changes they desire because the business unfortunately must continue developing features and doesn’t have time to care about code **quality**, they become known as the complainer. Because they’re still highly competent, they’re kept around, but relegated to a corner of the company where they won’t bother too many people but will keep critical systems running. Cut off from access to fresh development opportunities, their skills atrophy and they lose relevancy in the industry. Their negativity festers and curdles into a hardened bitterness until they eventually find themselves sustaining their ego by arguing with 20-year-old CS students about the way that their favorite years-old technology did it and why it’s still the way to go. Eventually, they retire and spend their old age yelling at birds.

Reality probably sits somewhere between these two extremes.

A few companies do exceedingly well with extremely negative, territorial, forceful cultures, such as Microsoft before its [lost decade](https://www.vanityfair.com/news/business/2012/08/microsoft-lost-mojo-steve-ballmer) — often those with an existing product with an excellent market fit and the need to scale as quickly as possible, or command-and-control structures (Apple during Steve Jobs’ heyday) where everybody does what one person says so how they say it doesn’t matter much. However, modern business studies (and now, common sense) show over and over that the peak creativity that leads to innovation on the large scale and high performance on the small scale require low levels of stress that enable flow, creative thinking, and methodical thinking. It is extremely difficult to do linguistically-driven, creative work when you’re worried about what your colleague will have to say about every line of code you write.

## Negativity in engineering “pop” culture

Today, a greater spotlight is being shone on engineer’s attitudes than ever. The idea of a [“No Asshole Rule”](https://www.amazon.com/Asshole-Rule-Civilized-Workplace-Surviving/dp/1600245854) is increasingly common in engineering organizations. More and more anecdotes pop up in the Twittersphere with accounts of people leaving engineering entirely because they simply couldn’t (wouldn’t) put up with the hostility and territorial attitudes toward outsiders. Even Linus Torvalds [recently apologized](https://arstechnica.com/gadgets/2018/09/linus-torvalds-apologizes-for-years-of-being-a-jerk-takes-time-off-to-learn-empathy/) for his years of hostility and berating of other Linux developers — to much debate over its effectiveness.

> Our world of code will become increasingly exposed to the interpersonal styles of people who did not grow up in the isolated nerd culture of the early tech boom, and eventually they will become the new world of code.

Some still uphold Linus’ now discarded right to be excessively critical — someone who should know quite a bit about the pros and cons of toxic negativity. It’s true that correctness is incredibly important (fundamental, even), but when you boil down many people’s reasons for allowing the expression of a negative opinion to fall into toxicity, they begin to sound paternalistic or adolescent: they deserve it for being stupid, he needs to make sure they don’t do it again, if they didn’t do that he wouldn’t have to yell at them, etc. (For another example of how much of an impact the emotive tendencies of a leader has on a programming community, we can look at the MINASWAN refrain of the Ruby community —“Matz [the creator of Ruby] is nice so we are nice”.)

I’ve found that the most ardent promoters of a “kill the fool” mentality are often those who care deeply about the quality and correctness of code, and hang their identities on their work. Unfortunately, they often confuse firmness with harshness. The darkest side of this attitude comes from the completely human but unproductive desire to feel superior to others. The people who retreat into this desire are the ones who tend to stay stuck on the path of darkness.

![source: [ProgrammerHumor](https://www.reddit.com/r/ProgrammerHumor/comments/bcb4w3/a_meme_i_had_in_the_back_of_my_mind_for_a_while/)](https://cdn-images-1.medium.com/max/2000/0*nlR4DmkDp0WRnV4h.png)

The world of code is quickly expanding to meet the edges of its container, the world of noncode. (Or is the world of code the container for the world of noncode? A question for another time.)

As our industry grows at an increasingly rapid pace and programming becomes more and more accessible, the distance between “techie” and “normie” is shrinking quickly. Our world of code will become increasingly exposed to the interpersonal styles of people who did not grow up in the isolated nerd culture of the early tech boom, and eventually they will **become** the new world of code. And regardless of any social or generational argument, efficiency in the name of capitalism will show itself in company culture and hiring practices: the best businesses simply will not hire those who cannot play neutrally with others, let alone play nice.

## What I’ve learned about negativity

Letting excessive negativity dominate your mindset and communication and spilling over into toxicity is dangerous to productive teams and expensive for businesses. I can’t tell you the number of software projects that I have seen (and heard of) get torn down and completely rebuilt at great cost because one trusted software developer had an axe to grind with a technology, a former developer, or a single file they took to be representative of the quality of the entire codebase. It’s also demoralizing and strains relationships. I’ll never forget an incident where I was berated by a coworker for putting CSS in the wrong file, which upset me and distracted my thoughts for days. I’m also very unlikely to ever let that person near one of my teams in the future. (But who knows? People change.)

It’s also [literally bad for your health](https://medium.com/the-mission/how-complaining-rewires-your-brain-for-negativity-96c67406a2a).

![what I imagine a smiling workshop looks like](https://cdn-images-1.medium.com/max/2000/0*P7DjTZk4qoRsoIhG.jpg)

This isn’t an argument for sunshine and rainbows attitudes, ten billion emojis on every pull request, or smiling workshops. (Of course, if that’s how you want to roll, go for it.) Negativity plays an extremely important part in programming (and human life) as a way to signal quality, to express our feelings, and to commiserate with our fellow human beings. It’s a signal of discernment and judiciousness or the severity of a problem. I can often tell that a developer has reached a new level when they begin to express disbelief where before they had been timid and unsure. They’re demonstrating their discernment, and their confidence in their own opinions. Negative expression cannot be discarded — that would be Orwellian.

However, it should be dosed with other essential human qualities: compassion, patience, understatement, and humor. And where necessary, you can always tell someone when they screwed up, without the screaming and cursing. (Don’t underestimate this; being told you seriously messed up in a completely unemotional way is a frightening experience.)

At that company from a few years ago, the CEO grabbed me for a chat. We made small talk and discussed the current state of the project for a while, then he asked me how I thought I was doing. I told him that I thought I was doing pretty well, we were making progress on the project, we were plugging along, there were probably some things I was missing and needed to renew my focus on. He told me that he had heard me sharing some of my more pessimistic thoughts around the office, and that other people had noticed it as well. He explained that if I have concerns, I can push those up to management as much as I want but to be careful not to push them down. As a leading engineer at the company, I had to be mindful of the impact my words have on others, because I wield a lot of influence, whether I realize it or not. He said all of this very kindly, and ended by saying that if I’m feeling this way, I should probably think about what I want for myself and my career. It was an extremely gentle “shape up or ship out” conversation. I thanked him for letting me know and acknowledged that my attitude had slipped over the last six months without my noticing how it might be affecting others.

> Ultimately, I’m here to accomplish a task, and I don’t have to complain about code in order to understand it, estimate it, or fix it.

It was an example of excellent, effective management and the power of a gentle touch. I realized that while I had thought I believed fully in the company and its ability to accomplish its goals, in reality I was saying and communicating to others something very different. I also realized that just because I felt skeptical about the project I was working on, that didn’t mean that I needed to express that feeling to my coworkers and spread my pessimism like a contagion, making it even less likely for us to succeed. Instead, I could aggressively communicate reality up to my managers. And if I ultimately felt that they weren’t listening, I could express my dissent with my feet.

A new opportunity eventually found me, where I got to work in an official HR-performance-evaluating manager role. As a formal engineering manager, I’m increasingly careful to monitor how I express my opinions about our (constantly improving) legacy code. To enact change, you must acknowledge the reality of the current situation, but you get nowhere if you get mired down in the bemoaning, belaboring, or bewhatevering the situation. Ultimately, I’m here to accomplish a task, and I don’t have to complain about code in order to understand it, estimate it, or fix it.

In fact, the more I restrained my emotional reaction to code, the clearer my vision of what it could be become, and the less inner turmoil I experienced. When I practiced understatement (“there might be opportunities for improvement here”), I amused myself and others and took the situation less personally. I also realized that I could defuse and uplift other’s negativity by being perfectly (annoyingly?) sensible (“you’re right, that code **is** pretty bad, but we’ll improve it”). I’m excited to see how far along I can travel the path of zen.

Fundamentally, I’m continually learning and relearning a deeper lesson: life is just too short to be pissed off and miserable all the time.

![source: [xkcd #1024](https://xkcd.com/1024/)](https://miro.medium.com/max/533/0*5-f0--cc80oJF26i.png)

P.S.: If you like this post, clap it. (That doesn’t sound weird.) And if you’d like to check out where I’m attempting the path of negativity zen, [my company is hiring](https://www.volusion.com/careers).

—

***Chuck Parsley is not a real person. If you are, I apologize, and I am sure you are a fantastic programmer, or at least have the aptitude to be one. And if not, that’s OK. Live your life.**

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
