> * 原文地址：[Reading a proposal draft](https://github.com/tc39/how-we-work/blob/master/how-to-read.md)
> * 原文作者：[Ecma TC39](https://github.com/tc39/how-we-work)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/ECMA-TC39/Reading-a-proposal-draft.md](https://github.com/xitu/gold-miner/blob/master/article/ECMA-TC39/Reading-a-proposal-draft.md)
> * 译者：
> * 校对者：

# Reading a proposal draft

Each proposal which is Stage 2 or higher has a specification text draft, located at `https://tc39.es/proposal-<name>`. This is the authoritative definition which implementations should use as a reference; README text or issues may be used for context.

The specification text for proposals is phrased as a diff over the [current draft specification](https://tc39.es/ecma262), possibly with the addition of certain other proposals. When an entirely new section is added, it is not highlighted, but when existing sections are modified, they are highlighted in green for insertions and red for deletions.

Specification text is meant to be interpreted abstractly. Only the *observable semantics*, that is, the behavior when JavaScript code is executed, need to match the specification. Implementations can use any strategy they want to make that happen, including using different algorithms that reach the same result.

For more details on reading specification text, see Timothy Gu's [How to Read the ECMAScript Specification](https://timothygu.me/es-howto/) and the ECMAScript specification's [Notational Conventions](https://tc39.es/ecma262/#sec-notational-conventions) section.


> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。
---
> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。

