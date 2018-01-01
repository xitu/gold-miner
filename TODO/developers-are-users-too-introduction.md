> * 原文地址：[Developers are users too — Introduction](https://medium.com/google-developers/developers-are-users-too-introduction-fefdb42f05a)
> * 原文作者：[Florina Muntenescu](https://medium.com/@florina.muntenescu?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/developers-are-users-too-introduction.md](https://github.com/xitu/gold-miner/blob/master/TODO/developers-are-users-too-introduction.md)
> * 译者：
> * 校对者：

# Developers are users too — Introduction

## Usability — learning from the UI, applying in API

![](https://cdn-images-1.medium.com/max/2000/1*KwDN8m7j1MLxObs2-znrVA.png)

Images: [Virgina Poltrack](https://twitter.com/VPoltrack)

When talking about **_usability_**, we tend to think of user interfaces, may it be a maps, messaging or photo sharing app. We want our user interfaces to have several qualities, for example a maps application should be:

* **Intuitive** — to be able to easily know how to navigate from A to B.
* **Efficient** — to get the navigation directions quickly.
* **Correct** — to get the right path from A to B, without any roadblocks or other impediments.
* Provide **appropriate functionality** — be able to explore the map, zoom in, zoom out and navigate.
* Provide **appropriate access to the functionality** — be able to zoom out, by just pinching the map.

We should expect the same qualities from the APIs we work with too. If the UI is the interface between users and functionality, then the API is the interface between the developer using it and the body of code that implements that functionality. APIs, like UIs, need to be usable as well.

Libraries, frameworks, SDKs — APIs are everywhere! Whenever you’re separating code into modules, the classes and methods exposed by the module become the API. It’s what other developers (and ‘future you’!) need to work with.

Usability can be measured to be the inverse of the amount of time needed to understand how to use something. Both beginner and expert developers spend a lot of time learning how to work with new APIs. A low degree of usability leads to incorrect usage of APIs, which can result in bugs and even security problems. These issues end up affecting not only the developers integrating those APIs, but also the users of those applications. That’s why it’s critical to provide a usable API.

Nielsen and Molich created a well known set of [UI usability heuristics](https://www.nngroup.com/articles/ten-usability-heuristics/) that can be easily applied to any product, including APIs, and can be combined with Bloch’s [guidelines](https://dl.acm.org/citation.cfm?id=1176622) for designing a good API.

1. [Visibility of system status](https://medium.com/google-developers/developers-are-users-too-part-1-c753483a50dc#a062)
2. [Match between system and the real world](https://medium.com/google-developers/developers-are-users-too-part-1-c753483a50dc#fd9a)
3. [User control and freedom](https://medium.com/google-developers/developers-are-users-too-part-1-c753483a50dc#52bc)
4. [Consistency and standards](https://medium.com/google-developers/developers-are-users-too-part-1-c753483a50dc#7d0b)
5. [Error prevention](https://medium.com/google-developers/developers-are-users-too-part-1-c753483a50dc#6f9b)
6. [Recognition rather than recall](https://medium.com/google-developers/developers-are-users-too-part-2-96e03fe17535#b705)
7. [Flexibility and efficiency of use](https://medium.com/google-developers/developers-are-users-too-part-2-96e03fe17535#0709)
8. [Aesthetic and minimalist design](https://medium.com/google-developers/developers-are-users-too-part-2-96e03fe17535#3033)
9. [Help users recognize, diagnose and recover from errors](https://medium.com/google-developers/developers-are-users-too-part-2-96e03fe17535#d40e)
10. [Help and documentation](https://medium.com/google-developers/developers-are-users-too-part-2-96e03fe17535#e86b)

* * *

In the next articles, we’ll take a look in depth at each of these principles and examine how they might be applied to API design. Stay tuned!


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
