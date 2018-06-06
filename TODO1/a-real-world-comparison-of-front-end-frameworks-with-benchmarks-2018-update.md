> * 原文地址：[A Real-World Comparison of Front-End Frameworks with Benchmarks (2018 update)](https://medium.freecodecamp.org/a-real-world-comparison-of-front-end-frameworks-with-benchmarks-2018-update-e5760fb4a962)
> * 原文作者：[Jacek Schae](https://medium.freecodecamp.org/@jacekschae?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/a-real-world-comparison-of-front-end-frameworks-with-benchmarks-2018-update.md](https://github.com/xitu/gold-miner/blob/master/TODO1/a-real-world-comparison-of-front-end-frameworks-with-benchmarks-2018-update.md)
> * 译者：
> * 校对者：

# A Real-World Comparison of Front-End Frameworks with Benchmarks (2018 update)

![](https://cdn-images-1.medium.com/max/1000/1*0aM-p4OCCxRMXroYn0qPVA.png)

This article is a refresh of [A Real-World Comparison of Front-End Frameworks with Benchmarks](https://medium.freecodecamp.org/a-real-world-comparison-of-front-end-frameworks-with-benchmarks-e1cb62fd526c) from December 2017.

In this comparison, we will show how different implementations of almost identical [RealWorld example apps](https://github.com/gothinkster/realworld) stack up against each other.

The [RealWorld example app](https://github.com/gothinkster/realworld) gives us:

1.  **Real World App** — Something more than a “todo”. Usually “todos” don’t convey enough knowledge and perspective to actually build _real_ applications.
2.  **Standardized **— A project that conforms to certain rules. Provides a back-end API, static markup, styles, and spec.
3.  **Written or reviewed by an expert **— A consistent, real world project that, ideally, an expert in that technology would have built or reviewed.

#### Criticism from the last version (Dec 2017)

✅️ Angular was not in production. The demo app listed on the RealWorld repo was using a development version, but thanks to [Jonathan Faircloth](https://medium.com/@jafaircl) it is now in production version!

✅ Vue was not listed in the Real World repo, and thus was not included. As you can imagine, in the front-end world, this caused a lot of heat. How come you didn’t add Vue? What the heck is wrong with you? This time around Vue.js is in! Thank you [Emmanuel Vilsbol](https://medium.com/@evilsbol)**.**

#### Which libraries/frameworks are we comparing?

As in the December 2017 article, we included all implementations listed in the RealWorld repo. It doesn’t matter if it has a big following or not. The only qualification is that it appears on the [RealWorld repo](https://github.com/gothinkster/realworld) page.

![](https://cdn-images-1.medium.com/max/1000/1*IJ4a_VfY1Qn3yJaIy7pjVw.png)

Frontends at [https://github.com/gothinkster/realworld](https://github.com/gothinkster/realworld) (April 2018)

### What metrics do we look at?

1.  **Performance:** How long does this App take to show content and become usable?
2.  **Size:** How big is the App? We will only compare the size of the compiled JavaScript file(s). The CSS is common to all variants, and is downloaded from a CDN (Content Delivery Network). The HTML is common to all variants, too. All technologies compile or transpile to JavaScript, thus we only size this file(s).
3.  **Lines of Code:** How many lines of code did the author need to create the RealWorld app based on spec? To be fair some apps have a bit more bells and whistles, but it should not have a significant impact. The only folder we quantify is `src/` in each app.

### Metric #1: **Performance**

Check out the [First meaningful paint](https://developers.google.com/web/tools/lighthouse/audits/first-meaningful-paint) test with [Lighthouse Audit](https://developers.google.com/web/tools/lighthouse/) that ships with Chrome.

The sooner you paint, the better the experience for the person who is using the App. Lighthouse also measures [First interactive](https://developers.google.com/web/tools/lighthouse/audits/first-interactive), but this was almost identical for most apps, and it’s in beta.

![](https://cdn-images-1.medium.com/max/1000/1*El9cBVFHxRG36XD8KNjA_g.png)

First meaningful paint (ms) — lower is better

You probably won’t see a lot of difference when it comes to performance.

### Metric #2: Size

Transfer size is from the Chrome network tab. GZIPed response headers plus the response body, as delivered by the server.

The smaller the file, the faster the download (and there’s less to parse).

This depends on the size of your framework as well as on any extra dependencies you added, and how well your build tool can make a small bundle.

![](https://cdn-images-1.medium.com/max/1000/1*xHuwMctzoT6aA3BE4zXA5w.png)

Transfer size (KB) — lower is better

You can see that Svelte, Dojo 2, and AppRun do a pretty good job. I can’t say enough about Elm— especially when you look at the next chart. I’d like to see how [Hyperapp](https://hyperapp.js.org/) compares…maybe next time, [Jorge Bucaran](https://medium.com/@jorgebucaran)?

### Metric #3: Lines of Code

Using [cloc](https://github.com/AlDanial/cloc) we count the lines of code in each repo’s src folder. Blank and comment lines are **not** part of this calculation.Why is this meaningful?

> If debugging is the process of removing software bugs, then programming must be the process of putting them in — Edsger Dijkstra

![](https://cdn-images-1.medium.com/max/1000/1*YTfk05JBtqNBIoK_4u2H3g.png)

# lines of code — fewer is better

The fewer lines of code you have, then the probability of finding an error is smaller. You also have a smaller code base to maintain.

### In conclusion

I’d like to say a big thank you to [Eric Simons](https://medium.com/@ericsimons) for creating the [RealWorld Example Apps](https://github.com/gothinkster/realworld) repo, and to numerous contributors who wrote different implementations.

**Update:** Thanks to [Jonathan Faircloth](https://medium.com/@jafaircl) for providing production version of Angular.

> And if you found this article interesting, you should [follow me on Twitter](https://twitter.com/jacekschae) and Medium.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
