> * 原文地址：[Revised Patterns for Participation in Standards Committees](https://medium.com/@jorydotcom/revised-patterns-for-participation-in-standards-committees-dae82d93954e)
> * 原文作者：[Jory Burson](https://medium.com/@jorydotcom)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/ECMA-TC39/Revised-Patterns-for-Participation-in-Standards-Committees.md](https://github.com/xitu/gold-miner/blob/master/article/ECMA-TC39/Revised-Patterns-for-Participation-in-Standards-Committees.md)
> * 译者：
> * 校对者：

# Revised Patterns for Participation in Standards Committees

![](https://miro.medium.com/max/1020/1*EnBeLnKvRHmiHvbivS4jzg.jpeg)

<small>*Image from Annual report of the Bureau of ethnology to the secretary of the Smithsonian Institution (1881)*</small>

I recently reread [Allen Wirfs-Brock’s](https://twitter.com/awbjs) paper, *[Programming Language Standardization: Patterns for Participation](http://pl.csie.ntut.edu.tw/asianplop2016/proceedings/A14.pdf)*, while preparing for an upcoming talk. Allen’s 20+ years of experience in language standards development, research and documentation is extremely valuable to the JavaScript community and can’t be understated. The paper is an academic approach to guidelines and patterns for those getting started in standards work; in order to make it a bit more actionable and modernize the language for our community, I’ve updated his guidelines below, along with some helpful tips to improve your standards-committee experience.

The nature of technical standards committees is such that users, implementers, and vendors are in the same room, often with conflicting needs or interests. [Alex Russell](https://twitter.com/slightlylate) does a fantastic job illustrating these tensions in web driven standards organizations in his two part series, *[Effective Standards Work](https://infrequently.org/2018/06/effective-standards-work-part-1-the-lay-of-the-land/)*. It’s important to remember that ultimately we’re all trying to “ship the right thing” — the challenge lies in gaining consensus about what that “right thing” is, and doing so in an inclusive and respectful way. These guidelines are about encouraging social activities that facilitate a professional (and personally rewarding) standards development process.

# Seek First to Understand…

**Be an active listener.** Allen’s guidance was to speak up only if you are sure you have something valuable to say, and I wholly agree that it’s time well spent for a newcomer to focus on listening and observing during one’s first meetings. However, I think it’s worth revising this guideline to convey that it’s absolutely, 100% ok to ask questions and get clarification if there’s something you don’t understand (at the appropriate time, of course). In order to ask questions, you have to really listen to what’s being said — both technically and contextually, and this is a great way to get a real feel for the group, too.

**Do your research**. This applies not only to specific proposals and ideas you may be interested in putting forward, but also to the organizations, individuals, and history of the group as a whole. Sometimes, this is easier said than done — documentation can be hard to find in a reflector or email group, or the people with real knowledge about something may have moved on. Ecma TC39 (and most all of the W3C working groups) have put a lot of this context online via GitHub, and are working to surface more organizational history for the community. If you stumble into an area where the history is not known, this could be a great opportunity to make a meaningful contribution by filling in the gap.

**Meet your team.** Allen advises “understanding the other players,” but I prefer to think of it as meeting and getting to know the rest of your new team. All technologies are products of their social environments, so the better you understand that social environment and can contribute positively to it, the more you help your cause. If you don’t know anyone else in the group, send and email and introduce yourself; share what brings you to the table. Invite someone to lunch or coffee. Attend or organize after-meeting events with your new peers. Get to know where they are coming from and what issues are most important to them. It’s easier to forge these connections in person — I highly recommend investing in a trip to attend one or more meetings a year if you can swing it.

# …Then Be Understood

**Be explicit about your objective.** If you’re trying to get a new feature implemented, come prepared with the clearly defined problem you’re trying to solve and any pertinent use cases. If your solution is well-formed enough, write the tests for it, too. Remember that, depending on where the language is in its lifecycle, real problems are going to be far more compelling than theoretical ones. As Allen notes, *“Development of a language standard is not a green-field development activity… A language standards committee exists to solve problems that arise from the current state of the language.”* So if your objective is to evolve a language a certain way — so it can be implemented on the blockchain, say — you’ll have to be patient! Conversely, if you’ve met your goals, it’s ok to move on to other things. Be purposeful.

**Be Open to Change**. Standards work, despite its reputation, is not about competitive arguing (I like to say that TC39 is not about “competitive JavaScripting”). Any two people in the group may solve the same problem different ways, but that doesn’t automatically make one of them wrong. In strategizing ways to get your feature implemented, Allen recommends “Finding Allies,” Picking your Battles,” and having a “Back-Pocket Alternative.” Working with others to develop ideas enriches your understanding of the problem and language, and helps you develop a sensitivity to what issues other organizations will care about (and thus might impact your proposal’s chances of success). This also helps you avoid arguments and debates that don’t matter in the given context. Another important strategy: being open to being wrong, and being willing to say as much. After all, *“Most ideas and designs aren’t good, and most of the ones we eventually accept don’t start good.”<sup>1</sup>* Fostering an environment wherein it is safe to propose, discuss, advance or withdraw ideas is essential for healthy technical dialogue — which requires all parties be willing to change their minds.

**Be a Contributor.** Both Allen and Alex share that, historically, the older the group, the harder it is for new people and ideas to enter that group. Fortunately, there’s a definite culture shift within these groups to open up to new ideas and ways of working.

> There are a lot of ways to start contributing to a standards effort that don’t involve writing technical proposals. In fact, this is often the most important and underserved area!

How you contribute to a standards effort should ultimately be a factor of your strengths, objectives, and the needs of the group. Here are some ways to be a great contributor and boost your credibility *without* writing new proposals:

- Volunteer to take notes at meetings.
- Organize or co-organize social events.
- Help with meeting planning.
- Contribute to other committee efforts, like writing documentation.
- Read proposals and provide critical feedback or use cases for them.
- Help edit or champion other proposals, or write tests for features or proposals.
- Help identify “prior art” and/or missing voices — are there examples that can be pulled, or people who can be consulted to help move something forward?

**Strive to Consensus.** Most web standards committees use a consensus model for decision-making, and how consensus is measured can vary from group to group, but it generally means that a supermajority<sup>2</sup> of the group supports the decision and the remainder is willing to accept the decision. Disagreement and debate is OK, and needed, but it must be professional and respectful. At some point as a delegate, you’ll have to decide if you should actively oppose a decision, but this should be a rare occurrence. Not every proposal will make it into the final specification — in fact, most won’t, and that’s a good thing.

The guidelines above apply whether you’re brand-new to standards development and looking to find your footing, or you’re an existing participant and want to increase the success of your current efforts. Any organization, committee or team operating a joint open source software project could benefit from these guidelines directly or with modifications to make it more appropriate for your team. Happy standards-making!

* <sup>1</sup>: Alex Russell in “[Threading the Needle](https://infrequently.org/2018/06/effective-standards-work-part-2-threading-the-needle/)”
* <sup>2</sup>: The definition of supermajority varies by organization. It usually requires two-thirds or more of votes cast to pass an issue.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
