> * 原文地址：[What It Was Like to Write a Full Blown Flutter App](https://hackernoon.com/what-it-was-like-to-write-a-full-blown-flutter-app-330d8202825b)
> * 原文作者：[Nick Manning](https://hackernoon.com/@seenickcode?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/what-it-was-like-to-write-a-full-blown-flutter-app.md](https://github.com/xitu/gold-miner/blob/master/TODO1/what-it-was-like-to-write-a-full-blown-flutter-app.md)
> * 译者：
> * 校对者：

# What It Was Like to Write a Full Blown Flutter App

![](https://cdn-images-1.medium.com/max/800/1*SZK7j8dPQuaecmaeJoWxwA.jpeg)

**UPDATE**: I’ll be releasing a new Flutter course called Practical Flutter. If you want to get notified when it launches in late July ’18, [click here](https://mailchi.mp/5a27b9f78aee/practical-flutter). 🚀

This morning I ate TWO breakfasts. I needed all “blog-writing brainpower” I could muster. There’s a lot to cover since [my last post](https://codeburst.io/why-flutter-will-take-off-in-2018-bbd75f8741b0) so here we go.

I’m super excited because I can now officially resume writing blog posts about Flutter because I’m nearly ready to release my first full blown Flutter app to the iOS and Android store — one or two more weeks to go! I refused to get distracted in the past few months and since I was writing this app in my free time.

**I haven’t been this excited about a technology since Ruby on Rails or Go.** After dedicating years to learning iOS app dev in-depth, it killed me that I was alienating so many Android friends out there. Also, learning other cross platform frameworks at the time was super unattractive to me because of what was available.

Even two years ago, going to for example, meetups showing off apps written with other cross platform mobile frameworks, I felt like they were either too hacky, unstable, had a poor developer experience, was hard to use, was overly complex or wouldn’t be around in other year or two to even use.

So I just finished my first Flutter app and I feel I can safely invest much more of my time long term to the framework. Writing a Flutter app has been a litmus test and Flutter passed the test. It’s amazing to now be able to competently write apps for iOS and Android. I also love writing and scaling backends and [my wife Irina](https://www.behance.net/irinamanning) is a UX so it’s a powerful combination.

**This is going to be long blog post because there is a lot to cover:**

1.  **My Experience Porting an iOS app to Flutter**
2.  **Thoughts on Flutter Thus Far**
3.  **Recommendations to the Google team**

I decided to get my thoughts out quickly so I can get back to work on writing tutorials (and more apps!).

### 1. Porting an iOS App to Flutter

Since my last [post about Flutter](https://codeburst.io/why-flutter-will-take-off-in-2018-bbd75f8741b0) months ago, I felt that the logical next step was to really really get in depth with Flutter. I’m huge fan of tutorials with battle tested, end to end examples (think Digital Ocean or even Auth0 tutorials). End to end, detailed, high quality examples are what made me get hooked on new technologies in the past because I was able to really see near-production ready code and feel secure that I was implementing things the right way. So I wanted to do the same writing Flutter tutorials.

So with those goals, I decided that the perfect app to cut my teeth on was to simply re-write an existing iOS app that I already had in the App Store. Steady Calendar ([homepage](https://www.steadycalendar.com), [Product Hunt](https://www.producthunt.com/posts/steady-calendar)), is a habit tracker that [my wife Irina](https://www.behance.net/irinamanning) and I designed and developed while we were living Berlin a few years ago. Since then, it has been a product that made us hooked on how satisfying it was to design, implement and release a product that helps others improve their lives by adopting healthy habits.

I basically took a month or two, part time, to port this iOS app to Flutter so I’d be able to write awesome Flutter tutorials — no pressure!

What’s cool is now I can cover the following in future tutorials because I’ve implemented them in the app:

*   A “pre-login” intro teaser.
*   Facebook / email sign up and login .
*   A grid view showing a calendar, where users can tap to highlight the day they’ve completed a goal.
*   Cross-platform forms, where neither iOS nor Android users are alienated.
*   Redux-style state management using [Scoped Model](https://pub.dartlang.org/packages/scoped_model)
*   Custom UIs with Stacks, Positioned elements, images and buttons.
*   List views.
*   Simple, multi-language internationalized UIs.
*   Navigation bars that are cross-platform, again, not alientating iOS nor Android users.
*   Globally styling widgets.
*   Integration testing.
*   Submitting the app to the Apple App Store.
*   Submitting the app to the Google Play Store.

### 2. Thoughts on Flutter Thus Far

Although I’ve been writing backends and webapps for more than 17 years now, 4 of those years were heavily involved with iOS development and as of the past year at work I’ve needed to ramp up with React Native heavily (throw in a few React projects last year too).

**So here’s what stood out when learning Flutter:**

1.  **The developer experience**, support and community spirit is amazing. Everything from Stack Overflow, Google Groups to blog posts are high quality naturally because of the enthusiasm for Flutter. Google Engineers go out of their way to stay heavily involved in answering question on Google Groups and this makes for a great community. They’re super polite and professional when working with engineers from all backgrounds, something that’s hard to say for a lot of other companies out there. There’s also a lively community where members are super active and provide really thoughtful answers. Documentation is fantastic. The libraries are very stable and with Flutter being based on Dart, a language that’s been around for years, learning is very easy as it is more established and battle tested. All around, great developer experience.
2.  As expected, there there is less **availability of third party libraries written in Dart**. Yet these are not deal breakers, at least in my experience. **95% of the features I’ve needed to use were there and available**, just one exception was say, some third party integration with a popular analytics tool but nothing that a simple HTTP wrapper could take care of.
3.  **Material Design widgets**, something that the Flutter framework is heavily comprised of, is great for cranking out simple apps yet for professional, cross-platform apps, it will alienate iOS users. I cannot present Material Design widgets to my iOS users because it would make my app look alien to them. Flutter does indeed provide its own set of iOS widgets, but these still have a way to go in terms of comprehensiveness. Luckily, with the Steady app I wrote, most of the UI was already custom. But for things like forms, that was more of a challenge. So at the end of the day, the documentation, examples and overallFlutter SDK is heavily oriented around Material Design which is great but there needs to be more of a balance for folks like me.
4.  **Developing custom UIs in Flutter was a breeze**. I have high standards too after being spoiled by leaning CocoaTouch / iOS back in the day. After diving through lots of Flutter code and judging by the experience of writing customer UIs, the **Google team really has their act together**. Sure, there are some widgets I really think are super overkill and can make the learning curve a bit more convoluted (i.e. the Center widget), but it’s not a huge deal. After writing a real app one quickly starts to see a pattern of what the most critical widgets they’d probably be using on a regular basis (and hey, I’ll be covering that in my future tutorials).
5.  As an iOS user, taking a few months to write my original iOS app Steady Calendar, **I’ll never forget the sheer excitement of running it for the first time on a physical Android device**. I guess it’s just because I always was super turned off by other cross platform mobile frameworks. If you take months of your spare time, lots of hard work developing something and realize you can run it on two major platforms, you will get hooked. This is probably not very insightful feedback for most people but I needed to share it anyway!
6.  **Writing cross platform apps will throw more design challenges your way** but this hasn’t really anything to do with Flutter itself but more to do with getting into development for multiple platforms. When you plan out a Flutter app, make sure you have a good designer and a nice custom UI mocked up or be ready to write your Flutter app so that your code conditionally uses either Material Design or Cupertino widgets. In the former case though, this is less of a Flutter issue and more of a challenge writing cross platform apps, you need to make sure the UI is designed to be good looking for Android users and iOS users based on the conventions they are each used to.
7.  **Dart is a pure pleasure to learn and use**. I love the stability and reliability I get vs using something like TypeScript or Flow. To put this into context, I have a bit of a React background and have been learning React Native heavily for my day job (heavily) for the past few months. I’ve also worked a lot with Objective-C and then Swift for years. Dart is a breath of fresh air because **it doesn’t try to be overly complex and has a solid core library and packages**. Honestly, I think even high school freshmen can use Dart for basic programming. I just can’t believe how many I hear complaining they’d have to learn a new language, which for Dart would take between one or two hours or a day max.
8.  **Flutter rocks.** It’s not perfect by any means, but in my own opinion, the learning curve, ease of use, tools available make it by far a nicer experience than other mobile frameworks I’ve used in the past.

### What Google Should Do

1.  Google team members and friends should to **continue to provide thoughtful, friendly and responsive support** in its Google Groups. This is a big plus and is what makes the framework standout in terms of approachability and support. The team supporting and cultivating the community are **really likable guys and have a good, positive attitude and that’s huge.**
2.  Get a poll from community members to see which Widgets may simply not be useful. **For the not so useful Widgets, just remove them from documentation tutorials** or deprecate them altogether. For example, the ‘Center’ widget is nice for a Hello, World container but I never understood it. Why can’t ‘Container’, something that’s way more prevalent have a property to do the same thing? This is a super trivial example but I think that’s part of the reason why Go was so successful, because it’s core library was simple and lean (and stayed lean).
3.  **Devote more focus on iOS users.** Material Design is great to get going quickly or if you’re only building something for Android users. I’d never use Material Design in an iOS app. With that said, I’ve found Flutter to be a nicer, less complex developer experience than learning Swift and all the one million library features one has to know to write iOS apps nowdays. I think a lot of iOS users would love to learn Flutter if Flutter had just even a bit more iOS style widgets.
4.  **More tutorials** on building realistic features and screens. I’d love to see more tutorials like this one: [https://flutter.io/get-started/codelab/](https://flutter.io/get-started/codelab/) but also “end to end” ones, where an example of integration with a backend is shown.
5.  **Theming apps** should be **less focused on Material Design**. Again, I don’t want to use the ‘MaterialApp’ widget if I’m writing an iOS app. Theming seems tightly coupled to this and it should be more generic.
6.  **Less prevalence of Firebase in the documentation** or pushing it so often. I realize Firebase really useful to get going fast and it helps bolster the approachability for new developers, but a significant amount of folks out there already have a backend ready or would not ever consider using Firebase. So I think more emphasis on how to work with simple web services and JSON would help. I had to read a lot of third party tutorials on this because I felt the documentation wasn’t realistic enough. I can elaborate when I write a future blog post about this.

So far, I’m super happy with Flutter overall.

Next, I’m going to consider re-writing another iOS I have in the app store, [www.brewswap.co](http://www.brewswap.co) that’s more complex (Tinder-style photo swiping, real time chat, etc).

So far, those are the main takeaways I can think of for now. Like any framework, there are a lot of quirks and learning curve issues but really overall, **Flutter is something I feel like I can really invest in and most importantly, really enjoy using**.

Stay tuned for some initial Flutter tutorials and I hope I was able to give some insight for anyone considering making the investment in Flutter — I’d say, go for it!

For anyone with questions on insight, etc, it’s better to just [**ping me on Twitter**](https://twitter.com/seenickcode) **@seenickcode.**

**UPDATE**: [Sign up](https://mailchi.mp/5a27b9f78aee/practical-flutter) and get notified about my upcoming Flutter course, Practical Flutter. 🚀

Happy Fluttering.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
