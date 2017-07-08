> * 原文地址：[Modern JavaScript for Ancient Web Developers](https://trackchanges.postlight.com/modern-javascript-for-ancient-web-developers-58e7cae050f9#.ibsx51ylz)
> * 原文作者：[Gina Trapani](https://trackchanges.postlight.com/@ginatrapani?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：[sun](http://suncafe.cc)
> * 校对者：[xilihuasi](https://github.com/xilihuasi)、 [Reid](https://github.com/reid3290)

# 写给“老派” Web 开发者的“现代” JavaScript 指南 #

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*_5XMNVNbpIDCDHU1YXZPyA.png">

用 JavaScript 学习 JavaScript。图片来自 [learnyounode](https://github.com/workshopper/learnyounode)。

有这样一种守旧的后端 web 开发者，他们很久以前就掌握了诸如 Perl 、Python、PHP 或 Java Server Pages 一类的东西，甚至还掌握了 Rails 或者 Django。他们使用巨大的关系型数据库构建 JSON API 服务，呃甚至是 XML。

他是个**后端**开发者， 因此对他而言，JavaScript 一直只是个可以添加一些前端花招，使网页上的东西变色的有趣小玩具。如果说 JavaScript 真的很有用，那也不过是给表单添加验证，以防止错误的数据进入数据库。八年前 [jQuery 让这个人十分震惊](https://twitter.com/ginatrapani/status/3252157585)。JavaScript 本身依然是可以被容忍但从未被接纳的语言。

 随后 JavaScript 及其现代框架侵蚀了后端、前端和他们之间的一切，对于 JavaScript 开发者而言，2017年正是重新成为一个全新 web 开发者的时刻。

Hi.我是一个正在学习现代 JavaScript 的“老派” web 开发者。我才刚刚起步玩得也还算尽兴，当然也踩了一些坑。有一些现代 JavaScript 的概念我希望我能在开始学习之前就融会贯通。

在旧编程语言的惯性思维模式之上学习一个新的生态系统，我在心态和期望方面得做下面一些改变。

### 转移目标 (.jS)

现代 JS 的特点就是朝气蓬勃和发展迅速，所以很容易就选择了过时的框架、模板引擎、构建工具、 教程或者已经不是最佳实践的技术。（如果真有一个被广泛接受的最佳实践的概念的话）

这种情况下，就有必要向你身边的 JavaScript 工程师朋友伸手求助了，和他们聊一聊你的技术路线。我很荣幸在 Postlight 得到了工程师朋友(特别是 [Jeremy Mack](https://medium.com/@mutewinter))的精湛指导，感谢他们容忍我无穷无尽的问题。

我要说的是，学习现代的 JavaScript 需要人为干预。事物还在不断发展变化，各种教程尚未成熟和定型，所谓最佳实践也未形成正式规范。如果你身边没有大牛，那么至少也得检查 Medium 上文章或教程的日期，或 GitHub 仓库的最近一次提交时间。如果时间超过了一年，基本上可以确定已经过时。

### 新的问题，而不是已经确定的解决方案 ###

走类似这样的路线：当你在学习现代 JavaScript 时，你遇到的问题的解决方案还在渐渐得到解决，这正是一个好机会。事实上，很可能仅仅差一次 code review，你在使用这个包时就可以修复问题。

当你在使用一种像 PHP 这样的古老的语言的时候，你可以 Google 一个提问或者问题，几乎百分之百能找到一个 5 年前的 Stack Overflow 回答来解决它，或者你能在（详尽的、大量评论的、无与伦比的）[文档](http://docs.php.net/docs.php)里找到整个描述。

现代 JavaScript 就并非如此了。 我曾经徜徉在 GitHub issues 和源码的时候不止一次找到的都是一些过时的文档。剖析 GitHub 版本库是学习和使用各种包的一部分，而且对于我这样的“老派人”，差之毫厘的学习总是令人迷惑。

### 工具过载 ###

在 2017 年学习 JavaScript 还有另一个不一样的地方：创建程序花费的时间感觉和写应用的时间一样多。需要以“正确的方式”去做的工具、插件、软件包和依赖以及编辑器配置和构建配置所需的绝对数量足以使你在启动项目之前望而却步。

[![Markdown](http://i4.buimg.com/1949/adafb30475d3d36a.png)](https://twitter.com/capndesign/status/832638513048850433/photo/1)

**不要因此止步不前**。我不得不放手去做，从起步到正确配置，允许自己的不完美甚至一些业余，只为舒适地使用自己的工具。（我不会告诉你我曾用 [nodemon](https://nodemon.io/) 做代码检查）随后我会找到更好的方法并且在每个新项目中纳入进来。

这方面 JS 还有大量的工作要做。现代 JavaScript 领域依然是不断变化的，但我一个现代 JS 工程师亲友告诉我，[这份来自 Jonathan Verrecchia 的教程](https://github.com/verekia/js-stack-from-scratch)是目前构建一个当代 JavaScript 栈的不二之选。对，就是现在。

[![Markdown](http://i1.piimg.com/1949/95cedaf271a8c352.png)](https://github.com/verekia/js-stack-from-scratch)

### 教程 / 项目 / 舍弃 / 重复 ###

无论学习什么语言都要经历写代码 - 舍弃 - 写更多代码这个过程。我的现代 JavaScript 学习经历已经成为一个个教程组成的阶梯，然后做一个小巧简单的项目，期间总结出现的疑问和困惑列出清单。然后和我的同事碰头以获得答案和解释，然后刷更多的教程，然后做一个稍微大一些的项目，更多的问题，再碰头，如此重复。

这是迄今为止我在这个过程中经历过的一些研讨会和教程的不完整列表。

- [HOW-TO-NPM](https://github.com/workshopper/how-to-npm) —— npm 是 JavaScript 的包管理器。即使在学习这个教程之前我已经敲打过上千次 “npm install”，但是知道学完这个我才知道 npm 做的所有事情。（在很多项目中我已经转移使用 [yarn](https://github.com/yarnpkg/yarn)，而不是 npm，但所有的概念都是相通的）

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*0NydvP4xLtp13z_HE2Xqyw.png">

`npm i -g how-to-npm`

- [learnyounode](https://github.com/workshopper/learnyounode)——我打算专注于服务端 JavaScript，因为那有令我安逸的东西，那就是 Node.js。Learnyounode 是一个交互式教程，结构上类似 how-to-npm。

- [expressworks](https://github.com/azat-co/expressworks) —— 和前面两个项目类似，Expressworks 是 Express.js 的介绍，一个 Node.js 的 web 框架。在 Postlight 公司 Express 没有得到广泛使用，但对于初学者，它值得学习去上手构建一个简单的 web 应用。
- 现在是时候做点真东西了。我发现 Tomomi Imura 的一篇教程 [Creating a Slack Command Bot from Scratch with Node.js](http://www.girliemac.com/blog/2016/10/24/slack-command-bot-nodejs/) 已经可以学到足够的 Node 和 Express 的新技能来应对工作。因为我专注于后端，使用 Slack 创建一个 “/” 命令是一个很好的开始，因为没有前端演示（Slack 帮你做好了）
- 在构建这个命令的过程中，我不使用演练中所推荐的 ngrok 或者 Heroku，而是使用 [Zeit Now](https://zeit.co/now)，这是任何人可用的、创建快速一次性的 JS 应用的宝贵工具。
- 一旦开始写真正意义的代码，我也开始掉下工具无底洞了，安装 Sublime 插件，获取正确的 [Node 版本](https://github.com/postlight/lux/blob/master/CONTRIBUTING.md#nodejs-version-requirements)，配置 ESLint，使用 [Airbnb 的代码规范 (Postlight 公司的偏好)](https://github.com/airbnb/javascript) —— 这些事情拖了我的后退，但也都是有价值的初始化投资。对于这方面我还在坑里，例如 Webpack 对我来说依然美妙又神秘，不过[这个视频是个很不错的介绍](https://www.youtube.com/watch?v=WQue1AN93YU)*.*
- 某些时候 JS 的异步执行（特别是[回调地狱](http://callbackhell.com/)）开始困扰我，[Promise It Won’t Hurt](https://github.com/stevekane/promise-it-wont-hurt) 是另一个教你怎样使用 Promise 书写优雅异步逻辑的教程。Promise 是用于解决异步执行的 JS 新概念。说实话 Promise 令我耳目一新，他们是巧妙的范式转变。感谢 [Mariko Kosaka](http://kosamari.com/notes/the-promise-of-a-burger-party)，现在我每次买汉堡的时候都能想起这些。
<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*Gh5Pv0ujTuikxGZMeANfCg.png">

burger.resolve() — 图片来自 [The Promise of a Burger Party](http://kosamari.com/notes/the-promise-of-a-burger-party).

我知道在这会陷入各种各样的麻烦，比如尝试使用 [Jest](https://facebook.github.io/jest/) 测试，使用 [Botkit](https://github.com/howdyai/botkit) 让 Slack 机器人更有趣，使用 [Serverless](https://serverless.com/) 真正打破函数式编程的价值。如果你不知道这些是什么意思，其实也没关系。这是一个大世界，我们都有属于自己的路要走。

### **“首先做，然后做对，然后做得更好**.” ###

最后这件最重要的事我一定要提起：不断去做就是学习的过程，做得很糟糕？那也是学习的过程。

[这年头学习现代 JavaScript](https://hackernoon.com/how-it-feels-to-learn-javascript-in-2016-d3a717dd577f#.kclvczou2) 感觉就像是在不知所以然得做无用功。当你在想有这么多时间搬搬砖不是更好吗的时候，Google 的 [Addy Osmani 有个不错的建议](https://medium.com/@addyosmani/totally-get-your-frustration-ea11adf237e3#.t599ja0j3)

> 我鼓励人们采用这种方法来跟上 JavaScript 生态系统：**首先做，然后做对，然后才是做得更好**. […]

> 掌握任何新技能的基本要求都需要时间，实践和技巧。如果不使用每日一库或者响应式学习，容易产生挫败感。学会正确使用 Babel 和 React 花费了我数周时间，学习 Isomorphic JS，WebPack 和其他所有相关的库花了更多的时间。 **简简单单地开始并且从基础做起就好.**

这里**感谢** [ **NodeSchool**](https://nodeschool.io/) 和 [**Free Code Camp**](https://www.freecodecamp.com/)，帮助初学者学习 JavaScript 的两个神奇的网站.  


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
