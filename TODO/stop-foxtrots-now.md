
> * 原文地址：[Protect our Git Repos, Stop Foxtrots Now!](https://developer.atlassian.com/blog/2016/04/stop-foxtrots-now/)
> * 原文作者：[Sylvie Davies](https://developer.atlassian.com/blog/authors/sdavies)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/stop-foxtrots-now.md](https://github.com/xitu/gold-miner/blob/master/TODO/stop-foxtrots-now.md)
> * 译者：[LeviDing](https://github.com/leviding)
> * 校对者：[薛定谔的猫](https://github.com/Aladdin-ADD)、[luisliuchao](https://github.com/luisliuchao)

# 保护我们的 Git Repos，立刻停止“狐步舞”

![狐步舞舞者](https://developer.atlassian.com/blog/2016/04/stop-foxtrots-now/01-dance.jpg)

舞者们正准备跳狐步舞。

### 首先，什么是“狐步舞”式的合并？

“狐步舞”式的合并是 `git commit` 的一个特别不好的具体顺序。如同在户外看到的“狐步舞”，这种 commits 序列像这个样子：

![“狐步舞”式的合并](https://developer.atlassian.com/blog/2016/04/stop-foxtrots-now/02-foxtrot.png)

但在公开场合很少会见到“狐步舞”。它们隐藏在树冠之间，树枝之间。我称它们“狐步舞”式，是因为他们交叉的样子，他们看起来像同步舞蹈的舞步顺序：

![狐步示意图](https://developer.atlassian.com/blog/2016/04/stop-foxtrots-now/foxtrot-redrawn.png)

还有一些人也提到“狐步舞”式的合并，但它们从来没有直接说出它的名字。例如，Junio C. Hamano 的博客有[有趣的 `--first-parent`](http://git-blame.blogspot.ca/2012/03/fun-with-first-parent.html)，还有[有趣的非快进方式（Non-Fast-Forward）](http://git-blame.blogspot.ca/2015/03/fun-with-non-fast-forward.html)。David Lowe 的 nestoria.com 有关于[保持一致的线性历史记录](http://devblog.nestoria.com/post/98892582763/maintaining-a-consistent-linear-history-for-git)的文章。此外还有[一](http://longair.net/blog/2009/04/16/git-fetch-and-merge/)[大](http://kernowsoul.com/blog/2012/06/20/4-ways-to-avoid-merge-commits-in-git/)[堆](https://randyfay.com/content/simpler-rebasing-avoiding-unintentional-merge-commits)[人](https://adamcod.es/2014/12/10/git-pull-correct-workflow.html)告诉你要避免使用 `git pull`，而是使用 `git pull –rebase`。为什么？主要是为了避免一般的合并和提交时的错误，此外还可以避免出现该死的“狐步舞”式的提交。

“狐步舞”式的合并真的很不好吗？是的。

![水母](https://developer.atlassian.com/blog/2016/04/stop-foxtrots-now/04-jelly.jpg)

它们显然不如僧帽水母那样糟糕。但是“狐步舞”式的合并也是不好的，你不希望你的 git 仓库里有它们的身影。

### “狐步舞”式的合并为什么不好？

“狐步舞”式的合并不好，因为它会改变 `origin/master` 分支的“第一父级”的地位。

合并提交记录的父级是有序的。第一个父级是 `HEAD`。第二个父级是用 `git merge` 命令提交的。

你可以像下面这样想：

```bash
git checkout 1st-parent
git merge 2nd-parent
```

如果你是 [octopus 的说客](http://marc.info/?l=linux-kernel&amp;m=139033182525831):

```bash
git merge 2nd-parent 3rd-parent 4th-parent ... 8th-parent etc...
```

这意味着父级的记录就像它听起来一样。当你提交新的代码的时候，忽略第一个父级以外的父级，从而得到一个新的代码记录。对于常规的 `commit`（非 `merge`），第一个父级是唯一的父级，并且对于 `merge` 来说，它是你在输入 `git merge` 时所产生的记录。这种父级概念是直接植入到 Git 里的，并且在很多命令行中都有所体现，例如，`git log –first-parent`。

“狐步舞”式的合并问题在于，它使得 *origin/master* 由第一父级变成了第二父级。

除了 Git 在评估提交是否有资格进行 `fast-forward` 时，Git 并不关心父级的先后次序。

当然你很不希望这样。你不希望“狐步舞”式的合并通过 `fast-forward` 的方式更新你的 *origin/master*，使得 *origin/master* 第一父级的地位不稳定。

看一下当“狐步舞”式的合并被 `push` 上去的时候会发生什么：

![“狐步舞”式的合并被 `push`](https://developer.atlassian.com/blog/2016/04/stop-foxtrots-now/05-foxtrot-pushed.png)

可以使用手指从 *origin/master* 开始沿着图形往下，在每个分叉的地方选择左边的分支，从而知道当前的第一父级的变更历史。

问题是，最初的第一个父级提交次序（从 *origin/master* 开始）是这样的：

B, A.

但是当“狐步舞”式的合并被 `push` 之后，父级的次序变成这样了：

D, C, A.

这时，B 节点已从 *origin/master* 第一父级中消失，事实上，B在它的第二父级上。当然，不会有任何资料的丢失，并且 B 节点仍然是 *origin/master* 的一部分。

但是，这样父级节点就会有错综复杂的关系。你是否知道，`tilda` 符号（例如 `~N`）指定从第 N 个提交的节点到第一个父节点间的路径？

你有没有想要看看你的分支上的每个提交记录之间的差异，但是使用 `git log -p` 显然会漏掉一些信息，使用 `git log -p -m` 能获取更多的信息吗？

尝试使用 `git log -p -m –first-parent` 吧。

你想过要还原一个合并的分支吗？那你需要为 `git revert` 提供 `-m parent-number` 选项，这时候你就很不希望自己提供的 `parent-number` 是错的。

和我一起工作的人，大多数都将第一个父级作为真正的 `master` 分支。有意识或无意识地，人们将 `git log –first-parent origin/master` 视为重要事物的顺序。 至于任何其他合并进来的分支？嗯，你应该知道他们会怎么说：

![topic](https://developer.atlassian.com/blog/2016/04/stop-foxtrots-now/06-what-happens-in-topic.jpg)

但是“狐步舞”式的合并把这些都混在了一起。请考虑下面的例子，其中 *origin/master* 分支的一系列的重要提交信息，与你自己的稍微不那么重要的提交并行：

![topic escaped](https://developer.atlassian.com/blog/2016/04/stop-foxtrots-now/07a-topic-branch-escape.png)

现在，你终于准备把你的工作并入到 `master` 中。你输入 `git pull`，或者可能你在一个主题分支上使用 `git merge master` 命令。那这样发生了什么？一个“狐步舞”式的合并就这么出现了。

![topic escaped b](https://developer.atlassian.com/blog/2016/04/stop-foxtrots-now/07b-topic-branch-escape.png)

一切都没有什么大问题，除了当你键入 `git push`，让你的远程仓库接受它时，你的历史记录看起来像这样：

![topic escaped c](https://developer.atlassian.com/blog/2016/04/stop-foxtrots-now/07c-topic-branch-escape.png)

![topic escaped lego](https://developer.atlassian.com/blog/2016/04/stop-foxtrots-now/08-lego-topic-branch-escaped.jpg)

### 对于已经混入了“狐步舞”式的合并的 git 项目应该怎么做？

啥招都没有，随它们去吧。除非你重写 master 分支的历史而惹怒其他人，那么就去这么疯吧。

事实上，[不要这样做。](https://www.atlassian.com/git/tutorials/merging-vs-rebasing/the-golden-rule-of-rebasing/)

### 如何防止未来“狐步舞”式的合并出现在我的 git 项目中？

这有几个方法。我最喜欢的的方式是下面的四步：

1. 为你的团队安装 Atlassian Bitbucket 服务器。

2. 安装我为 Bitbucket 服务器写的插件，名字叫“Bit Booster Commit Graph and More”。
你可以在下面的链接中找到他们：[https://marketplace.atlassian.com/plugins/com.bit-booster.bb](https://marketplace.atlassian.com/plugins/com.bit-booster.bb)[https://marketplace.atlassian.com/plugins/com.bit-booster.bb](https://marketplace.atlassian.com/plugins/com.bit-booster.bb)

3. 在你所有项目中，都点击 “Protect First Parent Hook” 上的 “Enabled” 按钮，也就是“启用”按钮：

![hook enabled](https://developer.atlassian.com/blog/2016/04/stop-foxtrots-now/09-hook-enabled.png)

4. 你可以在试用许可结束前免费使用31天。（感觉它好用的话，可以在试用期后进行购买）。

这是我最喜欢的方式，因为它杜绝了“狐步舞”的出现。每当有一个“狐步舞”式的合并被阻挡时，它会打印一只牛：

``` bash
$ git commit -m 'my commit'
$ git pull
$ git push

remote:  _____________________________________________
remote: /                                             \
remote: | Moo! Your bit-booster license has expired!  |
remote: \                                             /
remote:  ---------------------------------------------
remote:         \   ^__^
remote:          \  (oo)\_______
remote:             (__)\       )\/\
remote:                 ||----w |
remote:                 ||     ||
remote:
remote: *** PUSH REJECTED BY Protect-First-Parent HOOK ***
remote:
remote: Merge [da75830d94f5] is not allowed. *Current* master
remote: must appear in the 'first-parent' position of the
remote: subsequent commit.
```

还有其他的方法。你可以禁止直接向 *master* 分支进行推送，并保证不在 `fast-forward` 的情况下合并 `pull-requests`。或者培训你的员工使用 `git pull –rebase` 命令，并且永远不要使用 `git merge master`。并且一旦你培训完你的员工，就不要再招聘其他员工了。

如果你可以直接访问远程仓库，则可以设置 `pre-receive hook`。 以下的 `bash` 脚本可以帮助你开始这项设置：

```bash
#/bin/bash

# Copyright (c) 2016 G. Sylvie Davies. http://bit-booster.com/
# Copyright (c) 2016 torek. http://stackoverflow.com/users/1256452/torek
# License: MIT license. https://opensource.org/licenses/MIT
while read oldrev newrev refname
do
if [ "$refname" = "refs/heads/master" ]; then
   MATCH=`git log --first-parent --pretty='%H %P' $oldrev..$newrev |
     grep $oldrev |
     awk '{ print \$2 }'`

   if [ "$oldrev" = "$MATCH" ]; then
     exit 0
   else
     echo "*** PUSH REJECTED! FOXTROT MERGE BLOCKED!!! ***"
     exit 1
   fi
fi
done
```

### 我不小心创建了一个“狐步舞”式的合并，但我还没有 `push` 上去。我该怎么解决？

假设你安装了预先接收的钩子，并且阻止你“狐步舞”式的合并。你下一步做什么？你有三种可能的补救办法：

1. 普通的 `rebase`：

![使用 `rebase` 进行补救](https://developer.atlassian.com/blog/2016/04/stop-foxtrots-now/10-remedy-rebase.png)

2. 撤销你之前的合并，使你的 *origin/master* 分支成为第一父级：

![撤销 merge](https://developer.atlassian.com/blog/2016/04/stop-foxtrots-now/11-remedy-reverse-merge.png)

3. 在“狐步舞”式的合并后创建第二个合并并提交，以恢复 *origin/master* 的第一父级的地位。

![补救](https://developer.atlassian.com/blog/2016/04/stop-foxtrots-now/12-remedy-man-o-war.png)

但请不要使用上面的第三种方法，因为最后的结果被称为“僧帽水母”式的合并，这种合并甚至比“狐步舞”式的合并更糟糕。

### 总结

在最后，其实“狐步舞”式的合并也像其他的合并那样。两个（或多个）提交到一起融合成一个新的记录节点。就你的代码库而言，没有任何区别。无论 commit A 合并到 commit B 中还是反过来 commit B 合并到 commit A，从代码的角度来看最终结果是相同的。

但是，当涉及到你的仓库的历史记录时，以及有效地使用 git 工具集时，“狐步舞”式的合并会有一定的破坏性。通过设置相应的策略来防止其出现，可以使你仓库的历史记录更加清晰明了，并减少了需要记住的 git 命令选项的范围。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
