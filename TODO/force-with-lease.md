
> * 原文地址：[-force considered harmful; understanding git's --force-with-lease](https://developer.atlassian.com/blog/2015/04/force-with-lease/)
> * 原文作者：[Steve Smith](https://legacy-developer.atlassian.com/blog/authors/ssmith/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/force-with-lease.md](https://github.com/xitu/gold-miner/blob/master/TODO/force-with-lease.md)
> * 译者：[LeviDing](https://github.com/leviding)
> * 校对者：[yifili09](https://github.com/yifili09)

# 使用 `-force` 被认为是有害的；了解 Git 的 `-force-with-lease` 命令

Git 的 `push --force` 具有破坏性，因为它无条件地覆盖远程存储库，无论你在本地拥有什么。使用这个命令，可能覆盖团队成员在此期间推送的所有更改。然而，有一个更好的办法，当你需要强制推送，但仍需确保不覆盖其他人的工作时，`-force-with-lease` 这条指令选项可以帮助到你。

![我不经常使用 push --force...](https://developer.atlassian.com/blog/2015/04/force-with-lease/force-with-lease.jpg)

众所周知，git 的 `push -force` 指令是不推荐被使用的，因为它会破坏其他已经提交到共享库的内容。虽然这不总是完全致命的（如果那些修改的内容仍在某些同事的本地工作域中，那之后他们能被重新合并），但是这样的做法很欠考虑，最糟糕的情况会造成灾难性的损失。这是因为 `--force` 指令选项迫使分支的头指针指向你个人的修改记录，而忽略了那些其他和你同时进行地更改。

强制推动最常见的原因之一是当我们被迫 `rebase` 一个分支的时候。为了说明这一点，我们来看一个例子。我们有一个项目，其中有一个功能分支，Alice 和 Bob 要同时在这个分支上工作。他们都 `git clone...` 了这个仓库，并开始工作。

最初，Alice 完成了她负责的功能，并将其 `push` 到主仓库。这都没啥问题。

Bob 也完成了他的工作，但在 `push` 之前，他注意到一些变化已被合并到了 *master* 分支。想要保持一棵整洁的工作树，他会对主分支执行一个 `rebase`。当然，当他 `push` 这个经过 `rebase` 的分支的时候将被拒绝。然而，Bob 没有意识到 Alice 已经 `push` 了她的工作。Bob 执行了 `push --force` 命令。不幸的是，这将清除 Alice 在远程主仓库的所有更改和记录。

这里的问题是，进行强制推送的 Bob 不知道为什么他的 `push` 会被拒绝，所以他认为这是 `rebase` 造成的，而不是由于 Alice 的变化。这就是为什么 `--force` 在同一个分支上协作的时候要杜绝的；并且通过远程主仓库的工作流程，任何分支都可以被共享。

但是 `--force` 有一个不为众人所知的亲戚，它在**一定程度上**能防止强制更新操作带来的结构性破坏；它就是 `--force-with-lease`。

`--force-with-lease` 是用于拒绝更新一个分支，除非该分支达到我们期望的状态。即没有人在上游更新分支内容。 实际上，通过检查上游引用是我们所期望的，因为引用是散列，并将父系链隐含地编码成它们的值。

你可以告诉 `--force-with-lease` 究竟要检查什么，默认情况下会检查当前的远程引用。这在实践中意味着，当 Alice 更新她的分支并将其推送到远程仓库时，分支的引用指针将被更新。现在，除非 Bob从远程仓库 `pull` 一下，否则*本地*对远程仓库的引用将过期。当他使用 `--force-with-lease` 推送时，git 会检查本地与远程的引用是否对应，并拒绝 Bob 的强制推送。`--force-with-lease` 有效地只在没有人在上游更新分支内容的时候允许你强制推送。就像是一个带有安全带的 `--force`。它的一个快速演示可能有助于说明这一点：

Alice 已经对该分支进行了一些更改，并已推送到了远程主仓库。Bob 现在又对远程仓库的 `master` 分支进行了 `rebases` 操作：

```bash
ssmith$ git rebase master
First, rewinding head to replay your work on top of it...
Applying: Dev commit #1
Applying: Dev commit #2
Applying: Dev commit #3
```

`rebase` 之后，他试图将自己的更改 `push` 上去，但服务器拒绝了，因为这会覆盖 Alice 的工作：

```bash
ssmith$ git push
To /tmp/repo
 ! [rejected]        dev -> dev (fetch first)
error: failed to push some refs to '/tmp/repo'
hint: Updates were rejected because the remote contains work that you do
hint: not have locally. This is usually caused by another repository pushing
hint: to the same ref. You may want to first integrate the remote changes
hint: (e.g., 'git pull ...') before pushing again.
hint: See the 'Note about fast-forwards' in 'git push --help' for details.
```

但 Bob 认为这是 `rebase` 操作造成的，并决定强制 `push`：

```bash
ssmith$ git push --force
To /tmp/repo
 + f82f59e...c27aff1 dev -> dev (forced update)
```

然而，如果他使用了 `--force-with-lease`，则会得到不同的结果，因为 git 会检查远程分支，发现 从上一次 Bob 使用 `fetch` 到现在，实际上并没有被更新：

```
ssmith$ git push -n --force-with-lease
To /tmp/repo
 ! [rejected]        dev -> dev (stale info)
error: failed to push some refs to '/tmp/repo'
```

当然，在这有一些关于 git 的注意事项。上面展示的，只有当 Alice 已经将其更改推送到远程存储库时，它才有效。这不是一个严重的问题，但是如果她想修改她提交的东西，那她去 `pull` 分支时，会被提示合并被更改。

一个更微妙的问题是，我们有方法去骗 git，让 git 认为这个分支没有被修改。在正常使用情况下，最常发生这种现象的情况是，Bob 使用 `git fetch` `而不是 `git pull` `来更新他的本地副本。`fetch` 将从远程仓库拉出对象和引用，但没有匹配的 `merge` 则不会更新工作树。这将使本地仓库看起来已经与远程仓库进行了同步更新，但实际上本地仓库并没有进行更新，并欺骗 `--force-with-lease` 命令，成功覆盖远程分支，就像下面这个例子：

```
ssmith$ git push --force-with-lease
To /tmp/repo
 ! [rejected]        dev -> dev (stale info)
error: failed to push some refs to '/tmp/repo'

ssmith$ git fetch
remote: Counting objects: 3, done.
remote: Compressing objects: 100% (3/3), done.
remote: Total 3 (delta 0), reused 0 (delta 0)
Unpacking objects: 100% (3/3), done.
From /tmp/repo
   1a3a03f..d7cda55  dev        -> origin/dev

ssmith$ git push --force-with-lease
Counting objects: 9, done.
Delta compression using up to 8 threads.
Compressing objects: 100% (6/6), done.
Writing objects: 100% (9/9), 845 bytes | 0 bytes/s, done.
Total 9 (delta 0), reused 0 (delta 0)
To /tmp/repo
   d7cda55..b57fc84  dev -> dev
```

这个问题的最简单的答案就是，简单的说“不要在没有合并的情况下 `fetch` 远程该分支”（或者更常用的方法是 `pull`，这个操作包含了前面的两个），但是如果由于某种原因你希望在用 `--force-with-lease` 进行代码上传之前进行 `fetch`，那么这有一种比较安全的方法。像 git 那么多的属性一样，引用只是对象的指针，所以我们可以创建我们自己的引用。在这种情况下，我们可以在进行 `fetch` 之前，为远程仓库引用创建“保存点”的副本。然后，我们可以告诉 `--force-with-lease` 将此作为引用值，而不是已经更新的远程引用。

为了做到这一点，我们使用 git 的 `update-ref` 功能来创建一个新的引用，以保存远程仓库在任何 `rebase` 或 `fetch` 操作前的状态。这有效地标记了我们开始强制 `push` 到远程的工作节点。在这里，我们将远程分支 `dev` 的状态保存到一个名为 `dev-pre-rebase` 的新引用中：

```
ssmith$ git update-ref refs/dev-pre-rebase refs/remotes/origin/dev
```

这时呢，我们就可以进行 `rebase` 和 `fetch` 操作，然后使用保存的 `ref` 来保护远程仓库，以防有人在工作时做了更改：

```
ssmith$ git rebase master
First, rewinding head to replay your work on top of it...
Applying: Dev commit #1
Applying: Dev commit #2
Applying: Dev commit #3

ssmith$ git fetch
remote: Counting objects: 3, done.
remote: Compressing objects: 100% (3/3), done.
remote: Total 3 (delta 0), reused 0 (delta 0)
Unpacking objects: 100% (3/3), done.
From /tmp/repo
   2203121..a9a35b3  dev        -> origin/dev

ssmith$ git push --force-with-lease=dev:refs/dev-pre-rebase
To /tmp/repo
 ! [rejected]        dev -> dev (stale info)
error: failed to push some refs to '/tmp/repo'
```

我们可以看到 `--force-with-lease` 对于有时需要进行强制推送的 git 用户来说，是一个很有用的工具。但是，对于 `--force` 操作的所有风险来说，这并不是万能的，如果不了解它内部的工作及其注意事项，就不应该使用它。

但是，在最常见的用例中，开发人员只要按照正常的方式进行 `pull` 和 `push` 操作即可。偶尔使用下 `rebase`，这个命令提供了一些我们非常需要的，防止强制推送带来破坏的保护功能。因此，我希望在未来版本的 git（但可能 3.0 以前都不会实现），它将成为 `--force` 的默认行为，并且当前的行为将被降级到显示其实际行为的选项中，例如：`--force-replace-remote`。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
