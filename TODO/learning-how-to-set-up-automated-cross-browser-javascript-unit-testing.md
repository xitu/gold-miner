* 原文链接：[Learning How to Set Up Automated, Cross-browser JavaScript Unit Testing](https://philipwalton.com/articles/learning-how-to-set-up-automated-cross-browser-javascript-unit-testing)
* 原文作者：[PHILIP WALTON](https://philipwalton.com/)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[认领地址]()
* 校对者：
* 状态：认领中

We all know how important it is to test our code in multiple browsers. And I think for the most part, we in the web development community do a pretty good job at this—at least when first releasing a project.

What we don’t do a good job of is testing our code every time we make a change.

I know I’m personally guilty of this. I’ve had “learn how to set up automated, cross-browser JavaScript unit testing” on my to-do list for years, but every time I sat down to really figure it out, I gave up. While I’m sure this was partially due to my laziness, I think it was also due to the surprising lack of good information available on this topic.

There are a lot of tools and frameworks out there (like Karma) that claim to “make automated, JavaScript testing easy”, but in my experience these tools introduce more complexity than they get rid of (more on this later). In my experience, tools that “just work” can be nice once you’re an expert, but they’re terrible for learning. And what I wanted was to actually understand how this process worked under the hood, so that when it broke (which it always eventually does), I could fix it.

For me, the best way to fully understand how something works is to try to recreate it from scratch myself. So I decided to build my own testing tool, and then share what I learned with the community.

I’m writing this article because it’s the article I wish existed years ago when I first started releasing open source projects. If you’ve never set up automated, cross-browser JavaScript unit testing yourself but have always wanted to learn, then this article is for you. It will explain how the process works and show you how to do it yourself.

## The manual testing process

Before I explain the automated process, I think it’s important to make sure we’re all on the same page about how the manual process works.

After all, automation is about using machines to off-load the repetitive parts of an existing workflow. If you try to start with automation before fully understanding the manual process, it’s unlikely you’ll understand the automated process either.

In the manual process, you write your tests in a test file, and it probably looks something like this:

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

This example uses [Mocha](https://mochajs.org/) and the Node.js [`assert`](https://nodejs.org/api/assert.html) module, but it doesn’t really matter what testing or assertion library you use, it could be anything.

Since Mocha runs in Node.js, you can run this test from your terminal with the following command:

    mocha test/some-class-test.js

To run this test in your browser, you’ll need an HTML file with a `<script>` tag that loads the JavaScript, and since browsers don’t understand the `require` statement, you’ll need a module bundler like [browserify](http://browserify.org/) or [webpack](https://webpack.github.io/) to resolve the dependencies.

    browserify test/*-test.js > test/index.js

The nice thing about module bundlers like browserify or webpack is they combine all your tests (as well as any required dependencies) into a single file, so it’s easy to load it from your test page.<sup>[[1]](https://philipwalton.com/articles/learning-how-to-set-up-automated-cross-browser-javascript-unit-testing#footnote-1)</sup>

A typical test file using Mocha looks something like this:

    <html></html>
    <head></head>
      <meta charset="utf-8">
      <title></title>Tests
      <link href="../node_modules/mocha/mocha.css" rel="stylesheet">
      <script src="../node_modules/mocha/mocha.js"></script>

    <body></body>

      <div id="mocha"></div>

      <script></script>
      mocha.setup('bdd');
      window.onload = function() {
        mocha.run();
      };

      <script src="index.js"></script>

If you’re not using Node.js, then your starting point likely already looks like this HTML file, the only difference is your dependencies are probably listed individually as `<script>` tags.

### Detecting failures

Your test framework is able to know if a test fails because assertion libraries will throw an error any time an assertion isn’t true. Test frameworks run each test in a try/catch block to catch any errors that may be thrown, and then they report the errors either visually on the page or log them to the console.

Most testing frameworks (like Mocha) will provide hooks, so you can plug into the testing process, giving other scripts on the page access to the test results. This is a key feature for automating the testing process because in order for automation to work, the automation script needs to be able to fetch the results of the testing script.

### Benefits of the manual approach

A huge benefit of running your tests manually in a browser is, if one of your tests fails, you can use the browser’s existing developer tools to debug it.

It’s as simple as this:

    describe('SomeClass', () => {
      describe('someMethod', () => {
        it('accepts thing A and transforms it into thing B', () => {
          const sc = new SomeClass();

          <mark>debugger;</mark>
          assert.equal(sc.someMethod('A'), 'B');
        });
      });
    });

Now when you re-bundle and refresh the browser with the devtools open, you’ll be able to step through your code and easily track down the source of the problem.

By contrast, most of the popular automated testing frameworks out there make this really hard! Part of their convenience offering is they bundle your unit tests and create the host HTML page for you.

This is nice up until the point when any of your tests fail, because when they do, there’s no way to easily reproduce it and debug locally.

## The automated process

While the manual process has some benefits to it, it also has a lot of downsides. Opening up several different browsers to run your tests every time you want to make a change is tedious and error prone. Not to mention the fact that most of us don’t have every version of every browser we want to test installed on our local development machines.

If you’re serious about testing your code and want to ensure it’s done properly for every change, then you need to automate the process. No matter how disciplined you are, manual testing is too easy to forget or ignore, and ultimately it’s not a good use of your time.

But automated testing has its downsides too. Far too often automated testing tools introduce an entirely new set of problems. Builds can be slightly different, tests can be flaky, and failures can be a pain to debug.

When I was planning how I wanted to build my automated testing system, I didn’t want to fall into this trap or lose any of the conveniences of the manual testing process. So I decided to make a list of requirements before getting started.

After all, an automated system isn’t much of a win if it introduces brand new headaches and complexities.

### Requirements

*   I need to be able to run the tests from the command line.
*   I need to be able to debug failed tests locally.
*   I need all the dependencies required to run my tests to be installable via `npm`, so anyone checking out my code could run them by simply typing `npm install && npm test`.
*   I need the process for running the tests on a CI machine to be the same process as running them from my development machine. That way the builds are the same and failures can be debugged without having to check in new changes.
*   I need all the tests to run automatically anytime I (or anyone else) commits new changes or makes a pull request.

With this rough list in mind, the next step was to dive into how automated, cross-browser testing works on the popular cloud testing providers.

### How cloud testing works

There are a number of cloud testing providers out there, each with their own strengths and weaknesses. In my case I was writing open source, so I only looked at providers that offered a free plan for open source projects, and of those, [Sauce Labs](https://saucelabs.com/opensauce/) was the only one that didn’t require me to email support to start a new open source account.

The most surprising thing to me as I started diving into the Sauce Labs documentation on JavaScript unit testing was how straightforward it actually is. Because of how many testing frameworks there are out there that claim to make this easy, I assumed (incorrectly) that it was really hard!

I emphasized the point earlier that I didn’t want my automated process to be fundamentally different from my manual process. As it turns out, the automated methods offered by Sauce Labs are almost exactly like my manual process.

Here are the steps involved:

1.  You give Sauce Labs a URL to your test page as well as a list of browsers/platforms you want it to run the tests on.
2.  Sauce Labs uses [selenium webdriver](http://www.seleniumhq.org/projects/webdriver/) to load the page for each browser/platform combination you give it.
3.  Webdriver inspects the page to see if any tests failed, and it stores the results.
4.  Sauce Labs makes the results available to you.

It’s really that simple.

I mistakenly assumed that you had to give Sauce Labs your JavaScript code, and it would run it on their machines, but instead they just go to whatever URL you give them. This is just like the manual process; the only difference is Sauce Labs handles opening all the browsers and recording the results for you.

### The API methods

The Sauce Labs API for running unit tests consists of two methods:

*   [Start JS Unit Tests](https://wiki.saucelabs.com/display/DOCS/JavaScript+Unit+Testing+Methods#JavaScriptUnitTestingMethods-StartJSUnitTests)
*   [Get JS Unit Test Status](https://wiki.saucelabs.com/display/DOCS/JavaScript+Unit+Testing+Methods#JavaScriptUnitTestingMethods-GetJSUnitTestStatus)

The [Start JS Unit Tests](https://wiki.saucelabs.com/display/DOCS/JavaScript+Unit+Testing+Methods#JavaScriptUnitTestingMethods-StartJSUnitTests) method initiates testing of a single HTML page (at the given URL) on as many browser/platform combinations as you give it.

The documentation gives an example using `curl`:

    curl https://saucelabs.com/rest/v1/SAUCE_USERNAME/js-tests \
      -X POST \
      -u SAUCE_USERNAME:SAUCE_ACCESS_KEY \
      -H 'Content-Type: application/json' \
      --data '{"url": "https://example.com/tests.html",  "framework": "mocha", "platforms": [["Windows 7", "firefox", "27"], ["Linux", "chrome", "latest"]]}'

Since this is for JavaScript unit testing, I’ll give an example that uses the [request](https://www.npmjs.com/package/request) node module, which is probably closer to what you’ll end up doing if you’re using Node.js:

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

If you’re using a test framework not in that list, you can set `framework: 'custom'`, and Sauce Labs will instead look for a global variable called `window.global_test_results`. The format for the results is listed in the [custom framework](https://wiki.saucelabs.com/display/DOCS/Reporting+JavaScript+Unit+Test+Results+to+Sauce+Labs+Using+a+Custom+Framework) section of the documentation.

#### Making Mocha test results available to Sauce Lab’s webdriver client

Even though you told Sauce Labs in the initial request that you were using Mocha, you still have to update your HTML page to store the test results on a global variable that Sauce Labs can access.

To add Mocha support you change these lines in your HTML page:

    <script></script>
    mocha.setup('bdd');
    window.onload = function() {
      mocha.run();
    };

To something like this:

    <script></script>
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

The only difference between the above code and the default Mocha boilerplate is this logic assigns the results of the tests to a variable called `window.mochaResults` in a format that Sauce Labs is expecting. And since this new code doesn’t interfere with running the tests manually in your browser, you may as well just start using it as the default Mocha boilerplate.

To re-emphasize a point I made earlier, when Sauce Labs “runs” your tests, it’s not actually running anything, it’s simply visiting a web page and waiting until a value is found on the `window.mochaResults` object. Then it records those results.

#### Determining whether your tests passed or failed

The [Start JS Unit Tests](https://wiki.saucelabs.com/display/DOCS/JavaScript+Unit+Testing+Methods#JavaScriptUnitTestingMethods-StartJSUnitTests) method tells Sauce Labs to queue running your tests in all the browsers/platforms you give it, but it doesn’t return the results of the tests.

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

    {
      <mark>"completed": false,</mark>
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

      ]
    }

Once the `response.body.complete` property above is `true`, your tests have finished running, and you can loop through each job to report passes and failures.

### Accessing tests on localhost

I’ve explained that Sauce Labs “runs” your tests by visiting a URL. Of course, that means the URL you use must be publicly available on the internet.

This is a problem if you’re serving your tests from `localhost`.

There are a number of solutions to this problem, including [Sauce Connect](https://wiki.saucelabs.com/display/DOCS/Sauce+Connect+Proxy) (the officially recommended one), which is a proxy server created by Sauce Labs that opens a secure connection between a Sauce Labs virtual machine and your local host.

Sauce Connect is designed with security in mind, and it makes it virtually impossible for an outsider to gain access to your code. The downside of Sauce Connect is it’s quite complicated to set up and use.

If security of your code is a concern, it’s probably worth figuring out Sauce Connect; if not, there are several similar solutions that make this process a lot easier.

My solution of choice is [ngrok](https://ngrok.com/).

#### ngrok

[ngrok](https://ngrok.com/) is a tool for creating secure tunnels to localhost. It gives you a public URL<sup>[[2]](https://philipwalton.com/articles/learning-how-to-set-up-automated-cross-browser-javascript-unit-testing#footnote-2)</sup> to a web server running on your local machine, which is exactly what you need to run tests on Sauce Labs.

If you do any development or manual testing on a VM, you’ve probably already heard of ngrok, and if you haven’t, you should definitely check it out. It’s an extremely useful tool.

Installing ngrok on your development machine is as simple as downloading the binary and adding it to your path; though, if you’re going to be using ngrok in Node, you may as well install it via npm.

    npm install ngrok

You can programmatically start an ngrok process from Node with the following code (see the [documentation](https://philipwalton.com/articles/learning-how-to-set-up-automated-cross-browser-javascript-unit-testing) for the complete API details):

    const ngrok = require('ngrok');

    ngrok.connect(port, (err, url) => {
      if (err) {
        console.error(err);
      } else {
        console.log(`Tests now accessible at: ${url}`);
      }
    });

Once you have a public URL to your test file, using Sauce Labs to cross-browser test your local code becomes substantially easier!

## Putting all the pieces together

This article has covered a lot of topics, which might give the impression that automated, cross-browser JavaScript unit testing is complicated. But this is not the case.

I’ve framed the article from my point of view—as I was attempting to solve this problem for myself. And, looking back on my experience, the only real complications were due to the lack of good information out there as to how the whole process works and how all the pieces fit together.

Once you understand all the steps, it’s quite simple. Here they are, summarized:

**The initial, manual process:**

1.  Write your tests and create a single HTML page to run them.
2.  Run the tests locally in one or two browsers to make sure they work.

**Adding automation to the process:**

1.  Create an open-source Sauce Labs account and get a username and access key.
2.  Update your test page’s source code so Sauce Labs can read the results of the tests through a global JavaScript variable.
3.  Use ngrok to create a secure tunnel to your local test page, so it’s accessible publicly on the internet.
4.  Call the [Start JS Unit Tests](https://wiki.saucelabs.com/display/DOCS/JavaScript+Unit+Testing+Methods#JavaScriptUnitTestingMethods-StartJSUnitTests) API method with the list of browsers/platforms you want to test.
5.  Call the [Get JS Unit Test Status](https://wiki.saucelabs.com/display/DOCS/JavaScript+Unit+Testing+Methods#JavaScriptUnitTestingMethods-GetJSUnitTestStatus) method periodically until all jobs are finished.
6.  Report the results.

## Making it even easier

I know at the beginning of this article I talked a lot about how you didn’t need a framework to do automated, cross-browser JavaScript unit testing, and I still believe that. However, even though the steps above are simple, you probably don’t want to have to hand code them every time for every project.

I had a lot of older projects I wanted to add automated testing to, so for me it made sense to package this logic into its own module.

I do recommend you take a stab at implementing this yourself, so you can fully appreciate how it works, but if you don’t have time and you want to get testing set up quickly, I recommend trying out the library I created called [Easy Sauce](https://github.com/philipwalton/easy-sauce).

### Easy Sauce

[Easy Sauce](https://github.com/philipwalton/easy-sauce) is a Node package and command line tool (`easy-sauce`), and it’s what I now use for every JavaScript project I want to cross-browser test on the Sauce Labs cloud.

The `easy-sauce` command takes a path to your HTML test file (defaulting to `/test/`), a port to start a local server on (defaulting to `1337`), and a list of browsers/platforms to test against. `easy-sauce` will then run your tests on Sauce Lab’s selenium cloud, log the results to the console, and exit with the appropriate status code indicating whether or not the tests passed.

To make it even more convenient for npm packages, `easy-sauce` will by default look for configuration options in `package.json`, so you don’t have to separately store them. This has the added benefit of clearly communicating to users of your package exactly what browsers/platforms you support.

For complete `easy-sauce` usage instructions, check out the [documentation](https://github.com/philipwalton/easy-sauce) on Github.

Finally, I want to stress that I built this project specifically to solve my use-case. While I think the project will likely be quite useful to many other developers, I have no plans to turn it into a full-featured testing solution.

The whole point of `easy-sauce` was to fill a complexity gap that was keeping me—and I believe many other developers—from properly testing their software in the environments they claimed to support.

## Wrapping up

At the beginning of this article I wrote down a list of requirements, and with the help of Easy Sauce, I can now meet these requirements for any project I’m working on.

If you don’t already have automated, cross-browser JavaScript unit testing set up for your projects, I’d encourage you to give Easy Sauce a try. Even if you don’t want to use Easy Sauce, you should at least now have the knowledge needed to roll your own solution or better understand the existing tools.

Happy testing!
