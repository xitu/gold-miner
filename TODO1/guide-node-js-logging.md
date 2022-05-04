> * 原文地址：[A Guide to Node.js Logging](https://www.twilio.com/blog/guide-node-js-logging)
> * 原文作者：[dkundel](https://www.twilio.com/blog/author/dkundel)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/guide-node-js-logging.md](https://github.com/xitu/gold-miner/blob/master/TODO1/guide-node-js-logging.md)
> * 译者：[fireairforce](https://github.com/fireairforce)

# Node.js 日志记录指南

![Decorative header image "A guide to Node.js logging"](https://s3.amazonaws.com/com.twilio.prod.twilio-docs/images/kXeypOLzQZEdsIoPNIXDnloJ-7X1bqKVcPil1g3udZ_1Kd.width-808.png)

当你开始使用 JavaScript 开始时，你应该学会的第一件事就是如何通过 `console.log()` 将事物记录到控制台。如果你搜索如何调试 `JavaScript`，你会发现数百篇博客文章和 StackOverflow 上的文章会告诉你很“简单”的使用 `console.log()` 来完成调试。因为这是一种常见的做法，我们甚至开始使用 `linter` 规则，比如 [`no-console`](https://eslint.org/docs/rules/no-console)，以确保我们不会在生产代码中留下意外的日志记录。但是如果我们真的想记录一些东西来提供更多的信息呢？

在这篇博文中，我将会介绍一些你想要记录信息的各种情况，以及在 Node.js 中 `console.log` 和 `console.error` 的区别，以及如何在不影响用户控制台的情况下往库里面发送日志记录。

```js
console.log(`Let's go!`);
```

## 理论第一：Node.js 的重要细节

虽然您可以在浏览器和 Node.js 中使用 `console.log` 或 `console.error`，但在使用 Node.js 时需要记住一件重要的事情。在一个叫做 `index.js` 的文件中写下面的代码：

```js
console.log('Hello there');
console.error('Bye bye');
```

然后在终端里面使用 `node index.js` 来运行它，你会看到这两个直接在下面输出：

![Screenshot of Terminal running `node index.js`](https://s3.amazonaws.com/com.twilio.prod.twilio-docs/images/IOR3_DzRS9I8kNyWU4KQ0Kgb_B3gbgW4WLnaTPzE-5DUVO.width-500.png)

然而，虽然这两个看上去可能相同，但系统实际上对它们的处理方式并不相同。如果你去查看 [Node.js 文档中 `console` 部分](https://nodejs.org/api/console.html)，你会看到 `console.log` 是使用 `stdout` 来打印而 `console.error` 使用 `stderr` 来打印。

每个进程都可以使用三个默认的 `streams` 来工作。它们分别是 `stdin`、`stdout` 和 `stderr`。`stdin` 流来处理和你的进程相关的输出。例如按下按钮或重定向输出（我们会在一秒钟之内完成）。`stdout` 流则用于你的应用程序的输出。最后 `stderr` 用于错误消息。如果你想了解 `stderr` 存在的原因以及什么时候使用它，[可以查看本文](https://www.jstorimer.com/blogs/workingwithcode/7766119-when-to-use-stderr-instead-of-stdout)。

简而言之，这允许我们使用 redirect（`>`）和 pipe（`|`）运算符来处理和应用程序实际结果分开的错误和诊断信息。虽然 `>` 允许我们将命令的输出重定向到文件中，`2>` 允许我们将 `stderr` 的输出重定向到文件中。例如，下面这个命令会将 “Hello there” 传递到一个叫做 `hello.log` 的文件中和将 “Bye bye” 传递到一个叫做 `error.log` 的文件中。

```js
node index.js > hello.log 2> error.log
```

![Screenshot of terminal showing how error output is in different file](https://s3.amazonaws.com/com.twilio.prod.twilio-docs/images/rOWVM3v67qub6TIhwBqAFguCm9FOoOgZ6CHagg_Ns5QVLf.width-500.png)

## 你什么时候想记录？

既然我们已经了解了日志记录的基础记录方面，让我们先谈谈你可能想要记录某些内容的不同用例。通常这些用例属于以下的类别之一：

* 快速调试开发期间的意外行为
* 基于浏览器的分析或诊断日志记录
* 使用[服务器应用程序的日志](#你的服务器应用程序的日志)来记录传入的请求，以及可能发生的任何故障
* [库的可选调试日志](#你的库的日志)，以帮助用户解决问题 
* 使用 [CLI 的输出](#你的-CLI-输出)来打印进程, 确认消息或错误

本篇博客将会跳过前面两个类别，然后重点介绍基于 Node.js 的后三个类别

## 你的服务器应用程序的日志

你可能需要在服务器上进行日志记录的原因有很多。例如，记录传入的请求从而允许你从里面提取信息，比如有多少用户正在访问 404，这些请求可能是什么，或者正在使用什么 `User-Agent`。你也想知道什么时候出了问题以及为什么会出现问题。

如果你想在文章的这一部分中尝试下面的内容，首先要确保创建一个文件夹。在项目目录下创建一个叫做 `index.js` 的文件，然后使用下面的代码来初始化整个项目并且安装一下 `express`：

```
npm init -y
npm install express
```

然后设置一个带有中间件的服务器，只需要 `console.log` 为来提供每次的请求。将下面的内容放在 `index.js` 文件里面：

```js
const express = require('express');

const PORT = process.env.PORT || 3000;
const app = express();

app.use((req, res, next) => {
 console.log('%O', req);
 next();
});

app.get('/', (req, res) => {
 res.send('Hello World');
});

app.listen(PORT, () => {
 console.log('Server running on port %d', PORT);
});
```

我们用 `console.log('%O', req)` 来记录整个对象。`console.log` 在引擎盖下使用 `util.format`，它还支持 `%O` 等其他占位符。你可以在 [Node.js 文档中阅读它们](https://nodejs.org/api/util.html#util_util_format_format_args)。

当你运行 `node index.js` 执行服务器并且导航到 [http://localhost:3000](http://localhost:3000)，你会注意到它将打印出许多我们真正并不需要的信息。

![Screenshot of terminal showing too much output of request object](https://s3.amazonaws.com/com.twilio.prod.twilio-docs/images/fkC4l6o0lqPakT-3wbM4hNevjWsT2meB34BY7nTbmX1oXZ.width-500.png)

如果将代码改成 `console.log('%s', req)` 为不打印整个对象，我们也不会获得太多的信息。

![Screenshot of terminal printing "[object Object]" multiple times](https://s3.amazonaws.com/com.twilio.prod.twilio-docs/images/HhQKjPGMiOT52G3-X53cPGTQmbR3zPoLb5LgKSwrMrK5MY.width-500.png)

我们可以编写我们自己的打印函数，它只输出我们关心的东西，但是让我们先回退一步，讨论一下我们通常关心的事情。虽然这些信息经常成为我们关注的焦点，但实际上我们可能还需要其他信息。例如：

* 时间戳 —— 用于得知事情何时发生
* 计算机/服务器名称 —— 如果你运行的是分布式系统
* 进程 ID —— 如果你使用类似 [`pm2`](https://www.npmjs.com/package/pm2) 的工具来运行多个 Node 进程
* 消息 —— 包含一些内容的实际消息
* 堆栈跟踪 —— 以防我们记录错误
* 也许还有一些额外的变量/信息

 另外，既然我们知道所有的东西都会转到 `stdout` 和 `stderr`，那么我们可能需要不同的日志级别，并且根据它们来配置和过滤日志的能力。

我们可以通过访问各部分的 [`process`](https://nodejs.org/api/process.html) 并且写一大堆 JavaScript 代码来获取这些，但是关于 Node.js 最好的事情是我们得到了 [`npm`](https://www.npmjs.com/) 生态系统，并且已经有各种各样的库供我们使用。其中有一些是：

* [`pino`](https://getpino.io/)
* [`winston`](https://www.npmjs.com/package/winston)
* [`roarr`](https://www.npmjs.com/package/roarr)
* [`bunyan`](https://www.npmjs.com/package/bunyan)（注意这个库已经有两年没有更新了）

我个人很喜欢 `pino` 这个库，因为它运行很快，并且生态系统比较好，让我们来看看如何使用 [`pino`](https://getpino.io/) 来帮我们记录日志。我们同时也可以使用 `express-pino-logger` 包来帮助我们整洁的记录请求。

同时安装 `pino` 和 `express-pino-logger`：

```
npm install pino express-pino-logger

```

然后更新 `index.js` 文件来使用记录器和中间件：

```js
const express = require('express');
const pino = require('pino');
const expressPino = require('express-pino-logger');

const logger = pino({ level: process.env.LOG_LEVEL || 'info' });
const expressLogger = expressPino({ logger });

const PORT = process.env.PORT || 3000;
const app = express();

app.use(expressLogger);

app.get('/', (req, res) => {
 logger.debug('Calling res.send');
 res.send('Hello World');
});

app.listen(PORT, () => {
 logger.info('Server running on port %d', PORT);
});
```

在这个代码片段中，我们通过 `pino` 创建了一个 `logger` 实例并将其传递给 `express-pino-logger` 来创建一个新的中间件，并且通过 `app.use` 来调用它。此外，我们在服务器启动的位置用 `logger.info` 来替换 `console.log`，并在我们的路由中添加一行 `logger.debug` 来显示一个额外的日志级别。

如果通过 `node index.js` 再次运行重新启动服务器，你将会看到一个完全不同的输出，它会为每一行打印一个 JSON。再次导航到 [http://localhost:3000](http://localhost:3000)，你将会看到添加了另一行 JSON。

![Screenshot showing example pino logs from HTTP request](https://s3.amazonaws.com/com.twilio.prod.twilio-docs/images/x2TedyPcCiQ93p3U9Bb5HTkXECMxxbKZhZA4ecPlYKn0pB.width-500.png)

如果你检查这个 JSON，你将看到它包含所有先前提到的信息，例如时间戳。您可能还会注意到我们的 `logger.debug` 声明没有打印出来。那是因为我们必须更改默认日志级别才能使其可见。当我们创建 `logger` 实例时，我们将值设为 `process.env.LOG_LEVEL` 意味着我们可以通过它更改值，或者接受默认值 `info`。我们可以通过运行 `LOG_LEVEL=debug node index.js` 来调整日志的级别。

在我们这样做之前，让我们先认清这样一个事实，即现在的输出并不是真正可读的。这是故意的。`pino` 遵循一个理念，为了提高性能，你应该通过管道（使用`|`）输出将日志任何处理移动到单独的过程中去。这包括使其可读或将其上传到云主机上面去。我们称这些为 [`传输`](http://getpino.io/#/docs/transports)。查看[关于`传输`的文档](http://getpino.io/#/docs/transports) 去了解 `pino` 中的错误为什么没有写入 `stderr`。

我们将使用 `pino-pretty` 来查看更易读的日志版本。在终端运行：

```
npm install --save-dev pino-pretty
LOG_LEVEL=debug node index.js | ./node_modules/.bin/pino-pretty
```

现在，你的所有日志信息都会使用 `|` 操作符输出到 `pino-pretty` 中去。如果你再次去请求 [http://localhost:3000](http://localhost:3000)。你应该还能看到你的 `debug` 信息。

![Screenshot of pretty printed pino logs](https://s3.amazonaws.com/com.twilio.prod.twilio-docs/images/m7gSplE-B6Qldtf9Y0F6d2xMqqBH2mrweyRMERoASDo_OT.width-500.png)

有许多现有的传输工具可以美化或转换你的日志。你甚至可以通过 [`pino-colada`](https://www.npmjs.com/package/pino-colada) 来显示 emojis。这会对你的本地开发很有用。在生产环境中运行服务器后，你可能希望将日志输出到到[另外一个传输中](http://getpino.io/#/docs/transports)，使用 `>` 将其写入磁盘以待稍后处理，或者使用类似于 [`tee`](https://en.wikipedia.org/wiki/Tee_(command)) 的命令来进行同时的处理。

该 [文档](https://getpino.io/) 还将包含有关诸如轮换日志文件，过滤和将日志写入不同文件等内容的信息。

## 你的库的日志

既然我们研究了如何有效地为服务器应用程序编写日志，为什么不对我们编写的库使用相同的技术呢？

问题是，你的库可能希望记录用于调试的内容，但实际上不应该让使用者的应用程序变得混乱。相反，如果需要调试某些东西，使用者应该能够启用日志。你的库在默认情况下应该是不会处理这些的，并将写入输出的操作留给用户。

`express` 就是一个很好的例子。在 `express` 框架下有很多的事情要做，在调试应用程序时，你可能希望了解一下框架的内容。如果我们查询 [`express` 文档](https://expressjs.com/en/guide/debugging.html)，你会注意到你可以在你的命令前面加上 `DEBUG=express:*` 这样一行代码：

```
DEBUG=express:* node index.js
```

如果你使用现在的应用程序运行这个命令，你将看到许多其他输出，可帮助你调试问题。

![Screenshot of express debug logs](https://s3.amazonaws.com/com.twilio.prod.twilio-docs/images/sI71bQT5Tv1-lq_T9U9Nh4QOKnc52bINbLW7VhjSNgDinH.width-500.png)

如果你没有启用调试日志记录，则不会看到任何这样的日志。这是通过调用一个叫做 [`debug`](https://npm.im/debug) 的包来完成的。它允许我们在“命名空间”下编写消息，如果库的用户包含命名空间或者在其 `DEBUG` [环境变量](https://www.twilio.com/blog/2017/01/how-to-set-environment-variables.html) 中匹配它的通配符，它将输出这些。使用 `debug` 库，首先要先安装它：

```
npm install debug
```

让我们通过创建一个模拟我们的库调用的新文件 `random-id.js` 来尝试它，并在里面写上这样的代码：

```js
const debug = require('debug');

const log = debug('mylib:randomid');

log('Library loaded');

function getRandomId() {
 log('Computing random ID');
 const outcome = Math.random()
   .toString(36)
   .substr(2);
 log('Random ID is "%s"', outcome);
 return outcome;
}

module.exports = { getRandomId };
```

这里会创建一个带有命名空间 `mylib:randomid` 的 `debug` 记录器，然后会将两种消息记录上去。然后我们在前一节的 `index.js` 文件中使用它：

```js
const express = require('express');
const pino = require('pino');
const expressPino = require('express-pino-logger');

const randomId = require('./random-id');

const logger = pino({ level: process.env.LOG_LEVEL || 'info' });
const expressLogger = expressPino({ logger });

const PORT = process.env.PORT || 3000;
const app = express();

app.use(expressLogger);

app.get('/', (req, res) => {
 logger.debug('Calling res.send');
 const id = randomId.getRandomId();
 res.send(`Hello World [${id}]`);
});

app.listen(PORT, () => {
 logger.info('Server running on port %d', PORT);
});
```

如果你这次使用 `DEBUG=mylib:randomid node index.js` 来重新启动服务器，它会打印我们“库”的调式日志。

![Screenshot of custom debug logs](https://s3.amazonaws.com/com.twilio.prod.twilio-docs/images/Ax6Eu1HYBTvu5mNGigI96i3wcAwlzeIjZ8phL4Iv8bECnd.width-500.png)

有意思的是，如果使用你的库的用户想把这些调试信息方法到自己的 `pino` 日志中去，他们可以使用一个由 `pino` 团队出的一个叫做 `pino-debug` 库来正确的格式化这些日志。

使用下面的命令来安装这个库：

```
npm install pino-debug
```

`pino-debug` 在我们第一次使用之前需要初始化一次 `debug`。最简单的方法是在启动脚本之前使用 [Node.js 的 `-r` 或 `--require` 标识符](https://nodejs.org/api/cli.html#cli_r_require_module) 来初始化。使用下面的命令来重启你的服务器（假设你已经安装了 [`pino-colada`](https://www.npmjs.com/package/pino-colada)）：

```
DEBUG=mylib:randomid node -r pino-debug index.js | ./node_modules/.bin/pino-colada
```

你现在就可以用和应用程序日志相同的格式来查看库的调试日志。

![Screenshot of debug logs working with pino and pino-colada](https://s3.amazonaws.com/com.twilio.prod.twilio-docs/images/Y0rx6dlEkHTU-jFtPLPJDLCoy3itkF8Y06mjqJ0ArOUffq.width-500.png)

## 你的 CLI 输出

我将在这篇博文中介绍的最后一个案例是针对 CLI 而不是库去进行日志记录的特殊情况。我的理念是将逻辑日志和你的 CLI 输出 “logs” 分开。对于任何逻辑日志，你应该使用类似 [`debug`](https://npm.im/debug) 的库。这样你或其他人就可以重新使用逻辑，而不受 CLI 的特定用例约束。

[当你使用 Node.js 构建 CLI 时](https://www.twilio.com/blog/how-to-build-a-cli-with-node-js)，你可能希望通过特定的视觉吸引力方式来添加颜色、旋转器或格式化内容来使事物看起来很漂亮。但是，在构建 CLI 时，应该记住几种情况。

一种情况是，你的 CLI 可能在持续继承（CI）系统的上下文中使用，因此你可能希望删除颜色或任何花哨的装饰输出。一些 CI 系统设置了一个称为 “CI” 的环境标志。如果你想更安全的检查自己是否在 CI 中，可以使用已经支持多个 CI 系统的包，例如[`is-ci`](https://www.npmjs.com/package/is-ci)。

有些库例如 `chalk` 已经为你检测了 CI 并帮你删除颜色。让我们来看看这是什么样子。

使用 `npm install chalk` 来安装 `chalk`，并创建一个叫做 `cli.js` 的文件。将下面的内容放在里面：

```
const chalk = require('chalk');

console.log('%s Hi there', chalk.cyan('INFO'));
```

现在，如果你使用 `node cli.js` 运行这个脚本，你将会看到对应的颜色输出。

![Screenshot showing colored CLI output](https://s3.amazonaws.com/com.twilio.prod.twilio-docs/images/ABLZI2_ENJ2atjZMxFqs3FuNuZpe0O4zrluWAiW3lTSDOM.width-500.png)

但是你使用 `CI=true node cli.js` 来运行它，你会看到颜色被删除了：

![Screenshot showing CLI output without colors and enabled CI mode](https://s3.amazonaws.com/com.twilio.prod.twilio-docs/images/DNVDVhftcAcmBWR5v66D5GAkmdMH5DZk6kLBoNQhbSMMeq.width-500.png)

你要记住另外一个场景就是 `stdout` 能否在终端模式下运行。意思是将内容写入终端。如果是这种情况，我们可以使用类似 [`boxen`](https://npm.im/boxen) 的东西来显示所有漂亮的输出。如果不是，则可能会将输出重定向到文件或传输到其他地方。

你可以检查 [`isTTY`](https://nodejs.org/api/process.html#process_a_note_on_process_i_o) 相应的流属性来检查 `stdin`、`stdout` 或 `stderr` 是否处于终端模式。例如：`process.stdout.isTTY`. 在这种情况下特别用于终端，`TTY` 代表“电传打字机”。

根据 Node.js 进程的启动方式，三个流中的每个流的值可能不同。你可以在 [Node.js 文档的“进程 I/O” 部分](https://nodejs.org/api/process.html#process_a_note_on_process_i_o)了解到更多关于它的信息。

让我们看看 `process.stdout.isTTY` 在不同情况下价值的变化情况。更新你的 `cli.js` 文件以检查它：

```js
const chalk = require('chalk');

console.log(process.stdout.isTTY);
console.log('%s Hi there', chalk.cyan('INFO'));
```

然后使用 `node cli.js` 在你的终端你面运行，你会看到 `true` 打印后会跟着我们的彩色消息。

![Screenshot of output saying "true" and colored output](https://s3.amazonaws.com/com.twilio.prod.twilio-docs/images/rtLqrmfAtvWMA59CygeQnbvHqHos5hd51mEc4PtqGq2qNk.width-500.png)

之后运行相同的东西，但将输出重定向到一个文件，然后通过运行检查内容：

```
node cli.js > output.log
cat output.log
```

这次你会看到它会打印 `undefined` 后面跟着一个简单的无色消息。因为 `stdout` 关闭了终端模式下 `stdout` 的重定向。因为 `chalk` 使用了 [`supports-color`](https://github.com/chalk/supports-color#readme)，所以在引擎盖下会检查各个流上的 `isTTY`。

![Screenshot saying "undefined" and monochrome CLI output](https://s3.amazonaws.com/com.twilio.prod.twilio-docs/images/2n-ArjiYxgsmdt0d3KHiJUvvv7_lf8e_kR1Mm3ix81hS2Q.width-500.png)

但是，像 `chalk` 这样的工具已经为你处理了这种行为，当你开发 CLI 时，你应该始终注意你的 CLI 可能在 CI 模式下运行或输出被重定向的情况。它也可以帮助你把你的 CLI 的经验更进一步。例如，你可以在终端以一种漂亮的方式排列数据，如果 `isTTY` 是 `undefined` 的话，则切换到更容易解析的方式。

## 总结

开始使用 JavaScript 并使用 `console.log` 记录你的第一行是很快的，但是当你将代码带到生产环境时，你应该考虑更多关于记录的内容。本文仅介绍各种方法和可用的日志记录解决方案。它不包含你需要知道的一切。我建议你检查一些你最喜欢的开源项目，看看它们如何解决日志记录问题以及它们使用的工具。现在去记录所有的事情，不要打印你的日志😉

![GIF of endless printing of a document](https://s3.amazonaws.com/com.twilio.prod.twilio-docs/original_images/mDf8ceyn8JviZCtuUmtELF8nB0-JFgfvtuRqE6kGRq_9OBdN54bcmQNMKDJ_YdFPOuqO5T_pSHHKV4)

如果你知道或找到任何我应该明确提及的工具，或者如果你有任何问题，请随时联系我。我等不及想看看你做了什么。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
