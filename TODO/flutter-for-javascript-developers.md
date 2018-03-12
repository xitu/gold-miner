> * 原文地址：[Flutter for JavaScript Developers](https://hackernoon.com/flutter-for-javascript-developers-35515e533317)
> * 原文作者：[Nader Dabit](https://hackernoon.com/@dabit3?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/flutter-for-javascript-developers.md](https://github.com/xitu/gold-miner/blob/master/TODO/flutter-for-javascript-developers.md)
> * 译者：
> * 校对者：

# Flutter for JavaScript Developers

[Flutter](https://flutter.io/) is a cross-platform mobile app SDK for building high-performance, high-fidelity, apps for iOS and Android, from a single codebase.

Also from the [docs](https://flutter.io/technical-overview/):

> Flutter includes a modern **react-style** framework, a 2D rendering engine, ready-made widgets, and development tools.

![](https://cdn-images-1.medium.com/max/800/1*oUyZxsBi_aS6jVhL8sjCsQ.png)

This post will hopefully be a quick and easy intro for most JavaScript developers as I will attempt to draw a parallel between JS and the npm ecosystem, and working with Flutter / Dart and the [Pub](https://pub.dartlang.org/) package repository.

> If you’re interested in staying up to date on Flutter tutorials, libraries, announcements, and updates from the community, I suggest signing up for the bi-weekly [Flutter Newsletter](http://flutternewsletter.com/) that I just announced.

* * *

In my talk [React Native — Cross Platform & Beyond](https://www.youtube.com/watch?v=pFtvv0rJgPw) at [React Native EU](https://react-native.eu/) I discussed and demoed a few different technologies within the React Ecosystem including [React Native Web](https://github.com/necolas/react-native-web), [React Primitives](https://github.com/lelandrichardson/react-primitives), and [ReactXP](https://microsoft.github.io/reactxp/), but I also had the opportunity to discuss [Weex](https://weex.incubator.apache.org/) and [Flutter](https://flutter.io/).

Of all the front-end technologies I have looked at in the past few years, I am most excited about Flutter after experimenting with it. In this post, I will discuss why and also give an intro of how you can get started with it as quickly as possible.

#### If you know me, then I know what you are thinking…

![](https://cdn-images-1.medium.com/max/800/1*GTsgYXSN2AcJZN9wZm7zhQ.jpeg)

I’m a React and React Native developer of over 2.5 years. I’m still extremely bullish on React / React Native and know of pretty massive adoption that is going on right now among many large companies, but I always enjoy seeing other ideas and looking at alternative ways to go about achieving similar goals / objectives, whether it be to learn from them or to shift my current platform.

### Flutter

> My _tldr_ is this: Flutter is amazing and I see it being a viable option in the very near future.

After using the SDK over the past couple of weeks, I’m in the process of building my first app using it, and am really liking the process so far.

Before I go into how to get started with Flutter, I will first go over what my opinions are on the pros and cons of the SDK.

![](https://cdn-images-1.medium.com/max/800/1*hl9BrVAK5rNBJnw76tmTEQ.png)

### Pros:

*   Built in UI libraries (Material, Cupertino) maintained by the core team.
*   Dart & Flutter team work closely together to optimize the Dart VM for mobile specifically for the Flutter needs.
*   Documentation is pristine / awesome / amazing 😍.
*   Nice cli.
*   Smooth and easy for me to get up and running without running into many roadblocks / bugs.
*   Debugging experience is good with hot reloading enabled out of the box plus [an array of debugging techniques well documente](https://flutter.io/debugging/)d.
*   Pretty solid and opinionated navigation library built and maintained by the core team
*   The Dart language is 6 years old and mature. While Dart is a class-based object oriented programming language, if you’re into functional programming, Dart does has first-class functions and supports many functional programming constructs.
*   Dart was easier for me to pick up on than I had anticipated, and I came to really enjoy it.
*   Dart is a typed language out of the box without any additional configuration (re: TypeScript / Flow).
*   Has a similar paradigm of working with state that you may be used to if you have used React (i.e. lifecycle methods and `setState`).

### Cons

*   You’ll need to learn Dart (which is easy, trust me)
*   Still in alpha.
*   Only targets iOS and Android.
*   The plugin ecosystem is young, with only 70+ packages for Flutter in [https://pub.dartlang.org/flutter](https://pub.dartlang.org/flutter) [](https://t.co/KMMwbnVM6M "http://pub.dartlang.org") as of September 2017
*   Layout / styling is a completely new paradigm / API to learn.
*   Different project configuration setup to learn (_pubspec.yaml_ vs _package.json_).

### Getting Started / Other Observations

*   I’m using VS Code as my editor with the [Dart Code extension](https://marketplace.visualstudio.com/items?itemName=DanTup.dart-code) which has let to a really nice development experience. The flutter documentation highly recommends though the [IntelliJ IDE](https://www.jetbrains.com/idea/) which has some built in support for things like hot / live reloading that VSCode doesn’t have to the best of my knowledge.
*   There is a module system / package management system that is much different than that of npm, the [Pub Dart Package Manager](https://pub.dartlang.org/). This could be a good or bad thing depending on your view of npm.
*   I started with no knowledge of Dart and picked it up fairly quickly. It reminds me a lot of TypeScript and also bears some resemblance to JavaScript.
*   There are a few really great CodeLabs and tutorials in the documentation that helped me tremendously, and I recommend checking them out: 1. [Building UIS](https://codelabs.developers.google.com/codelabs/flutter/index.html#0) 2. [Adding Firebase](https://codelabs.developers.google.com/codelabs/flutter-firebase/index.html#0) 3. [Building Layouts](https://flutter.io/tutorials/layout/) 4\. [Adding Interactivity](https://flutter.io/tutorials/interactive/)

#### _Enough talk, let’s get started creating a new project!_

### Installing the CLI (macOS)

_To get started on Windows, check out_ [_these_](https://flutter.io/setup/) _docs._

_To see full macOS setup instructions, check out_ [_these_](https://flutter.io/setup-macos/) _docs._

First, we need to clone the repository that contains the binary for the flutter CLI and add it to our path. I cloned this repo into a folder where I keep my binaries and then added a new path to my `$HOME/.bashrc` / `$HOME/.zshrc` file.

1.  Clone repo:

```
git clone -b alpha https://github.com/flutter/flutter.git
```

2. Add path:

```
export PATH=$HOME/bin/flutter/bin:$PATH (or whatever the path is to your installation)
```

3. Run flutter doctor from your command line to make sure flutter path is being recognized and to see if there are any dependencies you need to install to complete the setup:

```
flutter doctor
```

### Installing other dependencies

If you would like to deploy for iOS, you must have Xcode installed, and for Android you must have Android Studio installed.

_To learn more about installing each platform, see the documentation_ [_here_](https://flutter.io/setup-macos/#platform-setup)_._

### Creating your first Flutter app

Now that we have the flutter CLI installed, we can create our first app. To do so, we need to run the flutter create command:

```
flutter create myapp
```

This will create a new app for you. Now, change into the new directory and open either an iOS simulator or android emulator, and then run the following command:

```
flutter run
```

![](https://cdn-images-1.medium.com/max/800/1*wr4Ox5ZFThwFMdaZL9To6w.jpeg)

This will launch the app in a simulator that you have open. If you have both iOS and Android simulators open, you can pass in the simulator in which you want the app to run in:

```
flutter run -d android / flutter run -d iPhone
```

Or to run in both run

```
flutter run -d all
```

You should get some information about reloading the app printed to your console:

![](https://cdn-images-1.medium.com/max/800/1*gdWuSFptAuk3ljy-AagJ_w.png)

### Project Structure

The code that you are running lives in the `lib/main.dart` file.

You’ll also notice that we have an android folder and an iOS folder where our native projects live.

The configuration for the project lives in the `pubspec.yaml` file, which is similar to a `package.json` file in the JavaScript ecosystem.

Let’s now take a look at `lib/main.dart`.

At the top of the file we see an import:

`import ‘package:flutter/material.dart’;`

Where does this come from? Well, in the `pubspec.yaml` file, you’ll notice under dependencies we have a single flutter dependency, that we are referencing here as `package:flutter/`. If we want to add and import other dependencies, we need to update our `pubspec.yaml` with the new dependencies, making them then available as imports.

In this file, we also see that there is a function at the top called main. In Dart, [main](https://www.dartlang.org/guides/language/language-tour#the-main-function) is the special, _required_, top-level function where app execution starts. Because flutter is built using Dart, this is also our main entry point to the project.

```
void main() {
  runApp(new MyApp());
}
```

This function calls `new MyApp()` which itself calls a class and so on and so forth, similar to a React app where we have a main component that is composed of other components, then rendered in `ReactDOM.render` or `AppRegistry.registerComponent`.

### Widgets

One of the core principles in the [technical overview](https://flutter.io/technical-overview/) of Flutter is that “Everything is a Widget”.

> Widgets are the basic building blocks of every Flutter app. Each widget is an immutable declaration of part of the user interface. Unlike other frameworks that separate views, controllers, layouts, and other properties, Flutter has a consistent, unified object model: the widget.

In terms of web terminology / JavaScript, you can think of a Widget similar to how you may think about a component. The widgets are usually composed inside of classes that may or may not also have some local state and methods within them.

If you look at main.dart, you will see references to classes like _StatelessWidget, StatefulWidget, Center, and Text._These are all considered widgets. For a full list of available Widgets, see [the documentation](https://docs.flutter.io/flutter/widgets/widgets-library.html).

### Layout and Styling

While Dart and most of the Flutter framework has been pretty easy grok, working with Layouts and styling was at first a little harder to wrap my head around.

The main thing to keep in mind is that unlike web styling, and even React Native styling where Views perform all layout and also perform some styling, Layout is determined by a combination of **the type of Widget you choose** and **its layout & styling properties**, which are usually different depending on the type of Widget you are working with.

For example, the [Column](https://docs.flutter.io/flutter/widgets/Column-class.html) takes an array of children and not any styling properties (only layout properties such as [CrossAxisAlignment](https://docs.flutter.io/flutter/widgets/Flex/crossAxisAlignment.html) and [direction](https://docs.flutter.io/flutter/widgets/Flex/direction.html) among others), while [Container](https://docs.flutter.io/flutter/widgets/Container-class.html) takes a combination of layout and styling properties.

There are even layout components such as [Padding](https://docs.flutter.io/flutter/widgets/Padding-class.html) that take a child and do nothing notable other than adding padding to a child component.

There is an entire [catalog of Widgets](https://flutter.io/widgets/layout/) that can help you achieve the type of layout you would like, with components like Container, Row, Column, Center, GridView and many others, all with their own layout specifications.

### SetState / Lifecycle methods

Similar to React, there is the idea of Stateful and Stateless widgets or components. Stateful widgets can create state, update state, and destroy, being somewhat similar to the lifecycle methods you may be used to if you’ve worked with React.

There is even a method called setState which updates the state. You can see this in action in the `_incrementCounter` method in the project we just generated.

See [StatefulWidget](https://docs.flutter.io/flutter/widgets/StatefulWidget-class.html), [State](https://docs.flutter.io/flutter/widgets/State-class.html), and [StatelessWidget](https://docs.flutter.io/flutter/widgets/StatelessWidget-class.html).

### Consensus

As someone who specializes in cross-platform application development, I’ve been keeping my eye out for a competent competitor to React Native that would be a viable option for clients that maybe wanted something different for whatever reason. I think that Flutter answers some of the concerns of some of my clients regarding things like a built in type system, a first class UI library, and also a promising navigation library that is maintained by the core team.

I will be adding Flutter to my toolbelt so when I run into a problem or situation that React Native does not answer I will have something else to fall back on. I will also be presenting it to my clients once I have shipped my first app as another option for them to choose up front, as long as I feel it is production ready.

> _My Name is_ [_Nader Dabit_ ](https://twitter.com/dabit3)_. I am a Developer Advocate at_ [_AWS Mobile_](https://aws.amazon.com/mobile/) _working with projects like_ [_AppSync_](https://aws.amazon.com/appsync/) _and_ [_Amplify_](https://github.com/aws/aws-amplify)_, and the founder of_ [_React Native Training_](http://reactnative.training/)_._

> If you like React and React Native, checkout out our podcast — [React Native Radio](https://devchat.tv/react-native-radio) on [Devchat.tv](http://devchat.tv/).

> Also, check out my book, [React Native in Action](https://www.manning.com/books/react-native-in-action) now available from Manning Publications

> If you enjoyed this article, please recommend and share it! Thanks for your time


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
