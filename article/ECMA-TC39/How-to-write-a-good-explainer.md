> * 原文地址：[How to write a good explainer](https://github.com/tc39/how-we-work/blob/master/explainer.md)
> * 原文作者：[Ecma TC39](https://github.com/tc39/how-we-work)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/ECMA-TC39/How-to-write-a-good-explainer.md](https://github.com/xitu/gold-miner/blob/master/article/ECMA-TC39/How-to-write-a-good-explainer.md)
> * 译者：[Ashira97](https://github.com/Ashira97)
> * 校对者：[Kimberly](https://github.com/kimberlyohq)、[Kim Yang](https://github.com/KimYangOfCat)、[Hoarfroster](https://github.com/PassionPenguin)

# 如何写一个好的说明文件

每一个 TC39 提案都应该包含 README.md 文件来说明该提案目的和高层的发展方向。这篇由 W3C TAG 发布的[指南](https://github.com/w3ctag/w3ctag.github.io/blob/master/explainers.md)为网络规范提供了一个良好的入门说明。

您浏览指南时会发现其中附加了一些关于如何书写 TC39 提案说明的建议，以及可能想在您的提案说明文件中引用的内容大纲。
如果您想要浏览近期提案中优质的说明书文件，请看 [Promise.allSettled](https://github.com/tc39/proposal-promise-allSettled)，[Temporal proposal](https://github.com/tc39/proposal-temporal)，或者是 [RegExp Unicode property escapes](https://github.com/tc39/proposal-regexp-unicode-property-escapes)。

本页接下来的内容可以作为您的 README.md 文件中的模板。并非模板中的所有章节都需要被引入，下面的内容只是一系列可选择的建议。**加粗字样**是说明，而纯文本是示例文本。除了标题，这里的大部分内容都应该用您自己的内容代替。

----

# 装配器（Frobnicator）

## 状态

提案发起人：**提案发起人姓名**
作者：**非主要作者姓名，如果有的话**
阶段：-1

## 动机

**为什么这在 JavaScript 语言中很重要？**

不断的修改和调整代码存在于计算机的所有领域中，无论是前端还是后端开发。
详细信息请看 [CATB](http://catb.org/jargon/html/F/frobnicate.html)。

## 用例

**列举出使用该特性的一些实际场景，以及代码和问题描述；多个用例可能会有帮助。**

**服务端静态装配（Server-side static frobnication）**：加入想要装配某个功能，那么您将要做所有的一系列工作。如果有标准的第三方库提供，这些事情就会容易很多。

```js
frobnicate({});
```

**动态装配案例（Dynamic frobnicate cases）：**：对象以不同的方式提供，并且出现了可以由相同的功能实现的不同类型的用例。

## 描述

**一份对开发者友好的文档应该写明如何使用特性**

`frobnicate(object)`返回了调整过的对象。

## 比较

**相关编程语言和类似的第三方库之间的横向比较。如果当前项目是该语言或者该第三方库第一次对某功能的实现，就请解释为什么该功能是应该实现的。如果这是一个标准库的特性，那么最好在 JavaScript 的生态中做横向比较；如果这是语法特性，那可能不切实际，并且在不同编程语言之间的横向比较则可能会受限。**

npm 模块按照提案实现了以下功能：
- [frobnicate-2018](https://www.npmjs.com/package/frobnicate-2018)
- [B](#)
- [C](#)

frobnicate-2018 是一个奇怪的特性，因为...，然而 B 也是奇怪的因为...，所以我们采用了 C 中的方法，这一方法由...进行修改。

这些编程语言的标准库包含相关的功能：
- APL (对于涉及到的每一项都应该有相关文档的链接)
- PostScript
- Self
- XSLT
- Emacs Lisp

我们的方法与 Emacs Lisp 方法非常相似，通过对数十亿篇 Stack Overflow 文章的手工分析可以清楚地看出，对于普通开发者来说，这是最直接的方法。

## 实现

### Polyfill/转译器的实现

**该提案的一种 JavaScript 实现方式，其能以简单、可行的方式进行打包。关于创建原型实现的详细信息，请参见 [implement.md](https://github.com/tc39/how-we-work/blob/master/implement.md)。**

您可以使用 npm 包  [frobnicate](https://www.npmjs.com/package/frobnicate) 中尝试这个提案的实现。注意，这个包有 semver 主版本 0，可能会发生变化。

### 简单实现

**对于阶段 3 以上或者更早的提案，将完全的、端到端的 JavaScript 引擎的实现状态链接到文中是非常有帮助的。然而在阶段 3 之前填充这些提议因为有些不太可行，所以显得有些多余。**

- [V8]() （**提供在 JS 引擎中用于跟踪问题的链接**）
- [JSC](#)
- [SpiderMonkey](#)
- ...

## Q&A

**常见问题，或者您认为可能会被问到的问题。issues 上的问题或过去 reviews 中的问题可能是编写这一部分的很好的参考。**

**问题**：该提案的设计初衷是什么？

**回答**：因为……

**问题**：为什么他需要被内置实现而不是在 JavaScript 中实现？

**回答**：我们可以鼓励用户在用户空间中做这件事。然而，这样会非常严重地增加页面的加载时间。不仅如此，web 浏览器已经有高质量的内置装配模块。

**问题**：真的有必要创建这样一个高级的内置装配模块而不是使用低级特性吗？

**回答**：我们可以暴露更多的基础特性来组装 MD5 哈希模块和 ROT13 模块而不是提供一个直接的 `frobnicate` 方法。然而 rot13 在 2012 年被发现是不安全的，所以将它作为一个基础特性暴露可能会导致相关的安全问题。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
