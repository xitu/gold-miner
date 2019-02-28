> * 原文地址：[TSLint in 2019](https://medium.com/palantir/tslint-in-2019-1a144c2317a9)
> * 原文作者：[Palantir](https://medium.com/@palantir)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/tslint-in-2019.md](https://github.com/xitu/gold-miner/blob/master/TODO1/tslint-in-2019.md)
> * 译者：
> * 校对者：

## TSLint in 2019

![](https://cdn-images-1.medium.com/max/5984/1*YtDebDXHLQIWDyJl2LWh8g.png)

Palantir is the creator and primary maintainer of [TSLint](https://github.com/palantir/tslint), the standard linter for the TypeScript programming language. As the TypeScript community is [working toward a unified developer experience](https://github.com/Microsoft/TypeScript/issues/29288) across the TypeScript and JavaScript languages, we are committed to support the convergence of TSLint and ESLint; in this blog post we explain the Why and How of our efforts.

## TSLint and ESLint today

Today, TSLint is de facto the standard linter for TypeScript repositories and for the TypeScript implementation itself. The TSLint ecosystem consists of a core rule set together with community-maintained, custom rule and configuration packages.

Meanwhile, ESLint is the standard JavaScript linter. Like TSLint, it consists of a core rule set plus community-maintained customizations. ESLint supports a number of features missing from TSLint, for instance [conditional lint configuration](https://github.com/palantir/tslint/issues/3447) and [automatic indentation](https://github.com/palantir/tslint/issues/2814). Conversely, ESLint rules cannot benefit (today, at least) from static analysis and type inference provided by the TypeScript language services and are thus unable to catch a class of bugs and code smells covered by TSLint’s [semantic rules](https://palantir.github.io/tslint/usage/type-checking/).

## TypeScript + ESLint

The [strategic direction](https://github.com/Microsoft/TypeScript/issues/29288) of the TypeScript team is to enable** “**types on every desk, in every home, for every JS developer”. In other words, the direction is to incrementally enrich the JavaScript developer experience with TypeScript features like types and static analysis until, maybe, the TypeScript and JavaScript developer experience converge.

It is clear that linting is a core part of the TypeScript/JavaScript developer experience, and so Palantir’s TSLint team met with the TypeScript core team in Redmond to discuss what the TypeScript/JavaScript convergence should mean for linting. The TypeScript community intends to meet JavaScript developers where they are, and ESLint is the tool of choice for JavaScript linting. In order to avoid bifurcating the linting tool space for TypeScript, we therefore plan to deprecate TSLint and focus our efforts instead on improving ESLint’s TypeScript support. There are both strategic and pragmatic reasons why we believe this is the correct path forward:

* **Developer accessibility:**One of the barriers for JavaScript developers to move to TypeScript is the non-trivial migration from ESLint to TSLint. Allowing developers to start from their existing ESLint setups and incrementally add TypeScript-specific static analysis reduces this barrier.

* **Uniting the community:**At their core, ESLint and TSLint have the same purpose: to provide an excellent code linting experience with a strong core rule set and extensive plugin points. Now that TypeScript parsing is available within ESLint, we believe it’s best for the communities to standardize, rather than to maintain fragmentation through competing tools.

* **More performant analysis infrastructure**: The ESLint API allows for more efficient implementations of certain classes of checks. Although it would be possible to refactor TSLint’s APIs, it seems prudent to leverage ESLint’s architecture and focus our development resources elsewhere.

* **Investment hypothesis:** Within Palantir, TSLint encodes our tradecraft for the TypeScript language; as such, its feature set and architecture have matured and reached a steady state. It has thus been hard for us to justify the level of commitment needed to keep up with community contributions and demands.

## What’s next

Palantir will support the TSLint community by providing a smooth transition path to ESLint via a range of feature and plugin contributions (shout out to [James Henry](https://github.com/JamesHenry) and other contributors there for getting it started!), for instance:

* **Support & documentation for writing ESLint rules in TypeScript: **See [this typescript-eslint issue thread](https://github.com/typescript-eslint/typescript-eslint/issues/40).

* **Testing infrastructure in typescript-eslint: **ESLint’s built-in rule tester is hard to use and the test case syntax is hard to read. We’d like to bring something like [TSLint’s testing infrastructure](https://palantir.github.io/tslint/develop/testing-rules/) to this project to ensure there are no regressions in the TSLint rule development experience.

* **Semantic, type-checker-based rules:** Porting over and adding new rules which [use TypeScript language services](https://github.com/palantir/tslint/labels/Requires%20Type%20Checker).

Once we consider ESLint feature-complete w.r.t. TSLint, we will deprecate TSLint and help users migrate to ESLint; our primary tasks until then include:

* **Continued TSLint support:** The most important maintenance task in TSLint is ensuring its compatibility with new compiler versions and features.

* **TSLint → ESLint compat package:** Once the ESLint static analysis checks are on a par with TSLint, we’ll publish an *eslint-config-palantir* package, a drop-in ESLint replacement for our TSLint rule set.

We’ve loved seeing TypeScript and TSLint grow in adoption over the past few years, and we’re excited to contribute to the even more impactful future of TypeScript in the Web development ecosystem! Please get in touch with us by commenting on this post or via GitHub Issues if you have questions or concerns, or if you would like to help.

## Authors

[Adi D.](https://twitter.com/adi_dahiya), [John W.](https://github.com/johnwiseheart), [Robert F.](https://github.com/uschi2000), Stephanie Y.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。