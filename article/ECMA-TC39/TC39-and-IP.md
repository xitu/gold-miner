> * 原文地址：[TC39 and IP](https://github.com/tc39/how-we-work/blob/master/ip.md)
> * 原文作者：[Ecma TC39](https://github.com/tc39/how-we-work)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/ECMA-TC39/TC39-and-IP.md](https://github.com/xitu/gold-miner/blob/master/article/ECMA-TC39/TC39-and-IP.md)
> * 译者：
> * 校对者：
# TC39 and IP

## How TC39 works

TC39 is a technical committee of Ecma, which creates and maintains ECMA-262, the standard for the JavaScript programming language, and some
other JavaScript-related specifications such as ECMA-402 ("Intl").

### Meetings

TC39 meets once every two months for three days. Meetings are primarily attended by delegates from Ecma member organizations. Non-members who are invited by the committee to attend TC39 can do so in two ways:
- "Invited Experts" may contribute to the discussions.
- "Observers" are simply watching a TC39 meeting, without
contributing.

In practice, both of these designations are most often used for prospective Ecma members, and rarely for other purposes. In these meetings, we discuss proposals, recommend modifications, and promote proposals through a ["stage" process][1]. When a proposal advances to Stage 4, we add it to the draft specification.

### Work on GitHub

Most deep technical work in TC39 takes place on GitHub. The [main specification][2] has a GitHub repository, as do other specifications such as [ECMA-402][3]. Small changes to the draft specification are done via GitHub Pull Requests, and larger changes are done via staged proposals which are maintained in [separate GitHub repositories][4].

### Annual specification releases

Every year, around the end of January or beginning of February, the ECMA-262 editor makes a branch of the ecma262 repository for future as the annual "ECMAScript20xx" standard. Backports of small fixes, both editorial and normative, may be targeted at this branch, but new features are not landed there. In June, this branch is passed on to the Ecma General Assembly for ratification as an Ecma standard.

## Legal agreements

### Ecma membership agreements

Ecma members are organizations, such as corporations or
universities, which sign up in one of [Ecma's membership categories][5]. There are separate forms for each membership category, but they each contain the following text:

b) We confirm that we have knowledge of the By-laws, Rules and the
Code of Conduct in Patent Matters of Ecma International and that we
will comply with them.
c) We irrevocably grant Ecma International the right to use
contributions, in part or whole, whether adapted or not, that we
submit to Ecma International, for Ecma International’s purposes of
standardisation, while we retain all the rights we may have on those
contributions.

The above sections grant Ecma the license to copyright over contributions from the member organization. Ecma members who participate in TC39 must sign the RFTC agreement as well, described below, which licenses patents on a royalty-free basis.

### Contributor IPR license

TC39 is open to individuals who are not associated with Ecma members to contribute, either through comments made in TC39 meetings as invited experts, or as normative patches to the specification made via GitHub. Both of these kinds of contributors are required to sign [the non-member contributor agreement][6].

If an individual associated with a Ecma member organization makes a contribution to TC39-associated specifications where the member organization does not have the right to relicense the IPR, but the individual does have this right, then the individual is expected to sign the contributor IPR form as well. If neither has such a right, then the contribution should not be used.

When a non-member contributor works within an organization where they do not have the authorization to license their contributed IPR, the form can be filled out with separate "signatory" and "contributor" fields, where the "contributor" is the participant in TC39 work, and the "signatory" is the member of the organization who is authorized to license the IPR. The form must be signed for each individual contributor who participates in TC39, and does not apply organization-wide.

### Ecma Royalty-Free Technical Committee

Ecma specifications are generally developed under [Ecma Code of Conduct in Patent Matters](http://www.ecma-international.org/memento/codeofconduct.htm), but TC39 uses a distinct royalty-free policy based on the use of Ecma's ["Ecma International Royalty-Free Patent Policy Extension Option"][7]. TC39 is a Royalty Free Technical Committee (RFTC) within Ecma, meaning that standards produced by Ecma TC39 and approved by the Ecma General Assembly include a "royalty-free patent license statement that applies to any patent claims owned or controlled" by TC39 participants.

Participating organizations in TC39 are required to sign a particular form which includes them in the annual RF patent grant. Ecma's RF patent policy provides for a defined time window during which participants may opt out of providing an RF commitment under certain circumstances. (See footnote 1.) Such an Opt-Out has never been taken in TC39's history.

### Copyright licenses

The specification text in annual, GA-approved ECMA-262 and ECMA-402 are licensed under Ecma's [text copyright policy][9], and the contained source code is licensed under [Ecma's software license][10].

TC39 maintains a test suite for ECMA-262 and ECMA-402, called test262, which is licensed under [Ecma's software license][10]. Contributors to test262 are required to sign the separate [software submitter license][11]. Files added to test262 have a [copyright header indicating an initial author][12].

The same copyright policy applies to ECMA-404 (JSON) and ECMA-415 (ECMAScript Suite), which are updated only occasionally.

ECMAScript specification drafts are licensed under the [draft copyright license][14]. Proposals have copyright [reserved by their author][15], but many proposal authors secondarily license their proposal with another license, visible in the proposal repository.

### Processes to ensure contributors have granted appropriate licenses

- In physical meetings, the chair and vice chairs verify that all meeting attendees are either delegates of member companies, or otherwise have chosen among the observer/invited expert options explained above. There is a quick agenda item to clarify the IPR agreements.
- For contributions on GitHub, there is [a bot in development][13] to check that non-member contributors have signed the appropriate agreement.  Until then, the set of contributions has been manually surveyed going back to the beginning of GitHub use, and all contributors have been verified to have signed the agreement; this manual check continues for current contributions.

#### Footnotes

- 1: Historically, all of TC39's work actually takes place in the TC39 RFTG, with a [separately-tracked membership][8]. Today, the entire committee has converted to an RFTC. The opt-out period begins when the annual version is "branched" off, towards the beginning of the year, and ends before the annual version is ratified by the Ecma General Assembly, typically around the middle of the year.

[1]: http://tc39.es/process-document/
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