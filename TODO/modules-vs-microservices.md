> * 原文地址：[Modules vs. microservices](https://www.oreilly.com/ideas/modules-vs-microservices)
> * 原文作者：[Sander Mak](https://www.oreilly.com/people/sander_mak)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者： 
> * 校对者：

# Modules vs. microservices

Apply modular system design principles while avoiding the operational complexity of microservices.

![](https://d3tdunqjn7n0wj.cloudfront.net/360x240/container-227877_1920-0db52b796e6b80d98f6df2d01a6ee4fb.jpg)

Much has been said about moving from monoliths to microservices. Besides rolling off the tongue nicely, it also seems like a no-brainer to chop up a monolith into microservices. But is this approach really the best choice for your organization? It’s true that there are many drawbacks to maintaining a messy monolithic application. But there is a compelling alternative which is often overlooked: modular application development. In this article, we'll explore what this alternative entails and show how it relates to building microservices.

## Microservices for modularity

"With microservices we can finally have teams work independently", or "our monolith is too complex, which slows us down." These expressions are just a few of the many reasons that lead development teams down the path of microservices. Another one is the need for scalability and resilience. What developers collectively seem to be yearning for is a modular approach to system design and development. Modularity in software development can be boiled down into three guiding principles:

[![](https://cdn.oreillystatic.com/oreilly/email/programming-newsletter-20160205.jpg)](![](https://cdn.oreillystatic.com/oreilly/email/programming-newsletter-20160205.jpg))

- **Strong encapsulation**: hide implementation details inside components, leading to low coupling between different parts. Teams can work in isolation on decoupled parts of the system.
- **Well-defined interfaces**: you can't hide everything (or else your system won't do anything meaningful), so well-defined and stable APIs between components are a must. A component can be replaced by any implementation that conforms to the interface specification.
- **Explicit dependencies**: having a modular system means distinct components must work together. You'd better have a good way of expressing (and verifying) their relationships.

Many of these principles can be realized with microservices. A microservice can be implemented in any way, as long as it exposes a well-defined interface (oftentimes a REST API) for other services. Its implementation details are internal to the service, and can change without system-wide impact or coordination. Dependencies between microservices are typically not quite explicit at development-time, leading to possible service orchestration failures at run-time. Let's just say this last modularity principle could use some love in most microservice architectures.

So, microservices realize important modularity principles, leading to tangible benefits:

- 
Teams can work and scale independently.
- 
Microservices are small and focused, reducing complexity.
- 
Services can be internally changed or replaced without global impact.

What's not to like? Well, along the way you've gone from a single (albeit slightly obese) application to a distributed system of microservices. This brings an enormous amount of operational complexity to the table. Suddenly, you need to continuously deploy many different (possibly containerized) services. New concerns arise: service discovery, distributed logging, tracing and so on. You are now even more prone to the [fallacies of distributed computing](https://en.wikipedia.org/wiki/Fallacies_of_distributed_computing). Versioning of interfaces and configuration management become a major concern. The list goes on and on.

It turns out there is as much complexity in the connections between microservices as there is in the combined business logic of all individual microservices. And to get here, you can't just take your monolith and chop it up. Whereas 'spaghetti code' in monolithic codebases is problematic, putting a network boundary in between escalates these entanglement issues to downright painful. 

## The modular alternative

Does this mean we are either relegated to the messy monolith, or must drown in the complexity of microservice madness? Modularity can be achieved by other means as well. What's essential is that we can effectively draw and enforce boundaries during development. But we can achieve this by creating a well-structured monolith as well. Of course, that means embracing any help we can get from the programming language and development tooling to enforce the principles of modularity.

In Java, for example, there are several module systems that can help in structuring an application. OSGi is the most well-known one, but with the release of Java 9 a native module system is added to the Java platform itself. Modules are now part of the language and platform as a first-class construct. Java modules can express dependencies on other modules, and publicly export interfaces while strongly encapsulating implementation classes. Even the Java platform itself (an enormous codebase) has been modularized using the new Java module system. You can learn more about modular development with Java 9 in my forthcoming book, [Java 9 Modularity](https://www.safaribooksonline.com/library/view/java-9-modularity/9781491954157/?utm_source=newsite&amp;utm_medium=content&amp;utm_campaign=lgen&amp;utm_content=modules-vs-microservices-inline), now available in early release.

[![](https://d3ansictanv2wj.cloudfront.net/software-architecture-16-cta-1d5409f91b486d57eed2d816223fa119.jpg)](https://conferences.oreilly.com/software-architecture/sa-ny?intcmp=il-prog-confreg-article-sany17_new_site)

Other languages offer similar mechanisms. For instance, JavaScript got a [module system](http://exploringjs.com/es6/ch_modules.html) as of ES2015. Before that, Node.js already offered a non-standard module system for JavaScript back-ends. However, as a dynamic language, JavaScript has weaker support for enforcing interfaces (types) and encapsulation between modules. You can consider using TypeScript on top of JavaScript to get back this advantage again. Microsoft's .Net Framework does have strong typing like Java, but it doesn't have a direct equivalent to Java's upcoming module system in terms of strong encapsulation and explicit dependencies between assemblies. Still, a good modular architecture can be achieved by using Inversion-of-Control patterns which are standardized in [.Net Core](https://msdn.microsoft.com/en-us/magazine/mt707534.aspx) and by creating logically related assemblies. Even C++ is [considering the addition](http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2016/n4610.pdf) of a module system in a future revision. Many languages are gaining appreciation for modularization, which is in itself a striking development.

When you make a conscious effort to use the modularity features of your development platform, you can achieve the same modularity benefits that we ascribed to microservices earlier. Essentially, the better the module system, the more help you get during development. Different teams can work on different parts, where only the well-defined interfaces are touch points between the teams. Still, at deployment time the modules come together in a single deployment unit. This way you can prevent the substantial complexity and costs associated with moving to microservices development and management. True, this means you can't build each module on a different tech-stack. But is your organization really ready for that anyway?

## Designing modules

Creating good modules requires the same design rigor as creating good microservices. A module should model (part of) a single bounded context of the domain. Choosing microservice boundaries is an architecturally significant decision with costly ramifications when done wrong. Module boundaries in a modular application are easier to change. Refactoring across modules is typically supported by the type-system and the compiler. Redrawing microservice boundaries involves a lot of inter-personal communication to not let things blow up at run-time. And be honest, how often do you get your boundaries right the first time, or even the second?

In many ways, modules in statically typed languages offer better constructs for well-defined interfaces. Calling a method through a typed interface exposed by another module is much more robust against changes than calling a REST endpoint on another microservice. REST+JSON is ubiquitous, but it is not the hallmark of well-typed interoperability in the absence of (compiler-checked) schemas. Add in the fact that traversing the network including (de)serialization still isn't free, and the picture becomes even bleaker. What's more, many module systems allow you to express your dependencies on other modules. When these dependencies are violated, the module system will not allow it. Dependencies between microservices only materialize at run-time, leading to hard to debug systems.

Modules are natural units for code-ownership as well. Teams can be responsible for one or more modules in the system. The only thing shared with other teams is the public API of their modules. At run-time, there's less isolation between modules in comparison with microservices. Everything still runs in the same process, after all. 

[![](https://d3ansictanv2wj.cloudfront.net/safari-topic-cta-1f60e6f96856da19ba3cb25660472ca5.jpg)](https://www.safaribooksonline.com/home/?utm_source=newsite&amp;utm_medium=content&amp;utm_campaign=lgen&amp;utm_content=software-architecture-post-safari-right-rail-cta)

There's no reason why a module in a monolith can't own its data just like a good microservice does. Sharing within the modular application then happens through well-defined interfaces or messages between modules, not through a shared datastore. The big difference with microservices is that everything happens in-process. Eventual consistency concerns should not be underestimated. With modules, eventual consistency can be a deliberate, strategic choice. Or, you can just 'logically' separate data while storing them in the same datastore and still use cross-domain transactions for the time being. For microservices, there is no choice: eventual consistency is a given and you need to adapt.

## When are microservices right for your organization?

So when should you turn to microservices? Until now, we've mainly focused on tackling complexity through modularity. For that, both microservices and modular applications will do. But there are different challenges besides the ones addressed so far. 

When your organization is at the scale of Google or Netflix, it makes complete sense to embrace microservices. You have the capacity to build your own platform and toolkits, and the number of engineers prohibits any reasonable monolithic approach. But most organizations  don't operate at this scale. Even if you think your organization will become a billion-dollar unicorn one day, starting out with a modularized monolith won't do much harm. 

Another good reason to spin up separate microservices is if different services are inherently better suited to different technology stacks. Then again, you must have the scale to attract talent across these disparate stacks and keep those platforms up and running. 

Microservices also enable independent deployment of different parts of the system, something that is harder (or even impossible) in most modular platforms. Isolated deployments add to the resilience and fault-tolerance of the system. Furthermore, the scaling characteristics may be different for each microservice. Different microservices can be deployed to matching hardware.  The modularized monolith can be scaled horizontally as well, but you scale out all modules together. That may not always work out for the best, though in practice, you can get quite far with this approach. 

## Conclusion

As always, the best option is finding a middle-ground. There's a place for both approaches, and which is best really depends on the environment, organisation and the application itself. Why not start with a modular application? You can always choose to move to microservices later. Then, instead of having to surgically untangle your monolith, you have sensible module boundaries cut out already. It's not even an exclusive choice: you can also use modules to structure microservices internally. The question then becomes, why do microservices have to be 'micro'? 

Even if you do depart from a single modularized application, your services don't have to be tiny to be maintainable. Again, applying the principles of modularity within services allows them to scale in complexity beyond what you'd normally ascribe to microservices. There's a place for both modules and microservices in this picture. Real cost-savings can be achieved by reducing the number of services in your architecture. Modules can help structure and scale services just as they can help structure a single monolithic application.

If you're after the benefits of modularity, make sure you don't trick yourself into a microservices-only mindset. Explore the in-process modularity features or frameworks of your favorite technology stack. You’ll get support to enforce modular design, instead of having to just rely on conventions to avoid spaghetti code. Then, make a deliberate choice whether you want to incur the complexity penalty of microservices. Sometimes you just have to, but often, you can find a better way forward. 

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
