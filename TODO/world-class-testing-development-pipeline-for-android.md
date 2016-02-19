* 原文链接 : [World-Class Testing Development Pipeline for Android - Part 1.](http://blog.karumi.com/world-class-testing-development-pipeline-for-android/)
* 原文作者 : [Karumi](hello@karumi.com)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [认领地址](https://github.com/xitu/gold-miner/issues/111)
* 校对者: 
* 状态 : 认领中

# 世界级的 Android 测试流程（一）

After developing mobile applications and collaborating with manual QA teams for several years we decided to start writing tests. We knew that, as engineers, **test automation is the key to successful mobile development.** In this blog post we’d like to share how our story, the Karumi testing story, started several years ago. This is the first blog post of a series where we will cover all aspects of world-class testing development pipeline for Android.

A couple of years ago we started writing tests for mobile applications. We had limited testing knowledge so we focused on acceptance and unit tests using the most common frameworks, a simple test runner and a mocking library. After some time we ran into problems:

- We had no idea what to test and how to test it.
- Our code was not ready to be tested.
- We were obsessed with Mike Cohn’s Test Pyramid without thinking about the type of software we were writing.
- Just because our tests were passing didn’t mean the code was working.

Scary, right? We spent a lot of time trying to tackle these challenges and at some point we realized the approach wasn’t correct. Even with a high test coverage, our software was failing. Worst of all, we were getting no feedback whatsoever from our tests. **The key to start solving our problems was identifying the problems we continuously ran into:**

- Our acceptance tests were too difficult to write because we needed to use a provisioning API to simulate an initial state for an acceptance test.
- Most of the time our tests were failing randomly and we didn’t know why. Just by repeating the build we passed our tests.
- We had tons of unit tests and high coverage, but our unit tests never failed. Our tests were passing even when the application was not working.
- Most of the time we were verifying calls to mocks.
- We had to use some “magic” testing tools to test our code, a private method or to mock the result of a static method invocation.

At this point we decided to stop writing tests and started thinking about why we didn’t feel comfortable with our tests. We needed to find a solution to this problem, fast. Our project was telling us we were doing it wrong, we needed a solution, **we needed a testing development pipeline**. That said, a testing development pipeline is not always the first thing to fix in order to improve your project quality.

**A testing development pipeline defines what to test and how**. What are the tools to use and why? What is the scope of our tests? **Even with a good testing development pipeline one needs a testable code to be confident enough to write tests**, because most of the tests are impossible, or at least, really difficult to write. The test closest to the code and related to a unit or integration scope is not always easy to write if your code is not ready. Therefore, we decided to first identify the problems in our application and then fix them with these goals in mind. The question was: if our code could be perfect, what would we expect from it? The expectations were:

- The application had to be testable.
- The code had to be readable.
- The responsibility had to be clear and structured.
- The coupling had to be low and the cohesion high.
- The code had to be honest.

The code prior to the refactor was a mess. The software responsibility was missing between lines and lines of UI code. The implementation details were completely exposed, activities and fragments were responsible for handling the state of the software, and it was all over the place. Furthermore, our business logic was completely coupled to the framework. Given these problems we decided to change the application architecture to something with more structure. **The architecture we used is named [“Clean Architecture”](https://blog.8thlight.com/uncle-bob/2012/08/13/the-clean-architecture.html). In addition to the key concepts of the architecture, we applied some patterns related to the GUI applications like MVP or MVVM and patterns related to data handling such as the Repository pattern**. Architecture details are not relevant for this blog post (we will discuss it in future posts), **the key element** of the “Clean Architecture” is related to **one of the most important SOLID principles, the [Dependency Inversion Principle](http://martinfowler.com/articles/dipInTheWild.html)**.

**The Dependency Inversion Principle specifies that your code should always depend on abstractions and not concretions**. This principle, just this simple principle was the key to success. It was **the key to changing our code and adapting our testing strategies to effectively tackle the problem at hand**. Depending on abstractions is neither related to dependency injection frameworks nor to always using a Java Interface to define your class API. However, it is related to hiding implementation details. Creating layers with different roles, points where the software responsibility changes and points to introduce a [TestDouble](http://www.martinfowler.com/bliki/TestDouble.html) much limit the scope of the test.

**We were able to choose the right amount of code to test by respecting the dependency inversion principle**. Once these points were clear, we stop writing tests full of mocks. We were able to use the exact number of mocks to cover a test case, making sure we were testing the state of the software and not only the interactions between components.

Once the application architecture was clear we started **to define our testing development pipeline. We were aiming to answer two questions: What do we want to test? How do we want to test it?** After trying to find out how to split the tests and write them in an easy and readable way, we noticed that the layer separations were the perfect starting point. As a result, the solution became clear:

What do we want to test?

- We want to test our business logic independently of any framework or library.
- We want to test our API integration.
- We want to test our integration with our persistence framework.
- We want to test some generic UI components.
- We want to test acceptance criteria written from the user’s point of view in a completely black box scenario.

How do we want to test it?

- This is something we will talk about in the next blog post, stay tuned! ;)

References:

- World-Class Testing Development Pipeline for Android slides by Pedro Vicente Gómez Sánchez. [http://www.slideshare.net/PedroVicenteGmezSnch/worldclass-testing-development-pipeline-for-android](http://www.slideshare.net/PedroVicenteGmezSnch/worldclass-testing-development-pipeline-for-android)
- Mike Cohn’s Test Pyramid by Martin Fowler. [http://martinfowler.com/bliki/TestPyramid.html](http://martinfowler.com/bliki/TestPyramid.html)
- Clean Architecture by Uncle Bob. [https://blog.8thlight.com/uncle-bob/2012/08/13/the-clean-architecture.html](https://blog.8thlight.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- DIP in the Wild by Martin Fowler.[http://martinfowler.com/articles/dipInTheWild.html](http://martinfowler.com/articles/dipInTheWild.html)
- Test Double by Martin Fowler. [http://www.martinfowler.com/bliki/TestDouble.html](http://www.martinfowler.com/bliki/TestDouble.html)

