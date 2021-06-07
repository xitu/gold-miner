> * 原文地址：[How to experiment with a proposal before Stage 4](https://github.com/tc39/how-we-work/blob/master/experiment.md)
> * 原文作者：[Ecma TC39](https://github.com/tc39/how-we-work)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/ECMA-TC39/How-to-experiment-with-a-proposal-before-Stage-4.md](https://github.com/xitu/gold-miner/blob/master/article/ECMA-TC39/How-to-experiment-with-a-proposal-before-Stage-4.md)
> * 译者：
> * 校对者：

# How to experiment with a proposal before Stage 4

For JavaScript programmers who want to be adventurous and give TC39 feedback on proposals, there are various ways they can try things out:

- For code which does not require maintenance across TC39 language design changes, experiment with the feature by turning it on using runtime or build-time flags, for example:
    - In Babel, enable the feature in your selected Babel preset (see [babel/proposals](https://github.com/babel/proposals/issues) for feature status).
    - Get advanced versions of web browsers such as Edge Insider Edition, Safari Tech Preview, Firefox Nightly, or Chrome Canary for certain new language features. See their release notes to learn what's included.
    - Use TypeScript, which implements several Stage 3 TC39 proposals.
    - In V8, turn the feature on by passing in a flag beginning with `--harmony` found in [flag-definitions.h](https://github.com/v8/v8/blob/master/src/flag-definitions.h). Note that some flagged implementations may be unstable or incomplete and should not generally be used in production.
        - In Node.js based on V8, the flag can be passed directly as such
        - Within Chrome, enable "experimental JavaScript features" in about:flags, or use the command-line argument `--js-flags=--harmony-<flagname>`.
- If implementations are missing, [add one](https://github.com/tc39/how-we-work/blob/master/implement.md)!
- When you have feedback on the proposal, file it as an issue in the GitHub repository of the proposal

WARNING: Proposals at Stage 3 and below are subject to significant change or removal.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。
---
> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。


