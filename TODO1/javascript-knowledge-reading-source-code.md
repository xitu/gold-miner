> * 原文地址：[Improve Your JavaScript Knowledge By Reading Source Code](https://www.smashingmagazine.com/2019/07/javascript-knowledge-reading-source-code/)
> * 原文作者：[Carl Mungazi](https://www.smashingmagazine.com/author/carl-mungazi/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/javascript-knowledge-reading-source-code.md](https://github.com/xitu/gold-miner/blob/master/TODO1/javascript-knowledge-reading-source-code.md)
> * 译者：[MarchYuanx](https://github.com/MarchYuanx)
> * 校对者：

# 通过阅读源码提高您的 javascript 知识水平

快速摘要：当您还处于编程生涯的初期阶段时，深入研究开源库和框架的源代码可能是一项艰巨的任务。在本文中，Carl Mungazi 分享了他如何克服恐惧，并开始用源码来提高他的知识水平和专业技能。他还使用了 Redux 来演示他如何解构一个代码库。

你还记得你第一次深入研究你常用的库或框架的源码时的情景吗？对我来说，这一刻发生在三年前我作为前端开发者的第一份工作中。

当时我们刚刚完成了用于创建网络学习课程的内部遗留框架的重构。在重构开始时，我们花时间研究了许多不同的解决方案，包括 Mithril，Inferno，Angular，React，Aurelia，Vue 和 Polymer。由于我是一个小萌新（我刚从新闻工作转向 web 开发），我记得我对每个框架的复杂性感到恐惧，不理解它们是如何工作的。

当我开始更深入地研究我们所选择的框架 Mithril 时，我的理解加深了。从那以后，我对 javascript 的了解 —— 和平时编程 —— 都显著地提升于我深入挖掘的时间，研究那些我每天在工作中或自己的项目中使用的库的内部结构。在这篇文章中，我将分享一些方法给你，你可以使用自己喜欢的库或框架，并将其作为学习工具。

[![The source code for Mithril’s hyperscript function](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/a94d53ac-c580-4a50-846d-74d997c484d9/2-improve-your-javascript-knowledge-by-reading-source-code.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/a94d53ac-c580-4a50-846d-74d997c484d9/2-improve-your-javascript-knowledge-by-reading-source-code.png)

我阅读的源码的第一个介绍是 Mithril 的 hyperscript 函数。([高清预览](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/a94d53ac-c580-4a50-846d-74d997c484d9/2-improve-your-javascript-knowledge-by-reading-source-code.png))

### 阅读源码的好处

阅读源代码的一个主要好处是可以学到很多东西。当我第一次看到 Mithril 的代码库时，我对虚拟 DOM 的含义有了一个模糊的概念。当我完成后，我了解到虚拟 DOM 是一种技术，它创建一个对象树，用于描述用户界面的外观。然后使用 DOM APIs（如 `document.createElement`）将对象树转换为 DOM 元素。通过创建描述用户界面的更新状态的新对象树，然后将其与旧对象树进行比较来执行更新。

我在各种文章和教程中已经阅读了所有这些内容，虽然这很有帮助，但对我来说，能够在我们提供的应用程序的环境中观察到它工作是非常有启发性的。它还教会我在比较不同框架时应该问哪些问题。例如，我现在知道要问这样的问题，“每个框架执行更新的方式如何影响性能和用户体验？”，而不是只看框架在 Github 上 star 的数量。

另一个好处是你对优秀的程序架构的理解和鉴赏能力提升了。虽然大多数开源项目的存储库通常遵循相同的结构，但每个项目都包含差异。Mithril 的结构非常简单，如果你熟悉它的 API，你可以对文件夹中的代码进行有根据的猜测，如 `render`，`router` 和 `request`。另一方面，React 的结构反映了它的新架构。维护人员将负责 UI 更新的模块 (`react concerner`) 与负责呈现 DOM 元素的模块 (`react dom`) 分开。

这样做的好处之一是，开发人员现在更容易通过挂进 `react-reconciler` 包来编写自己的[自定义渲染器](https://github.com/chentsulin/awesome-react-renderer)。我最近研究过的模块打包工具 Parcel 也有像 React 这样的 `packages` 文件夹。主模块名为 `parcel-bundler`，它包含负责创建包、启动热模块服务器和命令行工具的代码。

[![The section of the JavaScript specification which explains how Object.prototype.toString works](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/6777ea35-ee97-40c4-a0b8-5b4c2455f733/1-improve-your-javascript-knowledge-by-reading-source-code.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/6777ea35-ee97-40c4-a0b8-5b4c2455f733/1-improve-your-javascript-knowledge-by-reading-source-code.png)

不久之后，你所阅读的源码将引导您找到 JavaScript 规范。([高清预览](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/6777ea35-ee97-40c4-a0b8-5b4c2455f733/1-improve-your-javascript-knowledge-by-reading-source-code.png))

另一个好处 —— 令我感到惊讶的是 —— 您可以更轻松地阅读定义语言如何工作的官方 JavaScript 规范。我第一次阅读规范是在研究 `throw Error` 与 `throw new Error`（警告 — 这是 [none](http://www.ecma-international.org/ecma-262/7.0/#sec-error-constructor)）之间的区别时。我研究这个问题是因为我注意到 Mithril 在其 `m` 函数的实现中使用了 `throw Error` ，我想知道在它的实现上使用 `throw new Error` 是否有好处。从那以后，我还了解了逻辑运算符 `&&` 和 `||` [不一定返回布尔值](https://tc39.es/ecma262/#prod-LogicalORExpression)，找到了控制 `==` 等于运算符如何强制转换值的[规则](http://www.ecma-international.org/ecma-262/#sec-abstract-equality-comparison)和 `Object.prototype.toString.call({})` 返回 `'[object Object]'` 的[原因](http://www.ecma-international.org/ecma-262/#sec-object.prototype.tostring)。

### Techniques For Reading Source Code

There are many ways of approaching source code. I have found the easiest way to start is by selecting a method from your chosen library and documenting what happens when you call it. Do not document every single step but try to identify its overall flow and structure.

I did this recently with `ReactDOM.render` and consequently learned a lot about React Fiber and some of the reasons behind its implementation. Thankfully, as React is a popular framework, I came across a lot of articles written by other developers on the same issue and this sped up the process.

This deep dive also introduced me to the concepts of [co-operative scheduling](https://developer.mozilla.org/en-US/docs/Web/API/Background_Tasks_API), the `[window.requestIdleCallback](https://developer.mozilla.org/en-US/docs/Web/API/Window/requestIdleCallback)` method and a [real world example of linked lists](https://github.com/facebook/react/blob/v16.7.0/packages/react-reconciler/src/ReactUpdateQueue.js#L10) (React handles updates by putting them in a queue which is a linked list of prioritised updates). When doing this, it is advisable to create a very basic application using the library. This makes it easier when debugging because you do not have to deal with the stack traces caused by other libraries.

If I am not doing an in-depth review, I will open up the `/node_modules` folder in a project I am working on or I will go to the GitHub repository. This usually happens when I come across a bug or interesting feature. When reading code on GitHub, make sure you are reading from the latest version. You can view the code from commits with the latest version tag by clicking the button used to change branches and select “tags”. Libraries and frameworks are forever undergoing changes so you do not want to learn about something which may be dropped in the next version.

Another less involved way of reading source code is what I like to call the ‘cursory glance’ method. Early on when I started reading code, I installed **express.js**, opened its `/node_modules` folder and went through its dependencies. If the `README` did not provide me with a satisfactory explanation, I read the source. Doing this led me to these interesting findings:

* Express depends on two modules which both merge objects but do so in very different ways. `merge-descriptors` only adds properties directly found directly on the source object and it also merges non-enumerable properties whilst `utils-merge` only iterates over an object’s enumerable properties as well as those found in its prototype chain. `merge-descriptors` uses `Object.getOwnPropertyNames()` and `Object.getOwnPropertyDescriptor()` whilst `utils-merge` uses `for..in`;
* The `setprototypeof` module provides a cross platform way of setting the prototype of an instantiated object;
* `escape-html` is a 78-line module for escaping a string of content so it can be interpolated in HTML content.

Whilst the findings are not likely to be useful immediately, having a general understanding of the dependencies used by your library or framework is useful.

When it comes to debugging front-end code, your browser’s debugging tools are your best friend. Among other things, they allow you to stop the program at any time and inspect its state, skip a function’s execution or step into or out of it. Sometimes this will not be immediately possible because the code has been minified. I tend to unminify it and copy the unminified code into the relevant file in the `/node_modules` folder.

[![The source code for the ReactDOM.render function](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/798703fd-8689-40d9-9159-701f1a00f837/3-improve-your-javascript-knowledge-by-reading-source-code.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/798703fd-8689-40d9-9159-701f1a00f837/3-improve-your-javascript-knowledge-by-reading-source-code.png)

Approach debugging as you would any other application. Form a hypothesis and then test it. ([Large preview](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/798703fd-8689-40d9-9159-701f1a00f837/3-improve-your-javascript-knowledge-by-reading-source-code.png))

### Case Study: Redux’s Connect Function

React-Redux is a library used to manage the state of React applications. When dealing with popular libraries such as these, I start by searching for articles that have been written about its implementation. In doing so for this case study, I came across this [article](https://blog.isquaredsoftware.com/2018/11/react-redux-history-implementation). This is another good thing about reading source code. The research phase usually leads you to informative articles such as this which only improve your own thinking and understanding.

`connect` is a React-Redux function which connects React components to an application’s Redux store. How? Well, according to the [docs](https://react-redux.js.org/api/connect), it does the following:

> “...returns a new, connected component class that wraps the component you passed in.”

After reading this, I would ask the following questions:

* Do I know any patterns or concepts in which functions take an input and then return that same input wrapped with additional functionality?
* If I know of any such patterns, how would I implement this based on the explanation given in the docs?

Usually, the next step would be to create a very basic example app which uses `connect`. However, on this occasion I opted to use the new React app we are building at [Limejump](https://limejump.com/) because I wanted to understand `connect` within the context of an application which will eventually be going into a production environment.

The component I am focusing on looks like this:

```
class MarketContainer extends Component {
 // code omitted for brevity
}

const mapDispatchToProps = dispatch => {
 return {
   updateSummary: (summary, start, today) => dispatch(updateSummary(summary, start, today))
 }
}

export default connect(null, mapDispatchToProps)(MarketContainer);
```

It is a container component which wraps four smaller connected components. One of the first things you come across in the [file](https://github.com/reduxjs/react-redux/blob/v7.1.0/src/connect/connect.js) which exports `connect` method is this comment: **connect is a facade over connectAdvanced**. Without going far we have our first learning moment: **an opportunity to observe the [facade](http://jargon.js.org/_glossary/FACADE_PATTERN.md) design pattern in action**. At the end of the file we see that `connect` exports an invocation of a function called `createConnect`. Its parameters are a bunch of default values which have been destructured like this:

```
export function createConnect({
 connectHOC = connectAdvanced,
 mapStateToPropsFactories = defaultMapStateToPropsFactories,
 mapDispatchToPropsFactories = defaultMapDispatchToPropsFactories,
 mergePropsFactories = defaultMergePropsFactories,
 selectorFactory = defaultSelectorFactory
} = {})
```

Again, we come across another learning moment: **exporting invoked functions** and **destructuring default function arguments**. The destructuring part is a learning moment because had the code been written like this:

```
export function createConnect({
 connectHOC = connectAdvanced,
 mapStateToPropsFactories = defaultMapStateToPropsFactories,
 mapDispatchToPropsFactories = defaultMapDispatchToPropsFactories,
 mergePropsFactories = defaultMergePropsFactories,
 selectorFactory = defaultSelectorFactory
})
```

It would have resulted in this error `Uncaught TypeError: Cannot destructure property 'connectHOC' of 'undefined' or 'null'.` This is because the function has no default argument to fall back on.

**Note**: **For more on this, you can read David Walsh’s [article](https://davidwalsh.name/destructuring-function-arguments). Some learning moments may seem trivial, depending on your knowledge of the language, and so it might be better to focus on things you have not seen before or need to learn more about.**

`createConnect` itself does nothing in its function body. It returns a function called `connect`, the one I used here:

```javascript
export default connect(null, mapDispatchToProps)(MarketContainer)
```

It takes four arguments, all optional, and the first three arguments each go through a `[match](https://github.com/reduxjs/react-redux/blob/v7.1.0/src/connect/connect.js#L25)` function which helps define their behaviour according to whether the arguments are present and their value type. Now, because the second argument provided to `match` is one of three functions imported into `connect`, I have to decide which thread to follow.

There are learning moments with the [proxy function](https://github.com/reduxjs/react-redux/blob/v7.1.0/src/connect/wrapMapToProps.js#L29) used to wrap the first argument to `connect` if those arguments are functions, the `[isPlainObject](https://github.com/reduxjs/react-redux/blob/v7.1.0/src/utils/isPlainObject.js)` utility used to check for plain objects or the `[warning](https://github.com/reduxjs/react-redux/blob/v7.1.0/src/utils/warning.js)` module which reveals how you can set your debugger to [break on all exceptions](https://developers.google.com/web/tools/chrome-devtools/javascript/breakpoints#exceptions). After the match functions, we come to `connectHOC`, the function which takes our React component and connects it to Redux. It is another function invocation which returns `[wrapWithConnect](https://github.com/reduxjs/react-redux/blob/v7.1.0/src/components/connectAdvanced.js#L123)`, the function which actually handles connecting the component to the store.

Looking at `connectHOC`’s implementation, I can appreciate why it needs `connect` to hide its implementation details. It is the heart of React-Redux and contains logic which does not need to be exposed via `connect`. Even though I will end the deep dive here, had I continued, this would have been the perfect time to consult the reference material I found earlier as it contains an incredibly detailed explanation of the codebase.

### Summary

Reading source code is difficult at first but as with anything, it becomes easier with time. The goal is not to understand everything but to come away with a different perspective and new knowledge. The key is to be deliberate about the entire process and intensely curious about everything.

For example, I found the `isPlainObject` function interesting because it uses this `if (typeof obj !== 'object' || obj === null) return false` to make sure the given argument is a plain object. When I first read its implementation, I wondered why it did not use `Object.prototype.toString.call(opts) !== '[object Object]'`, which is less code and distinguishes between objects and object sub types such as the Date object. However, reading the next line revealed that in the extremely unlikely event that a developer using `connect` returns a Date object, for example, this will be handled by the `Object.getPrototypeOf(obj) === null` check.

Another bit of intrigue in `isPlainObject` is this code:

```javascript
while (Object.getPrototypeOf(baseProto) !== null) {
 baseProto = Object.getPrototypeOf(baseProto)
}
```

Some Google searching led me to [this](https://stackoverflow.com/questions/51722354/the-implementation-of-isplainobject-function-in-redux/51726564#51726564) StackOverflow thread and the Redux [issue](https://github.com/reduxjs/redux/pull/2599#issuecomment-342849867) explaining how that code handles cases such as checking against objects which originate from an iFrame.

#### Useful Links On Reading Source Code

* “[How To Reverse Engineer Frameworks](https://blog.angularindepth.com/level-up-your-reverse-engineering-skills-8f910ae10630),” Max Koretskyi, Medium
* “[How To Read Code](https://github.com/aredridel/how-to-read-code/blob/master/how-to-read-code.md),” Aria Stewart, GitHub

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
