> * 原文地址：[Git aliases I can't live without](http://mjk.space/git-aliases-i-cant-live-without/)
> * 原文作者：[MICHAŁ KONARSKI](http://mjk.space)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/git-aliases-i-cant-live-without.md](https://github.com/xitu/gold-miner/blob/master/TODO1/git-aliases-i-cant-live-without.md)
> * 译者：
> * 校对者：

# Git aliases I can't live without

People are often surprised and curious at the same time when they see how I work with Git:

![My Git workflow](http://mjk.space/images/blog/git-aliases/workflow.gif) _My Git workflow_

My love for aliases started when I installed _zsh_ and its addon suite _[oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh)_ for the first time. It contains a big set of predefined aliases and helper functions for different command line programs. I immediately liked the concept of typing just few letters instead of regular, long, parametrized invocations. The tool that I work with most often is Git, so it was a natural candidate for the alias revolution. Now, few years later, I can’t imagine using Git with the `git` command itself.

Of course, Git has its own [system for defining aliases](https://git-scm.com/book/en/v2/Git-Basics-Git-Aliases), which is perfectly fine. Personally I just don’t like that space between `git` and the alias. Shell aliases are also more flexible and can be used for other commands too, e.g. `docker`.

Below you’ll find the list of aliases that I use the most. Some of them come directly from _oh-my-zsh_ and some were created by me. I hope you’ll find at least some of them useful! If you want to try all them on your own - just go and grab them from [my repository](https://github.com/mjkonarski/oh-my-git-aliases).

### 1. Let’s start working with this repo!

`alias gcl = git clone`

This is maybe not the most frequent Git command programmers use, but I personally like to get my hands on this _awesome-github-project-I-have-just-seen_ as soon as possible.

### 2. Download the latest state from the remote

`alias gf = git fetch`

I usually use fetch to get the newest changes from the remote repository because it doesn’t affect working directory and _HEAD_ in any way. Later I can use other commands to modify local files explicitly.

### 3. Let’s see some other branch!

`alias gco = git checkout`

This is definitely one of the most useful commands on the daily basis. One of the reasons I had decided to write this article is that I still see people writing `git checkout` everytime they want to switch to other branch.

### 4. Get back to the previous branch!

`gco -`

This dash is a little trick that means “the previous branch”. I know that strictly speaking this is not an alias, but it’s just too useful not to mention. Also I’ve got the impression that not many people know about it.

`checkout` is not the only option that accepts a dash - you can use it also with e.g. `merge`, `cherry-pick` and `rebase`.

### 5. Get me to master quickly!

`alias gcm = git checkout master`

If we switch often between some well defined branches, why don’t make it as simple as possible? Depending on your workflow you can also find other similar aliases useful: `gcd` (_develop_), `gcu` (_uat_), `gcs` (_stable_).

### 6. Where am I and what’s going on?

`alias gst = git status`

Simple and self explanatory.

### 7. I don’t care about the current working changes, just give me the latest state from origin!

`alias ggrh = git reset --hard origin/$(current_branch)`

My personal favourite. How many times have you made such a terrible mess that you just wanted to get both staging area and working directory back to their original state? Now it’s only four keystrokes away.

Please note that this particular command resets the current branch to the latest commit from _origin_. This is exactly what _I_ usually need, but may not be the thing that _you_ need. I use it every time I don’t care about local changes and I simply want my current branch to reflect its remote counterpart. You may say that `git pull` can be used instead, but I just don’t like the fact that it tries to merge remote branch instead of just reset the current one to it.

Note that `current_branch` is a custom function (made by the author of _oh-my-zsh_). You can see it e.g. [here](https://github.com/mjkonarski/oh-my-git-aliases/blob/master/oh-my-git-aliases.sh#L71).

### 8. What are the current changes?

`alias gd = git diff`

Another classic. It simply shows all changes made but not yet staged. If you want to see what changes had been already staged, use this version:

`alias gdc = git diff --cached`

### 9. Let’s commit these changed files!

`alias gca = git commit -a`

This commits all changed files, so you don’t need to add them manually. However, if there are some new files, that had not been committed yet, obviously you need to point to them explicitly:

`alias ga = git add`

### 10. I have some changes that I’d like to add to the previous commit!

`alias gca! = git commit -a --amend`

I use this one very often, as I like to keep my Git history clean and tidy (no “pull request fixes” or “forgot to add this file” type of commit messages). It simply takes all changes and adds them to the previous commit.

### 11. I did the previous one too quick, how to “uncommit” a file?

```
gfr() { 
    git reset @~ "$@" && git commit --amend --no-edit 
}
```

This one is a function, not an alias, and may seem a bit complicated at the first glance. It takes a name of a file you want to “uncommit”, removes all changes made to this file from the _HEAD_ commit, but leaves it untouched in the working directory. Then it’s ready to be staged again, maybe as a separate commit. This is how it works in practice:

![grf example](http://mjk.space/images/blog/git-aliases/grf.gif)

### 12. Ok, ready to push!

`alias ggpush = git push origin $(current_branch)`

I use this one every time I want to do a push. Because it implicitly passes the remote branch argument I can be sure that only one branch is pushed, regardless of the `push.default` [setting](https://git-scm.com/docs/git-config#git-config-pushdefault). Starting with Git 2.0 this is the default behaviour anyway, but the alias gives me extra safety in case I’d work with some legacy Git version.

This is maybe not that critical with a normal push, but critical as hell with the next command.

### 13. I’m ready to push and I know what I’m doing

`alias ggpushf = git push --force-with-lease origin $(current_branch)`

Pushing with force is clearly a controversial habit and many people will say that you should never ever do that. I agree, but only when it comes to critical, shared branches like _master_.

As I’ve already mentioned, I like to keep my git history clean. That sometimes involves changing already pushed commits. The `--force-with-lease` switch is particularly useful here, as it rejects the push when your local repository doesn’t have the latest state of the remote branch. Therefore it’s not possible to discard someone else’s modifications. At least not unintentionally.

I started using this alias with remote branch name part set to `$(current_branch)` after my colleague had once mistakenly invoked `git commit -f` (with `push.default` set to `matching`) and force-pushed all local branches to the _origin_. Including an old version of _master_. I still remember the panic in his eyes after he realised what had happened.

### 14. Oh no, the push has been rejected! Somebody has been touching my branch!

You tried to push your branch to the remote repository, but got the following message:

```
To gitlab.com:mjkonarski/my-repo.git
 ! [rejected]        my-branch -> my-branch (non-fast-forward)
error: failed to push some refs to 'git@gitlab.com:mjkonarski/my-repo.git'
hint: Updates were rejected because the tip of your current branch is behind
hint: its remote counterpart. Integrate the remote changes (e.g.
hint: 'git pull ...') before pushing again. 
```

This happens when more that one person works on the same branch. Maybe your colleague had pushed a change when you were not looking? Or you used two computers, not syncing the branch before? Here’s a simple solution:

`alias glr = git pull --rebase`

It pulls the latests changes and rebases your commits on the top of them automatically. If you’re lucky enough (and the remote changes were made to different files) you may even avoid resolving conflicts. Voilà, ready to push again!

### 15. I want my branch to reflect the latest changes from master!

Let’s say that you have a branch you’ve created from _master_ some time ago. You’ve pushed some changed, but in the meantime _master_ itself had also been updated. Now you’d like your branch to reflect those latests commits. I strongly prefer rebasing over merging in that case - your commit history stays short and clean. It’s as easy as typing:

`alias grbiom = git rebase --interactive origin/master`

I use this command so often that this alias was one of the first I’ve started using. The `--interactive` switch spins up your favourite editor and lets you quickly check the list of commits that are about to be rebased on master. You can also use this opportunity to _squash_, _reword_ or _reorder_ commits. So many options with that simple alias!

### 16. Damn, I tried to rebase, but wild conflicts appeared! Get me the hell out of here!

Nobody likes getting this message:

```
CONFLICT (content): Merge conflict in my_file.md

Resolve all conflicts manually, mark them as resolved with
"git add/rm <conflicted_files>", then run "git rebase --continue".
You can instead skip this commit: run "git rebase --skip".
To abort and get back to the state before "git rebase", run "git rebase --abort".
```

Sometimes you may want just to abort the whole process and leave resolving the conflict for later. The above message gives a clue how to do it, but why in so many keystrokes?

`alias grba = git rebase --abort`

And we’re safe again. When you finally find the courage to do the merge again and resolve these conflicts, after `git add`-ing them you can simply carry on with the rebase typing:

`alias grbc = git rebase --continue`

### 17. Put these changes away for a second, please!

Let’s say you had made some changes, but haven’t committed them yet. Now you want to quickly switch to a different branch and do some unrelated work:

`alias gsta = git stash`

This commit puts your modifications aside and reverts the clean state of _HEAD_.

### 18. Now, give them back!

When you’re done with your unrelated work you may bring back your changes with a quick:

`alias gstp = git stash pop`

### 19. This one little commit looks nice, let’s put it on my branch!

Git has a nice feature called _cherry-pick_. You can use it to add any existing commit to the top of your current branch. It’s as simple as using this alias:

`alias gcp = git cherry-pick`

This can of course lead to a conflict, depending on a content of this commit. Resolving this conflict is exactly the same as resolving rebase conflicts. Therefore we’ve got similar options to abort and continue cherry picking as well:

`alias gcpa = git cherry-pick --abort`

`alias gcpc = git cherry-pick --continue`

* * *

The above list for sure doesn’t cover all possible git use cases. I’d like to encourage you to take it as a good start for building your own suite of aliases. It’s always a good idea to seek for possible improvements in your daily workflow.

You can find all these aliases (and more!) in [my Github repository](https://github.com/mjkonarski/oh-my-git-aliases).

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
