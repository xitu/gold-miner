>* 原文链接 : [AFTER A YEAR OF USING NODEJS IN PRODUCTION](http://geekforbrains.com/post/after-a-year-of-nodejs-in-production)
* 原文作者 : [GEEK FOR BRAINS](http://geekforbrains.com/)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [cdpath](https://github.com/cdpath)
* 校对者: [godofchina](https://github.com/godofchina) , [Zhangjd](https://github.com/Zhangjd)

# 在生产环境中使用 NODEJS 一年记

本文是[「我为什么弃 Python 从 Node.js」](http://geekforbrains.com/post/why-im-switching-from-python-to-node-js)一文的续集。一年多前，我因为对 Python 的挫败，还想解释为什么转而尝试 Node ，故写下那篇文章。

一年后，公司内部的 CLI（命令行） 工具，客户项目以及[我司](http://inputlogic.ca)产品的更新，这些都是我学到的。不仅仅是 Node，基本上对 JavaScript 也学到不少。

### 易学难精

Node 学起来很容易，尤其是对有 JavaScript 的基础的人。谷歌搜索一些入门教程，折腾一会儿 Express，就可以上道了，不是吗？然后你发现需要折腾数据库。没问题，搜索 NPM。哦，发现不少适用的 SQL 包。稍后你意识到所有的 ORM（对象关系映射）工具都很糟糕，最基本的数据库引擎才是最好的选择。然后就陷在手动实现冗余模型和验证逻辑的泥潭中不能自拔。随后你开始写更复杂的检索语句，开始迷失在回调函数中。自然，你读到了回调函数大坑，砍掉圣诞树，开始选一个 promise 库来用。现在你 Promisify 了一切，终于可以干一杯啤酒了。

上面实际是在说 Node 生态系统仍在经历持续的变革。这不是什么好事。好像每天都有更好的工具涌现取代旧工具。总有新奇的玩意可以取代其他东西。你会感到诧异这些竟会轻易发生在自己头上，而社区在似乎鼓励这种行为。你在用 Grunt！？大家都在用 Gulp！？等等，不对，应该用原生 NPM 脚本！

NPM 有些包只有不足十行代码，每天会被下载数千次。开什么玩笑！？检查个数组类型也要有依赖？甚至诸如 React 和 Babel 的巨型工具也在用这些包。

高速变革的技术根本无法掌握，更别提依赖包潜在的不稳定性。

### 处理错误，自求多福

如果用过 Python，Ruby 或 PHP 这类语言，你可能觉得通过抛出并捕获错误，甚至用函数返回错误的方式来处理错误再自然不过了。但是 Node 不行。相反，你必须用回调函数（或者 promise）传递错误，没错，就是不能抛出异常。当你深陷数个回调函数还试图跟踪调用栈的时候，Node 这种机制就没法用了。更不用说如果你忘了返回一个错误的回调函数，Node 会在你返回第一个错误之后继续运行然后引发其他错误。你会翻倍客户的费用来弥补 debug 的时间。

哪怕你想方设法构造了可靠的自定义错误标准，你也无法（在不阅读源码的前提下）保证已安装的所有 NPM 包都遵循相同的标准模板。

这些问题直接带来了「全捕获」异常处理器的使用，干脆直接记录下问题然后让你的 App 优雅地去屎。牢记，Node 是单线程。如果进程被锁，所有东西都会崩溃。不过这也没什么，你反正可以用 Forever，Upstart 还有 Monit 对吗？

### 回调函数，Promise 还是生成器？

为了搞定回调函数大坑，错误处理以及基本上很难读懂的逻辑，越来越多的开发者开始用 Promise。基本上就是用一种看上去像异步代码的东西来回避可怕的回调函数逻辑。不幸的是并没有一个标准（跟 Javascript 中的其他东西一样一样的）来规范该如何执行或使用 promise。

现在最值得注意的是 [Bluebird](http://bluebirdjs.com/docs/getting-started.html)。相当不错，速度快，用来搞一些「够用」的小东西相当不错。但是我觉得不得不把必要的东西都包裹在 `Promise.promisifyAll()` 简直是跑偏了。

大多数时候，我最后还是会用优秀的 [async](https://github.com/caolan/async) 库来收拾回调函数这一烂摊子。感觉自然多了。

在我体验 Node 进入尾声的时候，生成器越来越流行了。我没有很深入了解生成器，所以没什么好反馈的。希望能听到对此有经验的人的声音。

### 糟糕的标准

最后一件令我沮丧的东西就是标准的缺失。似乎每个人都对上述几点有自己的想法。回调函数？ Promise？错误处理？构建脚本？这话题根本说不完。

这还只是冰山一角。当然似乎也没有人能就如何写标准的 Javascript 达成共识。随手 Google 一把「Javascript 编程标准」你就懂我意思了。

我意识到许多语言都没有严格的结构，但是这些语言的维护者却都给出了编程标准。

我唯一能想到的还不错的 Javascript编程标准来自 [Mozilla](https://developer.mozilla.org/en-US/docs/Mozilla/Developer_guide/Coding_Style)。

### Node 终极感想

我花了一年的工夫尝试让我的团队使用 Javascript（具体地说是 Node）。但是这一年来我们浪费在追更新的文档，构想标准，争论使用哪个库以及 debug 无关紧要的代码的时间比其他事情还要多。

我会建议已具有较大规模的产品使用 Node 吗？当然不。那有人坚持这样干吗？当然。连我都试了。

我还是会向前端开发者推荐诸如 Angular 或 React 的 Javascript 库（好像你还有别的选择似地）。

如果后端服务器较简单，只是用来做 websockets 或 API 转发的话，我还是会推荐 Node。用 Express 实现起来很容易，我们的 [Quoterobot](https://quoterobot.com/) PDF 处理服务器就是这么搞的。只用了一个算上空格和注释才 186 行代码的脚本。而且完全可以胜任。

### 回到 Python

那你现在估计在寻思，我现在在搞啥呢？现在啊，我的大部分 web 产品和 API 的开发工作都是用 Python。基本上都是 Flask 或者 Django 结合 Postgres 或者 MongoDb。

Python 经住了时间的检验，有众多不错的标准，库，易于 debug，完全可以胜任工作。当然 Python 也有缺点。每个语言都有，只要你开始用它编程。出于一些原因 Node 赢得了我的青睐并吸引了我。我并不后悔用过 Node，但是我还是觉得浪费了更多的时间。

我希望 Javascript 和 Node 将来有所改进。我不介意再次使用它。

你的经验又是什么呢？你也经历过我遇到的问题吗？你是否最终又重新启用了更习惯的语言呢？
