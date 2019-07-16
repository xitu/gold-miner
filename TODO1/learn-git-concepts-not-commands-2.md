> * 原文地址：[Learn git concepts, not commands](https://dev.to/unseenwizzard/learn-git-concepts-not-commands-4gjc)
> * 原文作者：[Nico Riedmann](https://dev.to/unseenwizzard)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/learn-git-concepts-not-commands-2.md](https://github.com/xitu/gold-miner/blob/master/TODO1/learn-git-concepts-not-commands-2.md)
> * 译者：[Mirosalva](https://github.com/Mirosalva)
> * 校对者：[shixi-li](https://github.com/shixi-li)，[Moonliujk](https://github.com/Moonliujk)

# Git：透过命令学概念 —— 第二部分

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
> 因此，如果你读完了本文还意犹未尽，就快点击上面两个链接一探究竟吧！我真心希望本教程中介绍的概念，能帮你理解另外两篇文章中详解的其他 Git 功能

建议按照顺序阅读本系列文章：

- [Git：透过命令学概念 —— 第一部分](https://github.com/xitu/gold-miner/blob/master/TODO1/learn-git-concepts-not-commands-1.md)
- [Git：透过命令学概念 —— 第二部分](https://github.com/xitu/gold-miner/blob/master/TODO1/learn-git-concepts-not-commands-2.md)
- [Git：透过命令学概念 —— 第三部分](https://github.com/xitu/gold-miner/blob/master/TODO1/learn-git-concepts-not-commands-3.md)

---

- [Git：透过命令学概念 —— 第二部分](#Git%E9%80%8F%E8%BF%87%E5%91%BD%E4%BB%A4%E5%AD%A6%E6%A6%82%E5%BF%B5--%E7%AC%AC%E4%BA%8C%E9%83%A8%E5%88%86)
  - [合并](#%E5%90%88%E5%B9%B6)
    - [快进合并](#%E5%BF%AB%E8%BF%9B%E5%90%88%E5%B9%B6)
    - [合并相异的分支](#%E5%90%88%E5%B9%B6%E7%9B%B8%E5%BC%82%E7%9A%84%E5%88%86%E6%94%AF)
    - [解决冲突](#%E8%A7%A3%E5%86%B3%E5%86%B2%E7%AA%81)
  - [变基](#%E5%8F%98%E5%9F%BA)
    - [解决冲突](#%E8%A7%A3%E5%86%B3%E5%86%B2%E7%AA%81-1)
  - [更新远程变更到**本地工作环境**](#%E6%9B%B4%E6%96%B0%E8%BF%9C%E7%A8%8B%E5%8F%98%E6%9B%B4%E5%88%B0%E6%9C%AC%E5%9C%B0%E5%B7%A5%E4%BD%9C%E7%8E%AF%E5%A2%83)
    - [获取更新](#%E8%8E%B7%E5%8F%96%E6%9B%B4%E6%96%B0)
    - [拉取更新](#%E6%8B%89%E5%8F%96%E6%9B%B4%E6%96%B0)
    - [储藏变更](#%E5%82%A8%E8%97%8F%E5%8F%98%E6%9B%B4)
    - [包含冲突的拉取](#%E5%8C%85%E5%90%AB%E5%86%B2%E7%AA%81%E7%9A%84%E6%8B%89%E5%8F%96)

---

## 合并

我们所有人一般都会工作在分支上，我们需要讨论下如何通过**合并**来从一个分支上获取变更到另一个分支上。

我们刚在 `change_alice` 分支上修改了 `Alice.txt`，我想说我们对所做的改变感到满意。

如果你接着执行 `git checkout master` 命令，那么我们在其他分支上创建的 `提交` 无法在此看到为了将变更弄到 master 分支，我们需要 `合并` `change_alice` 分支**到** master 分支上。

注意：你总是将某个分支 `合并` 到当前分支。

### 快进合并

既然我们已经执行了 `checked out` 来切换到 master 分支，现在我们可以执行 `git merge change_alice` 合并命令。

由于 `Alice.txt` 并没有其他**冲突**变更，我们在 **master** 分支未做修改，因此合并将在所谓的**快进**合并中进行。 

在下面的图表中，我们可以看到，这仅仅意味着：**master** 的指针会被简单地前进到 **change_alice** 分支存在的位置。

第一张图显示了我们执行 `合并` 前的状态，**master** 指针仍处于它之前的提交位置，同时另一个分支上我们又做了一次提交。

[![快进合并之前](https://res.cloudinary.com/practicaldev/image/fetch/s--sS6CJ1Rg--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://raw.githubusercontent.com/UnseenWizzard/git_training/master/img/before_ff_merge.png)](https://res.cloudinary.com/practicaldev/image/fetch/s--sS6CJ1Rg--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://raw.githubusercontent.com/UnseenWizzard/git_training/master/img/before_ff_merge.png)

第二张图显示了在我们 `合并` 之后发生了什么变化。

[![快进合并之后](https://res.cloudinary.com/practicaldev/image/fetch/s--K_hHy8zA--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://raw.githubusercontent.com/UnseenWizzard/git_training/master/img/ff_merge.png)](https://res.cloudinary.com/practicaldev/image/fetch/s--K_hHy8zA--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://raw.githubusercontent.com/UnseenWizzard/git_training/master/img/ff_merge.png)

### 合并相异的分支

让我们试一些更复杂的。

在 master 分支的 `Bob.txt` 文件新行中添加一些文字，然后提交它。

接着执行 `git checkout change_alice` 命令，改变 `Alice.txt` 文件并提交。

在下图中，你可以看到我们的提交历史现在的样子。**master** 和 `change_alice` 分支都源于同一个提交，但那之后它们发生了**分歧** ，每个分支都有自己额外的提交。

[![不同的提交](https://res.cloudinary.com/practicaldev/image/fetch/s--NKM59jTn--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://raw.githubusercontent.com/UnseenWizzard/git_training/master/img/branches_diverge.png)](https://res.cloudinary.com/practicaldev/image/fetch/s--NKM59jTn--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://raw.githubusercontent.com/UnseenWizzard/git_training/master/img/branches_diverge.png)

如果你现在使用命令 `git merge change_alice` 来执行一个快进合并是不可能的了。取代它的是，你最爱的文本编辑器将会打开，并且允许你修改 `合并提交` 操作的提交信息，git 即将执行这个提交从而将两个分支重新保持一致。你现在使用默认提交信息就行。下图显示了我们在执行 `合并` 后的 git 历史状态。

[![合并分支](https://res.cloudinary.com/practicaldev/image/fetch/s--btBTCeUD--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://raw.githubusercontent.com/UnseenWizzard/git_training/master/img/merge.png)](https://res.cloudinary.com/practicaldev/image/fetch/s--btBTCeUD--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://raw.githubusercontent.com/UnseenWizzard/git_training/master/img/merge.png)

新的提交将我们在 `change_alice` 分支上的修改引入到 master 分支。 

正如你之前记得那样，git 中的修订不仅仅是文件的快照，还包含了它们来自何处的一些信息。每次 `提交` 都包含一个或多个父级提交信息。我们的新 `合并` 提交包含了 **master** 分支的最后提交，以及我们在另一个分支上的提交来作为这次合并的父级提交。

### 解决冲突

目前为止，我们的修改都没有相互干扰。

让我们介绍一种**冲突**，然后**解决**它。

创建一个新分支，然后将它 `检出`。你知道如何操作，不过或许可以使用 `git checkout -b` 命令为你减少麻烦。

我把它命名为 `bobby_branch`。

在这个分支上，我们会修改 `Bob.txt` 文件。

第一行应该仍然是 `Hi!! I'm Bob. I'm new here.`，把它修改成 `Hi!! I'm Bobby. I'm new here.`。

暂存文件之后，在你再次 `检出` master 分支之前，`提交` 你的修改。在 master 分支我们将同一行修改为 `Hi!! I'm Bob. I've been here for a while now.`，接着 `提交` 该修改。

现在是将新分支 `合并` 到 **master** 的时候了。

如果你尝试这么做，你将会看到如下的结果：

```
Auto-merging Bob.txt
CONFLICT (content): Merge conflict in Bob.txt
Automatic merge failed; fix conflicts and then commit the result.
```

两个分支都修改了同一行，此时 git 工具无法自己完全处理这种情况。

如果你运行 `git status` 命令，你会获取到用来指导接下来如何继续的所有常见帮助命令。

首先我们必须手动解决冲突。

> 对于像这个简单冲突来说，你最喜爱的文本编辑器就够用了。而对于合并含有很多变化的多个文件来说，使用更强大的工具会让你轻松不少，我建议选用包含版本控制工具，具有友好合并界面的你最喜爱的 IDE。

如果你打开 `Bob.txt` 文件，你会看到一些类似下面的内容（我已经截断了之前可能放在第二行的其他内容）：

```
<<<<<<< HEAD
Hi! I'm Bob. I've been here for a while now.
=======
Hi! I'm Bobby. I'm new here.
>>>>>>> bobby_branch
[...你在第 2 行传入的随便什么内容]
```

在上面你可以看到当前 HEAD 上 `Bob.txt` 发生的变化，在下面你可以看到我们正尝试合并进来的分支所做的更改。

为了手工解决冲突，你只需要确保文件最终保留一些合理内容，而不包含 git 引入文件的特殊行。

所以继续修改文件为下面这种内容：

```
Hi! I'm Bobby. I've been here for a while now.
[...]
```

从这里开始，我们即将要做的事是适用于任何变更。

在我们执行 `add Bob.txt` 添加文件后，**暂存**这些变更，然后执行 `提交`。

我们已经了解为解决冲突所做的变更提交，就是合并过程中一直都有的**合并提交**。

实际上你应该意识到在解决冲突的过程中，如果你不想继续 `合并` 进程，你可以通过运行 `git merge --abort` 命令直接 `中止` 它。

## 变基

Git 有另外一种纯净方式来集成两个分支的变化，叫做 `变基`。

我们始终记得一个分支总是基于另外一个分支。当你创建它时，从某处开始**分叉**。

在我们简单的合并样例中，我们从 **master** 分支的某次提交创建了一个分支，然后提交了在 **master** 和 `change_alice` 分别提交了一些变更。

当一个分支相对于它所基于的分支产生了改变，如果你想要把最新的变更整合到你当前的分支，`变基` 提供了一种比 `合并` 更加纯净的处理方式。

正如你所看到的，一次 `合并` 引入了一个**合并提交**，这个过程中两边的历史记录得到整合。

很容易看得出，变基仅仅改变了你的分支所依赖的历史记录点（创建分支所基于的某次提交）。

为了尝试这一点，我们首先将 **master** 分支再次检出，然后基于它来创建/检出一个新分支。

我称自己的新分支为 `add_patrick`，然后我添加了一个新文件 `Patrick.txt`，然后以信息 “Add Patrick” 提交了该文件。

在你为该分支添加了一条提交后，返回 **master** 分支，做一点修改然后提交它。我做的修改是为 `Alice.txt` 文件多加了一些文本。

就像我们合并样例中那样，两个分支有公共祖先，然而历史是不同的，你可以从下图中看出：

[![一次变基之前的历史记录](https://res.cloudinary.com/practicaldev/image/fetch/s--nTsD2ONw--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://raw.githubusercontent.com/UnseenWizzard/git_training/master/img/before_rebase.png)](https://res.cloudinary.com/practicaldev/image/fetch/s--nTsD2ONw--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://raw.githubusercontent.com/UnseenWizzard/git_training/master/img/before_rebase.png)

现在让我们再执行 `checkout add_patrick` 命令，然后把 **master** 上做的修改获取到我们正在操作的分支上！

当我们执行 `git rebase master` 命令，我们让 `add_patrick` 分支重新以当前状态的 **master** 分支做了基准。

上面这条命令为我们提供了目前操作的友好提示：

```
First, rewinding head to replay your work on top of it...
Applying: Add Patrick
```

我们知道 **HEAD** 是我们所在的**工作环境**中当前提交的指针。

在变基操作执行之前，它的指向与 `add_patrick` 分支一致。发生了变基，它会首先移回到两个分支的公共祖先，然后移动到我们想要定为基点的那个分支的当前顶点。

所以 **HEAD** 移动到 **0cfc1d2** 这次提交，然后到 **7639f4b** 这次提交，它是位于 **master** 分支的顶点。

然后变基操作会将我们在 `add_patrick` 分支上做的每一个提交都应用到那个顶点上。

为了更精确了解 **git** 把 **HEAD** 指针移回到分支的公共祖先过程中做了什么，可以把你在被操作的分支上每次提交都存储一部分（修改的 `差异点`、提交信息、作者等等。）。

在上面操作之后，你正在变基的分支需要 `检出` 最新的提交，然后把存下的所有变化**以一条新提交**应用到前面的提交之上。

所以在我们原先简单的视图中，我们认为在 `变基` 之后，**0cfc1d2** 这次提交不再指向它历史中原公共祖先，而是指向 master 分支的顶部。

事实上，**0cfc1d2** 这次提交消失了，并且 `add_patrick` 分支以一个新提交 **0ccaba8** 为开始，它以 **master** 分支的最新提交作为公共祖先。

我们让它看起来就像，`add_patrick` 分支是以当前 **master** 分支为基点，而不是分支的较旧版本，不过我们这样做相当于重写了该分支的历史。

在本教程的末尾，我们会多学习一些重写历史以及什么时候适宜和不适宜这么做。

[![变基之后的历史记录](https://res.cloudinary.com/practicaldev/image/fetch/s--rV897ytW--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://raw.githubusercontent.com/UnseenWizzard/git_training/master/img/rebase.png)](https://res.cloudinary.com/practicaldev/image/fetch/s--rV897ytW--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://raw.githubusercontent.com/UnseenWizzard/git_training/master/img/rebase.png)

当你自己的工作分支是基于一个共享分支时，例如 **master** 分支，`变基` 是一种相当强大的工具。

使用变基操作，可以确保你能经常整合别人提交到 **master** 分支的变更和推送，并且保证一条干净线性的历史，在你的工作文本需要引入到共享分支时，这种历史可以做 `快进合并`。

相对于包含**合并提交**的凌乱历史，保持历史的线性也可以使提交日志更加有用（试一下 `git log --graph`，或者看一下 **GitHub** 或 **GitLab** 的分支视图）。

### 解决冲突

就像 `合并` 过程中，如果遇到两次提交修改了一个文件中同样位置的内容块，你可能会遇到冲突。

然而当你在 `变基` 过程中遇到冲突，你无需在额外的**合并提交**中解决它，却可以在当前正在执行的提交中解决它。

同样地，将你的修改直接以原始分支的当前状态为基准。

事实上，你在 `变基` 过程中的解决冲突操作非常类似你在 `合并` 中的操作，所以如果你不太确定如何操作的话，可以回过头查看那个小节。

唯一的区别在于，由于你没有引入**合并提交**，所以不需要你提交冲突解决结果。只需**添加**变更到**暂存环境**，然后执行 `git rebase --continue` 命令。冲突将会在刚刚执行的提交中得到解决。

当合并时，你一直都可以停止和丢弃目前你做的所有内容，通过执行 `git rebase --abort` 命令。

## 更新远程变更到**本地工作环境**

目前为止，我们已经学习了如何生成和共享内容变更。

如果你是独自工作，这些已经够用了。但是通常我们是多人共同处理一项工作，并且我们想要从**远程仓库**以某种方式获取他们的变更到我们自己的**工作环境**中。

由于已经过了一段时间，让我们看一下 git 的组件：

[![git 组件](https://res.cloudinary.com/practicaldev/image/fetch/s--jSuilYlA--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://raw.githubusercontent.com/UnseenWizzard/git_training/master/img/components.png)](https://res.cloudinary.com/practicaldev/image/fetch/s--jSuilYlA--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://raw.githubusercontent.com/UnseenWizzard/git_training/master/img/components.png)

就像你的**工作环境**，每个工作在同一份源代码的人都有他们自己的工作环境。

[![许多工作环境](https://res.cloudinary.com/practicaldev/image/fetch/s--l88bjwDT--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://raw.githubusercontent.com/UnseenWizzard/git_training/master/img/many_dev_environments.png)](https://res.cloudinary.com/practicaldev/image/fetch/s--l88bjwDT--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://raw.githubusercontent.com/UnseenWizzard/git_training/master/img/many_dev_environments.png)

所有这些**工作环境**都有它们自己的**进行中**和**暂存的**变更，这些会在某个节点被 `提交` 到**本地仓库**，最终 `推送` 到**远程仓库**。

我们的例子中，我们会使用 **GitHub** 提供的在线工具，来模拟在我们工作时其他人对**远程仓库**生成的变更。

查看你在 [github.com](https://www.github.com) 网上对这个仓库的 fork 分支，打开 `Alice.txt` 文件。

找到编辑按钮，通过网站来生成和提交一个变更。

[![github 编辑](https://res.cloudinary.com/practicaldev/image/fetch/s--ifXKNJi7--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://raw.githubusercontent.com/UnseenWizzard/git_training/master/img/github.png)](https://res.cloudinary.com/practicaldev/image/fetch/s--ifXKNJi7--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://raw.githubusercontent.com/UnseenWizzard/git_training/master/img/github.png)

在这个仓库中，我已经在一个叫做 `fetching_changes_sample` 的分支上为 `Alice.txt` 文件添加了一个远程仓库变更，但是在你的该仓库版本，你当然可以直接改变 `master` 分支上这个文件。

### 获取更新

我们还记得，当你执行 `git push` 命令时，会将**本地仓库**的变更同步到**远程仓库**。

为了获取**远程仓库**中的变更到**本地仓库**，你可以使用 `git fetch` 命令。

这个操作获取到远程的任何变更到你的**本地仓库**，包含提交和分支。

这点要注意，变更还没有被整合到本地分支，更不用说**工作空间**和**暂存区域**。

[![获取更新](https://res.cloudinary.com/practicaldev/image/fetch/s--F6oFwBrc--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://raw.githubusercontent.com/UnseenWizzard/git_training/master/img/fetch.png)](https://res.cloudinary.com/practicaldev/image/fetch/s--F6oFwBrc--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://raw.githubusercontent.com/UnseenWizzard/git_training/master/img/fetch.png)

如果你现在执行 `git status` 命令，你会看到 git 命令的另一个很棒的例子，告诉你现在正发生什么：

```
git status
On branch fetching_changes_sample
Your branch is behind 'origin/fetching_changes_sample' by 1 commit, and can be fast-forwarded.
(use "git pull" to update your local branch)
```

### 拉取更新

由于我们没有**工作中**和**暂存**的变更，我们现在可以执行 `git pull` 命令来从**仓库**中拉取所有变更到我们的工作空间。

> 拉取会隐式地 `获取` **远程仓库**，但有时候单独执行 `获取` 是个好选择。
> 例如，当你想要同步任何新的**远程**分支，或者你想在像 `origin/master` 这种分支上执行 `git rebase` 之前，需要确保你的**本地仓库**是最新的。

[![拉取更新](https://res.cloudinary.com/practicaldev/image/fetch/s--LD07tDxG--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://raw.githubusercontent.com/UnseenWizzard/git_training/master/img/pull.png)](https://res.cloudinary.com/practicaldev/image/fetch/s--LD07tDxG--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://raw.githubusercontent.com/UnseenWizzard/git_training/master/img/pull.png)

在我们 `拉取` 之前，让我们本地修改一个文件来看会发生什么。

让我们在**工作空间**再次修改 `Alice.txt` 文件！

如果你现在尝试做一次 `git pull`，你会看到如下错误：

```
git pull
Updating df3ad1d..418e6f0
error: Your local changes to the following files would be overwritten by merge:
Alice.txt
Please commit your changes or stash them before you merge.
Aborting
```

你无法 `拉取` 任何变更，因为**工作空间**中有些文件被修改，同时你正在拉取进来的提交也有这些文件的变化。

这种情况的一种解决方法是，为了获取你比较信任的某个点上的变更，在你最终提交它们之前，可以把本地变更 `添加` 到**暂存空间**。但是在你最终提交它们之前，而这是学习另一个很棒工具的一个好时机。

### 储藏变更

在任何时刻如果你有一些本地变更，还不想放进一个提交中，或者想存在某个地方来以其他某种角度来解决一个问题，你可以将这些变更 `储藏` 起来。

一次 `git stash` 基本上是一个变更的堆栈，这里面你可以存储对**工作空间**的任何变更。

最常用的命令是：`git stash`，它将对**工作空间**的任何修改储藏起来。还有 `git stash pop` 命令，它拿到储藏起来的最近修改，并将其再次应用到**工作空间**。

就如堆栈命令的命名，`git stash pop` 命令在应用变更之前，将最近存储的变更移除。

如果你想保留储藏的变更，你可以使用 `git stash apply` 命令，这种方式不会在应用变更之前从储藏中移除它们。

为了检查你当前的 `储藏`,你可以使用 `git stash list` 命令来列出各个单独的条目，还可以使用 `git stash show` 命令来显示 `储藏` 中最近条目的变更。

> 另一个好用的命令是 `git stash branch {BRANCH NAME}`，它从当前的 HEAD 开始创建一个分支，此时你储藏了变更，并把它们应用到了新建分支中。

现在我们了解了 `git stash` 命令，让我们执行它，用来从**工作空间**中移除我们对 `Alice.txt` 文件做的本地变更，这样我们就可以继续上面的操作，执行 `git pull` 命令来拉取我们在网站上做的远程变更。

在那之后，让我们执行 `git stash pop` 命令来取回本地变更。

因为我们 `拉取` 的提交和 `储藏` 的变更都修改了 `Alice.txt` 文件，所以你需要解决冲突，就像在 `合并` 或 `变基` 中你做的那样。
完成 `添加` 后，提交这个变更。

### 包含冲突的拉取

现在我们已经理解如何 `获取` 和 `拉取` **远程变更**到我们的**工作环境**，正是制造一些冲突的时候！

不要推送那个修改 `Alice.txt` 文件的提交，回到你位于 [github.com](https://www.github.com) 的**远程仓库**

这里我们又要修改 `Alice.txt` 文件并提交它。

现在实际上在我们的**本地**和**远程仓库**之间存在两处冲突。

不要忘了运行 `git fetch` 命令来查看远程的变更，而不是立即 `拉取` 它。

如果你现在运行 `git status` 命令，你会看到两个分支各有一个与对方不同的提交。

```
git status
On branch fetching_changes_sample
Your branch and 'origin/fetching_changes_sample' have diverged,
and have 1 and 1 different commits each, respectively.
(use "git pull" to merge the remote branch into yours)
```

另外，我们已经在上面不同提交中修改了同一个文件，为了介绍 `合并` 中的冲突这个概念，所以我们需要解决它。

当你执行 `git pull` 命令时，而**本地**和**远程仓库**之间存在着差异，就会发生与 `合并` 两个分支过程时同样的事情。

额外的，你可以认为**远程仓库**和**本地仓库**分支之间的关系是一种从一个分支上创建另一个分支的特殊情况。

本地分支是基于你从**远程仓库**最近一次获取的分支状态的。

如果以这种方式思考，这两种选项来获取**远程仓库**变化就很有道理：

当你执行 `git pull` 命令，**本地**和**远程仓库**的版本就会 `合并`。就像 `合并` 不同分支一样，这会引入一个**合并**提交。

因为任何本地分支都基于它们各自的远程版本，我们也可以对它执行 `变基`，这样做的话我们在本地做的任何变更，都表现为基于远程仓库中的最新可用版本。

为了这么做，我们可以使用 `git pull --rebase` 命令（或者简写`git pull -r`）。

在[变基](#变基)这小节中已经详细介绍了，保持一个干净线性的历史提交记录是有好处的，所以我才强烈建议当你需要执行 `git pull` 命令时，不妨使用 `git pull -r` 替代。

> 你也可以告诉 git 使用 `变基` 来代替 `合并`，作为你执行 `git pull` 命令时的默认策略，通过一个像这样 `git config --global pull.rebase true` 的命令来设置 `pull.rebase` 标识。

在我介绍前面几个段落之后，如果你还没有执行过 `git pull` 命令的话，让我现在一起执行 `git pull -r` 来获取远程变更吧，让它显得就像我们的新提交位于那些远程变更之后。

当然就像一个正常的 `变基`（或者 `合并`）操作，你需要解决我们引入的冲突，以便 `git pull` 命令可以完成。

欢迎继续阅读本系列其他文章：

- [Git：透过命令学概念 —— 第一部分](https://github.com/xitu/gold-miner/blob/master/TODO1/learn-git-concepts-not-commands-1.md)
- [Git：透过命令学概念 —— 第二部分](https://github.com/xitu/gold-miner/blob/master/TODO1/learn-git-concepts-not-commands-2.md)
- [Git：透过命令学概念 —— 第三部分](https://github.com/xitu/gold-miner/blob/master/TODO1/learn-git-concepts-not-commands-3.md)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
