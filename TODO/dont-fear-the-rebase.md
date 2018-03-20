> * 原文地址：[Don’t Fear The Rebase](https://hackernoon.com/dont-fear-the-rebase-bca683888dae)
> * 原文作者：本文已获原作者 [Jared Ready](https://hackernoon.com/@jared.ready) 授权，转载请注明出处。
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/dont-fear-the-rebase.md](https://github.com/xitu/gold-miner/blob/master/TODO/dont-fear-the-rebase.md)
> * 译者：
> * 校对者：

![](https://cdn-images-1.medium.com/max/2000/1*09KWDWnv1JDeZ-LEkXpL7g.png)

Git’s `rebase` command is a common source of fear and confusion for Git users, especially users who may have come from a more centralized version control system. That’s normal. Rebase is a weird, magical looking beast that just comes in and starts changing history willy-nilly.

Rebase is sort of like pointers; it is this confusing construct that everybody talks about but you have no idea why anybody would use it and then suddenly everything will *click* and the whole idea becomes glaringly obvious and incredibly simple.

I am here to force that *click* onto you so you can go into work and spread the wonder that is `git rebase`.

### What Even is a Rebase?

> Git Rebase is simply a tool that can be used to take some commits that were made in one place and just pretend they were made in another place all along.

**OK but what does that *mean*?**

Let’s look at an example. We have two branches in this repository: `master` and `feature/foo`. `feature/foo` was branched off of `master` and some commits were made on `feature/foo`. `master` has moved on because the world doesn’t just stop when you aren’t looking.

![](https://cdn-images-1.medium.com/max/1600/1*RQdhYt4nNVFKlpw_q_IYow.png)

Current state of affairs
We want to integrate the changes from `master` into `feature/foo` but we don’t want to deal with having a pesky merge commit every time we perform this integration.

**Rebase is a tool that gives you the power to integrate changes that happened on the source branch without performing a merge, and thus without having a merge commit.**

![](https://cdn-images-1.medium.com/max/2000/1*PZLwva5O5UoPxcrV68oYgQ.png)

Post-rebase. Visions of fast-forward…

Commits *D* and *F* have been *replayed* on top of `master`, which is currently pointing at commit *G*. You will notice that these commits are actually named *D`* and *F`* and the commit SHA-1 is different. Why is this?

#### Commits are Immutable in Git

A commit has a few properties that are relevant here: a parent commit, a timestamp, and a snapshot of the repository at the time of the commit (commits are not just changesets). These values are what Git uses when it computes the SHA-1 that identifies a commit.

Since commits are immutable and a SHA-1 should uniquely identify a single commit, Git has to create new commits that contain the same repository snapshot as the original commits, but each with a **different parent commit and timestamp**.

This leads to new commits that look identical to the original commits, but have different SHA-1s.

---

### Finding the Commits

How does git know what commits to move when we run `git rebase master` from `feature/foo`?

Let’s first look at a Venn diagram of the commits on each branch.

![](https://cdn-images-1.medium.com/max/1600/1*HbxYqw71A8ehVCTGkNOyWw.png)

Here we see that each branch has commits *A*, *B*, and *C*. `master` has commits *E *and *G *that `feature/foo` does not have. `feature/foo` has commits *F* and *D* that `master` does not have.

Git will perform a set subtraction, `{commits on feature/foo} — {commits on master}`, to find the right commits. This results in commits *D *and *F.*

![](https://cdn-images-1.medium.com/max/1600/1*qkRc0FH6CzwSse5CNrscfA.png)

#### Can we prove this?

Yes! An easy way is to use `git log` to see the exact commits that we get from this set subtraction.

`git log master..feature/foo`*should* show us commits `bc1f36b` and `640e713`.

![](https://cdn-images-1.medium.com/max/1600/1*g3VrmbNmzlpuOm3Fl9Fe8w.png)

Current branch is implied if you omit a branch after ..
This looks good so far. Let’s get a wider view to make sure I’m not yanking chains.

![](https://cdn-images-1.medium.com/max/1600/1*U2qcOyvEF6CiZycntHQ_6g.png)

These SHA-1s look familiar

![](https://cdn-images-1.medium.com/max/1600/1*zUQkjOT3zHCNp_6LjilQ4A.png)

76f5fd1 and 22033eb are missing because we diverged from master at 7559a0b

---

If we now perform a `rebase` onto `master`, we should see commits `76f5fd1` and `22033eb` immediately before the commits that were made on `feature/foo`.

![](https://cdn-images-1.medium.com/max/1600/1*VLXh6HY221LdULI_i79RyQ.png)

Git is replaying the commits that we expected

![](https://cdn-images-1.medium.com/max/1600/1*cCRyFq-dsWmZWWQ-8a-RJg.png)

Does this look familiar?

![](https://cdn-images-1.medium.com/max/1600/1*PZLwva5O5UoPxcrV68oYgQ.png)

We saw this earlier!
We now have a nice linear history. You should be able to see how a fast-forward merge would happen at this point.

> The rebase strategy has the added bonus of knowing that if your CI pipeline passes on the feature branch, it will pass on main branch post-merge. With a non-linear merge strategy, you do not have this guarantee.

---

### Using the Force

If `feature/foo` were already pushed and another push is attempted after this rebase, Git will very politely decline to do the push. Why is this?

**Git will do everything it can to prevent an accidental overwriting of history, which is a *good thing*.**

Let’s look at what Git thinks `feature/foo` looks like on the remote repository.

![](https://cdn-images-1.medium.com/max/1600/1*6v_6goRTKnPduN6q_x4Vpw.png)

Now let’s look at what we’re telling Git to do.

![](https://cdn-images-1.medium.com/max/1600/1*3zndxVsC81_e7okV0aQbVg.png)

From Git’s point of view, commits *D *and *F* are about to be lost. Git will give you a nice message along the lines of `Updates were rejected because the tip of your current branch is behind`.

You might say, “But I can clearly see in the nice picture that you made, `feature/foo` is further ahead than what it was before.” This is a good observation, but Git just sees that `feature/foo` on the remote repository contains `bc1f36b` and `640e713` and your local version of `feature/foo` does not contain those commits. So in order to not lose these commits, Git will politely decline a normal `git push`, requiring you to perform a `git push --force`.

---

If you take away one thing from this article, remember that a rebase simply finds commits that were made on some branch and creates new commits with the same content but with a new parent or *base* commit.

---

If you liked what you read then 👏 to show your appreciation!

Follow [Hackernoon](https://medium.com/@hackernoon) and [Jared Ready](https://medium.com/@jared.ready) for more quality software engineering content.

[![](https://cdn-images-1.medium.com/max/1600/1*PZjwR1Nbluff5IMI6Y1T6g@2x.png)](https://goo.gl/w4Pbea)

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
