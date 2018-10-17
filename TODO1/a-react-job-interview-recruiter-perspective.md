> * 原文地址：[A React job interview — recruiter perspective.](https://medium.com/@baphemot/a-react-job-interview-recruiter-perspective-f1096f54dd16)
> * 原文作者：[Bartosz Szczeciński](https://medium.com/@baphemot?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/a-react-job-interview-recruiter-perspective.md](https://github.com/xitu/gold-miner/blob/master/TODO1/a-react-job-interview-recruiter-perspective.md)
> * 译者：[CoolRice](https://github.com/CoolRice)
> * 校对者：

# 以面试官的角度来看 React 工作面试

![](https://cdn-images-1.medium.com/max/1000/1*MQNFrJwbmP7AmaSU-rxuBg.jpeg)

图片来自于 unsplash 上的 [rawpixel](https://unsplash.com/@rawpixel)

> **重要说明**
> 本文不是在面试中的期望问题列表和它们的完整答案。这篇文章的重点是展示我提出的问题，我在答案中寻找的内容以及为什么没有不好的答案。如果你想要一份“最佳面试问题2018”的集合，请查看 [https://github.com/sudheerj/reactjs-interview-questions](https://github.com/sudheerj/reactjs-interview-questions)

我的部分工作职责是执行所谓的“技术面试”，在面试时我会评估申请“React 前端开发”职位的潜在候选人。

如果你曾经用谷歌搜索“React 面试问题”（或任何其他“[技术]面试问题”），你可能已经看过无数“十大 React 面试问题”，这些问题要么已经过时，要么和“state 和 props 之间有什么不同”或“什么是虚拟  dom” 这些问题重复。

知道这些问题的答案**不应该**是面试官是否决定聘用的依据。这是候选人在日常工作中**需要了解**，理解和实现的。如果你被问到这样的问题，要么是面试你的人没有技术背景（HR 或“猎头”），要么他们认为这是一种形式。

面试不应该浪费时间。它应该让你了解候选人的过去经历，过去的知识和发展机会。候选人应该了解您的公司和项目（如果可能），并获得有关他的表现与期望的反馈。在求职面试中没有不好的答案（除非问题严格是技术性的）—— 他的答案应该能让你审视这个人的思考过程。

**本篇文章以面试官的视角所写！**

### 让我们相互了解对方

在许多情况下，面试将通过 Skype 或其他语音（或语音+视频）通信平台进行。了解潜在的员工是一个让他们放开自己的好方法。

#### 你能告诉我一些你以前的工作，你是如何适应团队的吗？你的职责是什么？

了解这个人在他以前的公司做了什么（如果他被允许分享的话）是一个很好的开始。这给你一些关于他以前工作经验的基本想法：软技能（“我是……的唯一开发人员”，“我和我的同事……”，“我管理了一个由 6 名开发人员组成的团队……”）和硬技能（“ ……我们创建了一个一百万人使用的应用程序”，“……我帮助优化了应用程序的渲染时间”，“……创建了很多自动化测试”）。

#### **对你来说** React 的主要卖点是什么。为什么**你**选择使用 React？

我并不期望你提到 JSX，VDOM 等等。—— 我们已经可以通过阅读 React 主页上的“特色”导语得到这些东西。**你** 为什么使用 React？

是因为“easy to learn, hard to master” 的 API（和其它解决方案相比它**的确是**非常轻量）？好 —— 这么说的话，意味着你愿意学习新事物，并且随学随用。

是因为更多的“就业机会”吗？不错 —— 你是一个能够适应市场的人，并且在下一个大框架到来的 5 年内不会有任何问题。我们已经有足够的 jQuery 开发人员了。

想想这有点像“电梯游说”情景（你和你的老板在电梯里，并且需要说服他在 20 楼走出电梯门之前使用新技术）。我并不知道你掌握了多少（为了让客户和你（开发者）受益 React 需要提供什么？）。

### 让我们开始更技术向的问题

正如我在一段开头提到的那样 —— 我不会问你 VDOM 是什么。我们都知道它，但我会问你……

#### 什么是 JSX 和我们怎样在 JavaScript 代码中书写它 —— 浏览器是如何识别它的？

你知道 —— JSX 只是一种 Facebook 普及的标记语法，受益于 Babel/TSC 这些工具 —— 允许我们以一种更令赏心悦目的方式书写 `React.createElement` 调用。

为什么我会问这个问题？我想知道你是否理解 JSX 的技术原理以及随之而来的限制：为什么甚至在我们的代码并没有使用 `React` 的情况下，也需要在文件顶部 `import React from 'react'`；为什么组件不能直接返回多个元素。

**加分题：为什么 JSX 中的组件名要以大写字母开头？**

能回答出 React 如何知道要渲染的是组件还是 HTML 元素就够了。<br/>
额外加分点：此规则有很多例外。例如：把一个组件赋给 `this.component` 并且写 `<this.component />` 也会起作用。

#### 在 React 中你可以声明的两种主要组件类型是什么以及使用时怎样在两者间选择？

一些人会认为这道题是关于展示组件和容器组件的，但实际上是关于 `React.Component` 和函数组件。

正确的回答会提及生命周期函数和组件状态。

#### 由于我们提到了生命周期 —— 你能跟我讲一遍挂载状态组件的生命周期吗？哪些函数按何种顺序被调用？你会把向 API 的数据请求放在哪里执行？为什么？

好，这个问题有点长。请随意把它分成两个小问题。你现在会想“但你说你不会问关于生命周期的内容啊！”。我不会问，我不关心生命周期。我关心的其实是最近几个月生命周期发生的变化。

如果回答包含 `componentWillMount`，你可以假设此人一直在使用旧版本的 React，或者学了一些过时的教程。两种情况都会引起一些担忧。`getDerivedStateFromProps` 才是你在寻找的答案。

额外加分点：提到在服务端上处理方式不同。

关于数据获取的问题也是如此 —— `componentDidMount` 是你想要/听到的之一。

**加分题：为什么用 `componentDidMount` 而不是 `constructor`？**<br/>
你希望听到的两个原因会是：“在渲染发生之前数据不会存在” —— 虽然不是主要原因，但它向您显示该人员了解组件的处理方式; “在 React Fiber 中使用新的异步渲染……” —— 有人一直在做努力学习。

#### 我们刚才提到通过 API 获取数据 —— 你是如何保证在组件重新挂载之后不会重新获取数据？

// todo

我问这个问题的目的是查看候选人是否理解在应用中 UI 需要与其他层解耦的理念。可以提及 React 架构外部的 API。

#### 你能解释下“状态提升”理念吗？

好，我确实问了一些典型的 React 问题。不过这一个是至关重要的，允许你给候选人一些放松空间。

首选答案是“它允许你在兄弟组件间传递数据”或“它允许你拥有更多纯展示组件，更易复用”。在这里也许会提到 Redux，不过这可能也是一件坏事，因为它表示候选人只是跟随社区推荐的任何东西，而不理解他为什么需要它。

**加分题：如果不能在组件间传递数据，你怎样给多级组件传递数据？**
自从 React 16.3 开始，Context 已经成为主流 —— 它之前就已经存在了，不过文档是缺失的（有意为之）。如果能在解释出 Context 的工作方式（同时能表现出知道 function-as-child 模式）会是加分项。

如果这里能提到 Redux/MobX 也很好。

### React 生态

开发 React 应用只是流程的一部分 —— 还有更多的要做：调试、测试和文档。

#### 你是怎样调试 React 代码问题的，你用哪些工具？你会怎样调查组件没有重新渲染的问题？

每个人都应该熟悉像 linter（eslint，jslint）和调试工具（React Developer Tools）这些基本工具。

使用 RDT 来调试问题并通过检查组件 state/props 是否正确是一个不错的答案，如果能提到用 Developer Tools 来打断点也是很好的回答。

#### 你用过哪些测试工具来写 unit/e2e 测试？快照测试是什么及它的好处？

在大多数情况下测试是“不可避免的麻烦”，但它们又是我们所需要的。有很多优秀的答案：karma、mocha、jasmin、jest、cypres、selenium、enzyme、react-test-library 等等。最糟糕的事是候选人回答“上一家公司我们不做单元测试，只有人工测试”。

快照测试部分的回答依赖于你的项目里用了什么；如果你觉得它不是很有用就不要问及。但是如果觉得有用 —— 答案就是“用于 HTML + CSS 生成的 UI 层的便捷回归测试”。

### 小型的代码挑战

如果有可能，我也会让候选人来做一些小型的代码挑战，解决/解释它们不应该花费超过一两分钟，例如：

```
/**
* 这个例子有什么问题，要如何修改或改进这个组件？
*/

class App extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      name: this.props.name || 'Anonymous'
    }
  }

  render() {
    return (
      <p>Hello {this.state.name}</p>
    );
  }
}
```

有很多方式来解决它：移除 state 并使用 props，实现 `getDerivedStateFromProps` 或者更好的方式是把该组件变为函数组件。

```
/**
 * 这几个向组件传递函数的方式，你能解释它们的不同吗？
 *
 * 当你点击每个按钮会发生什么？
 */

class App extends React.Component {

  constructor() {
    super();
    this.name = 'MyComponent';

    this.handleClick2 = this.handleClick1.bind(this);
  }

  handleClick1() {
    alert(this.name);
  }

  handleClick3 = () => alert(this.name);

render() {
    return (
      <div>
        <button onClick={this.handleClick1()}>click 1</button>
        <button onClick={this.handleClick1}>click 2</button>
        <button onClick={this.handleClick2}>click 3</button>
        <button onClick={this.handleClick3}>click 4</button>
      </div>
    );
  }
}
```

这道题要稍微费点功夫，因为代码比较多。如果候选人回答正确紧接着问“为什么？”。为什么 `click 2` 这会以这种方式运行？

这个不是 React 问题，如果有人的回答以“因为在 React 中……”开始，这说明他们没有真正理解 JS 事件循环机制。

```
/**
 * 这个组件有什么问题。为什么？要如何解决呢？
 */

class App extends React.Component {

state = { search: '' }

handleChange = event => {

/**
     * 这是“防抖”函数的简单实现，它会以队列的方式在 250 ms 内调用
     * 表达式并取消所有挂起的队列表达式。以这种方式我们可以在用户停止输
     * 入时延迟 250 ms 来调用表达式。
     */
    clearTimeout(this.timeout);
    this.timeout = setTimeout(() => {
      this.setState({
        search: event.target.value
      })
    }, 250);
  }

render() {
    return (
      <div>
        <input type="text" onChange={this.handleChange} />
        {this.state.search ? <p>Search for: {this.state.search}</p> : null}
      </div>
    )
  }
}
```

好，这道题就需要一些解释了。在防抖函数中并没有错误。那么应用会按期望方式运行吗？它会在用户停止输入的 250 ms 之后更新并且渲染字符串“Search for: …”吗？

这里的问题是在 React 中 `event` 是一个 `SyntheticEvent`，如果和它的交互被延迟了（例如：通过 `setTimeout`），事件会被清除并且 `.target.value` 引用不会再有效。

**额外加分点：候选人要能解释出为什么。**

### 技术问题环节完毕

这应该足够你了解候选人的技能了。不过你还要为开放问答留一些时间。

#### 你在过去的项目里遇到的最大问题是什么？你最大的成就？

这就回到第一个问题了 —— 答案可能因开发人员以及职位而异。初级开发人员会说他最大的问题是在一个复杂的过程中报错，但他可以征服它。寻找更高级职位的人将解释他如何优化应用程序性能，而带领团队的人会解释他如何通过结对编程提高速度。

#### 如果你有无限的时间预算并让你解决/提升/改变你最后一个项目里的一项东西，你会选什么，以及为什么选它？

而别的开放问题则要看你要在候选人身上寻找什么。他会尝试用 MobX 替换 Redux 吗？改进测试设置？写出更好的文档？

### 对调表格和反馈

现在是时候改变角色了。你可能已经对候选人的技能和成长潜力有了充分的了解。让他问些问题 —— 这不仅可以让他更多地了解公司和产品，他问的问题可能会给你一些关于他想要成长方向的指示。

[Carl Vitullo](https://medium.com/@vcarl) 写过一些关于要问你的潜在雇主的问题的好文章，我会推荐给你 —— 准备好回答他们，除非因为保密协议或别的需要让你不能问某些特定问题：

*   [入职和工作场所](https://medium.com/@vcarl/questions-to-ask-your-interviewer-82a26e67ce6c)
*   [发展和紧急情况](https://medium.com/@vcarl/questions-to-ask-your-interviewer-development-and-emergencies-f7fbc4519e5b)
*   [成长](https://medium.com/@vcarl/questions-to-ask-your-interviewer-growth-c88eed119ce2)

#### 给予反馈

如果候选人在某些问题上表现不佳或者回答错误（或者与你预期不同）—— 这时你可能希望澄清这些问题。不要让它听起来像是在青睐此人，只要解释你注意到的问题 —— 提供解决方案和一些他可以用来改善自己的资源。

如果招聘过程的其余部分取决于您，请告诉他们您将在 X 天内回复他们，如果没有，请告诉他们你们公司的某个人会这样做。如果您知道该过程需要超过 2-3 天，请告诉他们。现在 IT 是一个很大的市场，候选人可能已经进行了多次面试 —— 他可能会接受另一个报价而不会等你的反馈。

**不要忽视候选人 —— 这其实是人们在社交媒体上经常抱怨的。**

> 本篇文章中表达的是我自己的观点，不能代表我过去或现任雇主，客户或合作者的意见。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
