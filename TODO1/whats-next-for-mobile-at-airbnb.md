> * 原文地址：[What’s Next for Mobile at Airbnb:: Bringing the best back to native](https://medium.com/airbnb-engineering/whats-next-for-mobile-at-airbnb-5e71618576ab)
> * 原文作者：[]()
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/whats-next-for-mobile-at-airbnb.md](https://github.com/xitu/gold-miner/blob/master/TODO1/whats-next-for-mobile-at-airbnb.md)
> * 译者：
> * 校对者：

# What’s Next for Mobile at Airbnb

## Bringing the best back to native

![](https://cdn-images-1.medium.com/max/2000/1*_N3sz8fhNFU5tB5YTVfGHg.jpeg)

_This is the fifth in a_ [_series of blog posts_](https://medium.com/airbnb-engineering/react-native-at-airbnb-f95aa460be1c) _in which we outline our experience with React Native and what is next for mobile at Airbnb._

### Exciting Times Ahead

Even while experimenting with React Native, we continued to accelerate our efforts on native as well. Today, we have a number of exciting projects in production or in the pipeline. Some of these projects were inspired by the best parts and learnings from our experience with React Native.

#### Server-Driven Rendering

Even though we’re not using React Native, we still see the value in writing product code once. We still heavily rely on our universal design language system ([DLS](https://airbnb.design/building-a-visual-language/)) and many screens look nearly identical on Android and iOS.

Several teams have experimented with and started to unify around powerful server-driven rendering frameworks. With these frameworks, the server sends data to the device describing the components to render, the screen configuration, and the actions that can occur. Each mobile platform then interprets this data and renders native screens or even entire flows using DLS components.

Server-driven rendering at scale comes with its own set of challenges. Here is a handful we’re solving:

*   Safely updating our component definitions while maintaining backward compatibility.
*   Sharing type definitions for our components across platforms.
*   Responding to events at runtime like button taps or user input.
*   Transitioning between multiple JSON-driven screens while preserving internal state.
*   Rendering entirely custom components that don’t have existing implementations at build-time. We’re experimenting with the [Lona](https://github.com/airbnb/Lona/) format for this.

Server-driven rendering frameworks have already provided huge value by allowing us to experiment with and update functionality instantly over-the-air.

#### Epoxy Components

In 2016, we open sourced [Epoxy](https://github.com/airbnb/epoxy) for Android. Epoxy is a framework that enables easy heterogeneous RecyclerViews, UICollectionViews, and UITableViews. Today, most new screens use Epoxy. Doing so allows us to break up each screen into isolated components and achieve lazy-rendering. Today, we have Epoxy on Android and iOS.

This is what it looks like on iOS:

![](https://i.embed.ly/1/display/resize?url=https%3A%2F%2Favatars1.githubusercontent.com%2Fu%2F1307745%3Fs%3D400%26v%3D4&key=a19fcc184b9711e1b4764040d3dc5c07&width=40)

On Android, we have leveraged the ability to write [DSLs in Kotlin](https://kotlinlang.org/docs/reference/type-safe-builders.html) to make implementing components easy to write and type-safe:

![](https://i.embed.ly/1/display/resize?url=https%3A%2F%2Favatars1.githubusercontent.com%2Fu%2F1307745%3Fs%3D400%26v%3D4&key=a19fcc184b9711e1b4764040d3dc5c07&width=40)

#### Epoxy Diffing

In React, you return a list of components from [render](https://reactjs.org/tutorial/tutorial.html#what-is-react). The key to React’s performance is that those components are just a data model representation of the actual views/HTML you want to render. The component tree is then diffed and only the changes are dispatched. We built a similar concept for Epoxy. In Epoxy, you declare the models for your entire screen in [buildModels](https://reactjs.org/tutorial/tutorial.html#what-is-react). That, paired with the elegant Kotlin DSL makes it conceptually very similar to React and looks like this:

![](https://i.embed.ly/1/display/resize?url=https%3A%2F%2Favatars1.githubusercontent.com%2Fu%2F1307745%3Fs%3D400%26v%3D4&key=a19fcc184b9711e1b4764040d3dc5c07&width=40)

Any time your data changes, you call requestModelBuild() and it will re-render your screen with the optimal RecyclerView calls dispatched.

On iOS, it would look like this:

![](https://i.embed.ly/1/display/resize?url=https%3A%2F%2Favatars1.githubusercontent.com%2Fu%2F1307745%3Fs%3D400%26v%3D4&key=a19fcc184b9711e1b4764040d3dc5c07&width=40)

#### A New Android Product Framework (MvRx)

One of the most exciting recent developments is a new Framework we’re developing that we internally call MvRx. MvRx combines the best of Epoxy, [Jetpack](https://developer.android.com/jetpack/), [RxJava](https://github.com/ReactiveX/RxJava), and Kotlin with many principles from React to make building new screens easier and more seamless than ever before. It is an opinionated yet flexible framework that was developed by taking common development patterns that we observed as well as the best parts of React. It is also thread-safe and nearly everything runs off of the main thread which makes scrolling and animations feel fluid and smooth.

So far, it has worked on a variety of screens and nearly eliminated the need to deal with lifecycles. We are currently trialing it across a range of Android products and are planning on open sourcing it if it continues to be successful. This is the complete code required to create a functional screen that makes a network request:

![](https://i.embed.ly/1/display/resize?url=https%3A%2F%2Favatars1.githubusercontent.com%2Fu%2F1307745%3Fs%3D400%26v%3D4&key=a19fcc184b9711e1b4764040d3dc5c07&width=40)

MvRx has simple constructs for handling Fragment args, savedInstanceState persistence across process restarts, TTI tracking, and a number of other features.

We’re also working on a similar framework for iOS that is in early testing.

Expect to hear more about this soon but we’re excited about the progress we’ve made so far.

#### Iteration Speed

One thing that was immediately obvious when switching from React Native back to native was the iteration speed. Going from a world where you can reliably test your changes in a second or two to one where may have to wait up to 15 minutes was unacceptable. Luckily, we were able to provide some much-needed relief there as well.

We built infrastructure on Android and iOS to enable you to compile only part of the app that includes a launcher and can depend on specific feature modules.

On Android, this uses [gradle product flavors](https://developer.android.com/studio/build/build-variants#product-flavors). Our gradle modules look like this:

![](https://cdn-images-1.medium.com/freeze/max/60/1*KVrbsdwESyfbtKFeh2acXg.png?q=20)

![](https://cdn-images-1.medium.com/max/1600/1*KVrbsdwESyfbtKFeh2acXg.png)

This new level of indirection enables engineers to build and develop on a thin slice of the app. That paired with [IntelliJ module unloading](https://blog.jetbrains.com/idea/2017/06/intellij-idea-2017-2-eap-introduces-unloaded-modules/) dramatically improves build and IDE performance on a MacBook Pro.

We have built scripts to create a new testing flavor and in the span of just a few months, we have already created over 20. Development builds that use these new flavors are 2.5x faster on average and the percentage of builds that take longer than five minutes is down 15x.

For reference, [this is the gradle snippet](https://gist.github.com/gpeal/d68e4fc1357ef9d126f25afd9ab4eee2) used to dynamically generate product flavors that have a root dependency module.

Similarly, on iOS, our modules look like this:

![](https://cdn-images-1.medium.com/freeze/max/60/1*AVB7em_JCmj-JmjTCkLdQw.png?q=20)

![](https://cdn-images-1.medium.com/max/1600/1*AVB7em_JCmj-JmjTCkLdQw.png)

The same system results in builds that are 3–8x faster

### Conclusion

It is exciting to be at a company that isn’t afraid to try new technologies yet strives to maintain an incredibly high bar for quality, speed, and developer experience. At the end of the day, React Native was an essential tool in shipping features and giving us new ways of thinking about mobile development. If this sounds like a journey you would like to be a part of, [let us know](https://www.airbnb.com/careers/departments/engineering)!

* * *

This is part five in a series of blog posts highlighting our experiences with React Native and what’s next for mobile at Airbnb.

*   [Part 1: React Native at Airbnb](https://medium.com/airbnb-engineering/react-native-at-airbnb-f95aa460be1c)
*   [Part 2: The Technology](https://medium.com/airbnb-engineering/react-native-at-airbnb-the-technology-dafd0b43838)
*   [Part 3: Building a Cross-Platform Mobile Team](https://medium.com/airbnb-engineering/building-a-cross-platform-mobile-team-3e1837b40a88)
*   [Part 4: Making a Decision on React Native](https://medium.com/airbnb-engineering/sunsetting-react-native-1868ba28e30a)
*   [_Part 5: What’s Next for Mobile_](https://medium.com/airbnb-engineering/whats-next-for-mobile-at-airbnb-5e71618576ab)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
