> * 原文地址：[Learn git concepts, not commands - Part 1](https://dev.to/unseenwizzard/learn-git-concepts-not-commands-4gjc)
> * 原文作者：[Nico Riedmann](https://dev.to/unseenwizzard)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/learn-git-concepts-not-commands-1.md](https://github.com/xitu/gold-miner/blob/master/TODO1/learn-git-concepts-not-commands-1.md)
> * 译者：
> * 校对者：

# Learn git concepts, not commands- Part 1

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

---

- [Learn git concepts, not commands- Part 1](#learn-git-concepts-not-commands--part-1)
  - [Overview](#overview)
  - [Getting a Remote Repository](#getting-a-remote-repository)
  - [Adding new things](#adding-new-things)
  - [Making changes](#making-changes)
  - [Branching](#branching)

---

## Overview

In the picture below you see four boxes. One of them stands alone, while the other three are grouped together in what I'll call your **Development Environment**.

[![git components](https://res.cloudinary.com/practicaldev/image/fetch/s--jSuilYlA--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://raw.githubusercontent.com/UnseenWizzard/git_training/master/img/components.png)](https://res.cloudinary.com/practicaldev/image/fetch/s--jSuilYlA--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://raw.githubusercontent.com/UnseenWizzard/git_training/master/img/components.png)

We'll start with the one that's on it's own though. The **Remote Repository** is where you send your changes when you want to share them with other people, and where you get their changes from. If you've used other version control systems there's nothing interesting about that.

The **Development Environment** is what you have on your local machine.  
The three parts of it are your **Working Directory**, the **Staging Area** and the **Local Repository**. We'll learn more about those as we start using git.

Choose a place in which you want to put your **Development Environment**.  
Just go to your home folder, or where ever you like to put your projects. You don't need to create a new folder for your **Dev Environment** though.

## Getting a Remote Repository

Now we want to grab a **Remote Repository** and put what's in it onto your machine.

I'd suggest we use this one ([https://github.com/UnseenWizzard/git_training.git](https://github.com/UnseenWizzard/git_training.git) if you're not already reading this on github).

> To do that I can use `git clone https://github.com/UnseenWizzard/git_training.git`
> 
> But as following this tutorial will need you to get the changes you make in your **Dev Environment** back to the **Remote Repository**, and github doesn't just allow anyone to do that to anyone's repo, you'll best create a **fork** of it right now. There's a button to do that on the top right of this page.

Now that you have a copy of my **Remote Repository** of your own, it's time to get that onto your machine.

For that we use `git clone https://github.com/{YOUR USERNAME}/git_training.git`

As you can see in the diagram below, this copies the **Remote Repository** into two places, your **Working Directory** and the **Local Repository**.

Now you see how git is **distributed** version control. The **Local Repository** is a copy of the **Remote** one, and acts just like it. The only difference is that you don't share it with anyone.

What `git clone` also does, is create a new folder wherever you called it. There should be a `git_training` folder now. Open it.

[![Cloning the remote repo](https://res.cloudinary.com/practicaldev/image/fetch/s--NCZ2AIG5--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://raw.githubusercontent.com/UnseenWizzard/git_training/master/img/clone.png)](https://res.cloudinary.com/practicaldev/image/fetch/s--NCZ2AIG5--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://raw.githubusercontent.com/UnseenWizzard/git_training/master/img/clone.png)

## Adding new things

Someone already put a file into the **Remote Repository**. It's `Alice.txt`, and kind of lonely there. Let's create a new file and call it `Bob.txt`.

What you've just done is add the file to your **Working Directory**.

There's two kinds of files in your **Working Directory**: **tracked** files that git knows about and **untracked** files that git doesn't know about (yet).

To see what's going on in your **Working Directory** run `git status`, which will tell you what branch you're on, whether your **Local Repository** is different from the **Remote** and the state of **tracked** and **untracked** files.

You'll see that `Bob.txt` is untracked, and `git status` even tells you how to change that.

In the picture below you can see what happens when you follow the advice and execute `git add Bob.txt`: You've added the file to the **Staging Area**, in which you collect all the changes you wish to put into **Repository**

[![Adding changes to the staging area](https://res.cloudinary.com/practicaldev/image/fetch/s--LVFHwLca--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://raw.githubusercontent.com/UnseenWizzard/git_training/master/img/add.png)](https://res.cloudinary.com/practicaldev/image/fetch/s--LVFHwLca--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://raw.githubusercontent.com/UnseenWizzard/git_training/master/img/add.png)

When you have added all your changes (which right now is only adding Bob), you're ready to **commit** what you just did to the **Local Repository**.

The collected changes that you **commit** are some meaningful chunk of work, so when you now run `git commit` a text editor will open and allow you to write a message telling everything what you just did. When you save and close the message file, your **commit** is added to the **Local Repository**.

[![Committing to the local repo](https://res.cloudinary.com/practicaldev/image/fetch/s--we00N_rB--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://raw.githubusercontent.com/UnseenWizzard/git_training/master/img/commit.png)](https://res.cloudinary.com/practicaldev/image/fetch/s--we00N_rB--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://raw.githubusercontent.com/UnseenWizzard/git_training/master/img/commit.png)

You can also add your **commit message** right there in the command line if you call `git commit` like this: `git commit -m "Add Bob"`. But because you want to write [good commit messages](https://chris.beams.io/posts/git-commit/) you really should take your time and use the editor.

Now your changes are in your local repository, which is a good place for the to be as long as no one else needs them or you're not yet ready to share them.

In order to share your commits with the **Remote Repository** you need to `push` them.

[![Pushing to the local repo](https://res.cloudinary.com/practicaldev/image/fetch/s--XwP0hGrK--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://raw.githubusercontent.com/UnseenWizzard/git_training/master/img/push.png)](https://res.cloudinary.com/practicaldev/image/fetch/s--XwP0hGrK--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://raw.githubusercontent.com/UnseenWizzard/git_training/master/img/push.png)

Once you run `git push` the changes will be sent to the **Remote Repository**. In the diagram below you see the state after your `push`.

[![State of all components after pushing changes](https://res.cloudinary.com/practicaldev/image/fetch/s--Gj_DegbP--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://raw.githubusercontent.com/UnseenWizzard/git_training/master/img/after_push.png)](https://res.cloudinary.com/practicaldev/image/fetch/s--Gj_DegbP--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://raw.githubusercontent.com/UnseenWizzard/git_training/master/img/after_push.png)

## Making changes

So far we've only added a new file. Obviously the more interesting part of version control is changing files.

Have a look at `Alice.txt`.

It actually contains some text, but `Bob.txt` doesn't, so lets change that and put `Hi!! I'm Bob. I'm new here.` in there.

If you run `git status` now, you'll see that `Bob.txt` is **modified**.

In that state the changes are only in your **Working Directory**.

If you want to see what has changed in your **Working Directory** you can run `git diff`, and right now see this:

```
diff --git a/Bob.txt b/Bob.txt
index e69de29..3ed0e1b 100644
--- a/Bob.txt
+++ b/Bob.txt
@@ -0,0 +1 @@
+Hi!! I'm Bob. I'm new here.
```

Go ahead and `git add Bob.txt` like you've done before. As we know, this moves your changes to the **Staging Area**.

I want to see the changes we just **staged**, so let's show the `git diff` again! You'll notice that this time the output is empty. This happens because `git diff` operates on the changes in your **Working Directory** only.

To show what changes are **staged** already, we can use `git diff --staged` and we'll see the same diff output as before.

I just noticed that we put two exclamation marks after the 'Hi'. I don't like that, so lets change `Bob.txt` again, so that it's just 'Hi!'

If we now run `git status` we'll see that there's two changes, the one we already **staged** where we added text, and the one we just made, which is still only in the working directory.

We can have a look at the `git diff` between the **Working Directory** and what we've already moved to the **Staging Area**, to show what has changed since we last felt ready to **stage** our changes for a **commit**.

```
diff --git a/Bob.txt b/Bob.txt
index 8eb57c4..3ed0e1b 100644
--- a/Bob.txt
+++ b/Bob.txt
@@ -1 +1 @@
-Hi!! I'm Bob. I'm new here.
+Hi! I'm Bob. I'm new here.
```

As the change is what we wanted, let's `git add Bob.txt` to stage the current state of the file.

Now we're ready to `commit` what we just did. I went with `git commit -m "Add text to Bob"` because I felt for such a small change writing one line would be enough.

As we know, the changes are now in the **Local Repository**.

We might still want to know what change we just **committed** and what was there before.

We can do that by comparing commits.

Every commit in git has a unique hash by which it is referenced.

If we have a look at the `git log` we'll not only see a list of all the commits with their **hash** as well as **Author** and **Date**, we also see the state of our **Local Repository** and the latest local information about **remote branches**.

Right now the `git log` looks something like this:

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

In there we see a few interesting things:

* The first two commits are made by me.
* Your initial commit to add Bob is the current **HEAD** of the **master** branch on the **Remote Repository**. We'll look at this again when we talk about branches and getting remote changes.
* The latest commit in the **Local Repository** is the one we just made, and now we know its hash.

> Note that the actual commit hashes will be different for you. If you want to know how exactly git arrives at those revision IDs have a look at [this interesting article](https://blog.thoughtram.io/git/2014/11/18/the-anatomy-of-a-git-commit.html) .

To compare that commit and the one one before we can do `git diff <commit>^!`, where the `^!` tells git to compare to the commit one before. So in this case I run `git diff 87a4ad48d55e5280aa608cd79e8bce5e13f318dc^!`

We can also do `git diff 8af2ff2a8f7c51e2e52402ecb7332aec39ed540e 87a4ad48d55e5280aa608cd79e8bce5e13f318dc` for the same result and in general to compare any two commits. Note that the format here is `git diff <from commit> <to commit>`, so our new commit comes second.

In the diagram below you again see the different stages of a change, and the diff commands that apply to where a file currently is.

[![States of a change an related diff commands](https://res.cloudinary.com/practicaldev/image/fetch/s--hZ540Uzu--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://raw.githubusercontent.com/UnseenWizzard/git_training/master/img/diffs.png)](https://res.cloudinary.com/practicaldev/image/fetch/s--hZ540Uzu--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://raw.githubusercontent.com/UnseenWizzard/git_training/master/img/diffs.png)

Now that we're sure we made the change we wanted, go ahead and `git push`.

## Branching

Another thing that makes git great, is the fact that working with branches is really easy and integral part of how you work with git.

In fact we've been working on a branch since we've started.

When you `clone` the **Remote Repository** your **Dev Environment** automatically starts on the repositories main or **master** branch.

Most work-flows with git include making your changes on a **branch**, before you `merge` them back into **master**.

Usually you'll be working on your own **branch**, until you're done and confident in your changes which can then be merged into the **master**.

> Many git repository managers like **GitLab** and **GitHub** also allow for branches to be **protected**, which means that not everyone is allowed to just `push` changes there. There the **master** is usually protected by default.

Don't worry, we'll get back to all of these things in more detail when we need them.

Right now we want to create a branch to make some changes there. Maybe you just want to try something on your own and not mess with the working state on your **master** branch, or you're not allowed to `push` to **master**.

Branches live in the **Local** and **Remote Repository**. When you create a new branch, the branches contents will be a copy of the currently committed state of whatever branch you are currently working on.

Let's make some change to `Alice.txt`! How about we put some text on the second line?

We want to share that change, but not put it on **master** right away, so let's create a branch for it using `git branch <branch name>`.

To create a new branch called `change_alice` you can run `git branch change_alice`.

This adds the new branch to the **Local Repository**.

While your **Working Directory** and **Staging Area** don't really care about branches, you always `commit` to the branch you are currently on.

You can think of **branches** in git as pointers, pointing to a series of commits. When you `commit`, you add to whatever you're currently pointing to.

Just adding a branch, doesn't directly take you there, it just creates such a pointer.

In fact the state your **Local Repository** is currently at, can be viewed as another pointer, called **HEAD**, which points to what branch and commit you are currently at.

If that sounds complicated the diagrams below will hopefully help to clear things up a bit:

[![State after adding branch](https://res.cloudinary.com/practicaldev/image/fetch/s--Ss_shD7h--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://raw.githubusercontent.com/UnseenWizzard/git_training/master/img/add_branch.png)](https://res.cloudinary.com/practicaldev/image/fetch/s--Ss_shD7h--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://raw.githubusercontent.com/UnseenWizzard/git_training/master/img/add_branch.png)

To switch to our new branch you will have to use `git checkout change_alice`. What this does is simply to move the **HEAD** to the branch you specify.

> As you'll usually want switch to a branch right after creating it, there is the convenient `-b` option available for the `checkout` command, which allows you to just directly `checkout` a **new** branch, so you don't have to create it beforehand.
> 
> So to create and switch to our `change_alice` branch, we could also just have called `git checkout -b change_alice`.

[![State after after switching branch](https://res.cloudinary.com/practicaldev/image/fetch/s--9Kp5zCqP--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://raw.githubusercontent.com/UnseenWizzard/git_training/master/img/checkout_branch.png)](https://res.cloudinary.com/practicaldev/image/fetch/s--9Kp5zCqP--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://raw.githubusercontent.com/UnseenWizzard/git_training/master/img/checkout_branch.png)

You'll notice that your **Working Directory** hasn't changed. That we've **modified** `Alice.txt` is not related to the branch we're on yet.

Now you can `add` and `commit` the change to `Alice.txt` just like we did on the **master** before, which will **stage** (at which point it's still unrelated to the branch) and finally **commit** your change to the `change_alice` branch.

There's just one thing you can't do yet. Try to `git push` your changes to the **Remote Repository**.

You'll see the following error and - as git is always ready to help - a suggestion how to resolve the issue:

```
fatal: The current branch change_alice has no upstream branch.
To push the current branch and set the remote as upstream, use

    git push --set-upstream origin change_alice
```

But we don't just want to blindly do that. We're here to understand what's actually going on. So what are **upstream branches** and **remotes**?

Remember when we `cloned` the **Remote Repository** a while ago? At that point it didn't only contain this tutorial and `Alice.txt` but actually two branches.

The **master** we just went ahead and started working on, and one I called "tutorial_wip" on which I commit all the changes I make to this tutorial.

When we copied the things in the **Remote Repository** into your **Dev Environment** a few extra steps happened under the hood.

Git setup the **remote** of your **Local Repository** to be the **Remote Repository** you cloned and gave it the default name `origin`.

> Your **Local Repository** can track several **remotes** and they can have different names, but we'll stick to the `origin` and nothing else for this tutorial.

Then it copied the two remote branches into your **Local Repository** and finally it `checked out` **master** for you.

When doing that another implicit step happens. When you `checkout` a branch name that has an exact match in the remote branches, you will get a new **local** branch that is linked to the **remote** branch. The **remote** branch is the **upstream branch** of your **local** one.

In the diagrams above you can see just the local branches you have. You can see that list of local branches by running `git branch`.

If you want to also see the **remote** branches your **Local Repository** knows, you can use `git branch -a` to list all of them.

[![Remote and local branches`](https://res.cloudinary.com/practicaldev/image/fetch/s--6K-Zm5cn--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://raw.githubusercontent.com/UnseenWizzard/git_training/master/img/branches.png)](https://res.cloudinary.com/practicaldev/image/fetch/s--6K-Zm5cn--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://raw.githubusercontent.com/UnseenWizzard/git_training/master/img/branches.png)

Now we can call the suggested `git push --set-upstream origin change_alice`, and `push` the changes on our branch to a new **remote**. This will create a `change_alice` branch on the **Remote Repository** and set our **local** `change_alice` to track that new branch.

> There is another option if we actually want our branch to track something that already exists on the **Remote Repository**. Maybe a colleague has already pushed some changes, while we were working on something related on our local branch, and we'd like to integrate the two. Then we could just set the **upstream** for our `change_alice` branch to a new **remote** by using `git branch --set-upstream-to=origin/change_alice` and from there on track the **remote** branch.

After that went through have a look at your **Remote Repository** on github, your branch will be there, ready for other people to see and work with.

We'll get to how you can get other people's changes into your **Dev Environment** soon, but first we'll work a bit more with branches, to introduce all the concepts that also come into play when we get new things from the **Remote Repository**.

欢迎继续阅读本系列其他文章：

- [Learn git concepts, not commands - Part 1](https://github.com/xitu/gold-miner/blob/master/TODO1/learn-git-concepts-not-commands-1.md)
- [Learn git concepts, not commands - Part 2](https://github.com/xitu/gold-miner/blob/master/TODO1/learn-git-concepts-not-commands-2.md)
- [Learn git concepts, not commands - Part 3](https://github.com/xitu/gold-miner/blob/master/TODO1/learn-git-concepts-not-commands-3.md)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
