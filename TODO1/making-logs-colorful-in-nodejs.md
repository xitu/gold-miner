> * 原文地址：[Making Logs Colorful in NodeJS](https://medium.com/front-end-weekly/making-logs-colorful-in-nodejs-b26b6cf9f0bf)
> * 原文作者：[Prateek Singh](https://medium.com/@prateeksingh_31398)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/making-logs-colorful-in-nodejs.md](https://github.com/xitu/gold-miner/blob/master/TODO1/making-logs-colorful-in-nodejs.md)
> * 译者：[Jessica](https://github.com/cyz980908)
> * 校对者：[Long Xiong](https://github.com/xionglong58)，[Zavier Tang](https://github.com/ZavierTang)

# 给 NodeJS 的 Logs 点颜色看看！

![图片版权：[Bapu Graphics](https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.bapugraphics.com%2Fmultimediacoursetips%2F7-nodejs-tips-and-also-tricks-for-javascript-developers%2F&psig=AOvVaw3ZA2cfk0Y7Q-TxrYBfFgd0&ust=1580829786882000&source=images&cd=vfe&ved=0CAMQjB1qFwoTCMiwnIfYtecCFQAAAAAdAAAAABAD)](https://cdn-images-1.medium.com/max/2000/1*fVkQKafnrC3U6YL7yynPag.jpeg)

在任何应用中，日志都是一个非常重要的部分。我们借助它来调试代码，还可以将它通过 [Splunk](https://en.wikipedia.org/wiki/Splunk) 等框架的分析处理，了解应用中的重要统计数据。从我们敲出 “Hello Word!” 的那一天起，日志就成为了我们的好朋友，帮助了我们很多。所以说，日志基本上是所有后端代码架构中必不可少的部分之一。市面上有许多可用的日志库，比如 [Winston](https://github.com/winstonjs/winston)、[Loggly](https://www.loggly.com/docs/api-overview/)、[Bunyan](https://github.com/trentm/node-bunyan) 等等。但是，在调试我们的 API 或者需要检查某个变量的值时，我们需要的只是用 JavaScript 的 **console.log（）** 来输出调试。我们先来看一些您可能会觉得很熟悉的日志代码。

```javascript
console.log("MY CRUSH NAME");
console.log("AAAAAAA");
console.log("--------------------");
console.log("Step 1");
console.log("Inside If");
```

为什么我们要放这样做？是因为懒吗？不，这样输出日志，是因为需要将我们期待的输出与控制台上打印的其他日志区分开。

![图 1](https://cdn-images-1.medium.com/max/2730/1*UdH0W6yGIk3z3ptPrO5nog.png)

目前我们仅仅在当前的控制台增加了 console.log(“Got the packets”) 这一行。您能在这堆日志（图 1）中找到 “Got the packets” 吗？我知道找到这条日志是很困难的。那么该怎么做呢？如何才能使我们的开发更加顺手，日志看起来更加优雅。

## 有颜色的 Log

如果我告诉您，这些日志可以同时用各种各样的颜色打印出来。这样开发就会更加顺手了，对吧?让我们看看下一张图片，并再次找一找 “**Got the packets**” 这条 log。

![图 2](https://cdn-images-1.medium.com/max/2732/1*yPiqGs3XlYqywqZ0AdoTAg.png)

“**Got the packets**“ 现在是明显的红色。很棒吧？我们可以将不同的 log 用不同的颜色表示。我打赌这个技能会改变您的日志风格，让日志变得更简单。我们来再看一个例子。

![图 3](https://cdn-images-1.medium.com/max/2732/1*puJJ71wiSgqCv_h_L4qREg.png)

新添加的 log 也是明显的。现在让我们来看看如何实现这个功能。我们可以使用 **Chalk** 包来实现这一点。

## 安装

```bash
npm install chalk
```

## 使用

```javascript
const chalk = require('chalk');
console.log(chalk.blue('Hello world!'));//打印蓝色字符串
```

您也可以自己定制主题并使用，就像下面这样。

```javascript
const chalk = require('chalk');

const error = chalk.bold.red;

const warning = chalk.keyword('orange');

console.log(error('Error!'));
console.log(warning('Warning!'));
```

基本上它就像 chalk[修改符][颜色] 这样，我们可以在代码中打印彩色日志 😊。“**Chalk**” 包给我们提供了很多修改符和颜色来打印。

## 修饰符

* `reset` —— 重置当前颜色链。
* `bold` —— 加粗文本。
* `dim` —— 使亮度降低。
* `italic` —— 将文字设为斜体。**（未被广泛支持）**
* `underline` —— 使文字加下划线。**（未被广泛支持）**
* `inverse` —— 反色背景和前景色。
* `hidden` —— 打印文本，但使其不可见。
* `strikethrough` —— 在文本的中间画一条水平线。**（未被广泛支持）**
* `visible` —— 仅当 Chalk 的颜色级别 > 0 时才打印文本。它对于输出一个整洁好看的日志很有帮助。

## 颜色

* `black`
* `red`
* `green`
* `yellow`
* `blue`
* `magenta`
* `cyan`
* `white`
* `blackBright`（即：`gray`、`grey`）
* `redBright`
* `greenBright`
* `yellowBright`
* `blueBright`
* `magentaBright`
* `cyanBright`
* `whiteBright`

感谢您的阅读。后续，我将向您更新一些不太为人所知的 JavaScript 小技巧，帮助您的开发更加顺手。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
