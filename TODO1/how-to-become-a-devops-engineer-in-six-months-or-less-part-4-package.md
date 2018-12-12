> * 原文地址：[How To Become a DevOps Engineer In Six Months or Less, Part 4: Package](https://medium.com/@devfire/how-to-become-a-devops-engineer-in-six-months-or-less-part-4-package-47677ca2f058)
> * 原文作者：[Igor Kantor](https://medium.com/@devfire?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-become-a-devops-engineer-in-six-months-or-less-part-4-package.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-become-a-devops-engineer-in-six-months-or-less-part-4-package.md)
> * 译者：
> * 校对者：

# How To Become a DevOps Engineer In Six Months or Less, Part 4: Package

![](https://cdn-images-1.medium.com/max/1000/0*dUiEaJN0gcR_ZFd5)

“Packages” by [chuttersnap](https://unsplash.com/@chuttersnap?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)

### Quick Recap

In Part 1, we talked about the DevOps culture and the foundations required:

* **[[译] 如何在六个月或更短的时间内成为 DevOps 工程师（系列文章第一篇）](https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-become-a-devops-engineer-in-six-months-or-less.md)**

In Part 2, we discussed how to properly lay the foundation for future code deployments:

* **[[译] 如何在六个月或更短的时间内成为 DevOps 工程师，第二部分：配置](https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-become-a-devops-engineer-in-six-months-or-less-part-2-configure.md)**

In Part 3, we talked about how to keep your deployed code organized:

* **[[译] 如何在六个月或更短的时间内成为 DevOps 工程师，第三部分：版本控制](https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-become-a-devops-engineer-in-six-months-or-less-part-3-version.md)**

Here, we’ll talk about how to package your code for easy deployment and subsequent execution.

For reference, we are here in our journey:

![](https://cdn-images-1.medium.com/max/800/1*uTJj1toNrJRl9f6qxR73rQ.png)

Package

NOTE: You can see how every part builds on the previous part and lays the foundation for the subsequent part. This is important and is done on purpose.

The reason is, whether you are talking to your current or future employers, you have to be able to articulate what DevOps is and why it’s important.

And you do so by telling a coherent story — a story of how best to quickly efficiently ship code from a developer’s laptop to a money-making prod deployment.

Therefore, we are not after learning a bunch of disconnected, trendy DevOps tools. We are after learning a set of skills, driven by business needs, backed by technical tools.

OK, enough chatter, let’s get to it!

### Primer on Virtualization

Remember physical servers? The ones you had to wait weeks to be PO-approved, shipped, data center accepted, racked, networked, OS-installed and patched?

Yeah, those. They came first.

Essentially, imagine if the only way to have a place to live is to build a brand new house. Need a place to live? Wait for however long it takes! Kind of cool since everybody gets a house but also not really because it takes a long time to build a house. In this analogy, a physical server is like a house.

Then people got annoyed about how long everything took and some really smart people came up with the idea of _virtualization_: how to run a bunch of pretend “machines” on a single physical machine and have each fake machine pretend to be a real machine. Genius!

So, if you really wanted a house, you could build your own and wait six weeks. Or you could go and live in an apartment building and share the resources with other tenants. Maybe not as awesome but good enough! And most importantly, there is no wait!

This went on for a while and companies (i.e. VMWare) made an absolute killing on this.

Until other smart people decided that stuffing a bunch of virtual machines into a physical machine is not good enough: we need **more** compact packing of **more** processes into **fewer** resources.

At this point, a house is too expensive and an apartment is still too expensive. What if I just need a room to rent, temporarily? That’s amazing, I can move in and out at a moment’s notice!

Essentially, that’s Docker.

### Birth of Docker

Docker is new but the _idea_ behind Docker is very old. An operating system called FreeBSD had a concept of [jails](https://en.wikipedia.org/wiki/FreeBSD_jail) that dates back to 2000! Truly everything new is old.

The idea then and now was to isolate individual processes within the same operating system, in what is known as “operating system level virtualization.”

NOTE: This is not the same thing as “full virtualization”, which is running virtual machines side by side on the same physical host.

What does this mean in practice?

In practice, this means that the rise of Docker’s popularity neatly mirrors the rise of microservices — a software engineering approach where software is broken into many individual components.

And these components need a home. Deploying them individually, as stand-alone Java applications or binary executables is a huge pain: how you manage a Java app is different from how you manage a C++ app and that’s different from you manage a Golang app.

Instead, Docker provides a single management interface that allows software engineers to package (!), deploy and run various applications in a consistent way.

That is a huge win!

OK, let’s talk more about the benefits of Docker.

### Benefits of Docker

#### Process Isolation

Docker allows every service to have full **process isolation**. Service A lives in its own little container, with all of its dependencies. Service B lives in its container, with all its dependencies. And the two are not in conflict!

Moreover, if one container crashes, only that container is affected. The rest will (should!) continue running happily.

This benefits security as well. If a container is compromised, it is extremely difficult (but not impossible!) to get out of that container and hack the base OS.

Finally, if a container is misbehaving (consuming too much CPU or memory) it is possible to “contain” the blast radius to that container only, without impacting the rest of the system.

#### Deployment

Think about how the various applications are built in practice.

If it’s a Python app, it will have a slew of various Python packages. Some will be installed as _pip_ modules, others are _rpm_ or _deb_ packages, and others are simple _git clone_ installs. Or, if done with _virtualenv_, it will be a zip file of all the dependencies in the _virtualenv_ directory.

On the other hand, if it’s a Java app, it will have a gradle build, with all of its dependencies pulled and sprinkled into appropriate places.

You get the point. Various apps, build with different languages and different runtimes pose a challenge when it comes to deploying these apps to prod.

How can we possibly keep all of the dependencies satisfied?

Plus, the problem is worse if there are conflicts. What if service A depends on Python library v1 but service B depends on Python library v2? Now there is a conflict since both v1 and v2 cannot co-exist on the same machine.

Enter Docker.

Docker allows not only for full process isolation but also for full **dependency isolation.** It is entirely possible and common to have multiple containers running side by side, on the same OS, each with its own and conflicting libraries and packages.

#### Runtime Management

Again, how we manage disparate applications differs between applications. Java code logs differently, is started differently and monitored differently from Python. And Python is different from Golang, etc.

With Docker, we gain a single, unified management interface that allows us to start, monitor, centralize logs, stop, and restart many different kinds of applications.

This is a huge win and greatly reduces operational overhead of running production systems.

### Enter Lambda

As great as Docker is, it has downsides.

First, running Docker is still running servers. Servers are brittle and flaky. They must be managed, patched and otherwise cared for.

Second, nobody really runs Docker as is. Instead, it is almost always deployed as part of a complex container orchestration fabric, such as Kubernetes, ECS, _docker-swarm_ or Nomad. These are fairly complex platforms that require dedicated personnel to operate (more on these solutions later).

However, if I’m a developer, I just want to write code and have somebody else run it for me. Docker, Kubernetes and all that jazz are not simple things to learn — do I really have to?!

Short answer is, it depends!

For people who just want somebody else run their code, [AWS Lambda](https://aws.amazon.com/lambda/) (and other solutions like it) are the answer:

> AWS Lambda lets you run code without provisioning or managing servers. You pay only for the compute time you consume — there is no charge when your code is not running.

If you have heard of the whole “serverless” movement, this is it! No more servers to run or containers to manage. Just write your code, package it up in to a zip file, upload to Amazon and let them deal with the headache!

Moreover, since Lambdas are short lived there is nothing to hack — Lambdas are pretty secure by design.

Great, isn’t it?

It is but (surprise!) there are caveats.

First, Lambdas can only run for a max of 15 minutes (as of November 2018). This implies that long running processes, like Kafka consumers or number crunching apps cannot run in Lambda.

Second, Lambdas are Functions-as-a-Service, which means your application must be fully decomposed into microservices and orchestrated with other complex PaaS services like [AWS Step Functions](https://aws.amazon.com/step-functions/). Not every enterprise is at this level of microservice architecture.

Third, troubleshooting Lambdas are difficult. They are cloud-native runtimes and all bug fixing takes place within Amazon ecosystem. This is oftentimes challenging and non-intuitive.

In short, there is no free lunch.

NOTE: There are now “serverless” cloud container solutions as well. [AWS Fargate](https://aws.amazon.com/fargate/) is one such approach. However, I’m ignoring that for now since these tend to be fairly expensive and are still sparingly used.

### Summary

Docker and Lambda are two of the most popular modern, cloud-native approaches to packaging, running and managing production applications.

They are often complimentary, each suited for slightly different use cases and applications.

Regardless, a modern DevOps engineer must be well versed in both. Therefore, learning Docker and Lambda are good short- and medium-term goals.

NOTE: Thus far in our series we have dealt with topics that Junior to Mid-Level DevOps Engineers are expected to know. In subsequent sections, we will start discussing techniques that are more suited for Mid-Level to Senior DevOps Engineers. As always, however, there are no shortcuts to experience!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
