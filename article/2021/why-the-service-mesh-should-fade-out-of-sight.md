> * 原文地址：[Why the Service Mesh Should Fade Out of Sight](https://medium.com/better-programming/why-the-service-mesh-should-fade-out-of-sight-878bfd30f5a)
> * 原文作者：[David Mooter](https://medium.com/@davidmooter)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/why-the-service-mesh-should-fade-out-of-sight.md](https://github.com/xitu/gold-miner/blob/master/article/2021/why-the-service-mesh-should-fade-out-of-sight.md)
> * 译者：
> * 校对者：

# Why the Service Mesh Should Fade Out of Sight

![Photo by [Ricardo Gomez Angel](https://unsplash.com/@ripato?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral).](https://cdn-images-1.medium.com/max/9000/0*aQPqRSOiXhzz9zo6)

With rising interest in service meshes, many application development and delivery pros’ first encounter with one leaves them wondering how they differ from API gateways. Are service meshes their own product category or are they part of broader API management? These questions miss the point: Service meshes need to fade away into the background of development platforms.

To understand why, one must first understand the quiet revolution happening with Kubernetes. Simply put, Kubernetes is becoming a distributed operating system to support distributed applications.

* Legacy operating systems manage the resources of a computer and provide higher levels of abstractions for programmers to interact with the complex underlying hardware. They arose to address the challenges of hand-coding direct interactions with hardware.
* Kubernetes manages the resources of a cluster of computers and provides higher levels of abstractions for programmers to interact with complex underlying hardware and unstable, insecure networks. It arose to address the challenges of hand-coding direct interactions with clustered hardware. Although primitive by OS standards, it will make legacy OSes like Linux and Windows more and more irrelevant as it matures.

## Service Mesh == Dynamic Linker For Cloud

A service mesh is the modern-day dynamic linker for distributed computing. With traditional programming, including another module involves importing a library into your integrated development environment (IDE). Upon deployment, the operating system’s dynamic linker connects your program with the library at runtime. It also handles discovering the library, validating security to invoke the library, and establishing a connection to it. With a microservices architecture, your “library” is a network hop to another microservice. Finding that “library” and establishing a secure connection is the job of the service mesh.

Just as it makes no sense for development and operations teams to have to think about a dynamic linker — much less care and feed for one — modern-day teams should not have to care for and feed a complicated service mesh. The situation we see today of service meshes being first-class infrastructure is an important step forward, but they have a problem: They are too visible.

Installing a typical service mesh requires several manual steps. Infrastructure teams must coordinate with AppDev teams to ensure that connection configurations are compatible with what was coded. Many service meshes are too complicated to stand up at scale and require solid operational support talent to configure and keep them healthy. You may even need to understand the service mesh’s internal architecture to debug it when things go wrong.

This must change.

## It’s All About the Developer Experience

Imagine a developer experience in which importing a JAR or DLL library required all the installation, configuration, and operational support a service mesh entails. What if it also required understanding the internal architecture of the operating system’s dynamic linker to diagnose runtime problems? I hear you responding, “That’d be insane!”

Contrast this with the real experience of linking to a library: You reference the library from your IDE, build, and deploy. Done. That should be the gold standard for service mesh.

Obviously, that is unattainable. A network call is more complicated than an in-memory library link. The point is that a service mesh should become as invisible as possible to the DevOps team. It should **strive** toward that gold standard, even if it can never quite get there 100%.

Imagine a cloud-native development environment that enables developers to link microservices at build time. It then pushes the configurations of these connections into Kubernetes as part of the build process. Kubernetes then takes care of the rest, with the service mesh just being an implementation detail of your Kubernetes distribution that you rarely have to think about.

Vendors that believe service mesh is merely about connectivity are missing the point. The fundamental value of microservices (and the cloud in general) is greater agility and scalability from smaller deployable units running on serverless, yet the programming constructs we’ve needed for decades haven’t gone away. Many advancements in cloud technology are filling in the constructs we lost when migrating from monoliths to cloud-native. Vendors that make the microservice developer’s experience more on par with that of traditional software development, without sacrificing the benefits of microservices, will have the winning products.

The service mesh should be a platform feature — not a product category. It should be as far out of sight and mind from the DevOps team as possible.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
