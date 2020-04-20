> - 原文地址：[5 Best Practices To Prevent Git Leaks](https://levelup.gitconnected.com/5-best-practices-to-prevent-git-leaks-4997b96c1cbe)
> - 原文作者：[Coder’s Cat](https://medium.com/@coderscat)
> - 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> - 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/5-best-practices-to-prevent-git-leaks.md](https://github.com/xitu/gold-miner/blob/master/TODO1/5-best-practices-to-prevent-git-leaks.md)
> - 译者：[YueYongDEV](https://github.com/YueYongDev)
> - 校对者：[Roc](https://github.com/QinRoc)、[icy](https://github.com/Raoul1996)

# 防止 Git 泄漏的 5 种最佳做法

![](https://cdn-images-1.medium.com/max/4000/0*bskmb4Tr98q5if_y.jpg)

无数的开发人员正在使用 Git 进行版本控制，但是许多开发人员对 Git 的工作方式并没有足够的了解。有些人甚至将 Git 和 Github 用作备份文件的工具。这些做法导致 Git 仓库中的信息遭到泄露，[每天都有数千个新的 API 或加密密钥从 GitHub 泄漏出去](https://www.zdnet.com/article/over-100000-github-repos-have-leaked-api-or-cryptographic-keys/)。

我在信息安全领域工作了三年。大约在两年前，我们公司发生了一起非常严重的安全问题，是由于 Git 仓库发生了信息泄露导致的。

一名员工意外地在 Github 上泄露了 AWS 的密钥。攻击者使用此密钥从我们的服务器下载很多敏感的数据。我们花了很多时间来解决这个问题，我们试图统计出泄漏了多少数据，并分析了受影响的系统和相关用户，最后替换了系统中所有泄漏的密钥。

这是一个任何公司和开发人员都不愿经历的悲惨故事。

关于整件事情的细节我就不多写了。事实上，我希望更多的人知道如何去避免 Git 的信息泄露。以下是我提出的一些建议。

## 建立安全意识

大多数新人开发者没有足够的安全意识。有些公司会培训新员工，但有些公司没有系统的培训。

作为开发人员，我们需要知道哪些数据可能会带来安全问题。千万记住，下面这些数据不要上传到 Git 仓库中：

1. 任何配置数据，包括密码，API 密钥，AWS 密钥和私钥等。
2. [个人身份信息](https://en.wikipedia.org/wiki/Personal_data)（PII）。根据 GDPR 的说法，如果公司泄露了用户的 PII，则该公司需要通知用户和有关部门，否则会带来更多的法律麻烦。

如果你在公司工作，未经允许，请勿共享任何与公司相关的源代码或数据。

攻击者可以在 GitHub 上轻松地找到某些具有公司版权的代码，而这些代码都是被员工无意中泄露到 Github 上的。

我的建议是，应该将公司项目和个人项目严格区分。

## 使用 Git 忽略（Git ignore）

当我们使用 Git 创建一个新项目时，我们必须正确地设置一个 **.gitignore** 文件。**.gitignore** 是一个 Git 配置文件，它列出了不会被存入 Git 仓库的文件或目录。

[这个 gitignore 项目](https://github.com/github/gitignore) 是一个实际使用着的 .gitignore 模板集合，其中包含对应各种编程语言、框架、工具或环境的配置文件。

我们需要了解 **gitignore** 的模式匹配规则，并根据模板添加我们自己的规则。

![](https://cdn-images-1.medium.com/max/2000/0*VmEolB6qYNCYr9Wf.png)

## 使用 Git 钩子（Git hooks）和 CI 检查提交

没有工具可以从 Git 仓库中找出所有敏感数据，但是有一些工具可以为我们提供帮助。

[git-secrets](https://github.com/awslabs/git-secrets) 和 [talisman](https://github.com/thoughtworks/talisman) 是类似的工具，它们应作为[预提交的钩子](https://git-scm.com/book/en/v2/Customizing-Git-Git-Hooks)（pre-commit hooks）安装在本地代码库中。每次都会在提交之前对更改的内容进行检查，如果钩子检测到预期的提交内容可能包含敏感信息，那它们将会拒绝提交。

[gitleaks](https://github.com/zricethezav/gitleaks) 提供了另一种在 git 仓库中查找未加密的密钥和其他一些不需要的数据类型的方法。我们可以将其集成到自动化工作流程中，例如 CICD。

## 代码审查（Code review）

代码审查是团队合作的最佳实践。所有队友都将从彼此的源代码中学习。初级开发人员的代码应由具有更多经验的开发人员进行审查。

在代码检查阶段可以发现大多数不符合预期的更改。

[启用分支限制](https://help.github.com/en/github/administering-a-repository/enabling-branch-restrictions) 可以强制执行分支限制，以便只有部分用户才能推送到代码库中受保护的分支。Gitlab 也有类似的选择。

将 master 设置为受限制的分支有助于我们执行代码审查的工作。

![](https://cdn-images-1.medium.com/max/2208/0*RUqDCQlDgym-Jo8x.png)

## 快速并且正确地修复它

即使使用了上面提到的工具和方法，却仍然可能会发生错误。但如果我们快速且正确地修复它，则代码泄漏可能就不会引起实际的安全问题。

如果我们在 Git 仓库中发现了一些敏感数据泄漏，我们就不能仅仅通过提交另一个提交覆盖的方式来进行清理。

![This fix is self-deception](https://cdn-images-1.medium.com/max/2000/0*FsGBhHSlXdeSpTk4.png)

我们需要做的是从整个 Git 历史记录中删除所有敏感数据。

**在进行任何清理之前请记得进行备份，然后在确认一切正常后再删除备份文件。**

使用 `--mirror` 参数克隆一个仓库；这是 Git 数据库的完整副本。

```bash
git clone --mirror git://example.com/need-clean-repo.git
```

我们需要执行 **git filter-branch** 命令来从所有分支中删除数据并提交历史记录。

下面举个例子，假设我们要从 Git 中删除 `./config /passwd`：

```bash
$ git filter-branch --force --index-filter \
  'git rm --cached --ignore-unmatch ./config/password' \
  --prune-empty --tag-name-filter cat -- --all
```

请记住将敏感文件添加到 .gitignore 中：

```bash
$ echo "./config/password" >> .gitignore
$ git add .gitignore
$ git commit -m "Add password to .gitignore"
```

然后我们将所有分支推送到远端：

```bash
$ git push --force --all
$ git push --force --tags
```

告诉我们的小伙伴进行变基（rebase）：

```bash
$ git rebase
```

[BFG](https://rtyley.github.io/bfg-repo-cleaner/) 是一种比 **git filter-branch** 更快、更简单的用于删除敏感数据的替代方法。通常比 **git filter-branch** 快 10–720 倍。除删除文件外，BFG 还可以用于替换文件中的机密信息。

BFG 保留最新的提交记录。它是用来防止我们犯错误的。我们应该显式地删除文件，提交删除，然后清除历史记录以此删除它。

如果泄漏的 Git 代码库被其他人 fork 了，我们需要遵循 [DMCA](https://help.github.com/en/github/site-policy/dmca-takedown-policy#c-what-if-i-inadvertently-missed-the-window-to-make-changes) 的删除策略，请求 Github 删除创建的代码库。

整个过程需要一些时间才能完成，但这是删除所有副本的唯一方法。

## 总结

不要犯无数人犯过的错误。尽力避免发生安全事故。

使用上面提到的这些工具和策略将有助于避免 Git 泄漏。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
