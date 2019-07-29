> * 原文地址：[Improve Your JavaScript Knowledge By Reading Source Code](https://www.smashingmagazine.com/2019/07/javascript-knowledge-reading-source-code/)
> * 原文作者：[Carl Mungazi](https://www.smashingmagazine.com/author/carl-mungazi/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/javascript-knowledge-reading-source-code.md](https://github.com/xitu/gold-miner/blob/master/TODO1/javascript-knowledge-reading-source-code.md)
> * 译者：[MarchYuanx](https://github.com/MarchYuanx)
> * 校对者：[imononoke](https://github.com/imononoke), [Baddyo](https://github.com/Baddyo)

# 通过阅读源码提高你的 Javascript 水平

快速摘要：当你还处于编程生涯的初期阶段时，深入研究开源库和框架的源代码可能是一项艰巨的任务。在本文中，Carl Mungazi 分享了他如何克服恐惧，并开始用源码来提高他的知识水平和专业技能。他还使用了 Redux 来演示他如何解构一个代码库。

你还记得你第一次深入研究你常用的库或框架的源码时的情景吗？对我来说，这一刻发生在三年前我作为前端开发者的第一份工作中。

当时我们刚刚完成了用于创建网络学习课程的内部遗留框架的重构。在重构开始时，我们花时间研究了许多不同的解决方案，包括 Mithril、Inferno、Angular、React、Aurelia、Vue 和 Polymer。那时我仅仅只是个小萌新（我刚从新闻工作转向 web 开发），我记得我对每个框架的复杂性感到恐惧，不理解它们是如何工作的。

随着对我们所选择的 Mithril 框架研究的深入，我对它的理解也逐渐加深了。从那以后，我花了很多时间深入钻研那些在工作或个人项目中日常使用的库的内部结构，这显著地提升了我对 JavaScript —— 以及通用编程思想 —— 的了解。在这篇文章中，我将分享一些方法给你，你可以使用自己喜欢的库或框架，并将其作为学习工具。

[![Mithril 中 hyperscript 函数的源码](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/a94d53ac-c580-4a50-846d-74d997c484d9/2-improve-your-javascript-knowledge-by-reading-source-code.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/a94d53ac-c580-4a50-846d-74d997c484d9/2-improve-your-javascript-knowledge-by-reading-source-code.png)

我要介绍的第一个源码阅读示例是 Mithril 的 hyperscript 函数。（[高清预览](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/a94d53ac-c580-4a50-846d-74d997c484d9/2-improve-your-javascript-knowledge-by-reading-source-code.png)）

### 阅读源码的好处

阅读源代码的一个主要好处是可以学到很多东西。在我第一次读 Mithril 代码库时，我对虚拟 DOM 的概念还很模糊。当我读完后，我了解到虚拟 DOM 是一种技术，它创建一个对象树，用于描述用户界面的外观。然后使用 DOM APIs（如 `document.createElement`）将对象树转换为 DOM 元素。通过创建描述用户界面的更新状态的新对象树，然后将其与旧对象树进行比较来执行更新。

我在各种文章和教程中已经阅读了所有这些内容，虽然这很有帮助，但对我来说，能够在我们提供的应用程序的环境中观察到它工作是非常有启发性的。它还教会我在比较不同框架时应该考虑哪些因素。例如，我现在知道要考虑这样的问题，“每个框架执行更新的方式如何影响性能和用户体验？”，而不是只看框架在 GitHub 上 star 的数量。

另一个好处是你对优秀的程序架构的理解和鉴赏能力提升了。虽然大多数开源项目的存储库通常遵循相同的结构，但每个项目都包含差异。Mithril 的结构非常简单，如果你熟悉它的 API，你可以根据文件夹名称推测出其中的代码的功能，如 `render`、`router` 和 `request`。另一方面，React 的结构反映了它的新架构。维护人员将负责 UI 更新的模块（`react concerner`）与负责呈现 DOM 元素的模块（`react dom`）分开。

这样做的好处之一是，开发人员现在更容易通过挂进 `react-reconciler` 包来编写自己的[自定义渲染器](https://github.com/chentsulin/awesome-react-renderer)。我最近研究过的模块打包工具 Parcel 也有像 React 这样的 `packages` 文件夹。主模块名为 `parcel-bundler`，它包含负责创建包、启动热模块服务器和命令行工具的代码。

[![JavaScript 语言规范中解释 Object.prototype.toString 原理的章节](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/6777ea35-ee97-40c4-a0b8-5b4c2455f733/1-improve-your-javascript-knowledge-by-reading-source-code.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/6777ea35-ee97-40c4-a0b8-5b4c2455f733/1-improve-your-javascript-knowledge-by-reading-source-code.png)

不久之后，你所阅读的源码将引导你找到 JavaScript 规范。（[高清预览](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/6777ea35-ee97-40c4-a0b8-5b4c2455f733/1-improve-your-javascript-knowledge-by-reading-source-code.png)）

另一个好处 —— 令我感到惊讶的是 —— 你可以更轻松地阅读定义语言如何工作的官方 JavaScript 规范。我第一次阅读规范是在研究 `throw Error` 与 `throw new Error`（剧透警告 —— [二者没有区别](http://www.ecma-international.org/ecma-262/7.0/#sec-error-constructor)）之间的区别时。我研究这个问题是因为我注意到 Mithril 在其 `m` 函数的实现中使用了 `throw Error`，我想知道这种用法是否比使用 throw new Error 更好。从那以后，我还了解了逻辑运算符 `&&` 和 `||` [不一定返回布尔值](https://tc39.es/ecma262/#prod-LogicalORExpression)，找到了控制 `==` 等于运算符如何强制转换值的[规则](http://www.ecma-international.org/ecma-262/#sec-abstract-equality-comparison)和 `Object.prototype.toString.call({})` 返回 `'[object Object]'` 的[原因](http://www.ecma-international.org/ecma-262/#sec-object.prototype.tostring)。

### 阅读源码的技巧

有很多方法可以处理源码。我发现最简单的方法是从你选择的库中选择一个方法，并记录当你调用它时会发生什么。不要每一个步骤都记录，而是尝试理解它的整体流程和结构。

我最近用这个方法阅读了 ReactDOM.render 的源码，因此学到了很多关于 React Fiber 及其实现背后的一些原因。谢天谢地，由于 React 是一个流行的框架，在同样的问题上，我找到了很多其他开发者撰写的文章，这让我的学习进程快了许多。

这次深入研究还让我明白了[合作调度](https://developer.mozilla.org/en-US/docs/Web/API/Background_Tasks_API)的概念、[`window.requestIdleCallback`](https://developer.mozilla.org/en-US/docs/Web/API/Window/requestIdleCallback) 方法和一个[链接列表的实际示例](https://github.com/facebook/react/blob/v16.7.0/packages/react-reconciler/src/ReactUpdateQueue.js#L10)（React 通过将更新放入一个队列来处理它们，这个队列是一个按优先级排列的链接列表）。在研究过程中，建议使用库创建非常基本的应用程序。这使得调试更容易，因为你不必处理由其他库引起的堆栈跟踪。

如果我不打算进行深入研究，我会打开正在开发的项目中的 /node_modules 文件夹，或者到 GitHub 仓库中去查看源码。这通常发生在我遇到一个 bug 或有趣的特性时。在 GitHub 上阅读代码时，请确保你阅读的是最新版本。你可以通过单击用于更改分支的按钮并选择“tags”来查看具有最新版本标记的提交中的代码。库和框架永远在进行更改，因此你不会想了解可能在下一版本中删除的内容。

还有另一种不太复杂的阅读源码的方法，我喜欢称之为“粗略一瞥”。在我开始阅读代码的早期，我安装了 **express.js**，打开了它的 `/node_modules` 文件夹并浏览了它的依赖项。如果 `README` 没有给我一个满意的解释，我就会阅读源码。这样做让我得到了这些有趣的发现：

* Express 依赖于两个模块，两个模块都合并对象，但以非常不同的方式进行合并。`merge-descriptors` 只添加直接在源对象上直接找到的属性，它还合并了不可枚举的属性，而 `utils-merge` 只迭代对象的可枚举属性以及在其原型链中找到的属性。`merge-descriptors` 使用 `Object.getOwnPropertyNames()` 和 `Object.getOwnPropertyDescriptor()` 而 `utils-merge` 使用 `for..in`；
* `setprototypeof` 模块提供了一种设置实例化对象原型的跨平台方式；
* `escape-html` 是一个有 78 行代码的模块，用于转义一系列内容，可以在 HTML 内容中进行插值。

虽然这些发现不可能立即有用，但是对库或框架所使用的依赖关系有一个大致的了解是有用的。

在调试前端代码时，浏览器的调试工具是你最好的朋友。除此之外，它们允许你随时停止程序并检查其状态，跳过函数的执行或进入或退出程序。有时这不能立即生效，因为代码已经压缩。我倾向于将它解压并将解压的代码复制到 `/node_modules` 文件夹中的对应文件中。

[![ReactDOM.render 函数的源码](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/798703fd-8689-40d9-9159-701f1a00f837/3-improve-your-javascript-knowledge-by-reading-source-code.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/798703fd-8689-40d9-9159-701f1a00f837/3-improve-your-javascript-knowledge-by-reading-source-code.png)

像处理任何其他应用程序一样处理调试。形成一个假设，然后测试它。（[高清预览](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/798703fd-8689-40d9-9159-701f1a00f837/3-improve-your-javascript-knowledge-by-reading-source-code.png)）

### 研究案例：Redux 的 Connect 函数

React-Redux 是一个用于管理 React 应用程序状态的库。在处理这些流行的库时，我首先搜索有关其实现的文章。在这个案例研究中，我找到了这篇[文章](https://blog.isquaredsoftware.com/2018/11/react-redux-history-implementation)。这是阅读源码的另一个好处。研究阶段通常会引导你阅读这样的信息性文章，这些文章会提高你的思考与理解。

`connect` 是一个将 React 组件连接到应用程序的 Redux 存储的 React-Redux 函数。怎么连？好的，根据[文档](https://react-redux.js.org/api/connect)，它执行以下操作：

> “...返回一个新的连接的组件类，它包装您传入的组件。”

看完之后，我会问下列问题：

* 我是否知道哪些模式或概念，其函数能够接受一个输入并将输入封装、加上附加功能再返回输出？
* 如果我知道这样的模式，我如何根据文档中给出的解释来实现它？

通常，下一步是创建一个使用 `connect` 的非常基础的示例应用程序。但是，在这种情况下，我选择使用我们在 [limejump](https://limejump.com/) 上构建的新的 React 应用程序，因为我希望在最终要进入生产环境的应用程序的上下文环境中理解 `connect`。

我关注的组件看起来像这样：

```
class MarketContainer extends Component {
 // 简洁起见，省略代码（code omitted for brevity）
}

const mapDispatchToProps = dispatch => {
 return {
   updateSummary: (summary, start, today) => dispatch(updateSummary(summary, start, today))
 }
}

export default connect(null, mapDispatchToProps)(MarketContainer);
```

它是一个容器组件，包裹着四个较小的连接的组件。在导出 `connect` 方法的[文件](https://github.com/reduxjs/react-redux/blob/v7.1.0/src/connect/connect.js)中，你首先看到的是这个注释：**connect is a facade over connectAdvanced**。没走多远，我们就有了第一个学习的时刻：**一个观察 [facade](http://jargon.js.org/_glossary/FACADE_PATTERN.md) 设计模式的机会**。在文件末尾，我们看到 `connect` 导出了对名为 `createConnect` 的函数的调用。它的参数是一组默认值，这些默认值被这样解构：

```
export function createConnect({
 connectHOC = connectAdvanced,
 mapStateToPropsFactories = defaultMapStateToPropsFactories,
 mapDispatchToPropsFactories = defaultMapDispatchToPropsFactories,
 mergePropsFactories = defaultMergePropsFactories,
 selectorFactory = defaultSelectorFactory
} = {})
```

同样，我们遇到了另一个学习时刻：**导出调用函数**和**解构默认函数参数**。解构部分是一个学习时刻，因为它的代码编写如下：

```
export function createConnect({
 connectHOC = connectAdvanced,
 mapStateToPropsFactories = defaultMapStateToPropsFactories,
 mapDispatchToPropsFactories = defaultMapDispatchToPropsFactories,
 mergePropsFactories = defaultMergePropsFactories,
 selectorFactory = defaultSelectorFactory
})
```

它会导致这个错误 `Uncaught TypeError: Cannot destructure property 'connectHOC' of 'undefined' or 'null'.`。这是因为函数没有可供回调的默认参数。

**注意：有关这方面的更多信息，您可以阅读 David Walsh 的[文章](https://davidwalsh.name/destructuring-function-arguments)。根据你对语言的了解，一些学习时刻可能看起来微不足道，因此最好将注意力放在您以前从未见过的事情上，或需要了解更多信息的事情上。**

`createConnect` 在其函数内部并不执行任何操作。它只是返回一个名为 connect 的函数，也就是我在这里用到的：

```javascript
export default connect(null, mapDispatchToProps)(MarketContainer)
```

它需要四个参数，都是可选的，前三个参数都通过 [match](https://github.com/reduxjs/react-redux/blob/v7.1.0/src/connect/connect.js#L25) 函数来帮助根据参数是否存在以及它们的值类型来定义它们的行为。现在，因为提供给 `match` 的第二个参数是导入 `connect` 的三个函数之一，我必须决定要遵循哪个线程。

如果那些参数是函数，[代理函数](https://github.com/reduxjs/react-redux/blob/v7.1.0/src/connect/wrapMapToProps.js#L29)被用来将第一个参数包装为 `connect`，这是也一个学习的时刻。[isPlainObject](https://github.com/reduxjs/react-redux/blob/v7.1.0/src/utils/isPlainObject.js) 用于检查普通对象或 [warning](https://github.com/reduxjs/react-redux/blob/v7.1.0/src/utils/warning.js) 模块，它揭示了如何将调试器设置为[中断所有异常](https://developers.google.com/web/tools/chrome-devtools/javascript/breakpoints#exceptions)。在匹配函数之后，我们来看 `connectHOC`，这个函数接受我们的 React 组件并将它连接到 Redux。它是另一个函数调用，返回 [wrapWithConnect](https://github.com/reduxjs/react-redux/blob/v7.1.0/src/components/connectAdvanced.js#L123)，该函数实际处理将组件连接到存储的操作。

看看 `connectHOC` 的实现，我可以理解为什么它需要 `connect` 来隐藏它的实现细节。它是 React-Redux 的核心，包含不需要通过 `connect` 展现的逻辑。尽管我原本打算在这个地方结束对它的深度探讨，我也会继续，这将是查阅之前发现的参考资料的最佳时机，因为它包含对代码库的非常详细的解释。

### 总结

阅读源码起初很困难，但与任何事情一样，随着时间的推移变得更容易。我们的目标不是理解一切，而是要获得不同的视角和新知识。关键是要对整个过程进行深思熟虑，并对所有事情充满好奇。

例如，我发现 `isPlainObject` 函数很有趣，因为它使用 `if (typeof obj !== 'object' || obj === null) return false` 以确保给定的参数是普通对象。 当我第一次阅读它的实现时，我想知道为什么它没有使用 `Object.prototype.toString.call(opts) !== '[object Object]'` ，这样能用更少的代码且区分对象和对象子类型，如 Date 对象。但是，读完下一行我发现，在极小概率情况下，例如开发者使用 `connect` 时返回了 Date 对象，这将由`Object.getPrototypeOf(obj) === null` 检查处理。

`isPlainObject` 中另一个吸引人的地方是这段代码：

```javascript
while (Object.getPrototypeOf(baseProto) !== null) {
 baseProto = Object.getPrototypeOf(baseProto)
}
```

有些谷歌搜索结果指向这个 [StackOverflow 问答](https://stackoverflow.com/questions/51722354/the-implementation-of-isplainobject-function-in-redux/51726564#51726564)和这个在 GitHub 仓库中的 [Redux issue](https://github.com/reduxjs/redux/pull/2599#issuecomment-342849867)，解释该代码如何处理诸如检查源自 iFrame 的对象这类情况。

#### 其它的阅读源码的参考链接

* “[How To Reverse Engineer Frameworks](https://blog.angularindepth.com/level-up-your-reverse-engineering-skills-8f910ae10630),” Max Koretskyi, Medium
* “[How To Read Code](https://github.com/aredridel/how-to-read-code/blob/master/how-to-read-code.md),” Aria Stewart, GitHub

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
