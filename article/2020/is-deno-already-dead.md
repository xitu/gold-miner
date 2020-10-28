> * 原文地址：[Is Deno Already Dead?](https://medium.com/javascript-in-plain-english/is-deno-already-dead-661ce807338a)
> * 原文作者：[Louis Petrik](https://medium.com/@louispetrik)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/is-deno-already-dead.md](https://github.com/xitu/gold-miner/blob/master/article/2020/is-deno-already-dead.md)
> * 译者：
> * 校对者：

# Is Deno Already Dead?

![Source: the author](https://cdn-images-1.medium.com/max/2800/1*UH9zLe8rjJI9lFpj44yYDA.png)

In May of this year, not only was the coronavirus in the center of attention — in the JavaScript and backend-development community, Deno spread. The first stable version was there, and already a huge hype broke out. I, too, immediately got involved with Deno and was looking forward to trying something new.

[An article](https://medium.com/javascript-in-plain-english/deno-vs-node-js-here-are-the-most-important-differences-62b547443be1) I wrote about it got thousands of hits only via Google — so the interest was really huge.

But what is left of it? Where are the voices that perhaps even thought that Deno could replace Node.js? There is obviously not much left of the hype — Google confirms this:

![Source: [Google Trends](https://trends.google.com/trends/explore?q=deno)](https://cdn-images-1.medium.com/max/4592/1*nbOAGzuHmHB7vr00J7xOjw.png)

As you can see from Google Trends, the search term Deno is no longer as much there as it was in the original hype at the end of spring and beginning of summer — it should also be noted that Google Trends for Deno does not include the category theme or programming language. Other Google searches for Deno, which have nothing to do with the technology, are still included in the statistics.

## The rise of other technology

This year already had a lot to offer — in the front-end area, it was Svelte, in the back-end Deno. And also, many programming languages, in general, have gained a lot of attention. Rust and Julia are good examples of this — while JavaScript has no growth in its popularity.

New technologies always bring with them new possibilities — and new frameworks & libraries. Of course, they all want to be tried out — and so, for example, Rust’s Actix Web gained attention, if only in the Rust community, and among the people interested in it.

In my opinion, Deno didn’t have the room for even more hype — but that’s also because it never had the ambition to turn the web world upside down — and that’s exactly what became clear very quickly.

## Nothing earth-shattering new

In my article about the differences between Deno and Node.js, I already mentioned this. These are the essential, special features Deno offers:

* No NPM support
* Permissions
* Top-level-Await
* Support for the window-object
* TypeScript-support out of the box

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
