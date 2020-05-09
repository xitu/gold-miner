> * 原文地址：[What Does Serverless Actually Mean?](https://medium.com/better-programming/what-does-serverless-actually-mean-c68bde4cdc0d)
> * 原文作者：[Steven Popovich](https://medium.com/@steven.popovich)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/what-does-serverless-actually-mean.md](https://github.com/xitu/gold-miner/blob/master/article/2020/what-does-serverless-actually-mean.md)
> * 译者：
> * 校对者：

# What Does Serverless Actually Mean?

![Photo by [Taylor Vick](https://unsplash.com/@tvick?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) on [Unsplash](https://unsplash.com/s/photos/servers?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)](https://cdn-images-1.medium.com/max/7912/1*poXRRZdZAElrrP9C3ZQLoQ.jpeg)

> It’s actually not serverless at all

The word **serverless** is really misleading. It’s a buzzword, for sure.

If you google “serverless,” the Wikipedia definition is actually pretty good:

> **“**Serverless computing is a [cloud computing](https://en.wikipedia.org/wiki/Cloud_computing) [execution model](https://en.wikipedia.org/wiki/Execution_model) in which the cloud provider runs the [server](https://en.wikipedia.org/wiki/Server_(computing)), and dynamically manages the allocation of machine resources. Pricing is based on the actual amount of resources consumed by an application, rather than on pre-purchased units of capacity.[[1]](https://en.wikipedia.org/wiki/Serverless_computing#cite_note-techcrunch-lambda-1)It can be a form of [utility computing](https://en.wikipedia.org/wiki/Utility_computing).” — Wikipedia

This is all true. And if you can digest this jargony definition, you can see that serverless, in fact, involves many servers.

What serverless actually means that you don’t have to worry about what size of the server box (processing power) or how many boxes you need to serve your users. The provider of the serverless service deals with the size and numbers of boxes you need, based on the amount of work you throw at it.

Cloudflare, one provider of serverless back ends has a great graphic about how serverless can save you money and how it scales:

![Taken from [Cloudfare’s great piece on the cost/benefit of serverless](https://www.cloudflare.com/learning/serverless/why-use-serverless/)](https://cdn-images-1.medium.com/max/2000/1*e3EE-9xCRweHvYnK44wYlQ.png)

In a traditional system, when your application gets more users or your users do more things, or really anything that causes your back end to do more processing, you have to increase the number of boxes (or the power of the boxes) as you get more demand.

Let's take an example. Let’s say you operate Reddit. You have to have servers to serve the website to the user and a database to keep all your links, comments, and user profiles.

In the traditional model, you could have one box serving traffic. You might have a scaling policy that if the box has 95% CPU or more for five minutes, add another box to serve the traffic. That’s the blue boxes above. You would be paying a fixed price per box, per hour. When you go from one box to two boxes, you are doubling your cost.

But what if, when you scale up to two boxes, users get off your site. Your new box doesn’t even get used. You could have a scaling policy that will scale back down to one box, but the point is, if you have two boxes spun up, you are paying for them.

You can see the overhead this introduces. You are technically paying for server power you may not be using.

With serverless, however, in theory, you pay for exactly only what you use. You don’t set scaling policies or pick how many servers you need. You just throw traffic at the provider and pay for how much it costs. You don’t know how many boxes the provider is using, and you don’t care. And the savings are passed on to you. In theory.

This is where the name **serverless** comes from. You, as a user of server power, don’t have to think about the servers that are working behind the scenes. But they are still there!

## So What’s the Catch?

So why isn’t everything serverless? It seems like everyone would win because we don’t end up with wasted server time.

But it isn’t that simple. Behind the scenes, the serverless provider is still doing the same thing as the traditional model. And it won’t become magically perfectly granular.

The serverless provider — meaning a service like AWS Lambda, Cloudflare, Azure, and Google Cloud — is still scaling up and down, and allocating boxes to work that goes up and down. And sometimes they will have unused servers. And someone still has to pay for the servers, whether they are unused or not.

Now, they might be better at it. They can have advanced machine-learning algorithms and distribute your work across many boxes intelligently. Boxes can run work from different people. Since it is their main purpose to cost-effectively provide server time without wasting server time, they can probably do it more efficiently than you. But they, just as you did when you were managing your own boxes, have to deal with the scaling of boxes.

Serverless really just puts the job of scaling onto the service provider. So what if the provider isn’t good at it? And remember, you are paying for the engineering of the serverless algorithms and infrastructure. This means, for some workloads, you could end up paying more.

Remember: These providers are businesses.

It is important to keep in mind that if you’re using one of the providers, they are still businesses that need to make money.

And they can lose money on small projects and make all their money on big projects.

A lot of providers of developer back-end services (Google Maps API and Firebase, to name a few I have used) employ a “you’ll pay when you scale” model. In that, for some small workloads, the cost is much cheaper than provisioning your own boxes. But when you scale up your workload (your business grows) the cost would be much more than your own setup. Keep this in mind and use the provider's calculators as necessary.

#### There is also a man behind a curtain

Furthermore, serverless has another problem that makes me nervous as a distributed system maintainer: You can’t see exactly what is happening.

When you spin up your own boxes, run your own software on them, and roll your own monitoring and scaling for all the boxes you manage, you have **control.** And for large-scale applications, developers and companies want control. You want insight as to what is happening in your system.

With serverless, if you have a problem with your workload, it’s much harder to tell what is going on because you can’t just look at the logs on a box. The computation that is happening is hidden away from you.

Or when users start writing in that your software isn’t working or is slow, you can’t see exactly why your system didn’t scale. The best you can do is file a ticket with your provider and hope that it was just a blip.

This means debugging your system is more difficult. It’s not impossible; you still have logging and the like. But most back-end maintainers I know like having the ability to hop onto a box that is having a problem and see exactly what is going on.

There are also myriad other problems with serverless that I’m not going to get into (vendor lock-in, cold starts, security?), but they are worth considering if you’re thinking about using serverless for your application.

## But We Are Getting There

I wish serverless was perfect. I and many other people spend too much worrying about if our system will scale.

Remember, any time you can reduce the number of variables you have to worry about in a system, it’s a better system. You always want to reduce complexity.

But going serverless tomorrow doesn’t necessarily reduce complexity and doesn’t necessarily reduce costs, either. As with any other technical or architectural decision, it’s important to see if it fits your project. Take your time and do a strong analysis of what is right for you.

It also still uses servers — don’t be fooled! Thanks for reading!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
