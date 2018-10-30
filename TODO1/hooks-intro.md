> * 原文地址：[Introducing Hooks](https://reactjs.org/docs/hooks-intro.html)
> * 原文作者：[reactjs.org](https://reactjs.org/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/hooks-intro.md](https://github.com/xitu/gold-miner/blob/master/TODO1/hooks-intro.md)
> * 译者：[Sam](https://github.com/xutaogit)
> * 校对者：

# Hook 介绍

*Hook* 是一项新的功能提案，可以让你在不编写类的情况下使用状态(state)和其他 React 功能。它们目前处于 React v16.7.0-alpha 阶段，并且在[开放式 RFC 中](https://github.com/reactjs/rfcs/pull/68)进行着讨论。

```js{4,5}
import { useState } from 'react';

function Example() {
  // Declare a new state variable, which we'll call "count"
  const [count, setCount] = useState(0);

  return (
    <div>
      <p>You clicked {count} times</p>
      <button onClick={() => setCount(count + 1)}>
        Click me
      </button>
    </div>
  );
}
```

这个 `useState` 新功能将是我们学习的第一个“钩子”，但这个例子仅仅是个预告。即便你对它没感觉也不用担心！

**你可以[在下一页](https://reactjs.org/docs/hooks-overview.html)开始学习 Hook**。在本页面上，我们将继续解释为什么我们要将 Hook 添加到 React 中，以及它们如何帮助你编写出色的应用。

## 没有重大的变化

在我们继续之前，请注意 Hook 是：

* **完全可选择引入。** 你无需重写任何现有代码，就能在一些组件里尝试使用 Hook。但如果你不想，你不必现在学习或使用 Hook。
* **100% 向后兼容。** Hook 不包含任何重大的更改。
* **现在可用。** Hook 目前处于 alpha 版本，我们希望在收到社区反馈后把它们包含在 React 16.7 中。

**没有把类从 React 中移除的计划。** 你可以在本页面[底部](https://reactjs.org/docs/hooks-intro.html#gradual-adoption-strategy)阅读更多关于渐进式采用 Hook 的策略信息。

**Hook 不会取代你对 React 概念的理解。** 相反地，Hook 为你已知的 React 概念(props，state，context，refs 和 lifecycle)提供了更直接的 API。并且稍后我们还将演示，Hook 还提供了一种组合它们新的强大的方式。

**如果你只是想开始学习 Hook，请随意[直接跳到下一页！](https://reactjs.org/docs/hooks-overview.html))** 你也可以继续阅读本页，详细了解我们为什么要添加 Hook，以及我们是如何在不重写应用程序的情况下开始使用它们的。

## 动机

Hook 解决了我们在过去五年时间里编写和维护数以万计 React 组件时遇到的各种看似不相关的问题。无论你是在学习 React，还是日常使用，甚至说是喜欢使用具有类似组件模型的其他库，你都有可能注意到这些问题。

### 在组件之间重用带状态逻辑很困难

React 没有提供把可重用行为“附加”到组件上的方法(例如，把它关联到 store 里)。如果你已经使用了 React 一段时间，你可能会熟练使用[渲染属性](https://reactjs.org/docs/render-props.html)和[高阶组件](https://reactjs.org/docs/higher-order-components.html)的模式尝试解决这个问题。但这些模式需要你在使用它们的时候对组件进行重构，这可能会很麻烦并且使代码更难以跟踪。如果你看一下 React DevTools 里的典型 React 应用程序，你也许会发现一个由提供者，消费者，高阶组件，渲染属性和其他抽象层包裹起来的“包装地狱”组件。虽然我们可以[在 React DevTools 中过滤它们](https://github.com/facebook/react-devtools/pull/503)，但这里引出了一个更深层次的基本问题：React 需要一个更好的分享带状态逻辑的原语。

使用 Hook，你可以从一个组件中导出带状态逻辑，以便它可以单独测试和复用。**Hook 允许你在不改变组件层次结构的情况下复用带状态逻辑。** 这样就可以轻松地在多个组件之间或者社区里共享 Hook。

我们将在[编写自定义钩子](https://reactjs.org/docs/hooks-custom.html#using-a-custom-hook)里进行更多的讨论。

### 复杂的组件变得难以理解

我们经常不得不维护从简单开始，但后来变成混杂着带状态逻辑和副作用无法管理的组件。每个生命周期方法通常都包含了一堆不相关的逻辑。例如，组件也许要在 `componentDidMount` 和 `componentDidUpdate` 方法里请求数据。但是，同样是在 componentDidMount 方法，可能会包含不相关的设置事件监听的逻辑，还得在componentWillUnmount 里清除。本该一起更改的相关联代码被拆分，而完全不相关的代码却最终组合到一个方法里。这就太容易引入 bug 和导致不一致了。

很多情况下不可能把这些组件拆分得更小，因为到处都有带状态的逻辑。而且测试它们也很困难。这就是许多人更喜欢将 React 与单独的状态管理库相结合的原因之一。但是，这通常会引入太多的抽象(概念)，使得你在不同的文件之间跳转，同时让重用组件变得更加困难。

为了解决这个问题，**Hook 允许你基于相关联的部分(例如设置订阅或获取数据)把一个组件拆分成较小的函数**，而不是基于生命周期函数强制拆分。你还可以选择使用 reducer 管理组件的本地状态，以使其更具可预测性。

我们将在[使用效果 Hook](https://reactjs.org/docs/hooks-effect.html#tip-use-multiple-effects-to-separate-concerns) 里更多地讨论这个问题。

### 类(Class)混淆了人类和机器

通过我们的观察，发现类是学习 React 最大的障碍。你必须理解 `this` 在 JavaScript 中是怎么工作的，大多数语言中它的工作方式有很大不同。你必须记住绑定事件处理程序。如果没有不稳定的[语法提案](https://babeljs.io/docs/en/babel-plugin-transform-class-properties/)，代码就非常冗长。人们可以很好地理解属性，状态和自上而下的数据流，但仍然很艰难地与类作斗争。React 中的函数和类组件之间的区别以及何时使用哪种组件，即使在经验丰富的 React 开发人员之间也会引发分歧。

此外，React 已经推出大概五年时间了，并且我们希望确保它在未来的五年里还保持相关性。就像 [Svelte](https://svelte.technology/)，[Angular](https://angular.io/)，[Glimmer](https://glimmerjs.com/)和其他人表明的那样，[提前编译](https://en.wikipedia.org/wiki/Ahead-of-time_compilation)组件未来有很大的潜力。特别是在它不局限于模版的情况下。目前，我们已经使用 [Prepack](https://prepack.io/) 做了[组件折叠](https://github.com/facebook/react/issues/7323)的实验，并且我们已经看到了有前景的早期结果。但是，我们发现类组件可能会引发无意识的模式使得这些优化回退到较慢的路径上。类也给今天的工具提出了问题。例如，类不能很好地压缩，并且它们使得热更新加载变得片状和不可靠。我们希望提供一种 API，使代码更可能的留在可优化的路径上。 

为了解决这个问题，**Hook 允许你在没有类的情况下使用更多 React 的功能。** 概念上来说，React 组件一直是更接近于函数的。Hook 拥抱函数，但不会牺牲掉 React 实际的精神。Hook 提供了对命令式逃生舱口（译者注：可讨论）的访问，并且不需要你学习复杂的函数式或反应式编程技术。

>例子
>
>[Hook 概览](https://reactjs.org/docs/hooks-overview.html) 是开始学习 Hook 的好地方。

## 逐步采用策略

>**TLDR: 没有从 React 中移除类的计划**

我们知道 React 开发者专注于发布产品，没有时间研究正在发布的每个新 API。Hook 是很新的，在考虑学习或采用它们之前等待更多的示例和教程可能会更好。

我们也理解为 React 添加新原语的标准非常高。对于好奇的读者来说，我们已经事先准备了一个[详细的 RFC](https://github.com/reactjs/rfcs/pull/68)，里面有更多深入细节的动机，并提供有关特定设计决策的额外视角和相关领先技术。

**至关重要的是，Hook 和现有代码是并行工作的，所以你可以逐步采用它们。** 我们正在分享这个实验性的 API，为了是从社区中那些有兴趣塑造 React 未来的人那里得到早期反馈 —— 然后我们会在公开场合迭代 Hook。

最后，别急着迁移到 Hook。我们建议避免任何“重大改写”，特别是对于现有复杂的类组件。开始“考虑 Hook”需要一点心理上的转变。根据我们的经验，最好先在新的和非相关的组件里练习使用 Hook，并确保团队中的每个人都对它们感到满意。在你尝试 Hook 之后，请随时[给我们发送反馈](https://github.com/facebook/react/issues/new)，无论是积极的还是消极的。

我们打算让 Hook 能覆盖所有现有的类用例，但**我们将在可预见的未来继续支持类组件。** 在 Facebook，我们有数以万计用类编写的组件，显然我们没有要重写它们的计划。相反地，我们开始在新的代码中并行使用 Hook 和类。

## 下一步

在本页的末尾，你应该大致了解 Hook 正在解决的问题，但很多细节可能还不清楚。别担心！**现在让我们进入[下一页](https://reactjs.org/docs/hooks-overview.html)，我们通过示例开始学习 Hook。**

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
