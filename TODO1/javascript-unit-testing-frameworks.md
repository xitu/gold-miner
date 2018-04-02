> * 原文地址：[JavaScript unit testing frameworks: Comparing Jasmine, Mocha, AVA, Tape and Jest](https://raygun.com/blog/javascript-unit-testing-frameworks/)
> * 原文作者：[Ben Harding](https://raygun.com/blog/javascript-unit-testing-frameworks/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/javascript-unit-testing-frameworks.md](https://github.com/xitu/gold-miner/blob/master/TODO1/javascript-unit-testing-frameworks.md)
> * 译者：
> * 校对者：

# JavaScript unit testing frameworks: Comparing Jasmine, Mocha, AVA, Tape and Jest

When starting development on a new front end project, I always ask myself two questions: “Which JavaScript unit testing frameworks should I use?” and “Should I even spend time adding tests?”

My colleagues often write about how unit tests are great for peace of mind and reducing software errors. So I **always make the time to test**. But which framework should you choose for your project? Before rushing into any decisions, I investigated five of the most popular JavaScript unit testing frameworks so you can decide which one is best for you.

> [Effective unit testing is only part of keeping your software error free. Make your JavaScript unit testing more robust by using these JavaScript debugging tips](https://raygun.com/javascript-debugging-tips).

**Note: If you have a favorite framework and don’t see it listed, let me know in the comments and I’ll add it to this article.**

## JavaScript Unit Testing Frameworks: A comparison

### Jasmine

![Jasmine is one of the JavaScript unit testing frameworks we compare](https://raygun.com/blog/wp-content/uploads/2017/05/Front-end-development-frameworks.png "Jasmine logo - behavior driven JavaScript")

One of the most popular JavaScript unit testing frameworks, [Jasmine](https://jasmine.github.io/) provides you with everything you need out-of-the-box.

*   Comes with assertions, spies, and mocks, so pretty much everything you may need to start developing your unit tests. Jasmine makes the initial setup easy and you can still add libraries if you really require unit functionality
*   Globals make it easy to start adding tests to your app right away. Although I dislike globals, Jasmine provides developers with everything you need out-of-the-box, and there isn’t much inconsistency  
*   I found the standalone version made it easy to see just how everything is setup and you can start playing around with it right away 
*   Integrates with [Angular 1](https://docs.angularjs.org/guide/unit-testing) and [Angular 2](https://docs.angularjs.org/guide/unit-testing) alongside many popular libraries today

**My thoughts on Jasmine**

I’m not a fan of having the globals populating the environment, so Jasmine does lose a few points in my book there. Otherwise, it has a good variety of features out-of-the-box. It does seem slightly “older” than the other frameworks on this list but that is not necessarily a bad thing and any pain points would have been encountered by others, meaning they should be easy to resolve.

### AVA

![AVA is one of the JavaScript unit testing frameworks we compare](https://raygun.com/blog/wp-content/uploads/2017/05/Front-end-development-frameworks-1.png "AVA logo")

A minimalistic testing library, [AVA](https://github.com/avajs/ava)  takes advantage of JavaScript’s async nature and runs tests concurrently, which, in turn, increases performance.

*   AVA doesn’t create any globals for you, therefore you can control more easily what you use. I think this brings extra clarity to the tests ensuring that you know exactly what is happening 
*   Taking advantage of the async nature of JavaScript makes testing extremely beneficial. The main benefit is minimizing the wait time between deployments
*   Contains a simple API which provides you with only what you need. This can be nice if you would like mocking support, but you’ll have to install a separate library
*   Snapshot testing is provided via [jest-snapshot](https://facebook.github.io/jest/blog/2016/07/27/jest-14.html) which is great when you’d like to know when your application’s UI changes unexpectedly.

**My thoughts on AVA**

Ava’s “[highly opinionated](https://github.com/avajs/ava#why-not-mocha-tape-tap)” minimalist approach, alongside them not populating the global environment, earns itself big points in my book. The simple API makes tests clear. AVA is certainly a library you should check out when selecting your JavaScript unit testing frameworks.

### Tape

![Tape is one of the JavaScript unit testing frameworks we compare](https://raygun.com/blog/wp-content/uploads/2017/05/Front-end-development-frameworks-2.png "An image of Tape ")

The most minimal of all the frameworks on the list, [Tape](https://github.com/substack/tape) is straight to the point and provides you with the bare essentials.  

*  Just like AVA, Tape doesn’t support globals, instead requiring you to include them yourself. This is nice as it doesn’t pollute the global environment
*   Tape contains no setup/teardown methods. Instead, it opts for a more modular system where you will need to define setup code explicitly in each test making each test more clear. It also stops the state being shared between tests
*   Typescript/coffeescript/es6 support 
*   Easy and fast to get up and running, Tape is a JavaScript file that you run anywhere that’s running JavaScript, without an overloading amount of configuration options

**My thoughts on Tape**

Tape contains an even lower-level, less feature-rich API than AVA, and is proud of it. Tape has kept everything simple, giving you only what you need and nothing more. This is why Tape rates highly in my book and one of the best JavaScript unit testing frameworks, as this allows you to focus more your efforts on your product and less on which tool to use.

### Mocha

![Mocha is one of the JavaScript unit testing frameworks we compare](https://raygun.com/blog/wp-content/uploads/2017/05/Front-end-development-frameworks-3.png "Mocha logo")

Arguably the most used library, [Mocha](https://mochajs.org/) is a flexible library providing developers with just the base test structure. Functionality for assertions, spies, mocks, and the like are then added via other libraries/plugins.

*   If you want a flexible configuration, including the libraries that you particularly need, then the additional set up and configuration required for Mocha is something you definitely need to check out
*   Unfortunately, the above point does have a downside, which is having to include additional libraries for assertions. This does mean that it’s a little harder, if not longer, to set up than others. That said, setting up is generally a one-time deal, but I do like being able to go a “single source truth” (documentation) instead of jumping around the show   
*   Mocha includes the test structure as globals, saving you time by not having to `include` or require it in every file. The downside is that plugins just might `require` you to include these anyway, leading to inconsistencies, and if you are OCD like me it will eventually drive you mad! 

**My thoughts on Mocha**

The extensibility and sheer number of different ways you can configure Mocha impresses me. Having to learn Mocha, then also having to learn the assertion library you choose does scare me a little though. Flexibility in its assertions, spies and mocks is highly beneficial.

## Jest

![Jest is one of the JavaScript unit testing frameworks we compare](https://raygun.com/blog/wp-content/uploads/2017/05/Front-end-development-frameworks-4.png "Jest logo")

Used and recommended by Facebook alongside a variety of React applications, [Jest](https://facebook.github.io/jest/) is well supported. Jest also reports a very fast testing library due to its [clever parallel testing](http://facebook.github.io/jest/blog/2016/03/11/javascript-unit-testing-performance.html).

*   For smaller projects you might not worry about this too much initially, having increased performance is great for larger projects wanting to [continuously deploy](https://raygun.com/blog/continuous-deployment/) their app throughout the day
*   Whilst developers primarily use Jest to test React applications, Jest can easily integrate into other applications allowing you to use it’s more unique features elsewhere
*   Snapshot testing is a great tool to ensure that your application’s UI doesn’t unexpectedly change between releases. Although more specifically designed and used in React, it does work with other frameworks if you can find the correct plugins 
*   Unlike other libraries on the list, Jest comes with a wide API, not requiring you to include additional libraries unless you really need to
[Jest continues to improve considerably](https://facebook.github.io/jest/blog/) with every update they make

**My thoughts on Jest**

Whilst the globals are a downside, Jest is a feature-rich library constantly being developed. It has a number of easily accessible guides to help out, and supports a variety of different environments which is great to see when building any project.

## Which Javascript unit testing framework should I use?

After looking into only a few of the many different frameworks out there I find myself coming to the conclusion that choosing a framework is not black and white.

Most frameworks (Mocha being the exception) provide you with what you need at the end of the day, which is a testing environment along with the mechanisms to ensure that given the X -> Y is always returned, with a few simply giving you more “bells and whistles.”

You should feel pretty confident in choosing any of them, and the choice in my mind depends what you and your particular project wants or needs.

*   **If you require a broad API along with specific (perhaps unique) features then Mocha would be your choice as the extensibility is there**
*   **AVA or Tape gives you the minimum requirements. Great for providing a solid minimal foundation for you to get going fast**
*   **If you have a large project, or would like to quickly get started without much configuration, then Jest would be a solid choice**

I hope this helps you in choosing your JavaScript unit testing frameworks in the future. If you’d like me to take a look at any other JavaScript unit testing frameworks, let me know in the comments! I’ll add them to the list later.


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
