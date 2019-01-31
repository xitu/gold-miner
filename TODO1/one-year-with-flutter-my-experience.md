> * 原文地址：[One Year with Flutter: My Experience](https://hackernoon.com/one-year-with-flutter-my-experience-5bfe64acc96f)
> * 原文作者：[Nick Manning](https://hackernoon.com/@seenickcode)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/one-year-with-flutter-my-experience.md](https://github.com/xitu/gold-miner/blob/master/TODO1/one-year-with-flutter-my-experience.md)
> * 译者：
> * 校对者：

# One Year with Flutter: My Experience

![](https://cdn-images-1.medium.com/max/800/1*pO38uoqgEOZiQuzq6lDrvQ.jpeg)

It’s been an amazing year for Flutter.

Roughly around this time last year, I wrote “[Why Flutter Will Take Off in 2018](https://codeburst.io/why-flutter-will-take-off-in-2018-bbd75f8741b0)”. While in beta for pretty much the entire 2018 and now at version 1.0, the Flutter community and product have grown tremendously, with Flutter now being [in the top 20](https://twitter.com/timsneath/status/1079436636344049664) repos on Github. Reflecting back on this article, it’s time for me to give an update on my experience with **Flutter one year out**, with all the **pros and cons** I’ve found along the way.

_How_ did I exactly did I “work with Flutter” in the past year? I’ve:

*   Re-written an [iOS app](https://steadycalendar.com) I’ve had in the App Store into Flutter.
*   Developed a free [crash course](https://fluttercrashcourse.com) on Flutter, recording over 5 hours of instructional video content.
*   A number of smaller, not yet published apps with Flutter.

So before I list out my thoughts, note that my background, in terms of purely mobile dev, is mainly coming from the **iOS world**. Also, last year I’ve done a solid amount of **React Native** sprinkled in for my day job. I’m _not_ going to compare Flutter to these technologies but it’s worth nothing that does shape my impressions of Flutter based on what else is out for mobile devs.

So **here’s what I’ve learned** by using Flutter for a year now:

#### 1. Dart is simple to learn and a joy to use.

Compared to [TypeScript](https://www.typescriptlang.org/) or [Flow](https://flow.org/), all of which I’ve used extensively this past year doing React Native development, Dart was far easier to learn and had a much simpler syntax. I was able to move fast because I had a proper compiler that had clear, well defined error messages, with far less unexpected hidden runtime errors. If enough people ask for my experiences on this I can write up a more detailed comparison with examples. All I have to say is, when writing even medium sized applications, developers should cherish strongly typed languages because it pays off big time when it comes to moving fast and writing reliable code.

#### 2. I still have to “roll my own” at times.

Another common case when it comes to a new technology is needing to “roll your own” library in order to integrate with a 3rd party service. For example, to get analytics into my app using Mixpanel (since they have a generous free tier option and very simple, clear cut UI), I had to roll my own library, [pure_mixpanel](https://pub.dartlang.org/packages/pure_mixpanel). It wasn’t a big deal though and actually it was a lot of fun.

I’ve personally had a lot of success with [scoped_model](https://pub.dartlang.org/packages/scoped_model), since it nicely abstracts away needing to use streams and works a lot like React’s new [Context API](https://reactjs.org/docs/context.html). You can cleanly still separate your business logic and rendering logic nicely and it’s really easy to learn.

#### 3. Architecture and state management patterns will still need time to mature.

First off, Flutter is a new technology, so it’s still hard getting enough opinions on battle tested, trusted architecture patterns and state management tools. Some people follow the “[BLoC](https://www.youtube.com/watch?v=fahC3ky_zW0)” (or “business logic component”) pattern. The jury’s still out on this one for me since I think it’s a bit unnecessarily complex. There’s also [RxDart](https://github.com/ReactiveX/rxdart) and [Redux for Flutter](https://pub.dartlang.org/packages/flutter_redux), both of which I haven’t used either yet, as they seemed overly complex as well. On the other hand, folks coming from the Android or React world seem to have a lot of success with them since it’s what they may be used to.

I think this whole ecosystem will naturally mature in 2019 as more and more people are writing more and more complex Flutter apps.

#### 4. Hot reload is still a big deal for me.

There’s not much to say about this, except this feature of Flutter alone is important enough to warrant its own section of this article. It’s fast and even more importantly, _reliable_. I can’t say the same thing about other technologies I’ve used when it comes to hot reloading features (told myself I wouldn’t be negative about other technologies).

#### 5. Cross platform design is hard.

Material Design is wonderful, allowing folks to get up and running fast. It’s also a no-brainer for certain types of web-applications as well as Android apps. But presenting it to iOS users, unless it’s a Google app or something very simple, isn’t a good idea. iOS users are used to their own CocoaTouch style UX.

What I’ve been seeing more and more when writing for two platforms using one codebase, some kind of bespoke, custom design is used, pulling in design common design elements (such as say, a tab bar). Although Flutter does offer plenty of iOS style widgets, to keep code maintenance at a minimum, most people will just customize Flutter’s Material Design library, which is incredibly easy to do.

I’ll be writing another article on just this topic but my recommendation is to stick to Material Design and in some areas, try to make it not so “Android-like” for all those iOS users out there. One example being forms. Style form fields using Material Design in a way that looks familiar enough to both types of users.

#### 6. Implementing complex layout in Flutter is easy.

I’m used to implementing layout using libraries like React, CSS Grid, Flexbox, etc. Flutter’s approach to layout takes a lot of cues from these tools for good reason. If you’re already familiar with these more web-based layout concepts, learning layout in Flutter will be easy. Even if you’re not, it’s still easy. I have a [video on this](https://fluttercrashcourse.com/lessons/container-layout-column-row) if you want to get a feel for it.

Also, UI logic in Dart and Flutter is excellent from a code readability standpoint. Overall, I prefer implementing layout personally much more to something like JSX. It reminds me of how simple layout logic is in Swift and iOS, if you’re programmatically implementing layout.

#### 7. More focus on end to end app examples are still needed.

While there’s a _ton_ of solid documentation, tutorials, communities and overall help out there on working with Flutter, I think there’s too much of a focus on widgets alone. That makes a lot of sense since Flutter is so new. But eventually, more and more people are going beyond just implementing pure-UI and animation and will start writing more full blown apps and more end to end tutorials should be featured on Flutter’s website in my opinion. Actually, this is the main reason why I started my course website.

I’ve learned Writing Flutter apps go way beyond just widgets. There are a lot of more advanced Dart features I’ve found very helpful that you have to dig for. There’s architecture patterns that I’ve mentioned that you have kind to dig for. Lastly, integrating with web services and other Dart best practices still need more documentation and tutorials.

#### 8. GraphQL or gRPC, I’ll pick one for my next project.

I’m always pushing for less boilerplate code. While there are [some tools](https://flutter.io/docs/development/data-and-backend/json) that help me solve this problem that work well for simple projects, I think for my next project I’ll use [GraphQL](https://pub.dartlang.org/packages/graphql_flutter) or [gRPC](https://grpc.io/). I think the investment in either is worth it. As for gRPC, I wouldn’t recommend it for smaller projects, but for medium to larger ones, once you use it it’s hard to go back. gRPC has worked really well for another project using Swift and I’ve had it running in production for some years now.

#### 9. Submitting apps for both platforms was easy

It does take some investment to get used to the tools and steps required to submit apps for each platform, specifically the Google Play Store and iTunes Connect, but it’s very much easy. I’d say submitting apps for iOS though is definitely more of a learning curve.

#### 10. Flutter has way too many widgets.

For all the widgets I thought I had to learn to get going with Flutter, I ended up using probably 20% of them. For example, the [Center](https://docs.flutter.io/flutter/widgets/Center-class.html) widget. Why have a widget alone _just_ for centering something? Although it makes it easy for newcomers to get started, its widgets like these that produce far too much nested Dart code when it comes time to implement more complex layouts. Instead, I fall back on the basic [Container](https://docs.flutter.io/flutter/widgets/Container-class.html) layout options I’m just going to use anyway because they are very flexible.

My recommendation is to focus on simple, basic widgets and only learn more when it’s really needed.

#### 11. I’m passing on Firebase (except for Push Notifications)

Firebase seems like a great product. It reminds me of [Parse](https://parseplatform.org/) from back in the day. It especially seems like a good choice in order to get going for simple projects or to later hand over a project to a client where they don’t have enough specialized developers to manage a custom backend.

The reality is is that most folks already have an existing backend or the tech team has chosen to write their own backend. This especially goes for larger companies or even just startups.

For indie devs or “mom and pop” shops, what happens to your monthly Firebase bill if you get a surge in traffic? That was really the main reason why I avoided Firebase, because in case I did have that “dream problem” of going viral, how would I pay for it if Firebase is charging me based on usage?

Note that I write backend systems for a living, so I’m biased. If you’re a junior dev, want to hand over a simple backend to a client or you simply don’t write backend APIs, I would still take a strong look at Firebase.

#### 12. Flutter’s documentation is getting better and better

Widgets and class documentation now have more and more examples ([example](https://docs.flutter.io/flutter/widgets/Container-class.html)). This is a big win over other libraries that lack proper examples even, let alone well-written documentation.

Beyond documentation, I’ve found that for most of this past year, there have been plenty of passionate, knowledgeable folks out there on Stack Overflow to get me the support I needed.

#### 13. I got spoiled by iOS development and same goes for Flutter.

I’ve been an iOS engineer for a number of years so I’ve been a bit spoiled by the iOS developer experience. Not only documentation and support but the overall quality of the iOS ecosystem, from libraries to Xcode to how the CocoaTouch SDK is organized.

Flutter matches this experience I think. It’s refreshingly simple too, taking the simplicity of certain React Native components as well, such as ListView (man, have you used UITableViewController on iOS? Yuck) So overall, learning and using Flutter has been super smooth, with mature tooling to go with it. It’s really refreshing to not need the complexity of something like Xcode any longer.

####  14. I can never go back to “single platform” mobile dev.

A video game developer would probably never consider writing one code base for only a single platform. Now, “non-video game” developers can do the same with the emergence of React Native and Flutter.

For example, in my free time, I’m part of (literally) a “mom and pop” shop, building apps with my wife who’s a UX designer. With our user base more than doubling converting our iOS app into Flutter, now that it’s published on two platforms, I can’t go back to writing for a single platform now.

### Final Thoughts

One year out, as I start my next Flutter app (will be posting some videos on how I develop it soon!), I’m _still_ really really happy that I invested all this time into learning Flutter. I can’t go back now. It makes sense for businesses as a now viable option for a technology for writing for multiple platforms and it’s a joy to use as a developer. If you combine this fact with the potential for “Flutter for the Web” technologies like [Hummingbird](https://medium.com/flutter-io/hummingbird-building-flutter-for-the-web-e687c2a023a8) as well as Google’s long term investment in Flutter for the new [Fuschia operating system](https://en.wikipedia.org/wiki/Google_Fuchsia), these facts alone show that Google is very much invested in this technology.

Feel free to reach out to me on [Twitter](https://twitter.com/seenickcode) with your thoughts. I also have a free Flutter course at my site [fluttercrashcourse.com](https://fluttercrashcourse.com) if you’re interested!

Happy coding in 2019!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
