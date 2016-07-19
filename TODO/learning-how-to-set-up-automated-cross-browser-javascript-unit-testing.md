* 原文链接：[Learning How to Set Up Automated, Cross-browser JavaScript Unit Testing](https://philipwalton.com/articles/learning-how-to-set-up-automated-cross-browser-javascript-unit-testing)
* 原文作者：[PHILIP WALTON](https://philipwalton.com/)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：owenlyn
* 校对者：

We all know how important it is to test our code in multiple browsers. And I think for the most part, we in the web development community do a pretty good job at this—at least when first releasing a project. 
我们都知道在各个不同的浏览器环境里测试代码是很重要的， 并且在大多数时候，我们作为Web开发者在这一点上是做的很好的 —— 至少在第一次发布的时候是这样。

What we don’t do a good job of is testing our code every time we make a change.
然而我们在每次更改代码之后的测试方面，却做的不尽人意。

I know I’m personally guilty of this. I’ve had “learn how to set up automated, cross-browser JavaScript unit testing” on my to-do list for years, but every time I sat down to really figure it out, I gave up. While I’m sure this was partially due to my laziness, I think it was also due to the surprising lack of good information available on this topic.
我深切地知道我本人就是这样的 —— 我早就把“学习怎样建立自动化、跨浏览器的JavaScript单元测试”写在To-do List上了，但每当我坐下来想要真正的去解决这个问题的时候，我却不得不一次次地放弃了。虽然我知道我的懒惰是其中一部分原因，但同时，在这个问题上的相关信息极其匮乏，也是一个重要因素。

There are a lot of tools and frameworks out there (like Karma) that claim to “make automated, JavaScript testing easy”, but in my experience these tools introduce more complexity than they get rid of (more on this later). In my experience, tools that “just work” can be nice once you’re an expert, but they’re terrible for learning. And what I wanted was to actually understand how this process worked under the hood, so that when it broke (which it always eventually does), I could fix it.
现在已经有了很多声称可以让“JavasScript测试变得简单而又自动化”的工具和框架（比如Karma），但从我的经验来看，这些工具创造的麻烦比它们解决的问题还要多。那些“有求必应”的工具会在你掌握了它们之后变得很好用，但往往掌握使用这些工具的技巧本身就是个难题。而且更进一步来说，我想要的时真正地理解这个过程和它的原理，这样我才能在遇到问题的时候解决问题。

For me, the best way to fully understand how something works is to try to recreate it from scratch myself. So I decided to build my own testing tool, and then share what I learned with the community.
对我来说，最好的学习方法就是尝试着把一件事情从零开始做一遍，所以我决定自己写一个测试工具，然后把我从中学到的分享给开发者社区。

I’m writing this article because it’s the article I wish existed years ago when I first started releasing open source projects. If you’ve never set up automated, cross-browser JavaScript unit testing yourself but have always wanted to learn, then this article is for you. It will explain how the process works and show you how to do it yourself.
我之所以写这篇文章，是因为我多么希望像这样的文章，是在多年之前当我开始发布开源项目的时候就已经存在的。如果你也想做自动化的跨浏览器JavaScript单元测试，却从未尝试过，那么这篇文章就是为你而写的。这篇文章将会阐释这个过程并教你怎么自己去做。

## The manual testing process
## 手工测试过程

Before I explain the automated process, I think it’s important to make sure we’re all on the same page about how the manual process works.
在我解释自动化测试之前，我决定有必要确认一下我们对怎么做手工测试的理解是一致的。

After all, automation is about using machines to off-load the repetitive parts of an existing workflow. If you try to start with automation before fully understanding the manual process, it’s unlikely you’ll understand the automated process either.
毕竟，自动化测试只是用机器代替人去不停重复一个已经存在的流程。如果你不能完全理解怎样去做手工测试，那么你也不太可能理解自动化测试的过程。

In the manual process, you write your tests in a test file, and it probably looks something like this:
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

This example uses [Mocha](https://mochajs.org/) and Node.js [`assert`](https://nodejs.org/api/assert.html) assert module, but it doesn’t really matter what testing or assertion library you use, it could be anything.
这个栗子使用了 [Mocha](https://mochajs.org/) 和 Node.js 里面的 [`assert`](https://nodejs.org/api/assert.html) 组件, 但具体用哪一个库并不重要 —— 你可用任何一个你熟悉的库。

Since Mocha runs in Node.js, you can run this test from your terminal with the following command:
你可以用下面的命令在terminal（命令行）里测试刚刚写的栗子：

    mocha test/some-class-test.js

To run this test in your browser, you’ll need an HTML file with a `<script>` tag that loads the JavaScript, and since browsers don’t understand the `require` statement, you’ll need a module bundler like [browserify](http://browserify.org/) or webpack](https://webpack.github.io/) to resolve the dependencies.

要在浏览器里打开这个测试栗子，你需要一个 `<script>` 标签的HTML文件来加载JavaScript，并且因为浏览器并不知道 `require` 语句是啥，你还要[browserify](http://browserify.org/) 或 [webpack](https://webpack.github.io/) 这样的软件来帮你解决dependencies（从属关系）的问题。 

    browserify test/*-test.js > test/index.js

The nice thing about module bundlers like browserify or webpack is they combine all your tests (as well as any required dependencies) into a single file, so it’s easy to load it from your test page.<sup>[[1]](https://philipwalton.com/articles/learning-how-to-set-up-automated-cross-browser-javascript-unit-testing#footnote-1)</sup>
使用像 browserify 或 webpack 这样的bundlers（连接器？）的好处是它们会把你所写的所有测试以及这些测试需要的资源都放进一个文件里，这样你就可以很方便的把这个文件加载到测试页面里了。

A typical test file using Mocha looks something like this:
一个典型的使用Mocha的测试文件看起来像这样：

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

If you’re not using Node.js, then your starting point likely already looks like this HTML file, the only difference is your dependencies are probably listed individually as `<script>` tags.
如果你不使用Node.js，那么你在一开始就已经有了类似这样的HTML一个文件，唯一的不同就是你的dependencies是单独用`<script>`标签列出来的。

### Detecting failures
### 找到测试没有通过的地方（这副标题怎么翻。。。）

Your test framework is able to know if a test fails because assertion libraries will throw an error any time an assertion isn’t true. Test frameworks run each test in a try/catch block to catch any errors that may be thrown, and then they report the errors either visually on the page or log them to the console.
你的测试框架知道每一个测试是否通过了，因为assert语句会在每一个返回值为否的同时返回一个错误信息。测试框架会使用一个try/catch代码块来试运行每一个单元测试，这样一旦有错误，要么会被直接显示在页面上，要么会被记录在console（操作台|对话框？）里。

Most testing frameworks (like Mocha) will provide hooks, so you can plug into the testing process, giving other scripts on the page access to the test results. This is a key feature for automating the testing process because in order for automation to work, the automation script needs to be able to fetch the results of the testing script.
大多数测试框架（比如Mocha）会提供接口，这样你在页面里写的其他脚本就可以使用这些测试结果。这是一个自动化测试的关键功能 —— 因为自动化测试的脚本需要提取测试脚本的结果。

### Benefits of the manual approach
### 手工测试的好处

A huge benefit of running your tests manually in a browser is, if one of your tests fails, you can use the browser’s existing developer tools to debug it.
手工测试的一个巨大好处就是，万一你某个单元测试出现问题了，你可以很方便的利用浏览器自带的开发者工具debug。

It’s as simple as this:
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

Now when you re-bundle and refresh the browser with the devtools open, you’ll be able to step through your code and easily track down the source of the problem.
现在，当你开着开发者工具，重新打包并载入你的代码的时候，你就可以一步一步的找出代码中的错误了。

By contrast, most of the popular automated testing frameworks out there make this really hard! Part of their convenience offering is they bundle your unit tests and create the host HTML page for you.
但现在大部分现在市面上有的测试框架却让这个过程变得十分痛苦。这些框架帮你做的，大概也就是把要测试的内容打个包放进一个HTML页面里而已。

This is nice up until the point when any of your tests fail, because when they do, there’s no way to easily reproduce it and debug locally.
在你的代码报错之前，这一切都还不错——因为当你的代码真的出错的时候，确实没有什么特别简单的方法能让你立马就找打错误并debug。

## The automated process
## 自动化过程

While the manual process has some benefits to it, it also has a lot of downsides. Opening up several different browsers to run your tests every time you want to make a change is tedious and error prone. Not to mention the fact that most of us don’t have every version of every browser we want to test installed on our local development machines.
虽然手工测试有它的好处，但也存在着很多不足。首现，每次你做测试的时候，打开好多个浏览器本身就很麻烦，并且容易出错。更不要提的是，大部分开发者都不太可能把所有版本的浏览器都装在我们的开发环境里。

If you’re serious about testing your code and want to ensure it’s done properly for every change, then you need to automate the process. No matter how disciplined you are, manual testing is too easy to forget or ignore, and ultimately it’s not a good use of your time.
如果你很认真的要测试你的代码，并想要确保每一次更新都被适当的测试了，那么你需要让测试过程自动化。不论你是多么严谨的一个人，手工测试总是太容易出错或者是忘记什么东西，并且这也是一种浪费时间。

But automated testing has its downsides too. Far too often automated testing tools introduce an entirely new set of problems. Builds can be slightly different, tests can be flaky, and failures can be a pain to debug.
当然，自动化测试也有一些不好的地方。最常见的就是自动化测试工具有一整套新的习惯需要适应，比如稍有不同的build，奇奇怪怪的测试以及痛苦debug过程。

When I was planning how I wanted to build my automated testing system, I didn’t want to fall into this trap or lose any of the conveniences of the manual testing process. So I decided to make a list of requirements before getting started.
当我计划做我自己的自动化测试系统的时候，我想避免掉进这个坑，并且保留手工测试的好处，所以我做了一个需求列表，

After all, an automated system isn’t much of a win if it introduces brand new headaches and complexities.
毕竟，如果一个自动化系统带来新的麻烦，那也算不上有什么进步。

### Requirements

*   I need to be able to run the tests from the command line.
*   I need to be able to debug failed tests locally.
*   I need all the dependencies required to run my tests to be installable via `npm`, so anyone checking out my code could run them by simply typing `npm install && npm test`.
*   I need the process for running the tests on a CI machine to be the same process as running them from my development machine. That way the builds are the same and failures can be debugged without having to check in new changes.
*   I need all the tests to run automatically anytime I (or anyone else) commits new changes or makes a pull request.

### 要求

*   能从命令提示行中运行单元测试

*   能在本地debug出错的单元测试

*   能通过npm安装所有需要的dependencies，这样任何人只需要输入nam install && nam test就可以运行我的代码

*   能够在Continuous Integration Machine(自动集成服务器？)上和我的开发机器上有相同的运行测试过程，这样builds都一样，我debug之后就不用再提交一遍代码了。

*   能够在有新的commit或pull request的时候自动运行所有的代码

With this rough list in mind, the next step was to dive into how automated, cross-browser testing works on the popular cloud testing providers.
在脑子里有这样大致的一个列表之后，下一步我们就可以埋头研究怎样让自动化、跨浏览器的JavaScript单元测试怎样在云测试提供商的平台上运行了。

### How cloud testing works
### 云测试是怎样运作的

There are a number of cloud testing providers out there, each with their own strengths and weaknesses. In my case I was writing open source, so I only looked at providers that offered a free plan for open source projects, and of those, [Sauce Labs](https://saucelabs.com/opensauce/) was the only one that didn’t require me to email support to start a new open source account.
现在有很多云测试服务提供商，每一家都有擅长和不擅长的东方。从我的情况来看，我在写一个开源软件，所以我只关心为开源项目提供免费服务的提供商。[Sauce Labs](https://saucelabs.com/opensauce/) 是唯一一家不要求我提供电子邮件支持就可以注册一个新的开源账户的。

The most surprising thing to me as I started diving into the Sauce Labs documentation on JavaScript unit testing was how straightforward it actually is. Because of how many testing frameworks there are out there that claim to make this easy, I assumed (incorrectly) that it was really hard!
当我开始研究Sauce Lab上关于JavaScript单元测试的资料的时候，它的简单直白让我喜出望外——大量“号称”好用的测试框架让我错误的以为这一个也会非常难用（囧）。

I emphasized the point earlier that I didn’t want my automated process to be fundamentally different from my manual process. As it turns out, the automated methods offered by Sauce Labs are almost exactly like my manual process.
就像我之前强调的一样，我希望我的自动化测试和手工测试本质上是一样的——事实上也是如此。

Here are the steps involved:

1.  You give Sauce Labs a URL to your test page as well as a list of browsers/platforms you want it to run the tests on.
2.  Sauce Labs uses [selenium webdriver](http://www.seleniumhq.org/projects/webdriver/) to load the page for each browser/platform combination you give it.
3.  Webdriver inspects the page to see if any tests failed, and it stores the results.
4.  Sauce Labs makes the results available to you.

下面是我用到的几个步骤：

1. 你提供给Sauce Labs需要被测试的网页的地址，以及一个包含浏览器/操作系统的列表
2. Sauce Labs使用[selenium webdriver](http://www.seleniumhq.org/projects/webdriver/)把测试页面加载到每一个你希望测试的浏览器/操作系统组合上（就是你刚刚提供的那个列表）
3. Webdriver会检测哪些单元测试没有通过，并记录测试结果
4. Sauce Labs把最终结果提供给你

It’s really that simple.
就是看起来这么简单

I mistakenly assumed that you had to give Sauce Labs your JavaScript code, and it would run it on their machines, but instead they just go to whatever URL you give them. This is just like the manual process; the only difference is Sauce Labs handles opening all the browsers and recording the results for you.
我一开始还错误的以为我必须把JavaScript的源码上传到Sauce Labs，然后在他们的服务器上运行，但其实他们会直接去你（步骤1里）提供的地址找到需要运行的文件。这和手工测试像极了——唯一的不同就是Sauce Labs帮你打开所有的浏览器并帮你记录结果。

### The API methods
### 关于Sauce Labs的API

The Sauce Labs API for running unit tests consists of two methods:
Sauce Labs上有关单元测试的API里有两个方法：

*   [Start JS Unit Tests](https://wiki.saucelabs.com/display/DOCS/JavaScript+Unit+Testing+Methods#JavaScriptUnitTestingMethods-StartJSUnitTests)
*   [Get JS Unit Test Status](https://wiki.saucelabs.com/display/DOCS/JavaScript+Unit+Testing+Methods#JavaScriptUnitTestingMethods-GetJSUnitTestStatus)

The [Start JS Unit Tests](https://wiki.saucelabs.com/display/DOCS/JavaScript+Unit+Testing+Methods#JavaScriptUnitTestingMethods-StartJSUnitTests) method initiates testing of a single HTML page (at the given URL) on as many browser/platform combinations as you give it.
开始JS单元测试这个方法会在你提供的每一个浏览器/操作系统组合上初始化一个测试HTML页面。

The documentation gives an example using `curl`:
下面的这个文档给出了一个用curl的栗子：

    curl https://saucelabs.com/rest/v1/SAUCE_USERNAME/js-tests \
      -X POST \
      -u SAUCE_USERNAME:SAUCE_ACCESS_KEY \
      -H 'Content-Type: application/json' \
      --data '{"url": "https://example.com/tests.html",  "framework": "mocha", "platforms": [["Windows 7", "firefox", "27"], ["Linux", "chrome", "latest"]]}'

Since this is for JavaScript unit testing, I’ll give an example that uses the [request](https://www.npmjs.com/package/request) node module, which is probably closer to what you’ll end up doing if you’re using Node.js:
既然这是篇关于JavaScript单元测试的文章，我来给一个用了Node里面 [request](https://www.npmjs.com/package/request) 组件的栗子，如果你使用Node.js的话，这个栗子应该跟你做的东西更贴近：

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

Notice in the post body you see `framework: 'mocha'`. Sauce Labs provides support for many of the popular JavaScript unit testing frameworks including Mocha, Jasmine, QUnit, and YUI. And by “support” it just means that Sauce Lab’s webdriver client knows where to look to get the test results (though in most cases you still have to populate those results yourself, more on that later).
注意到在body里面有 `framework: ‘mocha’` 这段代码：Sauce Labs对很多流行的JavaScript单元测试框架都提供支持，包括Mocha，Jasmine, QUnit，以及YUI。当然，这里所谓的“支持”，仅仅是指Sauce Labs的网页驱动知道在哪里找到测试结果（尽管有时候连这一点都做不到，还需要你自己完成，这一点我们待会儿再说）。

If you’re using a test framework not in that list, you can set `framework: 'custom'`, and Sauce Labs will instead look for a global variable called `window.global_test_results`. The format for the results is listed in the [custom framework](https://wiki.saucelabs.com/display/DOCS/Reporting+JavaScript+Unit+Test+Results+to+Sauce+Labs+Using+a+Custom+Framework) section of the documentation.
如果你使用了一个不再支持列表内的测试框架，你可以设置 `framework: ‘custom’`，然后Sauce Labs会去全局变量里找一个叫 `window.global_test_result`的变量。[自定义框架](https://wiki.saucelabs.com/display/DOCS/Reporting+JavaScript+Unit+Test+Results+to+Sauce+Labs+Using+a+Custom+Framework)这部分文档对测试结果的格式进行了说明。

#### Making Mocha test results available to Sauce Lab’s webdriver client
#### 让Mocha的测试结果显示在Sauce Labs的网页驱动客户端上
Even though you told Sauce Labs in the initial request that you were using Mocha, you still have to update your HTML page to store the test results on a global variable that Sauce Labs can access.
尽管在一开始你就告诉Sauce Labs你在用Mocha，你依然需要更新你的HTML文件，这样你才能把测试结果放到一个Sauce Labs有访问权限的全局变量里。

To add Mocha support you change these lines in your HTML page:
你需要把以下几行代码：

    <script>
    mocha.setup('bdd');
    window.onload = function() {
      mocha.run();
    };
    </script>

To something like this:
变成这样：

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

The only difference between the above code and the default Mocha boilerplate is this logic assigns the results of the tests to a variable called `window.mochaResults` in a format that Sauce Labs is expecting. And since this new code doesn’t interfere with running the tests manually in your browser, you may as well just start using it as the default Mocha boilerplate.
以上的改动只是让Mocha默认模板把测试结果变成一个Sauce Labs能理解的格式存到一个叫 `window.mochaResults` 的变量里。因为我们新增的这些代码和我们手工在浏览器里测试代码并不冲突，你可以放心的把这段设置成Mocha的默认模板。

To re-emphasize a point I made earlier, when Sauce Labs “runs” your tests, it’s not actually running anything, it’s simply visiting a web page and waiting until a value is found on the `window.mochaResults` object. Then it records those results.
重申一下我之前强调的一点，当 Sauce Labs “运行”你的单元测试的时候，它并不是真的在运行任何东西 —— 他只是访问一个网页，直到一个特定值在 `window.mochaResults` 中被找到，然后它记录下这些值。仅此而已。

#### Determining whether your tests passed or failed
#### 看看你的测试通过了没有

The [Start JS Unit Tests](https://wiki.saucelabs.com/display/DOCS/JavaScript+Unit+Testing+Methods#JavaScriptUnitTestingMethods-StartJSUnitTests) method tells Sauce Labs to queue running your tests in all the browsers/platforms you give it, but it doesn’t return the results of the tests.
[Start JS Unit Tests](https://wiki.saucelabs.com/display/DOCS/JavaScript+Unit+Testing+Methods#JavaScriptUnitTestingMethods-StartJSUnitTests) 这个方法仅仅让Sauce Labs开始运行单元测试，但并不返回测试结果。它仅仅返回一个它完成（”安排”更好？）的任务的ID列表，看起来像这样：

All it returns is the IDs of the jobs it queued. The response will look something like this:

    {
      "js tests": [
        "9b6a2d7e6c8d4fd2afeeb0ff7e54e694",
        "d38688ec7256497da6966f4523ddee76",
        "14054e68ccd344c0bed77a798a9ce1e8",
        "dbc54181f7d947458f52201ea5fcb901"
      ]
    }

To determine if your tests have passed or failed, you call the [Get JS Unit Test Status](https://wiki.saucelabs.com/display/DOCS/JavaScript+Unit+Testing+Methods#JavaScriptUnitTestingMethods-GetJSUnitTestStatus) method, which accepts a list of job IDs and returns the current status of each job.
要看你的测试到底通过没有，你需要调用 [Get JS Unit Test Status](https://wiki.saucelabs.com/display/DOCS/JavaScript+Unit+Testing+Methods#JavaScriptUnitTestingMethods-GetJSUnitTestStatus) 这个方法。这个方法接收一个任务ID列表，并返回每一个任务的状态。思路是你定期地调用这个方法，知道所有的任务都完成。

The idea is you call this method periodically until all the jobs have completed.

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

The response will look something like this:
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

Once the `response.body.complete` property above is `true`, your tests have finished running, and you can loop through each job to report passes and failures.
当 `response.body.complete` 这个属性的值为`true`的时候，意味着你所有的任务都已经完成了，你可以遍历每一个任务来看它们是否通过了。

### Accessing tests on localhost
### 在localhost上进行测试

I’ve explained that Sauce Labs “runs” your tests by visiting a URL. Of course, that means the URL you use must be publicly available on the internet.
我已经解释了Sauce Labs通过访问一个网址来运行你的单元测试。当然，这就意味着你提供的网址可以在互联网上被所有人访问的。

This is a problem if you’re serving your tests from `localhost`.
但如果你使用 `localhost` 的话，这又是个麻烦。

There are a number of solutions to this problem, including [Sauce Connect](https://wiki.saucelabs.com/display/DOCS/Sauce+Connect+Proxy) (the officially recommended one), which is a proxy server created by Sauce Labs that opens a secure connection between a Sauce Labs virtual machine and your local host.
不过你放心，这个问题已经有了一堆解决方案，包括官方推荐的 [Sauce Connect](https://wiki.saucelabs.com/display/DOCS/Sauce+Connect+Proxy) —— 一个由Sauce Labs发布的代理服务器软件，它是用来连接Sauce Labs的虚拟机和你的本地机器的。

Sauce Connect is designed with security in mind, and it makes it virtually impossible for an outsider to gain access to your code. The downside of Sauce Connect is it’s quite complicated to set up and use.
Sauce Connect在设计的时候就考虑到了安全性，任何一个第三方都几乎不可能获取你的代码。但Sauce Connect不好的一面就是它比较难以设置和使用。

If security of your code is a concern, it’s probably worth figuring out Sauce Connect; if not, there are several similar solutions that make this process a lot easier.
如果安全性是你代码的一个要点，那或许Sauce Connect值得你花点时间去研究；如果不是的话，那么还有一些其他相似的解决方案。

My solution of choice is [ngrok](https://ngrok.com/).
我选择了[ngrok](https://ngrok.com/)。

#### ngrok
#### ngrok

[ngrok](https://ngrok.com/) is a tool for creating secure tunnels to localhost. It gives you a public URL<sup>[[2]](https://philipwalton.com/articles/learning-how-to-set-up-automated-cross-browser-javascript-unit-testing#footnote-2)</sup> to a web server running on your local machine, which is exactly what you need to run tests on Sauce Labs.
[ngrok](https://ngrok.com/)是一个用来和localhost建立安全连接的小工具。它会为你的localhost创建一个公共URL<sup>[[2]](https://philipwalton.com/articles/learning-how-to-set-up-automated-cross-browser-javascript-unit-testing#footnote-2)</sup>，而这正是你使用Sauce Labs所需要的。

If you do any development or manual testing on a VM, you’ve probably already heard of ngrok, and if you haven’t, you should definitely check it out. It’s an extremely useful tool.
如果你在虚拟机上做过开发或者是手工测试，那你很可能已经听过ngrok，即使没有的话，你也应该去了解一下它，这是一个非常实用的小工具。

Installing ngrok on your development machine is as simple as downloading the binary and adding it to your path; though, if you’re going to be using ngrok in Node, you may as well install it via npm.
在本地安装ngrok非常方便，你只需要下载编译好的代码并把它加到path系统变量就好了（或者“并把它添加到路径就好了”？）。当然，如果你要用Node的话你也可以通过npm来安装：

    npm install ngrok

You can programmatically start an ngrok process from Node with the following code (see the [documentation](https://philipwalton.com/articles/learning-how-to-set-up-automated-cross-browser-javascript-unit-testing) for the complete API details):
你也可以通过程序从Node来启动ngrok，请看下面的代码（如果你想完整的了解细节的话，这里是[API文档](https://philipwalton.com/articles/learning-how-to-set-up-automated-cross-browser-javascript-unit-testing) for the complete API details))：

    const ngrok = require('ngrok');

    ngrok.connect(port, (err, url) => {
      if (err) {
        console.error(err);
      } else {
        console.log(`Tests now accessible at: ${url}`);
      }
    });

Once you have a public URL to your test file, using Sauce Labs to cross-browser test your local code becomes substantially easier!
一旦你的测试文件有了一个公共URL之后，使用Sauce Labs来跨浏览器测试你的本地代码会从本质上变得更简单。

## Putting all the pieces together
## 化零为整

This article has covered a lot of topics, which might give the impression that automated, cross-browser JavaScript unit testing is complicated. But this is not the case.
这篇文章讨论了很多话题，这也许让自动化、跨浏览器JavaScript单元测试看起来很复杂，但其实不是酱紫的。

I’ve framed the article from my point of view—as I was attempting to solve this problem for myself. And, looking back on my experience, the only real complications were due to the lack of good information out there as to how the whole process works and how all the pieces fit together.
我的这篇文章结构是从我自己的角度出发，把自己当成一个新手来写的。回顾我的学习历程，唯一的难点在于，关于这整个过程以的有用信息极其缺乏。

Once you understand all the steps, it’s quite simple. Here they are, summarized:
一旦你理解了这些步骤，这件事情就这么简单，这里是个总结：

**The initial, manual process:**

1.  Write your tests and create a single HTML page to run them.
2.  Run the tests locally in one or two browsers to make sure they work.

**一开始的手工过程：**

1.  把你的单元测试写到一个文件里面，然后把这个文件放进一个HTML页面里。
2.  在本地的一两个浏览器里运行这些单元测试以确保它们没有bug。

**Adding automation to the process:**

1.  Create an open-source Sauce Labs account and get a username and access key.
2.  Update your test page’s source code so Sauce Labs can read the results of the tests through a global JavaScript variable.
3.  Use ngrok to create a secure tunnel to your local test page, so it’s accessible publicly on the internet.
4.  Call the [Start JS Unit Tests](https://wiki.saucelabs.com/display/DOCS/JavaScript+Unit+Testing+Methods#JavaScriptUnitTestingMethods-StartJSUnitTests) API method with the list of browsers/platforms you want to test.
5.  Call the [Get JS Unit Test Status](https://wiki.saucelabs.com/display/DOCS/JavaScript+Unit+Testing+Methods#JavaScriptUnitTestingMethods-GetJSUnitTestStatus) method periodically until all jobs are finished.
6.  Report the results.

**把手工过程自动化：**

1.  创建一个开源的Sauce Labs账户并记下用户名和密码。
2.  更新你的HTML页面让Sauce Labs可以从JavaScript的全局变量中读取测试结果。
3.  用ngrok来创建一个公共URL。
4.  调用Start JS Unit Tests来运行你的代码。
5.  调用Get JS Unit Test Status来不停地获取测试状态直到测试结束。
6.  报告结果。

## Making it even easier
## 敢不敢再简单一点？！

I know at the beginning of this article I talked a lot about how you didn’t need a framework to do automated, cross-browser JavaScript unit testing, and I still believe that. However, even though the steps above are simple, you probably don’t want to have to hand code them every time for every project.
我知道在文章的一开始，我说过一大堆关于你根本不需要任何一个框架就可以做自动化、跨浏览器JavaScript单元测试的话，现在我依然相信这一点。但是，尽管上面的过程很简单，你大概也不想每做一个项目就写一遍这样的代码。

I had a lot of older projects I wanted to add automated testing to, so for me it made sense to package this logic into its own module.
我有一些很久以前做过的项目，我想把自动化测试加到这些项目里面，这就让我有了把这做成一个独立模块的动力。

I do recommend you take a stab at implementing this yourself, so you can fully appreciate how it works, but if you don’t have time and you want to get testing set up quickly, I recommend trying out the library I created called [Easy Sauce](https://github.com/philipwalton/easy-sauce).
我建议你尝试着把上面这个自动化的过程自己做一下，这样你才能完全理解这个过程是怎么完成的。但如果你没有时间的话，我建议你试试我做的库[Easy Sauce](https://github.com/philipwalton/easy-sauce)。

### Easy Sauce
### Easy Sauce

[Easy Sauce](https://github.com/philipwalton/easy-sauce) is a Node package and command line tool (`easy-sauce`), and it’s what I now use for every JavaScript project I want to cross-browser test on the Sauce Labs cloud.
[Easy Sauce](https://github.com/philipwalton/easy-sauce)是一个包含Node包和一个叫(`easy-sauce`)命令提示行的工具，现在我只要有需要做跨浏览器测试的JavaScript项目，我都用它。

The `easy-sauce` command takes a path to your HTML test file (defaulting to `/test/`), a port to start a local server on (defaulting to `1337`), and a list of browsers/platforms to test against. `easy-sauce` will then run your tests on Sauce Lab’s selenium cloud, log the results to the console, and exit with the appropriate status code indicating whether or not the tests passed.
`easy-sauce` 命令行需要你HTML测试文件的路径（默认 `/test/`），一个可以开启本地服务器的端口（默认 `1337`），以及一个含有浏览器/操作系统的列表。`easy-sauce`接下来会在Sauce Labs的selenium云上运行你的代码，把结果写到console里，然后在运行结束的时候自动退出并告诉你哪些测试通过了。

To make it even more convenient for npm packages, `easy-sauce` will by default look for configuration options in `package.json`, so you don’t have to separately store them. This has the added benefit of clearly communicating to users of your package exactly what browsers/platforms you support.
为了更方便npm包的用户，`easy-sauce` 会在 `package.json`里自动寻找设置选项，这样你甚至不用分开存储他们。这让软件与用户的交流变得更清楚，也让你的用户清楚的知道你的包到底支持哪些浏览器/操作系统。

For complete `easy-sauce` usage instructions, check out the [documentation](https://github.com/philipwalton/easy-sauce) on Github.
关于完整的 `easy-sauce` [使用手册](https://github.com/philipwalton/easy-sauce)，请看我的Github。

Finally, I want to stress that I built this project specifically to solve my use-case. While I think the project will likely be quite useful to many other developers, I have no plans to turn it into a full-featured testing solution.
最后，我想强调一下这个只是针对我的个人需求写的一个项目。虽然我认为这个项目会对一部分人很有帮助，我目前还没有计划把它变为一个全面的测试解决方案。

The whole point of `easy-sauce` was to fill a complexity gap that was keeping me—and I believe many other developers—from properly testing their software in the environments they claimed to support.
`easy-sauce`这个项目存在的意义是为了填补一个空白——在这之前，我，以及其他很多开发者都不能在我们声称可以可以支持的环境里面好好测试我们的软件。

## Wrapping up
## 总结

At the beginning of this article I wrote down a list of requirements, and with the help of Easy Sauce, I can now meet these requirements for any project I’m working on.
在文章的一开始我写下了我的要求列表，现在在Easy Sauce的帮助下，我可以在我做的任何项目里满足这些要求。

If you don’t already have automated, cross-browser JavaScript unit testing set up for your projects, I’d encourage you to give Easy Sauce a try. Even if you don’t want to use Easy Sauce, you should at least now have the knowledge needed to roll your own solution or better understand the existing tools.
如果你的项目里还没有自动化的跨浏览器JavaScript单元测试系统，我鼓励你试试Easy Sauce。即使你不想用它，你现在至少也有了足够的知识在你的项目中解决这个测试问题，或是对现有的测试工具有了更好的了解。

Happy testing!
代码狗们，汪汪~~
