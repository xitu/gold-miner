> * 原文地址：[Node.js Best Practices - How to become a better Node.js developer in 2018](https://nemethgergely.com/nodejs-best-practices-how-to-become-a-better-developer-in-2018/)
> * 原文作者：[GERGELY NEMETH](https://nemethgergely.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/nodejs-best-practices-how-to-become-a-better-developer-in-2018.md](https://github.com/xitu/gold-miner/blob/master/TODO/nodejs-best-practices-how-to-become-a-better-developer-in-2018.md)
> * 译者：
> * 校对者：

It became a tradition for me in the past two years to write recommendations for the next year on how one can become a better Node.js developer. This year is no exception! 🤗

If you are interested in my past new years’ recommendations, you can read them on the RisingStack blog:

* [How to Become a Better Node.js Developer in 2016](https://blog.risingstack.com/how-to-become-a-better-node-js-developer-in-2016/)
* [How to Become a Better Developer in 2017](https://blog.risingstack.com/node-js-best-practices-2017/)

Without further ado, let’s take a look at all the advice for 2018!

# Adopt `async-await`

With the release of Node.js 8, `async` functions became generally available. You can replace callbacks and write synchronously looking asynchronous code with their help.

But what are async functions? Let’s take a look at a recap of the [Node.js Async Function Best Practices](https://nemethgergely.com/async-function-best-practices/) article:

`async` functions let you write `Promise`-based code as if it were synchronous. Once you define a function using the `async` keyword, you can use the `await` keyword within the function’s body. When the `async` function is called, it returns with a `Promise`. When the `async` function returns a value, the `Promise` gets fulfilled, if the `async` function throws an error, it gets rejected.

The `await` keyword can be used to wait for a `Promise` to be resolved and return the fulfilled value. If the value passed to the `await` keyword is not a Promise, it converts the value to a resolved `Promise`.

If you’d like to master async functions, I recommend checking out the following resources:

* [Learning to throw again](https://hueniverse.com/learning-to-throw-again-79b498504d28)
* [Catching without awating](https://hueniverse.com/catching-without-awaiting-b2cb7df45790)
* [Node.js async function best practices](https://nemethgergely.com/async-function-best-practices/)

# Graceful shutdown for your applications

When you deploy a new version of your application, the old must be replaced. The process manager you are using _(no matter if it is Heroku, Kubernetes, supervisor or anything else)_ will first send a `SIGTERM` signal to the application to let it know, that it is going to be killed. Once it gets this signal, it should **stop accepting new requests, finish all the ongoing requests, and clean up the resources it used**. Resources may include database connections or file locks.

To make it easier, we have released an open-source module at GoDaddy called [terminus](https://github.com/godaddy/terminus) to help you implement graceful shutdown for your applications. [Check it out now! ☺️](https://github.com/godaddy/terminus)

# Adopt the same style-guide across the company

Adopting a style guide across a company of hundreds of developers can be quite challenging - to get everyone to agree to the same set of rules is almost an impossible challenge to solve.

To state the (probably) unpopular opinion: you will never get hundreds of developers to agree to the same set of rules, even if it has the obvious advantage to enable developers to easily move between projects, without going the extra mile to get used to a new (even if only a slightly different) style of writing code.

If you are working in such environment, I find it the best approach to trust a seasoned developer, who will have the final saying of what makes its way into the style guide, and what does not, with the help of all the others involved. It does not matter what they come up with _(let’s not start the semicolon wars)_, till they can get everyone to follow the same set of rules. There has to be a decision made at some point.

# Make security a requirement

We see more and more companies end up on [haveibeenpwned](https://haveibeenpwned.com/) - I bet you don’t want to be the next one. When you ship a new piece of code to your customers, code reviews should involve people with security expertise. If you don’t have that in-house, or they are super busy, a great way to solve this is to work with a company like [Lift Security](https://liftsecurity.io/reviews/).

You, as a developer should always try to keep your security knowledge in the best shape, too. For that purpose, I recommend reading the following resources:

* [Node.js Security Checklist](https://blog.risingstack.com/node-js-security-checklist/)
* [The Open Web Application Security Project website](https://www.owasp.org/index.php/Main_Page)
* [The Snyk blog](https://snyk.io/blog/)

# Talk at meetups or conferences

Another great way to become a better developer, and become better at expressing yourself is to speak at meetups and conferences. If you’ve never done that before, I’d recommend first to speak at a local meetup, then applying to national or international conferences.

I realize that public speaking can be tough - when I was preparing for my first talk ever, [Speaking.io](http://speaking.io/) helped a lot, I recommend checking that site out! Also, if you are just preparing to your give your first talk, and would love some feedback, just hit me up on [Twitter](https://twitter.com/nthgergo), and let’s chat. I’d love to help out! 🤗

Once you have the topic you’d like to talk about at a conference, check out the [Web conferences 2018](https://github.com/asciidisco/web-conferences-2018/blob/master/README.md) collection on GitHub for CFPs, it rocks!

# Write modules that directly use new browser APIs

[Mikeal](https://medium.com/@mikeal) published a great writing on [Modern Modules](https://medium.com/@mikeal/modern-modules-d99b6867b8f1) back in September. One of the takeaways I loved the most was to start writing modules using browser APIs, and polyfill Node.js if necessary. This has the obvious advantage of shipping smaller JavaScript assets to the browser (thus making page load times faster). On the other hand, no one cares if your backend dependencies are a bit heavier.

# Adopt the twelve-factor app principles

The Twelve-Factor application manifesto describes best practices on how web applications should be written, and it was on my list for this year as well.

With the rising adoption of Kuberentes and other orchestration engines, adhering to the twelve-factor application principles are getting more and more important. They cover the following areas:

1. [One codebase tracked in revision control, many deploys](http://12factor.net/codebase)
2. [Explicitly declare and isolate dependencies](http://12factor.net/dependencies)
3. [Store config in the environment](http://12factor.net/config)
4. [Treat backing services as attached resources](http://12factor.net/backing-services)
5. [Strictly separate build and run stages](http://12factor.net/build-release-run)
6. [Execute the app as one or more stateless processes](http://12factor.net/processes)
7. [Export services via port binding](http://12factor.net/port-binding)
8. [Scale out via the process model](http://12factor.net/concurrency)
9. [Maximize robustness with fast startup and graceful shutdown](http://12factor.net/disposability)
10. [Keep development, staging, and production as similar as possible](http://12factor.net/dev-prod-parity)
11. [Treat logs as event streams](http://12factor.net/logs)
12. [Run admin/management tasks as one-off processes](http://12factor.net/admin-processes)

# Learn the new ECMAScript features

Some of the new ECMAScript features can boost your productivity a lot. They enable you to write more self-explanatory code. Some of my personal favorites _(well, they are not that new, to be honest)_:

* [Spread syntax](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Spread_operator)
* [Rest paramaters](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Functions/rest_parameters)
* [Destructuring](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Destructuring_assignment)
* [Async functions](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/async_function)

If you’d like to get a full picture of new ECMAScript features, I recommend reading the book [ES6 & Beyond](https://github.com/getify/You-Dont-Know-JS/blob/master/es6%20&%20beyond/README.md#you-dont-know-js-es6--beyond).

* * *

What would you add to the list? Please let me know in the comments. 


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
