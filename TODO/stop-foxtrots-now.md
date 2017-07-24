
> * 原文地址：[Protect our Git Repos, Stop Foxtrots Now!](https://developer.atlassian.com/blog/2016/04/stop-foxtrots-now/)
> * 原文作者：[Sylvie Davies](https://developer.atlassian.com/blog/authors/sdavies)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/stop-foxtrots-now.md](https://github.com/xitu/gold-miner/blob/master/TODO/stop-foxtrots-now.md)
> * 译者：
> * 校对者：

# Protect our Git Repos, Stop Foxtrots Now!

![foxtrot dancers](https://developer.atlassian.com/blog/2016/04/stop-foxtrots-now/01-dance.jpg)

Dancers gearing up to do the Foxtrot

### First, what is a foxtrot merge?

A foxtrot merge is a specific sequence of git commits. A particularly nefarious sequence. Out in the open, in lush open grasslands, the sequence looks like this:

![foxtrot merge](https://developer.atlassian.com/blog/2016/04/stop-foxtrots-now/02-foxtrot.png)

But foxtrots are rarely seen in the open. They hide up in the canopy, in-between the branches. I call them foxtrots because, when caught mid-pounce, they look like the foot sequence for the eponymous ballroom dance:

![foxtrot merge](https://developer.atlassian.com/blog/2016/04/stop-foxtrots-now/foxtrot-redrawn.png)

Others have blogged about foxtrot merges, but they never name them directly. For example, Junio C. Hamano blogs about having [Fun With –First-Parent](http://git-blame.blogspot.ca/2012/03/fun-with-first-parent.html), as well as [Fun With Non-Fast-Forward](http://git-blame.blogspot.ca/2015/03/fun-with-non-fast-forward.html). David Lowe of nestoria.com talks about [Maintaining Consistent Linear History](http://devblog.nestoria.com/post/98892582763/maintaining-a-consistent-linear-history-for-git).  And then there’s a [whole](http://longair.net/blog/2009/04/16/git-fetch-and-merge/)[whack](http://kernowsoul.com/blog/2012/06/20/4-ways-to-avoid-merge-commits-in-git/)[of](https://randyfay.com/content/simpler-rebasing-avoiding-unintentional-merge-commits)[people](https://adamcod.es/2014/12/10/git-pull-correct-workflow.html) telling you to avoid `git pull` and to always use `git pull –rebase` instead. Why?  Mostly to avoid merge commits in general, but also to avoid them darn foxtrot vermin.

But are foxtrot merges really bad? Yes.

![jelly](https://developer.atlassian.com/blog/2016/04/stop-foxtrots-now/04-jelly.jpg)

They are clearly not as bad as the Portuguese Man o’ War merge. But foxtrot merges are bad, and you do not want them creeping into your git repositories.

### Why are foxtrot merges bad?

Foxtrot merges are bad because they change origin/master’s first-parent history.

The parents of a merge commit are ordered. The first parent is HEAD. The second parent is the commit you reference with the `git merge` command.

You can think of it like this:

```
git checkout 1st-parent
git merge 2nd-parent
```

And if you are of the [octopus persuasion](http://marc.info/?l=linux-kernel&amp;m=139033182525831):

```
git merge 2nd-parent 3rd-parent 4th-parent ... 8th-parent etc...
```

This means first-parent history is exactly like it sounds.  It’s the history you get when you omit all parents except the first one for each commit. For regular commits (non-merges) the first parent is the only parent, and for merges it was the commit you were on when you typed `git merge.` This notion of first-parent is built right into Git, and appears in many of the commands, e.g., `git log –first-parent.`

The problem with foxtrot merges is they cause *origin/master* to merge as a second parent.

Which would be fine except that Git doesn’t care about parent-order when it evaluates whether a commit is eligible for fast-forward.

And you really don’t want that. You don’t want foxtrot merges updating *origin/master* via fast-forward. It makes the first-parent history unstable.

Look what happens when a foxtrot merge is pushed:

![foxtrot pushed](https://developer.atlassian.com/blog/2016/04/stop-foxtrots-now/05-foxtrot-pushed.png)

You can calculate the first-parent history yourself by tracing the graph with your finger starting from *origin/master* and always going left at every fork.

The problem is that initially the first-parent sequence of commits (starting from *origin/master*) is this:

B, A

But after the foxtrot merge is pushed, the first-parent sequence becomes this:

D, C, A

Commit B has vanished from the *origin-master*‘s first-parent history. No work is lost, and commit B is still part of *origin/master* of course.

But first-parent turns out to have all sorts of implications. Did you know that the tilda notation (e.g., ~N) specifies the *Nth*-commit down the first-parent path from the given commit?

Have you ever wanted to see each commit on your branch as a diff, but `git log -p` is clearly missing diffs, and `git log -p -m` has way too many diffs?

Try `git log -p -m –first-parent` instead.

Have you ever wanted to revert a merge?  You need to supply the `-m parent-number` option to `git revert` to do that, and you really don’t want to provide the wrong parent-number.

Most people I work with treat the first-parent sequence as the real “master” branch. Either consciously or subconsciously, people see `git log –first-parent origin/master` as the sequence of the important things. As for any side branches merging in? Well, you know what they say:

![topic](https://developer.atlassian.com/blog/2016/04/stop-foxtrots-now/06-what-happens-in-topic.jpg)

But foxtrot merges mess with this. Consider the example below, where a sequence of critical commits hits origin/master in parallel to your own slightly less important work:

![topic escaped](https://developer.atlassian.com/blog/2016/04/stop-foxtrots-now/07a-topic-branch-escape.png)

At this point you’re finally ready to bring your work into master. You type `git pull`, or maybe you’re on a topic branch and you type `git merge master`. What happens? A foxtrot merge happens.

![topic escaped b](https://developer.atlassian.com/blog/2016/04/stop-foxtrots-now/07b-topic-branch-escape.png)

This wouldn’t really be of any concern. Except when you type `git push` and your remote repo accepts it. Because now your history looks like this:

![topic escaped c](https://developer.atlassian.com/blog/2016/04/stop-foxtrots-now/07c-topic-branch-escape.png)

![topic escaped lego](https://developer.atlassian.com/blog/2016/04/stop-foxtrots-now/08-lego-topic-branch-escaped.jpg)

### What should I do about the pre-existing foxtrot merges that have infected my git repo?

Nothing. Leave them. Unless you’re one of those antisocial people that rewrites master. Then go nuts.

Actually, [please don’t](https://www.atlassian.com/git/tutorials/merging-vs-rebasing/the-golden-rule-of-rebasing/).

### How can I prevent future foxtrot merges from creeping into my git repo?

There are a few ways.  My favorite approach involves 4 steps:

1. Setup Atlassian Bitbucket Server for your team.

2. Install the add-on I wrote for Bitbucket Server called “Bit Booster Commit Graph and More.”  You can find it here:  [https://marketplace.atlassian.com/plugins/com.bit-booster.bb](https://marketplace.atlassian.com/plugins/com.bit-booster.bb)[https://marketplace.atlassian.com/plugins/com.bit-booster.bb](https://marketplace.atlassian.com/plugins/com.bit-booster.bb)

3. Click the “Enable” button on the “Protect First Parent Hook” in all your repos:

![hook enabled](https://developer.atlassian.com/blog/2016/04/stop-foxtrots-now/09-hook-enabled.png)

4. Call in sick to work for 31 days to make the trial license expire.

This is my preferred approach because it keeps the foxtrots away, and it prints a cow whenever a foxtrot is blocked:

```
$ git commit -m 'my commit'
$ git pull
$ git push

remote:  _____________________________________________
remote: /                                             \
remote: | Moo! Your bit-booster license has expired!  |
remote: \                                             /
remote:  ---------------------------------------------
remote:         \   ^__^
remote:          \  (oo)\_______
remote:             (__)\       )\/\
remote:                 ||----w |
remote:                 ||     ||
remote:
remote: *** PUSH REJECTED BY Protect-First-Parent HOOK ***
remote:
remote: Merge [da75830d94f5] is not allowed. *Current* master
remote: must appear in the 'first-parent' position of the
remote: subsequent commit.
```

There are other ways. You could disable direct pushes to master, and hope that pull-requests never merge with fast-forward. Or train your staff to always do `git pull –rebase` and to never type `git merge master` and once all your staff are trained, never hire anyone else.

If you have direct access to the remote repository, you could setup a pre-receive hook. The following bash script should help you get started:

```
#/bin/bash

# Copyright (c) 2016 G. Sylvie Davies. http://bit-booster.com/
# Copyright (c) 2016 torek. http://stackoverflow.com/users/1256452/torek
# License: MIT license. https://opensource.org/licenses/MIT
while read oldrev newrev refname
do
if [ "$refname" = "refs/heads/master" ]; then
   MATCH=`git log --first-parent --pretty='%H %P' $oldrev..$newrev |
     grep $oldrev |
     awk '{ print \$2 }'`

   if [ "$oldrev" = "$MATCH" ]; then
     exit 0
   else
     echo "*** PUSH REJECTED! FOXTROT MERGE BLOCKED!!! ***"
     exit 1
   fi
fi
done
```

### I accidentally created a foxtrot merge, but I haven’t pushed it. How can I fix it?

Suppose you install the pre-receive hook, and it blocks your foxtrot. What do you do next? You have three possible remedies:

1. Simple rebase:

![remedy rebase](https://developer.atlassian.com/blog/2016/04/stop-foxtrots-now/10-remedy-rebase.png)

2. Reverse your earlier merge to make origin/master the first-parent:

![reverse merge](https://developer.atlassian.com/blog/2016/04/stop-foxtrots-now/11-remedy-reverse-merge.png)

3. Create a 2nd merge commit after the foxtrot merge to preserve origin/master’s –first-parent relation.

![remedy](https://developer.atlassian.com/blog/2016/04/stop-foxtrots-now/12-remedy-man-o-war.png)

But please don’t do #3, because the final result is called a “Portuguese man o’ war merge,” and those guys are even worse than foxtrot merges.

### Conclusion

At the end of the day a foxtrot merge is just like any other merge. Two (or more) commits come together to reconcile separate development histories.  As far as your codebase is concerned, it makes no difference. Whether commit A merges into commit B or vice versa, the end result from a code perspective is identical.

But when it comes to your repository’s history, as well as using the git toolset effectively, foxtrot merges create havoc.  By setting up policy to prevent them, you make your history easier to understand, and you reduce the range of git command options you need to memorize.


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
