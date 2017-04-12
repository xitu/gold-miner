> * 原文地址：[Node.js War Stories: Debugging Issues in Production](https://blog.risingstack.com/node-js-war-stories-solving-issues-in-production-2/)
> * 原文作者：[Gergely Nemeth](https://blog.risingstack.com/author/gergely/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：
> * 校对者：

# Node.js War Stories: Debugging Issues in Production #

In this article, you can **read stories from Netflix, RisingStack & nearForm about Node.js issues in production** - so you can learn from our mistakes and avoid repeating them. You'll also learn what methods we used to debug these Node.js issues.

*Special shoutout to Yunong Xiao of Netflix, Matteo Collina of nearForm & Shubhra Kar from Strongloop for helping us with their insights for this post!*


At RisingStack, we have accumulated a tremendous experience of running Node apps in production in the past 4 years - thanks to our [Node.js consulting, training and development](https://risingstack.com/) business.

As well as the Node teams at Netflix & nearForm we picked up the habit of always writing thorough postmortems, so the whole team (and now the whole world) could learn from the mistakes we made. 

## Netflix & Debugging Node: Know your Dependencies ##

**Let's start with a slowdown story from Yunong Xiao, which happened with our friends at Netflix.**

The trouble started with the Netflix team noticing that their applications response time increased progressively - some of their endpoints' latency increased with 10ms every hour. 

This was also reflected in the growing CPU usage.

![Netflix debugging Nodejs in production with the Request latency graph](https://blog-assets.risingstack.com/2017/04/Netflix-debugging-Nodejs-in-production---Request-latency-graph.png)

*Request latencies for each region over time - photo credit: Netflix*

At first, they started to investigate whether the request handler is responsible for slowing things down. 

**After testing it in isolation, it turned out that the request handler had a constant response time around 1ms.**

So the problem was not that, and they started to suspect that probably it's deeper in the stack.

The next thing Yunong & the Netflix team tried are [CPU flame graphs](http://www.brendangregg.com/FlameGraphs/cpuflamegraphs.html) and Linux [Perf Events](https://perf.wiki.kernel.org/index.php/Main_Page).

![Flame graph of Netflix Nodejs slowdown](https://blog-assets.risingstack.com/2017/04/Flame-graph-of-Netflix-Nodejs-slowdown.png)

*Flame graph or the Netflix slowdown - photo credit: Netflix*

**What you can see in the flame graph above is that**

- it has high stacks *(which means lot of function calls)*
- and the boxes are wide *(meaning we are spending quite some time in those functions)*.

After further inspection, the team found that Express's `router.handle` and `router.handle.next` has lots of references.

> The Express.js source code reveals a couple of interesting tidbits:
> 
> - Route handlers for all endpoints are stored in one global array.
> - Express.js recursively iterates through and invokes all handlers until it finds the right route handler.

**Before revealing the solution of this mystery, we have to get one more detail:**

Netflix's codebase contained a periodical code that ran every 6 minutes and grabbed new route configs from an external resource and updated the application's route handlers to reflect the changes. 

This was done by deleting old handlers and adding new ones. Accidentally, it also added the same static handler all over again - even before the API route handlers. **As it turned out, this caused the extra 10ms response time hourly.**

### Takeaways from Netflix's Issue ###

- **Always know your dependencies** - first, you have to fully understand them before going into production with them.
- **Observability is key** - flame graphs helped the Netflix engineering team to get to the bottom of the issue.

> Read the full story here: [Node.js in Flames](http://techblog.netflix.com/2014/11/nodejs-in-flames.html).

#### Expert help when you need it the most ####

##### Commercial Node.js Support by RisingStack #####
[Learn more ](https://risingstack.com/nodejs-support?utm_source=rsblog&amp;utm_medium=roadblock-new&amp;utm_campaign=trace&amp;utm_content=/node-js-war-stories-solving-issues-in-production-2/) 

## RisingStack CTO: "Crypto takes time" ##

You may have already heard to story of how we [broke down the monolithic](https://www.youtube.com/watch?v=k9QZ4oIOHnk) infrastructure of [Trace *(our Node.js monitoring solution)*](https://trace.risingstack.com) into microservices from our CTO, Peter Marton.

**The issue we'll talk about now is a slowdown which affected Trace in production:**

As the very first versions of Trace ran on a PaaS, it used the public cloud to communicate with other services of ours. 

To ensure the integrity of our requests, we decided to sign all of them. To do so, we went with Joyent's [HTTP signing library](https://github.com/joyent/node-http-signature). What's really great about it, is that the [request](https://www.npmjs.com/package/request) module supports HTTP signature out of the box.

**This solution was not only expensive, but it also had a bad impact on our response times.**

![network delay in nodejs request visualized by trace](https://blog-assets.risingstack.com/2017/04/network-delay-in-nodejs-request-visualized-by-trace.png)

*The network delay built up our response times - photo: Trace*

As you can see on the graph above, the given endpoint had a response time of 180ms, however from that amount, **100ms was just the network delay between the two services alone**.

As the first step, we [migrated from the PaaS provider to use Kubernetes](/moving-node-js-from-paas-to-kubernetes-tutorial/). We expected that our response times would be a lot better, as we can leverage internal networking. 

> We were right - our latency improved.

However, we expected better results - and a lot bigger drop in our CPU usage. The next step was to do CPU profiling, just like the guys at Netflix:

![crypto sign function taking up cpu time](https://blog-assets.risingstack.com/2017/04/crypto-sign-function-taking-up-cpu-time.png)

As you can see on the screenshot, the `crypto.sign` function takes up most of the CPU time, by consuming 10ms on each request. To solve this, you have two options:

- if you are running in a trusted environment, you can drop request signing,
- if you are in an untrusted environment, you can scale up your machines to have stronger CPUs.

### Takeaways from Peter Marton ###

- **Latency in-between your services has a huge impact on user experience** - whenever you can, leverage internal networking.
- **Crypto can take a LOT of time**.

## nearForm: Don't block the Node.js Event Loop ##

**React is more popular than ever.** Developers use it for both the frontend and the backend, or they even take a step further and use it to build isomorphic JavaScript applications.

> However, rendering React pages can put some heavy load on the CPU, as rendering complex React components is CPU bound. 

When your Node.js process is rendering, it blocks the event loop because of its synchronous nature.

As a result, **the server can become entirely unresponsive** - requests accumulate, which all puts load on the CPU. 

What can be even worse is that even those requests will be served which no longer have a client - still putting load on the Node.js application, as [Matteo Collina](https://github.com/mcollina) of nearForm explains.

**It is not just React, but string operations in general.** If you are building JSON REST APIs, you should always pay attention to `JSON.parse` and `JSON.stringify`.

As Shubhra Kar from Strongloop (now Joyent) explained, parsing and stringifying huge payloads can take a lot of time as well *(and blocking the event loop in the meantime)*.

```
functionrequestHandler(req, res) {  
  const body = req.rawBody
  let parsedBody
  try {
    parsedBody = JSON.parse(body)
  }
  catch(e) {
     res.end(newError('Error parsing the body'))
  }
  res.end('Record successfully received')
}

```

*Simple request handler*

The example above shows a simple request handler, which just parses the body. For small payloads, it works like a charm - however, **if the JSON's size can be measured in megabytes, the execution time can be seconds** instead of milliseconds. The same applies for `JSON.stringify`.

To mitigate these issues, first, you have to know about them. For that, you can use Matteo's [loopbench](https://github.com/mcollina/loopbench) module, or [Trace](https://trace.risingstack.com)'s event loop metrics feature. 

With `loopbench`, you can return a status code of 503 to the load balancer, if the request cannot be fulfilled. To enable this feature, you have to use the `instance.overLimit` option. This way ELB or NGINX can retry it on a different backend, and the request may be served.

Once you know about the issue and understand it, you can start working on fixing it - you can do it either by leveraging Node.js streams or by tweaking the architecture you are using.

### Takeaways from nearForm ###

- **Always pay attention to CPU bound operations** - the more you have, to more pressure you put on your event loop.
- **String operations are CPU-heavy operations**

## Debugging Node.js Issues in Production ##

I hope these examples from Netflix, RisingStack & nearForm will help you to debug your Node.js apps in Production.

If you'd like to learn more, I recommend checking out these recent posts which will help you to deepen your Node knowledge:

- [Case Study: Finding a Node.js Memory Leak in Ghost](https://blog.risingstack.com/case-study-node-js-memory-leak-in-ghost/)
- [Understanding the Node.js Event Loop](https://blog.risingstack.com/node-js-at-scale-understanding-node-js-event-loop/)
- [Node.js Garbage Collection Explained](https://blog.risingstack.com/node-js-at-scale-node-js-garbage-collection/)
- [Node.js Async Best Practices & Avoiding the Callback Hell](https://blog.risingstack.com/node-js-async-best-practices-avoiding-callback-hell-node-js-at-scale/)
- [Event Sourcing with Examples in Node.js](https://blog.risingstack.com/event-sourcing-with-examples-node-js-at-scale/)
- [Getting Node.js Testing and TDD Right](https://blog.risingstack.com/getting-node-js-testing-and-tdd-right-node-js-at-scale/)
- [10 Best Practices for Writing Node.js REST APIs](https://blog.risingstack.com/10-best-practices-for-writing-node-js-rest-apis/)
- [Node.js End-to-End Testing with Nightwatch.js](https://blog.risingstack.com/end-to-end-testing-with-nightwatch-js-node-js-at-scale/)
- [The Definitive Guide for Monitoring Node.js Applications](https://blog.risingstack.com/monitoring-nodejs-applications-nodejs-at-scale/)

If you have any questions, please let us know in the comments!

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
