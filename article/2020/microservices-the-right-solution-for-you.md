> * 原文地址：[Microservices: The Right Solution for You?](https://blog.bitsrc.io/microservices-the-right-solution-for-you-869e916ded09)
> * 原文作者：[Ashan Fernando](https://medium.com/@ashan.fernando)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/microservices-the-right-solution-for-you.md](https://github.com/xitu/gold-miner/blob/master/article/2020/microservices-the-right-solution-for-you.md)
> * 译者：
> * 校对者：

# Microservices: The Right Solution for You?

## Microservices: 5 Questions to Ask before Making that Decision

#### 5 questions you should ask yourself before jumping into Microservices.

I have been writing about Microservices for quite a few years, both its benefits and its downside. I also raised the flag for newbies not to jump into Microservices without having a proper understanding of the complexity they are getting into, by merely following the trend.

When it comes to Microservices, the success stories and the concepts are truly mesmerizing. Having a collection of services of each doing one thing in the business domain builds a perfect image of a lean architecture. However, we shouldn’t forget that these services need to work together to deliver business value to their end-users.

![](https://cdn-images-1.medium.com/max/2560/1*H5vA_7yhd8zq7F8ZfmAkFg.jpeg)

## Knowing business domain Inside-Out

In the real world, we offer services to end-users in the form of web applications, mobile apps, IoT, or even APIs for integrations. So, if we follow the Microservices architecture, we are talking about Microservices communicating with each other in a particular way.

So if you are new to Microservices, before adopting it, you need first to answer the following question.

#### Question 1: Do you know your business domain inside out and reasonably predict what will change shortly?

Knowing the business domain inside out and the experience with the domain-driven design is crucial to identify the bounded context of each service. Since we allocate teams per each Microservice and allow them to work with minimal interference, getting the bounded context wrong would increase the communication overhead and inter-team dependencies, impacting the overall development speed. So for a project starting from scratch, selecting Microservices is a risky move.

## Entering the world of Distributed Systems

> # “Distributed Systems are Hard” — Anonymous

But what’s the relationship between distributed systems and Microservices. The connection is simple, and when you build Microservices, you directly dive into the realm of distributed systems kind of in advanced mode. They may solve specific problems, but will also introduce others.

> # In fact, its likely not to experience any of the issues with Monoliths, in your software product lifetime, that are worth solved with Microservices.

#### Question 2: What are you trying to achieve by adopting Microservices Architecture?

Microservices isn’t a silver bullet or a superb architecture style that is for everyone. Since we need to deal with distributed systems, it could be an overkill for many. Therefore, it’s essential to assess whether the issues you are experiencing with the Monolith are solvable by Microservices.

#### Question 3: Are you and your team experienced enough to work with distributed systems required for Microservices?

Working with a distributed system will put you in challenges such as distributed telemetry and monitoring, network & communication, fault-tolerant design, distributed transactions, event-driven architecture, containers, and middleware that need a specialized set of design skills and experience. Although there are reference architectures and guides available on the internet, using these properly is the main challenge.

## Following the Celebrities

I have seen famous case studies from Amazon, Netflix absorbing Microservices. You might also feel that why not step up and follow their success paths to the next big thing. You might even get the buying from your business counterparts. The fun part is the non-tech people will also provoke you by asking why not consider Microservices?

> # At the end of the day, who doesn’t want to become Amazon or Netflix and follow their paths, right?

These influences might set an extremely positive impression on Microservices. You might buy the point from the case study or watching the video and convince your self that Monoliths are evil and Microservices are the way to the future.

#### Question 4: Do you have enough time, effort, and money to invest in Microservices?

You might miss the point of how much effort and time it took for them to migrate their Monoliths to Microservices. These projects could quickly go for a couple of years. Even you start a new project with Microservices, that doesn’t guarantee that you will save time and money due to complexities and productivity challenges.

## Big design upfront?

I have talked with some people who have followed full-fledge Microservices from the beginning and experiencing delays than usual, still convinced that it will solve the problem in the future.

> # Microservices will slow you down, take my word for it. If time to market is important, it’s better to go with a Monolith.

Dealing with Distributed systems, Microservices communication, extra effort on data consistency, extra effort on DevOps efforts, are overheads for software development.

#### Question 5: Do you understand the architectural and technical overheads with sufficient experience in solving them?

Unless you build a Monolith and use best practices from Microservices, you might fall into this trap.

## Make it Evolve

If you have read the article up to hear, you will feel that I’m just causing fear in adopting Microservices. My whole purpose here is to make you aware of the risks of directly jumping into Microservices, which I learned the hard way. The bright side is that these journies taught me how to do better with Microservices.

As a litmus test, I have put five questions that you can use as a checklist before adopting Microservices. If the answer is “YES” for all the questions, there is hope that you will make rational decisions in your journey. Otherwise, it’s better to stay away from Microservices since the learning would be costly for the business and has the likelihood of risking the entire project.

#### Follow the proper architecture process.

So my first tip is to decide on the architecture styles by identifying the quality attributes and using the right tactics. Knowing their trade-offs is the right way to move ahead in selecting the architecture styles, tools, and technologies for the application.

Following this approach will keep you away from taking drastic architectural choices, which will also keep Microservices a distant reality in most of the cases.

#### Evolving from Monolith to Microservices

If you already have a well-established business and experiencing architectural and technical difficulties with its growth, that that the right time to think of Microservices.

If you grasp the message from Amazon and Netflix success stories, remember that they were successful with the Monolith as a business at first where they had the money and people with enough experience to do the transformation. These migrations might take months or years. But these businesses have the financials to back the digital transformation, knowing overall benefits at their scale.

## Use the Right Tools

If you are into Microservices and Microfrontends, it’s essential to use the right tools and practices.

If you are using a public cloud provider, it would be a lifesaver to use the middleware available in the cloud. These will help to reduce the total cost of ownership when using Gateways, Async Communication, Data Storage, Monitoring for Microservices.

Similarly, if you adopt Microfrontends along the way, you can use [Bit](https://bit.dev/) ([Github](https://github.com/teambit/bit)) for sharing and managing independent UI components. It will also improve your overall developer experience (DX) by handling the DevOps complexities around independent components.

![React components shared on [Bit.dev](https://bit.dev)](https://cdn-images-1.medium.com/max/2000/1*T6i0a9d9RykUYZXNh2N-DQ.gif)

Besides, its important to structure your projects correctly to improve developer productivity. You can go for either a distributed repository or a monorepo approach, and setup DevOps around the structure for fast releases.

## Summary

Finally, I want to finish this article by saying that be cautious if you decide to follow the Microservices approach from the beginning of a project. The journey seems to be more challenging than you think unless you have a solid case of following Microservices (For example, building an application for a specification or a given standard where you already know the bounded contexts, reducing overall risks). Or else, start with a Monolith.

I hope I have made the points clear to you. If you have any questions or don’t agree with the facts, please leave a comment. I would be happy to reply as soon as I can.

## Learn More
[**How We Build Micro Frontends**
**Building micro-frontends to speed up and scale our web development process.**blog.bitsrc.io](https://blog.bitsrc.io/how-we-build-micro-front-ends-d3eeeac0acfc)
[**A Better Way to Share Code Between Your Node.js Projects**
**Learn why you’ve probably been sharing code modules the wrong way.**blog.bitsrc.io](https://blog.bitsrc.io/a-better-way-to-share-code-between-your-node-js-projects-af6fbadc3102)
[**Can We Use Serverless Functions to Build Microservices?**
**Over the past decade, serverless technologies have evolved tremendously. Today, any software running in the cloud, uses…**blog.bitsrc.io](https://blog.bitsrc.io/aws-serverless-building-blocks-for-microservices-728a6c2ef6e)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
