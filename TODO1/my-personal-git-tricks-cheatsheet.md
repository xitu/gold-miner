> * 原文地址：[My Personal Git Tricks Cheatsheet](https://dev.to/antjanus/my-personal-git-tricks-cheatsheet-23j1)
> * 原文作者：[Antonin Januska](https://dev.to/antjanus)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/my-personal-git-tricks-cheatsheet.md](https://github.com/xitu/gold-miner/blob/master/TODO1/my-personal-git-tricks-cheatsheet.md)
> * 译者：
> * 校对者：

# My Personal Git Tricks Cheatsheet

Besides the "basic" commands of Git, everyone has their own little Git tricks they use. I wanted to quickly write a list of my own which I tend to alias in my `.gitconfig`. Scroll to the bottom to see some fun `git` related commands that run outside of git! :)

## Quick amend

I often forget to commit a file, or leave a `console.log` in. I absolutely hate doing commits like `removed console.log`. So instead, I add the file as if I was going to make a commit and run:

```
git commit --amend --reuse-message HEAD
```

Which will add the file to the last commit and reuse the old commit message. I alias this one as `git amend` for quickfixes

**NOTE** Based on feedback below, it's also possible to do `git commit --amend --no-edit` for the same effect.

## Rebase on top of origin/master

Older branches often fall behind pretty far, so far that I have to get up to speed to eliminate build errors, ci errors, or just resolve conflicts. My favorite is to do the following:

```
git fetch origin # fetch latest origin
git rebase origin/master
```

This way, I'm stacking my current branch commits on top of the latest version of master!

## Last commit

Sometimes, the `git log` gets overwhelming. Due to my frequent use of the aforementioned `amend` command, i tend to want to view just the last commit in my git log:

```
git log -1
```

## checkout older version of a file (like a lock file!)

Occasionally, I screw up a file unrelated to my branch. Mostly, that happens with lock files (mix.lock, package-lock.json, etc.). Rather than reverting a commit which probably contained a bunch of other stuff, I just "reset" the file back to an older version

```
git checkout hash-goes-here mix.lock
```

And then I can commit the fix!

## cherry-pick

An underrated command that I occasionally use. When a branch gets stale, it's sometimes easier to just get the stuff you really need from it rather than try to get the entire branch up to speed. A good example, for me, have been branches that involve UI/backend code that is no longer necessary. In that case, I might want to cherry pick only certain commits from the branch

```
git cherry-pick hash-goes-here
```

This will magically bring that commit over to the branch you're on. You can also do a list!

```
git cherry-pick first-hash second-hash third-hash
```

You can also do a range

```
git cherry-pick first-hash..last-hash
```

### The reflog

This is such a power-user feature that I **rarely** use it. I mean, once a year! But it's good to know about it. Sometimes, I lose commits. I delete a branch or reset or amend a commit I didn't mean to mess up.

In those situations, it's good to know `reflog` exists. It's not a log of individual commits for the branch you're on, it's a log of all of your commits -- even ones that were on dead branches. However, the log gets emptied from time to time (pruned) so that only relevant information stays.

```
git reflog
```

The command returns a log and what's useful is cherry-picking or rebasing on top of a commit. Very powerful when you pipe into `grep`.

## Bash command aliases

Aside from git commands, I like to also use some fun bash aliases to help my workflow

### Current branch

To get the name of the current branch, I have this alias:

```
alias git-branch="git branch | sed -n -e 's/^\* \(.*\)/\1/p'"
```

When I run `git-branch` or run `$(git-branch)` in another command, I'll get the name of the current branch I'm on.

**NOTE** Based on feedback in the comments, I switched this over to `git symbolic-ref --short HEAD` which works just as well but you can actually read it.

### Track upstream branch

While I'm sure this is doable in the `.gitconfig`, I've yet to figure out how. When I run the first push on a new branch, I always get asked to setup the branch for upstream tracking. Here's my alias for that:

```
alias git-up="git branch | sed -n -e 's/^\* \(.*\)/\1/p' | xargs git push -u origin "
```

Now when I run `git-up`, I push my current branch and setup upstream tracking!

## Feedback

Based on some of the very helpful feedback in the comments, I made some adjustments to what I'm using.

### Current branch

It looks like there are a bunch of new ways to get the current branch name. If you scroll up, you'll see that I've used a crazy `sed` parsing command to get the branch name.

Here's my new alternative:

```
alias git-branch="git symbolic-ref --short HEAD"
```

And it seems to work exactly as you'd expect!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
