> * 原文地址：[8 Tips to Build Better Node.js Apps in 2018](https://blog.risingstack.com/node-js-development-tips-2018/)
> * 原文作者：[Bertalan Miklos](https://twitter.com/@solkimicreb)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/node-js-development-tips-2018.md](https://github.com/xitu/gold-miner/blob/master/TODO/node-js-development-tips-2018.md)
> * 译者：
> * 校对者：

# 8 Tips to Build Better Node.js Apps in 2018

In the previous two years we covered best practices for writing and operating Node.js applications (read the [2016 edition](https://blog.risingstack.com/how-to-become-a-better-node-js-developer-in-2016/) & [2017 edition](https://blog.risingstack.com/node-js-best-practices-2017/)). Another year has passed, so it’s time to revisit the topic of becoming a better developer!

In this article, we collected a few tips that we think Node.js developers should follow in 2018. Feel free to pick some development related New Year's resolutions!

## Tip #1: Use `async` - `await`

Async - await landed in Node.js 8 with a boom. It changed how we handle async events and simplified previously mind-boggling code bases. If you are not yet using `async` - `await` read our [introductory blog post](https://blog.risingstack.com/mastering-async-await-in-nodejs/).

Refreshing your knowledge about old school [async programming and Promises](https://blog.risingstack.com/node-hero-async-programming-in-node-js/) may also help.

## Tip #2: Get acquainted with `import` and `import()`

ES modules are already widely used with transpilers or the [@std/esm](https://github.com/standard-things/esm) library. They are natively supported since Node.js 8.5 behind the `--experimental-modules` flag, but there is still a long way until they become production ready.

We suggest you to learn the foundations now and follow the progress in 2018. You can find a simple ES modules tutorial with Node.js [here](http://2ality.com/2017/09/native-esm-node.html).

## Tip #3: Get familiar with HTTP/2

HTTP/2 is available since Node.js 8.8 without a flag. It has server push and multiplexing, which paves the way for efficient native module loading in browsers. Some frameworks - like Koa and Hapi - partially support it. Others - like Express and Meteor - are working on the support.

HTTP/2 is still experimental in Node.js, but we expect 2018 to bring wide adoption with a lot of new libraries. You can learn more about the topic in our [HTTP/2 blog post](https://blog.risingstack.com/node-js-http-2-push/).

## Tip #4: Get rid of code style controversies

[Prettier](https://github.com/prettier/prettier) was a big hit in 2017. It is an opinionated code formatter, which formats your code instead of simple code style warnings. There are still code quality errors - such as [no-unused-vars](http://eslint.org/docs/rules/no-unused-vars) and [no-implicit-globals](http://eslint.org/docs/rules/no-implicit-globals) - that can not be automatically reformatted.

The bottom line is, that you should use Prettier together with your good old fashioned linter in your upcoming projects. It helps a lot, especially if you have people with dyslexia in your team.

## Tip #5: Secure your Node.js applications

There are big [security breaches](https://en.wikipedia.org/wiki/List_of_data_breaches) and newly found vulnerabilities every year, and 2017 was no exception. Security is a rapidly changing topic, which can not be ignored. To get started with Node.js security, read our [Node.js Security Checklist](https://blog.risingstack.com/node-js-security-checklist/).

If you think your application is already secure, you can use [Snyk](https://snyk.io/) and the [Node Security Platform](https://nodesecurity.io/) to find sneaky vulnerabilities.

## Tip #6: Embrace microservices

If you have deployment issues or upcoming large-scale projects, it may be time to embrace the microservices architecture. Learn these two techs to stay up to date in 2018's microservices scene.

> [Docker](https://www.docker.com/) is a software technology providing containers, which wrap up a piece of software in a complete filesystem that contains everything it needs to run: code, runtime, system tools and system libraries.

> [Kubernetes](https://kubernetes.io/) is an open-source system for automating deployment, scaling, and management of containerized applications.

Before getting too deep into containers and orchestration, you can warm up by improving your existing code. Follow the [12-factor app](https://12factor.net/) methodology, and you will have a much easier time containerizing and deploying your services.

## Tip #7: Monitor your services

Fix issues before your users even notice them. Monitoring and alerting is a crucial part of production deployment, but taming a complex microservice system is no easy feat. Luckily this is a rapidly evolving field, with ever-improving tools. Check out what the [future of monitoring holds](https://blog.risingstack.com/the-future-of-microservices-monitoring-and-instrumentation/) or learn about the recent [OpenTracing standard](https://blog.risingstack.com/distributed-tracing-opentracing-node-js/).

If you are a more practical person [our Prometheus tutorial](https://blog.risingstack.com/node-js-performance-monitoring-with-prometheus/) gives a nice intro to the world of monitoring.

## Tip #8: Contribute to open-source projects

Do you have some favorite Node.js projects? Chances are that they could use your help to become even better. Just find an issue that matches your interest and jump into coding.

If you don't know how to get started, run through [these quick tips](https://egghead.io/articles/get-started-contributing-to-javascript-open-source) or [watch this course](https://egghead.io/courses/how-to-contribute-to-an-open-source-project-on-github) about open-source contribution on GitHub. Doing is the best way of learning, especially for programmers.

## What's your Node.js Development advice?

What else would you recommend to your fellow Node.js developers to get right in 2018? Leave your opinion in the comments section!

**We hope that you will have an awesome 2018. Happy coding!**

[Follow @RisingStack](https://twitter.com/RisingStack)


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
