> * 原文地址：[How (and why!) to keep your Git commit history clean](https://about.gitlab.com/2018/06/07/keeping-git-commit-history-clean/)
> * 原文作者：[Kushal Pandya](https://about.gitlab.com/team/#Kushal_Pandya)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/keeping-git-commit-history-clean.md](https://github.com/xitu/gold-miner/blob/master/TODO1/keeping-git-commit-history-clean.md)
> * 译者：
> * 校对者：

# How (and why!) to keep your Git commit history clean

## Git commit history is very easy to mess up, here's how you can fix it!

Commits are one of the key parts of a Git repository, and more so, the _commit message_ is a life log for the repository. As the project/repository evolves over time (new features getting added, bugs being fixed, architecture being refactored), commit messages are the place where one can see what was changed and how. So it's important that these messages reflect the underlying change in a short, precise manner.

## Why meaningful commit history is important

Git commit messages are the fingerprints that you leave on the code you touch. Any code that you commit today, a year from now when you look at the same change; you would be thankful for a clear, meaningful commit message that you wrote, and it will also make the lives of your fellow developers easier. When commits are isolated based on context, a bug which was introduced by a certain commit becomes quicker to find, and the easier it is to revert the commit which caused the bug in the first place.

While working on a large project, we often deal with a lot of moving parts that are updated, added or removed. Ensuring that commit messages are maintained in such cases could be tricky, especially when development spans across days, weeks, or even months. So to simplify the effort of maintaining concise commit history, this article will use some of the common situations that a developer might face while working on a Git repository.

*   [Situation 1: I need to change the most recent commit](#situation-1-i-need-to-change-the-most-recent-commit)
*   [Situation 2: I need to change a specific commit](#situation-2-i-need-to-change-a-specific-commit)
*   [Situation 3: I need to add, remove, or combine commits](#situation-3-i-need-to-add-remove-or-combine-commits)
*   [Situation 4: My commit history doesn't make sense, I need a fresh start!](#situation-4-my-commit-history-doesnt-make-sense-i-need-a-fresh-start)

But before we dive in, let's quickly go through how a typical development workflow looks like in a our hypothetical Ruby application.

**Note:** This article assumes that you are aware about basics of Git, how branches work, how to add uncommitted changes of a branch to stage and how to commit the changes. If you're unsure of these flows, [our documentation](https://docs.gitlab.com/ee/topics/git/index.html) is a great starting point.

## A day in the life

Here, we are working on a small Ruby on Rails project where we need to add a navigation view on the homepage and that involves updating and adding several files. Following is a step by step breakdown of the entire flow:

*   You start working on a feature with updating a file; let's call it `application_controller.rb`
*   This feature requires you to also update a view: `index.html.haml`
*   You added a partial which is used in index page: `_navigation.html.haml`
*   Styles for the page also need to be updated to reflect the partial we added: `styles.css.scss`
*   Feature is now ready with the desired changes, time to also update tests; files to be updated are as follows:
    *   `application_controller_spec.rb`
    *   `navigation_spec.rb`
*   Tests are updated and passing as expected, now time to commit the changes!

Since all the files belong to different territories of the architecture, we commit the changes isolated of each other to ensure that each commit represents a certain context and is made in a certain order. I usually prefer backend -> frontend order where most backend-centric change is committed first, followed by the middle layer and then by frontend-centric changes in the commits list.

1.  `application_controller.rb` & `application_controller_spec.rb`; **Add routes for navigation**.
2.  `_navigation.html.haml` & `navigation_spec.rb`; **Page Navigation View**.
3.  `index.html.haml`; **Render navigation partial**.
4.  `styles.css.scss`; **Add styles for navigation**.

Now that we have our changes committed, we create a merge request with the branch. Once you have merge request open, it typically gets reviewed by your peer before the changes are merged into repo's `master` branch. Now let's learn what different situations we may end up with during code review.

## Situation 1: I need to change the most recent commit

Imagine a case where the reviewer looked at `styles.css.scss` and suggested a change. In such a case, it is very simple to do the change as the stylesheet changes are part of **last** commit on your branch. Here's how we can handle this;

*   You directly do the necessary changes to `styles.css.scss` in your branch.
*   Once you're done with the changes, add these changes to stage; run `git add styles.css.scss`.
*   Once changes are staged, we need to _add_ these changes to our last commit; run `git commit --amend`.
    *   **Command breakdown**: Here, we're asking the `git commit` command to _amend_ whatever changes are present in stage to the most recent commit.
*   This will open your last commit in your Git-defined text editor which has the commit message **Add styles for navigation**.
*   Since we only updated the CSS declaration, we don't need to alter the commit message. At this point, you can just save and exit the text editor that Git opened for you and your changes will be reflected in the commit.

Since you modified an existing commit, these changes are required to be _force pushed_ to your remote repo using `git push --force-with-lease <remote_name> <branch_name>`. This command will override the commit `Add styles for navigation` on remote repo with updated commit that we just made in our local repo.

One thing to keep in mind while force pushing branches is that if you are working on the same branch with multiple people, force pushing may cause trouble for other users when they try to normally push their changes on a remote branch that has new commits force pushed. Hence, use this feature wisely. You can learn more about Git force push options [here](https://git-scm.com/docs/git-push#git-push---no-force-with-lease).

## Situation 2: I need to change a specific commit

In the previous situation, the fix was rather simple as we had to modify only our last commit, but imagine if reviewer suggested to change something in `_navigation.html.haml`. In this case, it is second commit from the top, so changing it won't be as direct as it was in the first situation. Let's see how we can handle this:

Whenever a commit is made in a branch, it is identified by a unique SHA1 hash string. Think of it as a unique ID that separates one commit from another. You can view all the commits, along with their SHA1 hashes in a branch by running `git log`. With this, you would see an output that looks somewhat as follows, where the most recent commits are at the top;

```
commit aa0a35a867ed2094da60042062e8f3d6000e3952 (HEAD -> add-page-navigation)
Author: Kushal Pandya <kushal@gitlab.com>
Date: Wed May 2 15:24:02 2018 +0530

    Add styles for navigation

commit c22a3fa0c5cdc175f2b8232b9704079d27c619d0
Author: Kushal Pandya <kushal@gitlab.com>
Date: Wed May 2 08:42:52 2018 +0000

    Render navigation partial

commit 4155df1cdc7be01c98b0773497ff65c22ba1549f
Author: Kushal Pandya <kushal@gitlab.com>
Date: Wed May 2 08:42:51 2018 +0000

    Page Navigation View

commit 8d74af102941aa0b51e1a35b8ad731284e4b5a20
Author: Kushal Pandya <kushal@gitlab.com>
Date: Wed May 2 08:12:20 2018 +0000

    Add routes for navigation
```

This is where `git rebase` command comes into play. Whenever we wish to edit a specific commit with `git rebase`, we need to first rebase our branch by moving back HEAD to the point right _before_ the commit we wish to edit. In our case, we need to change the commit that reads `Page Navigation View`.

![Commit Log](https://about.gitlab.com/images/blogimages/keeping-git-commit-history-clean/GitRebase.png)

Here, notice the hash of commit which is right before the commit we want to modify; copy the hash and perform the following steps:

*   Rebase the branch to move to commit before our target commit; run `git rebase -i 8d74af102941aa0b51e1a35b8ad731284e4b5a20`
    *   **Command breakdown**: Here we're running Git's `rebase` command with _interactive_ mode with provided SHA1 hash as commit to rebase to.
*   This will run rebase command for Git in interactive mode and will open your text editor showing all of your commits that came _after_ the commit you rebased to. It will look somewhat like this:

```
pick 4155df1cdc7 Page Navigation View
pick c22a3fa0c5c Render navigation partial
pick aa0a35a867e Add styles for navigation

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

Notice how each commit has a word `pick` in front of it, and in the contents below, there are all possible keywords we can use. Since we want to _edit_ a commit, we need to change `pick 4155df1cdc7 Page Navigation View` to `edit 4155df1cdc7 Page Navigation View`. Save the changes and exit editor.

Now your branch is rebased to the point in time right before the commit you made which included `_navigation.html.haml`. Open the file and perform desired changes as per the review feedback. Once you're done with the changes, stage the them by running `git add _navigation.html.haml`.

Since we have staged the changes, it is time to move branch HEAD back to the commit we originally had (while also including the new changes we added), run `git rebase --continue`, this will open your default editor in the terminal and show you the commit message that we edited during rebase; `Page Navigation View`. You can change this message if you wish, but we would leave it as it is for now, so save and exit the editor. At this point, Git will replay all the commits that followed after the commit you just edited and now branch `HEAD` is back to the top commit we originally had, and it also includes the new changes you made to one of the commits.

Since we again modified a commit that's already present in remote repo, we need force push this branch again using `git push --force-with-lease <remote_name> <branch_name>`.

## Situation 3: I need to add, remove, or combine commits

A common situation is when you've made several commits just to fix something previously committed. Now let's reduce them as much as we can, combining them with the original commits.

All you need to do is start the interactive rebase as you would in the other scenarios.

```
pick 4155df1cdc7 Page Navigation View
pick c22a3fa0c5c Render navigation partial
pick aa0a35a867e Add styles for navigation
pick 62e858a322 Fix a typo
pick 5c25eb48c8 Ops another fix
pick 7f0718efe9 Fix 2
pick f0ffc19ef7 Argh Another fix!
```

Now imagine you want to combine all those fixes into `c22a3fa0c5c Render navigation partial`. You just need to:

1.  Move the fixes up so that they are right below the commit you want to keep in the end.
2.  Change `pick` to `squash` or `fixup` for each of the fixes.

_Note:_ `squash` keeps the commits messages in the description. `fixup` will forget the commit messages of the fixes and keep the original.

You'll end up with something like this:

```
pick 4155df1cdc7 Page Navigation View
pick c22a3fa0c5c Render navigation partial
fixup 62e858a322 Fix a typo
fixup 5c25eb48c8 Ops another fix
fixup 7f0718efe9 Fix 2
fixup f0ffc19ef7 Argh Another fix!
pick aa0a35a867e Add styles for navigation
```

Save the changes, exit the editor, and you're done! This is the resulting history:

```
pick 4155df1cdc7 Page Navigation View
pick 96373c0bcf Render navigation partial
pick aa0a35a867e Add styles for navigation
```

As before, all you need to do now is `git push --force-with-lease <remote_name> <branch_name>` and the changes are up.

If you want to remove a commit altogether, instead of `squash` or `fixup`, just write `drop` or simply delete that line.

### Avoid conflicts

To avoid conflicts, make sure the commits you're moving up the timeline aren't touching the same files touched by the commits left after them.

```
pick 4155df1cdc7 Page Navigation View
pick c22a3fa0c5c Render navigation partial
fixup 62e858a322 Fix a typo                 # this changes styles.css
fixup 5c25eb48c8 Ops another fix            # this changes image/logo.svg
fixup 7f0718efe9 Fix 2                      # this changes styles.css
fixup f0ffc19ef7 Argh Another fix!          # this changes styles.css
pick aa0a35a867e Add styles for navigation  # this changes index.html (no conflict)
```

### Pro-tip: Quick `fixup`s

If you know exactly which commit you want to fixup, when committing you don't have to waste brain cycles thinking of good temporary names for "Fix 1", "Fix 2", …, "Fix 42".

**Step 1: Meet `--fixup`**

After you've staged the changes fixing whatever it is that needs fixing, just commit the changes like this:

```
git commit --fixup c22a3fa0c5c
```

(Note that this is the hash for the commit `c22a3fa0c5c Render navigation partial`)

This will generate this commit message: `fixup! Render navigation partial`.

**Step 2: And the sidekick `--autosquash`**

Easy interactive rebase. You can have `git` place the `fixup`s automatically in the right place.

`git rebase -i 4155df1cdc7 --autosquash`

History will be shown like so:

```
pick 4155df1cdc7 Page Navigation View
pick c22a3fa0c5c Render navigation partial
fixup 62e858a322 Fix a typo
fixup 5c25eb48c8 Ops another fix
fixup 7f0718efe9 Fix 2
fixup f0ffc19ef7 Argh Another fix!
pick aa0a35a867e Add styles for navigation
```

Ready for you to just review and proceed.

If you're feeling adventurous you can do a non-interactive rebase `git rebase --autosquash`, but only if you like living dangerously, as you'll have no opportunity to review the squashes being made before they're applied.

## Situation 4: My commit history doesn't make sense, I need a fresh start!

If we're working on a large feature, it is common to have several fixup and review-feedback changes that are being committed frequently. Instead of constantly rebasing the branch, we can leave the cleaning up of commits until the end of development.

This is where creating patch files is extremely handy. In fact, patch files were the primary way of sharing code over email while collaborating on large open source projects before Git-based services like GitLab were available to developers. Imagine you have one such branch (eg; `add-page-navigation`) where there are tons of commits that don't convey the underlying changes clearly. Here's how you can create a patch file for all the changes you made in this branch:

*   The first step to create the patch file is to make sure that your branch has all the changes present from `master` branch and has no conflicts with the same.
*   You can run `git rebase master` or `git merge master` while you're checked out in `add-page-navigation` branch to get all the changes from `master` on to your branch.
*   Now create the patch file; run `git diff master add-page-navigation > ~/add_page_navigation.patch`.
    *   **Command breakdown**: Here we're using Git's _diff_ feature, and asking for a diff between `master` branch and `add-page-navigation` branch, and _redirecting_ the output (via `>` symbol) to a file named `add_page_navigation.patch` in our user home directory (typically `~/` in *nix operating systems).
*   You can specify any path you wish to keep this file in and the file name and extension could be anything you want.
*   Once the command is run and you don't see any errors, the patch file is generated.
*   Now checkout `master` branch; run `git checkout master`.
*   Delete the branch `add-page-navigation` from local repo; run `git branch -D add-page-navigation`. Remember, we already have changes of this branch in a created patch file.
*   Now create a new branch with the same name (while `master` is checked out); run `git checkout -b add-page-navigation`.
*   At this point, this is a fresh branch and doesn't have any of your changes.
*   Finally, apply your changes from the patch file; `git apply ~/add_page_navigation.patch`.
*   Here, all of your changes are applied in a branch and they will appear as uncommitted, as if all your modification where done, but none of the modifications were actually committed in the branch.
*   Now you can go ahead and commit individual files or files grouped by area of impact in the order you want with concise commit messages.

As with previous situations, we basically modified the whole branch, so it is time to force push!

## Conclusion

While we have covered most common and basic situations that arise in a day-to-day workflow with Git, rewriting Git history is a vast topic and as you get familiar with above tips, you can learn more advanced concepts around the subject in the [Git Official Documentation](https://git-scm.com/book/en/v2/Git-Tools-Rewriting-History). Happy git'ing!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
