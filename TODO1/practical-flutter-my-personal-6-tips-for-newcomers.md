> * 原文地址：[Practical Flutter: 6 Tips for Newcomers](https://hackernoon.com/practical-flutter-my-personal-6-tips-for-newcomers-dfbe44a29246)
> * 原文作者：[Nick Manning](https://hackernoon.com/@seenickcode?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/practical-flutter-my-personal-6-tips-for-newcomers.md](https://github.com/xitu/gold-miner/blob/master/TODO1/practical-flutter-my-personal-6-tips-for-newcomers.md)
> * 译者：
> * 校对者：

# Practical Flutter: 6 Tips for Newcomers

![](https://cdn-images-1.medium.com/max/800/1*49JRIXl5TjmS9GWjlyr7Sw.jpeg)

I've just submitted [Steady Calendar](https://www.steadycalendar.com), a minimalist habit tracker app, on the [Google Play Store](https://play.google.com/store/apps/details?id=com.manninglabs.steady), design by my wife [Irina](https://www.behance.net/irinamanning) and developed in short order by yours truly in the little free time I have being a new father. The app was a port from iOS to Flutter. After speaking about the experience ([slides](https://docs.google.com/presentation/d/1YQP7Qz1-4xRQWmOhwhswDTexmOl456RZPko45lhh-KU/edit#slide=id.gcb9a0b074_1_0)) at last week’s [Flutter Camp](https://flutter.camp), organized by @[flutterfyi](https://twitter.com/flutterfyi), I've decided to boil my talk down to something more meaty for everyone and make it a prelude to what an upcoming Flutter course, [Practical Flutter](https://mailchi.mp/5a27b9f78aee/practical-flutter), will be all about.

Well, after writing this app, with little free time yet without cutting really too many corners, I wasted a lot of time with distractions on what I thought I had to learn about Flutter, which in the end wasn't very useful and was sort of time lost.

So with that said, here’s some advice for newcomers to Flutter.

### 1. Keep it Simple When Getting Started with Widgets

Flutter heavily uses [Material Design](https://material.io/design/) widgets in examples and throughout most of its library. If you want to quickly get a UI together or have no time to write an app for Android and iOS, stick to Material Design.

Yet the problem with Material Design is it may alienate your iOS users unless customized properly. Google has been [recently making efforts](https://www.theverge.com/2018/5/10/17339230/google-material-design-theme-update-new-tools-matias-duarte) to make its library more flexible and show how adaptable it is, encouraging developers to break out of boring, repetitive UIs that all just look like Google Docs.

Flutter does offer “Cupertino” [iOS style widgets](https://flutter.io/widgets/cupertino/) yet this comes at the cost of needing to do some heavy code splitting, since these widgets require other [parent widgets](https://www.crossdart.info/p/flutter/0.0.32-dev/src/cupertino/scaffold.dart.html) to work properly. Plus, Google isn’t heavily focused on offering a full blown comprehensive set of iOS widgets, after speaking with one of it’s employees at a recent event.

In my next app, I will be customizing Material Design heavily to match design needs yet here are some of the widget you may want to learn for now to stay flexible and get the most out of your time:

*   [Scaffold](https://docs.flutter.io/flutter/material/Scaffold-class.html) and an AppBar (container for a screen and nav bar, respectively)
*   [Layouts](https://flutter.io/tutorials/layout/), with Column, Row
*   [Container](https://docs.flutter.io/flutter/widgets/Container-class.html) (ability to set ‘padding’, ‘decoration’, etc)
*   [Text](https://flutter.io/widgets/text/)
*   [AssetImage](https://flutter.io/assets-and-images/) ([NetworkImage](https://flutter.io/cookbook/images/network-image/) as a bonus)
*   RaisedButton (forgot icons for now)

### 2. Forget Learning Dart From Day One

Flutter uses [Dart](https://www.dartlang.org), a language that is very easy to pickup, even for folks new to software development. Yet getting an app running and rendering some simple UI does not at all require any Dart knowledge.

After you’re comfortable with learning the basics of layouts, getting some content on the screen, then take an entirely separate day to read up on Dart. After that, you’ll be ready to learn things like handling events (i.e. tapping a button) and maybe even fetching data from an API, depending on your experience level.

### 3. Stick to Stateless Widgets For Now

‘StatelessWidget’ is the default class any Widget will extend in Flutter. As the name implies they are for rendering widgets that will not need to hold any state.

In terms of it’s counterpart, ‘**Statefull**Widget’, Flutter’s documentation presents this by showing how to say, handle an event and change some information that’s on a screen. If you’re a newcomer to programming or even a junior developer, learning this in the beginning is by no means required. I say this because in the beginning of learning anything, motivation is the key to keep going and your primary focus should be getting comfortable with rendering a nice looking screen with some content.

### 4. Establish Some “Motivation Milestones”

Again, when learning anything, hitting some important milestones is key to staying motivated. Here are some of my recommended learning milestones:

*   Milestone One: Be able to develop a screen with a simple layout, text, a non-working button, and an image.
*   Milestone Two: Be able to run your app on your actual phone. This is very cool and really motivating.
*   Milestone Three: Learn how to hook up a button, change some state and render it on the screen by using a StatefulWidget.
*   Milestone Four: Take a few hours to read up on Dart (this step can even come before the previous milestone if you’d like).
*   Milestone Five: Be able to fetch some data from a public API ([examples](https://github.com/toddmotto/public-apis)) and render it on the screen. Understand how to work with JSON and deserializing it.
*   Milestone Six: Release an actual iOS and/or Android build to a friend. This will surprise you but I really believe in doing this early, unless you’re still evaluating to see if Flutter is right for you. Showing an app you wrote, even if it’s not at all useful, to friends and family and sending it out to a test user via iTunesConnect or the Google Play Store (easier) and doing this early on is the really an amazing way to stay motivated and confident that you can crank out an app to the public one day.

### 5. Learn How to Get Help

Get used to going to the [Flutter Google Group](https://groups.google.com/forum/#!forum/flutter-dev) if you can’t find an answer to a problem on Stack Overflow. I recommend the former over Stack Overflow when asking questions actually. You can read more advice [here](https://flutter.io/faq/#where-can-i-get-support).

Try to find a few mentors that can help you as well. You’ll find the Flutter community is wonderfully engaged and passionate.

### 6. Share Your Work

I’ve found that Twitter is a great way to share what you’ve done. Even if it’s something simple, simply posting a screenshot of your app and mentioning @[flutterio](http://twitter.com/flutterio) is really motivating.

### Final Thoughts on Learning

Overall, in terms of learning resources out there, there’s a lot available yet I’ve found that there isn’t enough real, end to end, battle tested tutorials on Flutter out there. Sure there’s your Google-produced YouTube videos and Udacity courses and these are great, yet a lot of the time they cover 1/5th of what you’ll need to learn to get a real app into the app store(s). I say this because after writing a port from iOS to Flutter for a simple app I wrote, Steady Calendar, recently, I found that things like working with JSON, APIs, manging multiple build environments, localization, caching, code organization, state management, tweaking Material Design for really custom UIs, etc took some digging.

So with that, **I plan to release a beta Flutter course** which will take my experiences learning Flutter and boil it down to practical, more “end to end” type tutorials which will focus on Flutter and all the other know-how it may take to write a real app.

If you’d like to sign up to get notified when I release the first lesson in July ’18, sign up here: [Practical Flutter](https://mailchi.mp/5a27b9f78aee/practical-flutter).

Happy Fluttering.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
