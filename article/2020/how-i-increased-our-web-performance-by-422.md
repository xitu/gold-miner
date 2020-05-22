> * 原文地址：[How I Increased Our Web Performance by 422%](https://blog.bitsrc.io/how-i-increased-our-web-performance-by-422-84e4997132ff)
> * 原文作者：[Perry Martijena](https://medium.com/@thisisnotperry)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/how-i-increased-our-web-performance-by-422.md](https://github.com/xitu/gold-miner/blob/master/article/2020/how-i-increased-our-web-performance-by-422.md)
> * 译者：[Badd](https://juejin.im/user/5b0f6d4b6fb9a009e405dda1)
> * 校对者：[hansonfang](https://github.com/hansonfang)、[IAMSHENSH](https://github.com/IAMSHENSH)

# 看我如何把网站性能提升 422%

![Our application now…](https://cdn-images-1.medium.com/max/5200/0*jDO8rVIDpzTq0vGx.jpeg)

我把网站性能提升了 422%。没想到，单凭改良数据结构和其他一些技巧就能达到这么好的效果。

在近期的工作中，我重新设计了网站的用户界面。我们的网站基于 AngularJS 开发，而且由于它已经在线上运行了 4 年，所以其中大部分应用都是用 ES5 开发的。网站存在一些性能问题，包括更新缓慢、加载时间长，和一些来自 jQuery 主宰响应式布局年代的过时笨重的代码。我承担了这些优化工作，并想与大家分享在这个过程中我学到的 6 个最重要的经验。

## 1) 学习数据结构和算法

JavaScript 已经不再是一个弱小的语言了。你想要的每个数据结构实现它都有，yin'y性能对前端来说很重要。决定 Web 应用的性能的因素中，有 45% 来自前端（来自 Steve Souders 的《[High Performance Web Sites: Essential Knowledge For Front-End Engineers](http://shop.oreilly.com/product/9780596529307.do)》）。你身边的后端开发者很有可能在用数据结构和算法，所以你也应该用得上它们。使用良好的、可扩展的数据结构和算法极其重要，这样你的应用也是可扩展的。

最有用的数据结构就是 [ES6 Map](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Map) 和栈，它们有效地帮我提升了网站性能。哈希 Map 简直太令人惊艳了，它应该被用于频繁的访问某个键的地方。在前端开发中，我们需要花大量时间检查显示条件（比如鉴权）。我发现缓存数据是非常有用的，我们可以把每个页面中需要通过数组多次访问的数据缓存到 Map 中。这个优化能把时间复杂度从 O(n) 降到 O(1)，这是一个非常显著的性能提升。堆栈对于像向导（Wizard）这样经常需要执行“撤消”操作的场景非常有用。递归也是必知必会的概念，特别是处理对象时。使用分而治之策略，我用良好的递归函数（具有固定的基线条件）替换了大量缓慢的函数。

## 2) 缓存

无论任何列表数值或数据，只要是需要多次访问且不经常改变，你都应该缓存起来。一般来说，我把这些数据存到会话存储（Session Storage）中。虽说本地存储在一些场景中更有用，但对于我缓存的大多数数据来说，我希望当用户的会话中止时就刷新它们。缓存数据一定要谨慎。例如，把敏感信息（如用户名、上个用户的部分消息等）存到本地存储中是一个极为糟糕的做法，因为任何使用这台电脑的人都能得到它们。如果某些数据不随着会话的改变而改变，且需要经常访问，那就果断缓存之！

## 3) 减少 HTTP 请求

减少 HTTP 请求对用户来说意义重大。本地调试时快如闪电的 API 接口调用，可能在 3G 网络下慢似树懒，实际的速度取决于用户的网络状况。推荐大家使用 Chrome 的 Network 面板和 CPU 节流功能来测试你的网站在较缓慢的网络中性能如何。

## 4) 消除卡顿（顺滑的 CSS 动画）

CSS 动画十分强大。 “卡顿（Jank）”指的是动画不稳定的情况。Chrome 调试工具中的 Performance 面板能帮你记录并观察 CSS 动画和过渡（Transition）的 FPS 值。我发现顺滑的动画能让用户更加信赖系统。加载后的元素乱跳或明显的过渡抖动，都会让用户担忧。

## 5) 不要使用 eval……（不仅仅是为了安全）

先抛开安全因素不谈，我发现 eval 实在是太太太慢了。eval 会解析代码，而后通过追踪机器代码来查找代码中提及的变量。用其他解决方案（通常是递归）替代 eval 能提速不少。即使你以安全的方式使用着 eval，如果有另一个可能同样好的解决方案，那就赶紧取用替代方案。

## 6) 理解 JavaScript 的运行原理

从事件循环、调用栈、异步行为、框架的编译原理、原型、作用域链等角度，去理解当你创建了一个 Promise/Observable 时发生了什么，将会是里程碑般的进步。理解 JavaScript 的运行原理能让你知道当涉及到性能和可扩展应用的设计时，应该如何做出正确的决策。也极力推荐大家看看 [Javascript Design Patterns](https://www.dofactory.com/javascript/design-patterns)，免费且裨益良多。

最后，不要担心微优化（Micro-optimization）。虽说有性能意识很重要，但记住，第一要务仍是写出易懂、易维护的代码。再强调一遍：

* 使用良好的数据结构和算法
* 适当做缓存
* 减少 HTTP 请求
* 消除卡顿
* 别用 eval
* 理解 JavaScript 运行原理！

希望本文能给你带来启发！😃

---

> **“Uncommon thinkers reuse what common thinkers refuse.”**
>
> **— J. R. D. Tata**

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
