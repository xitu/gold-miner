> * 原文地址：[Monolith vs. Micro Frontends](https://blog.bitsrc.io/monolith-vs-micro-frontend-e6e9772a068b)
> * 原文作者：[Florian Rappl](https://medium.com/@FlorianRappl)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/monolith-vs-micro-frontend.md](https://github.com/xitu/gold-miner/blob/master/article/2020/monolith-vs-micro-frontend.md)
> * 译者：
> * 校对者：

# Monolith vs. Micro Frontends

Are you modern? Is your web app state of the art? Then you must be doing micro frontends! Quite **provocative** isn’t it?

![](https://cdn-images-1.medium.com/max/3840/1*YaRaJ3Sxh9KNcxMZsr7ofg.jpeg)

All the complexity. All the trouble. For what? Your frontend is outdated anyway in a couple of months and you should rather invest in reusable components. Nothing beats the monolith! Also a quite absolute and narrow perspective, right?

Good chance you either agree to the first or second paragraph. However, as always in software development the answer is somewhere in the middle:

> It depends!

Everyone who knows me knows that I’m a **big fan of a monolith**. Yes, I do a lot of development on micro frontends these days and I’ve even created a [neat framework called Piral](https://github.com/smapiot/piral) to help in creating large micro frontend solutions. But even here we are not blindly using it or advocating it without knowing that it fits to the problem.

## Reasons for a Monolith

Many people argue that the decision between monolith and micro frontends should be made based on the size of the app. I don’t necessarily feel that way. Sure, if the app is really small it potentially reduces the time for a rewrite to a level that makes everything else looks expensive and bloated. However, for me then real metric is the business perspective.

If the app is supposed to be rather static, not so frequently updated, and equipped with features that should be rolled out to everyone, then a monolith is a great choice.

The monolith is easy to develop, easy to deploy, and easy to test. At least when the monolith is small. This is, of course, nothing in particular to the monolith. Any kind of system is easy to understand when being small and dedicated to a single thing.

In short:

* consistency
* reliability
* performance

## Reasons for Micro Frontends

Micro frontends are supposed to be giant applications that can only be tamed by large enterprises. Well, while all of these properties support using micro frontends they are not necessary. Even a small application may benefit from micro frontends if it fits. For instance, we may have a landing page app that brings in some content that should be daily updated. Surely, we can connect this one to a backend, but then suddenly we need to maintain a lot of things. Just to publish one (potentially very custom) fragment. Instead, publishing it as a frontend artifact and consuming it directly may be the best solution.

One thing that larger applications fear is “legacy”. Having legacy code or not being able to use the latest and greatest tools makes a software project doomed to failure. Either by missing out critical updates or by failing to attract new developers. Micro frontends provide a nice way out of this by allowing fragments to be different regarding core technical choices.

![Micro frontends can outperform their monolithic ancestors — given the right problem statement.](https://cdn-images-1.medium.com/max/2000/1*iVLtTGNKeVjX3p2dmtPmRA.png)

A micro frontend solution is flexible in most regards. Consequently, it comes with various challenges as compared to the frontend. However, once these challenges (such as performance or consistency) are solved the solution is not necessarily more complex than their monolithic counterpart. Actually, the individual pieces (i.e., the true micro frontends) are much easier to understand and maintain. In fact, this decreases on-boarding time significantly, leading to a more developer friendly solution.

In short:

* scalability
* flexibility
* independence

## Alignments and Collaboration

So what team setup is best suited for each model? Well, obviously micro frontends **allow** more distributed teams, while a monolith requires a lot of alignment usually find in one central team that follows a strict hierarchy. Surely, there are exceptions to these extremes, but in most cases the truth is quite close to the naive assumption.

Depending on the actual architecture of the micro frontend application there may be one central team responsible for cross-cutting concerns and governance. The remaining teams could be considered satellite teams with sizes ranging from 1 to 5 developers depending on the feature scope. There is little to no alignment needed — even though at least some alignment coming from business owners or the central team may be desired. Every satellite team can work on their own schedule and release when they are ready.

![Different teams producing different artifacts.](https://cdn-images-1.medium.com/max/2000/1*TM5WFttKghAGLdcZ02sv2w.png)

In contrast, the monolith consists of either a single team or a large central team with some features being developed in smaller teams. However, in any case there will be alignment. There is a scenario where the additional teams are actually also fairly large and on their own process. This is where concepts like “nexus” or a “scrum of scrums” come in. Once we hear these terms appearing we know: Lots of alignment happening. Lots of meetings happening. Lots of efficiency lost.

![One large team producing a single application.](https://cdn-images-1.medium.com/max/2000/1*Sj8vdinS7TjOb48sb7-5qQ.png)

The loss of efficiency sounds like a disadvantage at first, but keep in mind that every application that matures will see a loss of development efficiency over time. This is quite natural and often even desired to some degree. After all, this means that real customers are using the product and that changes need to be well thought out and aligned. As usual, the question is therefore not “is there inefficiency”, but “how inefficient” the process is.

## Deployments

One of the most crucial points for either kind of project is how to do deployments. I’ve seen micro frontend solutions that deploy everything at the same time. Every micro frontend gets released in one big CI/CD pipeline. I’d actively advocate against that pattern.

If we publish everything at once a true micro frontend solution is not ideal. It may be a monolith developed quite efficiently using reusable packages within a monorepo. But not a micro frontend.

What are we losing by doing a joint release?

* **Independence** (teams need to ship, they need to be prepared to ship, …)
* **Caching** (all resources are invalided at the same point in time instead of when actual changes happened)
* **Velocity** (we need to have some alignment regarding the publish date, which means unnecessary inefficiency)

What would we gain by doing a joint release?

* **Consistency** (we know that all parts have been updated to their latest version)
* **Reliability** (we can run just a single smoke test to know everything is right)
* **Familiarity** (instead of having an ever changing application the application will only be updated in certain intervals)

> While micro frontends can be used with both extremes of the spectrum, the monolith will mostly remain on larger joint releases.

Micro frontends can also be deployed in a mixed set. For instance, we could have some “core” micro frontends developed by one to many teams. These core micro frontends could be deployed jointly. Still, such a mixed mode may be a good compromise aiming to avoid losing velocity, independence, and caching capabilities, while preserving consistency, reliability, and familiarity. This is a system that is already quite known from mobile operating systems (or most operating systems actually):

* third-party applications are on their own release cycles
* some core applications may be updated independently
* with a new release of the main OS the core applications also come in a new version

In some sense a fully running micro frontend solution can be considered similar to a mobile app. Being able to adjust the deployment strategy is one of the advantages that come with micro frontends.

## Conclusion

Choosing between a monolith and a micro frontend does not need to be difficult. Usually, we can start with the monolith without putting in too much thought. Going for a micro frontend solution can still be done once required.

Nevertheless, there are advantages and disadvantages for both kinds of projects. We should always try to find the sweet spot that solves our problem the best. If that’s a monolith — great! If we end up with micro frontends — great, too!

**Don’t** worry about people telling you what’s modern and what’s best practice. Think about the real challenges of your problem and try to come up with the best solution. There is also more than just a technical and business perspective. The team setup (i.e., what is the background of everyone in the team, how open are they for the different solutions, etc.) should never be neglected, too.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
