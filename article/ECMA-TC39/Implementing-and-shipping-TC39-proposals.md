> * 原文地址：[Implementing and shipping TC39 proposals](https://github.com/tc39/how-we-work/blob/master/implement.md)
> * 原文作者：[Ecma TC39](https://github.com/tc39/how-we-work)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/ECMA-TC39/Implementing-and-shipping-TC39-proposals.md](https://github.com/xitu/gold-miner/blob/master/article/ECMA-TC39/Implementing-and-shipping-TC39-proposals.md)
> * 译者：
> * 校对者：

# Implementing and shipping TC39 proposals

Beyond specification text and conformance tests, new JavaScript features need implementations, that is, code in JS engines, transpilers, tools, polyfills, etc. that makes them available to programmers. Implementers end up getting into every detail of a proposal, giving them a unique perspective, which helps TC39 validate proposals.

## Interaction with the stage process

It's never too early to draft an implementation, but different stages indicate different levels of stability and concreteness. Many implementations use runtime or compile-time flags to switch on or off TC39 proposals. This may be used to manage incomplete implementations or to refrain from shipping earlier stage designs from developers.

At **Stage 4**, a specification is *complete* and set to be included in the ECMAScript draft specification. Except in particular circumstances, the proposal is complete, stable and **ready to ship**. Implementations tend to turn on Stage 4 features by default, without any particular flags. Refraining from implementing and shipping a Stage 4 feature risks getting the implementation out of sync with others.

At **Stage 3**, the committee is strongly considering a feature and has *agreed on concrete details*. Implementation experience may still lead to semantic changes, and some Stage 3 features have been dropped entirely. Projects requiring stability tend to use a certain amount of **case-by-case judgement** before shipping Stage 3 features, if they ship them at all.

At **Stage 0, 1, and 2**, semantic details are *up in the air*. The committee has not come to consensus on all of the concrete details of the proposal. Implementations at this stage should be considered **experimental and speculative**. Implementations at this stage can be very valuable to enable experimentation by programmers, which can help refine the language design. Implementations tend to expose this stage of feature via special flags which are not enabled by default.

## Transpiler implementations

Early language features can be prototyped in so-called "transpilers": JavaScript-to-JavaScript compilers which include support for newer language features in older JavaScript environments. Transpiler implementations of new language features can help collect feedback and drive incremental adoption.

One popular transpiler used for prototyping early JavaScript features is [Babel](https://babeljs.io/). For features which create new syntax, Babel's parser needs to be modified, which you can do in a fork and PR. In some cases, a Babel transform plugin may be sufficient, when existing syntactic constructs can be used (but note that, due to web compatibility issues, it is difficult to change the definition of its semantics in non-error cases for existing features).

## Library implementations

If the proposal is a standard library feature, and it's possible to implement this feature in JavaScript, it's helpful to get this feature out to developers to try it out, so they can give feedback. As it emerges as a standard, supported in some engines and not others, it remains useful to have this implementation as a backup, often called a "polyfill" or a “shim”. To encourage use, it's helpful to expose these implementations as modules in popular package managers such as [npm](https://www.npmjs.com/).

The best practice for implementations for early library proposals (pre-Stage 3, and Stage 3 is borderline, as discussed above) is to expose it as a module, rather than a global or property of an existing object; this is important for the evolution of the standard, so people don't accidentally depend on an early version being the final one. See [Polyfills and the evolution of the Web](https://www.w3.org/2001/tag/doc/polyfills/) for details.

## Testing

TC39 maintains conformance tests to validate JavaScript implementations against the specification in a project called [test262](https://github.com/tc39/test262/). To contribute to test262, see their [CONTRIBUTING.md](https://github.com/tc39/test262/blob/master/CONTRIBUTING.md). If you develop tests against a particular implementation, it's highly encouraged to upstream them in test262.

test262 includes tests for all Stage 4 proposals and some Stage 3 proposals. Earlier Stage 2 proposals may have tests posted in a [pull request](https://github.com/tc39/test262/pulls).

## Giving feedback to proposal champions

TC39 appreciates implementers! In addition to getting features to JS developers, the process of implementation gives detailed sense of the feature within the language as a whole and its various interactions, leading to important insights about the design.

All kinds of feedback are appreciated from implementers, whether it's about the motivation, high-level design, integration with various other systems, implementation complexity, or the semantics of edge cases. The best way to give feedback is through filing bugs in the GitHub repository. Feel free to make PRs against the draft proposal specification for suggested semantic changes, as well.

Champions want to hear from you. If you're working on an implementation and, e.g., are having trouble understanding the proposal or want help with an edge case, get in touch with the champion, either by filing the question as an issue in GitHub, writing them an email, or even asking for a call to go over things.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。
---
> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。