
> * 原文地址：[-force considered harmful; understanding git's --force-with-lease](https://developer.atlassian.com/blog/2015/04/force-with-lease/)
> * 原文作者：[Steve Smith](https://legacy-developer.atlassian.com/blog/authors/ssmith/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/force-with-lease.md](https://github.com/xitu/gold-miner/blob/master/TODO/force-with-lease.md)
> * 译者：
> * 校对者：

# -force considered harmful; understanding git's --force-with-lease

Git's `push --force` is destructive because it unconditionally overwrites the remote repository with whatever you have locally, possibly overwriting any changes that a team member has pushed in the meantime. However there is a better way; the option --force-with-lease can help when you do need to do a forced push but still ensure you don't overwrite other's work.

![I don't always push --force...](https://developer.atlassian.com/blog/2015/04/force-with-lease/force-with-lease.jpg)

It's well known that git's `push --force` is strongly discouraged as it can destroy other commits already pushed to a shared repository. This isn't always completely fatal (if the changes are in someone's working tree then they can be merged), but at the very least it's inconsiderate, at worst disastrous. This is because the `--force` option makes the head of the branch point at your personal history, ignoring any changes that may have occurred in parallel with yours.

One of the most common causes of force pushes is when we're forced to rebase a branch. To illustrate this, let's have a quick example. We have a project with a feature branch that both Alice and Bob are going to work on. They both `clone` this repository and start work.

Alice initially completes her part of the feature, and `push`es this up to the main repository. This is all well and good.

Bob also finishes his work, but before pushing it up he notices some changes had been merged into master. Wanting to keep a clean tree, he performs a rebase against the master branch. Of-course, when he goes to push this rebased branch it will be rejected. However not realising that Alice has already pushed her work, he performs a `push --force`. Unfortunately, this will erase all record of Alice's changes in the central repository.

The problem here is that when doing a force push Bob doesn't know why his changes have been rejected, so he assumes that it's due to the rebase, not due to Alice's changes. This is why `--force` on shared branches is an absolute no-no; and with the central-repository workflow any branch can potentially be shared.

But `--force` has a lesser-known sibling that *partially* protects against damaging forced updates; this is `--force-with-lease`.

What `--force-with-lease` does is refuse to update a branch unless it is the state that we expect; i.e. nobody has updated the branch upstream. In practice this works by checking that the upstream ref is what we expect, because refs are hashes, and implicitly encode the chain of parents into their value.

You can tell `--force-with-lease` exactly what to check for, but by default will check the current remote ref. What this means in practice is that when Alice updates her branch and pushes it up to the remote repository, the ref pointing head of the branch will be updated. Now, unless Bob does a pull from the remote, his *local* reference to the remote will be out of date. When he goes to push using `--force-with-lease`, git will check the local ref against the new remote and refuse to force the push. `--force-with-lease` effectively only allows you to force-push if no-one else has pushed changes up to the remote in the interim. It's `--force` with the seatbelt on. A quick demonstration of it in action may help clarify this:

Alice has made some changes to the branch and has pushed to the main repository. But here Bob rebases the branch against master:

```
ssmith$ git rebase master
First, rewinding head to replay your work on top of it...
Applying: Dev commit #1
Applying: Dev commit #2
Applying: Dev commit #3
```

Having rebased, he attempts to push, but the server rejects it as it would overwrite Alice's work:

```
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

But Bob assumes that this is due to the rebase, and decides to push it anyway:

```
ssmith$ git push --force
To /tmp/repo
 + f82f59e...c27aff1 dev -> dev (forced update)
```

However, if he had used `--force-with-lease`, he would have had a different result, as git would have checked that the remote branch had not in-fact been updated since Bob last fetched it:

```
ssmith$ git push -n --force-with-lease
To /tmp/repo
 ! [rejected]        dev -> dev (stale info)
error: failed to push some refs to '/tmp/repo'
```

Of course, this being git there are some caveats. The standard one is that this only works if Alice has already pushed her changes up to the remote repository. This is not a serious problem, however as when she goes to pull the rebased branch she'll be prompted to merge the changes in; if she wishes she can alternatively rebase her work onto it.

A more subtle problem is that it is possible to trick git into thinking that a branch has not been modified when it has. The main way that this would happen under normal usage is when Bob uses `git fetch` rather than `git pull` to update his local copy. The `fetch` will pull the objects and refs from the remote, but without a matching `merge` does not update the working tree. This will make it look as if the working copy of the remote is up to date with the remote without actually including the new work, and trick `--force-with-lease` into overwriting the remote branch, as you can see in this example:

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

The simplest answer to this issue is to simply say "Don't fetch without a merge" (or more commonly just do pull, which does both), but if for some reason you wish to fetch before pushing with `--force-with-lease` there is a way to do this safely. As with so many things git, refs are just arbitrary pointers to objects, so we can just create our own. In this case we can create a "save-point" copy of the remote ref before we perform the fetch. We can then tell `--force-with-lease` to use this ref as the expected value rather than the updated remote ref.

To do this we use git's `update-ref` feature to create a new ref to save the remote state before any rebase or fetch operations. This effectively bookmarks the point at which we start the work we're going to force push to the remote. In this we're saving the state of the remote branch `dev` to a new ref called `dev-pre-rebase`:

```
ssmith$ git update-ref refs/dev-pre-rebase refs/remotes/origin/dev
```

At this point we can do the rebase, fetch and then use the saved ref to protect the remote repository in case anyone has pushed up changes while we were working:

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

As we can see `--force-with-lease` is a useful tool for the git user who sometimes needs to force-push. But it is far from a panacea for all the risks of `--force`, and it should not be used without first understanding how it works internally and its caveats.

But in its most common use case where the developers just push and pull as normal, with the occasional rebase, it provides some much needed protection against damaging forced pushes. For this reason, I would hope that in a future version of git (but probably not until 3.0) it would become the default behaviour of `--force`, and that that the current behaviour would be relegated to an option that shows its actual behaviour such as `--force-replace-remote`.


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
