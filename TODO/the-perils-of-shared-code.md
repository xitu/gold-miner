* 原文地址：[The perils of shared code](https://www.innoq.com/en/blog/the-perils-of-shared-code)
* 原文作者：[Daniel Westheide](https://www.innoq.com/en/staff/daniel-westheide)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

# The perils of shared code

The road to hell is often paved with good intentions. One such road that I have seen people walk on in various software projects is sharing code between microservices by means of libraries. In almost every project in which the organization went for a microservices architecture, individual teams and developers were expected to base their microservices on some core library. Apparently, even though the problems that can come with that have been known for a long time, a lot of people are still unaware of them. In this blog article, I want to examine why using such a library may sound attractive in the first place, why it can be problematic, and how you can mitigate those problems.

## Goals of shared code

There are two main goals I have seen for sharing code via libraries: sharing domain logic and sharing abstractions in the infrastructure layer:

1. **Shared domain model:** A specific part of the domain model is common between two or more *Bounded Contexts*, so instead of implementing it again and again, you eliminate the need for repetition and the possibility of introducing inconsistent implementations of this domain logic. Usually, the parts of the domain model that people want to share like that are the core domain or one or more generic subdomains. In domain-driven design lingo, this is also called a *Shared Kernel*. Often, you would find concepts like a *Session*, and authentication logic, in here, but it’s not limited to that. A related approach is the *Canonical Data Model*.
2. **Infrastructure layer abstractions:** You want to avoid having to implement useful abstractions for the infrastructure layer time and again, so you put these into a library. Often, these libraries provide a unified approach at database access, messaging, and serialization, among other things.

The motivation for either of them is the same – to avoid repetition, i.e. to follow the *DRY* principle (“Don’t repeat yourself!”). Implementing these things once has several advantages:

- You don’t spend precious time working on problems that have already been solved.
- Having a unified way of doing messaging, database access etc. means that it’s easy for developers to find their way when they need to read or modify code in microservices other developers have originally created.
- You won’t have divergent implementations of business logic or infrastructure concerns that behave slightly different from each other. Instead, there is one canonical implementation that does the right thing.

## Problems of shared code

What may sound great in theory doesn’t come without its own problems, and those problems are probably more painful than the ones you are trying to solve with your library. Stefan Tilkov has already explained in detail [why you should avoid a canonical data model](https://www.innoq.com/en/blog/thoughts-on-a-canonical-data-model/). In addition to that, let me point out a few other issues.

### [The distributed monolith](#thedistributedmonolith)

Often, there seems to be an implicit assumption that putting things into a library means that you never have to worry about services using a wrong or outdated implementation, because they simply need to update their dependency on the library to the latest version.

Whenever you rely on being able to change some behaviour consistently across all your microservices by updating them all to the same new version of your library, you introduce a strong coupling between them. You lose one major benefit of microservices, the ability to have them evolve and to deploy them independently from each other.

I have seen cases where all the services had to be deployed together in order for things to still work properly. If you reach this state, there is no denying that you have actually built a distributed monolith.

A popular example is to use code generation based, for instance, on a Swagger description of your service API, in order to provide a client library for your service. More often than you may think, developers are tempted to abuse this for making breaking changes, because dependent services “just” need to use a new version of their client library. This is not how you [evolve a distributed system](http://olivergierke.de/2016/10/evolving-distributed-systems/).

### [Dependency hell](#dependencyhell)

Libraries, especially those that are designed to provide a common solution to infrastructure concerns, often have an additional problem: They come with a whole bag of additional libraries they depend on. The bigger the transitive dependency tree of your library, the higher the probability that it will lead to the nightmare commonly known as dependency hell. Since your microservices will likely need their own additional dependencies, which again have transitive dependencies, it is only a matter of time until some of them transitively pull in conflicting versions of some library, and simply choosing between the different versions will be impossible, because they are binary incompatible.

Of course, your solution might be to simply provide all the libraries your microservices could possibly need as dependencies of your core library. That still means that your microservices cannot evolve independently, for example by upgrading to a later version of only a specific library they depend on – they are all in lockstep with the release cycle of your core library. Apart from that, why would you force a whole bunch of dependencies on every service when in fact they probably only need a few of them?

### [Top-down library design](#top-downlibrarydesign)

More often than not, the libraries I have seen were forced upon the developers by one or more architects, taking a top-down approach to library design.

Usually, what happens in this case is that the APIs that are exposed by the library are too restrictive and inflexible, or use the wrong level of abstraction, because they are designed by people who are not familiar enough with the wide spectrum of different real-world use cases. Such a library often leads to frustration among the developers that have to live with it, and to people trying to work around the limitations of the library.

### [One language to rule them all](#onelanguagetorulethemall)

One of the most obvious drawbacks that come with enforcing libraries is that this makes it even harder to switch to a different programming language (or platform, like the JVM or .NET), again losing one advantage of a microservices architecture, the ability to choose the technology that fits best for a given problem. If you later on realise that you need this kind of language or platform diversity after all, you have to do invent all kinds of weird crutches. For instance, Netflix came up with [Prana](https://github.com/Netflix/Prana), a sidecar that runs along side non-JVM services, providing them an HTTP API to the Netflix technology stack.

## Can we do better?

With all the problems introduced by sharing code via libraries, the most extreme solution is to simply have no such library at all. If you do that, you will have to do some copy-and-paste or provide a template project for new microservices in order to liberate your services from the lockstep described above. This can be done both for infrastructure code as well as for the shared kernel of your domain model. In fact, in his classic blue book on domain-driven design, Eric Evans mentioned that usually, “teams make changes on separate copies of the KERNEL, integrating with the other team at intervals”[[1]](#fn:1). The shared kernel does not necessarily have to be a library.

If you don’t like the idea of copy and paste, that’s fine as well. After all, as mentioned above, there are definite advantages to sharing code through libraries. Here are some important things to consider in this case:

### [Small libraries with minimal dependencies](#smalllibrarieswithminimaldependencies)

Try to split up your big shared library into a set of very small, highly focussed libraries, each of them solving one specific problem. Try to make these libraries zero-dependency libraries, only relying on the language’s standard library. Yes, it’s not always enjoyable to program only against your languge’s standard library, but the tremendous benefits for all the teams in your company (or even beyond your company, if your library is open source) clearly outweigh this minor inconvenience.

Of course, zero dependencies is not always possible, especially for infrastructure concerns. For these, minimize the dependencies required by each of your small libraries. Also, sometimes it can make sense to provide a binding or integration with another library as a separate artifact, independently from the core of your library.

### [Be optional](#beoptional)

Never rely on the fact that services will update to the latest version of your shared library at a specific point in time. In other words, don’t force library updates on teams, but give them the freedom to update at their own pace. This may require you to change your library in backward and forward compatible ways, but it decouples your services, giving you not only the operational costs of a microservices architecture, but also some of the benefits.

If possible, avoid not only forced library upates, but make the usage of your library itself optional.

### [Bottom-up library design](#bottom-uplibrarydesign)

Finally, if you want to have shared libraries, successful projects I have seen were using a bottom-up approach. Instead of having ivory tower architects design libraries that are hardly usable in the real-world, have your teams implement their microservices, and when some common patterns emerge that have proven themselves in production in multiple services, extract them into a library.

1. 
Evans, Eric: Domain-Driven Design: Tackling Complexity in the Heart of Software, p. 355 [ ↩](#fnref:1)
