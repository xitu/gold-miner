> * 原文地址：[Deploy != Release (Part 1): The difference between deploy and release and why it matters.](https://blog.turbinelabs.io/deploy-not-equal-release-part-one-4724bc1e726b)
> * 原文作者：[Art Gillespie](https://blog.turbinelabs.io/@artgillespie?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/deploy-not-equal-release-part-one.md](https://github.com/xitu/gold-miner/blob/master/TODO1/deploy-not-equal-release-part-one.md)
> * 译者：
> * 校对者：

# Deploy != Release (Part 1)

## The difference between deploy and release and why it matters.

_Q: “Is the latest version deployed?”_

_A: “I deployed animated gif support to production.”_

_Q: “So animated gif support is released?”_

_A: “The animated gif release is deployed.”_

_Q: “…”_

I’ve worked at many companieswhere “deploy”, “deployment”, “ship”, and “release” are used loosely, even interchangeably. As an industry, we haven’t done a great job of standardizing our use of these terms, even though we’ve radically improved operations practices and tooling over the past decade. At [Turbine Labs](https://turbinelabs.io), we use precise definitions of “ship”, “deploy”, “release”, and “rollback”, and spend a lot of our time thinking about what the world looks like when you think about “release” as an independent phase of your shipping process. In part one of this post, I’ll share these definitions, describe some common “deploy == release” practices, and explain why they have a poor risk profile. In part two, I’ll describe some of the extremely powerful risk mitigation techniques made possible when “deploy” and “release” are treated as distinct phases of your software shipping cycle.

### Ship

**Shipping** is your team’s process of getting a snapshot of your service’s code — a _version_ — from your team’s source control repository all the way to handling production traffic. I think of the overall shipping process as four distinct groups of smaller, specialized processes: Build, test, deploy, and release. Thanks to technology advances in cloud infrastructure, containers, orchestration frameworks, as well as process advances like [twelve-factor](https://12factor.net/), [continuous integration](https://martinfowler.com/articles/continuousIntegration.html), and [continuous delivery](https://martinfowler.com/bliki/ContinuousDelivery.html), it’s never been easier to execute the first three processes — build, test, and deploy.

### Deploy

**Deployment** is your team’s process for installing the new version of your service’s code on production infrastructure. When we say a new version of software is **deployed**, we mean it is running somewhere in your production infrastructure. That could be a newly spun-up EC2 instance on AWS, or a Docker container running in a pod in your data center’s Kubernetes cluster. Your software has started successfully, passed health checks, and is ready (you hope!) to handle production traffic, but may not actually be receiving any. This is an important point, so I’ll repeat it using Medium’s awesome large pull quote format:

> **_Deployment need not expose customers to a new version of your service_**_._

Given this definition, _deployment can be an almost zero-risk activity._ Sure, a lot can go wrong during deployment, but if a container backs off a crash loop in the woods and no customer gets a 500 status response, did it _really_ happen?

![](https://cdn-images-1.medium.com/max/800/1*5B2HsE8FasLrEsaoRLxBiQ.png)

New (purple) version deployed, but not released. Known-good (green) version still responding to production requests.

### Release

When we say a version of a service is **released**, we mean that it is responsible for serving production traffic. In verb form, **releasing** is the process of moving production traffic to the new version. Given this definition, all the risks we associate with shipping a new binary — outages, angry customers, snarky write-ups in [The Register](https://www.theregister.co.uk/2017/02/28/aws_is_awol_as_s3_goes_haywire) — are related to the release, not deployment, of new software. (At some companies I’ve heard this phase of shipping referred as **rollout**. We’ll stick to **release** for this post.)

![](https://cdn-images-1.medium.com/max/800/1*wDLGwgwtDo1h7dCWg4Qymw.png)

New version released, responding to production requests.

### Rollback

Sooner or later, but probably sooner _and_ later, your team is going to ship something broken. Rollback (and its dangerous, unpredictable, stressed-out cousin, roll-forward) is the process of getting production back to a known state, typically by re-releasing the most recent version. It’s useful to think of rollback as just another deploy and release, the only differences being:

*   You are shipping a version whose characteristics are known in production,
*   You are executing your deploy and release process under time pressure, and
*   You are potentially releasing into a different environment — things may have changed during (or been changed by) the failed release.

![](https://cdn-images-1.medium.com/max/800/0*MAapvhIhLX8oWJ25.)

An example of rollback after a bad release.

Now that we’ve agreed on these definitions for shipping, deployment, release, and rollback, let’s examine some common deploy and release practices.

### Release in Place (Or deploy == release)

When your team’s shipping process involves pushing a new version of your software onto a server running the old version and re-starting the process, you’re releasing in place. Using our definition above, deployment and release occur simultaneously: as soon as the new software is running (deployed), it’s taking all the production traffic the old version was taking a split-second ago (released). In this world, a successful deploy is a successful release, and a bad deploy gets you a partial or complete outage, a bunch of mad users, and—possibly—a hyperventilating manager.

Release-in-place has the distinction of being the only deploy/release process we’ll discuss here that directly exposes _deploy risk_ to customers. If the new version you’ve just deployed can’t launch — maybe it throws an error when it doesn’t find a newly-required secret in an environment variable, maybe there’s an unmet library dependency, or maybe it’s just not your day — there is no old version to take that instance’s customer traffic. Your service is—at least partially—down.

Moreover, if there’s a user-facing issue or more subtle operational issue with the new version — I call this _release risk_ — release-in-place will expose every production request to it for each instance that you’ve released to.

In a clustered environment, you might first release-in-place to just one of your instances. This practice, most commonly referred to as **canary**, can mitigate some risk — the percentage of your traffic exposed to deploy and release risk is equal to the number of instances with the new version of your service divided by the total number of instances in your service’s cluster.

![](https://cdn-images-1.medium.com/max/800/1*rAKFZcAMipD5HpvovIlXmA.png)

A canary release: One host in the cluster is running the new version.

Finally, rolling back a broken release-in-place deploy can be problematic. There’s no guarantee that you can get back to the previous system state even if you rollback (re-release) the old version. Your rollback deploy is just as likely to fail at startup as your currently broken deploy.

Despite its relatively poor risk management characteristics—even with canaries, you’re directly exposing some percentage of customers’ requests to deploy risk—release-in-place is still a common way to do business. I think it’s experience with these kinds of systems that leads to the unfortunate use of the terms “deploy” and “release” interchangeably.

### Despair Not

We can do much, much better! In the [second part of this post](https://medium.com/turbine-labs/deploy-not-equal-release-part-two-acbfe402a91c), I’ll talk about strategies for decoupling deploy from release and some of the powerful workflows you can build on top of a sophisticated release system.

_I’m an engineer at_ [_Turbine Labs_](https://turbinelabs.io) _where we’re building_ [_Houston_](https://docs.turbinelabs.io/reference/#introduction)_, a service that makes building and monitoring sophisticated, realtime release workflows easy. If you’d like to ship more and worry less, you should definitely_ [_get in touch!_](https://turbinelabs.io/contact) _We’d love to talk with you._

_Thanks to Glen Sanford, Mark McBride, Emily Pinkerton, Brook Shelley, Sara, and Jenn Gillespie for reading drafts of this post._

Thanks to [Glen D Sanford](https://medium.com/@9len?source=post_page).


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
