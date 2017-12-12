> * 原文地址：[So you want to learn React.js?](https://edgecoders.com/so-you-want-to-learn-react-js-a78801d3cd4d)
> * 原文作者：[Samer Buna](https://edgecoders.com/@samerbuna?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/so-you-want-to-learn-react-js.md](https://github.com/xitu/gold-miner/blob/master/TODO/so-you-want-to-learn-react-js.md)
> * 译者：[tvChan](https://github.com/tvChan)
> * 校对者：[kangkai124](https://github.com/kangkai124) [jonjia](https://github.com/jonjia)

# 听说你想学 React.js ？

![](https://cdn-images-1.medium.com/max/2000/1*Wz7GxmF1-xFe5zvNTHETxQ.png)

首先，你需要接受一个事实，就是为了使用 React 你需要学习除了 React 之外更多的知识。这是件好事，React 这个库在某些场景下使用是非常棒的，但它并不能解决所有问题。

而且，请先确认你现在是否在学习 React，这主要是为了不让你对学习 React 本身感到困惑。一个熟悉 HTML 和其他一种编程语言的程序员，他应该能够在一天或更短时间内 100% 的掌握 React。一个新手程序员应该在一个星期就能掌握 React。当然，这不包括用来完善 React 的工具及其他库，例如 Redux 和 Relay。

有序地学习是一件重要的事情，这个顺序会根据你掌握的技能而有所不同。不言而喻，首先你需要对 JavaScript 本身有清晰的理解，当然， HTML 也是。我想在这详细说明下，如果你不知道如何使用数组的 map 或 reduce 方法，或者你不理解闭包，[回调](https://edgecoders.com/asynchronous-programming-as-seen-at-starbucks-fc242cf16aa#.wb5c6opp7)的概念，又或者如果在 JavaScript 代码中看到“this”使你感到困惑。那么你还没有准备好学习 React ，而且在 JavaScript 的领域你还有很多东西需要学习。

首先更新 JavaScript 的知识并不是一件坏事，主要是你需要学习 ES2015，并不是因为 React 依赖它（事实也并不依赖 ES2015）。但因为它是一个更好的语言，因此大多数示例，课程和教程都会使用现代的 JavaScript 语法。具体来说，你需要以下内容：

* 对象字面量和模板字符串的新特性
* 块级作用域 和 let/const 和 var 的区别
* 箭头函数
* 解构和默认值／剩余参数／扩展运算符
* 类和继承（用于定义组件，但是避免其他方式使用）
* 使用类字段语法和箭头函数定义方法
* Promise 对象以及如何配合 async/await 使用
* 引入和导出模块（最重要的）

你不需要从 ES2015 开始学习，但最终你还是需要学习它（并不是因为你正在学习 React）

所以除了 ES2015 以外的东西，要成为一个高效的 React 开发者你还需要学习以下内容：

* [React](https://facebook.github.io/react/docs/react-api.html)，[ReactDOM](https://facebook.github.io/react/docs/react-dom.html)，[ReactDOMServer](https://facebook.github.io/react/docs/react-dom-server.html) 的 API：这些 API 并不是那么常用，我们平时用到的（谈论到的）大概只有 25 个左右，你很少会全部使用到。[React 的官方文档](https://facebook.github.io/react/docs/hello-world.html) 实际上它是一个很好的起点（它最近变得更好了），但是如果你还是很困惑，可以观看[在线课程](https://www.pluralsight.com/search?q=buna&categories=all)，[阅读一本书](https://www.syncfusion.com/resources/techportal/details/ebooks/Reactjs_Succinctly)，或者参加一个[专门的研讨会](https://jscomplete.com/)。你的选择无穷无尽，但要小心你挑选的内容，确保它关注的内容是 React 本身，而不是它的工具和生态系统。

![](https://ws1.sinaimg.cn/large/006LnBnPgy1fm8n5p37jwj30lc0ozn3w.jpg)

* [node 和 npm](https://www.pluralsight.com/courses/nodejs-advanced)：你需要学习这些（为了 React）的原因，是因为在 [npmjs.org](http://npmjs.org/) 上有很多的工具包，可以让你的编程生活更轻松。而且，自从 Node 允许在服务器端执行 JavaScript 代码后，你可以在服务器端复用前端的 React 代码（同构／跨平台应用）。大多数情况下，你会发现配合像 webpack 这样的模块打包工具时，就更能彰显 node 和 npm 的价值。更重要的是，当你编写大型应用程序时，你至少需要一个工具来处理 JSX （忽略 JSX 是可选的建议）。学习并使用 JSX，推荐的工具是 Babel.js。
* React 生态系统库：因为 React 只是一个构建页面 UI 的语言，你需要结合其他工具库来完成页面的展示和 MVC 实现。不要等到你对 React 很熟悉后才开始这一步。一旦你完成 React 的学习，我建议你关注 react-router 和 redux 这两个工具库，忘掉你之前学习的东西，先学习这两个库。
* 在熟悉 React 本身的原始概念之后，马上构建一个 [React Native](https://facebook.github.io/react-native/) 的应用程序。你一旦这么做，你将会只体会到 React 的美。相信我。

![](https://ws1.sinaimg.cn/large/006LnBnPgy1fm8n5op3eqj30lf088t9l.jpg)

在你学习的过程中，你能做到最好的事就是靠自己双手构建东西。不要复制粘贴例子，也不要盲目地遵循说明，而是参照说明构建其他东西（理想情况下，你更在乎的东西）。无论你做什么，不要只做一个[ TODOs 应用程序](https://hackernoon.com/a-react-todos-example-explained-6df53cdebed1)。

我发现构建简单的游戏比用数据驱动的严肃的 web 应用程序能更好地展示 React 的思想。这就是为什么在我的 [**React.js 入门课程**](https://www.pluralsight.com/courses/react-js-getting-started)中，我专注于构建简单的游戏。我还在我的[**《简洁的 React.js》**](https://www.syncfusion.com/resources/techportal/details/ebooks/Reactjs_Succinctly)中构建了另一个[不同的游戏](http://jscomplete.com/react-examples/memory-grid-game/)，你可以免费阅读。尝试在[ JavaScript 在线开发平台](https://jscomplete.com/repl) 中实现其他类似的游戏，这是一个好的开始，你不需要服务器，也不需要管理那些烦人的 state。

[ **JavaScript REPL 和 React.js 开发平台**
**通过jsComplete交互式实验学习 JavaScript 和 React.js** jscomplete.com](https://jscomplete.com/repl)

最近，我为 jsComplate 创建了一个交互式的音频学习工具。我测试这工具的第一个实验是一个 [React.js 的例子](http://jscomplete.com/interactive-learning-demo/)。如果你有做实验，请务必留下你的反馈意见。

祝你好运并玩得开心！如果你提问得很好，我会很乐意的看看你第一个 React 应用程序并给你一些指导。

**感谢您的阅读，如果你发现这篇文章对你有帮助，请点击下面的 💚，跟随我发现更多关于 React.js 和 JavaScript 的文章吧。**


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
