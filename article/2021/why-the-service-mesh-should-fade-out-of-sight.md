> * 原文地址：[Why the Service Mesh Should Fade Out of Sight](https://medium.com/better-programming/why-the-service-mesh-should-fade-out-of-sight-878bfd30f5a)
> * 原文作者：[David Mooter](https://medium.com/@davidmooter)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/why-the-service-mesh-should-fade-out-of-sight.md](https://github.com/xitu/gold-miner/blob/master/article/2021/why-the-service-mesh-should-fade-out-of-sight.md)
> * 译者：[nettee](https://github.com/nettee)
> * 校对者：[PassionPenguin](https://github.com/PassionPenguin)、[1autodidact](https://github.com/1autodidact)

# 为什么 Service Mesh 应该淡出人们的视野

![[Ricardo Gomez Angel](https://unsplash.com/@ripato?utm_source=medium&utm_medium=referral) 在 [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral) 上的照片](https://cdn-images-1.medium.com/max/9000/0*aQPqRSOiXhzz9zo6)

Service Mesh 越来越受到人们的关注，而很多软件开发与交付的专家在初次接触到 Service Mesh 的时候，会搞不清楚它与 API 网关的区别。Service Mesh 究竟是自成一类产品，还是属于广义的 API 管理的一部分？这些问题并没有抓住重点，因为 Service Mesh 需要逐渐淡入成为后端开发平台的一部分。

要理解为什么这么说，我们首先需要理解正悄然发生在 Kubernetes 上的变革。简单来说，Kubernetes 将成为一个支持分布式应用的分布式操作系统：

+ 传统的操作系统管理计算机的资源，为程序员提供更高级别的抽象，使其可以与复杂的底层硬件进行交互。操作系统的出现是为了解决人工编码直接与硬件进行交互所遇到的困难。
+ Kubernetes 管理计算机集群的资源，为程序员提供更高级别的抽象，使其可以与复杂的底层硬件以及不稳定、不安全的网络进行交互。Kubernetes 的出现是为了解决人工编码直接与硬件集群进行交互所遇到的挑战。虽然按操作系统的标准来看，Kubernetes 还很原始，但随着它逐渐成熟，它将会使传统的操作系统（如 Linux 和 Windows）越来越无关紧要。

## Service Mesh == 云的动态链接器

Service Mesh 是用于分布式计算的现代动态链接器。在传统的编程中，引入另一个模块需要在你的集成开发环境（IDE）中导入一个库。在部署时，操作系统的动态链接器会在运行时将你的程序与库进行连接。动态链接器还会负责寻找调用库、验证调用库的安全性，以及建立与调用库的链接。在微服务架构中，你的“库”是到另一个微服务的网络跳转，而找到那个“库”并与之建立安全连接则是 Service Mesh 的工作。

正如开发和运维团队完全不必考虑动态链接器一样（这几乎不怎么需要照看），现代的分布式团队也不应该去照看一个复杂的 Service Mesh。今天我们看到 Service Mesh 成为第一类的基础架构，这已经是很大的进步了。不过这存在一个问题：Service Mesh 还是太显眼了。

安装 Service Mesh 通常需要几个手工步骤。基础架构团队必须与应用开发团队协作，来保证连接的配置和编码的内容相兼容。许多 Service Mesh 太过复杂，无法大规模扩展，需要专业的运维支持人员进行配置才能保证它们正常运转。当 Service Mesh 出错的时候，你可能甚至要理解它的内部架构才能进行调试。

这种局面必须改变。

## 一切都与开发者体验有关

想象一下，Service Mesh 的安装、配置、运维都需要导入一个 JAR 或者 DLL 库，这个过程中的开发者体验如何？如果在传统软件开发中，诊断线上问题必须理解操作系统的动态链接器的内部架构，那又会是怎样的情景？我想你一定会说：“那也太痛苦了！”

对比一下链接到库的真实体验：你从你的IDE中引用库，构建，然后部署。这样就完成了。这也应该成为 Service Mesh 的黄金标准。

当然，这样的目标是几乎无法达成的。网络调用比内存中的库链接要复杂得多。不过，问题的关键在于，Service Mesh 应该尽可能地对开发运维团队不可见。它应该**尽力**达到这一黄金标准，即使它永远不可能 100% 达到这个目标。

想象一个云原生的开发环境，让开发者能在构建阶段链接微服务。构建阶段的其中一步会将这些连接的配置推送到 Kubernetes 中。Kubernetes 会负责其余的工作，其中 Service Mesh 只是 Kubernetes 发行版的一个实现细节，而你几乎不需要考虑这个细节。

那些认为 Service Mesh 只是用于连接的供应商没有抓住重点。微服务（以及整个云）的价值是小型可部署单元的灵活性和可扩展性更高，然而几十年来我们一直需要的编程结构并未消失。云技术的许多进步正在填补我们从单片机迁移到云原生时失去的构造。如果能让微服务开发者的体验更接近传统软件开发，同时又不牺牲微服务优势的厂商，将拥有制胜的产品。

Service Mesh 应当成为一个平台特性，而不是一个产品类别。它应该尽可能地淡出开发运维团队的视野。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
