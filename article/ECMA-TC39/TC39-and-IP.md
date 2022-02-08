> - 原文地址：[TC39 and IP](https://github.com/tc39/how-we-work/blob/master/ip.md)
> - 原文作者：[Ecma TC39](https://github.com/tc39/how-we-work)
> - 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> - 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/ECMA-TC39/TC39-and-IP.md](https://github.com/xitu/gold-miner/blob/master/article/ECMA-TC39/TC39-and-IP.md)
> - 译者：[finalwhy](https://github.com/finalwhy)
> - 校对者：[PassionPenguin](https://github.com/PassionPenguin) 、[KimYangOfCat](https://github.com/KimYangOfCat)

# TC39 与知识产权（IP）

## TC39 是如何运作的

TC39 是 Ecma 的一个技术委员会，它负责创建和维护 ECMA-262，即 JavaScript 编程语言的标准，以及一些其他与 JavaScript 相关的规范，例如 ECMA-402（『国际』）。

### 会议

TC39 会议每两个月举行一次，会议为期三天。会议主要由 Ecma 成员组织的代表参加。受委员会邀请参加 TC39 会议的非会员组织的成员可以通过以下两种方式参与：

- 『特邀专家』可以参与讨论。
- 『观察员』仅能旁听 TC39，不能参与讨论。

在实践中，这两种身份通常用于潜在的 Ecma 成员, 而很少用于其他目的。在 TC39 会议中，我们通过[『stage』过程][1]讨论提案，提出修改建议，并推动提案。当一个提案进入到 Stage 4 阶段，我们会将它加入到规范草案里。

### 在 GitHub 上工作

TC39 中最深入的技术性工作发生在 GitHub 上。[主要规范][2] 有一个位于 Github 的存储库，并且其他规范也是如此，例如 [ECMA-402][3]。对规范草案的小改动是通过 GitHub Pull Requests 完成的，而更大的改动则是通过分阶段的提案完成的，这些提案在[单独的 GitHub 存储库][4]中维护。

### 年度规范的发布

在每年的一月末或者二月初，ECMA-262 的维护者会将 ecma262 仓库的一个分支作为本年度的 "ECMAScript20xx" 标准。此后，该分支可能还有一些编辑性或规范性的小修改，但不会再有新增的特性。同年六月，Ecma 大会将批准该分支作为新的 Ecma 标准。

## 法律协议

### Ecma 成员协议

Ecma 的成员都是注册在某个 [Ecma 成员类别][5] 中的组织，例如一些学校或者公司。每个成员类别都有独立的表格，但每个表格都包含以下内容：

b) 我们确认我们已了解 Ecma International 的章程、规则和专利事务行为守则并且将遵守它们。
c) 为了 Ecma 国际的标准化目标，我们授予 Ecma 国际对我们提交给其的贡献的部分或全部使用权和改编权，同时我们保留对这些贡献的所有权利。

上述章节授予 Ecma 对会员组织贡献的版权许可。参与 TC39 的 Ecma 成员还必须签署 RFTC 协议，该协议在免版税的基础上许可专利。

### 贡献者知识产权（IPR）许可

TC39 也接受来自与 Ecma 成员无关的个人的贡献，包括作为特邀专家在 TC39 会议上发表评论，或者在 Github 上向规范仓库提交规范补丁。这两种类型的贡献者都需要签署 [非成员贡献者协议][6]。

如果与 Ecma 成员组织相关的个人对 TC39 相关规范做出贡献，而成员组织无权重新授予知识产权，但个人有此权利，那么个人也需要签署贡献者知识产权（IPR）表格。如果两者都没有这样的权利，那么这些贡献则不应被使用。

当一个非成员组织的贡献者在一个未授权他们为其贡献的知识产权发布许可的组织中工作时，表格中可以填写单独的『签署人』和『贡献者』字段，『贡献者』是 TC39 工作的参与者，『签署人』是被授权能够许可知识产权的成员组织。该表格必须由参与 TC39 的个人贡献者填写，并且不适用于全组织范围。

### Ecma 免版税技术委员会

Ecma 规范通常是遵循 [Ecma 专利事务行为守则][16] 而制定的，但 TC39 使用的是基于 [『Ecma 国际免版税专利政策扩展选项』][7] 的独特版税政策。TC39 是 Ecma 内的一个免版税的技术委员会（Royalty Free Technical Committee, RFTC），这意味着由 Ecma TC39 制定并经 Ecma 大会批准的所有标准都包含一份适用于任何由 TC39 参与者所拥有或控制的专利的『免版税专利许可声明』。

参与 TC39 的组织都需要签署一份特殊的表格，这份表格表示他们授予 TC39 年度免版税（Royalty Free, RF）授权。Ecma 的免版税专利政策中提供了一个特定的时间窗口，在此期间参与的成员组织可以在某些情况下选择不提供免版税承诺<sup><a href="#note1">\[1\]</a></sup>。但在 TC39 的历史上从未发生过这样的选择性退出事件。

### 版权许可

经过 GA 授权的年度 ECMA-262 和 ECMA-402 中的规范文本遵循 [Ecma 文字版权政策][9] 许可，其中包含的源代码通过 [Ecma 软件许可][10] 获得许可。

TC39 为 ECMA-262 和 ECMA-402 维护了一个名为 test262 的测试套件，它通过 [Ecma 软件许可][10] 获得许可。test262 的贡献者需要签署独立的 [软件提交者许可][11]。向 test262 添加的文件都会有一个 [版权标头指明其原始作者][12]。

ECMA-404（JSON）和 ECMA-415（ECMAScript 套件）也应用了相同的版权政策，这两个标准只会偶尔更新。

ECMAScript 规范草案根据 [版权草案许可][14] 获得许可。提案 [由其作者保留][15] 版权，但许多提案作者会通过另一个许可证二次许可他们的提案，该许可在提案的存储库中是可见的。

### 确保贡献者授予正确许可的流程

- 在线下会议中，会议主席和副主席将核实所有与会者要么是成员公司的代表，要么是上述的观察员或者特邀专家，然后会有一个快速议程项目来澄清知识产权协议。
- 对于 GitHub 上的贡献，有 [一个正在开发的机器人][13] 来检查非成员贡献者是否签署了适当的协议。直到贡献集已经被手动检查并回到 GitHub 使用之初，并且所有贡献者都已被验证已签署适当的协议之后，将会对当前的贡献继续进行手动检查。

#### 脚注

- <a name="note1"></a>1：从历史上看，TC39 的所有工作实际上都发生在 TC39 免版税技术委员会中，并具有 [单独跟踪的成员关系][8]。而在今天，整个委员会已转变为一个免版税技术委员会。选择性退出期从年初，每个年度版本确立分支开始，直到年度版本被 Ecma 大会批准之前，通常在年中左右。

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
[16]: http://www.ecma-international.org/memento/codeofconduct.htm

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
