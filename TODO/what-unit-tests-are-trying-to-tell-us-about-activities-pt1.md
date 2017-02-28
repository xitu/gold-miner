> * 原文地址：[What Unit Tests are Trying to Tell us about Activities: Pt. 1](https://www.philosophicalhacker.com/post/what-unit-tests-are-trying-to-tell-us-about-activities-pt1/)
* 原文作者：[Philosophical Hacker](https://www.philosophicalhacker.com)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者： 
* 校对者：

![](https://www.philosophicalhacker.com/images/broken-brick.jpg)

# What Unit Tests are Trying to Tell us about Activities: Pt. 1

`Activity`s and `Fragment`s, perhaps by [some strange historical accidents](/post/why-android-testing-is-so-hard-historical-edition/), have been seen as *the optimal* building blocks upon which we can build our Android applications for much of the time that Android has been around. Let’s call this idea – the idea that `Activity`s and `Fragment`s are the best building blocks for our apps – “android-centric” architecture.

This series of posts is about the connection between the testability of android-centric architecture and the other problems that are now leading Android developers to reject it; it’s about how our unit tests are trying to tell us that `Activity`s and `Fragment`s don’t make the best building blocks for our apps because they force us to write code with *tight coupling* and *low cohesion*.

In this first part of the series, I want to say a little about why I think android-centric architecture has been dominant for so long and to provide a little background on why I think unit tests have insightful things to say about rejecting android-centric architecture.

### What is Android-Centric Architecture?

An android-centric architecture is one in which each screen the user sees is *ultimately* backed by a class whose main purpose is to interact with the android operating system. As we’ll see later, Diane Hackborne and Chet Haase have both recently stated that `Activity`s are an example of such a class. Since `Fragment`s are very similar to `Activity`s, I consider an app where each screen is backed by a `Fragment` to also have an android-centric architecture, even if there’s only one `Activity` in the app.

MVP and VIPER and RIBLETS and…are a thing now in the Android community. However, these suggestions aren’t *necessarily* a full rejection of android-centric architecture. Although there may be `Presenter`s or `Interactors`s or whatever involved, these objects are often still built on top of `Activity`s and `Fragment`s; they could still get instantiated by and delegate to android-centric components, one for each screen the user sees.

An app that doesn’t follow android-centric architecture has one `Activity` and no `Fragment`s. Router and Controller type classes are POJOs.

### Why Android-Centric Architecture?

I suspect that a part of the reason why we buy into android-centric architecture is that Google hasn’t really been clear on what `Activity`s and `Fragment`s are for until relatively recently. On channels less official and visible than the Android docs, [Chet Haase](https://medium.com/google-developers/developing-for-android-vii-the-rules-framework-concerns-d0210e52eee3#.1o25pxfat) and [Diane Hackborne](https://plus.google.com/+DianneHackborn/posts/FXCCYxepsDU) have both suggested that `Activity`s aren’t really the kind of things with which you want to build your application.

Here’s Hackborne:

> …With its Java language APIs and fairly high-level concepts, it can look like a typical application framework that is there to say how applications should be doing their work. But for the most part, it is not.
> 
> It is probably better to call the core Android APIs a “system framework.” For the most part, the platform APIs we provide are there to define how an application interacts with the operating system; but for anything going on purely within the app, these APIs are often just not relevant.

and here’s Haase:

> Application components (activities, services, providers, receivers) are interfaces for your application to interact with the operating system; don’t take them as a recommendation of the facilities you should architect your entire application around.

Hackborne and Haase almost explicitly reject android-centric architecture. I say “almost”, as they both don’t seem to denounce the use of `Fragment`s as building blocks for our apps. However, there’s a tension between the idea `Activity`s are not suitable app components and that `Fragment`s are, and that tension is as strong as the the many similarities between the two components.

It might even be fair to say that Google has actually suggested an android-centric architecture through the previous [Google I/O app samples](https://github.com/google/iosched) and the android documentation. The “app components” section of the Android docs is a particularly good example of this. [The section introduction](https://developer.android.com/guide/components/index.html) tells the reader that they’ll learn “how you can build the components [including `Activity`s and `Fragment`s] that define the *building blocks* of your app.”

Over the past couple of years, many Android developers – myself included – are starting to realize that `Activity`s and `Fragment`s often are not helpful building blocks for their applications. Companies like [Square](https://medium.com/square-corner-blog/advocating-against-android-fragments-81fd0b462c97), [Lyft](https://eng.lyft.com/building-single-activity-apps-using-scoop-763d4271b41#.mshtjz99n), and [Uber](https://eng.uber.com/new-rider-app/) are moving away from android-centric architecture. Two common complaints stand out: as the app gets more complicated, the code is *difficult to understand* and *too rigid to handle their varying use-cases.*

### What does Testing have to do with this?

The connection between testability and understandable, flexible code is well expressed in this quotation from *Growing Object Oriented Software Guided by Tests*:

> for a class to be easy to unit-test, the class must…be loosely coupled and highly cohesive – in other words, well-designed.

Coupling and cohesion have direct bearing on how understandable and flexible your code is, so if this quote is right and if unit testing `Activity`s and `Fragment`s is difficult – and you likely know that even if you haven’t read [my](/post/why-we-should-stop-putting-logic-in-activities/) [posts](https://www.philosophicalhacker.com/2015/04/17/why-android-unit-testing-is-so-hard-pt-1/) suggesting as much – then writing unit tests would have shown us, before Google and painful experiences did, that `Activity`s and `Fragment`s aren’t the building blocks we want for constructing our applications.

### Next Time…

In the next post, I’ll try and fail to write an example test against an `Activity` and show exactly how the tight coupling and low cohesion of `Activity`s makes testing difficult. Next, I’ll test drive the same functionality, and we’ll end up with testable code. In the following post, I’ll show how the resulting code is loosely coupled and highly cohesive and talk about some of the benefits of these properties, including how they open up novel solutions to common problems on Android, like runtime permissions and intermittent connectivity.