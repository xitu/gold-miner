> * 原文地址：[8 Key React Component Decisions: Standardize your React development with these key decisions](https://medium.freecodecamp.org/8-key-react-component-decisions-cc965db11594)
> * 原文作者：[Cory House](https://medium.freecodecamp.org/@housecor?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/8-key-react-component-decisions.md](https://github.com/xitu/gold-miner/blob/master/TODO/8-key-react-component-decisions.md)
> * 译者：[undead25](https://github.com/undead25)
> * 校对者：[Tina92](https://github.com/Tina92)、[vuuihc](https://github.com/vuuihc)

# React 组件的 8 个关键决策

## 通过这些关键决策来标准化你的 React 开发

![选择困难症](https://cdn-images-1.medium.com/max/1000/1*XgHYXVXoyziBKd7Or5IliQ.jpeg)


React 自 2013 年被开源以来，一直在迭代更新。当你在网上搜索相关信息时，可能会被一些使用了过时的方法的文章坑到。所以，现在在写 React 组件时，你的团队需要作出以下八个关键决策。

### 决策 1：开发环境

在编写第一个组件之前，你的团队需要就开发环境达成一致。太多选择了……

![](https://i.loli.net/2017/10/17/59e5d90a25a0a.jpg)

当然，你可以[从头开始构建 JS 开发环境](https://www.pluralsight.com/courses/javascript-development-environment)，有 25% 的 React 开发者是这么做的。我目前的团队使用的是 create-react-app 的 fork，并拓展了一些功能，例如[支持 CRUD 的 mock API](https://medium.freecodecamp.org/rapid-development-via-mock-apis-e559087be066)、[可复用的组件库](https://www.pluralsight.com/courses/react-creating-reusable-components)和增强的代码检测功能（我们会检测 create-react-app 忽略了的测试文件）。我是喜欢 create-react-app 的，但[这个工具可以帮助你比较许多不错的替代方案](http://andrewhfarmer.com/starter-project/)。想在服务端进行渲染？可以了解下 [Gatsby](http://gatsbyjs.org) 或者 [Next.js](https://github.com/zeit/next.js/)。你甚至可以考虑使用在线编辑器，例如 [CodeSandbox](https://codesandbox.io)。

### 决策 2：类型检测

你可以忽略类型，也可以使用 [prop-types](https://reactjs.org/docs/typechecking-with-proptypes.html)、[Flow](https://flow.org) 或者 [TypeScript](https://www.typescriptlang.org)。需要注意的是，在 React 15.5 中，prop-types 被提取到了[单独的库](https://www.npmjs.com/package/prop-types)，因此按照较老的文章进行导入会报警告（React 16 会报错）。

社区在这个话题上依然存在着分歧：

![](https://i.loli.net/2017/10/17/59e5da85a81b6.jpg)

我更倾向于 prop-types，因为我发现它在 React 组件中提供了足够的类型安全性，几乎没有任何阻碍。使用 Babel、[Jest](https://facebook.github.io/jest/)、[ESLint](http://www.eslint.org) 和 prop-types 的组合，我很少看到运行时的类型问题。

### 决策 3：createClass 和 ES 类

React.createClass 是原始 API，但在 15.5 中已被弃用。有点感觉[我们将枪头指向了 ES 类](https://medium.com/dailyjs/we-jumped-the-gun-moving-react-components-to-es2015-class-syntax-2b2bb6f35cb3)。不管怎样，createClass 已经从 React 的核心中移除，并被[归类到 React 官方文档中一个名为“React without ES6”的页面](https://reactjs.org/docs/react-without-es6.html)。所以很清楚的是：ES 类是趋势。你可以使用 [react-codemod](https://github.com/reactjs/react-codemod) 轻松地从 createClass 转换为 ES 类。

### 决策 4：类和函数

你可以通过类或函数来声明 React 组件。当你需要 refs 或者生命周期方法时，类很有用。这里有[尽可能考虑使用函数的 9 个理由](https://hackernoon.com/react-stateless-functional-components-nine-wins-you-might-have-overlooked-997b0d933dbc)。但值得注意的是，[函数组件有一些缺点](https://medium.freecodecamp.org/7-reasons-to-outlaw-reacts-functional-components-ff5b5ae09b7c)。

### 决策 5：状态

使用普通的 React 组件状态足以满足大多数场景。[状态提升](https://reactjs.org/docs/lifting-state-up.html)可以很好地解决状态共享的问题。或者，你也可以使用 Redux 或 MobX：

![](https://i.loli.net/2017/10/17/59e5daca05632.jpg)

[我是 Redux 的粉丝](https://www.pluralsight.com/courses/react-redux-react-router-es6)，但我经常使用普通的 React 状态，因为它更简单。就目前来看，我们已经上线了十几个 React 应用程序，其中的两个是值得使用 Redux 的。我更喜欢多个小型的、自治的应用程序而不是单个的大型的应用程序。

如果你对不可变状态感兴趣，这里有一篇相关的文章，提到了至少有 [4 种方式来保持状态不可变](https://medium.com/@housecor/handling-state-in-react-four-immutable-approaches-to-consider-d1f5c00249d5)。

### Decision 6: 绑定

在 React 组件中，至少有[半打方式可以处理绑定](https://medium.freecodecamp.org/react-binding-patterns-5-approaches-for-handling-this-92c651b5af56)。这主要是因为现代 JS 提供了很多方法来处理绑定。你可以在构造函数中绑定，在 render 中绑定，在 render 中使用箭头函数，使用类属性或者装饰器。[这篇文章的评论](https://medium.freecodecamp.org/react-binding-patterns-5-approaches-for-handling-this-92c651b5af56)里有更多的选择！每种方式都有其优点，但假设你觉得实验性功能还不错，[我建议默认使用类属性（也叫属性初始值）](https://medium.freecodecamp.org/react-binding-patterns-5-approaches-for-handling-this-92c651b5af56)。

这个投票是从 2016 年 8 月开始的。从那时起，类属性越来越受欢迎，而 createClass 的欢迎程度则逐步降低。

![](https://i.loli.net/2017/10/17/59e5daf6be182.jpg)

**附注**：许多人对于为什么在 render 中使用箭头函数和绑定可能存在问题而感到困惑。真正的原因是因为[它使 shouldComponentUpdate 和 PureComponent 变得古怪](https://medium.freecodecamp.org/why-arrow-functions-and-bind-in-reacts-render-are-problematic-f1c08b060e36)。

### 决策 7：样式

这里的选择变得非常多，有 50 多种方式来写组件的样式，包括 React 的内联样式、传统的 CSS、Sass/Less、[CSS Modules](https://github.com/css-modules/css-modules) 和 [56 个 CSS-in-JS 选项](https://github.com/MicheleBertoli/css-in-js)。不开玩笑，我在这个[样式模块化课程](https://www.pluralsight.com/courses/react-creating-reusable-components)中详细探索了 React 的样式，下面是总结：

![](https://cdn-images-1.medium.com/max/1000/1*5Q3FXqxI6akM-GWV2rqlcw.png)

红色代表不支持，绿色代表支持，灰色代表警告。

看看为什么在 React 的样式选择中有这么多的分歧？没有明确的赢家。

![](https://cdn-images-1.medium.com/max/800/1*_K-z-ZfTXNFwyedAXrS5sA.png)

看起来 CSS-in-JS 正在蒸蒸日上，而 CSS modules 正在每况愈下。

我目前的团队使用 Sass 和 BEM，并乐在其中，但我也喜欢[样式组件](https://www.styled-components.com)。

### 决策 8：逻辑复用

React 最初采用 [mixins](https://reactjs.org/docs/react-without-es6.html#mixins) 作为组件之间共享代码的机制。但是 mixins 有问题，[现在被认为是有害的](https://reactjs.org/blog/2016/07/13/mixins-considered-harmful.html)。你不能在 ES 类组件中使用 mixins，所以现在我们[使用高阶组件](https://reactjs.org/docs/higher-order-components.html)和[渲染属性](https//cdb.reacttraining.com/use-a-render-prop-50de598f11ce)（也叫子函数）在组件之间共享代码。

![](https://i.loli.net/2017/10/17/59e5db5a8f656.jpg)

高阶组件目前更受欢迎，但我更喜欢渲染属性，因为它们通常更易于阅读和创建。

[YouTube 视频](https://youtu.be/BcVAq3YFiuc)

### 其他决策

还有一些其他的决策：

* 你使用 [.js 还是 .jsx 拓展名](https://github.com/facebookincubator/create-react-app/issues/87#issuecomment-234627904)?
* 你会将[每个组件放在其自己的文件夹中](https://medium.com/styled-components/component-folder-pattern-ee42df37ec68)吗？
* 你会要求每个组件即一个文件吗？你会[在每个目录写一个 index.js 文件来让别人感到抓狂吗](https://hackernoon.com/the-100-correct-way-to-structure-a-react-app-or-why-theres-no-such-thing-3ede534ef1ed)？
* 如果使用 propTypes，你会在底部声明它们，还是在其自身的类里使用[静态属性](https://michalzalecki.com/react-components-and-class-properties/#static-fields)？你会[尽可能深地声明 propTypes](https://iamakulov.com/notes/deep-proptypes/?utm_content=buffer57abf&utm_medium=social&utm_source=twitter.com&utm_campaign=buffer) 吗？
* 你会传统地在构造函数中初始化状态，还是使用[属性初始化语法](http://stackoverflow.com/questions/35662932/react-constructor-es6-vs-es7)？

由于 React 大多是 JavaScript，所以你需要进行许多 JS 开发风格的决策，例如[分号](https://eslint.org/docs/rules/semi)、[尾随逗号](https://eslint.org/docs/rules/comma-dangle)、[格式化](https://github.com/prettier/prettier)以及[事件处理的命名](https://jaketrent.com/post/naming-event-handlers-react/)。

### 选择一个标准，然后自动化执行

所有的这一切，今天你可能会看到很多组合。

所以，下面这几步是关键：

> 1. 和你的团队讨论这些决策并把你们的标准写成文档。

> 2. 不要浪费时间在代码审查中手动检查不一致。要求你的团队都使用像 [ESLint](https://eslint.org)、[eslint-plugin-react](https://github.com/yannickcr/eslint-plugin-react) 和 [prettier](https://github.com/prettier/prettier) 这些工具。

> 3. 需要重构现有的 React 组件？使用 [react-codemod](https://github.com/reactjs/react-codemod) 来自动化该过程。

如果我忽略了其它的关键决策，请在评论中提出。

### 想了解更多关于 React 的信息？⚛️

我在 Pluralsight（[免费试用](http://bit.ly/pstrialimmutablepost)）上写了[很多 React 和 JavaScript 课程](http://bit.ly/psauthorpageimmutablepost)。

[![](https://cdn-images-1.medium.com/max/800/1*BkPc3o2d2bz0YEO7z5C2JQ.png)](https://www.pluralsight.com/authors/cory-house)

* * *

[Cory House](https://twitter.com/housecor) 是 [Pluralsight 上许多 JavaScript、React、代码整洁之道和 .NET 课程](http://pluralsight.com/author/cory-house)的作者。他是 [reactjsconsulting.com](http://www.reactjsconsulting.com) 的首席顾问、VinSolutions 的软件架构师、Microsoft 的最有价值专家，并且在国际上培训软件开发人员的软件实践，例如前端开发和代码整洁之道。Cory 在 Twitter 上 [@housecor](http://www.twitter.com/housecor) 发布了很多关于 JavaScript 和前端开发的推文。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
