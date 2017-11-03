> * 原文地址：[JavaScript Testing: Unit vs Functional vs Integration Tests](http://www.sitepoint.com/javascript-testing-unit-functional-integration)
* 原文作者：[Eric Elliott](https://www.sitepoint.com/author/eelliott/)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[wild-flame](http://github.com/wild-flame)
* 校对者：[marcmoore](https://github.com/marcmoore)、[Tina92](https://github.com/Tina92)

# JavaScript 测试︰ 单元 vs 功能 vs 集成测试

单元测试、集成测试、功能测试这些自动化测试方法，是项目持续部署的基础。作为一种研发方式，它能帮助你在短时间内安全的发布新特性，而不用等上几个月甚至几年。

自动测试通过捕捉更多的错误，增强了软件到达用户之前的稳定性。就好比是一张防护网一样，使开发者们在做更改的时候不必担心引发未知的错误。

## 忽略测试的代价

与直觉相反，维护一个高质量的测试套件能够极大地提高开发人员的效率，因为它使得开发人员能够立即发现开发中的错误。反过来说，如果没有这些套件，终端用户会遇到更多的 Bug，从而导致需要在用户服务，质量保证和错误报告上面投入更多的资源。

测试驱动开发（TDD）在前期需要更多的时间，但是一旦 Bug 到了用户那里，你会付出更多的代价：

*   它们会影响用户体验，而这会导致你销量下降，用户减少，甚至赶走潜在的客户。
*   所有的错误报告都必须被 QA 或者开发者亲自验证。
*   修补这些 Bug 会耗费你大量的时间，因为它导致你必须停下手头的工作。粗略估计每一个 Bug 都将浪费你 20 分钟的时间，而这还没有算你修补它们的时间。
*   有时候，诊断这些 Bug 的人并不是开发它们的人，这导致了开发人员对代码的不熟悉。
*   机会成本：开发团队必须等到 Bug 被修补以后，才能继续按照计划开发。

在生产环境里的 Bug 使你付出的代价往往要数倍于在自动化测试时发现的 Bug。换句话说，如果你计算投资与回报的话，测试驱动开发（TDD）将具有压倒性的优势。

## 不同类型的测试

你需要了解的第一件事情就是，每一种测试都有它自己的作用。他们都在软件的持续发布中起了扮演着重要的角色。

前阵子，我为一个野心勃勃的项目做了咨询，这个团队费尽心机的希望搭建一个可靠的测试套件。但因其难以使用和理解，很少派上用场，更无法继续维护。

我观察到的其中一个问题就是，现有套件混淆了单元，功能和集成测试。以至于不同类型的测试之间没有明显的区别。

其结果是现有测试套件不适合任何一个测试套件。

## 在持续发布中这些测试所扮演的角色

每种类型的测试可以发挥其独特的作用。你不用在单元测试、功能测试和集成测试中做选择。因为你会使用全部的这三种测试，并确保可以独立的运行这三种类型的测试套件。

大多数应用程序都需要单元测试和功能测试，而许多复杂的应用程序在此基础上，还需要集成测试。


*   **单元测试** 用来确保每个组件正常工作 —— 测试组件的 API 。
*   **集成测试** 用来确保不同组件互相合作 —— 测试组件的 API, UI, 或者边缘情况（比如数据库I/O，登陆等等）。
*   **功能测试** 用来确保整个应用会按照用户期望的那样运行 —— 主要测试界面

你应该把单元，集成和功能测试互相隔离开来，这样你就可以在开发时分别的运行它们。在持续的集成过程中，测试一般会出现在下面三个阶段。

*   **开发阶段**，主要是程序员反馈。这时单元测试很有用。
*   **在中间阶段**，主要是能够在发现问题时立刻停下来。这时各种测试都很有用。
*   **在生产环境**，主要是运行功能测试套件中一个叫做「冒烟测试」的子集，确保部署的时候没有弄坏什么东西。

如果你问我该使用那个测试？**所有的。**

为了了解如何在您的软件开发过程选择不同测试，你需要了解每种测试所扮演的角色，那些测试大致可分为三大类︰

*   用户体验测试（针对最终用户）
*   开发 API 测试（针对开发人员）
*   基础设施测试（负载测试、 网络集成测试等......）

用户体验测试从用户的角度来测试，使用实际的用户界面，通常是在目标平台或设备上。

API 测试则从开发者的角度来做测试。我说的可不是 Http API。我说的是一个 Unit 的 API，而一个 Unit 指开发者创建出来用来和其他模块或者类交互的一整个部分。

单元测试：实时的开发者反馈

单元测试是确保单个组件的工作彼此隔绝。一个单元，通常是一个模块、 功能等等...

比方说，您的应用程序可能需要路由一个 URL 到路由处理程序。一个单元测试就用来确保此 URL 解析器正确的解析 URL。而另一个单元测试可能确保路由器为给定的 URL 调用了正确的处理程序。

然而，如果你想测试在接收到特定的 post 请求以后，数据库会添加对应的记录，那么这就是集成测试，而不是单元测试。

单元测试常常被用来开发者的反馈机制。比方说，我在工作时，会在我每一次更改之后运行 lint 和单元测试，在 console 里检测运行的结果。

![Running tests on file change](https://dab1nmslvvntp.cloudfront.net/wp-content/uploads/2016/04/1461566883dev-console-animated-small.gif)

为了实现这个目的，单元测试必须很快，也就是说，在单元测试里，一切异步的操作都应该被避免。

自集成测试和功能测试非常频繁地依赖于网络连接和文件 I/O，他们会显著减慢测试的速度。当有很多的测试的时候，可以运行的时间可以从毫秒数到几分钟。对于非常大的应用程序，运行完整的测试可以用一个多小时。

一个好的单元测试应该包括以下三点：

*   非常简单
*   速度很快 - 以迅雷不及掩耳之势
*   生成一个「好的报告」

什么是「好的报告」呢？

「好的报告」就是能够一眼就告诉你，

1. 什么组件正在被测试
2. 你期望什么行为
3. 实际是什么结果
4. 你期望什么结果
5. 如何重现

前四个问题应在故障报告中清晰可见，而最后的那个问题应该从测试的执行很清楚的中找到。当然，在一份不合格的报告中有一些 assertion 的类型是不能回答所有问题的,但大部分的问题 ‘equal’、 ’same'，或者 'deepEqual’ 都应该可以做到。事实上，如果那些断言是现有断言库里的唯一断言，现存的大多数测试套件可能会更好。大道至简！

下面这个是我在实际项目中使用 [Tape](https://medium.com/javascript-scene/why-i-use-tape-instead-of-mocha-so-should-you-6aa105d8eaf4) 的做单元测试的例子：

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

## 集成测试

集成测试确保各组件一起正常工作。例如，节点路由处理程序可能需要一个记录器（logger）作为依赖。集成测试可测试路由和连接被正确的记录。

这里有两个组件同时被测试了：

1. 路由处理器（Route handler）
2. 记录器（Logger）

如果我们对 logger 做单元测试，这些测试是不会调用到 route handler，或者说根本就不知道还有个 handler。

如果我们对路由处理器做单元测试。我们不会管 Logger，或者与它有任何关系。我们会对路由做假的请求来测试。

Route handler 作为一种工厂函数通过依赖注入将 logger 注入进去。我们来看一段批注：

    createRoute({ logger: LoggerInstance }) => RouteHandler

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

我们来看看比较重要的细节。首先，我们创建一个 logger，然后在 memory 里做记录：

    const logger = createLog({ output: 'memory' });

创建一个 router，然后把 logger 的依赖传过去

    const routeHandler = createRoute({ logger });

向路由处理器发出假的请求，来测试记录的功能。

    routeHandler({ url });

记录器应该返回内存里的 log。我们只需要检查下面的信息：

      const actual = logger.memoryLog[0];

类似的，对于有数据库读写的操作，你可以连接到数据库，检查数据是不是在那里，等等……

很多集成测试测试相互作用提供服务，如第三方的 Api，并可能需要网络才能正常工作。为此，集成测试应与单元测试分开，以保持尽可能快地运行单元测试。

## 功能测试

功能测试是确保您的应用程序从用户的角度来看正常运行的自动化测试。功能测试测试用户的界面，输入和输出，确保软件按照期望方式做出响应。

功能测试有时被称为端到端测试，因为他们测试整个应用程序，以及与之相关的硬件和网络基础设施，从前端 UI 到后端数据库系统。在这个意义上，功能测试也是一种集成测试，确保机器和组件的都按期望工作。

功能测试通常会彻底测试"最佳路径” — — 确保关键应用程序的功能，如用户登录、 注册，购买和工作相关的关键工作流的行为符合预期。

通过 [Selenium](https://www.w3.org/TR/2016/WD-webdriver-20160120/) 这类 [WebDriver](https://www.w3.org/TR/2016/WD-webdriver-20160120/) 项目，功能测试能在诸如 [Sauce Labs](https://saucelabs.com/) 这样的云服务上正确运行。

这可能有点奇技淫巧。幸运的是，我们有不少开源项目使得这件事简单不少。

我个人最喜欢的是守夜人项目 —— [Nightwatch.js](http://nightwatchjs.org/)。从守夜人项目文档中可以看到，一个简单的守夜人功能测试套件像看起来是这样︰

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

正如你所看到的，在中间环境中，和在生产环境中，功能测试点击真实的 Url，他们通过模拟用户的真实操作来工作。他们可以单击按钮、 输入文本、 等待待页面上的更新，通过检验页面 UI 来做断言。

### 冒烟测试

当你部署了一个新的发布到生产环境后，很重要的一点就是确定它是否正常工作。你不希望你的用户比你还先发现错误 —— 因为这会赶走用户！

维护一份自动化的功能测试 - 比方说烟雾测试，是很重要的。测试你应用中所有的重要功能。那些用户在日常操作中会遇到的请求。

冒烟测试不是功能测试的唯一作用， 但是在我看来，却是最有意义的

## 为什么要持续发布产品？

在持续交付革命之前，软件发布都是使用瀑布过程。软件发布通过以下步骤，一次一个，每一步必须在下一步之前完成︰

1. 收集需求
2. 设计
3. 实现
4. 检验
5. 部署
6. 维护

它之所以被称为瀑布，是因为如果你记录它从右到左的运行的时间，它看起来像从一个任务到下一个级联的瀑布。换句话说，在理论上你不能同时做这些事情。

实际上，很多正在开发的项目的需求是在开发中才被发现的，而需求的变更常常导致灾难性的工程延误和返工。不可避免地，业务团队也会想"简单的改变”在发布后的产品，而不打算通过整个昂贵、 耗时的瀑布式的过程，这经常导致在无限循环的变化管理会议和产品热修复。

一个理论上的瀑布过程可能只是一个神话。在我的长长的职业生涯中，我与数百家企业，进行了磋商，但我从没见在真正的生产中见过完美的瀑布。典型的瀑布的发布周期可能会是几个月或几年。

## 持续发布的解决办法

持续发布法是一种开发方法，承认需求是随着项目的进展而被挖掘的，鼓励在短周期内增量改进软件，并确保不会导致问题，在任何时候软件发布。

有了迭代，软件的改进可以在短短数小时内就上线。

对比瀑布方案，我在无数的企业组织中都见过迭代开发顺利进行 —— 但我从没见过哪一个是在没有单元和功能的测试组件的情况下完成的，通常，测试组件也会包括集成测试。

希望我的这篇文章告诉了你开始迭代发布所需要知道的所有内容。

## 结论

正如你所看到的，每种类型的测试发挥了重要作用。单元测试能够快速的反馈开发者，集成测试会覆盖所有的角落的组件，而功能测试确保一切最终用户的那里的情况一切正常。
。

至于您如何使用自动的测试您的代码，以及它们如何影响您的信心和生产力？请亲们尽情的留下评论！
