> * 原文地址：[Three-framework problem with Kotlin Multiplatform Mobile](https://medium.com/xorum-io/three-framework-problem-with-kotlin-multiplatform-mobile-16267c5afa53)
> * 原文作者：[Yev Kanivets](https://medium.com/@yev-kanivets)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/three-framework-problem-with-kotlin-multiplatform-mobile.md](https://github.com/xitu/gold-miner/blob/master/article/2021/three-framework-problem-with-kotlin-multiplatform-mobile.md)
> * 译者：
> * 校对者：

# Three-framework problem with Kotlin Multiplatform Mobile

With KMM (Kotlin Multiplatform Mobile) maturing every month, more and more teams are putting it in production on both Android and iOS. But as the adoption grows, new problems arise.

![](https://cdn-images-1.medium.com/max/2880/1*UXiMJrLOUiwSziIcXUsSLA.png)

Today we will discuss an issue that may occur in modular applications, which have multiple KMP (Kotlin Multiplatform) frameworks shared and used in the iOS application. These KMP frameworks should use a common code from a 3rd module or library exposed to the iOS app.

## Real-world example

Imagine a simple application that allows keeping track of favorite authors and books for all authenticated users. All data is persisted on the backend, so we would like to share the networking, business, and presentation logic in mobile apps using Kotlin Multiplatform technology.

This application will grow a lot in the coming months, so we want to start right with a scalable architecture. We decide to split the codebase into three modules (one per feature): **authentication**, **authors**, **books**.

![](https://cdn-images-1.medium.com/max/2364/1*XKTLMLfs2CTW7vPrB4BR4g.png)

Each module in the Android app is represented by 2 sub-modules: the shared KMP module and the Android-specific module. Shared KMP modules are compiled to iOS frameworks and reused in the iOS app, organized the same way as the Android app — one module per feature.

It's important to mention that **authors** and **books** modules depend on the **authentication** module to serve the authenticated user entity so that the backend can return personalized responses (authors and books).

## Real-world problem

This approach works perfectly well in the Android application but creates cumbersome problems once applied to the iOS application with imported KMP-powered frameworks.

The actual problem is that during the compilation of iOS frameworks Kotlin/Native plugin includes the whole set of dependencies inside the currently compiled framework, so it's self-contained. Also, it prefixes all exposed dependencies with the name of the library to prevent clashing.

![](https://cdn-images-1.medium.com/max/2348/1*8Ne4eMYHJS2OZ4uYtv0QFw.png)

This is very convenient for a single module or a set of independent modules. But once two or more modules use the same dependency exposed to the iOS application, you get several versions of the same dependency duplicated.

In our example, the user entity from the **authors** module and the user entity from the **books** module will be the same in the Android app but two different entities in the iOS application, even though they are identical.

Literally, we have two distinct authentication frameworks in the iOS application, which share nothing — no classes, no state, nothing.

## Real-world solution

I had a chance to discuss this problem with a KMP team, and the recommended solution (at least it was 6 months ago) is to use the Umbrella framework, which contains all shared KMP modules. This framework is a single framework to be imported into the iOS application.

![](https://cdn-images-1.medium.com/max/2348/1*ornbj_vtf61Bak0WaKkgBw.png)

This has an obvious disadvantage of breaking the modularity on the iOS side. But as far as iOS modules match Android modules, we are less prone to use out-of-scope classes from the Umbrella framework in the wrong place.

Good architecture helps a lot here as well. For example, with a Clean Architecture, you have only the top-most level exposed by shared KMP modules. In our case, it's a Presentation level, which is difficult to use anywhere outside of the target module.

## Conclusion

There are no perfect technologies nor solutions. You should be ready to tackle problems as they appear along the way, especially if you are brave enough to use alpha or beta software.

Kotlin Multiplatform allows to use the modular architecture, but with certain important limitations, which need to be taken into account while planning the implementation of the common part and its usage in the iOS application.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
