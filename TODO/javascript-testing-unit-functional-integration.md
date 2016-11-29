> * 原文地址：[JavaScript Testing: Unit vs Functional vs Integration Tests](http://www.sitepoint.com/javascript-testing-unit-functional-integration)
* 原文作者：[Eric Elliott](https://www.sitepoint.com/author/eelliott/)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[野火wildflame](http://github.com/wild-flame)
* 校对者：

# JavaScript Testing: Unit vs Functional vs Integration Tests
# JavaScript 测试︰ 单元 vs 功能 vs 集成测试

Unit tests, integration tests, and functional tests are all types of automated tests which form essential cornerstones of continuous delivery, a development methodology that allows you to safely ship changes to production in days or hours rather than months or years.

自动测试包括了单元测试、 集成测试和功能测试。自动测试是一种开发方法，它是持续不断迭代发布产品的基石，使你生产环境里的发布的能够在数小时，数天之内就发生改变，而不是按月或是按年而计。

Automated tests enhance software stability by catching more errors before software reaches the end user. They provide a safety net that allows developers to make changes without fear that they will unknowingly break something in the process.

自动测试通过捕捉更多的错误，增强了软件到达用户之前的稳定性。就好比是一张防护网一样，使开发者们在做更改的时候不必担心弄坏了东西。

## The Cost of Neglecting Tests

## 忽略测试的代价

### More from this author

*   [The Future of Programming: WebAssembly & Life After JavaScript](https://www.sitepoint.com/future-programming-webassembly-life-after-javascript/?utm_source=sitepoint&utm_medium=relatedinline&utm_term=&utm_campaign=relatedauthor)
（上面这段文字和本文内容无关，故我打算删掉，请校对过目。）

Contrary to popular intuition, maintaining a quality test suite can dramatically enhance developer productivity by catching errors immediately. Without them, end users encounter more bugs, which can lead to increased reliance on customer service, quality assurance teams, and bug reports.

与直觉相反，维护一个高质量的测试套件能够极大地提高开发人员的效率，（因为它使得开发人员）能够立即发现开发中的错误。反过来说，如果没有这些套件，用户会遇到更多的 Bug，从而导致需要投入更多的在用户服务，质量保证和错误报告上面。

Test Driven Development takes a little more time up front, but bugs that reach customers cost more in many ways:
测试驱动开发（TDD）在前期需要更多的时间，但是一旦 Bug 到了用户那里，你会付出更多的代价：

*   They interrupt the user experience, which can cost you in sales, usage metrics, they can even drive customers away permanently.
*   Every bug report must be validated by QA or developers.
*   Bug fixes are interruptions which cause a costly context switch. Each interruption can waste up to 20 minutes per bug, not counting the actual fix.
*   Bug diagnosis happens outside the normal context of feature development, sometimes by different developers who are unfamiliar with the code and the surrounding implications of it.
*   Opportunity cost: The development team must wait for bug fixes before they can continue working on the planned development roadmap.

- 它们会影响用户体验，而这会导致你销量下降，用户减少，甚至赶走潜在的客户。
所有的错误报告都必须被 QA 或者开发者亲自验证。
修补这些 Bug 会耗费你大量的时间，因为它导致你必须停下手头的工作。粗略估计每一个 Bug 都将浪费你 20分钟的时间，而这还没有算你修补它们的时间。
有时候，诊断这些 Bug 的人并不是开发它们的人，这导致了开发人员对代码的不熟悉。
机会成本：开发团队必须等到 Bug 被修补以后，才能继续按照计划开发。

The cost of a bug that makes it into production is many times larger than the cost of a bug caught by an automated test suite. In other words, TDD has an overwhelmingly positive ROI.
在生产环境里的 Bug 使你付出的代价往往要数倍于在自动化测试时发现的。换句话说，在计算算投资与回报时，测试驱动开发（TDD）具有压倒性的优势。

## Different Types of Tests
## 不同的测试类型

The first thing you need to understand about different types of tests is that they all have a job to do. They play important roles in continuous delivery.

你需要了解的第一件事情就是，每一种测试都有它自己的作用。他们都在软件的持续迭代发布中起了重要的作用。

A while back, I was consulting on an ambitious project where the team was having a hard time building a reliable test suite. Because it was hard to use and understand, it rarely got used or maintained.

前阵子，我为一个野心勃勃的项目做了咨询，他们为了建立一个可靠的测试套件可为煞费苦心。因为，由于现有套件很难使用和理解，它基本上没有被维护和使用。

One of the problems I observed with the existing test suite is that it confused unit tests, functional tests, and integration tests. It made absolutely no distinction between any of them.

我观察到的其中一个问题就是，现有套件混淆了单元，功能和集成测试。他们之间没有明显的区别。

The result was a test suite that was not particularly well suited for anything.

其结果是现有测试套件不适合任何一个测试套件。

## Roles Tests Play in Continuous Delivery

## 在持续迭代发布中它们所扮演的角色

Each type of test has a unique role to play. You don’t choose between unit tests, functional tests, and integration tests. Use all of them, and make sure you can run each type of test suite in isolation from the others.

每种类型的测试可以发挥其独特的作用。你不用选择在单元测试、 功能测试和集成测试中做选择。因为你会使用它们所有，并确保您也可以独立的运行每种类型的测试套件。

Most apps will require both unit tests and functional tests, and many complex apps will also require integration tests.

大多数应用程序都需要单元测试和功能测试，而许多复杂的应用程序在此基础上，还需要集成测试。

*   **Unit tests** ensure that individual components of the app work as expected. Assertions test the component API.
*   **Integration tests** ensure that component collaborations work as expected. Assertions may test component API, UI, or side-effects (such as database I/O, logging, etc…)
*   **Functional tests** ensure that the app works as expected from the user’s perspective. Assertions primarily test the user interface.

**单元测试** 用来确保每个组件正常工作 —— 测试组件 API
**集成测试** 用来确保不同组件互相合作 —— 测试组件 API, UI, 或者副作用。
（译注：校对看看 side-effects 这里是啥意思，我知道的 side-effect 是副作用的意思，但我感觉我理解不能。）

**功能测试** 用来确保整个应用会按照用户期望的那样运行 —— 主要测试界面

You should isolate unit tests, integration tests, and functional tests from each other so that you can easily run them separately during different phases of development. During continuous integration, tests are frequently used in three ways:

你应该把单元，集成和功能测试互相隔离开来，这样你就可以在开发时分别的运行它们。在持续的集成过程中，测试一般会出现在下面三个阶段。

*   **During development**, for developer feedback. Unit tests are particularly helpful here.
*   **In the staging environment**, to detect problems and stop the deploy process if something goes wrong. Typically the full suite of all test types are run at this stage.
*   **In the production environment**, a subset of production-safe functional tests known as smoke tests are run to ensure that none of the critical functionality was broken during the deploy process.
**开发阶段**，主要是程序员反馈。这时单元测试很有用。
**在中间阶段**，主要是能够在发现问题时立刻停下来。这时各种测试都很有用。
**在生产环境**，主要是运行测试套件中一个叫做「冒烟测试」的子集，确保部署的时候没有弄坏什么东西。

Which Test Types Should You Use? All of Them.
如果你问我该使用那个测试？**所有的。**

In order to understand how different tests fit in your software development process, you need to understand that each kind of test has a job to do, and those tests roughly fall into three broad categories:

为了了解如何在您的软件开发过程选择不同测试，你需要了解每种测试它的工作要做，那些测试大致可分为三大类︰

*   User experience tests (end user experience)
*   Developer API tests (developer experience)
*   Infrastructure tests (load tests, network integration tests, etc…)

用户体验测试 （最终用户体验）
* 开发 API 测试 （开发人员体验）
* 基础设施测试 (负载测试、 网络集成测试等。......)

User experience tests examine the system from the perspective of the user, using the actual user interface, typically using the target platforms or devices.

用户体验测试从用户的角度来测试，使用实际的用户界面，通常是目标平台或设备。

Developer API tests examine the system from the perspective of a developer. When I say API, I don’t mean HTTP APIs. I mean the surface area API of a unit: the interface used by developers to interact with the module, function, class, etc…

API 测试则从开发者的角度来做测试。我说的可不是 Http API。我说的是一个单元的接口，即开发者创建出来用来和其他模块或者类交互的部分。

## Unit Tests: Realtime Developer Feedback

单元测试：实时的开发者反馈

Unit tests ensure that individual components work in isolation from each other. Units are typically modules, functions, etc…

单元测试是确保单个组件的工作彼此隔绝。一个单元，通常是一个模块、 功能等等...

For example, your app may need to route URLs to route handlers. A unit test may be written against the URL parser to ensure that the relevant components of the URL are parsed correctly. Another unit test might ensure that the router calls the correct handler for a given URL.

比方说，您的应用程序可能需要路由一个 URL 到路由处理程序。一个单元测试就用来确保此 URL 解析器正确的解析 URL。而另一个单元测试可能确保路由器为给定的 URL 调用了正确的处理程序。

However, if you want to test that when a specific URL is posted to, a corresponding record gets added to the database, that would be an integration test, not a unit test.

然而，如果你想测试，接收到特定的 post 请求以后，在数据库添加对应的记录，那么这就是集成测试，而不是单元测试。

Unit tests are frequently used as a developer feedback mechanism during development. For example, I run lint and unit tests on every file change and monitor the results in a development console which gives me real-time feedback as I’m working.

单元测试常常被用来开发者的反馈机制。比方说，我在工作时，会在我每一次更改之后运行 lint 和单元测试，在 console 里检测运行的结果。

![Running tests on file change](https://dab1nmslvvntp.cloudfront.net/wp-content/uploads/2016/04/1461566883dev-console-animated-small.gif)

For this to work well, unit tests must run very quickly, which means that asynchronous operations such as network and file I/O should be avoided in unit tests.

为了实现这个目的，单元测试必须很快，也就是说，在单元测试里，一切异步的操作都应该在被避免。

Since integration tests and functional tests very frequently rely on network connections and file I/O, they tend to significantly slow down the test run when there are lots of tests, which can stretch the run time from milliseconds into minutes. In the case of very large apps, a complete functional test run can take more than an hour.

自集成测试和功能测试非常频繁地依赖于网络连接和文件 I/O，他们会显著减慢测试的速度。当有很多的测试的时候，可以运行的时间可以从毫秒数到几分钟。对于非常大的应用程序，运行完整的测试可以用一个多小时。


Unit tests should be:

单元测试应该

*   Dead simple.
*   Lightning fast.
*   A good bug report.

炒鸡简单
迅雷不及掩耳之势
有一个好的报告

What do I mean by “a good bug report?”

什么事「好的报告」？

I mean that whatever test runner and assertion library you use, a failing unit test should tell you at a glance:

「好的报告」就是能够一眼就告诉你，

1.  Which component is under test?
2.  What is the expected behavior?
3.  What was the actual result?
4.  What is the expected result?
5.  How is the behavior reproduced?

1. 什么组件被测试 ing
2. 你期望什么行为
3. 实际是什么结果
4. 你期望什么结果
5. 为什么会这样

The first four questions should be visible in the failure report. The last question should be clear from the test’s implementation. Some assertion types are not capable of answering all those questions in a failure report, but most `equal`, `same`, or `deepEqual` assertions should. In fact, if those were the only assertions in any assertion library, most test suites would probably be better off. Simplify.

前四个问题应在故障报告中清晰可见，而最后的那个问题应该从测试的执行很清楚的中找到。当然，有一些断言的类型是不能回答所有这些问题的，但大部分的问题 ‘equal’、 ’same'，或者 'deepEqual’ 都应改可以做到。事实上，如果那些断言是现有断言库里的唯一断言，现存的大多数测试套件可能会更好。大道至简！

Here are some simple unit test examples from real projects using [Tape](https://medium.com/javascript-scene/why-i-use-tape-instead-of-mocha-so-should-you-6aa105d8eaf4):

下面这个是我在实际项目中使用 Tape 的做单元测试的例子：

    // Ensure that the initial state of the "hello" reducer gets set correctly
    import test from 'tape';
    import hello from 'store/reducers/hello';

    test('...initial', assert => {
      const message = `should set { mode: 'display', subject: 'world' }`;

      const expected = {
        mode: 'display',
        subject: 'World'
      };

      const actual = hello();

      assert.deepEqual(actual, expected, message);
      assert.end();
    });

    // Asynchronous test to ensure that a password hash is created as expected.
    import test from 'tape',
    import credential from '../credential';

    test('hash', function (t) {
      // Create a password record
      const pw = credential();

      // Asynchronously create the password hash
      pw.hash('foo', function (err, hash) {
        t.error(err, 'should not throw an error');

        t.ok(JSON.parse(hash).hash,
          'should be a json string representing the hash.');

        t.end();
      });
    });

## Integration Tests

## 集成测试

Integration tests ensure that various units work together correctly. For example, a Node route handler might take a logger as a dependency. An integration test might hit that route and test that the connection was properly logged.

集成测试确保各组件一起正常工作。例如，节点路由处理程序可能需要一个记录器（logger）作为依赖。集成测试可测试路由和连接被正确的记录。

In this case, we have two units under test:
这里有两个组件同时被测试了：

1.  The route handler
2.  The logger

1. 路由处理器（Route handler）
2. 记录器（Logger）

If we were unit testing the logger, our tests wouldn’t invoke the route handler, or know anything about it.

如果我们对记录器做单元测试。我们不会了解和路由处理相关的任何内容。

If we were unit testing the route handler, our tests would stub the logger, and ignore the interactions with it, testing only whether or not the route responded appropriately to the faked request.

如果我们队路由处理器做但也测试。我们不会管记录器，或者与它有任何交互。我们只会对路由做假的请求来测试。

Let’s look at this in more depth. The route handler is a factory function which uses dependency injection to inject the logger into the route handler. Let’s look at the signature (See the [rtype docs](https://github.com/ericelliott/rtype) for help reading signatures):

进一步说。路由处理器是一个工厂方法，靠依赖注入来注入进记录器里。让我们来看看 signature：

（译注：我不太懂依赖注入和工厂方法，这句可能翻译的不对，请校对帮帮忙！）


    createRoute({ logger: LoggerInstance }) => RouteHandler

Let’s see how we can test this:

让我们看看如何测试它：

    import test from 'tape';

    import createLog from 'shared/logger';
    import routeRoute from 'routes/my-route';

    test('logger/route integration', assert => {
      const msg = 'Logger logs router calls to memory';

      const logMsg = 'hello';
      const url = `http://127.0.0.1/msg/${ logMsg }`;

      const logger = createLog({ output: 'memory' });
      const routeHandler = createRoute({ logger });

      routeHandler({ url });

      const actual = logger.memoryLog[0];
      const expected = logMsg;

      assert.equal(actual, expected, msg);
      assert.end();
    });

We’ll walk through the important bits in more detail. First, we create the logger and tell it to log in memory:

我们来看看比较重要的细节。首先，我们创建一个 logger，然后在 memory 里做记录：

    const logger = createLog({ output: 'memory' });

Create the router and pass in the logger dependency. This is how the router accesses the logger API. Note that in your unit tests, you can stub the logger and test the route in isolation:

创建一个 router，然后把 logger 的依赖传过去

    const routeHandler = createRoute({ logger });

Call the route handler with a fake request object to test the logging:

向路由处理器发出假的请求，来测试记录的功能。

    routeHandler({ url });

The logger should respond by adding the message to the in-memory log. All we need to do now is check to see if the message is there:

记录器应该返回内存里的 log。我们只需要检查下面的信息：

      const actual = logger.memoryLog[0];

Similarly, for APIs that write to a database, you can connect to the database and check to see if the data is updated correctly, etc…

类似的，对于有数据库读写的操作，你可以连接到数据库，检查数据是不是在那里，等等……

Many integration tests test interactions with services, such as 3rd party APIs, and may need to hit the network in order to work. For this reason, integration tests should always be kept separate from unit tests, in order to keep the unit tests running as quickly as they can.

很多集成测试测试相互作用提供服务，如第三方的 Api，并可能需要网络才能正常工作。为此，集成测试应与单元测试分开，以保持尽可能快地运行单元测试。


## Functional Tests

## 功能测试

Functional tests are automated tests which ensure that your application does what it’s supposed to do from the point of view of the user. Functional tests feed input to the user interface, and make assertions about the output that ensure that the software responds the way it should.

功能测试是确保您的应用程序从用户的角度来看正常运行的自动化测试。功能测试测试用户的界面，输入和输出，确保软件按照期望方式做出响应。

Functional tests are sometimes called end-to-end tests because they test the entire application, and it’s hardware and networking infrastructure, from the front end UI to the back end database systems. In that sense, functional tests are also a form of integration testing, ensuring that machines and component collaborations are working as expected.

功能测试有时被称为端到端测试，因为他们测试整个应用程序，已经它相关的硬件和网络基础设施，从前端 UI 到后端数据库系统。在这个意义上，功能测试也是一种集成测试，确保机器和组件的都按期望工作。

Functional tests typically have thorough tests for “happy paths” — ensuring the critical app capabilities, such as user logins, signups, purchase work flows, and all the critical user workflows all behave as expected.

功能测试通常会彻底测试"最佳路径” — — 确保关键应用程序的功能，如用户登录、 注册，购买和工作相关的关键工作流的行为符合预期。


Functional tests should be able to run in the cloud on services such as [Sauce Labs](https://saucelabs.com/), which typically use the [WebDriver API](https://www.w3.org/TR/2016/WD-webdriver-20160120/) via projects like Selenium.

通过 Selenium 这类项目，功能测试能在诸如 Sauce Labs 这样的云服务上正确运行。

That takes a bit of juggling. Luckily, there are some great open source projects that make it fairly easy.

这可能有点奇技淫巧/奇淫技巧。幸运的是，我们有不少开源项目，这使得这件事简单不少。

My favorite is [Nightwatch.js](http://nightwatchjs.org/). Here’s what a simple Nightwatch functional test suite looks like this example from the Nightwatch docs:

我个人最喜欢的是守夜人项目 —— Nightwatch.js。从守夜人项目文档中可以看到，一个简单的守夜人功能测试套件像看起来是这样︰

    module.exports = {
      'Demo test Google' : function (browser) {
        browser
          .url('http://www.google.com')
          .waitForElementVisible('body', 1000)
          .setValue('input[type=text]', 'nightwatch')
          .waitForElementVisible('button[name=btnG]', 1000)
          .click('button[name=btnG]')
          .pause(1000)
          .assert.containsText('#main', 'Night Watch')
          .end();
      }
    };

As you can see, functional tests hit real URLs, both in staging environments, and in production. They work by simulating actions the end user might take in order to accomplish their goals in your app. They can click buttons, input text, wait for things to happen on the page, and make assertions by looking at the actual UI output.

正如你所看到的，在中间环境中，和在生产环境中，功能测试点击真实的 Url，他们通过模拟用户的真实操作来工作。他们可以单击按钮、 输入文本、 等待待页面上的更新，通过检验页面 UI 来做断言。

### Smoke Tests

### 烟雾测试

After you deploy a new release to production, it’s important to find out right away whether or not it’s working as expected in the production environment. You don’t want your users to find the bugs before you do — it could chase them away!

当你部署了一个新的发布到生产环境后，很重要的一点就是确定它是否正常工作。你不希望你的用户比你还先发现错误 —— 因为这会赶走他们！

It’s important to maintain a suite of automated functional tests that act like smoke tests for your newly deployed releases. Test all the critical functionality in your app: The stuff that most users will encounter in a typical session.

维护一份自动化的功能测试 - 比方说烟雾测试，是很重要的。测试你应用中所有的重要功能。那些用户在日常操作中会遇到的请求。

Smoke tests are not the only use for functional tests, but in my opinion, they’re the most valuable.

烟雾测试不是功能测试的唯一作用， 但是在我看来，却是最有意义的

## What Is Continuous Delivery?

## 为什么要持续迭代发布产品？

Prior to the continuous delivery revolution, software was released using a waterfall process. Software would go through the following steps, one at a time. Each step had to be completed before moving on to the next:

在持续交付革命之前，软件发布都是使用瀑布过程。软件发布通过以下步骤，一次一个，每一步不得移到下一步之前完成︰

1.  Requirement gathering
2.  Design
3.  Implementation
4.  Verification
5.  Deployment
6.  Maintenance
1. 收集需求
2. 设计
3. 实现
4. 检验
5. 部署
6. 维护

It’s called waterfall because if you chart it with time running from right to left, it looks like a waterfall cascading from one task to the next. In other words, in theory, you can’t really do these things concurrently.

它之所以被称为瀑布，是因为如果你记录它从右到左的运行的时间，它看起来像从一个任务到下一个级联的瀑布。换句话说，在理论上你不能同时做这些事情。

In theory. In reality, a lot of project scope is discovered as the project is being developed, and scope creep often leads to disastrous project delays and rework. Inevitably, the business team will also want “simple changes” made after delivery without going through the whole expensive, time-consuming waterfall process again, which frequently results in an endless cycle of change management meetings and production hot fixes.

理论上（译注：这是作者打错了？怎么又是理论上又是实际上...），实际上，很多正在开发的项目的需求是在开发中才被发现的，而范围的变化常常导致灾难性的工程延误和返工。不可避免地，业务团队也会想"简单的改变”在发布后的产品，而不打算通过整个昂贵、 耗时的瀑布式的过程，这经常导致在无限循环的变化管理会议和产品热修复。

A clean waterfall process is probably a myth. I’ve had a long career and consulted with hundreds of companies, and I’ve never seen the theoretical waterfall work the way it’s supposed to in real life. Typical waterfall release cycles can take months or years.

一个理论上的瀑布过程可能只是一个神话。在我的长长的职业生涯中，我与数百家企业，进行了磋商，但我从没见在真正的生产中见过完美的瀑布。典型的瀑布的发布周期可能会是几个月或几年。

## The Continuous Delivery Solution

## 持续迭代的解决办法

Continuous delivery is a development methodology that acknowledges that scope is uncovered as the project progresses, and encourages incremental improvements to software in short cycles that ensure that software can be released at any time without causing problems.

持续迭代法不是一种开发方法，承认需求是随着项目的进展而被挖掘的，鼓励在短周期内增量改进软件，并确保不会导致问题，在任何时候软件发布。

With continuous delivery, changes can ship safely in a matter of hours.

有了持续迭代，软件的改进可以在短短数小时内就上线。

In contrast to the waterfall method, I’ve seen the continuous delivery process running smoothly at dozens of organizations — but I’ve never seen it work anywhere without a quality array of test suites that includes both unit tests and functional tests, and frequently includes integration tests, as well.

对比瀑布方案，我在无数的企业组织中都见过迭代开发顺利进行 —— 但我从没见过哪一个是在没有单元和功能的测试组件的情况下完成的，通常，测试组件也会包括集成测试。

Hopefully now you have everything you need to get started on your continuous delivery foundations.

希望我的这篇文章告诉了你开始迭代发布所需要知道的所有内容。

## Conclusion

As you can see, each type of test has an important part to play. Unit tests for fast developer feedback, integration tests to cover all the corner cases of component integrations, and functional tests to make sure everything works right for the end users.

正如你所看到的，每种类型的测试发挥了重要作用。单元测试能够快速的反馈开发者，集成测试会覆盖所有的角落的组件，而功能测试确保一切最终用户的那里的情况一切正常。
。

How do you use automated tests in your code, and how does it impact your confidence and productivity? Let me know in the comments.
至于您如何使用自动的测试您的代码，以及它们如何影响您的信心和生产力？请亲们尽情的留下评论！
