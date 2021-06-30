> * 原文地址：[How to give helpful feedback](https://github.com/tc39/how-we-work/blob/master/feedback.md)
> * 原文作者：[Ecma TC39](https://github.com/tc39/how-we-work)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/ECMA-TC39/How-to-give-helpful-feedback.md](https://github.com/xitu/gold-miner/blob/master/article/ECMA-TC39/How-to-give-helpful-feedback.md)
> * 译者：[霜羽 Hoarfroster](https://github.com/PassionPenguin)
> * 校对者：[Kim Yang](https://github.com/KimYangOfCat)、[Miigon](https://github.com/Miigon)

# 如何提出有用的反馈

不管是借助在线渠道或是在 TC39 会议中出席，我们始终会就提案提供反馈。以下的这些建议能够确保您的反馈意见是可行的和有帮助的。

- 在所有提案反馈中遵循 TC39 [行为准则](https://tc39.es/code-of-conduct/)
- 保持反馈的礼貌性、建设性和可行性。
    - 当您发现问题时，请尽可能详细地解释该问题。提出一个解决方案可能会有所帮助，但有时过于轻易地制定并坚持自己的方案则会适得其反。
        - 尝试说明提案为何给具体使用场景带来问题、提案为何无法完全满足使用场景，或者为何不同或经过修改的提案对具体使用场景而言效果很好。
        - 如果您有修改的想法，请解释修改动机，但请记住，不同的约束条件之间，以及不同使用场景之间是一个取舍求平衡的关系。
    - 具体说明哪些约束被打破了，比如说向后不兼容、提案的目标之一无效或无法被满足、抽象可能以不可预知的方式泄漏状态、不遵守对象模型或由于语义改变而阻止未来的工作。请尝试弄清楚如何解决被打破的约束以及约束为何重要的原因。不同的观点可能产生冲突的约束，需要加以验证和权衡。
    - 从一个角度来看，缺乏可取性本身并不会引起问题。请尝试具体解释此问题如何影响提案本身或语言其他部分的可用性。保持反馈的可行性，以便讨论如何提高整个语言的可取性和凝聚力。
    - 尝试以具有可行动性的方式表达任何有关约束的反馈，不要让其阻止某些特定的设计选择。说明由该选择引起的具体问题，而不是解释为什么提案不应该作出某个设计选择。以说明具体影响的方式提出问题，更有可能在提案推进者同意需要采取行动时直接表达。
    - 我们鼓励大家讨论替代方案，但请保持灵活的思路，尤其是在一些表面上的问题（“琐碎定律”，即人们往往会对琐碎的事情报以轻微的关注度）上。命名这样的事情是很难的 —— 可能需要付出巨大的努力（甚至是无法克服的努力）来研究每种可能的替代方案，或者可能存在其他目前仍然不那么显而易见的约束。最终，即使不可能找到一个毫无争议的名称，我们仍将继续前进并做出具体选择，从而使所有人都受益。解释您所面临的问题以及替代方案与问题之间的联系，比单纯对某种替代方案的口头支持更有价值。
- 如果您不了解提案的动机，那么一个好的策略是提出一个问题，而不是假设它的设计不当。
    - 根据要解决的问题来锚定您的探索性问题可以帮助您自己或原始作者（或两者兼而有之）提供激励性的清晰说明。过去的说明中，包括但不限于提供其他语言的问题空间示例、深入讨论提案的性能影响、讨论与语言中现有语义的一致性等等。
    - 认识到语言要在各种各样的场景中使用，单单一个人对提案的反感还不足以作为有价值的反馈。在提出贡献前，了解提案如何使其他人受益，并围绕提案本身（而不是个人对其的期望或个人使用情况）提出反馈。
    - 有许多的决定是基于某些限制而作出的，这些限制在仅查看公开问题的情况下并不那么显而易见。当遇到这些决定时，若关于决定动机的文档不清晰或缺失，可考虑请求决定者澄清动机。
- 我们都是从不同的角度出发，并且对该领域都仅有部分的理解。无论你的立足点是什么，都可以提出你的反馈。例如，可以无需用正式语言来修饰您的反馈，除非您的思维过程与之相符。
- 尽可能在 TC39 会议之前就提案的 GitHub 仓库中的问题提供反馈。
- 在发布新主题之前，搜索涵盖某个主题的现有问题。
- 提出正面的反馈、赞同先前批评意见的反馈以及新的批评意见都很有帮助。
- 除 GitHub 以及会议讨论以外的渠道（例如 Twitter 的 Topic 中）中给出的反馈更可能会被遗忘。
- 在会议中，请使用排队举手工具，而不要在演示中途打断。有关详细信息，请参见 [how-to-participate-in-meetings.md](https://github.com/xitu/gold-miner/blob/master/article/ECMA-TC39/How-to-participate-in-meetings.md) 一文。

提案小组负责仔细考查并总结所有反馈，在考虑了以上所有要求之后向委员会提出建议。提案发起人不一定总能在表达意见的所有人之间取得绝对共识，但他们应尽力认真聆听并做出平衡的判断。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。
---
> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
