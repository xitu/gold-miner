> * 原文地址：[How to write a good explainer](https://github.com/tc39/how-we-work/blob/master/explainer.md)
> * 原文作者：[Ecma TC39](https://github.com/tc39/how-we-work)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/ECMA-TC39/How-to-write-a-good-explainer.md](https://github.com/xitu/gold-miner/blob/master/article/ECMA-TC39/How-to-write-a-good-explainer.md)
> * 译者：[Ashira97](https://github.com/Ashira97)
> * 校对者：

# 如何写一个好的解释文件

Each TC39 proposal should have a README.md file which explains the purpose of the proposal and its shape at a high level. 
每一个 TC39 提案都包括了一个说明该提案目的和从高层角度的发展方向。
[This guide](https://github.com/w3ctag/w3ctag.github.io/blob/master/explainers.md) by the W3C TAG has a good introduction for web specifications。
[这一由 W3C TAG 颁布的向导](https://github.com/w3ctag/w3ctag.github.io/blob/master/explainers.md)为网络规范提供了一个良好的入门说明。

This page you're on has some additional advice for how to write an explainer for TC39 proposals, with an outline for content that you might want to include in your proposal's explainer. 
您正在浏览的页面提供了额外建议来帮助您书写一个用于 TC39 提案的解释器，该页面也包含了一个内容的纲要，您可能想要将该纲要包含到您的提案的解释器中。
For some well-written explainers in recent proposals, see [Promise.allSettled](https://github.com/tc39/proposal-promise-allSettled), the [Temporal proposal](https://github.com/tc39/proposal-temporal), or [RegExp Unicode property escapes](https://github.com/tc39/proposal-regexp-unicode-property-escapes).
如果您想要浏览近期提案的书写完善的解释器，看 [Promise.allSettled](https://github.com/tc39/proposal-promise-allSettled)，[Temporal proposal](https://github.com/tc39/proposal-temporal)，或者是[RegExp Unicode property escapes](https://github.com/tc39/proposal-regexp-unicode-property-escapes)。

The rest of this page can be used as a template, to put in your README.md. 
本页接下来的内容可以作为您的 README.md 文件中的模板
Not all sections need to be included: This is just a series of optional suggestions. 
并不是所有的部分都需要包含在 README.md 文件中， 本文为您提供了一系列可选择的建议。
In *italics* is the instructions, and in plain text is the example text. Most of what's here besides the headings should be replaced by your own content.
在引导中的*斜体字样*和普通文本是样例文本。大多数在头部文章之后的内容都应该用您自己的内容代替。

----

# 制作者

## 状态

Champion(s): *champion name(s)*
主要作者：*主要作者姓名*
Author(s): *non-champion author(s), if applicable*
作者：*非主要作者姓名，如果有的话*
Stage: -1
阶段：-1

## 动机

*Why is this important to have in the JavaScript language?*
*为什么使用 JavaScript 编程语言是很重要的？*

Frobnication comes up in all areas of computer science, in both front-end and back-end programming. 
不断的修改和调整代码存在于计算机的所有领域中，无论是前端开发到后端开发。
See [CATB](http://catb.org/jargon/html/F/frobnicate.html) for details.
详细信息请看 [CATB](http://catb.org/jargon/html/F/frobnicate.html)。

## 用例

*Some realistic scenarios using the feature, with both code and description of the problem; more than one can be helpful.*
*列举出使用该特性的一些实际场景，可以列出代码和问题描述；当你这么做的时候，不仅仅是在这一种情况下可以有帮助。*

**Server-side static frobnication**: Say you want to frobnicate a thing. Then, you would normally have to do all this stuff. If it's in the standard library, it'd be easier.
**服务端静态装配**：加入你想要开发某个功能，那么你将要做所有的一系列工作。如果有标准的第三方库提供，这些事情就会容易很多。

```js
frobnicate({});
```

**Dynamic frobnicate cases**: The object is provided in a different way, and a different sort of use case comes up, which can be met by the same feature.
**动态装配案例：**：对象以不同的方式提供，并且出现了不同类型的用例，这些用例可以由相同的功能来满足。

## 描述

*Developer-friendly documentation for how to use the feature*
*一份对开发者友好的文档应该写明如何使用特性*

`frobnicate(object)` returns the frobnication of object.
`frobnicate(object)`返回了一个装配实例。

## 比较

*A comparison across various related programming languages and/or libraries. If this is the first sort of language or library to do this thing, explain why that is the case. If this is a standard library feature, a comparison across the JavaScript ecosystem would be good; if it's a syntax feature, that might not be practical, and comparisons may be limited to other programming languages.*
*横跨相关编程语言和第三方库的比较。如果当前项目是该语言或者该第三方库第一次对某功能的实现，就请解释为什么该功能如此重要。如果这是一个标准库的特性，那么最好在 JavaScript 的生态中做横跨比较；如果这是一个可能并不实用的语法特性，那么在不同编程语言之间的横向比较则可能会受限。*

These npm modules do something like the proposal:
npm 模块按照提案实现了以下功能：
- [frobnicate-2018](https://www.npmjs.com/package/frobnicate-2018)
- [B](link)
- [C](link)

frobnicate-2018 is weird because xyz, whereas B is weird because jkl, so we take a version of the approach in C, modified by qrs.
frobnicate-2018 是一个奇怪的特性，因为...，然而 B 也是奇怪的因为...，所以我们采用了 C 中的方法，这一方法由 qrs 进行修改。

The standard libraries of these programming languages includes related functionality:
这些编程语言的标准库包含相关的功能：
- APL (links to the relevant documentation for each of these)
- PostScript
- Self
- XSLT
- Emacs Lisp

Our approach is pretty similar to the Emacs Lisp approach, and it's clear from a manual analysis of billions of Stack Overflow posts that this is the most straightforward to ordinary developers.
我们的方法与Emacs Lisp方法非常相似，通过对数十亿篇Stack Overflow文章的手工分析可以清楚地看出，对于普通开发人员来说，这是最简单的方法。

## 实现

### Polyfill/transpiler implementations
### Polyfill/转译器的实现

*A JavaScript implementation of the proposal, ideally packaged in a way that enables easy, realistic experimentation. See [implement.md](https://github.com/tc39/how-we-work/blob/master/implement.md) for details on creating useful prototype implementations.*
*该提案中理想的 JavaScript 打包方式实现是简单、可行的。关于创建有用的原型实现的详细信息，请参见 [implement.md](https://github.com/tc39/how-we-work/blob/master/implement.md)。*

You can try out an implementation of this proposal in the npm package [frobnicate](https://www.npmjs.com/package/frobnicate). Note, this package has semver major version 0 and is subject to change.
你可以在 npm 包  [frobnicate](https://www.npmjs.com/package/frobnicate) 中尝试这个建议的实现。注意，这个包有 semver 主版本0，可能会发生变化。

### 简单实现

*For Stage 3+ proposals, and occasionally earlier, it is helpful to link to the implementation status of full, end-to-end JavaScript engines. Filing these issues before Stage 3 is somewhat unnecessary, though, as it's not very actionable.*
*对于阶段3以上的提案，或者更早的提案，将完全的、端到端的 javascript 引擎链接到本文中是非常有帮助的。然而在阶段 3 之前填充这些提议有些时候是多余或者非常不可行的。*

- [V8]() (*Links to tracking issues in each JS engine*)
- [JSC]()
- [SpiderMonkey]()
- ...

## Q&A

*Frequently asked questions, or questions you think might be asked. Issues on the issue tracker or questions from past reviews can be a good source for these.*
*常见问题，或者你认为可能会被问到的问题。问题跟踪器上的问题或过去评审中的问题可能是这些问题的一个很好的来源*

**Q**: Why is the proposal this way?
**Q**：为什么会出现这样的提议？

**A**: Because reasons!

**Q**: Why does this need to be built-in, instead of being implemented in JavaScript?

**A**: We could encourage people to continue doing this in user-space. However, that would significantly increase load time of web pages. Additionally, web browsers already have a built-in frobnicator which is higher quality.

**Q**: Is it really necessary to create such a high-level built-in construct, rather than using lower-level primitives?

**A**: Instead of providing a direct `frobnicate` method, we could expose more basic primitives to compose an md5 hash with rot13. However, rot13 was demonstrated to be insecure in 2012 (citation), so exposing it as a primitive could serve as a footgun.
> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
