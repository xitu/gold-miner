> * 原文地址：[The beginner's guide to contributing to a GitHub project](https://akrabat.com/the-beginners-guide-to-contributing-to-a-github-project/)
> * 原文作者：[Rob Allen](https://akrabat.com)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/the-beginners-guide-to-contributing-to-a-github-project.md](https://github.com/xitu/gold-miner/blob/master/TODO1/the-beginners-guide-to-contributing-to-a-github-project.md)
> * 译者：[sophia](https://github.com/sophiayang1997)
> * 校对者：

# 为 GitHub 项目做出贡献的初学者指南

这是一个为 GitHub 项目做出贡献的初学者指南。它主要基于我看到 [Zend Framework](http://framework.zend.com)，[Slim Framework](http://www.slimframework.com) 和 [joind.in](https://joind.in) 如何操作。但是，这是一个通用指南，因此请先检查项目的 README 文件以了解具体情况。

## 第 1 步：在你的计算机上设置工作副本[](#step-1-set-up-a-working-copy-on-your-computer)

首先你需要一个项目的本地分支，所以先在 GitHub 中按下“fork”按钮。这之后会在你自己的 GitHub 账户中创建一个仓库副本，而且你会看到在已经被 fork 成功的项目名称下面有一行注释：

![Forked](https://akrabat.com/wp-content/uploads/2015/09/2015-09forked.png)

现在你需要一个本地副本，因此在右侧列中找到“SSH clone URL”，并使用它在本地终端进行克隆：

```
$ git clone git@github.com:akrabat/zend-validator.git
```

如下图所示：

![Clone](https://akrabat.com/wp-content/uploads/2015/09/2015-09clone.png)

将路径转到新项目的目录中：

```
$ cd zend-validator
```

最后，在这个阶段，你需要设置一个指向原始项目的新远程，以便你可以抓取原始项目的任何更改并将它们更新至本地副本。首先将链接指向原始仓库 —— 它在 GitHub 页面的顶部标记为“Forked from”。这会将你带回项目的主要 GitHub 页面，因此你可以找到“SSH clone URL”并使用它创建新的远程，我们通常也可称之为 **upstream**。

```
$ git remote add upstream git@github.com:zendframework/zend-validator.git
```

你现在在磁盘上拥两个此项目的远程：

1.  **origin**：它指向你项目的 GitHub 分支。你可以读取和写入此远程。
2.  **upstream**：它指向主项目的 GitHub 仓库。你只能从这个远程读取。

## 第 2 步：做一些工作[](#step-2-do-some-work)

这是你为项目作出贡献时最有趣的一步。通常情况下，最好从修复一个令人讨厌的问题开始，或者是你在项目的 issue 跟踪器中找到的问题。如果你正在寻找一个开始的地方，很多项目使用[“easy pick“标签](http://seld.be/notes/encouraging-contributions-with-the-easy-pick-label)（或者相近意思的标签）来表明这个问题可以由项目开发的新人解决。

### 分支![](#branch)

**第一法则是将每一份修改工作都放到自己的分支上**。如果项目使用 [git-flow](http://nvie.com/posts/a-successful-git-branching-model/)，那么它将同时拥有一个 **master** 和一个 **develop** 分支。一般的规则是，如果你是修复 bug，那么从 master 上拉下新分支。如果你正在添加一个新功能，那么从 develop 上拉下新分支。如果该项目只有一个 **master** 分支，直接从该 master 拉取新分支。有一些项目，如 Slim 使用以版本号命名的分支（2.x 和 3.x）。在这种情况下，选择相关的分支。

对于这个例子，我们假设我们正在修复 zend-validator 中的一个 bug， 所以我们从 **master** 拉出新分支：

```
$ git checkout master
$ git pull upstream master && git push origin master
$ git checkout -b hotfix/readme-update
```

首先我们确保我们在主分支上。然后 git pull 命令将我们的本地副本与上游项目同步，并且 git push 命令将它同步到我们所在分支的 GitHub 副本项目中。最后我们创建我们的新分支。你可以根据你的喜好命名你的分支，但是它最好是有意义的。包括问题编号，这通常也是有帮助的。如果该项目像 zend-validator 使用 git-flow 一样，那么在特定的命名约定中分支名的前缀是“hotfix/”或者“feature/”。

现在你就可以开始做你的工作了。

**确保你只修复你正在处理的事情。不要试图解决你修复问题过程中看到的其他问题，包括格式问题，因为你的 PR 可能会被拒绝。**

确保你在逻辑块中提交。每个提交消息应该是理智的。请阅读 Tim Pope 的[关于 Git 提交消息的注意事项](http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html)。

## 第 3 步：创建 PR[](#step-3-create-the-pr)

要创建 PR，你需要将你的分支推送到 **origin** 远程，然后按下 GitHub 上的一些按钮。

推送一个新分支：

```
$ git push -u origin hotfix/readme-update
```

这样做将会在你的 GitHub 项目上创建新分支。-u 标志符表示将本地分支与远程分支相连，以便将来只需输入 git push origin 就可以推送到远程分支。

返回浏览器并导航到你 fork 的项目（在我的示例中地址是：https://github.com/akrabat/zend-validator），你会发现你的新分支在顶部列出了一个简便的“Compare & pull request”按钮：

![Pr button](https://akrabat.com/wp-content/uploads/2015/09/2015-09pr-button.png)

继续然后按下按钮！

如果你看到这样的黄色框：

![Contributing](https://akrabat.com/wp-content/uploads/2015/09/2015-09contributing.png)

点击链接可以将你带到项目的 CONTRIBUTING 文件并且你需要阅读它！它包含有关如何使用该项目代码库的宝贵信息，并将帮助你如何使你的贡献被接受。

在此页面上，确保“base fork”指向正确的仓库和分支。然后确保你为 pull request 提供了一个很好，简洁的标题，并在说明框中解释你为什么创建了它。如果你有相关的 issue 编号，请添加进去。

![Create pr](https://akrabat.com/wp-content/uploads/2015/09/2015-09create-pr.png)

如果你向下滚动一点，你就会看到你的更改与原版本的差异。**仔细检查它是否是你想要的结果。**

要是你觉得没什么问题了，按下“Create pull request” 按钮即可完成。

## 第 4 步：由维护人员审查[](#step-4-review-by-the-maintainers)

为了将你的修改工作集成到项目中，维护人员将检查你的修改工作，并请求更改或合并它。

Lorna Mitchell 的文章[代码审查：在你运行代码之前](http://www.lornajane.net/posts/2015/code-reviews-before-you-even-run-the-code)涵盖了维护人员将要查找的内容，所以阅读它并确保不给维护人员增添麻烦。

## 总结[](#to-sum-up)

上面就是所有你应该做的事情，下面列举一些基本点：

1.  Fork 原项目并克隆到本地。
2.  创建一个 **upstream** 远程并在你创建分支之前同步更新到你的本地副本。
3.  为每项单独的工作创建分支。
4.  做好你的工作，编写[良好的提交信息](https://blogs.gnome.org/danni/2011/10/25/a-guide-to-writing-git-commit-messages/)，并阅读CONTRIBUTING文件（如果有的话）。
5.  推送到 **origin** 仓库。
6.  在 GitHub 中创建一个新的 PR。
7.  回应每一条[代码审查](http://www.lornajane.net/posts/2015/code-reviews-before-you-even-run-the-code)的反馈信息。

如果你想贡献一个开源项目，最好选择一个你自己使用的项目。维护人员会很欣赏！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
