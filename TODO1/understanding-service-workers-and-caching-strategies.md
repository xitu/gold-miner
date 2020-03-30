> * 原文地址：[Understanding Service Workers and Caching Strategies](https://blog.bitsrc.io/understanding-service-workers-and-caching-strategies-a6c1e1cbde03)
> * 原文作者：[Aayush Jaiswal](https://medium.com/@aayush1408)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/understanding-service-workers-and-caching-strategies.md](https://github.com/xitu/gold-miner/blob/master/TODO1/understanding-service-workers-and-caching-strategies.md)
> * 译者：[Jessica](https://github.com/cyz980908)
> * 校对者：[noname](https://github.com/Eternaldeath)

# 理解 Service Worker 和缓存策略

> 看了本指南，包您能学会 Service Worker 并知道何时使用哪种缓存策略。

![[Maksym Zakharyak](https://unsplash.com/photos/6VBRu8jR8to?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) 在 [Unsplash](https://unsplash.com/search/photos/workflow?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) 上​​发布的照片](https://cdn-images-1.medium.com/max/10368/1*vMvkVSydVwjeXBOAXDjC5w.jpeg)

如果您钻研 Javascript 或从事开发工作已经有一段时间了，那您一定听说过 Service Worker。它到底是什么？简单来说，**它是浏览器在后台运行一个脚本，与 web 页面或 DOM 没有任何关系，并具有开箱即用的特性。** 这些功能包括代理网络请求、推送通知以及后台同步。Service Worker 能保证用户拥有良好的离线体验。

您可以将 Service Worker 看作是一个位于客户端和服务器之间的人，对服务器的所有请求都将通过 Service Worker。本质上来说，它就是个**中间人**。由于所有请求都通过 Service Worker，所以它能够动态拦截这些请求。

![Service Worker 就像一个中间人👷‍♂️](https://cdn-images-1.medium.com/max/2000/1*st7O3EJn6_lrz9QkG0McvQ.png)

不同的 Service Worker 运行在不同的线程上，它们是没有权限直接访问 DOM 元素的，就像一个个与 DOM 和 Web 页面没有交互的 Javascript。虽然不能直接访问 DOM，但是它们可以通过 **postMessage** 间接访问 DOM。如果您打算构建一个渐进式 Web 应用，那么您应该熟练掌握 Service Worker 和缓存策略。

> **注意：** Service worker 不是 Web Worker。Web Worker 是在不同线程上运行运行负载密集型计算的脚本，它不会阻塞主事件循环，也不会阻塞 UI 的渲染。

---

小安利：使用 **[Bit](https://github.com/teambit/bit)** 在项目之间复用和同步组件。作为一个团队来构建与共享组件，可以使组件更快地构建多个应用。
[**团队共享可重用的代码组件 · Bit**
在 Bit ，开发人员可以共享组件并共同构建出优秀软件。快来 bit.dev 上发现共享的组件。](https://bit.dev/)

![例子：Bit 上 的 React 等待加载组件 —— 选择、演示、安装](https://cdn-images-1.medium.com/max/2000/1*Yhkh7jbS5Mx9uP96Y88pZg.gif)

---

## 注册 Service Worker

要在网站中使用 Service Worker，我们必须首先在一个 Javascript 文件中注册一个 Service Worker。

![](https://cdn-images-1.medium.com/max/3976/1*EJh3hdqmn81tZEBTpfw6LQ.png)

在上面的代码中，我们首先检查 Service Worker API是否存在。如果存在，我们将通过上面刚刚写的 Javascript 文件的路径使用 register 方法来注册 Service Worker。因此，一旦页面被加载，您的 Service Worker 就会被注册。

## Service Worker 的生命周期

![Service Worker 的生命周期 👀](https://cdn-images-1.medium.com/max/2000/1*2icy-zbfbPzd2kYhHwxcNQ.png)

#### 安装（Install）

在 Service Worker 注册好时，将触发 **install** 事件。我们可以在 **sw.js** 文件中监听此事件。在深入了解代码前，先让我们了解一下在这个 **install** 事件中应该做些什么。

* 我们想在此事件中设置缓存。
* 将所有静态资源添加到缓存中。

**event.waitUntil()** 方法接收一个 Promise ，使用它来知道安装需要多长时间，以及安装是否成功。如果任何一个文件在缓存过程中失败，那么 Service Worker 的安装也会失败。因此，确保一个短的缓存文件地址列表是很重要的，因为即使一个文件缓存的失败，也会中断 Service Worker 的安装。

![Install 阶段](https://cdn-images-1.medium.com/max/3520/1*0fWZsySFns4KpUqaFZk3eQ.png)

#### 激活（Activate）

一旦一个新的 Service Worker 安装好，并且在不使用以前的版本的 Service Worker 的情况下，就会激活一个新的 Service Worker，同时我们还会得到一个 **activate** 事件。在这个激活事件里，我们可以移除或删除现有的旧缓存。下面给出的代码段摘自[离线指南 中的 Service Worker 部分](https://juejin.im/post/5c0788a65188250808259ae4)。

![Activate 阶段](https://cdn-images-1.medium.com/max/3520/1*KQQGF9AgvjpzvnksqQ6Q2Q.png)

#### 空闲（Idle）

这个阶段没什么好说的，在 Activate 阶段之后，Service Worker 将处于空闲，不执行任何操作，直到另一个事件被触发。

#### 获取（Fetch）

每当发出 fetch 请求时，就会触发一个 **fetch** 事件。我们在这个事件里实现缓存策略。正如我之前提到的，Service Worker 就像一个中间人，所有请求都经过 Service Worker。在这里，我们可以决定是将请求走到网络还是从缓存中获取。下面是一个例子，Service Worker 拦截请求，如果缓存没有返回有效的响应，则将请求发送到网络。

![Fetch 阶段](https://cdn-images-1.medium.com/max/3520/1*kEE7vxaLlxIP4gCUUXPN8Q.png)

上面的代码是缓存策略的一个例子。您应该已经掌握了 Service Worker 的原理了。现在，我们将深入研究一些缓存策略。

## 缓存策略

在上面的 **fetch** 事件中，我们讨论了一种叫**缓存优先，若无缓存则回退到网络**的缓存策略。需要注意是，所有的缓存策略都将在 **fetch** 事件中实现。让我们来看看这些缓存策略。

#### 仅缓存（Cache only）

最简单的。就像它名字所说的，它意味着所有请求都将进入缓存。

**何时使用：当您只想访问静态资源的时候使用它。**

![仅缓存](https://cdn-images-1.medium.com/max/3520/1*YWa918sEIMEmeTDH6KJQDg.png)

#### 仅网络（Network only）

客户端发出请求，Service Worker 拦截该请求并将请求发送到网络。

**何时使用：当不是请求静态资源时，比如 ping 检测、非 GET 的请求。**

![仅网络](https://cdn-images-1.medium.com/max/3520/1*Rn7nC460uo0E_k6IgANO_Q.png)

> **注意：**如果我们不使用 **responseWith** 方法，请求也会正常发出。

#### 缓存优先，若无缓存则回退到网络请求（Cache，falling back to network）

这是之前在 fetch 事件中讨论的内容，如果请求缓存不成功，Service Worker 则会将请求网络。

**何时使用：当您在构建离线优先的应用时**

![缓存优先，若无缓存则回退到网络](https://cdn-images-1.medium.com/max/3520/1*pF1Zr5gWmwEgPB2A2fPZjg.png)

#### 网络优先，若获取失败则回退到缓存获取（Network falling back to cache）

首先，Service Worker 将向网络发出一个请求，如果请求成功，那么就将资源存入缓存。

**何时使用：当您在构建一些需要频繁改变的内容时，比如实时发布的页面或者游戏排行榜。当您最新数据优先时，此策略便是首选。**

![网络优先，若获取失败则回退到缓存获取](https://cdn-images-1.medium.com/max/3520/1*xn7l--f2VtZGq5c4DWmmzQ.png)

#### 常规回退（Generic fallback）

当两个请求都失败时（一个请求失败于缓存，另一个失败于网络），您将显示一个通用的回退，以便您的用户不会感受到白屏或某些奇怪的错误。

![常规回退](https://cdn-images-1.medium.com/max/3520/1*sMjn8fVkJLWDwonMDB8gLg.png)

我们已经学习完了在开发一个渐进式 Web 应用最常用和最基本的缓存策略。还有更多详细内容，可以查看由 Jake Archibald 编写的 [离线指南](https://developers.google.com/web/fundamentals/instant-and-offline/offline-cookbook?hl=zh-cn)。

## 总结

在这篇文章中，我们了解了一些与 Service Worker 和缓存策略相关的很有意思的内容。希望您能喜欢这篇文章，如果您很喜欢我的文章，欢迎您为我点个赞 💖并关注我以了解更多内容。感谢您的阅读🙏，欢迎随时评论和询问。

---

## 了解更多
- [**5 个 加速 React 开发的工具**
5 个工具来加速您的 React 应用开发，专注于组件。](https://blog.bitsrc.io/5-tools-for-faster-development-in-react-676f134050f2)
- [**11 个 2019 年流行的 JavaScript 动画库**
一些最好的 JS 和 CSS 动画库。](https://blog.bitsrc.io/11-javascript-animation-libraries-for-2018-9d7ac93a2c59)
- [**如何构建一个 React 渐进式 Web 应用（PWA）**
包括透彻、全面的指南与现成的代码例子。](https://blog.bitsrc.io/how-to-build-a-react-progressive-web-application-pwa-b5b897df2f0a)

## 译者注：

本文是一篇入门小总结，强烈建议读者阅读文中提到的由 Jake Archibald 编写的 [离线指南](https://developers.google.com/web/fundamentals/instant-and-offline/offline-cookbook?hl=zh-cn)。阅读需翻墙，但在掘金已有译文：
- [[译]前端离线指南（上）](https://juejin.im/post/5c0788a65188250808259ae4)
- [[译]前端离线指南（下）](https://juejin.im/post/5c078e146fb9a049db72e9c3#heading-7)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
