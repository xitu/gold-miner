> * 原文地址：[Learn git concepts, not commands - Part 1](https://dev.to/unseenwizzard/learn-git-concepts-not-commands-4gjc)
> * 原文作者：[Nico Riedmann](https://dev.to/unseenwizzard)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/learn-git-concepts-not-commands-1.md](https://github.com/xitu/gold-miner/blob/master/TODO1/learn-git-concepts-not-commands-1.md)
> * 译者：[Baddyo](https://juejin.im/user/5b0f6d4b6fb9a009e405dda1)
> * 校对者：[Usey95](https://github.com/Usey95)，[ZavierTang](https://github.com/ZavierTang)

# Git：透过命令学概念 —— 第一部分

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

---

- [概览](#user-content-概览)
- [获取远程仓库](#user-content-获取远程仓库)
- [添加新文件](#user-content-添加新文件)
- [更改](#user-content-更改)
- [分支](#user-content-分支)

---

## 概览

下图中有四个盒子。其中一个盒子独占一隅；其他三个盒子并为一组，这三个盒子构成了**开发环境（Development Environment）**。

[![Git 组成](https://res.cloudinary.com/practicaldev/image/fetch/s--jSuilYlA--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://raw.githubusercontent.com/UnseenWizzard/git_training/master/img/components.png)](https://res.cloudinary.com/practicaldev/image/fetch/s--jSuilYlA--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://raw.githubusercontent.com/UnseenWizzard/git_training/master/img/components.png)

先从那个单独的盒子说起。当你更新了工作内容，并想要和其他人共享你更改的内容，或者你想获取到别人更改的内容，那么**远程仓库**（Remote Repository）就是你们用来传送更改内容的地方。如果你已经用过其他的版本控制系统了，那这种流程对你来说一点都不陌生。

相对于**远程仓库**（Remote Repository），**开发环境**（Development Environment）则是你的本地仓库。
开发环境由三部分组成：**工作目录**（Working Directory）、**暂存区**（Staging Area）和**本地仓库**（Local Repository）。在开始使用 Git 后，我们对这几块区域的理解会逐渐加深。

在电脑中选一个地方作为**开发环境**。
在根目录或者任意你喜欢之处放置你的项目都可以。只不过不用给**开发环境**特意新建一个文件夹了。

## 获取远程仓库

现在，我们要把一个**远程仓库**的内容抓到电脑本地上。

建议使用本仓库（https://github.com/UnseenWizzard/git_training.git 如果你不是在 GitHub 上阅读本文，就点击此链接来实操）。

> 用 `git clone https://github.com/UnseenWizzard/git_training.git` 命令来实现这一步操作
> 
> 但若要跟随本教程操作，你会需要把你的更改从**开发环境**回传到**远程仓库**中，而 GitHub 不允许用户随意更改其他用户的仓库，因此你最好创建一个教程仓库的 **fork** 版本以供使用。fork 按钮在 GitHub 仓库页面的右上角。

现在你获取到了笔者的**远程仓库**的副本，接下来就把该副本拉到你的电脑中。

使用 `git clone https://github.com/{YOUR USERNAME}/git_training.git` 命令将远程仓库复制到本地。

如下图所示，该命令将**远程仓库**复制到两个地方：**工作目录**和**本地仓库**。

现在你应该明白了，这就是 Git **分布式**版本控制的原理。**本地仓库**是**远程仓库**的克隆体，毫无二致。唯一的区别就是，这个克隆体是不与其他人共享的。

`git clone` 命令的另一个作用是新建一个文件夹。在你本地会出现一个名为 `git_training` 的文件夹。打开它。

[![克隆远程仓库](https://res.cloudinary.com/practicaldev/image/fetch/s--NCZ2AIG5--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://raw.githubusercontent.com/UnseenWizzard/git_training/master/img/clone.png)](https://res.cloudinary.com/practicaldev/image/fetch/s--NCZ2AIG5--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://raw.githubusercontent.com/UnseenWizzard/git_training/master/img/clone.png)

## 添加新文件

**远程仓库**中已经有一个文件了。该文件名为 `Alice.txt`，在仓库中形单影只。我们来新建一个文件，命名为 `Bob.txt`，与 Alice 作伴。

刚才的操作是向**工作目录**中新增文件。

**工作目录**中有两种文件：**已跟踪**文件 —— 由 Git 看管着的文件，**未跟踪**文件 ——（暂时）没有被 Git 看管的文件。

运行 `git status` 命令可以查看**工作目录**中的版本状态，输出结果会告诉你目前处于哪条分支，**本地仓库**是否与**远程仓库**同步，以及哪些文件分别处于**已跟踪**（tracked）状态和**未跟踪**（untracked）状态。

你会看到，`Bob.txt` 处于未跟踪状态，`git status` 命令甚至会告诉你如何改变文件状态。

如下图所示，当你按照提示执行 `git add Bob.txt` 命令后，`Bob.txt` 文件会被加入到**暂存区**。**暂存区**中收集了所有你希望加入到**仓库**中的更改。

[![把更改添加到暂存区](https://res.cloudinary.com/practicaldev/image/fetch/s--LVFHwLca--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://raw.githubusercontent.com/UnseenWizzard/git_training/master/img/add.png)](https://res.cloudinary.com/practicaldev/image/fetch/s--LVFHwLca--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://raw.githubusercontent.com/UnseenWizzard/git_training/master/img/add.png)

当把所有更改（目前只有 Bob.txt）都添加进暂存区，你就可以把更改**提交**（commit）到**本地仓库**了。

你所**提交**的更改是一些有特定含义的工作内容，因此当运行了 `git commit` 后，你需要在自动打开的文本编辑器中写下你的更改说明。保存并关闭文本编辑器后，你的**提交内容**就被添加到**本地仓库**中了。

[![提交到本地仓库](https://res.cloudinary.com/practicaldev/image/fetch/s--we00N_rB--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://raw.githubusercontent.com/UnseenWizzard/git_training/master/img/commit.png)](https://res.cloudinary.com/practicaldev/image/fetch/s--we00N_rB--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://raw.githubusercontent.com/UnseenWizzard/git_training/master/img/commit.png)

`git commit -m "Add Bob"` 命令让你能够直接在命令中编辑**提交说明**。但你应该养成书写[规范易读的提交说明](https://chris.beams.io/posts/git-commit/)这种良好习惯，因此不要一蹴而就，还是乖乖用文本编辑器吧。

现在，你做的更改就进入本地仓库了，本地仓库适合存储那些不需要共享或暂时还不能共享的工作内容。

那么为了把提交的更改共享到**远程仓库**，你需要`推送`（push）一下。

[![推送到远程仓库](https://res.cloudinary.com/practicaldev/image/fetch/s--XwP0hGrK--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://raw.githubusercontent.com/UnseenWizzard/git_training/master/img/push.png)](https://res.cloudinary.com/practicaldev/image/fetch/s--XwP0hGrK--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://raw.githubusercontent.com/UnseenWizzard/git_training/master/img/push.png)

运行 `git push` 命令后，更改内容就会被发送到**远程仓库**中。下图展示了`推送`后的仓库状态。

[![推送更改后的仓库状态](https://res.cloudinary.com/practicaldev/image/fetch/s--Gj_DegbP--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://raw.githubusercontent.com/UnseenWizzard/git_training/master/img/after_push.png)](https://res.cloudinary.com/practicaldev/image/fetch/s--Gj_DegbP--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://raw.githubusercontent.com/UnseenWizzard/git_training/master/img/after_push.png)

## 更改

截至目前，我们只是新增了一个文件。而版本控制更有趣的部分就是更改文件。

回过头来看 `Alice.txt` 文件。

`Alice.txt` 文件里有一些文字，而 `Bob.txt` 文件里并没有，那我们就给 `Bob.txt` 添加上 `Hi!! I'm Bob. I'm new here.` 这句话。

如果你现在再运行 `git status` 命令，你会看到 `Bob.txt` 的状态变成了**已修改**（modified）。

在此状态下，此处更改仅存在于**工作目录**中。

若想查看**工作目录**中具体的更改细节，你可以运行 `git diff` 命令，输出结果如下：

```
diff --git a/Bob.txt b/Bob.txt
index e69de29..3ed0e1b 100644
--- a/Bob.txt
+++ b/Bob.txt
@@ -0,0 +1 @@
+Hi!! I'm Bob. I'm new here.
```

照旧运行 `git add Bob.txt` 命令。显然，新的更改进入了**暂存区**。

想查看刚刚标记为`暂存`（staged）状态的更改的话，试试再运行一次 `git diff` 命令！你会发现这一次输出结果是空的。这是因为 `git diff` 命令只在**工作目录**中有效。

那么要想看到已经处于`暂存`状态的更改的内容，我们需要运行 `git diff --staged` 命令，这样才能看到上次那样的输出结果。

哎呀呀，我才发现我刚刚在『Hi』后面多加了一个感叹号。这样可不行，得再一次改动 `Bob.txt` 文件，保留一个感叹号就行了。

删掉多余的感叹号后，再运行 `git status` 命令，可以看到有两处更改，一处是**暂存**状态的添文字添加，另一处时是在工作目录中对感叹号的删除。

我们用 `git diff` 命令比较一下**工作目录**和**暂存区**中的更改，看看自从上次标记**暂存**后发生了什么变化。

```
diff --git a/Bob.txt b/Bob.txt
index 8eb57c4..3ed0e1b 100644
--- a/Bob.txt
+++ b/Bob.txt
@@ -1 +1 @@
-Hi!! I'm Bob. I'm new here.
+Hi! I'm Bob. I'm new here.
```

发生的更改正如我们所愿，接着用 `git add Bob.txt` 命令`暂存`文件当前的状态。。

现在我们可以提交刚才的更改了。这次咱们使用 `git commit -m "Add text to Bob"` 命令，因为只是做了小小的改动，写一行说明足矣。

我们知道，现在那些更改已经进入**本地仓库**了。

我们可能会想知道刚刚提交了什么更改，想知道更改前后有什么不同。

我们可以通过『比较提交』得到答案。

在 Git 中，每次提交操作都对应一个唯一的哈希值，我们可以用某个哈希值来引用对应的提交。

如果用 `git log` 命令查看一下日志，我们不单会看到一系列带**哈希值**、**作者**和**日期**的提交操作，还会看到**本地仓库**的状态和关于**远程分支**的最新本地信息。

此刻 `git log` 命令的运行结果大概如下：

```
commit 87a4ad48d55e5280aa608cd79e8bce5e13f318dc (HEAD -> master)
Author: {YOU} <{YOUR EMAIL}>
Date:   Sun Jan 27 14:02:48 2019 +0100

    Add text to Bob

commit 8af2ff2a8f7c51e2e52402ecb7332aec39ed540e (origin/master, origin/HEAD)
Author: {YOU} <{YOUR EMAIL}>
Date:   Sun Jan 27 13:35:41 2019 +0100

    Add Bob

commit 71a6a9b299b21e68f9b0c61247379432a0b6007c 
Author: UnseenWizzard <nicola.riedmann@live.de>
Date:   Fri Jan 25 20:06:57 2019 +0100

    Add Alice

commit ddb869a0c154f6798f0caae567074aecdfa58c46
Author: Nico Riedmann <UnseenWizzard@users.noreply.github.com>
Date:   Fri Jan 25 19:25:23 2019 +0100

    Add Tutorial Text

      Changes to the tutorial are all squashed into this commit on master, to keep the log free of clutter that distracts from the tutorial

      See the tutorial_wip branch for the actual commit history
```

在日志中，我们能发现几处有意思的细节：

* 前两个提交的操作人是自己。
* 最开始添加 `Bob.txt` 文件的提交是**远程仓库**中 **master** 分支的 **HEAD**。等说到分支和拉取远程更改的部分时，我们再展开探讨这个『HEAD』。
* **本地仓库**中最新的提交就是我们刚刚做的更改，而此刻我们知道了其哈希值是什么。

> 注意，你实际操作的提交的哈希值跟文中的例子是不一样的。如果你好奇 Git 是如何生成那些修改 ID 的，可以看看[这篇有趣的文章](https://blog.thoughtram.io/git/2014/11/18/the-anatomy-of-a-git-commit.html)。

我们可以通过 `git diff <commit>^!` 命令来比较这先后两次提交，命令中的 `^!` 告诉 Git 要比较的是指定哈希值的提交和它上一次的提交。那么我这里就是运行 `git diff 87a4ad48d55e5280aa608cd79e8bce5e13f318dc^!` 这样的命令。

我们还能用 `git diff 8af2ff2a8f7c51e2e52402ecb7332aec39ed540e 87a4ad48d55e5280aa608cd79e8bce5e13f318dc` 这样的命令来比较任意两次提交，同样会输出比较信息。注意，该命令的格式是 `git diff <from commit> <to commit>`，也就是说对于较新的提交，其哈希值要放在第二位。

下图再次呈现了一个更改的不同阶段，以及每个阶段用的不同的 `diff` 命令。

[![一个更改的不同阶段以及相关的 diff 命令](https://res.cloudinary.com/practicaldev/image/fetch/s--hZ540Uzu--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://raw.githubusercontent.com/UnseenWizzard/git_training/master/img/diffs.png)](https://res.cloudinary.com/practicaldev/image/fetch/s--hZ540Uzu--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://raw.githubusercontent.com/UnseenWizzard/git_training/master/img/diffs.png)

现在我们可以确信提交的更改正是我们想要的，可以放心大胆地运行 `git push` 命令了。

## 分支

Git 的另一个伟大之处就是分支。分支是你使用 Git 时不可或缺的部分，借助分支来工作非常便利。

其实，从一开始我们就已经在使用分支了。

在克隆**远程仓库**时，**开发环境**会自动选中仓库的主分支（**master** 分支）复制。

通常的 Git 工作流都是先在一个**分支**上做更改，再将其`合并`（merge）回 **master** 分支。

一般情况下，你都是先在自己的**分支**上动工，等到完成现阶段的工作，并确信能够合并的时候，再合并到 **master** 分支。

> 一些 Git 仓库托管平台（如 **GitLab**、**GitHub** 等）也提供保护分支的功能，意思是并非所有人都能把更改推送到受保护的分支。在这些托管平台中，**master** 分支一般都是默认受保护的。

别担心，当我们需要用到这些托管平台的时候，自会深入研究其细节。

眼下，我们得创建一条分支，在该分支上做一些更改。有时候你只是想要尝试自己做些东西，不想污染 **master** 分支的工作状态；有时候你没有推送更改到 **master** 分支的权限。此时，一条新的分支正是你所需要的。

**本地仓库**和**远程仓库**中都允许有多条分支。每个新建的分支，都是你当前所在分支中已经提交的内容的副本。

来动手改一改 `Alice.txt` 文件吧！在第二行增加一些文字怎么样？

我们想共享要做的更改，但不想立马就并入 **master** 分支，因此得先用 `git branch <branch name>` 命令新建一条分支。

具体来说就是用 `git branch change_alice` 命令创建一个名为 `change_alice` 的分支。

这一步操作给**本地仓库**新增了一条分支。

而**工作目录**和**暂存区**其实并不会和多条分支联动，你提交的更改总是会进入到当前分支。

你可以把 Git 中的**分支**想象成指针，一根指向一系列提交内容的指针。每当你进行提交操作时，当前指针指向哪里，更改的内容就提交到哪里。

单纯新建一条分支，并不能直接连到仓库，那只是竖起了一根指针而已。

其实，**本地仓库**当前的状态，可以视为另一根指针，其名为 **HEAD**，它指向的是你当前的分支和当前的提交内容。

可能文字描述有点复杂，下面的示意图可以帮你理清这些头绪：

[![创建分支后的状态](https://res.cloudinary.com/practicaldev/image/fetch/s--Ss_shD7h--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://raw.githubusercontent.com/UnseenWizzard/git_training/master/img/add_branch.png)](https://res.cloudinary.com/practicaldev/image/fetch/s--Ss_shD7h--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://raw.githubusercontent.com/UnseenWizzard/git_training/master/img/add_branch.png)

使用 `git checkout change_alice` 命令可以切换到新分支。本操作实质上是把 **HEAD** 移到了你所指定的分支上了。

> 通常我们都是创建分支后切换到该分支上，因此可以用带有 `-b` 选项的 `checkout` 命令，一气呵成地新建完切换过去，不用分两步走了，毕竟牛仔很忙的。
> 
> 落实到具体操作就是运行 `git checkout -b change_alice` 命令，实现了创建并切换到 `change_alice` 分支。

[![切换分支后的状态](https://res.cloudinary.com/practicaldev/image/fetch/s--9Kp5zCqP--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://raw.githubusercontent.com/UnseenWizzard/git_training/master/img/checkout_branch.png)](https://res.cloudinary.com/practicaldev/image/fetch/s--9Kp5zCqP--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://raw.githubusercontent.com/UnseenWizzard/git_training/master/img/checkout_branch.png)

可能你已经注意到了，**工作目录**并没有什么变化。那是因为对 `Alice.txt` 文件的**修改**还没有关联到当前分支上。

现在你可以像在 **master** 分支上那样，执行 `add` 和 `commit` 命令，把更改标记为**暂存**（在这个节点，更改内容和分支仍然没有相互关联）并**提交**到 `change_alice` 分支上。

现在只剩一步没迈出去了。你可以试试运行 `git push` 命令，把更改推送到**远程仓库**。

你会看到如下报错信息和一条（Git 一如既往地提供的）解决建议：

```
fatal: The current branch change_alice has no upstream branch.（严重错误：没有上游分支对应当前的 change_alice 分支。）
To push the current branch and set the remote as upstream, use（若想推送当前分支并设置远程仓库为上游分支，请使用）

    git push --set-upstream origin change_alice
```

咱们可不是随意盲从的人，对吧。咱们得弄明白到底发生了什么。所以何为**上游分支（upstream branch）**？何为**远程分支（remote）**？

还记得之前我们用 `clone` 命令复制了**远程仓库**吧？那时候，**远程仓库**不只是包含本篇文章和 `Alice.txt` 文件，实际上是有两条分支在其中。

一条是 **master** 分支，我们开始动工并一路推进的分支；另一条是 **tutorial_wip** 分支，我把本教程中所有的更改都提交到这条分支上了。

当我们把**远程仓库**的内容复制到**开发环境**中时，一些额外操作潜移默化地发生了。

Git 把**本地仓库**的**远程分支**设置为你所克隆的**远程仓库**，并赋予其一个默认名称 `origin`。

> **本地仓库**可以追踪多个不同名称的**远程分支**，但本教程中，我们将紧盯住 `origin` 而不考虑其他分支。

而后，Git 复制了两条远程分支到**本地仓库**中，并最终切换到了 **master** 分支。

同时，另一个操作暗搓搓地启动了。当`签出`（checkout）一条分支，且此分支的名称与远程分支匹配时，你会得到一条新的**本地**分支，本地和远程的分支相互关联。那么我们说，这条**远程分支**就是**本地分支**的**上游分支**（upstream branch）。

在上文中的那些示意图中，你只能看到一条本地分支。而使用 `git branch` 命令则能查看一系列本地分支。

假如你想看到**本地仓库**中关联的**远程分支**，可以使用 `git branch -a` 命令列出它们。

[![远程分支和本地分支](https://res.cloudinary.com/practicaldev/image/fetch/s--6K-Zm5cn--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://raw.githubusercontent.com/UnseenWizzard/git_training/master/img/branches.png)](https://res.cloudinary.com/practicaldev/image/fetch/s--6K-Zm5cn--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://raw.githubusercontent.com/UnseenWizzard/git_training/master/img/branches.png)

明白了这些，我们就可以踏踏实实地遵照建议运行 `git push --set-upstream origin change_alice` 命令了，这样就把本地分支中的更改推送到了一条新的**远程分支**中。命令生效后，**远程仓库**中会创建一条名为 `change_alice` 的分支，并且**本地**的 `change_alice` 分支会追踪远程的新分支。

> 另外有一种操作，适用于想用本地分支追踪**远程仓库**中已有的内容这种需求。想象这样的场景：一位同事已经推送了一些更改，而这些更改与你本地分支的工作内容有依赖关系，那就需要将二者整合到一起。于是就要用到 `git branch --set-upstream-to=origin/change_alice` 这条命令，把 `change_alice` 分支的**上游分支**设为新的**远程分支**，以便于追踪同事的更改。

操作完成后，到 GitHub 上的**远程仓库**中看看，你的分支已经创建就绪，可以被其他人看到并协同工作。

很快我们将谈到如何把别人的更改拉到自己的**开发环境**中，但目前我们还是使用分支来介绍更多的概念，这些概念会在我们把**远程仓库**向本地更新时粉墨登场。

欢迎继续阅读本系列其他文章：

- [Learn git concepts, not commands - Part 1](https://github.com/xitu/gold-miner/blob/master/TODO1/learn-git-concepts-not-commands-1.md)
- [Learn git concepts, not commands - Part 2](https://github.com/xitu/gold-miner/blob/master/TODO1/learn-git-concepts-not-commands-2.md)
- [Learn git concepts, not commands - Part 3](https://github.com/xitu/gold-miner/blob/master/TODO1/learn-git-concepts-not-commands-3.md)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
