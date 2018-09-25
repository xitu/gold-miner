> * 原文地址：[How To Become a DevOps Engineer In Six Months or Less, Part 2: Configure](https://medium.com/@devfire/how-to-become-a-devops-engineer-in-six-months-or-less-part-2-configure-a2dfc11f6f7d)
> * 原文作者：[Igor Kantor](https://medium.com/@devfire?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-become-a-devops-engineer-in-six-months-or-less-part-2-configure.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-become-a-devops-engineer-in-six-months-or-less-part-2-configure.md)
> * 译者：
> * 校对者：

# How To Become a DevOps Engineer In Six Months or Less, Part 2: Configure

![](https://cdn-images-1.medium.com/max/1000/0*CqfqPJ0kz66ZHKtt)

Photo by [Reto Simonet](https://unsplash.com/@reetoo?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)

_NOTE: this is Part 2 of a multi-part series. For Part 1, please click [here](https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-become-a-devops-engineer-in-six-months-or-less.md)._

Let’s recap quickly where we are.

In Part 1, I argued the job of DevOps Engineering is to built fully automated, digital pipelines that move code from a developer’s machine to production.

Now, to do this job effectively requires a solid understanding of fundamentals, depicted here:

![](https://cdn-images-1.medium.com/max/800/1*GNxucS4v93-XdnD5-vWB_w.png)

DevOps Fundamentals

as well as a good understanding of tools and skills (see next graphic below) that build upon these fundamentals.

A quick reminder: your goal is to learn things in blue first, left to right, followed by the things in purple, left to right.

OK, back to our topic. In this article, we will cover the **first** stage of our digital pipeline: Configure.

![](https://cdn-images-1.medium.com/max/1000/1*0S3C5EmK7p_iESafTNB4Ug.png)

Focus on the Configure stage

What happens during the Configure stage?

Since the code we are creating needs machines to run on, the Configure stage actually builds the infrastructure that runs our code.

In the past, provisioning infrastructure was a lengthy, labor-intensive, error-prone ordeal.

Now, because we have our awesome cloud, all provisioning can be done with a click of a button. Or, many clicks, at least.

However, turns out clicking buttons to accomplish these tasks is a Bad Idea.

Why?

Because button clicking is

1.  error prone (humans make mistakes),
2.  not versioned (clicks cannot be stored in git),
3.  not repeatable (more machines = more clicking),
4.  and not testable (no idea if my clicks will actually work or mess stuff up).

For example, think of all the work required to provision your dev environment… then the int environment… then QA… then staging… then prod in US… then prod in EU… It gets very tedious, very annoying, very quickly.

Therefore, a new way is needed. That new way is i**nfrastructure-as-code** and that’s what this Configure stage is all about.

As a best practice, infrastructure-as-code mandates that whatever work is needed to provision computing resources it must be done via code only.

NOTE: by “computing resources” I mean everything needed to properly run an application in prod: compute, storage, networking, databases, etc. Hence the name, “infrastructure-as-code.”

Further, it means that instead of clicking our way through our infrastructure deployment, we will instead

1.  write up the desired infrastructure state in [Terraform](https://www.terraform.io/),
2.  store it in our source code control,
3.  go through a formal [Pull Request](https://www.atlassian.com/git/tutorials/comparing-workflows/feature-branch-workflow) process to solicit feedback,
4.  test it,
5.  execute to provision all the resources needed.

Now, the obvious question is, “Why Terraform? Why not Chef or Puppet or Ansible or CFEngine or Salt or CloudFormation or ${whatever}?”

Good question! Barrels of virtual ink have been spilled debating this very issue.

In short, I think you should learn Terraform because

1.  It is very trendy, therefore the job opportunities are plentiful
2.  It is somewhat easier to learn than others
3.  It is cross-platform

Now, can you pick one of the other ones and still be successful? Absolutely!

* * *

SIDE NOTE: this space is rapidly evolving and is pretty confusing. I want to take a few minutes to talk about some recent history and where I see things evolving.

Traditionally, things like Terraform and CloudFormation have been used to **provision** infrastructure, whereas things like Ansible are used to **configure** it.

You can think of Terraform as a tool to create a foundation, Ansible to put the house on top and then the application gets deployed however you wish (can be Ansible also, for example.)

![](https://cdn-images-1.medium.com/max/800/1*9kmJS9w9gNgqJMmmqb_NVg.png)

How to think about these tools

In other words, you create your VMs with Terraform and then use Ansible to configure the servers, as well as potentially deploy your applications.

Traditionally (!) that is how these things played together.

However, Ansible can do a lot (if not all) that Terraform can do. The reverse is also mostly true.

Don’t let that bother you. Just know that Terraform is one of the most dominant players in the infrastructure-as-code space, so I strongly recommend you start there.

In fact, Terraform+AWS expertise is one of the hottest skill sets to acquire right now!

However, if you are going to defer Ansible in favor of Terraform, you still need to know how to configure large numbers of servers programmatically, right?

Not necessarily!

* * *

Actually, I predict that **configuration management** tools like Ansible will decrease in importance, while **infrastructure provisioning** tools like Terraform or CloudFormation will rise in importance.

Why?

Because of something called “[immutable deployments](https://blog.codeship.com/immutable-infrastructure/).”

Simply put, immutable deployments refer to the practice of never altering your deployed infrastructure. In other words, your unit of deployment is a VM or a Docker container, not a piece of code.

So, you don’t deploy code to a set of static VMs, you deploy whole VMs, with the code already baked in.

You don’t change how the VMs are configured, you deploy new VMs with the desired configuration in place.

You don’t patch prod machines, you deploy new machines, already patched.

You don’t run one set of VMs in dev and a different set of VMs in prod, they are all the same.

You get my point.

When used correctly, this is a very powerful pattern and one I strongly recommend!

NOTE: Immutable deployments mandate that configuration be separate from your code. Please read the [12 Factor App](https://12factor.net/) manifesto which details this (and other awesome ideas!) in great detail. This is a must-read for DevOps practitioners.

The decoupling of code from config is super important — you don’t want to re-deploy the entire application stack every time you rotate your database passwords. Instead, make sure the apps pull it from an external config store (SSM/Consul/etc.)

Further, you can easily see how given the rise of immutable deployments, tools like Ansible start playing less of a prominent role.

Reason is, you only need to configure **one** server and deploy it a whole bunch of times as part of your auto-scaling group.

Or, if you are doing containers, you definitely want immutable deployments almost by definition. You do **not** want your dev container to be different from your QA container and that be different from prod.

You want **the exact same container** across all your environments. This avoids configuration drift and simplifies roll-backs in case of issues.

Containers aside, for those folks who are just starting out, provisioning AWS infrastructure using Terraform is a textbook DevOps pattern and something you really need to master.

But wait… what if I need to look at logs to troubleshoot a problem? Well, you won’t be logging into the machines to look at logs any more, you will instead be looking at the centralized logging infrastructure for all your logs.

In fact, some handsome chap already wrote a detailed [post](https://medium.com/@devfire/deploying-the-elk-stack-on-amazon-ecs-dd97d671df06) on how to deploy an ELK stack in AWS — give it a read if you want to see how it’s done in practice.

Further, you can disable remote access altogether and feel good about being more secure than most people out there!

![](https://cdn-images-1.medium.com/max/800/0*nX3CGWxtkMFh5P5N.jpg)

How you are guaranteed to feel with immutable deployments

To summarize, our fully automated “DevOps” journey begins with provisioning the computing resources needed to run our code — Configure stage. And the best way to accomplish that is via immutable deployments.

Finally, if you are curious about where exactly to start, Terraform+AWS combo is a solid place to begin your journey!

That’s all for the “Configure” stage.

Part 3, “Version” is [here](https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-become-a-devops-engineer-in-six-months-or-less-part-3-version.md)!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
