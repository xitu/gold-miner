> * 原文地址：[Why You Should Give Flutter Some of Your Attention](https://medium.com/the-andela-way/why-you-should-give-flutter-some-of-your-attention-22dd7e5cae42)
> * 原文作者：[Bruce Bigirwenkya](https://medium.com/@bruce.bigirwenkya?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/why-you-should-give-flutter-some-of-your-attention.md](https://github.com/xitu/gold-miner/blob/master/TODO1/why-you-should-give-flutter-some-of-your-attention.md)
> * 译者：
> * 校对者：

# Why You Should Give Flutter Some of Your Attention

![](https://cdn-images-1.medium.com/max/1000/1*ksS2oqmcv5ol9nCaMkraIw.jpeg)

A new take on Hybrid Mobile Application Development

### What is Flutter?

Flutter is a mobile app SDK for crafting high-quality native interfaces on iOS and Android in record time. It is developed by Google and is fully open source.

Flutter just reached [Release Preview 1](https://medium.com/flutter-io/flutter-release-preview-1-943a9b6ee65a)

### Why Flutter?

Understanding why Flutter involves understanding who it is intended for, as well as the history of development in the various user domains.

#### Who is Flutter for

*   Developers looking to build highly-performant User Interfaces.
*   Web Application Developers looking to get into the mobile application development space without the overhead of learning various Native Platform Languages.
*   Companies looking to reach more users with a single investment.
*   Designers looking to have their app designs delivered consistently with their vision.

#### History

Native Application development has always had distinct differences from Cross Platform Development providing various advantages and disadvantages.

The appeal for Cross Platform application is very profound. It is nonetheless an ever changing scene growing to eventually fill the shoes of the native application development space. Mobile development, as it is in general, is also relatively young (less than a decade old)

[This article](https://hackernoon.com/whats-revolutionary-about-flutter-946915b09514) goes into great detail to explain the history of the view technologies used in mobile development.

The first cross platform frameworks used Web technologies and rendered to Web Views

Before Apple released their iOS SDK, they encouraged third party developers to build web-apps for the iPhone, so building cross-platform apps using web technologies was an obvious step.

[Reactive Programming](https://gist.github.com/staltz/868e7e9bc2a7b8c1f754) is a programming paradigm that emphasises asynchronous data flow with streams of data from events. It has become increasingly employed in User Interface development with respect to animation and other rendering requirements.

Reactive web frameworks like ReactJS use reactive programming techniques to simplify the creation of web views.

Technologies categorisation according to Compilation mechanisms and View Types

![](https://cdn-images-1.medium.com/max/800/1*pxh6w9ALI-bAYHg33zZQ2g.png)

#### The Bridge

Traditionally, building cross platform apps has faced performance hits because of working across different realms. The application is developed with JavaScript but its UI is completely native. Variables in one realm can’t be accessed by another realm. All interaction of variables and data across the different realms must be done over a “bridge”.

For example: Debugging React Native apps in chrome means the application is running in two different realms (Desktop and Mobile). These realms are bridged over a WebSocket.

Optimisations in React Native try to keep the passes across the Bridge during the application runtime to the bare minimum. Ultimately, each of the different environments can be fast but the delay arises in exchanges across the Bridge.

Flutter counters this problem with its reliance on Dart which is AOT-compiled. This means there is no need for the application to use a bridge during runtime because the application is compiled to native code.

#### Widgets

A widget is an element that controls and affects the View and Interface to an app. Everything that you build in Flutter is a widget. This makes it much more self contained, reusable and extensible.

#### Layouts

Traditional Layouts rely on multiple rules typically defined in separate CSS files. These rules are applied to markup, thereby creating potential for multiple interactions and contradictions on the rules being applied. CSS3 has about 375 rules. Aside from the possible contradictions in the rules, the layout performance is typically of order N-squared.

Flutter redesigns the Layout to be more performant and also fairly more intuitive. Layout information is specified by the widget individually as it gets modelled. This not only makes it easier for a developer looking at the code to understand what is going on, it also means the widget does not have the overhead of processing through rules that may not apply to it.

The flutter team provides some layout widgets that they feel are to be used. Flutter also has a lot of optimisations around these layouts like caching to enable it render layouts only when necessary as well as render a high volume of widgets.

#### Dart

Dart is used by the Flutter team for several reasons:

*   _AOT_  
    Dart is Ahead-Of-Time compiled. The Dart VM supports building of native ARM code for the platforms you are developing for. The implication is that the applications are much faster in comparison to those which use Just-In-Time compilers, which compile on-the-fly at program execution.
*   _JIT  
    _Dart also offers Just In Time compilation. Flutter leverages this ability in development to make for faster development cycles. Features like Hot Reload are made possible because the application can easily compile the updates, making it easier to test and iterate over a product.
*   _Strongly typed  
    _Dart is [strongly typed](https://en.wikipedia.org/wiki/Strong_and_weak_typing). If you have used Java and C#, transitioning to Dart can be ideal for several reasons, one of which is, given the familiarity and type safety that Dart offers, you don’t have to sacrifice on your programmatic completeness.
*   _Server-side Curiosity  
    _Dart is a great fit for a lot of things, including running on the server. Server side Dart is a growing interest for many and It makes for a great case to use it in Flutter considering the possibility of a unified codebase

You can find out more about Dart for Flutter [here.](https://hackernoon.com/why-flutter-uses-dart-dd635a054ebf)

#### Structure of Flutter

![](https://cdn-images-1.medium.com/max/800/1*okW6pQoMLLmlAhPnGL95PA.png)

The Structure of a Flutter Application

#### Potential use in Fuchsia

Use in Fuchsia. [Fuchsia](https://fuchsia.googlesource.com/) is a new [open source](https://fuchsia.googlesource.com/) operating system currently being developed by Google that is also garnering some attention in tech enthusiast spaces. Unlike Android and other popular operating systems, It is based on a new microkernel called “Zircon”. Flutter has already been used with Armadillo to test development of [user interfaces for Fuchsia.](https://9to5google.com/2018/03/02/fuchsia-friday-first-fuchsia-app/)

#### Current Shortcomings

The observed shortcomings are based on other developer experiences in the past. This section only serves to highlight where the Flutter project has been and what it is solving for. A testament to the development velocity of the Flutter team.

You can review this article to review the challenges a native mobile developer faced when test driving Flutter. Some of the issues they highlight are very much in contention on my part, like the lack of OpenGL support, granted Flutter uses Skia, which supports OpenGL as one of its backends.

Other possible challenges you might face right now as a result of Flutter being in very early stages include:

*   Low level implementation of animations. This has created challenges in the past for some people with a need to go a bit low level to achieve the desired animations.
*   Data manipulation libraries still short. Flutter has focused on Visual Rendering initially. If you are someone with a strong reliance on ready-made community modules and widgets for your implementation, you might struggle with the scarce data manipulation libraries. I personally feel, however, that this field is maturing steadily, with Flutter offering more recommendations regarding architecting your application and paving way for people building libraries to align their products with the best conventions.

#### Getting Started with Flutter

Head over to [Flutter.io](http://flutter.io/) to find out how to get started with Flutter. You can also review the content in the Resources section at the bottom.

In a nutshell, Getting started with Flutter will involve downloading the SDK and configuring your path to use it. Installing the necessary plugins in the editors you use is a necessary next step.

* * *

You might run into a [missing dependency issue](https://github.com/flutter/flutter/issues/16428) on Mac OS which you can fix by running **pip install six**

The other issue you might run into is a merge conflict when you try to run flutter upgrade. This currently happens if you have been testing out the Flutter examples bundled with the SDK. In this case, what worked for me was to cd into the Flutter SDK folder and stashing the changed files (git add . | git stash) before running the Flutter upgrade command.

#### Some Resources

*   Rohan Taneja provides a fairly comprehensive set of links to valuable resources in this [article](https://medium.freecodecamp.org/learn-flutter-best-resources-18f88346ed0f).
*   [Fluttery](https://medium.com/fluttery) is a collection of tutorials, challenges and patterns for anyone looking to get started with Flutter.
*   [Flutter studio](https://flutterstudio.app/) is also a good resource for anyone looking to simplify their development process.

_I’m excited to try it. Let me know if you are!_  
❤️🚀

* * *

Need to hire developers? [Let Andela help you with that](http://hire.andela.com/need-more-devs).

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
