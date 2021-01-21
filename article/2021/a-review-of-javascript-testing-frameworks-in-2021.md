> * 原文地址：[A Review of JavaScript Testing Frameworks in 2021](https://medium.com/javascript-in-plain-english/a-review-of-javascript-testing-frameworks-in-2021-fe5934567c2a)
> * 原文作者：[Kisan Tamang](https://medium.com/@kisantamang)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/a-review-of-javascript-testing-frameworks-in-2021.md](https://github.com/xitu/gold-miner/blob/master/article/2021/a-review-of-javascript-testing-frameworks-in-2021.md)
> * 译者：想念苏苏的 [PassionPenguin](https://github.com/PassionPenguin)
> * 校对者：

# 2021 年 JavaScript 测试框架回顾

![JavaScript 测试框架的使用情况，数据来源《2020 年 Javascript 状况调查》](https://github.com/PassionPenguin/gold-miner-images/blob/master/a-review-of-javascript-testing-frameworks-in-2021-UsageRanking.jpg?raw=true)

测试运行是软件工程的重要组成部分。如果你不熟悉测试，那你可能会提出和别人一样的问题 —— 如果软件的功能良好地运行了，那我为什么要编写测试呢？

好吧，我们编写测试是用来检查代码的功能，检查代码是否按预期工作。我们不会编写测试来查找代码中的错误。

而如果我们要编写针对 JavaScript 和 Node 应用程序的测试，有很多可用的框架供我们选择。

在本文中，我们将仔细研究当今可用的一些流行的测试框架。

### 1. Jest
**Github Stars**：**38.3k**

![](https://cdn-images-1.medium.com/max/2000/0*ORx4FzFx1702SS1x.png)

Jest 是一个令人愉悦的 JavaScript 测试框架，而它的特性是是易于操作。我们可以在：[Babel](https://babeljs.io/) 、 [TypeScript](https://www.typescriptlang.org/) 、 [Node](https://nodejs.org/en/) 、 [React](https://reactjs.org/) 、 [Angular](https://angular.io/) 、 [Vue](https://vuejs.org/) 等项目中使用它！

Jest 是我最喜欢的框架之一。它快速、安全、易于使用且提供了大量文档。基于 [2020 年 Javascript 状况调查](https://2020.stateofjs.com/zh-cn/) ，它是 JavaScript 开发人员中最常用的测试框架之一。而且调查显示，大多数开发人员都感兴趣于学习它。

![JavaScript 测试框架的使用情况，数据来源《2020 年 Javascript 状况调查》](https://github.com/PassionPenguin/gold-miner-images/blob/master/a-review-of-javascript-testing-frameworks-in-2021-UsageRanking.jpg?raw=true)

### 2. Mocha

**GitHub Stars**：**20.2k**

![Mocha Logo](https://cdn-images-1.medium.com/max/2000/1*if41jUf_RLXNEjCSz-2aBQ.png)

Mocha 是 Node.js 程序的 JavaScript 测试框架，支持浏览器、异步测试、测试覆盖率报告以及任何断言库的使用。 

适用于 Node.js 和浏览器，它简单、灵活度高而且很有趣。基于[2020 年 Javascript 状况调查](https://2020.stateofjs.com/zh-cn/) ，它是仅次于 Jest 的 JavaScript 开发人员中第二常用的测试框架之一。

### 3. Jasmine
**GitHub Stars**：**15k **

![](https://cdn-images-1.medium.com/max/NaN/1*4deASSS8X3i5_G0zBiYXDA.png)

Jasmine 是一个行为驱动开发框架用于测试 JavaScript 代码。它不依赖于任何其他 JavaScript 框架，它不需要DOM，而且它的语法清晰明了，因此你可以轻松使用它编写测试。

调查显示，许多开发人员正在使用 Jasmine。但是开发人员对该框架的兴趣最近有所下降。

![JavaScript 测试框架的兴趣情况，数据来源《2020 年 Javascript 状况》](https://github.com/PassionPenguin/gold-miner-images/blob/master/a-review-of-javascript-testing-frameworks-in-2021-InterestRanking.jpg?raw=true)

### 4. AVA

**GitHub Stars**：**18.6k **

![](https://cdn-images-1.medium.com/max/2000/0*_MnNTc5DD3wLQJMu)

AVA 是 Node.js 的测试框架。它拥有简洁的 API、详细的错误输出。它支持新的语言功能以及支持隔离进程使你更有信心进行开发。

### 5. Puppeteer

**GitHub Stars**：**68.2k**

![](https://cdn-images-1.medium.com/max/2560/0*gfOux77U2JV6g3C5)

Puppeteer 是一个 Node 库。它提供了高级 API 来通过 [DevTools 协议](https://chromedevtools.github.io/devtools-protocol/) 控制 Chrome 或Chromium。Puppeteer 默认运行在 [Headless Chrome](https://developers.google.com/web/updates/2017/04/headless-chrome) ，但你也可以通过配置它，让它运行在完整的 Chrome 或 Chromium 上。

---

其他受欢迎的测试库还包括了 [Sinon.js](https://github.com/sinonjs/) 、 [Chai](https://www.chaijs.com/) 、 [Cypress](https://www.cypress.io/) 。我个人使用了 Sinon.js —— 它是 JavaScript 的支持监察、存储和模拟的测试框架，可与任何单元测试框架一起使用。

## 结论
不要为这些框架混淆。他们所做的只是提供一个很好的环境来测试你的代码。调查还显示，Jest 已成为开发人员最爱的测试框架，而我也一直在使用 Jest 测试我的 Node 应用程序。

如果你是 Node 开发人员或 React 开发人员，我强烈建议你使用 Jest。

祝学习愉快！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
