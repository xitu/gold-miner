> * 原文地址：[Deploy != Release (Part 2)](https://blog.turbinelabs.io/deploy-not-equal-release-part-two-acbfe402a91c)
> * 原文作者：[Art Gillespie](https://blog.turbinelabs.io/@artgillespie?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/deploy-not-equal-release-part-two.md](https://github.com/xitu/gold-miner/blob/master/TODO1/deploy-not-equal-release-part-two.md)
> * 译者：
> * 校对者：

# Deploy != Release (Part 2)

## Decouple deploy and release, mitigate risk, and unlock powerful workflows

In [part one of this post](https://medium.com/turbine-labs/deploy-not-equal-release-part-one-4724bc1e726b), I laid out the definitions we use at [Turbine Labs](https://turbinelabs.io) for ship, deploy, release, and rollback . I explained the difference between _deploy risk_ and _release risk,_ and I also talked about release-in-place, a common deploy/release strategy that exposes production requests to deploy risk. In this post, I’ll discuss approaches to decoupling deploy risk from release risk, and describe a few powerful workflows for managing release risk.

### Blue/Green (Or deploy != release)

A b[lue/green deploy](https://martinfowler.com/bliki/BlueGreenDeployment.html) involves deploying your service’s new version alongside the released version in production. You may use dedicated hardware or VMs for each ‘color’ and alternate subsequent deploys between them, or you may use containers and an orchestration framework like Kubernetes to manage ephemeral processes. Regardless, the key here is that once your new (green) version is deployed, it is not released — it does not start responding to production requests. Those are still being handled by the existing, known-good (blue) version of the service.

Release in a blue/green setup usually involves making changes at the load balancer that add hosts running the new version and remove hosts running the known-good version. While this approach is much better than release-in-place, it has some limitations, particularly as it relates to release risk_._ I’ll come back to this point shortly. First, let’s look at a couple of incredibly powerful things you can do now that deploy and release are separate steps.

#### Nothing

If your deployment is hung up in a crash loop backoff or if the database secret is wrong and the newly-deployed service can’t connect, you’re not under any pressure to do _anything_. Your team can diagnose the problem without the pressure of angry users or pacing executives, build another new version, and then deploy it. Repeat at your leisure until you have a good deploy. In the meantime, the known-good released version continues to happily handle production requests and you won’t have to share the post mortem for the broken deploy on your company blog. In other words, y_our deploy risk is completely contained_.

#### Health checks and integration tests

When deployment is separate from release, you can run automated health checks and integration tests against the newly-deployed version before exposing any production traffic to it. I’ve sat in many postmortems where the big takeaway was that something as simple as a post-deploy/pre-release health check would’ve prevented a customer-facing incident.

![](https://cdn-images-1.medium.com/max/800/1*YcCeIx4-FrWMS63ZaVqSRQ.png)

A blue/green deploy with health checks and tests. If there’s something wrong with v1.2, customers aren’t exposed to it.

#### Finer-grained release risk exposure

Since you’re not necessarily required to replace an existing “blue” host when you introduce a new “green” host, you have _some_ control over the percentage of production traffic exposed to your new version. For example, if you have three hosts running the known-good version of your service, you could add a single “green” host to the mix at the load balancer. Now only 25% of your traffic is exposed to the new version instead of the 33% that would’ve been exposed if you removed one of the “green” hosts in the same operation, or had performed a release-in-place on one of the hosts. This is still pretty coarse-grained release risk management, but it’s better than nothing.

![](https://cdn-images-1.medium.com/max/800/1*7D-TdjRuzt9wGX1dcMnitg.png)

When you make one of your “green” hosts available, the percentage of traffic exposed to any bugs in that release is determined by the total number of hosts. Here it’s 33%.

### Release as a Continuum

As I discussed above, from a _deploy risk_ standpoint, blue/green deploys are a win. But when we consider _release risk,_ the way typical blue/green setups handle release doesn’t give us the fine-grained control that we’re looking for. If we agree that [every release is a test in production](https://medium.com/turbine-labs/every-release-is-a-production-test-b31d80f2bc74) (and whether we agree or not, they are), then what we _really_ want is to segment our production requests using pattern-matching rules and dynamically route an arbitrary percentage of that traffic to any version of our service. This is a powerful concept that forms the foundation of sophisticated release workflows like dogfooding, incremental release, rollbacks, and dark traffic. Each of these warrants its own two-part post (coming soon!) but I’ll quickly summarize them here.

**Dogfooding** is a popular technique of releasing a new version of a service to employees only. With a powerful release service in place, you can write rules like “send 50% of internal employee traffic to instances where version=x.x” In my career, dogfooding in production has caught more embarrassing bugs than I care to admit.

**Incremental Release** is the process of starting with some small percentage of production requests routed to a new version of a service while monitoring the performance of those requests — errors, latency, success rate, and so on — against the previous production release. When you’re confident the new version doesn’t exhibit any unexpected behavior relative to the known-good version, you can increase the percentage and repeat the process until you’ve reached 100%.

**Rollback** with a release-as-a-continuum system is simply a function of routing production requests back to instances that are still running the last known-good version. It’s fast, low-risk, and like release itself, can be done in a fine-grained, targeted fashion.

**Dark Traffic** is a powerful technique where your release system duplicates production requests and sends one copy to the known-good, “light” version of your service and another to a new, “dark” version. The “light” version is responsible for actually responding to the user’s request. The “dark” version handles the request, but its response is ignored. This is particularly effective when you need to test new software under production load.

At Turbine Labs, we use our own product, [Houston](https://turbinelabs.io), for dogfooding, incremental release, rollbacks, and, soon, dark traffic. For me, having a sophisticated release system like Houston has been transformative for my day-to-day. Releases are so lightweight and low-risk, I do them _constantly._ As a team, it’s increased our feature velocity and the quality of our product in ways I hadn’t anticipated. We’ll talk in more detail about our internal release process at [Turbine Labs](https://turbinelabs.io) in a future post.

### Conclusion

Most of the technological and process advances in shipping software over the past five years — on-demand cloud compute, containers, orchestration frameworks, continuous delivery, and so on — have focused on deploy primitives. With these advances, designing and implementing a robust _deployment_ process for your service has never been easier, but designing and implementing a reliable _release_ process that can support your services’ needs is still extremely difficult. Facebook, Twitter, and Google committed many engineer-years to the design, implementation, and ongoing maintenance of sophisticated release systems like Gatekeeper, TFE, and GFE. These systems have proven their value many times over, not just for service reliability, but for developer productivity, product velocity, and user experience.

> A sophisticated release system does more than mitigate deploy risk—it directly improves your product velocity and user experience.

We’re starting to see products ([Houston](https://turbinelabs.io), [LaunchDarkly](https://launchdarkly.com/)), and open-source tools ([Envoy](https://lyft.github.io/envoy/), [Linkerd](https://linkerd.io/), [Traefik](https://traefik.io/), [Istio](https://istio.io)) bring to companies of all sizes the kind of release primitives and workflows that until recently were only available to the largest tech companies. These tools and products allow all of us to release features faster and with confidence that we won’t negatively impact our users’ experience.

I’m an engineer at [Turbine Labs](https://turbinelabs.io/) where we’re building [Houston](https://docs.turbinelabs.io/reference/#introduction), a service that makes building and monitoring sophisticated, realtime release workflows easy. If you’d like to ship more and worry less, you should definitely [get in touch](https://turbinelabs.io/contact)! We’d love to talk with you.

Thanks to Glen Sanford, Mark McBride, Emily Pinkerton, Brook Shelley, Sara, and Jenn Gillespie for reading drafts of this post.


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
