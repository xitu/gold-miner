> * 原文地址：[The Smart Ways to Correct Mistakes in Git](https://css-tricks.com/the-smart-ways-to-correct-mistakes-in-git/)
> * 原文作者：[Tobias Günther](https://css-tricks.com/author/tobiasgunther/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/the-smart-ways-to-correct-mistakes-in-git.md](https://github.com/xitu/gold-miner/blob/master/TODO1/the-smart-ways-to-correct-mistakes-in-git.md)
> * 译者：
> * 校对者：

# The Smart Ways to Correct Mistakes in Git

The world of software development offers an _infinite_ amount of ways to mess up: deleting the wrong things, coding into dead ends, littering commit messages with typos, are a mere few of the plentitude.

​​Fortunately, however, we have a wonderful safety net under our feet in the form of Git when we’re working with version control. Not that you and I need a safety net, of course, because we never make mistakes, right? Sure, sure. But for the benefit of everyone else, let's take a tour of some of the "undo" tools in Git that can save us from ourselves.

### Fixing the last commit

​​Messing up a commit is all too easy. Classic case in point: making a typo in a commit message. Another? Forgetting to add a change to the staging area. And in many cases, we instantly realize our mistake — right after hitting the Enter key, naturally.

​​Luckily, Git makes it ridiculously easy to fix the very last commit. Let's say we had just hit Enter on the following command:

```
git commit -m "Massage full of typohs"
```

​​And (as if this orthographic mess wasn't bad enough) let's say we _also_ forgot to add another changed file to the staging area. We can correct both of our mistakes with the following two commands:

```
git add forgotten-changes.js
​​git commit --amend -m "A sensible message"
```

​​The magic ingredient is the `--amend​` flag: when using it on a commit, Git will correct the very last commit — with any staged changes and the new message.

​​A short word of warning, though: only use `--amend`​ on commits that haven't been pushed to a remote repository, yet. The reason is that Git **replaces the original**, bad commit with the amended version. Afterwards, it looks as if the original commit never happened. Yeah, that’s good for concealing mistakes, but only if we haven't already _published_ this mistake on the remote server.

### Undoing local changes

​​Everyone’s had days like this: spend all morning hacking away, only to admit to yourself that the last few hours were a waste of time. Gotta start over and undo much (or all) of that work.

​​But this is one of the reasons for using Git in the first place — to be able to try out things without the fear that we might break something.

​​Let's take stock in an example situation:

```
git status
​​  modified: about.html
​​  deleted:  imprint.html
​​  modified: index.html
```

​​Now, let's assume that this is one of the wasted hacking days described above. We ought to have kept our hands off of about.html and not deleted imprint.html. What we now want is to _discard_ our current changes in these files — while keeping the brilliant work done in index.html. ​​The `git checkout​` command can help in this case. Instead, we’ve gotta get more specific with which files to check out, like this:

```
git checkout HEAD about.html imprint.html
```

​​This command restores both about.html and imprint.html to their last committed states. Phew, we got away from a black eye!

​​We could take this one step further and **discard specific individual lines** in a changed file instead of tossing out the entire thing! I’ll admit, it’s rather complicated to make it happen on the command line, but using a [desktop Git client like Tower](https://www.git-tower.com/) is a great way to go about it:

![](https://css-tricks.com/wp-content/uploads/2019/02/tower-discard-single-lines-2.gif)

​​For those _really_ bad days, we might want to bring out the big guns in the form of:

```
git reset --hard HEAD
```

​​While we only restored _specific_ files with `checkout`​, this command resets our _whole working copy_. In other words, `reset`​ restores the complete project at its last committed state. ​​Similar to `--amend`​, there's something to keep in mind when using `checkout`​ and `reset`​: discarding local changes with these commands cannot be undone! They have never been committed to the repository, so it's only logical that they cannot be restored. Better be sure that you really want to get rid of them because there’s no turning back!

### Undoing and reverting an older commit

​​In many cases, we only realize a mistake much later, after it has long been committed to the repository.

![](https://res.cloudinary.com/css-tricks/image/upload/v1548698897/F9D13FDA-F04C-467F-A910-B944BB7AA196_a71qfi.png)

​​How can we get rid of that one bad commit? Well, the answer is that we shouldn't… at least in most cases. Even when "undoing" things, Git normally doesn't actually delete data. It _corrects it by adding new data_. Let's see how this works using our "bad guy" example:

```
git revert 2b504bee
```

​​By using `git revert`​ on that bad commit, we haven't deleted anything. Quite the contrary:

![](https://res.cloudinary.com/css-tricks/image/upload/v1548698922/F4BA4EB6-68CB-4ADB-B840-157A0FB094B8_pt0t26.png)

​​Git automatically created a _new_ commit with changes that _reverts the effects_ of the "bad" commit. So, really, if we started with three commits and were trying to correct the middle one, now we have four total commits, with a new one added that corrects the one we targeted with `revert`​.

### Restoring a previous version of a project

​​A different use case is when we want to restore a previous version of our project. Instead of simply undoing or reverting a specific revision somewhere in our commit history, we might really want to turn back time and return to a specific revision.
​​  
​​In the following example scenario, we would declare all the commits that came after "C2" as _unwanted_. What we want is to return to the state of commit "C2" and forget everything that came after it in the process:

![](https://res.cloudinary.com/css-tricks/image/upload/v1548698945/9F2F3E84-7499-4047-B3A1-812AD45D32A1_qcy0xt.png)

​​The command that's necessary is already (at least partly) familiar to you based on what we’ve already covered:

```
git reset --hard 2b504bee
```

​​This tells `git reset`​ the SHA-1 hash of the commit we want to return to. Commits C3 and C4 then disappear from the project's history.
​​
​​If you're working in a Git client, like Tower, both `git revert`​ and `git reset` are available from the contextual menu of a commit item:

![](https://res.cloudinary.com/css-tricks/image/upload/v1548699011/23F90DCB-BD37-4948-A309-0682FB961824_lc3t8d.png)

### ​​Deleting commits, restoring deleted branches, dealing with conflicts, etc. etc. etc.

​​Of course, there are many other ways to mess up things in a software project. But luckily, Git also offers many more tools for undoing the mess.

​​Have a look at the ["First Aid Kit for Git"](https://www.git-tower.com/learn/git/first-aid-kit) project that I and other folks on the Tower team have created if you want to learn more about the scenarios we covered in this post, or about other topics, like how to move commits between branches, delete old commits, restore deleted branches or gracefully deal with merge conflicts. It’s a totally free guide that includes 17 videos and a handy cheat sheet you can download and keep next to your machine.

[![](https://res.cloudinary.com/css-tricks/image/upload/v1548699043/7A41F2B2-96C4-483C-8639-B7A35F305681_vafnlo.png)](https://www.git-tower.com/learn/git/first-aid-kit)

​​In the meantime, happy undoing!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
