> * 原文地址：[How to write a good explainer](https://github.com/tc39/how-we-work/blob/master/explainer.md)
> * 原文作者：[Ecma TC39](https://github.com/tc39/how-we-work)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/ECMA-TC39/How-to-write-a-good-explainer.md](https://github.com/xitu/gold-miner/blob/master/article/ECMA-TC39/How-to-write-a-good-explainer.md)
> * 译者：[Ashira97](https://github.com/Ashira97)
> * 校对者：

# 如何写一个好的解释文件

每一个 TC39 提案都包括了 README.md 文件来说明该提案目的和高层的发展方向。
[这一由 W3C TAG 颁布的向导](https://github.com/w3ctag/w3ctag.github.io/blob/master/explainers.md)为网络规范提供了一个良好的入门说明。

您正在浏览的页面提供了额外建议来帮助您书写一个用于 TC39 提案的解释器，该页面也包含了一个内容的纲要，您可能想要将该纲要包含到您的提案的解释器中。
如果您想要浏览近期提案的书写完善的解释文件，看 [Promise.allSettled](https://github.com/tc39/proposal-promise-allSettled)，[Temporal proposal](https://github.com/tc39/proposal-temporal)，或者是 [RegExp Unicode property escapes](https://github.com/tc39/proposal-regexp-unicode-property-escapes)。

本页接下来的内容可以作为您的 README.md 文件中的模板
并不是所有的部分都需要包含在 README.md 文件中， 本文为您提供了一系列可选择的建议。
在引导中的*斜体字样*和普通文本是样例文本。大多数在头部文章之后的内容都应该用您自己的内容代替。

----

# 制作者

## 状态

主要作者：*主要作者姓名*
作者：*非主要作者姓名，如果有的话*
阶段：-1

## 动机

*为什么应该使用 JavaScript 编程语言？*

不断的修改和调整代码存在于计算机的所有领域中，无论是前端开发到后端开发。
详细信息请看 [CATB](http://catb.org/jargon/html/F/frobnicate.html)。

## 用例

*列举出使用该特性的一些实际场景，可以列出代码和问题描述；当你这么做的时候，不仅仅是在这一种情况下可以有帮助。*

**服务端静态装配**：加入你想要装配某个功能，那么你将要做所有的一系列工作。如果有标准的第三方库提供，这些事情就会容易很多。

```js
frobnicate({});
```

**动态装配案例：**：对象以不同的方式提供，并且出现了不同类型的用例，这些用例可以由相同的特性实现。

## 描述

*一份对开发者友好的文档应该写明如何使用特性*

`frobnicate(object)`返回了一个装配实例。

## 比较

*横跨相关编程语言和类似的第三方库的比较。如果当前项目是该语言或者该第三方库第一次对某功能的实现，就请解释为什么该功能是应该实现的。如果这是一个标准库的特性，那么最好在 JavaScript 的生态中做横向比较；如果这是一个可能并不实用的语法特性，那么在不同编程语言之间的横向比较则可能会受限。*

npm 模块按照提案实现了以下功能：
- [frobnicate-2018](https://www.npmjs.com/package/frobnicate-2018)
- [B](link)
- [C](link)

frobnicate-2018 是一个奇怪的特性，因为...，然而 B 也是奇怪的因为...，所以我们采用了 C 中的方法，这一方法由 qrs 进行修改。

这些编程语言的标准库包含相关的功能：
- APL (对于涉及到的每一项都应该有相关文档的链接)
- PostScript
- Self
- XSLT
- Emacs Lisp

我们的方法与 Emacs Lisp 方法非常相似，通过对数十亿篇 Stack Overflow 文章的手工分析可以清楚地看出，对于普通开发人员来说，这是最简单的方法。

## 实现

### Polyfill/转译器的实现

*该提案中理想的 JavaScript 打包方式实现是简单、可行的。关于创建原型实现的详细信息，请参见 [implement.md](https://github.com/tc39/how-we-work/blob/master/implement.md)。*

你可以使用 npm 包  [frobnicate](https://www.npmjs.com/package/frobnicate) 中尝试这个建议的实现。注意，这个包有 semver 主版本 0，可能会发生变化。

### 简单实现

*对于阶段3以上或者更早的提案，将完全的、端到端的 javascript 引擎的实现状态链接到文中是非常有帮助的。然而在阶段 3 之前填充这些提议有些时候是多余或者非常不可行的。*

- [V8]() (*提供在 JS 引擎中用于跟踪问题的链接*)
- [JSC]()
- [SpiderMonkey]()
- ...

## 问题及回答

*常见问题，或者你认为可能会被问到的问题。问题跟踪器上的问题或过去评审中的问题可能是您编写这一部分的很好的参考。*

**问题**：为什么会出现这样的提议？

**回答**：因为...

**问题**：为什么他需要被内置实现而不是在 JavaScript 中实现？

**回答**：我们一直鼓励用户在用户空间中做这件事。然而，这样会非常严重地增加页面的加载时间。不仅如此，web 浏览器已经有高质量的内置装配模块。

**问题**：真的有必要创建这样一个高级的内置装配模块而不是使用低级特性吗？

**回答**：我们可以暴露更多的基础特性来组装 MD5 哈希模块和 ROT13 模块而不是提供一个直接的 `frobnicate` 方法。然而 rot13 在2012年被发现是不安全的，所以将它 作为一个基础特性暴露可能会导致相关的安全问题。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
