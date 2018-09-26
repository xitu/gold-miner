> * 原文地址：[How To Become a DevOps Engineer In Six Months or Less, Part 3: Version](https://medium.com/@devfire/how-to-become-a-devops-engineer-in-six-months-or-less-part-3-version-76034885a7ab)
> * 原文作者：[Igor Kantor](https://medium.com/@devfire?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-become-a-devops-engineer-in-six-months-or-less-part-3-version.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-become-a-devops-engineer-in-six-months-or-less-part-3-version.md)
> * 译者：
> * 校对者：

# How To Become a DevOps Engineer In Six Months or Less, Part 3: Version

![](https://cdn-images-1.medium.com/max/1000/0*WbA21p1XhfwT36Cx)

“Close-up of a backlit laptop keyboard” by [Markus Petritz](https://unsplash.com/@petritzdesigns?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)

_NOTE: this is Part 3 of a multi-part series. For Part 1, please click [here](https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-become-a-devops-engineer-in-six-months-or-less.md). Part 2 is [here](https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-become-a-devops-engineer-in-six-months-or-less-part-2-configure.md)._

Let’s quickly recap where we are.

In short, this series of posts tells a story.

And that story is learning how to take an idea and turn it into money, as quickly as possible — the essence of the modern DevOps movement.

Specifically, in [Part 1](https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-become-a-devops-engineer-in-six-months-or-less.md) we talked about the DevOps culture and goals.

In [Part 2](https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-become-a-devops-engineer-in-six-months-or-less-part-2-configure.md), we talked about how to lay the foundation for future code deployments with Terraform. Of course, Terraform is code also!

Consequently, in this post, we will discuss how to keep all these pieces of code from completely going haywire all over the place. Spoiler, it’s all about [_git_](https://git-scm.com/)!

Bonus: we will also talk about how to use this git business to build and promote your own personal brand.

For reference, we are here in our journey:

![](https://cdn-images-1.medium.com/max/1000/1*N-4zkp9GM6apxn3GMWcT0A.png)

DevOps Journey

* * *

So, when we talk of “Versioning” what do we mean?

Imagine you are working on some piece of software. You are making changes to it constantly, adding or removing features as needed. Often, the latest change will be a “breaking” change. In other words, whatever it was you did last, broke whatever you had working prior.

Now what?

Well. If you are really Old School, you probably had a tendency to name your first file like this:

```
awesome_code.pl
```

Then you start making changes and you need to preserve what works, in case you have to go back to it.

So, you rename your file to this:

```
awesome_code.12.25.2018.pl
```

And that works fine. Until one day you make more than one change per day, so you end up with this:

```
awesome_code.GOOD.12.25.2018.pl
```

And so on.

Of course, in a professional environment, you have multiple teams collaborating on the same codebase, which breaks this model even further.

Needless to say, this crazy train derails fast.

Enter Source Code Control: a way to keep your files in a **centralized** location, where multiple teams can work together on a common codebase.

Now, this idea is not new. The earliest [mention](https://en.wikipedia.org/wiki/Source_Code_Control_System) of such a thing that I’ve been able to find dates back to 1972! So, the idea that we should centralize our code in one place is definitely old.

What is relatively new, however, is the idea that **all production artifacts must be versioned**.

What does that mean?

It means that everything that touches your production environment must be stored in version control, subject to tracking, review, and history of changes.

Moreover, enforcing the “all prod artifacts must be versioned” law really forces you to approach problems with the “automation first” mindset.

For example, when you decide to just click your way through a complex problem in your Dev AWS environment, you can pause and think, “Is all this clicking a versioned artifact?”

Of course, the answer is, “no”. So, while it is OK to do rapid prototypes via UI to see if something works or not, these efforts must really be short-lived. Longer term, please make sure you do everything in Terraform or another infrastructure-as-code tool.

OK, so if everything is a versioned artifact, how do we store and manage these things, exactly?

The answer is git.

Until [git](https://git-scm.com/doc) came along, using source code control systems like SVN or others was clunky, not user friendly and was in general a pretty painful experience.

What git does differently is that embraces the notion of a **distributed** source code control.

In other words, you are not locking other people out of a centralized source code repository, while you are working on your changes. Instead, you are working on a complete **copy** of the codebase. And that copy then gets _merged_ into the _master_ repository.

Keep in mind, the above is a gross oversimplification of how git works. But it is enough for the purposes of this article, even though knowing the inner workings of git is both valuable and takes a while to master.

![](https://cdn-images-1.medium.com/max/800/0*hoGY4_63YI8B7Pbc.png)

[https://xkcd.com/1597/](https://xkcd.com/1597/)

For now, just remember that git is **not** like SVN of old. It is a distributed source code control system, where multiple teams can work on a shared codebase safely and securely.

What does it mean for us?

Specifically, I would strongly argue that you **cannot** become a professional DevOps (Cloud) Engineer without knowing how git works. It’s as simple as that.

OK, so how does one learn git, exactly?

I must say, Googling for a “git tutorial” has the dubious distinction of coming up with extremely comprehensive and extremely confusing tutorials.

However, there are a few that are really, really good.

One such series of tutorials I urge everyone to read, learn and practice with is [Atlassian’s Git Tutorials](https://www.atlassian.com/git/tutorials).

In fact, they are all pretty good but one section in particular is what is used by professional software engineers the world over: [Git Workflows](https://www.atlassian.com/git/tutorials/comparing-workflows).

I cannot stress this enough. Time and again, lack of understanding how git feature branching works or failure to explain Gitflow is what sinks 99% of aspiring DevOps engineers candidacies.

This is a key point. You can come to an interview and not know Terraform or whatever the latest trendy infrastructure-as-code tool is and that’s ok — one can learn it on the job.

But not knowing git and how it works is a signal that you lack the fundamentals of modern software engineering best practices, DevOps or not. That signals to hiring managers that your learning curve is going to be very steep. You do not want to signal that!

Conversely, your ability to confidently speak of git best practices tells the hiring managers that you come with a software engineering mindset first — exactly the kind of image you want to project.

To summarize: you don’t need to become world’s foremost git expert to land that awesome DevOps role but you do need to live and breathe git for a while to be able to confidently speak about what’s going on.

At a minimum, you should be well versed in how to

1.  Fork a repo
2.  Create branches
3.  Merge changes from upstream and back
4.  Create Pull Requests

Now, once you get through the introductory git tutorials, get yourself a [GitHub](https://help.github.com/) account.

NOTE: GitLab is OK also but at the time of this writing, GitHub is the most prevalent open source git repository, so you want to be where everyone else is.

Once you have your GitHub account, start contributing your code to it! Whatever you learn that requires you to write code, make sure you commit it to GitHub regularly.

This not only instills good source code control discipline but helps you build your own personal brand.

NOTE: when you are learning how to use git+GitHub, pay special attention to [Pull Requests](https://help.github.com/articles/about-pull-requests/) (or PRs, if you want to be cool).

![](https://cdn-images-1.medium.com/max/800/0*E1Y3iKOJjkKiwcoa)

Pull Request, by [Vidar Nordli-Mathisen](https://unsplash.com/@vidarnm?utm_source=medium&utm_medium=referral)

* * *

Brand: a way to showcase to the wider world what you are capable of.

One way (currently, one of the better ways!) is to establish to solid GitHub presence as a proxy for your brand. Almost all employers these days will ask for one anyway.

Therefore, you should strive to have a neat, carefully curated GitHub account — something you can put on your resume and be proud of.

In later sections, we’ll talk about how to build a simple but cool-looking website on GitHub using the [Hugo](https://gohugo.io/) framework. For now, just putting your code into GitHub is enough.

Later on, as you get more experienced, you might consider having two GitHub accounts. One for your personal stuff you use to store practice code you write and another account to store code you want to show others.

To summarize:

*   Learn git
*   Contribute everything you’ve learned to GitHub
*   Leverage #1 and #2 as a showcase of all the things you have learned thus far
*   Profit!

Finally, please keep in mind the latest developments in this space, such as [GitOps](https://queue.acm.org/detail.cfm?ref=rss&id=3237207).

GitOps takes all the ideas we have been discussing thus far to new levels — where everything is done via git, pull requests, and deployment pipelines.

Please note that GitOps and approaches like it speak to the **business** side of things. Specifically, that we are not after using complex things like git because they are cool.

Instead, we are using git to enable business agility, speed up innovation and deliver features faster — these are things that allow our business to make more money in the end!

That’s all for now!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。

