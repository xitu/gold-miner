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

现在你能从 `.env` 文件中加载 `port` 的设置了，接下来在项目的根目录下新建一个名为 `.env` 的文件：

    PORT=5150

Save it, and relaunch the app, and you should see:

保存，重启应用，之后你会看到：

    listening on port 5150

You don’t want to check your `.env` file into Git, so add it to your `.gitignore` file. In fact, while we’re at it, let’s add some other stuff, too:

如果你不想将 `.env` 文件提交到 Git，你需要将它添加到 `.gitignore` 文件中。事实上，我们还需要将一些其他的内容添加进去：

    node_modules
    build
    npm-debug.log
    .env
    .DS_Store

You still want to document the settings that are required for your app, so I like to check in a copy of the `.env` file with app secrets redacted. New users of the app can copy the file, name it `.env`, customize the settings, and be off and running. I name the checked-in copy `.env.example` and include instructions for developers in the project’s `README.md` file.

如果你还是想记录应用所需的配置信息，我通常喜欢在应用密文编辑中添加一份 `.env` 文件的副本。新用户可以复制该文件，将其命名为 `.env` 并自定义设置选项、关闭文件然后运行。我会将提交的副本文件命名为 `.env.example` 并在项目的 `README.md` 文件中写一份开发指南。

PORT=5150
AWS_KEY=

Note that you should be careful that all the app secrets are all redacted in your `.env.example` file, as demonstrated.

你应该注意，如我所言，所有的应用密文都要写在 `.env.example` 文件中。

> Don’t check your app secrets into the Git repository.

> 不要将你的应用密文提交到 Git 仓库。

### Testing Node Apps

### 测试 Node 应用

I like to test Node apps with [Supertest](https://github.com/visionmedia/supertest), which abstracts away http connection issues and provides a simple, Fluent API. For http endpoints, I use [functional tests](https://www.sitepoint.com/javascript-testing-unit-functional-integration/), which means that I don’t worry about mocking databases and so on. I just hit the API with some values and expect a specific response back.

我喜欢用[Supertest](https://github.com/visionmedia/supertest)来测试 Node 应用，它会抽象出 http 连接问题，并且提供一个简单、流畅的 API。我用 [functional tests](https://www.sitepoint.com/javascript-testing-unit-functional-integration/) 进行 http 端点测试，它让我不必担心模拟数据库等问题。我只需要点击 API 并传入一些值，然后静候一个具体的响应。

Here’s a simple example with Supertest and [Tape](https://medium.com/javascript-scene/why-i-use-tape-instead-of-mocha-so-should-you-6aa105d8eaf4):

以下是一个使用 Supertest 和 [Tape](https://medium.com/javascript-scene/why-i-use-tape-instead-of-mocha-so-should-you-6aa105d8eaf4) 测试的一个简单的实例：

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

我也会给任何我用于构建 API 的稍小的、可重用的模块写[单元测试](https://medium.com/javascript-scene/what-every-unit-test-needs-f6cd34d9836d)。

Note that instead of dealing with the network, we’re directly importing the express app. Supertest doesn’t need to read your app config to know what port to connect to. It handles all those details under the covers, but for this to work, you’ll want to export your app… in your app file:

需要注意的是，我们直接导入了快速应用，而没有使用网络。Supertest 并不需要读取应用配置来确定连接端口，它将所有的细节都封装起来，为了能够正常工作，你需要在应用文件中导出你的应用。

    module.exports = app;

For this and other reasons, I split my app into a couple different pieces, `app.js` where I build and configure the app itself, and `server.js`, where I import the app, handle the networking details, and call `app.listen()`.

出于这样和那样的理由，我将应用分割成许多不同的切片，在 `app.js` 中搭建并配置应用，在 `server.js` 中导入应用，在 `app.listen()` 中处理网络细节。

#### Setting the Node Path

#### 设置 Node 路径

When you start splitting your app into modules, you may get sick of relative path requires like this:

当你将应用划分为多个模块时，你将会对相对路径的引入关系感到不胜其烦：

const app = require('../../app');

Luckily, you don’t need to use them. Put your app files in a directory named `source` or `src` and then set the `NODE_PATH` environment variable. You can use `cross-env` to set environment variables so they’ll work cross-platform (read, run your app on Windows):

幸运的是，你不需要这样做。把你的应用文件放在名为 `source` 或者 `src` 的目录中，然后设置 `NODE_PATH` 环境变量。你可以使用 `cross-env` 设置环境变量，使他们可以跨平台使用（可以在 Windows 下读取并运行应用）。

    npm install --save cross-env

Then in your `package.json` scripts, you can safely set your environment variables:

之后，你可以很安全地在 `package.json` 脚本中设置环境变量：

     "scripts": {
        "start": "cross-env NODE_PATH=source node source/server.js",
        "debug": "cross-env NODE_PATH=source node --debug-brk --inspect source/server.js",
        "test": "cross-env NODE_PATH=source node source/test/index.js"
      }

With `NODE_PATH` set, you can require modules like this:

设置 `NODE_PATH` 之后，你可以这样引入模块：

const app = require('app');

Much better!

超赞！

### Middleware

### 中间件

[Express](http://expressjs.com/) is the most popular framework for Node apps, and it features middleware using continuation passing. When you want to run the same code for potentially many different routes, the right place for that code is probably middleware.

[Express](http://expressjs.com/) 是 Node 应用中最流行的框架，它使用延续传递的方式实现中间件。如果你有可能在许多路由中都会运行相同的代码，也许最好的方式是将它们写入中间件。

Middleware is a function that gets passed the request and response objects, along with a continuation function to call, called `next()`. Imagine you want to add a `requestId` to each request/response pair so that you can easily trace them back to the individual request when you’re debugging or searching your logs for something.

You can write some middleware like this:

中间件其实是一个函数，他能够调用一个名为 `next()` 的函数，来传递请求和响应对象。假如你想在每个请求和响应中都添加一个 `requestId` ，从而能够很方便地在调试中追踪单个请求或者在日志中搜索内容，你可以写一个像这样的中间件：

    require('dotenv').config();
    const express = require('express');
    const cuid = require('cuid');

    const app = express();

    // 请求 id 的中间件
    const requestId = (req, res, next) => {
      const requestId = cuid();
      req.id = requestId;
      res.id = requestId;

      // 延续传递至下一个中间件

### Memory Management

### 内存管理

Since Node is single-threaded, that means that all your users are going to be sharing the same memory space. In other words, unlike in the browser, you have to be careful not to store user-specific data in closures where other connections can get at it. For this reason, I like to use `res.locals` to store temporary user data that’s only available during that user’s request/response cycle:

因为 Node 是单线程的，这也意味着所有的用户都会共享同一块内存空间。换句话说，不像是在浏览器中，你不得不当心不要再闭包函数中保存针对某一个用户的数据，因为其他的连接可能会拿到那些数据。正因如此，我喜欢用 `res.locals` 来存储当前用户的信息，这只在该用户的请求和响应循环中可用。

This is also a better way to store the `requestId` mentioned above.

这也是一个用来存储上文提到的 `requestId` 的更好的办法。

### Debugging Node Apps

### 调试 Node 应用

Node v6.4.x+ ships with an integrated Chrome debugger, so you can hook up Node to use the same tools you use to debug your JS apps in the browser.

Node v6.4.x+ 版本中集成了完整的 Chrome 调试工具，因此你可以像在浏览器中调试 JS 应用一样调试 Node。

To use it, simply add debugger statements anywhere you want to set a breakpoint, then run:

要使用调试功能，你只需简单的在断点处添加一个调试声明，然后运行：

node --debug-brk --inspect source/app.js

Open the provided URL in the browser, and you’ll get an interactive debugging environment.

在浏览器中打开所提供的 URL，之后你就能得到一个交互式的调试环境。

I use `--debug-brk` by default to tell it to break at the beginning, but you can leave it out. Remember, you’ll probably need to hit your route in a browser or from curl to trigger the route handlers and hit your breakpoints.

我会使用 `--debug-brk` 默认地在起点设置一个断点，但是你也可以取消。要记住，你可能需要在浏览器中点击路由或者从 curl 中触发路由处理机制并且点击你的断点位置。

As you probably already know, Chrome’s dev tools are packed with valuable debugging insights. You can profile, inspect the memory management and watch for memory leaks, step through the code a line at a time, hover over variables to see values, etc…

你可能知道的，Chrome 的开发工具集成了非常有价值的调试信息。你能够浏览、检查内存管理并监控内存泄漏、一次只执行一行代码、鼠标悬停在变量上来查看变量的值等等。

### Let it Crash

### 应用崩溃

Processes crash. Like all things, your server’s runtime will probably encounter an error it can’t handle at some point. Don’t sweat it. Log the error, shut down the server, and launch a new instance.

进程崩溃。众生皆如此，你的服务器在运行中可能会遭遇一个它无法处理的错误。不要苦恼，记录下错误信息，关闭服务器然后重新运行一个新的实例。

What you absolutely must not do is this:

你绝对不能像这样做：

    process.on('uncaughtException', (err) => {
      console.log('Oops!');
    });

You must shut down the process when there is an uncaught exception, because by definition, if you don’t know what went wrong with the app, your app is in an unknown, undefined state, and just about anything could be going wrong.

当出现未捕获的异常时，你必须关闭进程，因为从定义上来讲，如果你不知道应用哪里出了问题，你的应用就处在一种不可知不明确的状态，并且随处都有可能产生错误。

You could be leaking resources. Your users may not be seeing the correct data. You could have all kinds of crazy, undefined behaviors. When there is an exception you haven’t specifically planned for, log the error, clean up whatever resources you can, and shut down the process.

你可能会造成资源泄漏，用户可能看到错误的数据，你可能会得到各种疯狂的不明确的应用操作。当产生一个你意料之外的异常时，记录下错误信息，清理所以有你能清理的资源，并且关闭进程。

I wrote a module to make graceful error handling easy with Node. Check out [express-error-handler](https://github.com/ericelliott/express-error-handler).

我用 Node 写了一个优雅的错误处理模块，在此检出 [express-error-handler](https://github.com/ericelliott/express-error-handler)。

#### Crash Recovery

#### 崩溃修复

There are a wide range of server monitor utilities to detect crashes and repair the service in order to keep things running smoothly, even in the face of unexpected exceptions.

有各种各种的服务器监控工具可以检测崩溃并且修复服务来保持应用运行流畅，即使是遇到了未知异常，它们同样有效。

I highly recommend [PM2](http://pm2.keymetrics.io/) for this. I use it, and it’s trusted by companies like Microsoft, IBM, and PayPal.

我极力推荐 [PM2](http://pm2.keymetrics.io/) ，因为不光我在使用它而且它也深受许多公司的信赖，比如 Microsoft，IBM，和 PayPal。

To install, run `npm install -g pm2`. Install locally using `npm install --save-dev pm2`. Then you can launch the app using `pm2 start source/app.js`.

安装的时候，运行 `npm install -g pm2`，在本地安装就使用 `npm install --save-dev pm2` 命令。之后你就可以使用 `pm2 start source/app.js` 来运行应用了。

You can manage running app instances with `pm2 list` and stop instances with `pm2 stop`. See the [quick start](http://pm2.keymetrics.io/docs/usage/quick-start/) for details.

你可以用 `pm2 list` 管理运行的应用实例，也可以使用 `pm2 stop` 来终止实例。查看更多细节请点击 [quick start](http://pm2.keymetrics.io/docs/usage/quick-start/)。

Bonus: PM2 can be configured to integrate with [Keymetrics](https://keymetrics.io/), which can provide great insights into your production app instances with a friendly web interface.

福利：PM2 能配置集成 [Keymetrics](https://keymetrics.io/)，它能以非常友好的 web 界面为你的生产应用实例提供很棒的调试意见。

### Conclusion

### 小结

We’ve only just scratched the surface of Node. There’s a lot more to learn about, including session management, token authentication, API design, etc… I’ve covered some of those topics in much more depth in [“Programming JavaScript Applications”](http://pjabook.com/) (free online).

我们仅仅是蜻蜓点水一般地了解了 Node，还有很多的东西需要我们去学习，包括会话管理、token 验证、API 设计等等。我对其中一些内容做了更深刻地阐释，详见 [“Programming JavaScript Applications”](http://pjabook.com/)（免费）。











* * *







Want to learn a lot more about Node? We’re launching a new Node video series for members of EricElliottJS.com. If you’re not a member, you’re missing out.

想学习更多 Node 的知识？我们为 EricElliottJS.com 的会员发行了新的 Node 视频系列，如果你不是会员，那么你就要错过啦！











* * *







**_Eric Elliott_** _is the author of_ [_“Programming JavaScript Applications”_](http://pjabook.com/) _(O’Reilly), and_ [_“Learn JavaScript with Eric Elliott”_](http://ericelliottjs.com/product/lifetime-access-pass/)_. He has contributed to software experiences for_ **_Adobe Systems_**_,_ **_Zumba Fitness_**_,_ **_The Wall Street Journal_**_,_**_ESPN_**_,_ **_BBC_**_, and top recording artists including_ **_Usher_**_,_ **_Frank Ocean_**_,_**_Metallica_**_, and many more._

_He spends most of his time in the San Francisco Bay Area with the most beautiful woman in the world._

**_Eric Elliott_**是 [**_“Programming JavaScript Applications”_**](http://pjabook.com/)(O’Reilly) 和 [**_“Learn JavaScript with Eric Elliott”_**](http://ericelliottjs.com/product/lifetime-access-pass/) 的作者。他曾在**_Adobe Systems_**_,_ **_Zumba Fitness_**_,_ **_The Wall Street Journal_**_,_**_ESPN_**_,_ **_BBC_**的软件开发领域立下汗马功劳，也曾为顶级唱片大师**_Usher_**_,_ **_Frank Ocean_**_,_**_Metallica_**等人量身定制。

**他的大部分时光都是和世界上最美丽的女人在旧金山海湾地区度过的。**







