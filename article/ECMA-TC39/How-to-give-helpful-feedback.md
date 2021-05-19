> * 原文地址：[How to give helpful feedback](https://github.com/tc39/how-we-work/blob/master/feedback.md)
> * 原文作者：[Ecma TC39](https://github.com/tc39/how-we-work)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/ECMA-TC39/How-to-give-helpful-feedback.md](https://github.com/xitu/gold-miner/blob/master/article/ECMA-TC39/How-to-give-helpful-feedback.md)
> * 译者：
> * 校对者：

# How to give helpful feedback

Online and in person at TC39 meetings, we're always giving feedback on proposals. There are some suggestions for making sure that your feedback is actionable and helpful.

- Follow the TC39 [Code of Conduct](https://tc39.es/code-of-conduct/) in all proposal feedback
- Keep feedback respectful, constructive, and actionable.
    - When you see a problem, explain the problem as much as possible. Proposing a solution can be helpful, but sometimes jumping to and insisting on a particular solution can be counter-productive.
        - Try to explain how the proposal presents problems for a use case, how a use case is not fully satisfied by the proposal, or why a different or modified proposal works well for a use case.
        - If you have ideas for modifications, consider providing them with an explanation of their motivation, but keep in mind that many different constraints and use cases are being balanced against each other.
    - Concretely explain which constraints are being broken. Examples might include backwards incompatibility, a goal of the proposal being invalidated or unsatisfied, abstractions leaking state in potentially unseen ways, not complying with the object model, or preventing some future work due to semantics. Try to be clear about what could be done to fix this breakage as well as why the constraint is important. Differing perspectives may have conflicting constraints and these need to be recognized and weighed.
    - Lack of desirability from one perspective, does not cause a problem on its own. Try to concretely explain how the problem impacts the usability of the proposal itself or of other parts of the language. Keeping feedback actionable allows discussion on how to improve desirability and cohesion for the whole language.
    - Try to phrase any feedback of constraints such that they are actionable rather than preventing some specific design choice. Explain the concrete problem that is being caused by that choice rather than why a proposal should not make a specific choice of design. Presenting problems in terms of concrete impact is more likely to allow champions to directly address if they agree that something needs action.
    - Discussing alternatives is encouraged, but please be flexible, especially on superficial issues ("bikeshedding"). Naming things is hard—it may require significant (or even insurmountable) effort to investigate each potential alternative, or there may be other constraints which are not immediately apparent. Ultimately, even if it is impossible to find a single uncontroversial name, we still all benefit by moving forward on a concrete choice. An explanation of the problems you're facing and how the alternatives relate to them is more valuable than vocal support for one or the other alternatives.
- When you don't understand the motivation for a part of a proposal, one good strategy is to ask a question about it, rather than assuming that it's poorly designed.
    - Anchoring your probing questions in terms of problems to be solved can help to provide motivational clarity either for yourself or the original author (or both!) Clarifications in the past have included examples of the problem space in other languages, diving deeper into the performance impact of a proposal, or discussing consistency with existing semantics within the language, though this is not an inclusive list.
    - Understand that the language is used in such a wide variety of contexts that one's own distaste for a proposal isn't enough to warrant valuable feedback. Understand how the proposal benefits others before contributing, and keep feedback about motivation around the proposal itself rather than personal desirability or usage.
    - A variety of decisions are made due to constraints that might not be immediately obvious only visiting open issues. When these decisions come up, consider asking for clarification if the documentation for the motivation is vague or missing.
- We're all coming from different perspectives and have partial knowledge of the universe. Give your feedback from wherever you're at. For example, there is no need to dress up feedback in formal language if your thought process doesn't correspond to that.
- Whenever possible, give feedback ahead of a TC39 meeting in issues on the GitHub repository for the proposal.
- Search for existing issues which cover a topic before posting a new topic.
- It's helpful to give positive feedback, or feedback agreeing with a previous critique, as well as new points of critique.
- Feedback which is given in channels outside of GitHub and meeting discussions (for example, Twitter threads) is more likely to be lost.
- When in meetings, use the queue tool rather than interrupting the presentation to make a point. See [how-to-participate-in-meetings.md](https://github.com/tc39/how-we-work/blob/master/how-to-participate-in-meetings.md) for details.

The champion group is responsible for carefully considering the sum of all feedback and making a recommendation to the committee taking this into account. Champions will not always be able to find absolute consensus among everyone who voices an opinion, but they should do their best to listen carefully and come to a balanced judgement.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。
---
> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
