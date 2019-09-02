> * 原文地址：[Learn git concepts, not commands- Part 3](https://dev.to/unseenwizzard/learn-git-concepts-not-commands-4gjc)
> * 原文作者：[Nico Riedmann](https://dev.to/unseenwizzard)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/learn-git-concepts-not-commands-3.md](https://github.com/xitu/gold-miner/blob/master/TODO1/learn-git-concepts-not-commands-3.md)
> * 译者：[Sam](https://github.com/xutaogit)
> * 校对者：[40m41h42t](https://github.com/40m41h42t)，[子非](https://github.com/CoolRice)

# Git：透过命令学概念 —— 第三部分

**用交互式的教程教你 Git 的原理，而非罗列常用命令。**

所以，你想正确地使用 Git 吗？

但你肯定不想仅仅学一些操作命令，你还想要理解其背后的原理，对吧？

那么本文就是为你量身定做的！

让我们快点开动吧！

---

> 本文的落笔点基于 Rachel M. Carmena 撰写的 [**如何教授 Git**](https://rachelcarmena.github.io/2018/12/12/how-to-teach-git.html) 一文中提及的常规概念。
>
> 网上有很多重方法轻原理的 Git 教程，但我还是挖掘到了兼得二者的宝贵资源（也是本教程的灵感源泉），那就是 [*git Book*](https://git-scm.com/book/en/v2) 和 [*Reference page*](https://git-scm.com/docs)。
>
> 因此，如果你读完了本文还意犹未尽，就快点击上面两个链接一探究竟吧！我真心希望本教程中介绍的概念，能帮你理解另外两篇文章中详解的其他 Git 功能。

建议按照顺序阅读本系列文章：

- [Git：透过命令学概念 —— 第一部分](https://github.com/xitu/gold-miner/blob/master/TODO1/learn-git-concepts-not-commands-1.md)
- [Git：透过命令学概念 —— 第二部分](https://github.com/xitu/gold-miner/blob/master/TODO1/learn-git-concepts-not-commands-2.md)
- [Git：透过命令学概念 —— 第三部分](https://github.com/xitu/gold-miner/blob/master/TODO1/learn-git-concepts-not-commands-3.md)

---

* [精心挑选](#cherry-picking-精心挑选)
* [重写历史](#rewriting-history-重写历史)
* [查看历史](#reading-history-查看历史)

---

## 精心挑选

> 恭喜！你现在已经知道了更多的高级功能！
>
> 到目前为止你知道如何使用所有典型的 git 命令，更重要的是你还了解它们是如何工作的。
>
> 比起我只告诉你输入什么命令，这些（之前了解的高级功能）将有助于帮你更容易理解接下来的概念。
>
> 所以让我们立即学习如何使用`挑选（cherry-pick）`命令！

基于之前的章节你应该还大致记得 `提交（commit）` 命令是如何执行的，对吧？

以及如何在对分支进行 [`rebase`](#rebasing) （变基）的时候，把你的提交应用成为具有相同**更改集**和**提交消息**的新提交？

有时你只想从一个分支上获取一些改动并应用到另一个分支上，（比如）你希望通过`挑选`命令把一些改动拉取到你自己的分支上。

这正是 `git cherry-pick` 命令允许你使用单个或一组提交要做的事。

就像在`变基`命令执行过程中一样，它实际上会将这些提交的更改放置到你当前分支上的新提交中。

让我们看一个例子，分别用于`挑选`一个或多个提交：

下图显示的是在我们执行任何操作之前存在的三个分支。假设我们现在就想要从 `add_patrick` 分支获取一些变更放置到 `change_alice` 分支里。遗憾的是现在它们（译者注： `add_patrick` 分支上的变更）并没有合到 master 主干上，所以我们不能仅通过在 master 主干上使用`变基`命令获取这些变更（因为我们可能获取到其他分支上我们不想要的变更）。

[![Branches before cherry-picking](https://res.cloudinary.com/practicaldev/image/fetch/s--DcmKB8P2--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://raw.githubusercontent.com/UnseenWizzard/git_training/master/img/cherry_branches.png)](https://res.cloudinary.com/practicaldev/image/fetch/s--DcmKB8P2--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://raw.githubusercontent.com/UnseenWizzard/git_training/master/img/cherry_branches.png)

所以，让我们使用 `git cherry-pick` 命令定位到 **63fc421** 这个提交。

下图可视化地表现了当我们运行 `git cheery-pick 63fc421` 命令时发生了什么：

[![Cherry-picking a single commit](https://res.cloudinary.com/practicaldev/image/fetch/s--3eCyc1bO--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://raw.githubusercontent.com/UnseenWizzard/git_training/master/img/cherry_pick.png)](https://res.cloudinary.com/practicaldev/image/fetch/s--3eCyc1bO--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://raw.githubusercontent.com/UnseenWizzard/git_training/master/img/cherry_pick.png)

你可以看到，带有我们想要变更的一个新提交出现在分支上。

> 此时请注意，与我们之前见过的任何其他方式获取变更到分支上的情况一样，在命令顺利运行之前，任何在执行`挑选`命令期间出现的冲突都需要我们**自己解决**。
>
> 同样和其他所有命令一样，当你解决完冲突后可以使用 `cherry-pick --continue` 命令继续或使用 `--abort` 命令结束所有操作。

下图展示了使用`挑选`命令选取一组提交而不是单个提交。你可以通过调用 `git cherry-pick <from>..<to>` 形式的命令做到这一点，或者像我们下面的例子一样使用 `git cherry-pick 0cfc1d2..41fbfa7`。

[![Cherry-picking commit range](https://res.cloudinary.com/practicaldev/image/fetch/s--_-UHvfoF--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://raw.githubusercontent.com/UnseenWizzard/git_training/master/img/cherry_pick_range.png)](https://res.cloudinary.com/practicaldev/image/fetch/s--_-UHvfoF--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://raw.githubusercontent.com/UnseenWizzard/git_training/master/img/cherry_pick_range.png)

## 重写历史

> 我又要再问一遍，你确定还记得 [`变基`](#rebasing) 命令是如何运作的对吧？或许在继续开始之前，你快速跳回到那个章节看看，因为我们将要使用已经掌握的知识学习如何改变历史！

如你所知，`提交` 命令通常包含了分支的变更内容，变更描述和其他一些信息。

一条分支的“历史”是由它的提交构成的。

我们假设你刚完成了一个`提交`，然后发现少提交了文件，或者你有一个拼写导致的代码错误。

简要来说可以做两件事修复这个问题，并且让这个错误看起来像从未发生过一样。

让我们使用 `git checkout -b rewrite_history` 命令切换到一个新分支。

现在我们在 `Alice.txt` 和 `Bob.txt` 文件上都做一些修改，然后执行 `git add Alice.txt`。

之后使用 “This is history” 作为描述信息运行 `git commit`，结束操作。

等等，我们做完了吗？不，你会清楚地看到我们在这里犯了一些错误：

- 我们忘记添加变更到 `Bob.txt` 文件里
- 我们没有撰写一个[良好的提交描述信息](https://chris.beams.io/posts/git-commit/)

### 修正最后一次提交

解决这两个问题的一种方式是使用 `amend（修正）` 命令修正我们刚做的提交。

从根本上来说，修正最近一次提交就像是重做了一次新的提交。

在开始之前，使用 `git show {COMMIT}` 命令查看你的最近一次提交。可以使用缓存里已有的 `{COMMIT}`（你也许还能再从命令行 `git commit` 里看到，或者通过 `git log` 命令看到），或者直接用 **HEAD**（译者注：`git show HEAD`）。

就像在 `git log` 命令里一样，你将看到提交信息，作者、日期和修改记录信息。

现在让我们`修正`在提交里所做的一切。

使用 `git add Bob.txt` 往**暂存区域**里添加修改，然后执行 `git commit --amend` 命令。

接下来你最近的一次提交会被展开，**暂存区域**里的新变更会被添加到接下来的一个提交里，填写提交信息的编辑器会打开。

在编辑器里你将看到先前的提交信息。

随意填写修改成更好的提交信息。

操作完成后，使用 `git show HEAD` 命令再看看最近的这次提交。

就像你期望的一样，提交的缓存记录有变化。先前的提交不见了，取而代之的是一个结合了新变更的新提交。

> 请注意相比于之前的提交，诸如作者（author）和日期（date）这样的提交数据并没有发生变化。你可能会混淆这些信息，如果你愿意，可以在修正的时候使用额外的 `--author={AUTHOR}` 和 `--date={DATE}` 参数进行修改。

恭喜！你已经成功地完成了第一次重写历史记录的操作！

### 交互式变基（Rebase）

通常当我们使用 `git rebase` 命令时，我们是在分支上`变基`的。比如我们使用 `git rebase origin/master` 做某些操作，实际上发生的事，是我们在分支的 **HEAD** 上做了变基操作。

事实上只要我们喜欢，可以在任何提交上使用`变基`命令。

> 请记住，提交包含了有关它前面的历史记录信息。

和很多其他命令一样，`git rebase` 命令有一种**交互**模式。

和大多数命令不一样的地方在于，你可能会使用很多次**交互式**`变基`命令，因为它可以让你根据需要任意次数地更改历史记录。

特别是你在当前工作流的变更中做了很多细小的提交，且这些提交很容易让你犯错从而导致返工的时候，**交互式**`变基`将会成为你的利器。

**说得够多了！来点实际操作！**

切回到 **master** 分支上，然后使用 `git checkout` 命令切出一个新的工作分支。

和之前一样，我们将在 `Alice.txt` 和 `Bob.txt` 文件里做一些修改，然后执行 `git add Alice.txt` 命令。

然后在执行 `git commit` 命令时填写像 “向 Alice 里添加内容” 这样的信息

现在不去修改提交，我们还将执行 `git add Bob.txt` 和 `git commit` 命令。提交信息写的是“添加 Bob.txt 文件”。

为了让例子更有意思，我们再在 `Alice.txt` 上做修改，然后执行 `git add` 和 `git commit` 命令。提交信息填写的是“向 Alice 文件里添加更多内容”。

如果我们现在使用 `git log` 命令查看分支的历史记录（或者只是优先使用 `git log --oneline` 命令快速看一下），我们将看到刚才的三个提交在你 **master** 分支的任何内容之上。

内容看起来会是这样：

```
git log --oneline
0b22064 (HEAD -> interactiveRebase) Add more text to Alice
062ef13 Add Bob.txt
9e06fca Add text to Alice
df3ad1d (origin/master, origin/HEAD, master) Add Alice
800a947 Add Tutorial Text
```

关于这一点，我们有两件事需要解决，为了学习不同的东西，解决方案有别于之前 `amend（修正）` 章节的内容。

* 把关于 `Alice.txt` 文件相关的所有变更包含在单个提交里
* 统一命名规范，从关于 `Bob.txt` 的提交信息里移除 **.txt**

为了改变这三次新提交，我们希望变基到这三次提交之前的地方。提交 id 是 `df3ad1d`，或者我们也可以从当前 **HEAD** 处使用 `HEAD~3` 引用达到相同目的。

我们使用 `git rebase -i {COMMIT}` 开始**交互式**`变基（rebase）`，即运行 `git rebase -i HEAD~3` 命令。

你将在你的编辑器里看到一些像这样的选择信息：

```
pick 9e06fca Add text to Alice
pick 062ef13 Add Bob.txt
pick 0b22064 Add more text to Alice
# Rebase df3ad1d..0b22064 onto df3ad1d (3 commands)
#
# Commands:
# p, pick = use commit
# r, reword = use commit, but edit the commit message
# e, edit = use commit, but stop for amending
# s, squash = use commit, but meld into previous commit
# f, fixup = like "squash", but discard this commit's log message
# x, exec = run command (the rest of the line) using shell
# d, drop = remove commit
#
# These lines can be re-ordered; they are executed from top to bottom.
#
# If you remove a line here THAT COMMIT WILL BE LOST.
#
# However, if you remove everything, the rebase will be aborted.
#
# Note that empty commits are commented out
```

还是注意你在调用命令时， `git` 是如何解释你能做的任何事情。

你最有可能使用的 **Commands** 命令将会是 `reword`、`squash` 和 `drop`（还有 `pick`，但这个是默认的）。

花点时间分析你所看到的，并考虑我们可以使用上面什么内容达成我们的两个目的。我等你。

有对策了？非常棒！

在我们开始做修改之前，留意一件事实，即提交的记录是从最旧的到最新的罗列，而 `git log` 命令的输出则正好相反的。

我将开始做一些简单的变更，然后针对一些中间的提交做一些提交信息的修改。

```
pick 9e06fca Add text to Alice
reword 062ef13 Add Bob.txt
pick 0b22064 Add more text to Alice
# Rebase df3ad1d..0b22064 onto df3ad1d (3 commands)
[...]
```

现在把关于 `Alice.txt` 文件相关的两个变更并入到一个提交里。

很显然的是我们想把后一个变更的内容 `squash（压缩）`到前一个里面去，因此让我们把这个命令放在改变 `Alice.txt` 的第二次提交的 `pick` 上。在这个例子上是 **0b22064**。

```
pick 9e06fca Add text to Alice
reword 062ef13 Add Bob.txt
squash 0b22064 Add more text to Alice
# Rebase df3ad1d..0b22064 onto df3ad1d (3 commands)
[...]
```

我们操作结束了吗？像刚才那样做能得到我们想要的吗？

不能对吧？就像文件里注解告诉我们的一样：

```
# s, squash = use commit, but meld into previous commit
```

所以就我们目前所做的，将会合并 Alice 文件的第二次变更提交和 Bob 文件的提交内容。然而这并不是我们想要的。

我们在**交互式**`变基`里能做的另一项给力的事情是篡改提交的顺序。

假如你有仔细阅读注解里的内容，你应该已经知道怎么做了：简单地移动行就行了。

得利于你用了自己最喜欢的文档编辑器，你直接把关于 Alice 文件的第二次提交放置到第一次之后。

```
pick 9e06fca Add text to Alice
squash 0b22064 Add more text to Alice
reword 062ef13 Add Bob.txt
# Rebase df3ad1d..0b22064 onto df3ad1d (3 commands)
[...]
```

这些操作会有意想不到的效果，关闭编辑器通知 `git` 去开始执行这些命令。

接下来发生的就像通常的`变基`命令一样：从启动时引用的提交开始，你所有罗列的每个提交都会一个一个被应用。

> 现在它可能不会发生，但当你在 `rebase` 期间遇到冲突，重新排列实际代码变更时，它就有可能发生。毕竟你有可能会混淆已经建立在彼此间的变化。
>
> 就像你通常做的那样，[解决](#resolving-conflicts)它们就好了。

在应用完第一次提交之后，编辑器将会打开便于你为合并修改到 `Alice.txt` 文件里填写一个新的提交信息。我移除了所有提交的文本然后填写上“给 Alice 文件添加很多非常重要的信息”。

在你完成刚才那次提交关闭编辑器之后，编辑器会再次打开让你填写关于 `Add Bob.txt` 命令的变更信息。那么移除 “.txt” 内容然后关闭编辑器就好了。

就这样！你已经重写了历史记录。而且这次比使用 `amend（修正）` 的时候更加稳固。

如果你再运行一下 `git log` 命令，你将看到有两个新的提交替换了我们先前做的三个提交。但到目前为止，你因为习惯了`变基`命令提交的东西，所以应该已经料想到这些内容。

```
git log --oneline
105177b (HEAD -> interactiveRebase) Add Bob
ed78fa1 Add a lot very important text to Alice
df3ad1d (origin/master, origin/HEAD, master) Add Alice
800a947 Add Tutorial Text
```

### 公共历史记录，为什么你不应该修改它，以及如何以安全的方式修改它

如前所述，在工作时进行的涵盖了大小型提交操作的任何工作流里，变更历史记录都是非常有用的内容。

虽然所有小的原子性修改让你很容易进行操作，比如验证每次你做的修改能否通过测试，假如不能，删除或者修改这些特定的更改就行，但你在 `HelloWorld.java` 文件里做的 100 次提交可能都不是你想要与他人分享的内容。

你最可能想要与他们分享的情况是，你写了一些结构良好的变更，提交不错的描述消息告诉你的同事你为什么这么做以及做了什么。

只要这些小的提交都只存在于你的 **开发环境** 中，你就完全可以执行 `git rebase -i` 把历史记录变更到你的主内容里。

当改变**公共历史记录**时会出现问题。因为它意味着变更任何已经进入到**远程仓库**的东西。

基于这点，把公共历史记录变成 `public` 的，而其他人的分支都是基于这个公共的记录。通常这样就不会让你混淆它们。

通常的建议是“绝不改写公共历史记录！”，而且我在这里重申一遍，但不得不承认，仍然有一些合理的场景里需要去重写**公共历史记录**。

然而这些合理场合里的历史记录并不是“真正的”**公共**记录。你肯定不会想着去改写开源仓库里 **master** 分支上的记录，或者你公司**发布版本**分支的内容。

你想要修改的是那些你已经 `push（推送）` 了，并且分享给其他同事的分支的记录。

你可能正在进行基于主干的开发，但想分享一些甚至还没有编译的东西，所以你显然不想故意将它放在主分支上。

或者你可能有一个工作流程，用在你的分享特性分支里。

特别是对于功能分支，你希望经常把它们`变基`到当前`主干`分支上。但正如我们所知，`git rebase` 命令会将我们分支的提交作为**新的**提交放到我们基于的分支上。这就改写了历史记录。而且在共享特性分支的情况下，它会改写**公共历史记录**。

因此如果要遵循“绝不重写公共历史记录”的口号我们该怎么做？

从开始到最后都不变基分支，还希望它能最后合并进**主干**分支？

还是不再使用共享的特性分支？

诚然第二个确实是一个比较合理的回答，但你仍然有可能做不到那样。因此你唯一能做的是，接受重写**公共历史记录**，然后把变更记录`推送`到**远端仓库**。

如果你仅仅使用 `git push` 命令会发现你不被允许这样做，因为你的**本地**分支已经和**远程**分支是分离的。

你将需要使用 `force（强制）` 推送变更，并且使用本地的版本重写远端的内容。

基于我已经特别的暗示说明，你现在可能准备尝试执行 `git push --force` 命令。但如果你想要安全地改写**公共历史记录**的话，你真的不应该这样做。

使用 `--force` 更谨慎的兄弟命令 `--force-with-lease`，会好很多！

`--force-with-lease` 命令将在推送之前检查你的**本地**版本的**远程**分支和实际**远程**分支的内容匹配。

通过这种方式，你可以确保在重写历史记录时不会意外擦除其他人可能的推送的任何变更信息！

[![What happens in a push --force-with-lease](https://res.cloudinary.com/practicaldev/image/fetch/s--K0b0QO_X--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://raw.githubusercontent.com/UnseenWizzard/git_training/master/img/force_push.png)](https://res.cloudinary.com/practicaldev/image/fetch/s--K0b0QO_X--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://raw.githubusercontent.com/UnseenWizzard/git_training/master/img/force_push.png)

基于这里提及的内容，我将给你一个稍微变化了的口号：

**除非你真的明确你所做的操作，否则不要重写公共历史记录。假如你要这么做，也要使用 force-with-lease 的安全模式重写。**

## 阅读历史记录

在了解**开发环境** —— 尤其是**本地仓库**中区域之间的提交和历史记录工作方式差异后，你应该不会再害怕执行`变基`操作了。

但仍有些时候会出问题。你很可能做了一次`变基`操作后意外地发现当你解决一个冲突的时候得到了一个错误版本的文件。

现在，文件里只有你同事添加的日志记录，而没有你添加的功能。

幸好 `git` 为你留了后路，它内置一个安全的功能，叫做**参考日志**又称 `reflog`。

每当在**本地仓库**中更新任何类似分支末端的引用时，都会添加引用日志条目。

所以不仅存在着你任何时候`提交`的记录，而且还记录了你什么时候执行 `reset` 或者切换到 `HEAD` 节点等信息。

教程读到这里，你已经知道当我们弄混了一个`变基`的时候，该如何很好的使用上述信息处理问题，对吗？

我们知道，一个`变基`将我们分支的 `HEAD` 移动到我们基于它的点，并应用我们的更改。 交互式`变基`的工作方式类似，但可能会对诸如**压缩**或**重写**它们之类的提交做些事情。

如果你现在不在我们练习[交互式变基](#interactive-rebase)内容时的分支上，再次切换过去，我们将做更多的练习。

让我们看下在这个分支上所作的`参考日志（reflog）` —— 你可能猜到了 —— 执行 `git reflog` 命令。

你可能会看到很多输出，但顶部的几行内容也行会像下面这样：

```
git reflog
105177b (HEAD -> interactiveRebase) HEAD@{0}: rebase -i (finish): returning to refs/heads/interactiveRebase
105177b (HEAD -> interactiveRebase) HEAD@{1}: rebase -i (reword): Add Bob
ed78fa1 HEAD@{2}: rebase -i (squash): Add a lot very important text to Alice
9e06fca HEAD@{3}: rebase -i (start): checkout HEAD~3
0b22064 HEAD@{4}: commit: Add more text to Alice
062ef13 HEAD@{5}: commit: Add Bob.txt
9e06fca HEAD@{6}: commit: Add text to Alice
df3ad1d (origin/master, origin/HEAD, master) HEAD@{7}: checkout: moving from master to interactiveRebase
```

这里就可以看到，我们所作的每个单一的操作，从切换分支到执行`变基`都记录在案。

很高兴能看到我们已完成的事情，因为它自己（reflog）是每行以引用作为开头的，不然我们搞砸了某些地方就都没用了。

当我们比较`reflog（参考日志）`和之前看到的`log（日志）`命令输出时，你会发现`参考日志`的那些记录关联的是提交引用，我们同样可以像之前`日志`中那样使用它们。

假设我们真的不想执行变基操作。我们如何解除已经作出的变更呢？

使用 `git reset 0b22064` 命令将 `HEAD` 移置`变基`开始之前。

> 在这个例子里 `0b22064` 是早于`变基`的提交。更通常的说法是，也可以通过 `HEAD{4}` 将它作为 **HEAD 四次变化前**的引用。请注意，如果你在此其间切换了分支或执行了创建日志条目的任何其他操作，那么你可能会需要更高的数字。

如果你再执行`日志`命令查看，你将看到恢复了三次单独提交内容的原始状态。

我们发现现在的内容不是我们想要的。`变基`操作的内容挺好的，我们只是不想要改变了 Bob 文件信息的提交。

我们可以在当前状态上执行另一个 `rebase -i` 命令，就像先前做的那样。

或者我们可以借助`参考日志`跳回到变基之后，然后从那里使用 `amend` 修正提交。

至此两种方法你都知道怎么做了，所以我会让你自己亲自试一试。此外你还应该知道借助 `reflog` 命令可以让你在犯了错误之后回退很多内容。

欢迎继续阅读本系列其他文章：

- [Git：透过命令学概念 —— 第一部分](https://github.com/xitu/gold-miner/blob/master/TODO1/learn-git-concepts-not-commands-1.md)
- [Git：透过命令学概念 —— 第二部分](https://github.com/xitu/gold-miner/blob/master/TODO1/learn-git-concepts-not-commands-2.md)
- [Git：透过命令学概念 —— 第三部分](https://github.com/xitu/gold-miner/blob/master/TODO1/learn-git-concepts-not-commands-3.md)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
