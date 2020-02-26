> * 原文地址：[The History of Git: The Road to Domination in Software Version Control](https://www.welcometothejungle.com/en/articles/btc-history-git)
> * 原文作者：[Andy Favell](https://twitter.com/andy_favell)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/btc-history-git.md](https://github.com/xitu/gold-miner/blob/master/TODO1/btc-history-git.md)
> * 译者：
> * 校对者：

# The History of Git: The Road to Domination in Software Version Control

![Coder stories](https://cdn.welcometothejungle.co/uploads/article/image/6172/158080/git-history-linus-torvalds.png)

**In 2005, Linus Torvalds urgently needed a new version control system to maintain the development of the Linux Kernel. So he went offline for a week, wrote a revolutionary new system from scratch, and called it Git. Fifteen years later, the platform is [the undisputed leader in a crowded field](https://en.wikipedia.org/wiki/List_of_version-control_software).**

Worldwide, huge numbers of start-ups, collectives and multinationals, including Google and Microsoft, use Git to maintain the source code of their software projects. Some host their own Git projects, others use Git via commercial hosting companies such as GitHub (founded in 2007), Bitbucket (founded in 2010) and GitLab (founded in 2011). The largest of these, GitHub, has [40 million registered developers](https://octoverse.github.com/) and was [acquired by Microsoft](https://news.microsoft.com/2018/06/04/microsoft-to-acquire-github-for-7-5-billion/) for a whopping $7.5 billion in 2018.

Git (and its competitors) is sometimes categorized as a version control system (VCS), sometimes a source code management system (SCM), and sometimes a revision control system (RCS). Torvalds thinks life’s too short to distinguish between the definitions, so we won’t.

Part of the appeal of Git is that it’s open source (like Linux and Android). However, there are other open-source VCS, including Concurrent Versions System (CVS), Subversion (SVN), Mercurial, and Monotone, so that alone does not explain its ascendancy.

The best indication of Git’s market dominance is [a survey of developers by Stack Overflow](https://insights.stackoverflow.com/survey/). This found that 88.4% of 74,298 respondents in 2018 used Git (up from 69.3% in 2015). The nearest competitors were Subversion, with 16.6% penetration (down from 36.9%); Team Foundation Version Control, with 11.3% (down from 12.2%); and Mercurial, with 3.7% (down from 7.9%). In fact, so dominant has Git become that the data scientists at Stack Overflow didn’t bother to ask the question in their 2019 survey.

```
What are developers using for source control?

|           2018         |          2015          |
| ---------------------- | ---------------------- |
| Git: 88.4%             | Git: 69.3%             |
| Subversion: 16.6%      | Subversion: 36.9%      |
| Team Foundation: 11.3% | Team Foundation: 12.2% |
| Mercurial: 3.7%        | Mercurial: 7.9%        |
|                        | CVS: 4.2%              |
|                        | Perforce: 3.3%         |

| 74,298 responses       | 16,694 responses       |

Source: Stack Overflow Developer Survey 2018/2015 
```

## In the beginning

Up until April 2005 Torvalds had managed the contributions of a large, disparate team of volunteer developers to Linux Kernel—the increasingly popular open-source, UNIX-like operating system—using [BitKeeper](http://www.bitkeeper.org/) (BK). This was a proprietary and paid-for tool at the time, but the Linux development crew were allowed to use it for free… until BK founder Larry McVoy took issue with one of the Linux developers over inappropriate use of BK.

From [Torvalds’s announcement](https://marc.info/?l=linux-kernel&m=111280216717070&w=2) to the Linux mailing list about his plan to take a working “vacation” to decide what to do about finding a new VCS for Linux, it is clear that he liked BK, was frustrated that Linux could no longer use it, and that he was unimpressed by the competition. As mentioned, the outcome of that vacation was Git. There are several theories why Torvalds called it Git, but the reason is actually just that he liked the word, which he’d learned from the Beatles song [I’m So Tired](https://genius.com/The-beatles-im-so-tired-lyrics) (verse two).

**“The in-joke was that I name all my projects after myself, and this one was named ‘Git’. Git is [British slang](https://dictionary.cambridge.org/dictionary/english/git) for ‘stupid person’,”** Torvalds tells us. **“There’s a made-up acronym for it, too—Global Information Tracker—but that’s really a ‘backronym’, \[something\] made up after the fact.”**

So, is Torvalds surprised by Git’s monumental success? **“I’d be lying if I said I saw it coming. I absolutely didn’t. But Git really did get all the fundamentals right. Were there things that could have been done better? Sure. But in the big picture, Git really finally solved some of the really hard problems with VCS,”** he says.

## Defining Git’s goals

Traditionally, version control was client server, so the code sits in a single repository —or repo—on a central server. Concurrent Versions System (CVS), [Subversion](https://en.wikipedia.org/wiki/Apache_Subversion) and Team Foundation Version Control (TFVC) are all examples of client-server systems.

A client-server VCS works fine in a corporate environment, where development is tightly controlled and is undertaken by an in-house development team with good network connections. It doesn’t work so well if you have a collaboration involving hundreds or thousands of developers, working voluntarily, independently, and remotely, all eager to try out new things with the code, which is all typical with open source software (OSS) projects such as Linux.

Distributed VCS, pioneered by BK, broke that mould. Git, Mercurial, and Monotone all followed this example. With distributed VCS, a copy of the most current version of the code resides on each developer’s device, making it easier for developers to work independently on changes to the code. **“BK was the big conceptual influence for the usage model, and really should get all the credit. For various reasons, I wanted to make the Git implementation and logic completely different from BK, but the conceptual notion of ‘distributed VCS’ really was the number one goal, and BK taught me the importance of that,”** says Torvalds. **“Being truly distributed means forks are non-issues, and anybody can fork a project and do their own development, and then come back a month or a year later and say, ‘Look at this great thing I’ve done.’”**

Another major drawback with client-server VCS, especially for open-source projects, is whoever hosted the central repository on their server “owned” the source code. With distributed VCS, however, there is no central repository, just lots of clones, so nobody owns or controls the code.

**“\[This is what makes\] sites like GitHub possible. When there is no central ‘master’ location that contains the source code, you can suddenly host things without the politics that go along with that ‘one repo to rule them all’ concept,”** says Torvalds.

Another central goal was to reduce the pain of merging new branches into the main source code or “tree” (the directory that makes up the source code’s hierarchy). Key to this is assigning a cryptographic hash—a unique and secure number—to index every object. Using hashes wasn’t unique, but Git took it to a new level, not just applying them to every new version of file contents, but also using them to identify how they relate to each other, including trees and the commits. This meant that, by using ‘git diff’, Git could very quickly identify all the changes between new/proposed versions of branches and the source code, even entire trees, by comparing the two indexes of hashes. **“The real reason for the Git index is to act as that intermediate step for merging, so that you can incrementally fix conflicts,”** says Torvalds.

This concept of the intermediate step or staging area to allow comparisons of versions and fix any problems between the main source code and the additions, before going ahead with the full merge, was revolutionary. However, it was not universally appreciated by those used to other VCS.

## Appointing a maintainer

Having written Git, Torvalds threw it open to the open-source community for review and contributions. Of those who stepped up, one developer in particular shone through: Junio Hamano. So much so, that after only a few months, Torvalds could take [a step back](https://marc.info/?l=git&m=112243466603239) and concentrate on Linux, passing over responsibility for maintaining Git to Hamano. **“He had that obvious and all-important but hard-to-describe ‘good taste’ when it came to code and features,”** says Torvalds. **“Junio really should get pretty much all the credit for Git—I started it, and I’ll take credit for the design, but as a project, Junio is the person who has maintained it and made it be such a pleasant tool to use.”**

Clearly he was a good choice because he is still leading/maintaining Git 15 years later, as a [benevolent dictator](http://oss-watch.ac.uk/resources/benevolentdictatorgovernancemodel), which means he controls the direction of Git and has the final say on changes to the code, and he holds the record for the most commits.

## Widening Git’s appeal

Some of the volunteer contributors who supported Hamano in the early days still contribute today, although they are often now employed to do it full time by the companies that rely on Git and want to invest in its upkeep and improvement.

One of these volunteers was Jeff King, known as Peff, who started contributing when he was a student. His first commit was in 2006, having spotted and fixed a bug in [git-cvsimport](https://git-scm.com/docs/git-cvsimport), when moving his repositories from CVS to Git. **“I was a graduate student in computer science at the time,”** he says, **“so I spent a lot of time lurking on Git’s mailing list, answering questions and fixing bugs—sometimes things that bothered me, sometimes in response to other people’s reports. By around 2008, I had become one of the main contributors, quite by accident.”** King has been employed by GitHub since 2011, both working on the website and contributing to Git itself.

King singles out the exemplary work of two fellow contributors to Git, who both started in 2006 and helped to expand its influence beyond the Linux community: Shawn Pearce for his work on [JGit](https://gerrit.googlesource.com/jgit/), which opened up Git to the Java and Android ecosystem, and Johannes Schindelin, for his work on Git for Windows, which opened up Git to the Windows community. They subsequently went to work at Google and Microsoft respectively.

**“\[Shawn Pearce\] was an early contributor to Git and implemented [git-gui](https://git-scm.com/docs/git-gui), the first graphical interface for Git. But more important is his work on JGit, a pure-Java implementation of Git,”** says King. **“This enabled a whole other ecosystem of Git users and allowed an Eclipse plugin, which was a key part of the Android project selecting Git as their version control system. He also wrote [Gerrit](https://www.gerritcodereview.com/) \[when at Google\], a code-review system based around Git that’s used for Android and many other projects. Sadly, [Shawn passed away in 2018](https://sfconservancy.org/blog/2018/jan/30/shawn-pearce/).”**

Schindelin remains the maintainer of the [Git for Windows distribution](https://gitforwindows.org/) today. **“Because of the way Git grew out of the kernel community, Windows support was mostly an afterthought,”** says King. **“Git has been ported to a lot of platforms, but most of them are vaguely Unix-ish. Windows was by far the biggest challenge. There were not only portability issues in the C code, but also the challenges of shipping an application with parts written in Bourne shell, Perl, and so on. Git for Windows wrangles all of that complexity into a single binary package, and has had a big impact on the growth of Git for Windows developers.”**

According to [somsubhra.com](https://www.somsubhra.com/github-release-stats/?username=git-for-windows&repository=git), Git for Windows has been downloaded more than 18m times to date.

## Founding GitHub

Tom Preston-Werner was introduced to Git by coworker Dave Fayram while working on a side project for a start-up called [Powerset](https://en.wikipedia.org/wiki/Powerset_(company)). **“The ability to create branches \[within Git\], work on them, and easily merge them back into the master branch, was revolutionary. In that regard it was amazing. The command line interface took a bit of getting used to, especially the notion of a staging area,”** says Preston-Werner. The opportunity to offer source-code hosting services based on Git was evident. **“There weren’t any good options to host Git repos, so that was a big barrier to ease of use. Also missing was a modern web interface. As a web developer, I thought I’d be well positioned to improve the situation by making it easy to host Git repos and foster collaboration, something that Git made possible, but did not make easy,”** he adds.

Preston-Werner teamed up with Chris Wanstrath, Scott Chacon and P.J. Hyett to start developing GitHub in late 2007. GitHub helped to take Git mainstream, both by making it easier to use and spreading the word beyond the Linux fraternity. As the GitHub founders were Ruby developers and GitHub was written in Ruby, the word spread fast through that community, hitting the big time when it was adopted by the development framework [Ruby on Rails](https://github.com/rails/rails).

**“By mid-2008, Ruby on Rails switched to GitHub and it seemed like the entire Ruby community followed very quickly. I think that endorsement, combined with Ruby developers’ willingness to embrace newer, better technologies, was critical to our success,”** says Preston-Werner. **“Other projects, like [Node.js](https://github.com/nodejs) and [Homebrew](https://github.com/Homebrew), started out on GitHub and helped bring in new communities.”**

Preston-Werner [resigned as CEO of GitHub](https://github.blog/2014-04-28-follow-up-to-the-investigation-results/) in 2014, amid allegations of bullying and inappropriate complaints procedures, issues that are perhaps symptomatic of a company that had grown too fast.

Today, according to its [own data](https://octoverse.github.com/), GitHub has more than 40m registered developers. This makes it considerably larger than its competitors—[Bitbucket has 10m users](https://bitbucket.org/blog/celebrating-10-million-bitbucket-cloud-registered-users), while GitLab says it has “millions” of users.

## Adoption by Android

Many corporations use the hosting services of [GitHub Enterprise](https://github.com/customer-stories?type=enterprise), [GitLab](https://about.gitlab.com/customers/), or Bitbucket for software projects. But the largest Git installations tend to be internally hosted—and therefore out of public view—often with bespoke modifications.

The first major corporate adopter (thus providing a huge endorsement) of Git was Google, which decided in March 2009 to use Git for Android, its Linux-based operating system for mobile phones. Being open source, Android needed a platform that allowed a huge ecosystem of developers to clone, work with, and contribute to the code without requiring the purchase/license of specific tools in order to do so.

At the time, Git was not considered sufficient to manage a project of this magnitude, so the team built [Repo](https://gerrit.googlesource.com/git-repo/)—a super-repository that delegates to sub-Git repositories. However, [Google states](https://gerrit.googlesource.com/git-repo/): **“Repo is not meant to replace Git, only to make it easier to work with Git.”** To help view Repo and manage/review changes to the source, the team—led by Pearce—built [Gerrit](https://gerrit.googlesource.com/gerrit/).

## Microsoft changes its tune

Given the history of mutual animosity between the open-source community and Microsoft, the software giant has to be the most unlikely supporter of Git. In 2001, the then-Microsoft CEO, Steve Ballmer, even [called Linux a cancer](https://www.theregister.co.uk/2001/06/02/ballmer_linux_is_a_cancer/), and Microsoft had its own competing VCS TFVC.

Schindelin worked for years on Git for Windows without anyone at Microsoft noticing his efforts. However, by 2015, when he took a job at Microsoft, there had been a huge cultural shift. **“If you had asked me in 2007, or for that matter in 2011, whether I would ever own a Windows machine or even work at Microsoft, I would have died of laughter,”** he jokes.

The first evidence of this cultural shift came in 2012, when Microsoft started to contribute (substantially) to [libgit2](https://libgit2.org/), a library of Git development resources, to help speed up Git applications, which was then embedded in its developer tools. Edward Thomson, then part of the Microsoft team, remains the maintainer of libgit2.

In 2013, Microsoft shocked the tech world by [announcing Git support](https://devblogs.microsoft.com/bharry/git-init-vs/) for its development tools/environment Visual Studio (VS) and that Git hosting would be offered through its suite of cloud-based tools and services Azure DevOps (then called Team Foundation Service) as an alternative to its own TFVC.

Even more remarkable, from 2014, under the new open-source-friendly CEO Satya Nadella, was Microsoft’s gradual standardization on Git of its own internal software development, through the [One Engineering System](https://devblogs.microsoft.com/bharry/scaling-git-and-some-back-story/) (1ES) initiative. The precedent was set when the Azure DevOps team started using its own Git services as a repository for their own source code in 2015.

In 2017, the entire development effort for the Microsoft Windows suite of products moved to Git, hosted by Azure, creating [the world’s largest Git repository](https://devblogs.microsoft.com/bharry/the-largest-git-repo-on-the-planet/). This included considerable moderations to help Git scale. Rather than downloading the entire 300GB Windows repository to each client device, [the Virtual Filesystem for Git](https://vfsforgit.org/) (which is open source) ensures that only the appropriate files are downloaded to each engineer’s computer.

As Schindelin points out: **“When a company this big, with a history as Microsoft has, decides that Git is enterprise-ready, the business world listens very carefully. I think this is why Git is ‘the winner,’ at least for right now.”**

## Sold!

The [announcement](https://news.microsoft.com/2018/06/04/microsoft-to-acquire-github-for-7-5-billion/), in June 2018, that Microsoft would acquire GitHub for $7.5 billion in Microsoft stock came as a big surprise. But when you look at the facts, maybe the acquisition wasn’t so unexpected.

Microsoft had been involved with GitHub since 2014, when the .Net developer platform was [open sourced](https://devblogs.microsoft.com/dotnet/net-core-is-open-source/). According to [GitHub Octoverse 2019](https://octoverse.github.com/), the two most-contributed-to technologies on GitHub are currently both Microsoft products—[Visual Studio code](https://github.com/microsoft/vscode) and [Microsoft Azure](https://github.com/Azure)—while [OSCI/EPAM research in 2019](https://solutionshub.epam.com/OSCI/) revealed that Microsoft is the largest corporate contributor on GitHub. And, as already mentioned, Microsoft had standardized its internal development on Git.

```
Number of contributors to open-source projects

|                 Projects               |  Contributors |
| -------------------------------------- | ------------- |
| Microsoft/vscode                       | 19.1k         |
| MicrosoftDocs/azure-docs               | 14k           |
| flutter/flutter                        | 13k           |
| firstcontributions/first-contributions | 11.6k         |
| tensorflow/tensorflow                  | 9.9k          |
| facebook/react-native                  | 9.1k          |
| kubernetes/kubernetes                  | 6.9k          |
| DefinitelyTyped/DefinitelyTyped        | 6.9k          |
| ansible/ansible                        | 6.8k          |
| home-assistant/home-assistant          | 6.3k          |

Source: GitHub Octoverse 2019 
```

```
Number of active contributors in companies to open-source projects on GitHub

|   Company    |  Active contributors |
| -------------| -------------------- |
| Microsoft    | 4,859                |
| Google       | 4,457                |
| Red Hat      | 2,766                |
| IBM          | 2,108                |
| Intel        | 2,079                |
| Facebook     | 1,114                |
| Amazon       | 850                  |
| Pivotal      | 767                  |
| SAP          | 732                  |
| GitHub       | 663                  |

Source: OSCI/EPAM research January 2020 
```

Despite this, the acquisition caused some concern among those GitHub clients that remember the old Microsoft under the stewardship of the open-source community’s bête noire, Ballmer. Both Bitbucket and GitLab claim to have seen a spike in projects moving from GitHub to their platforms.

That concern is not shared by Torvalds, though. **“I don’t have any reservations about the MS acquisition, partly because of the whole fundamental distributed nature of Git—it avoids the political issues, and it avoids the scary ‘hosting company controls the projects’ part. The other reason I’m not worried is I think MS is a different company today… Microsoft and open source simply aren’t enemies,”** he says. **“On a purely personal level, when I heard that MS spent a lot of money on GitHub, it just made me say, ‘Now two of the projects I’ve started have become billion-dollar industries.’ Not a lot of people can say that. Nor am I just a ‘one-hit wonder.’  
“It is part of the ‘life well lived’ thing. It makes me happy that I have made a positive and meaningful influence on the world. I may not have made any money personally from Git directly, but it makes it possible for me to do my real job and passion, \[Linux\]. And I am not a starving student anymore—I’m doing quite well as a respected programmer. So other people being successful with Git in no way upsets me.”**

**Contributors. Thanks to: Linus Torvalds, founder of Git and Linux; Johannes Schindelin, Software Engineer, Microsoft, and maintainer of Git for Windows; Jeff King, OSS developer, GitHub; Tom Preston-Werner, Chatterbug cofounder, co-founder GitHub; Edward Thomson, Product Manager, GitHub, and maintainer libgit2; Ben Straub, author of Pro Git; Evan Phoenix, creator of Rubinius; Christian Couder, Senior Backend Engineer, GitLab; Todd Barr, Chief Marketing Officer, GitLab; and Patrick Stephens, Director, Delivery Management, EPAM.**

**This article is part of Behind the Code, the media for developers, by developers. Discover more articles and videos by visiting [Behind the Code](https://www.welcometothejungle.com/collections/behind-the-code)!**

**Want to contribute? [Get published!](https://docs.google.com/forms/d/e/1FAIpQLSeelH8Eh0HohNrrDWnmKJGBRsFijXfMsMw1fPxOSGdMVypCyg/viewform?usp=sf_link)**

**Follow us on [Twitter](https://twitter.com/behind_thecode) to stay tuned!**

**Illustration by [Blok](https://fr.creasenso.com/portfolio/blok)**

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
