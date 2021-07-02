> * 原文地址：[TC39 and IP](https://github.com/tc39/how-we-work/blob/master/ip.md)
> * 原文作者：[Ecma TC39](https://github.com/tc39/how-we-work)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/ECMA-TC39/TC39-and-IP.md](https://github.com/xitu/gold-miner/blob/master/article/ECMA-TC39/TC39-and-IP.md)
> * 译者：
> * 校对者：
# TC39 与知识产权（IP）

## TC39 是如何运作的

TC39 是 Ecma 的一个技术委员会，它负责创建和维护 ECMA-262，即JavaScript 编程语言的标准，以及一些其他与 JavaScript 相关的规范，例如 ECMA-402（『国际』）。

### 会议

TC39 会议每两个月举行一次，会议为期三天。会议主要由 Ecma 成员组织的代表参加。受委员会邀请参加 TC39 的非会员可以通过以下两种方式参加:
- 『特邀专家』 可以参与讨论.
- 『观察员』仅能旁听 TC39，不能参与讨论。

在实践中，这两种身份通常用于潜在的 Ecma 成员, 而很少用于其他目的. 在这些会议中，我们通过[『stage』过程][1]讨论提案，提出修改建议，并推动提案。当一个提案进入到 Stage 4 阶段，我们会将它加入到规范草案里。

### 在 GitHub 上工作

TC39 中最深入的技术性工作发生在 GitHub 上。[主要规范][2] 有一个位于 Github 的存储库，并且其他规范也是如此，例如 [ECMA-402][3]. 对规范草案的小改动是通过 GitHub Pull Requests 完成的，而更大的改动则是通过分阶段的提案完成的，这些提案在[单独的 GitHub 存储库][4]中维护。

### 年度规范的发布

在每年的一月末或者二月初，ECMA-262 的维护者会将 ecma262 仓库的一个分支作为本年度的 "ECMAScript20xx" 标准。Backports of small fixes, both editorial and normative, may be targeted at this branch, but new features are not landed there。同年六月，Ecma 大会将批准该分支作为新的 Ecma 标准

## 法律协议

### Ecma 成员协议

Ecma 的成员都是注册在某个 [Ecma 成员类别][5] 中的组织，例如一些学校或者公司。每中成员类别都有独立的表格，但每个表格都包含以下内容:

b) 我们确认我们已了解 Ecma International 的章程、规则和专利事务行为准则并且将遵守它们
c) We irrevocably grant Ecma International the right to use
contributions, in part or whole, whether adapted or not, that we
submit to Ecma International, for Ecma International’s purposes of
standardisation, while we retain all the rights we may have on those
contributions.

The above sections grant Ecma the license to copyright over contributions from the member organization. Ecma members who participate in TC39 must sign the RFTC agreement as well, described below, which licenses patents on a royalty-free basis.

### 贡献者知识产权（IPR）许可

TC39 也接受来自与 Ecma 成员无关的个人的贡献，包括作为特邀专家在 TC39 会议上发表评论，或者在 Github 上向规范仓库提交规范补丁。这两种类型的贡献者都需要签署 [非成员贡献者协议][6].

If an individual associated with a Ecma member organization makes a contribution to TC39-associated specifications where the member organization does not have the right to relicense the IPR, but the individual does have this right, then the individual is expected to sign the contributor IPR form as well. If neither has such a right, then the contribution should not be used.

When a non-member contributor works within an organization where they do not have the authorization to license their contributed IPR, the form can be filled out with separate "signatory" and "contributor" fields, where the "contributor" is the participant in TC39 work, and the "signatory" is the member of the organization who is authorized to license the IPR. The form must be signed for each individual contributor who participates in TC39, and does not apply organization-wide.

### Ecma 免版税技术委员会
Ecma specifications are generally developed under [Ecma Code of Conduct in Patent Matters](http://www.ecma-international.org/memento/codeofconduct.htm), but TC39 uses a distinct royalty-free policy based on the use of Ecma's ["Ecma International Royalty-Free Patent Policy Extension Option"][7]. TC39 is a Royalty Free Technical Committee (RFTC) within Ecma, meaning that standards produced by Ecma TC39 and approved by the Ecma General Assembly include a "royalty-free patent license statement that applies to any patent claims owned or controlled" by TC39 participants.

Participating organizations in TC39 are required to sign a particular form which includes them in the annual RF patent grant. Ecma's RF patent policy provides for a defined time window during which participants may opt out of providing an RF commitment under certain circumstances. (See footnote 1.) Such an Opt-Out has never been taken in TC39's history.

### 版权许可

The specification text in annual, GA-approved ECMA-262 and ECMA-402 are licensed under Ecma's [text copyright policy][9], and the contained source code is licensed under [Ecma's software license][10].

TC39 maintains a test suite for ECMA-262 and ECMA-402, called test262, which is licensed under [Ecma's software license][10]. Contributors to test262 are required to sign the separate [software submitter license][11]. Files added to test262 have a [copyright header indicating an initial author][12].

The same copyright policy applies to ECMA-404 (JSON) and ECMA-415 (ECMAScript Suite), which are updated only occasionally.

ECMAScript specification drafts are licensed under the [draft copyright license][14]. Proposals have copyright [reserved by their author][15], but many proposal authors secondarily license their proposal with another license, visible in the proposal repository.

### 确保贡献者授予正确许可的过程

- In physical meetings, the chair and vice chairs verify that all meeting attendees are either delegates of member companies, or otherwise have chosen among the observer/invited expert options explained above. There is a quick agenda item to clarify the IPR agreements.
- For contributions on GitHub, there is [a bot in development][13] to check that non-member contributors have signed the appropriate agreement.  Until then, the set of contributions has been manually surveyed going back to the beginning of GitHub use, and all contributors have been verified to have signed the agreement; this manual check continues for current contributions.

#### 脚注

- 1: Historically, all of TC39's work actually takes place in the TC39 RFTG, with a [separately-tracked membership][8]. Today, the entire committee has converted to an RFTC. The opt-out period begins when the annual version is "branched" off, towards the beginning of the year, and ends before the annual version is ratified by the Ecma General Assembly, typically around the middle of the year.

[1]: https://github.com/tc39/ecma262/
[2]: https://github.com/tc39/ecma262/
[3]: https://github.com/tc39/ecma402/
[4]: https://github.com/tc39/proposals/
[5]: http://www.ecma-international.org/memento/join.htm
[6]: https://tc39.es/agreements/contributor/
[7]: https://www.ecma-international.org/memento/Policies/Ecma_Royalty-Free_Patent_Policy_Extension_Option.htm
[8]: https://www.ecma-international.org/memento/TC39-RF-TG.htm
[9]: https://www.ecma-international.org/memento/Ecma%20copyright%20faq.htm
[10]: https://www.ecma-international.org/memento/Policies/Ecma_Policy_on_Submission_Inclusion_and_Licensing_of_Software.htm
[11]: https://tc39.es/test262-cla/
[12]: https://github.com/tc39/test262/blob/master/CONTRIBUTING.md#test-case-style
[13]: https://github.com/IgnoredAmbience/tc39-bot/
[14]: https://github.com/bterlson/ecmarkup/blob/master/boilerplate/draft-copyright.html
[15]: https://github.com/bterlson/ecmarkup/blob/master/boilerplate/proposal-copyright.html

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。
---
> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。