> * 原文地址：[How To Become a DevOps Engineer In Six Months or Less, Part 3: Version](https://medium.com/@devfire/how-to-become-a-devops-engineer-in-six-months-or-less-part-3-version-76034885a7ab)
> * 原文作者：[Igor Kantor](https://medium.com/@devfire?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-become-a-devops-engineer-in-six-months-or-less-part-3-version.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-become-a-devops-engineer-in-six-months-or-less-part-3-version.md)
> * 译者：[jianboy](https://github.com/jianboy)
> * 校对者：[lihanxiang](https://github.com/lihanxiang)

# 如何在六个月或更短的时间内成为 DevOps 工程师，第三部分：版本控制

![](https://cdn-images-1.medium.com/max/1000/0*WbA21p1XhfwT36Cx)

“背光式笔记本的特写镜头”由 [Markus Petritz](https://unsplash.com/@petritzdesigns?utm_source=medium&utm_medium=referral) 发布在 [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)

**注意：这是《如何如何在六个月或更短的时间内成为 DevOps 工程师》系列的第三部分，第一部分请点击[这里](https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-become-a-devops-engineer-in-six-months-or-less.md)。第二部分点击[这里](https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-become-a-devops-engineer-in-six-months-or-less-part-2-configure.md)。**

让我们快速回顾一下上期内容。

简而言之，这一系列文章讲述了一个故事。

而这个故事正在学习如何将想法转化为金钱，快速 —— 现代化 DevOps 开发的精髓。

具体而言，在[第一部分](https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-become-a-devops-engineer-in-six-months-or-less.md)我们谈到了 DevOps 的文化和目标。

在[第二部分](https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-become-a-devops-engineer-in-six-months-or-less-part-2-configure.md)，我们讨论了如何使用 Terraform 为未来的代码部署奠定基础。当然，Terraform 也是代码！

因此，在这篇文章中，我们将讨论如何防止所有这些代码完全失控。剧透，这都是关于 [_git_](https://git-scm.com/)！

额外奖励：我们还将讨论如何使用此 git business 来构建和推广您自己的个人品牌。

作为参考，我们从这里开始：

![](https://cdn-images-1.medium.com/max/1000/1*N-4zkp9GM6apxn3GMWcT0A.png)

DevOps 之旅

* * *

那么，当我们谈论“版本控制”时，我们在说什么？

想象一下，你正在开发一些软件。您正在不断更改它，根据需要添加或删除功能。 通常情况下，最新的变化将是一次“破坏性”的变化。 换句话说，无论你最后做了什么，都打乱之前的工作。

怎么办？

好。如果您在以前的学校，您可能倾向于将您的第一个文件命名为：

```
awesome_code.pl
```

然后你开始对文件做一些修改，你需要保留有用的东西，万一你必须恢复它。

因此，您将文件重命名为：

```
awesome_code.12.25.2018.pl
```

这很好。直到有一天你每天进行多次更改，所以你最终会得到这样的结果：

```
awesome_code.GOOD.12.25.2018.pl
```

等等。

当然，在专业环境中，您有多个团队在相同的代码库上进行协作，这进一步打破这种文档备份方案。

毋庸置疑，上面这种文件重命名来版本管理肯定行不通。

源代码控制：一种将文件保存在**集中**位置的方法，其中多个团队可以在公共代码库上一起工作。

现在，这个想法并不新鲜。我能找到的最早提及的[文章](https://en.wikipedia.org/wiki/Source_Code_Control_System)可以追溯到 1972 年！因此，我们应该将代码集中在一个地方的想法肯定是老的。

然而，相对较新的是**所有开发过程必须被版本化**的想法。

什么意思呢？

这就是说涉及生产环境的所有内容都必须存储在版本控制中，并受到跟踪、审核和记录历史更改。

此外，强制执行“所有开发过程必须版本化”的原则实际上迫使您以“自动化第一”的思维方式处理问题。

例如，当您决定在 Dev AWS 环境中只通过点击解决复杂问题时，您可以暂停并思考这么一个问题：“所有点击操作都受版本控制了吗？”

当然，答案是“不”。因此，虽然可以通过 UI 进行快速原型查看是否有效，但这些努力必须是短暂的。从长远来看，请确保您使用 Terraform 或其他架构即代码工具来执行所有操作都受版本控制。

好的，所以如果一切都受版本控制，那么我们如何存储和管理这些东西呢？

答案是 git。

在 [git](https://git-scm.com/doc) 出现之前，使用像 SVN 或其他的源代码控制系统是笨重的，不是用户友好的，并且通常是非常痛苦的经历。

git 的不同之处在于它包含**分布式**源代码控制的概念。

换句话说，当您正在处理更改时，您不会将其他人锁定在集中式源代码存储库之外。相反，您正在编写代码库的完整**副本**。然后该副本会 _merged_ 进入 _master_ 存储库。

请记住，以上是对 git 如何工作的粗略过度简化。但就本文而言，这已经足够了，即使知道 git 的内部工作方式既有价值又需要一段时间才能掌握。

![](https://cdn-images-1.medium.com/max/800/0*hoGY4_63YI8B7Pbc.png)

[https://xkcd.com/1597/](https://xkcd.com/1597/)

现在，请记住，git **不是**像旧版的 SVN 一样。它是一个分布式源代码控制系统，多个团队可以安全，可靠地在共享代码库上工作。

这对我们意味着什么？

具体来说，如果没有使用 git 版本管理而自称作专业的 DevOps（云）工程师，我严重怀疑你的能力。就这么简单。

好的，那么如何学习 git 呢？

我必须说，Google 搜索 “git 教程”的区别在于它提供的教程非常全面但非常令人困惑。

但是，有一些非常非常好。

我推荐大家阅读，学习和练习的一系列教程是 [Atlassian’s Git Tutorials](https://www.atlassian.com/git/tutorials)。

事实上，它们都非常好，但特别是世界各地的专业软件工程师使用的部分：[Git Workflows](https://www.atlassian.com/git/tutorials/comparing-workflows)。

我再怎么强调也不为过。一次又一次地，缺乏理解 git 分支是如何工作的，或者没有解释 Gitflow 是什么让 99% 有抱负的 DevOps 工程师落选的原因。

这是关键。你可以参加面试，即使不知道 Terraform 或者最新的架构及代码是什么，没关系 — 你可以在工作中学习它。

不知道 git 及其工作方式表明你缺乏现代软件工程最佳实践的基础知识，DevOps 与否。这向招聘经理发出信号，表明你的学习曲线非常陡峭。你不想发出信号！

相反，您自信地谈论 git 最佳实践的能力告诉招聘经理您首先要具备软件工程思维模式 —— 这正是您想要应用到工作中的思维。

总而言之，你不需要成为世界上最重要的 git 专家，来获得令人敬畏的 DevOps 角色，但你确实需要在一段时间内生活和呼吸 git，才能自信地谈论正在发生的事情。

至少，你应该精通如下：

1. Fork 一个仓库
2. 创建分支
3. 合并两个不同的 commit
4. 创建 Pull 请求

现在，一旦您完成介绍性的 git 教程，请获取 [GitHub](https://help.github.com/) 帐户。

注意：GitLab 也可以，但在撰写本文时，GitHub 是最流行的开源 git 存储库，因此您肯定希望和其他人分享。

获得 GitHub 帐户后，开始为其提供代码！无论你学到什么，都需要你编写代码，请确保定期将它提交给 GitHub。

这不仅可以灌输良好的源代码控制思想，还可以帮助您建立自己的个人品牌。

注意：当你学习如何使用 git + GitHub 时，要特别注意 [Pull Requests](https://help.github.com/articles/about-pull-requests/)（也叫 PRs，如果你想变酷）。

![](https://cdn-images-1.medium.com/max/800/0*E1Y3iKOJjkKiwcoa)

Pull Request, by [Vidar Nordli-Mathisen](https://unsplash.com/@vidarnm?utm_source=medium&utm_medium=referral)

* * *

品牌：向更广阔的世界展示您的能力的一种方式。

这种方式（目前，更好的方式之一！）是建立一个 GitHub 账户，作为您的品牌代表。这些天几乎所有的面试官都会要求求职者有 GitHub 账户。

因此，您应该努力拥有一个整洁、精心策划的 GitHub 帐户 — 您可以将其放在简历上并为此感到自豪。

在后面的部分中，我们将讨论如何使用 [Hugo](https://gohugo.io/) 框架在 GitHub 上构建一个简单但酷炫的网站。现在，只需将代码放入 GitHub 即可。

稍后，随着您的经验越来越丰富，您可能会考虑使用两个 GitHub 帐户。一个用于存储您编写的练习代码的个人资料，另一个用于存储您想要向其他人展示的代码。

总结一下：

* 学习 git
* 将您学到的所有知识贡献给 GitHub
* 利用＃1和＃2作为迄今为止所学到的所有知识的展示
* 从中受益！

最后，请记住这个领域的最新发展，例如 [GitOps](https://queue.acm.org/detail.cfm?ref=rss&id=3237207)。

GitOps 将我们迄今为止讨论的所有想法提升到新的水平 — 一切都通过 git、pull requests 和管道的部署。

请注意，GitOps 和类似的工具应用于**商业**方面的事情。具体来说，我们不是在使用像 git 之类的复杂东西，因为它们很酷。

相反，我们使用 git 来实现业务敏捷性，加速创新并更快地交付功能 —— 这些都可以让我们的业务最终赚到更多钱！

目前为止就这样了！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。

