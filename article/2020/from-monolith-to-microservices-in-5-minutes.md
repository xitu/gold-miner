> * 原文地址：[From Monolith to Microservices in 5 Minutes](https://levelup.gitconnected.com/from-monolith-to-microservices-in-5-minutes-83069677d021)
> * 原文作者：[Daniel Rusnok](https://medium.com/@danielrusnok)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/from-monolith-to-microservices-in-5-minutes.md](https://github.com/xitu/gold-miner/blob/master/article/2020/from-monolith-to-microservices-in-5-minutes.md)
> * 译者：
> * 校对者：

# From Monolith to Microservices in 5 Minutes

> “A microservice architectural style is an approach to developing a single application as a suite of small services.” — Martin Fowler.

![Monolithic Architecture vs. Microservice Architecture](https://cdn-images-1.medium.com/max/6486/1*prvtMgGd36b-smjFPbAcLQ.png)

First, we will find out what is Monolithic Architecture. Therefore, I will show you how to modify its domain to be ready for Microservice Architecture. In the end, I will briefly tell you the basics of Microservice Architecture and judge its pros and cons.

## Monolithic Architecture

Monolithic Architecture is every non-vertically divided architecture. Vertical division in software design means splitting the application into more deployable units. This does not mean that monolith can’t be [horizontally divided into layers](https://levelup.gitconnected.com/layers-in-software-architecture-that-every-sofware-architect-should-know-76b2452b9d9a).

The adjective **monolithic** refers that the architecture of software consists of one backend unit. I am saying backend because I believe that monolith can have more than one UI like web and mobile and still stay monolithic.

![Monolithic Architecture](https://cdn-images-1.medium.com/max/2000/1*ypN7hg56LlEkL8mXwwG7_g.png)

Communication between components is happening mostly by the method invocation. If your frontend and backend are physically divided into, for example, API and web client, then it is still a monolith.

Until you divide the backend into more deployment units, you are still using Monolithic Architecture in my eyes.

## Single Domain Model

> “A domain is the targeted subject area of a computer program. Formally it represents the target subject of a specific programming project.” — Wikipedia

In my words, the domain is the thing why software exists and is about. I wrote ore about the domain in [3 Domain-Centric Architectures Every Software Developer should Know](https://levelup.gitconnected.com/3-domain-centric-architectures-every-software-developer-should-know-a15727ada79f) article.

This is a visualization of part ripped from the online shop’s domain.

![Single-Domain Model](https://cdn-images-1.medium.com/max/4086/1*4V6XEE4UXoADirlpZwNbvQ.png)

Sales and Catalog subdomains contain the single **Product** entity. This leads to more concerns in one place, which is always not good. It is a violation of the [Separation of Concerns principle](https://en.wikipedia.org/wiki/Separation_of_concerns).

Forcing one entity for more concerns does not feel right. The entity contains unused properties in both contexts. Sales don’t need to know the product’s category, and the Catalog doesn’t have any usage for information on how the product was delivered to the customer.

To avoid this problem, we need to find Sales and Catalog contexts' boundaries to split them apart. This leads us to a Bounded Context.

## Bounded Context

> Bounded Context is the boundary or perimeter of a context. — [Idapwiki.com](https://ldapwiki.com/wiki/Bounded%20Context)

To specify the Bounded Context, we need to recognize a contextual scope where the model is still valid.

We can validate the model by asking a simple question within each entity of the domain. **For which context is this entity valid?**

![Specifying Entities Contexts](https://cdn-images-1.medium.com/max/4422/1*_n14MElHRUXeDkhTyW_ytA.png)

When an entity is valid for more than one context, it is divided into more than one. Each with properties corresponding with context. After this process, your application is ready for **Microservice Architecture**.

This is a visualization of part ripped from the online shop’s domain with divided Product entity.

![Multi-Domain Model](https://cdn-images-1.medium.com/max/5106/1*-DKOV0a4q4Cy9ZcuNBfNmg.png)

## Microservice Architecture

Microservice Architecture is also known as Microservices. It is the subdivided monolith. Microservices divide the large systems into smaller pieces.

Bounded Context helps us to find the optimal size for one microservice. Microservice should have a small enough model to minimalize communication with the external world and large enough for existential reasons.

![Microservices](https://cdn-images-1.medium.com/max/3546/1*N4hWH5yRLsrsv0cI703mGQ.png)

Microservice Architecture provides the power of independence. The architecture supports separated development teams, different operating systems, different programming languages, and different business layer architectures like [CQRS](https://levelup.gitconnected.com/3-cqrs-architectures-that-every-software-architect-should-know-a7f69aae8b6c).

Each microservice has its clearly-defined interface, mostly realized by JSON over HTTP via restful API. The recommended solution for communication between microservices is through a messaging platform like [RabitMQ](https://www.rabbitmq.com/) or [Azure Service Bus](https://azure.microsoft.com/cs-cz/services/service-bus/).

Without a proper message passing tool, the Microservice must know other microservices' locations, and locations can be easily changed.

## Summary

The cost curve of development in Microservice Architecture is flattered at large applications. The small applications don’t benefit from microservices and should stay monolithic.

With microservices comes distributed system costs like load balancing and network latency. Such concerns can be nicely handled with orchestrators such as [Kubernetes ](https://kubernetes.io/)or [Azure Service Fabric](https://azure.microsoft.com/cs-cz/services/service-fabric/).

As a next step, I would recommend the [Pluralsight course from Mark Heath — Microservices Fundamentals](https://app.pluralsight.com/library/courses/microservices-fundamentals/table-of-contents).

## Sources

* [Martin Fowler’s blog post about microservices.](https://martinfowler.com/microservices/)
* [Martin Fowler’s blog post about Bounded Context.](https://martinfowler.com/bliki/BoundedContext.html)
* [Pluralsight course Clean architecture patterns, practices, and principles](https://app.pluralsight.com/library/courses/clean-architecture-patterns-practices-principles/table-of-contents).

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
