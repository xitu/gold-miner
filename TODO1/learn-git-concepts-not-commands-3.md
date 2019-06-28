> * 原文地址：[Learn git concepts, not commands- Part 3](https://dev.to/unseenwizzard/learn-git-concepts-not-commands-4gjc)
> * 原文作者：[Nico Riedmann](https://dev.to/unseenwizzard)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/learn-git-concepts-not-commands-3.md](https://github.com/xitu/gold-miner/blob/master/TODO1/learn-git-concepts-not-commands-3.md)
> * 译者：
> * 校对者：

# Learn git concepts, not commands- Part 3

**An interactive git tutorial meant to teach you how git works, not just which commands to execute.**

So, you want to use git right?

But you don't just want to learn commands, you want to understand what you're using?

Then this is meant for you!

Let's get started!

---

> Based on the general concept from Rachel M. Carmena's blog post on [How to teach Git](https://rachelcarmena.github.io/2018/12/12/how-to-teach-git.html).
> 
> While I find many git tutorials on the internet to be too focused on what to do instead of how things work, the most invaluable resource for both (and source for this tutorial!) are the [git Book](https://git-scm.com/book/en/v2) and [Reference page](https://git-scm.com/docs).
> 
> So if you're still interested when you're done here, go check those out! I do hope the somewhat different concept of this tutorial will aid you in understanding all the other git features detailed there.

建议按照顺序阅读本系列文章：

- [Learn git concepts, not commands - Part 1](https://github.com/xitu/gold-miner/blob/master/TODO1/learn-git-concepts-not-commands-1.md)
- [Learn git concepts, not commands - Part 2](https://github.com/xitu/gold-miner/blob/master/TODO1/learn-git-concepts-not-commands-2.md)
- [Learn git concepts, not commands - Part 3](https://github.com/xitu/gold-miner/blob/master/TODO1/learn-git-concepts-not-commands-3.md)

---

* [Cherry-picking](#cherry-picking)
* [Rewriting history](#rewriting-history)
* [Reading history](#reading-history)

---

## Cherry-picking

> Congratulations! You've made it to the more advanced features!
> 
> By now you understand how to use all the typical git commands and more importantly how they work.
> 
> This will hopefully make the following concepts much simpler to understand than if I just told you what commands to type in.
> 
> So let's head right in an learn how to `cherry-pick` commits!

From earlier sections you still remember roughly what a `commit` is made off, right?

And how when you [`rebase`](#rebasing) a branch your commits are applied as new commits with the same **change set** and **message**?

Whenever you want to just take a few choice changes from one branch and apply them to another branch, you want to `cherry-pick` these commits and put them on your branch.

That is exactly what `git cherry-pick` allows you to do with either single commits or a range of commits.

Just like during a `rebase` this will actually put the changes from these commits into a new commit on your current branch.

Lets have a look at an example each for `cherry-pick`ing one or more commits:

The figure below shows three branches before we have done anything. Let's assume we really want to get some changes from the `add_patrick` branch into the `change_alice` branch. Sadly they haven't made it into master yet, so we can't just `rebase` onto master to get those changes (along with any other changes on the other branch, that we might not even want).

[![Branches before cherry-picking](https://res.cloudinary.com/practicaldev/image/fetch/s--DcmKB8P2--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://raw.githubusercontent.com/UnseenWizzard/git_training/master/img/cherry_branches.png)](https://res.cloudinary.com/practicaldev/image/fetch/s--DcmKB8P2--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://raw.githubusercontent.com/UnseenWizzard/git_training/master/img/cherry_branches.png)

So let's just `git cherry-pick` the commit **63fc421**.

The figure below visualizes what happens when we run `git cherry-pick 63fc421`

[![Cherry-picking a single commit](https://res.cloudinary.com/practicaldev/image/fetch/s--3eCyc1bO--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://raw.githubusercontent.com/UnseenWizzard/git_training/master/img/cherry_pick.png)](https://res.cloudinary.com/practicaldev/image/fetch/s--3eCyc1bO--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://raw.githubusercontent.com/UnseenWizzard/git_training/master/img/cherry_pick.png)

As you can see, a new commit with the changes we wanted shows up on branch.

> At this point note that like with any other kind of getting changes onto a branch that we've seen before, any conflicts that arise during a `cherry-pick` will have to be **resolved** by us, before the command can go through.
> 
> Also like all other commands you can either `--continue` a `cherry-pick` when you've resolved conflicts, or decide to `--abort` the command entirely.

The figure below visualizes `cherry-pick`ing a range of commits instead of a single one. You can simply do that by calling the command in the form `git cherry-pick <from>..<to>` or in our example below as `git cherry-pick 0cfc1d2..41fbfa7`.

[![Cherry-picking commit range](https://res.cloudinary.com/practicaldev/image/fetch/s--_-UHvfoF--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://raw.githubusercontent.com/UnseenWizzard/git_training/master/img/cherry_pick_range.png)](https://res.cloudinary.com/practicaldev/image/fetch/s--_-UHvfoF--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://raw.githubusercontent.com/UnseenWizzard/git_training/master/img/cherry_pick_range.png)

## Rewriting history

> I'm repeating myself now, but you still remember [`rebase`](#rebasing) well enough right? Else quickly jump back to that section, before continuing here, as we'll use what we already know when learning about how change history!

As you know a `commit` basically contains your changes, a message and few other things.

The 'history' of a branch is made up of all it's commits.

But lets say you've just made a `commit` and then notice, that you've forgotten to add a file, or you made a typo and the change leaves you with broken code.

We'll briefly look at two things we could do to fix that, and make it look like it never happened.

Let's switch to a new branch with `git checkout -b rewrite_history`.

Now make some changes to both `Alice.txt` and `Bob.txt`, and then `git add Alice.txt`.

Then `git commit` using a message like "This is history" and you're done.

Wait, did I say we're done? No, you'll clearly see that we've made some mistakes here:

* We forgot to add the changes to `Bob.txt`
* We didn't write a [good commit message](https://chris.beams.io/posts/git-commit/)

### Amending the last Commit

One way to fix both of these in one go would be to `amend` the commit we've just made.

`Amend`ing the latest commit basically works just like making a new one.

Before we do anything take a look at your latest commit, with `git show {COMMIT}`. Put either the commit hash (which you'll probably still see in your command line from the `git commit` call, or in the `git log`), or just **HEAD**.

Just like in the `git log` you'll see the message, author, date and of course changes.

Now let's `amend` what we've done in that commit.

`git add Bob.txt` to get the changes to the **Staging Area**, and then `git commit --amend`.

What happens next is your latest commit being unrolled, the new changes from the **Staging Area** added to the existing one, and the editor for the commit message opening.

In the editor you'll see the previous commit message.

Feel free to change it to something better.

After you're done, take another look at the latest commit with `git show HEAD`.

As you've certainly expected by now, the commit hash is different. The original commit is gone, and in it's place there is a new one, with the combined changes and new commit message.

> Note how the other commit data like author and date are unchanged from the original commit. You can mess with those too, if you really want, by using the extra `--author={AUTHOR}` and `--date={DATE}` flags when amending.

Congratulations! You've just successfully re-written history for the first time!

### Interactive Rebase

Generally when we `git rebase`, we `rebase` onto a branch. When we do something like `git rebase origin/master`, what actually happens, is a rebase onto the **HEAD** of that branch.

In fact if we felt like it, we could `rebase` onto any commit.

> Remember that a commit contains information about the history that came before it

Like many other commands `git rebase` has an **interactive** mode.

Unlike most others, the **interactive** `rebase` is something you'll probably be using a lot, as it allows you to change history as much as you want.

Especially if you follow a work-flow of making many small commits of your changes, which allow you to easily jump back if you made a mistake, **interactive** `rebase` will be your closest ally.

**Enough talk! Lets do something!**

Switch back to your **master** branch and `git checkout` a new branch to work on.

As before, we'll make some changes to both `Alice.txt` and `Bob.txt`, and then `git add Alice.txt`.

Then we `git commit` using a message like "Add text to Alice".

Now instead of changing that commit, we'll `git add Bob.txt` and `git commit` that change as well. As message I used "Add Bob.txt".

And to make things more interesting, we'll make another change to `Alice.txt` which we'll `git add` and `git commit`. As a message I used "Add more text to Alice".

If we now have a look at the branch's history with `git log` (or for just a quick look preferably with `git log --oneline`), we'll see our three commits on top of whatever was on your **master**.

For me it looks like this:

```
git log --oneline
0b22064 (HEAD -> interactiveRebase) Add more text to Alice
062ef13 Add Bob.txt
9e06fca Add text to Alice
df3ad1d (origin/master, origin/HEAD, master) Add Alice
800a947 Add Tutorial Text
```

There's two things we'd like to fix about this, which for the sake of learning different things, will be a bit different than in the previous section on `amend`:

* Put both changes to `Alice.txt` in a single commit
* Consistently name things, and remove the **.txt** from the message about `Bob.txt`

To change the three new commits, we'll want to rebase onto the commit just before them. That commit for me is `df3ad1d`, but we can also reference it as the third commit from the current **HEAD** as `HEAD~3`

To start an **interactive** `rebase` we use `git rebase -i {COMMIT}`, so let's run `git rebase -i HEAD~3`

What you'll see is your editor of choice showing something like this:

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

Note as always how `git` explains everything you can do right there when you call the command.

The **Commands** you'll probably be using most are `reword`, `squash` and `drop`. (And `pick` but that one's there by default)

Take a moment to think about what you see and what we're going to use to achieve our two goals from above. I'll wait.

Got a plan? Perfect!

Before we start making changes, take note of the fact, that the commits are listed from oldest to newest, and thus in the opposite direction of the `git log` output.

I'll start off with the easy change and make it so we get to change the commit message of the middle commit.

```
pick 9e06fca Add text to Alice
reword 062ef13 Add Bob.txt
pick 0b22064 Add more text to Alice
# Rebase df3ad1d..0b22064 onto df3ad1d (3 commands)
[...]
```

Now to getting the two changes of `Alice.txt` into one commit.

Obviously what we want to do is to `squash` the later of the two into the first one, so let's put that command in place of the `pick` on the second commit changing `Alice.txt`. For me in the example that's **0b22064**.

```
pick 9e06fca Add text to Alice
reword 062ef13 Add Bob.txt
squash 0b22064 Add more text to Alice
# Rebase df3ad1d..0b22064 onto df3ad1d (3 commands)
[...]
```

Are we done? Will that do what we want?

It wont right? As the comments in the file tell us:

```
# s, squash = use commit, but meld into previous commit
```

So what we've done so far, will merge the changes of the second Alice commit, with the Bob commit. That's not what we want.

Another powerful thing we can do in an **interactive** `rebase` is changing the order of commits.

If you've read what the comments told you carefully, you already know how: Simply move the lines!

Thankfully you're in your favorite text editor, so go ahead and move the second Alice commit after the first.

```
pick 9e06fca Add text to Alice
squash 0b22064 Add more text to Alice
reword 062ef13 Add Bob.txt
# Rebase df3ad1d..0b22064 onto df3ad1d (3 commands)
[...]
```

That should do the trick, so close the editor to tell `git` to start executing the commands.

What happens next is just like a normal `rebase`: starting with the commit you've referenced when starting it, each of the commits you have listed will be applied one after the other.

> Right now it won't happen, but when you re-order actual code changes, it may happen, that you run into conflicts during the `rebase`. After all you've possibly mixed up changes that were building on each other.
> 
> Just [resolve](#resolving-conflicts) them, as you would usually.

After applying the first commit, the editor will open and allow you to put a new message for the commit combining the changes to `Alice.txt`. I've thrown away the text of both commits and put "Add a lot of very important text to Alice".

After you close the editor to finish that commit, it will open again to allow you to change the message of the `Add Bob.txt` commit. Remove the ".txt" and continue by closing the editor.

That's it! You've rewritten history again. This time a lot more substantially than when `amend`ing!

If you look at the `git log` again, you'll see that there's two new commits in place of the three that we had previously. But by now you're used to what `rebase` does to commits and have expected that.

```
git log --oneline
105177b (HEAD -> interactiveRebase) Add Bob
ed78fa1 Add a lot very important text to Alice
df3ad1d (origin/master, origin/HEAD, master) Add Alice
800a947 Add Tutorial Text
```

### Public History, why you shouldn't rewrite it, and how to still do it safely

As noted before, changing history is a incredibly useful part of any work-flow that involves making a lot of small commits while you work.

While all the small atomic changes make it very easy for you to e.g. verify that with each change your test-suite still passes and if it doesn't, remove or amend just these specific changes, the 100 commits you've made to write `HelloWorld.java` are probably not something you want to share with people.

Most likely what you want to share with them, are a few well formed changes with nice commit messages telling your colleagues what you did for which reason.

As long as all those small commits only exist in your **Dev Environment**, you're perfectly save to do a `git rebase -i` and change history to your hearts content.

Things get problematic when it comes to changing **Public History**. That means anything that has already made it to the **Remote Repository**.

At this point is has become **public** and other people's branches might be based on that history. That really makes it something you generally don't want to mess with.

The usual advice is to "Never rewrite public history!" and while I repeat that here, I've got to admit, that there is a decent amount of cases in which you might still want to rewrite **public history**.

In all of theses cases that history isn't 'really' **public** though. You most certainly don't want to go rewriting history on the **master** branch of an open source project, or something like your company's **release** branch.

Where you might want to rewrite history are branches that you've `push`ed just to share with some colleagues.

You might be doing trunk-based development, but want to share something that doesn't even compile yet, so you obviously don't want to put that on the main branch knowingly.

Or you might have a work-flow in which you share feature branches.

Especially with feature branches you hopefully `rebase` them onto the current **master** frequently. But as we know, a `git rebase` adds our branch's commits as **new** commits on top of the thing we're basing them on. This rewrites history. And in the case of a shared feature branch it rewrites **public history**.

So what should we do if we follow the "Never rewrite public history" mantra?

Never rebase our branch and hope it still merges into **master** in the end?

Not use shared feature branches?

Admittedly that second one is actually a reasonable answer, but you might still not be able to do that. So the only thing you can do, is to accept rewriting the **public history** and `push` the changed history to the **Remote Repository**.

If you just do a `git push` you'll be notified that you're not allowed to do that, as your **local** branch has diverged from the **remote** one.

You will need to `force` pushing the changes, and overwrite the remote with your local version.

As I've highlighted that so suggestively, you're probably ready to try `git push --force` right now. You really shouldn't do that if you want to rewrite **public history** safely though!

You're much better off using `--force`'s more careful sibling `--force-with-lease` !

`--force-with-lease` will check if your **local** version of the **remote** branch and the actual **remote** match, before `push`ing.

By that you can ensure that you don't accidentally wipe any changes someone else may have `push`ed while you where rewriting history!

[![What happens in a push --force-with-lease](https://res.cloudinary.com/practicaldev/image/fetch/s--K0b0QO_X--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://raw.githubusercontent.com/UnseenWizzard/git_training/master/img/force_push.png)](https://res.cloudinary.com/practicaldev/image/fetch/s--K0b0QO_X--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://raw.githubusercontent.com/UnseenWizzard/git_training/master/img/force_push.png)

And on that note I'll leave you with a slightly changed mantra:

**Don't rewrite public history unless you're really sure about what you're doing. And if you do, be safe and force-with-lease.**

## Reading history

Knowing about the differences between the areas in your **Dev Environment** - especially the **Local Repository** - and how commits and the history work, doing a `rebase` should not be scary to you.

Still sometimes things go wrong. You may have done a `rebase` and accidentally accepted the wrong version of file when resolving a conflict.

Now instead of the feature you've added, there's just your colleagues added line of logging in a file.

Luckily `git` has your back, by having a built in safety feature called the **Reference Logs** AKA `reflog`.

Whenever any **reference** like the tip of a branch is updated in your **Local Repository** a **Reference Log** entry is added.

So theres a record of any time you make a `commit`, but also of when you `reset` or otherwise move the `HEAD` etc.

Having read this tutorial so far, you see how this might come in handy when we've messed up a `rebase` right?

We know that a `rebase` moves the `HEAD` of our branch to the point we're basing it on and the applies our changes. An interactive `rebase` works similarly, but might do things to those commits like **squashing** or **rewording** them.

If you're not still on the branch on which we practiced [interactive rebase](#interactive-rebase), switch to it again, as we're about to practice some more there.

Lets have a look at the `reflog` of the things we've done on that branch by - you've guessed it - running `git reflog`.

You'll probably see a lot of output, but the first few lines on the top should be similar to this:

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

There it is. Every single thing we've done, from switching to the branch to doing the `rebase`.

Quite cool to see the things we've done, but useless on it's own if we messed up somewhere, if it wasn't for the references at the start of each line.

If you compare the `reflog` output to when we looked at the `log` the last time, you'll see those points relate to commit references, and we can use them just like that.

Let's say we actually didn't want to do the rebase. How do we get rid of the changes it made?

We move `HEAD` to the point before the `rebase` started with a `git reset 0b22064`.

> `0b22064` is the commit before the `rebase` in my case. More generally you can also reference it as **HEAD four changes ago** via `HEAD@{4}`. Note that should you have switched branches in between or done any other thing that creates a log entry, you might have a higher number there.

If you take a look at the `log` now, you'll see the original state with three individual commits restored.

But let's say we now realize that's not what we wanted. The `rebase` is fine, we just don't like how we changed the message of the Bob commit.

We could just do another `rebase -i` in the current state, just like we did originally.

Or we use the reflog and jump back to after the rebase and `amend` the commit from there.

But by now you know how to do either of that, so I'll let you try that on your own. And in addition you also know that there's the `reflog` allowing you to undo most things you might end up doing by mistake.

欢迎继续阅读本系列其他文章：

- [Learn git concepts, not commands - Part 1](https://github.com/xitu/gold-miner/blob/master/TODO1/learn-git-concepts-not-commands-1.md)
- [Learn git concepts, not commands - Part 2](https://github.com/xitu/gold-miner/blob/master/TODO1/learn-git-concepts-not-commands-2.md)
- [Learn git concepts, not commands - Part 3](https://github.com/xitu/gold-miner/blob/master/TODO1/learn-git-concepts-not-commands-3.md)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
