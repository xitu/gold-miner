> * 原文地址：[An iOS Dev’s Experience with React Native](https://blog.madebywindmill.com/an-ios-devs-experience-with-react-native-559275b5a4e8#.qvkcgzpaa)
> * 原文作者：[John Scalo](https://blog.madebywindmill.com/@scalo?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：
> * 校对者：

# An iOS Dev’s Experience with React Native #

If you’re a developer in the iOS space you’ve probably heard of React Native. The promise is simple and compelling: write once, ship twice. iOS and Android all in one shot. I’m a long-time iOS (and an even loooonger time macOS) developer so thought I’d share my experiences with this magical technology.

Last year we were talking with a potential client. They wanted their iOS app out ASAP and so came to us, but midway through discussions they discovered this thing called React Native and, because they already had a web developer on staff that was handy with Javascript, figured it would be much faster for them to go that route. We parted ways but it also left me wondering if RN was something we should add to our toolbox.

A few weeks later an old friend of mine approached me with a proposition to create an app that would serve as a supplemental reference source to support a book that he’d already published. Since I was working for barter, I saw the opportunity to stretch out a little bit and figured this would be a great time to test the waters with React Native. Most of his audience are probably on Android so write once/ship twice seemed like a slam dunk.

I won’t take you through every trial and tribulation but let’s just say that this app, as simple as it may be, ain’t gonna ship using RN. Here’s why.

First, I must say there’s a lot to like about React Native even beyond its magical write once/ship twice promise.

- React.js, which RN derives from, is an elegant way to describe and update a UI. The basic idea is that a component renders its UI from top to bottom using a set of properties that are passed to it. Thanks to React’s virtual DOM, the UI updates instantly when a property changes, making model/view synchronization seamless and automatic. I found myself wishing that iOS’s UIKit had been designed this way.
- It’s awesome that I can update my JSX code and have the app update in the simulator without recompiling or re-running.
- There’s a thriving RN community offering hundreds of prefabbed components for you to drop into your app. (Actually, while most would consider this a “pro”, I kind of hate this “script kiddie” approach to programming. Building an app out of pieces that you mostly didn’t write and don’t understand can lead to maintenance quagmires down the road.)
- One of my concerns about RN was performance, but in my experience it wasn’t an issue. Scrolling is smooth, animation is snappy, etc. After all, for the most part an RN app will be using platform-native UI controls and the RN engineers have done a good job optimizing for them.

So what’s not to like? To be fair, I’m not who React Native was designed for. I know my way around Javascript but I’m by no means an expert, and I *am* a Swift/Objective-C expert. I quickly came to realize that if I were to finish the app using RN, it would take me a solid 10–20x longer than it would have taken me in Swift. Sure, the Android version would still need to get written but given my learning curve with RN I’d probably be better off just learning Java.

Even beyond that, I believe there are some serious issues with taking the RN approach.

### Fragile Dependency Chain ###

React Native is not a one-stop solution. In fact I made a rough dependency graph of some of the necessary components:

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*781lZgF4IFAvLrnFRHcvaQ.png">

The React Native Dependency Chain

Perhaps if you’re coming from the world of web development this is normal but for me, it’s not. In my world we have Xcode and everything needed to create Swift/Obj-C/iOS/Mac/Apple TV/etc/etc apps is packaged *inside *and managed by Xcode. The dependency chain is probably just as long as the above (if not longer), *but it’s all guaranteed to be in sync and compatible.*

Now I’m sure that most of the components in the RN dependency chain get along with one another just great. But I ran into 4 or 5 hitches that required a few hours of StackOverflow surfing to resolve. The more important issue in my mind is what happens going forward. For example, upgrading Nuclide (an IDE add-on for RN) might require a new version of Atom. And what if another tool on my system requires a newer version of `winston`, but then it turns out *that* version isn’t compatible with RN? You get the picture.

### Broken Promises ###

It turns out the promise of write once, ship twice is only partially true*. I ran into cases where I was forced to “branch” my RN app based on whether I was targeting iOS or Android. Take for example a tab bar. As ubiquitous as tab bars are you’d think that RN would include it as a first-class citizen, but not really. RN includes the `TabBarIOS` component for iOS but for some reason there isn’t an equivalent for Android. Instead there are dozens of GitHub solutions and tutorials to show you how to make them from scratch. For a nav bar, there’s `NavigatorIOS` for iOS but `Navigator` for Android, and they work very differently. The fact that these core navigation constructs deviate between the two platforms can necessitate a multitude of different files and components for each platform. I began to feel that despite the magical promise, I was still writing two different apps, albeit in the same language.

* And to be fair, this “promise” is inferred, not stated, at least not by the good people at Facebook/RN. Their stated mission is: “Learn once, write anywhere.”

### Surprising Technical Limitations ###

The project I was working on was essentially a hierarchically organized reference guide. The book author and I came up with a sensible layout for the categories and articles that worked with the UI paradigm we designed. Given our strategy, we could link or navigate to any of a couple hundred detail pages using content that’s included statically in the app. I coded this up but strangely my `require()` calls kept failing. After some research I learned that with RN, *you can’t read files from arbitrary paths*. Apparently all the paths used in your RN app are collected at compile time and any not known to the compiler simply can’t be read. So you can do `require(‘../file1.json’)` but not `require(‘../file’ + ‘1’ + ‘.json’)`. This surprising limitation rendered our architecture unworkable.

### Impostor UI ###

Chances are that your finished RN app is going to feel like a not-quite-native iOS app and a not-quite-native Android app. Some people will have a bigger problem with this than others and most users of the general population won’t notice. But you do risk losing platform specific niceties that users *will *notice, like not being able to swipe right from the left edge to navigate back (which you only get in RN if you write all your navigation code twice using `NavigatorIOS`).


In a nutshell, iOS developers probably shouldn’t be looking at React Native as a solution to shipping on two platforms. Writing an iOS app natively will take *much* less time and most likely have a better UX. The same is true for the Android app, so all in all I think everyone is better served going platform-native.

When is RN the right approach? If you’re an expert Javascript programmer or have one on staff, and *don’t* have an iOS or Android dev at your disposal, then the economics *might* work out in your favor. Then again, remember the client that wanted their app on both platforms PDQ? They *did* have a Javascript developer on staff and the v1.0 version of their app just hit the App Store, 8 months after contacting us.


*Shameless plug time! If you’re looking to have an iOS app developed,* [*get in touch*](http://www.madebywindmill.com) *! We have some availability coming up.*
