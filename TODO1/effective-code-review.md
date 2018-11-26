> * 原文地址：[Effective code review](https://engineering.linecorp.com/en/blog/detail/378/)
> * 原文作者：[Bryan Liu](https://engineering.linecorp.com)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/effective-code-review.md](https://github.com/xitu/gold-miner/blob/master/TODO1/effective-code-review.md)
> * 译者：[子非](https://www.github.com/CoolRice)
> * 校对者：[7Ethan](https://github.com/7Ethan), [smallfatS](https://github.com/smallfatS)

# Effective code review
# 如何让高效的代码评审成为一种文化

如何提升代码质量经常在某一段时间成为开发团队工作的重点，我们积极地讨论如何提升单元测试的效率，如何增加测试的代码覆盖率。然而好景不长，大家各忙各的，提升代码质量的热情也就慢慢降温了。但是，但不超过一年，历史又将重演，人们又将重提相似的观点。我的名字叫 Bryan Liu，目前是在 LINE 从事自动化测试的一名质量工程师，我想分享在 LINE Taiwan 我是如何帮助改进单元测试和代码评审进程的。

## 单元测试和代码评审

正如在职培训上 CTO 在向我们解释的一样，同行代码评审是 LINE 工程师文化的一部分。Facebook 指出开发过程中最重要的三件事 —— 代码评审、代码评审和代码评审。是的，解决单元测试和改进代码质量的唯一方法是使单元测试成为我们工程师文化的一部分，而这就是代码评审帮到我们的地方。

![boyscout_rule](https://engineering.linecorp.com/wp-content/uploads/2018/10/24/1540351340897.png)

针对代码的童子军规，来自 [{codemotion}](https://codemotionworld.com/)

请遵循这个童子军规，该规则建议评审人检查单元测试是否支持在评审期间补充新代码和修复 bug，通过持续执行此操作，代码覆盖率应该扩展或至少维持不变。举个例子，如果代码覆盖率下降，则评审人应向团队解释他/她遇到的困难以及不添加更多测试的原因。如果所有人都认可该解释并且没提出新问题，他/她可以继续，否则，评审人应予以解决！

## 有效的代码评审小贴士

最高效的代码评审方式是结对编程，不过如果 GitHub 的 PR（Pull Request）适用于你的团队，那么 PR 同样可行。为了搞定代码评审，我指的是完全搞定，我们首先应该尝试提高代码评审流程的效率；我们的想法是把评审人当做稀缺的资源，因为我们的主要职责并不是代码评审，对不对？！

以下是有效并高效的代码评审的一些提示：

*   [每次提交的改动尽量小](#keep-changes-small)
*   [经常评审并缩短评审时间](#review-often)
*   [尽早发送 Pull Request 以供评审](#send-pull-request-early)
*   [提供足够的背景信息使 Pull Request 旨意更明确](#provide-enough-context)
*   [Linting 和代码风格检查](#linting-code-style-check)

### 每次提交的改动尽量小

Cisco System 编程团队的一项研究表明，对 200 到 400 LoC（代码行）进行 60 到 90 分钟的长时间评审可以发现 70 — 90% 的缺陷。把每次 PR 的内容当做一个独立单元处理（功能，bug 修复）或有意义的相关性强的想法。想了解为什么单次 Pull Request 提交大量代码弊病繁多以及 Pull Request 的最佳量级，请看[此处](https://smallbusinessprogramming.com/optimal-pull-request-size/)。

![](https://engineering.linecorp.com/wp-content/uploads/2018/10/24/1540351568447.png)

![](https://engineering.linecorp.com/wp-content/uploads/2018/10/24/1540351612913.png)

代码评审, 来自于 Twitter [@iamdeveloper](https://twitter.com/iamdevloper) 与 缺陷密度 vs LoC, 来自于 [Cisco 研究案例](https://smartbear.com/learn/code-review/best-practices-for-peer-code-review/)

### 经常评审并缩短评审时间

以合理的量级，较平稳的速度及利用有限的时间内进行代码评审，可以得到最有效的评审结果。超过 400 LoC，发现缺陷的能力会降低。低于 300 LoC/hr 时检验效率是最好的。

![](https://engineering.linecorp.com/wp-content/uploads/2018/10/24/1540351632935.png)

缺陷密度与检验效率, 来自于 [Cisco 研究案例](https://smartbear.com/learn/code-review/best-practices-for-peer-code-review/)

### 尽早发送 Pull Request 以供评审

为了获得有价值的代码评审，在细化实现前发起讨论并尽量避免提交非常大段的改动。将不同的想法分成不同的 PR，并且根据需要分配给不同的评审人，将大问题分成较小的问题并一次解决一个小问题。

![](https://engineering.linecorp.com/wp-content/uploads/2018/10/24/1540351658308.png)

如果在代码评审的最后一分钟发现架构/设计问题，该如何应用应急办法，来自于[Twitter @isoiphone](https://twitter.com/isoiphone/status/824771226585296896)

### 提供足够的背景信息使 Pull Request 旨意更明确

> 评审人资源能做的十分有限，请明智地对待。

为了帮助评审人快速进入问题背景，提供足够的信息非常重要，例如改动的原因和方案，以及潜藏的问题和需要关注的点。想要激发高效的讨论，这些信息是必不可少的催化剂。作为额外的好处，作者通常会在评审开始之前发现其他错误。虽然不是每个 PR 都值得写出这样的细节，但是你可以简单地注释已经完成和测试的内容或者评审人应该更加关注哪个部分！

[GitHub Issue 和 Pull Request 模板](https://blog.github.com/2016-02-17-issue-and-pull-request-templates/)可能会有所帮助。另外，附上截图来描述您达成的效果是一个好主意！下面是几个关于使用 PR 模板为代码评审和进一步 QA 验证提供有意义背景的例子。

![](https://engineering.linecorp.com/wp-content/uploads/2018/10/24/1540363289472.png)

![](https://engineering.linecorp.com/wp-content/uploads/2018/10/24/1540351906927.png)

Github PR 模板示例

### Linting 和编码风格检查

让机器使用 [SonarQube](https://www.sonarqube.org/) 和 [ESLint](https://eslint.org/) 等工具进行静态代码分析和编码风格检查，为业务逻辑和算法等重要环节节省注意力。这些代码扫描工具、类型检查工具和 linting 工具可以报告错误，[code smells](https://en.wikipedia.org/wiki/Code_smell) 和漏洞，使用好的测试套件肯定可以提高代码可靠度。

![](https://engineering.linecorp.com/wp-content/uploads/2018/10/24/1540351983588.png)

在 SonarQube 中发现问题，图片来自于 SonarQube 站点

代码评审中最重要的部分之一是奖励开发人员的成长和努力，因此请提供尽可能多的赞美。

最后，如果你无法理解部分代码，则无法进行适当的评审。如果你的讨论似乎是反复的，那就面对面地完成这部分讨论，那样会更有成效。

## 使之融入我们的工程师文化

有人说“文化是即使没人监督也会自然为之的事”。在跳过代码评审过程时，你是否仍会为代码编写足够的测试？不容易吧？但它仍然值得尝试！如果您的项目采用了敏捷开发模式，请考虑以下因素，以使您的团队文化能自我导向，不断改进和学习：

*   自治：团队成员以他们喜欢的方式承担责任和工作（例如：Scrum，结对编程）
*   提升：持续执行良好的编码实践并通过代码评审相互学习，最终可以提高个人编码技能
*   目标：代码质量是我们的最终目标，应该在早期发现错误而不是在生产中灭火

因此，为了促进团队文化建设，我开始尝试以下两个项目：

*   [增强技能](#enhance-skill)
*   [评估进度](#measure-progress)

### 增强技能

是的，为了深入开展这项工作，开发人员还需要有全面的概念和完整的知识，才能在日常工作中达到团队不断增长的共识（实践）。为了帮助开发人员，我们请来本地培训机构开展有关单元测试，重构和 TDD（测试驱动开发）的培训。

我们在研讨会上讨论了以下主题（列出但不限于此）：

1.  单元测试
    *   设计测试用例用来展示目的，而不是测试代码的实现
    *   需要识别并隔离依赖
    *   引入抽取和覆盖以及依赖注入方法
    *   解释 stub 和 mock 框架及断言库
    *   练习重构技巧，如抽取方法，内联变量等等。
2.  [Kata](https://en.wikipedia.org/wiki/Kata_)（编程）着手于
    *   需求分析、优化方案并找出关键示例
    *   编码设计和实现
3.  TDD 和重构
    *   Demo 重构，标识 code smells 及移除相关方法
    *   使用 TDD 方法进行实时编码（例如：小步前进，红绿灯）
    *   着手实践

![](https://engineering.linecorp.com/wp-content/uploads/2018/10/24/1540352042625.png)

![](https://engineering.linecorp.com/wp-content/uploads/2018/10/24/1540352054720.png)

研讨会期间的照片

### 评估进度

如果你不了解进度，你就无从评估进度，更无法提升进度

我们运用公示屏展示分析结果并通过消息通知持续推送最新进度，强大的视觉效果增加了大家的参与度，为了同一个目标我们共同努力。位于门口的大型公示屏会循环展示如下信息。

*   [SonarQube 项目公示板（dashboard）](#sonarqube-project-dashboard)
*   [基于团队的代码覆盖率](#team-based-code-coverage)
*   [PR 的大小与解决时间](#pr-size-resolution-time)
*   [PR 评论通知](#pr-comment-notification)

#### SonarQube 项目公示板

所有的静态代码分析数据来自于 SonarQube，直接链接到生产服务的代码仓库应该在这里发布报告。

![](https://engineering.linecorp.com/wp-content/uploads/2018/10/24/1540352094755.png)  

#### 基于团队的代码覆盖率

基于团队的代码覆盖率图表显示了团队中每个仓库的覆盖趋势，因此无需导航到每个 SonarQube 项目页面。通过将这种类型的图表并排放置，可以很容易地比较不同团队的表现。

![](https://engineering.linecorp.com/wp-content/uploads/2018/10/24/1540352210111.png)  

#### PR 的大小与解决时间

DevOps 的核心思想是如何将软件变更频繁地发布到生产中，同时保证质量。使每个部署单元变小是这里的诀窍。大型 PR 不仅无法进行良好的代码评审，而且还会增加在代码质量和发布周期成本，因此对于 DevOps 将任务/变更做小是行之有效的技能。我们尝试使用以下“分辨率时间与 PR 大小”图表来推进这一理念：

![](https://engineering.linecorp.com/wp-content/uploads/2018/10/24/1540352229137.png)  

*   气泡大小：更改设置大小（代码行）
*   解决时间：PR 创建时间到 PR 合并时间
*   #n：PR 号

这些图表持续提醒每个人采用良好实践和追求目标的进度。这些只是我们在这里做的一些例子。想想你自己可以直观地向别人展示你的意图。顺便说一下，这些对于月度会议期间总结进展也很有用。


#### PR 评论通知

提交给 PR 的每次提交都会触发一个 webhook 来发布 github 评论，如下所示。这是为了提醒 PR 创建者添加测试并修复在此 PR 内部发现的新漏洞，这比在两周后把更改发布到生产中更为有效。为了提高质量指标，评审人还应该帮助找出被评审人遇到问题的原因。

![](https://engineering.linecorp.com/wp-content/uploads/2018/10/25/1540439109739.png)  

*   最新 n 次提交的平均值: 展示每种指标的趋势
*   xxx 次问题: 发现的 bug，漏洞和 code smells 的数量
*   代码覆盖率: 执行单元测试的 LoC 百分比

## 总结与未来计划

为了给代码评审讨论提供很好的环境，知晓如何编写整洁的代码以及如何识别 code smell 并删除至关重要，只有团队真正下功夫解决这些常见问题，文化才能随之培养。

另一方面，没用的指标不需要跟踪；显示数据随时间变化的趋势很重要，它提供给我们做出相应措施的背景。看看上图中显示的趋势线随着进展而变化。此外，我们还考虑添加更多公示板展示以下内容：

*   质量：开启/关闭的 bug 数，同时展示严重性和缺陷密度
*   速度：部署频率，生产前导时间，修改失败率和平均恢复时间（MTTR）

## 参考

*   [Gerrit] [代码评审 — 贡献](https://gerritcodereview-test.gsrc.io/dev-contributing.html#code-organization)
*   [Phabricator] [编写可评审的代码](https://secure.phabricator.com/book/phabflavor/article/writing_reviewable_code/)
*   [Phabricator] [差异用户指南：测试计划](https://secure.phabricator.com/book/phabricator/article/differential_test_plans/)
*   [MSFT] [代码评审和软件质量，实践研究成果](https://www.linkedin.com/pulse/code-reviews-software-quality-empirical-research-results-avteniev/)
*   [Cisco] [代码评审的最佳实践](https://smartbear.com/learn/code-review/best-practices-for-peer-code-review/)
*   [Book] [加速：依靠软件和 DevOps 的科学](https://www.amazon.com/Accelerate-Software-Performing-Technology-Organizations-ebook/dp/B07B9F83WM)
*   [驱动力] [关于激励他人的惊人事实](https://www.danpink.com/books/drive)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
