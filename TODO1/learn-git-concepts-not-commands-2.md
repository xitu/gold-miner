> * 原文地址：[Learn git concepts, not commands](https://dev.to/unseenwizzard/learn-git-concepts-not-commands-4gjc)
> * 原文作者：[Nico Riedmann](https://dev.to/unseenwizzard)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/learn-git-concepts-not-commands-2.md](https://github.com/xitu/gold-miner/blob/master/TODO1/learn-git-concepts-not-commands-2.md)
> * 译者：
> * 校对者：

# Learn git concepts, not commands- Part 2

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

- [Learn git concepts, not commands- Part 2](#learn-git-concepts-not-commands--part-2)
  - [Merging](#merging)
    - [Fast-Forward merging](#fast-forward-merging)
    - [Merging divergent branches](#merging-divergent-branches)
    - [Resolving conflicts](#resolving-conflicts)
  - [Rebasing](#rebasing)
    - [Resolving conflicts](#resolving-conflicts-1)
  - [Updating the **Dev Environment** with remote changes](#updating-the-dev-environment-with-remote-changes)
    - [Fetching Changes](#fetching-changes)
    - [Pulling Changes](#pulling-changes)
    - [Stashing changes](#stashing-changes)
    - [Pulling with Conflicts](#pulling-with-conflicts)

---

## Merging

As you and everyone else will generally be working on branches, we need to talk about how to get changes from one branch into the other by **merging** them.

We've just changed `Alice.txt` on the `change_alice` branch, and I'd say we're happy with the changes we made.

If you go and `git checkout master`, the `commit` we made on the other branch will not be there. To get the changes into master we need to `merge` the `change_alice` branch **into** master.

Note that you always `merge` some branch **into** the one you're currently at.

### Fast-Forward merging

As we've already `checked out` master, we can now `git merge change_alice`.

As there are no other **conflicting** changes to `Alice.txt`, and we've changed nothing on **master**, this will go through without a hitch in what is called a **fast forward** merge.

In the diagrams below, you can see that this just means that the **master** pointer can simply be advanced to where the **change_alice** one already is.

The first diagram shows the state before our `merge`, **master** is still at the commit it was, and on the other branch we've made one more commit.

[![Before fast forward merge](https://res.cloudinary.com/practicaldev/image/fetch/s--sS6CJ1Rg--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://raw.githubusercontent.com/UnseenWizzard/git_training/master/img/before_ff_merge.png)](https://res.cloudinary.com/practicaldev/image/fetch/s--sS6CJ1Rg--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://raw.githubusercontent.com/UnseenWizzard/git_training/master/img/before_ff_merge.png)

The second diagram shows what has changed with our `merge`.

[![After fast forward merge](https://res.cloudinary.com/practicaldev/image/fetch/s--K_hHy8zA--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://raw.githubusercontent.com/UnseenWizzard/git_training/master/img/ff_merge.png)](https://res.cloudinary.com/practicaldev/image/fetch/s--K_hHy8zA--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://raw.githubusercontent.com/UnseenWizzard/git_training/master/img/ff_merge.png)

### Merging divergent branches

Let's try something more complex.

Add some text on a new line to `Bob.txt` on **master** and commit it.

Then `git checkout change_alice`, change `Alice.txt` and commit.

In the diagram below you see how our commit history now looks. Both **master** and `change_alice` originated from the same commit, but since then they **diverged**, each having their own additional commit.

[![Divergent commits](https://res.cloudinary.com/practicaldev/image/fetch/s--NKM59jTn--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://raw.githubusercontent.com/UnseenWizzard/git_training/master/img/branches_diverge.png)](https://res.cloudinary.com/practicaldev/image/fetch/s--NKM59jTn--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://raw.githubusercontent.com/UnseenWizzard/git_training/master/img/branches_diverge.png)

If you now `git merge change_alice` a fast-forward merge is not possible. Instead your favorite text editor will open and allow you to change the message of the `merge commit` git is about to make in order to get the two branches back together. You can just go with the default message right now. The diagram below shows the state of our git history after we the `merge`.

[![Merging branches](https://res.cloudinary.com/practicaldev/image/fetch/s--btBTCeUD--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://raw.githubusercontent.com/UnseenWizzard/git_training/master/img/merge.png)](https://res.cloudinary.com/practicaldev/image/fetch/s--btBTCeUD--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://raw.githubusercontent.com/UnseenWizzard/git_training/master/img/merge.png)

The new commit introduces the changes that we've made on the `change_alice` branch into master.

As you'll remember from before, revisions in git, aren't only a snapshot of your files but also contain information on where they came from from. Each `commit` has one or more parent commits. Our new `merge` commit, has both the last commit from **master** and the commit we made on the other branch as it's parents.

### Resolving conflicts

So far our changes haven't interfered with each other.

Let's introduce a **conflict** and then **resolve** it.

Create and `checkout` a new branch. You know how, but maybe try using `git checkout -b` to make your live easier.

I've called mine `bobby_branch`.

On the branch we'll make a change to `Bob.txt`.

The first line should still be `Hi!! I'm Bob. I'm new here.`. Change that to `Hi!! I'm Bobby. I'm new here.`

Stage and then `commit` your change, before you `checkout` **master** again. Here we'll change that same line to `Hi!! I'm Bob. I've been here for a while now.` and `commit` your change.

Now it's time to `merge` the new branch into **master**.

When you try that, you'll see the following output

```
Auto-merging Bob.txt
CONFLICT (content): Merge conflict in Bob.txt
Automatic merge failed; fix conflicts and then commit the result.
```

The same line has changed on both of the branches, and git can't handle this on it's own.

If you run `git status` you'll get all the usual helpful instructions on how to continue.

First we have to resolve the conflict by hand.

> For an easy conflict like this one your favorite text editor will do fine. For merging large files with lots of changes a more powerful tool will make your life much easier, and I'd assume your favorite IDE comes with version control tools and a nice view for merging.

If you open `Bob.txt` you'll see something similar to this (I've truncated whatever we might have put on the second line before):

```
<<<<<<< HEAD
Hi! I'm Bob. I've been here for a while now.
=======
Hi! I'm Bobby. I'm new here.
>>>>>>> bobby_branch
[... whatever you've put on line 2]
```

On top you see what has changed in `Bob.txt` on the current HEAD, below you see what has changed in the branch we're merging in.

To resolve the conflict by hand, you'll just need to make sure that you end up with some reasonable content and without the special lines git has introduced to the file.

So go ahead and change the file to something like this:

```
Hi! I'm Bobby. I've been here for a while now.
[...]
```

From here what we're doing is exactly what we'd do for any changes.

We **stage** them when we `add Bob.txt`, and then we `commit`.

We already know the commit for the changes we've made to resolve the conflict. It's the **merge commit** that is always present when merging.

Should you ever realize in the middle of resolving conflicts that you actually don't want to follow through with the `merge`, you can just `abort` it by running `git merge --abort`.

## Rebasing

Git has another clean way to integrate changes between two branches, which is called `rebase`.

We still recall that a branch is always based on another. When you create it, you **branch away** from somewhere.

In our simple merging example we branched from **master** at a specific commit, then committed some changes on both **master** and the `change_alice` branch.

When a branch is diverging from the one it's based on and you want to integrate the latest changes back into your current branch, `rebase` offers a cleaner way of doing that than a `merge` would.

As we've seen, a `merge` introduces a **merge commit** in which the two histories get integrated again.

Viewed simply, rebasing just changes the point in history (the commit) your branch is based on.

To try that out, let's first checkout the **master** branch again, then create/checkout a new branch based on it.

I called mine `add_patrick` and I added a new `Patrick.txt` file and committed that with the message 'Add Patrick'.

When you've added a commit to the branch, get back to **master**, make a change and commit it. I added some more text to `Alice.txt`.

Like in our merging example the history of these two branches diverges at a common ancestor as you can see in the diagram below.

[![History before a rebase](https://res.cloudinary.com/practicaldev/image/fetch/s--nTsD2ONw--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://raw.githubusercontent.com/UnseenWizzard/git_training/master/img/before_rebase.png)](https://res.cloudinary.com/practicaldev/image/fetch/s--nTsD2ONw--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://raw.githubusercontent.com/UnseenWizzard/git_training/master/img/before_rebase.png)

Now let's `checkout add_patrick` again, and get that change that was made on **master** into the branch we work on!

When we `git rebase master`, we re-base our `add_patrick` branch on the current state of the **master** branch.

The output of that command gives us a nice hint at what is happening in it:

```
First, rewinding head to replay your work on top of it...
Applying: Add Patrick
```

As we remember **HEAD** is the pointer to the current commit we're at in our **Dev Environment**.

It's pointing to the same place as `add_patrick` before the rebase starts. For the rebase, it then first moves back to the common ancestor, before moving to the current head of the branch we want to re-base ours on.

So **HEAD** moves from the **0cfc1d2** commit, to the **7639f4b** commit that is at the head of **master**.

Then rebase applies every single commit we made on our `add_patrick` branch to that.

To be more exact what **git** does after moving **HEAD** back to the common ancestor of the branches, is to store parts of every single commit you've made on the branch (the `diff` of changes, and the commit text, author, etc.).

After that it does a `checkout` of the latest commit of the branch you're rebasing on, and then applies each of the stored changed **as a new commit** on top of that.

So in our original simplified view, we'd assume that after the `rebase` the **0cfc1d2** commit doesn't point to the common ancestor anymore in it's history, but points to the head of master.

In fact the **0cfc1d2** commit is gone, and the `add_patrick` branch starts with a new **0ccaba8** commit, that has the latest commit of **master** as its ancestor.

We made it look, like our `add_patrick` was based on the current **master** not an older version of it, but in doing so we re-wrote the history of the branch.

At the end of this tutorial we'll learn a bit more about re-writing history and when it's appropriate and inappropriate to do so.

[![History after rebase](https://res.cloudinary.com/practicaldev/image/fetch/s--rV897ytW--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://raw.githubusercontent.com/UnseenWizzard/git_training/master/img/rebase.png)](https://res.cloudinary.com/practicaldev/image/fetch/s--rV897ytW--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://raw.githubusercontent.com/UnseenWizzard/git_training/master/img/rebase.png)

`Rebase` is an incredibly powerful tool when you're working on your own development branch which is based on a shared branch, e.g. the **master**.

Using rebase you can make sure that you frequently integrate the changes other people make and push to **master**, while keeping a clean linear history that allows you to do a `fast-forward merge` when it's time to get your work into the shared branch.

Keeping a linear history also makes reading or looking at (try out `git log --graph` or take a look at the branch view of **GitHub** or **GitLab**) commit logs much more useful than having a history littered with **merge commits**, usually just using the default text.

### Resolving conflicts

Just like for a `merge` you may run into conflicts, if you run into two commits changing the same parts of a file.

However when you encounter a conflict during a `rebase` you don't fix it in an extra **merge commit**, but can simply resolve it in the commit that is currently being applied.

Again, basing your changes directly on the current state of the original branch.

Actually resolving conflicts while you `rebase` is very similar to how you would for a `merge` so refer back to that section if you're not sure anymore how to do it.

The only distinction is, that as you're not introducing a **merge commit** there is no need to `commit` your resolution. Simply `add` the changes to the **Staging Environment** and then `git rebase --continue`. The conflict will be resolved in the commit that was just being applied.

As when merging, you can always stop and drop everything you've done so far when you `git rebase --abort`.

## Updating the **Dev Environment** with remote changes

So far we've only learned how to make and share changes.

That fits what you'll do if you're just working on your own, but usually there'll be a lot of people that do just the same, and we're gonna want to get their changes from the **Remote Repository** into our **Dev Environment** somehow.

Because it has been a while, lets have another look at the components of git:

[![git components](https://res.cloudinary.com/practicaldev/image/fetch/s--jSuilYlA--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://raw.githubusercontent.com/UnseenWizzard/git_training/master/img/components.png)](https://res.cloudinary.com/practicaldev/image/fetch/s--jSuilYlA--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://raw.githubusercontent.com/UnseenWizzard/git_training/master/img/components.png)

Just like your **Dev Environment** everyone else working on the same source code has theirs.

[![many dev environments](https://res.cloudinary.com/practicaldev/image/fetch/s--l88bjwDT--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://raw.githubusercontent.com/UnseenWizzard/git_training/master/img/many_dev_environments.png)](https://res.cloudinary.com/practicaldev/image/fetch/s--l88bjwDT--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://raw.githubusercontent.com/UnseenWizzard/git_training/master/img/many_dev_environments.png)

All of these **Dev Environments** have their own **working** and **staged** changes, that are at some point `committed` to the **Local Repository** and finally `pushed` to the **Remote**.

For our example, we'll use the online tools offered by **GitHub**, to simulate someone else making changes to the **remote** while we work.

Go to your `fork` of this repo on [github.com](https://www.github.com) and open the `Alice.txt` file.

Find the edit button and make and commit a change via the website.

[![github edit](https://res.cloudinary.com/practicaldev/image/fetch/s--ifXKNJi7--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://raw.githubusercontent.com/UnseenWizzard/git_training/master/img/github.png)](https://res.cloudinary.com/practicaldev/image/fetch/s--ifXKNJi7--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://raw.githubusercontent.com/UnseenWizzard/git_training/master/img/github.png)

In this repository I have added a remote change to `Alice.txt` on a branch called `fetching_changes_sample`, but in your version of the repository you can of course just change the file on `master`.

### Fetching Changes

We still remember that when you `git push`, you synchronize changes made to the **Local Repository** into the **Remote Repository**.

To get changes made to the **Remote** into your **Local Repository** you use `git fetch`.

This gets any changes on the remote - so commits as well as branches - into your **Local Repository**.

Note that at this point, changes aren't integrated into the local branches and thus the **Working Directory** and **Staging Area** yet.

[![Fetching changes](https://res.cloudinary.com/practicaldev/image/fetch/s--F6oFwBrc--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://raw.githubusercontent.com/UnseenWizzard/git_training/master/img/fetch.png)](https://res.cloudinary.com/practicaldev/image/fetch/s--F6oFwBrc--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://raw.githubusercontent.com/UnseenWizzard/git_training/master/img/fetch.png)

If you run `git status` now, you'll see another great example of git commands telling you exactly what is going on:

```
git status
On branch fetching_changes_sample
Your branch is behind 'origin/fetching_changes_sample' by 1 commit, and can be fast-forwarded.
(use "git pull" to update your local branch)
```

### Pulling Changes

As we have no **working** or **staged** changes, we could just execute `git pull` now to get the changes from the **Repository** all the way into our working area.

> Pulling will implicitly also `fetch` the **Remote Repository**, but sometimes it is a good idea to do a `fetch` on it's own.
> For example when you want to synchronize any new **remote** branches, or when you want to make sure your **Local Repository** is up to date before you do a `git rebase` on something like `origin/master`.

[![Pulling in changes](https://res.cloudinary.com/practicaldev/image/fetch/s--LD07tDxG--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://raw.githubusercontent.com/UnseenWizzard/git_training/master/img/pull.png)](https://res.cloudinary.com/practicaldev/image/fetch/s--LD07tDxG--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://raw.githubusercontent.com/UnseenWizzard/git_training/master/img/pull.png)

Before we `pull`, lets change a file locally to see what happens.

Lets also change `Alice.txt` in our **Working Directory** now!

If you now try to do a `git pull` you'll see the following error:

```
git pull
Updating df3ad1d..418e6f0
error: Your local changes to the following files would be overwritten by merge:
Alice.txt
Please commit your changes or stash them before you merge.
Aborting
```

You can not `pull` in any changes, while there are modifications to files in the **Working Directory** that are also changed by the commits you're `pull`ing in.

While one way around this is, to just get your changes to a point where you're confident in them, `add` them to the **Staging Environment**, before you finally `commit` them, this is a good moment to learn about another great tool, the `git stash`.

### Stashing changes

If at any point you have local changes that you do not yet want to put into a commit, or want to store somewhere while you try some different angle to solve a problem, you can `stash` those changes away.

A `git stash` is basically a stack of changes on which you store any changes to the **Working Directory**.

The commands you'll mostly use are `git stash` which places any modifications to the **Working Directory** on the stash, and `git stash pop` which takes the latest change that was stashed and applies it the to the **Working Directory** again.

Just like the stack commands it's named after `git stash pop` removes the latest stashed change before applying it again.

If you want to keep the stashed changes, you can use `git stash apply`, which doesn't remove them from the stash before applying them.

To inspect you current `stash` you can use `git stash list` to list the individual entries, and `git stash show` to show the changes in the latest entry on the `stash`.

> Another nice convenience command is `git stash branch {BRANCH NAME}`, which creates a branch, starting from the HEAD at the moment you've stashed the changes, and applies the stashed changes to that branch.

Now that we know about `git stash`, lets run it to remove our local changes to `Alice.txt` from the **Working Directory**, so that we can go ahead and `git pull` the changes we've made via the website.

After that, let's `git stash pop` to get the changes back.

As both the commit we `pull`ed in and the `stash`ed change modified `Alice.txt` you wil have to resolve the conflict, just how you would in a `merge` or `rebase`.  
When you're done `add` and `commit` the change.

### Pulling with Conflicts

Now that we've understood how to `fetch` and `pull` **Remote Changes** into our **Dev Environment**, it's time to create some conflicts!

Do not `push` the commit that changed `Alice.txt` and head back to your **Remote Repository** on [github.com](https://www.github.com).

There we're also again going to change `Alice.txt` and commit the change.

Now there's actually two conflicts between our **Local** and **Remote Repositories**.

Don't forget to run `git fetch` to see the remote change without `pull`ing it in right away.

If you now run `git status` you will see, that both branches have one commit on them that differs from the other.

```
git status
On branch fetching_changes_sample
Your branch and 'origin/fetching_changes_sample' have diverged,
and have 1 and 1 different commits each, respectively.
(use "git pull" to merge the remote branch into yours)
```

In addition we've changed the same file in both of those commits, to introduce a `merge` conflict we'll have to resolve.

When you `git pull` while there is a difference between the **Local** and **Remote Repository** the exact same thing happens as when you `merge` two branches.

Additionally, you can think of the relationship between branches on the **Remote** and the one in the **Local Repository** as a special case of creating a branch based on another.

A local branch is based on a branches state on the **Remote** from the time you last `fetched` it.

Thinking that way, the two options you have to get **remote** changes make a lot of sense:

When you `git pull` the **Local** and **Remote** version of a branch will be `merged`. Just like `merging` branches, this will introduce a _merge commit.

As any **local** branch is based on it's respective **remote** version, we can also `rebase` it, so that any changes we may have made locally, appear as if they were based on the latest version that is available in the _Remote Repository.

To do that, we can use `git pull --rebase` (or the shorthand `git pull -r`).

As detailed in the section on [Rebasing](#rebasing), there is a benefit in keeping a clean linear history, which is why I would strongly recommend that whenever you `git pull` you do a `git pull -r`.

> You can also tell git to use `rebase` instead of `merge` as it's default strategy when your `git pull`, by setting the `pull.rebase` flag with a command like this `git config --global pull.rebase true`.

If you haven't already run `git pull` when I first mentioned it a few paragraphs ago, let's now run `git pull -r` to get the remote changes while making it look like our new commit just happened after them.

Of course like with a normal `rebase` (or `merge`) you'll have to resolve the conflict we introduced for the `git pull` to be done.

欢迎继续阅读本系列其他文章：

- [Learn git concepts, not commands - Part 1](https://github.com/xitu/gold-miner/blob/master/TODO1/learn-git-concepts-not-commands-1.md)
- [Learn git concepts, not commands - Part 2](https://github.com/xitu/gold-miner/blob/master/TODO1/learn-git-concepts-not-commands-2.md)
- [Learn git concepts, not commands - Part 3](https://github.com/xitu/gold-miner/blob/master/TODO1/learn-git-concepts-not-commands-3.md)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
