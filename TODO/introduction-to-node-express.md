> * 原文地址：[Introduction to Node & Express](https://medium.com/javascript-scene/introduction-to-node-express-90c431f9e6fd#.xffyxajza)
* 原文作者：[Eric Elliott](https://medium.com/@_ericelliott)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[王子建](https://github.com/Romeo0906)
* 校对者：

# Introduction to Node & Express

# Node & Express 入门指南








> This post series has companion videos and exercises for members of [“Learn JavaScript with Eric Elliott”](https://ericelliottjs.com/product/lifetime-access-pass/). For members, the video lessons are here: [“Introduction to Node and Express” video course](https://ericelliottjs.com/premium-content/introduction-to-node-express/). Not a member yet? [Sign up now](https://ericelliottjs.com/product/lifetime-access-pass/).

> 本系列文章给[跟 Eric Elliott 学 JavaScript](https://ericelliottjs.com/product/lifetime-access-pass/)的会员提供了配套的视频和练习，会员可点击查看视频教程：[“Node & Express 入门指南”视频教程](https://ericelliottjs.com/premium-content/introduction-to-node-express/)。还不是会员？[马上注册](https://ericelliottjs.com/product/lifetime-access-pass/)。











* * *







Node is a JavaScript environment built on the same JavaScript engine used in Google’s Chrome web browser. It has some great features that make it an attractive choice for building server-side application middle tiers, including web servers and web services for platform APIs.

Node 是一个 JavaScript 环境，使用了与谷歌 Chrome 浏览器相同的 JavaScript 引擎。Node 具有非常强大的功能，无论对 web 服务器还是 web 服务器的平台 API 来说，它都是搭建服务端应用中间层的诱人之选。

The non-blocking event driven I/O model gives it very attractive performance, easily beating threaded server environments like PHP and Ruby on Rails, which block on I/O and handle multiple simultaneous users by spinning up separate threads for each.

非阻塞事件驱动的 I/O 模型给予 Node 非常强大的性能，轻而易举地就能打败阻塞 I/O 和分线程处理多用户并发的线程服务器环境，比如 PHP 和 Ruby on Rails。

I’ve ported production apps with tens of millions of users from both PHP and Ruby on Rails to Node, leading to 2x — 10x improvements of both response handling time and the number of simultaneous users handled by a single server.

我曾经将千万级用户的 app 产品从 PHP 和 Ruby on Rails 环境迁移至 Node 环境，并实现了响应处理时间和单服务器多用户并发状况处理 2-10 倍的性能提升。

**Node Features:**

**Node 的特征：**

*   Fast! (Non-blocking I/O by default).
*   Event driven.
*   First class networking.
*   First class streaming API.
*   Great standard libraries for interfacing with the OS, filesystem, etc…
*   Support for compiled binary modules when you need to extend Node’s capabilities with a lower-level language like C++.
*   Trusted and backed by large enterprises running mission-critical apps. (Adobe, Google, Microsoft, Netflix, PayPal, Uber, Walmart, etc…).
*   Easy to get started.

* 快！（默认为非阻塞 I/O）
* 事件驱动
* 一流的网络性能
* 一流的流媒体接口
* 用于接入操作系统和文件系统等的强大的标准库
* 支持编译的二进制模块，以便用户可以用其他更为基础的语言（如 C++）实现 Node 的强大性能
* 深受许多大企业的信赖和支持，并用于运行关键任务应用（如：Adobe, Google, Microsoft, Netflix, PayPal, Uber, Walmart 等）
* 易于上手

### Installing Node

### 安装 Node

Before we jump in, let’s make sure you’ve got Node installed. There are always two supported versions of Node, the Long Term Support version (stable), and the current release. For production projects, try the LTS version. If you want to play with cutting edge features from the future, pick the current version.

入圈之前，要确保已经安装了 Node。Node 一般提供两个版本，长期支持版本（稳定）和最新版本。如果用于生产项目，你应该使用 LTS 版本，如果想使用最前沿的功能则应选择最新版本。

#### Windows

Hit the [Node website](https://nodejs.org/en/) and click one of the big green install buttons.

访问[Node 官网](https://nodejs.org/en/)并且点击绿色的安装按钮。

#### Mac 或者 Linux

If you’re on a Mac or Linux system, my favorite way to install Node is with nvm.

在 Mac 或者 Linux 系统上，我最喜欢的方式是用 nvm 安装 Node。

To install or update nvm, you can use the [install script](https://github.com/creationix/nvm/blob/v0.32.1/install.sh) using cURL:

curl -o- [https://raw.githubusercontent.com/creationix/nvm/v0.32.1/install.sh](https://raw.githubusercontent.com/creationix/nvm/v0.32.1/install.sh) | bash

or Wget:

wget -qO- [https://raw.githubusercontent.com/creationix/nvm/v0.32.1/install.sh](https://raw.githubusercontent.com/creationix/nvm/v0.32.1/install.sh) | bash

Once nvm is installed, you can use it to install any version of Node.

你可以使用[install script](https://github.com/creationix/nvm/blob/v0.32.1/install.sh)来安装或者升级 nvm，使用 cURL：

curl -o- [https://raw.githubusercontent.com/creationix/nvm/v0.32.1/install.sh](https://raw.githubusercontent.com/creationix/nvm/v0.32.1/install.sh) | bash

or Wget:

wget -qO- [https://raw.githubusercontent.com/creationix/nvm/v0.32.1/install.sh](https://raw.githubusercontent.com/creationix/nvm/v0.32.1/install.sh) | bash

安装好 nvm 后，你可以用它来安装各种版本的 Node。

### Hello, World! 实例

Node & Express are easy enough that you get a basic web server to serve “Hello, world!” in about 12 lines of code:

Node & Express 非常简单，你可以仅用 12 行代码就能够实现一个基本的 web 服务器来实现“Hello,world!”：

    const express = require('express');

    const app = express();
    const port = process.env.PORT || 3000;

    app.get('/', (req, res) => {
      res.send('\n\nHello, world!\n\n');
    });

    app.listen(port, () => {
      console.log(`listening on port ${ port }`);
    });

Before this code will run, you’ll need to set up your app a little. Start by creating a new git repo:

在代码运行之前，你需要创建你的应用。从创建一个新的 git 仓库开始：

    mkdir my-node-app && cd my-node-app
    git init

You need a `package.json` file to store your apps configuration. To create one, use `npm`, which comes installed with Node:

你需要一个  `package.json` 文件来存储应用的配置信息，你可以用 Node 中自带的 `npm` 来创建：

    npm init

Answer a few questions (app name, git repo, etc…) and you’ll be ready to roll. Then you’ll need to install Express:

填写一些问题（应用名称、git 仓库等）之后你就可以准备部署应用了。接下来你需要安装 Express：

    npm install --save express

With the dependencies installed, you can run your app by typing:

依赖关系安装完之后，你可以输入以下命令来运行你的应用：

    node index.js

Test it with `curl`:

用 `curl` 来测试：

curl localhost:3000

Or visit `localhost:3000` in your browser.

或者在浏览器中访问 `localhost:3000`。

That’s it! You’ve just built your first Node app.

搞定了！你已经搭建了你的首个 Node 应用。

### Environment Variables

### 环境变量

You can use environment variables to configure your Node application. That makes it easy to use different configurations in different environments, such as the developer’s local machine, a testing server, a staging server, and production servers.

你可以使用环境变量来配置你的 Node 应用，这样就能很容易地因地制宜切换不同的配置，比如在开发者本地环境，测试环境以及生产环境下使用对应的配置。

You should also use environment variables to inject app secrets, such as API keys into the app, without checking them into source control. Some deployment environments let you use `.env` files that contain the configuration settings for your app, but then you’re left with the question, “how do I load the `.env` settings into environment variables that the app can use?”

你应该使用环境变量给应用注入应用密文，如 API 的 key，而不是在源代码控制中对其进行校验。一些开发环境使用 `.env` 文件来保存应用的配置信息，但是你可能对此充满了疑问，“我如何才能将 .env 文件中的设置加载到应用的环境变量中去呢？”

For that, try [dotenv](https://github.com/motdotla/dotenv) for Node:

鉴于此，来试试 Node 的 [dotenv](https://github.com/motdotla/dotenv) 吧：

    npm install --save dotenv

Then add one line to the top of your entry file:

然后在入口文件顶部添加：

    require('dotenv').config();

Now you can load the `port` setting from a `.env` file. Create a new file called `.env` in your project root with the following:



    PORT=5150

Save it, and relaunch the app, and you should see:

    listening on port 5150

You don’t want to check your `.env` file into Git, so add it to your `.gitignore` file. In fact, while we’re at it, let’s add some other stuff, too:

    node_modules
    build
    npm-debug.log
    .env
    .DS_Store

You still want to document the settings that are required for your app, so I like to check in a copy of the `.env` file with app secrets redacted. New users of the app can copy the file, name it `.env`, customize the settings, and be off and running. I name the checked-in copy `.env.example` and include instructions for developers in the project’s `README.md` file.

PORT=5150
AWS_KEY=

Note that you should be careful that all the app secrets are all redacted in your `.env.example` file, as demonstrated.

> Don’t check your app secrets into the Git repository.

### Testing Node Apps

I like to test Node apps with [Supertest](https://github.com/visionmedia/supertest), which abstracts away http connection issues and provides a simple, Fluent API. For http endpoints, I use [functional tests](https://www.sitepoint.com/javascript-testing-unit-functional-integration/), which means that I don’t worry about mocking databases and so on. I just hit the API with some values and expect a specific response back.

Here’s a simple example with Supertest and [Tape](https://medium.com/javascript-scene/why-i-use-tape-instead-of-mocha-so-should-you-6aa105d8eaf4):

    const test = require('tape');
    const request = require('supertest');

    const app = require('app');

    test('get /', assert => {
      request(app)
        .get('/')
        .expect(200)
        .end((err, res) => {
          const msg = 'should return 200 OK';
          if (err) return assert.fail(msg);

I also write [unit tests](https://medium.com/javascript-scene/what-every-unit-test-needs-f6cd34d9836d) for any smaller, reusable modules I use to build the API.

Note that instead of dealing with the network, we’re directly importing the express app. Supertest doesn’t need to read your app config to know what port to connect to. It handles all those details under the covers, but for this to work, you’ll want to export your app… in your app file:

    module.exports = app;

For this and other reasons, I split my app into a couple different pieces, `app.js` where I build and configure the app itself, and `server.js`, where I import the app, handle the networking details, and call `app.listen()`.

#### Setting the Node Path

When you start splitting your app into modules, you may get sick of relative path requires like this:

const app = require('../../app');

Luckily, you don’t need to use them. Put your app files in a directory named `source` or `src` and then set the `NODE_PATH` environment variable. You can use `cross-env` to set environment variables so they’ll work cross-platform (read, run your app on Windows):

    npm install --save cross-env

Then in your `package.json` scripts, you can safely set your environment variables:

     "scripts": {
        "start": "cross-env NODE_PATH=source node source/server.js",
        "debug": "cross-env NODE_PATH=source node --debug-brk --inspect source/server.js",
        "test": "cross-env NODE_PATH=source node source/test/index.js"
      }

With `NODE_PATH` set, you can require modules like this:

const app = require('app');

Much better!

### Middleware

[Express](http://expressjs.com/) is the most popular framework for Node apps, and it features middleware using continuation passing. When you want to run the same code for potentially many different routes, the right place for that code is probably middleware.

Middleware is a function that gets passed the request and response objects, along with a continuation function to call, called `next()`. Imagine you want to add a `requestId` to each request/response pair so that you can easily trace them back to the individual request when you’re debugging or searching your logs for something.

You can write some middleware like this:

    require('dotenv').config();
    const express = require('express');
    const cuid = require('cuid');

    const app = express();

    // request id middleware
    const requestId = (req, res, next) => {
      const requestId = cuid();
      req.id = requestId;
      res.id = requestId;

      // pass continuation to next middleware

### Memory Management

Since Node is single-threaded, that means that all your users are going to be sharing the same memory space. In other words, unlike in the browser, you have to be careful not to store user-specific data in closures where other connections can get at it. For this reason, I like to use `res.locals` to store temporary user data that’s only available during that user’s request/response cycle:

This is also a better way to store the `requestId` mentioned above.

### Debugging Node Apps

Node v6.4.x+ ships with an integrated Chrome debugger, so you can hook up Node to use the same tools you use to debug your JS apps in the browser.

To use it, simply add debugger statements anywhere you want to set a breakpoint, then run:

node --debug-brk --inspect source/app.js

Open the provided URL in the browser, and you’ll get an interactive debugging environment.

I use `--debug-brk` by default to tell it to break at the beginning, but you can leave it out. Remember, you’ll probably need to hit your route in a browser or from curl to trigger the route handlers and hit your breakpoints.

As you probably already know, Chrome’s dev tools are packed with valuable debugging insights. You can profile, inspect the memory management and watch for memory leaks, step through the code a line at a time, hover over variables to see values, etc…

### Let it Crash

Processes crash. Like all things, your server’s runtime will probably encounter an error it can’t handle at some point. Don’t sweat it. Log the error, shut down the server, and launch a new instance.

What you absolutely must not do is this:

    process.on('uncaughtException', (err) => {
      console.log('Oops!');
    });

You must shut down the process when there is an uncaught exception, because by definition, if you don’t know what went wrong with the app, your app is in an unknown, undefined state, and just about anything could be going wrong.

You could be leaking resources. Your users may not be seeing the correct data. You could have all kinds of crazy, undefined behaviors. When there is an exception you haven’t specifically planned for, log the error, clean up whatever resources you can, and shut down the process.

I wrote a module to make graceful error handling easy with Node. Check out [express-error-handler](https://github.com/ericelliott/express-error-handler).

#### Crash Recovery

There are a wide range of server monitor utilities to detect crashes and repair the service in order to keep things running smoothly, even in the face of unexpected exceptions.

I highly recommend [PM2](http://pm2.keymetrics.io/) for this. I use it, and it’s trusted by companies like Microsoft, IBM, and PayPal.

To install, run `npm install -g pm2`. Install locally using `npm install --save-dev pm2`. Then you can launch the app using `pm2 start source/app.js`.

You can manage running app instances with `pm2 list` and stop instances with `pm2 stop`. See the [quick start](http://pm2.keymetrics.io/docs/usage/quick-start/) for details.

Bonus: PM2 can be configured to integrate with [Keymetrics](https://keymetrics.io/), which can provide great insights into your production app instances with a friendly web interface.

### Conclusion

We’ve only just scratched the surface of Node. There’s a lot more to learn about, including session management, token authentication, API design, etc… I’ve covered some of those topics in much more depth in [“Programming JavaScript Applications”](http://pjabook.com/) (free online).











* * *







Want to learn a lot more about Node? We’re launching a new Node video series for members of EricElliottJS.com. If you’re not a member, you’re missing out.











* * *







**_Eric Elliott_** _is the author of_ [_“Programming JavaScript Applications”_](http://pjabook.com/) _(O’Reilly), and_ [_“Learn JavaScript with Eric Elliott”_](http://ericelliottjs.com/product/lifetime-access-pass/)_. He has contributed to software experiences for_ **_Adobe Systems_**_,_ **_Zumba Fitness_**_,_ **_The Wall Street Journal_**_,_**_ESPN_**_,_ **_BBC_**_, and top recording artists including_ **_Usher_**_,_ **_Frank Ocean_**_,_**_Metallica_**_, and many more._

_He spends most of his time in the San Francisco Bay Area with the most beautiful woman in the world._







