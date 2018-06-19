> * 原文地址：[How (and why!) to keep your Git commit history clean](https://about.gitlab.com/2018/06/07/keeping-git-commit-history-clean/)
> * 原文作者：[Kushal Pandya](https://about.gitlab.com/team/#Kushal_Pandya)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/keeping-git-commit-history-clean.md](https://github.com/xitu/gold-miner/blob/master/TODO1/keeping-git-commit-history-clean.md)
> * 译者：[DM.Zhong](https://github.com/zhongdeming428)
> * 校对者：[Leo Lyu](https://github.com/zmkoo000)，[YiLin Wang](https://github.com/Colafornia)

# 怎样（以及为什么要）保持你的 Git 提交记录的整洁

## Git 提交记录很容易变得混乱不堪，现在教你怎么保持整洁！

提交功能是 Git 仓库的关键部分之一，不仅如此，**提交信息**也是仓库的生命日志。项目或者仓库在随着时间的推移不断演变（新功能不断加入，Bug 被不断修复，体系架构也被重构），提交信息成为了人们查看仓库所发生的变化或者怎么发生变化的地方。因此使用简短精确的提交信息反映出内部的变化是非常重要的。

## 为什么有意义的提交记录非常重要？

Git 提交信息是你在你所写的代码上所留下的指纹。不管你今天提交了什么代码，一年之后你再看到这个变化；你会非常感谢你所写的有意义的、干净整洁的提交信息，这也会使得你的同事工作更轻松。当根据上下文分开提交时，可以更快地找到 Bug 是在哪一次提交中被引入的，将首先引起 Bug 的这次提交进行回退可以非常简便的修复 Bug。

当开发大型项目时，我们经常处理一大堆部件变动，包括更新、添加和移除。在这种场景中确保好好维护提交信息是很艰难的，尤其是当开发周期是数天、数周、甚至数月时。因此为了简化维护提交记录的工作，这篇文章会使用许多开发人员在 Git 仓库上工作时可能会经常遇到的常见场景。

*   [场景 1：我需要修改最近一次的提交](#场景-1我需要修改最近一次的提交)
*   [场景 2：我需要修改一次特定的提交](#场景-2我需要修改一次特定的提交)
*   [场景 3：我需要添加、移除或者合并提交](#场景-3我需要添加移除或者合并提交)
*   [场景 4：我的提交记录没啥有用的内容，我需要重新开始！](#场景-4我的提交记录没啥有用的内容我需要重新开始)

但是在我们深入了解之前，让我们快速浏览一下我们假设的 Ruby 应用程序中典型的开发工作流程。

**注意：**这篇文章默认你已经掌握 Git 基础，分支如何工作，如何将分支的未提交更改添加到暂存区以及如何提交更改。如果你不太熟悉这些流程，[我们的文档](https://docs.gitlab.com/ee/topics/git/index.html)是一个好的起点。

## 生活中的某天

现在，我们正在开发一个小型的 Ruby on Rails 项目，在这个项目中我们需要在首页添加一个导航视图，这需要更新和添加许多文件。下面是整个流程分解的每个步骤：

*   你开始开发某个功能，更新了一个文件；让我们称它为 `application_controller.rb`
*   这个功能还需要你更新一个视图：`index.html.haml`
*   你添加了索引页所使用的一个部分：`_navigation.html.haml`
*   为了体现你所添加的那一部分，样式表也需要被更新：`styles.css.scss`
*   改完这些模块，功能已经完成了，是时候更新测试文件了；要更新的文件如下：
    *   `application_controller_spec.rb`
    *   `navigation_spec.rb`
*   测试也更新了，并且如期地通过了所有的测试案例，现在是时候提交更改了！

因为所有的这些文件属于不同的架构领域，我们彼此隔离地提交这些文件的更改，以确保每次提交代表了特定的上下文，并且按照特定顺序进行提交。我通常偏向于后端 -> 前端的提交顺序：首先提交以后端为中心的更改，其次提交中间层文件的更改，最后提交以前端为中心的更改。

1.  `application_controller.rb` & `application_controller_spec.rb`；**添加导航路由**。
2.  `_navigation.html.haml` & `navigation_spec.rb`；**页面导航视图**。
3.  `index.html.haml`；**渲染导航部分**。
4.  `styles.css.scss`；**为导航添加样式**。

在提交更改之后，我们会为分支创建一个合并请求。一旦创建了合并请求，在被合并到仓库的 `master` 分支之前，通常会由你的同事对代码进行审查。现在我们了解一下代码审查过程中可能会遇到的不同情况。

## 场景 1：我需要修改最近一次的提交

想象一下代码审查者在审查 `styles.css.scss` 时提出了一个修改建议。这种情况，修改起来非常简单，因为样式表修改是你分支上的**最后一次**提交。下面是我们应该怎样处理这种情况：

*   你直接在你的分支上对 `styles.css.scss` 做必要的修改。
*   一旦你完成了修改，将这些修改添加到暂存区进行暂存；运行命令 `git add styles.css.scss`。
*   一旦修改被添加到暂存区，我们需要将这些修改**添加**到我们的最后一次提交；运行命令： `git commit --amend`。
    *   **命令分解**：这里，我们使用 `git commit` 命令**修改**最近一次提交，把暂存中的任何修改合并到最近一次提交。
*   这会在你的 Git 定义的文本编辑器中打开你最后一次的提交，它具有提交信息**为导航添加样式**。
*   因为我们只更新了 CSS 声明，所以我们不需要修改提交信息。你可以只做保存然后退出 Git 为你打开的文本编辑器，你的更改会被反映到提交上。

由于你修改了一个已经存在的提交，你需要使用 `git push --force-with-lease <remote_name> <branch_name>` 命令将这些修改 **强制推送**到你的远程仓库。这个命令会使用我们本地仓库中所做的修改来覆盖远程仓库中`为导航添加样式`这个提交。

当你强制推送分支时，有一点需要注意，那就是当你所在分支是一个多人协作的分支时，你的强制推送可能会给其他人的正常推送造成麻烦，因为远程分支上有一些强制推送的新的提交。因此，你应该合理地使用这个功能。你可以在[这里](https://git-scm.com/docs/git-push#git-push---no-force-with-lease)学习到更多有关 Git 强制推送选项的信息。

## 场景 2：我需要修改一次特定的提交

在上一个场景中，因为我们只需要修改最近的一次提交，所以做起来非常简单，但是想象一下如果代码审查者建议修改 `_navigation.html.haml` 文件中的某些部分。在这种场景下，它是第二次提交，所以修改起来不像第一个场景中那么直接。让我们看看怎么处理这种情况：

每次在分支上提交更改，都会有一个独一无二的 SHA1 哈希字符串作为更改提交的标志。可以把它看做区分每次提交的独特 ID。可以通过运行 `git log` 命令查看某个分支上的所有提交以及它们分别的 SHA1 哈希值。运行命令之后，可以看到类似下面的输出，其中最近一次的提交在顶部。

```
commit aa0a35a867ed2094da60042062e8f3d6000e3952 (HEAD -> add-page-navigation)
Author: Kushal Pandya <kushal@gitlab.com>
Date: Wed May 2 15:24:02 2018 +0530

    为导航添加样式

commit c22a3fa0c5cdc175f2b8232b9704079d27c619d0
Author: Kushal Pandya <kushal@gitlab.com>
Date: Wed May 2 08:42:52 2018 +0000

    渲染导航部分

commit 4155df1cdc7be01c98b0773497ff65c22ba1549f
Author: Kushal Pandya <kushal@gitlab.com>
Date: Wed May 2 08:42:51 2018 +0000

    页面导航视图

commit 8d74af102941aa0b51e1a35b8ad731284e4b5a20
Author: Kushal Pandya <kushal@gitlab.com>
Date: Wed May 2 08:12:20 2018 +0000

    添加导航路由
```

现在轮到 `git rebase` 命令表演了。不管什么时候我们想要用 `git rebase` 命令修改一个特定的更改提交，我们首先要将我们分支的 HEAD 变基到我们想要修改的更改提交**之前**。在这个场景中，我们需要修改`页面导航视图`的更改提交。

![更改提交日志](https://about.gitlab.com/images/blogimages/keeping-git-commit-history-clean/GitRebase.png)

现在，注意我们想要修改的更改提交之前的一个更改提交的哈希值；复制这个哈希值然后按照一下步骤进行操作：

*   通过运行命令 `git rebase -i 8d74af102941aa0b51e1a35b8ad731284e4b5a20` 来将分支变基到我们要修改的更改提交的前一个更改提交
    *   **命令分解**：现在我们正在使用 Git 的 `rebase` 命令的**交互模式**，通过提交 SHA1 哈希值我们可以将分支进变基。
*   这条命令会运行 Git 变基命令的交互模式，并且会打开文本编辑器展示你所变基到的更改提交**之后**的所有更改提交。它看起来是这样的：

```
pick 4155df1cdc7 页面导航视图
pick c22a3fa0c5c 渲染导航部分
pick aa0a35a867e 为导航添加样式

# Rebase 8d74af10294..aa0a35a867e onto 8d74af10294 (3 commands)
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

注意到每个更改提交之前都有一个单词 `pick`，并且在它下面的内容里面，有所有的我们可以使用的关键字。因为我们想要**编辑**一个更改提交，所以我们将命令 `pick 4155df1cdc7 页面导航视图` 修改为 `edit 4155df1cdc7 页面导航视图`。保存更改并退出编辑器。 

现在你的分支已经被变基到包含 `_navigation.html.haml` 的更改提交之前了。打开文件并完成每个审查反馈中的修改需求。一旦你完成了修改，使用命令 `git add _navigation.html.haml` 将它们暂存起来。

因为我们已经暂存了这些更改，所以现在应该把分支 HEAD 重新移动到我们原来的更改提交（同时包含我们所有的新的更改的提交），运行 `git rebase --continue`，这将会在终端中打开你的默认编辑器并且向你展示变基期间我们所做的更改的提交信息；`页面导航视图`。如果需要你可以修改这个提交信息，但现在我们保留它，因此接下来保存修改然后退出编辑器。这个时候，Git 会重新展示你刚刚修改的更改提交之后的所有更改提交并且分支的 `HEAD` 已经回到了我们原来的所有更改提交的顶部，它包含所有你对其中某个更改提交所做的所有新的更改。

因为我们又一次修改了远程仓库中的一个提交，我们需要再次使用 `git push --force-with-lease <remote_name> <branch_name>` 命令将分支强制提交。

## 场景 3：我需要添加、移除或者合并提交

一个常见的场景就是当我们刚刚修改了一些之前的提交并重新提交了一些新的更改。现在让我们尽可能的精简一下这些提交，用原来的提交合并它们。

你所要做的就是像其它场景中所做的那样开始交互性的变基操作。

```
pick 4155df1cdc7 页面导航视图
pick c22a3fa0c5c 渲染导航部分
pick aa0a35a867e 为导航添加样式
pick 62e858a322 Fix a typo
pick 5c25eb48c8 Ops another fix
pick 7f0718efe9 Fix 2
pick f0ffc19ef7 Argh Another fix!
```

现在假设你想要合并所有的那些提交到 `c22a3fa0c5c 渲染导航部分`。你只需要做：

1.  把你想要合并的那些更改提交往上移动，以使得它们位于最终合并的更改提交之下。
2.  将每一个更改提交的模式由 `pick` 改为 `squash` 或者 `fixup`。

**注意：**`squash` 模式会在描述中保留修改时的信息。而`fixup` 不会，它只会保留原来的提交信息。

你会以下面这种结果结束实验：

```
pick 4155df1cdc7 页面导航视图
pick c22a3fa0c5c 渲染导航部分
fixup 62e858a322 Fix a typo
fixup 5c25eb48c8 Ops another fix
fixup 7f0718efe9 Fix 2
fixup f0ffc19ef7 Argh Another fix!
pick aa0a35a867e 为导航添加样式
```

保存更改并退出编辑器，你就完成了！这就是完成之后的历史提交记录：

```
pick 4155df1cdc7 页面导航视图
pick 96373c0bcf 渲染导航部分
pick aa0a35a867e 为导航添加样式
```

像之前一样，你现在所要做的所有工作只是运行 `git push --force-with-lease <remote_name> <branch_name>` 命令，然后所有的修改都被强制推送了。

如果你想要完全地移除一个更改提交，而不是 `squash` 或者 `fixup`，你只需要输入 `drop` 或者简单地删除这一行。

### 避免冲突

为避免发生冲突，请确保您在时间线上上移的提交不会触及其后的提交所触及的相同文件。

```
pick 4155df1cdc7 页面导航视图
pick c22a3fa0c5c 渲染导航部分
fixup 62e858a322 Fix a typo                 # this changes styles.css
fixup 5c25eb48c8 Ops another fix            # this changes image/logo.svg
fixup 7f0718efe9 Fix 2                      # this changes styles.css
fixup f0ffc19ef7 Argh Another fix!          # this changes styles.css
pick aa0a35a867e 为导航添加样式  # this changes index.html (no conflict)
```

### 附加提示：快速 `fixup`

如果你很清楚你想要修改哪一个更改提交，在提交更改时不必浪费脑力思考一些 "Fix 1", "Fix 2", …, "Fix 42" 这样的名字。

**步骤 1：初识 `--fixup`**

在你暂存那些更改之后，使用以下命令提交更改：

```
git commit --fixup c22a3fa0c5c
```

（注意到这个哈希值是属于 `c22a3fa0c5c 渲染导航部分`这个更改提交的）

这会产生这样的提交信息：`fixup! 渲染导航部分`。

**步骤 2：还有这个小伙伴 `--autosquash`**

通过简单的使用交互变基操作。你可以让 `git` 自动的把所有 `fixup` 放到正确的位置。

`git rebase -i 4155df1cdc7 --autosquash`

历史提交记录会变成下面这样:

```
pick 4155df1cdc7 页面导航视图
pick c22a3fa0c5c 渲染导航部分
fixup 62e858a322 Fix a typo
fixup 5c25eb48c8 Ops another fix
fixup 7f0718efe9 Fix 2
fixup f0ffc19ef7 Argh Another fix!
pick aa0a35a867e 为导航添加样式
```

一切就绪，你只需要审查并继续。

如果你觉得有风险，你可以做一个非交互式的变基 `git rebase --autosquash`，但前提是你喜欢过这种有风险的生活，因为你没有机会在应用前检查它们。

## 场景 4：我的提交记录没啥有用的内容，我需要重新开始！

如果你在开发一个大型的功能，那通常会有许多修复和代码审查反馈的修改频繁的被提交。我们可以将提交的清理工作留到开发结束，而不是不断重新设计分支。

这是创建补丁文件非常方便的地方。实际上，在开发人员可以使用以 Git 为基础的服务比如 GitLab 之前，补丁文件一直是开发大型开源项目通过邮件分享代码与合并代码的主要方式。假设你有一个提交量非常巨大的分支（例如；`add-page-navigation`），它对于仓库的变更历史表述得不是很清晰。以下是如何为您在此分支中所做的所有更改创建补丁文件：

*   创建补丁文件的第一步是确保您的分支具有来自 `master` 分支的所有更改并且与这些更改没有冲突。
*   您可以在 `add-page-navigation` 分支中签出时运行 `git rebase master` 或 `git merge master`，以将所有从 `master` 进行的更改转移到您的分支上。
*   现在创建补丁文件; 运行 `git diff master add-page-navigation>〜/ add_page_navigation.patch`。
    *    **命令分解**：在这里我们使用了 Git 的 _diff_ 特性，查询 `master` 分支和 `add-page-navigation` 分支之间的差异，然后**重定向**输出（通过 `>` 符号）到一个文件，在我们的用户主目录（在 *nix 系操作系统中通常是 `〜/`）中命名为 `add_page_navigation.patch`。
*   你可以指定你想保存这个文件的路径，文件名和扩展名为任意你想要的值。
*   一旦命令运行并且没有看到任何错误，就会生成补丁文件。
*   现在签出 `master` 分支; 运行 `git checkout master`。
*   从本地仓库删除分支 `add-page-navigation`; 运行 `git branch -D add-page-navigation`。请记住，我们已经在创建的补丁文件中更改了此分支。
*   现在创建一个具有相同名称的新分支（`master` 被签出）; 运行 `git checkout -b add-page-navigation`。
*   现在，这是一个新的分支，没有任何你所做的修改。
*   最后，从修补程序文件中应用您的更改；`git apply〜/ add_page_navigation.patch`。
*   在这里，所有更改都会应用到分支中，并且它们将显示为未提交，就好像您所做的所有修改都完成了，但没有任何修改是在分支中实际提交的。
*   现在，您可以继续并按照所需顺序提交按影响区域分组的单个文件或文件，并使用简单明了的提交信息。

跟之前的场景一样，我们修改了整个分支，现在是时候强制推送了！

## 结论

虽然我们已经介绍了使用 Git 进行日常工作流程中出现的大多数常见和基本情况，但重写 Git 提交历史是一个巨大的话题，如果你已经熟悉上述建议，您可以在[Git 官方文档](https://git-scm.com/book/en/v2/Git-Tools-Rewriting-History)。快乐的 git'ing！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
