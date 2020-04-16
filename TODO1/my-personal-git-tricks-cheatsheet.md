> * 原文地址：[My Personal Git Tricks Cheatsheet](https://dev.to/antjanus/my-personal-git-tricks-cheatsheet-23j1)
> * 原文作者：[Antonin Januska](https://dev.to/antjanus)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/my-personal-git-tricks-cheatsheet.md](https://github.com/xitu/gold-miner/blob/master/TODO1/my-personal-git-tricks-cheatsheet.md)
> * 译者：[Pingren](https://github.com/Pingren)
> * 校对者：[zh1an](https://github.com/zh1an)，[Badd](https://github.com/Baddyo)，[shixi-li](https://github.com/shixi-li)

# 我个人的 Git 技巧备忘录

除了 “基础的” 命令之外，每个人都有他们常用的 Git 技巧。我想列出我愿意在 `.gitconfig` 保存别名（alias）的命令。在文章末尾，你可以看到一些在 git 之外与 `git` 相关的有意思的命令！:)

## 快速纠正

我经常忘记提交（commit）某文件，或者遗留了 `console.log` 在文件里。我十分讨厌如 `删除 console.log` 的提交。因此，我将添加文件至暂存区，就好像我要提交一样，接着运行命令：

```bash
git commit --amend --reuse-message HEAD
```

这个命令会将文件加入上次提交，并且重新使用旧的提交信息。我将它的别名设置为 `git amend`，用于快速修正错误。

**注意** 基于底下评论区的回复，也可以使用命令 `git commit --amend --no-edit` 达到一样的效果。

## 在 origin/master 分支的顶部变基

旧的分支通常情况下会落后相当久远，久到我不得不准备好消除编译错误、ci 错误，或者解决冲突。此时我最喜欢使用以下命令：

```bash
git fetch origin # fetch latest origin
git rebase origin/master
```

通过这种方式，我将当前分支的提交都叠加在最新版本的 master 分支之上。

## 上次的提交

有时，`git log` 命令的结果冗长。由于我频繁使用的前文中提过的 `amend` 命令，我倾向于查看最后一条提交记录：

```bash
git log -1
```

## 签出到旧版文件 (比如一个锁文件！)

有时，我把某个与我的分支不相关文件搞坏了。这通常发生在锁文件上（`mix.lock`、`package-lock.json` 等等）。我只是将这个文件“重置”回旧版本而不是还原一个可能包含许多其他内容的提交：

```bash
git checkout hash值 mix.lock
```

接着我就可以提交修复！

## cherry-pick

我偶尔会使用这个被低估的命令。当一个分支变得老旧，有时候从中只获取真正需要的东西，比让整个分支跟上进度简单。举个例子，这个分支有关于 UI 或后端的冗余代码。在这种情况下，我可能只想从分支中挑选出特定的提交：

```bash
git cherry-pick hash值
```

这将会把提交带到你所处的分支。你也可以使用列表！

```bash
git cherry-pick 第一个hash值 第二个hash值 第三个hash值
```

你也可以使用区间：

```bash
git cherry-pick 开始的hash值..结束的hash值
```

### 参考日志

这是一个高级功能，以至于我几乎不用它。我的意思是，大概一年用一次。但是了解一下它还是挺好的。有时，我丢失了提交：我不小心删除了分支、重置或修改了一个提交。

在这些情况下，知道 `reflog` 的存在就挺好的。它不是你当前所处的分支的提交日志，它是你所有提交（包括了在失效分支之上）的日志。然而，这个日志将会随着时间推移被清空（pruned），因此只有有关的信息会保留。

```bash
git reflog
```

这个命令将返回一个日志，你可以在某个提交之上使用挑选或者变基。使用 pipe 管道命令连接 `grep` 之后非常强大。

## Bash 命令别名

除了 git 命令，我也喜欢使用一些有趣的 bash 别名来帮助我的工作流。

### 当前分支

为了获取当前分支的名字，我有这个别名：

```bash
alias git-branch="git branch | sed -n -e 's/^\* \(.*\)/\1/p'"
```

当我运行 `git-branch` 或者在其它命令中运行 `$(git-branch)`，我将得到我目前所在的分支的名字。

**注意** 基于评论区的回复，我将它切换为 `git symbolic-ref --short HEAD`，可以达到一样的效果并且命令更具有可读性。

### 跟踪上游分支

虽然我确定配置 `.gitconfig` 可以解决问题，我暂时还没弄清楚如何做（译者注：使用命令 `git config --global push.default current`，参见[官方文档](https://git-scm.com/docs/git-config/#Documentation/git-config.txt-pushdefault)）。当我在新的分支上首次运行推送命令时，我总是被要求先设置上游分支的跟踪状态。这种情况下我使用别名：

```bash
alias git-up="git branch | sed -n -e 's/^\* \(.*\)/\1/p' | xargs git push -u origin "
```

现在当我运行 `git-up`，我可以推送当前的分支并设置好上游分支的跟踪状态！

## 回复

基于评论中一些有用的反馈，我对我所使用的别名做了一些修改。

### 当前分支

似乎有许多新方式来获取当前的分支名称。如果你往上看，你将看到我使用了一个疯狂的 `sed` 命令来获取分支名称。

以下是我使用的新办法：

```bash
alias git-branch="git symbolic-ref --short HEAD"
```

它的运行与期望完全一样！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
