> * 原文地址：[Developers are users too — Introduction](https://medium.com/google-developers/developers-are-users-too-introduction-fefdb42f05a)
> * 原文作者：[Florina Muntenescu](https://medium.com/@florina.muntenescu?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/developers-are-users-too-introduction.md](https://github.com/xitu/gold-miner/blob/master/TODO/developers-are-users-too-introduction.md)
> * 译者：[lsvih](https://github.com/lsvih)
> * 校对者：[IllllllIIl](https://github.com/IllllllIIl), [hanliuxin5](https://github.com/hanliuxin5)

# 开发者也是用户 - 简介

## 易用性 - 学于 UI，用于 API

![](https://cdn-images-1.medium.com/max/2000/1*KwDN8m7j1MLxObs2-znrVA.png)

题图：[Virgina Poltrack](https://twitter.com/VPoltrack)

当谈起**易用性**时，我们通常会将其与地图、短信或照片分享之类的 app 的用户界面联系起来。我们希望它们有着各自的优质特性，例如一个地图 app 应该要有：

* **直观性** —— 能够轻松让用户知道如何从 A 导航至 B。
* **高效性** —— 能够快速地获得导航方向。
* **正确性** —— 能够获得从 A 至 B 正确的、无障碍的路线。
* 提供**适当的功能** —— 能够让用户探索地图，比如放大、缩小和导航。
* 为以上功能提供**适当的使用方式** —— 例如通过手指的缩放来操作地图。

同样的，我们也希望自己所使用的 API 也能有与此相同的特性。如果说 UI 是用户与功能之间的界面，那么 API 就是使用这个 API 的开发者和能实现相应功能代码之间的界面。因此，API 与 UI 一样需要易用性。 

库、框架、SDK - API 无处不在。每当你把代码分离为模块，那么模块暴露的类与方法就成为了 API。其他的开发者（和未来的你）都将会要使用它。

易用性与如何学习使用某个事物花的时间可以说是成反比。无论是新手开发者还是专家都需要用许多的时间学习如何使用新的 API，一个低易用性的 API 可能会导致它被错误的调用，从而造成 bug 和安全问题。这些问题最终不仅会影响使用这些 API 的开发者，还会影响使用 app 的用户。因此，提供高易用性的 API 至关重要。

Nielsen 与 Molich 编写了一套广为人知的手册：[UI 易用性的启示](https://www.nngroup.com/articles/ten-usability-heuristics/)，它可以简单地套用于任何产品中（包括 API），你可以结合 Bloch 所著的 [指南](https://dl.acm.org/citation.cfm?id=1176622) 了解如何设计优秀的 API。

1. [系统状态的可见性](https://medium.com/google-developers/developers-are-users-too-part-1-c753483a50dc#a062)
2. [让系统符合真实世界](https://medium.com/google-developers/developers-are-users-too-part-1-c753483a50dc#fd9a)
3. [为用户提供自由的操作方式](https://medium.com/google-developers/developers-are-users-too-part-1-c753483a50dc#52bc)
4. [一致性与标准](https://medium.com/google-developers/developers-are-users-too-part-1-c753483a50dc#7d0b)
5. [预防错误的发生](https://medium.com/google-developers/developers-are-users-too-part-1-c753483a50dc#6f9b)
6. [让用户认知，而不是回忆](https://medium.com/google-developers/developers-are-users-too-part-2-96e03fe17535#b705)
7. [弹性、高效的使用方式](https://medium.com/google-developers/developers-are-users-too-part-2-96e03fe17535#0709)
8. [优雅、极简的设计](https://medium.com/google-developers/developers-are-users-too-part-2-96e03fe17535#3033)
9. [帮助用户认识、判断、改正错误](https://medium.com/google-developers/developers-are-users-too-part-2-96e03fe17535#d40e)
10. [提供帮助与文档](https://medium.com/google-developers/developers-are-users-too-part-2-96e03fe17535#e86b)

* * *

在下篇文章中，我们将一同深入探讨这些原则，并了解如何将它们应用于 API 设计。敬请关注！

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。

