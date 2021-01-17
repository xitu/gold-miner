> * 原文地址：[A Review of JavaScript Testing Frameworks in 2021](https://medium.com/javascript-in-plain-english/a-review-of-javascript-testing-frameworks-in-2021-fe5934567c2a)
> * 原文作者：[Kisan Tamang](https://medium.com/@kisantamang)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/a-review-of-javascript-testing-frameworks-in-2021.md](https://github.com/xitu/gold-miner/blob/master/article/2021/a-review-of-javascript-testing-frameworks-in-2021.md)
> * 译者：
> * 校对者：

# A Review of JavaScript Testing Frameworks in 2021

#### Based on the State of JS 2020 Survey

![Usage of JS Testing Frameworks. Source: State of JS 2020](https://cdn-images-1.medium.com/max/3060/1*bpLclR6tFirmgc0bs3BvHQ.png)

Testing is one of the essential parts of Software Engineering. If you are new to testing, you might ask the same question as everybody does. Why the hell should I write tests? If the functionality is just working perfectly.

Well, we write tests to check the functionality of the code. Whether the code is working as expected or not. We don’t write tests to find the bug in the code.

To write tests for JavaScript and Node applications, there are so many frameworks available.

In this article, we will closely look at some of the popular testing frameworks available today.

#### 1. Jest

**Github Stars:**** 38.3k**

![](https://cdn-images-1.medium.com/max/2000/0*ORx4FzFx1702SS1x.png)

Jest is a delightful JavaScript Testing Framework with a focus on simplicity. It works with projects using: [Babel](https://babeljs.io/), [TypeScript](https://www.typescriptlang.org/), [Node](https://nodejs.org/en/), [React](https://reactjs.org/), [Angular](https://angular.io/), [Vue](https://vuejs.org/), and more!

Jest is one of my favorite frameworks. It is fast, safe, easy to use, and well documented. Based on the [State of JS survey 2020](https://2020.stateofjs.com/en-US/), it is one of the most used testing frameworks among javascript developers. And, the surveys show that most of the developers are interested in learning it.

![](https://cdn-images-1.medium.com/max/3002/1*ABMiYTBr54hUQ0z70H5DGw.png)

---

#### 2. Mocha

**GitHub Stars**: **20.2k**

![Mocha Logo](https://cdn-images-1.medium.com/max/2000/1*if41jUf_RLXNEjCSz-2aBQ.png)

Mocha is a JavaScript test framework for Node.js programs, featuring browser support, asynchronous testing, test coverage reports, and use of any assertion library.

Simple, flexible, fun javascript test framework for both node.js & the browser. Based on

Based on the [State of JS survey 2020](https://2020.stateofjs.com/en-US/), it is one of the second most used testing frameworks among javascript developers after jest.

---

#### 3. Jasmine

**GitHub Stars**: **15k**

![](https://cdn-images-1.medium.com/max/NaN/1*4deASSS8X3i5_G0zBiYXDA.png)

Jasmine is a behavior-driven development framework for testing JavaScript code. It does not depend on any other JavaScript frameworks. It does not require a DOM. And it has a clean, obvious syntax so that you can easily write tests.

The survey shows a lot of developers are using Jasmine. But the interest of developers in the framework has decreased.

![Usage of the Testing frameworks. Source: State of JS 2020](https://cdn-images-1.medium.com/max/NaN/1*bpLclR6tFirmgc0bs3BvHQ.png)

---

#### 4. AVA

**GitHub Stars**: **18.6k**

![](https://cdn-images-1.medium.com/max/2000/0*_MnNTc5DD3wLQJMu)

AVA is a test runner for Node.js with a concise API, detailed error output, embrace of new language features, and process isolation that lets you develop with confidence.

---

#### 5. Puppeteer

**GitHub Stars:** **68.2k**

![](https://cdn-images-1.medium.com/max/2560/0*gfOux77U2JV6g3C5)

Puppeteer is a Node library that provides a high-level API to control Chrome or Chromium over the [DevTools Protocol](https://chromedevtools.github.io/devtools-protocol/). Puppeteer runs [headless](https://developers.google.com/web/updates/2017/04/headless-chrome) by default but can be configured to run full (non-headless) Chrome or Chromium.

---

Other popular testing library includes [Sinon.js](https://github.com/sinonjs/), [Chai](https://www.chaijs.com/), [Cypress](https://www.cypress.io/), etc. I have personally use Sinon.js. It is standalone test spies, stubs, and mocks for JavaScript and works with any unit testing framework.

#### Conclusion

Don’t be confused with these frameworks. All they do is provide a nice environment to test your code. The survey also shows that Jest has become a favorite among the developers. I’ve been using Jest to test my Node applications as well.

If you are a Node developer or React developer I highly recommend using Jest.

If you enjoyed reading, be sure to like and comment.

Happy learning!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
