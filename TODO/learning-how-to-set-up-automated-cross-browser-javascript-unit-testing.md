* 原文链接：[Learning How to Set Up Automated, Cross-browser JavaScript Unit Testing](https://philipwalton.com/articles/learning-how-to-set-up-automated-cross-browser-javascript-unit-testing)
* 原文作者：[PHILIP WALTON](https://philipwalton.com/)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[owenlyn](https://github.com/owenlyn)
* 校对者：[Yaowenjie](https://github.com/Yaowenjie) [MAYDAY1993](https://github.com/MAYDAY1993)

# 如何搭建自动化、跨浏览器的 JavaScript 单元测试

我们都知道在各个不同的浏览器环境里测试代码是很重要的，并且在大多数时候，我们这些 Web 开发者在这一点上还是做的不错的 —— 至少在第一次发布项目的时候是这样。

然而我们每次更改代码之后的测试工作，却做的不尽人意。

我深切地知道我本人就是这样的 —— 我早就把“学习怎样搭建自动化、跨浏览器的 JavaScript 单元测试”写在 To-do List 上了，但每当我坐下来想要真正的去解决这个问题的时候，我却不得不一次次地放弃了。虽然我知道我的懒惰是其中一部分原因，但同时，在这个问题上的相关信息极其匮乏，也是一个重要因素。

现在已经有了很多声称可以让 “JavasScript 测试变得简单而又自动化”的工具和框架（比如 Karma ），但从我的经验来看，这些工具制造的麻烦比它们解决的问题还要多。那些“有求必应”的工具会在你掌握了它们之后变得很好用，但往往掌握使用这些工具的技巧本身就是个难题。并且我想要的是真正理解这一过程在底层的工作原理，以便在出现问题的时候我能解决。

对我来说，最好的学习方法就是尝试着把一件事情从零开始做一遍，所以我决定自己写一个测试工具，然后把我从中学到的分享给开发者社区。

我之所以写这篇文章，是因为多年之前当我第一次开始发布开源项目的时候，我就希望能存在这样的一篇文章。如果你也想做自动化的跨浏览器 JavaScript 单元测试，却从未尝试过，那么这篇文章就是为你而写的。这篇文章将会阐释这个过程并教你怎么自己去做。

## 手工测试过程

在我解释自动化测试之前，我觉得有必要确认一下我们对怎么做手工测试的理解是一致的。
毕竟，自动化测试只是用机器代替人去不停重复一个已经存在的流程。如果你不能完全理解怎样去做手工测试，那么你也不太可能理解自动化测试的过程。

在手工测试中，你把想要做的测试写在一个测试文件中，大概看起来像这样：

    var assert = require('assert');
    var SomeClass = require('../lib/some-class');

    describe('SomeClass', function() {
      describe('someMethod', function() {
        it('accepts thing A and transforms it into thing B', function() {
          var sc = new SomeClass();
          assert.equal(sc.someMethod('A'), 'B');
        });
      });
    });

这个栗子使用了 [Mocha](https://mochajs.org/) 和 Node.js 里面的 [`assert`](https://nodejs.org/api/assert.html) 模块, 但具体用哪一个库并不重要 —— 你可用任何一个你熟悉的库。

由于 Mocha 运行在 Node.js 上，你可以用下面的命令在 terminal（命令行）里测试刚刚写的栗子：

    mocha test/some-class-test.js

要在浏览器里打开这个测试栗子，你需要一个 `<script>` 标签的HTML文件来加载 JavaScript，并且因为浏览器并不知道 `require` 语句是啥，你还要[browserify](http://browserify.org/) 或 [webpack](https://webpack.github.io/) 打包工具来处理依赖管理。 

    browserify test/*-test.js > test/index.js

使用像 browserify 或 webpack 这样的 bundlers 的好处是它们会把你所写的所有测试以及这些测试需要的资源都放进一个文件里，这样你就可以很方便的把这个文件加载到测试页面里了。[[1]](https://philipwalton.com/articles/learning-how-to-set-up-automated-cross-browser-javascript-unit-testing#footnote-1)

一个典型的使用 Mocha 的测试文件看起来像这样：

    <!DOCTYPE html>
    <html>
    <head>
      <meta charset="utf-8">
      <title>Tests</title>
      <link href="../node_modules/mocha/mocha.css" rel="stylesheet" />
      <script src="../node_modules/mocha/mocha.js"></script>
    </head>
    <body>
    
      <!-- A container element for the visual Mocha results -->
      <div id="mocha"></div>
    
      <!-- Mocha setup and initiation code -->
      <script>
      mocha.setup('bdd');
      window.onload = function() {
        mocha.run();
      };
      </script>
    
      <!-- The script under test -->
      <script src="index.js"></script>
    
    </body>
    </html>

如果你不使用 Node.js，那么你在一开始就已经有了类似这样的 HTML 一个文件，唯一的不同就是你依赖的资源是单独用 `<script>` 标签列出来的。

### 错误检测

你的测试框架知道每一个测试是否通过了，因为 assert 语句会在每一个返回值为否的同时返回一个错误信息。测试框架会使用一个 try/catch 代码块来试运行每一个单元测试，这样一旦有错误，要么会被直接显示在页面上，要么会被记录在 console 里。

大多数测试框架（比如 Mocha ）会提供接口，这样你在页面里写的其他脚本就可以使用这些测试结果。这是一个自动化测试的关键功能 —— 为了自动化脚本能起作用，它需要能够提取测试脚本的结果。

### 手工测试的好处

手工测试的一个巨大好处就是，万一你某个单元测试出现问题了，你可以很方便的利用浏览器自带的开发者工具来调试。

就像下面这个过程这么简单：

    describe('SomeClass', () => {
      describe('someMethod', () => {
        it('accepts thing A and transforms it into thing B', () => {
          const sc = new SomeClass();

          debugger;
          assert.equal(sc.someMethod('A'), 'B');
        });
      });
    });

现在，当你开着开发者工具，重新打包并刷新浏览器，你就可以一步一步的找出代码中的错误了。

对比来看，市面上大多数流行的自动测试框架却使这一过程变得困难——它们提供的一部分便利性只是在于它们打包了你的单元测试并为你新建主 html 页面。

在你的代码报错之前，这一切都还不错——因为当你的代码真的出错的时候，没有办法来简单地重现错误并本地调试。

## 自动化过程

虽然手工测试有它的好处，但也存在着很多不足。首现，每次你做测试的时候，打开好多个浏览器本身就很麻烦，并且太容易出错或者遗漏。更不要提的是，大部分开发者都不太可能把所有版本的浏览器都装在我们的开发环境里。

如果你很认真的要测试你的代码，并想要确保每一次更新都被适当的测试了，那么你需要让测试过程自动化。不论你是多么严谨的一个人，手工测试总是太容易出错或者是忘记什么东西，并且这也是一种浪费时间。

当然，自动化测试也有一些不好的地方。最常见的是自动化测试工具会引入一系列新问题。稍微不同的搭建过程，奇奇怪怪的测试，以及难以调试的错误。

当我计划做我自己的自动化测试系统的时候，我想避免掉进这个坑，并且保留手工测试的好处，所以我做了一个需求列表，

毕竟，如果一个自动化系统带来新的麻烦，那也算不上有什么进步。

### 要求

*   能从命令提示行中运行单元测试

*   能在本地 debug 出错的单元测试

*   能通过 npm 安装所有依赖的资源，这样任何人只需要输入 `nam install && nam test` 就可以运行我的代码

*   能够在自动集成服务器上和我的开发机器上有相同的运行测试过程，那样搭的环境是一样的，并且不需要检查新的改动就能调试错误。

*   能够在有新的 commit 或 pull request 的时候自动运行所有的代码

在脑子里有这样大致的一个列表之后，下一步我们就可以埋头研究怎样让自动化、跨浏览器的 JavaScript 单元测试怎样在云测试提供商的平台上运行了。

### 云测试是怎样运作的

现在有很多云测试服务提供商，每一家都各有优缺点。从我的情况来看，我在写一个开源软件，所以我只关心为开源项目提供免费服务的提供商。[Sauce Labs](https://saucelabs.com/opensauce/) 是唯一一家不要求我提供电子邮件支持就可以注册一个新的开源账户的。

当我开始研究 Sauce Lab 上关于 JavaScript 单元测试的资料的时候，它的简单直白让我喜出望外——大量“号称”好用的测试框架让我错误的以为这一个也会非常难用（囧）。

就像我之前强调的一样，我希望我的自动化测试和手工测试本质上是一样的——事实上也是如此。

下面是我用到的几个步骤：

1. 你提供给 Sauce Labs 需要被测试的网页的地址，以及一个包含浏览器/操作系统的列表
2. Sauce Labs 使用 [selenium webdriver](http://www.seleniumhq.org/projects/webdriver/) 把测试页面加载到每一个你希望测试的浏览器/操作系统组合上（就是你刚刚提供的那个列表）
3. Webdriver 会检测哪些单元测试没有通过，并记录测试结果
4. Sauce Labs 把最终结果提供给你

就是看起来这么简单

我一开始还错误的以为我必须把 JavaScript 的源码上传到 Sauce Labs，然后在他们的服务器上运行，但其实他们会直接去你（步骤1里）提供的地址找到需要运行的文件。这和手工测试像极了——唯一的不同就是 Sauce Labs 帮你打开所有的浏览器并帮你记录结果。

### 关于 Sauce Labs 的 API

Sauce Labs 上有关单元测试的 API 里有两个方法：

*   [Start JS Unit Tests](https://wiki.saucelabs.com/display/DOCS/JavaScript+Unit+Testing+Methods#JavaScriptUnitTestingMethods-StartJSUnitTests)
*   [Get JS Unit Test Status](https://wiki.saucelabs.com/display/DOCS/JavaScript+Unit+Testing+Methods#JavaScriptUnitTestingMethods-GetJSUnitTestStatus)

Start JS Unit Tests](https://wiki.saucelabs.com/display/DOCS/JavaScript+Unit+Testing+Methods#JavaScriptUnitTestingMethods-StartJSUnitTests) 这个方法会在你提供的每一个浏览器/操作系统组合上初始化一个测试 HTML 页面。

下面的这个文档给出了一个用 curl 的栗子：

    curl https://saucelabs.com/rest/v1/SAUCE_USERNAME/js-tests \
      -X POST \
      -u SAUCE_USERNAME:SAUCE_ACCESS_KEY \
      -H 'Content-Type: application/json' \
      --data '{"url": "https://example.com/tests.html",  "framework": "mocha", "platforms": [["Windows 7", "firefox", "27"], ["Linux", "chrome", "latest"]]}'

既然这是篇关于 JavaScript 单元测试的文章，我来给一个用了 Node 里面 [request](https://www.npmjs.com/package/request) 组件的栗子，如果你使用 Node.js 的话，这个栗子应该跟你做的东西更贴近：

    request({
      url: `https://saucelabs.com/rest/v1/${username}/js-tests`,
      method: 'POST',
      auth: {
        username: process.env.SAUCE_USERNAME,
        password: process.env.SAUCE_ACCESS_KEY
      },
      json: true,
      body: {
        url: 'https://example.com/tests.html',
        framework: 'mocha',
        platforms: [
          ['Windows 7', 'firefox', '27'],
          ['Linux', 'chrome', 'latest']
        ]
      }
    }, (err, response) => {
      if (err) {
        console.error(err);
      } else {
        console.log(response.body);
      }
    });

注意到在 body 里面有 `framework: ‘mocha’` 这段代码：Sauce Labs 对很多流行的 JavaScript 单元测试框架都提供支持，包括 Mocha，Jasmine, QUnit，以及 YUI。当然，这里所谓的“支持”，仅仅是指 Sauce Labs 的网页驱动知道在哪里找到测试结果（尽管有时候连这一点都做不到，还需要你自己完成，这一点我们待会儿再说）。

如果你使用了一个不再支持列表内的测试框架，你可以设置 `framework: ‘custom’`，然后 Sauce Labs 会去全局变量里找一个叫  `window.global_test_result` 的变量。[自定义框架](https://wiki.saucelabs.com/display/DOCS/Reporting+JavaScript+Unit+Test+Results+to+Sauce+Labs+Using+a+Custom+Framework)这部分文档对测试结果的格式进行了说明。

#### 让 Mocha 的测试结果显示在 Sauce Labs 的网页驱动客户端上

尽管在一开始你就告诉 Sauce Labs 你在用 Mocha，你依然需要更新你的 HTML 文件，这样你才能把测试结果放到一个 Sauce Labs 有访问权限的全局变量里。

为了添加对 Mocha 的支持，在 html 页面中做如下改变，把：

    <script>
    mocha.setup('bdd');
    window.onload = function() {
      mocha.run();
    };
    </script>

改成：

    <script>
    mocha.setup('bdd');
    window.onload = function() {
      var runner = mocha.run();
      var failedTests = [];
    
      runner.on('end', function() {
        window.mochaResults = runner.stats;
        window.mochaResults.reports = failedTests;
      });
    
      runner.on('fail', logFailure);
    
      function logFailure(test, err){
        var flattenTitles = function(test){
          var titles = [];
          while (test.parent.title){
            titles.push(test.parent.title);
            test = test.parent;
          }
          return titles.reverse();
        };
    
        failedTests.push({
          name: test.title,
          result: false,
          message: err.message,
          stack: err.stack,
          titles: flattenTitles(test)
        });
      };
    };
    </script>

上述代码和 Mocha 默认模板的唯一区别是上述代码将测试结果以 Sauce Labs 接受的格式分配给一个叫 window.mochaResults  的变量。因为我们新增的这些代码和我们手工在浏览器里测试代码并不冲突，你可以放心的把这段设置成 Mocha 的默认模板。

重申一下我之前强调的一点，当 Sauce Labs “运行”你的单元测试的时候，它并不是真的在运行任何东西 —— 他只是访问一个网页，直到一个特定值在 `window.mochaResults` 中被找到，然后它记录下这些值。仅此而已。

#### 看看你的测试通过了没有

[Start JS Unit Tests](https://wiki.saucelabs.com/display/DOCS/JavaScript+Unit+Testing+Methods#JavaScriptUnitTestingMethods-StartJSUnitTests) 这个方法仅仅让 Sauce Labs 把单元测试放进一个任务列表中，但并不返回测试结果。它仅仅返回一个任务队列中的任务 ID 列表，看起来像这样：

    {
      "js tests": [
        "9b6a2d7e6c8d4fd2afeeb0ff7e54e694",
        "d38688ec7256497da6966f4523ddee76",
        "14054e68ccd344c0bed77a798a9ce1e8",
        "dbc54181f7d947458f52201ea5fcb901"
      ]
    }

要看你的测试到底通过没有，你需要调用 [Get JS Unit Test Status](https://wiki.saucelabs.com/display/DOCS/JavaScript+Unit+Testing+Methods#JavaScriptUnitTestingMethods-GetJSUnitTestStatus) 这个方法。这个方法接收一个任务 ID 列表，并返回每一个任务的状态。

思路是你定期地调用这个方法，知道所有的任务都完成：

    request({
      url: `https://saucelabs.com/rest/v1/${username}/js-tests/status`,
      method: 'POST',
      auth: {
        username: process.env.SAUCE_USERNAME,
        password: process.env.SAUCE_ACCESS_KEY
      },
      json: true,
      body: jsTests, 

    }, (err, response) => {
      if (err) {
        console.error(err);
      } else {
        console.log(response.body);
      }
    });

返回值看起来像这样：

    {
      "completed": false,
      "js tests": [
        {
          "url": "https://saucelabs.com/jobs/75ac4cadb85e415fae957f7811d778b8",
          "platform": [
            "Windows 10",
            "chrome",
            "latest"
          ],
          "result": {
            "passes": 29,
            "tests": 30,
            "end": {},
            "suites": 7,
            "reports": [],
            "start": {},
            "duration": 97,
            "failures": 0,
            "pending": 1
          },
          "id": "1f74a237d5ba4a47b5a42570ae1e7999",
          "job_id": "75ac4cadb85e415fae957f7811d778b8"
        },
        // ... the rest of the jobs
      ]
    }

当 `response.body.complete` 这个属性的值为 `true` 的时候，意味着你所有的任务都已经完成了，你可以遍历每一个任务来看它们是否通过了。

### 在 localhost 上进行测试

我已经解释了 Sauce Labs 通过访问一个网址来运行你的单元测试。当然，这就意味着你提供的网址可以在互联网上被所有人访问的。

但如果你使用 `localhost` 的话，这又是个麻烦。

不过你放心，这个问题已经有了一堆解决方案，包括官方推荐的 [Sauce Connect](https://wiki.saucelabs.com/display/DOCS/Sauce+Connect+Proxy) —— 一个由 Sauce Labs 发布的代理服务器软件，它是用来连接 Sauce Labs 的虚拟机和你的本地机器的。

Sauce Connect 在设计的时候就考虑到了安全性，任何一个第三方都几乎不可能获取你的代码。但 Sauce Connect 不好的一面就是它比较难以设置和使用。

如果安全性是你代码的一个要点，那或许 Sauce Connect 值得你花点时间去研究；如果不是的话，那么还有一些其他相似的解决方案能让过程更简单。

我选择了 [ngrok](https://ngrok.com/)。

#### ngrok

[ngrok](https://ngrok.com/) 是一个用来和 localhost 建立安全连接的小工具。它会为本地服务器创建一个公共的 URL[[2]](https://philipwalton.com/articles/learning-how-to-set-up-automated-cross-browser-javascript-unit-testing#footnote-2)，而这正是你使用 Sauce Labs 所需要的。

如果你在虚拟机上做过开发或者是手工测试，那你很可能已经听过 ngrok，即使没有的话，你也应该去了解一下它，这是一个非常实用的小工具。

在本地安装 ngrok 非常方便，你只需要下载编译好的代码并把它加到 path 系统变量就好了（或者“并把它添加到路径就好了”？）。当然，如果你要用 Node 的话你也可以通过 npm 来安装：

    npm install ngrok

你也可以通过程序从 Node 来启动 ngrok，请看下面的代码（如果你想完整的了解细节的话，这里是 [API文档](https://philipwalton.com/articles/learning-how-to-set-up-automated-cross-browser-javascript-unit-testing) )：

    const ngrok = require('ngrok');

    ngrok.connect(port, (err, url) => {
      if (err) {
        console.error(err);
      } else {
        console.log(`Tests now accessible at: ${url}`);
      }
    });

一旦你的测试文件有了一个公共 URL 之后，使用 Sauce Labs 来跨浏览器测试你的本地代码会从本质上变得更简单。

## 化零为整

这篇文章讨论了很多话题，这也许让自动化、跨浏览器 JavaScript 单元测试看起来很复杂，但其实不是酱紫的。

我的这篇文章结构是从我自己的角度出发，把自己当成一个新手来写的。回顾我的学习历程，由于缺少有用的信息，唯一复杂的是整个过程的工作原理以及如何化零为整。

一旦你理解了这些步骤，这件事情就这么简单，这里是个总结：

**一开始的手工过程：**

1.  把你的单元测试写到一个文件里面，然后把这个文件放进一个 HTML 页面里。
2.  在本地的一两个浏览器里运行这些单元测试以确保它们没有 bug。

**把手工过程自动化：**

1.  创建一个开源的 Sauce Labs 账户并获取用户名和密码。
2.  更新测试页面的源代码让 Sauce Labs 可以从 JavaScript 的全局变量中读取测试结果。
3.  用 ngrok 来创建一个公共 URL。
4.  调用 Start JS Unit Tests 来运行你的代码。
5.  定期调用 Get JS Unit Test Status 方法获取测试状态直到测试结束。
6.  报告结果。

## 敢不敢再简单一点？！

我知道在文章的一开始，我说过一大堆关于你根本不需要任何一个框架就可以做自动化、跨浏览器 JavaScript 单元测试的话，现在我依然相信这一点。但是，尽管上面的过程很简单，你大概也不想每做一个项目就写一遍这样的代码。

我有一些很久以前做过的项目，我想把自动化测试加到这些项目里面，这就让我有了把这做成一个独立模块的动力。

我建议你尝试着把上面这个自动化的过程自己做一下，这样你才能完全理解这个过程是怎么完成的。但如果你没有时间的话，我建议你试试我做的库 [Easy Sauce](https://github.com/philipwalton/easy-sauce)。

### Easy Sauce

[Easy Sauce](https://github.com/philipwalton/easy-sauce)是一个包含 Node 包和叫 `easy-sauce` 的命令行工具，现在我如果有在 Sauce Labs 云上做跨浏览器测试的 JavaScript 项目，我都用它。

`easy-sauce` 命令行需要你 HTML 测试文件的路径（默认 `/test/`），一个可以开启本地服务器的端口（默认 `1337`），以及一个含有浏览器/操作系统的列表。`easy-sauce` 接下来会在 Sauce Labs 的 selenium 云上运行你的代码，把结果写到 console 里，然后在运行结束的时候自动退出并告诉你哪些测试通过了。

为了更方便 npm 包的用户，`easy-sauce` 会在 `package.json` 里自动寻找设置选项，这样你甚至不用分开存储他们。这让软件与用户的交流变得更清楚，也让你的用户清楚的知道你的包到底支持哪些浏览器/操作系统。

关于完整的 `easy-sauce` [使用手册](https://github.com/philipwalton/easy-sauce)，请看我的 Github。

最后，我想强调一下这个只是针对我的个人需求写的一个项目。虽然我认为这个项目会对一部分人很有帮助，我目前还没有计划把它变为一个全面的测试解决方案。

`easy-sauce` 这个项目存在的意义是为了填补一个空白——在这之前，我，以及其他很多开发者都不能在我们声称可以可以支持的环境里面好好测试我们的软件。

## 总结

在文章的一开始我写下了我的要求列表，现在在 Easy Sauce 的帮助下，我可以在我做的任何项目里满足这些需求。

如果你的项目里还没有自动化的跨浏览器 JavaScript 单元测试系统，我推荐你试试 Easy Sauce。即使你不想用它，你现在至少也有了足够的知识在你的项目中解决这个测试问题，或是对现有的测试工具有了更好的了解。

希望你享受测试的过程！

**脚注**

1.  使用连接器的另一个不足之处就是，目前为止内存追踪和 source map兼容的还不是很好。Chrome 浏览器下的一个解决方案是使用[node-source-map-support](https://github.com/evanw/node-source-map-support#browser-support)。

2.  ngrok 生成的链接（URL）是公共的，这意味着理论上互联网上的任何一个人都可以访问这个链接。不过，因为这个链接是随机生成的，而且通常你的测试只需要几分钟就可以了，所以其他人找到这个链接的可能性微乎其微。从这个角度看，虽然 ngrok 的安全性比 Sauce
Connect 稍弱一些，但仍然是一个相对安全的解决方案。
