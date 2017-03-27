> * 原文地址：[Flying Solo with Android Development](https://hackernoon.com/flying-solo-with-android-development-c52d911b62bf#.yhgjjtwz1)
> * 原文作者：[Anita Singh](https://hackernoon.com/@anitas3791?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：
> * 校对者：

# Flying Solo with Android Development #

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*gqA2o9GN2tU2xaIMuddXJg.jpeg">

Photo credit : [http://www.magic4walls.com/crop-image?id=14269](http://www.magic4walls.com/crop-image?id=14269) 

My Android career started two-and-a-half years ago, when I transitioned from back-end development to mobile development, along with the support of a four-person Android team. A year later, I joined a series-B startup, where I was one of two Android engineers for most of my time there. Working on small teams was a great way to have independence and also learn from other engineers.

But then, five months ago, I took a leap from small team to no team when I joined a seed-funded startup of six employees as their **only** Android engineer. In my new role, I’ve been building the [Winnie](https://winnie.com/)  app from scratch, which just got [released](https://winnie.com/android) !

It turns out this was a big leap. Flying solo has been a challenge, but it’s also been extremely rewarding. I’ve learned along the way that there are pros and cons to working alone. Most importantly, there are things you can do to set yourself up for success. Here are some of the tactics that have helped me thus far.

#### **Be connected with the community. Do your homework.** ####

One of my worries about going solo was not having Android teammates to discuss new ideas with or be a sounding board for their ideas, which I’ve thoroughly enjoyed in my previous roles.

The good news is that there are tons of resources available online to expand your knowledge and perspectives. From online talks from various conferences such as [**DroidCon**](https://twitter.com/droidcon?ref_src=twsrc%5Egoogle%7Ctwcamp%5Eserp%7Ctwgr%5Eauthor), [**360|AnDev**](http://360andev.com/) ,etc to your timely dose from [**Fragmented Podcast**](http://fragmentedpodcast.com/) , [**Android Dialogs**](https://www.youtube.com/channel/UCMEmNnHT69aZuaOrE-dF6ug/videos)  and [**Android Weekly**](http://androidweekly.net/) , there are many ways to broaden your thinking.

My personal favorite is [**Caster.io**](https://caster.io/) — the code samples with every bite-sized lecture keeps me on my toes! Local meet ups or virtual communities like the [**AndroidDev subreddit**](https://www.reddit.com/r/androiddev/) , [**Google+ communities**](https://plus.google.com/communities/105153134372062985968) ,Slack groups and Twitter are great places to continue the conversation and ask questions when stuck!

#### **Review your own PR’s and maintain high standards.** ####

I highly encourage opening PR’s and then reviewing them yourself. It will feel silly commenting on your own PR’s, but I think it’s a healthy habit when working by yourself (also discussed in this relevant Android Dialogs [episode](https://www.youtube.com/watch?v=CtxBO9zq7vQ).

I do a first-pass using the preview feature of Github, and then let it sit for a while before I look at it again. I try my best to review my PR’s as I would review PR’s from a peer, and thus hold myself to the same standards. A second look at all your code also **helps catch bugs and edge-cases, as well as keeps your code consistent and clean.**

#### **A “bad” pattern is often better than no clear pattern.** ####

You will have to make many decisions — should you use [MVVM](https://upday.github.io/blog/model-view-viewmodel/) , [MVP](https://medium.com/upday-devs/android-architecture-patterns-part-2-model-view-presenter-8a6faaae14a5#.vcztbt47h) , [Flux](http://lgvalle.xyz/2015/08/04/flux-architecture/), and/or another architectural pattern? Fragments or custom ViewGroups? What should have abstractions and what shouldn’t?

It’s not uncommon to start with one pattern and then realize another pattern is better when you’re at the beginning of a project, which leads to either some refactoring or diverging of patterns.

While it makes sense to break your patterns for certain cases, it is best to be mindful of refactoring and changing it consistently everywhere when you’ve found something you like better. This might sound obvious but it’s easy to just use the new pattern for all the new code when you’re working by yourself, which can quickly result in a confusing and incoherent codebase before you know it! **Even if the patterns aren’t great, consistency makes it easier to fix down the line**.

#### **Strongly consider using Kotlin.** ####

Especially if you are starting from scratch! If not, consider giving it a shot with the next class you’re going to write.

I didn’t end up using [Kotlin](https://kotlinlang.org/) because I wasn’t confident about pitching the idea, since I had zero experience with it at the time and didn’t want to discourage the back-end Java developers on the team from contributing to the codebase.

However, after watching [Christina’s talk](https://www.youtube.com/watch?v=mDpnc45WwlI)  on Kotlin and doing more research,** if I were to do it again, I’d have at least tried it. **Kotlin has plenty of advantages — even just avoiding crashes because of null pointer exceptions and not dealing with Java boilerplate has me sold! This [talk](https://realm.io/news/oredev-jake-wharton-kotlin-advancing-android-dev/)  by Jake Wharton is also a great starting-point.

#### **Try to keep control by not being too reliant on third-party libraries.** ####

I remember spending a bunch of time trying to decide on a library to use for MVP, as there are many of them. While being spoiled for choice is a great problem to have, I ended up implementing a simple version myself and have been very happy with it!

When choosing what third-party libraries to use, I’d suggest considering whether you really need it and how it would restrict the development of the app in the future — does it make unit testing harder? Does it restrict using features that Android gives for free, like transition animations between screens? Is it actively under development and do many apps use it? This helped me make informed trade-offs and decisions.

**I’d recommend optimizing for retaining as much control as possible without reinventing the wheel.** There is a library out there for pretty much everything, but you’re better off implementing some stuff yourself.

#### **Have a testing and accessibility plan.** ####

If you are building from scratch, it is very exciting that you have a **chance to do this right** from day one! And if not, you can try doing it right with all the new code you write!

It isn’t uncommon that testing and accessibility take the backseat when trying to hit aggressive deadlines — and when you’re solo, it can be harder to find time for it since you aren’t sharing the load with anyone else.

I will admit that I am only in the beginning of this journey myself, however I wrote code with testing in mind by using dependency injection, Model View Presenter pattern, exposing only interfaces of my model objects to the UI, and so forth with the goal of making it easier to test. I also had [**CircleCI**](https://circleci.com/)  build after each commit from the beginning of the project, as a sanity check and to get closer to running tests.

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*IlMGg4Voi3RcLi7sjVQP0g.gif">

For accessibility, I add content descriptions whenever I can, and use the [**Accessibility Scanner**](https://play.google.com/store/apps/details?id=com.google.android.apps.accessibility.auditor&amp;hl=en)  before a release to figure out what I should focus on next. There is definitely more work to be done, but it is a start. Here is a great [talk](https://realm.io/news/kelly-shuster-android-is-for-everyone/)  by Kelly Schuster on actionable steps that developers can take to make their apps more accessible.

If you aren’t able to spend time on writing tests, then have a manual testing plan handy. For example, write down different test cases (positive, negative) in a document for each feature and make sure to test those before every release! **Set deadlines for yourself to start writing tests, and do the same for accessibility improvements, otherwise they’ll most likely never get done**.

#### **Tell your iOS designers that they are wrong and look for potential Android converts :-).** ####

Don’t be afraid to stand up for what is right for your platform! When you’re solo, you are responsible for bringing others up to speed with the latest Android UI patterns, as well as the codebase.

I mostly worked off iOS screenshots but used the [material design spec](https://material.io/guidelines/)  and well-designed Android apps as resources to help me convert those designs to Android. Also, there is nothing better than linking to the official material design documentation to make your point!

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*xFUdWXDI9s_aHY949_vZ8w.gif">

Regarding the codebase, I helped bring my CEO up to speed with our architecture and concepts like MVP, Dagger2, RxJava2 and so forth when she helped out for a couple of months. I’d recommend keeping a lookout for potential Android converts, as **explaining your decisions to someone or teaching them a new concept helps you really own it or alternatively, realize your mistake.**

#### Go to beta as early as possible. ####

This is applicable if you are working on app that hasn’t been launched yet or are making major changes to an existing app. Google play has an [alpha and beta channel](https://support.google.com/googleplay/android-developer/answer/3131213?hl=en), and within the beta channel you can either have a closed or open beta.

If you are working on an existing app, you can still have a beta run in parallel, so long as it’s version is higher than the production app. If it is an open-beta, users will be able to opt in on the playstore or by clicking on a link. If you are trying to test out changes of a smaller scale, then [staged-rollouts](https://support.google.com/googleplay/android-developer/answer/6346149?hl=en) might be better for that.

If you are working on a new app, I’d suggest **having a closed beta as soon as possible, and converting that to an open beta when it’s ready, before the launch.** Our first closed beta had very few features, but it helped us iron out bugs early on, get onto a regular release train and receive valuable feedback throughout the process. This also resulted in a stress-free and smooth launch!

Going solo for the first time is a great learning experience as you get to **challenge yourself** like never before, be more self-reliant, exercise total creative control over the codebase (for better or for worse), learn more about what you like, and deal with making mistakes that you only have yourself to blame (yay). I was nervous about going solo but it turned out to be a fun experience as the above suggestions worked for me. I hope they will be helpful for you too!

Are you considering going solo or want to share your experience? I’d love to hear from you! Please comment or ❤ the post, or feel free to get in touch on [Twitter](https://twitter.com/anitas3791).
