> * 原文地址：[Is Deno Already Dead?](https://medium.com/javascript-in-plain-english/is-deno-already-dead-661ce807338a)
> * 原文作者：[Louis Petrik](https://medium.com/@louispetrik)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/is-deno-already-dead.md](https://github.com/xitu/gold-miner/blob/master/article/2020/is-deno-already-dead.md)
> * 译者：[Inchill](https://github.com/Inchill)
> * 校对者：

# Deno 已经死了吗？

![Source: the author](https://cdn-images-1.medium.com/max/2800/1*UH9zLe8rjJI9lFpj44yYDA.png)

在今年 5 月，不止冠状病毒成为人们关注的焦点，在 JavaScript 和后端开发社区中，Deno 也受到同样的关注并迅速传播开来。第一个稳定版本已经出现，而且引发了一场巨大的炒作。我也一样，迅速地参与到 Deno 并且期望能尝试点新东西。

[一篇文章](https://medium.com/javascript-in-plain-english/deno-vs-node-js-here-are-the-most-important-differences-62b547443be1) 我写了这篇文章，仅仅通过谷歌它就获得了数千的点击量 —— 显而易见大家对于 Deno 的兴趣是真的很浓厚。

但是炒作之后剩下了什么呢？那些甚至认为 Deno 可以取代 Node.js 的声音在哪里？显然，炒作已经所剩无几了 —— 谷歌证实了这一点：

![Source: [Google Trends](https://trends.google.com/trends/explore?q=deno)](https://cdn-images-1.medium.com/max/4592/1*nbOAGzuHmHB7vr00J7xOjw.png)

正如你从谷歌趋势中看到的那样，搜索词 Deno 已经不再像春末夏初的时候那么流行了 —— 还应该注意的是，谷歌 Deno 趋势不包括类别主题或编程语言。谷歌对 Deno 的其它搜索结果与这项技术无关，但仍包含在统计数据中。

## 其它技术的兴起

今年已经有很多东西可以提供 —— 在前端领域是 Svelte，在后端领域是 Deno。而且，总体而言，许多编程语言都得到了广泛的关注。Rust 和 Julia 就是很好的例子 —— 而 JavaScript 的普及率没有增长。

新技术总是带来新的可能性 —— 以及新框架和库。当然，他们都想经受住考验 —— 因此，举例来说，Rust 的 Actix Web 获得了关注，即使只是在 Rust 社区，以及对它感兴趣的人中。

在我看来，Deno 之所以没有了更大的炒作空间 —— 是因为它从来没有颠倒 web 世界的野心 —— 而这正是很快就变得清楚的地方。

## 没有惊天动地的新东西

In my article about the differences between Deno and Node.js, I already mentioned this. These are the essential, special features Deno offers:
在我关于 Deno 和 Node.js 之间的差异的文章中，我就提到了这一点。以下是 Deno 展现出的极其重要的、独特的特性：

* 不支持 NPM
* 权限
* 顶层 Await
* 对 window 对象的支持
* 开箱即用的 TypeScript 支持

That was the essential feature mentioned in a breath of air with Deno.

After a lot of trial and error, most developers probably realized that it’s not features that turn their world upside down. Especially for existing backends, no huge incentive to change everything.

This is also reflected in the professional use of Deno — according to [StackShare.io,](https://stackshare.io/deno) 7 companies use Deno.

## Moving is expensive — and partly pointless

Deno and Node.js are, of course, quite similar. In Deno, you are not only dependent on TypeScript. JavaScript also supports it out-of-the-box.

But where the word JavaScript comes up, you have to think of the many libraries and frameworks that are spread in the JS community. 
Some of them are also available in the Node.js world. 
Just think of Express.js, Koa, Sails, Axios, Lodash, or Sequelize. All of these libraries are often used in Node.js projects and can be easily installed via NPM.

And NPM is the keyword that somehow makes you think of Deno — because using NPM modules with Deno is not intended per se, and therefore rather cumbersome. 
This makes it rather difficult to move from Node.js to Deno. 
Deno is also known for its security — for the fact that virtually everything requires the permission of the user. That’s not bad either, definitely a sensitive approach. But in my opinion, this is not a good argument to completely migrate an existing Node.js app to Deno.

## No extra performance

At this point, I want to make it clear that I personally don’t think that Node.js should be placed above Deno just because of its performance.

As we measure it, performance is often rather unrealistic and can be completely neglected, especially for smaller applications with few users. Scalable service providers make it easy to adapt to your needs in terms of performance — you don’t have to install the fastest possible web server and database on a fixed root server.

Nevertheless, one cannot neglect that many developers are interested in performance — even if there are differences only on paper. But in terms of performance, Deno does not do better than Node.js.

This should not be surprising. After all, Deno has never had the ambition to replace Node.js in terms of performance. It was much more about security and such things.

You can find it on the official Deno website — benchmarks that prove that Deno is not the fastest framework. Not even compared to Node.js.

![Source: [Deno Land — Benchmarks](https://deno.land/benchmarks)](https://cdn-images-1.medium.com/max/2924/1*H_5-f1ftdQirKClZzMFR1g.png)

The standard HTTP request and response modules of Node.js and Deno are compared in the benchmark shown above. The benchmark shows that Node.js offers more performance.

I myself also did a benchmark between the two platforms — the result is the same. Node.js performs clearly better. 
Even though Deno does not look bad all in all, many people are mainly looking for performance.

Of course, performance should not be the only decisive component when choosing a technology. Frameworks and technologies like Fastify, or HTTP libraries for Go and Rust, which shine through their performance, are of great interest. So you can clearly say that many developers are interested in a good performance, and Deno does not offer exactly that compared to Node.js.

## It is too early

New technologies always quickly create hype. Everyone wants to try something new, now is the best time to produce content for it. As a result, topics inflate to the extreme without most people trying to have serious intentions.

Some have gone so far as to see the end of Node.js with the release of Deno — of course, this is content that attracts a lot of attention and is therefore valuable for the creators — but of course, this was a complete exaggeration.

The result is a pompous narrative that has nothing to do with reality anymore, and everyone wants to check on his own if Deno means the end of Node.js. 
Everything else would be illogical. I didn’t decide to rewrite my existing Node.js apps with Deno before I tried it.

At the time when Node.js was announced and released in 2010, the interest was not very high. Early versions of projects always seem a bit bloody and daunting.

Some technologies may be ahead of their time — in 2 years, the world may look very different after the one or other scandal around Node.js. In the past, there have been serious cases of security problems with NPM packages. But in a crisis, there are always those who profit — maybe Deno will be the big one.

## Summing up

Deno is not bad and has its justification.

Node.js was not a bit hyped in its first version, and there is still time for improvements. So Deno will probably continue to evolve.

Especially concerning performance and features that we don’t know from node.js yet, a lot can change. So I’m curious about what will happen to Deno, and I will always check back and see what will be released with the new version.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
