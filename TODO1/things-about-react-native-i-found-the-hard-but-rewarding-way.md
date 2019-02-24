> * 原文地址：[Things about React Native I found the hard (but rewarding) way](https://blog.usejournal.com/things-about-react-native-i-found-the-hard-but-rewarding-way-1557a87a0c8)
> * 原文作者：[Christos Sotiriou](https://blog.usejournal.com/@christossotiriou)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/things-about-react-native-i-found-the-hard-but-rewarding-way.md](https://github.com/xitu/gold-miner/blob/master/TODO1/things-about-react-native-i-found-the-hard-but-rewarding-way.md)
> * 译者：
> * 校对者：

# Things about React Native I found the hard (but rewarding) way

## Thoughts on React Native after using it professionally for projects of many scales

![](https://cdn-images-1.medium.com/max/1600/1*TkSZ7PH0c6nqkJ3oFeSmBA.jpeg)

React Native has been around for some time now. I put it to use professionally when Android support was released (approximately one year after iOS). I decided to invest time in it for cross-platform development. When I found out about React Native I was already an iOS developer for 6 years and more than that a Mac OS X developer.

I have developed four medium-sized (10.000–20.000 of lines of code excluding dependencies) projects on the App Store and Play Store for my clients. I also oversaw and contributed in a greater project with more than 50.000 lines of code written in React Native (apart from the native code) that is now being deployed in production and runs smoothly. I have gathered enough experience to find out where React (and React Native) shines, and where it isn’t — and how to scale it.

Note: I know a few of you reading this will point me towards [Flutter](https://flutter.io/). Since it’s maturity is nowhere near its competitors I haven’t been able to look at it thoroughly yet.

**At the time of this writing, the current stable version of React Native is 0.57 with 0.58RC around the corner.**

Here are my thoughts:

### The most advertised feature of React Native is also the least important

The most advertised feature of React Native is that it is cross-platform, but this is not the reason it caught my eye — not by a longshot. The most important feature of React Native **is that it uses React and that way it supports a common declarative layout**. Cross-platform support comes second. As an iOS developer, I have struggled with a less-than intuitive way of designing user interfaces; The Auto Layout system.

If you have a system that is highly dynamic, and elements on the screen depend on each other (like drawers and animations) then Apple’s Autolayout is the best way of managing stuff on the screen. However, for most Android and iOS applications, this is not the case. Most Android and iOS apps are using the standard elements we are used to seeing: Text, Buttons, Lists, Generic Views, and Images laid out in a manner that most resembles the Web.

In the time between the invention of AutoLayout, the [flex box system](https://css-tricks.com/snippets/css/a-guide-to-flexbox/) was invented and used as a de facto standard to put things on the screen. Apart from the standard web use, there are layout systems designed to take advantage of FlexBox principles for Native Development:

*   [Yoga](https://github.com/facebook/yoga) and dependencies on it: [Litho](https://fblitho.com/) for Android (Java / Kotlin)/ [ComponentKit](https://componentkit.org/) for iOS ( Objective C++)
*   [TextureKit](http://texturegroup.org/) (formerly known as AsyncDisplayKit )
*   [LinkedIn’s LayoutKit](https://github.com/linkedin/LayoutKit) (not flex box — but similarities exist)

There are more interface libraries out there — those are just a few of the most widely known. One thing they have in common is that they all use the declarative user interface approach.

#### The case for declarative user interfaces:

Declarative user interfaces for Mobile Development were created to cope with problems that traditional layout systems have. You declare your _intentions_ and the system produces a result based on them.

Few of the challenges of mobile development that are tackled by declarative user interfaces are the following:

**Componentization**. iOS uses ViewControllers inside ViewControllers and views inside views. Android uses Fragments. Both have XML interface declarations, and both allow runtime view instantiation and editing. When it comes to breaking those into smaller ones or reusing them, you are in for a small refactor. In declarative user interfaces, you have this already by default.

**Developer productivity**. Declarative user interfaces take care of component sizing for you. Take a look at this code (React Native example):

```
class TestTextLabel extends React.Component {
  render() {
    return (
      <view>
        <text>This is a small text</text>
        <text>{this}</text>
      </view>
    );
  }
}
```

The above code renders a Component with just two text components inside. notice the `this.props.sampleText` . What will happen if this variable is too long (like – 10000 characters long)? The result will be that the component will resize to fit the entire text. If the text reaches the end of the allowed space (the screen, let’s say), then the view will be clipped and the user will not be able to see the entire text. You need a scroll view for that.

```
class TestTextLabel extends React.Component {
  render() {
    return (
      <ScrollView style={{flex : 1}}>
        <Text>This is a small text</Text>
        <Text>{this}</Text>
      </ScrollView>
    );
  }
}
```

The only thing that changed is the addition of the `<ScrollView>` element. This would require MUCH more work on iOS.

**Collaboration — Git Friendliness**. Every declarative UI I have seen fares better at that.

On iOS and Android, if you have big monolithic UIs, you are doing something wrong. However, big XML files are most of the time unavoidable (note for iOS: XIBs are actually XML files). Changes in them mean nothing to the code reviewer (or you) — pull requests are next to impossible if you don’t agree in prior which version (your changes or the other developer’s) to keep **in its entirety**.

With React and other declarative UI libraries those problems are minimized to a large extent since the layout is actual code — code that you can update, delete, merge, diff and do just about everything you normally do to any other piece of your software.

### The key is understanding what “performance” really is

You will probably need to be a mobile developer to grasp the concepts of performance and manage efficient memory and processor use.

The concept that React Native can be used by Web Developers without knowing a thing about Native only applies for small projects. Once the application starts to grow and the Redux store’s calculations start taking a toll at the performance of your application you will need knowledge of how the Native side works to understand why this happens. You will also need to realize that re-renders caused by your Redux Store in React Native are not quite the same as the re-renders that happen inside a DOM. This applies especially to components coming from the Native side of your app.

At the same time, re-rendering components of your application can get expensive on React Native. Since React Native uses a bridge, any instruction you give inside the `render()` function will travel from JavascriptCore to Java / Objective C++. The native side will take the `render()` instructions given in JSX tags and will translate them into their native counterparts such as Views, Labels and Images. That kind of translation takes a non-negligible cpu time if done hundreds of times per second.

On the performance department, it seems that React Native is one of the better cross-platform solutions out there. However, there are still issues with the performance of React Native in certain key areas.

One such example is large datasets ([and lists](https://github.com/facebook/react-native/issues/16186)). In the case of large lists and grid views, Android and iOS offer an excellent and insanely performant solution — recycling views. Imagine that when using a large list view (iOS / Android), only the cells that are being displayed at any given time are rendered. Other cells are being marked as reusable so that they can be reused when a new cell is about to be displayed. When changing the dataset, the OS will only need to update the displayed cells.

React Native offers VirtualizedList and its derivatives (FlatList and SectionList) for large datasets. However, even this leaves a lot to be desired. There are performance overheads, especially when rendering complex components inside SectionList and try to update a large dataset of 100+ objects. The update mechanism brings a low or mid-end mobile device to a crawl.

To cope with issues such as this, I have switched from Redux to MobX, which offers more predictable updates for my components. Moreover, in the case of large lists, MobX can update specific cells without re-rendering the entire list. Usually this is achievable with Redux too, but you need to override `componentShouldUpdate()`and write some more boilerplate to avoid unnecessary re-renders. Your reducer would also still do some unnecessary work while copying the rest of the variables to your new state.

**Bottom line**: Be careful. The fact that you are using React Native means that squeezing the best possible behavior from your app demands being familiar with both React’s best practices and the Native ones.

### Understanding the JS runtime and how it affects you is important.

Debugging in React Native is possible through a bridge which sends debugging information to Chrome. **That means that the process that runs your actual code in the device is not the same as the one you debug your code on**.

React Native on both Android and iOS uses JavascriptCore for Javascript execution. The debugging tools, however, run on V8 (Chrome). To make the system more fragmented, at the time of this writing React Native uses Apple’s Javascript Core on iOS, and on Android they are using build scripts for JS Core [that are 3 years old](https://github.com/facebook/android-jsc) (since Android didn’t offer any JS runtime out of the box like iOS does Facebook had to build their own). That resulted in lacking JS features like Proxy Objects support on Android and 64 bit support. Therefore, if one wants to use [MobX 5+](https://github.com/mobxjs/mobx/blob/master/CHANGELOG.md#the-system-requirements-to-run-mobx-has-been-upped) he/she is out of luck unless you use an upgraded Javascript Runtime (read on to find out how to do that).

Runtime differences often result in bugs only reproducible on production. Even worse is that there are cases where some things become undebuggable.

For example, the best solution for a mobile database out there when it comes to React Native is Realm. However, when going into debug mode, this happens: [https://github.com/realm/realm-js/issues/491](https://github.com/realm/realm-js/issues/491) . The guys at Realm have already [explained why this is happening](https://github.com/realm/realm-js/issues/491#issuecomment-350718316) — but the bottom line is that the debugging architecture of React Native must be improved if we want to have a more stable debugging solution. Good news is that I have been using [Haul](https://callstack.github.io/haul/) as my bundler which allowed me to debug directly from my iOS device without going through Chrome Dev Tools (unfortunately, you need a Mac, an iOS Simulator, and Safari for that).

Note that the people at Facebook already know this problem, and they are re-designing React Native’s core so that the Native and React Native part can share the same memory. When this is done, debugging will probably be able to be made directly on the JavaScript runtime of the device. ([React Native Fabric (UI-Layer Re-architecture)).](https://github.com/react-native-community/discussions-and-proposals/issues/4)

Not only that, but the React Native community [now provide js android build scripts](https://github.com/react-native-community/jsc-android-buildscripts) which allow building against a newer version of JavascriptCore and embedding it into the React Native app. This brings Android’s React Native Javascript features on par with iOS and also paves the way for the addition of 64 bit support for React Native running on Android.

### In-App Navigation Is Awesome with React Native

Have you ever developed a mobile application with authentication? What happens if the user receives a Push Notification and has to first pass through the Login screen and only after login he will be able to see the push notification content screen? Or, what if you are currently deeply nested inside your application and want to jump into an entirely different area in another app section as a response to a user action?

Problems such as those are solvable in Native with a bit of effort. With [React Navigation](https://reactnavigation.org/) they are not even a problem. Deep linking with associated routes and navigation jumps feel natural and fluid. There are other navigation libraries as well, but React Navigation is being considered as the de facto standard. You should give it a try. This is the one thing that React Native does _way_ better than iOS and Android hands down.

### React Native is not a silver bullet

As with any other technology, you need to understand what it is and what it isn’t before you invest in it. Here is a non-exhaustive list about what RN is good at:

*   Content-driven applications
*   Applications with a Web-like UI.
*   Cross Platform apps that may or may not need a fast Time To Market.

Here is also a non-exhaustive list of things where RN does not fare too good:

*   Apps with Huge Lists
*   Media Driven Applications without the need for a layout (example: simple/small games, animations, video processing), or screen-to-screen transitions.
*   CPU-intensive tasks.

It’s true that for the things that React cannot do you can write everything you need in Native and then call the appropriate code from React Native. But that means that you need to write code once per platform (iOS, Android), and then write extra code for the Javascript Interface.

React Native’s internals are currently undergoing a major refactor so that RN can do more things synchronously, in parallel and so that it can share common code with Native. [https://facebook.github.io/react-native/blog](https://facebook.github.io/react-native/blog/2018/11/01/oss-roadmap)/ — until this is done, you ought to do some research before you decide whether to use it.

### Conclusion

React Native is an insanely well-thought and good platform to develop on. It opens the world of NodeJS to your app, and makes you program in one of the best layout systems out there. It also gives you a very good bridge with the Native side so that you can get the best of both worlds.

It also falls into another strange category, however — the one where you will either need one team to develop your application or three! At some point, you will need some iOS and Android developers to construct components that React Native does not have by default. Once your team starts to grow you will have to decide whether you will make your application 100% Native or not. Therefore whether you choose React Native for your next project becomes a question of how much native code (Java / Kotlin / Swift / ObjC) you will need to have.

My personal advice: If you realize that you need 3 teams to develop three aspects of one application (an iOS team, an Android team, and a React team) then you should probably go for Native iOS and Android all the way and skip React Native. You will save time and money by maintaining only two codebases instead of developing three.

However, if you have a small team of proficient developers and want to build a content application or something similar, then React Native is an excellent choice.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
