> * 原文地址：[Why I close PRs (OSS project maintainer notes)](http://www.jeffgeerling.com/blog/2016/why-i-close-prs-oss-project-maintainer-notes)
* 原文作者：[Jeff Geerling](http://www.jeffgeerling.com/)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

# Why I close PRs (OSS project maintainer notes)

![GitHub project notifications geerlingguy/drupal-vm PRs](http://www.jeffgeerling.com/sites/jeffgeerling.com/files/images/github-project-notifications-prs.jpg) 

I maintain many open source projects on GitHub and elsewhere (over 160 as of this writing). I have merged and/or closed thousands of Pull Requests (PRs) and patches in the past few years, and would like to summarize here many of the reasons I *don't* merge many PRs.

A few of my projects have co-maintainers, but most are just me. The [bus factor](https://en.wikipedia.org/wiki/Bus_factor) is low, but I offset that by granting very open licenses and encouraging forks. I also devote a set amount of time (averaging 5-10 hours/week) to my OSS project maintenance, and have a personal budget of around $1,000/year to devote to infrastructure to support my projects (that's more than most for-profit companies who *use* my projects devote to OSS, sadly).

I don't like closing a PR without merging, because a PR means someone liked my project enough to contribute back. But sometimes it's necessary. I'm not trying to be a jerk (and I usually start by thanking the contributor to try to soften the blow of a closed PR), I'm just ensuring the continued health of the project. Below are the principles behind how I maintain my projects, and hopefully by reading through them you'll understand more about why I choose to close PRs instead of merging.

## Principles for Evaluating Pull Requests ##

For the projects I maintain (and indeed, for most software I work on in general), I hold the following principles to be the most important, and will usually close a PR if it doesn't hold up to these principles:

### Everything should be well-tested with automation ###

Almost every project I maintain has at least full coverage of the 'happy path' running through Travis CI, Jenkins, or another CI system. [If You Breaka My Tests I Breaka You Face](https://www.amazon.com/SmartSign-Lyle-K2-0113-AL-12x18-Breaka-Aluminum/dp/B01KIYWD70/ref=as_li_ss_tl?ie=UTF8&amp;qid=1482861696&amp;sr=8-1-fkmr0&amp;keywords=if+you+taka+my+space+i+breaka+your+face&amp;linkCode=ll1&amp;tag=mmjjg-20&amp;linkId=71ba06c689653589697ff5c93c95491f). With rare exceptions, I will not merge a PR if all tests aren't passing. I also will not merge PRs that have large amounts of new, untested functionality. I don't require 100% unit test coverage, but all happy paths should be tested.

### Maintainabilty > completeness ###

I don't cater to everyone. I usually cater to myself. And for 98% of my OSS projects, I'm actually *using* them, live, in production (often for dozens or hundreds of projects). So I'm generally happy with them as they are. I will not add something that increases my maintenance burden unless it's very compelling functionality or an obvious bugfix. I can't maintain a system I don't fully understand, so I like keeping things lighter and cutting off edge cases rather than adding [technical debt](http://martinfowler.com/bliki/TechnicalDebt.html) I don't have time to pay off.

### Cater to the 80% use case ###

I see a lot of PRs for one-off functionality that I've personally *never* seen in the wild. Sure there are unicorn systems out there that need to configure hairy details in some obscure app... but I'm not going to include code for that in my projects because (a) I don't use it, so I can't vouch for it, and (b) it adds maintenance overhead—even if it's a 'simple' addition. If you are one of the unicorns, please fork my work. I won't get offended! My public projects are almost always meant to solve the [most common problems](https://en.wikipedia.org/wiki/Pareto_principle); and I try to make it easy to go deeper by either forking my work or extending it.

### Use proper syntax ###

Often, I have automated syntax review built into my automated testing. But when I don't, please make sure basic things like spacing, variable naming conventions, line endings, [spaces instead of tabs](https://www.youtube.com/watch?v=SsoOG6ZeyUI), and the like follow the general style of the project. I will often merge code then fix the style myself, but it's much nicer to not have to do this, and I'm more willing to merge a PR that has no style quirks.

### Don't change architecture ###

(Unless first discussed in an issue.)

I've had PRs where the entire project architecture or test architecture was swapped out. I will never merge something like this unless it's been thoroughly discussed (and approved) in an issue first. There's usually a reason (*many* reasons, in fact) why things are the way they are. I'm not saying my architecture or test rigs are always *right*, but I will not merge in sweeping changes to things which make it harder for me to understand how my own projects work.

### Don't change more than 50 lines of code in one PR ###

(Unless you have very good reason.)

Too often I get a notification that someone submitted a PR, I jump over to review it, and I see 20 files changed with 800 lines of code added across 12 commits. If this is an architectural change previously discussed in an issue, I can understand a large PR like this, and I'll take the time to read through it. But anything more than ~50 lines of changes and my brain doesn't have the capacity to do a good code review in less than an hour.

## Conclusion: 'No' is the default ##

One of the greatest ironies about this process is that some of the people who open issues and subsequent PRs and are the most [persistent|annoying|difficult] are those who want one problem solved in their own project but will vanish immediately after the code is merged. They realize (usually not *explicitly*) that if they can convince *me* to maintain their snowflake code, they can save themselves that ongoing technical burden.

If contributors are willing to establish a long-term relationship with the project, I'm willing to concede some control over the architecture. But they have to prove that I can trust them. A few of the best contributors to projects I started are ones who use the projects in their for-profit work, but donate an hour or two a week to help tend the issue queues, close out invalid issues, and submit PRs for simple bug fixes (especially related to parts of the project they're most familiar with).

To anyone else maintaining OSS projects: make sure you have a well-established set of principles by which you can evaluate PRs. And **feel free to say 'no'** when a PR doesn't meet your standards. So many projects get derailed by accepting too many new features without evaluating them for long-term maintainability, and it's a problem that's avoided by a simple two-letter word.
