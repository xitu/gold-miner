> * 原文地址：[Why Android Testing is so Hard: Historical Edition](https://www.philosophicalhacker.com/post/why-android-testing-is-so-hard-historical-edition/)
* 原文作者：[David West](https://www.philosophicalhacker.com/)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：


![](https://www.philosophicalhacker.com/images/time.jpg)

# Why Android Testing is so Hard: Historical Edition #
          
> As a profession, we also tend to be abysmally ignorant of our own history.
> 
> David West, Object Thinking

Almost two years ago, I wrote a [couple](https://www.philosophicalhacker.com/2015/04/17/why-android-unit-testing-is-so-hard-pt-1/)[articles](https://www.philosophicalhacker.com/2015/04/24/why-android-unit-testing-is-so-hard-pt-2/) that attempted to answer the question, “Why is testing Android apps so hard?” In those posts, I suggested that the standard architecture of Android applications is what makes testing difficult. This explanation of the difficulty of testing android apps raises a deeper, more historical question: why did an architecture that makes testing difficult became the default way of building Android apps in the first place?

That’s the question I want to speculate about in this post. I think there were three things that contributed to a less-than-ideal testing situation on Android: performance concerns, confusion about the purpose of app component classes, and the newness of TDD and automated testing at the time of Android’s initial release.

### Performance ###

To some extent, there’s an inverse relationship between testable code and performant code. As Michael Feathers points out, testable code requires layers of abstraction.

> …one pervasive problem in legacy code bases is that there often aren’t any layers of abstraction; the most important code in the system often sits intermingled with low-level API calls. We’ve already seen how this can make testing difficult…1

Layers of abstraction, as Chet Haase points out, have a performance cost, a cost that we need to particularly aware of as Android developers:

> If there is some section of code that is executed rarely…,but which would benefit from a clearer style, then a more traditional layer of abstraction could be the right decision. But if analysis shows that you are re-executing some code path often and causing lots of memory churn in the process, consider these strategies for avoiding excess allocations…2

Although “#perfmatters” in 2017, performance was a much larger concern when Android was first getting off the ground, which means that the design of the Android APIs and the early practices/architectures for building Android apps was extremely performance sensitive. Its possible that building the layers of abstraction to support testing just wasn’t practical in those days.

The first Android phone, [the G1](https://www.google.com/shopping/product/1556749025834621307/specs?sourceid=chrome-psyapi2&amp;ion=1&amp;espv=2&amp;ie=UTF-8&amp;q=tmobile+g1+android&amp;oq=tmobile+g1+android&amp;aqs=chrome..69i57j0l5.2528j0j4&amp;sa=X&amp;ved=0ahUKEwjilvOU0YXSAhVG8CYKHTp2BrAQuC8IjgE), had *192 MB of RAM* and a *528MHZ* processor. Obviously, we’ve come a long way since then, and in many cases, we can now afford the additional layers of abstraction that testability requires.

One of the more interesting things I’ve heard lately that indicates how heavily performance concerns weighed on the design of Android and on the early days of Android development in the trenches comes from Ficus Kirkpatrick, one of the founding members of the Android team, in a recent episode of Android Developers backstage:

> …A lot these things like enums and this philosophy of extreme frugality when it comes to CPU cycles or memory…that’s an interesting lens to look at a lot the early Android decisions. I look at a lot of these engineers almost like they were raised during the depression and they learned to scrape the bottom of the pot.3

There’s a great discussion after this point in the podcast about the tradeoff between performance and development speed. Chet Haase and Tor Norbye push pretty hard on performance concerns while Ficus Fitzpatrick, who is now at Facebook, seems more sympathetic towards trading performance for development speed.

Who is right – or whether there was ultimately an unresolved disagreement in the end – doesn’t matter for our purposes. What matters is that their conversation, along with the [hoopla](https://plus.google.com/105051985738280261832/posts/YDykw2hstUu) [about](https://twitter.com/jakewharton/status/551876948469620737?lang=en) [enums](https://www.youtube.com/watch?v=5MzayZXtSiQ), shows clearly that the folks at Android are still very concerned about performance and this might make them less interested in promoting patterns whose abstractions have some performance overhead, even if that overhead facilitates testing.

### Misunderstanding Android Components ###

Another reason that the testing situation on Android is so bad may be that we’ve fundamentally misunderstood the purpose of Android’s app component classes (viz., `Activity`, `Service`, `BroadcastReceiver`, and `ContentProvider`). For a long time, I thought that these classes were supposed to facilitate *application development*. Not so, says Diane Hackborne:

> …With its Java language APIs and fairly high-level concepts, it can look like a typical application framework that is there to say how applications should be doing their work.  But for the most part, it is not.
> 
> It is probably better to call the core Android APIs a “system framework.”  For the most part, the platform APIs we provide are there to define how an application interacts with the operating system; but for anything going on purely within the app, these APIs are often just not relevant.

This same idea gets reiterated by Chet Haase in his *Developing for Android* medium blog post series:

> Application components (activities, services, providers, receivers) are interfaces for your application to interact with the operating system; don’t take them as a recommendation of the facilities you should architect your entire application around.4

I think by know its well-known [that putting logic in activities and other app component classes makes testing difficult](/post/why-we-should-stop-putting-logic-in-activities/) because of the lack of proper dependency injection. Because many of us believed that we were supposed to be building our applications around these components, we over-used them, worsening the testability situation in our apps.

### The Rise of Android and Unit Testing ###

Here’s one more thing that probably contributed to the sad testing situation on Android: TDD was on the rise at the same time Android was. The first release of Android was in September of 2008. *TDD by Example* one of the earliest books written on TDD-style unit testing was written a mere 3 years earlier.

The importance of automated testing is likely much more widely accepted now than it was then. Perceived importance of testability likely factored into design decisions around the Android SDK and the Android community’s willingness to develop practices and architectures that supported testing.


### Notes: ###

1. 
Michael Feathers, *Working Effectively with Legacy Code*, 350-351.

2. 
Chet Haase, *[Developing for Android II The Rules: Memory](https://medium.com/google-developers/developing-for-android-ii-bb9a51f8c8b9#.p49q9k3uj)*

3. 
“In the Beginning,” [*Android Developers Backstage*](http://androidbackstage.blogspot.com/2016/10/episode-56-in-beginning.html), ~25:00.

4. 
Haase, *[Developing for Android VII The Rules: Framework](https://medium.com/google-developers/developing-for-android-vii-the-rules-framework-concerns-d0210e52eee3#.yegpenynu)*

### We're hiring mid-senior Android developers at [Unikey](http://www.unikey.com/). Email me if you want to work for a Startup in the smart lock space in Orlando ###

#### kmatthew[dot]dupree[at][google'semailservice][dot]com ####

