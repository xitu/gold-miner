> * 原文地址：[How Google builds web frameworks](https://medium.freecodecamp.com/how-google-builds-a-web-framework-5eeddd691dea#.dv1nhpg5w)
* 原文作者：[Filip Hracek](https://medium.freecodecamp.com/@filiph)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者： 
* 校对者：

# How Google builds web frameworks

![](https://cdn-images-1.medium.com/max/1000/1*QDS-kCgeF8ZJg_JSEwwIeA.jpeg)

It’s [public knowledge](http://cacm.acm.org/magazines/2016/7/204032-why-google-stores-billions-of-lines-of-code-in-a-single-repository/fulltext) that Google uses a single repository to share code — all 2 billion lines of it — and that it uses the trunk-based development paradigm.

![](https://cdn-images-1.medium.com/max/800/1*3hPZNDocbp68XsbsJoZ-iQ.jpeg)

For many developers outside the company, this is surprising and counterintuitive, but it works really well. (The article linked above gives good examples, so I won’t repeat them here.)

> Google’s codebase is shared by more than 25,000 Google software developers from dozens of offices in countries around the world. On a typical workday, they commit 16,000 changes to the codebase. ([source](http://cacm.acm.org/magazines/2016/7/204032-why-google-stores-billions-of-lines-of-code-in-a-single-repository/fulltext))

This article is about the specifics of building an open source web framework ([AngularDart](https://webdev.dartlang.org/angular)) in this context.

![](https://cdn-images-1.medium.com/max/800/1*42xyxKFKI9a0j0BWuHGIHg.jpeg)

### Only one version

When you employ trunk-based development in a single huge repo, you have only one version of everything. That’s kind of obvious. It’s still good to point it out here, though, because it means that — at Google — you can’t have app FooBar that’s using AngularDart 2.2.1 and another app BarFoo that’s on 2.3.0. Both apps must be on the same version — the latest one.

![](https://cdn-images-1.medium.com/max/800/0*vdQqatZdTxZ9CUDs.)

Illustrative image taken from [trunkbaseddevelopment.com](https://trunkbaseddevelopment.com/).
That’s why Googlers sometimes say that all software at Google lives on the bleeding edge.

If your entire soul screams ‘dangerous!’ right now, that’s understandable. Depending on the trunk (‘master’ in git terminology) of a library with your production code sure sounds dangerous. But there’s a plot twist ahead.

### 74 thousand tests per commit

AngularDart defines 1601 tests ([here](https://github.com/dart-lang/angular2/tree/master/test)). But when you’re committing a change to AngularDart code in the Google repository, it also runs tests for *everyone at Google who depends on the framework*. At the moment, that’s about 74 thousand tests (depending on how big your change is — a heuristic skips tests that the system knows you’re not affecting).

![](https://cdn-images-1.medium.com/max/800/1*5VjjBOiVq74495vLAKctOg.png)

It’s good to have more tests.

I just made a change that only manifests itself 5% of the time, simulating something like a race condition in the change detection reinsertion verification algorithm (I added `&& random.nextDouble() > .05` to [this if statement](https://github.com/dart-lang/angular2/blob/v2.1.0/lib/src/core/change_detection/differs/default_iterable_differ.dart#L386)). It did not manifest in any of the 1601 tests when I ran them (once). But it did break a bunch of client tests.

The real value here, though, is that those are tests of *actual apps*. Not only are they numerous, they’re also reflecting how the framework is used by developers (not just the framework authors). This is significant: framework owners don’t always correctly estimate how their framework is being used.

It also helps that those apps are in production, and billions of dollars flow through them each month. There’s a big difference between demo apps that a framework author puts together in his spare time, and real production apps with tens or hundreds of person-years invested in them. If the web is to be relevant in the future, we need to better support development of the latter.

![](https://cdn-images-1.medium.com/max/800/1*DrJBfzzSTkGdmrlu6OnYfA.png)

So what happens if the framework breaks some of the apps that are built on it?

### You break it, you fix it

When AngularDart authors want to introduce a breaking change, *they have to go and fix it for their users*. Since everything at Google lives in a single repo, it’s trivial to find out whom they’re breaking, and they can start fixing right away.

Any breaking change to AngularDart also includes all the fixes to that change in all the Google apps that depend on it. So the breakage and the fix go into the repo simultaneously and — of course — after proper code review by all affected parties.

Let’s give a concrete example. When someone from the AngularDart team makes a change that affects code in the AdWords app, they go to that app’s source code and fix it. They can run AdWords’ existing tests in the process, and they can add new ones. Then, they put all of that into their change list and ask for review. Since their change list touches code in both the AngularDart repo and the AdWords repo, the system automatically requires code review approval from both of those teams. Only then can the change be submitted.

![](https://cdn-images-1.medium.com/max/800/1*kbwhvH4lz1B-jRHBCEvAcA.png)

This has the obvious effect of preventing framework development in a vacuum. AngularDart framework developers have access to millions of lines of code that are built with their platform, and they regularly touch that code themselves. They don’t need to assume how their framework is used. (The obvious caveat is that they only see the Google code and not the code of all the Workivas, Wrikes and StableKernels of the world that also use AngularDart.)

Having to upgrade your users’ code also slows development down. Not as much as you may think (look at AngularDart’s progress since October), but it still slows things down. That’s both good and bad, depending on what you want from a framework. We’ll get back to that.

Anyway. The next time someone at Google [says](https://webdev.dartlang.org/angular/version) that an alpha version of some library is stable and in production, now you know why.

### Large scale changes

What if AngularDart needs to make a major breaking change (say, going from 2.x to 3.0) and that change breaks 74 thousand tests? Will the team go and fix all of them? Will they make changes to *thousands* of source files, most of which they haven’t authored?

Yes.

One of the cool things about having a [sound type system](https://www.dartlang.org/guides/language/sound-dart) is that your tooling can be much more useful. In sound Dart, tools can be sure that a variable is of a certain type, for example. For refactoring, that means that many changes can be completely automatic, with no need of confirmation from the developer.

When a method on class Foo changes from `bar()` to `baz()`, you can create a tool that goes through the entirety of the single Google repository, finds all instances of *that *Foo class and its subclasses, and changes all mentions of `bar()` to `baz()`. With Dart’s sound type system, you can be sure this won’t break anything. Without sound types, even such a simple change can get you in trouble.

![](https://cdn-images-1.medium.com/max/800/1*yxqdl9CBoB48XG0avf4piQ.gif)

Another thing that helps with large scale changes is [dart_style](https://github.com/dart-lang/dart_style), Dart’s default formatter. All Dart code at Google is formatted using this tool. By the time your code reaches reviewers, it has been auto-formatted using dart_style, so there are no arguments about whether to put the newline here or there. And that applies to large scale refactors as well.

### Performance metrics

As I said above, AngularDart benefits from its dependents’ tests. But it’s not just tests. Google is very rigorous about measuring performance of its apps, and so most (all?) production apps have benchmark suites.

So when the AngularDart team introduces a change that makes AdWords 1% slower to load, they know *before* landing the change. When the team [said](https://www.youtube.com/watch?list=PLOU2XLYxmsILKY-A1kq4eHMcku3GMAyp2&amp;v=8ixOkJOXdMo) in October that AngularDart apps got 40% smaller and 10% faster since August, they were not talking about some synthetic tiny TodoMVC example apps. They were talking about real-life, mission-critical, production apps with millions of users and megabytes of business logic code.

![](https://cdn-images-1.medium.com/max/800/1*FFPofhArfE_q-ppyTkDniA.png)

### Side note: Hermetic build tool

You may be wondering: how did this guy know which tests in the huge internal repository to run after introducing the flaky bug in AngularDart? Surely he wasn’t hand-picking the 74 thousand tests, and just as surely he wasn’t running *all* the tests at Google. The answer lies in something called Bazel.

At this scale, you can’t have a series of shell scripts to build stuff. Things would be flaky and prohibitively slow. What you need is a hermetic build tool.

“Hermetic” in this context is very similar to “[pure](https://en.wikipedia.org/wiki/Pure_function)” in the context of functions. Your build steps cannot have side effects (like temp files, changes to PATH etc.), and they must be deterministic (same input always leads to the same output). When that’s the case, you can run the builds and the tests on any machine at any time and you’ll get consistent output. You don’t need to `make clean`. You can therefore send your builds/tests to build servers and parallelize them.

![](https://cdn-images-1.medium.com/max/800/1*sq_8UFpeBsxSIpBXpmWiSg.png)

Google has spent years developing such a build tool. It was open sourced last year as [Bazel](https://bazel.build/).

And thanks to this piece of infrastructure, internal testing tools can determine which builds/tests each change affects, and run them when appropriate.

### What does it all mean?

AngularDart’s explicit goal is to be best-in-class in productivity, performance and dependability for building large web applications. This post hopefully covers the last part — dependability — and why it’s important that mission-critical Google apps like AdWords and AdSense are using the framework. It’s not just the team boasting about their users — as explained above, having large internal users makes AngularDart less likely to introduce superficial changes. It makes the framework more dependable.

![](https://cdn-images-1.medium.com/max/800/1*BjhLEoihrMr6eRcTYL50ag.png)

If you’re looking for a framework that makes major overhauls and introduces major features every few months, AngularDart is definitely not for you. Even if the team wanted to build the framework in such a way, I think it’s clear from this article that they couldn’t. We sincerely believe, though, that there is space for a framework that is less trendy but dependable.

In my opinion, the best prediction of long-term support of an open-source tech stack is that it’s a big part of the primary maintainer’s business. Take Android, dagger, MySQL, or git as examples. That’s why I’m glad that Dart finally has one preferred web framework (AngularDart), one preferred component library ([AngularDart Components](https://pub.dartlang.org/packages/angular2_components)) and one preferred mobile framework ([Flutter](https://flutter.io/)) — all of which are used to build business-critical Google apps.