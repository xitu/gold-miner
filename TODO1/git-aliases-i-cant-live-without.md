> * 原文地址：[Git aliases I can't live without](http://mjk.space/git-aliases-i-cant-live-without/)
> * 原文作者：[MICHAŁ KONARSKI](http://mjk.space)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/git-aliases-i-cant-live-without.md](https://github.com/xitu/gold-miner/blob/master/TODO1/git-aliases-i-cant-live-without.md)
> * 译者：
> * 校对者：

# 我无法想象没有 Git 别名的的场景

大家看到我的 Git 工作流时，总是充满了惊讶与好奇：

![我的 Git 工作流](http://mjk.space/images/blog/git-aliases/workflow.gif)**我的 Git** 工作流

我对别名的热爱，始于我初次下载 **zsh** 和它的 **[oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh)** 套件。它包含大量针对不同命令行程序的预定义别名和函数助手。我立刻便喜欢上了这种取代常规的那些很长的参数化调用的输入概念。因为我最常使用的工具是 Git，所以它是我开始别名变革的首选目标。几年之后的现在，我无法想象使用 Git 自带的那些原始 `git` 命令。

当然，Git 本身就拥有完美的[别名自定义系统](https://git-scm.com/book/en/v2/Git-Basics-Git-Aliases)。对我来说，我只是不喜欢 `git` 和别名之间的空白。Shell 别名也很灵活，别名也可以用于其他地方，例如 `docker`。

下面你会找到我使用最多的别名列表。其中一些直接源自于我的 **oh-my-zsh**，其他一些是我自己创造的。我喜欢你们至少可以找到一些有用的！如果你想亲自尝试所有的这些方法，可以从[我的仓库](https://github.com/mjkonarski/oh-my-git-aliases)下载。

### 1. 我们从这个库开始吧！

`alias gcl = git clone`

这可能不是 Git 用户最常使用的命令，但我个人希望尽可能让你们最快掌握这些**令人生畏的 GitHub 项目**，就像我所希望的那样。

### 2. 从远程仓库获取分支最新动态

`alias gf = git fetch`

我通常使用 fetch 来获取远程仓库的最新更改，因为它不会以任何形式影响工作目录的 **HEAD**。之后我会使用其他命令来显式修改本地文件。

### 3. 我们查看一下其他分支！

`alias gco = git checkout`

对于日常开发来说，这无疑是最有用的命令之一。我决定写这篇文章的原因之一就是，我发现大家每次在他们想要切换分支时，仍然需要使用 `git checkout`。

### 4. 回退到之前的分支状态！

`gco -`

这个破折号是一个小把戏，意思是“以前的分支”。我知道严格意义上，它不算是别名，但这不影响它的用处。而且，我记得好像没有多少人知道这些事情。

`checkout` 不是接受破折号的唯一选项 —— 你也可以在其他地方使用，比如 `merge`、`cherry-pick` 和 `rebase`。

### 5. 快速切换至 master 分支

`alias gcm = git checkout master`

如果我们经常在一些定义良好的分支之间进行切换，那么我们为什么不使其尽可能简单一些呢？根据你的工作流，你也可以找出其他相似的有用别名：`gcd` (**develop**)、`gcu` (**uat**)、`gcs` (**stable**)。

### 6. 我在哪？发生了什么？

`alias gst = git status`

简单明了。

### 7. 我不在意当前工作变化，只要从源分支给我最新的状态就行！

`alias ggrh = git reset --hard origin/$(current_branch)`

我的个人最爱。有多少次你制造了如此严重的混乱，以至于你只想让暂存区和工作目录恢复到原来的状态？现在只剩下四个按键了。

请注意，这个特定的命令将当前分支重置为来源于 **origin** 分支的最新提交。这正是**我**通常最需要的，但可能不是**你**需要的东西。每当我不关心本地更改时，我都会使用它，我只希望我的当前分支能够反映对应的远程分支。你可能会说你可以使用 `git pull` 替带，但我只是不喜欢它会试图合并远程分支，而不只是将当前分支重置为远程分支。

注意 `current_branch` 是一个自定义函数（由 **oh-my-zsh** 作者创建）。你可以看到它，比如[这里](https://github.com/mjkonarski/oh-my-git-aliases/blob/master/oh-my-git-aliases.sh#L71)。

### 8. 当前的更改是什么？

`alias gd = git diff`

有一个典型示例。它只是显示了所有的改变，但并没有分阶段。如果要查看已经进行的更改，请使用此版本：

`alias gdc = git diff --cached`

### 9. 让我们提交哪些更改的文件！

`alias gca = git commit -a`

这会提交所有的更改文件，因此你不需要手动添加它们。但是，如果有一些尚未提交的新文件，显然需要显式地说明它们：

`alias ga = git add`

### 10. 我想在先前的提交中添加一些更改！

`alias gca! = git commit -a --amend`

我经常使用它，因为我喜欢保持 Git 历史记录的整洁（没有 “pull request fixs” 或者 “forgot to add this file” 类型的提交信息）。它只需简单接受所有的更改并将他们添加到上一次提交中。

### 11. 我之前的分支做的太快，那么怎么撤销一个文件？

```
gfr() {
    git reset @~ "$@" && git commit --amend --no-edit
}
```

这是一个函数，不是别名，乍看好像有些复杂。它获取要“取消提交”的文件名称，从 **HEAD** 提交中删除对该文件所做的所有更改，但将其保留在工作目录中。然后，它会准备分阶段提交，也许是作为一个独立提交。这就是它在实践中的工作方式：

![grf 示例](http://mjk.space/images/blog/git-aliases/grf.gif)

### 12. 好的，准备推送！

`alias ggpush = git push origin $(current_branch)`

我每次想推送的时候，都会使用这个。因为它是隐式传递远程分支参数，所以我可以确保只推送一个分支，而无须在意 `push.default` [设置](https://git-scm.com/docs/git-config#git-config-pushdefault)。从 Git 2.0 开始，它会成为默认行为，但是别名为我提供了额外的安全保证，以防我使用一些 Git 遗留的版本问题。

对于正常的推送，这可能并不那么重要，但对于下一个命令来说，这非常关键。

### 13. 我已经准备推送了，而且我知道我在做什么

`alias ggpushf = git push --force-with-lease origin $(current_branch)`

强制推送显然是一个有争议的习惯，许多人会说你永远不应该这样做。我同意，但只有涉及到想 **master** 这样的关键、共享分支才会有问题。

正如我提及的，我喜欢保持我的 git 历史干净。这有时涉及更改已经被推送的提交。这时，`--force-with-lease` 就会特别有用，因为当你的本地仓库没有远程分支的最新状态时，它会拒绝推送。因此，不可能抛弃别人的修改，至少不应该是无意的。

在我的同事有一次错误地调用了 `git commit -f` (将 `push.default` 设置为 `matching`)之后，我开始使用这个别名， 将远程分支部分名称设置为 `$(current_branch)`，并强制推送所有的本地分支到 **origin** 分支。包括一个旧版本的 **master**，当我意识到发生了什么之后，我仍然记得他眼中的恐慌。

### 14. 哇，推送被拒绝了！有人已经污染了我的分支！

你试图将你的分支推送到远程仓库，但得到了一下信息：

```
To gitlab.com:mjkonarski/my-repo.git
 ! [rejected]        my-branch -> my-branch (non-fast-forward)
error: failed to push some refs to 'git@gitlab.com:mjkonarski/my-repo.git'
hint: Updates were rejected because the tip of your current branch is behind
hint: its remote counterpart. Integrate the remote changes (e.g.
hint: 'git pull ...') before pushing again. 
```

当多个人同时在一个分支上工作时，就会发生这种情况。也许你的同事在你不知情的情况下，又推送了一个修改？或者你用了两台电脑，同步了之前的分支？一下是一个简单的解决方案：

`alias glr = git pull --rebase`

它会自动拉取最新的修改，然后将你的提交 rebase 到他们的顶部。如果你足够幸运（并且对不同的文件进行了远程修改），你甚至可以避免解决冲突。哇，又要重新推送！

### 15. 我想用自己的分支来映射主分支的最新变化！

假设你有一个分支是不久之前从 **master** 分支创建的。你已经推送了一些改变，但同时也更新了 **master** 本身。现在，你希望你的分支可以反映那些最新的提交内容。在这种情况下，相比 merge，我更喜欢 rebase —— 你的提交历史保持保持简短和清晰。就像打字一样简单：

`alias grbiom = git rebase --interactive origin/master`

我经常使用这个命令，因此这个别名是我最开始使用的第一批命令之一。`--interactive` 启用了你最爱的编辑器，并允许你快速检查即将基于 master 提交的提交列表。你也可以利用这个机会来 **squash**、**reword** 或者 **reorder** 提交。因此有许多简单别名可以选择！

### 16. emmm，我尝试了 rebase，但出现了严重的冲突！救命啊！

没有人喜欢这些信息：

```
CONFLICT (content): Merge conflict in my_file.md

Resolve all conflicts manually, mark them as resolved with
"git add/rm <conflicted_files>", then run "git rebase --continue".
You can instead skip this commit: run "git rebase --skip".
To abort and get back to the state before "git rebase", run "git rebase --abort".
```

有时，你可能只想中止整个进程，之后再解决冲突。以上信息是如何处理的线索，但为什么以上的解决线索会出现那么多按键呢？

`alias grba = git rebase --abort`

我们又安全了。但你终于鼓起勇气再次进行合并解决这些冲突时，在 `git add` 之后，你只需继续进行 rebase 输入即可：

`alias grbc = git rebase --continue`

### 17. 请把这些变化暂时搁浅！

假设你已经做了一些改变，但还没有提交它们。现在你想快速切换到另一个分支，并执行一些无关的工作：

`alias gsta = git stash`

这个提交将你的修改放在一边，并恢复至 **HEAD** 的干净状态。

### 18. 现在，开始回退！

当你完成了与你无关的工作时，你可能会快速回退你的修改：

`alias gstp = git stash pop`

### 19. 这个小提交，看起来很棒，让我们把它放到自己的分支上！

Git 有一个叫做 **cherry-pick** 的优秀特性。你可以使用它来将任何现有提交添加到当前分支的顶部。它就像使用这个别名一样简单：

`alias gcp = git cherry-pick`

这当然会导致冲突，当然这也取决于你提交的内容。解决这个冲突与解决 rebase 冲突的方法完全一样。因此，我们也有类似的选择来中止以及继续选择分支：

`alias gcpa = git cherry-pick --abort`

`alias gcpc = git cherry-pick --continue`

* * *

以上列表肯定没有涵盖所有 git 用例。我想鼓励你把它看作是建立你自己的化名套件的良好开端。在日常工作流程中寻求可能的改进是一个好主意。

You can find all these aliases (and more!) in [my Github repository](https://github.com/mjkonarski/oh-my-git-aliases).

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
