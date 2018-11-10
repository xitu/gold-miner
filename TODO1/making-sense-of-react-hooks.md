> * 原文地址：[Making Sense of React Hooks](https://medium.com/@dan_abramov/making-sense-of-react-hooks-fdbde8803889)
> * 原文作者：[Dan Abramov](https://medium.com/@dan_abramov?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/making-sense-of-react-hooks.md](https://github.com/xitu/gold-miner/blob/master/TODO1/making-sense-of-react-hooks.md)
> * 译者：[HaoChuan9421](https://github.com/HaoChuan9421/)
> * 校对者：[calpa](https://github.com/calpa), [Ivocin](https://github.com/Ivocin)

# 理解 React Hooks

本周，[Sophie Alpert](https://mobile.twitter.com/sophiebits) 和我在 React Conf 上提出了 “Hooks” 提案，紧接着是 [Ryan Florence](https://mobile.twitter.com/ryanflorence) 对 Hooks 的深入介绍：

* YouTube 视频链接：https://youtu.be/dpw9EHDh2bM

我强烈推荐大家观看这个开场演讲，在这个演讲里，大家可以了解到我们尝试使用 Hooks 提案去解决的问题。不过，花费一个小时看视频也是时间上的巨大投入，所以我决定在下面分享一些关于 Hooks 的想法。

> **注意: Hooks 是 React 的实验性提案。你无需现在就去学习它们。另请注意，这篇文章包含我的个人意见，并不一定代表 React 团队的立场**。

### 为什么需要 Hooks？

我们知道组件和自上而下的数据流可以帮助我们将庞大的 UI 组织成小型、独立、可复用的块。**但是，我们经常无法进一步拆分复杂的组件，因为逻辑是有状态的，而且无法抽象为函数或其他组件**。这也就是人们有时说 React 不允许他们“分离关注点”的意思。

这些情况很常见，包括动画、表单处理、连接到外部数据源以及其他很多我们希望在组件中做的事情。当我们尝试单独使用组件来解决这些问题时，通常我们会这样收场：

*   **巨大的组件** 难以重构和测试。
*   **重复的逻辑** 在不同的组件和生命周期函数之间。
*   **复杂的模式** 像 render props 和高阶组件。

我们认为 Hooks 是解决所有这些问题的最佳实践。**Hooks 让我们将组件内部的逻辑组织成可复用的隔离单元**：

![](https://i.loli.net/2018/10/31/5bd98faa90275.png)

**Hooks 在组件内部应用 React 的哲学（显式数据流和组合），而不仅仅是组件之间**。这就是为什么我觉得 Hooks 天生就适用于 React 的组件模型。

不同于 render props 或高阶组件等的模式，Hooks 不会在组件树中引入不必要的嵌套。它们也没有受到 [mixins 的负面影响](https://reactjs.org/blog/2016/07/13/mixins-considered-harmful.html#why-mixins-are-broken)。

即使你内心一开始是抵触的（就像我刚开始一样！），我还是强烈建议你直接对这个提案进行一次尝试和探索。我想你会喜欢它的。

### Hooks 会使 React 变得臃肿吗？

在我们详细介绍 Hooks 之前，你可能会担心我们通过 Hooks 只是向 React 添加了更多概念。这是一个公正的批评。我认为虽然学习它们肯定会有短期的认知成本，不过最终的结果却恰恰相反。

**如果 React 社区接受 Hooks 的提案，这将减少编写 React 应用时需要考虑的概念数量**。Hooks 可以使得你始终使用函数，而不必在函数、类、高阶组件和 reader 属性之间不断切换。

就部署大小而言，对 Hooks 的支持仅仅增加了 React 约 1.5kB（min + gzip）的大小。虽然不多，但由于使用 Hooks 的代码通常可以比使用类的等效代码压缩得更小，**所以使用 Hooks 也可能会减少你的包大小**。下面这个例子有点极端，但它有效地展示了我这么说的原因（点击查看整个帖子）：

![](https://i.loli.net/2018/10/31/5bd98fde2d939.png)

**Hooks 提案不包括任何重大变化**。即使你在新编写的组件中采用了 Hooks，你现有的代码仍将照常运行。事实上，这正是我们推荐的 —— 不做大的重写！在任何关键代码中采用 Hooks 都是一个好主意。与此同时，如果你能够尝试 16.7 alpha 版并在 [Hooks proposal](https://github.com/reactjs/rfcs/pull/68) 和 [report any bugs](https://github.com/facebook/react/issues/new) 向在我们提供反馈，我们将不胜感激。

### 究竟什么是 Hooks？

要了解 Hooks，我们需要退一步来思考代码复用。

今天，有很多方式可以在 React 应用中复用逻辑。我们可以编写一个简单的函数并调用它们来进行某些计算。我们也可以编写组件（它们本身可以是函数或类）。组件更强大，但它们必须渲染一些 UI。这使得它们不便于共享非可视逻辑。这使得我们最终不得不用到 render props 和高阶组件等复杂模式。**如果只用一种简单的方式来复用代码而不是那么多，那么React会不会简单点**？

函数似乎是代码复用的一种完美机制。在函数之间组织逻辑仅需要最少的精力。但是，函数内无法包含 React 的本地状态。在不重构代码或不抽象出 Observables 的情况下，你也无法从类组件中抽象出“监视窗口大小并更新状态”或“随时间变化改变动画值”的行为。这两种方法都破坏了我们喜欢的 React 的简单性。

Hooks 正好解决了这个问题。 Hooks 允许你通过调用单个函数以在函数中使用 React 的特性（如状态）。React 提供了一些内置的 Hooks，它们暴露了 React 的“构建块”：状态、生命周期和上下文。

**由于 Hooks 是普通的 JavaScript 函数，因此你可以将 React 提供的内置 Hooks 组合到你自己的“自定义 Hooks”中**。这使你可以将复杂问题转换为一行代码，并在整个应用或 React 社区中分享它们：

![](https://i.loli.net/2018/10/31/5bd990044fa52.png)

注意，自定义 Hooks 从技术上讲并不是 React 的特性。编写自定义 Hooks 的可行性源自于 Hooks 的设计方式。

### 来点代码！

假设我们想要将订阅一个自适应当前窗口宽度的组件（例如，在有限的视图上显示不同的内容）。

现在你有几种方法可以编写这种代码。这些方法包括编写类，设置一些生命周期函数，如果要在组件之间复用，甚至可以需要提取 render props 或更高一层的组件。但我认为没有比这更好的了：

![](https://cdn-images-1.medium.com/max/800/1*j8U3U0nZvmEKJrSOK7iH5g.png)

**如果你看这段代码，它恰恰就是我所表达的**。我们在我们的组件中**使用窗口的宽度**，而 React 将会在它变化是重新渲染。这就是 Hooks 的目的 —— 使组件做到真正的声明式，即使它们包含状态和副作用。

让我们来看看如何实现这个自定义 Hooks。我们 **使用 React 的本地状态来保存当前窗口宽度，并在窗口调整大小时**使用一个副作用来设置该状态：

![](https://cdn-images-1.medium.com/max/800/1*9QhpwSGTKM-c8sc4UNcxqA.png)

就像你从上面看到的那样，像 _useState_ 和 _useEffect_ 这样作为基本构建块的 React 内置 Hooks。我们可以直接在组件中使用它们，或者我们可以将它们整合到自定义 Hooks 中，就像 _useWindowWidth_ 那样。使用自定义 Hooks 感觉就像使用 React 的内置 API 一样得心应手。

你可以从[此概述](https://reactjs.org/docs/hooks-overview.html)中了解有关内置 Hooks 的更多信息。

**Hooks 是完全封装的 —— 你每次调用 Hooks 函数, 它都会从当前执行组件中获取到独立的本地状态**。对这个特殊的例子来说并不重要（所有组件的窗口宽度是相同的！），但这正是 Hooks 如此强大的原因。它们不仅是一种共享**状态**的方式，更是共享**状态化逻辑**的方式。我们不想破坏自上而下的数据流！

每个 Hooks 都可以包含一些本地状态和副作用。你可以在不同 Hooks 之间传值，就像在通常在函数之间做的那样。Hooks 可以接受参数并返回值，因为它们**就是**JavaScript 函数。

这是一个实验 Hooks 的 React 动画库的例子：

![](https://i.loli.net/2018/10/31/5bd9904fc600f.png)

[在 CodeSandbox 上运行这个例子](https://codesandbox.io/s/ppxnl191zx?from-embed)

注意，在演示代码中，这个惊人的动画是通过几个自定义 Hooks 的传值实现的。

![](https://cdn-images-1.medium.com/max/800/1*NJ2G1R_32k95WiPel5JHpg.png)

（如果你想了解更多关于这个例子的信息, 查看[此介绍](https://medium.com/@drcmda/hooks-in-react-spring-a-tutorial-c6c436ad7ee4)。）

在 Hooks 之间传递数据的能力使得它们非常适合实现动画、数据订阅、表单管理和其他状态化的抽象。**不同于 render props 和高阶组件，Hooks 不会在渲染树中创建“错误层次结构”**。它们更像是一个连接到组件的“存储单元”的平面列表。没有额外的层。

### 类又该何去何从？

在我们看来，自定义 Hooks 是 Hooks 提案中最吸引人的部分。但是为了使自定义 Hooks 工作，React 需要为函数提供一种声明状态和副作用的办法。而这也正是像 _useState_ 和 _useEffect_ 这样的内置 Hooks 允许我们做的事情。你可以在[文档](https://reactjs.org/docs/hooks-overview.html)中了解它们。

事实证明，这些内置 Hooks **不仅**可用于创建自定义 Hooks。它们**也**足以用来定义组件，因为它们像 state 一样为我们提供了所有必要的特性。这就是为什么我们希望 Hooks 成为未来定义 React 组件的主要原因。

我们没有打算弃用类。在 Facebook，我们有成千上万的类组件，而且和你一样，我们无意重写它们。但是如果 React 社区接受了 Hooks，那么同时推荐两种不同的方式来编写组件是没有意义的。Hooks 可以涵盖类的所有应用场景，同时在抽象，测试和复用代码方面提供更大的灵活性。这就是为什么 Hooks 代表了我们对 React 未来的愿景。

### 不过 Hooks 是不是有点“魔术化”？

你可能会对[Hooks 的规则](https://reactjs.org/docs/hooks-rules.html)感到惊讶。

**虽然必须在顶层调用 Hooks 是不寻常的，但即使可以，你可能也不希望在某种条件判断中定义状态**。例如，你也无法对类中定义的状态进行条件判断，而在过去四年和 React 用户的交流中，我也没有听到过对此的抱怨。

这种设计在不引入额外的语法噪音或其他坑的情况下，对自定义 Hooks 至关重要。我们知道用户一开始可能不熟悉，但我们认为这种取舍对未来是值得的。如果你不同意，我鼓励你动手去实践一下，看看这是否会改变你的感受。

我们已经在生产环境下使用 Hooks 一个月了，以观察工程师们是否对这些规则感到困惑。我们发现实际情况是人们会在几个小时内习惯它们。就个人而言，我承认这些规则起初让我“感觉不对”，但我很快就克服了它。这次经历像极了我对 React 的第一印象。（你一开始就喜欢 React 吗？至少我不是一开始就喜欢，直到更多次尝试后才改变看法。）

记住，在 Hooks 的实现中也没有什么“魔术”。就像 Jamie [指出](https://mobile.twitter.com/jamiebuilds/status/1055538414538223616)的那样，它像极了这个：

![](https://cdn-images-1.medium.com/max/800/1*xNeUnpwUvFMuQu9Zr6A3AA.jpeg)

我们为每个组件保留了一个 Hooks 列表，并在每次 Hooks 被调用时移动到列表中的下一项。得意于 Hooks 的规则，它们的顺序在每次渲染中都是相同的，因此我们可以为每次调用提供正确的组件状态。要知道 React 不需要做任何特殊处理就能知道哪个组件正在渲染 —— 调用你的组件的**正是** React。

也许你在想 React 在哪里保存了 Hooks 的状态。答案就是，它保存在和 React 为类保持状态相同位置。无论你如何定义组件，React 都有一个内部的更新队列，它是任何状态的真实来源。

Hooks 不依赖于现代 JavaScript 库中常见的代理或 getter。按理说，Hooks 比一些解决类似问题的流行方法**更**平常。我想说 Hooks 就像调用 array.push 和 array.pop 一样普通（一样的取决于调用顺序！）。

Hooks 的设计与 React 无关。事实上，在提案发布后的前几天，不同的人提出了针对 Vue，Web Components 甚至原生 JavaScript 函数的相同 Hooks API 的实验性实现。

最后，如果你是一个纯函数编程主义者并且对 React 依赖可突变状态的实现细节感到不安，你会欣喜的发现完成 Hooks 可以以函数式编程的方式实现（如果 JavaScript 支持它们）。当然，React 一直依赖于内部的可突变状态 —— 正因如此**你**不必那样做。

无论你是从一个更务实还是教条的角度来考虑（或者你两者兼有），我希望至少有一个立场是有意义的。最重要的是，我认为 Hooks 让我们用更少的精力去构建组件，并提供更好的用户体验。这就正是我个人对 Hooks 感到兴奋的地方。

### 传播正能量，而不是炒作

如果 Hooks 对你还没有什么吸引力，我完全可以理解。我仍然希望你能在一个很小的项目上尝试一下，看看是否会改变你的看法。无论你是遇到需要 Hooks 来解决的问题，还是说你有不同的解决方案，欢迎通过 RFC 告诉我们！

如果我**让**你感到兴奋，或者说有那么点好奇，那就太好了！我只有一个问题要问。现在有很多人正在学习 React，如果我们匆匆忙忙的编写教程，并把仅仅才出现几天的功能宣称为最佳实践，他们会感到困惑。即使对我们在 React 团队的人来说，关于 Hooks 的一些事情还不是很清楚。

**如果你在 Hooks 不稳定期间开发了任何有关 Hooks 的内容，请突出提示它们是一个实验性提案，并包含指向[官方文档](https://reactjs.org/hooks)的链接**。我们会在提案发生任何改变时及时更新它。我们也花了相当多的精力来完善它，所以很多问题已在那里得到了解决。

当你和其他不像你那么兴奋的人交流时，请保持礼貌。如果你发现别人对此有误解，如果对方乐意的话你可以和他分享更多信息。但任何改变都是可怕的，作为一个社区，我们应该尽力帮助人们，而不是疏远他们。如果我（或 React 团队中的任何其他人）未遵循此建议，请致电我们！
### 更进一步

查看 Hooks 提案的文档以了解更多信息：

*   [Hooks 介绍](https://reactjs.org/docs/hooks-intro.html) （动机）
*   [Hooks 小瞥](https://reactjs.org/docs/hooks-overview.html) （通览）
*   [编写自定义 Hooks](https://reactjs.org/docs/hooks-custom.html)
*   [Hooks 常见问题](https://reactjs.org/docs/hooks-faq.html) （也许你问题的答案就在其中！）

Hooks 仍然处于早期阶段，但我们很乐意能听到你们的反馈。你可以直接去 [RFC](https://github.com/reactjs/rfcs/pull/68)，与此同时，我们也会尽量及时回复 Twitter 上的对话。

如果有不清楚的地方，请告诉我，我很乐意为你答疑解惑。感谢你的阅读！

![](https://cdn-images-1.medium.com/max/800/1*_XMyHqfFSyw03BiNjBoV3Q.jpeg)

<p align="center">Vitra — Portemanteau Hang it all</p>

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
