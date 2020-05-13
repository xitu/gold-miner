> * 原文地址：[How I Increased Our Web Performance by 422%](https://blog.bitsrc.io/how-i-increased-our-web-performance-by-422-84e4997132ff)
> * 原文作者：[Perry Martijena](https://medium.com/@thisisnotperry)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/how-i-increased-our-web-performance-by-422.md](https://github.com/xitu/gold-miner/blob/master/article/2020/how-i-increased-our-web-performance-by-422.md)
> * 译者：
> * 校对者：

# How I Increased Our Web Performance by 422%

![Our application now…](https://cdn-images-1.medium.com/max/5200/0*jDO8rVIDpzTq0vGx.jpeg)

I increased our web performance by 422%. Surprisingly, it mainly came down to better data structures and a few other tricks.

Recently I re-designed the UI at my job. We’re running on AngularJS, and most of the application was built with ES5 as it’s been running in production for 4 years now. We had some performance issues, including slow updates, long loading times, and some clunky code from the days when jQuery was the standard for responsive resizing. I took on these tasks, and thought I’d share the 6 most important lessons I learned in the process.

## 1) Learn your Data Structures and Algorithms

JavaScript is no longer an inferior language. It has every data structure implementation you’d expect, and performance matters on the front-end. Up to 45% of a web application’s speed is on the front end (via [High Performance Web Sites: Essential Knowledge For Front-End Engineers by Steve Souders](http://shop.oreilly.com/product/9780596529307.do)). Chances are, your back-end developer is using them, so you should be too. It’s extremely important to use good data structures and algorithms that can scale, so your app can also scale.

The most useful data structures that helped me in increasing performance were the [ES6 Map](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Map) and Stacks. Hash-maps are amazing, and should be used anywhere you need constant accesses from a key. In front-end development, a lot of the time we need to check for display conditions (e.g. permissions). I found it super useful caching data that we accessed many times per page through an array into a Map. That improved time complexity from O(n) to O(1) and there is a very noticeable improvement. Stacks were very useful for things like wizards where you need to “undo” a lot. Recursion was extremely important to know, especially working with objects. I was able to replace a lot of slow functions with good recursive functions (that had solid base cases) using the divide and conquer strategy.

## 2) Caching

Any sort of list value or data you might need to access more than a few times that doesn’t change often should be cached. Generally, I try to store those things in session storage. There are cases where local storage is useful, but most data I cache I want to be refreshed when the user’s session ends. Make sure you are careful about what you are caching. For instance, storing sensitive data in local storage (such as username, part of last user messages, etc) is a very, very, bad idea as it’s accessible to anyone on the computer. When possible, if something doesn’t change per session and is accessed more than once, cache it!

## 3) Make less HTTP Calls

Making less HTTP calls is very important for the user. Depending on their network, your API calls that are lightning fast locally could be very slow on a 3G network. I recommend using Chrome’s network and CPU throttling features to see how your website performs on a slower network computer.

## 4) Remove jank (smooth CSS animations)

CSS animations are very powerful. “Jank” is when your animations are choppy. Chrome’s performance section in the dev tools let’s you record and view the FPS of your CSS animations/transitions. I noticed that smooth animations make users feel increasingly confident in the system. Elements moving around after loading or noticeably choppy transitions can be concerning for a user.

## 5) Don’t use eval….(not just for security reasons)

Security reasons aside, I noticed that eval is SLOWWWWW. Eval interprets code, and then has to find variables you’ve mentioned by tracing it through machine code. Replacing eval conditions with other solutions (recursive solutions a lot of the time) can be a lot faster. Even if you’re using eval in a secure way, if there’s another solution that is potentially just as good, go with that one.

## 6) Learn how JavaScript actually works

Knowing what is happening when you create a Promise/Observable, about the event loop and the call stack, asynchronous behavior, how a framework you’re using is compiled, the prototype/scope chains, etc will go milestones. Knowing what JS is actually doing gives you the knowledge to make the right decisions when it comes to performance and designing scalable applications. I’d also highly recommend checking out this resource on [Javascript Design Patterns](https://www.dofactory.com/javascript/design-patterns) which is free and extremely useful.

Finally, don’t worry about the micro-optimizations. It’s important to be performance conscious, but make sure you are writing understandable and manageable code first and foremost. So to recap:

* Use good data structures and algorithms
* Cache when you can
* Make less HTTP calls
* Remove Jank
* Don’t use eval
* Learn how JavaScript works internally!

I hope you got something out of this! 😃

---

> **“Uncommon thinkers reuse what common thinkers refuse.”**
>
> **— J. R. D. Tata**

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
